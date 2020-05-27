###### product.pl #######
#                      	#
#	CreateProduct		#
#	DeleteProduct		#
#	FilterProduct		#
#	GetProduct			#
#	UpdateProduct		#
#						#
#########################

sub CreateProduct {
	
	use Switch;
	
	my ($col, $dbh, $err, $sku, $sql, $svc, $uri, $val);
	my ($body, $code, $json, $time);
	my (@Key, @Service);
	
	$dbh  = $_[0];
	$uri  = $_[1];
	$sku  = $_[2];
	$json = $_[3];
	
	@Service = keys %SVC;
	
	switch ( $json->{created} ) {
		case undef { $time = GetTime('epoch') }
		else       { $time = $json->{created} }
	}
	
	foreach $svc ( @Service ) {
		if ( ref $json->{$svc} eq 'HASH' ) {
			switch ( $json->{created} ) {
				case undef  { delete $json->{$svc}{updated}; next }
				case (/.*/) { delete $json->{$svc}{created} }
			}
			
			@Key = keys %{ $json->{$svc} };
			$col = join(', ', @Key);
			$val = join(', ', map { "\"$json->{$svc}{$_}\"" } @Key);
			$val =~ s/\"\"/null/g;
			
			switch ( $col ) {
				case undef { $sql = "INSERT INTO warehouse.$svc (sku, created) VALUES (\"$sku\", $time)" }
				else       { $sql = "INSERT INTO warehouse.$svc (sku, $col, created) VALUES (\"$sku\", $val, $time)" }
			}
			
			if ( $err = ExecuteSql($dbh, $sql) ) {
				if ( $err =~ m/duplicate entry/i ) {
					$code = 403;
					$body = {
						status  => $code,
						request => $uri,
						message => 'product already exists'
					};
				}
				
				else {
					DeleteProduct($dbh, $uri, $sku);
					$code = 400;
					$body = {
						status  => $code,
						request => $uri,
						message => 'invalid json'
					};
				}
			
				last;
			}
			
			else {
				$code = 201;
				$body = {
					status  => $code,
					request => $uri,
					message => 'product created'
				};
			}
		}
		
		else {
			DeleteProduct($dbh, $uri, $sku);
			$code = 400;
			$body = {
				status  => $code,
				request => $uri,
				message => 'invalid json'
			};
			
			last;
		}
	}
	
	return($code, $body);
}

sub DeleteProduct {
	
	use Switch;
	
	my ($dbh, $sku, $svc, $uri);
	my ($body, $code, @Service);
	
	$dbh = $_[0];
	$uri = $_[1];
	$sku = $_[2];
	
	@Service = keys %SVC;
	
	foreach $svc ( @Service ) {
		ExecuteSql($dbh, "DELETE FROM warehouse.$svc WHERE sku = \"$sku\"");
	}
	
	$code = 200;
	$body = {
		status  => $code,
		request => $uri,
		message => 'product deleted'
	};
	
	return($code, $body);
}

sub FilterProduct {
	
	use Switch;
	
	my ($key, $sku, $str, $svc);
	my ($data, $field, $match);
	my (@Keys, @Fields, @Service, %DATA);
	
	$str  = $_[0];
	$data = $_[1];
	
	@Service = keys %SVC;
	delete $str->{range};
	
	switch ( $str->{fields} ) {
		case undef { undef @Fields }
		else       { @Fields = split(/\+/, $str->{fields}); delete $str->{fields} }
	}
	
	if ( keys %{$str} ) {
		foreach $sku ( keys %{$data} ) {
			foreach $key ( keys %{$str} ) {
				if ( $key =~ m/(quantity|retail|reviews|sale|score|size|unit)/ ) {
					$str->{$key} =~ s/%20/ /g;
					$str->{$key} =~ s/%2A/.+/g;
					
					if ( $data->{$sku}{$MAP{$key}}{$key} ne $str->{$key} ) {
						last;
					}
					
					else {
						$match = 1;
					}
				}
				
				else {
					$str->{$key} =~ s/%20/ /g;
					$str->{$key} =~ s/%2A/.+/g;
					
					if ( $data->{$sku}{$MAP{$key}}{$key} !~ m/$str->{$key}/i ) {
						last;
					}
					
					else {
						$match = 1;
					}
				}
			}
			
			if ( !$match ) {
				delete $data->{$sku};
			}
			
			undef $match;
		}
	}
	
	if ( @Fields ) {
		foreach $sku ( keys %{$data} ) {
			foreach $svc ( @Service ) {
				foreach $field ( @Fields ) {
					if ( $field eq 'sku' ) {
						undef %DATA;
						@Keys = sort {$a <=> $b} keys %{$data};
						for (my $i = 0; $i < @Keys; $i++) {
							$DATA{skus}[$i] = $Keys[$i];
						}
						last;
					}
					
					elsif ( $field eq 'created' ) {
						$DATA{$sku}{created} = $data->{$sku}{created};
					}
					
					elsif ( $field eq 'updated' ) {
						switch ( $data->{$sku}{$svc}{updated} ) {
							case undef { $DATA{$sku}{$svc}{updated} = undef; }
							else       { $DATA{$sku}{$svc}{updated} = $data->{$sku}{$svc}{updated}; }
						}
					}
					
					elsif ( $data->{$sku}{$svc}{$field} ) {
						$DATA{$sku}{$svc}{$field} = $data->{$sku}{$svc}{$field};
					}
				}
			}
		}
		
		if ( %DATA ) {
			%{$data} = %DATA;	
		}
	}
	
	return($data);
}

