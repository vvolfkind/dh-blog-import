<?php

function dd($param)
{
    echo "<pre>";
    die(var_dump($param));
}

function BrasilConnect()
{
    try {
        $pdo = new PDO();
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
        return $pdo;
    } catch (PDOException $e) {
        die($e->getMessage());
    }
}

function ArgentolandiaConnect()
{
    try {
        $pdo = new PDO();
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
        return $pdo;
    } catch (PDOException $e) {
        die($e->getMessage());
    }
}
// meta_tags, columnas name, parent_type, parent_id
//Connectores
$brasil = BrasilConnect();
$argenta = ArgentolandiaConnect();

// Queries
$stmt = $brasil->prepare("SELECT DISTINCT
                            p.ID            AS id,
                            p.post_title    AS title,
                            p.post_status   AS status,
                            p.post_date     AS created_at,
                            p.post_modified AS updated_at,
                                (SELECT group_concat(t.name SEPARATOR ', ')
                                    FROM Shny66_terms t
                                        LEFT JOIN Shny66_term_taxonomy tt ON t.term_id = tt.term_id
                                        LEFT JOIN Shny66_term_relationships tr ON tr.term_taxonomy_id = tt.term_taxonomy_id
                                    WHERE tt.taxonomy = 'category' AND p.ID = tr.object_id
                                )               
                                AS category,
                                (SELECT group_concat(t.name SEPARATOR ', ')
                                    FROM Shny66_terms t
                                        LEFT JOIN Shny66_term_taxonomy tt ON t.term_id = tt.term_id
                                        LEFT JOIN Shny66_term_relationships tr ON tr.term_taxonomy_id = tt.term_taxonomy_id
                                    WHERE tt.taxonomy = 'post_tag' AND p.ID = tr.object_id
                                )               
                                AS tag
                            FROM Shny66_posts p
                            WHERE p.post_type = 'post'
                            AND p.post_status = 'publish'");

$stmt->execute();
$postsBrasil = $stmt->fetchAll(PDO::FETCH_ASSOC);
$postsBrasil = array_map(function($p) {
    return [
        'post_id' => $p['id'],
        'tags' => explode(', ', $p['tag'])
    ];
}, $postsBrasil);

$insert = $argenta->prepare("INSERT INTO meta_tags (name, parent_type, parent_id) VALUES (:name, :parent_type, :parent_id)");

foreach($postsBrasil as $postinho) {
    $id = $postinho['post_id'];
    $post = 'posts';
    foreach($postinho['tags'] as $tag) {
        if($tag == null || $tag == false || $tag == "") {
            continue;
        }
        $tagUTF8 = utf8_encode($tag);
        $insert->bindParam(':name', $tagUTF8, PDO::PARAM_STR);
        $insert->bindParam(':parent_type', $post, PDO::PARAM_STR);
        $insert->bindParam(':parent_id', $id, PDO::PARAM_INT);
        $insert->execute();
    }
}
