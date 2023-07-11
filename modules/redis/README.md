# Redis Module

Terraform module which create redis cluster.

## Resources

| Name | Type | 
| ------ | ------ | 
| aws_elasticache_subnet_group | resource
| terraform-aws-modules/s3-bucket/aws| module
| aws_security_group | resource
| aws_elasticache_cluster | resource
| aws_elasticache_replication_group | resource
| aws_dynamodb_table | resource

## Inputs

| Name | Description | Type
| ------ | ------ | ------ | 
| EnvName | Name of your enviorment, keep the value in lower case | Required
| Vpc_id | VPC id where you will deploy your Resources | Required
|Privatesubnets_ids| ID of your two Publicsubnets | Required
| VPCZone1 | Zone name where you will deploy your subnets | Optional
| VPCZone2 | Zone name where you will deploy your subnets | Optional
| VPCZone3 | Zone name where you will deploy your subnets | Optional
| redis-instancetype | Instance type of your Redis cache | Required
| redis-engine | Engine version of your Redis cache | Required
| rediscluster_name | Name of your RedisCluster | Optional
| redissubnetgroup | Name of your RedisSubnetGroup | Optional
| redis-sg | Name of your Redis Security Group | Optional
|redis_nodes_number | Number of node for your redis cluster | Optional 
| redis_port | Redis cluster port | Optional
| bucket_name | Name of your S3 state bucket name | Required
| dynamodb_name | Name of your dynamo db table name | Required 

## Outputs

| Name | Description | 
| ------ | ------ | 
| bucket_id | ID of the state bucket S3
| redis_cluster_id |  List of node objects including id, address, port and availability_zone.
| redis_cache_cluster_address | DNS name of the cache cluster without the port appended.
| redis_cache_configuration_endpoint |  Configuration endpoint to allow host discovery.


## Steps to Create Modules

This is the first command that should be run after cloning files from version control. The command is used to initialize a working directory containing Terraform configuration files.

```sh
terraform init
```

This command is used to rewrite Terraform configuration files to a canonical format and style.

```sh
terraform fmt --check
```

Validate runs checks that verify whether a configuration is syntactically valid and internally consistent, regardless of any provided variables or existing state.

```sh
terraform validate
```

This command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.

```sh
terraform plan
```

Finally this command executes the actions proposed in a Terraform plan.

```sh
terraform apply
```

And a convenient way to destroy all remote objects managed by a particular Terraform configuration.

```sh
terraform destroy
```
