
; [2.0-a118] Star Trek Med Screen IE11 Zoom 125%

#Include ieFunc.ahk
#Include medsImages.ahk

Red_Alert(){
    redAlert.style.visibility := (redAlert.style.visibility = "hidden") ? "visible" : "hidden"
}

Click_OnMouseMove(*){
    PostMessage WM_NCLBUTTONDOWN,HTCAPTION,,hWnd
}

Close_OnMouseOver(*){
    iea.Quit
    ExitApp
}

global WS_POPUP := 0x80000000,WM_NCLBUTTONDOWN := 161,HTCAPTION := 2

W := 1300,H := 710
iLeft := [[85,90],[230,255],[395,415],[655,665],[810,835],[980,995]]

;Create Medical Screen
IE_Gui "StarTrek Meds",W,H
body.background := medsPanel

WinSetStyle WS_POPUP,hWnd
WinSetRegion "0-0 w" W " h" H " r60-60",hWnd

; Create div to Drag Screen
global imove := Set_Element("div",body,,15,15,960,10)
imove.style.background   := "orange"
imove.style.borderStyle  := "none"
imove.style.borderRadius := "30px"
imove.style.cursor       := "pointer"
ComObjConnect(imove,"Click_")

; Image of Number Dump
temp     := Set_Element("img",body,,15,40,475,45)
temp.src := nDump

; Image of Emergency Exit
quit     := Set_Element("img",body,,980,6,40,35)
quit.src := iExit
ComObjConnect(quit,"Close_")

; Image of Red Alert
global redAlert           := Set_Element("img",body,,575,40,385,40)
redAlert.src              := red_Alert
redAlert.style.visibility := "hidden"

; Image of Flashing Red Bar
temp     := Set_Element("img",body,,490,165,75,50)
temp.src := redBar
body.appendChild(temp)

; Create Pointers and Text Info
loop 6{
    iTop                  := floor((random(0,1) * (470 - 76) + 76))
    temp                  := Set_Element("img",body,,iLeft[A_Index][1],iTop,50,46)
    temp.id               := "in" A_Index
    temp.src              := Pointer
    temp.style.transition := "top 2s"
    temp                  := Set_Element("div",body,,iLeft[A_Index][2],505,30,20)
    temp.id               := "out" A_Index
    temp.style.color      := "orange"
    temp.style.font       := "bold 18 Arial"
}

; Create button to Turn Sound On Off
onoff := Set_Element("button",body,"Sound",490,465,80,25)
onoff.setAttribute("onclick","PlaySound()")
onoff.style.background   := "red"
onoff.style.borderStyle  := "none"
onoff.style.borderRadius := "30px"
onoff.style.font         := "bold 18 Arial"
onoff.style.cursor       := "pointer"

; Create audio for playing heart beat
sound      := Set_Element("audio",body)
sound.loop := true
sound.src  := heartBeatslow
; sound.src  := heartBeatfast

; Create the javascript to run the Pointers/Text/Sound
jsCode := "
(
    onoff = document.getElementsByTagName('button')[0];
    sound = document.getElementsByTagName('audio')[0];
    function MoveMeds(){
        for(i=1;i<7;i++){
            io = document.getElementById('in' + i);
            io.style.top = Math.floor((Math.random() * (470 - 76) + 76));
            lab = document.getElementById('out' + i);
            lab.textContent = parseInt(io.style.top).toString(16).toUpperCase();}}
    function PlaySound(){sound.paused ? (sound.play(),onoff.style.background='green') : (sound.pause(),onoff.style.background='red');}
    MoveMeds();
    setInterval(MoveMeds,5000);
)"

; Load the javascript
Set_Element "script",body,jsCode

; Show IEGui Med Screen
iea.visible := true

SetTimer "Red_Alert",20000

Esc::Close_OnMouseOver()
