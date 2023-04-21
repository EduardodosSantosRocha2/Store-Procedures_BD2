CREATE TABLE Departamentos (
  codigo INT NOT NULL,
  nome VARCHAR(50) NOT NULL,
  endereco VARCHAR(100) NOT NULL,
  orcamento DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (codigo)
);


CREATE TABLE Salas (
  numero_sala INT NOT NULL,
  area_metros_quadrados DECIMAL(10,2) NOT NULL,
  num_computadores INT NOT NULL,
  PRIMARY KEY (numero_sala)
);

CREATE TABLE Empregados (
  carteira_trabalho INT NOT NULL,
  nome VARCHAR(50) NOT NULL,
  endereco_residencial VARCHAR(100) NOT NULL,	
  telefone_residencial VARCHAR(20) NOT NULL,
  data_contratacao DATE NOT NULL,
  data_nascimento DATE NOT NULL,
  cod_departamento INT NOT NULL,
  salario real NOT NULL,
  num_sala INT NOT NULL,
  PRIMARY KEY (carteira_trabalho),
  FOREIGN KEY (cod_departamento) REFERENCES Departamentos(codigo),
  FOREIGN KEY (num_sala) REFERENCES Salas(numero_sala)
);


CREATE TABLE Gerentes (
  carteira_trabalho INT NOT NULL,
  cod_departamento INT NOT NULL,
  data_nomeacao DATE NOT NULL,
  PRIMARY KEY (carteira_trabalho),
  FOREIGN KEY (carteira_trabalho) REFERENCES Empregados(carteira_trabalho),
  FOREIGN KEY (cod_departamento) REFERENCES Departamentos(codigo)
);


CREATE TABLE Projetos (
  codigo INT NOT NULL,
  descricao VARCHAR(100) NOT NULL,
  orcamento DECIMAL(10,2) NOT NULL,
  data_inicio DATE NOT NULL,
  duracao_prevista_meses INT NOT NULL,
  PRIMARY KEY (codigo)
);


CREATE TABLE Participacao_Projetos (
  carteira_trabalho INT NOT NULL,
  codigo_projeto INT NOT NULL,
  horas_mensais INT NOT NULL,
  PRIMARY KEY (carteira_trabalho, codigo_projeto),
  FOREIGN KEY (carteira_trabalho) REFERENCES Empregados(carteira_trabalho),
  FOREIGN KEY (codigo_projeto) REFERENCES Projetos(codigo)
);











-- Inserindo dados na tabela Departamentos
INSERT INTO Departamentos (codigo, nome, endereco, orcamento) VALUES
(100, 'Departamento de Vendas', 'Rua dos Vendedores, 123', 50000),
(200, 'Departamento de Marketing', 'Avenida das Propagandas, 456', 75000),
(300, 'Departamento de Tecnologia', 'Rua dos Programadores, 789', 100000);


-- Inserindo dados na tabela Salas
INSERT INTO Salas (numero_sala, area_metros_quadrados, num_computadores) VALUES
(101, 25.0, 10),
(102, 30.0, 15),
(103, 20.0, 8),
(104, 35.0, 12),
(105, 40.0, 20);

-- Inserindo dados na tabela Empregados
INSERT INTO Empregados (carteira_trabalho, nome, endereco_residencial, telefone_residencial, data_contratacao, data_nascimento, cod_departamento,salario ,num_sala) VALUES
(10001, 'João Silva', 'Rua dos Funcionários, 123', '(11) 1234-5678', '2022-01-15', '2000-05-01', 100, 23.4,101),
(10002, 'Maria Santos', 'Rua das Flores, 456', '(11) 2345-6789', '2022-01-15', '1998-10-10', 100, 45.8,101),
(10003, 'Pedro Souza', 'Avenida dos Trabalhadores, 789', '(11) 3456-7890', '2022-02-01', '2002-01-20', 200,12344 ,102),
(10004, 'Lucas Oliveira', 'Rua dos Profissionais, 101', '(11) 4567-8901', '2022-02-01', '2001-03-15', 200, 10000,102),
(10005, 'Ana Pereira', 'Rua das Amoras, 654', '(11) 5678-9012', '2022-03-01', '2000-12-30', 300, 4564,103),
(10006, 'Gustavo Souza', 'Avenida das Árvores, 987', '(11) 6789-0123', '2022-03-01', '2003-07-07', 300,424242 ,103),
(10007, 'Leticia Rodrigues', 'Rua das Pedras, 555', '(11) 7890-1234', '2022-04-01', '2000-01-01', 300,5567 ,104),
(10008, 'Marcos Santos', 'Rua das Oliveiras, 789', '(11) 8901-2345', '2022-04-01', '1999-06-20', 300, 24242,105);

INSERT INTO Empregados (carteira_trabalho, nome, endereco_residencial, telefone_residencial, data_contratacao,
						data_nascimento, cod_departamento,salario ,num_sala) 
						VALUES(100010, 'Narcos Santos', 'Rua das Oliveiras, 789', '(11) 8901-2345', 
							   '2022-04-01', '1999-06-20', 100, 24242,105);

