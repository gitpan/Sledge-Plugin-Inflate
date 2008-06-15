package Sledge::Plugin::Inflate;
use strict;
use warnings;
our $VERSION = '0.04';
use Carp;
use Sledge::Registrar;

sub import {
    my $pkg = caller(0);

    $pkg->mk_classdata('__inflate_rule' => []);

    my $sub = sub {
        my ($self, $key) = @_;
        my $page = Sledge::Registrar->context;

        for my $rule ( @{ $page->__inflate_rule } ) {
            if ($key =~ $rule->{regexp}) {
                return $rule->{cb}->($page);
            }
        }

        # unmatched
        croak "unknown inflate rule : $key";
    };

    $pkg->add_trigger(
        AFTER_INIT => sub {
            my $page = shift;

            for my $meth (qw/r session/) {
                no strict 'refs';  ## no critic
                my $proto = ref $page->$meth;
                *{"$proto\::inflate"} = $sub;
            }
        }
    );

    {
        no strict 'refs'; ## no critic
        *{"$pkg\::add_inflate_rule"} = sub {
            my ($class, %rule) = @_;

            while (my ($regexp, $cb) = each %rule ) {
                unshift @{ $class->__inflate_rule } => {
                    regexp => $regexp,
                    cb     => $cb,
                };
            }
        };
    }
}

1;
__END__

=head1 NAME

Sledge::Plugin::Inflate - inflate object from request or session.

=head1 SYNOPSIS

    package Your::Pages;
    use Sledge::Plugin::Inflate;
    use DateTime;

    __PACKAGE__->add_inflate_rule(
        qr/^(.+day)$/ => sub {
            my $self = shift;
            my %args;
            @args{year month day} = split /-/, $self->r->param($1);
            return DateTime->new(%args);
        },
        cd_id => sub {
            my $self = shift;
            return Your::Data::CD->retrieve($self->r->param('cd_id'));
        },
        user_id => sub {
            my $self = shift;
            return Your::Data::User->retrieve($self->r->param('user_id'));
        }
    );

    sub dispatch_foo {
        my $self = shift;

        $self->r->inflate('birthday');
        $self->r->inflate('cd_id');
        $self->session->inflate('user_id');
    }

=head1 DESCRIPTION

inflate object from request or session.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

Tokuhiro Matsuno  C<< <tokuhiro __at__ mobilefactory.jp> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Tokuhiro Matsuno C<< <tokuhiro __at__ mobilefactory.jp> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

