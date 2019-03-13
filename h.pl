#!/usr/bin/perl -w

# Poor man's version of the df(1)/du(1) -h flag so that you can do
# math/sort(1) with the -k flag, but still get human-readable
# output.

use strict;

my @powers = qw(KB MB GB TB PB);
my ($item, $power);
while (<>) {
	foreach $item (split()) {
		chomp($item);
		if ($item =~ m/^[0-9]+$/) {
			$power = 0;
			while ($item > 1024) {
				$item /= 1024;
				$power++;
			}
			printf "%.2f %s", $item, $powers[$power];
		} else {
			print $item;
		}
		print " ";
	}
	print "\n";
}
