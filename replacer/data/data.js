module.exports = {
  http: {
    routers: {
      "nextjs-router": {
        entrypoints: ["web"],
        rule: "Host(`corliansa.xyz`) && PathPrefix(`/`)",
        service: "nextjs",
        priority: 2,
        middlewares: ["redirect-to-https"],
      },
      "nextjs-router-secure": {
        entrypoints: ["websecure"],
        rule: "Host(`corliansa.xyz`) && PathPrefix(`/`)",
        service: "nextjs",
        priority: 2,
        tls: {
          certResolver: "le",
        },
        middlewares: [],
      },
      "adguard-router": {
        entrypoints: ["web"],
        rule: "Host(`dns.corliansa.xyz`) && PathPrefix(`/`)",
        service: "adguard",
        priority: 2,
        middlewares: ["redirect-to-https"],
      },
      "adguard-router-secure": {
        entrypoints: ["websecure"],
        rule: "Host(`dns.corliansa.xyz`) && PathPrefix(`/`)",
        service: "adguard",
        priority: 2,
        tls: {
          certResolver: "le",
        },
        middlewares: [],
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
    },
  },
};
