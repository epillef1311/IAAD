CREATE TABLE startup(
	id_startup CHAR(5) PRIMARY KEY NOT NULL,
	nome_startup VARCHAR(50) NOT NULL,
    cidade_sede VARCHAR(50)
);

CREATE TABLE linguagem_programacao(
	id_linguagem CHAR(5) PRIMARY KEY NOT NULL,
    nome_linguagem VARCHAR(50) NOT NULL,
    ano_lancamento YEAR NOT NULL
);

CREATE TABLE programador(
	id_programador CHAR(5) PRIMARY KEY NOT NULL,
    id_startup CHAR(5) NOT NULL,
    nome_programador VARCHAR(50) NOT NULL,
    genero CHAR(1),
    data_nasc DATE,
    email VARCHAR(50) UNIQUE
);

CREATE TABLE programador_linguagem(
	id_programador CHAR(5) NOT NULL,
    id_linguagem CHAR(5) NOT NULL,
    PRIMARY KEY(id_programador, id_linguagem)
);

CREATE TABLE startup_linguagem(
	id_startup CHAR(5),
    id_linguagem CHAR(5),
    PRIMARY KEY(id_startup, id_linguagem)
);

ALTER TABLE programador ADD FOREIGN KEY(id_startup) REFERENCES startup(id_startup);

SET SQL_SAFE_UPDATES=0;

DELIMITER $$
CREATE TRIGGER before_delete_linguagem_prog
	BEFORE DELETE ON linguagem_programacao
	FOR EACH ROW
    BEGIN
	IF old.id_linguagem IN (SELECT DISTINCT id_linguagem FROM programador_linguagem)
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR';
    END IF;
    END
$$

DELIMITER ;


DELIMITER $$
CREATE TRIGGER after_delete_prog
	AFTER DELETE ON programador
    FOR EACH ROW
    BEGIN
    IF old.id_programador IN (SELECT id_programador FROM programador_linguagem)
		THEN
        DELETE FROM programador_linguagem WHERE id_programador = old.id_programador;
        END IF;
        END
$$
    DELIMITER ;
    
    
    
DELIMITER $$
CREATE TRIGGER after_update_startup_id
	AFTER UPDATE ON startup
    FOR EACH ROW
    BEGIN
    IF old.id_startup IN(SELECT id_startup FROM programador)
    THEN
    UPDATE programador
    SET old.id_startup = new.id_startup;
    END IF;
    END
    $$
	DELIMITER ;
    
    
DELIMITER $$
CREATE TRIGGER before_delete_linguagem_prog_startup
	BEFORE DELETE ON linguagem_programacao
	FOR EACH ROW
    BEGIN
	IF old.id_linguagem IN (SELECT DISTINCT id_linguagem FROM startup_linguagem)
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR';
    END IF;
    END
$$

DELIMITER ;

INSERT INTO startup VALUES
('10001','Tech4Toy','Porto Alegre'), 
('10002','Smart123','Belo Horizonte'), 
('10003','knowledgeUp','Rio de Janeiro'), 
('10004','BSI Next Level','Recife'), 
('10005','QualiHealth','São Paulo'), 
('10006','ProEdu','Florianópolis');

INSERT INTO linguagem_programacao VALUES
('20001','Python','1991'),
('20002','PHP','1995'),
('20003','Java','1995'),
('20004','C','1972'),
('20005','JavaScript','1995'),
('20006','Dart','2011');

INSERT INTO programador VALUES
('30001','10001','João Pedro','M','1993-06-23','joaop@mail.com'), 
('30002','10002','Paula Silva','F','1986-01-10','paulas@mail.com'), 
('30003','10003','Renata Vieira','F','1991-07-05','renatav@mail.com'), 
('30004','10004','Felipe Santos','M','1976-11-25','felipes@mail.com'), 
('30005','10001','Ana Cristina','F','1968-02-19','anac@mail.com'), 
('30006','10004','Alexandre Alves','M','1988-07-07','alexandrea@mail.com'), 
('30007','10002','Laura Marques','F','1987-10-04','lauram@mail.com');


INSERT INTO programador_linguagem VALUES
('30001','20001'), 
('30001','20002'), 
('30002','20003'), 
('30002','20004'), 
('30003','20005'), 
('30004','20005'), 
('30007','20001'), 
('30007','20002');

INSERT INTO startup_linguagem VALUES
('10001','20001'),
('10001','20002'),
('10002','20003'),
('10003','20004'),
('10003','20005'),
('10004','20005');