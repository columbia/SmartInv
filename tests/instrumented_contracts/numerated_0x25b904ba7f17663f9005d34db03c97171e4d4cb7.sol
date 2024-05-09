1 // SPDX-License-Identifier: GPL-3.0-or-later
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
296         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
297         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
298         // for accounts without code, i.e. `keccak256('')`
299         bytes32 codehash;
300         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
301         // solhint-disable-next-line no-inline-assembly
302         assembly { codehash := extcodehash(account) }
303         return (codehash != accountHash && codehash != 0x0);
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
796 // File: contracts/BondingCurve/BondingCurve.sol
797 
798 pragma solidity 0.6.12;
799 
800 /**
801  * Hegic
802  * Copyright (C) 2020 Hegic Protocol
803  *
804  * This program is free software: you can redistribute it and/or modify
805  * it under the terms of the GNU General Public License as published by
806  * the Free Software Foundation, either version 3 of the License, or
807  * (at your option) any later version.
808  *
809  * This program is distributed in the hope that it will be useful,
810  * but WITHOUT ANY WARRANTY; without even the implied warranty of
811  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
812  * GNU General Public License for more details.
813  *
814  * You should have received a copy of the GNU General Public License
815  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
816  */
817 
818 
819 
820 
821 abstract
822 contract BondingCurve {
823     using SafeMath for uint;
824     using SafeERC20 for IERC20;
825 
826     IERC20 public token;
827     uint public soldAmount;
828     address payable public hegicDevelopmentFund;
829 
830     event Bought(address indexed account, uint amount, uint ethAmount);
831     event Sold(address indexed account, uint amount, uint ethAmount, uint comission);
832 
833     constructor(IERC20 _token) public {
834         token = _token;
835         hegicDevelopmentFund = msg.sender;
836     }
837 
838     function buy(uint tokenAmount) external payable {
839         uint nextSold = soldAmount.add(tokenAmount);
840         uint ethAmount = s(soldAmount, nextSold);
841         soldAmount = nextSold;
842         require(msg.value >= ethAmount, "Value is too small");
843         token.safeTransfer(msg.sender, tokenAmount);
844         if (msg.value > ethAmount)
845             msg.sender.transfer(msg.value - ethAmount);
846         emit Bought(msg.sender, tokenAmount, ethAmount);
847     }
848 
849     function sell(uint tokenAmount) external {
850         uint nextSold = soldAmount.sub(tokenAmount);
851         uint ethAmount = s(nextSold, soldAmount);
852         uint comission = ethAmount / 10;
853         uint refund = ethAmount.sub(comission);
854         require(comission > 0);
855 
856         soldAmount = nextSold;
857         token.safeTransferFrom(msg.sender, address(this), tokenAmount);
858         hegicDevelopmentFund.transfer(comission);
859         msg.sender.transfer(refund);
860         emit Sold(msg.sender, tokenAmount, refund, comission);
861     }
862 
863     function s(uint x0, uint x1) public view virtual returns (uint);
864 }
865 
866 // File: contracts/BondingCurve/LinearBondingCurve.sol
867 
868 pragma solidity 0.6.12;
869 
870 /**
871  * Hegic
872  * Copyright (C) 2020 Hegic Protocol
873  *
874  * This program is free software: you can redistribute it and/or modify
875  * it under the terms of the GNU General Public License as published by
876  * the Free Software Foundation, either version 3 of the License, or
877  * (at your option) any later version.
878  *
879  * This program is distributed in the hope that it will be useful,
880  * but WITHOUT ANY WARRANTY; without even the implied warranty of
881  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
882  * GNU General Public License for more details.
883  *
884  * You should have received a copy of the GNU General Public License
885  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
886  */
887 
888 
889 
890 contract LinearBondingCurve is BondingCurve {
891     using SafeMath for uint;
892     using SafeERC20 for IERC20;
893     uint internal immutable K;
894     uint internal immutable START_PRICE;
895 
896     constructor(IERC20 _token, uint k, uint startPrice) public BondingCurve(_token) {
897         K = k;
898         START_PRICE = startPrice;
899     }
900 
901     function s(uint x0, uint x1) public view override returns (uint) {
902         require(x1 > x0);
903         return x1.add(x0).mul(x1.sub(x0))
904             .div(2).div(K)
905             .add(START_PRICE.mul(x1 - x0))
906             .div(1e18);
907     }
908 }