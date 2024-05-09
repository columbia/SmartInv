1 pragma solidity ^0.4.2;
2 
3 contract mortal {
4     /* Define variable owner of the type address*/
5     address owner;
6 
7     /* this function is executed at initialization and sets the owner of the contract */
8     function mortal() { owner = msg.sender; }
9 
10     /* Function to recover the funds on the contract */
11     function kill() { if (msg.sender == owner) selfdestruct(owner); }
12 }
13 
14 contract owned {
15     address public owner;
16 
17     function owned() {
18         owner = msg.sender;
19     }
20 
21     modifier onlyOwner {
22         if (msg.sender != owner) throw;
23         _;
24     }
25 
26     function transferOwnership(address newOwner) onlyOwner {
27         owner = newOwner;
28     }
29 }
30 
31 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
32 
33 contract token {
34     /* Public variables of the token */
35     string public standard = 'Token 0.1';
36     string public name;
37     string public symbol;
38     uint8 public decimals;
39     uint256 public totalSupply;
40 
41     /* This creates an array with all balances */
42     mapping (address => uint256) public balanceOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45     /* This generates a public event on the blockchain that will notify clients */
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     /* Initializes contract with initial supply tokens to the creator of the contract */
49     function token(
50         uint256 initialSupply,
51         string tokenName,
52         uint8 decimalUnits,
53         string tokenSymbol
54         ) {
55         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
56         totalSupply = initialSupply;                        // Update total supply
57         name = tokenName;                                   // Set the name for display purposes
58         symbol = tokenSymbol;                               // Set the symbol for display purposes
59         decimals = decimalUnits;                            // Amount of decimals for display purposes
60     }
61 
62     /* Send coins */
63     function transfer(address _to, uint256 _value) {
64         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
65         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
66         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
67         balanceOf[_to] += _value;                            // Add the same to the recipient
68         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
69     }
70 
71     /* Allow another contract to spend some tokens in your behalf */
72     function approve(address _spender, uint256 _value)
73         returns (bool success) {
74         allowance[msg.sender][_spender] = _value;
75         tokenRecipient spender = tokenRecipient(_spender);
76         return true;
77     }
78 
79     /* Approve and then comunicate the approved contract in a single tx */
80     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
81         returns (bool success) {    
82         tokenRecipient spender = tokenRecipient(_spender);
83         if (approve(_spender, _value)) {
84             spender.receiveApproval(msg.sender, _value, this, _extraData);
85             return true;
86         }
87     }
88 
89     /* A contract attempts to get the coins */
90     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
91         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
92         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
93         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
94         balanceOf[_from] -= _value;                          // Subtract from the sender
95         balanceOf[_to] += _value;                            // Add the same to the recipient
96         allowance[_from][msg.sender] -= _value;
97         Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     /* This unnamed function is called whenever someone tries to send ether to it */
102     function () {
103         throw;     // Prevents accidental sending of ether
104     }
105 }
106 
107 contract MyAdvancedToken is owned, token, mortal {
108 
109     uint256 public sellPrice;
110     uint256 public buyPrice;
111     uint256 public totalSupply;
112 
113     mapping (address => bool) public frozenAccount;
114 
115     /* This generates a public event on the blockchain that will notify clients */
116     event FrozenFunds(address target, bool frozen);
117 
118     /* Initializes contract with initial supply tokens to the creator of the contract */
119     function MyAdvancedToken() token (1000000000, "Welfare Token Fund", 3, "WTF") {
120         owner = 0x00e199840Fe2a772282A770F9eAb2Ab3e6B0cbDe;      // Sets the owner as specified (if centralMinter is not specified the owner is msg.sender)
121         balanceOf[owner] = 1000000000;                   // Give the owner all initial tokens
122     }
123 
124     /* Send coins */
125     function transfer(address _to, uint256 _value) {
126         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
127         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
128         if (frozenAccount[msg.sender]) throw;                // Check if frozen
129         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
130         balanceOf[_to] += _value;                            // Add the same to the recipient
131         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
132     }
133 
134 
135     /* A contract attempts to get the coins */
136     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
137         if (frozenAccount[_from]) throw;                        // Check if frozen            
138         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
139         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
140         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
141         balanceOf[_from] -= _value;                          // Subtract from the sender
142         balanceOf[_to] += _value;                            // Add the same to the recipient
143         allowance[_from][msg.sender] -= _value;
144         Transfer(_from, _to, _value);
145         return true;
146     }
147 
148     function mintToken(address target, uint256 mintedAmount) onlyOwner {
149         balanceOf[target] += mintedAmount;
150         totalSupply += mintedAmount;
151         Transfer(0, this, mintedAmount);
152         Transfer(this, target, mintedAmount);
153     }
154 
155     function freezeAccount(address target, bool freeze) onlyOwner {
156         frozenAccount[target] = freeze;
157         FrozenFunds(target, freeze);
158     }
159 
160     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
161         sellPrice = newSellPrice;
162         buyPrice = newBuyPrice;
163     }
164 
165     function buy() payable {
166         uint amount = msg.value / buyPrice;                // calculates the amount
167         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
168         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
169         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
170         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
171     }
172 
173     function sell(uint256 amount) {
174         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
175         balanceOf[this] += amount;                         // adds the amount to owner's balance
176         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
177         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
178             throw;                                         // to do this last to avoid recursion attacks
179         } else {
180             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
181         }               
182     }
183 }