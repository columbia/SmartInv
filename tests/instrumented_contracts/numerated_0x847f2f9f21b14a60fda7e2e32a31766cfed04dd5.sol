1 pragma solidity ^0.4.19;
2 
3 // Wolf Crypto pooling contract
4 // written by @iamdefinitelyahuman
5 
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 
29 interface ERC20 {
30   function balanceOf(address _owner) external returns (uint256 balance);
31   function transfer(address _to, uint256 _value) external returns (bool success);
32 }
33 
34 interface WhiteList {
35    function isPaidUntil (address addr) external view returns (uint);
36 }
37 
38 
39 contract PresalePool {
40 
41   // SafeMath is a library to ensure that math operations do not have overflow errors
42   // https://zeppelin-solidity.readthedocs.io/en/latest/safemath.html
43   using SafeMath for uint;
44   
45   // The contract has 2 stages:
46   // 1 - The initial state. The owner is able to add addresses to the whitelist, and any whitelisted addresses can deposit or withdraw eth to the contract.
47   // 2 - The eth is sent from the contract to the receiver. Unused eth can be claimed by contributors immediately. Once tokens are sent to the contract,
48   //     the owner enables withdrawals and contributors can withdraw their tokens.
49   uint8 public contractStage = 1;
50   
51   // These variables are set at the time of contract creation
52   // address that creates the contract
53   address public owner;
54   uint maxContractBalance;
55   // maximum eth amount (in wei) that can be sent by a whitelisted address
56   uint contributionCap;
57   // the % of tokens kept by the contract owner
58   uint public feePct;
59   // the address that the pool will be paid out to
60   address public receiverAddress;
61   
62   // These constant variables do not change with each contract deployment
63   // minimum eth amount (in wei) that can be sent by a whitelisted address
64   uint constant public contributionMin = 100000000000000000;
65   // maximum gas price allowed for deposits in stage 1
66   uint constant public maxGasPrice = 50000000000;
67   // whitelisting contract
68   WhiteList constant public whitelistContract = WhiteList(0xf6E386FA4794B58350e7B4Cb32B6f86Fb0F357d4);
69   bool whitelistIsActive = true;
70   
71   // These variables are all initially set to 0 and will be set at some point during the contract
72   // epoch time that the next contribution caps become active
73   uint public nextCapTime;
74   // pending contribution caps
75   uint public nextContributionCap;
76   // block number of the last change to the receiving address (set if receiving address is changed, stage 1)
77   uint public addressChangeBlock;
78   // amount of eth (in wei) present in the contract when it was submitted
79   uint public finalBalance;
80   // array containing eth amounts to be refunded in stage 2
81   uint[] public ethRefundAmount;
82   // default token contract to be used for withdrawing tokens in stage 2
83   address public activeToken;
84   
85   // data structure for holding the contribution amount, cap, eth refund status, and token withdrawal status for each whitelisted address
86   struct Contributor {
87     uint ethRefund;
88     uint balance;
89     uint cap;
90     mapping (address => uint) tokensClaimed;
91   }
92   // mapping that holds the contributor struct for each whitelisted address
93   mapping (address => Contributor) whitelist;
94   
95   // data structure for holding information related to token withdrawals.
96   struct TokenAllocation {
97     ERC20 token;
98     uint[] pct;
99     uint balanceRemaining;
100   }
101   // mapping that holds the token allocation struct for each token address
102   mapping (address => TokenAllocation) distributionMap;
103   
104   
105   // modifier for functions that can only be accessed by the contract creator
106   modifier onlyOwner () {
107     require (msg.sender == owner);
108     _;
109   }
110   
111   // modifier to prevent re-entrancy exploits during contract > contract interaction
112   bool locked;
113   modifier noReentrancy() {
114     require(!locked);
115     locked = true;
116     _;
117     locked = false;
118   }
119   
120   // Events triggered throughout contract execution
121   // These can be watched via geth filters to keep up-to-date with the contract
122   event ContributorBalanceChanged (address contributor, uint totalBalance);
123   event ReceiverAddressSet ( address _addr);
124   event PoolSubmitted (address receiver, uint amount);
125   event WithdrawalsOpen (address tokenAddr);
126   event TokensWithdrawn (address receiver, address token, uint amount);
127   event EthRefundReceived (address sender, uint amount);
128   event EthRefunded (address receiver, uint amount);
129   event ERC223Received (address token, uint value);
130    
131   // These are internal functions used for calculating fees, eth and token allocations as %
132   // returns a value as a % accurate to 20 decimal points
133   function _toPct (uint numerator, uint denominator ) internal pure returns (uint) {
134     return numerator.mul(10 ** 20) / denominator;
135   }
136   
137   // returns % of any number, where % given was generated with toPct
138   function _applyPct (uint numerator, uint pct) internal pure returns (uint) {
139     return numerator.mul(pct) / (10 ** 20);
140   }
141   
142   // This function is called at the time of contract creation,
143   // it sets the initial variables and whitelists the contract owner.
144   function PresalePool (address receiverAddr, uint contractCap, uint cap, uint fee) public {
145     require (fee < 100);
146     require (contractCap >= cap);
147     owner = msg.sender;
148     receiverAddress = receiverAddr;
149     maxContractBalance = contractCap;
150     contributionCap = cap;
151     feePct = _toPct(fee,100);
152   }
153   
154   // This function is called whenever eth is sent into the contract.
155   // The send will fail unless the contract is in stage one and the sender has been whitelisted.
156   // The amount sent is added to the balance in the Contributor struct associated with the sending address.
157   function () payable public {
158     if (contractStage == 1) {
159       _ethDeposit();
160     } else _ethRefund();
161   }
162   
163   // Internal function for handling eth deposits during contract stage one.
164   function _ethDeposit () internal {
165     assert (contractStage == 1);
166     require (!whitelistIsActive || whitelistContract.isPaidUntil(msg.sender) > now);
167     require (tx.gasprice <= maxGasPrice);
168     require (this.balance <= maxContractBalance);
169     var c = whitelist[msg.sender];
170     uint newBalance = c.balance.add(msg.value);
171     require (newBalance >= contributionMin);
172     if (nextCapTime > 0 && nextCapTime < now) {
173       contributionCap = nextContributionCap;
174       nextCapTime = 0;
175     }
176     if (c.cap > 0) require (newBalance <= c.cap);
177     else require (newBalance <= contributionCap);
178     c.balance = newBalance;
179     ContributorBalanceChanged(msg.sender, newBalance);
180   }
181   
182   // Internal function for handling eth refunds during stage two.
183   function _ethRefund () internal {
184     assert (contractStage == 2);
185     require (msg.sender == owner || msg.sender == receiverAddress);
186     require (msg.value >= contributionMin);
187     ethRefundAmount.push(msg.value);
188     EthRefundReceived(msg.sender, msg.value);
189   }
190   
191   // This function is called to withdraw eth or tokens from the contract.
192   // It can only be called by addresses that are whitelisted and show a balance greater than 0.
193   // If called during stage one, the full eth balance deposited into the contract is returned and the contributor's balance reset to 0.
194   // If called during stage two, the contributor's unused eth will be returned, as well as any available tokens.
195   // The token address may be provided optionally to withdraw tokens that are not currently the default token (airdrops).
196   function withdraw (address tokenAddr) public {
197     var c = whitelist[msg.sender];
198     require (c.balance > 0);
199     if (contractStage == 1) {
200       uint amountToTransfer = c.balance;
201       c.balance = 0;
202       msg.sender.transfer(amountToTransfer);
203       ContributorBalanceChanged(msg.sender, 0);
204     } else {
205       _withdraw(msg.sender,tokenAddr);
206     }  
207   }
208   
209   // This function allows the contract owner to force a withdrawal to any contributor.
210   function withdrawFor (address contributor, address tokenAddr) public onlyOwner {
211     require (contractStage == 2);
212     require (whitelist[contributor].balance > 0);
213     _withdraw(contributor,tokenAddr);
214   }
215   
216   // This internal function handles withdrawals during stage two.
217   // The associated events will fire to notify when a refund or token allocation is claimed.
218   function _withdraw (address receiver, address tokenAddr) internal {
219     assert (contractStage == 2);
220     var c = whitelist[receiver];
221     if (tokenAddr == 0x00) {
222       tokenAddr = activeToken;
223     }
224     var d = distributionMap[tokenAddr];
225     require ( (ethRefundAmount.length > c.ethRefund) || d.pct.length > c.tokensClaimed[tokenAddr] );
226     if (ethRefundAmount.length > c.ethRefund) {
227       uint pct = _toPct(c.balance,finalBalance);
228       uint ethAmount = 0;
229       for (uint i=c.ethRefund; i<ethRefundAmount.length; i++) {
230         ethAmount = ethAmount.add(_applyPct(ethRefundAmount[i],pct));
231       }
232       c.ethRefund = ethRefundAmount.length;
233       if (ethAmount > 0) {
234         receiver.transfer(ethAmount);
235         EthRefunded(receiver,ethAmount);
236       }
237     }
238     if (d.pct.length > c.tokensClaimed[tokenAddr]) {
239       uint tokenAmount = 0;
240       for (i=c.tokensClaimed[tokenAddr]; i<d.pct.length; i++) {
241         tokenAmount = tokenAmount.add(_applyPct(c.balance,d.pct[i]));
242       }
243       c.tokensClaimed[tokenAddr] = d.pct.length;
244       if (tokenAmount > 0) {
245         require(d.token.transfer(receiver,tokenAmount));
246         d.balanceRemaining = d.balanceRemaining.sub(tokenAmount);
247         TokensWithdrawn(receiver,tokenAddr,tokenAmount);
248       }  
249     }
250     
251   }
252   
253   
254   // This function is called by the owner to modify the contribution cap of a whitelisted address.
255   // If the current contribution balance exceeds the new cap, the excess balance is refunded.
256   function modifyIndividualCap (address addr, uint cap) public onlyOwner {
257     require (contractStage == 1);
258     require (cap <= maxContractBalance);
259     var c = whitelist[addr];
260     require (cap >= c.balance);
261     c.cap = cap;
262   }
263   
264   // This function is called by the owner to modify the cap.
265   function modifyCap (uint cap) public onlyOwner {
266     require (contractStage == 1);
267     require (contributionCap <= cap && maxContractBalance >= cap);
268     contributionCap = cap;
269     nextCapTime = 0;
270   }
271   
272   // This function is called by the owner to modify the cap at a future time.
273   function modifyNextCap (uint time, uint cap) public onlyOwner {
274     require (contractStage == 1);
275     require (contributionCap <= cap && maxContractBalance >= cap);
276     require (time > now);
277     nextCapTime = time;
278     nextContributionCap = cap;
279   }
280   
281   // This function is called to modify the maximum balance of the contract.
282   function modifyMaxContractBalance (uint amount) public onlyOwner {
283     require (contractStage == 1);
284     require (amount >= contributionMin);
285     require (amount >= this.balance);
286     maxContractBalance = amount;
287     if (amount < contributionCap) contributionCap = amount;
288   }
289   
290   function toggleWhitelist (bool active) public onlyOwner {
291     whitelistIsActive = active;
292   }
293   
294   // This callable function returns the total pool cap, current balance and remaining balance to be filled.
295   function checkPoolBalance () view public returns (uint poolCap, uint balance, uint remaining) {
296     if (contractStage == 1) {
297       remaining = maxContractBalance.sub(this.balance);
298     } else {
299       remaining = 0;
300     }
301     return (maxContractBalance,this.balance,remaining);
302   }
303   
304   // This callable function returns the balance, contribution cap, and remaining available balance of any contributor.
305   function checkContributorBalance (address addr) view public returns (uint balance, uint cap, uint remaining) {
306     var c = whitelist[addr];
307     if (contractStage == 2) return (c.balance,0,0);
308     if (whitelistIsActive && whitelistContract.isPaidUntil(addr) < now) return (c.balance,0,0);
309     if (c.cap > 0) cap = c.cap;
310     else cap = contributionCap;
311     if (cap.sub(c.balance) > maxContractBalance.sub(this.balance)) return (c.balance, cap, maxContractBalance.sub(this.balance));
312     return (c.balance, cap, cap.sub(c.balance));
313   }
314   
315   // This callable function returns the token balance that a contributor can currently claim.
316   function checkAvailableTokens (address addr, address tokenAddr) view public returns (uint tokenAmount) {
317     var c = whitelist[addr];
318     var d = distributionMap[tokenAddr];
319     for (uint i = c.tokensClaimed[tokenAddr]; i < d.pct.length; i++) {
320       tokenAmount = tokenAmount.add(_applyPct(c.balance, d.pct[i]));
321     }
322     return tokenAmount;
323   }
324    
325   // This function sets the receiving address that the contract will send the pooled eth to.
326   // It can only be called by the contract owner if the receiver address has not already been set.
327   // After making this call, the contract will be unable to send the pooled eth for 6000 blocks.
328   // This limitation is so that if the owner acts maliciously in making the change, all whitelisted
329   // addresses have ~24 hours to withdraw their eth from the contract.
330   function setReceiverAddress (address addr) public onlyOwner {
331     require (contractStage == 1);
332     receiverAddress = addr;
333     addressChangeBlock = block.number;
334     ReceiverAddressSet(addr);
335   }
336 
337   // This function sends the pooled eth to the receiving address, calculates the % of unused eth to be returned,
338   // and advances the contract to stage two. It can only be called by the contract owner during stages one or two.
339   // The amount to send (given in wei) must be specified during the call. As this function can only be executed once,
340   // it is VERY IMPORTANT not to get the amount wrong.
341   function submitPool (uint amountInWei) public onlyOwner noReentrancy {
342     require (contractStage == 1);
343     require (receiverAddress != 0x00);
344     require (block.number >= addressChangeBlock.add(6000));
345     if (amountInWei == 0) amountInWei = this.balance;
346     require (contributionMin <= amountInWei && amountInWei <= this.balance);
347     finalBalance = this.balance;
348     require (receiverAddress.call.value(amountInWei).gas(msg.gas.sub(5000))());
349     if (this.balance > 0) ethRefundAmount.push(this.balance);
350     contractStage = 2;
351     PoolSubmitted(receiverAddress, amountInWei);
352   }
353   
354   // This function opens the contract up for token withdrawals.
355   // It can only be called by the owner during stage two.  The owner specifies the address of an ERC20 token
356   // contract that this contract has a balance in, and optionally a bool to prevent this token from being
357   // the default withdrawal (in the event of an airdrop, for example).
358   function enableTokenWithdrawals (address tokenAddr, bool notDefault) public onlyOwner noReentrancy {
359     require (contractStage == 2);
360     if (notDefault) {
361       require (activeToken != 0x00);
362     } else {
363       activeToken = tokenAddr;
364     }
365     var d = distributionMap[tokenAddr];    
366     if (d.pct.length==0) d.token = ERC20(tokenAddr);
367     uint amount = d.token.balanceOf(this).sub(d.balanceRemaining);
368     require (amount > 0);
369     if (feePct > 0) {
370       require (d.token.transfer(owner,_applyPct(amount,feePct)));
371     }
372     amount = d.token.balanceOf(this).sub(d.balanceRemaining);
373     d.balanceRemaining = d.token.balanceOf(this);
374     d.pct.push(_toPct(amount,finalBalance));
375   }
376   
377   // This is a standard function required for ERC223 compatibility.
378   function tokenFallback (address from, uint value, bytes data) public {
379     ERC223Received (from, value);
380   }
381   
382 }