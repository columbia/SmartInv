1 pragma solidity 0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     if (a == 0) {
27       return 0;
28     }
29     c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     // uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return a / b;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
56     c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   uint256 totalSupply_;
73 
74   /**
75   * @dev total number of tokens in existence
76   */
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     emit Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     emit Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     emit Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To decrement
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _subtractedValue The amount of tokens to decrease the allowance by.
202    */
203   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204     uint oldValue = allowed[msg.sender][_spender];
205     if (_subtractedValue > oldValue) {
206       allowed[msg.sender][_spender] = 0;
207     } else {
208       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209     }
210     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214 }
215 
216 
217 /*
218     ERC20 compatible smart contract
219 */
220 contract Token is StandardToken {
221     /* Public variables of the token */
222     string public name;
223 
224     string public version = "0.1";
225 
226     string public symbol;
227 
228     uint8 public decimals;
229 
230     uint256 public creationBlock;
231 
232     /* Initializes contract with initial supply tokens to the creator of the contract */
233     function Token(
234         uint256 initialSupply,
235         string tokenName,
236         uint8 decimalUnits,
237         string tokenSymbol,
238         bool transferAllSupplyToOwner
239     ) public {
240         totalSupply_ = initialSupply;
241 
242         if (transferAllSupplyToOwner) {
243             balances[msg.sender] = initialSupply;
244         } else {
245             balances[this] = initialSupply;
246         }
247 
248         // Set the name for display purposes
249         name = tokenName;
250         // Set the symbol for display purposes
251         symbol = tokenSymbol;
252         // Amount of decimals for display purposes
253         decimals = decimalUnits;
254         // Set creation block
255         creationBlock = block.number;
256     }
257 }
258 
259 
260 
261 /**
262  * @title Ownable
263  * @dev The Ownable contract has an owner address, and provides basic authorization control
264  * functions, this simplifies the implementation of "user permissions".
265  */
266 contract Ownable {
267   address public owner;
268 
269 
270   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272 
273   /**
274    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
275    * account.
276    */
277   function Ownable() public {
278     owner = msg.sender;
279   }
280 
281   /**
282    * @dev Throws if called by any account other than the owner.
283    */
284   modifier onlyOwner() {
285     require(msg.sender == owner);
286     _;
287   }
288 
289   /**
290    * @dev Allows the current owner to transfer control of the contract to a newOwner.
291    * @param newOwner The address to transfer ownership to.
292    */
293   function transferOwnership(address newOwner) public onlyOwner {
294     require(newOwner != address(0));
295     emit OwnershipTransferred(owner, newOwner);
296     owner = newOwner;
297   }
298 
299 }
300 
301 
302 contract Multivest is Ownable {
303     /* public variables */
304     mapping(address => bool) public allowedMultivests;
305 
306     /* events */
307     event Contribution(address _holder, uint256 value, uint256 tokens);
308     
309     /* modifier */
310     modifier onlyPayloadSize(uint size) {
311         assert(msg.data.length >= size + 4);
312         _;
313     }
314 
315     modifier onlyAllowedMultivests() {
316         require(true == allowedMultivests[msg.sender]);
317         _;
318     }
319 
320     /* constructor */
321     function Multivest(address multivest) public {
322         allowedMultivests[multivest] = true;
323     }
324 
325     /* public methods */
326     function setAllowedMultivest(address _address) public onlyOwner {
327         allowedMultivests[_address] = true;
328     }
329 
330     function unsetAllowedMultivest(address _address) public onlyOwner {
331         allowedMultivests[_address] = false;
332     }
333 
334     function multivestBuy(address holder, uint256 value) public onlyPayloadSize(2) onlyAllowedMultivests {
335         bool status = buy(holder, block.timestamp, value);
336         require(status == true);
337     }
338 
339     function buy(address _address, uint256 time, uint256 value) internal returns (bool);
340 }
341 
342 
343 contract Ryfts is Token, Multivest {
344     using SafeMath for uint256;
345 
346     uint256 public allocatedTokensForSale;
347     uint256 public collectedEthers;
348     bool public isRefundAllowed;
349     bool public whitelistActive;
350     bool public phasesSet;
351 
352     bool public locked;
353 
354     mapping (address => uint256) public sentEthers;
355 
356     Phase[] public phases;
357 
358     struct Phase {
359         uint256 price;
360         uint256 since;
361         uint256 till;
362         uint256 allocatedTokens;
363         // min. goal of tokens sold including bonuses
364         uint256 goalMinSoldTokens;
365         uint256 minContribution;
366         uint256 maxContribution;
367         uint256 soldTokens;
368         bool isFinished;
369         mapping (address => bool) whitelist;
370     }
371 
372     event Refund(address holder, uint256 ethers, uint256 tokens);
373 
374     function Ryfts(
375         address _reserveAccount,
376         uint256 _reserveAmount,
377         uint256 _initialSupply,
378         string _tokenName,
379         string _tokenSymbol,
380         address _multivestMiddleware,
381         bool _locked
382     )
383         public
384         Token(_initialSupply, _tokenName, 18, _tokenSymbol, false)
385         Multivest(_multivestMiddleware)
386     {
387         require(_reserveAmount <= _initialSupply);
388 
389         // lock sale
390         locked = _locked;
391 
392         balances[_reserveAccount] = _reserveAmount;
393         balances[this] = balanceOf(this).sub(balanceOf(_reserveAccount));
394 
395         allocatedTokensForSale = balanceOf(this);
396     
397         emit Transfer(this, _reserveAccount, balanceOf(_reserveAccount));
398     }
399 
400     function() public payable {
401         buyTokens();
402     }
403 
404     function setSalePhases(
405         uint256 _preIcoTokenPrice,
406         uint256 _preIcoSince,
407         uint256 _preIcoTill,
408         uint256 _allocatedTokensForPreICO,
409         uint256 _minPreIcoContribution,
410         uint256 _maxPreIcoContribution,
411 
412         uint256 _icoTokenPrice,
413         uint256 _icoSince,
414         uint256 _icoTill,
415         uint256  _goalIcoMinSoldTokens
416     ) public onlyOwner {
417         require(phasesSet == false);
418         require(_allocatedTokensForPreICO < allocatedTokensForSale);
419         require(_goalIcoMinSoldTokens <= allocatedTokensForSale - _allocatedTokensForPreICO);
420         require((_preIcoSince < _preIcoTill) && (_icoSince < _icoTill) && (_preIcoTill <= _icoSince));
421         require(_minPreIcoContribution <= _maxPreIcoContribution);
422         phasesSet = true;
423         phases.push(
424             Phase(
425                 _preIcoTokenPrice,
426                 _preIcoSince,
427                 _preIcoTill,
428                 _allocatedTokensForPreICO,
429                 0,
430                 _minPreIcoContribution,
431                 _maxPreIcoContribution,
432                 0,
433                 false
434             )
435         );
436         phases.push(
437             Phase(
438                 _icoTokenPrice,
439                 _icoSince,
440                 _icoTill,
441                 allocatedTokensForSale - _allocatedTokensForPreICO,
442                 _goalIcoMinSoldTokens,
443                 0,
444                 0,
445                 0,
446                 false
447             )
448         );
449     }
450 
451     function getCurrentPhase(uint256 _time) public constant returns (uint8) {
452         require(phasesSet == true);
453         if (_time == 0) {
454             return uint8(phases.length);
455         }
456         for (uint8 i = 0; i < phases.length; i++) {
457             Phase storage phase = phases[i];
458             if (phase.since > _time) {
459                 continue;
460             }
461 
462             if (phase.till < _time) {
463                 continue;
464             }
465 
466             return i;
467         }
468 
469         return uint8(phases.length);
470     }
471 
472     function getBonusAmount(uint256 time, uint256 amount) public constant returns (uint256) {
473         uint8 currentPhase = getCurrentPhase(time);
474         Phase storage phase = phases[currentPhase];
475 
476         // First 10 mil. have bonus
477         if (phase.soldTokens < 10000000000000000000000000) {
478             return amount.mul(40).div(100);
479         }
480 
481         return 0;
482     }
483 
484     function addToWhitelist(uint8 _phaseId, address _address) public onlyOwner {
485 
486         require(phases.length > _phaseId);
487 
488         Phase storage phase = phases[_phaseId];
489 
490         phase.whitelist[_address] = true;
491 
492     }
493 
494     function removeFromWhitelist(uint8 _phaseId, address _address) public onlyOwner {
495 
496         require(phases.length > _phaseId);
497 
498         Phase storage phase = phases[_phaseId];
499 
500         phase.whitelist[_address] = false;
501     }
502 
503     function setTokenPrice(uint8 _phaseId, uint256 _value) public onlyOwner {
504         require(phases.length > _phaseId);
505         Phase storage phase = phases[_phaseId];
506         phase.price = _value;
507     }
508 
509     function setPeriod(uint8 _phaseId, uint256 _since, uint256 _till) public onlyOwner {
510         require(phases.length > _phaseId);
511         // restrict changing phase after it begins
512         require(now < phase.since);
513 
514         Phase storage phase = phases[_phaseId];
515         phase.since = _since;
516         phase.till = _till;
517     }
518 
519     function setLocked(bool _locked) public onlyOwner {
520         locked = _locked;
521     }
522 
523     function finished(uint8 _phaseId) public returns (bool) {
524         require(phases.length > _phaseId);
525         Phase storage phase = phases[_phaseId];
526 
527         if (phase.isFinished == true) {
528             return true;
529         }
530 
531         uint256 unsoldTokens = phase.allocatedTokens.sub(phase.soldTokens);
532 
533         if (block.timestamp > phase.till || phase.allocatedTokens == phase.soldTokens || balanceOf(this) == 0) {
534             if (_phaseId == 1) {
535                 balances[this] = 0;
536                 emit Transfer(this, address(0), unsoldTokens);
537 
538                 if (phase.soldTokens >= phase.goalMinSoldTokens) {
539                     isRefundAllowed = false;
540                 } else {
541                     isRefundAllowed = true;
542                 }
543             }
544             if (_phaseId == 0) {
545                 if (unsoldTokens > 0) {
546                     transferUnusedTokensToICO(unsoldTokens);
547                     phase.allocatedTokens = phase.soldTokens;
548                 }
549 
550             }
551             phase.isFinished = true;
552 
553         }
554 
555         return phase.isFinished;
556     }
557 
558     function refund() public returns (bool) {
559         return refundInternal(msg.sender);
560     }
561 
562     function refundFor(address holder) public returns (bool) {
563         return refundInternal(holder);
564     }
565 
566     function transferEthers() public onlyOwner {
567         require(false == isActive(1));
568         Phase storage phase = phases[1];
569         if (phase.till <= block.timestamp) {
570             require(phase.isFinished == true && isRefundAllowed == false);
571             owner.transfer(address(this).balance);
572         } else {
573             owner.transfer(address(this).balance);
574         }
575     }
576 
577     function setWhitelistStatus(bool _value) public onlyOwner {
578         whitelistActive = _value;
579     }
580 
581     function setMinMaxContribution(uint8 _phaseId, uint256 _min, uint256 _max) public onlyOwner {
582         require(phases.length > _phaseId);
583         Phase storage phase = phases[_phaseId];
584         require(_min <= _max || _max == 0);
585 
586         phase.minContribution = _min;
587         phase.maxContribution = _max;
588     }
589 
590     function calculateTokensAmount(address _address, uint256 _time, uint256 _value) public constant returns(uint256) {
591         uint8 currentPhase = getCurrentPhase(_time);
592         Phase storage phase = phases[currentPhase];
593 
594         if (true == whitelistActive && phase.whitelist[_address] == false) {
595             return 0;
596         }
597 
598         if (phase.isFinished) {
599             return 0;
600         }
601 
602         if (false == checkValuePermission(currentPhase, _value)) {
603             return 0;
604         }
605 
606         // Check if total investment in phase is lower than max. amount of contribution
607         if (phase.maxContribution != 0 && sentEthers[_address] != 0) {
608             uint allTimeInvestment = sentEthers[_address].add(_value);
609             if (allTimeInvestment > phase.maxContribution) {
610                 return 0;
611             }
612         }
613 
614         return _value.mul(uint256(10) ** decimals).div(phase.price);
615     }
616 
617     // @return true if sale period is active
618     function isActive(uint8 _phaseId) public constant returns (bool) {
619         require(phases.length > _phaseId);
620         Phase storage phase = phases[_phaseId];
621         if (phase.soldTokens > uint256(0) && phase.soldTokens == phase.allocatedTokens) {
622             return false;
623         }
624         return withinPeriod(_phaseId);
625     }
626 
627     // @return true if the transaction can buy tokens
628     function withinPeriod(uint8 _phaseId) public constant returns (bool) {
629         require(phases.length > _phaseId);
630         Phase storage phase = phases[_phaseId];
631         return block.timestamp >= phase.since && block.timestamp <= phase.till;
632     }
633 
634     function buyTokens() public payable {
635         bool status = buy(msg.sender, block.timestamp, msg.value);
636         require(status == true);
637 
638         sentEthers[msg.sender] = sentEthers[msg.sender].add(msg.value);
639     }
640 
641     /* solhint-disable code-complexity */
642     function buy(address _address, uint256 _time, uint256 _value) internal returns (bool) {
643         if (locked == true) {
644             return false;
645         }
646         uint8 currentPhase = getCurrentPhase(_time);
647         Phase storage phase = phases[currentPhase];
648         if (_value == 0) {
649             return false;
650         }
651 
652         uint256 amount = calculateTokensAmount(_address, _time, _value);
653 
654         if (amount == 0) {
655             return false;
656         }
657 
658         uint256 totalAmount = amount.add(getBonusAmount(_time, amount));
659 
660         if (phase.allocatedTokens < phase.soldTokens + totalAmount) {
661             return false;
662         }
663 
664         phase.soldTokens = phase.soldTokens.add(totalAmount);
665 
666         if (balanceOf(this) < totalAmount) {
667             return false;
668         }
669 
670         if (balanceOf(_address) + totalAmount < balanceOf(_address)) {
671             return false;
672         }
673 
674         balances[this] = balanceOf(this).sub(totalAmount);
675         balances[_address] = balanceOf(_address).add(totalAmount);
676 
677         collectedEthers = collectedEthers.add(_value);
678 
679         emit Contribution(_address, _value, totalAmount);
680         emit Transfer(this, _address, totalAmount);
681         return true;
682     }
683 
684     function refundInternal(address holder) internal returns (bool success) {
685         Phase storage phase = phases[1];
686         require(phase.isFinished == true && isRefundAllowed == true);
687         uint256 refundEthers = sentEthers[holder];
688         uint256 refundTokens = balanceOf(holder);
689 
690         if (refundEthers == 0 && refundTokens == 0) {
691             return false;
692         }
693 
694         balances[holder] = 0;
695         sentEthers[holder] = 0;
696 
697         if (refundEthers > 0) {
698             holder.transfer(refundEthers);
699         }
700 
701         emit Refund(holder, refundEthers, refundTokens);
702 
703         return true;
704     }
705 
706     function transferUnusedTokensToICO(uint256 _unsoldPreICO) internal {
707         Phase storage phase = phases[1];
708         phase.allocatedTokens = phase.allocatedTokens.add(_unsoldPreICO);
709     }
710 
711     function checkValuePermission(uint8 _phaseId, uint256 _value) internal view returns (bool) {
712         require(phases.length > _phaseId);
713         Phase storage phase = phases[_phaseId];
714 
715         if (phase.minContribution == 0 && phase.maxContribution == 0) {
716             return true;
717         }
718 
719         if (phase.minContribution <= _value && _value <= phase.maxContribution) {
720             return true;
721         }
722 
723         if (_value > phase.maxContribution && phase.maxContribution != 0) {
724             return false;
725         }
726 
727         if (_value < phase.minContribution) {
728             return false;
729         }
730 
731         return false;
732     }
733 
734 }