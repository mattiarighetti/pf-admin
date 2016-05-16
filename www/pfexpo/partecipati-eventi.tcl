ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    orderby:optional
    iscritto_id:naturalnum
    {return_url ""}
}
pf::user_must_admin
set page_title [db_string query "select initcap(lower(cognome))||' '||initcap(lower(nome)) from expo_iscritti where iscritto_id = :iscritto_id"] 
#set context [list [list ?module=pfexpo "PFEXPO"] $page_title]
set admin_menu [pf::admin_menu "pfexpo"]
template::list::create \
    -name eventi \
    -multirow eventi \
    -elements {	
        evento_id {
            label "ID"
        }
	denominazione {
	    label "Denominazione"
	}
    } 
db_multirow \
    -extend {
    } eventi query "select distinct(e.evento_id), e.denominazione from expo_eventi e, expo_presenze p where e.evento_id = p.evento_id and p.iscritto_id = :iscritto_id [template::list::filter_where_clauses -name eventi -and] [template::list::orderby_clause -name eventi -orderby]" {
    }
