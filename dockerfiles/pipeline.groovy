def call(body) {
    // evaluate the body block, and collect configuration into the object
    def config = [:]
    body.resolveStrategy = Closure.DELEGATE_FIRST
    body.delegate = config
    body()

    // Mandatory configuration
    def dockerfile = config["dockerfile"]
    assert dockerfile : "dockerfile should be specified"

    // Optional configuration
    def projectName = config["name"] ?: env.JOB_BASE_NAME
    def sanitizers = config["sanitizers"] ?: ["address", "memory"]

    node {
      echo "Config: ${config}"

      echo "Building project ${projectName} with Dockerfile=${dockerfile}"

      for (int i = 0; i < sanitizers.size(); i++) {
        def sanitizer = sanitizers[i]
        def docker_tag = "${projectName}-${sanitizer}"

        dir(sanitizer) {
          echo "*** Building with ${sanitizer} sanitizer"
        }
      }
    }
}

return this;
