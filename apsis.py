import argparse
import container

class Apsis():
    def __init__(self, image, command):
        self.dr = container.DockerRunner(image, command)

    def run(self):
        self.dr.start()
        with container.NetworkConfigurator(self.dr.container_name) as nc:
            self.dr.join()
        return self

parser = argparse.ArgumentParser(description='')
parser.add_argument('image', help='docker image')
parser.add_argument('command', help='command')
parser.add_argument('arg', nargs=argparse.REMAINDER, help='command arguments')
args = parser.parse_args()
ac = Apsis(args.image, args.command)
ac.run()
