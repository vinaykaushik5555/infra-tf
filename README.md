# Terraform AWS EKS Deployment with Jenkins

This repository contains Terraform scripts to deploy and manage an **Amazon EKS cluster** using **Jenkins** as the CI/CD pipeline. It provisions an EKS cluster with a maximum of **2 worker nodes** (`t3.medium`) and allows for **automated deletion**.

## **Project Structure**

```
infra-tf/
│── terraform/
│   ├── provider.tf         # AWS Provider Configuration
│   ├── variables.tf        # Terraform Variables
│   ├── eks.tf              # EKS Cluster Definition
│   ├── node_group.tf       # Worker Nodes Configuration
│   ├── outputs.tf          # Terraform Outputs
│   ├── terraform.tfvars    # Variables File
│── Jenkinsfile             # Jenkins Pipeline Configuration
│── README.md               # Documentation
```

---

## **Prerequisites**

Ensure you have the following installed on the Jenkins server:

- **Terraform** (`>=1.0`)
- **AWS CLI** (`aws --version`)
- **kubectl** (`kubectl version --client`)
- **Jenkins with Terraform Plugin**
- **IAM Role for Jenkins** (With `AmazonEKSClusterPolicy` and `AmazonEC2ContainerRegistryReadOnly`)

### **Verify Installations**

```bash
aws --version
terraform --version
kubectl version --client
```

---

## **How to Use**

### **Step 1: Configure AWS Credentials**

On the **Jenkins Server**, make sure AWS CLI is configured:

```bash
aws configure
```

Provide:

- **AWS Access Key**
- **AWS Secret Key**
- **Region** (e.g., `us-east-1`)

---

### **Step 2: Jenkins Job Setup**

1. **Go to Jenkins Dashboard → New Item → Pipeline**
2. **Enter Job Name** → `eks-terraform-deploy`
3. **Select Pipeline** and Click **OK**
4. Under **Pipeline**, select **Pipeline Script from SCM**
    - **SCM:** Git
    - **Repository URL:** `https://github.com/vinaykaushik5555/infra-tf.git`
    - **Branch:** `main`
    - **Script Path:** `Jenkinsfile`
5. **Save and Build** the Job.

---

### **Step 3: Deploy EKS Cluster**

- Run the **Jenkins job** without selecting "Destroy Infrastructure."
- Verify the deployment using:
  ```bash
  aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster
  kubectl get nodes
  ```

---

### **Step 4: Destroy the EKS Cluster**

To delete the EKS cluster:

- **Go to Jenkins**
- **Trigger a new build**, but select **"Destroy Infrastructure"** checkbox.

Alternatively, manually run:

```bash
terraform destroy -auto-approve
```

---

## **Terraform Variables**

You can modify these variables in **`terraform/terraform.tfvars`**.

| Variable             | Description      | Default Value    |
| -------------------- | ---------------- | ---------------- |
| `region`             | AWS Region       | `us-east-1`      |
| `cluster_name`       | EKS Cluster Name | `my-eks-cluster` |
| `node_instance_type` | Worker Node Type | `t3.medium`      |
| `min_size`           | Min Nodes        | `1`              |
| `max_size`           | Max Nodes        | `2`              |

---

## **Jenkins Pipeline Stages**

| Stage                 | Description                                       |
| --------------------- | ------------------------------------------------- |
| **Checkout**          | Clones the repository from GitHub                 |
| **Terraform Init**    | Initializes Terraform                             |
| **Terraform Plan**    | Generates an execution plan                       |
| **Terraform Apply**   | Deploys the EKS cluster                           |
| **Configure kubectl** | Configures kubectl for EKS                        |
| **Destroy EKS**       | Deletes the EKS cluster (if `DESTROY_INFRA=true`) |

---

## **Useful Commands**

### **Connect to EKS Cluster**

```bash
aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster
kubectl get nodes
```

### **List Terraform State**

```bash
terraform state list
```

### **Manually Destroy EKS Cluster**

```bash
terraform destroy -auto-approve
```

---

## **Conclusion**

This setup automates the deployment and management of **AWS EKS clusters** using **Terraform and Jenkins**. It supports **scalable worker nodes (Max: 2 nodes)** and includes an **automated cleanup process**.

🚀 **Happy Coding!** 🚀
