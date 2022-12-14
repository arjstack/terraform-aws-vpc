variable "create_vpc" {
    description = "(Optional, default false) Flag to decide if a new VPC should be created"
    type = bool
    default = true
}

variable "vpc_id" {
    description = "(Optional) The ID of the VPC [Required only whern create_vpc is set false]"
    type = string
    default = ""
}

variable "vpc_name" {
    description = "(Optional) The name of the VPC"
    type = string
}

variable "ipv4_cidr_block" {
    description = "(Optional) The IPv4 CIDR block for the VPC."
    type = string
    default = "0.0.0.0/0"
}

variable "enable_ipv6" {
    description = "(Optional) Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC."
    type = bool
    default = false
}

variable "ipv6_cidr_block" {
    description = "(Optional) IPv6 CIDR block to request from an IPAM Pool."
    type = string
    default = null
}

variable "vpc_base_configs" {
    description = <<EOF
(Optional) Basic configuration Map for VPC with the following entries:

instance_tenancy - (Optional) A tenancy option for instances launched into the VPC; Defaule value - "default"
enable_dhcp_options - (Optional) Set it to true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type; Default value - false
ipv6_cidr_block_network_border_group - (Optional) By default when an IPv6 CIDR is assigned to a VPC a default ipv6_cidr_block_network_border_group will be set to the region of the VPC. 
EOF
    type = map
    default = {}
}

variable "vpc_ipam_configs" {
    description = <<EOF
(Optional) Configuration Map for IPv4 with the following entries:

Note - 
Either set the value of property [ipv4_cidr_block] to explicitely set CIDR block for VPC  
or Set the ipam specific properties [ipam_pool_id and netmask_length] for deriving CIDR from IPAM 

use_ipv4_ipam_pool - (Optional) Set flag true if use ipam pool for IPv4 CIDRs; Default value - false
ipv4_ipam_pool_id - (Optional) The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR.
ipv4_netmask_length - (Optional) The netmask length of the IPv4 CIDR you want to allocate to this VPC.

Note: 
Follwoing properties are only required when enable_ipv6 is set true
use_ipv6_ipam_pool - (Optional) Set flag true if use ipam pool for IPv6 CIDRs; Default value - false
ipv6_ipam_pool_id - IPAM Pool ID for a IPv6 pool.
ipv6_netmask_length - (Optional) Netmask length to request from IPAM Pool.

EOF
    type = map
    default = {}
}

variable "vpc_dns_configs" {
    description = <<EOF
(Optional) Configuration Map for DNS Support with the following entries:

enable_dns_support - (Optional) A boolean flag to enable/disable DNS support in the VPC.
vpc_dns_host_name - (Optional) A boolean flag to enable/disable DNS hostnames in the VPC.
EOF
    type        = map
    default = {
        enable_dns_support = true
        dns_host_name = false
    }
}

variable "vpc_classiclink_configs" {
    description = <<EOF
(Optional) Configuration Map for CLassic Link with the following entries:

enable_classiclink - (Optional) A boolean flag to enable/disable ClassicLink for the VPC.
enable_classiclink_dns_support - (Optional) A boolean flag to enable/disable ClassicLink DNS Support for the VPC.
EOF
    type        = map
    default = {
        enable_classiclink              = false
        enable_classiclink_dns_support  = false
    }
}

variable "vpc_secondary_cidr_blocks" {
  description = <<EOF
Map of Secondary CIDR blocks configurations where 
Map Key - Any unique identifire
Map Value - It will again be a map of CIDR configurations witht the following properties:

cidr_block - (Optional) The IPv4 CIDR block for the VPC.
ipam_pool_id - (Optional) The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR.
netmask_length - (Optional) The netmask length of the IPv4 CIDR you want to allocate to this VPC.

Sample
"CIDR-1" = {
    cidr_block - "x.x.x.x/xx"
},
"CIDR-2 = {
    ipam_pool_id - "ipam-xxxx"
    netmask_length - 28
}
EOF
  type        = map
  default     = {}

}

####################################
## DHCP Options Specific Variables 
####################################
variable "dhcp_options_domain_name" {
    description = <<EOF
(Optional) the suffix domain name to use by default when resolving non Fully Qualified Domain Names.
This will require enable_dhcp_options set to true
EOF
  type        = string
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = <<EOF
(Optional) List of name servers to configure in /etc/resolv.conf.
This will require enable_dhcp_options set to true
EOF
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = <<EOF
(Optional) List of NTP servers to configure.
This will require enable_dhcp_options set to true
EOF
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = <<EOF
(Optional) List of NETBIOS name servers.
This will require enable_dhcp_options set to true
EOF
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = <<EOF
(Optional) The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 
since broadcast and multicast are not supported in their network.
This will require enable_dhcp_options set to true
EOF
  type        = string
  default     = ""
}

