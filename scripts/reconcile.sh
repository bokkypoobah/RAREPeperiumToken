#!/bin/sh
# ----------------------------------------------------------------------------------------------
# Extract Token Balances
#
# Based on https://github.com/BitySA/whetcwithdraw/tree/master/daobalance
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

# geth attach rpc:http://192.168.4.120:8545 << EOF
geth attach rpc:http://localhost:8545 << EOF > reconcile.txt

var oldTokenAddress = "0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437";
var oldTokenABI = [{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"totalSupply","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"}];
var oldToken = web3.eth.contract(oldTokenABI).at(oldTokenAddress);
var oldTokenFromBlock = 3366003;
var oldTokenToBlock = 3834349;

var block = eth.getBlock(oldTokenToBlock);
console.log("BALANCE: snapshot at block=" + block.number + " time=" + block.timestamp + " " + new Date(block.timestamp * 1000).toUTCString());

var newTokenAddress = "0x5dDAB66DA218Fb05dfeDA07f1AfC4ea0738ee234";
var newTokenABI = [{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_amount","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"seal","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"value","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"acceptOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"fill","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"newOwner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"sealed","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"payable":false,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"}],"name":"OwnershipTransferred","type":"event"}];
var newToken = web3.eth.contract(newTokenABI).at(newTokenAddress);
var newTokenFromBlock = 3834667;
var newTokenToBlock = 3834722;


function getOldTokenAccounts() {
  var accounts = {};
  var transferEventsFilter = oldToken.Transfer({}, {fromBlock: oldTokenFromBlock, toBlock: oldTokenToBlock});
  var transferEvents = transferEventsFilter.get();
  for (var i = 0; i < transferEvents.length; i++) {
    var transferEvent = transferEvents[i];
    console.log(JSON.stringify(transferEvent));
    accounts[transferEvent.args._from] = 1;
    accounts[transferEvent.args._to] = 1;
  }
  // Add owner address
  accounts["0x00011675f9d83C2fBBD93883F056093BA322e600"] = 1;
  return Object.keys(accounts);
}

function getNewTokenAccounts() {
  var accounts = {};
  var transferEventsFilter = newToken.Transfer({}, {fromBlock: newTokenFromBlock, toBlock: newTokenToBlock});
  var transferEvents = transferEventsFilter.get();
  for (var i = 0; i < transferEvents.length; i++) {
    var transferEvent = transferEvents[i];
    console.log(JSON.stringify(transferEvent));
    accounts[transferEvent.args.from] = 1;
    accounts[transferEvent.args.to] = 1;
  }
  // Add owner address
  accounts["0x00011675f9d83C2fBBD93883F056093BA322e600"] = 1;
  return Object.keys(accounts);
}

function getOldAndNewTokenBalances(accounts, tokenType) {
    var oldTokenTotalBalance = new BigNumber(0);
    var newTokenTotalBalance = new BigNumber(0);
    console.log("BALANCE: #\tSource\tAccount\tOldBalance\tNewBalance");
    for (var i = 0; i < accounts.length; i++) {
        var oldAmount = oldToken.balanceOf(accounts[i], oldTokenToBlock);
        var newAmount = newToken.balanceOf(accounts[i], newTokenToBlock);
        if (oldAmount.greaterThan(0)) {
            oldTokenTotalBalance = oldTokenTotalBalance.add(oldAmount);
        }
        if (newAmount.greaterThan(0)) {
            newTokenTotalBalance = newTokenTotalBalance.add(newAmount);
        }
        console.log("BALANCE: " + i + "\t" + tokenType + "\t" + accounts[i] + "\t" + oldAmount.div(1e8) + "\t" + newAmount.div(1e8));
    }
    console.log("Total oldTokenTotalBalance=" + oldTokenTotalBalance.toString(10));
    console.log("Total newTokenTotalBalance=" + newTokenTotalBalance.toString(10));
}

var oldAccounts = getOldTokenAccounts();
var newAccounts = getNewTokenAccounts();

getOldAndNewTokenBalances(oldAccounts, "From Old Accounts");
getOldAndNewTokenBalances(newAccounts, "From New Accounts");

EOF

grep "BALANCE: " reconcile.txt | sed "s/BALANCE: //" > reconcileBalances.txt
