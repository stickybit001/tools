import os, subprocess, pathlib, threading

def execExtractThread(file):
	try:
		folder_name = file.strip('.jar')
		status_code = subprocess.run(['tar', '-xf', file, '-C', folder_name], stdout=subprocess.DEVNULL).returncode
		if status_code == 0:
			os.remove(file)
	except Exception as e:
		print(e)

def extractJarFile(jar_foler):
	print('[INFO] - finding all files endswith .jar')
	folder = pathlib.Path(jar_foler)
	files = [str(f) for f in list(folder.rglob("*.jar"))] # **/*.jar
	print(f'[DONE] - found {len(files)} files!')

	threads = []
	for i, file in enumerate(files):
		t = threading.Thread(target=execExtractThread, args=(file, ))
		t.start()
		threads.append(t)

		if i % 20 == 0:
			for thread in threads:
				thread.join()
			threads = []
			print(f'[INFO] - extracted {i} files')

	print('[DONE] - extracted all jar files!')

def execDecompileThread(file):
	try:
		folder_name = file[:file.rindex('\\')]
		status_code = subprocess.run(['java', '-jar', './jd-cli.jar', file, '-od', folder_name], stdout=subprocess.DEVNULL).returncode # call java.exe
		if status_code == 0:
			 os.remove(file)
	except Exception as e:
		print(e)

def decompileClassFiletoJava(jar_foler):
	print('[INFO] - finding all files endswith .class')
	folder = pathlib.Path(jar_foler)
	files = [str(f) for f in list(folder.rglob("**/*.class"))]
	print(f'[DONE] - found {len(files)} files!')

	threads = []
	for i, file in enumerate(files):
		t = threading.Thread(target=execDecompileThread, args=(file, ))
		t.start()
		threads.append(t)

		if i % 10 == 0:
			for thread in threads:
				thread.join()
			threads = []
		
		if i % 500 == 0:
			print(f'[INFO] - decompiled {i} files')
			# print(f'[Checkpoint] - {file}')

	print('[DONE] - extracted all class files!')


if __name__ == '__main__':
	jar_foler = 'D:\\RESEARCH\\WSO2\\source\\wso2-decompiled'
	
	# extractJarFile(jar_foler)
	decompileClassFiletoJava(jar_foler)
	