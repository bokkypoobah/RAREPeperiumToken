# Fixing And Security Auditing The RARE Peperium Token (Work in progress)

Michael C, the owner of the R$ RARE token at [0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437](https://etherscan.io/address/0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437) had troubles listing the R$ tokens for sale and purchase on https://cryptoderivatives.market/ . [EtherScan](https://etherscan.io/token/0x584AA8297eDfCB7d8853a426bb0f5252C4aF9437) displays an "Oops" error while [Ethplorer](https://ethplorer.io/address/0x584aa8297edfcb7d8853a426bb0f5252c4af9437) displayed a Total Supply of 1.157920892373162e+69 R$ .

The original contract code can be found at [contracts/RARE_original.sol](contracts/RARE_original.sol).

I offered to fix, test and audit the R$ token code. The fixed contract can be found at [contracts/RAREToken.sol](contracts/RAREToken.sol).

<br />

<hr />

**Table of contents**
* [Background And History](#background-and-history)
* [Security Overview Of The RAREToken Contract](#security-overview-of-the-raretoken-contract)
  * [Other Notes](#other-notes)
* [Comments On The Source Code](#comments-on-the-source-code)
* [References](#references)


<br />

<hr />

## Background And History
* Apr 24 2017 Michael C agreed for the unnecessary `mintToken(...)`, `freezeAccount(...)`, `approveAndCall(...)`, `buy()`, `sell(...)` and `setPrices(...)` functions to be removed.
* May 08 2017 Bok Consulting completed (almost) the changes to [contracts/RAREToken.sol](contracts/RAREToken.sol) and the test script [test/01_test1.sh](test/01_test1.sh) with the generated result documented in [test/test1results.txt](test/test1results.txt)
* May 09 2017 Bok Consulting completed this security audit report

<br />

<hr />

## Security Overview Of The RAREToken Contract
* [x] The smart contract has been kept relatively simple
* [x] The code has been tested for the normal use cases, and around the boundary cases
* [x] The testing has been done using geth 1.5.9-stable and solc 0.4.9+commit.364da425.Darwin.appleclang instead of one of the testing frameworks and JavaScript VMs to simulate the live environment as closely as possible
* [x] The `approveAndCall(...)` function has been removed as the side effects of this function has not been evaluated fully
* [x] There is no logic with potential division by zero errors
* [x] All numbers used are uint256 (with the exception of `decimals`), reducing the risk of errors from type conversions
* [x] Areas with potential overflow errors in `transfer(...)` and `transferFrom(...)` have the logic to prevent overflows
* [x] Areas with potential underflow errors in `transfer(...)` and `transferFrom(...)` have the logic to prevent underflows
* [x] Function and event names are differentiated by case - function names begin with a lowercase character and event names begin with an uppercase character

### Other Notes


<br />

<hr />

## Comments On The Source Code

My comments in the following code are market in the lines beginning with `// NOTE: `

```javascript
pragma solidity ^0.4.9;

contract Owned {
    address public owner;
    address public newOwner;
    event OwnershipTransferred(address indexed _from, address indexed _to);

    function Owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _;
    }

    function transferOwnership(address _newOwner) onlyOwner {
        newOwner = _newOwner;
    }
 
    function acceptOwnership() {
        if (msg.sender == newOwner) {
            OwnershipTransferred(owner, newOwner);
            owner = newOwner;
        }
    }
}


contract ERC20Token is Owned {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint256 public totalSupply;

    // Balances for each account
    mapping (address => uint256) balances;
    
    // Owner of account approves the transfer of an amount to another account
    mapping (address => mapping (address => uint256)) allowed;

    // Triggered when tokens are transferred.
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Triggered whenever approve(address _spender, uint256 _value) is called.
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // Constructor
    function ERC20Token(string _symbol, string _name, uint8 _decimals, uint256 _totalSupply) {
        symbol = _symbol;
        name = _name;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }

    // What is the balance of a particular account?
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    // Transfer the balance from owner's account to another account
    function transfer(address _to, uint256 _amount) returns (bool success) {
        if (balances[msg.sender] >= _amount
            && _amount > 0
            && balances[_to] + _amount > balances[_to]) {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    // Send _value amount of tokens from address _from to address _to
    // The sender of the message will need to have had the spending approved
    // via the approve(...) function
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) returns (bool success) {
        if (balances[_from] >= _amount
            && allowed[_from][msg.sender] >= _amount
            && _amount > 0
            && balances[_to] + _amount > balances[_to]) {
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(_from, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    function approve(address _spender, uint256 _amount) returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }

    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    // Don't accept ethers
    function () {
        throw;
    }
}


contract RareToken is ERC20Token {
    /* 100,000,000 tokens, 8 decimal places */
    function RareToken() ERC20Token ("RARE", "RARE", 8, 10000000000000000) {
    }

    function burnTokens(uint256 _value) onlyOwner {
        if (balances[owner] < _value) throw;
        balances[owner] -= _value;
        totalSupply -= _value;
        Transfer(owner, 0, _value);
    }
}
```

<br />

<hr />

## References

* [Ethereum Contract Security Techniques and Tips](https://github.com/ConsenSys/smart-contract-best-practices)
* Solidity [bugs.json](https://github.com/ethereum/solidity/blob/develop/docs/bugs.json) and [bugs_by_version.json](https://github.com/ethereum/solidity/blob/develop/docs/bugs_by_version.json).

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd - May 09 2017