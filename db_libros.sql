-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 09-03-2026 a las 17:00:31
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `db_libros`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_actualizar_socio` (IN `id_socio` INT(10), IN `telefono` VARCHAR(10), IN `direccion` VARCHAR(255))   BEGIN
    UPDATE socio
    SET soc_telefono = telefono,
        soc_direccion = direccion
    WHERE soc_numero = id_socio;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_eliminar_libro` (IN `P_LIB_ISBN` VARCHAR(20))   BEGIN
    DECLARE TOTAL INT;
    SELECT COUNT(*) INTO TOTAL
    FROM PRESTAMO
    WHERE COPIA_LIB_ISBN = P_LIB_ISBN;
    
    IF total > 0 THEN
        SELECT 'No se puede eliminar el libro porque tiene préstamos registrados' AS mensaje;
    ELSE
        DELETE FROM libro
        WHERE LIB_ISBN = P_LIB_ISBN;
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_insert_socio` (`ID` INT, `NOMBRE` VARCHAR(45), `APELLIDO` VARCHAR(45), `DIRECCION` VARCHAR(255), `TELEFONO` VARCHAR(10))   BEGIN
	INSERT INTO SOCIO(SOC_NUMERO, SOC_NOMBRE, SOC_APELLIDO, SOC_DIRECCION, SOC_TELEFONO)
    VALUES (ID, NOMBRE, APELLIDO, DIRECCION, TELEFONO);
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_libros_prestamo` ()   SELECT LIB_TITULO, LIB_DIAS_PRESTAMO, FECHA_PRESTAMO, SOC_NOMBRE, SOC_APELLIDO FROM SOCIO, PRESTAMO
INNER JOIN LIBRO
ON LIB_ISBN = COPIA_LIB_ISBN$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_listaAutores` ()   SELECT AUT_CODIGO, AUT_APELLIDO 
FROM AUTOR 
ORDER BY AUT_APELLIDO DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_nombre_libro` (`LIB_TITULO` VARCHAR(200))   SELECT LIB_TITULO as 'Titulo del libro'
FROM libro$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_socio_prestamo` ()   SELECT * FROM socio
LEFT JOIN PRESTAMO 
ON SOC_NUMERO=COPIA_SOC_NUMERO$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tipoAutor` (`variable` VARCHAR(20))   BEGIN
SELECT AUT_APELLIDO AS 'AUTOR', TIPO_AUTOR 
FROM AUTOR
INNER JOIN TIPO_AUTORES 
ON AUT_CODIGO = COPIA_COD_AUTOR
WHERE TIPO_AUTOR = variable;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_libros` (`c1_isbn` BIGINT(20), `c2_titulo` VARCHAR(255), `c3_genero` VARCHAR(20), `c4_paginas` INT(11), `c5_diaspres` TINYINT(4))   INSERT INTO
libro(LIB_ISBN, LIB_TITULO, LIB_GENERO, LIB_NUMRO_PAGINAS, LIB_DIAS_PRESTAMO)
VALUES (c1_isbn,c2_titulo,c3_genero, c4_paginas,c5_diaspres)$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_prestamo_dias` (`LIB_ISBN` VARCHAR(20)) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE TOTAL_DIAS INT;
    SELECT DATEDIFF(FECHA_DEVOLUCION, FECHA_PRESTAMO)
    INTO TOTAL_DIAS
    FROM PRESTAMO
    WHERE COPIA_LIB_ISBN = LIB_ISBN
    LIMIT 1;
    RETURN TOTAL_DIAS;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_total_socios` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE cantidad INT;
    SELECT COUNT(*) INTO cantidad
    FROM socio;
    RETURN cantidad;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aprendiz`
--

