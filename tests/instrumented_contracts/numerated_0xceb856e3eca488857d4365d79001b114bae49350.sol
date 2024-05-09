1 /**
2  * Do not send tokens to this contract directly!
3  * 
4  * Allows EDG token holders to lend the Edgeless Casino tokens for the bankroll.
5  * Users may pay in their tokens at any time, but they will only be used for the bankroll
6  * begining from the next cycle. When the cycle is closed, they may
7  * withdraw their stake of the bankroll. The casino may decide to limit the number of tokens
8  * used for the bankroll.
9  * Non-withdrawn tokens after cycle is finished is not automaticaly staked for the next round,
10  * but they can be withdrawn by staker in any time.
11  * author: Rytis Grincevicius <rytis@edgeless.io>
12  * */
13 
14 pragma solidity ^0.5.10;
15 
16 contract Token {
17   function transfer(address receiver, uint amount) public returns(bool);
18   function transferFrom(address sender, address receiver, uint amount) public returns(bool);
19   function balanceOf(address holder) public view returns(uint);
20 }
21 
22 contract Casino {
23   mapping(address => bool) public authorized;
24 }
25 
26 contract Owned {
27   address public owner;
28   modifier onlyOwner {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   constructor() public {
34     owner = msg.sender;
35   }
36 
37   function changeOwner(address newOwner) onlyOwner public {
38     owner = newOwner;
39   }
40 }
41 
42 contract SafeMath {
43 
44 	function safeSub(uint a, uint b) pure internal returns(uint) {
45 		assert(b <= a);
46 		return a - b;
47 	}
48 
49 	function safeAdd(uint a, uint b) pure internal returns(uint) {
50 		uint c = a + b;
51 		assert(c >= a && c >= b);
52 		return c;
53 	}
54 
55 	function safeMul(uint a, uint b) pure internal returns (uint) {
56     uint c = a * b;
57     assert(a == 0 || c / a == b);
58     return c;
59   }
60 }
61 
62 contract BankrollLending is Owned, SafeMath {
63   struct CycleData {
64       /** How musch stakers we got in this cycle */
65       uint numHolders;
66       /** Total staked amount */
67       uint initialStakes;
68       /** Amount received from bankroll (staked + 40% of bankroll surpluss) */
69       uint finalStakes;
70       /** Amount distributed to stakers for withdrawals. It decreases when user withdraws. */
71       uint totalStakes;
72       /** Last staker wallet index that had his share distributed */
73       uint lastUpdateIndex;
74       /** Amount of balance to return to bankroll. (If all stakers are ranked VIP then this amount should be 0) */
75       uint returnToBankroll;
76       /** Allows withdrawals when set to true */
77       bool sharesDistributed;
78       /** Stakers address to Staker struct */
79       mapping(address => Staker) addressToStaker;
80       /** staker address to available staker balance */
81       mapping(address => uint) addressToBalance;
82       /** Index to staker address */
83       address[] indexToAddress;
84   }
85   struct Staker {
86     /** Index of staker */
87     uint stakeIndex;
88     /** Staker rank */
89     StakingRank rank;
90     /** How much staked for this stake round */
91     uint staked;
92     /** How much staker payout was for stake round */
93     uint payout;
94   }
95   /** The set of lending contracts state phases **/
96   enum StakingPhases { deposit, bankroll }
97   /** The set of staking ranks **/
98   enum StakingRank { vip, gold, silver }
99   /** The number of the current cycle. Increases by 1 each round.**/
100   uint public cycle;
101   /** Cycle data */
102   mapping(uint => CycleData) public cycleToData;
103   /** Phase of current round */
104   StakingPhases public phase; 
105   /** The address of the casino contract.**/
106   Casino public casino;
107   /** The Edgeless casino token contract **/
108   Token public token;
109   /** Previuos staking contract **/
110   address public predecessor;
111   /** Wallet to return bankroll surplus share of stakers who doesnt get all 100% */
112   address public returnBankrollTo;
113   /** The minimum staking amount required **/
114   uint public minStakingAmount;
115   /** The maximum number of addresses to process in one batch of stake updates **/
116   uint public maxUpdates; 
117   /** Marks contract as paused. */
118   bool public paused;
119   /** Share of vip rank */
120   uint vipRankShare;
121   /** Share of gold rank */
122   uint goldRankShare;
123   /** Share of silver rank */
124   uint silverRankShare;
125   
126   /** notifies listeners about a stake update **/
127   event StakeUpdate(address holder, uint stake);
128 
129   /**
130    * Constructor.
131    * @param tokenAddr the address of the edgeless token contract
132    *        casinoAddr the address of the edgeless casino contract
133    *        predecessorAdr the address of the previous bankroll lending contract.
134    * */
135   constructor(address tokenAddr, address casinoAddr, address predecessorAdr) public {
136     token = Token(tokenAddr);
137     casino = Casino(casinoAddr);
138     predecessor = predecessorAdr;
139     returnBankrollTo = casinoAddr;
140     maxUpdates = 200;
141     cycle = 10;
142     
143     vipRankShare = 1000;
144     goldRankShare = 500;
145     silverRankShare = 125;
146   }
147   
148   /**
149    * Changes share of specified ranks that would be assigned from bankroll surpluss.
150    * @param _rank   staking rank (0 - vip, 1 - gold, 2 - silver)
151    * @param _share  share 0 - 1000, 1000 is 100%.
152    */
153   function setStakingRankShare(StakingRank _rank, uint _share) public onlyOwner {
154     if (_rank == StakingRank.vip) {
155         vipRankShare = _share;
156     } else if (_rank == StakingRank.gold) {
157         goldRankShare = _share;
158     } else if (_rank == StakingRank.silver) {
159         silverRankShare = _share;
160     }
161   }
162   
163   /**
164    * Get share of staking rank.
165    * @param _rank staking rank  (0 - vip, 1 - gold, 2 - silver)
166    * @return share 0 - 1000, 1000 is 100%
167    */
168   function getStakingRankShare(StakingRank _rank) public view returns (uint) {
169    if (_rank == StakingRank.vip) {
170        return vipRankShare;
171     } else if (_rank == StakingRank.gold) {
172        return goldRankShare;
173     } else if (_rank == StakingRank.silver) {
174        return silverRankShare;
175     }
176     return 0;
177   }
178   
179   /**
180    * Allows authorized wallet to change stakers VIP ranking for current round.
181    * @param _address stakers wallet address
182    * @param _rank new vip rank of staker. (0 - vip, 1 - gold, 2 - silver)
183    */
184   function setStakerRank(address _address, StakingRank _rank) public onlyAuthorized {
185       Staker storage _staker = cycleToData[cycle].addressToStaker[_address];
186       require(_staker.staked > 0, "Staker not staked.");
187       _staker.rank = _rank;
188   }
189   
190   /**
191    * Allows owner to change returnBankrollTo address
192    * @param _address address to send tokens to
193    */
194   function setReturnBankrollTo(address _address) public onlyOwner {
195       returnBankrollTo = _address;
196   }
197   
198   /**
199    * Pause contract so it would not allow to make new deposits.
200    */
201   function setPaused() public onlyOwner onlyActive {
202       paused = true;
203   }
204   
205   /**
206    * Enable deposits.
207    */ 
208   function setActive() public onlyOwner onlyPaused {
209       paused = false;
210   }
211   
212   /**
213    * Allows staker to withdraw staked amount + bankroll share of previous round.
214    * @param _receiver address withdraw tokens to
215    */
216   function withdraw(address _receiver) public {
217       makeWithdrawal(msg.sender, _receiver, safeSub(cycle, 1));
218   }
219   
220   /**
221    * Allows staker to withdraw staked amount + bankroll share of previous round.
222    * @param _cycle cycle index from which to withdraw.
223    * @param _receiver address withdraw tokens to
224    */
225   function withdraw(address _receiver, uint _cycle) public {
226       makeWithdrawal(msg.sender, _receiver, _cycle);
227   }
228   
229   /**
230    * Allow authorized wallet to withdraw stakers balance back to stakers wallet.
231    * @param _address    staker address
232    * @param _cycle      cycle index from which to withdraw.
233    */
234   function withdrawFor(address _address, uint _cycle) public onlyAuthorized {
235       makeWithdrawal(_address, _address, _cycle);
236   }
237   
238   /**
239    * Send collected stakes to casino contract and advance staking to bankroll phase.
240    */
241   function useAsBankroll() public onlyAuthorized depositPhase {
242       CycleData storage _cycle = cycleToData[cycle];
243       _cycle.initialStakes = _cycle.totalStakes;
244       _cycle.totalStakes = 0;
245       assert(token.transfer(address(casino), _cycle.initialStakes));
246       phase = StakingPhases.bankroll;
247   }
248   
249   /**
250    * Closes staking round with amount to distribute and creates new round with deposit phase.
251    * @param _finalStakes    Token amount (0 decimals) of amount to be distributed for stakers. (Staked amount + 40% casino surpluss)
252    */
253   function closeCycle(uint _finalStakes) public onlyAuthorized bankrollPhase {
254       CycleData storage _cycle = cycleToData[cycle];
255       _cycle.finalStakes = _finalStakes;
256       cycle = safeAdd(cycle, 1);
257       phase = StakingPhases.deposit;
258   }
259   
260   /**
261    * Distributes user shares for previous round.
262    */
263   function updateUserShares() public onlyAuthorized {
264       _updateUserShares(cycle - 1);
265   }
266 
267   /**
268    * Distributes user shares for selected finished round.
269    * @param _cycleIndex Index of cycle to update shares.
270    */
271   function updateUserShares(uint _cycleIndex) public onlyAuthorized {
272       _updateUserShares(_cycleIndex);
273   }
274   
275   /**
276    * Allows to deposit tokens to staking. Wallet must approve staking contract to transfer its tokens.
277    * Transfaction must be signed by authorized wallet to confirm rank and allowance.
278    */
279   function deposit(uint _value, StakingRank _rank, uint _allowedMax, uint8 v, bytes32 r, bytes32 s) public depositPhase onlyActive {
280       require(verifySignature(msg.sender, _allowedMax, _rank, v, r, s));
281       makeDeposit(msg.sender, _value, _rank, _allowedMax);
282   }
283   
284   /**
285    * Allow authorized wallet to deposit on wallet behalft. Wallet must approve staking contract to transfer its tokens.
286    */
287   function depositFor(address _address, uint _value, StakingRank _rank, uint _allowedMax) public depositPhase onlyActive onlyAuthorized {
288       makeDeposit(_address, _value, _rank, _allowedMax);
289   }
290   
291   /**
292    * Holders of current staking round.
293    */
294   function numHolders() public view returns (uint) {
295       return cycleToData[cycle].numHolders;
296   }
297   
298   /**
299    * Get holder address by index.
300    * @param _index staker index in array.
301    */ 
302   function stakeholders(uint _index) public view returns (address) {
303       return stakeholders(cycle, _index);
304   }
305   
306   /**
307    * Get holder balance by address.
308    * @param _address staker address.
309    */ 
310   function stakes(address _address) public view returns (uint) {
311       return stakes(cycle, _address);
312   }
313   
314   /**
315    * Get holder information by address.
316    * @param _address staker address.
317    */ 
318   function staker(address _address) public view returns (uint stakeIndex, StakingRank rank, uint staked, uint payout) {
319       return staker(cycle, _address);
320   }
321   
322   /**
323    * Returns token amount staked to contract
324    */
325   function totalStakes() public view returns (uint) {
326       return totalStakes(cycle);
327   }
328   
329   /**
330    * Returns token amount of initial stakes
331    */
332   function initialStakes() public view returns (uint) {
333       return initialStakes(cycle);
334   }
335   
336    /**
337    * Get holder address by cycle and index.
338    * @param _cycle cycle to look
339    * @param _index staker index in array.
340    */ 
341   function stakeholders(uint _cycle, uint _index) public view returns (address) {
342       return cycleToData[_cycle].indexToAddress[_index];
343   }
344   
345   /**
346    * Returns available EDG balance of staker.
347    * @param _cycle cycle index to look
348    * @param _address staker address
349    */
350   function stakes(uint _cycle, address _address) public view returns (uint) {
351       return cycleToData[_cycle].addressToBalance[_address];
352   }
353 
354   /**
355    * Returns info about staker in round. 
356    * @param _cycle cycle index to look
357    * @param _address staker address
358    */
359   function staker(uint _cycle, address _address) public view returns (uint stakeIndex, StakingRank rank, uint staked, uint payout ) {
360       Staker memory _s = cycleToData[_cycle].addressToStaker[_address];
361       return (_s.stakeIndex, _s.rank, _s.staked, _s.payout);
362   }
363   
364   /**
365    * Returns token amount staked to contract
366    * @param _cycle cycle index to look
367    */
368   function totalStakes(uint _cycle) public view returns (uint) {
369       return cycleToData[_cycle].totalStakes;
370   }
371   
372   /**
373    * Returns token amount of initial stakes
374    * @param _cycle cycle index to look
375    */
376   function initialStakes(uint _cycle) public view returns (uint) {
377       return cycleToData[_cycle].initialStakes;
378   }
379   
380   /**
381    * Returns token amount of final stakes
382    * @param _cycle cycle index to look
383    */
384   function finalStakes(uint _cycle) public view returns (uint) {
385       return cycleToData[_cycle].finalStakes;
386   }
387 
388   /**
389    * Sets the casino contract address.
390    * @param casinoAddr the new casino contract address
391    * */
392   function setCasinoAddress(address casinoAddr) public onlyOwner {
393     casino = Casino(casinoAddr);
394   }
395   
396   /**
397    * Sets the maximum number of user stakes to update at once
398    * @param newMax the new maximum
399    * */
400   function setMaxUpdates(uint newMax) public onlyAuthorized {
401     maxUpdates = newMax;
402   }
403   
404   /**
405    * Sets the minimum amount of user stakes
406    * @param amount the new minimum
407    * */
408   function setMinStakingAmount(uint amount) public onlyAuthorized {
409     minStakingAmount = amount;
410   }
411 
412   /**
413   * Closes the contract in state of emergency or on contract update.
414   * Transfers all tokens held by the contract to the owner before doing so.
415   **/
416   function kill() public onlyOwner {
417     assert(token.transfer(owner, tokenBalance()));
418     selfdestruct(address(uint160(owner)));
419   }
420 
421   /**
422   * @return the current token balance of the contract.
423   * */
424   function tokenBalance() public view returns(uint) {
425     return token.balanceOf(address(this));
426   }
427   
428   /**
429    * Withdrawal logic. Withdraws all balance from stakers staking contract and transfers to his deposit wallet.
430    * @param _address    staker address for which to withdraw
431    * @param _receiver   address withdraw to.
432    * @param _cycle      cycle index from which to withdraw.
433    */
434   function makeWithdrawal(address _address, address _receiver, uint _cycle) internal {
435       require(_cycle < cycle, "Withdrawal possible only for finished rounds.");
436       CycleData storage _cycleData = cycleToData[_cycle];
437       require(_cycleData.sharesDistributed == true, "All user shares must be distributed to stakeholders first.");
438       uint _balance = _cycleData.addressToBalance[_address];
439       require(_balance > 0, "Staker doesn't have balance.");
440       _cycleData.addressToBalance[_address] = 0;
441       _cycleData.totalStakes = safeSub(_cycleData.totalStakes, _balance);
442       emit StakeUpdate(_address, 0);
443       assert(token.transfer(_receiver, _balance));
444   }
445   
446   
447   /**
448    * Calculates and distributes shares for stakers.
449    * When all staker shares distributed it sets cycleToData[cycle].sharesDistributed to true and unlocks withdrawals.
450    * @param _cycleIndex round index for which calculations should be made.
451    */
452   function _updateUserShares(uint _cycleIndex) internal {
453       require(cycle > 0 && cycle > _cycleIndex, "You can't distribute shares of previous cycle when there isn't any.");
454       CycleData storage _cycle = cycleToData[_cycleIndex];
455       require(_cycle.sharesDistributed == false, "Shares already distributed.");
456       uint limit = safeAdd(_cycle.lastUpdateIndex, maxUpdates);
457       if (limit >= _cycle.numHolders) {
458           limit = _cycle.numHolders;
459       }
460       address _address;
461       uint _payout;
462       uint _totalStakes = _cycle.totalStakes;
463       for (uint i = _cycle.lastUpdateIndex; i < limit; i++) {
464           _address = _cycle.indexToAddress[i];
465           Staker storage _staker = _cycle.addressToStaker[_address];
466           _payout = computeFinalStake(_staker.staked, _staker.rank, _cycle);
467           _staker.payout = _payout;
468           _cycle.addressToBalance[_address] = _payout;
469           _totalStakes = safeAdd(_totalStakes, _payout);
470           emit StakeUpdate(_address, _payout);
471       }
472       _cycle.totalStakes = _totalStakes;
473       _cycle.lastUpdateIndex = limit;
474       if (limit >= _cycle.numHolders) {
475           if (_cycle.finalStakes > _cycle.totalStakes) {
476             _cycle.returnToBankroll = safeSub(_cycle.finalStakes, _cycle.totalStakes);
477             if (_cycle.returnToBankroll > 0) {
478                 assert(token.transfer(returnBankrollTo, _cycle.returnToBankroll));
479             }
480           }
481           _cycle.sharesDistributed = true;
482       }
483   }
484   
485    /**
486     * Calculates stakers profit / loss.
487     * @param _initialStake how much holder initialy staked for the round
488     * @param _vipRank vip rank of the holder
489     * @param _cycleData data of the cycle
490     */
491    function computeFinalStake(uint _initialStake, StakingRank _vipRank, CycleData storage _cycleData) internal view returns(uint) {
492        if (_cycleData.finalStakes >= _cycleData.initialStakes) {
493         uint profit = ((_initialStake * _cycleData.finalStakes / _cycleData.initialStakes) - _initialStake) * getStakingRankShare(_vipRank) / 1000;
494         return _initialStake + profit;
495       } else {
496         uint loss = (_initialStake - (_initialStake * _cycleData.finalStakes / _cycleData.initialStakes));
497         return _initialStake - loss;
498       }
499     }
500     
501    /**
502     * Deposit logic.
503     * @param _address holder address
504     * @param _value how much to deposit
505     * @param _rank vip rank to set for holder
506     * @param _allowedMax what is maximum total deposit for the holder
507     */
508    function makeDeposit(address _address, uint _value, StakingRank _rank, uint _allowedMax) internal {
509        require(_value > 0);
510        CycleData storage _cycle = cycleToData[cycle];
511        uint _balance = _cycle.addressToBalance[_address];
512        uint newStake = safeAdd(_balance, _value);
513        require(newStake >= minStakingAmount);
514        if(_allowedMax > 0){ //if allowedMax > 0 the caller is the user himself
515            require(newStake <= _allowedMax);
516            assert(token.transferFrom(_address, address(this), _value));
517        }
518        Staker storage _staker = _cycle.addressToStaker[_address];
519        
520        if (_cycle.addressToBalance[_address] == 0) {
521            uint _numHolders = _cycle.indexToAddress.push(_address);
522            _cycle.numHolders = _numHolders;
523            _staker.stakeIndex = safeSub(_numHolders, 1);
524        }
525        
526        _cycle.addressToBalance[_address] = newStake;
527        _staker.staked = newStake;
528        _staker.rank = _rank;
529        
530        _cycle.totalStakes = safeAdd(_cycle.totalStakes, _value);
531        
532        emit StakeUpdate(_address, newStake);
533    }
534 
535   /**
536    * verifies if the withdrawal request was signed by an authorized wallet
537    * @param to      the receiver address
538    *        value   the number of tokens
539    *        rank    the vip rank
540    *        v, r, s the signature of an authorized wallet
541    * */
542   function verifySignature(address to, uint value, StakingRank rank, uint8 v, bytes32 r, bytes32 s) internal view returns(bool) {
543     address signer = ecrecover(keccak256(abi.encodePacked(to, value, rank, cycle)), v, r, s);
544     return casino.authorized(signer);
545   }
546   
547   //check if the sender is an authorized casino wallet
548   modifier onlyAuthorized {
549     require(casino.authorized(msg.sender), "Only authorized wallet can request this method.");
550     _;
551   }
552 
553   modifier depositPhase {
554     require(phase == StakingPhases.deposit, "Method can be run only in deposit phase.");
555     _;
556   }
557 
558   modifier bankrollPhase {
559     require(phase == StakingPhases.bankroll, "Method can be run only in bankroll phase.");
560     _;
561   }
562   
563   modifier onlyActive() {
564     require(paused == false, "Contract is paused.");
565     _;
566   }
567   
568   modifier onlyPaused() {
569     require(paused == true, "Contract is not paused.");
570     _;
571   }
572 
573 }