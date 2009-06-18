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
my $projectfile = 'explore.pbt';
chdir 'C:\Developpement\Powerbuilder\explore-2.1.0\Sources';

my $pb = new Powerbuilder::PBVM;
print "Running application...\n";
$pb->RunApplication( $pb->project( $projectfile ), '--batch' );
print "Application running...\n";
$pb->ReleaseSession();

END{
	chdir $saved_dir;
};