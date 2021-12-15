echo "🔑 Adding ssh key..." &&
eval $(ssh-agent -s) &&
ssh-add <(echo "${INPUT_KEY}") && 
echo "🔐 Added ssh key";

PRE_UPLOAD=${INPUT_PRE_UPLOAD}
if [ ! -z "$PRE_UPLOAD" ]; then
    { 
        echo "👌 Ejecutando script pre-subida..." &&
        ssh ${INPUT_SSH_OPTIONS} -p "${INPUT_PORT}" ${INPUT_USER}@${INPUT_HOST} "$INPUT_PRE_UPLOAD && exit" &&
        echo "✅ Script pre-subida ejecutado"
    } || {
        echo "😢 Algo falló durante la ejecución del script de pre-subida" &&
        echo ssh ${INPUT_SSH_OPTIONS} -p "${INPUT_PORT}" ${INPUT_USER}@${INPUT_HOST} "$INPUT_PRE_UPLOAD" &&
        exit 1
    }
fi

{
    echo "🚚 Copiando archivos por scp..." &&
    ls -la &&
    pwd &&
    cat docker/complete-app-dockerization/docker-compose.yml &&
    scp ${INPUT_SSH_OPTIONS} ${INPUT_SCP_OPTIONS} -P "${INPUT_PORT}" -r ${INPUT_LOCAL} ${INPUT_USER}@${INPUT_HOST}:"${INPUT_REMOTE}" && 
    echo "🙌 Ficheros copiados por scp"
} || {
    echo "😢 Algo falló durante la subida" && exit 1
}

POST_UPLOAD=${INPUT_POST_UPLOAD}
if [ ! -z "$POST_UPLOAD" ]; then
    {
        echo "👌 Ejecutando script post-subida..." &&
        ssh ${INPUT_SSH_OPTIONS} -p "${INPUT_PORT}" ${INPUT_USER}@${INPUT_HOST} "$POST_UPLOAD && exit" &&
        echo "✅ Script post-subida ejecutado"
    } || {
        echo "😢 Algo falló durante la ejecución del script de post-subida" &&
        echo ssh ${INPUT_SSH_OPTIONS} -p "${INPUT_PORT}" ${INPUT_USER}@${INPUT_HOST} "$POST_UPLOAD && exit" &&
        exit 1
    }
fi

echo "🎉 Done";