1 pragma solidity ^0.4.23;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract GoConfig {
6     string public constant NAME = "GOeureka";
7     string public constant SYMBOL = "GOT";
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
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) public onlyOwner {
46     require(newOwner != address(0));
47     emit OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51   /**
52    * @dev Allows the current owner to relinquish control of the contract.
53    */
54   function renounceOwnership() public onlyOwner {
55     emit OwnershipRenounced(owner);
56     owner = address(0);
57   }
58 }
59 
60 contract WhiteListedBasic {
61     function addWhiteListed(address[] addrs) external;
62     function removeWhiteListed(address addr) external;
63     function isWhiteListed(address addr) external view returns (bool);
64 }
65 library SafeMath {
66 
67   /**
68   * @dev Multiplies two numbers, throws on overflow.
69   */
70   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     if (a == 0) {
72       return 0;
73     }
74     c = a * b;
75     assert(c / a == b);
76     return c;
77   }
78 
79   /**
80   * @dev Integer division of two numbers, truncating the quotient.
81   */
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     // uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return a / b;
87   }
88 
89   /**
90   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
91   */
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   /**
98   * @dev Adds two numbers, throws on overflow.
99   */
100   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
101     c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 }
106 
107 contract ERC20Basic {
108   function totalSupply() public view returns (uint256);
109   function balanceOf(address who) public view returns (uint256);
110   function transfer(address to, uint256 value) public returns (bool);
111   event Transfer(address indexed from, address indexed to, uint256 value);
112 }
113 
114 contract OperatableBasic {
115     function setMinter (address addr) external;
116     function setWhiteLister (address addr) external;
117 }
118 contract gotTokenSaleConfig is GoConfig {
119     uint public constant MIN_PRESALE = 5 ether;
120     uint public constant MIN_PRESALE2 = 1 ether;
121     
122 
123     uint public constant VESTING_AMOUNT = 100000000 * DECIMALSFACTOR;
124     address public constant VESTING_WALLET = 0x8B6EB396eF85D2a9ADbb79955dEB5d77Ee61Af88;
125         
126     uint public constant RESERVE_AMOUNT = 300000000 * DECIMALSFACTOR;
127     address public constant RESERVE_WALLET = 0x8B6EB396eF85D2a9ADbb79955dEB5d77Ee61Af88;
128 
129     uint public constant PRESALE_START = 1529035246; // Friday, June 15, 2018 12:00:46 PM GMT+08:00
130     uint public constant SALE_START = PRESALE_START + 4 weeks;
131         
132     uint public constant SALE_CAP = 600000000 * DECIMALSFACTOR;
133 
134     address public constant MULTISIG_ETH = RESERVE_WALLET;
135 
136 }
137 contract Pausable is Ownable {
138   event Pause();
139   event Unpause();
140 
141   bool public paused = false;
142 
143 
144   /**
145    * @dev Modifier to make a function callable only when the contract is not paused.
146    */
147   modifier whenNotPaused() {
148     require(!paused);
149     _;
150   }
151 
152   /**
153    * @dev Modifier to make a function callable only when the contract is paused.
154    */
155   modifier whenPaused() {
156     require(paused);
157     _;
158   }
159 
160   /**
161    * @dev called by the owner to pause, triggers stopped state
162    */
163   function pause() onlyOwner whenNotPaused public {
164     paused = true;
165     emit Pause();
166   }
167 
168   /**
169    * @dev called by the owner to unpause, returns to normal state
170    */
171   function unpause() onlyOwner whenPaused public {
172     paused = false;
173     emit Unpause();
174   }
175 }
176 
177 contract BasicToken is ERC20Basic {
178   using SafeMath for uint256;
179 
180   mapping(address => uint256) balances;
181 
182   uint256 totalSupply_;
183 
184   /**
185   * @dev total number of tokens in existence
186   */
187   function totalSupply() public view returns (uint256) {
188     return totalSupply_;
189   }
190 
191   /**
192   * @dev transfer token for a specified address
193   * @param _to The address to transfer to.
194   * @param _value The amount to be transferred.
195   */
196   function transfer(address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(_value <= balances[msg.sender]);
199 
200     balances[msg.sender] = balances[msg.sender].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     emit Transfer(msg.sender, _to, _value);
203     return true;
204   }
205 
206   /**
207   * @dev Gets the balance of the specified address.
208   * @param _owner The address to query the the balance of.
209   * @return An uint256 representing the amount owned by the passed address.
210   */
211   function balanceOf(address _owner) public view returns (uint256) {
212     return balances[_owner];
213   }
214 
215 }
216 
217 contract Claimable is Ownable {
218   address public pendingOwner;
219 
220   /**
221    * @dev Modifier throws if called by any account other than the pendingOwner.
222    */
223   modifier onlyPendingOwner() {
224     require(msg.sender == pendingOwner);
225     _;
226   }
227 
228   /**
229    * @dev Allows the current owner to set the pendingOwner address.
230    * @param newOwner The address to transfer ownership to.
231    */
232   function transferOwnership(address newOwner) onlyOwner public {
233     pendingOwner = newOwner;
234   }
235 
236   /**
237    * @dev Allows the pendingOwner address to finalize the transfer.
238    */
239   function claimOwnership() onlyPendingOwner public {
240     emit OwnershipTransferred(owner, pendingOwner);
241     owner = pendingOwner;
242     pendingOwner = address(0);
243   }
244 }
245 
246 contract Operatable is Claimable, OperatableBasic {
247     address public minter;
248     address public whiteLister;
249     address public launcher;
250 
251     event NewMinter(address newMinter);
252     event NewWhiteLister(address newwhiteLister);
253 
254     modifier canOperate() {
255         require(msg.sender == minter || msg.sender == whiteLister || msg.sender == owner);
256         _;
257     }
258 
259     constructor() public {
260         minter = owner;
261         whiteLister = owner;
262         launcher = owner;
263     }
264 
265     function setMinter (address addr) external onlyOwner {
266         minter = addr;
267         emit NewMinter(minter);
268     }
269 
270     function setWhiteLister (address addr) external onlyOwner {
271         whiteLister = addr;
272         emit NewWhiteLister(whiteLister);
273     }
274 
275     modifier ownerOrMinter()  {
276         require ((msg.sender == minter) || (msg.sender == owner));
277         _;
278     }
279 
280     modifier onlyLauncher()  {
281         require (msg.sender == launcher);
282         _;
283     }
284 
285     modifier onlyWhiteLister()  {
286         require (msg.sender == whiteLister);
287         _;
288     }
289 }
290 contract ERC20 is ERC20Basic {
291   function allowance(address owner, address spender)
292     public view returns (uint256);
293 
294   function transferFrom(address from, address to, uint256 value)
295     public returns (bool);
296 
297   function approve(address spender, uint256 value) public returns (bool);
298   event Approval(
299     address indexed owner,
300     address indexed spender,
301     uint256 value
302   );
303 }
304 
305 contract BurnableToken is BasicToken {
306 
307   event Burn(address indexed burner, uint256 value);
308 
309   /**
310    * @dev Burns a specific amount of tokens.
311    * @param _value The amount of token to be burned.
312    */
313   function burn(uint256 _value) public {
314     _burn(msg.sender, _value);
315   }
316 
317   function _burn(address _who, uint256 _value) internal {
318     require(_value <= balances[_who]);
319     // no need to require value <= totalSupply, since that would imply the
320     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
321 
322     balances[_who] = balances[_who].sub(_value);
323     totalSupply_ = totalSupply_.sub(_value);
324     emit Burn(_who, _value);
325     emit Transfer(_who, address(0), _value);
326   }
327 }
328 
329 contract Salvageable is Operatable {
330     // Salvage other tokens that are accidentally sent into this token
331     function emergencyERC20Drain(ERC20 oddToken, uint amount) public onlyLauncher {
332         if (address(oddToken) == address(0)) {
333             launcher.transfer(amount);
334             return;
335         }
336         oddToken.transfer(launcher, amount);
337     }
338 }
339 contract StandardToken is ERC20, BasicToken {
340 
341   mapping (address => mapping (address => uint256)) internal allowed;
342 
343 
344   /**
345    * @dev Transfer tokens from one address to another
346    * @param _from address The address which you want to send tokens from
347    * @param _to address The address which you want to transfer to
348    * @param _value uint256 the amount of tokens to be transferred
349    */
350   function transferFrom(
351     address _from,
352     address _to,
353     uint256 _value
354   )
355     public
356     returns (bool)
357   {
358     require(_to != address(0));
359     require(_value <= balances[_from]);
360     require(_value <= allowed[_from][msg.sender]);
361 
362     balances[_from] = balances[_from].sub(_value);
363     balances[_to] = balances[_to].add(_value);
364     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
365     emit Transfer(_from, _to, _value);
366     return true;
367   }
368 
369   /**
370    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
371    *
372    * Beware that changing an allowance with this method brings the risk that someone may use both the old
373    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
374    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
375    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
376    * @param _spender The address which will spend the funds.
377    * @param _value The amount of tokens to be spent.
378    */
379   function approve(address _spender, uint256 _value) public returns (bool) {
380     allowed[msg.sender][_spender] = _value;
381     emit Approval(msg.sender, _spender, _value);
382     return true;
383   }
384 
385   /**
386    * @dev Function to check the amount of tokens that an owner allowed to a spender.
387    * @param _owner address The address which owns the funds.
388    * @param _spender address The address which will spend the funds.
389    * @return A uint256 specifying the amount of tokens still available for the spender.
390    */
391   function allowance(
392     address _owner,
393     address _spender
394    )
395     public
396     view
397     returns (uint256)
398   {
399     return allowed[_owner][_spender];
400   }
401 
402   /**
403    * @dev Increase the amount of tokens that an owner allowed to a spender.
404    *
405    * approve should be called when allowed[_spender] == 0. To increment
406    * allowed value is better to use this function to avoid 2 calls (and wait until
407    * the first transaction is mined)
408    * From MonolithDAO Token.sol
409    * @param _spender The address which will spend the funds.
410    * @param _addedValue The amount of tokens to increase the allowance by.
411    */
412   function increaseApproval(
413     address _spender,
414     uint _addedValue
415   )
416     public
417     returns (bool)
418   {
419     allowed[msg.sender][_spender] = (
420       allowed[msg.sender][_spender].add(_addedValue));
421     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
422     return true;
423   }
424 
425   /**
426    * @dev Decrease the amount of tokens that an owner allowed to a spender.
427    *
428    * approve should be called when allowed[_spender] == 0. To decrement
429    * allowed value is better to use this function to avoid 2 calls (and wait until
430    * the first transaction is mined)
431    * From MonolithDAO Token.sol
432    * @param _spender The address which will spend the funds.
433    * @param _subtractedValue The amount of tokens to decrease the allowance by.
434    */
435   function decreaseApproval(
436     address _spender,
437     uint _subtractedValue
438   )
439     public
440     returns (bool)
441   {
442     uint oldValue = allowed[msg.sender][_spender];
443     if (_subtractedValue > oldValue) {
444       allowed[msg.sender][_spender] = 0;
445     } else {
446       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
447     }
448     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
449     return true;
450   }
451 
452 }
453 
454 contract PausableToken is StandardToken, Pausable {
455 
456   function transfer(
457     address _to,
458     uint256 _value
459   )
460     public
461     whenNotPaused
462     returns (bool)
463   {
464     return super.transfer(_to, _value);
465   }
466 
467   function transferFrom(
468     address _from,
469     address _to,
470     uint256 _value
471   )
472     public
473     whenNotPaused
474     returns (bool)
475   {
476     return super.transferFrom(_from, _to, _value);
477   }
478 
479   function approve(
480     address _spender,
481     uint256 _value
482   )
483     public
484     whenNotPaused
485     returns (bool)
486   {
487     return super.approve(_spender, _value);
488   }
489 
490   function increaseApproval(
491     address _spender,
492     uint _addedValue
493   )
494     public
495     whenNotPaused
496     returns (bool success)
497   {
498     return super.increaseApproval(_spender, _addedValue);
499   }
500 
501   function decreaseApproval(
502     address _spender,
503     uint _subtractedValue
504   )
505     public
506     whenNotPaused
507     returns (bool success)
508   {
509     return super.decreaseApproval(_spender, _subtractedValue);
510   }
511 }
512 
513 contract GOeureka is  Salvageable, PausableToken, BurnableToken, GoConfig {
514     using SafeMath for uint;
515  
516     string public name = NAME;
517     string public symbol = SYMBOL;
518     uint8 public decimals = DECIMALS;
519     bool public mintingFinished = false;
520 
521     event Mint(address indexed to, uint amount);
522     event MintFinished();
523 
524     modifier canMint() {
525         require(!mintingFinished);
526         _;
527     }
528 
529     constructor() public {
530         paused = true;
531     }
532 
533     function mint(address _to, uint _amount) ownerOrMinter canMint public returns (bool) {
534         require(totalSupply_.add(_amount) <= TOTALSUPPLY);
535         totalSupply_ = totalSupply_.add(_amount);
536         balances[_to] = balances[_to].add(_amount);
537         emit Mint(_to, _amount);
538         emit Transfer(address(0), _to, _amount);
539         return true;
540     }
541 
542     function finishMinting() ownerOrMinter canMint public returns (bool) {
543         mintingFinished = true;
544         emit MintFinished();
545         return true;
546     }
547 
548     function sendBatchCS(address[] _recipients, uint[] _values) external ownerOrMinter returns (bool) {
549         require(_recipients.length == _values.length);
550         uint senderBalance = balances[msg.sender];
551         for (uint i = 0; i < _values.length; i++) {
552             uint value = _values[i];
553             address to = _recipients[i];
554             require(senderBalance >= value);        
555             senderBalance = senderBalance - value;
556             balances[to] += value;
557             emit Transfer(msg.sender, to, value);
558         }
559         balances[msg.sender] = senderBalance;
560         return true;
561     }
562 
563     // Lifted from ERC827
564 
565       /**
566    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
567    * @dev address and execute a call with the sent data on the same transaction
568    *
569    * @param _to address The address which you want to transfer to
570    * @param _value uint256 the amout of tokens to be transfered
571    * @param _data ABI-encoded contract call to call `_to` address.
572    *
573    * @return true if the call function was executed successfully
574    */
575     function transferAndCall(
576         address _to,
577         uint256 _value,
578         bytes _data
579     )
580     public
581     payable
582     whenNotPaused
583     returns (bool)
584     {
585         require(_to != address(this));
586 
587         super.transfer(_to, _value);
588 
589         // solium-disable-next-line security/no-call-value
590         require(_to.call.value(msg.value)(_data));
591         return true;
592     }
593 
594 
595 }
596 
597 contract GOeurekaSale is Claimable, gotTokenSaleConfig, Pausable, Salvageable {
598     using SafeMath for uint256;
599 
600     // The token being sold
601     GOeureka public token;
602 
603     WhiteListedBasic public whiteListed;
604 
605     uint256 public presaleEnd;
606     uint256 public saleEnd;
607 
608     // Minimum contribution is now calculated
609     uint256 public minContribution;
610 
611     // address where funds are collected
612     address public multiSig;
613 
614     // amount of raised funds in wei from private, presale and main sale
615     uint256 public weiRaised;
616 
617     // amount of raised tokens
618     uint256 public tokensRaised;
619 
620     // number of participants
621     mapping(address => uint256) public contributions;
622     uint256 public numberOfContributors = 0;
623 
624     //  for rate
625     uint public basicRate;
626  
627     // EVENTS
628 
629     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
630     event SaleClosed();
631     event HardcapReached();
632     event NewCapActivated(uint256 newCap);
633 
634  
635     // CONSTRUCTOR
636 
637     constructor(GOeureka token_, WhiteListedBasic _whiteListed) public {
638 
639         basicRate = 3000;  // TokensPerEther
640         calculateRates();
641         
642         presaleEnd = 1536508800; //20180910 00:00 +8
643         saleEnd = 1543593600; //20181201 00:00 +8
644 
645         multiSig = MULTISIG_ETH;
646 
647         // NOTE - toke
648         token = token_;
649 
650         whiteListed = _whiteListed;
651     }
652 
653     // This sale contract must be the minter before we mintAllocations or do anything else.
654     //
655     bool allocated = false;
656     function mintAllocations() external onlyOwner {
657         require(!allocated);
658         allocated = true;
659         token.mint(VESTING_WALLET,VESTING_AMOUNT);
660         token.mint(RESERVE_WALLET,RESERVE_AMOUNT);
661     }
662 
663     function setWallet(address _newWallet) public onlyOwner {
664         multiSig = _newWallet;
665     } 
666 
667 
668     // @return true if crowdsale event has ended
669     function hasEnded() public view returns (bool) {
670         if (now > saleEnd)
671             return true;
672         if (tokensRaised >= SALE_CAP)
673             return true; // if we reach the tokensForSale
674         return false;
675     }
676 
677     // Buyer must be whitelisted
678     function isWhiteListed(address beneficiary) internal view returns (bool) {
679         return whiteListed.isWhiteListed(beneficiary);
680     }
681 
682     modifier onlyAuthorised(address beneficiary) {
683         require(isWhiteListed(beneficiary),"Not authorised");
684         
685         require (!hasEnded(),"ended");
686         require (multiSig != 0x0,"MultiSig empty");
687         require ((msg.value > minContribution) || (tokensRaised.add(getTokens(msg.value)) == SALE_CAP),"Value too small");
688         _;
689     }
690 
691     function setNewRate(uint newRate) onlyOwner public {
692         require(weiRaised == 0);
693         require(1000 < newRate && newRate < 10000);
694         basicRate = newRate;
695         calculateRates();
696     }
697 
698     function calculateRates() internal {
699         minContribution = uint(100 * DECIMALSFACTOR).div(basicRate);
700     }
701 
702 
703     function getTokens(uint256 amountInWei) 
704     internal
705     view
706     returns (uint256 tokens)
707     {
708         if (now <= presaleEnd) {
709             uint theseTokens = amountInWei.mul(basicRate).mul(1125).div(1000);
710             require((amountInWei >= 1 ether) || (tokensRaised.add(theseTokens)==SALE_CAP));
711             return (theseTokens);
712         }
713         if (now <= saleEnd) { 
714             return (amountInWei.mul(basicRate));
715         }
716         revert();
717     }
718 
719   
720     // low level token purchase function
721     function buyTokens(address beneficiary, uint256 value)
722         internal
723         onlyAuthorised(beneficiary) 
724         whenNotPaused
725     {
726         uint256 newTokens;
727  
728         newTokens = getTokens(value);
729         weiRaised = weiRaised.add(value);
730         // if we have bridged two tranches....
731         if (contributions[beneficiary] == 0) {
732             numberOfContributors++;
733         }
734         contributions[beneficiary] = contributions[beneficiary].add(value);
735         tokensRaised = tokensRaised.add(newTokens);
736         token.mint(beneficiary,newTokens);
737         emit TokenPurchase(beneficiary, value, newTokens);
738         multiSig.transfer(value);
739     }
740 
741     function placeTokens(address beneficiary, uint256 tokens) 
742         public       
743         onlyOwner
744     {
745         require(!hasEnded());
746         tokensRaised = tokensRaised.add(tokens);
747         token.mint(beneficiary,tokens);
748     }
749 
750 
751     // Complete the sale
752     function finishSale() public onlyOwner {
753         require(hasEnded());
754         token.finishMinting();
755         emit SaleClosed();
756     }
757 
758     // fallback function can be used to buy tokens
759     function () public payable {
760         buyTokens(msg.sender, msg.value);
761     }
762 
763 }