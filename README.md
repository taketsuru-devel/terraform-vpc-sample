# 環境
amazon linux2
v0.13.0

# terraform勉強中
- VPC周りのsnippet

# できるもの
- isolatedなサブネット、セキュリティグループ

# input
- project名
- vpcのcidr
- route tableがigwに渡す宛先ipのcidr(デフォ値0.0.0.0/0)
- subnetの{az,cidr}のlist

# output
- vpcのid
- subnetのids
- security groupのid

# コマンド
- terraform init
- terraform plan
- terraform apply
- terraform destroy
