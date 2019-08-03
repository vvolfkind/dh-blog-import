SELECT DISTINCT   
    Shny66_posts.ID as ID, Shny66_posts.post_date as post_date, Shny66_posts.post_content as post_content, Shny66_posts.post_title as post_title, Shny66_posts.post_status as post_status, Shny66_posts.post_name as post_name, Shny66_posts.post_type as post_type,    
        (SELECT GROUP_CONCAT(Shny66_terms.name) from Shny66_term_relationships
            LEFT JOIN Shny66_term_taxonomy ON(Shny66_term_relationships.term_taxonomy_id = Shny66_term_taxonomy.term_taxonomy_id)
            LEFT JOIN Shny66_terms ON (Shny66_term_taxonomy.term_id = Shny66_terms.term_id)
        WHERE Shny66_posts.ID = Shny66_term_relationships.object_id AND Shny66_term_taxonomy.taxonomy = 'post_tag') as post_category,
        (SELECT GROUP_CONCAT(Shny66_terms.name) from Shny66_term_relationships
            LEFT JOIN Shny66_term_taxonomy ON (Shny66_term_relationships.term_taxonomy_id = Shny66_term_taxonomy.term_taxonomy_id)
            LEFT JOIN Shny66_terms ON(Shny66_term_taxonomy.term_id = Shny66_terms.term_id)
        WHERE Shny66_posts.ID = Shny66_term_relationships.object_id AND Shny66_term_taxonomy.taxonomy = 'tags') as post_tags
    FROM Shny66_posts
    WHERE Shny66_posts.post_status = 'publish' AND Shny66_posts.post_type = 'post'


SELECT Shny66_posts.ID, Shny66_posts.post_date, Shny66_posts.post_content, Shny66_posts.post_title, Shny66_posts.post_status, Shny66_posts.post_name, Shny66_posts.post_type, 



SELECT wp_posts.post_content, wp_posts.ID, wp_terms.slug

FROM wp_posts

# Cant figure out how to join the tables
INNER JOIN wp_postmeta
ON wp_posts.ID = wp_postmeta.post_id

INNER JOIN wp_term_relationships
ON wp_posts.ID = wp_term_relationships.object_id

INNER JOIN wp_term_taxonomy
ON wp_term_relationships.term_taxonomy_id = wp_term_taxonomy.term_taxonomy_id

INNER JOIN wp_terms
ON wp_term_taxonomy.term_id = wp_terms.term_id




WHERE
wp_posts.post_type = 'my-own-post-type'         # Only get specific post-type
AND
wp_posts.post_status = 'publish'                # Only get published posts


SELECT p.ID 
FROM wp_posts p 
INNER JOIN wp_term_relationships tr ON (p.ID = tr.object_id) 
INNER JOIN wp_term_taxonomy tt ON (tr.term_taxonomy_id = tt.term_taxonomy_id) 
INNER JOIN wp_terms t ON (tt.term_id = t.term_id) 
WHERE tt.taxonomy = 'post_tag' 


SELECT
    p.id,
    p.post_name,
    c.name,
    GROUP_CONCAT(t.`name`)
FROM Shny66_posts p
JOIN Shny66_term_relationships cr
    on (p.`id`=cr.`object_id`)
JOIN Shny66_term_taxonomy ct
    on (ct.`term_taxonomy_id`=cr.`term_taxonomy_id`
    and ct.`taxonomy`='category')
JOIN Shny66_terms c on
    (ct.`term_id`=c.`term_id`)
JOIN Shny66_term_relationships tr
    on (p.`id`=tr.`object_id`)
JOIN Shny66_term_taxonomy tt
    on (tt.`term_taxonomy_id`=tr.`term_taxonomy_id`
    and tt.`taxonomy`='post_tag')
JOIN Shny66_terms t
    on (tt.`term_id`=t.`term_id`)
GROUP BY p.id



SELECT DISTINCT
  p.ID            AS id,
  p.post_title    AS title,
  p.post_author   AS user,
  p.post_content  AS content,
  p.post_excerpt  AS intro,
  p.post_status   AS status,
  p.post_date     AS created_at,
  p.post_modified AS updated_at,
  (SELECT group_concat(p.guid SEPARATOR ', ')
   FROM wp_postmeta pm
     LEFT JOIN wp_posts p ON pm.meta_value = p.ID
   WHERE pm.post_id = 17917 AND pm.meta_key = '_thumbnail_id' AND p.post_type = 'attachment'
  )               AS image,
  (SELECT group_concat(pm.meta_value SEPARATOR ', ')
   FROM wp_posts p
     LEFT JOIN wp_postmeta pm ON pm.meta_key = 'views' AND pm.post_id = p.ID
   WHERE p.ID = 17917
  )               AS views,
  (SELECT group_concat(t.name SEPARATOR ', ')
   FROM wp_terms t
     LEFT JOIN wp_term_taxonomy tt ON t.term_id = tt.term_id
     LEFT JOIN wp_term_relationships tr ON tr.term_taxonomy_id = tt.term_taxonomy_id
   WHERE tt.taxonomy = 'category' AND p.ID = tr.object_id
  )               AS category,
  (SELECT group_concat(t.name SEPARATOR ', ')
   FROM wp_terms t
     LEFT JOIN wp_term_taxonomy tt ON t.term_id = tt.term_id
     LEFT JOIN wp_term_relationships tr ON tr.term_taxonomy_id = tt.term_taxonomy_id
   WHERE tt.taxonomy = 'post_tag' AND p.ID = tr.object_id
  )               AS tag
FROM wp_posts p
WHERE p.post_type = 'post'
ORDER BY p.post_date DESC
LIMIT 3