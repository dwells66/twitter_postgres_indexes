/*
 * Calculates the hashtags that are commonly used with the hashtag #coronavirus
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
             COALESCE(t.data->'entities'->'hashtags','[]'::jsonb)
             ||
             COALESCE(t.data->'extended_tweet'->'entities'->'hashtags','[]'::jsonb)
         ) h
    WHERE (
        t.data->'entities'->'hashtags' @> '[{"text":"coronavirus"}]'
     OR t.data->'extended_tweet'->'entities'->'hashtags' @> '[{"text":"coronavirus"}]'
    )
) x
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;

