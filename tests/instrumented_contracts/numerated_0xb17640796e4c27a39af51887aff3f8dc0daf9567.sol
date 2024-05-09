1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.5.17;
4 
5 
6 
7 // Part: IController
8 
9 interface IController {
10     function withdraw(address, uint256) external;
11 
12     function balanceOf(address) external view returns (uint256);
13 
14     function earn(address, uint256) external;
15 
16     function want(address) external view returns (address);
17 
18     function rewards() external view returns (address);
19 
20     function vaults(address) external view returns (address);
21 
22     function strategies(address) external view returns (address);
23 }
24 
25 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/Address
26 
27 /**
28  * @dev Collection of functions related to the address type
29  */
30 library Address {
31     /**
32      * @dev Returns true if `account` is a contract.
33      *
34      * [IMPORTANT]
35      * ====
36      * It is unsafe to assume that an address for which this function returns
37      * false is an externally-owned account (EOA) and not a contract.
38      *
39      * Among others, `isContract` will return false for the following 
40      * types of addresses:
41      *
42      *  - an externally-owned account
43      *  - a contract in construction
44      *  - an address where a contract will be created
45      *  - an address where a contract lived, but was destroyed
46      * ====
47      */
48     function isContract(address account) internal view returns (bool) {
49         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
50         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
51         // for accounts without code, i.e. `keccak256('')`
52         bytes32 codehash;
53         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
54         // solhint-disable-next-line no-inline-assembly
55         assembly { codehash := extcodehash(account) }
56         return (codehash != accountHash && codehash != 0x0);
57     }
58 
59     /**
60      * @dev Converts an `address` into `address payable`. Note that this is
61      * simply a type cast: the actual underlying value is not changed.
62      *
63      * _Available since v2.4.0._
64      */
65     function toPayable(address account) internal pure returns (address payable) {
66         return address(uint160(account));
67     }
68 
69     /**
70      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
71      * `recipient`, forwarding all available gas and reverting on errors.
72      *
73      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
74      * of certain opcodes, possibly making contracts go over the 2300 gas limit
75      * imposed by `transfer`, making them unable to receive funds via
76      * `transfer`. {sendValue} removes this limitation.
77      *
78      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
79      *
80      * IMPORTANT: because control is transferred to `recipient`, care must be
81      * taken to not create reentrancy vulnerabilities. Consider using
82      * {ReentrancyGuard} or the
83      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
84      *
85      * _Available since v2.4.0._
86      */
87     function sendValue(address payable recipient, uint256 amount) internal {
88         require(address(this).balance >= amount, "Address: insufficient balance");
89 
90         // solhint-disable-next-line avoid-call-value
91         (bool success, ) = recipient.call.value(amount)("");
92         require(success, "Address: unable to send value, recipient may have reverted");
93     }
94 }
95 
96 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/Context
97 
98 /*
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with GSN meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 contract Context {
109     // Empty internal constructor, to prevent people from mistakenly deploying
110     // an instance of this contract, which should be used via inheritance.
111     constructor () internal { }
112     // solhint-disable-previous-line no-empty-blocks
113 
114     function _msgSender() internal view returns (address payable) {
115         return msg.sender;
116     }
117 
118     function _msgData() internal view returns (bytes memory) {
119         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
120         return msg.data;
121     }
122 }
123 
124 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/IERC20
125 
126 /**
127  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
128  * the optional functions; to access them see {ERC20Detailed}.
129  */
130 interface IERC20 {
131     /**
132      * @dev Returns the amount of tokens in existence.
133      */
134     function totalSupply() external view returns (uint256);
135 
136     /**
137      * @dev Returns the amount of tokens owned by `account`.
138      */
139     function balanceOf(address account) external view returns (uint256);
140 
141     /**
142      * @dev Moves `amount` tokens from the caller's account to `recipient`.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transfer(address recipient, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Returns the remaining number of tokens that `spender` will be
152      * allowed to spend on behalf of `owner` through {transferFrom}. This is
153      * zero by default.
154      *
155      * This value changes when {approve} or {transferFrom} are called.
156      */
157     function allowance(address owner, address spender) external view returns (uint256);
158 
159     /**
160      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * IMPORTANT: Beware that changing an allowance with this method brings the risk
165      * that someone may use both the old and the new allowance by unfortunate
166      * transaction ordering. One possible solution to mitigate this race
167      * condition is to first reduce the spender's allowance to 0 and set the
168      * desired value afterwards:
169      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170      *
171      * Emits an {Approval} event.
172      */
173     function approve(address spender, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Moves `amount` tokens from `sender` to `recipient` using the
177      * allowance mechanism. `amount` is then deducted from the caller's
178      * allowance.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Emitted when `value` tokens are moved from one account (`from`) to
188      * another (`to`).
189      *
190      * Note that `value` may be zero.
191      */
192     event Transfer(address indexed from, address indexed to, uint256 value);
193 
194     /**
195      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
196      * a call to {approve}. `value` is the new allowance.
197      */
198     event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/SafeMath
202 
203 /**
204  * @dev Wrappers over Solidity's arithmetic operations with added overflow
205  * checks.
206  *
207  * Arithmetic operations in Solidity wrap on overflow. This can easily result
208  * in bugs, because programmers usually assume that an overflow raises an
209  * error, which is the standard behavior in high level programming languages.
210  * `SafeMath` restores this intuition by reverting the transaction when an
211  * operation overflows.
212  *
213  * Using this library instead of the unchecked operations eliminates an entire
214  * class of bugs, so it's recommended to use it always.
215  */
216 library SafeMath {
217     /**
218      * @dev Returns the addition of two unsigned integers, reverting on
219      * overflow.
220      *
221      * Counterpart to Solidity's `+` operator.
222      *
223      * Requirements:
224      * - Addition cannot overflow.
225      */
226     function add(uint256 a, uint256 b) internal pure returns (uint256) {
227         uint256 c = a + b;
228         require(c >= a, "SafeMath: addition overflow");
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the subtraction of two unsigned integers, reverting on
235      * overflow (when the result is negative).
236      *
237      * Counterpart to Solidity's `-` operator.
238      *
239      * Requirements:
240      * - Subtraction cannot overflow.
241      */
242     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
243         return sub(a, b, "SafeMath: subtraction overflow");
244     }
245 
246     /**
247      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
248      * overflow (when the result is negative).
249      *
250      * Counterpart to Solidity's `-` operator.
251      *
252      * Requirements:
253      * - Subtraction cannot overflow.
254      *
255      * _Available since v2.4.0._
256      */
257     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b <= a, errorMessage);
259         uint256 c = a - b;
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the multiplication of two unsigned integers, reverting on
266      * overflow.
267      *
268      * Counterpart to Solidity's `*` operator.
269      *
270      * Requirements:
271      * - Multiplication cannot overflow.
272      */
273     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
274         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
275         // benefit is lost if 'b' is also tested.
276         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
277         if (a == 0) {
278             return 0;
279         }
280 
281         uint256 c = a * b;
282         require(c / a == b, "SafeMath: multiplication overflow");
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers. Reverts on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b) internal pure returns (uint256) {
299         return div(a, b, "SafeMath: division by zero");
300     }
301 
302     /**
303      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
304      * division by zero. The result is rounded towards zero.
305      *
306      * Counterpart to Solidity's `/` operator. Note: this function uses a
307      * `revert` opcode (which leaves remaining gas untouched) while Solidity
308      * uses an invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      * - The divisor cannot be zero.
312      *
313      * _Available since v2.4.0._
314      */
315     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         // Solidity only automatically asserts when dividing by 0
317         require(b > 0, errorMessage);
318         uint256 c = a / b;
319         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
320 
321         return c;
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * Reverts when dividing by zero.
327      *
328      * Counterpart to Solidity's `%` operator. This function uses a `revert`
329      * opcode (which leaves remaining gas untouched) while Solidity uses an
330      * invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      * - The divisor cannot be zero.
334      */
335     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
336         return mod(a, b, "SafeMath: modulo by zero");
337     }
338 
339     /**
340      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
341      * Reverts with custom message when dividing by zero.
342      *
343      * Counterpart to Solidity's `%` operator. This function uses a `revert`
344      * opcode (which leaves remaining gas untouched) while Solidity uses an
345      * invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      * - The divisor cannot be zero.
349      *
350      * _Available since v2.4.0._
351      */
352     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
353         require(b != 0, errorMessage);
354         return a % b;
355     }
356 }
357 
358 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/ERC20
359 
360 /**
361  * @dev Implementation of the {IERC20} interface.
362  *
363  * This implementation is agnostic to the way tokens are created. This means
364  * that a supply mechanism has to be added in a derived contract using {_mint}.
365  * For a generic mechanism see {ERC20Mintable}.
366  *
367  * TIP: For a detailed writeup see our guide
368  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
369  * to implement supply mechanisms].
370  *
371  * We have followed general OpenZeppelin guidelines: functions revert instead
372  * of returning `false` on failure. This behavior is nonetheless conventional
373  * and does not conflict with the expectations of ERC20 applications.
374  *
375  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
376  * This allows applications to reconstruct the allowance for all accounts just
377  * by listening to said events. Other implementations of the EIP may not emit
378  * these events, as it isn't required by the specification.
379  *
380  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
381  * functions have been added to mitigate the well-known issues around setting
382  * allowances. See {IERC20-approve}.
383  */
384 contract ERC20 is Context, IERC20 {
385     using SafeMath for uint256;
386 
387     mapping (address => uint256) private _balances;
388 
389     mapping (address => mapping (address => uint256)) private _allowances;
390 
391     uint256 private _totalSupply;
392 
393     /**
394      * @dev See {IERC20-totalSupply}.
395      */
396     function totalSupply() public view returns (uint256) {
397         return _totalSupply;
398     }
399 
400     /**
401      * @dev See {IERC20-balanceOf}.
402      */
403     function balanceOf(address account) public view returns (uint256) {
404         return _balances[account];
405     }
406 
407     /**
408      * @dev See {IERC20-transfer}.
409      *
410      * Requirements:
411      *
412      * - `recipient` cannot be the zero address.
413      * - the caller must have a balance of at least `amount`.
414      */
415     function transfer(address recipient, uint256 amount) public returns (bool) {
416         _transfer(_msgSender(), recipient, amount);
417         return true;
418     }
419 
420     /**
421      * @dev See {IERC20-allowance}.
422      */
423     function allowance(address owner, address spender) public view returns (uint256) {
424         return _allowances[owner][spender];
425     }
426 
427     /**
428      * @dev See {IERC20-approve}.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      */
434     function approve(address spender, uint256 amount) public returns (bool) {
435         _approve(_msgSender(), spender, amount);
436         return true;
437     }
438 
439     /**
440      * @dev See {IERC20-transferFrom}.
441      *
442      * Emits an {Approval} event indicating the updated allowance. This is not
443      * required by the EIP. See the note at the beginning of {ERC20};
444      *
445      * Requirements:
446      * - `sender` and `recipient` cannot be the zero address.
447      * - `sender` must have a balance of at least `amount`.
448      * - the caller must have allowance for `sender`'s tokens of at least
449      * `amount`.
450      */
451     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
452         _transfer(sender, recipient, amount);
453         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
454         return true;
455     }
456 
457     /**
458      * @dev Atomically increases the allowance granted to `spender` by the caller.
459      *
460      * This is an alternative to {approve} that can be used as a mitigation for
461      * problems described in {IERC20-approve}.
462      *
463      * Emits an {Approval} event indicating the updated allowance.
464      *
465      * Requirements:
466      *
467      * - `spender` cannot be the zero address.
468      */
469     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
470         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
471         return true;
472     }
473 
474     /**
475      * @dev Atomically decreases the allowance granted to `spender` by the caller.
476      *
477      * This is an alternative to {approve} that can be used as a mitigation for
478      * problems described in {IERC20-approve}.
479      *
480      * Emits an {Approval} event indicating the updated allowance.
481      *
482      * Requirements:
483      *
484      * - `spender` cannot be the zero address.
485      * - `spender` must have allowance for the caller of at least
486      * `subtractedValue`.
487      */
488     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
489         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
490         return true;
491     }
492 
493     /**
494      * @dev Moves tokens `amount` from `sender` to `recipient`.
495      *
496      * This is internal function is equivalent to {transfer}, and can be used to
497      * e.g. implement automatic token fees, slashing mechanisms, etc.
498      *
499      * Emits a {Transfer} event.
500      *
501      * Requirements:
502      *
503      * - `sender` cannot be the zero address.
504      * - `recipient` cannot be the zero address.
505      * - `sender` must have a balance of at least `amount`.
506      */
507     function _transfer(address sender, address recipient, uint256 amount) internal {
508         require(sender != address(0), "ERC20: transfer from the zero address");
509         require(recipient != address(0), "ERC20: transfer to the zero address");
510 
511         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
512         _balances[recipient] = _balances[recipient].add(amount);
513         emit Transfer(sender, recipient, amount);
514     }
515 
516     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
517      * the total supply.
518      *
519      * Emits a {Transfer} event with `from` set to the zero address.
520      *
521      * Requirements
522      *
523      * - `to` cannot be the zero address.
524      */
525     function _mint(address account, uint256 amount) internal {
526         require(account != address(0), "ERC20: mint to the zero address");
527 
528         _totalSupply = _totalSupply.add(amount);
529         _balances[account] = _balances[account].add(amount);
530         emit Transfer(address(0), account, amount);
531     }
532 
533     /**
534      * @dev Destroys `amount` tokens from `account`, reducing the
535      * total supply.
536      *
537      * Emits a {Transfer} event with `to` set to the zero address.
538      *
539      * Requirements
540      *
541      * - `account` cannot be the zero address.
542      * - `account` must have at least `amount` tokens.
543      */
544     function _burn(address account, uint256 amount) internal {
545         require(account != address(0), "ERC20: burn from the zero address");
546 
547         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
548         _totalSupply = _totalSupply.sub(amount);
549         emit Transfer(account, address(0), amount);
550     }
551 
552     /**
553      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
554      *
555      * This is internal function is equivalent to `approve`, and can be used to
556      * e.g. set automatic allowances for certain subsystems, etc.
557      *
558      * Emits an {Approval} event.
559      *
560      * Requirements:
561      *
562      * - `owner` cannot be the zero address.
563      * - `spender` cannot be the zero address.
564      */
565     function _approve(address owner, address spender, uint256 amount) internal {
566         require(owner != address(0), "ERC20: approve from the zero address");
567         require(spender != address(0), "ERC20: approve to the zero address");
568 
569         _allowances[owner][spender] = amount;
570         emit Approval(owner, spender, amount);
571     }
572 
573     /**
574      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
575      * from the caller's allowance.
576      *
577      * See {_burn} and {_approve}.
578      */
579     function _burnFrom(address account, uint256 amount) internal {
580         _burn(account, amount);
581         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
582     }
583 }
584 
585 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/ERC20Detailed
586 
587 /**
588  * @dev Optional functions from the ERC20 standard.
589  */
590 contract ERC20Detailed is IERC20 {
591     string private _name;
592     string private _symbol;
593     uint8 private _decimals;
594 
595     /**
596      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
597      * these values are immutable: they can only be set once during
598      * construction.
599      */
600     constructor (string memory name, string memory symbol, uint8 decimals) public {
601         _name = name;
602         _symbol = symbol;
603         _decimals = decimals;
604     }
605 
606     /**
607      * @dev Returns the name of the token.
608      */
609     function name() public view returns (string memory) {
610         return _name;
611     }
612 
613     /**
614      * @dev Returns the symbol of the token, usually a shorter version of the
615      * name.
616      */
617     function symbol() public view returns (string memory) {
618         return _symbol;
619     }
620 
621     /**
622      * @dev Returns the number of decimals used to get its user representation.
623      * For example, if `decimals` equals `2`, a balance of `505` tokens should
624      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
625      *
626      * Tokens usually opt for a value of 18, imitating the relationship between
627      * Ether and Wei.
628      *
629      * NOTE: This information is only used for _display_ purposes: it in
630      * no way affects any of the arithmetic of the contract, including
631      * {IERC20-balanceOf} and {IERC20-transfer}.
632      */
633     function decimals() public view returns (uint8) {
634         return _decimals;
635     }
636 }
637 
638 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/SafeERC20
639 
640 /**
641  * @title SafeERC20
642  * @dev Wrappers around ERC20 operations that throw on failure (when the token
643  * contract returns false). Tokens that return no value (and instead revert or
644  * throw on failure) are also supported, non-reverting calls are assumed to be
645  * successful.
646  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
647  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
648  */
649 library SafeERC20 {
650     using SafeMath for uint256;
651     using Address for address;
652 
653     function safeTransfer(IERC20 token, address to, uint256 value) internal {
654         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
655     }
656 
657     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
658         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
659     }
660 
661     function safeApprove(IERC20 token, address spender, uint256 value) internal {
662         // safeApprove should only be called when setting an initial allowance,
663         // or when resetting it to zero. To increase and decrease it, use
664         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
665         // solhint-disable-next-line max-line-length
666         require((value == 0) || (token.allowance(address(this), spender) == 0),
667             "SafeERC20: approve from non-zero to non-zero allowance"
668         );
669         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
670     }
671 
672     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
673         uint256 newAllowance = token.allowance(address(this), spender).add(value);
674         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
675     }
676 
677     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
678         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
679         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
680     }
681 
682     /**
683      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
684      * on the return value: the return value is optional (but if data is returned, it must not be false).
685      * @param token The token targeted by the call.
686      * @param data The call data (encoded using abi.encode or one of its variants).
687      */
688     function callOptionalReturn(IERC20 token, bytes memory data) private {
689         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
690         // we're implementing it ourselves.
691 
692         // A Solidity high level call has three parts:
693         //  1. The target address is checked to verify it contains contract code
694         //  2. The call itself is made, and success asserted
695         //  3. The return value is decoded, which in turn checks the size of the returned data.
696         // solhint-disable-next-line max-line-length
697         require(address(token).isContract(), "SafeERC20: call to non-contract");
698 
699         // solhint-disable-next-line avoid-low-level-calls
700         (bool success, bytes memory returndata) = address(token).call(data);
701         require(success, "SafeERC20: low-level call failed");
702 
703         if (returndata.length > 0) { // Return data is optional
704             // solhint-disable-next-line max-line-length
705             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
706         }
707     }
708 }
709 
710 // File: yVault.sol
711 
712 contract yVault is ERC20, ERC20Detailed {
713     using SafeERC20 for IERC20;
714     using Address for address;
715     using SafeMath for uint256;
716 
717     IERC20 public token;
718 
719     uint256 public min = 9500;
720     uint256 public constant max = 10000;
721 
722     address public governance;
723     address public controller;
724 
725     constructor(address _token, address _controller)
726         public
727         ERC20Detailed(
728             string(
729                 abi.encodePacked("stake dao ", ERC20Detailed(_token).name())
730             ),
731             string(abi.encodePacked("sd", ERC20Detailed(_token).symbol())),
732             ERC20Detailed(_token).decimals()
733         )
734     {
735         token = IERC20(_token);
736         governance = msg.sender;
737         controller = _controller;
738     }
739 
740     function balance() public view returns (uint256) {
741         return
742             token.balanceOf(address(this)).add(
743                 IController(controller).balanceOf(address(token))
744             );
745     }
746 
747     function setMin(uint256 _min) external {
748         require(msg.sender == governance, "!governance");
749         min = _min;
750     }
751 
752     function setGovernance(address _governance) public {
753         require(msg.sender == governance, "!governance");
754         governance = _governance;
755     }
756 
757     function setController(address _controller) public {
758         require(msg.sender == governance, "!governance");
759         controller = _controller;
760     }
761 
762     // Custom logic in here for how much the vault allows to be borrowed
763     // Sets minimum required on-hand to keep small withdrawals cheap
764     function available() public view returns (uint256) {
765         return token.balanceOf(address(this)).mul(min).div(max);
766     }
767 
768     function earn() public {
769         uint256 _bal = available();
770         token.safeTransfer(controller, _bal);
771         IController(controller).earn(address(token), _bal);
772     }
773 
774     function depositAll() external {
775         deposit(token.balanceOf(msg.sender));
776     }
777 
778     function deposit(uint256 _amount) public {
779         uint256 _pool = balance();
780         uint256 _before = token.balanceOf(address(this));
781         token.safeTransferFrom(msg.sender, address(this), _amount);
782         uint256 _after = token.balanceOf(address(this));
783         _amount = _after.sub(_before); // Additional check for deflationary tokens
784         uint256 shares = 0;
785         if (totalSupply() == 0) {
786             shares = _amount;
787         } else {
788             shares = (_amount.mul(totalSupply())).div(_pool);
789         }
790         _mint(msg.sender, shares);
791     }
792 
793     function withdrawAll() external {
794         withdraw(balanceOf(msg.sender));
795     }
796 
797     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
798     function harvest(address reserve, uint256 amount) external {
799         require(msg.sender == controller, "!controller");
800         require(reserve != address(token), "token");
801         IERC20(reserve).safeTransfer(controller, amount);
802     }
803 
804     // No rebalance implementation for lower fees and faster swaps
805     function withdraw(uint256 _shares) public {
806         uint256 r = (balance().mul(_shares)).div(totalSupply());
807         _burn(msg.sender, _shares);
808 
809         // Check balance
810         uint256 b = token.balanceOf(address(this));
811         if (b < r) {
812             uint256 _withdraw = r.sub(b);
813             IController(controller).withdraw(address(token), _withdraw);
814             uint256 _after = token.balanceOf(address(this));
815             uint256 _diff = _after.sub(b);
816             if (_diff < _withdraw) {
817                 r = b.add(_diff);
818             }
819         }
820 
821         token.safeTransfer(msg.sender, r);
822     }
823 
824     function getPricePerFullShare() public view returns (uint256) {
825         return balance().mul(1e18).div(totalSupply());
826     }
827 }
