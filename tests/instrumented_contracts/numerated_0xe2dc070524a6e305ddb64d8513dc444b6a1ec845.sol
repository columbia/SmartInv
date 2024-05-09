1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/GSN/Context.sol
164 
165 // SPDX-License-Identifier: MIT
166 
167 pragma solidity ^0.6.0;
168 
169 /*
170  * @dev Provides information about the current execution context, including the
171  * sender of the transaction and its data. While these are generally available
172  * via msg.sender and msg.data, they should not be accessed in such a direct
173  * manner, since when dealing with GSN meta-transactions the account sending and
174  * paying for execution may not be the actual sender (as far as an application
175  * is concerned).
176  *
177  * This contract is only required for intermediate, library-like contracts.
178  */
179 abstract contract Context {
180     function _msgSender() internal view virtual returns (address payable) {
181         return msg.sender;
182     }
183 
184     function _msgData() internal view virtual returns (bytes memory) {
185         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
186         return msg.data;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
191 
192 // SPDX-License-Identifier: MIT
193 
194 pragma solidity ^0.6.0;
195 
196 /**
197  * @dev Interface of the ERC20 standard as defined in the EIP.
198  */
199 interface IERC20 {
200     /**
201      * @dev Returns the amount of tokens in existence.
202      */
203     function totalSupply() external view returns (uint256);
204 
205     /**
206      * @dev Returns the amount of tokens owned by `account`.
207      */
208     function balanceOf(address account) external view returns (uint256);
209 
210     /**
211      * @dev Moves `amount` tokens from the caller's account to `recipient`.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transfer(address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Returns the remaining number of tokens that `spender` will be
221      * allowed to spend on behalf of `owner` through {transferFrom}. This is
222      * zero by default.
223      *
224      * This value changes when {approve} or {transferFrom} are called.
225      */
226     function allowance(address owner, address spender) external view returns (uint256);
227 
228     /**
229      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * IMPORTANT: Beware that changing an allowance with this method brings the risk
234      * that someone may use both the old and the new allowance by unfortunate
235      * transaction ordering. One possible solution to mitigate this race
236      * condition is to first reduce the spender's allowance to 0 and set the
237      * desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address spender, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Moves `amount` tokens from `sender` to `recipient` using the
246      * allowance mechanism. `amount` is then deducted from the caller's
247      * allowance.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Emitted when `value` tokens are moved from one account (`from`) to
257      * another (`to`).
258      *
259      * Note that `value` may be zero.
260      */
261     event Transfer(address indexed from, address indexed to, uint256 value);
262 
263     /**
264      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
265      * a call to {approve}. `value` is the new allowance.
266      */
267     event Approval(address indexed owner, address indexed spender, uint256 value);
268 }
269 
270 // File: @openzeppelin/contracts/utils/Address.sol
271 
272 // SPDX-License-Identifier: MIT
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
416 // SPDX-License-Identifier: MIT
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
675      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
676      *
677      * This is internal function is equivalent to `approve`, and can be used to
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
723 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
724 
725 // SPDX-License-Identifier: MIT
726 
727 pragma solidity ^0.6.0;
728 
729 
730 /**
731  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
732  */
733 abstract contract ERC20Capped is ERC20 {
734     uint256 private _cap;
735 
736     /**
737      * @dev Sets the value of the `cap`. This value is immutable, it can only be
738      * set once during construction.
739      */
740     constructor (uint256 cap) public {
741         require(cap > 0, "ERC20Capped: cap is 0");
742         _cap = cap;
743     }
744 
745     /**
746      * @dev Returns the cap on the token's total supply.
747      */
748     function cap() public view returns (uint256) {
749         return _cap;
750     }
751 
752     /**
753      * @dev See {ERC20-_beforeTokenTransfer}.
754      *
755      * Requirements:
756      *
757      * - minted tokens must not cause the total supply to go over the cap.
758      */
759     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
760         super._beforeTokenTransfer(from, to, amount);
761 
762         if (from == address(0)) { // When minting tokens
763             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
764         }
765     }
766 }
767 
768 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
769 
770 // SPDX-License-Identifier: MIT
771 
772 pragma solidity ^0.6.0;
773 
774 /**
775  * @dev Library for managing
776  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
777  * types.
778  *
779  * Sets have the following properties:
780  *
781  * - Elements are added, removed, and checked for existence in constant time
782  * (O(1)).
783  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
784  *
785  * ```
786  * contract Example {
787  *     // Add the library methods
788  *     using EnumerableSet for EnumerableSet.AddressSet;
789  *
790  *     // Declare a set state variable
791  *     EnumerableSet.AddressSet private mySet;
792  * }
793  * ```
794  *
795  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
796  * (`UintSet`) are supported.
797  */
798 library EnumerableSet {
799     // To implement this library for multiple types with as little code
800     // repetition as possible, we write it in terms of a generic Set type with
801     // bytes32 values.
802     // The Set implementation uses private functions, and user-facing
803     // implementations (such as AddressSet) are just wrappers around the
804     // underlying Set.
805     // This means that we can only create new EnumerableSets for types that fit
806     // in bytes32.
807 
808     struct Set {
809         // Storage of set values
810         bytes32[] _values;
811 
812         // Position of the value in the `values` array, plus 1 because index 0
813         // means a value is not in the set.
814         mapping (bytes32 => uint256) _indexes;
815     }
816 
817     /**
818      * @dev Add a value to a set. O(1).
819      *
820      * Returns true if the value was added to the set, that is if it was not
821      * already present.
822      */
823     function _add(Set storage set, bytes32 value) private returns (bool) {
824         if (!_contains(set, value)) {
825             set._values.push(value);
826             // The value is stored at length-1, but we add 1 to all indexes
827             // and use 0 as a sentinel value
828             set._indexes[value] = set._values.length;
829             return true;
830         } else {
831             return false;
832         }
833     }
834 
835     /**
836      * @dev Removes a value from a set. O(1).
837      *
838      * Returns true if the value was removed from the set, that is if it was
839      * present.
840      */
841     function _remove(Set storage set, bytes32 value) private returns (bool) {
842         // We read and store the value's index to prevent multiple reads from the same storage slot
843         uint256 valueIndex = set._indexes[value];
844 
845         if (valueIndex != 0) { // Equivalent to contains(set, value)
846             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
847             // the array, and then remove the last element (sometimes called as 'swap and pop').
848             // This modifies the order of the array, as noted in {at}.
849 
850             uint256 toDeleteIndex = valueIndex - 1;
851             uint256 lastIndex = set._values.length - 1;
852 
853             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
854             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
855 
856             bytes32 lastvalue = set._values[lastIndex];
857 
858             // Move the last value to the index where the value to delete is
859             set._values[toDeleteIndex] = lastvalue;
860             // Update the index for the moved value
861             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
862 
863             // Delete the slot where the moved value was stored
864             set._values.pop();
865 
866             // Delete the index for the deleted slot
867             delete set._indexes[value];
868 
869             return true;
870         } else {
871             return false;
872         }
873     }
874 
875     /**
876      * @dev Returns true if the value is in the set. O(1).
877      */
878     function _contains(Set storage set, bytes32 value) private view returns (bool) {
879         return set._indexes[value] != 0;
880     }
881 
882     /**
883      * @dev Returns the number of values on the set. O(1).
884      */
885     function _length(Set storage set) private view returns (uint256) {
886         return set._values.length;
887     }
888 
889    /**
890     * @dev Returns the value stored at position `index` in the set. O(1).
891     *
892     * Note that there are no guarantees on the ordering of values inside the
893     * array, and it may change when more values are added or removed.
894     *
895     * Requirements:
896     *
897     * - `index` must be strictly less than {length}.
898     */
899     function _at(Set storage set, uint256 index) private view returns (bytes32) {
900         require(set._values.length > index, "EnumerableSet: index out of bounds");
901         return set._values[index];
902     }
903 
904     // AddressSet
905 
906     struct AddressSet {
907         Set _inner;
908     }
909 
910     /**
911      * @dev Add a value to a set. O(1).
912      *
913      * Returns true if the value was added to the set, that is if it was not
914      * already present.
915      */
916     function add(AddressSet storage set, address value) internal returns (bool) {
917         return _add(set._inner, bytes32(uint256(value)));
918     }
919 
920     /**
921      * @dev Removes a value from a set. O(1).
922      *
923      * Returns true if the value was removed from the set, that is if it was
924      * present.
925      */
926     function remove(AddressSet storage set, address value) internal returns (bool) {
927         return _remove(set._inner, bytes32(uint256(value)));
928     }
929 
930     /**
931      * @dev Returns true if the value is in the set. O(1).
932      */
933     function contains(AddressSet storage set, address value) internal view returns (bool) {
934         return _contains(set._inner, bytes32(uint256(value)));
935     }
936 
937     /**
938      * @dev Returns the number of values in the set. O(1).
939      */
940     function length(AddressSet storage set) internal view returns (uint256) {
941         return _length(set._inner);
942     }
943 
944    /**
945     * @dev Returns the value stored at position `index` in the set. O(1).
946     *
947     * Note that there are no guarantees on the ordering of values inside the
948     * array, and it may change when more values are added or removed.
949     *
950     * Requirements:
951     *
952     * - `index` must be strictly less than {length}.
953     */
954     function at(AddressSet storage set, uint256 index) internal view returns (address) {
955         return address(uint256(_at(set._inner, index)));
956     }
957 
958 
959     // UintSet
960 
961     struct UintSet {
962         Set _inner;
963     }
964 
965     /**
966      * @dev Add a value to a set. O(1).
967      *
968      * Returns true if the value was added to the set, that is if it was not
969      * already present.
970      */
971     function add(UintSet storage set, uint256 value) internal returns (bool) {
972         return _add(set._inner, bytes32(value));
973     }
974 
975     /**
976      * @dev Removes a value from a set. O(1).
977      *
978      * Returns true if the value was removed from the set, that is if it was
979      * present.
980      */
981     function remove(UintSet storage set, uint256 value) internal returns (bool) {
982         return _remove(set._inner, bytes32(value));
983     }
984 
985     /**
986      * @dev Returns true if the value is in the set. O(1).
987      */
988     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
989         return _contains(set._inner, bytes32(value));
990     }
991 
992     /**
993      * @dev Returns the number of values on the set. O(1).
994      */
995     function length(UintSet storage set) internal view returns (uint256) {
996         return _length(set._inner);
997     }
998 
999    /**
1000     * @dev Returns the value stored at position `index` in the set. O(1).
1001     *
1002     * Note that there are no guarantees on the ordering of values inside the
1003     * array, and it may change when more values are added or removed.
1004     *
1005     * Requirements:
1006     *
1007     * - `index` must be strictly less than {length}.
1008     */
1009     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1010         return uint256(_at(set._inner, index));
1011     }
1012 }
1013 
1014 // File: @openzeppelin/contracts/access/AccessControl.sol
1015 
1016 // SPDX-License-Identifier: MIT
1017 
1018 pragma solidity ^0.6.0;
1019 
1020 
1021 
1022 
1023 /**
1024  * @dev Contract module that allows children to implement role-based access
1025  * control mechanisms.
1026  *
1027  * Roles are referred to by their `bytes32` identifier. These should be exposed
1028  * in the external API and be unique. The best way to achieve this is by
1029  * using `public constant` hash digests:
1030  *
1031  * ```
1032  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1033  * ```
1034  *
1035  * Roles can be used to represent a set of permissions. To restrict access to a
1036  * function call, use {hasRole}:
1037  *
1038  * ```
1039  * function foo() public {
1040  *     require(hasRole(MY_ROLE, msg.sender));
1041  *     ...
1042  * }
1043  * ```
1044  *
1045  * Roles can be granted and revoked dynamically via the {grantRole} and
1046  * {revokeRole} functions. Each role has an associated admin role, and only
1047  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1048  *
1049  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1050  * that only accounts with this role will be able to grant or revoke other
1051  * roles. More complex role relationships can be created by using
1052  * {_setRoleAdmin}.
1053  *
1054  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1055  * grant and revoke this role. Extra precautions should be taken to secure
1056  * accounts that have been granted it.
1057  */
1058 abstract contract AccessControl is Context {
1059     using EnumerableSet for EnumerableSet.AddressSet;
1060     using Address for address;
1061 
1062     struct RoleData {
1063         EnumerableSet.AddressSet members;
1064         bytes32 adminRole;
1065     }
1066 
1067     mapping (bytes32 => RoleData) private _roles;
1068 
1069     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1070 
1071     /**
1072      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1073      *
1074      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1075      * {RoleAdminChanged} not being emitted signaling this.
1076      *
1077      * _Available since v3.1._
1078      */
1079     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1080 
1081     /**
1082      * @dev Emitted when `account` is granted `role`.
1083      *
1084      * `sender` is the account that originated the contract call, an admin role
1085      * bearer except when using {_setupRole}.
1086      */
1087     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1088 
1089     /**
1090      * @dev Emitted when `account` is revoked `role`.
1091      *
1092      * `sender` is the account that originated the contract call:
1093      *   - if using `revokeRole`, it is the admin role bearer
1094      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1095      */
1096     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1097 
1098     /**
1099      * @dev Returns `true` if `account` has been granted `role`.
1100      */
1101     function hasRole(bytes32 role, address account) public view returns (bool) {
1102         return _roles[role].members.contains(account);
1103     }
1104 
1105     /**
1106      * @dev Returns the number of accounts that have `role`. Can be used
1107      * together with {getRoleMember} to enumerate all bearers of a role.
1108      */
1109     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1110         return _roles[role].members.length();
1111     }
1112 
1113     /**
1114      * @dev Returns one of the accounts that have `role`. `index` must be a
1115      * value between 0 and {getRoleMemberCount}, non-inclusive.
1116      *
1117      * Role bearers are not sorted in any particular way, and their ordering may
1118      * change at any point.
1119      *
1120      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1121      * you perform all queries on the same block. See the following
1122      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1123      * for more information.
1124      */
1125     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1126         return _roles[role].members.at(index);
1127     }
1128 
1129     /**
1130      * @dev Returns the admin role that controls `role`. See {grantRole} and
1131      * {revokeRole}.
1132      *
1133      * To change a role's admin, use {_setRoleAdmin}.
1134      */
1135     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1136         return _roles[role].adminRole;
1137     }
1138 
1139     /**
1140      * @dev Grants `role` to `account`.
1141      *
1142      * If `account` had not been already granted `role`, emits a {RoleGranted}
1143      * event.
1144      *
1145      * Requirements:
1146      *
1147      * - the caller must have ``role``'s admin role.
1148      */
1149     function grantRole(bytes32 role, address account) public virtual {
1150         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1151 
1152         _grantRole(role, account);
1153     }
1154 
1155     /**
1156      * @dev Revokes `role` from `account`.
1157      *
1158      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1159      *
1160      * Requirements:
1161      *
1162      * - the caller must have ``role``'s admin role.
1163      */
1164     function revokeRole(bytes32 role, address account) public virtual {
1165         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1166 
1167         _revokeRole(role, account);
1168     }
1169 
1170     /**
1171      * @dev Revokes `role` from the calling account.
1172      *
1173      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1174      * purpose is to provide a mechanism for accounts to lose their privileges
1175      * if they are compromised (such as when a trusted device is misplaced).
1176      *
1177      * If the calling account had been granted `role`, emits a {RoleRevoked}
1178      * event.
1179      *
1180      * Requirements:
1181      *
1182      * - the caller must be `account`.
1183      */
1184     function renounceRole(bytes32 role, address account) public virtual {
1185         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1186 
1187         _revokeRole(role, account);
1188     }
1189 
1190     /**
1191      * @dev Grants `role` to `account`.
1192      *
1193      * If `account` had not been already granted `role`, emits a {RoleGranted}
1194      * event. Note that unlike {grantRole}, this function doesn't perform any
1195      * checks on the calling account.
1196      *
1197      * [WARNING]
1198      * ====
1199      * This function should only be called from the constructor when setting
1200      * up the initial roles for the system.
1201      *
1202      * Using this function in any other way is effectively circumventing the admin
1203      * system imposed by {AccessControl}.
1204      * ====
1205      */
1206     function _setupRole(bytes32 role, address account) internal virtual {
1207         _grantRole(role, account);
1208     }
1209 
1210     /**
1211      * @dev Sets `adminRole` as ``role``'s admin role.
1212      *
1213      * Emits a {RoleAdminChanged} event.
1214      */
1215     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1216         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1217         _roles[role].adminRole = adminRole;
1218     }
1219 
1220     function _grantRole(bytes32 role, address account) private {
1221         if (_roles[role].members.add(account)) {
1222             emit RoleGranted(role, account, _msgSender());
1223         }
1224     }
1225 
1226     function _revokeRole(bytes32 role, address account) private {
1227         if (_roles[role].members.remove(account)) {
1228             emit RoleRevoked(role, account, _msgSender());
1229         }
1230     }
1231 }
1232 
1233 // File: contracts/Nex.sol
1234 
1235 pragma solidity ^0.6.2;
1236 
1237 
1238 
1239 
1240 
1241 
1242 contract NEX is ERC20, AccessControl {
1243 
1244     using SafeMath for uint256;
1245 
1246     uint8 public constant NEX_DECIMALS = 8;
1247     string public constant NAME = "Nash Exchange Token";
1248     string public constant SYMBOL = "NEX";
1249 
1250     // this is the max possible supply, cap cannot go higher than this
1251     uint public constant MAX_SUPPLY = 50000000 * (10 ** uint(NEX_DECIMALS));
1252 
1253     // Users can swap a minimum 500 ETH NEX to NEO NEX at once
1254     uint public constant MIN_SWAP_AMOUNT = 500 * (10 ** uint(NEX_DECIMALS));
1255 
1256     bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');
1257 
1258     mapping (uint256 => bool) private _swapsFromNeo;
1259     uint256 private _swapsToNeoCounter;
1260 
1261     // cap starts at 0
1262     uint256 private _cap = 0;
1263 
1264 
1265     /**
1266      * @dev Emitted when `value` tokens are moved from one NEO blockchain to this contract at 
1267      * (`to`) address. 
1268      *
1269      */
1270     event SwapFromNeo(address to, string from, uint256 value, uint256 swapId);
1271 
1272     /**
1273      * @dev Emitted when `value` tokens are moved from this contract at 
1274      * (`from`) address to an address  (`to`) on the NEO blockchain.  
1275      *
1276      */
1277     event SwapToNeo(address from, string to, uint256 value, uint256 swapId);
1278 
1279 
1280     constructor () ERC20(NAME, SYMBOL) public {
1281         _setupDecimals(NEX_DECIMALS);
1282         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);        
1283     }
1284 
1285     /**
1286      * @dev Destroys `amount` tokens from the caller. Emits event
1287      * indicating corresponding tokens to be minted on NEO contract
1288      *
1289      * See {ERC20-_burn}.
1290      */
1291     function swapToNeo(uint256 amount, string memory to) public virtual {
1292         bytes memory strBytes = bytes(to);
1293         require(amount >= MIN_SWAP_AMOUNT, "[NEX] Minimum swap amount is 500");
1294         require(strBytes.length == 34, "[NEX] Neo address must be 34 bytes in length");
1295         _burn(_msgSender(), amount);
1296         _swapsToNeoCounter++;
1297         emit SwapToNeo(_msgSender(), to, amount, _swapsToNeoCounter);
1298     }
1299 
1300     /**
1301      * @dev Creates `amount` tokens from the caller. Emits event
1302      * indicating tokens have been minted on ETH contract
1303      *
1304      * See {ERC20-_mint}.
1305      */
1306     function swapFromNeo(address to, string memory from, uint256 amount, uint256 swapId) public virtual {
1307         require(hasRole(MINTER_ROLE, msg.sender), "[NEX] Caller is not a minter");
1308         require(_swapsFromNeo[swapId] == false, "[NEX] Swap for given swap id already performed");
1309         _mint(to, amount);
1310         _swapsFromNeo[swapId] = true;
1311         emit SwapFromNeo(to, from, amount, swapId);
1312     }
1313 
1314 
1315     /**
1316      * @dev Returns the current cap on the token's total supply.
1317      */
1318     function cap() public view returns (uint256) {
1319         return _cap;
1320     }
1321 
1322     /**
1323      * @dev Returns the max possible cap on the token's total supply.
1324      */
1325     function maxCap() public pure returns (uint256) {
1326         return MAX_SUPPLY;
1327     }
1328 
1329 
1330     /**
1331      * @dev Updates soft cap of total tokens
1332      */
1333     function updateCap(uint256 amount) public virtual {
1334         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "[NEX] Caller is not an admin");
1335         require(amount > totalSupply(), "[NEX] Must be greater than total supply");
1336         require(amount <= MAX_SUPPLY, "[NEX] Cap cannot be greater than max supply");
1337         _cap = amount;
1338     }
1339 
1340 
1341     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20) {
1342         // Check cap when minting tokens
1343         if (from == address(0)) { 
1344             require(totalSupply().add(amount) <= _cap, "[NEX] Cap exceeded");
1345         }
1346 
1347         super._beforeTokenTransfer(from, to, amount);
1348     }
1349 }