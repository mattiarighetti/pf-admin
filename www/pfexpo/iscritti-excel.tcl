# 

ad_page_contract {
    
    Programma per l'estrazione Excel degli iscritti all'expo attivo.
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-05-24
    @cvs-id $Id$
} {
    expo_id:naturalnum
} -properties {
} -validate {
} -errors {
}
with_catch errmsg {
    exec psql -d openacs -U www-data -c "copy (SELECT p.iscritto_id as ID, INITCAP(LOWER(p.nome)) AS Nome, INITCAP(LOWER(p.cognome)) AS Cognome, p.email as Email, p.societa as Società, COUNT(i.evento_id) as Tot_eventi, p.data as Data_Iscr FROM expo_iscritti p LEFT OUTER JOIN expo_iscrizioni i ON p.iscritto_id = i.iscritto_id WHERE p.expo_id = $expo_id group by p.iscritto_id, p.nome, p.cognome, p.email, p.societa, p.pagato, p.data) to '/tmp/iscritti.csv' delimiter ';' csv header"
} {
    ad_return_complaint 1 "Si è verificato un errore nell'estrazione degli iscritti.<br>L'errore ritornato da database è il seguente:<br><code>$errmsg</code>"
}
ns_set update [ns_conn outputheaders] content-disposition "attachment; filename=iscritti.csv" 
ns_returnfile 200 application/CSV /tmp/iscritti.csv
ns_unlink /tmp/iscritti.csv
ad_returnredirect iscritti-list
ad_script_abort
