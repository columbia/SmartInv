1 pragma solidity ^0.4.2;
2 contract owned {
3     address public owner;
4 
5     function owned() {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         if (msg.sender != owner) throw;
11         _;
12     }
13 
14     function transferOwnership(address newOwner) onlyOwner {
15         owner = newOwner;
16     }
17 }
18 
19 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
20 
21 contract token {
22     /* Public variables of the token */
23     string public standard = 'Token 0.1';
24     string public name;
25     string public symbol;
26     uint8 public decimals;
27     uint256 public totalSupply;
28 
29     /* This creates an array with all balances */
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     /* This generates a public event on the blockchain that will notify clients */
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     /* Initializes contract with initial supply tokens to the creator of the contract */
37     function token(
38         uint256 initialSupply,
39         string tokenName,
40         uint8 decimalUnits,
41         string tokenSymbol
42         ) {
43         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
44         totalSupply = initialSupply;                        // Update total supply
45         name = tokenName;                                   // Set the name for display purposes
46         symbol = tokenSymbol;                               // Set the symbol for display purposes
47         decimals = decimalUnits;                            // Amount of decimals for display purposes
48     }
49 
50     /* Send coins */
51     function transfer(address _to, uint256 _value) {
52         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
53         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
54         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
55         balanceOf[_to] += _value;                            // Add the same to the recipient
56         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
57     }
58 
59     /* Allow another contract to spend some tokens in your behalf */
60     function approve(address _spender, uint256 _value)
61         returns (bool success) {
62         allowance[msg.sender][_spender] = _value;
63         return true;
64     }
65 
66     /* Approve and then communicate the approved contract in a single tx */
67     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
68         returns (bool success) {    
69         tokenRecipient spender = tokenRecipient(_spender);
70         if (approve(_spender, _value)) {
71             spender.receiveApproval(msg.sender, _value, this, _extraData);
72             return true;
73         }
74     }
75 
76     /* A contract attempts to get the coins */
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
78         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
79         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
80         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
81         balanceOf[_from] -= _value;                          // Subtract from the sender
82         balanceOf[_to] += _value;                            // Add the same to the recipient
83         allowance[_from][msg.sender] -= _value;
84         Transfer(_from, _to, _value);
85         return true;
86     }
87 
88     /* This unnamed function is called whenever someone tries to send ether to it */
89     function () {
90         throw;     // Prevents accidental sending of ether
91     }
92 }
93 
94 contract GoodKarma is owned, token {
95 
96     /* Initializes contract with initial supply tokens to the creator of the contract */
97     function GoodKarma(
98         uint256 initialSupply,
99         string tokenName,
100         uint8 decimalUnits,
101         string tokenSymbol
102     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
103 
104     /* Send coins */
105     function transfer(address _to, uint256 _value) {
106         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
107         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
108         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
109         balanceOf[_to] += _value;                            // Add the same to the recipient
110         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
111     }
112 
113 
114     /* A contract attempts to get the coins */
115     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {         
116         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
117         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
118         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
119         balanceOf[_from] -= _value;                          // Subtract from the sender
120         balanceOf[_to] += _value;                            // Add the same to the recipient
121         allowance[_from][msg.sender] -= _value;
122         Transfer(_from, _to, _value);
123         return true;
124     }
125 
126 }