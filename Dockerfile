FROM node:16.14.2-alpine AS builder
RUN mkdir -p app
COPY . app/
WORKDIR app/
RUN yarn install --frozen-lockfile
RUN yarn run build
FROM node:16.14.2-alpine AS prod
RUN mkdir app
COPY --from=builder app/dist ./app/dist
COPY --from=builder app/node_modules ./app/node_modules
COPY --from=builder app/static ./app/static
USER node
WORKDIR app/
EXPOSE 3000
CMD ["node", "dist/main"]