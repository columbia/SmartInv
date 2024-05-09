1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 // SPDX-License-Identifier: MIT
84 
85 pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 // SPDX-License-Identifier: MIT
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
272         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
273         // for accounts without code, i.e. `keccak256('')`
274         bytes32 codehash;
275         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { codehash := extcodehash(account) }
278         return (codehash != accountHash && codehash != 0x0);
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @opengsn/gsn/contracts/utils/MinLibBytes.sol
388 
389 // SPDX-License-Identifier: MIT
390 // minimal bytes manipulation required by GSN
391 // a minimal subset from 0x/LibBytes
392 /* solhint-disable no-inline-assembly */
393 pragma solidity ^0.6.2;
394 
395 library MinLibBytes {
396 
397     //truncate the given parameter (in-place) if its length is above the given maximum length
398     // do nothing otherwise.
399     //NOTE: solidity warns unless the method is marked "pure", but it DOES modify its parameter.
400     function truncateInPlace(bytes memory data, uint256 maxlen) internal pure {
401         if (data.length > maxlen) {
402             assembly { mstore(data, maxlen) }
403         }
404     }
405 
406     /// @dev Reads an address from a position in a byte array.
407     /// @param b Byte array containing an address.
408     /// @param index Index in byte array of address.
409     /// @return result address from byte array.
410     function readAddress(
411         bytes memory b,
412         uint256 index
413     )
414         internal
415         pure
416         returns (address result)
417     {
418         require (b.length >= index + 20, "readAddress: data too short");
419 
420         // Add offset to index:
421         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
422         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
423         index += 20;
424 
425         // Read address from array memory
426         assembly {
427             // 1. Add index to address of bytes array
428             // 2. Load 32-byte word from memory
429             // 3. Apply 20-byte mask to obtain address
430             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
431         }
432         return result;
433     }
434 
435     function readBytes32(
436         bytes memory b,
437         uint256 index
438     )
439         internal
440         pure
441         returns (bytes32 result)
442     {
443         require(b.length >= index + 32, "readBytes32: data too short" );
444 
445         // Read the bytes32 from array memory
446         assembly {
447             result := mload(add(b, add(index,32)))
448         }
449         return result;
450     }
451 
452     /// @dev Reads a uint256 value from a position in a byte array.
453     /// @param b Byte array containing a uint256 value.
454     /// @param index Index in byte array of uint256 value.
455     /// @return result uint256 value from byte array.
456     function readUint256(
457         bytes memory b,
458         uint256 index
459     )
460         internal
461         pure
462         returns (uint256 result)
463     {
464         result = uint256(readBytes32(b, index));
465         return result;
466     }
467 
468     function readBytes4(
469         bytes memory b,
470         uint256 index
471     )
472         internal
473         pure
474         returns (bytes4 result)
475     {
476         require(b.length >= index + 4, "readBytes4: data too short");
477 
478         // Read the bytes4 from array memory
479         assembly {
480             result := mload(add(b, add(index,32)))
481             // Solidity does not require us to clean the trailing bytes.
482             // We do it anyway
483             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
484         }
485         return result;
486     }
487 }
488 
489 // File: @opengsn/gsn/contracts/interfaces/IRelayRecipient.sol
490 
491 // SPDX-License-Identifier:MIT
492 pragma solidity ^0.6.2;
493 
494 /**
495  * a contract must implement this interface in order to support relayed transaction.
496  * It is better to inherit the BaseRelayRecipient as its implementation.
497  */
498 abstract contract IRelayRecipient {
499 
500     /**
501      * return if the forwarder is trusted to forward relayed transactions to us.
502      * the forwarder is required to verify the sender's signature, and verify
503      * the call is not a replay.
504      */
505     function isTrustedForwarder(address forwarder) public virtual view returns(bool);
506 
507     /**
508      * return the sender of this call.
509      * if the call came through our trusted forwarder, then the real sender is appended as the last 20 bytes
510      * of the msg.data.
511      * otherwise, return `msg.sender`
512      * should be used in the contract anywhere instead of msg.sender
513      */
514     function _msgSender() internal virtual view returns (address payable);
515 
516     function versionRecipient() external virtual view returns (string memory);
517 }
518 
519 // File: @opengsn/gsn/contracts/BaseRelayRecipient.sol
520 
521 // SPDX-License-Identifier:MIT
522 pragma solidity ^0.6.2;
523 
524 
525 
526 /**
527  * A base contract to be inherited by any contract that want to receive relayed transactions
528  * A subclass must use "_msgSender()" instead of "msg.sender"
529  */
530 abstract contract BaseRelayRecipient is IRelayRecipient {
531 
532     /*
533      * Forwarder singleton we accept calls from
534      */
535     address internal trustedForwarder;
536 
537     function isTrustedForwarder(address forwarder) public override view returns(bool) {
538         return forwarder == trustedForwarder;
539     }
540 
541     /**
542      * return the sender of this call.
543      * if the call came through our trusted forwarder, return the original sender.
544      * otherwise, return `msg.sender`.
545      * should be used in the contract anywhere instead of msg.sender
546      */
547     function _msgSender() internal override virtual view returns (address payable) {
548         if (msg.data.length >= 24 && isTrustedForwarder(msg.sender)) {
549             // At this point we know that the sender is a trusted forwarder,
550             // so we trust that the last bytes of msg.data are the verified sender address.
551             // extract sender address from the end of msg.data
552             return address(uint160(MinLibBytes.readAddress(msg.data, msg.data.length - 20)));
553         }
554         return msg.sender;
555     }
556 }
557 
558 // File: contracts/common/OwnableBaseRelayRecipient.sol
559 
560 // SPDX-License-Identifier: MIT
561 
562 pragma solidity ^0.6.0;
563 
564 
565 /**
566  * @dev Contract module which provides a basic access control mechanism, where
567  * there is an account (an owner) that can be granted exclusive access to
568  * specific functions.
569  *
570  * By default, the owner account will be the one that deploys the contract. This
571  * can later be changed with {transferOwnership}.
572  *
573  * This module is used through inheritance. It will make available the modifier
574  * `onlyOwner`, which can be applied to your functions to restrict their use to
575  * the owner.
576  */
577 contract OwnableBaseRelayRecipient is BaseRelayRecipient {
578     address private _owner;
579 
580     event OwnershipTransferred(
581         address indexed previousOwner,
582         address indexed newOwner
583     );
584 
585     /**
586      * @dev Initializes the contract setting the deployer as the initial owner.
587      */
588     constructor() internal {
589         address msgSender = _msgSender();
590         _owner = msgSender;
591         emit OwnershipTransferred(address(0), msgSender);
592     }
593 
594     /**
595      * @dev Returns the address of the current owner.
596      */
597     function owner() public view returns (address) {
598         return _owner;
599     }
600 
601     /**
602      * @dev Throws if called by any account other than the owner.
603      */
604     modifier onlyOwner() {
605         require(_owner == _msgSender(), "Ownable: caller is not the owner");
606         _;
607     }
608 
609     /**
610      * @dev Leaves the contract without owner. It will not be possible to call
611      * `onlyOwner` functions anymore. Can only be called by the current owner.
612      *
613      * NOTE: Renouncing ownership will leave the contract without an owner,
614      * thereby removing any functionality that is only available to the owner.
615      */
616     function renounceOwnership() public virtual onlyOwner {
617         emit OwnershipTransferred(_owner, address(0));
618         _owner = address(0);
619     }
620 
621     /**
622      * @dev Transfers ownership of the contract to a new account (`newOwner`).
623      * Can only be called by the current owner.
624      */
625     function transferOwnership(address newOwner) public virtual onlyOwner {
626         require(
627             newOwner != address(0),
628             "Ownable: new owner is the zero address"
629         );
630         emit OwnershipTransferred(_owner, newOwner);
631         _owner = newOwner;
632     }
633 
634     // updates trusted forwarder (OpenGSN BaseRelayRecipient)
635     function changeTrustedForwarder(address forwarder) public onlyOwner() {
636         trustedForwarder = forwarder;
637     }
638 
639     function versionRecipient()
640         external
641         virtual
642         override
643         view
644         returns (string memory)
645     {
646         return "1";
647     }
648 }
649 
650 // File: contracts/common/ERC20.sol
651 
652 // SPDX-License-Identifier: MIT
653 
654 pragma solidity ^0.6.0;
655 
656 
657 
658 
659 
660 /**
661  * @dev Implementation of the {IERC20} interface.
662  *
663  * This implementation is agnostic to the way tokens are created. This means
664  * that a supply mechanism has to be added in a derived contract using {_mint}.
665  * For a generic mechanism see {ERC20PresetMinterPauser}.
666  *
667  * TIP: For a detailed writeup see our guide
668  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
669  * to implement supply mechanisms].
670  *
671  * We have followed general OpenZeppelin guidelines: functions revert instead
672  * of returning `false` on failure. This behavior is nonetheless conventional
673  * and does not conflict with the expectations of ERC20 applications.
674  *
675  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
676  * This allows applications to reconstruct the allowance for all accounts just
677  * by listening to said events. Other implementations of the EIP may not emit
678  * these events, as it isn't required by the specification.
679  *
680  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
681  * functions have been added to mitigate the well-known issues around setting
682  * allowances. See {IERC20-approve}.
683  */
684 contract ERC20 is OwnableBaseRelayRecipient, IERC20 {
685     using SafeMath for uint256;
686     using Address for address;
687 
688     mapping(address => uint256) private _balances;
689 
690     mapping(address => mapping(address => uint256)) private _allowances;
691 
692     uint256 private _totalSupply;
693 
694     string private _name;
695     string private _symbol;
696     uint8 private _decimals;
697 
698     /**
699      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
700      * a default value of 18.
701      *
702      * To select a different value for {decimals}, use {_setupDecimals}.
703      *
704      * All three of these values are immutable: they can only be set once during
705      * construction.
706      */
707     constructor(string memory name, string memory symbol) public {
708         _name = name;
709         _symbol = symbol;
710         _decimals = 18;
711     }
712 
713     /**
714      * @dev Returns the name of the token.
715      */
716     function name() public view returns (string memory) {
717         return _name;
718     }
719 
720     /**
721      * @dev Returns the symbol of the token, usually a shorter version of the
722      * name.
723      */
724     function symbol() public view returns (string memory) {
725         return _symbol;
726     }
727 
728     /**
729      * @dev Returns the number of decimals used to get its user representation.
730      * For example, if `decimals` equals `2`, a balance of `505` tokens should
731      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
732      *
733      * Tokens usually opt for a value of 18, imitating the relationship between
734      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
735      * called.
736      *
737      * NOTE: This information is only used for _display_ purposes: it in
738      * no way affects any of the arithmetic of the contract, including
739      * {IERC20-balanceOf} and {IERC20-transfer}.
740      */
741     function decimals() public view returns (uint8) {
742         return _decimals;
743     }
744 
745     /**
746      * @dev See {IERC20-totalSupply}.
747      */
748     function totalSupply() public override view returns (uint256) {
749         return _totalSupply;
750     }
751 
752     /**
753      * @dev See {IERC20-balanceOf}.
754      */
755     function balanceOf(address account) public override view returns (uint256) {
756         return _balances[account];
757     }
758 
759     /**
760      * @dev See {IERC20-transfer}.
761      *
762      * Requirements:
763      *
764      * - `recipient` cannot be the zero address.
765      * - the caller must have a balance of at least `amount`.
766      */
767     function transfer(address recipient, uint256 amount)
768         public
769         virtual
770         override
771         returns (bool)
772     {
773         _transfer(_msgSender(), recipient, amount);
774         return true;
775     }
776 
777     /**
778      * @dev See {IERC20-allowance}.
779      */
780     function allowance(address owner, address spender)
781         public
782         virtual
783         override
784         view
785         returns (uint256)
786     {
787         return _allowances[owner][spender];
788     }
789 
790     /**
791      * @dev See {IERC20-approve}.
792      *
793      * Requirements:
794      *
795      * - `spender` cannot be the zero address.
796      */
797     function approve(address spender, uint256 amount)
798         public
799         virtual
800         override
801         returns (bool)
802     {
803         _approve(_msgSender(), spender, amount);
804         return true;
805     }
806 
807     /**
808      * @dev See {IERC20-transferFrom}.
809      *
810      * Emits an {Approval} event indicating the updated allowance. This is not
811      * required by the EIP. See the note at the beginning of {ERC20};
812      *
813      * Requirements:
814      * - `sender` and `recipient` cannot be the zero address.
815      * - `sender` must have a balance of at least `amount`.
816      * - the caller must have allowance for ``sender``'s tokens of at least
817      * `amount`.
818      */
819     function transferFrom(
820         address sender,
821         address recipient,
822         uint256 amount
823     ) public virtual override returns (bool) {
824         _transfer(sender, recipient, amount);
825         _approve(
826             sender,
827             _msgSender(),
828             _allowances[sender][_msgSender()].sub(
829                 amount,
830                 "ERC20: transfer amount exceeds allowance"
831             )
832         );
833         return true;
834     }
835 
836     /**
837      * @dev Atomically increases the allowance granted to `spender` by the caller.
838      *
839      * This is an alternative to {approve} that can be used as a mitigation for
840      * problems described in {IERC20-approve}.
841      *
842      * Emits an {Approval} event indicating the updated allowance.
843      *
844      * Requirements:
845      *
846      * - `spender` cannot be the zero address.
847      */
848     function increaseAllowance(address spender, uint256 addedValue)
849         public
850         virtual
851         returns (bool)
852     {
853         _approve(
854             _msgSender(),
855             spender,
856             _allowances[_msgSender()][spender].add(addedValue)
857         );
858         return true;
859     }
860 
861     /**
862      * @dev Atomically decreases the allowance granted to `spender` by the caller.
863      *
864      * This is an alternative to {approve} that can be used as a mitigation for
865      * problems described in {IERC20-approve}.
866      *
867      * Emits an {Approval} event indicating the updated allowance.
868      *
869      * Requirements:
870      *
871      * - `spender` cannot be the zero address.
872      * - `spender` must have allowance for the caller of at least
873      * `subtractedValue`.
874      */
875     function decreaseAllowance(address spender, uint256 subtractedValue)
876         public
877         virtual
878         returns (bool)
879     {
880         _approve(
881             _msgSender(),
882             spender,
883             _allowances[_msgSender()][spender].sub(
884                 subtractedValue,
885                 "ERC20: decreased allowance below zero"
886             )
887         );
888         return true;
889     }
890 
891     /**
892      * @dev Moves tokens `amount` from `sender` to `recipient`.
893      *
894      * This is internal function is equivalent to {transfer}, and can be used to
895      * e.g. implement automatic token fees, slashing mechanisms, etc.
896      *
897      * Emits a {Transfer} event.
898      *
899      * Requirements:
900      *
901      * - `sender` cannot be the zero address.
902      * - `recipient` cannot be the zero address.
903      * - `sender` must have a balance of at least `amount`.
904      */
905     function _transfer(
906         address sender,
907         address recipient,
908         uint256 amount
909     ) internal virtual {
910         require(sender != address(0), "ERC20: transfer from the zero address");
911         require(recipient != address(0), "ERC20: transfer to the zero address");
912 
913         _beforeTokenTransfer(sender, recipient, amount);
914 
915         _balances[sender] = _balances[sender].sub(
916             amount,
917             "ERC20: transfer amount exceeds balance"
918         );
919         _balances[recipient] = _balances[recipient].add(amount);
920         emit Transfer(sender, recipient, amount);
921     }
922 
923     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
924      * the total supply.
925      *
926      * Emits a {Transfer} event with `from` set to the zero address.
927      *
928      * Requirements
929      *
930      * - `to` cannot be the zero address.
931      */
932     function _mint(address account, uint256 amount) internal virtual {
933         require(account != address(0), "ERC20: mint to the zero address");
934 
935         _beforeTokenTransfer(address(0), account, amount);
936 
937         _totalSupply = _totalSupply.add(amount);
938         _balances[account] = _balances[account].add(amount);
939         emit Transfer(address(0), account, amount);
940     }
941 
942     /**
943      * @dev Destroys `amount` tokens from `account`, reducing the
944      * total supply.
945      *
946      * Emits a {Transfer} event with `to` set to the zero address.
947      *
948      * Requirements
949      *
950      * - `account` cannot be the zero address.
951      * - `account` must have at least `amount` tokens.
952      */
953     function _burn(address account, uint256 amount) internal virtual {
954         require(account != address(0), "ERC20: burn from the zero address");
955 
956         _beforeTokenTransfer(account, address(0), amount);
957 
958         _balances[account] = _balances[account].sub(
959             amount,
960             "ERC20: burn amount exceeds balance"
961         );
962         _totalSupply = _totalSupply.sub(amount);
963         emit Transfer(account, address(0), amount);
964     }
965 
966     /**
967      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
968      *
969      * This is internal function is equivalent to `approve`, and can be used to
970      * e.g. set automatic allowances for certain subsystems, etc.
971      *
972      * Emits an {Approval} event.
973      *
974      * Requirements:
975      *
976      * - `owner` cannot be the zero address.
977      * - `spender` cannot be the zero address.
978      */
979     function _approve(
980         address owner,
981         address spender,
982         uint256 amount
983     ) internal virtual {
984         require(owner != address(0), "ERC20: approve from the zero address");
985         require(spender != address(0), "ERC20: approve to the zero address");
986 
987         _allowances[owner][spender] = amount;
988         emit Approval(owner, spender, amount);
989     }
990 
991     /**
992      * @dev Sets {decimals} to a value other than the default one of 18.
993      *
994      * WARNING: This function should only be called from the constructor. Most
995      * applications that interact with token contracts will not expect
996      * {decimals} to ever change, and may work incorrectly if it does.
997      */
998     function _setupDecimals(uint8 decimals_) internal {
999         _decimals = decimals_;
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
1016     function _beforeTokenTransfer(
1017         address from,
1018         address to,
1019         uint256 amount
1020     ) internal virtual {}
1021 }
1022 
1023 // File: contracts/common/ERC20Burnable.sol
1024 
1025 // SPDX-License-Identifier: MIT
1026 
1027 pragma solidity ^0.6.0;
1028 
1029 
1030 /**
1031  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1032  * tokens and those that they have an allowance for, in a way that can be
1033  * recognized off-chain (via event analysis).
1034  */
1035 abstract contract ERC20Burnable is ERC20 {
1036     /**
1037      * @dev Destroys `amount` tokens from the caller.
1038      *
1039      * See {ERC20-_burn}.
1040      */
1041     function burn(uint256 amount) public virtual {
1042         _burn(_msgSender(), amount);
1043     }
1044 
1045     /**
1046      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1047      * allowance.
1048      *
1049      * See {ERC20-_burn} and {ERC20-allowance}.
1050      *
1051      * Requirements:
1052      *
1053      * - the caller must have allowance for ``accounts``'s tokens of at least
1054      * `amount`.
1055      */
1056     function burnFrom(address account, uint256 amount) public virtual {
1057         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(
1058             amount,
1059             "ERC20: burn amount exceeds allowance"
1060         );
1061 
1062         _approve(account, _msgSender(), decreasedAllowance);
1063         _burn(account, amount);
1064     }
1065 }
1066 
1067 // File: erc20/root/IGGToken.sol
1068 
1069 // SPDX-License-Identifier: UNLICENSED
1070 pragma solidity ^0.6.2;
1071 
1072 
1073 contract IGGToken is ERC20Burnable {
1074     constructor(uint256 initialSupply) public ERC20("IG Gold", "IGG") {
1075         _setupDecimals(6);
1076         _mint(msg.sender, initialSupply);
1077     }
1078 }