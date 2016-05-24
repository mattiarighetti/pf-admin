ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 June 2015
    @cvs-id processing-delete.tcl
} {
    evento_id:integer    
    speaker_id:integer
}
pf::user_must_admin
with_catch errmsg {
    db_dml query "delete from expo_eventi_speakers where evento_id = :evento_id and speaker_id = :speaker_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la relazione.</br>L'errore riportato dal database è il seguente.</br></br><code>$errmsg</code>"
    return
}
ad_returnredirect [export_vars -base "eventi-speakers-list" {evento_id}]
ad_script_abort
