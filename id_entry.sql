SELECT *
FROM  directories.elements a
JOIN directories.activities b
ON a.index = b.entry_id
JOIN directories.sources c
ON a.directory = c.code_fichier
WHERE b.entry_id = 4326729
AND a.view BETWEEN npage_pdf_d AND npage_pdf_f
AND liste_type = 'ListNoms'
ORDER BY published, directory, persons