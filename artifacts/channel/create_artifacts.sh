# # These folders will NOT update when we re-run create_artifacts.sh
# # Therefore, we have to remove it
# chmod -R 0755 ./crypto-config
# # # Delete existing artifacts
# rm -rf ./crypto-config
# rm genesis.block mychannel.tx
# rm -rf ../../channel-creation/*

##################################################################################################
#--------------------------THIS FILE CREATES CRYPTO FOR ORGs, CHANNEL AND------------------------#
#-------------------------------COVER THEM INTO BLOCKs-------------------------------------------# 
#---------NOTE:THIS FILE ONLY CREATE BLOCKS FOR VERY FIRST IMPORTANT COMPONENTS OF THE NETWORK---#
#--------------------------WHICH ARE ORGs, CHANNELs AND ANCHOR PEERs-----------------------------#
#----------------------------IT DOES NOT RUN THE COMPONENTS--------------------------------------#
##################################################################################################

# Generate Crypto artifacts for organizations
# In production network, we use CAs
cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/

# # System channel
# This is ordering organization (ordering nodes) channel
SYS_CHANNEL="sys-channel"
    
# # channel name defaults to "mychannel"
# This is org1+2 channel
CHANNEL_NAME="mychannel"

echo $CHANNEL_NAME

# Generate System Genesis block
# This is channel block for orderer nodes
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
# This is channel block for 2 orgs
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./mychannel.tx -channelID $CHANNEL_NAME

# echo "#######    Generating anchor peer update for Org1MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

# echo "#######    Generating anchor peer update for Org2MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
