1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
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
394 
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
695 /**
696  * @dev Contract module which provides a basic access control mechanism, where
697  * there is an account (an owner) that can be granted exclusive access to
698  * specific functions.
699  *
700  * By default, the owner account will be the one that deploys the contract. This
701  * can later be changed with {transferOwnership}.
702  *
703  * This module is used through inheritance. It will make available the modifier
704  * `onlyOwner`, which can be applied to your functions to restrict their use to
705  * the owner.
706  */
707 contract Ownable is Context {
708     address private _owner;
709 
710     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
711 
712     /**
713      * @dev Initializes the contract setting the deployer as the initial owner.
714      */
715     constructor () internal {
716         address msgSender = _msgSender();
717         _owner = msgSender;
718         emit OwnershipTransferred(address(0), msgSender);
719     }
720 
721     /**
722      * @dev Returns the address of the current owner.
723      */
724     function owner() public view returns (address) {
725         return _owner;
726     }
727 
728     /**
729      * @dev Throws if called by any account other than the owner.
730      */
731     modifier onlyOwner() {
732         require(_owner == _msgSender(), "Ownable: caller is not the owner");
733         _;
734     }
735 
736     /**
737      * @dev Leaves the contract without owner. It will not be possible to call
738      * `onlyOwner` functions anymore. Can only be called by the current owner.
739      *
740      * NOTE: Renouncing ownership will leave the contract without an owner,
741      * thereby removing any functionality that is only available to the owner.
742      */
743     function renounceOwnership() public virtual onlyOwner {
744         emit OwnershipTransferred(_owner, address(0));
745         _owner = address(0);
746     }
747 
748     /**
749      * @dev Transfers ownership of the contract to a new account (`newOwner`).
750      * Can only be called by the current owner.
751      */
752     function transferOwnership(address newOwner) public virtual onlyOwner {
753         require(newOwner != address(0), "Ownable: new owner is the zero address");
754         emit OwnershipTransferred(_owner, newOwner);
755         _owner = newOwner;
756     }
757 }
758 
759 /**
760  * @title SafeERC20
761  * @dev Wrappers around ERC20 operations that throw on failure (when the token
762  * contract returns false). Tokens that return no value (and instead revert or
763  * throw on failure) are also supported, non-reverting calls are assumed to be
764  * successful.
765  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
766  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
767  */
768 library SafeERC20 {
769     using SafeMath for uint256;
770     using Address for address;
771 
772     function safeTransfer(IERC20 token, address to, uint256 value) internal {
773         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
774     }
775 
776     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
777         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
778     }
779 
780     /**
781      * @dev Deprecated. This function has issues similar to the ones found in
782      * {IERC20-approve}, and its usage is discouraged.
783      *
784      * Whenever possible, use {safeIncreaseAllowance} and
785      * {safeDecreaseAllowance} instead.
786      */
787     function safeApprove(IERC20 token, address spender, uint256 value) internal {
788         // safeApprove should only be called when setting an initial allowance,
789         // or when resetting it to zero. To increase and decrease it, use
790         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
791         // solhint-disable-next-line max-line-length
792         require((value == 0) || (token.allowance(address(this), spender) == 0),
793             "SafeERC20: approve from non-zero to non-zero allowance"
794         );
795         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
796     }
797 
798     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
799         uint256 newAllowance = token.allowance(address(this), spender).add(value);
800         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
801     }
802 
803     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
804         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
805         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
806     }
807 
808     /**
809      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
810      * on the return value: the return value is optional (but if data is returned, it must not be false).
811      * @param token The token targeted by the call.
812      * @param data The call data (encoded using abi.encode or one of its variants).
813      */
814     function _callOptionalReturn(IERC20 token, bytes memory data) private {
815         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
816         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
817         // the target address contains contract code and also asserts for success in the low-level call.
818 
819         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
820         if (returndata.length > 0) { // Return data is optional
821             // solhint-disable-next-line max-line-length
822             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
823         }
824     }
825 }
826 
827 /**
828  * @dev Library for managing
829  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
830  * types.
831  *
832  * Sets have the following properties:
833  *
834  * - Elements are added, removed, and checked for existence in constant time
835  * (O(1)).
836  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
837  *
838  * ```
839  * contract Example {
840  *     // Add the library methods
841  *     using EnumerableSet for EnumerableSet.AddressSet;
842  *
843  *     // Declare a set state variable
844  *     EnumerableSet.AddressSet private mySet;
845  * }
846  * ```
847  *
848  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
849  * (`UintSet`) are supported.
850  */
851 library EnumerableSet {
852     // To implement this library for multiple types with as little code
853     // repetition as possible, we write it in terms of a generic Set type with
854     // bytes32 values.
855     // The Set implementation uses private functions, and user-facing
856     // implementations (such as AddressSet) are just wrappers around the
857     // underlying Set.
858     // This means that we can only create new EnumerableSets for types that fit
859     // in bytes32.
860 
861     struct Set {
862         // Storage of set values
863         bytes32[] _values;
864 
865         // Position of the value in the `values` array, plus 1 because index 0
866         // means a value is not in the set.
867         mapping (bytes32 => uint256) _indexes;
868     }
869 
870     /**
871      * @dev Add a value to a set. O(1).
872      *
873      * Returns true if the value was added to the set, that is if it was not
874      * already present.
875      */
876     function _add(Set storage set, bytes32 value) private returns (bool) {
877         if (!_contains(set, value)) {
878             set._values.push(value);
879             // The value is stored at length-1, but we add 1 to all indexes
880             // and use 0 as a sentinel value
881             set._indexes[value] = set._values.length;
882             return true;
883         } else {
884             return false;
885         }
886     }
887 
888     /**
889      * @dev Removes a value from a set. O(1).
890      *
891      * Returns true if the value was removed from the set, that is if it was
892      * present.
893      */
894     function _remove(Set storage set, bytes32 value) private returns (bool) {
895         // We read and store the value's index to prevent multiple reads from the same storage slot
896         uint256 valueIndex = set._indexes[value];
897 
898         if (valueIndex != 0) { // Equivalent to contains(set, value)
899             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
900             // the array, and then remove the last element (sometimes called as 'swap and pop').
901             // This modifies the order of the array, as noted in {at}.
902 
903             uint256 toDeleteIndex = valueIndex - 1;
904             uint256 lastIndex = set._values.length - 1;
905 
906             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
907             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
908 
909             bytes32 lastvalue = set._values[lastIndex];
910 
911             // Move the last value to the index where the value to delete is
912             set._values[toDeleteIndex] = lastvalue;
913             // Update the index for the moved value
914             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
915 
916             // Delete the slot where the moved value was stored
917             set._values.pop();
918 
919             // Delete the index for the deleted slot
920             delete set._indexes[value];
921 
922             return true;
923         } else {
924             return false;
925         }
926     }
927 
928     /**
929      * @dev Returns true if the value is in the set. O(1).
930      */
931     function _contains(Set storage set, bytes32 value) private view returns (bool) {
932         return set._indexes[value] != 0;
933     }
934 
935     /**
936      * @dev Returns the number of values on the set. O(1).
937      */
938     function _length(Set storage set) private view returns (uint256) {
939         return set._values.length;
940     }
941 
942    /**
943     * @dev Returns the value stored at position `index` in the set. O(1).
944     *
945     * Note that there are no guarantees on the ordering of values inside the
946     * array, and it may change when more values are added or removed.
947     *
948     * Requirements:
949     *
950     * - `index` must be strictly less than {length}.
951     */
952     function _at(Set storage set, uint256 index) private view returns (bytes32) {
953         require(set._values.length > index, "EnumerableSet: index out of bounds");
954         return set._values[index];
955     }
956 
957     // AddressSet
958 
959     struct AddressSet {
960         Set _inner;
961     }
962 
963     /**
964      * @dev Add a value to a set. O(1).
965      *
966      * Returns true if the value was added to the set, that is if it was not
967      * already present.
968      */
969     function add(AddressSet storage set, address value) internal returns (bool) {
970         return _add(set._inner, bytes32(uint256(value)));
971     }
972 
973     /**
974      * @dev Removes a value from a set. O(1).
975      *
976      * Returns true if the value was removed from the set, that is if it was
977      * present.
978      */
979     function remove(AddressSet storage set, address value) internal returns (bool) {
980         return _remove(set._inner, bytes32(uint256(value)));
981     }
982 
983     /**
984      * @dev Returns true if the value is in the set. O(1).
985      */
986     function contains(AddressSet storage set, address value) internal view returns (bool) {
987         return _contains(set._inner, bytes32(uint256(value)));
988     }
989 
990     /**
991      * @dev Returns the number of values in the set. O(1).
992      */
993     function length(AddressSet storage set) internal view returns (uint256) {
994         return _length(set._inner);
995     }
996 
997    /**
998     * @dev Returns the value stored at position `index` in the set. O(1).
999     *
1000     * Note that there are no guarantees on the ordering of values inside the
1001     * array, and it may change when more values are added or removed.
1002     *
1003     * Requirements:
1004     *
1005     * - `index` must be strictly less than {length}.
1006     */
1007     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1008         return address(uint256(_at(set._inner, index)));
1009     }
1010 
1011 
1012     // UintSet
1013 
1014     struct UintSet {
1015         Set _inner;
1016     }
1017 
1018     /**
1019      * @dev Add a value to a set. O(1).
1020      *
1021      * Returns true if the value was added to the set, that is if it was not
1022      * already present.
1023      */
1024     function add(UintSet storage set, uint256 value) internal returns (bool) {
1025         return _add(set._inner, bytes32(value));
1026     }
1027 
1028     /**
1029      * @dev Removes a value from a set. O(1).
1030      *
1031      * Returns true if the value was removed from the set, that is if it was
1032      * present.
1033      */
1034     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1035         return _remove(set._inner, bytes32(value));
1036     }
1037 
1038     /**
1039      * @dev Returns true if the value is in the set. O(1).
1040      */
1041     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1042         return _contains(set._inner, bytes32(value));
1043     }
1044 
1045     /**
1046      * @dev Returns the number of values on the set. O(1).
1047      */
1048     function length(UintSet storage set) internal view returns (uint256) {
1049         return _length(set._inner);
1050     }
1051 
1052    /**
1053     * @dev Returns the value stored at position `index` in the set. O(1).
1054     *
1055     * Note that there are no guarantees on the ordering of values inside the
1056     * array, and it may change when more values are added or removed.
1057     *
1058     * Requirements:
1059     *
1060     * - `index` must be strictly less than {length}.
1061     */
1062     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1063         return uint256(_at(set._inner, index));
1064     }
1065 }
1066 
1067 contract CEFIStaker is Ownable {
1068     using SafeMath for uint256;
1069     using SafeERC20 for IERC20;
1070 
1071     // Info of each user.
1072     struct UserInfo {
1073         uint256 amount;     // How many LP tokens the user has provided.
1074         uint256 rewardDebt; // Reward debt. See explanation below.
1075         //
1076         // We do some fancy math here. Basically, any point in time, the amount of CEFIs
1077         // entitled to a user but is pending to be distributed is:
1078         //
1079         //   pending reward = (user.amount * pool.accCefiPerShare) - user.rewardDebt
1080         //
1081         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1082         //   1. The pool's `accCefiPerShare` (and `lastRewardBlock`) gets updated.
1083         //   2. User receives the pending reward sent to his/her address.
1084         //   3. User's `amount` gets updated.
1085         //   4. User's `rewardDebt` gets updated.
1086     }
1087 
1088     // Info of each pool.
1089     struct PoolInfo {
1090         IERC20 lpToken;           // Address of LP token contract.
1091         uint256 allocPoint;       // How many allocation points assigned to this pool. CEFIs to distribute per block.
1092         uint256 lastRewardBlock;  // Last block number that CEFIs distribution occurs.
1093         uint256 accCefiPerShare; // Accumulated CEFI's per share, times 1e12. See below.
1094     }
1095 
1096     // The CEFI TOKEN
1097     CEFIToken public cefi;
1098     // Dev address.
1099     address public devaddr;
1100     // CEFI tokens created per block.
1101     uint256 public cefiPerBlock;
1102 
1103     // Info of each pool.
1104     PoolInfo[] public poolInfo;
1105     // Info of each user that stakes LP tokens.
1106     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1107     // Total allocation points. Must be the sum of all allocation points in all pools.
1108     uint256 public totalAllocPoint = 0;
1109     // The block number when CEFI mining starts.
1110     uint256 public startBlock;
1111     // Block number when CEFI mining ends.
1112     uint256 public targetEndBlock;
1113 
1114     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1115     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1116     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1117 
1118 
1119 
1120     constructor(
1121         CEFIToken _cefi,
1122         address _devaddr,
1123         uint256 _startBlock,
1124         uint256 _targetEndBlock,
1125         uint256 _lp_program,
1126         uint256 _lp_program_extra
1127     ) public {
1128         cefi = _cefi;
1129         devaddr = _devaddr;
1130         targetEndBlock = _targetEndBlock;
1131         startBlock = _startBlock;
1132 
1133         cefiPerBlock = _lp_program.add(_lp_program_extra).div(targetEndBlock.sub(startBlock));
1134     }
1135 
1136     function poolLength() external view returns (uint256) {
1137         return poolInfo.length;
1138     }
1139 
1140     // Add a new lp to the pool. Can only be called by the owner.
1141     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1142     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1143         if (_withUpdate) {
1144             massUpdatePools();
1145         }
1146         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1147         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1148         poolInfo.push(PoolInfo({
1149             lpToken: _lpToken,
1150             allocPoint: _allocPoint,
1151             lastRewardBlock: lastRewardBlock,
1152             accCefiPerShare: 0
1153         }));
1154     }
1155 
1156     // Update the given pool's CEFI allocation point. Can only be called by the owner.
1157     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1158         if (_withUpdate) {
1159             massUpdatePools();
1160         }
1161         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1162         poolInfo[_pid].allocPoint = _allocPoint;
1163     }
1164 
1165     // Return the number of active blocks over the given _from to _to block.
1166     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1167         if (_from >= targetEndBlock) {
1168             return 0;
1169         } else if (_from >= startBlock && _to >= targetEndBlock) {
1170             return targetEndBlock.sub(_from);
1171         } else if (_to >= targetEndBlock) {
1172             return targetEndBlock.sub(startBlock);
1173         } else if (_from >= startBlock && _to < targetEndBlock) {
1174             return _to.sub(_from);
1175         } else if (_to >= startBlock) {
1176             return _to.sub(startBlock.sub(1));
1177         } else {
1178             return 0;
1179         }
1180     }
1181 
1182     // View function to see pending CEFI on frontend.
1183     function pendingCEFI(uint256 _pid, address _user) external view returns (uint256) {
1184         PoolInfo storage pool = poolInfo[_pid];
1185         UserInfo storage user = userInfo[_pid][_user];
1186         uint256 accCefiPerShare = pool.accCefiPerShare;
1187         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1188         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1189             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1190             uint256 cefiReward = multiplier.mul(cefiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1191             accCefiPerShare = accCefiPerShare.add(cefiReward.mul(1e12).div(lpSupply));
1192         }
1193         return user.amount.mul(accCefiPerShare).div(1e12).sub(user.rewardDebt);
1194     }
1195 
1196     // Update reward variables for all pools. Be careful of gas spending!
1197     function massUpdatePools() public {
1198         uint256 length = poolInfo.length;
1199         for (uint256 pid = 0; pid < length; ++pid) {
1200             updatePool(pid);
1201         }
1202     }
1203 
1204     // Update reward variables of the given pool to be up-to-date.
1205     function updatePool(uint256 _pid) public {
1206         PoolInfo storage pool = poolInfo[_pid];
1207         if (block.number <= pool.lastRewardBlock) {
1208             return;
1209         }
1210         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1211         if (lpSupply == 0) {
1212             pool.lastRewardBlock = block.number;
1213             return;
1214         }
1215         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1216         uint256 cefiReward = multiplier.mul(cefiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1217         cefi.stakerMint(devaddr, cefiReward.mul(3).div(100));
1218         cefi.stakerMint(address(this), cefiReward);
1219         pool.accCefiPerShare = pool.accCefiPerShare.add(cefiReward.mul(1e12).div(lpSupply));
1220         pool.lastRewardBlock = block.number;
1221     }
1222 
1223     // Deposit LP tokens to CEFIStaker for CEFI allocation.
1224     function deposit(uint256 _pid, uint256 _amount) public {
1225         PoolInfo storage pool = poolInfo[_pid];
1226         UserInfo storage user = userInfo[_pid][msg.sender];
1227         updatePool(_pid);
1228         if (user.amount > 0) {
1229             uint256 pending = user.amount.mul(pool.accCefiPerShare).div(1e12).sub(user.rewardDebt);
1230             if(pending > 0) {
1231                 safeCefiTransfer(msg.sender, pending);
1232             }
1233         }
1234         if(_amount > 0) {
1235             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1236             user.amount = user.amount.add(_amount);
1237         }
1238         user.rewardDebt = user.amount.mul(pool.accCefiPerShare).div(1e12);
1239         emit Deposit(msg.sender, _pid, _amount);
1240     }
1241 
1242     // Withdraw LP tokens from CEFIStaker.
1243     function withdraw(uint256 _pid, uint256 _amount) public {
1244         PoolInfo storage pool = poolInfo[_pid];
1245         UserInfo storage user = userInfo[_pid][msg.sender];
1246         require(user.amount >= _amount, "withdraw: not good");
1247         updatePool(_pid);
1248         uint256 pending = user.amount.mul(pool.accCefiPerShare).div(1e12).sub(user.rewardDebt);
1249         if(pending > 0) {
1250             safeCefiTransfer(msg.sender, pending);
1251         }
1252         if(_amount > 0) {
1253             user.amount = user.amount.sub(_amount);
1254             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1255         }
1256         user.rewardDebt = user.amount.mul(pool.accCefiPerShare).div(1e12);
1257         emit Withdraw(msg.sender, _pid, _amount);
1258     }
1259 
1260     // Withdraw without caring about rewards. EMERGENCY ONLY.
1261     function emergencyWithdraw(uint256 _pid) public {
1262         PoolInfo storage pool = poolInfo[_pid];
1263         UserInfo storage user = userInfo[_pid][msg.sender];
1264         uint256 amount = user.amount;
1265         user.amount = 0;
1266         user.rewardDebt = 0;
1267         pool.lpToken.safeTransfer(address(msg.sender), amount);
1268         emit EmergencyWithdraw(msg.sender, _pid, amount);
1269     }
1270 
1271     // Safe CEFI transfer function, just in case if rounding error causes pool to not have enough CEFIs.
1272     function safeCefiTransfer(address _to, uint256 _amount) internal {
1273         uint256 cefiBal = cefi.balanceOf(address(this));
1274         if (_amount > cefiBal) {
1275             cefi.transfer(_to, cefiBal);
1276         } else {
1277             cefi.transfer(_to, _amount);
1278         }
1279     }
1280 
1281     // Update dev address by the previous dev.
1282     function dev(address _devaddr) public {
1283         require(msg.sender == devaddr, "dev: wut?");
1284         devaddr = _devaddr;
1285     }
1286 }
1287 
1288 
1289 // CEFIToken
1290 contract CEFIToken is ERC20("Emporium.Finance", "CEFI"), Ownable {
1291 
1292     uint256 public constant MINT_LIMIT =  888000 * 1e18;
1293     // CEFI tokens for bounty program
1294     uint256 public constant BOUNTY_PROGRAM  =  17760 * 1e18;
1295     // CEFI tokens for cashback 
1296     uint256 public constant CASHBACK_PROGRAM  =  17760 * 1e18;
1297 
1298     // Staker (ruled by CEFIStaker contract)
1299     address public staker;
1300 
1301     /**
1302      * @dev Throws if called by any account other than the staker.
1303      */
1304     modifier onlyStaker() {
1305         require(staker == _msgSender(), "CEFI: caller is not the staker");
1306         _;
1307     }
1308 
1309     // Constructor code is only run when the contract
1310     // is created
1311     constructor(
1312       address _stakerOwner, 
1313       address _devaddr, 
1314       address _bountyaddr, 
1315       address _cashbackaddr,
1316       uint256 _lpProgram,
1317       uint256 _lpProgramExtra,
1318       uint _startLPBlock,
1319       uint _endLPBlock
1320       ) public {
1321 	      staker = address(new CEFIStaker(this, _devaddr, _startLPBlock, _endLPBlock, _lpProgram, _lpProgramExtra));
1322         CEFIStaker(staker).transferOwnership(_stakerOwner);
1323 
1324         _mint(_bountyaddr, BOUNTY_PROGRAM);
1325         _mint(_cashbackaddr, CASHBACK_PROGRAM);
1326     }
1327 
1328     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner.
1329     function mint(address _to, uint256 _amount) public onlyOwner {
1330         require(totalSupply() + _amount < MINT_LIMIT, 'Mint amount exceeds max supply');
1331         _mint(_to, _amount);
1332     }
1333 
1334     /// @notice Creates `_amount` token to `_to`. Must only be called by the staker.
1335     function stakerMint(address _to, uint256 _amount) public onlyStaker {
1336         require(totalSupply() + _amount < MINT_LIMIT, 'Mint amount exceeds max supply');
1337         _mint(_to, _amount);
1338     }
1339 
1340 }