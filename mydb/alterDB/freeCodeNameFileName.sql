ALTER TABLE file_input
    ADD COLUMN code_start INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN code_length INTEGER NOT NULL DEFAULT 5,
    ALTER COLUMN filecode TYPE varchar(20)
;
UPDATE file_input 
    SET code_length = LENGTH(code);

UPDATE file_input 
    SET filecode = 'tqbs',
    code_start = 0,
    code_length = 4
WHERE filecode = 'tqbs_';

UPDATE file_input
    SET code_start = 9
WHERE fk_file_type='tec_ncfc';

