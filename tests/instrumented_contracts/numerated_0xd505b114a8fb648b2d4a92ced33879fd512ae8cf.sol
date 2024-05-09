1 pragma solidity ^0.4.2;
2 
3 contract Titaneum {
4     /* Public variables of the token */
5     string public standard = 'Token 0.1';
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public totalSupply;
10 
11     /* This creates an array with all balances */
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     /* This generates a public event on the blockchain that will notify clients */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     /* Initializes contract with initial supply tokens to the creator of the contract */
19     function Titaneum() {
20     
21         balanceOf[msg.sender] = 99000000;              // Give the creator all initial tokens
22         totalSupply = 99000000;                        // Update total supply
23         name = "Titaneum";                                   // Set the name for display purposes
24         symbol = "TTNM";                               // Set the symbol for display purposes
25         decimals = 0;                            // Amount of decimals for display purposes
26     }
27 
28     /* Send coins */
29     function transfer(address _to, uint256 _value) {
30         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
31         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
32         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
33         balanceOf[_to] += _value;                            // Add the same to the recipient
34         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
35     }
36 }