ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 June 2015
    @cvs-id processing-delete.tcl
} {
    voucher_id:integer
}
with_catch errmsg {
    db_dml query "delete from expo_voucher where voucher_id = :voucher_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare il voucher. &Egrave; possibile che sia già stato utilizzato.</br>In particolare, l'errore riportato dal database è il seguente.</br></br><code>$errmsg</code>"
}
ad_returnredirect voucher-list
ad_script_abort
