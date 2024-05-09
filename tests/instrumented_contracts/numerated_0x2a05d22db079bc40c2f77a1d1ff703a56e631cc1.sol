1 pragma solidity ^0.4.13;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) revert();
12         _;
13     }
14 
15 }
16 
17 contract tokenRecipient { 
18     
19     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
20     
21 }
22 
23 contract token {
24     
25     /* Public variables of the token */ 
26     string public name;
27     string public symbol;
28     uint8 public decimals;
29     uint256 public totalSupply;
30 
31     /* This creates an array with all balances */
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     /* This generates a public event on the blockchain that will notify clients */
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     /* Initializes contract with initial supply tokens to the creator of the contract */
39     function token(
40         uint256 initialSupply,
41         string tokenName,
42         uint8 decimalUnits,
43         string tokenSymbol
44         ) {
45         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
46         totalSupply = initialSupply;                        // Update total supply
47         name = tokenName;                                   // Set the name for display purposes
48         symbol = tokenSymbol;                               // Set the symbol for display purposes
49         decimals = decimalUnits;                            // Amount of decimals for display purposes
50     }
51 
52     /* Send coins */
53     function transfer(address _to, uint256 _value) {
54         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
55         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
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
78     /* A contract attempts to get the coins e.g. exchange transfer our token */
79     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
80         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
81         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
82         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
83         balanceOf[_from] -= _value;                          // Subtract from the sender
84         balanceOf[_to] += _value;                            // Add the same to the recipient
85         allowance[_from][msg.sender] -= _value;
86         Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     /* This unnamed function is called whenever someone tries to send ether to it */
91     function () {
92         revert();     // Prevents accidental sending of ether
93     }
94 }
95 
96 contract BitAseanToken is owned, token { 
97  
98     mapping (address => bool) public frozenAccount;
99 
100     /* This generates a public event on the blockchain that will notify clients */
101     event FrozenFunds(address target, bool frozen);
102 
103     /* Initializes contract with initial supply tokens to the creator of the contract */
104     function BitAseanToken(
105         uint256 initialSupply,
106         string tokenName,
107         uint8 decimalUnits,
108         string tokenSymbol
109     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {  
110     }
111 
112     /* Send coins */
113     function transfer(address _to, uint256 _value) {
114         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
115         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
116         if (frozenAccount[msg.sender]) revert();                // Check if frozen
117         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
118         balanceOf[_to] += _value;                            // Add the same to the recipient
119         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
120     }
121 
122 
123     /* A contract attempts to get the coins */
124     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
125         if (frozenAccount[_from]) revert();                        // Check if frozen            
126         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
127         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
128         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
129         balanceOf[_from] -= _value;                          // Subtract from the sender
130         balanceOf[_to] += _value;                            // Add the same to the recipient
131         allowance[_from][msg.sender] -= _value;
132         Transfer(_from, _to, _value);
133         return true;
134     }
135 
136     function mintToken(address target, uint256 mintedAmount) onlyOwner {
137         balanceOf[target] += mintedAmount;
138         totalSupply += mintedAmount;
139         Transfer(0, this, mintedAmount);
140         Transfer(this, target, mintedAmount);
141     }
142 
143     function freezeAccount(address target, bool freeze) onlyOwner {
144         frozenAccount[target] = freeze;
145         FrozenFunds(target, freeze);
146     }
147 
148 
149 }