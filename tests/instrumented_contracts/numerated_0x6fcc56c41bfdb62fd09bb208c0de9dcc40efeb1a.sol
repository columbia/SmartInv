1 /**
2  * Test & Staging servers.
3  * Allows EDG token holders to lend the Edgeless Casino tokens for the bankroll.
4  * Users may pay in their tokens at any time, but they will only be used for the bankroll
5  * begining from the next cycle. When the cycle is closed (at the end of the month), they may
6  * withdraw their stake of the bankroll. The casino may decide to limit the number of tokens
7  * used for the bankroll. The user will be able to withdraw the remaining tokens along with the
8  * bankroll tokens once per cycle.
9  * author: Rytis Grincevicius
10  * */
11 
12 pragma solidity ^0.4.21;
13 
14 contract Token {
15   function transfer(address receiver, uint amount) public returns(bool);
16   function transferFrom(address sender, address receiver, uint amount) public returns(bool);
17   function balanceOf(address holder) public view returns(uint);
18 }
19 
20 contract Casino {
21   mapping(address => bool) public authorized;
22 }
23 
24 contract Owned {
25   address public owner;
26   modifier onlyOwner {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   function Owned() public {
32     owner = msg.sender;
33   }
34 
35   function changeOwner(address newOwner) onlyOwner public {
36     owner = newOwner;
37   }
38 }
39 
40 contract SafeMath {
41 
42 	function safeSub(uint a, uint b) pure internal returns(uint) {
43 		assert(b <= a);
44 		return a - b;
45 	}
46 
47 	function safeAdd(uint a, uint b) pure internal returns(uint) {
48 		uint c = a + b;
49 		assert(c >= a && c >= b);
50 		return c;
51 	}
52 
53 	function safeMul(uint a, uint b) pure internal returns (uint) {
54     uint c = a * b;
55     assert(a == 0 || c / a == b);
56     return c;
57   }
58 }
59 
60 contract BankrollLending is Owned, SafeMath {
61   /** The set of lending contracts state phases **/
62   enum StatePhases { deposit, bankroll, update, withdraw }
63   /** The number of the current cycle. Increases by 1 each month.**/
64   uint public cycle;
65   /** The address of the casino contract.**/
66   Casino public casino;
67   /** The Edgeless casino token contract **/
68   Token public token;
69   /** The sum of the initial stakes per cycle **/
70   mapping(uint => uint) public initialStakes;
71   /** The sum of the final stakes per cycle **/
72   mapping(uint => uint) public finalStakes;
73   /** The sum of the user stakes currently on the contract **/
74   uint public totalStakes; //note: uint is enough because the Edgeless Token Contract has 0 decimals and a total supply of 132,046,997 EDG
75   /** the number of stake holders **/
76   uint public numHolders;
77   /** List of all stakeholders **/
78   address[] public stakeholders;
79   /** Stake per user address **/
80   mapping(address => uint) public stakes;
81   /** the gas cost if the casino helps the user with the deposit in full EDG **/
82   uint8 public depositGasCost;
83   /** the gas cost if the casino helps the user with the withdrawal in full EDG **/
84   uint8 public withdrawGasCost;
85   /** the gas cost for balance update at the end of the cycle per user in EDG with 2 decimals
86   * (updates are made for all users at once, so it's possible to subtract all gas costs from the paid back tokens before
87   * setting the final stakes of the cycle.) **/
88   uint public updateGasCost;
89   /** The minimum staking amount required **/
90   uint public minStakingAmount;
91   /** The maximum number of addresses to process in one batch of stake updates **/
92   uint public maxUpdates; 
93   /** The maximum number of addresses that can be assigned in one batch **/
94   uint public maxBatchAssignment;
95   /** remembers the last index updated per cycle **/
96   mapping(uint => uint) lastUpdateIndex;
97   /** notifies listeners about a stake update **/
98   event StakeUpdate(address holder, uint stake);
99 
100   /**
101    * Constructor.
102    * @param tokenAddr the address of the edgeless token contract
103    *        casinoAddr the address of the edgeless casino contract
104    * */
105   function BankrollLending(address tokenAddr, address casinoAddr) public {
106     token = Token(tokenAddr);
107     casino = Casino(casinoAddr);
108     maxUpdates = 200;
109     maxBatchAssignment = 200;
110     cycle = 1;
111   }
112 
113   /**
114    * Sets the casino contract address.
115    * @param casinoAddr the new casino contract address
116    * */
117   function setCasinoAddress(address casinoAddr) public onlyOwner {
118     casino = Casino(casinoAddr);
119   }
120 
121   /**
122    * Sets the deposit gas cost.
123    * @param gasCost the new deposit gas cost
124    * */
125   function setDepositGasCost(uint8 gasCost) public onlyAuthorized {
126     depositGasCost = gasCost;
127   }
128 
129   /**
130    * Sets the withdraw gas cost.
131    * @param gasCost the new withdraw gas cost
132    * */
133   function setWithdrawGasCost(uint8 gasCost) public onlyAuthorized {
134     withdrawGasCost = gasCost;
135   }
136 
137   /**
138    * Sets the update gas cost.
139    * @param gasCost the new update gas cost
140    * */
141   function setUpdateGasCost(uint gasCost) public onlyAuthorized {
142     updateGasCost = gasCost;
143   }
144   
145   /**
146    * Sets the maximum number of user stakes to update at once
147    * @param newMax the new maximum
148    * */
149   function setMaxUpdates(uint newMax) public onlyAuthorized{
150     maxUpdates = newMax;
151   }
152   
153   /**
154    * Sets the minimum amount of user stakes
155    * @param amount the new minimum
156    * */
157   function setMinStakingAmount(uint amount) public onlyAuthorized {
158     minStakingAmount = amount;
159   }
160   
161   /**
162    * Sets the maximum number of addresses that can be assigned at once
163    * @param newMax the new maximum
164    * */
165   function setMaxBatchAssignment(uint newMax) public onlyAuthorized {
166     maxBatchAssignment = newMax;
167   }
168   
169   /**
170    * Allows the user to deposit funds, where the sender address and max allowed value have to be signed together with the cycle
171    * number by the casino. The method verifies the signature and makes sure, the deposit was made in time, before updating
172    * the storage variables.
173    * @param value the number of tokens to deposit
174    *        allowedMax the maximum deposit allowed this cycle
175    *        v, r, s the signature of an authorized casino wallet
176    * */
177   function deposit(uint value, uint allowedMax, uint8 v, bytes32 r, bytes32 s) public depositPhase {
178     require(verifySignature(msg.sender, allowedMax, v, r, s));
179     if (addDeposit(msg.sender, value, numHolders, allowedMax))
180       numHolders = safeAdd(numHolders, 1);
181     totalStakes = safeSub(safeAdd(totalStakes, value), depositGasCost);
182   }
183 
184   /**
185    * Allows an authorized casino wallet to assign some tokens held by the lending contract to the given addresses.
186    * Only allows to assign token which do not already belong to any other user.
187    * Caller needs to make sure that the number of assignments can be processed in a single batch!
188    * @param to array containing the addresses of the holders
189    *        value array containing the number of tokens per address
190    * */
191   function batchAssignment(address[] to, uint[] value) public onlyAuthorized depositPhase {
192     require(to.length == value.length);
193     require(to.length <= maxBatchAssignment);
194     uint newTotalStakes = totalStakes;
195     uint numSH = numHolders;
196     for (uint8 i = 0; i < to.length; i++) {
197       newTotalStakes = safeSub(safeAdd(newTotalStakes, value[i]), depositGasCost);
198       if(addDeposit(to[i], value[i], numSH, 0))
199         numSH = safeAdd(numSH, 1);//save gas costs by increasing a memory variable instead of the storage variable per iteration
200     }
201     numHolders = numSH;
202     //rollback if more tokens have been assigned than the contract possesses
203     assert(newTotalStakes < tokenBalance());
204     totalStakes = newTotalStakes;
205   }
206   
207   /**
208    * updates the stake of an address.
209    * @param to the address
210    *        value the value to add to the stake
211    *        numSH the number of stakeholders
212    *        allowedMax the maximum amount a user may stake (0 in case the casino is making the assignment)
213    * */
214   function addDeposit(address to, uint value, uint numSH, uint allowedMax) internal returns (bool newHolder) {
215     require(value > 0);
216     uint newStake = safeSub(safeAdd(stakes[to], value), depositGasCost);
217     require(newStake >= minStakingAmount);
218     if(allowedMax > 0){//if allowedMax > 0 the caller is the user himself
219       require(newStake <= allowedMax);
220       assert(token.transferFrom(to, address(this), value));
221     }
222     if(stakes[to] == 0){
223       addHolder(to, numSH);
224       newHolder = true;
225     }
226     stakes[to] = newStake;
227     emit StakeUpdate(to, newStake);
228   }
229 
230   /**
231    * Transfers the total stakes to the casino contract to be used as bankroll.
232    * Callabe only once per cycle and only after a cycle was started.
233    * */
234   function useAsBankroll() public onlyAuthorized depositPhase {
235     initialStakes[cycle] = totalStakes;
236     totalStakes = 0; //withdrawals are unlocked until this value is > 0 again and the final stakes have been set
237     assert(token.transfer(address(casino), initialStakes[cycle]));
238   }
239 
240   /**
241    * Initiates the next cycle. Callabe only once per cycle and only after the last one was closed.
242    * */
243   function startNextCycle() public onlyAuthorized {
244     // make sure the last cycle was closed, can be called in update or withdraw phase
245     require(finalStakes[cycle] > 0);
246     cycle = safeAdd(cycle, 1);
247   }
248 
249   /**
250    * Sets the final sum of user stakes for history and profit computation. Callable only once per cycle.
251    * The token balance of the contract may not be set as final stake, because there might have occurred unapproved deposits.
252    * @param value the number of EDG tokens that were transfered from the bankroll
253    * */
254   function closeCycle(uint value) public onlyAuthorized bankrollPhase {
255     require(tokenBalance() >= value);
256     finalStakes[cycle] = safeSub(value, safeMul(updateGasCost, numHolders)/100);//updateGasCost is using 2 decimals
257   }
258 
259   /**
260    * Updates the user shares depending on the difference between final and initial stake.
261    * For doing so, it iterates over the array of stakeholders, while it processes max 500 addresses at once.
262    * If the array length is bigger than that, the contract remembers the position to start with on the next invocation.
263    * Therefore, this method might need to be called multiple times.
264    * It does consider the gas costs and subtracts them from the final stakes before computing the profit/loss.
265    * As soon as the last stake has been updated, withdrawals are unlocked by setting the totalStakes to the height of final stakes of the cycle.
266    * */
267   function updateUserShares() public onlyAuthorized updatePhase {
268     uint limit = safeAdd(lastUpdateIndex[cycle], maxUpdates);
269     if(limit >= numHolders) {
270       limit = numHolders;
271       totalStakes = finalStakes[cycle]; //enable withdrawals after this method call was processed
272       if (cycle > 1) {
273         lastUpdateIndex[cycle - 1] = 0;
274       }
275     }
276     address holder;
277     uint newStake;
278     for(uint i = lastUpdateIndex[cycle]; i < limit; i++){
279       holder = stakeholders[i];
280       newStake = computeFinalStake(stakes[holder]);
281       stakes[holder] = newStake;
282       emit StakeUpdate(holder, newStake);
283     }
284     lastUpdateIndex[cycle] = limit;
285   }
286 
287   /**
288   * In case something goes wrong above, enable the users to withdraw their tokens.
289   * Should never be necessary.
290   * @param value the number of tokens to release
291   **/
292   function unlockWithdrawals(uint value) public onlyOwner {
293     require(value <= tokenBalance());
294     totalStakes = value;
295   }
296 
297   /**
298    * If withdrawals are unlocked (final stakes of the cycle > 0 and totalStakes > 0), this function withdraws tokens from the sender’s balance to
299    * the specified address. If no balance remains, the user is removed from the stakeholder array.
300    * @param to the receiver
301    *        value the number of tokens
302    *        index the index of the message sender in the stakeholder array (save gas costs by not looking it up on the contract)
303    * */
304   function withdraw(address to, uint value, uint index) public withdrawPhase{
305     makeWithdrawal(msg.sender, to, value, index);
306   }
307 
308   /**
309    * An authorized casino wallet may use this function to make a withdrawal for the user.
310    * The value is subtracted from the signer’s balance and transferred to the specified address.
311    * If no balance remains, the signer is removed from the stakeholder array.
312    * @param to the receiver
313    *        value the number of tokens
314    *        index the index of the signer in the stakeholder array (save gas costs by not looking it up on the contract)
315    *        v, r, s the signature of the stakeholder
316    * */
317   function withdrawFor(address to, uint value, uint index, uint8 v, bytes32 r, bytes32 s) public onlyAuthorized withdrawPhase{
318     address from = ecrecover(keccak256(to, value, cycle), v, r, s);
319     makeWithdrawal(from, to, value, index);
320   }
321   
322   /**
323    * internal method for processing the withdrawal.
324    * @param from the stakeholder
325    *        to the receiver
326    *        value the number of tokens
327    *        index the index of the message sender in the stakeholder array (save gas costs by not looking it up on the contract)
328    * */
329   function makeWithdrawal(address from, address to, uint value, uint index) internal{
330     if(value == stakes[from]){
331       stakes[from] = 0;
332       removeHolder(from, index);
333       emit StakeUpdate(from, 0);
334     }
335     else{
336       uint newStake = safeSub(stakes[from], value);
337       require(newStake >= minStakingAmount);
338       stakes[from] = newStake;
339       emit StakeUpdate(from, newStake);
340     }
341     totalStakes = safeSub(totalStakes, value);
342     assert(token.transfer(to, safeSub(value, withdrawGasCost)));
343   }
344 
345   /**
346    * Allows the casino to withdraw tokens which do not belong to any stakeholder.
347    * This is the case for gas-payback-tokens and if people send their tokens directly to the contract
348    * without the approval of the casino.
349    * */
350   function withdrawExcess() public onlyAuthorized {
351     uint value = safeSub(tokenBalance(), totalStakes);
352     token.transfer(owner, value);
353   }
354 
355   /**
356    * Closes the contract in state of emergency or on contract update.
357    * Transfers all tokens held by the contract to the owner before doing so.
358    **/
359   function kill() public onlyOwner {
360     assert(token.transfer(owner, tokenBalance()));
361     selfdestruct(owner);
362   }
363 
364   /**
365    * @return the current token balance of the contract.
366    * */
367   function tokenBalance() public view returns(uint) {
368     return token.balanceOf(address(this));
369   }
370 
371   /**
372   * Adds a new stakeholder to the list.
373   * @param holder the address of the stakeholder
374   *        numSH  the current number of stakeholders
375   **/
376   function addHolder(address holder, uint numSH) internal{
377     if(numSH < stakeholders.length)
378       stakeholders[numSH] = holder;
379     else
380       stakeholders.push(holder);
381   }
382   
383   /**
384   * Removes a stakeholder from the list.
385   * @param holder the address of the stakeholder
386   *        index  the index of the holder
387   **/
388   function removeHolder(address holder, uint index) internal{
389     require(stakeholders[index] == holder);
390     numHolders = safeSub(numHolders, 1);
391     stakeholders[index] = stakeholders[numHolders];
392   }
393 
394   /**
395    * computes the final stake.
396    * @param initialStake the initial number of tokens the user invested
397    * @return finalStake  the final number of tokens the user receives
398    * */
399   function computeFinalStake(uint initialStake) internal view returns(uint) {
400     return safeMul(initialStake, finalStakes[cycle]) / initialStakes[cycle];
401   }
402 
403   /**
404    * verifies if the withdrawal request was signed by an authorized wallet
405    * @param to      the receiver address
406    *        value   the number of tokens
407    *        v, r, s the signature of an authorized wallet
408    * */
409   function verifySignature(address to, uint value, uint8 v, bytes32 r, bytes32 s) internal view returns(bool) {
410     address signer = ecrecover(keccak256(to, value, cycle), v, r, s);
411     return casino.authorized(signer);
412   }
413 
414   /**
415    * computes state based on the initial, total and final stakes of the current cycle.
416    * @return current state phase
417    * */
418   function getPhase() internal view returns (StatePhases) {
419     if (initialStakes[cycle] == 0) {
420       return StatePhases.deposit;
421     } else if (finalStakes[cycle] == 0) {
422       return StatePhases.bankroll;
423     } else if (totalStakes == 0) {
424       return StatePhases.update;
425     }
426     return StatePhases.withdraw;
427   }
428   
429   //check if the sender is an authorized casino wallet
430   modifier onlyAuthorized {
431     require(casino.authorized(msg.sender));
432     _;
433   }
434 
435   // deposit phase: initialStakes[cycle] == 0
436   modifier depositPhase {
437     require(getPhase() == StatePhases.deposit);
438     _;
439   }
440 
441   // bankroll phase: initialStakes[cycle] > 0 and finalStakes[cycle] == 0
442   modifier bankrollPhase {
443     require(getPhase() == StatePhases.bankroll);
444     _;
445   }
446 
447   // update phase: finalStakes[cycle] > 0 and totalStakes == 0
448   modifier updatePhase {
449     require(getPhase() == StatePhases.update);
450     _;
451   }
452 
453   // withdraw phase: finalStakes[cycle] > 0 and totalStakes > 0
454   modifier withdrawPhase {
455     require(getPhase() == StatePhases.withdraw);
456     _;
457   }
458 
459 }