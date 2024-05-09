1 pragma solidity ^0.4.2;
2 contract owned {
3     address public owner;
4 
5     function owned() public{
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         if (msg.sender != owner) revert();
11         _;
12     }
13 
14     function transferOwnership(address newOwner) onlyOwner public {
15         owner = newOwner;
16     }
17 }
18 
19 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
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
41         ) public {
42         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
43         totalSupply = initialSupply;                        // Update total supply
44         name = tokenName;                                   // Set the name for display purposes
45         symbol = tokenSymbol;                               // Set the symbol for display purposes
46         decimals = decimalUnits;                            // Amount of decimals for display purposes
47     }
48 
49     /* Send coins */
50     function transfer(address _to, uint256 _value) public {
51         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
52         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
53         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
54         balanceOf[_to] += _value;                            // Add the same to the recipient
55         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
56     }
57 
58     /* Allow another contract to spend some tokens in your behalf */
59     function approve(address _spender, uint256 _value) public
60         returns (bool success) {
61         allowance[msg.sender][_spender] = _value;
62         return true;
63     }
64 
65     /* Approve and then communicate the approved contract in a single tx */
66     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public 
67         returns (bool success) {    
68         tokenRecipient spender = tokenRecipient(_spender);
69         if (approve(_spender, _value)) {
70             spender.receiveApproval(msg.sender, _value, this, _extraData);
71             return true;
72         }
73     }
74 
75     /* A contract attempts to get the coins */
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
78         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
79         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
80         balanceOf[_from] -= _value;                          // Subtract from the sender
81         balanceOf[_to] += _value;                            // Add the same to the recipient
82         allowance[_from][msg.sender] -= _value;
83         emit Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     /* This unnamed function is called whenever someone tries to send ether to it */
88     function () public {
89         revert();     // Prevents accidental sending of ether
90     }
91 }
92 
93 contract COOPET is owned, token {
94 
95     mapping (address => bool) public frozenAccount;
96 
97     /* This generates a public event on the blockchain that will notify clients */
98     event FrozenFunds(address target, bool frozen);
99 
100     /* Initializes contract with initial supply tokens to the creator of the contract */
101     function COOPET(
102         uint256 initialSupply,
103         string tokenName,
104         uint8 decimalUnits,
105         string tokenSymbol
106     ) public token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
107 
108     /* Send coins */
109     function transfer(address _to, uint256 _value) public {
110         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
111         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
112         if (frozenAccount[msg.sender]) revert();                // Check if frozen
113         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
114         balanceOf[_to] += _value;                            // Add the same to the recipient
115         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
116     }
117 
118     /* A contract attempts to get the coins */
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
120         if (frozenAccount[_from]) revert();                        // Check if frozen            
121         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
122         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
123         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
124         balanceOf[_from] -= _value;                          // Subtract from the sender
125         balanceOf[_to] += _value;                            // Add the same to the recipient
126         allowance[_from][msg.sender] -= _value;
127         emit Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     function mintToken(address target, uint256 mintedAmount) public onlyOwner {
132         balanceOf[target] += mintedAmount;
133         emit Transfer(0, owner, mintedAmount);
134         emit Transfer(owner, target, mintedAmount);
135     }
136 
137     function destroyToken(uint256 amount) public onlyOwner {
138         totalSupply -= amount;
139     }
140 
141     function freezeAccount(address target, bool freeze) public onlyOwner {
142         frozenAccount[target] = freeze;
143         emit FrozenFunds(target, freeze);
144     }
145 }