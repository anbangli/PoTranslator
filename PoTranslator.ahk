; PoTranslator v2024.05
; 使用 Poedit 自动进行词条机器翻译。要求先启动 Poedit 并打开待翻译的 .po 文件。
; 本程序可以选择使用不同的翻译引擎。选择方法见程序末尾处的说明。
; 原作者：zj1d ，修改者：anbangli@foxmail.com


; todo:
; 自动 free() 后可以自动退出
#MenuMaskKey vkFF
gosub, CreateGUI	;构建程序用户界面
gosub, InitializeTranslator	;初始化
SetTimer, Update, 1020	;定时器自动刷新
return


CreateGUI:	;构建程序用户界面
  Gui, Add, Checkbox, yp+5 xp+50 w150 h20 Right vAutoNext +Checked, 自动连续翻译  
  Gui Add, Edit, x16 y30 w300 h120 vOriginal +Disabled
  Gui Add, Button, x16 y160 w300 h40 vTranslate +Disabled, Translate
  Gui Add, Edit, x16 y210 w300 h150 vTranslation +Disabled
  Gui Show, w320 h380, PoeditTranslator
return

InitializeTranslator:	;初始化
  GuiControl, , Original, Initializing...`n正在初始化...
  if (Translator.init("Chrome\chrome.exe")=Translator.multiLanguage.5)
    GuiControl, , Original, Init failed, pls exit and try again.`n初始化失败，请退出重试。
  else
  {
    GuiControl, Enable, Original
    GuiControl, Enable, Translation
    GuiControl, Enable, Translate
    HelpText := "请启动 Poedit 并打开待翻译文件。`n点击菜单“查看”，勾选“未翻译条目优先”, `n"
    HelpText := HelpText . "鼠标点击第1个未翻译条目，以开始自动翻译。"
    GuiControl, , Original, %HelpText%
  }
return

ButtonTranslate:
  Gui, Submit, NoHide
  GuiControl, , Translation, Translating...`n翻译中...

  ret := Translator.translate(Original)
  
  GuiControl, , Translation, % ret
  if(Original != ret)
  ControlSetText , RICHEDIT50W3,% ret,ahk_exe Poedit.exe
  Sleep 50
  ControlSend,, ^u,ahk_exe Poedit.exe
  ;ControlClick , Button7.ahk_exe Poedit.exe
  Sleep 50
  if(AutoNext){
  ControlSend,, ^+{Down},ahk_exe Poedit.exe
  }
return

GuiEscape:
GuiClose:
  Translator.free()
  ExitApp
return

CurText := ""
SourceText:= ""
TransText := ""
count := 0
Update:
  ControlGetText, SourceText, RICHEDIT50W1, ahk_exe Poedit.exe
  ControlGetText, TransText, RICHEDIT50W3, ahk_exe Poedit.exe
  if (SourceText != CurText && TransText == ""){
  	count=0
    CurText:=OutputVar
 	GuiControl, , Original, % SourceText
 	gosub, ButtonTranslate
  } else {
  	count := count + 1
  	GuiControl, , Translation, % count
  }
  if (count >= 10 && AutoNext) {
  	ControlSend,, ^+{PageDown},ahk_exe Poedit.exe
  	
  	ControlSend,, ^+{Down},ahk_exe Poedit.exe
  	
  	GuiControl, , Translation, Ctrl-Down-Next
  	count := 0
  }
  
;  else if (SourceText == CurText && TransText != "" && AutoNext){
;    ControlSend,, ^+{Down},ahk_exe Poedit.exe
;    CurText:=OutputVar
; 	GuiControl, , Original, % SourceText
; 	gosub, ButtonTranslate
;  }
return

;选择翻译引擎：下面四行代码分别代表四个翻译引擎（百度，搜狗，有道，DeepL），
;只能选择其中一个为有效语句（行首 不 写 分号），其它的设为注释（行首写英文分号）。
;#Include <BaiduTranslator>		;百度
#Include <SogouTranslator>   	;搜狗
;#Include <YoudaoTranslator>	;有道
;#Include <DeepLTranslator>   	;DeepL
