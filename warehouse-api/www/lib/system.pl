####### system.pl #######
#                       #
#	DecodeBody			#
#	GetTime				#
#	ParseQueryString	#
#	ReadConfig			#
#	ReadFile			#
#	WriteFile			#
#	WriteLog			#
#						#
#########################

sub DecodeBody {
	
	my ($fh, $env, $body);
	
	$env = shift;
	
    open($fh, ">&", $$env->{'psgi.input'});
	$fh->read( $body, $$env->{CONTENT_LENGTH} );
	close($fh);
	
	$body = eval { decode_json($body) };
	$body = $@ ? undef : $body;
	
	return($body);
}

sub GetTime {
	
	my ($day, $mon, $sec, $hrs, $yrs, $time, $type);
	
	$type = lc($_[0]);
	
	($time) = gettimeofday();
	
	if ($type ne 'epoch') {
		
		if ($type eq 'local') {
			($sec, $min, $hrs, $day, $mon, $yrs) = (localtime($time))[0, 1, 2, 3, 4, 5];
		}
		
		else {
			($sec, $min, $hrs, $day, $mon, $yrs) = (gmtime($time))[0, 1, 2, 3, 4, 5];
		}
		
		$time = sprintf("%04d/%02d/%02d %02d:%02d:%02d", $yrs + 1900, $mon + 1, $day, $hrs, $min, $sec);
	}
	
	return($time);
}

sub ParseQueryString {
	
	my ($key, $str, $val, $pair);
	my (@Pair, %QUERY);
	
	$str  = shift;
	@Pair = split('&', $str);
	
	foreach $pair (@Pair) {
		($key, $val) = split('=', $pair);
		$QUERY{$key} = $val;
	}
	
	return(\%QUERY);
}

sub ReadConfig {
	
	my $json;
	my @File;
	
	$json = shift;
	@File = ReadFile($json);
	
	if (!@File) {
		WriteLog($ENV{LOG_FILE}, "Unable to read file: { $json }");
	}
	
	else {
		$json = decode_json( join("", @File) );
	}
	
	return( %{$json} );
}

sub ReadFile {
	
	my ($args, $mode, $path);
	my @File;
	
	$path = $_[0];
	$args = $_[1];
	
	open(FILE, "<$path");
	
	if ($args eq 'chomp') {
		chomp(@File = <FILE>);
	}
	
	else {
		@File = <FILE>;
	}
	
	close(FILE);
	
	return(@File);
}

sub WriteFile {
	
	my ($line, $mode, $path);
	my @File;
	
	$path = shift;
	$mode = shift;
	@File = @_;
	
	open(FILE, $mode, $path);
	
	foreach $line (@File) {
		chomp($line);
		print FILE "$line\n";
	}
	
	close(FILE);
}

sub WriteLog {
	
	my ($data, $path, $time);
	
	$path = $_[0];
	$data = $_[1];

	$time = GetTime('local');
	
	open(FILE, '>>', $path);
	chomp($data);
	print FILE "$time - $data\n";	
	close(FILE);
}

1;