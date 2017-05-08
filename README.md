# RARE Peperium Token
RARE Peperium Token

The owner of the RARE Peperium contract asked why the TokenTraderFactory contract was now working with their supposedly ERC20-compliant token.

I had a quick scan of the emailed token contract code and found a bug in the RARE Peperium contract deployed to [0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437](https://etherscan.io/address/0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437):

Following are alternative block explorer views of this contract:

* https://etherscan.io/token/0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437
* https://ethplorer.io/address/0x584aa8297edfcb7d8853a426bb0f5252c4af9437

I have offered to fix, test and audit the code, so here is the repository with the fix, tests and [security audit](SecurityAudit.md).

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

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd - May 09 2017