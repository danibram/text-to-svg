module Input = {
  @react.component
  let make = (~label, ~value, ~onChange) => {
    <div className="p-6">
      <label>
        {label->React.string}
        <input
          type_="text"
          value
          onChange={ev => {
            let value =
              (ev->ReactEvent.Form.target)["value"]->JSON.Decode.string->Belt.Option.getExn
            onChange(value)
          }}
        />
      </label>
    </div>
  }
}

module Select = {
  @react.component
  let make = (~options, ~onChange) => {
    <div className="p-6">
      <select
        name="select"
        onChange={ev => {
          let value = (ev->ReactEvent.Form.target)["value"]->JSON.Decode.string->Belt.Option.getExn
          onChange(value)
        }}>
        {React.array(
          options->Array.map(((key, value)) => {
            <option value=key> {value->React.string} </option>
          }),
        )}
      </select>
    </div>
  }
}

module FontSelector = {
  let notificationMethods = [
    ("customFile", "Upload font file"),
    ("googleFont", "Google font"),
    ("url", "Url"),
  ]
  @react.component
  let make = (~onSelectFont) => {
    let (fonts, setFonts) = React.useState(() => None)
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

    <>
      <div className="border-b border-gray-200 bg-white px-4 py-5 sm:px-6">
        <label className="text-base font-semibold text-gray-900">
          {"Font source"->React.string}
        </label>
        <p className="text-sm text-gray-500"> {"How you wanna select the font"->React.string} </p>
        <fieldset className="mt-4">
          <legend className="sr-only"> {"Font source"->React.string} </legend>
          <div className="space-y-4 sm:flex sm:items-center sm:space-x-10 sm:space-y-0">
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
        </fieldset>
        {method == #googleFont
          ? switch (fonts, loading) {
            | (None, true) => <div> {"Loading..."->React.string} </div>
            | (None, false) => <div> {"Error loading..."->React.string} </div>
            | (Some(fonts), _) =>
              <div>
                <Select
                  options={fonts->Belt.Map.String.toArray->Array.map(((k, _)) => (k, k))}
                  onChange={value => setFirstFontVariant(value)}
                />
              </div>
            }
          : React.null}
      </div>
    </>
  }
}

@react.component
let make = () => {
  let (fontUrl, setFontUrl) = React.useState(() => None)
  let (text, setText) = React.useState(() =>
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
  )
  let (size, setSize) = React.useState(() => 90)
  let (svg, setSvg) = React.useState(() => None)

  React.useEffect3(() => {
    fontUrl->Option.forEach(fontUrl =>
      fontUrl
      ->Opentype.Font.load
      ->Promise.then(
        fontResult => {
          switch fontResult {
          | Ok(font) => {
              let svg =
                text
                ->Lib.composeModel(~font, ~fontSize=size)
                ->MakerJS.TextModel.toSVG(MakerJS.Options.make())

              setSvg(_ => Some(svg))
              Promise.resolve()
            }
          | Error(err) =>
            Console.error(err->Opentype.Font.Error.toString)
            Promise.resolve()
          }
        },
      )
      ->ignore
    )

    None
  }, (fontUrl, text, size))

  <div className="bg-gray-100">
    <div className="mx-auto max-w-7xl py-6 sm:px-6 lg:px-8">
      <div className="mx-auto max-w-none">
        <div className="overflow-hidden bg-white sm:rounded-lg sm:shadow">
          <div className="border-b border-gray-200 bg-white px-4 py-5 sm:px-6">
            <h3 className="text-base font-semibold leading-6 text-gray-900">
              {"Text to svg"->React.string}
            </h3>
          </div>
          <FontSelector onSelectFont={(font: string) => setFontUrl(_ => Some(font))} />
          <div className="border-b border-gray-200 bg-white px-4 py-5 sm:px-6">
            <Input label="Text" value={text} onChange={value => setText(_ => value)} />
            <Input
              label="Size"
              value={size->Int.toString}
              onChange={value => setSize(_ => value->Int.fromString->Option.getExn)}
            />
          </div>
          <div className="border-b border-gray-200 bg-white px-4 py-5 sm:px-6">
            {switch svg {
            | None => <div> {"No SVG"->React.string} </div>
            | Some(svg) =>
              <div className="bg-white p-6 w-fit" dangerouslySetInnerHTML={"__html": svg} />
            }}
          </div>
        </div>
      </div>
    </div>
  </div>
}
