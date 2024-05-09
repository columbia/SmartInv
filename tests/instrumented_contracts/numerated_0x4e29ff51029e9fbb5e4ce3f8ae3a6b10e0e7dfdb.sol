1 pragma solidity ^0.4.23;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract REDTTokenConfig {
6     string public constant NAME = "Real Estate Doc Token";
7     string public constant SYMBOL = "REDT";
8     uint8 public constant DECIMALS = 18;
9     uint public constant DECIMALSFACTOR = 10 ** uint(DECIMALS);
10     uint public constant TOTALSUPPLY = 1000000000 * DECIMALSFACTOR;
11 }
12 
13 
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipRenounced(address indexed previousOwner);
19   event OwnershipTransferred(
20     address indexed previousOwner,
21     address indexed newOwner
22   );
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   constructor() public {
30     owner = msg.sender;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to relinquish control of the contract.
43    * @notice Renouncing to ownership will leave the contract without an owner.
44    * It will not be possible to call the functions with the `onlyOwner`
45    * modifier anymore.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address _newOwner) public onlyOwner {
57     _transferOwnership(_newOwner);
58   }
59 
60   /**
61    * @dev Transfers control of the contract to a newOwner.
62    * @param _newOwner The address to transfer ownership to.
63    */
64   function _transferOwnership(address _newOwner) internal {
65     require(_newOwner != address(0));
66     emit OwnershipTransferred(owner, _newOwner);
67     owner = _newOwner;
68   }
69 }
70 
71 library SafeMath {
72 
73   /**
74   * @dev Multiplies two numbers, throws on overflow.
75   */
76   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
77     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
78     // benefit is lost if 'b' is also tested.
79     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
80     if (a == 0) {
81       return 0;
82     }
83 
84     c = a * b;
85     assert(c / a == b);
86     return c;
87   }
88 
89   /**
90   * @dev Integer division of two numbers, truncating the quotient.
91   */
92   function div(uint256 a, uint256 b) internal pure returns (uint256) {
93     // assert(b > 0); // Solidity automatically throws when dividing by 0
94     // uint256 c = a / b;
95     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96     return a / b;
97   }
98 
99   /**
100   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
101   */
102   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103     assert(b <= a);
104     return a - b;
105   }
106 
107   /**
108   * @dev Adds two numbers, throws on overflow.
109   */
110   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
111     c = a + b;
112     assert(c >= a);
113     return c;
114   }
115 }
116 
117 contract ERC20Basic {
118   function totalSupply() public view returns (uint256);
119   function balanceOf(address who) public view returns (uint256);
120   function transfer(address to, uint256 value) public returns (bool);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 contract Pausable is Ownable {
125   event Pause();
126   event Unpause();
127 
128   bool public paused = false;
129 
130 
131   /**
132    * @dev Modifier to make a function callable only when the contract is not paused.
133    */
134   modifier whenNotPaused() {
135     require(!paused);
136     _;
137   }
138 
139   /**
140    * @dev Modifier to make a function callable only when the contract is paused.
141    */
142   modifier whenPaused() {
143     require(paused);
144     _;
145   }
146 
147   /**
148    * @dev called by the owner to pause, triggers stopped state
149    */
150   function pause() onlyOwner whenNotPaused public {
151     paused = true;
152     emit Pause();
153   }
154 
155   /**
156    * @dev called by the owner to unpause, returns to normal state
157    */
158   function unpause() onlyOwner whenPaused public {
159     paused = false;
160     emit Unpause();
161   }
162 }
163 
164 contract Claimable is Ownable {
165   address public pendingOwner;
166 
167   /**
168    * @dev Modifier throws if called by any account other than the pendingOwner.
169    */
170   modifier onlyPendingOwner() {
171     require(msg.sender == pendingOwner);
172     _;
173   }
174 
175   /**
176    * @dev Allows the current owner to set the pendingOwner address.
177    * @param newOwner The address to transfer ownership to.
178    */
179   function transferOwnership(address newOwner) onlyOwner public {
180     pendingOwner = newOwner;
181   }
182 
183   /**
184    * @dev Allows the pendingOwner address to finalize the transfer.
185    */
186   function claimOwnership() onlyPendingOwner public {
187     emit OwnershipTransferred(owner, pendingOwner);
188     owner = pendingOwner;
189     pendingOwner = address(0);
190   }
191 }
192 
193 contract REDTTokenSaleConfig is REDTTokenConfig {
194     uint public constant MIN_CONTRIBUTION      = 100 finney;
195 
196     
197 
198     
199 
200     uint public constant RESERVE_AMOUNT = 500000000 * DECIMALSFACTOR;
201 
202     uint public constant SALE_START = 1537189200;
203     uint public constant SALE_END = 1540990800;
204     
205     uint public constant SALE0_END = 1537794000;
206     uint public constant SALE0_RATE = 24000;
207     uint public constant SALE0_CAP = 400000000 * DECIMALSFACTOR;
208     
209     uint public constant SALE1_END = 1538398800;
210     uint public constant SALE1_RATE = 22000;
211     uint public constant SALE1_CAP = 500000000 * DECIMALSFACTOR;
212     
213     uint public constant SALE2_END = 1540990800;
214     uint public constant SALE2_RATE = 20000;
215     uint public constant SALE2_CAP = 500000000 * DECIMALSFACTOR;
216     
217     uint public constant SALE_CAP = 500000000 * DECIMALSFACTOR;
218 
219     address public constant MULTISIG_ETH = 0x25C7A30F23a107ebF430FDFD582Afe1245B690Af;
220     address public constant MULTISIG_TKN = 0x25C7A30F23a107ebF430FDFD582Afe1245B690Af;
221 
222 }
223 contract ERC20 is ERC20Basic {
224   function allowance(address owner, address spender)
225     public view returns (uint256);
226 
227   function transferFrom(address from, address to, uint256 value)
228     public returns (bool);
229 
230   function approve(address spender, uint256 value) public returns (bool);
231   event Approval(
232     address indexed owner,
233     address indexed spender,
234     uint256 value
235   );
236 }
237 
238 contract BasicToken is ERC20Basic {
239   using SafeMath for uint256;
240 
241   mapping(address => uint256) balances;
242 
243   uint256 totalSupply_;
244 
245   /**
246   * @dev Total number of tokens in existence
247   */
248   function totalSupply() public view returns (uint256) {
249     return totalSupply_;
250   }
251 
252   /**
253   * @dev Transfer token for a specified address
254   * @param _to The address to transfer to.
255   * @param _value The amount to be transferred.
256   */
257   function transfer(address _to, uint256 _value) public returns (bool) {
258     require(_to != address(0));
259     require(_value <= balances[msg.sender]);
260 
261     balances[msg.sender] = balances[msg.sender].sub(_value);
262     balances[_to] = balances[_to].add(_value);
263     emit Transfer(msg.sender, _to, _value);
264     return true;
265   }
266 
267   /**
268   * @dev Gets the balance of the specified address.
269   * @param _owner The address to query the the balance of.
270   * @return An uint256 representing the amount owned by the passed address.
271   */
272   function balanceOf(address _owner) public view returns (uint256) {
273     return balances[_owner];
274   }
275 
276 }
277 
278 contract StandardToken is ERC20, BasicToken {
279 
280   mapping (address => mapping (address => uint256)) internal allowed;
281 
282 
283   /**
284    * @dev Transfer tokens from one address to another
285    * @param _from address The address which you want to send tokens from
286    * @param _to address The address which you want to transfer to
287    * @param _value uint256 the amount of tokens to be transferred
288    */
289   function transferFrom(
290     address _from,
291     address _to,
292     uint256 _value
293   )
294     public
295     returns (bool)
296   {
297     require(_to != address(0));
298     require(_value <= balances[_from]);
299     require(_value <= allowed[_from][msg.sender]);
300 
301     balances[_from] = balances[_from].sub(_value);
302     balances[_to] = balances[_to].add(_value);
303     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
304     emit Transfer(_from, _to, _value);
305     return true;
306   }
307 
308   /**
309    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
310    * Beware that changing an allowance with this method brings the risk that someone may use both the old
311    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
312    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
313    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
314    * @param _spender The address which will spend the funds.
315    * @param _value The amount of tokens to be spent.
316    */
317   function approve(address _spender, uint256 _value) public returns (bool) {
318     allowed[msg.sender][_spender] = _value;
319     emit Approval(msg.sender, _spender, _value);
320     return true;
321   }
322 
323   /**
324    * @dev Function to check the amount of tokens that an owner allowed to a spender.
325    * @param _owner address The address which owns the funds.
326    * @param _spender address The address which will spend the funds.
327    * @return A uint256 specifying the amount of tokens still available for the spender.
328    */
329   function allowance(
330     address _owner,
331     address _spender
332    )
333     public
334     view
335     returns (uint256)
336   {
337     return allowed[_owner][_spender];
338   }
339 
340   /**
341    * @dev Increase the amount of tokens that an owner allowed to a spender.
342    * approve should be called when allowed[_spender] == 0. To increment
343    * allowed value is better to use this function to avoid 2 calls (and wait until
344    * the first transaction is mined)
345    * From MonolithDAO Token.sol
346    * @param _spender The address which will spend the funds.
347    * @param _addedValue The amount of tokens to increase the allowance by.
348    */
349   function increaseApproval(
350     address _spender,
351     uint256 _addedValue
352   )
353     public
354     returns (bool)
355   {
356     allowed[msg.sender][_spender] = (
357       allowed[msg.sender][_spender].add(_addedValue));
358     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
359     return true;
360   }
361 
362   /**
363    * @dev Decrease the amount of tokens that an owner allowed to a spender.
364    * approve should be called when allowed[_spender] == 0. To decrement
365    * allowed value is better to use this function to avoid 2 calls (and wait until
366    * the first transaction is mined)
367    * From MonolithDAO Token.sol
368    * @param _spender The address which will spend the funds.
369    * @param _subtractedValue The amount of tokens to decrease the allowance by.
370    */
371   function decreaseApproval(
372     address _spender,
373     uint256 _subtractedValue
374   )
375     public
376     returns (bool)
377   {
378     uint256 oldValue = allowed[msg.sender][_spender];
379     if (_subtractedValue > oldValue) {
380       allowed[msg.sender][_spender] = 0;
381     } else {
382       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
383     }
384     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
385     return true;
386   }
387 
388 }
389 
390 contract Operatable is Claimable {
391     address public minter;
392     address public whiteLister;
393     address public launcher;
394 
395     modifier canOperate() {
396         require(msg.sender == minter || msg.sender == whiteLister || msg.sender == owner);
397         _;
398     }
399 
400     constructor() public {
401         minter = owner;
402         whiteLister = owner;
403         launcher = owner;
404     }
405 
406     function setMinter (address addr) public onlyOwner {
407         minter = addr;
408     }
409 
410     function setWhiteLister (address addr) public onlyOwner {
411         whiteLister = addr;
412     }
413 
414     modifier onlyMinter()  {
415         require (msg.sender == minter);
416         _;
417     }
418 
419     modifier ownerOrMinter()  {
420         require ((msg.sender == minter) || (msg.sender == owner));
421         _;
422     }
423 
424 
425     modifier onlyLauncher()  {
426         require (msg.sender == minter);
427         _;
428     }
429 
430     modifier onlyWhiteLister()  {
431         require (msg.sender == whiteLister);
432         _;
433     }
434 }
435 contract Salvageable is Operatable {
436     // Salvage other tokens that are accidentally sent into this token
437     function emergencyERC20Drain(ERC20 oddToken, uint amount) public onlyLauncher {
438         if (address(oddToken) == address(0)) {
439             launcher.transfer(amount);
440             return;
441         }
442         oddToken.transfer(launcher, amount);
443     }
444 }
445 contract PausableToken is StandardToken, Pausable {
446 
447   function transfer(
448     address _to,
449     uint256 _value
450   )
451     public
452     whenNotPaused
453     returns (bool)
454   {
455     return super.transfer(_to, _value);
456   }
457 
458   function transferFrom(
459     address _from,
460     address _to,
461     uint256 _value
462   )
463     public
464     whenNotPaused
465     returns (bool)
466   {
467     return super.transferFrom(_from, _to, _value);
468   }
469 
470   function approve(
471     address _spender,
472     uint256 _value
473   )
474     public
475     whenNotPaused
476     returns (bool)
477   {
478     return super.approve(_spender, _value);
479   }
480 
481   function increaseApproval(
482     address _spender,
483     uint _addedValue
484   )
485     public
486     whenNotPaused
487     returns (bool success)
488   {
489     return super.increaseApproval(_spender, _addedValue);
490   }
491 
492   function decreaseApproval(
493     address _spender,
494     uint _subtractedValue
495   )
496     public
497     whenNotPaused
498     returns (bool success)
499   {
500     return super.decreaseApproval(_spender, _subtractedValue);
501   }
502 }
503 
504 contract WhiteListed is Operatable {
505 
506 
507     uint public count;
508     mapping (address => bool) public whiteList;
509 
510     event Whitelisted(address indexed addr, uint whitelistedCount, bool isWhitelisted);
511 
512     function addWhiteListed(address[] addrs) external canOperate {
513         uint c = count;
514         for (uint i = 0; i < addrs.length; i++) {
515             if (!whiteList[addrs[i]]) {
516                 whiteList[addrs[i]] = true;
517                 c++;
518                 emit Whitelisted(addrs[i], count, true);
519             }
520         }
521         count = c;
522     }
523 
524     function removeWhiteListed(address addr) external canOperate {
525         require(whiteList[addr]);
526         whiteList[addr] = false;
527         count--;
528         emit Whitelisted(addr, count, false);
529     }
530 
531 }
532 contract REDTToken is PausableToken, REDTTokenConfig, Salvageable {
533     using SafeMath for uint;
534 
535     string public name = NAME;
536     string public symbol = SYMBOL;
537     uint8 public decimals = DECIMALS;
538     bool public mintingFinished = false;
539 
540     event Mint(address indexed to, uint amount);
541     event MintFinished();
542     event Burn(address indexed burner, uint256 value);
543 
544 
545     modifier canMint() {
546         require(!mintingFinished);
547         _;
548     }
549 
550     constructor(address launcher_) public {
551         launcher = launcher_;
552         paused = true;
553     }
554 
555     function mint(address _to, uint _amount) canMint onlyMinter public returns (bool) {
556         require(totalSupply_.add(_amount) <= TOTALSUPPLY);
557         totalSupply_ = totalSupply_.add(_amount);
558         balances[_to] = balances[_to].add(_amount);
559         emit Transfer(address(0), _to, _amount);
560         return true;
561     }
562 
563     function finishMinting() canMint public returns (bool) {
564         mintingFinished = true;
565         emit MintFinished();
566         return true;
567     }
568 
569     function burn(uint256 _value) public {
570         _burn(msg.sender, _value);
571     }
572 
573     function _burn(address _who, uint256 _value) internal {
574         require(_value <= balances[_who]);
575         balances[_who] = balances[_who].sub(_value);
576         totalSupply_ = totalSupply_.sub(_value);
577         emit Burn(_who, _value);
578         emit Transfer(_who, address(0), _value);
579     }
580 
581     function sendBatchCS(address[] _recipients, uint[] _values) external canOperate returns (bool) {
582         require(_recipients.length == _values.length);
583         uint senderBalance = balances[msg.sender];
584         for (uint i = 0; i < _values.length; i++) {
585             uint value = _values[i];
586             address to = _recipients[i];
587             require(senderBalance >= value);        
588             senderBalance = senderBalance - value;
589             balances[to] += value;
590             emit Transfer(msg.sender, to, value);
591         }
592         balances[msg.sender] = senderBalance;
593         return true;
594     }
595 
596 }
597 contract REDTTokenSale is REDTTokenSaleConfig, Claimable, Pausable, Salvageable {
598     using SafeMath for uint;
599     bool public isFinalized = false;
600     REDTToken public token;
601     
602     uint public tokensRaised;           
603     uint public weiRaised;              // Amount of raised money in WEI
604     WhiteListed public whiteListed;
605     uint public numContributors;        // Discrete number of contributors
606 
607     mapping (address => uint) public contributions; // to allow them to have multiple spends
608 
609     event Finalized();
610     event TokenPurchase(address indexed beneficiary, uint value, uint amount);
611     event TokenPresale(address indexed purchaser, uint amount);
612 
613     struct capRec  {
614         uint time;
615         uint amount;
616     }
617     capRec[] public capz;
618     uint public capDefault;
619 
620 
621     constructor( WhiteListed _whiteListed ) public {
622         
623         require(now < SALE_START);
624         
625         require(_whiteListed != address(0));
626         
627         whiteListed = _whiteListed;
628 
629         token = new REDTToken(owner);
630         token.mint(MULTISIG_TKN,RESERVE_AMOUNT);
631         initCaps();
632     }
633 
634     
635     function initCaps() public {
636         uint[4] memory caps = [uint(10),20,30,40];
637         uint[4] memory times = [uint(1),4,12,24];
638         for (uint i = 0; i < caps.length; i++) {
639             capRec memory cr;
640             cr.time = times[i];
641             cr.amount = caps[i];
642             capz.push(cr);
643         }
644         capDefault = 100;
645     }
646     
647     function setCapRec(uint[] capsInEther, uint[] timesInHours, uint defaultCapInEther) public onlyOwner {
648         //capRec[] memory cz = new capRec[](caps.length);
649         require(capsInEther.length == timesInHours.length);
650         capz.length = 0;
651         for (uint i = 0; i < capsInEther.length; i++) {
652             capRec memory cr;
653             cr.time = timesInHours[i];
654             cr.amount = capsInEther[i];
655             capz.push(cr);
656         }
657         capDefault = defaultCapInEther;
658         
659     }
660     
661     function currentCap() public view returns (uint) {
662         for (uint i = 0; i < capz.length; i++) {
663             if (now < SALE_START + capz[i].time * 1 hours)
664                 return (capz[i].amount * 1 ether);
665         }
666         return capDefault;
667     }
668 
669 
670     function getRateAndCheckCap() public view returns (uint) {
671         
672         require(now>SALE_START);
673         
674         if ((now<SALE0_END) && (tokensRaised < SALE0_CAP))
675             return SALE0_RATE;
676         
677         if ((now<SALE1_END) && (tokensRaised < SALE1_CAP))
678             return SALE1_RATE;
679         
680         if ((now<SALE2_END) && (tokensRaised < SALE2_CAP))
681             return SALE2_RATE;
682         
683         revert();
684     }
685 
686     // Only fallback function can be used to buy tokens
687     function () external payable {
688         buyTokens(msg.sender, msg.value);
689     }
690 
691     function buyTokens(address beneficiary, uint weiAmount) internal whenNotPaused {
692         require(contributions[beneficiary].add(weiAmount) < currentCap());
693         require(whiteListed.whiteList(beneficiary));
694         require((weiAmount > MIN_CONTRIBUTION) || (weiAmount == SALE_CAP.sub(MIN_CONTRIBUTION)));
695 
696         weiRaised = weiRaised.add(weiAmount);
697         uint tokens = weiAmount.mul(getRateAndCheckCap());
698 
699         if (contributions[beneficiary] == 0) {
700             numContributors++;
701         }
702 
703         tokensRaised = tokensRaised.add(tokens);
704 
705         contributions[beneficiary] = contributions[beneficiary].add(weiAmount);
706         token.mint(beneficiary, tokens);
707         emit TokenPurchase(beneficiary, weiAmount, tokens);
708         forwardFunds();
709     }
710 
711     function placeTokens(address beneficiary, uint256 numtokens) 
712     public
713 	  ownerOrMinter
714     {
715         require(now < SALE_START);  
716         tokensRaised = tokensRaised.add(numtokens);
717         token.mint(beneficiary,numtokens);
718     }
719 
720 
721     function tokensUnsold() public view returns(uint) {
722         return token.TOTALSUPPLY().sub(token.totalSupply());
723     }
724 
725     // Return true if crowdsale event has ended
726     function hasEnded() public view returns (bool) {
727         return ((now > SALE_END) || (tokensRaised >= SALE_CAP));
728     }
729 
730     // Send ether to the fund collection wallet
731     function forwardFunds() internal {
732         
733         MULTISIG_ETH.transfer(address(this).balance);
734     }
735 
736     // Must be called after crowdsale ends, to do some extra finalization
737     function finalize() onlyOwner public {
738         require(!isFinalized);
739         require(hasEnded());
740 
741         finalization();
742         emit Finalized();
743 
744         isFinalized = true;
745     }
746 
747     // Stops the minting and transfer token ownership to sale owner. Mints unsold tokens to owner
748     function finalization() internal {
749         token.finishMinting();
750         token.transferOwnership(owner);
751     }
752 }