1 // Octo.fi Token $OCTO 
2 // © 2020 Decentralized Tentacles
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.6.12;
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
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations with added overflow
104  * checks.
105  *
106  * Arithmetic operations in Solidity wrap on overflow. This can easily result
107  * in bugs, because programmers usually assume that an overflow raises an
108  * error, which is the standard behavior in high level programming languages.
109  * `SafeMath` restores this intuition by reverting the transaction when an
110  * operation overflows.
111  *
112  * Using this library instead of the unchecked operations eliminates an entire
113  * class of bugs, so it's recommended to use it always.
114  */
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      *
124      * - Addition cannot overflow.
125      */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         require(c >= a, "SafeMath: addition overflow");
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `*` operator.
169      *
170      * Requirements:
171      *
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b != 0, errorMessage);
254         return a % b;
255     }
256 }
257 
258 /**
259  * @dev Collection of functions related to the address type
260  */
261 library Address {
262     /**
263      * @dev Returns true if `account` is a contract.
264      *
265      * [IMPORTANT]
266      * ====
267      * It is unsafe to assume that an address for which this function returns
268      * false is an externally-owned account (EOA) and not a contract.
269      *
270      * Among others, `isContract` will return false for the following
271      * types of addresses:
272      *
273      *  - an externally-owned account
274      *  - a contract in construction
275      *  - an address where a contract will be created
276      *  - an address where a contract lived, but was destroyed
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
281         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
282         // for accounts without code, i.e. `keccak256('')`
283         bytes32 codehash;
284         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
285         // solhint-disable-next-line no-inline-assembly
286         assembly { codehash := extcodehash(account) }
287         return (codehash != accountHash && codehash != 0x0);
288     }
289 
290     /**
291      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
292      * `recipient`, forwarding all available gas and reverting on errors.
293      *
294      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
295      * of certain opcodes, possibly making contracts go over the 2300 gas limit
296      * imposed by `transfer`, making them unable to receive funds via
297      * `transfer`. {sendValue} removes this limitation.
298      *
299      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
300      *
301      * IMPORTANT: because control is transferred to `recipient`, care must be
302      * taken to not create reentrancy vulnerabilities. Consider using
303      * {ReentrancyGuard} or the
304      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
305      */
306     function sendValue(address payable recipient, uint256 amount) internal {
307         require(address(this).balance >= amount, "Address: insufficient balance");
308 
309         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
310         (bool success, ) = recipient.call{ value: amount }("");
311         require(success, "Address: unable to send value, recipient may have reverted");
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level `call`. A
316      * plain`call` is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If `target` reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324      *
325      * Requirements:
326      *
327      * - `target` must be a contract.
328      * - calling `target` with `data` must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
333       return functionCall(target, data, "Address: low-level call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
338      * `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
343         return _functionCallWithValue(target, data, 0, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but also transferring `value` wei to `target`.
349      *
350      * Requirements:
351      *
352      * - the calling contract must have an ETH balance of at least `value`.
353      * - the called Solidity function must be `payable`.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
368         require(address(this).balance >= value, "Address: insufficient balance for call");
369         return _functionCallWithValue(target, data, value, errorMessage);
370     }
371 
372     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
373         require(isContract(target), "Address: call to non-contract");
374 
375         // solhint-disable-next-line avoid-low-level-calls
376         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
377         if (success) {
378             return returndata;
379         } else {
380             // Look for revert reason and bubble it up if present
381             if (returndata.length > 0) {
382                 // The easiest way to bubble the revert reason is using memory via assembly
383 
384                 // solhint-disable-next-line no-inline-assembly
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 /**
397  * @dev Implementation of the {IERC20} interface.
398  *
399  * This implementation is agnostic to the way tokens are created. This means
400  * that a supply mechanism has to be added in a derived contract using {_mint}.
401  * For a generic mechanism see {ERC20PresetMinterPauser}.
402  *
403  * TIP: For a detailed writeup see our guide
404  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
405  * to implement supply mechanisms].
406  *
407  * We have followed general OpenZeppelin guidelines: functions revert instead
408  * of returning `false` on failure. This behavior is nonetheless conventional
409  * and does not conflict with the expectations of ERC20 applications.
410  *
411  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
412  * This allows applications to reconstruct the allowance for all accounts just
413  * by listening to said events. Other implementations of the EIP may not emit
414  * these events, as it isn't required by the specification.
415  *
416  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
417  * functions have been added to mitigate the well-known issues around setting
418  * allowances. See {IERC20-approve}.
419  */
420 contract ERC20 is Context, IERC20 {
421     using SafeMath for uint256;
422     using Address for address;
423 
424     mapping (address => uint256) private _balances;
425 
426     mapping (address => mapping (address => uint256)) private _allowances;
427 
428     uint256 private _totalSupply;
429 
430     string private _name;
431     string private _symbol;
432     uint8 private _decimals;
433 
434     /**
435      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
436      * a default value of 18.
437      *
438      * To select a different value for {decimals}, use {_setupDecimals}.
439      *
440      * All three of these values are immutable: they can only be set once during
441      * construction.
442      */
443     constructor (string memory name, string memory symbol) public {
444         _name = name;
445         _symbol = symbol;
446         _decimals = 18;
447     }
448 
449     /**
450      * @dev Returns the name of the token.
451      */
452     function name() public view returns (string memory) {
453         return _name;
454     }
455 
456     /**
457      * @dev Returns the symbol of the token, usually a shorter version of the
458      * name.
459      */
460     function symbol() public view returns (string memory) {
461         return _symbol;
462     }
463 
464     /**
465      * @dev Returns the number of decimals used to get its user representation.
466      * For example, if `decimals` equals `2`, a balance of `505` tokens should
467      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
468      *
469      * Tokens usually opt for a value of 18, imitating the relationship between
470      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
471      * called.
472      *
473      * NOTE: This information is only used for _display_ purposes: it in
474      * no way affects any of the arithmetic of the contract, including
475      * {IERC20-balanceOf} and {IERC20-transfer}.
476      */
477     function decimals() public view returns (uint8) {
478         return _decimals;
479     }
480 
481     /**
482      * @dev See {IERC20-totalSupply}.
483      */
484     function totalSupply() public view override returns (uint256) {
485         return _totalSupply;
486     }
487 
488     /**
489      * @dev See {IERC20-balanceOf}.
490      */
491     function balanceOf(address account) public view override returns (uint256) {
492         return _balances[account];
493     }
494 
495     /**
496      * @dev See {IERC20-transfer}.
497      *
498      * Requirements:
499      *
500      * - `recipient` cannot be the zero address.
501      * - the caller must have a balance of at least `amount`.
502      */
503     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
504         _transfer(_msgSender(), recipient, amount);
505         return true;
506     }
507 
508     /**
509      * @dev See {IERC20-allowance}.
510      */
511     function allowance(address owner, address spender) public view virtual override returns (uint256) {
512         return _allowances[owner][spender];
513     }
514 
515     /**
516      * @dev See {IERC20-approve}.
517      *
518      * Requirements:
519      *
520      * - `spender` cannot be the zero address.
521      */
522     function approve(address spender, uint256 amount) public virtual override returns (bool) {
523         _approve(_msgSender(), spender, amount);
524         return true;
525     }
526 
527     /**
528      * @dev See {IERC20-transferFrom}.
529      *
530      * Emits an {Approval} event indicating the updated allowance. This is not
531      * required by the EIP. See the note at the beginning of {ERC20};
532      *
533      * Requirements:
534      * - `sender` and `recipient` cannot be the zero address.
535      * - `sender` must have a balance of at least `amount`.
536      * - the caller must have allowance for ``sender``'s tokens of at least
537      * `amount`.
538      */
539     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
540         _transfer(sender, recipient, amount);
541         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
542         return true;
543     }
544 
545     /**
546      * @dev Atomically increases the allowance granted to `spender` by the caller.
547      *
548      * This is an alternative to {approve} that can be used as a mitigation for
549      * problems described in {IERC20-approve}.
550      *
551      * Emits an {Approval} event indicating the updated allowance.
552      *
553      * Requirements:
554      *
555      * - `spender` cannot be the zero address.
556      */
557     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
558         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
559         return true;
560     }
561 
562     /**
563      * @dev Atomically decreases the allowance granted to `spender` by the caller.
564      *
565      * This is an alternative to {approve} that can be used as a mitigation for
566      * problems described in {IERC20-approve}.
567      *
568      * Emits an {Approval} event indicating the updated allowance.
569      *
570      * Requirements:
571      *
572      * - `spender` cannot be the zero address.
573      * - `spender` must have allowance for the caller of at least
574      * `subtractedValue`.
575      */
576     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
577         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
578         return true;
579     }
580 
581     /**
582      * @dev Moves tokens `amount` from `sender` to `recipient`.
583      *
584      * This is internal function is equivalent to {transfer}, and can be used to
585      * e.g. implement automatic token fees, slashing mechanisms, etc.
586      *
587      * Emits a {Transfer} event.
588      *
589      * Requirements:
590      *
591      * - `sender` cannot be the zero address.
592      * - `recipient` cannot be the zero address.
593      * - `sender` must have a balance of at least `amount`.
594      */
595     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
596         require(sender != address(0), "ERC20: transfer from the zero address");
597         require(recipient != address(0), "ERC20: transfer to the zero address");
598 
599         _beforeTokenTransfer(sender, recipient, amount);
600 
601         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
602         _balances[recipient] = _balances[recipient].add(amount);
603         emit Transfer(sender, recipient, amount);
604     }
605 
606     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
607      * the total supply.
608      *
609      * Emits a {Transfer} event with `from` set to the zero address.
610      *
611      * Requirements
612      *
613      * - `to` cannot be the zero address.
614      */
615     function _mint(address account, uint256 amount) internal virtual {
616         require(account != address(0), "ERC20: mint to the zero address");
617 
618         _beforeTokenTransfer(address(0), account, amount);
619 
620         _totalSupply = _totalSupply.add(amount);
621         _balances[account] = _balances[account].add(amount);
622         emit Transfer(address(0), account, amount);
623     }
624 
625     /**
626      * @dev Destroys `amount` tokens from `account`, reducing the
627      * total supply.
628      *
629      * Emits a {Transfer} event with `to` set to the zero address.
630      *
631      * Requirements
632      *
633      * - `account` cannot be the zero address.
634      * - `account` must have at least `amount` tokens.
635      */
636     function _burn(address account, uint256 amount) internal virtual {
637         require(account != address(0), "ERC20: burn from the zero address");
638 
639         _beforeTokenTransfer(account, address(0), amount);
640 
641         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
642         _totalSupply = _totalSupply.sub(amount);
643         emit Transfer(account, address(0), amount);
644     }
645 
646     /**
647      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
648      *
649      * This is internal function is equivalent to `approve`, and can be used to
650      * e.g. set automatic allowances for certain subsystems, etc.
651      *
652      * Emits an {Approval} event.
653      *
654      * Requirements:
655      *
656      * - `owner` cannot be the zero address.
657      * - `spender` cannot be the zero address.
658      */
659     function _approve(address owner, address spender, uint256 amount) internal virtual {
660         require(owner != address(0), "ERC20: approve from the zero address");
661         require(spender != address(0), "ERC20: approve to the zero address");
662 
663         _allowances[owner][spender] = amount;
664         emit Approval(owner, spender, amount);
665     }
666 
667     /**
668      * @dev Sets {decimals} to a value other than the default one of 18.
669      *
670      * WARNING: This function should only be called from the constructor. Most
671      * applications that interact with token contracts will not expect
672      * {decimals} to ever change, and may work incorrectly if it does.
673      */
674     function _setupDecimals(uint8 decimals_) internal {
675         _decimals = decimals_;
676     }
677 
678     /**
679      * @dev Hook that is called before any transfer of tokens. This includes
680      * minting and burning.
681      *
682      * Calling conditions:
683      *
684      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
685      * will be to transferred to `to`.
686      * - when `from` is zero, `amount` tokens will be minted for `to`.
687      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
688      * - `from` and `to` are never both zero.
689      *
690      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
691      */
692     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
693 }
694 
695 contract OctoToken is ERC20 {
696     string constant NAME    = 'Octo.fi';
697     string constant SYMBOL  = 'OCTO';
698     uint8 constant DECIMALS  = 18;
699     uint256 constant TOTAL_SUPPLY = 800_000 * 10**uint256(DECIMALS);
700 
701     constructor() ERC20(NAME, SYMBOL) public {
702         _mint(msg.sender, TOTAL_SUPPLY);
703     }
704 }