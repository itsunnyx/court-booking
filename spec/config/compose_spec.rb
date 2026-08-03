require "json"
require "open3"

RSpec.describe "Docker Compose configuration" do
  it "provides a healthy Keycloak service backed by PostgreSQL" do
    compose_file = File.expand_path("../../compose.yml", __dir__)
    output, error, status = Open3.capture3(
      "docker", "compose", "-f", compose_file, "config", "--format", "json"
    )

    expect(status).to be_success, error

    configuration = JSON.parse(output)
    keycloak = configuration.dig("services", "keycloak")
    database = configuration.dig("services", "keycloak-db")

    expect(keycloak).to include(
      "image" => "quay.io/keycloak/keycloak:26.7.0",
      "command" => [ "start-dev" ]
    )
    expect(keycloak.fetch("ports")).to include(
      include("target" => 8080, "published" => "8080")
    )
    expect(keycloak.dig("depends_on", "keycloak-db", "condition")).to eq("service_healthy")
    expect(keycloak.fetch("healthcheck")).to include("test")

    expect(database).to include("image" => "postgres:17")
    expect(database.fetch("healthcheck")).to include("test")
    expect(database.fetch("volumes")).to include(
      include("source" => "keycloak_postgres_data", "target" => "/var/lib/postgresql/data")
    )
  end
end
