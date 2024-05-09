1 /**
2 UniLend Finance Token (UFT)
3 */
4 
5 pragma solidity 0.6.2;
6 
7 
8 // SPDX-License-Identifier: MIT
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
30 // SPDX-License-Identifier: MIT
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 // SPDX-License-Identifier: MIT
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      *
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      *
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 // SPDX-License-Identifier: MIT
263 /**
264  * @dev Collection of functions related to the address type
265  */
266 library Address {
267     /**
268      * @dev Returns true if `account` is a contract.
269      *
270      * [IMPORTANT]
271      * ====
272      * It is unsafe to assume that an address for which this function returns
273      * false is an externally-owned account (EOA) and not a contract.
274      *
275      * Among others, `isContract` will return false for the following
276      * types of addresses:
277      *
278      *  - an externally-owned account
279      *  - a contract in construction
280      *  - an address where a contract will be created
281      *  - an address where a contract lived, but was destroyed
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // This method relies in extcodesize, which returns 0 for contracts in
286         // construction, since the code is only stored at the end of the
287         // constructor execution.
288 
289         uint256 size;
290         // solhint-disable-next-line no-inline-assembly
291         assembly { size := extcodesize(account) }
292         return size > 0;
293     }
294 
295     /**
296      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297      * `recipient`, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by `transfer`, making them unable to receive funds via
302      * `transfer`. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to `recipient`, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
315         (bool success, ) = recipient.call{ value: amount }("");
316         require(success, "Address: unable to send value, recipient may have reverted");
317     }
318 
319     /**
320      * @dev Performs a Solidity function call using a low level `call`. A
321      * plain`call` is an unsafe replacement for a function call: use this
322      * function instead.
323      *
324      * If `target` reverts with a revert reason, it is bubbled up by this
325      * function (like regular Solidity function calls).
326      *
327      * Returns the raw returned data. To convert to the expected return value,
328      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
329      *
330      * Requirements:
331      *
332      * - `target` must be a contract.
333      * - calling `target` with `data` must not revert.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
338       return functionCall(target, data, "Address: low-level call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
343      * `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
348         return _functionCallWithValue(target, data, 0, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but also transferring `value` wei to `target`.
354      *
355      * Requirements:
356      *
357      * - the calling contract must have an ETH balance of at least `value`.
358      * - the called Solidity function must be `payable`.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
368      * with `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         return _functionCallWithValue(target, data, value, errorMessage);
375     }
376 
377     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
378         require(isContract(target), "Address: call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 // solhint-disable-next-line no-inline-assembly
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 contract ERC20 is Context, IERC20 {
402     using SafeMath for uint256;
403     using Address for address;
404 
405     mapping (address => uint256) private _balances;
406 
407     mapping (address => mapping (address => uint256)) private _allowances;
408 
409     uint256 private _totalSupply;
410 
411     string private _name;
412     string private _symbol;
413     uint8 private _decimals;
414 
415     /**
416      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
417      * a default value of 18.
418      *
419      * To select a different value for {decimals}, use {_setupDecimals}.
420      *
421      * All three of these values are immutable: they can only be set once during
422      * construction.
423      */
424     constructor (string memory name, string memory symbol) public {
425         _name = name;
426         _symbol = symbol;
427         _decimals = 18;
428     }
429 
430     /**
431      * @dev Returns the name of the token.
432      */
433     function name() public view returns (string memory) {
434         return _name;
435     }
436 
437     /**
438      * @dev Returns the symbol of the token, usually a shorter version of the
439      * name.
440      */
441     function symbol() public view returns (string memory) {
442         return _symbol;
443     }
444 
445     /**
446      * @dev Returns the number of decimals used to get its user representation.
447      * For example, if `decimals` equals `2`, a balance of `505` tokens should
448      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
449      *
450      * Tokens usually opt for a value of 18, imitating the relationship between
451      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
452      * called.
453      *
454      * NOTE: This information is only used for _display_ purposes: it in
455      * no way affects any of the arithmetic of the contract, including
456      * {IERC20-balanceOf} and {IERC20-transfer}.
457      */
458     function decimals() public view returns (uint8) {
459         return _decimals;
460     }
461 
462     /**
463      * @dev See {IERC20-totalSupply}.
464      */
465     function totalSupply() public view override returns (uint256) {
466         return _totalSupply;
467     }
468 
469     /**
470      * @dev See {IERC20-balanceOf}.
471      */
472     function balanceOf(address account) public view override returns (uint256) {
473         return _balances[account];
474     }
475 
476     /**
477      * @dev See {IERC20-transfer}.
478      *
479      * Requirements:
480      *
481      * - `recipient` cannot be the zero address.
482      * - the caller must have a balance of at least `amount`.
483      */
484     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
485         _transfer(_msgSender(), recipient, amount);
486         return true;
487     }
488 
489     /**
490      * @dev See {IERC20-allowance}.
491      */
492     function allowance(address owner, address spender) public view virtual override returns (uint256) {
493         return _allowances[owner][spender];
494     }
495 
496     /**
497      * @dev See {IERC20-approve}.
498      *
499      * Requirements:
500      *
501      * - `spender` cannot be the zero address.
502      */
503     function approve(address spender, uint256 amount) public virtual override returns (bool) {
504         _approve(_msgSender(), spender, amount);
505         return true;
506     }
507 
508     /**
509      * @dev See {IERC20-transferFrom}.
510      *
511      * Emits an {Approval} event indicating the updated allowance. This is not
512      * required by the EIP. See the note at the beginning of {ERC20};
513      *
514      * Requirements:
515      * - `sender` and `recipient` cannot be the zero address.
516      * - `sender` must have a balance of at least `amount`.
517      * - the caller must have allowance for ``sender``'s tokens of at least
518      * `amount`.
519      */
520     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
521         _transfer(sender, recipient, amount);
522         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
523         return true;
524     }
525 
526     /**
527      * @dev Atomically increases the allowance granted to `spender` by the caller.
528      *
529      * This is an alternative to {approve} that can be used as a mitigation for
530      * problems described in {IERC20-approve}.
531      *
532      * Emits an {Approval} event indicating the updated allowance.
533      *
534      * Requirements:
535      *
536      * - `spender` cannot be the zero address.
537      */
538     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
539         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
540         return true;
541     }
542 
543     /**
544      * @dev Atomically decreases the allowance granted to `spender` by the caller.
545      *
546      * This is an alternative to {approve} that can be used as a mitigation for
547      * problems described in {IERC20-approve}.
548      *
549      * Emits an {Approval} event indicating the updated allowance.
550      *
551      * Requirements:
552      *
553      * - `spender` cannot be the zero address.
554      * - `spender` must have allowance for the caller of at least
555      * `subtractedValue`.
556      */
557     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
558         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
559         return true;
560     }
561 
562     /**
563      * @dev Moves tokens `amount` from `sender` to `recipient`.
564      *
565      * This is internal function is equivalent to {transfer}, and can be used to
566      * e.g. implement automatic token fees, slashing mechanisms, etc.
567      *
568      * Emits a {Transfer} event.
569      *
570      * Requirements:
571      *
572      * - `sender` cannot be the zero address.
573      * - `recipient` cannot be the zero address.
574      * - `sender` must have a balance of at least `amount`.
575      */
576     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
577         require(sender != address(0), "ERC20: transfer from the zero address");
578         require(recipient != address(0), "ERC20: transfer to the zero address");
579 
580         _beforeTokenTransfer(sender, recipient, amount);
581 
582         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
583         _balances[recipient] = _balances[recipient].add(amount);
584         emit Transfer(sender, recipient, amount);
585     }
586 
587     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
588      * the total supply.
589      *
590      * Emits a {Transfer} event with `from` set to the zero address.
591      *
592      * Requirements
593      *
594      * - `to` cannot be the zero address.
595      */
596     function _mint(address account, uint256 amount) internal virtual {
597         require(account != address(0), "ERC20: mint to the zero address");
598 
599         _beforeTokenTransfer(address(0), account, amount);
600 
601         _totalSupply = _totalSupply.add(amount);
602         _balances[account] = _balances[account].add(amount);
603         emit Transfer(address(0), account, amount);
604     }
605 
606     /**
607      * @dev Destroys `amount` tokens from `account`, reducing the
608      * total supply.
609      *
610      * Emits a {Transfer} event with `to` set to the zero address.
611      *
612      * Requirements
613      *
614      * - `account` cannot be the zero address.
615      * - `account` must have at least `amount` tokens.
616      */
617     function _burn(address account, uint256 amount) internal virtual {
618         require(account != address(0), "ERC20: burn from the zero address");
619 
620         _beforeTokenTransfer(account, address(0), amount);
621 
622         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
623         _totalSupply = _totalSupply.sub(amount);
624         emit Transfer(account, address(0), amount);
625     }
626 
627     /**
628      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
629      *
630      * This internal function is equivalent to `approve`, and can be used to
631      * e.g. set automatic allowances for certain subsystems, etc.
632      *
633      * Emits an {Approval} event.
634      *
635      * Requirements:
636      *
637      * - `owner` cannot be the zero address.
638      * - `spender` cannot be the zero address.
639      */
640     function _approve(address owner, address spender, uint256 amount) internal virtual {
641         require(owner != address(0), "ERC20: approve from the zero address");
642         require(spender != address(0), "ERC20: approve to the zero address");
643 
644         _allowances[owner][spender] = amount;
645         emit Approval(owner, spender, amount);
646     }
647 
648     /**
649      * @dev Sets {decimals} to a value other than the default one of 18.
650      *
651      * WARNING: This function should only be called from the constructor. Most
652      * applications that interact with token contracts will not expect
653      * {decimals} to ever change, and may work incorrectly if it does.
654      */
655     function _setupDecimals(uint8 decimals_) internal {
656         _decimals = decimals_;
657     }
658 
659     /**
660      * @dev Hook that is called before any transfer of tokens. This includes
661      * minting and burning.
662      *
663      * Calling conditions:
664      *
665      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
666      * will be to transferred to `to`.
667      * - when `from` is zero, `amount` tokens will be minted for `to`.
668      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
669      * - `from` and `to` are never both zero.
670      *
671      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
672      */
673     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
674 }
675 
676 contract Ownable is Context {
677     address private _owner;
678 
679     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
680 
681     /**
682      * @dev Initializes the contract setting the deployer as the initial owner.
683      */
684     constructor () internal {
685         address msgSender = _msgSender();
686         _owner = msgSender;
687         emit OwnershipTransferred(address(0), msgSender);
688     }
689 
690     /**
691      * @dev Returns the address of the current owner.
692      */
693     function owner() public view returns (address) {
694         return _owner;
695     }
696 
697     /**
698      * @dev Throws if called by any account other than the owner.
699      */
700     modifier onlyOwner() {
701         require(_owner == _msgSender(), "Ownable: caller is not the owner");
702         _;
703     }
704 
705     /**
706      * @dev Leaves the contract without owner. It will not be possible to call
707      * `onlyOwner` functions anymore. Can only be called by the current owner.
708      *
709      * NOTE: Renouncing ownership will leave the contract without an owner,
710      * thereby removing any functionality that is only available to the owner.
711      */
712     function renounceOwnership() public virtual onlyOwner {
713         emit OwnershipTransferred(_owner, address(0));
714         _owner = address(0);
715     }
716 
717     /**
718      * @dev Transfers ownership of the contract to a new account (`newOwner`).
719      * Can only be called by the current owner.
720      */
721     function transferOwnership(address newOwner) public virtual onlyOwner {
722         require(newOwner != address(0), "Ownable: new owner is the zero address");
723         emit OwnershipTransferred(_owner, newOwner);
724         _owner = newOwner;
725     }
726 }
727 
728 library Counters {
729     using SafeMath for uint256;
730 
731     struct Counter {
732         // This variable should never be directly accessed by users of the library: interactions must be restricted to
733         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
734         // this feature: see https://github.com/ethereum/solidity/issues/4637
735         uint256 _value; // default: 0
736     }
737 
738     function current(Counter storage counter) internal view returns (uint256) {
739         return counter._value;
740     }
741 
742     function increment(Counter storage counter) internal {
743         // The {SafeMath} overflow check can be skipped here, see the comment at the top
744         counter._value += 1;
745     }
746 
747     function decrement(Counter storage counter) internal {
748         counter._value = counter._value.sub(1);
749     }
750 }
751 
752 /**
753  * @dev Interface of the ERC2612 standard as defined in the EIP.
754  *
755  * Adds the {permit} method, which can be used to change one's
756  * {IERC20-allowance} without having to send a transaction, by signing a
757  * message. This allows users to spend tokens without having to hold Ether.
758  *
759  * See https://eips.ethereum.org/EIPS/eip-2612.
760  */
761 interface IERC2612Permit {
762     /**
763      * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
764      * given `owner`'s signed approval.
765      *
766      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
767      * ordering also apply here.
768      *
769      * Emits an {Approval} event.
770      *
771      * Requirements:
772      *
773      * - `owner` cannot be the zero address.
774      * - `spender` cannot be the zero address.
775      * - `deadline` must be a timestamp in the future.
776      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
777      * over the EIP712-formatted function arguments.
778      * - the signature must use ``owner``'s current nonce (see {nonces}).
779      *
780      * For more information on the signature format, see the
781      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
782      * section].
783      */
784     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
785 
786     /**
787      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
788      * included whenever a signature is generated for {permit}.
789      *
790      * Every successful call to {permit} increases ``owner``'s nonce by one. This
791      * prevents a signature from being used multiple times.
792      */
793     function nonces(address owner) external view returns (uint256);
794 }
795 
796 abstract contract ERC20Permit is ERC20, IERC2612Permit {
797     using Counters for Counters.Counter;
798 
799     mapping (address => Counters.Counter) private _nonces;
800 
801     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
802     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
803 
804     bytes32 public DOMAIN_SEPARATOR;
805 
806     constructor() internal {
807         uint256 chainID;
808         assembly {
809             chainID := chainid()
810         }
811 
812         DOMAIN_SEPARATOR = keccak256(
813             abi.encode(
814                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
815                 keccak256(bytes(name())),
816                 keccak256(bytes("1")), // Version
817                 chainID,
818                 address(this)
819             )
820         );
821     }
822 
823     /**
824      * @dev See {IERC2612Permit-permit}.
825      *
826      */
827     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
828         require(block.timestamp <= deadline, "UnilendPermit: expired deadline");
829 
830         bytes32 hashStruct = keccak256(
831             abi.encode(
832                 PERMIT_TYPEHASH,
833                 owner,
834                 spender,
835                 amount,
836                 _nonces[owner].current(),
837                 deadline
838             )
839         );
840 
841         bytes32 _hash = keccak256(
842             abi.encodePacked(
843                 uint16(0x1901),
844                 DOMAIN_SEPARATOR,
845                 hashStruct
846             )
847         );
848 
849         address signer = ecrecover(_hash, v, r, s);
850         require(signer != address(0) && signer == owner, "UnilendPermit: Invalid signature");
851 
852         _nonces[owner].increment();
853         _approve(owner, spender, amount);
854     }
855 
856     /**
857      * @dev See {IERC2612Permit-nonces}.
858      */
859     function nonces(address owner) public view override returns (uint256) {
860         return _nonces[owner].current();
861     }
862 }
863 
864 /**
865  * @title UniLendToken
866  * @dev UniLend ERC20 Token
867  */
868 contract UniLendToken is ERC20Permit,  Ownable {
869     constructor (string memory name, string memory symbol, uint256 totalSupply)
870     public
871     ERC20 (name, symbol) {
872         _mint(msg.sender, totalSupply);
873     }
874 
875     /**
876      * @notice Function to rescue funds
877      * Owner is assumed to be governance or UFT trusted party to helping users
878      * Funtion can be disabled by destroying ownership via `renounceOwnership` function
879      * @param token Address of token to be rescued
880      * @param destination User address
881      * @param amount Amount of tokens
882      */
883     function rescueTokens(address token, address destination, uint256 amount) external onlyOwner {
884         require(token != destination, "Invalid address");
885         require(ERC20(token).transfer(destination, amount), "Retrieve failed");
886     }
887 }