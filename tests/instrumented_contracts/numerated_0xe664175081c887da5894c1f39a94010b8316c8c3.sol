1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 pragma solidity ^0.6.2;
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
30 
31 
32 pragma solidity ^0.6.2;
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
111 
112 pragma solidity ^0.6.2;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 // File: @openzeppelin/contracts/utils/Address.sol
271 
272 
273 
274 pragma solidity ^0.6.2;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
299         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
300         // for accounts without code, i.e. `keccak256('')`
301         bytes32 codehash;
302         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
303         // solhint-disable-next-line no-inline-assembly
304         assembly { codehash := extcodehash(account) }
305         return (codehash != accountHash && codehash != 0x0);
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
328         (bool success, ) = recipient.call{ value: amount }("");
329         require(success, "Address: unable to send value, recipient may have reverted");
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain`call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351       return functionCall(target, data, "Address: low-level call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
361         return _functionCallWithValue(target, data, 0, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but also transferring `value` wei to `target`.
367      *
368      * Requirements:
369      *
370      * - the calling contract must have an ETH balance of at least `value`.
371      * - the called Solidity function must be `payable`.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
376         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
381      * with `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
386         require(address(this).balance >= value, "Address: insufficient balance for call");
387         return _functionCallWithValue(target, data, value, errorMessage);
388     }
389 
390     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
391         require(isContract(target), "Address: call to non-contract");
392 
393         // solhint-disable-next-line avoid-low-level-calls
394         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
395         if (success) {
396             return returndata;
397         } else {
398             // Look for revert reason and bubble it up if present
399             if (returndata.length > 0) {
400                 // The easiest way to bubble the revert reason is using memory via assembly
401 
402                 // solhint-disable-next-line no-inline-assembly
403                 assembly {
404                     let returndata_size := mload(returndata)
405                     revert(add(32, returndata), returndata_size)
406                 }
407             } else {
408                 revert(errorMessage);
409             }
410         }
411     }
412 }
413 
414 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
415 
416 
417 
418 pragma solidity ^0.6.2;
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
672      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
673      *
674      * This is internal function is equivalent to `approve`, and can be used to
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
720 // File: @openzeppelin/contracts/access/Ownable.sol
721 
722 
723 
724 pragma solidity ^0.6.2;
725 
726 /**
727  * @dev Contract module which provides a basic access control mechanism, where
728  * there is an account (an owner) that can be granted exclusive access to
729  * specific functions.
730  *
731  * By default, the owner account will be the one that deploys the contract. This
732  * can later be changed with {transferOwnership}.
733  *
734  * This module is used through inheritance. It will make available the modifier
735  * `onlyOwner`, which can be applied to your functions to restrict their use to
736  * the owner.
737  */
738 contract Ownable is Context {
739     address private _owner;
740 
741     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
742 
743     /**
744      * @dev Initializes the contract setting the deployer as the initial owner.
745      */
746     constructor () internal {
747         address msgSender = _msgSender();
748         _owner = msgSender;
749         emit OwnershipTransferred(address(0), msgSender);
750     }
751 
752     /**
753      * @dev Returns the address of the current owner.
754      */
755     function owner() public view returns (address) {
756         return _owner;
757     }
758 
759     /**
760      * @dev Throws if called by any account other than the owner.
761      */
762     modifier onlyOwner() {
763         require(_owner == _msgSender(), "Ownable: caller is not the owner");
764         _;
765     }
766 
767     /**
768      * @dev Leaves the contract without owner. It will not be possible to call
769      * `onlyOwner` functions anymore. Can only be called by the current owner.
770      *
771      * NOTE: Renouncing ownership will leave the contract without an owner,
772      * thereby removing any functionality that is only available to the owner.
773      */
774     function renounceOwnership() public virtual onlyOwner {
775         emit OwnershipTransferred(_owner, address(0));
776         _owner = address(0);
777     }
778 
779     /**
780      * @dev Transfers ownership of the contract to a new account (`newOwner`).
781      * Can only be called by the current owner.
782      */
783     function transferOwnership(address newOwner) public virtual onlyOwner {
784         require(newOwner != address(0), "Ownable: new owner is the zero address");
785         emit OwnershipTransferred(_owner, newOwner);
786         _owner = newOwner;
787     }
788 }
789 
790 // IERC165.sol
791 
792 pragma solidity ^0.6.2;
793 
794 /**
795  * @dev Interface of the ERC165 standard, as defined in the
796  * https://eips.ethereum.org/EIPS/eip-165[EIP].
797  *
798  * Implementers can declare support of contract interfaces, which can then be
799  * queried by others ({ERC165Checker}).
800  *
801  * For an implementation, see {ERC165}.
802  */
803 interface IERC165 {
804     /**
805      * @dev Returns true if this contract implements the interface defined by
806      * `interfaceId`. See the corresponding
807      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
808      * to learn more about how these ids are created.
809      *
810      * This function call must use less than 30 000 gas.
811      */
812     function supportsInterface(bytes4 interfaceId) external view returns (bool);
813 }
814 
815 // IERC721.sol
816 
817 pragma solidity ^0.6.2;
818 
819 /**
820  * @dev Required interface of an ERC721 compliant contract.
821  */
822 interface IERC721 is IERC165 {
823     /**
824      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
825      */
826     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
827 
828     /**
829      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
830      */
831     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
832 
833     /**
834      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
835      */
836     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
837 
838     /**
839      * @dev Returns the number of tokens in ``owner``'s account.
840      */
841     function balanceOf(address owner) external view returns (uint256 balance);
842 
843     /**
844      * @dev Returns the owner of the `tokenId` token.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must exist.
849      */
850     function ownerOf(uint256 tokenId) external view returns (address owner);
851 
852     /**
853      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
854      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
855      *
856      * Requirements:
857      *
858      * - `from` cannot be the zero address.
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must exist and be owned by `from`.
861      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
862      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
863      *
864      * Emits a {Transfer} event.
865      */
866     function safeTransferFrom(address from, address to, uint256 tokenId) external;
867 
868     /**
869      * @dev Transfers `tokenId` token from `from` to `to`.
870      *
871      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
872      *
873      * Requirements:
874      *
875      * - `from` cannot be the zero address.
876      * - `to` cannot be the zero address.
877      * - `tokenId` token must be owned by `from`.
878      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
879      *
880      * Emits a {Transfer} event.
881      */
882     function transferFrom(address from, address to, uint256 tokenId) external;
883 
884     /**
885      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
886      * The approval is cleared when the token is transferred.
887      *
888      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
889      *
890      * Requirements:
891      *
892      * - The caller must own the token or be an approved operator.
893      * - `tokenId` must exist.
894      *
895      * Emits an {Approval} event.
896      */
897     function approve(address to, uint256 tokenId) external;
898 
899     /**
900      * @dev Returns the account approved for `tokenId` token.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must exist.
905      */
906     function getApproved(uint256 tokenId) external view returns (address operator);
907 
908     /**
909      * @dev Approve or remove `operator` as an operator for the caller.
910      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
911      *
912      * Requirements:
913      *
914      * - The `operator` cannot be the caller.
915      *
916      * Emits an {ApprovalForAll} event.
917      */
918     function setApprovalForAll(address operator, bool _approved) external;
919 
920     /**
921      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
922      *
923      * See {setApprovalForAll}
924      */
925     function isApprovedForAll(address owner, address operator) external view returns (bool);
926 
927     /**
928       * @dev Safely transfers `tokenId` token from `from` to `to`.
929       *
930       * Requirements:
931       *
932       * - `from` cannot be the zero address.
933       * - `to` cannot be the zero address.
934       * - `tokenId` token must exist and be owned by `from`.
935       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
936       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
937       *
938       * Emits a {Transfer} event.
939       */
940     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
941 }
942 
943 interface IXBMF is IERC20 { 
944     function minterMint(address _to, uint256 _amount) external;
945 }
946 
947 contract MinterProxy is Ownable { // start MinterProxy contract
948 
949     using SafeMath for uint256;
950 
951     uint256 constant private SODA_INITIAL_REWARD = 30000 ether;
952     uint256 constant private SODA_REWARD_PER_DAY = 25 ether;
953     
954     uint256 constant private SECS_IN_DAY = 86400;
955     uint256 constant private REWARD_DENOMINATOR = 1000000000000000000;
956     
957     address constant private SODA_ADDRESS = 0x2624bB7854D823e80b2BAFf2066e2979Cd5e0186;
958     address constant private XBMF_ADDRESS = 0x0405B21BC88aF1Fa4f7Ac9cC311Da0748CA8f31E;
959     
960     uint256 private contractBirthTime;
961     
962     address private minter;
963     
964     IERC721 soda = IERC721(SODA_ADDRESS);
965     IXBMF xbmf = IXBMF(XBMF_ADDRESS);
966     
967     mapping(uint => bool) private sodaInitialClaims;
968     mapping(uint256 => uint256) private sodaTimeRewards;
969     mapping(uint256 => uint256) private sodaLastUpdate;
970     
971     constructor() public {
972         contractBirthTime = now;
973     }
974     
975     modifier onlyMinter {
976         if (msg.sender != minter) revert();
977         _;
978     }
979     
980     // SODA
981     
982     function hasClaimedSodaInitialReward(uint256 nftId) public view returns (bool) {
983         return sodaInitialClaims[nftId];
984     }
985     
986     function claimSodaInitialReward(uint256 nftId) public {
987         require(soda.ownerOf(nftId) ==  msg.sender, "You don't hold this NFT in your wallet");
988         require(sodaInitialClaims[nftId] == false, "This soda initial claim has already been claimed");
989         sodaInitialClaims[nftId] = true;
990         xbmf.minterMint(msg.sender, SODA_INITIAL_REWARD);
991     }
992     
993     function claimAllAccumulatedSodaRewards(uint256[] memory nftIds) public {
994         for (uint i = 0; i < nftIds.length; i++){
995             claimAccumulatedSodaRewards(nftIds[i]);
996         }
997     }
998     
999     function claimAccumulatedSodaRewards(uint256 nftId) public {
1000         require(soda.ownerOf(nftId) ==  msg.sender, "You don't own this NFT");
1001 
1002         uint256 dailyReward = SODA_REWARD_PER_DAY;
1003         uint256 time = block.timestamp;
1004         uint256 lastTime = sodaLastUpdate[nftId];
1005         if (lastTime == 0) {
1006             lastTime = contractBirthTime;
1007         }
1008         
1009         uint256 timePassed = time.sub(lastTime);
1010         uint256 additionalRewards = dailyReward.mul(timePassed).div(SECS_IN_DAY);
1011         sodaTimeRewards[nftId] = sodaTimeRewards[nftId].add(additionalRewards);
1012 
1013         sodaLastUpdate[nftId] = time;
1014         uint256 payout = sodaTimeRewards[nftId];
1015         
1016         sodaTimeRewards[nftId] = 0;
1017         xbmf.minterMint(msg.sender, payout);
1018     }
1019     
1020     function viewAccumulatedSodaDecimalRewards(uint256 nftId) public view returns (uint256[2] memory) {
1021         uint256 time = block.timestamp;
1022         uint256 lastTime = sodaLastUpdate[nftId];
1023         if (lastTime == 0) {
1024             lastTime = contractBirthTime;
1025         }
1026   
1027         uint256 dailyReward = SODA_REWARD_PER_DAY;
1028         uint256 timePassed = time.sub(lastTime);
1029         uint256 additionalRewards = dailyReward.mul(timePassed).div(SECS_IN_DAY);
1030         uint256[2] memory res =  [sodaTimeRewards[nftId].add(additionalRewards), REWARD_DENOMINATOR];
1031         return res;
1032     }
1033     
1034     // Minter 
1035     
1036     function getMinter() public view returns (address) {
1037         return minter;
1038     }
1039     
1040     function minterMint(address _to, uint256 _amount) external onlyMinter {
1041         xbmf.minterMint(_to, _amount);
1042     }
1043     
1044     function setMinter(address _minter) public onlyOwner {
1045         minter = _minter;
1046     }
1047     
1048 } // end MinterProxy contract