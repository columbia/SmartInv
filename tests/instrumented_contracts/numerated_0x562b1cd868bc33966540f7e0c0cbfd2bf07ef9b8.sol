1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     public
356     hasMintPermission
357     canMint
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() public onlyOwner canMint returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
379 
380 /**
381  * @title Burnable Token
382  * @dev Token that can be irreversibly burned (destroyed).
383  */
384 contract BurnableToken is BasicToken {
385 
386   event Burn(address indexed burner, uint256 value);
387 
388   /**
389    * @dev Burns a specific amount of tokens.
390    * @param _value The amount of token to be burned.
391    */
392   function burn(uint256 _value) public {
393     _burn(msg.sender, _value);
394   }
395 
396   function _burn(address _who, uint256 _value) internal {
397     require(_value <= balances[_who]);
398     // no need to require value <= totalSupply, since that would imply the
399     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
400 
401     balances[_who] = balances[_who].sub(_value);
402     totalSupply_ = totalSupply_.sub(_value);
403     emit Burn(_who, _value);
404     emit Transfer(_who, address(0), _value);
405   }
406 }
407 
408 // File: contracts/robonomics/XRT.sol
409 
410 contract XRT is MintableToken, BurnableToken {
411     string public constant name     = "Robonomics Beta";
412     string public constant symbol   = "XRT";
413     uint   public constant decimals = 9;
414 
415     uint256 public constant INITIAL_SUPPLY = 1000 * (10 ** uint256(decimals));
416 
417     constructor() public {
418         totalSupply_ = INITIAL_SUPPLY;
419         balances[msg.sender] = INITIAL_SUPPLY;
420         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
421     }
422 }
423 
424 // File: contracts/robonomics/DutchAuction.sol
425 
426 /// @title Dutch auction contract - distribution of XRT tokens using an auction.
427 /// @author Stefan George - <stefan.george@consensys.net>
428 /// @author Airalab - <research@aira.life> 
429 contract DutchAuction {
430 
431     /*
432      *  Events
433      */
434     event BidSubmission(address indexed sender, uint256 amount);
435 
436     /*
437      *  Constants
438      */
439     uint constant public MAX_TOKENS_SOLD = 800 * 10**9; // 8M XRT = 10M - 1M (Foundation) - 1M (Early investors base)
440     uint constant public WAITING_PERIOD = 30 minutes;
441 
442     /*
443      *  Storage
444      */
445     XRT     public xrt;
446     address public ambix;
447     address public wallet;
448     address public owner;
449     uint public ceiling;
450     uint public priceFactor;
451     uint public startBlock;
452     uint public endTime;
453     uint public totalReceived;
454     uint public finalPrice;
455     mapping (address => uint) public bids;
456     Stages public stage;
457 
458     /*
459      *  Enums
460      */
461     enum Stages {
462         AuctionDeployed,
463         AuctionSetUp,
464         AuctionStarted,
465         AuctionEnded,
466         TradingStarted
467     }
468 
469     /*
470      *  Modifiers
471      */
472     modifier atStage(Stages _stage) {
473         // Contract on stage
474         require(stage == _stage);
475         _;
476     }
477 
478     modifier isOwner() {
479         // Only owner is allowed to proceed
480         require(msg.sender == owner);
481         _;
482     }
483 
484     modifier isWallet() {
485         // Only wallet is allowed to proceed
486         require(msg.sender == wallet);
487         _;
488     }
489 
490     modifier isValidPayload() {
491         require(msg.data.length == 4 || msg.data.length == 36);
492         _;
493     }
494 
495     modifier timedTransitions() {
496         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
497             finalizeAuction();
498         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
499             stage = Stages.TradingStarted;
500         _;
501     }
502 
503     /*
504      *  Public functions
505      */
506     /// @dev Contract constructor function sets owner.
507     /// @param _wallet Multisig wallet.
508     /// @param _ceiling Auction ceiling.
509     /// @param _priceFactor Auction price factor.
510     constructor(address _wallet, uint _ceiling, uint _priceFactor)
511         public
512     {
513         require(_wallet != 0 && _ceiling != 0 && _priceFactor != 0);
514         owner = msg.sender;
515         wallet = _wallet;
516         ceiling = _ceiling;
517         priceFactor = _priceFactor;
518         stage = Stages.AuctionDeployed;
519     }
520 
521     /// @dev Setup function sets external contracts' addresses.
522     /// @param _xrt Robonomics token address.
523     /// @param _ambix Distillation cube address.
524     function setup(address _xrt, address _ambix)
525         public
526         isOwner
527         atStage(Stages.AuctionDeployed)
528     {
529         // Validate argument
530         require(_xrt != 0 && _ambix != 0);
531         xrt = XRT(_xrt);
532         ambix = _ambix;
533 
534         // Validate token balance
535         require(xrt.balanceOf(this) == MAX_TOKENS_SOLD);
536 
537         stage = Stages.AuctionSetUp;
538     }
539 
540     /// @dev Starts auction and sets startBlock.
541     function startAuction()
542         public
543         isWallet
544         atStage(Stages.AuctionSetUp)
545     {
546         stage = Stages.AuctionStarted;
547         startBlock = block.number;
548     }
549 
550     /// @dev Changes auction ceiling and start price factor before auction is started.
551     /// @param _ceiling Updated auction ceiling.
552     /// @param _priceFactor Updated start price factor.
553     function changeSettings(uint _ceiling, uint _priceFactor)
554         public
555         isWallet
556         atStage(Stages.AuctionSetUp)
557     {
558         ceiling = _ceiling;
559         priceFactor = _priceFactor;
560     }
561 
562     /// @dev Calculates current token price.
563     /// @return Returns token price.
564     function calcCurrentTokenPrice()
565         public
566         timedTransitions
567         returns (uint)
568     {
569         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
570             return finalPrice;
571         return calcTokenPrice();
572     }
573 
574     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
575     /// @return Returns current auction stage.
576     function updateStage()
577         public
578         timedTransitions
579         returns (Stages)
580     {
581         return stage;
582     }
583 
584     /// @dev Allows to send a bid to the auction.
585     /// @param receiver Bid will be assigned to this address if set.
586     function bid(address receiver)
587         public
588         payable
589         isValidPayload
590         timedTransitions
591         atStage(Stages.AuctionStarted)
592         returns (uint amount)
593     {
594         require(msg.value > 0);
595         amount = msg.value;
596 
597         // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
598         if (receiver == 0)
599             receiver = msg.sender;
600 
601         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
602         uint maxWei = MAX_TOKENS_SOLD * calcTokenPrice() / 10**9 - totalReceived;
603         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
604         if (maxWeiBasedOnTotalReceived < maxWei)
605             maxWei = maxWeiBasedOnTotalReceived;
606 
607         // Only invest maximum possible amount.
608         if (amount > maxWei) {
609             amount = maxWei;
610             // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
611             receiver.transfer(msg.value - amount);
612         }
613 
614         // Forward funding to ether wallet
615         wallet.transfer(amount);
616 
617         bids[receiver] += amount;
618         totalReceived += amount;
619         BidSubmission(receiver, amount);
620 
621         // Finalize auction when maxWei reached
622         if (amount == maxWei)
623             finalizeAuction();
624     }
625 
626     /// @dev Claims tokens for bidder after auction.
627     /// @param receiver Tokens will be assigned to this address if set.
628     function claimTokens(address receiver)
629         public
630         isValidPayload
631         timedTransitions
632         atStage(Stages.TradingStarted)
633     {
634         if (receiver == 0)
635             receiver = msg.sender;
636         uint tokenCount = bids[receiver] * 10**9 / finalPrice;
637         bids[receiver] = 0;
638         require(xrt.transfer(receiver, tokenCount));
639     }
640 
641     /// @dev Calculates stop price.
642     /// @return Returns stop price.
643     function calcStopPrice()
644         view
645         public
646         returns (uint)
647     {
648         return totalReceived * 10**9 / MAX_TOKENS_SOLD + 1;
649     }
650 
651     /// @dev Calculates token price.
652     /// @return Returns token price.
653     function calcTokenPrice()
654         view
655         public
656         returns (uint)
657     {
658         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
659     }
660 
661     /*
662      *  Private functions
663      */
664     function finalizeAuction()
665         private
666     {
667         stage = Stages.AuctionEnded;
668         finalPrice = totalReceived == ceiling ? calcTokenPrice() : calcStopPrice();
669         uint soldTokens = totalReceived * 10**9 / finalPrice;
670 
671         if (totalReceived == ceiling) {
672             // Auction contract transfers all unsold tokens to Ambix contract
673             require(xrt.transfer(ambix, MAX_TOKENS_SOLD - soldTokens));
674         } else {
675             // Auction contract burn all unsold tokens
676             xrt.burn(MAX_TOKENS_SOLD - soldTokens);
677         }
678 
679         endTime = now;
680     }
681 }