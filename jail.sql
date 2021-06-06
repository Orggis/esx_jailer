
CREATE TABLE IF NOT EXISTS `jail` (
  `identifier` varchar(100) NOT NULL,
  `isjailed` varchar(50) DEFAULT 'false',
  `J_Time` int(11) NOT NULL DEFAULT 0,
  `J_Cell` varchar(20) NOT NULL,
  `Jailer_ID` varchar(100) DEFAULT NULL,
  `jail_time` int(10) NOT NULL,
  `Jailer` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
