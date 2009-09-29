#!/usr/bin/perl
#~ $|=1;
use Win32::Registry;
#TODO: install or migrated *.pbw, *.pbl, *.pbt in $PBVERSION !
#	-> we could use Powerbuilder::ORCA or an orcascript...
my $sybase;
$::HKEY_LOCAL_MACHINE->Open('SOFTWARE\Sybase\Powerbuilder', $sybase) 
	or die "can't open Sybase/Powerbuilder registry key!\n";

my @keys;
$sybase->GetKeys(\@keys);
$sybase->Close;
@keys = sort @keys;
print "Sybase Powerbuilder available versions:\n";
my $pbversion = $keys[-1];
foreach (@keys){
	print "\t$_";
	if( -e "usepb$_" or $pbversion eq $_){
		print " *" ;
		$pbversion = $_;
	}
	print "\n";
}
my %values;
$::HKEY_LOCAL_MACHINE->Open('SOFTWARE\Sybase\Powerbuilder\\'. $pbversion, $sybase) 
	or die "can't open Sybase/Powerbuilder/$pbversion registry key!\n";
$sybase->GetValues(\%values);
$sybase->Close;
my $pbpath = $values{Location}[2] . '\\' . $values{"IPS Name"}[2] . '\SDK\PBNI';
print 'Using installation path "'.$pbpath.'"'.$/;

sub unlinkdir{
	my $dir = shift;
	foreach(glob($dir.'/*')){
		#~ warn "deleting $_\n";
		unlink $_;
	}
	rmdir $dir;
}

unlinkdir "./sybase/include"; # if -e './include';
unlinkdir "./sybase/lib"; # if -e './include';
unlinkdir "./sybase";
mkdir './sybase';
mkdir './sybase/include';
mkdir './sybase/lib';
#* then copy files
`copy /Y "$pbpath\\include\\*.*" .\\sybase\\include`;
`copy /Y "$pbpath\\lib\\*.*" .\\sybase\\lib`;
#* then patch PBNI.h if needed...
`move .\\sybase\\include\\PBNI.h .\\sybase\\include\\PBNI.h.bak`;
open my $PBNIH, ">", "./sybase/include/PBNI.h" or die "Can't patch PBNI.H !\n";
open my $PBNIHSRC, "<", "./sybase/include/PBNI.h.bak" or die "Can't patch PBNI.H.bak !\n";
while(<$PBNIHSRC>){
	s/^\s*#define\s+(TRUE|FALSE)(.*)$/#ifndef $1\n#define $1\t$2\n#endif\n/;
	print $PBNIH $_;
}
close $PBNIH;
close $PBNIHSRC;
unlink './sybase/include/PBNI.h.bak';

#* ADD matching defined  PBxxy
package PreBuild;
our $PBVERSION = '-DPB'.$pbversion;
$PBVERSION =~ s/\.//;
#~ warn "Exporting \$PBVERSION = $PBVERSION\n";
1;