#########################################
## Route Tables
#########################################

variable "default_route_table_propagating_vgws" {
  description = "List of virtual gateways for propagation"
  type        = list(string)
  default     = []
}

variable "default_route_table_routes" {
  description = <<EOF
List of Routes where each value of the list will be a map with the following Keys:

route_key - This must be a uniue identifiier of this list of map

# One of the following key is mandatory
cidr_block - (Required) The CIDR block of the route.
ipv6_cidr_block - (Optional) The Ipv6 CIDR block of the route

One of the following keys is mandatory
core_network_arn - (Optional) The Amazon Resource Name (ARN) of a core network.
egress_only_gateway_id - (Optional) Identifier of a VPC Egress Only Internet Gateway.
gateway_id - (Optional) Identifier of a VPC internet gateway or a virtual private gateway.
instance_id - (Optional) Identifier of an EC2 instance.
nat_gateway_id - (Optional) Identifier of a VPC NAT gateway.
network_interface_id - (Optional) Identifier of an EC2 network interface.
transit_gateway_id - (Optional) Identifier of an EC2 Transit Gateway.
vpc_endpoint_id - (Optional) Identifier of a VPC Endpoint.
vpc_peering_connection_id - (Optional) Identifier of a VPC peering connection.

Sample: 
[
  {
    route_key="rt-1"
    cidr_block = "x.x.x.x/xx"
    instance_id = "i-xxxxxx"
  },
  {
    route_key="rt-2"
    cidr_block = "y.y.y.y/yy"
    network_interface_id = "nic-xxxxx"
  }
]
EOF
  type        = list(map(string))
  default     = []
}

#########################################
## Network ACLs
#########################################

variable "dedicated_network_acl" {
  description = "Set true if dedicated network ACL is required for subnets"
  type        = bool
  default     = false
}

variable "nacl_rules" {
    description = <<EOF
Configuration Map of Rules of 2 different rule types for Dedicated Network ACL where
Map key - Rule Type [There could be 2 Rule Types : `inbound`, `outbound`]<br>
Map Value - An array of Rule Maps

Note - One of `cidr_block` and `ipv6_cidr_block` is mandatory
EOF
    default = {
      "inbound" = [
        {
          rule_number = 100
          rule_action = "allow"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_block  = "0.0.0.0/0"
        },
      ],
      "outbound" = [
        {
          rule_number = 100
          rule_action = "allow"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_block  = "0.0.0.0/0"
        },
      ]
    }
}

variable "default_network_acl" {
  description = <<EOF
Configuration Map of Rules of 2 different rule types for Default Network ACL where
Map key - Rule Type [There could be 2 Rule Types : `inbound`, `outbound`]<br>
Map Value - An array of Rule Maps

Note - One of `cidr_block` and `ipv6_cidr_block` is mandatory
EOF
  type        = map

  default = {
    "inbound" =  [
      {
        rule_no    = 100
        action     = "allow"
        from_port  = 0
        to_port    = 0
        protocol   = "-1"
        cidr_block = "0.0.0.0/0"
      },
      {
        rule_no         = 101
        action          = "allow"
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        ipv6_cidr_block = "::/0"
      },
    ],
    "outbound" = [
      {
        rule_no    = 100
        action     = "allow"
        from_port  = 0
        to_port    = 0
        protocol   = "-1"
        cidr_block = "0.0.0.0/0"
      },
      {
        rule_no         = 101
        action          = "allow"
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        ipv6_cidr_block = "::/0"
      },
    ]
  }
}

#########################################
## Default Security Group Specific Rules
#########################################
variable "default_sg_rules" {
    description = <<EOF
(Optional) Configuration List for Security Group Rules of Default Security Group:
It is a map of Rule Pairs where,
Key of the map is Rule Type and Value of the map would be an array of Security Rules Map 
There could be 3 Rule Types [Keys] : 'ingress-cidr', 'ingress-self', 'egress'

Sample:

ingress-cidr = [
    {
        rule_name = "<Name of the rule>"
        from_port = <Value of from Port>
        to_port = <Value of to Port>
        protocol = "<Protocol>"
        cidr_blocks = ["<CIDR Block>"] 
    }
],
ingress-self = [
    {
        rule_name = "<Name of the rule>"
        from_port = <Value of from Port>
        to_port = <Value of to Port>
        protocol = "<Protocol>"
    }
],
egress = [
    {
        rule_name = "<Name of the rule>"
        from_port = <Value of from Port>
        to_port = <Value of to Port>
        protocol = "<Protocol>"
        cidr_blocks = ["<CIDR Block>"] 
    }
]

EOF
    default = []
}

####################################################
## Internet Gateway and Egress Only Internet Gateway
####################################################
variable "create_igw" {
    description = "(Optional) Flag to set whether to create internet gateway"
    type = bool
    default = true
}

