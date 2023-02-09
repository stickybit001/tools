# Stealthy Webshell Backdoor

Khi start-up, tất cả file aspx phần server-side code được compiled lại chung thành 1 dll file với từng cachekey file trỏ đến file dll này và load vào memory, request aspx file dựa vào mem cache chứ không phải trên disk nên các file cache trên disk chỉ được sử dụng để load khi iis bị restart lại. iis server có cơ chế tối ưu nên mặc định sau 20p không hoạt động sẽ tự tắt, có request mới sẽ restart lên lại ==> load cache from disk

Thế nên kĩ thuật này thường được dùng để đặt persistent backdoor chứ cũng khá bất tiện do cần đợi server restart

Do đó, để đặt backdoor trong runtime cần chọn một **file aspx chưa được compile**

1. Đặt một "innocent aspx file" tại webroot
2. Upload compiled webshell `App_Web_pax0e2so.dll` lên *IIS Server* cache directory, mặc định là: `C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files\app\hash\hash`. `app/hash/hash` là `codegendir` được tính từ script đính kèm
3. Từ innocent aspx file cần hijack + script để tìm cachekey của file này từ virtualPath ==> tạo cachekey file với element `preserve` có thuộc tính như sau và đặt tiếp vào cache folder:
  - `assembly="App_Web_pax0e2so"` <== compiled theme.aspx : aspx webshell
  - `type="ASP.theme_aspx"`
4. Request innocent aspx file kia sẽ load cachekey trên disk do trong mem chưa tồn tại. Từ đây cache trên disk được load vào mem ==> ta có thể xóa innocent file này.

**Cache folder**:

![Cache folder](https://user-images.githubusercontent.com/71699412/217500057-1015606f-7b01-4f9e-854f-c739a1f3cbe5.png)

**Cache key file**:

![Cache key](https://user-images.githubusercontent.com/71699412/217500604-d4b87cce-3799-4b5d-adaf-3b7f90adada3.png)


![After hijacking](https://user-images.githubusercontent.com/71699412/217499295-4083ba0d-05d0-4550-af47-f37303d97c74.png)
