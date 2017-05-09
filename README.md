# RARE Peperium Token
RARE Peperium Token

The owner of the RARE Peperium contract asked why the TokenTraderFactory contract was now working with their supposedly ERC20-compliant token.

I had a quick scan of the emailed token contract code and found a bug in the RARE Peperium contract deployed to [0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437](https://etherscan.io/address/0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437):

Following are alternative block explorer views of this contract:

* https://etherscan.io/token/0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437
* https://ethplorer.io/address/0x584aa8297edfcb7d8853a426bb0f5252c4af9437

I have offered to fix, test and audit the code, so here is the repository with the fix, tests and [security audit](SecurityAudit.md).

I have also offered to help him migrate the token balances from the old RARE token contract to the new RARE token contract. 

<br />

<hr />

## Conversation with Michael C Apr 24 2017

* Hardcoded the initial supply of 100 million units with 8 decimals, symbol R$, name RARE

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