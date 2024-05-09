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
27     
28     string public generalTerms;
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
65         tokenRecipient spender = tokenRecipient(_spender);
66         return true;
67     }
68 
69     /* Approve and then comunicate the approved contract in a single tx */
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
71         returns (bool success) {    
72         tokenRecipient spender = tokenRecipient(_spender);
73         if (approve(_spender, _value)) {
74             spender.receiveApproval(msg.sender, _value, this, _extraData);
75             return true;
76         }
77     }
78 
79     /* A contract attempts to get the coins */
80     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
81         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
82         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
83         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
84         balanceOf[_from] -= _value;                          // Subtract from the sender
85         balanceOf[_to] += _value;                            // Add the same to the recipient
86         allowance[_from][msg.sender] -= _value;
87         Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     /* This unnamed function is called whenever someone tries to send ether to it */
92     function () {
93         throw;     // Prevents accidental sending of ether
94     }
95 }
96 
97 contract t_swap is owned, token {
98 
99     uint256 public buyPrice;
100     uint256 public totalSupply;
101     uint256 public claim;
102     bool public claimStatus;
103 
104     mapping (address => bool) public frozenAccount;
105 
106     /* This generates a public event on the blockchain that will notify clients */
107     event FrozenFunds(address target, bool frozen);
108 
109     /* Initializes contract with initial supply tokens to the creator of the contract */
110     function t_swap(
111         uint256 initialSupply,
112         string tokenName,
113         uint8 decimalUnits,
114         string tokenSymbol,
115         address centralMinter
116     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {
117         if(centralMinter != 0 ) owner = centralMinter;      // Sets the owner as specified (if centralMinter is not specified the owner is msg.sender)
118         balanceOf[owner] = initialSupply;                   // Give the owner all initial tokens
119     }
120 
121     /* Send coins */
122     function transfer(address _to, uint256 _value) {
123         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
124         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
125         if (frozenAccount[msg.sender]) throw;                // Check if frozen
126         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
127         balanceOf[_to] += _value;                            // Add the same to the recipient
128         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
129     }
130 
131 
132     /* A contract attempts to get the coins */
133     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
134         if (frozenAccount[_from]) throw;                        // Check if frozen            
135         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
136         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
137         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
138         balanceOf[_from] -= _value;                          // Subtract from the sender
139         balanceOf[_to] += _value;                            // Add the same to the recipient
140         allowance[_from][msg.sender] -= _value;
141         Transfer(_from, _to, _value);
142         return true;
143     }
144 
145     function mintToken(address target, uint256 mintedAmount) onlyOwner {
146         balanceOf[target] += mintedAmount;
147         totalSupply += mintedAmount;
148         Transfer(0, this, mintedAmount);
149         Transfer(this, target, mintedAmount);
150     }
151 
152     function freezeAccount(address target, bool freeze) onlyOwner {
153         frozenAccount[target] = freeze;
154         FrozenFunds(target, freeze);
155     }
156 
157     function setPrices(uint256 newBuyPrice) onlyOwner {
158         buyPrice = newBuyPrice;
159     }
160 
161     function buy() payable {
162         uint amount = msg.value / buyPrice;                // calculates the amount
163         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
164         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
165         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
166         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
167     }
168 
169     /* Insurance claim data */
170     
171     function setClaim(uint256 _claim)  onlyOwner{
172         claim = _claim;
173     }
174     
175     
176     function setClaimStatus(bool _status) onlyOwner {
177         claimStatus = _status;
178     }
179 
180     
181     /* Sell position and collect claim*/
182 
183     function sell(uint256 amount) {
184         if(claimStatus == false) throw;                // checks if party can make a claim
185         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
186         balanceOf[this] += amount;                         // adds the amount to owner's balance
187         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
188         if (!msg.sender.send(claim)) {                  // sends ether to the seller. It's important
189             throw;                                         // to do this last to avoid recursion attacks
190         } else {
191             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
192         }               
193     }
194 }