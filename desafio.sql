CREATE TABLE Pacientes (
    PacienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    DataNascimento DATE,
    Sexo CHAR(1),
    Endereco VARCHAR(255),
    Telefone VARCHAR(15)
);

-- Crie a tabela Medicos
CREATE TABLE Medicos (
    MedicoID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Especialidade VARCHAR(255),
    CRM VARCHAR(15),
    Telefone VARCHAR(15)
);

-- Crie a tabela ConsultasMedicas
CREATE TABLE ConsultasMedicas (
    ConsultaID INT AUTO_INCREMENT PRIMARY KEY,
    PacienteID INT,
    MedicoID INT,
    DataConsulta DATETIME,
    Sintomas TEXT,
    Observacoes TEXT,
    FOREIGN KEY (PacienteID) REFERENCES Pacientes (PacienteID),
    FOREIGN KEY (MedicoID) REFERENCES Medicos (MedicoID)
);

-- Crie a tabela ExamesMedicos
CREATE TABLE ExamesMedicos (
    ExameID INT AUTO_INCREMENT PRIMARY KEY,
    PacienteID INT,
    MedicoID INT,
    DataExame DATETIME,
    TipoExame VARCHAR(255),
    Resultado TEXT,
    FOREIGN KEY (PacienteID) REFERENCES Pacientes (PacienteID),
    FOREIGN KEY (MedicoID) REFERENCES Medicos (MedicoID)
);

DELIMITER //

-- Crie a função para atualizar o diagnóstico
CREATE FUNCTION AtualizarDiagnostico(
    consulta_id INT,
    exame_id INT
)
RETURNS TEXT
BEGIN
    DECLARE diagnostico TEXT;

    SELECT IFNULL(CONS.Diagnostico, EXAM.Diagnostico) INTO diagnostico
    FROM ConsultasMedicas AS CONS
    LEFT JOIN ExamesMedicos AS EXAM ON CONS.ConsultaID = consulta_id AND EXAM.ExameID = exame_id;

    RETURN diagnostico;
END;
//

DELIMITER ;

-- Crie o trigger que chama a função ao inserir um novo diagnóstico
DELIMITER //
CREATE TRIGGER AtualizarDiagnosticoTrigger
BEFORE INSERT ON Diagnosticos
FOR EACH ROW
BEGIN
    SET NEW.Diagnostico = AtualizarDiagnostico(NEW.ConsultaID, NEW.ExameID);
END;
//

DELIMITER ;
