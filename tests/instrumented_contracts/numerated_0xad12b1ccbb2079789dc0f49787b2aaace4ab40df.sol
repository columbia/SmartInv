1 pragma solidity ^0.4.13;
2 contract owned {
3   address public owner;
4 
5   function owned() {
6     owner = msg.sender;
7   }
8 
9   modifier onlyOwner {
10     assert(msg.sender == owner);
11     _;
12   }
13 
14   function transferOwnership(address newOwner) onlyOwner {
15     owner = newOwner;
16   }
17 }
18 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
19 
20 contract token {
21   /* Public variables of the token */
22   string public standard = 'Token 0.1';
23   string public name;
24   string public symbol;
25   uint8 public decimals;
26   uint256 public totalSupply;
27 
28   /* This creates an array with all balances */
29   mapping (address => uint256) public balanceOf;
30   mapping (address => mapping (address => uint256)) public allowance;
31 
32   /* This generates a public event on the blockchain that will notify clients */
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 
35   /* Initializes contract with initial supply tokens to the creator of the contract */
36   function token(
37   uint256 initialSupply,
38   string tokenName,
39   uint8 decimalUnits,
40   string tokenSymbol
41   ) {
42     balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
43     totalSupply = initialSupply;                        // Update total supply
44     name = tokenName;                                   // Set the name for display purposes
45     symbol = tokenSymbol;                               // Set the symbol for display purposes
46     decimals = decimalUnits;                            // Amount of decimals for display purposes
47   }
48 
49   /* Send coins */
50   function transfer(address _to, uint256 _value) {
51     assert (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
52     assert (balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
53     balanceOf[msg.sender] -= _value;                     // Subtract from the sender
54     balanceOf[_to] += _value;                            // Add the same to the recipient
55     Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
56   }
57 
58   /* Allow another contract to spend some tokens in your behalf */
59   function approve(address _spender, uint256 _value)
60   returns (bool success) {
61     allowance[msg.sender][_spender] = _value;
62     return true;
63   }
64 
65   /* Approve and then communicate the approved contract in a single tx */
66   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
67   returns (bool success) {
68     tokenRecipient spender = tokenRecipient(_spender);
69     if (approve(_spender, _value)) {
70       spender.receiveApproval(msg.sender, _value, this, _extraData);
71       return true;
72     }
73   }
74 
75   /* A contract attempts to get the coins */
76   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77     assert (balanceOf[_from] >= _value);                 // Check if the sender has enough
78     assert (balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
79     assert (_value <= allowance[_from][msg.sender]);     // Check allowance
80     balanceOf[_from] -= _value;                          // Subtract from the sender
81     balanceOf[_to] += _value;                            // Add the same to the recipient
82     allowance[_from][msg.sender] -= _value;
83     Transfer(_from, _to, _value);
84     return true;
85   }
86 
87   /* This unnamed function is called whenever someone tries to send ether to it */
88   function () {
89     assert(false);     // Prevents accidental sending of ether
90   }
91 }
92 
93 contract YLCToken is owned, token {
94 
95   uint256 public sellPrice;
96   uint256 public buyPrice;
97 
98   mapping (address => bool) public frozenAccount;
99 
100   /* This generates a public event on the blockchain that will notify clients */
101   event FrozenFunds(address target, bool frozen);
102 
103   /* This notifies clients about the amount burnt */
104   event Burn(address indexed from, uint256 value);
105 
106   /* Initializes contract with initial supply tokens to the creator of the contract */
107   function YLCToken(
108   uint256 initialSupply,
109   string tokenName,
110   uint8 decimalUnits,
111   string tokenSymbol
112   ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
113 
114   /* Send coins */
115   function transfer(address _to, uint256 _value) {
116     assert (balanceOf[msg.sender] >= _value);           // Check if the sender has enough
117     assert (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
118     assert (!frozenAccount[msg.sender]);                // Check if frozen
119     balanceOf[msg.sender] -= _value;                     // Subtract from the sender
120     balanceOf[_to] += _value;                            // Add the same to the recipient
121     Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
122   }
123 
124 
125   /* A contract attempts to get the coins */
126   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
127     assert (!frozenAccount[_from]);                      // Check if frozen
128     assert (balanceOf[_from] >= _value);                 // Check if the sender has enough
129     assert (balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
130     assert (_value <= allowance[_from][msg.sender]);     // Check allowance
131     balanceOf[_from] -= _value;                          // Subtract from the sender
132     balanceOf[_to] += _value;                            // Add the same to the recipient
133     allowance[_from][msg.sender] -= _value;
134     Transfer(_from, _to, _value);
135     return true;
136   }
137 
138   function mintToken(address target, uint256 mintedAmount) onlyOwner {
139     balanceOf[target] += mintedAmount;
140     totalSupply += mintedAmount;
141     Transfer(0, this, mintedAmount);
142     Transfer(this, target, mintedAmount);
143   }
144 
145   function freezeAccount(address target, bool freeze) onlyOwner {
146     frozenAccount[target] = freeze;
147     FrozenFunds(target, freeze);
148   }
149 
150   function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
151     sellPrice = newSellPrice;
152     buyPrice = newBuyPrice;
153   }
154 
155   function buy() payable {
156     uint amount = msg.value / buyPrice;                // calculates the amount
157     assert (balanceOf[this] >= amount);                // checks if it has enough to sell
158     balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
159     balanceOf[this] -= amount;                         // subtracts amount from seller's balance
160     Transfer(this, msg.sender, amount);                // execute an event reflecting the change
161   }
162 
163   function sell(uint256 amount) {
164     assert (balanceOf[msg.sender] >= amount );         // checks if the sender has enough to sell
165     balanceOf[this] += amount;                         // adds the amount to owner's balance
166     balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
167     assert (msg.sender.send(amount * sellPrice));      // sends ether to the seller. It's important
168                                                        // to do this last to avoid recursion attacks
169     Transfer(msg.sender, this, amount);                // executes an event reflecting on the change
170   }
171 
172   function burn(uint256 amount) onlyOwner returns (bool success) {
173     assert (balanceOf[msg.sender] >= amount);             // Check if the sender has enough
174     balanceOf[msg.sender] -= amount;                      // Subtract from the sender
175     totalSupply -= amount;                                // Updates totalSupply
176     Burn(msg.sender, amount);
177     return true;
178   }
179 
180 }