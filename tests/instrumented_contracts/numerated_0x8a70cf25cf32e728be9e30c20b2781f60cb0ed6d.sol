1 pragma solidity ^0.4.2;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract MyToken {
5     /* Public variables of the token */
6     string public standard = 'Token 0.1';
7     string public name;
8     string public symbol;
9     uint8 public decimals = 0;
10     uint256 public totalSupply;
11 
12     /* This creates an array with all balances */
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     /* This generates a public event on the blockchain that will notify clients */
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /* Initializes contract with initial supply tokens to the creator of the contract */
20     function MyToken() {
21         balanceOf[msg.sender] = 100000;              // Give the creator all initial tokens
22         totalSupply = 100000;                        // Update total supply
23         name = "TESTBtfund.ru";                                   // Set the name for display purposes
24         symbol = "TST";                               // Set the symbol for display purposes
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
36 
37     /* Allow another contract to spend some tokens in your behalf */
38     function approve(address _spender, uint256 _value)
39         returns (bool success) {
40         allowance[msg.sender][_spender] = _value;
41         return true;
42     }
43 
44     /* Approve and then comunicate the approved contract in a single tx */
45     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
46         returns (bool success) {
47         tokenRecipient spender = tokenRecipient(_spender);
48         if (approve(_spender, _value)) {
49             spender.receiveApproval(msg.sender, _value, this, _extraData);
50             return true;
51         }
52     }        
53 
54     /* A contract attempts to get the coins */
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
57         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
58         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
59         balanceOf[_from] -= _value;                          // Subtract from the sender
60         balanceOf[_to] += _value;                            // Add the same to the recipient
61         allowance[_from][msg.sender] -= _value;
62         Transfer(_from, _to, _value);
63         return true;
64     }
65 
66     /* This unnamed function is called whenever someone tries to send ether to it */
67     function () {
68         throw;     // Prevents accidental sending of ether
69     }
70 }