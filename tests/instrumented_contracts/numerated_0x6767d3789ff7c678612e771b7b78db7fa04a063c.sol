1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 pragma experimental ABIEncoderV2;
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 
19 
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
162 contract Context {
163     function _msgSender() internal view virtual returns (address payable) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes memory) {
168         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
169         return msg.data;
170     }
171 }
172 
173 library Address {
174     /**
175      * @dev Returns true if `account` is a contract.
176      *
177      * [IMPORTANT]
178      * ====
179      * It is unsafe to assume that an address for which this function returns
180      * false is an externally-owned account (EOA) and not a contract.
181      *
182      * Among others, `isContract` will return false for the following
183      * types of addresses:
184      *
185      *  - an externally-owned account
186      *  - a contract in construction
187      *  - an address where a contract will be created
188      *  - an address where a contract lived, but was destroyed
189      * ====
190      */
191     function isContract(address account) internal view returns (bool) {
192         // This method relies on extcodesize, which returns 0 for contracts in
193         // construction, since the code is only stored at the end of the
194         // constructor execution.
195 
196         uint256 size;
197         // solhint-disable-next-line no-inline-assembly
198         assembly { size := extcodesize(account) }
199         return size > 0;
200     }
201 
202     /**
203      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
204      * `recipient`, forwarding all available gas and reverting on errors.
205      *
206      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
207      * of certain opcodes, possibly making contracts go over the 2300 gas limit
208      * imposed by `transfer`, making them unable to receive funds via
209      * `transfer`. {sendValue} removes this limitation.
210      *
211      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
212      *
213      * IMPORTANT: because control is transferred to `recipient`, care must be
214      * taken to not create reentrancy vulnerabilities. Consider using
215      * {ReentrancyGuard} or the
216      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
217      */
218     function sendValue(address payable recipient, uint256 amount) internal {
219         require(address(this).balance >= amount, "Address: insufficient balance");
220 
221         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
222         (bool success, ) = recipient.call{ value: amount }("");
223         require(success, "Address: unable to send value, recipient may have reverted");
224     }
225 
226     /**
227      * @dev Performs a Solidity function call using a low level `call`. A
228      * plain`call` is an unsafe replacement for a function call: use this
229      * function instead.
230      *
231      * If `target` reverts with a revert reason, it is bubbled up by this
232      * function (like regular Solidity function calls).
233      *
234      * Returns the raw returned data. To convert to the expected return value,
235      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
236      *
237      * Requirements:
238      *
239      * - `target` must be a contract.
240      * - calling `target` with `data` must not revert.
241      *
242      * _Available since v3.1._
243      */
244     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
245       return functionCall(target, data, "Address: low-level call failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
250      * `errorMessage` as a fallback revert reason when `target` reverts.
251      *
252      * _Available since v3.1._
253      */
254     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
255         return functionCallWithValue(target, data, 0, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but also transferring `value` wei to `target`.
261      *
262      * Requirements:
263      *
264      * - the calling contract must have an ETH balance of at least `value`.
265      * - the called Solidity function must be `payable`.
266      *
267      * _Available since v3.1._
268      */
269     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
270         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
275      * with `errorMessage` as a fallback revert reason when `target` reverts.
276      *
277      * _Available since v3.1._
278      */
279     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
280         require(address(this).balance >= value, "Address: insufficient balance for call");
281         require(isContract(target), "Address: call to non-contract");
282 
283         // solhint-disable-next-line avoid-low-level-calls
284         (bool success, bytes memory returndata) = target.call{ value: value }(data);
285         return _verifyCallResult(success, returndata, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but performing a static call.
291      *
292      * _Available since v3.3._
293      */
294     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
295         return functionStaticCall(target, data, "Address: low-level static call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
300      * but performing a static call.
301      *
302      * _Available since v3.3._
303      */
304     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
305         require(isContract(target), "Address: static call to non-contract");
306 
307         // solhint-disable-next-line avoid-low-level-calls
308         (bool success, bytes memory returndata) = target.staticcall(data);
309         return _verifyCallResult(success, returndata, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but performing a delegate call.
315      *
316      * _Available since v3.3._
317      */
318     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
324      * but performing a delegate call.
325      *
326      * _Available since v3.3._
327      */
328     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
329         require(isContract(target), "Address: delegate call to non-contract");
330 
331         // solhint-disable-next-line avoid-low-level-calls
332         (bool success, bytes memory returndata) = target.delegatecall(data);
333         return _verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
337         if (success) {
338             return returndata;
339         } else {
340             // Look for revert reason and bubble it up if present
341             if (returndata.length > 0) {
342                 // The easiest way to bubble the revert reason is using memory via assembly
343 
344                 // solhint-disable-next-line no-inline-assembly
345                 assembly {
346                     let returndata_size := mload(returndata)
347                     revert(add(32, returndata), returndata_size)
348                 }
349             } else {
350                 revert(errorMessage);
351             }
352         }
353     }
354 }
355 
356 interface IERC20 {
357     /**
358      * @dev Returns the amount of tokens in existence.
359      */
360     function totalSupply() external view returns (uint256);
361 
362     /**
363      * @dev Returns the amount of tokens owned by `account`.
364      */
365     function balanceOf(address account) external view returns (uint256);
366 
367     /**
368      * @dev Moves `amount` tokens from the caller's account to `recipient`.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * Emits a {Transfer} event.
373      */
374     function transfer(address recipient, uint256 amount) external returns (bool);
375 
376     /**
377      * @dev Returns the remaining number of tokens that `spender` will be
378      * allowed to spend on behalf of `owner` through {transferFrom}. This is
379      * zero by default.
380      *
381      * This value changes when {approve} or {transferFrom} are called.
382      */
383     function allowance(address owner, address spender) external view returns (uint256);
384 
385     /**
386      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * IMPORTANT: Beware that changing an allowance with this method brings the risk
391      * that someone may use both the old and the new allowance by unfortunate
392      * transaction ordering. One possible solution to mitigate this race
393      * condition is to first reduce the spender's allowance to 0 and set the
394      * desired value afterwards:
395      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
396      *
397      * Emits an {Approval} event.
398      */
399     function approve(address spender, uint256 amount) external returns (bool);
400 
401     /**
402      * @dev Moves `amount` tokens from `sender` to `recipient` using the
403      * allowance mechanism. `amount` is then deducted from the caller's
404      * allowance.
405      *
406      * Returns a boolean value indicating whether the operation succeeded.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
411 
412     /**
413      * @dev Emitted when `value` tokens are moved from one account (`from`) to
414      * another (`to`).
415      *
416      * Note that `value` may be zero.
417      */
418     event Transfer(address indexed from, address indexed to, uint256 value);
419 
420     /**
421      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
422      * a call to {approve}. `value` is the new allowance.
423      */
424     event Approval(address indexed owner, address indexed spender, uint256 value);
425 }
426 
427 library SafeERC20 {
428     using SafeMath for uint256;
429     using Address for address;
430 
431     function safeTransfer(IERC20 token, address to, uint256 value) internal {
432         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
433     }
434 
435     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
436         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
437     }
438 
439     /**
440      * @dev Deprecated. This function has issues similar to the ones found in
441      * {IERC20-approve}, and its usage is discouraged.
442      *
443      * Whenever possible, use {safeIncreaseAllowance} and
444      * {safeDecreaseAllowance} instead.
445      */
446     function safeApprove(IERC20 token, address spender, uint256 value) internal {
447         // safeApprove should only be called when setting an initial allowance,
448         // or when resetting it to zero. To increase and decrease it, use
449         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
450         // solhint-disable-next-line max-line-length
451         require((value == 0) || (token.allowance(address(this), spender) == 0),
452             "SafeERC20: approve from non-zero to non-zero allowance"
453         );
454         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
455     }
456 
457     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
458         uint256 newAllowance = token.allowance(address(this), spender).add(value);
459         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
460     }
461 
462     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
463         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
464         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
465     }
466 
467     /**
468      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
469      * on the return value: the return value is optional (but if data is returned, it must not be false).
470      * @param token The token targeted by the call.
471      * @param data The call data (encoded using abi.encode or one of its variants).
472      */
473     function _callOptionalReturn(IERC20 token, bytes memory data) private {
474         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
475         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
476         // the target address contains contract code and also asserts for success in the low-level call.
477 
478         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
479         if (returndata.length > 0) { // Return data is optional
480             // solhint-disable-next-line max-line-length
481             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
482         }
483     }
484 }
485 contract Ownable is Context {
486     address private _owner;
487 
488     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
489 
490     /**
491      * @dev Initializes the contract setting the deployer as the initial owner.
492      */
493     constructor () internal {
494         address msgSender = _msgSender();
495         _owner = msgSender;
496         emit OwnershipTransferred(address(0), msgSender);
497     }
498 
499     /**
500      * @dev Returns the address of the current owner.
501      */
502     function owner() public view returns (address) {
503         return _owner;
504     }
505 
506     /**
507      * @dev Throws if called by any account other than the owner.
508      */
509     modifier onlyOwner() {
510         require(_owner == _msgSender(), "Ownable: caller is not the owner");
511         _;
512     }
513 
514     /**
515      * @dev Leaves the contract without owner. It will not be possible to call
516      * `onlyOwner` functions anymore. Can only be called by the current owner.
517      *
518      * NOTE: Renouncing ownership will leave the contract without an owner,
519      * thereby removing any functionality that is only available to the owner.
520      */
521     function renounceOwnership() public virtual onlyOwner {
522         emit OwnershipTransferred(_owner, address(0));
523         _owner = address(0);
524     }
525 
526     /**
527      * @dev Transfers ownership of the contract to a new account (`newOwner`).
528      * Can only be called by the current owner.
529      */
530     function transferOwnership(address newOwner) public virtual onlyOwner {
531         require(newOwner != address(0), "Ownable: new owner is the zero address");
532         emit OwnershipTransferred(_owner, newOwner);
533         _owner = newOwner;
534     }
535 }
536 
537 interface IERC20Decimals {
538     function decimals() external view returns(uint256);
539 }
540 
541 contract ERC20 is Context, IERC20 {
542     using SafeMath for uint256;
543 
544     mapping (address => uint256) internal _balances;
545 
546     mapping (address => mapping (address => uint256)) internal _allowances;
547 
548     uint256 internal _totalSupply;
549 
550     string private _name;
551     string private _symbol;
552     uint8 private _decimals;
553 
554     /**
555      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
556      * a default value of 18.
557      *
558      * To select a different value for {decimals}, use {_setupDecimals}.
559      *
560      * All three of these values are immutable: they can only be set once during
561      * construction.
562      */
563     constructor (string memory name, string memory symbol) public {
564         _name = name;
565         _symbol = symbol;
566         _decimals = 18;
567     }
568 
569     /**
570      * @dev Returns the name of the token.
571      */
572     function name() public view returns (string memory) {
573         return _name;
574     }
575 
576     /**
577      * @dev Returns the symbol of the token, usually a shorter version of the
578      * name.
579      */
580     function symbol() public view returns (string memory) {
581         return _symbol;
582     }
583 
584     /**
585      * @dev Returns the number of decimals used to get its user representation.
586      * For example, if `decimals` equals `2`, a balance of `505` tokens should
587      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
588      *
589      * Tokens usually opt for a value of 18, imitating the relationship between
590      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
591      * called.
592      *
593      * NOTE: This information is only used for _display_ purposes: it in
594      * no way affects any of the arithmetic of the contract, including
595      * {IERC20-balanceOf} and {IERC20-transfer}.
596      */
597     function decimals() public view returns (uint8) {
598         return _decimals;
599     }
600 
601     /**
602      * @dev See {IERC20-totalSupply}.
603      */
604     function totalSupply() public view override returns (uint256) {
605         return _totalSupply;
606     }
607 
608     /**
609      * @dev See {IERC20-balanceOf}.
610      */
611     function balanceOf(address account) public view override returns (uint256) {
612         return _balances[account];
613     }
614 
615     /**
616      * @dev See {IERC20-transfer}.
617      *
618      * Requirements:
619      *
620      * - `recipient` cannot be the zero address.
621      * - the caller must have a balance of at least `amount`.
622      */
623     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
624         _transfer(_msgSender(), recipient, amount);
625         return true;
626     }
627 
628     /**
629      * @dev See {IERC20-allowance}.
630      */
631     function allowance(address owner, address spender) public view virtual override returns (uint256) {
632         return _allowances[owner][spender];
633     }
634 
635     /**
636      * @dev See {IERC20-approve}.
637      *
638      * Requirements:
639      *
640      * - `spender` cannot be the zero address.
641      */
642     function approve(address spender, uint256 amount) public virtual override returns (bool) {
643         _approve(_msgSender(), spender, amount);
644         return true;
645     }
646 
647     /**
648      * @dev See {IERC20-transferFrom}.
649      *
650      * Emits an {Approval} event indicating the updated allowance. This is not
651      * required by the EIP. See the note at the beginning of {ERC20}.
652      *
653      * Requirements:
654      *
655      * - `sender` and `recipient` cannot be the zero address.
656      * - `sender` must have a balance of at least `amount`.
657      * - the caller must have allowance for ``sender``'s tokens of at least
658      * `amount`.
659      */
660     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
661         _transfer(sender, recipient, amount);
662         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
663         return true;
664     }
665 
666     /**
667      * @dev Atomically increases the allowance granted to `spender` by the caller.
668      *
669      * This is an alternative to {approve} that can be used as a mitigation for
670      * problems described in {IERC20-approve}.
671      *
672      * Emits an {Approval} event indicating the updated allowance.
673      *
674      * Requirements:
675      *
676      * - `spender` cannot be the zero address.
677      */
678     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
679         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
680         return true;
681     }
682 
683     /**
684      * @dev Atomically decreases the allowance granted to `spender` by the caller.
685      *
686      * This is an alternative to {approve} that can be used as a mitigation for
687      * problems described in {IERC20-approve}.
688      *
689      * Emits an {Approval} event indicating the updated allowance.
690      *
691      * Requirements:
692      *
693      * - `spender` cannot be the zero address.
694      * - `spender` must have allowance for the caller of at least
695      * `subtractedValue`.
696      */
697     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
698         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
699         return true;
700     }
701 
702     /**
703      * @dev Moves tokens `amount` from `sender` to `recipient`.
704      *
705      * This is internal function is equivalent to {transfer}, and can be used to
706      * e.g. implement automatic token fees, slashing mechanisms, etc.
707      *
708      * Emits a {Transfer} event.
709      *
710      * Requirements:
711      *
712      * - `sender` cannot be the zero address.
713      * - `recipient` cannot be the zero address.
714      * - `sender` must have a balance of at least `amount`.
715      */
716     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
717         require(sender != address(0), "ERC20: transfer from the zero address");
718         require(recipient != address(0), "ERC20: transfer to the zero address");
719 
720         _beforeTokenTransfer(sender, recipient, amount);
721 
722         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
723         _balances[recipient] = _balances[recipient].add(amount);
724         emit Transfer(sender, recipient, amount);
725     }
726 
727     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
728      * the total supply.
729      *
730      * Emits a {Transfer} event with `from` set to the zero address.
731      *
732      * Requirements:
733      *
734      * - `to` cannot be the zero address.
735      */
736     function _mint(address account, uint256 amount) internal virtual {
737         require(account != address(0), "ERC20: mint to the zero address");
738 
739         _beforeTokenTransfer(address(0), account, amount);
740 
741         _totalSupply = _totalSupply.add(amount);
742         _balances[account] = _balances[account].add(amount);
743         emit Transfer(address(0), account, amount);
744     }
745 
746     /**
747      * @dev Destroys `amount` tokens from `account`, reducing the
748      * total supply.
749      *
750      * Emits a {Transfer} event with `to` set to the zero address.
751      *
752      * Requirements:
753      *
754      * - `account` cannot be the zero address.
755      * - `account` must have at least `amount` tokens.
756      */
757     function _burn(address account, uint256 amount) internal virtual {
758         require(account != address(0), "ERC20: burn from the zero address");
759 
760         _beforeTokenTransfer(account, address(0), amount);
761 
762         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
763         _totalSupply = _totalSupply.sub(amount);
764         emit Transfer(account, address(0), amount);
765     }
766 
767     /**
768      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
769      *
770      * This internal function is equivalent to `approve`, and can be used to
771      * e.g. set automatic allowances for certain subsystems, etc.
772      *
773      * Emits an {Approval} event.
774      *
775      * Requirements:
776      *
777      * - `owner` cannot be the zero address.
778      * - `spender` cannot be the zero address.
779      */
780     function _approve(address owner, address spender, uint256 amount) internal virtual {
781         require(owner != address(0), "ERC20: approve from the zero address");
782         require(spender != address(0), "ERC20: approve to the zero address");
783 
784         _allowances[owner][spender] = amount;
785         emit Approval(owner, spender, amount);
786     }
787 
788     /**
789      * @dev Sets {decimals} to a value other than the default one of 18.
790      *
791      * WARNING: This function should only be called from the constructor. Most
792      * applications that interact with token contracts will not expect
793      * {decimals} to ever change, and may work incorrectly if it does.
794      */
795     function _setupDecimals(uint8 decimals_) internal {
796         _decimals = decimals_;
797     }
798 
799     /**
800      * @dev Hook that is called before any transfer of tokens. This includes
801      * minting and burning.
802      *
803      * Calling conditions:
804      *
805      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
806      * will be to transferred to `to`.
807      * - when `from` is zero, `amount` tokens will be minted for `to`.
808      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
809      * - `from` and `to` are never both zero.
810      *
811      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
812      */
813     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
814 }
815 
816 
817 
818 contract BlueWhale is ERC20, Ownable {
819     using SafeERC20 for IERC20;
820     using SafeMath for uint256;
821     uint256 constant private BASE = 1e8;
822 
823     uint256 constant private DAY1 = 1 days;
824     struct UserInfo {
825         uint256 amount;
826         uint256 pending; 
827         uint256 rewardDebt; 
828         
829     }
830 
831     // Info of each pool.
832     struct PoolInfo {
833         IERC20 lpToken; 
834         uint256 allocPoint;
835         uint256 totalamount; 
836         uint256 lastRewardBlock; 
837         uint256 accBLWPerShare; 
838     }
839 
840     struct AccountNodeInfo {
841         uint256 initAmount;
842         uint256 lockedAmount; 
843         uint256 lastUnlockTs; 
844         uint256 rewardPending;
845         uint256 rewardDebt;
846     }
847 
848     struct NodeInfo {
849         uint256 allocPoint;
850         uint256 totalamount; 
851         uint256 lastRewardBlock; 
852         uint256 accBLWPerShare; 
853     }
854 
855     struct Fund {
856         uint256 initFund;
857         uint256 Locked;
858         uint256 lastReleaseTs;
859     }
860 
861     bool public init;
862     PoolInfo[] public poolInfo;
863     NodeInfo public nodeinfo;
864     uint256 poolstart = 1606060800;
865     uint256 public totalAllocPoint = 0;
866     uint256 public teamRewardPerDay;
867     uint256 public lastTeamReleaseTs;
868     mapping(address => uint256) public Locked; 
869     uint256 public nodeRequireAmount; 
870     uint256 public nodeStartReleaseTs; 
871     uint256 public nodeReleaseDays;
872     mapping(uint256 => mapping(address => UserInfo)) public userInfo; 
873     mapping(address => AccountNodeInfo) public accountNodeInfo; 
874     mapping(address => bool) public accountNodestatus;
875     uint256 public startBlock; 
876     uint256 public BLWPerBlock; 
877     mapping(address => Fund) public funds; 
878     address public fundToken; 
879     address public TeamHolder;
880     uint256 private fundStartTs;
881     uint256 private fundFinishTs;
882     uint256 private fundStartReleaseTs; 
883     uint256 private maxFund;
884     uint256 private maxFundPerAccount;
885     uint256 public currentLockedFund; 
886     uint256 private fundReleaseDays; 
887     uint256 private fundPrice;
888     // uint256  private ts1023 = 1602518400;
889     // uint256  private ts1025 = 1603382400  ;
890     event LockFund(address user, uint256 amount);
891     event UnlockFund(address user, uint256 amount);
892     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
893     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
894     event NodeSet(uint256 oldallocPoint, uint256 newallocPoint);
895     event Set(uint256 pid, uint256 allocPoint, bool withUpdate);
896     event Lock(address user, uint256 amount);
897     event unLock(address user, uint256 amount);
898     event UnlockNodeBalance(address user, uint256 amount);
899     event BatchUpdatePools();
900     event ReclaimStakingReward(address user, uint256 amount);
901 
902     function getpool() view public returns(PoolInfo[] memory){
903         return poolInfo;
904     }
905     //池子pid有效性检查
906     modifier validatePool(uint256 _pid) {
907         require(_pid < poolInfo.length, 'not good pid');
908         _;
909     }
910     constructor(address _fundToken, address teamHolder, uint256 teamReleaseTime, uint256 _nodeLockTime, uint256 _BLWPerBlock, uint256 _startBlock) ERC20("BlueWhale", "BLW") public {
911         BLWPerBlock = _BLWPerBlock;
912         TeamHolder = teamHolder;
913         startBlock = _startBlock;
914         _mint(address(this), 41340000 * BASE); //total supply 41340000
915         _transferlock(teamHolder,4134000* BASE); //10%
916         _setupDecimals(8);
917         _setupFundParams(_fundToken); 
918         _setupTeamParams(4134000* BASE, teamReleaseTime);
919         _setupNodeParams(_nodeLockTime);
920 
921     }
922     
923     function _setupTeamParams(uint256 lockAmount, uint256 startTime) internal {
924         teamRewardPerDay = lockAmount / 365 / 4;
925         lastTeamReleaseTs = startTime;
926     }
927     
928     function _setupFundParams(address _fundToken) internal {
929         maxFund = 2000000 * BASE;
930         maxFundPerAccount = 500 * BASE;
931         IERC20Decimals erc20 = IERC20Decimals(_fundToken);
932         fundToken = _fundToken;
933         fundPrice = 17000 * 1e4 * (10 ** (erc20.decimals())) / BASE; // 1e8 based
934         fundStartTs = 1602518400;
935         fundFinishTs = 1603468800;
936         fundStartReleaseTs = 1605801600;
937         fundReleaseDays = 90;
938     }
939 
940     function _setupNodeParams(uint256 _nodeLockTime) internal {
941         nodeinfo.lastRewardBlock = block.number > startBlock ? block.number : startBlock;
942         nodeRequireAmount = 5000 * BASE; 
943         nodeStartReleaseTs = _nodeLockTime + 90 days; //node release time
944         nodeReleaseDays = 90; //node release cycle
945     }
946 
947     function setNodeInfo(uint256 _allocPoint, bool _withUpdate) public onlyOwner {
948         if (_withUpdate) {
949             batchUpdatePools();
950         }
951         totalAllocPoint = totalAllocPoint.sub(nodeinfo.allocPoint).add(_allocPoint);
952         emit NodeSet(nodeinfo.allocPoint, _allocPoint);
953         nodeinfo.allocPoint = _allocPoint;
954 
955     }
956 
957     function updateFundParams(uint256 _fundStartAt, uint256 _fundFinishAt, uint256 _fundStartReleaseTs,
958         uint256 _maxFund, uint256 _maxFundPerAccount, uint256 _fundPrice, uint32 _fundReleaseDays) public onlyOwner {
959         fundStartTs = _fundStartAt;
960         fundFinishTs = _fundFinishAt;
961         fundStartReleaseTs = _fundStartReleaseTs;
962         maxFund = _maxFund;
963         maxFundPerAccount = _maxFundPerAccount;
964         fundPrice = _fundPrice;
965         fundReleaseDays = _fundReleaseDays;
966     }
967     function getFundParams() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
968         return (fundStartTs, fundFinishTs, fundStartReleaseTs, maxFund,
969             maxFundPerAccount, currentLockedFund, fundReleaseDays, fundPrice, poolstart);
970     }
971     function _teamTransfer(address sender, address recipient, uint256 amount) internal {
972         uint256 _amount = balanceOf(sender).sub(Locked[sender]);
973         require(_amount >= amount);
974         if (accountNodestatus[recipient]) { 
975             updateNodeReward(); 
976             accountNodeInfo[recipient].rewardPending = accountNodeInfo[recipient].rewardPending.add(accountNodeInfo[recipient].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18).sub(accountNodeInfo[recipient].rewardDebt));              
977             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
978             _balances[recipient] = _balances[recipient].add(amount);
979             nodeinfo.totalamount = nodeinfo.totalamount.add(amount);
980             accountNodeInfo[recipient].initAmount = accountNodeInfo[recipient].initAmount.add(amount);
981             accountNodeInfo[recipient].rewardDebt = accountNodeInfo[recipient].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
982         }else{ 
983             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
984             _balances[recipient] = _balances[recipient].add(amount);
985         }
986     }
987     function _fromNodeTransfer(address sender, address recipient, uint256 amount) internal {
988         updateNodeReward();
989         uint256 _amount = balanceOf(sender).sub(accountNodeInfo[sender].lockedAmount); 
990         require(_amount >= amount);
991         if (accountNodestatus[recipient]){
992             accountNodeInfo[sender].rewardPending = accountNodeInfo[sender].rewardPending.add(accountNodeInfo[sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18).sub(accountNodeInfo[sender].rewardDebt));
993             accountNodeInfo[recipient].rewardPending = accountNodeInfo[recipient].rewardPending.add(accountNodeInfo[recipient].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18).sub(accountNodeInfo[recipient].rewardDebt));              
994             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
995             _balances[recipient] = _balances[recipient].add(amount);
996             accountNodeInfo[recipient].initAmount = accountNodeInfo[recipient].initAmount.add(amount);
997             accountNodeInfo[recipient].rewardDebt = accountNodeInfo[recipient].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
998             accountNodeInfo[sender].initAmount = accountNodeInfo[sender].initAmount.sub(amount);
999             accountNodeInfo[sender].rewardDebt = accountNodeInfo[sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
1000             if (accountNodeInfo[sender].initAmount < 5000 * BASE) {
1001                 accountNodestatus[sender] = false;
1002                 nodeinfo.totalamount = nodeinfo.totalamount.sub(accountNodeInfo[sender].initAmount);
1003                 accountNodeInfo[sender].initAmount = 0;
1004                 accountNodeInfo[sender].rewardDebt = accountNodeInfo[sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
1005             }
1006         }else{
1007             accountNodeInfo[sender].rewardPending = accountNodeInfo[sender].rewardPending.add(accountNodeInfo[sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18).sub(accountNodeInfo[sender].rewardDebt));
1008             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1009             _balances[recipient] = _balances[recipient].add(amount);
1010             nodeinfo.totalamount = nodeinfo.totalamount.sub(amount);
1011             accountNodeInfo[sender].initAmount = accountNodeInfo[sender].initAmount.sub(amount);
1012             accountNodeInfo[sender].rewardDebt = accountNodeInfo[sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
1013             if (accountNodeInfo[sender].initAmount < 5000 * BASE) {
1014                 accountNodestatus[sender] = false;
1015                 nodeinfo.totalamount = nodeinfo.totalamount.sub(accountNodeInfo[sender].initAmount);
1016                 accountNodeInfo[sender].initAmount = 0;
1017                 accountNodeInfo[sender].rewardDebt = accountNodeInfo[sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
1018             }
1019         }
1020     }
1021     function _toNodeTransfer(address sender, address recipient, uint256 amount) internal {
1022             updateNodeReward();
1023             accountNodeInfo[recipient].rewardPending = accountNodeInfo[recipient].rewardPending.add(accountNodeInfo[recipient].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18).sub(accountNodeInfo[recipient].rewardDebt));             
1024             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1025             _balances[recipient] = _balances[recipient].add(amount);
1026             nodeinfo.totalamount = nodeinfo.totalamount.add(amount);
1027             accountNodeInfo[recipient].initAmount = accountNodeInfo[recipient].initAmount.add(amount);
1028             accountNodeInfo[recipient].rewardDebt = accountNodeInfo[recipient].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
1029     }
1030 
1031     function _transfer(address sender, address recipient, uint256 amount) internal virtual override{
1032         require(sender != address(0), "ERC20: transfer from the zero address");
1033         require(recipient != address(0), "ERC20: transfer to the zero address");
1034         if (sender == TeamHolder) { 
1035             _teamTransfer(sender, recipient, amount);
1036             emit Transfer(sender, recipient, amount);
1037             return; 
1038         }
1039         if (accountNodestatus[sender]) {
1040             _fromNodeTransfer(sender, recipient, amount);
1041             emit Transfer(sender, recipient, amount);
1042             return;
1043 
1044         }
1045         if (accountNodestatus[recipient]) { 
1046             _toNodeTransfer(sender, recipient, amount);
1047             emit Transfer(sender, recipient, amount);
1048             return;
1049         }
1050      
1051         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1052         _balances[recipient] = _balances[recipient].add(amount);
1053 
1054         emit Transfer(sender, recipient, amount);
1055         
1056     }
1057 
1058     function _transferlock(address _TeamHolder, uint256 amount) internal {
1059         _transfer(address(this), _TeamHolder, amount); // 
1060         Locked[_TeamHolder] = amount;
1061         emit Lock(_TeamHolder, amount);
1062     }
1063 
1064     function unlockTeam() public onlyOwner {
1065         _unlockTeam();
1066     }
1067 
1068     function _unlockTeam() internal {
1069         uint256 _amount = getAvailableTeamReward();
1070         Locked[TeamHolder] = Locked[TeamHolder].sub(_amount);
1071         lastTeamReleaseTs = block.timestamp;
1072         emit unLock(TeamHolder, _amount);
1073     }
1074 
1075     function getAvailableTeamReward() public view returns (uint256)  {
1076         if(block.timestamp <= lastTeamReleaseTs) {
1077             return 0;
1078         }
1079 
1080         uint256 _days = (block.timestamp - lastTeamReleaseTs) / 1 days;
1081         if(_days > 0) {
1082             uint256 _releaseByDay = _days * teamRewardPerDay;
1083             return Locked[TeamHolder] > _releaseByDay ? _releaseByDay : Locked[TeamHolder];
1084         }
1085         return 0;
1086     }
1087 
1088     //add node
1089     function addNodeAdmin(address account) public {
1090         require(msg.sender == TeamHolder, "Team only");
1091         require(account != address(this));
1092         require(account != TeamHolder);
1093         require(!accountNodestatus[account]);
1094         require(accountNodeInfo[account].lockedAmount == 0, "There are unreleased tokens");
1095         safeBLWTransfer(account, nodeRequireAmount);
1096         accountNodestatus[account] = true;
1097         accountNodeInfo[account].initAmount = balanceOf(account);
1098         accountNodeInfo[account].lockedAmount = nodeRequireAmount;
1099         accountNodeInfo[account].lastUnlockTs = block.timestamp > nodeStartReleaseTs ? block.timestamp : nodeStartReleaseTs;
1100         accountNodeInfo[account].rewardPending = 0;
1101         accountNodeInfo[account].rewardDebt = accountNodeInfo[account].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
1102         nodeinfo.totalamount = nodeinfo.totalamount.add(balanceOf(account));
1103 
1104     }
1105 
1106     function unlockNodeAmount() public {
1107         require(block.timestamp >= nodeStartReleaseTs, "");
1108         uint256 _amount = getAvailableNodeAmount(msg.sender);
1109         require(_amount > 0, "no available fund");
1110         accountNodeInfo[msg.sender].lockedAmount = accountNodeInfo[msg.sender].lockedAmount.sub(_amount);
1111         accountNodeInfo[msg.sender].lastUnlockTs = block.timestamp;
1112 
1113         emit UnlockNodeBalance(msg.sender, _amount);
1114     }
1115 
1116     function getAvailableNodeAmount(address account) public view returns (uint256) {
1117         if(accountNodeInfo[account].lockedAmount == 0) {
1118             return 0;
1119         }
1120 
1121         if(block.timestamp <= nodeStartReleaseTs || block.timestamp <= accountNodeInfo[account].lastUnlockTs) {
1122             return 0;
1123         }
1124 
1125         uint256 _last_ts = nodeStartReleaseTs > accountNodeInfo[account].lastUnlockTs ? nodeStartReleaseTs : accountNodeInfo[account].lastUnlockTs;
1126         uint256 _days = (block.timestamp - _last_ts) / DAY1;
1127 
1128         if(_days > 0) {
1129             uint256 _releaseByDay = nodeRequireAmount.mul(_days).div(nodeReleaseDays);
1130             return accountNodeInfo[account].lockedAmount > _releaseByDay ? _releaseByDay : accountNodeInfo[account].lockedAmount;
1131         }
1132         return 0;
1133     }
1134 
1135     //update node reward
1136     function updateNodeReward() internal {
1137         if (block.number <= nodeinfo.lastRewardBlock) {
1138             return;
1139         }
1140         if (nodeinfo.totalamount == 0) {
1141             nodeinfo.lastRewardBlock = block.number;
1142             return;
1143         }
1144 
1145         uint256 multiplier = getMultiplier(nodeinfo.lastRewardBlock, block.number);
1146         uint256 BLWReward = multiplier
1147             .mul(BLWPerBlock)
1148             .mul(nodeinfo.allocPoint)
1149             .div(totalAllocPoint);
1150         
1151         
1152         nodeinfo.accBLWPerShare = nodeinfo.accBLWPerShare.add(BLWReward.mul(1e18).div(nodeinfo.totalamount));
1153 
1154         nodeinfo.lastRewardBlock = block.number;  
1155     }
1156     // query node reward
1157     function getNodeReward() public view returns(uint256) {
1158         uint256 accBLWPerShare = nodeinfo.accBLWPerShare;
1159         uint256 lpSupply = nodeinfo.totalamount;
1160         if (block.number > nodeinfo.lastRewardBlock && lpSupply != 0) {
1161             uint256 multiplier = getMultiplier(
1162                 nodeinfo.lastRewardBlock,
1163                 block.number
1164             );
1165             uint256 BLWReward = multiplier
1166                 .mul(BLWPerBlock)
1167                 .mul(nodeinfo.allocPoint)
1168                 .div(totalAllocPoint);
1169             accBLWPerShare = accBLWPerShare.add(
1170                 BLWReward.mul(1e18).div(lpSupply)
1171             );
1172         }
1173 
1174         uint256 Pending = accountNodeInfo[msg.sender].rewardPending.add(accountNodeInfo[msg.sender].initAmount.mul(accBLWPerShare).div(1e18).sub(accountNodeInfo[msg.sender].rewardDebt));
1175         return Pending;
1176     }
1177 
1178     //withdraw node reward
1179     function takeNodeReward() public {
1180         updateNodeReward();
1181         uint256 Pending = accountNodeInfo[msg.sender].rewardPending.add(accountNodeInfo[msg.sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18).sub(accountNodeInfo[msg.sender].rewardDebt));
1182         require(Pending > 0, "no reward");
1183         accountNodeInfo[msg.sender].rewardPending = 0;
1184         accountNodeInfo[msg.sender].rewardDebt = accountNodeInfo[msg.sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
1185         safeBLWTransfer(msg.sender, Pending);
1186     }
1187 
1188 
1189     function checkRepeatedPool(IERC20 _lpToken) internal view {
1190         uint256 length = poolInfo.length;
1191         for (uint256 pid = 0; pid < length; ++pid) {
1192             if (poolInfo[pid].lpToken == _lpToken) {
1193                 revert();
1194             }
1195         }
1196     }
1197 
1198     function poolLength() external view returns (uint256) {
1199         return poolInfo.length;
1200     }
1201     //add pool
1202     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1203         checkRepeatedPool(_lpToken);
1204 
1205         if (_withUpdate) {
1206             batchUpdatePools();
1207         }
1208         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1209         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1210         poolInfo.push(
1211             PoolInfo({
1212                 lpToken: _lpToken,
1213                 allocPoint: _allocPoint,
1214                 totalamount: 0,
1215                 lastRewardBlock: lastRewardBlock,
1216                 accBLWPerShare: 0
1217             })
1218         );
1219     }
1220 
1221 
1222     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner validatePool(_pid) {
1223         if (_withUpdate) {
1224             batchUpdatePools();
1225         }
1226         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1227         poolInfo[_pid].allocPoint = _allocPoint;
1228         emit Set(_pid, _allocPoint, _withUpdate);
1229     }
1230 
1231 
1232 
1233     function batchUpdatePools() public {
1234         uint256 length = poolInfo.length;
1235         for (uint256 pid = 0; pid < length; ++pid) {
1236             updatePool(pid);
1237         }
1238         emit BatchUpdatePools();
1239     }
1240     function getMultiplier(uint256 _from, uint256 _to) internal pure returns (uint256) {
1241         return _to.sub(_from);
1242     
1243     }
1244     function pendingBLW(uint256 _pid, address _user)external view validatePool(_pid) returns (uint256) {
1245         PoolInfo storage pool = poolInfo[_pid];
1246         UserInfo storage user = userInfo[_pid][_user];
1247         uint256 accBLWPerShare = pool.accBLWPerShare;
1248         uint256 lpSupply = pool.totalamount;
1249         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1250             uint256 multiplier = getMultiplier(
1251                 pool.lastRewardBlock,
1252                 block.number
1253             );
1254             uint256 BLWReward = multiplier
1255                 .mul(BLWPerBlock)
1256                 .mul(pool.allocPoint)
1257                 .div(totalAllocPoint);
1258             accBLWPerShare = accBLWPerShare.add(
1259                 BLWReward.mul(1e18).div(lpSupply)
1260             );
1261         }
1262         return user.pending.add(user.amount.mul(accBLWPerShare).div(1e18)).sub(user.rewardDebt);
1263     }
1264 
1265     function updatePool(uint256 _pid) public validatePool(_pid) {
1266         PoolInfo storage pool = poolInfo[_pid];
1267         if (block.number <= pool.lastRewardBlock) {
1268             return;
1269         }
1270         uint256 lpSupply = pool.totalamount;
1271         if (lpSupply == 0) {
1272             pool.lastRewardBlock = block.number;
1273             return;
1274         }
1275         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1276         uint256 BLWReward = multiplier
1277             .mul(BLWPerBlock)
1278             .mul(pool.allocPoint)
1279             .div(totalAllocPoint);
1280 
1281         pool.accBLWPerShare = pool.accBLWPerShare.add(
1282             BLWReward.mul(1e18).div(lpSupply)
1283         );
1284       
1285         pool.lastRewardBlock = block.number;
1286 
1287     }
1288     //deposit
1289     function deposit(uint256 _pid, uint256 _amount) public validatePool(_pid) payable {
1290         if (_pid == 0 || _pid == 1) {
1291             require(block.timestamp >= poolstart, "pool no start");
1292         }
1293         PoolInfo storage pool = poolInfo[_pid];
1294         UserInfo storage user = userInfo[_pid][msg.sender];
1295         updatePool(_pid);
1296         if (user.amount > 0) {
1297             uint256 pending = user.amount.mul(pool.accBLWPerShare).div(1e18).sub(user.rewardDebt);
1298             user.pending = user.pending.add(pending);
1299         }
1300         if (address(pool.lpToken) == address(0)) {
1301             _amount = msg.value;
1302         } else {
1303             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1304         }
1305         pool.totalamount = pool.totalamount.add(_amount);
1306         user.amount = user.amount.add(_amount);
1307         user.rewardDebt = user.amount.mul(pool.accBLWPerShare).div(1e18);
1308         emit Deposit(msg.sender, _pid, _amount);
1309     }
1310 
1311     function withdraw(uint256 _pid, uint256 _amount) public validatePool(_pid){
1312         PoolInfo storage pool = poolInfo[_pid];
1313         UserInfo storage user = userInfo[_pid][msg.sender];
1314         if (funds[msg.sender].Locked > 0 && _pid == 2){
1315             _unlockFund();
1316             require(user.amount.sub(funds[msg.sender].Locked) >= _amount);
1317         }
1318         require(user.amount >= _amount, "withdraw: not good");
1319         updatePool(_pid);
1320         pool.totalamount = pool.totalamount.sub(_amount);
1321         uint256 pending = user.amount.mul(pool.accBLWPerShare).div(1e18).sub(user.rewardDebt);
1322         user.pending = user.pending.add(pending);
1323         user.amount = user.amount.sub(_amount);
1324         user.rewardDebt = user.amount.mul(pool.accBLWPerShare).div(1e18);
1325         if (address(pool.lpToken) == address(0)) {
1326             msg.sender.transfer(_amount);
1327         } else {
1328             pool.lpToken.safeTransfer(msg.sender, _amount);
1329         }
1330         emit Withdraw(msg.sender, _pid, _amount);
1331     }
1332 
1333     function reclaimStakingReward(uint256 _pid) public validatePool(_pid) {
1334         PoolInfo storage pool = poolInfo[_pid];
1335         UserInfo storage user = userInfo[_pid][msg.sender];
1336         updatePool(_pid);
1337         uint256 pending = user.pending.add(user.amount.mul(pool.accBLWPerShare).div(1e18).sub(user.rewardDebt));
1338         if (pending > 0) {
1339             safeBLWTransfer(msg.sender, pending);
1340         }
1341         user.pending = 0;
1342         user.rewardDebt = user.amount.mul(pool.accBLWPerShare).div(1e18);
1343         emit ReclaimStakingReward(msg.sender, pending);
1344     }
1345 
1346     function safeBLWTransfer(address _to, uint256 _amount) internal {
1347         PoolInfo storage pool = poolInfo[2];
1348         uint256 BLWBal = balanceOf(address(this)).sub(pool.totalamount);
1349         if (_amount > BLWBal) {
1350             _transfer(address(this),_to, BLWBal);
1351         } else {
1352             _transfer(address(this), _to, _amount);
1353         }
1354     }
1355 
1356     function lockFund(uint256 amount) public {
1357         require(block.timestamp >= fundStartTs, "wait");
1358         require(block.timestamp <= fundFinishTs, "it is over");
1359         currentLockedFund = currentLockedFund.add(amount);
1360         require(currentLockedFund <= maxFund, "fund end");
1361 
1362         uint256 _fundTokenAmount = getRequireFundToken(amount);
1363         require(_fundTokenAmount > 0, "amount error");
1364 
1365         uint256 _newAmount = funds[msg.sender].initFund.add(amount);
1366         require(_newAmount <= maxFundPerAccount, "reach max limit");
1367 
1368         funds[msg.sender].initFund = funds[msg.sender].initFund.add(amount);
1369         funds[msg.sender].Locked = funds[msg.sender].Locked.add(amount);
1370         funds[msg.sender].lastReleaseTs = block.timestamp > fundStartReleaseTs ? block.timestamp : fundStartReleaseTs;
1371 
1372         IERC20 erc20 = IERC20(fundToken); 
1373         erc20.safeTransferFrom(msg.sender, address(this), _fundTokenAmount);
1374         erc20.safeTransfer(TeamHolder, _fundTokenAmount);
1375         PoolInfo storage pool = poolInfo[2];
1376         UserInfo storage user = userInfo[2][msg.sender];
1377         updatePool(2);
1378         if (user.amount > 0) {
1379             uint256 pending = user.amount.mul(pool.accBLWPerShare).div(1e18).sub(user.rewardDebt);
1380             safeBLWTransfer(msg.sender, pending);
1381         }
1382         pool.totalamount = pool.totalamount.add(amount);
1383         user.amount = user.amount.add(amount);
1384         user.rewardDebt = user.amount.mul(pool.accBLWPerShare).div(1e18);
1385         emit Deposit(msg.sender, 2, amount);
1386         emit LockFund(msg.sender, amount);
1387     }
1388 
1389     function getRequireFundToken(uint256 amount) public view returns (uint256) {
1390         return amount.mul(fundPrice).div(BASE);
1391     }
1392 
1393     function unlockFund() public {
1394         uint256 _amount = getAvailableFund(msg.sender);
1395         withdraw(2,_amount);
1396     }
1397 
1398     function _unlockFund() internal {
1399         require(block.timestamp >= fundStartReleaseTs, "wait start");
1400         uint256 _amount = getAvailableFund(msg.sender);
1401         require(_amount > 0);
1402         currentLockedFund = currentLockedFund.sub(_amount); 
1403         funds[msg.sender].Locked = funds[msg.sender].Locked.sub(_amount);
1404         funds[msg.sender].lastReleaseTs = block.timestamp; 
1405     }
1406 
1407     function getAvailableFund(address account) public view returns (uint256) {
1408         if(funds[account].initFund == 0) {
1409             return 0;
1410         }
1411         if(block.timestamp <= fundStartReleaseTs || block.timestamp < funds[account].lastReleaseTs) {
1412             return 0;
1413         }
1414 
1415         uint256 _days = (block.timestamp - funds[account].lastReleaseTs) / DAY1;
1416 
1417         if(_days > 0) {
1418             uint256 _releaseByDay = funds[account].initFund.mul(_days).div(fundReleaseDays);
1419             return funds[account].Locked > _releaseByDay ? _releaseByDay : funds[account].Locked;
1420         }
1421         return 0;
1422     }
1423 
1424     receive() external payable {
1425 
1426     }
1427 
1428     function setinit() public onlyOwner {
1429         init = true;
1430     }
1431 
1432     //import historical data
1433     function batchlockFund(address[] memory _to, uint256[] memory _value) onlyOwner public {
1434         require(!init);
1435         require(_to.length > 0);
1436         require(_to.length == _value.length);
1437         uint256 sum = 0;
1438         address account;
1439         uint256 amount;  
1440         for(uint256 i = 0; i < _to.length; i++){
1441             amount = _value[i];
1442             account = _to[i];
1443             sum = sum.add(amount);    
1444             funds[account].initFund = amount;
1445             funds[account].Locked = amount;
1446             funds[account].lastReleaseTs = fundStartReleaseTs;        
1447             UserInfo storage user = userInfo[2][account];
1448             user.amount = user.amount.add(amount);
1449             emit Deposit(account, 2, amount);
1450             emit LockFund(account, amount);
1451         }
1452         currentLockedFund = currentLockedFund.add(sum);
1453         require(currentLockedFund <= maxFund, "fund end");
1454         PoolInfo storage pool = poolInfo[2];
1455         pool.totalamount = pool.totalamount.add(sum);
1456     }
1457 
1458 }