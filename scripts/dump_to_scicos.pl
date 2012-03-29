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
my $prev_time;

my @Times;
my @Values;

open(my $Input, '<', $ARGV[0]);
my $stop = 0;
while (not $stop and my $row = <$Input>) {
    my ($time, $power, $tacho) = $row =~ /^time=(\d+\.\d+) power=(\d+\.\d+) tacho=(\d+\.\d+)$/;

    if ($start_time == 0) {
        $start_time = $time;
        $start_power = $power;
        $prev_time = $time = 0;
    } else {
        if ($power != $start_power) {
            $stop = 1;
            next;
        }
        $time -= $start_time;
        if ($time <= $prev_time) {
            # Seriously, why are there repeated readings??
            next;
        }
        $prev_time = $time;
    }

    push @Times, $time;
    push @Values, $tacho;
}
close($Input);

open(my $Out, '>', $ARGV[0] . ".mat");
say $Out join('   ', @Times);
say $Out join('   ', @Values);
close($Out);

