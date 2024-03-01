type t = {
  text: string,
  fontSize: int,
  canvasWidth: int,
  letterSpacing: int,
  lineHeight: float,
  align: Opentype.Layout.Options.align,
  fill: string,
  stroke: string,
  strokeWidth: float,
  fillRule: MakerJS.Options.fillRule,
}

@react.component
let make = (~options, ~onChange) => {
  <>
    <div className="flex">
      <Input
        label="Text"
        className="w-full"
        value={options.text}
        onChange={value => {
          onChange({...options, text: value->Input.getText})
        }}
      />
      <Input
        type_="number"
        label="Size"
        value={options.fontSize->Int.toString}
        onChange={value => {
          onChange({
            ...options,
            fontSize: value->Input.getInt,
          })
        }}
      />
      <Input
        type_="number"
        label="CanvasWidth"
        value={options.canvasWidth->Int.toString}
        onChange={value => {
          onChange({
            ...options,
            canvasWidth: value->Input.getInt,
          })
        }}
      />
      <Input
        type_="number"
        label="LetterSpacing"
        value={options.letterSpacing->Int.toString}
        onChange={value => {
          onChange({
            ...options,
            letterSpacing: value->Input.getInt,
          })
        }}
      />
      <Input
        type_="number"
        label="LineHeight"
        value={options.lineHeight->Float.toString}
        onChange={value => {
          onChange({
            ...options,
            lineHeight: value->Input.getFloat,
          })
        }}
      />
    </div>
    <div className="flex">
      <Input
        label="Fill"
        value={options.fill}
        onChange={value => {
          onChange({
            ...options,
            fill: value->Input.getText,
          })
        }}
      />
      <Input
        label="Stroke"
        value={options.stroke}
        onChange={value => {
          onChange({
            ...options,
            stroke: value->Input.getText,
          })
        }}
      />
      <Input
        type_="number"
        label="Stroke width"
        value={options.strokeWidth->Float.toString}
        onChange={value => {
          onChange({
            ...options,
            strokeWidth: value->Input.getFloat,
          })
        }}
      />
      <Select
        label="Fill Rule"
        options=[("evenodd", "Even odd"), ("nonzero", "Non zero")]
        value={switch options.fillRule {
        | #evenodd => "evenodd"
        | #nonzero => "nonzero"
        }}
        onChange={value => {
          onChange({
            ...options,
            fillRule: switch value {
            | "evenodd" => #evenodd
            | "nonzero" => #nonzero
            | _ => #evenodd
            },
          })
        }}
      />
      <Select
        label="Align"
        options=[("left", "Left"), ("center", "Center"), ("right", "Right")]
        value={switch options.align {
        | #left => "left"
        | #center => "center"
        | #right => "right"
        }}
        onChange={value => {
          onChange({
            ...options,
            align: switch value {
            | "left" => #left
            | "center" => #center
            | "right" => #right
            | _ => #left
            },
          })
        }}
      />
    </div>
  </>
}
