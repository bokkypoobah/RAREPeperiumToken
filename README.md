# RARE Peperium Token
RARE Peperium Token

The owner of the RARE Peperium contract asked why the TokenTraderFactory contract was now working with their supposedly ERC20-compliant token.

I had a quick scan of the emailed token contract code and found some bugs in the RARE Peperium contract deployed to [0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437](https://etherscan.io/address/0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437):

* The first issue is that the totalSupply is reported as 115792089237316195423570985008687907853269984665640564039457583907913129639936 . The intended  total supply is 100,000,000. See https://github.com/bokkypoobah/RAREPeperiumToken/blob/master/scripts/oldTokenBalances.txt#L735 .
* Extracting each account balance and summing the balance for all accounts results in the number 9900000000000000 which is 99,000,000.00000000 . See https://github.com/bokkypoobah/RAREPeperiumToken/blob/master/scripts/oldTokenBalances.txt#L734 and [data/EthplorerOldTokenBalances_20170510.xls](data/EthplorerOldTokenBalances_20170510.xls).

Following are alternative block explorer views of this contract:

* https://etherscan.io/token/0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437
* https://ethplorer.io/address/0x584aa8297edfcb7d8853a426bb0f5252c4af9437

I have offered to fix, test and audit the code, so here is the repository with the fix, tests and [security audit](SecurityAudit.md).

I have also offered to help him migrate the token balances from the old RARE token contract to the new RARE token contract. 

<br />

<hr />

## Conversation with Michael C Apr 24 2017

* Hardcoded the initial supply of 100 million units with 8 decimals, symbol R$, name RARE

## Conversation with Michael C May 11 2017

* The missing 1,000,000 is due to the burning of this amount of tokens to signify the RARE release date.
* The total supply will have to be adjusted for this burning events

<br />

<hr />

## Actions

* Completed [#1 Remove the mintToken(...) function](https://github.com/bokkypoobah/RAREPeperiumToken/issues/1)
* Completed [#2 Fix the totalSupply issue](https://github.com/bokkypoobah/RAREPeperiumToken/issues/2)
* Completed [#3 Remove freezeAccount(...) function](https://github.com/bokkypoobah/RAREPeperiumToken/issues/3)
* Completed [#4 Remove approveAndCall(...) function](https://github.com/bokkypoobah/RAREPeperiumToken/issues/4)
* Completed [#5 Remove buy(), sell(...), setPrices(...) functions](https://github.com/bokkypoobah/RAREPeperiumToken/issues/5)

## Deployment Steps

* [] MC to inform users to halt transfers of the old tokens after a specified block in the near future
* [] BK to extract the token balances for all accounts at the specified block
* [] BK to fill the new token contract with the token balances for all accounts
* [] BK to seal the new token contract
* [] BK to reconcile the token numbers between the old and new token contracts
* [] BK to call `token.transferOwnership(...)` to transfer the contract to MC's account
* [] MC to call `token.acceptOwnership()` to accept the transfer of the contract

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd - May 09 2017