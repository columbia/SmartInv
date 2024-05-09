1 pragma solidity ^0.4.11;
2 contract owned {
3   address public owner;
4 
5   function owned() {
6     owner = msg.sender;
7   }
8 
9   modifier onlyOwner {
10     if (msg.sender != owner) throw;
11     _;
12   }
13 
14   function transferOwnership(address newOwner) onlyOwner {
15     owner = newOwner;
16   }
17 }
18 
19 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
20 
21 contract token {
22   /* Public variables of the token */
23   string public standard = 'Token 0.1';
24   string public name;
25   string public symbol;
26   uint8 public decimals;
27   uint256 public totalSupply;
28 
29   /* This creates an array with all balances */
30   mapping (address => uint256) public balanceOf;
31   mapping (address => mapping (address => uint256)) public allowance;
32 
33   /* This generates a public event on the blockchain that will notify clients */
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 
36   /* Initializes contract with initial supply tokens to the creator of the contract */
37   function token(
38   uint256 initialSupply,
39   string tokenName,
40   uint8 decimalUnits,
41   string tokenSymbol
42   ) {
43     balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
44     totalSupply = initialSupply;                        // Update total supply
45     name = tokenName;                                   // Set the name for display purposes
46     symbol = tokenSymbol;                               // Set the symbol for display purposes
47     decimals = decimalUnits;                            // Amount of decimals for display purposes
48   }
49 
50   /* Send coins */
51   function transfer(address _to, uint256 _value) {
52     if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
53     if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
54     balanceOf[msg.sender] -= _value;                     // Subtract from the sender
55     balanceOf[_to] += _value;                            // Add the same to the recipient
56     Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
57   }
58 
59   /* Allow another contract to spend some tokens in your behalf */
60   function approve(address _spender, uint256 _value)
61   returns (bool success) {
62     allowance[msg.sender][_spender] = _value;
63     return true;
64   }
65 
66   /* Approve and then communicate the approved contract in a single tx */
67   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
68   returns (bool success) {
69     tokenRecipient spender = tokenRecipient(_spender);
70     if (approve(_spender, _value)) {
71       spender.receiveApproval(msg.sender, _value, this, _extraData);
72       return true;
73     }
74   }
75 
76   /* A contract attempts to get the coins */
77   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
78     if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
79     if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
80     if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
81     balanceOf[_from] -= _value;                          // Subtract from the sender
82     balanceOf[_to] += _value;                            // Add the same to the recipient
83     allowance[_from][msg.sender] -= _value;
84     Transfer(_from, _to, _value);
85     return true;
86   }
87 
88   /* This unnamed function is called whenever someone tries to send ether to it */
89   function () {
90     throw;     // Prevents accidental sending of ether
91   }
92 }
93 
94 contract MyBoToken is owned, token {
95 
96   uint256 public sellPrice;
97   uint256 public buyPrice;
98 
99   mapping (address => bool) public frozenAccount;
100 
101   /* This generates a public event on the blockchain that will notify clients */
102   event FrozenFunds(address target, bool frozen);
103 
104   /* This notifies clients about the amount burnt */
105   event Burn(address indexed from, uint256 value);
106 
107   /* Initializes contract with initial supply tokens to the creator of the contract */
108   function MyBoToken(
109   uint256 initialSupply,
110   string tokenName,
111   uint8 decimalUnits,
112   string tokenSymbol
113   ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
114 
115   /* Send coins */
116   function transfer(address _to, uint256 _value) {
117     if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
118     if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
119     if (frozenAccount[msg.sender]) throw;                // Check if frozen
120     balanceOf[msg.sender] -= _value;                     // Subtract from the sender
121     balanceOf[_to] += _value;                            // Add the same to the recipient
122     Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
123   }
124 
125 
126   /* A contract attempts to get the coins */
127   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
128     if (frozenAccount[_from]) throw;                        // Check if frozen
129     if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
130     if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
131     if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
132     balanceOf[_from] -= _value;                          // Subtract from the sender
133     balanceOf[_to] += _value;                            // Add the same to the recipient
134     allowance[_from][msg.sender] -= _value;
135     Transfer(_from, _to, _value);
136     return true;
137   }
138 
139   function mintToken(address target, uint256 mintedAmount) onlyOwner {
140     balanceOf[target] += mintedAmount;
141     totalSupply += mintedAmount;
142     Transfer(0, this, mintedAmount);
143     Transfer(this, target, mintedAmount);
144   }
145 
146   function freezeAccount(address target, bool freeze) onlyOwner {
147     frozenAccount[target] = freeze;
148     FrozenFunds(target, freeze);
149   }
150 
151   function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
152     sellPrice = newSellPrice;
153     buyPrice = newBuyPrice;
154   }
155 
156   function buy() payable {
157     uint amount = msg.value / buyPrice;                // calculates the amount
158     if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
159     balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
160     balanceOf[this] -= amount;                         // subtracts amount from seller's balance
161     Transfer(this, msg.sender, amount);                // execute an event reflecting the change
162   }
163 
164   function sell(uint256 amount) {
165     if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
166     balanceOf[this] += amount;                         // adds the amount to owner's balance
167     balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
168     if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
169       throw;                                         // to do this last to avoid recursion attacks
170     } else {
171       Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
172     }
173   }
174 
175   function burn(uint256 amount) onlyOwner returns (bool success) {
176     if (balanceOf[msg.sender] < amount) throw;            // Check if the sender has enough
177     balanceOf[msg.sender] -= amount;                      // Subtract from the sender
178     totalSupply -= amount;                                // Updates totalSupply
179     Burn(msg.sender, amount);
180     return true;
181   }
182 
183 }