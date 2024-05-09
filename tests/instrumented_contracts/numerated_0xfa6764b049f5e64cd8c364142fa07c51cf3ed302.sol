1 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 pragma solidity ^0.4.18;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 pragma solidity ^0.4.18;
19 
20 
21 
22 
23 /**
24  * @title ERC20 interface
25  * @dev see https://github.com/ethereum/EIPs/issues/20
26  */
27 contract ERC20 is ERC20Basic {
28   function allowance(address owner, address spender) public view returns (uint256);
29   function transferFrom(address from, address to, uint256 value) public returns (bool);
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
35 pragma solidity ^0.4.18;
36 
37 
38 
39 
40 
41 /**
42  * @title SafeERC20
43  * @dev Wrappers around ERC20 operations that throw on failure.
44  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
45  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
46  */
47 library SafeERC20 {
48   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
49     assert(token.transfer(to, value));
50   }
51 
52   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
53     assert(token.transferFrom(from, to, value));
54   }
55 
56   function safeApprove(ERC20 token, address spender, uint256 value) internal {
57     assert(token.approve(spender, value));
58   }
59 }
60 
61 //File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
62 pragma solidity ^0.4.18;
63 
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71   address public owner;
72 
73 
74   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76 
77   /**
78    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79    * account.
80    */
81   function Ownable() public {
82     owner = msg.sender;
83   }
84 
85   /**
86    * @dev Throws if called by any account other than the owner.
87    */
88   modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address newOwner) public onlyOwner {
98     require(newOwner != address(0));
99     OwnershipTransferred(owner, newOwner);
100     owner = newOwner;
101   }
102 
103 }
104 
105 //File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
106 pragma solidity ^0.4.18;
107 
108 
109 /**
110  * @title SafeMath
111  * @dev Math operations with safety checks that throw on error
112  */
113 library SafeMath {
114 
115   /**
116   * @dev Multiplies two numbers, throws on overflow.
117   */
118   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119     if (a == 0) {
120       return 0;
121     }
122     uint256 c = a * b;
123     assert(c / a == b);
124     return c;
125   }
126 
127   /**
128   * @dev Integer division of two numbers, truncating the quotient.
129   */
130   function div(uint256 a, uint256 b) internal pure returns (uint256) {
131     // assert(b > 0); // Solidity automatically throws when dividing by 0
132     uint256 c = a / b;
133     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134     return c;
135   }
136 
137   /**
138   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
139   */
140   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141     assert(b <= a);
142     return a - b;
143   }
144 
145   /**
146   * @dev Adds two numbers, throws on overflow.
147   */
148   function add(uint256 a, uint256 b) internal pure returns (uint256) {
149     uint256 c = a + b;
150     assert(c >= a);
151     return c;
152   }
153 }
154 
155 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
156 pragma solidity ^0.4.18;
157 
158 
159 
160 
161 
162 
163 
164 /**
165  * @title TokenVesting
166  * @dev A token holder contract that can release its token balance gradually like a
167  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
168  * owner.
169  */
170 contract TokenVesting is Ownable {
171   using SafeMath for uint256;
172   using SafeERC20 for ERC20Basic;
173 
174   event Released(uint256 amount);
175   event Revoked();
176 
177   // beneficiary of tokens after they are released
178   address public beneficiary;
179 
180   uint256 public cliff;
181   uint256 public start;
182   uint256 public duration;
183 
184   bool public revocable;
185 
186   mapping (address => uint256) public released;
187   mapping (address => bool) public revoked;
188 
189   /**
190    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
191    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
192    * of the balance will have vested.
193    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
194    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
195    * @param _duration duration in seconds of the period in which the tokens will vest
196    * @param _revocable whether the vesting is revocable or not
197    */
198   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
199     require(_beneficiary != address(0));
200     require(_cliff <= _duration);
201 
202     beneficiary = _beneficiary;
203     revocable = _revocable;
204     duration = _duration;
205     cliff = _start.add(_cliff);
206     start = _start;
207   }
208 
209   /**
210    * @notice Transfers vested tokens to beneficiary.
211    * @param token ERC20 token which is being vested
212    */
213   function release(ERC20Basic token) public {
214     uint256 unreleased = releasableAmount(token);
215 
216     require(unreleased > 0);
217 
218     released[token] = released[token].add(unreleased);
219 
220     token.safeTransfer(beneficiary, unreleased);
221 
222     Released(unreleased);
223   }
224 
225   /**
226    * @notice Allows the owner to revoke the vesting. Tokens already vested
227    * remain in the contract, the rest are returned to the owner.
228    * @param token ERC20 token which is being vested
229    */
230   function revoke(ERC20Basic token) public onlyOwner {
231     require(revocable);
232     require(!revoked[token]);
233 
234     uint256 balance = token.balanceOf(this);
235 
236     uint256 unreleased = releasableAmount(token);
237     uint256 refund = balance.sub(unreleased);
238 
239     revoked[token] = true;
240 
241     token.safeTransfer(owner, refund);
242 
243     Revoked();
244   }
245 
246   /**
247    * @dev Calculates the amount that has already vested but hasn't been released yet.
248    * @param token ERC20 token which is being vested
249    */
250   function releasableAmount(ERC20Basic token) public view returns (uint256) {
251     return vestedAmount(token).sub(released[token]);
252   }
253 
254   /**
255    * @dev Calculates the amount that has already vested.
256    * @param token ERC20 token which is being vested
257    */
258   function vestedAmount(ERC20Basic token) public view returns (uint256) {
259     uint256 currentBalance = token.balanceOf(this);
260     uint256 totalBalance = currentBalance.add(released[token]);
261 
262     if (now < cliff) {
263       return 0;
264     } else if (now >= start.add(duration) || revoked[token]) {
265       return totalBalance;
266     } else {
267       return totalBalance.mul(now.sub(start)).div(duration);
268     }
269   }
270 }
271 
272 //File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
273 pragma solidity ^0.4.18;
274 
275 
276 
277 
278 
279 /**
280  * @title Pausable
281  * @dev Base contract which allows children to implement an emergency stop mechanism.
282  */
283 contract Pausable is Ownable {
284   event Pause();
285   event Unpause();
286 
287   bool public paused = false;
288 
289 
290   /**
291    * @dev Modifier to make a function callable only when the contract is not paused.
292    */
293   modifier whenNotPaused() {
294     require(!paused);
295     _;
296   }
297 
298   /**
299    * @dev Modifier to make a function callable only when the contract is paused.
300    */
301   modifier whenPaused() {
302     require(paused);
303     _;
304   }
305 
306   /**
307    * @dev called by the owner to pause, triggers stopped state
308    */
309   function pause() onlyOwner whenNotPaused public {
310     paused = true;
311     Pause();
312   }
313 
314   /**
315    * @dev called by the owner to unpause, returns to normal state
316    */
317   function unpause() onlyOwner whenPaused public {
318     paused = false;
319     Unpause();
320   }
321 }
322 
323 //File: node_modules/zeppelin-solidity/contracts/ownership/CanReclaimToken.sol
324 pragma solidity ^0.4.18;
325 
326 
327 
328 
329 
330 
331 /**
332  * @title Contracts that should be able to recover tokens
333  * @author SylTi
334  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
335  * This will prevent any accidental loss of tokens.
336  */
337 contract CanReclaimToken is Ownable {
338   using SafeERC20 for ERC20Basic;
339 
340   /**
341    * @dev Reclaim all ERC20Basic compatible tokens
342    * @param token ERC20Basic The address of the token contract
343    */
344   function reclaimToken(ERC20Basic token) external onlyOwner {
345     uint256 balance = token.balanceOf(this);
346     token.safeTransfer(owner, balance);
347   }
348 
349 }
350 
351 //File: src/contracts/ico/KYCBase.sol
352 pragma solidity ^0.4.19;
353 
354 
355 
356 
357 // Abstract base contract
358 contract KYCBase {
359     using SafeMath for uint256;
360 
361     mapping (address => bool) public isKycSigner;
362     mapping (uint64 => uint256) public alreadyPayed;
363 
364     event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);
365 
366     function KYCBase(address [] kycSigners) internal {
367         for (uint i = 0; i < kycSigners.length; i++) {
368             isKycSigner[kycSigners[i]] = true;
369         }
370     }
371 
372     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
373     function releaseTokensTo(address buyer) internal returns(bool);
374 
375     // This method can be overridden to enable some sender to buy token for a different address
376     function senderAllowedFor(address buyer)
377         internal view returns(bool)
378     {
379         return buyer == msg.sender;
380     }
381 
382     function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
383         public payable returns (bool)
384     {
385         require(senderAllowedFor(buyerAddress));
386         return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);
387     }
388 
389     function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
390         public payable returns (bool)
391     {
392         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
393     }
394 
395     function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
396         private returns (bool)
397     {
398         // check the signature
399         bytes32 hash = sha256("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount);
400         address signer = ecrecover(hash, v, r, s);
401         if (!isKycSigner[signer]) {
402             revert();
403         } else {
404             uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);
405             require(totalPayed <= maxAmount);
406             alreadyPayed[buyerId] = totalPayed;
407             KycVerified(signer, buyerAddress, buyerId, maxAmount);
408             return releaseTokensTo(buyerAddress);
409         }
410         return true;
411     }
412 
413     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
414     function () public {
415         revert();
416     }
417 }
418 //File: src/contracts/ico/ICOEngineInterface.sol
419 pragma solidity ^0.4.19;
420 
421 
422 contract ICOEngineInterface {
423 
424     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
425     function started() public view returns(bool);
426 
427     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
428     function ended() public view returns(bool);
429 
430     // time stamp of the starting time of the ico, must return 0 if it depends on the block number
431     function startTime() public view returns(uint);
432 
433     // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
434     function endTime() public view returns(uint);
435 
436     // Optional function, can be implemented in place of startTime
437     // Returns the starting block number of the ico, must return 0 if it depends on the time stamp
438     // function startBlock() public view returns(uint);
439 
440     // Optional function, can be implemented in place of endTime
441     // Returns theending block number of the ico, must retrun 0 if it depends on the time stamp
442     // function endBlock() public view returns(uint);
443 
444     // returns the total number of the tokens available for the sale, must not change when the ico is started
445     function totalTokens() public view returns(uint);
446 
447     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
448     // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
449     function remainingTokens() public view returns(uint);
450 
451     // return the price as number of tokens released for each ether
452     function price() public view returns(uint);
453 }
454 //File: src/contracts/ico/CrowdsaleBase.sol
455 /**
456  * @title CrowdsaleBase
457  * @dev Base crowdsale contract to be inherited by the UacCrowdsale and Reservation contracts.
458  *
459  * @version 1.0
460  * @author Validity Labs AG <info@validitylabs.org>
461  */
462 pragma solidity ^0.4.19;
463 
464 
465 
466 
467 
468 
469 
470 contract CrowdsaleBase is Pausable, CanReclaimToken, ICOEngineInterface, KYCBase {
471 
472     /*** CONSTANTS ***/
473     uint256 public constant USD_PER_TOKEN = 2;                        //
474     uint256 public constant USD_PER_ETHER = 1000;                      // 
475 
476     uint256 public start;                                             // ICOEngineInterface
477     uint256 public end;                                               // ICOEngineInterface
478     uint256 public cap;                                               // ICOEngineInterface
479     address public wallet;
480     uint256 public tokenPerEth;
481     uint256 public availableTokens;                                   // ICOEngineInterface
482     address[] public kycSigners;                                      // KYCBase
483     bool public capReached;
484     uint256 public weiRaised;
485     uint256 public tokensSold;
486 
487     /**
488      * @dev Constructor.
489      * @param _start The start time of the sale.
490      * @param _end The end time of the sale.
491      * @param _cap The maximum amount of tokens to be sold during the sale.
492      * @param _wallet The address where funds should be transferred.
493      * @param _kycSigners Array of the signers addresses required by the KYCBase constructor, provided by Eidoo.
494      * See https://github.com/eidoo/icoengine
495      */
496     function CrowdsaleBase(
497         uint256 _start,
498         uint256 _end,
499         uint256 _cap,
500         address _wallet,
501         address[] _kycSigners
502     )
503         public
504         KYCBase(_kycSigners)
505     {
506         require(_end >= _start);
507         require(_cap > 0);
508 
509         start = _start;
510         end = _end;
511         cap = _cap;
512         wallet = _wallet;
513         tokenPerEth = USD_PER_ETHER.div(USD_PER_TOKEN);
514         availableTokens = _cap;
515         kycSigners = _kycSigners;
516     }
517 
518     /**
519      * @dev Implements the ICOEngineInterface.
520      * @return False if the ico is not started, true if the ico is started and running, true if the ico is completed.
521      */
522     function started() public view returns(bool) {
523         if (block.timestamp >= start) {
524             return true;
525         } else {
526             return false;
527         }
528     }
529 
530     /**
531      * @dev Implements the ICOEngineInterface.
532      * @return False if the ico is not started, false if the ico is started and running, true if the ico is completed.
533      */
534     function ended() public view returns(bool) {
535         if (block.timestamp >= end) {
536             return true;
537         } else {
538             return false;
539         }
540     }
541 
542     /**
543      * @dev Implements the ICOEngineInterface.
544      * @return Timestamp of the ico start time.
545      */
546     function startTime() public view returns(uint) {
547         return start;
548     }
549 
550     /**
551      * @dev Implements the ICOEngineInterface.
552      * @return Timestamp of the ico end time.
553      */
554     function endTime() public view returns(uint) {
555         return end;
556     }
557 
558     /**
559      * @dev Implements the ICOEngineInterface.
560      * @return The total number of the tokens available for the sale, must not change when the ico is started.
561      */
562     function totalTokens() public view returns(uint) {
563         return cap;
564     }
565 
566     /**
567      * @dev Implements the ICOEngineInterface.
568      * @return The number of the tokens available for the ico. At the moment the ico starts it must be equal to totalTokens(),
569      * then it will decrease.
570      */
571     function remainingTokens() public view returns(uint) {
572         return availableTokens;
573     }
574 
575     /**
576      * @dev Implements the KYCBase senderAllowedFor function to enable a sender to buy tokens for a different address.
577      * @return true.
578      */
579     function senderAllowedFor(address buyer) internal view returns(bool) {
580         require(buyer != address(0));
581 
582         return true;
583     }
584 
585     /**
586      * @dev Implements the KYCBase releaseTokensTo function to mint tokens for an investor. Called after the KYC process has passed.
587      * @return A bollean that indicates if the operation was successful.
588      */
589     function releaseTokensTo(address buyer) internal returns(bool) {
590         require(validPurchase());
591 
592         uint256 overflowTokens;
593         uint256 refundWeiAmount;
594 
595         uint256 weiAmount = msg.value;
596         uint256 tokenAmount = weiAmount.mul(price());
597 
598         if (tokenAmount >= availableTokens) {
599             capReached = true;
600             overflowTokens = tokenAmount.sub(availableTokens);
601             tokenAmount = tokenAmount.sub(overflowTokens);
602             refundWeiAmount = overflowTokens.div(price());
603             weiAmount = weiAmount.sub(refundWeiAmount);
604             buyer.transfer(refundWeiAmount);
605         }
606 
607         weiRaised = weiRaised.add(weiAmount);
608         tokensSold = tokensSold.add(tokenAmount);
609         availableTokens = availableTokens.sub(tokenAmount);
610         mintTokens(buyer, tokenAmount);
611         forwardFunds(weiAmount);
612 
613         return true;
614     }
615 
616     /**
617      * @dev Fired by the releaseTokensTo function after minting tokens, to forward the raised wei to the address that collects funds.
618      * @param _weiAmount Amount of wei send by the investor.
619      */
620     function forwardFunds(uint256 _weiAmount) internal {
621         wallet.transfer(_weiAmount);
622     }
623 
624     /**
625      * @dev Validates an incoming purchase. Required statements revert state when conditions are not met.
626      * @return true If the transaction can buy tokens.
627      */
628     function validPurchase() internal view returns (bool) {
629         require(!paused && !capReached);
630         require(block.timestamp >= start && block.timestamp <= end);
631 
632         return true;
633     }
634 
635     /**
636     * @dev Abstract function to mint tokens, to be implemented in the Crowdsale and Reservation contracts.
637     * @param to The address that will receive the minted tokens.
638     * @param amount The amount of tokens to mint.
639     */
640     function mintTokens(address to, uint256 amount) private;
641 }
642 
643 
644 
645 
646 
647 //File: src/contracts/ico/Reservation.sol
648 /**
649  * @title Reservation
650  *
651  * @version 1.0
652  * @author Validity Labs AG <info@validitylabs.org>
653  */
654 pragma solidity ^0.4.19;
655 
656 
657 
658 
659 contract Reservation is CrowdsaleBase {
660 
661     /*** CONSTANTS ***/
662     uint256 public constant START_TIME = 1525683600;                     // 7 May 2018 09:00:00 GMT
663     uint256 public constant END_TIME = 1525856400;                       // 9 May 2018 09:00:00 GMT
664     uint256 public constant RESERVATION_CAP = 7.5e6 * 1e18;
665     uint256 public constant BONUS = 110;                                 // 10% bonus
666 
667     UacCrowdsale public crowdsale;
668 
669     /**
670      * @dev Constructor.
671      * @notice Unsold tokens should add up to the crowdsale hard cap.
672      * @param _wallet The address where funds should be transferred.
673      * @param _kycSigners Array of the signers addresses required by the KYCBase constructor, provided by Eidoo.
674      * See https://github.com/eidoo/icoengine
675      */
676     function Reservation(
677         address _wallet,
678         address[] _kycSigners
679     )
680         public
681         CrowdsaleBase(START_TIME, END_TIME, RESERVATION_CAP, _wallet, _kycSigners)
682     {
683     }
684 
685     function setCrowdsale(address _crowdsale) public {
686         require(crowdsale == address(0));
687         crowdsale = UacCrowdsale(_crowdsale);
688     }
689 
690     /**
691      * @dev Implements the price function from EidooEngineInterface.
692      * @notice Calculates the price as tokens/ether based on the corresponding bonus.
693      * @return Price as tokens/ether.
694      */
695     function price() public view returns (uint256) {
696         return tokenPerEth.mul(BONUS).div(1e2);
697     }
698 
699     /**
700      * @dev Fires the mintReservationTokens function on the crowdsale contract to mint the tokens being sold during the reservation phase.
701      * This function is called by the releaseTokensTo function, as part of the KYCBase implementation.
702      * @param to The address that will receive the minted tokens.
703      * @param amount The amount of tokens to mint.
704      */
705     function mintTokens(address to, uint256 amount) private {
706         crowdsale.mintReservationTokens(to, amount);
707     }
708 }
709 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
710 pragma solidity ^0.4.18;
711 
712 
713 
714 
715 
716 
717 /**
718  * @title Basic token
719  * @dev Basic version of StandardToken, with no allowances.
720  */
721 contract BasicToken is ERC20Basic {
722   using SafeMath for uint256;
723 
724   mapping(address => uint256) balances;
725 
726   uint256 totalSupply_;
727 
728   /**
729   * @dev total number of tokens in existence
730   */
731   function totalSupply() public view returns (uint256) {
732     return totalSupply_;
733   }
734 
735   /**
736   * @dev transfer token for a specified address
737   * @param _to The address to transfer to.
738   * @param _value The amount to be transferred.
739   */
740   function transfer(address _to, uint256 _value) public returns (bool) {
741     require(_to != address(0));
742     require(_value <= balances[msg.sender]);
743 
744     // SafeMath.sub will throw if there is not enough balance.
745     balances[msg.sender] = balances[msg.sender].sub(_value);
746     balances[_to] = balances[_to].add(_value);
747     Transfer(msg.sender, _to, _value);
748     return true;
749   }
750 
751   /**
752   * @dev Gets the balance of the specified address.
753   * @param _owner The address to query the the balance of.
754   * @return An uint256 representing the amount owned by the passed address.
755   */
756   function balanceOf(address _owner) public view returns (uint256 balance) {
757     return balances[_owner];
758   }
759 
760 }
761 
762 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
763 pragma solidity ^0.4.18;
764 
765 
766 
767 
768 
769 /**
770  * @title Standard ERC20 token
771  *
772  * @dev Implementation of the basic standard token.
773  * @dev https://github.com/ethereum/EIPs/issues/20
774  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
775  */
776 contract StandardToken is ERC20, BasicToken {
777 
778   mapping (address => mapping (address => uint256)) internal allowed;
779 
780 
781   /**
782    * @dev Transfer tokens from one address to another
783    * @param _from address The address which you want to send tokens from
784    * @param _to address The address which you want to transfer to
785    * @param _value uint256 the amount of tokens to be transferred
786    */
787   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
788     require(_to != address(0));
789     require(_value <= balances[_from]);
790     require(_value <= allowed[_from][msg.sender]);
791 
792     balances[_from] = balances[_from].sub(_value);
793     balances[_to] = balances[_to].add(_value);
794     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
795     Transfer(_from, _to, _value);
796     return true;
797   }
798 
799   /**
800    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
801    *
802    * Beware that changing an allowance with this method brings the risk that someone may use both the old
803    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
804    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
805    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
806    * @param _spender The address which will spend the funds.
807    * @param _value The amount of tokens to be spent.
808    */
809   function approve(address _spender, uint256 _value) public returns (bool) {
810     allowed[msg.sender][_spender] = _value;
811     Approval(msg.sender, _spender, _value);
812     return true;
813   }
814 
815   /**
816    * @dev Function to check the amount of tokens that an owner allowed to a spender.
817    * @param _owner address The address which owns the funds.
818    * @param _spender address The address which will spend the funds.
819    * @return A uint256 specifying the amount of tokens still available for the spender.
820    */
821   function allowance(address _owner, address _spender) public view returns (uint256) {
822     return allowed[_owner][_spender];
823   }
824 
825   /**
826    * @dev Increase the amount of tokens that an owner allowed to a spender.
827    *
828    * approve should be called when allowed[_spender] == 0. To increment
829    * allowed value is better to use this function to avoid 2 calls (and wait until
830    * the first transaction is mined)
831    * From MonolithDAO Token.sol
832    * @param _spender The address which will spend the funds.
833    * @param _addedValue The amount of tokens to increase the allowance by.
834    */
835   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
836     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
837     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
838     return true;
839   }
840 
841   /**
842    * @dev Decrease the amount of tokens that an owner allowed to a spender.
843    *
844    * approve should be called when allowed[_spender] == 0. To decrement
845    * allowed value is better to use this function to avoid 2 calls (and wait until
846    * the first transaction is mined)
847    * From MonolithDAO Token.sol
848    * @param _spender The address which will spend the funds.
849    * @param _subtractedValue The amount of tokens to decrease the allowance by.
850    */
851   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
852     uint oldValue = allowed[msg.sender][_spender];
853     if (_subtractedValue > oldValue) {
854       allowed[msg.sender][_spender] = 0;
855     } else {
856       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
857     }
858     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
859     return true;
860   }
861 
862 }
863 
864 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
865 pragma solidity ^0.4.18;
866 
867 
868 
869 
870 
871 /**
872  * @title Mintable token
873  * @dev Simple ERC20 Token example, with mintable token creation
874  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
875  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
876  */
877 contract MintableToken is StandardToken, Ownable {
878   event Mint(address indexed to, uint256 amount);
879   event MintFinished();
880 
881   bool public mintingFinished = false;
882 
883 
884   modifier canMint() {
885     require(!mintingFinished);
886     _;
887   }
888 
889   /**
890    * @dev Function to mint tokens
891    * @param _to The address that will receive the minted tokens.
892    * @param _amount The amount of tokens to mint.
893    * @return A boolean that indicates if the operation was successful.
894    */
895   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
896     totalSupply_ = totalSupply_.add(_amount);
897     balances[_to] = balances[_to].add(_amount);
898     Mint(_to, _amount);
899     Transfer(address(0), _to, _amount);
900     return true;
901   }
902 
903   /**
904    * @dev Function to stop minting new tokens.
905    * @return True if the operation was successful.
906    */
907   function finishMinting() onlyOwner canMint public returns (bool) {
908     mintingFinished = true;
909     MintFinished();
910     return true;
911   }
912 }
913 
914 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
915 pragma solidity ^0.4.18;
916 
917 
918 
919 
920 
921 /**
922  * @title Pausable token
923  * @dev StandardToken modified with pausable transfers.
924  **/
925 contract PausableToken is StandardToken, Pausable {
926 
927   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
928     return super.transfer(_to, _value);
929   }
930 
931   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
932     return super.transferFrom(_from, _to, _value);
933   }
934 
935   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
936     return super.approve(_spender, _value);
937   }
938 
939   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
940     return super.increaseApproval(_spender, _addedValue);
941   }
942 
943   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
944     return super.decreaseApproval(_spender, _subtractedValue);
945   }
946 }
947 
948 //File: src/contracts/ico/UacToken.sol
949 /**
950  * @title Ubiatar Coin token
951  *
952  * @version 1.0
953  * @author Validity Labs AG <info@validitylabs.org>
954  */
955 pragma solidity ^0.4.19;
956 
957 
958 
959 
960 
961 contract UacToken is CanReclaimToken, MintableToken, PausableToken {
962     string public constant name = "Ubiatar Coin";
963     string public constant symbol = "UAC";
964     uint8 public constant decimals = 18;
965 
966     /**
967      * @dev Constructor of UacToken that instantiates a new Mintable Pausable Token
968      */
969     function UacToken() public {
970         // token should not be transferrable until after all tokens have been issued
971         paused = true;
972     }
973 }
974 
975 //File: src/contracts/ico/UbiatarPlayVault.sol
976 /**
977  * @title UbiatarPlayVault
978  * @dev A token holder contract that allows the release of tokens to the UbiatarPlay Wallet.
979  *
980  * @version 1.0
981  * @author Validity Labs AG <info@validitylabs.org>
982  */
983 
984 pragma solidity ^0.4.19;
985 
986 
987 
988 
989 
990 
991 
992 contract UbiatarPlayVault {
993     using SafeMath for uint256;
994     using SafeERC20 for UacToken;
995 
996     uint256[6] public vesting_offsets = [
997         90 days,
998         180 days,
999         270 days,
1000         360 days,
1001         540 days,
1002         720 days
1003     ];
1004 
1005     uint256[6] public vesting_amounts = [
1006         2e6 * 1e18,
1007         4e6 * 1e18,
1008         6e6 * 1e18,
1009         8e6 * 1e18,
1010         10e6 * 1e18,
1011         20.5e6 * 1e18
1012     ];
1013 
1014     address public ubiatarPlayWallet;
1015     UacToken public token;
1016     uint256 public start;
1017     uint256 public released;
1018 
1019     /**
1020      * @dev Constructor.
1021      * @param _ubiatarPlayWallet The address that will receive the vested tokens.
1022      * @param _token The UAC Token, which is being vested.
1023      * @param _start The start time from which each release time will be calculated.
1024      */
1025     function UbiatarPlayVault(
1026         address _ubiatarPlayWallet,
1027         address _token,
1028         uint256 _start
1029     )
1030         public
1031     {
1032         ubiatarPlayWallet = _ubiatarPlayWallet;
1033         token = UacToken(_token);
1034         start = _start;
1035     }
1036 
1037     /**
1038      * @dev Transfers vested tokens to ubiatarPlayWallet.
1039      */
1040     function release() public {
1041         uint256 unreleased = releasableAmount();
1042         require(unreleased > 0);
1043 
1044         released = released.add(unreleased);
1045 
1046         token.safeTransfer(ubiatarPlayWallet, unreleased);
1047     }
1048 
1049     /**
1050      * @dev Calculates the amount that has already vested but hasn't been released yet.
1051      */
1052     function releasableAmount() public view returns (uint256) {
1053         return vestedAmount().sub(released);
1054     }
1055 
1056     /**
1057      * @dev Calculates the amount that has already vested.
1058      */
1059     function vestedAmount() public view returns (uint256) {
1060         uint256 vested = 0;
1061 
1062         for (uint256 i = 0; i < vesting_offsets.length; i = i.add(1)) {
1063             if (block.timestamp > start.add(vesting_offsets[i])) {
1064                 vested = vested.add(vesting_amounts[i]);
1065             }
1066         }
1067 
1068         return vested;
1069     }
1070 }
1071 
1072 
1073 
1074 //File: src/contracts/ico/PresaleTokenVault.sol
1075 /**
1076  * @title PresaleTokenVault
1077  * @dev A token holder contract that allows multiple beneficiaries to extract their tokens after a given release time.
1078  *
1079  * @version 1.0
1080  * @author Validity Labs AG <info@validitylabs.org>
1081  */
1082 pragma solidity ^0.4.17;
1083 
1084 
1085 
1086 
1087 
1088 
1089 
1090 contract PresaleTokenVault {
1091     using SafeMath for uint256;
1092     using SafeERC20 for ERC20Basic;
1093 
1094     /*** CONSTANTS ***/
1095     uint256 public constant VESTING_OFFSET = 90 days;                   // starting of vesting
1096     uint256 public constant VESTING_DURATION = 180 days;                // duration of vesting
1097 
1098     uint256 public start;
1099     uint256 public cliff;
1100     uint256 public end;
1101 
1102     ERC20Basic public token;
1103 
1104     struct Investment {
1105         address beneficiary;
1106         uint256 totalBalance;
1107         uint256 released;
1108     }
1109 
1110     Investment[] public investments;
1111 
1112     // key: investor address; value: index in investments array.
1113     mapping(address => uint256) public investorLUT;
1114 
1115     function init(address[] beneficiaries, uint256[] balances, uint256 startTime, address _token) public {
1116         // makes sure this function is only called once
1117         require(token == address(0));
1118         require(beneficiaries.length == balances.length);
1119 
1120         start = startTime;
1121         cliff = start.add(VESTING_OFFSET);
1122         end = cliff.add(VESTING_DURATION);
1123 
1124         token = ERC20Basic(_token);
1125 
1126         for (uint256 i = 0; i < beneficiaries.length; i = i.add(1)) {
1127             investorLUT[beneficiaries[i]] = investments.length;
1128             investments.push(Investment(beneficiaries[i], balances[i], 0));
1129         }
1130     }
1131 
1132     /**
1133      * @dev Allows a sender to transfer vested tokens to the beneficiary's address.
1134      * @param beneficiary The address that will receive the vested tokens.
1135      */
1136     function release(address beneficiary) public {
1137         uint256 unreleased = releasableAmount(beneficiary);
1138         require(unreleased > 0);
1139 
1140         uint256 investmentIndex = investorLUT[beneficiary];
1141         investments[investmentIndex].released = investments[investmentIndex].released.add(unreleased);
1142         token.safeTransfer(beneficiary, unreleased);
1143     }
1144 
1145     /**
1146      * @dev Transfers vested tokens to the sender's address.
1147      */
1148     function release() public {
1149         release(msg.sender);
1150     }
1151 
1152     /**
1153      * @dev Calculates the amount that has already vested but hasn't been released yet.
1154      * @param beneficiary The address that will receive the vested tokens.
1155      */
1156     function releasableAmount(address beneficiary) public view returns (uint256) {
1157         uint256 investmentIndex = investorLUT[beneficiary];
1158 
1159         return vestedAmount(beneficiary).sub(investments[investmentIndex].released);
1160     }
1161 
1162     /**
1163      * @dev Calculates the amount that has already vested.
1164      * @param beneficiary The address that will receive the vested tokens.
1165      */
1166     function vestedAmount(address beneficiary) public view returns (uint256) {
1167 
1168         uint256 investmentIndex = investorLUT[beneficiary];
1169 
1170         uint256 vested = 0;
1171 
1172         if (block.timestamp >= start) {
1173             // after start -> 1/3 released (fixed)
1174             vested = investments[investmentIndex].totalBalance.div(3);
1175         }
1176         if (block.timestamp >= cliff && block.timestamp < end) {
1177             // after cliff -> linear vesting over time
1178             uint256 p1 = investments[investmentIndex].totalBalance.div(3);
1179             uint256 p2 = investments[investmentIndex].totalBalance;
1180 
1181             /*
1182               released amount:  r
1183               1/3:              p1
1184               all:              p2
1185               current time:     t
1186               cliff:            c
1187               end:              e
1188 
1189               r = p1 +  / d_time * time
1190                 = p1 + (p2-p1) / (e-c) * (t-c)
1191             */
1192             uint256 d_token = p2.sub(p1);
1193             uint256 time = block.timestamp.sub(cliff);
1194             uint256 d_time = end.sub(cliff);
1195 
1196             vested = vested.add(d_token.mul(time).div(d_time));
1197         }
1198         if (block.timestamp >= end) {
1199             // after end -> all vested
1200             vested = investments[investmentIndex].totalBalance;
1201         }
1202         return vested;
1203     }
1204 }
1205 
1206 //File: src/contracts/ico/UacCrowdsale.sol
1207 /**
1208  * @title UacCrowdsale
1209  *
1210  * @version 1.0
1211  * @author Validity Labs AG <info@validitylabs.org>
1212  */
1213 pragma solidity ^0.4.19;
1214 
1215 
1216 
1217 
1218 
1219 
1220 
1221 
1222 
1223 contract UacCrowdsale is CrowdsaleBase {
1224 
1225     /*** CONSTANTS ***/
1226     uint256 public constant START_TIME = 1525856400;                     // 9 May 2018 09:00:00 GMT
1227     uint256 public constant END_TIME = 1528448400;                       // 8 June 2018 09:00:00 GMT
1228     uint256 public constant PRESALE_VAULT_START = END_TIME + 7 days;
1229     uint256 public constant PRESALE_CAP = 17584778551358900100698693;
1230     uint256 public constant TOTAL_MAX_CAP = 15e6 * 1e18;                // Reservation plus main sale tokens
1231     uint256 public constant CROWDSALE_CAP = 7.5e6 * 1e18;
1232     uint256 public constant FOUNDERS_CAP = 12e6 * 1e18;
1233     uint256 public constant UBIATARPLAY_CAP = 50.5e6 * 1e18;
1234     uint256 public constant ADVISORS_CAP = 4915221448641099899301307;
1235 
1236     // Eidoo interface requires price as tokens/ether, therefore the discounts are presented as bonus tokens.
1237     uint256 public constant BONUS_TIER1 = 108;                           // 8% during first 3 hours
1238     uint256 public constant BONUS_TIER2 = 106;                           // 6% during next 9 hours
1239     uint256 public constant BONUS_TIER3 = 104;                           // 4% during next 30 hours
1240     uint256 public constant BONUS_DURATION_1 = 3 hours;
1241     uint256 public constant BONUS_DURATION_2 = 12 hours;
1242     uint256 public constant BONUS_DURATION_3 = 42 hours;
1243 
1244     uint256 public constant FOUNDERS_VESTING_CLIFF = 1 years;
1245     uint256 public constant FOUNDERS_VESTING_DURATION = 2 years;
1246 
1247     Reservation public reservation;
1248 
1249     // Vesting contracts.
1250     PresaleTokenVault public presaleTokenVault;
1251     TokenVesting public foundersVault;
1252     UbiatarPlayVault public ubiatarPlayVault;
1253 
1254     // Vesting wallets.
1255     address public foundersWallet;
1256     address public advisorsWallet;
1257     address public ubiatarPlayWallet;
1258 
1259     address public wallet;
1260 
1261     UacToken public token;
1262 
1263     // Lets owner manually end crowdsale.
1264     bool public didOwnerEndCrowdsale;
1265 
1266     /**
1267      * @dev Constructor.
1268      * @param _foundersWallet address Wallet holding founders tokens.
1269      * @param _advisorsWallet address Wallet holding advisors tokens.
1270      * @param _ubiatarPlayWallet address Wallet holding ubiatarPlay tokens.
1271      * @param _wallet The address where funds should be transferred.
1272      * @param _kycSigners Array of the signers addresses required by the KYCBase constructor, provided by Eidoo.
1273      * See https://github.com/eidoo/icoengine
1274      */
1275     function UacCrowdsale(
1276         address _token,
1277         address _reservation,
1278         address _presaleTokenVault,
1279         address _foundersWallet,
1280         address _advisorsWallet,
1281         address _ubiatarPlayWallet,
1282         address _wallet,
1283         address[] _kycSigners
1284     )
1285         public
1286         CrowdsaleBase(START_TIME, END_TIME, TOTAL_MAX_CAP, _wallet, _kycSigners)
1287     {
1288         token = UacToken(_token);
1289         reservation = Reservation(_reservation);
1290         presaleTokenVault = PresaleTokenVault(_presaleTokenVault);
1291         foundersWallet = _foundersWallet;
1292         advisorsWallet = _advisorsWallet;
1293         ubiatarPlayWallet = _ubiatarPlayWallet;
1294         wallet = _wallet;
1295         // Create founders vault contract
1296         foundersVault = new TokenVesting(foundersWallet, END_TIME, FOUNDERS_VESTING_CLIFF, FOUNDERS_VESTING_DURATION, false);
1297 
1298         // Create Ubiatar Play vault contract
1299         ubiatarPlayVault = new UbiatarPlayVault(ubiatarPlayWallet, address(token), END_TIME);
1300     }
1301 
1302     function mintPreAllocatedTokens() public onlyOwner {
1303         mintTokens(address(foundersVault), FOUNDERS_CAP);
1304         mintTokens(advisorsWallet, ADVISORS_CAP);
1305         mintTokens(address(ubiatarPlayVault), UBIATARPLAY_CAP);
1306     }
1307 
1308     /**
1309      * @dev Creates the presale vault contract.
1310      * @param beneficiaries Array of the presale investors addresses to whom vested tokens are transferred.
1311      * @param balances Array of token amount per beneficiary.
1312      */
1313     function initPresaleTokenVault(address[] beneficiaries, uint256[] balances) public onlyOwner {
1314         require(beneficiaries.length == balances.length);
1315 
1316         presaleTokenVault.init(beneficiaries, balances, PRESALE_VAULT_START, token);
1317 
1318         uint256 totalPresaleBalance = 0;
1319         uint256 balancesLength = balances.length;
1320         for(uint256 i = 0; i < balancesLength; i++) {
1321             totalPresaleBalance = totalPresaleBalance.add(balances[i]);
1322         }
1323 
1324         mintTokens(presaleTokenVault, totalPresaleBalance);
1325     }
1326 
1327     /**
1328      * @dev Implements the price function from EidooEngineInterface.
1329      * @notice Calculates the price as tokens/ether based on the corresponding bonus bracket.
1330      * @return Price as tokens/ether.
1331      */
1332     function price() public view returns (uint256 _price) {
1333         if (block.timestamp <= start.add(BONUS_DURATION_1)) {
1334             return tokenPerEth.mul(BONUS_TIER1).div(1e2);
1335         } else if (block.timestamp <= start.add(BONUS_DURATION_2)) {
1336             return tokenPerEth.mul(BONUS_TIER2).div(1e2);
1337         } else if (block.timestamp <= start.add(BONUS_DURATION_3)) {
1338             return tokenPerEth.mul(BONUS_TIER3).div(1e2);
1339         }
1340         return tokenPerEth;
1341     }
1342 
1343     /**
1344      * @dev Mints tokens being sold during the reservation phase, as part of the implementation of the releaseTokensTo function
1345      * from the KYCBase contract.
1346      * Also, updates tokensSold and availableTokens in the crowdsale contract.
1347      * @param to The address that will receive the minted tokens.
1348      * @param amount The amount of tokens to mint.
1349      */
1350     function mintReservationTokens(address to, uint256 amount) public {
1351         require(msg.sender == address(reservation));
1352         tokensSold = tokensSold.add(amount);
1353         availableTokens = availableTokens.sub(amount);
1354         mintTokens(to, amount);
1355     }
1356 
1357     /**
1358      * @dev Mints tokens being sold during the crowdsale phase as part of the implementation of releaseTokensTo function
1359      * from the KYCBase contract.
1360      * @param to The address that will receive the minted tokens.
1361      * @param amount The amount of tokens to mint.
1362      */
1363     function mintTokens(address to, uint256 amount) private {
1364         token.mint(to, amount);
1365     }
1366 
1367     /**
1368      * @dev Allows the owner to close the crowdsale manually before the end time.
1369      */
1370     function closeCrowdsale() public onlyOwner {
1371         require(block.timestamp >= START_TIME && block.timestamp < END_TIME);
1372         didOwnerEndCrowdsale = true;
1373     }
1374 
1375     /**
1376      * @dev Allows the owner to unpause tokens, stop minting and transfer ownership of the token contract.
1377      */
1378     function finalise() public onlyOwner {
1379         require(didOwnerEndCrowdsale || block.timestamp > end || capReached);
1380         token.finishMinting();
1381         token.unpause();
1382 
1383         // Token contract extends CanReclaimToken so the owner can recover any ERC20 token received in this contract by mistake.
1384         // So far, the owner of the token contract is the crowdsale contract.
1385         // We transfer the ownership so the owner of the crowdsale is also the owner of the token.
1386         token.transferOwnership(owner);
1387     }
1388 }