def call(body) {
    // evaluate the body block, and collect configuration into the object
    def config = [:]
    body.resolveStrategy = Closure.DELEGATE_FIRST
    body.delegate = config
    body()

    // Mandatory configuration
    def dockerfile = config["dockerfile"]
    assert dockerfile : "dockerfile should be specified"
    def gitUrl = config["git"]
    assert gitUrl : "git should be specified"

    // Optional configuration
    def projectName = config["name"] ?: env.JOB_BASE_NAME
    def sanitizers = config["sanitizers"] ?: ["address", "memory"]
    def checkoutDir = config["checkoutDir"] ?: projectName

    def date = java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmm").format(java.time.LocalDateTime.now())

    node {
      echo "Building project $projectName with Dockerfile=$dockerfile"

      for (int i = 0; i < sanitizers.size(); i++) {
        def sanitizer = sanitizers[i]
        def dockerTag = "$projectName-$sanitizer"

        dir(sanitizer) {
          echo "*** Building with $sanitizer sanitizer"

          // See JENKINS-33511
          sh 'pwd > pwd.current'
          def workspace = readFile('pwd.current').trim()
          def out = "$workspace/out"

          dir('libfuzzer-bot') {
              git url: 'https://github.com/google/libfuzzer-bot/'
          }
          dir(checkoutDir) {
              git url: gitUrl
          }

          sh "docker build -t libfuzzer/$dockerTag -f $dockerfile ."

          sh "rm -rf $out"
          def zipFile= "$dockerTag-${date}.zip"

          sh "mkdir -p $out"
          sh "docker run -v $workspace:/workspace -v $out:/out -e sanitizer_flags=\"-fsanitize=$sanitizer\" -t libfuzzer/$dockerTag"
          sh "zip -j $zipFile $out/*"
          sh "gsutil cp $zipFile gs://clusterfuzz-builds/$projectName/"
        }
      }
    }

  echo 'Done'
}

return this;
