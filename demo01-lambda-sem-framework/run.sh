# 1o passo criar o arquivo de politicas de segurança
# 2o criar role de segurança na AWS

aws iam create-role \
    --role-name lambda-exemplo \
    --assume-role-policy-document file://politicas.json \
    | tee logs/role.log

# 3o criar arquivo com conteúdo da função lambda
zip function.zip index.js

aws lambda create-function \
    --function-name hello-cli \
    --zip-file fileb://function.zip \
    --handler index.handler \
    --runtime nodejs18.x \
    --role arn:aws:iam::1234567890:role/lambda-exemplo \
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
    --role-name lambda-exemplo