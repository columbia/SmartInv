1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Eliptic curve signature operations
5  *
6  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
7  *
8  * TODO Remove this library once solidity supports passing a signature to ecrecover.
9  * See https://github.com/ethereum/solidity/issues/864
10  *
11  */
12 
13 library ECRecovery {
14 
15   /**
16    * @dev Recover signer address from a message by using their signature
17    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
18    * @param sig bytes signature, the signature is generated using web3.eth.sign()
19    */
20   function recover(bytes32 hash, bytes sig)
21     internal
22     pure
23     returns (address)
24   {
25     bytes32 r;
26     bytes32 s;
27     uint8 v;
28 
29     // Check the signature length
30     if (sig.length != 65) {
31       return (address(0));
32     }
33 
34     // Divide the signature in r, s and v variables
35     // ecrecover takes the signature parameters, and the only way to get them
36     // currently is to use assembly.
37     // solium-disable-next-line security/no-inline-assembly
38     assembly {
39       r := mload(add(sig, 32))
40       s := mload(add(sig, 64))
41       v := byte(0, mload(add(sig, 96)))
42     }
43 
44     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
45     if (v < 27) {
46       v += 27;
47     }
48 
49     // If the version is correct return the signer address
50     if (v != 27 && v != 28) {
51       return (address(0));
52     } else {
53       // solium-disable-next-line arg-overflow
54       return ecrecover(hash, v, r, s);
55     }
56   }
57 
58   /**
59    * toEthSignedMessageHash
60    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
61    * @dev and hash the result
62    */
63   function toEthSignedMessageHash(bytes32 hash)
64     internal
65     pure
66     returns (bytes32)
67   {
68     // 32 is the length in bytes of hash,
69     // enforced by the type signature above
70     return keccak256(
71       "\x19Ethereum Signed Message:\n32",
72       hash
73     );
74   }
75 }
76 
77 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * See https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85   function totalSupply() public view returns (uint256);
86   function balanceOf(address _who) public view returns (uint256);
87   function transfer(address _to, uint256 _value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
103     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (_a == 0) {
107       return 0;
108     }
109 
110     c = _a * _b;
111     assert(c / _a == _b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
119     // assert(_b > 0); // Solidity automatically throws when dividing by 0
120     // uint256 c = _a / _b;
121     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
122     return _a / _b;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
129     assert(_b <= _a);
130     return _a - _b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
137     c = _a + _b;
138     assert(c >= _a);
139     return c;
140   }
141 }
142 
143 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) internal balances;
153 
154   uint256 internal totalSupply_;
155 
156   /**
157   * @dev Total number of tokens in existence
158   */
159   function totalSupply() public view returns (uint256) {
160     return totalSupply_;
161   }
162 
163   /**
164   * @dev Transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169     require(_value <= balances[msg.sender]);
170     require(_to != address(0));
171 
172     balances[msg.sender] = balances[msg.sender].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     emit Transfer(msg.sender, _to, _value);
175     return true;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address _owner) public view returns (uint256) {
184     return balances[_owner];
185   }
186 
187 }
188 
189 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
190 
191 /**
192  * @title ERC20 interface
193  * @dev see https://github.com/ethereum/EIPs/issues/20
194  */
195 contract ERC20 is ERC20Basic {
196   function allowance(address _owner, address _spender)
197     public view returns (uint256);
198 
199   function transferFrom(address _from, address _to, uint256 _value)
200     public returns (bool);
201 
202   function approve(address _spender, uint256 _value) public returns (bool);
203   event Approval(
204     address indexed owner,
205     address indexed spender,
206     uint256 value
207   );
208 }
209 
210 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
211 
212 /**
213  * @title Standard ERC20 token
214  *
215  * @dev Implementation of the basic standard token.
216  * https://github.com/ethereum/EIPs/issues/20
217  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
218  */
219 contract StandardToken is ERC20, BasicToken {
220 
221   mapping (address => mapping (address => uint256)) internal allowed;
222 
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param _from address The address which you want to send tokens from
227    * @param _to address The address which you want to transfer to
228    * @param _value uint256 the amount of tokens to be transferred
229    */
230   function transferFrom(
231     address _from,
232     address _to,
233     uint256 _value
234   )
235     public
236     returns (bool)
237   {
238     require(_value <= balances[_from]);
239     require(_value <= allowed[_from][msg.sender]);
240     require(_to != address(0));
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245     emit Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    * Beware that changing an allowance with this method brings the risk that someone may use both the old
252    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255    * @param _spender The address which will spend the funds.
256    * @param _value The amount of tokens to be spent.
257    */
258   function approve(address _spender, uint256 _value) public returns (bool) {
259     allowed[msg.sender][_spender] = _value;
260     emit Approval(msg.sender, _spender, _value);
261     return true;
262   }
263 
264   /**
265    * @dev Function to check the amount of tokens that an owner allowed to a spender.
266    * @param _owner address The address which owns the funds.
267    * @param _spender address The address which will spend the funds.
268    * @return A uint256 specifying the amount of tokens still available for the spender.
269    */
270   function allowance(
271     address _owner,
272     address _spender
273    )
274     public
275     view
276     returns (uint256)
277   {
278     return allowed[_owner][_spender];
279   }
280 
281   /**
282    * @dev Increase the amount of tokens that an owner allowed to a spender.
283    * approve should be called when allowed[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _addedValue The amount of tokens to increase the allowance by.
289    */
290   function increaseApproval(
291     address _spender,
292     uint256 _addedValue
293   )
294     public
295     returns (bool)
296   {
297     allowed[msg.sender][_spender] = (
298       allowed[msg.sender][_spender].add(_addedValue));
299     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    * approve should be called when allowed[_spender] == 0. To decrement
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param _spender The address which will spend the funds.
310    * @param _subtractedValue The amount of tokens to decrease the allowance by.
311    */
312   function decreaseApproval(
313     address _spender,
314     uint256 _subtractedValue
315   )
316     public
317     returns (bool)
318   {
319     uint256 oldValue = allowed[msg.sender][_spender];
320     if (_subtractedValue >= oldValue) {
321       allowed[msg.sender][_spender] = 0;
322     } else {
323       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
324     }
325     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326     return true;
327   }
328 
329 }
330 
331 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
332 
333 /**
334  * @title Ownable
335  * @dev The Ownable contract has an owner address, and provides basic authorization control
336  * functions, this simplifies the implementation of "user permissions".
337  */
338 contract Ownable {
339   address public owner;
340 
341 
342   event OwnershipRenounced(address indexed previousOwner);
343   event OwnershipTransferred(
344     address indexed previousOwner,
345     address indexed newOwner
346   );
347 
348 
349   /**
350    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
351    * account.
352    */
353   constructor() public {
354     owner = msg.sender;
355   }
356 
357   /**
358    * @dev Throws if called by any account other than the owner.
359    */
360   modifier onlyOwner() {
361     require(msg.sender == owner);
362     _;
363   }
364 
365   /**
366    * @dev Allows the current owner to relinquish control of the contract.
367    * @notice Renouncing to ownership will leave the contract without an owner.
368    * It will not be possible to call the functions with the `onlyOwner`
369    * modifier anymore.
370    */
371   function renounceOwnership() public onlyOwner {
372     emit OwnershipRenounced(owner);
373     owner = address(0);
374   }
375 
376   /**
377    * @dev Allows the current owner to transfer control of the contract to a newOwner.
378    * @param _newOwner The address to transfer ownership to.
379    */
380   function transferOwnership(address _newOwner) public onlyOwner {
381     _transferOwnership(_newOwner);
382   }
383 
384   /**
385    * @dev Transfers control of the contract to a newOwner.
386    * @param _newOwner The address to transfer ownership to.
387    */
388   function _transferOwnership(address _newOwner) internal {
389     require(_newOwner != address(0));
390     emit OwnershipTransferred(owner, _newOwner);
391     owner = _newOwner;
392   }
393 }
394 
395 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
396 
397 /**
398  * @title Mintable token
399  * @dev Simple ERC20 Token example, with mintable token creation
400  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
401  */
402 contract MintableToken is StandardToken, Ownable {
403   event Mint(address indexed to, uint256 amount);
404   event MintFinished();
405 
406   bool public mintingFinished = false;
407 
408 
409   modifier canMint() {
410     require(!mintingFinished);
411     _;
412   }
413 
414   modifier hasMintPermission() {
415     require(msg.sender == owner);
416     _;
417   }
418 
419   /**
420    * @dev Function to mint tokens
421    * @param _to The address that will receive the minted tokens.
422    * @param _amount The amount of tokens to mint.
423    * @return A boolean that indicates if the operation was successful.
424    */
425   function mint(
426     address _to,
427     uint256 _amount
428   )
429     public
430     hasMintPermission
431     canMint
432     returns (bool)
433   {
434     totalSupply_ = totalSupply_.add(_amount);
435     balances[_to] = balances[_to].add(_amount);
436     emit Mint(_to, _amount);
437     emit Transfer(address(0), _to, _amount);
438     return true;
439   }
440 
441   /**
442    * @dev Function to stop minting new tokens.
443    * @return True if the operation was successful.
444    */
445   function finishMinting() public onlyOwner canMint returns (bool) {
446     mintingFinished = true;
447     emit MintFinished();
448     return true;
449   }
450 }
451 
452 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
453 
454 /**
455  * @title Burnable Token
456  * @dev Token that can be irreversibly burned (destroyed).
457  */
458 contract BurnableToken is BasicToken {
459 
460   event Burn(address indexed burner, uint256 value);
461 
462   /**
463    * @dev Burns a specific amount of tokens.
464    * @param _value The amount of token to be burned.
465    */
466   function burn(uint256 _value) public {
467     _burn(msg.sender, _value);
468   }
469 
470   function _burn(address _who, uint256 _value) internal {
471     require(_value <= balances[_who]);
472     // no need to require value <= totalSupply, since that would imply the
473     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
474 
475     balances[_who] = balances[_who].sub(_value);
476     totalSupply_ = totalSupply_.sub(_value);
477     emit Burn(_who, _value);
478     emit Transfer(_who, address(0), _value);
479   }
480 }
481 
482 // File: contracts/robonomics/XRT.sol
483 
484 contract XRT is MintableToken, BurnableToken {
485     string public constant name     = "Robonomics Beta";
486     string public constant symbol   = "XRT";
487     uint   public constant decimals = 9;
488 
489     uint256 public constant INITIAL_SUPPLY = 1000 * (10 ** uint256(decimals));
490 
491     constructor() public {
492         totalSupply_ = INITIAL_SUPPLY;
493         balances[msg.sender] = INITIAL_SUPPLY;
494         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
495     }
496 }
497 
498 
499 // File: contracts/robonomics/DutchAuction.sol
500 
501 /// @title Dutch auction contract - distribution of XRT tokens using an auction.
502 /// @author Stefan George - <stefan.george@consensys.net>
503 /// @author Airalab - <research@aira.life> 
504 contract DutchAuction {
505 
506     /*
507      *  Events
508      */
509     event BidSubmission(address indexed sender, uint256 amount);
510 
511     /*
512      *  Constants
513      */
514     uint constant public MAX_TOKENS_SOLD = 8000 * 10**9; // 8M XRT = 10M - 1M (Foundation) - 1M (Early investors base)
515     uint constant public WAITING_PERIOD = 0; // 1 days;
516 
517     /*
518      *  Storage
519      */
520     XRT     public xrt;
521     address public ambix;
522     address public wallet;
523     address public owner;
524     uint public ceiling;
525     uint public priceFactor;
526     uint public startBlock;
527     uint public endTime;
528     uint public totalReceived;
529     uint public finalPrice;
530     mapping (address => uint) public bids;
531     Stages public stage;
532 
533     /*
534      *  Enums
535      */
536     enum Stages {
537         AuctionDeployed,
538         AuctionSetUp,
539         AuctionStarted,
540         AuctionEnded,
541         TradingStarted
542     }
543 
544     /*
545      *  Modifiers
546      */
547     modifier atStage(Stages _stage) {
548         // Contract on stage
549         require(stage == _stage);
550         _;
551     }
552 
553     modifier isOwner() {
554         // Only owner is allowed to proceed
555         require(msg.sender == owner);
556         _;
557     }
558 
559     modifier isWallet() {
560         // Only wallet is allowed to proceed
561         require(msg.sender == wallet);
562         _;
563     }
564 
565     modifier isValidPayload() {
566         require(msg.data.length == 4 || msg.data.length == 36);
567         _;
568     }
569 
570     modifier timedTransitions() {
571         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
572             finalizeAuction();
573         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
574             stage = Stages.TradingStarted;
575         _;
576     }
577 
578     /*
579      *  Public functions
580      */
581     /// @dev Contract constructor function sets owner.
582     /// @param _wallet Multisig wallet.
583     /// @param _ceiling Auction ceiling.
584     /// @param _priceFactor Auction price factor.
585     constructor(address _wallet, uint _ceiling, uint _priceFactor)
586         public
587     {
588         require(_wallet != 0 && _ceiling != 0 && _priceFactor != 0);
589         owner = msg.sender;
590         wallet = _wallet;
591         ceiling = _ceiling;
592         priceFactor = _priceFactor;
593         stage = Stages.AuctionDeployed;
594     }
595 
596     /// @dev Setup function sets external contracts' addresses.
597     /// @param _xrt Robonomics token address.
598     /// @param _ambix Distillation cube address.
599     function setup(address _xrt, address _ambix)
600         public
601         isOwner
602         atStage(Stages.AuctionDeployed)
603     {
604         // Validate argument
605         require(_xrt != 0 && _ambix != 0);
606         xrt = XRT(_xrt);
607         ambix = _ambix;
608 
609         // Validate token balance
610         require(xrt.balanceOf(this) == MAX_TOKENS_SOLD);
611 
612         stage = Stages.AuctionSetUp;
613     }
614 
615     /// @dev Starts auction and sets startBlock.
616     function startAuction()
617         public
618         isWallet
619         atStage(Stages.AuctionSetUp)
620     {
621         stage = Stages.AuctionStarted;
622         startBlock = block.number;
623     }
624 
625     /// @dev Changes auction ceiling and start price factor before auction is started.
626     /// @param _ceiling Updated auction ceiling.
627     /// @param _priceFactor Updated start price factor.
628     function changeSettings(uint _ceiling, uint _priceFactor)
629         public
630         isWallet
631         atStage(Stages.AuctionSetUp)
632     {
633         ceiling = _ceiling;
634         priceFactor = _priceFactor;
635     }
636 
637     /// @dev Calculates current token price.
638     /// @return Returns token price.
639     function calcCurrentTokenPrice()
640         public
641         timedTransitions
642         returns (uint)
643     {
644         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
645             return finalPrice;
646         return calcTokenPrice();
647     }
648 
649     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
650     /// @return Returns current auction stage.
651     function updateStage()
652         public
653         timedTransitions
654         returns (Stages)
655     {
656         return stage;
657     }
658 
659     /// @dev Allows to send a bid to the auction.
660     /// @param receiver Bid will be assigned to this address if set.
661     function bid(address receiver)
662         public
663         payable
664         isValidPayload
665         timedTransitions
666         atStage(Stages.AuctionStarted)
667         returns (uint amount)
668     {
669         require(msg.value > 0);
670         amount = msg.value;
671 
672         // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
673         if (receiver == 0)
674             receiver = msg.sender;
675 
676         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
677         uint maxWei = MAX_TOKENS_SOLD * calcTokenPrice() / 10**9 - totalReceived;
678         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
679         if (maxWeiBasedOnTotalReceived < maxWei)
680             maxWei = maxWeiBasedOnTotalReceived;
681 
682         // Only invest maximum possible amount.
683         if (amount > maxWei) {
684             amount = maxWei;
685             // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
686             receiver.transfer(msg.value - amount);
687         }
688 
689         // Forward funding to ether wallet
690         wallet.transfer(amount);
691 
692         bids[receiver] += amount;
693         totalReceived += amount;
694         BidSubmission(receiver, amount);
695 
696         // Finalize auction when maxWei reached
697         if (amount == maxWei)
698             finalizeAuction();
699     }
700 
701     /// @dev Claims tokens for bidder after auction.
702     /// @param receiver Tokens will be assigned to this address if set.
703     function claimTokens(address receiver)
704         public
705         isValidPayload
706         timedTransitions
707         atStage(Stages.TradingStarted)
708     {
709         if (receiver == 0)
710             receiver = msg.sender;
711         uint tokenCount = bids[receiver] * 10**9 / finalPrice;
712         bids[receiver] = 0;
713         require(xrt.transfer(receiver, tokenCount));
714     }
715 
716     /// @dev Calculates stop price.
717     /// @return Returns stop price.
718     function calcStopPrice()
719         view
720         public
721         returns (uint)
722     {
723         return totalReceived * 10**9 / MAX_TOKENS_SOLD + 1;
724     }
725 
726     /// @dev Calculates token price.
727     /// @return Returns token price.
728     function calcTokenPrice()
729         view
730         public
731         returns (uint)
732     {
733         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
734     }
735 
736     /*
737      *  Private functions
738      */
739     function finalizeAuction()
740         private
741     {
742         stage = Stages.AuctionEnded;
743         finalPrice = totalReceived == ceiling ? calcTokenPrice() : calcStopPrice();
744         uint soldTokens = totalReceived * 10**9 / finalPrice;
745 
746         if (totalReceived == ceiling) {
747             // Auction contract transfers all unsold tokens to Ambix contract
748             require(xrt.transfer(ambix, MAX_TOKENS_SOLD - soldTokens));
749         } else {
750             // Auction contract burn all unsold tokens
751             xrt.burn(MAX_TOKENS_SOLD - soldTokens);
752         }
753 
754         endTime = now;
755     }
756 }
757 
758 // File: ens/contracts/ENS.sol
759 
760 interface ENS {
761 
762     // Logged when the owner of a node assigns a new owner to a subnode.
763     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
764 
765     // Logged when the owner of a node transfers ownership to a new account.
766     event Transfer(bytes32 indexed node, address owner);
767 
768     // Logged when the resolver for a node changes.
769     event NewResolver(bytes32 indexed node, address resolver);
770 
771     // Logged when the TTL of a node changes
772     event NewTTL(bytes32 indexed node, uint64 ttl);
773 
774 
775     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
776     function setResolver(bytes32 node, address resolver) public;
777     function setOwner(bytes32 node, address owner) public;
778     function setTTL(bytes32 node, uint64 ttl) public;
779     function owner(bytes32 node) public view returns (address);
780     function resolver(bytes32 node) public view returns (address);
781     function ttl(bytes32 node) public view returns (uint64);
782 
783 }
784 
785 // File: ens/contracts/PublicResolver.sol
786 
787 /**
788  * A simple resolver anyone can use; only allows the owner of a node to set its
789  * address.
790  */
791 contract PublicResolver {
792 
793     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
794     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
795     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
796     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
797     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
798     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
799     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
800     bytes4 constant MULTIHASH_INTERFACE_ID = 0xe89401a1;
801 
802     event AddrChanged(bytes32 indexed node, address a);
803     event ContentChanged(bytes32 indexed node, bytes32 hash);
804     event NameChanged(bytes32 indexed node, string name);
805     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
806     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
807     event TextChanged(bytes32 indexed node, string indexedKey, string key);
808     event MultihashChanged(bytes32 indexed node, bytes hash);
809 
810     struct PublicKey {
811         bytes32 x;
812         bytes32 y;
813     }
814 
815     struct Record {
816         address addr;
817         bytes32 content;
818         string name;
819         PublicKey pubkey;
820         mapping(string=>string) text;
821         mapping(uint256=>bytes) abis;
822         bytes multihash;
823     }
824 
825     ENS ens;
826 
827     mapping (bytes32 => Record) records;
828 
829     modifier only_owner(bytes32 node) {
830         require(ens.owner(node) == msg.sender);
831         _;
832     }
833 
834     /**
835      * Constructor.
836      * @param ensAddr The ENS registrar contract.
837      */
838     function PublicResolver(ENS ensAddr) public {
839         ens = ensAddr;
840     }
841 
842     /**
843      * Sets the address associated with an ENS node.
844      * May only be called by the owner of that node in the ENS registry.
845      * @param node The node to update.
846      * @param addr The address to set.
847      */
848     function setAddr(bytes32 node, address addr) public only_owner(node) {
849         records[node].addr = addr;
850         AddrChanged(node, addr);
851     }
852 
853     /**
854      * Sets the content hash associated with an ENS node.
855      * May only be called by the owner of that node in the ENS registry.
856      * Note that this resource type is not standardized, and will likely change
857      * in future to a resource type based on multihash.
858      * @param node The node to update.
859      * @param hash The content hash to set
860      */
861     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
862         records[node].content = hash;
863         ContentChanged(node, hash);
864     }
865 
866     /**
867      * Sets the multihash associated with an ENS node.
868      * May only be called by the owner of that node in the ENS registry.
869      * @param node The node to update.
870      * @param hash The multihash to set
871      */
872     function setMultihash(bytes32 node, bytes hash) public only_owner(node) {
873         records[node].multihash = hash;
874         MultihashChanged(node, hash);
875     }
876     
877     /**
878      * Sets the name associated with an ENS node, for reverse records.
879      * May only be called by the owner of that node in the ENS registry.
880      * @param node The node to update.
881      * @param name The name to set.
882      */
883     function setName(bytes32 node, string name) public only_owner(node) {
884         records[node].name = name;
885         NameChanged(node, name);
886     }
887 
888     /**
889      * Sets the ABI associated with an ENS node.
890      * Nodes may have one ABI of each content type. To remove an ABI, set it to
891      * the empty string.
892      * @param node The node to update.
893      * @param contentType The content type of the ABI
894      * @param data The ABI data.
895      */
896     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
897         // Content types must be powers of 2
898         require(((contentType - 1) & contentType) == 0);
899         
900         records[node].abis[contentType] = data;
901         ABIChanged(node, contentType);
902     }
903     
904     /**
905      * Sets the SECP256k1 public key associated with an ENS node.
906      * @param node The ENS node to query
907      * @param x the X coordinate of the curve point for the public key.
908      * @param y the Y coordinate of the curve point for the public key.
909      */
910     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
911         records[node].pubkey = PublicKey(x, y);
912         PubkeyChanged(node, x, y);
913     }
914 
915     /**
916      * Sets the text data associated with an ENS node and key.
917      * May only be called by the owner of that node in the ENS registry.
918      * @param node The node to update.
919      * @param key The key to set.
920      * @param value The text data value to set.
921      */
922     function setText(bytes32 node, string key, string value) public only_owner(node) {
923         records[node].text[key] = value;
924         TextChanged(node, key, key);
925     }
926 
927     /**
928      * Returns the text data associated with an ENS node and key.
929      * @param node The ENS node to query.
930      * @param key The text data key to query.
931      * @return The associated text data.
932      */
933     function text(bytes32 node, string key) public view returns (string) {
934         return records[node].text[key];
935     }
936 
937     /**
938      * Returns the SECP256k1 public key associated with an ENS node.
939      * Defined in EIP 619.
940      * @param node The ENS node to query
941      * @return x, y the X and Y coordinates of the curve point for the public key.
942      */
943     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
944         return (records[node].pubkey.x, records[node].pubkey.y);
945     }
946 
947     /**
948      * Returns the ABI associated with an ENS node.
949      * Defined in EIP205.
950      * @param node The ENS node to query
951      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
952      * @return contentType The content type of the return value
953      * @return data The ABI data
954      */
955     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
956         Record storage record = records[node];
957         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
958             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
959                 data = record.abis[contentType];
960                 return;
961             }
962         }
963         contentType = 0;
964     }
965 
966     /**
967      * Returns the name associated with an ENS node, for reverse records.
968      * Defined in EIP181.
969      * @param node The ENS node to query.
970      * @return The associated name.
971      */
972     function name(bytes32 node) public view returns (string) {
973         return records[node].name;
974     }
975 
976     /**
977      * Returns the content hash associated with an ENS node.
978      * Note that this resource type is not standardized, and will likely change
979      * in future to a resource type based on multihash.
980      * @param node The ENS node to query.
981      * @return The associated content hash.
982      */
983     function content(bytes32 node) public view returns (bytes32) {
984         return records[node].content;
985     }
986 
987     /**
988      * Returns the multihash associated with an ENS node.
989      * @param node The ENS node to query.
990      * @return The associated multihash.
991      */
992     function multihash(bytes32 node) public view returns (bytes) {
993         return records[node].multihash;
994     }
995 
996     /**
997      * Returns the address associated with an ENS node.
998      * @param node The ENS node to query.
999      * @return The associated address.
1000      */
1001     function addr(bytes32 node) public view returns (address) {
1002         return records[node].addr;
1003     }
1004 
1005     /**
1006      * Returns true if the resolver implements the interface specified by the provided hash.
1007      * @param interfaceID The ID of the interface to check for.
1008      * @return True if the contract implements the requested interface.
1009      */
1010     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
1011         return interfaceID == ADDR_INTERFACE_ID ||
1012         interfaceID == CONTENT_INTERFACE_ID ||
1013         interfaceID == NAME_INTERFACE_ID ||
1014         interfaceID == ABI_INTERFACE_ID ||
1015         interfaceID == PUBKEY_INTERFACE_ID ||
1016         interfaceID == TEXT_INTERFACE_ID ||
1017         interfaceID == MULTIHASH_INTERFACE_ID ||
1018         interfaceID == INTERFACE_META_ID;
1019     }
1020 }
1021 
1022 contract LightContract {
1023     /**
1024      * @dev Shared code smart contract 
1025      */
1026     address lib;
1027 
1028     constructor(address _library) public {
1029         lib = _library;
1030     }
1031 
1032     function() public {
1033         require(lib.delegatecall(msg.data));
1034     }
1035 }
1036 
1037 contract LighthouseABI {
1038     function refill(uint256 _value) external;
1039     function withdraw(uint256 _value) external;
1040     function to(address _to, bytes _data) external;
1041     function () external;
1042 }
1043 
1044 contract LighthouseAPI {
1045     address[] public members;
1046     mapping(address => uint256) indexOf;
1047 
1048     mapping(address => uint256) public balances;
1049 
1050     uint256 public minimalFreeze;
1051     uint256 public timeoutBlocks;
1052 
1053     LiabilityFactory public factory;
1054     XRT              public xrt;
1055 
1056     uint256 public keepaliveBlock = 0;
1057     uint256 public marker = 0;
1058     uint256 public quota = 0;
1059 
1060     function quotaOf(address _member) public view returns (uint256)
1061     { return balances[_member] / minimalFreeze; }
1062 }
1063 
1064 contract LighthouseLib is LighthouseAPI, LighthouseABI {
1065 
1066     function refill(uint256 _value) external {
1067         require(xrt.transferFrom(msg.sender, this, _value));
1068         require(_value >= minimalFreeze);
1069 
1070         if (balances[msg.sender] == 0) {
1071             indexOf[msg.sender] = members.length;
1072             members.push(msg.sender);
1073         }
1074         balances[msg.sender] += _value;
1075     }
1076 
1077     function withdraw(uint256 _value) external {
1078         require(balances[msg.sender] >= _value);
1079 
1080         balances[msg.sender] -= _value;
1081         require(xrt.transfer(msg.sender, _value));
1082 
1083         // Drop member if quota go to zero
1084         if (quotaOf(msg.sender) == 0) {
1085             uint256 balance = balances[msg.sender];
1086             balances[msg.sender] = 0;
1087             require(xrt.transfer(msg.sender, balance)); 
1088             
1089             uint256 senderIndex = indexOf[msg.sender];
1090             uint256 lastIndex = members.length - 1;
1091             if (senderIndex < lastIndex)
1092                 members[senderIndex] = members[lastIndex];
1093             members.length -= 1;
1094         }
1095     }
1096 
1097     function nextMember() internal
1098     { marker = (marker + 1) % members.length; }
1099 
1100     modifier quoted {
1101         if (quota == 0) {
1102             // Step over marker
1103             nextMember();
1104 
1105             // Allocate new quota
1106             quota = quotaOf(members[marker]);
1107         }
1108 
1109         // Consume one quota for transaction sending
1110         assert(quota > 0);
1111         quota -= 1;
1112 
1113         _;
1114     }
1115 
1116     modifier keepalive {
1117         if (timeoutBlocks < block.number - keepaliveBlock) {
1118             // Search keepalive sender
1119             while (msg.sender != members[marker])
1120                 nextMember();
1121 
1122             // Allocate new quota
1123             quota = quotaOf(members[marker]);
1124         }
1125 
1126         _;
1127     }
1128 
1129     modifier member {
1130         // Zero members guard
1131         require(members.length > 0);
1132 
1133         // Only member with marker can to send transaction
1134         require(msg.sender == members[marker]);
1135 
1136         // Store transaction sending block
1137         keepaliveBlock = block.number;
1138 
1139         _;
1140     }
1141 
1142     function to(address _to, bytes _data) external keepalive quoted member {
1143         require(factory.gasUtilizing(_to) > 0);
1144         require(_to.call(_data));
1145     }
1146 
1147     function () external keepalive quoted member
1148     { require(factory.call(msg.data)); }
1149 }
1150 
1151 contract Lighthouse is LighthouseAPI, LightContract {
1152     constructor(
1153         address _lib,
1154         uint256 _minimalFreeze,
1155         uint256 _timeoutBlocks
1156     ) 
1157         public
1158         LightContract(_lib)
1159     {
1160         minimalFreeze = _minimalFreeze;
1161         timeoutBlocks = _timeoutBlocks;
1162         factory = LiabilityFactory(msg.sender);
1163         xrt = factory.xrt();
1164     }
1165 }
1166 
1167 contract RobotLiabilityABI {
1168     function ask(
1169         bytes   _model,
1170         bytes   _objective,
1171 
1172         ERC20   _token,
1173         uint256 _cost,
1174 
1175         address _validator,
1176         uint256 _validator_fee,
1177 
1178         uint256 _deadline,
1179         bytes32 _nonce,
1180         bytes   _signature
1181     ) external returns (bool);
1182 
1183     function bid(
1184         bytes   _model,
1185         bytes   _objective,
1186         
1187         ERC20   _token,
1188         uint256 _cost,
1189 
1190         uint256 _lighthouse_fee,
1191 
1192         uint256 _deadline,
1193         bytes32 _nonce,
1194         bytes   _signature
1195     ) external returns (bool);
1196 
1197     function finalize(
1198         bytes _result,
1199         bytes _signature,
1200         bool  _agree
1201     ) external returns (bool);
1202 }
1203 
1204 contract RobotLiabilityAPI {
1205     bytes   public model;
1206     bytes   public objective;
1207     bytes   public result;
1208 
1209     ERC20   public token;
1210     uint256 public cost;
1211     uint256 public lighthouseFee;
1212     uint256 public validatorFee;
1213 
1214     bytes32 public askHash;
1215     bytes32 public bidHash;
1216 
1217     address public promisor;
1218     address public promisee;
1219     address public validator;
1220 
1221     bool    public isConfirmed;
1222     bool    public isFinalized;
1223 
1224     LiabilityFactory public factory;
1225 }
1226 
1227 contract RobotLiabilityLib is RobotLiabilityABI
1228                             , RobotLiabilityAPI {
1229     using ECRecovery for bytes32;
1230 
1231     function ask(
1232         bytes   _model,
1233         bytes   _objective,
1234 
1235         ERC20   _token,
1236         uint256 _cost,
1237 
1238         address _validator,
1239         uint256 _validator_fee,
1240 
1241         uint256 _deadline,
1242         bytes32 _nonce,
1243         bytes   _signature
1244     )
1245         external
1246         returns (bool)
1247     {
1248         require(msg.sender == address(factory));
1249         require(block.number < _deadline);
1250 
1251         model        = _model;
1252         objective    = _objective;
1253         token        = _token;
1254         cost         = _cost;
1255         validator    = _validator;
1256         validatorFee = _validator_fee;
1257 
1258         askHash = keccak256(abi.encodePacked(
1259             _model
1260           , _objective
1261           , _token
1262           , _cost
1263           , _validator
1264           , _validator_fee
1265           , _deadline
1266           , _nonce
1267         ));
1268 
1269         promisee = askHash
1270             .toEthSignedMessageHash()
1271             .recover(_signature);
1272         return true;
1273     }
1274 
1275     function bid(
1276         bytes   _model,
1277         bytes   _objective,
1278         
1279         ERC20   _token,
1280         uint256 _cost,
1281 
1282         uint256 _lighthouse_fee,
1283 
1284         uint256 _deadline,
1285         bytes32 _nonce,
1286         bytes   _signature
1287     )
1288         external
1289         returns (bool)
1290     {
1291         require(msg.sender == address(factory));
1292         require(block.number < _deadline);
1293         require(keccak256(model) == keccak256(_model));
1294         require(keccak256(objective) == keccak256(_objective));
1295         require(_token == token);
1296         require(_cost == cost);
1297 
1298         lighthouseFee = _lighthouse_fee;
1299 
1300         bidHash = keccak256(abi.encodePacked(
1301             _model
1302           , _objective
1303           , _token
1304           , _cost
1305           , _lighthouse_fee
1306           , _deadline
1307           , _nonce
1308         ));
1309 
1310         promisor = bidHash
1311             .toEthSignedMessageHash()
1312             .recover(_signature);
1313         return true;
1314     }
1315 
1316     /**
1317      * @dev Finalize this liability
1318      * @param _result Result data hash
1319      * @param _agree Validation network confirmation
1320      * @param _signature Result sender signature
1321      */
1322     function finalize(
1323         bytes _result,
1324         bytes _signature,
1325         bool  _agree
1326     )
1327         external
1328         returns (bool)
1329     {
1330         uint256 gasinit = gasleft();
1331         require(!isFinalized);
1332 
1333         address resultSender = keccak256(abi.encodePacked(this, _result))
1334             .toEthSignedMessageHash()
1335             .recover(_signature);
1336         require(resultSender == promisor);
1337 
1338         result = _result;
1339         isFinalized = true;
1340 
1341         if (validator == 0) {
1342             require(factory.isLighthouse(msg.sender));
1343             require(token.transfer(promisor, cost));
1344         } else {
1345             require(msg.sender == validator);
1346 
1347             isConfirmed = _agree;
1348             if (isConfirmed)
1349                 require(token.transfer(promisor, cost));
1350             else
1351                 require(token.transfer(promisee, cost));
1352 
1353             if (validatorFee > 0)
1354                 require(factory.xrt().transfer(validator, validatorFee));
1355         }
1356 
1357         require(factory.liabilityFinalized(gasinit));
1358         return true;
1359     }
1360 }
1361 
1362 // Standard robot liability light contract
1363 contract RobotLiability is RobotLiabilityAPI, LightContract {
1364     constructor(address _lib) public LightContract(_lib)
1365     { factory = LiabilityFactory(msg.sender); }
1366 }
1367 
1368 contract LiabilityFactory {
1369     constructor(
1370         address _robot_liability_lib,
1371         address _lighthouse_lib,
1372         DutchAuction _auction,
1373         XRT _xrt,
1374         ENS _ens
1375     ) public {
1376         robotLiabilityLib = _robot_liability_lib;
1377         lighthouseLib = _lighthouse_lib;
1378         auction = _auction;
1379         xrt = _xrt;
1380         ens = _ens;
1381     }
1382 
1383     /**
1384      * @dev New liability created 
1385      */
1386     event NewLiability(address indexed liability);
1387 
1388     /**
1389      * @dev New lighthouse created
1390      */
1391     event NewLighthouse(address indexed lighthouse, string name);
1392 
1393     /**
1394      * @dev Robonomics dutch auction contract
1395      */
1396     DutchAuction public auction;
1397 
1398     /**
1399      * @dev Robonomics network protocol token
1400      */
1401     XRT public xrt;
1402 
1403     /**
1404      * @dev Ethereum name system
1405      */
1406     ENS public ens;
1407 
1408     /**
1409      * @dev Total GAS utilized by Robonomics network
1410      */
1411     uint256 public totalGasUtilizing = 0;
1412 
1413     /**
1414      * @dev GAS utilized by liability contracts
1415      */
1416     mapping(address => uint256) public gasUtilizing;
1417 
1418     /**
1419      * @dev The count of utilized gas for switch to next epoch 
1420      */
1421     uint256 public constant gasEpoch = 347 * 10**10;
1422 
1423     /**
1424      * @dev Weighted average gasprice
1425      */
1426     uint256 public constant gasPrice = 10 * 10**9;
1427 
1428     /**
1429      * @dev Used market orders accounting
1430      */
1431     mapping(bytes32 => bool) public usedHash;
1432 
1433     /**
1434      * @dev Lighthouse accounting
1435      */
1436     mapping(address => bool) public isLighthouse;
1437 
1438     /**
1439      * @dev Robot liability shared code smart contract
1440      */
1441     address public robotLiabilityLib;
1442 
1443     /**
1444      * @dev Lightouse shared code smart contract
1445      */
1446     address public lighthouseLib;
1447 
1448     /**
1449      * @dev XRT emission value for utilized gas
1450      */
1451     function wnFromGas(uint256 _gas) public view returns (uint256) {
1452         // Just return wn=gas when auction isn't finish
1453         if (auction.finalPrice() == 0)
1454             return _gas;
1455 
1456         // Current gas utilization epoch
1457         uint256 epoch = totalGasUtilizing / gasEpoch;
1458 
1459         // XRT emission with addition coefficient by gas utilzation epoch
1460         uint256 wn = _gas * 10**9 * gasPrice * 2**epoch / 3**epoch / auction.finalPrice();
1461 
1462         // Check to not permit emission decrease below wn=gas
1463         return wn < _gas ? _gas : wn;
1464     }
1465 
1466     /**
1467      * @dev Only lighthouse guard
1468      */
1469     modifier onlyLighthouse {
1470         require(isLighthouse[msg.sender]);
1471         _;
1472     }
1473 
1474     /**
1475      * @dev Parameter can be used only once
1476      * @param _hash Single usage hash
1477      */
1478     function usedHashGuard(bytes32 _hash) internal {
1479         require(!usedHash[_hash]);
1480         usedHash[_hash] = true;
1481     }
1482 
1483     /**
1484      * @dev Create robot liability smart contract
1485      * @param _ask ABI-encoded ASK order message 
1486      * @param _bid ABI-encoded BID order message 
1487      */
1488     function createLiability(
1489         bytes _ask,
1490         bytes _bid
1491     )
1492         external 
1493         onlyLighthouse
1494         returns (RobotLiability liability)
1495     {
1496         // Store in memory available gas
1497         uint256 gasinit = gasleft();
1498 
1499         // Create liability
1500         liability = new RobotLiability(robotLiabilityLib);
1501         emit NewLiability(liability);
1502 
1503         // Parse messages
1504         require(liability.call(abi.encodePacked(bytes4(0x82fbaa25), _ask))); // liability.ask(...)
1505         usedHashGuard(liability.askHash());
1506 
1507         require(liability.call(abi.encodePacked(bytes4(0x66193359), _bid))); // liability.bid(...)
1508         usedHashGuard(liability.bidHash());
1509 
1510         // Transfer lighthouse fee to lighthouse worker directly
1511         require(xrt.transferFrom(liability.promisor(),
1512                                  tx.origin,
1513                                  liability.lighthouseFee()));
1514 
1515         // Transfer liability security and hold on contract
1516         ERC20 token = liability.token();
1517         require(token.transferFrom(liability.promisee(),
1518                                    liability,
1519                                    liability.cost()));
1520 
1521         // Transfer validator fee and hold on contract
1522         if (address(liability.validator()) != 0 && liability.validatorFee() > 0)
1523             require(xrt.transferFrom(liability.promisee(),
1524                                      liability,
1525                                      liability.validatorFee()));
1526 
1527         // Accounting gas usage of transaction
1528         uint256 gas = gasinit - gasleft() + 110525; // Including observation error
1529         totalGasUtilizing       += gas;
1530         gasUtilizing[liability] += gas;
1531      }
1532 
1533     /**
1534      * @dev Create lighthouse smart contract
1535      * @param _minimalFreeze Minimal freeze value of XRT token
1536      * @param _timeoutBlocks Max time of lighthouse silence in blocks
1537      * @param _name Lighthouse subdomain,
1538      *              example: for 'my-name' will created 'my-name.lighthouse.1.robonomics.eth' domain
1539      */
1540     function createLighthouse(
1541         uint256 _minimalFreeze,
1542         uint256 _timeoutBlocks,
1543         string  _name
1544     )
1545         external
1546         returns (address lighthouse)
1547     {
1548         bytes32 lighthouseNode
1549             // lighthouse.1.robonomics.eth
1550             = 0x3662a5d633e9a5ca4b4bd25284e1b343c15a92b5347feb9b965a2b1ef3e1ea1a;
1551 
1552         // Name reservation check
1553         bytes32 subnode = keccak256(abi.encodePacked(lighthouseNode, keccak256(_name)));
1554         require(ens.resolver(subnode) == 0);
1555 
1556         // Create lighthouse
1557         lighthouse = new Lighthouse(lighthouseLib, _minimalFreeze, _timeoutBlocks);
1558         emit NewLighthouse(lighthouse, _name);
1559         isLighthouse[lighthouse] = true;
1560 
1561         // Register subnode
1562         ens.setSubnodeOwner(lighthouseNode, keccak256(_name), this);
1563 
1564         // Register lighthouse address
1565         PublicResolver resolver = PublicResolver(ens.resolver(lighthouseNode));
1566         ens.setResolver(subnode, resolver);
1567         resolver.setAddr(subnode, lighthouse);
1568     }
1569 
1570     /**
1571      * @dev Is called whan after liability finalization
1572      * @param _gas Liability finalization gas expenses
1573      */
1574     function liabilityFinalized(
1575         uint256 _gas
1576     )
1577         external
1578         returns (bool)
1579     {
1580         require(gasUtilizing[msg.sender] > 0);
1581 
1582         uint256 gas = _gas - gasleft();
1583         totalGasUtilizing        += gas;
1584         gasUtilizing[msg.sender] += gas;
1585         require(xrt.mint(tx.origin, wnFromGas(gasUtilizing[msg.sender])));
1586         return true;
1587     }
1588 }