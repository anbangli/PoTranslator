; 自动修剪 Poedit 中的中文翻译词条末尾的空格。
; 要求先启动 Poedit 并打开待翻译的 .po 文件。

gosub, CreateGUI	;构建程序用户界面
SetTimer, Update, 200		;定时器自动刷新
return

CreateGUI:	;构建程序用户界面
  Gui, Add, Checkbox, xp+10 yp+5 w150 h20 Right vAutoNext +Checked, 连续工作
  Gui Add, Edit, x16 y30 w300 h50 vOrigText
  Gui Add, Button, x16 y90 w300 h40 vbtnTrim, 清除空格
  Gui Add, Edit, x16 y140 w300 h50 vTrimText
  Gui Show, w330 h210, 自动修剪PO词条空格
return

S1:=""
btnTrim:
  ControlGetText, S1, RICHEDIT50W3, ahk_exe Poedit.exe ;获取翻译词条
  GuiControl, , OrigText, % S1
  ;ret := LTrim(S1)  ;修剪左侧空格
  ;ret := RTrim(S1)  ;修剪右侧空格
  ret := Trim(S1)    ;修剪左右两侧空格

  GuiControl, , TrimText, % ret
  ControlSetText , RICHEDIT50W3,% ret,ahk_exe Poedit.exe  ;写入修剪后的词条
  
  ;if(AutoNext){
    ControlSend,, ^+{Down},ahk_exe Poedit.exe
  ;}
return


GuiEscape:
GuiClose:
  ExitApp
return

Update:
  gosub, btnTrim
return
