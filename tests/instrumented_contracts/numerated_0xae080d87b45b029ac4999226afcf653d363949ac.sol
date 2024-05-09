1 pragma solidity ^0.4.16;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract BerithCoin {
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
24 
25     function BerithCoin(uint256 initialSupply) {
26         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
27         totalSupply = initialSupply;                        // Update total supply
28         name = "Berith";                                   // Set the name for display purposes
29         symbol = "BRT";                               // Set the symbol for display purposes
30         decimals = 8;                            // Amount of decimals for display purposes
31     }
32 
33     /* Send coins */
34     function transfer(address _to, uint256 _value) {
35         if (_to == 0x0) return;                               // Prevent transfer to 0x0 address. Use burn() instead
36         if (balanceOf[msg.sender] < _value) return;           // Check if the sender has enough
37         if (balanceOf[_to] + _value < balanceOf[_to]) return; // Check for overflows
38         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
39         balanceOf[_to] += _value;                            // Add the same to the recipient
40         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
41     }
42 
43     /* Allow another contract to spend some tokens in your behalf */
44     function approve(address _spender, uint256 _value)
45         returns (bool success) {
46         allowance[msg.sender][_spender] = _value;
47         return true;
48     }
49 
50     /* Approve and then communicate the approved contract in a single tx */
51     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
52         returns (bool success) {
53         tokenRecipient spender = tokenRecipient(_spender);
54         if (approve(_spender, _value)) {
55             spender.receiveApproval(msg.sender, _value, this, _extraData);
56             return true;
57         }
58     }        
59 
60     /* A contract attempts to get the coins */
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
62         if (_to == 0x0) return false;                                // Prevent transfer to 0x0 address. Use burn() instead
63         if (balanceOf[_from] < _value) return false;                 // Check if the sender has enough
64         if (balanceOf[_to] + _value < balanceOf[_to]) return false;  // Check for overflows
65         if (_value > allowance[_from][msg.sender]) return false;     // Check allowance
66         balanceOf[_from] -= _value;                           // Subtract from the sender
67         balanceOf[_to] += _value;                             // Add the same to the recipient
68         allowance[_from][msg.sender] -= _value;
69         Transfer(_from, _to, _value);
70         return true;
71     }
72 
73     function burn(uint256 _value) returns (bool success) {
74         if (balanceOf[msg.sender] < _value) return false;            // Check if the sender has enough
75         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
76         totalSupply -= _value;                                // Updates totalSupply
77         Burn(msg.sender, _value);
78         return true;
79     }
80 
81     function burnFrom(address _from, uint256 _value) returns (bool success) {
82         if (balanceOf[_from] < _value) return false;                // Check if the sender has enough
83         if (_value > allowance[_from][msg.sender]) return false;    // Check allowance
84         balanceOf[_from] -= _value;                          // Subtract from the sender
85         totalSupply -= _value;                               // Updates totalSupply
86         Burn(_from, _value);
87         return true;
88     }
89 }