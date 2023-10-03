WITH per_count AS (
			SELECT e.index, (length(e.ner_xml) - length(replace(e.ner_xml, '<PER>', '' ))) / length('<PER>') AS count_
			FROM directories.elements AS e
			ORDER BY count_ DESC
		), short_list AS ( --Ne conserve que les entrées avec 0 ou 1 PER (au delà, on aura un produit cartésien de tous les attributs)
			SELECT pc.index
			FROM per_count AS pc
			WHERE count_ <=1)
	SELECT DISTINCT e.index, p.ner_xml AS person, TRANSLATE(act.ner_xml,'éëèêàç','eeeeac') AS activity, soundex(act.ner_xml) AS actsoundex, s.loc AS loc, s.cardinal AS cardinal,
	t.ner_xml AS title, e.directory, e.published, lower((COALESCE(s.loc,'') || ' '::text) || COALESCE(s.cardinal,'')) AS fulladd
	FROM short_list AS l
	INNER JOIN directories.elements AS e ON l.index = e.index
	INNER JOIN directories.persons AS p ON e.index = p.entry_id
	INNER JOIN directories.activities AS act ON e.index = act.entry_id
	INNER JOIN directories.addresses AS s ON e.index = s.entry_id
	INNER JOIN directories.titles AS t ON e.index = t.entry_id
	WHERE (
		(e.published>1844 AND e.published<1886) AND
		-- Liste des mots-clés: à adapter!
		(TRANSLATE(act.ner_xml,'éëèêàç','eeeeac') ILIKE '%ebeniste%' OR 
		 TRANSLATE(act.ner_xml,'éëèêàç','eeeeac') ILIKE '%cbeniste%')
		)
	ORDER BY e.index, e.published ASC;