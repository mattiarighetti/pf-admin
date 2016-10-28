# 

ad_page_contract {
    
    
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-09-21
    @cvs-id $Id$
} {
    {award_id [pf::awards::id]}
} -properties {
} -validate {
} -errors {
}
set f [open /tmp/pfawards-promossi.csv w]
puts $f "Codice Persona;Nome;Cognome;Email;Categoria"
db_foreach query "select p.persona_id, pp.first_names, pp.last_name, pa.email, c.titolo from parties pa, crm_persone p, awards_esami_2 e, persons pp, awards_categorie c where c.categoria_id = e.categoria_id and p.user_id = pp.person_id and p.persona_id = e.persona_id and pa.party_id = p.user_id and e.award_id = :award_id" {
    puts $f "$persona_id;$first_names;$last_name;$email;$titolo"
}
close $f
set data [string map {- "" / ""} [db_string query "select current_date"]]
ns_set update [ns_conn outputheaders] content-disposition "attachment; filename=promossi-pfawards-al-$data.csv"
ns_returnfile 200 application/CSV /tmp/pfawards-promossi.csv
ns_unlink /tmp/pfawards-promossi.csv
ad_returnredirect esami-list
ad_script_abort
