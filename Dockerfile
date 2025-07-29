ARG os=10.0.20250606
ARG image=php-8.4

FROM aursu/pearbuild:${os}-${image}

# 10.0 and 10z doesn't contain GraphicsMagick-devel, so we need to use 10 or 10.1
RUN sed -i 's/\${releasever_minor:+-z}//' /etc/yum.repos.d/epel.repo \
    && dnf -y install \
        GraphicsMagick-devel \
    && dnf clean all && rm -rf /var/cache/dnf

COPY SOURCES ${BUILD_TOPDIR}/SOURCES
COPY SPECS ${BUILD_TOPDIR}/SPECS

RUN chown -R $BUILD_USER ${BUILD_TOPDIR}/{SOURCES,SPECS}

USER $BUILD_USER

ENTRYPOINT ["/usr/bin/rpmbuild", "php-pecl-gmagick.spec"]
CMD ["-ba"]
