1 pragma solidity ^0.4.19;
2 
3 // Wolf Crypto pooling contract for Fintrux
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
67   // the addresses of all administrators
68   address[] public admins;
69   // the minimum eth amount (in wei) that can be sent by a whitelisted address
70   uint public contributionMin;
71   // the maximum eth amount (in wei) that can be sent by a whitelisted address
72   uint[] public contributionCaps;
73   // the % of tokens kept by the contract owner
74   uint public feePct;
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
110   modifier onlyAdmins () {
111     for (uint8 i=0; i<admins.length; i++) {
112       if (msg.sender==admins[i]) {
113         _;
114         return;
115       }
116     }
117     revert();
118   }
119   
120   // this modifier is used to prevent re-entrancy exploits during contract > contract interaction
121   bool locked;
122   modifier noReentrancy() {
123     require(!locked);
124     locked = true;
125     _;
126     locked = false;
127   }
128   
129   // Events triggered throughout contract execution
130   // These can be watched via geth filters to keep up-to-date with the contract
131   event ContributorBalanceChanged (address contributor, uint totalBalance);
132   event ReceiverAddressChanged ( address _addr);
133   event TokensWithdrawn (address receiver, uint amount);
134   event EthRefunded (address receiver, uint amount);
135   event WithdrawalsOpen (address tokenAddr);
136   event ERC223Received (address token, uint value);
137   event EthRefundReceived (address sender, uint amount);
138    
139   // These are internal functions used for calculating fees, eth and token allocations as %
140   // returns a value as a % accurate to 20 decimal points
141   function _toPct (uint numerator, uint denominator ) internal pure returns (uint) {
142     return numerator.mul(10 ** 20) / denominator;
143   }
144   
145   // returns % of any number, where % given was generated with toPct
146   function _applyPct (uint numerator, uint pct) internal pure returns (uint) {
147     return numerator.mul(pct) / (10 ** 20);
148   }
149   
150   // This function is called at the time of contract creation,
151   // it sets the initial variables and whitelists the contract owner.
152   function PresalePool(address[] adminList, address whitelistAddr, uint individualMin, uint[] capAmounts, uint fee) public {
153     require (fee < 100);
154     require (100000000000000000 <= individualMin);
155     require (capAmounts.length>1 && capAmounts.length<256);
156     for (uint8 i=1; i<capAmounts.length; i++) {
157       require (capAmounts[i] <= capAmounts[0]);
158     }
159     owner = msg.sender;
160     admins = adminList;
161     admins.push(msg.sender);
162     contributionMin = individualMin;
163     contributionCaps = capAmounts;
164     feePct = _toPct(fee,100);
165     whitelistContract = WhiteList(whitelistAddr);
166     whitelist[msg.sender].authorized = true;
167   }
168   
169   // This function is called whenever eth is sent into the contract.
170   // The send will fail unless the contract is in stage one and the sender has been whitelisted.
171   // The amount sent is added to the balance in the Contributor struct associated with the sending address.
172   function () payable public {
173     if (contractStage == 1) {
174       _ethDeposit();
175     } else if (contractStage == 3) {
176       _ethRefund();
177     } else revert();
178   }
179   
180   // Internal function for handling eth deposits during contract stage one.
181   function _ethDeposit () internal {
182     assert (contractStage == 1);
183     require (tx.gasprice <= maxGasPrice);
184     require (this.balance <= contributionCaps[0]);
185     var c = whitelist[msg.sender];
186     uint newBalance = c.balance.add(msg.value);
187     require (newBalance >= contributionMin);
188     require (newBalance <= _checkCap(msg.sender));
189     c.balance = newBalance;
190     ContributorBalanceChanged(msg.sender, newBalance);
191   }
192   
193   // Internal function for handling eth refunds during stage three.
194   function _ethRefund () internal {
195     assert (contractStage == 3);
196     require (msg.sender == owner);
197     require (msg.value >= contributionMin);
198     ethRefundAmount.push(msg.value);
199     EthRefundReceived(msg.sender, msg.value);
200   }
201   
202   // This function is called to withdraw eth or tokens from the contract.
203   // It can only be called by addresses that are whitelisted and show a balance greater than 0.
204   // If called during contract stages one or two, the full eth balance deposited into the contract will be returned and the contributor's balance will be reset to 0.
205   // If called during stage three, the contributor's unused eth will be returned, as well as any available tokens.
206   // The token address may be provided optionally to withdraw tokens that are not currently the default token (airdrops).
207   function withdraw (address tokenAddr) public {
208     var c = whitelist[msg.sender];
209     require (c.balance > 0);
210     if (contractStage < 3) {
211       uint amountToTransfer = c.balance;
212       c.balance = 0;
213       msg.sender.transfer(amountToTransfer);
214       ContributorBalanceChanged(msg.sender, 0);
215     } else {
216       _withdraw(msg.sender,tokenAddr);
217     }  
218   }
219   
220   // This function allows the contract owner to force a withdrawal to any contributor.
221   function withdrawFor (address contributor, address tokenAddr) public onlyAdmins {
222     require (contractStage == 3);
223     require (whitelist[contributor].balance > 0);
224     _withdraw(contributor,tokenAddr);
225   }
226   
227   // This internal function handles withdrawals during stage three.
228   // The associated events will fire to notify when a refund or token allocation is claimed.
229   function _withdraw (address receiver, address tokenAddr) internal {
230     assert (contractStage == 3);
231     var c = whitelist[receiver];
232     if (tokenAddr == 0x00) {
233       tokenAddr = activeToken;
234     }
235     var d = distribution[tokenAddr];
236     require ( (ethRefundAmount.length > c.ethRefund) || d.pct.length > c.tokensClaimed[tokenAddr] );
237     if (ethRefundAmount.length > c.ethRefund) {
238       uint pct = _toPct(c.balance,finalBalance);
239       uint ethAmount = 0;
240       for (uint i=c.ethRefund; i<ethRefundAmount.length; i++) {
241         ethAmount = ethAmount.add(_applyPct(ethRefundAmount[i],pct));
242       }
243       c.ethRefund = ethRefundAmount.length;
244       if (ethAmount > 0) {
245         receiver.transfer(ethAmount);
246         EthRefunded(receiver,ethAmount);
247       }
248     }
249     if (d.pct.length > c.tokensClaimed[tokenAddr]) {
250       uint tokenAmount = 0;
251       for (i=c.tokensClaimed[tokenAddr]; i<d.pct.length; i++) {
252         tokenAmount = tokenAmount.add(_applyPct(c.balance,d.pct[i]));
253       }
254       c.tokensClaimed[tokenAddr] = d.pct.length;
255       if (tokenAmount > 0) {
256         require(d.token.transfer(receiver,tokenAmount));
257         d.balanceRemaining = d.balanceRemaining.sub(tokenAmount);
258         TokensWithdrawn(receiver,tokenAmount);
259       }  
260     }
261     
262   }
263   
264   // This function can only be executed by the owner, it adds an address to the whitelist.
265   // To execute, the contract must be in stage 1, the address cannot already be whitelisted, and the address cannot be a contract itself.
266   // Blocking contracts from being whitelisted prevents attacks from unexpected contract to contract interaction - very important!
267   function authorize (address addr, uint cap) public onlyAdmins {
268     require (contractStage == 1);
269     _checkWhitelistContract(addr);
270     require (!whitelist[addr].authorized);
271     require ((cap > 0 && cap < contributionCaps.length) || (cap >= contributionMin && cap <= contributionCaps[0]) );
272     uint size;
273     assembly { size := extcodesize(addr) }
274     require (size == 0);
275     whitelist[addr].cap = cap;
276     whitelist[addr].authorized = true;
277   }
278   
279   // This function is used by the owner to authorize many addresses in a single call.
280   // Each address will be given the same cap, and the cap must be one of the standard levels.
281   function authorizeMany (address[] addr, uint cap) public onlyAdmins {
282     require (addr.length < 255);
283     require (cap > 0 && cap < contributionCaps.length);
284     for (uint8 i=0; i<addr.length; i++) {
285       authorize(addr[i], cap);
286     }
287   }
288   
289   // This function is called by the owner to remove an address from the whitelist.
290   // It may only be executed during stages 1 and 2.  Any eth sent by the address is refunded and their personal cap is set to 0.
291   // It will throw if the address is still authorised in the whitelist contract.
292   function revoke (address addr) public onlyAdmins {
293     require (contractStage < 3);
294     require (whitelist[addr].authorized);
295     require (whitelistContract.checkMemberLevel(addr) == 0);
296     whitelist[addr].authorized = false;
297     if (whitelist[addr].balance > 0) {
298       uint amountToTransfer = whitelist[addr].balance;
299       whitelist[addr].balance = 0;
300       addr.transfer(amountToTransfer);
301       ContributorBalanceChanged(addr, 0);
302     }
303   }
304   
305   // This function is called by the owner to modify the contribution cap of a whitelisted address.
306   // If the current contribution balance exceeds the new cap, the excess balance is refunded.
307   function modifyIndividualCap (address addr, uint cap) public onlyAdmins {
308     require (contractStage < 3);
309     require (cap < contributionCaps.length || (cap >= contributionMin && cap <= contributionCaps[0]) );
310     _checkWhitelistContract(addr);
311     var c = whitelist[addr];
312     require (c.authorized);
313     uint amount = c.balance;
314     c.cap = cap;
315     uint capAmount = _checkCap(addr);
316     if (amount > capAmount) {
317       c.balance = capAmount;
318       addr.transfer(amount.sub(capAmount));
319       ContributorBalanceChanged(addr, capAmount);
320     }
321   }
322   
323   // This function is called by the owner to modify the cap for a contribution level.
324   // The cap can only be increased, not decreased, and cannot exceed the contract limit.
325   function modifyLevelCap (uint level, uint cap) public onlyAdmins {
326     require (contractStage < 3);
327     require (level > 0 && level < contributionCaps.length);
328     require (contributionCaps[level] < cap && contributionCaps[0] >= cap);
329     contributionCaps[level] = cap;
330   }
331   
332   // This function can be called during stages one or two to modify the maximum balance of the contract.
333   // It can only be called by the owner. The amount cannot be set to lower than the current balance of the contract.
334   function modifyMaxContractBalance (uint amount) public onlyAdmins {
335     require (contractStage < 3);
336     require (amount >= contributionMin);
337     require (amount >= this.balance);
338     contributionCaps[0] = amount;
339     for (uint8 i=1; i<contributionCaps.length; i++) {
340       if (contributionCaps[i]>amount) contributionCaps[i]=amount;
341     }
342   }
343   
344   // This internal function returns the cap amount of a whitelisted address.
345   function _checkCap (address addr) internal returns (uint) {
346     _checkWhitelistContract(addr);
347     var c = whitelist[addr];
348     if (!c.authorized) return 0;
349     if (c.cap<contributionCaps.length) return contributionCaps[c.cap];
350     return c.cap; 
351   }
352   
353   // This internal function checks if an address is whitelisted in the whitelist contract.
354   function _checkWhitelistContract (address addr) internal {
355     var c = whitelist[addr];
356     if (!c.authorized) {
357       var level = whitelistContract.checkMemberLevel(addr);
358       if (level == 0 || level >= contributionCaps.length) return;
359       c.cap = level;
360       c.authorized = true;
361     }
362   }
363   
364   // This callable function returns the total pool cap, current balance and remaining balance to be filled.
365   function checkPoolBalance () view public returns (uint poolCap, uint balance, uint remaining) {
366     if (contractStage == 1) {
367       remaining = contributionCaps[0].sub(this.balance);
368     } else {
369       remaining = 0;
370     }
371     return (contributionCaps[0],this.balance,remaining);
372   }
373   
374   // This callable function returns the balance, contribution cap, and remaining available balance of any contributor.
375   function checkContributorBalance (address addr) view public returns (uint balance, uint cap, uint remaining) {
376     var c = whitelist[addr];
377     if (!c.authorized) {
378       cap = whitelistContract.checkMemberLevel(addr);
379       if (cap == 0) return (0,0,0);
380     } else {
381       cap = c.cap;
382     }
383     balance = c.balance;
384     if (contractStage == 1) {
385       if (cap<contributionCaps.length) {
386         cap = contributionCaps[cap];
387       }
388       remaining = cap.sub(balance);
389       if (contributionCaps[0].sub(this.balance) < remaining) remaining = contributionCaps[0].sub(this.balance);
390     } else {
391       remaining = 0;
392     }
393     return (balance, cap, remaining);
394   }
395   
396   // This callable function returns the token balance that a contributor can currently claim.
397   function checkAvailableTokens (address addr, address tokenAddr) view public returns (uint tokenAmount) {
398     var c = whitelist[addr];
399     var d = distribution[tokenAddr];
400     for (uint i=c.tokensClaimed[tokenAddr]; i<d.pct.length; i++) {
401       tokenAmount = tokenAmount.add(_applyPct(c.balance,d.pct[i]));
402     }
403     return tokenAmount;
404   }
405   
406   // This function closes further contributions to the contract, advancing it to stage two.
407   // It can only be called by the owner.  After this call has been made, whitelisted addresses
408   // can still remove their eth from the contract but cannot contribute any more.
409   function closeContributions () public onlyAdmins {
410     require (contractStage == 1);
411     contractStage = 2;
412   }
413   
414   // This function reopens the contract to contributions and further whitelisting, returning it to stage one.
415   // It can only be called by the owner during stage two.
416   function reopenContributions () public onlyAdmins {
417     require (contractStage == 2);
418     contractStage = 1;
419   }
420   
421   // This function sends the pooled eth to the receiving address, calculates the % of unused eth to be returned,
422   // and advances the contract to stage three. It can only be called by the contract owner during stages one or two.
423   // The amount to send (given in wei) must be specified during the call. As this function can only be executed once,
424   // it is VERY IMPORTANT not to get the amount wrong.
425   function submitPool (address receiverAddr, uint amountInWei) public onlyAdmins noReentrancy {
426     require (contractStage < 3);
427     require (receiverAddr != 0x00);
428     require (contributionMin <= amountInWei && amountInWei <= this.balance);
429     finalBalance = this.balance;
430     require (receiverAddr.call.value(amountInWei).gas(msg.gas.sub(5000))());
431     ethRefundAmount.push(this.balance);
432     contractStage = 3;
433   }
434   
435   // This function opens the contract up for token withdrawals.
436   // It can only be called by the owner during stage 3.  The owner specifies the address of an ERC20 token
437   // contract that this contract has a balance in, and optionally a bool to prevent this token from being
438   // the default withdrawal (in the event of an airdrop, for example).
439   // The function can only be called if there is not currently a token distribution 
440   function enableTokenWithdrawals (address tokenAddr, bool notDefault) public onlyAdmins noReentrancy {
441     require (contractStage == 3);
442     if (notDefault) {
443       require (activeToken != 0x00);
444     } else {
445       activeToken = tokenAddr;
446     }
447     var d = distribution[tokenAddr];    
448     if (d.pct.length==0) d.token = ERC20(tokenAddr);
449     uint amount = d.token.balanceOf(this).sub(d.balanceRemaining);
450     require (amount > 0);
451     if (feePct > 0) {
452       require (d.token.transfer(owner,_applyPct(amount,feePct)));
453     }
454     amount = d.token.balanceOf(this).sub(d.balanceRemaining);
455     d.balanceRemaining = d.token.balanceOf(this);
456     d.pct.push(_toPct(amount,finalBalance));
457   }
458   
459   // This is a standard function required for ERC223 compatibility.
460   function tokenFallback (address from, uint value, bytes data) public {
461     ERC223Received (from, value);
462   }
463   
464 }