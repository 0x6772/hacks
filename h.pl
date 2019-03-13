#!/usr/bin/perl -w

# Poor man's version of the df(1)/du(1) -h flag so that you can do
# math/sort(1) with the -k flag, but still get human-readable
# output.

# Copyright (c) 2019 Alan Gabriel Rosenkoetter
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
