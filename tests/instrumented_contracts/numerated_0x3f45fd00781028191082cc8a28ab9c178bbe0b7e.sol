1 pragma solidity 0.4.23;
2 
3 // File: eidoo-icoengine/contracts/ICOEngineInterface.sol
4 
5 contract ICOEngineInterface {
6 
7     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
8     function started() public view returns(bool);
9 
10     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
11     function ended() public view returns(bool);
12 
13     // time stamp of the starting time of the ico, must return 0 if it depends on the block number
14     function startTime() public view returns(uint);
15 
16     // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
17     function endTime() public view returns(uint);
18 
19     // Optional function, can be implemented in place of startTime
20     // Returns the starting block number of the ico, must return 0 if it depends on the time stamp
21     // function startBlock() public view returns(uint);
22 
23     // Optional function, can be implemented in place of endTime
24     // Returns theending block number of the ico, must retrun 0 if it depends on the time stamp
25     // function endBlock() public view returns(uint);
26 
27     // returns the total number of the tokens available for the sale, must not change when the ico is started
28     function totalTokens() public view returns(uint);
29 
30     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
31     // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
32     function remainingTokens() public view returns(uint);
33 
34     // return the price as number of tokens released for each ether
35     function price() public view returns(uint);
36 }
37 
38 // File: zeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     if (a == 0) {
51       return 0;
52     }
53     c = a * b;
54     assert(c / a == b);
55     return c;
56   }
57 
58   /**
59   * @dev Integer division of two numbers, truncating the quotient.
60   */
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     // uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return a / b;
66   }
67 
68   /**
69   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
70   */
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   /**
77   * @dev Adds two numbers, throws on overflow.
78   */
79   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
80     c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 
86 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
87 
88 /**
89  * @title Ownable
90  * @dev The Ownable contract has an owner address, and provides basic authorization control
91  * functions, this simplifies the implementation of "user permissions".
92  */
93 contract Ownable {
94   address public owner;
95 
96 
97   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 
99 
100   /**
101    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102    * account.
103    */
104   function Ownable() public {
105     owner = msg.sender;
106   }
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(msg.sender == owner);
113     _;
114   }
115 
116   /**
117    * @dev Allows the current owner to transfer control of the contract to a newOwner.
118    * @param newOwner The address to transfer ownership to.
119    */
120   function transferOwnership(address newOwner) public onlyOwner {
121     require(newOwner != address(0));
122     emit OwnershipTransferred(owner, newOwner);
123     owner = newOwner;
124   }
125 
126 }
127 
128 // File: contracts/KYCBase.sol
129 
130 // Abstract base contract
131 contract KYCBase {
132     using SafeMath for uint256;
133 
134     mapping (address => bool) public isKycSigner;
135     mapping (uint64 => uint256) public alreadyPayed;
136 
137     event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);
138 
139     function KYCBase(address [] kycSigners) internal {
140         for (uint i = 0; i < kycSigners.length; i++) {
141             isKycSigner[kycSigners[i]] = true;
142         }
143     }
144 
145     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
146     function releaseTokensTo(address buyer, address signer) internal returns(bool);
147 
148     // This method can be overridden to enable some sender to buy token for a different address
149     function senderAllowedFor(address buyer)
150         internal view returns(bool)
151     {
152         return buyer == msg.sender;
153     }
154 
155     function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
156         public payable returns (bool)
157     {
158         require(senderAllowedFor(buyerAddress));
159         return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);
160     }
161 
162     function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
163         public payable returns (bool)
164     {
165         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
166     }
167 
168     function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
169         private returns (bool)
170     {
171         // check the signature
172         bytes32 hash = sha256("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount);
173         address signer = ecrecover(hash, v, r, s);
174         if (!isKycSigner[signer]) {
175             revert();
176         } else {
177             uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);
178             require(totalPayed <= maxAmount);
179             alreadyPayed[buyerId] = totalPayed;
180             KycVerified(signer, buyerAddress, buyerId, maxAmount);
181             return releaseTokensTo(buyerAddress, signer);
182         }
183     }
184 
185     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
186     function () public {
187         revert();
188     }
189 }
190 
191 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
192 
193 /**
194  * @title ERC20Basic
195  * @dev Simpler version of ERC20 interface
196  * @dev see https://github.com/ethereum/EIPs/issues/179
197  */
198 contract ERC20Basic {
199   function totalSupply() public view returns (uint256);
200   function balanceOf(address who) public view returns (uint256);
201   function transfer(address to, uint256 value) public returns (bool);
202   event Transfer(address indexed from, address indexed to, uint256 value);
203 }
204 
205 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
206 
207 /**
208  * @title Basic token
209  * @dev Basic version of StandardToken, with no allowances.
210  */
211 contract BasicToken is ERC20Basic {
212   using SafeMath for uint256;
213 
214   mapping(address => uint256) balances;
215 
216   uint256 totalSupply_;
217 
218   /**
219   * @dev total number of tokens in existence
220   */
221   function totalSupply() public view returns (uint256) {
222     return totalSupply_;
223   }
224 
225   /**
226   * @dev transfer token for a specified address
227   * @param _to The address to transfer to.
228   * @param _value The amount to be transferred.
229   */
230   function transfer(address _to, uint256 _value) public returns (bool) {
231     require(_to != address(0));
232     require(_value <= balances[msg.sender]);
233 
234     balances[msg.sender] = balances[msg.sender].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     emit Transfer(msg.sender, _to, _value);
237     return true;
238   }
239 
240   /**
241   * @dev Gets the balance of the specified address.
242   * @param _owner The address to query the the balance of.
243   * @return An uint256 representing the amount owned by the passed address.
244   */
245   function balanceOf(address _owner) public view returns (uint256) {
246     return balances[_owner];
247   }
248 
249 }
250 
251 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
252 
253 /**
254  * @title ERC20 interface
255  * @dev see https://github.com/ethereum/EIPs/issues/20
256  */
257 contract ERC20 is ERC20Basic {
258   function allowance(address owner, address spender) public view returns (uint256);
259   function transferFrom(address from, address to, uint256 value) public returns (bool);
260   function approve(address spender, uint256 value) public returns (bool);
261   event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 
264 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
265 
266 /**
267  * @title Standard ERC20 token
268  *
269  * @dev Implementation of the basic standard token.
270  * @dev https://github.com/ethereum/EIPs/issues/20
271  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
272  */
273 contract StandardToken is ERC20, BasicToken {
274 
275   mapping (address => mapping (address => uint256)) internal allowed;
276 
277 
278   /**
279    * @dev Transfer tokens from one address to another
280    * @param _from address The address which you want to send tokens from
281    * @param _to address The address which you want to transfer to
282    * @param _value uint256 the amount of tokens to be transferred
283    */
284   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
285     require(_to != address(0));
286     require(_value <= balances[_from]);
287     require(_value <= allowed[_from][msg.sender]);
288 
289     balances[_from] = balances[_from].sub(_value);
290     balances[_to] = balances[_to].add(_value);
291     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
292     emit Transfer(_from, _to, _value);
293     return true;
294   }
295 
296   /**
297    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
298    *
299    * Beware that changing an allowance with this method brings the risk that someone may use both the old
300    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
301    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
302    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
303    * @param _spender The address which will spend the funds.
304    * @param _value The amount of tokens to be spent.
305    */
306   function approve(address _spender, uint256 _value) public returns (bool) {
307     allowed[msg.sender][_spender] = _value;
308     emit Approval(msg.sender, _spender, _value);
309     return true;
310   }
311 
312   /**
313    * @dev Function to check the amount of tokens that an owner allowed to a spender.
314    * @param _owner address The address which owns the funds.
315    * @param _spender address The address which will spend the funds.
316    * @return A uint256 specifying the amount of tokens still available for the spender.
317    */
318   function allowance(address _owner, address _spender) public view returns (uint256) {
319     return allowed[_owner][_spender];
320   }
321 
322   /**
323    * @dev Increase the amount of tokens that an owner allowed to a spender.
324    *
325    * approve should be called when allowed[_spender] == 0. To increment
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _addedValue The amount of tokens to increase the allowance by.
331    */
332   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
333     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
334     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337 
338   /**
339    * @dev Decrease the amount of tokens that an owner allowed to a spender.
340    *
341    * approve should be called when allowed[_spender] == 0. To decrement
342    * allowed value is better to use this function to avoid 2 calls (and wait until
343    * the first transaction is mined)
344    * From MonolithDAO Token.sol
345    * @param _spender The address which will spend the funds.
346    * @param _subtractedValue The amount of tokens to decrease the allowance by.
347    */
348   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
349     uint oldValue = allowed[msg.sender][_spender];
350     if (_subtractedValue > oldValue) {
351       allowed[msg.sender][_spender] = 0;
352     } else {
353       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
354     }
355     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
356     return true;
357   }
358 
359 }
360 
361 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
362 
363 /**
364  * @title Mintable token
365  * @dev Simple ERC20 Token example, with mintable token creation
366  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
367  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
368  */
369 contract MintableToken is StandardToken, Ownable {
370   event Mint(address indexed to, uint256 amount);
371   event MintFinished();
372 
373   bool public mintingFinished = false;
374 
375 
376   modifier canMint() {
377     require(!mintingFinished);
378     _;
379   }
380 
381   /**
382    * @dev Function to mint tokens
383    * @param _to The address that will receive the minted tokens.
384    * @param _amount The amount of tokens to mint.
385    * @return A boolean that indicates if the operation was successful.
386    */
387   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
388     totalSupply_ = totalSupply_.add(_amount);
389     balances[_to] = balances[_to].add(_amount);
390     emit Mint(_to, _amount);
391     emit Transfer(address(0), _to, _amount);
392     return true;
393   }
394 
395   /**
396    * @dev Function to stop minting new tokens.
397    * @return True if the operation was successful.
398    */
399   function finishMinting() onlyOwner canMint public returns (bool) {
400     mintingFinished = true;
401     emit MintFinished();
402     return true;
403   }
404 }
405 
406 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
407 
408 /**
409  * @title Capped token
410  * @dev Mintable token with a token cap.
411  */
412 contract CappedToken is MintableToken {
413 
414   uint256 public cap;
415 
416   function CappedToken(uint256 _cap) public {
417     require(_cap > 0);
418     cap = _cap;
419   }
420 
421   /**
422    * @dev Function to mint tokens
423    * @param _to The address that will receive the minted tokens.
424    * @param _amount The amount of tokens to mint.
425    * @return A boolean that indicates if the operation was successful.
426    */
427   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
428     require(totalSupply_.add(_amount) <= cap);
429 
430     return super.mint(_to, _amount);
431   }
432 
433 }
434 
435 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
436 
437 /**
438  * @title Pausable
439  * @dev Base contract which allows children to implement an emergency stop mechanism.
440  */
441 contract Pausable is Ownable {
442   event Pause();
443   event Unpause();
444 
445   bool public paused = false;
446 
447 
448   /**
449    * @dev Modifier to make a function callable only when the contract is not paused.
450    */
451   modifier whenNotPaused() {
452     require(!paused);
453     _;
454   }
455 
456   /**
457    * @dev Modifier to make a function callable only when the contract is paused.
458    */
459   modifier whenPaused() {
460     require(paused);
461     _;
462   }
463 
464   /**
465    * @dev called by the owner to pause, triggers stopped state
466    */
467   function pause() onlyOwner whenNotPaused public {
468     paused = true;
469     emit Pause();
470   }
471 
472   /**
473    * @dev called by the owner to unpause, returns to normal state
474    */
475   function unpause() onlyOwner whenPaused public {
476     paused = false;
477     emit Unpause();
478   }
479 }
480 
481 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
482 
483 /**
484  * @title Pausable token
485  * @dev StandardToken modified with pausable transfers.
486  **/
487 contract PausableToken is StandardToken, Pausable {
488 
489   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
490     return super.transfer(_to, _value);
491   }
492 
493   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
494     return super.transferFrom(_from, _to, _value);
495   }
496 
497   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
498     return super.approve(_spender, _value);
499   }
500 
501   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
502     return super.increaseApproval(_spender, _addedValue);
503   }
504 
505   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
506     return super.decreaseApproval(_spender, _subtractedValue);
507   }
508 }
509 
510 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
511 
512 /**
513  * @title Burnable Token
514  * @dev Token that can be irreversibly burned (destroyed).
515  */
516 contract BurnableToken is BasicToken {
517 
518   event Burn(address indexed burner, uint256 value);
519 
520   /**
521    * @dev Burns a specific amount of tokens.
522    * @param _value The amount of token to be burned.
523    */
524   function burn(uint256 _value) public {
525     _burn(msg.sender, _value);
526   }
527 
528   function _burn(address _who, uint256 _value) internal {
529     require(_value <= balances[_who]);
530     // no need to require value <= totalSupply, since that would imply the
531     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
532 
533     balances[_who] = balances[_who].sub(_value);
534     totalSupply_ = totalSupply_.sub(_value);
535     emit Burn(_who, _value);
536     emit Transfer(_who, address(0), _value);
537   }
538 }
539 
540 // File: zeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
541 
542 /**
543  * @title Standard Burnable Token
544  * @dev Adds burnFrom method to ERC20 implementations
545  */
546 contract StandardBurnableToken is BurnableToken, StandardToken {
547 
548   /**
549    * @dev Burns a specific amount of tokens from the target address and decrements allowance
550    * @param _from address The address which you want to send tokens from
551    * @param _value uint256 The amount of token to be burned
552    */
553   function burnFrom(address _from, uint256 _value) public {
554     require(_value <= allowed[_from][msg.sender]);
555     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
556     // this function needs to emit an event with the updated approval.
557     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
558     _burn(_from, _value);
559   }
560 }
561 
562 // File: contracts/ORSToken.sol
563 
564 /// @title ORSToken
565 /// @author Sicos et al.
566 contract ORSToken is CappedToken, StandardBurnableToken, PausableToken {
567 
568     string public name = "ORS Token";
569     string public symbol = "ORS";
570     uint8 public decimals = 18;
571 
572     /// @dev Constructor
573     /// @param _cap Maximum number of integral token units; total supply must never exceed this limit
574     constructor(uint _cap) public CappedToken(_cap) {
575         pause();  // Disable token trade
576     }
577 
578 }
579 
580 // File: contracts/ORSTokenSale.sol
581 
582 /// @title ORSTokenSale
583 /// @author Sicos et al.
584 contract ORSTokenSale is KYCBase, ICOEngineInterface, Ownable {
585 
586     using SafeMath for uint;
587 
588     // Maximum token amounts of each pool
589     // Note: There were 218054209 token sold in PreSale
590     // Note: 4193635 Bonus token will be issued to preSale investors
591     // Note: PRESALE_CAP = 218054209 PreSale token + 4193635 PreSale Bonus token
592     uint constant public PRESALE_CAP = 222247844e18;          // 222,247,844 e18
593     uint constant public MAINSALE_CAP = 281945791e18;         // 281,945,791 e18
594     // Note: BONUS_CAP should be at least 5% of MAINSALE_CAP
595     // Note: BONUS_CAP = 64460000 BONUS token  - 4193635 PreSale Bonus token
596     uint constant public BONUS_CAP = 60266365e18;             //  60,266,365 e18
597 
598     // Granted token shares that will be minted upon finalization
599     uint constant public COMPANY_SHARE = 127206667e18;        // 127,206,667 e18
600     uint constant public TEAM_SHARE = 83333333e18;            //  83,333,333 e18
601     uint constant public ADVISORS_SHARE = 58333333e18;        //  58,333,333 e18
602 
603     // Remaining token amounts of each pool
604     uint public presaleRemaining = PRESALE_CAP;
605     uint public mainsaleRemaining = MAINSALE_CAP;
606     uint public bonusRemaining = BONUS_CAP;
607 
608     // Beneficiaries of granted token shares
609     address public companyWallet;
610     address public advisorsWallet;
611     address public bountyWallet;
612 
613     ORSToken public token;
614 
615     // Integral token units (10^-18 tokens) per wei
616     uint public rate;
617 
618     // Mainsale period
619     uint public openingTime;
620     uint public closingTime;
621 
622     // Ethereum address where invested funds will be transferred to
623     address public wallet;
624 
625     // Purchases signed via Eidoo's platform will receive bonus tokens
626     address public eidooSigner;
627 
628     bool public isFinalized = false;
629 
630     /// @dev Log entry on rate changed
631     /// @param newRate New rate in integral token units per wei
632     event RateChanged(uint newRate);
633 
634     /// @dev Log entry on token purchased
635     /// @param buyer Ethereum address of token purchaser
636     /// @param value Worth in wei of purchased token amount
637     /// @param tokens Number of integral token units
638     event TokenPurchased(address indexed buyer, uint value, uint tokens);
639 
640     /// @dev Log entry on buyer refunded upon token purchase
641     /// @param buyer Ethereum address of token purchaser
642     /// @param value Worth of refund of wei
643     event BuyerRefunded(address indexed buyer, uint value);
644 
645     /// @dev Log entry on finalized
646     event Finalized();
647 
648     /// @dev Constructor
649     /// @param _token An ORSToken
650     /// @param _rate Rate in integral token units per wei
651     /// @param _openingTime Block (Unix) timestamp of mainsale start time
652     /// @param _closingTime Block (Unix) timestamp of mainsale latest end time
653     /// @param _wallet Ethereum account who will receive sent ether upon token purchase during mainsale
654     /// @param _companyWallet Ethereum account of company who will receive company share upon finalization
655     /// @param _advisorsWallet Ethereum account of advisors who will receive advisors share upon finalization
656     /// @param _bountyWallet Ethereum account of a wallet that will receive remaining bonus upon finalization
657     /// @param _kycSigners List of KYC signers' Ethereum addresses
658     constructor(
659         ORSToken _token,
660         uint _rate,
661         uint _openingTime,
662         uint _closingTime,
663         address _wallet,
664         address _companyWallet,
665         address _advisorsWallet,
666         address _bountyWallet,
667         address[] _kycSigners
668     )
669         public
670         KYCBase(_kycSigners)
671     {
672         require(_token != address(0x0));
673         require(_token.cap() == PRESALE_CAP + MAINSALE_CAP + BONUS_CAP + COMPANY_SHARE + TEAM_SHARE + ADVISORS_SHARE);
674         require(_rate > 0);
675         require(_openingTime > now && _closingTime > _openingTime);
676         require(_wallet != address(0x0));
677         require(_companyWallet != address(0x0) && _advisorsWallet != address(0x0) && _bountyWallet != address(0x0));
678         require(_kycSigners.length >= 2);
679 
680         token = _token;
681         rate = _rate;
682         openingTime = _openingTime;
683         closingTime = _closingTime;
684         wallet = _wallet;
685         companyWallet = _companyWallet;
686         advisorsWallet = _advisorsWallet;
687         bountyWallet = _bountyWallet;
688 
689         eidooSigner = _kycSigners[0];
690     }
691 
692     /// @dev Set rate, i.e. adjust to changes of fiat/ether exchange rates
693     /// @param newRate Rate in integral token units per wei
694     function setRate(uint newRate) public onlyOwner {
695         require(newRate > 0);
696 
697         if (newRate != rate) {
698             rate = newRate;
699 
700             emit RateChanged(newRate);
701         }
702     }
703 
704     /// @dev Distribute presold tokens and bonus tokens to investors
705     /// @param investors List of investors' Ethereum addresses
706     /// @param tokens List of integral token amounts each investors will receive
707     function distributePresale(address[] investors, uint[] tokens) public onlyOwner {
708         require(!isFinalized);
709         require(tokens.length == investors.length);
710 
711         for (uint i = 0; i < investors.length; ++i) {
712             presaleRemaining = presaleRemaining.sub(tokens[i]);
713 
714             token.mint(investors[i], tokens[i]);
715         }
716     }
717 
718     /// @dev Finalize, i.e. end token minting phase and enable token trading
719     function finalize() public onlyOwner {
720         require(ended() && !isFinalized);
721         require(presaleRemaining == 0);
722 
723         // Distribute granted token shares
724         token.mint(companyWallet, COMPANY_SHARE + TEAM_SHARE);
725         token.mint(advisorsWallet, ADVISORS_SHARE);
726 
727         // There shouldn't be any remaining presale tokens
728         // Remaining mainsale tokens will be lost (i.e. not minted)
729         // Remaining bonus tokens will be minted for the benefit of bounty wallet
730         if (bonusRemaining > 0) {
731             token.mint(bountyWallet, bonusRemaining);
732             bonusRemaining = 0;
733         }
734 
735         // Enable token trade
736         token.finishMinting();
737         token.unpause();
738 
739         isFinalized = true;
740 
741         emit Finalized();
742     }
743 
744     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
745     /// @dev Started (as required by Eidoo's ICOEngineInterface)
746     /// @return True iff mainsale start has passed
747     function started() public view returns (bool) {
748         return now >= openingTime;
749     }
750 
751     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
752     /// @dev Ended (as required by Eidoo's ICOEngineInterface)
753     /// @return True iff mainsale is finished
754     function ended() public view returns (bool) {
755         // Note: Even though we allow token holders to burn their tokens immediately after purchase, this won't
756         //       affect the early end via "sold out" as mainsaleRemaining is independent of token.totalSupply.
757         return now > closingTime || mainsaleRemaining == 0;
758     }
759 
760     // time stamp of the starting time of the ico, must return 0 if it depends on the block number
761     /// @dev Start time (as required by Eidoo's ICOEngineInterface)
762     /// @return Block (Unix) timestamp of mainsale start time
763     function startTime() public view returns (uint) {
764         return openingTime;
765     }
766 
767     // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
768     /// @dev End time (as required by Eidoo's ICOEngineInterface)
769     /// @return Block (Unix) timestamp of mainsale latest end time
770     function endTime() public view returns (uint) {
771         return closingTime;
772     }
773 
774     // returns the total number of the tokens available for the sale, must not change when the ico is started
775     /// @dev Total amount of tokens initially available for purchase during mainsale (excluding bonus tokens)
776     /// @return Integral token units
777     function totalTokens() public view returns (uint) {
778         return MAINSALE_CAP;
779     }
780 
781     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be
782     // equal to totalTokens(), then it will decrease. It is used to calculate the percentage of sold tokens as
783     // remainingTokens() / totalTokens()
784     /// @dev Remaining amount of tokens available for purchase during mainsale (excluding bonus tokens)
785     /// @return Integral token units
786     function remainingTokens() public view returns (uint) {
787         return mainsaleRemaining;
788     }
789 
790     // return the price as number of tokens released for each ether
791     /// @dev Price (as required by Eidoo's ICOEngineInterface); actually the inverse of a "price"
792     /// @return Rate in integral token units per wei
793     function price() public view returns (uint) {
794         return rate;
795     }
796 
797     /// @dev Release purchased tokens to buyers during mainsale (as required by Eidoo's ICOEngineInterface)
798     /// @param buyer Ethereum address of purchaser
799     /// @param signer Ethereum address of signer
800     /// @return Always true, failures will be indicated by transaction reversal
801     function releaseTokensTo(address buyer, address signer) internal returns (bool) {
802         require(started() && !ended());
803 
804         uint value = msg.value;
805         uint refund = 0;
806 
807         uint tokens = value.mul(rate);
808         uint bonus = 0;
809 
810         // (Last) buyer whose purchase would exceed available mainsale tokens will be partially refunded
811         if (tokens > mainsaleRemaining) {
812             uint valueOfRemaining = mainsaleRemaining.div(rate);
813 
814             refund = value.sub(valueOfRemaining);
815             value = valueOfRemaining;
816             tokens = mainsaleRemaining;
817             // Note:
818             // To be 100% accurate the buyer should receive only a token amount that corresponds to valueOfRemaining,
819             // i.e. tokens = valueOfRemaining.mul(rate), because of mainsaleRemaining may not be a multiple of rate
820             // (due to regular adaption to the ether/fiat exchange rate).
821             // Nevertheless, we deliver all mainsaleRemaining tokens as the worth of these additional tokens at time
822             // of purchase is less than a wei and the gas costs of a correct solution, i.e. calculate value * rate
823             // again, would exceed this by several orders of magnitude.
824         }
825 
826         // Purchases signed via Eidoo's platform will receive additional 5% bonus tokens
827         if (signer == eidooSigner) {
828             bonus = tokens.div(20);
829         }
830 
831         mainsaleRemaining = mainsaleRemaining.sub(tokens);
832         bonusRemaining = bonusRemaining.sub(bonus);
833 
834         token.mint(buyer, tokens.add(bonus));
835         wallet.transfer(value);
836         if (refund > 0) {
837             buyer.transfer(refund);
838 
839             emit BuyerRefunded(buyer, refund);
840         }
841 
842         emit TokenPurchased(buyer, value, tokens.add(bonus));
843 
844         return true;
845     }
846 
847 }