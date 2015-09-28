#!/usr/bin/env perl

package bin::combinations::primitive;

use warnings;
use strict;

sub new {
	my ($class, %args) = @_;
	my $self = {};

	$self->{first_column} = $args{first_column};

	if (defined $args{second_column}) {
		if ($args{second_column} eq $self->{first_column}) {
			die "can't set second column same as first";
		} else {
			$self->{second_column} = $args{second_column};
		}
	}

	if (defined $args{third_column}) {
		if (("caretaker" eq $self->{first_column} && "smile" eq $args{third_column})
			|| ("caretaker" eq $self->{first_column} && "i" eq $args{third_column})
			|| ("object" eq $self->{first_column} && "smile" eq $args{third_column})
			|| ("object" eq $self->{first_column} && "i" eq $args{third_column})
			|| ("object" eq $self->{first_column} && "dif" eq $args{third_column})
			|| ("object" eq $self->{first_column} && "S" eq $args{third_column})
			|| ("infant" eq $self->{first_column} && "S" eq $args{third_column})) {
			die "can't set third column to that";
		} elsif (("caretaker" eq $self->{second_column} && "dif" eq $args{third_column})
			|| ("infant" eq $self->{second_column} && "dif" eq $args{third_column})) {
			die "can't set third column to that";
		} else {
			$self->{third_column} = $args{third_column};
		}
	}

	bless($self, $class);
}

sub possible_first_column_values {
	return "caretaker,infant,object";
}

sub possible_third_column_values {
	return "dif,i,smile,S";
}

sub possible_column_combinations {
	my @good_combos;
	my @all_firsts = split(',', possible_first_column_values());
	my @all_seconds = split(',', possible_first_column_values());
	my @all_thirds = split(',', possible_third_column_values());
	for my $first (@all_firsts) {
		for my $second (@all_seconds) {
			my $combo = eval {
				bin::combinations::primitive->new(
					first_column  => $first,
					second_column => $second,
				);
			};
			if (! $@) {
				push @good_combos, "$first $second";
			}
			for my $third (@all_thirds) {
				my $combo = eval {
					bin::combinations::primitive->new(
						first_column  => $first,
						second_column => $second,
						third_column  => $third,
					);
				};
				if (! $@) {
					push @good_combos, "$first $second $third";
				}
			}
		}
	}
	return @good_combos;
}

package bin::combinations::combinated;

use Algorithm::Permute;

use warnings;
use strict;

sub new {
	my ($class, @args) = @_;
	my $self = [];

	for my $arg (@args) {
		if (distinct_from_all_previous_combos($arg, @{$self})) {
			push @{$self}, $arg;
		} else {
			die "can't set next combo same as existing";
		}
	}

	bless($self, $class);
}

sub distinct_from_all_previous_combos {
	my ($primitive, @all_previous) = @_;
	for my $previous_primitive (@all_previous) {
		if (first_two_parts_in_common($primitive, $previous_primitive)) {
			return 0;
		}
	}
	return 1;
}

sub first_two_parts_in_common {
	my ($combo1, $combo2) = @_;
	my @combo1_parts = split(' ', $combo1);
	my @combo2_parts = split(' ', $combo2);
	if (($combo1_parts[0] eq $combo2_parts[0])
		&& ($combo1_parts[1] eq $combo2_parts[1])) {
		return 1;
	} else {
		return 0;
	}
}

sub combos_of_r {
	my ($r, @all_primitive_combinations) = @_;
	my @all_combos_of_r = permute_picking_r_of_n($r, @all_primitive_combinations);
	my @good_combos;

	for my $permutation_arrayref (@all_combos_of_r) {
		my @permutation = @{$permutation_arrayref};
		my $combo = eval {
			bin::combinations::combinated->new(
				@permutation,
			);
		};
		if (! $@) {
			push @good_combos, join(' ', @permutation);
		}
	}

	return @good_combos;
}

sub permute_picking_r_of_n {
	my ($r, @n) = @_;
	my $permuter = Algorithm::Permute->new([@n], $r);
	my @permutations;
	while (my @permutation = $permuter->next()) {
		push @permutations, [ @permutation ];
	}
	return @permutations;
}

package main;

print 
	join("\n", bin::combinations::combinated::combos_of_r(
	(defined $ARGV[0] ? $ARGV[0] : 2),
	bin::combinations::primitive::possible_column_combinations(),
)) . "\n"
	unless caller();

1;
