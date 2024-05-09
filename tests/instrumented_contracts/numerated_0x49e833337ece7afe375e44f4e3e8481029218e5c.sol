1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 // File: @openzeppelin/contracts/GSN/Context.sol
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 // File: @openzeppelin/contracts/math/SafeMath.sol
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      *
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      *
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 // File: @openzeppelin/contracts/utils/Address.sol
263 
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // This method relies in extcodesize, which returns 0 for contracts in
287         // construction, since the code is only stored at the end of the
288         // constructor execution.
289 
290         uint256 size;
291         // solhint-disable-next-line no-inline-assembly
292         assembly { size := extcodesize(account) }
293         return size > 0;
294     }
295 
296     /**
297      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298      * `recipient`, forwarding all available gas and reverting on errors.
299      *
300      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301      * of certain opcodes, possibly making contracts go over the 2300 gas limit
302      * imposed by `transfer`, making them unable to receive funds via
303      * `transfer`. {sendValue} removes this limitation.
304      *
305      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306      *
307      * IMPORTANT: because control is transferred to `recipient`, care must be
308      * taken to not create reentrancy vulnerabilities. Consider using
309      * {ReentrancyGuard} or the
310      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311      */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314 
315         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
316         (bool success, ) = recipient.call{ value: amount }("");
317         require(success, "Address: unable to send value, recipient may have reverted");
318     }
319 
320     /**
321      * @dev Performs a Solidity function call using a low level `call`. A
322      * plain`call` is an unsafe replacement for a function call: use this
323      * function instead.
324      *
325      * If `target` reverts with a revert reason, it is bubbled up by this
326      * function (like regular Solidity function calls).
327      *
328      * Returns the raw returned data. To convert to the expected return value,
329      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330      *
331      * Requirements:
332      *
333      * - `target` must be a contract.
334      * - calling `target` with `data` must not revert.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
339       return functionCall(target, data, "Address: low-level call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344      * `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
349         return _functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369      * with `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         return _functionCallWithValue(target, data, value, errorMessage);
376     }
377 
378     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
379         require(isContract(target), "Address: call to non-contract");
380 
381         // solhint-disable-next-line avoid-low-level-calls
382         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 // solhint-disable-next-line no-inline-assembly
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
403 
404 /**
405  * @dev Implementation of the {IERC20} interface.
406  *
407  * This implementation is agnostic to the way tokens are created. This means
408  * that a supply mechanism has to be added in a derived contract using {_mint}.
409  * For a generic mechanism see {ERC20PresetMinterPauser}.
410  *
411  * TIP: For a detailed writeup see our guide
412  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
413  * to implement supply mechanisms].
414  *
415  * We have followed general OpenZeppelin guidelines: functions revert instead
416  * of returning `false` on failure. This behavior is nonetheless conventional
417  * and does not conflict with the expectations of ERC20 applications.
418  *
419  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
420  * This allows applications to reconstruct the allowance for all accounts just
421  * by listening to said events. Other implementations of the EIP may not emit
422  * these events, as it isn't required by the specification.
423  *
424  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
425  * functions have been added to mitigate the well-known issues around setting
426  * allowances. See {IERC20-approve}.
427  */
428 contract ERC20 is Context, IERC20 {
429     using SafeMath for uint256;
430     using Address for address;
431 
432     mapping (address => uint256) private _balances;
433 
434     mapping (address => mapping (address => uint256)) private _allowances;
435 
436     uint256 private _totalSupply;
437 
438     string private _name;
439     string private _symbol;
440     uint8 private _decimals;
441 
442     /**
443      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
444      * a default value of 18.
445      *
446      * To select a different value for {decimals}, use {_setupDecimals}.
447      *
448      * All three of these values are immutable: they can only be set once during
449      * construction.
450      */
451     constructor (string memory name, string memory symbol) public {
452         _name = name;
453         _symbol = symbol;
454         _decimals = 18;
455     }
456 
457     /**
458      * @dev Returns the name of the token.
459      */
460     function name() public view returns (string memory) {
461         return _name;
462     }
463 
464     /**
465      * @dev Returns the symbol of the token, usually a shorter version of the
466      * name.
467      */
468     function symbol() public view returns (string memory) {
469         return _symbol;
470     }
471 
472     /**
473      * @dev Returns the number of decimals used to get its user representation.
474      * For example, if `decimals` equals `2`, a balance of `505` tokens should
475      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
476      *
477      * Tokens usually opt for a value of 18, imitating the relationship between
478      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
479      * called.
480      *
481      * NOTE: This information is only used for _display_ purposes: it in
482      * no way affects any of the arithmetic of the contract, including
483      * {IERC20-balanceOf} and {IERC20-transfer}.
484      */
485     function decimals() public view returns (uint8) {
486         return _decimals;
487     }
488 
489     /**
490      * @dev See {IERC20-totalSupply}.
491      */
492     function totalSupply() public view override returns (uint256) {
493         return _totalSupply;
494     }
495 
496     /**
497      * @dev See {IERC20-balanceOf}.
498      */
499     function balanceOf(address account) public view override returns (uint256) {
500         return _balances[account];
501     }
502 
503     /**
504      * @dev See {IERC20-transfer}.
505      *
506      * Requirements:
507      *
508      * - `recipient` cannot be the zero address.
509      * - the caller must have a balance of at least `amount`.
510      */
511     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
512         _transfer(_msgSender(), recipient, amount);
513         return true;
514     }
515 
516     /**
517      * @dev See {IERC20-allowance}.
518      */
519     function allowance(address owner, address spender) public view virtual override returns (uint256) {
520         return _allowances[owner][spender];
521     }
522 
523     /**
524      * @dev See {IERC20-approve}.
525      *
526      * Requirements:
527      *
528      * - `spender` cannot be the zero address.
529      */
530     function approve(address spender, uint256 amount) public virtual override returns (bool) {
531         _approve(_msgSender(), spender, amount);
532         return true;
533     }
534 
535     /**
536      * @dev See {IERC20-transferFrom}.
537      *
538      * Emits an {Approval} event indicating the updated allowance. This is not
539      * required by the EIP. See the note at the beginning of {ERC20};
540      *
541      * Requirements:
542      * - `sender` and `recipient` cannot be the zero address.
543      * - `sender` must have a balance of at least `amount`.
544      * - the caller must have allowance for ``sender``'s tokens of at least
545      * `amount`.
546      */
547     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
548         _transfer(sender, recipient, amount);
549         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
550         return true;
551     }
552 
553     /**
554      * @dev Atomically increases the allowance granted to `spender` by the caller.
555      *
556      * This is an alternative to {approve} that can be used as a mitigation for
557      * problems described in {IERC20-approve}.
558      *
559      * Emits an {Approval} event indicating the updated allowance.
560      *
561      * Requirements:
562      *
563      * - `spender` cannot be the zero address.
564      */
565     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
566         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
567         return true;
568     }
569 
570     /**
571      * @dev Atomically decreases the allowance granted to `spender` by the caller.
572      *
573      * This is an alternative to {approve} that can be used as a mitigation for
574      * problems described in {IERC20-approve}.
575      *
576      * Emits an {Approval} event indicating the updated allowance.
577      *
578      * Requirements:
579      *
580      * - `spender` cannot be the zero address.
581      * - `spender` must have allowance for the caller of at least
582      * `subtractedValue`.
583      */
584     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
585         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
586         return true;
587     }
588 
589     /**
590      * @dev Moves tokens `amount` from `sender` to `recipient`.
591      *
592      * This is internal function is equivalent to {transfer}, and can be used to
593      * e.g. implement automatic token fees, slashing mechanisms, etc.
594      *
595      * Emits a {Transfer} event.
596      *
597      * Requirements:
598      *
599      * - `sender` cannot be the zero address.
600      * - `recipient` cannot be the zero address.
601      * - `sender` must have a balance of at least `amount`.
602      */
603     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
604         require(sender != address(0), "ERC20: transfer from the zero address");
605         require(recipient != address(0), "ERC20: transfer to the zero address");
606 
607         _beforeTokenTransfer(sender, recipient, amount);
608 
609         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
610         _balances[recipient] = _balances[recipient].add(amount);
611         emit Transfer(sender, recipient, amount);
612     }
613 
614     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
615      * the total supply.
616      *
617      * Emits a {Transfer} event with `from` set to the zero address.
618      *
619      * Requirements
620      *
621      * - `to` cannot be the zero address.
622      */
623     function _mint(address account, uint256 amount) internal virtual {
624         require(account != address(0), "ERC20: mint to the zero address");
625 
626         _beforeTokenTransfer(address(0), account, amount);
627 
628         _totalSupply = _totalSupply.add(amount);
629         _balances[account] = _balances[account].add(amount);
630         emit Transfer(address(0), account, amount);
631     }
632 
633     /**
634      * @dev Destroys `amount` tokens from `account`, reducing the
635      * total supply.
636      *
637      * Emits a {Transfer} event with `to` set to the zero address.
638      *
639      * Requirements
640      *
641      * - `account` cannot be the zero address.
642      * - `account` must have at least `amount` tokens.
643      */
644     function _burn(address account, uint256 amount) internal virtual {
645         require(account != address(0), "ERC20: burn from the zero address");
646 
647         _beforeTokenTransfer(account, address(0), amount);
648 
649         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
650         _totalSupply = _totalSupply.sub(amount);
651         emit Transfer(account, address(0), amount);
652     }
653 
654     /**
655      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
656      *
657      * This internal function is equivalent to `approve`, and can be used to
658      * e.g. set automatic allowances for certain subsystems, etc.
659      *
660      * Emits an {Approval} event.
661      *
662      * Requirements:
663      *
664      * - `owner` cannot be the zero address.
665      * - `spender` cannot be the zero address.
666      */
667     function _approve(address owner, address spender, uint256 amount) internal virtual {
668         require(owner != address(0), "ERC20: approve from the zero address");
669         require(spender != address(0), "ERC20: approve to the zero address");
670 
671         _allowances[owner][spender] = amount;
672         emit Approval(owner, spender, amount);
673     }
674 
675     /**
676      * @dev Sets {decimals} to a value other than the default one of 18.
677      *
678      * WARNING: This function should only be called from the constructor. Most
679      * applications that interact with token contracts will not expect
680      * {decimals} to ever change, and may work incorrectly if it does.
681      */
682     function _setupDecimals(uint8 decimals_) internal {
683         _decimals = decimals_;
684     }
685 
686     /**
687      * @dev Hook that is called before any transfer of tokens. This includes
688      * minting and burning.
689      *
690      * Calling conditions:
691      *
692      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
693      * will be to transferred to `to`.
694      * - when `from` is zero, `amount` tokens will be minted for `to`.
695      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
696      * - `from` and `to` are never both zero.
697      *
698      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
699      */
700     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
701 }
702 
703 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
704 
705 /**
706  * @title SafeERC20
707  * @dev Wrappers around ERC20 operations that throw on failure (when the token
708  * contract returns false). Tokens that return no value (and instead revert or
709  * throw on failure) are also supported, non-reverting calls are assumed to be
710  * successful.
711  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
712  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
713  */
714 library SafeERC20 {
715     using SafeMath for uint256;
716     using Address for address;
717 
718     function safeTransfer(IERC20 token, address to, uint256 value) internal {
719         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
720     }
721 
722     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
723         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
724     }
725 
726     /**
727      * @dev Deprecated. This function has issues similar to the ones found in
728      * {IERC20-approve}, and its usage is discouraged.
729      *
730      * Whenever possible, use {safeIncreaseAllowance} and
731      * {safeDecreaseAllowance} instead.
732      */
733     function safeApprove(IERC20 token, address spender, uint256 value) internal {
734         // safeApprove should only be called when setting an initial allowance,
735         // or when resetting it to zero. To increase and decrease it, use
736         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
737         // solhint-disable-next-line max-line-length
738         require((value == 0) || (token.allowance(address(this), spender) == 0),
739             "SafeERC20: approve from non-zero to non-zero allowance"
740         );
741         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
742     }
743 
744     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
745         uint256 newAllowance = token.allowance(address(this), spender).add(value);
746         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
747     }
748 
749     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
750         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
751         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
752     }
753 
754     /**
755      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
756      * on the return value: the return value is optional (but if data is returned, it must not be false).
757      * @param token The token targeted by the call.
758      * @param data The call data (encoded using abi.encode or one of its variants).
759      */
760     function _callOptionalReturn(IERC20 token, bytes memory data) private {
761         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
762         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
763         // the target address contains contract code and also asserts for success in the low-level call.
764 
765         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
766         if (returndata.length > 0) { // Return data is optional
767             // solhint-disable-next-line max-line-length
768             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
769         }
770     }
771 }
772 
773 // File: contracts/VALUE/ValueLiquidityToken.sol
774 
775 /**
776  * @notice Value Liquidity (VALUE) with Governance Alpha
777  */
778 contract ValueLiquidityToken is ERC20 {
779     using SafeERC20 for IERC20;
780     using SafeMath for uint256;
781 
782     IERC20 public yfv;
783 
784     address public governance;
785     uint256 public cap;
786     uint256 public yfvLockedBalance;
787     mapping(address => bool) public minters;
788 
789     event Deposit(address indexed dst, uint amount);
790     event Withdrawal(address indexed src, uint amount);
791 
792     constructor (IERC20 _yfv, uint256 _cap) public ERC20("Value Liquidity", "VALUE") {
793         governance = msg.sender;
794         yfv = _yfv;
795         cap = _cap;
796     }
797 
798     function mint(address _to, uint256 _amount) public {
799         require(msg.sender == governance || minters[msg.sender], "!governance && !minter");
800         _mint(_to, _amount);
801         _moveDelegates(address(0), _delegates[_to], _amount);
802     }
803 
804     function burn(uint256 _amount) public {
805         _burn(msg.sender, _amount);
806         _moveDelegates(_delegates[msg.sender], address(0), _amount);
807     }
808 
809     function burnFrom(address _account, uint256 _amount) public {
810         uint256 decreasedAllowance = allowance(_account, msg.sender).sub(_amount, "ERC20: burn amount exceeds allowance");
811         _approve(_account, msg.sender, decreasedAllowance);
812         _burn(_account, _amount);
813         _moveDelegates(_delegates[_account], address(0), _amount);
814     }
815 
816     function setGovernance(address _governance) public {
817         require(msg.sender == governance, "!governance");
818         governance = _governance;
819     }
820 
821     function addMinter(address _minter) public {
822         require(msg.sender == governance, "!governance");
823         minters[_minter] = true;
824     }
825 
826     function removeMinter(address _minter) public {
827         require(msg.sender == governance, "!governance");
828         minters[_minter] = false;
829     }
830 
831     function setCap(uint256 _cap) public {
832         require(msg.sender == governance, "!governance");
833         require(_cap.add(yfvLockedBalance) >= totalSupply(), "_cap (plus yfvLockedBalance) is below current supply");
834         cap = _cap;
835     }
836 
837     function deposit(uint256 _amount) public {
838         yfv.safeTransferFrom(msg.sender, address(this), _amount);
839         yfvLockedBalance = yfvLockedBalance.add(_amount);
840         _mint(msg.sender, _amount);
841         _moveDelegates(address(0), _delegates[msg.sender], _amount);
842         Deposit(msg.sender, _amount);
843     }
844 
845     function withdraw(uint256 _amount) public {
846         yfvLockedBalance = yfvLockedBalance.sub(_amount, "There is not enough locked YFV to withdraw");
847         yfv.safeTransfer(msg.sender, _amount);
848         _burn(msg.sender, _amount);
849         _moveDelegates(_delegates[msg.sender], address(0), _amount);
850         Withdrawal(msg.sender, _amount);
851     }
852 
853     // This function allows governance to take unsupported tokens out of the contract.
854     // This is in an effort to make someone whole, should they seriously mess up.
855     // There is no guarantee governance will vote to return these.
856     // It also allows for removal of airdropped tokens.
857     function governanceRecoverUnsupported(IERC20 _token, address _to, uint256 _amount) external {
858         require(msg.sender == governance, "!governance");
859         if (_token == yfv) {
860             uint256 yfvBalance = yfv.balanceOf(address(this));
861             require(_amount <= yfvBalance.sub(yfvLockedBalance), "cant withdraw more then stuck amount");
862         }
863         _token.safeTransfer(_to, _amount);
864     }
865 
866     /**
867      * @dev See {ERC20-_beforeTokenTransfer}.
868      *
869      * Requirements:
870      *
871      * - minted tokens must not cause the total supply to go over the cap.
872      */
873     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
874         super._beforeTokenTransfer(from, to, amount);
875 
876         if (from == address(0)) {// When minting tokens
877             require(totalSupply().add(amount) <= cap.add(yfvLockedBalance), "ERC20Capped: cap exceeded");
878         }
879     }
880 
881     // Copied and modified from YAM code:
882     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
883     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
884     // Which is copied and modified from COMPOUND:
885     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
886 
887     /// @dev A record of each accounts delegate
888     mapping(address => address) internal _delegates;
889 
890     /// @notice A checkpoint for marking number of votes from a given block
891     struct Checkpoint {
892         uint32 fromBlock;
893         uint256 votes;
894     }
895 
896     /// @notice A record of votes checkpoints for each account, by index
897     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
898 
899     /// @notice The number of checkpoints for each account
900     mapping(address => uint32) public numCheckpoints;
901 
902     /// @notice The EIP-712 typehash for the contract's domain
903     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
904 
905     /// @notice The EIP-712 typehash for the delegation struct used by the contract
906     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
907 
908     /// @notice A record of states for signing / validating signatures
909     mapping(address => uint) public nonces;
910 
911     /// @notice An event thats emitted when an account changes its delegate
912     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
913 
914     /// @notice An event thats emitted when a delegate account's vote balance changes
915     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
916 
917     /**
918      * @notice Delegate votes from `msg.sender` to `delegatee`
919      * @param delegator The address to get delegatee for
920      */
921     function delegates(address delegator)
922     external
923     view
924     returns (address)
925     {
926         return _delegates[delegator];
927     }
928 
929     /**
930      * @notice Delegate votes from `msg.sender` to `delegatee`
931      * @param delegatee The address to delegate votes to
932      */
933     function delegate(address delegatee) external {
934         return _delegate(msg.sender, delegatee);
935     }
936 
937     /**
938      * @notice Delegates votes from signatory to `delegatee`
939      * @param delegatee The address to delegate votes to
940      * @param nonce The contract state required to match the signature
941      * @param expiry The time at which to expire the signature
942      * @param v The recovery byte of the signature
943      * @param r Half of the ECDSA signature pair
944      * @param s Half of the ECDSA signature pair
945      */
946     function delegateBySig(
947         address delegatee,
948         uint nonce,
949         uint expiry,
950         uint8 v,
951         bytes32 r,
952         bytes32 s
953     )
954         external
955     {
956         bytes32 domainSeparator = keccak256(
957             abi.encode(
958                 DOMAIN_TYPEHASH,
959                 keccak256(bytes(name())),
960                 getChainId(),
961                 address(this)
962             )
963         );
964 
965         bytes32 structHash = keccak256(
966             abi.encode(
967                 DELEGATION_TYPEHASH,
968                 delegatee,
969                 nonce,
970                 expiry
971             )
972         );
973 
974         bytes32 digest = keccak256(
975             abi.encodePacked(
976                 "\x19\x01",
977                 domainSeparator,
978                 structHash
979             )
980         );
981         address signatory = ecrecover(digest, v, r, s);
982         require(signatory != address(0), "VALUE::delegateBySig: invalid signature");
983         require(nonce == nonces[signatory]++, "VALUE::delegateBySig: invalid nonce");
984         require(now <= expiry, "VALUE::delegateBySig: signature expired");
985         return _delegate(signatory, delegatee);
986     }
987 
988     /**
989      * @notice Gets the current votes balance for `account`
990      * @param account The address to get votes balance
991      * @return The number of current votes for `account`
992      */
993     function getCurrentVotes(address account)
994         external
995         view
996         returns (uint256)
997     {
998         uint32 nCheckpoints = numCheckpoints[account];
999         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1000     }
1001 
1002     /**
1003      * @notice Determine the prior number of votes for an account as of a block number
1004      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1005      * @param account The address of the account to check
1006      * @param blockNumber The block number to get the vote balance at
1007      * @return The number of votes the account had as of the given block
1008      */
1009     function getPriorVotes(address account, uint blockNumber)
1010         external
1011         view
1012         returns (uint256)
1013     {
1014         require(blockNumber < block.number, "VALUE::getPriorVotes: not yet determined");
1015 
1016         uint32 nCheckpoints = numCheckpoints[account];
1017         if (nCheckpoints == 0) {
1018             return 0;
1019         }
1020 
1021         // First check most recent balance
1022         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1023             return checkpoints[account][nCheckpoints - 1].votes;
1024         }
1025 
1026         // Next check implicit zero balance
1027         if (checkpoints[account][0].fromBlock > blockNumber) {
1028             return 0;
1029         }
1030 
1031         uint32 lower = 0;
1032         uint32 upper = nCheckpoints - 1;
1033         while (upper > lower) {
1034             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1035             Checkpoint memory cp = checkpoints[account][center];
1036             if (cp.fromBlock == blockNumber) {
1037                 return cp.votes;
1038             } else if (cp.fromBlock < blockNumber) {
1039                 lower = center;
1040             } else {
1041                 upper = center - 1;
1042             }
1043         }
1044         return checkpoints[account][lower].votes;
1045     }
1046 
1047     function _delegate(address delegator, address delegatee)
1048         internal
1049     {
1050         address currentDelegate = _delegates[delegator];
1051         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying VALUEs (not scaled);
1052         _delegates[delegator] = delegatee;
1053 
1054         emit DelegateChanged(delegator, currentDelegate, delegatee);
1055 
1056         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1057     }
1058 
1059     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1060         if (srcRep != dstRep && amount > 0) {
1061             if (srcRep != address(0)) {
1062                 // decrease old representative
1063                 uint32 srcRepNum = numCheckpoints[srcRep];
1064                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1065                 uint256 srcRepNew = srcRepOld.sub(amount);
1066                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1067             }
1068 
1069             if (dstRep != address(0)) {
1070                 // increase new representative
1071                 uint32 dstRepNum = numCheckpoints[dstRep];
1072                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1073                 uint256 dstRepNew = dstRepOld.add(amount);
1074                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1075             }
1076         }
1077     }
1078 
1079     function _writeCheckpoint(
1080         address delegatee,
1081         uint32 nCheckpoints,
1082         uint256 oldVotes,
1083         uint256 newVotes
1084     )
1085         internal
1086     {
1087         uint32 blockNumber = safe32(block.number, "VALUE::_writeCheckpoint: block number exceeds 32 bits");
1088 
1089         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1090             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1091         } else {
1092             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1093             numCheckpoints[delegatee] = nCheckpoints + 1;
1094         }
1095 
1096         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1097     }
1098 
1099     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1100         require(n < 2 ** 32, errorMessage);
1101         return uint32(n);
1102     }
1103 
1104     function getChainId() internal pure returns (uint) {
1105         uint256 chainId;
1106         assembly {chainId := chainid()}
1107         return chainId;
1108     }
1109 }