#!/usr/bin/env perl

####################################################################################################
# Author:  I. Dan Melamed
# Purpose:	for each pair of floating point numbers (x,y), and +ive tolerance t, check if (x / y - 1 < t)
# Streams:	2 files of numbers; the numbers that we want to be smaller should come first
# N.B.:		tolerance is evaluated in only one direction, unless one of the numbers is zero
# N.B.2:    return code is > 0 iff tolerance test fails
####################################################################################################

#check for correct usage
if ($#ARGV < 0) {
    print "usage: $0 <tolerance> <file 1> [<file 2>]\n";
    exit; 
};

$exitCode = 0;
$tolerance = shift;
open(F, $ARGV[0]) || die "\nCouldn't open $ARGV[0]: $!\n";
shift;
open(G, $ARGV[0]) || die "\nCouldn't open $ARGV[0]: $!\n";
shift;

LINE: while (<F>) {
	@ftok = split;
	if (eof(G)) {
		print "1st file has more lines than 2nd.\n";
		$exitCode = 11;
		last;
	};
	$_ = <G>;
	@gtok = split;
	while (@ftok) {
		if (! @gtok) {
			print "Different number of tokens on line $.\n";
			$exitCode = 13;
			next LINE;
		};
		$ftok = shift @ftok;
		$gtok = shift @gtok;
		if ($ftok == 0 && $gtok == 0) {
			next;
		};
		if (
			($ftok != 0 && $gtok == 0)
			|| 
			($ftok == 0 && $gtok != 0)
			) {
			print "Difference in zeros on line $.: $ftok vs. $gtok .\n";
			$exitCode = 15;
			next LINE;
		};
		$diff = $ftok / $gtok - 1.0;
		if ($diff > $tolerance) {
			print "Difference exceeds tolerance of $tolerance on line $.: $ftok vs. $gtok .\n";
			$exitCode = 17;
			next LINE;
		};
	};
	if (@gtok) {
		print "Different number of tokens on line $.\n";
		$exitCode = 19;
		next LINE;
	};
};

if (not eof(G)) {
	$exitCode = 21;
	print "2nd file has more lines than 1st.\n";
};

exit $exitCode;
