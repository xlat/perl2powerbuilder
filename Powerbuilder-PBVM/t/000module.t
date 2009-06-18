# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Powerbuilder-PBVM.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 3;
BEGIN { use_ok('Powerbuilder::PBVM') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $session = new Powerbuilder::PBVM;
ok( ref($session) eq 'Powerbuilder::PBVM',    'constructor');

cmp_ok( pbvalue_char, 'eq', 18, 'constant test' );

diag "TODO: project( pbt_file, [ [relative_]path ] )";