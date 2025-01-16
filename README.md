# Blender Notebook Container

## Introduction
The Blender Notebook Container project provides a convenient way to run Blender within a Jupyter Notebook environment. This setup allows users to leverage the power of Blender for 3D modeling, rendering, and scripting directly from a Jupyter Notebook.

## Features
- **Blender Integration**: Run Blender commands and scripts within Jupyter Notebooks.
- **Interactive Environment**: Use Jupyter's interactive features to visualize and manipulate 3D models.
- **Containerized Setup**: Easy to deploy and manage using Docker.

## Getting Started
### Prerequisites
- [Docker](https://www.docker.com/get-started) installed on your machine.

### Installation
1. Clone the repository:
    ```sh
    git clone https://github.com/scherlac/blender-container.git
    ```
2. Navigate to the project directory:
    ```sh
    cd blender-container
    ```

### Building the Docker Image
Build the Docker image using the provided Dockerfile:
```sh
docker build . --tag blender-container
```

### Running the Container

Run the Docker container using the following command:
```sh
docker run -it --rm -e ACCESS_PW=newPW \
    -v xa:/Xauthority \
    -p 6080:6080 \
    -p 8888:8888 \
    -p 5900:5900 \
    blender-container
```

### Accessing the Jupyter Notebook

1. Open a web browser and navigate to `http://localhost:8888`.
2. Enter the token shown in the terminal to access the Jupyter Notebook.
3. Open the `BlenderNotebook.ipynb` file to start using Blender in the Jupyter Notebook.


### Accessing the Blender GUI

1. Open a VNC viewer and connect to `http://localhost:5900`.
2. Enter the password `ACCESS_PW` to access the Blender GUI.
3. Start a new Blender project by selecting 'general??' from the splash screen.

## Current progress

The current setup is already working quite well. The Docker image is built successfully and the container is running with smaller issues. The Blender GUI is accessible via VNC or novnc via browser. The Jupyter Notebook is accessible via browser as well. The BlenderNotebook.ipynb file is now working. Selecting the front view in the 3d view port section was updated to support Blender 4.x version ([link](https://blender.stackexchange.com/questions/298458/why-does-bpy-ops-view3d-view-axis-not-work-in-view-3d-context)).

## To Do

- [ ] Add support for GPU acceleration.
- [ ] The configuration of the blender kernel is not working properly. We copied the kernel.json file and other files to the right location instead of using the install command. Currently the install command waits for a user input.
- [ ] The BlenderNotebook.ipynb file is copied from the original repository. It would be better to pull the file from the repository instead of duplicating it. 

