/**
 * aes_128_cfb_zero_padding
 String encoder = "aes";
 String SessionKey = "WSESSID"; // Custom sessionkey id
 String aes_mode = "CFB";            // EBC|ECB|CFB|
 String aes_padding = "NoPadding";   // NoPadding|PKCS5Padding|PKCS7Padding
 int aes_keylen = 16;                // 16|32  // 16(AES-128) 32(AES-256)
 String aes_key_padding = "a";
 */

'use strict';
const path = require('path');
var CryptoJS = require(path.join(window.antSword.remote.process.env.AS_WORKDIR, 'node_modules/crypto-js'));

function get_cookie(Name, CookieStr="") {
    var search = Name + "="
    var returnvalue = "";
    if (CookieStr.length > 0) {
        var sd = CookieStr.indexOf(search);
        if (sd!= -1) {
            sd += search.length;
            var end = CookieStr.indexOf(";", sd);
            if (end == -1){
                end = CookieStr.length;
            }
            returnvalue = window.unescape(CookieStr.substring(sd, end));
        }
    }
    return returnvalue;
}


function decryptText(keyStr, text) {
    let buff = Buffer.alloc(16, 'a');
    buff.write(keyStr,0);
    keyStr = buff.toString();
    let decodetext = CryptoJS.AES.decrypt(text, CryptoJS.enc.Utf8.parse(keyStr), {
        iv: CryptoJS.enc.Utf8.parse(keyStr),
        mode: CryptoJS.mode.CFB,
        padding: CryptoJS.pad.ZeroPadding
    }).toString(CryptoJS.enc.Utf8)
    return decodetext;
}

function encryptText(keyStr, text) {
    let buff = Buffer.alloc(16, 'a');
    buff.write(keyStr,0);
    keyStr = buff.toString();

    let encodetext = CryptoJS.AES.encrypt(text, CryptoJS.enc.Utf8.parse(keyStr), {
        iv: CryptoJS.enc.Utf8.parse(keyStr),
        mode: CryptoJS.mode.CFB,
        padding: CryptoJS.pad.ZeroPadding,
    }).toString()
    return encodetext;
}

/*
* @param  {String} pwd   pwd parameter
* @param  {Array}  data  payload before encoder processing
* @return {Array}  data  payload processed by the encoder
*/
module.exports = (pwd, data, ext={}) => {
    // get aes encryption key from cookies
    let headers = ext.opts.httpConf.headers;
    if(!headers.hasOwnProperty('Cookie')) {
        window.toastr.error("Please set the cookie first (case sensitive), you can get the cookie by browsing the website", "ERROR");
        return data;
    }
    let session_key = "WSESSID";
    let keyStr = get_cookie(session_key, headers['Cookie']);
    if(keyStr.length === 0) {
        window.toastr.error("WSESSID not found in cookie", "ERROR");
        return data;
    }

    let ret = {};
    for (let _ in data) { // encrypt all parameters
        if (_ === '_') {
            continue // except java bytecode
        };

        ret[_] = encryptText(keyStr, data[_]);
    }
    ret[pwd] = data['_'];
    return ret;
}