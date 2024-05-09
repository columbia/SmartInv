1 /**
2  * Allows EDG token holders to lend the Edgeless Casino tokens for the bankroll.
3  * Users may pay in their tokens at any time, but they will only be used for the bankroll
4  * begining from the next cycle. When the cycle is closed (at the end of the month), they may
5  * withdraw their stake of the bankroll. The casino may decide to limit the number of tokens
6  * used for the bankroll. The user will be able to withdraw the remaining tokens along with the
7  * bankroll tokens once per cycle.
8  * author: Julia Altenried
9  * */
10 
11 pragma solidity ^0.4.21;
12 
13 contract Token {
14   function transfer(address receiver, uint amount) public returns(bool);
15   function transferFrom(address sender, address receiver, uint amount) public returns(bool);
16   function balanceOf(address holder) public view returns(uint);
17 }
18 
19 contract Casino {
20   mapping(address => bool) public authorized;
21 }
22 
23 contract Owned {
24   address public owner;
25   modifier onlyOwner {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   function Owned() public {
31     owner = msg.sender;
32   }
33 
34   function changeOwner(address newOwner) onlyOwner public {
35     owner = newOwner;
36   }
37 }
38 
39 contract SafeMath {
40 
41 	function safeSub(uint a, uint b) pure internal returns(uint) {
42 		assert(b <= a);
43 		return a - b;
44 	}
45 
46 	function safeAdd(uint a, uint b) pure internal returns(uint) {
47 		uint c = a + b;
48 		assert(c >= a && c >= b);
49 		return c;
50 	}
51 
52 	function safeMul(uint a, uint b) pure internal returns (uint) {
53     uint c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57 }
58 
59 contract BankrollLending is Owned, SafeMath {
60   /** The set of lending contracts state phases **/
61   enum StatePhases { deposit, bankroll, update, withdraw }
62   /** The number of the current cycle. Increases by 1 each month.**/
63   uint public cycle;
64   /** The address of the casino contract.**/
65   Casino public casino;
66   /** The Edgeless casino token contract **/
67   Token public token;
68   /** Previuos staking contract **/
69   address public predecessor;
70   /** The sum of the initial stakes per cycle **/
71   mapping(uint => uint) public initialStakes;
72   /** The sum of the final stakes per cycle **/
73   mapping(uint => uint) public finalStakes;
74   /** The sum of the user stakes currently on the contract **/
75   uint public totalStakes; //note: uint is enough because the Edgeless Token Contract has 0 decimals and a total supply of 132,046,997 EDG
76   /** the number of stake holders **/
77   uint public numHolders;
78   /** List of all stakeholders **/
79   address[] public stakeholders;
80   /** Stake per user address **/
81   mapping(address => uint) public stakes;
82   /** the gas cost if the casino helps the user with the deposit in full EDG **/
83   uint8 public depositGasCost;
84   /** the gas cost if the casino helps the user with the withdrawal in full EDG **/
85   uint8 public withdrawGasCost;
86   /** the gas cost for balance update at the end of the cycle per user in EDG with 2 decimals
87   * (updates are made for all users at once, so it's possible to subtract all gas costs from the paid back tokens before
88   * setting the final stakes of the cycle.) **/
89   uint public updateGasCost;
90   /** The minimum staking amount required **/
91   uint public minStakingAmount;
92   /** The maximum number of addresses to process in one batch of stake updates **/
93   uint public maxUpdates; 
94   /** The maximum number of addresses that can be assigned in one batch **/
95   uint public maxBatchAssignment;
96   /** remembers the last index updated per cycle **/
97   mapping(uint => uint) lastUpdateIndex;
98   /** notifies listeners about a stake update **/
99   event StakeUpdate(address holder, uint stake);
100 
101   /**
102    * Constructor.
103    * @param tokenAddr the address of the edgeless token contract
104    *        casinoAddr the address of the edgeless casino contract
105    *        predecessorAdr the address of the previous bankroll lending contract.
106    * */
107   function BankrollLending(address tokenAddr, address casinoAddr, address predecessorAdr) public {
108     token = Token(tokenAddr);
109     casino = Casino(casinoAddr);
110     predecessor = predecessorAdr;
111     maxUpdates = 200;
112     maxBatchAssignment = 200;
113     cycle = 7;
114   }
115 
116   /**
117    * Sets the casino contract address.
118    * @param casinoAddr the new casino contract address
119    * */
120   function setCasinoAddress(address casinoAddr) public onlyOwner {
121     casino = Casino(casinoAddr);
122   }
123 
124   /**
125    * Sets the deposit gas cost.
126    * @param gasCost the new deposit gas cost
127    * */
128   function setDepositGasCost(uint8 gasCost) public onlyAuthorized {
129     depositGasCost = gasCost;
130   }
131 
132   /**
133    * Sets the withdraw gas cost.
134    * @param gasCost the new withdraw gas cost
135    * */
136   function setWithdrawGasCost(uint8 gasCost) public onlyAuthorized {
137     withdrawGasCost = gasCost;
138   }
139 
140   /**
141    * Sets the update gas cost.
142    * @param gasCost the new update gas cost
143    * */
144   function setUpdateGasCost(uint gasCost) public onlyAuthorized {
145     updateGasCost = gasCost;
146   }
147   
148   /**
149    * Sets the maximum number of user stakes to update at once
150    * @param newMax the new maximum
151    * */
152   function setMaxUpdates(uint newMax) public onlyAuthorized{
153     maxUpdates = newMax;
154   }
155   
156   /**
157    * Sets the minimum amount of user stakes
158    * @param amount the new minimum
159    * */
160   function setMinStakingAmount(uint amount) public onlyAuthorized {
161     minStakingAmount = amount;
162   }
163   
164   /**
165    * Sets the maximum number of addresses that can be assigned at once
166    * @param newMax the new maximum
167    * */
168   function setMaxBatchAssignment(uint newMax) public onlyAuthorized {
169     maxBatchAssignment = newMax;
170   }
171   
172   /**
173    * Allows the user to deposit funds, where the sender address and max allowed value have to be signed together with the cycle
174    * number by the casino. The method verifies the signature and makes sure, the deposit was made in time, before updating
175    * the storage variables.
176    * @param value the number of tokens to deposit
177    *        allowedMax the maximum deposit allowed this cycle
178    *        v, r, s the signature of an authorized casino wallet
179    * */
180   function deposit(uint value, uint allowedMax, uint8 v, bytes32 r, bytes32 s) public depositPhase {
181     require(verifySignature(msg.sender, allowedMax, v, r, s));
182     if (addDeposit(msg.sender, value, numHolders, allowedMax))
183       numHolders = safeAdd(numHolders, 1);
184     totalStakes = safeSub(safeAdd(totalStakes, value), depositGasCost);
185   }
186 
187   /**
188    * Allows an authorized casino wallet to assign some tokens held by the lending contract to the given addresses.
189    * Only allows to assign token which do not already belong to any other user.
190    * Caller needs to make sure that the number of assignments can be processed in a single batch!
191    * @param to array containing the addresses of the holders
192    *        value array containing the number of tokens per address
193    * */
194   function batchAssignment(address[] to, uint[] value) public onlyAuthorized depositPhase {
195     require(to.length == value.length);
196     require(to.length <= maxBatchAssignment);
197     uint newTotalStakes = totalStakes;
198     uint numSH = numHolders;
199     for (uint8 i = 0; i < to.length; i++) {
200       newTotalStakes = safeSub(safeAdd(newTotalStakes, value[i]), depositGasCost);
201       if(addDeposit(to[i], value[i], numSH, 0))
202         numSH = safeAdd(numSH, 1);//save gas costs by increasing a memory variable instead of the storage variable per iteration
203     }
204     numHolders = numSH;
205     //rollback if more tokens have been assigned than the contract possesses
206     assert(newTotalStakes < tokenBalance());
207     totalStakes = newTotalStakes;
208   }
209   
210   /**
211    * updates the stake of an address.
212    * @param to the address
213    *        value the value to add to the stake
214    *        numSH the number of stakeholders
215    *        allowedMax the maximum amount a user may stake (0 in case the casino is making the assignment)
216    * */
217   function addDeposit(address to, uint value, uint numSH, uint allowedMax) internal returns (bool newHolder) {
218     require(value > 0);
219     uint newStake = safeSub(safeAdd(stakes[to], value), depositGasCost);
220     require(newStake >= minStakingAmount);
221     if(allowedMax > 0){//if allowedMax > 0 the caller is the user himself
222       require(newStake <= allowedMax);
223       assert(token.transferFrom(to, address(this), value));
224     }
225     if(stakes[to] == 0){
226       addHolder(to, numSH);
227       newHolder = true;
228     }
229     stakes[to] = newStake;
230     emit StakeUpdate(to, newStake);
231   }
232 
233   /**
234    * Transfers the total stakes to the casino contract to be used as bankroll.
235    * Callabe only once per cycle and only after a cycle was started.
236    * */
237   function useAsBankroll() public onlyAuthorized depositPhase {
238     initialStakes[cycle] = totalStakes;
239     totalStakes = 0; //withdrawals are unlocked until this value is > 0 again and the final stakes have been set
240     assert(token.transfer(address(casino), initialStakes[cycle]));
241   }
242 
243   /**
244    * Initiates the next cycle. Callabe only once per cycle and only after the last one was closed.
245    * */
246   function startNextCycle() public onlyAuthorized {
247     // make sure the last cycle was closed, can be called in update or withdraw phase
248     require(finalStakes[cycle] > 0);
249     cycle = safeAdd(cycle, 1);
250   }
251 
252   /**
253    * Sets the final sum of user stakes for history and profit computation. Callable only once per cycle.
254    * The token balance of the contract may not be set as final stake, because there might have occurred unapproved deposits.
255    * @param value the number of EDG tokens that were transfered from the bankroll
256    * */
257   function closeCycle(uint value) public onlyAuthorized bankrollPhase {
258     require(tokenBalance() >= value);
259     finalStakes[cycle] = safeSub(value, safeMul(updateGasCost, numHolders)/100);//updateGasCost is using 2 decimals
260   }
261 
262   /**
263    * Updates the user shares depending on the difference between final and initial stake.
264    * For doing so, it iterates over the array of stakeholders, while it processes max 500 addresses at once.
265    * If the array length is bigger than that, the contract remembers the position to start with on the next invocation.
266    * Therefore, this method might need to be called multiple times.
267    * It does consider the gas costs and subtracts them from the final stakes before computing the profit/loss.
268    * As soon as the last stake has been updated, withdrawals are unlocked by setting the totalStakes to the height of final stakes of the cycle.
269    * */
270   function updateUserShares() public onlyAuthorized updatePhase {
271     uint limit = safeAdd(lastUpdateIndex[cycle], maxUpdates);
272     if(limit >= numHolders) {
273       limit = numHolders;
274       totalStakes = finalStakes[cycle]; //enable withdrawals after this method call was processed
275       if (cycle > 1) {
276         lastUpdateIndex[cycle - 1] = 0;
277       }
278     }
279     address holder;
280     uint newStake;
281     for(uint i = lastUpdateIndex[cycle]; i < limit; i++){
282       holder = stakeholders[i];
283       newStake = computeFinalStake(stakes[holder]);
284       stakes[holder] = newStake;
285       emit StakeUpdate(holder, newStake);
286     }
287     lastUpdateIndex[cycle] = limit;
288   }
289 
290   /**
291   * In case something goes wrong above, enable the users to withdraw their tokens.
292   * Should never be necessary.
293   * @param value the number of tokens to release
294   **/
295   function unlockWithdrawals(uint value) public onlyOwner {
296     require(value <= tokenBalance());
297     totalStakes = value;
298   }
299 
300   /**
301    * If withdrawals are unlocked (final stakes of the cycle > 0 and totalStakes > 0), this function withdraws tokens from the sender’s balance to
302    * the specified address. If no balance remains, the user is removed from the stakeholder array.
303    * @param to the receiver
304    *        value the number of tokens
305    *        index the index of the message sender in the stakeholder array (save gas costs by not looking it up on the contract)
306    *        share to send to staker 1000 is 100%
307    * */
308   function withdraw(address to, uint value, uint index, uint share) public withdrawPhase{
309     makeWithdrawal(msg.sender, to, value, index, share);
310   }
311 
312   /**
313    * An authorized casino wallet may use this function to make a withdrawal for the user.
314    * The value is subtracted from the signer’s balance and transferred to the specified address.
315    * If no balance remains, the signer is removed from the stakeholder array.
316    * @param to the receiver
317    *        value the number of tokens
318    *        index the index of the signer in the stakeholder array (save gas costs by not looking it up on the contract)
319    *        share to send to staker 1000 is 100%
320    *        v, r, s the signature of the stakeholder
321    * */
322   function withdrawFor(address to, uint value, uint index, uint share, uint8 v, bytes32 r, bytes32 s) public onlyAuthorized withdrawPhase{
323     address from = ecrecover(keccak256(to, value, cycle), v, r, s);
324     makeWithdrawal(from, to, value, index, share);
325   }
326   
327   /**
328    * internal method for processing the withdrawal.
329    * @param from the stakeholder
330    *        to the receiver
331    *        value the number of tokens
332    *        index the index of the message sender in the stakeholder array (save gas costs by not looking it up on the contract)
333    *        share to send to staker 1000 is 100%
334    * */
335   function makeWithdrawal(address from, address to, uint value, uint index, uint share) internal{
336     if(value == stakes[from]){
337       stakes[from] = 0;
338       removeHolder(from, index);
339       emit StakeUpdate(from, 0);
340     }
341     else{
342       uint newStake = safeSub(stakes[from], value);
343       require(newStake >= minStakingAmount);
344       stakes[from] = newStake;
345       emit StakeUpdate(from, newStake);
346     }
347     totalStakes = safeSub(totalStakes, value);
348     uint receives = value;
349     uint bankroll = 0;
350     if (share < 1000) {
351         receives = safeMul(value, safeMul(1000, share));
352         bankroll = safeSub(value, receives);
353     }
354     assert(token.transfer(to, safeSub(receives, withdrawGasCost)));
355     if (bankroll > 0) {
356         assert(token.transfer(address(casino), bankroll));
357     }
358   }
359 
360   /**
361    * Allows the casino to withdraw tokens which do not belong to any stakeholder.
362    * This is the case for gas-payback-tokens and if people send their tokens directly to the contract
363    * without the approval of the casino.
364    * */
365   function withdrawExcess() public onlyAuthorized {
366     uint value = safeSub(tokenBalance(), totalStakes);
367     token.transfer(owner, value);
368   }
369 
370   /**
371    * Closes the contract in state of emergency or on contract update.
372    * Transfers all tokens held by the contract to the owner before doing so.
373    **/
374   function kill() public onlyOwner {
375     assert(token.transfer(owner, tokenBalance()));
376     selfdestruct(owner);
377   }
378 
379   /**
380    * @return the current token balance of the contract.
381    * */
382   function tokenBalance() public view returns(uint) {
383     return token.balanceOf(address(this));
384   }
385 
386   /**
387   * Adds a new stakeholder to the list.
388   * @param holder the address of the stakeholder
389   *        numSH  the current number of stakeholders
390   **/
391   function addHolder(address holder, uint numSH) internal{
392     if(numSH < stakeholders.length)
393       stakeholders[numSH] = holder;
394     else
395       stakeholders.push(holder);
396   }
397   
398   /**
399   * Removes a stakeholder from the list.
400   * @param holder the address of the stakeholder
401   *        index  the index of the holder
402   **/
403   function removeHolder(address holder, uint index) internal{
404     require(stakeholders[index] == holder);
405     numHolders = safeSub(numHolders, 1);
406     stakeholders[index] = stakeholders[numHolders];
407   }
408 
409   /**
410    * computes the final stake.
411    * @param initialStake the initial number of tokens the user invested
412    * @return finalStake  the final number of tokens the user receives
413    * */
414   function computeFinalStake(uint initialStake) internal view returns(uint) {
415     return safeMul(initialStake, finalStakes[cycle]) / initialStakes[cycle];
416   }
417 
418   /**
419    * verifies if the withdrawal request was signed by an authorized wallet
420    * @param to      the receiver address
421    *        value   the number of tokens
422    *        v, r, s the signature of an authorized wallet
423    * */
424   function verifySignature(address to, uint value, uint8 v, bytes32 r, bytes32 s) internal view returns(bool) {
425     address signer = ecrecover(keccak256(to, value, cycle), v, r, s);
426     return casino.authorized(signer);
427   }
428 
429   /**
430    * computes state based on the initial, total and final stakes of the current cycle.
431    * @return current state phase
432    * */
433   function getPhase() public view returns (StatePhases) {
434     if (initialStakes[cycle] == 0) {
435       return StatePhases.deposit;
436     } else if (finalStakes[cycle] == 0) {
437       return StatePhases.bankroll;
438     } else if (totalStakes == 0) {
439       return StatePhases.update;
440     }
441     return StatePhases.withdraw;
442   }
443   
444   //check if the sender is an authorized casino wallet
445   modifier onlyAuthorized {
446     require(casino.authorized(msg.sender));
447     _;
448   }
449 
450   // deposit phase: initialStakes[cycle] == 0
451   modifier depositPhase {
452     require(getPhase() == StatePhases.deposit);
453     _;
454   }
455 
456   // bankroll phase: initialStakes[cycle] > 0 and finalStakes[cycle] == 0
457   modifier bankrollPhase {
458     require(getPhase() == StatePhases.bankroll);
459     _;
460   }
461 
462   // update phase: finalStakes[cycle] > 0 and totalStakes == 0
463   modifier updatePhase {
464     require(getPhase() == StatePhases.update);
465     _;
466   }
467 
468   // withdraw phase: finalStakes[cycle] > 0 and totalStakes > 0
469   modifier withdrawPhase {
470     require(getPhase() == StatePhases.withdraw);
471     _;
472   }
473 
474 }