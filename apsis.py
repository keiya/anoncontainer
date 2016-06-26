import container

class Apsis():
    def __init__(self):
        self.dr = container.DockerRunner("firefox","firefox")

    def run(self):
        self.dr.start()
        with container.NetworkConfigurator(self.dr.container_name) as nc:
            self.dr.join()
        return self

ac = Apsis()
ac.run()
