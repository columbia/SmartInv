1 pragma solidity ^0.4.18;
2 interface IYeekFormula {
3     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) external view returns (uint256);
4     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) external view returns (uint256);
5 }
6 
7 interface ITradeableAsset {
8     function totalSupply() external view returns (uint256);
9     function approve(address spender, uint tokens) external returns (bool success);
10     function transferFrom(address from, address to, uint tokens) external returns (bool success);
11     function decimals() external view returns (uint256);
12     function transfer(address _to, uint256 _value) external;
13     function balanceOf(address _address) external view returns (uint256);
14 }
15 
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
17 
18 /* A basic permissions hierarchy (Owner -> Admin -> Everyone else). One owner may appoint and remove any number of admins
19    and may transfer ownership to another individual address */
20 contract Administered {
21     address public creator;
22 
23     mapping (address => bool) public admins;
24     
25     constructor()  public {
26         creator = msg.sender;
27         admins[creator] = true;
28     }
29 
30     //Restrict to the current owner. There may be only 1 owner at a time, but 
31     //ownership can be transferred.
32     modifier onlyOwner {
33         require(creator == msg.sender);
34         _;
35     }
36     
37     //Restrict to any admin. Not sufficient for highly sensitive methods
38     //since basic admin can be granted programatically regardless of msg.sender
39     modifier onlyAdmin {
40         require(admins[msg.sender] || creator == msg.sender);
41         _;
42     }
43 
44     //Add an admin with basic privileges. Can be done by any superuser (or the owner)
45     function grantAdmin(address newAdmin) onlyOwner  public {
46         _grantAdmin(newAdmin);
47     }
48 
49     function _grantAdmin(address newAdmin) internal
50     {
51         admins[newAdmin] = true;
52     }
53 
54     //Transfer ownership
55     function changeOwner(address newOwner) onlyOwner public {
56         creator = newOwner;
57     }
58 
59     //Remove an admin
60     function revokeAdminStatus(address user) onlyOwner public {
61         admins[user] = false;
62     }
63 }
64 
65 /* A liqudity pool that executes buy and sell orders for an ETH / Token Pair */
66 /* The owner deploys it and then adds tokens / ethereum in the desired ratio */
67 
68 contract Exchanger is Administered, tokenRecipient {
69     bool public enabled = false;    //Owner can turn off and on
70 
71     //The token which is being bought and sold
72     ITradeableAsset public tokenContract;
73     //The contract that does the calculations to determine buy and sell pricing
74     IYeekFormula public formulaContract;
75     //The reserve pct of this exchanger, expressed in ppm
76     uint32 public weight;
77     //The fee, in ppm
78     uint32 public fee=5000; //0.5%
79     //Price multiplier - for use when the total supply is not in circulation
80     //Lets you use a higher weight with a lower reserve
81     uint32 public multiplier=1;
82     //Accounting for the fees
83     uint32 public collectedFees=0;
84 
85     /** 
86         @dev Deploys an exchanger contract for a given token / Ether pairing
87         @param _token An ERC20 token
88         @param _weight The reserve fraction of this exchanger, in ppm
89         @param _formulaContract The contract with the algorithms to calculate price
90      */
91 
92     constructor(address _token, 
93                 uint32 _weight,
94                 address _formulaContract) {
95         require (_weight > 0 && weight <= 1000000);
96         
97         weight = _weight;
98         tokenContract = ITradeableAsset(_token);
99         formulaContract = IYeekFormula(_formulaContract);
100     }
101 
102     //Events raised on completion of buy and sell orders. 
103     //The web client can use this info to provide users with their trading history for a given token
104     //and also to notify when a trade has completed.
105 
106     event Buy(address indexed purchaser, uint256 amountInWei, uint256 amountInToken);
107     event Sell(address indexed seller, uint256 amountInToken, uint256 amountInWei);
108 
109     /**
110      @dev Deposit tokens to the reserve.
111      */
112     function depositTokens(uint amount) onlyOwner public {
113         tokenContract.transferFrom(msg.sender, this, amount);
114     }
115         
116     /**
117     @dev Deposit ether to the reserve
118     */
119     function depositEther() onlyOwner public payable {
120     //return getQuotePrice(); 
121     }
122 
123     /**  
124      @dev Withdraw tokens from the reserve
125      */
126     function withdrawTokens(uint amount) onlyOwner public {
127         tokenContract.transfer(msg.sender, amount);
128     }
129 
130     /**  
131      @dev Withdraw ether from the reserve
132      */
133     function withdrawEther(uint amountInWei) onlyOwner public {
134         msg.sender.transfer(amountInWei); //Transfers in wei
135     }
136 
137     /**
138      @dev Enable trading
139      */
140     function enable() onlyAdmin public {
141         enabled = true;
142     }
143 
144      /**
145       @dev Disable trading
146      */
147     function disable() onlyAdmin public {
148         enabled = false;
149     }
150 
151      /**
152       @dev Play central banker and set the fractional reserve ratio, from 1 to 1000000 ppm.
153       It is highly disrecommended to do this while trading is enabled! Obviously this should 
154       only be done in combination with a matching deposit or withdrawal of ether, 
155       and I'll enforce it at a later point.
156      */
157     function setReserveWeight(uint ppm) onlyAdmin public {
158         require (ppm>0 && ppm<=1000000);
159         weight = uint32(ppm);
160     }
161 
162     function setFee(uint ppm) onlyAdmin public {
163         require (ppm >= 0 && ppm <= 1000000);
164         fee = uint32(ppm);
165     }
166 
167     function setMultiplier(uint newValue) onlyAdmin public {
168         require (newValue > 0);
169         multiplier = uint32(newValue);
170     }
171 
172     //These methods return information about the exchanger, and the buy / sell rates offered on the Token / ETH pairing.
173     //They can be called without gas from any client.
174 
175     /**  
176      @dev Audit the reserve balances, in the base token and in ether
177      */
178     function getReserveBalances() public view returns (uint256, uint256) {
179         return (tokenContract.balanceOf(this), address(this).balance);
180     }
181 
182 
183     /**
184      @dev Gets price based on a sample 1 ether BUY order
185      */
186      /*
187     function getQuotePrice() public view returns(uint) {
188         uint tokensPerEther = 
189         formulaContract.calculatePurchaseReturn(
190             (tokenContract.totalSupply() - tokenContract.balanceOf(this)) * multiplier,
191             address(this).balance,
192             weight,
193             1 ether 
194         ); 
195 
196         return tokensPerEther;
197     }*/
198 
199     /**
200      @dev Get the BUY price based on the order size. Returned as the number of tokens that the amountInWei will buy.
201      */
202     function getPurchasePrice(uint256 amountInWei) public view returns(uint) {
203         uint256 purchaseReturn = formulaContract.calculatePurchaseReturn(
204             (tokenContract.totalSupply() / multiplier) - tokenContract.balanceOf(this),
205             address(this).balance,
206             weight,
207             amountInWei 
208         ); 
209 
210         purchaseReturn = (purchaseReturn - (purchaseReturn * (fee / 1000000)));
211 
212         if (purchaseReturn > tokenContract.balanceOf(this)){
213             return tokenContract.balanceOf(this);
214         }
215         return purchaseReturn;
216     }
217 
218     /**
219      @dev Get the SELL price based on the order size. Returned as amount (in wei) that you'll get for your tokens.
220      */
221     function getSalePrice(uint256 tokensToSell) public view returns(uint) {
222         uint256 saleReturn = formulaContract.calculateSaleReturn(
223             (tokenContract.totalSupply() / multiplier) - tokenContract.balanceOf(this),
224             address(this).balance,
225             weight,
226             tokensToSell 
227         ); 
228         saleReturn = (saleReturn - (saleReturn * (fee/1000000)));
229         if (saleReturn > address(this).balance) {
230             return address(this).balance;
231         }
232         return saleReturn;
233     }
234 
235     //buy and sell execute live trades against the exchanger. For either method, 
236     //you must specify your minimum return (in total tokens or ether that you expect to receive for your trade)
237     //this protects the trader against slippage due to other orders that make it into earlier blocks after they 
238     //place their order. 
239     //
240     //With buy, send the amount of ether you want to spend on the token - you'll get it back immediately if minPurchaseReturn
241     //is not met or if this Exchanger is not in a condition to service your order (usually this happens when there is not a full 
242     //reserve of tokens to satisfy the stated weight)
243     //
244     //With sell, first approve the exchanger to spend the number of tokens you want to sell
245     //Then call sell with that number and your minSaleReturn. The token transfer will not happen 
246     //if the minSaleReturn is not met.
247     //
248     //Sales always go through, as long as there is any ether in the reserve... but those dumping massive quantities of tokens
249     //will naturally be given the shittest rates.
250 
251     /**
252      @dev Buy tokens with ether. 
253      @param minPurchaseReturn The minimum number of tokens you will accept.
254      */
255     function buy(uint minPurchaseReturn) public payable {
256         uint amount = formulaContract.calculatePurchaseReturn(
257             (tokenContract.totalSupply() / multiplier) - tokenContract.balanceOf(this),
258             address(this).balance - msg.value,
259             weight,
260             msg.value);
261         amount = (amount - (amount * (fee / 1000000)));
262         require (enabled); // ADDED SEMICOLON    
263         require (amount >= minPurchaseReturn);
264         require (tokenContract.balanceOf(this) >= amount);
265         emit Buy(msg.sender, msg.value, amount);
266         tokenContract.transfer(msg.sender, amount);
267     }
268     /**
269      @dev Sell tokens for ether
270      @param quantity Number of tokens to sell
271      @param minSaleReturn Minimum amount of ether (in wei) you will accept for your tokens
272      */
273     function sell(uint quantity, uint minSaleReturn) public {
274         uint amountInWei = formulaContract.calculateSaleReturn(
275             (tokenContract.totalSupply() / multiplier) - tokenContract.balanceOf(this),
276              address(this).balance,
277              weight,
278              quantity
279         );
280         amountInWei = (amountInWei - (amountInWei * (fee / 1000000)));
281 
282         require (enabled); // ADDED SEMICOLON
283         require (amountInWei >= minSaleReturn);
284         require (amountInWei <= address(this).balance);
285         require (tokenContract.transferFrom(msg.sender, this, quantity));
286 
287         emit Sell(msg.sender, quantity, amountInWei);
288         msg.sender.transfer(amountInWei); //Always send ether last
289     }
290 
291 
292     //approveAndCall flow for selling entry point
293     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external {
294         //not needed: if it was the wrong token, the tx fails anyways require(_token == address(tokenContract));
295         sellOneStep(_value, 0, _from);
296     }
297     
298 
299     //Variant of sell for one step ordering. The seller calls approveAndCall on the token
300     //which calls receiveApproval above, which calls this funciton
301     function sellOneStep(uint quantity, uint minSaleReturn, address seller) public {
302         uint amountInWei = formulaContract.calculateSaleReturn(
303             (tokenContract.totalSupply() / multiplier) - tokenContract.balanceOf(this),
304              address(this).balance,
305              weight,
306              quantity
307         );
308         amountInWei = (amountInWei - (amountInWei * (fee / 1000000)));
309         
310         require (enabled); // ADDED SEMICOLON
311         require (amountInWei >= minSaleReturn);
312         require (amountInWei <= address(this).balance);
313         require (tokenContract.transferFrom(seller, this, quantity));
314 
315         emit Sell(seller, quantity, amountInWei);
316         seller.transfer(amountInWei); //Always send ether last
317     }
318 
319 }