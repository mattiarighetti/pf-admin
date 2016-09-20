ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 12 February 2015
} {
    iscritto_id:integer
}
set page_title "Registrazione"
set context ""
set table_html "<table class=\"table table-hover\"><tr><th>ID Evento</th><th>ID Iscrizione</th><th>Denominazione</th></tr>"
db_foreach query "select i.iscrizione_id, e.denominazione, e.evento_id from expo_eventi e, expo_iscrizioni i where i.iscritto_id = :iscritto_id and i.evento_id = e.evento_id" {
    append table_html "<tr><td>$evento_id</td><td>$iscrizione_id</td><td>$denominazione</td></tr>"
}
if {[db_0or1row query "select * from expo_iscritti where pagato is true and iscritto_id = :iscritto_id"]} {
    set pagamento_html "<div class=\"panel panel-default\"><h3>Stato pagamento: pagato.</h3></div>"
} else {
    set pagamento_html "<div class=\"panel panel-default\"><h3>Stato pagamento: non pagato.</h3><br></br><a class=\"btn btn-success\" href=\"pagato?iscritto_id=$iscritto_id\"><span class=\"glyphicon glyphicon-euro\"></span> Segna pagamento con voucher.</a></div>"
}
append table_html "</table>"
ad_return_template
