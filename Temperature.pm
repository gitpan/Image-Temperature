package Image::Temperature;
use strict;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw/temperature threshold coefficient/;

our $VERSION = '0.01';

use GD;

our $threshold = 127;
our @coef = qw(0.3 0.59 0.11);

sub threshold   { $_[0] ? $threshold = $_[0] : $threshold }

sub tograyscale { $_[0]*$coef[0] + $_[1]*$coef[1] + $_[2]*$coef[2] }

sub coefficient { @_ == 3 ? @coef = @_ : @coef }

sub temperature {
    my $im;
    if(ref($_[0]) eq 'GD::Image'){
	$im = $_[0];
    }
    elsif(-f $_[0] && -s $_[0] && -r $_[0]) {
	$im = GD::Image->new($_[0]) || die "Cannot create a GD object for '$_[0]'\n";
    }

    my ($width,$height) = $im->getBounds();
    my $hit;
    foreach my $x (0..$width-1){
	foreach my $y (0..$height-1){
	    $hit++ if tograyscale($im->rgb($im->getPixel($x, $y))) >= $threshold;
	}
    }

    my $E = 2*$hit/($width +$height);
    return 0 if($E >= 0 && $E <= 1);
    log(10)/log($E/($E-1));
}


1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

Image::Temperature - Taking temperature of images

=head1 SYNOPSIS

    use Image::Temperature qw/temperature threshold coefficient/;

    print temperature($image);

    print threshold;

    print coefficient(0.3, 0.59, 0.11);


=head1 DESCRIPTION

Yes, the B<TEMPERATURE>. Temperature of an image means an invariant measure for the image, and temperature remains steady in spite of transposition, rotation or scaling. It is (may be/might be/not be) quite interesting to estimate the temperature of your given image.

The temperature of a given image is calculated with this formula: B<T = 1/log(E/(E-1))>. E stands for the expected number of intersection points of the image's curves and a random straight line; B<T> is the absolute temperature. (Surely, don't ask me how we derive this. Refer to this article yourself: I<The Planck constant of a curve> by B<Michel MendE<egrave>s France>.)

An image is composed of various colorful curves. However, before taking the temperature, the colored image needs to be converted to grayscale. The default conversion formula is B<0.3*R + 0.59*G + 0.11*B>. If the result is greater than or equal to 127, then the point is considered to be part of the image's curves; otherwise, the background. As to the same image, the lower the threshold, the higher the temperature. Of course, interface is also provided for you to modify the threshold and the coefficients of the conversion formula.

=head1 INTERFACE

=head2 temperature

Taking the temperature of an image. The parameter can be a GD object or an image file.

  print temperature('my_self-portrait');  # an easy number

  print temperature($GD_OBJECT);

=head2 threshold

Setting the threshold for a point to be considered of the curve.

 threshold($value);

If $value is not given, it returns the current threshold.

=head2 coeffient

Setting the cofficients of the conversion formula.

 coefficient($R, $G, $B);

It returns the current setting if nothing is given.

=head1 COPYRIGHT

xern E<lt>xern@cpan.orgE<gt>

This module is free software; you can redistribute it or modify it under the same terms as Perl itself.

=cut
