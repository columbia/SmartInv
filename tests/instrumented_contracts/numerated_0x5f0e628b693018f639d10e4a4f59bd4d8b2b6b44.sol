1 // SPDX-License-Identifier: MIT
2 
3 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/utils/Address.sol
4 
5 
6 
7 pragma solidity ^0.6.2;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
32         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
33         // for accounts without code, i.e. `keccak256('')`
34         bytes32 codehash;
35         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { codehash := extcodehash(account) }
38         return (codehash != accountHash && codehash != 0x0);
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return _functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130                 // The easiest way to bubble the revert reason is using memory via assembly
131         } else {
132             // Look for revert reason and bubble it up if present
133             if (returndata.length > 0) {
134 
135                 // solhint-disable-next-line no-inline-assembly
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/math/SafeMath.sol
148 
149 
150 
151 
152 pragma solidity ^0.6.0;
153 
154 /**
155  * @dev Wrappers over Solidity's arithmetic operations with added overflow
156  * checks.
157  *
158  * Arithmetic operations in Solidity wrap on overflow. This can easily result
159  * in bugs, because programmers usually assume that an overflow raises an
160  * error, which is the standard behavior in high level programming languages.
161  * `SafeMath` restores this intuition by reverting the transaction when an
162  * operation overflows.
163  *
164  * Using this library instead of the unchecked operations eliminates an entire
165  * class of bugs, so it's recommended to use it always.
166  */
167 library SafeMath {
168     /**
169      * @dev Returns the addition of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `+` operator.
173      *
174      * Requirements:
175      *
176      * - Addition cannot overflow.
177      */
178     function add(uint256 a, uint256 b) internal pure returns (uint256) {
179         uint256 c = a + b;
180         require(c >= a, "SafeMath: addition overflow");
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the subtraction of two unsigned integers, reverting on
187      * overflow (when the result is negative).
188      *
189      * Counterpart to Solidity's `-` operator.
190      *
191      * Requirements:
192      *
193      * - Subtraction cannot overflow.
194      */
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         return sub(a, b, "SafeMath: subtraction overflow");
197     }
198 
199     /**
200      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
201      * overflow (when the result is negative).
202      *
203      * Counterpart to Solidity's `-` operator.
204      *
205      * Requirements:
206      *
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         require(b <= a, errorMessage);
211         uint256 c = a - b;
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the multiplication of two unsigned integers, reverting on
218      * overflow.
219      *
220      * Counterpart to Solidity's `*` operator.
221      *
222      * Requirements:
223      *
224      * - Multiplication cannot overflow.
225      */
226     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
227         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
228         // benefit is lost if 'b' is also tested.
229         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
230         if (a == 0) {
231             return 0;
232         }
233 
234         uint256 c = a * b;
235         require(c / a == b, "SafeMath: multiplication overflow");
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the integer division of two unsigned integers. Reverts on
242      * division by zero. The result is rounded towards zero.
243      *
244      * Counterpart to Solidity's `/` operator. Note: this function uses a
245      * `revert` opcode (which leaves remaining gas untouched) while Solidity
246      * uses an invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function div(uint256 a, uint256 b) internal pure returns (uint256) {
253         return div(a, b, "SafeMath: division by zero");
254     }
255 
256     /**
257      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
258      * division by zero. The result is rounded towards zero.
259      *
260      * Counterpart to Solidity's `/` operator. Note: this function uses a
261      * `revert` opcode (which leaves remaining gas untouched) while Solidity
262      * uses an invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b > 0, errorMessage);
270         uint256 c = a / b;
271         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
272 
273         return c;
274     }
275 
276     /**
277      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
278      * Reverts when dividing by zero.
279      *
280      * Counterpart to Solidity's `%` operator. This function uses a `revert`
281      * opcode (which leaves remaining gas untouched) while Solidity uses an
282      * invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      *
286      * - The divisor cannot be zero.
287      */
288     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
289         return mod(a, b, "SafeMath: modulo by zero");
290     }
291 
292     /**
293      * Counterpart to Solidity's `%` operator. This function uses a `revert`
294      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
295      * Reverts with custom message when dividing by zero.
296      *
297      * opcode (which leaves remaining gas untouched) while Solidity uses an
298      * invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      *
302      * - The divisor cannot be zero.
303      */
304     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         require(b != 0, errorMessage);
306         return a % b;
307     }
308 }
309 
310 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/IERC20.sol
311 
312 
313 
314 
315 pragma solidity ^0.6.0;
316 
317 /**
318  * @dev Interface of the ERC20 standard as defined in the EIP.
319  */
320 interface IERC20 {
321     /**
322      * @dev Returns the amount of tokens in existence.
323      */
324     function totalSupply() external view returns (uint256);
325 
326     /**
327      * @dev Returns the amount of tokens owned by `account`.
328      */
329     function balanceOf(address account) external view returns (uint256);
330 
331     /**
332      * @dev Moves `amount` tokens from the caller's account to `recipient`.
333      *
334      * Returns a boolean value indicating whether the operation succeeded.
335      *
336      * Emits a {Transfer} event.
337      */
338     function transfer(address recipient, uint256 amount) external returns (bool);
339 
340     /**
341      * @dev Returns the remaining number of tokens that `spender` will be
342      * allowed to spend on behalf of `owner` through {transferFrom}. This is
343      * zero by default.
344      *
345      * This value changes when {approve} or {transferFrom} are called.
346      */
347     function allowance(address owner, address spender) external view returns (uint256);
348 
349     /**
350      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
351      *
352      * Returns a boolean value indicating whether the operation succeeded.
353      *
354      * IMPORTANT: Beware that changing an allowance with this method brings the risk
355      * that someone may use both the old and the new allowance by unfortunate
356      * transaction ordering. One possible solution to mitigate this race
357      * condition is to first reduce the spender's allowance to 0 and set the
358      * desired value afterwards:
359      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
360      *
361      * Emits an {Approval} event.
362      */
363     function approve(address spender, uint256 amount) external returns (bool);
364 
365     /**
366      * @dev Moves `amount` tokens from `sender` to `recipient` using the
367      * allowance mechanism. `amount` is then deducted from the caller's
368      * allowance.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * Emits a {Transfer} event.
373      */
374     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
375 
376     /**
377      * another (`to`).
378      *
379      * Note that `value` may be zero.
380      */
381     event Transfer(address indexed from, address indexed to, uint256 value);
382 
383     /**
384      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
385      * a call to {approve}. `value` is the new allowance.
386      */
387     event Approval(address indexed owner, address indexed spender, uint256 value);
388 }
389 
390 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/GSN/Context.sol
391 
392 
393 
394 
395 pragma solidity ^0.6.0;
396 
397 /*
398  * @dev Provides information about the current execution context, including the
399  * sender of the transaction and its data. While these are generally available
400  * via msg.sender and msg.data, they should not be accessed in such a direct
401  *
402  * manner, since when dealing with GSN meta-transactions the account sending and
403  * paying for execution may not be the actual sender (as far as an application
404  * is concerned).
405  * This contract is only required for intermediate, library-like contracts.
406  */
407 abstract contract Context {
408     function _msgSender() internal view virtual returns (address payable) {
409         return msg.sender;
410     }
411 
412     function _msgData() internal view virtual returns (bytes memory) {
413         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
414         return msg.data;
415     }
416 }
417 
418 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/ERC20.sol
419 
420 
421 
422 
423 pragma solidity ^0.6.0;
424 
425 
426 
427 
428 
429 /**
430  * @dev Implementation of the {IERC20} interface.
431  *
432  * This implementation is agnostic to the way tokens are created. This means
433  * that a supply mechanism has to be added in a derived contract using {_mint}.
434  * For a generic mechanism see {ERC20PresetMinterPauser}.
435  *
436  * TIP: For a detailed writeup see our guide
437  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
438  * to implement supply mechanisms].
439  *
440  * We have followed general OpenZeppelin guidelines: functions revert instead
441  * of returning `false` on failure. This behavior is nonetheless conventional
442  * and does not conflict with the expectations of ERC20 applications.
443  *
444  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
445  * This allows applications to reconstruct the allowance for all accounts just
446  * by listening to said events. Other implementations of the EIP may not emit
447  * these events, as it isn't required by the specification.
448  *
449  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
450  * functions have been added to mitigate the well-known issues around setting
451  * allowances. See {IERC20-approve}.
452  */
453 contract ERC20 is Context, IERC20 {
454     using SafeMath for uint256;
455     using Address for address;
456 
457     mapping (address => uint256) private _balances;
458 
459     mapping (address => mapping (address => uint256)) private _allowances;
460 
461     uint256 private _totalSupply;
462 
463     string private _name;
464     string private _symbol;
465     uint8 private _decimals;
466 
467     /**
468      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
469      * a default value of 18.
470      *
471      * To select a different value for {decimals}, use {_setupDecimals}.
472      *
473      * All three of these values are immutable: they can only be set once during
474      * construction.
475      */
476     constructor (string memory name, string memory symbol) public {
477         _name = name;
478         _symbol = symbol;
479         _decimals = 18;
480     }
481 
482     /**
483      * @dev Returns the name of the token.
484      */
485     function name() public view returns (string memory) {
486         return _name;
487     }
488 
489     /**
490      * @dev Returns the symbol of the token, usually a shorter version of the
491      * name.
492      */
493     function symbol() public view returns (string memory) {
494         return _symbol;
495     }
496 
497     /**
498      * @dev Returns the number of decimals used to get its user representation.
499      * For example, if `decimals` equals `2`, a balance of `505` tokens should
500      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
501      *
502      * Tokens usually opt for a value of 18, imitating the relationship between
503      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
504      * called.
505      *
506      * NOTE: This information is only used for _display_ purposes: it in
507      * no way affects any of the arithmetic of the contract, including
508      * {IERC20-balanceOf} and {IERC20-transfer}.
509      */
510     function decimals() public view returns (uint8) {
511         return _decimals;
512     }
513 
514     /**
515      * @dev See {IERC20-totalSupply}.
516      */
517     function totalSupply() public view override returns (uint256) {
518         return _totalSupply;
519     }
520 
521     /**
522      * @dev See {IERC20-balanceOf}.
523      */
524     function balanceOf(address account) public view override returns (uint256) {
525         return _balances[account];
526     }
527 
528     /**
529      * @dev See {IERC20-transfer}.
530      *
531      * Requirements:
532      *
533      * - `recipient` cannot be the zero address.
534      * - the caller must have a balance of at least `amount`.
535      */
536     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
537         _transfer(_msgSender(), recipient, amount);
538         return true;
539     }
540 
541     /**
542      * @dev See {IERC20-allowance}.
543      */
544     function allowance(address owner, address spender) public view virtual override returns (uint256) {
545         return _allowances[owner][spender];
546     }
547 
548     /**
549      * @dev See {IERC20-approve}.
550      *
551      * Requirements:
552      *
553      * - `spender` cannot be the zero address.
554      */
555     function approve(address spender, uint256 amount) public virtual override returns (bool) {
556         _approve(_msgSender(), spender, amount);
557         return true;
558     }
559 
560     /**
561      * @dev See {IERC20-transferFrom}.
562      *
563      * Emits an {Approval} event indicating the updated allowance. This is not
564      * required by the EIP. See the note at the beginning of {ERC20};
565      *
566      * Requirements:
567      * - `sender` and `recipient` cannot be the zero address.
568      * - `sender` must have a balance of at least `amount`.
569      * - the caller must have allowance for ``sender``'s tokens of at least
570      * `amount`.
571      */
572     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
573         _transfer(sender, recipient, amount);
574         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
575         return true;
576     }
577 
578     /**
579      * @dev Atomically increases the allowance granted to `spender` by the caller.
580      *
581      * This is an alternative to {approve} that can be used as a mitigation for
582      * problems described in {IERC20-approve}.
583      *
584      * Emits an {Approval} event indicating the updated allowance.
585      *
586      * Requirements:
587      *
588      * - `spender` cannot be the zero address.
589      */
590     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
591         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
592         return true;
593     }
594 
595     /**
596      * @dev Atomically decreases the allowance granted to `spender` by the caller.
597      *
598      * This is an alternative to {approve} that can be used as a mitigation for
599      * problems described in {IERC20-approve}.
600      *
601      * Emits an {Approval} event indicating the updated allowance.
602      *
603      * Requirements:
604      *
605      * - `spender` cannot be the zero address.
606      * - `spender` must have allowance for the caller of at least
607      * `subtractedValue`.
608      */
609     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
610         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
611         return true;
612     }
613 
614     /**
615      * @dev Moves tokens `amount` from `sender` to `recipient`.
616      *
617      * This is internal function is equivalent to {transfer}, and can be used to
618      * e.g. implement automatic token fees, slashing mechanisms, etc.
619      *
620      * Emits a {Transfer} event.
621      *
622      * Requirements:
623      *
624      * - `sender` cannot be the zero address.
625      * - `recipient` cannot be the zero address.
626      * - `sender` must have a balance of at least `amount`.
627      */
628     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
629         require(sender != address(0), "ERC20: transfer from the zero address");
630         require(recipient != address(0), "ERC20: transfer to the zero address");
631 
632         _beforeTokenTransfer(sender, recipient, amount);
633 
634         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
635         _balances[recipient] = _balances[recipient].add(amount);
636         emit Transfer(sender, recipient, amount);
637     }
638 
639     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
640      * the total supply.
641      *
642      * Emits a {Transfer} event with `from` set to the zero address.
643      *
644      * Requirements
645      *
646      * - `to` cannot be the zero address.
647      */
648     function _mint(address account, uint256 amount) internal virtual {
649         require(account != address(0), "ERC20: mint to the zero address");
650 
651         _beforeTokenTransfer(address(0), account, amount);
652 
653         _totalSupply = _totalSupply.add(amount);
654         _balances[account] = _balances[account].add(amount);
655         emit Transfer(address(0), account, amount);
656     }
657 
658     /**
659      * @dev Destroys `amount` tokens from `account`, reducing the
660      * total supply.
661      *
662      * Emits a {Transfer} event with `to` set to the zero address.
663      *
664      * Requirements
665      *
666      * - `account` cannot be the zero address.
667      * - `account` must have at least `amount` tokens.
668      */
669     function _burn(address account, uint256 amount) internal virtual {
670         require(account != address(0), "ERC20: burn from the zero address");
671 
672         _beforeTokenTransfer(account, address(0), amount);
673 
674         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
675         _totalSupply = _totalSupply.sub(amount);
676         emit Transfer(account, address(0), amount);
677     }
678 
679     /**
680      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
681      *
682      * This is internal function is equivalent to `approve`, and can be used to
683      * e.g. set automatic allowances for certain subsystems, etc.
684      *
685      * Emits an {Approval} event.
686      *
687      * Requirements:
688      *
689      * - `owner` cannot be the zero address.
690      * - `spender` cannot be the zero address.
691      */
692     function _approve(address owner, address spender, uint256 amount) internal virtual {
693         require(owner != address(0), "ERC20: approve from the zero address");
694         require(spender != address(0), "ERC20: approve to the zero address");
695 
696         _allowances[owner][spender] = amount;
697         emit Approval(owner, spender, amount);
698     }
699 
700     /**
701      * @dev Sets {decimals} to a value other than the default one of 18.
702      *
703      * WARNING: This function should only be called from the constructor. Most
704      * applications that interact with token contracts will not expect
705      * {decimals} to ever change, and may work incorrectly if it does.
706      */
707     function _setupDecimals(uint8 decimals_) internal {
708         _decimals = decimals_;
709     }
710 
711     /**
712      * @dev Hook that is called before any transfer of tokens. This includes
713      * minting and burning.
714      * Calling conditions:
715      *
716      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
717      * will be to transferred to `to`.
718      * - when `from` is zero, `amount` tokens will be minted for `to`.
719      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
720      * - `from` and `to` are never both zero.
721      *
722      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
723      */
724     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
725 }
726 
727 
728 
729 pragma solidity ^0.6.10;
730 
731 contract Whiteheart is ERC20("Whiteheart Token", "WHITE") {
732     constructor() public {
733         uint INITIAL_SUPPLY = 8888e18;
734         _mint(msg.sender, INITIAL_SUPPLY);
735     }
736 }