-- Inserindo dados na tabela Gerentes
INSERT INTO Gerentes (carteira_trabalho, cod_departamento, data_nomeacao) VALUES
(10005, 300, '2022-03-01'),
(10003, 200, '2022-02-01'),
(10001, 100, '2022-01-15');


-- Inserindo dados na tabela Projetos
INSERT INTO Projetos (codigo, descricao, orcamento, data_inicio, duracao_prevista_meses) VALUES 
(1, 'Desenvolvimento de software', 50000.00, '2023-01-01', 6),
(2, 'Expansão de mercado', 75000.00, '2022-07-01', 12),
(3, 'Melhoria de processos', 35000.00, '2022-11-01', 4);

-- Inserindo dados na tabela Participacao_Projetos
INSERT INTO Participacao_Projetos (carteira_trabalho, codigo_projeto, horas_mensais) VALUES 
(10001, 1, 160),
(10005, 1, 120),
(10007, 2, 180),
(10001, 2, 200),
(10006, 3, 100),
(10004, 3, 80);




-- 1- Faça uma procedure que verifique se todos os salários 
--dos funcionários estão dentro de uma determinada faixa salarial. 
--Se o salário estiver abaixo ele deve chegar ao piso.

CREATE OR REPLACE FUNCTION pisasalarial()
	RETURNS void AS $$
	DECLARE 
		tupla RECORD;
BEGIN		
		
	FOR tupla IN SELECT salario,carteira_trabalho FROM Empregados 
		LOOP
		 IF tupla.salario < 4000.00
		 	THEN
				
				UPDATE Empregados SET salario = 4000 where carteira_trabalho = tupla.carteira_trabalho;
				RAISE NOTICE 'Salario % carteira_trabalho: % tiveram o piso atualizado',tupla.salario,tupla.carteira_trabalho ;
				
		 ELSE
			 RAISE NOTICE 'Salario % carteira_trabalho: % já esta no piso ou acima',tupla.salario,tupla.carteira_trabalho ;
		END IF;
		
		
		
    END LOOP;
END;	
$$ LANGUAGE 'plpgsql'	


SELECT nome, salario FROM Empregados
SELECT pisasalarial();

--7) - Faça uma procedure para atualizar o salário de um empregado.
 
CREATE OR REPLACE FUNCTION salario_empregado(real, real)
	RETURNS void AS $$
	DECLARE 
		tupla RECORD;
BEGIN		
		
	FOR tupla IN SELECT carteira_trabalho FROM Empregados 
		LOOP
		 IF tupla.carteira_trabalho = $1
		 	THEN
				
				UPDATE Empregados SET salario = $2 where carteira_trabalho = tupla.carteira_trabalho;
				RAISE NOTICE 'Empregado da carteira de trabalho: % teve o salario atualizado',tupla.carteira_trabalho ;
				
		 ELSE
			 RAISE NOTICE 'carteira de trabalho não encontrada!!!' ;
		END IF;
		
		
		
    END LOOP;
END;	
$$ LANGUAGE 'plpgsql'	

SELECT nome,carteira_trabalho, salario FROM Empregados;
SELECT salario_empregado(10002, 7777);

-- OU sem verificação 
CREATE OR REPLACE FUNCTION salario_empregado2(real, real)
	RETURNS void AS $$
	DECLARE 
	BEGIN		
		
		UPDATE Empregados SET salario = $2 WHERE carteira_trabalho = $1;
		RAISE NOTICE 'Empregado da carteira de trabalho: % teve o salario atualizado', $1;
		   
	END;	
$$ LANGUAGE 'plpgsql';	

SELECT nome,carteira_trabalho, salario FROM Empregados;
SELECT salario_empregado2(10002, 8888);





-- 8) Faça uma procedure para atualizar o nome do departamento.

CREATE OR REPLACE FUNCTION nome_departamento(int, VARCHAR(50))
	RETURNS void AS $$
	BEGIN					
		UPDATE Departamentos SET nome = $2 where codigo = $1;
		RAISE NOTICE 'Departamento do codigo : % teve o nome atualizado',$1 ;	
	END;	
$$ LANGUAGE 'plpgsql'

SELECT nome, codigo FROM Departamentos;
SELECT nome_departamento(300, 'Carros');






-- LISTA 4

-- 2) Criar um procedimento que receba como parâmetro todos os dados de um Empregado e efetue a
-- sua inclusão. Este procedimento deverá avaliar se o CPF do Empregado que está sendo inserido já
-- existe. Se isto ocorrer, apresentar uma mensagem de erro e não efetuar a inclusão.


CREATE OR REPLACE FUNCTION inserir_funcionario(int,VARCHAR(50), VARCHAR(100), VARCHAR(20), DATE, DATE, int, real, int)
	RETURNS void AS $$
	DECLARE 
		tupla RECORD;
		carteira_trabalho_existe BOOLEAN := false;
