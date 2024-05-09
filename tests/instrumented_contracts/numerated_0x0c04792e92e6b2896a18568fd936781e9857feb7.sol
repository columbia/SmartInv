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
29 contract ERC20 {
30   function balanceOf(address _owner) constant returns (uint256 balance) {}
31   function transfer(address _to, uint256 _value) returns (bool success) {}
32 }
33 
34 
35 contract WhiteList {
36    function checkMemberLevel (address addr) view public returns (uint) {}
37 }
38 
39 
40 contract PresalePool {
41 
42   // SafeMath is a library to ensure that math operations do not have overflow errors
43   // https://zeppelin-solidity.readthedocs.io/en/latest/safemath.html
44   using SafeMath for uint;
45   
46   // The contract has 3 stages:
47   // 1 - The initial state. The owner is able to add addresses to the whitelist, and any whitelisted addresses can deposit or withdraw eth to the contract.
48   // 2 - The owner has closed the contract for further deposits. Whitelisted addresses can still withdraw eth from the contract.
49   // 3 - The eth is sent from the contract to the receiver. Unused eth can be claimed by contributors immediately. Once tokens are sent to the contract,
50   //     the owner enables withdrawals and contributors can withdraw their tokens.
51   uint8 public contractStage = 1;
52   
53   // These variables are set at the time of contract creation
54   // address that creates the contract
55   address public owner;
56   // maximum eth amount (in wei) that can be sent by a whitelisted address
57   uint[] public contributionCaps;
58   // the % of tokens kept by the contract owner
59   uint public feePct;
60   // the address that the pool will be paid out to
61   address public receiverAddress;
62   
63   // These constant variables do not change with each contract deployment
64   // minimum eth amount (in wei) that can be sent by a whitelisted address
65   uint constant public contributionMin = 100000000000000000;
66   // maximum gas price allowed for deposits in stage 1
67   uint constant public maxGasPrice = 50000000000;
68   // whitelisting contract
69   WhiteList constant public whitelistContract = WhiteList(0x8D95B038cA80A986425FA240C3C17Fb2B6e9bc63);
70   bool whitelistIsActive;
71   
72   // These variables are all initially set to 0 and will be set at some point during the contract
73   // epoch time that the next contribution caps become active
74   uint public nextCapTime;
75   // pending contribution caps
76   uint [] public nextContributionCaps;
77   // block number of the last change to the receiving address (set if receiving address is changed, stage 1 or 2)
78   uint public addressChangeBlock;
79   // amount of eth (in wei) present in the contract when it was submitted
80   uint public finalBalance;
81   // array containing eth amounts to be refunded in stage 3
82   uint[] public ethRefundAmount;
83   // default token contract to be used for withdrawing tokens in stage 3
84   address public activeToken;
85   
86   // data structure for holding the contribution amount, cap, eth refund status, and token withdrawal status for each whitelisted address
87   struct Contributor {
88     bool authorized;
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
146   function PresalePool(address receiverAddr, uint[] capAmounts, uint fee) public {
147     require (fee < 100);
148     require (capAmounts.length>1 && capAmounts.length<256);
149     for (uint8 i=1; i<capAmounts.length; i++) {
150       require (capAmounts[i] <= capAmounts[0]);
151     }
152     owner = msg.sender;
153     receiverAddress = receiverAddr;
154     contributionCaps = capAmounts;
155     feePct = _toPct(fee,100);
156     whitelist[msg.sender].authorized = true;
157   }
158   
159   // This function is called whenever eth is sent into the contract.
160   // The send will fail unless the contract is in stage one and the sender has been whitelisted.
161   // The amount sent is added to the balance in the Contributor struct associated with the sending address.
162   function () payable public {
163     if (contractStage == 1) {
164       _ethDeposit();
165     } else if (contractStage == 3) {
166       _ethRefund();
167     } else revert();
168   }
169   
170   // Internal function for handling eth deposits during contract stage one.
171   function _ethDeposit () internal {
172     assert (contractStage == 1);
173     require (tx.gasprice <= maxGasPrice);
174     require (this.balance <= contributionCaps[0]);
175     var c = whitelist[msg.sender];
176     uint newBalance = c.balance.add(msg.value);
177     require (newBalance >= contributionMin);
178     require (newBalance <= _checkCap(msg.sender));
179     c.balance = newBalance;
180     ContributorBalanceChanged(msg.sender, newBalance);
181   }
182   
183   // Internal function for handling eth refunds during stage three.
184   function _ethRefund () internal {
185     assert (contractStage == 3);
186     require (msg.sender == owner || msg.sender == receiverAddress);
187     require (msg.value >= contributionMin);
188     ethRefundAmount.push(msg.value);
189     EthRefundReceived(msg.sender, msg.value);
190   }
191   
192   // This function is called to withdraw eth or tokens from the contract.
193   // It can only be called by addresses that are whitelisted and show a balance greater than 0.
194   // If called during stages one or two, the full eth balance deposited into the contract is returned and the contributor's balance reset to 0.
195   // If called during stage three, the contributor's unused eth will be returned, as well as any available tokens.
196   // The token address may be provided optionally to withdraw tokens that are not currently the default token (airdrops).
197   function withdraw (address tokenAddr) public {
198     var c = whitelist[msg.sender];
199     require (c.balance > 0);
200     if (contractStage < 3) {
201       uint amountToTransfer = c.balance;
202       c.balance = 0;
203       msg.sender.transfer(amountToTransfer);
204       ContributorBalanceChanged(msg.sender, 0);
205     } else {
206       _withdraw(msg.sender,tokenAddr);
207     }  
208   }
209   
210   // This function allows the contract owner to force a withdrawal to any contributor.
211   function withdrawFor (address contributor, address tokenAddr) public onlyOwner {
212     require (contractStage == 3);
213     require (whitelist[contributor].balance > 0);
214     _withdraw(contributor,tokenAddr);
215   }
216   
217   // This internal function handles withdrawals during stage three.
218   // The associated events will fire to notify when a refund or token allocation is claimed.
219   function _withdraw (address receiver, address tokenAddr) internal {
220     assert (contractStage == 3);
221     var c = whitelist[receiver];
222     if (tokenAddr == 0x00) {
223       tokenAddr = activeToken;
224     }
225     var d = distributionMap[tokenAddr];
226     require ( (ethRefundAmount.length > c.ethRefund) || d.pct.length > c.tokensClaimed[tokenAddr] );
227     if (ethRefundAmount.length > c.ethRefund) {
228       uint pct = _toPct(c.balance,finalBalance);
229       uint ethAmount = 0;
230       for (uint i=c.ethRefund; i<ethRefundAmount.length; i++) {
231         ethAmount = ethAmount.add(_applyPct(ethRefundAmount[i],pct));
232       }
233       c.ethRefund = ethRefundAmount.length;
234       if (ethAmount > 0) {
235         receiver.transfer(ethAmount);
236         EthRefunded(receiver,ethAmount);
237       }
238     }
239     if (d.pct.length > c.tokensClaimed[tokenAddr]) {
240       uint tokenAmount = 0;
241       for (i=c.tokensClaimed[tokenAddr]; i<d.pct.length; i++) {
242         tokenAmount = tokenAmount.add(_applyPct(c.balance,d.pct[i]));
243       }
244       c.tokensClaimed[tokenAddr] = d.pct.length;
245       if (tokenAmount > 0) {
246         require(d.token.transfer(receiver,tokenAmount));
247         d.balanceRemaining = d.balanceRemaining.sub(tokenAmount);
248         TokensWithdrawn(receiver,tokenAddr,tokenAmount);
249       }  
250     }
251     
252   }
253   
254   // This function can only be executed by the owner, it adds an address to the whitelist.
255   // To execute, the contract must be in stage 1, the address cannot already be whitelisted, and the address cannot be a contract itself.
256   // Blocking contracts from being whitelisted prevents attacks from unexpected contract to contract interaction - very important!
257   function authorize (address addr, uint cap) public onlyOwner {
258     require (contractStage == 1);
259     _checkWhitelistContract(addr);
260     require (!whitelist[addr].authorized);
261     require ((cap > 0 && cap < contributionCaps.length) || (cap >= contributionMin && cap <= contributionCaps[0]) );
262     uint size;
263     assembly { size := extcodesize(addr) }
264     require (size == 0);
265     whitelist[addr].cap = cap;
266     whitelist[addr].authorized = true;
267   }
268   
269   // This function is used by the owner to authorize many addresses in a single call.
270   // Each address will be given the same cap, and the cap must be one of the standard levels.
271   function authorizeMany (address[] addr, uint cap) public onlyOwner {
272     require (addr.length < 255);
273     require (cap > 0 && cap < contributionCaps.length);
274     for (uint8 i=0; i<addr.length; i++) {
275       authorize(addr[i], cap);
276     }
277   }
278   
279   // This function is called by the owner to remove an address from the whitelist.
280   // It may only be executed during stages 1 and 2.  Any eth sent by the address is refunded and their personal cap is set to 0.
281   // It will throw if the address is still authorised in the whitelist contract.
282   function revoke (address addr) public onlyOwner {
283     require (contractStage < 3);
284     require (whitelist[addr].authorized);
285     require (whitelistContract.checkMemberLevel(addr) == 0);
286     whitelist[addr].authorized = false;
287     if (whitelist[addr].balance > 0) {
288       uint amountToTransfer = whitelist[addr].balance;
289       whitelist[addr].balance = 0;
290       addr.transfer(amountToTransfer);
291       ContributorBalanceChanged(addr, 0);
292     }
293   }
294   
295   // This function is called by the owner to modify the contribution cap of a whitelisted address.
296   // If the current contribution balance exceeds the new cap, the excess balance is refunded.
297   function modifyIndividualCap (address addr, uint cap) public onlyOwner {
298     require (contractStage < 3);
299     require (cap < contributionCaps.length || (cap >= contributionMin && cap <= contributionCaps[0]) );
300     _checkWhitelistContract(addr);
301     var c = whitelist[addr];
302     require (c.authorized);
303     uint amount = c.balance;
304     c.cap = cap;
305     uint capAmount = _checkCap(addr);
306     if (amount > capAmount) {
307       c.balance = capAmount;
308       addr.transfer(amount.sub(capAmount));
309       ContributorBalanceChanged(addr, capAmount);
310     }
311   }
312   
313   // This function is called by the owner to modify the cap for a contribution level.
314   // The cap cannot be decreased below the current balance or increased past the contract limit.
315   function modifyLevelCap (uint level, uint cap) public onlyOwner {
316     require (contractStage < 3);
317     require (level > 0 && level < contributionCaps.length);
318     require (this.balance <= cap && contributionCaps[0] >= cap);
319     contributionCaps[level] = cap;
320     nextCapTime = 0;
321   }
322   
323   // This function changes every level cap at once, with an optional delay.
324   // Modifying the caps immediately will cancel any delayed cap change.
325   function modifyAllLevelCaps (uint[] cap, uint time) public onlyOwner {
326     require (contractStage < 3);
327     require (cap.length == contributionCaps.length-1);
328     require (time == 0 || time>block.timestamp);
329     if (time == 0) {
330       for (uint8 i = 0; i < cap.length; i++) {
331         modifyLevelCap(i+1, cap[i]);
332       }
333     } else {
334       nextContributionCaps = contributionCaps;
335       nextCapTime = time;
336       for (i = 0; i < cap.length; i++) {
337         require (contributionCaps[i+1] <= cap[i] && contributionCaps[0] >= cap[i]);
338         nextContributionCaps[i+1] = cap[i];
339       }
340     }
341   }
342   
343   // This function can be called during stages one or two to modify the maximum balance of the contract.
344   // It can only be called by the owner. The amount cannot be set to lower than the current balance of the contract.
345   function modifyMaxContractBalance (uint amount) public onlyOwner {
346     require (contractStage < 3);
347     require (amount >= contributionMin);
348     require (amount >= this.balance);
349     contributionCaps[0] = amount;
350     nextCapTime = 0;
351     for (uint8 i=1; i<contributionCaps.length; i++) {
352       if (contributionCaps[i]>amount) contributionCaps[i]=amount;
353     }
354   }
355   
356   function toggleWhitelist (bool active) public onlyOwner {
357     whitelistIsActive = active;
358   }
359   
360   // This internal function returns the cap amount of a whitelisted address.
361   function _checkCap (address addr) internal returns (uint) {
362     if (!whitelistIsActive) return contributionCaps[0];
363     _checkWhitelistContract(addr);
364     var c = whitelist[addr];
365     if (!c.authorized) return 0;
366     if (nextCapTime>0 && block.timestamp>nextCapTime) {
367       contributionCaps = nextContributionCaps;
368       nextCapTime = 0;
369     }
370     if (c.cap<contributionCaps.length) return contributionCaps[c.cap];
371     return c.cap; 
372   }
373   
374   // This internal function checks if an address is whitelisted in the whitelist contract.
375   function _checkWhitelistContract (address addr) internal {
376     var c = whitelist[addr];
377     if (!c.authorized) {
378       var level = whitelistContract.checkMemberLevel(addr);
379       if (level == 0 || level >= contributionCaps.length) return;
380       c.cap = level;
381       c.authorized = true;
382     }
383   }
384   
385   // This callable function returns the total pool cap, current balance and remaining balance to be filled.
386   function checkPoolBalance () view public returns (uint poolCap, uint balance, uint remaining) {
387     if (contractStage == 1) {
388       remaining = contributionCaps[0].sub(this.balance);
389     } else {
390       remaining = 0;
391     }
392     return (contributionCaps[0],this.balance,remaining);
393   }
394   
395   // This callable function returns the balance, contribution cap, and remaining available balance of any contributor.
396   function checkContributorBalance (address addr) view public returns (uint balance, uint cap, uint remaining) {
397     var c = whitelist[addr];
398     if (!whitelistIsActive) cap = contributionCaps[0];
399     else if (!c.authorized) {
400       cap = whitelistContract.checkMemberLevel(addr);
401       if (cap == 0) return (c.balance,0,0);
402     } else {
403       cap = c.cap;
404     }
405     balance = c.balance;
406     if (contractStage == 1) {
407       if (cap<contributionCaps.length) { 
408         if (nextCapTime == 0 || nextCapTime > block.timestamp) {
409           cap = contributionCaps[cap];
410         } else {
411           cap = nextContributionCaps[cap];
412         }
413       }
414       remaining = cap.sub(balance);
415       if (contributionCaps[0].sub(this.balance) < remaining) remaining = contributionCaps[0].sub(this.balance);
416     } else {
417       remaining = 0;
418     }
419     return (balance, cap, remaining);
420   }
421   
422   // This callable function returns the token balance that a contributor can currently claim.
423   function checkAvailableTokens (address addr, address tokenAddr) view public returns (uint tokenAmount) {
424     var c = whitelist[addr];
425     var d = distributionMap[tokenAddr];
426     for (uint i = c.tokensClaimed[tokenAddr]; i < d.pct.length; i++) {
427       tokenAmount = tokenAmount.add(_applyPct(c.balance, d.pct[i]));
428     }
429     return tokenAmount;
430   }
431   
432   // This function closes further contributions to the contract, advancing it to stage two.
433   // It can only be called by the owner.  After this call has been made, whitelisted addresses
434   // can still remove their eth from the contract but cannot contribute any more.
435   function closeContributions () public onlyOwner {
436     require (contractStage == 1);
437     contractStage = 2;
438   }
439   
440   // This function reopens the contract to contributions and further whitelisting, returning it to stage one.
441   // It can only be called by the owner during stage two.
442   function reopenContributions () public onlyOwner {
443     require (contractStage == 2);
444     contractStage = 1;
445   }
446   
447   // This function sets the receiving address that the contract will send the pooled eth to.
448   // It can only be called by the contract owner if the receiver address has not already been set.
449   // After making this call, the contract will be unable to send the pooled eth for 6000 blocks.
450   // This limitation is so that if the owner acts maliciously in making the change, all whitelisted
451   // addresses have ~24 hours to withdraw their eth from the contract.
452   function setReceiverAddress (address addr) public onlyOwner {
453     require (addr != 0x00 && receiverAddress == 0x00);
454     require (contractStage < 3);
455     receiverAddress = addr;
456     addressChangeBlock = block.number;
457     ReceiverAddressSet(addr);
458   }
459 
460   // This function sends the pooled eth to the receiving address, calculates the % of unused eth to be returned,
461   // and advances the contract to stage three. It can only be called by the contract owner during stages one or two.
462   // The amount to send (given in wei) must be specified during the call. As this function can only be executed once,
463   // it is VERY IMPORTANT not to get the amount wrong.
464   function submitPool (uint amountInWei) public onlyOwner noReentrancy {
465     require (contractStage < 3);
466     require (receiverAddress != 0x00);
467     require (block.number >= addressChangeBlock.add(6000));
468     require (contributionMin <= amountInWei && amountInWei <= this.balance);
469     finalBalance = this.balance;
470     require (receiverAddress.call.value(amountInWei).gas(msg.gas.sub(5000))());
471     if (this.balance > 0) ethRefundAmount.push(this.balance);
472     contractStage = 3;
473     PoolSubmitted(receiverAddress, amountInWei);
474   }
475   
476   // This function opens the contract up for token withdrawals.
477   // It can only be called by the owner during stage 3.  The owner specifies the address of an ERC20 token
478   // contract that this contract has a balance in, and optionally a bool to prevent this token from being
479   // the default withdrawal (in the event of an airdrop, for example).
480   function enableTokenWithdrawals (address tokenAddr, bool notDefault) public onlyOwner noReentrancy {
481     require (contractStage == 3);
482     if (notDefault) {
483       require (activeToken != 0x00);
484     } else {
485       activeToken = tokenAddr;
486     }
487     var d = distributionMap[tokenAddr];    
488     if (d.pct.length==0) d.token = ERC20(tokenAddr);
489     uint amount = d.token.balanceOf(this).sub(d.balanceRemaining);
490     require (amount > 0);
491     if (feePct > 0) {
492       require (d.token.transfer(owner,_applyPct(amount,feePct)));
493     }
494     amount = d.token.balanceOf(this).sub(d.balanceRemaining);
495     d.balanceRemaining = d.token.balanceOf(this);
496     d.pct.push(_toPct(amount,finalBalance));
497   }
498   
499   // This is a standard function required for ERC223 compatibility.
500   function tokenFallback (address from, uint value, bytes data) public {
501     ERC223Received (from, value);
502   }
503   
504 }