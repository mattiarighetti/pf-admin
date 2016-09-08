ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    persona_id:integer
    esame_id:integer
}
pf::user_must_admin
with_catch errmsg {
    db_dml query "DELETE FROM awards_esami WHERE esame_id = :esame_id"
} {
    ad_return_complaint 1 "Si è verificato un errore nel cancellare le iscrizioni dell'utente selezionato. Si prega di tornare indietro e riprovare.<br><br>L'errore riportato dal database è il seguente:<br><code>$errmsg</code>" 
    return
}
ad_returnredirect [export_vars -base "iscritti-gest" {persona_id}]
ad_script_abort
