(new-object net.webclient).DownloadFile(
  "http://cygwin.com/setup-x86_64.exe", "C:\cygwin\setup-x86_64.exe")
foreach ($pkg in @("make","curl","patch","python","gcc-g++","m4","p7zip",
    "mingw64-i686-gcc-g++","mingw64-i686-gcc-fortran",
    "mingw64-x86_64-gcc-g++","mingw64-x86_64-gcc-fortran")) {
  Write-Host $("Installing "+$pkg)
  & C:\cygwin\setup-x86_64.exe -q -n -g -P $pkg >$null 2>&1
}
C:\cygwin\bin\sh -lc "git config --global core.autocrlf input"
C:\cygwin\bin\sh -lc "if ! [ -e julia32 ]; then git clone \
  git://github.com/JuliaLang/julia.git julia32; fi && \
  cd julia32 && git submodule init && git pull && \
  git submodule update && XC_HOST=i686-w64-mingw32 make -C deps"
C:\cygwin\bin\sh -lc "if ! [ -e julia64 ]; then git clone \
  git://github.com/JuliaLang/julia.git julia64; fi && \
  cd julia64 && git submodule init && git pull && \
  git submodule update && XC_HOST=x86_64-w64-mingw32 make -C deps"
