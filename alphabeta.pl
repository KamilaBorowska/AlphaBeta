use 5.010;
use Getopt::Long;
sub p (@) { print @_ ? @_ : $_ }
sub _ (@) { say for @_ ? @_ : $_ }
sub j { print "Hello World" }
sub c (@) { chomp @_ ? @_ : $_ }
sub d (&) { $_[0]->() }
sub l (&) { $_[0]->() while 1 }
sub t (&) {
    while (<>) {
        my @values = split ' ', $_;
        my $regexp = '\s*';
        for my $value (@values) {
            $regexp .= '(\S+)\s*';
        }
        # Make $1 and higher variables
        $_ =~ $regexp;
        $_[0]->($_);
    }
}
sub w (&) {
    while (<>) {
        my @values = split ' ', $_;
        my $regexp = '\s*';
        for my $value (@values) {
            $regexp .= '(\S+)\s*';
        }
        # Make $1 and higher variables
        $_ =~ $regexp;
        say $_[0]->($_);
    }
}
sub e { eval $} }
sub i { print 'i' }

my $help;
my $help_document = <<"DOC";
AlphaBeta 0.1
  
  Turing-complete programming language where empty programs prints out
  alphabet. Other programs are eval'ed by Perl with additional functions
  to help making good and obfuscated programs.
  
  Additionally, to aid programming, following aliases are available.
  
  * p - works like print
  * _ - works like say except that arguments are separated with "\\n"
  * j - works like say "Hello World" without arguments
  * c - works like chomp
  * d - just like do - one character shorter
  * l - infinite loop
  * t - for every file line using \$1 and higher variables while split
  * w - similar to above, except with automatic say
  * e - eval current file name
  * i - prints 'i' (quine)
  
  Also, it has \$} variable which is currently parsed script in case you
  need it.
   
Usage:
  $0 [--help | <file.ab>]
DOC

GetOptions 'help' => \$help;
if ($help || !@ARGV) {
    print $help_document;
    exit 1;
}
else {
    my $file;
    my $code;
    {
        local $/;
        # The name of the file should be invisible for second program
        our $} = shift @ARGV;
        open my $file, '<', $} or die $!;
        $code = <$file>;
        close $file;
    }
    
    # Fix spacing issues
    $code =~ s/^\s+|\s+$//g;
    
    if ($code eq '') {
        say 'a'..'z';
    }
    else {
        eval $code;
    }
}
