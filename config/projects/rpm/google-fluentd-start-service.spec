# Build with "rpmbuild -bb google-fluentd-start-service.spec".
Summary: Service auto-start helper for the data collector for Google Cloud Logging
Name: google-fluentd-start-service
Version: 0.0.1
Release: 1%{?dist}
BuildArch: noarch
License: ASL 2.0
Group: System Environment/Daemons
URL: https://cloud.google.com/logging/docs/agent
Requires: google-fluentd

%description
This auxiliary helper automatically starts the data collector for Google Cloud Logging when installed.

%files

%clean
exit 0

%post
/sbin/service google-fluentd start

%changelog
* Thu Jun 18 2020 Stackdriver Agents <stackdriver-agents@google.com> 0.0.1-1
- Initial release.
