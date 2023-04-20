# FileCosmos

FileCosmos is a mobile application that allows users to drop files at specific locations for other users to pick up. The app also has a stream of file sharing, allowing users to share files with others who have the app installed.The app aims to provide a seamless and easy-to-use platform for file sharing and dropping.

## Frontend

The frontend of this app would be responsible for providing a user-friendly interface that allows users to interact with the app and view available files in their vicinity. To accomplish this, we would use the Flutter framework.

The main user interface of the app consist of a map view that displays the user's current location and nearby files that are available for download. To implement this, we have used Mapbox SDK for Flutter. Also to find the location of the current user, we are using the GPS technology to get the co-ordinates of the user as well as the file that the user is uploading. We have also used the Google OAuth2 to authenticate the user for login purpose. Using the google API will allow us to scale the app for production purposes

### Installation

To run the frontend use the following command
```bash
flutter run --dart-define \ 
    ACCESS_TOKEN=pk.eyJ1IjoiY29zbWljLWNvZGVyIiwiYSI6ImNsZnRiaXFldDA2c3gzaHBlMDY0a2t2b3gifQ.uESpMXdt9_N9U7l8I9NBhQ
```

## Backend

The backend of this app would be responsible for handling requests from the client-side of the app, retrieving data from Firebase, sending and downloading files and performing any necessary data processing before sending a response back to the client.

To ensure that our backend can handle a high volume of requests and provide a reliable service to users, we would deploy our backend using Docker. This would allow us to create a containerized version of our backend that can be easily deployed and scaled up or down as needed.

### Deloyment

To deploy the backend run the following command

```bash
docker compose up -d --build
```

If you dont have docker added as a group then try adding `sudo`.
If you dont have docker installed on your system install it using the following commands or you can visit the official <a href = "https://docs.docker.com/engine/install/ubuntu/">docker installation </a> website.

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER
```

If you want to run on your system without using docker you can run the following command
```bash
go run main.go
```
