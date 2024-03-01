let getText = ev => (ev->ReactEvent.Form.target)["value"]
let getFloat = ev => (ev->ReactEvent.Form.target)["value"]->Float.fromString->Option.getOr(0.)
let getInt = ev => (ev->ReactEvent.Form.target)["value"]->Int.fromString->Option.getOr(0)

let getFile = ev => {
  (ev->ReactEvent.Form.target)["files"]->Belt.Array.get(0)
}

let fileAsDataURL = (file, cb) => {
  FilerReader.fileToDataUrl(file, cb)
}

@react.component
let make = (~type_="text", ~label, ~value="", ~onChange, ~className="") => {
  <div
    className={`rounded-md px-3 pb-1.5 pt-2.5 shadow-sm ring-1 ring-inset ring-gray-300 focus-within:ring-2 focus-within:ring-indigo-600 ${className}`}>
    <label htmlFor={label} className="block text-xs font-medium text-gray-900">
      {label->React.string}
    </label>
    <input
      type_
      name={label}
      id={label}
      className="block w-full border-0 p-0 text-gray-900 placeholder:text-gray-400 focus:ring-0 sm:text-sm sm:leading-6 focus:outline-0"
      value={value}
      onChange={ev => onChange(ev)}
    />
  </div>
}
