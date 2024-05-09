1 pragma solidity ^0.4.19;
2 
3 // Wolf Crypto pooling contract for Havven
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
54   // the address that creates the contract
55   address public owner;
56   // the minimum eth amount (in wei) that can be sent by a whitelisted address
57   uint constant public contributionMin = 100000000000000000;
58   // the maximum eth amount (in wei) that can be sent by a whitelisted address
59   uint[] public contributionCaps;
60   // the % of tokens kept by the contract owner
61   uint public feePct;
62   // the address that the pool will be paid out to
63   address public receiverAddress;
64   // the maximum gas price allowed for deposits in stage 1
65   uint constant public maxGasPrice = 50000000000;
66   // the whitelisting contract
67   WhiteList constant public whitelistContract = WhiteList(0x8D95B038cA80A986425FA240C3C17Fb2B6e9bc63);
68   
69   // These variables are all initially set to 0 and will be set at some point during the contract
70   // the amount of eth (in wei) present in the contract when it was submitted
71   uint public finalBalance;
72   // an array containing eth amounts to be refunded in stage 3
73   uint[] public ethRefundAmount;
74   // the default token contract to be used for withdrawing tokens in stage 3
75   address public activeToken;
76   
77   // a data structure for holding the contribution amount, cap, eth refund status, and token withdrawal status for each whitelisted address
78   struct Contributor {
79     bool authorized;
80     uint ethRefund;
81     uint balance;
82     uint cap;
83     mapping (address => uint) tokensClaimed;
84   }
85   // a mapping that holds the contributor struct for each whitelisted address
86   mapping (address => Contributor) whitelist;
87   
88   // a data structure for holding information related to token withdrawals.
89   struct TokenAllocation {
90     ERC20 token;
91     uint[] pct;
92     uint balanceRemaining;
93   }
94   // a mapping that holds the token allocation struct for each token address
95   mapping (address => TokenAllocation) distributionMap;
96   
97   
98   // this modifier is used for functions that can only be accessed by the contract creator
99   modifier onlyOwner () {
100     require (msg.sender == owner);
101     _;
102   }
103   
104   // this modifier is used to prevent re-entrancy exploits during contract > contract interaction
105   bool locked;
106   modifier noReentrancy() {
107     require(!locked);
108     locked = true;
109     _;
110     locked = false;
111   }
112   
113   // Events triggered throughout contract execution
114   // These can be watched via geth filters to keep up-to-date with the contract
115   event ContributorBalanceChanged (address contributor, uint totalBalance);
116   event PoolSubmitted (address receiver, uint amount);
117   event WithdrawalsOpen (address tokenAddr);
118   event TokensWithdrawn (address receiver, uint amount);
119   event EthRefundReceived (address sender, uint amount);
120   event EthRefunded (address receiver, uint amount);
121   event ERC223Received (address token, uint value);
122    
123   // These are internal functions used for calculating fees, eth and token allocations as %
124   // returns a value as a % accurate to 20 decimal points
125   function _toPct (uint numerator, uint denominator ) internal pure returns (uint) {
126     return numerator.mul(10 ** 20) / denominator;
127   }
128   
129   // returns % of any number, where % given was generated with toPct
130   function _applyPct (uint numerator, uint pct) internal pure returns (uint) {
131     return numerator.mul(pct) / (10 ** 20);
132   }
133   
134   // This function is called at the time of contract creation,
135   // it sets the initial variables and whitelists the contract owner.
136   function PresalePool(address receiverAddr, uint[] capAmounts, uint fee) public {
137     require (fee < 100);
138     require (capAmounts.length>1 && capAmounts.length<256);
139     for (uint8 i=1; i<capAmounts.length; i++) {
140       require (capAmounts[i] <= capAmounts[0]);
141     }
142     owner = msg.sender;
143     receiverAddress = receiverAddr;
144     contributionCaps = capAmounts;
145     feePct = _toPct(fee,100);
146     whitelist[msg.sender].authorized = true;
147   }
148   
149   // This function is called whenever eth is sent into the contract.
150   // The send will fail unless the contract is in stage one and the sender has been whitelisted.
151   // The amount sent is added to the balance in the Contributor struct associated with the sending address.
152   function () payable public {
153     if (contractStage == 1) {
154       _ethDeposit();
155     } else if (contractStage == 3) {
156       _ethRefund();
157     } else revert();
158   }
159   
160   // Internal function for handling eth deposits during contract stage one.
161   function _ethDeposit () internal {
162     assert (contractStage == 1);
163     require (tx.gasprice <= maxGasPrice);
164     require (this.balance <= contributionCaps[0]);
165     var c = whitelist[msg.sender];
166     uint newBalance = c.balance.add(msg.value);
167     require (newBalance >= contributionMin);
168     require (newBalance <= _checkCap(msg.sender));
169     c.balance = newBalance;
170     ContributorBalanceChanged(msg.sender, newBalance);
171   }
172   
173   // Internal function for handling eth refunds during stage three.
174   function _ethRefund () internal {
175     assert (contractStage == 3);
176     require (msg.sender == owner || msg.sender == receiverAddress);
177     require (msg.value >= contributionMin);
178     ethRefundAmount.push(msg.value);
179     EthRefundReceived(msg.sender, msg.value);
180   }
181   
182   // This function is called to withdraw eth or tokens from the contract.
183   // It can only be called by addresses that are whitelisted and show a balance greater than 0.
184   // If called during stages one or two, the full eth balance deposited into the contract is returned and the contributor's balance reset to 0.
185   // If called during stage three, the contributor's unused eth will be returned, as well as any available tokens.
186   // The token address may be provided optionally to withdraw tokens that are not currently the default token (airdrops).
187   function withdraw (address tokenAddr) public {
188     var c = whitelist[msg.sender];
189     require (c.balance > 0);
190     if (contractStage < 3) {
191       uint amountToTransfer = c.balance;
192       c.balance = 0;
193       msg.sender.transfer(amountToTransfer);
194       ContributorBalanceChanged(msg.sender, 0);
195     } else {
196       _withdraw(msg.sender,tokenAddr);
197     }  
198   }
199   
200   // This function allows the contract owner to force a withdrawal to any contributor.
201   function withdrawFor (address contributor, address tokenAddr) public onlyOwner {
202     require (contractStage == 3);
203     require (whitelist[contributor].balance > 0);
204     _withdraw(contributor,tokenAddr);
205   }
206   
207   // This internal function handles withdrawals during stage three.
208   // The associated events will fire to notify when a refund or token allocation is claimed.
209   function _withdraw (address receiver, address tokenAddr) internal {
210     assert (contractStage == 3);
211     var c = whitelist[receiver];
212     if (tokenAddr == 0x00) {
213       tokenAddr = activeToken;
214     }
215     var d = distributionMap[tokenAddr];
216     require ( (ethRefundAmount.length > c.ethRefund) || d.pct.length > c.tokensClaimed[tokenAddr] );
217     if (ethRefundAmount.length > c.ethRefund) {
218       uint pct = _toPct(c.balance,finalBalance);
219       uint ethAmount = 0;
220       for (uint i=c.ethRefund; i<ethRefundAmount.length; i++) {
221         ethAmount = ethAmount.add(_applyPct(ethRefundAmount[i],pct));
222       }
223       c.ethRefund = ethRefundAmount.length;
224       if (ethAmount > 0) {
225         receiver.transfer(ethAmount);
226         EthRefunded(receiver,ethAmount);
227       }
228     }
229     if (d.pct.length > c.tokensClaimed[tokenAddr]) {
230       uint tokenAmount = 0;
231       for (i=c.tokensClaimed[tokenAddr]; i<d.pct.length; i++) {
232         tokenAmount = tokenAmount.add(_applyPct(c.balance,d.pct[i]));
233       }
234       c.tokensClaimed[tokenAddr] = d.pct.length;
235       if (tokenAmount > 0) {
236         require(d.token.transfer(receiver,tokenAmount));
237         d.balanceRemaining = d.balanceRemaining.sub(tokenAmount);
238         TokensWithdrawn(receiver,tokenAmount);
239       }  
240     }
241     
242   }
243   
244   // This function can only be executed by the owner, it adds an address to the whitelist.
245   // To execute, the contract must be in stage 1, the address cannot already be whitelisted, and the address cannot be a contract itself.
246   // Blocking contracts from being whitelisted prevents attacks from unexpected contract to contract interaction - very important!
247   function authorize (address addr, uint cap) public onlyOwner {
248     require (contractStage == 1);
249     _checkWhitelistContract(addr);
250     require (!whitelist[addr].authorized);
251     require ((cap > 0 && cap < contributionCaps.length) || (cap >= contributionMin && cap <= contributionCaps[0]) );
252     uint size;
253     assembly { size := extcodesize(addr) }
254     require (size == 0);
255     whitelist[addr].cap = cap;
256     whitelist[addr].authorized = true;
257   }
258   
259   // This function is used by the owner to authorize many addresses in a single call.
260   // Each address will be given the same cap, and the cap must be one of the standard levels.
261   function authorizeMany (address[] addr, uint cap) public onlyOwner {
262     require (addr.length < 255);
263     require (cap > 0 && cap < contributionCaps.length);
264     for (uint8 i=0; i<addr.length; i++) {
265       authorize(addr[i], cap);
266     }
267   }
268   
269   // This function is called by the owner to remove an address from the whitelist.
270   // It may only be executed during stages 1 and 2.  Any eth sent by the address is refunded and their personal cap is set to 0.
271   // It will throw if the address is still authorised in the whitelist contract.
272   function revoke (address addr) public onlyOwner {
273     require (contractStage < 3);
274     require (whitelist[addr].authorized);
275     require (whitelistContract.checkMemberLevel(addr) == 0);
276     whitelist[addr].authorized = false;
277     if (whitelist[addr].balance > 0) {
278       uint amountToTransfer = whitelist[addr].balance;
279       whitelist[addr].balance = 0;
280       addr.transfer(amountToTransfer);
281       ContributorBalanceChanged(addr, 0);
282     }
283   }
284   
285   // This function is called by the owner to modify the contribution cap of a whitelisted address.
286   // If the current contribution balance exceeds the new cap, the excess balance is refunded.
287   function modifyIndividualCap (address addr, uint cap) public onlyOwner {
288     require (contractStage < 3);
289     require (cap < contributionCaps.length || (cap >= contributionMin && cap <= contributionCaps[0]) );
290     _checkWhitelistContract(addr);
291     var c = whitelist[addr];
292     require (c.authorized);
293     uint amount = c.balance;
294     c.cap = cap;
295     uint capAmount = _checkCap(addr);
296     if (amount > capAmount) {
297       c.balance = capAmount;
298       addr.transfer(amount.sub(capAmount));
299       ContributorBalanceChanged(addr, capAmount);
300     }
301   }
302   
303   // This function is called by the owner to modify the cap for a contribution level.
304   // The cap can only be increased, not decreased, and cannot exceed the contract limit.
305   function modifyLevelCap (uint level, uint cap) public onlyOwner {
306     require (contractStage < 3);
307     require (level > 0 && level < contributionCaps.length);
308     require (contributionCaps[level] < cap && contributionCaps[0] >= cap);
309     contributionCaps[level] = cap;
310   }
311   
312   // This function changes every level cap at once.
313   function modifyAllLevelCaps (uint[] cap) public onlyOwner {
314     require (contractStage < 3);
315     require (cap.length == contributionCaps.length-1);
316     for (uint8 i = 1; i < contributionCaps.length; i++) {
317       modifyLevelCap(i, cap[i-1]);
318     }
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
334   function _checkCap (address addr) internal returns (uint) {
335     _checkWhitelistContract(addr);
336     var c = whitelist[addr];
337     if (!c.authorized) return 0;
338     if (c.cap<contributionCaps.length) return contributionCaps[c.cap];
339     return c.cap; 
340   }
341   
342   // This internal function checks if an address is whitelisted in the whitelist contract.
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
388     var d = distributionMap[tokenAddr];
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
410   // This function sends the pooled eth to the receiving address, calculates the % of unused eth to be returned,
411   // and advances the contract to stage three. It can only be called by the contract owner during stages one or two.
412   // The amount to send (given in wei) must be specified during the call. As this function can only be executed once,
413   // it is VERY IMPORTANT not to get the amount wrong.
414   function submitPool (uint amountInWei) public onlyOwner noReentrancy {
415     require (contractStage < 3);
416     require (contributionMin <= amountInWei && amountInWei <= this.balance);
417     finalBalance = this.balance;
418     require (receiverAddress.call.value(amountInWei).gas(msg.gas.sub(5000))());
419     ethRefundAmount.push(this.balance);
420     contractStage = 3;
421     PoolSubmitted(receiverAddress, amountInWei);
422   }
423   
424   // This function opens the contract up for token withdrawals.
425   // It can only be called by the owner during stage 3.  The owner specifies the address of an ERC20 token
426   // contract that this contract has a balance in, and optionally a bool to prevent this token from being
427   // the default withdrawal (in the event of an airdrop, for example).
428   function enableTokenWithdrawals (address tokenAddr, bool notDefault) public onlyOwner noReentrancy {
429     require (contractStage == 3);
430     if (notDefault) {
431       require (activeToken != 0x00);
432     } else {
433       activeToken = tokenAddr;
434     }
435     var d = distributionMap[tokenAddr];    
436     if (d.pct.length==0) d.token = ERC20(tokenAddr);
437     uint amount = d.token.balanceOf(this).sub(d.balanceRemaining);
438     require (amount > 0);
439     if (feePct > 0) {
440       require (d.token.transfer(owner,_applyPct(amount,feePct)));
441     }
442     amount = d.token.balanceOf(this).sub(d.balanceRemaining);
443     d.balanceRemaining = d.token.balanceOf(this);
444     d.pct.push(_toPct(amount,finalBalance));
445   }
446   
447   // This is a standard function required for ERC223 compatibility.
448   function tokenFallback (address from, uint value, bytes data) public {
449     ERC223Received (from, value);
450   }
451   
452 }