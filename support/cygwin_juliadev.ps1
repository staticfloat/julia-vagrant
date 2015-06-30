mkdir -Force C:\cygwin | Out-Null
(new-object net.webclient).DownloadFile(
  "http://cygwin.com/setup-x86_64.exe", "C:\cygwin\setup-x86_64.exe")
foreach ($pkg in @("git,make,curl,patch,python,gcc-g++,m4,cmake,p7zip",
    "mingw64-i686-gcc-g++,mingw64-i686-gcc-fortran",
    "mingw64-x86_64-gcc-g++,mingw64-x86_64-gcc-fortran")) {
  C:\cygwin\setup-x86_64.exe -q -n -R C:\cygwin -l C:\cygwin\packages `
    -s http://mirrors.mit.edu/cygwin -g -P $pkg | Where-Object `
    -FilterScript {$_ -notlike "Installing file *"} | Write-Output
}
[Environment]::SetEnvironmentVariable("HOMEDRIVE", "C:")
[Environment]::SetEnvironmentVariable("HOMEPATH", "\Users\vagrant")
C:\cygwin\bin\sh -lc "if ! [ -e julia32 ]; then git clone \
  git://github.com/JuliaLang/julia.git julia32; fi && cd julia32 && git pull && \
  echo 'XC_HOST = i686-w64-mingw32' > Make.user && make cleanall && \
  make -j2 test && make win-extras && make binary-dist"
C:\cygwin\bin\sh -lc "if ! [ -e julia64 ]; then git clone \
  git://github.com/JuliaLang/julia.git julia64; fi && cd julia64 && git pull && \
  echo 'XC_HOST = x86_64-w64-mingw32' > Make.user && make cleanall && \
  make -j2 test && make win-extras && make binary-dist"
