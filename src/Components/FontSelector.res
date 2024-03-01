let notificationMethods = [
  ("customFile", "Upload font file"),
  ("googleFont", "Google font"),
  ("url", "Url"),
]
@react.component
let make = (~onSelectFont) => {
  let (fontUrl, setFontUrl) = React.useState(() => None)
  let (err, setErr) = React.useState(() => None)
  let (fonts, setFonts) = React.useState(() => None)
  let (fontSelected, setFontSelected) = React.useState(() => None)
  let (loading, setLoading) = React.useState(() => true)
  let (method, setMethod) = React.useState(() => #googleFont)

  let loadGoogleFonts = async () => {
    setLoading(_ => true)
    let fonts = await GoogleFont.load()
    setFonts(_ => fonts)
    setLoading(_ => false)
  }

  let setFirstFontVariant = fontSelected => {
    fonts
    ->Option.flatMap(Belt.Map.String.get(_, fontSelected))
    ->Belt.Option.flatMap(font =>
      font.files
      ->Belt.Map.String.keysToArray
      ->Array.get(0)
      ->Option.flatMap(Belt.Map.String.get(font.files, _))
    )
    ->Option.forEach(file => onSelectFont(file))
  }

  React.useEffect0(() => {
    loadGoogleFonts()->ignore
    None
  })

  let handleChangeFontUrl = (value, errorMsg) => {
    setErr(_ => None)
    let re = %re(
      "/^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:\/?#[\]@!\$&'\(\)\*\+,;=.]+.(ttf)$/g"
    )
    Re.test(re, value) ? onSelectFont(value) : setErr(_ => Some(errorMsg))
  }

  <>
    <div className="border-b border-gray-200 bg-white px-4 py-5 sm:px-6">
      <label className="text-base font-semibold text-gray-900">
        {"Font source"->React.string}
      </label>
      <p className="text-sm text-gray-500"> {"How you wanna select the font"->React.string} </p>
      <fieldset className="mt-4 flex gap-4 items-center w-full">
        <legend className="sr-only"> {"Font source"->React.string} </legend>
        <div className="space-y-4 sm:flex sm:items-center sm:space-x-10 sm:space-y-0 w-full">
          {notificationMethods
          ->Array.map(((id, title)) =>
            <div key={id} className="flex items-center">
              <input
                id={id}
                name="notification-method"
                type_="radio"
                defaultChecked={id === "googleFont"}
                className="h-4 w-4 border-gray-300 text-indigo-600 focus:ring-indigo-600"
                onClick={_ => {
                  if id == "googleFont" {
                    setMethod(_ => #googleFont)
                    loadGoogleFonts()->ignore
                  }
                  if id == "customFile" {
                    setMethod(_ => #customFile)
                  }
                  if id == "url" {
                    setMethod(_ => #url)
                  }
                }}
              />
              <label
                htmlFor={id} className="ml-3 block text-sm font-medium leading-6 text-gray-900">
                {title->React.string}
              </label>
            </div>
          )
          ->React.array}
        </div>
        <div className="text-sm w-full">
          {method == #googleFont
            ? switch (fonts, loading) {
              | (None, true) => <div> {"Loading..."->React.string} </div>
              | (None, false) => <div> {"Error loading..."->React.string} </div>
              | (Some(fonts), _) =>
                <Select
                  label="Google font"
                  options={fonts->Belt.Map.String.toArray->Array.map(((k, _)) => (k, k))}
                  onChange={value => {
                    setFirstFontVariant(value)
                    setFontSelected(_ => Some(value))
                  }}
                  value={fontSelected->Option.getOr("__none")}
                />
              }
            : React.null}
          {method == #url
            ? <>
                <Input
                  className="w-full"
                  label="Url"
                  value={fontUrl->Option.getOr("")}
                  onChange={value => {
                    let value = value->Input.getText
                    setFontUrl(_ => Some(value))
                    handleChangeFontUrl(value, "Invalid url")
                  }}
                />
                {switch err {
                | Some(err) => <p className="text-sm text-red-500"> {err->React.string} </p>
                | None => React.null
                }}
              </>
            : React.null}
          {method == #customFile
            ? <Input
                type_="file"
                className="w-full"
                label="Upload file"
                onChange={value => {
                  value
                  ->Input.getFile
                  ->Option.forEach(file =>
                    file->FilerReader.fileToDataUrl(url => onSelectFont(url))
                  )
                }}
              />
            : React.null}
        </div>
      </fieldset>
    </div>
  </>
}
