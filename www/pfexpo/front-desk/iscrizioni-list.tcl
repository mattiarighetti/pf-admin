ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 12 February 2015
} {
    iscritto_id:integer
}
set page_title "Registrazione"
set context ""

if {[db_0or1row query "select * from expo_iscritti where pagato is true and iscritto_id = :iscritto_id"]} {
    set pagamento_html "<div class=\"panel panel-default\"><h3>Stato pagamento: pagato.</h3></div>"
} else {
    set pagamento_html "<div class=\"panel panel-default\"><h3>Stato pagamento: non pagato.</h3><br></br><a class=\"btn btn-success\" href=\"pagato?iscritto_id=$iscritto_id\"><span class=\"glyphicon glyphicon-euro\"></span> Segna pagamento con voucher.</a></div>"
}
append table_html "</table>"
ad_return_template
