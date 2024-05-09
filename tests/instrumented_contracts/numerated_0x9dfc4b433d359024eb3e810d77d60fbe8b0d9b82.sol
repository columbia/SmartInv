1 /***
2  *    ██████╗ ███████╗ ██████╗  ██████╗ 
3  *    ██╔══██╗██╔════╝██╔════╝ ██╔═══██╗
4  *    ██║  ██║█████╗  ██║  ███╗██║   ██║
5  *    ██║  ██║██╔══╝  ██║   ██║██║   ██║
6  *    ██████╔╝███████╗╚██████╔╝╚██████╔╝
7  *    ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ 
8  *    
9  * https://dego.finance
10                                   
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2020 dego
15 *
16 * Permission is hereby granted, free of charge, to any person obtaining a copy
17 * of this software and associated documentation files (the "Software"), to deal
18 * in the Software without restriction, including without limitation the rights
19 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 * copies of the Software, and to permit persons to whom the Software is
21 * furnished to do so, subject to the following conditions:
22 *
23 * The above copyright notice and this permission notice shall be included in all
24 * copies or substantial portions of the Software.
25 *
26 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
29 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
32 */
33 // File: @openzeppelin/contracts/math/SafeMath.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Wrappers over Solidity's arithmetic operations with added overflow
39  * checks.
40  *
41  * Arithmetic operations in Solidity wrap on overflow. This can easily result
42  * in bugs, because programmers usually assume that an overflow raises an
43  * error, which is the standard behavior in high level programming languages.
44  * `SafeMath` restores this intuition by reverting the transaction when an
45  * operation overflows.
46  *
47  * Using this library instead of the unchecked operations eliminates an entire
48  * class of bugs, so it's recommended to use it always.
49  */
50 library SafeMath {
51     /**
52      * @dev Returns the addition of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `+` operator.
56      *
57      * Requirements:
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     /**
81      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
82      * overflow (when the result is negative).
83      *
84      * Counterpart to Solidity's `-` operator.
85      *
86      * Requirements:
87      * - Subtraction cannot overflow.
88      *
89      * _Available since v2.4.0._
90      */
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      *
147      * _Available since v2.4.0._
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         // Solidity only automatically asserts when dividing by 0
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      *
184      * _Available since v2.4.0._
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
193 
194 pragma solidity ^0.5.0;
195 
196 /**
197  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
198  * the optional functions; to access them see {ERC20Detailed}.
199  */
200 interface IERC20 {
201     /**
202      * @dev Returns the amount of tokens in existence.
203      */
204     function totalSupply() external view returns (uint256);
205 
206     /**
207      * @dev Returns the amount of tokens owned by `account`.
208      */
209     function balanceOf(address account) external view returns (uint256);
210 
211     /**
212      * @dev Moves `amount` tokens from the caller's account to `recipient`.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * Emits a {Transfer} event.
217      */
218     function transfer(address recipient, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Returns the remaining number of tokens that `spender` will be
222      * allowed to spend on behalf of `owner` through {transferFrom}. This is
223      * zero by default.
224      *
225      * This value changes when {approve} or {transferFrom} are called.
226      */
227     function allowance(address owner, address spender) external view returns (uint256);
228 
229     /**
230      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
231      *
232      * Returns a boolean value indicating whether the operation succeeded.
233      *
234      * IMPORTANT: Beware that changing an allowance with this method brings the risk
235      * that someone may use both the old and the new allowance by unfortunate
236      * transaction ordering. One possible solution to mitigate this race
237      * condition is to first reduce the spender's allowance to 0 and set the
238      * desired value afterwards:
239      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240      *
241      * Emits an {Approval} event.
242      */
243     function approve(address spender, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Moves `amount` tokens from `sender` to `recipient` using the
247      * allowance mechanism. `amount` is then deducted from the caller's
248      * allowance.
249      *
250      * Returns a boolean value indicating whether the operation succeeded.
251      *
252      * Emits a {Transfer} event.
253      */
254     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
255 
256     /**
257      * @dev Emitted when `value` tokens are moved from one account (`from`) to
258      * another (`to`).
259      *
260      * Note that `value` may be zero.
261      */
262     event Transfer(address indexed from, address indexed to, uint256 value);
263 
264     /**
265      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
266      * a call to {approve}. `value` is the new allowance.
267      */
268     event Approval(address indexed owner, address indexed spender, uint256 value);
269 }
270 
271 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
272 
273 pragma solidity ^0.5.0;
274 
275 
276 /**
277  * @dev Optional functions from the ERC20 standard.
278  */
279 contract ERC20Detailed is IERC20 {
280     string private _name;
281     string private _symbol;
282     uint8 private _decimals;
283 
284     /**
285      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
286      * these values are immutable: they can only be set once during
287      * construction.
288      */
289     constructor (string memory name, string memory symbol, uint8 decimals) public {
290         _name = name;
291         _symbol = symbol;
292         _decimals = decimals;
293     }
294 
295     /**
296      * @dev Returns the name of the token.
297      */
298     function name() public view returns (string memory) {
299         return _name;
300     }
301 
302     /**
303      * @dev Returns the symbol of the token, usually a shorter version of the
304      * name.
305      */
306     function symbol() public view returns (string memory) {
307         return _symbol;
308     }
309 
310     /**
311      * @dev Returns the number of decimals used to get its user representation.
312      * For example, if `decimals` equals `2`, a balance of `505` tokens should
313      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
314      *
315      * Tokens usually opt for a value of 18, imitating the relationship between
316      * Ether and Wei.
317      *
318      * NOTE: This information is only used for _display_ purposes: it in
319      * no way affects any of the arithmetic of the contract, including
320      * {IERC20-balanceOf} and {IERC20-transfer}.
321      */
322     function decimals() public view returns (uint8) {
323         return _decimals;
324     }
325 }
326 
327 // File: @openzeppelin/contracts/utils/Address.sol
328 
329 pragma solidity ^0.5.5;
330 
331 /**
332  * @dev Collection of functions related to the address type
333  */
334 library Address {
335     /**
336      * @dev Returns true if `account` is a contract.
337      *
338      * [IMPORTANT]
339      * ====
340      * It is unsafe to assume that an address for which this function returns
341      * false is an externally-owned account (EOA) and not a contract.
342      *
343      * Among others, `isContract` will return false for the following 
344      * types of addresses:
345      *
346      *  - an externally-owned account
347      *  - a contract in construction
348      *  - an address where a contract will be created
349      *  - an address where a contract lived, but was destroyed
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
354         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
355         // for accounts without code, i.e. `keccak256('')`
356         bytes32 codehash;
357         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
358         // solhint-disable-next-line no-inline-assembly
359         assembly { codehash := extcodehash(account) }
360         return (codehash != accountHash && codehash != 0x0);
361     }
362 
363     /**
364      * @dev Converts an `address` into `address payable`. Note that this is
365      * simply a type cast: the actual underlying value is not changed.
366      *
367      * _Available since v2.4.0._
368      */
369     function toPayable(address account) internal pure returns (address payable) {
370         return address(uint160(account));
371     }
372 
373     /**
374      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
375      * `recipient`, forwarding all available gas and reverting on errors.
376      *
377      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
378      * of certain opcodes, possibly making contracts go over the 2300 gas limit
379      * imposed by `transfer`, making them unable to receive funds via
380      * `transfer`. {sendValue} removes this limitation.
381      *
382      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
383      *
384      * IMPORTANT: because control is transferred to `recipient`, care must be
385      * taken to not create reentrancy vulnerabilities. Consider using
386      * {ReentrancyGuard} or the
387      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
388      *
389      * _Available since v2.4.0._
390      */
391     function sendValue(address payable recipient, uint256 amount) internal {
392         require(address(this).balance >= amount, "Address: insufficient balance");
393 
394         // solhint-disable-next-line avoid-call-value
395         (bool success, ) = recipient.call.value(amount)("");
396         require(success, "Address: unable to send value, recipient may have reverted");
397     }
398 }
399 
400 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
401 
402 pragma solidity ^0.5.0;
403 
404 
405 
406 
407 /**
408  * @title SafeERC20
409  * @dev Wrappers around ERC20 operations that throw on failure (when the token
410  * contract returns false). Tokens that return no value (and instead revert or
411  * throw on failure) are also supported, non-reverting calls are assumed to be
412  * successful.
413  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
414  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
415  */
416 library SafeERC20 {
417     using SafeMath for uint256;
418     using Address for address;
419 
420     function safeTransfer(IERC20 token, address to, uint256 value) internal {
421         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
422     }
423 
424     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
425         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
426     }
427 
428     function safeApprove(IERC20 token, address spender, uint256 value) internal {
429         // safeApprove should only be called when setting an initial allowance,
430         // or when resetting it to zero. To increase and decrease it, use
431         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
432         // solhint-disable-next-line max-line-length
433         require((value == 0) || (token.allowance(address(this), spender) == 0),
434             "SafeERC20: approve from non-zero to non-zero allowance"
435         );
436         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
437     }
438 
439     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
440         uint256 newAllowance = token.allowance(address(this), spender).add(value);
441         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
445         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
446         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
447     }
448 
449     /**
450      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
451      * on the return value: the return value is optional (but if data is returned, it must not be false).
452      * @param token The token targeted by the call.
453      * @param data The call data (encoded using abi.encode or one of its variants).
454      */
455     function callOptionalReturn(IERC20 token, bytes memory data) private {
456         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
457         // we're implementing it ourselves.
458 
459         // A Solidity high level call has three parts:
460         //  1. The target address is checked to verify it contains contract code
461         //  2. The call itself is made, and success asserted
462         //  3. The return value is decoded, which in turn checks the size of the returned data.
463         // solhint-disable-next-line max-line-length
464         require(address(token).isContract(), "SafeERC20: call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = address(token).call(data);
468         require(success, "SafeERC20: low-level call failed");
469 
470         if (returndata.length > 0) { // Return data is optional
471             // solhint-disable-next-line max-line-length
472             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
473         }
474     }
475 }
476 
477 // File: @openzeppelin/contracts/GSN/Context.sol
478 
479 pragma solidity ^0.5.0;
480 
481 /*
482  * @dev Provides information about the current execution context, including the
483  * sender of the transaction and its data. While these are generally available
484  * via msg.sender and msg.data, they should not be accessed in such a direct
485  * manner, since when dealing with GSN meta-transactions the account sending and
486  * paying for execution may not be the actual sender (as far as an application
487  * is concerned).
488  *
489  * This contract is only required for intermediate, library-like contracts.
490  */
491 contract Context {
492     // Empty internal constructor, to prevent people from mistakenly deploying
493     // an instance of this contract, which should be used via inheritance.
494     constructor () internal { }
495     // solhint-disable-previous-line no-empty-blocks
496 
497     function _msgSender() internal view returns (address payable) {
498         return msg.sender;
499     }
500 
501     function _msgData() internal view returns (bytes memory) {
502         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
503         return msg.data;
504     }
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
508 
509 pragma solidity ^0.5.0;
510 
511 
512 
513 
514 /**
515  * @dev Implementation of the {IERC20} interface.
516  *
517  * This implementation is agnostic to the way tokens are created. This means
518  * that a supply mechanism has to be added in a derived contract using {_mint}.
519  * For a generic mechanism see {ERC20Mintable}.
520  *
521  * TIP: For a detailed writeup see our guide
522  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
523  * to implement supply mechanisms].
524  *
525  * We have followed general OpenZeppelin guidelines: functions revert instead
526  * of returning `false` on failure. This behavior is nonetheless conventional
527  * and does not conflict with the expectations of ERC20 applications.
528  *
529  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
530  * This allows applications to reconstruct the allowance for all accounts just
531  * by listening to said events. Other implementations of the EIP may not emit
532  * these events, as it isn't required by the specification.
533  *
534  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
535  * functions have been added to mitigate the well-known issues around setting
536  * allowances. See {IERC20-approve}.
537  */
538 contract ERC20 is Context, IERC20 {
539     using SafeMath for uint256;
540 
541     mapping (address => uint256) private _balances;
542 
543     mapping (address => mapping (address => uint256)) private _allowances;
544 
545     uint256 private _totalSupply;
546 
547     /**
548      * @dev See {IERC20-totalSupply}.
549      */
550     function totalSupply() public view returns (uint256) {
551         return _totalSupply;
552     }
553 
554     /**
555      * @dev See {IERC20-balanceOf}.
556      */
557     function balanceOf(address account) public view returns (uint256) {
558         return _balances[account];
559     }
560 
561     /**
562      * @dev See {IERC20-transfer}.
563      *
564      * Requirements:
565      *
566      * - `recipient` cannot be the zero address.
567      * - the caller must have a balance of at least `amount`.
568      */
569     function transfer(address recipient, uint256 amount) public returns (bool) {
570         _transfer(_msgSender(), recipient, amount);
571         return true;
572     }
573 
574     /**
575      * @dev See {IERC20-allowance}.
576      */
577     function allowance(address owner, address spender) public view returns (uint256) {
578         return _allowances[owner][spender];
579     }
580 
581     /**
582      * @dev See {IERC20-approve}.
583      *
584      * Requirements:
585      *
586      * - `spender` cannot be the zero address.
587      */
588     function approve(address spender, uint256 amount) public returns (bool) {
589         _approve(_msgSender(), spender, amount);
590         return true;
591     }
592 
593     /**
594      * @dev See {IERC20-transferFrom}.
595      *
596      * Emits an {Approval} event indicating the updated allowance. This is not
597      * required by the EIP. See the note at the beginning of {ERC20};
598      *
599      * Requirements:
600      * - `sender` and `recipient` cannot be the zero address.
601      * - `sender` must have a balance of at least `amount`.
602      * - the caller must have allowance for `sender`'s tokens of at least
603      * `amount`.
604      */
605     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
606         _transfer(sender, recipient, amount);
607         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
608         return true;
609     }
610 
611     /**
612      * @dev Atomically increases the allowance granted to `spender` by the caller.
613      *
614      * This is an alternative to {approve} that can be used as a mitigation for
615      * problems described in {IERC20-approve}.
616      *
617      * Emits an {Approval} event indicating the updated allowance.
618      *
619      * Requirements:
620      *
621      * - `spender` cannot be the zero address.
622      */
623     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
624         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
625         return true;
626     }
627 
628     /**
629      * @dev Atomically decreases the allowance granted to `spender` by the caller.
630      *
631      * This is an alternative to {approve} that can be used as a mitigation for
632      * problems described in {IERC20-approve}.
633      *
634      * Emits an {Approval} event indicating the updated allowance.
635      *
636      * Requirements:
637      *
638      * - `spender` cannot be the zero address.
639      * - `spender` must have allowance for the caller of at least
640      * `subtractedValue`.
641      */
642     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
643         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
644         return true;
645     }
646 
647     /**
648      * @dev Moves tokens `amount` from `sender` to `recipient`.
649      *
650      * This is internal function is equivalent to {transfer}, and can be used to
651      * e.g. implement automatic token fees, slashing mechanisms, etc.
652      *
653      * Emits a {Transfer} event.
654      *
655      * Requirements:
656      *
657      * - `sender` cannot be the zero address.
658      * - `recipient` cannot be the zero address.
659      * - `sender` must have a balance of at least `amount`.
660      */
661     function _transfer(address sender, address recipient, uint256 amount) internal {
662         require(sender != address(0), "ERC20: transfer from the zero address");
663         require(recipient != address(0), "ERC20: transfer to the zero address");
664 
665         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
666         _balances[recipient] = _balances[recipient].add(amount);
667         emit Transfer(sender, recipient, amount);
668     }
669 
670     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
671      * the total supply.
672      *
673      * Emits a {Transfer} event with `from` set to the zero address.
674      *
675      * Requirements
676      *
677      * - `to` cannot be the zero address.
678      */
679     function _mint(address account, uint256 amount) internal {
680         require(account != address(0), "ERC20: mint to the zero address");
681 
682         _totalSupply = _totalSupply.add(amount);
683         _balances[account] = _balances[account].add(amount);
684         emit Transfer(address(0), account, amount);
685     }
686 
687     /**
688      * @dev Destroys `amount` tokens from `account`, reducing the
689      * total supply.
690      *
691      * Emits a {Transfer} event with `to` set to the zero address.
692      *
693      * Requirements
694      *
695      * - `account` cannot be the zero address.
696      * - `account` must have at least `amount` tokens.
697      */
698     function _burn(address account, uint256 amount) internal {
699         require(account != address(0), "ERC20: burn from the zero address");
700 
701         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
702         _totalSupply = _totalSupply.sub(amount);
703         emit Transfer(account, address(0), amount);
704     }
705 
706     /**
707      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
708      *
709      * This is internal function is equivalent to `approve`, and can be used to
710      * e.g. set automatic allowances for certain subsystems, etc.
711      *
712      * Emits an {Approval} event.
713      *
714      * Requirements:
715      *
716      * - `owner` cannot be the zero address.
717      * - `spender` cannot be the zero address.
718      */
719     function _approve(address owner, address spender, uint256 amount) internal {
720         require(owner != address(0), "ERC20: approve from the zero address");
721         require(spender != address(0), "ERC20: approve to the zero address");
722 
723         _allowances[owner][spender] = amount;
724         emit Approval(owner, spender, amount);
725     }
726 
727     /**
728      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
729      * from the caller's allowance.
730      *
731      * See {_burn} and {_approve}.
732      */
733     function _burnFrom(address account, uint256 amount) internal {
734         _burn(account, amount);
735         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
736     }
737 }
738 
739 // File: contracts/library/Governance.sol
740 
741 pragma solidity ^0.5.0;
742 
743 contract Governance {
744 
745     address public _governance;
746 
747     constructor() public {
748         _governance = tx.origin;
749     }
750 
751     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
752 
753     modifier onlyGovernance {
754         require(msg.sender == _governance, "not governance");
755         _;
756     }
757 
758     function setGovernance(address governance)  public  onlyGovernance
759     {
760         require(governance != address(0), "new governance the zero address");
761         emit GovernanceTransferred(_governance, governance);
762         _governance = governance;
763     }
764 
765 
766 }
767 
768 // File: contracts/dandy/DandyToken.sol
769 
770 pragma solidity ^0.5.5;
771 
772 
773 
774 
775 
776 
777 
778 /// @title DandyToken Contract
779 
780 contract DandyToken is Governance, ERC20, ERC20Detailed {
781     using SafeERC20 for IERC20;
782     using Address for address;
783     using SafeMath for uint256;
784 
785     // for minters
786     mapping(address => bool) public _minters;
787 
788     //token base data
789     uint256 internal _totalSupply;
790     mapping(address => uint256) public _balances;
791     mapping(address => mapping(address => uint256)) public _allowances;
792 
793     /**
794      * CONSTRUCTOR
795      *
796      * @dev Initialize the Token
797      */
798 
799     constructor() public ERC20Detailed("dandy.dego", "DANDY", 18) {}
800 
801     function mint(address account, uint256 amount) public {
802         require(_minters[msg.sender], "!minter");
803         _mint(account, amount);
804     }
805 
806 
807     function addMinter(address minter) public onlyGovernance{
808         _minters[minter] = true;
809     }
810 
811     function removeMinter(address minter) public onlyGovernance {
812         _minters[minter] = false;
813     }
814 }