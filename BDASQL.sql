CREATE DATABASE UNIVERSIDADE
GO
USE UNIVERSIDADE
GO
CREATE TABLE CURSOS
    (
	CURSO CHAR(3) NOT NULL 
    CONSTRAINT PK_CURSO PRIMARY KEY,
	NOMECURSO VARCHAR(50) NOT NULL
    );
GO
CREATE TABLE PROFESSORES
    (
	PROFESSOR INT IDENTITY NOT NULL 
    CONSTRAINT PK_PROFESSOR PRIMARY KEY,
	NOMEPROFESSOR VARCHAR(50) NOT NULL,
	SEXO VARCHAR(1) NOT NULL,
    );

GO
CREATE TABLE MATERIAS
    (
	SIGLA CHAR(3) NOT NULL,
	NOMEMATERIA VARCHAR(50) NOT NULL,
	CARGAHORARIA INT NOT NULL,
	CURSO CHAR(3) NOT NULL,
	PROFESSOR INT
	CONSTRAINT PK_MATERIA
	PRIMARY KEY (
                  SIGLA,
                  CURSO,
                  PROFESSOR
							)
	CONSTRAINT FK_CURSO FOREIGN KEY (CURSO) 
    REFERENCES CURSOS(CURSO),
	CONSTRAINT FK_PROFESSOR FOREIGN KEY (PROFESSOR)
    REFERENCES PROFESSORES (PROFESSOR)
    );
GO
CREATE TABLE TURMAS
    (
	TURMA INT NOT NULL IDENTITY(1,1) 
    CONSTRAINT PK_TURMA PRIMARY KEY,
	DATAINI INT NOT NULL,
	DATAFIM INT NOT NULL,
	CURSO CHAR(3) NOT NULL,
	CONSTRAINT FK_CURSO1 FOREIGN KEY (CURSO) 
    REFERENCES CURSOS(CURSO),
    );
GO
CREATE TABLE ALUNOS
    (
	MATRICULA INT NOT NULL IDENTITY(1,1) 
    CONSTRAINT PK_ALUNO PRIMARY KEY,
	NOMEALUNO VARCHAR(50) NOT NULL,
	SEXO VARCHAR(1) NOT NULL,
	CURSO CHAR(3) NOT NULL,
	TURMA INT NOT NULL,
	CONSTRAINT FK_CURSO2	FOREIGN KEY (CURSO) 
    REFERENCES CURSOS (CURSO),
	CONSTRAINT FK_TURMA	FOREIGN KEY (TURMA) 
    REFERENCES  TURMAS(TURMA)
    );
GO
CREATE PROCEDURE procCurso
(
@CURSO CHAR(3),
@NOMECURSO VARCHAR(50)
)
AS
BEGIN
	INSERT CURSOS (CURSO, NOMECURSO) VALUES (@CURSO, @NOMECURSO)
END
GO
EXEC procCurso     
	@CURSO = 'BSI',
	@NOMECURSO =	'BACHARELADO EM SISTEMAS DA INFORMACAO'
GO
CREATE PROCEDURE procProfessor
(
	@NOMEPROFESSOR VARCHAR(50),
	@SEXO VARCHAR(1)
)
AS
BEGIN
	INSERT PROFESSORES(NOMEPROFESSOR,SEXO) VALUES (@NOMEPROFESSOR,@SEXO)
END
GO
EXEC procProfessor     
	@NOMEPROFESSOR = 'LEANDERSON',
	@SEXO =	'M'
GO
CREATE PROCEDURE procTurma
(
	@DATAINI INT,
	@DATAFIM INT,
	@CURSO CHAR(3),
	@PROFESSOR INT
)
AS
BEGIN
	INSERT TURMAS( CURSO, DATAINI, DATAFIM) VALUES (@CURSO,@DATAINI,@DATAFIM)
END
GO
EXEC procTurma     
	@DATAINI = 15032019,
	@DATAFIM = 06112019,
	@CURSO = 'BSI',
	@PROFESSOR = 1
GO
CREATE PROCEDURE procAluno
(
	@NOMEALUNO VARCHAR(50),
	@SEXO VARCHAR(1),
	@CURSO CHAR(3),
	@TURMA INT
)
AS
BEGIN
	INSERT ALUNOS(NOMEALUNO,SEXO,CURSO,TURMA) VALUES (@NOMEALUNO,@SEXO,@CURSO,@TURMA)
END
GO
EXEC procAluno     
	@NOMEALUNO = 'GUILHERME',
	@SEXO =	'M',
	@CURSO =	'BSI',
	@TURMA = 1
GO
CREATE PROCEDURE procMateria
(
	
	@SIGLA CHAR(3),
	@NOMEMATERIA VARCHAR(50),
	@CARGAHORARIA INT,
	@CURSO CHAR(3),
	@PROFESSOR INT
)
AS
BEGIN
	INSERT MATERIAS(SIGLA,NOMEMATERIA,CARGAHORARIA,CURSO,PROFESSOR) VALUES (@SIGLA,@NOMEMATERIA,@CARGAHORARIA,@CURSO,@PROFESSOR)
END
GO
EXEC procMateria    
	@SIGLA = 'BDA',
	@NOMEMATERIA = 'BANCO DE DADOS',
	@CARGAHORARIA = 90,
	@CURSO = 'BSI',
	@PROFESSOR = 1
GO
CREATE TRIGGER TCurso
ON CURSOS
FOR DELETE
AS
BEGIN
    DECLARE
    @CURSO  CHAR(3)
 
    SELECT @CURSO = CURSO FROM DELETED

	DELETE FROM ALUNOS WHERE CURSO = @CURSO
	DELETE FROM TURMAS WHERE CURSO = @CURSO
	DELETE FROM MATERIAS WHERE CURSO = @CURSO
END
GO
CREATE TRIGGER TTurma
ON TURMAS
FOR DELETE
AS
BEGIN
    DECLARE
    @TURMA  INT
 
    SELECT @TURMA = TURMA FROM DELETED

	DELETE FROM ALUNOS WHERE TURMA = @TURMA
END
GO
SELECT	CURSOS.CURSO, CURSOS.NOMECURSO, MATERIAS.CARGAHORARIA, MATERIAS.NOMEMATERIA, MATERIAS.SIGLA, 
		PROFESSORES.NOMEPROFESSOR, PROFESSORES.PROFESSOR, PROFESSORES.SEXO, TURMAS.TURMA, 
		TURMAS.DATAINI, TURMAS.DATAFIM, ALUNOS.NOMEALUNO, ALUNOS.MATRICULA, ALUNOS.SEXO

FROM	CURSOS, MATERIAS, PROFESSORES, ALUNOS, TURMAS
