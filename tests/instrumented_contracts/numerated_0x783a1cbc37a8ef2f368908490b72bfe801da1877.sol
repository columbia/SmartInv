1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 contract ERC20 {
38   function balanceOf(address _owner) constant returns (uint256 balance) {}
39   function transfer(address _to, uint256 _value) returns (bool success) {}
40 }
41 
42 
43 contract WhiteList {
44    function checkMemberLevel (address addr) view public returns (uint) {}
45 }
46 
47 
48 contract PresalePool {
49 
50   // SafeMath is a library to ensure that math operations do not have overflow errors
51   // https://zeppelin-solidity.readthedocs.io/en/latest/safemath.html
52   using SafeMath for uint;
53   
54   // The contract has 3 stages:
55   // 1 - The initial state. The owner is able to add addresses to the whitelist, and any whitelisted addresses can deposit or withdraw eth to the contract.
56   // 2 - The owner has closed the contract for further deposits. Whitelisted addresses can still withdraw eth from the contract.
57   // 3 - The eth is sent from the contract to the receiver. Unused eth can be claimed by contributors immediately. Once tokens are sent to the contract,
58   //     the owner enables withdrawals and contributors can withdraw their tokens.
59   uint8 public contractStage = 1;
60   
61   // These variables are set at the time of contract creation
62   // the address that creates the contract
63   address public owner;
64   // the minimum eth amount (in wei) that can be sent by a whitelisted address
65   uint public contributionMin;
66   // the maximum eth amount (in wei) that can be sent by a whitelisted address
67   uint[] public contributionCaps;
68   // the % of tokens kept by the contract owner
69   uint public feePct;
70   // the address that the pool will be paid out to
71   address public receiverAddress;
72   
73   uint constant public maxGasPrice = 50000000000;
74   WhiteList public whitelistContract;
75   
76   // These variables are all initially set to 0 and will be set at some point during the contract
77   // the amount of eth (in wei) present in the contract when it was submitted
78   uint public finalBalance;
79   // the % of contributed eth to be refunded to whitelisted addresses (set in stage 3)
80   uint[] public ethRefundAmount;
81   // the default token contract to be used for withdrawing tokens in stage 3
82   address public activeToken;
83   
84   // a data structure for holding the contribution amount, cap, eth refund status, and token withdrawal status for each whitelisted address
85   struct Contributor {
86     bool authorized;
87     uint ethRefund;
88     uint balance;
89     uint cap;
90     mapping (address => uint) tokensClaimed;
91   }
92   // a mapping that holds the contributor struct for each whitelisted address
93   mapping (address => Contributor) whitelist;
94   
95   // a data structure for holding information related to token withdrawals.
96   struct TokenAllocation {
97     ERC20 token;
98     uint[] pct;
99     uint balanceRemaining;
100   }
101   // a mapping that holds the token allocation struct for each token address
102   mapping (address => TokenAllocation) distribution;
103   
104   
105   // this modifier is used for functions that can only be accessed by the contract creator
106   modifier onlyOwner () {
107     require (msg.sender == owner);
108     _;
109   }
110   
111   // this modifier is used to prevent re-entrancy exploits during contract > contract interaction
112   bool locked;
113   modifier noReentrancy() {
114     require(!locked);
115     locked = true;
116     _;
117     locked = false;
118   }
119   
120   event ContributorBalanceChanged (address contributor, uint totalBalance);
121   event TokensWithdrawn (address receiver, uint amount);
122   event EthRefunded (address receiver, uint amount);
123   event WithdrawalsOpen (address tokenAddr);
124   event ERC223Received (address token, uint value);
125   event EthRefundReceived (address sender, uint amount);
126    
127   // These are internal functions used for calculating fees, eth and token allocations as %
128   // returns a value as a % accurate to 20 decimal points
129   function _toPct (uint numerator, uint denominator ) internal pure returns (uint) {
130     return numerator.mul(10 ** 20) / denominator;
131   }
132   
133   // returns % of any number, where % given was generated with toPct
134   function _applyPct (uint numerator, uint pct) internal pure returns (uint) {
135     return numerator.mul(pct) / (10 ** 20);
136   }
137   
138   // This function is called at the time of contract creation,
139   // it sets the initial variables and whitelists the contract owner.
140   function PresalePool(address receiverAddr, address whitelistAddr, uint individualMin, uint[] capAmounts, uint fee) public {
141     require (receiverAddr != 0x00);
142     require (fee < 100);
143     require (100000000000000000 <= individualMin);
144     require (capAmounts.length>1 && capAmounts.length<256);
145     for (uint8 i=1; i<capAmounts.length; i++) {
146       require (capAmounts[i] <= capAmounts[0]);
147     }
148     owner = msg.sender;
149     receiverAddress = receiverAddr;
150     contributionMin = individualMin;
151     contributionCaps = capAmounts;
152     feePct = _toPct(fee,100);
153     whitelistContract = WhiteList(whitelistAddr);
154     whitelist[msg.sender].authorized = true;
155   }
156   
157   // This function is called whenever eth is sent into the contract.
158   // The send will fail unless the contract is in stage one and the sender has been whitelisted.
159   // The amount sent is added to the balance in the Contributor struct associated with the sending address.
160   function () payable public {
161     if (contractStage == 1) {
162       _ethDeposit();
163     } else if (contractStage == 3) {
164       _ethRefund();
165     } else revert();
166   }
167   
168   function _ethDeposit () internal {
169     assert (contractStage == 1);
170     require (tx.gasprice <= maxGasPrice);
171     require (this.balance <= contributionCaps[0]);
172     var c = whitelist[msg.sender];
173     uint newBalance = c.balance.add(msg.value);
174     require (newBalance >= contributionMin);
175     require (newBalance <= _checkCap(msg.sender));
176     c.balance = newBalance;
177     ContributorBalanceChanged(msg.sender, newBalance);
178   }
179   
180   
181   function _ethRefund () internal {
182     assert (contractStage == 3);
183     require (msg.sender == owner || msg.sender == receiverAddress);
184     require (msg.value >= contributionMin);
185     ethRefundAmount.push(msg.value);
186     EthRefundReceived(msg.sender, msg.value);
187   }
188   
189     
190   // This function is called to withdraw eth or tokens from the contract.
191   // It can only be called by addresses that are whitelisted and show a balance greater than 0.
192   // If called during contract stages one or two, the full eth balance deposited into the contract will be returned and the contributor's balance will be reset to 0.
193   // If called during stage three, the contributor's unused eth will be returned, as well as any available tokens.
194   // The token address may be provided optionally to withdraw tokens that are not currently the default token (airdrops).
195   function withdraw (address tokenAddr) public {
196     var c = whitelist[msg.sender];
197     require (c.balance > 0);
198     if (contractStage < 3) {
199       uint amountToTransfer = c.balance;
200       c.balance = 0;
201       msg.sender.transfer(amountToTransfer);
202       ContributorBalanceChanged(msg.sender, 0);
203     } else {
204       _withdraw(msg.sender,tokenAddr);
205     }  
206   }
207   
208   // This function allows the contract owner to force a withdrawal to any contributor.
209   // It is useful if a new round of tokens can be distributed but some contributors have
210   // not yet withdrawn their previous allocation.
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
225     var d = distribution[tokenAddr];
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
248         TokensWithdrawn(receiver,tokenAmount);
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
281   function revoke (address addr) public onlyOwner {
282     require (contractStage < 3);
283     require (whitelist[addr].authorized);
284     require (whitelistContract.checkMemberLevel(addr) == 0);
285     whitelist[addr].authorized = false;
286     if (whitelist[addr].balance > 0) {
287       uint amountToTransfer = whitelist[addr].balance;
288       whitelist[addr].balance = 0;
289       addr.transfer(amountToTransfer);
290       ContributorBalanceChanged(addr, 0);
291     }
292   }
293   
294   // This function is called by the owner to modify the contribution cap of a whitelisted address.
295   // If the current contribution balance exceeds the new cap, the excess balance is refunded.
296   function modifyIndividualCap (address addr, uint cap) public onlyOwner {
297     require (contractStage < 3);
298     require (cap < contributionCaps.length || (cap >= contributionMin && cap <= contributionCaps[0]) );
299     _checkWhitelistContract(addr);
300     var c = whitelist[addr];
301     require (c.authorized);
302     uint amount = c.balance;
303     c.cap = cap;
304     uint capAmount = _checkCap(addr);
305     if (amount > capAmount) {
306       c.balance = capAmount;
307       addr.transfer(amount.sub(capAmount));
308       ContributorBalanceChanged(addr, capAmount);
309     }
310   }
311   
312   // This function is called by the owner to modify the cap for a contribution level.
313   // The cap can only be increased, not decreased, and cannot exceed the contract limit.
314   function modifyLevelCap (uint level, uint cap) public onlyOwner {
315     require (contractStage < 3);
316     require (level > 0 && level < contributionCaps.length);
317     require (contributionCaps[level] < cap && contributionCaps[0] >= cap);
318     contributionCaps[level] = cap;
319   }
320   
321   // This function can be called during stages one or two to modify the maximum balance of the contract.
322   // It can only be called by the owner. The amount cannot be set to lower than the current balance of the contract.
323   function modifyMaxContractBalance (uint amount) public onlyOwner {
324     require (contractStage < 3);
325     require (amount >= contributionMin);
326     require (amount >= this.balance);
327     contributionCaps[0] = amount;
328     for (uint8 i=1; i<contributionCaps.length; i++) {
329       if (contributionCaps[i]>amount) contributionCaps[i]=amount;
330     }
331   }
332   
333   // This internal function returns the cap amount of a whitelisted address.
334   // If the address is not whitelisted it will throw.
335   function _checkCap (address addr) internal returns (uint) {
336     _checkWhitelistContract(addr);
337     var c = whitelist[addr];
338     if (!c.authorized) return 0;
339     if (c.cap<contributionCaps.length) return contributionCaps[c.cap];
340     return c.cap; 
341   }
342   
343   function _checkWhitelistContract (address addr) internal {
344     var c = whitelist[addr];
345     if (!c.authorized) {
346       var level = whitelistContract.checkMemberLevel(addr);
347       if (level == 0 || level >= contributionCaps.length) return;
348       c.cap = level;
349       c.authorized = true;
350     }
351   }
352   
353   // This callable function returns the total pool cap, current balance and remaining balance to be filled.
354   function checkPoolBalance () view public returns (uint poolCap, uint balance, uint remaining) {
355     if (contractStage == 1) {
356       remaining = contributionCaps[0].sub(this.balance);
357     } else {
358       remaining = 0;
359     }
360     return (contributionCaps[0],this.balance,remaining);
361   }
362   
363   // This callable function returns the balance, contribution cap, and remaining available balance of any contributor.
364   function checkContributorBalance (address addr) view public returns (uint balance, uint cap, uint remaining) {
365     var c = whitelist[addr];
366     if (!c.authorized) {
367       cap = whitelistContract.checkMemberLevel(addr);
368       if (cap == 0) return (0,0,0);
369     } else {
370       cap = c.cap;
371     }
372     balance = c.balance;
373     if (contractStage == 1) {
374       if (cap<contributionCaps.length) {
375         cap = contributionCaps[cap];
376       }
377       remaining = cap.sub(balance);
378       if (contributionCaps[0].sub(this.balance) < remaining) remaining = contributionCaps[0].sub(this.balance);
379     } else {
380       remaining = 0;
381     }
382     return (balance, cap, remaining);
383   }
384   
385   // This callable function returns the token balance that a contributor can currently claim.
386   function checkAvailableTokens (address addr, address tokenAddr) view public returns (uint tokenAmount) {
387     var c = whitelist[addr];
388     var d = distribution[tokenAddr];
389     for (uint i=c.tokensClaimed[tokenAddr]; i<d.pct.length; i++) {
390       tokenAmount = tokenAmount.add(_applyPct(c.balance,d.pct[i]));
391     }
392     return tokenAmount;
393   }
394   
395   // This function closes further contributions to the contract, advancing it to stage two.
396   // It can only be called by the owner.  After this call has been made, whitelisted addresses
397   // can still remove their eth from the contract but cannot contribute any more.
398   function closeContributions () public onlyOwner {
399     require (contractStage == 1);
400     contractStage = 2;
401   }
402   
403   // This function reopens the contract to contributions and further whitelisting, returning it to stage one.
404   // It can only be called by the owner during stage two.
405   function reopenContributions () public onlyOwner {
406     require (contractStage == 2);
407     contractStage = 1;
408   }
409   
410 
411   // This function sends the pooled eth to the receiving address, calculates the % of unused eth to be returned,
412   // and advances the contract to stage three. It can only be called by the contract owner during stage two.
413   // The amount to send (given in wei) must be specified during the call. As this function can only be executed once,
414   // it is VERY IMPORTANT not to get the amount wrong.
415   function submitPool (uint amountInWei) public onlyOwner noReentrancy {
416     require (contractStage < 3);
417     require (contributionMin <= amountInWei && amountInWei <= this.balance);
418     finalBalance = this.balance;
419     require (receiverAddress.call.value(amountInWei).gas(msg.gas.sub(5000))());
420     ethRefundAmount.push(this.balance);
421     contractStage = 3;
422   }
423   
424   // This function opens the contract up for token withdrawals.
425   // It can only be called by the owner during stage 3.  The owner specifies the address of an ERC20 token
426   // contract that this contract has a balance in, and optionally a bool to prevent this token from being
427   // the default withdrawal (in the event of an airdrop, for example).
428   // The function can only be called if there is not currently a token distribution 
429   function enableTokenWithdrawals (address tokenAddr, bool notDefault) public onlyOwner noReentrancy {
430     require (contractStage == 3);
431     if (notDefault) {
432       require (activeToken != 0x00);
433     } else {
434       activeToken = tokenAddr;
435     }
436     var d = distribution[tokenAddr];    
437     if (d.pct.length==0) d.token = ERC20(tokenAddr);
438     uint amount = d.token.balanceOf(this).sub(d.balanceRemaining);
439     require (amount > 0);
440     if (feePct > 0) {
441       require (d.token.transfer(owner,_applyPct(amount,feePct)));
442     }
443     amount = d.token.balanceOf(this).sub(d.balanceRemaining);
444     d.balanceRemaining = d.token.balanceOf(this);
445     d.pct.push(_toPct(amount,finalBalance));
446   }
447   
448   // This is a standard function required for ERC223 compatibility.
449   function tokenFallback (address from, uint value, bytes data) public {
450     ERC223Received (from, value);
451   }
452   
453 }