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
              url: "https://portainer-agent:9001",
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
});
