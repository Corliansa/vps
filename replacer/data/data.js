module.exports = {
  http: {
    routers: {
      "nextjs-router": {
        entrypoints: ["web"],
        rule: "Host(`corliansa.xyz`) && PathPrefix(`/`)",
        service: "noop",
        priority: 2,
        middlewares: ["redirect-to-https"],
      },
      "nextjs-router-secure": {
        entrypoints: ["websecure"],
        rule: "Host(`corliansa.xyz`) && PathPrefix(`/`)",
        service: "nextjs",
        priority: 2,
        tls: {
          certresolver: "letsencrypt",
        },
        middlewares: [],
      },
      "adguard-router": {
        entrypoints: ["web"],
        rule: "Host(`dns.corliansa.xyz`) && PathPrefix(`/`)",
        service: "noop",
        priority: 2,
        middlewares: ["redirect-to-https"],
      },
      "adguard-router-secure": {
        entrypoints: ["websecure"],
        rule: "Host(`dns.corliansa.xyz`) && PathPrefix(`/`)",
        service: "adguard",
        priority: 2,
        tls: {
          certresolver: "letsencrypt",
        },
        middlewares: [],
      },
      "portainer-router": {
        entrypoints: ["web"],
        rule: "Host(`portainer.corliansa.xyz`) && PathPrefix(`/`)",
        service: "noop",
        priority: 2,
        middlewares: ["redirect-to-https"],
      },
      "portainer-router-secure": {
        entrypoints: ["websecure"],
        rule: "Host(`portainer.corliansa.xyz`) && PathPrefix(`/`)",
        service: "portainer",
        priority: 2,
        tls: {
          certresolver: "letsencrypt",
        },
        middlewares: ["tailscale-auth"],
      },
      "coolify-3000-/-secure": {
        middlewares: ["tailscale-auth"],
      },
      "traefik-router": {
        entrypoints: ["web"],
        rule: "Host(`traefik.corliansa.xyz`) && PathPrefix(`/`)",
        service: "noop",
        priority: 2,
        middlewares: ["redirect-to-https"],
      },
      "traefik-router-secure": {
        entrypoints: ["websecure"],
        rule: "Host(`traefik.corliansa.xyz`) && PathPrefix(`/`)",
        service: "api@internal",
        priority: 2,
        tls: {
          certresolver: "letsencrypt",
        },
        middlewares: ["tailscale-auth"],
      },
    },
    services: {
      nextjs: {
        loadbalancer: {
          servers: [
            {
              url: "http://nextjs:3000",
            },
          ],
        },
      },
      adguard: {
        loadbalancer: {
          servers: [
            {
              url: "https://adguard:443",
              scheme: "https",
            },
          ],
        },
      },
      portainer: {
        loadbalancer: {
          servers: [
            {
              url: "https://portainer:9443",
              scheme: "https",
            },
          ],
        },
      },
    },
    middlewares: {
      "tailscale-auth": {
        forwardAuth: {
          address: "http://replacer:8080/auth",
        },
      },
    },
  },
};
