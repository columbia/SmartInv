1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-23
3 */
4 
5 pragma solidity 0.6.12;
6 
7 
8 interface IController {
9     function vaults(address) external view returns (address);
10 
11     function rewards() external view returns (address);
12 
13     function devfund() external view returns (address);
14 
15     function treasury() external view returns (address);
16 
17     function balanceOf(address) external view returns (uint256);
18 
19     function withdraw(address, uint256) external;
20 
21     function earn(address, uint256) external;
22 }
23 
24 /**
25  * @dev Wrappers over Solidity's arithmetic operations with added overflow
26  * checks.
27  *
28  * Arithmetic operations in Solidity wrap on overflow. This can easily result
29  * in bugs, because programmers usually assume that an overflow raises an
30  * error, which is the standard behavior in high level programming languages.
31  * `SafeMath` restores this intuition by reverting the transaction when an
32  * operation overflows.
33  *
34  * Using this library instead of the unchecked operations eliminates an entire
35  * class of bugs, so it's recommended to use it always.
36  */
37 library SafeMath {
38     /**
39      * @dev Returns the addition of two unsigned integers, reverting on
40      * overflow.
41      *
42      * Counterpart to Solidity's `+` operator.
43      *
44      * Requirements:
45      *
46      * - Addition cannot overflow.
47      */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51 
52         return c;
53     }
54 
55     /**
56      * @dev Returns the subtraction of two unsigned integers, reverting on
57      * overflow (when the result is negative).
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      *
63      * - Subtraction cannot overflow.
64      */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return sub(a, b, "SafeMath: subtraction overflow");
67     }
68 
69     /**
70      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
71      * overflow (when the result is negative).
72      *
73      * Counterpart to Solidity's `-` operator.
74      *
75      * Requirements:
76      *
77      * - Subtraction cannot overflow.
78      */
79     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b <= a, errorMessage);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the multiplication of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `*` operator.
91      *
92      * Requirements:
93      *
94      * - Multiplication cannot overflow.
95      */
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
98         // benefit is lost if 'b' is also tested.
99         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
100         if (a == 0) {
101             return 0;
102         }
103 
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the integer division of two unsigned integers. Reverts on
112      * division by zero. The result is rounded towards zero.
113      *
114      * Counterpart to Solidity's `/` operator. Note: this function uses a
115      * `revert` opcode (which leaves remaining gas untouched) while Solidity
116      * uses an invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      *
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         return div(a, b, "SafeMath: division by zero");
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator. Note: this function uses a
131      * `revert` opcode (which leaves remaining gas untouched) while Solidity
132      * uses an invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b > 0, errorMessage);
140         uint256 c = a / b;
141         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         return mod(a, b, "SafeMath: modulo by zero");
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * Reverts with custom message when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b != 0, errorMessage);
176         return a % b;
177     }
178 }
179 
180 /*
181  * @dev Provides information about the current execution context, including the
182  * sender of the transaction and its data. While these are generally available
183  * via msg.sender and msg.data, they should not be accessed in such a direct
184  * manner, since when dealing with GSN meta-transactions the account sending and
185  * paying for execution may not be the actual sender (as far as an application
186  * is concerned).
187  *
188  * This contract is only required for intermediate, library-like contracts.
189  */
190 abstract contract Context {
191     function _msgSender() internal view virtual returns (address payable) {
192         return msg.sender;
193     }
194 
195     function _msgData() internal view virtual returns (bytes memory) {
196         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
197         return msg.data;
198     }
199 }
200 
201 /**
202  * @dev Interface of the ERC20 standard as defined in the EIP.
203  */
204 interface IERC20 {
205     /**
206      * @dev Returns the amount of tokens in existence.
207      */
208     function totalSupply() external view returns (uint256);
209 
210     /**
211      * @dev Returns the amount of tokens owned by `account`.
212      */
213     function balanceOf(address account) external view returns (uint256);
214 
215     /**
216      * @dev Moves `amount` tokens from the caller's account to `recipient`.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transfer(address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Returns the remaining number of tokens that `spender` will be
226      * allowed to spend on behalf of `owner` through {transferFrom}. This is
227      * zero by default.
228      *
229      * This value changes when {approve} or {transferFrom} are called.
230      */
231     function allowance(address owner, address spender) external view returns (uint256);
232 
233     /**
234      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * IMPORTANT: Beware that changing an allowance with this method brings the risk
239      * that someone may use both the old and the new allowance by unfortunate
240      * transaction ordering. One possible solution to mitigate this race
241      * condition is to first reduce the spender's allowance to 0 and set the
242      * desired value afterwards:
243      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244      *
245      * Emits an {Approval} event.
246      */
247     function approve(address spender, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Moves `amount` tokens from `sender` to `recipient` using the
251      * allowance mechanism. `amount` is then deducted from the caller's
252      * allowance.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Emitted when `value` tokens are moved from one account (`from`) to
262      * another (`to`).
263      *
264      * Note that `value` may be zero.
265      */
266     event Transfer(address indexed from, address indexed to, uint256 value);
267 
268     /**
269      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
270      * a call to {approve}. `value` is the new allowance.
271      */
272     event Approval(address indexed owner, address indexed spender, uint256 value);
273 }
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
413 /**
414  * @dev Implementation of the {IERC20} interface.
415  *
416  * This implementation is agnostic to the way tokens are created. This means
417  * that a supply mechanism has to be added in a derived contract using {_mint}.
418  * For a generic mechanism see {ERC20PresetMinterPauser}.
419  *
420  * TIP: For a detailed writeup see our guide
421  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
422  * to implement supply mechanisms].
423  *
424  * We have followed general OpenZeppelin guidelines: functions revert instead
425  * of returning `false` on failure. This behavior is nonetheless conventional
426  * and does not conflict with the expectations of ERC20 applications.
427  *
428  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
429  * This allows applications to reconstruct the allowance for all accounts just
430  * by listening to said events. Other implementations of the EIP may not emit
431  * these events, as it isn't required by the specification.
432  *
433  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
434  * functions have been added to mitigate the well-known issues around setting
435  * allowances. See {IERC20-approve}.
436  */
437 contract ERC20 is Context, IERC20 {
438     using SafeMath for uint256;
439     using Address for address;
440 
441     mapping (address => uint256) private _balances;
442 
443     mapping (address => mapping (address => uint256)) private _allowances;
444 
445     uint256 private _totalSupply;
446 
447     string private _name;
448     string private _symbol;
449     uint8 private _decimals;
450 
451     /**
452      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
453      * a default value of 18.
454      *
455      * To select a different value for {decimals}, use {_setupDecimals}.
456      *
457      * All three of these values are immutable: they can only be set once during
458      * construction.
459      */
460     constructor (string memory name, string memory symbol) public {
461         _name = name;
462         _symbol = symbol;
463         _decimals = 18;
464     }
465 
466     /**
467      * @dev Returns the name of the token.
468      */
469     function name() public view returns (string memory) {
470         return _name;
471     }
472 
473     /**
474      * @dev Returns the symbol of the token, usually a shorter version of the
475      * name.
476      */
477     function symbol() public view returns (string memory) {
478         return _symbol;
479     }
480 
481     /**
482      * @dev Returns the number of decimals used to get its user representation.
483      * For example, if `decimals` equals `2`, a balance of `505` tokens should
484      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
485      *
486      * Tokens usually opt for a value of 18, imitating the relationship between
487      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
488      * called.
489      *
490      * NOTE: This information is only used for _display_ purposes: it in
491      * no way affects any of the arithmetic of the contract, including
492      * {IERC20-balanceOf} and {IERC20-transfer}.
493      */
494     function decimals() public view returns (uint8) {
495         return _decimals;
496     }
497 
498     /**
499      * @dev See {IERC20-totalSupply}.
500      */
501     function totalSupply() public view override returns (uint256) {
502         return _totalSupply;
503     }
504 
505     /**
506      * @dev See {IERC20-balanceOf}.
507      */
508     function balanceOf(address account) public view override returns (uint256) {
509         return _balances[account];
510     }
511 
512     /**
513      * @dev See {IERC20-transfer}.
514      *
515      * Requirements:
516      *
517      * - `recipient` cannot be the zero address.
518      * - the caller must have a balance of at least `amount`.
519      */
520     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
521         _transfer(_msgSender(), recipient, amount);
522         return true;
523     }
524 
525     /**
526      * @dev See {IERC20-allowance}.
527      */
528     function allowance(address owner, address spender) public view virtual override returns (uint256) {
529         return _allowances[owner][spender];
530     }
531 
532     /**
533      * @dev See {IERC20-approve}.
534      *
535      * Requirements:
536      *
537      * - `spender` cannot be the zero address.
538      */
539     function approve(address spender, uint256 amount) public virtual override returns (bool) {
540         _approve(_msgSender(), spender, amount);
541         return true;
542     }
543 
544     /**
545      * @dev See {IERC20-transferFrom}.
546      *
547      * Emits an {Approval} event indicating the updated allowance. This is not
548      * required by the EIP. See the note at the beginning of {ERC20};
549      *
550      * Requirements:
551      * - `sender` and `recipient` cannot be the zero address.
552      * - `sender` must have a balance of at least `amount`.
553      * - the caller must have allowance for ``sender``'s tokens of at least
554      * `amount`.
555      */
556     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
557         _transfer(sender, recipient, amount);
558         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
559         return true;
560     }
561 
562     /**
563      * @dev Atomically increases the allowance granted to `spender` by the caller.
564      *
565      * This is an alternative to {approve} that can be used as a mitigation for
566      * problems described in {IERC20-approve}.
567      *
568      * Emits an {Approval} event indicating the updated allowance.
569      *
570      * Requirements:
571      *
572      * - `spender` cannot be the zero address.
573      */
574     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
575         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
576         return true;
577     }
578 
579     /**
580      * @dev Atomically decreases the allowance granted to `spender` by the caller.
581      *
582      * This is an alternative to {approve} that can be used as a mitigation for
583      * problems described in {IERC20-approve}.
584      *
585      * Emits an {Approval} event indicating the updated allowance.
586      *
587      * Requirements:
588      *
589      * - `spender` cannot be the zero address.
590      * - `spender` must have allowance for the caller of at least
591      * `subtractedValue`.
592      */
593     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
594         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
595         return true;
596     }
597 
598     /**
599      * @dev Moves tokens `amount` from `sender` to `recipient`.
600      *
601      * This is internal function is equivalent to {transfer}, and can be used to
602      * e.g. implement automatic token fees, slashing mechanisms, etc.
603      *
604      * Emits a {Transfer} event.
605      *
606      * Requirements:
607      *
608      * - `sender` cannot be the zero address.
609      * - `recipient` cannot be the zero address.
610      * - `sender` must have a balance of at least `amount`.
611      */
612     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
613         require(sender != address(0), "ERC20: transfer from the zero address");
614         require(recipient != address(0), "ERC20: transfer to the zero address");
615 
616         _beforeTokenTransfer(sender, recipient, amount);
617 
618         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
619         _balances[recipient] = _balances[recipient].add(amount);
620         emit Transfer(sender, recipient, amount);
621     }
622 
623     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
624      * the total supply.
625      *
626      * Emits a {Transfer} event with `from` set to the zero address.
627      *
628      * Requirements
629      *
630      * - `to` cannot be the zero address.
631      */
632     function _mint(address account, uint256 amount) internal virtual {
633         require(account != address(0), "ERC20: mint to the zero address");
634 
635         _beforeTokenTransfer(address(0), account, amount);
636 
637         _totalSupply = _totalSupply.add(amount);
638         _balances[account] = _balances[account].add(amount);
639         emit Transfer(address(0), account, amount);
640     }
641 
642     /**
643      * @dev Destroys `amount` tokens from `account`, reducing the
644      * total supply.
645      *
646      * Emits a {Transfer} event with `to` set to the zero address.
647      *
648      * Requirements
649      *
650      * - `account` cannot be the zero address.
651      * - `account` must have at least `amount` tokens.
652      */
653     function _burn(address account, uint256 amount) internal virtual {
654         require(account != address(0), "ERC20: burn from the zero address");
655 
656         _beforeTokenTransfer(account, address(0), amount);
657 
658         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
659         _totalSupply = _totalSupply.sub(amount);
660         emit Transfer(account, address(0), amount);
661     }
662 
663     /**
664      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
665      *
666      * This internal function is equivalent to `approve`, and can be used to
667      * e.g. set automatic allowances for certain subsystems, etc.
668      *
669      * Emits an {Approval} event.
670      *
671      * Requirements:
672      *
673      * - `owner` cannot be the zero address.
674      * - `spender` cannot be the zero address.
675      */
676     function _approve(address owner, address spender, uint256 amount) internal virtual {
677         require(owner != address(0), "ERC20: approve from the zero address");
678         require(spender != address(0), "ERC20: approve to the zero address");
679 
680         _allowances[owner][spender] = amount;
681         emit Approval(owner, spender, amount);
682     }
683 
684     /**
685      * @dev Sets {decimals} to a value other than the default one of 18.
686      *
687      * WARNING: This function should only be called from the constructor. Most
688      * applications that interact with token contracts will not expect
689      * {decimals} to ever change, and may work incorrectly if it does.
690      */
691     function _setupDecimals(uint8 decimals_) internal {
692         _decimals = decimals_;
693     }
694 
695     /**
696      * @dev Hook that is called before any transfer of tokens. This includes
697      * minting and burning.
698      *
699      * Calling conditions:
700      *
701      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
702      * will be to transferred to `to`.
703      * - when `from` is zero, `amount` tokens will be minted for `to`.
704      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
705      * - `from` and `to` are never both zero.
706      *
707      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
708      */
709     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
710 }
711 
712 /**
713  * @title SafeERC20
714  * @dev Wrappers around ERC20 operations that throw on failure (when the token
715  * contract returns false). Tokens that return no value (and instead revert or
716  * throw on failure) are also supported, non-reverting calls are assumed to be
717  * successful.
718  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
719  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
720  */
721 library SafeERC20 {
722     using SafeMath for uint256;
723     using Address for address;
724 
725     function safeTransfer(IERC20 token, address to, uint256 value) internal {
726         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
727     }
728 
729     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
730         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
731     }
732 
733     /**
734      * @dev Deprecated. This function has issues similar to the ones found in
735      * {IERC20-approve}, and its usage is discouraged.
736      *
737      * Whenever possible, use {safeIncreaseAllowance} and
738      * {safeDecreaseAllowance} instead.
739      */
740     function safeApprove(IERC20 token, address spender, uint256 value) internal {
741         // safeApprove should only be called when setting an initial allowance,
742         // or when resetting it to zero. To increase and decrease it, use
743         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
744         // solhint-disable-next-line max-line-length
745         require((value == 0) || (token.allowance(address(this), spender) == 0),
746             "SafeERC20: approve from non-zero to non-zero allowance"
747         );
748         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
749     }
750 
751     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
752         uint256 newAllowance = token.allowance(address(this), spender).add(value);
753         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
754     }
755 
756     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
757         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
758         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
759     }
760 
761     /**
762      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
763      * on the return value: the return value is optional (but if data is returned, it must not be false).
764      * @param token The token targeted by the call.
765      * @param data The call data (encoded using abi.encode or one of its variants).
766      */
767     function _callOptionalReturn(IERC20 token, bytes memory data) private {
768         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
769         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
770         // the target address contains contract code and also asserts for success in the low-level call.
771 
772         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
773         if (returndata.length > 0) { // Return data is optional
774             // solhint-disable-next-line max-line-length
775             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
776         }
777     }
778 }
779 
780 // Code adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/pull/2237/
781 /**
782  * @dev Interface of the ERC2612 standard as defined in the EIP.
783  *
784  * Adds the {permit} method, which can be used to change one's
785  * {IERC20-allowance} without having to send a transaction, by signing a
786  * message. This allows users to spend tokens without having to hold Ether.
787  *
788  * See https://eips.ethereum.org/EIPS/eip-2612.
789  */
790 interface IERC2612 {
791     /**
792      * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
793      * given `owner`'s signed approval.
794      *
795      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
796      * ordering also apply here.
797      *
798      * Emits an {Approval} event.
799      *
800      * Requirements:
801      *
802      * - `owner` cannot be the zero address.
803      * - `spender` cannot be the zero address.
804      * - `deadline` must be a timestamp in the future.
805      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
806      * over the EIP712-formatted function arguments.
807      * - the signature must use ``owner``'s current nonce (see {nonces}).
808      *
809      * For more information on the signature format, see the
810      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
811      * section].
812      */
813     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
814 
815     /**
816      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
817      * included whenever a signature is generated for {permit}.
818      *
819      * Every successful call to {permit} increases ``owner``'s nonce by one. This
820      * prevents a signature from being used multiple times.
821      */
822     function nonces(address owner) external view returns (uint256);
823 }
824 
825 // SPDX-License-Identifier: GPL-3.0-or-later
826 // Adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/53516bc555a454862470e7860a9b5254db4d00f5/contracts/token/ERC20/ERC20Permit.sol
827 /**
828  * @author Georgios Konstantopoulos
829  * @dev Extension of {ERC20} that allows token holders to use their tokens
830  * without sending any transactions by setting {IERC20-allowance} with a
831  * signature using the {permit} method, and then spend them via
832  * {IERC20-transferFrom}.
833  *
834  * The {permit} signature mechanism conforms to the {IERC2612} interface.
835  */
836 abstract contract ERC20Permit is ERC20, IERC2612 {
837     mapping (address => uint256) public override nonces;
838 
839     bytes32 public immutable PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
840     bytes32 public immutable DOMAIN_SEPARATOR;
841     constructor(string memory name_, string memory symbol_) internal ERC20(name_, symbol_) {
842         uint256 chainId;
843         assembly {
844             chainId := chainid()
845         }
846 
847         DOMAIN_SEPARATOR = keccak256(
848             abi.encode(
849                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
850                 keccak256(bytes(name_)),
851                 keccak256(bytes("1")),
852                 chainId,
853                 address(this)
854             )
855         );
856     }
857 
858     /**
859      * @dev See {IERC2612-permit}.
860      *
861      * In cases where the free option is not a concern, deadline can simply be
862      * set to uint(-1), so it should be seen as an optional parameter
863      */
864     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
865         require(deadline >= block.timestamp, "ERC20Permit: expired deadline");
866 
867         bytes32 hashStruct = keccak256(
868             abi.encode(
869                 PERMIT_TYPEHASH,
870                 owner,
871                 spender,
872                 amount,
873                 nonces[owner]++,
874                 deadline
875             )
876         );
877 
878         bytes32 hash = keccak256(
879             abi.encodePacked(
880                 '\x19\x01',
881                 DOMAIN_SEPARATOR,
882                 hashStruct
883             )
884         );
885 
886         address signer = ecrecover(hash, v, r, s);
887         require(
888             signer != address(0) && signer == owner,
889             "ERC20Permit: invalid signature"
890         );
891 
892         _approve(owner, spender, amount);
893     }
894 
895 }
896 
897 /**
898  * @dev Contract module that helps prevent reentrant calls to a function.
899  *
900  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
901  * available, which can be applied to functions to make sure there are no nested
902  * (reentrant) calls to them.
903  *
904  * Note that because there is a single `nonReentrant` guard, functions marked as
905  * `nonReentrant` may not call one another. This can be worked around by making
906  * those functions `private`, and then adding `external` `nonReentrant` entry
907  * points to them.
908  *
909  * TIP: If you would like to learn more about reentrancy and alternative ways
910  * to protect against it, check out our blog post
911  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
912  */
913 contract ReentrancyGuard {
914     // Booleans are more expensive than uint256 or any type that takes up a full
915     // word because each write operation emits an extra SLOAD to first read the
916     // slot's contents, replace the bits taken up by the boolean, and then write
917     // back. This is the compiler's defense against contract upgrades and
918     // pointer aliasing, and it cannot be disabled.
919 
920     // The values being non-zero value makes deployment a bit more expensive,
921     // but in exchange the refund on every call to nonReentrant will be lower in
922     // amount. Since refunds are capped to a percentage of the total
923     // transaction's gas, it is best to keep them low in cases like this one, to
924     // increase the likelihood of the full refund coming into effect.
925     uint256 constant _NOT_ENTERED = 1;
926     uint256 constant _ENTERED = 2;
927 
928     uint256 _status;
929 
930     constructor () internal {
931         _status = _NOT_ENTERED;
932     }
933 
934     /**
935      * @dev Prevents a contract from calling itself, directly or indirectly.
936      * Calling a `nonReentrant` function from another `nonReentrant`
937      * function is not supported. It is possible to prevent this from happening
938      * by making the `nonReentrant` function external, and make it call a
939      * `private` function that does the actual work.
940      */
941     modifier nonReentrant() {
942         // On the first call to nonReentrant, _notEntered will be true
943         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
944 
945         // Any calls to nonReentrant after this point will fail
946         _status = _ENTERED;
947 
948         _;
949 
950         // By storing the original value once again, a refund is triggered (see
951         // https://eips.ethereum.org/EIPS/eip-2200)
952         _status = _NOT_ENTERED;
953     }
954 }
955 
956 /**
957 * @title IFlashLoanReceiver interface
958 * @notice Interface for the Mushrooms fee IFlashLoanReceiver.
959 * @author Mushrooms
960 * @dev implement this interface to develop a flashloan-compatible flashLoanReceiver contract
961 **/
962 interface IFlashLoanReceiver {
963 
964    /**
965    * @dev execute caller's logic after borrowed tokens
966    * @param _token the address of the reserve in which the flashloan is happening
967    * @param _amount amount of the flashloan tokens
968    * @param _loanFee flashloan fee of this transaction
969    * @param _data the data from caller
970    **/
971    function mushroomsFlashloan(address _token, uint256 _amount, uint256 _loanFee, bytes calldata _data) external;
972 }
973 
974 interface IChiToken {
975     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
976 
977     function balanceOf(address account) external view returns (uint256);
978 
979     function approve(address spender, uint256 amount) external returns (bool);
980 }
981 
982 interface IMasterchef {
983     function BONUS_MULTIPLIER() external view returns (uint256);
984 
985     function add(
986         uint256 _allocPoint,
987         address _lpToken,
988         bool _withUpdate
989     ) external;
990 
991     function bonusEndBlock() external view returns (uint256);
992 
993     function deposit(uint256 _pid, uint256 _amount) external;
994 
995     function dev(address _devaddr) external;
996 
997     function devFundDivRate() external view returns (uint256);
998 
999     function devaddr() external view returns (address);
1000 
1001     function emergencyWithdraw(uint256 _pid) external;
1002 
1003     function getMultiplier(uint256 _from, uint256 _to)
1004         external
1005         view
1006         returns (uint256);
1007 
1008     function massUpdatePools() external;
1009 
1010     function owner() external view returns (address);
1011 
1012     function pendingMM(uint256 _pid, address _user)
1013         external
1014         view
1015         returns (uint256);
1016 
1017     function mm() external view returns (address);
1018 
1019     function mmPerBlock() external view returns (uint256);
1020 
1021     function poolInfo(uint256)
1022         external
1023         view
1024         returns (
1025             address lpToken,
1026             uint256 allocPoint,
1027             uint256 lastRewardBlock,
1028             uint256 accMMPerShare
1029         );
1030 
1031     function poolLength() external view returns (uint256);
1032 
1033     function renounceOwnership() external;
1034 
1035     function set(
1036         uint256 _pid,
1037         uint256 _allocPoint,
1038         bool _withUpdate
1039     ) external;
1040 
1041     function setBonusEndBlock(uint256 _bonusEndBlock) external;
1042 
1043     function setDevFundDivRate(uint256 _devFundDivRate) external;
1044 
1045     function setMMPerBlock(uint256 _mmPerBlock) external;
1046 
1047     function startBlock() external view returns (uint256);
1048 
1049     function totalAllocPoint() external view returns (uint256);
1050 
1051     function transferOwnership(address newOwner) external;
1052 
1053     function updatePool(uint256 _pid) external;
1054 
1055     function userInfo(uint256, address)
1056         external
1057         view
1058         returns (uint256 amount, uint256 rewardDebt);
1059 
1060     function withdraw(uint256 _pid, uint256 _amount) external;
1061 
1062     function notifyBuybackReward(uint256 _amount) external;
1063 }
1064 
1065 // https://github.com/iearn-finance/vaults/blob/master/contracts/vaults/yVault.sol
1066 contract MMVault is ReentrancyGuard, ERC20Permit  {
1067     using SafeERC20 for IERC20;
1068     using Address for address;
1069     using SafeMath for uint256;
1070 
1071     IERC20 public token;
1072 
1073     IChiToken public constant chi = IChiToken(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
1074 
1075     uint256 public min = 9500;
1076     uint256 public constant max = 10000;
1077 
1078     uint256 public loanFee = 1;
1079     uint256 public loanFeeMax = 10000;
1080     bool public loanEnabled = true;
1081 
1082     address public governance;
1083     address public timelock;
1084     address public controller;
1085 
1086     mapping(address => bool) public keepers;
1087     mapping(address => bool) public reentrancyWhitelist;
1088 
1089     uint256 public DAY_SECONDS = 86400;
1090     uint256 public lockWindowBuffer = DAY_SECONDS/4;
1091 
1092     uint256 public lockStartTime;
1093     uint256 public lockWindow;
1094     uint256 public withdrawWindow;
1095     uint256 public earnedTimestamp;
1096     bool public lockEnabled = false;
1097     bool public earnOnceEnabled = false;
1098 
1099     event FlashLoan(address _token, address _receiver, uint256 _amount, uint256 _loanFee);
1100 
1101     modifier discountCHI() {
1102         uint256 gasStart = gasleft();
1103         _;
1104         uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
1105 
1106         if(chi.balanceOf(msg.sender) > 0) {
1107             chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41947);
1108         }
1109     }
1110 
1111     modifier onlyKeepers {
1112         require(
1113             keepers[msg.sender] ||
1114             msg.sender == governance,
1115             "!keepers"
1116         );
1117         _;
1118     }
1119 
1120     modifier onlyGovernance(){
1121         require(msg.sender == governance, "!governance");
1122         _;
1123     }
1124 
1125     modifier canEarn {
1126         if(lockEnabled){
1127             require(
1128                 block.timestamp > lockStartTime,
1129                 "!earnTime"
1130             );
1131             if(earnOnceEnabled){
1132                 require(
1133                     block.timestamp.sub(earnedTimestamp) > lockWindow,
1134                      "!earnTwice");
1135                 if(earnedTimestamp != 0){
1136                     lockStartTime = getLockCycleEndTime();
1137                 }
1138                 earnedTimestamp = block.timestamp;
1139             }
1140         }
1141         _;
1142     }
1143 
1144     modifier canWithdraw(uint256 _shares) {
1145         if(lockEnabled){
1146             //withdraw locker not work when withdraw amount less than available balance
1147             if(!withdrawableWithoutLock(_shares)){
1148                 uint256 withdrawStartTimestamp = lockStartTime.add(lockWindow);
1149                 require(
1150                     block.timestamp > withdrawStartTimestamp &&
1151                     block.timestamp < withdrawStartTimestamp.add(withdrawWindow),
1152                     "!withdrawTime"
1153                 );
1154             }
1155         }
1156         _;
1157     }
1158 	
1159     modifier nonReentrantWithWhitelist() {
1160         // only check if NOT in whitelist
1161         if (!reentrancyWhitelist[msg.sender]){
1162             // On the first call to nonReentrantWithWhitelist, _notEntered will be true
1163             require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1164             // Any calls to nonReentrantWithWhitelist after this point will fail
1165             _status = _ENTERED;
1166         }
1167 
1168         _;	
1169         
1170         if (!reentrancyWhitelist[msg.sender]){
1171             // By storing the original value once again, a refund is triggered (see https://eips.ethereum.org/EIPS/eip-2200)
1172             _status = _NOT_ENTERED;	
1173         }
1174     }
1175 
1176     constructor(address _token, address _governance, address _timelock, address _controller)
1177         public
1178         ERC20Permit(
1179             string(abi.encodePacked("mushrooming ", ERC20(_token).name())),
1180             string(abi.encodePacked("m", ERC20(_token).symbol()))
1181         )
1182     {
1183         _setupDecimals(ERC20(_token).decimals());
1184         token = IERC20(_token);
1185         governance = _governance;
1186         timelock = _timelock;
1187         controller = _controller;
1188 
1189         //time line: [lockStartTime]|----lockWindow----|----withdrawWindow----|[lockStartTime]|----lockWindow---|........
1190         lockWindow = (14 * DAY_SECONDS) + lockWindowBuffer;
1191         withdrawWindow = DAY_SECONDS/2;
1192         lockStartTime = block.timestamp.add(withdrawWindow);
1193     }
1194 
1195     function getName() public pure returns(string memory){
1196         return "mmVaultV2";
1197     }
1198 
1199     function balance() public view returns (uint256) {
1200         return token.balanceOf(address(this)).add(IController(controller).balanceOf(address(token)));
1201     }
1202 
1203     function setMin(uint256 _min) external onlyGovernance{
1204         min = _min;
1205     }
1206 
1207     function setGovernance(address _governance) public onlyGovernance{
1208         governance = _governance;
1209     }
1210 
1211     function setTimelock(address _timelock) public {
1212         require(msg.sender == timelock, "!timelock");
1213         timelock = _timelock;
1214     }
1215 
1216     function setController(address _controller) public {
1217         require(msg.sender == timelock, "!timelock");
1218         controller = _controller;
1219     }
1220 
1221     function setLoanFee(uint256 _loanFee) public onlyGovernance{
1222         loanFee = _loanFee;
1223     }
1224 
1225     function setLoanEnabled(bool _loanEnabled) public onlyGovernance{
1226         loanEnabled = _loanEnabled;
1227     }
1228 
1229     function addKeeper(address _keeper) public onlyGovernance{
1230         keepers[_keeper] = true;
1231     }
1232 
1233     function removeKeeper(address _keeper) public onlyGovernance{
1234         keepers[_keeper] = false;
1235     }
1236 
1237     function addReentrancyWhitelist(address _whitelist) public onlyGovernance{
1238         reentrancyWhitelist[_whitelist] = true;
1239     }
1240 
1241     function removeReentrancyWhitelist(address _whitelist) public onlyGovernance{
1242         reentrancyWhitelist[_whitelist] = false;
1243     }
1244 
1245     function setLockWindow(uint256 _lockWindow) public onlyGovernance {
1246         lockWindow = _lockWindow.add(lockWindowBuffer);
1247     }
1248 
1249     function setWithdrawWindow(uint256 _withdrawWindow) public onlyGovernance {
1250         withdrawWindow = _withdrawWindow;
1251     }
1252 
1253     function setLockEnabled(bool _enabled) public onlyGovernance {
1254         lockEnabled = _enabled;
1255     }
1256 
1257     function setEarnOnceEnabled(bool _earnOnce) public onlyGovernance {
1258         earnOnceEnabled = _earnOnce;
1259     }
1260 
1261     function resetLockStartTime(uint256 _lockStartTime) public onlyGovernance{
1262         require(lockEnabled, "!lockEnabled");
1263 
1264         uint256 withdrawEndTime = getLockCycleEndTime();
1265         require(block.timestamp >= withdrawEndTime, "Last lock cycle not end");
1266         require(_lockStartTime > block.timestamp, "!_lockStartTime");
1267         lockStartTime = _lockStartTime;
1268     }
1269 
1270     function getLockCycleEndTime() public view returns (uint256){
1271         return lockStartTime.add(lockWindow).add(withdrawWindow);
1272     }
1273 
1274     function withdrawableWithoutLock(uint256 _shares) public view returns(bool){
1275         uint256 _withdrawAmount = (balance().mul(_shares)).div(totalSupply());
1276         return _withdrawAmount <= token.balanceOf(address(this));
1277     }
1278 
1279     // Custom logic in here for how much the vaults allows to be borrowed
1280     // Sets minimum required on-hand to keep small withdrawals cheap
1281     function available() public view returns (uint256) {
1282         return token.balanceOf(address(this)).mul(min).div(max);
1283     }
1284 
1285     function earn() public nonReentrant onlyKeepers canEarn {
1286         uint256 _bal = available();
1287         token.safeTransfer(controller, _bal);
1288         IController(controller).earn(address(token), _bal);
1289     }
1290 
1291     function depositAll() external {
1292         deposit(token.balanceOf(msg.sender));
1293     }
1294 
1295     function deposit(uint256 _approveAmount, uint256 _amount, uint256 _deadline, uint8 v, bytes32 r, bytes32 s) public {
1296         require(_approveAmount >= _amount, "!_approveAmount");
1297         IERC2612(address(token)).permit(msg.sender, address(this), _approveAmount, _deadline, v, r, s);
1298         deposit(_amount);
1299     }
1300 
1301     function deposit(uint256 _amount) public nonReentrant {
1302         uint256 _pool = balance();
1303         uint256 _before = token.balanceOf(address(this));
1304         token.safeTransferFrom(msg.sender, address(this), _amount);
1305         uint256 _after = token.balanceOf(address(this));
1306         _amount = _after.sub(_before); // Additional check for deflationary tokens
1307         uint256 shares = 0;
1308         if (totalSupply() == 0) {
1309             shares = _amount;
1310         } else {
1311             shares = (_amount.mul(totalSupply())).div(_pool);
1312         }
1313         _mint(msg.sender, shares);
1314     }
1315 
1316     function withdrawAll() external {
1317         withdraw(balanceOf(msg.sender));
1318     }
1319 
1320     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
1321     function harvest(address reserve, uint256 amount)  external nonReentrant {
1322         require(msg.sender == controller, "!controller");
1323         require(reserve != address(token), "token");
1324         IERC20(reserve).safeTransfer(controller, amount);
1325     }
1326 
1327     // No rebalance implementation for lower fees and faster swaps
1328     function withdraw(uint256 _shares) public nonReentrant canWithdraw(_shares) {
1329         uint256 r = (balance().mul(_shares)).div(totalSupply());
1330         _burn(msg.sender, _shares);
1331 
1332         // Check balance
1333         uint256 b = token.balanceOf(address(this));
1334         if (b < r) {
1335             uint256 _withdraw = r.sub(b);
1336             IController(controller).withdraw(address(token), _withdraw);
1337             uint256 _after = token.balanceOf(address(this));
1338             uint256 _diff = _after.sub(b);
1339             if (_diff < _withdraw) {
1340                 r = b.add(_diff);
1341             }
1342         }
1343 
1344         token.safeTransfer(msg.sender, r);
1345     }
1346 
1347     function getRatio() public view returns (uint256) {
1348         return balance().mul(1e18).div(totalSupply());
1349     }
1350 
1351     function flashLoan(address _receiver, uint256 _amount, bytes memory _data) public nonReentrantWithWhitelist discountCHI{
1352         require(loanEnabled == true, "!loanEnabled");
1353         require(_amount > 0, "amount too small!");
1354         uint256 beforeBalance = token.balanceOf(address(this));
1355         require(beforeBalance > _amount, "balance not enough!");
1356 
1357         //loanFee
1358         uint256 _fee = _amount.mul(loanFee).div(loanFeeMax);
1359 
1360         require(_fee > 0, "fee too small");
1361 
1362         //transfer token to _receiver
1363         token.safeTransfer(_receiver, _amount);
1364 
1365         //execute user's logic
1366         IFlashLoanReceiver(_receiver).mushroomsFlashloan(address(token), _amount, _fee, _data);
1367 
1368         uint256 afterBalance = token.balanceOf(address(this));
1369 
1370         require(afterBalance == beforeBalance.add(_fee), "payback amount incorrect!");
1371 
1372         emit FlashLoan(address(token), _receiver, _amount, _fee);
1373     }
1374 
1375 }