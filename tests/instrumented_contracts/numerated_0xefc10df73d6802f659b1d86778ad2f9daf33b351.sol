1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
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
26 
27 
28 
29 
30 
31 
32 
33 
34 
35 
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 
113 
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      *
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157         return sub(a, b, "SafeMath: subtraction overflow");
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      *
185      * - Multiplication cannot overflow.
186      */
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
189         // benefit is lost if 'b' is also tested.
190         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
191         if (a == 0) {
192             return 0;
193         }
194 
195         uint256 c = a * b;
196         require(c / a == b, "SafeMath: multiplication overflow");
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         return mod(a, b, "SafeMath: modulo by zero");
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * Reverts with custom message when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 
272 
273 
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
297         // This method relies in extcodesize, which returns 0 for contracts in
298         // construction, since the code is only stored at the end of the
299         // constructor execution.
300 
301         uint256 size;
302         // solhint-disable-next-line no-inline-assembly
303         assembly { size := extcodesize(account) }
304         return size > 0;
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
665      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
666      *
667      * This internal function is equivalent to `approve`, and can be used to
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
713 
714 
715 
716 
717 
718 /**
719  * @dev Contract module which provides a basic access control mechanism, where
720  * there is an account (an owner) that can be granted exclusive access to
721  * specific functions.
722  *
723  * By default, the owner account will be the one that deploys the contract. This
724  * can later be changed with {transferOwnership}.
725  *
726  * This module is used through inheritance. It will make available the modifier
727  * `onlyOwner`, which can be applied to your functions to restrict their use to
728  * the owner.
729  */
730 contract Ownable is Context {
731     address private _owner;
732 
733     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
734 
735     /**
736      * @dev Initializes the contract setting the deployer as the initial owner.
737      */
738     constructor () internal {
739         address msgSender = _msgSender();
740         _owner = msgSender;
741         emit OwnershipTransferred(address(0), msgSender);
742     }
743 
744     /**
745      * @dev Returns the address of the current owner.
746      */
747     function owner() public view returns (address) {
748         return _owner;
749     }
750 
751     /**
752      * @dev Throws if called by any account other than the owner.
753      */
754     modifier onlyOwner() {
755         require(_owner == _msgSender(), "Ownable: caller is not the owner");
756         _;
757     }
758 
759     /**
760      * @dev Leaves the contract without owner. It will not be possible to call
761      * `onlyOwner` functions anymore. Can only be called by the current owner.
762      *
763      * NOTE: Renouncing ownership will leave the contract without an owner,
764      * thereby removing any functionality that is only available to the owner.
765      */
766     function renounceOwnership() public virtual onlyOwner {
767         emit OwnershipTransferred(_owner, address(0));
768         _owner = address(0);
769     }
770 
771     /**
772      * @dev Transfers ownership of the contract to a new account (`newOwner`).
773      * Can only be called by the current owner.
774      */
775     function transferOwnership(address newOwner) public virtual onlyOwner {
776         require(newOwner != address(0), "Ownable: new owner is the zero address");
777         emit OwnershipTransferred(_owner, newOwner);
778         _owner = newOwner;
779     }
780 }
781 
782 // import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
783 // import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
784 
785 library Roles {
786     struct Role {
787         mapping (address => bool) bearer;
788     }
789     /**
790      * @dev give an account access to this role
791      */
792     function add(Role storage role, address account) internal {
793         require(account != address(0));
794         require(!has(role, account));
795 
796         role.bearer[account] = true;
797     }
798 
799     /**
800      * @dev remove an account's access to this role
801      */
802     function remove(Role storage role, address account) internal {
803         require(account != address(0));
804         require(has(role, account));
805 
806         role.bearer[account] = false;
807     }
808 
809     /**
810      * @dev check if an account has this role
811      * @return bool
812      */
813     function has(Role storage role, address account) internal view returns (bool) {
814         require(account != address(0));
815         return role.bearer[account];
816     }
817 }
818 
819 contract MinterRole is Ownable {
820     using Roles for Roles.Role;
821 
822     event MinterAdded(address indexed account);
823     event MinterRemoved(address indexed account);
824 
825     Roles.Role private _minters;
826 
827     constructor () internal {
828         _addMinter(msg.sender);
829     }
830 
831     modifier onlyMinter() {
832         require(isMinter(msg.sender));
833         _;
834     }
835 
836     function isMinter(address account) public view returns (bool) {
837         return _minters.has(account);
838     }
839 
840     function addMinter(address account) public onlyMinter {
841         _addMinter(account);
842     }
843     
844     function removeMinter(address account) public onlyOwner {
845         _removeMinter(account);
846     }
847 
848     function renounceMinter() public {
849         _removeMinter(msg.sender);
850     }
851 
852     function _addMinter(address account) internal {
853         _minters.add(account);
854         emit MinterAdded(account);
855     }
856 
857     function _removeMinter(address account) internal {
858         _minters.remove(account);
859         emit MinterRemoved(account);
860     }
861 }
862 
863 
864 // CoffnbToken with Governance.
865 contract CoffnbToken is ERC20("CoffnbToken", "CFNB"), MinterRole {
866     
867     uint256 private constant maxSupply = 5 * 1e6 * 1e18;  // the max supply
868 
869     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner or admin (CoffnbMaster).
870     function mint(address _to, uint256 _amount) public onlyMinter returns (bool) {
871         if (_amount.add(totalSupply()) > maxSupply) {
872             return false; 
873         } 
874         _mint(_to, _amount);
875         _moveDelegates(address(0), _delegates[_to], _amount);
876         return true;
877     }
878 
879     // Copied and modified from YAM code:
880     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
881     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
882     // Which is copied and modified from COMPOUND:
883     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
884 
885     // @notice A record of each accounts delegate
886     mapping (address => address) internal _delegates;
887 
888     /// @notice A checkpoint for marking number of votes from a given block
889     struct Checkpoint {
890         uint32 fromBlock;
891         uint256 votes;
892     }
893 
894     /// @notice A record of votes checkpoints for each account, by index
895     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
896 
897     /// @notice The number of checkpoints for each account
898     mapping (address => uint32) public numCheckpoints;
899 
900     /// @notice The EIP-712 typehash for the contract's domain
901     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
902 
903     /// @notice The EIP-712 typehash for the delegation struct used by the contract
904     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
905 
906     /// @notice A record of states for signing / validating signatures
907     mapping (address => uint) public nonces;
908 
909       /// @notice An event thats emitted when an account changes its delegate
910     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
911 
912     /// @notice An event thats emitted when a delegate account's vote balance changes
913     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
914 
915     /**
916      * @notice Delegate votes from `msg.sender` to `delegatee`
917      * @param delegator The address to get delegatee for
918      */
919     function delegates(address delegator)
920         external
921         view
922         returns (address)
923     {
924         return _delegates[delegator];
925     }
926 
927    /**
928     * @notice Delegate votes from `msg.sender` to `delegatee`
929     * @param delegatee The address to delegate votes to
930     */
931     function delegate(address delegatee) external {
932         return _delegate(msg.sender, delegatee);
933     }
934 
935     /**
936      * @notice Delegates votes from signatory to `delegatee`
937      * @param delegatee The address to delegate votes to
938      * @param nonce The contract state required to match the signature
939      * @param expiry The time at which to expire the signature
940      * @param v The recovery byte of the signature
941      * @param r Half of the ECDSA signature pair
942      * @param s Half of the ECDSA signature pair
943      */
944     function delegateBySig(
945         address delegatee,
946         uint nonce,
947         uint expiry,
948         uint8 v,
949         bytes32 r,
950         bytes32 s
951     )
952         external
953     {
954         bytes32 domainSeparator = keccak256(
955             abi.encode(
956                 DOMAIN_TYPEHASH,
957                 keccak256(bytes(name())),
958                 getChainId(),
959                 address(this)
960             )
961         );
962 
963         bytes32 structHash = keccak256(
964             abi.encode(
965                 DELEGATION_TYPEHASH,
966                 delegatee,
967                 nonce,
968                 expiry
969             )
970         );
971 
972         bytes32 digest = keccak256(
973             abi.encodePacked(
974                 "\x19\x01",
975                 domainSeparator,
976                 structHash
977             )
978         );
979 
980         address signatory = ecrecover(digest, v, r, s);
981         require(signatory != address(0), "CFNB::delegateBySig: invalid signature");
982         require(nonce == nonces[signatory]++, "CFNB::delegateBySig: invalid nonce");
983         require(now <= expiry, "CFNB::delegateBySig: signature expired");
984         return _delegate(signatory, delegatee);
985     }
986 
987     /**
988      * @notice Gets the current votes balance for `account`
989      * @param account The address to get votes balance
990      * @return The number of current votes for `account`
991      */
992     function getCurrentVotes(address account)
993         external
994         view
995         returns (uint256)
996     {
997         uint32 nCheckpoints = numCheckpoints[account];
998         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
999     }
1000 
1001     /**
1002      * @notice Determine the prior number of votes for an account as of a block number
1003      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1004      * @param account The address of the account to check
1005      * @param blockNumber The block number to get the vote balance at
1006      * @return The number of votes the account had as of the given block
1007      */
1008     function getPriorVotes(address account, uint blockNumber)
1009         external
1010         view
1011         returns (uint256)
1012     {
1013         require(blockNumber < block.number, "CFNB::getPriorVotes: not yet determined");
1014 
1015         uint32 nCheckpoints = numCheckpoints[account];
1016         if (nCheckpoints == 0) {
1017             return 0;
1018         }
1019 
1020         // First check most recent balance
1021         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1022             return checkpoints[account][nCheckpoints - 1].votes;
1023         }
1024 
1025         // Next check implicit zero balance
1026         if (checkpoints[account][0].fromBlock > blockNumber) {
1027             return 0;
1028         }
1029 
1030         uint32 lower = 0;
1031         uint32 upper = nCheckpoints - 1;
1032         while (upper > lower) {
1033             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1034             Checkpoint memory cp = checkpoints[account][center];
1035             if (cp.fromBlock == blockNumber) {
1036                 return cp.votes;
1037             } else if (cp.fromBlock < blockNumber) {
1038                 lower = center;
1039             } else {
1040                 upper = center - 1;
1041             }
1042         }
1043         return checkpoints[account][lower].votes;
1044     }
1045 
1046     function _delegate(address delegator, address delegatee)
1047         internal
1048     {
1049         address currentDelegate = _delegates[delegator];
1050         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying CFNBs (not scaled);
1051         _delegates[delegator] = delegatee;
1052 
1053         emit DelegateChanged(delegator, currentDelegate, delegatee);
1054 
1055         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1056     }
1057 
1058     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1059         if (srcRep != dstRep && amount > 0) {
1060             if (srcRep != address(0)) {
1061                 // decrease old representative
1062                 uint32 srcRepNum = numCheckpoints[srcRep];
1063                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1064                 uint256 srcRepNew = srcRepOld.sub(amount);
1065                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1066             }
1067 
1068             if (dstRep != address(0)) {
1069                 // increase new representative
1070                 uint32 dstRepNum = numCheckpoints[dstRep];
1071                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1072                 uint256 dstRepNew = dstRepOld.add(amount);
1073                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1074             }
1075         }
1076     }
1077 
1078     function _writeCheckpoint(
1079         address delegatee,
1080         uint32 nCheckpoints,
1081         uint256 oldVotes,
1082         uint256 newVotes
1083     )
1084         internal
1085     {
1086         uint32 blockNumber = safe32(block.number, "CFNB::_writeCheckpoint: block number exceeds 32 bits");
1087 
1088         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1089             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1090         } else {
1091             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1092             numCheckpoints[delegatee] = nCheckpoints + 1;
1093         }
1094 
1095         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1096     }
1097 
1098     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1099         require(n < 2**32, errorMessage);
1100         return uint32(n);
1101     }
1102 
1103     function getChainId() internal pure returns (uint) {
1104         uint256 chainId;
1105         assembly { chainId := chainid() }
1106         return chainId;
1107     }
1108 }