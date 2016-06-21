def call(body) {
    // evaluate the body block, and collect configuration into the object
    def config = [:]
    body.resolveStrategy = Closure.DELEGATE_FIRST
    body.delegate = config
    body()

    def projectName = config.get("name", env.JOB_BASE_NAME)
    def dockerfile = config.get("dockerfile")

    node {
      echo "Config: ${config}"

      echo "Building project ${projectName} with Dockerfile=${dockerfile}"
    }
}

return this;