variable "create_egress_only_igw" {
    description = "(Optional) Flag to set whether to create Egress only internet gateway"
    type = bool
    default = false
}

############################################################################################
## Setting for Routes to Internet Gateway and Egress Only Internet Gateway in ROute Tables
############################################################################################
variable "create_igw_ipv4_route" {
    description = <<EOF
Flag to set if routes to IGW needs to be created in the dedicated route table 
for the subnets; Elligible only for Public Subnets
EOF
    type = bool
    default = true
}

variable "create_igw_ipv6_route" {
    description = <<EOF
Flag to set if routes to Egress IGW needs to be created in the dedicated route table 
for the subnets; Elligible only for Public Subnets
EOF
    type = bool
    default = false
}

variable "egress_igw_id" {
    description = "ID of the Egress Internet Gateway"
    type = string
    default = ""
}

variable "create_nat_gateway_route" {
    description = <<EOF
Flag to set if routes to NAT Gateway needs to be created in the dedicated route table 
for the subnets; Elligible only for Private Subnets
EOF
    type = bool
    default = false
}

variable "nat_gateway_id" {
    description = "ID of the NAT Gateway"
    type = string
    default = ""
}
####################################################
## Subnets
####################################################
variable "subnets_type" {
    description = "The value that can show the purpose of the subnet like 'infra', 'web', 'rds' etc..."
    type        = string
    default     = "private"
}

variable "subnets" {
    description = <<EOF
(Optional) The List of Subnets to be provisioned where each entry is a map with following Key-Pairs:

1. subnet_core_configs: (Required) This is again a Map of the Core settings for the subnet with the following keys:

1.1. name - (Required) The name of the subnet
1.2. availability_zone - (Optional) AZ for the subnet.

2. subnet_ip_configs: (Optional) This is again a Map of the IPv4/IPv6 settings for the subnet with the following keys:

2.1. cidr_block - (Optional) The IPv4 CIDR block for the subnet.
2.2. assign_ipv6_address_on_creation - (Optional) Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address.
2.3. ipv6_cidr_block - (Optional) The IPv6 network range for the subnet, in CIDR notation.
2.4. ipv6_native - (Optional) Indicates whether to create an IPv6-only subnet.
2.5. map_public_ip_on_launch - (Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address.


3. subnet_customer_owned_ip_configs: (Optional) This is again a Map of the Customer Owned IP settings for the subnet with the following keys:

3.1. map_customer_owned_ip_on_launch - (Optional) Specify true to indicate that network interfaces created in the subnet should be assigned a customer owned IP address.
3.2. customer_owned_ipv4_pool - (Optional) The customer owned IPv4 address pool.
3.3. vpc_dns_host_name - (Optional) The Amazon Resource Name (ARN) of the Outpost.

4. subnet_dns_configs: (Optional) This is again a Map of the DNS settings for the subnet with the following keys:

4.1. enable_dns64 - (Optional) Indicates whether DNS queries made to the Amazon-provided DNS Resolver 
                       in this subnet should return synthetic IPv6 addresses for IPv4-only destinations.
4.2. enable_resource_name_dns_a_record_on_launch - (Optional) Indicates whether to respond to DNS queries for instance hostnames with DNS A records.
4.3. enable_resource_name_dns_aaaa_record_on_launch - (Optional) Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records.

4.4. private_dns_hostname_type_on_launch - (Optional) The type of hostnames to assign to instances in the subnet at launch.

5. subnet_tags: (Optional) A map of tags to assign to the resource.

EOF
    default = []
}

variable "dedicated_route_table" {
  description = "Set false if do not need a dedicated route table for the subnets"
  type        = bool
  default     = true
}


## NAT Gateways
variable "nat_gateways" {
    description = <<EOF
The configuration map of Nat Gateways
Map Key - Unique identifier for Nat Gateway Name
Map Value - Subnet Name in which Nat Gatway will be created
EOF
    type = map
    default = {}
}

## Tags

variable "default_tags" {
    description = "(Optional) A map of tags to assign to all the resource."
    type = map
    default = {}
}

variable "vpc_tags" {
    description = "(Optional) A map of tags to assign to the VPC."
    type = map
    default = {}
}

variable "igw_tags" {
    description = "(Optional) A map of tags to assign to IGW."
    type = map
    default = {}
}

variable "rt_default_tags" {
    description = "(Optional) A map of tags to assign to the route Tables."
    type = map
    default = {}
}

variable "subnet_default_tags" {
    description = "(Optional) A map of tags to assign to all the subnets."
    type = map
    default = {}
}

variable "network_acl_default_tags" {
    description = "(Optional) A map of tags to assign to all the Network ACLs."
    type = map
    default = {}
}

variable "nat_gateway_tags" {
    description = "(Optional) A map of tags to assign to all the NAT Gateways."
    type = map
    default = {}
}
