1 pragma solidity ^0.6.6;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         return sub(a, b, "SafeMath: subtraction overflow");
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b <= a, errorMessage);
158         uint256 c = a - b;
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the multiplication of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `*` operator.
168      *
169      * Requirements:
170      *
171      * - Multiplication cannot overflow.
172      */
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
175         // benefit is lost if 'b' is also tested.
176         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
177         if (a == 0) {
178             return 0;
179         }
180 
181         uint256 c = a * b;
182         require(c / a == b, "SafeMath: multiplication overflow");
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         return mod(a, b, "SafeMath: modulo by zero");
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts with custom message when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
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
695 
696 contract ERA is ERC20 {
697     constructor ()
698         ERC20('ERA Finance', 'ERA')
699         public
700     {
701         _mint(0x5a77bD42971B3399d5f2eaE6505bb36EA6a359F3, 12000 * 10 ** uint(decimals()));
702     }
703 }