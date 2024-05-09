1 pragma solidity ^0.6.0;
2 pragma solidity ^0.6.0;
3 pragma solidity ^0.6.0;
4 pragma solidity ^0.6.2;
5 pragma solidity ^0.6.0;
6 pragma solidity ^0.6.0;
7 pragma solidity 0.6.12;
8 
9 
10 /**
11  *Submitted for verification at Etherscan.io on 2020-08-26
12 */
13 // File: @openzeppelin/contracts/GSN/Context.sol
14 /*
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with GSN meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 /**
112  * @dev Wrappers over Solidity's arithmetic operations with added overflow
113  * checks.
114  *
115  * Arithmetic operations in Solidity wrap on overflow. This can easily result
116  * in bugs, because programmers usually assume that an overflow raises an
117  * error, which is the standard behavior in high level programming languages.
118  * `SafeMath` restores this intuition by reverting the transaction when an
119  * operation overflows.
120  *
121  * Using this library instead of the unchecked operations eliminates an entire
122  * class of bugs, so it's recommended to use it always.
123  */
124 library SafeMath {
125     /**
126      * @dev Returns the addition of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `+` operator.
130      *
131      * Requirements:
132      *
133      * - Addition cannot overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         return sub(a, b, "SafeMath: subtraction overflow");
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      *
181      * - Multiplication cannot overflow.
182      */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b > 0, errorMessage);
227         uint256 c = a / b;
228         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         return mod(a, b, "SafeMath: modulo by zero");
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts with custom message when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b != 0, errorMessage);
263         return a % b;
264     }
265 }
266 
267 // File: @openzeppelin/contracts/utils/Address.sol
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
291         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
292         // for accounts without code, i.e. `keccak256('')`
293         bytes32 codehash;
294         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
295         // solhint-disable-next-line no-inline-assembly
296         assembly { codehash := extcodehash(account) }
297         return (codehash != accountHash && codehash != 0x0);
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
320         (bool success, ) = recipient.call{ value: amount }("");
321         require(success, "Address: unable to send value, recipient may have reverted");
322     }
323 
324     /**
325      * @dev Performs a Solidity function call using a low level `call`. A
326      * plain`call` is an unsafe replacement for a function call: use this
327      * function instead.
328      *
329      * If `target` reverts with a revert reason, it is bubbled up by this
330      * function (like regular Solidity function calls).
331      *
332      * Returns the raw returned data. To convert to the expected return value,
333      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
334      *
335      * Requirements:
336      *
337      * - `target` must be a contract.
338      * - calling `target` with `data` must not revert.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
343       return functionCall(target, data, "Address: low-level call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
348      * `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
353         return _functionCallWithValue(target, data, 0, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but also transferring `value` wei to `target`.
359      *
360      * Requirements:
361      *
362      * - the calling contract must have an ETH balance of at least `value`.
363      * - the called Solidity function must be `payable`.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
373      * with `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
378         require(address(this).balance >= value, "Address: insufficient balance for call");
379         return _functionCallWithValue(target, data, value, errorMessage);
380     }
381 
382     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
383         require(isContract(target), "Address: call to non-contract");
384 
385         // solhint-disable-next-line avoid-low-level-calls
386         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
387         if (success) {
388             return returndata;
389         } else {
390             // Look for revert reason and bubble it up if present
391             if (returndata.length > 0) {
392                 // The easiest way to bubble the revert reason is using memory via assembly
393 
394                 // solhint-disable-next-line no-inline-assembly
395                 assembly {
396                     let returndata_size := mload(returndata)
397                     revert(add(32, returndata), returndata_size)
398                 }
399             } else {
400                 revert(errorMessage);
401             }
402         }
403     }
404 }
405 
406 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
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
454     constructor (string memory name, string memory symbol) public {
455         _name = name;
456         _symbol = symbol;
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
658      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
659      *
660      * This is internal function is equivalent to `approve`, and can be used to
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
706 // File: @openzeppelin/contracts/access/Ownable.sol
707 /**
708  * @dev Contract module which provides a basic access control mechanism, where
709  * there is an account (an owner) that can be granted exclusive access to
710  * specific functions.
711  *
712  * By default, the owner account will be the one that deploys the contract. This
713  * can later be changed with {transferOwnership}.
714  *
715  * This module is used through inheritance. It will make available the modifier
716  * `onlyOwner`, which can be applied to your functions to restrict their use to
717  * the owner.
718  */
719 contract Ownable is Context {
720     address private _owner;
721 
722     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
723 
724     /**
725      * @dev Initializes the contract setting the deployer as the initial owner.
726      */
727     constructor () internal {
728         address msgSender = _msgSender();
729         _owner = msgSender;
730         emit OwnershipTransferred(address(0), msgSender);
731     }
732 
733     /**
734      * @dev Returns the address of the current owner.
735      */
736     function owner() public view returns (address) {
737         return _owner;
738     }
739 
740     /**
741      * @dev Throws if called by any account other than the owner.
742      */
743     modifier onlyOwner() {
744         require(_owner == _msgSender(), "Ownable: caller is not the owner");
745         _;
746     }
747 
748     /**
749      * @dev Leaves the contract without owner. It will not be possible to call
750      * `onlyOwner` functions anymore. Can only be called by the current owner.
751      *
752      * NOTE: Renouncing ownership will leave the contract without an owner,
753      * thereby removing any functionality that is only available to the owner.
754      */
755     function renounceOwnership() public virtual onlyOwner {
756         emit OwnershipTransferred(_owner, address(0));
757         _owner = address(0);
758     }
759 
760     /**
761      * @dev Transfers ownership of the contract to a new account (`newOwner`).
762      * Can only be called by the current owner.
763      */
764     function transferOwnership(address newOwner) public virtual onlyOwner {
765         require(newOwner != address(0), "Ownable: new owner is the zero address");
766         emit OwnershipTransferred(_owner, newOwner);
767         _owner = newOwner;
768     }
769 }
770 
771 // SpringRollToken with Governance.
772 contract SpringRollToken is ERC20("SpringRollToken", "SPRINGROLL"), Ownable {
773     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
774     function mint(address _to, uint256 _amount) public onlyOwner {
775         _mint(_to, _amount);
776         _moveDelegates(address(0), _delegates[_to], _amount);
777     }
778 
779     // Copied and modified from YAM code:
780     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
781     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
782     // Which is copied and modified from COMPOUND:
783     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
784 
785     /// @notice A record of each accounts delegate
786     mapping (address => address) internal _delegates;
787 
788     /// @notice A checkpoint for marking number of votes from a given block
789     struct Checkpoint {
790         uint32 fromBlock;
791         uint256 votes;
792     }
793 
794     /// @notice A record of votes checkpoints for each account, by index
795     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
796 
797     /// @notice The number of checkpoints for each account
798     mapping (address => uint32) public numCheckpoints;
799 
800     /// @notice The EIP-712 typehash for the contract's domain
801     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
802 
803     /// @notice The EIP-712 typehash for the delegation struct used by the contract
804     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
805 
806     /// @notice A record of states for signing / validating signatures
807     mapping (address => uint) public nonces;
808 
809       /// @notice An event thats emitted when an account changes its delegate
810     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
811 
812     /// @notice An event thats emitted when a delegate account's vote balance changes
813     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
814 
815     /**
816      * @notice Delegate votes from `msg.sender` to `delegatee`
817      * @param delegator The address to get delegatee for
818      */
819     function delegates(address delegator)
820         external
821         view
822         returns (address)
823     {
824         return _delegates[delegator];
825     }
826 
827    /**
828     * @notice Delegate votes from `msg.sender` to `delegatee`
829     * @param delegatee The address to delegate votes to
830     */
831     function delegate(address delegatee) external {
832         return _delegate(msg.sender, delegatee);
833     }
834 
835     /**
836      * @notice Delegates votes from signatory to `delegatee`
837      * @param delegatee The address to delegate votes to
838      * @param nonce The contract state required to match the signature
839      * @param expiry The time at which to expire the signature
840      * @param v The recovery byte of the signature
841      * @param r Half of the ECDSA signature pair
842      * @param s Half of the ECDSA signature pair
843      */
844     function delegateBySig(
845         address delegatee,
846         uint nonce,
847         uint expiry,
848         uint8 v,
849         bytes32 r,
850         bytes32 s
851     )
852         external
853     {
854         bytes32 domainSeparator = keccak256(
855             abi.encode(
856                 DOMAIN_TYPEHASH,
857                 keccak256(bytes(name())),
858                 getChainId(),
859                 address(this)
860             )
861         );
862 
863         bytes32 structHash = keccak256(
864             abi.encode(
865                 DELEGATION_TYPEHASH,
866                 delegatee,
867                 nonce,
868                 expiry
869             )
870         );
871 
872         bytes32 digest = keccak256(
873             abi.encodePacked(
874                 "\x19\x01",
875                 domainSeparator,
876                 structHash
877             )
878         );
879 
880         address signatory = ecrecover(digest, v, r, s);
881         require(signatory != address(0), "SPRINGROLL::delegateBySig: invalid signature");
882         require(nonce == nonces[signatory]++, "SPRINGROLL::delegateBySig: invalid nonce");
883         require(now <= expiry, "SPRINGROLL::delegateBySig: signature expired");
884         return _delegate(signatory, delegatee);
885     }
886 
887     /**
888      * @notice Gets the current votes balance for `account`
889      * @param account The address to get votes balance
890      * @return The number of current votes for `account`
891      */
892     function getCurrentVotes(address account)
893         external
894         view
895         returns (uint256)
896     {
897         uint32 nCheckpoints = numCheckpoints[account];
898         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
899     }
900 
901     /**
902      * @notice Determine the prior number of votes for an account as of a block number
903      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
904      * @param account The address of the account to check
905      * @param blockNumber The block number to get the vote balance at
906      * @return The number of votes the account had as of the given block
907      */
908     function getPriorVotes(address account, uint blockNumber)
909         external
910         view
911         returns (uint256)
912     {
913         require(blockNumber < block.number, "SPRINGROLL::getPriorVotes: not yet determined");
914 
915         uint32 nCheckpoints = numCheckpoints[account];
916         if (nCheckpoints == 0) {
917             return 0;
918         }
919 
920         // First check most recent balance
921         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
922             return checkpoints[account][nCheckpoints - 1].votes;
923         }
924 
925         // Next check implicit zero balance
926         if (checkpoints[account][0].fromBlock > blockNumber) {
927             return 0;
928         }
929 
930         uint32 lower = 0;
931         uint32 upper = nCheckpoints - 1;
932         while (upper > lower) {
933             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
934             Checkpoint memory cp = checkpoints[account][center];
935             if (cp.fromBlock == blockNumber) {
936                 return cp.votes;
937             } else if (cp.fromBlock < blockNumber) {
938                 lower = center;
939             } else {
940                 upper = center - 1;
941             }
942         }
943         return checkpoints[account][lower].votes;
944     }
945 
946     function _delegate(address delegator, address delegatee)
947         internal
948     {
949         address currentDelegate = _delegates[delegator];
950         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SPRINGROLLs (not scaled);
951         _delegates[delegator] = delegatee;
952 
953         emit DelegateChanged(delegator, currentDelegate, delegatee);
954 
955         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
956     }
957 
958     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
959         if (srcRep != dstRep && amount > 0) {
960             if (srcRep != address(0)) {
961                 // decrease old representative
962                 uint32 srcRepNum = numCheckpoints[srcRep];
963                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
964                 uint256 srcRepNew = srcRepOld.sub(amount);
965                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
966             }
967 
968             if (dstRep != address(0)) {
969                 // increase new representative
970                 uint32 dstRepNum = numCheckpoints[dstRep];
971                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
972                 uint256 dstRepNew = dstRepOld.add(amount);
973                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
974             }
975         }
976     }
977 
978     function _writeCheckpoint(
979         address delegatee,
980         uint32 nCheckpoints,
981         uint256 oldVotes,
982         uint256 newVotes
983     )
984         internal
985     {
986         uint32 blockNumber = safe32(block.number, "SPRINGROLL::_writeCheckpoint: block number exceeds 32 bits");
987 
988         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
989             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
990         } else {
991             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
992             numCheckpoints[delegatee] = nCheckpoints + 1;
993         }
994 
995         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
996     }
997 
998     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
999         require(n < 2**32, errorMessage);
1000         return uint32(n);
1001     }
1002 
1003     function getChainId() internal pure returns (uint) {
1004         uint256 chainId;
1005         assembly { chainId := chainid() }
1006         return chainId;
1007     }
1008 }