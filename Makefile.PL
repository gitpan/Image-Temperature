use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Image::Temperature',
    'VERSION_FROM'	=> 'Temperature.pm', 
    'PREREQ_PM'		=> {
	'GD' => '1',
    }, 
    ($] >= 5.005 ?    
      (ABSTRACT_FROM => 'Temperature.pm', 
       AUTHOR     => 'xern <xern@cpan.org>') : ()),
);
