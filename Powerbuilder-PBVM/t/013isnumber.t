use Test::More tests => 6;
BEGIN { use_ok('Powerbuilder::PBVM') };

my $session = new Powerbuilder::PBVM;
cmp_ok( ref($session), 'eq', 'Powerbuilder::PBVM',    'constructor');

my $number1 = 1;
my $number2 = 1.5;
my $notnumber1 = '10';
my $notnumber2 = "1.5";

cmp_ok( $session->doesScalarContainNumber( $number1 ), '==', 1, 'number 1' );
cmp_ok( $session->doesScalarContainNumber( $number2 ), '==', 1, 'number 2' );
cmp_ok( $session->doesScalarContainNumber( $notnumber1 ), '!=', 1, 'not number 1' );
cmp_ok( $session->doesScalarContainNumber( $notnumber2 ), '!=', 1, 'not number 2' );