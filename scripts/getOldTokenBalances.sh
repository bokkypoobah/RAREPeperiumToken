#!/bin/sh
# ----------------------------------------------------------------------------------------------
# Extract Token Balances
#
# Based on https://github.com/BitySA/whetcwithdraw/tree/master/daobalance
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

geth attach rpc:http://192.168.4.120:8545 << EOF

var D160 = new BigNumber("10000000000000000000000000000000000000000", 16);
var tokenAddress = "0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437";
var tokenABI = [{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"totalSupply","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"}];
var token = web3.eth.contract(tokenABI).at(tokenAddress);
var fromBlock = 3366003;
var toBlock = "latest";
// var toBlock = parseInt(fromBlock) + 1000;

function getAccounts() {
  var accounts = {};
  var transferEventsFilter = token.Transfer({}, {fromBlock: fromBlock, toBlock: toBlock});
  var transferEvents = transferEventsFilter.get();
  var i;
  for (i = 0; i < transferEvents.length; i++) {
    var transferEvent = transferEvents[i];
    console.log(JSON.stringify(transferEvent));
    accounts[transferEvent.args._from] = 1;
    accounts[transferEvent.args._to] = 1;
  }
  return Object.keys(accounts);
}

function getBalancesAndCompress(accounts) {
    var i;
    var balances = [];
    var acc = new BigNumber(0);
    for (i = 0; i < accounts.length; i++) {
        var addressNum = new BigNumber(accounts[i].substring(2), 16);
        var amount = token.balanceOf(accounts[i], toBlock);
        var v = D160.mul(amount).add(addressNum);
        if (amount.greaterThan(0)) {
            balances.push(v.toString(10));
            acc = acc.add(amount);
            if (i%100 === 0) console.log("Processed: " + i);
        }
    }
    console.log("Added Balance = "+ acc.toString(10));
    console.log("totalSupply = " + token.totalSupply().toString(10));
    return balances;
}

var accounts = getAccounts();
console.log(JSON.stringify(accounts));
var balances = getBalancesAndCompress(accounts);
// console.log(JSON.stringify(balances, null, 2));
console.log(JSON.stringify(balances));

EOF