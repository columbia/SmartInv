1 pragma solidity ^0.4.19;
2 
3 // Wolf Crypto pooling contract for TE-Foods
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
70   
71   
72   // These variables are all initially set to 0 and will be set at some point during the contract
73   // epoch time that the next contribution caps become active
74   uint public nextCapTime;
75   // pending contribution caps
76   uint [] public nextContributionCaps;
77   // amount of eth (in wei) present in the contract when it was submitted
78   uint public finalBalance;
79   // array containing eth amounts to be refunded in stage 3
80   uint[] public ethRefundAmount;
81   // default token contract to be used for withdrawing tokens in stage 3
82   address public activeToken;
83   
84   // data structure for holding the contribution amount, cap, eth refund status, and token withdrawal status for each whitelisted address
85   struct Contributor {
86     bool authorized;
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
123   event PoolSubmitted (address receiver, uint amount);
124   event WithdrawalsOpen (address tokenAddr);
125   event TokensWithdrawn (address receiver, uint amount);
126   event EthRefundReceived (address sender, uint amount);
127   event EthRefunded (address receiver, uint amount);
128   event ERC223Received (address token, uint value);
129    
130   // These are internal functions used for calculating fees, eth and token allocations as %
131   // returns a value as a % accurate to 20 decimal points
132   function _toPct (uint numerator, uint denominator ) internal pure returns (uint) {
133     return numerator.mul(10 ** 20) / denominator;
134   }
135   
136   // returns % of any number, where % given was generated with toPct
137   function _applyPct (uint numerator, uint pct) internal pure returns (uint) {
138     return numerator.mul(pct) / (10 ** 20);
139   }
140   
141   // This function is called at the time of contract creation,
142   // it sets the initial variables and whitelists the contract owner.
143   function PresalePool(address receiverAddr, uint[] capAmounts, uint fee) public {
144     require (fee < 100);
145     require (capAmounts.length>1 && capAmounts.length<256);
146     for (uint8 i=1; i<capAmounts.length; i++) {
147       require (capAmounts[i] <= capAmounts[0]);
148     }
149     owner = msg.sender;
150     receiverAddress = receiverAddr;
151     contributionCaps = capAmounts;
152     feePct = _toPct(fee,100);
153     whitelist[msg.sender].authorized = true;
154   }
155   
156   // This function is called whenever eth is sent into the contract.
157   // The send will fail unless the contract is in stage one and the sender has been whitelisted.
158   // The amount sent is added to the balance in the Contributor struct associated with the sending address.
159   function () payable public {
160     if (contractStage == 1) {
161       _ethDeposit();
162     } else if (contractStage == 3) {
163       _ethRefund();
164     } else revert();
165   }
166   
167   // Internal function for handling eth deposits during contract stage one.
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
180   // Internal function for handling eth refunds during stage three.
181   function _ethRefund () internal {
182     assert (contractStage == 3);
183     require (msg.sender == owner || msg.sender == receiverAddress);
184     require (msg.value >= contributionMin);
185     ethRefundAmount.push(msg.value);
186     EthRefundReceived(msg.sender, msg.value);
187   }
188   
189   // This function is called to withdraw eth or tokens from the contract.
190   // It can only be called by addresses that are whitelisted and show a balance greater than 0.
191   // If called during stages one or two, the full eth balance deposited into the contract is returned and the contributor's balance reset to 0.
192   // If called during stage three, the contributor's unused eth will be returned, as well as any available tokens.
193   // The token address may be provided optionally to withdraw tokens that are not currently the default token (airdrops).
194   function withdraw (address tokenAddr) public {
195     var c = whitelist[msg.sender];
196     require (c.balance > 0);
197     if (contractStage < 3) {
198       uint amountToTransfer = c.balance;
199       c.balance = 0;
200       msg.sender.transfer(amountToTransfer);
201       ContributorBalanceChanged(msg.sender, 0);
202     } else {
203       _withdraw(msg.sender,tokenAddr);
204     }  
205   }
206   
207   // This function allows the contract owner to force a withdrawal to any contributor.
208   function withdrawFor (address contributor, address tokenAddr) public onlyOwner {
209     require (contractStage == 3);
210     require (whitelist[contributor].balance > 0);
211     _withdraw(contributor,tokenAddr);
212   }
213   
214   // This internal function handles withdrawals during stage three.
215   // The associated events will fire to notify when a refund or token allocation is claimed.
216   function _withdraw (address receiver, address tokenAddr) internal {
217     assert (contractStage == 3);
218     var c = whitelist[receiver];
219     if (tokenAddr == 0x00) {
220       tokenAddr = activeToken;
221     }
222     var d = distributionMap[tokenAddr];
223     require ( (ethRefundAmount.length > c.ethRefund) || d.pct.length > c.tokensClaimed[tokenAddr] );
224     if (ethRefundAmount.length > c.ethRefund) {
225       uint pct = _toPct(c.balance,finalBalance);
226       uint ethAmount = 0;
227       for (uint i=c.ethRefund; i<ethRefundAmount.length; i++) {
228         ethAmount = ethAmount.add(_applyPct(ethRefundAmount[i],pct));
229       }
230       c.ethRefund = ethRefundAmount.length;
231       if (ethAmount > 0) {
232         receiver.transfer(ethAmount);
233         EthRefunded(receiver,ethAmount);
234       }
235     }
236     if (d.pct.length > c.tokensClaimed[tokenAddr]) {
237       uint tokenAmount = 0;
238       for (i=c.tokensClaimed[tokenAddr]; i<d.pct.length; i++) {
239         tokenAmount = tokenAmount.add(_applyPct(c.balance,d.pct[i]));
240       }
241       c.tokensClaimed[tokenAddr] = d.pct.length;
242       if (tokenAmount > 0) {
243         require(d.token.transfer(receiver,tokenAmount));
244         d.balanceRemaining = d.balanceRemaining.sub(tokenAmount);
245         TokensWithdrawn(receiver,tokenAmount);
246       }  
247     }
248     
249   }
250   
251   // This function can only be executed by the owner, it adds an address to the whitelist.
252   // To execute, the contract must be in stage 1, the address cannot already be whitelisted, and the address cannot be a contract itself.
253   // Blocking contracts from being whitelisted prevents attacks from unexpected contract to contract interaction - very important!
254   function authorize (address addr, uint cap) public onlyOwner {
255     require (contractStage == 1);
256     _checkWhitelistContract(addr);
257     require (!whitelist[addr].authorized);
258     require ((cap > 0 && cap < contributionCaps.length) || (cap >= contributionMin && cap <= contributionCaps[0]) );
259     uint size;
260     assembly { size := extcodesize(addr) }
261     require (size == 0);
262     whitelist[addr].cap = cap;
263     whitelist[addr].authorized = true;
264   }
265   
266   // This function is used by the owner to authorize many addresses in a single call.
267   // Each address will be given the same cap, and the cap must be one of the standard levels.
268   function authorizeMany (address[] addr, uint cap) public onlyOwner {
269     require (addr.length < 255);
270     require (cap > 0 && cap < contributionCaps.length);
271     for (uint8 i=0; i<addr.length; i++) {
272       authorize(addr[i], cap);
273     }
274   }
275   
276   // This function is called by the owner to remove an address from the whitelist.
277   // It may only be executed during stages 1 and 2.  Any eth sent by the address is refunded and their personal cap is set to 0.
278   // It will throw if the address is still authorised in the whitelist contract.
279   function revoke (address addr) public onlyOwner {
280     require (contractStage < 3);
281     require (whitelist[addr].authorized);
282     require (whitelistContract.checkMemberLevel(addr) == 0);
283     whitelist[addr].authorized = false;
284     if (whitelist[addr].balance > 0) {
285       uint amountToTransfer = whitelist[addr].balance;
286       whitelist[addr].balance = 0;
287       addr.transfer(amountToTransfer);
288       ContributorBalanceChanged(addr, 0);
289     }
290   }
291   
292   // This function is called by the owner to modify the contribution cap of a whitelisted address.
293   // If the current contribution balance exceeds the new cap, the excess balance is refunded.
294   function modifyIndividualCap (address addr, uint cap) public onlyOwner {
295     require (contractStage < 3);
296     require (cap < contributionCaps.length || (cap >= contributionMin && cap <= contributionCaps[0]) );
297     _checkWhitelistContract(addr);
298     var c = whitelist[addr];
299     require (c.authorized);
300     uint amount = c.balance;
301     c.cap = cap;
302     uint capAmount = _checkCap(addr);
303     if (amount > capAmount) {
304       c.balance = capAmount;
305       addr.transfer(amount.sub(capAmount));
306       ContributorBalanceChanged(addr, capAmount);
307     }
308   }
309   
310   // This function is called by the owner to modify the cap for a contribution level.
311   // The cap cannot be decreased below the current balance or increased past the contract limit.
312   function modifyLevelCap (uint level, uint cap) public onlyOwner {
313     require (contractStage < 3);
314     require (level > 0 && level < contributionCaps.length);
315     require (this.balance <= cap && contributionCaps[0] >= cap);
316     contributionCaps[level] = cap;
317     nextCapTime = 0;
318   }
319   
320   // This function changes every level cap at once, with an optional delay.
321   // Modifying the caps immediately will cancel any delayed cap change.
322   function modifyAllLevelCaps (uint[] cap, uint time) public onlyOwner {
323     require (contractStage < 3);
324     require (cap.length == contributionCaps.length-1);
325     require (time == 0 || time>block.timestamp);
326     if (time == 0) {
327       for (uint8 i = 0; i < cap.length; i++) {
328         modifyLevelCap(i+1, cap[i]);
329       }
330     } else {
331       nextContributionCaps = contributionCaps;
332       nextCapTime = time;
333       for (i = 0; i < cap.length; i++) {
334         require (contributionCaps[i+1] <= cap[i] && contributionCaps[0] >= cap[i]);
335         nextContributionCaps[i+1] = cap[i];
336       }
337     }
338   }
339   
340   // This function can be called during stages one or two to modify the maximum balance of the contract.
341   // It can only be called by the owner. The amount cannot be set to lower than the current balance of the contract.
342   function modifyMaxContractBalance (uint amount) public onlyOwner {
343     require (contractStage < 3);
344     require (amount >= contributionMin);
345     require (amount >= this.balance);
346     contributionCaps[0] = amount;
347     nextCapTime = 0;
348     for (uint8 i=1; i<contributionCaps.length; i++) {
349       if (contributionCaps[i]>amount) contributionCaps[i]=amount;
350     }
351   }
352   
353   // This internal function returns the cap amount of a whitelisted address.
354   function _checkCap (address addr) internal returns (uint) {
355     _checkWhitelistContract(addr);
356     var c = whitelist[addr];
357     if (!c.authorized) return 0;
358     if (nextCapTime>0 && block.timestamp>nextCapTime) {
359       contributionCaps = nextContributionCaps;
360       nextCapTime = 0;
361     }
362     if (c.cap<contributionCaps.length) return contributionCaps[c.cap];
363     return c.cap; 
364   }
365   
366   // This internal function checks if an address is whitelisted in the whitelist contract.
367   function _checkWhitelistContract (address addr) internal {
368     var c = whitelist[addr];
369     if (!c.authorized) {
370       var level = whitelistContract.checkMemberLevel(addr);
371       if (level == 0 || level >= contributionCaps.length) return;
372       c.cap = level;
373       c.authorized = true;
374     }
375   }
376   
377   // This callable function returns the total pool cap, current balance and remaining balance to be filled.
378   function checkPoolBalance () view public returns (uint poolCap, uint balance, uint remaining) {
379     if (contractStage == 1) {
380       remaining = contributionCaps[0].sub(this.balance);
381     } else {
382       remaining = 0;
383     }
384     return (contributionCaps[0],this.balance,remaining);
385   }
386   
387   // This callable function returns the balance, contribution cap, and remaining available balance of any contributor.
388   function checkContributorBalance (address addr) view public returns (uint balance, uint cap, uint remaining) {
389     var c = whitelist[addr];
390     if (!c.authorized) {
391       cap = whitelistContract.checkMemberLevel(addr);
392       if (cap == 0) return (0,0,0);
393     } else {
394       cap = c.cap;
395     }
396     balance = c.balance;
397     if (contractStage == 1) {
398       if (cap<contributionCaps.length) { 
399         if (nextCapTime == 0 || nextCapTime > block.timestamp) {
400           cap = contributionCaps[cap];
401         } else {
402           cap = nextContributionCaps[cap];
403         }
404       }
405       remaining = cap.sub(balance);
406       if (contributionCaps[0].sub(this.balance) < remaining) remaining = contributionCaps[0].sub(this.balance);
407     } else {
408       remaining = 0;
409     }
410     return (balance, cap, remaining);
411   }
412   
413   // This callable function returns the token balance that a contributor can currently claim.
414   function checkAvailableTokens (address addr, address tokenAddr) view public returns (uint tokenAmount) {
415     var c = whitelist[addr];
416     var d = distributionMap[tokenAddr];
417     for (uint i = c.tokensClaimed[tokenAddr]; i < d.pct.length; i++) {
418       tokenAmount = tokenAmount.add(_applyPct(c.balance, d.pct[i]));
419     }
420     return tokenAmount;
421   }
422   
423   // This function closes further contributions to the contract, advancing it to stage two.
424   // It can only be called by the owner.  After this call has been made, whitelisted addresses
425   // can still remove their eth from the contract but cannot contribute any more.
426   function closeContributions () public onlyOwner {
427     require (contractStage == 1);
428     contractStage = 2;
429   }
430   
431   // This function reopens the contract to contributions and further whitelisting, returning it to stage one.
432   // It can only be called by the owner during stage two.
433   function reopenContributions () public onlyOwner {
434     require (contractStage == 2);
435     contractStage = 1;
436   }
437 
438   // This function sends the pooled eth to the receiving address, calculates the % of unused eth to be returned,
439   // and advances the contract to stage three. It can only be called by the contract owner during stages one or two.
440   // The amount to send (given in wei) must be specified during the call. As this function can only be executed once,
441   // it is VERY IMPORTANT not to get the amount wrong.
442   function submitPool (uint amountInWei) public onlyOwner noReentrancy {
443     require (contractStage < 3);
444     require (contributionMin <= amountInWei && amountInWei <= this.balance);
445     finalBalance = this.balance;
446     require (receiverAddress.call.value(amountInWei).gas(msg.gas.sub(5000))());
447     ethRefundAmount.push(this.balance);
448     contractStage = 3;
449     PoolSubmitted(receiverAddress, amountInWei);
450   }
451   
452   // This function opens the contract up for token withdrawals.
453   // It can only be called by the owner during stage 3.  The owner specifies the address of an ERC20 token
454   // contract that this contract has a balance in, and optionally a bool to prevent this token from being
455   // the default withdrawal (in the event of an airdrop, for example).
456   function enableTokenWithdrawals (address tokenAddr, bool notDefault) public onlyOwner noReentrancy {
457     require (contractStage == 3);
458     if (notDefault) {
459       require (activeToken != 0x00);
460     } else {
461       activeToken = tokenAddr;
462     }
463     var d = distributionMap[tokenAddr];    
464     if (d.pct.length==0) d.token = ERC20(tokenAddr);
465     uint amount = d.token.balanceOf(this).sub(d.balanceRemaining);
466     require (amount > 0);
467     if (feePct > 0) {
468       require (d.token.transfer(owner,_applyPct(amount,feePct)));
469     }
470     amount = d.token.balanceOf(this).sub(d.balanceRemaining);
471     d.balanceRemaining = d.token.balanceOf(this);
472     d.pct.push(_toPct(amount,finalBalance));
473   }
474   
475   // This is a standard function required for ERC223 compatibility.
476   function tokenFallback (address from, uint value, bytes data) public {
477     ERC223Received (from, value);
478   }
479   
480 }