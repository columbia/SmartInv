1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender)
123     public view returns (uint256);
124 
125   function transferFrom(address from, address to, uint256 value)
126     public returns (bool);
127 
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
322 
323 /**
324  * @title Pausable
325  * @dev Base contract which allows children to implement an emergency stop mechanism.
326  */
327 contract Pausable is Ownable {
328   event Pause();
329   event Unpause();
330 
331   bool public paused = false;
332 
333 
334   /**
335    * @dev Modifier to make a function callable only when the contract is not paused.
336    */
337   modifier whenNotPaused() {
338     require(!paused);
339     _;
340   }
341 
342   /**
343    * @dev Modifier to make a function callable only when the contract is paused.
344    */
345   modifier whenPaused() {
346     require(paused);
347     _;
348   }
349 
350   /**
351    * @dev called by the owner to pause, triggers stopped state
352    */
353   function pause() onlyOwner whenNotPaused public {
354     paused = true;
355     emit Pause();
356   }
357 
358   /**
359    * @dev called by the owner to unpause, returns to normal state
360    */
361   function unpause() onlyOwner whenPaused public {
362     paused = false;
363     emit Unpause();
364   }
365 }
366 
367 // File: contracts/MarketDataStorage.sol
368 
369 contract MarketDataStorage is Ownable {
370     // vars
371     address[] supportedTokens;
372     mapping (address => bool) public supportedTokensMapping; // same as supportedTokens just in a mapping for quicker lookup
373     mapping (address => uint[]) public currentTokenMarketData; // represent the last token data
374     mapping (bytes32 => bool) internal validIds; // for Oraclize callbacks
375     address dataUpdater; // who is allowed to update data
376 
377     // modifiers
378     modifier updaterOnly() {
379         require(
380             msg.sender == dataUpdater,
381             "updater not allowed"
382         );
383         _;
384     }
385 
386     modifier supportedTokenOnly(address token_address) {
387         require(
388             isTokenSupported(token_address),
389             "Can't update a non supported token"
390         );
391         _;
392     }
393 
394     constructor (address[] _supportedTokens, address _dataUpdater) Ownable() public {
395         dataUpdater = _dataUpdater;
396 
397         // to populate supportedTokensMapping
398         for (uint i=0; i<_supportedTokens.length; i++) {
399             addSupportedToken(_supportedTokens[i]);
400         }
401     }
402 
403     function numberOfSupportedTokens() view public returns (uint) {
404         return supportedTokens.length;
405     }
406 
407     function getSupportedTokenByIndex(uint idx) view public returns (address token_address, bool supported_status) {
408         address token = supportedTokens[idx];
409         return (token, supportedTokensMapping[token]);
410     }
411 
412     function getMarketDataByTokenIdx(uint idx) view public returns (address token_address, uint volume, uint depth, uint marketcap) {
413         (address token, bool status) = getSupportedTokenByIndex(idx);
414 
415         (uint _volume, uint _depth, uint _marketcap) = getMarketData(token);
416 
417         return (token, _volume, _depth, _marketcap);
418     }
419 
420     function getMarketData(address token_address) view public returns (uint volume, uint depth, uint marketcap) {
421         // we do not throw an exception for non supported tokens, simply return 0,0,0
422         if (!supportedTokensMapping[token_address]) {
423             return (0,0,0);
424         }
425 
426         uint[] memory data = currentTokenMarketData[token_address];
427         return (data[0], data[1], data[2]);
428     }
429 
430     function addSupportedToken(address token_address) public onlyOwner {
431         require(
432             isTokenSupported(token_address) == false,
433             "Token already added"
434         );
435 
436         supportedTokens.push(token_address);
437         supportedTokensMapping[token_address] = true;
438 
439         currentTokenMarketData[token_address] = [0,0,0]; // until next update
440     }
441 
442     function isTokenSupported(address token_address) view public returns (bool) {
443         return supportedTokensMapping[token_address];
444     }
445 
446     // update Data
447     function updateMarketData(address token_address,
448         uint volume,
449         uint depth,
450         uint marketcap)
451     external
452     updaterOnly
453     supportedTokenOnly(token_address) {
454         currentTokenMarketData[token_address] = [volume,depth,marketcap];
455     }
456 }
457 
458 // File: contracts/WarOfTokens.sol
459 
460 contract WarOfTokens is Pausable {
461     using SafeMath for uint256;
462 
463     struct AttackInfo {
464         address attacker;
465         address attackee;
466         uint attackerScore;
467         uint attackeeScore;
468         bytes32 attackId;
469         bool completed;
470         uint hodlSpellBlockNumber;
471         mapping (address => uint256) attackerWinnings;
472         mapping (address => uint256) attackeeWinnings;
473     }
474 
475     // events
476     event Deposit(address token, address user, uint amount, uint balance);
477     event Withdraw(address token, address user, uint amount, uint balance);
478     event UserActiveStatusChanged(address user, bool isActive);
479     event Attack (
480         address indexed attacker,
481         address indexed attackee,
482         bytes32 attackId,
483         uint attackPrizePercent,
484         uint base,
485         uint hodlSpellBlockNumber
486     );
487     event AttackCompleted (
488         bytes32 indexed attackId,
489         address indexed winner,
490         uint attackeeActualScore
491     );
492 
493     // vars
494     /**
495     *   mapping of token addresses to mapping of account balances (token=0 means Ether)
496     */
497     mapping (address => mapping (address => uint256)) public tokens;
498     mapping (address => bool) public activeUsers;
499     address public cdtTokenAddress;
500     uint256 public minCDTToParticipate;
501     MarketDataStorage public marketDataOracle;
502     uint public maxAttackPrizePercent; // if attacker and attackee have the same score, whats the max % of their assets will be as prize
503     uint attackPricePrecentBase = 1000; // since EVM doesn't support floating numbers yet.
504     uint public maxOpenAttacks = 5;
505     mapping (bytes32 => AttackInfo) public attackIdToInfo;
506     mapping (address => mapping(address => bytes32)) public userToUserToAttackId;
507     mapping (address => uint) public cntUserAttacks; // keeps track of how many un-completed attacks user has
508 
509 
510     // modifiers
511     modifier activeUserOnly(address user) {
512         require(
513             isActiveUser(user),
514             "User not active"
515         );
516         _;
517     }
518 
519     constructor(address _cdtTokenAddress,
520         uint256 _minCDTToParticipate,
521         address _marketDataOracleAddress,
522         uint _maxAttackPrizeRatio)
523     Pausable()
524     public {
525         cdtTokenAddress = _cdtTokenAddress;
526         minCDTToParticipate = _minCDTToParticipate;
527         marketDataOracle = MarketDataStorage(_marketDataOracleAddress);
528         setMaxAttackPrizePercent(_maxAttackPrizeRatio);
529     }
530 
531     // don't allow default
532     function() public {
533         revert("Please do not send ETH without calling the deposit function. We will not do it automatically to validate your intent");
534     }
535 
536     // user management
537     function isActiveUser(address user) view public returns (bool) {
538         return activeUsers[user];
539     }
540 
541     ////////////////////////////////////////////////////////
542     //
543     //  balances management
544     //
545     ////////////////////////////////////////////////////////
546 
547     // taken from https://etherscan.io/address/0x8d12a197cb00d4747a1fe03395095ce2a5cc6819#code
548     /**
549     *   disabled when contract is paused
550     */
551     function deposit() payable external whenNotPaused {
552         tokens[0][msg.sender] = tokens[0][msg.sender].add(msg.value);
553         emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
554 
555         _validateUserActive(msg.sender);
556     }
557 
558     /**
559     *   disabled when contract is paused
560     */
561     function depositToken(address token, uint amount) external whenNotPaused {
562         //remember to call StandardToken(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
563         require(
564             token!=0,
565             "unrecognized token"
566         );
567         assert(StandardToken(token).transferFrom(msg.sender, this, amount));
568         tokens[token][msg.sender] =  tokens[token][msg.sender].add(amount);
569         emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
570 
571         _validateUserActive(msg.sender);
572     }
573 
574     function withdraw(uint amount) external {
575         tokens[0][msg.sender] = tokens[0][msg.sender].sub(amount);
576         assert(msg.sender.call.value(amount)());
577         emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
578 
579         _validateUserActive(msg.sender);
580     }
581 
582     function withdrawToken(address token, uint amount) external {
583         require(
584             token!=0,
585             "unrecognized token"
586         );
587         tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);
588         assert(StandardToken(token).transfer(msg.sender, amount));
589         emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
590 
591         _validateUserActive(msg.sender);
592     }
593 
594     function balanceOf(address token, address user) view public returns (uint) {
595         return tokens[token][user];
596     }
597 
598     ////////////////////////////////////////////////////////
599     //
600     //  combat functions
601     //
602     ////////////////////////////////////////////////////////
603     function setMaxAttackPrizePercent(uint newAttackPrize) onlyOwner public {
604         require(
605             newAttackPrize < 5,
606             "max prize is 5 percent of funds"
607         );
608         maxAttackPrizePercent = newAttackPrize;
609     }
610 
611     function setMaxOpenAttacks(uint newValue) onlyOwner public {
612         maxOpenAttacks = newValue;
613     }
614 
615     function openAttacksCount(address user) view public returns (uint) {
616         return cntUserAttacks[user];
617     }
618 
619     function isTokenSupported(address token_address) view public returns (bool) {
620         return marketDataOracle.isTokenSupported(token_address);
621     }
622 
623     function getUserScore(address user)
624     view
625     public
626     whenNotPaused
627     returns (uint) {
628         uint cnt_supported_tokens = marketDataOracle.numberOfSupportedTokens();
629         uint aggregated_score = 0;
630         for (uint i=0; i<cnt_supported_tokens; i++) {
631             (address token_address, uint volume, uint depth, uint marketcap) = marketDataOracle.getMarketDataByTokenIdx(i);
632             uint256 user_balance = balanceOf(token_address, user);
633 
634             aggregated_score = aggregated_score + _calculateScore(user_balance, volume, depth, marketcap);
635         }
636 
637         return aggregated_score;
638     }
639 
640     function _calculateScore(uint256 balance, uint volume, uint depth, uint marketcap) pure internal returns (uint) {
641         return balance * volume * depth * marketcap;
642     }
643 
644     function attack(address attackee)
645     external
646     activeUserOnly(msg.sender)
647     activeUserOnly(attackee)
648     {
649         require(
650             msg.sender != attackee,
651             "Can't attack yourself"
652         );
653         require(
654             userToUserToAttackId[msg.sender][attackee] == 0,
655             "Cannot attack while pending attack exists, please complete attack"
656         );
657         require(
658             openAttacksCount(msg.sender) < maxOpenAttacks,
659             "Too many open attacks for attacker"
660         );
661         require(
662             openAttacksCount(attackee) < maxOpenAttacks,
663             "Too many open attacks for attackee"
664         );
665 
666         (uint attackPrizePercent, uint attackerScore, uint attackeeScore) = attackPrizeRatio(attackee);
667 
668         AttackInfo memory attackInfo = AttackInfo(
669             msg.sender,
670             attackee,
671             attackerScore,
672             attackeeScore,
673             sha256(abi.encodePacked(msg.sender, attackee, block.blockhash(block.number-1))), // attack Id
674             false,
675             block.number // block after insertion of attack tx the complete function can be called
676         );
677         _registerAttack(attackInfo);
678 
679         _calculateWinnings(attackIdToInfo[attackInfo.attackId], attackPrizePercent);
680 
681         emit Attack(
682             attackInfo.attacker,
683             attackInfo.attackee,
684             attackInfo.attackId,
685             attackPrizePercent,
686             attackPricePrecentBase,
687             attackInfo.hodlSpellBlockNumber
688         );
689     }
690 
691     /**
692     *   Returns the % of the attacker/ attackee funds are for winning/ loosing
693     *   we multiple the values by a base since solidity does not support
694     *   floating values.
695     */
696     function attackPrizeRatio(address attackee)
697     view
698     public
699     returns (uint attackPrizePercent, uint attackerScore, uint attackeeScore) {
700         uint _attackerScore = getUserScore(msg.sender);
701         require(
702             _attackerScore > 0,
703             "attacker score is 0"
704         );
705         uint _attackeeScore = getUserScore(attackee);
706         require(
707             _attackeeScore > 0,
708             "attackee score is 0"
709         );
710 
711         uint howCloseAreThey = _attackeeScore.mul(attackPricePrecentBase).div(_attackerScore);
712 
713         return (howCloseAreThey, _attackerScore, _attackeeScore);
714     }
715 
716     function attackerPrizeByToken(bytes32 attackId, address token_address) view public returns (uint256) {
717         return attackIdToInfo[attackId].attackerWinnings[token_address];
718     }
719 
720     function attackeePrizeByToken(bytes32 attackId, address token_address) view public returns (uint256) {
721         return attackIdToInfo[attackId].attackeeWinnings[token_address];
722     }
723 
724     // anyone can call the complete attack function.
725     function completeAttack(bytes32 attackId) public {
726         AttackInfo storage attackInfo = attackIdToInfo[attackId];
727 
728         (address winner, uint attackeeActualScore) = getWinner(attackId);
729 
730         // distribuite winngs
731         uint cnt_supported_tokens = marketDataOracle.numberOfSupportedTokens();
732         for (uint i=0; i<cnt_supported_tokens; i++) {
733             (address token_address, bool status) = marketDataOracle.getSupportedTokenByIndex(i);
734 
735             if (attackInfo.attacker == winner) {
736                 uint winnings = attackInfo.attackerWinnings[token_address];
737 
738                 if (winnings > 0) {
739                     tokens[token_address][attackInfo.attackee] = tokens[token_address][attackInfo.attackee].sub(winnings);
740                     tokens[token_address][attackInfo.attacker] = tokens[token_address][attackInfo.attacker].add(winnings);
741                 }
742             }
743             else {
744                 uint loosings = attackInfo.attackeeWinnings[token_address];
745 
746                 if (loosings > 0) {
747                     tokens[token_address][attackInfo.attacker] = tokens[token_address][attackInfo.attacker].sub(loosings);
748                     tokens[token_address][attackInfo.attackee] = tokens[token_address][attackInfo.attackee].add(loosings);
749                 }
750             }
751         }
752 
753         // cleanup
754         _unregisterAttack(attackId);
755 
756         emit AttackCompleted(
757             attackId,
758             winner,
759             attackeeActualScore
760         );
761     }
762 
763     function getWinner(bytes32 attackId) public view returns(address winner, uint attackeeActualScore) {
764         require(
765             block.number >= attackInfo.hodlSpellBlockNumber,
766             "attack can not be completed at this block, please wait"
767         );
768 
769         AttackInfo storage attackInfo = attackIdToInfo[attackId];
770 
771         //  block.blockhash records only for the recent 256 blocks
772         //  https://solidity.readthedocs.io/en/v0.3.1/units-and-global-variables.html#block-and-transaction-properties
773         //  So... attacker has 256 blocks to call completeAttack
774         //  otherwise win goes automatically to the attackee
775         if (block.number - attackInfo.hodlSpellBlockNumber >= 256) {
776             return (attackInfo.attackee, attackInfo.attackeeScore);
777         }
778 
779         bytes32 blockHash = block.blockhash(attackInfo.hodlSpellBlockNumber);
780         return _calculateWinnerBasedOnEntropy(attackInfo, blockHash);
781     }
782 
783     ////////////////////////////////////////////////////////
784     //
785     //  internal functions
786     //
787     ////////////////////////////////////////////////////////
788 
789     // validates user active status
790     function _validateUserActive(address user) private {
791         // get CDT balance
792         uint256 cdt_balance = balanceOf(cdtTokenAddress, user);
793 
794         bool new_active_state = cdt_balance >= minCDTToParticipate;
795         bool current_active_state = activeUsers[user]; // could be false if never set up
796 
797         if (current_active_state != new_active_state) { // only emit on activity change
798             emit UserActiveStatusChanged(user, new_active_state);
799         }
800 
801         activeUsers[user] = new_active_state;
802     }
803 
804     function _registerAttack(AttackInfo attackInfo) internal {
805         userToUserToAttackId[attackInfo.attacker][attackInfo.attackee] = attackInfo.attackId;
806         userToUserToAttackId[attackInfo.attackee][attackInfo.attacker] = attackInfo.attackId;
807 
808         attackIdToInfo[attackInfo.attackId] = attackInfo;
809 
810         // update open attacks counter
811         cntUserAttacks[attackInfo.attacker] = cntUserAttacks[attackInfo.attacker].add(1);
812         cntUserAttacks[attackInfo.attackee] = cntUserAttacks[attackInfo.attackee].add(1);
813     }
814 
815     function _unregisterAttack(bytes32 attackId) internal {
816         AttackInfo storage attackInfo = attackIdToInfo[attackId];
817 
818         cntUserAttacks[attackInfo.attacker] = cntUserAttacks[attackInfo.attacker].sub(1);
819         cntUserAttacks[attackInfo.attackee] = cntUserAttacks[attackInfo.attackee].sub(1);
820 
821         delete userToUserToAttackId[attackInfo.attacker][attackInfo.attackee];
822         delete userToUserToAttackId[attackInfo.attackee][attackInfo.attacker];
823 
824         delete attackIdToInfo[attackId];
825     }
826 
827     /**
828        if the attacker has a higher/ equal score to the attackee than the prize will be at max maxAttackPrizePercent
829        if the attacker has lower score than the prize can be higher than maxAttackPrizePercent since he takes a bigger risk
830    */
831     function _calculateWinnings(AttackInfo storage attackInfo, uint attackPrizePercent) internal {
832         // get all user balances and calc winnings from that
833         uint cnt_supported_tokens = marketDataOracle.numberOfSupportedTokens();
834 
835         uint actualPrizeRation = attackPrizePercent
836         .mul(maxAttackPrizePercent);
837 
838 
839         for (uint i=0; i<cnt_supported_tokens; i++) {
840             (address token_address, bool status) = marketDataOracle.getSupportedTokenByIndex(i);
841 
842             if (status) {
843                 // attacker
844                 uint256 _b1 = balanceOf(token_address, attackInfo.attacker);
845                 if (_b1 > 0) {
846                     uint256 _w1 = _b1.mul(actualPrizeRation).div(attackPricePrecentBase * 100); // 100 since maxAttackPrizePercent has 100 basis
847                     attackInfo.attackeeWinnings[token_address] = _w1;
848                 }
849 
850                 // attackee
851                 uint256 _b2 = balanceOf(token_address, attackInfo.attackee);
852                 if (_b2 > 0) {
853                     uint256 _w2 = _b2.mul(actualPrizeRation).div(attackPricePrecentBase * 100); // 100 since maxAttackPrizePercent has 100 basis
854                     attackInfo.attackerWinnings[token_address] = _w2;
855                 }
856             }
857         }
858     }
859 
860     //
861     // winner logic:
862     //  1) get difference in scores between players times 2
863     //  2) get hodl spell block number (decided in the attack call), do hash % {result of step 1}
864     //  3) block hash mod 10 to decide direction
865     //  4) if result step 3 > 1 than we add result step 2 to attackee's score (80% chance for this to happen)
866     //  5) else reduce attacke's score by result of step 2
867     //
868     //
869     //
870     // Since the attacker decides if to attack or not we give the attackee a defending chance by
871     // adopting the random HODL spell.
872     // if the attacker has a higher score than attackee than the HODL spell will randomly add (most probably) to the
873     // attackee score. this might or might not be enought to beat the attacker.
874     //
875     // if the attacker has a lower score than the attackee than he takes a bigger chance in attacking and he will get a bigger reward.
876     //
877     //
878     // just like in crypto life, HODLing has its risks and rewards. Be carefull in your trading decisions!
879     function _calculateWinnerBasedOnEntropy(AttackInfo storage attackInfo, bytes32 entropy) view internal returns(address, uint) {
880         uint attackeeActualScore = attackInfo.attackeeScore;
881         uint modul = _absSubtraction(attackInfo.attackerScore, attackInfo.attackeeScore);
882         modul = modul.mul(2); // attacker score is now right in the middle of the range
883         uint hodlSpell = uint(entropy) % modul;
884         uint direction = uint(entropy) % 10;
885         uint directionThreshold = 1;
886 
887         // direction is 80% chance positive (meaning adding the hodl spell)
888         // to the weakest player
889         if (attackInfo.attackerScore < attackInfo.attackeeScore) {
890             directionThreshold = 8;
891         }
892 
893         // winner calculation
894         if (direction > directionThreshold) {
895             attackeeActualScore = attackeeActualScore.add(hodlSpell);
896         }
897         else {
898             attackeeActualScore = _safeSubtract(attackeeActualScore, hodlSpell);
899         }
900         if (attackInfo.attackerScore > attackeeActualScore) { return (attackInfo.attacker, attackeeActualScore); }
901         else { return (attackInfo.attackee, attackeeActualScore); }
902     }
903 
904     // will subtract 2 uint and returns abs(result).
905     // example: a=2,b=3 returns 1
906     // example: a=3,b=2 returns 1
907     function _absSubtraction(uint a, uint b) pure internal returns (uint) {
908         if (b>a) {
909             return b-a;
910         }
911 
912         return a-b;
913     }
914 
915     // example: a=2,b=3 returns 0
916     // example: a=3,b=2 returns 1
917     function _safeSubtract(uint a, uint b) pure internal returns (uint) {
918         if (b > a) {
919             return 0;
920         }
921 
922         return a-b;
923     }
924 }