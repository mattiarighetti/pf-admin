# 

ad_page_contract {
    
    
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-09-21
    @cvs-id $Id$
} {
    expo_id:integer
} -properties {
} -validate {
} -errors {
}
set luogo [db_string query "select c.denominazione from comuni c, expo_edizioni e, expo_luoghi l where l.luogo_id = e.luogo_id and l.comune_id = c.comune_id and e.expo_id = :expo_id"]
set data [db_string query "select current_date"]
set f [open /tmp/pfexpo.csv w]
set header "Codice Iscritto;Nome;Cognome;Telefono;Email;Società;Data iscrizione;Portafoglio;Clienti;Attività"
for {set count 1} {$count <= [db_string query "select max(y.num) from (select count(i.iscrizione_id) as num from expo_iscrizioni i, expo_iscritti s where s.expo_id = :expo_id and i.iscritto_id = s.iscritto_id group by i.iscritto_id) as y"]} {incr count} {
    append header ";Evento $count"
}
puts $f $header
db_foreach query "select iscritto_id, nome, cognome, telefono, email, societa, to_char(data, 'DD/MM/YYYY')as data, portafoglio, clienti, attivita from expo_iscritti where expo_id = :expo_id" {
    set row "$iscritto_id;$nome;$cognome;$telefono;$email;$societa;$data;$portafoglio;$clienti;$attivita"
    db_foreach query "select e.denominazione, s.denominazione as sala, to_char(e.start_time, 'HH24:MI') as orario from expo_eventi e, expo_iscrizioni i, expo_sale s where i.iscritto_id = :iscritto_id and e.evento_id = i.evento_id and s.sala_id = e.sala_id" {
	append row ";$denominazione (in sala $sala alle $orario)"
    }    
    puts $f $row
}
close $f
ns_set update [ns_conn outputheaders] content-disposition "attachment; filename=iscritti-pfexpo-$luogo-al-$data.csv"
ns_returnfile 200 application/CSV /tmp/pfexpo.csv
ns_unlink /tmp/pfexpo.csv
ad_returnredirect iscritti-list
ad_script_abort
