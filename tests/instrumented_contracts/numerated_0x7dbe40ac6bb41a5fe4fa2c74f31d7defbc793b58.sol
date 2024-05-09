1 // File: @pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.4.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, 'SafeMath: addition overflow');
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, 'SafeMath: subtraction overflow');
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(
63         uint256 a,
64         uint256 b,
65         string memory errorMessage
66     ) internal pure returns (uint256) {
67         require(b <= a, errorMessage);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the multiplication of two unsigned integers, reverting on
75      * overflow.
76      *
77      * Counterpart to Solidity's `*` operator.
78      *
79      * Requirements:
80      *
81      * - Multiplication cannot overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, 'SafeMath: multiplication overflow');
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the integer division of two unsigned integers. Reverts on
99      * division by zero. The result is rounded towards zero.
100      *
101      * Counterpart to Solidity's `/` operator. Note: this function uses a
102      * `revert` opcode (which leaves remaining gas untouched) while Solidity
103      * uses an invalid opcode to revert (consuming all remaining gas).
104      *
105      * Requirements:
106      *
107      * - The divisor cannot be zero.
108      */
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, 'SafeMath: division by zero');
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator. Note: this function uses a
118      * `revert` opcode (which leaves remaining gas untouched) while Solidity
119      * uses an invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function div(
126         uint256 a,
127         uint256 b,
128         string memory errorMessage
129     ) internal pure returns (uint256) {
130         require(b > 0, errorMessage);
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return mod(a, b, 'SafeMath: modulo by zero');
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts with custom message when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(
166         uint256 a,
167         uint256 b,
168         string memory errorMessage
169     ) internal pure returns (uint256) {
170         require(b != 0, errorMessage);
171         return a % b;
172     }
173 
174     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
175         z = x < y ? x : y;
176     }
177 
178     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
179     function sqrt(uint256 y) internal pure returns (uint256 z) {
180         if (y > 3) {
181             z = y;
182             uint256 x = y / 2 + 1;
183             while (x < z) {
184                 z = x;
185                 x = (y / x + x) / 2;
186             }
187         } else if (y != 0) {
188             z = 1;
189         }
190     }
191 }
192 
193 // File: @pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol
194 
195 
196 pragma solidity >=0.4.0;
197 
198 interface IBEP20 {
199     /**
200      * @dev Returns the amount of tokens in existence.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns the token decimals.
206      */
207     function decimals() external view returns (uint8);
208 
209     /**
210      * @dev Returns the token symbol.
211      */
212     function symbol() external view returns (string memory);
213 
214     /**
215      * @dev Returns the token name.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the bep token owner.
221      */
222     function getOwner() external view returns (address);
223 
224     /**
225      * @dev Returns the amount of tokens owned by `account`.
226      */
227     function balanceOf(address account) external view returns (uint256);
228 
229     /**
230      * @dev Moves `amount` tokens from the caller's account to `recipient`.
231      *
232      * Returns a boolean value indicating whether the operation succeeded.
233      *
234      * Emits a {Transfer} event.
235      */
236     function transfer(address recipient, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Returns the remaining number of tokens that `spender` will be
240      * allowed to spend on behalf of `owner` through {transferFrom}. This is
241      * zero by default.
242      *
243      * This value changes when {approve} or {transferFrom} are called.
244      */
245     function allowance(address _owner, address spender) external view returns (uint256);
246 
247     /**
248      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
249      *
250      * Returns a boolean value indicating whether the operation succeeded.
251      *
252      * IMPORTANT: Beware that changing an allowance with this method brings the risk
253      * that someone may use both the old and the new allowance by unfortunate
254      * transaction ordering. One possible solution to mitigate this race
255      * condition is to first reduce the spender's allowance to 0 and set the
256      * desired value afterwards:
257      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258      *
259      * Emits an {Approval} event.
260      */
261     function approve(address spender, uint256 amount) external returns (bool);
262 
263     /**
264      * @dev Moves `amount` tokens from `sender` to `recipient` using the
265      * allowance mechanism. `amount` is then deducted from the caller's
266      * allowance.
267      *
268      * Returns a boolean value indicating whether the operation succeeded.
269      *
270      * Emits a {Transfer} event.
271      */
272     function transferFrom(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) external returns (bool);
277 
278     /**
279      * @dev Emitted when `value` tokens are moved from one account (`from`) to
280      * another (`to`).
281      *
282      * Note that `value` may be zero.
283      */
284     event Transfer(address indexed from, address indexed to, uint256 value);
285 
286     /**
287      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
288      * a call to {approve}. `value` is the new allowance.
289      */
290     event Approval(address indexed owner, address indexed spender, uint256 value);
291 }
292 
293 // File: @pancakeswap/pancake-swap-lib/contracts/utils/Address.sol
294 
295 
296 pragma solidity ^0.6.2;
297 
298 /**
299  * @dev Collection of functions related to the address type
300  */
301 library Address {
302     /**
303      * @dev Returns true if `account` is a contract.
304      *
305      * [IMPORTANT]
306      * ====
307      * It is unsafe to assume that an address for which this function returns
308      * false is an externally-owned account (EOA) and not a contract.
309      *
310      * Among others, `isContract` will return false for the following
311      * types of addresses:
312      *
313      *  - an externally-owned account
314      *  - a contract in construction
315      *  - an address where a contract will be created
316      *  - an address where a contract lived, but was destroyed
317      * ====
318      */
319     function isContract(address account) internal view returns (bool) {
320         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
321         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
322         // for accounts without code, i.e. `keccak256('')`
323         bytes32 codehash;
324         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
325         // solhint-disable-next-line no-inline-assembly
326         assembly {
327             codehash := extcodehash(account)
328         }
329         return (codehash != accountHash && codehash != 0x0);
330     }
331 
332     /**
333      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
334      * `recipient`, forwarding all available gas and reverting on errors.
335      *
336      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
337      * of certain opcodes, possibly making contracts go over the 2300 gas limit
338      * imposed by `transfer`, making them unable to receive funds via
339      * `transfer`. {sendValue} removes this limitation.
340      *
341      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
342      *
343      * IMPORTANT: because control is transferred to `recipient`, care must be
344      * taken to not create reentrancy vulnerabilities. Consider using
345      * {ReentrancyGuard} or the
346      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
347      */
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, 'Address: insufficient balance');
350 
351         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
352         (bool success, ) = recipient.call{value: amount}('');
353         require(success, 'Address: unable to send value, recipient may have reverted');
354     }
355 
356     /**
357      * @dev Performs a Solidity function call using a low level `call`. A
358      * plain`call` is an unsafe replacement for a function call: use this
359      * function instead.
360      *
361      * If `target` reverts with a revert reason, it is bubbled up by this
362      * function (like regular Solidity function calls).
363      *
364      * Returns the raw returned data. To convert to the expected return value,
365      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
366      *
367      * Requirements:
368      *
369      * - `target` must be a contract.
370      * - calling `target` with `data` must not revert.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
375         return functionCall(target, data, 'Address: low-level call failed');
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
380      * `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         return _functionCallWithValue(target, data, 0, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but also transferring `value` wei to `target`.
395      *
396      * Requirements:
397      *
398      * - the calling contract must have an ETH balance of at least `value`.
399      * - the called Solidity function must be `payable`.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(
404         address target,
405         bytes memory data,
406         uint256 value
407     ) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
413      * with `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         require(address(this).balance >= value, 'Address: insufficient balance for call');
424         return _functionCallWithValue(target, data, value, errorMessage);
425     }
426 
427     function _functionCallWithValue(
428         address target,
429         bytes memory data,
430         uint256 weiValue,
431         string memory errorMessage
432     ) private returns (bytes memory) {
433         require(isContract(target), 'Address: call to non-contract');
434 
435         // solhint-disable-next-line avoid-low-level-calls
436         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
437         if (success) {
438             return returndata;
439         } else {
440             // Look for revert reason and bubble it up if present
441             if (returndata.length > 0) {
442                 // The easiest way to bubble the revert reason is using memory via assembly
443 
444                 // solhint-disable-next-line no-inline-assembly
445                 assembly {
446                     let returndata_size := mload(returndata)
447                     revert(add(32, returndata), returndata_size)
448                 }
449             } else {
450                 revert(errorMessage);
451             }
452         }
453     }
454 }
455 
456 // File: @pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol
457 
458 
459 pragma solidity ^0.6.0;
460 
461 
462 
463 
464 /**
465  * @title SafeBEP20
466  * @dev Wrappers around BEP20 operations that throw on failure (when the token
467  * contract returns false). Tokens that return no value (and instead revert or
468  * throw on failure) are also supported, non-reverting calls are assumed to be
469  * successful.
470  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
471  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
472  */
473 library SafeBEP20 {
474     using SafeMath for uint256;
475     using Address for address;
476 
477     function safeTransfer(
478         IBEP20 token,
479         address to,
480         uint256 value
481     ) internal {
482         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
483     }
484 
485     function safeTransferFrom(
486         IBEP20 token,
487         address from,
488         address to,
489         uint256 value
490     ) internal {
491         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
492     }
493 
494     /**
495      * @dev Deprecated. This function has issues similar to the ones found in
496      * {IBEP20-approve}, and its usage is discouraged.
497      *
498      * Whenever possible, use {safeIncreaseAllowance} and
499      * {safeDecreaseAllowance} instead.
500      */
501     function safeApprove(
502         IBEP20 token,
503         address spender,
504         uint256 value
505     ) internal {
506         // safeApprove should only be called when setting an initial allowance,
507         // or when resetting it to zero. To increase and decrease it, use
508         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
509         // solhint-disable-next-line max-line-length
510         require(
511             (value == 0) || (token.allowance(address(this), spender) == 0),
512             'SafeBEP20: approve from non-zero to non-zero allowance'
513         );
514         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
515     }
516 
517     function safeIncreaseAllowance(
518         IBEP20 token,
519         address spender,
520         uint256 value
521     ) internal {
522         uint256 newAllowance = token.allowance(address(this), spender).add(value);
523         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
524     }
525 
526     function safeDecreaseAllowance(
527         IBEP20 token,
528         address spender,
529         uint256 value
530     ) internal {
531         uint256 newAllowance = token.allowance(address(this), spender).sub(
532             value,
533             'SafeBEP20: decreased allowance below zero'
534         );
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536     }
537 
538     /**
539      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
540      * on the return value: the return value is optional (but if data is returned, it must not be false).
541      * @param token The token targeted by the call.
542      * @param data The call data (encoded using abi.encode or one of its variants).
543      */
544     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
545         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
546         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
547         // the target address contains contract code and also asserts for success in the low-level call.
548 
549         bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
550         if (returndata.length > 0) {
551             // Return data is optional
552             // solhint-disable-next-line max-line-length
553             require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
554         }
555     }
556 }
557 
558 // File: @pancakeswap/pancake-swap-lib/contracts/GSN/Context.sol
559 
560 
561 pragma solidity >=0.4.0;
562 
563 /*
564  * @dev Provides information about the current execution context, including the
565  * sender of the transaction and its data. While these are generally available
566  * via msg.sender and msg.data, they should not be accessed in such a direct
567  * manner, since when dealing with GSN meta-transactions the account sending and
568  * paying for execution may not be the actual sender (as far as an application
569  * is concerned).
570  *
571  * This contract is only required for intermediate, library-like contracts.
572  */
573 contract Context {
574     // Empty internal constructor, to prevent people from mistakenly deploying
575     // an instance of this contract, which should be used via inheritance.
576     constructor() internal {}
577 
578     function _msgSender() internal view returns (address payable) {
579         return msg.sender;
580     }
581 
582     function _msgData() internal view returns (bytes memory) {
583         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
584         return msg.data;
585     }
586 }
587 
588 // File: @pancakeswap/pancake-swap-lib/contracts/access/Ownable.sol
589 
590 
591 pragma solidity >=0.4.0;
592 
593 
594 /**
595  * @dev Contract module which provides a basic access control mechanism, where
596  * there is an account (an owner) that can be granted exclusive access to
597  * specific functions.
598  *
599  * By default, the owner account will be the one that deploys the contract. This
600  * can later be changed with {transferOwnership}.
601  *
602  * This module is used through inheritance. It will make available the modifier
603  * `onlyOwner`, which can be applied to your functions to restrict their use to
604  * the owner.
605  */
606 contract Ownable is Context {
607     address private _owner;
608 
609     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
610 
611     /**
612      * @dev Initializes the contract setting the deployer as the initial owner.
613      */
614     constructor() internal {
615         address msgSender = _msgSender();
616         _owner = msgSender;
617         emit OwnershipTransferred(address(0), msgSender);
618     }
619 
620     /**
621      * @dev Returns the address of the current owner.
622      */
623     function owner() public view returns (address) {
624         return _owner;
625     }
626 
627     /**
628      * @dev Throws if called by any account other than the owner.
629      */
630     modifier onlyOwner() {
631         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
632         _;
633     }
634 
635     /**
636      * @dev Leaves the contract without owner. It will not be possible to call
637      * `onlyOwner` functions anymore. Can only be called by the current owner.
638      *
639      * NOTE: Renouncing ownership will leave the contract without an owner,
640      * thereby removing any functionality that is only available to the owner.
641      */
642     function renounceOwnership() public onlyOwner {
643         emit OwnershipTransferred(_owner, address(0));
644         _owner = address(0);
645     }
646 
647     /**
648      * @dev Transfers ownership of the contract to a new account (`newOwner`).
649      * Can only be called by the current owner.
650      */
651     function transferOwnership(address newOwner) public onlyOwner {
652         _transferOwnership(newOwner);
653     }
654 
655     /**
656      * @dev Transfers ownership of the contract to a new account (`newOwner`).
657      */
658     function _transferOwnership(address newOwner) internal {
659         require(newOwner != address(0), 'Ownable: new owner is the zero address');
660         emit OwnershipTransferred(_owner, newOwner);
661         _owner = newOwner;
662     }
663 }
664 
665 // File: @pancakeswap/pancake-swap-lib/contracts/token/BEP20/BEP20.sol
666 
667 
668 pragma solidity >=0.4.0;
669 
670 
671 
672 
673 
674 
675 /**
676  * @dev Implementation of the {IBEP20} interface.
677  *
678  * This implementation is agnostic to the way tokens are created. This means
679  * that a supply mechanism has to be added in a derived contract using {_mint}.
680  * For a generic mechanism see {BEP20PresetMinterPauser}.
681  *
682  * TIP: For a detailed writeup see our guide
683  * https://forum.zeppelin.solutions/t/how-to-implement-BEP20-supply-mechanisms/226[How
684  * to implement supply mechanisms].
685  *
686  * We have followed general OpenZeppelin guidelines: functions revert instead
687  * of returning `false` on failure. This behavior is nonetheless conventional
688  * and does not conflict with the expectations of BEP20 applications.
689  *
690  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
691  * This allows applications to reconstruct the allowance for all accounts just
692  * by listening to said events. Other implementations of the EIP may not emit
693  * these events, as it isn't required by the specification.
694  *
695  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
696  * functions have been added to mitigate the well-known issues around setting
697  * allowances. See {IBEP20-approve}.
698  */
699 contract BEP20 is Context, IBEP20, Ownable {
700     using SafeMath for uint256;
701     using Address for address;
702 
703     mapping(address => uint256) private _balances;
704 
705     mapping(address => mapping(address => uint256)) private _allowances;
706 
707     uint256 private _totalSupply;
708 
709     string private _name;
710     string private _symbol;
711     uint8 private _decimals;
712 
713     /**
714      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
715      * a default value of 18.
716      *
717      * To select a different value for {decimals}, use {_setupDecimals}.
718      *
719      * All three of these values are immutable: they can only be set once during
720      * construction.
721      */
722     constructor(string memory name, string memory symbol) public {
723         _name = name;
724         _symbol = symbol;
725         _decimals = 18;
726     }
727 
728     /**
729      * @dev Returns the bep token owner.
730      */
731     function getOwner() external override view returns (address) {
732         return owner();
733     }
734 
735     /**
736      * @dev Returns the token name.
737      */
738     function name() public override view returns (string memory) {
739         return _name;
740     }
741 
742     /**
743      * @dev Returns the token decimals.
744      */
745     function decimals() public override view returns (uint8) {
746         return _decimals;
747     }
748 
749     /**
750      * @dev Returns the token symbol.
751      */
752     function symbol() public override view returns (string memory) {
753         return _symbol;
754     }
755 
756     /**
757      * @dev See {BEP20-totalSupply}.
758      */
759     function totalSupply() public override view returns (uint256) {
760         return _totalSupply;
761     }
762 
763     /**
764      * @dev See {BEP20-balanceOf}.
765      */
766     function balanceOf(address account) public override view returns (uint256) {
767         return _balances[account];
768     }
769 
770     /**
771      * @dev See {BEP20-transfer}.
772      *
773      * Requirements:
774      *
775      * - `recipient` cannot be the zero address.
776      * - the caller must have a balance of at least `amount`.
777      */
778     function transfer(address recipient, uint256 amount) public override returns (bool) {
779         _transfer(_msgSender(), recipient, amount);
780         return true;
781     }
782 
783     /**
784      * @dev See {BEP20-allowance}.
785      */
786     function allowance(address owner, address spender) public override view returns (uint256) {
787         return _allowances[owner][spender];
788     }
789 
790     /**
791      * @dev See {BEP20-approve}.
792      *
793      * Requirements:
794      *
795      * - `spender` cannot be the zero address.
796      */
797     function approve(address spender, uint256 amount) public override returns (bool) {
798         _approve(_msgSender(), spender, amount);
799         return true;
800     }
801 
802     /**
803      * @dev See {BEP20-transferFrom}.
804      *
805      * Emits an {Approval} event indicating the updated allowance. This is not
806      * required by the EIP. See the note at the beginning of {BEP20};
807      *
808      * Requirements:
809      * - `sender` and `recipient` cannot be the zero address.
810      * - `sender` must have a balance of at least `amount`.
811      * - the caller must have allowance for `sender`'s tokens of at least
812      * `amount`.
813      */
814     function transferFrom(
815         address sender,
816         address recipient,
817         uint256 amount
818     ) public override returns (bool) {
819         _transfer(sender, recipient, amount);
820         _approve(
821             sender,
822             _msgSender(),
823             _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
824         );
825         return true;
826     }
827 
828     /**
829      * @dev Atomically increases the allowance granted to `spender` by the caller.
830      *
831      * This is an alternative to {approve} that can be used as a mitigation for
832      * problems described in {BEP20-approve}.
833      *
834      * Emits an {Approval} event indicating the updated allowance.
835      *
836      * Requirements:
837      *
838      * - `spender` cannot be the zero address.
839      */
840     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
841         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
842         return true;
843     }
844 
845     /**
846      * @dev Atomically decreases the allowance granted to `spender` by the caller.
847      *
848      * This is an alternative to {approve} that can be used as a mitigation for
849      * problems described in {BEP20-approve}.
850      *
851      * Emits an {Approval} event indicating the updated allowance.
852      *
853      * Requirements:
854      *
855      * - `spender` cannot be the zero address.
856      * - `spender` must have allowance for the caller of at least
857      * `subtractedValue`.
858      */
859     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
860         _approve(
861             _msgSender(),
862             spender,
863             _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero')
864         );
865         return true;
866     }
867 
868     /**
869      * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
870      * the total supply.
871      *
872      * Requirements
873      *
874      * - `msg.sender` must be the token owner
875      */
876     function mint(uint256 amount) public onlyOwner returns (bool) {
877         _mint(_msgSender(), amount);
878         return true;
879     }
880 
881     /**
882      * @dev Moves tokens `amount` from `sender` to `recipient`.
883      *
884      * This is internal function is equivalent to {transfer}, and can be used to
885      * e.g. implement automatic token fees, slashing mechanisms, etc.
886      *
887      * Emits a {Transfer} event.
888      *
889      * Requirements:
890      *
891      * - `sender` cannot be the zero address.
892      * - `recipient` cannot be the zero address.
893      * - `sender` must have a balance of at least `amount`.
894      */
895     function _transfer(
896         address sender,
897         address recipient,
898         uint256 amount
899     ) internal {
900         require(sender != address(0), 'BEP20: transfer from the zero address');
901         require(recipient != address(0), 'BEP20: transfer to the zero address');
902 
903         _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
904         _balances[recipient] = _balances[recipient].add(amount);
905         emit Transfer(sender, recipient, amount);
906     }
907 
908     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
909      * the total supply.
910      *
911      * Emits a {Transfer} event with `from` set to the zero address.
912      *
913      * Requirements
914      *
915      * - `to` cannot be the zero address.
916      */
917     function _mint(address account, uint256 amount) internal {
918         require(account != address(0), 'BEP20: mint to the zero address');
919 
920         _totalSupply = _totalSupply.add(amount);
921         _balances[account] = _balances[account].add(amount);
922         emit Transfer(address(0), account, amount);
923     }
924 
925     /**
926      * @dev Destroys `amount` tokens from `account`, reducing the
927      * total supply.
928      *
929      * Emits a {Transfer} event with `to` set to the zero address.
930      *
931      * Requirements
932      *
933      * - `account` cannot be the zero address.
934      * - `account` must have at least `amount` tokens.
935      */
936     function _burn(address account, uint256 amount) internal {
937         require(account != address(0), 'BEP20: burn from the zero address');
938 
939         _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
940         _totalSupply = _totalSupply.sub(amount);
941         emit Transfer(account, address(0), amount);
942     }
943 
944     /**
945      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
946      *
947      * This is internal function is equivalent to `approve`, and can be used to
948      * e.g. set automatic allowances for certain subsystems, etc.
949      *
950      * Emits an {Approval} event.
951      *
952      * Requirements:
953      *
954      * - `owner` cannot be the zero address.
955      * - `spender` cannot be the zero address.
956      */
957     function _approve(
958         address owner,
959         address spender,
960         uint256 amount
961     ) internal {
962         require(owner != address(0), 'BEP20: approve from the zero address');
963         require(spender != address(0), 'BEP20: approve to the zero address');
964 
965         _allowances[owner][spender] = amount;
966         emit Approval(owner, spender, amount);
967     }
968 
969     /**
970      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
971      * from the caller's allowance.
972      *
973      * See {_burn} and {_approve}.
974      */
975     function _burnFrom(address account, uint256 amount) internal {
976         _burn(account, amount);
977         _approve(
978             account,
979             _msgSender(),
980             _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance')
981         );
982     }
983 }
984 
985 // File: contracts/Token.sol
986 
987 pragma solidity 0.6.12;
988 
989 
990 // Token with Governance
991 contract Token is BEP20 {
992 
993     uint256 public maxSupply;
994 
995     constructor(string memory _name, string memory _symbol, uint256 _maxSupply, uint256 _initialSupply, address _holder)
996         BEP20(_name, _symbol)
997         public
998     {
999         require(_initialSupply <= _maxSupply, "Token: cap exceeded");
1000 
1001         maxSupply = _maxSupply;
1002 
1003         _mint(_holder, _initialSupply);
1004     }
1005 
1006     /// @dev Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1007     function mint(address _to, uint256 _amount)
1008         public
1009         onlyOwner
1010     {
1011         require(totalSupply() + _amount <= maxSupply, "Token: cap exceeded");
1012 
1013         _mint(_to, _amount);
1014     }
1015 
1016 }
1017 
1018 // File: contracts/MasterChef.sol
1019 
1020 pragma solidity 0.6.12;
1021 
1022 
1023 
1024 
1025 
1026 
1027 // MasterChef is the master of Token. He can make Token and he is a fair guy.
1028 //
1029 // Note that it's ownable and the owner wields tremendous power. The ownership
1030 // will be transferred to a governance smart contract once TOKEN is sufficiently
1031 // distributed and the community can show to govern itself.
1032 //
1033 // Have fun reading it. Hopefully it's bug-free. God bless.
1034 contract MasterChef is Ownable {
1035 
1036     using SafeMath for uint256;
1037     using SafeBEP20 for IBEP20;
1038 
1039     // Info of each user.
1040     struct UserInfo {
1041         uint256 amount;         // How many LP tokens the user has provided.
1042         uint256 rewardDebt;     // Reward debt. See explanation below.
1043                                 //
1044                                 // We do some fancy math here. Basically, any point in time, the amount of TOKENs
1045                                 // entitled to a user but is pending to be distributed is:
1046                                 //
1047                                 //   pending reward = (user.amount * pool.accTokenPerShare) - user.rewardDebt
1048                                 //
1049                                 // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1050                                 //   1. The pool's `accTokenPerShare` (and `lastRewardBlock`) gets updated.
1051                                 //   2. User receives the pending reward sent to his/her address.
1052                                 //   3. User's `amount` gets updated.
1053                                 //   4. User's `rewardDebt` gets updated.
1054     }
1055 
1056     // Info of each pool.
1057     struct PoolInfo {
1058         IBEP20 lpToken;           // Address of LP token contract.
1059         uint256 allocPoint;       // How many allocation points assigned to this pool. TOKENs to distribute per block.
1060         uint256 lastRewardBlock;  // Last block number that TOKENs distribution occurs.
1061         uint256 accTokenPerShare; // Accumulated TOKENs per share, times 1e12. See below.
1062         uint16 depositFeeBP;      // Deposit fee in basis points
1063         uint256 totalRewardTokens;
1064         uint256 totalMaxRewardTokens;
1065         uint256 totalDeposit;
1066     }
1067 
1068     // The TOKEN
1069     Token public token;
1070     // TOKEN tokens created per block.
1071     uint256 public tokenPerBlock;
1072     // Bonus muliplier for early token makers.
1073     uint256 public constant BONUS_MULTIPLIER = 1;
1074     // Deposit Fee address
1075     address public feeAddress;
1076 
1077     // Info of each pool.
1078     PoolInfo[] public poolInfo;
1079     // Info of each user that stakes LP tokens.
1080     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1081     // Total allocation points. Must be the sum of all allocation points in all pools.
1082     uint256 public totalAllocPoint = 0;
1083     // The block number when TOKEN mining starts.
1084     uint256 public startBlock;
1085 
1086     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1087     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1088     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1089 
1090     constructor(Token _token, address _feeAddress, uint256 _tokenPerBlock, uint256 _startBlock)
1091         public
1092     {
1093         token = _token;
1094         feeAddress = _feeAddress;
1095         tokenPerBlock = _tokenPerBlock;
1096         startBlock = _startBlock;
1097     }
1098 
1099     function poolLength()
1100         external
1101         view
1102         returns (uint256)
1103     {
1104         return poolInfo.length;
1105     }
1106 
1107     // Add a new lp to the pool. Can only be called by the owner.
1108     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1109     function add(uint256 _allocPoint, IBEP20 _lpToken, uint16 _depositFeeBP, uint256 totalMaxRewardToken, bool _withUpdate)
1110         public
1111         onlyOwner
1112     {
1113         require(_depositFeeBP <= 10000, "add: invalid deposit fee basis points");
1114 
1115         if (_withUpdate) {
1116             massUpdatePools();
1117         }
1118 
1119         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1120 
1121         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1122 
1123         poolInfo.push(PoolInfo({
1124             lpToken: _lpToken,
1125             allocPoint: _allocPoint,
1126             lastRewardBlock: lastRewardBlock,
1127             accTokenPerShare: 0,
1128             depositFeeBP: _depositFeeBP,
1129             totalRewardTokens: 0,
1130             totalMaxRewardTokens: totalMaxRewardToken,
1131             totalDeposit: 0
1132         }));
1133     }
1134 
1135     // Update the given pool's TOKEN allocation point and deposit fee. Can only be called by the owner.
1136     function set(uint256 _pid, uint256 _allocPoint, uint16 _depositFeeBP, uint256 totalMaxRewardToken, bool _withUpdate)
1137         public
1138         onlyOwner
1139     {
1140         require(_depositFeeBP <= 10000, "set: invalid deposit fee basis points");
1141 
1142         if (_withUpdate) {
1143             massUpdatePools();
1144         }
1145 
1146         require(poolInfo[_pid].totalRewardTokens <= totalMaxRewardToken, "set: totalMaxRewardToken is invalid");
1147 
1148         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1149 
1150         poolInfo[_pid].allocPoint = _allocPoint;
1151         poolInfo[_pid].depositFeeBP = _depositFeeBP;
1152         poolInfo[_pid].totalMaxRewardTokens = totalMaxRewardToken;
1153     }
1154 
1155     // Return reward multiplier over the given _from to _to block.
1156     function getMultiplier(uint256 _from, uint256 _to)
1157         public
1158         pure
1159         returns (uint256)
1160     {
1161         return _to.sub(_from).mul(BONUS_MULTIPLIER);
1162     }
1163 
1164     // View function to see pending TOKENs on frontend.
1165     function pendingToken(uint256 _pid, address _user)
1166         external
1167         view
1168         returns (uint256)
1169     {
1170         PoolInfo storage pool = poolInfo[_pid];
1171         UserInfo storage user = userInfo[_pid][_user];
1172 
1173         uint256 accTokenPerShare = pool.accTokenPerShare;
1174         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1175 
1176         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1177             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1178 
1179             uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1180 
1181             uint256 remainingTokens = pool.totalMaxRewardTokens - pool.totalRewardTokens;
1182 
1183             if (tokenReward > remainingTokens) {
1184                 tokenReward = remainingTokens;
1185             }
1186 
1187             accTokenPerShare = accTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1188         }
1189 
1190         return user.amount.mul(accTokenPerShare).div(1e12).sub(user.rewardDebt);
1191     }
1192 
1193     // Update reward variables for all pools. Be careful of gas spending!
1194     function massUpdatePools()
1195         public
1196     {
1197         uint256 length = poolInfo.length;
1198 
1199         for (uint256 pid = 0; pid < length; ++pid) {
1200             updatePool(pid);
1201         }
1202     }
1203 
1204     // Update reward variables of the given pool to be up-to-date.
1205     function updatePool(uint256 _pid)
1206         public
1207     {
1208         PoolInfo storage pool = poolInfo[_pid];
1209 
1210         if (block.number <= pool.lastRewardBlock) {
1211             return;
1212         }
1213 
1214         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1215 
1216         if (lpSupply == 0 || pool.allocPoint == 0) {
1217             pool.lastRewardBlock = block.number;
1218             return;
1219         }
1220 
1221         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1222 
1223         uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1224 
1225         uint256 remainingTokens = pool.totalMaxRewardTokens - pool.totalRewardTokens;
1226 
1227         if (tokenReward > remainingTokens) {
1228             tokenReward = remainingTokens;
1229         }
1230 
1231         if (tokenReward == 0) {
1232             pool.lastRewardBlock = block.number;
1233             return;
1234         }
1235 
1236         token.mint(address(this), tokenReward);
1237 
1238         pool.accTokenPerShare = pool.accTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1239         pool.lastRewardBlock = block.number;
1240         pool.totalRewardTokens = pool.totalRewardTokens.add(tokenReward);
1241     }
1242 
1243     // Deposit LP tokens to MasterChef for TOKEN allocation.
1244     function deposit(uint256 _pid, uint256 _amount)
1245         public
1246     {
1247         PoolInfo storage pool = poolInfo[_pid];
1248         UserInfo storage user = userInfo[_pid][msg.sender];
1249 
1250         updatePool(_pid);
1251 
1252         if (user.amount > 0) {
1253             uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1254 
1255             if (pending > 0) {
1256                 safeTokenTransfer(msg.sender, pending);
1257             }
1258         }
1259 
1260         if (_amount > 0) {
1261             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1262 
1263             if (pool.depositFeeBP > 0) {
1264                 uint256 depositFee = _amount.mul(pool.depositFeeBP).div(10000);
1265 
1266                 pool.lpToken.safeTransfer(feeAddress, depositFee);
1267 
1268                 user.amount = user.amount.add(_amount).sub(depositFee);
1269 
1270                 pool.totalDeposit = pool.totalDeposit.add(_amount).sub(depositFee);
1271 
1272             } else {
1273                 user.amount = user.amount.add(_amount);
1274 
1275                 pool.totalDeposit = pool.totalDeposit.add(_amount);
1276             }
1277         }
1278 
1279         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1280 
1281         emit Deposit(msg.sender, _pid, _amount);
1282     }
1283 
1284     // Withdraw LP tokens from MasterChef.
1285     function withdraw(uint256 _pid, uint256 _amount)
1286         public
1287     {
1288         PoolInfo storage pool = poolInfo[_pid];
1289         UserInfo storage user = userInfo[_pid][msg.sender];
1290 
1291         require(user.amount >= _amount, "withdraw: not good");
1292 
1293         updatePool(_pid);
1294 
1295         uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1296 
1297         if (pending > 0) {
1298             safeTokenTransfer(msg.sender, pending);
1299         }
1300 
1301         if (_amount > 0) {
1302             user.amount = user.amount.sub(_amount);
1303 
1304             pool.totalDeposit = pool.totalDeposit.sub(_amount);
1305 
1306             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1307         }
1308 
1309         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1310 
1311         emit Withdraw(msg.sender, _pid, _amount);
1312     }
1313 
1314     // Withdraw without caring about rewards. EMERGENCY ONLY.
1315     function emergencyWithdraw(uint256 _pid)
1316         public
1317     {
1318         PoolInfo storage pool = poolInfo[_pid];
1319         UserInfo storage user = userInfo[_pid][msg.sender];
1320 
1321         uint256 amount = user.amount;
1322 
1323         user.amount = 0;
1324         user.rewardDebt = 0;
1325 
1326         pool.lpToken.safeTransfer(address(msg.sender), amount);
1327 
1328         emit EmergencyWithdraw(msg.sender, _pid, amount);
1329     }
1330 
1331     // Safe token transfer function, just in case if rounding error causes pool to not have enough TOKENs.
1332     function safeTokenTransfer(address _to, uint256 _amount)
1333         internal
1334     {
1335         uint256 tokenBal = token.balanceOf(address(this));
1336 
1337         if (_amount > tokenBal) {
1338             token.transfer(_to, tokenBal);
1339 
1340         } else {
1341             token.transfer(_to, _amount);
1342         }
1343     }
1344 
1345     function setFeeAddress(address _feeAddress)
1346         public
1347     {
1348         require(msg.sender == feeAddress, "setFeeAddress: FORBIDDEN");
1349 
1350         feeAddress = _feeAddress;
1351     }
1352 
1353     //Pancake has to add hidden dummy pools inorder to alter the emission, here we make it simple and transparent to all.
1354     function updateEmissionRate(uint256 _tokenPerBlock)
1355         public
1356         onlyOwner
1357     {
1358         massUpdatePools();
1359 
1360         tokenPerBlock = _tokenPerBlock;
1361     }
1362 
1363     function withdrawAllReward(address _receiver)
1364         public
1365         onlyOwner
1366     {
1367         require(_receiver != address(0), "address is invalid");
1368 
1369         uint256 remaining = token.maxSupply() - token.totalSupply();
1370 
1371         if (remaining > 0) {
1372             token.mint(_receiver, remaining);
1373         }
1374 
1375         uint256 balance = token.balanceOf(address(this));
1376 
1377         if (balance > 0) {
1378             token.transfer(_receiver, balance);
1379         }
1380     }
1381 
1382 }