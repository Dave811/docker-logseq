# Docker Logseq

A Docker container that runs the full-featured Logseq desktop application in a web browser, providing access to all desktop features including plugins and HTTP API functionality.

## Why This Container Exists

While Logseq offers a web application, its functionality is highly limited compared to the desktop version. The web app doesn't support plugins and, more importantly, doesn't expose an HTTP API server that can be used for automation and integrations.

This Docker container solves these limitations by running the complete Logseq desktop application in a containerized environment, accessible through your web browser. This gives you:

- **Full plugin support** - Use all available Logseq plugins
- **HTTP API access** - Integrate Logseq with other tools and workflows
- **Desktop feature parity** - Access all features available in the desktop version
- **Remote accessibility** - Run Logseq on any headless server (AWS, Azure, self-hosted, NAS devices, etc.)

## How It Works

This container uses **KasmVNC** technology to stream the desktop Logseq application to your web browser:

1. **Base Infrastructure**: Built on [LinuxServer's KasmVNC base image](https://github.com/linuxserver/docker-baseimage-kasmvnc), which provides a web-accessible VNC server
2. **Desktop Application**: Downloads and installs the official Logseq desktop application (AppImage for x86_64, ZIP package for ARM64)
3. **Web Streaming**: KasmVNC streams the desktop application interface directly to your browser - no additional VNC client needed
4. **Full Functionality**: Since it's the actual desktop application running in a Linux environment, all features work exactly as they would on your local machine

The result is seamless access to the complete Logseq desktop experience through any modern web browser, while maintaining full compatibility with plugins and API functionality.

## Supported Architectures

This container supports multiple architectures and will automatically detect your system:

- **x86_64** (Intel/AMD 64-bit) - Uses Logseq AppImage
- **ARM64/aarch64** (Apple Silicon, ARM servers, ARM-based NAS) - Uses Logseq ZIP package

## Installation & Usage

### Quick Start

#### Option 1: Using Named Volumes (Recommended for new setups)

```bash
docker run -d \
  --privileged \
  -p 3000:3000 \
  -p 12315:12315 \
  -v config:/config \
  -v notes:/notes \
  --name logseq \
  nulinspiratie/docker-logseq:latest
```

#### Option 2: Using Existing Directories

```bash
docker run -d \
  --privileged \
  -p 3000:3000 \
  -p 12315:12315 \
  -v /path/to/your/existing/config:/config \
  -v /path/to/your/existing/notes:/notes \
  --name logseq \
  nulinspiratie/docker-logseq:latest
```

Replace `/path/to/your/existing/config` and `/path/to/your/existing/notes` with the actual paths to your existing Logseq configuration and notes directories.

After running the container, access Logseq at `http://localhost:3000`

### Volume Configuration

The container uses two main volumes for data persistence:

- `/config` - Logseq configuration and settings
- `/notes` - Your Logseq notes and data

#### Using Docker Named Volumes (Recommended for new setups)

Docker will create and manage these volumes automatically:

```bash
-v config:/config \
-v notes:/notes \
```

#### Using Existing Directories (Bind Mounts)

To use existing config files or notes folders from your host system, use absolute paths:

```bash
# Use existing directories
-v /path/to/your/existing/config:/config \
-v /path/to/your/existing/notes:/notes \

# Example with real paths
-v /home/user/.logseq:/config \
-v /home/user/Documents/LogseqNotes:/notes \
```

**Important Notes:**

- Use absolute paths (starting with `/`) for bind mounts
- Ensure the directories exist on your host system before running the container
- The container runs as a specific user, so make sure the directories are readable/writable
- On Linux/macOS, you may need to adjust permissions: `chmod -R 755 /path/to/your/directories`

### Port Configuration

- `3000` - Web interface for accessing Logseq
- `12315` - HTTP API server

### For NAS Users

Most NAS systems (Synology, QNAP, etc.) support Docker containers:

1. Open your NAS Docker interface
2. Search for `nulinspiratie/docker-logseq`
3. Set up the volumes:
   - **For new setups**: Use named volumes (`config` and `notes`)
   - **For existing data**: Map to existing folders on your NAS
   - `/config` → your preferred config folder (e.g., `/volume1/docker/logseq/config`)
   - `/notes` → your Logseq notes folder (e.g., `/volume1/LogseqNotes`)
4. Map ports `3000` and `12315`
5. Enable privileged mode
6. Access Logseq at `http://your-nas-ip:3000`

## Docker Compose Files

This project includes pre-configured docker-compose files for different deployment scenarios:

- **`docker-compose.dev.yml`** - For development and testing environments
  - Builds the container from the local `dockerfile`
  - Uses bind mounts for live configuration editing

- **`docker-compose.yml`** - For production deployments
  - Uses the published image `nulinspiratie/docker-logseq:latest`
  - Uses named Docker volumes for data persistence

See the docker-compose files in this repository for detailed configuration examples and usage instructions.

## Development

### Setting Up Development Environment

To contribute or modify this project:

```bash
# Clone the repository
git clone https://github.com/nulinspiratie/docker-logseq.git
cd docker-logseq

# Build the Docker image
docker build -t logseq-dev .
```

### Running Your Development Build

```bash
docker run -d \
  --privileged \
  -p 3000:3000 \
  -p 12315:12315 \
  -v config:/config \
  -v notes:/notes \
  --name logseq-dev \
  logseq-dev
```

### Development Workflow

1. Make changes to the dockerfile or configuration
2. Rebuild the image: `docker build -t logseq-dev .`
3. Stop and remove the old container: `docker stop logseq-dev && docker rm logseq-dev`
4. Run the updated image using the command above

### Publishing Updates

The image is automatically built and published when you push to the main branch. To create a new versioned release:

```bash
git tag v0.10.13
git push origin v0.10.13
```

This will trigger automated builds for both version-tagged and `latest` images.

## Steps to enable HTTP API

1. Navigate to Logseq URL (e.g. `localhost:3000`)
2. Press three dots (`...`) on the topright -> `Settings`
3. Go to `Advanced` -> Enable `Developer Mode`
4. Go to `Features` -> Enable `HTTP APIs Server` -> Press `Restart App`
5. Once app is restarted, press `API` in topright
6. Go to `Server Configuration` -> Set `Host` to `0.0.0.0`
7. Again press `API` -> `Start Server`
8. Verify that API url is working (e.g. `localhost:12315`)
9. Add a bearer token (and also add to any apps that require it)

## Credits

This project is based on the original work by [@CorrectRoadH](https://github.com/CorrectRoadH/docker-logseq). Thank you for the initial implementation!
