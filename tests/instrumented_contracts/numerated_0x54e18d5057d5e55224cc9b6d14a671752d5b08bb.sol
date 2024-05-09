1 pragma solidity ^0.4.8;
2 
3 contract WSIPrivateEquityShare {
4     /* Public variables of the token */
5     string public constant name = 'WSI Private Equity Share';
6     string public constant symbol = 'WSIPES';
7     uint256 public constant totalSupply = 10000;
8     uint8 public decimals = 2;
9 
10     /* This creates an array with all balances */
11     mapping (address => uint256) public balanceOf;
12 
13     /* This generates a public event on the blockchain that will notify clients */
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     /* Initializes contract with initial supply tokens to the creator of the contract */
17     function WSIPrivateEquityShare() {
18         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
19     }
20 
21     /* Send coins */
22     function transfer(address _to, uint256 _value) {
23         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
24         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
25         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
26         balanceOf[_to] += _value;                            // Add the same to the recipient
27         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
28     }
29 
30     /* This unnamed function is called whenever someone tries to send ether to it */
31     function () {
32         throw;     // Prevents accidental sending of ether
33     }
34 }