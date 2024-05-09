1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.18;
7 
8 
9 /*************************************************************************
10  * import "zeppelin-solidity/contracts/math/SafeMath.sol" : start
11  *************************************************************************/
12 
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 /*************************************************************************
47  * import "zeppelin-solidity/contracts/math/SafeMath.sol" : end
48  *************************************************************************/
49 /*************************************************************************
50  * import "zeppelin-solidity/contracts/token/MintableToken.sol" : start
51  *************************************************************************/
52 
53 
54 /*************************************************************************
55  * import "./StandardToken.sol" : start
56  *************************************************************************/
57 
58 
59 /*************************************************************************
60  * import "./BasicToken.sol" : start
61  *************************************************************************/
62 
63 
64 /*************************************************************************
65  * import "./ERC20Basic.sol" : start
66  *************************************************************************/
67 
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   uint256 public totalSupply;
76   function balanceOf(address who) public view returns (uint256);
77   function transfer(address to, uint256 value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 /*************************************************************************
81  * import "./ERC20Basic.sol" : end
82  *************************************************************************/
83 
84 
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
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     // SafeMath.sub will throw if there is not enough balance.
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public view returns (uint256 balance) {
117     return balances[_owner];
118   }
119 
120 }
121 /*************************************************************************
122  * import "./BasicToken.sol" : end
123  *************************************************************************/
124 /*************************************************************************
125  * import "./ERC20.sol" : start
126  *************************************************************************/
127 
128 
129 
130 
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender) public view returns (uint256);
138   function transferFrom(address from, address to, uint256 value) public returns (bool);
139   function approve(address spender, uint256 value) public returns (bool);
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141 }
142 /*************************************************************************
143  * import "./ERC20.sol" : end
144  *************************************************************************/
145 
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * @dev https://github.com/ethereum/EIPs/issues/20
152  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract StandardToken is ERC20, BasicToken {
155 
156   mapping (address => mapping (address => uint256)) internal allowed;
157 
158 
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param _from address The address which you want to send tokens from
162    * @param _to address The address which you want to transfer to
163    * @param _value uint256 the amount of tokens to be transferred
164    */
165   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[_from]);
168     require(_value <= allowed[_from][msg.sender]);
169 
170     balances[_from] = balances[_from].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173     Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    *
180    * Beware that changing an allowance with this method brings the risk that someone may use both the old
181    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184    * @param _spender The address which will spend the funds.
185    * @param _value The amount of tokens to be spent.
186    */
187   function approve(address _spender, uint256 _value) public returns (bool) {
188     allowed[msg.sender][_spender] = _value;
189     Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(address _owner, address _spender) public view returns (uint256) {
200     return allowed[_owner][_spender];
201   }
202 
203   /**
204    * approve should be called when allowed[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    */
209   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
210     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
216     uint oldValue = allowed[msg.sender][_spender];
217     if (_subtractedValue > oldValue) {
218       allowed[msg.sender][_spender] = 0;
219     } else {
220       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221     }
222     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226 }
227 /*************************************************************************
228  * import "./StandardToken.sol" : end
229  *************************************************************************/
230 /*************************************************************************
231  * import "../ownership/Ownable.sol" : start
232  *************************************************************************/
233 
234 
235 /**
236  * @title Ownable
237  * @dev The Ownable contract has an owner address, and provides basic authorization control
238  * functions, this simplifies the implementation of "user permissions".
239  */
240 contract Ownable {
241   address public owner;
242 
243 
244   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
245 
246 
247   /**
248    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
249    * account.
250    */
251   function Ownable() public {
252     owner = msg.sender;
253   }
254 
255 
256   /**
257    * @dev Throws if called by any account other than the owner.
258    */
259   modifier onlyOwner() {
260     require(msg.sender == owner);
261     _;
262   }
263 
264 
265   /**
266    * @dev Allows the current owner to transfer control of the contract to a newOwner.
267    * @param newOwner The address to transfer ownership to.
268    */
269   function transferOwnership(address newOwner) public onlyOwner {
270     require(newOwner != address(0));
271     OwnershipTransferred(owner, newOwner);
272     owner = newOwner;
273   }
274 
275 }
276 /*************************************************************************
277  * import "../ownership/Ownable.sol" : end
278  *************************************************************************/
279 
280 
281 
282 /**
283  * @title Mintable token
284  * @dev Simple ERC20 Token example, with mintable token creation
285  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
286  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
287  */
288 
289 contract MintableToken is StandardToken, Ownable {
290   event Mint(address indexed to, uint256 amount);
291   event MintFinished();
292 
293   bool public mintingFinished = false;
294 
295 
296   modifier canMint() {
297     require(!mintingFinished);
298     _;
299   }
300 
301   /**
302    * @dev Function to mint tokens
303    * @param _to The address that will receive the minted tokens.
304    * @param _amount The amount of tokens to mint.
305    * @return A boolean that indicates if the operation was successful.
306    */
307   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
308     totalSupply = totalSupply.add(_amount);
309     balances[_to] = balances[_to].add(_amount);
310     Mint(_to, _amount);
311     Transfer(address(0), _to, _amount);
312     return true;
313   }
314 
315   /**
316    * @dev Function to stop minting new tokens.
317    * @return True if the operation was successful.
318    */
319   function finishMinting() onlyOwner canMint public returns (bool) {
320     mintingFinished = true;
321     MintFinished();
322     return true;
323   }
324 }
325 /*************************************************************************
326  * import "zeppelin-solidity/contracts/token/MintableToken.sol" : end
327  *************************************************************************/
328 
329 
330 contract SuperMegaTestToken is MintableToken {
331 
332     /* Token constants */
333 
334     string public name = "SPDToken";
335 
336     string public symbol = "SPD";
337 
338     uint public decimals = 6;
339 
340     /* Blocks token transfers until ICO is finished.*/
341     bool public tokensBlocked = true;
342 
343     // list of addresses with time-freezend tokens
344     mapping (address => uint) public teamTokensFreeze;
345 
346     event debugLog(string key, uint value);
347 
348 
349 
350 
351     /* Allow token transfer.*/
352     function unblock() external onlyOwner {
353         tokensBlocked = false;
354     }
355 
356     /* Override some function to add support of blocking .*/
357     function transfer(address _to, uint256 _value) public returns (bool) {
358         require(!tokensBlocked);
359         require(allowTokenOperations(_to));
360         require(allowTokenOperations(msg.sender));
361         super.transfer(_to, _value);
362     }
363 
364 
365     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
366         require(!tokensBlocked);
367         require(allowTokenOperations(_from));
368         require(allowTokenOperations(_to));
369         super.transferFrom(_from, _to, _value);
370     }
371 
372     function approve(address _spender, uint256 _value) public returns (bool) {
373         require(!tokensBlocked);
374         require(allowTokenOperations(_spender));
375         super.approve(_spender, _value);
376     }
377 
378     // Hold team/founders tokens for defined time
379     function freezeTokens(address _holder, uint time) public onlyOwner {
380         require(_holder != 0x0);
381         teamTokensFreeze[_holder] = time;
382     }
383 
384     function allowTokenOperations(address _holder) public constant returns (bool) {
385         return teamTokensFreeze[_holder] == 0 || now >= teamTokensFreeze[_holder];
386     }
387 
388 }
389 
390 
391 contract SuperMegaIco {
392     using SafeMath for uint;
393 
394     //==========
395     // Variables
396     //==========
397     //States
398     enum IcoState {Running, Paused, Failed, Finished}
399 
400     // ico successed
401     bool public isSuccess = false;
402 
403     // contract hardcoded owner
404     address public owner = 0x956A9C8879109dFd9B0024634e52a305D8150Cc4;
405     // Start time
406     uint public constant startTime = 1513766000;
407     // End time
408     uint public endTime = startTime + 30 days;
409 
410     // decimals multiplier for calculation & debug
411     uint public constant multiplier = 1000000;
412 
413     // minimal amount of tokens for sale
414     uint private constant minTokens = 50;
415 
416     // one million
417     uint public constant mln = 1000000;
418 
419     // ICO max tokens for sale
420     uint public constant tokensCap = 99 * mln * multiplier;
421 
422     //ICO success
423     uint public constant minSuccess = 17 * mln * multiplier;
424 
425     // Amount of sold tokens
426     uint public totalSupply = 0;
427     // Amount of tokens w/o bonus
428     uint public tokensSoldTotal = 0;
429 
430 
431     // State of ICO - default Running
432     IcoState public icoState = IcoState.Running;
433 
434 
435     // @dev for debug
436     uint private constant rateDivider = 1;
437 
438     // initial price in wei
439     uint public priceInWei = 3046900000 / rateDivider;
440 
441 
442     // robot address
443     address public _robot;// = 0x00a329c0648769A73afAc7F9381E08FB43dBEA72; //
444 
445     // if ICO not finished - we must send all old contract eth to new
446     bool public tokensAreFrozen = true;
447 
448     // The token being sold
449     SuperMegaTestToken public token;
450 
451     // Structure for holding bonuses and tokens for btc investors
452     // We can now deprecate rate/bonus_tokens/value without bitcoin holding mechanism - we don't need it
453     struct TokensHolder {
454     uint value; //amount of wei
455     uint tokens; //amount of tokens
456     uint bonus; //amount of bonus tokens
457     uint total; //total tokens
458     uint rate; //conversion rate for hold moment
459     uint change; //unused wei amount if tx reaches cap
460     }
461 
462     //wei amount
463     mapping (address => uint) public investors;
464 
465     struct teamTokens {
466     address holder;
467     uint freezePeriod;
468     uint percent;
469     uint divider;
470     uint maxTokens;
471     }
472 
473     teamTokens[] public listTeamTokens;
474 
475     // Bonus params
476     uint[] public bonusPatterns = [80, 60, 40, 20];
477 
478     uint[] public bonusLimit = [5 * mln * multiplier, 10 * mln * multiplier, 15 * mln * multiplier, 20 * mln * multiplier];
479 
480     // flag to prevent team tokens regen with external call
481     bool public teamTokensGenerated = false;
482 
483 
484     //=========
485     //Modifiers
486     //=========
487 
488     // Active ICO
489     modifier ICOActive {
490         require(icoState == IcoState.Running);
491         require(now >= (startTime));
492         require(now <= (endTime));
493         _;
494     }
495 
496     // Finished ICO
497     modifier ICOFinished {
498         require(icoState == IcoState.Finished);
499         _;
500     }
501 
502     // Failed ICO - time is over 
503     modifier ICOFailed {
504         require(now >= (endTime));
505         require(icoState == IcoState.Failed || !isSuccess);
506         _;
507     }
508 
509 
510     // Allows some methods to be used by team or robot
511     modifier onlyOwner() {
512         require(msg.sender == owner);
513         _;
514     }
515 
516     modifier onlyTeam() {
517         require(msg.sender == owner || msg.sender == _robot);
518         _;
519     }
520 
521     modifier successICOState() {
522         require(isSuccess);
523         _;
524     }
525 
526     
527   
528 
529     //=======
530     // Events
531     //=======
532 
533     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);
534 
535     event RunIco();
536 
537     event PauseIco();
538 
539     event SuccessIco();
540 
541     event FinishIco();
542 
543     event ICOFails();
544 
545     event updateRate(uint time, uint rate);
546 
547     event debugLog(string key, uint value);
548 
549     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
550 
551 
552     //========
553     // Methods
554     //========
555 
556     // Constructor
557     function SuperMegaIco() public {
558         token = new SuperMegaTestToken();
559         if (owner == 0x0) {//owner not set in contract
560             owner = msg.sender;
561         }
562         //uint freezePeriod;
563         //uint percent;
564         //uint divider;
565         //
566 
567 
568         // Company tokens 10%, blocked for 182 days
569         listTeamTokens.push(teamTokens(0xf06ec7eB54298faBB2a90B87204E457c78e2e497, 182 days, 10, 1, 0));
570 
571         // Company tokens 10%, blocked for 1 year
572         listTeamTokens.push(teamTokens(0xF12Cf87978BbCF865B97bD877418397c34bEbAC2, 1 years, 10, 1, 0));
573 
574 
575         // Team tokens 6.667%
576         listTeamTokens.push(teamTokens(0xC01C37c39E073b148100A34368EE6fA4b23D1B58, 0, 3, 1, 0));
577         listTeamTokens.push(teamTokens(0xc02c3399ACa202B56c3930CA51d3Ac2303751cD9, 0, 15, 10, 0));
578         listTeamTokens.push(teamTokens(0xc03d1Be0eaAa2801a88DAcEa173B7c0b1EFd012C, 0, 21667, 10000, 357500 * multiplier));
579 
580         
581         // Team tokens 6.667%, blocked for 1 year
582         listTeamTokens.push(teamTokens(0xC11FCcFf8aae8004A18C89c30135136E1825A3aB, 1 years, 3, 1, 0));
583         listTeamTokens.push(teamTokens(0xC12cE69513b6dBbde644553C1d206d4371134C55, 1 years, 15, 10, 0));
584         listTeamTokens.push(teamTokens(0xc13CC448F0DA5251FBE3ffD94421525A1413c673, 1 years, 21667, 100000, 357500 * multiplier));
585 
586         
587         // Team tokes 6.667%, blocked for 2 years
588         listTeamTokens.push(teamTokens(0xC21BEe33eBc58AE55B898Fe1d723A8F1A8C89248, 2 years, 3, 1, 0));
589         listTeamTokens.push(teamTokens(0xC22AC37471E270aD7026558D4756F2e1A70E1042, 2 years, 15, 10, 0));
590         listTeamTokens.push(teamTokens(0xC23ddd9AeD2d0bFae8006dd68D0dfE1ce04A89D1, 2 years, 21667, 100000, 357500 * multiplier));
591 
592 
593 
594     }
595 
596     // fallback function can be used to buy tokens
597     function() public payable ICOActive {
598         require(!isReachedLimit());
599         TokensHolder memory tokens = calculateTokens(msg.value);
600         require(tokens.total > 0);
601         token.mint(msg.sender, tokens.total);
602         TokenPurchase(msg.sender, msg.sender, tokens.value, tokens.total);
603         if (tokens.change > 0 && tokens.change <= msg.value) {
604             msg.sender.transfer(tokens.change);
605         }
606         investors[msg.sender] = investors[msg.sender].add(tokens.value);
607         addToStat(tokens.tokens, tokens.bonus);
608         manageStatus();
609     }
610 
611     function hasStarted() public constant returns (bool) {
612         return now >= startTime;
613     }
614 
615     function hasFinished() public constant returns (bool) {
616         return now >= endTime || isReachedLimit();
617     }
618 
619     // Calculates amount of bonus tokens
620     function getBonus(uint _value, uint _sold) internal constant returns (TokensHolder) {
621         TokensHolder memory result;
622         uint _bonus = 0;
623 
624         result.tokens = _value;
625         //debugLog('get bonus start - sold', _sold);
626         //debugLog('get bonus start - value', _value);
627         for (uint8 i = 0; _value > 0 && i < bonusLimit.length; ++i) {
628             uint current_bonus_part = 0;
629 
630             if (_value > 0 && _sold < bonusLimit[i]) {
631                 uint bonus_left = bonusLimit[i] - _sold;
632                 //debugLog('start bonus', i);
633                 //debugLog('left for ', bonus_left);
634                 uint _bonusedPart = min(_value, bonus_left);
635                 //debugLog('bonused part for ', _bonusedPart);
636                 current_bonus_part = current_bonus_part.add(percent(_bonusedPart, bonusPatterns[i]));
637                 _value = _value.sub(_bonusedPart);
638                 _sold = _sold.add(_bonusedPart);
639                 //debugLog('sold after  ', _sold);
640             }
641             if (current_bonus_part > 0) {
642                 _bonus = _bonus.add(current_bonus_part);
643             }
644             //debugLog('current_bonus_part ', current_bonus_part);
645 
646         }
647         result.bonus = _bonus;
648         //debugLog('======================================================', 1);
649         return result;
650     }
651 
652 
653 
654     // Are we reached tokens limit?
655     function isReachedLimit() internal constant returns (bool) {
656         return tokensCap.sub(totalSupply) == 0;
657     }
658 
659     function manageStatus() internal {
660         debugLog('after purchase ', totalSupply);
661         if (totalSupply >= minSuccess && !isSuccess) {
662             debugLog('set success state ', 1);
663             successICO();
664         }
665         bool capIsReached = (totalSupply == tokensCap);
666         if (capIsReached || (now >= endTime)) {
667             if (!isSuccess) {
668                 failICO();
669             }
670             else {
671                 autoFinishICO();
672             }
673         }
674     }
675 
676     function calculateForValue(uint value) public constant returns (uint, uint, uint)
677     {
678         TokensHolder memory tokens = calculateTokens(value);
679         return (tokens.total, tokens.tokens, tokens.bonus);
680     }
681 
682     function calculateTokens(uint value) internal constant returns (TokensHolder)
683     {
684         require(value > 0);
685         require(priceInWei * minTokens <= value);
686 
687         uint tokens = value.div(priceInWei);
688         require(tokens > 0);
689         uint remain = tokensCap.sub(totalSupply);
690         uint change = 0;
691         uint value_clear = 0;
692         if (remain <= tokens) {
693             tokens = remain;
694             change = value.sub(tokens.mul(priceInWei));
695             value_clear = value.sub(change);
696         }
697         else {
698             value_clear = value;
699         }
700 
701         TokensHolder memory bonus = getBonus(tokens, tokensSoldTotal);
702 
703         uint total = tokens + bonus.bonus;
704         bonus.tokens = tokens;
705         bonus.total = total;
706         bonus.change = change;
707         bonus.rate = priceInWei;
708         bonus.value = value_clear;
709         return bonus;
710 
711     }
712 
713     // Add tokens&bonus amount to counters
714     function addToStat(uint tokens, uint bonus) internal {
715         uint total = tokens + bonus;
716         totalSupply = totalSupply.add(total);
717         //tokensBought = tokensBought.add(tokens.div(multiplier));
718         //tokensBonus = tokensBonus.add(bonus.div(multiplier));
719         tokensSoldTotal = tokensSoldTotal.add(tokens);
720     }
721 
722     // manual start ico after pause
723     function startIco() external onlyOwner {
724         require(icoState == IcoState.Paused);
725         icoState = IcoState.Running;
726         RunIco();
727     }
728 
729     // manual pause ico
730     function pauseIco() external onlyOwner {
731         require(icoState == IcoState.Running);
732         icoState = IcoState.Paused;
733         PauseIco();
734     }
735 
736     // auto success ico - cat withdraw ether now
737     function successICO() internal
738     {
739         isSuccess = true;
740         SuccessIco();
741     }
742 
743 
744     function autoFinishICO() internal
745     {
746         bool capIsReached = (totalSupply == tokensCap);
747         if (capIsReached && now < endTime) {
748             endTime = now;
749         }
750         icoState = IcoState.Finished;
751         tokensAreFrozen = false;
752         // maybe this must be called as external one-time call
753         token.unblock();
754     }
755 
756     function failICO() internal
757     {
758         icoState = IcoState.Failed;
759         ICOFails();
760     }
761 
762 
763     function refund() public ICOFailed
764     {
765         require(msg.sender != 0x0);
766         require(investors[msg.sender] > 0);
767         uint refundVal = investors[msg.sender];
768         investors[msg.sender] = 0;
769 
770         uint balance = token.balanceOf(msg.sender);
771         totalSupply = totalSupply.sub(balance);
772         msg.sender.transfer(refundVal);
773 
774     }
775 
776     // Withdraw allowed only on success
777     function withdraw(uint value) external onlyOwner successICOState {
778         owner.transfer(value);
779     }
780 
781     // Generates team tokens after ICO finished
782     function generateTeamTokens() internal ICOFinished {
783         require(!teamTokensGenerated);
784         teamTokensGenerated = true;
785         uint totalSupplyTokens = totalSupply;
786         debugLog('totalSupplyTokens', totalSupplyTokens);
787         totalSupplyTokens = totalSupplyTokens.mul(100);
788         debugLog('totalSupplyTokens div 60', totalSupplyTokens);
789         totalSupplyTokens = totalSupplyTokens.div(60);
790         debugLog('totalSupplyTokens mul 100', totalSupplyTokens);
791 
792         for (uint8 i = 0; i < listTeamTokens.length; ++i) {
793             uint teamTokensPart = percent(totalSupplyTokens, listTeamTokens[i].percent);
794 
795             if (listTeamTokens[i].divider != 0) {
796                 teamTokensPart = teamTokensPart.div(listTeamTokens[i].divider);
797             }
798 
799             if (listTeamTokens[i].maxTokens != 0 && listTeamTokens[i].maxTokens < teamTokensPart) {
800                 teamTokensPart = listTeamTokens[i].maxTokens;
801             }
802 
803             token.mint(listTeamTokens[i].holder, teamTokensPart);
804 
805             debugLog('teamTokensPart index ', i);
806             debugLog('teamTokensPart value ', teamTokensPart);
807             debugLog('teamTokensPart max is  ', listTeamTokens[i].maxTokens);
808             
809             if(listTeamTokens[i].freezePeriod != 0) {
810                 debugLog('freeze add ', listTeamTokens[i].freezePeriod);
811                 debugLog('freeze now + add ', now + listTeamTokens[i].freezePeriod);
812                 token.freezeTokens(listTeamTokens[i].holder, endTime + listTeamTokens[i].freezePeriod);
813             }
814             addToStat(teamTokensPart, 0);
815             
816 
817 
818         }
819 
820     }
821 
822     function transferOwnership(address newOwner) public onlyOwner {
823         require(newOwner != address(0));
824         OwnershipTransferred(owner, newOwner);
825         owner = newOwner;
826     }
827 
828 
829     //==========================
830     // Methods for bots requests
831     //==========================
832     // set/update robot address
833     function setRobot(address robot) public onlyOwner {
834         require(robot != 0x0);
835         _robot = robot;
836     }
837 
838     // update token price in wei
839     function setRate(uint newRate) public onlyTeam {
840         require(newRate > 0);
841         //todo min rate check! 0 - for debug
842         priceInWei = newRate;
843         updateRate(now, newRate);
844     }
845 
846     // mb deprecated
847     function robotRefund(address investor) public onlyTeam ICOFailed
848     {
849         require(investor != 0x0);
850         require(investors[investor] > 0);
851         uint refundVal = investors[investor];
852         investors[investor] = 0;
853 
854         uint balance = token.balanceOf(investor);
855         totalSupply = totalSupply.sub(balance);
856         investor.transfer(refundVal);
857     }
858 
859     function autoFinishTime() public onlyTeam
860     {
861         require(hasFinished());
862         manageStatus();
863         generateTeamTokens();
864     }
865 
866     //dev method for debugging
867     function setEndTime(uint time) public onlyTeam {
868         require(time > 0 && time > now);
869         endTime = now;
870     }
871     //
872     //    function getBonusPercent() public constant returns (uint) {
873     //        for (uint8 i = 0; i < bonusLimit.length; ++i) {
874     //           if(totalSupply < bonusLimit[i]) {
875     //               return bonusPatterns[i];
876     //            }
877     //        }
878     //        return 0;
879     //   }
880     //========
881     // Helpers
882     //========
883 
884     // calculation of min value
885     function min(uint a, uint b) internal pure returns (uint) {
886         return a < b ? a : b;
887     }
888 
889 
890     function percent(uint value, uint bonus) internal pure returns (uint) {
891         return (value * bonus).div(100);
892     }
893 
894     /**
895     * @dev Transfers the current balance to the owner and terminates the contract.
896     */
897     function destroy() onlyOwner public {
898         selfdestruct(owner);
899     }
900 
901 }