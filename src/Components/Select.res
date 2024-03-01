@react.component
let make = (~label, ~className="", ~options, ~onChange, ~value="__none") => {
  <div
    className={`rounded-md px-3 pb-1.5 pt-2.5 shadow-sm ring-1 ring-inset ring-gray-300 focus-within:ring-2 focus-within:ring-indigo-600 ${className}`}>
    <label htmlFor={label} className="block text-xs font-medium text-gray-900">
      {label->React.string}
    </label>
    <select
      name="select"
      className="relative cursor-default rounded-md bg-white py-1.5 pl-3 pr-10 text-left text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 focus:outline-none sm:text-sm sm:leading-6"
      onChange={ev => {
        let value = (ev->ReactEvent.Form.target)["value"]->JSON.Decode.string->Belt.Option.getExn

        value !== "__none" ? onChange(value) : ()
      }}
      value>
      <option key="__none" value="__none"> {"Select a font"->React.string} </option>
      {React.array(
        options->Array.map(((key, value)) => {
          <option key value=key> {value->React.string} </option>
        }),
      )}
    </select>
  </div>
}
