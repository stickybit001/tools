# Stealthy Webshell Backdoor

1. Uplaod compiled webshell `App_Web_pax0e2so.dll` đến *IIS Server* cache directory, mặc định là: `C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files\app\hash\hash`
  - `app/hash/hash` là `codegendir` được tính từ script đính kèm
2. Từ file aspx muốn hijack + script để tìm cache key ==> chỉnh sửa cache key file các thuộc tính thuộc element `preserve` như sau:
  - `assembly="App_Web_pax0e2so"`
  - `type="ASP.theme_aspx"`

**Cache folder**:

![02-08 17_08_03-2f935a94](https://user-images.githubusercontent.com/71699412/217500057-1015606f-7b01-4f9e-854f-c739a1f3cbe5.png)

**Cache key file**:

![02-08 17_08_03-2f935a94](https://user-images.githubusercontent.com/71699412/217500441-f35825ca-d93e-4642-a9f6-cd1cfe686415.png)

**Before hijacking**:

![02-08 17_06_34-localhost_aboutu aspx](https://user-images.githubusercontent.com/71699412/217499285-ee8e56c0-f6f7-4b91-9a61-2b1e31db472f.png)

**After hijacking**:

![02-08 17_07_00-localhost_aboutu aspx](https://user-images.githubusercontent.com/71699412/217499295-4083ba0d-05d0-4550-af47-f37303d97c74.png)
