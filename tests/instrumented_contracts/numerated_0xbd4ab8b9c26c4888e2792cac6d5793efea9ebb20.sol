1 pragma solidity ^0.4.2;
2 contract owned {
3     address public owner;
4 
5     function owned() {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         if (msg.sender != owner) revert();
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
23     string public name;
24     string public symbol;
25     uint8 public decimals;
26     uint256 public totalSupply;
27 
28     /* This creates an array with all balances */
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     /* This generates a public event on the blockchain that will notify clients */
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     /* Initializes contract with initial supply tokens to the creator of the contract */
36     function token(
37         uint256 initialSupply,
38         string tokenName,
39         uint8 decimalUnits,
40         string tokenSymbol
41         ) {
42         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
43         totalSupply = initialSupply;                        // Update total supply
44         name = tokenName;                                   // Set the name for display purposes
45         symbol = tokenSymbol;                               // Set the symbol for display purposes
46         decimals = decimalUnits;                            // Amount of decimals for display purposes
47     }
48 
49     /* Send coins */
50     function transfer(address _to, uint256 _value) {
51         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
52         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
53         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
54         balanceOf[_to] += _value;                            // Add the same to the recipient
55         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
56     }
57 
58     /* Allow another contract to spend some tokens in your behalf */
59     function approve(address _spender, uint256 _value)
60         returns (bool success) {
61         allowance[msg.sender][_spender] = _value;
62         return true;
63     }
64 
65     /* Approve and then communicate the approved contract in a single tx */
66     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
67         returns (bool success) {    
68         tokenRecipient spender = tokenRecipient(_spender);
69         if (approve(_spender, _value)) {
70             spender.receiveApproval(msg.sender, _value, this, _extraData);
71             return true;
72         }
73     }
74 
75     /* A contract attempts to get the coins */
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
78         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
79         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
80         balanceOf[_from] -= _value;                          // Subtract from the sender
81         balanceOf[_to] += _value;                            // Add the same to the recipient
82         allowance[_from][msg.sender] -= _value;
83         Transfer(_from, _to, _value);
84         return true;
85     }
86 
87 }
88 
89 contract KRTY is owned, token {
90 
91     mapping (address => bool) public frozenAccount;
92 
93     /* This generates a public event on the blockchain that will notify clients */
94     event FrozenFunds(address target, bool frozen);
95 
96     /* Initializes contract with initial supply tokens to the creator of the contract */
97     function KRTY(
98         uint256 initialSupply,
99         string tokenName,
100         uint8 decimalUnits,
101         string tokenSymbol
102     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
103 
104     /* Send coins */
105     function transfer(address _to, uint256 _value) {
106         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
107         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
108         if (frozenAccount[msg.sender]) revert();                // Check if frozen
109         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
110         balanceOf[_to] += _value;                            // Add the same to the recipient
111         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
112     }
113 
114     /* A contract attempts to get the coins */
115     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
116         if (frozenAccount[_from]) revert();                        // Check if frozen            
117         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
118         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
119         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
120         balanceOf[_from] -= _value;                          // Subtract from the sender
121         balanceOf[_to] += _value;                            // Add the same to the recipient
122         allowance[_from][msg.sender] -= _value;
123         Transfer(_from, _to, _value);
124         return true;
125     }
126 
127     function freezeAccount(address target, bool freeze) onlyOwner {
128         frozenAccount[target] = freeze;
129         FrozenFunds(target, freeze);
130     }
131     
132     // transfer balance to owner
133 	function withdrawEther(uint256 amount) {
134 		if(msg.sender != owner)throw;
135 		owner.transfer(amount);
136 	}
137 	
138 	// can accept ether
139 	function() payable {
140     }
141 }