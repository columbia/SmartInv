1 pragma solidity ^0.4.24;
2 
3 
4 /** 
5 * MonetaryCoin Distribution 
6 * full source code:
7 * https://github.com/Monetary-Foundation/MonetaryCoin
8 */
9 
10 /**
11  * @title ERC20Basic
12  * @dev Simpler version of ERC20 interface
13  * @dev see https://github.com/ethereum/EIPs/issues/179
14  */
15 contract ERC20Basic {
16   function totalSupply() public view returns (uint256);
17   function balanceOf(address who) public view returns (uint256);
18   function transfer(address to, uint256 value) public returns (bool);
19   event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable {
28   address public owner;
29 
30 
31   event OwnershipRenounced(address indexed previousOwner);
32   event OwnershipTransferred(
33     address indexed previousOwner,
34     address indexed newOwner
35   );
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   constructor() public {
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     emit OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64   /**
65    * @dev Allows the current owner to relinquish control of the contract.
66    */
67   function renounceOwnership() public onlyOwner {
68     emit OwnershipRenounced(owner);
69     owner = address(0);
70   }
71 }
72 
73 
74 
75 
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that throw on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, throws on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     if (a == 0) {
88       return 0;
89     }
90     c = a * b;
91     assert(c / a == b);
92     return c;
93   }
94 
95   /**
96   * @dev Integer division of two numbers, truncating the quotient.
97   */
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     // uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return a / b;
103   }
104 
105   /**
106   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
107   */
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   /**
114   * @dev Adds two numbers, throws on overflow.
115   */
116   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
117     c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 }
122 
123 
124 
125 
126 
127 
128 
129 
130 
131 
132 
133 
134 
135 
136 
137 
138 
139 
140 /**
141  * @title Basic token
142  * @dev Basic version of StandardToken, with no allowances.
143  */
144 contract BasicToken is ERC20Basic {
145   using SafeMath for uint256;
146 
147   mapping(address => uint256) balances;
148 
149   uint256 totalSupply_;
150 
151   /**
152   * @dev total number of tokens in existence
153   */
154   function totalSupply() public view returns (uint256) {
155     return totalSupply_;
156   }
157 
158   /**
159   * @dev transfer token for a specified address
160   * @param _to The address to transfer to.
161   * @param _value The amount to be transferred.
162   */
163   function transfer(address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165     require(_value <= balances[msg.sender]);
166 
167     balances[msg.sender] = balances[msg.sender].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     emit Transfer(msg.sender, _to, _value);
170     return true;
171   }
172 
173   /**
174   * @dev Gets the balance of the specified address.
175   * @param _owner The address to query the the balance of.
176   * @return An uint256 representing the amount owned by the passed address.
177   */
178   function balanceOf(address _owner) public view returns (uint256) {
179     return balances[_owner];
180   }
181 
182 }
183 
184 
185 
186 
187 
188 
189 /**
190  * @title ERC20 interface
191  * @dev see https://github.com/ethereum/EIPs/issues/20
192  */
193 contract ERC20 is ERC20Basic {
194   function allowance(address owner, address spender)
195     public view returns (uint256);
196 
197   function transferFrom(address from, address to, uint256 value)
198     public returns (bool);
199 
200   function approve(address spender, uint256 value) public returns (bool);
201   event Approval(
202     address indexed owner,
203     address indexed spender,
204     uint256 value
205   );
206 }
207 
208 
209 
210 /**
211  * @title Standard ERC20 token
212  *
213  * @dev Implementation of the basic standard token.
214  * @dev https://github.com/ethereum/EIPs/issues/20
215  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
216  */
217 contract StandardToken is ERC20, BasicToken {
218 
219   mapping (address => mapping (address => uint256)) internal allowed;
220 
221 
222   /**
223    * @dev Transfer tokens from one address to another
224    * @param _from address The address which you want to send tokens from
225    * @param _to address The address which you want to transfer to
226    * @param _value uint256 the amount of tokens to be transferred
227    */
228   function transferFrom(
229     address _from,
230     address _to,
231     uint256 _value
232   )
233     public
234     returns (bool)
235   {
236     require(_to != address(0));
237     require(_value <= balances[_from]);
238     require(_value <= allowed[_from][msg.sender]);
239 
240     balances[_from] = balances[_from].sub(_value);
241     balances[_to] = balances[_to].add(_value);
242     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
243     emit Transfer(_from, _to, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249    *
250    * Beware that changing an allowance with this method brings the risk that someone may use both the old
251    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
252    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
253    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254    * @param _spender The address which will spend the funds.
255    * @param _value The amount of tokens to be spent.
256    */
257   function approve(address _spender, uint256 _value) public returns (bool) {
258     allowed[msg.sender][_spender] = _value;
259     emit Approval(msg.sender, _spender, _value);
260     return true;
261   }
262 
263   /**
264    * @dev Function to check the amount of tokens that an owner allowed to a spender.
265    * @param _owner address The address which owns the funds.
266    * @param _spender address The address which will spend the funds.
267    * @return A uint256 specifying the amount of tokens still available for the spender.
268    */
269   function allowance(
270     address _owner,
271     address _spender
272    )
273     public
274     view
275     returns (uint256)
276   {
277     return allowed[_owner][_spender];
278   }
279 
280   /**
281    * @dev Increase the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _addedValue The amount of tokens to increase the allowance by.
289    */
290   function increaseApproval(
291     address _spender,
292     uint _addedValue
293   )
294     public
295     returns (bool)
296   {
297     allowed[msg.sender][_spender] = (
298       allowed[msg.sender][_spender].add(_addedValue));
299     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    *
306    * approve should be called when allowed[_spender] == 0. To decrement
307    * allowed value is better to use this function to avoid 2 calls (and wait until
308    * the first transaction is mined)
309    * From MonolithDAO Token.sol
310    * @param _spender The address which will spend the funds.
311    * @param _subtractedValue The amount of tokens to decrease the allowance by.
312    */
313   function decreaseApproval(
314     address _spender,
315     uint _subtractedValue
316   )
317     public
318     returns (bool)
319   {
320     uint oldValue = allowed[msg.sender][_spender];
321     if (_subtractedValue > oldValue) {
322       allowed[msg.sender][_spender] = 0;
323     } else {
324       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
325     }
326     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
327     return true;
328   }
329 
330 }
331 
332 
333 
334 
335 /**
336  * @title Mintable token
337  * @dev Simple ERC20 Token example, with mintable token creation
338  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
339  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
340  */
341 contract MintableToken is StandardToken, Ownable {
342   event Mint(address indexed to, uint256 amount);
343   event MintFinished();
344 
345   bool public mintingFinished = false;
346 
347 
348   modifier canMint() {
349     require(!mintingFinished);
350     _;
351   }
352 
353   modifier hasMintPermission() {
354     require(msg.sender == owner);
355     _;
356   }
357 
358   /**
359    * @dev Function to mint tokens
360    * @param _to The address that will receive the minted tokens.
361    * @param _amount The amount of tokens to mint.
362    * @return A boolean that indicates if the operation was successful.
363    */
364   function mint(
365     address _to,
366     uint256 _amount
367   )
368     hasMintPermission
369     canMint
370     public
371     returns (bool)
372   {
373     totalSupply_ = totalSupply_.add(_amount);
374     balances[_to] = balances[_to].add(_amount);
375     emit Mint(_to, _amount);
376     emit Transfer(address(0), _to, _amount);
377     return true;
378   }
379 
380   /**
381    * @dev Function to stop minting new tokens.
382    * @return True if the operation was successful.
383    */
384   function finishMinting() onlyOwner canMint public returns (bool) {
385     mintingFinished = true;
386     emit MintFinished();
387     return true;
388   }
389 }
390 
391 
392 
393 /**
394  * @title MineableToken
395  * @dev ERC20 Token with Pos mining.
396  * The blockReward_ is controlled by a GDP oracle tied to the national identity or currency union identity of the subject MonetaryCoin.
397  * This type of mining will be used during both the initial distribution period and when GDP growth is positive.
398  * For mining during negative growth period please refer to MineableM5Token.sol. 
399  * Unlike standard erc20 token, the totalSupply is sum(all user balances) + totalStake instead of sum(all user balances).
400 */
401 contract MineableToken is MintableToken { 
402   event Commit(address indexed from, uint value,uint atStake, int onBlockReward);
403   event Withdraw(address indexed from, uint reward, uint commitment);
404 
405   uint256 totalStake_ = 0;
406   int256 blockReward_;         //could be positive or negative according to GDP
407 
408   struct Commitment {
409     uint256 value;             // value commited to mining
410     uint256 onBlockNumber;     // commitment done on block
411     uint256 atStake;           // stake during commitment
412     int256 onBlockReward;
413   }
414 
415   mapping( address => Commitment ) miners;
416 
417   /**
418   * @dev commit _value for minning
419   * @notice the _value will be substructed from user balance and added to the stake.
420   * if user previously commited, add to an existing commitment. 
421   * this is done by calling withdraw() then commit back previous commit + reward + new commit 
422   * @param _value The amount to be commited.
423   * @return the commit value: _value OR prevCommit + reward + _value
424   */
425   function commit(uint256 _value) public returns (uint256 commitmentValue) {
426     require(0 < _value);
427     require(_value <= balances[msg.sender]);
428     
429     commitmentValue = _value;
430     uint256 prevCommit = miners[msg.sender].value;
431     //In case user already commited, withdraw and recommit 
432     // new commitment value: prevCommit + reward + _value
433     if (0 < prevCommit) {
434       // withdraw Will revert if reward is negative
435       uint256 prevReward;
436       (prevReward, prevCommit) = withdraw();
437       commitmentValue = prevReward.add(prevCommit).add(_value);
438     }
439 
440     // sub will revert if there is not enough balance.
441     balances[msg.sender] = balances[msg.sender].sub(commitmentValue);
442     emit Transfer(msg.sender, address(0), commitmentValue);
443 
444     totalStake_ = totalStake_.add(commitmentValue);
445 
446     miners[msg.sender] = Commitment(
447       commitmentValue, // Commitment.value
448       block.number, // onBlockNumber
449       totalStake_, // atStake = current stake + commitments value
450       blockReward_ // onBlockReward
451       );
452     
453     emit Commit(msg.sender, commitmentValue, totalStake_, blockReward_); // solium-disable-line
454 
455     return commitmentValue;
456   }
457 
458   /**
459   * @dev withdraw reward
460   * @return {
461     "uint256 reward": the new supply
462     "uint256 commitmentValue": the commitment to be returned
463     }
464   */
465   function withdraw() public returns (uint256 reward, uint256 commitmentValue) {
466     require(miners[msg.sender].value > 0); 
467 
468     //will revert if reward is negative:
469     reward = getReward(msg.sender);
470 
471     Commitment storage commitment = miners[msg.sender];
472     commitmentValue = commitment.value;
473 
474     uint256 withdrawnSum = commitmentValue.add(reward);
475     
476     totalStake_ = totalStake_.sub(commitmentValue);
477     totalSupply_ = totalSupply_.add(reward);
478     
479     balances[msg.sender] = balances[msg.sender].add(withdrawnSum);
480     emit Transfer(address(0), msg.sender, commitmentValue.add(reward));
481     
482     delete miners[msg.sender];
483     
484     emit Withdraw(msg.sender, reward, commitmentValue);  // solium-disable-line
485     return (reward, commitmentValue);
486   }
487 
488   /**
489   * @dev Calculate the reward if withdraw() happans on this block
490   * @notice The reward is calculated by the formula:
491   * (numberOfBlocks) * (effectiveBlockReward) * (commitment.value) / (effectiveStake) 
492   * effectiveBlockReward is the average between the block reward during commit and the block reward during the call
493   * effectiveStake is the average between the stake during the commit and the stake during call (liniar aproximation)
494   * @return An uint256 representing the reward amount
495   */ 
496   function getReward(address _miner) public view returns (uint256) {
497     if (miners[_miner].value == 0) {
498       return 0;
499     }
500 
501     Commitment storage commitment = miners[_miner];
502 
503     int256 averageBlockReward = signedAverage(commitment.onBlockReward, blockReward_);
504     
505     require(0 <= averageBlockReward);
506     
507     uint256 effectiveBlockReward = uint256(averageBlockReward);
508     
509     uint256 effectiveStake = average(commitment.atStake, totalStake_);
510     
511     uint256 numberOfBlocks = block.number.sub(commitment.onBlockNumber);
512 
513     uint256 miningReward = numberOfBlocks.mul(effectiveBlockReward).mul(commitment.value).div(effectiveStake);
514        
515     return miningReward;
516   }
517 
518   /**
519   * @dev Calculate the average of two integer numbers 
520   * @notice 1.5 will be rounded toward zero
521   * @return An uint256 representing integer average
522   */
523   function average(uint256 a, uint256 b) public pure returns (uint256) {
524     return a.add(b).div(2);
525   }
526 
527   /**
528   * @dev Calculate the average of two signed integers numbers 
529   * @notice 1.5 will be toward zero
530   * @return An int256 representing integer average
531   */
532   function signedAverage(int256 a, int256 b) public pure returns (int256) {
533     int256 ans = a + b;
534 
535     if (a > 0 && b > 0 && ans <= 0) {
536       require(false);
537     }
538     if (a < 0 && b < 0 && ans >= 0) {
539       require(false);
540     }
541 
542     return ans / 2;
543   }
544 
545   /**
546   * @dev Gets the commitment of the specified address.
547   * @param _miner The address to query the the commitment Of
548   * @return the amount commited.
549   */
550   function commitmentOf(address _miner) public view returns (uint256) {
551     return miners[_miner].value;
552   }
553 
554   /**
555   * @dev Gets the all fields for the commitment of the specified address.
556   * @param _miner The address to query the the commitment Of
557   * @return {
558     "uint256 value": the amount commited.
559     "uint256 onBlockNumber": block number of commitment.
560     "uint256 atStake": stake when commited.
561     "int256 onBlockReward": block reward when commited.
562     }
563   */
564   function getCommitment(address _miner) public view 
565   returns (
566     uint256 value,             // value commited to mining
567     uint256 onBlockNumber,     // commited on block
568     uint256 atStake,           // stake during commit
569     int256 onBlockReward       // block reward during commit
570     ) 
571   {
572     value = miners[_miner].value;
573     onBlockNumber = miners[_miner].onBlockNumber;
574     atStake = miners[_miner].atStake;
575     onBlockReward = miners[_miner].onBlockReward;
576   }
577 
578   /**
579   * @dev the total stake
580   * @return the total stake
581   */
582   function totalStake() public view returns (uint256) {
583     return totalStake_;
584   }
585 
586   /**
587   * @dev the block reward
588   * @return the current block reward
589   */
590   function blockReward() public view returns (int256) {
591     return blockReward_;
592   }
593 }
594 
595 
596 /**
597  * @title MCoinDistribution
598  * @dev MCoinDistribution
599  * MCoinDistribution is used to distribute a fixed amount of token per window of time.
600  * Users may commit Ether to a window of their choice.
601  * After a window closes, a user may withdraw their reward using the withdraw(uint256 window) function or use the withdrawAll() 
602  * function to get tokens from all windows in a single transaction.
603  * The amount of tokens allocated to a user for a given window equals (window allocation) * (user eth) / (total eth).
604  * A user can get the details of the current window with the detailsOfWindow() function.
605  * The first-period allocation is larger than second-period allocation (per window). 
606  */
607 contract MCoinDistribution is Ownable {
608   using SafeMath for uint256;
609 
610   event Commit(address indexed from, uint256 value, uint256 window);
611   event Withdraw(address indexed from, uint256 value, uint256 window);
612   event MoveFunds(uint256 value);
613 
614   MineableToken public MCoin;
615 
616   uint256 public firstPeriodWindows;
617   uint256 public firstPeriodSupply;
618  
619   uint256 public secondPeriodWindows;
620   uint256 public secondPeriodSupply;
621   
622   uint256 public totalWindows;  // firstPeriodWindows + secondPeriodSupply
623 
624   address public foundationWallet;
625 
626   uint256 public startTimestamp;
627   uint256 public windowLength;         // in seconds
628 
629   mapping (uint256 => uint256) public totals;
630   mapping (address => mapping (uint256 => uint256)) public commitment;
631   
632   constructor(
633     uint256 _firstPeriodWindows,
634     uint256 _firstPeriodSupply,
635     uint256 _secondPeriodWindows,
636     uint256 _secondPeriodSupply,
637     address _foundationWallet,
638     uint256 _startTimestamp,
639     uint256 _windowLength
640   ) public 
641   {
642     require(0 < _firstPeriodWindows);
643     require(0 < _firstPeriodSupply);
644     require(0 < _secondPeriodWindows);
645     require(0 < _secondPeriodSupply);
646     require(0 < _startTimestamp);
647     require(0 < _windowLength);
648     require(_foundationWallet != address(0));
649     
650     firstPeriodWindows = _firstPeriodWindows;
651     firstPeriodSupply = _firstPeriodSupply;
652     secondPeriodWindows = _secondPeriodWindows;
653     secondPeriodSupply = _secondPeriodSupply;
654     foundationWallet = _foundationWallet;
655     startTimestamp = _startTimestamp;
656     windowLength = _windowLength;
657 
658     totalWindows = firstPeriodWindows.add(secondPeriodWindows);
659     require(currentWindow() == 0);
660   }
661 
662   /**
663    * @dev Commit used as a fallback
664    */
665   function () public payable {
666     commit();
667   }
668 
669   /**
670   * @dev initiate the distribution
671   * @param _MCoin the token to distribute
672   */
673   function init(MineableToken _MCoin) public onlyOwner {
674     require(address(MCoin) == address(0));
675     require(_MCoin.owner() == address(this));
676     require(_MCoin.totalSupply() == 0);
677 
678     MCoin = _MCoin;
679     MCoin.mint(address(this), firstPeriodSupply.add(secondPeriodSupply));
680     MCoin.finishMinting();
681   }
682 
683   /**
684   * @dev return allocation for given window
685   * @param window the desired window
686   * @return the number of tokens to distribute in the given window
687   */
688   function allocationFor(uint256 window) view public returns (uint256) {
689     require(window < totalWindows);
690     
691     return (window < firstPeriodWindows) 
692       ? firstPeriodSupply.div(firstPeriodWindows) 
693       : secondPeriodSupply.div(secondPeriodWindows);
694   }
695 
696   /**
697   * @dev Return the window number for given timestamp
698   * @param timestamp 
699   * @return number of the current window in [0,inf)
700   * zero will be returned before distribution start and during the first window.
701   */
702   function windowOf(uint256 timestamp) view public returns (uint256) {
703     return (startTimestamp < timestamp) 
704       ? timestamp.sub(startTimestamp).div(windowLength) 
705       : 0;
706   }
707 
708   /**
709   * @dev Return information about the selected window
710   * @param window number: [0-totalWindows)
711   * @return {
712     "uint256 start": window start timestamp
713     "uint256 end": window end timestamp
714     "uint256 remainingTime": remaining time (sec), zero if ended
715     "uint256 allocation": number of tokens to be distributed
716     "uint256 totalEth": total eth commited this window
717     "uint256 number": # of requested window
718     }
719   */
720   function detailsOf(uint256 window) view public 
721     returns (
722       uint256 start,  // window start timestamp
723       uint256 end,    // window end timestamp
724       uint256 remainingTime, // remaining time (sec), zero if ended
725       uint256 allocation,    // number of tokens to be distributed
726       uint256 totalEth,      // total eth commited this window
727       uint256 number         // # of requested window
728     ) 
729     {
730     require(window < totalWindows);
731     start = startTimestamp.add(windowLength.mul(window));
732     end = start.add(windowLength);
733     remainingTime = (block.timestamp < end) // solium-disable-line
734       ? end.sub(block.timestamp)            // solium-disable-line
735       : 0; 
736 
737     allocation = allocationFor(window);
738     totalEth = totals[window];
739     return (start, end, remainingTime, allocation, totalEth, window);
740   }
741 
742   /**
743   * @dev Return information for the current window
744   * @return {
745     "uint256 start": window start timestamp
746     "uint256 end": window end timestamp
747     "uint256 remainingTime": remaining time (sec), zero if ended
748     "uint256 allocation": number of tokens to be distributed
749     "uint256 totalEth": total eth commited this window
750     "uint256 number": # of requested window
751     }
752   */
753   function detailsOfWindow() view public
754     returns (
755       uint256 start,  // window start timestamp
756       uint256 end,    // window end timestamp
757       uint256 remainingTime, // remaining time (sec), zero if ended
758       uint256 allocation,    // number of tokens to be distributed
759       uint256 totalEth,      // total eth commited this window
760       uint256 number         // current window
761     )
762   {
763     return (detailsOf(currentWindow()));
764   }
765 
766   /**
767   * @dev return the number of the current window
768   * @return the window, range: [0-totalWindows)
769   */
770   function currentWindow() view public returns (uint256) {
771     return windowOf(block.timestamp); // solium-disable-line
772   }
773 
774   /**
775   * @dev commit funds for a given window
776   * Tokens for commited window need to be withdrawn after
777   * window closes using withdraw(uint256 window) function
778   * first window: 0
779   * last window: totalWindows - 1
780   * @param window to commit [0-totalWindows)
781   */
782   function commitOn(uint256 window) public payable {
783     // Distribution didn't ended
784     require(currentWindow() < totalWindows);
785     // Commit only for present or future windows
786     require(currentWindow() <= window);
787     // Don't commit after distribution is finished
788     require(window < totalWindows);
789     // Minimum commitment
790     require(0.01 ether <= msg.value);
791 
792     // Add commitment for user on given window
793     commitment[msg.sender][window] = commitment[msg.sender][window].add(msg.value);
794     // Add to window total
795     totals[window] = totals[window].add(msg.value);
796     // Log
797     emit Commit(msg.sender, msg.value, window);
798   }
799 
800   /**
801   * @dev commit funds for the current window
802   */
803   function commit() public payable {
804     commitOn(currentWindow());
805   }
806   
807   /**
808   * @dev Withdraw tokens after the window has closed
809   * @param window to withdraw 
810   * @return the calculated number of tokens
811   */
812   function withdraw(uint256 window) public returns (uint256 reward) {
813     // Requested window already been closed
814     require(window < currentWindow());
815     // The sender hasn't made a commitment for requested window
816     if (commitment[msg.sender][window] == 0) {
817       return 0;
818     }
819 
820     // The Price for given window is allocation / total_commitment
821     // uint256 price = allocationFor(window).div(totals[window]);
822     // The reward is price * commitment
823     // uint256 reward = price.mul(commitment[msg.sender][window]);
824     
825     // Same calculation optimized for accuracy (without the .div rounding for price calculation):
826     reward = allocationFor(window).mul(commitment[msg.sender][window]).div(totals[window]);
827     
828     // Init the commitment
829     commitment[msg.sender][window] = 0;
830     // Transfer the tokens
831     MCoin.transfer(msg.sender, reward);
832     // Log
833     emit Withdraw(msg.sender, reward, window);
834     return reward;
835   }
836 
837   /**
838   * @dev get the reward from all closed windows
839   */
840   function withdrawAll() public {
841     for (uint256 i = 0; i < currentWindow(); i++) {
842       withdraw(i);
843     }
844   }
845 
846   /**
847   * @dev returns a array which contains reward for every closed window
848   * a convinience function to be called for updating a GUI. 
849   * To get the reward tokens use withdrawAll(), which consumes less gas.
850   * @return uint256[] rewards - the calculated number of tokens for every closed window
851   */
852   function getAllRewards() public view returns (uint256[]) {
853     uint256[] memory rewards = new uint256[](totalWindows);
854     // lastClosedWindow = min(currentWindow(),totalWindows);
855     uint256 lastWindow = currentWindow() < totalWindows ? currentWindow() : totalWindows;
856     for (uint256 i = 0; i < lastWindow; i++) {
857       rewards[i] = withdraw(i);
858     }
859     return rewards;
860   }
861 
862   /**
863   * @dev returns a array filled with commitments of address for every window
864   * a convinience function to be called for updating a GUI. 
865   * @return uint256[] commitments - the commited Eth per window of a given address
866   */
867   function getCommitmentsOf(address from) public view returns (uint256[]) {
868     uint256[] memory commitments = new uint256[](totalWindows);
869     for (uint256 i = 0; i < totalWindows; i++) {
870       commitments[i] = commitment[from][i];
871     }
872     return commitments;
873   }
874 
875   /**
876   * @dev returns a array filled with eth totals for every window
877   * a convinience function to be called for updating a GUI. 
878   * @return uint256[] ethTotals - the totals for commited Eth per window
879   */
880   function getTotals() public view returns (uint256[]) {
881     uint256[] memory ethTotals = new uint256[](totalWindows);
882     for (uint256 i = 0; i < totalWindows; i++) {
883       ethTotals[i] = totals[i];
884     }
885     return ethTotals;
886   }
887 
888   /**
889   * @dev moves Eth to the foundation wallet.
890   * @return the amount to be moved.
891   */
892   function moveFunds() public onlyOwner returns (uint256 value) {
893     value = address(this).balance;
894     require(0 < value);
895 
896     foundationWallet.transfer(value);
897     
898     emit MoveFunds(value);
899     return value;
900   }
901 }
902 
903 
904 
905 /**
906  * @title MCoinDistributionWrap
907  * @dev MCoinDistribution wrapper contract.
908  * This contracts wraps MCoinDistribution.sol and is used to create the distribution contract. 
909  * See MCoinDistribution.sol for full distribution details.
910  */
911 contract MCoinDistributionWrap is MCoinDistribution {
912   using SafeMath for uint256;
913   
914   uint8 public constant decimals = 18;  // solium-disable-line uppercase
915 
916   constructor(
917     uint256 firstPeriodWindows,
918     uint256 firstPeriodSupply,
919     uint256 secondPeriodWindows,
920     uint256 secondPeriodSupply,
921     address foundationWallet,
922     uint256 startTime,
923     uint256 windowLength
924     )
925     MCoinDistribution (
926       firstPeriodWindows,              // uint _firstPeriodWindows
927       toDecimals(firstPeriodSupply),   // uint _firstPeriodSupply,
928       secondPeriodWindows,             // uint _secondPeriodDays,
929       toDecimals(secondPeriodSupply),  // uint _secondPeriodSupply,
930       foundationWallet,                // address _foundationMultiSig,
931       startTime,                       // uint _startTime
932       windowLength                     // uint _windowLength
933     ) public 
934   {}    
935 
936   function toDecimals(uint256 _value) pure internal returns (uint256) {
937     return _value.mul(10 ** uint256(decimals));
938   }
939 }