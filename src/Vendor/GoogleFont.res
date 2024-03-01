module Fetch = {
  module Response = {
    type t
    @send external json: t => promise<Js.Json.t> = "json"
  }

  @val external fetch: string => promise<Response.t> = "fetch"
}

module Font = {
  type t = {
    family: string,
    files: Belt.Map.String.t<string>,
  }

  let make = (~family, ~files): t => {family, files}
}

let decodeFonts = (json: Js.Json.t): option<Belt.Map.String.t<Font.t>> => {
  json
  ->JSON.Decode.object
  ->Option.flatMap(Js.Dict.get(_, "items"))
  ->Option.flatMap(items => items->JSON.Decode.array)
  ->Option.map(fonts => {
    fonts->Array.reduce(Belt.Map.String.empty, (acc, font) => {
      switch font
      ->JSON.Decode.object
      ->Option.flatMap(
        font => {
          let family = font->Js.Dict.get("family")->Option.flatMap(JSON.Decode.string)
          let files =
            Js.Dict.get(font, "files")
            ->Option.flatMap(JSON.Decode.object)
            ->Option.flatMap(
              files => Some(
                files
                ->Dict.keysToArray
                ->Array.reduce(
                  Belt.Map.String.empty,
                  (acc, key) =>
                    switch files->Js.Dict.get(key)->Option.flatMap(JSON.Decode.string) {
                    | None => acc
                    | Some(value) => acc->Belt.Map.String.set(key, value)
                    },
                ),
              ),
            )

          switch (family, files) {
          | (Some(family), Some(files)) => Some(Font.make(~family, ~files))
          | _ => None
          }
        },
      ) {
      | None => acc
      | Some(font) => acc->Belt.Map.String.set(font.family, font)
      }
    })
  })
}

let load = async () => {
  let url = `https://www.googleapis.com/webfonts/v1/webfonts?key=${Env.googleApiKey}`
  let response = await Fetch.fetch(url)
  let json = await Fetch.Response.json(response)

  json->decodeFonts
}
