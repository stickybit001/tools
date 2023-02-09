# Stealthy Webshell Backdoor

1. Upload compiled webshell `App_Web_pax0e2so.dll` đến *IIS Server* cache directory, mặc định là: `C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files\app\hash\hash`
  - `app/hash/hash` là `codegendir` được tính từ script đính kèm
2. Từ file aspx muốn hijack + script để tìm cache key ==> chỉnh sửa cache key file các thuộc tính thuộc element `preserve` như sau:
  - `assembly="App_Web_pax0e2so"`
  - `type="ASP.theme_aspx"`

**Cache folder**:

![Cache folder](https://user-images.githubusercontent.com/71699412/217500057-1015606f-7b01-4f9e-854f-c739a1f3cbe5.png)

**Cache key file**:

![Cache key](https://user-images.githubusercontent.com/71699412/217500604-d4b87cce-3799-4b5d-adaf-3b7f90adada3.png)

**Before hijacking**:

![Before hijacking](https://user-images.githubusercontent.com/71699412/217499285-ee8e56c0-f6f7-4b91-9a61-2b1e31db472f.png)

**After hijacking**:

![After hijacking](https://user-images.githubusercontent.com/71699412/217499295-4083ba0d-05d0-4550-af47-f37303d97c74.png)


## notes
- Tất cả file aspx phần server-side code được compiled lại chung thành 1 dll file ==> lấy assembly từ cachekey mem ==> edit cackey file trên disk thì phải restart lại server
