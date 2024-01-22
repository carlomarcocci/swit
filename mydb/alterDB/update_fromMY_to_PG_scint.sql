UPDATE file_input
    SET 
        db_host = 'scintdb', 
        db_port = 5432, 
        db_name = 'scint', 
        db_type = 'pg', 
        db_user = 'scintu', 
        db_pass = 'wd8h570qww'
WHERE db_name = 'scintillation';

INSERT INTO file_type (code, parser_ref) VALUES('raw_sept','class_septentrio.php');
UPDATE file_input SET fk_file_type='ismr_sept' where fk_file_type='def_sept';
ALTER TABLE file_input ADD CONSTRAINT foreign_file_type FOREIGN KEY (fk_file_type) REFERENCES file_type (code);
UPDATE file_input SET bkup_dir=db_name;
update file_input set extension= REPLACE(extension, '[2-9][0-9]','[0-9][0-9]') where extension like '[2-9][0-9]_';
