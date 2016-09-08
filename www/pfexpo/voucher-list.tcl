ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    expo_id:integer,optional
    orderby:optional
}
pf::user_must_admin
set page_title "Voucher"
set context [list [list /pfexpo "PFEXPO"] $page_title]
if {![info exist expo_id]} {
    set expo_id [ad_get_cookie expo_id]
}
set actions [list "Nuovo voucher" voucher-gest "Aggiunge un nuovo voucher."]
template::list::create \
    -name voucher \
    -no_data "Nessun voucher registrato per questo PFEXPO." \
    -multirow voucher \
    -actions $actions \
    -elements {
	codice {
	    label "Voucher"
	}
	denominazione {
	    label "Eventi"
	}
	times {
	    label "Utilizzi"
	    link_url_col times_url
	}
	discount {
	    label "Sconto"
	}
	expiry_date {
	    label "Scadenza"
	}
	creation_date {
	    label "Creazione"
	}
	utilizzazioni {
	    label "Usati"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="http://images.professionefinanza.com/icons/edit.gif" height="12" border="0">}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella l'evento." onClick "return(confirm('Sei davvero sicuro di voler cancellare l'evento?'));"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value creation_date
	creation_date {
	    label "Creazione"
	    orderby creation_date
	}
	codice {
	    label "Codice"
	    orderby codice
	}
	discount {
	    label "Sconto"
	    orderby discount
	}
    }
db_multirow \
    -extend {
	edit_url
	times_url
	delete_url
    } voucher query "select v.voucher_id, v.evento_id, v.times, v.discount||'%' as discount, v.codice, to_char(v.creation_date, 'DD/MM/YYYY HH24:MI') as creation_date, to_char(v.expiry_date, 'DD/MM/YYYY') as expiry_date,e.denominazione, count(distinct(i.iscritto_id)) as utilizzazioni from expo_voucher v left outer join expo_eventi e on e.evento_id = v.evento_id left outer join expo_iscrizioni i on v.voucher_id = i.voucher_id [template::list::filter_where_clauses -name voucher] GROUP BY v.voucher_id, e.denominazione [template::list::orderby_clause -name voucher -orderby]" {
	set edit_url [export_vars -base "voucher-gest" {voucher_id}]
	set times_url [export_vars -base "voucher-times-list" {voucher_id}]
	set delete_url [export_vars -base "voucher-canc" {voucher_id}]
    }
