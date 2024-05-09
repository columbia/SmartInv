1 pragma solidity ^0.4.11;
2 
3 contract Travelerscash {
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
18     function Travelerscash() {
19 
20          initialSupply = 200000000;
21          name ="Travelerscash";
22         decimals = 0;
23          symbol = "TCASH";
24         
25         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
26         totalSupply = initialSupply;                        // Update total supply
27                                    
28     }
29 
30     /* Send coins */
31     function transfer(address _to, uint256 _value) {
32         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
33         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
34         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
35         balanceOf[_to] += _value;                            // Add the same to the recipient
36       
37     }
38 
39    
40 
41     
42 
43    
44 
45     /* This unnamed function is called whenever someone tries to send ether to it */
46     function () {
47         throw;     // Prevents accidental sending of ether
48     }
49 }