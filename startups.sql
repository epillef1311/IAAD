CREATE TABLE startup(
	id_startup INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	nome_startup VARCHAR(50) NOT NULL,
    cidade_sede VARCHAR(50)
);
ALTER TABLE startup AUTO_INCREMENT=10001;

CREATE TABLE linguagem_programacao(
	id_linguagem INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome_linguagem VARCHAR(50) NOT NULL,
    ano_lancamento YEAR NOT NULL
);
ALTER TABLE linguagem_programacao AUTO_INCREMENT=20001;

CREATE TABLE programador(
	id_programador INT NOT NULL AUTO_INCREMENT,
    id_startup CHAR(5) NOT NULL,
    nome_programador VARCHAR(50) NOT NULL,
    genero CHAR(1),
    data_nasc DATE,
    email VARCHAR(50) UNIQUE,
    PRIMARY KEY(id_programador)
);
ALTER TABLE programador AUTO_INCREMENT=30001;

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
(DEFAULT,'Tech4Toy','Porto Alegre'), 
(DEFAULT,'Smart123','Belo Horizonte'), 
(DEFAULT,'knowledgeUp','Rio de Janeiro'), 
(DEFAULT,'BSI Next Level','Recife'), 
(DEFAULT,'QualiHealth','São Paulo'), 
(DEFAULT,'ProEdu','Florianópolis');

INSERT INTO linguagem_programacao VALUES
(DEFAULT,'Python','1991'),
(DEFAULT,'PHP','1995'),
(DEFAULT,'Java','1995'),
(DEFAULT,'C','1972'),
(DEFAULT,'JavaScript','1995'),
(DEFAULT,'Dart','2011');

INSERT INTO programador () VALUES
(DEFAULT,'10001','João Pedro','M','1993-06-23','joaop@mail.com'), 
(DEFAULT,'10002','Paula Silva','F','1986-01-10','paulas@mail.com'), 
(DEFAULT,'10003','Renata Vieira','F','1991-07-05','renatav@mail.com'), 
(DEFAULT,'10004','Felipe Santos','M','1976-11-25','felipes@mail.com'), 
(DEFAULT,'10001','Ana Cristina','F','1968-02-19','anac@mail.com'), 
(DEFAULT,'10004','Alexandre Alves','M','1988-07-07','alexandrea@mail.com'), 
(DEFAULT,'10002','Laura Marques','F','1987-10-04','lauram@mail.com');


INSERT INTO programador_linguagem VALUES
('30001','20001'), 
('30001','20002'), 
('30002','20003'), 
('30003','20004'), 
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