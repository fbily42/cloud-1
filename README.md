# Cloud-1

**Cloud-1** is a pedagogical project developed at **42 Paris**, showcasing a complete end-to-end deployment of a multi-service web application using modern cloud and automation technologies. This project demonstrates an **Infrastructure-as-Code** approach leveraging **AWS**, **Terraform**, **Ansible**, and **Docker**, secured behind an **Nginx** reverse proxy with dynamic domain configuration via **DuckDNS**.

---

## Project Overview

The project provisions an EC2 instance on **AWS**, running a full **WordPress** stack, a **MariaDB** database, and a **phpMyAdmin** interface. Each component runs in its own isolated container following the *1 process = 1 container* principle. The infrastructure is fully automated with **Terraform**, configured with **Ansible**, and orchestrated using **Docker Compose**.

Public access is strictly controlled with AWS **Security Groups**, ensuring that the database is never directly exposed to the Internet. Traffic is secured with **HTTPS** using Nginx as a reverse proxy, routing requests to the correct service depending on the requested URL. **DuckDNS** is integrated to maintain a dynamic domain pointing to the instance’s public IP.

---

## Usage

To get this project up and running after cloning the repository, follow these essential steps.

### Prerequisites

**1. AWS Account & IAM User**  
   You need an AWS account and an IAM user with sufficient permissions to manage EC2, VPC, Security Groups, and Key Pairs. Keep your **AWS Access Key ID** and **Secret Access Key** ready.

**2. DuckDNS Account**  
   A DuckDNS token is required to register and maintain a dynamic DNS domain. You can get one for free at [DuckDNS.org](https://www.duckdns.org/).

**3. Python ≥ 3.8**  
   Make sure you have **Python 3.8 or higher** installed on your local machine to use the `venv` module and manage Ansible & Terraform.  
   Check your version with:
   ```bash
   python3 --version
   ```

**4. Environment Variables**  
   All sensitive keys and tokens are managed in a `.env` file (a template is provided).

---

### Configuration

**1. Clone the repository**

   ```bash
   git clone https://github.com/fbily42/cloud1.git
   cd cloud1
   ```
**2. Create your `.env` file**

Copy the example file and add your credentials:

```bash
cp .env.example .env
```

Then edit .env with your values:

```env
AWS_ACCESS_KEY_ID=YourAWSAccessKeyID
AWS_SECRET_ACCESS_KEY=YourAWSSecretKey
AWS_DEFAULT_REGION=YourAWSRegion

DUCKDNS_TOKEN=YourDuckDNSToken
DUCKDNS_DOMAIN=your-subdomain
```

**3. Configure your `terraform.tfvars`**

Edit the terraform/terraform.tfvars file to set the absolute or relative path to your public SSH key:

```env
public_key_path = "/home/your_user/.ssh/id_rsa.pub"
```
This key will be used to connect to your AWS EC2 instance via SSH.

---

### Running the Project
The project comes with two main scripts to fully automate the deployment.

**1. Set up the Python virtual environment**

This script:

- Creates a dedicated Python virtual environment (venv)

- Installs Terraform and Ansible locally

- Exports your AWS credentials automatically on activation

```bash
./scripts/setup_venv.sh
source ~/.cloud1/bin/activate
```
**2. Deploy the infrastructure**

This script:

- Runs terraform init and apply to create the AWS EC2 instance and networking

- Updates your DuckDNS domain with the new public IP

- Generates the Ansible inventory

- Runs the Ansible playbook to install Docker, Nginx, WordPress, phpMyAdmin, and launch the Docker Compose stack

```bash
./scripts/deploy.sh
```

### Access Your Services
- WordPress: ```https://<your-duckdns>.duckdns.org```

- phpMyAdmin: ```https://<your-duckdns>.duckdns.org/pma```

All connections are secured through HTTPS handled by Nginx. The MariaDB database is only accessible internally.

### Cleaning Up

After you are done testing or deploying, you can clean up all resources and your local setup with the provided scripts.

**1. Destroy the AWS infrastructure**

Use the `clean.sh` script to:

- Destroy all AWS resources created by Terraform
- Remove any generated Terraform state files locally

```bash
./scripts/clean.sh
```

**1. Remove the Python virtual environment**

Use the delete_venv.sh script to:

- Delete the virtual environment created for this project

```bash
deactivate
./scripts/delete_venv.sh
```

---

## Conclusion

This project demonstrates a full Infrastructure-as-Code deployment workflow using **AWS**, **Terraform**, **Ansible**, and **Docker**, orchestrated to run a secure, multi-service WordPress stack.  
By following these steps, you can deploy, manage, and tear down your infrastructure reliably, with data persistence and HTTPS security handled by **Nginx**.

> **Cloud-1** was developed as part of the [42 Paris](https://42.fr) curriculum. 
