##########################################################################################
# Module/Library Name: SXM
# Development: Stamatis X. Mavrogeorgis
# Location: /usr/local/share/perl/x.y.z/SXM.pm
#       or: /usr/local/lib/perl/x.y.z/SXM.pm
#       or: $HOME/.local/share/perl/SXM.pm
##########################################################################################

package SXM;

use strict; use warnings;
use bignum;
use v5.20;
no warnings 'experimental::smartmatch';
use utf8;
#use Encode;
use Time::Local;
#use open qw/:encoding(utf8)/;
#use encoding 'utf-8';
use Math::Complex;
use Math::Trig;
use Math::Round;
use parent 'Exporter';
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = qw($version $year $copyLeft $userHomeDir $userIconDir $sxmtoolkitDir $backupDir);
@EXPORT_OK   = qw(DEBUGSXM factorial readPrefix formatPrefix formatLTS2UTS slurpFile deZero max min);
%EXPORT_TAGS = ( DEFAULT => [qw(&DEBUGSXM)],
                 All => [qw(&DEBUGSXM &factorial &readPrefix &formatPrefix &formatLTS2UTS &slurpFile &deZero &max &min)]);

our $version=`grep '^# version' \$(which $0) | cut -f3 -d' ' | sort -r | head -1`; chomp $version;
our $year = `date "+%Y"`; chomp $year;
our $copyLeft = 'Copyright 2010 - ' . $year . ' Stamatis X. Mavrogeorgis';

our $userHomeDir="$ENV{HOME}";
our $userIconDir="$userHomeDir/.local/share/icons";
our $sxmtoolkitDir="$userHomeDir/.sxmtoolkit";
our $backupDir="$sxmtoolkitDir/.backup";

sub factorial($) {
  my ($target) = @_;
  my $start=1;
  my $result=1;
  while ($start <= $target) {
    $result *= $start;
    $start++;
  }
  if($target == 0) {
    $result=1;
  }
  if($target < 0) {
    $result="undef";
  }
  return $result;
}

sub findOOM($) {
  my $iNumber = $_[0];
  return nearest(1,log($iNumber)/log(10));
}

sub readPrefix($) {
  my ($iNumber) = @_;
  my $tNum = $iNumber;
  my $prefix = chop $tNum;
  my $retNumber = $iNumber;
  given ($prefix) {
    when ('y') { $retNumber = $tNum * 1e-24 }
    when ('z') { $retNumber = $tNum * 1e-21 }
    when ('a') { $retNumber = $tNum * 1e-18 }
    when ('f') { $retNumber = $tNum * 1e-15 }
    when ('p') { $retNumber = $tNum * 1e-12 }
    when ('n') { $retNumber = $tNum * 1e-9 }
    when ('μ') { $retNumber = $tNum * 1e-6 }
    when ('u') { $retNumber = $tNum * 1e-6 }
    when ('m') { $retNumber = $tNum * 1e-3 }
    when ('k') { $retNumber = $tNum * 1e3 }
    when ('M') { $retNumber = $tNum * 1e6 }
    when ('G') { $retNumber = $tNum * 1e9 }
    when ('T') { $retNumber = $tNum * 1e12 }
    when ('P') { $retNumber = $tNum * 1e15 }
    when ('E') { $retNumber = $tNum * 1e18 }
    when ('Z') { $retNumber = $tNum * 1e21 }
    when ('Y') { $retNumber = $tNum * 1e24 }
    default { $retNumber = $iNumber }
  }
  return $retNumber;
}

