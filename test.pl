use Test;
BEGIN { plan tests => 5 };

use Image::Temperature qw/temperature threshold coefficient/;
use GD;

print "$/$/Please enter the image's path: ";
chomp ($_=<>);
print "$/";
ok(defined temperature($_));
ok(defined temperature(GD::Image->new($_)));
ok(threshold, 127);
ok(join(q//,coefficient), qw/0.30.590.11/);
ok(threshold(50), 50);
ok(join(q//,coefficient(0.3,0.3,0.3)), qw/0.30.30.3/);
