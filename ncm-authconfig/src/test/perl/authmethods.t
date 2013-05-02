# -*- mode: cperl -*-
# ${license-info}
# ${author-info}
# ${build-info}

=pod

=head1 DESCRIPTION

Trivial tests for the several methods that add arguments to the
C<authconfig> invocation.

=head1 TESTS

=cut

use strict;
use warnings;
use Test::More;
use Test::Quattor;
use NCM::Component::authconfig;
use CAF::Process;

my $cmp = NCM::Component::authconfig->new("authconfig");

my $cmd = CAF::Process->new([]);

=pod

=head2 C<enable_krb5>

Test the different KRB5-related parameters

=cut

$cmp->enable_krb5({realm => "foo", adminservers => [qw(admin admin2)],
		   kdcs => [qw(kdc kdc2)]}, $cmd);

is($cmd->{COMMAND}->[0], "--enablekrb5", "KRB5 enabled");
is($cmd->{COMMAND}->[1], "--krb5realm", "KRB5 realm invoked");
is($cmd->{COMMAND}->[2], "foo", "Correct KRB5 realm passed");
is($cmd->{COMMAND}->[3], "--krb5kdc", "KRB5 KDCs defined");
is($cmd->{COMMAND}->[4], "kdc,kdc2", "Correct KDCs defined");
is($cmd->{COMMAND}->[5], "--krb5adminserver", "KRB5 adminserver defined");
is($cmd->{COMMAND}->[6], "admin,admin2", "Correct admin servers defined");

$cmd = CAF::Process->new([]);
$cmp->enable_krb5({realm => "foo"}, $cmd);
is($cmd->{COMMAND}->[0], "--enablekrb5", "KRB5 enabled inconditionally");
is($cmd->{COMMAND}->[1], "--krb5realm", "KRB5 realm enabled inconditionally");
ok(!grep(m{krb5admin|krb5kdc}, @{$cmd->{COMMAND}}),
   "KRB5 KDC and admins are not passed unless defined");

=pod

=head2 C<enable_smb>

Test the Samba-related authentication parameters

=cut

$cmd = CAF::Process->new([]);

$cmp->enable_smb({workgroup => "wg", servers => [qw(srv1 srv2)]}, $cmd);
is($cmd->{COMMAND}->[0], "--enablesmbauth", "SMB authentication is enabled");
is($cmd->{COMMAND}->[1], "--smbworkgroup", "SMB work group is set up");
is($cmd->{COMMAND}->[2], "wg", "Correct SMB workgroup passed");
is($cmd->{COMMAND}->[3], "--smbservers", "SMB servers defined");
is($cmd->{COMMAND}->[4], "srv1,srv2", "Correct SMB servers defined");

=pod

=head2 C<enable_nis>

Test the NIS-related authentication parameters

=cut

$cmd = CAF::Process->new([]);

$cmp->enable_nis({domain => "dom", servers => [qw(srv1 srv2)]}, $cmd);

is($cmd->{COMMAND}->[0], "--enablenis", "NIS enabled");
is($cmd->{COMMAND}->[1], "--nisdomain", "NIS domain specified");
is($cmd->{COMMAND}->[2], "dom", "Correct NIS domain passed");
is($cmd->{COMMAND}->[3], "--nisserver", "NIS server specified");
is($cmd->{COMMAND}->[4], "srv1,srv2", "Correct NIS servers passed");

=pod

=head2 C<enable_hesiod>

Test the Hesiod-based authentication parameters

=cut

$cmd = CAF::Process->new([]);

$cmp->enable_hesiod({lhs => "l", rhs => "r"}, $cmd);

is($cmd->{COMMAND}->[0], "--enablehesiod", "Hesiod enabled");
is($cmd->{COMMAND}->[1], "--hesiodlhs", "LHS enabled");
is($cmd->{COMMAND}->[2], "l", "Correct LHS passed");
is($cmd->{COMMAND}->[3], "--hesiodrhs", "RHS enabled");
is($cmd->{COMMAND}->[4], "r", "Correct RHS passed");

=pod

=head2 C<enable_ldap>

Test the LDAP parameters for authconfig.

=cut

$cmd = CAF::Process->new([]);

$cmp->enable_ldap({nssonly => 1, basedn => "dn",}, $cmd);
is($cmd->{COMMAND}->[0], "--disableldapauth", "LDAP auth disabled when nssonly");
is($cmd->{COMMAND}->[1], "--enableldap", "LDAP enabled anyways");
is($cmd->{COMMAND}->[2], "--ldapbasedn=dn", "Correct DN passed");
ok(!grep(m{ldapserver|ldaptls}, @{$cmd->{COMMAND}}),
   "Unneeded options are not passed");

$cmd = CAF::Process->new([]);

$cmp->enable_ldap({nssonly => 0,
		   basedn => "dn",
		   servers => [qw(srv1 srv2)],
		   enableldaptls => 1},
		  $cmd);

is($cmd->{COMMAND}->[0], "--enableldapauth", "LDAP auth enabled when not nssonly");
is($cmd->{COMMAND}->[1], "--enableldap", "LDAP is enabled inconditionally");
is($cmd->{COMMAND}->[2], "--ldapserver", "LDAP servers are enabled when specified");
is($cmd->{COMMAND}->[3], "srv1,srv2", "Correct LDAP servers passed");
is($cmd->{COMMAND}->[4], "--ldapbasedn=dn", "Correct DN passed");
is($cmd->{COMMAND}->[5], "--enableldaptls",
   "LDAP TLS enabled when specified in the profile");

done_testing();
