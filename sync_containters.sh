#!/bin/bash
# Create two way sync between eu and us InstantFiles containers

# change container name, synckey, account
container='public'
synckey='yoursynckeyhere'

account="1000000"
tenant=$account

# Get auth tokens and endpoints
# EU
serv=`curl -s http://serviceapi.eu01.webzilla.com/accounts/${account}/users/${tenant}/token`
ENDPEU=`echo ${serv} |  jq --raw-output '.serviceCatalog[0].endpoints[0].publicURL'`
TOKEU=`echo ${serv} |  jq --raw-output '.token.value'`
# US
serv=`curl -s http://serviceapi.us01.webzilla.com/accounts/${account}/users/${tenant}/token`
ENDPUS=`echo ${serv} |  jq --raw-output '.serviceCatalog[0].endpoints[0].publicURL'`
TOKUS=`echo ${serv} |  jq --raw-output '.token.value'`


echo "$TOKEU $TOKUS $ENDPEU $ENDPUS"

SEU="swift --os-auth-token ${TOKEU} --os-storage-url ${ENDPEU}"
SUS="swift --os-auth-token ${TOKUS} --os-storage-url ${ENDPUS}"

#Sync eu-us
${SEU} post -t ${ENDPUS}/${container} -k ${synckey} ${container}
#Sync us-eu
${SUS} post -t ${ENDPEU}/${container} -k ${synckey} ${container}
