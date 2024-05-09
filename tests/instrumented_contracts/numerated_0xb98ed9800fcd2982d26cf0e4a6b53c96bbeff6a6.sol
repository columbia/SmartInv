1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // X-License-Identifier: MIT
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
83 // X-License-Identifier: MIT
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
245 // X-License-Identifier: MIT
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
271         // This method relies in extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
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
387 // File: @openzeppelin/contracts/GSN/Context.sol
388 
389 // X-License-Identifier: MIT
390 
391 pragma solidity ^0.6.0;
392 
393 /*
394  * @dev Provides information about the current execution context, including the
395  * sender of the transaction and its data. While these are generally available
396  * via msg.sender and msg.data, they should not be accessed in such a direct
397  * manner, since when dealing with GSN meta-transactions the account sending and
398  * paying for execution may not be the actual sender (as far as an application
399  * is concerned).
400  *
401  * This contract is only required for intermediate, library-like contracts.
402  */
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address payable) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes memory) {
409         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
410         return msg.data;
411     }
412 }
413 
414 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
415 
416 // X-License-Identifier: MIT
417 
418 pragma solidity ^0.6.0;
419 
420 
421 
422 
423 
424 /**
425  * @dev Implementation of the {IERC20} interface.
426  *
427  * This implementation is agnostic to the way tokens are created. This means
428  * that a supply mechanism has to be added in a derived contract using {_mint}.
429  * For a generic mechanism see {ERC20PresetMinterPauser}.
430  *
431  * TIP: For a detailed writeup see our guide
432  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
433  * to implement supply mechanisms].
434  *
435  * We have followed general OpenZeppelin guidelines: functions revert instead
436  * of returning `false` on failure. This behavior is nonetheless conventional
437  * and does not conflict with the expectations of ERC20 applications.
438  *
439  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
440  * This allows applications to reconstruct the allowance for all accounts just
441  * by listening to said events. Other implementations of the EIP may not emit
442  * these events, as it isn't required by the specification.
443  *
444  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
445  * functions have been added to mitigate the well-known issues around setting
446  * allowances. See {IERC20-approve}.
447  */
448 contract ERC20 is Context, IERC20 {
449     using SafeMath for uint256;
450     using Address for address;
451 
452     mapping (address => uint256) private _balances;
453 
454     mapping (address => mapping (address => uint256)) private _allowances;
455 
456     uint256 private _totalSupply;
457 
458     string private _name;
459     string private _symbol;
460     uint8 private _decimals;
461 
462     /**
463      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
464      * a default value of 18.
465      *
466      * To select a different value for {decimals}, use {_setupDecimals}.
467      *
468      * All three of these values are immutable: they can only be set once during
469      * construction.
470      */
471     constructor (string memory name, string memory symbol) public {
472         _name = name;
473         _symbol = symbol;
474         _decimals = 18;
475     }
476 
477     /**
478      * @dev Returns the name of the token.
479      */
480     function name() public view returns (string memory) {
481         return _name;
482     }
483 
484     /**
485      * @dev Returns the symbol of the token, usually a shorter version of the
486      * name.
487      */
488     function symbol() public view returns (string memory) {
489         return _symbol;
490     }
491 
492     /**
493      * @dev Returns the number of decimals used to get its user representation.
494      * For example, if `decimals` equals `2`, a balance of `505` tokens should
495      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
496      *
497      * Tokens usually opt for a value of 18, imitating the relationship between
498      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
499      * called.
500      *
501      * NOTE: This information is only used for _display_ purposes: it in
502      * no way affects any of the arithmetic of the contract, including
503      * {IERC20-balanceOf} and {IERC20-transfer}.
504      */
505     function decimals() public view returns (uint8) {
506         return _decimals;
507     }
508 
509     /**
510      * @dev See {IERC20-totalSupply}.
511      */
512     function totalSupply() public view override returns (uint256) {
513         return _totalSupply;
514     }
515 
516     /**
517      * @dev See {IERC20-balanceOf}.
518      */
519     function balanceOf(address account) public view override returns (uint256) {
520         return _balances[account];
521     }
522 
523     /**
524      * @dev See {IERC20-transfer}.
525      *
526      * Requirements:
527      *
528      * - `recipient` cannot be the zero address.
529      * - the caller must have a balance of at least `amount`.
530      */
531     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
532         _transfer(_msgSender(), recipient, amount);
533         return true;
534     }
535 
536     /**
537      * @dev See {IERC20-allowance}.
538      */
539     function allowance(address owner, address spender) public view virtual override returns (uint256) {
540         return _allowances[owner][spender];
541     }
542 
543     /**
544      * @dev See {IERC20-approve}.
545      *
546      * Requirements:
547      *
548      * - `spender` cannot be the zero address.
549      */
550     function approve(address spender, uint256 amount) public virtual override returns (bool) {
551         _approve(_msgSender(), spender, amount);
552         return true;
553     }
554 
555     /**
556      * @dev See {IERC20-transferFrom}.
557      *
558      * Emits an {Approval} event indicating the updated allowance. This is not
559      * required by the EIP. See the note at the beginning of {ERC20};
560      *
561      * Requirements:
562      * - `sender` and `recipient` cannot be the zero address.
563      * - `sender` must have a balance of at least `amount`.
564      * - the caller must have allowance for ``sender``'s tokens of at least
565      * `amount`.
566      */
567     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
568         _transfer(sender, recipient, amount);
569         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
570         return true;
571     }
572 
573     /**
574      * @dev Atomically increases the allowance granted to `spender` by the caller.
575      *
576      * This is an alternative to {approve} that can be used as a mitigation for
577      * problems described in {IERC20-approve}.
578      *
579      * Emits an {Approval} event indicating the updated allowance.
580      *
581      * Requirements:
582      *
583      * - `spender` cannot be the zero address.
584      */
585     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
586         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
587         return true;
588     }
589 
590     /**
591      * @dev Atomically decreases the allowance granted to `spender` by the caller.
592      *
593      * This is an alternative to {approve} that can be used as a mitigation for
594      * problems described in {IERC20-approve}.
595      *
596      * Emits an {Approval} event indicating the updated allowance.
597      *
598      * Requirements:
599      *
600      * - `spender` cannot be the zero address.
601      * - `spender` must have allowance for the caller of at least
602      * `subtractedValue`.
603      */
604     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
605         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
606         return true;
607     }
608 
609     /**
610      * @dev Moves tokens `amount` from `sender` to `recipient`.
611      *
612      * This is internal function is equivalent to {transfer}, and can be used to
613      * e.g. implement automatic token fees, slashing mechanisms, etc.
614      *
615      * Emits a {Transfer} event.
616      *
617      * Requirements:
618      *
619      * - `sender` cannot be the zero address.
620      * - `recipient` cannot be the zero address.
621      * - `sender` must have a balance of at least `amount`.
622      */
623     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
624         require(sender != address(0), "ERC20: transfer from the zero address");
625         require(recipient != address(0), "ERC20: transfer to the zero address");
626 
627         _beforeTokenTransfer(sender, recipient, amount);
628 
629         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
630         _balances[recipient] = _balances[recipient].add(amount);
631         emit Transfer(sender, recipient, amount);
632     }
633 
634     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
635      * the total supply.
636      *
637      * Emits a {Transfer} event with `from` set to the zero address.
638      *
639      * Requirements
640      *
641      * - `to` cannot be the zero address.
642      */
643     function _mint(address account, uint256 amount) internal virtual {
644         require(account != address(0), "ERC20: mint to the zero address");
645 
646         _beforeTokenTransfer(address(0), account, amount);
647 
648         _totalSupply = _totalSupply.add(amount);
649         _balances[account] = _balances[account].add(amount);
650         emit Transfer(address(0), account, amount);
651     }
652 
653     /**
654      * @dev Destroys `amount` tokens from `account`, reducing the
655      * total supply.
656      *
657      * Emits a {Transfer} event with `to` set to the zero address.
658      *
659      * Requirements
660      *
661      * - `account` cannot be the zero address.
662      * - `account` must have at least `amount` tokens.
663      */
664     function _burn(address account, uint256 amount) internal virtual {
665         require(account != address(0), "ERC20: burn from the zero address");
666 
667         _beforeTokenTransfer(account, address(0), amount);
668 
669         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
670         _totalSupply = _totalSupply.sub(amount);
671         emit Transfer(account, address(0), amount);
672     }
673 
674     /**
675      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
676      *
677      * This internal function is equivalent to `approve`, and can be used to
678      * e.g. set automatic allowances for certain subsystems, etc.
679      *
680      * Emits an {Approval} event.
681      *
682      * Requirements:
683      *
684      * - `owner` cannot be the zero address.
685      * - `spender` cannot be the zero address.
686      */
687     function _approve(address owner, address spender, uint256 amount) internal virtual {
688         require(owner != address(0), "ERC20: approve from the zero address");
689         require(spender != address(0), "ERC20: approve to the zero address");
690 
691         _allowances[owner][spender] = amount;
692         emit Approval(owner, spender, amount);
693     }
694 
695     /**
696      * @dev Sets {decimals} to a value other than the default one of 18.
697      *
698      * WARNING: This function should only be called from the constructor. Most
699      * applications that interact with token contracts will not expect
700      * {decimals} to ever change, and may work incorrectly if it does.
701      */
702     function _setupDecimals(uint8 decimals_) internal {
703         _decimals = decimals_;
704     }
705 
706     /**
707      * @dev Hook that is called before any transfer of tokens. This includes
708      * minting and burning.
709      *
710      * Calling conditions:
711      *
712      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
713      * will be to transferred to `to`.
714      * - when `from` is zero, `amount` tokens will be minted for `to`.
715      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
716      * - `from` and `to` are never both zero.
717      *
718      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
719      */
720     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
721 }
722 
723 // File: @openzeppelin/contracts/access/Ownable.sol
724 
725 // X-License-Identifier: MIT
726 
727 pragma solidity ^0.6.0;
728 
729 /**
730  * @dev Contract module which provides a basic access control mechanism, where
731  * there is an account (an owner) that can be granted exclusive access to
732  * specific functions.
733  *
734  * By default, the owner account will be the one that deploys the contract. This
735  * can later be changed with {transferOwnership}.
736  *
737  * This module is used through inheritance. It will make available the modifier
738  * `onlyOwner`, which can be applied to your functions to restrict their use to
739  * the owner.
740  */
741  
742 contract Ownable is Context {
743     address private _owner;
744 
745     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
746 
747     /**
748      * @dev Initializes the contract setting the deployer as the initial owner.
749      */
750     constructor () internal {
751         address msgSender = _msgSender();
752         _owner = msgSender;
753         emit OwnershipTransferred(address(0), msgSender);
754     }
755 
756     /**
757      * @dev Returns the address of the current owner.
758      */
759     function owner() public view returns (address) {
760         return _owner;
761     }
762 
763     /**
764      * @dev Throws if called by any account other than the owner.
765      */
766     modifier onlyOwner() {
767         require(_owner == _msgSender(), "Ownable: caller is not the owner");
768         _;
769     }
770 
771     /**
772      * @dev Leaves the contract without owner. It will not be possible to call
773      * `onlyOwner` functions anymore. Can only be called by the current owner.
774      *
775      * NOTE: Renouncing ownership will leave the contract without an owner,
776      * thereby removing any functionality that is only available to the owner.
777      */
778     function renounceOwnership() public virtual onlyOwner {
779         emit OwnershipTransferred(_owner, address(0));
780         _owner = address(0);
781     }
782 
783     /**
784      * @dev Transfers ownership of the contract to a new account (`newOwner`).
785      * Can only be called by the current owner.
786      */
787     function transferOwnership(address newOwner) public virtual onlyOwner {
788         require(newOwner != address(0), "Ownable: new owner is the zero address");
789         emit OwnershipTransferred(_owner, newOwner);
790         _owner = newOwner;
791     }
792 }
793 
794 // File: @openzeppelin/contracts/utils/Pausable.sol
795 
796 // X-License-Identifier: MIT
797 
798 pragma solidity ^0.6.0;
799 
800 
801 /**
802  * @dev Contract module which allows children to implement an emergency stop
803  * mechanism that can be triggered by an authorized account.
804  *
805  * This module is used through inheritance. It will make available the
806  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
807  * the functions of your contract. Note that they will not be pausable by
808  * simply including this module, only once the modifiers are put in place.
809  */
810 contract Pausable is Context {
811     /**
812      * @dev Emitted when the pause is triggered by `account`.
813      */
814     event Paused(address account);
815 
816     /**
817      * @dev Emitted when the pause is lifted by `account`.
818      */
819     event Unpaused(address account);
820 
821     bool private _paused;
822 
823     /**
824      * @dev Initializes the contract in unpaused state.
825      */
826     constructor () internal {
827         _paused = false;
828     }
829 
830     /**
831      * @dev Returns true if the contract is paused, and false otherwise.
832      */
833     function paused() public view returns (bool) {
834         return _paused;
835     }
836 
837     /**
838      * @dev Modifier to make a function callable only when the contract is not paused.
839      *
840      * Requirements:
841      *
842      * - The contract must not be paused.
843      */
844     modifier whenNotPaused() {
845         require(!_paused, "Pausable: paused");
846         _;
847     }
848 
849     /**
850      * @dev Modifier to make a function callable only when the contract is paused.
851      *
852      * Requirements:
853      *
854      * - The contract must be paused.
855      */
856     modifier whenPaused() {
857         require(_paused, "Pausable: not paused");
858         _;
859     }
860 
861     /**
862      * @dev Triggers stopped state.
863      *
864      * Requirements:
865      *
866      * - The contract must not be paused.
867      */
868     function _pause() internal virtual whenNotPaused {
869         _paused = true;
870         emit Paused(_msgSender());
871     }
872 
873     /**
874      * @dev Returns to normal state.
875      *
876      * Requirements:
877      *
878      * - The contract must be paused.
879      */
880     function _unpause() internal virtual whenPaused {
881         _paused = false;
882         emit Unpaused(_msgSender());
883     }
884 }
885 
886 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
887 
888 // X-License-Identifier: MIT
889 
890 pragma solidity ^0.6.0;
891 
892 /**
893  * @dev Contract module that helps prevent reentrant calls to a function.
894  *
895  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
896  * available, which can be applied to functions to make sure there are no nested
897  * (reentrant) calls to them.
898  *
899  * Note that because there is a single `nonReentrant` guard, functions marked as
900  * `nonReentrant` may not call one another. This can be worked around by making
901  * those functions `private`, and then adding `external` `nonReentrant` entry
902  * points to them.
903  *
904  * TIP: If you would like to learn more about reentrancy and alternative ways
905  * to protect against it, check out our blog post
906  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
907  */
908 contract ReentrancyGuard {
909     // Booleans are more expensive than uint256 or any type that takes up a full
910     // word because each write operation emits an extra SLOAD to first read the
911     // slot's contents, replace the bits taken up by the boolean, and then write
912     // back. This is the compiler's defense against contract upgrades and
913     // pointer aliasing, and it cannot be disabled.
914 
915     // The values being non-zero value makes deployment a bit more expensive,
916     // but in exchange the refund on every call to nonReentrant will be lower in
917     // amount. Since refunds are capped to a percentage of the total
918     // transaction's gas, it is best to keep them low in cases like this one, to
919     // increase the likelihood of the full refund coming into effect.
920     uint256 private constant _NOT_ENTERED = 1;
921     uint256 private constant _ENTERED = 2;
922 
923     uint256 private _status;
924 
925     constructor () internal {
926         _status = _NOT_ENTERED;
927     }
928 
929     /**
930      * @dev Prevents a contract from calling itself, directly or indirectly.
931      * Calling a `nonReentrant` function from another `nonReentrant`
932      * function is not supported. It is possible to prevent this from happening
933      * by making the `nonReentrant` function external, and make it call a
934      * `private` function that does the actual work.
935      */
936     modifier nonReentrant() {
937         // On the first call to nonReentrant, _notEntered will be true
938         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
939 
940         // Any calls to nonReentrant after this point will fail
941         _status = _ENTERED;
942 
943         _;
944 
945         // By storing the original value once again, a refund is triggered (see
946         // https://eips.ethereum.org/EIPS/eip-2200)
947         _status = _NOT_ENTERED;
948     }
949 }
950 
951 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
952 
953 // X-License-Identifier: MIT
954 
955 pragma solidity ^0.6.0;
956 
957 
958 
959 
960 /**
961  * @title SafeERC20
962  * @dev Wrappers around ERC20 operations that throw on failure (when the token
963  * contract returns false). Tokens that return no value (and instead revert or
964  * throw on failure) are also supported, non-reverting calls are assumed to be
965  * successful.
966  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
967  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
968  */
969 library SafeERC20 {
970     using SafeMath for uint256;
971     using Address for address;
972 
973     function safeTransfer(IERC20 token, address to, uint256 value) internal {
974         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
975     }
976 
977     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
978         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
979     }
980 
981     /**
982      * @dev Deprecated. This function has issues similar to the ones found in
983      * {IERC20-approve}, and its usage is discouraged.
984      *
985      * Whenever possible, use {safeIncreaseAllowance} and
986      * {safeDecreaseAllowance} instead.
987      */
988     function safeApprove(IERC20 token, address spender, uint256 value) internal {
989         // safeApprove should only be called when setting an initial allowance,
990         // or when resetting it to zero. To increase and decrease it, use
991         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
992         // solhint-disable-next-line max-line-length
993         require((value == 0) || (token.allowance(address(this), spender) == 0),
994             "SafeERC20: approve from non-zero to non-zero allowance"
995         );
996         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
997     }
998 
999     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1000         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1001         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1002     }
1003 
1004     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1005         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1006         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1007     }
1008 
1009     /**
1010      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1011      * on the return value: the return value is optional (but if data is returned, it must not be false).
1012      * @param token The token targeted by the call.
1013      * @param data The call data (encoded using abi.encode or one of its variants).
1014      */
1015     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1016         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1017         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1018         // the target address contains contract code and also asserts for success in the low-level call.
1019 
1020         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1021         if (returndata.length > 0) { // Return data is optional
1022             // solhint-disable-next-line max-line-length
1023             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1024         }
1025     }
1026 }
1027 
1028 // File: contracts/interfaces/INsure.sol
1029 
1030 pragma solidity ^0.6.0;
1031 pragma experimental ABIEncoderV2;
1032 interface INsure {
1033 
1034     function burn(uint256 amount)  external ;
1035     function transfer(address recipient, uint256 amount) external returns (bool);
1036     function transferFrom(address sender, address recipient, uint256 amount) external  returns (bool);
1037     function mint(address _to, uint256 _amount) external  returns (bool);
1038     function balanceOf(address account) external view returns (uint256);
1039 }
1040 
1041 // File: contracts/CapitalStake.sol
1042 
1043 /**
1044  * @dev Capital mining contract. Need stake here to earn rewards after converting to nTokens.
1045  */
1046 
1047 pragma solidity ^0.6.0;
1048 
1049 
1050 
1051 
1052 
1053 
1054 
1055 
1056 
1057 
1058 
1059 
1060 
1061 
1062 
1063 contract CapitalStake is Ownable, Pausable, ReentrancyGuard {
1064     using SafeMath for uint256;
1065     using SafeERC20 for IERC20;
1066 
1067     address public signer;
1068     string public constant name = "CapitalStake";
1069     string public constant version = "1";
1070     // Info of each user.
1071     struct UserInfo {
1072         uint256 amount;     // How many  tokens the user has provided.
1073         uint256 rewardDebt; // Reward debt. See explanation below.
1074         uint256 reward;
1075 
1076         uint256 pendingWithdrawal;  // payments available for withdrawal by an investor
1077         uint256 pendingAt;
1078     }
1079 
1080     // Info of each pool.
1081     struct PoolInfo {
1082         uint256 amount;             //Total Deposit of token
1083         IERC20 lpToken;             // Address of token contract.
1084         uint256 allocPoint;
1085         uint256 lastRewardBlock;
1086         uint256 accNsurePerShare;
1087         uint256 pending;
1088     }
1089  
1090     INsure public nsure;
1091     uint256 public nsurePerBlock    = 18 * 1e17;
1092 
1093     uint256 public pendingDuration  = 14 days;
1094 
1095     mapping(uint256 => uint256) public capacityMax;
1096 
1097     bool public canDeposit = true;
1098     address public operator;
1099 
1100     // the max capacity for one user's deposit.
1101     mapping(uint256 => uint256) public userCapacityMax;
1102 
1103     // Info of each pool.
1104     PoolInfo[] public poolInfo;
1105 
1106     /// @notice A record of states for signing / validating signatures
1107     mapping(address => uint256) public nonces;
1108     // Info of each user that stakes LP tokens.
1109     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1110 
1111     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1112     uint256 public totalAllocPoint = 0;
1113 
1114     uint256 public startBlock;
1115 
1116 
1117      /// @notice The EIP-712 typehash for the contract's domain
1118     bytes32 public constant DOMAIN_TYPEHASH =
1119         keccak256(
1120             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1121     );
1122 
1123     /// @notice The EIP-712 typehash for the permit struct used by the contract
1124     bytes32 public constant Capital_Unstake_TYPEHASH =
1125         keccak256(
1126             "CapitalUnstake(uint256 pid,address account,uint256 amount,uint256 nonce,uint256 deadline)"
1127     );
1128 
1129     bytes32 public constant Capital_Deposit_TYPEHASH =
1130         keccak256(
1131             "Deposit(uint256 pid,address account,uint256 amount,uint256 nonce,uint256 deadline)"
1132     );
1133 
1134 
1135 
1136     constructor(address _signer, address _nsure, uint256 _startBlock) public {
1137         nsure       = INsure(_nsure);
1138         startBlock  = _startBlock;
1139         userCapacityMax[0] = 10000e18;
1140         signer = _signer;
1141     }
1142     
1143       function setOperator(address _operator) external onlyOwner {   
1144         require(_operator != address(0),"_operator is zero");
1145         operator = _operator;
1146         emit eSetOperator(_operator);
1147     }
1148 
1149     function setSigner(address _signer) external onlyOwner {
1150         require(_signer != address(0), "_signer is zero");
1151         signer = _signer;
1152         emit eSetSigner(_signer);
1153     }
1154 
1155     modifier onlyOperator() {
1156         require(msg.sender == operator,"not operator");
1157         _;
1158     }
1159 
1160     function switchDeposit() external onlyOwner {
1161         canDeposit = !canDeposit;
1162         emit SwitchDeposit(canDeposit);
1163     }
1164 
1165     function setUserCapacityMax(uint256 _pid,uint256 _max) external onlyOwner {
1166         userCapacityMax[_pid] = _max;
1167         emit SetUserCapacityMax(_pid,_max);
1168     }
1169 
1170     function setCapacityMax(uint256 _pid,uint256 _max) external onlyOwner {
1171         capacityMax[_pid] = _max;
1172         emit SetCapacityMax(_pid,_max);
1173     }
1174    
1175    
1176    
1177     function updateBlockReward(uint256 _newReward) external onlyOwner {
1178         nsurePerBlock   = _newReward;
1179         emit UpdateBlockReward(_newReward);
1180     }
1181 
1182     function updateWithdrawPending(uint256 _seconds) external onlyOwner {
1183         pendingDuration = _seconds;
1184         emit UpdateWithdrawPending(_seconds);
1185     }
1186 
1187     function poolLength() public view returns (uint256) {
1188         return poolInfo.length;
1189     }
1190 
1191     // Add a new lp to the pool. Can only be called by the owner.
1192     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate,uint256 maxCapacity) onlyOwner external {
1193         require(address(_lpToken) != address(0),"_lpToken is zero");
1194         for(uint256 i=0; i<poolLength(); i++) {
1195             require(address(_lpToken) != address(poolInfo[i].lpToken), "Duplicate Token!");
1196         }
1197 
1198         if (_withUpdate) {
1199             massUpdatePools();
1200         }
1201 
1202         capacityMax[poolInfo.length] = maxCapacity;
1203         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1204         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1205         poolInfo.push(PoolInfo({
1206             amount:0,
1207             lpToken: _lpToken,
1208             allocPoint: _allocPoint,
1209             lastRewardBlock: lastRewardBlock,
1210             accNsurePerShare: 0,
1211             pending: 0
1212         }));
1213 
1214         
1215         emit Add(_allocPoint,_lpToken,_withUpdate);
1216     }
1217 
1218     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate)  onlyOwner external {
1219         require(_pid < poolInfo.length , "invalid _pid");
1220         if (_withUpdate) {
1221             massUpdatePools();
1222         }
1223 
1224         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1225         poolInfo[_pid].allocPoint = _allocPoint;
1226         emit Set(_pid,_allocPoint,_withUpdate);
1227     }
1228 
1229     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
1230         return _to.sub(_from);
1231     }
1232 
1233     function pendingNsure(uint256 _pid, address _user) external view returns (uint256) {
1234         PoolInfo storage pool = poolInfo[_pid];
1235         UserInfo storage user = userInfo[_pid][_user];
1236 
1237         uint256 accNsurePerShare = pool.accNsurePerShare;
1238         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1239         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1240             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1241             uint256 nsureReward = multiplier.mul(nsurePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1242             accNsurePerShare = accNsurePerShare.add(nsureReward.mul(1e12).div(lpSupply));
1243         }
1244 
1245         return user.amount.mul(accNsurePerShare).div(1e12).sub(user.rewardDebt);
1246     }
1247 
1248 
1249     function massUpdatePools() public {
1250         uint256 length = poolInfo.length;
1251         for (uint256 pid = 0; pid < length; ++pid) {
1252             updatePool(pid);
1253         }
1254     }
1255 
1256     function updatePool(uint256 _pid) public {
1257         require(_pid < poolInfo.length, "invalid _pid");
1258         PoolInfo storage pool = poolInfo[_pid];
1259         if (block.number <= pool.lastRewardBlock) {
1260             return;
1261         }
1262         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1263         if (lpSupply == 0) {
1264             pool.lastRewardBlock = block.number;
1265             return;
1266         }
1267 
1268         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1269         uint256 nsureReward = multiplier.mul(nsurePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1270 
1271         bool mintRet = nsure.mint(address(this), nsureReward);
1272         if(mintRet) {
1273             pool.accNsurePerShare = pool.accNsurePerShare.add(nsureReward.mul(1e12).div(lpSupply));
1274             pool.lastRewardBlock = block.number;
1275         }
1276     }
1277 
1278 
1279     function deposit(uint256 _pid, uint256 _amount) external whenNotPaused {
1280         require(canDeposit, "can not");
1281         require(_pid < poolInfo.length, "invalid _pid");
1282         PoolInfo storage pool = poolInfo[_pid];
1283         UserInfo storage user = userInfo[_pid][msg.sender];
1284         require(user.amount.add(_amount) <= userCapacityMax[_pid],"exceed user limit");
1285         require(pool.amount.add(_amount) <= capacityMax[_pid],"exceed the total limit");
1286         updatePool(_pid);
1287 
1288       
1289         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1290 
1291         uint256 pending = user.amount.mul(pool.accNsurePerShare).div(1e12).sub(user.rewardDebt);
1292         
1293         user.amount = user.amount.add(_amount);
1294         user.rewardDebt = user.amount.mul(pool.accNsurePerShare).div(1e12);
1295         
1296         pool.amount = pool.amount.add(_amount);
1297 
1298         if(pending > 0){
1299             safeNsureTransfer(msg.sender,pending);
1300         }
1301 
1302         emit Deposit(msg.sender, _pid, _amount);
1303     }
1304 
1305     
1306 
1307 
1308     // unstake, need pending sometime
1309     function unstake(
1310             uint256 _pid,
1311             uint256 _amount,
1312             uint8 v,
1313             bytes32 r,
1314             bytes32 s,
1315             uint256 deadline) external nonReentrant whenNotPaused {
1316 
1317    
1318         bytes32 domainSeparator =
1319             keccak256(
1320                 abi.encode(
1321                     DOMAIN_TYPEHASH,
1322                     keccak256(bytes(name)),
1323                     keccak256(bytes(version)),
1324                     getChainId(),
1325                     address(this)
1326                 )
1327             );
1328         bytes32 structHash =
1329             keccak256(
1330                 abi.encode(
1331                     Capital_Unstake_TYPEHASH,
1332                     _pid,
1333                     address(msg.sender),
1334                     _amount,
1335                     nonces[msg.sender]++,
1336                     deadline
1337                 )
1338             );
1339         bytes32 digest =
1340             keccak256(
1341                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
1342             );
1343             
1344         address signatory = ecrecover(digest, v, r, s);
1345         require(signatory != address(0), "invalid signature");
1346         require(signatory == signer, "unauthorized");
1347         
1348 
1349         require(_pid < poolInfo.length , "invalid _pid");
1350         PoolInfo storage pool = poolInfo[_pid];
1351         UserInfo storage user = userInfo[_pid][msg.sender];
1352 
1353         require(user.amount >= _amount, "unstake: insufficient assets");
1354 
1355         updatePool(_pid);
1356         uint256 pending = user.amount.mul(pool.accNsurePerShare).div(1e12).sub(user.rewardDebt);
1357        
1358         user.amount     = user.amount.sub(_amount);
1359         user.rewardDebt = user.amount.mul(pool.accNsurePerShare).div(1e12);
1360 
1361         user.pendingAt  = block.timestamp;
1362         user.pendingWithdrawal = user.pendingWithdrawal.add(_amount);
1363 
1364         pool.pending = pool.pending.add(_amount);
1365 
1366         safeNsureTransfer(msg.sender, pending);
1367 
1368         emit Unstake(msg.sender,_pid,_amount,nonces[msg.sender]-1);
1369     }
1370 
1371 
1372       // unstake, need pending sometime
1373       // won't use this function, for we don't use it now.
1374     function deposit(
1375             uint256 _pid,
1376             uint256 _amount,
1377             uint8 v,
1378             bytes32 r,
1379             bytes32 s,
1380             uint256 deadline) external nonReentrant whenNotPaused {
1381 
1382    
1383         bytes32 domainSeparator =
1384             keccak256(
1385                 abi.encode(
1386                     DOMAIN_TYPEHASH,
1387                     keccak256(bytes(name)),
1388                     keccak256(bytes(version)),
1389                     getChainId(),
1390                     address(this)
1391                 )
1392             );
1393         bytes32 structHash =
1394             keccak256(
1395                 abi.encode(
1396                     Capital_Deposit_TYPEHASH,
1397                     _pid,
1398                     address(msg.sender),
1399                     _amount,
1400                     nonces[msg.sender]++,
1401                     deadline
1402                 )
1403             );
1404         bytes32 digest =
1405             keccak256(
1406                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
1407             );
1408             
1409         address signatory = ecrecover(digest, v, r, s);
1410         require(signatory != address(0), "invalid signature");
1411         require(signatory == signer, "unauthorized");
1412         
1413 
1414         require(_pid < poolInfo.length , "invalid _pid");
1415         PoolInfo storage pool = poolInfo[_pid];
1416         UserInfo storage user = userInfo[_pid][msg.sender];
1417         require(user.amount.add(_amount) <= userCapacityMax[_pid],"exceed user's limit");
1418         require(pool.amount.add(_amount) <= capacityMax[_pid],"exceed the total limit");
1419         updatePool(_pid);
1420 
1421       
1422         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1423 
1424         uint256 pending = user.amount.mul(pool.accNsurePerShare).div(1e12).sub(user.rewardDebt);
1425         
1426         user.amount = user.amount.add(_amount);
1427         user.rewardDebt = user.amount.mul(pool.accNsurePerShare).div(1e12);
1428         
1429         pool.amount = pool.amount.add(_amount);
1430 
1431         if(pending > 0){
1432             safeNsureTransfer(msg.sender,pending);
1433         }
1434 
1435         emit DepositSign(msg.sender, _pid, _amount,nonces[msg.sender] - 1);
1436     }
1437 
1438 
1439 
1440 
1441     function isPending(uint256 _pid) external view returns (bool,uint256) {
1442         UserInfo storage user = userInfo[_pid][msg.sender];
1443         if(block.timestamp >= user.pendingAt.add(pendingDuration)) {
1444             return (false,0);
1445         }
1446 
1447         return (true,user.pendingAt.add(pendingDuration).sub(block.timestamp));
1448     }
1449     
1450     // when it's pending while a claim occurs, the value of the withdrawal will decrease as usual
1451     // so we keep the claim function by this tool.
1452     function withdraw(uint256 _pid) external nonReentrant whenNotPaused {
1453         require(_pid < poolInfo.length , "invalid _pid");
1454         PoolInfo storage pool = poolInfo[_pid];
1455         UserInfo storage user = userInfo[_pid][msg.sender];
1456 
1457         require(block.timestamp >= user.pendingAt.add(pendingDuration), "still pending");
1458 
1459         uint256 amount          = user.pendingWithdrawal;
1460         pool.amount             = pool.amount.sub(amount);
1461         pool.pending            = pool.pending.sub(amount);
1462 
1463         user.pendingWithdrawal  = 0;
1464 
1465         pool.lpToken.safeTransfer(address(msg.sender), amount);
1466 
1467      
1468         
1469         emit Withdraw(msg.sender, _pid, amount);
1470     }
1471 
1472     //claim reward
1473     function claim(uint256 _pid) external nonReentrant whenNotPaused {
1474         require(_pid < poolInfo.length , "invalid _pid");
1475         PoolInfo storage pool = poolInfo[_pid];
1476         UserInfo storage user = userInfo[_pid][msg.sender];
1477 
1478         updatePool(_pid);
1479 
1480         uint256 pending = user.amount.mul(pool.accNsurePerShare).div(1e12).sub(user.rewardDebt);
1481         safeNsureTransfer(msg.sender, pending);
1482 
1483         user.rewardDebt = user.amount.mul(pool.accNsurePerShare).div(1e12);
1484 
1485         emit Claim(msg.sender, _pid, pending);
1486     }
1487 
1488     // we don't support this function due to the claim process..
1489     // or guys will step over the claim events via this function. 
1490     // function emergencyWithdraw(uint256 _pid) public {
1491     //     PoolInfo storage pool = poolInfo[_pid];
1492     //     UserInfo storage user = userInfo[_pid][msg.sender];
1493     //     pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1494 
1495     //     emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1496 
1497     //     user.amount = 0;
1498     //     user.rewardDebt = 0;
1499     // }
1500 
1501     function safeNsureTransfer(address _to, uint256 _amount) internal {
1502         require(_to != address(0),"_to is zero");
1503         uint256 nsureBal = nsure.balanceOf(address(this));
1504         if (_amount > nsureBal) {
1505             // nsure.transfer(_to, nsureBal);
1506             nsure.transfer(_to,nsureBal);
1507         } else {
1508             // nsure.transfer(_to, _amount);
1509             nsure.transfer(_to,_amount);
1510         }
1511     }
1512     
1513      function getChainId() internal pure returns (uint256) {
1514         uint256 chainId;
1515         assembly {
1516             chainId := chainid()
1517         }
1518         return chainId;
1519     }
1520     
1521 
1522     ////////////  event definitions  ////////////
1523     event Claim(address indexed user,uint256 pid,uint256 amount);
1524     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1525     event DepositSign(address indexed user, uint256 indexed pid, uint256 amount, uint256 nonce);
1526     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1527     event Unstake(address indexed user,uint256 pid, uint256 amount,uint256 nonce);
1528     event UpdateBlockReward(uint256 reward);
1529     event UpdateWithdrawPending(uint256 duration);
1530     event Add(uint256 point, IERC20 token, bool update);
1531     event Set(uint256 pid, uint256 point, bool update);
1532     event SwitchDeposit(bool swi);
1533     event SetUserCapacityMax(uint256 pid,uint256 max);
1534     event SetCapacityMax(uint256 pid, uint256 max);
1535     event eSetOperator(address indexed operator);
1536     event eSetSigner(address indexed signer);
1537     // event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1538 }