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

my %Speeds;

sub get_speed {
    my ($k) = @_;
    my $ret;

    if (not exists $Speeds{$k}) {
        return $Speeds{$k} = [];
    } else {
        return $Speeds{$k};
    }
}

my $start_time = 0;
my $prev_power = 0;
my $prev_time;
my $times;
my $vals;
my $pow_rec;
my $last = 0;

open(my $Input, '<', $ARGV[0]);
while (my $row = <$Input>) {
    chop $row;
    my ($time, $power, $tacho) =
        $row =~ /^time=(\d+\.\d+) power=(\-?\d+\.\d+) tacho=(\-?\d+\.\d+)$/;

    $time = int($time);
    $power = int($power);

    next if $power == 0;

    if ($prev_power != $power) {

        $start_time = $time;
        $prev_time = -1;

        if ($prev_power != 0) {
            # We got $pow_rec setted by previous cycle here.
            push @$pow_rec, ($times, $vals);
        }

        $prev_power = $power;
        $times = [];
        $vals = [];
        $pow_rec = get_speed($power);
    }

    $time -= $start_time;
    if ($time <= $prev_time) {
        next;
    }
    $prev_time = $time;

    push @$times, $time;
    push @$vals, $tacho;
}
# Last entry is just ignored: probably is broken because we interrupted
# the experiment.

say "File terminated";
close($Input);

foreach my $pow (sort keys %Speeds) {
    my $expers = $Speeds{$pow};
    my $i = 0;
    my $N = @$expers;

    if ($N) {
        say "Experiments for power=$pow: ", $N;
        while (@$expers > 0) {
            my $times = shift @$expers;
            my $vals = shift @$expers;

            open (my $out, ">", sprintf("%s_%s%03u_%03u.mat", $ARGV[0],
                                        $pow >= 0 ? 'p' : 'm', abs($pow),
                                        $i));
            say $out join('   ', @$times);
            say $out join('   ', @$vals);
            close($out);

            $i ++;
        }
    }
}
