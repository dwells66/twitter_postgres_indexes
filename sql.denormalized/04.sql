/*
 * Count the number of English tweets containing the word "coronavirus"
 */

--CREATE INDEX ON tweets_jsonb USING GIN (to_tsvector('english', data->>'text'));

--CREATE INDEX ON tweets_jsonb
--USING GIN (to_tsvector('english', data->'extended_tweet'->>'full_text'));

--CREATE INDEX ON tweets_jsonb ((data->>'lang')); 


SELECT count(*)
FROM tweets_jsonb
WHERE to_tsvector(
        'english',
        COALESCE(
            data->'extended_tweet'->>'full_text',
            data->>'text'
        )
      )
      @@ to_tsquery('english', 'coronavirus')
  AND data->>'lang' = 'en';

