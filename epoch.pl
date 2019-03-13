#!/usr/bin/perl -w

# Convert a time in seconds-since-epoch to human-readable in the
# local time zone.

use strict;

while (<>)
{
  foreach my $item (split())
  {
    chomp($item);
    if ($item =~ m/^[0-9]+$/)
    {
      print scalar localtime($item), "\n";
    }
  }
}
