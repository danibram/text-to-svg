// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Debounce from "rescript-debounce/src/Debounce.res.mjs";

function useDebounced(wait, fn) {
  return React.useRef(Debounce.make(wait, fn)).current;
}

export {
  useDebounced ,
}
/* react Not a pure module */