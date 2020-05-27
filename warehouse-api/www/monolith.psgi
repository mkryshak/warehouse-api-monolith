#!/usr/bin/perl

#### Property of NGINX, Inc. ####
#							  	#
#      Date: December 08, 2019	#
#    Author: Matt Kryshak		#
#   Version: 2.0				#
#								#
#################################

##### Libraries #####
use DBI;
use JSON;
use Switch;
use Time::HiRes qw( gettimeofday );

##### Functions #####
require './lib/mysql.pl';
require './lib/product.pl';
require './lib/system.pl';

##### Constants #####
use constant EXIT_FAIL	  => 1;
use constant EXIT_SUCCESS => 0;

##### Main Program #####
if ( !$ENV{BASE_URI} ) { $ENV{BASE_URI} = '/api/v1/warehouse' }
if ( !$ENV{CFG_FILE} ) { $ENV{CFG_FILE} = './config.json' }
if ( !$ENV{LOG_FILE} ) { $ENV{LOG_FILE} = './error.log' }
if ( !$ENV{MAP_FILE} ) { $ENV{MAP_FILE} = './map.json' }

%CFG = ReadConfig( $ENV{CFG_FILE} );
%MAP = ReadConfig( $ENV{MAP_FILE} );

my $app = sub {
	
	my ($dbh, $env, $req, $str, $typ, $uri);
	my ($body, $code, $json, $health, %RESP);
	
	$env = shift;
	$req = $env->{REQUEST_METHOD};
	$uri = $env->{REQUEST_URI};
	$str = $env->{QUERY_STRING};
	$typ = $env->{CONTENT_TYPE};
	
	%SVC = (
		'description' => undef,
		'inventory'   => undef,
		'price'       => undef,
		'rating'      => undef );
	
	$dbh = MySqlConnect(\%CFG);
	
	if ( !$dbh ) {
		$code = 503;
		$body = {
			status  => $code,
			request => $uri,
			message => 'unable to connect to database'
		};
	}
	
	elsif ( $uri eq '/health' ) {
		switch ( $dbh->ping ) {
			case 1 { $code = 200; $health = 'healthy' }
			else   { $code = 503; $health = 'unhealthy' } 
		}
		
		$body = {
			status  => $code,
			request => $uri,
			message => $health
		};
	}
	
	else {
		if ( $uri =~ m/^$ENV{BASE_URI}\/product(\?.+)?$/ ) {
			if ( $req eq 'GET' ) {
				($code, $body) = GetProduct($dbh, $uri, $str);
			}
			
			else {
				$code = 405;
				$body = {
					status  => $code,
					request => $uri,
					message => 'method not allowed'
				};
				
				$RESP{'Allow'} = 'GET';
			}
		}
		
		elsif ( $uri =~ m/^$ENV{BASE_URI}\/product\/(\d+)(\?.+)?$/ ) {
			if ( $req eq 'DELETE' ) {
				($code, $body) = DeleteProduct($dbh, $uri, $1);
			}
			
			elsif ( $req eq 'GET' ) {
				($code, $body) = GetProduct($dbh, $uri, $str, undef, $1);
			}
			
			elsif ( $req eq 'POST' || $req eq 'PUT' ) {
				if ( lc($typ) ne 'application/json' ) {
					$code = 415;
					$body = {
						status  => $code,
						request => $uri,
						message => 'unsupported media type'
					};
				}
				
				elsif ( $json = DecodeBody(\$env) ) {
					switch ( $req ) {
						case 'POST' { ($code, $body) = CreateProduct($dbh, $uri, $1, $json) }
						else        { ($code, $body) = UpdateProduct($dbh, $uri, undef, $1, $json) }
					}
				}
				
				else {
					$code = 400;
					$body = {
						status  => $code,
						request => $uri,
						message => 'malformed json'
					};
				}
			}
			
			else {
				$code = 405;
				$body = {
					status  => $code,
					request => $uri,
					message => 'method not allowed'
				};
				
				$RESP{'Allow'} = 'DELETE, GET, POST, PUT';
			}
		}
		
		elsif ( $uri =~ m/^$ENV{BASE_URI}\/product\/(description|inventory|price|rating)\/(\d+)$/ ) {
			if ( $req eq 'GET' ) {
				($code, $body) = GetProduct($dbh, $uri, $str, $1, $2);
			}
			
			elsif ( $req eq 'PATCH' ) {
				if ( lc($typ) ne 'application/json' ) {
					$code = 415;
					$body = {
						status  => $code,
						request => $uri,
						message => 'unsupported media type'
					};
				}
				
				elsif ( $json = DecodeBody(\$env) ) {
					($code, $body) = UpdateProduct($dbh, $uri, $1, $2, $json)
				}
				
				else {
					$code = 400;
					$body = {
						status  => $code,
						request => $uri,
						message => 'malformed json'
					};
				}
			}
			
			else {
				$code = 405;
				$body = {
					status  => $code,
					request => $uri,
					message => 'method not allowed'
				};
				
				$RESP{'Allow'} = 'GET, PATCH';
			}
		}
		
		else {
			$code = 404;
			$body = {
				status  => $code,
				request => $uri,
				message => 'resource not found'
			};
		}
	}
	
	$RESP{'Content-Type'} = 'application/json';
	
	return [
		$code,
		[ %RESP ],
		[ JSON->new->pretty->space_before(0)->canonical(1)->encode($body) ]
	];
};
