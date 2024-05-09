1 pragma solidity 0.6.12;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
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
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113 library SafeMath {
114     /**
115      * @dev Returns the addition of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `+` operator.
119      *
120      * Requirements:
121      *
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return sub(a, b, "SafeMath: subtraction overflow");
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b <= a, errorMessage);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the multiplication of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `*` operator.
167      *
168      * Requirements:
169      *
170      * - Multiplication cannot overflow.
171      */
172     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b) internal pure returns (uint256) {
199         return div(a, b, "SafeMath: division by zero");
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         uint256 c = a / b;
217         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b != 0, errorMessage);
252         return a % b;
253     }
254 }
255 
256 /**
257  * @dev Collection of functions related to the address type
258  */
259 library Address {
260     /**
261      * @dev Returns true if `account` is a contract.
262      *
263      * [IMPORTANT]
264      * ====
265      * It is unsafe to assume that an address for which this function returns
266      * false is an externally-owned account (EOA) and not a contract.
267      *
268      * Among others, `isContract` will return false for the following
269      * types of addresses:
270      *
271      *  - an externally-owned account
272      *  - a contract in construction
273      *  - an address where a contract will be created
274      *  - an address where a contract lived, but was destroyed
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
279         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
280         // for accounts without code, i.e. `keccak256('')`
281         bytes32 codehash;
282         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
283         // solhint-disable-next-line no-inline-assembly
284         assembly { codehash := extcodehash(account) }
285         return (codehash != accountHash && codehash != 0x0);
286     }
287 
288     /**
289      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
290      * `recipient`, forwarding all available gas and reverting on errors.
291      *
292      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293      * of certain opcodes, possibly making contracts go over the 2300 gas limit
294      * imposed by `transfer`, making them unable to receive funds via
295      * `transfer`. {sendValue} removes this limitation.
296      *
297      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298      *
299      * IMPORTANT: because control is transferred to `recipient`, care must be
300      * taken to not create reentrancy vulnerabilities. Consider using
301      * {ReentrancyGuard} or the
302      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303      */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
308         (bool success, ) = recipient.call{ value: amount }("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 
312     /**
313      * @dev Performs a Solidity function call using a low level `call`. A
314      * plain`call` is an unsafe replacement for a function call: use this
315      * function instead.
316      *
317      * If `target` reverts with a revert reason, it is bubbled up by this
318      * function (like regular Solidity function calls).
319      *
320      * Returns the raw returned data. To convert to the expected return value,
321      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322      *
323      * Requirements:
324      *
325      * - `target` must be a contract.
326      * - calling `target` with `data` must not revert.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
331       return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
336      * `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
341         return _functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361      * with `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         return _functionCallWithValue(target, data, value, errorMessage);
368     }
369 
370     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
371         require(isContract(target), "Address: call to non-contract");
372 
373         // solhint-disable-next-line avoid-low-level-calls
374         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 // solhint-disable-next-line no-inline-assembly
383                 assembly {
384                     let returndata_size := mload(returndata)
385                     revert(add(32, returndata), returndata_size)
386                 }
387             } else {
388                 revert(errorMessage);
389             }
390         }
391     }
392 }
393 
394 /**
395  * @dev Implementation of the {IERC20} interface.
396  *
397  * This implementation is agnostic to the way tokens are created. This means
398  * that a supply mechanism has to be added in a derived contract using {_mint}.
399  * For a generic mechanism see {ERC20PresetMinterPauser}.
400  *
401  * TIP: For a detailed writeup see our guide
402  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
403  * to implement supply mechanisms].
404  *
405  * We have followed general OpenZeppelin guidelines: functions revert instead
406  * of returning `false` on failure. This behavior is nonetheless conventional
407  * and does not conflict with the expectations of ERC20 applications.
408  *
409  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
410  * This allows applications to reconstruct the allowance for all accounts just
411  * by listening to said events. Other implementations of the EIP may not emit
412  * these events, as it isn't required by the specification.
413  *
414  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
415  * functions have been added to mitigate the well-known issues around setting
416  * allowances. See {IERC20-approve}.
417  */
418 contract ERC20 is Context, IERC20 {
419     using SafeMath for uint256;
420     using Address for address;
421 
422     mapping (address => uint256) private _balances;
423 
424     mapping (address => mapping (address => uint256)) private _allowances;
425 
426     uint256 private _totalSupply;
427 
428     string private _name;
429     string private _symbol;
430     uint8 private _decimals;
431 
432     /**
433      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
434      * a default value of 18.
435      *
436      * To select a different value for {decimals}, use {_setupDecimals}.
437      *
438      * All three of these values are immutable: they can only be set once during
439      * construction.
440      */
441     constructor (string memory name, string memory symbol) public {
442         _name = name;
443         _symbol = symbol;
444         _decimals = 18;
445     }
446 
447     /**
448      * @dev Returns the name of the token.
449      */
450     function name() public view returns (string memory) {
451         return _name;
452     }
453 
454     /**
455      * @dev Returns the symbol of the token, usually a shorter version of the
456      * name.
457      */
458     function symbol() public view returns (string memory) {
459         return _symbol;
460     }
461 
462     /**
463      * @dev Returns the number of decimals used to get its user representation.
464      * For example, if `decimals` equals `2`, a balance of `505` tokens should
465      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
466      *
467      * Tokens usually opt for a value of 18, imitating the relationship between
468      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
469      * called.
470      *
471      * NOTE: This information is only used for _display_ purposes: it in
472      * no way affects any of the arithmetic of the contract, including
473      * {IERC20-balanceOf} and {IERC20-transfer}.
474      */
475     function decimals() public view returns (uint8) {
476         return _decimals;
477     }
478 
479     /**
480      * @dev See {IERC20-totalSupply}.
481      */
482     function totalSupply() public view override returns (uint256) {
483         return _totalSupply;
484     }
485 
486     /**
487      * @dev See {IERC20-balanceOf}.
488      */
489     function balanceOf(address account) public view override returns (uint256) {
490         return _balances[account];
491     }
492 
493     /**
494      * @dev See {IERC20-transfer}.
495      *
496      * Requirements:
497      *
498      * - `recipient` cannot be the zero address.
499      * - the caller must have a balance of at least `amount`.
500      */
501     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
502         _transfer(_msgSender(), recipient, amount);
503         return true;
504     }
505 
506     /**
507      * @dev See {IERC20-allowance}.
508      */
509     function allowance(address owner, address spender) public view virtual override returns (uint256) {
510         return _allowances[owner][spender];
511     }
512 
513     /**
514      * @dev See {IERC20-approve}.
515      *
516      * Requirements:
517      *
518      * - `spender` cannot be the zero address.
519      */
520     function approve(address spender, uint256 amount) public virtual override returns (bool) {
521         _approve(_msgSender(), spender, amount);
522         return true;
523     }
524 
525     /**
526      * @dev See {IERC20-transferFrom}.
527      *
528      * Emits an {Approval} event indicating the updated allowance. This is not
529      * required by the EIP. See the note at the beginning of {ERC20};
530      *
531      * Requirements:
532      * - `sender` and `recipient` cannot be the zero address.
533      * - `sender` must have a balance of at least `amount`.
534      * - the caller must have allowance for ``sender``'s tokens of at least
535      * `amount`.
536      */
537     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
538         _transfer(sender, recipient, amount);
539         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
540         return true;
541     }
542 
543     /**
544      * @dev Atomically increases the allowance granted to `spender` by the caller.
545      *
546      * This is an alternative to {approve} that can be used as a mitigation for
547      * problems described in {IERC20-approve}.
548      *
549      * Emits an {Approval} event indicating the updated allowance.
550      *
551      * Requirements:
552      *
553      * - `spender` cannot be the zero address.
554      */
555     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
556         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
557         return true;
558     }
559 
560     /**
561      * @dev Atomically decreases the allowance granted to `spender` by the caller.
562      *
563      * This is an alternative to {approve} that can be used as a mitigation for
564      * problems described in {IERC20-approve}.
565      *
566      * Emits an {Approval} event indicating the updated allowance.
567      *
568      * Requirements:
569      *
570      * - `spender` cannot be the zero address.
571      * - `spender` must have allowance for the caller of at least
572      * `subtractedValue`.
573      */
574     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
575         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
576         return true;
577     }
578 
579     /**
580      * @dev Moves tokens `amount` from `sender` to `recipient`.
581      *
582      * This is internal function is equivalent to {transfer}, and can be used to
583      * e.g. implement automatic token fees, slashing mechanisms, etc.
584      *
585      * Emits a {Transfer} event.
586      *
587      * Requirements:
588      *
589      * - `sender` cannot be the zero address.
590      * - `recipient` cannot be the zero address.
591      * - `sender` must have a balance of at least `amount`.
592      */
593     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
594         require(sender != address(0), "ERC20: transfer from the zero address");
595         require(recipient != address(0), "ERC20: transfer to the zero address");
596 
597         _beforeTokenTransfer(sender, recipient, amount);
598 
599         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
600         _balances[recipient] = _balances[recipient].add(amount);
601         emit Transfer(sender, recipient, amount);
602     }
603 
604     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
605      * the total supply.
606      *
607      * Emits a {Transfer} event with `from` set to the zero address.
608      *
609      * Requirements
610      *
611      * - `to` cannot be the zero address.
612      */
613     function _mint(address account, uint256 amount) internal virtual {
614         require(account != address(0), "ERC20: mint to the zero address");
615 
616         _beforeTokenTransfer(address(0), account, amount);
617 
618         _totalSupply = _totalSupply.add(amount);
619         _balances[account] = _balances[account].add(amount);
620         emit Transfer(address(0), account, amount);
621     }
622 
623     /**
624      * @dev Destroys `amount` tokens from `account`, reducing the
625      * total supply.
626      *
627      * Emits a {Transfer} event with `to` set to the zero address.
628      *
629      * Requirements
630      *
631      * - `account` cannot be the zero address.
632      * - `account` must have at least `amount` tokens.
633      */
634     function _burn(address account, uint256 amount) internal virtual {
635         require(account != address(0), "ERC20: burn from the zero address");
636 
637         _beforeTokenTransfer(account, address(0), amount);
638 
639         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
640         _totalSupply = _totalSupply.sub(amount);
641         emit Transfer(account, address(0), amount);
642     }
643 
644     /**
645      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
646      *
647      * This is internal function is equivalent to `approve`, and can be used to
648      * e.g. set automatic allowances for certain subsystems, etc.
649      *
650      * Emits an {Approval} event.
651      *
652      * Requirements:
653      *
654      * - `owner` cannot be the zero address.
655      * - `spender` cannot be the zero address.
656      */
657     function _approve(address owner, address spender, uint256 amount) internal virtual {
658         require(owner != address(0), "ERC20: approve from the zero address");
659         require(spender != address(0), "ERC20: approve to the zero address");
660 
661         _allowances[owner][spender] = amount;
662         emit Approval(owner, spender, amount);
663     }
664 
665     /**
666      * @dev Sets {decimals} to a value other than the default one of 18.
667      *
668      * WARNING: This function should only be called from the constructor. Most
669      * applications that interact with token contracts will not expect
670      * {decimals} to ever change, and may work incorrectly if it does.
671      */
672     function _setupDecimals(uint8 decimals_) internal {
673         _decimals = decimals_;
674     }
675 
676     /**
677      * @dev Hook that is called before any transfer of tokens. This includes
678      * minting and burning.
679      *
680      * Calling conditions:
681      *
682      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
683      * will be to transferred to `to`.
684      * - when `from` is zero, `amount` tokens will be minted for `to`.
685      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
686      * - `from` and `to` are never both zero.
687      *
688      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
689      */
690     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
691 }
692 
693 /**
694  * @dev Contract module which provides a basic access control mechanism, where
695  * there is an account (an owner) that can be granted exclusive access to
696  * specific functions.
697  *
698  * By default, the owner account will be the one that deploys the contract. This
699  * can later be changed with {transferOwnership}.
700  *
701  * This module is used through inheritance. It will make available the modifier
702  * `onlyOwner`, which can be applied to your functions to restrict their use to
703  * the owner.
704  */
705 contract Ownable is Context {
706     address private _owner;
707 
708     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
709 
710     /**
711      * @dev Initializes the contract setting the deployer as the initial owner.
712      */
713     constructor () internal {
714         address msgSender = _msgSender();
715         _owner = msgSender;
716         emit OwnershipTransferred(address(0), msgSender);
717     }
718 
719     /**
720      * @dev Returns the address of the current owner.
721      */
722     function owner() public view returns (address) {
723         return _owner;
724     }
725 
726     /**
727      * @dev Throws if called by any account other than the owner.
728      */
729     modifier onlyOwner() {
730         require(_owner == _msgSender(), "Ownable: caller is not the owner");
731         _;
732     }
733 
734     /**
735      * @dev Leaves the contract without owner. It will not be possible to call
736      * `onlyOwner` functions anymore. Can only be called by the current owner.
737      *
738      * NOTE: Renouncing ownership will leave the contract without an owner,
739      * thereby removing any functionality that is only available to the owner.
740      */
741     function renounceOwnership() public virtual onlyOwner {
742         emit OwnershipTransferred(_owner, address(0));
743         _owner = address(0);
744     }
745 
746     /**
747      * @dev Transfers ownership of the contract to a new account (`newOwner`).
748      * Can only be called by the current owner.
749      */
750     function transferOwnership(address newOwner) public virtual onlyOwner {
751         require(newOwner != address(0), "Ownable: new owner is the zero address");
752         emit OwnershipTransferred(_owner, newOwner);
753         _owner = newOwner;
754     }
755 }
756 
757 // TrumpToken with Governance.
758 contract TrumpToken is ERC20("trumpswap.finance", "TRUMP"), Ownable {
759     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
760     function mint(address _to, uint256 _amount) public onlyOwner {
761         _mint(_to, _amount);
762         _moveDelegates(address(0), _delegates[_to], _amount);
763     }
764 
765     //  transfers delegate authority when sending a token.
766     // https://medium.com/bulldax-finance/sushiswap-delegation-double-spending-bug-5adcc7b3830f
767     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
768       super._transfer(sender, recipient, amount);
769       _moveDelegates(_delegates[sender], _delegates[recipient], amount);
770     }
771 
772     // Copied and modified from YAM code:
773     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
774     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
775     // Which is copied and modified from COMPOUND:
776     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
777 
778     /// @notice A record of each accounts delegate
779     mapping (address => address) internal _delegates;
780 
781     /// @notice A checkpoint for marking number of votes from a given block
782     struct Checkpoint {
783         uint32 fromBlock;
784         uint256 votes;
785     }
786 
787     /// @notice A record of votes checkpoints for each account, by index
788     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
789 
790     /// @notice The number of checkpoints for each account
791     mapping (address => uint32) public numCheckpoints;
792 
793     /// @notice The EIP-712 typehash for the contract's domain
794     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
795 
796     /// @notice The EIP-712 typehash for the delegation struct used by the contract
797     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
798 
799     /// @notice A record of states for signing / validating signatures
800     mapping (address => uint) public nonces;
801 
802       /// @notice An event thats emitted when an account changes its delegate
803     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
804 
805     /// @notice An event thats emitted when a delegate account's vote balance changes
806     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
807 
808     /**
809      * @notice Delegate votes from `msg.sender` to `delegatee`
810      * @param delegator The address to get delegatee for
811      */
812     function delegates(address delegator)
813         external
814         view
815         returns (address)
816     {
817         return _delegates[delegator];
818     }
819 
820    /**
821     * @notice Delegate votes from `msg.sender` to `delegatee`
822     * @param delegatee The address to delegate votes to
823     */
824     function delegate(address delegatee) external {
825         return _delegate(msg.sender, delegatee);
826     }
827 
828     /**
829      * @notice Delegates votes from signatory to `delegatee`
830      * @param delegatee The address to delegate votes to
831      * @param nonce The contract state required to match the signature
832      * @param expiry The time at which to expire the signature
833      * @param v The recovery byte of the signature
834      * @param r Half of the ECDSA signature pair
835      * @param s Half of the ECDSA signature pair
836      */
837     function delegateBySig(
838         address delegatee,
839         uint nonce,
840         uint expiry,
841         uint8 v,
842         bytes32 r,
843         bytes32 s
844     )
845         external
846     {
847         bytes32 domainSeparator = keccak256(
848             abi.encode(
849                 DOMAIN_TYPEHASH,
850                 keccak256(bytes(name())),
851                 getChainId(),
852                 address(this)
853             )
854         );
855 
856         bytes32 structHash = keccak256(
857             abi.encode(
858                 DELEGATION_TYPEHASH,
859                 delegatee,
860                 nonce,
861                 expiry
862             )
863         );
864 
865         bytes32 digest = keccak256(
866             abi.encodePacked(
867                 "\x19\x01",
868                 domainSeparator,
869                 structHash
870             )
871         );
872 
873         address signatory = ecrecover(digest, v, r, s);
874         require(signatory != address(0), "TRUMP::delegateBySig: invalid signature");
875         require(nonce == nonces[signatory]++, "TRUMP::delegateBySig: invalid nonce");
876         require(now <= expiry, "TRUMP::delegateBySig: signature expired");
877         return _delegate(signatory, delegatee);
878     }
879 
880     /**
881      * @notice Gets the current votes balance for `account`
882      * @param account The address to get votes balance
883      * @return The number of current votes for `account`
884      */
885     function getCurrentVotes(address account)
886         external
887         view
888         returns (uint256)
889     {
890         uint32 nCheckpoints = numCheckpoints[account];
891         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
892     }
893 
894     /**
895      * @notice Determine the prior number of votes for an account as of a block number
896      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
897      * @param account The address of the account to check
898      * @param blockNumber The block number to get the vote balance at
899      * @return The number of votes the account had as of the given block
900      */
901     function getPriorVotes(address account, uint blockNumber)
902         external
903         view
904         returns (uint256)
905     {
906         require(blockNumber < block.number, "TRUMP::getPriorVotes: not yet determined");
907 
908         uint32 nCheckpoints = numCheckpoints[account];
909         if (nCheckpoints == 0) {
910             return 0;
911         }
912 
913         // First check most recent balance
914         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
915             return checkpoints[account][nCheckpoints - 1].votes;
916         }
917 
918         // Next check implicit zero balance
919         if (checkpoints[account][0].fromBlock > blockNumber) {
920             return 0;
921         }
922 
923         uint32 lower = 0;
924         uint32 upper = nCheckpoints - 1;
925         while (upper > lower) {
926             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
927             Checkpoint memory cp = checkpoints[account][center];
928             if (cp.fromBlock == blockNumber) {
929                 return cp.votes;
930             } else if (cp.fromBlock < blockNumber) {
931                 lower = center;
932             } else {
933                 upper = center - 1;
934             }
935         }
936         return checkpoints[account][lower].votes;
937     }
938 
939     function _delegate(address delegator, address delegatee)
940         internal
941     {
942         address currentDelegate = _delegates[delegator];
943         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying TRUMPs (not scaled);
944         _delegates[delegator] = delegatee;
945 
946         emit DelegateChanged(delegator, currentDelegate, delegatee);
947 
948         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
949     }
950 
951     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
952         if (srcRep != dstRep && amount > 0) {
953             if (srcRep != address(0)) {
954                 // decrease old representative
955                 uint32 srcRepNum = numCheckpoints[srcRep];
956                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
957                 uint256 srcRepNew = srcRepOld.sub(amount);
958                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
959             }
960 
961             if (dstRep != address(0)) {
962                 // increase new representative
963                 uint32 dstRepNum = numCheckpoints[dstRep];
964                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
965                 uint256 dstRepNew = dstRepOld.add(amount);
966                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
967             }
968         }
969     }
970 
971     function _writeCheckpoint(
972         address delegatee,
973         uint32 nCheckpoints,
974         uint256 oldVotes,
975         uint256 newVotes
976     )
977         internal
978     {
979         uint32 blockNumber = safe32(block.number, "TRUMP::_writeCheckpoint: block number exceeds 32 bits");
980 
981         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
982             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
983         } else {
984             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
985             numCheckpoints[delegatee] = nCheckpoints + 1;
986         }
987 
988         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
989     }
990 
991     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
992         require(n < 2**32, errorMessage);
993         return uint32(n);
994     }
995 
996     function getChainId() internal pure returns (uint) {
997         uint256 chainId;
998         assembly { chainId := chainid() }
999         return chainId;
1000     }
1001 }