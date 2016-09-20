ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    persona_id:integer
}
pf::user_must_admin
set award_id [db_string query "select award_id from awards_edizioni where attivo is true limit 1"]
with_catch errmsg {
    db_dml query "DELETE FROM awards_esami WHERE persona_id = :persona_id and award_id = :award_id"
} {
    ad_return_complaint 1 "Si è verificato un errore nel cancellare le iscrizioni dell'utente selezionato. Si prega di tornare indietro e riprovare.<br><br>L'errore riportato dal database è il seguente:<br><code>$errmsg</code>" 
    return
}
ad_returnredirect "iscritti-list"
ad_script_abort
