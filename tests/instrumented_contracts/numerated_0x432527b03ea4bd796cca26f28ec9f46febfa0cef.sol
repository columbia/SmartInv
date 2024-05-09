1 //File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
2 pragma solidity ^0.4.18;
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 //File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
46 pragma solidity ^0.4.18;
47 
48 
49 
50 
51 
52 /**
53  * @title Pausable
54  * @dev Base contract which allows children to implement an emergency stop mechanism.
55  */
56 contract Pausable is Ownable {
57   event Pause();
58   event Unpause();
59 
60   bool public paused = false;
61 
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is not paused.
65    */
66   modifier whenNotPaused() {
67     require(!paused);
68     _;
69   }
70 
71   /**
72    * @dev Modifier to make a function callable only when the contract is paused.
73    */
74   modifier whenPaused() {
75     require(paused);
76     _;
77   }
78 
79   /**
80    * @dev called by the owner to pause, triggers stopped state
81    */
82   function pause() onlyOwner whenNotPaused public {
83     paused = true;
84     Pause();
85   }
86 
87   /**
88    * @dev called by the owner to unpause, returns to normal state
89    */
90   function unpause() onlyOwner whenPaused public {
91     paused = false;
92     Unpause();
93   }
94 }
95 
96 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
97 pragma solidity ^0.4.18;
98 
99 
100 /**
101  * @title ERC20Basic
102  * @dev Simpler version of ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/179
104  */
105 contract ERC20Basic {
106   function totalSupply() public view returns (uint256);
107   function balanceOf(address who) public view returns (uint256);
108   function transfer(address to, uint256 value) public returns (bool);
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
113 pragma solidity ^0.4.18;
114 
115 
116 
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender) public view returns (uint256);
124   function transferFrom(address from, address to, uint256 value) public returns (bool);
125   function approve(address spender, uint256 value) public returns (bool);
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
130 pragma solidity ^0.4.18;
131 
132 
133 
134 
135 
136 /**
137  * @title SafeERC20
138  * @dev Wrappers around ERC20 operations that throw on failure.
139  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
140  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
141  */
142 library SafeERC20 {
143   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
144     assert(token.transfer(to, value));
145   }
146 
147   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
148     assert(token.transferFrom(from, to, value));
149   }
150 
151   function safeApprove(ERC20 token, address spender, uint256 value) internal {
152     assert(token.approve(spender, value));
153   }
154 }
155 
156 //File: node_modules/zeppelin-solidity/contracts/ownership/CanReclaimToken.sol
157 pragma solidity ^0.4.18;
158 
159 
160 
161 
162 
163 
164 /**
165  * @title Contracts that should be able to recover tokens
166  * @author SylTi
167  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
168  * This will prevent any accidental loss of tokens.
169  */
170 contract CanReclaimToken is Ownable {
171   using SafeERC20 for ERC20Basic;
172 
173   /**
174    * @dev Reclaim all ERC20Basic compatible tokens
175    * @param token ERC20Basic The address of the token contract
176    */
177   function reclaimToken(ERC20Basic token) external onlyOwner {
178     uint256 balance = token.balanceOf(this);
179     token.safeTransfer(owner, balance);
180   }
181 
182 }
183 
184 //File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
185 pragma solidity ^0.4.18;
186 
187 
188 /**
189  * @title SafeMath
190  * @dev Math operations with safety checks that throw on error
191  */
192 library SafeMath {
193 
194   /**
195   * @dev Multiplies two numbers, throws on overflow.
196   */
197   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198     if (a == 0) {
199       return 0;
200     }
201     uint256 c = a * b;
202     assert(c / a == b);
203     return c;
204   }
205 
206   /**
207   * @dev Integer division of two numbers, truncating the quotient.
208   */
209   function div(uint256 a, uint256 b) internal pure returns (uint256) {
210     // assert(b > 0); // Solidity automatically throws when dividing by 0
211     uint256 c = a / b;
212     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213     return c;
214   }
215 
216   /**
217   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
218   */
219   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
220     assert(b <= a);
221     return a - b;
222   }
223 
224   /**
225   * @dev Adds two numbers, throws on overflow.
226   */
227   function add(uint256 a, uint256 b) internal pure returns (uint256) {
228     uint256 c = a + b;
229     assert(c >= a);
230     return c;
231   }
232 }
233 
234 //File: src/contracts/ico/KYCBase.sol
235 pragma solidity ^0.4.19;
236 
237 
238 
239 
240 // Abstract base contract
241 contract KYCBase {
242     using SafeMath for uint256;
243 
244     mapping (address => bool) public isKycSigner;
245     mapping (uint64 => uint256) public alreadyPayed;
246 
247     event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);
248 
249     function KYCBase(address [] kycSigners) internal {
250         for (uint i = 0; i < kycSigners.length; i++) {
251             isKycSigner[kycSigners[i]] = true;
252         }
253     }
254 
255     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
256     function releaseTokensTo(address buyer) internal returns(bool);
257 
258     // This method can be overridden to enable some sender to buy token for a different address
259     function senderAllowedFor(address buyer)
260         internal view returns(bool)
261     {
262         return buyer == msg.sender;
263     }
264 
265     function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
266         public payable returns (bool)
267     {
268         require(senderAllowedFor(buyerAddress));
269         return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);
270     }
271 
272     function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
273         public payable returns (bool)
274     {
275         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
276     }
277 
278     function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
279         private returns (bool)
280     {
281         // check the signature
282         bytes32 hash = sha256("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount);
283         address signer = ecrecover(hash, v, r, s);
284         if (!isKycSigner[signer]) {
285             revert();
286         } else {
287             uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);
288             require(totalPayed <= maxAmount);
289             alreadyPayed[buyerId] = totalPayed;
290             KycVerified(signer, buyerAddress, buyerId, maxAmount);
291             return releaseTokensTo(buyerAddress);
292         }
293         return true;
294     }
295 
296     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
297     function () public {
298         revert();
299     }
300 }
301 //File: src/contracts/ico/ICOEngineInterface.sol
302 pragma solidity ^0.4.19;
303 
304 
305 contract ICOEngineInterface {
306 
307     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
308     function started() public view returns(bool);
309 
310     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
311     function ended() public view returns(bool);
312 
313     // time stamp of the starting time of the ico, must return 0 if it depends on the block number
314     function startTime() public view returns(uint);
315 
316     // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
317     function endTime() public view returns(uint);
318 
319     // Optional function, can be implemented in place of startTime
320     // Returns the starting block number of the ico, must return 0 if it depends on the time stamp
321     // function startBlock() public view returns(uint);
322 
323     // Optional function, can be implemented in place of endTime
324     // Returns theending block number of the ico, must retrun 0 if it depends on the time stamp
325     // function endBlock() public view returns(uint);
326 
327     // returns the total number of the tokens available for the sale, must not change when the ico is started
328     function totalTokens() public view returns(uint);
329 
330     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
331     // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
332     function remainingTokens() public view returns(uint);
333 
334     // return the price as number of tokens released for each ether
335     function price() public view returns(uint);
336 }
337 //File: src/contracts/ico/CrowdsaleBase.sol
338 /**
339  * @title CrowdsaleBase
340  * @dev Base crowdsale contract to be inherited by the UacCrowdsale and Reservation contracts.
341  *
342  * @version 1.0
343  * @author Validity Labs AG <info@validitylabs.org>
344  */
345 pragma solidity ^0.4.19;
346 
347 
348 
349 
350 
351 
352 
353 contract CrowdsaleBase is Pausable, CanReclaimToken, ICOEngineInterface, KYCBase {
354 
355     /*** CONSTANTS ***/
356     uint256 public constant USD_PER_TOKEN = 2;                        //
357     uint256 public constant USD_PER_ETHER = 1000;                      // 
358 
359     uint256 public start;                                             // ICOEngineInterface
360     uint256 public end;                                               // ICOEngineInterface
361     uint256 public cap;                                               // ICOEngineInterface
362     address public wallet;
363     uint256 public tokenPerEth;
364     uint256 public availableTokens;                                   // ICOEngineInterface
365     address[] public kycSigners;                                      // KYCBase
366     bool public capReached;
367     uint256 public weiRaised;
368     uint256 public tokensSold;
369 
370     /**
371      * @dev Constructor.
372      * @param _start The start time of the sale.
373      * @param _end The end time of the sale.
374      * @param _cap The maximum amount of tokens to be sold during the sale.
375      * @param _wallet The address where funds should be transferred.
376      * @param _kycSigners Array of the signers addresses required by the KYCBase constructor, provided by Eidoo.
377      * See https://github.com/eidoo/icoengine
378      */
379     function CrowdsaleBase(
380         uint256 _start,
381         uint256 _end,
382         uint256 _cap,
383         address _wallet,
384         address[] _kycSigners
385     )
386         public
387         KYCBase(_kycSigners)
388     {
389         require(_end >= _start);
390         require(_cap > 0);
391 
392         start = _start;
393         end = _end;
394         cap = _cap;
395         wallet = _wallet;
396         tokenPerEth = USD_PER_ETHER.div(USD_PER_TOKEN);
397         availableTokens = _cap;
398         kycSigners = _kycSigners;
399     }
400 
401     /**
402      * @dev Implements the ICOEngineInterface.
403      * @return False if the ico is not started, true if the ico is started and running, true if the ico is completed.
404      */
405     function started() public view returns(bool) {
406         if (block.timestamp >= start) {
407             return true;
408         } else {
409             return false;
410         }
411     }
412 
413     /**
414      * @dev Implements the ICOEngineInterface.
415      * @return False if the ico is not started, false if the ico is started and running, true if the ico is completed.
416      */
417     function ended() public view returns(bool) {
418         if (block.timestamp >= end) {
419             return true;
420         } else {
421             return false;
422         }
423     }
424 
425     /**
426      * @dev Implements the ICOEngineInterface.
427      * @return Timestamp of the ico start time.
428      */
429     function startTime() public view returns(uint) {
430         return start;
431     }
432 
433     /**
434      * @dev Implements the ICOEngineInterface.
435      * @return Timestamp of the ico end time.
436      */
437     function endTime() public view returns(uint) {
438         return end;
439     }
440 
441     /**
442      * @dev Implements the ICOEngineInterface.
443      * @return The total number of the tokens available for the sale, must not change when the ico is started.
444      */
445     function totalTokens() public view returns(uint) {
446         return cap;
447     }
448 
449     /**
450      * @dev Implements the ICOEngineInterface.
451      * @return The number of the tokens available for the ico. At the moment the ico starts it must be equal to totalTokens(),
452      * then it will decrease.
453      */
454     function remainingTokens() public view returns(uint) {
455         return availableTokens;
456     }
457 
458     /**
459      * @dev Implements the KYCBase senderAllowedFor function to enable a sender to buy tokens for a different address.
460      * @return true.
461      */
462     function senderAllowedFor(address buyer) internal view returns(bool) {
463         require(buyer != address(0));
464 
465         return true;
466     }
467 
468     /**
469      * @dev Implements the KYCBase releaseTokensTo function to mint tokens for an investor. Called after the KYC process has passed.
470      * @return A bollean that indicates if the operation was successful.
471      */
472     function releaseTokensTo(address buyer) internal returns(bool) {
473         require(validPurchase());
474 
475         uint256 overflowTokens;
476         uint256 refundWeiAmount;
477 
478         uint256 weiAmount = msg.value;
479         uint256 tokenAmount = weiAmount.mul(price());
480 
481         if (tokenAmount >= availableTokens) {
482             capReached = true;
483             overflowTokens = tokenAmount.sub(availableTokens);
484             tokenAmount = tokenAmount.sub(overflowTokens);
485             refundWeiAmount = overflowTokens.div(price());
486             weiAmount = weiAmount.sub(refundWeiAmount);
487             buyer.transfer(refundWeiAmount);
488         }
489 
490         weiRaised = weiRaised.add(weiAmount);
491         tokensSold = tokensSold.add(tokenAmount);
492         availableTokens = availableTokens.sub(tokenAmount);
493         mintTokens(buyer, tokenAmount);
494         forwardFunds(weiAmount);
495 
496         return true;
497     }
498 
499     /**
500      * @dev Fired by the releaseTokensTo function after minting tokens, to forward the raised wei to the address that collects funds.
501      * @param _weiAmount Amount of wei send by the investor.
502      */
503     function forwardFunds(uint256 _weiAmount) internal {
504         wallet.transfer(_weiAmount);
505     }
506 
507     /**
508      * @dev Validates an incoming purchase. Required statements revert state when conditions are not met.
509      * @return true If the transaction can buy tokens.
510      */
511     function validPurchase() internal view returns (bool) {
512         require(!paused && !capReached);
513         require(block.timestamp >= start && block.timestamp <= end);
514 
515         return true;
516     }
517 
518     /**
519     * @dev Abstract function to mint tokens, to be implemented in the Crowdsale and Reservation contracts.
520     * @param to The address that will receive the minted tokens.
521     * @param amount The amount of tokens to mint.
522     */
523     function mintTokens(address to, uint256 amount) private;
524 }
525 
526 
527 
528 
529 
530 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
531 pragma solidity ^0.4.18;
532 
533 
534 
535 
536 
537 
538 
539 /**
540  * @title TokenVesting
541  * @dev A token holder contract that can release its token balance gradually like a
542  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
543  * owner.
544  */
545 contract TokenVesting is Ownable {
546   using SafeMath for uint256;
547   using SafeERC20 for ERC20Basic;
548 
549   event Released(uint256 amount);
550   event Revoked();
551 
552   // beneficiary of tokens after they are released
553   address public beneficiary;
554 
555   uint256 public cliff;
556   uint256 public start;
557   uint256 public duration;
558 
559   bool public revocable;
560 
561   mapping (address => uint256) public released;
562   mapping (address => bool) public revoked;
563 
564   /**
565    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
566    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
567    * of the balance will have vested.
568    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
569    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
570    * @param _duration duration in seconds of the period in which the tokens will vest
571    * @param _revocable whether the vesting is revocable or not
572    */
573   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
574     require(_beneficiary != address(0));
575     require(_cliff <= _duration);
576 
577     beneficiary = _beneficiary;
578     revocable = _revocable;
579     duration = _duration;
580     cliff = _start.add(_cliff);
581     start = _start;
582   }
583 
584   /**
585    * @notice Transfers vested tokens to beneficiary.
586    * @param token ERC20 token which is being vested
587    */
588   function release(ERC20Basic token) public {
589     uint256 unreleased = releasableAmount(token);
590 
591     require(unreleased > 0);
592 
593     released[token] = released[token].add(unreleased);
594 
595     token.safeTransfer(beneficiary, unreleased);
596 
597     Released(unreleased);
598   }
599 
600   /**
601    * @notice Allows the owner to revoke the vesting. Tokens already vested
602    * remain in the contract, the rest are returned to the owner.
603    * @param token ERC20 token which is being vested
604    */
605   function revoke(ERC20Basic token) public onlyOwner {
606     require(revocable);
607     require(!revoked[token]);
608 
609     uint256 balance = token.balanceOf(this);
610 
611     uint256 unreleased = releasableAmount(token);
612     uint256 refund = balance.sub(unreleased);
613 
614     revoked[token] = true;
615 
616     token.safeTransfer(owner, refund);
617 
618     Revoked();
619   }
620 
621   /**
622    * @dev Calculates the amount that has already vested but hasn't been released yet.
623    * @param token ERC20 token which is being vested
624    */
625   function releasableAmount(ERC20Basic token) public view returns (uint256) {
626     return vestedAmount(token).sub(released[token]);
627   }
628 
629   /**
630    * @dev Calculates the amount that has already vested.
631    * @param token ERC20 token which is being vested
632    */
633   function vestedAmount(ERC20Basic token) public view returns (uint256) {
634     uint256 currentBalance = token.balanceOf(this);
635     uint256 totalBalance = currentBalance.add(released[token]);
636 
637     if (now < cliff) {
638       return 0;
639     } else if (now >= start.add(duration) || revoked[token]) {
640       return totalBalance;
641     } else {
642       return totalBalance.mul(now.sub(start)).div(duration);
643     }
644   }
645 }
646 
647 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
648 pragma solidity ^0.4.18;
649 
650 
651 
652 
653 
654 
655 /**
656  * @title Basic token
657  * @dev Basic version of StandardToken, with no allowances.
658  */
659 contract BasicToken is ERC20Basic {
660   using SafeMath for uint256;
661 
662   mapping(address => uint256) balances;
663 
664   uint256 totalSupply_;
665 
666   /**
667   * @dev total number of tokens in existence
668   */
669   function totalSupply() public view returns (uint256) {
670     return totalSupply_;
671   }
672 
673   /**
674   * @dev transfer token for a specified address
675   * @param _to The address to transfer to.
676   * @param _value The amount to be transferred.
677   */
678   function transfer(address _to, uint256 _value) public returns (bool) {
679     require(_to != address(0));
680     require(_value <= balances[msg.sender]);
681 
682     // SafeMath.sub will throw if there is not enough balance.
683     balances[msg.sender] = balances[msg.sender].sub(_value);
684     balances[_to] = balances[_to].add(_value);
685     Transfer(msg.sender, _to, _value);
686     return true;
687   }
688 
689   /**
690   * @dev Gets the balance of the specified address.
691   * @param _owner The address to query the the balance of.
692   * @return An uint256 representing the amount owned by the passed address.
693   */
694   function balanceOf(address _owner) public view returns (uint256 balance) {
695     return balances[_owner];
696   }
697 
698 }
699 
700 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
701 pragma solidity ^0.4.18;
702 
703 
704 
705 
706 
707 /**
708  * @title Standard ERC20 token
709  *
710  * @dev Implementation of the basic standard token.
711  * @dev https://github.com/ethereum/EIPs/issues/20
712  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
713  */
714 contract StandardToken is ERC20, BasicToken {
715 
716   mapping (address => mapping (address => uint256)) internal allowed;
717 
718 
719   /**
720    * @dev Transfer tokens from one address to another
721    * @param _from address The address which you want to send tokens from
722    * @param _to address The address which you want to transfer to
723    * @param _value uint256 the amount of tokens to be transferred
724    */
725   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
726     require(_to != address(0));
727     require(_value <= balances[_from]);
728     require(_value <= allowed[_from][msg.sender]);
729 
730     balances[_from] = balances[_from].sub(_value);
731     balances[_to] = balances[_to].add(_value);
732     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
733     Transfer(_from, _to, _value);
734     return true;
735   }
736 
737   /**
738    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
739    *
740    * Beware that changing an allowance with this method brings the risk that someone may use both the old
741    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
742    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
743    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
744    * @param _spender The address which will spend the funds.
745    * @param _value The amount of tokens to be spent.
746    */
747   function approve(address _spender, uint256 _value) public returns (bool) {
748     allowed[msg.sender][_spender] = _value;
749     Approval(msg.sender, _spender, _value);
750     return true;
751   }
752 
753   /**
754    * @dev Function to check the amount of tokens that an owner allowed to a spender.
755    * @param _owner address The address which owns the funds.
756    * @param _spender address The address which will spend the funds.
757    * @return A uint256 specifying the amount of tokens still available for the spender.
758    */
759   function allowance(address _owner, address _spender) public view returns (uint256) {
760     return allowed[_owner][_spender];
761   }
762 
763   /**
764    * @dev Increase the amount of tokens that an owner allowed to a spender.
765    *
766    * approve should be called when allowed[_spender] == 0. To increment
767    * allowed value is better to use this function to avoid 2 calls (and wait until
768    * the first transaction is mined)
769    * From MonolithDAO Token.sol
770    * @param _spender The address which will spend the funds.
771    * @param _addedValue The amount of tokens to increase the allowance by.
772    */
773   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
774     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
775     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
776     return true;
777   }
778 
779   /**
780    * @dev Decrease the amount of tokens that an owner allowed to a spender.
781    *
782    * approve should be called when allowed[_spender] == 0. To decrement
783    * allowed value is better to use this function to avoid 2 calls (and wait until
784    * the first transaction is mined)
785    * From MonolithDAO Token.sol
786    * @param _spender The address which will spend the funds.
787    * @param _subtractedValue The amount of tokens to decrease the allowance by.
788    */
789   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
790     uint oldValue = allowed[msg.sender][_spender];
791     if (_subtractedValue > oldValue) {
792       allowed[msg.sender][_spender] = 0;
793     } else {
794       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
795     }
796     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
797     return true;
798   }
799 
800 }
801 
802 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
803 pragma solidity ^0.4.18;
804 
805 
806 
807 
808 
809 /**
810  * @title Mintable token
811  * @dev Simple ERC20 Token example, with mintable token creation
812  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
813  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
814  */
815 contract MintableToken is StandardToken, Ownable {
816   event Mint(address indexed to, uint256 amount);
817   event MintFinished();
818 
819   bool public mintingFinished = false;
820 
821 
822   modifier canMint() {
823     require(!mintingFinished);
824     _;
825   }
826 
827   /**
828    * @dev Function to mint tokens
829    * @param _to The address that will receive the minted tokens.
830    * @param _amount The amount of tokens to mint.
831    * @return A boolean that indicates if the operation was successful.
832    */
833   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
834     totalSupply_ = totalSupply_.add(_amount);
835     balances[_to] = balances[_to].add(_amount);
836     Mint(_to, _amount);
837     Transfer(address(0), _to, _amount);
838     return true;
839   }
840 
841   /**
842    * @dev Function to stop minting new tokens.
843    * @return True if the operation was successful.
844    */
845   function finishMinting() onlyOwner canMint public returns (bool) {
846     mintingFinished = true;
847     MintFinished();
848     return true;
849   }
850 }
851 
852 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
853 pragma solidity ^0.4.18;
854 
855 
856 
857 
858 
859 /**
860  * @title Pausable token
861  * @dev StandardToken modified with pausable transfers.
862  **/
863 contract PausableToken is StandardToken, Pausable {
864 
865   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
866     return super.transfer(_to, _value);
867   }
868 
869   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
870     return super.transferFrom(_from, _to, _value);
871   }
872 
873   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
874     return super.approve(_spender, _value);
875   }
876 
877   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
878     return super.increaseApproval(_spender, _addedValue);
879   }
880 
881   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
882     return super.decreaseApproval(_spender, _subtractedValue);
883   }
884 }
885 
886 //File: src/contracts/ico/UacToken.sol
887 /**
888  * @title Ubiatar Coin token
889  *
890  * @version 1.0
891  * @author Validity Labs AG <info@validitylabs.org>
892  */
893 pragma solidity ^0.4.19;
894 
895 
896 
897 
898 
899 contract UacToken is CanReclaimToken, MintableToken, PausableToken {
900     string public constant name = "Ubiatar Coin";
901     string public constant symbol = "UAC";
902     uint8 public constant decimals = 18;
903 
904     /**
905      * @dev Constructor of UacToken that instantiates a new Mintable Pausable Token
906      */
907     function UacToken() public {
908         // token should not be transferrable until after all tokens have been issued
909         paused = true;
910     }
911 }
912 
913 //File: src/contracts/ico/UbiatarPlayVault.sol
914 /**
915  * @title UbiatarPlayVault
916  * @dev A token holder contract that allows the release of tokens to the UbiatarPlay Wallet.
917  *
918  * @version 1.0
919  * @author Validity Labs AG <info@validitylabs.org>
920  */
921 
922 pragma solidity ^0.4.19;
923 
924 
925 
926 
927 
928 
929 
930 contract UbiatarPlayVault {
931     using SafeMath for uint256;
932     using SafeERC20 for UacToken;
933 
934     uint256[6] public vesting_offsets = [
935         90 days,
936         180 days,
937         270 days,
938         360 days,
939         540 days,
940         720 days
941     ];
942 
943     uint256[6] public vesting_amounts = [
944         2e6 * 1e18,
945         4e6 * 1e18,
946         6e6 * 1e18,
947         8e6 * 1e18,
948         10e6 * 1e18,
949         20.5e6 * 1e18
950     ];
951 
952     address public ubiatarPlayWallet;
953     UacToken public token;
954     uint256 public start;
955     uint256 public released;
956 
957     /**
958      * @dev Constructor.
959      * @param _ubiatarPlayWallet The address that will receive the vested tokens.
960      * @param _token The UAC Token, which is being vested.
961      * @param _start The start time from which each release time will be calculated.
962      */
963     function UbiatarPlayVault(
964         address _ubiatarPlayWallet,
965         address _token,
966         uint256 _start
967     )
968         public
969     {
970         ubiatarPlayWallet = _ubiatarPlayWallet;
971         token = UacToken(_token);
972         start = _start;
973     }
974 
975     /**
976      * @dev Transfers vested tokens to ubiatarPlayWallet.
977      */
978     function release() public {
979         uint256 unreleased = releasableAmount();
980         require(unreleased > 0);
981 
982         released = released.add(unreleased);
983 
984         token.safeTransfer(ubiatarPlayWallet, unreleased);
985     }
986 
987     /**
988      * @dev Calculates the amount that has already vested but hasn't been released yet.
989      */
990     function releasableAmount() public view returns (uint256) {
991         return vestedAmount().sub(released);
992     }
993 
994     /**
995      * @dev Calculates the amount that has already vested.
996      */
997     function vestedAmount() public view returns (uint256) {
998         uint256 vested = 0;
999 
1000         for (uint256 i = 0; i < vesting_offsets.length; i = i.add(1)) {
1001             if (block.timestamp > start.add(vesting_offsets[i])) {
1002                 vested = vested.add(vesting_amounts[i]);
1003             }
1004         }
1005 
1006         return vested;
1007     }
1008 }
1009 
1010 
1011 
1012 //File: src/contracts/ico/PresaleTokenVault.sol
1013 /**
1014  * @title PresaleTokenVault
1015  * @dev A token holder contract that allows multiple beneficiaries to extract their tokens after a given release time.
1016  *
1017  * @version 1.0
1018  * @author Validity Labs AG <info@validitylabs.org>
1019  */
1020 pragma solidity ^0.4.17;
1021 
1022 
1023 
1024 
1025 
1026 
1027 
1028 contract PresaleTokenVault {
1029     using SafeMath for uint256;
1030     using SafeERC20 for ERC20Basic;
1031 
1032     /*** CONSTANTS ***/
1033     uint256 public constant VESTING_OFFSET = 90 days;                   // starting of vesting
1034     uint256 public constant VESTING_DURATION = 180 days;                // duration of vesting
1035 
1036     uint256 public start;
1037     uint256 public cliff;
1038     uint256 public end;
1039 
1040     ERC20Basic public token;
1041 
1042     struct Investment {
1043         address beneficiary;
1044         uint256 totalBalance;
1045         uint256 released;
1046     }
1047 
1048     Investment[] public investments;
1049 
1050     // key: investor address; value: index in investments array.
1051     mapping(address => uint256) public investorLUT;
1052 
1053     function init(address[] beneficiaries, uint256[] balances, uint256 startTime, address _token) public {
1054         // makes sure this function is only called once
1055         require(token == address(0));
1056         require(beneficiaries.length == balances.length);
1057 
1058         start = startTime;
1059         cliff = start.add(VESTING_OFFSET);
1060         end = cliff.add(VESTING_DURATION);
1061 
1062         token = ERC20Basic(_token);
1063 
1064         for (uint256 i = 0; i < beneficiaries.length; i = i.add(1)) {
1065             investorLUT[beneficiaries[i]] = investments.length;
1066             investments.push(Investment(beneficiaries[i], balances[i], 0));
1067         }
1068     }
1069 
1070     /**
1071      * @dev Allows a sender to transfer vested tokens to the beneficiary's address.
1072      * @param beneficiary The address that will receive the vested tokens.
1073      */
1074     function release(address beneficiary) public {
1075         uint256 unreleased = releasableAmount(beneficiary);
1076         require(unreleased > 0);
1077 
1078         uint256 investmentIndex = investorLUT[beneficiary];
1079         investments[investmentIndex].released = investments[investmentIndex].released.add(unreleased);
1080         token.safeTransfer(beneficiary, unreleased);
1081     }
1082 
1083     /**
1084      * @dev Transfers vested tokens to the sender's address.
1085      */
1086     function release() public {
1087         release(msg.sender);
1088     }
1089 
1090     /**
1091      * @dev Calculates the amount that has already vested but hasn't been released yet.
1092      * @param beneficiary The address that will receive the vested tokens.
1093      */
1094     function releasableAmount(address beneficiary) public view returns (uint256) {
1095         uint256 investmentIndex = investorLUT[beneficiary];
1096 
1097         return vestedAmount(beneficiary).sub(investments[investmentIndex].released);
1098     }
1099 
1100     /**
1101      * @dev Calculates the amount that has already vested.
1102      * @param beneficiary The address that will receive the vested tokens.
1103      */
1104     function vestedAmount(address beneficiary) public view returns (uint256) {
1105 
1106         uint256 investmentIndex = investorLUT[beneficiary];
1107 
1108         uint256 vested = 0;
1109 
1110         if (block.timestamp >= start) {
1111             // after start -> 1/3 released (fixed)
1112             vested = investments[investmentIndex].totalBalance.div(3);
1113         }
1114         if (block.timestamp >= cliff && block.timestamp < end) {
1115             // after cliff -> linear vesting over time
1116             uint256 p1 = investments[investmentIndex].totalBalance.div(3);
1117             uint256 p2 = investments[investmentIndex].totalBalance;
1118 
1119             /*
1120               released amount:  r
1121               1/3:              p1
1122               all:              p2
1123               current time:     t
1124               cliff:            c
1125               end:              e
1126 
1127               r = p1 +  / d_time * time
1128                 = p1 + (p2-p1) / (e-c) * (t-c)
1129             */
1130             uint256 d_token = p2.sub(p1);
1131             uint256 time = block.timestamp.sub(cliff);
1132             uint256 d_time = end.sub(cliff);
1133 
1134             vested = vested.add(d_token.mul(time).div(d_time));
1135         }
1136         if (block.timestamp >= end) {
1137             // after end -> all vested
1138             vested = investments[investmentIndex].totalBalance;
1139         }
1140         return vested;
1141     }
1142 }
1143 
1144 //File: src/contracts/ico/UacCrowdsale.sol
1145 /**
1146  * @title UacCrowdsale
1147  *
1148  * @version 1.0
1149  * @author Validity Labs AG <info@validitylabs.org>
1150  */
1151 pragma solidity ^0.4.19;
1152 
1153 
1154 
1155 
1156 
1157 
1158 
1159 
1160 
1161 contract UacCrowdsale is CrowdsaleBase {
1162 
1163     /*** CONSTANTS ***/
1164     uint256 public constant START_TIME = 1525856400;                     // 9 May 2018 09:00:00 GMT
1165     uint256 public constant END_TIME = 1528448400;                       // 8 June 2018 09:00:00 GMT
1166     uint256 public constant PRESALE_VAULT_START = END_TIME + 7 days;
1167     uint256 public constant PRESALE_CAP = 17584778551358900100698693;
1168     uint256 public constant TOTAL_MAX_CAP = 15e6 * 1e18;                // Reservation plus main sale tokens
1169     uint256 public constant CROWDSALE_CAP = 7.5e6 * 1e18;
1170     uint256 public constant FOUNDERS_CAP = 12e6 * 1e18;
1171     uint256 public constant UBIATARPLAY_CAP = 50.5e6 * 1e18;
1172     uint256 public constant ADVISORS_CAP = 4915221448641099899301307;
1173 
1174     // Eidoo interface requires price as tokens/ether, therefore the discounts are presented as bonus tokens.
1175     uint256 public constant BONUS_TIER1 = 108;                           // 8% during first 3 hours
1176     uint256 public constant BONUS_TIER2 = 106;                           // 6% during next 9 hours
1177     uint256 public constant BONUS_TIER3 = 104;                           // 4% during next 30 hours
1178     uint256 public constant BONUS_DURATION_1 = 3 hours;
1179     uint256 public constant BONUS_DURATION_2 = 12 hours;
1180     uint256 public constant BONUS_DURATION_3 = 42 hours;
1181 
1182     uint256 public constant FOUNDERS_VESTING_CLIFF = 1 years;
1183     uint256 public constant FOUNDERS_VESTING_DURATION = 2 years;
1184 
1185     Reservation public reservation;
1186 
1187     // Vesting contracts.
1188     PresaleTokenVault public presaleTokenVault;
1189     TokenVesting public foundersVault;
1190     UbiatarPlayVault public ubiatarPlayVault;
1191 
1192     // Vesting wallets.
1193     address public foundersWallet;
1194     address public advisorsWallet;
1195     address public ubiatarPlayWallet;
1196 
1197     address public wallet;
1198 
1199     UacToken public token;
1200 
1201     // Lets owner manually end crowdsale.
1202     bool public didOwnerEndCrowdsale;
1203 
1204     /**
1205      * @dev Constructor.
1206      * @param _foundersWallet address Wallet holding founders tokens.
1207      * @param _advisorsWallet address Wallet holding advisors tokens.
1208      * @param _ubiatarPlayWallet address Wallet holding ubiatarPlay tokens.
1209      * @param _wallet The address where funds should be transferred.
1210      * @param _kycSigners Array of the signers addresses required by the KYCBase constructor, provided by Eidoo.
1211      * See https://github.com/eidoo/icoengine
1212      */
1213     function UacCrowdsale(
1214         address _token,
1215         address _reservation,
1216         address _presaleTokenVault,
1217         address _foundersWallet,
1218         address _advisorsWallet,
1219         address _ubiatarPlayWallet,
1220         address _wallet,
1221         address[] _kycSigners
1222     )
1223         public
1224         CrowdsaleBase(START_TIME, END_TIME, TOTAL_MAX_CAP, _wallet, _kycSigners)
1225     {
1226         token = UacToken(_token);
1227         reservation = Reservation(_reservation);
1228         presaleTokenVault = PresaleTokenVault(_presaleTokenVault);
1229         foundersWallet = _foundersWallet;
1230         advisorsWallet = _advisorsWallet;
1231         ubiatarPlayWallet = _ubiatarPlayWallet;
1232         wallet = _wallet;
1233         // Create founders vault contract
1234         foundersVault = new TokenVesting(foundersWallet, END_TIME, FOUNDERS_VESTING_CLIFF, FOUNDERS_VESTING_DURATION, false);
1235 
1236         // Create Ubiatar Play vault contract
1237         ubiatarPlayVault = new UbiatarPlayVault(ubiatarPlayWallet, address(token), END_TIME);
1238     }
1239 
1240     function mintPreAllocatedTokens() public onlyOwner {
1241         mintTokens(address(foundersVault), FOUNDERS_CAP);
1242         mintTokens(advisorsWallet, ADVISORS_CAP);
1243         mintTokens(address(ubiatarPlayVault), UBIATARPLAY_CAP);
1244     }
1245 
1246     /**
1247      * @dev Creates the presale vault contract.
1248      * @param beneficiaries Array of the presale investors addresses to whom vested tokens are transferred.
1249      * @param balances Array of token amount per beneficiary.
1250      */
1251     function initPresaleTokenVault(address[] beneficiaries, uint256[] balances) public onlyOwner {
1252         require(beneficiaries.length == balances.length);
1253 
1254         presaleTokenVault.init(beneficiaries, balances, PRESALE_VAULT_START, token);
1255 
1256         uint256 totalPresaleBalance = 0;
1257         uint256 balancesLength = balances.length;
1258         for(uint256 i = 0; i < balancesLength; i++) {
1259             totalPresaleBalance = totalPresaleBalance.add(balances[i]);
1260         }
1261 
1262         mintTokens(presaleTokenVault, totalPresaleBalance);
1263     }
1264 
1265     /**
1266      * @dev Implements the price function from EidooEngineInterface.
1267      * @notice Calculates the price as tokens/ether based on the corresponding bonus bracket.
1268      * @return Price as tokens/ether.
1269      */
1270     function price() public view returns (uint256 _price) {
1271         if (block.timestamp <= start.add(BONUS_DURATION_1)) {
1272             return tokenPerEth.mul(BONUS_TIER1).div(1e2);
1273         } else if (block.timestamp <= start.add(BONUS_DURATION_2)) {
1274             return tokenPerEth.mul(BONUS_TIER2).div(1e2);
1275         } else if (block.timestamp <= start.add(BONUS_DURATION_3)) {
1276             return tokenPerEth.mul(BONUS_TIER3).div(1e2);
1277         }
1278         return tokenPerEth;
1279     }
1280 
1281     /**
1282      * @dev Mints tokens being sold during the reservation phase, as part of the implementation of the releaseTokensTo function
1283      * from the KYCBase contract.
1284      * Also, updates tokensSold and availableTokens in the crowdsale contract.
1285      * @param to The address that will receive the minted tokens.
1286      * @param amount The amount of tokens to mint.
1287      */
1288     function mintReservationTokens(address to, uint256 amount) public {
1289         require(msg.sender == address(reservation));
1290         tokensSold = tokensSold.add(amount);
1291         availableTokens = availableTokens.sub(amount);
1292         mintTokens(to, amount);
1293     }
1294 
1295     /**
1296      * @dev Mints tokens being sold during the crowdsale phase as part of the implementation of releaseTokensTo function
1297      * from the KYCBase contract.
1298      * @param to The address that will receive the minted tokens.
1299      * @param amount The amount of tokens to mint.
1300      */
1301     function mintTokens(address to, uint256 amount) private {
1302         token.mint(to, amount);
1303     }
1304 
1305     /**
1306      * @dev Allows the owner to close the crowdsale manually before the end time.
1307      */
1308     function closeCrowdsale() public onlyOwner {
1309         require(block.timestamp >= START_TIME && block.timestamp < END_TIME);
1310         didOwnerEndCrowdsale = true;
1311     }
1312 
1313     /**
1314      * @dev Allows the owner to unpause tokens, stop minting and transfer ownership of the token contract.
1315      */
1316     function finalise() public onlyOwner {
1317         require(didOwnerEndCrowdsale || block.timestamp > end || capReached);
1318         token.finishMinting();
1319         token.unpause();
1320 
1321         // Token contract extends CanReclaimToken so the owner can recover any ERC20 token received in this contract by mistake.
1322         // So far, the owner of the token contract is the crowdsale contract.
1323         // We transfer the ownership so the owner of the crowdsale is also the owner of the token.
1324         token.transferOwnership(owner);
1325     }
1326 }
1327 
1328 
1329 //File: src/contracts/ico/Reservation.sol
1330 /**
1331  * @title Reservation
1332  *
1333  * @version 1.0
1334  * @author Validity Labs AG <info@validitylabs.org>
1335  */
1336 pragma solidity ^0.4.19;
1337 
1338 
1339 
1340 
1341 contract Reservation is CrowdsaleBase {
1342 
1343     /*** CONSTANTS ***/
1344     uint256 public constant START_TIME = 1525683600;                     // 7 May 2018 09:00:00 GMT
1345     uint256 public constant END_TIME = 1525856400;                       // 9 May 2018 09:00:00 GMT
1346     uint256 public constant RESERVATION_CAP = 7.5e6 * 1e18;
1347     uint256 public constant BONUS = 110;                                 // 10% bonus
1348 
1349     UacCrowdsale public crowdsale;
1350 
1351     /**
1352      * @dev Constructor.
1353      * @notice Unsold tokens should add up to the crowdsale hard cap.
1354      * @param _wallet The address where funds should be transferred.
1355      * @param _kycSigners Array of the signers addresses required by the KYCBase constructor, provided by Eidoo.
1356      * See https://github.com/eidoo/icoengine
1357      */
1358     function Reservation(
1359         address _wallet,
1360         address[] _kycSigners
1361     )
1362         public
1363         CrowdsaleBase(START_TIME, END_TIME, RESERVATION_CAP, _wallet, _kycSigners)
1364     {
1365     }
1366 
1367     function setCrowdsale(address _crowdsale) public {
1368         require(crowdsale == address(0));
1369         crowdsale = UacCrowdsale(_crowdsale);
1370     }
1371 
1372     /**
1373      * @dev Implements the price function from EidooEngineInterface.
1374      * @notice Calculates the price as tokens/ether based on the corresponding bonus.
1375      * @return Price as tokens/ether.
1376      */
1377     function price() public view returns (uint256) {
1378         return tokenPerEth.mul(BONUS).div(1e2);
1379     }
1380 
1381     /**
1382      * @dev Fires the mintReservationTokens function on the crowdsale contract to mint the tokens being sold during the reservation phase.
1383      * This function is called by the releaseTokensTo function, as part of the KYCBase implementation.
1384      * @param to The address that will receive the minted tokens.
1385      * @param amount The amount of tokens to mint.
1386      */
1387     function mintTokens(address to, uint256 amount) private {
1388         crowdsale.mintReservationTokens(to, amount);
1389     }
1390 }