let useDebounced = (~wait=?, fn) => {
  let ref = fn->Debounce.make(~wait?)->React.useRef
  ref.current
}
