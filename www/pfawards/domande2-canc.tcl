ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    domanda_id:integer
}
pf::user_must_admin
with_catch errmsg {
    db_dml query "DELETE FROM awards_domande_2 WHERE domanda_id = :domanda_id"
} {
    ad_return_complaint 1 "Si è verificato un errore nel cancellare il quesito selezionato. Si prega di tornare indietro e riprovare.<br><br>L'errore riportato dal database è il seguente:<br><code>$errmsg</code>" 
    return
}
ad_returnredirect "domande2-list"
ad_script_abort
