1 pragma solidity ^0.4.23;
2 
3 // File: contracts/JSECoinCrowdsaleConfig.sol
4 
5 contract JSECoinCrowdsaleConfig {
6     
7     uint8 public constant   TOKEN_DECIMALS = 18;
8     uint256 public constant DECIMALSFACTOR = 10**uint256(TOKEN_DECIMALS);
9 
10     uint256 public constant DURATION                                = 12 weeks; 
11     uint256 public constant CONTRIBUTION_MIN                        = 0.1 ether; // Around $64
12     uint256 public constant CONTRIBUTION_MAX_NO_WHITELIST           = 20 ether; // $9,000
13     uint256 public constant CONTRIBUTION_MAX                        = 10000.0 ether; //After Whitelisting
14     
15     uint256 public constant TOKENS_MAX                              = 10000000000 * (10 ** uint256(TOKEN_DECIMALS)); //10,000,000,000 aka 10 billion
16     uint256 public constant TOKENS_SALE                             = 5000000000 * DECIMALSFACTOR; //50%
17     uint256 public constant TOKENS_DISTRIBUTED                      = 5000000000 * DECIMALSFACTOR; //50%
18 
19 
20     // For the public sale, tokens are priced at 0.006 USD/token.
21     // So if we have 450 USD/ETH -> 450,000 USD/KETH / 0.006 USD/token = ~75000000
22                                                                     //    3600000
23     uint256 public constant TOKENS_PER_KETHER                       = 75000000;
24 
25     // Constant used by buyTokens as part of the cost <-> tokens conversion.
26     // 18 for ETH -> WEI, TOKEN_DECIMALS (18 for JSE Coin Token), 3 for the K in tokensPerKEther.
27     uint256 public constant PURCHASE_DIVIDER                        = 10**(uint256(18) - TOKEN_DECIMALS + 3);
28 
29 }
30 
31 // File: contracts/ERC223.sol
32 
33 /**
34  * @title Interface for an ERC223 Contract
35  * @author Amr Gawish <amr@gawi.sh>
36  * @dev Only one method is unique to contracts `transfer(address _to, uint _value, bytes _data)`
37  * @notice The interface has been stripped to its unique methods to prevent duplicating methods with ERC20 interface
38 */
39 interface ERC223 {
40     function transfer(address _to, uint _value, bytes _data) external returns (bool);
41     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
42 }
43 
44 // File: contracts/ERC223ReceivingContract.sol
45 
46 /**
47  * @title Contract that will work with ERC223 tokens.
48  */
49  
50 contract ERC223ReceivingContract { 
51 
52     /**
53     * @dev Standard ERC223 function that will handle incoming token transfers.
54     *
55     * @param _from  Token sender address.
56     * @param _value Amount of tokens.
57     * @param _data  Transaction metadata.
58     */
59     function tokenFallback(address _from, uint _value, bytes _data) public;
60 }
61 
62 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
63 
64 /**
65  * @title Ownable
66  * @dev The Ownable contract has an owner address, and provides basic authorization control
67  * functions, this simplifies the implementation of "user permissions".
68  */
69 contract Ownable {
70   address public owner;
71 
72 
73   event OwnershipRenounced(address indexed previousOwner);
74   event OwnershipTransferred(
75     address indexed previousOwner,
76     address indexed newOwner
77   );
78 
79 
80   /**
81    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82    * account.
83    */
84   constructor() public {
85     owner = msg.sender;
86   }
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96   /**
97    * @dev Allows the current owner to relinquish control of the contract.
98    */
99   function renounceOwnership() public onlyOwner {
100     emit OwnershipRenounced(owner);
101     owner = address(0);
102   }
103 
104   /**
105    * @dev Allows the current owner to transfer control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function transferOwnership(address _newOwner) public onlyOwner {
109     _transferOwnership(_newOwner);
110   }
111 
112   /**
113    * @dev Transfers control of the contract to a newOwner.
114    * @param _newOwner The address to transfer ownership to.
115    */
116   function _transferOwnership(address _newOwner) internal {
117     require(_newOwner != address(0));
118     emit OwnershipTransferred(owner, _newOwner);
119     owner = _newOwner;
120   }
121 }
122 
123 // File: contracts/OperatorManaged.sol
124 
125 // Simple JSE Operator management contract
126 contract OperatorManaged is Ownable {
127 
128     address public operatorAddress;
129     address public adminAddress;
130 
131     event AdminAddressChanged(address indexed _newAddress);
132     event OperatorAddressChanged(address indexed _newAddress);
133 
134 
135     constructor() public
136         Ownable()
137     {
138         adminAddress = msg.sender;
139     }
140 
141     modifier onlyAdmin() {
142         require(isAdmin(msg.sender));
143         _;
144     }
145 
146 
147     modifier onlyAdminOrOperator() {
148         require(isAdmin(msg.sender) || isOperator(msg.sender));
149         _;
150     }
151 
152 
153     modifier onlyOwnerOrAdmin() {
154         require(isOwner(msg.sender) || isAdmin(msg.sender));
155         _;
156     }
157 
158 
159     modifier onlyOperator() {
160         require(isOperator(msg.sender));
161         _;
162     }
163 
164 
165     function isAdmin(address _address) internal view returns (bool) {
166         return (adminAddress != address(0) && _address == adminAddress);
167     }
168 
169 
170     function isOperator(address _address) internal view returns (bool) {
171         return (operatorAddress != address(0) && _address == operatorAddress);
172     }
173 
174     function isOwner(address _address) internal view returns (bool) {
175         return (owner != address(0) && _address == owner);
176     }
177 
178 
179     function isOwnerOrOperator(address _address) internal view returns (bool) {
180         return (isOwner(_address) || isOperator(_address));
181     }
182 
183 
184     // Owner and Admin can change the admin address. Address can also be set to 0 to 'disable' it.
185     function setAdminAddress(address _adminAddress) external onlyOwnerOrAdmin returns (bool) {
186         require(_adminAddress != owner);
187         require(_adminAddress != address(this));
188         require(!isOperator(_adminAddress));
189 
190         adminAddress = _adminAddress;
191 
192         emit AdminAddressChanged(_adminAddress);
193 
194         return true;
195     }
196 
197 
198     // Owner and Admin can change the operations address. Address can also be set to 0 to 'disable' it.
199     function setOperatorAddress(address _operatorAddress) external onlyOwnerOrAdmin returns (bool) {
200         require(_operatorAddress != owner);
201         require(_operatorAddress != address(this));
202         require(!isAdmin(_operatorAddress));
203 
204         operatorAddress = _operatorAddress;
205 
206         emit OperatorAddressChanged(_operatorAddress);
207 
208         return true;
209     }
210 }
211 
212 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
213 
214 /**
215  * @title SafeMath
216  * @dev Math operations with safety checks that throw on error
217  */
218 library SafeMath {
219 
220   /**
221   * @dev Multiplies two numbers, throws on overflow.
222   */
223   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
224     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
225     // benefit is lost if 'b' is also tested.
226     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
227     if (a == 0) {
228       return 0;
229     }
230 
231     c = a * b;
232     assert(c / a == b);
233     return c;
234   }
235 
236   /**
237   * @dev Integer division of two numbers, truncating the quotient.
238   */
239   function div(uint256 a, uint256 b) internal pure returns (uint256) {
240     // assert(b > 0); // Solidity automatically throws when dividing by 0
241     // uint256 c = a / b;
242     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243     return a / b;
244   }
245 
246   /**
247   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
248   */
249   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
250     assert(b <= a);
251     return a - b;
252   }
253 
254   /**
255   * @dev Adds two numbers, throws on overflow.
256   */
257   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
258     c = a + b;
259     assert(c >= a);
260     return c;
261   }
262 }
263 
264 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
265 
266 /**
267  * @title ERC20Basic
268  * @dev Simpler version of ERC20 interface
269  * @dev see https://github.com/ethereum/EIPs/issues/179
270  */
271 contract ERC20Basic {
272   function totalSupply() public view returns (uint256);
273   function balanceOf(address who) public view returns (uint256);
274   function transfer(address to, uint256 value) public returns (bool);
275   event Transfer(address indexed from, address indexed to, uint256 value);
276 }
277 
278 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
279 
280 /**
281  * @title Basic token
282  * @dev Basic version of StandardToken, with no allowances.
283  */
284 contract BasicToken is ERC20Basic {
285   using SafeMath for uint256;
286 
287   mapping(address => uint256) balances;
288 
289   uint256 totalSupply_;
290 
291   /**
292   * @dev total number of tokens in existence
293   */
294   function totalSupply() public view returns (uint256) {
295     return totalSupply_;
296   }
297 
298   /**
299   * @dev transfer token for a specified address
300   * @param _to The address to transfer to.
301   * @param _value The amount to be transferred.
302   */
303   function transfer(address _to, uint256 _value) public returns (bool) {
304     require(_to != address(0));
305     require(_value <= balances[msg.sender]);
306 
307     balances[msg.sender] = balances[msg.sender].sub(_value);
308     balances[_to] = balances[_to].add(_value);
309     emit Transfer(msg.sender, _to, _value);
310     return true;
311   }
312 
313   /**
314   * @dev Gets the balance of the specified address.
315   * @param _owner The address to query the the balance of.
316   * @return An uint256 representing the amount owned by the passed address.
317   */
318   function balanceOf(address _owner) public view returns (uint256) {
319     return balances[_owner];
320   }
321 
322 }
323 
324 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
325 
326 /**
327  * @title ERC20 interface
328  * @dev see https://github.com/ethereum/EIPs/issues/20
329  */
330 contract ERC20 is ERC20Basic {
331   function allowance(address owner, address spender)
332     public view returns (uint256);
333 
334   function transferFrom(address from, address to, uint256 value)
335     public returns (bool);
336 
337   function approve(address spender, uint256 value) public returns (bool);
338   event Approval(
339     address indexed owner,
340     address indexed spender,
341     uint256 value
342   );
343 }
344 
345 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
346 
347 /**
348  * @title Standard ERC20 token
349  *
350  * @dev Implementation of the basic standard token.
351  * @dev https://github.com/ethereum/EIPs/issues/20
352  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
353  */
354 contract StandardToken is ERC20, BasicToken {
355 
356   mapping (address => mapping (address => uint256)) internal allowed;
357 
358 
359   /**
360    * @dev Transfer tokens from one address to another
361    * @param _from address The address which you want to send tokens from
362    * @param _to address The address which you want to transfer to
363    * @param _value uint256 the amount of tokens to be transferred
364    */
365   function transferFrom(
366     address _from,
367     address _to,
368     uint256 _value
369   )
370     public
371     returns (bool)
372   {
373     require(_to != address(0));
374     require(_value <= balances[_from]);
375     require(_value <= allowed[_from][msg.sender]);
376 
377     balances[_from] = balances[_from].sub(_value);
378     balances[_to] = balances[_to].add(_value);
379     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
380     emit Transfer(_from, _to, _value);
381     return true;
382   }
383 
384   /**
385    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
386    *
387    * Beware that changing an allowance with this method brings the risk that someone may use both the old
388    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
389    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
390    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
391    * @param _spender The address which will spend the funds.
392    * @param _value The amount of tokens to be spent.
393    */
394   function approve(address _spender, uint256 _value) public returns (bool) {
395     allowed[msg.sender][_spender] = _value;
396     emit Approval(msg.sender, _spender, _value);
397     return true;
398   }
399 
400   /**
401    * @dev Function to check the amount of tokens that an owner allowed to a spender.
402    * @param _owner address The address which owns the funds.
403    * @param _spender address The address which will spend the funds.
404    * @return A uint256 specifying the amount of tokens still available for the spender.
405    */
406   function allowance(
407     address _owner,
408     address _spender
409    )
410     public
411     view
412     returns (uint256)
413   {
414     return allowed[_owner][_spender];
415   }
416 
417   /**
418    * @dev Increase the amount of tokens that an owner allowed to a spender.
419    *
420    * approve should be called when allowed[_spender] == 0. To increment
421    * allowed value is better to use this function to avoid 2 calls (and wait until
422    * the first transaction is mined)
423    * From MonolithDAO Token.sol
424    * @param _spender The address which will spend the funds.
425    * @param _addedValue The amount of tokens to increase the allowance by.
426    */
427   function increaseApproval(
428     address _spender,
429     uint _addedValue
430   )
431     public
432     returns (bool)
433   {
434     allowed[msg.sender][_spender] = (
435       allowed[msg.sender][_spender].add(_addedValue));
436     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
437     return true;
438   }
439 
440   /**
441    * @dev Decrease the amount of tokens that an owner allowed to a spender.
442    *
443    * approve should be called when allowed[_spender] == 0. To decrement
444    * allowed value is better to use this function to avoid 2 calls (and wait until
445    * the first transaction is mined)
446    * From MonolithDAO Token.sol
447    * @param _spender The address which will spend the funds.
448    * @param _subtractedValue The amount of tokens to decrease the allowance by.
449    */
450   function decreaseApproval(
451     address _spender,
452     uint _subtractedValue
453   )
454     public
455     returns (bool)
456   {
457     uint oldValue = allowed[msg.sender][_spender];
458     if (_subtractedValue > oldValue) {
459       allowed[msg.sender][_spender] = 0;
460     } else {
461       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
462     }
463     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
464     return true;
465   }
466 
467 }
468 
469 // File: openzeppelin-solidity/contracts/token/ERC20//MintableToken.sol
470 
471 /**
472  * @title Mintable token
473  * @dev Simple ERC20 Token example, with mintable token creation
474  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
475  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
476  */
477 contract MintableToken is StandardToken, Ownable {
478   event Mint(address indexed to, uint256 amount);
479   event MintFinished();
480 
481   bool public mintingFinished = false;
482 
483 
484   modifier canMint() {
485     require(!mintingFinished);
486     _;
487   }
488 
489   modifier hasMintPermission() {
490     require(msg.sender == owner);
491     _;
492   }
493 
494   /**
495    * @dev Function to mint tokens
496    * @param _to The address that will receive the minted tokens.
497    * @param _amount The amount of tokens to mint.
498    * @return A boolean that indicates if the operation was successful.
499    */
500   function mint(
501     address _to,
502     uint256 _amount
503   )
504     hasMintPermission
505     canMint
506     public
507     returns (bool)
508   {
509     totalSupply_ = totalSupply_.add(_amount);
510     balances[_to] = balances[_to].add(_amount);
511     emit Mint(_to, _amount);
512     emit Transfer(address(0), _to, _amount);
513     return true;
514   }
515 
516   /**
517    * @dev Function to stop minting new tokens.
518    * @return True if the operation was successful.
519    */
520   function finishMinting() onlyOwner canMint public returns (bool) {
521     mintingFinished = true;
522     emit MintFinished();
523     return true;
524   }
525 }
526 
527 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
528 
529 /**
530  * @title Burnable Token
531  * @dev Token that can be irreversibly burned (destroyed).
532  */
533 contract BurnableToken is BasicToken {
534 
535   event Burn(address indexed burner, uint256 value);
536 
537   /**
538    * @dev Burns a specific amount of tokens.
539    * @param _value The amount of token to be burned.
540    */
541   function burn(uint256 _value) public {
542     _burn(msg.sender, _value);
543   }
544 
545   function _burn(address _who, uint256 _value) internal {
546     require(_value <= balances[_who]);
547     // no need to require value <= totalSupply, since that would imply the
548     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
549 
550     balances[_who] = balances[_who].sub(_value);
551     totalSupply_ = totalSupply_.sub(_value);
552     emit Burn(_who, _value);
553     emit Transfer(_who, address(0), _value);
554   }
555 }
556 
557 // File: contracts/JSEToken.sol
558 
559 /**
560  * @title Main Token Contract for JSE Coin
561  * @author Amr Gawish <amr@gawi.sh>
562  * @dev This Token is the Mintable and Burnable to allow variety of actions to be done by users.
563  * @dev It also complies with both ERC20 and ERC223.
564  * @notice Trying to use JSE Token to Contracts that doesn't accept tokens and doesn't have tokenFallback function will fail, and all contracts
565  * must comply to ERC223 compliance. 
566 */
567 contract JSEToken is ERC223, BurnableToken, Ownable, MintableToken, OperatorManaged {
568     
569     event Finalized();
570 
571     string public name = "JSE Token";
572     string public symbol = "JSE";
573     uint public decimals = 18;
574     uint public initialSupply = 10000000000 * (10 ** decimals); //10,000,000,000 aka 10 billion
575 
576     bool public finalized;
577 
578     constructor() OperatorManaged() public {
579         totalSupply_ = initialSupply;
580         balances[msg.sender] = initialSupply; 
581 
582         emit Transfer(0x0, msg.sender, initialSupply);
583     }
584 
585 
586     // Implementation of the standard transferFrom method that takes into account the finalize flag.
587     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
588         checkTransferAllowed(msg.sender, _to);
589 
590         return super.transferFrom(_from, _to, _value);
591     }
592 
593     function checkTransferAllowed(address _sender, address _to) private view {
594         if (finalized) {
595             // Everybody should be ok to transfer once the token is finalized.
596             return;
597         }
598 
599         // Owner and Ops are allowed to transfer tokens before the sale is finalized.
600         // This allows the tokens to move from the TokenSale contract to a beneficiary.
601         // We also allow someone to send tokens back to the owner. This is useful among other
602         // cases, for the Trustee to transfer unlocked tokens back to the owner (reclaimTokens).
603         require(isOwnerOrOperator(_sender) || _to == owner);
604     }
605 
606     // Implementation of the standard transfer method that takes into account the finalize flag.
607     function transfer(address _to, uint256 _value) public returns (bool success) {
608         checkTransferAllowed(msg.sender, _to);
609 
610         return super.transfer(_to, _value);
611     }
612 
613     /**
614     * @dev transfer token for a specified contract address
615     * @param _to The address to transfer to.
616     * @param _value The amount to be transferred.
617     * @param _data Additional Data sent to the contract.
618     */
619     function transfer(address _to, uint _value, bytes _data) external returns (bool) {
620         checkTransferAllowed(msg.sender, _to);
621 
622         require(_to != address(0));
623         require(_value <= balances[msg.sender]);
624         require(isContract(_to));
625 
626 
627         balances[msg.sender] = balances[msg.sender].sub(_value);
628         balances[_to] = balances[_to].add(_value);
629         ERC223ReceivingContract erc223Contract = ERC223ReceivingContract(_to);
630         erc223Contract.tokenFallback(msg.sender, _value, _data);
631 
632         emit Transfer(msg.sender, _to, _value);
633         return true;
634     }
635 
636     /** 
637     * @dev Owner can transfer out any accidentally sent ERC20 tokens
638     */
639     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
640         return ERC20(tokenAddress).transfer(owner, tokens);
641     }
642 
643     function isContract(address _addr) private view returns (bool) {
644         uint codeSize;
645         /* solium-disable-next-line */
646         assembly {
647             codeSize := extcodesize(_addr)
648         }
649         return codeSize > 0;
650     }
651 
652     // Finalize method marks the point where token transfers are finally allowed for everybody.
653     function finalize() external onlyAdmin returns (bool success) {
654         require(!finalized);
655 
656         finalized = true;
657 
658         emit Finalized();
659 
660         return true;
661     }
662 }
663 
664 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
665 
666 /**
667  * @title Pausable
668  * @dev Base contract which allows children to implement an emergency stop mechanism.
669  */
670 contract Pausable is Ownable {
671   event Pause();
672   event Unpause();
673 
674   bool public paused = false;
675 
676 
677   /**
678    * @dev Modifier to make a function callable only when the contract is not paused.
679    */
680   modifier whenNotPaused() {
681     require(!paused);
682     _;
683   }
684 
685   /**
686    * @dev Modifier to make a function callable only when the contract is paused.
687    */
688   modifier whenPaused() {
689     require(paused);
690     _;
691   }
692 
693   /**
694    * @dev called by the owner to pause, triggers stopped state
695    */
696   function pause() onlyOwner whenNotPaused public {
697     paused = true;
698     emit Pause();
699   }
700 
701   /**
702    * @dev called by the owner to unpause, returns to normal state
703    */
704   function unpause() onlyOwner whenPaused public {
705     paused = false;
706     emit Unpause();
707   }
708 }
709 
710 // File: contracts/JSETokenSale.sol
711 
712 //
713 // Implementation of the token sale of JSE Token
714 //
715 // * Lifecycle *
716 // Initialization sequence should be as follow:
717 //    1. Deploy JSEToken contract
718 //    2. Deploy JSETokenSale contract
719 //    3. Set operationsAddress of JSEToken contract to JSETokenSale contract
720 //    4. Transfer tokens from owner to JSETokenSale contract
721 //    5. Transfer tokens from owner to Distributer Account
722 //    6. Initialize JSETokenSale contract
723 //
724 // Pre-sale sequence:
725 //    - Set tokensPerKEther
726 //    - Update whitelist
727 //    - Start public sale
728 //
729 // After-sale sequence:
730 //    1. Finalize the JSETokenSale contract
731 //    2. Finalize the JSEToken contract
732 //    3. Set operationsAddress of JSETokenSale contract to 0
733 //    4. Set operationsAddress of JSEToken contract to 0
734 
735 
736 contract JSETokenSale is OperatorManaged, Pausable, JSECoinCrowdsaleConfig { // Pausable is also Owned
737 
738     using SafeMath for uint256;
739 
740 
741     // We keep track of whether the sale has been finalized, at which point
742     // no additional contributions will be permitted.
743     bool public finalized;
744 
745     // Public Sales start trigger
746     bool public publicSaleStarted;
747 
748     // Number of tokens per 1000 ETH. See JSETokenSaleConfig for details.
749     uint256 public tokensPerKEther;
750 
751     // Increase Percentage Bonus of buying tokens
752     uint256 public bonusIncreasePercentage = 10; //percentage
753 
754     // Address where the funds collected during the sale will be forwarded.
755     address public wallet;
756 
757     // Token contract that the sale contract will interact with.
758     JSEToken public tokenContract;
759 
760     // // JSETrustee contract to hold on token balances. The following token pools will be held by trustee:
761     // //    - Founders
762     // //    - Advisors
763     // //    - Early investors
764     // //    - Presales
765     // address private distributerAccount;
766 
767     // Total amount of tokens sold during presale + public sale. Excludes pre-sale bonuses.
768     uint256 public totalTokensSold;
769 
770     // Total amount of tokens given as bonus during presale. Will influence accelerator token balance.
771     uint256 public totalPresaleBase;
772     uint256 public totalPresaleBonus;
773 
774     // Map of addresses that have been whitelisted in advance (and passed KYC).
775     mapping(address => bool) public whitelist;
776 
777     // Amount of wei raised
778     uint256 public weiRaised;
779 
780     //
781     // EVENTS
782     //
783     event Initialized();
784     event PresaleAdded(address indexed _account, uint256 _baseTokens, uint256 _bonusTokens);
785     event WhitelistUpdated(address indexed _account);
786     event TokensPurchased(address indexed _beneficiary, uint256 _cost, uint256 _tokens, uint256 _totalSold);
787     event TokensPerKEtherUpdated(uint256 _amount);
788     event WalletChanged(address _newWallet);
789     event TokensReclaimed(uint256 _amount);
790     event UnsoldTokensBurnt(uint256 _amount);
791     event BonusIncreasePercentageChanged(uint256 _oldPercentage, uint256 _newPercentage);
792     event Finalized();
793 
794 
795     constructor(JSEToken _tokenContract, address _wallet) public
796         OperatorManaged()
797     {
798         require(address(_tokenContract) != address(0));
799         //  require(address(_distributerAccount) != address(0));
800         require(_wallet != address(0));
801 
802         require(TOKENS_PER_KETHER > 0);
803 
804 
805         wallet                  = _wallet;
806         finalized               = false;
807         publicSaleStarted       = false;
808         tokensPerKEther         = TOKENS_PER_KETHER;
809         tokenContract           = _tokenContract;
810         //distributerAccount      = _distributerAccount;
811     }
812 
813 
814     // Initialize is called to check some configuration parameters.
815     // It expects that a certain amount of tokens have already been assigned to the sale contract address.
816     function initialize() external onlyOwner returns (bool) {
817         require(totalTokensSold == 0);
818         require(totalPresaleBase == 0);
819         require(totalPresaleBonus == 0);
820 
821         uint256 ownBalance = tokenContract.balanceOf(address(this));
822         require(ownBalance == TOKENS_SALE);
823 
824         emit Initialized();
825 
826         return true;
827     }
828 
829 
830     // Allows the admin to change the wallet where ETH contributions are sent.
831     function changeWallet(address _wallet) external onlyAdmin returns (bool) {
832         require(_wallet != address(0));
833         require(_wallet != address(this));
834         // require(_wallet != address(distributerAccount));
835         require(_wallet != address(tokenContract));
836 
837         wallet = _wallet;
838 
839         emit WalletChanged(wallet);
840 
841         return true;
842     }
843 
844 
845 
846     //
847     // TIME
848     //
849 
850     function currentTime() public view returns (uint256 _currentTime) {
851         return now;
852     }
853 
854 
855     modifier onlyBeforeSale() {
856         require(hasSaleEnded() == false && publicSaleStarted == false);
857         _;
858     }
859 
860 
861     modifier onlyDuringSale() {
862         require(hasSaleEnded() == false && publicSaleStarted == true);
863         _;
864     }
865 
866     modifier onlyAfterSale() {
867         // require finalized is stronger than hasSaleEnded
868         require(finalized);
869         _;
870     }
871 
872 
873     function hasSaleEnded() private view returns (bool) {
874         // if sold out or finalized, sale has ended
875         if (finalized) {
876             return true;
877         } else {
878             return false;
879         }
880     }
881 
882 
883 
884     //
885     // WHITELIST
886     //
887 
888     // Allows operator to add accounts to the whitelist.
889     // Only those accounts will be allowed to contribute above the threshold
890     function updateWhitelist(address _account) external onlyAdminOrOperator returns (bool) {
891         require(_account != address(0));
892         require(!hasSaleEnded());
893 
894         whitelist[_account] = true;
895 
896         emit WhitelistUpdated(_account);
897 
898         return true;
899     }
900 
901     //
902     // PURCHASES / CONTRIBUTIONS
903     //
904 
905     // Allows the admin to set the price for tokens sold during phases 1 and 2 of the sale.
906     function setTokensPerKEther(uint256 _tokensPerKEther) external onlyAdmin onlyBeforeSale returns (bool) {
907         require(_tokensPerKEther > 0);
908 
909         tokensPerKEther = _tokensPerKEther;
910 
911         emit TokensPerKEtherUpdated(_tokensPerKEther);
912 
913         return true;
914     }
915 
916 
917     function () external payable whenNotPaused onlyDuringSale {
918         buyTokens();
919     }
920 
921 
922     // This is the main function to process incoming ETH contributions.
923     function buyTokens() public payable whenNotPaused onlyDuringSale returns (bool) {
924         require(msg.value >= CONTRIBUTION_MIN);
925         require(msg.value <= CONTRIBUTION_MAX);
926         require(totalTokensSold < TOKENS_SALE);
927 
928         // All accounts need to be whitelisted to purchase if the value above the CONTRIBUTION_MAX_NO_WHITELIST
929         bool whitelisted = whitelist[msg.sender];
930         if(msg.value >= CONTRIBUTION_MAX_NO_WHITELIST){
931             require(whitelisted);
932         }
933 
934         uint256 tokensMax = TOKENS_SALE.sub(totalTokensSold);
935 
936         require(tokensMax > 0);
937         
938         uint256 actualAmount = msg.value.mul(tokensPerKEther).div(PURCHASE_DIVIDER);
939 
940         uint256 bonusAmount = actualAmount.mul(bonusIncreasePercentage).div(100);
941 
942         uint256 tokensBought = actualAmount.add(bonusAmount);
943 
944         require(tokensBought > 0);
945 
946         uint256 cost = msg.value;
947         uint256 refund = 0;
948 
949         if (tokensBought > tokensMax) {
950             // Not enough tokens available for full contribution, we will do partial.
951             tokensBought = tokensMax;
952 
953             // Calculate actual cost for partial amount of tokens.
954             cost = tokensBought.mul(PURCHASE_DIVIDER).div(tokensPerKEther);
955 
956             // Calculate refund for contributor.
957             refund = msg.value.sub(cost);
958         }
959 
960         totalTokensSold = totalTokensSold.add(tokensBought);
961 
962         // Transfer tokens to the account
963         require(tokenContract.transfer(msg.sender, tokensBought));
964 
965         // Issue a ETH refund for any unused portion of the funds.
966         if (refund > 0) {
967             msg.sender.transfer(refund);
968         }
969 
970         // update state
971         weiRaised = weiRaised.add(msg.value.sub(refund));
972 
973         // Transfer the contribution to the wallet
974         wallet.transfer(msg.value.sub(refund));
975 
976         emit TokensPurchased(msg.sender, cost, tokensBought, totalTokensSold);
977 
978         // If all tokens available for sale have been sold out, finalize the sale automatically.
979         if (totalTokensSold == TOKENS_SALE) {
980             finalizeInternal();
981         }
982 
983         return true;
984     }
985 
986 
987 
988     // Allows the admin to move bonus tokens still available in the sale contract
989     // out before burning all remaining unsold tokens in burnUnsoldTokens().
990     // Used to distribute bonuses to token sale participants when the sale has ended
991     // and all bonuses are known.
992     function reclaimTokens(uint256 _amount) external onlyAfterSale onlyAdmin returns (bool) {
993         uint256 ownBalance = tokenContract.balanceOf(address(this));
994         require(_amount <= ownBalance);
995         
996         address tokenOwner = tokenContract.owner();
997         require(tokenOwner != address(0));
998 
999         require(tokenContract.transfer(tokenOwner, _amount));
1000 
1001         emit TokensReclaimed(_amount);
1002 
1003         return true;
1004     }
1005 
1006     function changeBonusIncreasePercentage(uint256 _newPercentage) external onlyDuringSale onlyAdmin returns (bool) {
1007         uint oldPercentage = bonusIncreasePercentage;
1008         bonusIncreasePercentage = _newPercentage;
1009         emit BonusIncreasePercentageChanged(oldPercentage, _newPercentage);
1010         return true;
1011     }
1012 
1013     // Allows the admin to finalize the sale and complete allocations.
1014     // The JSEToken.admin also needs to finalize the token contract
1015     // so that token transfers are enabled.
1016     function finalize() external onlyAdmin returns (bool) {
1017         return finalizeInternal();
1018     }
1019 
1020     function startPublicSale() external onlyAdmin onlyBeforeSale returns (bool) {
1021         publicSaleStarted = true;
1022         return true;
1023     }
1024 
1025 
1026     // The internal one will be called if tokens are sold out or
1027     // the end time for the sale is reached, in addition to being called
1028     // from the public version of finalize().
1029     function finalizeInternal() private returns (bool) {
1030         require(!finalized);
1031 
1032         finalized = true;
1033 
1034         emit Finalized();
1035 
1036         return true;
1037     }
1038 }