CREATE TABLE `aprendiz` (
  `ID_APRENDIZ` int(11) NOT NULL,
  `NOM_APRENDIZ` varchar(50) NOT NULL,
  `APE_APRENDIZ` varchar(50) NOT NULL,
  `CORREO_APRENDIZ` varchar(50) NOT NULL,
  `UBICACION_APRENDIZ` varchar(70) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `aprendiz`
--

INSERT INTO `aprendiz` (`ID_APRENDIZ`, `NOM_APRENDIZ`, `APE_APRENDIZ`, `CORREO_APRENDIZ`, `UBICACION_APRENDIZ`) VALUES
(1, 'Juan', 'Pérez', 'juan.perez@example.com', 'Ciudad A'),
(2, 'María', 'Gómez', 'maria.gomez@example.com', 'Ciudad B'),
(3, 'Pedro', 'López', 'pedro.lopez@example.com', 'Ciudad C'),
(4, 'Laura', 'Torres', 'laura.torres@example.com', 'Ciudad A'),
(5, 'Carlos', 'Rodríguez', 'carlos.rodriguez@example.com', 'Ciudad B');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_autor`
--

CREATE TABLE `audi_autor` (
  `ID_AUDI_AUTOR` int(11) NOT NULL,
  `AUT_CODIGO_AUDI` int(11) DEFAULT NULL,
  `AUT_APELLIDO_ANTERIOR` varchar(45) DEFAULT NULL,
  `AUT_NACIMIENTO_ANTERIOR` date DEFAULT NULL,
  `AUT_MUERTE_ANTERIOR` date DEFAULT NULL,
  `AUT_APELLIDO_NUEVO` varchar(45) DEFAULT NULL,
  `AUT_NACIMIENTO_NUEVO` date DEFAULT NULL,
  `AUT_MUERTE_NUEVO` date DEFAULT NULL,
  `FECHA_MODIFICACION` datetime DEFAULT NULL,
  `USUARIO` varchar(10) DEFAULT NULL,
  `ACCION` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `audi_autor`
--

INSERT INTO `audi_autor` (`ID_AUDI_AUTOR`, `AUT_CODIGO_AUDI`, `AUT_APELLIDO_ANTERIOR`, `AUT_NACIMIENTO_ANTERIOR`, `AUT_MUERTE_ANTERIOR`, `AUT_APELLIDO_NUEVO`, `AUT_NACIMIENTO_NUEVO`, `AUT_MUERTE_NUEVO`, `FECHA_MODIFICACION`, `USUARIO`, `ACCION`) VALUES
(1, 345, 'Wilson ', '0000-00-00', '1975-08-29', 'Ramirez', '1972-11-13', '2001-03-18', '2026-03-09 09:34:56', 'root@local', 'ACTUALIZACIÓN'),
(2, 521, 'Muñoz', '1975-08-14', '2018-05-08', NULL, NULL, NULL, '2026-03-09 10:05:41', 'root@local', 'ELIMINACIÓN');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_socio`
--

CREATE TABLE `audi_socio` (
  `ID_AUDI` int(10) NOT NULL,
  `soc_Numero_audi` int(11) DEFAULT NULL,
  `soc_Nombre_anterior` varchar(45) DEFAULT NULL,
  `soc_Apellido_anterior` varchar(45) DEFAULT NULL,
  `soc_Direccion_anterior` varchar(255) DEFAULT NULL,
  `soc_Telefono_anterior` varchar(10) DEFAULT NULL,
  `soc_Nombre_nuevo` varchar(45) DEFAULT NULL,
  `soc_Apellido_nuevo` varchar(45) DEFAULT NULL,
  `soc_Direccion_nuevo` varchar(255) DEFAULT NULL,
  `soc_Telefono_nuevo` varchar(10) DEFAULT NULL,
  `audi_fechaModificacion` datetime DEFAULT NULL,
  `audi_usuario` varchar(10) DEFAULT NULL,
  `audi_accion` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `audi_socio`
--

INSERT INTO `audi_socio` (`ID_AUDI`, `soc_Numero_audi`, `soc_Nombre_anterior`, `soc_Apellido_anterior`, `soc_Direccion_anterior`, `soc_Telefono_anterior`, `soc_Nombre_nuevo`, `soc_Apellido_nuevo`, `soc_Direccion_nuevo`, `soc_Telefono_nuevo`, `audi_fechaModificacion`, `audi_usuario`, `audi_accion`) VALUES
(1, 1, 'Ana', 'Ruiz', 'Cra 14 calle 23', '3213357665', 'Ana', 'Ruiz', 'Calle 72 # 2', '291876', '2026-03-05 07:24:21', 'root@local', 'Actualización');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aud_libros`
--

CREATE TABLE `aud_libros` (
  `ID_AUD_LIBRO` int(11) NOT NULL,
  `LIB_ISBN_AUDI` int(11) DEFAULT NULL,
  `LIB_TITULO_NUEVO` varchar(255) DEFAULT NULL,
  `LIB_GENERO_NUEVO` varchar(20) DEFAULT NULL,
  `LIB_NUMERO_PAGINAS_NUEVO` int(11) DEFAULT NULL,
  `LIB_DIAS_PRESTAMO` int(11) DEFAULT NULL,
  `FECHA_MODIFICACION` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `aud_libros`
--

INSERT INTO `aud_libros` (`ID_AUD_LIBRO`, `LIB_ISBN_AUDI`, `LIB_TITULO_NUEVO`, `LIB_GENERO_NUEVO`, `LIB_NUMERO_PAGINAS_NUEVO`, `LIB_DIAS_PRESTAMO`, `FECHA_MODIFICACION`) VALUES
(1, 324587917, 'Stranger', 'Misterio', 564, 12, '2026-03-05 15:50:04'),
(2, 2147483647, 'Antes de diciembre', 'Romance', 478, 15, '2026-03-05 16:05:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `autor`
--

CREATE TABLE `autor` (
  `AUT_CODIGO` int(11) NOT NULL,
  `AUT_APELLIDO` varchar(45) NOT NULL,
  `AUT_NACIMIENTO` date NOT NULL,
  `AUTO_MUERTE` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `autor`
--

INSERT INTO `autor` (`AUT_CODIGO`, `AUT_APELLIDO`, `AUT_NACIMIENTO`, `AUTO_MUERTE`) VALUES
(98, 'Smith ', '1974-12-21', '2018-07-21'),
(123, 'Taylor ', '1980-04-15', '0000-00-00'),
(234, 'Medina ', '1977-06-21', '2005-09-12'),
(345, 'Ramirez', '1972-11-13', '2001-03-18'),
(432, 'Miller ', '1981-10-26', '0000-00-00'),
(456, 'García ', '1978-09-27', '2021-12-09'),
(567, 'Davis ', '1983-03-04', '2010-03-28'),
(678, 'Silva ', '1986-02-02', '0000-00-00'),
(765, 'López ', '1976-07-08', '2005-05-12'),
(789, 'Rodríguez ', '1985-12-10', '0000-00-00'),
(890, 'Brown ', '1982-11-17', '0000-00-00'),
(901, 'Soto ', '1979-05-13', '2015-11-05');

--
-- Disparadores `autor`
--
DELIMITER $$
CREATE TRIGGER `DELETE_AUTOR` AFTER DELETE ON `autor` FOR EACH ROW BEGIN
	INSERT INTO AUDI_AUTOR(
	AUT_CODIGO_AUDI,
    AUT_APELLIDO_ANTERIOR,
    AUT_NACIMIENTO_ANTERIOR,
    AUT_MUERTE_ANTERIOR,
    AUT_APELLIDO_NUEVO,
    AUT_NACIMIENTO_NUEVO,
    AUT_MUERTE_NUEVO,
    FECHA_MODIFICACION,
    USUARIO,
    ACCION)
VALUES(
	OLD.AUT_CODIGO,
    OLD.AUT_APELLIDO,
    OLD.AUT_NACIMIENTO,
    OLD.AUTO_MUERTE,
    NULL,
    NULL,
    NULL,
  	NOW(),
    CURRENT_USER(),
    'ELIMINACIÓN');
    
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `UPDATE_AUTOR` BEFORE UPDATE ON `autor` FOR EACH ROW BEGIN 
INSERT INTO AUDI_AUTOR(
    AUT_CODIGO_AUDI,
    AUT_APELLIDO_ANTERIOR,
    AUT_NACIMIENTO_ANTERIOR,
    AUT_MUERTE_ANTERIOR,
    AUT_APELLIDO_NUEVO,
    AUT_NACIMIENTO_NUEVO,
    AUT_MUERTE_NUEVO,
    FECHA_MODIFICACION,
    USUARIO,
    ACCION)
VALUES(
	NEW.AUT_CODIGO,
    OLD.AUT_APELLIDO,
    OLD.AUTO_MUERTE,
    OLD.AUT_NACIMIENTO,
    NEW.AUT_APELLIDO,
    NEW.AUT_NACIMIENTO,
    NEW.AUTO_MUERTE,
  	NOW(),
    CURRENT_USER(),
    'ACTUALIZACIÓN');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `ID_CLIENTE` int(11) NOT NULL,
  `NOM_CLIENTE` varchar(20) NOT NULL,
  `CORREO` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`ID_CLIENTE`, `NOM_CLIENTE`, `CORREO`) VALUES
(1, 'María', 'mariaramirez@gmail.com'),
(2, 'Carlos', 'marincarlos@gmail.com');

--
-- Disparadores `cliente`
--
DELIMITER $$
CREATE TRIGGER `SEGUIMIENTO_ACTUALIZACION_CLIENTE` BEFORE UPDATE ON `cliente` FOR EACH ROW INSERT INTO LOG_CLIENTE(
	ID_CLIENTE,
    NOMBRE_ANTERIOR ,
    CORREO_ANTERIOR ,
    NOMBRE_NUEVO,
    CORREO_NUEVO,
    FECHA_MODIFICACION,
    USUARIO_MODIFICACION,
    COMENTARIO)
    VALUES(NEW.ID_CLIENTE, OLD.NOM_CLIENTE, OLD.CORREO, NEW.NOM_CLIENTE, NEW.CORREO,NOW(), USER(), 'SE ACTUALIZO DATOS'
    )
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `seguimiento_eliminacion_cliente` BEFORE DELETE ON `cliente` FOR EACH ROW INSERT INTO LOG_CLIENTE(
    ID_CLIENTE,
    NOMBRE_ANTERIOR,
    CORREO_ANTERIOR,
    FECHA_MODIFICACION,
    USUARIO_MODIFICACION,
    COMENTARIO)
VALUES (OLD.ID_CLIENTE,OLD.NOM_CLIENTE,OLD.CORREO,NOW(),USER(),'Se eliminaron datos')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libro`
--

CREATE TABLE `libro` (
  `LIB_ISBN` bigint(20) NOT NULL,
  `LIB_TITULO` varchar(255) NOT NULL,
  `LIB_GENERO` varchar(20) NOT NULL,
  `LIB_NUMERO_PAGINA` int(11) NOT NULL,
  `LIB_DIAS_PRESTAMO` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `libro`
--

INSERT INTO `libro` (`LIB_ISBN`, `LIB_TITULO`, `LIB_GENERO`, `LIB_NUMERO_PAGINA`, `LIB_DIAS_PRESTAMO`) VALUES
(324587917, 'Stranger', 'Misterio', 564, 12),
(1234567890, 'El Sueño de los Susurros ', 'novela ', 275, 7),
(1357924680, 'El Jardín de las Mariposas Perdidas ', 'novela ', 536, 7),
(2468135790, 'La Melodía de la Oscuridad ', 'romance ', 189, 7),
(2718281828, 'El Bosque de los Suspiros ', 'novela ', 387, 2),
(3141592653, 'El Secreto de las Estrellas Olvidadas ', 'Misterio ', 203, 7),
(5555555555, 'La Última Llave del Destino ', 'cuento ', 503, 7),
(7777777777, 'El Misterio de la Luna Plateada ', 'Misterio ', 422, 7),
(8642097531, 'El Reloj de Arena Infinito ', 'novela ', 321, 7),
(8888888888, 'La Ciudad de los Susurros ', 'Misterio ', 274, 1),
(9517530862, 'Las Crónicas del Eco Silencioso ', 'fantasía ', 448, 7),
(9876543210, 'El Laberinto de los Recuerdos ', 'cuento ', 412, 7),
(9999999999, 'El Enigma de los Espejos Rotos ', 'romance ', 156, 7);

--
-- Disparadores `libro`
--
DELIMITER $$
CREATE TRIGGER `DELETE_LIBRO` AFTER DELETE ON `libro` FOR EACH ROW BEGIN
	INSERT INTO AUD_LIBROS(
	LIB_ISBN_AUDI,
	LIB_TITULO_NUEVO,
	LIB_GENERO_NUEVO,
	LIB_NUMERO_PAGINAS_NUEVO,
	LIB_DIAS_PRESTAMO,
	FECHA_MODIFICACION)
	VALUES(
	OLD.LIB_ISBN,
	OLD.LIB_TITULO,
	OLD.LIB_GENERO,
	OLD.LIB_NUMERO_PAGINA,
    OLD.LIB_DIAS_PRESTAMO, NOW()
);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `INSERT_LIBRO` AFTER INSERT ON `libro` FOR EACH ROW BEGIN
    INSERT INTO aud_libros(
        LIB_ISBN_AUDI,
        LIB_TITULO_NUEVO,
        LIB_GENERO_NUEVO,
        LIB_NUMERO_PAGINAS_NUEVO,
        LIB_DIAS_PRESTAMO,
      	FECHA_MODIFICACION)
    VALUES(
        NEW.LIB_ISBN,
        NEW.LIB_TITULO,
        NEW.LIB_GENERO,
        NEW.LIB_NUMERO_PAGINA,
        NEW.LIB_DIAS_PRESTAMO,
        NOW()
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `UPDATE_LIBRO` AFTER UPDATE ON `libro` FOR EACH ROW BEGIN
INSERT INTO AUD_LIBROS(
    LIB_ISBN_AUDI,
    LIB_TITULO_NUEVO,
    LIB_GENERO_NUEVO,
    LIB_NUMERO_PAGINAS_NUEVO,
    LIB_DIAS_PRESTAMO,
    FECHA_MODIFICACION)
VALUES(OLD.LIB_ISBN,
       NEW.LIB_TITULO,
       NEW.LIB_GENERO,
       NEW.LIB_NUMERO_PAGINA,
       NEW.LIB_DIAS_PRESTAMO,
       NOW()
       );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `libro_cliente`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `libro_cliente` (
`NOM_CLIENTE` varchar(20)
,`LIB_TITULO` varchar(255)
,`LIB_DIAS_PRESTAMO` tinyint(4)
,`FECHA_PRESTAMO` date
,`FECHA_DEVOLUCION` date
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_cliente`
--

CREATE TABLE `log_cliente` (
  `ID_LOG` int(11) NOT NULL,
  `ID_CLIENTE` int(11) DEFAULT NULL,
  `NOMBRE_ANTERIOR` varchar(20) DEFAULT NULL,
  `CORREO_ANTERIOR` varchar(20) DEFAULT NULL,
  `NOMBRE_NUEVO` varchar(20) DEFAULT NULL,
  `CORREO_NUEVO` varchar(20) DEFAULT NULL,
  `FECHA_MODIFICACION` datetime DEFAULT NULL,
  `USUARIO_MODIFICACION` varchar(20) DEFAULT NULL,
  `COMENTARIO` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `nombre_correo_aprendiz`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `nombre_correo_aprendiz` (
`NOM_APRENDIZ` varchar(50)
,`CORREO_APRENDIZ` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `posiciones`
--

CREATE TABLE `posiciones` (
  `id` int(11) NOT NULL,
  `grupo` char(10) NOT NULL,
  `pais` varchar(45) NOT NULL,
  `jugados` int(11) NOT NULL,
  `ganados` int(11) NOT NULL,
  `empatados` int(11) NOT NULL,
  `perdidos` int(11) NOT NULL,
  `puntos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamo`
--

CREATE TABLE `prestamo` (
  `ID_PRESTAMO` varchar(20) NOT NULL,
  `FECHA_PRESTAMO` date NOT NULL,
  `FECHA_DEVOLUCION` date NOT NULL,
  `COPIA_SOC_NUMERO` int(11) NOT NULL,
  `COPIA_LIB_ISBN` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prestamo`
--

INSERT INTO `prestamo` (`ID_PRESTAMO`, `FECHA_PRESTAMO`, `FECHA_DEVOLUCION`, `COPIA_SOC_NUMERO`, `COPIA_LIB_ISBN`) VALUES
('pres1 ', '2023-01-15', '2023-01-20', 1, 1234567890),
('pres2 ', '2023-02-03', '2023-02-04', 2, 9999999999),
('pres3 ', '2023-04-09', '2023-04-11', 6, 2718281828),
('pres4 ', '2023-06-14', '2023-06-15', 9, 8888888888),
('pres5 ', '2023-07-02', '2023-07-09', 10, 5555555555),
('pres6 ', '2023-08-19', '2023-08-26', 12, 5555555555),
('pres7 ', '2023-10-24', '2023-10-27', 3, 1357924680),
('pres8 ', '2023-11-11', '2023-11-12', 4, 9999999999);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socio`
--

CREATE TABLE `socio` (
  `SOC_NUMERO` int(11) NOT NULL,
  `SOC_NOMBRE` varchar(45) NOT NULL,
  `SOC_APELLIDO` varchar(45) NOT NULL,
  `SOC_DIRECCION` varchar(255) NOT NULL,
  `SOC_TELEFONO` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `socio`
--

INSERT INTO `socio` (`SOC_NUMERO`, `SOC_NOMBRE`, `SOC_APELLIDO`, `SOC_DIRECCION`, `SOC_TELEFONO`) VALUES
(1, 'Ana', 'Ruiz', 'Calle 72 # 2', '291876'),
(2, 'Andrés Felipe', 'Galindo Luna', 'Avenida del Sol 456, Pueblo Nuevo, Madrid', '2123456789'),
(3, 'Juan', 'González', 'Calle Principal 789, Villa Flores, Valencia', '2012345678'),
(4, 'María', 'Rodríguez', 'Carrera del Río 321, El Pueblo, Sevilla', '3012345678'),
(5, 'Pedro', 'Martínez', 'Calle del Bosque 654, Los Pinos, Málaga', '1234567812'),
(6, 'Ana', 'López', 'Avenida Central 987, Villa Hermosa, Bilbao', '6123456781'),
(7, 'Carlos', 'Sánchez', 'Calle de la Luna 234, El Prado, Alicante', '1123456781'),
(8, 'Laura', 'Ramírez', 'Carrera del Mar 567, Playa Azul, Palma de Mallorca', '1312345678'),
(9, 'Luis', 'Hernández', 'Avenida de la Montaña 890, Monte Verde, Granada', '6101234567'),
(10, 'Andrea', 'García', 'Calle del Sol 432, La Colina, Zaragoza', '1112345678'),
(11, 'Alejandro', 'Torres', 'Carrera del Oeste 765, Ciudad Nueva, Murcia', '4951234567'),
(12, 'Sofia', 'Morales', 'Avenida del Mar 098, Costa Brava, Gijón', '5512345678'),
(13, 'Luis', 'Rodriguez', 'Cra 14 calle 35', '3213363489'),
(25, 'Pedro', 'Rodriguez', 'Calle 137 #88-76', '3213364587'),
(40, 'Fabio', 'Torres', 'Calle 90', '3213363546');

--
-- Disparadores `socio`
--
DELIMITER $$
CREATE TRIGGER `SOCIOS_AFTER_DELETE` AFTER DELETE ON `socio` FOR EACH ROW INSERT INTO audi_socio(
	soc_Numero_audi,
    soc_Nombre_anterior,
    soc_Apellido_anterior,
    soc_Direccion_anterior,
    soc_Telefono_anterior,
    audi_fechaModificacion,
    audi_usuario,
    audi_accion)
VALUES(
	old.soc_numero,
    old.soc_nombre,
    old.soc_apellido,
    old.soc_direccion,
    old.soc_telefono,
    NOW(),
    CURRENT_USER(),
    'Registro eliminado')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `socios_before_update` BEFORE UPDATE ON `socio` FOR EACH ROW INSERT INTO audi_socio(
    soc_Numero_audi,
    soc_Nombre_anterior,
    soc_Apellido_anterior,
    soc_Direccion_anterior,
    soc_Telefono_anterior,
    soc_Nombre_nuevo,
    soc_Apellido_nuevo,
    soc_Direccion_nuevo,
    soc_Telefono_nuevo,
    audi_fechaModificacion,
    audi_usuario,
    audi_accion)
VALUES(
    new.soc_numero,
    old.soc_nombre,
    old.soc_apellido,
    old.soc_direccion,
    old.soc_telefono,
    new.soc_nombre,
    new.soc_apellido,
    new.soc_direccion,
    new.soc_telefono,
    NOW(),
    CURRENT_USER(),
    'Actualización')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `tipo_autor`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `tipo_autor` (
`AUT_CODIGO` int(11)
,`AUT_APELLIDO` varchar(45)
,`TIPO_AUTOR` varchar(20)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_autores`
--

CREATE TABLE `tipo_autores` (
  `COPIA_ISBN` bigint(20) NOT NULL,
  `COPIA_COD_AUTOR` int(11) NOT NULL,
  `TIPO_AUTOR` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_autores`
--

INSERT INTO `tipo_autores` (`COPIA_ISBN`, `COPIA_COD_AUTOR`, `TIPO_AUTOR`) VALUES
(1357924680, 123, 'Traductor'),
(1234567890, 123, 'Autor'),
(1234567890, 456, 'Coautor'),
(2718281828, 789, 'Traductor'),
(8888888888, 234, 'Autor'),
(2468135790, 234, 'Autor'),
(9876543210, 567, 'Autor'),
(1234567890, 890, 'Autor'),
(8642097531, 345, 'Autor'),
(8888888888, 345, 'Coautor'),
(5555555555, 678, 'Autor'),
(3141592653, 901, 'Autor'),
(9517530862, 432, 'Autor'),
(7777777777, 765, 'Autor'),
(9999999999, 98, 'Autor'),
(1357924680, 123, 'Traductor'),
(1234567890, 123, 'Autor'),
(1234567890, 456, 'Coautor'),
(2718281828, 789, 'Traductor'),
(8888888888, 234, 'Autor'),
(2468135790, 234, 'Autor'),
(9876543210, 567, 'Autor'),
(1234567890, 890, 'Autor'),
(8642097531, 345, 'Autor'),
(8888888888, 345, 'Coautor'),
(5555555555, 678, 'Autor'),
(3141592653, 901, 'Autor'),
(9517530862, 432, 'Autor'),
(7777777777, 765, 'Autor'),
(9999999999, 98, 'Autor');

-- --------------------------------------------------------

--
-- Estructura para la vista `libro_cliente`
--
DROP TABLE IF EXISTS `libro_cliente`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `libro_cliente`  AS SELECT `cliente`.`NOM_CLIENTE` AS `NOM_CLIENTE`, `libro`.`LIB_TITULO` AS `LIB_TITULO`, `libro`.`LIB_DIAS_PRESTAMO` AS `LIB_DIAS_PRESTAMO`, `prestamo`.`FECHA_PRESTAMO` AS `FECHA_PRESTAMO`, `prestamo`.`FECHA_DEVOLUCION` AS `FECHA_DEVOLUCION` FROM ((`cliente` join `libro`) join `prestamo`) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `nombre_correo_aprendiz`
--
DROP TABLE IF EXISTS `nombre_correo_aprendiz`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `nombre_correo_aprendiz`  AS SELECT `aprendiz`.`NOM_APRENDIZ` AS `NOM_APRENDIZ`, `aprendiz`.`CORREO_APRENDIZ` AS `CORREO_APRENDIZ` FROM `aprendiz` ORDER BY `aprendiz`.`NOM_APRENDIZ` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `tipo_autor`
--
DROP TABLE IF EXISTS `tipo_autor`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tipo_autor`  AS SELECT `autor`.`AUT_CODIGO` AS `AUT_CODIGO`, `autor`.`AUT_APELLIDO` AS `AUT_APELLIDO`, `tipo_autores`.`TIPO_AUTOR` AS `TIPO_AUTOR` FROM (`autor` join `tipo_autores`) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `aprendiz`
--
ALTER TABLE `aprendiz`
  ADD PRIMARY KEY (`ID_APRENDIZ`);

--
-- Indices de la tabla `audi_autor`
--
ALTER TABLE `audi_autor`
  ADD PRIMARY KEY (`ID_AUDI_AUTOR`);

--
-- Indices de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  ADD PRIMARY KEY (`ID_AUDI`);

--
-- Indices de la tabla `aud_libros`
--
ALTER TABLE `aud_libros`
  ADD PRIMARY KEY (`ID_AUD_LIBRO`);

--
-- Indices de la tabla `autor`
--
ALTER TABLE `autor`
  ADD PRIMARY KEY (`AUT_CODIGO`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`ID_CLIENTE`);

--
-- Indices de la tabla `libro`
--
ALTER TABLE `libro`
  ADD PRIMARY KEY (`LIB_ISBN`),
  ADD KEY `idx_libro` (`LIB_TITULO`);

--
-- Indices de la tabla `log_cliente`
--
ALTER TABLE `log_cliente`
  ADD PRIMARY KEY (`ID_LOG`);

--
-- Indices de la tabla `posiciones`
--
ALTER TABLE `posiciones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pais` (`pais`),
  ADD KEY `grupo` (`grupo`);

--
-- Indices de la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD PRIMARY KEY (`ID_PRESTAMO`),
  ADD KEY `COPIA_SOC_NUMERO` (`COPIA_SOC_NUMERO`),
  ADD KEY `COPIA_LIB_ISBN` (`COPIA_LIB_ISBN`);

--
-- Indices de la tabla `socio`
--
ALTER TABLE `socio`
  ADD PRIMARY KEY (`SOC_NUMERO`);

--
-- Indices de la tabla `tipo_autores`
--
ALTER TABLE `tipo_autores`
  ADD KEY `COPIA_ISBN` (`COPIA_ISBN`),
  ADD KEY `COPIA_COD_AUTOR` (`COPIA_COD_AUTOR`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `audi_autor`
--
ALTER TABLE `audi_autor`
  MODIFY `ID_AUDI_AUTOR` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  MODIFY `ID_AUDI` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `aud_libros`
--
ALTER TABLE `aud_libros`
  MODIFY `ID_AUD_LIBRO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `ID_CLIENTE` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `log_cliente`
--
ALTER TABLE `log_cliente`
  MODIFY `ID_LOG` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `posiciones`
--
ALTER TABLE `posiciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD CONSTRAINT `prestamo_ibfk_1` FOREIGN KEY (`COPIA_SOC_NUMERO`) REFERENCES `socio` (`SOC_NUMERO`),
  ADD CONSTRAINT `prestamo_ibfk_2` FOREIGN KEY (`COPIA_LIB_ISBN`) REFERENCES `libro` (`LIB_ISBN`);

--
-- Filtros para la tabla `tipo_autores`
--
ALTER TABLE `tipo_autores`
  ADD CONSTRAINT `tipo_autores_ibfk_1` FOREIGN KEY (`COPIA_ISBN`) REFERENCES `libro` (`LIB_ISBN`),
  ADD CONSTRAINT `tipo_autores_ibfk_2` FOREIGN KEY (`COPIA_COD_AUTOR`) REFERENCES `autor` (`AUT_CODIGO`);

DELIMITER $$
--
-- Eventos
--
CREATE DEFINER=`root`@`localhost` EVENT `anual_eliminar_prestamos` ON SCHEDULE EVERY 1 YEAR STARTS '2026-03-09 06:41:25' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    DELETE FROM prestamo
    WHERE fecha_devolucion <= NOW() - INTERVAL 1 YEAR;
    #datos menores a la fecha actual - 1 año
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
