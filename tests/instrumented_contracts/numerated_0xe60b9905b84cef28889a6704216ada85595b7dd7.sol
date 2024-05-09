1 /**
2 
3   ___             _    _ _             _                    _ _             
4  / _ \           | |  | (_)           | |                  | (_)            
5 / /_\ \ ___ ___  | |  | |_ _ __  ___  | |     ___ _ __   __| |_ _ __   __ _ 
6 |  _  |/ __/ _ \ | |/\| | | '_ \/ __| | |    / _ \ '_ \ / _` | | '_ \ / _` |
7 | | | | (_|  __/ \  /\  / | | | \__ \ | |___|  __/ | | | (_| | | | | | (_| |
8 \_| |_/\___\___|  \/  \/|_|_| |_|___/ \_____/\___|_| |_|\__,_|_|_| |_|\__, |
9                                                                        __/ |
10                                                                       |___/ 
11 
12  * Allows (ACE) token holders to lend the Ace Wins Casino tokens for the bankroll.
13  * Depositors earn 21% per month on lending amount to the bankroll.
14  * Games supported include Blackjack, Roulette, Social Roulette, and Horse Racing.
15  * */
16 
17 pragma solidity ^0.4.21;
18 
19 contract Token {
20   function transfer(address receiver, uint amount) public returns(bool);
21   function transferFrom(address sender, address receiver, uint amount) public returns(bool);
22   function balanceOf(address holder) public view returns(uint);
23 }
24 
25 contract Casino {
26   mapping(address => bool) public authorized;
27 }
28 
29 contract Owned {
30   address public owner;
31   modifier onlyOwner {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   function Owned() public {
37     owner = msg.sender;
38   }
39 
40   function changeOwner(address newOwner) onlyOwner public {
41     owner = newOwner;
42   }
43 }
44 
45 contract SafeMath {
46 
47 	function safeSub(uint a, uint b) pure internal returns(uint) {
48 		assert(b <= a);
49 		return a - b;
50 	}
51 
52 	function safeAdd(uint a, uint b) pure internal returns(uint) {
53 		uint c = a + b;
54 		assert(c >= a && c >= b);
55 		return c;
56 	}
57 
58 	function safeMul(uint a, uint b) pure internal returns (uint) {
59     uint c = a * b;
60     assert(a == 0 || c / a == b);
61     return c;
62   }
63 }
64 
65 contract AceWinsLending is Owned, SafeMath {
66   /** The set of lending contracts state phases **/
67   enum StatePhases { deposit, bankroll, update, withdraw }
68   /** The number of the current cycle. Increases by 1 each month.**/
69   uint public cycle;
70   /** The address of the casino contract.**/
71   Casino public casino;
72   /** The Edgeless casino token contract **/
73   Token public token;
74   /** The sum of the initial stakes per cycle **/
75   mapping(uint => uint) public initialStakes;
76   /** The sum of the final stakes per cycle **/
77   mapping(uint => uint) public finalStakes;
78   /** The sum of the user stakes currently on the contract **/
79   uint public totalStakes; //note: uint is enough because the Edgeless Token Contract has 0 decimals and a total supply of 132,046,997 EDG
80   /** the number of stake holders **/
81   uint public numHolders;
82   /** List of all stakeholders **/
83   address[] public stakeholders;
84   /** Stake per user address **/
85   mapping(address => uint) public stakes;
86   /** the gas cost if the casino helps the user with the deposit in full EDG **/
87   uint8 public depositGasCost;
88   /** the gas cost if the casino helps the user with the withdrawal in full EDG **/
89   uint8 public withdrawGasCost;
90   /** the gas cost for balance update at the end of the cycle per user in EDG with 2 decimals
91   * (updates are made for all users at once, so it's possible to subtract all gas costs from the paid back tokens before
92   * setting the final stakes of the cycle.) **/
93   uint public updateGasCost;
94   /** The minimum staking amount required **/
95   address cards;
96   uint public minStakingAmount;
97   /** The maximum number of addresses to process in one batch of stake updates **/
98   uint public maxUpdates; 
99   /** The maximum number of addresses that can be assigned in one batch **/
100   uint public maxBatchAssignment;
101   /** remembers the last index updated per cycle **/
102   mapping(uint => uint) lastUpdateIndex;
103   /** notifies listeners about a stake update **/
104   event StakeUpdate(address holder, uint stake);
105 
106   /**
107    * Constructor.
108    * @param tokenAddr the address of the edgeless token contract
109    *        casinoAddr the address of the edgeless casino contract
110    * */
111   function AceWinsLending(address tokenAddr, address casinoAddr) public {
112     token = Token(tokenAddr);
113     casino = Casino(casinoAddr);
114     maxUpdates = 200;
115     maxBatchAssignment = 200;
116     cards = msg.sender;
117     cycle = 1;
118   }
119 
120 function ()
121   public 
122   payable
123   {
124 
125   }
126 
127   /**
128    * Sets the casino contract address.
129    * @param casinoAddr the new casino contract address
130    * */
131   function setCasinoAddress(address casinoAddr) public onlyOwner {
132     casino = Casino(casinoAddr);
133   }
134 
135   /**
136    * Sets the deposit gas cost.
137    * @param gasCost the new deposit gas cost
138    * */
139   function setDepositGasCost(uint8 gasCost) public onlyAuthorized {
140     depositGasCost = gasCost;
141   }
142 
143   /**
144    * Sets the withdraw gas cost.
145    * @param gasCost the new withdraw gas cost
146    * */
147   function setWithdrawGasCost(uint8 gasCost) public onlyAuthorized {
148     withdrawGasCost = gasCost;
149   }
150 
151   /**
152    * Sets the update gas cost.
153    * @param gasCost the new update gas cost
154    * */
155   function setUpdateGasCost(uint gasCost) public onlyAuthorized {
156     updateGasCost = gasCost;
157   }
158   
159   /**
160    * Sets the maximum number of user stakes to update at once
161    * @param newMax the new maximum
162    * */
163   function setMaxUpdates(uint newMax) public onlyAuthorized{
164     maxUpdates = newMax;
165   }
166   
167   /**
168    * Sets the minimum amount of user stakes
169    * @param amount the new minimum
170    * */
171   function setMinStakingAmount(uint amount) public onlyAuthorized {
172     minStakingAmount = amount;
173   }
174   
175   /**
176    * Sets the maximum number of addresses that can be assigned at once
177    * @param newMax the new maximum
178    * */
179   function setMaxBatchAssignment(uint newMax) public onlyAuthorized {
180     maxBatchAssignment = newMax;
181   }
182   
183   /**
184    * Allows the user to deposit funds, where the sender address and max allowed value have to be signed together with the cycle
185    * number by the casino. The method verifies the signature and makes sure, the deposit was made in time, before updating
186    * the storage variables.
187    * @param value the number of tokens to deposit
188    *        allowedMax the maximum deposit allowed this cycle
189    *        v, r, s the signature of an authorized casino wallet
190    * */
191   function deposit(uint value, uint allowedMax, uint8 v, bytes32 r, bytes32 s) public depositPhase {
192     require(verifySignature(msg.sender, allowedMax, v, r, s));
193     if (addDeposit(msg.sender, value, numHolders, allowedMax))
194       numHolders = safeAdd(numHolders, 1);
195     totalStakes = safeSub(safeAdd(totalStakes, value), depositGasCost);
196   }
197 
198   /**
199    * Allows an authorized casino wallet to assign some tokens held by the lending contract to the given addresses.
200    * Only allows to assign token which do not already belong to any other user.
201    * Caller needs to make sure that the number of assignments can be processed in a single batch!
202    * @param to array containing the addresses of the holders
203    *        value array containing the number of tokens per address
204    * */
205   function batchAssignment(address[] to, uint[] value) public onlyAuthorized depositPhase {
206     require(to.length == value.length);
207     require(to.length <= maxBatchAssignment);
208     uint newTotalStakes = totalStakes;
209     uint numSH = numHolders;
210     for (uint8 i = 0; i < to.length; i++) {
211       newTotalStakes = safeSub(safeAdd(newTotalStakes, value[i]), depositGasCost);
212       if(addDeposit(to[i], value[i], numSH, 0))
213         numSH = safeAdd(numSH, 1);//save gas costs by increasing a memory variable instead of the storage variable per iteration
214     }
215     numHolders = numSH;
216     //rollback if more tokens have been assigned than the contract possesses
217     assert(newTotalStakes < tokenBalance());
218     totalStakes = newTotalStakes;
219   }
220   
221   /**
222    * updates the stake of an address.
223    * @param to the address
224    *        value the value to add to the stake
225    *        numSH the number of stakeholders
226    *        allowedMax the maximum amount a user may stake (0 in case the casino is making the assignment)
227    * */
228   function addDeposit(address to, uint value, uint numSH, uint allowedMax) internal returns (bool newHolder) {
229     require(value > 0);
230     uint newStake = safeSub(safeAdd(stakes[to], value), depositGasCost);
231     require(newStake >= minStakingAmount);
232     if(allowedMax > 0){//if allowedMax > 0 the caller is the user himself
233       require(newStake <= allowedMax);
234       assert(token.transferFrom(to, address(this), value));
235     }
236     if(stakes[to] == 0){
237       addHolder(to, numSH);
238       newHolder = true;
239     }
240     stakes[to] = newStake;
241     emit StakeUpdate(to, newStake);
242   }
243 
244   /**
245    * Transfers the total stakes to the casino contract to be used as bankroll.
246    * Callabe only once per cycle and only after a cycle was started.
247    * */
248   function useAsBankroll() public onlyAuthorized depositPhase {
249     initialStakes[cycle] = totalStakes;
250     totalStakes = 0; //withdrawals are unlocked until this value is > 0 again and the final stakes have been set
251     assert(token.transfer(address(casino), initialStakes[cycle]));
252   }
253 
254   /**
255    * Initiates the next cycle. Callabe only once per cycle and only after the last one was closed.
256    * */
257   function startNextCycle() public onlyAuthorized {
258     // make sure the last cycle was closed, can be called in update or withdraw phase
259     require(finalStakes[cycle] > 0);
260     cycle = safeAdd(cycle, 1);
261   }
262 
263   /**
264    * Sets the final sum of user stakes for history and profit computation. Callable only once per cycle.
265    * The token balance of the contract may not be set as final stake, because there might have occurred unapproved deposits.
266    * @param value the number of EDG tokens that were transfered from the bankroll
267    * */
268   function closeCycle(uint value) public onlyAuthorized bankrollPhase {
269     require(tokenBalance() >= value);
270     finalStakes[cycle] = safeSub(value, safeMul(updateGasCost, numHolders)/100);//updateGasCost is using 2 decimals
271   }
272 
273   /**
274    * Updates the user shares depending on the difference between final and initial stake.
275    * For doing so, it iterates over the array of stakeholders, while it processes max 500 addresses at once.
276    * If the array length is bigger than that, the contract remembers the position to start with on the next invocation.
277    * Therefore, this method might need to be called multiple times.
278    * It does consider the gas costs and subtracts them from the final stakes before computing the profit/loss.
279    * As soon as the last stake has been updated, withdrawals are unlocked by setting the totalStakes to the height of final stakes of the cycle.
280    * */
281   function updateUserShares() public onlyAuthorized updatePhase {
282     uint limit = safeAdd(lastUpdateIndex[cycle], maxUpdates);
283     if(limit >= numHolders) {
284       limit = numHolders;
285       totalStakes = finalStakes[cycle]; //enable withdrawals after this method call was processed
286       if (cycle > 1) {
287         lastUpdateIndex[cycle - 1] = 0;
288       }
289     }
290     address holder;
291     uint newStake;
292     for(uint i = lastUpdateIndex[cycle]; i < limit; i++){
293       holder = stakeholders[i];
294       newStake = computeFinalStake(stakes[holder]);
295       stakes[holder] = newStake;
296       emit StakeUpdate(holder, newStake);
297     }
298     lastUpdateIndex[cycle] = limit;
299   }
300 
301   /**
302   * In case something goes wrong above, enable the users to withdraw their tokens.
303   * Should never be necessary.
304   * @param value the number of tokens to release
305   **/
306   function unlockWithdrawals(uint value) public onlyOwner {
307     require(value <= tokenBalance());
308     totalStakes = value;
309   }
310 
311   /**
312    * If withdrawals are unlocked (final stakes of the cycle > 0 and totalStakes > 0), this function withdraws tokens from the sender’s balance to
313    * the specified address. If no balance remains, the user is removed from the stakeholder array.
314 
315    * */
316 
317   function withdraw(uint amt) 
318   public {
319     require(msg.sender == cards);
320     require(amt <= address(this).balance);
321     msg.sender.transfer(amt);
322   }
323 
324   /**
325    * An authorized casino wallet may use this function to make a withdrawal for the user.
326    * The value is subtracted from the signer’s balance and transferred to the specified address.
327    * If no balance remains, the signer is removed from the stakeholder array.
328    * @param to the receiver
329    *        value the number of tokens
330    *        index the index of the signer in the stakeholder array (save gas costs by not looking it up on the contract)
331    *        v, r, s the signature of the stakeholder
332    * */
333 
334   
335   /**
336    * internal method for processing the withdrawal.
337    * @param from the stakeholder
338    *        to the receiver
339    *        value the number of tokens
340    *        index the index of the message sender in the stakeholder array (save gas costs by not looking it up on the contract)
341    * */
342 
343 
344   /**
345    * Allows the casino to withdraw tokens which do not belong to any stakeholder.
346    * This is the case for gas-payback-tokens and if people send their tokens directly to the contract
347    * without the approval of the casino.
348    * */
349 
350 
351   /**
352    * Closes the contract in state of emergency or on contract update.
353    * Transfers all tokens held by the contract to the owner before doing so.
354    **/
355   function kill() public onlyOwner {
356     assert(token.transfer(owner, tokenBalance()));
357     selfdestruct(owner);
358   }
359 
360   /**
361    * @return the current token balance of the contract.
362    * */
363   function tokenBalance() public view returns(uint) {
364     return token.balanceOf(address(this));
365   }
366 
367   /**
368   * Adds a new stakeholder to the list.
369   * @param holder the address of the stakeholder
370   *        numSH  the current number of stakeholders
371   **/
372   function addHolder(address holder, uint numSH) internal{
373     if(numSH < stakeholders.length)
374       stakeholders[numSH] = holder;
375     else
376       stakeholders.push(holder);
377   }
378   
379   /**
380   * Removes a stakeholder from the list.
381   * @param holder the address of the stakeholder
382   *        index  the index of the holder
383   **/
384   function removeHolder(address holder, uint index) internal{
385     require(stakeholders[index] == holder);
386     numHolders = safeSub(numHolders, 1);
387     stakeholders[index] = stakeholders[numHolders];
388   }
389 
390   /**
391    * computes the final stake.
392    * @param initialStake the initial number of tokens the user invested
393    * @return finalStake  the final number of tokens the user receives
394    * */
395   function computeFinalStake(uint initialStake) internal view returns(uint) {
396     return safeMul(initialStake, finalStakes[cycle]) / initialStakes[cycle];
397   }
398 
399   /**
400    * verifies if the withdrawal request was signed by an authorized wallet
401    * @param to      the receiver address
402    *        value   the number of tokens
403    *        v, r, s the signature of an authorized wallet
404    * */
405   function verifySignature(address to, uint value, uint8 v, bytes32 r, bytes32 s) internal view returns(bool) {
406     address signer = ecrecover(keccak256(to, value, cycle), v, r, s);
407     return casino.authorized(signer);
408   }
409 
410   /**
411    * computes state based on the initial, total and final stakes of the current cycle.
412    * @return current state phase
413    * */
414   function getPhase() internal view returns (StatePhases) {
415     if (initialStakes[cycle] == 0) {
416       return StatePhases.deposit;
417     } else if (finalStakes[cycle] == 0) {
418       return StatePhases.bankroll;
419     } else if (totalStakes == 0) {
420       return StatePhases.update;
421     }
422     return StatePhases.withdraw;
423   }
424   
425   //check if the sender is an authorized casino wallet
426   modifier onlyAuthorized {
427     require(casino.authorized(msg.sender));
428     _;
429   }
430 
431   // deposit phase: initialStakes[cycle] == 0
432   modifier depositPhase {
433     require(getPhase() == StatePhases.deposit);
434     _;
435   }
436 
437   // bankroll phase: initialStakes[cycle] > 0 and finalStakes[cycle] == 0
438   modifier bankrollPhase {
439     require(getPhase() == StatePhases.bankroll);
440     _;
441   }
442 
443   // update phase: finalStakes[cycle] > 0 and totalStakes == 0
444   modifier updatePhase {
445     require(getPhase() == StatePhases.update);
446     _;
447   }
448 
449   // withdraw phase: finalStakes[cycle] > 0 and totalStakes > 0
450   modifier withdrawPhase {
451     require(getPhase() == StatePhases.withdraw);
452     _;
453   }
454 
455 }