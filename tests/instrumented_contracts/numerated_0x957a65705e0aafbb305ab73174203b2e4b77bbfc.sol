1 // * SPDX-License-Identifier: GPL-3.0-or-later
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 
6 pragma solidity ^0.6.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
30 
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/math/SafeMath.sol
109 
110 
111 pragma solidity ^0.6.0;
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      *
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      *
183      * - Multiplication cannot overflow.
184      */
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
187         // benefit is lost if 'b' is also tested.
188         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
189         if (a == 0) {
190             return 0;
191         }
192 
193         uint256 c = a * b;
194         require(c / a == b, "SafeMath: multiplication overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return mod(a, b, "SafeMath: modulo by zero");
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts with custom message when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/utils/Address.sol
270 
271 
272 pragma solidity ^0.6.2;
273 
274 /**
275  * @dev Collection of functions related to the address type
276  */
277 library Address {
278     /**
279      * @dev Returns true if `account` is a contract.
280      *
281      * [IMPORTANT]
282      * ====
283      * It is unsafe to assume that an address for which this function returns
284      * false is an externally-owned account (EOA) and not a contract.
285      *
286      * Among others, `isContract` will return false for the following
287      * types of addresses:
288      *
289      *  - an externally-owned account
290      *  - a contract in construction
291      *  - an address where a contract will be created
292      *  - an address where a contract lived, but was destroyed
293      * ====
294      */
295     function isContract(address account) internal view returns (bool) {
296         // This method relies in extcodesize, which returns 0 for contracts in
297         // construction, since the code is only stored at the end of the
298         // constructor execution.
299 
300         uint256 size;
301         // solhint-disable-next-line no-inline-assembly
302         assembly { size := extcodesize(account) }
303         return size > 0;
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
326         (bool success, ) = recipient.call{ value: amount }("");
327         require(success, "Address: unable to send value, recipient may have reverted");
328     }
329 
330     /**
331      * @dev Performs a Solidity function call using a low level `call`. A
332      * plain`call` is an unsafe replacement for a function call: use this
333      * function instead.
334      *
335      * If `target` reverts with a revert reason, it is bubbled up by this
336      * function (like regular Solidity function calls).
337      *
338      * Returns the raw returned data. To convert to the expected return value,
339      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
340      *
341      * Requirements:
342      *
343      * - `target` must be a contract.
344      * - calling `target` with `data` must not revert.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
349       return functionCall(target, data, "Address: low-level call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
354      * `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
359         return _functionCallWithValue(target, data, 0, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but also transferring `value` wei to `target`.
365      *
366      * Requirements:
367      *
368      * - the calling contract must have an ETH balance of at least `value`.
369      * - the called Solidity function must be `payable`.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
384         require(address(this).balance >= value, "Address: insufficient balance for call");
385         return _functionCallWithValue(target, data, value, errorMessage);
386     }
387 
388     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
389         require(isContract(target), "Address: call to non-contract");
390 
391         // solhint-disable-next-line avoid-low-level-calls
392         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
393         if (success) {
394             return returndata;
395         } else {
396             // Look for revert reason and bubble it up if present
397             if (returndata.length > 0) {
398                 // The easiest way to bubble the revert reason is using memory via assembly
399 
400                 // solhint-disable-next-line no-inline-assembly
401                 assembly {
402                     let returndata_size := mload(returndata)
403                     revert(add(32, returndata), returndata_size)
404                 }
405             } else {
406                 revert(errorMessage);
407             }
408         }
409     }
410 }
411 
412 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
413 
414 
415 pragma solidity ^0.6.0;
416 
417 
418 
419 
420 
421 /**
422  * @dev Implementation of the {IERC20} interface.
423  *
424  * This implementation is agnostic to the way tokens are created. This means
425  * that a supply mechanism has to be added in a derived contract using {_mint}.
426  * For a generic mechanism see {ERC20PresetMinterPauser}.
427  *
428  * TIP: For a detailed writeup see our guide
429  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
430  * to implement supply mechanisms].
431  *
432  * We have followed general OpenZeppelin guidelines: functions revert instead
433  * of returning `false` on failure. This behavior is nonetheless conventional
434  * and does not conflict with the expectations of ERC20 applications.
435  *
436  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
437  * This allows applications to reconstruct the allowance for all accounts just
438  * by listening to said events. Other implementations of the EIP may not emit
439  * these events, as it isn't required by the specification.
440  *
441  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
442  * functions have been added to mitigate the well-known issues around setting
443  * allowances. See {IERC20-approve}.
444  */
445 contract ERC20 is Context, IERC20 {
446     using SafeMath for uint256;
447     using Address for address;
448 
449     mapping (address => uint256) private _balances;
450 
451     mapping (address => mapping (address => uint256)) private _allowances;
452 
453     uint256 private _totalSupply;
454 
455     string private _name;
456     string private _symbol;
457     uint8 private _decimals;
458 
459     /**
460      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
461      * a default value of 18.
462      *
463      * To select a different value for {decimals}, use {_setupDecimals}.
464      *
465      * All three of these values are immutable: they can only be set once during
466      * construction.
467      */
468     constructor (string memory name, string memory symbol) public {
469         _name = name;
470         _symbol = symbol;
471         _decimals = 18;
472     }
473 
474     /**
475      * @dev Returns the name of the token.
476      */
477     function name() public view returns (string memory) {
478         return _name;
479     }
480 
481     /**
482      * @dev Returns the symbol of the token, usually a shorter version of the
483      * name.
484      */
485     function symbol() public view returns (string memory) {
486         return _symbol;
487     }
488 
489     /**
490      * @dev Returns the number of decimals used to get its user representation.
491      * For example, if `decimals` equals `2`, a balance of `505` tokens should
492      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
493      *
494      * Tokens usually opt for a value of 18, imitating the relationship between
495      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
496      * called.
497      *
498      * NOTE: This information is only used for _display_ purposes: it in
499      * no way affects any of the arithmetic of the contract, including
500      * {IERC20-balanceOf} and {IERC20-transfer}.
501      */
502     function decimals() public view returns (uint8) {
503         return _decimals;
504     }
505 
506     /**
507      * @dev See {IERC20-totalSupply}.
508      */
509     function totalSupply() public view override returns (uint256) {
510         return _totalSupply;
511     }
512 
513     /**
514      * @dev See {IERC20-balanceOf}.
515      */
516     function balanceOf(address account) public view override returns (uint256) {
517         return _balances[account];
518     }
519 
520     /**
521      * @dev See {IERC20-transfer}.
522      *
523      * Requirements:
524      *
525      * - `recipient` cannot be the zero address.
526      * - the caller must have a balance of at least `amount`.
527      */
528     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
529         _transfer(_msgSender(), recipient, amount);
530         return true;
531     }
532 
533     /**
534      * @dev See {IERC20-allowance}.
535      */
536     function allowance(address owner, address spender) public view virtual override returns (uint256) {
537         return _allowances[owner][spender];
538     }
539 
540     /**
541      * @dev See {IERC20-approve}.
542      *
543      * Requirements:
544      *
545      * - `spender` cannot be the zero address.
546      */
547     function approve(address spender, uint256 amount) public virtual override returns (bool) {
548         _approve(_msgSender(), spender, amount);
549         return true;
550     }
551 
552     /**
553      * @dev See {IERC20-transferFrom}.
554      *
555      * Emits an {Approval} event indicating the updated allowance. This is not
556      * required by the EIP. See the note at the beginning of {ERC20};
557      *
558      * Requirements:
559      * - `sender` and `recipient` cannot be the zero address.
560      * - `sender` must have a balance of at least `amount`.
561      * - the caller must have allowance for ``sender``'s tokens of at least
562      * `amount`.
563      */
564     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
565         _transfer(sender, recipient, amount);
566         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
567         return true;
568     }
569 
570     /**
571      * @dev Atomically increases the allowance granted to `spender` by the caller.
572      *
573      * This is an alternative to {approve} that can be used as a mitigation for
574      * problems described in {IERC20-approve}.
575      *
576      * Emits an {Approval} event indicating the updated allowance.
577      *
578      * Requirements:
579      *
580      * - `spender` cannot be the zero address.
581      */
582     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
583         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
584         return true;
585     }
586 
587     /**
588      * @dev Atomically decreases the allowance granted to `spender` by the caller.
589      *
590      * This is an alternative to {approve} that can be used as a mitigation for
591      * problems described in {IERC20-approve}.
592      *
593      * Emits an {Approval} event indicating the updated allowance.
594      *
595      * Requirements:
596      *
597      * - `spender` cannot be the zero address.
598      * - `spender` must have allowance for the caller of at least
599      * `subtractedValue`.
600      */
601     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
602         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
603         return true;
604     }
605 
606     /**
607      * @dev Moves tokens `amount` from `sender` to `recipient`.
608      *
609      * This is internal function is equivalent to {transfer}, and can be used to
610      * e.g. implement automatic token fees, slashing mechanisms, etc.
611      *
612      * Emits a {Transfer} event.
613      *
614      * Requirements:
615      *
616      * - `sender` cannot be the zero address.
617      * - `recipient` cannot be the zero address.
618      * - `sender` must have a balance of at least `amount`.
619      */
620     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
621         require(sender != address(0), "ERC20: transfer from the zero address");
622         require(recipient != address(0), "ERC20: transfer to the zero address");
623 
624         _beforeTokenTransfer(sender, recipient, amount);
625 
626         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
627         _balances[recipient] = _balances[recipient].add(amount);
628         emit Transfer(sender, recipient, amount);
629     }
630 
631     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
632      * the total supply.
633      *
634      * Emits a {Transfer} event with `from` set to the zero address.
635      *
636      * Requirements
637      *
638      * - `to` cannot be the zero address.
639      */
640     function _mint(address account, uint256 amount) internal virtual {
641         require(account != address(0), "ERC20: mint to the zero address");
642 
643         _beforeTokenTransfer(address(0), account, amount);
644 
645         _totalSupply = _totalSupply.add(amount);
646         _balances[account] = _balances[account].add(amount);
647         emit Transfer(address(0), account, amount);
648     }
649 
650     /**
651      * @dev Destroys `amount` tokens from `account`, reducing the
652      * total supply.
653      *
654      * Emits a {Transfer} event with `to` set to the zero address.
655      *
656      * Requirements
657      *
658      * - `account` cannot be the zero address.
659      * - `account` must have at least `amount` tokens.
660      */
661     function _burn(address account, uint256 amount) internal virtual {
662         require(account != address(0), "ERC20: burn from the zero address");
663 
664         _beforeTokenTransfer(account, address(0), amount);
665 
666         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
667         _totalSupply = _totalSupply.sub(amount);
668         emit Transfer(account, address(0), amount);
669     }
670 
671     /**
672      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
673      *
674      * This internal function is equivalent to `approve`, and can be used to
675      * e.g. set automatic allowances for certain subsystems, etc.
676      *
677      * Emits an {Approval} event.
678      *
679      * Requirements:
680      *
681      * - `owner` cannot be the zero address.
682      * - `spender` cannot be the zero address.
683      */
684     function _approve(address owner, address spender, uint256 amount) internal virtual {
685         require(owner != address(0), "ERC20: approve from the zero address");
686         require(spender != address(0), "ERC20: approve to the zero address");
687 
688         _allowances[owner][spender] = amount;
689         emit Approval(owner, spender, amount);
690     }
691 
692     /**
693      * @dev Sets {decimals} to a value other than the default one of 18.
694      *
695      * WARNING: This function should only be called from the constructor. Most
696      * applications that interact with token contracts will not expect
697      * {decimals} to ever change, and may work incorrectly if it does.
698      */
699     function _setupDecimals(uint8 decimals_) internal {
700         _decimals = decimals_;
701     }
702 
703     /**
704      * @dev Hook that is called before any transfer of tokens. This includes
705      * minting and burning.
706      *
707      * Calling conditions:
708      *
709      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
710      * will be to transferred to `to`.
711      * - when `from` is zero, `amount` tokens will be minted for `to`.
712      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
713      * - `from` and `to` are never both zero.
714      *
715      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
716      */
717     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
718 }
719 
720 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
721 
722 
723 pragma solidity ^0.6.0;
724 
725 
726 
727 
728 /**
729  * @title SafeERC20
730  * @dev Wrappers around ERC20 operations that throw on failure (when the token
731  * contract returns false). Tokens that return no value (and instead revert or
732  * throw on failure) are also supported, non-reverting calls are assumed to be
733  * successful.
734  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
735  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
736  */
737 library SafeERC20 {
738     using SafeMath for uint256;
739     using Address for address;
740 
741     function safeTransfer(IERC20 token, address to, uint256 value) internal {
742         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
743     }
744 
745     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
746         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
747     }
748 
749     /**
750      * @dev Deprecated. This function has issues similar to the ones found in
751      * {IERC20-approve}, and its usage is discouraged.
752      *
753      * Whenever possible, use {safeIncreaseAllowance} and
754      * {safeDecreaseAllowance} instead.
755      */
756     function safeApprove(IERC20 token, address spender, uint256 value) internal {
757         // safeApprove should only be called when setting an initial allowance,
758         // or when resetting it to zero. To increase and decrease it, use
759         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
760         // solhint-disable-next-line max-line-length
761         require((value == 0) || (token.allowance(address(this), spender) == 0),
762             "SafeERC20: approve from non-zero to non-zero allowance"
763         );
764         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
765     }
766 
767     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
768         uint256 newAllowance = token.allowance(address(this), spender).add(value);
769         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
770     }
771 
772     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
773         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
774         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
775     }
776 
777     /**
778      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
779      * on the return value: the return value is optional (but if data is returned, it must not be false).
780      * @param token The token targeted by the call.
781      * @param data The call data (encoded using abi.encode or one of its variants).
782      */
783     function _callOptionalReturn(IERC20 token, bytes memory data) private {
784         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
785         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
786         // the target address contains contract code and also asserts for success in the low-level call.
787 
788         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
789         if (returndata.length > 0) { // Return data is optional
790             // solhint-disable-next-line max-line-length
791             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
792         }
793     }
794 }
795 
796 // File: @openzeppelin/contracts/access/Ownable.sol
797 
798 
799 pragma solidity ^0.6.0;
800 
801 /**
802  * @dev Contract module which provides a basic access control mechanism, where
803  * there is an account (an owner) that can be granted exclusive access to
804  * specific functions.
805  *
806  * By default, the owner account will be the one that deploys the contract. This
807  * can later be changed with {transferOwnership}.
808  *
809  * This module is used through inheritance. It will make available the modifier
810  * `onlyOwner`, which can be applied to your functions to restrict their use to
811  * the owner.
812  */
813 contract Ownable is Context {
814     address private _owner;
815 
816     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
817 
818     /**
819      * @dev Initializes the contract setting the deployer as the initial owner.
820      */
821     constructor () internal {
822         address msgSender = _msgSender();
823         _owner = msgSender;
824         emit OwnershipTransferred(address(0), msgSender);
825     }
826 
827     /**
828      * @dev Returns the address of the current owner.
829      */
830     function owner() public view returns (address) {
831         return _owner;
832     }
833 
834     /**
835      * @dev Throws if called by any account other than the owner.
836      */
837     modifier onlyOwner() {
838         require(_owner == _msgSender(), "Ownable: caller is not the owner");
839         _;
840     }
841 
842     /**
843      * @dev Leaves the contract without owner. It will not be possible to call
844      * `onlyOwner` functions anymore. Can only be called by the current owner.
845      *
846      * NOTE: Renouncing ownership will leave the contract without an owner,
847      * thereby removing any functionality that is only available to the owner.
848      */
849     function renounceOwnership() public virtual onlyOwner {
850         emit OwnershipTransferred(_owner, address(0));
851         _owner = address(0);
852     }
853 
854     /**
855      * @dev Transfers ownership of the contract to a new account (`newOwner`).
856      * Can only be called by the current owner.
857      */
858     function transferOwnership(address newOwner) public virtual onlyOwner {
859         require(newOwner != address(0), "Ownable: new owner is the zero address");
860         emit OwnershipTransferred(_owner, newOwner);
861         _owner = newOwner;
862     }
863 }
864 
865 // File: @chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol
866 
867 pragma solidity >=0.6.0;
868 
869 interface AggregatorV3Interface {
870   function decimals() external view returns (uint8);
871   function description() external view returns (string memory);
872   function version() external view returns (uint256);
873 
874   // getRoundData and latestRoundData should both raise "No data present"
875   // if they do not have data to report, instead of returning unset values
876   // which could be misinterpreted as actual reported values.
877   function getRoundData(uint80 _roundId)
878     external
879     view
880     returns (
881       uint80 roundId,
882       int256 answer,
883       uint256 startedAt,
884       uint256 updatedAt,
885       uint80 answeredInRound
886     );
887   function latestRoundData()
888     external
889     view
890     returns (
891       uint80 roundId,
892       int256 answer,
893       uint256 startedAt,
894       uint256 updatedAt,
895       uint80 answeredInRound
896     );
897 }
898 
899 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
900 
901 pragma solidity >=0.6.2;
902 
903 interface IUniswapV2Router01 {
904     function factory() external pure returns (address);
905     function WETH() external pure returns (address);
906 
907     function addLiquidity(
908         address tokenA,
909         address tokenB,
910         uint amountADesired,
911         uint amountBDesired,
912         uint amountAMin,
913         uint amountBMin,
914         address to,
915         uint deadline
916     ) external returns (uint amountA, uint amountB, uint liquidity);
917     function addLiquidityETH(
918         address token,
919         uint amountTokenDesired,
920         uint amountTokenMin,
921         uint amountETHMin,
922         address to,
923         uint deadline
924     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
925     function removeLiquidity(
926         address tokenA,
927         address tokenB,
928         uint liquidity,
929         uint amountAMin,
930         uint amountBMin,
931         address to,
932         uint deadline
933     ) external returns (uint amountA, uint amountB);
934     function removeLiquidityETH(
935         address token,
936         uint liquidity,
937         uint amountTokenMin,
938         uint amountETHMin,
939         address to,
940         uint deadline
941     ) external returns (uint amountToken, uint amountETH);
942     function removeLiquidityWithPermit(
943         address tokenA,
944         address tokenB,
945         uint liquidity,
946         uint amountAMin,
947         uint amountBMin,
948         address to,
949         uint deadline,
950         bool approveMax, uint8 v, bytes32 r, bytes32 s
951     ) external returns (uint amountA, uint amountB);
952     function removeLiquidityETHWithPermit(
953         address token,
954         uint liquidity,
955         uint amountTokenMin,
956         uint amountETHMin,
957         address to,
958         uint deadline,
959         bool approveMax, uint8 v, bytes32 r, bytes32 s
960     ) external returns (uint amountToken, uint amountETH);
961     function swapExactTokensForTokens(
962         uint amountIn,
963         uint amountOutMin,
964         address[] calldata path,
965         address to,
966         uint deadline
967     ) external returns (uint[] memory amounts);
968     function swapTokensForExactTokens(
969         uint amountOut,
970         uint amountInMax,
971         address[] calldata path,
972         address to,
973         uint deadline
974     ) external returns (uint[] memory amounts);
975     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
976         external
977         payable
978         returns (uint[] memory amounts);
979     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
980         external
981         returns (uint[] memory amounts);
982     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
983         external
984         returns (uint[] memory amounts);
985     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
986         external
987         payable
988         returns (uint[] memory amounts);
989 
990     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
991     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
992     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
993     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
994     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
995 }
996 
997 // File: contracts/Interfaces/Interfaces.sol
998 
999 pragma solidity 0.6.12;
1000 
1001 /**
1002  * Hegic
1003  * Copyright (C) 2020 Hegic Protocol
1004  *
1005  * This program is free software: you can redistribute it and/or modify
1006  * it under the terms of the GNU General Public License as published by
1007  * the Free Software Foundation, either version 3 of the License, or
1008  * (at your option) any later version.
1009  *
1010  * This program is distributed in the hope that it will be useful,
1011  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1012  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1013  * GNU General Public License for more details.
1014  *
1015  * You should have received a copy of the GNU General Public License
1016  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1017  */
1018 
1019 
1020 
1021 
1022 
1023 
1024 
1025 interface ILiquidityPool {
1026     struct LockedLiquidity { uint amount; uint premium; bool locked; }
1027 
1028     event Profit(uint indexed id, uint amount);
1029     event Loss(uint indexed id, uint amount);
1030     event Provide(address indexed account, uint256 amount, uint256 writeAmount);
1031     event Withdraw(address indexed account, uint256 amount, uint256 writeAmount);
1032 
1033     function unlock(uint256 id) external;
1034     function send(uint256 id, address payable account, uint256 amount) external;
1035     function setLockupPeriod(uint value) external;
1036     function totalBalance() external view returns (uint256 amount);
1037     // function unlockPremium(uint256 amount) external;
1038 }
1039 
1040 
1041 interface IERCLiquidityPool is ILiquidityPool {
1042     function lock(uint id, uint256 amount, uint premium) external;
1043     function token() external view returns (IERC20);
1044 }
1045 
1046 
1047 interface IETHLiquidityPool is ILiquidityPool {
1048     function lock(uint id, uint256 amount) external payable;
1049 }
1050 
1051 
1052 interface IHegicStaking {    
1053     event Claim(address indexed acount, uint amount);
1054     event Profit(uint amount);
1055 
1056 
1057     function claimProfit() external returns (uint profit);
1058     function buy(uint amount) external;
1059     function sell(uint amount) external;
1060     function profitOf(address account) external view returns (uint);
1061 }
1062 
1063 
1064 interface IHegicStakingETH is IHegicStaking {
1065     function sendProfit() external payable;
1066 }
1067 
1068 
1069 interface IHegicStakingERC20 is IHegicStaking {
1070     function sendProfit(uint amount) external;
1071 }
1072 
1073 
1074 interface IHegicOptions {
1075     event Create(
1076         uint256 indexed id,
1077         address indexed account,
1078         uint256 settlementFee,
1079         uint256 totalFee
1080     );
1081 
1082     event Exercise(uint256 indexed id, uint256 profit);
1083     event Expire(uint256 indexed id, uint256 premium);
1084     enum State {Inactive, Active, Exercised, Expired}
1085     enum OptionType {Invalid, Put, Call}
1086 
1087     struct Option {
1088         State state;
1089         address payable holder;
1090         uint256 strike;
1091         uint256 amount;
1092         uint256 lockedAmount;
1093         uint256 premium;
1094         uint256 expiration;
1095         OptionType optionType;
1096     }
1097 
1098     function options(uint) external view returns (
1099         State state,
1100         address payable holder,
1101         uint256 strike,
1102         uint256 amount,
1103         uint256 lockedAmount,
1104         uint256 premium,
1105         uint256 expiration,
1106         OptionType optionType
1107     );
1108 }
1109 
1110 // For the future integrations of non-standard ERC20 tokens such as USDT and others
1111 // interface ERC20Incorrect {
1112 //     event Transfer(address indexed from, address indexed to, uint256 value);
1113 //
1114 //     event Approval(address indexed owner, address indexed spender, uint256 value);
1115 //
1116 //     function transfer(address to, uint256 value) external;
1117 //
1118 //     function transferFrom(
1119 //         address from,
1120 //         address to,
1121 //         uint256 value
1122 //     ) external;
1123 //
1124 //     function approve(address spender, uint256 value) external;
1125 //     function balanceOf(address who) external view returns (uint256);
1126 //     function allowance(address owner, address spender) external view returns (uint256);
1127 //
1128 // }
1129 
1130 // File: contracts/Rewards/HegicRewards.sol
1131 
1132 pragma solidity 0.6.12;
1133 
1134 /**
1135  * Hegic
1136  * Copyright (C) 2020 Hegic Protocol
1137  *
1138  * This program is free software: you can redistribute it and/or modify
1139  * it under the terms of the GNU General Public License as published by
1140  * the Free Software Foundation, either version 3 of the License, or
1141  * (at your option) any later version.
1142  *
1143  * This program is distributed in the hope that it will be useful,
1144  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1145  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1146  * GNU General Public License for more details.
1147  *
1148  * You should have received a copy of the GNU General Public License
1149  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1150  */
1151 
1152 
1153 
1154 abstract
1155 contract HegicRewards is Ownable {
1156     using SafeMath for uint;
1157     using SafeERC20 for IERC20;
1158 
1159     IHegicOptions public immutable hegicOptions;
1160     IERC20 public immutable hegic;
1161     mapping(uint => bool) public rewardedOptions;
1162     mapping(uint => uint) public dailyReward;
1163     uint internal constant MAX_DAILY_REWARD = 165_000e18;
1164     uint internal constant REWARD_RATE_ACCURACY = 1e8;
1165     uint internal immutable MAX_REWARDS_RATE;
1166     uint internal immutable MIN_REWARDS_RATE;
1167     uint internal immutable FIRST_OPTION_ID;
1168     uint public rewardsRate;
1169 
1170     constructor(
1171         IHegicOptions _hegicOptions,
1172         IERC20 _hegic,
1173         uint maxRewardsRate,
1174         uint minRewardsRate,
1175         uint firstOptionID
1176     ) public {
1177         hegicOptions = _hegicOptions;
1178         hegic = _hegic;
1179         MAX_REWARDS_RATE = maxRewardsRate;
1180         MIN_REWARDS_RATE = minRewardsRate;
1181         rewardsRate = maxRewardsRate;
1182         FIRST_OPTION_ID = firstOptionID;
1183     }
1184 
1185     function getReward(uint optionId) external {
1186         uint amount = rewardAmount(optionId);
1187         uint today = block.timestamp / 1 days;
1188         dailyReward[today] = dailyReward[today].add(amount);
1189 
1190         (IHegicOptions.State state, address holder, , , , , , ) =
1191             hegicOptions.options(optionId);
1192         require(optionId >= FIRST_OPTION_ID, "Wrong Option ID");
1193         require(state != IHegicOptions.State.Inactive, "The option is inactive");
1194         require(!rewardedOptions[optionId], "The option was rewarded");
1195         require(
1196             dailyReward[today] < MAX_DAILY_REWARD,
1197             "Exceeds daily limits"
1198         );
1199         rewardedOptions[optionId] = true;
1200         hegic.safeTransfer(holder, amount);
1201     }
1202 
1203     function setRewardsRate(uint value) external onlyOwner {
1204         require(MIN_REWARDS_RATE <= value && value <= MAX_REWARDS_RATE);
1205         rewardsRate = value;
1206     }
1207 
1208     function rewardAmount(uint optionId) internal view returns (uint) {
1209         (, , , uint _amount, , uint _premium, , ) = hegicOptions.options(optionId);
1210         return _amount.div(100).add(_premium)
1211             .mul(rewardsRate)
1212             .div(REWARD_RATE_ACCURACY);
1213     }
1214 }
1215 
1216 // File: contracts/Rewards/HegicETHRewards.sol
1217 
1218 pragma solidity 0.6.12;
1219 
1220 /**
1221  * Hegic
1222  * Copyright (C) 2020 Hegic Protocol
1223  *
1224  * This program is free software: you can redistribute it and/or modify
1225  * it under the terms of the GNU General Public License as published by
1226  * the Free Software Foundation, either version 3 of the License, or
1227  * (at your option) any later version.
1228  *
1229  * This program is distributed in the hope that it will be useful,
1230  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1231  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1232  * GNU General Public License for more details.
1233  *
1234  * You should have received a copy of the GNU General Public License
1235  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1236  */
1237 
1238 
1239 
1240 contract HegicETHRewards is HegicRewards {
1241     constructor(
1242         IHegicOptions _hegicOptions,
1243         IERC20 _hegic
1244     ) public HegicRewards(
1245         _hegicOptions,
1246         _hegic,
1247         1_000_000e8,
1248         10e8,
1249         168
1250     ) {}
1251 }