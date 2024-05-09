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
330 contract S25 is MintableToken {
331 
332     /* Token constants */
333 
334     string public name = "SuperGidron25";
335 
336     string public symbol = "S25";
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
391 contract S25ICO {
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
404     address public owner = 0xfFFafD9849e0b678a879E92581e1eF4729C65d00;// 0x987ddcbf60a5ab0206b32ca9dde2595e182f54e1;// = 0x00a329c0648769A73afAc7F9381E08FB43dBEA72;
405     address public wallet = 0xdDd1BB2F9BF1EEc3A11230de23b3e69Dee7665f8;//deploy 0x4A536E9F10c19112C33DEA04BFC62216792a197D;
406     address public unsold = 0xffC7086F6dB8d9A1545eA643aaDf4Da96668fC60; //
407     // Start time
408     uint public constant startTime = 1529761145;
409     // End time
410     uint public endTime = startTime + 30 days;
411 
412     // decimals multiplier for calculation & debug
413     uint public constant multiplier = 1000000;
414 
415     // minimal amount of tokens for sale
416     uint private constant minTokens = 50;
417 
418     // one million
419     uint public constant mln = 1000000;
420 
421     // ICO max tokens for sale
422     uint public constant tokensCap = 99 * mln * multiplier;
423 
424     //ICO success
425     uint public constant minSuccess = 2 * mln * multiplier;
426 
427     // Amount of sold tokens
428     uint public totalSupply = 0;
429     // Amount of tokens w/o bonus
430     uint public tokensSoldTotal = 0;
431 
432 
433     // State of ICO - default Running
434     IcoState public icoState = IcoState.Running;
435 
436 
437     // @dev for debug
438     uint private constant rateDivider = 1;
439 
440     // initial price in wei
441     uint public priceInWei = 3046900000 / rateDivider;
442 
443 
444     // robot address
445     address public _robot = 0x63b247db491D3d3E32A9629509Fb459386Aff921;// = 0x00a329c0648769A73afAc7F9381E08FB43dBEA72; //
446 
447     // if ICO not finished - we must send all old contract eth to new
448     bool public tokensAreFrozen = true;
449 
450     // The token being sold
451     S25 public token;
452 
453     // Structure for holding bonuses and tokens for btc investors
454     // We can now deprecate rate/bonus_tokens/value without bitcoin holding mechanism - we don't need it
455     struct TokensHolder {
456     uint value; //amount of wei
457     uint tokens; //amount of tokens
458     uint bonus; //amount of bonus tokens
459     uint total; //total tokens
460     uint rate; //conversion rate for hold moment
461     uint change; //unused wei amount if tx reaches cap
462     }
463 
464     //wei amount
465     mapping (address => uint) public investors;
466 
467     struct teamTokens {
468     address holder;
469     uint freezePeriod;
470     uint percent;
471     uint divider;
472     uint maxTokens;
473     }
474 
475     teamTokens[] public listTeamTokens;
476 
477     // Bonus params
478     uint[] public bonusPatterns = [80, 60, 40, 20];
479 
480     uint[] public bonusLimit = [5 * mln * multiplier, 10 * mln * multiplier, 15 * mln * multiplier, 20 * mln * multiplier];
481 
482     // flag to prevent team tokens regen with external call
483     bool public teamTokensGenerated = false;
484 
485 
486     //=========
487     //Modifiers
488     //=========
489 
490     // Active ICO
491     modifier ICOActive {
492         require(icoState == IcoState.Running);
493         require(now >= (startTime));
494         require(now <= (endTime));
495         _;
496     }
497 
498     // Finished ICO
499     modifier ICOFinished {
500         require(icoState == IcoState.Finished);
501         _;
502     }
503 
504     // Failed ICO - time is over 
505     modifier ICOFailed {
506         require(now >= (endTime));
507         require(icoState == IcoState.Failed || !isSuccess);
508         _;
509     }
510 
511 
512     // Allows some methods to be used by team or robot
513     modifier onlyOwner() {
514         require(msg.sender == owner);
515         _;
516     }
517 
518     modifier onlyTeam() {
519         require(msg.sender == owner || msg.sender == _robot);
520         _;
521     }
522 
523     modifier successICOState() {
524         require(isSuccess);
525         _;
526     }
527 
528     
529   
530 
531     //=======
532     // Events
533     //=======
534 
535     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);
536 
537     event RunIco();
538 
539     event PauseIco();
540 
541     event SuccessIco();
542 
543     
544     event ICOFails();
545 
546     event updateRate(uint time, uint rate);
547 
548     event debugLog(string key, uint value);
549 
550     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
551 
552 
553     //========
554     // Methods
555     //========
556 
557     // Constructor
558     function S25ICO() public {
559         token = new S25();
560         //if (owner == 0x0) {//owner not set in contract
561         //    owner = msg.sender;
562         //}
563         //uint freezePeriod;
564         //uint percent;
565         //uint divider;
566         //
567 
568         
569         // Company tokens 10%, blocked for 182 days
570         listTeamTokens.push(teamTokens(0xAaa1C6f83F2D6eab13aD341a2b3Ff8d8976fcE64, 182 days, 10, 1, 0));
571 
572         // Company tokens 10%, blocked for 1 year
573         listTeamTokens.push(teamTokens(0xAAa27079007bCe64f0a5B225FB0aFec175d69ca5, 1 years, 10, 1, 0));
574 
575 
576         // Team tokens 6.667%
577         listTeamTokens.push(teamTokens(0xAaa315b6640d2Af971C2Ab3a5c2af1209A8C0083, 0, 32, 10, 0));
578         listTeamTokens.push(teamTokens(0xAAA34a3F68e079DdaEf9566c5E7b1507F1d545B3, 0, 16, 10, 0));
579         listTeamTokens.push(teamTokens(0xaAa351aD60699729CaF0cc0812477Ee73d00a611, 0, 16, 10, 0));
580         listTeamTokens.push(teamTokens(0xaAA383c35390DC0E112CA5a46f768650F5C11C29, 0, 200, 1000, 0));
581         listTeamTokens.push(teamTokens(0xAaa3f9dE05E5d9c5CF2D79fDF99aBb8a9bE4b403, 0, 6670, 100000, 0));
582         
583         
584         // Team tokens 6.667%, blocked for 1 year
585         listTeamTokens.push(teamTokens(0xaAa417D941a7c49d858451B423e83355d10b68C8, 1 years, 32, 1, 0));
586         listTeamTokens.push(teamTokens(0xAAa42b7755517Db92379D43a2C5a5161a0DBa5fe, 1 years, 16, 1, 0));
587         listTeamTokens.push(teamTokens(0xAAA47837A6751Ba35B9e9C52bD156a434b6a5B6a, 1 years, 16, 1, 0));
588         listTeamTokens.push(teamTokens(0xAaa485EC95febED46628FBEA1Cd6f8404378C90d, 1 years, 200, 1000, 0));
589         listTeamTokens.push(teamTokens(0xAaA52924D1F18d90148D45fa020DEB5F5f755E51, 1 years, 6670, 100000, 0));
590 
591   
592         // Team tokes 6.667%, blocked for 2 years
593         listTeamTokens.push(teamTokens(0xAAa6e7638AF0dE4233101BE9841C8BD1890dd2e6, 2 years, 32, 1, 0));
594         listTeamTokens.push(teamTokens(0xAaa7fFb1e7E1f70e94bD35C61FBBd5681c06025c, 2 years, 16, 1, 0));
595         listTeamTokens.push(teamTokens(0xaaa92aab966fCC1de934aC700C4e8A322d51D561, 2 years, 16, 1, 0));
596         listTeamTokens.push(teamTokens(0xAaA95183da70778a93F7088A19A1A1c7Af3Bd154, 2 years, 200, 1000, 0));
597         listTeamTokens.push(teamTokens(0xAaa95a9b2Bc5A35Ffc49E6A62C6b71b76B1A61a7, 2 years, 6660, 100000, 0));
598 
599     }
600 
601     // fallback function can be used to buy tokens
602     function() public payable ICOActive {
603         require(!isReachedLimit());
604         TokensHolder memory tokens = calculateTokens(msg.value);
605         require(tokens.total > 0);
606         token.mint(msg.sender, tokens.total);
607         TokenPurchase(msg.sender, msg.sender, tokens.value, tokens.total);
608         if (tokens.change > 0 && tokens.change <= msg.value) {
609             msg.sender.transfer(tokens.change);
610         }
611         investors[msg.sender] = investors[msg.sender].add(tokens.value);
612         addToStat(tokens.tokens, tokens.bonus);
613         manageStatus();
614     }
615 
616     function hasStarted() public constant returns (bool) {
617         return now >= startTime;
618     }
619 
620     function hasFinished() public constant returns (bool) {
621         return now >= endTime || isReachedLimit();
622     }
623 
624     // Calculates amount of bonus tokens
625     function getBonus(uint _value, uint _sold) internal constant returns (TokensHolder) {
626         TokensHolder memory result;
627         uint _bonus = 0;
628 
629         result.tokens = _value;
630         for (uint8 i = 0; _value > 0 && i < bonusLimit.length; ++i) {
631             uint current_bonus_part = 0;
632 
633             if (_value > 0 && _sold < bonusLimit[i]) {
634                 uint bonus_left = bonusLimit[i] - _sold;
635                 uint _bonusedPart = min(_value, bonus_left);
636                 current_bonus_part = current_bonus_part.add(percent(_bonusedPart, bonusPatterns[i]));
637                 _value = _value.sub(_bonusedPart);
638                 _sold = _sold.add(_bonusedPart);                
639             }
640             if (current_bonus_part > 0) {
641                 _bonus = _bonus.add(current_bonus_part);
642             }
643             
644         }
645         result.bonus = _bonus;
646         return result;
647     }
648 
649 
650 
651     // Are we reached tokens limit?
652     function isReachedLimit() internal constant returns (bool) {
653         return tokensCap.sub(totalSupply) == 0;
654     }
655 
656     function manageStatus() internal {
657         if (totalSupply >= minSuccess && !isSuccess) {
658             successICO();
659         }
660         bool capIsReached = (totalSupply == tokensCap);
661         if (capIsReached || (now >= endTime)) {
662             if (!isSuccess) {
663                 failICO();
664             }
665             else {
666                 finishICO(false);
667             }
668         }
669     }
670 
671     function calculateForValue(uint value) public constant returns (uint, uint, uint)
672     {
673         TokensHolder memory tokens = calculateTokens(value);
674         return (tokens.total, tokens.tokens, tokens.bonus);
675     }
676 
677     function calculateTokens(uint value) internal constant returns (TokensHolder)
678     {
679         require(value > 0);
680         require(priceInWei * minTokens <= value);
681 
682         uint tokens = value.div(priceInWei);
683         require(tokens > 0);
684         uint remain = tokensCap.sub(totalSupply);
685         uint change = 0;
686         uint value_clear = 0;
687         if (remain <= tokens) {
688             tokens = remain;
689             change = value.sub(tokens.mul(priceInWei));
690             value_clear = value.sub(change);
691         }
692         else {
693             value_clear = value;
694         }
695 
696         TokensHolder memory bonus = getBonus(tokens, tokensSoldTotal);
697 
698         uint total = tokens + bonus.bonus;
699         bonus.tokens = tokens;
700         bonus.total = total;
701         bonus.change = change;
702         bonus.rate = priceInWei;
703         bonus.value = value_clear;
704         return bonus;
705 
706     }
707 
708     // Add tokens&bonus amount to counters
709     function addToStat(uint tokens, uint bonus) internal {
710         uint total = tokens + bonus;
711         totalSupply = totalSupply.add(total);
712         //tokensBought = tokensBought.add(tokens.div(multiplier));
713         //tokensBonus = tokensBonus.add(bonus.div(multiplier));
714         tokensSoldTotal = tokensSoldTotal.add(tokens);
715     }
716 
717     // manual start ico after pause
718     function startIco() external onlyOwner {
719         require(icoState == IcoState.Paused);
720         icoState = IcoState.Running;
721         RunIco();
722     }
723 
724     // manual pause ico
725     function pauseIco() external onlyOwner {
726         require(icoState == IcoState.Running);
727         icoState = IcoState.Paused;
728         PauseIco();
729     }
730 
731     // auto success ico - cat withdraw ether now
732     function successICO() internal
733     {
734         isSuccess = true;
735         SuccessIco();
736     }
737 
738 
739     function finishICO(bool manualFinish) internal successICOState
740     {
741         if(!manualFinish) {
742             bool capIsReached = (totalSupply == tokensCap);
743             if (capIsReached && now < endTime) {
744                 endTime = now;
745             }
746         } else {
747             endTime = now;
748         }
749         icoState = IcoState.Finished;
750         tokensAreFrozen = false;
751         // maybe this must be called as external one-time call
752         token.unblock();
753     }
754 
755     function failICO() internal
756     {
757         icoState = IcoState.Failed;
758         ICOFails();
759     }
760 
761 
762     function refund() public ICOFailed
763     {
764         require(msg.sender != 0x0);
765         require(investors[msg.sender] > 0);
766         uint refundVal = investors[msg.sender];
767         investors[msg.sender] = 0;
768 
769         uint balance = token.balanceOf(msg.sender);
770         totalSupply = totalSupply.sub(balance);
771         msg.sender.transfer(refundVal);
772 
773     }
774 
775     // Withdraw allowed only on success
776     function withdraw(uint value) external onlyOwner successICOState {
777         wallet.transfer(value);
778     }
779 
780     // Generates team tokens after ICO finished
781     function generateTeamTokens() internal ICOFinished {
782         require(!teamTokensGenerated);
783         teamTokensGenerated = true;
784         if(tokensCap > totalSupply) {
785             //debugLog('before ', totalSupply);
786             uint unsoldAmount = tokensCap.sub(totalSupply);
787             token.mint(unsold, unsoldAmount);
788             //debugLog('unsold ', unsoldAmount);
789             totalSupply = totalSupply.add(unsoldAmount);
790             //debugLog('after ', totalSupply);
791         }
792         uint totalSupplyTokens = totalSupply;
793         totalSupplyTokens = totalSupplyTokens.mul(100);
794         totalSupplyTokens = totalSupplyTokens.div(60);
795         
796         for (uint8 i = 0; i < listTeamTokens.length; ++i) {
797             uint teamTokensPart = percent(totalSupplyTokens, listTeamTokens[i].percent);
798 
799             if (listTeamTokens[i].divider != 0) {
800                 teamTokensPart = teamTokensPart.div(listTeamTokens[i].divider);
801             }
802 
803             if (listTeamTokens[i].maxTokens != 0 && listTeamTokens[i].maxTokens < teamTokensPart) {
804                 teamTokensPart = listTeamTokens[i].maxTokens;
805             }
806 
807             token.mint(listTeamTokens[i].holder, teamTokensPart);
808 
809             
810             if(listTeamTokens[i].freezePeriod != 0) {
811                 token.freezeTokens(listTeamTokens[i].holder, endTime + listTeamTokens[i].freezePeriod);
812             }
813             addToStat(teamTokensPart, 0);
814 
815 
816         }
817 
818     }
819 
820     function transferOwnership(address newOwner) public onlyOwner {
821         require(newOwner != address(0));
822         OwnershipTransferred(owner, newOwner);
823         owner = newOwner;
824     }
825 
826 
827     //==========================
828     // Methods for bots requests
829     //==========================
830     // set/update robot address
831     function setRobot(address robot) public onlyOwner {
832         require(robot != 0x0);
833         _robot = robot;
834     }
835 
836     // update token price in wei
837     function setRate(uint newRate) public onlyTeam {
838         require(newRate > 0);
839         //todo min rate check! 0 - for debug
840         priceInWei = newRate;
841         updateRate(now, newRate);
842     }
843 
844     // mb deprecated
845     function robotRefund(address investor) public onlyTeam ICOFailed
846     {
847         require(investor != 0x0);
848         require(investors[investor] > 0);
849         uint refundVal = investors[investor];
850         investors[investor] = 0;
851 
852         uint balance = token.balanceOf(investor);
853         totalSupply = totalSupply.sub(balance);
854         investor.transfer(refundVal);
855     }
856 
857 
858     function manualFinish() public onlyTeam 
859     {
860         require(!hasFinished());
861         finishICO(true);
862         generateTeamTokens();
863     }
864 
865     function autoFinishTime() public onlyTeam
866     {
867         require(hasFinished());
868         manageStatus();
869         generateTeamTokens();
870     }
871 
872     //========
873     // Helpers
874     //========
875 
876     // calculation of min value
877     function min(uint a, uint b) internal pure returns (uint) {
878         return a < b ? a : b;
879     }
880 
881 
882     function percent(uint value, uint bonus) internal pure returns (uint) {
883         return (value * bonus).div(100);
884     }
885 }