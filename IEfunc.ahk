
#SingleInstance

IE_OnQuit(*){
    ExitApp
}

; Create IE Gui Window
IE_Gui(title,width:=400,height:=400,left:=0,top:=0){
    iea            := ComObjCreate("InternetExplorer.Application")
    iea.width      := width
    iea.height     := height
    iea.left       := (!left ? (A_ScreenWidth - iea.width) / 2 : left)
    iea.top        := (!top  ? (A_ScreenHeight - iea.height) / 2 : top)
    iea.fullscreen := false
    iea.resizable  := false
    iea.addressbar := false
    iea.menubar    := false
    iea.toolbar    := false
    iea.statusbar  := false
    iea.navigate("about:blank")
    While iea.readystate != 4
        Continue
    hWnd                   := iea.hWnd
    doc                    := iea.document
    doc.title              := (a_ptrsize=4?"32-Bit ":"64-Bit ") title
    win                    := doc.defaultView
    head                   := doc.head
    body                   := doc.body
    body.scroll            := "no"
    body.style.borderwidth := 0
    win.focus
    ComObjConnect iea,"IE_"
}

; Create HTML Tag Objects for IE Gui Window
Set_Element(element,apend,text:="",left:=0,top:=0,width:=0,height:=0){
    obj := text != NS ? doc.createElement(element) : doc.createElementNS(NS,element)
    If left > 0 Or left < 0
        obj.style.left := left
    If top > 0 Or top < 0
        obj.style.top := top
    If width > 0
        obj.style.width := width
    If height > 0
        obj.style.height := height
    If left + top + width + height > 0
        obj.style.position := "absolute"
    If text != NS
        obj.textContent := text
    apend.appendChild(obj)
    Return obj
}

global iea:={},hWnd:=0,doc:={},win:={},head:={},body:={},NS:="http://www.w3.org/2000/svg"

