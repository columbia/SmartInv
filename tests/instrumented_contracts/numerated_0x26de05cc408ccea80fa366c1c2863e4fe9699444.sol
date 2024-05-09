1 pragma solidity ^0.4.2;
2 
3 contract Zeroexchange {
4     /* Public variables of the token */
5     string public standard = 'Token 0.1';
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public initialSupply;
10     uint256 public totalSupply;
11 
12     /* This creates an array with all balances */
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16   
17     /* Initializes contract with initial supply tokens to the creator of the contract */
18     function Zeroexchange() {
19 
20          initialSupply = 10000000000;
21          name ="Zeroexchange";
22         decimals = 2;
23          symbol = "ZOO";
24         
25         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
26         totalSupply = initialSupply;                        // Update total supply
27                                    
28     }
29   /* Send coins */
30     function transfer(address _to, uint256 _value) {
31         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
32         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
33         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
34         balanceOf[_to] += _value;                            // Add the same to the recipient
35       
36     }
37 
38    
39 
40     
41 
42    
43 
44     /* This unnamed function is called whenever someone tries to send ether to it */
45     function () {
46         throw;     // Prevents accidental sending of ether
47     }
48 }