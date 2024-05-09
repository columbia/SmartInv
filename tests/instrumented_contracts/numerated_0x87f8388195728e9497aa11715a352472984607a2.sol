1 // File: dependencies/openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: dependencies/openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
82 
83 
84 
85 pragma solidity ^0.8.0;
86 
87 
88 /**
89  * @dev Interface for the optional metadata functions from the ERC20 standard.
90  *
91  * _Available since v4.1._
92  */
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns (string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns (string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns (uint8);
108 }
109 
110 // File: dependencies/openzeppelin/contracts/utils/math/SafeMath.sol
111 
112 
113 
114 pragma solidity ^0.8.0;
115 
116 // CAUTION
117 // This version of SafeMath should only be used with Solidity 0.8 or later,
118 // because it relies on the compiler's built in overflow checks.
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations.
122  *
123  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
124  * now has built in overflow checking.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, with an overflow flag.
129      *
130      * _Available since v3.4._
131      */
132     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         unchecked {
134             uint256 c = a + b;
135             if (c < a) return (false, 0);
136             return (true, c);
137         }
138     }
139 
140     /**
141      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
142      *
143      * _Available since v3.4._
144      */
145     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             if (b > a) return (false, 0);
148             return (true, a - b);
149         }
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
154      *
155      * _Available since v3.4._
156      */
157     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         unchecked {
159             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160             // benefit is lost if 'b' is also tested.
161             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162             if (a == 0) return (true, 0);
163             uint256 c = a * b;
164             if (c / a != b) return (false, 0);
165             return (true, c);
166         }
167     }
168 
169     /**
170      * @dev Returns the division of two unsigned integers, with a division by zero flag.
171      *
172      * _Available since v3.4._
173      */
174     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
175         unchecked {
176             if (b == 0) return (false, 0);
177             return (true, a / b);
178         }
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
183      *
184      * _Available since v3.4._
185      */
186     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
187         unchecked {
188             if (b == 0) return (false, 0);
189             return (true, a % b);
190         }
191     }
192 
193     /**
194      * @dev Returns the addition of two unsigned integers, reverting on
195      * overflow.
196      *
197      * Counterpart to Solidity's `+` operator.
198      *
199      * Requirements:
200      *
201      * - Addition cannot overflow.
202      */
203     function add(uint256 a, uint256 b) internal pure returns (uint256) {
204         return a + b;
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting on
209      * overflow (when the result is negative).
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      *
215      * - Subtraction cannot overflow.
216      */
217     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a - b;
219     }
220 
221     /**
222      * @dev Returns the multiplication of two unsigned integers, reverting on
223      * overflow.
224      *
225      * Counterpart to Solidity's `*` operator.
226      *
227      * Requirements:
228      *
229      * - Multiplication cannot overflow.
230      */
231     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a * b;
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers, reverting on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator.
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function div(uint256 a, uint256 b) internal pure returns (uint256) {
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         return a % b;
263     }
264 
265     /**
266      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
267      * overflow (when the result is negative).
268      *
269      * CAUTION: This function is deprecated because it requires allocating memory for the error
270      * message unnecessarily. For custom revert reasons use {trySub}.
271      *
272      * Counterpart to Solidity's `-` operator.
273      *
274      * Requirements:
275      *
276      * - Subtraction cannot overflow.
277      */
278     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         unchecked {
280             require(b <= a, errorMessage);
281             return a - b;
282         }
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Counterpart to Solidity's `/` operator. Note: this function uses a
294      * `revert` opcode (which leaves remaining gas untouched) while Solidity
295      * uses an invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         unchecked {
303             require(b > 0, errorMessage);
304             return a / b;
305         }
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * reverting with custom message when dividing by zero.
311      *
312      * CAUTION: This function is deprecated because it requires allocating memory for the error
313      * message unnecessarily. For custom revert reasons use {tryMod}.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         unchecked {
325             require(b > 0, errorMessage);
326             return a % b;
327         }
328     }
329 }
330 
331 // File: elementix/libraries/SaleKindInterface.sol
332 
333 
334 pragma solidity ^0.8.0;
335 
336 
337 
338 library SaleKindInterface {
339     
340     /**
341      * Side: buy or sell.
342      */
343     enum Side { Buy, Sell }
344 
345     /**
346      * Currently supported kinds of sale: fixed price, Dutch auction. 
347      * English auctions cannot be supported without stronger escrow guarantees.
348      * Future interesting options: Vickrey auction, nonlinear Dutch auctions.
349      */
350     enum SaleKind { FixedPrice, DutchAuction }
351 
352     /**
353      * @dev Check whether the parameters of a sale are valid
354      * @param saleKind Kind of sale
355      * @param expirationTime Order expiration time
356      * @return Whether the parameters were valid
357      */
358     function validateParameters(SaleKind saleKind, uint256 expirationTime)
359         pure
360         internal
361         returns (bool)
362     {
363         /* Auctions must have a set expiration date. */
364         return (saleKind == SaleKind.FixedPrice || expirationTime > 0);
365     }
366 
367     /**
368      * @dev Return whether or not an order can be settled
369      * @dev Precondition: parameters have passed validateParameters
370      * @param listingTime Order listing time
371      * @param expirationTime Order expiration time
372      */
373     function canSettleOrder(uint256 listingTime, uint256 expirationTime)
374         view
375         internal
376         returns (bool)
377     {
378         return (listingTime < block.timestamp) && (expirationTime == 0 || block.timestamp < expirationTime);
379     }
380 
381     /**
382      * @dev Calculate the settlement price of an order
383      * @dev Precondition: parameters have passed validateParameters.
384      * @param side Order side
385      * @param saleKind Method of sale
386      * @param basePrice Order base price
387      * @param extra Order extra price data
388      * @param listingTime Order listing time
389      * @param expirationTime Order expiration time
390      */
391     function calculateFinalPrice(Side side, SaleKind saleKind, uint256 basePrice, uint256 extra, uint256 listingTime, uint256 expirationTime)
392         view
393         internal
394         returns (uint256 finalPrice)
395     {
396         if (saleKind == SaleKind.FixedPrice) {
397             return basePrice;
398         } else if (saleKind == SaleKind.DutchAuction) {
399             uint256 diff = SafeMath.div(SafeMath.mul(extra, SafeMath.sub(block.timestamp, listingTime)), SafeMath.sub(expirationTime, listingTime));
400             if (side == Side.Sell) {
401                 /* Sell-side - start price: basePrice. End price: basePrice - extra. */
402                 return SafeMath.sub(basePrice, diff);
403             } else {
404                 /* Buy-side - start price: basePrice. End price: basePrice + extra. */
405                 return SafeMath.add(basePrice, diff);
406             }
407         }
408     }
409 
410 }
411 
412 
413 // File: elementix/libraries/DataType.sol
414 
415 
416 pragma solidity ^0.8.0;
417 
418 
419 library DataType {
420 
421     /* An ECDSA signature. */ 
422     struct Sig {
423         /* v parameter */
424         uint8 v;
425         /* r parameter */
426         bytes32 r;
427         /* s parameter */
428         bytes32 s;
429     }
430 
431     /* Fee method: protocol fee or split fee. */
432     enum FeeMethod { ProtocolFee, SplitFee }
433   
434     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
435     enum HowToCall { Call, DelegateCall }
436     
437     /* An order on the exchange. */
438     struct Order {
439         /* Exchange address, intended as a versioning mechanism. */
440         address exchange;
441         /* Order maker address. */
442         address maker;
443         /* Order taker address, if specified. */
444         address taker;
445         /* Maker relayer fee of the order, unused for taker order. */
446         uint256 makerRelayerFee;
447         /* Taker relayer fee of the order, or maximum taker fee for a taker order. */
448         uint256 takerRelayerFee;
449         /* Maker protocol fee of the order, unused for taker order. */
450         uint256 makerProtocolFee;
451         /* Taker protocol fee of the order, or maximum taker fee for a taker order. */
452         uint256 takerProtocolFee;
453         /* Order fee recipient or zero address for taker order. */
454         address feeRecipient;
455         /* Fee method (protocol token or split fee). */
456         FeeMethod feeMethod;
457         /* Side (buy/sell). */
458         SaleKindInterface.Side side;
459         /* Kind of sale. */
460         SaleKindInterface.SaleKind saleKind;
461         /* Target. */
462         address target;
463         /* HowToCall. */
464         HowToCall howToCall;
465         /* Calldata. */
466         bytes dataToCall;
467         /* Calldata replacement pattern, or an empty byte array for no replacement. */
468         bytes replacementPattern;
469         /* Static call target, zero-address for no static call. */
470         address staticTarget;
471         /* Static call extra data. */
472         bytes staticExtradata;
473         /* Token used to pay for the order, or the zero-address as a sentinel value for Ether. */
474         address paymentToken;
475         /* Base price of the order (in paymentTokens). */
476         uint256 basePrice;
477         /* Auction extra parameter - minimum bid increment for English auctions, starting/ending price difference. */
478         uint256 extra;
479         /* Listing timestamp. */
480         uint256 listingTime;
481         /* Expiration timestamp - 0 for no expiry. */
482         uint256 expirationTime;
483         /* Order salt, used to prevent duplicate hashes. */
484         uint256 salt;
485     }
486 
487 }
488 // File: elementix/interfaces/IAuthenticatedProxy.sol
489 
490 
491 pragma solidity ^0.8.0;
492 
493 
494 interface IAuthenticatedProxy  {
495   
496 
497     /**
498      * Execute a message call from the proxy contract
499      *
500      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
501      * @param dest Address to which the call will be sent
502      * @param howToCall Which kind of call to make
503      * @param data Calldata to send
504      * @return result Result of the call (success or failure)
505      */
506     function proxy(address dest, DataType.HowToCall howToCall, bytes calldata data) external returns (bool result);
507 
508     /**
509      * Execute a message call and assert success
510      * 
511      * @dev Same functionality as `proxy`, just asserts the return value
512      * @param dest Address to which the call will be sent
513      * @param howToCall What kind of call to make
514      * @param data Calldata to send
515      */
516     function proxyAssert(address dest, DataType.HowToCall howToCall, bytes calldata data) external;
517 
518 }
519 
520 // File: elementix/OwnedUpgradeabilityStorage.sol
521 
522 
523 pragma solidity ^0.8.0;
524 
525 
526 abstract contract OwnedUpgradeabilityStorage  {
527 
528   // Current implementation
529   address internal _implementation;
530 
531   // Owner of the contract
532   address private _upgradeabilityOwner;
533 
534   /**
535    * @dev Tells the address of the owner
536    * @return the address of the owner
537    */
538   function upgradeabilityOwner() public view returns (address) {
539     return _upgradeabilityOwner;
540   }
541 
542   /**
543    * @dev Sets the address of the owner
544    */
545   function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
546     _upgradeabilityOwner = newUpgradeabilityOwner;
547   }
548 
549   /**
550   * @dev Tells the address of the current implementation
551   * @return address of the current implementation
552   */
553   function implementation() public view returns (address) {
554     return _implementation;
555   }
556 
557   /**
558   * @dev Tells the proxy type (EIP 897)
559   * @return proxyTypeId Proxy type, 2 for forwarding proxy
560   */
561   function proxyType() public pure returns (uint256 proxyTypeId) {
562     return 2;
563   }
564 
565 }
566 // File: elementix/OwnedUpgradeabilityProxy.sol
567 
568 
569 pragma solidity ^0.8.0;
570 
571 
572 
573 abstract contract OwnedUpgradeabilityProxy is OwnedUpgradeabilityStorage {
574   /**
575   * @dev Event to show ownership has been transferred
576   * @param previousOwner representing the address of the previous owner
577   * @param newOwner representing the address of the new owner
578   */
579   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
580 
581   /**
582   * @dev This event will be emitted every time the implementation gets upgraded
583   * @param implementation representing the address of the upgraded implementation
584   */
585   event Upgraded(address indexed implementation);
586 
587   /**
588   * @dev Upgrades the implementation address
589   * @param implementation representing the address of the new implementation to be set
590   */
591   function _upgradeTo(address implementation) internal {
592     require(_implementation != implementation);
593     _implementation = implementation;
594     emit Upgraded(implementation);
595   }
596 
597   /**
598   * @dev Throws if called by any account other than the owner.
599   */
600   modifier onlyProxyOwner() {
601     require(msg.sender == proxyOwner());
602     _;
603   }
604 
605   /**
606    * @dev Tells the address of the proxy owner
607    * @return the address of the proxy owner
608    */
609   function proxyOwner() public view returns (address) {
610     return upgradeabilityOwner();
611   }
612 
613   /**
614    * @dev Allows the current owner to transfer control of the contract to a newOwner.
615    * @param newOwner The address to transfer ownership to.
616    */
617   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
618     require(newOwner != address(0));
619     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
620     setUpgradeabilityOwner(newOwner);
621   }
622 
623   /**
624    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.
625    * @param implementation representing the address of the new implementation to be set.
626    */
627   function upgradeTo(address implementation) public onlyProxyOwner {
628     _upgradeTo(implementation);
629   }
630 
631   /**
632    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy
633    * and delegatecall the new implementation for initialization.
634    * @param implementation representing the address of the new implementation to be set.
635    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
636    * signature of the implementation to be called with the needed payload
637    */
638   function upgradeToAndCall(address implementation, bytes calldata data) payable public onlyProxyOwner {
639     upgradeTo(implementation);
640     (bool success, ) = address(this).delegatecall(data);
641     require(success);
642   }
643 
644 
645   /**
646   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
647   * This function will return whatever the implementation call returns
648   */
649   fallback() payable external {
650     address _impl = implementation();
651     require(_impl != address(0));
652 
653     assembly {
654       let ptr := mload(0x40)
655       calldatacopy(ptr, 0, calldatasize())
656       let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
657       let size := returndatasize()
658       returndatacopy(ptr, 0, size)
659 
660       switch result
661       case 0 { revert(ptr, size) }
662       default { return(ptr, size) }
663     }
664   }
665 }
666 
667 // File: elementix/OwnableDelegateProxy.sol
668 
669 
670 pragma solidity ^0.8.0;
671 
672 
673 
674 
675 contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {
676 
677     constructor(address owner, address initialImplementation, bytes memory dataToCall)
678     {
679         setUpgradeabilityOwner(owner);
680         _upgradeTo(initialImplementation);
681         (bool success, ) = initialImplementation.delegatecall(dataToCall);
682         require(success);
683     }
684     
685 }
686 // File: dependencies/openzeppelin/contracts/utils/Context.sol
687 
688 
689 
690 pragma solidity ^0.8.0;
691 
692 /*
693  * @dev Provides information about the current execution context, including the
694  * sender of the transaction and its data. While these are generally available
695  * via msg.sender and msg.data, they should not be accessed in such a direct
696  * manner, since when dealing with meta-transactions the account sending and
697  * paying for execution may not be the actual sender (as far as an application
698  * is concerned).
699  *
700  * This contract is only required for intermediate, library-like contracts.
701  */
702 abstract contract Context {
703     function _msgSender() internal view virtual returns (address) {
704         return msg.sender;
705     }
706 
707     function _msgData() internal view virtual returns (bytes calldata) {
708         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
709         return msg.data;
710     }
711 }
712 
713 // File: dependencies/openzeppelin/contracts/token/ERC20/ERC20.sol
714 
715 
716 
717 pragma solidity ^0.8.0;
718 
719 
720 
721 
722 /**
723  * @dev Implementation of the {IERC20} interface.
724  *
725  * This implementation is agnostic to the way tokens are created. This means
726  * that a supply mechanism has to be added in a derived contract using {_mint}.
727  * For a generic mechanism see {ERC20PresetMinterPauser}.
728  *
729  * TIP: For a detailed writeup see our guide
730  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
731  * to implement supply mechanisms].
732  *
733  * We have followed general OpenZeppelin guidelines: functions revert instead
734  * of returning `false` on failure. This behavior is nonetheless conventional
735  * and does not conflict with the expectations of ERC20 applications.
736  *
737  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
738  * This allows applications to reconstruct the allowance for all accounts just
739  * by listening to said events. Other implementations of the EIP may not emit
740  * these events, as it isn't required by the specification.
741  *
742  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
743  * functions have been added to mitigate the well-known issues around setting
744  * allowances. See {IERC20-approve}.
745  */
746 contract ERC20 is Context, IERC20, IERC20Metadata {
747     mapping (address => uint256) private _balances;
748 
749     mapping (address => mapping (address => uint256)) private _allowances;
750 
751     uint256 private _totalSupply;
752 
753     string private _name;
754     string private _symbol;
755 
756     /**
757      * @dev Sets the values for {name} and {symbol}.
758      *
759      * The defaut value of {decimals} is 18. To select a different value for
760      * {decimals} you should overload it.
761      *
762      * All two of these values are immutable: they can only be set once during
763      * construction.
764      */
765     constructor (string memory name_, string memory symbol_) {
766         _name = name_;
767         _symbol = symbol_;
768     }
769 
770     /**
771      * @dev Returns the name of the token.
772      */
773     function name() public view virtual override returns (string memory) {
774         return _name;
775     }
776 
777     /**
778      * @dev Returns the symbol of the token, usually a shorter version of the
779      * name.
780      */
781     function symbol() public view virtual override returns (string memory) {
782         return _symbol;
783     }
784 
785     /**
786      * @dev Returns the number of decimals used to get its user representation.
787      * For example, if `decimals` equals `2`, a balance of `505` tokens should
788      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
789      *
790      * Tokens usually opt for a value of 18, imitating the relationship between
791      * Ether and Wei. This is the value {ERC20} uses, unless this function is
792      * overridden;
793      *
794      * NOTE: This information is only used for _display_ purposes: it in
795      * no way affects any of the arithmetic of the contract, including
796      * {IERC20-balanceOf} and {IERC20-transfer}.
797      */
798     function decimals() public view virtual override returns (uint8) {
799         return 18;
800     }
801 
802     /**
803      * @dev See {IERC20-totalSupply}.
804      */
805     function totalSupply() public view virtual override returns (uint256) {
806         return _totalSupply;
807     }
808 
809     /**
810      * @dev See {IERC20-balanceOf}.
811      */
812     function balanceOf(address account) public view virtual override returns (uint256) {
813         return _balances[account];
814     }
815 
816     /**
817      * @dev See {IERC20-transfer}.
818      *
819      * Requirements:
820      *
821      * - `recipient` cannot be the zero address.
822      * - the caller must have a balance of at least `amount`.
823      */
824     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
825         _transfer(_msgSender(), recipient, amount);
826         return true;
827     }
828 
829     /**
830      * @dev See {IERC20-allowance}.
831      */
832     function allowance(address owner, address spender) public view virtual override returns (uint256) {
833         return _allowances[owner][spender];
834     }
835 
836     /**
837      * @dev See {IERC20-approve}.
838      *
839      * Requirements:
840      *
841      * - `spender` cannot be the zero address.
842      */
843     function approve(address spender, uint256 amount) public virtual override returns (bool) {
844         _approve(_msgSender(), spender, amount);
845         return true;
846     }
847 
848     /**
849      * @dev See {IERC20-transferFrom}.
850      *
851      * Emits an {Approval} event indicating the updated allowance. This is not
852      * required by the EIP. See the note at the beginning of {ERC20}.
853      *
854      * Requirements:
855      *
856      * - `sender` and `recipient` cannot be the zero address.
857      * - `sender` must have a balance of at least `amount`.
858      * - the caller must have allowance for ``sender``'s tokens of at least
859      * `amount`.
860      */
861     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
862         _transfer(sender, recipient, amount);
863 
864         uint256 currentAllowance = _allowances[sender][_msgSender()];
865         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
866         _approve(sender, _msgSender(), currentAllowance - amount);
867 
868         return true;
869     }
870 
871     /**
872      * @dev Atomically increases the allowance granted to `spender` by the caller.
873      *
874      * This is an alternative to {approve} that can be used as a mitigation for
875      * problems described in {IERC20-approve}.
876      *
877      * Emits an {Approval} event indicating the updated allowance.
878      *
879      * Requirements:
880      *
881      * - `spender` cannot be the zero address.
882      */
883     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
884         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
885         return true;
886     }
887 
888     /**
889      * @dev Atomically decreases the allowance granted to `spender` by the caller.
890      *
891      * This is an alternative to {approve} that can be used as a mitigation for
892      * problems described in {IERC20-approve}.
893      *
894      * Emits an {Approval} event indicating the updated allowance.
895      *
896      * Requirements:
897      *
898      * - `spender` cannot be the zero address.
899      * - `spender` must have allowance for the caller of at least
900      * `subtractedValue`.
901      */
902     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
903         uint256 currentAllowance = _allowances[_msgSender()][spender];
904         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
905         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
906 
907         return true;
908     }
909 
910     /**
911      * @dev Moves tokens `amount` from `sender` to `recipient`.
912      *
913      * This is internal function is equivalent to {transfer}, and can be used to
914      * e.g. implement automatic token fees, slashing mechanisms, etc.
915      *
916      * Emits a {Transfer} event.
917      *
918      * Requirements:
919      *
920      * - `sender` cannot be the zero address.
921      * - `recipient` cannot be the zero address.
922      * - `sender` must have a balance of at least `amount`.
923      */
924     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
925         require(sender != address(0), "ERC20: transfer from the zero address");
926         require(recipient != address(0), "ERC20: transfer to the zero address");
927 
928         _beforeTokenTransfer(sender, recipient, amount);
929 
930         uint256 senderBalance = _balances[sender];
931         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
932         _balances[sender] = senderBalance - amount;
933         _balances[recipient] += amount;
934 
935         emit Transfer(sender, recipient, amount);
936     }
937 
938     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
939      * the total supply.
940      *
941      * Emits a {Transfer} event with `from` set to the zero address.
942      *
943      * Requirements:
944      *
945      * - `to` cannot be the zero address.
946      */
947     function _mint(address account, uint256 amount) internal virtual {
948         require(account != address(0), "ERC20: mint to the zero address");
949 
950         _beforeTokenTransfer(address(0), account, amount);
951 
952         _totalSupply += amount;
953         _balances[account] += amount;
954         emit Transfer(address(0), account, amount);
955     }
956 
957     /**
958      * @dev Destroys `amount` tokens from `account`, reducing the
959      * total supply.
960      *
961      * Emits a {Transfer} event with `to` set to the zero address.
962      *
963      * Requirements:
964      *
965      * - `account` cannot be the zero address.
966      * - `account` must have at least `amount` tokens.
967      */
968     function _burn(address account, uint256 amount) internal virtual {
969         require(account != address(0), "ERC20: burn from the zero address");
970 
971         _beforeTokenTransfer(account, address(0), amount);
972 
973         uint256 accountBalance = _balances[account];
974         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
975         _balances[account] = accountBalance - amount;
976         _totalSupply -= amount;
977 
978         emit Transfer(account, address(0), amount);
979     }
980 
981     /**
982      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
983      *
984      * This internal function is equivalent to `approve`, and can be used to
985      * e.g. set automatic allowances for certain subsystems, etc.
986      *
987      * Emits an {Approval} event.
988      *
989      * Requirements:
990      *
991      * - `owner` cannot be the zero address.
992      * - `spender` cannot be the zero address.
993      */
994     function _approve(address owner, address spender, uint256 amount) internal virtual {
995         require(owner != address(0), "ERC20: approve from the zero address");
996         require(spender != address(0), "ERC20: approve to the zero address");
997 
998         _allowances[owner][spender] = amount;
999         emit Approval(owner, spender, amount);
1000     }
1001 
1002     /**
1003      * @dev Hook that is called before any transfer of tokens. This includes
1004      * minting and burning.
1005      *
1006      * Calling conditions:
1007      *
1008      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1009      * will be to transferred to `to`.
1010      * - when `from` is zero, `amount` tokens will be minted for `to`.
1011      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1012      * - `from` and `to` are never both zero.
1013      *
1014      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1015      */
1016     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1017 }
1018 
1019 // File: elementix/TokenRecipient.sol
1020 
1021 
1022 pragma solidity ^0.8.0;
1023 
1024 
1025 
1026 contract TokenRecipient {
1027     event ReceivedEther(address indexed sender, uint256 amount);
1028     event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);
1029 
1030     /**
1031      * @dev Receive tokens and generate a log event
1032      * @param from Address from which to transfer tokens
1033      * @param value Amount of tokens to transfer
1034      * @param token Address of token
1035      * @param extraData Additional data to log
1036      */
1037     function receiveApproval(address from, uint256 value, address token, bytes memory extraData) public {
1038         ERC20 t = ERC20(token);
1039         require(t.transferFrom(from, address(this), value));
1040         emit ReceivedTokens(from, value, token, extraData);
1041     }
1042 
1043     /**
1044      * @dev Receive Ether and generate a log event
1045      */
1046     receive() payable external {
1047         emit ReceivedEther(msg.sender, msg.value);
1048     }
1049 }
1050 
1051 // File: dependencies/openzeppelin/contracts/access/Ownable.sol
1052 
1053 
1054 
1055 pragma solidity ^0.8.0;
1056 
1057 /**
1058  * @dev Contract module which provides a basic access control mechanism, where
1059  * there is an account (an owner) that can be granted exclusive access to
1060  * specific functions.
1061  *
1062  * By default, the owner account will be the one that deploys the contract. This
1063  * can later be changed with {transferOwnership}.
1064  *
1065  * This module is used through inheritance. It will make available the modifier
1066  * `onlyOwner`, which can be applied to your functions to restrict their use to
1067  * the owner.
1068  */
1069 abstract contract Ownable is Context {
1070     address private _owner;
1071 
1072     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1073 
1074     /**
1075      * @dev Initializes the contract setting the deployer as the initial owner.
1076      */
1077     constructor () {
1078         address msgSender = _msgSender();
1079         _owner = msgSender;
1080         emit OwnershipTransferred(address(0), msgSender);
1081     }
1082 
1083     /**
1084      * @dev Returns the address of the current owner.
1085      */
1086     function owner() public view virtual returns (address) {
1087         return _owner;
1088     }
1089 
1090     /**
1091      * @dev Throws if called by any account other than the owner.
1092      */
1093     modifier onlyOwner() {
1094         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1095         _;
1096     }
1097 
1098     /**
1099      * @dev Leaves the contract without owner. It will not be possible to call
1100      * `onlyOwner` functions anymore. Can only be called by the current owner.
1101      *
1102      * NOTE: Renouncing ownership will leave the contract without an owner,
1103      * thereby removing any functionality that is only available to the owner.
1104      */
1105     function renounceOwnership() public virtual onlyOwner {
1106         emit OwnershipTransferred(_owner, address(0));
1107         _owner = address(0);
1108     }
1109 
1110     /**
1111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1112      * Can only be called by the current owner.
1113      */
1114     function transferOwnership(address newOwner) public virtual onlyOwner {
1115         require(newOwner != address(0), "Ownable: new owner is the zero address");
1116         emit OwnershipTransferred(_owner, newOwner);
1117         _owner = newOwner;
1118     }
1119 }
1120 
1121 // File: elementix/ProxyRegistry.sol
1122 
1123 
1124 pragma solidity ^0.8.0;
1125 
1126 
1127 
1128 
1129 contract ProxyRegistry is Ownable {
1130 
1131     /* DelegateProxy implementation contract. Must be initialized. */
1132     address public delegateProxyImplementation;
1133 
1134     /* Authenticated proxies by user. */
1135     mapping(address => OwnableDelegateProxy) public proxies;
1136 
1137     /* Contracts pending access. */
1138     mapping(address => uint256) public pending;
1139 
1140     /* Contracts allowed to call those proxies. */
1141     mapping(address => bool) public contracts;
1142 
1143     /* Delay period for adding an authenticated contract.
1144        This mitigates a particular class of potential attack on the Elementix DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the ELT supply (votes in the DAO),
1145        a malicious but rational attacker could buy half the Elementix and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given one weeks, if that happened, users would have
1146        plenty of time to notice and transfer their assets.
1147     */
1148     uint256 public DELAY_PERIOD = 7 days;
1149 
1150     // event
1151     event RegisterProxy(address indexed sender, address proxyAddr);
1152     event AuthenticationOperation(address indexed addr, bool opt);
1153 
1154     /**
1155      * Start the process to enable access for specified contract. Subject to delay period.
1156      *
1157      * @dev ProxyRegistry owner only
1158      * @param addr Address to which to grant permissions
1159      */
1160     function startGrantAuthentication (address addr)
1161         public
1162         onlyOwner
1163     {
1164         require(!contracts[addr] && pending[addr] == 0);
1165         pending[addr] = block.timestamp;
1166     }
1167 
1168     /**
1169      * End the process to nable access for specified contract after delay period has passed.
1170      *
1171      * @dev ProxyRegistry owner only
1172      * @param addr Address to which to grant permissions
1173      */
1174     function endGrantAuthentication (address addr)
1175         public
1176         onlyOwner
1177     {
1178         require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < block.timestamp));
1179         pending[addr] = 0;
1180         contracts[addr] = true;
1181         emit AuthenticationOperation(addr, true);
1182     }
1183 
1184     /**
1185      * Revoke access for specified contract. Can be done instantly.
1186      *
1187      * @dev ProxyRegistry owner only
1188      * @param addr Address of which to revoke permissions
1189      */    
1190     function revokeAuthentication (address addr)
1191         public
1192         onlyOwner
1193     {
1194         contracts[addr] = false;
1195         emit AuthenticationOperation(addr, false);
1196     }
1197 
1198     /**
1199      * Register a proxy contract with this registry
1200      *
1201      * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy
1202      * @return proxy New AuthenticatedProxy contract
1203      */
1204     function registerProxy()
1205         public
1206         returns (OwnableDelegateProxy proxy)
1207     {
1208         require(address(proxies[msg.sender]) == address(0),"dup register");
1209         proxy = new OwnableDelegateProxy(msg.sender, delegateProxyImplementation, abi.encodeWithSignature("initialize(address,address)", msg.sender, address(this)));
1210         proxies[msg.sender] = proxy;
1211         emit RegisterProxy(msg.sender, address(proxy));
1212         return proxy;
1213     }
1214 
1215 }
1216 // File: elementix/AuthenticatedProxy.sol
1217 
1218 
1219 pragma solidity ^0.8.0;
1220 
1221 
1222 
1223 
1224 
1225 
1226 
1227 
1228 contract AuthenticatedProxy is TokenRecipient, OwnedUpgradeabilityStorage, IAuthenticatedProxy {
1229 
1230     /* Whether initialized. */
1231     bool initialized = false;
1232 
1233     /* Address which owns this proxy. */
1234     address public user;
1235 
1236     /* Associated registry with contract authentication information. */
1237     ProxyRegistry public registry;
1238 
1239     /* Whether access has been revoked. */
1240     bool public revoked;
1241 
1242     string public constant version = "1.0";
1243 
1244     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
1245     // enum HowToCall { Call, DelegateCall }
1246 
1247     /* Event fired when the proxy access is revoked or unrevoked. */
1248     event Revoked(bool revoked);
1249 
1250     /**
1251      * Initialize an AuthenticatedProxy
1252      *
1253      * @param addrUser Address of user on whose behalf this proxy will act
1254      * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy
1255      */
1256     function initialize (address addrUser, ProxyRegistry addrRegistry)
1257         public
1258     {
1259         require(!initialized);
1260         initialized = true;
1261         user = addrUser;
1262         registry = addrRegistry;
1263     }
1264 
1265     /**
1266      * Set the revoked flag (allows a user to revoke ProxyRegistry access)
1267      *
1268      * @dev Can be called by the user only
1269      * @param revoke Whether or not to revoke access
1270      */
1271     function setRevoke(bool revoke)
1272         public
1273     {
1274         require(msg.sender == user);
1275         revoked = revoke;
1276         emit Revoked(revoke);
1277     }
1278 
1279     /**
1280      * Execute a message call from the proxy contract
1281      *
1282      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
1283      * @param dest Address to which the call will be sent
1284      * @param howToCall Which kind of call to make
1285      * @param data Calldata to send
1286      * @return result Result of the call (success or failure)
1287      */
1288     function proxy(address dest, DataType.HowToCall howToCall, bytes calldata data)
1289         public
1290         override
1291         returns (bool result)
1292     {
1293         require(msg.sender == user || (!revoked && registry.contracts(msg.sender)), "!valid proxy sender");
1294         if (howToCall == DataType.HowToCall.Call) {
1295             (result,) = dest.call(data);
1296         } else if (howToCall == DataType.HowToCall.DelegateCall) {
1297             (result,) = dest.delegatecall(data);
1298         }
1299         return result;
1300     }
1301 
1302     /**
1303      * Execute a message call and assert success
1304      * 
1305      * @dev Same functionality as `proxy`, just asserts the return value
1306      * @param dest Address to which the call will be sent
1307      * @param howToCall What kind of call to make
1308      * @param data Calldata to send
1309      */
1310     function proxyAssert(address dest, DataType.HowToCall howToCall, bytes calldata data)
1311         public
1312         override
1313     {
1314         require(proxy(dest, howToCall, data));
1315     }
1316 
1317 }
1318 
1319 // File: elementix/ElementixRegistry.sol
1320 
1321 
1322 pragma solidity ^0.8.0;
1323 
1324 
1325 
1326 
1327 contract ElementixProxyRegistry is ProxyRegistry {
1328 
1329     string public constant name = "Elementix Proxy Registry";
1330     string public constant version = "1.0";
1331 
1332     /* Whether the initial auth address has been set. */
1333     bool public initialAddressSet = false;
1334 
1335     constructor ()
1336     {
1337         delegateProxyImplementation = address(new AuthenticatedProxy());
1338     }
1339 
1340     /** 
1341      * Grant authentication to the initial Exchange protocol contract
1342      *
1343      * @dev No delay, can only be called once - after that the standard registry process with a delay must be used
1344      * @param authAddress Address of the contract to grant authentication
1345      */
1346     function grantInitialAuthentication (address authAddress)
1347         onlyOwner
1348         public
1349     {
1350         require(!initialAddressSet,"!initialed");
1351         initialAddressSet = true;
1352         contracts[authAddress] = true;
1353     }
1354 
1355 }