1 //ERC20 Token
2 pragma solidity ^0.4.2;
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
24     string public standard = "Riptide 0.2";//... fine? as the name? version 0.1, 1.0 etc..0.2
25     
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
78     /* A contract attempts _ to get the coins */
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
91     function () {
92         throw;     // Prevents accidental sending of ether
93     }
94 }
95 
96 contract MyAdvancedToken is owned, token {
97 
98     uint256 public sellPrice;
99     uint256 public buyPrice;
100 
101     mapping(address=>bool) public frozenAccount;
102 
103 
104     /* This generates a public event on the blockchain that will notify clients */
105     event FrozenFunds(address target, bool frozen);
106 
107     /* Initializes contract with initial supply tokens to the creator of the contract */
108     uint256 public constant initialSupply = 95000000 * 10**8;
109     uint8 public constant decimalUnits = 8;
110     string public tokenName = "Riptide";//fine
111     string public tokenSymbol = "RIPT";//fineyes
112     function MyAdvancedToken(    ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
113      /* Send coins */
114     function transfer(address _to, uint256 _value) {
115         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
116         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
117         if (frozenAccount[msg.sender]) throw;                // Check if frozen
118         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
119         balanceOf[_to] += _value;                            // Add the same to the recipient
120         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
121     }
122 
123 
124     /* A contract attempts to get the coins */
125     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
126         if (frozenAccount[_from]) throw;                        // Check if frozen
127         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
128         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
129         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
130         balanceOf[_from] -= _value;                          // Subtract from the sender
131         balanceOf[_to] += _value;                            // Add the same to the recipient
132         allowance[_from][msg.sender] -= _value;
133         Transfer(_from, _to, _value);
134         return true;
135     }
136 
137     function mintToken(address target, uint256 mintedAmount) onlyOwner {
138         balanceOf[target] += mintedAmount;
139         totalSupply += mintedAmount;
140         Transfer(0, this, mintedAmount);
141         Transfer(this, target, mintedAmount);
142     }
143 
144     function freezeAccount(address target, bool freeze) onlyOwner {
145         frozenAccount[target] = freeze;
146         FrozenFunds(target, freeze);
147     }
148 
149     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
150         sellPrice = newSellPrice;
151         buyPrice = newBuyPrice;
152     }
153 
154     function buy() payable {
155         uint amount = msg.value / buyPrice;                // calculates the amount
156         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
157         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
158         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
159         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
160     }
161 
162     function sell(uint256 amount) {
163         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
164         balanceOf[this] += amount;                         // adds the amount to owner's balance
165         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
166         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
167             throw;                                         // to do this last to avoid recursion attacks
168         } else {
169             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
170         }
171     }
172 }