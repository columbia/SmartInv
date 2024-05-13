1 pragma solidity ^0.4.11;
2 
3 
4 import "../ERC677Token.sol";
5 import "../token/linkStandardToken.sol";
6 
7 
8 contract Token677 is linkStandardToken, ERC677Token {
9     string public constant name = "Example ERC677 Token";
10     string public constant symbol = "ERC677";
11     uint8 public constant decimals = 18;
12     uint256 public totalSupply;
13 
14     function Token677(uint _initialBalance)
15     {
16         balances[msg.sender] = _initialBalance;
17         totalSupply = _initialBalance;
18     }
19 }
