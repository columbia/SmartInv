1 pragma solidity ^0.7.0;
2 
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a {Transfer} event.
20      */
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through {transferFrom}. This is
26      * zero by default.
27      *
28      * This value changes when {approve} or {transferFrom} are called.
29      */
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     /**
33      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * IMPORTANT: Beware that changing an allowance with this method brings the risk
38      * that someone may use both the old and the new allowance by unfortunate
39      * transaction ordering. One possible solution to mitigate this race
40      * condition is to first reduce the spender's allowance to 0 and set the
41      * desired value afterwards:
42      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43      *
44      * Emits an {Approval} event.
45      */
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Moves `amount` tokens from `sender` to `recipient` using the
50      * allowance mechanism. `amount` is then deducted from the caller's
51      * allowance.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Emitted when `value` tokens are moved from one account (`from`) to
61      * another (`to`).
62      *
63      * Note that `value` may be zero.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /**
68      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69      * a call to {approve}. `value` is the new allowance.
70      */
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 /**
75  * @dev Collection of functions related to the address type
76  */
77 library Address {
78     /**
79      * @dev Returns true if `account` is a contract.
80      *
81      * [IMPORTANT]
82      * ====
83      * It is unsafe to assume that an address for which this function returns
84      * false is an externally-owned account (EOA) and not a contract.
85      *
86      * Among others, `isContract` will return false for the following
87      * types of addresses:
88      *
89      *  - an externally-owned account
90      *  - a contract in construction
91      *  - an address where a contract will be created
92      *  - an address where a contract lived, but was destroyed
93      * ====
94      */
95     function isContract(address account) internal view returns (bool) {
96         // This method relies on extcodesize, which returns 0 for contracts in
97         // construction, since the code is only stored at the end of the
98         // constructor execution.
99 
100         uint256 size;
101         // solhint-disable-next-line no-inline-assembly
102         assembly { size := extcodesize(account) }
103         return size > 0;
104     }
105 
106     /**
107      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
108      * `recipient`, forwarding all available gas and reverting on errors.
109      *
110      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
111      * of certain opcodes, possibly making contracts go over the 2300 gas limit
112      * imposed by `transfer`, making them unable to receive funds via
113      * `transfer`. {sendValue} removes this limitation.
114      *
115      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
116      *
117      * IMPORTANT: because control is transferred to `recipient`, care must be
118      * taken to not create reentrancy vulnerabilities. Consider using
119      * {ReentrancyGuard} or the
120      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
121      */
122     function sendValue(address payable recipient, uint256 amount) internal {
123         require(address(this).balance >= amount, "Address: insufficient balance");
124 
125         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
126         (bool success, ) = recipient.call{ value: amount }("");
127         require(success, "Address: unable to send value, recipient may have reverted");
128     }
129 
130     /**
131      * @dev Performs a Solidity function call using a low level `call`. A
132      * plain`call` is an unsafe replacement for a function call: use this
133      * function instead.
134      *
135      * If `target` reverts with a revert reason, it is bubbled up by this
136      * function (like regular Solidity function calls).
137      *
138      * Returns the raw returned data. To convert to the expected return value,
139      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
140      *
141      * Requirements:
142      *
143      * - `target` must be a contract.
144      * - calling `target` with `data` must not revert.
145      *
146      * _Available since v3.1._
147      */
148     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
149       return functionCall(target, data, "Address: low-level call failed");
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
154      * `errorMessage` as a fallback revert reason when `target` reverts.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
159         return functionCallWithValue(target, data, 0, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
164      * but also transferring `value` wei to `target`.
165      *
166      * Requirements:
167      *
168      * - the calling contract must have an ETH balance of at least `value`.
169      * - the called Solidity function must be `payable`.
170      *
171      * _Available since v3.1._
172      */
173     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
179      * with `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
184         require(address(this).balance >= value, "Address: insufficient balance for call");
185         require(isContract(target), "Address: call to non-contract");
186 
187         // solhint-disable-next-line avoid-low-level-calls
188         (bool success, bytes memory returndata) = target.call{ value: value }(data);
189         return _verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but performing a static call.
195      *
196      * _Available since v3.3._
197      */
198     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
199         return functionStaticCall(target, data, "Address: low-level static call failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
204      * but performing a static call.
205      *
206      * _Available since v3.3._
207      */
208     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
209         require(isContract(target), "Address: static call to non-contract");
210 
211         // solhint-disable-next-line avoid-low-level-calls
212         (bool success, bytes memory returndata) = target.staticcall(data);
213         return _verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but performing a delegate call.
219      *
220      * _Available since v3.3._
221      */
222     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
223         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
228      * but performing a delegate call.
229      *
230      * _Available since v3.3._
231      */
232     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
233         require(isContract(target), "Address: delegate call to non-contract");
234 
235         // solhint-disable-next-line avoid-low-level-calls
236         (bool success, bytes memory returndata) = target.delegatecall(data);
237         return _verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
241         if (success) {
242             return returndata;
243         } else {
244             // Look for revert reason and bubble it up if present
245             if (returndata.length > 0) {
246                 // The easiest way to bubble the revert reason is using memory via assembly
247 
248                 // solhint-disable-next-line no-inline-assembly
249                 assembly {
250                     let returndata_size := mload(returndata)
251                     revert(add(32, returndata), returndata_size)
252                 }
253             } else {
254                 revert(errorMessage);
255             }
256         }
257     }
258 }
259 
260 /**
261  * @dev Standard math utilities missing in the Solidity language.
262  */
263 library Math {
264     /**
265      * @dev Returns the largest of two numbers.
266      */
267     function max(uint256 a, uint256 b) internal pure returns (uint256) {
268         return a >= b ? a : b;
269     }
270 
271     /**
272      * @dev Returns the smallest of two numbers.
273      */
274     function min(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a < b ? a : b;
276     }
277 
278     /**
279      * @dev Returns the average of two numbers. The result is rounded towards
280      * zero.
281      */
282     function average(uint256 a, uint256 b) internal pure returns (uint256) {
283         // (a + b) / 2 can overflow, so we distribute
284         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
285     }
286 }
287 
288 library Arrays {
289    /**
290      * @dev Searches a sorted `array` and returns the first index that contains
291      * a value greater or equal to `element`. If no such index exists (i.e. all
292      * values in the array are strictly less than `element`), the array length is
293      * returned. Time complexity O(log n).
294      *
295      * `array` is expected to be sorted in ascending order, and to contain no
296      * repeated elements.
297      */
298     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
299         if (array.length == 0) {
300             return 0;
301         }
302 
303         uint256 low = 0;
304         uint256 high = array.length;
305 
306         while (low < high) {
307             uint256 mid = Math.average(low, high);
308 
309             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
310             // because Math.average rounds down (it does integer division with truncation).
311             if (array[mid] > element) {
312                 high = mid;
313             } else {
314                 low = mid + 1;
315             }
316         }
317 
318         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
319         if (low > 0 && array[low - 1] == element) {
320             return low - 1;
321         } else {
322             return low;
323         }
324     }
325 }
326 
327 library SafeERC20 {
328     using SafeMath for uint256;
329     using Address for address;
330 
331     function safeTransfer(IERC20 token, address to, uint256 value) internal {
332         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
333     }
334 
335     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
336         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
337     }
338 
339     /**
340      * @dev Deprecated. This function has issues similar to the ones found in
341      * {IERC20-approve}, and its usage is discouraged.
342      *
343      * Whenever possible, use {safeIncreaseAllowance} and
344      * {safeDecreaseAllowance} instead.
345      */
346     function safeApprove(IERC20 token, address spender, uint256 value) internal {
347         // safeApprove should only be called when setting an initial allowance,
348         // or when resetting it to zero. To increase and decrease it, use
349         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
350         // solhint-disable-next-line max-line-length
351         require((value == 0) || (token.allowance(address(this), spender) == 0),
352             "SafeERC20: approve from non-zero to non-zero allowance"
353         );
354         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
355     }
356 
357     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
358         uint256 newAllowance = token.allowance(address(this), spender).add(value);
359         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
360     }
361 
362     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
363         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
364         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
365     }
366 
367     /**
368      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
369      * on the return value: the return value is optional (but if data is returned, it must not be false).
370      * @param token The token targeted by the call.
371      * @param data The call data (encoded using abi.encode or one of its variants).
372      */
373     function _callOptionalReturn(IERC20 token, bytes memory data) private {
374         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
375         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
376         // the target address contains contract code and also asserts for success in the low-level call.
377 
378         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
379         if (returndata.length > 0) { // Return data is optional
380             // solhint-disable-next-line max-line-length
381             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
382         }
383     }
384 }
385 
386 library SafeMath {
387     /**
388      * @dev Returns the addition of two unsigned integers, reverting on
389      * overflow.
390      *
391      * Counterpart to Solidity's `+` operator.
392      *
393      * Requirements:
394      *
395      * - Addition cannot overflow.
396      */
397     function add(uint256 a, uint256 b) internal pure returns (uint256) {
398         uint256 c = a + b;
399         require(c >= a, "SafeMath: addition overflow");
400 
401         return c;
402     }
403 
404     /**
405      * @dev Returns the subtraction of two unsigned integers, reverting on
406      * overflow (when the result is negative).
407      *
408      * Counterpart to Solidity's `-` operator.
409      *
410      * Requirements:
411      *
412      * - Subtraction cannot overflow.
413      */
414     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
415         return sub(a, b, "SafeMath: subtraction overflow");
416     }
417 
418     /**
419      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
420      * overflow (when the result is negative).
421      *
422      * Counterpart to Solidity's `-` operator.
423      *
424      * Requirements:
425      *
426      * - Subtraction cannot overflow.
427      */
428     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
429         require(b <= a, errorMessage);
430         uint256 c = a - b;
431 
432         return c;
433     }
434 
435     /**
436      * @dev Returns the multiplication of two unsigned integers, reverting on
437      * overflow.
438      *
439      * Counterpart to Solidity's `*` operator.
440      *
441      * Requirements:
442      *
443      * - Multiplication cannot overflow.
444      */
445     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
446         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
447         // benefit is lost if 'b' is also tested.
448         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
449         if (a == 0) {
450             return 0;
451         }
452 
453         uint256 c = a * b;
454         require(c / a == b, "SafeMath: multiplication overflow");
455 
456         return c;
457     }
458 
459     /**
460      * @dev Returns the integer division of two unsigned integers. Reverts on
461      * division by zero. The result is rounded towards zero.
462      *
463      * Counterpart to Solidity's `/` operator. Note: this function uses a
464      * `revert` opcode (which leaves remaining gas untouched) while Solidity
465      * uses an invalid opcode to revert (consuming all remaining gas).
466      *
467      * Requirements:
468      *
469      * - The divisor cannot be zero.
470      */
471     function div(uint256 a, uint256 b) internal pure returns (uint256) {
472         return div(a, b, "SafeMath: division by zero");
473     }
474 
475     /**
476      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
477      * division by zero. The result is rounded towards zero.
478      *
479      * Counterpart to Solidity's `/` operator. Note: this function uses a
480      * `revert` opcode (which leaves remaining gas untouched) while Solidity
481      * uses an invalid opcode to revert (consuming all remaining gas).
482      *
483      * Requirements:
484      *
485      * - The divisor cannot be zero.
486      */
487     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
488         require(b > 0, errorMessage);
489         uint256 c = a / b;
490         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
491 
492         return c;
493     }
494 
495     /**
496      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
497      * Reverts when dividing by zero.
498      *
499      * Counterpart to Solidity's `%` operator. This function uses a `revert`
500      * opcode (which leaves remaining gas untouched) while Solidity uses an
501      * invalid opcode to revert (consuming all remaining gas).
502      *
503      * Requirements:
504      *
505      * - The divisor cannot be zero.
506      */
507     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
508         return mod(a, b, "SafeMath: modulo by zero");
509     }
510 
511     /**
512      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
513      * Reverts with custom message when dividing by zero.
514      *
515      * Counterpart to Solidity's `%` operator. This function uses a `revert`
516      * opcode (which leaves remaining gas untouched) while Solidity uses an
517      * invalid opcode to revert (consuming all remaining gas).
518      *
519      * Requirements:
520      *
521      * - The divisor cannot be zero.
522      */
523     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
524         require(b != 0, errorMessage);
525         return a % b;
526     }
527 }
528 
529 abstract contract Context {
530     function _msgSender() internal view virtual returns (address payable) {
531         return msg.sender;
532     }
533 
534     function _msgData() internal view virtual returns (bytes memory) {
535         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
536         return msg.data;
537     }
538 }
539 
540 contract Ownable is Context {
541     address private _owner;
542 
543     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
544 
545     /**
546      * @dev Initializes the contract setting the deployer as the initial owner.
547      */
548     constructor () {
549         address msgSender = _msgSender();
550         _owner = msgSender;
551         emit OwnershipTransferred(address(0), msgSender);
552     }
553 
554     /**
555      * @dev Returns the address of the current owner.
556      */
557     function owner() public view returns (address) {
558         return _owner;
559     }
560 
561     /**
562      * @dev Throws if called by any account other than the owner.
563      */
564     modifier onlyOwner() {
565         require(_owner == _msgSender(), "Ownable: caller is not the owner");
566         _;
567     }
568 
569     /**
570      * @dev Leaves the contract without owner. It will not be possible to call
571      * `onlyOwner` functions anymore. Can only be called by the current owner.
572      *
573      * NOTE: Renouncing ownership will leave the contract without an owner,
574      * thereby removing any functionality that is only available to the owner.
575      */
576     function renounceOwnership() public virtual onlyOwner {
577         emit OwnershipTransferred(_owner, address(0));
578         _owner = address(0);
579     }
580 
581     /**
582      * @dev Transfers ownership of the contract to a new account (`newOwner`).
583      * Can only be called by the current owner.
584      */
585     function transferOwnership(address newOwner) public virtual onlyOwner {
586         require(newOwner != address(0), "Ownable: new owner is the zero address");
587         emit OwnershipTransferred(_owner, newOwner);
588         _owner = newOwner;
589     }
590 }
591 
592 
593 contract ERC20 is Context, IERC20 {
594     using SafeMath for uint256;
595 
596     mapping (address => uint256) private _balances;
597 
598     mapping (address => mapping (address => uint256)) private _allowances;
599 
600     uint256 private _totalSupply;
601 
602     string private _name;
603     string private _symbol;
604     uint8 private _decimals;
605 
606     /**
607      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
608      * a default value of 18.
609      *
610      * To select a different value for {decimals}, use {_setupDecimals}.
611      *
612      * All three of these values are immutable: they can only be set once during
613      * construction.
614      */
615     constructor (string memory name, string memory symbol) {
616         _name = name;
617         _symbol = symbol;
618         _decimals = 18;
619     }
620 
621     /**
622      * @dev Returns the name of the token.
623      */
624     function name() public view returns (string memory) {
625         return _name;
626     }
627 
628     /**
629      * @dev Returns the symbol of the token, usually a shorter version of the
630      * name.
631      */
632     function symbol() public view returns (string memory) {
633         return _symbol;
634     }
635 
636     /**
637      * @dev Returns the number of decimals used to get its user representation.
638      * For example, if `decimals` equals `2`, a balance of `505` tokens should
639      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
640      *
641      * Tokens usually opt for a value of 18, imitating the relationship between
642      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
643      * called.
644      *
645      * NOTE: This information is only used for _display_ purposes: it in
646      * no way affects any of the arithmetic of the contract, including
647      * {IERC20-balanceOf} and {IERC20-transfer}.
648      */
649     function decimals() public view returns (uint8) {
650         return _decimals;
651     }
652 
653     /**
654      * @dev See {IERC20-totalSupply}.
655      */
656     function totalSupply() public view override returns (uint256) {
657         return _totalSupply;
658     }
659 
660     /**
661      * @dev See {IERC20-balanceOf}.
662      */
663     function balanceOf(address account) public view override returns (uint256) {
664         return _balances[account];
665     }
666 
667     /**
668      * @dev See {IERC20-transfer}.
669      *
670      * Requirements:
671      *
672      * - `recipient` cannot be the zero address.
673      * - the caller must have a balance of at least `amount`.
674      */
675     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
676         _transfer(_msgSender(), recipient, amount);
677         return true;
678     }
679 
680     /**
681      * @dev See {IERC20-allowance}.
682      */
683     function allowance(address owner, address spender) public view virtual override returns (uint256) {
684         return _allowances[owner][spender];
685     }
686 
687     /**
688      * @dev See {IERC20-approve}.
689      *
690      * Requirements:
691      *
692      * - `spender` cannot be the zero address.
693      */
694     function approve(address spender, uint256 amount) public virtual override returns (bool) {
695         _approve(_msgSender(), spender, amount);
696         return true;
697     }
698 
699     /**
700      * @dev See {IERC20-transferFrom}.
701      *
702      * Emits an {Approval} event indicating the updated allowance. This is not
703      * required by the EIP. See the note at the beginning of {ERC20}.
704      *
705      * Requirements:
706      *
707      * - `sender` and `recipient` cannot be the zero address.
708      * - `sender` must have a balance of at least `amount`.
709      * - the caller must have allowance for ``sender``'s tokens of at least
710      * `amount`.
711      */
712     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
713         _transfer(sender, recipient, amount);
714         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
715         return true;
716     }
717 
718     /**
719      * @dev Atomically increases the allowance granted to `spender` by the caller.
720      *
721      * This is an alternative to {approve} that can be used as a mitigation for
722      * problems described in {IERC20-approve}.
723      *
724      * Emits an {Approval} event indicating the updated allowance.
725      *
726      * Requirements:
727      *
728      * - `spender` cannot be the zero address.
729      */
730     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
731         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
732         return true;
733     }
734 
735     /**
736      * @dev Atomically decreases the allowance granted to `spender` by the caller.
737      *
738      * This is an alternative to {approve} that can be used as a mitigation for
739      * problems described in {IERC20-approve}.
740      *
741      * Emits an {Approval} event indicating the updated allowance.
742      *
743      * Requirements:
744      *
745      * - `spender` cannot be the zero address.
746      * - `spender` must have allowance for the caller of at least
747      * `subtractedValue`.
748      */
749     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
750         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
751         return true;
752     }
753 
754     /**
755      * @dev Moves tokens `amount` from `sender` to `recipient`.
756      *
757      * This is internal function is equivalent to {transfer}, and can be used to
758      * e.g. implement automatic token fees, slashing mechanisms, etc.
759      *
760      * Emits a {Transfer} event.
761      *
762      * Requirements:
763      *
764      * - `sender` cannot be the zero address.
765      * - `recipient` cannot be the zero address.
766      * - `sender` must have a balance of at least `amount`.
767      */
768     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
769         require(sender != address(0), "ERC20: transfer from the zero address");
770         require(recipient != address(0), "ERC20: transfer to the zero address");
771 
772         _beforeTokenTransfer(sender, recipient, amount);
773 
774         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
775         _balances[recipient] = _balances[recipient].add(amount);
776         emit Transfer(sender, recipient, amount);
777     }
778 
779     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
780      * the total supply.
781      *
782      * Emits a {Transfer} event with `from` set to the zero address.
783      *
784      * Requirements:
785      *
786      * - `to` cannot be the zero address.
787      */
788     function _mint(address account, uint256 amount) internal virtual {
789         require(account != address(0), "ERC20: mint to the zero address");
790 
791         _beforeTokenTransfer(address(0), account, amount);
792 
793         _totalSupply = _totalSupply.add(amount);
794         _balances[account] = _balances[account].add(amount);
795         emit Transfer(address(0), account, amount);
796     }
797 
798     /**
799      * @dev Destroys `amount` tokens from `account`, reducing the
800      * total supply.
801      *
802      * Emits a {Transfer} event with `to` set to the zero address.
803      *
804      * Requirements:
805      *
806      * - `account` cannot be the zero address.
807      * - `account` must have at least `amount` tokens.
808      */
809     function _burn(address account, uint256 amount) internal virtual {
810         require(account != address(0), "ERC20: burn from the zero address");
811 
812         _beforeTokenTransfer(account, address(0), amount);
813 
814         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
815         _totalSupply = _totalSupply.sub(amount);
816         emit Transfer(account, address(0), amount);
817     }
818 
819     /**
820      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
821      *
822      * This internal function is equivalent to `approve`, and can be used to
823      * e.g. set automatic allowances for certain subsystems, etc.
824      *
825      * Emits an {Approval} event.
826      *
827      * Requirements:
828      *
829      * - `owner` cannot be the zero address.
830      * - `spender` cannot be the zero address.
831      */
832     function _approve(address owner, address spender, uint256 amount) internal virtual {
833         require(owner != address(0), "ERC20: approve from the zero address");
834         require(spender != address(0), "ERC20: approve to the zero address");
835 
836         _allowances[owner][spender] = amount;
837         emit Approval(owner, spender, amount);
838     }
839 
840     /**
841      * @dev Sets {decimals} to a value other than the default one of 18.
842      *
843      * WARNING: This function should only be called from the constructor. Most
844      * applications that interact with token contracts will not expect
845      * {decimals} to ever change, and may work incorrectly if it does.
846      */
847     function _setupDecimals(uint8 decimals_) internal {
848         _decimals = decimals_;
849     }
850 
851     /**
852      * @dev Hook that is called before any transfer of tokens. This includes
853      * minting and burning.
854      *
855      * Calling conditions:
856      *
857      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
858      * will be to transferred to `to`.
859      * - when `from` is zero, `amount` tokens will be minted for `to`.
860      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
861      * - `from` and `to` are never both zero.
862      *
863      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
864      */
865     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
866 }
867 
868 
869 contract DokiCoinCore is ERC20("DokiDokiFinance", "DOKI") {
870     using SafeMath for uint256;
871 
872     address internal _taxer;
873     address internal _taxDestination;
874     uint internal _taxRate = 0;
875     mapping (address => bool) internal _taxWhitelist;
876 
877     function transfer(address recipient, uint256 amount) public override returns (bool) {
878         uint256 taxAmount = amount.mul(_taxRate).div(100);
879         if (_taxWhitelist[msg.sender] == true) {
880             taxAmount = 0;
881         }
882         uint256 transferAmount = amount.sub(taxAmount);
883         require(balanceOf(msg.sender) >= transferAmount, "insufficient balance.");
884         super.transfer(recipient, amount);
885 
886         if (taxAmount != 0) {
887             super.transfer(_taxDestination, taxAmount);
888         }
889         return true;
890     }
891 
892     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
893         uint256 taxAmount = amount.mul(_taxRate).div(100);
894         if (_taxWhitelist[sender] == true) {
895             taxAmount = 0;
896         }
897         uint256 transferAmount = amount.sub(taxAmount);
898         require(balanceOf(sender) >= transferAmount, "insufficient balance.");
899         super.transferFrom(sender, recipient, amount);
900         if (taxAmount != 0) {
901             super.transferFrom(sender, _taxDestination, taxAmount);
902         }
903         return true;
904     }
905 }
906 
907 contract DokiCoin is DokiCoinCore, Ownable {
908     mapping (address => bool) public minters;
909 
910     constructor() {
911         _taxer = owner();
912         _taxDestination = owner();
913     }
914 
915     function mint(address to, uint amount) public onlyMinter {
916         _mint(to, amount);
917     }
918 
919     function burn(uint amount) public {
920         require(amount > 0);
921         require(balanceOf(msg.sender) >= amount);
922         _burn(msg.sender, amount);
923     }
924 
925     function addMinter(address account) public onlyOwner {
926         minters[account] = true;
927     }
928 
929     function removeMinter(address account) public onlyOwner {
930         minters[account] = false;
931     }
932 
933     modifier onlyMinter() {
934         require(minters[msg.sender], "Restricted to minters.");
935         _;
936     }
937 
938     modifier onlyTaxer() {
939         require(msg.sender == _taxer, "Only for taxer.");
940         _;
941     }
942 
943     function setTaxer(address account) public onlyTaxer {
944         _taxer = account;
945     }
946 
947     function setTaxRate(uint256 rate) public onlyTaxer {
948         _taxRate = rate;
949     }
950 
951     function setTaxDestination(address account) public onlyTaxer {
952         _taxDestination = account;
953     }
954 
955     function addToWhitelist(address account) public onlyTaxer {
956         _taxWhitelist[account] = true;
957     }
958 
959     function removeFromWhitelist(address account) public onlyTaxer {
960         _taxWhitelist[account] = false;
961     }
962 
963     function taxer() public view returns(address) {
964         return _taxer;
965     }
966 
967     function taxDestination() public view returns(address) {
968         return _taxDestination;
969     }
970 
971     function taxRate() public view returns(uint256) {
972         return _taxRate;
973     }
974 
975     function isInWhitelist(address account) public view returns(bool) {
976         return _taxWhitelist[account];
977     }
978 }
979 
980 
981 contract LPToDOKI is Ownable {
982     using SafeMath for uint256;
983     using SafeERC20 for DokiCoin;
984     using SafeERC20 for IERC20;
985     using Address for address;
986 
987     DokiCoin private doki;
988     IERC20 private lpToken;
989 
990     //LP token balances
991     mapping(address => uint256) private _lpBalances;
992     uint private _lpTotalSupply;
993 
994     // halving period time
995     uint256 public constant DURATION = 2 weeks;
996     // initial amount of doki
997     uint256 public initReward = 500 * 1e18;
998     bool public haveStarted = false;
999     // next time of halving
1000     uint256 public halvingTime = 0;
1001     uint256 public lastUpdateTime = 0;
1002     // distribution of per second
1003     uint256 public rewardRate = 0;
1004     uint256 public rewardPerLPToken = 0;
1005     mapping(address => uint256) private rewards;
1006     mapping(address => uint256) private userRewardPerTokenPaid;
1007 
1008 
1009     // Something about dev.
1010     address public devAddr;
1011     uint256 public devDistributeRate = 0;
1012     uint256 public lastDistributeTime = 0;
1013     uint256 public devFinishTime = 0;
1014     uint256 public devFundAmount = 90 * 1e18;
1015     uint256 public devDistributeDuration = 180 days;
1016 
1017     event Stake(address indexed from, uint amount);
1018     event Withdraw(address indexed to, uint amount);
1019     event Claim(address indexed to, uint amount);
1020     event Halving(uint amount);
1021     event Start(uint amount);
1022 
1023     constructor(address _doki, address _lpToken) {
1024         doki = DokiCoin(_doki);
1025         lpToken = IERC20(_lpToken);
1026         devAddr = owner();
1027     }
1028 
1029     function totalSupply() public view returns(uint256) {
1030         return _lpTotalSupply;
1031     }
1032 
1033     function balanceOf(address account) public view returns(uint256) {
1034         return _lpBalances[account];
1035     }
1036 
1037     function stake(uint amount) public shouldStarted {
1038         updateRewards(msg.sender);
1039         checkHalving();
1040         require(!address(msg.sender).isContract(), "Please use your individual account.");
1041         lpToken.safeTransferFrom(msg.sender, address(this), amount);
1042         _lpTotalSupply = _lpTotalSupply.add(amount);
1043         _lpBalances[msg.sender] = _lpBalances[msg.sender].add(amount);
1044         distributeDevFund();
1045         emit Stake(msg.sender, amount);
1046     }
1047 
1048     function withdraw(uint amount) public shouldStarted {
1049         updateRewards(msg.sender);
1050         checkHalving();
1051         require(amount <= _lpBalances[msg.sender] && _lpBalances[msg.sender] > 0, "Bad withdraw.");
1052         lpToken.safeTransfer(msg.sender, amount);
1053         _lpTotalSupply = _lpTotalSupply.sub(amount);
1054         _lpBalances[msg.sender] = _lpBalances[msg.sender].sub(amount);
1055         distributeDevFund();
1056         emit Withdraw(msg.sender, amount);
1057     }
1058 
1059     function claim(uint amount) public shouldStarted {
1060         updateRewards(msg.sender);
1061         checkHalving();
1062         require(amount <= rewards[msg.sender] && rewards[msg.sender] > 0, "Bad claim.");
1063         rewards[msg.sender] = rewards[msg.sender].sub(amount);
1064         doki.safeTransfer(msg.sender, amount);
1065         distributeDevFund();
1066         emit Claim(msg.sender, amount);
1067     }
1068 
1069     function checkHalving() internal {
1070         if (block.timestamp >= halvingTime) {
1071             initReward = initReward.mul(50).div(100);
1072             doki.mint(address(this), initReward);
1073 
1074             rewardRate = initReward.div(DURATION);
1075             halvingTime = halvingTime.add(DURATION);
1076 
1077             updateRewards(msg.sender);
1078             emit Halving(initReward);
1079         }
1080     }
1081 
1082     modifier shouldStarted() {
1083         require(haveStarted == true, "Have not started.");
1084         _;
1085     }
1086 
1087     function getRewardsAmount(address account) public view returns(uint256) {
1088         return balanceOf(account).mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
1089                 .div(1e18)
1090                 .add(rewards[account]);
1091     }
1092 
1093     function rewardPerToken() public view returns (uint256) {
1094         if (_lpTotalSupply == 0) {
1095             return rewardPerLPToken;
1096         }
1097         return rewardPerLPToken
1098             .add(Math.min(block.timestamp, halvingTime)
1099                     .sub(lastUpdateTime)
1100                     .mul(rewardRate)
1101                     .mul(1e18)
1102                     .div(_lpTotalSupply)
1103             );
1104     }
1105 
1106     function updateRewards(address account) internal {
1107         rewardPerLPToken = rewardPerToken();
1108         lastUpdateTime = lastRewardTime();
1109         if (account != address(0)) {
1110             rewards[account] = getRewardsAmount(account);
1111             userRewardPerTokenPaid[account] = rewardPerLPToken;
1112         }
1113     }
1114 
1115     function lastRewardTime() public view returns (uint256) {
1116         return Math.min(block.timestamp, halvingTime);
1117     }
1118 
1119     function startFarming() external onlyOwner {
1120         updateRewards(address(0));
1121         rewardRate = initReward.div(DURATION);
1122 
1123         uint256 mintAmount = initReward.add(devFundAmount);
1124         doki.mint(address(this), mintAmount);
1125         devDistributeRate = devFundAmount.div(devDistributeDuration);
1126         devFinishTime = block.timestamp.add(devDistributeDuration);
1127 
1128         lastUpdateTime = block.timestamp;
1129         lastDistributeTime = block.timestamp;
1130         halvingTime = block.timestamp.add(DURATION);
1131 
1132         haveStarted = true;
1133         emit Start(mintAmount);
1134     }
1135 
1136     function transferDevAddr(address newAddr) public onlyDev {
1137         require(newAddr != address(0), "zero addr");
1138         devAddr = newAddr;
1139     }
1140 
1141     function distributeDevFund() internal {
1142         uint256 nowTime = Math.min(block.timestamp, devFinishTime);
1143         uint256 fundAmount = nowTime.sub(lastDistributeTime).mul(devDistributeRate);
1144         doki.safeTransfer(devAddr, fundAmount);
1145         lastDistributeTime = nowTime;
1146     }
1147 
1148     modifier onlyDev() {
1149         require(msg.sender == devAddr, "This is only for dev.");
1150         _;
1151     }
1152 
1153     function lpTokenAddress() view public returns(address) {
1154         return address(lpToken);
1155     }
1156 
1157     function dokiAddress() view public returns(address) {
1158         return address(doki);
1159     }
1160 
1161     function testMint() public onlyOwner {
1162         doki.mint(address(this), 1);
1163     }
1164 }