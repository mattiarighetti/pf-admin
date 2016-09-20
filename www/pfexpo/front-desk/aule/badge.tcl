ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 12 February 2015
} {
    evento_id:integer
    {q ""}
}
set page_title "Registrazione PFEXPO"
set context ""
set evento [db_string query "select denominazione from expo_eventi where evento_id = :evento_id"]
set focus "cerca.q"
template::head::add_javascript -script {
    document.getElementById("q").focus();
}
ad_form -name "cerca" \
    -mode edit \
    -export {evento_id} \
    -form {
	{q:text(text)
	}
    } -on_submit {
	if {[string length $q] == 13} {
	    set q [string range $q 0 11]
	}
	if {[db_0or1row query "select * from expo_iscritti where barcode like :q limit 1"]} {
	    set iscritto_id [db_string query "select iscritto_id from expo_iscritti where barcode ilike :q limit 1"]
	    db_dml query "insert into expo_presenze (evento_id, iscritto_id, timestamp) values (:evento_id, :iscritto_id, current_timestamp)"
	} else {
	    db_dml query "insert into expo_presenze (evento_id, barcode, timestamp) values (:evento_id, :q, current_timestamp)"
	}
    } -after_submit {
	ad_returnredirect "badge?evento_id=$evento_id"
    }
set table_html "<table class=\"table table-condensed\"><tr><th>ID iscritto</th><th>Cognome e Nome</th><th>Ora</th><th>Note</th></tr>"
db_foreach query "select i.iscritto_id, i.cognome||' '||i.nome as nominativo, p.timestamp,case when s.soldout is true then '<b><big>LISTA ATTESA</big></b>' else '' end as attesa from expo_iscritti i, expo_presenze p, expo_iscrizioni s where p.iscritto_id = i.iscritto_id and s.iscritto_id = i.iscritto_id and p.evento_id = :evento_id order by p.timestamp desc" {
    append table_html "<tr><td>$iscritto_id</td><td>$nominativo</td><td>$timestamp</td><td>$attesa</td></tr>"
}
append table_html "</table>"
