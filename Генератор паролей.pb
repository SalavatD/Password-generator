
Enumeration
  #MAIN_WINDOW
EndEnumeration

Enumeration
  #MENU_BAR
EndEnumeration

Enumeration
  #ACTION_EXIT
  
  #ACTION_ABOUT
EndEnumeration

Enumeration
  #PASSWORD_STRING
  
  #COPY_BUTTON
  
  #GENERATE_BUTTON
  
  #LOWERCASE_CHECKBOX
  #LOWERCASE_TEXT
  
  #UPPERCASE_CHECKBOX
  #UPPERCASE_TEXT
  
  #NUMBERS_CHECKBOX
  #NUMBERS_TEXT
  
  #SYMBOLS_CHECKBOX
  #SYMBOLS_TEXT
  
  #SYMBOL_COUNT_SPIN
  
  #LENGTH_TEXT
EndEnumeration

#DEFAULT_LENGTH = 16

#MIN_LENGTH =  1
#MAX_LENGTH = 100

#RETURN_KEY_CODE = 13

Procedure OpenMainWindow()
  
  If OpenWindow(#MAIN_WINDOW, #PB_Ignore, #PB_Ignore, 380, 150, "Генератор паролей", #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered )
    If CreateMenu(#MENU_BAR, WindowID(#MAIN_WINDOW))
      MenuTitle("Файл")
      MenuItem(#ACTION_EXIT, "Выход")
      
      MenuTitle("Справка")
      MenuItem(#ACTION_ABOUT, "О программе")
    EndIf
    
    StringGadget(#PASSWORD_STRING,       20, 20, 230, 20, "", #PB_String_ReadOnly)
    
    ButtonGadget(#COPY_BUTTON,          260, 19, 100, 22, "Копировать")
    
    ButtonGadget(#GENERATE_BUTTON,      260, 87, 100, 25, "Сгенерировать", #PB_Button_Default)
    
    CheckBoxGadget(#LOWERCASE_CHECKBOX,  20, 60, 14, 15, "")
    TextGadget(#LOWERCASE_TEXT,          40, 60, 95, 20, "Строчные буквы")
    
    CheckBoxGadget(#UPPERCASE_CHECKBOX, 140, 60, 14, 15, "")
    TextGadget(#UPPERCASE_TEXT,         160, 60, 95, 20, "Прописные буквы")
    
    CheckBoxGadget(#NUMBERS_CHECKBOX,    20, 90, 14, 15, "")
    TextGadget(#NUMBERS_TEXT,            40, 90, 95, 20, "Цифры")
    
    CheckBoxGadget(#SYMBOLS_CHECKBOX,   140, 90, 14, 15, "")
    TextGadget(#SYMBOLS_TEXT,           160, 90, 95, 20, "Символы")
    
    SpinGadget(#SYMBOL_COUNT_SPIN,      320, 55,  40, 20, #MIN_LENGTH, #MAX_LENGTH, #PB_Spin_Numeric)
    
    TextGadget(#LENGTH_TEXT,            260, 60,  50, 20, "Длина:", #PB_Text_Right)
    
    SetWindowColor(#MAIN_WINDOW, $FFFFFF)
    
    SetGadgetColor(#PASSWORD_STRING, #PB_Gadget_BackColor, $FFFFFF)
    
    SetGadgetColor(#LOWERCASE_TEXT, #PB_Gadget_BackColor, $FFFFFF)
    
    SetGadgetColor(#UPPERCASE_TEXT, #PB_Gadget_BackColor, $FFFFFF)
    
    SetGadgetColor(#NUMBERS_TEXT, #PB_Gadget_BackColor, $FFFFFF)
    
    SetGadgetColor(#SYMBOLS_TEXT, #PB_Gadget_BackColor, $FFFFFF)
    
    SetGadgetColor(#LENGTH_TEXT, #PB_Gadget_BackColor, $FFFFFF)
    
    SetGadgetState(#SYMBOL_COUNT_SPIN, #DEFAULT_LENGTH)
    
    AddKeyboardShortcut(#MAIN_WINDOW, #PB_Shortcut_Return, #RETURN_KEY_CODE)
    
    DisableGadget(#COPY_BUTTON, #True)
  EndIf
EndProcedure

OpenMainWindow()

Repeat
  
  event       = WaitWindowEvent()
  eventMenu   = EventMenu()
  eventGadget = EventGadget()
  eventWindow = EventWindow()
  eventType   = EventType()
  
  If eventWindow = #MAIN_WINDOW
    If event = #PB_Event_Menu
      If eventMenu = #ACTION_EXIT
        Break
      ElseIf eventMenu = #ACTION_ABOUT
        MessageRequester("О программе", "Генератор паролей. Версия 1.0" + #CR$ + #CR$ + "Автор: Салават Даутов" + #CR$ + #CR$ + "Дата создания: июль 2012 года", #MB_ICONINFORMATION)
      ElseIf eventMenu = #RETURN_KEY_CODE
        Goto generate
      EndIf
    EndIf
    
    If event = #PB_Event_Gadget
      If eventGadget = #SYMBOL_COUNT_SPIN
        SetGadgetText(#SYMBOL_COUNT_SPIN, Str(GetGadgetState(#SYMBOL_COUNT_SPIN)))
      EndIf
      
      If eventGadget = #GENERATE_BUTTON
        generate:
        
        lowercase = GetGadgetState(#LOWERCASE_CHECKBOX)
        uppercase = GetGadgetState(#UPPERCASE_CHECKBOX)
        numbers   = GetGadgetState(#NUMBERS_CHECKBOX)
        symbols   = GetGadgetState(#SYMBOLS_CHECKBOX)
        
        If Not (lowercase Or uppercase Or numbers Or symbols)
          MessageRequester("Внимание", "Выберите символы для пароля", #MB_ICONINFORMATION)
        Else
          password.s = ""
          
          For i = #MIN_LENGTH To GetGadgetState(#SYMBOL_COUNT_SPIN)
            retry:
            Select Random(3)
              Case 0
                If lowercase
                  password = password + Chr(Random(122 - 97) + 97)
                Else
                  Goto retry
                EndIf
              Case 1
                If uppercase
                  password = password + Chr(Random(90 - 65) + 65)
                Else
                  Goto retry
                EndIf
              Case 2
                If numbers
                  password = password + Str(Random(9))
                Else
                  Goto retry
                EndIf
              Case 3
                If symbols
                  Select Random(4)
                    Case 0
                      password = password + Chr(Random(47 - 33) + 33)
                    Case 1
                      password = password + Chr(Random(47 - 33) + 33)
                    Case 2
                      password = password + Chr(Random(64 - 58) + 58)
                    Case 3
                      password = password + Chr(Random(96 - 91) + 91)
                    Case 4
                      password = password + Chr(Random(126 - 123) + 123)
                  EndSelect
                Else
                  Goto retry
                EndIf
            EndSelect
          Next
          
          SetGadgetText(#PASSWORD_STRING, password)
          
          DisableGadget(#COPY_BUTTON, #False)
        EndIf
      EndIf
      
      If eventGadget = #COPY_BUTTON
        SetClipboardText(GetGadgetText(#PASSWORD_STRING))
        MessageRequester("Скопировать", "Пароль скопирован в буфер обмена", #MB_ICONINFORMATION)
      EndIf
    EndIf
  EndIf
Until event = #PB_Event_CloseWindow And eventWindow = #MAIN_WINDOW

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 193
; FirstLine = 152
; Folding = -
; EnableXP
; UseIcon = Icon.ico
; Executable = Генератор паролей.exe
; DisableDebugger
; IncludeVersionInfo
; VersionField0 = 1.0.0.0
; VersionField1 = 1.0.0.0
; VersionField2 = Салават Даутов
; VersionField3 = Генератор паролей
; VersionField4 = 1.0
; VersionField5 = 1.0
; VersionField6 = Генератор паролей
; VersionField7 = Генератор паролей
; VersionField8 = Генератор паролей.exe
; VersionField17 = 0419 Russian
