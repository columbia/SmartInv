1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.7.1;
3 
4 // File: @openzeppelin/contracts/GSN/Context.sol
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 // File: @openzeppelin/contracts/math/SafeMath.sol
104 
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
261 // File: @openzeppelin/contracts/utils/Address.sol
262 
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
285         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
286         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
287         // for accounts without code, i.e. `keccak256('')`
288         bytes32 codehash;
289         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
290         // solhint-disable-next-line no-inline-assembly
291         assembly { codehash := extcodehash(account) }
292         return (codehash != accountHash && codehash != 0x0);
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
401 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
402 
403 
404 
405 
406 
407 /**
408  * @dev Implementation of the {IERC20} interface.
409  *
410  * This implementation is agnostic to the way tokens are created. This means
411  * that a supply mechanism has to be added in a derived contract using {_mint}.
412  * For a generic mechanism see {ERC20PresetMinterPauser}.
413  *
414  * TIP: For a detailed writeup see our guide
415  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
416  * to implement supply mechanisms].
417  *
418  * We have followed general OpenZeppelin guidelines: functions revert instead
419  * of returning `false` on failure. This behavior is nonetheless conventional
420  * and does not conflict with the expectations of ERC20 applications.
421  *
422  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
423  * This allows applications to reconstruct the allowance for all accounts just
424  * by listening to said events. Other implementations of the EIP may not emit
425  * these events, as it isn't required by the specification.
426  *
427  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
428  * functions have been added to mitigate the well-known issues around setting
429  * allowances. See {IERC20-approve}.
430  */
431 contract ERC20 is Context, IERC20 {
432     using SafeMath for uint256;
433     using Address for address;
434 
435     mapping (address => uint256) private _balances;
436 
437     mapping (address => mapping (address => uint256)) private _allowances;
438 
439     uint256 private _totalSupply;
440 
441     string private _name;
442     string private _symbol;
443     uint8 private _decimals;
444 
445     /**
446      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
447      * a default value of 18.
448      *
449      * To select a different value for {decimals}, use {_setupDecimals}.
450      *
451      * All three of these values are immutable: they can only be set once during
452      * construction.
453      */
454     constructor (string memory name_, string memory symbol_) {
455         _name = name_;
456         _symbol = symbol_;
457         _decimals = 18;
458     }
459 
460     /**
461      * @dev Returns the name of the token.
462      */
463     function name() public view returns (string memory) {
464         return _name;
465     }
466 
467     /**
468      * @dev Returns the symbol of the token, usually a shorter version of the
469      * name.
470      */
471     function symbol() public view returns (string memory) {
472         return _symbol;
473     }
474 
475     /**
476      * @dev Returns the number of decimals used to get its user representation.
477      * For example, if `decimals` equals `2`, a balance of `505` tokens should
478      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
479      *
480      * Tokens usually opt for a value of 18, imitating the relationship between
481      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
482      * called.
483      *
484      * NOTE: This information is only used for _display_ purposes: it in
485      * no way affects any of the arithmetic of the contract, including
486      * {IERC20-balanceOf} and {IERC20-transfer}.
487      */
488     function decimals() public view returns (uint8) {
489         return _decimals;
490     }
491 
492     /**
493      * @dev See {IERC20-totalSupply}.
494      */
495     function totalSupply() public view override returns (uint256) {
496         return _totalSupply;
497     }
498 
499     /**
500      * @dev See {IERC20-balanceOf}.
501      */
502     function balanceOf(address account) public view override returns (uint256) {
503         return _balances[account];
504     }
505 
506     /**
507      * @dev See {IERC20-transfer}.
508      *
509      * Requirements:
510      *
511      * - `recipient` cannot be the zero address.
512      * - the caller must have a balance of at least `amount`.
513      */
514     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
515         _transfer(_msgSender(), recipient, amount);
516         return true;
517     }
518 
519     /**
520      * @dev See {IERC20-allowance}.
521      */
522     function allowance(address owner, address spender) public view virtual override returns (uint256) {
523         return _allowances[owner][spender];
524     }
525 
526     /**
527      * @dev See {IERC20-approve}.
528      *
529      * Requirements:
530      *
531      * - `spender` cannot be the zero address.
532      */
533     function approve(address spender, uint256 amount) public virtual override returns (bool) {
534         _approve(_msgSender(), spender, amount);
535         return true;
536     }
537 
538     /**
539      * @dev See {IERC20-transferFrom}.
540      *
541      * Emits an {Approval} event indicating the updated allowance. This is not
542      * required by the EIP. See the note at the beginning of {ERC20};
543      *
544      * Requirements:
545      * - `sender` and `recipient` cannot be the zero address.
546      * - `sender` must have a balance of at least `amount`.
547      * - the caller must have allowance for ``sender``'s tokens of at least
548      * `amount`.
549      */
550     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
551         _transfer(sender, recipient, amount);
552         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
553         return true;
554     }
555 
556     /**
557      * @dev Atomically increases the allowance granted to `spender` by the caller.
558      *
559      * This is an alternative to {approve} that can be used as a mitigation for
560      * problems described in {IERC20-approve}.
561      *
562      * Emits an {Approval} event indicating the updated allowance.
563      *
564      * Requirements:
565      *
566      * - `spender` cannot be the zero address.
567      */
568     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
569         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
570         return true;
571     }
572 
573     /**
574      * @dev Atomically decreases the allowance granted to `spender` by the caller.
575      *
576      * This is an alternative to {approve} that can be used as a mitigation for
577      * problems described in {IERC20-approve}.
578      *
579      * Emits an {Approval} event indicating the updated allowance.
580      *
581      * Requirements:
582      *
583      * - `spender` cannot be the zero address.
584      * - `spender` must have allowance for the caller of at least
585      * `subtractedValue`.
586      */
587     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
588         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
589         return true;
590     }
591 
592     /**
593      * @dev Moves tokens `amount` from `sender` to `recipient`.
594      *
595      * This is internal function is equivalent to {transfer}, and can be used to
596      * e.g. implement automatic token fees, slashing mechanisms, etc.
597      *
598      * Emits a {Transfer} event.
599      *
600      * Requirements:
601      *
602      * - `sender` cannot be the zero address.
603      * - `recipient` cannot be the zero address.
604      * - `sender` must have a balance of at least `amount`.
605      */
606     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
607         require(sender != address(0), "ERC20: transfer from the zero address");
608         require(recipient != address(0), "ERC20: transfer to the zero address");
609 
610         _beforeTokenTransfer(sender, recipient, amount);
611 
612         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
613         _balances[recipient] = _balances[recipient].add(amount);
614         emit Transfer(sender, recipient, amount);
615     }
616 
617     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
618      * the total supply.
619      *
620      * Emits a {Transfer} event with `from` set to the zero address.
621      *
622      * Requirements
623      *
624      * - `to` cannot be the zero address.
625      */
626     function _mint(address account, uint256 amount) internal virtual {
627         require(account != address(0), "ERC20: mint to the zero address");
628 
629         _beforeTokenTransfer(address(0), account, amount);
630 
631         _totalSupply = _totalSupply.add(amount);
632         _balances[account] = _balances[account].add(amount);
633         emit Transfer(address(0), account, amount);
634     }
635 
636     /**
637      * @dev Destroys `amount` tokens from `account`, reducing the
638      * total supply.
639      *
640      * Emits a {Transfer} event with `to` set to the zero address.
641      *
642      * Requirements
643      *
644      * - `account` cannot be the zero address.
645      * - `account` must have at least `amount` tokens.
646      */
647     function _burn(address account, uint256 amount) internal virtual {
648         require(account != address(0), "ERC20: burn from the zero address");
649 
650         _beforeTokenTransfer(account, address(0), amount);
651 
652         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
653         _totalSupply = _totalSupply.sub(amount);
654         emit Transfer(account, address(0), amount);
655     }
656 
657     /**
658      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
659      *
660      * This internal function is equivalent to `approve`, and can be used to
661      * e.g. set automatic allowances for certain subsystems, etc.
662      *
663      * Emits an {Approval} event.
664      *
665      * Requirements:
666      *
667      * - `owner` cannot be the zero address.
668      * - `spender` cannot be the zero address.
669      */
670     function _approve(address owner, address spender, uint256 amount) internal virtual {
671         require(owner != address(0), "ERC20: approve from the zero address");
672         require(spender != address(0), "ERC20: approve to the zero address");
673 
674         _allowances[owner][spender] = amount;
675         emit Approval(owner, spender, amount);
676     }
677 
678     /**
679      * @dev Sets {decimals} to a value other than the default one of 18.
680      *
681      * WARNING: This function should only be called from the constructor. Most
682      * applications that interact with token contracts will not expect
683      * {decimals} to ever change, and may work incorrectly if it does.
684      */
685     function _setupDecimals(uint8 decimals_) internal {
686         _decimals = decimals_;
687     }
688 
689     /**
690      * @dev Hook that is called before any transfer of tokens. This includes
691      * minting and burning.
692      *
693      * Calling conditions:
694      *
695      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
696      * will be to transferred to `to`.
697      * - when `from` is zero, `amount` tokens will be minted for `to`.
698      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
699      * - `from` and `to` are never both zero.
700      *
701      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
702      */
703     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
704 }
705 
706 // File: @openzeppelin/contracts/utils/SafeCast.sol
707 
708 
709 /**
710  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
711  * checks.
712  *
713  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
714  * easily result in undesired exploitation or bugs, since developers usually
715  * assume that overflows raise errors. `SafeCast` restores this intuition by
716  * reverting the transaction when such an operation overflows.
717  *
718  * Using this library instead of the unchecked operations eliminates an entire
719  * class of bugs, so it's recommended to use it always.
720  *
721  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
722  * all math on `uint256` and `int256` and then downcasting.
723  */
724 library SafeCast {
725 
726     /**
727      * @dev Returns the downcasted uint128 from uint256, reverting on
728      * overflow (when the input is greater than largest uint128).
729      *
730      * Counterpart to Solidity's `uint128` operator.
731      *
732      * Requirements:
733      *
734      * - input must fit into 128 bits
735      */
736     function toUint128(uint256 value) internal pure returns (uint128) {
737         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
738         return uint128(value);
739     }
740 
741     /**
742      * @dev Returns the downcasted uint64 from uint256, reverting on
743      * overflow (when the input is greater than largest uint64).
744      *
745      * Counterpart to Solidity's `uint64` operator.
746      *
747      * Requirements:
748      *
749      * - input must fit into 64 bits
750      */
751     function toUint64(uint256 value) internal pure returns (uint64) {
752         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
753         return uint64(value);
754     }
755 
756     /**
757      * @dev Returns the downcasted uint32 from uint256, reverting on
758      * overflow (when the input is greater than largest uint32).
759      *
760      * Counterpart to Solidity's `uint32` operator.
761      *
762      * Requirements:
763      *
764      * - input must fit into 32 bits
765      */
766     function toUint32(uint256 value) internal pure returns (uint32) {
767         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
768         return uint32(value);
769     }
770 
771     /**
772      * @dev Returns the downcasted uint16 from uint256, reverting on
773      * overflow (when the input is greater than largest uint16).
774      *
775      * Counterpart to Solidity's `uint16` operator.
776      *
777      * Requirements:
778      *
779      * - input must fit into 16 bits
780      */
781     function toUint16(uint256 value) internal pure returns (uint16) {
782         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
783         return uint16(value);
784     }
785 
786     /**
787      * @dev Returns the downcasted uint8 from uint256, reverting on
788      * overflow (when the input is greater than largest uint8).
789      *
790      * Counterpart to Solidity's `uint8` operator.
791      *
792      * Requirements:
793      *
794      * - input must fit into 8 bits.
795      */
796     function toUint8(uint256 value) internal pure returns (uint8) {
797         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
798         return uint8(value);
799     }
800 
801     /**
802      * @dev Converts a signed int256 into an unsigned uint256.
803      *
804      * Requirements:
805      *
806      * - input must be greater than or equal to 0.
807      */
808     function toUint256(int256 value) internal pure returns (uint256) {
809         require(value >= 0, "SafeCast: value must be positive");
810         return uint256(value);
811     }
812 
813     /**
814      * @dev Returns the downcasted int128 from int256, reverting on
815      * overflow (when the input is less than smallest int128 or
816      * greater than largest int128).
817      *
818      * Counterpart to Solidity's `int128` operator.
819      *
820      * Requirements:
821      *
822      * - input must fit into 128 bits
823      *
824      * _Available since v3.1._
825      */
826     function toInt128(int256 value) internal pure returns (int128) {
827         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
828         return int128(value);
829     }
830 
831     /**
832      * @dev Returns the downcasted int64 from int256, reverting on
833      * overflow (when the input is less than smallest int64 or
834      * greater than largest int64).
835      *
836      * Counterpart to Solidity's `int64` operator.
837      *
838      * Requirements:
839      *
840      * - input must fit into 64 bits
841      *
842      * _Available since v3.1._
843      */
844     function toInt64(int256 value) internal pure returns (int64) {
845         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
846         return int64(value);
847     }
848 
849     /**
850      * @dev Returns the downcasted int32 from int256, reverting on
851      * overflow (when the input is less than smallest int32 or
852      * greater than largest int32).
853      *
854      * Counterpart to Solidity's `int32` operator.
855      *
856      * Requirements:
857      *
858      * - input must fit into 32 bits
859      *
860      * _Available since v3.1._
861      */
862     function toInt32(int256 value) internal pure returns (int32) {
863         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
864         return int32(value);
865     }
866 
867     /**
868      * @dev Returns the downcasted int16 from int256, reverting on
869      * overflow (when the input is less than smallest int16 or
870      * greater than largest int16).
871      *
872      * Counterpart to Solidity's `int16` operator.
873      *
874      * Requirements:
875      *
876      * - input must fit into 16 bits
877      *
878      * _Available since v3.1._
879      */
880     function toInt16(int256 value) internal pure returns (int16) {
881         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
882         return int16(value);
883     }
884 
885     /**
886      * @dev Returns the downcasted int8 from int256, reverting on
887      * overflow (when the input is less than smallest int8 or
888      * greater than largest int8).
889      *
890      * Counterpart to Solidity's `int8` operator.
891      *
892      * Requirements:
893      *
894      * - input must fit into 8 bits.
895      *
896      * _Available since v3.1._
897      */
898     function toInt8(int256 value) internal pure returns (int8) {
899         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
900         return int8(value);
901     }
902 
903     /**
904      * @dev Converts an unsigned uint256 into a signed int256.
905      *
906      * Requirements:
907      *
908      * - input must be less than or equal to maxInt256.
909      */
910     function toInt256(uint256 value) internal pure returns (int256) {
911         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
912         return int256(value);
913     }
914 }
915 
916 // File: contracts/util/AddressList.sol
917 
918 library AddressList {
919     /**
920      * @dev Inserts token address in addressList except for zero address.
921      */
922     function insert(address[] storage addressList, address token) internal {
923         if (token == address(0)) {
924             return;
925         }
926 
927         for (uint256 i = 0; i < addressList.length; i++) {
928             if (addressList[i] == address(0)) {
929                 addressList[i] = token;
930                 return;
931             }
932         }
933 
934         addressList.push(token);
935     }
936 
937     /**
938      * @dev Removes token address from addressList except for zero address.
939      */
940     function remove(address[] storage addressList, address token) internal returns (bool success) {
941         if (token == address(0)) {
942             return true;
943         }
944 
945         for (uint256 i = 0; i < addressList.length; i++) {
946             if (addressList[i] == token) {
947                 delete addressList[i];
948                 return true;
949             }
950         }
951     }
952 
953     /**
954      * @dev Returns the addresses included in addressList except for zero address.
955      */
956     function get(address[] storage addressList)
957         internal
958         view
959         returns (address[] memory denseAddressList)
960     {
961         uint256 numOfElements = 0;
962         for (uint256 i = 0; i < addressList.length; i++) {
963             if (addressList[i] != address(0)) {
964                 numOfElements++;
965             }
966         }
967 
968         denseAddressList = new address[](numOfElements);
969         uint256 j = 0;
970         for (uint256 i = 0; i < addressList.length; i++) {
971             if (addressList[i] != address(0)) {
972                 denseAddressList[j] = addressList[i];
973                 j++;
974             }
975         }
976     }
977 }
978 
979 // File: contracts/token/Whitelist.sol
980 
981 
982 contract Whitelist {
983     using AddressList for address[];
984 
985     /* ========== STATE VARIABLES ========== */
986 
987     /**
988      * @dev mapping from user address to whitelist token addresses
989      */
990     address[] internal _whitelist;
991 
992     /* ========== INTERNAL FUNCTIONS ========== */
993 
994     /**
995      * @dev Inserts token address in _whitelist except for ETH (= address(0)).
996      */
997     function _addWhitelist(address token) internal {
998         return _whitelist.insert(token);
999     }
1000 
1001     /**
1002      * @dev Removes token address from _whitelist except for ETH (= address(0)).
1003      */
1004     function _removeWhitelist(address token) internal returns (bool success) {
1005         return _whitelist.remove(token);
1006     }
1007 
1008     /**
1009      * @dev Returns the addresses included in _whitelist except for zero address.
1010      */
1011     function _getWhitelist() internal view returns (address[] memory) {
1012         return _whitelist.get();
1013     }
1014 }
1015 
1016 // File: contracts/oracle/OracleInterface.sol
1017 
1018 /**
1019  * @dev Oracle referenced by OracleProxy must implement this interface.
1020  */
1021 interface OracleInterface {
1022     function latestAnswer() external view returns (int256);
1023 
1024     function decimals() external view returns (uint8);
1025 }
1026 
1027 // File: contracts/token/TaxToken.sol
1028 
1029 
1030 
1031 
1032 
1033 
1034 contract TaxToken is ERC20("TAX", "TAX"), Whitelist {
1035     using SafeMath for uint256;
1036     using SafeMath for uint128;
1037     using SafeCast for uint256;
1038 
1039     /* ========== CONSTANT VARIABLES ========== */
1040 
1041     address internal immutable _deployer;
1042     uint256 internal immutable _halvingStartLendValue;
1043     uint256 internal immutable _maxTotalSupply;
1044     uint256 internal immutable _initialMintUnit;
1045     uint256 internal immutable _developerFundRateE8;
1046     uint256 internal immutable _incentiveFundRateE8;
1047 
1048     /* ========== STATE VARIABLES ========== */
1049 
1050     address[] internal _incentiveFundAddresses;
1051     uint256[] internal _incentiveFundAllocationE8;
1052 
1053     uint128 internal _developerFund;
1054     uint128 internal _incentiveFund;
1055     uint128 internal _totalLendValue;
1056 
1057     address internal _governanceAddress;
1058     address internal _developer;
1059     address internal _lendingAddress;
1060 
1061     mapping(address => address) internal _tokenPriceOracle;
1062 
1063     /* ========== EVENTS ========== */
1064 
1065     event LogUpdateGovernanceAddress(address newAddress);
1066     event LogUpdateLendingAddress(address newAddress);
1067     event LogRegisterWhitelist(address tokenAddress, address oracleAddress);
1068     event LogUnregisterWhitelist(address tokenAddress);
1069     event LogUpdateIncentiveAddresses(
1070         address[] newIncentiveAddresses,
1071         uint256[] newIncentiveAllocationE8
1072     );
1073 
1074     /* ========== CONSTRUCTOR ========== */
1075 
1076     constructor(
1077         address governanceAddress,
1078         address developer,
1079         address[] memory incentiveFundAddresses,
1080         uint256[] memory incentiveFundAllocationE8,
1081         uint256 developerFundRateE8,
1082         uint256 incentiveFundRateE8,
1083         address lendingAddress,
1084         uint256 halvingStartLendValue,
1085         uint256 maxTotalSupply,
1086         uint256 initialMintUnit
1087     ) {
1088         _deployer = msg.sender;
1089         _governanceAddress = governanceAddress; // governance address can update or delete whitelist
1090         _developer = developer; // developer fund address
1091         _incentiveFundAddresses = incentiveFundAddresses; // incentive fund addresses. ex) uniswap share token staking contract address
1092         _incentiveFundAllocationE8 = incentiveFundAllocationE8; //[0.3 * 10**8, 0.7 * 10**8]. sum should be 10**8
1093         _developerFundRateE8 = developerFundRateE8; // developer fund rate. when 5%, should be set as 0.05 * 10**8
1094         _incentiveFundRateE8 = incentiveFundRateE8; // incentive fund rate. when 10%, should be set as 0.1 * 10**8
1095         _lendingAddress = lendingAddress; // lending contract address
1096         _halvingStartLendValue = halvingStartLendValue; // the amount of totalLendValue that initial halving occurs. set at 2 * 10**8 = 200M dollar
1097         _maxTotalSupply = maxTotalSupply; // total supply of tax token, set at 1 * 10**9 * 10**18 = 1B tax
1098         _initialMintUnit = initialMintUnit; // amount to mint per unit, set at 1 * 10**18
1099 
1100         require(
1101             _incentiveFundAddresses.length == _incentiveFundAllocationE8.length,
1102             "the length of the addresses and their allocation should be the same"
1103         );
1104         uint256 sumcheck = 0;
1105         for (uint256 i = 0; i < _incentiveFundAllocationE8.length; i++) {
1106             sumcheck = sumcheck.add(_incentiveFundAllocationE8[i]);
1107         }
1108         require(sumcheck == 10**8, "the sum of the allocation should be 10**8");
1109     }
1110 
1111     /* ========== MODIFIERS ========== */
1112 
1113     modifier onlyGovernance() {
1114         require(msg.sender == _governanceAddress, "only governance address can call");
1115         _;
1116     }
1117 
1118     modifier onlyLending() {
1119         require(msg.sender == _lendingAddress, "only lending contract address can call");
1120         _;
1121     }
1122 
1123     /* ========== MUTATIVE FUNCTIONS ========== */
1124 
1125     /**
1126      * @notice mint token only when the lended ERC20 is whitelisted.
1127      * @dev this contract will not function when the total lend value of whitelisted tokens exceeds 2**128 dollar.
1128      * this contract will lose value when the oracle of the whitelisted tokens collapses and returns an extraordinary large number.
1129      */
1130     function mintToken(
1131         address tokenAddress,
1132         uint256 lendAmount,
1133         address recipient
1134     ) external onlyLending {
1135         if (_maxTotalSupply == totalSupply()) {
1136             return;
1137         }
1138         uint8 decimalsOfLendingToken = 18; // decimals of ETH
1139         if (tokenAddress != address(0)) {
1140             decimalsOfLendingToken = ERC20(tokenAddress).decimals();
1141         }
1142 
1143         address oracle = _tokenPriceOracle[tokenAddress];
1144         uint256 mintAmount = 0;
1145         if (oracle != address(0)) {
1146             OracleInterface oracleContract = OracleInterface(oracle);
1147             uint256 price = uint256(oracleContract.latestAnswer());
1148             uint8 decimalsOfOraclePrice = oracleContract.decimals();
1149             uint256 asOfMintUnit = _getMintUnit();
1150             uint256 lendValue = lendAmount.mul(price).div(
1151                 10**uint256(decimalsOfOraclePrice + decimalsOfLendingToken)
1152             );
1153             _totalLendValue = _totalLendValue.add(lendValue).toUint128();
1154             mintAmount = lendValue.mul(asOfMintUnit);
1155             uint256 remainingMintableAmount = _maxTotalSupply.sub(
1156                 totalSupply().add(_developerFund).add(_incentiveFund)
1157             );
1158             mintAmount = remainingMintableAmount >= mintAmount
1159                 ? mintAmount
1160                 : remainingMintableAmount;
1161         }
1162         if (mintAmount != 0) {
1163             uint256 devFund = mintAmount.mul(_developerFundRateE8) / 10**8;
1164             uint256 incFund = mintAmount.mul(_incentiveFundRateE8) / 10**8;
1165             _developerFund = _developerFund.add(devFund).toUint128();
1166             _incentiveFund = _incentiveFund.add(incFund).toUint128();
1167             _mint(recipient, mintAmount.sub(devFund).sub(incFund));
1168         }
1169     }
1170 
1171     /**
1172      * @notice governanceAddress can add/override ERC20 token to the whitelist with the oracle address.
1173      * any ERC20 token can use the lending contract, but only the whitelisted addresses can earn tax token.
1174      */
1175     function registerWhitelist(address tokenAddress, address oracleAddress)
1176         external
1177         onlyGovernance
1178     {
1179         OracleInterface oracleContract = OracleInterface(oracleAddress);
1180         oracleContract.decimals();
1181         oracleContract.latestAnswer();
1182 
1183         _tokenPriceOracle[tokenAddress] = oracleAddress;
1184         _addWhitelist(tokenAddress);
1185 
1186         emit LogRegisterWhitelist(tokenAddress, oracleAddress);
1187     }
1188 
1189     /**
1190      * @notice governanceAddress can delist from the whitelist.
1191      */
1192     function unregisterWhitelist(address tokenAddress) external onlyGovernance {
1193         delete _tokenPriceOracle[tokenAddress];
1194         _removeWhitelist(tokenAddress);
1195 
1196         emit LogUnregisterWhitelist(tokenAddress);
1197     }
1198 
1199     /**
1200      * @notice lendingAddress can be updated by the deployer.
1201      * @dev can be used only before the deployer transfers the rights of governance
1202      */
1203     function updateLendingAddress(address newLendingAddress) external onlyGovernance {
1204         _lendingAddress = newLendingAddress;
1205 
1206         emit LogUpdateLendingAddress(newLendingAddress);
1207     }
1208 
1209     /**
1210      * @notice only governance contract can update incentive addresses and their allocation.
1211      */
1212     function updateIncentiveAddresses(
1213         address[] memory newIncentiveAddresses,
1214         uint256[] memory newIncentiveAllocation
1215     ) external onlyGovernance {
1216         require(
1217             newIncentiveAddresses.length == newIncentiveAllocation.length,
1218             "the length of the addresses and the allocation should be the same"
1219         );
1220         uint256 sumcheck = 0;
1221         for (uint256 i = 0; i < newIncentiveAllocation.length; i++) {
1222             sumcheck = sumcheck.add(newIncentiveAllocation[i]);
1223         }
1224         require(sumcheck == 10**8, "the sum of the allocation should be 10**8");
1225 
1226         _incentiveFundAddresses = newIncentiveAddresses;
1227         _incentiveFundAllocationE8 = newIncentiveAllocation;
1228 
1229         emit LogUpdateIncentiveAddresses(newIncentiveAddresses, newIncentiveAllocation);
1230     }
1231 
1232     /**
1233      * @notice governanceAddress can be updated by the deployer.
1234      * @dev can be used only before the deployer transfers the rights of governance
1235      */
1236     function updateGovernanceAddress(address newGovernanceAddress) external onlyGovernance {
1237         _governanceAddress = newGovernanceAddress;
1238 
1239         emit LogUpdateGovernanceAddress(newGovernanceAddress);
1240     }
1241 
1242     /**
1243      * @notice mint tax token to the developer address up to the available amount.
1244      */
1245     function mintDeveloperFund() external {
1246         uint256 amount = _developerFund;
1247         _developerFund = 0;
1248         require(amount != 0, "no mintable amount");
1249         _mint(_developer, amount);
1250     }
1251 
1252     /**
1253      * @notice mint tax token to the incentive fund addresses up to the available amount.
1254      */
1255     function mintIncentiveFund() external {
1256         uint256 amount = _incentiveFund;
1257         _incentiveFund = 0;
1258         require(amount != 0, "no mintable amount");
1259         require(_incentiveFundAddresses.length != 0, "incentive fund addresses have not been set");
1260         for (uint256 i = 0; i < _incentiveFundAddresses.length; i++) {
1261             _mint(_incentiveFundAddresses[i], amount.mul(_incentiveFundAllocationE8[i]).div(10**8));
1262         }
1263     }
1264 
1265     /* ========== INTERNAL FUNCTIONS ========== */
1266 
1267     function _getMintUnit() internal view returns (uint256 asOfMintUnit) {
1268         uint256 totalLendValue = _totalLendValue;
1269         asOfMintUnit = _initialMintUnit;
1270         while (totalLendValue >= _halvingStartLendValue) {
1271             asOfMintUnit = asOfMintUnit / 2;
1272             totalLendValue = totalLendValue / 2;
1273         }
1274         asOfMintUnit = totalSupply() == _maxTotalSupply ? 0 : asOfMintUnit;
1275     }
1276 
1277     /* ========== CALL FUNCTIONS ========== */
1278 
1279     /**
1280      * @return governance contract address
1281      */
1282     function getGovernanceAddress() external view returns (address) {
1283         return _governanceAddress;
1284     }
1285 
1286     /**
1287      * @return developer fund address
1288      */
1289     function getDeveloperAddress() external view returns (address) {
1290         return _developer;
1291     }
1292 
1293     /**
1294      * @return lending contract address.
1295      */
1296     function getLendingAddress() external view returns (address) {
1297         return _lendingAddress;
1298     }
1299 
1300     /**
1301      * @notice get the immutable initial config values.
1302      */
1303     function getConfigs()
1304         external
1305         view
1306         returns (
1307             uint256 maxTotalSupply,
1308             uint256 halvingStartLendValue,
1309             uint256 initialMintUnit,
1310             uint256 developerFundRateE8,
1311             uint256 incentiveFundRateE8
1312         )
1313     {
1314         maxTotalSupply = _maxTotalSupply;
1315         halvingStartLendValue = _halvingStartLendValue;
1316         initialMintUnit = _initialMintUnit;
1317         developerFundRateE8 = _developerFundRateE8;
1318         incentiveFundRateE8 = _incentiveFundRateE8;
1319     }
1320 
1321     function getWhitelist() external view returns (address[] memory) {
1322         return _getWhitelist();
1323     }
1324 
1325     /**
1326      * @notice Get the incentive addresses and their allocation.
1327      */
1328     function getIncentiveFundAddresses()
1329         external
1330         view
1331         returns (
1332             address[] memory incentiveFundAddresses,
1333             uint256[] memory incentiveFundAllocationE8
1334         )
1335     {
1336         incentiveFundAddresses = _incentiveFundAddresses;
1337         incentiveFundAllocationE8 = _incentiveFundAllocationE8;
1338     }
1339 
1340     /**
1341      * @notice Get the current mintable amount for developer fund and incentive fund.
1342      */
1343     function getFunds() external view returns (uint256 developerFund, uint256 incentiveFund) {
1344         developerFund = _developerFund;
1345         incentiveFund = _incentiveFund;
1346     }
1347 
1348     /**
1349      * @notice Get the current amount to be minted per a dollar of lending.
1350      * @dev the amount to mint per a dollar of lending decays exponentially.
1351      */
1352     function getMintUnit() external view returns (uint256) {
1353         return _getMintUnit();
1354     }
1355 
1356     /**
1357      * @return oracle address of the erc20.
1358      * @dev returns zero address when the erc20 is not whitelisted.
1359      */
1360     function getOracleAddress(address tokenAddress) external view returns (address) {
1361         return _tokenPriceOracle[tokenAddress];
1362     }
1363 }