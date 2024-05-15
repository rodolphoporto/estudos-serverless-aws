# 1o passo criar o arquivo de politicas de segurança
# 2o criar role de segurança na AWS

aws --version

ROLE_NAME=$ROLE_NAME
NODEJS_VERSION=nodejs16.x
FUNCTION_NAME=hello-cli

aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document file://politicas.json \
    | tee logs/role.log

cat logs/role.log | jq .Role.Arn
cat logs/role.log | jq .Role.Arn | tr -d "'"
POLICY_ARN=$(cat logs/role.log | jq .Role.Arn)

# 3o criar arquivo com conteúdo da função lambda
zip function.zip index.js

aws lambda create-function \
    --function-name hello-cli \
    --zip-file fileb://function.zip \
    --handler index.handler \
    --runtime nodejs18.x \
    --role arn:aws:iam::1234567890:role/$ROLE_NAME \
    | tee logs/lambda-create.log

#4o invoke lambda!
aws lambda invoke \
    --function-name hello-cli \
    --log-type Tail \
    logs/lambda-exec.log

# -- atualizar, zipar
zip function.zip index.js

# atualizar função lambda
aws lambda update-function-code \
    --zip-file fileb://function.zip \
    --function-name hello-cli \
    --publish \
    | tee logs/lambda-update.log

# invocar novamente
aws lambda invoke \
    --function-name hello-cli \
    --log-type Tail \
    logs/lambda-exec-update.log

# remover lambda
aws lambda delete-function \
    --function-name hello-cli

# remover role
aws iam delete-role \
    --role-name $ROLE_NAME