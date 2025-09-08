AWS vs GCP vs Azure Service Comparison
Resource Hierarchy
Hierarchy Level	AWS	GCP	Azure
Root / Organization Level	AWS Organizations	Organization	Microsoft Entra ID Tenant / Root Management Group
Intermediate Grouping	Organizational Unit (OU)	Folder	Management Group
Primary Billing & Resource Boundary	AWS Account	Project	Subscription /Resource Groups
Geographic Scope	Region, Availability Zone (AZ)	Region, Zone	Region, Availability Zone (AZ)
Logical Grouping / Metadata	Tags	Labels	Tags
Individual Resource	EC2 Instance, S3 Bucket, etc.	Compute Engine Instance, Cloud Storage Bucket, etc.	Virtual Machine, Storage Account, etc.
Building blocks
Compute
Service Category	AWS	GCP	Azure
VMs	EC2 (Elastic Compute Cloud)	GCE	Virtual Machines
Containers	ECS, EKS	GKE, Cloud Run	AKS, Container Instances, App Service
Container Registry	ECR (Elastic Container Registry)	Artifact Registry	ACR
Serverless Functions	Lambda	Cloud Run functions	Azure Functions compute
Bare Metal	Bare Metal Instances	Bare Metal Solution	Azure Bare Metal Infrastructure
Storage
Service Category	AWS	GCP	Azure
Object	S3 (Simple Storage Service)	Cloud Storage	Blob Storage
Block	EBS (Elastic Block Store)	Persistent Disk	Managed Disks
File	EFS (Elastic File System), FSx	Filestore	Azure Files
Archive	S3 Glacier (various tiers)	Cloud Storage (Archive class)	Azure Archive Storage (Blob tier)
Backup	AWS Backup	Backup and DR Service	Azure Backup
Data Transfer	AWS DataSync	Transfer Appliance	Azure Data Box
Databases
Service Category	AWS	GCP	Azure
Relational	RDS (Relational Database Service), Aurora	Spanner, AlloyDB, Cloud SQL	Azure SQL Database, Azure Database for MySQL/PostgreSQL
NoSQL	DynamoDB	Firestore, Bigtable	Cosmos DB
Cache	ElastiCache	Memorystore	Azure Cache for Redis
Data Warehouse	Redshift	BigQuery	Azure Synapse Analytics
Graph	Neptune	Spanner Graph	Azure Cosmos DB (Gremlin API)
Networking
Service Category	AWS	GCP	Azure
VPC	VPC (Virtual Private Cloud)	VPC	Virtual Network (VNet)
Load Balancing	ELB (Elastic Load Balancing)	Cloud Load Balancing	Load Balancer, Application Gateway
DNS	Route 53	Cloud DNS	Azure DNS
CDN	CloudFront	Cloud CDN	Azure CDN
VPN	AWS Site-to-Site VPN	Cloud VPN	Azure VPN Gateway
Private Connectivity	AWS Direct Connect	Interconnect, VPN	Azure ExpressRoute
Developer Tools
Service Category	AWS	GCP	Azure
CI/CD	CodePipeline, CodeBuild, CodeDeploy	Cloud Build	Azure Pipelines (Part of Azure DevOps)
Code Repo	CodeCommit	Cloud Source Repositories	Azure Repos (Part of Azure DevOps)
Monitoring	CloudWatch	Cloud Monitoring	Azure Monitor
Logging	CloudWatch Logs	Cloud Logging	Azure Monitor Logs (Log Analytics)
Dev Environments	AWS Cloud9	Cloud Shell Editor, Cloud Workstations	Visual Studio Code
Security
Service Category	AWS	GCP	Azure
Identity	IAM (Identity and Access Management)	Cloud IAM	Azure AD / Microsoft Entra ID
Key Management	KMS (Key Management Service)	Cloud KMS	Key Vault
Certification Management	AWS Certificate Manager (ACM)	Certificate Authority Service	Azure Key Vault Certificates
Secret Management	AWS Secrets Manager	Secret Manager	Azure Key Vault Secrets
Zero-Trust	AWS Verified Access	BeyondCorp Enterprise	Microsoft Entra Verified ID
CSPM (Cloud Security Posture Management)	AWS Security Hub	Security Command Center	Microsoft Defender for Cloud
Firewall	Security Groups, Network ACLs, WAF	VPC Firewall Rules, Cloud Armor	Network Security Groups (NSGs), Azure Firewall, Azure WAF
DDoS Prevention	AWS Shield	Cloud Armor	Azure DDoS Protection
Big Data
Service Category	AWS	GCP	Azure
Processing	EMR (Elastic MapReduce)	Dataproc	HDInsight, Azure Databricks, Synapse Analytics Spark pools
Streaming	Kinesis	Pub/Sub, Dataflow	Event Hubs, Stream Analytics
Batch Processing	AWS Batch	Dataflow	Azure Batch
Others
Service Category	AWS	GCP	Azure
Management (Infra as Code)	CloudFormation	Infrastructure Manager	Azure Resource Manager (ARM) Templates, Bicep
Management (CLI)	AWS CLI	gcloud CLI	Azure CLI
AI / ML
AI Platforms
Service Category	AWS	GCP	Azure
AI / ML Platform	SageMaker	Vertex AI	Azure Machine Learning
Data Labeling	Ground Truth	Data Labeling Service	Azure Machine Learning Data Labeling
AI models
Model Type	AWS	GCP	Azure
Vision (Image/Video Analysis)	Amazon Rekognition (Object/Scene detection, Facial analysis, Text detection, Content moderation, Custom Labels)	Cloud Vision API (Labels, Faces, Objects, OCR, Logos, Moderation), Vertex AI Vision, AutoML Vision	Azure AI Vision (Image analysis, OCR, Spatial analysis, Face detection), Azure AI Custom Vision
Text-to-Speech (TTS)	Amazon Polly	Cloud Text-to-Speech API (Standard & WaveNet voices)	Azure AI Speech (Speech Service - TTS, Neural voices)
Speech-to-Text (STT)	Amazon Transcribe (Batch & Streaming, Custom vocabulary)	Cloud Speech-to-Text API (Batch & Streaming, Model adaptation)	Azure AI Speech (Speech Service - STT, Custom Speech)
Natural Language Processing (NLP)	Amazon Comprehend (Sentiment, Entities, Key Phrases, Language detection, Topic modeling, Custom Classification/Entities)	Cloud Natural Language API (Syntax, Entities, Sentiment, Content classification), Vertex AI NLP models	Azure AI Language (Sentiment, Key Phrases, Entities, PII, Language detection, Summarization, Custom Text Classification/NER)
Translation	Amazon Translate (Batch & Real-time, Custom terminology)	Cloud Translation API (Basic & Advanced/AutoML Translation)	Azure AI Translator (Text & Document translation, Custom Translator)
Large Language Models (LLMs) / Generative Text	Amazon Bedrock (Access to foundation models like Titan, Claude, Jurassic, Llama, Mistral), SageMaker JumpStart (Host various LLMs)	Vertex AI (Gemini models, PaLM 2, Generative AI Studio), Vertex AI Model Garden	Azure OpenAI Service (GPT-4, GPT-3.5 Turbo, Embeddings), Azure ML Model Catalog (Access to models like Llama, Mistral, Phi)
Document Analysis / OCR	Amazon Textract (Extract text, forms, tables from documents)	Document AI (Specialized parsers for invoices, receipts etc.), Cloud Vision API (OCR)	Azure AI Document Intelligence (formerly Form Recognizer - Extract text, key-value pairs, tables), Azure AI Vision (OCR)
Forecasting	Amazon Forecast (Time-series forecasting based on ML)	Vertex AI Forecast, BigQuery ML (ARIMA+ models)	Azure Machine Learning (Automated ML for Forecasting, Time Series libraries)
Personalization / Recommendations	Amazon Personalize (Real-time personalization & recommendations)	Vertex AI Matching Engine (Vector similarity search), Vertex AI Search and Conversation (includes recommendation features)	Azure AI Personalizer (Real-time decision making / reinforcement learning)
Chatbots / Conversational AI	Amazon Lex (Build conversational interfaces)	Dialogflow (CX & ES editions for building conversational agents)	Azure Bot Service, Azure AI Language (Conversational Language Understanding)
Code Generation / Assistance	Amazon CodeWhisperer	Vertex AI Codey APIs (Code generation, completion, chat - powered by Gemini/PaLM)	GitHub Copilot (Often integrated/used within Azure ecosystem)
