1 /**
2  *Submitted for verification at Etherscan.io on 2018-12-03
3 */
4 
5 /**
6  * Allows EDG token holders to lend the Edgeless Casino tokens for the bankroll.
7  * Users may pay in their tokens at any time, but they will only be used for the bankroll
8  * begining from the next cycle. When the cycle is closed (at the end of the month), they may
9  * withdraw their stake of the bankroll. The casino may decide to limit the number of tokens
10  * used for the bankroll. The user will be able to withdraw the remaining tokens along with the
11  * bankroll tokens once per cycle.
12  * author: Julia Altenried
13  * */
14 
15 pragma solidity ^0.4.21;
16 
17 contract Token {
18   function transfer(address receiver, uint amount) public returns(bool);
19   function transferFrom(address sender, address receiver, uint amount) public returns(bool);
20   function balanceOf(address holder) public view returns(uint);
21 }
22 
23 contract Casino {
24   mapping(address => bool) public authorized;
25 }
26 
27 contract Owned {
28   address public owner;
29   modifier onlyOwner {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   function Owned() public {
35     owner = msg.sender;
36   }
37 
38   function changeOwner(address newOwner) onlyOwner public {
39     owner = newOwner;
40   }
41 }
42 
43 contract SafeMath {
44 
45 	function safeSub(uint a, uint b) pure internal returns(uint) {
46 		assert(b <= a);
47 		return a - b;
48 	}
49 
50 	function safeAdd(uint a, uint b) pure internal returns(uint) {
51 		uint c = a + b;
52 		assert(c >= a && c >= b);
53 		return c;
54 	}
55 
56 	function safeMul(uint a, uint b) pure internal returns (uint) {
57     uint c = a * b;
58     assert(a == 0 || c / a == b);
59     return c;
60   }
61 }
62 
63 contract BankrollLending is Owned, SafeMath {
64   /** The set of lending contracts state phases **/
65   enum StatePhases { deposit, bankroll, update, withdraw }
66   /** The number of the current cycle. Increases by 1 each month.**/
67   uint public cycle;
68   /** The address of the casino contract.**/
69   Casino public casino;
70   /** The Edgeless casino token contract **/
71   Token public token;
72   /** The sum of the initial stakes per cycle **/
73   mapping(uint => uint) public initialStakes;
74   /** The sum of the final stakes per cycle **/
75   mapping(uint => uint) public finalStakes;
76   /** The sum of the user stakes currently on the contract **/
77   uint public totalStakes; //note: uint is enough because the Edgeless Token Contract has 0 decimals and a total supply of 132,046,997 EDG
78   /** the number of stake holders **/
79   uint public numHolders;
80   /** List of all stakeholders **/
81   address[] public stakeholders;
82   /** Stake per user address **/
83   mapping(address => uint) public stakes;
84   /** the gas cost if the casino helps the user with the deposit in full EDG **/
85   uint8 public depositGasCost;
86   /** the gas cost if the casino helps the user with the withdrawal in full EDG **/
87   uint8 public withdrawGasCost;
88   /** the gas cost for balance update at the end of the cycle per user in EDG with 2 decimals
89   * (updates are made for all users at once, so it's possible to subtract all gas costs from the paid back tokens before
90   * setting the final stakes of the cycle.) **/
91   uint public updateGasCost;
92   /** The minimum staking amount required **/
93   uint public minStakingAmount;
94   /** The maximum number of addresses to process in one batch of stake updates **/
95   uint public maxUpdates; 
96   /** The maximum number of addresses that can be assigned in one batch **/
97   uint public maxBatchAssignment;
98   /** remembers the last index updated per cycle **/
99   mapping(uint => uint) lastUpdateIndex;
100   /** notifies listeners about a stake update **/
101   event StakeUpdate(address holder, uint stake);
102 
103   /**
104    * Constructor.
105    * @param tokenAddr the address of the edgeless token contract
106    *        casinoAddr the address of the edgeless casino contract
107    * */
108   function BankrollLending(address tokenAddr, address casinoAddr) public {
109     token = Token(tokenAddr);
110     casino = Casino(casinoAddr);
111     maxUpdates = 200;
112     maxBatchAssignment = 200;
113     cycle = 1;
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
306    * */
307   function withdraw(address to, uint value, uint index) public withdrawPhase{
308     makeWithdrawal(msg.sender, to, value, index);
309   }
310 
311   /**
312    * An authorized casino wallet may use this function to make a withdrawal for the user.
313    * The value is subtracted from the signer’s balance and transferred to the specified address.
314    * If no balance remains, the signer is removed from the stakeholder array.
315    * @param to the receiver
316    *        value the number of tokens
317    *        index the index of the signer in the stakeholder array (save gas costs by not looking it up on the contract)
318    *        v, r, s the signature of the stakeholder
319    * */
320   function withdrawFor(address to, uint value, uint index, uint8 v, bytes32 r, bytes32 s) public onlyAuthorized withdrawPhase{
321     address from = ecrecover(keccak256(to, value, cycle), v, r, s);
322     makeWithdrawal(from, to, value, index);
323   }
324   
325   /**
326    * internal method for processing the withdrawal.
327    * @param from the stakeholder
328    *        to the receiver
329    *        value the number of tokens
330    *        index the index of the message sender in the stakeholder array (save gas costs by not looking it up on the contract)
331    * */
332   function makeWithdrawal(address from, address to, uint value, uint index) internal{
333     if(value == stakes[from]){
334       stakes[from] = 0;
335       removeHolder(from, index);
336       emit StakeUpdate(from, 0);
337     }
338     else{
339       uint newStake = safeSub(stakes[from], value);
340       require(newStake >= minStakingAmount);
341       stakes[from] = newStake;
342       emit StakeUpdate(from, newStake);
343     }
344     totalStakes = safeSub(totalStakes, value);
345     assert(token.transfer(to, safeSub(value, withdrawGasCost)));
346   }
347 
348   /**
349    * Allows the casino to withdraw tokens which do not belong to any stakeholder.
350    * This is the case for gas-payback-tokens and if people send their tokens directly to the contract
351    * without the approval of the casino.
352    * */
353   function withdrawExcess() public onlyAuthorized {
354     uint value = safeSub(tokenBalance(), totalStakes);
355     token.transfer(owner, value);
356   }
357 
358   /**
359    * Closes the contract in state of emergency or on contract update.
360    * Transfers all tokens held by the contract to the owner before doing so.
361    **/
362   function kill() public onlyOwner {
363     assert(token.transfer(owner, tokenBalance()));
364     selfdestruct(owner);
365   }
366 
367   /**
368    * @return the current token balance of the contract.
369    * */
370   function tokenBalance() public view returns(uint) {
371     return token.balanceOf(address(this));
372   }
373 
374   /**
375   * Adds a new stakeholder to the list.
376   * @param holder the address of the stakeholder
377   *        numSH  the current number of stakeholders
378   **/
379   function addHolder(address holder, uint numSH) internal{
380     if(numSH < stakeholders.length)
381       stakeholders[numSH] = holder;
382     else
383       stakeholders.push(holder);
384   }
385   
386   /**
387   * Removes a stakeholder from the list.
388   * @param holder the address of the stakeholder
389   *        index  the index of the holder
390   **/
391   function removeHolder(address holder, uint index) internal{
392     require(stakeholders[index] == holder);
393     numHolders = safeSub(numHolders, 1);
394     stakeholders[index] = stakeholders[numHolders];
395   }
396 
397   /**
398    * computes the final stake.
399    * @param initialStake the initial number of tokens the user invested
400    * @return finalStake  the final number of tokens the user receives
401    * */
402   function computeFinalStake(uint initialStake) internal view returns(uint) {
403     return safeMul(initialStake, finalStakes[cycle]) / initialStakes[cycle];
404   }
405 
406   /**
407    * verifies if the withdrawal request was signed by an authorized wallet
408    * @param to      the receiver address
409    *        value   the number of tokens
410    *        v, r, s the signature of an authorized wallet
411    * */
412   function verifySignature(address to, uint value, uint8 v, bytes32 r, bytes32 s) internal view returns(bool) {
413     address signer = ecrecover(keccak256(to, value, cycle), v, r, s);
414     return casino.authorized(signer);
415   }
416 
417   /**
418    * computes state based on the initial, total and final stakes of the current cycle.
419    * @return current state phase
420    * */
421   function getPhase() internal view returns (StatePhases) {
422     if (initialStakes[cycle] == 0) {
423       return StatePhases.deposit;
424     } else if (finalStakes[cycle] == 0) {
425       return StatePhases.bankroll;
426     } else if (totalStakes == 0) {
427       return StatePhases.update;
428     }
429     return StatePhases.withdraw;
430   }
431   
432   //check if the sender is an authorized casino wallet
433   modifier onlyAuthorized {
434     require(casino.authorized(msg.sender));
435     _;
436   }
437 
438   // deposit phase: initialStakes[cycle] == 0
439   modifier depositPhase {
440     require(getPhase() == StatePhases.deposit);
441     _;
442   }
443 
444   // bankroll phase: initialStakes[cycle] > 0 and finalStakes[cycle] == 0
445   modifier bankrollPhase {
446     require(getPhase() == StatePhases.bankroll);
447     _;
448   }
449 
450   // update phase: finalStakes[cycle] > 0 and totalStakes == 0
451   modifier updatePhase {
452     require(getPhase() == StatePhases.update);
453     _;
454   }
455 
456   // withdraw phase: finalStakes[cycle] > 0 and totalStakes > 0
457   modifier withdrawPhase {
458     require(getPhase() == StatePhases.withdraw);
459     _;
460   }
461 
462 }