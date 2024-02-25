// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Lib from "./Lib.res.mjs";
import * as React from "react";
import * as MakerJS from "./Vendor/MakerJS.res.mjs";
import * as Makerjs from "makerjs";
import * as Opentype from "./Vendor/Opentype.res.mjs";
import * as Core__Int from "@rescript/core/src/Core__Int.res.mjs";
import * as Core__JSON from "@rescript/core/src/Core__JSON.res.mjs";
import * as GoogleFont from "./Vendor/GoogleFont.res.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core__Option from "@rescript/core/src/Core__Option.res.mjs";
import * as Belt_MapString from "rescript/lib/es6/belt_MapString.js";
import * as JsxRuntime from "react/jsx-runtime";

function App$Input(props) {
  var onChange = props.onChange;
  return JsxRuntime.jsx("div", {
              children: JsxRuntime.jsxs("label", {
                    children: [
                      props.label,
                      JsxRuntime.jsx("input", {
                            type: "text",
                            value: props.value,
                            onChange: (function (ev) {
                                var value = Belt_Option.getExn(Core__JSON.Decode.string(ev.target.value));
                                onChange(value);
                              })
                          })
                    ]
                  }),
              className: "p-6"
            });
}

function App$Select(props) {
  var onChange = props.onChange;
  return JsxRuntime.jsx("div", {
              children: JsxRuntime.jsx("select", {
                    children: props.options.map(function (param) {
                          return JsxRuntime.jsx("option", {
                                      children: param[1],
                                      value: param[0]
                                    });
                        }),
                    name: "select",
                    onChange: (function (ev) {
                        var value = Belt_Option.getExn(Core__JSON.Decode.string(ev.target.value));
                        onChange(value);
                      })
                  }),
              className: "p-6"
            });
}

var notificationMethods = [
  [
    "customFile",
    "Upload font file"
  ],
  [
    "googleFont",
    "Google font"
  ],
  [
    "url",
    "Url"
  ]
];

function App$FontSelector(props) {
  var onSelectFont = props.onSelectFont;
  var match = React.useState(function () {
        
      });
  var setFonts = match[1];
  var fonts = match[0];
  var match$1 = React.useState(function () {
        return true;
      });
  var setLoading = match$1[1];
  var match$2 = React.useState(function () {
        return "googleFont";
      });
  var setMethod = match$2[1];
  var loadGoogleFonts = async function () {
    setLoading(function (param) {
          return true;
        });
    var fonts = await GoogleFont.load();
    setFonts(function (param) {
          return fonts;
        });
    return setLoading(function (param) {
                return false;
              });
  };
  return JsxRuntime.jsx(JsxRuntime.Fragment, {
              children: Caml_option.some(JsxRuntime.jsxs("div", {
                        children: [
                          JsxRuntime.jsx("label", {
                                children: "Font source",
                                className: "text-base font-semibold text-gray-900"
                              }),
                          JsxRuntime.jsx("p", {
                                children: "How you wanna select the font",
                                className: "text-sm text-gray-500"
                              }),
                          JsxRuntime.jsxs("fieldset", {
                                children: [
                                  JsxRuntime.jsx("legend", {
                                        children: "Font source",
                                        className: "sr-only"
                                      }),
                                  JsxRuntime.jsx("div", {
                                        children: notificationMethods.map(function (param) {
                                              var id = param[0];
                                              return JsxRuntime.jsxs("div", {
                                                          children: [
                                                            JsxRuntime.jsx("input", {
                                                                  defaultChecked: id === "googleFont",
                                                                  className: "h-4 w-4 border-gray-300 text-indigo-600 focus:ring-indigo-600",
                                                                  id: id,
                                                                  name: "notification-method",
                                                                  type: "radio",
                                                                  onClick: (function (param) {
                                                                      if (id === "googleFont") {
                                                                        setMethod(function (param) {
                                                                              return "googleFont";
                                                                            });
                                                                        loadGoogleFonts();
                                                                      }
                                                                      if (id === "customFile") {
                                                                        setMethod(function (param) {
                                                                              return "customFile";
                                                                            });
                                                                      }
                                                                      if (id === "url") {
                                                                        return setMethod(function (param) {
                                                                                    return "url";
                                                                                  });
                                                                      }
                                                                      
                                                                    })
                                                                }),
                                                            JsxRuntime.jsx("label", {
                                                                  children: param[1],
                                                                  className: "ml-3 block text-sm font-medium leading-6 text-gray-900",
                                                                  htmlFor: id
                                                                })
                                                          ],
                                                          className: "flex items-center"
                                                        }, id);
                                            }),
                                        className: "space-y-4 sm:flex sm:items-center sm:space-x-10 sm:space-y-0"
                                      })
                                ],
                                className: "mt-4"
                              }),
                          match$2[0] === "googleFont" ? (
                              fonts !== undefined ? JsxRuntime.jsx("div", {
                                      children: JsxRuntime.jsx(App$Select, {
                                            options: Belt_MapString.toArray(Caml_option.valFromOption(fonts)).map(function (param) {
                                                  var k = param[0];
                                                  return [
                                                          k,
                                                          k
                                                        ];
                                                }),
                                            onChange: (function (value) {
                                                Core__Option.forEach(Belt_Option.flatMap(Core__Option.flatMap(fonts, (function (__x) {
                                                                return Belt_MapString.get(__x, value);
                                                              })), (function (font) {
                                                            return Core__Option.flatMap(Belt_MapString.keysToArray(font.files)[0], (function (__x) {
                                                                          return Belt_MapString.get(font.files, __x);
                                                                        }));
                                                          })), (function (file) {
                                                        onSelectFont(file);
                                                      }));
                                              })
                                          })
                                    }) : (
                                  match$1[0] ? JsxRuntime.jsx("div", {
                                          children: "Loading..."
                                        }) : JsxRuntime.jsx("div", {
                                          children: "Error loading..."
                                        })
                                )
                            ) : null
                        ],
                        className: "border-b border-gray-200 bg-white px-4 py-5 sm:px-6"
                      }))
            });
}

