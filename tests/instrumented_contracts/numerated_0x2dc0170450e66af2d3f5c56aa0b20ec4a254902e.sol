1 pragma solidity ^0.4.6;
2 contract owned {
3     address public owner;
4 
5     function owned() {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         if (msg.sender != owner) throw;
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
23     string public standard = 'Token 0.1';
24     string public name;
25     string public symbol;
26     uint8 public decimals;
27     uint256 public totalSupply;
28 
29     /* This creates an array with all balances */
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     /* This generates a public event on the blockchain that will notify clients */
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     /* Initializes contract with initial supply tokens to the creator of the contract */
37     function token(
38         uint256 initialSupply,
39         string tokenName,
40         uint8 decimalUnits,
41         string tokenSymbol
42         ) {
43         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
44         totalSupply = initialSupply;                        // Update total supply
45         name = tokenName;                                   // Set the name for display purposes
46         symbol = tokenSymbol;                               // Set the symbol for display purposes
47         decimals = decimalUnits;                            // Amount of decimals for display purposes
48     }
49 
50     /* Send coins */
51     function transfer(address _to, uint256 _value) {
52         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
53         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
54         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
55         balanceOf[_to] += _value;                            // Add the same to the recipient
56         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
57     }
58 
59     /* Allow another contract to spend some tokens in your behalf */
60     function approve(address _spender, uint256 _value)
61         returns (bool success) {
62         allowance[msg.sender][_spender] = _value;
63         tokenRecipient spender = tokenRecipient(_spender);
64         return true;
65     }
66 
67     /* Approve and then comunicate the approved contract in a single tx */
68     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
69         returns (bool success) {    
70         tokenRecipient spender = tokenRecipient(_spender);
71         if (approve(_spender, _value)) {
72             spender.receiveApproval(msg.sender, _value, this, _extraData);
73             return true;
74         }
75     }
76 
77     /* A contract attempts to get the coins */
78     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
79         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
80         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
81         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
82         balanceOf[_from] -= _value;                          // Subtract from the sender
83         balanceOf[_to] += _value;                            // Add the same to the recipient
84         allowance[_from][msg.sender] -= _value;
85         Transfer(_from, _to, _value);
86         return true;
87     }
88 
89     /* This unnamed function is called whenever someone tries to send ether to it */
90     function () {
91         throw;     // Prevents accidental sending of ether
92     }
93 }
94 
95 contract MyAdvancedToken is owned, token {
96 
97     uint256 public buyPrice;
98     uint256 public totalSupply;
99     uint256 public claim;
100     bool public claimStatus;
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
155     function setPrices(uint256 newBuyPrice) onlyOwner {
156         buyPrice = newBuyPrice;
157     }
158 
159     function buy() payable {
160         uint amount = msg.value / buyPrice;                // calculates the amount
161         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
162         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
163         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
164         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
165     }
166 
167     /* Insurance claim data */
168     
169     function setClaim(uint256 _claim)  onlyOwner{
170         claim = _claim;
171     }
172     
173     function claimAmount() returns (uint256) {
174         return claim;
175     }
176     
177     function setClaimStatus(bool _status) onlyOwner {
178         claimStatus = _status;
179     }
180     
181     function getClaimStatus() returns (bool) {
182         return claimStatus;
183     }
184     
185     /* Sell position and collect claim*/
186 
187     function sell(uint256 amount) {
188         if(getClaimStatus() == false) throw;                // checks if party can make a claim
189         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
190         balanceOf[this] += amount;                         // adds the amount to owner's balance
191         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
192         if (!msg.sender.send(claim)) {        // sends ether to the seller. It's important
193             throw;                                         // to do this last to avoid recursion attacks
194         } else {
195             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
196         }               
197     }
198 }