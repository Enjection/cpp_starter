from conans import CMake
from conans import ConanFile


class StarterApp(ConanFile):
    name = "starter_app"
    version = "0.0.1"
    description = "Starter App"
    author = "???"
    generators = "cmake"
    settings = "os", "arch", "compiler", "build_type"
    requires = (
        "libuv/1.42.0",
        "catch2/2.11.0"
    )

    def configure(self):
        pass

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
