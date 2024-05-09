1 pragma solidity ^0.4.8;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) throw;
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 contract MyToken is owned{
20     /* Public variables of the token */
21     string public standard = 'Token 0.1';
22     string public name;
23     string public symbol;
24     uint8 public decimals;
25     uint256 public totalSupply;
26 
27     /* This creates an array with all balances */
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     /* This generates a public event on the blockchain that will notify clients */
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     /* This notifies clients about the amount burnt */
35     event Burn(address indexed from, uint256 value);
36 
37     /* Initializes contract with initial supply tokens to the creator of the contract */
38     function MyToken(
39         uint256 initialSupply,
40         string tokenName,
41         uint8 decimalUnits,
42         string tokenSymbol
43         ) {
44         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
45         totalSupply = initialSupply;                        // Update total supply
46         name = tokenName;                                   // Set the name for display purposes
47         symbol = tokenSymbol;                               // Set the symbol for display purposes
48         decimals = decimalUnits;                            // Amount of decimals for display purposes
49     }
50 
51     /* Send coins */
52     function transfer(address _to, uint256 _value) {
53         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
54         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
55         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
56         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
57         balanceOf[_to] += _value;                            // Add the same to the recipient
58         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
59     }
60 
61     /* Allow another contract to spend some tokens in your behalf */
62     function approve(address _spender, uint256 _value)
63         returns (bool success) {
64         allowance[msg.sender][_spender] = _value;
65         return true;
66     }
67 
68     /* Approve and then communicate the approved contract in a single tx */
69     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
70         returns (bool success) {
71         tokenRecipient spender = tokenRecipient(_spender);
72         if (approve(_spender, _value)) {
73             spender.receiveApproval(msg.sender, _value, this, _extraData);
74             return true;
75         }
76     }        
77 
78     /* A contract attempts to get the coins */
79     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
80         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
81         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
82         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
83         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
84         balanceOf[_from] -= _value;                           // Subtract from the sender
85         balanceOf[_to] += _value;                             // Add the same to the recipient
86         allowance[_from][msg.sender] -= _value;
87         Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function burn(uint256 _value) returns (bool success) {
92         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
93         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
94         totalSupply -= _value;                                // Updates totalSupply
95         Burn(msg.sender, _value);
96         return true;
97     }
98 
99     function burnFrom(address _from, uint256 _value) returns (bool success) {
100         if (balanceOf[_from] < _value) throw;                // Check if the sender has enough
101         if (_value > allowance[_from][msg.sender]) throw;    // Check allowance
102         balanceOf[_from] -= _value;                          // Subtract from the sender
103         totalSupply -= _value;                               // Updates totalSupply
104         Burn(_from, _value);
105         return true;
106     }
107         function mintToken(address target, uint256 mintedAmount) onlyOwner {
108         balanceOf[target] += mintedAmount;
109         totalSupply += mintedAmount;
110         Transfer(0, owner, mintedAmount);
111         Transfer(owner, target, mintedAmount);
112     }
113 }