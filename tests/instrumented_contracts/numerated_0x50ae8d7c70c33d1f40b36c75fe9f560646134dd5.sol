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
21 contract SwapToken is owned {
22     /* Public variables of the token */
23     
24     string public standard = 'Token 0.1';
25 
26     // buyer tokens
27     string public buyerTokenName;
28     string public buyerSymbol;
29     uint8 public buyerDecimals;
30     uint256 public totalBuyerSupply;
31     
32     // issuer tokens
33     string public issuerTokenName;
34     string public issuerSymbol;
35     uint8 public issuerDecimals;
36     uint256 public totalIssuerSupply;
37     
38     // more variables
39     uint256 public buyPrice;
40     uint256 public issuePrice;
41     address public project_wallet;
42     address public collectionFunds;
43     uint public startBlock;
44     uint public endBlock;
45     
46     /* Sets the constructor variables */
47     function SwapToken(
48         string _buyerTokenName,
49         string _buyerSymbol,
50         uint8 _buyerDecimals,
51         string _issuerTokenName,
52         string _issuerSymbol,
53         uint8 _issuerDecimals,
54         address _collectionFunds,
55         uint _startBlock,
56         uint _endBlock
57         ) {
58         buyerTokenName = _buyerTokenName;
59         buyerSymbol = _buyerSymbol;
60         buyerDecimals = _buyerDecimals;
61         issuerTokenName = _issuerTokenName;
62         issuerSymbol = _issuerSymbol;
63         issuerDecimals = _issuerDecimals;
64         collectionFunds = _collectionFunds;
65         startBlock = _startBlock;
66         endBlock = _endBlock;
67     }
68 
69     /* This creates an array with all balances */
70     mapping (address => uint256) public balanceOfBuyer;
71     mapping (address => uint256) public balanceOfIssuer;
72     mapping (address => mapping (address => uint256)) public allowance;
73 
74     /* This generates a public event on the blockchain that will notify clients */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /* Initializes contract with initial supply tokens to the creator of the contract 
78     function token(
79         uint256 initialSupply,
80         string tokenName,
81         uint8 decimalUnits,
82         string tokenSymbol
83         ) {
84         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
85         totalSupply = initialSupply;                        // Update total supply
86         name = tokenName;                                   // Set the name for display purposes
87         symbol = tokenSymbol;                               // Set the symbol for display purposes
88         decimals = decimalUnits;                            // Amount of decimals for display purposes
89     }
90     */
91     
92     /* Check if contract has started */
93     function has_contract_started() private constant returns (bool) {
94 	    return block.number >= startBlock;
95     }
96     
97     /* Check if contract has ended */
98     function has_contract_ended() private constant returns (bool) {
99         return block.number > endBlock;
100     }
101     
102     /* Set a project Wallet */
103     function defineProjectWallet(address target) onlyOwner {
104         project_wallet = target;
105     }
106     
107     /* Mint coins */
108     
109     // buyer tokens
110     function mintBuyerToken(address target, uint256 mintedAmount) onlyOwner {
111         balanceOfBuyer[target] += mintedAmount;
112         totalBuyerSupply += mintedAmount;
113         Transfer(0, this, mintedAmount);
114         Transfer(this, target, mintedAmount);
115     }
116     
117     // issuer tokens
118     function mintIssuerToken(address target, uint256 mintedAmount) onlyOwner {
119         balanceOfIssuer[target] += mintedAmount;
120         totalIssuerSupply += mintedAmount;
121         Transfer(0, this, mintedAmount);
122         Transfer(this, target, mintedAmount);
123     }
124     
125     /* Distroy coins */
126     
127     // Distroy buyer coins for sale in contract 
128     function distroyBuyerToken(uint256 burnAmount) onlyOwner {
129         balanceOfBuyer[this] -= burnAmount;
130         totalBuyerSupply -= burnAmount;
131     }
132     
133     // Distroy issuer coins for sale in contract
134     function distroyIssuerToken(uint256 burnAmount) onlyOwner {
135         balanceOfIssuer[this] -= burnAmount;
136         totalIssuerSupply -= burnAmount;
137     }
138 
139     /* Send coins */
140     
141     // send buyer coins
142     function transferBuyer(address _to, uint256 _value) {
143         if (balanceOfBuyer[msg.sender] < _value) throw;           // Check if the sender has enough
144         if (balanceOfBuyer[_to] + _value < balanceOfBuyer[_to]) throw; // Check for overflows
145         balanceOfBuyer[msg.sender] -= _value;                     // Subtract from the sender
146         balanceOfBuyer[_to] += _value;                            // Add the same to the recipient
147         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
148     }
149     
150     // send issuer coins
151     function transferIssue(address _to, uint256 _value) {
152         if (balanceOfIssuer[msg.sender] < _value) throw;
153         if (balanceOfIssuer[_to] + _value < balanceOfIssuer[_to]) throw;
154         balanceOfIssuer[msg.sender] -= _value;
155         balanceOfIssuer[_to] += _value;
156         Transfer(msg.sender, _to, _value);
157     }
158     
159     /* Allow another contract to spend some tokens in your behalf */
160     function approve(address _spender, uint256 _value)
161         returns (bool success) {
162         allowance[msg.sender][_spender] = _value;
163         tokenRecipient spender = tokenRecipient(_spender);
164         return true;
165     }
166 
167     /* Approve and then comunicate the approved contract in a single tx */
168     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
169         returns (bool success) {    
170         tokenRecipient spender = tokenRecipient(_spender);
171         if (approve(_spender, _value)) {
172             spender.receiveApproval(msg.sender, _value, this, _extraData);
173             return true;
174         }
175     }
176 
177     /* A contract attempts to get the coins 
178     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
179         if (balanceOfBuyer[_from] < _value) throw;                 // Check if the sender has enough
180         if (balanceOfBuyer[_to] + _value < balanceOfBuyer[_to]) throw;  // Check for overflows
181         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
182         balanceOfBuyer[_from] -= _value;                          // Subtract from the sender
183         balanceOfBuyer[_to] += _value;                            // Add the same to the recipient
184         allowance[_from][msg.sender] -= _value;
185         Transfer(_from, _to, _value);
186         return true;
187     }
188     */
189     
190     /* Set token price */
191     function setPrices(uint256 newBuyPrice, uint256 newIssuePrice) onlyOwner {
192         buyPrice = newBuyPrice;
193         issuePrice = newIssuePrice;
194     }
195 
196     /* Buy tokens */
197     
198     // buy buyer tokens
199     function buyBuyerTokens() payable {
200         if(!has_contract_started()) throw;                  // checks if the contract has started
201         if(has_contract_ended()) throw;                     // checks if the contract has ended 
202         uint amount = msg.value / buyPrice;                // calculates the amount
203         if (balanceOfBuyer[this] < amount) throw;               // checks if it has enough to sell
204         balanceOfBuyer[msg.sender] += amount;                   // adds the amount to buyer's balance
205         balanceOfBuyer[this] -= amount;                         // subtracts amount from seller's balance
206         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
207     }
208     
209     // buy issuer tokens
210     function buyIssuerTokens() payable {
211         uint amount = msg.value / issuePrice;
212         if (balanceOfIssuer[this] < amount) throw;
213         balanceOfIssuer[msg.sender] += amount;
214         balanceOfIssuer[this] -= amount;
215         Transfer(this, msg.sender, amount);
216     }
217     
218     /* After contract ends move funds */
219     function moveFunds() onlyOwner {
220         //if (!has_contract_ended()) throw;
221         if (!project_wallet.send(this.balance)) throw;
222     }
223 
224     /* This unnamed function is called whenever someone tries to send ether to it */
225     function () {
226         throw;     // Prevents accidental sending of ether
227     }
228 }