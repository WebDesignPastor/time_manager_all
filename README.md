
# Gotham Time Manager
## Table of Contents

- [Overview](#overview)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
	- [Local Installation](#local-installation)
	- [Docker Installation](#docker-installation)
- [Configuration](#configuration)
	- [Front End Env](#front-end-env)
	- [Back End Env](#back-end-env)
- [Api Documentation](#api-documentation)
- [Https config](#get-https-enable-https-on-aws-ec2-with-a-domain-name)
- [Contributing](#contributing)

## Overview

Rumors of strikes and resignations run, and the main union (CGT-U, which stands for City of Gotham Trade-Union) alerts the mayor and senior officials of the town hall of the urgency of the situation. To calm the tensions, the town hall decides to make a state of play of the situation, and why not, to allow the municipal workers to have access to some days off to recuperate. For this, management application has been developed.

## Technologies Used

- [Elixir](https://elixir-lang.org/) - Programming language used for the backend.
- [Phoenix Framework](https://www.phoenixframework.org/) - Web framework used with Elixir.
- [Vue.js](https://vuejs.org/) - JavaScript framework used for the frontend.
- [Vite](https://vitejs.dev/) - Build tool for frontend development.
- [PostgreSQL](https://www.postgresql.org/) - Database management system.

## Installation
### Local installation
To install the project locally follow these steps:

```bash
# Example installation for the backend
cd time_manager
mix deps.get
mix ecto.create
mix ecto.migrate
mix phx.server

# Example installation for the frontend
cd time_manager_app
npm install
npm run dev
```

### Docker Installation

To install the project using Docker, follow these steps:

1. Make sure you have [Docker](https://www.docker.com/)

2. Clone the repository:

   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd time_manager_all
   ````
 3. Run the docker compose command
	 ````bash
	 docker compose up --build
	 ````

<details>
<summary>Troubleshoot</summary>

## Issue: Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?

### Solution 1 - CLI

Start the Docker Daemon service using the following command:

```bash
sudo service docker start
# or
sudo systemctl start docker
  ```

### Solution 2 - Desktop

Start Docker Desktop.

## Issue: Port problem: Error starting userland proxy: listen tcp4 0.0.0.0:5432: bind: address already in use

### Solution

Check the availability of the port:
```bash
sudo lsof -i :5432
  ```
If the port is taken, it's probably by Postgres, stop it

```bash
sudo kill -9 <PID>
```
</details>

## Configuration
### Front End Env
For the frontend, configure your environment by creating or editing a `.env` file in the `time_manager_app/` directory with the following content:
````bash
# Example Frontend .env file
VITE_BASE_API_URL=YOUR_BACK_END_URL
````


### Back End Env
For the backend, configure your environment by creating or editing a `.env` file in the root directory with the following content:
````bash
# Example Frontend .env file
PGUSER=YOUR_PG_USERNAME
PGPASSWORD=YOUR_PG_PASSWORD
PGDATABASE=YOUR_DATABASE_NAME
PGHOST=YOUR_PG_HOST
PGPORT=YOUR_PG_PORT
````

## Api Documentation
To view the API documentation follow thes steps:

1. Copy the yaml on [Pastebin](https://pastebin.com/t6L0V38S)

2. Paste it in [swagger editor](https://editor.swagger.io/)


## Get HTTPS Enable HTTPS on AWS EC2 with a Domain Name
### Prerequisites

- A domain name registered with a domain registrar.
- An EC2 instance running under Amazon Linux 2.
- A security group for the EC2 instance that allows incoming HTTPS connections (port 443).

### Configuration Security group

  - From the AWS console, create a new security group.
  - Associate this security group with the EC2 instance.
  - Add a rule to allow incoming HTTPS traffic:
    - Traffic type: HTTPS
    - Port range: 443

### Point the Domain Name to the AWS EC2 Instance

- Connect to the domain registrar's management console.
- Select the domain name.
- In the DNS or Name Servers section, update the records to point to the DNS addresses

### Install and configure SSL Certificate

- Connexion to EC2 instance
- Generate CSR and Private Key, use OpenSSL to create a private key and a certificate signing request (CSR):


```bash
openssl req -new -newkey rsa:2048 -nodes -keyout nom_domaine.key -out nom_domaine.csr
```
- Submit the CSR to a certification authority to obtain an SSL certificate.
- Place the SSL certificate (.crt) and the private key (.key) on the EC2 instance and configure the web server to use the SSL certificate and the private key.

## Contributing
- [dhalley](https://github.com/dhall3y)
- [Baptiste Lemonnier](https://github.com/Baptill)
- [Chasmyr](https://github.com/Chasmyr)
- [Evans Hulot](https://github.com/EvansHulot)
