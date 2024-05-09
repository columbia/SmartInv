1 // SPDX-License-Identifier: MIT
2 
3 pragma experimental ABIEncoderV2;
4 pragma solidity 0.6.12;
5 
6 
7 // 
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
29 // 
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
104 // 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 // 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
314         (bool success, ) = recipient.call{ value: amount }("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain`call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337       return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
347         return _functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         return _functionCallWithValue(target, data, value, errorMessage);
374     }
375 
376     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
377         require(isContract(target), "Address: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 // 
401 /**
402  * @dev Implementation of the {IERC20} interface.
403  *
404  * This implementation is agnostic to the way tokens are created. This means
405  * that a supply mechanism has to be added in a derived contract using {_mint}.
406  * For a generic mechanism see {ERC20PresetMinterPauser}.
407  *
408  * TIP: For a detailed writeup see our guide
409  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
410  * to implement supply mechanisms].
411  *
412  * We have followed general OpenZeppelin guidelines: functions revert instead
413  * of returning `false` on failure. This behavior is nonetheless conventional
414  * and does not conflict with the expectations of ERC20 applications.
415  *
416  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
417  * This allows applications to reconstruct the allowance for all accounts just
418  * by listening to said events. Other implementations of the EIP may not emit
419  * these events, as it isn't required by the specification.
420  *
421  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
422  * functions have been added to mitigate the well-known issues around setting
423  * allowances. See {IERC20-approve}.
424  */
425 contract ERC20 is Context, IERC20 {
426     using SafeMath for uint256;
427     using Address for address;
428 
429     mapping (address => uint256) private _balances;
430 
431     mapping (address => mapping (address => uint256)) private _allowances;
432 
433     uint256 private _totalSupply;
434 
435     string private _name;
436     string private _symbol;
437     uint8 private _decimals;
438 
439     /**
440      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
441      * a default value of 18.
442      *
443      * To select a different value for {decimals}, use {_setupDecimals}.
444      *
445      * All three of these values are immutable: they can only be set once during
446      * construction.
447      */
448     constructor (string memory name, string memory symbol) public {
449         _name = name;
450         _symbol = symbol;
451         _decimals = 18;
452     }
453 
454     /**
455      * @dev Returns the name of the token.
456      */
457     function name() public view returns (string memory) {
458         return _name;
459     }
460 
461     /**
462      * @dev Returns the symbol of the token, usually a shorter version of the
463      * name.
464      */
465     function symbol() public view returns (string memory) {
466         return _symbol;
467     }
468 
469     /**
470      * @dev Returns the number of decimals used to get its user representation.
471      * For example, if `decimals` equals `2`, a balance of `505` tokens should
472      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
473      *
474      * Tokens usually opt for a value of 18, imitating the relationship between
475      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
476      * called.
477      *
478      * NOTE: This information is only used for _display_ purposes: it in
479      * no way affects any of the arithmetic of the contract, including
480      * {IERC20-balanceOf} and {IERC20-transfer}.
481      */
482     function decimals() public view returns (uint8) {
483         return _decimals;
484     }
485 
486     /**
487      * @dev See {IERC20-totalSupply}.
488      */
489     function totalSupply() public view override returns (uint256) {
490         return _totalSupply;
491     }
492 
493     /**
494      * @dev See {IERC20-balanceOf}.
495      */
496     function balanceOf(address account) public view override returns (uint256) {
497         return _balances[account];
498     }
499 
500     /**
501      * @dev See {IERC20-transfer}.
502      *
503      * Requirements:
504      *
505      * - `recipient` cannot be the zero address.
506      * - the caller must have a balance of at least `amount`.
507      */
508     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
509         _transfer(_msgSender(), recipient, amount);
510         return true;
511     }
512 
513     /**
514      * @dev See {IERC20-allowance}.
515      */
516     function allowance(address owner, address spender) public view virtual override returns (uint256) {
517         return _allowances[owner][spender];
518     }
519 
520     /**
521      * @dev See {IERC20-approve}.
522      *
523      * Requirements:
524      *
525      * - `spender` cannot be the zero address.
526      */
527     function approve(address spender, uint256 amount) public virtual override returns (bool) {
528         _approve(_msgSender(), spender, amount);
529         return true;
530     }
531 
532     /**
533      * @dev See {IERC20-transferFrom}.
534      *
535      * Emits an {Approval} event indicating the updated allowance. This is not
536      * required by the EIP. See the note at the beginning of {ERC20};
537      *
538      * Requirements:
539      * - `sender` and `recipient` cannot be the zero address.
540      * - `sender` must have a balance of at least `amount`.
541      * - the caller must have allowance for ``sender``'s tokens of at least
542      * `amount`.
543      */
544     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
545         _transfer(sender, recipient, amount);
546         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
547         return true;
548     }
549 
550     /**
551      * @dev Atomically increases the allowance granted to `spender` by the caller.
552      *
553      * This is an alternative to {approve} that can be used as a mitigation for
554      * problems described in {IERC20-approve}.
555      *
556      * Emits an {Approval} event indicating the updated allowance.
557      *
558      * Requirements:
559      *
560      * - `spender` cannot be the zero address.
561      */
562     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
563         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
564         return true;
565     }
566 
567     /**
568      * @dev Atomically decreases the allowance granted to `spender` by the caller.
569      *
570      * This is an alternative to {approve} that can be used as a mitigation for
571      * problems described in {IERC20-approve}.
572      *
573      * Emits an {Approval} event indicating the updated allowance.
574      *
575      * Requirements:
576      *
577      * - `spender` cannot be the zero address.
578      * - `spender` must have allowance for the caller of at least
579      * `subtractedValue`.
580      */
581     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
582         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
583         return true;
584     }
585 
586     /**
587      * @dev Moves tokens `amount` from `sender` to `recipient`.
588      *
589      * This is internal function is equivalent to {transfer}, and can be used to
590      * e.g. implement automatic token fees, slashing mechanisms, etc.
591      *
592      * Emits a {Transfer} event.
593      *
594      * Requirements:
595      *
596      * - `sender` cannot be the zero address.
597      * - `recipient` cannot be the zero address.
598      * - `sender` must have a balance of at least `amount`.
599      */
600     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
601         require(sender != address(0), "ERC20: transfer from the zero address");
602         require(recipient != address(0), "ERC20: transfer to the zero address");
603 
604         _beforeTokenTransfer(sender, recipient, amount);
605 
606         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
607         _balances[recipient] = _balances[recipient].add(amount);
608         emit Transfer(sender, recipient, amount);
609     }
610 
611     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
612      * the total supply.
613      *
614      * Emits a {Transfer} event with `from` set to the zero address.
615      *
616      * Requirements
617      *
618      * - `to` cannot be the zero address.
619      */
620     function _mint(address account, uint256 amount) internal virtual {
621         require(account != address(0), "ERC20: mint to the zero address");
622 
623         _beforeTokenTransfer(address(0), account, amount);
624 
625         _totalSupply = _totalSupply.add(amount);
626         _balances[account] = _balances[account].add(amount);
627         emit Transfer(address(0), account, amount);
628     }
629 
630     /**
631      * @dev Destroys `amount` tokens from `account`, reducing the
632      * total supply.
633      *
634      * Emits a {Transfer} event with `to` set to the zero address.
635      *
636      * Requirements
637      *
638      * - `account` cannot be the zero address.
639      * - `account` must have at least `amount` tokens.
640      */
641     function _burn(address account, uint256 amount) internal virtual {
642         require(account != address(0), "ERC20: burn from the zero address");
643 
644         _beforeTokenTransfer(account, address(0), amount);
645 
646         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
647         _totalSupply = _totalSupply.sub(amount);
648         emit Transfer(account, address(0), amount);
649     }
650 
651     /**
652      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
653      *
654      * This is internal function is equivalent to `approve`, and can be used to
655      * e.g. set automatic allowances for certain subsystems, etc.
656      *
657      * Emits an {Approval} event.
658      *
659      * Requirements:
660      *
661      * - `owner` cannot be the zero address.
662      * - `spender` cannot be the zero address.
663      */
664     function _approve(address owner, address spender, uint256 amount) internal virtual {
665         require(owner != address(0), "ERC20: approve from the zero address");
666         require(spender != address(0), "ERC20: approve to the zero address");
667 
668         _allowances[owner][spender] = amount;
669         emit Approval(owner, spender, amount);
670     }
671 
672     /**
673      * @dev Sets {decimals} to a value other than the default one of 18.
674      *
675      * WARNING: This function should only be called from the constructor. Most
676      * applications that interact with token contracts will not expect
677      * {decimals} to ever change, and may work incorrectly if it does.
678      */
679     function _setupDecimals(uint8 decimals_) internal {
680         _decimals = decimals_;
681     }
682 
683     /**
684      * @dev Hook that is called before any transfer of tokens. This includes
685      * minting and burning.
686      *
687      * Calling conditions:
688      *
689      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
690      * will be to transferred to `to`.
691      * - when `from` is zero, `amount` tokens will be minted for `to`.
692      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
693      * - `from` and `to` are never both zero.
694      *
695      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
696      */
697     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
698 }
699 
700 // 
701 interface IVaultsCore {
702   event Opened(uint256 indexed vaultId, address indexed collateralType, address indexed owner);
703   event Deposited(uint256 indexed vaultId, uint256 amount, address indexed sender);
704   event Withdrawn(uint256 indexed vaultId, uint256 amount, address indexed sender);
705   event Borrowed(uint256 indexed vaultId, uint256 amount, address indexed sender);
706   event Repaid(uint256 indexed vaultId, uint256 amount, address indexed sender);
707   event Liquidated(
708     uint256 indexed vaultId,
709     uint256 debtRepaid,
710     uint256 collateralLiquidated,
711     address indexed owner,
712     address indexed sender
713   );
714 
715   event CumulativeRateUpdated(
716     address indexed collateralType,
717     uint256 elapsedTime,
718     uint256 newCumulativeRate
719   ); //cumulative interest rate from deployment time T0
720 
721   event InsurancePaid(uint256 indexed vaultId, uint256 insuranceAmount, address indexed sender);
722 
723   function a() external view returns (IAddressProvider);
724 
725   function deposit(address _collateralType, uint256 _amount) external;
726 
727   function withdraw(uint256 _vaultId, uint256 _amount) external;
728 
729   function withdrawAll(uint256 _vaultId) external;
730 
731   function borrow(uint256 _vaultId, uint256 _amount) external;
732 
733   function repayAll(uint256 _vaultId) external;
734 
735   function repay(uint256 _vaultId, uint256 _amount) external;
736 
737   function liquidate(uint256 _vaultId) external;
738 
739   //Read only
740 
741   function availableIncome() external view returns (uint256);
742 
743   function cumulativeRates(address _collateralType) external view returns (uint256);
744 
745   function lastRefresh(address _collateralType) external view returns (uint256);
746 
747   //Refresh
748   function initializeRates(address _collateralType) external;
749 
750   function refresh() external;
751 
752   function refreshCollateral(address collateralType) external;
753 
754   //upgrade
755   function upgrade(address _newVaultsCore) external;
756 }
757 
758 // 
759 interface IAccessController {
760   event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
761   event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
762   event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
763 
764   function MANAGER_ROLE() external view returns (bytes32);
765 
766   function MINTER_ROLE() external view returns (bytes32);
767 
768   function hasRole(bytes32 role, address account) external view returns (bool);
769 
770   function getRoleMemberCount(bytes32 role) external view returns (uint256);
771 
772   function getRoleMember(bytes32 role, uint256 index) external view returns (address);
773 
774   function getRoleAdmin(bytes32 role) external view returns (bytes32);
775 
776   function grantRole(bytes32 role, address account) external;
777 
778   function revokeRole(bytes32 role, address account) external;
779 
780   function renounceRole(bytes32 role, address account) external;
781 }
782 
783 // 
784 interface IConfigProvider {
785   struct CollateralConfig {
786     address collateralType;
787     uint256 debtLimit;
788     uint256 minCollateralRatio;
789     uint256 borrowRate;
790     uint256 originationFee;
791   }
792 
793   function a() external view returns (IAddressProvider);
794 
795   function collateralConfigs(uint256 _id) external view returns (CollateralConfig memory);
796 
797   function collateralIds(address _collateralType) external view returns (uint256);
798 
799   function numCollateralConfigs() external view returns (uint256);
800 
801   function liquidationBonus() external view returns (uint256);
802 
803   event CollateralUpdated(
804     address indexed collateralType,
805     uint256 debtLimit,
806     uint256 minCollateralRatio,
807     uint256 borrowRate,
808     uint256 originationFee
809   );
810   event CollateralRemoved(address indexed collateralType);
811 
812   function setCollateralConfig(
813     address _collateralType,
814     uint256 _debtLimit,
815     uint256 _minCollateralRatio,
816     uint256 _borrowRate,
817     uint256 _originationFee
818   ) external;
819 
820   function removeCollateral(address _collateralType) external;
821 
822   function setCollateralDebtLimit(address _collateralType, uint256 _debtLimit) external;
823 
824   function setCollateralMinCollateralRatio(address _collateralType, uint256 _minCollateralRatio) external;
825 
826   function setCollateralBorrowRate(address _collateralType, uint256 _borrowRate) external;
827 
828   function setCollateralOriginationFee(address _collateralType, uint256 _originationFee) external;
829 
830   function setLiquidationBonus(uint256 _bonus) external;
831 
832   function collateralDebtLimit(address _collateralType) external view returns (uint256);
833 
834   function collateralMinCollateralRatio(address _collateralType) external view returns (uint256);
835 
836   function collateralBorrowRate(address _collateralType) external view returns (uint256);
837 
838   function collateralOriginationFee(address _collateralType) external view returns (uint256);
839 }
840 
841 // 
842 interface ISTABLEX is IERC20 {
843   function a() external view returns (IAddressProvider);
844 
845   function mint(address account, uint256 amount) external;
846 
847   function burn(address account, uint256 amount) external;
848 }
849 
850 // 
851 interface AggregatorV3Interface {
852   function decimals() external view returns (uint8);
853 
854   function description() external view returns (string memory);
855 
856   function version() external view returns (uint256);
857 
858   function getRoundData(uint80 _roundId)
859     external
860     view
861     returns (
862       uint80 roundId,
863       int256 answer,
864       uint256 startedAt,
865       uint256 updatedAt,
866       uint80 answeredInRound
867     );
868 
869   function latestRoundData()
870     external
871     view
872     returns (
873       uint80 roundId,
874       int256 answer,
875       uint256 startedAt,
876       uint256 updatedAt,
877       uint80 answeredInRound
878     );
879 }
880 
881 // 
882 interface IPriceFeed {
883   event OracleUpdated(address indexed asset, address oracle);
884 
885   function a() external view returns (IAddressProvider);
886 
887   function setAssetOracle(address _asset, address _oracle) external;
888 
889   function assetOracles(address _asset) external view returns (AggregatorV3Interface);
890 
891   function getAssetPrice(address _asset) external view returns (uint256);
892 
893   function convertFrom(address _asset, uint256 _balance) external view returns (uint256);
894 
895   function convertTo(address _asset, uint256 _balance) external view returns (uint256);
896 }
897 
898 // 
899 interface IRatesManager {
900   function a() external view returns (IAddressProvider);
901 
902   //current annualized borrow rate
903   function annualizedBorrowRate(uint256 _currentBorrowRate) external pure returns (uint256);
904 
905   //uses current cumulative rate to calculate totalDebt based on baseDebt at time T0
906   function calculateDebt(uint256 _baseDebt, uint256 _cumulativeRate) external pure returns (uint256);
907 
908   //uses current cumulative rate to calculate baseDebt at time T0
909   function calculateBaseDebt(uint256 _debt, uint256 _cumulativeRate) external pure returns (uint256);
910 
911   //calculate a new cumulative rate
912   function calculateCumulativeRate(
913     uint256 _borrowRate,
914     uint256 _cumulativeRate,
915     uint256 _timeElapsed
916   ) external view returns (uint256);
917 }
918 
919 // 
920 interface ILiquidationManager {
921   function a() external view returns (IAddressProvider);
922 
923   function calculateHealthFactor(
924     address _collateralType,
925     uint256 _collateralValue,
926     uint256 _vaultDebt
927   ) external view returns (uint256 healthFactor);
928 
929   function liquidationBonus(uint256 _amount) external view returns (uint256 bonus);
930 
931   function applyLiquidationDiscount(uint256 _amount) external view returns (uint256 discountedAmount);
932 
933   function isHealthy(
934     address _collateralType,
935     uint256 _collateralValue,
936     uint256 _vaultDebt
937   ) external view returns (bool);
938 }
939 
940 // 
941 interface IVaultsDataProvider {
942   struct Vault {
943     // borrowedType support USDX / PAR
944     address collateralType;
945     address owner;
946     uint256 collateralBalance;
947     uint256 baseDebt;
948     uint256 createdAt;
949   }
950 
951   function a() external view returns (IAddressProvider);
952 
953   // Read
954   function baseDebt(address _collateralType) external view returns (uint256);
955 
956   function vaultCount() external view returns (uint256);
957 
958   function vaults(uint256 _id) external view returns (Vault memory);
959 
960   function vaultOwner(uint256 _id) external view returns (address);
961 
962   function vaultCollateralType(uint256 _id) external view returns (address);
963 
964   function vaultCollateralBalance(uint256 _id) external view returns (uint256);
965 
966   function vaultBaseDebt(uint256 _id) external view returns (uint256);
967 
968   function vaultId(address _collateralType, address _owner) external view returns (uint256);
969 
970   function vaultExists(uint256 _id) external view returns (bool);
971 
972   function vaultDebt(uint256 _vaultId) external view returns (uint256);
973 
974   function debt() external view returns (uint256);
975 
976   function collateralDebt(address _collateralType) external view returns (uint256);
977 
978   //Write
979   function createVault(address _collateralType, address _owner) external returns (uint256);
980 
981   function setCollateralBalance(uint256 _id, uint256 _balance) external;
982 
983   function setBaseDebt(uint256 _id, uint256 _newBaseDebt) external;
984 }
985 
986 // 
987 interface IFeeDistributor {
988   event PayeeAdded(address indexed account, uint256 shares);
989   event FeeReleased(uint256 income, uint256 releasedAt);
990 
991   function a() external view returns (IAddressProvider);
992 
993   function lastReleasedAt() external view returns (uint256);
994 
995   function getPayees() external view returns (address[] memory);
996 
997   function totalShares() external view returns (uint256);
998 
999   function shares(address payee) external view returns (uint256);
1000 
1001   function release() external;
1002 
1003   function changePayees(address[] memory _payees, uint256[] memory _shares) external;
1004 }
1005 
1006 // 
1007 interface IAddressProvider {
1008   function controller() external view returns (IAccessController);
1009 
1010   function config() external view returns (IConfigProvider);
1011 
1012   function core() external view returns (IVaultsCore);
1013 
1014   function stablex() external view returns (ISTABLEX);
1015 
1016   function ratesManager() external view returns (IRatesManager);
1017 
1018   function priceFeed() external view returns (IPriceFeed);
1019 
1020   function liquidationManager() external view returns (ILiquidationManager);
1021 
1022   function vaultsData() external view returns (IVaultsDataProvider);
1023 
1024   function feeDistributor() external view returns (IFeeDistributor);
1025 
1026   function setAccessController(IAccessController _controller) external;
1027 
1028   function setConfigProvider(IConfigProvider _config) external;
1029 
1030   function setVaultsCore(IVaultsCore _core) external;
1031 
1032   function setStableX(ISTABLEX _stablex) external;
1033 
1034   function setRatesManager(IRatesManager _ratesManager) external;
1035 
1036   function setPriceFeed(IPriceFeed _priceFeed) external;
1037 
1038   function setLiquidationManager(ILiquidationManager _liquidationManager) external;
1039 
1040   function setVaultsDataProvider(IVaultsDataProvider _vaultsData) external;
1041 
1042   function setFeeDistributor(IFeeDistributor _feeDistributor) external;
1043 }
1044 
1045 // solium-disable security/no-block-members
1046 // 
1047 /**
1048  * @title  PAR
1049  * @notice  Stablecoin which can be minted against collateral in a vault
1050  */
1051 contract PAR is ISTABLEX, ERC20("PAR Stablecoin", "PAR") {
1052   IAddressProvider public override a;
1053 
1054   constructor(IAddressProvider _addresses) public {
1055     require(address(_addresses) != address(0));
1056     a = _addresses;
1057   }
1058 
1059   function mint(address account, uint256 amount) public override onlyMinter {
1060     _mint(account, amount);
1061   }
1062 
1063   function burn(address account, uint256 amount) public override onlyMinter {
1064     _burn(account, amount);
1065   }
1066 
1067   modifier onlyMinter() {
1068     require(a.controller().hasRole(a.controller().MINTER_ROLE(), msg.sender), "Caller is not a minter");
1069     _;
1070   }
1071 }