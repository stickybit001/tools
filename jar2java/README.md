# jar2java

decompile nhiều jar file ở 1 folder ra code .java

## Step 
```bash
find . -type f -name "*.jar" | xargs -n 1 -P 20 -I {} mv {} wso2-decompiled/
```
