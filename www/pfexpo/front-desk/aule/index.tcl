ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 12 February 2015
}
pf::user_must_admin
set page_title "Registrazione PFEXPO 2015 Roma"
set context ""
if {[db_0or1row query "select * from expo_edizioni where attivo is true limit 1"]} {
    set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
} else {
    ad_return_complaint 1 "Non risultano edizioni PFEXPO attive."
}
set table_html "<table class=\"table table-hover\"><tr><th>SALA</th><th>&nbsp;</th></tr>"
db_foreach query "select s.denominazione, s.sala_id from expo_sale s left outer join expo_eventi e on s.sala_id = e.sala_id and e.expo_id = :expo_id  where e.expo_id = :expo_id group by s.sala_id, s.denominazione order by s.denominazione" {
    append table_html "<tr><td>$denominazione</td><td><td><a class=\"btn btn-success\" href=\"eventi?sala_id=$sala_id\">VAI</a></td></tr>"
}
ad_return_template
