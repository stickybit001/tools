'use strict';

var zlib = require('zlib');
/*
* @param  {String} pwd   pwd parameter
* @param  {Array}  data  payload before encoder processing
* @return {Array}  data  payload processed by the encoder
*/
module.exports = (pwd, data) => {
  let compressed = zlib.deflateSync(Buffer.from(data['_'], 'base64'), {
    level: 9, // 0~9
    memLevel:5
  })
  data[pwd] = compressed.toString('base64');
  delete data['_'];
  return data;
}
