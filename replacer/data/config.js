module.exports = () => ({
  http: {
    routers: {
      "portainer-router": {
        entrypoints: ["web"],
        rule: "Host(`portainer.corliansa.xyz`) && PathPrefix(`/`)",
        service: "portainer",
        priority: 2,
        middlewares: ["tailscale-auth"],
      },
    },
    services: {
      portainer: {
        loadbalancer: {
          servers: [
            {
              url: "http://portainer-agent:9443",
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
});
