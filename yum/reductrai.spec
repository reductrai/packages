Name:           reductrai
Version:        1.0.0
Release:        1%{?dist}
Summary:        AI SRE Proxy - Full observability at 10% of the cost
License:        Proprietary
URL:            https://reductrai.com
Source0:        https://releases.reductrai.com/v%{version}/reductrai-%{version}.tar.gz

BuildRequires:  systemd-rpm-macros
Requires:       systemd

%description
ReductrAI is an AI-powered SRE proxy that provides full observability at 10% of the cost.
It acts as a transparent proxy between your applications and monitoring services,
compressing data locally while maintaining 100% visibility through AI-powered queries.

%prep
%autosetup -n reductrai-%{version}

%build
# Binary distribution, no build needed

%install
# Install binaries
install -D -m 755 bin/reductrai %{buildroot}%{_bindir}/reductrai
install -D -m 755 bin/reductrai-cli %{buildroot}%{_bindir}/reductrai-cli

# Install configuration
install -D -m 644 config/config.yaml %{buildroot}%{_sysconfdir}/reductrai/config.yaml
install -D -m 644 config/reductrai.env %{buildroot}%{_sysconfdir}/default/reductrai

# Install systemd service
install -D -m 644 systemd/reductrai.service %{buildroot}%{_unitdir}/reductrai.service

# Create directories
install -d -m 755 %{buildroot}%{_localstatedir}/lib/reductrai
install -d -m 755 %{buildroot}%{_localstatedir}/log/reductrai

# Install documentation
install -D -m 644 README.md %{buildroot}%{_docdir}/%{name}/README.md
install -D -m 644 LICENSE %{buildroot}%{_docdir}/%{name}/LICENSE

%pre
# Create user and group
getent group reductrai >/dev/null || groupadd -r reductrai
getent passwd reductrai >/dev/null || \
    useradd -r -g reductrai -d /var/lib/reductrai -s /sbin/nologin \
    -c "ReductrAI Service Account" reductrai

%post
%systemd_post reductrai.service

# Set proper permissions
chown -R reductrai:reductrai /var/lib/reductrai
chown -R reductrai:reductrai /var/log/reductrai

%preun
%systemd_preun reductrai.service

%postun
%systemd_postun_with_restart reductrai.service

%files
%license LICENSE
%doc README.md
%{_bindir}/reductrai
%{_bindir}/reductrai-cli
%{_unitdir}/reductrai.service
%config(noreplace) %{_sysconfdir}/reductrai/config.yaml
%config(noreplace) %{_sysconfdir}/default/reductrai
%attr(755,reductrai,reductrai) %{_localstatedir}/lib/reductrai
%attr(755,reductrai,reductrai) %{_localstatedir}/log/reductrai

%changelog
* Mon Jan 15 2025 ReductrAI Team <support@reductrai.com> - 1.0.0-1
- Initial release
- Full monitoring proxy functionality
- AI-powered query interface
- 89% compression ratio achieved