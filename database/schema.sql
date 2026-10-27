-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/

-- Servidor: 127.0.0.1
-- Tiempo de generación: 27-10-2026 a las 07:21:31
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
-- Base de datos: `aprendly`
--
-- --------------------------------------------------------
--
-- Estructura de tabla para la tabla `aprendly_demo_seed_sessions`
--

CREATE TABLE `aprendly_demo_seed_sessions` (
  `session_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `aprendly_demo_seed_sessions`
--

INSERT INTO `aprendly_demo_seed_sessions` (`session_id`, `created_at`) VALUES
(1, '2026-10-27 06:17:21'),
(2, '2026-10-27 06:17:21'),
(3, '2026-10-27 06:17:21'),
(4, '2026-10-27 06:17:21'),
(5, '2026-10-27 06:17:21'),
(6, '2026-10-27 06:17:21'),
(7, '2026-10-27 06:17:21'),
(8, '2026-10-27 06:17:21'),
(9, '2026-10-27 06:17:21'),
(10, '2026-10-27 06:17:21'),
(11, '2026-10-27 06:17:21'),
(12, '2026-10-27 06:17:21'),
(13, '2026-10-27 06:17:21'),
(14, '2026-10-27 06:17:21'),
(15, '2026-10-27 06:17:21'),
(16, '2026-10-27 06:17:21'),
(17, '2026-10-27 06:17:21'),
(18, '2026-10-27 06:17:21'),
(19, '2026-10-27 06:17:21'),
(20, '2026-10-27 06:17:21'),
(21, '2026-10-27 06:17:21'),
(22, '2026-10-27 06:17:21'),
(23, '2026-10-27 06:17:21'),
(24, '2026-10-27 06:17:21'),
(25, '2026-10-27 06:17:21'),
(26, '2026-10-27 06:17:21'),
(27, '2026-10-27 06:17:21'),
(28, '2026-10-27 06:17:21'),
(29, '2026-10-27 06:17:21'),
(30, '2026-10-27 06:17:21'),
(31, '2026-10-27 06:17:21'),
(32, '2026-10-27 06:17:21'),
(33, '2026-10-27 06:17:21'),
(34, '2026-10-27 06:17:21'),
(35, '2026-10-27 06:17:21'),
(36, '2026-10-27 06:17:21'),
(37, '2026-10-27 06:17:21'),
(38, '2026-10-27 06:17:21'),
(39, '2026-10-27 06:17:21'),
(40, '2026-10-27 06:17:21'),
(41, '2026-10-27 06:17:21'),
(42, '2026-10-27 06:17:21'),
(43, '2026-10-27 06:17:21'),
(44, '2026-10-27 06:17:21'),
(45, '2026-10-27 06:17:21'),
(46, '2026-10-27 06:17:21'),
(47, '2026-10-27 06:17:21'),
(48, '2026-10-27 06:17:21'),
(49, '2026-10-27 06:17:21'),
(50, '2026-10-27 06:17:21'),
(51, '2026-10-27 06:17:21'),
(52, '2026-10-27 06:17:21'),
(53, '2026-10-27 06:17:21'),
(54, '2026-10-27 06:17:21'),
(55, '2026-10-27 06:17:21'),
(56, '2026-10-27 06:17:21'),
(57, '2026-10-27 06:17:21'),
(58, '2026-10-27 06:17:21'),
(59, '2026-10-27 06:17:21'),
(60, '2026-10-27 06:17:21'),
(61, '2026-10-27 06:17:21'),
(62, '2026-10-27 06:17:21'),
(63, '2026-10-27 06:17:21'),
(64, '2026-10-27 06:17:21'),
(65, '2026-10-27 06:17:21'),
(66, '2026-10-27 06:17:21'),
(67, '2026-10-27 06:17:21'),
(68, '2026-10-27 06:17:21'),
(69, '2026-10-27 06:17:21'),
(70, '2026-10-27 06:17:21'),
(71, '2026-10-27 06:17:21'),
(72, '2026-10-27 06:17:21'),
(73, '2026-10-27 06:17:21'),
(74, '2026-10-27 06:17:21'),
(75, '2026-10-27 06:17:21'),
(76, '2026-10-27 06:17:21'),
(77, '2026-10-27 06:17:21'),
(78, '2026-10-27 06:17:21'),
(79, '2026-10-27 06:17:21'),
(80, '2026-10-27 06:17:21'),
(81, '2026-10-27 06:17:21'),
(82, '2026-10-27 06:17:21'),
(83, '2026-10-27 06:17:21'),
(84, '2026-10-27 06:17:21'),
(85, '2026-10-27 06:17:21'),
(86, '2026-10-27 06:17:21'),
(87, '2026-10-27 06:17:21'),
(88, '2026-10-27 06:17:21'),
(89, '2026-10-27 06:17:21'),
(90, '2026-10-27 06:17:21'),
(91, '2026-10-27 06:17:21'),
(92, '2026-10-27 06:17:21'),
(93, '2026-10-27 06:17:21'),
(94, '2026-10-27 06:17:21'),
(95, '2026-10-27 06:17:21'),
(96, '2026-10-27 06:17:21'),
(97, '2026-10-27 06:17:21'),
(98, '2026-10-27 06:17:21'),
(99, '2026-10-27 06:17:21'),
(100, '2026-10-27 06:17:21'),
(101, '2026-10-27 06:17:21'),
(102, '2026-10-27 06:17:21'),
(103, '2026-10-27 06:17:21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aprendly_demo_seed_users`
--

CREATE TABLE `aprendly_demo_seed_users` (
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `aprendly_demo_seed_users`
--

INSERT INTO `aprendly_demo_seed_users` (`user_id`, `created_at`) VALUES
(16, '2026-10-27 06:17:20'),
(17, '2026-10-27 06:17:20'),
(18, '2026-10-27 06:17:20'),
(19, '2026-10-27 06:17:20'),
(20, '2026-10-27 06:17:20'),
(21, '2026-10-27 06:17:20'),
(22, '2026-10-27 06:17:20'),
(23, '2026-10-27 06:17:20'),
(24, '2026-10-27 06:17:20'),
(25, '2026-10-27 06:17:20'),
(26, '2026-10-27 06:17:20'),
(27, '2026-10-27 06:17:20'),
(28, '2026-10-27 06:17:20'),
(29, '2026-10-27 06:17:20'),
(30, '2026-10-27 06:17:20'),
(31, '2026-10-27 06:17:20'),
(32, '2026-10-27 06:17:20'),
(33, '2026-10-27 06:17:20'),
(34, '2026-10-27 06:17:20'),
(35, '2026-10-27 06:17:20'),
(36, '2026-10-27 06:17:20'),
(37, '2026-10-27 06:17:21'),
(38, '2026-10-27 06:17:21'),
(39, '2026-10-27 06:17:21'),
(40, '2026-10-27 06:17:21'),
(41, '2026-10-27 06:17:21'),
(42, '2026-10-27 06:17:21'),
(43, '2026-10-27 06:17:21'),
(44, '2026-10-27 06:17:21'),
(45, '2026-10-27 06:17:21'),
(46, '2026-10-27 06:17:21'),
(47, '2026-10-27 06:17:21'),
(48, '2026-10-27 06:17:21'),
(49, '2026-10-27 06:17:21'),
(50, '2026-10-27 06:17:21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `connection_requests`
--

CREATE TABLE `connection_requests` (
  `id` int(11) NOT NULL,
  `requester_id` int(11) NOT NULL,
  `recipient_id` int(11) NOT NULL,
  `status` enum('pending','accepted','rejected','cancelled') NOT NULL DEFAULT 'pending',
  `message` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `responded_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `conversations`
--

CREATE TABLE `conversations` (
  `id` int(11) NOT NULL,
  `user_one_id` int(11) NOT NULL,
  `user_two_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `knowledge`
--

CREATE TABLE `knowledge` (
  `id` int(11) NOT NULL,
  `name` varchar(80) NOT NULL,
  `category` varchar(80) NOT NULL DEFAULT 'General'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `knowledge`
--

INSERT INTO `knowledge` (`id`, `name`, `category`) VALUES
(1, 'Java', 'Programación'),
(2, 'Git', 'Herramientas'),
(3, 'HTML', 'Programación Web'),
(4, 'CSS', 'Programación Web'),
(5, 'Programación Web', 'Programación Web'),
(6, 'Estadística', 'Matemáticas'),
(7, 'Excel', 'Ofimática'),
(8, 'Python', 'Programación'),
(9, 'Machine Learning', 'IA/Datos'),
(10, 'Redes', 'Infraestructura'),
(11, 'Packet Tracer', 'Infraestructura'),
(12, 'Diseño UX', 'Diseño'),
(13, 'Figma', 'Diseño'),
(14, 'SQL', 'Bases de Datos'),
(15, 'Bases de Datos', 'Bases de Datos'),
(16, 'Matemáticas', 'Matemáticas'),
(17, 'Inglés', 'Idiomas'),
(18, 'Marketing', 'Negocios'),
(19, 'Comunicación', 'Comunicación');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matches`
--

CREATE TABLE `matches` (
  `id` int(11) NOT NULL,
  `user_a_id` int(11) NOT NULL,
  `user_b_id` int(11) NOT NULL,
  `compatibility` decimal(5,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mentorship_sessions`
--

CREATE TABLE `mentorship_sessions` (
  `id` int(11) NOT NULL,
  `mentor_id` int(11) NOT NULL,
  `learner_id` int(11) NOT NULL,
  `knowledge_id` int(11) NOT NULL,
  `scheduled_start` datetime NOT NULL,
  `scheduled_end` datetime NOT NULL,
  `modality` enum('online','presential') NOT NULL DEFAULT 'online',
  `meeting_url` varchar(500) DEFAULT NULL,
  `status` enum('proposed','accepted','rejected','cancelled','completed','no_show') NOT NULL DEFAULT 'proposed',
  `mentor_confirmed` tinyint(1) NOT NULL DEFAULT 0,
  `learner_confirmed` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `mentorship_sessions`
--

INSERT INTO `mentorship_sessions` (`id`, `mentor_id`, `learner_id`, `knowledge_id`, `scheduled_start`, `scheduled_end`, `modality`, `meeting_url`, `status`, `mentor_confirmed`, `learner_confirmed`, `created_at`, `updated_at`) VALUES
(1, 14, 1, 6, '2026-06-17 09:00:00', '2026-06-17 10:00:00', 'online', NULL, 'completed', 1, 1, '2026-06-15 14:00:00', '2026-10-27 06:17:21'),
(2, 20, 18, 19, '2026-06-18 16:30:00', '2026-06-18 17:30:00', 'online', NULL, 'completed', 1, 1, '2026-06-16 21:30:00', '2026-10-27 06:17:21'),
(3, 24, 36, 18, '2026-06-19 14:00:00', '2026-06-19 15:00:00', 'online', NULL, 'completed', 1, 1, '2026-06-17 19:00:00', '2026-10-27 06:17:21'),
(4, 11, 15, 16, '2026-06-20 12:30:00', '2026-06-20 13:30:00', 'online', NULL, 'completed', 1, 1, '2026-06-18 17:30:00', '2026-10-27 06:17:21'),
(5, 1, 32, 4, '2026-06-21 10:00:00', '2026-06-21 11:00:00', 'online', NULL, 'completed', 1, 1, '2026-06-19 15:00:00', '2026-10-27 06:17:21'),
(6, 18, 9, 13, '2026-06-22 17:30:00', '2026-06-22 18:30:00', 'online', NULL, 'completed', 1, 1, '2026-06-20 22:30:00', '2026-10-27 06:17:21'),
(7, 3, 28, 2, '2026-06-23 15:00:00', '2026-06-23 16:00:00', 'online', NULL, 'completed', 1, 1, '2026-06-21 20:00:00', '2026-10-27 06:17:21'),
(8, 8, 5, 18, '2026-06-25 13:30:00', '2026-06-25 14:30:00', 'online', NULL, 'completed', 1, 1, '2026-06-23 18:30:00', '2026-10-27 06:17:21'),
(9, 8, 23, 19, '2026-06-26 11:00:00', '2026-06-26 12:00:00', 'online', NULL, 'completed', 1, 1, '2026-06-24 16:00:00', '2026-10-27 06:17:21'),
(10, 9, 1, 14, '2026-06-27 09:30:00', '2026-06-27 10:30:00', 'online', NULL, 'completed', 1, 1, '2026-06-25 14:30:00', '2026-10-27 06:17:21'),
(11, 9, 19, 7, '2026-06-28 16:00:00', '2026-06-28 17:00:00', 'online', NULL, 'completed', 1, 1, '2026-06-26 21:00:00', '2026-10-27 06:17:21'),
(12, 4, 36, 11, '2026-06-29 14:30:00', '2026-06-29 15:30:00', 'online', NULL, 'completed', 1, 1, '2026-06-27 19:30:00', '2026-10-27 06:17:21'),
(13, 3, 15, 9, '2026-06-30 12:00:00', '2026-06-30 13:00:00', 'online', NULL, 'completed', 1, 1, '2026-06-28 17:00:00', '2026-10-27 06:17:21'),
(14, 12, 32, 18, '2026-07-02 10:30:00', '2026-07-02 11:30:00', 'online', NULL, 'completed', 1, 1, '2026-06-30 15:30:00', '2026-10-27 06:17:21'),
(15, 31, 9, 7, '2026-07-03 17:00:00', '2026-07-03 18:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-01 22:00:00', '2026-10-27 06:17:21'),
(16, 6, 28, 2, '2026-07-04 15:30:00', '2026-07-04 16:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-02 20:30:00', '2026-10-27 06:17:21'),
(17, 4, 6, 2, '2026-07-05 13:00:00', '2026-07-05 14:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-03 18:00:00', '2026-10-27 06:17:21'),
(18, 28, 22, 14, '2026-07-06 11:30:00', '2026-07-06 12:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-04 16:30:00', '2026-10-27 06:17:21'),
(19, 9, 1, 14, '2026-07-07 09:00:00', '2026-07-07 10:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-05 14:00:00', '2026-10-27 06:17:21'),
(20, 17, 19, 2, '2026-07-09 16:30:00', '2026-07-09 17:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-07 21:30:00', '2026-10-27 06:17:21'),
(21, 7, 36, 7, '2026-07-10 14:00:00', '2026-07-10 15:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-08 19:00:00', '2026-10-27 06:17:21'),
(22, 24, 14, 18, '2026-07-11 12:30:00', '2026-07-11 13:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-09 17:30:00', '2026-10-27 06:17:21'),
(23, 23, 32, 1, '2026-07-12 10:00:00', '2026-07-12 11:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-10 15:00:00', '2026-10-27 06:17:21'),
(24, 1, 10, 4, '2026-07-13 17:30:00', '2026-07-13 18:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-11 22:30:00', '2026-10-27 06:17:21'),
(25, 7, 28, 17, '2026-07-14 15:00:00', '2026-07-14 16:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-12 20:00:00', '2026-10-27 06:17:21'),
(26, 37, 5, 4, '2026-07-16 13:30:00', '2026-07-16 14:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-14 18:30:00', '2026-10-27 06:17:21'),
(27, 13, 23, 17, '2026-07-17 11:00:00', '2026-07-17 12:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-15 16:00:00', '2026-10-27 06:17:21'),
(28, 18, 1, 12, '2026-07-18 09:30:00', '2026-07-18 10:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-16 14:30:00', '2026-10-27 06:17:21'),
(29, 28, 18, 8, '2026-07-19 16:00:00', '2026-07-19 17:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-17 21:00:00', '2026-10-27 06:17:21'),
(30, 6, 36, 1, '2026-07-20 14:30:00', '2026-07-20 15:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-18 19:30:00', '2026-10-27 06:17:21'),
(31, 3, 15, 6, '2026-07-21 12:00:00', '2026-07-21 13:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-19 17:00:00', '2026-10-27 06:17:21'),
(32, 26, 32, 6, '2026-07-23 10:30:00', '2026-07-23 11:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-21 15:30:00', '2026-10-27 06:17:21'),
(33, 37, 9, 3, '2026-07-24 17:00:00', '2026-07-24 18:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-22 22:00:00', '2026-10-27 06:17:21'),
(34, 2, 28, 6, '2026-07-25 15:30:00', '2026-07-25 16:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-23 20:30:00', '2026-10-27 06:17:21'),
(35, 2, 6, 7, '2026-07-26 13:00:00', '2026-07-26 14:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-24 18:00:00', '2026-10-27 06:17:21'),
(36, 7, 23, 19, '2026-07-27 11:30:00', '2026-07-27 12:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-25 16:30:00', '2026-10-27 06:17:21'),
(37, 4, 1, 11, '2026-07-28 09:00:00', '2026-07-28 10:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-26 14:00:00', '2026-10-27 06:17:21'),
(38, 1, 19, 2, '2026-07-30 16:30:00', '2026-07-30 17:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-28 21:30:00', '2026-10-27 06:17:21'),
(39, 6, 36, 15, '2026-07-31 14:00:00', '2026-07-31 15:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-29 19:00:00', '2026-10-27 06:17:21'),
(40, 5, 15, 12, '2026-08-01 12:30:00', '2026-08-01 13:30:00', 'online', NULL, 'completed', 1, 1, '2026-07-30 17:30:00', '2026-10-27 06:17:21'),
(41, 2, 32, 6, '2026-08-02 10:00:00', '2026-08-02 11:00:00', 'online', NULL, 'completed', 1, 1, '2026-07-31 15:00:00', '2026-10-27 06:17:21'),
(42, 5, 10, 13, '2026-08-03 17:30:00', '2026-08-03 18:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-01 22:30:00', '2026-10-27 06:17:21'),
(43, 3, 28, 2, '2026-08-04 15:00:00', '2026-08-04 16:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-02 20:00:00', '2026-10-27 06:17:21'),
(44, 3, 6, 14, '2026-08-06 13:30:00', '2026-08-06 14:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-04 18:30:00', '2026-10-27 06:17:21'),
(45, 7, 23, 18, '2026-08-07 11:00:00', '2026-08-07 12:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-05 16:00:00', '2026-10-27 06:17:21'),
(46, 5, 1, 4, '2026-08-08 09:30:00', '2026-08-08 10:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-06 14:30:00', '2026-10-27 06:17:21'),
(47, 10, 19, 12, '2026-08-09 16:00:00', '2026-08-09 17:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-07 21:00:00', '2026-10-27 06:17:21'),
(48, 7, 36, 7, '2026-08-10 14:30:00', '2026-08-10 15:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-08 19:30:00', '2026-10-27 06:17:21'),
(49, 33, 14, 14, '2026-08-11 12:00:00', '2026-08-11 13:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-09 17:00:00', '2026-10-27 06:17:21'),
(50, 3, 32, 8, '2026-08-13 10:30:00', '2026-08-13 11:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-11 15:30:00', '2026-10-27 06:17:21'),
(51, 7, 10, 7, '2026-08-14 17:00:00', '2026-08-14 18:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-12 22:00:00', '2026-10-27 06:17:21'),
(52, 3, 28, 8, '2026-08-15 15:30:00', '2026-08-15 16:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-13 20:30:00', '2026-10-27 06:17:21'),
(53, 10, 5, 13, '2026-08-16 13:00:00', '2026-08-16 14:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-14 18:00:00', '2026-10-27 06:17:21'),
(54, 6, 23, 14, '2026-08-17 11:30:00', '2026-08-17 12:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-15 16:30:00', '2026-10-27 06:17:21'),
(55, 2, 1, 14, '2026-08-18 09:00:00', '2026-08-18 10:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-16 14:00:00', '2026-10-27 06:17:21'),
(56, 1, 19, 1, '2026-08-20 16:30:00', '2026-08-20 17:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-18 21:30:00', '2026-10-27 06:17:21'),
(57, 5, 36, 12, '2026-08-21 14:00:00', '2026-08-21 15:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-19 19:00:00', '2026-10-27 06:17:21'),
(58, 39, 14, 16, '2026-08-22 12:30:00', '2026-08-22 13:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-20 17:30:00', '2026-10-27 06:17:21'),
(59, 28, 32, 14, '2026-08-23 10:00:00', '2026-08-23 11:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-21 15:00:00', '2026-10-27 06:17:21'),
(60, 26, 9, 6, '2026-08-24 17:30:00', '2026-08-24 18:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-22 22:30:00', '2026-10-27 06:17:21'),
(61, 23, 28, 1, '2026-08-25 15:00:00', '2026-08-25 16:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-23 20:00:00', '2026-10-27 06:17:21'),
(62, 1, 6, 1, '2026-08-27 13:30:00', '2026-08-27 14:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-25 18:30:00', '2026-10-27 06:17:21'),
(63, 7, 23, 19, '2026-08-28 11:00:00', '2026-08-28 12:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-26 16:00:00', '2026-10-27 06:17:21'),
(64, 12, 1, 17, '2026-08-29 09:30:00', '2026-08-29 10:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-27 14:30:00', '2026-10-27 06:17:21'),
(65, 7, 19, 17, '2026-08-30 16:00:00', '2026-08-30 17:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-28 21:00:00', '2026-10-27 06:17:21'),
(66, 1, 36, 5, '2026-08-31 14:30:00', '2026-08-31 15:30:00', 'online', NULL, 'completed', 1, 1, '2026-08-29 19:30:00', '2026-10-27 06:17:21'),
(67, 4, 15, 8, '2026-09-01 12:00:00', '2026-09-01 13:00:00', 'online', NULL, 'completed', 1, 1, '2026-08-30 17:00:00', '2026-10-27 06:17:21'),
(68, 2, 32, 14, '2026-09-03 10:30:00', '2026-09-03 11:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-01 15:30:00', '2026-10-27 06:17:21'),
(69, 15, 9, 1, '2026-09-04 17:00:00', '2026-09-04 18:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-02 22:00:00', '2026-10-27 06:17:21'),
(70, 7, 28, 6, '2026-09-05 15:30:00', '2026-09-05 16:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-03 20:30:00', '2026-10-27 06:17:21'),
(71, 3, 6, 14, '2026-09-06 13:00:00', '2026-09-06 14:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-04 18:00:00', '2026-10-27 06:17:21'),
(72, 8, 23, 19, '2026-09-07 11:30:00', '2026-09-07 12:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-05 16:30:00', '2026-10-27 06:17:21'),
(73, 11, 1, 10, '2026-09-08 09:00:00', '2026-09-08 10:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-06 14:00:00', '2026-10-27 06:17:21'),
(74, 1, 19, 3, '2026-09-10 16:30:00', '2026-09-10 17:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-08 21:30:00', '2026-10-27 06:17:21'),
(75, 7, 36, 18, '2026-09-11 14:00:00', '2026-09-11 15:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-09 19:00:00', '2026-10-27 06:17:21'),
(76, 8, 15, 18, '2026-09-12 12:30:00', '2026-09-12 13:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-10 17:30:00', '2026-10-27 06:17:21'),
(77, 17, 32, 2, '2026-09-13 10:00:00', '2026-09-13 11:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-11 15:00:00', '2026-10-27 06:17:21'),
(78, 33, 9, 14, '2026-09-14 17:30:00', '2026-09-14 18:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-12 22:30:00', '2026-10-27 06:17:21'),
(79, 10, 28, 12, '2026-09-15 15:00:00', '2026-09-15 16:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-13 20:00:00', '2026-10-27 06:17:21'),
(80, 19, 5, 16, '2026-09-17 13:30:00', '2026-09-17 14:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-15 18:30:00', '2026-10-27 06:17:21'),
(81, 3, 23, 9, '2026-09-18 11:00:00', '2026-09-18 12:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-16 16:00:00', '2026-10-27 06:17:21'),
(82, 5, 1, 3, '2026-09-19 09:30:00', '2026-09-19 10:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-17 14:30:00', '2026-10-27 06:17:21'),
(83, 47, 22, 7, '2026-09-20 16:00:00', '2026-09-20 17:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-18 21:00:00', '2026-10-27 06:17:21'),
(84, 4, 36, 8, '2026-09-21 14:30:00', '2026-09-21 15:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-19 19:30:00', '2026-10-27 06:17:21'),
(85, 1, 15, 3, '2026-09-22 12:00:00', '2026-09-22 13:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-20 17:00:00', '2026-10-27 06:17:21'),
(86, 2, 32, 16, '2026-09-24 10:30:00', '2026-09-24 11:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-22 15:30:00', '2026-10-27 06:17:21'),
(87, 3, 10, 6, '2026-09-25 17:00:00', '2026-09-25 18:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-23 22:00:00', '2026-10-27 06:17:21'),
(88, 7, 28, 6, '2026-09-26 15:30:00', '2026-09-26 16:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-24 20:30:00', '2026-10-27 06:17:21'),
(89, 4, 6, 2, '2026-09-27 13:00:00', '2026-09-27 14:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-25 18:00:00', '2026-10-27 06:17:21'),
(90, 4, 23, 10, '2026-09-28 11:30:00', '2026-09-28 12:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-26 16:30:00', '2026-10-27 06:17:21'),
(91, 1, 2, 2, '2026-09-29 09:00:00', '2026-09-29 10:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-27 14:00:00', '2026-10-27 06:17:21'),
(92, 2, 19, 7, '2026-10-01 16:30:00', '2026-10-01 17:30:00', 'online', NULL, 'completed', 1, 1, '2026-09-29 21:30:00', '2026-10-27 06:17:21'),
(93, 2, 36, 6, '2026-10-02 14:00:00', '2026-10-02 15:00:00', 'online', NULL, 'completed', 1, 1, '2026-09-30 19:00:00', '2026-10-27 06:17:21'),
(94, 6, 15, 14, '2026-10-03 12:30:00', '2026-10-03 13:30:00', 'online', NULL, 'completed', 1, 1, '2026-10-01 17:30:00', '2026-10-27 06:17:21'),
(95, 35, 31, 11, '2026-10-04 10:00:00', '2026-10-04 11:00:00', 'online', NULL, 'completed', 1, 1, '2026-10-02 15:00:00', '2026-10-27 06:17:21'),
(96, 23, 9, 2, '2026-10-05 17:30:00', '2026-10-05 18:30:00', 'online', NULL, 'completed', 1, 1, '2026-10-03 22:30:00', '2026-10-27 06:17:21'),
(97, 3, 28, 9, '2026-10-06 15:00:00', '2026-10-06 16:00:00', 'online', NULL, 'completed', 1, 1, '2026-10-04 20:00:00', '2026-10-27 06:17:21'),
(98, 4, 6, 10, '2026-10-08 13:30:00', '2026-10-08 14:30:00', 'online', NULL, 'completed', 1, 1, '2026-10-06 18:30:00', '2026-10-27 06:17:21'),
(99, 3, 23, 8, '2026-10-09 11:00:00', '2026-10-09 12:00:00', 'online', NULL, 'completed', 1, 1, '2026-10-07 16:00:00', '2026-10-27 06:17:21'),
(100, 42, 37, 19, '2026-10-10 09:30:00', '2026-10-10 10:30:00', 'online', NULL, 'completed', 1, 1, '2026-10-08 14:30:00', '2026-10-27 06:17:21'),
(101, 1, 19, 5, '2026-10-11 16:00:00', '2026-10-11 17:00:00', 'online', NULL, 'completed', 1, 1, '2026-10-09 21:00:00', '2026-10-27 06:17:21'),
(102, 2, 36, 16, '2026-10-12 14:30:00', '2026-10-12 15:30:00', 'online', NULL, 'completed', 1, 1, '2026-10-10 19:30:00', '2026-10-27 06:17:21'),
(103, 6, 15, 15, '2026-10-13 12:00:00', '2026-10-13 13:00:00', 'online', NULL, 'completed', 1, 1, '2026-10-11 17:00:00', '2026-10-27 06:17:21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `conversation_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `body` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `event_type` varchar(60) NOT NULL,
  `title` varchar(160) NOT NULL,
  `body` varchar(500) DEFAULT NULL,
  `reference_type` varchar(50) DEFAULT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profiles`
--

CREATE TABLE `profiles` (
  `user_id` int(11) NOT NULL,
  `career` varchar(120) NOT NULL DEFAULT '',
  `semester` varchar(40) NOT NULL DEFAULT '',
  `bio` varchar(500) NOT NULL DEFAULT '',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `profiles`
--

INSERT INTO `profiles` (`user_id`, `career`, `semester`, `bio`, `updated_at`) VALUES
(1, 'Ingeniería Informática', '5to ciclo', 'Desarrollo web, Java y Git. Quiero mejorar mi Estadística.', '2026-10-27 06:17:20'),
(2, 'Ingeniería de Sistemas', '4to ciclo', 'Me gustan las matemáticas y compartir técnicas de Excel.', '2026-10-27 06:17:20'),
(3, 'Ciencia de la Computación', '6to ciclo', 'Trabajo con Python y Machine Learning; quiero dominar Git.', '2026-10-27 06:17:20'),
(4, 'Ingeniería de Redes', '3er ciclo', 'Me entusiasman las redes y las simulaciones de conectividad.', '2026-10-27 06:17:20'),
(5, 'Ingeniería de Software', '7mo ciclo', 'Diseño experiencias digitales y aprendo programación.', '2026-10-27 06:17:20'),
(6, 'Ingeniería de Sistemas', '8vo ciclo', 'Me gusta resolver problemas de bases de datos y backend.', '2026-10-27 06:17:20'),
(7, 'Administración', '5to ciclo', 'Intercambio conocimientos en comunicación y análisis.', '2026-10-27 06:17:20'),
(8, 'Comunicación', '4to ciclo', 'Aprendo tecnología y comparto herramientas digitales.', '2026-10-27 06:17:20'),
(9, 'Ingeniería Estadística', '7mo ciclo', 'Analizo datos y ayudo con fundamentos estadísticos.', '2026-10-27 06:17:20'),
(10, 'Ingeniería Informática', '3er ciclo', 'Quiero aprender a crear aplicaciones web.', '2026-10-27 06:17:20'),
(11, 'Ingeniería Electrónica', '6to ciclo', 'Comparto fundamentos matemáticos y redes.', '2026-10-27 06:17:20'),
(12, 'Ingeniería de Software', '5to ciclo', 'Me interesa la experiencia de usuario y programación.', '2026-10-27 06:17:20'),
(13, 'Administración', '2do ciclo', 'Nuevo en la comunidad; busco apoyo en herramientas digitales.', '2026-10-27 06:17:20'),
(14, 'Ciencia de Datos', '3er ciclo', 'Exploro diferentes técnicas de análisis y programación.', '2026-10-27 06:17:20'),
(15, 'Ingeniería Informática', '2do ciclo', 'Busco compañeros para reforzar mis cursos.', '2026-10-27 06:17:20'),
(16, 'Administración', '6to ciclo', 'Comparto Excel y también quiero aprender Inglés.', '2026-10-27 06:17:20'),
(17, 'Ingeniería de Sistemas', '4to ciclo', 'Comparto Git y también quiero aprender SQL.', '2026-10-27 06:17:20'),
(18, 'Diseño Gráfico', '5to ciclo', 'Comparto Figma y también quiero aprender HTML.', '2026-10-27 06:17:20'),
(19, 'Ingeniería Industrial', '3to ciclo', 'Comparto Matemáticas y también quiero aprender Excel.', '2026-10-27 06:17:20'),
(20, 'Comunicación', '4to ciclo', 'Comparto Comunicación y también quiero aprender Marketing.', '2026-10-27 06:17:20'),
(21, 'Contabilidad', '2to ciclo', 'Busco apoyo para aprender Excel.', '2026-10-27 06:17:20'),
(22, 'Psicología', '5to ciclo', 'Busco apoyo para aprender Inglés.', '2026-10-27 06:17:20'),
(23, 'Ingeniería de Software', '6to ciclo', 'Comparto Java y también quiero aprender Machine Learning.', '2026-10-27 06:17:20'),
(24, 'Marketing', '4to ciclo', 'Comparto Marketing y también quiero aprender Figma.', '2026-10-27 06:17:20'),
(25, 'Arquitectura', '3to ciclo', 'Busco apoyo para aprender Figma.', '2026-10-27 06:17:20'),
(26, 'Economía', '6to ciclo', 'Comparto Estadística y también quiero aprender Python.', '2026-10-27 06:17:20'),
(27, 'Ingeniería Civil', '4to ciclo', 'Busco apoyo para aprender Matemáticas.', '2026-10-27 06:17:20'),
(28, 'Ciencia de Datos', '7to ciclo', 'Comparto SQL y también quiero aprender Redes.', '2026-10-27 06:17:20'),
(29, 'Derecho', '3to ciclo', 'Busco apoyo para aprender Comunicación.', '2026-10-27 06:17:20'),
(30, 'Ingeniería Informática', '2to ciclo', 'Busco apoyo para aprender Java.', '2026-10-27 06:17:20'),
(31, 'Administración', '5to ciclo', 'Comparto Excel y también quiero aprender Inglés.', '2026-10-27 06:17:20'),
(32, 'Publicidad', '4to ciclo', 'Busco apoyo para aprender Diseño UX.', '2026-10-27 06:17:20'),
(33, 'Ingeniería de Sistemas', '5to ciclo', 'Comparto SQL y también quiero aprender Machine Learning.', '2026-10-27 06:17:20'),
(34, 'Psicología', '2to ciclo', 'Busco apoyo para aprender Estadística.', '2026-10-27 06:17:20'),
(35, 'Ingeniería de Redes', '4to ciclo', 'Comparto Packet Tracer y también quiero aprender Python.', '2026-10-27 06:17:20'),
(36, 'Contabilidad', '3to ciclo', 'Busco apoyo para aprender Excel.', '2026-10-27 06:17:20'),
(37, 'Ciencia de la Computación', '6to ciclo', 'Comparto HTML y también quiero aprender SQL.', '2026-10-27 06:17:21'),
(38, 'Negocios Internacionales', '5to ciclo', 'Busco apoyo para aprender Inglés.', '2026-10-27 06:17:21'),
(39, 'Ingeniería Electrónica', '4to ciclo', 'Comparto Matemáticas y también quiero aprender Redes.', '2026-10-27 06:17:21'),
(40, 'Diseño UX', '3to ciclo', 'Comparto Figma y también quiero aprender HTML.', '2026-10-27 06:17:21'),
(41, 'Administración', '2to ciclo', 'Busco apoyo para aprender Excel.', '2026-10-27 06:17:21'),
(42, 'Comunicación Audiovisual', '6to ciclo', 'Comparto Comunicación y también quiero aprender Diseño UX.', '2026-10-27 06:17:21'),
(43, 'Ingeniería de Sistemas', '3to ciclo', 'Busco apoyo para aprender Java.', '2026-10-27 06:17:21'),
(44, 'Economía', '4to ciclo', 'Busco apoyo para aprender Estadística.', '2026-10-27 06:17:21'),
(45, 'Ingeniería de Software', '2to ciclo', 'Busco apoyo para aprender Git.', '2026-10-27 06:17:21'),
(46, 'Psicología', '4to ciclo', 'Busco apoyo para aprender Inglés.', '2026-10-27 06:17:21'),
(47, 'Ingeniería Industrial', '5to ciclo', 'Comparto Excel y también quiero aprender Python.', '2026-10-27 06:17:21'),
(48, 'Administración', '3to ciclo', 'Busco apoyo para aprender Marketing.', '2026-10-27 06:17:21'),
(49, 'Informática', '6to ciclo', 'Comparto Git y también quiero aprender Redes.', '2026-10-27 06:17:21'),
(50, 'Comunicación', '4to ciclo', 'Busco apoyo para aprender Inglés.', '2026-10-27 06:17:21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recognitions`
--

CREATE TABLE `recognitions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `period_year` smallint(6) NOT NULL,
  `period_month` tinyint(4) NOT NULL,
  `rank_position` tinyint(4) NOT NULL,
  `average_rating` decimal(3,2) NOT NULL,
  `sessions_count` int(11) NOT NULL,
  `verification_code` varchar(64) NOT NULL,
  `issued_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `session_reviews`
--

CREATE TABLE `session_reviews` (
  `id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `reviewer_id` int(11) NOT NULL,
  `reviewed_id` int(11) NOT NULL,
  `rating` tinyint(3) UNSIGNED NOT NULL,
  `comment` varchar(1000) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
--
-- Volcado de datos para la tabla `session_reviews`
--

INSERT INTO `session_reviews` (`id`, `session_id`, `reviewer_id`, `reviewed_id`, `rating`, `comment`, `created_at`) VALUES
(1, 7, 28, 3, 5, NULL, '2026-06-24 00:00:00'),
(2, 13, 15, 3, 5, 'Explicación clara y ejemplos útiles.', '2026-06-30 21:00:00'),
(3, 31, 15, 3, 5, NULL, '2026-07-21 21:00:00'),
(4, 43, 28, 3, 5, NULL, '2026-08-05 00:00:00'),
(5, 44, 6, 3, 4, NULL, '2026-08-06 22:30:00'),
(6, 50, 32, 3, 5, NULL, '2026-08-13 19:30:00'),
(7, 52, 28, 3, 4, NULL, '2026-08-16 00:30:00'),
(8, 71, 6, 3, 5, NULL, '2026-09-06 22:00:00'),
(9, 81, 23, 3, 5, 'Tuvo paciencia para explicar.', '2026-09-18 20:00:00'),
(10, 87, 10, 3, 4, NULL, '2026-09-26 02:00:00'),
(11, 97, 28, 3, 5, 'Explicación clara y ejemplos útiles.', '2026-10-07 00:00:00'),
(12, 99, 23, 3, 5, NULL, '2026-10-09 20:00:00'),
(13, 20, 19, 17, 5, NULL, '2026-07-10 01:30:00'),
(14, 77, 32, 17, 4, 'Aprendí a aplicar el tema.', '2026-09-13 19:00:00'),
(15, 6, 9, 18, 5, NULL, '2026-06-23 02:30:00'),
(16, 28, 1, 18, 4, NULL, '2026-07-18 18:30:00'),
(17, 80, 5, 19, 5, NULL, '2026-09-17 22:30:00'),
(18, 2, 18, 20, 5, NULL, '2026-06-19 01:30:00'),
(19, 23, 32, 23, 5, NULL, '2026-07-12 19:00:00'),
(20, 61, 28, 23, 4, 'Explicación clara y ejemplos útiles.', '2026-08-26 00:00:00'),
(21, 96, 9, 23, 4, NULL, '2026-10-06 02:30:00'),
(22, 3, 36, 24, 5, NULL, '2026-06-19 23:00:00'),
(23, 22, 14, 24, 4, NULL, '2026-07-11 21:30:00'),
(24, 32, 32, 26, 3, NULL, '2026-07-23 19:30:00'),
(25, 60, 9, 26, 4, NULL, '2026-08-25 02:30:00'),
(26, 18, 22, 28, 4, NULL, '2026-07-06 20:30:00'),
(27, 29, 18, 28, 4, 'Aprendí a aplicar el tema.', '2026-07-20 01:00:00'),
(28, 59, 32, 28, 5, NULL, '2026-08-23 19:00:00'),
(29, 15, 9, 31, 3, NULL, '2026-07-04 02:00:00'),
(30, 49, 14, 33, 4, 'Explicación clara y ejemplos útiles.', '2026-08-11 21:00:00'),
(31, 78, 9, 33, 5, NULL, '2026-09-15 02:30:00'),
(32, 95, 31, 35, 5, NULL, '2026-10-04 19:00:00'),
(33, 26, 5, 37, 4, NULL, '2026-07-16 22:30:00'),
(34, 33, 9, 37, 5, 'Tuvo paciencia para explicar.', '2026-07-25 02:00:00'),
(35, 58, 14, 39, 5, NULL, '2026-08-22 21:30:00'),
(36, 100, 37, 42, 5, NULL, '2026-10-10 18:30:00'),
(37, 83, 22, 47, 5, NULL, '2026-09-21 01:00:00'),
(38, 69, 9, 15, 4, 'Tuvo paciencia para explicar.', '2026-09-05 02:00:00'),
(39, 47, 19, 10, 4, NULL, '2026-08-10 01:00:00'),
(40, 53, 5, 10, 4, 'Aprendí a aplicar el tema.', '2026-08-16 22:00:00'),
(41, 79, 28, 10, 5, NULL, '2026-09-16 00:00:00'),
(42, 34, 28, 2, 4, NULL, '2026-07-26 00:30:00'),
(43, 35, 6, 2, 5, NULL, '2026-07-26 22:00:00'),
(44, 41, 32, 2, 5, 'Aprendí a aplicar el tema.', '2026-08-02 19:00:00'),
(45, 55, 1, 2, 4, NULL, '2026-08-18 18:00:00'),
(46, 68, 32, 2, 5, NULL, '2026-09-03 19:30:00'),
(47, 86, 32, 2, 5, NULL, '2026-09-24 19:30:00'),
(48, 92, 19, 2, 4, NULL, '2026-10-02 01:30:00'),
(49, 93, 36, 2, 5, 'Tuvo paciencia para explicar.', '2026-10-02 23:00:00'),
(50, 102, 36, 2, 4, NULL, '2026-10-12 23:30:00'),
(51, 10, 1, 9, 3, NULL, '2026-06-27 18:30:00'),
(52, 11, 19, 9, 5, NULL, '2026-06-29 01:00:00'),
(53, 19, 1, 9, 4, NULL, '2026-07-07 18:00:00'),
(54, 16, 28, 6, 5, NULL, '2026-07-05 00:30:00'),
(55, 30, 36, 6, 4, NULL, '2026-07-20 23:30:00'),
(56, 39, 36, 6, 4, NULL, '2026-07-31 23:00:00'),
(57, 54, 23, 6, 4, NULL, '2026-08-17 20:30:00'),
(58, 94, 15, 6, 5, NULL, '2026-10-03 21:30:00'),
(59, 103, 15, 6, 4, NULL, '2026-10-13 21:00:00'),
(60, 4, 15, 11, 5, NULL, '2026-06-20 21:30:00'),
(61, 73, 1, 11, 4, 'Explicación clara y ejemplos útiles.', '2026-09-08 18:00:00'),
(62, 5, 32, 1, 5, 'Aprendí a aplicar el tema.', '2026-06-21 19:00:00'),
(63, 24, 10, 1, 5, NULL, '2026-07-14 02:30:00'),
(64, 38, 19, 1, 5, NULL, '2026-07-31 01:30:00'),
(65, 56, 19, 1, 4, NULL, '2026-08-21 01:30:00'),
(66, 62, 6, 1, 4, NULL, '2026-08-27 22:30:00'),
(67, 66, 36, 1, 5, NULL, '2026-08-31 23:30:00'),
(68, 74, 19, 1, 4, NULL, '2026-09-11 01:30:00'),
(69, 85, 15, 1, 4, 'Explicación clara y ejemplos útiles.', '2026-09-22 21:00:00'),
(70, 91, 2, 1, 5, NULL, '2026-09-29 18:00:00'),
(71, 101, 19, 1, 5, 'Aprendí a aplicar el tema.', '2026-10-12 01:00:00'),
(72, 8, 5, 8, 4, NULL, '2026-06-25 22:30:00'),
(73, 9, 23, 8, 5, 'Tuvo paciencia para explicar.', '2026-06-26 20:00:00'),
(74, 72, 23, 8, 4, NULL, '2026-09-07 20:30:00'),
(75, 76, 15, 8, 4, NULL, '2026-09-12 21:30:00'),
(76, 14, 32, 12, 4, NULL, '2026-07-02 19:30:00'),
(77, 64, 1, 12, 5, NULL, '2026-08-29 18:30:00'),
(78, 12, 36, 4, 5, NULL, '2026-06-29 23:30:00'),
(79, 17, 6, 4, 5, 'Aprendí a aplicar el tema.', '2026-07-05 22:00:00'),
(80, 37, 1, 4, 4, 'Explicación clara y ejemplos útiles.', '2026-07-28 18:00:00'),
(81, 67, 15, 4, 5, NULL, '2026-09-01 21:00:00'),
(82, 84, 36, 4, 4, NULL, '2026-09-21 23:30:00'),
(83, 89, 6, 4, 4, 'Aprendí a aplicar el tema.', '2026-09-27 22:00:00'),
(84, 90, 23, 4, 4, NULL, '2026-09-28 20:30:00'),
(85, 98, 6, 4, 4, NULL, '2026-10-08 22:30:00'),
(86, 1, 1, 14, 4, 'Explicación clara y ejemplos útiles.', '2026-06-17 18:00:00'),
(87, 27, 23, 13, 5, NULL, '2026-07-17 20:00:00'),
(88, 21, 36, 7, 5, 'Tuvo paciencia para explicar.', '2026-07-10 23:00:00'),
(89, 25, 28, 7, 5, 'Explicación clara y ejemplos útiles.', '2026-07-15 00:00:00'),
(90, 36, 23, 7, 5, NULL, '2026-07-27 20:30:00'),
(91, 45, 23, 7, 5, 'Tuvo paciencia para explicar.', '2026-08-07 20:00:00'),
(92, 48, 36, 7, 5, NULL, '2026-08-10 23:30:00'),
(93, 51, 10, 7, 4, NULL, '2026-08-15 02:00:00'),
(94, 63, 23, 7, 5, NULL, '2026-08-28 20:00:00'),
(95, 65, 19, 7, 4, 'Aprendí a aplicar el tema.', '2026-08-31 01:00:00'),
(96, 70, 28, 7, 5, NULL, '2026-09-06 00:30:00'),
(97, 75, 36, 7, 4, NULL, '2026-09-11 23:00:00'),
(98, 88, 28, 7, 5, NULL, '2026-09-27 00:30:00'),
(99, 40, 15, 5, 5, NULL, '2026-08-01 21:30:00'),
(100, 42, 10, 5, 4, NULL, '2026-08-04 02:30:00'),
(101, 46, 1, 5, 4, NULL, '2026-08-08 18:30:00'),
(102, 57, 36, 5, 5, 'Tuvo paciencia para explicar.', '2026-08-21 23:00:00'),
(103, 82, 1, 5, 5, NULL, '2026-09-19 18:30:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `universities`
--

CREATE TABLE `universities` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `domain` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `universities`
--

INSERT INTO `universities` (`id`, `name`, `domain`, `created_at`) VALUES
(1, 'Universidad Tecnológica del Perú (UTP)', 'utp.edu.pe', '2026-10-27 06:17:20'),
(2, 'Universidad Nacional Mayor de San Marcos', 'unmsm.edu.pe', '2026-10-27 06:17:20'),
(3, 'Pontificia Universidad Católica del Perú', 'pucp.edu.pe', '2026-10-27 06:17:20'),
(4, 'Universidad Peruana de Ciencias Aplicadas', 'upc.edu.pe', '2026-10-27 06:17:20'),
(5, 'Universidad Nacional de Ingeniería', 'uni.edu.pe', '2026-10-27 06:17:20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(80) NOT NULL,
  `last_name` varchar(80) NOT NULL,
  `institutional_email` varchar(160) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `university_id` int(11) DEFAULT NULL,
  `university_name` varchar(150) NOT NULL DEFAULT '',
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `verification_code` varchar(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `institutional_email`, `password_hash`, `university_id`, `university_name`, `is_verified`, `verification_code`, `created_at`) VALUES
(1, 'Leonardo', 'Ramos', 'leonardo.ramos@utp.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 1, 'Universidad Tecnológica del Perú (UTP)', 1, NULL, '2026-10-27 06:17:20'),
(2, 'Carlos', 'Mendoza', 'carlos.mendoza@unmsm.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 2, 'Universidad Nacional Mayor de San Marcos', 1, NULL, '2026-10-27 06:17:20'),
(3, 'Andrea', 'Torres', 'andrea.torres@pucp.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 3, 'Pontificia Universidad Católica del Perú', 1, NULL, '2026-10-27 06:17:20'),
(4, 'Miguel', 'Quispe', 'miguel.quispe@upc.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 4, 'Universidad Peruana de Ciencias Aplicadas', 1, NULL, '2026-10-27 06:17:20'),
(5, 'Valeria', 'Castillo', 'valeria.castillo.demo@utp.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 1, 'Universidad Tecnológica del Perú (UTP)', 1, NULL, '2026-10-27 06:17:20'),
(6, 'Diego', 'Rojas', 'diego.rojas.demo@uni.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 5, 'Universidad Nacional de Ingeniería', 1, NULL, '2026-10-27 06:17:20'),
(7, 'Sofía', 'Ramírez', 'sofia.ramirez.demo@pucp.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 3, 'Pontificia Universidad Católica del Perú', 1, NULL, '2026-10-27 06:17:20'),
(8, 'Luciana', 'Pérez', 'luciana.perez.demo@upc.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 4, 'Universidad Peruana de Ciencias Aplicadas', 1, NULL, '2026-10-27 06:17:20'),
(9, 'Daniel', 'Flores', 'daniel.flores.demo@unmsm.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 2, 'Universidad Nacional Mayor de San Marcos', 1, NULL, '2026-10-27 06:17:20'),
(10, 'Camila', 'Vargas', 'camila.vargas.demo@utp.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 1, 'Universidad Tecnológica del Perú (UTP)', 1, NULL, '2026-10-27 06:17:20'),
(11, 'José', 'Navarro', 'jose.navarro.demo@uni.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 5, 'Universidad Nacional de Ingeniería', 1, NULL, '2026-10-27 06:17:20'),
(12, 'Mariana', 'Salazar', 'mariana.salazar.demo@upc.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 4, 'Universidad Peruana de Ciencias Aplicadas', 1, NULL, '2026-10-27 06:17:20'),
(13, 'Renato', 'García', 'renato.garcia.demo@unmsm.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 2, 'Universidad Nacional Mayor de San Marcos', 1, NULL, '2026-10-27 06:17:20'),
(14, 'Paula', 'Medina', 'paula.medina.demo@pucp.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 3, 'Pontificia Universidad Católica del Perú', 1, NULL, '2026-10-27 06:17:20'),
(15, 'Bruno', 'Herrera', 'bruno.herrera.demo@utp.edu.pe', '$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W', 1, 'Universidad Tecnológica del Perú (UTP)', 1, NULL, '2026-10-27 06:17:20'),
(16, 'Ariana', 'Paredes', 'aprendly.demo01@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 4, 'Universidad Peruana de Ciencias Aplicadas', 1, NULL, '2026-10-27 06:17:20'),
(17, 'Mateo', 'Cruz', 'aprendly.demo02@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 1, 'Universidad Tecnológica del Perú (UTP)', 1, NULL, '2026-10-27 06:17:20'),
(18, 'Fernanda', 'Ruiz', 'aprendly.demo03@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 3, 'Pontificia Universidad Católica del Perú', 1, NULL, '2026-10-27 06:17:20'),
(19, 'Emilio', 'Vega', 'aprendly.demo04@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 5, 'Universidad Nacional de Ingeniería', 1, NULL, '2026-10-27 06:17:20'),
(20, 'Alessia', 'Campos', 'aprendly.demo05@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 4, 'Universidad Peruana de Ciencias Aplicadas', 1, NULL, '2026-10-27 06:17:20'),
(21, 'Joaquín', 'Torres', 'aprendly.demo06@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 2, 'Universidad Nacional Mayor de San Marcos', 1, NULL, '2026-10-27 06:17:20'),
(22, 'Karla', 'Reyes', 'aprendly.demo07@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 3, 'Pontificia Universidad Católica del Perú', 1, NULL, '2026-10-27 06:17:20'),
(23, 'Sebastián', 'Flores', 'aprendly.demo08@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 1, 'Universidad Tecnológica del Perú (UTP)', 1, NULL, '2026-10-27 06:17:20'),
(24, 'Rocío', 'Guzmán', 'aprendly.demo09@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 4, 'Universidad Peruana de Ciencias Aplicadas', 1, NULL, '2026-10-27 06:17:20'),
(25, 'Alonso', 'Pinto', 'aprendly.demo10@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 5, 'Universidad Nacional de Ingeniería', 1, NULL, '2026-10-27 06:17:20'),
(26, 'María', 'Chávez', 'aprendly.demo11@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 2, 'Universidad Nacional Mayor de San Marcos', 1, NULL, '2026-10-27 06:17:20'),
(27, 'Esteban', 'Cárdenas', 'aprendly.demo12@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 5, 'Universidad Nacional de Ingeniería', 1, NULL, '2026-10-27 06:17:20'),
(28, 'Daniela', 'Soto', 'aprendly.demo13@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 3, 'Pontificia Universidad Católica del Perú', 1, NULL, '2026-10-27 06:17:20'),
(29, 'Nicolás', 'Herrera', 'aprendly.demo14@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 4, 'Universidad Peruana de Ciencias Aplicadas', 1, NULL, '2026-10-27 06:17:20'),
(30, 'Jimena', 'Cabrera', 'aprendly.demo15@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 1, 'Universidad Tecnológica del Perú (UTP)', 1, NULL, '2026-10-27 06:17:20'),
(31, 'Rodrigo', 'Molina', 'aprendly.demo16@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 2, 'Universidad Nacional Mayor de San Marcos', 1, NULL, '2026-10-27 06:17:20'),
(32, 'Camila', 'Aguilar', 'aprendly.demo17@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 4, 'Universidad Peruana de Ciencias Aplicadas', 1, NULL, '2026-10-27 06:17:20'),
(33, 'Santiago', 'Paz', 'aprendly.demo18@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 5, 'Universidad Nacional de Ingeniería', 1, NULL, '2026-10-27 06:17:20'),
(34, 'Renata', 'Bautista', 'aprendly.demo19@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 3, 'Pontificia Universidad Católica del Perú', 1, NULL, '2026-10-27 06:17:20'),
(35, 'Hugo', 'Navarro', 'aprendly.demo20@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 1, 'Universidad Tecnológica del Perú (UTP)', 1, NULL, '2026-10-27 06:17:20'),
(36, 'Nicole', 'Luna', 'aprendly.demo21@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 2, 'Universidad Nacional Mayor de San Marcos', 1, NULL, '2026-10-27 06:17:20'),
(37, 'Álvaro', 'Silva', 'aprendly.demo22@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 3, 'Pontificia Universidad Católica del Perú', 1, NULL, '2026-10-27 06:17:21'),
(38, 'Fiorella', 'Castro', 'aprendly.demo23@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 4, 'Universidad Peruana de Ciencias Aplicadas', 1, NULL, '2026-10-27 06:17:21'),
(39, 'Kevin', 'López', 'aprendly.demo24@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 5, 'Universidad Nacional de Ingeniería', 1, NULL, '2026-10-27 06:17:21'),
(40, 'Lucero', 'Romero', 'aprendly.demo25@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 1, 'Universidad Tecnológica del Perú (UTP)', 1, NULL, '2026-10-27 06:17:21'),
(41, 'Adrián', 'Peña', 'aprendly.demo26@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 2, 'Universidad Nacional Mayor de San Marcos', 1, NULL, '2026-10-27 06:17:21'),
(42, 'Claudia', 'Morales', 'aprendly.demo27@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 3, 'Pontificia Universidad Católica del Perú', 1, NULL, '2026-10-27 06:17:21'),
(43, 'Gonzalo', 'Medina', 'aprendly.demo28@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 4, 'Universidad Peruana de Ciencias Aplicadas', 1, NULL, '2026-10-27 06:17:21'),
(44, 'Brenda', 'Palacios', 'aprendly.demo29@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 2, 'Universidad Nacional Mayor de San Marcos', 1, NULL, '2026-10-27 06:17:21'),
(45, 'Thiago', 'Mendoza', 'aprendly.demo30@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 1, 'Universidad Tecnológica del Perú (UTP)', 1, NULL, '2026-10-27 06:17:21'),
(46, 'Isabel', 'Fuentes', 'aprendly.demo31@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 3, 'Pontificia Universidad Católica del Perú', 1, NULL, '2026-10-27 06:17:21'),
(47, 'Óscar', 'Ríos', 'aprendly.demo32@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 5, 'Universidad Nacional de Ingeniería', 1, NULL, '2026-10-27 06:17:21'),
(48, 'Valentina', 'Acuña', 'aprendly.demo33@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 4, 'Universidad Peruana de Ciencias Aplicadas', 1, NULL, '2026-10-27 06:17:21'),
(49, 'Fabricio', 'Salinas', 'aprendly.demo34@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 1, 'Universidad Tecnológica del Perú (UTP)', 1, NULL, '2026-10-27 06:17:21'),
(50, 'Diana', 'Vergara', 'aprendly.demo35@example.test', '$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai', 2, 'Universidad Nacional Mayor de San Marcos', 1, NULL, '2026-10-27 06:17:21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_availability`
--

CREATE TABLE `user_availability` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `weekday` tinyint(4) NOT NULL COMMENT '1=lunes,7=domingo',
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_learn_knowledge`
--

CREATE TABLE `user_learn_knowledge` (
  `user_id` int(11) NOT NULL,
  `knowledge_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `user_learn_knowledge`
--

INSERT INTO `user_learn_knowledge` (`user_id`, `knowledge_id`, `created_at`) VALUES
(1, 6, '2026-10-27 06:17:20'),
(1, 7, '2026-10-27 06:17:20'),
(2, 1, '2026-10-27 06:17:20'),
(2, 8, '2026-10-27 06:17:20'),
(3, 2, '2026-10-27 06:17:20'),
(3, 12, '2026-10-27 06:17:20'),
(4, 3, '2026-10-27 06:17:20'),
(4, 4, '2026-10-27 06:17:20'),
(5, 8, '2026-10-27 06:17:20'),
(5, 14, '2026-10-27 06:17:20'),
(6, 9, '2026-10-27 06:17:20'),
(6, 17, '2026-10-27 06:17:20'),
(7, 6, '2026-10-27 06:17:20'),
(7, 8, '2026-10-27 06:17:20'),
(8, 3, '2026-10-27 06:17:20'),
(8, 18, '2026-10-27 06:17:20'),
(9, 2, '2026-10-27 06:17:20'),
(9, 9, '2026-10-27 06:17:20'),
(10, 1, '2026-10-27 06:17:20'),
(10, 14, '2026-10-27 06:17:20'),
(11, 2, '2026-10-27 06:17:20'),
(11, 8, '2026-10-27 06:17:20'),
(12, 7, '2026-10-27 06:17:20'),
(12, 9, '2026-10-27 06:17:20'),
(13, 6, '2026-10-27 06:17:20'),
(13, 7, '2026-10-27 06:17:20'),
(14, 6, '2026-10-27 06:17:20'),
(14, 14, '2026-10-27 06:17:20'),
(15, 1, '2026-10-27 06:17:20'),
(15, 2, '2026-10-27 06:17:20'),
(15, 10, '2026-10-27 06:17:20'),
(16, 6, '2026-10-27 06:17:20'),
(16, 17, '2026-10-27 06:17:20'),
(17, 1, '2026-10-27 06:17:20'),
(17, 14, '2026-10-27 06:17:20'),
(18, 3, '2026-10-27 06:17:20'),
(18, 4, '2026-10-27 06:17:20'),
(19, 7, '2026-10-27 06:17:20'),
(19, 8, '2026-10-27 06:17:20'),
(20, 17, '2026-10-27 06:17:20'),
(20, 18, '2026-10-27 06:17:20'),
(21, 6, '2026-10-27 06:17:20'),
(21, 7, '2026-10-27 06:17:20'),
(22, 17, '2026-10-27 06:17:20'),
(22, 19, '2026-10-27 06:17:20'),
(23, 9, '2026-10-27 06:17:20'),
(23, 10, '2026-10-27 06:17:20'),
(24, 7, '2026-10-27 06:17:20'),
(24, 13, '2026-10-27 06:17:20'),
(25, 13, '2026-10-27 06:17:20'),
(25, 16, '2026-10-27 06:17:20'),
(26, 8, '2026-10-27 06:17:20'),
(26, 14, '2026-10-27 06:17:20'),
(27, 7, '2026-10-27 06:17:20'),
(27, 16, '2026-10-27 06:17:20'),
(28, 10, '2026-10-27 06:17:20'),
(28, 17, '2026-10-27 06:17:20'),
(29, 17, '2026-10-27 06:17:20'),
(29, 19, '2026-10-27 06:17:20'),
(30, 1, '2026-10-27 06:17:20'),
(30, 3, '2026-10-27 06:17:20'),
(31, 17, '2026-10-27 06:17:20'),
(31, 18, '2026-10-27 06:17:20'),
(32, 12, '2026-10-27 06:17:20'),
(32, 18, '2026-10-27 06:17:20'),
(33, 2, '2026-10-27 06:17:20'),
(33, 9, '2026-10-27 06:17:20'),
(34, 6, '2026-10-27 06:17:20'),
(34, 19, '2026-10-27 06:17:20'),
(35, 8, '2026-10-27 06:17:20'),
(35, 10, '2026-10-27 06:17:20'),
(36, 6, '2026-10-27 06:17:21'),
(36, 7, '2026-10-27 06:17:20'),
(37, 1, '2026-10-27 06:17:21'),
(37, 14, '2026-10-27 06:17:21'),
(38, 17, '2026-10-27 06:17:21'),
(38, 18, '2026-10-27 06:17:21'),
(39, 8, '2026-10-27 06:17:21'),
(39, 10, '2026-10-27 06:17:21'),
(40, 3, '2026-10-27 06:17:21'),
(40, 18, '2026-10-27 06:17:21'),
(41, 7, '2026-10-27 06:17:21'),
(41, 19, '2026-10-27 06:17:21'),
(42, 12, '2026-10-27 06:17:21'),
(42, 17, '2026-10-27 06:17:21'),
(43, 1, '2026-10-27 06:17:21'),
(43, 14, '2026-10-27 06:17:21'),
(44, 6, '2026-10-27 06:17:21'),
(44, 7, '2026-10-27 06:17:21'),
(45, 2, '2026-10-27 06:17:21'),
(45, 3, '2026-10-27 06:17:21'),
(46, 17, '2026-10-27 06:17:21'),
(46, 19, '2026-10-27 06:17:21'),
(47, 8, '2026-10-27 06:17:21'),
(47, 16, '2026-10-27 06:17:21'),
(48, 6, '2026-10-27 06:17:21'),
(48, 18, '2026-10-27 06:17:21'),
(49, 1, '2026-10-27 06:17:21'),
(49, 10, '2026-10-27 06:17:21'),
(50, 17, '2026-10-27 06:17:21'),
(50, 18, '2026-10-27 06:17:21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_teach_knowledge`
--

CREATE TABLE `user_teach_knowledge` (
  `user_id` int(11) NOT NULL,
  `knowledge_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `user_teach_knowledge`
--

INSERT INTO `user_teach_knowledge` (`user_id`, `knowledge_id`, `created_at`) VALUES
(1, 1, '2026-10-27 06:17:20'),
(1, 2, '2026-10-27 06:17:20'),
(1, 3, '2026-10-27 06:17:20'),
(1, 4, '2026-10-27 06:17:21'),
(1, 5, '2026-10-27 06:17:21'),
(2, 6, '2026-10-27 06:17:20'),
(2, 7, '2026-10-27 06:17:20'),
(2, 14, '2026-10-27 06:17:21'),
(2, 16, '2026-10-27 06:17:20'),
(3, 2, '2026-10-27 06:17:21'),
(3, 6, '2026-10-27 06:17:20'),
(3, 8, '2026-10-27 06:17:20'),
(3, 9, '2026-10-27 06:17:20'),
(3, 14, '2026-10-27 06:17:21'),
(4, 2, '2026-10-27 06:17:21'),
(4, 8, '2026-10-27 06:17:21'),
(4, 10, '2026-10-27 06:17:20'),
(4, 11, '2026-10-27 06:17:20'),
(5, 3, '2026-10-27 06:17:21'),
(5, 4, '2026-10-27 06:17:20'),
(5, 12, '2026-10-27 06:17:20'),
(5, 13, '2026-10-27 06:17:20'),
(6, 1, '2026-10-27 06:17:20'),
(6, 2, '2026-10-27 06:17:21'),
(6, 14, '2026-10-27 06:17:20'),
(6, 15, '2026-10-27 06:17:20'),
(7, 6, '2026-10-27 06:17:21'),
(7, 7, '2026-10-27 06:17:20'),
(7, 17, '2026-10-27 06:17:20'),
(7, 18, '2026-10-27 06:17:20'),
(7, 19, '2026-10-27 06:17:21'),
(8, 12, '2026-10-27 06:17:20'),
(8, 17, '2026-10-27 06:17:20'),
(8, 18, '2026-10-27 06:17:21'),
(8, 19, '2026-10-27 06:17:20'),
(9, 6, '2026-10-27 06:17:20'),
(9, 7, '2026-10-27 06:17:21'),
(9, 8, '2026-10-27 06:17:20'),
(9, 14, '2026-10-27 06:17:20'),
(10, 3, '2026-10-27 06:17:20'),
(10, 4, '2026-10-27 06:17:20'),
(10, 12, '2026-10-27 06:17:21'),
(10, 13, '2026-10-27 06:17:21'),
(11, 10, '2026-10-27 06:17:20'),
(11, 11, '2026-10-27 06:17:20'),
(11, 16, '2026-10-27 06:17:20'),
(12, 3, '2026-10-27 06:17:20'),
(12, 12, '2026-10-27 06:17:20'),
(12, 13, '2026-10-27 06:17:20'),
(12, 17, '2026-10-27 06:17:21'),
(12, 18, '2026-10-27 06:17:21'),
(13, 17, '2026-10-27 06:17:21'),
(13, 19, '2026-10-27 06:17:20'),
(14, 6, '2026-10-27 06:17:21'),
(14, 8, '2026-10-27 06:17:20'),
(15, 1, '2026-10-27 06:17:21'),
(15, 3, '2026-10-27 06:17:20'),
(16, 7, '2026-10-27 06:17:20'),
(16, 18, '2026-10-27 06:17:20'),
(17, 2, '2026-10-27 06:17:20'),
(18, 12, '2026-10-27 06:17:20'),
(18, 13, '2026-10-27 06:17:20'),
(19, 16, '2026-10-27 06:17:20'),
(20, 19, '2026-10-27 06:17:20'),
(23, 1, '2026-10-27 06:17:20'),
(23, 2, '2026-10-27 06:17:20'),
(24, 18, '2026-10-27 06:17:20'),
(26, 6, '2026-10-27 06:17:20'),
(28, 8, '2026-10-27 06:17:20'),
(28, 14, '2026-10-27 06:17:20'),
(31, 7, '2026-10-27 06:17:20'),
(33, 14, '2026-10-27 06:17:20'),
(35, 11, '2026-10-27 06:17:20'),
(37, 3, '2026-10-27 06:17:21'),
(37, 4, '2026-10-27 06:17:21'),
(39, 16, '2026-10-27 06:17:21'),
(40, 13, '2026-10-27 06:17:21'),
(42, 19, '2026-10-27 06:17:21'),
(47, 7, '2026-10-27 06:17:21'),
(49, 2, '2026-10-27 06:17:21'),
(49, 3, '2026-10-27 06:17:21');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `aprendly_demo_seed_sessions`
--
ALTER TABLE `aprendly_demo_seed_sessions`
  ADD PRIMARY KEY (`session_id`);

--
-- Indices de la tabla `aprendly_demo_seed_users`
--
ALTER TABLE `aprendly_demo_seed_users`
  ADD PRIMARY KEY (`user_id`);

--
-- Indices de la tabla `connection_requests`
--
ALTER TABLE `connection_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_connection_direction` (`requester_id`,`recipient_id`),
  ADD KEY `idx_requests_recipient` (`recipient_id`,`status`);

--
-- Indices de la tabla `conversations`
--
ALTER TABLE `conversations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_conv_pair` (`user_one_id`,`user_two_id`),
  ADD KEY `fk_conv_two` (`user_two_id`);

--
-- Indices de la tabla `knowledge`
--
ALTER TABLE `knowledge`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `matches`
--
ALTER TABLE `matches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_match_pair` (`user_a_id`,`user_b_id`),
  ADD KEY `fk_match_b` (`user_b_id`);

--
-- Indices de la tabla `mentorship_sessions`
--
ALTER TABLE `mentorship_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `knowledge_id` (`knowledge_id`),
  ADD KEY `idx_sessions_mentor` (`mentor_id`,`status`,`scheduled_start`),
  ADD KEY `idx_sessions_learner` (`learner_id`,`status`,`scheduled_start`);

--
-- Indices de la tabla `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_msg_conv` (`conversation_id`),
  ADD KEY `fk_msg_sender` (`sender_id`);

--
-- Indices de la tabla `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notifications_user` (`user_id`,`is_read`,`created_at`);

--
-- Indices de la tabla `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`user_id`);

--
-- Indices de la tabla `recognitions`
--
ALTER TABLE `recognitions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `verification_code` (`verification_code`),
  ADD UNIQUE KEY `uq_recognition_period_user` (`user_id`,`period_year`,`period_month`);

--
-- Indices de la tabla `session_reviews`
--
ALTER TABLE `session_reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_session_reviewer` (`session_id`,`reviewer_id`),
  ADD KEY `reviewer_id` (`reviewer_id`),
  ADD KEY `reviewed_id` (`reviewed_id`);

--
-- Indices de la tabla `universities`
--
ALTER TABLE `universities`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `institutional_email` (`institutional_email`),
  ADD KEY `fk_users_university` (`university_id`);

--
-- Indices de la tabla `user_availability`
--
ALTER TABLE `user_availability`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_availability_slot` (`user_id`,`weekday`,`start_time`);

--
-- Indices de la tabla `user_learn_knowledge`
--
ALTER TABLE `user_learn_knowledge`
  ADD PRIMARY KEY (`user_id`,`knowledge_id`),
  ADD KEY `fk_learn_know` (`knowledge_id`);

--
-- Indices de la tabla `user_teach_knowledge`
--
ALTER TABLE `user_teach_knowledge`
  ADD PRIMARY KEY (`user_id`,`knowledge_id`),
  ADD KEY `fk_teach_know` (`knowledge_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `connection_requests`
--
ALTER TABLE `connection_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `conversations`
--
ALTER TABLE `conversations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `knowledge`
--
ALTER TABLE `knowledge`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `matches`
--
ALTER TABLE `matches`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mentorship_sessions`
--
ALTER TABLE `mentorship_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=128;

--
-- AUTO_INCREMENT de la tabla `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `recognitions`
--
ALTER TABLE `recognitions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `session_reviews`
--
ALTER TABLE `session_reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `universities`
--
ALTER TABLE `universities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT de la tabla `user_availability`
--
ALTER TABLE `user_availability`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `aprendly_demo_seed_sessions`
--
ALTER TABLE `aprendly_demo_seed_sessions`
  ADD CONSTRAINT `fk_demo_session` FOREIGN KEY (`session_id`) REFERENCES `mentorship_sessions` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `aprendly_demo_seed_users`
--
ALTER TABLE `aprendly_demo_seed_users`
  ADD CONSTRAINT `fk_demo_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `connection_requests`
--
ALTER TABLE `connection_requests`
  ADD CONSTRAINT `connection_requests_ibfk_1` FOREIGN KEY (`requester_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `connection_requests_ibfk_2` FOREIGN KEY (`recipient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `conversations`
--
ALTER TABLE `conversations`
  ADD CONSTRAINT `fk_conv_one` FOREIGN KEY (`user_one_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_conv_two` FOREIGN KEY (`user_two_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `matches`
--
ALTER TABLE `matches`
  ADD CONSTRAINT `fk_match_a` FOREIGN KEY (`user_a_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_match_b` FOREIGN KEY (`user_b_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `mentorship_sessions`
--
ALTER TABLE `mentorship_sessions`
  ADD CONSTRAINT `mentorship_sessions_ibfk_1` FOREIGN KEY (`mentor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `mentorship_sessions_ibfk_2` FOREIGN KEY (`learner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `mentorship_sessions_ibfk_3` FOREIGN KEY (`knowledge_id`) REFERENCES `knowledge` (`id`);

--
-- Filtros para la tabla `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `fk_msg_conv` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_msg_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `profiles`
--
ALTER TABLE `profiles`
  ADD CONSTRAINT `fk_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `recognitions`
--
ALTER TABLE `recognitions`
  ADD CONSTRAINT `recognitions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `session_reviews`
--
ALTER TABLE `session_reviews`
  ADD CONSTRAINT `session_reviews_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `mentorship_sessions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `session_reviews_ibfk_2` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `session_reviews_ibfk_3` FOREIGN KEY (`reviewed_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_university` FOREIGN KEY (`university_id`) REFERENCES `universities` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `user_availability`
--
ALTER TABLE `user_availability`
  ADD CONSTRAINT `user_availability_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `user_learn_knowledge`
--
ALTER TABLE `user_learn_knowledge`
  ADD CONSTRAINT `fk_learn_know` FOREIGN KEY (`knowledge_id`) REFERENCES `knowledge` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_learn_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `user_teach_knowledge`
--
ALTER TABLE `user_teach_knowledge`
  ADD CONSTRAINT `fk_teach_know` FOREIGN KEY (`knowledge_id`) REFERENCES `knowledge` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_teach_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
