1 pragma solidity ^0.4.11;
2 
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
19 
20 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
21 
22 contract token {
23     /* Public variables of the token */
24     string public standard = 'Token 0.1';
25     string public name;
26     string public symbol;
27     uint8 public decimals;
28     uint256 public totalSupply;
29 
30     /* This creates an array with all balances */
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     /* This generates a public event on the blockchain that will notify clients */
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     /* Initializes contract with initial supply tokens to the creator of the contract */
38     function token(
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
53         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
54         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
55         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
56         balanceOf[_to] += _value;                            // Add the same to the recipient
57         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
58     }
59 
60     /* Allow another contract to spend some tokens in your behalf */
61     function approve(address _spender, uint256 _value)
62         returns (bool success) {
63         allowance[msg.sender][_spender] = _value;
64         tokenRecipient spender = tokenRecipient(_spender);
65         return true;
66     }
67 
68     /* Approve and then comunicate the approved contract in a single tx */
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
80         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
81         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
82         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
83         balanceOf[_from] -= _value;                          // Subtract from the sender
84         balanceOf[_to] += _value;                            // Add the same to the recipient
85         allowance[_from][msg.sender] -= _value;
86         Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     /* This unnamed function is called whenever someone tries to send ether to it */
91     function () payable {
92         throw;     // Prevents accidental sending of ether
93     }
94 }
95 
96 contract MyAdvancedToken is owned, token {
97 
98     uint256 public sellPrice;
99     uint256 public buyPrice;
100     uint256 public totalSupply;
101 
102     mapping (address => bool) public frozenAccount;
103 
104     /* This generates a public event on the blockchain that will notify clients */
105     event FrozenFunds(address target, bool frozen);
106 
107     /* Initializes contract with initial supply tokens to the creator of the contract */
108     function MyAdvancedToken(
109         uint256 initialSupply,
110         string tokenName,
111         uint8 decimalUnits,
112         string tokenSymbol,
113         address centralMinter
114     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {
115         if(centralMinter != 0 ) owner = centralMinter;      // Sets the owner as specified (if centralMinter is not specified the owner is msg.sender)
116         balanceOf[owner] = initialSupply;                   // Give the owner all initial tokens
117     }
118 
119     /* Send coins */
120     function transfer(address _to, uint256 _value) {
121         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
122         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
123         if (frozenAccount[msg.sender]) throw;                // Check if frozen
124         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
125         balanceOf[_to] += _value;                            // Add the same to the recipient
126         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
127     }
128 
129 
130     /* A contract attempts to get the coins */
131     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
132         if (frozenAccount[_from]) throw;                        // Check if frozen
133         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
134         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
135         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
136         balanceOf[_from] -= _value;                          // Subtract from the sender
137         balanceOf[_to] += _value;                            // Add the same to the recipient
138         allowance[_from][msg.sender] -= _value;
139         Transfer(_from, _to, _value);
140         return true;
141     }
142 
143     function mintToken(address target, uint256 mintedAmount) onlyOwner {
144         balanceOf[target] += mintedAmount;
145         totalSupply += mintedAmount;
146         Transfer(0, this, mintedAmount);
147         Transfer(this, target, mintedAmount);
148     }
149 
150     function freezeAccount(address target, bool freeze) onlyOwner {
151         frozenAccount[target] = freeze;
152         FrozenFunds(target, freeze);
153     }
154 
155     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
156         sellPrice = newSellPrice;
157         buyPrice = newBuyPrice;
158     }
159 
160     function buy() payable {
161         uint amount = msg.value / buyPrice;                // calculates the amount
162         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
163         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
164         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
165         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
166     }
167 
168     function sell(uint256 amount) {
169         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
170         balanceOf[this] += amount;                         // adds the amount to owner's balance
171         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
172         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
173             throw;                                         // to do this last to avoid recursion attacks
174         } else {
175             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
176         }
177     }
178 }
179 
180 contract cashBackMintable is token {
181   uint256 tokensForWei;
182 
183   function cashBackMintable(
184     string tokenName,
185     uint8 decimalUnits,
186     string tokenSymbol,
187     uint256 _tokensForWei
188   )
189     token(0, tokenName, decimalUnits, tokenSymbol)
190   {
191     tokensForWei = _tokensForWei;
192   }
193 
194   function () public payable {
195     msg.sender.transfer(msg.value);
196 
197     uint amount = msg.value * tokensForWei;
198     if (amount > 0) {
199       balanceOf[msg.sender] += amount;
200       totalSupply += amount;
201       Transfer(0, msg.sender, amount);
202     }
203   }
204 }