1 pragma solidity ^0.4.10;
2 contract owned {
3 address public owner;
4 
5 function owned() {
6     owner = msg.sender;
7 }
8 
9 modifier onlyOwner {
10     if (msg.sender != owner) throw;
11     _;
12 }
13 
14 function transferOwnership(address newOwner) onlyOwner {
15     owner = newOwner;
16 }
17 }
18 
19 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
20 
21 contract token {
22 /* Public variables of the token */
23 string public standard = 'Token 0.1';
24 string public name;
25 string public symbol;
26 uint8 public decimals;
27 uint256 public totalSupply;
28     event Burn(address indexed from, uint256 value);
29 
30 /* This creates an array with all balances */
31 mapping (address => uint256) public balanceOf;
32 mapping (address => mapping (address => uint256)) public allowance;
33 
34 /* This generates a public event on the blockchain that will notify clients */
35 event Transfer(address indexed from, address indexed to, uint256 value);
36 
37 /* Initializes contract with initial supply tokens to the creator of the contract */
38 function token(
39     uint256 initialSupply,
40     string tokenName,
41     uint8 decimalUnits,
42     string tokenSymbol
43     ) {
44     balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
45     totalSupply = initialSupply;                        // Update total supply
46     name = tokenName;                                   // Set the name for display purposes
47     symbol = tokenSymbol;                               // Set the symbol for display purposes
48     decimals = decimalUnits;                            // Amount of decimals for display purposes
49 }
50 
51 /* Send coins */
52 function transfer(address _to, uint256 _value) {
53     if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
54     if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
55     balanceOf[msg.sender] -= _value;                     // Subtract from the sender
56     balanceOf[_to] += _value;                            // Add the same to the recipient
57     Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
58 }
59 
60 /* Allow another contract to spend some tokens in your behalf */
61 function approve(address _spender, uint256 _value)
62     returns (bool success) {
63     allowance[msg.sender][_spender] = _value;
64     return true;
65 }
66 
67 /* Approve and then communicate the approved contract in a single tx */
68 function approveAndCall(address _spender, uint256 _value, bytes _extraData)
69     returns (bool success) {    
70     tokenRecipient spender = tokenRecipient(_spender);
71     if (approve(_spender, _value)) {
72         spender.receiveApproval(msg.sender, _value, this, _extraData);
73         return true;
74     }
75 }
76 
77 /* A contract attempts to get the coins */
78 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
79     if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
80     if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
81     if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
82     balanceOf[_from] -= _value;                          // Subtract from the sender
83     balanceOf[_to] += _value;                            // Add the same to the recipient
84     allowance[_from][msg.sender] -= _value;
85     Transfer(_from, _to, _value);
86     return true;
87 }
88 
89 /* This unnamed function is called whenever someone tries to send ether to it */
90 function () {
91     throw;     // Prevents accidental sending of ether
92 }
93 }
94 
95 contract MyAdvancedToken is owned, token {
96 
97 uint256 public sellPrice;
98 uint256 public buyPrice;
99 
100 mapping (address => bool) public frozenAccount;
101 
102 /* This generates a public event on the blockchain that will notify clients */
103 event FrozenFunds(address target, bool frozen);
104 
105 /* Initializes contract with initial supply tokens to the creator of the contract */
106 function MyAdvancedToken(
107     uint256 initialSupply,
108     string tokenName,
109     uint8 decimalUnits,
110     string tokenSymbol
111 ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
112 
113 /* Send coins */
114 function transfer(address _to, uint256 _value) {
115     if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
116     if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
117     if (frozenAccount[msg.sender]) throw;                // Check if frozen
118     balanceOf[msg.sender] -= _value;                     // Subtract from the sender
119     balanceOf[_to] += _value;                            // Add the same to the recipient
120     Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
121 }
122 
123 
124 /* A contract attempts to get the coins */
125 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
126     if (frozenAccount[_from]) throw;                        // Check if frozen            
127     if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
128     if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
129     if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
130     balanceOf[_from] -= _value;                          // Subtract from the sender
131     balanceOf[_to] += _value;                            // Add the same to the recipient
132     allowance[_from][msg.sender] -= _value;
133     Transfer(_from, _to, _value);
134     return true;
135 }
136 
137 function mintToken(address target, uint256 mintedAmount) onlyOwner {
138     balanceOf[target] += mintedAmount;
139     totalSupply += mintedAmount;
140     Transfer(0, this, mintedAmount);
141     Transfer(this, target, mintedAmount);
142 }
143 
144 function freezeAccount(address target, bool freeze) onlyOwner {
145     frozenAccount[target] = freeze;
146     FrozenFunds(target, freeze);
147 }
148 function unfreezeAccount(address target, bool freeze) onlyOwner {
149     frozenAccount[target] = !freeze;
150     FrozenFunds(target, !freeze);
151 }
152 
153 
154 function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
155     sellPrice = newSellPrice;
156     buyPrice = newBuyPrice;
157 }
158 
159 function buy() payable {
160     uint amount = msg.value / buyPrice;                // calculates the amount
161     if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
162     balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
163     balanceOf[this] -= amount;                         // subtracts amount from seller's balance
164     Transfer(this, msg.sender, amount);                // execute an event reflecting the change
165 }
166 
167 function sell(uint256 amount) {
168     if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
169     balanceOf[this] += amount;                         // adds the amount to owner's balance
170     balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
171     if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
172         throw;                                         // to do this last to avoid recursion attacks
173     } else {
174         Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
175     }               
176 }
177     
178     function burn(uint256 _value) public returns (bool success) {        
179         require(balanceOf[msg.sender] >= _value);
180         balanceOf[msg.sender] -= _value;
181         totalSupply -= _value;
182         Burn(msg.sender, _value);        
183         return true;
184     }
185     
186     function burnFrom(address _from, uint256 _value) public returns (bool success) {        
187         require(balanceOf[_from] >= _value);
188         require(_value <= allowance[_from][msg.sender]);
189         balanceOf[_from] -= _value;
190         allowance[_from][msg.sender] -= _value;
191         totalSupply -= _value;
192         Burn(_from, _value);        
193         return true;
194     }
195 }