type fileReader
type file = {"name": string, "lastModified": int, "size": int, "type__": string}

@new external createFileReader: unit => fileReader = "FileReader"

@send
external readAsDataURL: (fileReader, file) => unit = "readAsDataURL"

let onload: (fileReader, string => unit) => unit = %raw(`
    function (reader, cb) {
      reader.onload = function (e) {
        cb(e.target.result);
      }
    }
  `)

let fileToDataUrl: (file, string => unit) => unit = (file, continue) => {
  let reader = createFileReader()
  onload(reader, continue)
  readAsDataURL(reader, file)
}
