<?php
/*
require_once(dirname(__FILE__).'/../Config.php');
passthru (sprintf('export PGPASSWORD=%s ; psql -h %s -d %s -U %s -f '.$argv[1],
		DB_PASSWORD,
		DB_SERVER_MASTER,
		DB_NAME,
		DB_USER
	)
);
*/
require_once(dirname(__FILE__).'/../Config.php');
$sql = file_get_contents($argv[1]);
$cnt = NULL;
$sql = str_replace('OWNER TO;', 'OWNER TO '.DB_USER, $sql, $cnt);
$sql = str_replace('OWNER TO ;', 'OWNER TO '.DB_USER, $sql, $cnt);
if ($cnt){
	$sql_f = '.run_sql.sql';
	file_put_contents($sql_f, $sql);	
}
else{
	$sql_f = $argv[1];
}

$cmd = sprintf('export PGPASSWORD=%s ; psql -h %s -d %s -U %s -f '.$sql_f,
		DB_PASSWORD,
		DB_SERVER_MASTER,
		DB_NAME,
		DB_USER
);
//echo $cmd;

passthru ($cmd);

?>
