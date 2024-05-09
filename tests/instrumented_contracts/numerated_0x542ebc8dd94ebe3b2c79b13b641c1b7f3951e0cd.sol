1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address _newOwner) public onlyOwner {
98     _transferOwnership(_newOwner);
99   }
100 
101   /**
102    * @dev Transfers control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function _transferOwnership(address _newOwner) internal {
106     require(_newOwner != address(0));
107     emit OwnershipTransferred(owner, _newOwner);
108     owner = _newOwner;
109   }
110 }
111 
112 /**
113  * @title ERC20Basic
114  * @dev Simpler version of ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/179
116  */
117 contract ERC20Basic {
118   function totalSupply() public view returns (uint256);
119   function balanceOf(address who) public view returns (uint256);
120   function transfer(address to, uint256 value) public returns (bool);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender)
130     public view returns (uint256);
131 
132   function transferFrom(address from, address to, uint256 value)
133     public returns (bool);
134 
135   function approve(address spender, uint256 value) public returns (bool);
136   event Approval(
137     address indexed owner,
138     address indexed spender,
139     uint256 value
140   );
141 }
142 
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances.
146  */
147 contract BasicToken is ERC20Basic {
148   using SafeMath for uint256;
149 
150   mapping(address => uint256) balances;
151 
152   uint256 totalSupply_;
153 
154   /**
155   * @dev total number of tokens in existence
156   */
157   function totalSupply() public view returns (uint256) {
158     return totalSupply_;
159   }
160 
161   /**
162   * @dev transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[msg.sender]);
169 
170     balances[msg.sender] = balances[msg.sender].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     emit Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address.
178   * @param _owner The address to query the the balance of.
179   * @return An uint256 representing the amount owned by the passed address.
180   */
181   function balanceOf(address _owner) public view returns (uint256) {
182     return balances[_owner];
183   }
184 
185 }
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * @dev https://github.com/ethereum/EIPs/issues/20
192  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(
206     address _from,
207     address _to,
208     uint256 _value
209   )
210     public
211     returns (bool)
212   {
213     require(_to != address(0));
214     require(_value <= balances[_from]);
215     require(_value <= allowed[_from][msg.sender]);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    *
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(
247     address _owner,
248     address _spender
249    )
250     public
251     view
252     returns (uint256)
253   {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(
268     address _spender,
269     uint _addedValue
270   )
271     public
272     returns (bool)
273   {
274     allowed[msg.sender][_spender] = (
275       allowed[msg.sender][_spender].add(_addedValue));
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(
291     address _spender,
292     uint _subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 /**
310  * @title Burnable Token
311  * @dev Token that can be irreversibly burned (destroyed).
312  */
313 contract BurnableToken is BasicToken {
314 
315   event Burn(address indexed burner, uint256 value);
316 
317   /**
318    * @dev Burns a specific amount of tokens.
319    * @param _value The amount of token to be burned.
320    */
321   function burn(uint256 _value) public {
322     _burn(msg.sender, _value);
323   }
324 
325   function _burn(address _who, uint256 _value) internal {
326     require(_value <= balances[_who]);
327     // no need to require value <= totalSupply, since that would imply the
328     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
329 
330     balances[_who] = balances[_who].sub(_value);
331     totalSupply_ = totalSupply_.sub(_value);
332     emit Burn(_who, _value);
333     emit Transfer(_who, address(0), _value);
334   }
335 }
336 
337 contract Token is StandardToken, BurnableToken, Ownable {
338 
339     /**
340     * @dev Use SafeMath library for all uint256 variables
341     */
342     using SafeMath for uint256;
343 
344     /**
345     * @dev ERC20 variables
346     */
347     string public name = "MIMIC";
348     string public symbol = "MIMIC";
349     uint256 public decimals = 18;
350 
351     /**
352     * @dev Total token supply
353     */
354     uint256 public INITIAL_SUPPLY = 900000000 * (10 ** decimals);
355 
356     /** 
357     * @dev Addresses where the tokens will be stored initially
358     */
359     address public constant ICO_ADDRESS        = 0x93Fc953BefEF145A92760476d56E45842CE00b2F;
360     address public constant PRESALE_ADDRESS    = 0x3be448B6dD35976b58A9935A1bf165d5593F8F27;
361 
362     /**
363     * @dev Address that can receive the tokens before the end of the ICO
364     */
365     address public constant BACKUP_ONE     = 0x9146EE4eb69f92b1e59BE9C7b4718d6B75F696bE;
366     address public constant BACKUP_TWO     = 0xe12F95964305a00550E1970c3189D6aF7DB9cFdd;
367     address public constant BACKUP_FOUR    = 0x2FBF54a91535A5497c2aF3BF5F64398C4A9177a2;
368     address public constant BACKUP_THREE   = 0xa41554b1c2d13F10504Cc2D56bF0Ba9f845C78AC;
369 
370     /** 
371     * @dev Team members has temporally locked token.
372     *      Variables used to define how the tokens will be unlocked.
373     */
374     uint256 public lockStartDate = 0;
375     uint256 public lockEndDate = 0;
376     uint256 public lockAbsoluteDifference = 0;
377     mapping (address => uint256) public initialLockedAmounts;
378 
379     /**
380     * @dev Defines if tokens arre free to move or not 
381     */
382     bool public areTokensFree = false;
383 
384     /** 
385     * @dev Emitted when the token locked amount of an address is set
386     */
387     event SetLockedAmount(address indexed owner, uint256 amount);
388 
389     /** 
390     * @dev Emitted when the token locked amount of an address is updated
391     */
392     event UpdateLockedAmount(address indexed owner, uint256 amount);
393 
394     /**
395     * @dev Emitted when it will be time to free the unlocked tokens
396     */
397     event FreeTokens();
398 
399     constructor() public {
400         totalSupply_ = INITIAL_SUPPLY;
401         balances[owner] = totalSupply_;
402     }
403 
404     /** 
405     * @dev Check whenever an address has the power to transfer tokens before the end of the ICO
406     * @param _sender Address of the transaction sender
407     * @param _to Destination address of the transaction
408     */
409     modifier canTransferBeforeEndOfIco(address _sender, address _to) {
410         require(
411             areTokensFree ||
412             _sender == owner ||
413             _sender == ICO_ADDRESS ||
414             _sender == PRESALE_ADDRESS ||
415             (
416                 _to == BACKUP_ONE ||
417                 _to == BACKUP_TWO ||
418                 _to == BACKUP_THREE || 
419                 _to == BACKUP_FOUR
420             )
421             , "Cannot transfer tokens yet"
422         );
423 
424         _;
425     }
426 
427     /** 
428     * @dev Check whenever an address can transfer an certain amount of token in the case all or some part
429     *      of them are locked
430     * @param _sender Address of the transaction sender
431     * @param _amount The amount of tokens the address is trying to transfer
432     */
433     modifier canTransferIfLocked(address _sender, uint256 _amount) {
434         uint256 afterTransfer = balances[_sender].sub(_amount);
435         require(afterTransfer >= getLockedAmount(_sender), "Not enought unlocked tokens");
436         
437         _;
438     }
439 
440     /** 
441     * @dev Returns the amount of tokens an address has locked
442     * @param _addr The address in question
443     */
444     function getLockedAmount(address _addr) public view returns (uint256){
445         if (now >= lockEndDate || initialLockedAmounts[_addr] == 0x0)
446             return 0;
447 
448         if (now < lockStartDate) 
449             return initialLockedAmounts[_addr];
450 
451         uint256 alpha = uint256(now).sub(lockStartDate); // absolute purchase date
452         uint256 tokens = initialLockedAmounts[_addr].sub(alpha.mul(initialLockedAmounts[_addr]).div(lockAbsoluteDifference)); // T - (α * T) / β
453 
454         return tokens;
455     }
456 
457     /** 
458     * @dev Sets the amount of locked tokens for a specific address. It doesn't transfer tokens!
459     * @param _addr The address in question
460     * @param _amount The amount of tokens to lock
461     */
462     function setLockedAmount(address _addr, uint256 _amount) public onlyOwner {
463         require(_addr != address(0x0), "Cannot set locked amount to null address");
464 
465         initialLockedAmounts[_addr] = _amount;
466 
467         emit SetLockedAmount(_addr, _amount);
468     }
469 
470     /** 
471     * @dev Updates (adds to) the amount of locked tokens for a specific address. It doesn't transfer tokens!
472     * @param _addr The address in question
473     * @param _amount The amount of locked tokens to add
474     */
475     function updateLockedAmount(address _addr, uint256 _amount) public onlyOwner {
476         require(_addr != address(0x0), "Cannot update locked amount to null address");
477         require(_amount > 0, "Cannot add 0");
478 
479         initialLockedAmounts[_addr] = initialLockedAmounts[_addr].add(_amount);
480 
481         emit UpdateLockedAmount(_addr, _amount);
482     }
483 
484     /**
485     * @dev Frees all the unlocked tokens
486     */
487     function freeTokens() public onlyOwner {
488         require(!areTokensFree, "Tokens have already been freed");
489 
490         areTokensFree = true;
491 
492         lockStartDate = now;
493         // lockEndDate = lockStartDate + 365 days;
494         lockEndDate = lockStartDate + 1 days;
495         lockAbsoluteDifference = lockEndDate.sub(lockStartDate);
496 
497         emit FreeTokens();
498     }
499 
500     /**
501     * @dev Override of ERC20's transfer function with modifiers
502     * @param _to The address to which tranfer the tokens
503     * @param _value The amount of tokens to transfer
504     */
505     function transfer(address _to, uint256 _value)
506         public
507         canTransferBeforeEndOfIco(msg.sender, _to) 
508         canTransferIfLocked(msg.sender, _value) 
509         returns (bool)
510     {
511         return super.transfer(_to, _value);
512     }
513 
514     /**
515     * @dev Override of ERC20's transfer function with modifiers
516     * @param _from The address from which tranfer the tokens
517     * @param _to The address to which tranfer the tokens
518     * @param _value The amount of tokens to transfer
519     */
520     function transferFrom(address _from, address _to, uint _value) 
521         public
522         canTransferBeforeEndOfIco(_from, _to) 
523         canTransferIfLocked(_from, _value) 
524         returns (bool) 
525     {
526         return super.transferFrom(_from, _to, _value);
527     }
528 
529 }
530 
531 contract Presale is Ownable {
532 
533     /**
534     * @dev Use SafeMath library for all uint256 variables
535     */
536     using SafeMath for uint256;
537 
538     /**
539     * @dev Our previously deployed Token (ERC20) contract
540     */
541     Token public token;
542 
543     /**
544     * @dev How many tokens a buyer takes per wei
545     */
546     uint256 public rate;
547 
548     /**
549     * @dev The address where all the funds will be stored
550     */
551     address public wallet;
552 
553     /**
554     * @dev The address where all the tokens are stored
555     */
556     address public holder;
557 
558     /**
559     * @dev The amount of wei raised during the ICO
560     */
561     uint256 public weiRaised;
562 
563     /**
564     * @dev The amount of tokens purchased by the buyers
565     */
566     uint256 public tokenPurchased;
567 
568     /**
569     * @dev Crowdsale start date
570     */
571     uint256 public constant startDate = 1535994000; // 2018-09-03 17:00:00 (UTC)
572 
573     /**
574     * @dev Crowdsale end date
575     */
576     uint256 public constant endDate = 1541264400; // 2018-10-01 10:00:00 (UTC)
577 
578     /**
579     * @dev The minimum amount of ethereum that we accept as a contribution
580     */
581     uint256 public minimumAmount = 40 ether;
582 
583     /**
584     * @dev The maximum amount of ethereum that an address can contribute
585     */
586     uint256 public maximumAmount = 200 ether;
587 
588     /**
589     * @dev Mapping tracking how much an address has contribuited
590     */
591     mapping (address => uint256) public contributionAmounts;
592 
593     /**
594     * @dev Mapping containing which addresses are whitelisted
595     */
596     mapping (address => bool) public whitelist;
597 
598     /**
599     * @dev Emitted when an amount of tokens is beign purchased
600     */
601     event Purchase(address indexed sender, address indexed beneficiary, uint256 value, uint256 amount);
602 
603     /**
604     * @dev Emitted when we change the conversion rate 
605     */
606     event ChangeRate(uint256 rate);
607 
608     /**
609     * @dev Emitted when we change the minimum contribution amount
610     */
611     event ChangeMinimumAmount(uint256 amount);
612 
613     /**
614     * @dev Emitted when we change the maximum contribution amount
615     */
616     event ChangeMaximumAmount(uint256 amount);
617 
618     /**
619     * @dev Emitted when the whitelisted state of and address is changed
620     */
621     event Whitelist(address indexed beneficiary, bool indexed whitelisted);
622 
623     /**
624     * @dev Contract constructor
625     * @param _tokenAddress The address of the previously deployed Token contract
626     */
627     constructor(address _tokenAddress, uint256 _rate, address _wallet, address _holder) public {
628         require(_tokenAddress != address(0), "Token Address cannot be a null address");
629         require(_rate > 0, "Conversion rate must be a positive integer");
630         require(_wallet != address(0), "Wallet Address cannot be a null address");
631         require(_holder != address(0), "Holder Address cannot be a null address");
632 
633         token = Token(_tokenAddress);
634         rate = _rate;
635         wallet = _wallet;
636         holder = _holder;
637     }
638 
639     /**
640     * @dev Modifier used to verify if an address can purchase
641     */
642     modifier canPurchase(address _beneficiary) {
643         require(now >= startDate, "Presale has not started yet");
644         require(now <= endDate, "Presale has finished");
645 
646         require(whitelist[_beneficiary] == true, "Your address is not whitelisted");
647 
648         uint256 amount = uint256(contributionAmounts[_beneficiary]).add(msg.value);
649 
650         require(msg.value >= minimumAmount, "Cannot contribute less than the minimum amount");
651         require(amount <= maximumAmount, "Cannot contribute more than the maximum amount");
652         
653         _;
654     }
655 
656     /**
657     * @dev Fallback function, called when someone tryes to pay send ether to the contract address
658     */
659     function () external payable {
660         purchase(msg.sender);
661     }
662 
663     /**
664     * @dev General purchase function, used by the fallback function and from buyers who are buying for other addresses
665     * @param _beneficiary The Address that will receive the tokens
666     */
667     function purchase(address _beneficiary) internal canPurchase(_beneficiary) {
668         uint256 weiAmount = msg.value;
669 
670         // Validate beneficiary and wei amount
671         require(_beneficiary != address(0), "Beneficiary Address cannot be a null address");
672         require(weiAmount > 0, "Wei amount must be a positive integer");
673 
674         // Calculate token amount
675         uint256 tokenAmount = _getTokenAmount(weiAmount);
676 
677         // Update totals
678         weiRaised = weiRaised.add(weiAmount);
679         tokenPurchased = tokenPurchased.add(tokenAmount);
680         contributionAmounts[_beneficiary] = contributionAmounts[_beneficiary].add(weiAmount);
681 
682         _transferEther(weiAmount);
683 
684         // Make the actual purchase and send the tokens to the contributor
685         _purchaseTokens(_beneficiary, tokenAmount);
686 
687         // Emit purchase event
688         emit Purchase(msg.sender, _beneficiary, weiAmount, tokenAmount);
689     }
690 
691     /**
692     * @dev Updates the conversion rate to a new value
693     * @param _rate The new conversion rate
694     */
695     function updateConversionRate(uint256 _rate) public onlyOwner {
696         require(_rate > 0, "Conversion rate must be a positive integer");
697 
698         rate = _rate;
699 
700         emit ChangeRate(_rate);
701     }
702 
703     /**
704     * @dev Updates the minimum contribution amount to a new value
705     * @param _amount The new minimum contribution amount expressed in wei
706     */
707     function updateMinimumAmount(uint256 _amount) public onlyOwner {
708         require(_amount > 0, "Minimum amount must be a positive integer");
709 
710         minimumAmount = _amount;
711 
712         emit ChangeMinimumAmount(_amount);
713     }
714 
715     /**
716     * @dev Updates the maximum contribution amount to a new value
717     * @param _amount The new maximum contribution amount expressed in wei
718     */
719     function updateMaximumAmount(uint256 _amount) public onlyOwner {
720         require(_amount > 0, "Maximum amount must be a positive integer");
721 
722         maximumAmount = _amount;
723 
724         emit ChangeMaximumAmount(_amount);
725     }
726 
727     /**
728     * @dev Updates the whitelisted status of an address
729     * @param _addr The address in question
730     * @param _whitelist The new whitelist status
731     */
732     function setWhitelist(address _addr, bool _whitelist) public onlyOwner {
733         require(_addr != address(0x0), "Whitelisted address must be valid");
734 
735         whitelist[_addr] = _whitelist;
736 
737         emit Whitelist(_addr, _whitelist);
738     }
739 
740     /**
741     * @dev Processes the actual purchase (token transfer)
742     * @param _beneficiary The Address that will receive the tokens
743     * @param _amount The amount of tokens to transfer
744     */
745     function _purchaseTokens(address _beneficiary, uint256 _amount) internal {
746         token.transferFrom(holder, _beneficiary, _amount);
747     }
748 
749     /**
750     * @dev Transfers the ethers recreived from the contributor to the Presale wallet
751     * @param _amount The amount of ethers to transfer
752     */
753     function _transferEther(uint256 _amount) internal {
754         // this should throw an exeption if it fails
755         wallet.transfer(_amount);
756     }
757 
758     /**
759     * @dev Returns an amount of wei converted in tokens
760     * @param _wei Value in wei to be converted
761     * @return Amount of tokens 
762     */
763     function _getTokenAmount(uint256 _wei) internal view returns (uint256) {
764         // wei * ((rate * (30 + 100)) / 100)
765         return _wei.mul(rate.mul(130).div(100));
766     }
767 
768 }