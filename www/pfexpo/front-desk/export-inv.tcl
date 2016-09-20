ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 12 February 2015
} 
set page_title "Registrazione PFEXPO 2015 Roma"
set table_html ""
db_foreach query "select investitore_id, initcap(lower(nome)) as nome, initcap(lower(cognome)) as cognome, email, barcode from expo_investitori" {
    #Calcolo checksum
    
    #Estrazione corsi da passare a DYMO LABEL
    set courses ""
    db_foreach query "select e.short_title, s.denominazione as sala, to_char(e.start_time, 'HH24:MI') as start_time from expo_eventi e, expo_eventi_investitori i, expo_sale s where e.evento_id = i.evento_id and i.investitore_id = :investitore_id and s.sala_id = e.sala_id order by e.start_time" {
	append courses "- " $short_title" (" $sala ", " $start_time ");"
    }
    #Toglie ultimo br, inutile
    #set courses [string trimright $courses "<br />"]
    append table_html $barcode ";" [string map {' &rsquo;} $nome] ";" [string map {' &rsquo;} $cognome] ";" [string map {' &rsquo; "\"" ""} $courses] "<br>"
}


ad_return_complaint 1 $table_html
