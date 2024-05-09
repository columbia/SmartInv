1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-31
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/GSN/Context.sol
8 
9 pragma solidity ^0.5.17;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 contract Context {
22     // Empty internal constructor, to prevent people from mistakenly deploying
23     // an instance of this contract, which should be used via inheritance.
24     constructor () internal { }
25     // solhint-disable-previous-line no-empty-blocks
26 
27     function _msgSender() internal view returns (address payable) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view returns (bytes memory) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
38 
39 pragma solidity ^0.5.0;
40 
41 /**
42  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
43  * the optional functions; to access them see {ERC20Detailed}.
44  */
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 // File: @openzeppelin/contracts/math/SafeMath.sol
117 
118 pragma solidity ^0.5.0;
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations with added overflow
122  * checks.
123  *
124  * Arithmetic operations in Solidity wrap on overflow. This can easily result
125  * in bugs, because programmers usually assume that an overflow raises an
126  * error, which is the standard behavior in high level programming languages.
127  * `SafeMath` restores this intuition by reverting the transaction when an
128  * operation overflows.
129  *
130  * Using this library instead of the unchecked operations eliminates an entire
131  * class of bugs, so it's recommended to use it always.
132  */
133 library SafeMath {
134     /**
135      * @dev Returns the addition of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `+` operator.
139      *
140      * Requirements:
141      * - Addition cannot overflow.
142      */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      * - Subtraction cannot overflow.
171      *
172      * _Available since v2.4.0._
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         uint256 c = a - b;
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return div(a, b, "SafeMath: division by zero");
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      * - The divisor cannot be zero.
229      *
230      * _Available since v2.4.0._
231      */
232     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         // Solidity only automatically asserts when dividing by 0
234         require(b > 0, errorMessage);
235         uint256 c = a / b;
236         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253         return mod(a, b, "SafeMath: modulo by zero");
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * Reverts with custom message when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      * - The divisor cannot be zero.
266      *
267      * _Available since v2.4.0._
268      */
269     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b != 0, errorMessage);
271         return a % b;
272     }
273 }
274 
275 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
276 
277 pragma solidity ^0.5.0;
278 
279 
280 
281 
282 /**
283  * @dev Implementation of the {IERC20} interface.
284  *
285  * This implementation is agnostic to the way tokens are created. This means
286  * that a supply mechanism has to be added in a derived contract using {_mint}.
287  * For a generic mechanism see {ERC20Mintable}.
288  *
289  * TIP: For a detailed writeup see our guide
290  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
291  * to implement supply mechanisms].
292  *
293  * We have followed general OpenZeppelin guidelines: functions revert instead
294  * of returning `false` on failure. This behavior is nonetheless conventional
295  * and does not conflict with the expectations of ERC20 applications.
296  *
297  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
298  * This allows applications to reconstruct the allowance for all accounts just
299  * by listening to said events. Other implementations of the EIP may not emit
300  * these events, as it isn't required by the specification.
301  *
302  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
303  * functions have been added to mitigate the well-known issues around setting
304  * allowances. See {IERC20-approve}.
305  */
306 contract ERC20 is Context, IERC20 {
307     using SafeMath for uint256;
308 
309     mapping (address => uint256) private _balances;
310 
311     mapping (address => mapping (address => uint256)) private _allowances;
312 
313     uint256 private _totalSupply;
314 
315     /**
316      * @dev See {IERC20-totalSupply}.
317      */
318     function totalSupply() public view returns (uint256) {
319         return _totalSupply;
320     }
321 
322     /**
323      * @dev See {IERC20-balanceOf}.
324      */
325     function balanceOf(address account) public view returns (uint256) {
326         return _balances[account];
327     }
328 
329     /**
330      * @dev See {IERC20-transfer}.
331      *
332      * Requirements:
333      *
334      * - `recipient` cannot be the zero address.
335      * - the caller must have a balance of at least `amount`.
336      */
337     function transfer(address recipient, uint256 amount) public returns (bool) {
338         _transfer(_msgSender(), recipient, amount);
339         return true;
340     }
341 
342     /**
343      * @dev See {IERC20-allowance}.
344      */
345     function allowance(address owner, address spender) public view returns (uint256) {
346         return _allowances[owner][spender];
347     }
348 
349     /**
350      * @dev See {IERC20-approve}.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      */
356     function approve(address spender, uint256 amount) public returns (bool) {
357         _approve(_msgSender(), spender, amount);
358         return true;
359     }
360 
361     /**
362      * @dev See {IERC20-transferFrom}.
363      *
364      * Emits an {Approval} event indicating the updated allowance. This is not
365      * required by the EIP. See the note at the beginning of {ERC20};
366      *
367      * Requirements:
368      * - `sender` and `recipient` cannot be the zero address.
369      * - `sender` must have a balance of at least `amount`.
370      * - the caller must have allowance for `sender`'s tokens of at least
371      * `amount`.
372      */
373     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
374         _transfer(sender, recipient, amount);
375         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
376         return true;
377     }
378 
379     /**
380      * @dev Atomically increases the allowance granted to `spender` by the caller.
381      *
382      * This is an alternative to {approve} that can be used as a mitigation for
383      * problems described in {IERC20-approve}.
384      *
385      * Emits an {Approval} event indicating the updated allowance.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      */
391     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
392         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
393         return true;
394     }
395 
396     /**
397      * @dev Atomically decreases the allowance granted to `spender` by the caller.
398      *
399      * This is an alternative to {approve} that can be used as a mitigation for
400      * problems described in {IERC20-approve}.
401      *
402      * Emits an {Approval} event indicating the updated allowance.
403      *
404      * Requirements:
405      *
406      * - `spender` cannot be the zero address.
407      * - `spender` must have allowance for the caller of at least
408      * `subtractedValue`.
409      */
410     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
411         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
412         return true;
413     }
414 
415     /**
416      * @dev Moves tokens `amount` from `sender` to `recipient`.
417      *
418      * This is internal function is equivalent to {transfer}, and can be used to
419      * e.g. implement automatic token fees, slashing mechanisms, etc.
420      *
421      * Emits a {Transfer} event.
422      *
423      * Requirements:
424      *
425      * - `sender` cannot be the zero address.
426      * - `recipient` cannot be the zero address.
427      * - `sender` must have a balance of at least `amount`.
428      */
429     function _transfer(address sender, address recipient, uint256 amount) internal {
430         require(sender != address(0), "ERC20: transfer from the zero address");
431         require(recipient != address(0), "ERC20: transfer to the zero address");
432 
433         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
434         _balances[recipient] = _balances[recipient].add(amount);
435         emit Transfer(sender, recipient, amount);
436     }
437 
438     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
439      * the total supply.
440      *
441      * Emits a {Transfer} event with `from` set to the zero address.
442      *
443      * Requirements
444      *
445      * - `to` cannot be the zero address.
446      */
447     function _mint(address account, uint256 amount) internal {
448         require(account != address(0), "ERC20: mint to the zero address");
449 
450         _totalSupply = _totalSupply.add(amount);
451         _balances[account] = _balances[account].add(amount);
452         emit Transfer(address(0), account, amount);
453     }
454 
455     /**
456      * @dev Destroys `amount` tokens from `account`, reducing the
457      * total supply.
458      *
459      * Emits a {Transfer} event with `to` set to the zero address.
460      *
461      * Requirements
462      *
463      * - `account` cannot be the zero address.
464      * - `account` must have at least `amount` tokens.
465      */
466     function _burn(address account, uint256 amount) internal {
467         require(account != address(0), "ERC20: burn from the zero address");
468 
469         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
470         _totalSupply = _totalSupply.sub(amount);
471         emit Transfer(account, address(0), amount);
472     }
473 
474     /**
475      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
476      *
477      * This is internal function is equivalent to `approve`, and can be used to
478      * e.g. set automatic allowances for certain subsystems, etc.
479      *
480      * Emits an {Approval} event.
481      *
482      * Requirements:
483      *
484      * - `owner` cannot be the zero address.
485      * - `spender` cannot be the zero address.
486      */
487     function _approve(address owner, address spender, uint256 amount) internal {
488         require(owner != address(0), "ERC20: approve from the zero address");
489         require(spender != address(0), "ERC20: approve to the zero address");
490 
491         _allowances[owner][spender] = amount;
492         emit Approval(owner, spender, amount);
493     }
494 
495     /**
496      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
497      * from the caller's allowance.
498      *
499      * See {_burn} and {_approve}.
500      */
501     function _burnFrom(address account, uint256 amount) internal {
502         _burn(account, amount);
503         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
504     }
505 }
506 
507 // File: @openzeppelin/contracts/utils/Address.sol
508 
509 pragma solidity ^0.5.5;
510 
511 /**
512  * @dev Collection of functions related to the address type
513  */
514 library Address {
515     /**
516      * @dev Returns true if `account` is a contract.
517      *
518      * [IMPORTANT]
519      * ====
520      * It is unsafe to assume that an address for which this function returns
521      * false is an externally-owned account (EOA) and not a contract.
522      *
523      * Among others, `isContract` will return false for the following
524      * types of addresses:
525      *
526      *  - an externally-owned account
527      *  - a contract in construction
528      *  - an address where a contract will be created
529      *  - an address where a contract lived, but was destroyed
530      * ====
531      */
532     function isContract(address account) internal view returns (bool) {
533         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
534         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
535         // for accounts without code, i.e. `keccak256('')`
536         bytes32 codehash;
537         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
538         // solhint-disable-next-line no-inline-assembly
539         assembly { codehash := extcodehash(account) }
540         return (codehash != accountHash && codehash != 0x0);
541     }
542 
543     /**
544      * @dev Converts an `address` into `address payable`. Note that this is
545      * simply a type cast: the actual underlying value is not changed.
546      *
547      * _Available since v2.4.0._
548      */
549     function toPayable(address account) internal pure returns (address payable) {
550         return address(uint160(account));
551     }
552 
553     /**
554      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
555      * `recipient`, forwarding all available gas and reverting on errors.
556      *
557      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
558      * of certain opcodes, possibly making contracts go over the 2300 gas limit
559      * imposed by `transfer`, making them unable to receive funds via
560      * `transfer`. {sendValue} removes this limitation.
561      *
562      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
563      *
564      * IMPORTANT: because control is transferred to `recipient`, care must be
565      * taken to not create reentrancy vulnerabilities. Consider using
566      * {ReentrancyGuard} or the
567      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
568      *
569      * _Available since v2.4.0._
570      */
571     function sendValue(address payable recipient, uint256 amount) internal {
572         require(address(this).balance >= amount, "Address: insufficient balance");
573 
574         // solhint-disable-next-line avoid-call-value
575         (bool success, ) = recipient.call.value(amount)("");
576         require(success, "Address: unable to send value, recipient may have reverted");
577     }
578 }
579 
580 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
581 
582 pragma solidity ^0.5.0;
583 
584 
585 
586 
587 /**
588  * @title SafeERC20
589  * @dev Wrappers around ERC20 operations that throw on failure (when the token
590  * contract returns false). Tokens that return no value (and instead revert or
591  * throw on failure) are also supported, non-reverting calls are assumed to be
592  * successful.
593  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
594  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
595  */
596 library SafeERC20 {
597     using SafeMath for uint256;
598     using Address for address;
599 
600     function safeTransfer(IERC20 token, address to, uint256 value) internal {
601         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
602     }
603 
604     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
605         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
606     }
607 
608     function safeApprove(IERC20 token, address spender, uint256 value) internal {
609         // safeApprove should only be called when setting an initial allowance,
610         // or when resetting it to zero. To increase and decrease it, use
611         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
612         // solhint-disable-next-line max-line-length
613         require((value == 0) || (token.allowance(address(this), spender) == 0),
614             "SafeERC20: approve from non-zero to non-zero allowance"
615         );
616         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
617     }
618 
619     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
620         uint256 newAllowance = token.allowance(address(this), spender).add(value);
621         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
622     }
623 
624     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
625         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
626         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
627     }
628 
629     /**
630      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
631      * on the return value: the return value is optional (but if data is returned, it must not be false).
632      * @param token The token targeted by the call.
633      * @param data The call data (encoded using abi.encode or one of its variants).
634      */
635     function callOptionalReturn(IERC20 token, bytes memory data) private {
636         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
637         // we're implementing it ourselves.
638 
639         // A Solidity high level call has three parts:
640         //  1. The target address is checked to verify it contains contract code
641         //  2. The call itself is made, and success asserted
642         //  3. The return value is decoded, which in turn checks the size of the returned data.
643         // solhint-disable-next-line max-line-length
644         require(address(token).isContract(), "SafeERC20: call to non-contract");
645 
646         // solhint-disable-next-line avoid-low-level-calls
647         (bool success, bytes memory returndata) = address(token).call(data);
648         require(success, "SafeERC20: low-level call failed");
649 
650         if (returndata.length > 0) { // Return data is optional
651             // solhint-disable-next-line max-line-length
652             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
653         }
654     }
655 }
656 
657 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
658 
659 pragma solidity ^0.5.0;
660 
661 
662 /**
663  * @dev Optional functions from the ERC20 standard.
664  */
665 contract ERC20Detailed is IERC20 {
666     string private _name;
667     string private _symbol;
668     uint8 private _decimals;
669 
670     /**
671      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
672      * these values are immutable: they can only be set once during
673      * construction.
674      */
675     constructor (string memory name, string memory symbol, uint8 decimals) public {
676         _name = name;
677         _symbol = symbol;
678         _decimals = decimals;
679     }
680 
681     /**
682      * @dev Returns the name of the token.
683      */
684     function name() public view returns (string memory) {
685         return _name;
686     }
687 
688     /**
689      * @dev Returns the symbol of the token, usually a shorter version of the
690      * name.
691      */
692     function symbol() public view returns (string memory) {
693         return _symbol;
694     }
695 
696     /**
697      * @dev Returns the number of decimals used to get its user representation.
698      * For example, if `decimals` equals `2`, a balance of `505` tokens should
699      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
700      *
701      * Tokens usually opt for a value of 18, imitating the relationship between
702      * Ether and Wei.
703      *
704      * NOTE: This information is only used for _display_ purposes: it in
705      * no way affects any of the arithmetic of the contract, including
706      * {IERC20-balanceOf} and {IERC20-transfer}.
707      */
708     function decimals() public view returns (uint8) {
709         return _decimals;
710     }
711 }
712 
713 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
714 
715 pragma solidity ^0.5.0;
716 
717 /**
718  * @dev Contract module that helps prevent reentrant calls to a function.
719  *
720  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
721  * available, which can be applied to functions to make sure there are no nested
722  * (reentrant) calls to them.
723  *
724  * Note that because there is a single `nonReentrant` guard, functions marked as
725  * `nonReentrant` may not call one another. This can be worked around by making
726  * those functions `private`, and then adding `external` `nonReentrant` entry
727  * points to them.
728  *
729  * TIP: If you would like to learn more about reentrancy and alternative ways
730  * to protect against it, check out our blog post
731  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
732  *
733  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
734  * metering changes introduced in the Istanbul hardfork.
735  */
736 contract ReentrancyGuard {
737     bool private _notEntered;
738 
739     constructor () internal {
740         // Storing an initial non-zero value makes deployment a bit more
741         // expensive, but in exchange the refund on every call to nonReentrant
742         // will be lower in amount. Since refunds are capped to a percetange of
743         // the total transaction's gas, it is best to keep them low in cases
744         // like this one, to increase the likelihood of the full refund coming
745         // into effect.
746         _notEntered = true;
747     }
748 
749     /**
750      * @dev Prevents a contract from calling itself, directly or indirectly.
751      * Calling a `nonReentrant` function from another `nonReentrant`
752      * function is not supported. It is possible to prevent this from happening
753      * by making the `nonReentrant` function external, and make it call a
754      * `private` function that does the actual work.
755      */
756     modifier nonReentrant() {
757         // On the first call to nonReentrant, _notEntered will be true
758         require(_notEntered, "ReentrancyGuard: reentrant call");
759 
760         // Any calls to nonReentrant after this point will fail
761         _notEntered = false;
762 
763         _;
764 
765         // By storing the original value once again, a refund is triggered (see
766         // https://eips.ethereum.org/EIPS/eip-2200)
767         _notEntered = true;
768     }
769 }
770 
771 
772 pragma solidity ^0.5.17;
773 
774 // Interface
775 
776 interface ITendies {
777     function grillPool() external;
778     function claimRewards() external;
779     function unclaimedRewards(address) external returns (uint);
780     function getGrillAmount() external view returns (uint);
781 }
782 
783 interface IweebTendies {
784     function burn(uint256) external;
785 }
786 
787 // NOTE: term slave here refers to ones in BDSM context. Does not refer to any specific historical events.
788 contract TendiesFarmSlave {
789     address public master;
790     
791     IERC20 internal constant TEND = ERC20(0x1453Dbb8A29551ADe11D89825CA812e05317EAEB);
792     
793     constructor() public {
794         master = msg.sender;
795     }
796     
797     function takeMyTendiesMaster(uint256 amount) external {
798         require(msg.sender == master);
799         TEND.transfer(master, amount);
800     }
801 }
802 
803 
804 /**
805  * @title TendiesFarm
806  * @author Weeb_Mcgee on twitter / YieldFarming.info
807  */
808 contract TendiesFarmV2 is ERC20, ERC20Detailed, ReentrancyGuard {
809     using SafeMath for uint256;
810     using SafeERC20 for ERC20;
811     
812     ERC20 public constant TEND = ERC20(0x1453Dbb8A29551ADe11D89825CA812e05317EAEB);
813     ITendies public constant ITEND = ITendies(0x1453Dbb8A29551ADe11D89825CA812e05317EAEB);
814     
815     ERC20 public constant weebTEND = ERC20(0x171aaBEa00881D7F424A11D070dc98767F4f5eD6);
816     IweebTendies public constant IweebTEND = IweebTendies(0x171aaBEa00881D7F424A11D070dc98767F4f5eD6);
817     
818     address public constant owner = 0x4BC821fef2ff947B57585a5FDBC73690Db288A49;
819     
820     uint256 public totalStakedTendies = 0;
821     
822     // NOTE: term slave here refers to ones in BDSM context. Does not refer to any specific historical events.
823     mapping(uint256 => TendiesFarmSlave) public slaves;
824     uint256 public slaveCount;
825     uint256 public maxSlaveCount;
826     
827     /**
828      * @dev Set contract deployer as owner
829      */
830     constructor() public ERC20Detailed("TendiesFarmV2", "weebTEND-V2", 18) {
831         slaves[0] = new TendiesFarmSlave();
832         slaveCount = 1;
833         maxSlaveCount = 1;
834     }
835     
836 
837     // Mint weebTEND with TEND
838     function mint(uint256 amount) public {
839         _grillPool();
840         _claimRewards();
841         
842         uint256 totalStakedTendiesBefore = totalStakedTendies + TEND.balanceOf(address(this));
843         
844         // Receive TEND
845         TEND.safeTransferFrom(msg.sender, address(this), amount);
846         _depositToSlave(TEND.balanceOf(address(this)));
847     
848         uint256 totalStakedTendiesAfter = totalStakedTendies;
849         
850         if (totalSupply() == 0) {
851             _mint(msg.sender, amount);
852         } else {
853             uint256 mintAmount = (totalStakedTendiesAfter.sub(totalStakedTendiesBefore))
854             .mul(totalSupply())
855             .div(totalStakedTendiesBefore);
856             _mint(msg.sender, mintAmount);
857         }
858     }
859     
860     // Burn weebTEND to get collected TEND
861     function burn(uint256 amount) external nonReentrant {
862         _grillPool();
863         _claimRewards();
864         _depositToSlave(TEND.balanceOf(address(this)));
865         
866         // Burn weebTEND
867         uint256 proRataTend = totalStakedTendies.mul(amount).div(totalSupply());
868         _burn(msg.sender, amount);
869 
870         // Calculate burn fee and transfer underlying TEND
871         uint256 _fee = proRataTend.mul(5).div(10000);
872         
873         // Withdraw amount
874         _withdrawFromSlave(proRataTend);
875         proRataTend = TEND.balanceOf(address(this));
876         
877         TEND.safeTransfer(msg.sender, proRataTend.sub(_fee));
878         TEND.safeTransfer(owner, _fee);
879         totalStakedTendies = totalStakedTendies.sub(proRataTend);
880     }
881     
882     function convert(uint256 oldTokenAmount) public nonReentrant {
883         _grillPool();
884         _claimRewards();
885         
886         uint256 totalStakedTendiesBefore = totalStakedTendies + TEND.balanceOf(address(this));
887         
888         // Receive weebTEND-v1
889         weebTEND.safeTransferFrom(msg.sender, address(this), oldTokenAmount);
890         
891         // Convert to TEND
892         IweebTEND.burn(oldTokenAmount);
893         _depositToSlave(TEND.balanceOf(address(this)));
894     
895         uint256 totalStakedTendiesAfter = totalStakedTendies;
896         
897         if (totalSupply() == 0) {
898             _mint(msg.sender, totalStakedTendiesAfter.sub(totalStakedTendiesBefore));
899         } else {
900             uint256 mintAmount = (totalStakedTendiesAfter.sub(totalStakedTendiesBefore))
901             .mul(totalSupply())
902             .div(totalStakedTendiesBefore);
903             _mint(msg.sender, mintAmount);
904         }
905     }
906     
907     function getPricePerFullShare() external view returns (uint256 price) {
908         price = totalStakedTendies.mul(1e18).div(totalSupply());
909     }
910     
911     // Internal functions
912     function _depositToSlave(uint256 amount) internal {
913         if (amount > 0) {
914             TEND.safeTransfer(address(slaves[slaveCount - 1]), amount);
915             totalStakedTendies += amount;
916         }
917     }
918     
919     function _withdrawFromSlave(uint256 amount) internal {
920         if (amount >= TEND.balanceOf(address(slaves[slaveCount - 1]))) {
921             uint256 amountLeftOver = amount;
922             while(amountLeftOver > 0) {
923                 TendiesFarmSlave slave = slaves[slaveCount - 1];
924                 uint256 totalSlaveTEND = TEND.balanceOf(address(slave));
925 
926                 if (amountLeftOver > totalSlaveTEND && slaveCount > 1) {
927                     // Need to withdraw all and destroy a slave
928                     amountLeftOver -= totalSlaveTEND;
929                     slave.takeMyTendiesMaster(totalSlaveTEND);
930                     slaveCount -= 1;
931                 } else {
932                     amountLeftOver = amountLeftOver < totalSlaveTEND ? amountLeftOver : totalSlaveTEND;
933                     slave.takeMyTendiesMaster(amountLeftOver);
934                     amountLeftOver = 0;
935                 }
936             }
937         } else {
938             slaves[slaveCount - 1].takeMyTendiesMaster(amount);
939         }
940     }
941     
942     function _grillPool() internal {
943         if (ITEND.getGrillAmount() >= 1 * 1e18 ) {
944             ITEND.grillPool();
945         }
946     }
947     
948     function _claimRewards() internal {
949         if (ITEND.unclaimedRewards(address(this)) > 0) {
950             ITEND.claimRewards();
951         }
952     }
953     
954     function grillPool() public {
955         _grillPool();
956         _depositToSlave(TEND.balanceOf(address(this)));
957     }
958     
959     function claimRewards() public {
960         _claimRewards();
961         _depositToSlave(TEND.balanceOf(address(this)));
962     }
963     
964     // Admin functions
965     function rebalance(uint256 splitNumber) external {
966         require(msg.sender == owner && splitNumber > 0);
967         
968         if (splitNumber > maxSlaveCount) {
969             for (uint i = maxSlaveCount; i < splitNumber; i++) {
970                 slaves[i] = new TendiesFarmSlave();
971             }
972             maxSlaveCount = splitNumber;
973         }
974         
975         for (uint i = 0; i < slaveCount; i++) {
976             TendiesFarmSlave slave = slaves[i];
977             slave.takeMyTendiesMaster(TEND.balanceOf(address(slave)));
978         }
979         
980         uint256 amountPerPool = totalStakedTendies.div(splitNumber);
981         
982         for (uint i = 0; i < splitNumber - 1; i++) {
983           TEND.safeTransfer(address(slaves[i]), amountPerPool);
984         }
985         
986         TEND.safeTransfer(address(slaves[splitNumber - 1]), TEND.balanceOf(address(this)));
987         slaveCount = splitNumber;
988     }
989 }