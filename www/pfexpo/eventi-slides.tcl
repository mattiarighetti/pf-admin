ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 3 February 2016
} {
    evento_id:integer,optional
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
}
set page_title "Slides - PFEXPO"
set context [list [list /pfexpo "PFEXPO"] [list speakers-list "Speakers"] $page_title]
set evento [db_string query "select denominazione from expo_eventi where evento_id = :evento_id"]
ad_form -name materiale \
    -has_edit 1 \
    -html {enctype "multipart/form-data"} \
    -form {
	evento_id:key
	{upload_file:text(file)
	    {help_text "DEVE ESSERE IN PDF."}
	    {label "PDF"}
	}
    } -select_query {
	"SELECT evento_id, materiali AS upload_file FROM expo_eventi WHERE evento_id = :evento_id"
    } -on_submit {
	db_transaction {
	    set permalink [db_string query "select permalink from expo_eventi where evento_id = :evento_id"]
	    set slug [db_string query "select e.permalink from expo_edizioni e, expo_eventi i where i.evento_id = :evento_id and e.expo_id = i.expo_id"]
	    regsub -all {\\} $upload_file "<" upload_file
	    if {[string match *.pdf $upload_file] || [string match *.PDF $upload_file]} {
		set file_name $permalink
		append file_name "_" $slug ".pdf"
	    } else {
		ad_return_complaint 1 "IL FILE SOTTOMESSO NON &EGRAVE; IN FORMATO PDF."
	    }
	    set filepath [ns_queryget upload_file.tmpfile]
	    ns_rename $filepath /usr/share/openacs/packages/images/www/pfexpo/slides/$file_name
	    set file_url "http://images.professionefinanza.com/pfexpo/slides/"
	    append file_url $file_name
	    db_dml query "UPDATE expo_eventi SET materiali = :file_url WHERE evento_id = :evento_id"
	}
    } -after_submit {
	ad_returnredirect "eventi-list"
	ad_script_abort
    }