function App(props) {
  var match = React.useState(function () {
        
      });
  var setFontUrl = match[1];
  var fontUrl = match[0];
  var match$1 = React.useState(function () {
        return "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
      });
  var setText = match$1[1];
  var text = match$1[0];
  var match$2 = React.useState(function () {
        return 90;
      });
  var setSize = match$2[1];
  var size = match$2[0];
  var match$3 = React.useState(function () {
        
      });
  var setSvg = match$3[1];
  var svg = match$3[0];
  React.useEffect((function () {
          Core__Option.forEach(fontUrl, (function (fontUrl) {
                  Opentype.Font.load(fontUrl).then(function (fontResult) {
                        if (fontResult.TAG === "Ok") {
                          var svg = Makerjs.exporter.toSVG(Lib.composeModel(text, undefined, fontResult._0, size, undefined, undefined, undefined), MakerJS.Options.make(undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined));
                          setSvg(function (param) {
                                return svg;
                              });
                          return Promise.resolve();
                        }
                        console.error(fontResult._0.toString());
                        return Promise.resolve();
                      });
                }));
        }), [
        fontUrl,
        text,
        size
      ]);
  return JsxRuntime.jsx("div", {
              children: JsxRuntime.jsx("div", {
                    children: JsxRuntime.jsx("div", {
                          children: JsxRuntime.jsxs("div", {
                                children: [
                                  JsxRuntime.jsx("div", {
                                        children: JsxRuntime.jsx("h3", {
                                              children: "Text to svg",
                                              className: "text-base font-semibold leading-6 text-gray-900"
                                            }),
                                        className: "border-b border-gray-200 bg-white px-4 py-5 sm:px-6"
                                      }),
                                  JsxRuntime.jsx(App$FontSelector, {
                                        onSelectFont: (function (font) {
                                            setFontUrl(function (param) {
                                                  return font;
                                                });
                                          })
                                      }),
                                  JsxRuntime.jsxs("div", {
                                        children: [
                                          JsxRuntime.jsx(App$Input, {
                                                label: "Text",
                                                value: text,
                                                onChange: (function (value) {
                                                    setText(function (param) {
                                                          return value;
                                                        });
                                                  })
                                              }),
                                          JsxRuntime.jsx(App$Input, {
                                                label: "Size",
                                                value: size.toString(),
                                                onChange: (function (value) {
                                                    setSize(function (param) {
                                                          return Core__Option.getExn(Core__Int.fromString(undefined, value));
                                                        });
                                                  })
                                              })
                                        ],
                                        className: "border-b border-gray-200 bg-white px-4 py-5 sm:px-6"
                                      }),
                                  JsxRuntime.jsx("div", {
                                        children: svg !== undefined ? JsxRuntime.jsx("div", {
                                                className: "bg-white p-6 w-fit",
                                                dangerouslySetInnerHTML: {
                                                  __html: svg
                                                }
                                              }) : JsxRuntime.jsx("div", {
                                                children: "No SVG"
                                              }),
                                        className: "border-b border-gray-200 bg-white px-4 py-5 sm:px-6"
                                      })
                                ],
                                className: "overflow-hidden bg-white sm:rounded-lg sm:shadow"
                              }),
                          className: "mx-auto max-w-none"
                        }),
                    className: "mx-auto max-w-7xl py-6 sm:px-6 lg:px-8"
                  }),
              className: "bg-gray-100"
            });
}

var make = App;

export {
  make ,
}
/* Lib Not a pure module */