1 // File: @pancakeswap/pancake-swap-lib/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: GPL-3.0-or-later
4 
5 pragma solidity >=0.4.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor() internal {}
21 
22     function _msgSender() internal view returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @pancakeswap/pancake-swap-lib/contracts/access/Ownable.sol
33 
34 
35 pragma solidity >=0.4.0;
36 
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() internal {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public onlyOwner {
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      */
102     function _transferOwnership(address newOwner) internal {
103         require(newOwner != address(0), 'Ownable: new owner is the zero address');
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 // File: @pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol
110 
111 
112 pragma solidity >=0.4.0;
113 
114 interface IBEP20 {
115     /**
116      * @dev Returns the amount of tokens in existence.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     /**
121      * @dev Returns the token decimals.
122      */
123     function decimals() external view returns (uint8);
124 
125     /**
126      * @dev Returns the token symbol.
127      */
128     function symbol() external view returns (string memory);
129 
130     /**
131      * @dev Returns the token name.
132      */
133     function name() external view returns (string memory);
134 
135     /**
136      * @dev Returns the bep token owner.
137      */
138     function getOwner() external view returns (address);
139 
140     /**
141      * @dev Returns the amount of tokens owned by `account`.
142      */
143     function balanceOf(address account) external view returns (uint256);
144 
145     /**
146      * @dev Moves `amount` tokens from the caller's account to `recipient`.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transfer(address recipient, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Returns the remaining number of tokens that `spender` will be
156      * allowed to spend on behalf of `owner` through {transferFrom}. This is
157      * zero by default.
158      *
159      * This value changes when {approve} or {transferFrom} are called.
160      */
161     function allowance(address _owner, address spender) external view returns (uint256);
162 
163     /**
164      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * IMPORTANT: Beware that changing an allowance with this method brings the risk
169      * that someone may use both the old and the new allowance by unfortunate
170      * transaction ordering. One possible solution to mitigate this race
171      * condition is to first reduce the spender's allowance to 0 and set the
172      * desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      *
175      * Emits an {Approval} event.
176      */
177     function approve(address spender, uint256 amount) external returns (bool);
178 
179     /**
180      * @dev Moves `amount` tokens from `sender` to `recipient` using the
181      * allowance mechanism. `amount` is then deducted from the caller's
182      * allowance.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transferFrom(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) external returns (bool);
193 
194     /**
195      * @dev Emitted when `value` tokens are moved from one account (`from`) to
196      * another (`to`).
197      *
198      * Note that `value` may be zero.
199      */
200     event Transfer(address indexed from, address indexed to, uint256 value);
201 
202     /**
203      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
204      * a call to {approve}. `value` is the new allowance.
205      */
206     event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 // File: @pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol
210 
211 
212 pragma solidity >=0.4.0;
213 
214 /**
215  * @dev Wrappers over Solidity's arithmetic operations with added overflow
216  * checks.
217  *
218  * Arithmetic operations in Solidity wrap on overflow. This can easily result
219  * in bugs, because programmers usually assume that an overflow raises an
220  * error, which is the standard behavior in high level programming languages.
221  * `SafeMath` restores this intuition by reverting the transaction when an
222  * operation overflows.
223  *
224  * Using this library instead of the unchecked operations eliminates an entire
225  * class of bugs, so it's recommended to use it always.
226  */
227 library SafeMath {
228     /**
229      * @dev Returns the addition of two unsigned integers, reverting on
230      * overflow.
231      *
232      * Counterpart to Solidity's `+` operator.
233      *
234      * Requirements:
235      *
236      * - Addition cannot overflow.
237      */
238     function add(uint256 a, uint256 b) internal pure returns (uint256) {
239         uint256 c = a + b;
240         require(c >= a, 'SafeMath: addition overflow');
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the subtraction of two unsigned integers, reverting on
247      * overflow (when the result is negative).
248      *
249      * Counterpart to Solidity's `-` operator.
250      *
251      * Requirements:
252      *
253      * - Subtraction cannot overflow.
254      */
255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
256         return sub(a, b, 'SafeMath: subtraction overflow');
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
261      * overflow (when the result is negative).
262      *
263      * Counterpart to Solidity's `-` operator.
264      *
265      * Requirements:
266      *
267      * - Subtraction cannot overflow.
268      */
269     function sub(
270         uint256 a,
271         uint256 b,
272         string memory errorMessage
273     ) internal pure returns (uint256) {
274         require(b <= a, errorMessage);
275         uint256 c = a - b;
276 
277         return c;
278     }
279 
280     /**
281      * @dev Returns the multiplication of two unsigned integers, reverting on
282      * overflow.
283      *
284      * Counterpart to Solidity's `*` operator.
285      *
286      * Requirements:
287      *
288      * - Multiplication cannot overflow.
289      */
290     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
291         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
292         // benefit is lost if 'b' is also tested.
293         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
294         if (a == 0) {
295             return 0;
296         }
297 
298         uint256 c = a * b;
299         require(c / a == b, 'SafeMath: multiplication overflow');
300 
301         return c;
302     }
303 
304     /**
305      * @dev Returns the integer division of two unsigned integers. Reverts on
306      * division by zero. The result is rounded towards zero.
307      *
308      * Counterpart to Solidity's `/` operator. Note: this function uses a
309      * `revert` opcode (which leaves remaining gas untouched) while Solidity
310      * uses an invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function div(uint256 a, uint256 b) internal pure returns (uint256) {
317         return div(a, b, 'SafeMath: division by zero');
318     }
319 
320     /**
321      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
322      * division by zero. The result is rounded towards zero.
323      *
324      * Counterpart to Solidity's `/` operator. Note: this function uses a
325      * `revert` opcode (which leaves remaining gas untouched) while Solidity
326      * uses an invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      *
330      * - The divisor cannot be zero.
331      */
332     function div(
333         uint256 a,
334         uint256 b,
335         string memory errorMessage
336     ) internal pure returns (uint256) {
337         require(b > 0, errorMessage);
338         uint256 c = a / b;
339         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
340 
341         return c;
342     }
343 
344     /**
345      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
346      * Reverts when dividing by zero.
347      *
348      * Counterpart to Solidity's `%` operator. This function uses a `revert`
349      * opcode (which leaves remaining gas untouched) while Solidity uses an
350      * invalid opcode to revert (consuming all remaining gas).
351      *
352      * Requirements:
353      *
354      * - The divisor cannot be zero.
355      */
356     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
357         return mod(a, b, 'SafeMath: modulo by zero');
358     }
359 
360     /**
361      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
362      * Reverts with custom message when dividing by zero.
363      *
364      * Counterpart to Solidity's `%` operator. This function uses a `revert`
365      * opcode (which leaves remaining gas untouched) while Solidity uses an
366      * invalid opcode to revert (consuming all remaining gas).
367      *
368      * Requirements:
369      *
370      * - The divisor cannot be zero.
371      */
372     function mod(
373         uint256 a,
374         uint256 b,
375         string memory errorMessage
376     ) internal pure returns (uint256) {
377         require(b != 0, errorMessage);
378         return a % b;
379     }
380 
381     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
382         z = x < y ? x : y;
383     }
384 
385     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
386     function sqrt(uint256 y) internal pure returns (uint256 z) {
387         if (y > 3) {
388             z = y;
389             uint256 x = y / 2 + 1;
390             while (x < z) {
391                 z = x;
392                 x = (y / x + x) / 2;
393             }
394         } else if (y != 0) {
395             z = 1;
396         }
397     }
398 }
399 
400 // File: @pancakeswap/pancake-swap-lib/contracts/utils/Address.sol
401 
402 
403 pragma solidity ^0.6.2;
404 
405 /**
406  * @dev Collection of functions related to the address type
407  */
408 library Address {
409     /**
410      * @dev Returns true if `account` is a contract.
411      *
412      * [IMPORTANT]
413      * ====
414      * It is unsafe to assume that an address for which this function returns
415      * false is an externally-owned account (EOA) and not a contract.
416      *
417      * Among others, `isContract` will return false for the following
418      * types of addresses:
419      *
420      *  - an externally-owned account
421      *  - a contract in construction
422      *  - an address where a contract will be created
423      *  - an address where a contract lived, but was destroyed
424      * ====
425      */
426     function isContract(address account) internal view returns (bool) {
427         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
428         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
429         // for accounts without code, i.e. `keccak256('')`
430         bytes32 codehash;
431         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
432         // solhint-disable-next-line no-inline-assembly
433         assembly {
434             codehash := extcodehash(account)
435         }
436         return (codehash != accountHash && codehash != 0x0);
437     }
438 
439     /**
440      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
441      * `recipient`, forwarding all available gas and reverting on errors.
442      *
443      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
444      * of certain opcodes, possibly making contracts go over the 2300 gas limit
445      * imposed by `transfer`, making them unable to receive funds via
446      * `transfer`. {sendValue} removes this limitation.
447      *
448      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
449      *
450      * IMPORTANT: because control is transferred to `recipient`, care must be
451      * taken to not create reentrancy vulnerabilities. Consider using
452      * {ReentrancyGuard} or the
453      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
454      */
455     function sendValue(address payable recipient, uint256 amount) internal {
456         require(address(this).balance >= amount, 'Address: insufficient balance');
457 
458         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
459         (bool success, ) = recipient.call{value: amount}('');
460         require(success, 'Address: unable to send value, recipient may have reverted');
461     }
462 
463     /**
464      * @dev Performs a Solidity function call using a low level `call`. A
465      * plain`call` is an unsafe replacement for a function call: use this
466      * function instead.
467      *
468      * If `target` reverts with a revert reason, it is bubbled up by this
469      * function (like regular Solidity function calls).
470      *
471      * Returns the raw returned data. To convert to the expected return value,
472      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
473      *
474      * Requirements:
475      *
476      * - `target` must be a contract.
477      * - calling `target` with `data` must not revert.
478      *
479      * _Available since v3.1._
480      */
481     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
482         return functionCall(target, data, 'Address: low-level call failed');
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
487      * `errorMessage` as a fallback revert reason when `target` reverts.
488      *
489      * _Available since v3.1._
490      */
491     function functionCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal returns (bytes memory) {
496         return _functionCallWithValue(target, data, 0, errorMessage);
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
501      * but also transferring `value` wei to `target`.
502      *
503      * Requirements:
504      *
505      * - the calling contract must have an ETH balance of at least `value`.
506      * - the called Solidity function must be `payable`.
507      *
508      * _Available since v3.1._
509      */
510     function functionCallWithValue(
511         address target,
512         bytes memory data,
513         uint256 value
514     ) internal returns (bytes memory) {
515         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
520      * with `errorMessage` as a fallback revert reason when `target` reverts.
521      *
522      * _Available since v3.1._
523      */
524     function functionCallWithValue(
525         address target,
526         bytes memory data,
527         uint256 value,
528         string memory errorMessage
529     ) internal returns (bytes memory) {
530         require(address(this).balance >= value, 'Address: insufficient balance for call');
531         return _functionCallWithValue(target, data, value, errorMessage);
532     }
533 
534     function _functionCallWithValue(
535         address target,
536         bytes memory data,
537         uint256 weiValue,
538         string memory errorMessage
539     ) private returns (bytes memory) {
540         require(isContract(target), 'Address: call to non-contract');
541 
542         // solhint-disable-next-line avoid-low-level-calls
543         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
544         if (success) {
545             return returndata;
546         } else {
547             // Look for revert reason and bubble it up if present
548             if (returndata.length > 0) {
549                 // The easiest way to bubble the revert reason is using memory via assembly
550 
551                 // solhint-disable-next-line no-inline-assembly
552                 assembly {
553                     let returndata_size := mload(returndata)
554                     revert(add(32, returndata), returndata_size)
555                 }
556             } else {
557                 revert(errorMessage);
558             }
559         }
560     }
561 }
562 
563 // File: @pancakeswap/pancake-swap-lib/contracts/token/BEP20/BEP20.sol
564 
565 
566 pragma solidity >=0.4.0;
567 
568 
569 
570 
571 
572 
573 /**
574  * @dev Implementation of the {IBEP20} interface.
575  *
576  * This implementation is agnostic to the way tokens are created. This means
577  * that a supply mechanism has to be added in a derived contract using {_mint}.
578  * For a generic mechanism see {BEP20PresetMinterPauser}.
579  *
580  * TIP: For a detailed writeup see our guide
581  * https://forum.zeppelin.solutions/t/how-to-implement-BEP20-supply-mechanisms/226[How
582  * to implement supply mechanisms].
583  *
584  * We have followed general OpenZeppelin guidelines: functions revert instead
585  * of returning `false` on failure. This behavior is nonetheless conventional
586  * and does not conflict with the expectations of BEP20 applications.
587  *
588  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
589  * This allows applications to reconstruct the allowance for all accounts just
590  * by listening to said events. Other implementations of the EIP may not emit
591  * these events, as it isn't required by the specification.
592  *
593  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
594  * functions have been added to mitigate the well-known issues around setting
595  * allowances. See {IBEP20-approve}.
596  */
597 contract BEP20 is Context, IBEP20, Ownable {
598     using SafeMath for uint256;
599     using Address for address;
600 
601     mapping(address => uint256) private _balances;
602 
603     mapping(address => mapping(address => uint256)) private _allowances;
604 
605     uint256 private _totalSupply;
606 
607     string private _name;
608     string private _symbol;
609     uint8 private _decimals;
610 
611     /**
612      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
613      * a default value of 18.
614      *
615      * To select a different value for {decimals}, use {_setupDecimals}.
616      *
617      * All three of these values are immutable: they can only be set once during
618      * construction.
619      */
620     constructor(string memory name, string memory symbol) public {
621         _name = name;
622         _symbol = symbol;
623         _decimals = 18;
624     }
625 
626     /**
627      * @dev Returns the bep token owner.
628      */
629     function getOwner() external override view returns (address) {
630         return owner();
631     }
632 
633     /**
634      * @dev Returns the token name.
635      */
636     function name() public override view returns (string memory) {
637         return _name;
638     }
639 
640     /**
641      * @dev Returns the token decimals.
642      */
643     function decimals() public override view returns (uint8) {
644         return _decimals;
645     }
646 
647     /**
648      * @dev Returns the token symbol.
649      */
650     function symbol() public override view returns (string memory) {
651         return _symbol;
652     }
653 
654     /**
655      * @dev See {BEP20-totalSupply}.
656      */
657     function totalSupply() public override view returns (uint256) {
658         return _totalSupply;
659     }
660 
661     /**
662      * @dev See {BEP20-balanceOf}.
663      */
664     function balanceOf(address account) public override view returns (uint256) {
665         return _balances[account];
666     }
667 
668     /**
669      * @dev See {BEP20-transfer}.
670      *
671      * Requirements:
672      *
673      * - `recipient` cannot be the zero address.
674      * - the caller must have a balance of at least `amount`.
675      */
676     function transfer(address recipient, uint256 amount) public override returns (bool) {
677         _transfer(_msgSender(), recipient, amount);
678         return true;
679     }
680 
681     /**
682      * @dev See {BEP20-allowance}.
683      */
684     function allowance(address owner, address spender) public override view returns (uint256) {
685         return _allowances[owner][spender];
686     }
687 
688     /**
689      * @dev See {BEP20-approve}.
690      *
691      * Requirements:
692      *
693      * - `spender` cannot be the zero address.
694      */
695     function approve(address spender, uint256 amount) public override returns (bool) {
696         _approve(_msgSender(), spender, amount);
697         return true;
698     }
699 
700     /**
701      * @dev See {BEP20-transferFrom}.
702      *
703      * Emits an {Approval} event indicating the updated allowance. This is not
704      * required by the EIP. See the note at the beginning of {BEP20};
705      *
706      * Requirements:
707      * - `sender` and `recipient` cannot be the zero address.
708      * - `sender` must have a balance of at least `amount`.
709      * - the caller must have allowance for `sender`'s tokens of at least
710      * `amount`.
711      */
712     function transferFrom(
713         address sender,
714         address recipient,
715         uint256 amount
716     ) public override returns (bool) {
717         _transfer(sender, recipient, amount);
718         _approve(
719             sender,
720             _msgSender(),
721             _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
722         );
723         return true;
724     }
725 
726     /**
727      * @dev Atomically increases the allowance granted to `spender` by the caller.
728      *
729      * This is an alternative to {approve} that can be used as a mitigation for
730      * problems described in {BEP20-approve}.
731      *
732      * Emits an {Approval} event indicating the updated allowance.
733      *
734      * Requirements:
735      *
736      * - `spender` cannot be the zero address.
737      */
738     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
739         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
740         return true;
741     }
742 
743     /**
744      * @dev Atomically decreases the allowance granted to `spender` by the caller.
745      *
746      * This is an alternative to {approve} that can be used as a mitigation for
747      * problems described in {BEP20-approve}.
748      *
749      * Emits an {Approval} event indicating the updated allowance.
750      *
751      * Requirements:
752      *
753      * - `spender` cannot be the zero address.
754      * - `spender` must have allowance for the caller of at least
755      * `subtractedValue`.
756      */
757     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
758         _approve(
759             _msgSender(),
760             spender,
761             _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero')
762         );
763         return true;
764     }
765 
766     /**
767      * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
768      * the total supply.
769      *
770      * Requirements
771      *
772      * - `msg.sender` must be the token owner
773      */
774     function mint(uint256 amount) public onlyOwner returns (bool) {
775         _mint(_msgSender(), amount);
776         return true;
777     }
778 
779     /**
780      * @dev Moves tokens `amount` from `sender` to `recipient`.
781      *
782      * This is internal function is equivalent to {transfer}, and can be used to
783      * e.g. implement automatic token fees, slashing mechanisms, etc.
784      *
785      * Emits a {Transfer} event.
786      *
787      * Requirements:
788      *
789      * - `sender` cannot be the zero address.
790      * - `recipient` cannot be the zero address.
791      * - `sender` must have a balance of at least `amount`.
792      */
793     function _transfer(
794         address sender,
795         address recipient,
796         uint256 amount
797     ) internal {
798         require(sender != address(0), 'BEP20: transfer from the zero address');
799         require(recipient != address(0), 'BEP20: transfer to the zero address');
800 
801         _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
802         _balances[recipient] = _balances[recipient].add(amount);
803         emit Transfer(sender, recipient, amount);
804     }
805 
806     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
807      * the total supply.
808      *
809      * Emits a {Transfer} event with `from` set to the zero address.
810      *
811      * Requirements
812      *
813      * - `to` cannot be the zero address.
814      */
815     function _mint(address account, uint256 amount) internal {
816         require(account != address(0), 'BEP20: mint to the zero address');
817 
818         _totalSupply = _totalSupply.add(amount);
819         _balances[account] = _balances[account].add(amount);
820         emit Transfer(address(0), account, amount);
821     }
822 
823     /**
824      * @dev Destroys `amount` tokens from `account`, reducing the
825      * total supply.
826      *
827      * Emits a {Transfer} event with `to` set to the zero address.
828      *
829      * Requirements
830      *
831      * - `account` cannot be the zero address.
832      * - `account` must have at least `amount` tokens.
833      */
834     function _burn(address account, uint256 amount) internal {
835         require(account != address(0), 'BEP20: burn from the zero address');
836 
837         _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
838         _totalSupply = _totalSupply.sub(amount);
839         emit Transfer(account, address(0), amount);
840     }
841 
842     /**
843      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
844      *
845      * This is internal function is equivalent to `approve`, and can be used to
846      * e.g. set automatic allowances for certain subsystems, etc.
847      *
848      * Emits an {Approval} event.
849      *
850      * Requirements:
851      *
852      * - `owner` cannot be the zero address.
853      * - `spender` cannot be the zero address.
854      */
855     function _approve(
856         address owner,
857         address spender,
858         uint256 amount
859     ) internal {
860         require(owner != address(0), 'BEP20: approve from the zero address');
861         require(spender != address(0), 'BEP20: approve to the zero address');
862 
863         _allowances[owner][spender] = amount;
864         emit Approval(owner, spender, amount);
865     }
866 
867     /**
868      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
869      * from the caller's allowance.
870      *
871      * See {_burn} and {_approve}.
872      */
873     function _burnFrom(address account, uint256 amount) internal {
874         _burn(account, amount);
875         _approve(
876             account,
877             _msgSender(),
878             _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance')
879         );
880     }
881 }
882 
883 // File: contracts/Token.sol
884 
885 pragma solidity 0.6.12;
886 
887 
888 // Token with Governance
889 contract Token is BEP20 {
890 
891     uint256 public maxSupply;
892 
893     constructor(string memory _name, string memory _symbol, uint256 _maxSupply, uint256 _initialSupply, address _holder)
894         BEP20(_name, _symbol)
895         public
896     {
897         require(_initialSupply <= _maxSupply, "Token: cap exceeded");
898 
899         maxSupply = _maxSupply;
900 
901         _mint(_holder, _initialSupply);
902     }
903 
904     /// @dev Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
905     function mint(address _to, uint256 _amount)
906         public
907         onlyOwner
908     {
909         require(totalSupply() + _amount <= maxSupply, "Token: cap exceeded");
910 
911         _mint(_to, _amount);
912     }
913 
914 }