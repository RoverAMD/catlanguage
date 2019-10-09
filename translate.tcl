#!/usr/bin/env tclsh
set catLanguageConvertableSymbols {a b c d e f g h i j k l m n o p q r s t u v w x y z}
set catLanguageConvertableSymbols "$catLanguageConvertableSymbols [string toupper $catLanguageConvertableSymbols]"
lappend catLanguageConvertableSymbols 0 1 2 3 4 5 6 7 8 9 { }
lappend catLanguageConvertableSymbols . , ? ! "\{" "\}" "\[" "\]" ( ) {;} "\"" {'} "\\" / : @ {#} {$} % ^ & {*}
lappend catLanguageConvertableSymbols а б в г д е ё ж з и й к л м н о п р с т у ф х ц ч ш щ ъ ы ь э ю я
lappend catLanguageConvertableSymbols А Б В Г Д Е Ё Ж З И Й К Л М Н О П Р С Т У Ф Х Ц Ч Ш Щ Ъ Ы Ь Э Ю Я
set catLanguageEncodingMap [dict create 0 meow 1 mew 2 mow 3 meoow 4 meew 5 meooow 6 purr 7 purrr 8 shhhh 9 meoooow . ,]

proc _encodingMap {str} {
    global catLanguageEncodingMap
    set result ""
    for {set index 0} {$index < [string length $str]} {incr index} {
        set converted [dict get $catLanguageEncodingMap [string index $str $index]]
        set result "$result $converted"
    }
    return [string map {{ , } {, }} [string trim $result]]
}

proc _unencodingMap {el} {
    global catLanguageEncodingMap
    dict for {key val} $catLanguageEncodingMap {
        if {$val == $el} {
            return $key
        }
    }
    return 0
}


proc unmeow {str} {
    set encodingMapSplit [split [string map {{, } {,} { } .} $str] ,]
    set toJoin {}
    foreach el $encodingMapSplit {
        set prtJoined ""
        foreach prt [split $el .] {
            set prtJoined "$prtJoined[_unencodingMap [string trim $prt]]"
        }
        lappend toJoin $prtJoined
    }
    set result ""
    global catLanguageConvertableSymbols
    foreach el $toJoin {
        set result "$result[lindex $catLanguageConvertableSymbols $el]"
    }
    return $result
}

proc meowify {str} {
    global catLanguageConvertableSymbols
    set resultList {}
    for {set index 0} {$index < [string length $str]} {incr index} {
        set character [string index $str $index]
        set characterEncoded [lsearch -exact $catLanguageConvertableSymbols $character]
        if {$characterEncoded < 0} {
            set characterEncoded [lsearch -exact $catLanguageConvertableSymbols ?]
        }
        lappend resultList $characterEncoded
    }
    set result [_encodingMap [join $resultList .]]
    return $result
}

if {[file rootname $::argv0] == [file rootname [info script]]} {
    set stringToConv ""
    if {$::argc < 2} {
        puts "Usage: tclsh [info script] -e <your string in English or Russian>"
        puts "       tclsh [info script] -d <your string in Cat Language>"
        exit 1
    }
    set flag [lindex $::argv 0]
    set textV [lindex $::argv 1]
    if {$flag != {-e} && $flag != {-d}} {
        puts "Only \"-e\" and \"-d\" flags are supported."
        exit 2
    }
    if {$flag == {-e}} {
        puts [meowify $textV]
    } else {
        puts [unmeow $textV]
    }
    exit 0
}
