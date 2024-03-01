@react.component
let make = (~label, ~onClick, ~disabled=false) =>
  <button
    type_="button"
    className="rounded-md bg-indigo-500 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500 disabled:cursor-not-allowed disabled:opacity-50"
    disabled
    onClick>
    {label->React.string}
  </button>
