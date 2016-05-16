ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    iscritto_id:integer
}
pf::user_must_admin
with_catch errmsg {
    db_dml query "DELETE FROM expo_iscrizioni WHERE iscritto_id = :iscritto_id"
    db_dml query "DELETE FROM expo_iscritti WHERE iscritto_id = :iscritto_id"
} {
    ad_return_complaint 1 "Si è verificato un errore nel cancellare le iscrizioni dell'utente selezionato. Si prega di tornare indietro e riprovare." 
    return
}
ad_returnredirect "iscritti-list"
ad_script_abort
