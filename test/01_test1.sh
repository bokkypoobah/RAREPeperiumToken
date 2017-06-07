#!/bin/sh
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

GETHATTACHPOINT=`grep ^IPCFILE= settings.txt | sed "s/^.*=//"`
PASSWORD=`grep ^PASSWORD= settings.txt | sed "s/^.*=//"`
TOKENSOL=`grep ^TOKENSOL= settings.txt | sed "s/^.*=//"`
TOKENJS=`grep ^TOKENJS= settings.txt | sed "s/^.*=//"`
DEPLOYMENTDATA=`grep ^DEPLOYMENTDATA= settings.txt | sed "s/^.*=//"`

INCLUDEJS=`grep ^INCLUDEJS= settings.txt | sed "s/^.*=//"`
TEST1OUTPUT=`grep ^TEST1OUTPUT= settings.txt | sed "s/^.*=//"`
TEST1RESULTS=`grep ^TEST1RESULTS= settings.txt | sed "s/^.*=//"`

printf "GETHATTACHPOINT = '$GETHATTACHPOINT'\n"
printf "PASSWORD        = '$PASSWORD'\n"
printf "TOKENSOL        = '$TOKENSOL'\n"
printf "TOKENJS         = '$TOKENJS'\n"
printf "DEPLOYMENTDATA  = '$DEPLOYMENTDATA'\n"
printf "INCLUDEJS       = '$INCLUDEJS'\n"
printf "TEST1OUTPUT     = '$TEST1OUTPUT'\n"
printf "TEST1RESULTS    = '$TEST1RESULTS'\n"

echo "var tokenOutput=`solc --optimize --combined-json abi,bin,interface $TOKENSOL`;" > $TOKENJS

geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee $TEST1OUTPUT
loadScript("$TOKENJS");
loadScript("functions.js");

var tokenAbi = JSON.parse(tokenOutput.contracts["$TOKENSOL:RareToken"].abi);
var tokenBin = "0x" + tokenOutput.contracts["$TOKENSOL:RareToken"].bin;

console.log("DATA: tokenABI=" + JSON.stringify(tokenAbi));

unlockAccounts("$PASSWORD");
printBalances();

var tokenContract = web3.eth.contract(tokenAbi);

// -----------------------------------------------------------------------------
var testMessage = "Test 1.1 Deploy Token Contract";
console.log("RESULT: " + testMessage);

var tokenTx = null;
token = tokenContract.new({from: tokenOwnerAccount, data: tokenBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        tokenTx = contract.transactionHash;
      } else {
        tokenAddress = contract.address;
        addAccount(tokenAddress, "TOKEN");
        addContractAddressAndAbi(tokenAddress, tokenAbi);
        console.log("DATA: tokenAddress=" + tokenAddress);
        printTxData("tokenAddress=" + tokenAddress, tokenTx);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfGasEqualsGasUsed(tokenTx, testMessage);
printContractStaticDetails();
printContractDynamicDetails();


// -----------------------------------------------------------------------------
var testMessage = "Test 1.2 Initial Transfer Of Tokens";
console.log("RESULT: " + testMessage);
var tx12_1 = token.transfer(account2, "100000000000", {from: tokenOwnerAccount, gas: 100000});
var tx12_2 = token.transfer(account3, "100000000000", {from: tokenOwnerAccount, gas: 100000});
var tx12_3 = token.transfer(account4, "100000000000", {from: tokenOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("tx12_1", tx12_1);
printTxData("tx12_2", tx12_2);
printTxData("tx12_3", tx12_3);
printBalances();
failIfGasEqualsGasUsed(tx12_1, testMessage + " -> Account #2");
failIfGasEqualsGasUsed(tx12_2, testMessage + " -> Account #3");
failIfGasEqualsGasUsed(tx12_3, testMessage + " -> Account #4");
printContractDynamicDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var testMessage = "Test 1.3 Execute Invalid Functions - sending ethers to token contract; sending more tokens than owned";
console.log("RESULT: " + testMessage);
var tx13_1 = eth.sendTransaction({from: tokenOwnerAccount, to: tokenAddress, gas: 400000, value: web3.toWei("100", "ether")});
var tx13_2 = token.transfer(account2, "10000000000000000000", {from: tokenOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("tx13_1", tx13_1);
printTxData("tx13_2", tx13_2);
printBalances();
passIfGasEqualsGasUsed(tx13_1, testMessage + " - CHECK no ethers moved");
failIfGasEqualsGasUsed(tx13_2, testMessage + " - CHECK no tokens moved");
printContractDynamicDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var testMessage = "Test 1.4 Change Ownership";
console.log("RESULT: " + testMessage);
var tx14_1 = token.transferOwnership(minerAccount, {from: tokenOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
var tx14_2 = token.acceptOwnership({from: minerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("tx14_1", tx14_1);
printTxData("tx14_2", tx14_2);
printBalances();
failIfGasEqualsGasUsed(tx14_1, testMessage + " - Change owner");
failIfGasEqualsGasUsed(tx14_2, testMessage + " - Accept ownership");
printContractDynamicDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var testMessage = "Test 1.5 Account2 approves transfer of 100 tokens to account5 and account5 transfers";
console.log("RESULT: " + testMessage);
var tx1_5_1 = token.approve(account5, "10000000000", {from: account2, gas: 100000});
while (txpool.status.pending > 0) {
}
var tx1_5_2 = token.transferFrom(account2, account5, "10000000000", {from: account5, gas: 100000});
while (txpool.status.pending > 0) {
}
printBalances();
failIfGasEqualsGasUsed(tx1_5_1, testMessage + " - account2 approves");
failIfGasEqualsGasUsed(tx1_5_2, testMessage + " - account3 transferFrom");
printContractDynamicDetails();
console.log("RESULT: ");


EOF
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
