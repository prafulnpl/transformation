"use strict";

exports.id = 460, exports.ids = [ 460 ], exports.modules = {
 87460: (__unused_webpack___webpack_module__, __webpack_exports__, __webpack_require__) => {
  __webpack_require__.d(__webpack_exports__, {
   toFormData: () => toFormData
  });
  var fetch_blob_from_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(69730), formdata_polyfill_esm_min_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(98435);
  let s = 0;
  const S = {
   START_BOUNDARY: s++,
   HEADER_FIELD_START: s++,
   HEADER_FIELD: s++,
   HEADER_VALUE_START: s++,
   HEADER_VALUE: s++,
   HEADER_VALUE_ALMOST_DONE: s++,
   HEADERS_ALMOST_DONE: s++,
   PART_DATA_START: s++,
   PART_DATA: s++,
   END: s++
  };
  let f = 1;
  const F_PART_BOUNDARY = f, F_LAST_BOUNDARY = f *= 2, lower = c => 32 | c, noop = () => {};
  class MultipartParser {
   constructor(boundary) {
    this.index = 0, this.flags = 0, this.onHeaderEnd = noop, this.onHeaderField = noop, 
    this.onHeadersEnd = noop, this.onHeaderValue = noop, this.onPartBegin = noop, this.onPartData = noop, 
    this.onPartEnd = noop, this.boundaryChars = {}, boundary = "\r\n--" + boundary;
    const ui8a = new Uint8Array(boundary.length);
    for (let i = 0; i < boundary.length; i++) ui8a[i] = boundary.charCodeAt(i), this.boundaryChars[ui8a[i]] = !0;
    this.boundary = ui8a, this.lookbehind = new Uint8Array(this.boundary.length + 8), 
    this.state = S.START_BOUNDARY;
   }
   write(data) {
    let i = 0;
    const length_ = data.length;
    let previousIndex = this.index, {lookbehind, boundary, boundaryChars, index, state, flags} = this;
    const boundaryLength = this.boundary.length, boundaryEnd = boundaryLength - 1, bufferLength = data.length;
    let c, cl;
    const mark = name => {
     this[name + "Mark"] = i;
    }, clear = name => {
     delete this[name + "Mark"];
    }, callback = (callbackSymbol, start, end, ui8a) => {
     void 0 !== start && start === end || this[callbackSymbol](ui8a && ui8a.subarray(start, end));
    }, dataCallback = (name, clear) => {
     const markSymbol = name + "Mark";
     markSymbol in this && (clear ? (callback(name, this[markSymbol], i, data), delete this[markSymbol]) : (callback(name, this[markSymbol], data.length, data), 
     this[markSymbol] = 0));
    };
    for (i = 0; i < length_; i++) switch (c = data[i], state) {
    case S.START_BOUNDARY:
     if (index === boundary.length - 2) {
      if (45 === c) flags |= F_LAST_BOUNDARY; else if (13 !== c) return;
      index++;
      break;
     }
     if (index - 1 == boundary.length - 2) {
      if (flags & F_LAST_BOUNDARY && 45 === c) state = S.END, flags = 0; else {
       if (flags & F_LAST_BOUNDARY || 10 !== c) return;
       index = 0, callback("onPartBegin"), state = S.HEADER_FIELD_START;
      }
      break;
     }
     c !== boundary[index + 2] && (index = -2), c === boundary[index + 2] && index++;
     break;

    case S.HEADER_FIELD_START:
     state = S.HEADER_FIELD, mark("onHeaderField"), index = 0;

    case S.HEADER_FIELD:
     if (13 === c) {
      clear("onHeaderField"), state = S.HEADERS_ALMOST_DONE;
      break;
     }
     if (index++, 45 === c) break;
     if (58 === c) {
      if (1 === index) return;
      dataCallback("onHeaderField", !0), state = S.HEADER_VALUE_START;
      break;
     }
     if (cl = lower(c), cl < 97 || cl > 122) return;
     break;

    case S.HEADER_VALUE_START:
     if (32 === c) break;
     mark("onHeaderValue"), state = S.HEADER_VALUE;

    case S.HEADER_VALUE:
     13 === c && (dataCallback("onHeaderValue", !0), callback("onHeaderEnd"), state = S.HEADER_VALUE_ALMOST_DONE);
     break;

    case S.HEADER_VALUE_ALMOST_DONE:
     if (10 !== c) return;
     state = S.HEADER_FIELD_START;
     break;

    case S.HEADERS_ALMOST_DONE:
     if (10 !== c) return;
     callback("onHeadersEnd"), state = S.PART_DATA_START;
     break;

    case S.PART_DATA_START:
     state = S.PART_DATA, mark("onPartData");

    case S.PART_DATA:
     if (previousIndex = index, 0 === index) {
      for (i += boundaryEnd; i < bufferLength && !(data[i] in boundaryChars); ) i += boundaryLength;
      i -= boundaryEnd, c = data[i];
     }
     if (index < boundary.length) boundary[index] === c ? (0 === index && dataCallback("onPartData", !0), 
     index++) : index = 0; else if (index === boundary.length) index++, 13 === c ? flags |= F_PART_BOUNDARY : 45 === c ? flags |= F_LAST_BOUNDARY : index = 0; else if (index - 1 === boundary.length) if (flags & F_PART_BOUNDARY) {
      if (index = 0, 10 === c) {
       flags &= ~F_PART_BOUNDARY, callback("onPartEnd"), callback("onPartBegin"), state = S.HEADER_FIELD_START;
       break;
      }
     } else flags & F_LAST_BOUNDARY && 45 === c ? (callback("onPartEnd"), state = S.END, 
     flags = 0) : index = 0;
     if (index > 0) lookbehind[index - 1] = c; else if (previousIndex > 0) {
      const _lookbehind = new Uint8Array(lookbehind.buffer, lookbehind.byteOffset, lookbehind.byteLength);
      callback("onPartData", 0, previousIndex, _lookbehind), previousIndex = 0, mark("onPartData"), 
      i--;
     }
     break;

    case S.END:
     break;

    default:
     throw new Error(`Unexpected state entered: ${state}`);
    }
    dataCallback("onHeaderField"), dataCallback("onHeaderValue"), dataCallback("onPartData"), 
    this.index = index, this.state = state, this.flags = flags;
   }
   end() {
    if (this.state === S.HEADER_FIELD_START && 0 === this.index || this.state === S.PART_DATA && this.index === this.boundary.length) this.onPartEnd(); else if (this.state !== S.END) throw new Error("MultipartParser.end(): stream ended unexpectedly");
   }
  }
  async function toFormData(Body, ct) {
   if (!/multipart/i.test(ct)) throw new TypeError("Failed to fetch");
   const m = ct.match(/boundary=(?:"([^"]+)"|([^;]+))/i);
   if (!m) throw new TypeError("no or bad content-type header, no multipart boundary");
   const parser = new MultipartParser(m[1] || m[2]);
   let headerField, headerValue, entryValue, entryName, contentType, filename;
   const entryChunks = [], formData = new formdata_polyfill_esm_min_js__WEBPACK_IMPORTED_MODULE_1__.fS, onPartData = ui8a => {
    entryValue += decoder.decode(ui8a, {
     stream: !0
    });
   }, appendToFile = ui8a => {
    entryChunks.push(ui8a);
   }, appendFileToFormData = () => {
    const file = new fetch_blob_from_js__WEBPACK_IMPORTED_MODULE_0__.ZH(entryChunks, filename, {
     type: contentType
    });
    formData.append(entryName, file);
   }, appendEntryToFormData = () => {
    formData.append(entryName, entryValue);
   }, decoder = new TextDecoder("utf-8");
   decoder.decode(), parser.onPartBegin = function() {
    parser.onPartData = onPartData, parser.onPartEnd = appendEntryToFormData, headerField = "", 
    headerValue = "", entryValue = "", entryName = "", contentType = "", filename = null, 
    entryChunks.length = 0;
   }, parser.onHeaderField = function(ui8a) {
    headerField += decoder.decode(ui8a, {
     stream: !0
    });
   }, parser.onHeaderValue = function(ui8a) {
    headerValue += decoder.decode(ui8a, {
     stream: !0
    });
   }, parser.onHeaderEnd = function() {
    if (headerValue += decoder.decode(), headerField = headerField.toLowerCase(), "content-disposition" === headerField) {
     const m = headerValue.match(/\bname=("([^"]*)"|([^()<>@,;:\\"/[\]?={}\s\t]+))/i);
     m && (entryName = m[2] || m[3] || ""), filename = function(headerValue) {
      const m = headerValue.match(/\bfilename=("(.*?)"|([^()<>@,;:\\"/[\]?={}\s\t]+))($|;\s)/i);
      if (!m) return;
      const match = m[2] || m[3] || "";
      let filename = match.slice(match.lastIndexOf("\\") + 1);
      return filename = filename.replace(/%22/g, '"'), filename = filename.replace(/&#(\d{4});/g, ((m, code) => String.fromCharCode(code))), 
      filename;
     }(headerValue), filename && (parser.onPartData = appendToFile, parser.onPartEnd = appendFileToFormData);
    } else "content-type" === headerField && (contentType = headerValue);
    headerValue = "", headerField = "";
   };
   for await (const chunk of Body) parser.write(chunk);
   return parser.end(), formData;
  }
 }
};
//# sourceMappingURL=460.extension.js.map