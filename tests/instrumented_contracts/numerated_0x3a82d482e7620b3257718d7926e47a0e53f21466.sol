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
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85   function totalSupply() public view returns (uint256);
86   function balanceOf(address who) public view returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
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
102   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
103     if (a == 0) {
104       return 0;
105     }
106     c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     // uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return a / b;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
133     c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
140 
141 /**
142  * @title Basic token
143  * @dev Basic version of StandardToken, with no allowances.
144  */
145 contract BasicToken is ERC20Basic {
146   using SafeMath for uint256;
147 
148   mapping(address => uint256) balances;
149 
150   uint256 totalSupply_;
151 
152   /**
153   * @dev total number of tokens in existence
154   */
155   function totalSupply() public view returns (uint256) {
156     return totalSupply_;
157   }
158 
159   /**
160   * @dev transfer token for a specified address
161   * @param _to The address to transfer to.
162   * @param _value The amount to be transferred.
163   */
164   function transfer(address _to, uint256 _value) public returns (bool) {
165     require(_to != address(0));
166     require(_value <= balances[msg.sender]);
167 
168     balances[msg.sender] = balances[msg.sender].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     emit Transfer(msg.sender, _to, _value);
171     return true;
172   }
173 
174   /**
175   * @dev Gets the balance of the specified address.
176   * @param _owner The address to query the the balance of.
177   * @return An uint256 representing the amount owned by the passed address.
178   */
179   function balanceOf(address _owner) public view returns (uint256) {
180     return balances[_owner];
181   }
182 
183 }
184 
185 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
186 
187 /**
188  * @title ERC20 interface
189  * @dev see https://github.com/ethereum/EIPs/issues/20
190  */
191 contract ERC20 is ERC20Basic {
192   function allowance(address owner, address spender) public view returns (uint256);
193   function transferFrom(address from, address to, uint256 value) public returns (bool);
194   function approve(address spender, uint256 value) public returns (bool);
195   event Approval(address indexed owner, address indexed spender, uint256 value);
196 }
197 
198 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
199 
200 /**
201  * @title Standard ERC20 token
202  *
203  * @dev Implementation of the basic standard token.
204  * @dev https://github.com/ethereum/EIPs/issues/20
205  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  */
207 contract StandardToken is ERC20, BasicToken {
208 
209   mapping (address => mapping (address => uint256)) internal allowed;
210 
211 
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _value uint256 the amount of tokens to be transferred
217    */
218   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
219     require(_to != address(0));
220     require(_value <= balances[_from]);
221     require(_value <= allowed[_from][msg.sender]);
222 
223     balances[_from] = balances[_from].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
226     emit Transfer(_from, _to, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    *
233    * Beware that changing an allowance with this method brings the risk that someone may use both the old
234    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237    * @param _spender The address which will spend the funds.
238    * @param _value The amount of tokens to be spent.
239    */
240   function approve(address _spender, uint256 _value) public returns (bool) {
241     allowed[msg.sender][_spender] = _value;
242     emit Approval(msg.sender, _spender, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Function to check the amount of tokens that an owner allowed to a spender.
248    * @param _owner address The address which owns the funds.
249    * @param _spender address The address which will spend the funds.
250    * @return A uint256 specifying the amount of tokens still available for the spender.
251    */
252   function allowance(address _owner, address _spender) public view returns (uint256) {
253     return allowed[_owner][_spender];
254   }
255 
256   /**
257    * @dev Increase the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _addedValue The amount of tokens to increase the allowance by.
265    */
266   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
267     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
268     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272   /**
273    * @dev Decrease the amount of tokens that an owner allowed to a spender.
274    *
275    * approve should be called when allowed[_spender] == 0. To decrement
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param _spender The address which will spend the funds.
280    * @param _subtractedValue The amount of tokens to decrease the allowance by.
281    */
282   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
283     uint oldValue = allowed[msg.sender][_spender];
284     if (_subtractedValue > oldValue) {
285       allowed[msg.sender][_spender] = 0;
286     } else {
287       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
288     }
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293 }
294 
295 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
296 
297 /**
298  * @title Ownable
299  * @dev The Ownable contract has an owner address, and provides basic authorization control
300  * functions, this simplifies the implementation of "user permissions".
301  */
302 contract Ownable {
303   address public owner;
304 
305 
306   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
307 
308 
309   /**
310    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
311    * account.
312    */
313   function Ownable() public {
314     owner = msg.sender;
315   }
316 
317   /**
318    * @dev Throws if called by any account other than the owner.
319    */
320   modifier onlyOwner() {
321     require(msg.sender == owner);
322     _;
323   }
324 
325   /**
326    * @dev Allows the current owner to transfer control of the contract to a newOwner.
327    * @param newOwner The address to transfer ownership to.
328    */
329   function transferOwnership(address newOwner) public onlyOwner {
330     require(newOwner != address(0));
331     emit OwnershipTransferred(owner, newOwner);
332     owner = newOwner;
333   }
334 
335 }
336 
337 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
338 
339 /**
340  * @title Mintable token
341  * @dev Simple ERC20 Token example, with mintable token creation
342  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
343  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
344  */
345 contract MintableToken is StandardToken, Ownable {
346   event Mint(address indexed to, uint256 amount);
347   event MintFinished();
348 
349   bool public mintingFinished = false;
350 
351 
352   modifier canMint() {
353     require(!mintingFinished);
354     _;
355   }
356 
357   /**
358    * @dev Function to mint tokens
359    * @param _to The address that will receive the minted tokens.
360    * @param _amount The amount of tokens to mint.
361    * @return A boolean that indicates if the operation was successful.
362    */
363   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
364     totalSupply_ = totalSupply_.add(_amount);
365     balances[_to] = balances[_to].add(_amount);
366     emit Mint(_to, _amount);
367     emit Transfer(address(0), _to, _amount);
368     return true;
369   }
370 
371   /**
372    * @dev Function to stop minting new tokens.
373    * @return True if the operation was successful.
374    */
375   function finishMinting() onlyOwner canMint public returns (bool) {
376     mintingFinished = true;
377     emit MintFinished();
378     return true;
379   }
380 }
381 
382 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
383 
384 /**
385  * @title Burnable Token
386  * @dev Token that can be irreversibly burned (destroyed).
387  */
388 contract BurnableToken is BasicToken {
389 
390   event Burn(address indexed burner, uint256 value);
391 
392   /**
393    * @dev Burns a specific amount of tokens.
394    * @param _value The amount of token to be burned.
395    */
396   function burn(uint256 _value) public {
397     _burn(msg.sender, _value);
398   }
399 
400   function _burn(address _who, uint256 _value) internal {
401     require(_value <= balances[_who]);
402     // no need to require value <= totalSupply, since that would imply the
403     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
404 
405     balances[_who] = balances[_who].sub(_value);
406     totalSupply_ = totalSupply_.sub(_value);
407     emit Burn(_who, _value);
408     emit Transfer(_who, address(0), _value);
409   }
410 }
411 
412 // File: contracts/robonomics/XRT.sol
413 
414 contract XRT is MintableToken, BurnableToken {
415     string public constant name     = "Robonomics Beta";
416     string public constant symbol   = "XRT";
417     uint   public constant decimals = 9;
418 
419     uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));
420 
421     constructor() public {
422         totalSupply_ = INITIAL_SUPPLY;
423         balances[msg.sender] = INITIAL_SUPPLY;
424         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
425     }
426 }
427 
428 // File: contracts/robonomics/DutchAuction.sol
429 
430 /// @title Dutch auction contract - distribution of XRT tokens using an auction.
431 /// @author Stefan George - <stefan.george@consensys.net>
432 /// @author Airalab - <research@aira.life> 
433 contract DutchAuction {
434 
435     /*
436      *  Events
437      */
438     event BidSubmission(address indexed sender, uint256 amount);
439 
440     /*
441      *  Constants
442      */
443     uint constant public MAX_TOKENS_SOLD = 8000 * 10**9; // 8M XRT = 10M - 1M (Foundation) - 1M (Early investors base)
444     uint constant public WAITING_PERIOD = 0; // 1 days;
445 
446     /*
447      *  Storage
448      */
449     XRT     public xrt;
450     address public ambix;
451     address public wallet;
452     address public owner;
453     uint public ceiling;
454     uint public priceFactor;
455     uint public startBlock;
456     uint public endTime;
457     uint public totalReceived;
458     uint public finalPrice;
459     mapping (address => uint) public bids;
460     Stages public stage;
461 
462     /*
463      *  Enums
464      */
465     enum Stages {
466         AuctionDeployed,
467         AuctionSetUp,
468         AuctionStarted,
469         AuctionEnded,
470         TradingStarted
471     }
472 
473     /*
474      *  Modifiers
475      */
476     modifier atStage(Stages _stage) {
477         // Contract on stage
478         require(stage == _stage);
479         _;
480     }
481 
482     modifier isOwner() {
483         // Only owner is allowed to proceed
484         require(msg.sender == owner);
485         _;
486     }
487 
488     modifier isWallet() {
489         // Only wallet is allowed to proceed
490         require(msg.sender == wallet);
491         _;
492     }
493 
494     modifier isValidPayload() {
495         require(msg.data.length == 4 || msg.data.length == 36);
496         _;
497     }
498 
499     modifier timedTransitions() {
500         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
501             finalizeAuction();
502         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
503             stage = Stages.TradingStarted;
504         _;
505     }
506 
507     /*
508      *  Public functions
509      */
510     /// @dev Contract constructor function sets owner.
511     /// @param _wallet Multisig wallet.
512     /// @param _ceiling Auction ceiling.
513     /// @param _priceFactor Auction price factor.
514     constructor(address _wallet, uint _ceiling, uint _priceFactor)
515         public
516     {
517         require(_wallet != 0 && _ceiling != 0 && _priceFactor != 0);
518         owner = msg.sender;
519         wallet = _wallet;
520         ceiling = _ceiling;
521         priceFactor = _priceFactor;
522         stage = Stages.AuctionDeployed;
523     }
524 
525     /// @dev Setup function sets external contracts' addresses.
526     /// @param _xrt Robonomics token address.
527     /// @param _ambix Distillation cube address.
528     function setup(address _xrt, address _ambix)
529         public
530         isOwner
531         atStage(Stages.AuctionDeployed)
532     {
533         // Validate argument
534         require(_xrt != 0 && _ambix != 0);
535         xrt = XRT(_xrt);
536         ambix = _ambix;
537 
538         // Validate token balance
539         require(xrt.balanceOf(this) == MAX_TOKENS_SOLD);
540 
541         stage = Stages.AuctionSetUp;
542     }
543 
544     /// @dev Starts auction and sets startBlock.
545     function startAuction()
546         public
547         isWallet
548         atStage(Stages.AuctionSetUp)
549     {
550         stage = Stages.AuctionStarted;
551         startBlock = block.number;
552     }
553 
554     /// @dev Changes auction ceiling and start price factor before auction is started.
555     /// @param _ceiling Updated auction ceiling.
556     /// @param _priceFactor Updated start price factor.
557     function changeSettings(uint _ceiling, uint _priceFactor)
558         public
559         isWallet
560         atStage(Stages.AuctionSetUp)
561     {
562         ceiling = _ceiling;
563         priceFactor = _priceFactor;
564     }
565 
566     /// @dev Calculates current token price.
567     /// @return Returns token price.
568     function calcCurrentTokenPrice()
569         public
570         timedTransitions
571         returns (uint)
572     {
573         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
574             return finalPrice;
575         return calcTokenPrice();
576     }
577 
578     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
579     /// @return Returns current auction stage.
580     function updateStage()
581         public
582         timedTransitions
583         returns (Stages)
584     {
585         return stage;
586     }
587 
588     /// @dev Allows to send a bid to the auction.
589     /// @param receiver Bid will be assigned to this address if set.
590     function bid(address receiver)
591         public
592         payable
593         isValidPayload
594         timedTransitions
595         atStage(Stages.AuctionStarted)
596         returns (uint amount)
597     {
598         require(msg.value > 0);
599         amount = msg.value;
600 
601         // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
602         if (receiver == 0)
603             receiver = msg.sender;
604 
605         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
606         uint maxWei = MAX_TOKENS_SOLD * calcTokenPrice() / 10**9 - totalReceived;
607         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
608         if (maxWeiBasedOnTotalReceived < maxWei)
609             maxWei = maxWeiBasedOnTotalReceived;
610 
611         // Only invest maximum possible amount.
612         if (amount > maxWei) {
613             amount = maxWei;
614             // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
615             receiver.transfer(msg.value - amount);
616         }
617 
618         // Forward funding to ether wallet
619         wallet.transfer(amount);
620 
621         bids[receiver] += amount;
622         totalReceived += amount;
623         BidSubmission(receiver, amount);
624 
625         // Finalize auction when maxWei reached
626         if (amount == maxWei)
627             finalizeAuction();
628     }
629 
630     /// @dev Claims tokens for bidder after auction.
631     /// @param receiver Tokens will be assigned to this address if set.
632     function claimTokens(address receiver)
633         public
634         isValidPayload
635         timedTransitions
636         atStage(Stages.TradingStarted)
637     {
638         if (receiver == 0)
639             receiver = msg.sender;
640         uint tokenCount = bids[receiver] * 10**9 / finalPrice;
641         bids[receiver] = 0;
642         require(xrt.transfer(receiver, tokenCount));
643     }
644 
645     /// @dev Calculates stop price.
646     /// @return Returns stop price.
647     function calcStopPrice()
648         view
649         public
650         returns (uint)
651     {
652         return totalReceived * 10**9 / MAX_TOKENS_SOLD + 1;
653     }
654 
655     /// @dev Calculates token price.
656     /// @return Returns token price.
657     function calcTokenPrice()
658         view
659         public
660         returns (uint)
661     {
662         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
663     }
664 
665     /*
666      *  Private functions
667      */
668     function finalizeAuction()
669         private
670     {
671         stage = Stages.AuctionEnded;
672         finalPrice = totalReceived == ceiling ? calcTokenPrice() : calcStopPrice();
673         uint soldTokens = totalReceived * 10**9 / finalPrice;
674 
675         if (totalReceived == ceiling) {
676             // Auction contract transfers all unsold tokens to Ambix contract
677             require(xrt.transfer(ambix, MAX_TOKENS_SOLD - soldTokens));
678         } else {
679             // Auction contract burn all unsold tokens
680             xrt.burn(MAX_TOKENS_SOLD - soldTokens);
681         }
682 
683         endTime = now;
684     }
685 }
686 
687 // File: ens/contracts/ENS.sol
688 
689 interface ENS {
690 
691     // Logged when the owner of a node assigns a new owner to a subnode.
692     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
693 
694     // Logged when the owner of a node transfers ownership to a new account.
695     event Transfer(bytes32 indexed node, address owner);
696 
697     // Logged when the resolver for a node changes.
698     event NewResolver(bytes32 indexed node, address resolver);
699 
700     // Logged when the TTL of a node changes
701     event NewTTL(bytes32 indexed node, uint64 ttl);
702 
703 
704     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
705     function setResolver(bytes32 node, address resolver) public;
706     function setOwner(bytes32 node, address owner) public;
707     function setTTL(bytes32 node, uint64 ttl) public;
708     function owner(bytes32 node) public view returns (address);
709     function resolver(bytes32 node) public view returns (address);
710     function ttl(bytes32 node) public view returns (uint64);
711 
712 }
713 
714 // File: ens/contracts/PublicResolver.sol
715 
716 /**
717  * A simple resolver anyone can use; only allows the owner of a node to set its
718  * address.
719  */
720 contract PublicResolver {
721 
722     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
723     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
724     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
725     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
726     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
727     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
728     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
729     bytes4 constant MULTIHASH_INTERFACE_ID = 0xe89401a1;
730 
731     event AddrChanged(bytes32 indexed node, address a);
732     event ContentChanged(bytes32 indexed node, bytes32 hash);
733     event NameChanged(bytes32 indexed node, string name);
734     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
735     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
736     event TextChanged(bytes32 indexed node, string indexedKey, string key);
737     event MultihashChanged(bytes32 indexed node, bytes hash);
738 
739     struct PublicKey {
740         bytes32 x;
741         bytes32 y;
742     }
743 
744     struct Record {
745         address addr;
746         bytes32 content;
747         string name;
748         PublicKey pubkey;
749         mapping(string=>string) text;
750         mapping(uint256=>bytes) abis;
751         bytes multihash;
752     }
753 
754     ENS ens;
755 
756     mapping (bytes32 => Record) records;
757 
758     modifier only_owner(bytes32 node) {
759         require(ens.owner(node) == msg.sender);
760         _;
761     }
762 
763     /**
764      * Constructor.
765      * @param ensAddr The ENS registrar contract.
766      */
767     function PublicResolver(ENS ensAddr) public {
768         ens = ensAddr;
769     }
770 
771     /**
772      * Sets the address associated with an ENS node.
773      * May only be called by the owner of that node in the ENS registry.
774      * @param node The node to update.
775      * @param addr The address to set.
776      */
777     function setAddr(bytes32 node, address addr) public only_owner(node) {
778         records[node].addr = addr;
779         AddrChanged(node, addr);
780     }
781 
782     /**
783      * Sets the content hash associated with an ENS node.
784      * May only be called by the owner of that node in the ENS registry.
785      * Note that this resource type is not standardized, and will likely change
786      * in future to a resource type based on multihash.
787      * @param node The node to update.
788      * @param hash The content hash to set
789      */
790     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
791         records[node].content = hash;
792         ContentChanged(node, hash);
793     }
794 
795     /**
796      * Sets the multihash associated with an ENS node.
797      * May only be called by the owner of that node in the ENS registry.
798      * @param node The node to update.
799      * @param hash The multihash to set
800      */
801     function setMultihash(bytes32 node, bytes hash) public only_owner(node) {
802         records[node].multihash = hash;
803         MultihashChanged(node, hash);
804     }
805     
806     /**
807      * Sets the name associated with an ENS node, for reverse records.
808      * May only be called by the owner of that node in the ENS registry.
809      * @param node The node to update.
810      * @param name The name to set.
811      */
812     function setName(bytes32 node, string name) public only_owner(node) {
813         records[node].name = name;
814         NameChanged(node, name);
815     }
816 
817     /**
818      * Sets the ABI associated with an ENS node.
819      * Nodes may have one ABI of each content type. To remove an ABI, set it to
820      * the empty string.
821      * @param node The node to update.
822      * @param contentType The content type of the ABI
823      * @param data The ABI data.
824      */
825     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
826         // Content types must be powers of 2
827         require(((contentType - 1) & contentType) == 0);
828         
829         records[node].abis[contentType] = data;
830         ABIChanged(node, contentType);
831     }
832     
833     /**
834      * Sets the SECP256k1 public key associated with an ENS node.
835      * @param node The ENS node to query
836      * @param x the X coordinate of the curve point for the public key.
837      * @param y the Y coordinate of the curve point for the public key.
838      */
839     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
840         records[node].pubkey = PublicKey(x, y);
841         PubkeyChanged(node, x, y);
842     }
843 
844     /**
845      * Sets the text data associated with an ENS node and key.
846      * May only be called by the owner of that node in the ENS registry.
847      * @param node The node to update.
848      * @param key The key to set.
849      * @param value The text data value to set.
850      */
851     function setText(bytes32 node, string key, string value) public only_owner(node) {
852         records[node].text[key] = value;
853         TextChanged(node, key, key);
854     }
855 
856     /**
857      * Returns the text data associated with an ENS node and key.
858      * @param node The ENS node to query.
859      * @param key The text data key to query.
860      * @return The associated text data.
861      */
862     function text(bytes32 node, string key) public view returns (string) {
863         return records[node].text[key];
864     }
865 
866     /**
867      * Returns the SECP256k1 public key associated with an ENS node.
868      * Defined in EIP 619.
869      * @param node The ENS node to query
870      * @return x, y the X and Y coordinates of the curve point for the public key.
871      */
872     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
873         return (records[node].pubkey.x, records[node].pubkey.y);
874     }
875 
876     /**
877      * Returns the ABI associated with an ENS node.
878      * Defined in EIP205.
879      * @param node The ENS node to query
880      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
881      * @return contentType The content type of the return value
882      * @return data The ABI data
883      */
884     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
885         Record storage record = records[node];
886         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
887             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
888                 data = record.abis[contentType];
889                 return;
890             }
891         }
892         contentType = 0;
893     }
894 
895     /**
896      * Returns the name associated with an ENS node, for reverse records.
897      * Defined in EIP181.
898      * @param node The ENS node to query.
899      * @return The associated name.
900      */
901     function name(bytes32 node) public view returns (string) {
902         return records[node].name;
903     }
904 
905     /**
906      * Returns the content hash associated with an ENS node.
907      * Note that this resource type is not standardized, and will likely change
908      * in future to a resource type based on multihash.
909      * @param node The ENS node to query.
910      * @return The associated content hash.
911      */
912     function content(bytes32 node) public view returns (bytes32) {
913         return records[node].content;
914     }
915 
916     /**
917      * Returns the multihash associated with an ENS node.
918      * @param node The ENS node to query.
919      * @return The associated multihash.
920      */
921     function multihash(bytes32 node) public view returns (bytes) {
922         return records[node].multihash;
923     }
924 
925     /**
926      * Returns the address associated with an ENS node.
927      * @param node The ENS node to query.
928      * @return The associated address.
929      */
930     function addr(bytes32 node) public view returns (address) {
931         return records[node].addr;
932     }
933 
934     /**
935      * Returns true if the resolver implements the interface specified by the provided hash.
936      * @param interfaceID The ID of the interface to check for.
937      * @return True if the contract implements the requested interface.
938      */
939     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
940         return interfaceID == ADDR_INTERFACE_ID ||
941         interfaceID == CONTENT_INTERFACE_ID ||
942         interfaceID == NAME_INTERFACE_ID ||
943         interfaceID == ABI_INTERFACE_ID ||
944         interfaceID == PUBKEY_INTERFACE_ID ||
945         interfaceID == TEXT_INTERFACE_ID ||
946         interfaceID == MULTIHASH_INTERFACE_ID ||
947         interfaceID == INTERFACE_META_ID;
948     }
949 }
950 
951 contract LightContract {
952     /**
953      * @dev Shared code smart contract 
954      */
955     address lib;
956 
957     constructor(address _library) public {
958         lib = _library;
959     }
960 
961     function() public {
962         require(lib.delegatecall(msg.data));
963     }
964 }
965 
966 contract LighthouseABI {
967     function refill(uint256 _value) external;
968     function withdraw(uint256 _value) external;
969     function to(address _to, bytes _data) external;
970     function () external;
971 }
972 
973 contract LighthouseAPI {
974     address[] public members;
975     mapping(address => uint256) indexOf;
976 
977     mapping(address => uint256) public balances;
978 
979     uint256 public minimalFreeze;
980     uint256 public timeoutBlocks;
981 
982     LiabilityFactory public factory;
983     XRT              public xrt;
984 
985     uint256 public keepaliveBlock = 0;
986     uint256 public marker = 0;
987     uint256 public quota = 0;
988 
989     function quotaOf(address _member) public view returns (uint256)
990     { return balances[_member] / minimalFreeze; }
991 }
992 
993 contract LighthouseLib is LighthouseAPI, LighthouseABI {
994 
995     function refill(uint256 _value) external {
996         require(xrt.transferFrom(msg.sender, this, _value));
997         require(_value >= minimalFreeze);
998 
999         if (balances[msg.sender] == 0) {
1000             indexOf[msg.sender] = members.length;
1001             members.push(msg.sender);
1002         }
1003         balances[msg.sender] += _value;
1004     }
1005 
1006     function withdraw(uint256 _value) external {
1007         require(balances[msg.sender] >= _value);
1008 
1009         balances[msg.sender] -= _value;
1010         require(xrt.transfer(msg.sender, _value));
1011 
1012         // Drop member if quota go to zero
1013         if (quotaOf(msg.sender) == 0) {
1014             uint256 balance = balances[msg.sender];
1015             balances[msg.sender] = 0;
1016             require(xrt.transfer(msg.sender, balance)); 
1017             
1018             uint256 senderIndex = indexOf[msg.sender];
1019             uint256 lastIndex = members.length - 1;
1020             if (senderIndex < lastIndex)
1021                 members[senderIndex] = members[lastIndex];
1022             members.length -= 1;
1023         }
1024     }
1025 
1026     function nextMember() internal
1027     { marker = (marker + 1) % members.length; }
1028 
1029     modifier quoted {
1030         if (quota == 0) {
1031             // Step over marker
1032             nextMember();
1033 
1034             // Allocate new quota
1035             quota = quotaOf(members[marker]);
1036         }
1037 
1038         // Consume one quota for transaction sending
1039         assert(quota > 0);
1040         quota -= 1;
1041 
1042         _;
1043     }
1044 
1045     modifier keepalive {
1046         if (timeoutBlocks < block.number - keepaliveBlock) {
1047             // Search keepalive sender
1048             while (msg.sender != members[marker])
1049                 nextMember();
1050 
1051             // Allocate new quota
1052             quota = quotaOf(members[marker]);
1053         }
1054 
1055         _;
1056     }
1057 
1058     modifier member {
1059         // Zero members guard
1060         require(members.length > 0);
1061 
1062         // Only member with marker can to send transaction
1063         require(msg.sender == members[marker]);
1064 
1065         // Store transaction sending block
1066         keepaliveBlock = block.number;
1067 
1068         _;
1069     }
1070 
1071     function to(address _to, bytes _data) external keepalive quoted member {
1072         require(factory.gasUtilizing(_to) > 0);
1073         require(_to.call(_data));
1074     }
1075 
1076     function () external keepalive quoted member
1077     { require(factory.call(msg.data)); }
1078 }
1079 
1080 contract Lighthouse is LighthouseAPI, LightContract {
1081     constructor(
1082         address _lib,
1083         uint256 _minimalFreeze,
1084         uint256 _timeoutBlocks
1085     ) 
1086         public
1087         LightContract(_lib)
1088     {
1089         minimalFreeze = _minimalFreeze;
1090         timeoutBlocks = _timeoutBlocks;
1091         factory = LiabilityFactory(msg.sender);
1092         xrt = factory.xrt();
1093     }
1094 }
1095 
1096 contract RobotLiabilityABI {
1097     function ask(
1098         bytes   _model,
1099         bytes   _objective,
1100 
1101         ERC20   _token,
1102         uint256 _cost,
1103 
1104         address _validator,
1105         uint256 _validator_fee,
1106 
1107         uint256 _deadline,
1108         bytes32 _nonce,
1109         bytes   _signature
1110     ) external returns (bool);
1111 
1112     function bid(
1113         bytes   _model,
1114         bytes   _objective,
1115         
1116         ERC20   _token,
1117         uint256 _cost,
1118 
1119         uint256 _lighthouse_fee,
1120 
1121         uint256 _deadline,
1122         bytes32 _nonce,
1123         bytes   _signature
1124     ) external returns (bool);
1125 
1126     function finalize(
1127         bytes _result,
1128         bytes _signature,
1129         bool  _agree
1130     ) external returns (bool);
1131 }
1132 
1133 contract RobotLiabilityAPI {
1134     bytes   public model;
1135     bytes   public objective;
1136     bytes   public result;
1137 
1138     ERC20   public token;
1139     uint256 public cost;
1140     uint256 public lighthouseFee;
1141     uint256 public validatorFee;
1142 
1143     bytes32 public askHash;
1144     bytes32 public bidHash;
1145 
1146     address public promisor;
1147     address public promisee;
1148     address public validator;
1149 
1150     bool    public isConfirmed;
1151     bool    public isFinalized;
1152 
1153     LiabilityFactory public factory;
1154 }
1155 
1156 contract RobotLiabilityLib is RobotLiabilityABI
1157                             , RobotLiabilityAPI {
1158     using ECRecovery for bytes32;
1159 
1160     function ask(
1161         bytes   _model,
1162         bytes   _objective,
1163 
1164         ERC20   _token,
1165         uint256 _cost,
1166 
1167         address _validator,
1168         uint256 _validator_fee,
1169 
1170         uint256 _deadline,
1171         bytes32 _nonce,
1172         bytes   _signature
1173     )
1174         external
1175         returns (bool)
1176     {
1177         require(msg.sender == address(factory));
1178         require(block.number < _deadline);
1179 
1180         model        = _model;
1181         objective    = _objective;
1182         token        = _token;
1183         cost         = _cost;
1184         validator    = _validator;
1185         validatorFee = _validator_fee;
1186 
1187         askHash = keccak256(abi.encodePacked(
1188             _model
1189           , _objective
1190           , _token
1191           , _cost
1192           , _validator
1193           , _validator_fee
1194           , _deadline
1195           , _nonce
1196         ));
1197 
1198         promisee = askHash
1199             .toEthSignedMessageHash()
1200             .recover(_signature);
1201         return true;
1202     }
1203 
1204     function bid(
1205         bytes   _model,
1206         bytes   _objective,
1207         
1208         ERC20   _token,
1209         uint256 _cost,
1210 
1211         uint256 _lighthouse_fee,
1212 
1213         uint256 _deadline,
1214         bytes32 _nonce,
1215         bytes   _signature
1216     )
1217         external
1218         returns (bool)
1219     {
1220         require(msg.sender == address(factory));
1221         require(block.number < _deadline);
1222         require(keccak256(model) == keccak256(_model));
1223         require(keccak256(objective) == keccak256(_objective));
1224         require(_token == token);
1225         require(_cost == cost);
1226 
1227         lighthouseFee = _lighthouse_fee;
1228 
1229         bidHash = keccak256(abi.encodePacked(
1230             _model
1231           , _objective
1232           , _token
1233           , _cost
1234           , _lighthouse_fee
1235           , _deadline
1236           , _nonce
1237         ));
1238 
1239         promisor = bidHash
1240             .toEthSignedMessageHash()
1241             .recover(_signature);
1242         return true;
1243     }
1244 
1245     /**
1246      * @dev Finalize this liability
1247      * @param _result Result data hash
1248      * @param _agree Validation network confirmation
1249      * @param _signature Result sender signature
1250      */
1251     function finalize(
1252         bytes _result,
1253         bytes _signature,
1254         bool  _agree
1255     )
1256         external
1257         returns (bool)
1258     {
1259         uint256 gasinit = gasleft();
1260         require(!isFinalized);
1261 
1262         address resultSender = keccak256(abi.encodePacked(this, _result))
1263             .toEthSignedMessageHash()
1264             .recover(_signature);
1265         require(resultSender == promisor);
1266 
1267         result = _result;
1268         isFinalized = true;
1269 
1270         if (validator == 0) {
1271             require(factory.isLighthouse(msg.sender));
1272             require(token.transfer(promisor, cost));
1273         } else {
1274             require(msg.sender == validator);
1275 
1276             isConfirmed = _agree;
1277             if (isConfirmed)
1278                 require(token.transfer(promisor, cost));
1279             else
1280                 require(token.transfer(promisee, cost));
1281 
1282             if (validatorFee > 0)
1283                 require(factory.xrt().transfer(validator, validatorFee));
1284         }
1285 
1286         require(factory.liabilityFinalized(gasinit));
1287         return true;
1288     }
1289 }
1290 
1291 // Standard robot liability light contract
1292 contract RobotLiability is RobotLiabilityAPI, LightContract {
1293     constructor(address _lib) public LightContract(_lib)
1294     { factory = LiabilityFactory(msg.sender); }
1295 }
1296 
1297 contract LiabilityFactory {
1298     constructor(
1299         address _robot_liability_lib,
1300         address _lighthouse_lib,
1301         DutchAuction _auction,
1302         XRT _xrt,
1303         ENS _ens
1304     ) public {
1305         robotLiabilityLib = _robot_liability_lib;
1306         lighthouseLib = _lighthouse_lib;
1307         auction = _auction;
1308         xrt = _xrt;
1309         ens = _ens;
1310     }
1311 
1312     /**
1313      * @dev New liability created 
1314      */
1315     event NewLiability(address indexed liability);
1316 
1317     /**
1318      * @dev New lighthouse created
1319      */
1320     event NewLighthouse(address indexed lighthouse, string name);
1321 
1322     /**
1323      * @dev Robonomics dutch auction contract
1324      */
1325     DutchAuction public auction;
1326 
1327     /**
1328      * @dev Robonomics network protocol token
1329      */
1330     XRT public xrt;
1331 
1332     /**
1333      * @dev Ethereum name system
1334      */
1335     ENS public ens;
1336 
1337     /**
1338      * @dev Total GAS utilized by Robonomics network
1339      */
1340     uint256 public totalGasUtilizing = 0;
1341 
1342     /**
1343      * @dev GAS utilized by liability contracts
1344      */
1345     mapping(address => uint256) public gasUtilizing;
1346 
1347     /**
1348      * @dev The count of utilized gas for switch to next epoch 
1349      */
1350     uint256 public constant gasEpoch = 347 * 10**10;
1351 
1352     /**
1353      * @dev Weighted average gasprice
1354      */
1355     uint256 public constant gasPrice = 10 * 10**9;
1356 
1357     /**
1358      * @dev Used market orders accounting
1359      */
1360     mapping(bytes32 => bool) public usedHash;
1361 
1362     /**
1363      * @dev Lighthouse accounting
1364      */
1365     mapping(address => bool) public isLighthouse;
1366 
1367     /**
1368      * @dev Robot liability shared code smart contract
1369      */
1370     address public robotLiabilityLib;
1371 
1372     /**
1373      * @dev Lightouse shared code smart contract
1374      */
1375     address public lighthouseLib;
1376 
1377     /**
1378      * @dev XRT emission value for utilized gas
1379      */
1380     function wnFromGas(uint256 _gas) public view returns (uint256) {
1381         // Just return wn=gas when auction isn't finish
1382         if (auction.finalPrice() == 0)
1383             return _gas;
1384 
1385         // Current gas utilization epoch
1386         uint256 epoch = totalGasUtilizing / gasEpoch;
1387 
1388         // XRT emission with addition coefficient by gas utilzation epoch
1389         uint256 wn = _gas * gasPrice * 2**epoch / 3**epoch / auction.finalPrice();
1390 
1391         // Check to not permit emission decrease below wn=gas
1392         return wn < _gas ? _gas : wn;
1393     }
1394 
1395     /**
1396      * @dev Only lighthouse guard
1397      */
1398     modifier onlyLighthouse {
1399         require(isLighthouse[msg.sender]);
1400         _;
1401     }
1402 
1403     /**
1404      * @dev Parameter can be used only once
1405      * @param _hash Single usage hash
1406      */
1407     function usedHashGuard(bytes32 _hash) internal {
1408         require(!usedHash[_hash]);
1409         usedHash[_hash] = true;
1410     }
1411 
1412     /**
1413      * @dev Create robot liability smart contract
1414      * @param _ask ABI-encoded ASK order message 
1415      * @param _bid ABI-encoded BID order message 
1416      */
1417     function createLiability(
1418         bytes _ask,
1419         bytes _bid
1420     )
1421         external 
1422         onlyLighthouse
1423         returns (RobotLiability liability)
1424     {
1425         // Store in memory available gas
1426         uint256 gasinit = gasleft();
1427 
1428         // Create liability
1429         liability = new RobotLiability(robotLiabilityLib);
1430         emit NewLiability(liability);
1431 
1432         // Parse messages
1433         require(liability.call(abi.encodePacked(bytes4(0x82fbaa25), _ask))); // liability.ask(...)
1434         usedHashGuard(liability.askHash());
1435 
1436         require(liability.call(abi.encodePacked(bytes4(0x66193359), _bid))); // liability.bid(...)
1437         usedHashGuard(liability.bidHash());
1438 
1439         // Transfer lighthouse fee to lighthouse worker directly
1440         require(xrt.transferFrom(liability.promisor(),
1441                                  tx.origin,
1442                                  liability.lighthouseFee()));
1443 
1444         // Transfer liability security and hold on contract
1445         ERC20 token = liability.token();
1446         require(token.transferFrom(liability.promisee(),
1447                                    liability,
1448                                    liability.cost()));
1449 
1450         // Transfer validator fee and hold on contract
1451         if (address(liability.validator()) != 0 && liability.validatorFee() > 0)
1452             require(xrt.transferFrom(liability.promisee(),
1453                                      liability,
1454                                      liability.validatorFee()));
1455 
1456         // Accounting gas usage of transaction
1457         uint256 gas = gasinit - gasleft() + 110525; // Including observation error
1458         totalGasUtilizing       += gas;
1459         gasUtilizing[liability] += gas;
1460      }
1461 
1462     /**
1463      * @dev Create lighthouse smart contract
1464      * @param _minimalFreeze Minimal freeze value of XRT token
1465      * @param _timeoutBlocks Max time of lighthouse silence in blocks
1466      * @param _name Lighthouse subdomain,
1467      *              example: for 'my-name' will created 'my-name.lighthouse.1.robonomics.eth' domain
1468      */
1469     function createLighthouse(
1470         uint256 _minimalFreeze,
1471         uint256 _timeoutBlocks,
1472         string  _name
1473     )
1474         external
1475         returns (address lighthouse)
1476     {
1477         bytes32 lighthouseNode
1478             // lighthouse.1.robonomics.eth
1479             = 0x3662a5d633e9a5ca4b4bd25284e1b343c15a92b5347feb9b965a2b1ef3e1ea1a;
1480 
1481         // Name reservation check
1482         bytes32 subnode = keccak256(abi.encodePacked(lighthouseNode, keccak256(_name)));
1483         require(ens.resolver(subnode) == 0);
1484 
1485         // Create lighthouse
1486         lighthouse = new Lighthouse(lighthouseLib, _minimalFreeze, _timeoutBlocks);
1487         emit NewLighthouse(lighthouse, _name);
1488         isLighthouse[lighthouse] = true;
1489 
1490         // Register subnode
1491         ens.setSubnodeOwner(lighthouseNode, keccak256(_name), this);
1492 
1493         // Register lighthouse address
1494         PublicResolver resolver = PublicResolver(ens.resolver(lighthouseNode));
1495         ens.setResolver(subnode, resolver);
1496         resolver.setAddr(subnode, lighthouse);
1497     }
1498 
1499     /**
1500      * @dev Is called whan after liability finalization
1501      * @param _gas Liability finalization gas expenses
1502      */
1503     function liabilityFinalized(
1504         uint256 _gas
1505     )
1506         external
1507         returns (bool)
1508     {
1509         require(gasUtilizing[msg.sender] > 0);
1510 
1511         uint256 gas = _gas - gasleft();
1512         totalGasUtilizing        += gas;
1513         gasUtilizing[msg.sender] += gas;
1514         require(xrt.mint(tx.origin, wnFromGas(gasUtilizing[msg.sender])));
1515         return true;
1516     }
1517 }