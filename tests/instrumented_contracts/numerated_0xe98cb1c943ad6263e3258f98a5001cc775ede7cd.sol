1 pragma solidity ^0.4.8;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract Medikey {
5     /* Public variables of the token */
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
18     /* This notifies clients about the amount burnt */
19     event Burn(address indexed from, uint256 value);
20 
21     /* Initializes contract with initial supply tokens to the creator of the contract */
22     function Medikey(
23         uint256 initialSupply,
24         string tokenName,
25         uint8 decimalUnits,
26         string tokenSymbol
27         ) {
28         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
29         totalSupply = initialSupply;                        // Update total supply
30         name = tokenName;                                   // Set the name for display purposes
31         symbol = tokenSymbol;                               // Set the symbol for display purposes
32         decimals = decimalUnits;                            // Amount of decimals for display purposes
33     }
34 
35     /* Send coins */
36     function transfer(address _to, uint256 _value) {
37         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
38         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
39         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
40         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
41         balanceOf[_to] += _value;                            // Add the same to the recipient
42         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
43     }
44 
45     /* Allow another contract to spend some tokens in your behalf */
46     function approve(address _spender, uint256 _value)
47         returns (bool success) {
48         allowance[msg.sender][_spender] = _value;
49         return true;
50     }
51 
52     /* Approve and then communicate the approved contract in a single tx */
53     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
54         returns (bool success) {
55         tokenRecipient spender = tokenRecipient(_spender);
56         if (approve(_spender, _value)) {
57             spender.receiveApproval(msg.sender, _value, this, _extraData);
58             return true;
59         }
60     }        
61 
62     /* A contract attempts to get the coins */
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
64         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
65         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
66         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
67         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
68         balanceOf[_from] -= _value;                           // Subtract from the sender
69         balanceOf[_to] += _value;                             // Add the same to the recipient
70         allowance[_from][msg.sender] -= _value;
71         Transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function burn(uint256 _value) returns (bool success) {
76         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
77         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
78         totalSupply -= _value;                                // Updates totalSupply
79         Burn(msg.sender, _value);
80         return true;
81     }
82 
83     function burnFrom(address _from, uint256 _value) returns (bool success) {
84         if (balanceOf[_from] < _value) throw;                // Check if the sender has enough
85         if (_value > allowance[_from][msg.sender]) throw;    // Check allowance
86         balanceOf[_from] -= _value;                          // Subtract from the sender
87         totalSupply -= _value;                               // Updates totalSupply
88         Burn(_from, _value);
89         return true;
90     }
91 }