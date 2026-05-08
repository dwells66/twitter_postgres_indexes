/*
 * Calculates the hashtags that are commonly used for English tweets containing the word "coronavirus"
 */

SELECT
    CONCAT('#', tag) AS tag,
    COUNT(*) AS count
FROM (
    SELECT DISTINCT
        t.data->>'id' AS tweet_id,
        h->>'text' AS tag
    FROM tweets_jsonb t,
         jsonb_array_elements(
             COALESCE(
                 t.data->'entities'->'hashtags',
                 '[]'::jsonb
             )
             ||
             COALESCE(
                 t.data->'extended_tweet'
                        ->'entities'
                        ->'hashtags',
                 '[]'::jsonb
             )
         ) h
    WHERE (
        to_tsvector(
            'english',
            t.data->>'text'
        )
        @@ to_tsquery('english', 'coronavirus')

        OR

        to_tsvector(
            'english',
            t.data->'extended_tweet'->>'full_text'
        )
        @@ to_tsquery('english', 'coronavirus')
    )
    AND t.data->>'lang' = 'en'
) x
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;