BEGIN		
		
	FOR tupla IN SELECT carteira_trabalho FROM Empregados 
		LOOP
		  IF tupla.carteira_trabalho = $1
		 	THEN
				 RAISE NOTICE 'A carteira de trabalho % já existe na tabela de empregados',tupla.carteira_trabalho ;
				 carteira_trabalho_existe := true;
		  END IF;
		  	
	END LOOP;
	
	
	IF carteira_trabalho_existe = false
		THEN
			INSERT INTO Empregados (carteira_trabalho, nome, endereco_residencial, telefone_residencial, data_contratacao, data_nascimento, cod_departamento,salario ,num_sala) 
			VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9);
			RAISE NOTICE 'Empregado inserido com sucesso';
 	END IF;


END;	

$$ LANGUAGE 'plpgsql'







SELECT * FROM Empregados
SELECT inserir_funcionario(10009, 'Jose Fino', 'Avenida Guanabara', '34 99992331','2022-03-01', 
						   '2003-07-07', 100, 5675, 101);


-- 5) Criar uma função que retorne a idade do funcionário a partir do seu CPF. 
-- (verificar funções para trabalhar com datas).
CREATE OR REPLACE FUNCTION indadeFuncionario(int)
	RETURNS integer AS $$
	DECLARE 
		idade INTEGER;
		data_nascimento1 DATE;
BEGIN	

	SELECT INTO data_nascimento1 data_nascimento  FROM Empregados WHERE carteira_trabalho = $1;
	
	idade = DATE_PART('year', CURRENT_DATE) - DATE_PART('year', data_nascimento1);

	return idade;	
	
END;	

$$ LANGUAGE 'plpgsql'

SELECT nome, carteira_trabalho,data_nascimento  FROM Empregados;
SELECT indadeFuncionario(10003);


-- 9) Crie uma função que retorne os departamentos e a quantidade do orçamento que é gasta com folha de pagamento dos funcionários.
	
CREATE OR REPLACE FUNCTION dep_quantidadeorcamento()
	RETURNS TABLE (departamento VARCHAR(50), orcamento_total real) AS $$
	
	BEGIN 
		RETURN QUERY SELECT d.nome AS departamento, SUM(e.salario) AS orcamento_total
               FROM Departamentos d
               INNER JOIN Empregados e ON d.codigo = e.cod_departamento
               GROUP BY d.nome;
		RETURN;
	END;
	
$$ LANGUAGE 'plpgsql';			   
			   
SELECT * FROM dep_quantidadeorcamento();











-- –10)  Suponha uma tabela que contenha os campos de endereço com (tipo, nome, número,
-- complemento, bairro, cidade e estado). Crie uma função que retorne todos os endereços
-- armazenados “de forma cursiva”, inserindo inclusive vírgulas e demais pontuações que forem
-- necessárias.


CREATE TABLE Endereco(
    tipo text NOT NULL, 
    nome text NOT NULL, 
    número text PRIMARY KEY NOT NULL,
    complemento text NOT NULL, 
    bairro text NOT NULL, 
    cidade text NOT NULL, 
    estado text NOT NULL
);

INSERT INTO Endereco (tipo, nome, número, complemento, bairro, cidade, estado) VALUES
    ('Rua', 'São Paulo', '123', 'Apto 101', 'Centro', 'São Paulo', 'SP'),
    ('Avenida', 'Rio de Janeiro', '456', 'Sem complemento', 'Copacabana', 'Rio de Janeiro', 'RJ'),
    ('Rua', 'Belo Horizonte', '789', 'Casa 2', 'Santo Antônio', 'Belo Horizonte', 'MG'),
    ('Rua', 'Porto Alegre', '1011', 'Sem complemento', 'Moinhos de Vento', 'Porto Alegre', 'RS'),
    ('Avenida', 'Recife', '1213', 'Sala 302', 'Boa Viagem', 'Recife', 'PE');
	
	
	
CREATE TYPE	type_enderecos AS(
	tipo text , 
    nome text , 
    número text,
    complemento text , 
    bairro text , 
    cidade text , 
    estado text 
);
	

CREATE OR REPLACE FUNCTION enderecos1()
	RETURNS SETOF TEXT AS $$
DECLARE 
	 enderecos_concatenados TEXT;
BEGIN 
	FOR enderecos_concatenados IN  
		SELECT concat(tipo, ' ', nome, ', ', número, ' - ', complemento, ', ', bairro, ', ', cidade, ' - ', estado)
		FROM Endereco 
	LOOP
		RETURN NEXT enderecos_concatenados;
	END LOOP;
END;
$$ LANGUAGE 'plpgsql';	


SELECT * FROM enderecos1();


-- OU

CREATE OR REPLACE FUNCTION enderecos2()
	RETURNS SETOF TEXT AS $$
DECLARE 
	 enderecos_concatenados TEXT;
	 save RECORD;
BEGIN 
	 FOR save IN SELECT * FROM Endereco LOOP
        enderecos_concatenados := save.tipo || ' ' || save.nome || ', ' || save.número || ' - ' || save.complemento || ', ' || save.bairro || ', ' || save.cidade || ' - ' || save.estado;
      RETURN NEXT enderecos_concatenados;
	
	END LOOP;
END;
$$ LANGUAGE 'plpgsql';	


SELECT * FROM enderecos2();
	
	
