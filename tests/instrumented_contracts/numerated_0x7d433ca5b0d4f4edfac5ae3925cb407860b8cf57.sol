1 pragma solidity ^0.6.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 pragma solidity ^0.6.0;
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
101 
102 
103 pragma solidity ^0.6.0;
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 
262 
263 
264 pragma solidity ^0.6.2;
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies in extcodesize, which returns 0 for contracts in
289         // construction, since the code is only stored at the end of the
290         // constructor execution.
291 
292         uint256 size;
293         // solhint-disable-next-line no-inline-assembly
294         assembly { size := extcodesize(account) }
295         return size > 0;
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
318         (bool success, ) = recipient.call{ value: amount }("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain`call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341       return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
351         return _functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but also transferring `value` wei to `target`.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least `value`.
361      * - the called Solidity function must be `payable`.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         return _functionCallWithValue(target, data, value, errorMessage);
378     }
379 
380     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
381         require(isContract(target), "Address: call to non-contract");
382 
383         // solhint-disable-next-line avoid-low-level-calls
384         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 // solhint-disable-next-line no-inline-assembly
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 
405 
406 
407 pragma solidity ^0.6.0;
408 
409 
410 
411 /**
412  * @dev Implementation of the {IERC20} interface.
413  *
414  * This implementation is agnostic to the way tokens are created. This means
415  * that a supply mechanism has to be added in a derived contract using {_mint}.
416  * For a generic mechanism see {ERC20PresetMinterPauser}.
417  *
418  * TIP: For a detailed writeup see our guide
419  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
420  * to implement supply mechanisms].
421  *
422  * We have followed general OpenZeppelin guidelines: functions revert instead
423  * of returning `false` on failure. This behavior is nonetheless conventional
424  * and does not conflict with the expectations of ERC20 applications.
425  *
426  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
427  * This allows applications to reconstruct the allowance for all accounts just
428  * by listening to said events. Other implementations of the EIP may not emit
429  * these events, as it isn't required by the specification.
430  *
431  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
432  * functions have been added to mitigate the well-known issues around setting
433  * allowances. See {IERC20-approve}.
434  */
435 contract ERC20 is Context, IERC20 {
436     using SafeMath for uint256;
437     using Address for address;
438 
439     mapping (address => uint256) private _balances;
440 
441     mapping (address => mapping (address => uint256)) private _allowances;
442 
443     uint256 private _totalSupply;
444 
445     string private _name;
446     string private _symbol;
447     uint8 private _decimals;
448 
449     /**
450      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
451      * a default value of 18.
452      *
453      * To select a different value for {decimals}, use {_setupDecimals}.
454      *
455      * All three of these values are immutable: they can only be set once during
456      * construction.
457      */
458     constructor (string memory name, string memory symbol) public {
459         _name = name;
460         _symbol = symbol;
461         _decimals = 18;
462     }
463 
464     /**
465      * @dev Returns the name of the token.
466      */
467     function name() public view returns (string memory) {
468         return _name;
469     }
470 
471     /**
472      * @dev Returns the symbol of the token, usually a shorter version of the
473      * name.
474      */
475     function symbol() public view returns (string memory) {
476         return _symbol;
477     }
478 
479     /**
480      * @dev Returns the number of decimals used to get its user representation.
481      * For example, if `decimals` equals `2`, a balance of `505` tokens should
482      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
483      *
484      * Tokens usually opt for a value of 18, imitating the relationship between
485      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
486      * called.
487      *
488      * NOTE: This information is only used for _display_ purposes: it in
489      * no way affects any of the arithmetic of the contract, including
490      * {IERC20-balanceOf} and {IERC20-transfer}.
491      */
492     function decimals() public view returns (uint8) {
493         return _decimals;
494     }
495 
496     /**
497      * @dev See {IERC20-totalSupply}.
498      */
499     function totalSupply() public view override returns (uint256) {
500         return _totalSupply;
501     }
502 
503     /**
504      * @dev See {IERC20-balanceOf}.
505      */
506     function balanceOf(address account) public view override returns (uint256) {
507         return _balances[account];
508     }
509 
510     /**
511      * @dev See {IERC20-transfer}.
512      *
513      * Requirements:
514      *
515      * - `recipient` cannot be the zero address.
516      * - the caller must have a balance of at least `amount`.
517      */
518     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
519         _transfer(_msgSender(), recipient, amount);
520         return true;
521     }
522 
523     /**
524      * @dev See {IERC20-allowance}.
525      */
526     function allowance(address owner, address spender) public view virtual override returns (uint256) {
527         return _allowances[owner][spender];
528     }
529 
530     /**
531      * @dev See {IERC20-approve}.
532      *
533      * Requirements:
534      *
535      * - `spender` cannot be the zero address.
536      */
537     function approve(address spender, uint256 amount) public virtual override returns (bool) {
538         _approve(_msgSender(), spender, amount);
539         return true;
540     }
541 
542     /**
543      * @dev See {IERC20-transferFrom}.
544      *
545      * Emits an {Approval} event indicating the updated allowance. This is not
546      * required by the EIP. See the note at the beginning of {ERC20};
547      *
548      * Requirements:
549      * - `sender` and `recipient` cannot be the zero address.
550      * - `sender` must have a balance of at least `amount`.
551      * - the caller must have allowance for ``sender``'s tokens of at least
552      * `amount`.
553      */
554     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
555         _transfer(sender, recipient, amount);
556         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
557         return true;
558     }
559 
560     /**
561      * @dev Atomically increases the allowance granted to `spender` by the caller.
562      *
563      * This is an alternative to {approve} that can be used as a mitigation for
564      * problems described in {IERC20-approve}.
565      *
566      * Emits an {Approval} event indicating the updated allowance.
567      *
568      * Requirements:
569      *
570      * - `spender` cannot be the zero address.
571      */
572     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
573         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
574         return true;
575     }
576 
577     /**
578      * @dev Atomically decreases the allowance granted to `spender` by the caller.
579      *
580      * This is an alternative to {approve} that can be used as a mitigation for
581      * problems described in {IERC20-approve}.
582      *
583      * Emits an {Approval} event indicating the updated allowance.
584      *
585      * Requirements:
586      *
587      * - `spender` cannot be the zero address.
588      * - `spender` must have allowance for the caller of at least
589      * `subtractedValue`.
590      */
591     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
592         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
593         return true;
594     }
595 
596     /**
597      * @dev Moves tokens `amount` from `sender` to `recipient`.
598      *
599      * This is internal function is equivalent to {transfer}, and can be used to
600      * e.g. implement automatic token fees, slashing mechanisms, etc.
601      *
602      * Emits a {Transfer} event.
603      *
604      * Requirements:
605      *
606      * - `sender` cannot be the zero address.
607      * - `recipient` cannot be the zero address.
608      * - `sender` must have a balance of at least `amount`.
609      */
610     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
611         require(sender != address(0), "ERC20: transfer from the zero address");
612         require(recipient != address(0), "ERC20: transfer to the zero address");
613 
614         _beforeTokenTransfer(sender, recipient, amount);
615 
616         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
617         _balances[recipient] = _balances[recipient].add(amount);
618         emit Transfer(sender, recipient, amount);
619     }
620 
621     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
622      * the total supply.
623      *
624      * Emits a {Transfer} event with `from` set to the zero address.
625      *
626      * Requirements
627      *
628      * - `to` cannot be the zero address.
629      */
630     function _mint(address account, uint256 amount) internal virtual {
631         require(account != address(0), "ERC20: mint to the zero address");
632 
633         _beforeTokenTransfer(address(0), account, amount);
634 
635         _totalSupply = _totalSupply.add(amount);
636         _balances[account] = _balances[account].add(amount);
637         emit Transfer(address(0), account, amount);
638     }
639 
640     /**
641      * @dev Destroys `amount` tokens from `account`, reducing the
642      * total supply.
643      *
644      * Emits a {Transfer} event with `to` set to the zero address.
645      *
646      * Requirements
647      *
648      * - `account` cannot be the zero address.
649      * - `account` must have at least `amount` tokens.
650      */
651     function _burn(address account, uint256 amount) internal virtual {
652         require(account != address(0), "ERC20: burn from the zero address");
653 
654         _beforeTokenTransfer(account, address(0), amount);
655 
656         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
657         _totalSupply = _totalSupply.sub(amount);
658         emit Transfer(account, address(0), amount);
659     }
660 
661     /**
662      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
663      *
664      * This internal function is equivalent to `approve`, and can be used to
665      * e.g. set automatic allowances for certain subsystems, etc.
666      *
667      * Emits an {Approval} event.
668      *
669      * Requirements:
670      *
671      * - `owner` cannot be the zero address.
672      * - `spender` cannot be the zero address.
673      */
674     function _approve(address owner, address spender, uint256 amount) internal virtual {
675         require(owner != address(0), "ERC20: approve from the zero address");
676         require(spender != address(0), "ERC20: approve to the zero address");
677 
678         _allowances[owner][spender] = amount;
679         emit Approval(owner, spender, amount);
680     }
681 
682     /**
683      * @dev Sets {decimals} to a value other than the default one of 18.
684      *
685      * WARNING: This function should only be called from the constructor. Most
686      * applications that interact with token contracts will not expect
687      * {decimals} to ever change, and may work incorrectly if it does.
688      */
689     function _setupDecimals(uint8 decimals_) internal {
690         _decimals = decimals_;
691     }
692 
693     /**
694      * @dev Hook that is called before any transfer of tokens. This includes
695      * minting and burning.
696      *
697      * Calling conditions:
698      *
699      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
700      * will be to transferred to `to`.
701      * - when `from` is zero, `amount` tokens will be minted for `to`.
702      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
703      * - `from` and `to` are never both zero.
704      *
705      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
706      */
707     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
708 }
709 
710 
711 pragma solidity ^0.6.0;
712 
713 
714 /**
715  * @dev Contract module which provides a basic access control mechanism, where
716  * there is an account (an owner) that can be granted exclusive access to
717  * specific functions.
718  *
719  * By default, the owner account will be the one that deploys the contract. This
720  * can later be changed with {transferOwnership}.
721  *
722  * This module is used through inheritance. It will make available the modifier
723  * `onlyOwner`, which can be applied to your functions to restrict their use to
724  * the owner.
725  */
726 contract Ownable is Context {
727     address private _owner;
728 
729     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
730 
731     /**
732      * @dev Initializes the contract setting the deployer as the initial owner.
733      */
734     constructor () internal {
735         address msgSender = _msgSender();
736         _owner = msgSender;
737         emit OwnershipTransferred(address(0), msgSender);
738     }
739 
740     /**
741      * @dev Returns the address of the current owner.
742      */
743     function owner() public view returns (address) {
744         return _owner;
745     }
746 
747     /**
748      * @dev Throws if called by any account other than the owner.
749      */
750     modifier onlyOwner() {
751         require(_owner == _msgSender(), "Ownable: caller is not the owner");
752         _;
753     }
754 
755     /**
756      * @dev Leaves the contract without owner. It will not be possible to call
757      * `onlyOwner` functions anymore. Can only be called by the current owner.
758      *
759      * NOTE: Renouncing ownership will leave the contract without an owner,
760      * thereby removing any functionality that is only available to the owner.
761      */
762     function renounceOwnership() public virtual onlyOwner {
763         emit OwnershipTransferred(_owner, address(0));
764         _owner = address(0);
765     }
766 
767     /**
768      * @dev Transfers ownership of the contract to a new account (`newOwner`).
769      * Can only be called by the current owner.
770      */
771     function transferOwnership(address newOwner) public virtual onlyOwner {
772         require(newOwner != address(0), "Ownable: new owner is the zero address");
773         emit OwnershipTransferred(_owner, newOwner);
774         _owner = newOwner;
775     }
776 }
777 
778 
779 pragma solidity 0.6.12;
780 
781 
782 
783 // OnigiriToken with Governance.
784 contract OnigiriToken is ERC20("OnigiriToken", "ONIGIRI"), Ownable {
785     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
786     function mint(address _to, uint256 _amount) public onlyOwner {
787         _mint(_to, _amount);
788         _moveDelegates(address(0), _delegates[_to], _amount);
789     }
790 
791     // Copied and modified from YAM code:
792     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
793     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
794     // Which is copied and modified from COMPOUND:
795     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
796 
797     /// @notice A record of each accounts delegate
798     mapping (address => address) internal _delegates;
799 
800     /// @notice A checkpoint for marking number of votes from a given block
801     struct Checkpoint {
802         uint32 fromBlock;
803         uint256 votes;
804     }
805 
806     /// @notice A record of votes checkpoints for each account, by index
807     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
808 
809     /// @notice The number of checkpoints for each account
810     mapping (address => uint32) public numCheckpoints;
811 
812     /// @notice The EIP-712 typehash for the contract's domain
813     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
814 
815     /// @notice The EIP-712 typehash for the delegation struct used by the contract
816     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
817 
818     /// @notice A record of states for signing / validating signatures
819     mapping (address => uint) public nonces;
820 
821       /// @notice An event thats emitted when an account changes its delegate
822     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
823 
824     /// @notice An event thats emitted when a delegate account's vote balance changes
825     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
826 
827     /**
828      * @notice Delegate votes from `msg.sender` to `delegatee`
829      * @param delegator The address to get delegatee for
830      */
831     function delegates(address delegator)
832         external
833         view
834         returns (address)
835     {
836         return _delegates[delegator];
837     }
838 
839    /**
840     * @notice Delegate votes from `msg.sender` to `delegatee`
841     * @param delegatee The address to delegate votes to
842     */
843     function delegate(address delegatee) external {
844         return _delegate(msg.sender, delegatee);
845     }
846 
847     /**
848      * @notice Delegates votes from signatory to `delegatee`
849      * @param delegatee The address to delegate votes to
850      * @param nonce The contract state required to match the signature
851      * @param expiry The time at which to expire the signature
852      * @param v The recovery byte of the signature
853      * @param r Half of the ECDSA signature pair
854      * @param s Half of the ECDSA signature pair
855      */
856     function delegateBySig(
857         address delegatee,
858         uint nonce,
859         uint expiry,
860         uint8 v,
861         bytes32 r,
862         bytes32 s
863     )
864         external
865     {
866         bytes32 domainSeparator = keccak256(
867             abi.encode(
868                 DOMAIN_TYPEHASH,
869                 keccak256(bytes(name())),
870                 getChainId(),
871                 address(this)
872             )
873         );
874 
875         bytes32 structHash = keccak256(
876             abi.encode(
877                 DELEGATION_TYPEHASH,
878                 delegatee,
879                 nonce,
880                 expiry
881             )
882         );
883 
884         bytes32 digest = keccak256(
885             abi.encodePacked(
886                 "\x19\x01",
887                 domainSeparator,
888                 structHash
889             )
890         );
891 
892         address signatory = ecrecover(digest, v, r, s);
893         require(signatory != address(0), "ONIGIRI::delegateBySig: invalid signature");
894         require(nonce == nonces[signatory]++, "ONIGIRI::delegateBySig: invalid nonce");
895         require(now <= expiry, "ONIGIRI::delegateBySig: signature expired");
896         return _delegate(signatory, delegatee);
897     }
898 
899     /**
900      * @notice Gets the current votes balance for `account`
901      * @param account The address to get votes balance
902      * @return The number of current votes for `account`
903      */
904     function getCurrentVotes(address account)
905         external
906         view
907         returns (uint256)
908     {
909         uint32 nCheckpoints = numCheckpoints[account];
910         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
911     }
912 
913     /**
914      * @notice Determine the prior number of votes for an account as of a block number
915      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
916      * @param account The address of the account to check
917      * @param blockNumber The block number to get the vote balance at
918      * @return The number of votes the account had as of the given block
919      */
920     function getPriorVotes(address account, uint blockNumber)
921         external
922         view
923         returns (uint256)
924     {
925         require(blockNumber < block.number, "ONIGIRI::getPriorVotes: not yet determined");
926 
927         uint32 nCheckpoints = numCheckpoints[account];
928         if (nCheckpoints == 0) {
929             return 0;
930         }
931 
932         // First check most recent balance
933         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
934             return checkpoints[account][nCheckpoints - 1].votes;
935         }
936 
937         // Next check implicit zero balance
938         if (checkpoints[account][0].fromBlock > blockNumber) {
939             return 0;
940         }
941 
942         uint32 lower = 0;
943         uint32 upper = nCheckpoints - 1;
944         while (upper > lower) {
945             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
946             Checkpoint memory cp = checkpoints[account][center];
947             if (cp.fromBlock == blockNumber) {
948                 return cp.votes;
949             } else if (cp.fromBlock < blockNumber) {
950                 lower = center;
951             } else {
952                 upper = center - 1;
953             }
954         }
955         return checkpoints[account][lower].votes;
956     }
957 
958     function _delegate(address delegator, address delegatee)
959         internal
960     {
961         address currentDelegate = _delegates[delegator];
962         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying ONIGIRIs (not scaled);
963         _delegates[delegator] = delegatee;
964 
965         emit DelegateChanged(delegator, currentDelegate, delegatee);
966 
967         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
968     }
969 
970     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
971         if (srcRep != dstRep && amount > 0) {
972             if (srcRep != address(0)) {
973                 // decrease old representative
974                 uint32 srcRepNum = numCheckpoints[srcRep];
975                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
976                 uint256 srcRepNew = srcRepOld.sub(amount);
977                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
978             }
979 
980             if (dstRep != address(0)) {
981                 // increase new representative
982                 uint32 dstRepNum = numCheckpoints[dstRep];
983                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
984                 uint256 dstRepNew = dstRepOld.add(amount);
985                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
986             }
987         }
988     }
989 
990     function _writeCheckpoint(
991         address delegatee,
992         uint32 nCheckpoints,
993         uint256 oldVotes,
994         uint256 newVotes
995     )
996         internal
997     {
998         uint32 blockNumber = safe32(block.number, "ONIGIRI::_writeCheckpoint: block number exceeds 32 bits");
999 
1000         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1001             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1002         } else {
1003             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1004             numCheckpoints[delegatee] = nCheckpoints + 1;
1005         }
1006 
1007         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1008     }
1009 
1010     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1011         require(n < 2**32, errorMessage);
1012         return uint32(n);
1013     }
1014 
1015     function getChainId() internal pure returns (uint) {
1016         uint256 chainId;
1017         assembly { chainId := chainid() }
1018         return chainId;
1019     }
1020 }
1021 
1022 pragma solidity ^0.6.0;
1023 
1024 /**
1025  * @dev Library for managing
1026  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1027  * types.
1028  *
1029  * Sets have the following properties:
1030  *
1031  * - Elements are added, removed, and checked for existence in constant time
1032  * (O(1)).
1033  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1034  *
1035  * ```
1036  * contract Example {
1037  *     // Add the library methods
1038  *     using EnumerableSet for EnumerableSet.AddressSet;
1039  *
1040  *     // Declare a set state variable
1041  *     EnumerableSet.AddressSet private mySet;
1042  * }
1043  * ```
1044  *
1045  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1046  * (`UintSet`) are supported.
1047  */
1048 library EnumerableSet {
1049     // To implement this library for multiple types with as little code
1050     // repetition as possible, we write it in terms of a generic Set type with
1051     // bytes32 values.
1052     // The Set implementation uses private functions, and user-facing
1053     // implementations (such as AddressSet) are just wrappers around the
1054     // underlying Set.
1055     // This means that we can only create new EnumerableSets for types that fit
1056     // in bytes32.
1057 
1058     struct Set {
1059         // Storage of set values
1060         bytes32[] _values;
1061 
1062         // Position of the value in the `values` array, plus 1 because index 0
1063         // means a value is not in the set.
1064         mapping (bytes32 => uint256) _indexes;
1065     }
1066 
1067     /**
1068      * @dev Add a value to a set. O(1).
1069      *
1070      * Returns true if the value was added to the set, that is if it was not
1071      * already present.
1072      */
1073     function _add(Set storage set, bytes32 value) private returns (bool) {
1074         if (!_contains(set, value)) {
1075             set._values.push(value);
1076             // The value is stored at length-1, but we add 1 to all indexes
1077             // and use 0 as a sentinel value
1078             set._indexes[value] = set._values.length;
1079             return true;
1080         } else {
1081             return false;
1082         }
1083     }
1084 
1085     /**
1086      * @dev Removes a value from a set. O(1).
1087      *
1088      * Returns true if the value was removed from the set, that is if it was
1089      * present.
1090      */
1091     function _remove(Set storage set, bytes32 value) private returns (bool) {
1092         // We read and store the value's index to prevent multiple reads from the same storage slot
1093         uint256 valueIndex = set._indexes[value];
1094 
1095         if (valueIndex != 0) { // Equivalent to contains(set, value)
1096             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1097             // the array, and then remove the last element (sometimes called as 'swap and pop').
1098             // This modifies the order of the array, as noted in {at}.
1099 
1100             uint256 toDeleteIndex = valueIndex - 1;
1101             uint256 lastIndex = set._values.length - 1;
1102 
1103             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1104             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1105 
1106             bytes32 lastvalue = set._values[lastIndex];
1107 
1108             // Move the last value to the index where the value to delete is
1109             set._values[toDeleteIndex] = lastvalue;
1110             // Update the index for the moved value
1111             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1112 
1113             // Delete the slot where the moved value was stored
1114             set._values.pop();
1115 
1116             // Delete the index for the deleted slot
1117             delete set._indexes[value];
1118 
1119             return true;
1120         } else {
1121             return false;
1122         }
1123     }
1124 
1125     /**
1126      * @dev Returns true if the value is in the set. O(1).
1127      */
1128     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1129         return set._indexes[value] != 0;
1130     }
1131 
1132     /**
1133      * @dev Returns the number of values on the set. O(1).
1134      */
1135     function _length(Set storage set) private view returns (uint256) {
1136         return set._values.length;
1137     }
1138 
1139    /**
1140     * @dev Returns the value stored at position `index` in the set. O(1).
1141     *
1142     * Note that there are no guarantees on the ordering of values inside the
1143     * array, and it may change when more values are added or removed.
1144     *
1145     * Requirements:
1146     *
1147     * - `index` must be strictly less than {length}.
1148     */
1149     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1150         require(set._values.length > index, "EnumerableSet: index out of bounds");
1151         return set._values[index];
1152     }
1153 
1154     // AddressSet
1155 
1156     struct AddressSet {
1157         Set _inner;
1158     }
1159 
1160     /**
1161      * @dev Add a value to a set. O(1).
1162      *
1163      * Returns true if the value was added to the set, that is if it was not
1164      * already present.
1165      */
1166     function add(AddressSet storage set, address value) internal returns (bool) {
1167         return _add(set._inner, bytes32(uint256(value)));
1168     }
1169 
1170     /**
1171      * @dev Removes a value from a set. O(1).
1172      *
1173      * Returns true if the value was removed from the set, that is if it was
1174      * present.
1175      */
1176     function remove(AddressSet storage set, address value) internal returns (bool) {
1177         return _remove(set._inner, bytes32(uint256(value)));
1178     }
1179 
1180     /**
1181      * @dev Returns true if the value is in the set. O(1).
1182      */
1183     function contains(AddressSet storage set, address value) internal view returns (bool) {
1184         return _contains(set._inner, bytes32(uint256(value)));
1185     }
1186 
1187     /**
1188      * @dev Returns the number of values in the set. O(1).
1189      */
1190     function length(AddressSet storage set) internal view returns (uint256) {
1191         return _length(set._inner);
1192     }
1193 
1194    /**
1195     * @dev Returns the value stored at position `index` in the set. O(1).
1196     *
1197     * Note that there are no guarantees on the ordering of values inside the
1198     * array, and it may change when more values are added or removed.
1199     *
1200     * Requirements:
1201     *
1202     * - `index` must be strictly less than {length}.
1203     */
1204     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1205         return address(uint256(_at(set._inner, index)));
1206     }
1207 
1208 
1209     // UintSet
1210 
1211     struct UintSet {
1212         Set _inner;
1213     }
1214 
1215     /**
1216      * @dev Add a value to a set. O(1).
1217      *
1218      * Returns true if the value was added to the set, that is if it was not
1219      * already present.
1220      */
1221     function add(UintSet storage set, uint256 value) internal returns (bool) {
1222         return _add(set._inner, bytes32(value));
1223     }
1224 
1225     /**
1226      * @dev Removes a value from a set. O(1).
1227      *
1228      * Returns true if the value was removed from the set, that is if it was
1229      * present.
1230      */
1231     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1232         return _remove(set._inner, bytes32(value));
1233     }
1234 
1235     /**
1236      * @dev Returns true if the value is in the set. O(1).
1237      */
1238     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1239         return _contains(set._inner, bytes32(value));
1240     }
1241 
1242     /**
1243      * @dev Returns the number of values on the set. O(1).
1244      */
1245     function length(UintSet storage set) internal view returns (uint256) {
1246         return _length(set._inner);
1247     }
1248 
1249    /**
1250     * @dev Returns the value stored at position `index` in the set. O(1).
1251     *
1252     * Note that there are no guarantees on the ordering of values inside the
1253     * array, and it may change when more values are added or removed.
1254     *
1255     * Requirements:
1256     *
1257     * - `index` must be strictly less than {length}.
1258     */
1259     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1260         return uint256(_at(set._inner, index));
1261     }
1262 }
1263 
1264 pragma solidity ^0.6.0;
1265 
1266 /**
1267  * @title SafeERC20
1268  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1269  * contract returns false). Tokens that return no value (and instead revert or
1270  * throw on failure) are also supported, non-reverting calls are assumed to be
1271  * successful.
1272  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1273  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1274  */
1275 library SafeERC20 {
1276     using SafeMath for uint256;
1277     using Address for address;
1278 
1279     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1280         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1281     }
1282 
1283     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1284         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1285     }
1286 
1287     /**
1288      * @dev Deprecated. This function has issues similar to the ones found in
1289      * {IERC20-approve}, and its usage is discouraged.
1290      *
1291      * Whenever possible, use {safeIncreaseAllowance} and
1292      * {safeDecreaseAllowance} instead.
1293      */
1294     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1295         // safeApprove should only be called when setting an initial allowance,
1296         // or when resetting it to zero. To increase and decrease it, use
1297         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1298         // solhint-disable-next-line max-line-length
1299         require((value == 0) || (token.allowance(address(this), spender) == 0),
1300             "SafeERC20: approve from non-zero to non-zero allowance"
1301         );
1302         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1303     }
1304 
1305     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1306         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1307         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1308     }
1309 
1310     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1311         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1312         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1313     }
1314 
1315     /**
1316      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1317      * on the return value: the return value is optional (but if data is returned, it must not be false).
1318      * @param token The token targeted by the call.
1319      * @param data The call data (encoded using abi.encode or one of its variants).
1320      */
1321     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1322         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1323         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1324         // the target address contains contract code and also asserts for success in the low-level call.
1325 
1326         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1327         if (returndata.length > 0) { // Return data is optional
1328             // solhint-disable-next-line max-line-length
1329             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1330         }
1331     }
1332 }
1333 
1334 
1335 pragma solidity 0.6.12;
1336 
1337 interface IMigratorChef {
1338     // Perform LP token migration from legacy UniswapV2 to OnigiriSwap.
1339     // Take the current LP token address and return the new LP token address.
1340     // Migrator should have full access to the caller's LP token.
1341     // Return the new LP token address.
1342     //
1343     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1344     // OnigiriSwap must mint EXACTLY the same amount of OnigiriSwap LP tokens or
1345     // else something bad will happen. Traditional UniswapV2 does not
1346     // do that so be careful!
1347     function migrate(IERC20 token) external returns (IERC20);
1348 }
1349 
1350 // MasterChef is the master of Onigiri. He can make Onigiri and he is a fair guy.
1351 //
1352 // Note that it's ownable and the owner wields tremendous power. The ownership
1353 // will be transferred to a governance smart contract once ONIGIRI is sufficiently
1354 // distributed and the community can show to govern itself.
1355 //
1356 // Have fun reading it. Hopefully it's bug-free. God bless.
1357 contract MasterChef is Ownable {
1358     using SafeMath for uint256;
1359     using SafeERC20 for IERC20;
1360 
1361     // Info of each user.
1362     struct UserInfo {
1363         uint256 amount;     // How many LP tokens the user has provided.
1364         uint256 rewardDebt; // Reward debt. See explanation below.
1365         //
1366         // We do some fancy math here. Basically, any point in time, the amount of ONIGIRIs
1367         // entitled to a user but is pending to be distributed is:
1368         //
1369         //   pending reward = (user.amount * pool.accOnigiriPerShare) - user.rewardDebt
1370         //
1371         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1372         //   1. The pool's `accOnigiriPerShare` (and `lastRewardBlock`) gets updated.
1373         //   2. User receives the pending reward sent to his/her address.
1374         //   3. User's `amount` gets updated.
1375         //   4. User's `rewardDebt` gets updated.
1376     }
1377 
1378     // Info of each pool.
1379     struct PoolInfo {
1380         IERC20 lpToken;           // Address of LP token contract.
1381         uint256 allocPoint;       // How many allocation points assigned to this pool. ONIGIRIs to distribute per block.
1382         uint256 lastRewardBlock;  // Last block number that ONIGIRIs distribution occurs.
1383         uint256 accOnigiriPerShare; // Accumulated ONIGIRIs per share, times 1e12. See below.
1384     }
1385 
1386     // The ONIGIRI TOKEN!
1387     OnigiriToken public onigiri;
1388     // Dev address.
1389     address public devaddr;
1390     // Bonus muliplier for early onigiri makers.
1391     uint256 public constant BONUS_MULTIPLIER = 4;
1392     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1393     IMigratorChef public migrator;
1394 
1395     // Info of each pool.
1396     PoolInfo[] public poolInfo;
1397     // Info of each user that stakes LP tokens.
1398     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1399     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1400     uint256 public totalAllocPoint = 0;
1401     // The block number when ONIGIRI mining starts.
1402     uint256 public startBlock;
1403 
1404     uint256 public constant INITIAL_ONIGIRI_PER_BLOCK = 20e18; // 20 per block
1405     uint256 public constant HALVING_PERIOD = 100_000; // 100000 block (around 2 weeks)
1406 
1407     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1408     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1409     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1410 
1411     constructor(
1412         OnigiriToken _onigiri,
1413         address _devaddr,
1414         uint256 _startBlock
1415     ) public {
1416         onigiri = _onigiri;
1417         devaddr = _devaddr;
1418         startBlock = _startBlock;
1419     }
1420 
1421     function poolLength() external view returns (uint256) {
1422         return poolInfo.length;
1423     }
1424 
1425     // Add a new lp to the pool. Can only be called by the owner.
1426     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1427     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1428         if (_withUpdate) {
1429             massUpdatePools();
1430         }
1431         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1432         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1433         poolInfo.push(PoolInfo({
1434             lpToken: _lpToken,
1435             allocPoint: _allocPoint,
1436             lastRewardBlock: lastRewardBlock,
1437             accOnigiriPerShare: 0
1438         }));
1439     }
1440 
1441     // Update the given pool's ONIGIRI allocation point. Can only be called by the owner.
1442     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1443         if (_withUpdate) {
1444             massUpdatePools();
1445         }
1446         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1447         poolInfo[_pid].allocPoint = _allocPoint;
1448     }
1449 
1450     // Set the migrator contract. Can only be called by the owner.
1451     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1452         migrator = _migrator;
1453     }
1454 
1455     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1456     function migrate(uint256 _pid) public {
1457         require(address(migrator) != address(0), "migrate: no migrator");
1458         PoolInfo storage pool = poolInfo[_pid];
1459         IERC20 lpToken = pool.lpToken;
1460         uint256 bal = lpToken.balanceOf(address(this));
1461         lpToken.safeApprove(address(migrator), bal);
1462         IERC20 newLpToken = migrator.migrate(lpToken);
1463         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1464         pool.lpToken = newLpToken;
1465     }
1466 
1467     // Return total reward of Onigiri over the given _from to _to block.
1468     // Suppose the difference can only be at maximum 1 epoch (2 weeks)
1469     function getRewardDuringPeriod(uint256 _from, uint256 _to) public view returns (uint256) {
1470         uint256 epoch_from = _from.sub(startBlock).div(HALVING_PERIOD);
1471         uint256 epoch_to = _to.sub(startBlock).div(HALVING_PERIOD);
1472 
1473         if (epoch_from == epoch_to) {
1474             return _to.sub(_from).mul(getRewardPerBlock(_from));
1475         } else {
1476             uint256 boundary = HALVING_PERIOD.mul(epoch_to).add(startBlock);
1477             uint256 first = boundary.sub(_from).mul(getRewardPerBlock(_from));
1478             uint256 second = _to.sub(boundary).mul(getRewardPerBlock(_to));
1479             return first.add(second);
1480         }
1481     }
1482 
1483     // Return Onigiri reward of a given block height
1484     function getRewardPerBlock(uint256 blockIndex) private view returns (uint256) {
1485         uint256 epoch = blockIndex.sub(startBlock).div(HALVING_PERIOD);
1486         if (epoch == 0) {
1487             return INITIAL_ONIGIRI_PER_BLOCK * BONUS_MULTIPLIER; // 80
1488         } else if (epoch == 1) {
1489             return INITIAL_ONIGIRI_PER_BLOCK * BONUS_MULTIPLIER; // 80
1490         } else if (epoch == 2) {
1491             return INITIAL_ONIGIRI_PER_BLOCK; // 20
1492         } else if (epoch == 3) {
1493             return INITIAL_ONIGIRI_PER_BLOCK / 2; // 10
1494         } else if (epoch == 4) {
1495             return INITIAL_ONIGIRI_PER_BLOCK / 4; // 5
1496         } else if (epoch == 5) {
1497             return INITIAL_ONIGIRI_PER_BLOCK / 8; // 2.5
1498         } else if (epoch == 6) {
1499             return INITIAL_ONIGIRI_PER_BLOCK / 16; // 1.25
1500         } else if (epoch == 7) {
1501             return INITIAL_ONIGIRI_PER_BLOCK / 32; // 0.625
1502         } else {
1503             return INITIAL_ONIGIRI_PER_BLOCK / 64; // 0.3125
1504         }
1505     }
1506 
1507     // View function to see pending ONIGIRIs on frontend.
1508     function pendingOnigiri(uint256 _pid, address _user) external view returns (uint256) {
1509         PoolInfo storage pool = poolInfo[_pid];
1510         UserInfo storage user = userInfo[_pid][_user];
1511         uint256 accOnigiriPerShare = pool.accOnigiriPerShare;
1512         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1513         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1514             uint256 totalOnigiriReward = getRewardDuringPeriod(pool.lastRewardBlock, block.number);
1515             uint256 onigiriReward = totalOnigiriReward.mul(pool.allocPoint).div(totalAllocPoint);
1516             accOnigiriPerShare = accOnigiriPerShare.add(onigiriReward.mul(1e12).div(lpSupply));
1517         }
1518         return user.amount.mul(accOnigiriPerShare).div(1e12).sub(user.rewardDebt);
1519     }
1520 
1521     // Update reward variables for all pools. Be careful of gas spending!
1522     function massUpdatePools() public {
1523         uint256 length = poolInfo.length;
1524         for (uint256 pid = 0; pid < length; ++pid) {
1525             updatePool(pid);
1526         }
1527     }
1528 
1529     // Update reward variables of the given pool to be up-to-date.
1530     function updatePool(uint256 _pid) public {
1531         PoolInfo storage pool = poolInfo[_pid];
1532         if (block.number <= pool.lastRewardBlock) {
1533             return;
1534         }
1535         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1536         if (lpSupply == 0) {
1537             pool.lastRewardBlock = block.number;
1538             return;
1539         }
1540         uint256 totalOnigiriReward = getRewardDuringPeriod(pool.lastRewardBlock, block.number);
1541         uint256 onigiriReward = totalOnigiriReward.mul(pool.allocPoint).div(totalAllocPoint);
1542         uint currentBlockNumber = block.number;
1543         uint256 epoch = currentBlockNumber.sub(startBlock).div(HALVING_PERIOD);
1544         if (epoch <= 1) {
1545             onigiri.mint(devaddr, onigiriReward.div(15));
1546         } else {
1547             onigiri.mint(devaddr, onigiriReward.div(30));
1548         }
1549         onigiri.mint(address(this), onigiriReward);
1550         pool.accOnigiriPerShare = pool.accOnigiriPerShare.add(onigiriReward.mul(1e12).div(lpSupply));
1551         pool.lastRewardBlock = block.number;
1552     }
1553 
1554     // Deposit LP tokens to MasterChef for ONIGIRI allocation.
1555     function deposit(uint256 _pid, uint256 _amount) public {
1556         PoolInfo storage pool = poolInfo[_pid];
1557         UserInfo storage user = userInfo[_pid][msg.sender];
1558         updatePool(_pid);
1559         if (user.amount > 0) {
1560             uint256 pending = user.amount.mul(pool.accOnigiriPerShare).div(1e12).sub(user.rewardDebt);
1561             if(pending > 0) {
1562                 safeOnigiriTransfer(msg.sender, pending);
1563             }
1564         }
1565         if(_amount > 0) {
1566             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1567             user.amount = user.amount.add(_amount);
1568         }
1569         user.rewardDebt = user.amount.mul(pool.accOnigiriPerShare).div(1e12);
1570         emit Deposit(msg.sender, _pid, _amount);
1571     }
1572 
1573     // Withdraw LP tokens from MasterChef.
1574     function withdraw(uint256 _pid, uint256 _amount) public {
1575         PoolInfo storage pool = poolInfo[_pid];
1576         UserInfo storage user = userInfo[_pid][msg.sender];
1577         require(user.amount >= _amount, "withdraw: not good");
1578         updatePool(_pid);
1579         uint256 pending = user.amount.mul(pool.accOnigiriPerShare).div(1e12).sub(user.rewardDebt);
1580         if(pending > 0) {
1581             safeOnigiriTransfer(msg.sender, pending);
1582         }
1583         if(_amount > 0) {
1584             user.amount = user.amount.sub(_amount);
1585             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1586         }
1587         user.rewardDebt = user.amount.mul(pool.accOnigiriPerShare).div(1e12);
1588         emit Withdraw(msg.sender, _pid, _amount);
1589     }
1590 
1591     // Withdraw without caring about rewards. EMERGENCY ONLY.
1592     function emergencyWithdraw(uint256 _pid) public {
1593         PoolInfo storage pool = poolInfo[_pid];
1594         UserInfo storage user = userInfo[_pid][msg.sender];
1595         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1596         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1597         user.amount = 0;
1598         user.rewardDebt = 0;
1599     }
1600 
1601     // Safe onigiri transfer function, just in case if rounding error causes pool to not have enough ONIGIRIs.
1602     function safeOnigiriTransfer(address _to, uint256 _amount) internal {
1603         uint256 onigiriBal = onigiri.balanceOf(address(this));
1604         if (_amount > onigiriBal) {
1605             onigiri.transfer(_to, onigiriBal);
1606         } else {
1607             onigiri.transfer(_to, _amount);
1608         }
1609     }
1610 
1611     // Update dev address by the previous dev.
1612     function dev(address _devaddr) public {
1613         require(msg.sender == devaddr, "dev: wut?");
1614         devaddr = _devaddr;
1615     }
1616 }