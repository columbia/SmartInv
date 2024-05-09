1 pragma solidity ^0.4.8;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract PupToken {
5     /* Public variables of the token */
6     string public standard = 'Token 0.1';
7     uint256 public totalSupply = 100000000;
8 
9     /* This creates an array with all balances */
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     /* This generates a public event on the blockchain that will notify clients */
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16 
17     function name() constant returns (string) { return "PupToken"; }
18     function symbol() constant returns (string) { return "PUP"; }
19     function decimals() constant returns (uint8) { return 0; }	
20 	
21     /* Initializes contract with initial supply tokens to the creator of the contract */
22     function PupToken() {
23         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
24     }
25 
26     /* Send coins */
27     function transfer(address _to, uint256 _value) {
28         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
29         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
30         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
31         balanceOf[_to] += _value;                            // Add the same to the recipient
32         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
33     }
34 
35     /* Allow another contract to spend some tokens in your behalf */
36     function approve(address _spender, uint256 _value)
37         returns (bool success) {
38         allowance[msg.sender][_spender] = _value;
39         return true;
40     }
41 
42     /* Approve and then communicate the approved contract in a single tx */
43     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
44         returns (bool success) {
45         tokenRecipient spender = tokenRecipient(_spender);
46         if (approve(_spender, _value)) {
47             spender.receiveApproval(msg.sender, _value, this, _extraData);
48             return true;
49         }
50     }        
51 
52     /* A contract attempts to get the coins */
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
54         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
55         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
56         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
57         balanceOf[_from] -= _value;                           // Subtract from the sender
58         balanceOf[_to] += _value;                             // Add the same to the recipient
59         allowance[_from][msg.sender] -= _value;
60         Transfer(_from, _to, _value);
61         return true;
62     }
63 
64 }