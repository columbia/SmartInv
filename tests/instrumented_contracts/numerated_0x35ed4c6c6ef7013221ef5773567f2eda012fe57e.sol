1 pragma solidity ^0.4.19;
2 
3 // Wolf Crypto pooling contract
4 // written by @iamdefinitelyahuman
5 
6 library SafeMath {
7     
8     uint constant a = 30 days;
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 
31 interface ERC20 {
32   function balanceOf(address _owner) external returns (uint256 balance);
33   function transfer(address _to, uint256 _value) external returns (bool success);
34 }
35 
36 interface WhiteList {
37    function isPaidUntil (address addr) external view returns (uint);
38 }
39 
40 
41 contract PresalePool {
42 
43   // SafeMath is a library to ensure that math operations do not have overflow errors
44   // https://zeppelin-solidity.readthedocs.io/en/latest/safemath.html
45   using SafeMath for uint;
46   
47   // The contract has 2 stages:
48   // 1 - The initial state. The owner is able to add addresses to the whitelist, and any whitelisted addresses can deposit or withdraw eth to the contract.
49   // 2 - The eth is sent from the contract to the receiver. Unused eth can be claimed by contributors immediately. Once tokens are sent to the contract,
50   //     the owner enables withdrawals and contributors can withdraw their tokens.
51   uint8 public contractStage = 1;
52   
53   // These variables are set at the time of contract creation
54   // address that creates the contract
55   address public owner;
56   uint maxContractBalance;
57   // maximum eth amount (in wei) that can be sent by a whitelisted address
58   uint contributionCap;
59   // the % of tokens kept by the contract owner
60   uint public feePct;
61   // the address that the pool will be paid out to
62   address public receiverAddress;
63   
64   // These constant variables do not change with each contract deployment
65   // minimum eth amount (in wei) that can be sent by a whitelisted address
66   uint constant public contributionMin = 100000000000000000;
67   // maximum gas price allowed for deposits in stage 1
68   uint constant public maxGasPrice = 50000000000;
69   // whitelisting contract
70   WhiteList constant public whitelistContract = WhiteList(0xf6E386FA4794B58350e7B4Cb32B6f86Fb0F357d4);
71   bool whitelistIsActive = true;
72   
73   // These variables are all initially set to 0 and will be set at some point during the contract
74   // epoch time that the next contribution caps become active
75   uint public nextCapTime;
76   // pending contribution caps
77   uint public nextContributionCap;
78   // block number of the last change to the receiving address (set if receiving address is changed, stage 1)
79   uint public addressChangeBlock;
80   // amount of eth (in wei) present in the contract when it was submitted
81   uint public finalBalance;
82   // array containing eth amounts to be refunded in stage 2
83   uint[] public ethRefundAmount;
84   // default token contract to be used for withdrawing tokens in stage 2
85   address public activeToken;
86   
87   // data structure for holding the contribution amount, cap, eth refund status, and token withdrawal status for each whitelisted address
88   struct Contributor {
89     uint ethRefund;
90     uint balance;
91     uint cap;
92     mapping (address => uint) tokensClaimed;
93   }
94   // mapping that holds the contributor struct for each whitelisted address
95   mapping (address => Contributor) whitelist;
96   
97   // data structure for holding information related to token withdrawals.
98   struct TokenAllocation {
99     ERC20 token;
100     uint[] pct;
101     uint balanceRemaining;
102   }
103   // mapping that holds the token allocation struct for each token address
104   mapping (address => TokenAllocation) distributionMap;
105   
106   
107   // modifier for functions that can only be accessed by the contract creator
108   modifier onlyOwner () {
109     require (msg.sender == owner);
110     _;
111   }
112   
113   // modifier to prevent re-entrancy exploits during contract > contract interaction
114   bool locked;
115   modifier noReentrancy() {
116     require(!locked);
117     locked = true;
118     _;
119     locked = false;
120   }
121   
122   // Events triggered throughout contract execution
123   // These can be watched via geth filters to keep up-to-date with the contract
124   event ContributorBalanceChanged (address contributor, uint totalBalance);
125   event ReceiverAddressSet ( address _addr);
126   event PoolSubmitted (address receiver, uint amount);
127   event WithdrawalsOpen (address tokenAddr);
128   event TokensWithdrawn (address receiver, address token, uint amount);
129   event EthRefundReceived (address sender, uint amount);
130   event EthRefunded (address receiver, uint amount);
131   event ERC223Received (address token, uint value);
132    
133   // These are internal functions used for calculating fees, eth and token allocations as %
134   // returns a value as a % accurate to 20 decimal points
135   function _toPct (uint numerator, uint denominator ) internal pure returns (uint) {
136     return numerator.mul(10 ** 20) / denominator;
137   }
138   
139   // returns % of any number, where % given was generated with toPct
140   function _applyPct (uint numerator, uint pct) internal pure returns (uint) {
141     return numerator.mul(pct) / (10 ** 20);
142   }
143   
144   // This function is called at the time of contract creation,
145   // it sets the initial variables and whitelists the contract owner.
146   function PresalePool (address receiverAddr, uint contractCap, uint cap, uint fee) public {
147     require (fee < 100);
148     require (contractCap >= cap);
149     owner = msg.sender;
150     receiverAddress = receiverAddr;
151     maxContractBalance = contractCap;
152     contributionCap = cap;
153     feePct = _toPct(fee,100);
154   }
155   
156   // This function is called whenever eth is sent into the contract.
157   // The send will fail unless the contract is in stage one and the sender has been whitelisted.
158   // The amount sent is added to the balance in the Contributor struct associated with the sending address.
159   function () payable public {
160     if (contractStage == 1) {
161       _ethDeposit();
162     } else _ethRefund();
163   }
164   
165   // Internal function for handling eth deposits during contract stage one.
166   function _ethDeposit () internal {
167     assert (contractStage == 1);
168     require (!whitelistIsActive || whitelistContract.isPaidUntil(msg.sender) > now);
169     require (tx.gasprice <= maxGasPrice);
170     require (this.balance <= maxContractBalance);
171     var c = whitelist[msg.sender];
172     uint newBalance = c.balance.add(msg.value);
173     require (newBalance >= contributionMin);
174     if (nextCapTime > 0 && nextCapTime < now) {
175       contributionCap = nextContributionCap;
176       nextCapTime = 0;
177     }
178     if (c.cap > 0) require (newBalance <= c.cap);
179     else require (newBalance <= contributionCap);
180     c.balance = newBalance;
181     ContributorBalanceChanged(msg.sender, newBalance);
182   }
183   
184   // Internal function for handling eth refunds during stage two.
185   function _ethRefund () internal {
186     assert (contractStage == 2);
187     require (msg.sender == owner || msg.sender == receiverAddress);
188     require (msg.value >= contributionMin);
189     ethRefundAmount.push(msg.value);
190     EthRefundReceived(msg.sender, msg.value);
191   }
192   
193   // This function is called to withdraw eth or tokens from the contract.
194   // It can only be called by addresses that are whitelisted and show a balance greater than 0.
195   // If called during stage one, the full eth balance deposited into the contract is returned and the contributor's balance reset to 0.
196   // If called during stage two, the contributor's unused eth will be returned, as well as any available tokens.
197   // The token address may be provided optionally to withdraw tokens that are not currently the default token (airdrops).
198   function withdraw (address tokenAddr) public {
199     var c = whitelist[msg.sender];
200     require (c.balance > 0);
201     if (contractStage == 1) {
202       uint amountToTransfer = c.balance;
203       c.balance = 0;
204       msg.sender.transfer(amountToTransfer);
205       ContributorBalanceChanged(msg.sender, 0);
206     } else {
207       _withdraw(msg.sender,tokenAddr);
208     }  
209   }
210   
211   // This function allows the contract owner to force a withdrawal to any contributor.
212   function withdrawFor (address contributor, address tokenAddr) public onlyOwner {
213     require (contractStage == 2);
214     require (whitelist[contributor].balance > 0);
215     _withdraw(contributor,tokenAddr);
216   }
217   
218   // This internal function handles withdrawals during stage two.
219   // The associated events will fire to notify when a refund or token allocation is claimed.
220   function _withdraw (address receiver, address tokenAddr) internal {
221     assert (contractStage == 2);
222     var c = whitelist[receiver];
223     if (tokenAddr == 0x00) {
224       tokenAddr = activeToken;
225     }
226     var d = distributionMap[tokenAddr];
227     require ( (ethRefundAmount.length > c.ethRefund) || d.pct.length > c.tokensClaimed[tokenAddr] );
228     if (ethRefundAmount.length > c.ethRefund) {
229       uint pct = _toPct(c.balance,finalBalance);
230       uint ethAmount = 0;
231       for (uint i=c.ethRefund; i<ethRefundAmount.length; i++) {
232         ethAmount = ethAmount.add(_applyPct(ethRefundAmount[i],pct));
233       }
234       c.ethRefund = ethRefundAmount.length;
235       if (ethAmount > 0) {
236         receiver.transfer(ethAmount);
237         EthRefunded(receiver,ethAmount);
238       }
239     }
240     if (d.pct.length > c.tokensClaimed[tokenAddr]) {
241       uint tokenAmount = 0;
242       for (i=c.tokensClaimed[tokenAddr]; i<d.pct.length; i++) {
243         tokenAmount = tokenAmount.add(_applyPct(c.balance,d.pct[i]));
244       }
245       c.tokensClaimed[tokenAddr] = d.pct.length;
246       if (tokenAmount > 0) {
247         require(d.token.transfer(receiver,tokenAmount));
248         d.balanceRemaining = d.balanceRemaining.sub(tokenAmount);
249         TokensWithdrawn(receiver,tokenAddr,tokenAmount);
250       }  
251     }
252     
253   }
254   
255   
256   // This function is called by the owner to modify the contribution cap of a whitelisted address.
257   // If the current contribution balance exceeds the new cap, the excess balance is refunded.
258   function modifyIndividualCap (address addr, uint cap) public onlyOwner {
259     require (contractStage == 1);
260     require (cap <= maxContractBalance);
261     var c = whitelist[addr];
262     require (cap >= c.balance);
263     c.cap = cap;
264   }
265   
266   // This function is called by the owner to modify the cap.
267   function modifyCap (uint cap) public onlyOwner {
268     require (contractStage == 1);
269     require (contributionCap <= cap && maxContractBalance >= cap);
270     contributionCap = cap;
271     nextCapTime = 0;
272   }
273   
274   // This function is called by the owner to modify the cap at a future time.
275   function modifyNextCap (uint time, uint cap) public onlyOwner {
276     require (contractStage == 1);
277     require (contributionCap <= cap && maxContractBalance >= cap);
278     require (time > now);
279     nextCapTime = time;
280     nextContributionCap = cap;
281   }
282   
283   // This function is called to modify the maximum balance of the contract.
284   function modifyMaxContractBalance (uint amount) public onlyOwner {
285     require (contractStage == 1);
286     require (amount >= contributionMin);
287     require (amount >= this.balance);
288     maxContractBalance = amount;
289     if (amount < contributionCap) contributionCap = amount;
290   }
291   
292   function toggleWhitelist (bool active) public onlyOwner {
293     whitelistIsActive = active;
294   }
295   
296   // This callable function returns the total pool cap, current balance and remaining balance to be filled.
297   function checkPoolBalance () view public returns (uint poolCap, uint balance, uint remaining) {
298     if (contractStage == 1) {
299       remaining = maxContractBalance.sub(this.balance);
300     } else {
301       remaining = 0;
302     }
303     return (maxContractBalance,this.balance,remaining);
304   }
305   
306   // This callable function returns the balance, contribution cap, and remaining available balance of any contributor.
307   function checkContributorBalance (address addr) view public returns (uint balance, uint cap, uint remaining) {
308     var c = whitelist[addr];
309     if (contractStage == 2) return (c.balance,0,0);
310     if (whitelistIsActive && whitelistContract.isPaidUntil(addr) < now) return (c.balance,0,0);
311     if (c.cap > 0) cap = c.cap;
312     else cap = contributionCap;
313     if (cap.sub(c.balance) > maxContractBalance.sub(this.balance)) return (c.balance, cap, maxContractBalance.sub(this.balance));
314     return (c.balance, cap, cap.sub(c.balance));
315   }
316   
317   // This callable function returns the token balance that a contributor can currently claim.
318   function checkAvailableTokens (address addr, address tokenAddr) view public returns (uint tokenAmount) {
319     var c = whitelist[addr];
320     var d = distributionMap[tokenAddr];
321     for (uint i = c.tokensClaimed[tokenAddr]; i < d.pct.length; i++) {
322       tokenAmount = tokenAmount.add(_applyPct(c.balance, d.pct[i]));
323     }
324     return tokenAmount;
325   }
326    
327   // This function sets the receiving address that the contract will send the pooled eth to.
328   // It can only be called by the contract owner if the receiver address has not already been set.
329   // After making this call, the contract will be unable to send the pooled eth for 6000 blocks.
330   // This limitation is so that if the owner acts maliciously in making the change, all whitelisted
331   // addresses have ~24 hours to withdraw their eth from the contract.
332   function setReceiverAddress (address addr) public onlyOwner {
333     require (contractStage == 1);
334     receiverAddress = addr;
335     addressChangeBlock = block.number;
336     ReceiverAddressSet(addr);
337   }
338 
339   // This function sends the pooled eth to the receiving address, calculates the % of unused eth to be returned,
340   // and advances the contract to stage two. It can only be called by the contract owner during stages one or two.
341   // The amount to send (given in wei) must be specified during the call. As this function can only be executed once,
342   // it is VERY IMPORTANT not to get the amount wrong.
343   function submitPool (uint amountInWei) public onlyOwner noReentrancy {
344     require (contractStage == 1);
345     require (receiverAddress != 0x00);
346     require (block.number >= addressChangeBlock.add(6000));
347     if (amountInWei == 0) amountInWei = this.balance;
348     require (contributionMin <= amountInWei && amountInWei <= this.balance);
349     finalBalance = this.balance;
350     require (receiverAddress.call.value(amountInWei).gas(msg.gas.sub(5000))());
351     if (this.balance > 0) ethRefundAmount.push(this.balance);
352     contractStage = 2;
353     PoolSubmitted(receiverAddress, amountInWei);
354   }
355   
356   // This function opens the contract up for token withdrawals.
357   // It can only be called by the owner during stage two.  The owner specifies the address of an ERC20 token
358   // contract that this contract has a balance in, and optionally a bool to prevent this token from being
359   // the default withdrawal (in the event of an airdrop, for example).
360   function enableTokenWithdrawals (address tokenAddr, bool notDefault) public onlyOwner noReentrancy {
361     require (contractStage == 2);
362     if (notDefault) {
363       require (activeToken != 0x00);
364     } else {
365       activeToken = tokenAddr;
366     }
367     var d = distributionMap[tokenAddr];    
368     if (d.pct.length==0) d.token = ERC20(tokenAddr);
369     uint amount = d.token.balanceOf(this).sub(d.balanceRemaining);
370     require (amount > 0);
371     if (feePct > 0) {
372       require (d.token.transfer(owner,_applyPct(amount,feePct)));
373     }
374     amount = d.token.balanceOf(this).sub(d.balanceRemaining);
375     d.balanceRemaining = d.token.balanceOf(this);
376     d.pct.push(_toPct(amount,finalBalance));
377   }
378   
379   // This is a standard function required for ERC223 compatibility.
380   function tokenFallback (address from, uint value, bytes data) public {
381     ERC223Received (from, value);
382   }
383   
384 }