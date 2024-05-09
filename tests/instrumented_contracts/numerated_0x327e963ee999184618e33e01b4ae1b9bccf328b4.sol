1 pragma solidity ^0.4.11;
2 
3 
4 
5 contract ALCOIN {
6     /* Public variables of the token */
7     string public standard = 'Token 0.1';
8     string public name;
9     string public symbol;
10     uint8 public decimals;
11     uint256 public initialSupply;
12     uint256 public totalSupply;
13 
14     /* This creates an array with all balances */
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18   
19     /* Initializes contract with initial supply tokens to the creator of the contract */
20     function ALCOIN() {
21 
22          initialSupply = 500000000000;
23         name = "LATINO AMERICA COIN";
24         decimals = 3;
25         symbol = "ALC";
26         
27         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
28         totalSupply = initialSupply;                        // Update total supply
29                                    
30     }
31 
32     /* Send coins */
33     function transfer(address _to, uint256 _value) {
34         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
35         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
36         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
37         balanceOf[_to] += _value;                            // Add the same to the recipient
38       
39     }
40 
41     /* This unnamed function is called whenever someone tries to send ether to it */
42     function () {
43         throw;     // Prevents accidental sending of ether
44     }
45 }