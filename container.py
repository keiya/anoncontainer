import base64
import docker
import os
import subprocess
import threading
import uuid

class DockerRunner(threading.Thread):
    def __init__(self, image_name, command):
        threading.Thread.__init__(self)
        self.container_name = 'apsis-' + str(uuid.uuid4())
        self.image_name = image_name
        self.command = command.split(' ')

    def run(self):
      if 'DISPLAY' in os.environ:
        x_display = os.environ['DISPLAY']
        rc = subprocess.call( ['docker', 'run', '-ti', '--rm', '--name', self.container_name,
                   '-e', 'DISPLAY='+x_display, '-v', '/tmp/.X11-unix:/tmp/.X11-unix',
                   '--net=none',
                   self.image_name] + self.command )
      else:
        rc = subprocess.call( ['docker', 'run', '-ti', '--rm', '--name', self.container_name,
                   '--net=none', '--dns=8.8.8.8',
                   self.image_name] + self.command )


class NetworkConfigurator():
    def __init__(self,container_name):
        self.ctr = None
        self.shell_env = os.environ.copy()
        self.container_name = container_name
        self.path = os.path.dirname(os.path.abspath(__file__))

    def __enter__(self):
        c = docker.APIClient()
        timeout = 0
        while not self.ctr:
            try:
                tmp_ctr = c.inspect_container(self.container_name)
                if tmp_ctr["State"]["Pid"] > 0:
                    self.ctr = tmp_ctr
                    break

            except docker.errors.NotFound as e:
                pass

            if timeout > 1000:
                raise Exception("couldn't get pid")

            timeout += 1

        self.shell_env["apsis_sandboxed_pid"] = str(self.ctr["State"]["Pid"])
        rc = subprocess.call( ['bash', self.path + '/container-net-up.sh'], env=self.shell_env )

    def __exit__(self, exc_type, exc_value, traceback):
        print("executing net-down")
        self.shell_env["apsis_sandboxed_pid"] = str(self.ctr["State"]["Pid"])
        rc = subprocess.call( ['bash', self.path + '/container-net-down.sh'], env=self.shell_env )


