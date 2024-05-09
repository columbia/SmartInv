1 pragma solidity ^0.4.24;
2 /**
3  * Copyright YHT Community.
4  * This software is copyrighted by the YHT community.
5  * Prohibits any unauthorized copying and modification.
6  * It is allowed through ABI calls.
7  */
8  
9 //==============================================================================
10 // Begin: This part comes from openzeppelin-solidity
11 //        https://github.com/OpenZeppelin/openzeppelin-solidity
12 //============================================================================== 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18 
19   /**
20   * @dev Multiplies two numbers, throws on overflow.
21   */
22   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
23     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
24     // benefit is lost if 'b' is also tested.
25     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
26     if (a == 0) {
27       return 0;
28     }
29 
30     c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     // uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return a / b;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 /**
64  * @title ERC20Basic
65  * @dev Simpler version of ERC20 interface
66  * See https://github.com/ethereum/EIPs/issues/179
67  */
68 contract ERC20Basic {
69   function totalSupply() public view returns (uint256);
70   function balanceOf(address who) public view returns (uint256);
71   function transfer(address to, uint256 value) public returns (bool);
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75 /**
76  * @title ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/20
78  */
79 contract ERC20 is ERC20Basic {
80   function allowance(address owner, address spender) public view returns (uint256);
81   function transferFrom(address from, address to, uint256 value) public returns (bool);
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 /**
87  * @title Basic token
88  * @dev Basic version of StandardToken, with no allowances.
89  */
90 contract BasicToken is ERC20Basic {
91   using SafeMath for uint256;
92 
93   mapping(address => uint256) balances;
94 
95   uint256 totalSupply_;
96 
97   /**
98   * @dev Total number of tokens in existence
99   */
100   function totalSupply() public view returns (uint256) {
101     return totalSupply_;
102   }
103 
104   /**
105   * @dev Transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_value <= balances[msg.sender]);
111     require(_to != address(0));
112 
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     emit Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public view returns (uint256) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 /**
131  * @title Burnable Token
132  * @dev Token that can be irreversibly burned (destroyed).
133  */
134 contract BurnableToken is BasicToken {
135 
136   event Burn(address indexed burner, uint256 value);
137 
138   /**
139    * @dev Burns a specific amount of tokens.
140    * @param _value The amount of token to be burned.
141    */
142   function burn(uint256 _value) public {
143     _burn(msg.sender, _value);
144   }
145 
146   function _burn(address _who, uint256 _value) internal {
147     require(_value <= balances[_who]);
148     // no need to require value <= totalSupply, since that would imply the
149     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
150 
151     balances[_who] = balances[_who].sub(_value);
152     totalSupply_ = totalSupply_.sub(_value);
153     emit Burn(_who, _value);
154     emit Transfer(_who, address(0), _value);
155   }
156 }
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * https://github.com/ethereum/EIPs/issues/20
163  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179     require(_to != address(0));
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     emit Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     emit Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
223     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    * approve should be called when allowed[_spender] == 0. To decrement
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _subtractedValue The amount of tokens to decrease the allowance by.
236    */
237   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
238     uint256 oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue >= oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 }
248 
249 
250 /**
251  * @title Standard Burnable Token
252  * @dev Adds burnFrom method to ERC20 implementations
253  */
254 contract StandardBurnableToken is BurnableToken, StandardToken {
255 
256   /**
257    * @dev Burns a specific amount of tokens from the target address and decrements allowance
258    * @param _from address The address which you want to send tokens from
259    * @param _value uint256 The amount of token to be burned
260    */
261   function burnFrom(address _from, uint256 _value) public {
262     require(_value <= allowed[_from][msg.sender]);
263     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
264     // this function needs to emit an event with the updated approval.
265     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
266     _burn(_from, _value);
267   }
268 }
269 
270 /**
271  * @title Ownable
272  * @dev The Ownable contract has an owner address, and provides basic authorization control
273  * functions, this simplifies the implementation of "user permissions".
274  */
275 contract Ownable {
276   address public owner;
277 
278   event OwnershipRenounced(address indexed previousOwner);
279   event OwnershipTransferred(
280     address indexed previousOwner,
281     address indexed newOwner
282   );
283 
284 
285   /**
286    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
287    * account.
288    */
289   constructor() public {
290     owner = msg.sender;
291   }
292 
293   /**
294    * @dev Throws if called by any account other than the owner.
295    */
296   modifier onlyOwner() {
297     require(msg.sender == owner);
298     _;
299   }
300 
301   /**
302    * @dev Allows the current owner to relinquish control of the contract.
303    * @notice Renouncing to ownership will leave the contract without an owner.
304    * It will not be possible to call the functions with the `onlyOwner`
305    * modifier anymore.
306    */
307   function renounceOwnership() public onlyOwner {
308     emit OwnershipRenounced(owner);
309     owner = address(0);
310   }
311 
312   /**
313    * @dev Allows the current owner to transfer control of the contract to a newOwner.
314    * @param _newOwner The address to transfer ownership to.
315    */
316   function transferOwnership(address _newOwner) public onlyOwner {
317     _transferOwnership(_newOwner);
318   }
319 
320   /**
321    * @dev Transfers control of the contract to a newOwner.
322    * @param _newOwner The address to transfer ownership to.
323    */
324   function _transferOwnership(address _newOwner) internal {
325     require(_newOwner != address(0));
326     emit OwnershipTransferred(owner, _newOwner);
327     owner = _newOwner;
328   }
329 }
330 //==============================================================================
331 // End: This part comes from openzeppelin-solidity
332 //============================================================================== 
333 
334 
335 /**
336  * @dev Lottery Interface  
337  */ 
338 contract LotteryInterface {
339   function checkLastMintData(address addr) external;   
340   function getLastMintAmount(address addr) view external returns(uint256, uint256);
341   function getReferrerEarnings(address addr) view external returns(uint256);
342   function checkReferrerEarnings(address addr) external;
343   function deposit() public payable;
344 }
345 
346 /**
347  * @title YHT Token
348  * @dev The initial total is zero, which can only be produced by mining, halved production per 314 cycles.
349  * After call startMinting function, no one can pause it.
350  * All the people who hold it will enjoy the dividends.
351  * See the YHT whitepaper to get more information.
352  * https://github.com/ethergame/whitepaper
353  */
354 contract YHToken is StandardBurnableToken, Ownable {
355   string public constant name = "YHToken";
356   string public constant symbol = "YHT";
357   uint8 public constant decimals = 18;
358   
359   uint256 constant private kAutoCombineBonusesCount = 50;           // if the last two balance snapshot records are not far apart, they will be merged automatically.
360   
361   struct Bonus {                                                                    
362     uint256 payment;                                                // payment of dividends
363     uint256 currentTotalSupply;                                     // total supply at the payment time point  
364   }
365   
366   struct BalanceSnapshot {
367     uint256 balance;                                                // balance of snapshot     
368     uint256 bonusIdBegin;                                           // begin of bonusId
369     uint256 bonusIdEnd;                                             // end of bonusId
370   }
371   
372   struct User {
373     uint256 extraEarnings;                                              
374     uint256 bonusEarnings;
375     BalanceSnapshot[] snapshots;                                    // the balance snapshot array
376     uint256 snapshotsLength;                                        // the length of balance snapshot array    
377   }
378   
379   LotteryInterface public Lottery;
380   uint256 public bonusRoundId_;                                     // next bonus id
381   mapping(address => User) public users_;                           // user informations
382   mapping(uint256 => Bonus) public bonuses_;                        // the records of all bonuses
383     
384   event Started(address lottery);
385   event AddTotalSupply(uint256 addValue, uint256 total);
386   event AddExtraEarnings(address indexed from, address indexed to, uint256 amount);
387   event AddBonusEarnings(address indexed from, uint256 amount, uint256 bonusId, uint256 currentTotalSupply);
388   event Withdraw(address indexed addr, uint256 amount);
389 
390   constructor() public {
391     totalSupply_ = 0;      //initial is 0
392     bonusRoundId_ = 1;
393   }
394 
395   /**
396    * @dev only the lottery contract can transfer earnings
397    */
398   modifier isLottery() {
399     require(msg.sender == address(Lottery)); 
400     _;
401   }
402   
403   /**
404    * @dev Function to start. just start once.
405    */
406   function start(address lottery) onlyOwner public {
407     require(Lottery == address(0));
408     Lottery = LotteryInterface(lottery);
409     emit Started(lottery);
410   }
411   
412   /**
413    * @dev record a snapshot of balance
414    * with the bonuses information can accurately calculate the earnings 
415    */ 
416   function balanceSnapshot(address addr, uint256 bonusRoundId) private {
417     uint256 currentBalance = balances[addr];     
418     User storage user = users_[addr];   
419     if (user.snapshotsLength == 0) {
420       user.snapshotsLength = 1;
421       user.snapshots.push(BalanceSnapshot(currentBalance, bonusRoundId, 0));
422     }
423     else {
424       BalanceSnapshot storage lastSnapshot = user.snapshots[user.snapshotsLength - 1];
425       assert(lastSnapshot.bonusIdEnd == 0);
426       
427       // same as last record point just updated balance
428       if (lastSnapshot.bonusIdBegin == bonusRoundId) {
429         lastSnapshot.balance = currentBalance;      
430       }
431       else {
432         assert(lastSnapshot.bonusIdBegin < bonusRoundId);
433         
434         // if this snapshot is not the same as the last time, automatically merges part of the earnings
435         if (bonusRoundId - lastSnapshot.bonusIdBegin < kAutoCombineBonusesCount) {
436            uint256 amount = computeRoundBonuses(lastSnapshot.bonusIdBegin, bonusRoundId, lastSnapshot.balance);
437            user.bonusEarnings = user.bonusEarnings.add(amount);
438            
439            lastSnapshot.balance = currentBalance;
440            lastSnapshot.bonusIdBegin = bonusRoundId;
441            lastSnapshot.bonusIdEnd = 0;
442         }
443         else {
444           lastSnapshot.bonusIdEnd = bonusRoundId;     
445           
446           /* 
447           reuse this array to store data, based on code from
448           https://ethereum.stackexchange.com/questions/3373/how-to-clear-large-arrays-without-blowing-the-gas-limit?answertab=votes#tab-top
449           */
450           if (user.snapshotsLength == user.snapshots.length) {
451             user.snapshots.length += 1;  
452           } 
453           user.snapshots[user.snapshotsLength++] = BalanceSnapshot(currentBalance, bonusRoundId, 0);
454         }
455       }
456     }
457   }
458   
459   /**
460    * @dev mint to add balance then do snapshot
461    */ 
462   function mint(address to, uint256 amount, uint256 bonusRoundId) private {
463     balances[to] = balances[to].add(amount);
464     emit Transfer(address(0), to, amount); 
465     balanceSnapshot(to, bonusRoundId);  
466   }
467   
468   /**
469    * @dev add total supply and mint extra to founder team
470    */  
471   function mintToFounder(address to, uint256 amount, uint256 normalAmount) isLottery external {
472     checkLastMint(to);
473     uint256 value = normalAmount.add(amount);
474     totalSupply_ = totalSupply_.add(value);
475     emit AddTotalSupply(value, totalSupply_);
476     mint(to, amount, bonusRoundId_);
477   }
478   
479   /**
480    * @dev mint tokens for player
481    */ 
482   function mintToNormal(address to, uint256 amount, uint256 bonusRoundId) isLottery external {
483     require(bonusRoundId < bonusRoundId_);
484     mint(to, amount, bonusRoundId);
485   }
486   
487   /**
488    * @dev check player last mint status, mint for player if necessary
489    */ 
490   function checkLastMint(address addr) private {
491     Lottery.checkLastMintData(addr);  
492   }
493 
494   function balanceSnapshot(address addr) private {
495     balanceSnapshot(addr, bonusRoundId_);  
496   }
497 
498   /**
499    * @dev get balance snapshot
500    */ 
501   function getBalanceSnapshot(address addr, uint256 index) view public returns(uint256, uint256, uint256) {
502     BalanceSnapshot storage snapshot = users_[addr].snapshots[index];
503     return (
504       snapshot.bonusIdBegin,
505       snapshot.bonusIdEnd,
506       snapshot.balance
507     );
508   }
509 
510   /**
511   * @dev Transfer token for a specified address
512   * @param _to The address to transfer to.
513   * @param _value The amount to be transferred.
514   */
515   function transfer(address _to, uint256 _value) public returns (bool) {
516     checkLastMint(msg.sender);
517     checkLastMint(_to);
518     super.transfer(_to, _value);
519     balanceSnapshot(msg.sender);
520     balanceSnapshot(_to);
521     return true;
522   } 
523 
524   /**
525    * @dev Transfer tokens from one address to another
526    * @param _from address The address which you want to send tokens from
527    * @param _to address The address which you want to transfer to
528    * @param _value uint256 the amount of tokens to be transferred
529    */
530   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
531     checkLastMint(_from);
532     checkLastMint(_to);
533     super.transferFrom(_from, _to, _value);
534     balanceSnapshot(_from);
535     balanceSnapshot(_to);
536     return true;
537   }
538   
539   function _burn(address _who, uint256 _value) internal {
540     checkLastMint(_who);  
541     super._burn(_who, _value);  
542     balanceSnapshot(_who);
543   } 
544   
545   /**
546    * @dev clear warnings for unused variables  
547    */ 
548   function unused(uint256) pure private {} 
549   
550  /**
551   * @dev Gets the balance of the specified address.
552   * @param _owner The address to query the the balance of.
553   * @return An uint256 representing the amount owned by the passed address.
554   */
555   function balanceOf(address _owner) public view returns (uint256) {
556     (uint256 lastMintAmount, uint256 lastBonusRoundId) = Lottery.getLastMintAmount(_owner);  
557     unused(lastBonusRoundId);
558     return balances[_owner].add(lastMintAmount);  
559   }
560 
561   /**
562    * @dev Others contract transfer earnings to someone
563    * The lottery contract transfer the big reward to winner
564    * It is open interface, more game contracts may be used in the future
565    */
566   function transferExtraEarnings(address to) external payable {
567     if (msg.sender != address(Lottery)) {
568       require(msg.value > 662607004);
569       require(msg.value < 66740800000000000000000);
570     }  
571     users_[to].extraEarnings = users_[to].extraEarnings.add(msg.value);   
572     emit AddExtraEarnings(msg.sender, to, msg.value);
573   }
574   
575   /**
576    * @dev Others contract transfer bonus earnings to all the people who hold YHT  
577    * It is open interface, more game contracts may be used in the future
578    */
579   function transferBonusEarnings() external payable returns(uint256) {
580     require(msg.value > 0);
581     require(totalSupply_ > 0);
582     if (msg.sender != address(Lottery)) {
583       require(msg.value > 314159265358979323);
584       require(msg.value < 29979245800000000000000);   
585     }
586     
587     uint256 bonusRoundId = bonusRoundId_;
588     bonuses_[bonusRoundId].payment = msg.value;
589     bonuses_[bonusRoundId].currentTotalSupply = totalSupply_;
590     emit AddBonusEarnings(msg.sender, msg.value, bonusRoundId_, totalSupply_);
591     
592     ++bonusRoundId_;
593     return bonusRoundId;
594   }
595 
596   /**
597    * @dev get earings of user, can directly withdraw 
598    */ 
599   function getEarnings(address addr) view public returns(uint256) {
600     User storage user = users_[addr];  
601     uint256 amount;
602     (uint256 lastMintAmount, uint256 lastBonusRoundId) = Lottery.getLastMintAmount(addr);
603     if (lastMintAmount > 0) {
604       amount = computeSnapshotBonuses(user, lastBonusRoundId);
605       amount = amount.add(computeRoundBonuses(lastBonusRoundId, bonusRoundId_, balances[addr].add(lastMintAmount)));
606     } else {
607       amount = computeSnapshotBonuses(user, bonusRoundId_);     
608     }
609     uint256 referrerEarnings = Lottery.getReferrerEarnings(addr);
610     return user.extraEarnings + user.bonusEarnings + amount + referrerEarnings;
611   }
612   
613   /**
614    * @dev get bonuses 
615    * @param begin begin bonusId
616    * @param end end bonusId
617    * @param balance the balance in the round 
618    * Not use SafeMath, it is core loop, not use SafeMath will be saved 20% gas
619    */ 
620   function computeRoundBonuses(uint256 begin, uint256 end, uint256 balance) view private returns(uint256) {
621     require(begin != 0);
622     require(end != 0);  
623     
624     uint256 amount = 0;
625     while (begin < end) {
626       uint256 value = balance * bonuses_[begin].payment / bonuses_[begin].currentTotalSupply;      
627       amount += value;
628       ++begin;    
629     }
630     return amount;
631   }
632   
633   /**
634    * @dev compute snapshot bonuses
635    */ 
636   function computeSnapshotBonuses(User storage user, uint256 lastBonusRoundId) view private returns(uint256) {
637     uint256 amount = 0;
638     uint256 length = user.snapshotsLength;
639     for (uint256 i = 0; i < length; ++i) {
640       uint256 value = computeRoundBonuses(
641         user.snapshots[i].bonusIdBegin,
642         i < length - 1 ? user.snapshots[i].bonusIdEnd : lastBonusRoundId,
643         user.snapshots[i].balance);
644       amount = amount.add(value);
645     }
646     return amount;
647   }
648     
649   /**
650    * @dev add earnings from bonuses
651    */ 
652   function combineBonuses(address addr) private {
653     checkLastMint(addr);
654     User storage user = users_[addr];
655     if (user.snapshotsLength > 0) {
656       uint256 amount = computeSnapshotBonuses(user, bonusRoundId_);
657       if (amount > 0) {
658         user.bonusEarnings = user.bonusEarnings.add(amount);
659         user.snapshotsLength = 1;
660         user.snapshots[0].balance = balances[addr];
661         user.snapshots[0].bonusIdBegin = bonusRoundId_;
662         user.snapshots[0].bonusIdEnd = 0;     
663       }
664     }
665     Lottery.checkReferrerEarnings(addr);
666   }
667   
668   /**
669    * @dev withdraws all of your earnings
670    */
671   function withdraw() public {
672     combineBonuses(msg.sender);
673     uint256 amount = users_[msg.sender].extraEarnings.add(users_[msg.sender].bonusEarnings);
674     if (amount > 0) {
675       users_[msg.sender].extraEarnings = 0;
676       users_[msg.sender].bonusEarnings = 0;
677       msg.sender.transfer(amount);
678     }
679     emit Withdraw(msg.sender, amount);
680   }
681   
682   /**
683    * @dev withdraw immediateness to bet
684    */ 
685   function withdrawForBet(address addr, uint256 value) isLottery external {
686     combineBonuses(addr);
687     uint256 extraEarnings = users_[addr].extraEarnings; 
688     if (extraEarnings >= value) {
689       users_[addr].extraEarnings -= value;    
690     } else {
691       users_[addr].extraEarnings = 0;
692       uint256 remain = value - extraEarnings;
693       require(users_[addr].bonusEarnings >= remain);
694       users_[addr].bonusEarnings -= remain;
695     }
696     Lottery.deposit.value(value)();
697   }
698   
699   /**
700    * @dev get user informations at once
701    */
702   function getUserInfos(address addr) view public returns(uint256, uint256, uint256) {
703     return (
704       totalSupply_,
705       balanceOf(addr),
706       getEarnings(addr)
707     );  
708   }
709 }