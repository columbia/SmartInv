1 pragma solidity ^0.4.6;
2 
3 contract token { 
4     /* Public variables of the token */
5     string public standard = 'Token 0.1';
6     
7 	string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11 	
12     mapping (address => uint256) public coinBalanceOf;
13     event CoinTransfer(address sender, address receiver, uint256 amount);
14 
15   /* Initializes contract with initial supply tokens to the creator of the contract */
16   function token(
17         uint256 initialSupply,	
18         string tokenName,
19         uint8 decimalUnits,
20         string tokenSymbol
21         ) {
22         coinBalanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
23         totalSupply = initialSupply;                        // Update total supply
24         name = tokenName;                                   // Set the name for display purposes
25         symbol = tokenSymbol;                               // Set the symbol for display purposes
26         decimals = decimalUnits;                            // Amount of decimals for display purposes
27     }
28 
29     function balanceOf(address _owner) constant returns (uint256 balance) {
30         return coinBalanceOf[_owner];
31     }
32 
33   /* Very simple trade function */
34     function sendCoin(address receiver, uint256 amount) returns(bool sufficient) {
35         if (coinBalanceOf[msg.sender] < amount) return false;
36         coinBalanceOf[msg.sender] -= amount;
37         coinBalanceOf[receiver] += amount;
38         CoinTransfer(msg.sender, receiver, amount);
39         return true;
40     }
41 }