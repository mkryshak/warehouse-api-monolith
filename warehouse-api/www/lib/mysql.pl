###### mysql.pl ######
#                    #
#	ExecuteSql		 #
#	FetchAllByHash	 #
#	FetchRowByHash	 #
#	MySQLConnect	 #
#	MySQLDisconnect	 #
#					 #
######################

sub ExecuteSql {
	
	use Switch;
	
	my ($dbh, $sql, $sth);
	
	$dbh = $_[0];
	$sql = $_[1];
	
	$sth = $dbh->prepare($sql);
	
	if ( !defined $sth->execute ) {
		WriteLog($ENV{LOG_FILE}, "Error executing sql statement: { $sql, ".$sth->errstr." }");
	}
	
	return( $sth->errstr );
}

sub FetchAllByHash {
	
	use Switch;
	
	my ($all, $dbh, $key, $sql, $sth);
	
	$dbh = $_[0];
	$sql = $_[1];
	$key = $_[2];
	
	$sth = $dbh->prepare($sql);
	
	if ( !defined $sth->execute ) {
		WriteLog($ENV{LOG_FILE}, "Error executing sql statement: { $sql, ".$sth->errstr." }");
	}
	
	$all = $sth->fetchall_hashref($key);
	
	if ( defined $sth->err ) {
		WriteLog($ENV{LOG_FILE}, "Could not retrieve sql data: { $sql }");
	}
	
	$sth->finish;
	
	return($all);
}

sub FetchRowByHash {
	
	use Switch;
	
	my ($dbh, $row, $sql, $sth);
	
	$dbh = $_[0];
	$sql = $_[1];
	
	$sth = $dbh->prepare($sql);
	
	if ( !defined $sth->execute ) {
		WriteLog($ENV{LOG_FILE}, "Error executing sql statement: { $sql, ".$sth->errstr." }");
	}
	
	$row = $sth->fetchrow_hashref;
	
	if ( defined $sth->err ) {
		WriteLog($ENV{LOG_FILE}, "Could not retrieve sql data: { $sql }");
	}
	
	$sth->finish;
	
	return($row);
}

sub MySqlConnect {
	
	use Switch;
	
	my ($cfg, $dbh, $dsn);
	
	$cfg = shift;
	
	$dsn = "DBI:mysql:;host=$cfg->{mysql}{server}{host};port=$cfg->{mysql}{server}{port};mysql_connect_timeout=2";
	$dbh = DBI->connect_cached($dsn, $cfg->{mysql}{username}, $cfg->{mysql}{password}, { PrintError => 0 });
	
	if ( !$dbh ) {
		WriteLog($ENV{LOG_FILE}, "Error connecting to sql server: { $DBI::errstr }");
	}
	
	return($dbh);
}

sub MySqlDisconnect {
	
	use Switch;
	
	my $dbh;
	
	$dbh = shift;
	$dbh->disconnect();
	
	if ( !$dbh ) {
		WriteLog($ENV{LOG_FILE}, "Error disconnecting from sql server: { $DBI::errstr }");
	}
	
	return( undef $dbh );
}

1;