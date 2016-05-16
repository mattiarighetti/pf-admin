ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 25 November 2014
} {
    categoria_id:integer
}
set html "<html><table border=1 cellspacing=5 cellpadding=5>"
append html "<tr><td colspan=\"2\">DOMANDE<br><br><hr></td></tr>"
set titolo [db_string query "select titolo from awards_categorie where categoria_id = :categoria_id"]
append html "<tr><td colspan=\"2\"><center><u>$titolo (ID: $categoria_id)</u></center></td></tr>"
db_foreach query "select * from awards_domande_2 where categoria_id = :categoria_id order by categoria_id" {
    append html "<tr><td><strong>$domanda_id</strong></td><td><small>$testo</small></td>"
}
append html "<tr><td colspan=\"2\"><br><br></td></tr>"
append html "<tr><td colspan=\"2\"><br><hr><br></td></tr>"
append html "<tr><td colspan=\"2\">ESAMI<br><br><hr></td></tr>"
append html "<tr><td colspan=\"2\"><h1><u>$titolo</u></h1></td></tr>"
db_foreach query "SELECT e.esame_id, p.persona_id, p.nome||' '||p.cognome as nominativo, a.email FROM awards_esami_2 e, crm_persone p, parties a where p.persona_id = e.persona_id and categoria_id = :categoria_id and p.user_id = a.party_id ORDER BY p.cognome, e.esame_id" {
    append html "<tr><td colspan=\"2\"><center><br><big>ID Esame: #$esame_id</big><br>Credenziali: $nominativo <small>(Codice persona: $persona_id)</small><br>$email</br><br></center></td></tr>"
    if {[db_0or1row query "select * from awards_rispusr_2 where esame_id = :esame_id and risposta is not null limit 1"]} {
	db_foreach query "SELECT rispusr_id, domanda_id, risposta FROM awards_rispusr_2 WHERE esame_id = :esame_id ORDER BY rispusr_id" {
	    append html "<tr><td><strong>$domanda_id</strong></td><td><font face=\"Times New Roman\" size=\"3px\">$risposta</font><br><br></td></tr>"
	}
    } else {
	append html "<tr><td colspan=2><br><b>L'utente non ha risposto all'esame.</b></br></td></tr>"
    }
}
append html "<tr><td colspan=\"2\"><br></br><br></br></td></tr>"
append html "</html>"
set filenamehtml "/tmp/all-esami-print.html"
set filenamepdf  "/tmp/all-esami-print.pdf"
set file_html [open $filenamehtml w]
puts $file_html $html
close $file_html
with_catch error_msg {
    exec htmldoc --portrait --webpage --header ... --footer ... --quiet --left 0.5cm --right 0.5cm --top 0.5cm --bottom 0.5cm --fontsize 10 -f $filenamepdf $filenamehtml
} {
    ns_log notice "errore htmldoc  <code>$error_msg </code>"
}
ns_returnfile 200 application/pdf $filenamepdf
ns_unlink $filenamepdf
ns_unlink $filenamehtml
ad_script_abort
