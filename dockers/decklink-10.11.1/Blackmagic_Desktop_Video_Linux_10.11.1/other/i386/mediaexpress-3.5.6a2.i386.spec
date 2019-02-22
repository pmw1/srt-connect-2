%define _unpackaged_files_terminate_build 1
%undefine _missing_build_ids_terminate_build
%filter_provides_in %{_libdir}/blackmagic/MediaExpress/.*\.so.*$ 
%filter_from_requires /libQt5.*/d
%filter_from_requires /libc++.*/d
%filter_from_requires /libgcc_s.*/d
%filter_from_requires /libMXF.*/d
%filter_from_requires /libQtSingleApplication.*/d
%filter_setup
#
# RPM spec file for Blackmagic Drivers
#
Name:          mediaexpress
Summary:       Blackmagic Design - Media Express 3.5.6
Version:       3.5.6
Release:       a2
License:       Proprietary

Group:         Applications/Multimedia
Vendor:        Blackmagic Design Inc.
Packager:      Blackmagic Design Inc. <developer@blackmagicdesign.com>
Url:           http://blackmagicdesign.com
Requires:      blackmagic-driver
Provides:      mediaexpress
Buildarch:     i386
Buildroot:     %{_topdir}/BUILDROOT/%{name}-%{version}-%{release}.%{buildarch}
AutoProv:      0

%description
Media Express lets you capture, organize and playback all your project media.
It includes loads of smart features that make it simple to work with
compressed and uncompressed video in 2D and dual stream 3D.

%debug_package

%install
[ -d "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != / ]  && rm -rf "$RPM_BUILD_ROOT"
mkdir -p "$RPM_BUILD_ROOT"
tar zxf $RPM_SOURCE_DIR/$RPM_PACKAGE_NAME-$RPM_PACKAGE_VERSION$RPM_PACKAGE_RELEASE-$RPM_ARCH.tar.gz --strip=1 -C "$RPM_BUILD_ROOT"
if [ "%{_lib}" != lib ]; then
    mkdir -p $RPM_BUILD_ROOT/usr/%{_lib}
    mv $RPM_BUILD_ROOT/usr/lib/blackmagic $RPM_BUILD_ROOT/usr/%{_lib}
fi
ln -sf ../%{_lib}/blackmagic/MediaExpress/MediaExpress $RPM_BUILD_ROOT/usr/bin/MediaExpress

%clean
[ -n "$RPM_BUILD_ROOT" ] || export RPM_BUILD_ROOT=%{_topdir}/BUILDROOT
[ -d "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != / ]  && rm -rf "$RPM_BUILD_ROOT"

%post
/usr/bin/update-desktop-database &> /dev/null || :

%postun
if [ $1 -eq 0 ]; then
	/usr/bin/gtk-update-icon-cache --force --quiet /usr/share/icons/hicolor || :
fi
/usr/bin/update-desktop-database &> /dev/null || :


%posttrans
/usr/bin/gtk-update-icon-cache --force --quiet /usr/share/icons/hicolor || :

%files
%defattr(-,root,root,-)
%{_bindir}/*
%{_datadir}/applications/*
%{_datadir}/icons/hicolor/*/apps/*
%{_mandir}/man1/*
%{_docdir}/mediaexpress/*
%{_libdir}/blackmagic/MediaExpress/*

%changelog
* Mon Apr 8 2013 Stephen Buck <developer@blackmagicdesign.com>
  Initial changelog for MediaExpress
