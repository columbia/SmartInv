1 pragma solidity ^0.4.19;
2 
3 // Wolf Crypto pooling contract for Refereum
4 // written by @iamdefinitelyahuman
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 
40 contract ERC20 {
41   function balanceOf(address _owner) constant returns (uint256 balance) {}
42   function transfer(address _to, uint256 _value) returns (bool success) {}
43 }
44 
45 
46 contract WhiteList {
47    function checkMemberLevel (address addr) view public returns (uint) {}
48 }
49 
50 
51 contract PresalePool {
52 
53   // SafeMath is a library to ensure that math operations do not have overflow errors
54   // https://zeppelin-solidity.readthedocs.io/en/latest/safemath.html
55   using SafeMath for uint;
56   
57   // The contract has 3 stages:
58   // 1 - The initial state. The owner is able to add addresses to the whitelist, and any whitelisted addresses can deposit or withdraw eth to the contract.
59   // 2 - The owner has closed the contract for further deposits. Whitelisted addresses can still withdraw eth from the contract.
60   // 3 - The eth is sent from the contract to the receiver. Unused eth can be claimed by contributors immediately. Once tokens are sent to the contract,
61   //     the owner enables withdrawals and contributors can withdraw their tokens.
62   uint8 public contractStage = 1;
63   
64   // These variables are set at the time of contract creation
65   // the address that creates the contract
66   address public owner;
67   // the minimum eth amount (in wei) that can be sent by a whitelisted address
68   uint public contributionMin;
69   // the maximum eth amount (in wei) that can be sent by a whitelisted address
70   uint[] public contributionCaps;
71   // the % of tokens kept by the contract owner
72   uint public feePct;
73   // the address that the pool will be paid out to
74   address public receiverAddress;
75   // the maximum gas price allowed for deposits in stage 1
76   uint constant public maxGasPrice = 50000000000;
77   // the whitelisting contract
78   WhiteList public whitelistContract;
79   
80   // These variables are all initially set to 0 and will be set at some point during the contract
81   // the amount of eth (in wei) present in the contract when it was submitted
82   uint public finalBalance;
83   // an array containing eth amounts to be refunded in stage 3
84   uint[] public ethRefundAmount;
85   // the default token contract to be used for withdrawing tokens in stage 3
86   address public activeToken;
87   
88   // a data structure for holding the contribution amount, cap, eth refund status, and token withdrawal status for each whitelisted address
89   struct Contributor {
90     bool authorized;
91     uint ethRefund;
92     uint balance;
93     uint cap;
94     mapping (address => uint) tokensClaimed;
95   }
96   // a mapping that holds the contributor struct for each whitelisted address
97   mapping (address => Contributor) whitelist;
98   
99   // a data structure for holding information related to token withdrawals.
100   struct TokenAllocation {
101     ERC20 token;
102     uint[] pct;
103     uint balanceRemaining;
104   }
105   // a mapping that holds the token allocation struct for each token address
106   mapping (address => TokenAllocation) distribution;
107   
108   
109   // this modifier is used for functions that can only be accessed by the contract creator
110   modifier onlyOwner () {
111     require (msg.sender == owner);
112     _;
113   }
114   
115   // this modifier is used to prevent re-entrancy exploits during contract > contract interaction
116   bool locked;
117   modifier noReentrancy() {
118     require(!locked);
119     locked = true;
120     _;
121     locked = false;
122   }
123   
124   // Events triggered throughout contract execution
125   // These can be watched via geth filters to keep up-to-date with the contract
126   event ContributorBalanceChanged (address contributor, uint totalBalance);
127   event TokensWithdrawn (address receiver, uint amount);
128   event EthRefunded (address receiver, uint amount);
129   event WithdrawalsOpen (address tokenAddr);
130   event ERC223Received (address token, uint value);
131   event EthRefundReceived (address sender, uint amount);
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
146   function PresalePool(address receiverAddr, address whitelistAddr, uint individualMin, uint[] capAmounts, uint fee) public {
147     require (receiverAddr != 0x00);
148     require (fee < 100);
149     require (100000000000000000 <= individualMin);
150     require (capAmounts.length>1 && capAmounts.length<256);
151     for (uint8 i=1; i<capAmounts.length; i++) {
152       require (capAmounts[i] <= capAmounts[0]);
153     }
154     owner = msg.sender;
155     receiverAddress = receiverAddr;
156     contributionMin = individualMin;
157     contributionCaps = capAmounts;
158     feePct = _toPct(fee,100);
159     whitelistContract = WhiteList(whitelistAddr);
160     whitelist[msg.sender].authorized = true;
161   }
162   
163   // This function is called whenever eth is sent into the contract.
164   // The send will fail unless the contract is in stage one and the sender has been whitelisted.
165   // The amount sent is added to the balance in the Contributor struct associated with the sending address.
166   function () payable public {
167     if (contractStage == 1) {
168       _ethDeposit();
169     } else if (contractStage == 3) {
170       _ethRefund();
171     } else revert();
172   }
173   
174   // Internal function for handling eth deposits during contract stage one.
175   function _ethDeposit () internal {
176     assert (contractStage == 1);
177     require (tx.gasprice <= maxGasPrice);
178     require (this.balance <= contributionCaps[0]);
179     var c = whitelist[msg.sender];
180     uint newBalance = c.balance.add(msg.value);
181     require (newBalance >= contributionMin);
182     require (newBalance <= _checkCap(msg.sender));
183     c.balance = newBalance;
184     ContributorBalanceChanged(msg.sender, newBalance);
185   }
186   
187   // Internal function for handling eth refunds during stage three.
188   function _ethRefund () internal {
189     assert (contractStage == 3);
190     require (msg.sender == owner || msg.sender == receiverAddress);
191     require (msg.value >= contributionMin);
192     ethRefundAmount.push(msg.value);
193     EthRefundReceived(msg.sender, msg.value);
194   }
195   
196   // This function is called to withdraw eth or tokens from the contract.
197   // It can only be called by addresses that are whitelisted and show a balance greater than 0.
198   // If called during contract stages one or two, the full eth balance deposited into the contract will be returned and the contributor's balance will be reset to 0.
199   // If called during stage three, the contributor's unused eth will be returned, as well as any available tokens.
200   // The token address may be provided optionally to withdraw tokens that are not currently the default token (airdrops).
201   function withdraw (address tokenAddr) public {
202     var c = whitelist[msg.sender];
203     require (c.balance > 0);
204     if (contractStage < 3) {
205       uint amountToTransfer = c.balance;
206       c.balance = 0;
207       msg.sender.transfer(amountToTransfer);
208       ContributorBalanceChanged(msg.sender, 0);
209     } else {
210       _withdraw(msg.sender,tokenAddr);
211     }  
212   }
213   
214   // This function allows the contract owner to force a withdrawal to any contributor.
215   function withdrawFor (address contributor, address tokenAddr) public onlyOwner {
216     require (contractStage == 3);
217     require (whitelist[contributor].balance > 0);
218     _withdraw(contributor,tokenAddr);
219   }
220   
221   // This internal function handles withdrawals during stage three.
222   // The associated events will fire to notify when a refund or token allocation is claimed.
223   function _withdraw (address receiver, address tokenAddr) internal {
224     assert (contractStage == 3);
225     var c = whitelist[receiver];
226     if (tokenAddr == 0x00) {
227       tokenAddr = activeToken;
228     }
229     var d = distribution[tokenAddr];
230     require ( (ethRefundAmount.length > c.ethRefund) || d.pct.length > c.tokensClaimed[tokenAddr] );
231     if (ethRefundAmount.length > c.ethRefund) {
232       uint pct = _toPct(c.balance,finalBalance);
233       uint ethAmount = 0;
234       for (uint i=c.ethRefund; i<ethRefundAmount.length; i++) {
235         ethAmount = ethAmount.add(_applyPct(ethRefundAmount[i],pct));
236       }
237       c.ethRefund = ethRefundAmount.length;
238       if (ethAmount > 0) {
239         receiver.transfer(ethAmount);
240         EthRefunded(receiver,ethAmount);
241       }
242     }
243     if (d.pct.length > c.tokensClaimed[tokenAddr]) {
244       uint tokenAmount = 0;
245       for (i=c.tokensClaimed[tokenAddr]; i<d.pct.length; i++) {
246         tokenAmount = tokenAmount.add(_applyPct(c.balance,d.pct[i]));
247       }
248       c.tokensClaimed[tokenAddr] = d.pct.length;
249       if (tokenAmount > 0) {
250         require(d.token.transfer(receiver,tokenAmount));
251         d.balanceRemaining = d.balanceRemaining.sub(tokenAmount);
252         TokensWithdrawn(receiver,tokenAmount);
253       }  
254     }
255     
256   }
257   
258   // This function can only be executed by the owner, it adds an address to the whitelist.
259   // To execute, the contract must be in stage 1, the address cannot already be whitelisted, and the address cannot be a contract itself.
260   // Blocking contracts from being whitelisted prevents attacks from unexpected contract to contract interaction - very important!
261   function authorize (address addr, uint cap) public onlyOwner {
262     require (contractStage == 1);
263     _checkWhitelistContract(addr);
264     require (!whitelist[addr].authorized);
265     require ((cap > 0 && cap < contributionCaps.length) || (cap >= contributionMin && cap <= contributionCaps[0]) );
266     uint size;
267     assembly { size := extcodesize(addr) }
268     require (size == 0);
269     whitelist[addr].cap = cap;
270     whitelist[addr].authorized = true;
271   }
272   
273   // This function is used by the owner to authorize many addresses in a single call.
274   // Each address will be given the same cap, and the cap must be one of the standard levels.
275   function authorizeMany (address[] addr, uint cap) public onlyOwner {
276     require (addr.length < 255);
277     require (cap > 0 && cap < contributionCaps.length);
278     for (uint8 i=0; i<addr.length; i++) {
279       authorize(addr[i], cap);
280     }
281   }
282   
283   // This function is called by the owner to remove an address from the whitelist.
284   // It may only be executed during stages 1 and 2.  Any eth sent by the address is refunded and their personal cap is set to 0.
285   // It will throw if the address is still authorised in the whitelist contract.
286   function revoke (address addr) public onlyOwner {
287     require (contractStage < 3);
288     require (whitelist[addr].authorized);
289     require (whitelistContract.checkMemberLevel(addr) == 0);
290     whitelist[addr].authorized = false;
291     if (whitelist[addr].balance > 0) {
292       uint amountToTransfer = whitelist[addr].balance;
293       whitelist[addr].balance = 0;
294       addr.transfer(amountToTransfer);
295       ContributorBalanceChanged(addr, 0);
296     }
297   }
298   
299   // This function is called by the owner to modify the contribution cap of a whitelisted address.
300   // If the current contribution balance exceeds the new cap, the excess balance is refunded.
301   function modifyIndividualCap (address addr, uint cap) public onlyOwner {
302     require (contractStage < 3);
303     require (cap < contributionCaps.length || (cap >= contributionMin && cap <= contributionCaps[0]) );
304     _checkWhitelistContract(addr);
305     var c = whitelist[addr];
306     require (c.authorized);
307     uint amount = c.balance;
308     c.cap = cap;
309     uint capAmount = _checkCap(addr);
310     if (amount > capAmount) {
311       c.balance = capAmount;
312       addr.transfer(amount.sub(capAmount));
313       ContributorBalanceChanged(addr, capAmount);
314     }
315   }
316   
317   // This function is called by the owner to modify the cap for a contribution level.
318   // The cap can only be increased, not decreased, and cannot exceed the contract limit.
319   function modifyLevelCap (uint level, uint cap) public onlyOwner {
320     require (contractStage < 3);
321     require (level > 0 && level < contributionCaps.length);
322     require (contributionCaps[level] < cap && contributionCaps[0] >= cap);
323     contributionCaps[level] = cap;
324   }
325   
326   // This function changes every level cap at once.
327   function modifyLevelCaps (uint[] cap) public onlyOwner {
328     require (contractStage < 3);
329     require (cap.length == contributionCaps.length-1);
330     for (uint8 i = 1; i<contributionCaps.length; i++) {
331       modifyLevelCap(i,cap[i-1]);
332     }
333   }
334   
335   
336   // This function can be called during stages one or two to modify the maximum balance of the contract.
337   // It can only be called by the owner. The amount cannot be set to lower than the current balance of the contract.
338   function modifyMaxContractBalance (uint amount) public onlyOwner {
339     require (contractStage < 3);
340     require (amount >= contributionMin);
341     require (amount >= this.balance);
342     contributionCaps[0] = amount;
343     for (uint8 i=1; i<contributionCaps.length; i++) {
344       if (contributionCaps[i]>amount) contributionCaps[i]=amount;
345     }
346   }
347   
348   // This internal function returns the cap amount of a whitelisted address.
349   function _checkCap (address addr) internal returns (uint) {
350     _checkWhitelistContract(addr);
351     var c = whitelist[addr];
352     if (!c.authorized) return 0;
353     if (c.cap<contributionCaps.length) return contributionCaps[c.cap];
354     return c.cap; 
355   }
356   
357   // This internal function checks if an address is whitelisted in the whitelist contract.
358   function _checkWhitelistContract (address addr) internal {
359     var c = whitelist[addr];
360     if (!c.authorized) {
361       var level = whitelistContract.checkMemberLevel(addr);
362       if (level == 0 || level >= contributionCaps.length) return;
363       c.cap = level;
364       c.authorized = true;
365     }
366   }
367   
368   // This callable function returns the total pool cap, current balance and remaining balance to be filled.
369   function checkPoolBalance () view public returns (uint poolCap, uint balance, uint remaining) {
370     if (contractStage == 1) {
371       remaining = contributionCaps[0].sub(this.balance);
372     } else {
373       remaining = 0;
374     }
375     return (contributionCaps[0],this.balance,remaining);
376   }
377   
378   // This callable function returns the balance, contribution cap, and remaining available balance of any contributor.
379   function checkContributorBalance (address addr) view public returns (uint balance, uint cap, uint remaining) {
380     var c = whitelist[addr];
381     if (!c.authorized) {
382       cap = whitelistContract.checkMemberLevel(addr);
383       if (cap == 0) return (0,0,0);
384     } else {
385       cap = c.cap;
386     }
387     balance = c.balance;
388     if (contractStage == 1) {
389       if (cap<contributionCaps.length) {
390         cap = contributionCaps[cap];
391       }
392       remaining = cap.sub(balance);
393       if (contributionCaps[0].sub(this.balance) < remaining) remaining = contributionCaps[0].sub(this.balance);
394     } else {
395       remaining = 0;
396     }
397     return (balance, cap, remaining);
398   }
399   
400   // This callable function returns the token balance that a contributor can currently claim.
401   function checkAvailableTokens (address addr, address tokenAddr) view public returns (uint tokenAmount) {
402     var c = whitelist[addr];
403     var d = distribution[tokenAddr];
404     for (uint i=c.tokensClaimed[tokenAddr]; i<d.pct.length; i++) {
405       tokenAmount = tokenAmount.add(_applyPct(c.balance,d.pct[i]));
406     }
407     return tokenAmount;
408   }
409   
410   // This function closes further contributions to the contract, advancing it to stage two.
411   // It can only be called by the owner.  After this call has been made, whitelisted addresses
412   // can still remove their eth from the contract but cannot contribute any more.
413   function closeContributions () public onlyOwner {
414     require (contractStage == 1);
415     contractStage = 2;
416   }
417   
418   // This function reopens the contract to contributions and further whitelisting, returning it to stage one.
419   // It can only be called by the owner during stage two.
420   function reopenContributions () public onlyOwner {
421     require (contractStage == 2);
422     contractStage = 1;
423   }
424   
425 
426   // This function sends the pooled eth to the receiving address, calculates the % of unused eth to be returned,
427   // and advances the contract to stage three. It can only be called by the contract owner during stages one or two.
428   // The amount to send (given in wei) must be specified during the call. As this function can only be executed once,
429   // it is VERY IMPORTANT not to get the amount wrong.
430   function submitPool (uint amountInWei) public onlyOwner noReentrancy {
431     require (contractStage < 3);
432     require (contributionMin <= amountInWei && amountInWei <= this.balance);
433     finalBalance = this.balance;
434     require (receiverAddress.call.value(amountInWei).gas(msg.gas.sub(5000))());
435     ethRefundAmount.push(this.balance);
436     contractStage = 3;
437   }
438   
439   // This function opens the contract up for token withdrawals.
440   // It can only be called by the owner during stage 3.  The owner specifies the address of an ERC20 token
441   // contract that this contract has a balance in, and optionally a bool to prevent this token from being
442   // the default withdrawal (in the event of an airdrop, for example).
443   // The function can only be called if there is not currently a token distribution 
444   function enableTokenWithdrawals (address tokenAddr, bool notDefault) public onlyOwner noReentrancy {
445     require (contractStage == 3);
446     if (notDefault) {
447       require (activeToken != 0x00);
448     } else {
449       activeToken = tokenAddr;
450     }
451     var d = distribution[tokenAddr];    
452     if (d.pct.length==0) d.token = ERC20(tokenAddr);
453     uint amount = d.token.balanceOf(this).sub(d.balanceRemaining);
454     require (amount > 0);
455     if (feePct > 0) {
456       require (d.token.transfer(owner,_applyPct(amount,feePct)));
457     }
458     amount = d.token.balanceOf(this).sub(d.balanceRemaining);
459     d.balanceRemaining = d.token.balanceOf(this);
460     d.pct.push(_toPct(amount,finalBalance));
461   }
462   
463   // This is a standard function required for ERC223 compatibility.
464   function tokenFallback (address from, uint value, bytes data) public {
465     ERC223Received (from, value);
466   }
467   
468 }