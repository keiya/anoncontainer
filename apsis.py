import container

class Apsis():
    def __init__(self):
        #self.dr = container.DockerRunner("busybox","wget -O - --no-check-certificate https://130.158.64.1/~s1011420/env.php")
        self.dr = container.DockerRunner("busybox","/bin/sh")

    def run(self):
        self.dr.start()
        with container.NetworkConfigurator(self.dr.container_name) as nc:
            self.dr.join()
        return self

ac = Apsis()
ac.run()
