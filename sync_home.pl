#!/usr/bin/perl -w

# Keep ~gr in sync between my laptop and my workstation in my home
# office. To be run from the most recently used system (pushes
# first, then pulls).
#
# No, NFS/Samba is not the answer: my laptop is often miles away
# from my iMac.
#
# Very much still a WIP at time of writing (2019-03-14)

# Copyright (c) 2021 Alan Gabriel Rosenkoetter
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
use File::Spec::Functions qw(catfile splitpath);

# XXX oh just suck it up and use a library to parse an ini file,
# wouldya?
my $conf_file = (splitpath($0))[2];
$conf_file =~ s,\..+$,.conf,;
$conf_file = catfile($ENV{"HOME"}, $conf_file);

open(my $conf_fh, '<', $conf_file)
  or die "Need a populated $conf_file!";

my @hostnames;
my @paths;

while (my $line = <$conf_fh>)
{
  chomp $line;
  (my $type, my $content) = split(' ', $line);

  if ($type eq "host")
  {
    push @hostnames, $content;
  }
  elsif ($type eq "path")
  {
    push @paths, $content;
  }
  # TODO handle cloud targets like localhost:~/Cubbit
  # maybe with keyword "target"...? "tpath"? Something like that.
  else
  {
    print STDERR "Skipping unrecognized conf line [$line].\n";
  }
}

my $rsync = `which rsync`;
chomp($rsync);
#$rsync .= " -avzRn --no-implied-dirs"
$rsync .= " -avzR --no-implied-dirs"
  . " --exclude='*.photoslibrary'"
  . " --exclude='\~\$.*'"
  . " --exclude='\..*\.swp'";

foreach my $hostname (@hostnames)
{
  my $send_string = "$rsync @paths $hostname:/";
  my $recv_string = "$rsync $hostname:\'@paths\' /";

  print "$send_string\n";
  print qx{$send_string};

  print "$recv_string\n";
  print qx{$recv_string};
}

