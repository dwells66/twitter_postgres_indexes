/*
 * Calculates the languages that use the hashtag #coronavirus
 */

SELECT
    t.data->>'lang' AS lang,
    COUNT(DISTINCT t.data->>'id') AS count
FROM tweets_jsonb t
WHERE (
        t.data->'entities'->'hashtags' @> '[{"text": "coronavirus"}]'
     OR t.data->'extended_tweet'->'entities'->'hashtags' @> '[{"text": "coronavirus"}]'
)
GROUP BY lang
ORDER BY count DESC, lang;

