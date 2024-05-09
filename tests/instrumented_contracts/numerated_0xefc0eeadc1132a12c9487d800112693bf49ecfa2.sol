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
1130 // File: contracts/Pool/HegicETHPool.sol
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
1154 /**
1155  * @author 0mllwntrmt3
1156  * @title Hegic ETH Liquidity Pool
1157  * @notice Accumulates liquidity in ETH from LPs and distributes P&L in ETH
1158  */
1159 contract HegicETHPool is
1160     IETHLiquidityPool,
1161     Ownable,
1162     ERC20("Hegic ETH LP Token", "writeETH")
1163 {
1164     using SafeMath for uint256;
1165     uint256 public constant INITIAL_RATE = 1e3;
1166     uint256 public lockupPeriod = 2 weeks;
1167     uint256 public lockedAmount;
1168     uint256 public lockedPremium;
1169     mapping(address => uint256) public lastProvideTimestamp;
1170     mapping(address => bool) public _revertTransfersInLockUpPeriod;
1171     LockedLiquidity[] public lockedLiquidity;
1172 
1173     /**
1174      * @notice Used for changing the lockup period
1175      * @param value New period value
1176      */
1177     function setLockupPeriod(uint256 value) external override onlyOwner {
1178         require(value <= 60 days, "Lockup period is too large");
1179         lockupPeriod = value;
1180     }
1181 
1182     /**
1183      * @notice Used for ...
1184      */
1185     function revertTransfersInLockUpPeriod(bool value) external {
1186         _revertTransfersInLockUpPeriod[msg.sender] = value;
1187     }
1188 
1189     /*
1190      * @nonce A provider supplies ETH to the pool and receives writeETH tokens
1191      * @param minMint Minimum amount of tokens that should be received by a provider.
1192                       Calling the provide function will require the minimum amount of tokens to be minted.
1193                       The actual amount that will be minted could vary but can only be higher (not lower) than the minimum value.
1194      * @return mint Amount of tokens to be received
1195      */
1196     function provide(uint256 minMint) external payable returns (uint256 mint) {
1197         lastProvideTimestamp[msg.sender] = block.timestamp;
1198         uint supply = totalSupply();
1199         uint balance = totalBalance();
1200         if (supply > 0 && balance > 0)
1201             mint = msg.value.mul(supply).div(balance.sub(msg.value));
1202         else
1203             mint = msg.value.mul(INITIAL_RATE);
1204 
1205         require(mint >= minMint, "Pool: Mint limit is too large");
1206         require(mint > 0, "Pool: Amount is too small");
1207 
1208         _mint(msg.sender, mint);
1209         emit Provide(msg.sender, msg.value, mint);
1210     }
1211 
1212     /*
1213      * @nonce Provider burns writeETH and receives ETH from the pool
1214      * @param amount Amount of ETH to receive
1215      * @return burn Amount of tokens to be burnt
1216      */
1217     function withdraw(uint256 amount, uint256 maxBurn) external returns (uint256 burn) {
1218         require(
1219             lastProvideTimestamp[msg.sender].add(lockupPeriod) <= block.timestamp,
1220             "Pool: Withdrawal is locked up"
1221         );
1222         require(
1223             amount <= availableBalance(),
1224             "Pool Error: Not enough funds on the pool contract. Please lower the amount."
1225         );
1226 
1227         burn = divCeil(amount.mul(totalSupply()), totalBalance());
1228 
1229         require(burn <= maxBurn, "Pool: Burn limit is too small");
1230         require(burn <= balanceOf(msg.sender), "Pool: Amount is too large");
1231         require(burn > 0, "Pool: Amount is too small");
1232 
1233         _burn(msg.sender, burn);
1234         emit Withdraw(msg.sender, amount, burn);
1235         msg.sender.transfer(amount);
1236     }
1237 
1238     /*
1239      * @nonce calls by HegicCallOptions to lock the funds
1240      * @param amount Amount of funds that should be locked in an option
1241      */
1242     function lock(uint id, uint256 amount) external override onlyOwner payable {
1243         require(id == lockedLiquidity.length, "Wrong id");
1244         require(
1245             lockedAmount.add(amount).mul(10) <= totalBalance().sub(msg.value).mul(8),
1246             "Pool Error: Amount is too large."
1247         );
1248 
1249         lockedLiquidity.push(LockedLiquidity(amount, msg.value, true));
1250         lockedPremium = lockedPremium.add(msg.value);
1251         lockedAmount = lockedAmount.add(amount);
1252     }
1253 
1254     /*
1255      * @nonce calls by HegicOptions to unlock the funds
1256      * @param id Id of LockedLiquidity that should be unlocked
1257      */
1258     function unlock(uint256 id) external override onlyOwner {
1259         LockedLiquidity storage ll = lockedLiquidity[id];
1260         require(ll.locked, "LockedLiquidity with such id has already unlocked");
1261         ll.locked = false;
1262 
1263         lockedPremium = lockedPremium.sub(ll.premium);
1264         lockedAmount = lockedAmount.sub(ll.amount);
1265 
1266         emit Profit(id, ll.premium);
1267     }
1268 
1269     /*
1270      * @nonce calls by HegicCallOptions to send funds to liquidity providers after an option's expiration
1271      * @param to Provider
1272      * @param amount Funds that should be sent
1273      */
1274     function send(uint id, address payable to, uint256 amount)
1275         external
1276         override
1277         onlyOwner
1278     {
1279         LockedLiquidity storage ll = lockedLiquidity[id];
1280         require(ll.locked, "LockedLiquidity with such id has already unlocked");
1281         require(to != address(0));
1282 
1283         ll.locked = false;
1284         lockedPremium = lockedPremium.sub(ll.premium);
1285         lockedAmount = lockedAmount.sub(ll.amount);
1286 
1287         uint transferAmount = amount > ll.amount ? ll.amount : amount;
1288         to.transfer(transferAmount);
1289 
1290         if (transferAmount <= ll.premium)
1291             emit Profit(id, ll.premium - transferAmount);
1292         else
1293             emit Loss(id, transferAmount - ll.premium);
1294     }
1295 
1296     /*
1297      * @nonce Returns provider's share in ETH
1298      * @param account Provider's address
1299      * @return Provider's share in ETH
1300      */
1301     function shareOf(address account) external view returns (uint256 share) {
1302         if (totalSupply() > 0)
1303             share = totalBalance().mul(balanceOf(account)).div(totalSupply());
1304         else
1305             share = 0;
1306     }
1307 
1308     /*
1309      * @nonce Returns the amount of ETH available for withdrawals
1310      * @return balance Unlocked amount
1311      */
1312     function availableBalance() public view returns (uint256 balance) {
1313         return totalBalance().sub(lockedAmount);
1314     }
1315 
1316     /*
1317      * @nonce Returns the total balance of ETH provided to the pool
1318      * @return balance Pool balance
1319      */
1320     function totalBalance() public override view returns (uint256 balance) {
1321         return address(this).balance.sub(lockedPremium);
1322     }
1323 
1324     function _beforeTokenTransfer(address from, address to, uint256) internal override {
1325         if (
1326             lastProvideTimestamp[from].add(lockupPeriod) > block.timestamp &&
1327             lastProvideTimestamp[from] > lastProvideTimestamp[to]
1328         ) {
1329             require(
1330                 !_revertTransfersInLockUpPeriod[to],
1331                 "the recipient does not accept blocked funds"
1332             );
1333             lastProvideTimestamp[to] = lastProvideTimestamp[from];
1334         }
1335     }
1336 
1337     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
1338         require(b > 0);
1339         uint256 c = a / b;
1340         if (a % b != 0)
1341             c = c + 1;
1342         return c;
1343     }
1344 }
1345 
1346 // File: contracts/Options/HegicETHOptions.sol
1347 
1348 pragma solidity 0.6.12;
1349 
1350 /**
1351  * Hegic
1352  * Copyright (C) 2020 Hegic Protocol
1353  *
1354  * This program is free software: you can redistribute it and/or modify
1355  * it under the terms of the GNU General Public License as published by
1356  * the Free Software Foundation, either version 3 of the License, or
1357  * (at your option) any later version.
1358  *
1359  * This program is distributed in the hope that it will be useful,
1360  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1361  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1362  * GNU General Public License for more details.
1363  *
1364  * You should have received a copy of the GNU General Public License
1365  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1366  */
1367 
1368 
1369 
1370 /**
1371  * @author 0mllwntrmt3
1372  * @title Hegic ETH (Ether) Bidirectional (Call and Put) Options
1373  * @notice Hegic ETH Options Contract
1374  */
1375 contract HegicETHOptions is Ownable, IHegicOptions {
1376     using SafeMath for uint256;
1377 
1378     IHegicStakingETH public settlementFeeRecipient;
1379     Option[] public override options;
1380     uint256 public impliedVolRate;
1381     uint256 public optionCollateralizationRatio = 100;
1382     uint256 internal constant PRICE_DECIMALS = 1e8;
1383     uint256 internal contractCreationTimestamp;
1384     bool internal migrationProcess = true;
1385     HegicETHOptions private oldHegicETHOptions;
1386     AggregatorV3Interface public priceProvider;
1387     HegicETHPool public pool;
1388 
1389     /**
1390      * @param pp The address of ChainLink ETH/USD price feed contract
1391      */
1392     constructor(AggregatorV3Interface pp, IHegicStakingETH staking, HegicETHPool _pool) public {
1393         pool = _pool;
1394         priceProvider = pp;
1395         settlementFeeRecipient = staking;
1396         impliedVolRate = 4500;
1397         contractCreationTimestamp = block.timestamp;
1398     }
1399 
1400     /**
1401      * @notice Can be used to update the contract in critical situations
1402      *         in the first 14 days after deployment
1403      */
1404     function transferPoolOwnership() external onlyOwner {
1405         require(block.timestamp < contractCreationTimestamp + 14 days);
1406         pool.transferOwnership(owner());
1407     }
1408 
1409     /**
1410      * @notice Used for adjusting the options prices while balancing asset's implied volatility rate
1411      * @param value New IVRate value
1412      */
1413     function setImpliedVolRate(uint256 value) external onlyOwner {
1414         require(value >= 1000, "ImpliedVolRate limit is too small");
1415         impliedVolRate = value;
1416     }
1417 
1418     /**
1419      * @notice Used for changing settlementFeeRecipient
1420      * @param recipient New settlementFee recipient address
1421      */
1422     function setSettlementFeeRecipient(IHegicStakingETH recipient) external onlyOwner {
1423         require(block.timestamp < contractCreationTimestamp + 14 days);
1424         require(address(recipient) != address(0));
1425         settlementFeeRecipient = recipient;
1426     }
1427 
1428     /**
1429      * @notice Used for changing option collateralization ratio
1430      * @param value New optionCollateralizationRatio value
1431      */
1432     function setOptionCollaterizationRatio(uint value) external onlyOwner {
1433         require(50 <= value && value <= 100, "wrong value");
1434         optionCollateralizationRatio = value;
1435     }
1436 
1437     /**
1438      * @notice Creates a new option
1439      * @param period Option period in seconds (1 days <= period <= 4 weeks)
1440      * @param amount Option amount
1441      * @param strike Strike price of the option
1442      * @param optionType Call or Put option type
1443      * @return optionID Created option's ID
1444      */
1445     function create(
1446         uint256 period,
1447         uint256 amount,
1448         uint256 strike,
1449         OptionType optionType
1450     )
1451         external
1452         payable
1453         returns (uint256 optionID)
1454     {
1455         (uint256 total, uint256 settlementFee, uint256 strikeFee, ) = fees(
1456             period,
1457             amount,
1458             strike,
1459             optionType
1460         );
1461 
1462         require(
1463             optionType == OptionType.Call || optionType == OptionType.Put,
1464             "Wrong option type"
1465         );
1466         require(period >= 1 days, "Period is too short");
1467         require(period <= 4 weeks, "Period is too long");
1468         require(amount > strikeFee, "Price difference is too large");
1469         require(msg.value >= total, "Wrong value");
1470         if (msg.value > total) msg.sender.transfer(msg.value - total);
1471 
1472         uint256 strikeAmount = amount.sub(strikeFee);
1473         optionID = options.length;
1474         Option memory option = Option(
1475             State.Active,
1476             msg.sender,
1477             strike,
1478             amount,
1479             strikeAmount.mul(optionCollateralizationRatio).div(100).add(strikeFee),
1480             total.sub(settlementFee),
1481             block.timestamp + period,
1482             optionType
1483         );
1484 
1485         options.push(option);
1486         settlementFeeRecipient.sendProfit {value: settlementFee}();
1487         pool.lock {value: option.premium} (optionID, option.lockedAmount);
1488         emit Create(optionID, msg.sender, settlementFee, total);
1489     }
1490 
1491     /**
1492      * @notice Transfers an active option
1493      * @param optionID ID of your option
1494      * @param newHolder Address of new option holder
1495      */
1496     function transfer(uint256 optionID, address payable newHolder) external {
1497         Option storage option = options[optionID];
1498 
1499         require(newHolder != address(0), "new holder address is zero");
1500         require(option.expiration >= block.timestamp, "Option has expired");
1501         require(option.holder == msg.sender, "Wrong msg.sender");
1502         require(option.state == State.Active, "Only active options could be transferred");
1503 
1504         option.holder = newHolder;
1505     }
1506 
1507     /**
1508      * @notice Exercises an active option
1509      * @param optionID ID of your option
1510      */
1511     function exercise(uint256 optionID) external {
1512         Option storage option = options[optionID];
1513 
1514         require(option.expiration >= block.timestamp, "Option has expired");
1515         require(option.holder == msg.sender, "Wrong msg.sender");
1516         require(option.state == State.Active, "Wrong state");
1517 
1518         option.state = State.Exercised;
1519         uint256 profit = payProfit(optionID);
1520 
1521         emit Exercise(optionID, profit);
1522     }
1523 
1524     /**
1525      * @notice Unlocks an array of options
1526      * @param optionIDs array of options
1527      */
1528     function unlockAll(uint256[] calldata optionIDs) external {
1529         uint arrayLength = optionIDs.length;
1530         for (uint256 i = 0; i < arrayLength; i++) {
1531             unlock(optionIDs[i]);
1532         }
1533     }
1534 
1535     function migrate(uint count) external onlyOwner {
1536         require(migrationProcess, "Migration Process was ended");
1537         require(
1538             pool.owner() != address(this),
1539             "Liquidity Pool already attached"
1540         );
1541         require(address(oldHegicETHOptions) != address(0));
1542         for (uint i = 0; i < count; i++){
1543             uint optionID = options.length;
1544             HegicETHOptions.Option memory option;
1545             (
1546                 option.state,
1547                 option.holder,
1548                 option.strike,
1549                 option.amount,
1550                 option.lockedAmount,
1551                 option.premium,
1552                 option.expiration,
1553                 option.optionType
1554             ) = oldHegicETHOptions.options(optionID);
1555             uint settlementFee = getSettlementFee(option.amount);
1556             options.push(option);
1557             emit Create(
1558                 optionID,
1559                 option.holder,
1560                 settlementFee,
1561                 option.premium.add(settlementFee)
1562             );
1563         }
1564     }
1565 
1566     function setOldHegicETHOptions(address oldAddr) external onlyOwner {
1567         require(address(oldHegicETHOptions) == address(0));
1568         oldHegicETHOptions = HegicETHOptions(oldAddr);
1569     }
1570 
1571     function stopMigrationProcess() external onlyOwner {
1572         migrationProcess = false;
1573     }
1574 
1575     /**
1576      * @notice Used for getting the actual options prices
1577      * @param period Option period in seconds (1 days <= period <= 4 weeks)
1578      * @param amount Option amount
1579      * @param strike Strike price of the option
1580      * @return total Total price to be paid
1581      * @return settlementFee Amount to be distributed to the HEGIC token holders
1582      * @return strikeFee Amount that covers the price difference in the ITM options
1583      * @return periodFee Option period fee amount
1584      */
1585     function fees(
1586         uint256 period,
1587         uint256 amount,
1588         uint256 strike,
1589         OptionType optionType
1590     )
1591         public
1592         view
1593         returns (
1594             uint256 total,
1595             uint256 settlementFee,
1596             uint256 strikeFee,
1597             uint256 periodFee
1598         )
1599     {
1600         (,int latestPrice,,,) = priceProvider.latestRoundData();
1601         uint256 currentPrice = uint256(latestPrice);
1602         settlementFee = getSettlementFee(amount);
1603         periodFee = getPeriodFee(amount, period, strike, currentPrice, optionType);
1604         strikeFee = getStrikeFee(amount, strike, currentPrice, optionType);
1605         total = periodFee.add(strikeFee).add(settlementFee);
1606     }
1607 
1608     /**
1609      * @notice Unlock funds locked in the expired options
1610      * @param optionID ID of the option
1611      */
1612     function unlock(uint256 optionID) public {
1613         Option storage option = options[optionID];
1614         require(option.expiration < block.timestamp, "Option has not expired yet");
1615         require(option.state == State.Active, "Option is not active");
1616         option.state = State.Expired;
1617         pool.unlock(optionID);
1618         emit Expire(optionID, option.premium);
1619     }
1620 
1621     /**
1622      * @notice Calculates settlementFee
1623      * @param amount Option amount
1624      * @return fee Settlement fee amount
1625      */
1626     function getSettlementFee(uint256 amount)
1627         internal
1628         pure
1629         returns (uint256 fee)
1630     {
1631         return amount / 100;
1632     }
1633 
1634     /**
1635      * @notice Calculates periodFee
1636      * @param amount Option amount
1637      * @param period Option period in seconds (1 days <= period <= 4 weeks)
1638      * @param strike Strike price of the option
1639      * @param currentPrice Current price of ETH
1640      * @return fee Period fee amount
1641      *
1642      * amount < 1e30        |
1643      * impliedVolRate < 1e10| => amount * impliedVolRate * strike < 1e60 < 2^uint256
1644      * strike < 1e20 ($1T)  |
1645      *
1646      * in case amount * impliedVolRate * strike >= 2^256
1647      * transaction will be reverted by the SafeMath
1648      */
1649     function getPeriodFee(
1650         uint256 amount,
1651         uint256 period,
1652         uint256 strike,
1653         uint256 currentPrice,
1654         OptionType optionType
1655     ) internal view returns (uint256 fee) {
1656         if (optionType == OptionType.Put)
1657             return amount
1658                 .mul(sqrt(period))
1659                 .mul(impliedVolRate)
1660                 .mul(strike)
1661                 .div(currentPrice)
1662                 .div(PRICE_DECIMALS);
1663         else
1664             return amount
1665                 .mul(sqrt(period))
1666                 .mul(impliedVolRate)
1667                 .mul(currentPrice)
1668                 .div(strike)
1669                 .div(PRICE_DECIMALS);
1670     }
1671 
1672     /**
1673      * @notice Calculates strikeFee
1674      * @param amount Option amount
1675      * @param strike Strike price of the option
1676      * @param currentPrice Current price of ETH
1677      * @return fee Strike fee amount
1678      */
1679     function getStrikeFee(
1680         uint256 amount,
1681         uint256 strike,
1682         uint256 currentPrice,
1683         OptionType optionType
1684     ) internal pure returns (uint256 fee) {
1685         if (strike > currentPrice && optionType == OptionType.Put)
1686             return strike.sub(currentPrice).mul(amount).div(currentPrice);
1687         if (strike < currentPrice && optionType == OptionType.Call)
1688             return currentPrice.sub(strike).mul(amount).div(currentPrice);
1689         return 0;
1690     }
1691 
1692     /**
1693      * @notice Sends profits in ETH from the ETH pool to an option holder's address
1694      * @param optionID A specific option contract id
1695      */
1696     function payProfit(uint optionID)
1697         internal
1698         returns (uint profit)
1699     {
1700         Option memory option = options[optionID];
1701         (, int latestPrice, , , ) = priceProvider.latestRoundData();
1702         uint256 currentPrice = uint256(latestPrice);
1703         if (option.optionType == OptionType.Call) {
1704             require(option.strike <= currentPrice, "Current price is too low");
1705             profit = currentPrice.sub(option.strike).mul(option.amount).div(currentPrice);
1706         } else {
1707             require(option.strike >= currentPrice, "Current price is too high");
1708             profit = option.strike.sub(currentPrice).mul(option.amount).div(currentPrice);
1709         }
1710         if (profit > option.lockedAmount)
1711             profit = option.lockedAmount;
1712         pool.send(optionID, option.holder, profit);
1713     }
1714 
1715 
1716 
1717     /**
1718      * @return result Square root of the number
1719      */
1720     function sqrt(uint256 x) private pure returns (uint256 result) {
1721         result = x;
1722         uint256 k = x.div(2).add(1);
1723         while (k < result) (result, k) = (k, x.div(k).add(k).div(2));
1724     }
1725 }