1 /*
2 Copyright 2018 Subramanian Venkatesan, Binod Nirvan
3 
4 Licensed under the Apache License, Version 2.0 (the "License");
5 you may not use this file except in compliance with the License.
6 You may obtain a copy of the License at
7 
8     http://www.apache.org/licenses/LICENSE-2.0
9 
10 Unless required by applicable law or agreed to in writing, software
11 distributed under the License is distributed on an "AS IS" BASIS,
12 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13 See the License for the specific language governing permissions and
14 limitations under the License.
15  */
16 pragma solidity ^0.4.22;
17 
18 
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that revert on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, reverts on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32     // benefit is lost if 'b' is also tested.
33     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34     if (a == 0) {
35       return 0;
36     }
37 
38     uint256 c = a * b;
39     require(c / a == b);
40 
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     require(b > 0); // Solidity only automatically asserts when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52     return c;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b <= a);
60     uint256 c = a - b;
61 
62     return c;
63   }
64 
65   /**
66   * @dev Adds two numbers, reverts on overflow.
67   */
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     require(c >= a);
71 
72     return c;
73   }
74 
75   /**
76   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
77   * reverts when dividing by zero.
78   */
79   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80     require(b != 0);
81     return a % b;
82   }
83 }
84 
85 
86 
87 
88 
89 
90 
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 interface IERC20 {
97   function totalSupply() external view returns (uint256);
98 
99   function balanceOf(address who) external view returns (uint256);
100 
101   function allowance(address owner, address spender)
102     external view returns (uint256);
103 
104   function transfer(address to, uint256 value) external returns (bool);
105 
106   function approve(address spender, uint256 value)
107     external returns (bool);
108 
109   function transferFrom(address from, address to, uint256 value)
110     external returns (bool);
111 
112   event Transfer(
113     address indexed from,
114     address indexed to,
115     uint256 value
116   );
117 
118   event Approval(
119     address indexed owner,
120     address indexed spender,
121     uint256 value
122   );
123 }
124 
125 
126 
127 
128 
129 
130 
131 /**
132  * @title SafeERC20
133  * @dev Wrappers around ERC20 operations that throw on failure.
134  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
135  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
136  */
137 library SafeERC20 {
138 
139   using SafeMath for uint256;
140 
141   function safeTransfer(
142     IERC20 token,
143     address to,
144     uint256 value
145   )
146     internal
147   {
148     require(token.transfer(to, value));
149   }
150 
151   function safeTransferFrom(
152     IERC20 token,
153     address from,
154     address to,
155     uint256 value
156   )
157     internal
158   {
159     require(token.transferFrom(from, to, value));
160   }
161 
162   function safeApprove(
163     IERC20 token,
164     address spender,
165     uint256 value
166   )
167     internal
168   {
169     // safeApprove should only be called when setting an initial allowance, 
170     // or when resetting it to zero. To increase and decrease it, use 
171     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
172     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
173     require(token.approve(spender, value));
174   }
175 
176   function safeIncreaseAllowance(
177     IERC20 token,
178     address spender,
179     uint256 value
180   )
181     internal
182   {
183     uint256 newAllowance = token.allowance(address(this), spender).add(value);
184     require(token.approve(spender, newAllowance));
185   }
186 
187   function safeDecreaseAllowance(
188     IERC20 token,
189     address spender,
190     uint256 value
191   )
192     internal
193   {
194     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
195     require(token.approve(spender, newAllowance));
196   }
197 }
198 
199 
200 
201 /**
202  * @title Helps contracts guard against reentrancy attacks.
203  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
204  * @dev If you mark a function `nonReentrant`, you should also
205  * mark it `external`.
206  */
207 contract ReentrancyGuard {
208 
209   /// @dev counter to allow mutex lock with only one SSTORE operation
210   uint256 private _guardCounter;
211 
212   constructor() internal {
213     // The counter starts at one to prevent changing it from zero to a non-zero
214     // value, which is a more expensive operation.
215     _guardCounter = 1;
216   }
217 
218   /**
219    * @dev Prevents a contract from calling itself, directly or indirectly.
220    * Calling a `nonReentrant` function from another `nonReentrant`
221    * function is not supported. It is possible to prevent this from happening
222    * by making the `nonReentrant` function external, and make it call a
223    * `private` function that does the actual work.
224    */
225   modifier nonReentrant() {
226     _guardCounter += 1;
227     uint256 localCounter = _guardCounter;
228     _;
229     require(localCounter == _guardCounter);
230   }
231 
232 }
233 
234 
235 /**
236  * @title Crowdsale
237  * @dev Crowdsale is a base contract for managing a token crowdsale,
238  * allowing investors to purchase tokens with ether. This contract implements
239  * such functionality in its most fundamental form and can be extended to provide additional
240  * functionality and/or custom behavior.
241  * The external interface represents the basic interface for purchasing tokens, and conform
242  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
243  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
244  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
245  * behavior.
246  */
247 contract Crowdsale is ReentrancyGuard {
248   using SafeMath for uint256;
249   using SafeERC20 for IERC20;
250 
251   // The token being sold
252   IERC20 private _token;
253 
254   // Address where funds are collected
255   address private _wallet;
256 
257   // How many token units a buyer gets per wei.
258   // The rate is the conversion between wei and the smallest and indivisible token unit.
259   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
260   // 1 wei will give you 1 unit, or 0.001 TOK.
261   uint256 private _rate;
262 
263   // Amount of wei raised
264   uint256 private _weiRaised;
265 
266   /**
267    * Event for token purchase logging
268    * @param purchaser who paid for the tokens
269    * @param beneficiary who got the tokens
270    * @param value weis paid for purchase
271    * @param amount amount of tokens purchased
272    */
273   event TokensPurchased(
274     address indexed purchaser,
275     address indexed beneficiary,
276     uint256 value,
277     uint256 amount
278   );
279 
280   /**
281    * @param rate Number of token units a buyer gets per wei
282    * @dev The rate is the conversion between wei and the smallest and indivisible
283    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
284    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
285    * @param wallet Address where collected funds will be forwarded to
286    * @param token Address of the token being sold
287    */
288   constructor(uint256 rate, address wallet, IERC20 token) internal {
289     require(rate > 0);
290     require(wallet != address(0));
291     require(token != address(0));
292 
293     _rate = rate;
294     _wallet = wallet;
295     _token = token;
296   }
297 
298   // -----------------------------------------
299   // Crowdsale external interface
300   // -----------------------------------------
301 
302   /**
303    * @dev fallback function ***DO NOT OVERRIDE***
304    * Note that other contracts will transfer fund with a base gas stipend
305    * of 2300, which is not enough to call buyTokens. Consider calling
306    * buyTokens directly when purchasing tokens from a contract.
307    */
308   function () external payable {
309     buyTokens(msg.sender);
310   }
311 
312   /**
313    * @return the token being sold.
314    */
315   function token() public view returns(IERC20) {
316     return _token;
317   }
318 
319   /**
320    * @return the address where funds are collected.
321    */
322   function wallet() public view returns(address) {
323     return _wallet;
324   }
325 
326   /**
327    * @return the number of token units a buyer gets per wei.
328    */
329   function rate() public view returns(uint256) {
330     return _rate;
331   }
332 
333   /**
334    * @return the amount of wei raised.
335    */
336   function weiRaised() public view returns (uint256) {
337     return _weiRaised;
338   }
339 
340   /**
341    * @dev low level token purchase ***DO NOT OVERRIDE***
342    * This function has a non-reentrancy guard, so it shouldn't be called by
343    * another `nonReentrant` function.
344    * @param beneficiary Recipient of the token purchase
345    */
346   function buyTokens(address beneficiary) public nonReentrant payable {
347 
348     uint256 weiAmount = msg.value;
349     _preValidatePurchase(beneficiary, weiAmount);
350 
351     // calculate token amount to be created
352     uint256 tokens = _getTokenAmount(weiAmount);
353 
354     // update state
355     _weiRaised = _weiRaised.add(weiAmount);
356 
357     _processPurchase(beneficiary, tokens);
358     emit TokensPurchased(
359       msg.sender,
360       beneficiary,
361       weiAmount,
362       tokens
363     );
364 
365     _updatePurchasingState(beneficiary, weiAmount);
366 
367     _forwardFunds();
368     _postValidatePurchase(beneficiary, weiAmount);
369   }
370 
371   // -----------------------------------------
372   // Internal interface (extensible)
373   // -----------------------------------------
374 
375   /**
376    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
377    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
378    *   super._preValidatePurchase(beneficiary, weiAmount);
379    *   require(weiRaised().add(weiAmount) <= cap);
380    * @param beneficiary Address performing the token purchase
381    * @param weiAmount Value in wei involved in the purchase
382    */
383   function _preValidatePurchase(
384     address beneficiary,
385     uint256 weiAmount
386   )
387     internal
388     view
389   {
390     require(beneficiary != address(0));
391     require(weiAmount != 0);
392   }
393 
394   /**
395    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
396    * @param beneficiary Address performing the token purchase
397    * @param weiAmount Value in wei involved in the purchase
398    */
399   function _postValidatePurchase(
400     address beneficiary,
401     uint256 weiAmount
402   )
403     internal
404     view
405   {
406     // optional override
407   }
408 
409   /**
410    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
411    * @param beneficiary Address performing the token purchase
412    * @param tokenAmount Number of tokens to be emitted
413    */
414   function _deliverTokens(
415     address beneficiary,
416     uint256 tokenAmount
417   )
418     internal
419   {
420     _token.safeTransfer(beneficiary, tokenAmount);
421   }
422 
423   /**
424    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
425    * @param beneficiary Address receiving the tokens
426    * @param tokenAmount Number of tokens to be purchased
427    */
428   function _processPurchase(
429     address beneficiary,
430     uint256 tokenAmount
431   )
432     internal
433   {
434     _deliverTokens(beneficiary, tokenAmount);
435   }
436 
437   /**
438    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
439    * @param beneficiary Address receiving the tokens
440    * @param weiAmount Value in wei involved in the purchase
441    */
442   function _updatePurchasingState(
443     address beneficiary,
444     uint256 weiAmount
445   )
446     internal
447   {
448     // optional override
449   }
450 
451   /**
452    * @dev Override to extend the way in which ether is converted to tokens.
453    * @param weiAmount Value in wei to be converted into tokens
454    * @return Number of tokens that can be purchased with the specified _weiAmount
455    */
456   function _getTokenAmount(uint256 weiAmount)
457     internal view returns (uint256)
458   {
459     return weiAmount.mul(_rate);
460   }
461 
462   /**
463    * @dev Determines how ETH is stored/forwarded on purchases.
464    */
465   function _forwardFunds() internal {
466     _wallet.transfer(msg.value);
467   }
468 }
469 
470 
471 /**
472  * @title TimedCrowdsale
473  * @dev Crowdsale accepting contributions only within a time frame.
474  */
475 contract TimedCrowdsale is Crowdsale {
476   using SafeMath for uint256;
477 
478   uint256 private _openingTime;
479   uint256 private _closingTime;
480 
481   /**
482    * @dev Reverts if not in crowdsale time range.
483    */
484   modifier onlyWhileOpen {
485     require(isOpen());
486     _;
487   }
488 
489   /**
490    * @dev Constructor, takes crowdsale opening and closing times.
491    * @param openingTime Crowdsale opening time
492    * @param closingTime Crowdsale closing time
493    */
494   constructor(uint256 openingTime, uint256 closingTime) internal {
495     // solium-disable-next-line security/no-block-members
496     require(openingTime >= block.timestamp);
497     require(closingTime > openingTime);
498 
499     _openingTime = openingTime;
500     _closingTime = closingTime;
501   }
502 
503   /**
504    * @return the crowdsale opening time.
505    */
506   function openingTime() public view returns(uint256) {
507     return _openingTime;
508   }
509 
510   /**
511    * @return the crowdsale closing time.
512    */
513   function closingTime() public view returns(uint256) {
514     return _closingTime;
515   }
516 
517   /**
518    * @return true if the crowdsale is open, false otherwise.
519    */
520   function isOpen() public view returns (bool) {
521     // solium-disable-next-line security/no-block-members
522     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
523   }
524 
525   /**
526    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
527    * @return Whether crowdsale period has elapsed
528    */
529   function hasClosed() public view returns (bool) {
530     // solium-disable-next-line security/no-block-members
531     return block.timestamp > _closingTime;
532   }
533 
534   /**
535    * @dev Extend parent behavior requiring to be within contributing period
536    * @param beneficiary Token purchaser
537    * @param weiAmount Amount of wei contributed
538    */
539   function _preValidatePurchase(
540     address beneficiary,
541     uint256 weiAmount
542   )
543     internal
544     onlyWhileOpen
545     view
546   {
547     super._preValidatePurchase(beneficiary, weiAmount);
548   }
549 
550 }
551 
552 
553 /**
554  * @title FinalizableCrowdsale
555  * @dev Extension of Crowdsale with a one-off finalization action, where one
556  * can do extra work after finishing.
557  */
558 contract FinalizableCrowdsale is TimedCrowdsale {
559   using SafeMath for uint256;
560 
561   bool private _finalized;
562 
563   event CrowdsaleFinalized();
564 
565   constructor() internal {
566     _finalized = false;
567   }
568 
569   /**
570    * @return true if the crowdsale is finalized, false otherwise.
571    */
572   function finalized() public view returns (bool) {
573     return _finalized;
574   }
575 
576   /**
577    * @dev Must be called after crowdsale ends, to do some extra finalization
578    * work. Calls the contract's finalization function.
579    */
580   function finalize() public {
581     require(!_finalized);
582     require(hasClosed());
583 
584     _finalized = true;
585 
586     _finalization();
587     emit CrowdsaleFinalized();
588   }
589 
590   /**
591    * @dev Can be overridden to add finalization logic. The overriding function
592    * should call super._finalization() to ensure the chain of finalization is
593    * executed entirely.
594    */
595   function _finalization() internal {
596   }
597 }
598 
599 
600 
601 
602 
603 
604 /**
605  * @title CappedCrowdsale
606  * @dev Crowdsale with a limit for total contributions.
607  */
608 contract CappedCrowdsale is Crowdsale {
609   using SafeMath for uint256;
610 
611   uint256 private _cap;
612 
613   /**
614    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
615    * @param cap Max amount of wei to be contributed
616    */
617   constructor(uint256 cap) internal {
618     require(cap > 0);
619     _cap = cap;
620   }
621 
622   /**
623    * @return the cap of the crowdsale.
624    */
625   function cap() public view returns(uint256) {
626     return _cap;
627   }
628 
629   /**
630    * @dev Checks whether the cap has been reached.
631    * @return Whether the cap was reached
632    */
633   function capReached() public view returns (bool) {
634     return weiRaised() >= _cap;
635   }
636 
637   /**
638    * @dev Extend parent behavior requiring purchase to respect the funding cap.
639    * @param beneficiary Token purchaser
640    * @param weiAmount Amount of wei contributed
641    */
642   function _preValidatePurchase(
643     address beneficiary,
644     uint256 weiAmount
645   )
646     internal
647     view
648   {
649     super._preValidatePurchase(beneficiary, weiAmount);
650     require(weiRaised().add(weiAmount) <= _cap);
651   }
652 
653 }
654 
655 
656 /*
657 Copyright 2018 Binod Nirvan
658 
659 Licensed under the Apache License, Version 2.0 (the "License");
660 you may not use this file except in compliance with the License.
661 You may obtain a copy of the License at
662 
663     http://www.apache.org/licenses/LICENSE-2.0
664 
665 Unless required by applicable law or agreed to in writing, software
666 distributed under the License is distributed on an "AS IS" BASIS,
667 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
668 See the License for the specific language governing permissions and
669 limitations under the License.
670  */
671 
672 
673 /*
674 Copyright 2018 Binod Nirvan
675 
676 Licensed under the Apache License, Version 2.0 (the "License");
677 you may not use this file except in compliance with the License.
678 You may obtain a copy of the License at
679 
680     http://www.apache.org/licenses/LICENSE-2.0
681 
682 Unless required by applicable law or agreed to in writing, software
683 distributed under the License is distributed on an "AS IS" BASIS,
684 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
685 See the License for the specific language governing permissions and
686 limitations under the License.
687  */
688 
689 
690 
691 /*
692 Copyright 2018 Binod Nirvan
693 
694 Licensed under the Apache License, Version 2.0 (the "License");
695 you may not use this file except in compliance with the License.
696 You may obtain a copy of the License at
697 
698     http://www.apache.org/licenses/LICENSE-2.0
699 
700 Unless required by applicable law or agreed to in writing, software
701 distributed under the License is distributed on an "AS IS" BASIS,
702 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
703 See the License for the specific language governing permissions and
704 limitations under the License.
705  */
706 
707 
708 
709 
710 
711 /**
712  * @title Ownable
713  * @dev The Ownable contract has an owner address, and provides basic authorization control
714  * functions, this simplifies the implementation of "user permissions".
715  */
716 contract Ownable {
717   address private _owner;
718 
719   event OwnershipTransferred(
720     address indexed previousOwner,
721     address indexed newOwner
722   );
723 
724   /**
725    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
726    * account.
727    */
728   constructor() internal {
729     _owner = msg.sender;
730     emit OwnershipTransferred(address(0), _owner);
731   }
732 
733   /**
734    * @return the address of the owner.
735    */
736   function owner() public view returns(address) {
737     return _owner;
738   }
739 
740   /**
741    * @dev Throws if called by any account other than the owner.
742    */
743   modifier onlyOwner() {
744     require(isOwner());
745     _;
746   }
747 
748   /**
749    * @return true if `msg.sender` is the owner of the contract.
750    */
751   function isOwner() public view returns(bool) {
752     return msg.sender == _owner;
753   }
754 
755   /**
756    * @dev Allows the current owner to relinquish control of the contract.
757    * @notice Renouncing to ownership will leave the contract without an owner.
758    * It will not be possible to call the functions with the `onlyOwner`
759    * modifier anymore.
760    */
761   function renounceOwnership() public onlyOwner {
762     emit OwnershipTransferred(_owner, address(0));
763     _owner = address(0);
764   }
765 
766   /**
767    * @dev Allows the current owner to transfer control of the contract to a newOwner.
768    * @param newOwner The address to transfer ownership to.
769    */
770   function transferOwnership(address newOwner) public onlyOwner {
771     _transferOwnership(newOwner);
772   }
773 
774   /**
775    * @dev Transfers control of the contract to a newOwner.
776    * @param newOwner The address to transfer ownership to.
777    */
778   function _transferOwnership(address newOwner) internal {
779     require(newOwner != address(0));
780     emit OwnershipTransferred(_owner, newOwner);
781     _owner = newOwner;
782   }
783 }
784 
785 
786 
787 ///@title This contract enables to create multiple contract administrators.
788 contract CustomAdmin is Ownable {
789   ///@notice List of administrators.
790   mapping(address => bool) public admins;
791 
792   event AdminAdded(address indexed _address);
793   event AdminRemoved(address indexed _address);
794 
795   ///@notice Validates if the sender is actually an administrator.
796   modifier onlyAdmin() {
797     require(isAdmin(msg.sender), "Access is denied.");
798     _;
799   }
800 
801   ///@notice Adds the specified address to the list of administrators.
802   ///@param _address The address to add to the administrator list.
803   function addAdmin(address _address) external onlyAdmin returns(bool) {
804     require(_address != address(0), "Invalid address.");
805     require(!admins[_address], "This address is already an administrator.");
806 
807     require(_address != owner(), "The owner cannot be added or removed to or from the administrator list.");
808 
809     admins[_address] = true;
810 
811     emit AdminAdded(_address);
812     return true;
813   }
814 
815   ///@notice Adds multiple addresses to the administrator list.
816   ///@param _accounts The wallet addresses to add to the administrator list.
817   function addManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
818     for(uint8 i = 0; i < _accounts.length; i++) {
819       address account = _accounts[i];
820 
821       ///Zero address cannot be an admin.
822       ///The owner is already an admin and cannot be assigned.
823       ///The address cannot be an existing admin.
824       if(account != address(0) && !admins[account] && account != owner()) {
825         admins[account] = true;
826 
827         emit AdminAdded(_accounts[i]);
828       }
829     }
830 
831     return true;
832   }
833 
834   ///@notice Removes the specified address from the list of administrators.
835   ///@param _address The address to remove from the administrator list.
836   function removeAdmin(address _address) external onlyAdmin returns(bool) {
837     require(_address != address(0), "Invalid address.");
838     require(admins[_address], "This address isn't an administrator.");
839 
840     //The owner cannot be removed as admin.
841     require(_address != owner(), "The owner cannot be added or removed to or from the administrator list.");
842 
843     admins[_address] = false;
844     emit AdminRemoved(_address);
845     return true;
846   }
847 
848   ///@notice Removes multiple addresses to the administrator list.
849   ///@param _accounts The wallet addresses to add to the administrator list.
850   function removeManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
851     for(uint8 i = 0; i < _accounts.length; i++) {
852       address account = _accounts[i];
853 
854       ///Zero address can neither be added or removed from this list.
855       ///The owner is the super admin and cannot be removed.
856       ///The address must be an existing admin in order for it to be removed.
857       if(account != address(0) && admins[account] && account != owner()) {
858         admins[account] = false;
859 
860         emit AdminRemoved(_accounts[i]);
861       }
862     }
863 
864     return true;
865   }
866 
867   ///@notice Checks if an address is an administrator.
868   function isAdmin(address _address) public view returns(bool) {
869     if(_address == owner()) {
870       return true;
871     }
872 
873     return admins[_address];
874   }
875 }
876 
877 
878 
879 ///@title This contract enables you to create pausable mechanism to stop in case of emergency.
880 contract CustomPausable is CustomAdmin {
881   event Paused();
882   event Unpaused();
883 
884   bool public paused = false;
885 
886   ///@notice Verifies whether the contract is not paused.
887   modifier whenNotPaused() {
888     require(!paused, "Sorry but the contract isn't paused.");
889     _;
890   }
891 
892   ///@notice Verifies whether the contract is paused.
893   modifier whenPaused() {
894     require(paused, "Sorry but the contract is paused.");
895     _;
896   }
897 
898   ///@notice Pauses the contract.
899   function pause() external onlyAdmin whenNotPaused {
900     paused = true;
901     emit Paused();
902   }
903 
904   ///@notice Unpauses the contract and returns to normal state.
905   function unpause() external onlyAdmin whenPaused {
906     paused = false;
907     emit Unpaused();
908   }
909 }
910 
911 
912 ///@title This contract enables to maintain a list of whitelisted wallets.
913 contract CustomWhitelist is CustomPausable {
914   mapping(address => bool) public whitelist;
915 
916   event WhitelistAdded(address indexed _account);
917   event WhitelistRemoved(address indexed _account);
918 
919   ///@notice Verifies if the account is whitelisted.
920   modifier ifWhitelisted(address _account) {
921     require(_account != address(0), "Account cannot be zero address");
922     require(isWhitelisted(_account), "Account is not whitelisted");
923 
924     _;
925   }
926 
927   ///@notice Adds an account to the whitelist.
928   ///@param _account The wallet address to add to the whitelist.
929   function addWhitelist(address _account) external whenNotPaused onlyAdmin returns(bool) {
930     require(_account != address(0), "Account cannot be zero address");
931 
932     if(!whitelist[_account]) {
933       whitelist[_account] = true;
934 
935       emit WhitelistAdded(_account);
936     }
937 
938     return true;
939   }
940 
941   ///@notice Adds multiple accounts to the whitelist.
942   ///@param _accounts The wallet addresses to add to the whitelist.
943   function addManyWhitelist(address[] _accounts) external whenNotPaused onlyAdmin returns(bool) {
944     for(uint8 i = 0;i < _accounts.length;i++) {
945       if(_accounts[i] != address(0) && !whitelist[_accounts[i]]) {
946         whitelist[_accounts[i]] = true;
947 
948         emit WhitelistAdded(_accounts[i]);
949       }
950     }
951 
952     return true;
953   }
954 
955   ///@notice Removes an account from the whitelist.
956   ///@param _account The wallet address to remove from the whitelist.
957   function removeWhitelist(address _account) external whenNotPaused onlyAdmin returns(bool) {
958     require(_account != address(0), "Account cannot be zero address");
959     if(whitelist[_account]) {
960       whitelist[_account] = false;
961       emit WhitelistRemoved(_account);
962     }
963 
964     return true;
965   }
966 
967   ///@notice Removes multiple accounts from the whitelist.
968   ///@param _accounts The wallet addresses to remove from the whitelist.
969   function removeManyWhitelist(address[] _accounts) external whenNotPaused onlyAdmin returns(bool) {
970     for(uint8 i = 0;i < _accounts.length;i++) {
971       if(_accounts[i] != address(0) && whitelist[_accounts[i]]) {
972         whitelist[_accounts[i]] = false;
973 
974         emit WhitelistRemoved(_accounts[i]);
975       }
976     }
977     
978     return true;
979   }
980 
981   ///@notice Checks if an address is whitelisted.
982   function isWhitelisted(address _address) public view returns(bool) {
983     return whitelist[_address];
984   }
985 }
986 
987 
988 
989 /**
990  * @title TokenSale
991  * @dev Crowdsale contract for KubitX
992  */
993 contract TokenSale is CappedCrowdsale, FinalizableCrowdsale, CustomWhitelist {
994   event FundsWithdrawn(address indexed _wallet, uint256 _amount);
995   event BonusChanged(uint256 _newBonus, uint256 _oldBonus);
996   event RateChanged(uint256 _rate, uint256 _oldRate);
997 
998   uint256 public bonus;
999   uint256 public rate;
1000 
1001   constructor(uint256 _openingTime,
1002     uint256 _closingTime,
1003     uint256 _rate,
1004     address _wallet,
1005     IERC20 _token,
1006     uint256 _bonus,
1007     uint256 _cap)
1008   public 
1009   TimedCrowdsale(_openingTime, _closingTime) 
1010   CappedCrowdsale(_cap) 
1011   Crowdsale(_rate, _wallet, _token) {
1012     require(_bonus > 0, "Bonus must be greater than 0");
1013     bonus = _bonus;
1014     rate = _rate;
1015   }
1016 
1017   ///@notice This feature enables the admins to withdraw Ethers held in this contract.
1018   ///@param _amount Amount of Ethers in wei to withdraw.
1019   function withdrawFunds(uint256 _amount) external whenNotPaused onlyAdmin {
1020     require(_amount <= address(this).balance, "The amount should be less than the balance/");
1021     msg.sender.transfer(_amount);
1022     emit FundsWithdrawn(msg.sender, _amount);
1023   }
1024 
1025   ///@notice Withdraw the tokens remaining tokens from the contract.
1026   function withdrawTokens() external whenNotPaused onlyAdmin {
1027     IERC20 t = super.token();
1028     t.safeTransfer(msg.sender, t.balanceOf(this));
1029   }
1030 
1031   ///@notice Enables admins to withdraw accidentally sent ERC20 token to the contract.
1032   function withdrawERC20(address _token) external whenNotPaused onlyAdmin {
1033     IERC20 erc20 = IERC20(_token);
1034     uint256 balance = erc20.balanceOf(this);
1035 
1036     erc20.safeTransfer(msg.sender, balance);
1037   }
1038 
1039   ///@notice Changes the bonus.
1040   ///@param _bonus The new bonus to set.
1041   function changeBonus(uint256 _bonus) external whenNotPaused onlyAdmin {
1042     require(_bonus > 0, "Bonus must be greater than 0");
1043     emit BonusChanged(_bonus, bonus);
1044     bonus = _bonus;
1045   }
1046 
1047   ///@notice Changes the rate.
1048   ///@param _rate The new rate to set.
1049   function changeRate(uint256 _rate) external whenNotPaused onlyAdmin {
1050     require(_rate > 0, "Rate must be greater than 0");
1051     emit RateChanged(_rate, rate);
1052     rate = _rate;
1053   }
1054 
1055   ///@notice Checks if the crowdsale has closed.
1056   function hasClosed() public view returns (bool) {
1057     return super.hasClosed() || super.capReached();
1058   }
1059 
1060   ///@notice This is called before determining the token amount.
1061   ///@param _beneficiary Contributing address of ETH
1062   ///@param _weiAmount ETH contribution
1063   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) 
1064   internal view whenNotPaused ifWhitelisted(_beneficiary) {
1065     super._preValidatePurchase(_beneficiary, _weiAmount);
1066   }
1067 
1068   ///@notice Returns the number of tokens for ETH
1069   ///@param _weiAmount ETH contribution
1070   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1071     uint256 tokenAmount = _weiAmount.mul(rate);
1072     uint256 bonusTokens = tokenAmount.mul(bonus).div(100);
1073     return tokenAmount.add(bonusTokens);
1074   }
1075 
1076   ///@notice overrided to store the funds in the contract itself
1077   //solhint-disable-next-line
1078   function _forwardFunds() internal {
1079     //nothing to do here
1080   }
1081 }