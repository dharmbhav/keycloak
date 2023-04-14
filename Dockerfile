FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true


WORKDIR /opt/keycloak
FROM registry.access.redhat.com/ubi9 AS ubi-micro-build
RUN mkdir -p /mnt/rootfs
RUN dnf install --installroot /mnt/rootfs certbot --releasever 9 --setopt install_weak_deps=false --nodocs -y; dnf --installroot /mnt/rootfs clean all

FROM quay.io/keycloak/keycloak
COPY --from=ubi-micro-build /mnt/rootfs /

# change these values to point to a running postgres instance
ENV KC_DB=mssql
ENV KC_DB_URL=tcp:dpe-sbx-dbs-keycloak-test.database.windows.net,1433
ENV KC_DB_USERNAME=keycloak-dba
ENV KC_DB_PASSWORD=asin!fsa@#AS22
ENV KC_HOSTNAME=dpe-db-sbx-sql-keycloak-test
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]