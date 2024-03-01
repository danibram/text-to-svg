// Generated by ReScript, PLEASE EDIT WITH CARE

import * as JsxRuntime from "react/jsx-runtime";

function Button(props) {
  var __disabled = props.disabled;
  var disabled = __disabled !== undefined ? __disabled : false;
  return JsxRuntime.jsx("button", {
              children: props.label,
              className: "rounded-md bg-indigo-500 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500 disabled:cursor-not-allowed disabled:opacity-50",
              disabled: disabled,
              type: "button",
              onClick: props.onClick
            });
}

var make = Button;

export {
  make ,
}
/* react/jsx-runtime Not a pure module */