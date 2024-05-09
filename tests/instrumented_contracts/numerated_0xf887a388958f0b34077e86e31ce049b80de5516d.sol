1 pragma solidity ^0.4.25; 
2 
3 //0.4.25+commit.59dbf8f1
4 
5 contract FirstToken {
6     
7     /* This creates an array with addresses connected with balances */
8     mapping (address => uint256) public balanceOf;
9     
10     string public name;
11     string public symbol;
12     uint8 public decimals;
13     
14     // EVENTS
15     
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     
18     // Initializes contract with initial supply tokens to the creator of the contract
19     // W nowej wersji nie używa się function o nazwie contract ale constructor
20     /* Initializes contract with initial supply tokens to the creator of the contract */
21     
22     constructor (uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
23         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
24         name = tokenName;                                   // Set the name for display purposes
25         symbol = tokenSymbol;                               // Set the symbol for display purposes
26         decimals = decimalUnits;                            // Amount of decimals for display purposes
27     }
28 
29     /* Send coins */
30     function transfer(address _to, uint256 _value) public returns (bool success) {
31         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
32         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
33         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
34         balanceOf[_to] += _value;                           // Add the same to the recipient
35         emit Transfer(msg.sender, _to, _value);             // Powiadomienie o tym ze transfer sie odbyl
36         return true;
37     }
38     
39 }