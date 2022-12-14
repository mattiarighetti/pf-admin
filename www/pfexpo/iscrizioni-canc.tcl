ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    iscrizione_id:naturalnum
    return_url
}
pf::user_must_admin
with_catch errmsg {
    db_dml query "delete from expo_iscrizioni where iscrizione_id = :iscrizione_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la domanda. Si prega di tornare indietro e riprovare.</b>" 
    return
}
ad_returnredirect $return_url
ad_script_abort
