ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Sunday 14 June 2015
    @cvs-id processing-delete.tcl
    @param genere_id The id to delete
} {
    docente_id:integer
}
pf::user_must_admin
with_catch errmsg {
    if {[db_0or1row query "select immagine from docenti where docente_id = :docente_id"]} {
	with_catch error_message {
	    set immagine [db_string query "select immagine from docenti where docente_id = :docente_id"]
	    exec rm -rf /usr/share/openacs/packages/images/www/docenti/$immagine
	    db_dml query "delete from docenti where docente_id = :docente_id"
	} {
	    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare il docente, probabilmente è ancora referenziato da qualche altra tabella.</b><br>L'errore riportato dal sistema è il seguente.</br></br><code>$error_message</code>"
	}
    }
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare il partner, probabilmente è ancora referenziato da qualche altra tabella.</b><br>L'errore riportato dal database è il seguente.<br><br><code$errmsg</code>"
    return
}
ad_returnredirect "docenti-list"
ad_script_abort
