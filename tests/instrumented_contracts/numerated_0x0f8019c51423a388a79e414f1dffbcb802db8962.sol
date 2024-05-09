1 pragma solidity ^0.4.0;
2 
3    
4 
5 
6 contract Satnet {
7     /* Public variables of the token */
8     string public standard = 'Token 0.1';
9     string public name;
10     string public symbol;
11     uint8 public decimals;
12     uint256 public initialSupply;
13     uint256 public totalSupply;
14 
15     /* This creates an array with all balances */
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19   
20     /* Initializes contract with initial supply tokens to the creator of the contract */
21     function Satnet() {
22 
23          initialSupply = 10000000;
24          name ="satnet";
25         decimals = 0;
26          symbol = "dish";
27         
28         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
29         totalSupply = initialSupply;                        // Update total supply
30                                    
31     }
32 
33     /* Send coins */
34     function transfer(address _to, uint256 _value) {
35         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
36         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
37         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
38         balanceOf[_to] += _value;                            // Add the same to the recipient
39       
40     }
41 
42    
43 
44     
45 
46    
47 
48     /* This unnamed function is called whenever someone tries to send ether to it */
49     function () {
50         throw;     // Prevents accidental sending of ether
51     }
52 }