#!/usr/bin/perl -w

# This program converts a file in the format
#   time=<float> power=<float> tacho=<float>
# into something good for scicos (i.e. one vector per textfile row)

use strict;
use warnings;
use feature 'say';

if (@ARGV < 1) {
    say "Need input file";
    exit 1;
}

my $start_time = 0;
my $start_power;

my @Times;
my @Values;

open(my $Input, '<', $ARGV[0]);
my $stop = 0;
while (not $stop and my $row = <$Input>) {
    my ($time, $power, $tacho) = $row =~ /^time=(\d+\.\d+) power=(\d+\.\d+) tacho=(\d+\.\d+)$/;

    if ($start_time == 0) {
        $start_time = $time;
        $start_power = $power;
        $time = 0;
    } else {
        if ($power != $start_power) {
            $stop = 1;
            next;
        }
        $time -= $start_time;
    }

    push @Times, $time;
    push @Values, $tacho;
}
close($Input);

open(my $Out, '>', $ARGV[0] . ".mat");
say $Out join('   ', @Times);
say $Out join('   ', @Values);
close($Out);

