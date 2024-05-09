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
41     uint256 public cPT;
42     bool public creditStatus;
43     address public project_wallet;
44     address public collectionFunds;
45     //uint public startBlock;
46     //uint public endBlock;
47     
48     /* Sets the constructor variables */
49     function SwapToken(
50         string _buyerTokenName,
51         string _buyerSymbol,
52         uint8 _buyerDecimals,
53         string _issuerTokenName,
54         string _issuerSymbol,
55         uint8 _issuerDecimals,
56         address _collectionFunds,
57         uint _startBlock,
58         uint _endBlock
59         ) {
60         buyerTokenName = _buyerTokenName;
61         buyerSymbol = _buyerSymbol;
62         buyerDecimals = _buyerDecimals;
63         issuerTokenName = _issuerTokenName;
64         issuerSymbol = _issuerSymbol;
65         issuerDecimals = _issuerDecimals;
66         collectionFunds = _collectionFunds;
67         //startBlock = _startBlock;
68         //endBlock = _endBlock;
69     }
70 
71     /* This creates an array with all balances */
72     mapping (address => uint256) public balanceOfBuyer;
73     mapping (address => uint256) public balanceOfIssuer;
74     mapping (address => mapping (address => uint256)) public allowance;
75 
76     /* This generates a public event on the blockchain that will notify clients */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /* Initializes contract with initial supply tokens to the creator of the contract 
80     function token(
81         uint256 initialSupply,
82         string tokenName,
83         uint8 decimalUnits,
84         string tokenSymbol
85         ) {
86         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
87         totalSupply = initialSupply;                        // Update total supply
88         name = tokenName;                                   // Set the name for display purposes
89         symbol = tokenSymbol;                               // Set the symbol for display purposes
90         decimals = decimalUnits;                            // Amount of decimals for display purposes
91     }
92     */
93     
94     /* Check if contract has started */
95     /*function has_contract_started() private constant returns (bool) {
96 	    return block.number >= startBlock;
97     }*/
98     
99     /* Check if contract has ended */
100     /*function has_contract_ended() private constant returns (bool) {
101         return block.number > endBlock;
102     }*/
103     
104     /* Set a project Wallet */
105     function defineProjectWallet(address target) onlyOwner {
106         project_wallet = target;
107     }
108     
109     /* Mint coins */
110     
111     // buyer tokens
112     function mintBuyerToken(address target, uint256 mintedAmount) onlyOwner {
113         balanceOfBuyer[target] += mintedAmount;
114         totalBuyerSupply += mintedAmount;
115         Transfer(0, this, mintedAmount);
116         Transfer(this, target, mintedAmount);
117     }
118     
119     // issuer tokens
120     function mintIssuerToken(address target, uint256 mintedAmount) onlyOwner {
121         balanceOfIssuer[target] += mintedAmount;
122         totalIssuerSupply += mintedAmount;
123         Transfer(0, this, mintedAmount);
124         Transfer(this, target, mintedAmount);
125     }
126     
127     /* Distroy coins */
128     
129     // Distroy buyer coins for sale in contract 
130     function distroyBuyerToken(uint256 burnAmount) onlyOwner {
131         balanceOfBuyer[this] -= burnAmount;
132         totalBuyerSupply -= burnAmount;
133     }
134     
135     // Distroy issuer coins for sale in contract
136     function distroyIssuerToken(uint256 burnAmount) onlyOwner {
137         balanceOfIssuer[this] -= burnAmount;
138         totalIssuerSupply -= burnAmount;
139     }
140 
141     /* Send coins */
142     
143     // send buyer coins
144     function transferBuyer(address _to, uint256 _value) {
145         if (balanceOfBuyer[msg.sender] < _value) throw;           // Check if the sender has enough
146         if (balanceOfBuyer[_to] + _value < balanceOfBuyer[_to]) throw; // Check for overflows
147         balanceOfBuyer[msg.sender] -= _value;                     // Subtract from the sender
148         balanceOfBuyer[_to] += _value;                            // Add the same to the recipient
149         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
150     }
151     
152     // send issuer coins
153     function transferIssue(address _to, uint256 _value) {
154         if (balanceOfIssuer[msg.sender] < _value) throw;
155         if (balanceOfIssuer[_to] + _value < balanceOfIssuer[_to]) throw;
156         balanceOfIssuer[msg.sender] -= _value;
157         balanceOfIssuer[_to] += _value;
158         Transfer(msg.sender, _to, _value);
159     }
160     
161     /* Allow another contract to spend some tokens in your behalf */
162     function approve(address _spender, uint256 _value)
163         returns (bool success) {
164         allowance[msg.sender][_spender] = _value;
165         tokenRecipient spender = tokenRecipient(_spender);
166         return true;
167     }
168 
169     /* Approve and then comunicate the approved contract in a single tx */
170     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
171         returns (bool success) {    
172         tokenRecipient spender = tokenRecipient(_spender);
173         if (approve(_spender, _value)) {
174             spender.receiveApproval(msg.sender, _value, this, _extraData);
175             return true;
176         }
177     }
178 
179     /* A contract attempts to get the coins 
180     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
181         if (balanceOfBuyer[_from] < _value) throw;                 // Check if the sender has enough
182         if (balanceOfBuyer[_to] + _value < balanceOfBuyer[_to]) throw;  // Check for overflows
183         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
184         balanceOfBuyer[_from] -= _value;                          // Subtract from the sender
185         balanceOfBuyer[_to] += _value;                            // Add the same to the recipient
186         allowance[_from][msg.sender] -= _value;
187         Transfer(_from, _to, _value);
188         return true;
189     }
190     */
191     
192     /* Set token price */
193     function setPrices(uint256 newBuyPrice, uint256 newIssuePrice, uint256 coveragePerToken) onlyOwner {
194         buyPrice = newBuyPrice;
195         issuePrice = newIssuePrice;
196         cPT = coveragePerToken;
197     }
198 
199     /* Buy tokens */
200     
201     // buy buyer tokens
202     function buyBuyerTokens() payable {
203         //if(!has_contract_started()) throw;                  // checks if the contract has started
204         //if(has_contract_ended()) throw;                     // checks if the contract has ended 
205         uint amount = msg.value / buyPrice;                // calculates the amount
206         if (balanceOfBuyer[this] < amount) throw;               // checks if it has enough to sell
207         balanceOfBuyer[msg.sender] += amount;                   // adds the amount to buyer's balance
208         balanceOfBuyer[this] -= amount;                         // subtracts amount from seller's balance
209         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
210     }
211     
212     // buy issuer tokens
213     function buyIssuerTokens() payable {
214         uint amount = msg.value / issuePrice;
215         if (balanceOfIssuer[this] < amount) throw;
216         balanceOfIssuer[msg.sender] += amount;
217         balanceOfIssuer[this] -= amount;
218         Transfer(this, msg.sender, amount);
219     }
220     
221     
222     /* Credit Status Event */
223     function setCreditStatus(bool _status) onlyOwner {
224         creditStatus = _status;
225     }
226 
227     /* Collection */
228     
229     // buyer collection sale
230     function sellBuyerTokens(uint amount) returns (uint revenue){
231         if (creditStatus == false) throw;                       // checks if buyer is eligible for a claim
232         if (balanceOfBuyer[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
233         balanceOfBuyer[this] += amount;                         // adds the amount to owner's balance
234         balanceOfBuyer[msg.sender] -= amount;                   // subtracts the amount from seller's balance
235         revenue = amount * cPT;
236         if (!msg.sender.send(revenue)) {                   // sends ether to the seller: it's important
237             throw;                                         // to do this last to prevent recursion attacks
238         } else {
239             Transfer(msg.sender, this, amount);             // executes an event reflecting on the change
240             return revenue;                                 // ends function and returns
241         }
242     }
243     
244     /* After contract ends move funds */
245     function moveFunds() onlyOwner {
246         //if (!has_contract_ended()) throw;
247         if (!project_wallet.send(this.balance)) throw;
248     }
249 
250     /* This unnamed function is called whenever someone tries to send ether to it */
251     function () {
252         throw;     // Prevents accidental sending of ether
253     }
254 }