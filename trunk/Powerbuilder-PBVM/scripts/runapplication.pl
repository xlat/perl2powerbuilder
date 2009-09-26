#!/usr/bin/wperl
my $saved_dir;
BEGIN{
	use Cwd;
	$saved_dir = cwd();
};
use Powerbuilder::PBVM;
$|=1;

#~ my $projectfile = 'scriptingpb.pbt';
#~ chdir 'C:\Developpement\Perl\Powerbuilder-PBVM\t';
chdir 'C:\developpement\perl\Powerbuilder\perl2powerbuilder\Powerbuilder\t';

my $pb = new Powerbuilder::PBVM;
print "Running application...\n";
$pb->CreateSession( $pb->project('scriptingpb.pbt') );
#~ $pb->RunApplication( 'scriptingpb.exe', 'scriptingpb.exe', 1, '' );
print "Application running...\n";
use Data::Dumper;
print Dumper( $pb->{PBVM} );
$pb->ReleaseSession();

END{
	chdir $saved_dir;
};