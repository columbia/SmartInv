1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
111 
112 pragma solidity ^0.6.0;
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
273 pragma solidity ^0.6.2;
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
298         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
299         // for accounts without code, i.e. `keccak256('')`
300         bytes32 codehash;
301         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
302         // solhint-disable-next-line no-inline-assembly
303         assembly { codehash := extcodehash(account) }
304         return (codehash != accountHash && codehash != 0x0);
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327         (bool success, ) = recipient.call{ value: amount }("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain`call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350       return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
360         return _functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         return _functionCallWithValue(target, data, value, errorMessage);
387     }
388 
389     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
390         require(isContract(target), "Address: call to non-contract");
391 
392         // solhint-disable-next-line avoid-low-level-calls
393         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 // solhint-disable-next-line no-inline-assembly
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
414 
415 
416 
417 pragma solidity ^0.6.0;
418 
419 
420 
421 
422 
423 /**
424  * @dev Implementation of the {IERC20} interface.
425  *
426  * This implementation is agnostic to the way tokens are created. This means
427  * that a supply mechanism has to be added in a derived contract using {_mint}.
428  * For a generic mechanism see {ERC20PresetMinterPauser}.
429  *
430  * TIP: For a detailed writeup see our guide
431  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
432  * to implement supply mechanisms].
433  *
434  * We have followed general OpenZeppelin guidelines: functions revert instead
435  * of returning `false` on failure. This behavior is nonetheless conventional
436  * and does not conflict with the expectations of ERC20 applications.
437  *
438  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
439  * This allows applications to reconstruct the allowance for all accounts just
440  * by listening to said events. Other implementations of the EIP may not emit
441  * these events, as it isn't required by the specification.
442  *
443  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
444  * functions have been added to mitigate the well-known issues around setting
445  * allowances. See {IERC20-approve}.
446  */
447 contract ERC20 is Context, IERC20 {
448     using SafeMath for uint256;
449     using Address for address;
450 
451     mapping (address => uint256) private _balances;
452 
453     mapping (address => mapping (address => uint256)) private _allowances;
454 
455     uint256 private _totalSupply;
456 
457     string private _name;
458     string private _symbol;
459     uint8 private _decimals;
460 
461     /**
462      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
463      * a default value of 18.
464      *
465      * To select a different value for {decimals}, use {_setupDecimals}.
466      *
467      * All three of these values are immutable: they can only be set once during
468      * construction.
469      */
470     constructor (string memory name, string memory symbol) public {
471         _name = name;
472         _symbol = symbol;
473         _decimals = 18;
474     }
475 
476     /**
477      * @dev Returns the name of the token.
478      */
479     function name() public view returns (string memory) {
480         return _name;
481     }
482 
483     /**
484      * @dev Returns the symbol of the token, usually a shorter version of the
485      * name.
486      */
487     function symbol() public view returns (string memory) {
488         return _symbol;
489     }
490 
491     /**
492      * @dev Returns the number of decimals used to get its user representation.
493      * For example, if `decimals` equals `2`, a balance of `505` tokens should
494      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
495      *
496      * Tokens usually opt for a value of 18, imitating the relationship between
497      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
498      * called.
499      *
500      * NOTE: This information is only used for _display_ purposes: it in
501      * no way affects any of the arithmetic of the contract, including
502      * {IERC20-balanceOf} and {IERC20-transfer}.
503      */
504     function decimals() public view returns (uint8) {
505         return _decimals;
506     }
507 
508     /**
509      * @dev See {IERC20-totalSupply}.
510      */
511     function totalSupply() public view override returns (uint256) {
512         return _totalSupply;
513     }
514 
515     /**
516      * @dev See {IERC20-balanceOf}.
517      */
518     function balanceOf(address account) public view override returns (uint256) {
519         return _balances[account];
520     }
521 
522     /**
523      * @dev See {IERC20-transfer}.
524      *
525      * Requirements:
526      *
527      * - `recipient` cannot be the zero address.
528      * - the caller must have a balance of at least `amount`.
529      */
530     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
531         _transfer(_msgSender(), recipient, amount);
532         return true;
533     }
534 
535     /**
536      * @dev See {IERC20-allowance}.
537      */
538     function allowance(address owner, address spender) public view virtual override returns (uint256) {
539         return _allowances[owner][spender];
540     }
541 
542     /**
543      * @dev See {IERC20-approve}.
544      *
545      * Requirements:
546      *
547      * - `spender` cannot be the zero address.
548      */
549     function approve(address spender, uint256 amount) public virtual override returns (bool) {
550         _approve(_msgSender(), spender, amount);
551         return true;
552     }
553 
554     /**
555      * @dev See {IERC20-transferFrom}.
556      *
557      * Emits an {Approval} event indicating the updated allowance. This is not
558      * required by the EIP. See the note at the beginning of {ERC20};
559      *
560      * Requirements:
561      * - `sender` and `recipient` cannot be the zero address.
562      * - `sender` must have a balance of at least `amount`.
563      * - the caller must have allowance for ``sender``'s tokens of at least
564      * `amount`.
565      */
566     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
567         _transfer(sender, recipient, amount);
568         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
569         return true;
570     }
571 
572     /**
573      * @dev Atomically increases the allowance granted to `spender` by the caller.
574      *
575      * This is an alternative to {approve} that can be used as a mitigation for
576      * problems described in {IERC20-approve}.
577      *
578      * Emits an {Approval} event indicating the updated allowance.
579      *
580      * Requirements:
581      *
582      * - `spender` cannot be the zero address.
583      */
584     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
585         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
586         return true;
587     }
588 
589     /**
590      * @dev Atomically decreases the allowance granted to `spender` by the caller.
591      *
592      * This is an alternative to {approve} that can be used as a mitigation for
593      * problems described in {IERC20-approve}.
594      *
595      * Emits an {Approval} event indicating the updated allowance.
596      *
597      * Requirements:
598      *
599      * - `spender` cannot be the zero address.
600      * - `spender` must have allowance for the caller of at least
601      * `subtractedValue`.
602      */
603     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
604         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
605         return true;
606     }
607 
608     /**
609      * @dev Moves tokens `amount` from `sender` to `recipient`.
610      *
611      * This is internal function is equivalent to {transfer}, and can be used to
612      * e.g. implement automatic token fees, slashing mechanisms, etc.
613      *
614      * Emits a {Transfer} event.
615      *
616      * Requirements:
617      *
618      * - `sender` cannot be the zero address.
619      * - `recipient` cannot be the zero address.
620      * - `sender` must have a balance of at least `amount`.
621      */
622     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
623         require(sender != address(0), "ERC20: transfer from the zero address");
624         require(recipient != address(0), "ERC20: transfer to the zero address");
625 
626         _beforeTokenTransfer(sender, recipient, amount);
627 
628         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
629         _balances[recipient] = _balances[recipient].add(amount);
630         emit Transfer(sender, recipient, amount);
631     }
632 
633     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
634      * the total supply.
635      *
636      * Emits a {Transfer} event with `from` set to the zero address.
637      *
638      * Requirements
639      *
640      * - `to` cannot be the zero address.
641      */
642     function _mint(address account, uint256 amount) internal virtual {
643         require(account != address(0), "ERC20: mint to the zero address");
644 
645         _beforeTokenTransfer(address(0), account, amount);
646 
647         _totalSupply = _totalSupply.add(amount);
648         _balances[account] = _balances[account].add(amount);
649         emit Transfer(address(0), account, amount);
650     }
651 
652     /**
653      * @dev Destroys `amount` tokens from `account`, reducing the
654      * total supply.
655      *
656      * Emits a {Transfer} event with `to` set to the zero address.
657      *
658      * Requirements
659      *
660      * - `account` cannot be the zero address.
661      * - `account` must have at least `amount` tokens.
662      */
663     function _burn(address account, uint256 amount) internal virtual {
664         require(account != address(0), "ERC20: burn from the zero address");
665 
666         _beforeTokenTransfer(account, address(0), amount);
667 
668         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
669         _totalSupply = _totalSupply.sub(amount);
670         emit Transfer(account, address(0), amount);
671     }
672 
673     /**
674      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
675      *
676      * This is internal function is equivalent to `approve`, and can be used to
677      * e.g. set automatic allowances for certain subsystems, etc.
678      *
679      * Emits an {Approval} event.
680      *
681      * Requirements:
682      *
683      * - `owner` cannot be the zero address.
684      * - `spender` cannot be the zero address.
685      */
686     function _approve(address owner, address spender, uint256 amount) internal virtual {
687         require(owner != address(0), "ERC20: approve from the zero address");
688         require(spender != address(0), "ERC20: approve to the zero address");
689 
690         _allowances[owner][spender] = amount;
691         emit Approval(owner, spender, amount);
692     }
693 
694     /**
695      * @dev Sets {decimals} to a value other than the default one of 18.
696      *
697      * WARNING: This function should only be called from the constructor. Most
698      * applications that interact with token contracts will not expect
699      * {decimals} to ever change, and may work incorrectly if it does.
700      */
701     function _setupDecimals(uint8 decimals_) internal {
702         _decimals = decimals_;
703     }
704 
705     /**
706      * @dev Hook that is called before any transfer of tokens. This includes
707      * minting and burning.
708      *
709      * Calling conditions:
710      *
711      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
712      * will be to transferred to `to`.
713      * - when `from` is zero, `amount` tokens will be minted for `to`.
714      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
715      * - `from` and `to` are never both zero.
716      *
717      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
718      */
719     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
720 }
721 
722 // File: @openzeppelin/contracts/access/Ownable.sol
723 
724 
725 
726 pragma solidity ^0.6.0;
727 
728 /**
729  * @dev Contract module which provides a basic access control mechanism, where
730  * there is an account (an owner) that can be granted exclusive access to
731  * specific functions.
732  *
733  * By default, the owner account will be the one that deploys the contract. This
734  * can later be changed with {transferOwnership}.
735  *
736  * This module is used through inheritance. It will make available the modifier
737  * `onlyOwner`, which can be applied to your functions to restrict their use to
738  * the owner.
739  */
740 contract Ownable is Context {
741     address private _owner;
742 
743     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
744 
745     /**
746      * @dev Initializes the contract setting the deployer as the initial owner.
747      */
748     constructor () internal {
749         address msgSender = _msgSender();
750         _owner = msgSender;
751         emit OwnershipTransferred(address(0), msgSender);
752     }
753 
754     /**
755      * @dev Returns the address of the current owner.
756      */
757     function owner() public view returns (address) {
758         return _owner;
759     }
760 
761     /**
762      * @dev Throws if called by any account other than the owner.
763      */
764     modifier onlyOwner() {
765         require(_owner == _msgSender(), "Ownable: caller is not the owner");
766         _;
767     }
768 
769     /**
770      * @dev Leaves the contract without owner. It will not be possible to call
771      * `onlyOwner` functions anymore. Can only be called by the current owner.
772      *
773      * NOTE: Renouncing ownership will leave the contract without an owner,
774      * thereby removing any functionality that is only available to the owner.
775      */
776     function renounceOwnership() public virtual onlyOwner {
777         emit OwnershipTransferred(_owner, address(0));
778         _owner = address(0);
779     }
780 
781     /**
782      * @dev Transfers ownership of the contract to a new account (`newOwner`).
783      * Can only be called by the current owner.
784      */
785     function transferOwnership(address newOwner) public virtual onlyOwner {
786         require(newOwner != address(0), "Ownable: new owner is the zero address");
787         emit OwnershipTransferred(_owner, newOwner);
788         _owner = newOwner;
789     }
790 }
791 
792 // File: contracts/XdexToken.sol
793 
794 pragma solidity 0.6.12;
795 
796 
797 
798 
799 // XdexToken with Governance.
800 contract XdexToken is ERC20("XdexToken", "XDEX"), Ownable {
801     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
802     function mint(address _to, uint256 _amount) public onlyOwner {
803         _mint(_to, _amount);
804         _moveDelegates(address(0), _delegates[_to], _amount);
805     }
806 
807      // https://github.com/quantstamp/sushiswap-security-review 3.4 fixed.
808     function _transfer(address sender, address recipient, uint256 amount) internal override(ERC20) {
809         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
810         ERC20._transfer(sender, recipient, amount);
811     }
812     // Copied and modified from YAM code:
813     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
814     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
815     // Which is copied and modified from COMPOUND:
816     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
817 
818     /// @notice A record of each accounts delegate
819     mapping (address => address) internal _delegates;
820 
821     /// @notice A checkpoint for marking number of votes from a given block
822     struct Checkpoint {
823         uint32 fromBlock;
824         uint256 votes;
825     }
826 
827     /// @notice A record of votes checkpoints for each account, by index
828     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
829 
830     /// @notice The number of checkpoints for each account
831     mapping (address => uint32) public numCheckpoints;
832 
833     /// @notice The EIP-712 typehash for the contract's domain
834     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
835 
836     /// @notice The EIP-712 typehash for the delegation struct used by the contract
837     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
838 
839     /// @notice A record of states for signing / validating signatures
840     mapping (address => uint) public nonces;
841 
842       /// @notice An event thats emitted when an account changes its delegate
843     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
844 
845     /// @notice An event thats emitted when a delegate account's vote balance changes
846     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
847 
848     /**
849      * @notice Delegate votes from `msg.sender` to `delegatee`
850      * @param delegator The address to get delegatee for
851      */
852     function delegates(address delegator)
853         external
854         view
855         returns (address)
856     {
857         return _delegates[delegator];
858     }
859 
860    /**
861     * @notice Delegate votes from `msg.sender` to `delegatee`
862     * @param delegatee The address to delegate votes to
863     */
864     function delegate(address delegatee) external {
865         return _delegate(msg.sender, delegatee);
866     }
867 
868     /**
869      * @notice Delegates votes from signatory to `delegatee`
870      * @param delegatee The address to delegate votes to
871      * @param nonce The contract state required to match the signature
872      * @param expiry The time at which to expire the signature
873      * @param v The recovery byte of the signature
874      * @param r Half of the ECDSA signature pair
875      * @param s Half of the ECDSA signature pair
876      */
877     function delegateBySig(
878         address delegatee,
879         uint nonce,
880         uint expiry,
881         uint8 v,
882         bytes32 r,
883         bytes32 s
884     )
885         external
886     {
887         bytes32 domainSeparator = keccak256(
888             abi.encode(
889                 DOMAIN_TYPEHASH,
890                 keccak256(bytes(name())),
891                 getChainId(),
892                 address(this)
893             )
894         );
895 
896         bytes32 structHash = keccak256(
897             abi.encode(
898                 DELEGATION_TYPEHASH,
899                 delegatee,
900                 nonce,
901                 expiry
902             )
903         );
904 
905         bytes32 digest = keccak256(
906             abi.encodePacked(
907                 "\x19\x01",
908                 domainSeparator,
909                 structHash
910             )
911         );
912 
913         address signatory = ecrecover(digest, v, r, s);
914         require(signatory != address(0), "XDEX::delegateBySig: invalid signature");
915         require(nonce == nonces[signatory]++, "XDEX::delegateBySig: invalid nonce");
916         require(now <= expiry, "XDEX::delegateBySig: signature expired");
917         return _delegate(signatory, delegatee);
918     }
919 
920     /**
921      * @notice Gets the current votes balance for `account`
922      * @param account The address to get votes balance
923      * @return The number of current votes for `account`
924      */
925     function getCurrentVotes(address account)
926         external
927         view
928         returns (uint256)
929     {
930         uint32 nCheckpoints = numCheckpoints[account];
931         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
932     }
933 
934     /**
935      * @notice Determine the prior number of votes for an account as of a block number
936      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
937      * @param account The address of the account to check
938      * @param blockNumber The block number to get the vote balance at
939      * @return The number of votes the account had as of the given block
940      */
941     function getPriorVotes(address account, uint blockNumber)
942         external
943         view
944         returns (uint256)
945     {
946         require(blockNumber < block.number, "XDEX::getPriorVotes: not yet determined");
947 
948         uint32 nCheckpoints = numCheckpoints[account];
949         if (nCheckpoints == 0) {
950             return 0;
951         }
952 
953         // First check most recent balance
954         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
955             return checkpoints[account][nCheckpoints - 1].votes;
956         }
957 
958         // Next check implicit zero balance
959         if (checkpoints[account][0].fromBlock > blockNumber) {
960             return 0;
961         }
962 
963         uint32 lower = 0;
964         uint32 upper = nCheckpoints - 1;
965         while (upper > lower) {
966             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
967             Checkpoint memory cp = checkpoints[account][center];
968             if (cp.fromBlock == blockNumber) {
969                 return cp.votes;
970             } else if (cp.fromBlock < blockNumber) {
971                 lower = center;
972             } else {
973                 upper = center - 1;
974             }
975         }
976         return checkpoints[account][lower].votes;
977     }
978 
979     function _delegate(address delegator, address delegatee)
980         internal
981     {
982         address currentDelegate = _delegates[delegator];
983         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying XDEXs (not scaled);
984         _delegates[delegator] = delegatee;
985 
986         emit DelegateChanged(delegator, currentDelegate, delegatee);
987 
988         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
989     }
990 
991     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
992         if (srcRep != dstRep && amount > 0) {
993             if (srcRep != address(0)) {
994                 // decrease old representative
995                 uint32 srcRepNum = numCheckpoints[srcRep];
996                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
997                 uint256 srcRepNew = srcRepOld.sub(amount);
998                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
999             }
1000 
1001             if (dstRep != address(0)) {
1002                 // increase new representative
1003                 uint32 dstRepNum = numCheckpoints[dstRep];
1004                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1005                 uint256 dstRepNew = dstRepOld.add(amount);
1006                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1007             }
1008         }
1009     }
1010 
1011     function _writeCheckpoint(
1012         address delegatee,
1013         uint32 nCheckpoints,
1014         uint256 oldVotes,
1015         uint256 newVotes
1016     )
1017         internal
1018     {
1019         uint32 blockNumber = safe32(block.number, "XDEX::_writeCheckpoint: block number exceeds 32 bits");
1020 
1021         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1022             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1023         } else {
1024             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1025             numCheckpoints[delegatee] = nCheckpoints + 1;
1026         }
1027 
1028         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1029     }
1030 
1031     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1032         require(n < 2**32, errorMessage);
1033         return uint32(n);
1034     }
1035 
1036     function getChainId() internal pure returns (uint) {
1037         uint256 chainId;
1038         assembly { chainId := chainid() }
1039         return chainId;
1040     }
1041 }