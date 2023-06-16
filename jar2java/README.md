# jar2java

decompile nhiều jar file thành source code thuần java

## Step 

Move tất cả jar file vào một thư mục (linux):
```bash
find . -type f -name "*.jar" | xargs -n 1 -P 20 -I {} mv {} wso2-decompiled/
```

Chạy tool
	 - Tìm tất cả file .jar rồi extract như zip file
	 - Tìm tất cả file .class (recursive) rồi decompile dùng `jd-cli.jar`

Updating....