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
42     uint256 public premium;
43     bool public creditStatus;
44     address public project_wallet;
45     address public collectionFunds;
46     //uint public startBlock;
47     //uint public endBlock;
48     
49     /* Sets the constructor variables */
50     function SwapToken(
51         string _buyerTokenName,
52         string _buyerSymbol,
53         uint8 _buyerDecimals,
54         string _issuerTokenName,
55         string _issuerSymbol,
56         uint8 _issuerDecimals,
57         address _collectionFunds,
58         uint _startBlock,
59         uint _endBlock
60         ) {
61         buyerTokenName = _buyerTokenName;
62         buyerSymbol = _buyerSymbol;
63         buyerDecimals = _buyerDecimals;
64         issuerTokenName = _issuerTokenName;
65         issuerSymbol = _issuerSymbol;
66         issuerDecimals = _issuerDecimals;
67         collectionFunds = _collectionFunds;
68         //startBlock = _startBlock;
69         //endBlock = _endBlock;
70     }
71 
72     /* This creates an array with all balances */
73     mapping (address => uint256) public balanceOfBuyer;
74     mapping (address => uint256) public balanceOfIssuer;
75     mapping (address => mapping (address => uint256)) public allowance;
76 
77     /* This generates a public event on the blockchain that will notify clients */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /* Initializes contract with initial supply tokens to the creator of the contract 
81     function token(
82         uint256 initialSupply,
83         string tokenName,
84         uint8 decimalUnits,
85         string tokenSymbol
86         ) {
87         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
88         totalSupply = initialSupply;                        // Update total supply
89         name = tokenName;                                   // Set the name for display purposes
90         symbol = tokenSymbol;                               // Set the symbol for display purposes
91         decimals = decimalUnits;                            // Amount of decimals for display purposes
92     }
93     */
94     
95     /* Check if contract has started */
96     /*function has_contract_started() private constant returns (bool) {
97 	    return block.number >= startBlock;
98     }
99     
100     /* Check if contract has ended */
101     /*function has_contract_ended() private constant returns (bool) {
102         return block.number > endBlock;
103     }*/
104     
105     /* Set a project Wallet */
106     function defineProjectWallet(address target) onlyOwner {
107         project_wallet = target;
108     }
109     
110     /* Mint coins */
111     
112     // buyer tokens
113     function mintBuyerToken(address target, uint256 mintedAmount) onlyOwner {
114         balanceOfBuyer[target] += mintedAmount;
115         totalBuyerSupply += mintedAmount;
116         Transfer(0, this, mintedAmount);
117         Transfer(this, target, mintedAmount);
118     }
119     
120     // issuer tokens
121     function mintIssuerToken(address target, uint256 mintedAmount) onlyOwner {
122         balanceOfIssuer[target] += mintedAmount;
123         totalIssuerSupply += mintedAmount;
124         Transfer(0, this, mintedAmount);
125         Transfer(this, target, mintedAmount);
126     }
127     
128     /* Distroy coins */
129     
130     // Distroy buyer coins for sale in contract 
131     function distroyBuyerToken(uint256 burnAmount) onlyOwner {
132         balanceOfBuyer[this] -= burnAmount;
133         totalBuyerSupply -= burnAmount;
134     }
135     
136     // Distroy issuer coins for sale in contract
137     function distroyIssuerToken(uint256 burnAmount) onlyOwner {
138         balanceOfIssuer[this] -= burnAmount;
139         totalIssuerSupply -= burnAmount;
140     }
141 
142     /* Send coins */
143     
144     // send buyer coins
145     function transferBuyer(address _to, uint256 _value) {
146         if (balanceOfBuyer[msg.sender] < _value) throw;           // Check if the sender has enough
147         if (balanceOfBuyer[_to] + _value < balanceOfBuyer[_to]) throw; // Check for overflows
148         balanceOfBuyer[msg.sender] -= _value;                     // Subtract from the sender
149         balanceOfBuyer[_to] += _value;                            // Add the same to the recipient
150         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
151     }
152     
153     // send issuer coins
154     function transferIssue(address _to, uint256 _value) {
155         if (balanceOfIssuer[msg.sender] < _value) throw;
156         if (balanceOfIssuer[_to] + _value < balanceOfIssuer[_to]) throw;
157         balanceOfIssuer[msg.sender] -= _value;
158         balanceOfIssuer[_to] += _value;
159         Transfer(msg.sender, _to, _value);
160     }
161     
162     /* Allow another contract to spend some tokens in your behalf */
163     function approve(address _spender, uint256 _value)
164         returns (bool success) {
165         allowance[msg.sender][_spender] = _value;
166         tokenRecipient spender = tokenRecipient(_spender);
167         return true;
168     }
169 
170     /* Approve and then comunicate the approved contract in a single tx */
171     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
172         returns (bool success) {    
173         tokenRecipient spender = tokenRecipient(_spender);
174         if (approve(_spender, _value)) {
175             spender.receiveApproval(msg.sender, _value, this, _extraData);
176             return true;
177         }
178     }
179 
180     /* A contract attempts to get the coins 
181     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
182         if (balanceOfBuyer[_from] < _value) throw;                 // Check if the sender has enough
183         if (balanceOfBuyer[_to] + _value < balanceOfBuyer[_to]) throw;  // Check for overflows
184         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
185         balanceOfBuyer[_from] -= _value;                          // Subtract from the sender
186         balanceOfBuyer[_to] += _value;                            // Add the same to the recipient
187         allowance[_from][msg.sender] -= _value;
188         Transfer(_from, _to, _value);
189         return true;
190     }
191     */
192     
193     /* Set token price */
194     function setPrices(uint256 newBuyPrice, uint256 newIssuePrice, uint256 coveragePerToken) onlyOwner {
195         buyPrice = newBuyPrice;
196         issuePrice = newIssuePrice;
197         cPT = coveragePerToken;
198         premium = (issuePrice - cPT) * 98/100;
199     }
200 
201     /* Buy tokens */
202     
203     // buy buyer tokens
204     function buyBuyerTokens() payable {
205         //if(!has_contract_started()) throw;                  // checks if the contract has started
206         //if(has_contract_ended()) throw;                     // checks if the contract has ended 
207         uint amount = msg.value / buyPrice;                // calculates the amount
208         if (balanceOfBuyer[this] < amount) throw;               // checks if it has enough to sell
209         balanceOfBuyer[msg.sender] += amount;                   // adds the amount to buyer's balance
210         balanceOfBuyer[this] -= amount;                         // subtracts amount from seller's balance
211         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
212     }
213     
214     // buy issuer tokens
215     function buyIssuerTokens() payable {
216         uint amount = msg.value / issuePrice;
217         if (balanceOfIssuer[this] < amount) throw;
218         balanceOfIssuer[msg.sender] += amount;
219         balanceOfIssuer[this] -= amount;
220         Transfer(this, msg.sender, amount);
221     }
222     
223     /* Credit Status Event */
224     function setCreditStatus(bool _status) onlyOwner {
225         creditStatus = _status;
226     }
227 
228     /* Collection */
229     
230     // buyer collection sale
231     function sellBuyerTokens(uint amount) returns (uint revenue){
232         if (creditStatus == false) throw;                       // checks if buyer is eligible for a claim
233         if (balanceOfBuyer[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
234         balanceOfBuyer[this] += amount;                         // adds the amount to owner's balance
235         balanceOfBuyer[msg.sender] -= amount;                   // subtracts the amount from seller's balance
236         revenue = amount * cPT;
237         if (!msg.sender.send(revenue)) {                   // sends ether to the seller: it's important
238             throw;                                         // to do this last to prevent recursion attacks
239         } else {
240             Transfer(msg.sender, this, amount);             // executes an event reflecting on the change
241             return revenue;                                 // ends function and returns
242         }
243     }
244     
245     
246     // issuer collection sale
247     function sellIssuerTokens(uint amount) returns (uint revenue){
248         if (balanceOfIssuer[msg.sender] < amount ) throw;
249         balanceOfIssuer[this] += amount;
250         balanceOfIssuer[msg.sender] -= amount;
251         revenue = amount * premium;
252         if (!msg.sender.send(revenue)) {
253             throw;
254         } else {
255             Transfer(msg.sender, this, amount);
256             return revenue;
257         }
258     }
259     
260     /* After contract ends move funds */
261     function moveFunds() onlyOwner {
262         //if (!has_contract_ended()) throw;
263         if (!project_wallet.send(this.balance)) throw;
264     }
265 
266     /* This unnamed function is called whenever someone tries to send ether to it */
267     function () {
268         throw;     // Prevents accidental sending of ether
269     }
270 }