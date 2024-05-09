1 pragma solidity ^0.4.24;
2 
3 
4 contract Craftmelon {
5     /* Public variables of the token */
6     string public standard = 'Token 0.1';
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public initialSupply;
11     uint256 public totalSupply;
12 
13     /* This creates an array with all balances */
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17   
18     /* Initializes contract with initial supply tokens to the creator of the contract */
19     function Craftmelon() {
20 
21          initialSupply = 500000000;
22          name ="craft";
23          decimals = 2;
24          symbol = "C";
25         
26         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
27         totalSupply = initialSupply;                        // Update total supply
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
40     /* This unnamed function is called whenever someone tries to send ether to it */
41     function () {
42         throw;     // Prevents accidental sending of ether
43     }
44 }