1 pragma solidity ^0.5.16;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
6  * the optional functions; to access them see {ERC20Detailed}.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      * - Subtraction cannot overflow.
130      *
131      * _Available since v2.4.0._
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      *
189      * _Available since v2.4.0._
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         // Solidity only automatically asserts when dividing by 0
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts with custom message when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      *
226      * _Available since v2.4.0._
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following 
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
257         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
258         // for accounts without code, i.e. `keccak256('')`
259         bytes32 codehash;
260         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
261         // solhint-disable-next-line no-inline-assembly
262         assembly { codehash := extcodehash(account) }
263         return (codehash != accountHash && codehash != 0x0);
264     }
265 
266     /**
267      * @dev Converts an `address` into `address payable`. Note that this is
268      * simply a type cast: the actual underlying value is not changed.
269      *
270      * _Available since v2.4.0._
271      */
272     function toPayable(address account) internal pure returns (address payable) {
273         return address(uint160(account));
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      *
292      * _Available since v2.4.0._
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-call-value
298         (bool success, ) = recipient.call.value(amount)("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 }
302 
303 /**
304  * @title SafeERC20
305  * @dev Wrappers around ERC20 operations that throw on failure (when the token
306  * contract returns false). Tokens that return no value (and instead revert or
307  * throw on failure) are also supported, non-reverting calls are assumed to be
308  * successful.
309  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
310  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
311  */
312 library SafeERC20 {
313     using SafeMath for uint256;
314     using Address for address;
315 
316     function safeTransfer(IERC20 token, address to, uint256 value) internal {
317         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
318     }
319 
320     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
321         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
322     }
323 
324     function safeApprove(IERC20 token, address spender, uint256 value) internal {
325         // safeApprove should only be called when setting an initial allowance,
326         // or when resetting it to zero. To increase and decrease it, use
327         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
328         // solhint-disable-next-line max-line-length
329         require((value == 0) || (token.allowance(address(this), spender) == 0),
330             "SafeERC20: approve from non-zero to non-zero allowance"
331         );
332         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
333     }
334 
335     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
336         uint256 newAllowance = token.allowance(address(this), spender).add(value);
337         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
338     }
339 
340     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
341         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
342         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
343     }
344 
345     /**
346      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
347      * on the return value: the return value is optional (but if data is returned, it must not be false).
348      * @param token The token targeted by the call.
349      * @param data The call data (encoded using abi.encode or one of its variants).
350      */
351     function callOptionalReturn(IERC20 token, bytes memory data) private {
352         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
353         // we're implementing it ourselves.
354 
355         // A Solidity high level call has three parts:
356         //  1. The target address is checked to verify it contains contract code
357         //  2. The call itself is made, and success asserted
358         //  3. The return value is decoded, which in turn checks the size of the returned data.
359         // solhint-disable-next-line max-line-length
360         require(address(token).isContract(), "SafeERC20: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = address(token).call(data);
364         require(success, "SafeERC20: low-level call failed");
365 
366         if (returndata.length > 0) { // Return data is optional
367             // solhint-disable-next-line max-line-length
368             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
369         }
370     }
371 }
372 
373 /*
374  * @dev Provides information about the current execution context, including the
375  * sender of the transaction and its data. While these are generally available
376  * via msg.sender and msg.data, they should not be accessed in such a direct
377  * manner, since when dealing with GSN meta-transactions the account sending and
378  * paying for execution may not be the actual sender (as far as an application
379  * is concerned).
380  *
381  * This contract is only required for intermediate, library-like contracts.
382  */
383 contract Context {
384     // Empty internal constructor, to prevent people from mistakenly deploying
385     // an instance of this contract, which should be used via inheritance.
386     constructor () internal { }
387     // solhint-disable-previous-line no-empty-blocks
388 
389     function _msgSender() internal view returns (address payable) {
390         return msg.sender;
391     }
392 
393     function _msgData() internal view returns (bytes memory) {
394         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
395         return msg.data;
396     }
397 }
398 
399 /**
400  * @dev Contract module which provides a basic access control mechanism, where
401  * there is an account (an owner) that can be granted exclusive access to
402  * specific functions.
403  *
404  * This module is used through inheritance. It will make available the modifier
405  * `onlyOwner`, which can be applied to your functions to restrict their use to
406  * the owner.
407  */
408 contract Ownable is Context {
409     address private _owner;
410 
411     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
412 
413     /**
414      * @dev Initializes the contract setting the deployer as the initial owner.
415      */
416     constructor () internal {
417         address msgSender = _msgSender();
418         _owner = msgSender;
419         emit OwnershipTransferred(address(0), msgSender);
420     }
421 
422     /**
423      * @dev Returns the address of the current owner.
424      */
425     function owner() public view returns (address) {
426         return _owner;
427     }
428 
429     /**
430      * @dev Throws if called by any account other than the owner.
431      */
432     modifier onlyOwner() {
433         require(isOwner(), "Ownable: caller is not the owner");
434         _;
435     }
436 
437     /**
438      * @dev Returns true if the caller is the current owner.
439      */
440     function isOwner() public view returns (bool) {
441         return _msgSender() == _owner;
442     }
443 
444     /**
445      * @dev Leaves the contract without owner. It will not be possible to call
446      * `onlyOwner` functions anymore. Can only be called by the current owner.
447      *
448      * NOTE: Renouncing ownership will leave the contract without an owner,
449      * thereby removing any functionality that is only available to the owner.
450      */
451     function renounceOwnership() public onlyOwner {
452         emit OwnershipTransferred(_owner, address(0));
453         _owner = address(0);
454     }
455 
456     /**
457      * @dev Transfers ownership of the contract to a new account (`newOwner`).
458      * Can only be called by the current owner.
459      */
460     function transferOwnership(address newOwner) public onlyOwner {
461         _transferOwnership(newOwner);
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      */
467     function _transferOwnership(address newOwner) internal {
468         require(newOwner != address(0), "Ownable: new owner is the zero address");
469         emit OwnershipTransferred(_owner, newOwner);
470         _owner = newOwner;
471     }
472 }
473 
474 /**
475  * @dev Implementation of the {IERC20} interface.
476  *
477  * This implementation is agnostic to the way tokens are created. This means
478  * that a supply mechanism has to be added in a derived contract using {_mint}.
479  * For a generic mechanism see {ERC20Mintable}.
480  *
481  * TIP: For a detailed writeup see our guide
482  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
483  * to implement supply mechanisms].
484  *
485  * We have followed general OpenZeppelin guidelines: functions revert instead
486  * of returning `false` on failure. This behavior is nonetheless conventional
487  * and does not conflict with the expectations of ERC20 applications.
488  *
489  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
490  * This allows applications to reconstruct the allowance for all accounts just
491  * by listening to said events. Other implementations of the EIP may not emit
492  * these events, as it isn't required by the specification.
493  *
494  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
495  * functions have been added to mitigate the well-known issues around setting
496  * allowances. See {IERC20-approve}.
497  */
498 contract ERC20 is Context, IERC20 {
499     using SafeMath for uint256;
500 
501     mapping (address => uint256) private _balances;
502 
503     mapping (address => mapping (address => uint256)) private _allowances;
504 
505     uint256 private _totalSupply;
506 
507     /**
508      * @dev See {IERC20-totalSupply}.
509      */
510     function totalSupply() public view returns (uint256) {
511         return _totalSupply;
512     }
513 
514     /**
515      * @dev See {IERC20-balanceOf}.
516      */
517     function balanceOf(address account) public view returns (uint256) {
518         return _balances[account];
519     }
520 
521     /**
522      * @dev See {IERC20-transfer}.
523      *
524      * Requirements:
525      *
526      * - `recipient` cannot be the zero address.
527      * - the caller must have a balance of at least `amount`.
528      */
529     function transfer(address recipient, uint256 amount) public returns (bool) {
530         _transfer(_msgSender(), recipient, amount);
531         return true;
532     }
533 
534     /**
535      * @dev See {IERC20-allowance}.
536      */
537     function allowance(address owner, address spender) public view returns (uint256) {
538         return _allowances[owner][spender];
539     }
540 
541     /**
542      * @dev See {IERC20-approve}.
543      *
544      * Requirements:
545      *
546      * - `spender` cannot be the zero address.
547      */
548     function approve(address spender, uint256 amount) public returns (bool) {
549         _approve(_msgSender(), spender, amount);
550         return true;
551     }
552 
553     /**
554      * @dev See {IERC20-transferFrom}.
555      *
556      * Emits an {Approval} event indicating the updated allowance. This is not
557      * required by the EIP. See the note at the beginning of {ERC20};
558      *
559      * Requirements:
560      * - `sender` and `recipient` cannot be the zero address.
561      * - `sender` must have a balance of at least `amount`.
562      * - the caller must have allowance for `sender`'s tokens of at least
563      * `amount`.
564      */
565     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
566         _transfer(sender, recipient, amount);
567         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
568         return true;
569     }
570 
571     /**
572      * @dev Atomically increases the allowance granted to `spender` by the caller.
573      *
574      * This is an alternative to {approve} that can be used as a mitigation for
575      * problems described in {IERC20-approve}.
576      *
577      * Emits an {Approval} event indicating the updated allowance.
578      *
579      * Requirements:
580      *
581      * - `spender` cannot be the zero address.
582      */
583     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
584         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
585         return true;
586     }
587 
588     /**
589      * @dev Atomically decreases the allowance granted to `spender` by the caller.
590      *
591      * This is an alternative to {approve} that can be used as a mitigation for
592      * problems described in {IERC20-approve}.
593      *
594      * Emits an {Approval} event indicating the updated allowance.
595      *
596      * Requirements:
597      *
598      * - `spender` cannot be the zero address.
599      * - `spender` must have allowance for the caller of at least
600      * `subtractedValue`.
601      */
602     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
603         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
604         return true;
605     }
606 
607     /**
608      * @dev Moves tokens `amount` from `sender` to `recipient`.
609      *
610      * This is internal function is equivalent to {transfer}, and can be used to
611      * e.g. implement automatic token fees, slashing mechanisms, etc.
612      *
613      * Emits a {Transfer} event.
614      *
615      * Requirements:
616      *
617      * - `sender` cannot be the zero address.
618      * - `recipient` cannot be the zero address.
619      * - `sender` must have a balance of at least `amount`.
620      */
621     function _transfer(address sender, address recipient, uint256 amount) internal {
622         require(sender != address(0), "ERC20: transfer from the zero address");
623         require(recipient != address(0), "ERC20: transfer to the zero address");
624 
625         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
626         _balances[recipient] = _balances[recipient].add(amount);
627         emit Transfer(sender, recipient, amount);
628     }
629 
630     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
631      * the total supply.
632      *
633      * Emits a {Transfer} event with `from` set to the zero address.
634      *
635      * Requirements
636      *
637      * - `to` cannot be the zero address.
638      */
639     function _mint(address account, uint256 amount) internal {
640         require(account != address(0), "ERC20: mint to the zero address");
641 
642         _totalSupply = _totalSupply.add(amount);
643         _balances[account] = _balances[account].add(amount);
644         emit Transfer(address(0), account, amount);
645     }
646 
647     /**
648      * @dev Destroys `amount` tokens from `account`, reducing the
649      * total supply.
650      *
651      * Emits a {Transfer} event with `to` set to the zero address.
652      *
653      * Requirements
654      *
655      * - `account` cannot be the zero address.
656      * - `account` must have at least `amount` tokens.
657      */
658     function _burn(address account, uint256 amount) internal {
659         require(account != address(0), "ERC20: burn from the zero address");
660 
661         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
662         _totalSupply = _totalSupply.sub(amount);
663         emit Transfer(account, address(0), amount);
664     }
665 
666     /**
667      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
668      *
669      * This is internal function is equivalent to `approve`, and can be used to
670      * e.g. set automatic allowances for certain subsystems, etc.
671      *
672      * Emits an {Approval} event.
673      *
674      * Requirements:
675      *
676      * - `owner` cannot be the zero address.
677      * - `spender` cannot be the zero address.
678      */
679     function _approve(address owner, address spender, uint256 amount) internal {
680         require(owner != address(0), "ERC20: approve from the zero address");
681         require(spender != address(0), "ERC20: approve to the zero address");
682 
683         _allowances[owner][spender] = amount;
684         emit Approval(owner, spender, amount);
685     }
686 
687     /**
688      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
689      * from the caller's allowance.
690      *
691      * See {_burn} and {_approve}.
692      */
693     function _burnFrom(address account, uint256 amount) internal {
694         _burn(account, amount);
695         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
696     }
697 }
698 
699 /**
700  * @dev Optional functions from the ERC20 standard.
701  */
702 contract ERC20Detailed is IERC20 {
703     string private _name;
704     string private _symbol;
705     uint8 private _decimals;
706 
707     /**
708      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
709      * these values are immutable: they can only be set once during
710      * construction.
711      */
712     constructor (string memory name, string memory symbol, uint8 decimals) public {
713         _name = name;
714         _symbol = symbol;
715         _decimals = decimals;
716     }
717 
718     /**
719      * @dev Returns the name of the token.
720      */
721     function name() public view returns (string memory) {
722         return _name;
723     }
724 
725     /**
726      * @dev Returns the symbol of the token, usually a shorter version of the
727      * name.
728      */
729     function symbol() public view returns (string memory) {
730         return _symbol;
731     }
732 
733     /**
734      * @dev Returns the number of decimals used to get its user representation.
735      * For example, if `decimals` equals `2`, a balance of `505` tokens should
736      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
737      *
738      * Tokens usually opt for a value of 18, imitating the relationship between
739      * Ether and Wei.
740      *
741      * NOTE: This information is only used for _display_ purposes: it in
742      * no way affects any of the arithmetic of the contract, including
743      * {IERC20-balanceOf} and {IERC20-transfer}.
744      */
745     function decimals() public view returns (uint8) {
746         return _decimals;
747     }
748 }
749 
750 /**
751  * @dev Contract module which provides a Governance access control mechanism, where
752  * there is an account (a Governor) that can be granted exclusive access to
753  * specific functions.
754  *
755  * Unlike with Ownable, governance can not be renounced.
756  *
757  * This module is used through inheritance. It will make available the modifier
758  * `onlyGovernance`, which can be applied to your functions to restrict their use to
759  * the Governance.
760  */
761 contract Governable is Context {
762 
763     address private _governance;
764 
765     event GovernanceTransferred(address indexed previousGovernance, address indexed newGovernance);
766 
767     /**
768      * @dev Initializes the contract setting the deployer as the initial Governance.
769      */
770     constructor () internal {
771         address msgSender = _msgSender();
772         _governance = msgSender;
773         emit GovernanceTransferred(address(0), msgSender);
774     }
775 
776     /**
777      * @dev Returns the address of the current owner.
778      */
779     function governance() public view returns (address) {
780         return _governance;
781     }
782 
783     /**
784      * @dev Throws if called by any account other than the owner.
785      */
786     modifier onlyGovernance() {
787         require(isGovernance(), "Governable: caller is not the governance");
788         _;
789     }
790 
791     /**
792      * @dev Returns true if the caller is the current owner.
793      */
794     function isGovernance() public view returns (bool) {
795         return _msgSender() == _governance;
796     }
797 
798 
799     /**
800      * @dev Transfers governance of the contract to a new account (`newGovernance`).
801      * Can only be called by the current governance.
802      */
803     function setGovernance(address newGovernance) public onlyGovernance {
804         _transferGovernance(newGovernance);
805     }
806 
807     /**
808      * @dev Transfers governance of the contract to a new account (`newGovernance`).
809      */
810     function _transferGovernance(address newGovernance) internal {
811         require(newGovernance != address(0), "Governable: new governance is the zero address");
812         emit GovernanceTransferred(_governance, newGovernance);
813         _governance = newGovernance;
814     }
815 }
816 
817 contract EDDA is ERC20, ERC20Detailed, Governable {
818     constructor () public ERC20Detailed("Yggdrasil", "EDDA", 18) {
819         // Mint total supply to Governance during contract creation.
820         // _mint is internal funciton of Openzeppelin ERC20 contract used to create all supply.
821         // After contract creation, there is no way to call _mint() function on deployed contract.
822         _mint(governance(), uint256(5000 * 10 ** uint256(decimals())));
823     }
824 }
825 
826 contract IReleaser {
827     function release() external;
828 
829     function isReleaser() external pure returns (bool) {
830         return true;
831     }
832 }
833 
834 contract TokenSplitter is IReleaser, Ownable {
835     using SafeMath for uint256;
836     using SafeERC20 for IERC20;
837 
838     event PayeeAdded(address account, uint256 shares);
839     event PaymentReleased(address to, uint256 amount);
840 
841     IERC20 public token;
842 
843     address[] public payees;
844     mapping(address => uint256) public shares;
845     mapping(address => bool) public releasers;
846 
847     uint256 private _totalShares;
848 
849     constructor (IERC20 token_, address[] memory payees_, uint256[] memory shares_, bool[] memory releasers_) public {
850         require(address(token_) != address(0), "TokenSplitter: token is the zero address");
851         require(payees_.length == shares_.length, "TokenSplitter: payees and shares length mismatch");
852         require(payees_.length == releasers_.length, "TokenSplitter: payees and releasers length mismatch");
853         require(payees_.length > 0, "TokenSplitter: no payees");
854 
855         token = token_;
856         for (uint256 i = 0; i < payees_.length; i++) {
857             _addPayee(payees_[i], shares_[i], releasers_[i]);
858         }
859     }
860 
861     function payeesCount() public view returns (uint256) {
862         return payees.length;
863     }
864 
865     function totalShares() public view returns (uint256) {
866         return _totalShares;
867     }
868 
869     function release() external onlyOwner {
870         uint256 balance = token.balanceOf(address(this));
871         if (balance > 0) {
872             for (uint256 i = 0; i < payees.length; i++) {
873                 address account = payees[i];
874                 uint256 payment = balance.mul(shares[account]).div(_totalShares);
875                 if (payment > 0) {
876                     token.safeTransfer(account, payment);
877                     if (releasers[account]) {
878                         IReleaser(address(account)).release();
879                     }
880                     emit PaymentReleased(account, payment);
881                 }
882             }
883         }
884     }
885 
886     function _addPayee(address account_, uint256 shares_, bool releaser_) private {
887         require(account_ != address(0), "TokenSplitter: account is the zero address");
888         require(shares_ > 0, "TokenSplitter: shares are 0");
889         require(shares[account_] == 0, "TokenSplitter: account already has shares");
890         // if announced as releaser - should implement interface 
891         require(
892             !releaser_ || IReleaser(account_).isReleaser(), 
893             "TokenSplitter: account releaser status wrong"
894         );
895 
896         payees.push(account_);
897         shares[account_] = shares_;
898         releasers[account_] = releaser_;
899         _totalShares = _totalShares.add(shares_);
900         emit PayeeAdded(account_, shares_);
901     }
902 }
903 
904 // SPDX-License-Identifier: MIT
905 /**
906  * Yggdrasil.finance
907  * https://yggdrasil.finance
908  *
909  * Additional details for contract and wallet information:
910  * https://yggdrasil.finance/tracking/
911  */
912 contract EDDATokenSale is Ownable {
913     //Enable SafeMath
914     using SafeMath for uint256;
915     using SafeERC20 for IERC20;
916     using SafeERC20 for EDDA;
917 
918     uint8 public constant percentSale = 65; 
919     bool public initialized;
920 
921     uint256 public constant SCALAR = 1e18; // multiplier
922     uint256 public constant minBuyWei = 1e17; // in Wei
923 
924     address public tokenAcceptor;
925     address payable public ETHAcceptor;
926     uint256 public priceInWei;
927     uint256 public maxBuyTokens = 20; // in EDDA per address
928     uint256 public initialSupplyInWei;
929     
930     address[] buyers; // buyers
931     mapping(address => uint256) public purchases; // balances
932     uint256 public purchased; // spent
933     uint256 public distributionBatch = 1;
934     uint256 public transferredToTokenAcceptor;
935 
936     bool public saleEnabled = false;
937 
938     EDDA public tokenContract;
939     TokenSplitter public reserved;
940 
941     // Events
942     event Sell(address _buyer, uint256 _amount);
943     event Paid(address _from, uint256 _amount);
944     event Withdraw(address _to, uint256 _amount);
945 
946     // On deployment
947     constructor(
948         EDDA _tokenContract, 
949         uint256 _priceInWei,
950         address _tokenAcceptor, 
951         address payable _ETHAcceptor,
952         address _reserved
953     ) public {
954         tokenContract = _tokenContract;
955         tokenAcceptor = _tokenAcceptor;
956         priceInWei = _priceInWei;
957         ETHAcceptor = _ETHAcceptor;
958         reserved = TokenSplitter(_reserved);
959     }
960 
961     // Initialise
962     function init() external onlyOwner {
963         require(!initialized, "Could be initialized only once");
964         require(reserved.owner() == address(this), "Sale should be the owner of Reserved funds");
965 
966         uint256 _initialSupplyInWei = tokenContract.balanceOf(address(this));
967         require(
968             _initialSupplyInWei > 0, 
969             "Initial supply should be > 0"
970         );
971 
972         initialSupplyInWei = _initialSupplyInWei;
973         
974         uint256 _tokensToReserveInWei = _getInitialSupplyPercentInWei(100 - percentSale); 
975         initialized = true;
976         tokenContract.safeTransfer(address(reserved), _tokensToReserveInWei);
977     }
978   
979     /// @notice Any funds sent to this function will be unrecoverable
980     /// @dev This function receives funds, there is currently no way to send funds back
981     function () external payable {
982         emit Paid(msg.sender, msg.value);
983     }
984 
985     // Buy tokens with ETH
986     function buyTokens() external payable {
987         uint256 _ethSent = msg.value;
988         require(saleEnabled, "The EDDA Initial Token Offering is not yet started");
989         require(_ethSent >= minBuyWei, "Minimum purchase per transaction is 0.1 ETH");
990 
991         uint256 _tokens = _ethSent.mul(SCALAR).div(priceInWei);
992 
993         // Check that the purchase amount does not exceed remaining tokens
994         require(_tokens <= _remainingTokens(), "Not enough tokens remain");
995 
996         if (purchases[msg.sender] == 0) {
997             buyers.push(msg.sender);
998         }
999         purchases[msg.sender] = purchases[msg.sender].add(_tokens);
1000         require(purchases[msg.sender] <= maxBuyTokens.mul(SCALAR), "Exceeded maximum purchase limit per address");
1001 
1002         purchased = purchased.add(_tokens);
1003 
1004         emit Sell(msg.sender, _tokens);
1005     }
1006 
1007     // Enable the token sale
1008     function enableSale(bool _saleStatus) external onlyOwner {
1009         require(initialized, "Sale should be initialized");
1010         saleEnabled = _saleStatus;
1011     }
1012 
1013     // Update the current Token price in ETH
1014     function setPriceETH(uint256 _priceInWei) external onlyOwner {
1015         require(_priceInWei > 0, "Token price should be > 0");
1016         priceInWei = _priceInWei;
1017     }
1018 
1019     // Update the maximum buy in tokens
1020     function updateMaxBuyTokens(uint256 _maxBuyTokens) external onlyOwner {
1021         maxBuyTokens = _maxBuyTokens;
1022     }
1023 
1024     // Update the distribution batch size
1025     function updateDistributionBatch(uint256 _distributionBatch) external onlyOwner {
1026         distributionBatch = _distributionBatch;
1027     }
1028 
1029     // Distribute purchased tokens
1030     function distribute(uint256 _offset) external onlyOwner returns (uint256) {
1031         uint256 _distributed = 0;
1032         for (uint256 i = _offset; i < buyers.length; i++) {
1033             address _buyer = buyers[i];
1034             uint256 _purchase = purchases[_buyer];
1035             if (_purchase > 0) {
1036                 purchases[_buyer] = 0;
1037                 tokenContract.safeTransfer(_buyer, _purchase);
1038                 if (++_distributed >= distributionBatch) {
1039                     break;
1040                 }
1041             }            
1042         }
1043         return _distributed;
1044     }
1045 
1046     // Withdraw current ETH balance
1047     function withdraw() public onlyOwner {
1048         emit Withdraw(ETHAcceptor, address(this).balance);
1049         ETHAcceptor.transfer(address(this).balance);
1050     }
1051 
1052     // Get percent value of initial supply in wei
1053     function _getInitialSupplyPercentInWei(uint8 _percent) private view returns (uint256) {
1054         return initialSupplyInWei.mul(_percent).div(100); 
1055     }
1056 
1057     // Get tokens remaining on token sale balance
1058     function _remainingTokens() private view returns (uint256) {
1059         return _getInitialSupplyPercentInWei(percentSale)
1060             .sub(purchased)
1061             .sub(transferredToTokenAcceptor);
1062     }
1063 
1064     // End the token sale and transfer remaining ETH and tokens to the acceptors
1065     function endSale() external onlyOwner {
1066         uint256 remainingTokens = _remainingTokens();
1067         if (remainingTokens > 0) {
1068             transferredToTokenAcceptor = transferredToTokenAcceptor.add(remainingTokens);
1069             tokenContract.safeTransfer(tokenAcceptor, remainingTokens);
1070         }
1071         withdraw();
1072         reserved.release();
1073 
1074         saleEnabled = false;
1075     }
1076 }