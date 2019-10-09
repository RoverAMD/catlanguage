#!/usr/bin/env tclsh
source translate.tcl
package require Tk

proc copyEverything {} {
	clipboard clear
	clipboard append [.resultEntry get 0.0 end]
	tk_messageBox -message "Copied translation to clipboard successfully." -type ok
}

proc translateThis {} {
	set toTranslate [string trim [.thisTextEntry get 0.0 end]]
	.resultEntry configure -state normal
	.resultEntry delete 0.0 end
	.resultEntry insert end [meowify $toTranslate]
	.resultEntry configure -state disabled
}

proc toEnglishReal {} {
	set toTranslate [string trim [.thisTextEntry get 0.0 end]]
	.resultEntry configure -state normal
        .resultEntry delete 0.0 end
	.resultEntry insert end [unmeow $toTranslate]
	.resultEntry configure -state disabled
}

label .thisTextLabel -text "Enter text either in English or Russian or (if you're planning to decode it, the text in Cat Language):"
text .thisTextEntry -borderwidth 2
.thisTextEntry insert end "Hello there, cats!"
label .becomesLabel -text "after hardcore translation and calculations becomes:"
text .resultEntry -borderwidth 2
button .toCats -text "Translate to Cat Language" -command translateThis
.toCats configure -state normal
button .toEnglish -text "Translate back to English/Russian"
button .copyTranslation -text "Copy translation to clipboard" -command copyEverything
pack .thisTextLabel .thisTextEntry .becomesLabel .resultEntry .toCats .toEnglish .copyTranslation
wm title . "Cat Language Translator by Tim K/RoverAMD" 
