DROP SCHEMA IF EXISTS Persistencia;
CREATE SCHEMA Persistencia;

USE Persistencia;

CREATE TABLE `Persistencia`.`usuarios` (
  `nombre` VARCHAR(255) NOT NULL,
  `apellido` VARCHAR(255) NOT NULL,
  `nombreDeUsuario` VARCHAR(255) UNIQUE,
  `password` VARCHAR(12) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `fechaDeNacimiento` DATE NOT NULL,
  `codigoDeValidacion` VARCHAR(255) NOT NULL,
  `validado` BOOLEAN DEFAULT false,
  `ID` INTEGER NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`)
)
ENGINE = InnoDB;