sub GetProduct {
	
	use Switch;
	
	my ($all, $dbh, $key, $sku, $sql);
	my ($str, $svc, $uri, $body, $code);
	my (@Range, @Service, %DATA);
	
	$dbh = $_[0];
	$uri = $_[1];
	$str = $_[2];
	$svc = $_[3];
	$sku = $_[4];
	
	switch ( $svc ) {
		case undef { @Service = keys %SVC }
		else       { @Service = ($svc) }
	}
	
	switch ( $str ) {
		case undef { undef $str }
		else       { $str = ParseQueryString($str) }
	}
	
	switch ( $str->{range} ) {
		case undef { undef @Range }
		else       { @Range = split('-', $str->{range}) }
	}
	
	foreach $svc ( @Service ) {
		if ( $uri =~ m/\/product\/(\w+\/)?\d+/ ) {
			$sql = "SELECT * FROM warehouse.$svc WHERE sku = \"$sku\"";
		}
		
		else {
			switch ( @Range ) {
				case 0 { $sql = "SELECT * FROM warehouse.$svc" }
				else   { $sql = "SELECT * FROM warehouse.$svc WHERE sku BETWEEN \"$Range[0]\" AND \"$Range[1]\"" }
			}
		}
		
		$all = FetchAllByHash($dbh, $sql, [1]);
		
		foreach $sku ( keys %{$all} ) {
			$DATA{$sku}{created} = $all->{$sku}{created};
			delete $all->{$sku}{sku};
			delete $all->{$sku}{created};
			foreach $key ( keys %{$all->{$sku}} ) {
				$DATA{$sku}{$svc}{$key} = $all->{$sku}{$key};
			}
		}
	}
	
	$body = FilterProduct($str, \%DATA);
	
	if ( %{$body} ) {
		$code = 200;
	}
	
	else {
		$code = 404;
		$body = {
			status  => $code,
			request => $uri,
			message => 'product not found'
		};
	}
	
	return($code, $body);
}

sub UpdateProduct {
	
	use Switch;
	
	my ($col, $dbh, $row, $sku, $sql, $svc, $uri);
	my ($body, $code, $json, $time);
	my (@Backup, @Service);
	
	$dbh  = $_[0];
	$uri  = $_[1];
	$svc  = $_[2];
	$sku  = $_[3];
	$json = $_[4];
	
	$time = GetTime('epoch');
	
	switch ( $svc ) {
		case undef { @Service = keys %SVC }
		else       { @Service = ($svc) }
	}
	
	foreach $svc ( @Service ) {
		if ( ref $json->{$svc} eq undef ) {
			foreach $sql ( @Backup ) {
				ExecuteSql($dbh, $sql);
			}
			
			$code = 400;
			$body = {
				status  => $code,
				request => $uri,
				message => 'product not updated'
			};
			
			last;
		}
		
		elsif ( ref $json->{$svc} eq 'HASH' ) {
			$sql = "SELECT * FROM warehouse.$svc WHERE sku = \"$sku\"";
			
			if ( $row = FetchRowByHash($dbh, $sql) ) {
				delete $row->{sku};
				$col = join(', ', map { "$_ = \"$row->{$_}\"" } keys %{$row});
				$col =~ s/\"\"/null/g;
				push(@Backup, "UPDATE warehouse.$svc SET $col WHERE sku = \"$sku\"");
				
				delete $json->{$svc}{created};
				delete $json->{$svc}{updated};
				$col = join(', ', map { "$_ = \"$json->{$svc}{$_}\"" } keys %{$json->{$svc}});
				$col =~ s/\"\"/null/g;
				
				if ( $col ) {
					$sql = "UPDATE warehouse.$svc SET $col, updated = $time WHERE sku = \"$sku\"";
					
					if ( ExecuteSql($dbh, $sql) ) {
						foreach $sql ( @Backup ) {
							ExecuteSql($dbh, $sql);
						}
						
						$code = 400;
						$body = {
							status  => $code,
							request => $uri,
							message => 'invalid json'
						};
						
						last;
					}
					
					else {
						$code = 200;
						$body = {
							status  => $code,
							request => $uri,
							message => 'product updated'
						};
					}
				}
				
				else {
					next;
				}
			}
			
			else {
				foreach $sql ( @Backup ) {
					ExecuteSql($dbh, $sql);
				}
				
				$code = 404;
				$body = {
					status  => $code,
					request => $uri,
					message => 'product not found'
				};
				
				last;
			}
		}
		
		else {
			foreach $sql ( @Backup ) {
				ExecuteSql($dbh, $sql);
			}
			
			$code = 400;
			$body = {
				status  => $code,
				request => $uri,
				message => 'invalid json'
			};
			
			last;
		}
	}
	
	return($code, $body);
}

1;