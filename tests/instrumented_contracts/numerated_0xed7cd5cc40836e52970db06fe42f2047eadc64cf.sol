1 pragma solidity ^0.4.0;
2 
3 
4 
5 contract Tfarm {
6     /* Public variables of the token */
7     string public standard = 'Token 0.1';
8     string public name;
9     string public symbol;
10     uint8 public decimals;
11     uint256 public initialSupply;
12 
13     /* This creates an array with all balances */
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17   
18     /* Initializes contract with initial supply tokens to the creator of the contract */
19     function Tfarm() {
20 
21          initialSupply = 210000000;
22          name ="tfarm";
23         decimals = 2;
24          symbol = "^";
25         
26         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
27         uint256 totalSupply = initialSupply;                        // Update total supply
28                                    
29     }
30 
31     /* Send coins */
32     function transfer(address _to, uint256 _value) {
33         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
34         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
35         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
36         balanceOf[_to] += _value;                            // Add the same to the recipient
37       
38     }
39 
40    
41 
42     
43 
44    
45 
46     /* This unnamed function is called whenever someone tries to send ether to it */
47     function () {
48         throw;     // Prevents accidental sending of ether
49     }
50 }