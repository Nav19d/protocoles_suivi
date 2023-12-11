-- gn_monitoring.v_export_sittelles_standard source

CREATE OR REPLACE VIEW gn_monitoring.v_export_sittelles_standard
AS SELECT tsg.sites_group_name AS cluster,
    tbs.base_site_name AS "Point d'ecoute",
    concat(tsg.sites_group_name, tbs.base_site_name) AS "ID point d'ecoute",
    concat(concat(tsg.sites_group_name, tbs.base_site_name), tvc.data -> 'year'::text) AS id_source,
    tvc.data -> 'year'::text AS annee,
    tbv.visit_date_min AS date_min,
    tsg.data -> 'strates'::text AS strates,
    tvc.data -> 'time_observation1'::text AS "heureDebut",
    tvc.data -> 'time_observation2'::text AS "heureFin",
    tvc.data -> 'time_to_detection'::text AS "Temps de detection",
    tvc.data -> 'statut_obs'::text AS "statutObservation",
    tvc.data -> 'Occcomportement'::text AS "occComportement",
    concat('Vent : ', tvc.data -> 'Vent'::text, ', ', 'Pluie : ', tvc.data -> 'Pluie'::text, ', ', 'Temperature : ', tvc.data -> 'Temperature'::text, ', ', 'Couverture nuageuse : ', tvc.data -> 'Couverture_Nuageuse'::text) AS comment_context,
    tbv.comments AS comment,
    st_astext(tbs.geom) AS geometry,
    concat(tr.nom_role, ' ', tr.prenom_role) AS "identiteObservateur",
    tvc.data -> 'cd_nom'::text AS "cdNom",
    tvc.data -> 'nom_latin'::text AS "nomCite",
    tbv.uuid_base_visit as uuid
   FROM gn_monitoring.t_visit_complements tvc
     JOIN gn_monitoring.t_base_visits tbv ON tvc.id_base_visit = tbv.id_base_visit
     JOIN gn_monitoring.t_base_sites tbs ON tbs.id_base_site = tbv.id_base_site
     JOIN gn_monitoring.t_site_complements tsc ON tsc.id_base_site = tbs.id_base_site
     JOIN gn_monitoring.t_sites_groups tsg ON tsg.id_sites_group = tsc.id_sites_group
     JOIN gn_commons.t_modules tm ON tm.id_module = tsg.id_module
     JOIN gn_monitoring.cor_visit_observer cvo ON cvo.id_base_visit = tbv.id_base_visit
     JOIN utilisateurs.t_roles tr ON tr.id_role = cvo.id_role
  WHERE tm.module_code::text = 'Sittelles'::text;

-- Permissions

ALTER TABLE gn_monitoring.v_export_sittelles_standard OWNER TO geonatadmin;
GRANT ALL ON TABLE gn_monitoring.v_export_sittelles_standard TO geonatadmin;