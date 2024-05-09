1 pragma solidity ^0.4.6;
2 contract tokenRecipient { 
3     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract JaneToken {
6     /* Public variables of the Jane Career Coaching Token token */
7     string public standard = 'Jane 1.0';
8     string public name = 'JaneCareerCoachingToken';
9     string public symbol = 'JANE';
10     uint8 public decimals = 8;
11     uint256 public totalSupply = 10000000000000000;
12 
13     /* Creates an array with all balances */
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     /* Generates a public event on the blockchain that will notify clients */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /* Notifies clients about the amount burnt */
21     event Burn(address indexed from, uint256 value);
22 
23     /* Initializes contract with initial supply tokens to me */
24     function JaneToken() {
25         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
26     }
27 
28     /* Send coins */
29     function transfer(address _to, uint256 _value) {
30         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
31         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
32         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
33         balanceOf[msg.sender] -= _value;                        // Subtract from the sender
34         balanceOf[_to] += _value;                               // Add the same to the recipient
35         Transfer(msg.sender, _to, _value);                      // Notify anyone listening that this transfer took place
36     }
37 
38     /* Allow another contract to spend some tokens on my behalf */
39     function approve(address _spender, uint256 _value)
40         returns (bool success) {
41         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) revert();
42         allowance[msg.sender][_spender] = _value;
43         return true;
44     }
45 
46     /* Approve and then communicate the approved contract in a single tx */
47     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
48         returns (bool success) {
49         tokenRecipient spender = tokenRecipient(_spender);
50         if (approve(_spender, _value)) {
51             spender.receiveApproval(msg.sender, _value, this, _extraData);
52             return true;
53         }
54     }        
55 
56     /* A contract attempts to get the coins */
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
59         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
60         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
61         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
62         balanceOf[_from] -= _value;                              // Subtract from the sender
63         balanceOf[_to] += _value;                                // Add the same to the recipient
64         allowance[_from][msg.sender] -= _value;
65         Transfer(_from, _to, _value);
66         return true;
67     }
68 
69 	/* Burn Jane by User */
70     function burn(uint256 _value) returns (bool success) {
71         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
72         balanceOf[msg.sender] -= _value;                         // Subtract from the sender
73         totalSupply -= _value;                                   // Updates totalSupply
74         Burn(msg.sender, _value);
75         return true;
76     }
77 
78 	/* Burn Janes from Users */
79     function burnFrom(address _from, uint256 _value) returns (bool success) {
80         if (balanceOf[_from] < _value) revert();                // Check if the sender has enough
81         if (_value > allowance[_from][msg.sender]) revert();    // Check allowance
82         balanceOf[_from] -= _value;                             // Subtract from the sender
83         totalSupply -= _value;                                  // Updates totalSupply
84         Burn(_from, _value);
85         return true;
86     }
87 }