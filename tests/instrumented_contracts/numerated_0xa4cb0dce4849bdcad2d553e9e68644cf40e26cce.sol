1 /**
2  *Submitted for verification at Etherscan.io on 2021-06
3 */
4 
5 // File: @openzeppelin/contracts/GSN/Context.sol
6 // BAKED is a SUSHI Token with governance, with it's unique attributes originally based on Compound's Governance Alpha Smart contracts
7 
8 
9 
10 pragma solidity ^0.6.2;
11 
12 /*
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with GSN meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
34 
35 
36 
37 ////pragma solidity ^0.6.0;
38 
39 /**
40  * @dev Interface of the ERC20 standard as defined in the EIP.
41  */
42 interface IERC20 {
43     /**
44      * @dev Returns the amount of tokens in existence.
45      */
46     function totalSupply() external view returns (uint256);
47 
48     /**
49      * @dev Returns the amount of tokens owned by `account`.
50      */
51     function balanceOf(address account) external view returns (uint256);
52 
53     /**
54      * @dev Moves `amount` tokens from the caller's account to `recipient`.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Returns the remaining number of tokens that `spender` will be
64      * allowed to spend on behalf of `owner` through {transferFrom}. This is
65      * zero by default.
66      *
67      * This value changes when {approve} or {transferFrom} are called.
68      */
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `sender` to `recipient` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 // File: @openzeppelin/contracts/math/SafeMath.sol
114 
115 
116 
117 ////pragma solidity ^0.6.0;
118 
119 /**
120  * @dev Wrappers over Solidity's arithmetic operations with added overflow
121  * checks.
122  *
123  * Arithmetic operations in Solidity wrap on overflow. This can easily result
124  * in bugs, because programmers usually assume that an overflow raises an
125  * error, which is the standard behavior in high level programming languages.
126  * `SafeMath` restores this intuition by reverting the transaction when an
127  * operation overflows.
128  *
129  * Using this library instead of the unchecked operations eliminates an entire
130  * class of bugs, so it's recommended to use it always.
131  */
132 library SafeMath {
133     /**
134      * @dev Returns the addition of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `+` operator.
138      *
139      * Requirements:
140      *
141      * - Addition cannot overflow.
142      */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         return sub(a, b, "SafeMath: subtraction overflow");
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
166      * overflow (when the result is negative).
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         uint256 c = a - b;
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      *
189      * - Multiplication cannot overflow.
190      */
191     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
193         // benefit is lost if 'b' is also tested.
194         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
195         if (a == 0) {
196             return 0;
197         }
198 
199         uint256 c = a * b;
200         require(c / a == b, "SafeMath: multiplication overflow");
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         return div(a, b, "SafeMath: division by zero");
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b > 0, errorMessage);
235         uint256 c = a / b;
236         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         return mod(a, b, "SafeMath: modulo by zero");
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * Reverts with custom message when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).˳
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b != 0, errorMessage);
271         return a % b;
272     }
273 }
274 
275 // File: @openzeppelin/contracts/utils/Address.sol
276 
277 
278 
279 ////pragma solidity ^0.6.2;
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
304         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
305         // for accounts without code, i.e. `keccak256('')`
306         bytes32 codehash;
307         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
308         // solhint-disable-next-line no-inline-assembly
309         assembly { codehash := extcodehash(account) }
310         return (codehash != accountHash && codehash != 0x0);
311     }
312 
313     /**
314      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
315      * `recipient`, forwarding all available gas and reverting on errors.
316      *
317      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
318      * of certain opcodes, possibly making contracts go over the 2300 gas limit
319      * imposed by `transfer`, making them unable to receive funds via
320      * `transfer`. {sendValue} removes this limitation.
321      *
322      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
323      *
324      * IMPORTANT: because control is transferred to `recipient`, care must be
325      * taken to not create reentrancy vulnerabilities. Consider using
326      * {ReentrancyGuard} or the
327      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
328      */
329     function sendValue(address payable recipient, uint256 amount) internal {
330         require(address(this).balance >= amount, "Address: insufficient balance");
331 
332         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
333         (bool success, ) = recipient.call{ value: amount }("");
334         require(success, "Address: unable to send value, recipient may have reverted");
335     }
336 
337     /**
338      * @dev Performs a Solidity function call using a low level `call`. A
339      * plain`call` is an unsafe replacement for a function call: use this
340      * function instead.
341      *
342      * If `target` reverts with a revert reason, it is bubbled up by this
343      * function (like regular Solidity function calls).
344      *
345      * Returns the raw returned data. To convert to the expected return value,
346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
347      *
348      * Requirements:
349      *
350      * - `target` must be a contract.
351      * - calling `target` with `data` must not revert.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
356       return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361      * `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
366         return _functionCallWithValue(target, data, 0, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but also transferring `value` wei to `target`.
372      *
373      * Requirements:
374      *
375      * - the calling contract must have an ETH balance of at least `value`.
376      * - the called Solidity function must be `payable`.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
386      * with `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
391         require(address(this).balance >= value, "Address: insufficient balance for call");
392         return _functionCallWithValue(target, data, value, errorMessage);
393     }
394 
395     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
396         require(isContract(target), "Address: call to non-contract");
397 
398         // solhint-disable-next-line avoid-low-level-calls
399         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
400         if (success) {
401             return returndata;
402         } else {
403             // Look for revert reason and bubble it up if present
404             if (returndata.length > 0) {
405                 // The easiest way to bubble the revert reason is using memory via assembly
406 
407                 // solhint-disable-next-line no-inline-assembly
408                 assembly {
409                     let returndata_size := mload(returndata)
410                     revert(add(32, returndata), returndata_size)
411                 }
412             } else {
413                 revert(errorMessage);
414             }
415         }
416     }
417 }
418 
419 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
420 
421 
422 
423 //pragma solidity ^0.6.0;
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
480         _totalSupply = 300000000;
481         _balances[msg.sender] = _totalSupply;
482     }
483 
484     /**
485      * @dev Returns the name of the token.
486      */
487     function name() public view returns (string memory) {
488         return _name;
489     }
490 
491     /**
492      * @dev Returns the symbol of the token, usually a shorter version of the
493      * name.
494      */
495     function symbol() public view returns (string memory) {
496         return _symbol;
497     }
498 
499     /**
500      * @dev Returns the number of decimals used to get its user representation.
501      * For example, if `decimals` equals `2`, a balance of `505` tokens should
502      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
503      *
504      * Tokens usually opt for a value of 18, imitating the relationship between
505      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
506      * called.
507      *
508      * NOTE: This information is only used for _display_ purposes: it in
509      * no way affects any of the arithmetic of the contract, including
510      * {IERC20-balanceOf} and {IERC20-transfer}.
511      */
512     function decimals() public view returns (uint8) {
513         return _decimals;
514     }
515 
516     /**
517      * @dev See {IERC20-totalSupply}.
518      */
519     function totalSupply() public view override returns (uint256) {
520         return _totalSupply;
521     }
522 
523     /**
524      * @dev See {IERC20-balanceOf}.
525      */
526     function balanceOf(address account) public view override returns (uint256) {
527         return _balances[account];
528     }
529 
530     /**
531      * @dev See {IERC20-transfer}.
532      *
533      * Requirements:
534      *
535      * - `recipient` cannot be the zero address.
536      * - the caller must have a balance of at least `amount`.
537      */
538     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
539         _transfer(_msgSender(), recipient, amount);
540         return true;
541     }
542 
543     /**
544      * @dev See {IERC20-allowance}.
545      */
546     function allowance(address owner, address spender) public view virtual override returns (uint256) {
547         return _allowances[owner][spender];
548     }
549 
550     /**
551      * @dev See {IERC20-approve}.
552      *
553      * Requirements:
554      *
555      * - `spender` cannot be the zero address.
556      */
557     function approve(address spender, uint256 amount) public virtual override returns (bool) {
558         _approve(_msgSender(), spender, amount);
559         return true;
560     }
561 
562     /**
563      * @dev See {IERC20-transferFrom}.
564      *
565      * Emits an {Approval} event indicating the updated allowance. This is not
566      * required by the EIP. See the note at the beginning of {ERC20};
567      *
568      * Requirements:
569      * - `sender` and `recipient` cannot be the zero address.
570      * - `sender` must have a balance of at least `amount`.
571      * - the caller must have allowance for ``sender``'s tokens of at least
572      * `amount`.
573      */
574     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
575         _transfer(sender, recipient, amount);
576         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
577         return true;
578     }
579 
580     /**
581      * @dev Atomically increases the allowance granted to `spender` by the caller.
582      *
583      * This is an alternative to {approve} that can be used as a mitigation for
584      * problems described in {IERC20-approve}.
585      *
586      * Emits an {Approval} event indicating the updated allowance.
587      *
588      * Requirements:
589      *
590      * - `spender` cannot be the zero address.
591      */
592     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
593         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
594         return true;
595     }
596 
597     /**
598      * @dev Atomically decreases the allowance granted to `spender` by the caller.
599      *
600      * This is an alternative to {approve} that can be used as a mitigation for
601      * problems described in {IERC20-approve}.
602      *
603      * Emits an {Approval} event indicating the updated allowance.
604      *
605      * Requirements:
606      *
607      * - `spender` cannot be the zero address.
608      * - `spender` must have allowance for the caller of at least
609      * `subtractedValue`.
610      */
611     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
612         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
613         return true;
614     }
615 
616     /**
617      * @dev Moves tokens `amount` from `sender` to `recipient`.
618      *
619      * This is internal function is equivalent to {transfer}, and can be used to
620      * e.g. implement automatic token fees, slashing mechanisms, etc.
621      *
622      * Emits a {Transfer} event.
623      *
624      * Requirements:
625      *
626      * - `sender` cannot be the zero address.
627      * - `recipient` cannot be the zero address.
628      * - `sender` must have a balance of at least `amount`.
629      */
630     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
631         require(sender != address(0), "ERC20: transfer from the zero address");
632         require(recipient != address(0), "ERC20: transfer to the zero address");
633 
634         _beforeTokenTransfer(sender, recipient, amount);
635 
636         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
637         _balances[recipient] = _balances[recipient].add(amount);
638         emit Transfer(sender, recipient, amount);
639     }
640 
641     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
642      * the total supply.
643      *
644      * Emits a {Transfer} event with `from` set to the zero address.
645      *
646      * Requirements
647      *
648      * - `to` cannot be the zero address.
649      */
650     function _mint(address account, uint256 amount) internal virtual {
651         require(account != address(0), "ERC20: mint to the zero address");
652 
653         _beforeTokenTransfer(address(0), account, amount);
654 
655         _totalSupply = _totalSupply.add(amount);
656         _balances[account] = _balances[account].add(amount);
657         emit Transfer(address(0), account, amount);
658     }
659 
660     /**
661      * @dev Destroys `amount` tokens from `account`, reducing the
662      * total supply.
663      *
664      * Emits a {Transfer} event with `to` set to the zero address.
665      *
666      * Requirements
667      *
668      * - `account` cannot be the zero address.
669      * - `account` must have at least `amount` tokens.
670      */
671     function _burn(address account, uint256 amount) internal virtual {
672         require(account != address(0), "ERC20: burn from the zero address");
673 
674         _beforeTokenTransfer(account, address(0), amount);
675 
676         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
677         _totalSupply = _totalSupply.sub(amount);
678         emit Transfer(account, address(0), amount);
679     }
680 
681     /**
682      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
683      *
684      * This is internal function is equivalent to `approve`, and can be used to
685      * e.g. set automatic allowances for certain subsystems, etc.
686      *
687      * Emits an {Approval} event.
688      *
689      * Requirements:
690      *
691      * - `owner` cannot be the zero address.
692      * - `spender` cannot be the zero address.
693      */
694     function _approve(address owner, address spender, uint256 amount) internal virtual {
695         require(owner != address(0), "ERC20: approve from the zero address");
696         require(spender != address(0), "ERC20: approve to the zero address");
697 
698         _allowances[owner][spender] = amount;
699         emit Approval(owner, spender, amount);
700     }
701 
702     /**
703      * @dev Sets {decimals} to a value other than the default one of 18.
704      *
705      * WARNING: This function should only be called from the constructor. Most
706      * applications that interact with token contracts will not expect
707      * {decimals} to ever change, and may work incorrectly if it does.
708      */
709     function _setupDecimals(uint8 decimals_) internal {
710         _decimals = decimals_;
711     }
712 
713     /**
714      * @dev Hook that is called before any transfer of tokens. This includes
715      * minting and burning.
716      *
717      * Calling conditions:
718      *
719      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
720      * will be to transferred to `to`.
721      * - when `from` is zero, `amount` tokens will be minted for `to`.
722      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
723      * - `from` and `to` are never both zero.
724      *
725      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
726      */
727     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
728 }
729 
730 // File: @openzeppelin/contracts/access/Ownable.sol
731 
732 
733 
734 //pragma solidity ^0.6.0;
735 
736 /**
737  * @dev Contract module which provides a basic access control mechanism, where
738  * there is an account (an owner) that can be granted exclusive access to
739  * specific functions.
740  *
741  * By default, the owner account will be the one that deploys the contract. This
742  * can later be changed with {transferOwnership}.
743  *
744  * This module is used through inheritance. It will make available the modifier
745  * `onlyOwner`, which can be applied to your functions to restrict their use to
746  * the owner.
747  */
748 contract Ownable is Context {
749     address private _owner;
750 
751     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
752 
753     /**
754      * @dev Initializes the contract setting the deployer as the initial owner.
755      */
756     constructor () internal {
757         address msgSender = _msgSender();
758         _owner = msgSender;
759         emit OwnershipTransferred(address(0), msgSender);
760     }
761 
762     /**
763      * @dev Returns the address of the current owner.
764      */
765     function owner() public view returns (address) {
766         return _owner;
767     }
768 
769     /**
770      * @dev Throws if called by any account other than the owner.
771      */
772     modifier onlyOwner() {
773         require(_owner == _msgSender(), "Ownable: caller is not the owner");
774         _;
775     }
776 
777     /**
778      * @dev Leaves the contract without owner. It will not be possible to call
779      * `onlyOwner` functions anymore. Can only be called by the current owner.
780      *
781      * NOTE: Renouncing ownership will leave the contract without an owner,
782      * thereby removing any functionality that is only available to the owner.
783      */
784     function renounceOwnership() public virtual onlyOwner {
785         emit OwnershipTransferred(_owner, address(0));
786         _owner = address(0);
787     }
788 
789     /**
790      * @dev Transfers ownership of the contract to a new account (`newOwner`).
791      * Can only be called by the current owner.
792      */
793     function transferOwnership(address newOwner) public virtual onlyOwner {
794         require(newOwner != address(0), "Ownable: new owner is the zero address");
795         emit OwnershipTransferred(_owner, newOwner);
796         _owner = newOwner;
797     }
798 }
799 
800 
801 ////pragma solidity 0.6.12;
802 
803 
804 
805 
806 contract BakedToken is ERC20("BakedToken", "BAKED"), Ownable {
807     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
808     function mint(address _to, uint256 _amount) public onlyOwner {
809         _mint(_to, _amount);
810         _moveDelegates(address(0), _delegates[_to], _amount);
811     }
812    
813 
814     // Copied and modified from YAM code:
815     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
816     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
817     // Which is copied and modified from COMPOUND:
818     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
819 
820     /// @notice A record of each accounts delegate
821     mapping (address => address) internal _delegates;
822 
823     /// @notice A checkpoint for marking number of votes from a given block
824     struct Checkpoint {
825         uint32 fromBlock;
826         uint256 votes;
827     }
828 
829     /// @notice A record of votes checkpoints for each account, by index
830     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
831 
832     /// @notice The number of checkpoints for each account
833     mapping (address => uint32) public numCheckpoints;
834 
835     /// @notice The EIP-712 typehash for the contract's domain
836     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
837 
838     /// @notice The EIP-712 typehash for the delegation struct used by the contract
839     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
840 
841     /// @notice A record of states for signing / validating signatures
842     mapping (address => uint) public nonces;
843 
844       /// @notice An event thats emitted when an account changes its delegate
845     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
846 
847     /// @notice An event thats emitted when a delegate account's vote balance changes
848     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
849 
850     /**
851      * @notice Delegate votes from `msg.sender` to `delegatee`
852      * @param delegator The address to get delegatee for
853      */
854     function delegates(address delegator)
855         external
856         view
857         returns (address)
858     {
859         return _delegates[delegator];
860     }
861 
862    /**
863     * @notice Delegate votes from `msg.sender` to `delegatee`
864     * @param delegatee The address to delegate votes to
865     */
866     function delegate(address delegatee) external {
867         return _delegate(msg.sender, delegatee);
868     }
869 
870     /**
871      * @notice Delegates votes from signatory to `delegatee`
872      * @param delegatee The address to delegate votes to
873      * @param nonce The contract state required to match the signature
874      * @param expiry The time at which to expire the signature
875      * @param v The recovery byte of the signature
876      * @param r Half of the ECDSA signature pair
877      * @param s Half of the ECDSA signature pair
878      */
879     function delegateBySig(
880         address delegatee,
881         uint nonce,
882         uint expiry,
883         uint8 v,
884         bytes32 r,
885         bytes32 s
886     )
887         external
888     {
889         bytes32 domainSeparator = keccak256(
890             abi.encode(
891                 DOMAIN_TYPEHASH,
892                 keccak256(bytes(name())),
893                 getChainId(),
894                 address(this)
895             )
896         );
897 
898         bytes32 structHash = keccak256(
899             abi.encode(
900                 DELEGATION_TYPEHASH,
901                 delegatee,
902                 nonce,
903                 expiry
904             )
905         );
906 
907         bytes32 digest = keccak256(
908             abi.encodePacked(
909                 "\x19\x01",
910                 domainSeparator,
911                 structHash
912             )
913         );
914 
915         address signatory = ecrecover(digest, v, r, s);
916         require(signatory != address(0), "BAKED::delegateBySig: invalid signature");
917         require(nonce == nonces[signatory]++, "BAKED::delegateBySig: invalid nonce");
918         require(now <= expiry, "BAKED::delegateBySig: signature expired");
919         return _delegate(signatory, delegatee);
920     }
921 
922     /**
923      * @notice Gets the current votes balance for `account`
924      * @param account The address to get votes balance
925      * @return The number of current votes for `account`
926      */
927     function getCurrentVotes(address account)
928         external
929         view
930         returns (uint256)
931     {
932         uint32 nCheckpoints = numCheckpoints[account];
933         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
934     }
935 
936     /**
937      * @notice Determine the prior number of votes for an account as of a block number
938      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
939      * @param account The address of the account to check
940      * @param blockNumber The block number to get the vote balance at
941      * @return The number of votes the account had as of the given block
942      */
943     function getPriorVotes(address account, uint blockNumber)
944         external
945         view
946         returns (uint256)
947     {
948         require(blockNumber < block.number, "BAKED::getPriorVotes: not yet determined");
949 
950         uint32 nCheckpoints = numCheckpoints[account];
951         if (nCheckpoints == 0) {
952             return 0;
953         }
954 
955         // First check most recent balance
956         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
957             return checkpoints[account][nCheckpoints - 1].votes;
958         }
959 
960         // Next check implicit zero balance
961         if (checkpoints[account][0].fromBlock > blockNumber) {
962             return 0;
963         }
964 
965         uint32 lower = 0;
966         uint32 upper = nCheckpoints - 1;
967         while (upper > lower) {
968             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
969             Checkpoint memory cp = checkpoints[account][center];
970             if (cp.fromBlock == blockNumber) {
971                 return cp.votes;
972             } else if (cp.fromBlock < blockNumber) {
973                 lower = center;
974             } else {
975                 upper = center - 1;
976             }
977         }
978         return checkpoints[account][lower].votes;
979     }
980 
981     function _delegate(address delegator, address delegatee)
982         internal
983     {
984         address currentDelegate = _delegates[delegator];
985         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying BAKEDs (not scaled);
986         _delegates[delegator] = delegatee;
987 
988         emit DelegateChanged(delegator, currentDelegate, delegatee);
989 
990         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
991     }
992 
993     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
994         if (srcRep != dstRep && amount > 0) {
995             if (srcRep != address(0)) {
996                 // decrease old representative
997                 uint32 srcRepNum = numCheckpoints[srcRep];
998                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
999                 uint256 srcRepNew = srcRepOld.sub(amount);
1000                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1001             }
1002 
1003             if (dstRep != address(0)) {
1004                 // increase new representative
1005                 uint32 dstRepNum = numCheckpoints[dstRep];
1006                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1007                 uint256 dstRepNew = dstRepOld.add(amount);
1008                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1009             }
1010         }
1011     }
1012 
1013     function _writeCheckpoint(
1014         address delegatee,
1015         uint32 nCheckpoints,
1016         uint256 oldVotes,
1017         uint256 newVotes
1018     )
1019         internal
1020     {
1021         uint32 blockNumber = safe32(block.number, "BAKED::_writeCheckpoint: block number exceeds 32 bits");
1022 
1023         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1024             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1025         } else {
1026             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1027             numCheckpoints[delegatee] = nCheckpoints + 1;
1028         }
1029 
1030         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1031     }
1032 
1033     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1034         require(n < 2**32, errorMessage);
1035         return uint32(n);
1036     }
1037 
1038     function getChainId() internal pure returns (uint) {
1039         uint256 chainId;
1040         assembly { chainId := chainid() }
1041         return chainId;
1042     }
1043 }