1 /**
2 UniLend Finance FlashLoan Contract
3 */
4 
5 pragma solidity 0.6.2;
6 
7 
8 // SPDX-License-Identifier: MIT
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      *
31      * - Addition cannot overflow.
32      */
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      *
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      *
62      * - Subtraction cannot overflow.
63      */
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      *
79      * - Multiplication cannot overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      *
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts with custom message when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b != 0, errorMessage);
161         return a % b;
162     }
163 }
164 
165 // SPDX-License-Identifier: MIT
166 /*
167  * @dev Provides information about the current execution context, including the
168  * sender of the transaction and its data. While these are generally available
169  * via msg.sender and msg.data, they should not be accessed in such a direct
170  * manner, since when dealing with GSN meta-transactions the account sending and
171  * paying for execution may not be the actual sender (as far as an application
172  * is concerned).
173  *
174  * This contract is only required for intermediate, library-like contracts.
175  */
176 abstract contract Context {
177     function _msgSender() internal view virtual returns (address payable) {
178         return msg.sender;
179     }
180 
181     function _msgData() internal view virtual returns (bytes memory) {
182         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
183         return msg.data;
184     }
185 }
186 
187 // SPDX-License-Identifier: MIT
188 /**
189  * @dev Interface of the ERC20 standard as defined in the EIP.
190  */
191 interface IERC20 {
192     /**
193      * @dev Returns the amount of tokens in existence.
194      */
195     function totalSupply() external view returns (uint256);
196 
197     /**
198      * @dev Returns the amount of tokens owned by `account`.
199      */
200     function balanceOf(address account) external view returns (uint256);
201 
202     /**
203      * @dev Moves `amount` tokens from the caller's account to `recipient`.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transfer(address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Returns the remaining number of tokens that `spender` will be
213      * allowed to spend on behalf of `owner` through {transferFrom}. This is
214      * zero by default.
215      *
216      * This value changes when {approve} or {transferFrom} are called.
217      */
218     function allowance(address owner, address spender) external view returns (uint256);
219 
220     /**
221      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * IMPORTANT: Beware that changing an allowance with this method brings the risk
226      * that someone may use both the old and the new allowance by unfortunate
227      * transaction ordering. One possible solution to mitigate this race
228      * condition is to first reduce the spender's allowance to 0 and set the
229      * desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address spender, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Moves `amount` tokens from `sender` to `recipient` using the
238      * allowance mechanism. `amount` is then deducted from the caller's
239      * allowance.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Emitted when `value` tokens are moved from one account (`from`) to
249      * another (`to`).
250      *
251      * Note that `value` may be zero.
252      */
253     event Transfer(address indexed from, address indexed to, uint256 value);
254 
255     /**
256      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
257      * a call to {approve}. `value` is the new allowance.
258      */
259     event Approval(address indexed owner, address indexed spender, uint256 value);
260 }
261 
262 // SPDX-License-Identifier: MIT
263 /**
264  * @dev Collection of functions related to the address type
265  */
266 library Address {
267     /**
268      * @dev Returns true if `account` is a contract.
269      *
270      * [IMPORTANT]
271      * ====
272      * It is unsafe to assume that an address for which this function returns
273      * false is an externally-owned account (EOA) and not a contract.
274      *
275      * Among others, `isContract` will return false for the following
276      * types of addresses:
277      *
278      *  - an externally-owned account
279      *  - a contract in construction
280      *  - an address where a contract will be created
281      *  - an address where a contract lived, but was destroyed
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // This method relies in extcodesize, which returns 0 for contracts in
286         // construction, since the code is only stored at the end of the
287         // constructor execution.
288 
289         uint256 size;
290         // solhint-disable-next-line no-inline-assembly
291         assembly { size := extcodesize(account) }
292         return size > 0;
293     }
294 
295     /**
296      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297      * `recipient`, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by `transfer`, making them unable to receive funds via
302      * `transfer`. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to `recipient`, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
315         (bool success, ) = recipient.call{ value: amount }("");
316         require(success, "Address: unable to send value, recipient may have reverted");
317     }
318 
319     /**
320      * @dev Performs a Solidity function call using a low level `call`. A
321      * plain`call` is an unsafe replacement for a function call: use this
322      * function instead.
323      *
324      * If `target` reverts with a revert reason, it is bubbled up by this
325      * function (like regular Solidity function calls).
326      *
327      * Returns the raw returned data. To convert to the expected return value,
328      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
329      *
330      * Requirements:
331      *
332      * - `target` must be a contract.
333      * - calling `target` with `data` must not revert.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
338       return functionCall(target, data, "Address: low-level call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
343      * `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
348         return _functionCallWithValue(target, data, 0, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but also transferring `value` wei to `target`.
354      *
355      * Requirements:
356      *
357      * - the calling contract must have an ETH balance of at least `value`.
358      * - the called Solidity function must be `payable`.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
368      * with `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         return _functionCallWithValue(target, data, value, errorMessage);
375     }
376 
377     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
378         require(isContract(target), "Address: call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 // solhint-disable-next-line no-inline-assembly
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 // SPDX-License-Identifier: MIT
402 /**
403  * @dev Implementation of the {IERC20} interface.
404  *
405  * This implementation is agnostic to the way tokens are created. This means
406  * that a supply mechanism has to be added in a derived contract using {_mint}.
407  * For a generic mechanism see {ERC20PresetMinterPauser}.
408  *
409  * TIP: For a detailed writeup see our guide
410  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
411  * to implement supply mechanisms].
412  *
413  * We have followed general OpenZeppelin guidelines: functions revert instead
414  * of returning `false` on failure. This behavior is nonetheless conventional
415  * and does not conflict with the expectations of ERC20 applications.
416  *
417  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
418  * This allows applications to reconstruct the allowance for all accounts just
419  * by listening to said events. Other implementations of the EIP may not emit
420  * these events, as it isn't required by the specification.
421  *
422  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
423  * functions have been added to mitigate the well-known issues around setting
424  * allowances. See {IERC20-approve}.
425  */
426 contract ERC20 is Context, IERC20 {
427     using SafeMath for uint256;
428     using Address for address;
429 
430     mapping (address => uint256) private _balances;
431 
432     mapping (address => mapping (address => uint256)) private _allowances;
433 
434     uint256 private _totalSupply;
435 
436     string private _name;
437     string private _symbol;
438     uint8 private _decimals;
439 
440     /**
441      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
442      * a default value of 18.
443      *
444      * To select a different value for {decimals}, use {_setupDecimals}.
445      *
446      * All three of these values are immutable: they can only be set once during
447      * construction.
448      */
449     constructor (string memory name, string memory symbol) public {
450         _name = name;
451         _symbol = symbol;
452         _decimals = 18;
453     }
454 
455     /**
456      * @dev Returns the name of the token.
457      */
458     function name() public view returns (string memory) {
459         return _name;
460     }
461 
462     /**
463      * @dev Returns the symbol of the token, usually a shorter version of the
464      * name.
465      */
466     function symbol() public view returns (string memory) {
467         return _symbol;
468     }
469 
470     /**
471      * @dev Returns the number of decimals used to get its user representation.
472      * For example, if `decimals` equals `2`, a balance of `505` tokens should
473      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
474      *
475      * Tokens usually opt for a value of 18, imitating the relationship between
476      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
477      * called.
478      *
479      * NOTE: This information is only used for _display_ purposes: it in
480      * no way affects any of the arithmetic of the contract, including
481      * {IERC20-balanceOf} and {IERC20-transfer}.
482      */
483     function decimals() public view returns (uint8) {
484         return _decimals;
485     }
486 
487     /**
488      * @dev See {IERC20-totalSupply}.
489      */
490     function totalSupply() public view override returns (uint256) {
491         return _totalSupply;
492     }
493 
494     /**
495      * @dev See {IERC20-balanceOf}.
496      */
497     function balanceOf(address account) public view override returns (uint256) {
498         return _balances[account];
499     }
500 
501     /**
502      * @dev See {IERC20-transfer}.
503      *
504      * Requirements:
505      *
506      * - `recipient` cannot be the zero address.
507      * - the caller must have a balance of at least `amount`.
508      */
509     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
510         _transfer(_msgSender(), recipient, amount);
511         return true;
512     }
513 
514     /**
515      * @dev See {IERC20-allowance}.
516      */
517     function allowance(address owner, address spender) public view virtual override returns (uint256) {
518         return _allowances[owner][spender];
519     }
520 
521     /**
522      * @dev See {IERC20-approve}.
523      *
524      * Requirements:
525      *
526      * - `spender` cannot be the zero address.
527      */
528     function approve(address spender, uint256 amount) public virtual override returns (bool) {
529         _approve(_msgSender(), spender, amount);
530         return true;
531     }
532 
533     /**
534      * @dev See {IERC20-transferFrom}.
535      *
536      * Emits an {Approval} event indicating the updated allowance. This is not
537      * required by the EIP. See the note at the beginning of {ERC20};
538      *
539      * Requirements:
540      * - `sender` and `recipient` cannot be the zero address.
541      * - `sender` must have a balance of at least `amount`.
542      * - the caller must have allowance for ``sender``'s tokens of at least
543      * `amount`.
544      */
545     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
546         _transfer(sender, recipient, amount);
547         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
548         return true;
549     }
550 
551     /**
552      * @dev Atomically increases the allowance granted to `spender` by the caller.
553      *
554      * This is an alternative to {approve} that can be used as a mitigation for
555      * problems described in {IERC20-approve}.
556      *
557      * Emits an {Approval} event indicating the updated allowance.
558      *
559      * Requirements:
560      *
561      * - `spender` cannot be the zero address.
562      */
563     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
564         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
565         return true;
566     }
567 
568     /**
569      * @dev Atomically decreases the allowance granted to `spender` by the caller.
570      *
571      * This is an alternative to {approve} that can be used as a mitigation for
572      * problems described in {IERC20-approve}.
573      *
574      * Emits an {Approval} event indicating the updated allowance.
575      *
576      * Requirements:
577      *
578      * - `spender` cannot be the zero address.
579      * - `spender` must have allowance for the caller of at least
580      * `subtractedValue`.
581      */
582     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
583         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
584         return true;
585     }
586 
587     /**
588      * @dev Moves tokens `amount` from `sender` to `recipient`.
589      *
590      * This is internal function is equivalent to {transfer}, and can be used to
591      * e.g. implement automatic token fees, slashing mechanisms, etc.
592      *
593      * Emits a {Transfer} event.
594      *
595      * Requirements:
596      *
597      * - `sender` cannot be the zero address.
598      * - `recipient` cannot be the zero address.
599      * - `sender` must have a balance of at least `amount`.
600      */
601     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
602         require(sender != address(0), "ERC20: transfer from the zero address");
603         require(recipient != address(0), "ERC20: transfer to the zero address");
604 
605         _beforeTokenTransfer(sender, recipient, amount);
606 
607         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
608         _balances[recipient] = _balances[recipient].add(amount);
609         emit Transfer(sender, recipient, amount);
610     }
611 
612     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
613      * the total supply.
614      *
615      * Emits a {Transfer} event with `from` set to the zero address.
616      *
617      * Requirements
618      *
619      * - `to` cannot be the zero address.
620      */
621     function _mint(address account, uint256 amount) internal virtual {
622         require(account != address(0), "ERC20: mint to the zero address");
623 
624         _beforeTokenTransfer(address(0), account, amount);
625 
626         _totalSupply = _totalSupply.add(amount);
627         _balances[account] = _balances[account].add(amount);
628         emit Transfer(address(0), account, amount);
629     }
630 
631     /**
632      * @dev Destroys `amount` tokens from `account`, reducing the
633      * total supply.
634      *
635      * Emits a {Transfer} event with `to` set to the zero address.
636      *
637      * Requirements
638      *
639      * - `account` cannot be the zero address.
640      * - `account` must have at least `amount` tokens.
641      */
642     function _burn(address account, uint256 amount) internal virtual {
643         require(account != address(0), "ERC20: burn from the zero address");
644 
645         _beforeTokenTransfer(account, address(0), amount);
646 
647         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
648         _totalSupply = _totalSupply.sub(amount);
649         emit Transfer(account, address(0), amount);
650     }
651 
652     /**
653      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
654      *
655      * This internal function is equivalent to `approve`, and can be used to
656      * e.g. set automatic allowances for certain subsystems, etc.
657      *
658      * Emits an {Approval} event.
659      *
660      * Requirements:
661      *
662      * - `owner` cannot be the zero address.
663      * - `spender` cannot be the zero address.
664      */
665     function _approve(address owner, address spender, uint256 amount) internal virtual {
666         require(owner != address(0), "ERC20: approve from the zero address");
667         require(spender != address(0), "ERC20: approve to the zero address");
668 
669         _allowances[owner][spender] = amount;
670         emit Approval(owner, spender, amount);
671     }
672 
673     /**
674      * @dev Sets {decimals} to a value other than the default one of 18.
675      *
676      * WARNING: This function should only be called from the constructor. Most
677      * applications that interact with token contracts will not expect
678      * {decimals} to ever change, and may work incorrectly if it does.
679      */
680     function _setupDecimals(uint8 decimals_) internal {
681         _decimals = decimals_;
682     }
683 
684     /**
685      * @dev Hook that is called before any transfer of tokens. This includes
686      * minting and burning.
687      *
688      * Calling conditions:
689      *
690      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
691      * will be to transferred to `to`.
692      * - when `from` is zero, `amount` tokens will be minted for `to`.
693      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
694      * - `from` and `to` are never both zero.
695      *
696      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
697      */
698     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
699 }
700 
701 // SPDX-License-Identifier: MIT
702 /**
703  * @title SafeERC20
704  * @dev Wrappers around ERC20 operations that throw on failure (when the token
705  * contract returns false). Tokens that return no value (and instead revert or
706  * throw on failure) are also supported, non-reverting calls are assumed to be
707  * successful.
708  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
709  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
710  */
711 library SafeERC20 {
712     using SafeMath for uint256;
713     using Address for address;
714 
715     function safeTransfer(IERC20 token, address to, uint256 value) internal {
716         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
717     }
718 
719     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
720         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
721     }
722 
723     /**
724      * @dev Deprecated. This function has issues similar to the ones found in
725      * {IERC20-approve}, and its usage is discouraged.
726      *
727      * Whenever possible, use {safeIncreaseAllowance} and
728      * {safeDecreaseAllowance} instead.
729      */
730     function safeApprove(IERC20 token, address spender, uint256 value) internal {
731         // safeApprove should only be called when setting an initial allowance,
732         // or when resetting it to zero. To increase and decrease it, use
733         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
734         // solhint-disable-next-line max-line-length
735         require((value == 0) || (token.allowance(address(this), spender) == 0),
736             "SafeERC20: approve from non-zero to non-zero allowance"
737         );
738         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
739     }
740 
741     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
742         uint256 newAllowance = token.allowance(address(this), spender).add(value);
743         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
744     }
745 
746     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
747         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
748         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
749     }
750 
751     /**
752      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
753      * on the return value: the return value is optional (but if data is returned, it must not be false).
754      * @param token The token targeted by the call.
755      * @param data The call data (encoded using abi.encode or one of its variants).
756      */
757     function _callOptionalReturn(IERC20 token, bytes memory data) private {
758         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
759         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
760         // the target address contains contract code and also asserts for success in the low-level call.
761 
762         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
763         if (returndata.length > 0) { // Return data is optional
764             // solhint-disable-next-line max-line-length
765             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
766         }
767     }
768 }
769 
770 // SPDX-License-Identifier: MIT
771 /**
772  * @dev Contract module that helps prevent reentrant calls to a function.
773  *
774  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
775  * available, which can be applied to functions to make sure there are no nested
776  * (reentrant) calls to them.
777  *
778  * Note that because there is a single `nonReentrant` guard, functions marked as
779  * `nonReentrant` may not call one another. This can be worked around by making
780  * those functions `private`, and then adding `external` `nonReentrant` entry
781  * points to them.
782  *
783  * TIP: If you would like to learn more about reentrancy and alternative ways
784  * to protect against it, check out our blog post
785  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
786  */
787 contract ReentrancyGuard {
788     // Booleans are more expensive than uint256 or any type that takes up a full
789     // word because each write operation emits an extra SLOAD to first read the
790     // slot's contents, replace the bits taken up by the boolean, and then write
791     // back. This is the compiler's defense against contract upgrades and
792     // pointer aliasing, and it cannot be disabled.
793 
794     // The values being non-zero value makes deployment a bit more expensive,
795     // but in exchange the refund on every call to nonReentrant will be lower in
796     // amount. Since refunds are capped to a percentage of the total
797     // transaction's gas, it is best to keep them low in cases like this one, to
798     // increase the likelihood of the full refund coming into effect.
799     uint256 private constant _NOT_ENTERED = 1;
800     uint256 private constant _ENTERED = 2;
801 
802     uint256 private _status;
803 
804     constructor () internal {
805         _status = _NOT_ENTERED;
806     }
807 
808     /**
809      * @dev Prevents a contract from calling itself, directly or indirectly.
810      * Calling a `nonReentrant` function from another `nonReentrant`
811      * function is not supported. It is possible to prevent this from happening
812      * by making the `nonReentrant` function external, and make it call a
813      * `private` function that does the actual work.
814      */
815     modifier nonReentrant() {
816         // On the first call to nonReentrant, _notEntered will be true
817         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
818 
819         // Any calls to nonReentrant after this point will fail
820         _status = _ENTERED;
821 
822         _;
823 
824         // By storing the original value once again, a refund is triggered (see
825         // https://eips.ethereum.org/EIPS/eip-2200)
826         _status = _NOT_ENTERED;
827     }
828 }
829 
830 /**
831 * @title IFlashLoanReceiver interface
832 * @notice Interface for the Unilend fee IFlashLoanReceiver.
833 * @dev implement this interface to develop a flashloan-compatible flashLoanReceiver contract
834 **/
835 interface IFlashLoanReceiver {
836     function executeOperation(address _reserve, uint256 _amount, uint256 _fee, bytes calldata _params) external;
837 }
838 
839 library EthAddressLib {
840 
841     /**
842     * @dev returns the address used within the protocol to identify ETH
843     * @return the address assigned to ETH
844      */
845     function ethAddress() internal pure returns(address) {
846         return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
847     }
848 }
849 
850 contract UnilendFDonation {
851     using SafeMath for uint256;
852     using SafeERC20 for IERC20;
853     
854     uint public defaultReleaseRate;
855     bool public disableSetCore;
856     mapping(address => uint) public releaseRate;
857     mapping(address => uint) public lastReleased;
858     address public core;
859     
860     constructor() public {
861         core = msg.sender;
862         defaultReleaseRate = 11574074074075; // ~1% / day
863     }
864     
865     
866     modifier onlyCore {
867         require(
868             core == msg.sender,
869             "Not Permitted"
870         );
871         _;
872     }
873     
874     
875     event NewDonation(address indexed donator, uint amount);
876     event Released(address indexed to, uint amount);
877     event ReleaseRate(address indexed token, uint rate);
878     
879     
880     
881     function balanceOfToken(address _token) external view returns(uint) {
882         return IERC20(_token).balanceOf(address(this));
883     }
884     
885     function getReleaseRate(address _token) public view returns (uint) {
886         if(releaseRate[_token] > 0){
887             return releaseRate[_token];
888         } 
889         else {
890             return defaultReleaseRate;
891         }
892     }
893     
894     function getCurrentRelease(address _token, uint timestamp) public view returns (uint availRelease){
895         uint tokenBalance = IERC20(_token).balanceOf( address(this) );
896         
897         uint remainingRate = ( timestamp.sub( lastReleased[_token] ) ).mul( getReleaseRate(_token) );
898         uint maxRate = 100 * 10**18;
899         
900         if(remainingRate > maxRate){ remainingRate = maxRate; }
901         availRelease = ( tokenBalance.mul( remainingRate )).div(10**20);
902     }
903     
904     
905     function donate(address _token, uint amount) external returns(bool) {
906         require(amount > 0, "Amount can't be zero");
907         releaseTokens(_token);
908         
909         IERC20(_token).safeTransferFrom(msg.sender, address(this), amount);
910         
911         emit NewDonation(msg.sender, amount);
912         
913         return true;
914     }
915     
916     function disableSetNewCore() external onlyCore {
917         require(!disableSetCore, "Already disabled");
918         disableSetCore = true;
919     }
920     
921     function setCoreAddress(address _newAddress) external onlyCore {
922         require(!disableSetCore, "SetCoreAddress disabled");
923         core = _newAddress;
924     }
925     
926     function setReleaseRate(address _token, uint _newRate) external onlyCore {
927         releaseTokens(_token);
928         
929         releaseRate[_token] = _newRate;
930         
931         emit ReleaseRate(_token, _newRate);
932     }
933     
934     function releaseTokens(address _token) public {
935         uint tokenBalance = IERC20(_token).balanceOf( address(this) );
936         
937         if(tokenBalance > 0){
938             uint remainingRate = ( block.timestamp.sub( lastReleased[_token] ) ).mul( getReleaseRate(_token) );
939             uint maxRate = 100 * 10**18;
940             
941             lastReleased[_token] = block.timestamp;
942             
943             if(remainingRate > maxRate){ remainingRate = maxRate; }
944             uint totalReleased = ( tokenBalance.mul( remainingRate )).div(10**20);
945             
946             if(totalReleased > 0){
947                 IERC20(_token).safeTransfer(core, totalReleased);
948                 
949                 emit Released(core, totalReleased);
950             }
951         } 
952         else {
953             lastReleased[_token] = block.timestamp;
954         }
955     }
956 }
957 
958 // SPDX-License-Identifier: MIT
959 library Math {
960     function min(uint x, uint y) internal pure returns (uint z) {
961         z = x < y ? x : y;
962     }
963 
964     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
965     function sqrt(uint y) internal pure returns (uint z) {
966         if (y > 3) {
967             z = y;
968             uint x = y / 2 + 1;
969             while (x < z) {
970                 z = x;
971                 x = (y / x + x) / 2;
972             }
973         } else if (y != 0) {
974             z = 1;
975         }
976     }
977 }
978 
979 contract UFlashLoanPool is ERC20 {
980     using SafeMath for uint256;
981     
982     address public token;
983     address payable public core;
984     
985     
986     constructor(
987         address _token,
988         string memory _name,
989         string memory _symbol
990     ) ERC20(_name, _symbol) public {
991         token = _token;
992         
993         core = payable(msg.sender);
994     }
995     
996     modifier onlyCore {
997         require(
998             core == msg.sender,
999             "Not Permitted"
1000         );
1001         _;
1002     }
1003     
1004     
1005     
1006     function calculateShare(uint _totalShares, uint _totalAmount, uint _amount) internal pure returns (uint){
1007         if(_totalShares == 0){
1008             return Math.sqrt(_amount.mul( _amount ));
1009         } else {
1010             return (_amount).mul( _totalShares ).div( _totalAmount );
1011         }
1012     }
1013     
1014     function getShareValue(uint _totalAmount, uint _totalSupply, uint _amount) internal pure returns (uint){
1015         return ( _amount.mul(_totalAmount) ).div( _totalSupply );
1016     }
1017     
1018     function getShareByValue(uint _totalAmount, uint _totalSupply, uint _valueAmount) internal pure returns (uint){
1019         return ( _valueAmount.mul(_totalSupply) ).div( _totalAmount );
1020     }
1021     
1022     
1023     function deposit(address _recipient, uint amount) external onlyCore returns(uint) {
1024         uint _totalSupply = totalSupply();
1025         
1026         uint tokenBalance;
1027         if(EthAddressLib.ethAddress() == token){
1028             tokenBalance = address(core).balance;
1029         } 
1030         else {
1031             tokenBalance = IERC20(token).balanceOf(core);
1032         }
1033         
1034         uint ntokens = calculateShare(_totalSupply, tokenBalance.sub(amount), amount);
1035         
1036         require(ntokens > 0, 'Insufficient Liquidity Minted');
1037         
1038         // MINT uTokens
1039         _mint(_recipient, ntokens);
1040         
1041         return ntokens;
1042     }
1043     
1044     
1045     function redeem(address _recipient, uint tok_amount) external onlyCore returns(uint) {
1046         require(tok_amount > 0, 'Insufficient Liquidity Burned');
1047         require(balanceOf(_recipient) >= tok_amount, "Balance Exceeds Requested");
1048         
1049         uint tokenBalance;
1050         if(EthAddressLib.ethAddress() == token){
1051             tokenBalance = address(core).balance;
1052         } 
1053         else {
1054             tokenBalance = IERC20(token).balanceOf(core);
1055         }
1056         
1057         uint poolAmount = getShareValue(tokenBalance, totalSupply(), tok_amount);
1058         
1059         require(tokenBalance >= poolAmount, "Not enough Liquidity");
1060         
1061         // BURN uTokens
1062         _burn(_recipient, tok_amount);
1063         
1064         return poolAmount;
1065     }
1066     
1067     
1068     function redeemUnderlying(address _recipient, uint amount) external onlyCore returns(uint) {
1069         uint tokenBalance;
1070         if(EthAddressLib.ethAddress() == token){
1071             tokenBalance = address(core).balance;
1072         } 
1073         else {
1074             tokenBalance = IERC20(token).balanceOf(core);
1075         }
1076         
1077         uint tok_amount = getShareByValue(tokenBalance, totalSupply(), amount);
1078         
1079         require(tok_amount > 0, 'Insufficient Liquidity Burned');
1080         require(balanceOf(_recipient) >= tok_amount, "Balance Exceeds Requested");
1081         require(tokenBalance >= amount, "Not enough Liquidity");
1082         
1083         // BURN uTokens
1084         _burn(_recipient, tok_amount);
1085         
1086         return tok_amount;
1087     }
1088     
1089     
1090     function balanceOfUnderlying(address _address, uint timestamp) public view returns (uint _bal) {
1091         uint _balance = balanceOf(_address);
1092         
1093         if(_balance > 0){
1094             uint tokenBalance;
1095             if(EthAddressLib.ethAddress() == token){
1096                 tokenBalance = address(core).balance;
1097             } 
1098             else {
1099                 tokenBalance = IERC20(token).balanceOf(core);
1100             }
1101             
1102             address donationAddress = UnilendFlashLoanCore( core ).donationAddress();
1103             uint _balanceDonation = UnilendFDonation( donationAddress ).getCurrentRelease(token, timestamp);
1104             uint _totalPoolAmount = tokenBalance.add(_balanceDonation);
1105             
1106             _bal = getShareValue(_totalPoolAmount, totalSupply(), _balance);
1107         } 
1108     }
1109     
1110     
1111     function poolBalanceOfUnderlying(uint timestamp) public view returns (uint _bal) {
1112         uint tokenBalance;
1113         if(EthAddressLib.ethAddress() == token){
1114             tokenBalance = address(core).balance;
1115         } 
1116         else {
1117             tokenBalance = IERC20(token).balanceOf(core);
1118         }
1119         
1120         if(tokenBalance > 0){
1121             address donationAddress = UnilendFlashLoanCore( core ).donationAddress();
1122             uint _balanceDonation = UnilendFDonation( donationAddress ).getCurrentRelease(token, timestamp);
1123             uint _totalPoolAmount = tokenBalance.add(_balanceDonation);
1124             
1125             _bal = _totalPoolAmount;
1126         } 
1127     }
1128 }
1129 
1130 contract UnilendFlashLoanCore is Context, ReentrancyGuard {
1131     using SafeMath for uint256;
1132     using SafeERC20 for ERC20;
1133     
1134     address public admin;
1135     address payable public distributorAddress;
1136     address public donationAddress;
1137     
1138     mapping(address => address) public Pools;
1139     mapping(address => address) public Assets;
1140     uint public poolLength;
1141     
1142     
1143     uint256 private FLASHLOAN_FEE_TOTAL = 5;
1144     uint256 private FLASHLOAN_FEE_PROTOCOL = 3000;
1145     
1146     
1147     constructor() public {
1148         admin = msg.sender;
1149     }
1150     
1151     
1152     /**
1153     * @dev emitted when a flashloan is executed
1154     * @param _target the address of the flashLoanReceiver
1155     * @param _reserve the address of the reserve
1156     * @param _amount the amount requested
1157     * @param _totalFee the total fee on the amount
1158     * @param _protocolFee the part of the fee for the protocol
1159     * @param _timestamp the timestamp of the action
1160     **/
1161     event FlashLoan(
1162         address indexed _target,
1163         address indexed _reserve,
1164         uint256 _amount,
1165         uint256 _totalFee,
1166         uint256 _protocolFee,
1167         uint256 _timestamp
1168     );
1169     
1170     event PoolCreated(address indexed token, address pool, uint);
1171     
1172     /**
1173     * @dev emitted during a redeem action.
1174     * @param _reserve the address of the reserve
1175     * @param _user the address of the user
1176     * @param _amount the amount to be deposited
1177     * @param _timestamp the timestamp of the action
1178     **/
1179     event RedeemUnderlying(
1180         address indexed _reserve,
1181         address indexed _user,
1182         uint256 _amount,
1183         uint256 _timestamp
1184     );
1185     
1186     /**
1187     * @dev emitted on deposit
1188     * @param _reserve the address of the reserve
1189     * @param _user the address of the user
1190     * @param _amount the amount to be deposited
1191     * @param _timestamp the timestamp of the action
1192     **/
1193     event Deposit(
1194         address indexed _reserve,
1195         address indexed _user,
1196         uint256 _amount,
1197         uint256 _timestamp
1198     );
1199     
1200     /**
1201     * @dev only lending pools configurator can use functions affected by this modifier
1202     **/
1203     modifier onlyAdmin {
1204         require(
1205             admin == msg.sender,
1206             "The caller must be a admin"
1207         );
1208         _;
1209     }
1210     
1211     /**
1212     * @dev functions affected by this modifier can only be invoked if the provided _amount input parameter
1213     * is not zero.
1214     * @param _amount the amount provided
1215     **/
1216     modifier onlyAmountGreaterThanZero(uint256 _amount) {
1217         require(_amount > 0, "Amount must be greater than 0");
1218         _;
1219     }
1220     
1221     receive() payable external {}
1222     
1223     /**
1224     * @dev returns the fee applied to a flashloan and the portion to redirect to the protocol, in basis points.
1225     **/
1226     function getFlashLoanFeesInBips() public view returns (uint256, uint256) {
1227         return (FLASHLOAN_FEE_TOTAL, FLASHLOAN_FEE_PROTOCOL);
1228     }
1229     
1230     /**
1231     * @dev gets the bulk uToken contract address for the reserves
1232     * @param _reserves the array of reserve address
1233     * @return the address of the uToken contract
1234     **/
1235     function getPools(address[] calldata _reserves) external view returns (address[] memory) {
1236         address[] memory _addresss = new address[](_reserves.length);
1237         address[] memory _reserves_ = _reserves;
1238         
1239         for (uint i=0; i<_reserves_.length; i++) {
1240             _addresss[i] = Pools[_reserves_[i]];
1241         }
1242         
1243         return _addresss;
1244     }
1245     
1246     
1247     /**
1248     * @dev balance of underlying asset for user address
1249     * @param _reserve reserve address
1250     * @param _address user address
1251     * @param timestamp timestamp of query
1252     **/
1253     function balanceOfUnderlying(address _reserve, address _address, uint timestamp) public view returns (uint _bal) {
1254         if(Pools[_reserve] != address(0)){
1255             _bal = UFlashLoanPool(Pools[_reserve]).balanceOfUnderlying(_address, timestamp);
1256         }
1257     }
1258     
1259     /**
1260     * @dev balance of underlying asset for pool
1261     * @param _reserve reserve address
1262     * @param timestamp timestamp of query
1263     **/
1264     function poolBalanceOfUnderlying(address _reserve, uint timestamp) public view returns (uint _bal) {
1265         if(Pools[_reserve] != address(0)){
1266             _bal = UFlashLoanPool(Pools[_reserve]).poolBalanceOfUnderlying(timestamp);
1267         }
1268     }
1269     
1270     
1271     /**
1272     * @dev set new admin for contract.
1273     * @param _admin the address of new admin
1274     **/
1275     function setAdmin(address _admin) external onlyAdmin {
1276         require(_admin != address(0), "UnilendV1: ZERO ADDRESS");
1277         admin = _admin;
1278     }
1279     
1280     /**
1281     * @dev set new distributor address.
1282     * @param _address new address
1283     **/
1284     function setDistributorAddress(address payable _address) external onlyAdmin {
1285         require(_address != address(0), "UnilendV1: ZERO ADDRESS");
1286         distributorAddress = _address;
1287     }
1288     
1289     /**
1290     * @dev disable changing donation pool donation address.
1291     **/
1292     function setDonationDisableNewCore() external onlyAdmin {
1293         UnilendFDonation(donationAddress).disableSetNewCore();
1294     }
1295     
1296     /**
1297     * @dev set new core address for donation pool.
1298     * @param _newAddress new address
1299     **/
1300     function setDonationCoreAddress(address _newAddress) external onlyAdmin {
1301         require(_newAddress != address(0), "UnilendV1: ZERO ADDRESS");
1302         UnilendFDonation(donationAddress).setCoreAddress(_newAddress);
1303     }
1304     
1305     /**
1306     * @dev set new release rate from donation pool for token
1307     * @param _reserve reserve address
1308     * @param _newRate new rate of release
1309     **/
1310     function setDonationReleaseRate(address _reserve, uint _newRate) external onlyAdmin {
1311         require(_reserve != address(0), "UnilendV1: ZERO ADDRESS");
1312         UnilendFDonation(donationAddress).setReleaseRate(_reserve, _newRate);
1313     }
1314     
1315     /**
1316     * @dev set new flash loan fees.
1317     * @param _newFeeTotal total fee
1318     * @param _newFeeProtocol protocol fee
1319     **/
1320     function setFlashLoanFeesInBips(uint _newFeeTotal, uint _newFeeProtocol) external onlyAdmin returns (bool) {
1321         require(_newFeeTotal > 0 && _newFeeTotal < 10000, "UnilendV1: INVALID TOTAL FEE RANGE");
1322         require(_newFeeProtocol > 0 && _newFeeProtocol < 10000, "UnilendV1: INVALID PROTOCOL FEE RANGE");
1323         
1324         FLASHLOAN_FEE_TOTAL = _newFeeTotal;
1325         FLASHLOAN_FEE_PROTOCOL = _newFeeProtocol;
1326         
1327         return true;
1328     }
1329     
1330 
1331     /**
1332     * @dev transfers to the user a specific amount from the reserve.
1333     * @param _reserve the address of the reserve where the transfer is happening
1334     * @param _user the address of the user receiving the transfer
1335     * @param _amount the amount being transferred
1336     **/
1337     function transferToUser(address _reserve, address payable _user, uint256 _amount) internal {
1338         require(_user != address(0), "UnilendV1: USER ZERO ADDRESS");
1339         
1340         if (_reserve != EthAddressLib.ethAddress()) {
1341             ERC20(_reserve).safeTransfer(_user, _amount);
1342         } else {
1343             //solium-disable-next-line
1344             (bool result, ) = _user.call{value: _amount, gas: 50000}("");
1345             require(result, "Transfer of ETH failed");
1346         }
1347     }
1348     
1349     /**
1350     * @dev transfers to the protocol fees of a flashloan to the fees collection address
1351     * @param _token the address of the token being transferred
1352     * @param _amount the amount being transferred
1353     **/
1354     function transferFlashLoanProtocolFeeInternal(address _token, uint256 _amount) internal {
1355         if (_token != EthAddressLib.ethAddress()) {
1356             ERC20(_token).safeTransfer(distributorAddress, _amount);
1357         } else {
1358             (bool result, ) = distributorAddress.call{value: _amount, gas: 50000}("");
1359             require(result, "Transfer of ETH failed");
1360         }
1361     }
1362     
1363     
1364     /**
1365     * @dev allows smartcontracts to access the liquidity of the pool within one transaction,
1366     * as long as the amount taken plus a fee is returned. NOTE There are security concerns for developers of flashloan receiver contracts
1367     * that must be kept into consideration.
1368     * @param _receiver The address of the contract receiving the funds. The receiver should implement the IFlashLoanReceiver interface.
1369     * @param _reserve the address of the principal reserve
1370     * @param _amount the amount requested for this flashloan
1371     **/
1372     function flashLoan(address _receiver, address _reserve, uint256 _amount, bytes calldata _params)
1373         external
1374         nonReentrant
1375         onlyAmountGreaterThanZero(_amount)
1376     {
1377         //check that the reserve has enough available liquidity
1378         uint256 availableLiquidityBefore = _reserve == EthAddressLib.ethAddress()
1379             ? address(this).balance
1380             : IERC20(_reserve).balanceOf(address(this));
1381 
1382         require(
1383             availableLiquidityBefore >= _amount,
1384             "There is not enough liquidity available to borrow"
1385         );
1386 
1387         (uint256 totalFeeBips, uint256 protocolFeeBips) = getFlashLoanFeesInBips();
1388         //calculate amount fee
1389         uint256 amountFee = _amount.mul(totalFeeBips).div(10000);
1390 
1391         //protocol fee is the part of the amountFee reserved for the protocol - the rest goes to depositors
1392         uint256 protocolFee = amountFee.mul(protocolFeeBips).div(10000);
1393         require(
1394             amountFee > 0 && protocolFee > 0,
1395             "The requested amount is too small for a flashLoan."
1396         );
1397 
1398         //get the FlashLoanReceiver instance
1399         IFlashLoanReceiver receiver = IFlashLoanReceiver(_receiver);
1400 
1401         //transfer funds to the receiver
1402         transferToUser(_reserve, payable(_receiver), _amount);
1403 
1404         //execute action of the receiver
1405         receiver.executeOperation(_reserve, _amount, amountFee, _params);
1406 
1407         //check that the actual balance of the core contract includes the returned amount
1408         uint256 availableLiquidityAfter = _reserve == EthAddressLib.ethAddress()
1409             ? address(this).balance
1410             : IERC20(_reserve).balanceOf(address(this));
1411 
1412         require(
1413             availableLiquidityAfter == availableLiquidityBefore.add(amountFee),
1414             "The actual balance of the protocol is inconsistent"
1415         );
1416         
1417         transferFlashLoanProtocolFeeInternal(_reserve, protocolFee);
1418 
1419         //solium-disable-next-line
1420         emit FlashLoan(_receiver, _reserve, _amount, amountFee, protocolFee, block.timestamp);
1421     }
1422     
1423     
1424     
1425     
1426     
1427     /**
1428     * @dev deposits The underlying asset into the reserve. A corresponding amount of the overlying asset (uTokens) is minted.
1429     * @param _reserve the address of the reserve
1430     * @param _amount the amount to be deposited
1431     **/
1432     function deposit(address _reserve, uint _amount) external 
1433         payable
1434         nonReentrant
1435         onlyAmountGreaterThanZero(_amount)
1436     returns(uint mintedTokens) {
1437         require(Pools[_reserve] != address(0), 'UnilendV1: POOL NOT FOUND');
1438         
1439         UnilendFDonation(donationAddress).releaseTokens(_reserve);
1440         
1441         address _user = msg.sender;
1442         
1443         if (_reserve != EthAddressLib.ethAddress()) {
1444             require(msg.value == 0, "User is sending ETH along with the ERC20 transfer.");
1445             
1446             uint reserveBalance = IERC20(_reserve).balanceOf(address(this));
1447             
1448             ERC20(_reserve).safeTransferFrom(_user, address(this), _amount);
1449             
1450             _amount = ( IERC20(_reserve).balanceOf(address(this)) ).sub(reserveBalance);
1451         } else {
1452             require(msg.value >= _amount, "The amount and the value sent to deposit do not match");
1453 
1454             if (msg.value > _amount) {
1455                 //send back excess ETH
1456                 uint256 excessAmount = msg.value.sub(_amount);
1457                 
1458                 (bool result, ) = _user.call{value: excessAmount, gas: 50000}("");
1459                 require(result, "Transfer of ETH failed");
1460             }
1461         }
1462         
1463         mintedTokens = UFlashLoanPool(Pools[_reserve]).deposit(msg.sender, _amount);
1464         
1465         emit Deposit(_reserve, msg.sender, _amount, block.timestamp);
1466     }
1467     
1468     
1469     /**
1470     * @dev Redeems the uTokens for underlying assets.
1471     * @param _reserve the address of the reserve
1472     * @param _amount the amount uTokens to be redeemed
1473     **/
1474     function redeem(address _reserve, uint _amount) external returns(uint redeemTokens) {
1475         require(Pools[_reserve] != address(0), 'UnilendV1: POOL NOT FOUND');
1476         
1477         UnilendFDonation(donationAddress).releaseTokens(_reserve);
1478         
1479         redeemTokens = UFlashLoanPool(Pools[_reserve]).redeem(msg.sender, _amount);
1480         
1481         //transfer funds to the user
1482         transferToUser(_reserve, payable(msg.sender), redeemTokens);
1483         
1484         emit RedeemUnderlying(_reserve, msg.sender, redeemTokens, block.timestamp);
1485     }
1486     
1487     /**
1488     * @dev Redeems the underlying amount of assets.
1489     * @param _reserve the address of the reserve
1490     * @param _amount the underlying amount to be redeemed
1491     **/
1492     function redeemUnderlying(address _reserve, uint _amount) external returns(uint token_amount) {
1493         require(Pools[_reserve] != address(0), 'UnilendV1: POOL NOT FOUND');
1494         
1495         UnilendFDonation(donationAddress).releaseTokens(_reserve);
1496         
1497         token_amount = UFlashLoanPool(Pools[_reserve]).redeemUnderlying(msg.sender, _amount);
1498         
1499         //transfer funds to the user
1500         transferToUser(_reserve, payable(msg.sender), _amount);
1501         
1502         emit RedeemUnderlying(_reserve, msg.sender, _amount, block.timestamp);
1503     }
1504     
1505     
1506     
1507     /**
1508     * @dev Creates pool for asset.
1509     * This function is executed by the overlying uToken contract in response to a redeem action.
1510     * @param _reserve the address of the reserve
1511     **/
1512     function createPool(address _reserve) public returns (address) {
1513         require(Pools[_reserve] == address(0), 'UnilendV1: POOL ALREADY CREATED');
1514         
1515         ERC20 asset = ERC20(_reserve);
1516         
1517         string memory uTokenName;
1518         string memory uTokenSymbol;
1519         
1520         if(_reserve == EthAddressLib.ethAddress()){
1521             uTokenName = string(abi.encodePacked("UnilendV1 - ETH"));
1522             uTokenSymbol = string(abi.encodePacked("uETH"));
1523         } 
1524         else {
1525             uTokenName = string(abi.encodePacked("UnilendV1 - ", asset.name()));
1526             uTokenSymbol = string(abi.encodePacked("u", asset.symbol()));
1527         }
1528         
1529         UFlashLoanPool _poolMeta = new UFlashLoanPool(_reserve, uTokenName, uTokenSymbol);
1530         
1531         address _poolAddress = address(_poolMeta);
1532         
1533         Pools[_reserve] = _poolAddress;
1534         Assets[_poolAddress] = _reserve;
1535         
1536         poolLength++;
1537         
1538         emit PoolCreated(_reserve, _poolAddress, poolLength);
1539         
1540         return _poolAddress;
1541     }
1542     
1543     /**
1544     * @dev Creates donation contract (one-time).
1545     **/
1546     function createDonationContract() external returns (address) {
1547         require(donationAddress == address(0), 'UnilendV1: DONATION ADDRESS ALREADY CREATED');
1548         
1549         UnilendFDonation _donationMeta = new UnilendFDonation();
1550         donationAddress = address(_donationMeta);
1551         
1552         return donationAddress;
1553     }
1554 }