aws ec2 describe-instances \
--query 'Reservations[*].Instances[*].PublicIpAddress' \
--filters "Name=tag:Name,Values=Server101" \
--output text
