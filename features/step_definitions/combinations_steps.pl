#!/usr/bin/env perl

use warnings;
use strict;

use Test::BDD::Cucumber::StepFile;

use Test::More;
use Test::Exception;

require 'bin/combinations.pl';

Given qr/^the first column is (.+)$/, sub {
	S->{first_column} = $1;
};

Given qr/^the second column is (.+)$/, sub {
	S->{second_column} = $1;
};

When qr/^the second column is (.+)$/, sub {
	S->{second_column} = $1;
};

When qr/^the third column is (.+)$/, sub {
	S->{third_column} = $1;
};

Then qr/^that's an invalid duplicate value$/, sub {
	S->{first_column}  = "" unless defined S->{first_column};
	S->{second_column} = "" unless defined S->{second_column};
	S->{third_column}  = "" unless defined S->{third_column};

	throws_ok { 
		bin::combinations::primitive->new(
			first_column  => S->{first_column},
			second_column => S->{second_column},
			third_column  => S->{third_column},
		)
	} qr|column same as first|;
};

Then qr/^that's an invalid combination$/, sub {
	S->{first_column}  = "" unless defined S->{first_column};
	S->{second_column} = "" unless defined S->{second_column};
	S->{third_column}  = "" unless defined S->{third_column};

	throws_ok { 
		bin::combinations::primitive->new(
			first_column  => S->{first_column},
			second_column => S->{second_column},
			third_column  => S->{third_column},
		)
	} qr|third column to that|;
};

When qr/all possible (first|second)-column/, sub {
	S->{possible_column_values} = bin::combinations::primitive::possible_first_column_values();
};

When qr/all possible third-column/, sub {
	S->{possible_column_values} = bin::combinations::primitive::possible_third_column_values();
};

Then qr/the output should be exactly (.+)$/, sub {
	is(S->{possible_column_values}, $1);
};

When qr/all possible combinations of columns$/, sub {
	S->{possible_column_combinations} = [ bin::combinations::primitive::possible_column_combinations() ];
};

Then qr/^the output should have (.+) combinations$/, sub {
	is(scalar @{S->{possible_column_combinations}}, $1);
};

Given qr/^the first combo is (.+)$/, sub {
	S->{first_combo} = $1;
};

When qr/^the second combo is (.+)$/, sub {
	S->{second_combo} = $1;
};

Then qr/^that's an invalid duplicate combo$/, sub {
	throws_ok { 
		bin::combinations::combinated->new(
			S->{first_combo},
			S->{second_combo},
		)
	} qr|combo same as existing|;
};

Given qr/^the primitive combinations (.+)$/, sub {
	my @primitive_combinations = split(',', $1);
	S->{given_combos} = [ @primitive_combinations ];
};

When qr/the possible 2-combos$/, sub {
	my @given_combos = @{S->{given_combos}};
	S->{possible_combos} = [ bin::combinations::combinated::combos_of_r(
		2,
		@given_combos,
	)];
};

When qr/all possible 2-combos$/, sub {
	S->{possible_combos} = [ bin::combinations::combinated::combos_of_r(
		2,
		bin::combinations::primitive::possible_column_combinations(),
	)];
};

Then qr/^the output should be (.+)$/, sub {
	my @possible_combos = @{S->{possible_combos}};
	is(join(',', @possible_combos), $1);
};

Then qr/^there should be no output$/, sub {
	is(join(',', @{S->{possible_combos}}), q{});
};

Then qr/^the output should have (.+) combos$/, sub {
	is(scalar @{S->{possible_combos}}, $1);
};
