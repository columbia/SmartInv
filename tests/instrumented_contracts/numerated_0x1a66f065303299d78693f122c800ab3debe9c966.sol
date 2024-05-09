1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
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
83 
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
245 
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
389 
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
416 
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
725 
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
794 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
795 
796 
797 
798 pragma solidity ^0.6.0;
799 
800 
801 
802 
803 /**
804  * @title SafeERC20
805  * @dev Wrappers around ERC20 operations that throw on failure (when the token
806  * contract returns false). Tokens that return no value (and instead revert or
807  * throw on failure) are also supported, non-reverting calls are assumed to be
808  * successful.
809  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
810  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
811  */
812 library SafeERC20 {
813     using SafeMath for uint256;
814     using Address for address;
815 
816     function safeTransfer(IERC20 token, address to, uint256 value) internal {
817         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
818     }
819 
820     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
821         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
822     }
823 
824     /**
825      * @dev Deprecated. This function has issues similar to the ones found in
826      * {IERC20-approve}, and its usage is discouraged.
827      *
828      * Whenever possible, use {safeIncreaseAllowance} and
829      * {safeDecreaseAllowance} instead.
830      */
831     function safeApprove(IERC20 token, address spender, uint256 value) internal {
832         // safeApprove should only be called when setting an initial allowance,
833         // or when resetting it to zero. To increase and decrease it, use
834         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
835         // solhint-disable-next-line max-line-length
836         require((value == 0) || (token.allowance(address(this), spender) == 0),
837             "SafeERC20: approve from non-zero to non-zero allowance"
838         );
839         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
840     }
841 
842     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
843         uint256 newAllowance = token.allowance(address(this), spender).add(value);
844         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
845     }
846 
847     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
848         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
849         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
850     }
851 
852     /**
853      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
854      * on the return value: the return value is optional (but if data is returned, it must not be false).
855      * @param token The token targeted by the call.
856      * @param data The call data (encoded using abi.encode or one of its variants).
857      */
858     function _callOptionalReturn(IERC20 token, bytes memory data) private {
859         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
860         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
861         // the target address contains contract code and also asserts for success in the low-level call.
862 
863         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
864         if (returndata.length > 0) { // Return data is optional
865             // solhint-disable-next-line max-line-length
866             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
867         }
868     }
869 }
870 
871 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
872 
873 
874 
875 pragma solidity ^0.6.0;
876 
877 /**
878  * @dev Library for managing
879  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
880  * types.
881  *
882  * Sets have the following properties:
883  *
884  * - Elements are added, removed, and checked for existence in constant time
885  * (O(1)).
886  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
887  *
888  * ```
889  * contract Example {
890  *     // Add the library methods
891  *     using EnumerableSet for EnumerableSet.AddressSet;
892  *
893  *     // Declare a set state variable
894  *     EnumerableSet.AddressSet private mySet;
895  * }
896  * ```
897  *
898  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
899  * (`UintSet`) are supported.
900  */
901 library EnumerableSet {
902     // To implement this library for multiple types with as little code
903     // repetition as possible, we write it in terms of a generic Set type with
904     // bytes32 values.
905     // The Set implementation uses private functions, and user-facing
906     // implementations (such as AddressSet) are just wrappers around the
907     // underlying Set.
908     // This means that we can only create new EnumerableSets for types that fit
909     // in bytes32.
910 
911     struct Set {
912         // Storage of set values
913         bytes32[] _values;
914 
915         // Position of the value in the `values` array, plus 1 because index 0
916         // means a value is not in the set.
917         mapping (bytes32 => uint256) _indexes;
918     }
919 
920     /**
921      * @dev Add a value to a set. O(1).
922      *
923      * Returns true if the value was added to the set, that is if it was not
924      * already present.
925      */
926     function _add(Set storage set, bytes32 value) private returns (bool) {
927         if (!_contains(set, value)) {
928             set._values.push(value);
929             // The value is stored at length-1, but we add 1 to all indexes
930             // and use 0 as a sentinel value
931             set._indexes[value] = set._values.length;
932             return true;
933         } else {
934             return false;
935         }
936     }
937 
938     /**
939      * @dev Removes a value from a set. O(1).
940      *
941      * Returns true if the value was removed from the set, that is if it was
942      * present.
943      */
944     function _remove(Set storage set, bytes32 value) private returns (bool) {
945         // We read and store the value's index to prevent multiple reads from the same storage slot
946         uint256 valueIndex = set._indexes[value];
947 
948         if (valueIndex != 0) { // Equivalent to contains(set, value)
949             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
950             // the array, and then remove the last element (sometimes called as 'swap and pop').
951             // This modifies the order of the array, as noted in {at}.
952 
953             uint256 toDeleteIndex = valueIndex - 1;
954             uint256 lastIndex = set._values.length - 1;
955 
956             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
957             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
958 
959             bytes32 lastvalue = set._values[lastIndex];
960 
961             // Move the last value to the index where the value to delete is
962             set._values[toDeleteIndex] = lastvalue;
963             // Update the index for the moved value
964             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
965 
966             // Delete the slot where the moved value was stored
967             set._values.pop();
968 
969             // Delete the index for the deleted slot
970             delete set._indexes[value];
971 
972             return true;
973         } else {
974             return false;
975         }
976     }
977 
978     /**
979      * @dev Returns true if the value is in the set. O(1).
980      */
981     function _contains(Set storage set, bytes32 value) private view returns (bool) {
982         return set._indexes[value] != 0;
983     }
984 
985     /**
986      * @dev Returns the number of values on the set. O(1).
987      */
988     function _length(Set storage set) private view returns (uint256) {
989         return set._values.length;
990     }
991 
992    /**
993     * @dev Returns the value stored at position `index` in the set. O(1).
994     *
995     * Note that there are no guarantees on the ordering of values inside the
996     * array, and it may change when more values are added or removed.
997     *
998     * Requirements:
999     *
1000     * - `index` must be strictly less than {length}.
1001     */
1002     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1003         require(set._values.length > index, "EnumerableSet: index out of bounds");
1004         return set._values[index];
1005     }
1006 
1007     // AddressSet
1008 
1009     struct AddressSet {
1010         Set _inner;
1011     }
1012 
1013     /**
1014      * @dev Add a value to a set. O(1).
1015      *
1016      * Returns true if the value was added to the set, that is if it was not
1017      * already present.
1018      */
1019     function add(AddressSet storage set, address value) internal returns (bool) {
1020         return _add(set._inner, bytes32(uint256(value)));
1021     }
1022 
1023     /**
1024      * @dev Removes a value from a set. O(1).
1025      *
1026      * Returns true if the value was removed from the set, that is if it was
1027      * present.
1028      */
1029     function remove(AddressSet storage set, address value) internal returns (bool) {
1030         return _remove(set._inner, bytes32(uint256(value)));
1031     }
1032 
1033     /**
1034      * @dev Returns true if the value is in the set. O(1).
1035      */
1036     function contains(AddressSet storage set, address value) internal view returns (bool) {
1037         return _contains(set._inner, bytes32(uint256(value)));
1038     }
1039 
1040     /**
1041      * @dev Returns the number of values in the set. O(1).
1042      */
1043     function length(AddressSet storage set) internal view returns (uint256) {
1044         return _length(set._inner);
1045     }
1046 
1047    /**
1048     * @dev Returns the value stored at position `index` in the set. O(1).
1049     *
1050     * Note that there are no guarantees on the ordering of values inside the
1051     * array, and it may change when more values are added or removed.
1052     *
1053     * Requirements:
1054     *
1055     * - `index` must be strictly less than {length}.
1056     */
1057     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1058         return address(uint256(_at(set._inner, index)));
1059     }
1060 
1061 
1062     // UintSet
1063 
1064     struct UintSet {
1065         Set _inner;
1066     }
1067 
1068     /**
1069      * @dev Add a value to a set. O(1).
1070      *
1071      * Returns true if the value was added to the set, that is if it was not
1072      * already present.
1073      */
1074     function add(UintSet storage set, uint256 value) internal returns (bool) {
1075         return _add(set._inner, bytes32(value));
1076     }
1077 
1078     /**
1079      * @dev Removes a value from a set. O(1).
1080      *
1081      * Returns true if the value was removed from the set, that is if it was
1082      * present.
1083      */
1084     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1085         return _remove(set._inner, bytes32(value));
1086     }
1087 
1088     /**
1089      * @dev Returns true if the value is in the set. O(1).
1090      */
1091     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1092         return _contains(set._inner, bytes32(value));
1093     }
1094 
1095     /**
1096      * @dev Returns the number of values on the set. O(1).
1097      */
1098     function length(UintSet storage set) internal view returns (uint256) {
1099         return _length(set._inner);
1100     }
1101 
1102    /**
1103     * @dev Returns the value stored at position `index` in the set. O(1).
1104     *
1105     * Note that there are no guarantees on the ordering of values inside the
1106     * array, and it may change when more values are added or removed.
1107     *
1108     * Requirements:
1109     *
1110     * - `index` must be strictly less than {length}.
1111     */
1112     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1113         return uint256(_at(set._inner, index));
1114     }
1115 }
1116 
1117 // File: @openzeppelin/contracts/math/Math.sol
1118 
1119 
1120 
1121 pragma solidity ^0.6.0;
1122 
1123 /**
1124  * @dev Standard math utilities missing in the Solidity language.
1125  */
1126 library Math {
1127     /**
1128      * @dev Returns the largest of two numbers.
1129      */
1130     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1131         return a >= b ? a : b;
1132     }
1133 
1134     /**
1135      * @dev Returns the smallest of two numbers.
1136      */
1137     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1138         return a < b ? a : b;
1139     }
1140 
1141     /**
1142      * @dev Returns the average of two numbers. The result is rounded towards
1143      * zero.
1144      */
1145     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1146         // (a + b) / 2 can overflow, so we distribute
1147         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1148     }
1149 }
1150 
1151 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
1152 
1153 
1154 
1155 pragma solidity ^0.6.0;
1156 
1157 /**
1158  * @dev Contract module that helps prevent reentrant calls to a function.
1159  *
1160  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1161  * available, which can be applied to functions to make sure there are no nested
1162  * (reentrant) calls to them.
1163  *
1164  * Note that because there is a single `nonReentrant` guard, functions marked as
1165  * `nonReentrant` may not call one another. This can be worked around by making
1166  * those functions `private`, and then adding `external` `nonReentrant` entry
1167  * points to them.
1168  *
1169  * TIP: If you would like to learn more about reentrancy and alternative ways
1170  * to protect against it, check out our blog post
1171  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1172  */
1173 contract ReentrancyGuard {
1174     // Booleans are more expensive than uint256 or any type that takes up a full
1175     // word because each write operation emits an extra SLOAD to first read the
1176     // slot's contents, replace the bits taken up by the boolean, and then write
1177     // back. This is the compiler's defense against contract upgrades and
1178     // pointer aliasing, and it cannot be disabled.
1179 
1180     // The values being non-zero value makes deployment a bit more expensive,
1181     // but in exchange the refund on every call to nonReentrant will be lower in
1182     // amount. Since refunds are capped to a percentage of the total
1183     // transaction's gas, it is best to keep them low in cases like this one, to
1184     // increase the likelihood of the full refund coming into effect.
1185     uint256 private constant _NOT_ENTERED = 1;
1186     uint256 private constant _ENTERED = 2;
1187 
1188     uint256 private _status;
1189 
1190     constructor () internal {
1191         _status = _NOT_ENTERED;
1192     }
1193 
1194     /**
1195      * @dev Prevents a contract from calling itself, directly or indirectly.
1196      * Calling a `nonReentrant` function from another `nonReentrant`
1197      * function is not supported. It is possible to prevent this from happening
1198      * by making the `nonReentrant` function external, and make it call a
1199      * `private` function that does the actual work.
1200      */
1201     modifier nonReentrant() {
1202         // On the first call to nonReentrant, _notEntered will be true
1203         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1204 
1205         // Any calls to nonReentrant after this point will fail
1206         _status = _ENTERED;
1207 
1208         _;
1209 
1210         // By storing the original value once again, a refund is triggered (see
1211         // https://eips.ethereum.org/EIPS/eip-2200)
1212         _status = _NOT_ENTERED;
1213     }
1214 }
1215 
1216 // File: contracts/interfaces/INsure.sol
1217 
1218 pragma solidity ^0.6.0;
1219 pragma experimental ABIEncoderV2;
1220 interface INsure {
1221 
1222     function burn(uint256 amount)  external ;
1223     function transfer(address recipient, uint256 amount) external returns (bool);
1224     function transferFrom(address sender, address recipient, uint256 amount) external  returns (bool);
1225     function mint(address _to, uint256 _amount) external  returns (bool);
1226     function balanceOf(address account) external view returns (uint256);
1227 }
1228 
1229 // File: contracts/Underwriting.sol
1230 
1231 /**
1232  * @dev     a contract for locking Nsure Token to be an underwriter.
1233  *   
1234  * @notice  the underwriter program would be calculated and recorded by central ways
1235             which is too complicated for contracts(gas used etc.)
1236  */
1237 
1238 
1239 
1240 
1241 
1242 
1243 
1244 
1245 
1246 
1247 
1248 
1249 pragma solidity ^0.6.0;
1250 
1251 
1252 
1253 contract Underwriting is Ownable, ReentrancyGuard{
1254     
1255     using SafeMath for uint256;
1256     using SafeERC20 for IERC20;
1257     
1258     address public signer; 
1259     string constant public name = "Stake";
1260     string public constant version = "1";
1261     
1262     uint256 public depositMax = 1000000e18;
1263     uint256 public deadlineDuration = 30 minutes;
1264     
1265     address public operator;
1266     
1267     /// @notice A record of states for signing / validating signatures
1268     mapping (address => uint256) public nonces;
1269     
1270     struct DivCurrency {
1271         address divCurrency;
1272         uint256 limit;
1273     }
1274     
1275     DivCurrency[] public divCurrencies;
1276     
1277 
1278     INsure public Nsure;
1279     uint256 private _totalSupply;
1280     uint256 public claimDuration = 30 minutes;
1281 
1282     mapping(address => uint256) private _balances;
1283     mapping(address => uint256) public claimAt;
1284 
1285    
1286 
1287     modifier onlyOperator() {
1288         require(msg.sender == operator,"not operator");
1289         _;
1290     }
1291 
1292       /// @notice The EIP-712 typehash for the contract's domain
1293     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1294 
1295  
1296     /// @notice The EIP-712 typehash for the permit struct used by the contract
1297     bytes32 public constant CLAIM_TYPEHASH = keccak256("Claim(address account,uint256 currency,uint256 amount,uint256 nonce,uint256 deadline)");
1298 
1299 
1300     /// @notice The EIP-712 typehash for the permit struct used by the contract
1301     bytes32 public constant WITHDRAW_TYPEHASH = keccak256("Withdraw(address account,uint256 amount,uint256 nonce,uint256 deadline)");
1302 
1303     constructor(address _signer, address _nsure)public {
1304         Nsure = INsure(_nsure);
1305         signer = _signer;
1306     }
1307 
1308     function totalSupply() external view returns (uint256) {
1309         return _totalSupply;
1310     }
1311 
1312     function balanceOf(address account) external view returns (uint256) {
1313         return _balances[account];
1314     }
1315 
1316     function setClaimDuration(uint256 _duration)external onlyOwner {
1317         require(claimDuration != _duration, "the same duration");
1318         claimDuration = _duration;
1319         emit SetClaimDuration(_duration);
1320     }
1321 
1322     function setSigner(address _signer) external onlyOwner {
1323         require(_signer != address(0),"_signer is zero");
1324         signer = _signer;
1325         emit SetSigner(_signer);
1326     }
1327  
1328     function setOperator(address _operator) external onlyOwner {  
1329         require(_operator != address(0),"_operator is zero"); 
1330         operator = _operator;
1331         emit SetOperator(_operator);
1332     }
1333 
1334     function setDeadlineDuration(uint256 _duration) external onlyOwner {
1335         deadlineDuration = _duration;
1336         emit SetDeadlineDuration(_duration);
1337     }
1338  
1339     function getDivCurrencyLength() external view returns (uint256) {
1340         return divCurrencies.length;
1341     }
1342 
1343     function addDivCurrency(address _currency,uint256 _limit) external onlyOwner {
1344         require(_currency != address(0),"_currency is zero");
1345         divCurrencies.push(DivCurrency({divCurrency:_currency, limit:_limit}));
1346     }
1347 
1348     function setDepositMax(uint256 _max) external onlyOwner {
1349         depositMax = _max;
1350         emit SetDepositMax(_max);
1351     }
1352 
1353     function deposit(uint256 amount) external nonReentrant{
1354         require(amount > 0, "Cannot stake 0");
1355         require(amount <= depositMax,"exceeding the maximum limit");
1356 
1357         _totalSupply = _totalSupply.add(amount);
1358         _balances[msg.sender] = _balances[msg.sender].add(amount);
1359 
1360         // Nsure.transferFrom(msg.sender, address(this), amount);
1361         Nsure.transferFrom(msg.sender,address(this),amount);
1362         emit Deposit(msg.sender, amount);
1363     }
1364 
1365     function withdraw(uint256 _amount,uint256 deadline,uint8 v, bytes32 r, bytes32 s) 
1366         external nonReentrant
1367     {
1368         require(_balances[msg.sender] >= _amount,"insufficient");
1369 
1370         bytes32 domainSeparator =   keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)),
1371                                         keccak256(bytes(version)), getChainId(), address(this)));
1372         bytes32 structHash  = keccak256(abi.encode(WITHDRAW_TYPEHASH, address(msg.sender), 
1373                                 _amount,nonces[msg.sender]++, deadline));
1374         bytes32 digest      = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1375 
1376         address signatory = ecrecover(digest, v, r, s);
1377 
1378         require(signatory != address(0), "invalid signature");
1379         require(signatory == signer, "unauthorized");
1380         require(block.timestamp <= deadline, "signature expired");
1381 
1382         _balances[msg.sender] = _balances[msg.sender].sub(_amount);
1383         Nsure.transfer(msg.sender,_amount);
1384         emit Withdraw(msg.sender,_amount,nonces[msg.sender]-1);
1385     }
1386 
1387     // burn 1/2 for claiming
1388     function burnOuts(address[] calldata _burnUsers, uint256[] calldata _amounts,uint256 _product) 
1389         external onlyOperator
1390     {
1391         require(_burnUsers.length == _amounts.length, "not equal");
1392 
1393         for(uint256 i = 0; i<_burnUsers.length; i++) {
1394             require(_balances[_burnUsers[i]] >= _amounts[i], "insufficient");
1395 
1396             _balances[_burnUsers[i]] = _balances[_burnUsers[i]].sub(_amounts[i]);
1397             Nsure.burn(_amounts[i]);
1398 
1399             emit Burn(_burnUsers[i],_amounts[i],_product);
1400         }
1401     }
1402 
1403     function claim(uint256 _amount, uint256 currency, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
1404         external nonReentrant
1405     {
1406         require(block.timestamp > claimAt[msg.sender].add(claimDuration), "wait" );
1407         require(block.timestamp.add(deadlineDuration) > deadline, "expired");
1408         require(_amount <= divCurrencies[currency].limit, "exceeding the maximum limit");
1409         require(block.timestamp <= deadline, "signature expired");
1410 
1411         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)),keccak256(bytes(version)), getChainId(), address(this)));
1412         bytes32 structHash = keccak256(abi.encode(CLAIM_TYPEHASH,address(msg.sender), currency, _amount,nonces[msg.sender]++, deadline));
1413         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1414         address signatory = ecrecover(digest, v, r, s);
1415 
1416         require(signatory != address(0), "invalid signature");
1417         require(signatory == signer, "unauthorized");
1418         
1419 
1420         claimAt[msg.sender] = block.timestamp;
1421         IERC20(divCurrencies[currency].divCurrency).safeTransfer(msg.sender,_amount);
1422 
1423         emit Claim(msg.sender,currency,_amount,nonces[msg.sender] -1);
1424     }
1425 
1426     function getChainId() internal pure returns (uint256) {
1427         uint256 chainId;
1428         assembly { chainId := chainid() }
1429         return chainId;
1430     }
1431 
1432 
1433     receive() external payable {}
1434    
1435 
1436 
1437     event Deposit(address indexed user, uint256 amount);
1438     event Withdraw(address indexed user,  uint256 amount,uint256 nonce);
1439     event Claim(address indexed user,uint256 currency,uint256 amount,uint256 nonce);
1440     event Burn(address indexed user,uint256 amount,uint256 product);
1441     event SetOperator(address indexed operator);
1442     event SetClaimDuration(uint256 duration);
1443     event SetSigner(address indexed signer);
1444     event SetDeadlineDuration(uint256 deadlineDuration);
1445     event SetDepositMax(uint256 depositMax);
1446 }