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

**Webroot**:

![02-09 11_02_45-PUBLISHED](https://user-images.githubusercontent.com/71699412/217715084-cff0e94c-9094-49ba-898a-1f5a3089a3e5.png)

**Cache folder**:

![02-09 11_00_31-2f935a94](https://user-images.githubusercontent.com/71699412/217715058-9ac58c48-67ec-4742-a6f5-e8fab67f7cbb.png)

**Cache key file**:

![02-09 11_03_42-C__Windows_Microsoft NET_Framework64_v4 0 30319_Temporary ASP NET Files_root_5e2](https://user-images.githubusercontent.com/71699412/217715091-983ccdfc-e6f4-4b55-a3cb-b39c4869c231.png)

![02-09 11_06_52-localhost_theme aspx](https://user-images.githubusercontent.com/71699412/217715337-0d0567f2-7ee8-4158-aaff-708956b12cab.png)
