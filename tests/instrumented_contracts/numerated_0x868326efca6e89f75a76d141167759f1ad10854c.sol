1 pragma solidity ^0.4.2;
2 
3 /*   ObjectLedger Token    */
4 /*   Thanks  VB            */  
5 
6 
7 contract owned {
8     address public owner;
9 
10     function owned() {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         if (msg.sender != owner) throw;
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner {
20         owner = newOwner;
21     }
22 }
23 
24 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
25 
26 contract token {
27     /* Public variables of the token */
28     string public standard = 'Token 0.1';
29     string public name;
30     string public symbol;
31     uint8 public decimals;
32     uint256 public totalSupply;
33 
34     /* This creates an array with all balances */
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     /* This generates a public event on the blockchain that will notify clients */
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     /* Initializes contract with initial supply tokens to the creator of the contract */
42     function token(
43         uint256 initialSupply,
44         string tokenName,
45         uint8 decimalUnits,
46         string tokenSymbol
47         ) {
48         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
49         totalSupply = initialSupply;                        // Update total supply
50         name = tokenName;                                   // Set the name for display purposes
51         symbol = tokenSymbol;                               // Set the symbol for display purposes
52         decimals = decimalUnits;                            // Amount of decimals for display purposes
53     }
54 
55     /* Send coins */
56     function transfer(address _to, uint256 _value) {
57         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
58         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
59         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
60         balanceOf[_to] += _value;                            // Add the same to the recipient
61         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
62     }
63 
64     /* Allow another contract to spend some tokens in your behalf */
65     function approve(address _spender, uint256 _value)
66         returns (bool success) {
67         allowance[msg.sender][_spender] = _value;
68         return true;
69     }
70 
71     /* Approve and then communicate the approved contract in a single tx */
72     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
73         returns (bool success) {    
74         tokenRecipient spender = tokenRecipient(_spender);
75         if (approve(_spender, _value)) {
76             spender.receiveApproval(msg.sender, _value, this, _extraData);
77             return true;
78         }
79     }
80 
81     /* A contract attempts to get the coins */
82     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
83         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
84         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
85         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
86         balanceOf[_from] -= _value;                          // Subtract from the sender
87         balanceOf[_to] += _value;                            // Add the same to the recipient
88         allowance[_from][msg.sender] -= _value;
89         Transfer(_from, _to, _value);
90         return true;
91     }
92 
93     /* This unnamed function is called whenever someone tries to send ether to it */
94     function () {
95         throw;     // Prevents accidental sending of ether
96     }
97 }
98 
99 contract ObjectToken is owned, token {
100 
101     uint256 public sellPrice;
102     uint256 public buyPrice;
103 
104     mapping (address => bool) public frozenAccount;
105 
106     /* This generates a public event on the blockchain that will notify clients */
107     event FrozenFunds(address target, bool frozen);
108 
109     /* Initializes contract with initial supply tokens to the creator of the contract */
110     function ObjectToken(
111         uint256 initialSupply,
112         string tokenName,
113         uint8 decimalUnits,
114         string tokenSymbol
115     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
116 
117     /* Send coins */
118     function transfer(address _to, uint256 _value) {
119         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
120         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
121         if (frozenAccount[msg.sender]) throw;                // Check if frozen
122         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
123         balanceOf[_to] += _value;                            // Add the same to the recipient
124         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
125     }
126 
127 
128     /* A contract attempts to get the coins */
129     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
130         if (frozenAccount[_from]) throw;                        // Check if frozen            
131         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
132         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
133         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
134         balanceOf[_from] -= _value;                          // Subtract from the sender
135         balanceOf[_to] += _value;                            // Add the same to the recipient
136         allowance[_from][msg.sender] -= _value;
137         Transfer(_from, _to, _value);
138         return true;
139     }
140 
141     function mintToken(address target, uint256 mintedAmount) onlyOwner {
142         balanceOf[target] += mintedAmount;
143         totalSupply += mintedAmount;
144         Transfer(0, this, mintedAmount);
145         Transfer(this, target, mintedAmount);
146     }
147 
148     function freezeAccount(address target, bool freeze) onlyOwner {
149         frozenAccount[target] = freeze;
150         FrozenFunds(target, freeze);
151     }
152 
153     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
154         sellPrice = newSellPrice;
155         buyPrice = newBuyPrice;
156     }
157 
158     function buy() payable {
159         uint amount = msg.value / buyPrice;                // calculates the amount
160         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
161         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
162         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
163         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
164     }
165 
166     function sell(uint256 amount) {
167         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
168         balanceOf[this] += amount;                         // adds the amount to owner's balance
169         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
170         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
171             throw;                                         // to do this last to avoid recursion attacks
172         } else {
173             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
174         }               
175     }
176 }