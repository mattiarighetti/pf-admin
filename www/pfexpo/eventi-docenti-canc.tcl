ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 June 2015
    @cvs-id processing-delete.tcl
} {
    evento_id:integer    
    docente_id:integer
}
pf::user_must_admin
with_catch errmsg {
    db_dml query "delete from expo_eve_doc where evento_id = :evento_id and docente_id = :docente_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la relazione.</br>L'errore riportato dal database è il seguente.</br></br><code>$errmsg</code>"
    return
}
ad_returnredirect [export_vars -base "eventi-docenti-list" {evento_id}]
ad_script_abort
