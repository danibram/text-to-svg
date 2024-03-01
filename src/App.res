open OptionsForm
@react.component
let make = () => {
  let (fontUrl, setFontUrl) = React.useState(() => None)
  let (svg, setSvg) = React.useState(() => None)
  let (options, setOptions) = React.useState(_ => {
    text: "This is the way",
    fontSize: 72,
    letterSpacing: 0,
    lineHeight: 1.5,
    align: #left,
    canvasWidth: 200,
    fill: "black",
    stroke: "black",
    strokeWidth: 0.25,
    fillRule: #evenodd,
  })

  let update = ((
    fontUrl,
    {text, fontSize, letterSpacing, lineHeight, align, canvasWidth, fill, stroke},
  )) =>
    fontUrl->Option.forEach(fontUrl =>
      fontUrl
      ->Opentype.Font.load
      ->Promise.then(fontResult => {
        switch fontResult {
        | Ok(font) => {
            let svg =
              text
              ->Lib.composeModel(
                ~font,
                ~fontSize,
                ~letterSpacing,
                ~lineHeight,
                ~align,
                ~canvasWidth,
              )
              ->MakerJS.TextModel.toSVG(MakerJS.Options.make(~fill, ~stroke))

            setSvg(_ => Some(svg))
            Promise.resolve()
          }
        | Error(err) =>
          Console.error(err->Opentype.Font.Error.toString)
          Promise.resolve()
        }
      })
      ->ignore
    )

  let updateDebounced = update->Utils.useDebounced(~wait=500)

  let optionsUpdate = React.useCallback1(options => {
    setOptions(_ => options)
    updateDebounced((fontUrl, options))
  }, [fontUrl])

  let fontUpdate = React.useCallback1(fontUrl => {
    setFontUrl(_ => Some(fontUrl))
    updateDebounced((Some(fontUrl), options))
  }, [options])

  <div className="bg-gray-100">
    <div className="mx-auto max-w-7xl py-6 sm:px-6 lg:px-8">
      <div className="mx-auto max-w-none">
        <div className="overflow-hidden bg-white sm:rounded-lg sm:shadow">
          <div className="border-b border-gray-200 bg-white px-4 py-5 sm:px-6">
            <h3 className="text-base font-semibold leading-6 text-gray-900">
              {"Text to svg"->React.string}
            </h3>
          </div>
          <FontSelector onSelectFont={fontUpdate} />
          <div className="border-b border-gray-200 bg-white px-4 py-5 sm:px-6 flex flex-col gap-4">
            <OptionsForm options onChange={optionsUpdate} />
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
