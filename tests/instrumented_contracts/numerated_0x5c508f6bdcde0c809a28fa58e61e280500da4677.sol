1 pragma solidity ^0.4.2;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract Barneys4HackerSpaceToken {
5     /* Public variables of the token */
6     string public standard = 'Token 0.1';
7     string public name="BarneysHackerSpaceToken";
8     string public symbol="BHST";
9     uint8 public decimals=6;
10     uint256 public totalSupply = 10000;
11 
12     /* This creates an array with all balances */
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     /* This generates a public event on the blockchain that will notify clients */
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /* Initializes contract with initial supply tokens to the creator of the contract */
20     function Barneys4HackerSpaceToken() {
21         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
22 
23     }
24 
25     /* Send coins */
26     function transfer(address _to, uint256 _value) {
27         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
28         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
29         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
30         balanceOf[_to] += _value;                            // Add the same to the recipient
31         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
32     }
33 
34     /* Allow another contract to spend some tokens in your behalf */
35     function approve(address _spender, uint256 _value)
36         returns (bool success) {
37         allowance[msg.sender][_spender] = _value;
38         return true;
39     }
40 
41     /* Approve and then comunicate the approved contract in a single tx */
42     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
43         returns (bool success) {
44         tokenRecipient spender = tokenRecipient(_spender);
45         if (approve(_spender, _value)) {
46             spender.receiveApproval(msg.sender, _value, this, _extraData);
47             return true;
48         }
49     }        
50 
51     /* A contract attempts to get the coins */
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
54         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
55         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
56         balanceOf[_from] -= _value;                          // Subtract from the sender
57         balanceOf[_to] += _value;                            // Add the same to the recipient
58         allowance[_from][msg.sender] -= _value;
59         Transfer(_from, _to, _value);
60         return true;
61     }
62 
63     /* This unnamed function is called whenever someone tries to send ether to it */
64     function () {
65         throw;     // Prevents accidental sending of ether
66     }
67 }