ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 12 February 2015
} {
    sala_id:integer
}
pf::user_must_admin
set page_title "Registrazione PFEXPO 2015 Roma"
set context ""
if {[db_0or1row query "select * from expo_edizioni where attivo is true limit 1"]} {
    set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
} else {
    ad_return_complaint 1 "Non risultano edizioni PFEXPO attive."
}
set sala [db_string query "select denominazione from expo_sale where sala_id = :sala_id"]
set table_html "<table class=\"table table-hover\"><tr><th>Evento</th><th>Sala</th><th>Inizio</th><th>Fine</th><th>&nbsp;</th></tr>"
db_foreach query "select e.denominazione, e.evento_id, s.denominazione as sala, to_char(e.start_time, 'HH24:MI') as start_time, to_char(e.end_time, 'HH24:MI') as end_time from expo_eventi e, expo_sale s where e.sala_id = s.sala_id and e.expo_id = :expo_id and s.sala_id = :sala_id order by e.start_time" {
    append table_html "<tr><td>$denominazione</td><td>$start_time</td><td>$end_time</td><td><a class=\"btn btn-success\" href=\"badge?evento_id=$evento_id\">VAI</a></td></tr>"
}
ad_return_template
