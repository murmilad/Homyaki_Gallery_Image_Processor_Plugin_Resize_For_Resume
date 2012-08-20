package Homyaki::Task_Manager::Task::Build_Gallery::Image_Processor::Resize_For_Resume;

use strict;

use Imager;

use Homyaki::Imager qw(rotate change_size);
use Homyaki::Logger;

use base 'Homyaki::Task_Manager::Task::Build_Gallery::Image_Processor';


sub process {
	my $self = shift;

	my %h = @_;
	my $image        = $h{image};
	my $dest_path    = $h{dest_path};
	my $source_path  = $h{source_path};
    my $result_image = $h{result_image};

	my $img = rotate($result_image);
	$img = change_size($img, 320);

	$source_path =~ s/$self->{result_path}//;

	if ($source_path =~ /([\w \\(\)'&-]+)\/([\w-]+)\/(acoll_\d{7}_[\w \\\(\)'&]+\.jpg)$/i){

		unless (-d "$self->{result_path}/resume/$1/$2"){
			`mkdir -p $self->{result_path}/resume/$1/$2`
		}


		unless ($img->write(file=>"$self->{result_path}/resume/$1/$2/$3")) {
			Homyaki::Logger::print_log("Resize_For_Resume: set_resume_thumb Error: $self->{result_path}/resume/$1/$2/$3 - " . $img->errstr());
			print STDERR "$self->{result_path}/resume/$1/$2/$3 - ",$img->errstr(),"\n";
			next;
		}
	}
	Homyaki::Logger::print_log("Resize_For_Resume: load_images: Change $source_path size:");


	return $result_image;
}

1;
