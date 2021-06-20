# remove pid
rm -f /tmp/pids/server.pid

# Run docker images
# docker-compose up --build

# Create db
docker-compose run web rake db:create

# Run migration
docker-compose run web rails db:migrate:reset

# Run seed
docker-compose run web rails db:seed

# install js package
docker-compose run web yarn

# start server
docker-compose up

