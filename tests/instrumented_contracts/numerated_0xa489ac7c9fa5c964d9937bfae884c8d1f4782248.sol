1 pragma solidity ^0.4.23;
2 contract REDTTokenConfig {
3     string public constant NAME = "Real Estate Doc Token";
4     string public constant SYMBOL = "REDT";
5     uint8 public constant DECIMALS = 18;
6     uint public constant DECIMALSFACTOR = 10 ** uint(DECIMALS);
7     uint public constant TOTALSUPPLY = 1000000000 * DECIMALSFACTOR;
8 }
9 
10 
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18     // benefit is lost if 'b' is also tested.
19     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20     if (a == 0) {
21       return 0;
22     }
23 
24     c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     // uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return a / b;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51     c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipRenounced(address indexed previousOwner);
68   event OwnershipTransferred(
69     address indexed previousOwner,
70     address indexed newOwner
71   );
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   constructor() public {
79     owner = msg.sender;
80   }
81 
82   /**
83    * @dev Throws if called by any account other than the owner.
84    */
85   modifier onlyOwner() {
86     require(msg.sender == owner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to relinquish control of the contract.
92    * @notice Renouncing to ownership will leave the contract without an owner.
93    * It will not be possible to call the functions with the `onlyOwner`
94    * modifier anymore.
95    */
96   function renounceOwnership() public onlyOwner {
97     emit OwnershipRenounced(owner);
98     owner = address(0);
99   }
100 
101   /**
102    * @dev Allows the current owner to transfer control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address _newOwner) public onlyOwner {
106     _transferOwnership(_newOwner);
107   }
108 
109   /**
110    * @dev Transfers control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function _transferOwnership(address _newOwner) internal {
114     require(_newOwner != address(0));
115     emit OwnershipTransferred(owner, _newOwner);
116     owner = _newOwner;
117   }
118 }
119 
120 
121 contract Pausable is Ownable {
122   event Pause();
123   event Unpause();
124 
125   bool public paused = false;
126 
127 
128   /**
129    * @dev Modifier to make a function callable only when the contract is not paused.
130    */
131   modifier whenNotPaused() {
132     require(!paused);
133     _;
134   }
135 
136   /**
137    * @dev Modifier to make a function callable only when the contract is paused.
138    */
139   modifier whenPaused() {
140     require(paused);
141     _;
142   }
143 
144   /**
145    * @dev called by the owner to pause, triggers stopped state
146    */
147   function pause() onlyOwner whenNotPaused public {
148     paused = true;
149     emit Pause();
150   }
151 
152   /**
153    * @dev called by the owner to unpause, returns to normal state
154    */
155   function unpause() onlyOwner whenPaused public {
156     paused = false;
157     emit Unpause();
158   }
159 }
160 
161 contract Claimable is Ownable {
162   address public pendingOwner;
163 
164   /**
165    * @dev Modifier throws if called by any account other than the pendingOwner.
166    */
167   modifier onlyPendingOwner() {
168     require(msg.sender == pendingOwner);
169     _;
170   }
171 
172   /**
173    * @dev Allows the current owner to set the pendingOwner address.
174    * @param newOwner The address to transfer ownership to.
175    */
176   function transferOwnership(address newOwner) onlyOwner public {
177     pendingOwner = newOwner;
178   }
179 
180   /**
181    * @dev Allows the pendingOwner address to finalize the transfer.
182    */
183   function claimOwnership() onlyPendingOwner public {
184     emit OwnershipTransferred(owner, pendingOwner);
185     owner = pendingOwner;
186     pendingOwner = address(0);
187   }
188 }
189 
190 
191 /**
192  * @title ERC20Basic
193  * @dev Simpler version of ERC20 interface
194  * See https://github.com/ethereum/EIPs/issues/179
195  */
196 contract ERC20Basic {
197   function totalSupply() public view returns (uint256);
198   function balanceOf(address who) public view returns (uint256);
199   function transfer(address to, uint256 value) public returns (bool);
200   event Transfer(address indexed from, address indexed to, uint256 value);
201 }
202 
203 
204 contract ERC20 is ERC20Basic {
205   function allowance(address owner, address spender)
206     public view returns (uint256);
207 
208   function transferFrom(address from, address to, uint256 value)
209     public returns (bool);
210 
211   function approve(address spender, uint256 value) public returns (bool);
212   event Approval(
213     address indexed owner,
214     address indexed spender,
215     uint256 value
216   );
217 }
218 
219 contract REDTTokenSaleConfig is REDTTokenConfig {
220     uint public constant MIN_CONTRIBUTION      = 100 finney;
221 
222     uint public constant SALE_START = 1537189200;
223     uint public constant SALE_END = 1540990800;
224     
225     uint public constant SALE0_END = 1537794000;
226     uint public constant SALE0_RATE = 24000;
227     uint public constant SALE0_CAP = 400000000 * DECIMALSFACTOR;
228     
229     uint public constant SALE1_END = 1538398800;
230     uint public constant SALE1_RATE = 22000;
231     uint public constant SALE1_CAP = 500000000 * DECIMALSFACTOR;
232     
233     uint public constant SALE2_END = 1540990800;
234     uint public constant SALE2_RATE = 20000;
235     uint public constant SALE2_CAP = 500000000 * DECIMALSFACTOR;
236     
237     uint public constant SALE_CAP = 500000000 * DECIMALSFACTOR;
238 
239     address public constant MULTISIG_ETH = 0x25C7A30F23a107ebF430FDFD582Afe1245B690Af;
240     address public constant MULTISIG_TKN = 0x25C7A30F23a107ebF430FDFD582Afe1245B690Af;
241 
242 }
243 
244 
245 /**
246  * @title Basic token
247  * @dev Basic version of StandardToken, with no allowances.
248  */
249 contract BasicToken is ERC20Basic {
250   using SafeMath for uint256;
251 
252   mapping(address => uint256) balances;
253 
254   uint256 totalSupply_;
255 
256   /**
257   * @dev Total number of tokens in existence
258   */
259   function totalSupply() public view returns (uint256) {
260     return totalSupply_;
261   }
262 
263   /**
264   * @dev Transfer token for a specified address
265   * @param _to The address to transfer to.
266   * @param _value The amount to be transferred.
267   */
268   function transfer(address _to, uint256 _value) public returns (bool) {
269     require(_to != address(0));
270     require(_value <= balances[msg.sender]);
271 
272     balances[msg.sender] = balances[msg.sender].sub(_value);
273     balances[_to] = balances[_to].add(_value);
274     emit Transfer(msg.sender, _to, _value);
275     return true;
276   }
277 
278   /**
279   * @dev Gets the balance of the specified address.
280   * @param _owner The address to query the the balance of.
281   * @return An uint256 representing the amount owned by the passed address.
282   */
283   function balanceOf(address _owner) public view returns (uint256) {
284     return balances[_owner];
285   }
286 
287 }
288 
289 
290 /**
291  * @title Standard ERC20 token
292  *
293  * @dev Implementation of the basic standard token.
294  * https://github.com/ethereum/EIPs/issues/20
295  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
296  */
297 contract StandardToken is ERC20, BasicToken {
298 
299   mapping (address => mapping (address => uint256)) internal allowed;
300 
301 
302   /**
303    * @dev Transfer tokens from one address to another
304    * @param _from address The address which you want to send tokens from
305    * @param _to address The address which you want to transfer to
306    * @param _value uint256 the amount of tokens to be transferred
307    */
308   function transferFrom(
309     address _from,
310     address _to,
311     uint256 _value
312   )
313     public
314     returns (bool)
315   {
316     require(_to != address(0));
317     require(_value <= balances[_from]);
318     require(_value <= allowed[_from][msg.sender]);
319 
320     balances[_from] = balances[_from].sub(_value);
321     balances[_to] = balances[_to].add(_value);
322     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
323     emit Transfer(_from, _to, _value);
324     return true;
325   }
326 
327   /**
328    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
329    * Beware that changing an allowance with this method brings the risk that someone may use both the old
330    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
331    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
332    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
333    * @param _spender The address which will spend the funds.
334    * @param _value The amount of tokens to be spent.
335    */
336   function approve(address _spender, uint256 _value) public returns (bool) {
337     allowed[msg.sender][_spender] = _value;
338     emit Approval(msg.sender, _spender, _value);
339     return true;
340   }
341 
342   /**
343    * @dev Function to check the amount of tokens that an owner allowed to a spender.
344    * @param _owner address The address which owns the funds.
345    * @param _spender address The address which will spend the funds.
346    * @return A uint256 specifying the amount of tokens still available for the spender.
347    */
348   function allowance(
349     address _owner,
350     address _spender
351    )
352     public
353     view
354     returns (uint256)
355   {
356     return allowed[_owner][_spender];
357   }
358 
359   /**
360    * @dev Increase the amount of tokens that an owner allowed to a spender.
361    * approve should be called when allowed[_spender] == 0. To increment
362    * allowed value is better to use this function to avoid 2 calls (and wait until
363    * the first transaction is mined)
364    * From MonolithDAO Token.sol
365    * @param _spender The address which will spend the funds.
366    * @param _addedValue The amount of tokens to increase the allowance by.
367    */
368   function increaseApproval(
369     address _spender,
370     uint256 _addedValue
371   )
372     public
373     returns (bool)
374   {
375     allowed[msg.sender][_spender] = (
376       allowed[msg.sender][_spender].add(_addedValue));
377     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
378     return true;
379   }
380 
381   /**
382    * @dev Decrease the amount of tokens that an owner allowed to a spender.
383    * approve should be called when allowed[_spender] == 0. To decrement
384    * allowed value is better to use this function to avoid 2 calls (and wait until
385    * the first transaction is mined)
386    * From MonolithDAO Token.sol
387    * @param _spender The address which will spend the funds.
388    * @param _subtractedValue The amount of tokens to decrease the allowance by.
389    */
390   function decreaseApproval(
391     address _spender,
392     uint256 _subtractedValue
393   )
394     public
395     returns (bool)
396   {
397     uint256 oldValue = allowed[msg.sender][_spender];
398     if (_subtractedValue > oldValue) {
399       allowed[msg.sender][_spender] = 0;
400     } else {
401       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
402     }
403     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
404     return true;
405   }
406 
407 }
408 
409 
410 
411 contract PausableToken is StandardToken, Pausable {
412 
413   function transfer(
414     address _to,
415     uint256 _value
416   )
417     public
418     whenNotPaused
419     returns (bool)
420   {
421     return super.transfer(_to, _value);
422   }
423 
424   function transferFrom(
425     address _from,
426     address _to,
427     uint256 _value
428   )
429     public
430     whenNotPaused
431     returns (bool)
432   {
433     return super.transferFrom(_from, _to, _value);
434   }
435 
436   function approve(
437     address _spender,
438     uint256 _value
439   )
440     public
441     whenNotPaused
442     returns (bool)
443   {
444     return super.approve(_spender, _value);
445   }
446 
447   function increaseApproval(
448     address _spender,
449     uint _addedValue
450   )
451     public
452     whenNotPaused
453     returns (bool success)
454   {
455     return super.increaseApproval(_spender, _addedValue);
456   }
457 
458   function decreaseApproval(
459     address _spender,
460     uint _subtractedValue
461   )
462     public
463     whenNotPaused
464     returns (bool success)
465   {
466     return super.decreaseApproval(_spender, _subtractedValue);
467   }
468 }
469 
470 contract Operatable is Claimable {
471     address public minter;
472     address public whiteLister;
473     address public launcher;
474 
475     modifier canOperate() {
476         require(msg.sender == minter || msg.sender == whiteLister || msg.sender == owner);
477         _;
478     }
479 
480     constructor() public {
481         minter = owner;
482         whiteLister = owner;
483         launcher = owner;
484     }
485 
486     function setMinter (address addr) public onlyOwner {
487         minter = addr;
488     }
489 
490     function setWhiteLister (address addr) public onlyOwner {
491         whiteLister = addr;
492     }
493 
494     modifier onlyMinter()  {
495         require (msg.sender == minter);
496         _;
497     }
498 
499     modifier onlyLauncher()  {
500         require (msg.sender == minter);
501         _;
502     }
503 
504     modifier onlyWhiteLister()  {
505         require (msg.sender == whiteLister);
506         _;
507     }
508 }
509 contract WhiteListed is Operatable {
510 
511 
512     uint public count;
513     mapping (address => bool) public whiteList;
514 
515     event Whitelisted(address indexed addr, uint whitelistedCount, bool isWhitelisted);
516 
517     function addWhiteListed(address[] addrs) external canOperate {
518         uint c = count;
519         for (uint i = 0; i < addrs.length; i++) {
520             if (!whiteList[addrs[i]]) {
521                 whiteList[addrs[i]] = true;
522                 c++;
523                 emit Whitelisted(addrs[i], count, true);
524             }
525         }
526         count = c;
527     }
528 
529     function removeWhiteListed(address addr) external canOperate {
530         require(whiteList[addr]);
531         whiteList[addr] = false;
532         count--;
533         emit Whitelisted(addr, count, false);
534     }
535 
536 }
537 contract Salvageable is Operatable {
538     // Salvage other tokens that are accidentally sent into this token
539     function emergencyERC20Drain(ERC20 oddToken, uint amount) public onlyLauncher {
540         if (address(oddToken) == address(0)) {
541             launcher.transfer(amount);
542             return;
543         }
544         oddToken.transfer(launcher, amount);
545     }
546 }
547 contract REDTToken is PausableToken, REDTTokenConfig, Salvageable {
548     using SafeMath for uint;
549 
550     string public name = NAME;
551     string public symbol = SYMBOL;
552     uint8 public decimals = DECIMALS;
553     bool public mintingFinished = false;
554 
555     event Mint(address indexed to, uint amount);
556     event MintFinished();
557 
558     modifier canMint() {
559         require(!mintingFinished);
560         _;
561     }
562 
563     constructor(address launcher_) public {
564         launcher = launcher_;
565         paused = true;
566     }
567 
568     function mint(address _to, uint _amount)  canMint public returns (bool) {
569         require(totalSupply_.add(_amount) <= TOTALSUPPLY);
570         totalSupply_ = totalSupply_.add(_amount);
571         balances[_to] = balances[_to].add(_amount);
572         emit Transfer(address(0), _to, _amount);
573         return true;
574     }
575 
576     function finishMinting()  canMint public returns (bool) {
577         mintingFinished = true;
578         emit MintFinished();
579         return true;
580     }
581 
582     function sendBatchCS(address[] _recipients, uint[] _values) external canOperate returns (bool) {
583         require(_recipients.length == _values.length);
584         uint senderBalance = balances[msg.sender];
585         for (uint i = 0; i < _values.length; i++) {
586             uint value = _values[i];
587             address to = _recipients[i];
588             require(senderBalance >= value);        
589             senderBalance = senderBalance - value;
590             balances[to] += value;
591             emit Transfer(msg.sender, to, value);
592         }
593         balances[msg.sender] = senderBalance;
594         return true;
595     }
596 
597 }
598 contract REDTTokenSale is REDTTokenSaleConfig, Claimable, Pausable, Salvageable {
599     using SafeMath for uint;
600     bool public isFinalized = false;
601     REDTToken public token;
602     
603     uint public tokensRaised;           
604     uint public weiRaised;              // Amount of raised money in WEI
605     WhiteListed public whiteListed;
606     uint public numContributors;        // Discrete number of contributors
607 
608     mapping (address => uint) public contributions; // to allow them to have multiple spends
609 
610     event Finalized();
611     event TokenPurchase(address indexed beneficiary, uint value, uint amount);
612     event TokenPresale(address indexed purchaser, uint amount);
613 
614     constructor( WhiteListed _whiteListed ) public {
615         
616         require(now < SALE_START);
617         
618         require(_whiteListed != address(0));
619         
620         whiteListed = _whiteListed;
621 
622         token = new REDTToken(owner);
623         // Note : since we are using claimable, the ownership transfer is not immediate
624         // This contract can still do what it needs to via the minter 
625         token.transferOwnership(owner);
626 
627     }
628 
629     function getRateAndCheckCap() public view returns (uint) {
630         
631         require(now>SALE_START);
632         
633         if ((now<SALE0_END) && (tokensRaised < SALE0_CAP))
634             return SALE0_RATE;
635         
636         if ((now<SALE1_END) && (tokensRaised < SALE1_CAP))
637             return SALE1_RATE;
638         
639         if ((now<SALE2_END) && (tokensRaised < SALE2_CAP))
640             return SALE2_RATE;
641         
642         revert();
643     }
644 
645     // Only fallback function can be used to buy tokens
646     function () external payable {
647         buyTokens(msg.sender, msg.value);
648     }
649 
650     function buyTokens(address beneficiary, uint weiAmount) internal whenNotPaused {
651         require(whiteListed.whiteList(beneficiary));
652         require((weiAmount > MIN_CONTRIBUTION) || (weiAmount == SALE_CAP.sub(MIN_CONTRIBUTION)));
653 
654         weiRaised = weiRaised.add(weiAmount);
655         uint tokens = weiAmount.mul(getRateAndCheckCap());
656 
657         if (contributions[beneficiary] == 0) {
658             numContributors++;
659         }
660 
661         contributions[beneficiary] = contributions[beneficiary].add(weiAmount);
662         token.mint(beneficiary, tokens);
663         emit TokenPurchase(beneficiary, weiAmount, tokens);
664         forwardFunds();
665     }
666 
667     function placeTokens(address beneficiary, uint256 numtokens) 
668     public
669 	  onlyOwner
670     {
671         
672         require(now < SALE_START);
673         
674         tokensRaised = tokensRaised.add(numtokens);
675         token.mint(beneficiary,numtokens);
676     }
677 
678 
679     function tokensUnsold() public view returns(uint) {
680         return token.TOTALSUPPLY().sub(token.totalSupply());
681     }
682 
683     // Return true if crowdsale event has ended
684     function hasEnded() public view returns (bool) {
685         return ((now > SALE_END) || (tokensRaised >= SALE_CAP));
686     }
687 
688     // Send ether to the fund collection wallet
689     function forwardFunds() internal {
690         
691         MULTISIG_ETH.transfer(address(this).balance);
692     }
693 
694     // Must be called after crowdsale ends, to do some extra finalization
695     function finalize() onlyOwner public {
696         require(!isFinalized);
697         require(hasEnded());
698 
699         finalization();
700         emit Finalized();
701 
702         isFinalized = true;
703     }
704 
705     // Stops the minting 
706     // Mints unsold tokens to owner
707     function finalization() internal {
708         
709         token.mint(MULTISIG_TKN,tokensUnsold());
710         
711         token.finishMinting();
712     }
713 }