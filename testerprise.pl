#!/usr/bin/perl

# just get BSSID of network, given SSID

use strict;
use warnings;


my $enterprise_dir = "/etc/wireless.d/";
my $interface = "iwn0";

sub get_enterprise_bssid;
sub enterprise_connect;

my $nwid = <STDIN>;
chomp $nwid;

print get_enterprise_bssid($interface, $nwid);


sub make_enterprise_config {

}

sub enterprise_connect {
	my ($interface, $nwid) = @_;

	system("mkdir -p $enterprise_dir");
}

sub get_enterprise_bssid {
	my ($interface, $nwid) = @_;

	# clear ifconfig flags
	system("ifconfig iwn0 -nwid -bssid -wpa -wpakey -nwkey");

	my $scan_output = `/sbin/ifconfig $interface scan`;
	# print $scan_output;

	foreach my $line (split /[\r\n]+/, $scan_output) {
		# if the line has "bssid", the nwid, and isn't in the inteface info
		if ($line =~ /$nwid.*bssid/ and $line !~ /ieee80211/) {
			# find the bssid on the line
			foreach my $part (split /\s/, $line) {
				if($part =~ /([0-9a-f]{2}([:-]|$)){6}/) {
					return $part;
				}
			}
		}
	}

	die "Unable to find BSSID for network: $nwid";
}
