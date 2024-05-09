1 pragma solidity ^0.4.8;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract MyToken {
5     /* Public variables of the token */
6     string public standard = 'Token 0.1';
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11 
12     /* This creates an array with all balances */
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     /* This generates a public event on the blockchain that will notify clients */
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /* This notifies clients about the amount burnt */
20     event Burn(address indexed from, uint256 value);
21 
22     /* Initializes contract with initial supply tokens to the creator of the contract */
23     function MyToken(
24         uint256 initialSupply,
25         string tokenName,
26         uint8 decimalUnits,
27         string tokenSymbol
28         ) {
29         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
30         totalSupply = initialSupply;                        // Update total supply
31         name = tokenName;                                   // Set the name for display purposes
32         symbol = tokenSymbol;                               // Set the symbol for display purposes
33         decimals = decimalUnits;                            // Amount of decimals for display purposes
34     }
35 
36     /* Send coins */
37     function transfer(address _to, uint256 _value) {
38         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
39         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
40         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
41         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
42         balanceOf[_to] += _value;                            // Add the same to the recipient
43         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
44     }
45 
46     /* Allow another contract to spend some tokens in your behalf */
47     function approve(address _spender, uint256 _value)
48         returns (bool success) {
49         allowance[msg.sender][_spender] = _value;
50         return true;
51     }
52 
53     /* Approve and then communicate the approved contract in a single tx */
54     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
55         returns (bool success) {
56         tokenRecipient spender = tokenRecipient(_spender);
57         if (approve(_spender, _value)) {
58             spender.receiveApproval(msg.sender, _value, this, _extraData);
59             return true;
60         }
61     }        
62 
63     /* A contract attempts to get the coins */
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
65         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
66         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
67         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
68         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
69         balanceOf[_from] -= _value;                           // Subtract from the sender
70         balanceOf[_to] += _value;                             // Add the same to the recipient
71         allowance[_from][msg.sender] -= _value;
72         Transfer(_from, _to, _value);
73         return true;
74     }
75 
76     function burn(uint256 _value) returns (bool success) {
77         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
78         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
79         totalSupply -= _value;                                // Updates totalSupply
80         Burn(msg.sender, _value);
81         return true;
82     }
83 
84     function burnFrom(address _from, uint256 _value) returns (bool success) {
85         if (balanceOf[_from] < _value) throw;                // Check if the sender has enough
86         if (_value > allowance[_from][msg.sender]) throw;    // Check allowance
87         balanceOf[_from] -= _value;                          // Subtract from the sender
88         totalSupply -= _value;                               // Updates totalSupply
89         Burn(_from, _value);
90         return true;
91     }
92 }