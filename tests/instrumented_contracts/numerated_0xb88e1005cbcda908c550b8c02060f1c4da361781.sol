1 pragma solidity ^0.4.11;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract MyToken {
6     /* Public variables of the token */
7     string public standard = 'Token 0.1';
8     string public name;
9     string public symbol;
10     uint8 public decimals;
11     uint256 public totalSupply;
12 
13     /* This creates an array with all balances */
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     /* This generates a public event on the blockchain that will notify clients */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /* This notifies clients about the amount burnt */
21     event Burn(address indexed from, uint256 value);
22 
23     /* Initializes contract with initial supply tokens to the creator of the contract */
24     function MyToken(
25         uint256 initialSupply,
26         string tokenName,
27         uint8 decimalUnits,
28         string tokenSymbol
29         ) {
30         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
31         totalSupply = initialSupply;                        // Update total supply
32         name = tokenName;                                   // Set the name for display purposes
33         symbol = tokenSymbol;                               // Set the symbol for display purposes
34         decimals = decimalUnits;                            // Amount of decimals for display purposes
35     }
36 
37     /* Send coins */
38     function transfer(address _to, uint256 _value) {
39         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
40         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
41         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
42         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
43         balanceOf[_to] += _value;                            // Add the same to the recipient
44         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
45     }
46 
47     /* Allow another contract to spend some tokens in your behalf */
48     function approve(address _spender, uint256 _value)
49         returns (bool success) {
50         allowance[msg.sender][_spender] = _value;
51         return true;
52     }
53 
54     /* Approve and then communicate the approved contract in a single tx */
55     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
56         returns (bool success) {
57         tokenRecipient spender = tokenRecipient(_spender);
58         if (approve(_spender, _value)) {
59             spender.receiveApproval(msg.sender, _value, this, _extraData);
60             return true;
61         }
62     }        
63 
64     /* A contract attempts to get the coins */
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
67         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
68         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
69         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
70         balanceOf[_from] -= _value;                           // Subtract from the sender
71         balanceOf[_to] += _value;                             // Add the same to the recipient
72         allowance[_from][msg.sender] -= _value;
73         Transfer(_from, _to, _value);
74         return true;
75     }
76 
77     function burn(uint256 _value) returns (bool success) {
78         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
79         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
80         totalSupply -= _value;                                // Updates totalSupply
81         Burn(msg.sender, _value);
82         return true;
83     }
84 
85     function burnFrom(address _from, uint256 _value) returns (bool success) {
86         if (balanceOf[_from] < _value) throw;                // Check if the sender has enough
87         if (_value > allowance[_from][msg.sender]) throw;    // Check allowance
88         balanceOf[_from] -= _value;                          // Subtract from the sender
89         totalSupply -= _value;                               // Updates totalSupply
90         Burn(_from, _value);
91         return true;
92     }
93 }