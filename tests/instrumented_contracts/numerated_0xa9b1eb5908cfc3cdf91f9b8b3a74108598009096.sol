1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 
6 
7 pragma solidity ^0.6.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
31 
32 
33 
34 pragma solidity ^0.6.0;
35 
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
111 
112 
113 
114 pragma solidity ^0.6.0;
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      *
138      * - Addition cannot overflow.
139      */
140     function add(uint256 a, uint256 b) internal pure returns (uint256) {
141         uint256 c = a + b;
142         require(c >= a, "SafeMath: addition overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         uint256 c = a - b;
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `*` operator.
183      *
184      * Requirements:
185      *
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(a, b, "SafeMath: division by zero");
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b > 0, errorMessage);
232         uint256 c = a / b;
233         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts with custom message when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 // File: @openzeppelin/contracts/utils/Address.sol
273 
274 
275 
276 pragma solidity ^0.6.2;
277 
278 /**
279  * @dev Collection of functions related to the address type
280  */
281 library Address {
282     /**
283      * @dev Returns true if `account` is a contract.
284      *
285      * [IMPORTANT]
286      * ====
287      * It is unsafe to assume that an address for which this function returns
288      * false is an externally-owned account (EOA) and not a contract.
289      *
290      * Among others, `isContract` will return false for the following
291      * types of addresses:
292      *
293      *  - an externally-owned account
294      *  - a contract in construction
295      *  - an address where a contract will be created
296      *  - an address where a contract lived, but was destroyed
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
301         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
302         // for accounts without code, i.e. `keccak256('')`
303         bytes32 codehash;
304         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
305         // solhint-disable-next-line no-inline-assembly
306         assembly { codehash := extcodehash(account) }
307         return (codehash != accountHash && codehash != 0x0);
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
330         (bool success, ) = recipient.call{ value: amount }("");
331         require(success, "Address: unable to send value, recipient may have reverted");
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain`call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353       return functionCall(target, data, "Address: low-level call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358      * `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
363         return _functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
388         require(address(this).balance >= value, "Address: insufficient balance for call");
389         return _functionCallWithValue(target, data, value, errorMessage);
390     }
391 
392     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
393         require(isContract(target), "Address: call to non-contract");
394 
395         // solhint-disable-next-line avoid-low-level-calls
396         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403 
404                 // solhint-disable-next-line no-inline-assembly
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
417 
418 
419 
420 pragma solidity ^0.6.0;
421 
422 
423 
424 
425 
426 /**
427  * @dev Implementation of the {IERC20} interface.
428  *
429  * This implementation is agnostic to the way tokens are created. This means
430  * that a supply mechanism has to be added in a derived contract using {_mint}.
431  * For a generic mechanism see {ERC20PresetMinterPauser}.
432  *
433  * TIP: For a detailed writeup see our guide
434  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
435  * to implement supply mechanisms].
436  *
437  * We have followed general OpenZeppelin guidelines: functions revert instead
438  * of returning `false` on failure. This behavior is nonetheless conventional
439  * and does not conflict with the expectations of ERC20 applications.
440  *
441  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
442  * This allows applications to reconstruct the allowance for all accounts just
443  * by listening to said events. Other implementations of the EIP may not emit
444  * these events, as it isn't required by the specification.
445  *
446  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
447  * functions have been added to mitigate the well-known issues around setting
448  * allowances. See {IERC20-approve}.
449  */
450 contract ERC20 is Context, IERC20 {
451     using SafeMath for uint256;
452     using Address for address;
453 
454     mapping (address => uint256) private _balances;
455 
456     mapping (address => mapping (address => uint256)) private _allowances;
457 
458     uint256 private _totalSupply;
459 
460     string private _name;
461     string private _symbol;
462     uint8 private _decimals;
463 
464     /**
465      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
466      * a default value of 18.
467      *
468      * To select a different value for {decimals}, use {_setupDecimals}.
469      *
470      * All three of these values are immutable: they can only be set once during
471      * construction.
472      */
473     constructor (string memory name, string memory symbol) public {
474         _name = name;
475         _symbol = symbol;
476         _decimals = 18;
477     }
478 
479     /**
480      * @dev Returns the name of the token.
481      */
482     function name() public view returns (string memory) {
483         return _name;
484     }
485 
486     /**
487      * @dev Returns the symbol of the token, usually a shorter version of the
488      * name.
489      */
490     function symbol() public view returns (string memory) {
491         return _symbol;
492     }
493 
494     /**
495      * @dev Returns the number of decimals used to get its user representation.
496      * For example, if `decimals` equals `2`, a balance of `505` tokens should
497      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
498      *
499      * Tokens usually opt for a value of 18, imitating the relationship between
500      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
501      * called.
502      *
503      * NOTE: This information is only used for _display_ purposes: it in
504      * no way affects any of the arithmetic of the contract, including
505      * {IERC20-balanceOf} and {IERC20-transfer}.
506      */
507     function decimals() public view returns (uint8) {
508         return _decimals;
509     }
510 
511     /**
512      * @dev See {IERC20-totalSupply}.
513      */
514     function totalSupply() public view override returns (uint256) {
515         return _totalSupply;
516     }
517 
518     /**
519      * @dev See {IERC20-balanceOf}.
520      */
521     function balanceOf(address account) public view override returns (uint256) {
522         return _balances[account];
523     }
524 
525     /**
526      * @dev See {IERC20-transfer}.
527      *
528      * Requirements:
529      *
530      * - `recipient` cannot be the zero address.
531      * - the caller must have a balance of at least `amount`.
532      */
533     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
534         _transfer(_msgSender(), recipient, amount);
535         return true;
536     }
537 
538     /**
539      * @dev See {IERC20-allowance}.
540      */
541     function allowance(address owner, address spender) public view virtual override returns (uint256) {
542         return _allowances[owner][spender];
543     }
544 
545     /**
546      * @dev See {IERC20-approve}.
547      *
548      * Requirements:
549      *
550      * - `spender` cannot be the zero address.
551      */
552     function approve(address spender, uint256 amount) public virtual override returns (bool) {
553         _approve(_msgSender(), spender, amount);
554         return true;
555     }
556 
557     /**
558      * @dev See {IERC20-transferFrom}.
559      *
560      * Emits an {Approval} event indicating the updated allowance. This is not
561      * required by the EIP. See the note at the beginning of {ERC20};
562      *
563      * Requirements:
564      * - `sender` and `recipient` cannot be the zero address.
565      * - `sender` must have a balance of at least `amount`.
566      * - the caller must have allowance for ``sender``'s tokens of at least
567      * `amount`.
568      */
569     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
570         _transfer(sender, recipient, amount);
571         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
572         return true;
573     }
574 
575     /**
576      * @dev Atomically increases the allowance granted to `spender` by the caller.
577      *
578      * This is an alternative to {approve} that can be used as a mitigation for
579      * problems described in {IERC20-approve}.
580      *
581      * Emits an {Approval} event indicating the updated allowance.
582      *
583      * Requirements:
584      *
585      * - `spender` cannot be the zero address.
586      */
587     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
588         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
589         return true;
590     }
591 
592     /**
593      * @dev Atomically decreases the allowance granted to `spender` by the caller.
594      *
595      * This is an alternative to {approve} that can be used as a mitigation for
596      * problems described in {IERC20-approve}.
597      *
598      * Emits an {Approval} event indicating the updated allowance.
599      *
600      * Requirements:
601      *
602      * - `spender` cannot be the zero address.
603      * - `spender` must have allowance for the caller of at least
604      * `subtractedValue`.
605      */
606     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
607         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
608         return true;
609     }
610 
611     /**
612      * @dev Moves tokens `amount` from `sender` to `recipient`.
613      *
614      * This is internal function is equivalent to {transfer}, and can be used to
615      * e.g. implement automatic token fees, slashing mechanisms, etc.
616      *
617      * Emits a {Transfer} event.
618      *
619      * Requirements:
620      *
621      * - `sender` cannot be the zero address.
622      * - `recipient` cannot be the zero address.
623      * - `sender` must have a balance of at least `amount`.
624      */
625     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
626         require(sender != address(0), "ERC20: transfer from the zero address");
627         require(recipient != address(0), "ERC20: transfer to the zero address");
628 
629         _beforeTokenTransfer(sender, recipient, amount);
630 
631         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
632         _balances[recipient] = _balances[recipient].add(amount);
633         emit Transfer(sender, recipient, amount);
634     }
635 
636     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
637      * the total supply.
638      *
639      * Emits a {Transfer} event with `from` set to the zero address.
640      *
641      * Requirements
642      *
643      * - `to` cannot be the zero address.
644      */
645     function _mint(address account, uint256 amount) internal virtual {
646         require(account != address(0), "ERC20: mint to the zero address");
647 
648         _beforeTokenTransfer(address(0), account, amount);
649 
650         _totalSupply = _totalSupply.add(amount);
651         _balances[account] = _balances[account].add(amount);
652         emit Transfer(address(0), account, amount);
653     }
654 
655     /**
656      * @dev Destroys `amount` tokens from `account`, reducing the
657      * total supply.
658      *
659      * Emits a {Transfer} event with `to` set to the zero address.
660      *
661      * Requirements
662      *
663      * - `account` cannot be the zero address.
664      * - `account` must have at least `amount` tokens.
665      */
666     function _burn(address account, uint256 amount) internal virtual {
667         require(account != address(0), "ERC20: burn from the zero address");
668 
669         _beforeTokenTransfer(account, address(0), amount);
670 
671         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
672         _totalSupply = _totalSupply.sub(amount);
673         emit Transfer(account, address(0), amount);
674     }
675 
676     /**
677      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
678      *
679      * This is internal function is equivalent to `approve`, and can be used to
680      * e.g. set automatic allowances for certain subsystems, etc.
681      *
682      * Emits an {Approval} event.
683      *
684      * Requirements:
685      *
686      * - `owner` cannot be the zero address.
687      * - `spender` cannot be the zero address.
688      */
689     function _approve(address owner, address spender, uint256 amount) internal virtual {
690         require(owner != address(0), "ERC20: approve from the zero address");
691         require(spender != address(0), "ERC20: approve to the zero address");
692 
693         _allowances[owner][spender] = amount;
694         emit Approval(owner, spender, amount);
695     }
696 
697     /**
698      * @dev Sets {decimals} to a value other than the default one of 18.
699      *
700      * WARNING: This function should only be called from the constructor. Most
701      * applications that interact with token contracts will not expect
702      * {decimals} to ever change, and may work incorrectly if it does.
703      */
704     function _setupDecimals(uint8 decimals_) internal {
705         _decimals = decimals_;
706     }
707 
708     /**
709      * @dev Hook that is called before any transfer of tokens. This includes
710      * minting and burning.
711      *
712      * Calling conditions:
713      *
714      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
715      * will be to transferred to `to`.
716      * - when `from` is zero, `amount` tokens will be minted for `to`.
717      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
718      * - `from` and `to` are never both zero.
719      *
720      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
721      */
722     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
723 }
724 
725 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
726 
727 
728 
729 pragma solidity ^0.6.0;
730 
731 
732 /**
733  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
734  */
735 abstract contract ERC20Capped is ERC20 {
736     uint256 private _cap;
737 
738     /**
739      * @dev Sets the value of the `cap`. This value is immutable, it can only be
740      * set once during construction.
741      */
742     constructor (uint256 cap) public {
743         require(cap > 0, "ERC20Capped: cap is 0");
744         _cap = cap;
745     }
746 
747     /**
748      * @dev Returns the cap on the token's total supply.
749      */
750     function cap() public view returns (uint256) {
751         return _cap;
752     }
753 
754     /**
755      * @dev See {ERC20-_beforeTokenTransfer}.
756      *
757      * Requirements:
758      *
759      * - minted tokens must not cause the total supply to go over the cap.
760      */
761     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
762         super._beforeTokenTransfer(from, to, amount);
763 
764         if (from == address(0)) { // When minting tokens
765             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
766         }
767     }
768 }
769 
770 // File: contracts/BounceAuctionToken.sol
771 
772 
773 
774 pragma solidity ^0.6.0;
775 
776 
777 contract BounceAuctionToken is ERC20Capped {
778     using SafeMath for uint;
779 
780     address internal constant DeadAddress = 0x000000000000000000000000000000000000dEaD;
781     address immutable private _botToken;
782 
783     event Swapped(address indexed sender, uint amountBot, uint amountAuction);
784 
785     constructor (address botToken) ERC20Capped(10000000e18) ERC20("Bounce Token", "Auction") public {
786         _botToken = botToken;
787     }
788 
789     function swap(uint amountBot) external {
790         uint amountAuction = amountBot.mul(100);
791         ERC20(_botToken).transferFrom(msg.sender, DeadAddress, amountBot);
792         _mint(msg.sender, amountAuction);
793         emit Swapped(msg.sender, amountBot, amountAuction);
794     }
795 }