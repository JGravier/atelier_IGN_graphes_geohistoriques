SET SEARCH_PATH=directories_v2, public;

WITH filtered_activities AS (
	SELECT * 
	FROM activities 
	WHERE /* ************************************************************* */
		/* Modifier la liste des mots-clés selon les données à extraire  */
		/* ************************************************************* */
		(
		(act ILIKE '%ébeniste%' OR 
		act ILIKE '%ebeniste%' OR 
		act ILIKE '%ébéniste%' OR 
		act ILIKE '%ebéniste%' OR 
		act ILIKE '%cbéniste%' OR 
		act ILIKE '%bemste%' OR 
		act ILIKE '%bémste%' OR 
		act ILIKE '%cbeniste%')
		)
)
SELECT  entries.uuid, 
		entries.ner_xml, 
		per, 
		titre, 
		act, 
		loc, 
		cardinal,  
		trim(concat(cardinal, ' ', loc)) AS fulladd, 
		sources.code_ouvrage, 
		sources.liste_annee, 
		sources.liste_type
FROM filtered_activities 
JOIN entries
ON filtered_activities.entry_uuid = entries.uuid
AND filtered_activities.source = entries.source
JOIN sources
ON entries.source_uuid = sources.uuid
JOIN addresses
ON addresses.entry_uuid = filtered_activities.entry_uuid
AND addresses.source = filtered_activities.source
LEFT JOIN LATERAL (
	SELECT string_agg(per, ',') AS per
	FROM persons
	WHERE persons.entry_uuid = filtered_activities.entry_uuid
	AND persons.source = filtered_activities.source
	AND per IS NOT NULL
	GROUP BY entry_uuid
) AS persons
ON True
LEFT JOIN LATERAL (
	SELECT string_agg(titre, ',') AS titre
	FROM titles
	WHERE titles.entry_uuid = filtered_activities.entry_uuid
	AND titles.source = filtered_activities.source
	AND titre IS NOT NULL
	GROUP BY entry_uuid
) AS titles
ON True
WHERE (sources.liste_type = 'ListNoms' AND ((sources.liste_annee>1844 AND sources.liste_annee<1886)))