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

* [x] MC to inform users to halt transfers of the old tokens after a specified block in the near future
* [x] BK to extract the token balances for all accounts at the specified block - snapshot at block=3834349 time=1496833201 Wed, 07 Jun 2017 11:00:01 UTC
* [x] BK to deploy new token contract - address [0x5ddab66da218fb05dfeda07f1afc4ea0738ee234](https://ethplorer.io/address/0x5ddab66da218fb05dfeda07f1afc4ea0738ee234)
* [x] BK to fill the new token contract with the token balances for all accounts
* [x] BK to seal the new token contract
* [x] BK to reconcile the token numbers between the old and new token contracts - see [scripts/reconcile.sh](scripts/reconcile.sh) and [scripts/reconcileBalances.txt](scripts/reconcileBalances.txt)
* [] BK to call `token.transferOwnership(...)` to transfer the contract to MC's account
* [] MC to call `token.acceptOwnership()` to accept the transfer of the contract

## Deployment Cost

Following are the transaction cost of deploying the new RARE token contract, with the 323 account balances transferred totaling 0.085889375 ETH:

[0xa052ae71](https://etherscan.io/tx/0xa052ae713568895795d4ce4f0184135e2315ebfb0ddd0f98f9ef4a10f4ddaa1e) 0.02079118543703
[0x8423def6](https://etherscan.io/tx/0x8423def6ac9e422dbd8fc3454b5a03c87d8ade40ef2c94a39f91b5538a30e437) 0.00757892
[0xf681a8f0](https://etherscan.io/tx/0xf681a8f0fb5d281a622189a814fd5742341dc734eb2a3367c7cadaf93396bebb) 0.00502287
[0x83d758f3](https://etherscan.io/tx/0x83d758f343271010d5b7a61ed261b3c6b9a3d9d1c7384d28d60005ceb3d7ef52) 0.0049126
[0x838dd32e](https://etherscan.io/tx/0x838dd32e0ecfc2bcf752bd81b9a5c2bf30772eaf46e8df6b4dae0eedadbb133b) 0.00491362
[0x6a90885b](https://etherscan.io/tx/0x6a90885bd390e60cc79d49062e0b34dd7b4f491d8912c2d7bfad8c403f7db664) 0.00491208
[0xec72251e](https://etherscan.io/tx/0xec72251ede76e871ec9f89e1b4b82bd8451858987ed6006fe55d1e19557399cc) 0.00491157
[0xa101e698](https://etherscan.io/tx/0xa101e698afbf065a283adb679be162c9067e68030ea8e95e74872faae8be55b3) 0.00491311
[0x032843d7](https://etherscan.io/tx/0x032843d73f7ddf9e8389b79b3e79e5c10495dc82b0d4d35969ba88296df81f43) 0.00491157
[0x19741741](https://etherscan.io/tx/0x19741741b78c140f1363d4012b7e4f11c083cf3a58a006073baec925636bad33) 0.00491055
[0xf1d4b376](https://etherscan.io/tx/0xf1d4b376164a1dc2d9be00c28d4323a645a54aa59cf1d2ee8b50cb4349f4f9a9) 0.00491157
[0x454bb51f](https://etherscan.io/tx/0x454bb51f91943d473fb3870f95de7583475a5f3e490e12d42bae8151402252c6) 0.00491925
[0x2cdeb3ab](https://etherscan.io/tx/0x2cdeb3abf9d7fa1d177e676afeeba25fc01aa028816ed5f4492140023f20617c) 0.0049172
[0xbb67c6b6](https://etherscan.io/tx/0xbb67c6b6b727163eb31fc8ccc41d3b701b27a9ea38a6ec16fc964bd1a2e7d11f) 0.00302516
[0x5ce235c6](https://etherscan.io/tx/0x5ce235c608945b141d3f3c012ddc84f63d4e641ffbc53fc6243429c43d4dc85f) 0.00033812

























<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd - May 09 2017