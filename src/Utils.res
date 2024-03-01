let useDebounced = (~wait=?, fn) => {
  let ref = fn->Debounce.make(~wait?)->React.useRef
  ref.current
}

let download = (svgString, name) => {
  open! Webapi.Dom

  let body =
    document
    ->Document.getElementsByTagName("body")
    ->HtmlCollection.toArray
    ->Array.get(0)
  let element = document->Document.createElement("a")
  element->Element.setAttribute(
    "href",
    "data:image/svg+xml;charset=utf-8," ++ svgString->encodeURIComponent,
  )
  element->Element.setAttribute(
    "download",
    Js.Date.make()->Js.Date.toISOString ++ ("_" ++ (name ++ ".svg")),
  )
  body->Option.forEach(Element.appendChild(~child=element, _))

  let _ = element->Element.asHtmlElement->Belt.Option.map(HtmlElement.click)
}

let stringSanitize = str =>
  str
  ->Js.String2.normalizeByForm("NFD")
  ->Js.String2.replaceByRe(%re("/[\u0300-\u036f]/g"), "")
  ->Js.String2.toLocaleLowerCase
  ->Js.String2.trim
  ->Js.String2.replaceByRe(%re("/[^a-z0-9 -]/g"), "")
  ->Js.String2.replaceByRe(%re("/\s+/g"), "-")
  ->Js.String2.replaceByRe(%re("/--+/g"), "-")
