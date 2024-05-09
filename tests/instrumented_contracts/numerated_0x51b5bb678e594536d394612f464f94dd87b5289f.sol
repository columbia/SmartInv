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
28 
29 
30 pragma solidity ^0.6.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 
107 
108 pragma solidity ^0.6.0;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 
267 pragma solidity ^0.6.2;
268 
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
292         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
293         // for accounts without code, i.e. `keccak256('')`
294         bytes32 codehash;
295         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
296         // solhint-disable-next-line no-inline-assembly
297         assembly { codehash := extcodehash(account) }
298         return (codehash != accountHash && codehash != 0x0);
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * IMPORTANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
321         (bool success, ) = recipient.call{ value: amount }("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain`call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344       return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
354         return _functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         return _functionCallWithValue(target, data, value, errorMessage);
381     }
382 
383     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 // solhint-disable-next-line no-inline-assembly
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 
408 pragma solidity ^0.6.0;
409 
410 
411 
412 
413 
414 /**
415  * @dev Implementation of the {IERC20} interface.
416  *
417  * This implementation is agnostic to the way tokens are created. This means
418  * that a supply mechanism has to be added in a derived contract using {_mint}.
419  * For a generic mechanism see {ERC20PresetMinterPauser}.
420  *
421  * TIP: For a detailed writeup see our guide
422  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
423  * to implement supply mechanisms].
424  *
425  * We have followed general OpenZeppelin guidelines: functions revert instead
426  * of returning `false` on failure. This behavior is nonetheless conventional
427  * and does not conflict with the expectations of ERC20 applications.
428  *
429  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
430  * This allows applications to reconstruct the allowance for all accounts just
431  * by listening to said events. Other implementations of the EIP may not emit
432  * these events, as it isn't required by the specification.
433  *
434  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
435  * functions have been added to mitigate the well-known issues around setting
436  * allowances. See {IERC20-approve}.
437  */
438 contract ERC20 is Context, IERC20 {
439     using SafeMath for uint256;
440     using Address for address;
441 
442     mapping (address => uint256) private _balances;
443 
444     mapping (address => mapping (address => uint256)) private _allowances;
445 
446     uint256 private _totalSupply;
447 
448     string private _name;
449     string private _symbol;
450     uint8 private _decimals;
451 
452     /**
453      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
454      * a default value of 18.
455      *
456      * To select a different value for {decimals}, use {_setupDecimals}.
457      *
458      * All three of these values are immutable: they can only be set once during
459      * construction.
460      */
461     constructor (string memory name, string memory symbol) public {
462         _name = name;
463         _symbol = symbol;
464         _decimals = 18;
465     }
466 
467     /**
468      * @dev Returns the name of the token.
469      */
470     function name() public view returns (string memory) {
471         return _name;
472     }
473 
474     /**
475      * @dev Returns the symbol of the token, usually a shorter version of the
476      * name.
477      */
478     function symbol() public view returns (string memory) {
479         return _symbol;
480     }
481 
482     /**
483      * @dev Returns the number of decimals used to get its user representation.
484      * For example, if `decimals` equals `2`, a balance of `505` tokens should
485      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
486      *
487      * Tokens usually opt for a value of 18, imitating the relationship between
488      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
489      * called.
490      *
491      * NOTE: This information is only used for _display_ purposes: it in
492      * no way affects any of the arithmetic of the contract, including
493      * {IERC20-balanceOf} and {IERC20-transfer}.
494      */
495     function decimals() public view returns (uint8) {
496         return _decimals;
497     }
498 
499     /**
500      * @dev See {IERC20-totalSupply}.
501      */
502     function totalSupply() public view override returns (uint256) {
503         return _totalSupply;
504     }
505 
506     /**
507      * @dev See {IERC20-balanceOf}.
508      */
509     function balanceOf(address account) public view override returns (uint256) {
510         return _balances[account];
511     }
512 
513     /**
514      * @dev See {IERC20-transfer}.
515      *
516      * Requirements:
517      *
518      * - `recipient` cannot be the zero address.
519      * - the caller must have a balance of at least `amount`.
520      */
521     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
522         _transfer(_msgSender(), recipient, amount);
523         return true;
524     }
525 
526     /**
527      * @dev See {IERC20-allowance}.
528      */
529     function allowance(address owner, address spender) public view virtual override returns (uint256) {
530         return _allowances[owner][spender];
531     }
532 
533     /**
534      * @dev See {IERC20-approve}.
535      *
536      * Requirements:
537      *
538      * - `spender` cannot be the zero address.
539      */
540     function approve(address spender, uint256 amount) public virtual override returns (bool) {
541         _approve(_msgSender(), spender, amount);
542         return true;
543     }
544 
545     /**
546      * @dev See {IERC20-transferFrom}.
547      *
548      * Emits an {Approval} event indicating the updated allowance. This is not
549      * required by the EIP. See the note at the beginning of {ERC20};
550      *
551      * Requirements:
552      * - `sender` and `recipient` cannot be the zero address.
553      * - `sender` must have a balance of at least `amount`.
554      * - the caller must have allowance for ``sender``'s tokens of at least
555      * `amount`.
556      */
557     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
558         _transfer(sender, recipient, amount);
559         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
560         return true;
561     }
562 
563     /**
564      * @dev Atomically increases the allowance granted to `spender` by the caller.
565      *
566      * This is an alternative to {approve} that can be used as a mitigation for
567      * problems described in {IERC20-approve}.
568      *
569      * Emits an {Approval} event indicating the updated allowance.
570      *
571      * Requirements:
572      *
573      * - `spender` cannot be the zero address.
574      */
575     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
576         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
577         return true;
578     }
579 
580     /**
581      * @dev Atomically decreases the allowance granted to `spender` by the caller.
582      *
583      * This is an alternative to {approve} that can be used as a mitigation for
584      * problems described in {IERC20-approve}.
585      *
586      * Emits an {Approval} event indicating the updated allowance.
587      *
588      * Requirements:
589      *
590      * - `spender` cannot be the zero address.
591      * - `spender` must have allowance for the caller of at least
592      * `subtractedValue`.
593      */
594     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
595         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
596         return true;
597     }
598 
599     /**
600      * @dev Moves tokens `amount` from `sender` to `recipient`.
601      *
602      * This is internal function is equivalent to {transfer}, and can be used to
603      * e.g. implement automatic token fees, slashing mechanisms, etc.
604      *
605      * Emits a {Transfer} event.
606      *
607      * Requirements:
608      *
609      * - `sender` cannot be the zero address.
610      * - `recipient` cannot be the zero address.
611      * - `sender` must have a balance of at least `amount`.
612      */
613     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
614         require(sender != address(0), "ERC20: transfer from the zero address");
615         require(recipient != address(0), "ERC20: transfer to the zero address");
616 
617         _beforeTokenTransfer(sender, recipient, amount);
618 
619         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
620         _balances[recipient] = _balances[recipient].add(amount);
621         emit Transfer(sender, recipient, amount);
622     }
623 
624     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
625      * the total supply.
626      *
627      * Emits a {Transfer} event with `from` set to the zero address.
628      *
629      * Requirements
630      *
631      * - `to` cannot be the zero address.
632      */
633     function _mint(address account, uint256 amount) internal virtual {
634         require(account != address(0), "ERC20: mint to the zero address");
635 
636         _beforeTokenTransfer(address(0), account, amount);
637 
638         _totalSupply = _totalSupply.add(amount);
639         _balances[account] = _balances[account].add(amount);
640         emit Transfer(address(0), account, amount);
641     }
642 
643     /**
644      * @dev Destroys `amount` tokens from `account`, reducing the
645      * total supply.
646      *
647      * Emits a {Transfer} event with `to` set to the zero address.
648      *
649      * Requirements
650      *
651      * - `account` cannot be the zero address.
652      * - `account` must have at least `amount` tokens.
653      */
654     function _burn(address account, uint256 amount) internal virtual {
655         require(account != address(0), "ERC20: burn from the zero address");
656 
657         _beforeTokenTransfer(account, address(0), amount);
658 
659         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
660         _totalSupply = _totalSupply.sub(amount);
661         emit Transfer(account, address(0), amount);
662     }
663 
664     /**
665      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
666      *
667      * This is internal function is equivalent to `approve`, and can be used to
668      * e.g. set automatic allowances for certain subsystems, etc.
669      *
670      * Emits an {Approval} event.
671      *
672      * Requirements:
673      *
674      * - `owner` cannot be the zero address.
675      * - `spender` cannot be the zero address.
676      */
677     function _approve(address owner, address spender, uint256 amount) internal virtual {
678         require(owner != address(0), "ERC20: approve from the zero address");
679         require(spender != address(0), "ERC20: approve to the zero address");
680 
681         _allowances[owner][spender] = amount;
682         emit Approval(owner, spender, amount);
683     }
684 
685     /**
686      * @dev Sets {decimals} to a value other than the default one of 18.
687      *
688      * WARNING: This function should only be called from the constructor. Most
689      * applications that interact with token contracts will not expect
690      * {decimals} to ever change, and may work incorrectly if it does.
691      */
692     function _setupDecimals(uint8 decimals_) internal {
693         _decimals = decimals_;
694     }
695 
696     /**
697      * @dev Hook that is called before any transfer of tokens. This includes
698      * minting and burning.
699      *
700      * Calling conditions:
701      *
702      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
703      * will be to transferred to `to`.
704      * - when `from` is zero, `amount` tokens will be minted for `to`.
705      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
706      * - `from` and `to` are never both zero.
707      *
708      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
709      */
710     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
711 }
712 
713 pragma solidity ^0.6.0;
714 
715 /**
716  * @dev Contract module which provides a basic access control mechanism, where
717  * there is an account (an owner) that can be granted exclusive access to
718  * specific functions.
719  *
720  * By default, the owner account will be the one that deploys the contract. This
721  * can later be changed with {transferOwnership}.
722  *
723  * This module is used through inheritance. It will make available the modifier
724  * `onlyOwner`, which can be applied to your functions to restrict their use to
725  * the owner.
726  */
727 contract Ownable is Context {
728     address private _owner;
729 
730     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
731 
732     /**
733      * @dev Initializes the contract setting the deployer as the initial owner.
734      */
735     constructor () internal {
736         address msgSender = _msgSender();
737         _owner = msgSender;
738         emit OwnershipTransferred(address(0), msgSender);
739     }
740 
741     /**
742      * @dev Returns the address of the current owner.
743      */
744     function owner() public view returns (address) {
745         return _owner;
746     }
747 
748     /**
749      * @dev Throws if called by any account other than the owner.
750      */
751     modifier onlyOwner() {
752         require(_owner == _msgSender(), "Ownable: caller is not the owner");
753         _;
754     }
755 
756     /**
757      * @dev Leaves the contract without owner. It will not be possible to call
758      * `onlyOwner` functions anymore. Can only be called by the current owner.
759      *
760      * NOTE: Renouncing ownership will leave the contract without an owner,
761      * thereby removing any functionality that is only available to the owner.
762      */
763     function renounceOwnership() public virtual onlyOwner {
764         emit OwnershipTransferred(_owner, address(0));
765         _owner = address(0);
766     }
767 
768     /**
769      * @dev Transfers ownership of the contract to a new account (`newOwner`).
770      * Can only be called by the current owner.
771      */
772     function transferOwnership(address newOwner) public virtual onlyOwner {
773         require(newOwner != address(0), "Ownable: new owner is the zero address");
774         emit OwnershipTransferred(_owner, newOwner);
775         _owner = newOwner;
776     }
777 }
778 
779 // File: contracts/NekoToken.sol
780 
781 pragma solidity 0.6.12;
782 
783 
784 
785 // NekoToken with Governance.
786 contract NekoToken is ERC20("NekoToken", "NEKO"), Ownable {
787     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
788     function mint(address _to, uint256 _amount) public onlyOwner {
789         _mint(_to, _amount);
790         _moveDelegates(address(0), _delegates[_to], _amount);
791     }
792 
793     // Copied and modified from YAM code:
794     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
795     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
796     // Which is copied and modified from COMPOUND:
797     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
798 
799     /// @notice A record of each accounts delegate
800     mapping(address => address) internal _delegates;
801 
802     /// @notice A checkpoint for marking number of votes from a given block
803     struct Checkpoint {
804         uint32 fromBlock;
805         uint256 votes;
806     }
807 
808     /// @notice A record of votes checkpoints for each account, by index
809     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
810 
811     /// @notice The number of checkpoints for each account
812     mapping(address => uint32) public numCheckpoints;
813 
814     /// @notice The EIP-712 typehash for the contract's domain
815     bytes32 public constant DOMAIN_TYPEHASH = keccak256(
816         "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
817     );
818 
819     /// @notice The EIP-712 typehash for the delegation struct used by the contract
820     bytes32 public constant DELEGATION_TYPEHASH = keccak256(
821         "Delegation(address delegatee,uint256 nonce,uint256 expiry)"
822     );
823 
824     /// @notice A record of states for signing / validating signatures
825     mapping(address => uint256) public nonces;
826 
827     /// @notice An event thats emitted when an account changes its delegate
828     event DelegateChanged(
829         address indexed delegator,
830         address indexed fromDelegate,
831         address indexed toDelegate
832     );
833 
834     /// @notice An event thats emitted when a delegate account's vote balance changes
835     event DelegateVotesChanged(
836         address indexed delegate,
837         uint256 previousBalance,
838         uint256 newBalance
839     );
840 
841     /**
842      * @notice Delegate votes from `msg.sender` to `delegatee`
843      * @param delegator The address to get delegatee for
844      */
845     function delegates(address delegator) external view returns (address) {
846         return _delegates[delegator];
847     }
848 
849     /**
850      * @notice Delegate votes from `msg.sender` to `delegatee`
851      * @param delegatee The address to delegate votes to
852      */
853     function delegate(address delegatee) external {
854         return _delegate(msg.sender, delegatee);
855     }
856 
857     /**
858      * @notice Delegates votes from signatory to `delegatee`
859      * @param delegatee The address to delegate votes to
860      * @param nonce The contract state required to match the signature
861      * @param expiry The time at which to expire the signature
862      * @param v The recovery byte of the signature
863      * @param r Half of the ECDSA signature pair
864      * @param s Half of the ECDSA signature pair
865      */
866     function delegateBySig(
867         address delegatee,
868         uint256 nonce,
869         uint256 expiry,
870         uint8 v,
871         bytes32 r,
872         bytes32 s
873     ) external {
874         bytes32 domainSeparator = keccak256(
875             abi.encode(
876                 DOMAIN_TYPEHASH,
877                 keccak256(bytes(name())),
878                 getChainId(),
879                 address(this)
880             )
881         );
882 
883         bytes32 structHash = keccak256(
884             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
885         );
886 
887         bytes32 digest = keccak256(
888             abi.encodePacked("\x19\x01", domainSeparator, structHash)
889         );
890 
891         address signatory = ecrecover(digest, v, r, s);
892         require(
893             signatory != address(0),
894             "NEKO::delegateBySig: invalid signature"
895         );
896         require(
897             nonce == nonces[signatory]++,
898             "NEKO::delegateBySig: invalid nonce"
899         );
900         require(now <= expiry, "NEKO::delegateBySig: signature expired");
901         return _delegate(signatory, delegatee);
902     }
903 
904     /**
905      * @notice Gets the current votes balance for `account`
906      * @param account The address to get votes balance
907      * @return The number of current votes for `account`
908      */
909     function getCurrentVotes(address account) external view returns (uint256) {
910         uint32 nCheckpoints = numCheckpoints[account];
911         return
912             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
913     }
914 
915     /**
916      * @notice Determine the prior number of votes for an account as of a block number
917      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
918      * @param account The address of the account to check
919      * @param blockNumber The block number to get the vote balance at
920      * @return The number of votes the account had as of the given block
921      */
922     function getPriorVotes(address account, uint256 blockNumber)
923         external
924         view
925         returns (uint256)
926     {
927         require(
928             blockNumber < block.number,
929             "NEKO::getPriorVotes: not yet determined"
930         );
931 
932         uint32 nCheckpoints = numCheckpoints[account];
933         if (nCheckpoints == 0) {
934             return 0;
935         }
936 
937         // First check most recent balance
938         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
939             return checkpoints[account][nCheckpoints - 1].votes;
940         }
941 
942         // Next check implicit zero balance
943         if (checkpoints[account][0].fromBlock > blockNumber) {
944             return 0;
945         }
946 
947         uint32 lower = 0;
948         uint32 upper = nCheckpoints - 1;
949         while (upper > lower) {
950             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
951             Checkpoint memory cp = checkpoints[account][center];
952             if (cp.fromBlock == blockNumber) {
953                 return cp.votes;
954             } else if (cp.fromBlock < blockNumber) {
955                 lower = center;
956             } else {
957                 upper = center - 1;
958             }
959         }
960         return checkpoints[account][lower].votes;
961     }
962 
963     function _delegate(address delegator, address delegatee) internal {
964         address currentDelegate = _delegates[delegator];
965         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying NEKOs (not scaled);
966         _delegates[delegator] = delegatee;
967 
968         emit DelegateChanged(delegator, currentDelegate, delegatee);
969 
970         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
971     }
972 
973     function _moveDelegates(
974         address srcRep,
975         address dstRep,
976         uint256 amount
977     ) internal {
978         if (srcRep != dstRep && amount > 0) {
979             if (srcRep != address(0)) {
980                 // decrease old representative
981                 uint32 srcRepNum = numCheckpoints[srcRep];
982                 uint256 srcRepOld = srcRepNum > 0
983                     ? checkpoints[srcRep][srcRepNum - 1].votes
984                     : 0;
985                 uint256 srcRepNew = srcRepOld.sub(amount);
986                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
987             }
988 
989             if (dstRep != address(0)) {
990                 // increase new representative
991                 uint32 dstRepNum = numCheckpoints[dstRep];
992                 uint256 dstRepOld = dstRepNum > 0
993                     ? checkpoints[dstRep][dstRepNum - 1].votes
994                     : 0;
995                 uint256 dstRepNew = dstRepOld.add(amount);
996                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
997             }
998         }
999     }
1000 
1001     function _writeCheckpoint(
1002         address delegatee,
1003         uint32 nCheckpoints,
1004         uint256 oldVotes,
1005         uint256 newVotes
1006     ) internal {
1007         uint32 blockNumber = safe32(
1008             block.number,
1009             "NEKO::_writeCheckpoint: block number exceeds 32 bits"
1010         );
1011 
1012         if (
1013             nCheckpoints > 0 &&
1014             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
1015         ) {
1016             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1017         } else {
1018             checkpoints[delegatee][nCheckpoints] = Checkpoint(
1019                 blockNumber,
1020                 newVotes
1021             );
1022             numCheckpoints[delegatee] = nCheckpoints + 1;
1023         }
1024 
1025         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1026     }
1027 
1028     function safe32(uint256 n, string memory errorMessage)
1029         internal
1030         pure
1031         returns (uint32)
1032     {
1033         require(n < 2**32, errorMessage);
1034         return uint32(n);
1035     }
1036 
1037     function getChainId() internal pure returns (uint256) {
1038         uint256 chainId;
1039         assembly {
1040             chainId := chainid()
1041         }
1042         return chainId;
1043     }
1044 }