WITH per_count AS (
			SELECT e.index, (length(e.ner_xml) - length(replace(e.ner_xml, '<PER>', '' ))) / length('<PER>') AS count_
			FROM directories.elements AS e
			ORDER BY count_ DESC
		), short_list AS ( --Ne conserve que les entrées avec 0 ou 1 PER (au delà, on aura un produit cartésien de tous les attributs)
			SELECT pc.index
			FROM per_count AS pc
			WHERE count_ <=1)
	SELECT DISTINCT e.index, TRANSLATE(p.ner_xml,'éëèêàçôö,.:;\-_\(\)\[\]?!$&','eeeeacoo') AS person, TRANSLATE(act.ner_xml,'éëèêàçôö,.:;\-_\(\)\[\]?!$&','eeeeacoo') AS activity, soundex(act.ner_xml) AS actsoundex, s.loc AS loc, s.cardinal AS cardinal,
	-- change TRANSLATE in unaccent()
	t.ner_xml AS title, e.directory, e.published, w.liste_type, TRANSLATE(lower((COALESCE(s.loc,'') || ' '::text) || COALESCE(s.cardinal,'')),'éëèêàçôö,.:;\-_\(\)\[\]?!$&','eeeeacoo') AS fulladd
	FROM short_list AS l
	INNER JOIN directories.elements AS e ON l.index = e.index
	INNER JOIN directories.persons AS p ON e.index = p.entry_id
	INNER JOIN directories.activities AS act ON e.index = act.entry_id
	INNER JOIN directories.addresses AS s ON e.index = s.entry_id
	INNER JOIN directories.titles AS t ON e.index = t.entry_id
	INNER JOIN directories.sources AS w ON e.directory = w.code_fichier 
	WHERE (
		(e.published>1844 AND e.published<1886) AND
		-- Liste des mots-clés: à adapter!
		(e.view BETWEEN w.npage_pdf_d AND w.npage_pdf_f) AND
        (w.liste_type ILIKE '%ListNoms%') AND
		(act.ner_xml ILIKE '%ébeniste%' OR 
		act.ner_xml ILIKE '%ebeniste%' OR 
		act.ner_xml ILIKE '%ébéniste%' OR 
		act.ner_xml ILIKE '%ebéniste%' OR 
		act.ner_xml ILIKE '%cbéniste%' OR 
		act.ner_xml ILIKE '%bemste%' OR 
		act.ner_xml ILIKE '%bémste%' OR 
		 act.ner_xml ILIKE '%cbeniste%')
		)
	ORDER BY e.index, e.published ASC;