/*
 * Count the number of tweets that use #coronavirus, seq scan since its one page read
 */
--CREATE INDEX ON tweets_jsonb USING gin(
    --(data -> 'entities' -> 'hashtags') jsonb_path_ops);

--CREATE INDEX
--ON tweets_jsonb
--USING GIN ((data->'extended_tweet'->'entities'->'hashtags') jsonb_path_ops);

SELECT COUNT(distinct data->>'id')
FROM tweets_jsonb
WHERE data->'entities'->'hashtags' @> '[{"text": "coronavirus"}]' 
    OR data->'extended_tweet'->'entities'->'hashtags' @> '[{"text": "coronavirus"}]';

-- jsonb array elements: set returning function, internally does a join
-- set returning functions cannot be sped up without an index
-- CREATE INDEX ON tweets_jsonb()
-- @N: contains
