FROM node:alpine

WORKDIR /usr/app

RUN apk add --no-cache git
RUN apk add --no-cache openssh
RUN git clone https://github.com/Corliansa/corliansa.git .

RUN corepack enable
RUN npm install --global pm2

# Production use node instead of root
# USER node

RUN yarn install

COPY ./ ./

RUN yarn build

USER node

EXPOSE 3000
CMD [ "pm2-runtime", "start", "yarn", "--", "start" ]