sub formatPrefix($$) {
  no warnings "uninitialized";
  my ($number, $unit) = @_;
  my $retString;

  if ((abs($number) >= 1e27)) {
    $retString=nearest(.001, $number).$unit;
  }
  elsif ((abs($number) >= 1e24) and (abs($number) < 1e27)) {
    $number *= 1e-24;
    $retString=nearest(.001, $number).'Y'.$unit;
  }
  elsif ((abs($number) >= 1e21) and (abs($number) < 1e24)) {
    $number *= 1e-21;
    $retString=nearest(.001, $number).'Z'.$unit;
  }
  elsif ((abs($number) >= 1e18) and (abs($number) < 1e21)) {
    $number *= 1e-18;
    $retString=nearest(.001, $number).'E'.$unit;
  }
  elsif ((abs($number) >= 1e15) and (abs($number) < 1e18)) {
    $number *= 1e-15;
    $retString=nearest(.001, $number).'P'.$unit;
  }
  elsif ((abs($number) >= 1e12) and (abs($number) < 1e15)) {
    $number *= 1e-12;
    $retString=nearest(.001, $number).'T'.$unit;
  }
  elsif ((abs($number) >= 1e9) and (abs($number) < 1e12)) {
    $number *= 1e-9;
    $retString=nearest(.001, $number).'G'.$unit;
  }
  elsif ((abs($number) >= 1e6) and (abs($number) < 1e9)) {
    $number *= 1e-6;
    $retString=nearest(.001, $number).'M'.$unit;
  }
  elsif ((abs($number) >= 1e3) and (abs($number) < 1e6)) {
    $number *= 1e-3;
    $retString=nearest(.001, $number).'k'.$unit;
  }
  elsif ((abs($number) >= 1) and (abs($number) < 1e3)) {
    $number *= 1;
    $retString=nearest(.001, $number).$unit;
  }
  elsif ((abs($number) < 1) and (abs($number) >= 1e-3)) {
    $number *= 1e3;
    $retString=nearest(.001, $number).'m'.$unit;
  }
  elsif ((abs($number) < 1e-3) and (abs($number) >= 1e-6)) {
    $number *= 1e6;
    $retString=nearest(.001, $number).'μ'.$unit;
  }
  elsif ((abs($number) < 1e-6) and (abs($number) >= 1e-9)) {
    $number *= 1e9;
    $retString=nearest(.001, $number).'n'.$unit;
  }
  elsif ((abs($number) < 1e-9) and (abs($number) >= 1e-12)) {
    $number *= 1e12;
    $retString=nearest(.001, $number).'p'.$unit;
  }
  elsif ((abs($number) < 1e-12) and (abs($number) >= 1e-15)) {
    $number *= 1e15;
    $retString=nearest(0.001, $number).'f'.$unit;
  }
  elsif ((abs($number) < 1e-15) and (abs($number) >= 1e-18)) {
    $number *= 1e18;
    $retString=nearest(0.001, $number).'a'.$unit;
  }
  elsif ((abs($number) < 1e-18) and (abs($number) >= 1e-21)) {
    $number *= 1e21;
    $retString=nearest(0.001, $number).'z'.$unit;
  }
  elsif ((abs($number) < 1e-21) and (abs($number) >= 1e-24)) {
    $number *= 1e24;
    $retString=nearest(0.001, $number).'y'.$unit;
  }
  elsif ((abs($number) < 1e-24)) {
    $retString=nearest(0.001, $number).$unit;
  }
  return $retString;
}

sub formatLTS2UTS{
  my ($timeString) = @_;
  my $year=substr($timeString,0,4);
  my $month=substr($timeString,4,2);
  my $day=substr($timeString,6,2);
  my $hour=substr($timeString,8,2);
  my $minute=substr($timeString,10,2);
  my $second=substr($timeString,12,2);
  return timelocal($second, $minute, $hour, $day, $month-1, $year);
}

sub slurpFile{
  my ($fileToSlurp) = @_;
  open (*myFH, $fileToSlurp);
  my $holdTerminator = $/;
  undef $/;
  my ($slurpFile) = <myFH>;
  $/ = $holdTerminator;
  my @lines = split /$holdTerminator/, $slurpFile;
  $slurpFile = "init";
  $slurpFile = join $holdTerminator, @lines;
  close(*myFH);
  return $slurpFile; 
}

sub deZero{
  no warnings "uninitialized";
  my $retNum;
  if (Math::BigFloat::is_nan($_[0])) {
    $retNum = 0;
  } elsif ($_[0] eq "") {
    $retNum = 0;
  } else {
    $retNum = 0 + $_[0];
  }
  return($retNum);
}

sub DEBUGSXM {
  print(@_, "\n");
}

sub max ($$) { $_[$_[0] < $_[1]] }

sub min ($$) { $_[$_[0] > $_[1]] }

1
