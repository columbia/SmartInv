1 pragma solidity ^0.4.24;
2 
3 
4 /** ----------------------MonetaryCoin V1.0.0 ------------------------*/
5 
6 /**
7  * Homepage: https://MonetaryCoin.org  Distribution: https://MonetaryCoin.io
8  *
9  * Full source code: https://github.com/Monetary-Foundation/MonetaryCoin
10  * 
11  * Licenced MIT - The Monetary Foundation 2018
12  *
13  */
14 
15 /**
16  * @title ERC20Basic
17  * @dev Simpler version of ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/179
19  */
20 contract ERC20Basic {
21   function totalSupply() public view returns (uint256);
22   function balanceOf(address who) public view returns (uint256);
23   function transfer(address to, uint256 value) public returns (bool);
24   event Transfer(address indexed from, address indexed to, uint256 value);
25 }
26 
27 
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipRenounced(address indexed previousOwner);
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   constructor() public {
50     owner = msg.sender;
51   }
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) public onlyOwner {
66     require(newOwner != address(0));
67     emit OwnershipTransferred(owner, newOwner);
68     owner = newOwner;
69   }
70 
71   /**
72    * @dev Allows the current owner to relinquish control of the contract.
73    */
74   function renounceOwnership() public onlyOwner {
75     emit OwnershipRenounced(owner);
76     owner = address(0);
77   }
78 }
79 
80 /**
81  * @title SafeMath
82  * @dev Math operations with safety checks that throw on error
83  */
84 library SafeMath {
85 
86   /**
87   * @dev Multiplies two numbers, throws on overflow.
88   */
89   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
90     if (a == 0) {
91       return 0;
92     }
93     c = a * b;
94     assert(c / a == b);
95     return c;
96   }
97 
98   /**
99   * @dev Integer division of two numbers, truncating the quotient.
100   */
101   function div(uint256 a, uint256 b) internal pure returns (uint256) {
102     // assert(b > 0); // Solidity automatically throws when dividing by 0
103     // uint256 c = a / b;
104     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105     return a / b;
106   }
107 
108   /**
109   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
110   */
111   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112     assert(b <= a);
113     return a - b;
114   }
115 
116   /**
117   * @dev Adds two numbers, throws on overflow.
118   */
119   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
120     c = a + b;
121     assert(c >= a);
122     return c;
123   }
124 }
125 
126 
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  */
132 contract BasicToken is ERC20Basic {
133   using SafeMath for uint256;
134 
135   mapping(address => uint256) balances;
136 
137   uint256 totalSupply_;
138 
139   /**
140   * @dev total number of tokens in existence
141   */
142   function totalSupply() public view returns (uint256) {
143     return totalSupply_;
144   }
145 
146   /**
147   * @dev transfer token for a specified address
148   * @param _to The address to transfer to.
149   * @param _value The amount to be transferred.
150   */
151   function transfer(address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[msg.sender]);
154 
155     balances[msg.sender] = balances[msg.sender].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     emit Transfer(msg.sender, _to, _value);
158     return true;
159   }
160 
161   /**
162   * @dev Gets the balance of the specified address.
163   * @param _owner The address to query the the balance of.
164   * @return An uint256 representing the amount owned by the passed address.
165   */
166   function balanceOf(address _owner) public view returns (uint256) {
167     return balances[_owner];
168   }
169 
170 }
171 
172 
173 
174 
175 
176 
177 /**
178  * @title ERC20 interface
179  * @dev see https://github.com/ethereum/EIPs/issues/20
180  */
181 contract ERC20 is ERC20Basic {
182   function allowance(address owner, address spender)
183     public view returns (uint256);
184 
185   function transferFrom(address from, address to, uint256 value)
186     public returns (bool);
187 
188   function approve(address spender, uint256 value) public returns (bool);
189   event Approval(
190     address indexed owner,
191     address indexed spender,
192     uint256 value
193   );
194 }
195 
196 
197 
198 /**
199  * @title Standard ERC20 token
200  *
201  * @dev Implementation of the basic standard token.
202  * @dev https://github.com/ethereum/EIPs/issues/20
203  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
204  */
205 contract StandardToken is ERC20, BasicToken {
206 
207   mapping (address => mapping (address => uint256)) internal allowed;
208 
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(
217     address _from,
218     address _to,
219     uint256 _value
220   )
221     public
222     returns (bool)
223   {
224     require(_to != address(0));
225     require(_value <= balances[_from]);
226     require(_value <= allowed[_from][msg.sender]);
227 
228     balances[_from] = balances[_from].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231     emit Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    *
238    * Beware that changing an allowance with this method brings the risk that someone may use both the old
239    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) public returns (bool) {
246     allowed[msg.sender][_spender] = _value;
247     emit Approval(msg.sender, _spender, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Function to check the amount of tokens that an owner allowed to a spender.
253    * @param _owner address The address which owns the funds.
254    * @param _spender address The address which will spend the funds.
255    * @return A uint256 specifying the amount of tokens still available for the spender.
256    */
257   function allowance(
258     address _owner,
259     address _spender
260    )
261     public
262     view
263     returns (uint256)
264   {
265     return allowed[_owner][_spender];
266   }
267 
268   /**
269    * @dev Increase the amount of tokens that an owner allowed to a spender.
270    *
271    * approve should be called when allowed[_spender] == 0. To increment
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _addedValue The amount of tokens to increase the allowance by.
277    */
278   function increaseApproval(
279     address _spender,
280     uint _addedValue
281   )
282     public
283     returns (bool)
284   {
285     allowed[msg.sender][_spender] = (
286       allowed[msg.sender][_spender].add(_addedValue));
287     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291   /**
292    * @dev Decrease the amount of tokens that an owner allowed to a spender.
293    *
294    * approve should be called when allowed[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseApproval(
302     address _spender,
303     uint _subtractedValue
304   )
305     public
306     returns (bool)
307   {
308     uint oldValue = allowed[msg.sender][_spender];
309     if (_subtractedValue > oldValue) {
310       allowed[msg.sender][_spender] = 0;
311     } else {
312       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
313     }
314     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315     return true;
316   }
317 
318 }
319 
320 
321 
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
327  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
328  */
329 contract MintableToken is StandardToken, Ownable {
330   event Mint(address indexed to, uint256 amount);
331   event MintFinished();
332 
333   bool public mintingFinished = false;
334 
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341   modifier hasMintPermission() {
342     require(msg.sender == owner);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(
353     address _to,
354     uint256 _amount
355   )
356     hasMintPermission
357     canMint
358     public
359     returns (bool)
360   {
361     totalSupply_ = totalSupply_.add(_amount);
362     balances[_to] = balances[_to].add(_amount);
363     emit Mint(_to, _amount);
364     emit Transfer(address(0), _to, _amount);
365     return true;
366   }
367 
368   /**
369    * @dev Function to stop minting new tokens.
370    * @return True if the operation was successful.
371    */
372   function finishMinting() onlyOwner canMint public returns (bool) {
373     mintingFinished = true;
374     emit MintFinished();
375     return true;
376   }
377 }
378 
379 
380 
381 /**
382  * @title MineableToken
383  * @dev ERC20 Token with Pos mining.
384  * The blockReward_ is controlled by a GDP oracle tied to the national identity or currency union identity of the subject MonetaryCoin.
385  * This type of mining will be used during both the initial distribution period and when GDP growth is positive.
386  * For mining during negative growth period please refer to MineableM5Token.sol. 
387  * Unlike standard erc20 token, the totalSupply is sum(all user balances) + totalStake instead of sum(all user balances).
388 */
389 contract MineableToken is MintableToken { 
390   event Commit(address indexed from, uint value,uint atStake, int onBlockReward);
391   event Withdraw(address indexed from, uint reward, uint commitment);
392 
393   uint256 totalStake_ = 0;
394   int256 blockReward_;         //could be positive or negative according to GDP
395 
396   struct Commitment {
397     uint256 value;             // value commited to mining
398     uint256 onBlockNumber;     // commitment done on block
399     uint256 atStake;           // stake during commitment
400     int256 onBlockReward;
401   }
402 
403   mapping( address => Commitment ) miners;
404 
405   /**
406   * @dev commit _value for minning
407   * @notice the _value will be substructed from user balance and added to the stake.
408   * if user previously commited, add to an existing commitment. 
409   * this is done by calling withdraw() then commit back previous commit + reward + new commit 
410   * @param _value The amount to be commited.
411   * @return the commit value: _value OR prevCommit + reward + _value
412   */
413   function commit(uint256 _value) public returns (uint256 commitmentValue) {
414     require(0 < _value);
415     require(_value <= balances[msg.sender]);
416     
417     commitmentValue = _value;
418     uint256 prevCommit = miners[msg.sender].value;
419     //In case user already commited, withdraw and recommit 
420     // new commitment value: prevCommit + reward + _value
421     if (0 < prevCommit) {
422       // withdraw Will revert if reward is negative
423       uint256 prevReward;
424       (prevReward, prevCommit) = withdraw();
425       commitmentValue = prevReward.add(prevCommit).add(_value);
426     }
427 
428     // sub will revert if there is not enough balance.
429     balances[msg.sender] = balances[msg.sender].sub(commitmentValue);
430     emit Transfer(msg.sender, address(0), commitmentValue);
431 
432     totalStake_ = totalStake_.add(commitmentValue);
433 
434     miners[msg.sender] = Commitment(
435       commitmentValue, // Commitment.value
436       block.number, // onBlockNumber
437       totalStake_, // atStake = current stake + commitments value
438       blockReward_ // onBlockReward
439       );
440     
441     emit Commit(msg.sender, commitmentValue, totalStake_, blockReward_); // solium-disable-line
442 
443     return commitmentValue;
444   }
445 
446   /**
447   * @dev withdraw reward
448   * @return {
449     "uint256 reward": the new supply
450     "uint256 commitmentValue": the commitment to be returned
451     }
452   */
453   function withdraw() public returns (uint256 reward, uint256 commitmentValue) {
454     require(miners[msg.sender].value > 0); 
455 
456     //will revert if reward is negative:
457     reward = getReward(msg.sender);
458 
459     Commitment storage commitment = miners[msg.sender];
460     commitmentValue = commitment.value;
461 
462     uint256 withdrawnSum = commitmentValue.add(reward);
463     
464     totalStake_ = totalStake_.sub(commitmentValue);
465     totalSupply_ = totalSupply_.add(reward);
466     
467     balances[msg.sender] = balances[msg.sender].add(withdrawnSum);
468     emit Transfer(address(0), msg.sender, commitmentValue.add(reward));
469     
470     delete miners[msg.sender];
471     
472     emit Withdraw(msg.sender, reward, commitmentValue);  // solium-disable-line
473     return (reward, commitmentValue);
474   }
475 
476   /**
477   * @dev Calculate the reward if withdraw() happans on this block
478   * @notice The reward is calculated by the formula:
479   * (numberOfBlocks) * (effectiveBlockReward) * (commitment.value) / (effectiveStake) 
480   * effectiveBlockReward is the average between the block reward during commit and the block reward during the call
481   * effectiveStake is the average between the stake during the commit and the stake during call (liniar aproximation)
482   * @return An uint256 representing the reward amount
483   */ 
484   function getReward(address _miner) public view returns (uint256) {
485     if (miners[_miner].value == 0) {
486       return 0;
487     }
488 
489     Commitment storage commitment = miners[_miner];
490 
491     int256 averageBlockReward = signedAverage(commitment.onBlockReward, blockReward_);
492     
493     require(0 <= averageBlockReward);
494     
495     uint256 effectiveBlockReward = uint256(averageBlockReward);
496     
497     uint256 effectiveStake = average(commitment.atStake, totalStake_);
498     
499     uint256 numberOfBlocks = block.number.sub(commitment.onBlockNumber);
500 
501     uint256 miningReward = numberOfBlocks.mul(effectiveBlockReward).mul(commitment.value).div(effectiveStake);
502        
503     return miningReward;
504   }
505 
506   /**
507   * @dev Calculate the average of two integer numbers 
508   * @notice 1.5 will be rounded toward zero
509   * @return An uint256 representing integer average
510   */
511   function average(uint256 a, uint256 b) public pure returns (uint256) {
512     return a.add(b).div(2);
513   }
514 
515   /**
516   * @dev Calculate the average of two signed integers numbers 
517   * @notice 1.5 will be toward zero
518   * @return An int256 representing integer average
519   */
520   function signedAverage(int256 a, int256 b) public pure returns (int256) {
521     int256 ans = a + b;
522 
523     if (a > 0 && b > 0 && ans <= 0) {
524       require(false);
525     }
526     if (a < 0 && b < 0 && ans >= 0) {
527       require(false);
528     }
529 
530     return ans / 2;
531   }
532 
533   /**
534   * @dev Gets the commitment of the specified address.
535   * @param _miner The address to query the the commitment Of
536   * @return the amount commited.
537   */
538   function commitmentOf(address _miner) public view returns (uint256) {
539     return miners[_miner].value;
540   }
541 
542   /**
543   * @dev Gets the all fields for the commitment of the specified address.
544   * @param _miner The address to query the the commitment Of
545   * @return {
546     "uint256 value": the amount commited.
547     "uint256 onBlockNumber": block number of commitment.
548     "uint256 atStake": stake when commited.
549     "int256 onBlockReward": block reward when commited.
550     }
551   */
552   function getCommitment(address _miner) public view 
553   returns (
554     uint256 value,             // value commited to mining
555     uint256 onBlockNumber,     // commited on block
556     uint256 atStake,           // stake during commit
557     int256 onBlockReward       // block reward during commit
558     ) 
559   {
560     value = miners[_miner].value;
561     onBlockNumber = miners[_miner].onBlockNumber;
562     atStake = miners[_miner].atStake;
563     onBlockReward = miners[_miner].onBlockReward;
564   }
565 
566   /**
567   * @dev the total stake
568   * @return the total stake
569   */
570   function totalStake() public view returns (uint256) {
571     return totalStake_;
572   }
573 
574   /**
575   * @dev the block reward
576   * @return the current block reward
577   */
578   function blockReward() public view returns (int256) {
579     return blockReward_;
580   }
581 }
582 
583 
584 /**
585  * @title GDPOraclizedToken
586  * @dev This is an interface for the GDP Oracle to control the mining rate.
587  * For security reasons, two distinct functions were created: 
588  * setPositiveGrowth() and setNegativeGrowth()
589  */
590 contract GDPOraclizedToken is MineableToken {
591 
592   event GDPOracleTransferred(address indexed previousOracle, address indexed newOracle);
593   event BlockRewardChanged(int oldBlockReward, int newBlockReward);
594 
595   address GDPOracle_;
596   address pendingGDPOracle_;
597 
598   /**
599    * @dev Modifier Throws if called by any account other than the GDPOracle.
600    */
601   modifier onlyGDPOracle() {
602     require(msg.sender == GDPOracle_);
603     _;
604   }
605   
606   /**
607    * @dev Modifier throws if called by any account other than the pendingGDPOracle.
608    */
609   modifier onlyPendingGDPOracle() {
610     require(msg.sender == pendingGDPOracle_);
611     _;
612   }
613 
614   /**
615    * @dev Allows the current GDPOracle to transfer control to a newOracle.
616    * The new GDPOracle need to call claimOracle() to finalize
617    * @param newOracle The address to transfer ownership to.
618    */
619   function transferGDPOracle(address newOracle) public onlyGDPOracle {
620     pendingGDPOracle_ = newOracle;
621   }
622 
623   /**
624    * @dev Allows the pendingGDPOracle_ address to finalize the transfer.
625    */
626   function claimOracle() onlyPendingGDPOracle public {
627     emit GDPOracleTransferred(GDPOracle_, pendingGDPOracle_);
628     GDPOracle_ = pendingGDPOracle_;
629     pendingGDPOracle_ = address(0);
630   }
631 
632   /**
633    * @dev Chnage block reward according to GDP 
634    * @param newBlockReward the new block reward in case of possible growth
635    */
636   function setPositiveGrowth(int256 newBlockReward) public onlyGDPOracle returns(bool) {
637     // protect against error / overflow
638     require(0 <= newBlockReward);
639     
640     emit BlockRewardChanged(blockReward_, newBlockReward);
641     blockReward_ = newBlockReward;
642   }
643 
644   /**
645    * @dev Chnage block reward according to GDP 
646    * @param newBlockReward the new block reward in case of negative growth
647    */
648   function setNegativeGrowth(int256 newBlockReward) public onlyGDPOracle returns(bool) {
649     require(newBlockReward < 0);
650 
651     emit BlockRewardChanged(blockReward_, newBlockReward);
652     blockReward_ = newBlockReward;
653   }
654 
655   /**
656   * @dev get GDPOracle
657   * @return the address of the GDPOracle
658   */
659   function GDPOracle() public view returns (address) { // solium-disable-line mixedcase
660     return GDPOracle_;
661   }
662 
663   /**
664   * @dev get GDPOracle
665   * @return the address of the GDPOracle
666   */
667   function pendingGDPOracle() public view returns (address) { // solium-disable-line mixedcase
668     return pendingGDPOracle_;
669   }
670 }
671 
672 
673 
674 /**
675  * @title MineableM5Token
676  * @notice This contract adds the ability to mine for M5 tokens when growth is negative.
677  * The M5 token is a distinct ERC20 token that may be obtained only following a period of negative GDP growth.
678  * The logic for M5 mining will be finalized in advance of the close of the initial distribution period – see the White Paper for additional details.
679  * After upgrading this contract with the final M5 logic, finishUpgrade() will be called to permanently seal the upgradeability of the contract.
680 */
681 contract MineableM5Token is GDPOraclizedToken { 
682   
683   event M5TokenUpgrade(address indexed oldM5Token, address indexed newM5Token);
684   event M5LogicUpgrade(address indexed oldM5Logic, address indexed newM5Logic);
685   event FinishUpgrade();
686 
687   // The M5 token contract
688   address M5Token_;
689   // The contract to manage M5 mining logic.
690   address M5Logic_;
691   // The address which controls the upgrade process
692   address upgradeManager_;
693   // When isUpgradeFinished_ is true, no more upgrades is allowed
694   bool isUpgradeFinished_ = false;
695 
696   /**
697   * @dev get the M5 token address
698   * @return M5 token address
699   */
700   function M5Token() public view returns (address) {
701     return M5Token_;
702   }
703 
704   /**
705   * @dev get the M5 logic contract address
706   * @return M5 logic contract address
707   */
708   function M5Logic() public view returns (address) {
709     return M5Logic_;
710   }
711 
712   /**
713   * @dev get the upgrade manager address
714   * @return the upgrade manager address
715   */
716   function upgradeManager() public view returns (address) {
717     return upgradeManager_;
718   }
719 
720   /**
721   * @dev get the upgrade status
722   * @return the upgrade status. if true, no more upgrades are possible.
723   */
724   function isUpgradeFinished() public view returns (bool) {
725     return isUpgradeFinished_;
726   }
727 
728   /**
729   * @dev Throws if called by any account other than the GDPOracle.
730   */
731   modifier onlyUpgradeManager() {
732     require(msg.sender == upgradeManager_);
733     require(!isUpgradeFinished_);
734     _;
735   }
736 
737   /**
738    * @dev Allows to set the M5 token contract 
739    * @param newM5Token The address of the new contract
740    */
741   function upgradeM5Token(address newM5Token) public onlyUpgradeManager { // solium-disable-line
742     require(newM5Token != address(0));
743     emit M5TokenUpgrade(M5Token_, newM5Token);
744     M5Token_ = newM5Token;
745   }
746 
747   /**
748    * @dev Allows the upgrade the M5 logic contract 
749    * @param newM5Logic The address of the new contract
750    */
751   function upgradeM5Logic(address newM5Logic) public onlyUpgradeManager { // solium-disable-line
752     require(newM5Logic != address(0));
753     emit M5LogicUpgrade(M5Logic_, newM5Logic);
754     M5Logic_ = newM5Logic;
755   }
756 
757   /**
758    * @dev Allows the upgrade the M5 logic contract and token at the same transaction
759    * @param newM5Token The address of a new M5 token
760    * @param newM5Logic The address of the new contract
761    */
762   function upgradeM5(address newM5Token, address newM5Logic) public onlyUpgradeManager { // solium-disable-line
763     require(newM5Token != address(0));
764     require(newM5Logic != address(0));
765     emit M5TokenUpgrade(M5Token_, newM5Token);
766     emit M5LogicUpgrade(M5Logic_, newM5Logic);
767     M5Token_ = newM5Token;
768     M5Logic_ = newM5Logic;
769   }
770 
771   /**
772   * @dev Function to dismiss the upgrade capability
773   * @return True if the operation was successful.
774   */
775   function finishUpgrade() onlyUpgradeManager public returns (bool) {
776     isUpgradeFinished_ = true;
777     emit FinishUpgrade();
778     return true;
779   }
780 
781   /**
782   * @dev Calculate the reward if withdrawM5() happans on this block
783   * @notice This is a wrapper, which calls and return result from M5Logic
784   * the actual logic is found in the M5Logic contract
785   * @param _miner The address of the _miner
786   * @return An uint256 representing the reward amount
787   */
788   function getM5Reward(address _miner) public view returns (uint256) {
789     require(M5Logic_ != address(0));
790     if (miners[_miner].value == 0) {
791       return 0;
792     }
793     // check that effective block reward is indeed negative
794     require(signedAverage(miners[_miner].onBlockReward, blockReward_) < 0);
795 
796     // return length (bytes)
797     uint32 returnSize = 32;
798     // target contract
799     address target = M5Logic_;
800     // method signeture for target contract
801     bytes32 signature = keccak256("getM5Reward(address)");
802     // size of calldata for getM5Reward function: 4 for signeture and 32 for one variable (address)
803     uint32 inputSize = 4 + 32;
804     // variable to check delegatecall result (success or failure)
805     uint8 callResult;
806     // result from target.getM5Reward()
807     uint256 result;
808     
809     assembly { // solium-disable-line
810         // return _dest.delegatecall(msg.data)
811         mstore(0x0, signature) // 4 bytes of method signature
812         mstore(0x4, _miner)    // 20 bytes of address
813         // delegatecall(g, a, in, insize, out, outsize)	- call contract at address a with input mem[in..(in+insize))
814         // providing g gas and v wei and output area mem[out..(out+outsize)) returning 0 on error (eg. out of gas) and 1 on success
815         // keep caller and callvalue
816         callResult := delegatecall(sub(gas, 10000), target, 0x0, inputSize, 0x0, returnSize)
817         switch callResult 
818         case 0 
819           { revert(0,0) } 
820         default 
821           { result := mload(0x0) }
822     }
823     return result;
824   }
825 
826   event WithdrawM5(address indexed from,uint commitment, uint M5Reward);
827 
828   /**
829   * @dev withdraw M5 reward, only appied to mining when GDP is negative
830   * @return {
831     "uint256 reward": the new M5 supply
832     "uint256 commitmentValue": the commitment to be returned
833     }
834   */
835   function withdrawM5() public returns (uint256 reward, uint256 commitmentValue) {
836     require(M5Logic_ != address(0));
837     require(M5Token_ != address(0));
838     require(miners[msg.sender].value > 0); 
839     
840     // will revert if reward is positive
841     reward = getM5Reward(msg.sender);
842     commitmentValue = miners[msg.sender].value;
843     
844     require(M5Logic_.delegatecall(bytes4(keccak256("withdrawM5()")))); // solium-disable-line
845     
846     return (reward,commitmentValue);
847   }
848 
849   //triggered when user swaps m5Value of M5 tokens for value of regular tokens.
850   event Swap(address indexed from, uint256 M5Value, uint256 value);
851 
852   /**
853   * @dev swap M5 tokens back to regular tokens when GDP is back to positive 
854   * @param _value The amount of M5 tokens to swap for regular tokens
855   * @return true
856   */
857   function swap(uint256 _value) public returns (bool) {
858     require(M5Logic_ != address(0));
859     require(M5Token_ != address(0));
860 
861     require(M5Logic_.delegatecall(bytes4(keccak256("swap(uint256)")),_value)); // solium-disable-line
862     
863     return true;
864   }
865 }
866 
867 
868 /**
869  * @title MCoin
870  * @dev The MonetaryCoin contract
871  * The MonetaryCoin contract allows for the creation of a new monetary coin.
872  * The supply of a minable coin in a period is defined by an oracle that reports GDP data from the country related to that coin.
873  * Example: If the GDP of a given country grows by 3%, then 3% more coins will be available for forging (i.e. mining) in the next period.
874  * Coins will be distributed by the proof of stake forging mechanism both during and after the initial distribution period.
875  * The Proof of stake forging is defined by the MineableToken.sol contract. 
876  */
877 contract MCoin is MineableM5Token {
878 
879   string public name; // solium-disable-line uppercase
880   string public symbol; // solium-disable-line uppercase
881   uint8 public constant decimals = 18; // solium-disable-line uppercase
882 
883   constructor(
884     string tokenName,
885     string tokenSymbol,
886     uint256 blockReward, // will be transformed using toDecimals()
887     address GDPOracle,
888     address upgradeManager
889     ) public 
890     {
891     require(GDPOracle != address(0));
892     require(upgradeManager != address(0));
893     
894     name = tokenName;
895     symbol = tokenSymbol;
896 
897     blockReward_ = toDecimals(blockReward);
898     emit BlockRewardChanged(0, blockReward_);
899 
900     GDPOracle_ = GDPOracle;
901     emit GDPOracleTransferred(0x0, GDPOracle_);
902 
903     M5Token_ = address(0);
904     M5Logic_ = address(0);
905     upgradeManager_ = upgradeManager;
906   }
907 
908   function toDecimals(uint256 _value) pure internal returns (int256 value) {
909     value = int256 (
910       _value.mul(10 ** uint256(decimals))
911     );
912     assert(0 < value);
913     return value;
914   }
915 
916 }