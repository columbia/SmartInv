1 // produced by the Solididy File Flattener (c)  Created By BitDNS.vip
2 // contact : BitDNS.vip
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
33         require(c >= a, "SafeMath: addition overflow");
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
49         return sub(a, b, "SafeMath: subtraction overflow");
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
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 
164 /**
165  * @dev Collection of functions related to the address type
166  */
167 library Address {
168     /**
169      * @dev Returns true if `account` is a contract.
170      *
171      * [IMPORTANT]
172      * ====
173      * It is unsafe to assume that an address for which this function returns
174      * false is an externally-owned account (EOA) and not a contract.
175      *
176      * Among others, `isContract` will return false for the following
177      * types of addresses:
178      *
179      *  - an externally-owned account
180      *  - a contract in construction
181      *  - an address where a contract will be created
182      *  - an address where a contract lived, but was destroyed
183      * ====
184      */
185     function isContract(address account) internal view returns (bool) {
186         // This method relies in extcodesize, which returns 0 for contracts in
187         // construction, since the code is only stored at the end of the
188         // constructor execution.
189 
190         uint256 size;
191         // solhint-disable-next-line no-inline-assembly
192         assembly { size := extcodesize(account) }
193         return size > 0;
194     }
195 
196     /**
197      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
198      * `recipient`, forwarding all available gas and reverting on errors.
199      *
200      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
201      * of certain opcodes, possibly making contracts go over the 2300 gas limit
202      * imposed by `transfer`, making them unable to receive funds via
203      * `transfer`. {sendValue} removes this limitation.
204      *
205      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
206      *
207      * IMPORTANT: because control is transferred to `recipient`, care must be
208      * taken to not create reentrancy vulnerabilities. Consider using
209      * {ReentrancyGuard} or the
210      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
211      */
212     function sendValue(address payable recipient, uint256 amount) internal {
213         require(address(this).balance >= amount, "Address: insufficient balance");
214 
215         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
216         (bool success, ) = recipient.call{ value: amount }("");
217         require(success, "Address: unable to send value, recipient may have reverted");
218     }
219 
220     /**
221      * @dev Performs a Solidity function call using a low level `call`. A
222      * plain`call` is an unsafe replacement for a function call: use this
223      * function instead.
224      *
225      * If `target` reverts with a revert reason, it is bubbled up by this
226      * function (like regular Solidity function calls).
227      *
228      * Returns the raw returned data. To convert to the expected return value,
229      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
230      *
231      * Requirements:
232      *
233      * - `target` must be a contract.
234      * - calling `target` with `data` must not revert.
235      *
236      * _Available since v3.1._
237      */
238     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
239       return functionCall(target, data, "Address: low-level call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
244      * `errorMessage` as a fallback revert reason when `target` reverts.
245      *
246      * _Available since v3.1._
247      */
248     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
249         return _functionCallWithValue(target, data, 0, errorMessage);
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
254      * but also transferring `value` wei to `target`.
255      *
256      * Requirements:
257      *
258      * - the calling contract must have an ETH balance of at least `value`.
259      * - the called Solidity function must be `payable`.
260      *
261      * _Available since v3.1._
262      */
263     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
264         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
269      * with `errorMessage` as a fallback revert reason when `target` reverts.
270      *
271      * _Available since v3.1._
272      */
273     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
274         require(address(this).balance >= value, "Address: insufficient balance for call");
275         return _functionCallWithValue(target, data, value, errorMessage);
276     }
277 
278     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
279         require(isContract(target), "Address: call to non-contract");
280 
281         // solhint-disable-next-line avoid-low-level-calls
282         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
283         if (success) {
284             return returndata;
285         } else {
286             // Look for revert reason and bubble it up if present
287             if (returndata.length > 0) {
288                 // The easiest way to bubble the revert reason is using memory via assembly
289 
290                 // solhint-disable-next-line no-inline-assembly
291                 assembly {
292                     let returndata_size := mload(returndata)
293                     revert(add(32, returndata), returndata_size)
294                 }
295             } else {
296                 revert(errorMessage);
297             }
298         }
299     }
300 }
301 
302 
303 /*
304  * @dev Provides information about the current execution context, including the
305  * sender of the transaction and its data. While these are generally available
306  * via msg.sender and msg.data, they should not be accessed in such a direct
307  * manner, since when dealing with GSN meta-transactions the account sending and
308  * paying for execution may not be the actual sender (as far as an application
309  * is concerned).
310  *
311  * This contract is only required for intermediate, library-like contracts.
312  */
313 abstract contract Context {
314     function _msgSender() internal view virtual returns (address payable) {
315         return msg.sender;
316     }
317 
318     function _msgData() internal view virtual returns (bytes memory) {
319         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
320         return msg.data;
321     }
322 }
323 
324 
325 /**
326  * @dev Standard math utilities missing in the Solidity language.
327  */
328 library Math {
329     /**
330      * @dev Returns the largest of two numbers.
331      */
332     function max(uint256 a, uint256 b) internal pure returns (uint256) {
333         return a >= b ? a : b;
334     }
335 
336     /**
337      * @dev Returns the smallest of two numbers.
338      */
339     function min(uint256 a, uint256 b) internal pure returns (uint256) {
340         return a < b ? a : b;
341     }
342 
343     /**
344      * @dev Returns the average of two numbers. The result is rounded towards
345      * zero.
346      */
347     function average(uint256 a, uint256 b) internal pure returns (uint256) {
348         // (a + b) / 2 can overflow, so we distribute
349         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
350     }
351 }
352 
353 
354 /**
355  * @dev Interface of the ERC20 standard as defined in the EIP.
356  */
357 interface IERC20 {
358     /**
359      * @dev Returns the amount of tokens in existence.
360      */
361     function totalSupply() external view returns (uint256);
362 
363     /**
364      * @dev Returns the amount of tokens owned by `account`.
365      */
366     function balanceOf(address account) external view returns (uint256);
367 
368     /**
369      * @dev Moves `amount` tokens from the caller's account to `recipient`.
370      *
371      * Returns a boolean value indicating whether the operation succeeded.
372      *
373      * Emits a {Transfer} event.
374      */
375     function transfer(address recipient, uint256 amount) external returns (bool);
376 
377     /**
378      * @dev Returns the remaining number of tokens that `spender` will be
379      * allowed to spend on behalf of `owner` through {transferFrom}. This is
380      * zero by default.
381      *
382      * This value changes when {approve} or {transferFrom} are called.
383      */
384     function allowance(address owner, address spender) external view returns (uint256);
385 
386     /**
387      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
388      *
389      * Returns a boolean value indicating whether the operation succeeded.
390      *
391      * IMPORTANT: Beware that changing an allowance with this method brings the risk
392      * that someone may use both the old and the new allowance by unfortunate
393      * transaction ordering. One possible solution to mitigate this race
394      * condition is to first reduce the spender's allowance to 0 and set the
395      * desired value afterwards:
396      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
397      *
398      * Emits an {Approval} event.
399      */
400     function approve(address spender, uint256 amount) external returns (bool);
401 
402     /**
403      * @dev Moves `amount` tokens from `sender` to `recipient` using the
404      * allowance mechanism. `amount` is then deducted from the caller's
405      * allowance.
406      *
407      * Returns a boolean value indicating whether the operation succeeded.
408      *
409      * Emits a {Transfer} event.
410      */
411     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
412 
413     /**
414      * @dev Emitted when `value` tokens are moved from one account (`from`) to
415      * another (`to`).
416      *
417      * Note that `value` may be zero.
418      */
419     event Transfer(address indexed from, address indexed to, uint256 value);
420 
421     /**
422      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
423      * a call to {approve}. `value` is the new allowance.
424      */
425     event Approval(address indexed owner, address indexed spender, uint256 value);
426 }
427 
428 
429 /**
430  * @title Counters
431  * @author Matt Condon (@shrugs)
432  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
433  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
434  *
435  * Include with `using Counters for Counters.Counter;`
436  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
437  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
438  * directly accessed.
439  */
440 library Counters {
441     using SafeMath for uint256;
442 
443     struct Counter {
444         // This variable should never be directly accessed by users of the library: interactions must be restricted to
445         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
446         // this feature: see https://github.com/ethereum/solidity/issues/4637
447         uint256 _value; // default: 0
448     }
449 
450     function current(Counter storage counter) internal view returns (uint256) {
451         return counter._value;
452     }
453 
454     function increment(Counter storage counter) internal {
455         // The {SafeMath} overflow check can be skipped here, see the comment at the top
456         counter._value += 1;
457     }
458 
459     function decrement(Counter storage counter) internal {
460         counter._value = counter._value.sub(1);
461     }
462 }
463 
464 /**
465  * @dev Contract module which provides a basic access control mechanism, where
466  * there is an account (an owner) that can be granted exclusive access to
467  * specific functions.
468  *
469  * By default, the owner account will be the one that deploys the contract. This
470  * can later be changed with {transferOwnership}.
471  *
472  * This module is used through inheritance. It will make available the modifier
473  * `onlyOwner`, which can be applied to your functions to restrict their use to
474  * the owner.
475  */
476 contract Ownable is Context {
477     address private _owner;
478 
479     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
480 
481     /**
482      * @dev Initializes the contract setting the deployer as the initial owner.
483      */
484     constructor () internal {
485         address msgSender = _msgSender();
486         _owner = msgSender;
487         emit OwnershipTransferred(address(0), msgSender);
488     }
489 
490     /**
491      * @dev Returns the address of the current owner.
492      */
493     function owner() public view returns (address) {
494         return _owner;
495     }
496 
497     /**
498      * @dev Throws if called by any account other than the owner.
499      */
500     modifier onlyOwner() {
501         require(_owner == _msgSender(), "Ownable: caller is not the owner");
502         _;
503     }
504 
505     /**
506      * @dev Leaves the contract without owner. It will not be possible to call
507      * `onlyOwner` functions anymore. Can only be called by the current owner.
508      *
509      * NOTE: Renouncing ownership will leave the contract without an owner,
510      * thereby removing any functionality that is only available to the owner.
511      */
512     function renounceOwnership() public virtual onlyOwner {
513         emit OwnershipTransferred(_owner, address(0));
514         _owner = address(0);
515     }
516 
517     /**
518      * @dev Transfers ownership of the contract to a new account (`newOwner`).
519      * Can only be called by the current owner.
520      */
521     function transferOwnership(address newOwner) public virtual onlyOwner {
522         require(newOwner != address(0), "Ownable: new owner is the zero address");
523         emit OwnershipTransferred(_owner, newOwner);
524         _owner = newOwner;
525     }
526 }
527 
528 
529 /**
530  * @dev Collection of functions related to array types.
531  */
532 library Arrays {
533    /**
534      * @dev Searches a sorted `array` and returns the first index that contains
535      * a value greater or equal to `element`. If no such index exists (i.e. all
536      * values in the array are strictly less than `element`), the array length is
537      * returned. Time complexity O(log n).
538      *
539      * `array` is expected to be sorted in ascending order, and to contain no
540      * repeated elements.
541      */
542     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
543         if (array.length == 0) {
544             return 0;
545         }
546 
547         uint256 low = 0;
548         uint256 high = array.length;
549 
550         while (low < high) {
551             uint256 mid = Math.average(low, high);
552 
553             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
554             // because Math.average rounds down (it does integer division with truncation).
555             if (array[mid] > element) {
556                 high = mid;
557             } else {
558                 low = mid + 1;
559             }
560         }
561 
562         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
563         if (low > 0 && array[low - 1] == element) {
564             return low - 1;
565         } else {
566             return low;
567         }
568     }
569 }
570 
571 
572 /**
573  * @dev Implementation of the {IERC20} interface.
574  *
575  * This implementation is agnostic to the way tokens are created. This means
576  * that a supply mechanism has to be added in a derived contract using {_mint}.
577  * For a generic mechanism see {ERC20PresetMinterPauser}.
578  *
579  * TIP: For a detailed writeup see our guide
580  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
581  * to implement supply mechanisms].
582  *
583  * We have followed general OpenZeppelin guidelines: functions revert instead
584  * of returning `false` on failure. This behavior is nonetheless conventional
585  * and does not conflict with the expectations of ERC20 applications.
586  *
587  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
588  * This allows applications to reconstruct the allowance for all accounts just
589  * by listening to said events. Other implementations of the EIP may not emit
590  * these events, as it isn't required by the specification.
591  *
592  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
593  * functions have been added to mitigate the well-known issues around setting
594  * allowances. See {IERC20-approve}.
595  */
596 contract ERC20 is Context, IERC20 {
597     using SafeMath for uint256;
598     using Address for address;
599 
600     mapping (address => uint256) private _balances;
601 
602     mapping (address => mapping (address => uint256)) private _allowances;
603 
604     uint256 private _totalSupply;
605 
606     string private _name;
607     string private _symbol;
608     uint8 private _decimals;
609 
610     /**
611      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
612      * a default value of 18.
613      *
614      * To select a different value for {decimals}, use {_setupDecimals}.
615      *
616      * All three of these values are immutable: they can only be set once during
617      * construction.
618      */
619     constructor (string memory name, string memory symbol) public {
620         _name = name;
621         _symbol = symbol;
622         _decimals = 18;
623     }
624 
625     /**
626      * @dev Returns the name of the token.
627      */
628     function name() public view returns (string memory) {
629         return _name;
630     }
631 
632     /**
633      * @dev Returns the symbol of the token, usually a shorter version of the
634      * name.
635      */
636     function symbol() public view returns (string memory) {
637         return _symbol;
638     }
639 
640     /**
641      * @dev Returns the number of decimals used to get its user representation.
642      * For example, if `decimals` equals `2`, a balance of `505` tokens should
643      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
644      *
645      * Tokens usually opt for a value of 18, imitating the relationship between
646      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
647      * called.
648      *
649      * NOTE: This information is only used for _display_ purposes: it in
650      * no way affects any of the arithmetic of the contract, including
651      * {IERC20-balanceOf} and {IERC20-transfer}.
652      */
653     function decimals() public view returns (uint8) {
654         return _decimals;
655     }
656 
657     /**
658      * @dev See {IERC20-totalSupply}.
659      */
660     function totalSupply() public view override returns (uint256) {
661         return _totalSupply;
662     }
663 
664     /**
665      * @dev See {IERC20-balanceOf}.
666      */
667     function balanceOf(address account) public view override returns (uint256) {
668         return _balances[account];
669     }
670 
671     /**
672      * @dev See {IERC20-transfer}.
673      *
674      * Requirements:
675      *
676      * - `recipient` cannot be the zero address.
677      * - the caller must have a balance of at least `amount`.
678      */
679     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
680         _transfer(_msgSender(), recipient, amount);
681         return true;
682     }
683 
684     /**
685      * @dev See {IERC20-allowance}.
686      */
687     function allowance(address owner, address spender) public view virtual override returns (uint256) {
688         return _allowances[owner][spender];
689     }
690 
691     /**
692      * @dev See {IERC20-approve}.
693      *
694      * Requirements:
695      *
696      * - `spender` cannot be the zero address.
697      */
698     function approve(address spender, uint256 amount) public virtual override returns (bool) {
699         require((_allowances[_msgSender()][spender] == 0) || (amount == 0), "ERC20: use increaseAllowance or decreaseAllowance instead");
700         _approve(_msgSender(), spender, amount);
701         return true;
702     }
703 
704     /**
705      * @dev See {IERC20-transferFrom}.
706      *
707      * Emits an {Approval} event indicating the updated allowance. This is not
708      * required by the EIP. See the note at the beginning of {ERC20};
709      *
710      * Requirements:
711      * - `sender` and `recipient` cannot be the zero address.
712      * - `sender` must have a balance of at least `amount`.
713      * - the caller must have allowance for ``sender``'s tokens of at least
714      * `amount`.
715      */
716     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
717         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
718         _transfer(sender, recipient, amount);
719         return true;
720     }
721 
722     /**
723      * @dev Atomically increases the allowance granted to `spender` by the caller.
724      *
725      * This is an alternative to {approve} that can be used as a mitigation for
726      * problems described in {IERC20-approve}.
727      *
728      * Emits an {Approval} event indicating the updated allowance.
729      *
730      * Requirements:
731      *
732      * - `spender` cannot be the zero address.
733      */
734     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
735         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
736         return true;
737     }
738 
739     /**
740      * @dev Atomically decreases the allowance granted to `spender` by the caller.
741      *
742      * This is an alternative to {approve} that can be used as a mitigation for
743      * problems described in {IERC20-approve}.
744      *
745      * Emits an {Approval} event indicating the updated allowance.
746      *
747      * Requirements:
748      *
749      * - `spender` cannot be the zero address.
750      * - `spender` must have allowance for the caller of at least
751      * `subtractedValue`.
752      */
753     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
754         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
755         return true;
756     }
757 
758     /**
759      * @dev Moves tokens `amount` from `sender` to `recipient`.
760      *
761      * This is internal function is equivalent to {transfer}, and can be used to
762      * e.g. implement automatic token fees, slashing mechanisms, etc.
763      *
764      * Emits a {Transfer} event.
765      *
766      * Requirements:
767      *
768      * - `sender` cannot be the zero address.
769      * - `recipient` cannot be the zero address.
770      * - `sender` must have a balance of at least `amount`.
771      */
772     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
773         require(sender != address(0), "ERC20: transfer from the zero address");
774         require(recipient != address(0), "ERC20: transfer to the zero address");
775 
776         _beforeTokenTransfer(sender, recipient, amount);
777 
778         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
779         _balances[recipient] = _balances[recipient].add(amount);
780         emit Transfer(sender, recipient, amount);
781     }
782 
783     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
784      * the total supply.
785      *
786      * Emits a {Transfer} event with `from` set to the zero address.
787      *
788      * Requirements
789      *
790      * - `to` cannot be the zero address.
791      */
792     function _mint(address account, uint256 amount) internal virtual {
793         require(account != address(0), "ERC20: mint to the zero address");
794 
795         _beforeTokenTransfer(address(0), account, amount);
796 
797         _totalSupply = _totalSupply.add(amount);
798         _balances[account] = _balances[account].add(amount);
799         emit Transfer(address(0), account, amount);
800     }
801 
802     /**
803      * @dev Destroys `amount` tokens from `account`, reducing the
804      * total supply.
805      *
806      * Emits a {Transfer} event with `to` set to the zero address.
807      *
808      * Requirements
809      *
810      * - `account` cannot be the zero address.
811      * - `account` must have at least `amount` tokens.
812      */
813     function _burn(address account, uint256 amount) internal virtual {
814         require(account != address(0), "ERC20: burn from the zero address");
815 
816         _beforeTokenTransfer(account, address(0), amount);
817 
818         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
819         _totalSupply = _totalSupply.sub(amount);
820         emit Transfer(account, address(0), amount);
821     }
822 
823     /**
824      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
825      *
826      * This is internal function is equivalent to `approve`, and can be used to
827      * e.g. set automatic allowances for certain subsystems, etc.
828      *
829      * Emits an {Approval} event.
830      *
831      * Requirements:
832      *
833      * - `owner` cannot be the zero address.
834      * - `spender` cannot be the zero address.
835      */
836     function _approve(address owner, address spender, uint256 amount) internal virtual {
837         require(owner != address(0), "ERC20: approve from the zero address");
838         require(spender != address(0), "ERC20: approve to the zero address");
839 
840         _allowances[owner][spender] = amount;
841         emit Approval(owner, spender, amount);
842     }
843 
844     /**
845      * @dev Sets {decimals} to a value other than the default one of 18.
846      *
847      * WARNING: This function should only be called from the constructor. Most
848      * applications that interact with token contracts will not expect
849      * {decimals} to ever change, and may work incorrectly if it does.
850      */
851     function _setupDecimals(uint8 decimals_) internal {
852         _decimals = decimals_;
853     }
854 
855     /**
856      * @dev Hook that is called before any transfer of tokens. This includes
857      * minting and burning.
858      *
859      * Calling conditions:
860      *
861      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
862      * will be to transferred to `to`.
863      * - when `from` is zero, `amount` tokens will be minted for `to`.
864      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
865      * - `from` and `to` are never both zero.
866      *
867      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
868      */
869     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
870 }
871 
872 
873 /**
874  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
875  * total supply at the time are recorded for later access.
876  *
877  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
878  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
879  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
880  * used to create an efficient ERC20 forking mechanism.
881  *
882  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
883  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
884  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
885  * and the account address.
886  *
887  * ==== Gas Costs
888  *
889  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
890  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
891  * smaller since identical balances in subsequent snapshots are stored as a single entry.
892  *
893  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
894  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
895  * transfers will have normal cost until the next snapshot, and so on.
896  */
897 abstract contract ERC20Snapshot is ERC20 {
898     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
899     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
900 
901     using SafeMath for uint256;
902     using Arrays for uint256[];
903     using Counters for Counters.Counter;
904 
905     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
906     // Snapshot struct, but that would impede usage of functions that work on an array.
907     struct Snapshots {
908         uint256[] ids;
909         uint256[] values;
910     }
911 
912     mapping (address => Snapshots) private _accountBalanceSnapshots;
913     Snapshots private _totalSupplySnapshots;
914 
915     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
916     Counters.Counter private _currentSnapshotId;
917 
918     /**
919      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
920      */
921     event Snapshot(uint256 id);
922 
923     /**
924      * @dev Creates a new snapshot and returns its snapshot id.
925      *
926      * Emits a {Snapshot} event that contains the same id.
927      *
928      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
929      * set of accounts, for example using {AccessControl}, or it may be open to the public.
930      *
931      * [WARNING]
932      * ====
933      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
934      * you must consider that it can potentially be used by attackers in two ways.
935      *
936      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
937      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
938      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
939      * section above.
940      *
941      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
942      * ====
943      */
944     function _snapshot() internal virtual returns (uint256) {
945         _currentSnapshotId.increment();
946 
947         uint256 currentId = _currentSnapshotId.current();
948         emit Snapshot(currentId);
949         return currentId;
950     }
951 
952     /**
953      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
954      */
955     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
956         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
957 
958         return snapshotted ? value : balanceOf(account);
959     }
960 
961     /**
962      * @dev Retrieves the total supply at the time `snapshotId` was created.
963      */
964     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
965         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
966 
967         return snapshotted ? value : totalSupply();
968     }
969 
970     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
971     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
972     // The same is true for the total supply and _mint and _burn.
973     function _transfer(address from, address to, uint256 value) internal virtual override {
974         _updateAccountSnapshot(from);
975         _updateAccountSnapshot(to);
976 
977         super._transfer(from, to, value);
978     }
979 
980     function _mint(address account, uint256 value) internal virtual override {
981         _updateAccountSnapshot(account);
982         _updateTotalSupplySnapshot();
983 
984         super._mint(account, value);
985     }
986 
987     function _burn(address account, uint256 value) internal virtual override {
988         _updateAccountSnapshot(account);
989         _updateTotalSupplySnapshot();
990 
991         super._burn(account, value);
992     }
993 
994     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
995         private view returns (bool, uint256)
996     {
997         require(snapshotId > 0, "ERC20Snapshot: id is 0");
998         // solhint-disable-next-line max-line-length
999         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
1000 
1001         // When a valid snapshot is queried, there are three possibilities:
1002         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1003         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1004         //  to this id is the current one.
1005         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1006         //  requested id, and its value is the one to return.
1007         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1008         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1009         //  larger than the requested one.
1010         //
1011         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1012         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1013         // exactly this.
1014 
1015         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1016 
1017         if (index == snapshots.ids.length) {
1018             return (false, 0);
1019         } else {
1020             return (true, snapshots.values[index]);
1021         }
1022     }
1023 
1024     function _updateAccountSnapshot(address account) private {
1025         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1026     }
1027 
1028     function _updateTotalSupplySnapshot() private {
1029         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1030     }
1031 
1032     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1033         uint256 currentId = _currentSnapshotId.current();
1034         if (_lastSnapshotId(snapshots.ids) < currentId) {
1035             snapshots.ids.push(currentId);
1036             snapshots.values.push(currentValue);
1037         }
1038     }
1039 
1040     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1041         if (ids.length == 0) {
1042             return 0;
1043         } else {
1044             return ids[ids.length - 1];
1045         }
1046     }
1047 }
1048 
1049 
1050 /**
1051  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1052  * tokens and those that they have an allowance for, in a way that can be
1053  * recognized off-chain (via event analysis).
1054  */
1055 abstract contract ERC20Burnable is Context, ERC20 {
1056     /**
1057      * @dev Destroys `amount` tokens from the caller.
1058      *
1059      * See {ERC20-_burn}.
1060      */
1061     function burn(uint256 amount) public virtual {
1062         _burn(_msgSender(), amount);
1063     }
1064 
1065     /**
1066      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1067      * allowance.
1068      *
1069      * See {ERC20-_burn} and {ERC20-allowance}.
1070      *
1071      * Requirements:
1072      *
1073      * - the caller must have allowance for ``accounts``'s tokens of at least
1074      * `amount`.
1075      */
1076     function burnFrom(address account, uint256 amount) public virtual {
1077         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1078 
1079         _approve(account, _msgSender(), decreasedAllowance);
1080         _burn(account, amount);
1081     }
1082 }
1083 
1084 
1085 contract DNSToken is Context, Ownable, ERC20Snapshot, ERC20Burnable {
1086     using SafeMath for uint256;
1087     using Address for address;
1088 
1089     // Total Supply is 1 Billion
1090     uint256 constant TOTAL_SUPPLY   = 1000 * 1000 * 1000 ether;   
1091     uint256 constant MINE_PERCENT   = 55;                 // Proportion of miners: 55%
1092     uint256 constant FUND_PERCENT   = 15;                 // Proportion of foundation: 15%  
1093     uint256 constant TEAM_PERCENT   = 10;                 // Proportion of team: 10%
1094     uint256 constant RELEASE_TIMES  = 20;                 // Release times for foundation and team's tokens
1095     uint256 constant RELEASE_CYCLE  = 365.25 days / 4;    // Release cycle: 1 quarter
1096     
1097     // 1% Total supply for caculating
1098     uint256 constant TOTAL_SUPPLY_PERCENT   = TOTAL_SUPPLY / 100;
1099     // Amount of foundation releasing tokens Quarterly
1100     uint256 constant FUND_AMOUNT_QUARTER    = FUND_PERCENT * TOTAL_SUPPLY_PERCENT / RELEASE_TIMES;    
1101     // Amount of team releasing tokens Quarterly             
1102     uint256 constant TEAM_AMOUNT_QUARTER    = TEAM_PERCENT * TOTAL_SUPPLY_PERCENT / RELEASE_TIMES;            
1103 
1104     address private _fund_account;                        // Account of foundation used to release token 
1105     address private _team_account;                        // Account of team used to release token
1106     uint256 private _release_time;                        // Release time of next quater
1107     uint256 private _release_count;                       // Release count
1108     
1109     constructor() public ERC20("BitDNS", "DNS") {
1110         _release_count = 0;
1111         _release_time = block.timestamp.add(RELEASE_CYCLE);
1112         
1113         // Lock 80% in the contract, include the all tokens of miner, fundaction and team
1114         uint256 lock = MINE_PERCENT + FUND_PERCENT + TEAM_PERCENT;
1115         _mint(address(this), lock.mul(TOTAL_SUPPLY_PERCENT));
1116         _mint(msg.sender, (100 - lock).mul(TOTAL_SUPPLY_PERCENT));
1117     }
1118 
1119     /**
1120      * @notice Transfers tokens held by timelock to foundation and team quarterly.
1121      */
1122     function release() public onlyOwner {
1123         // solhint-disable-next-line not-rely-on-time
1124         require(block.timestamp >= _release_time, "DNSToken: current time is before next release time");
1125         require(_release_count < releaseMaxCount(), "DNSToken: release times reached max count");
1126         require(_fund_account != address(0), "DNSToken: fund account can't be a zero address");
1127         require(_team_account != address(0), "DNSToken: team account can't be a zero address");
1128 
1129         // transter
1130         address self = address(this);
1131         uint256 amount = balanceOf(self);
1132         require(amount > FUND_AMOUNT_QUARTER + TEAM_AMOUNT_QUARTER, "DNSToken: no enough tokens to release");
1133         _transfer(self, _fund_account, FUND_AMOUNT_QUARTER);
1134         _transfer(self, _team_account, TEAM_AMOUNT_QUARTER);
1135 
1136         // release completed, caculate for next quarter
1137         _release_count = _release_count.add(1);
1138         _release_time = block.timestamp.add(releaseCycle());
1139     }
1140 
1141     /**
1142      * @notice Get next release time.
1143      */
1144     function releaseTime() public view returns (uint256) {
1145         return _release_time;
1146     }
1147 
1148     /**
1149      * @notice Get Each release cycle with ms or 0.001s.
1150      */
1151     function releaseCycle() public pure returns (uint256) {
1152         return RELEASE_CYCLE;
1153     }
1154 
1155     /**
1156      * @notice Get maximum release count.
1157      */
1158     function releaseMaxCount() public pure returns (uint256) {
1159         return RELEASE_TIMES;
1160     }
1161 
1162     /**
1163      * @notice Get completed release count.
1164      */
1165     function releaseCount() public view returns (uint256) {
1166         return _release_count;
1167     }
1168 
1169     function setFundAccount(address fund_account) public onlyOwner {
1170         require(fund_account != address(0), "DNSToken: fund account can't be a zero address");
1171         _fund_account = fund_account;
1172     }
1173 
1174     function setTeamAccount(address team_account) public onlyOwner {
1175         require(team_account != address(0), "DNSToken: team account can't be a zero address");
1176         _team_account = team_account;
1177     }
1178 
1179     // Overrides
1180     function _transfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Snapshot) {
1181         super._transfer(from, to, amount);
1182     }
1183 
1184     function _mint(address account, uint256 amount) internal virtual override(ERC20, ERC20Snapshot) {
1185         super._mint(account, amount);
1186     }
1187 
1188     function _burn(address account, uint256 value) internal virtual override(ERC20, ERC20Snapshot) {
1189         super._burn(account, value);
1190     }
1191 }