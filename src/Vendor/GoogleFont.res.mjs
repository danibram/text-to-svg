// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Core__JSON from "@rescript/core/src/Core__JSON.res.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core__Array from "@rescript/core/src/Core__Array.res.mjs";
import * as Core__Option from "@rescript/core/src/Core__Option.res.mjs";
import * as Belt_MapString from "rescript/lib/es6/belt_MapString.js";

var $$Response = {};

var Fetch = {
  $$Response: $$Response
};

function make(family, files) {
  return {
          family: family,
          files: files
        };
}

var Font = {
  make: make
};

function decodeFonts(json) {
  return Core__Option.map(Core__Option.flatMap(Core__Option.flatMap(Core__JSON.Decode.object(json), (function (__x) {
                        return Js_dict.get(__x, "items");
                      })), (function (items) {
                    return Core__JSON.Decode.array(items);
                  })), (function (fonts) {
                return Core__Array.reduce(fonts, undefined, (function (acc, font) {
                              var font$1 = Core__Option.flatMap(Core__JSON.Decode.object(font), (function (font) {
                                      var family = Core__Option.flatMap(Js_dict.get(font, "family"), Core__JSON.Decode.string);
                                      var files = Core__Option.flatMap(Core__Option.flatMap(Js_dict.get(font, "files"), Core__JSON.Decode.object), (function (files) {
                                              return Caml_option.some(Core__Array.reduce(Object.keys(files), undefined, (function (acc, key) {
                                                                var value = Core__Option.flatMap(Js_dict.get(files, key), Core__JSON.Decode.string);
                                                                if (value !== undefined) {
                                                                  return Belt_MapString.set(acc, key, value);
                                                                } else {
                                                                  return acc;
                                                                }
                                                              })));
                                            }));
                                      if (family !== undefined && files !== undefined) {
                                        return {
                                                family: family,
                                                files: Caml_option.valFromOption(files)
                                              };
                                      }
                                      
                                    }));
                              if (font$1 !== undefined) {
                                return Belt_MapString.set(acc, font$1.family, font$1);
                              } else {
                                return acc;
                              }
                            }));
              }));
}

async function load() {
  var url = "https://www.googleapis.com/webfonts/v1/webfonts?key=" + process.env.GOOGLE_API_KEY;
  var response = await fetch(url);
  var json = await response.json();
  return decodeFonts(json);
}

export {
  Fetch ,
  Font ,
  decodeFonts ,
  load ,
}
/* No side effect */
