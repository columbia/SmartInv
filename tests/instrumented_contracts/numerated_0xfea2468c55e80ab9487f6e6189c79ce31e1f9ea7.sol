1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 
4 pragma solidity ^0.6.0;
5 
6 /*
7  * Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
28 
29 pragma solidity ^0.6.0;
30 
31 /**
32  * Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * Sets `amount` as the allowance of `spender` over the caller's tokens.
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
80      * Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89     
90     function decimals() external view returns (uint8);
91 
92     /**
93      * Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 // File: @openzeppelin/contracts/math/SafeMath.sol
108 
109 pragma solidity ^0.6.0;
110 
111 /**
112  * Wrappers over Solidity's arithmetic operations with added overflow
113  * checks.
114  *
115  * Arithmetic operations in Solidity wrap on overflow. This can easily result
116  * in bugs, because programmers usually assume that an overflow raises an
117  * error, which is the standard behavior in high level programming languages.
118  * `SafeMath` restores this intuition by reverting the transaction when an
119  * operation overflows.
120  *
121  * Using this library instead of the unchecked operations eliminates an entire
122  * class of bugs, so it's recommended to use it always.
123  */
124 library SafeMath {
125     /**
126      * Returns the addition of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `+` operator.
130      *
131      * Requirements:
132      *
133      * - Addition cannot overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141 
142     /**
143      * Returns the subtraction of two unsigned integers, reverting on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         return sub(a, b, "SafeMath: subtraction overflow");
154     }
155 
156     /**
157      * Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      *
181      * - Multiplication cannot overflow.
182      */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196 
197     /**
198      * Returns the integer division of two unsigned integers. Reverts on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b > 0, errorMessage);
227         uint256 c = a / b;
228         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230         return c;
231     }
232 
233     /**
234      * Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         return mod(a, b, "SafeMath: modulo by zero");
247     }
248 
249     /**
250      * Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts with custom message when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b != 0, errorMessage);
263         return a % b;
264     }
265 }
266 
267 // File: @openzeppelin/contracts/utils/Address.sol
268 
269 pragma solidity ^0.6.2;
270 
271 /**
272  * Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      * Returns true if `account` is a contract.
277      *
278      * [IMPORTANT]
279      * ====
280      * It is unsafe to assume that an address for which this function returns
281      * false is an externally-owned account (EOA) and not a contract.
282      *
283      * Among others, `isContract` will return false for the following
284      * types of addresses:
285      *
286      *  - an externally-owned account
287      *  - a contract in construction
288      *  - an address where a contract will be created
289      *  - an address where a contract lived, but was destroyed
290      * ====
291      */
292     function isContract(address account) internal view returns (bool) {
293         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
294         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
295         // for accounts without code, i.e. `keccak256('')`
296         bytes32 codehash;
297         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
298         // solhint-disable-next-line no-inline-assembly
299         assembly { codehash := extcodehash(account) }
300         return (codehash != accountHash && codehash != 0x0);
301     }
302 
303     /**
304      * Replacement for Solidity's `transfer`: sends `amount` wei to
305      * `recipient`, forwarding all available gas and reverting on errors.
306      *
307      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308      * of certain opcodes, possibly making contracts go over the 2300 gas limit
309      * imposed by `transfer`, making them unable to receive funds via
310      * `transfer`. {sendValue} removes this limitation.
311      *
312      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313      *
314      * IMPORTANT: because control is transferred to `recipient`, care must be
315      * taken to not create reentrancy vulnerabilities. Consider using
316      * {ReentrancyGuard} or the
317      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318      */
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(address(this).balance >= amount, "Address: insufficient balance");
321 
322         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
323         (bool success, ) = recipient.call{ value: amount }("");
324         require(success, "Address: unable to send value, recipient may have reverted");
325     }
326 
327     /**
328      * Performs a Solidity function call using a low level `call`. A
329      * plain`call` is an unsafe replacement for a function call: use this
330      * function instead.
331      *
332      * If `target` reverts with a revert reason, it is bubbled up by this
333      * function (like regular Solidity function calls).
334      *
335      * Returns the raw returned data. To convert to the expected return value,
336      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
337      *
338      * Requirements:
339      *
340      * - `target` must be a contract.
341      * - calling `target` with `data` must not revert.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
346       return functionCall(target, data, "Address: low-level call failed");
347     }
348 
349     /**
350      * Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
351      * `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
356         return _functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
372     }
373 
374     /**
375      * Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
376      * with `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
381         require(address(this).balance >= value, "Address: insufficient balance for call");
382         return _functionCallWithValue(target, data, value, errorMessage);
383     }
384 
385     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
386         require(isContract(target), "Address: call to non-contract");
387 
388         // solhint-disable-next-line avoid-low-level-calls
389         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 // solhint-disable-next-line no-inline-assembly
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
410 
411 pragma solidity ^0.6.0;
412 
413 /**
414  * Implementation of the {IERC20} interface.
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
452      * Sets the values for {name} and {symbol}, initializes {decimals} with
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
467      * Returns the name of the token.
468      */
469     function name() public view returns (string memory) {
470         return _name;
471     }
472 
473     /**
474      * Returns the symbol of the token, usually a shorter version of the
475      * name.
476      */
477     function symbol() public view returns (string memory) {
478         return _symbol;
479     }
480 
481     /**
482      * Returns the number of decimals used to get its user representation.
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
494     function decimals() public view override returns (uint8) {
495         return _decimals;
496     }
497 
498     /**
499      * See {IERC20-totalSupply}.
500      */
501     function totalSupply() public view override returns (uint256) {
502         return _totalSupply;
503     }
504 
505     /**
506      * See {IERC20-balanceOf}.
507      */
508     function balanceOf(address account) public view override returns (uint256) {
509         return _balances[account];
510     }
511 
512     /**
513      * See {IERC20-transfer}.
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
526      * See {IERC20-allowance}.
527      */
528     function allowance(address owner, address spender) public view virtual override returns (uint256) {
529         return _allowances[owner][spender];
530     }
531 
532     /**
533      * See {IERC20-approve}.
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
545      * See {IERC20-transferFrom}.
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
563      * Atomically increases the allowance granted to `spender` by the caller.
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
580      * Atomically decreases the allowance granted to `spender` by the caller.
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
599      * Moves tokens `amount` from `sender` to `recipient`.
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
616         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
617         _balances[recipient] = _balances[recipient].add(amount);
618         emit Transfer(sender, recipient, amount);
619     }
620 
621     /** Creates `amount` tokens and assigns them to `account`, increasing
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
633         _totalSupply = _totalSupply.add(amount);
634         _balances[account] = _balances[account].add(amount);
635         emit Transfer(address(0), account, amount);
636     }
637 
638     /**
639      * Destroys `amount` tokens from `account`, reducing the
640      * total supply.
641      *
642      * Emits a {Transfer} event with `to` set to the zero address.
643      *
644      * Requirements
645      *
646      * - `account` cannot be the zero address.
647      * - `account` must have at least `amount` tokens.
648      */
649     function _burn(address account, uint256 amount) internal virtual {
650         require(account != address(0), "ERC20: burn from the zero address");
651 
652         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
653         _totalSupply = _totalSupply.sub(amount);
654         emit Transfer(account, address(0), amount);
655     }
656 
657     /**
658      * Sets `amount` as the allowance of `spender` over the `owner`s tokens.
659      *
660      * This is internal function is equivalent to `approve`, and can be used to
661      * e.g. set automatic allowances for certain subsystems, etc.
662      *
663      * Emits an {Approval} event.
664      *
665      * Requirements:
666      *
667      * - `owner` cannot be the zero address.
668      * - `spender` cannot be the zero address.
669      */
670     function _approve(address owner, address spender, uint256 amount) internal virtual {
671         require(owner != address(0), "ERC20: approve from the zero address");
672         require(spender != address(0), "ERC20: approve to the zero address");
673 
674         _allowances[owner][spender] = amount;
675         emit Approval(owner, spender, amount);
676     }
677 
678     /**
679      * Sets {decimals} to a value other than the default one of 18.
680      *
681      * WARNING: This function should only be called from the constructor. Most
682      * applications that interact with token contracts will not expect
683      * {decimals} to ever change, and may work incorrectly if it does.
684      */
685     function _setupDecimals(uint8 decimals_) internal {
686         _decimals = decimals_;
687     }
688 
689 }
690 
691 // File: @openzeppelin/contracts/access/Ownable.sol
692 
693 pragma solidity ^0.6.0;
694 
695 /**
696  * Contract module which provides a basic access control mechanism, where
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
713      * Initializes the contract setting the deployer as the initial owner.
714      */
715     constructor () internal {
716         address msgSender = _msgSender();
717         _owner = msgSender;
718         emit OwnershipTransferred(address(0), msgSender);
719     }
720 
721     /**
722      * Returns the address of the current owner.
723      */
724     function governance() public view returns (address) {
725         return _owner;
726     }
727 
728     /**
729      * Throws if called by any account other than the owner.
730      */
731     modifier onlyGovernance() {
732         require(_owner == _msgSender(), "Ownable: caller is not the owner");
733         _;
734     }
735 
736     /**
737      * Transfers ownership of the contract to a new account (`newOwner`).
738      * Can only be called by the current owner.
739      */
740     function transferGovernance(address newOwner) internal virtual onlyGovernance {
741         require(newOwner != address(0), "Ownable: new owner is the zero address");
742         emit OwnershipTransferred(_owner, newOwner);
743         _owner = newOwner;
744     }
745 }
746 
747 library SafeERC20 {
748     using SafeMath for uint256;
749     using Address for address;
750 
751     function safeTransfer(IERC20 token, address to, uint256 value) internal {
752         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
753     }
754 
755     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
756         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
757     }
758 
759     /**
760      * @dev Deprecated. This function has issues similar to the ones found in
761      * {IERC20-approve}, and its usage is discouraged.
762      *
763      * Whenever possible, use {safeIncreaseAllowance} and
764      * {safeDecreaseAllowance} instead.
765      */
766     function safeApprove(IERC20 token, address spender, uint256 value) internal {
767         // safeApprove should only be called when setting an initial allowance,
768         // or when resetting it to zero. To increase and decrease it, use
769         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
770         // solhint-disable-next-line max-line-length
771         require((value == 0) || (token.allowance(address(this), spender) == 0),
772             "SafeERC20: approve from non-zero to non-zero allowance"
773         );
774         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
775     }
776 
777     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
778         uint256 newAllowance = token.allowance(address(this), spender).add(value);
779         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
780     }
781 
782     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
783         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
784         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
785     }
786 
787     /**
788      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
789      * on the return value: the return value is optional (but if data is returned, it must not be false).
790      * @param token The token targeted by the call.
791      * @param data The call data (encoded using abi.encode or one of its variants).
792      */
793     function _callOptionalReturn(IERC20 token, bytes memory data) private {
794         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
795         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
796         // the target address contains contract code and also asserts for success in the low-level call.
797 
798         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
799         if (returndata.length > 0) { // Return data is optional
800             // solhint-disable-next-line max-line-length
801             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
802         }
803     }
804 }
805 
806 contract ReentrancyGuard {
807     // Booleans are more expensive than uint256 or any type that takes up a full
808     // word because each write operation emits an extra SLOAD to first read the
809     // slot's contents, replace the bits taken up by the boolean, and then write
810     // back. This is the compiler's defense against contract upgrades and
811     // pointer aliasing, and it cannot be disabled.
812 
813     // The values being non-zero value makes deployment a bit more expensive,
814     // but in exchange the refund on every call to nonReentrant will be lower in
815     // amount. Since refunds are capped to a percentage of the total
816     // transaction's gas, it is best to keep them low in cases like this one, to
817     // increase the likelihood of the full refund coming into effect.
818     uint256 private constant _NOT_ENTERED = 1;
819     uint256 private constant _ENTERED = 2;
820 
821     uint256 private _status;
822 
823     constructor () internal {
824         _status = _NOT_ENTERED;
825     }
826 
827     /**
828      * @dev Prevents a contract from calling itself, directly or indirectly.
829      * Calling a `nonReentrant` function from another `nonReentrant`
830      * function is not supported. It is possible to prevent this from happening
831      * by making the `nonReentrant` function external, and make it call a
832      * `private` function that does the actual work.
833      */
834     modifier nonReentrant() {
835         // On the first call to nonReentrant, _notEntered will be true
836         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
837 
838         // Any calls to nonReentrant after this point will fail
839         _status = _ENTERED;
840 
841         _;
842 
843         // By storing the original value once again, a refund is triggered (see
844         // https://eips.ethereum.org/EIPS/eip-2200)
845         _status = _NOT_ENTERED;
846     }
847 }
848 
849 // File: contracts/zs-SGR.sol
850 // zsTokens are Stabilize proxy tokens that serve as receipts for deposits into Stabilize strategies
851 // zsTokens should increase in value if the strategy it uses is profitable
852 // When someone deposits into the zsToken contract, tokens are minted and when they redeem, tokens are burned
853 
854 interface StabilizeStrategy {
855     function rewardTokensCount() external view returns (uint256);
856     function rewardTokenAddress(uint256) external view returns (address);
857     function withdrawTokenReserves() external view returns (address, uint256);
858     function balance() external view returns (uint256);
859     function pricePerToken() external view returns (uint256);
860     function enter() external;
861     function exit() external;
862     function deposit(bool) external;
863     function withdraw(address, uint256, uint256, bool) external returns (uint256); // Will withdraw to the address specified a percent of total shares
864 }
865 
866 pragma solidity ^0.6.6;
867 
868 contract zsToken is ERC20("Stabilize Strategy Multi-Seigniorage", "zs-SGR"), Ownable, ReentrancyGuard {
869     using SafeERC20 for IERC20;
870 
871     // Variables
872     uint256 constant divisionFactor = 100000;
873     
874     // There are no fees to deposit and withdraw from the zs-Tokens
875     
876     // Info of each user.
877     struct UserInfo {
878         uint256 depositTime; // The time the user made the last deposit
879         uint256 shareEstimate;
880     }
881     
882     mapping(address => UserInfo) private userInfo;
883     
884     // Token information
885     // This wrapped token accepts multiple sgr coins
886     // ESD, DSD, BAC
887     struct TokenInfo {
888         IERC20 token; // Reference of token
889         uint256 decimals; // Decimals of token
890     }
891     
892     TokenInfo[] private tokenList; // An array of tokens accepted as deposits
893     address private _underlyingPriceAsset; // Token from which the price is derived for STBZ staking
894     bool public depositsOpen = true; // Governance can open or close deposits without timelock, cannot block withdrawals
895     
896     // Strategy information
897     StabilizeStrategy private currentStrategy; // This will be the contract for the strategy
898     address private _pendingStrategy;
899     
900     // Events
901     event Wrapped(address indexed user, uint256 amount);
902     event Unwrapped(address indexed user, uint256 amount);
903 
904     constructor (address _priceAsset) public {
905         _underlyingPriceAsset = _priceAsset;
906         setupWithdrawTokens();
907     }
908     
909     function setupWithdrawTokens() internal {
910         // Start with ESD
911         IERC20 _token = IERC20(address(0x36F3FD68E7325a35EB768F1AedaAe9EA0689d723));
912         tokenList.push(
913             TokenInfo({
914                 token: _token,
915                 decimals: _token.decimals()
916             })
917         );   
918         
919         // DSD
920         _token = IERC20(address(0xBD2F0Cd039E0BFcf88901C98c0bFAc5ab27566e3));
921         tokenList.push(
922             TokenInfo({
923                 token: _token,
924                 decimals: _token.decimals()
925             })
926         );
927         
928         // BAC
929         _token = IERC20(address(0x3449FC1Cd036255BA1EB19d65fF4BA2b8903A69a));
930         tokenList.push(
931             TokenInfo({
932                 token: _token,
933                 decimals: _token.decimals()
934             })
935         );
936     }
937     
938     function getCurrentStrategy() external view returns (address) {
939         return address(currentStrategy);
940     }
941     
942     function getPendingStrategy() external view returns (address) {
943         return _pendingStrategy;
944     }
945 
946     function underlyingAsset() public view returns (address) {
947         // Can be used if staking in the STBZ pool
948         return address(_underlyingPriceAsset);
949     }
950     
951     function underlyingDepositAssets() public view returns (address, address, address) {
952         // Returns all addresses accepted by this token vault
953         return (address(tokenList[0].token), address(tokenList[1].token), address(tokenList[2].token));
954     }
955     
956     function pricePerToken() public view returns (uint256) {
957         if(totalSupply() == 0){
958             return 1e18; // Shown in Wei units
959         }else{
960             return uint256(1e18).mul(valueOfVaultAndStrategy()).div(totalSupply());      
961         }
962     }
963     
964     function getNormalizedTotalBalance(address _address) public view returns (uint256) {
965         uint256 _balance = 0;
966         for(uint256 i = 0; i < tokenList.length; i++){
967             uint256 _bal = tokenList[i].token.balanceOf(_address);
968             _bal = _bal.mul(1e18).div(10**tokenList[i].decimals);
969             _balance = _balance.add(_bal); // This has been normalized to 1e18 decimals
970         }
971         return _balance;
972     }
973     
974     function valueOfVaultAndStrategy() public view returns (uint256) { // The total value of the tokens
975         uint256 balance = getNormalizedTotalBalance(address(this)); // Get tokens stored in this contract
976         if(currentStrategy != StabilizeStrategy(address(0))){
977             balance += currentStrategy.balance(); // And tokens stored at the strategy
978         }
979         return balance;
980     }
981     
982     function withdrawTokenReserves() public view returns (address, uint256) {
983         // This function will return the address and amount of the token with the highest balance
984         if(currentStrategy != StabilizeStrategy(address(0))){
985             return currentStrategy.withdrawTokenReserves();
986         }else{
987             uint256 length = tokenList.length;
988             uint256 targetID = 0;
989             uint256 targetNormBalance = 0;
990             for(uint256 i = 0; i < length; i++){
991                 uint256 _normBal = tokenList[i].token.balanceOf(address(this)).mul(1e18).div(10**tokenList[i].decimals);
992                 if(_normBal > 0){
993                     if(targetNormBalance == 0 || _normBal >= targetNormBalance){
994                         targetNormBalance = _normBal;
995                         targetID = i;
996                     }
997                 }
998             }
999             if(targetNormBalance > 0){
1000                 return (address(tokenList[targetID].token), tokenList[targetID].token.balanceOf(address(this)));
1001             }else{
1002                 return (address(0), 0); // No balance
1003             }
1004         }
1005     }
1006     
1007     
1008     // Now handle deposits into the strategy
1009     function deposit(uint256 amount, uint256 _tokenID) public nonReentrant {
1010         uint256 total = valueOfVaultAndStrategy(); // Get token equivalent at strategy and here if applicable
1011         
1012         require(depositsOpen == true, "Deposits have been suspended, but you can still withdraw");
1013         require(currentStrategy != StabilizeStrategy(address(0)),"No strategy contract has been selected yet");
1014         require(_tokenID < tokenList.length, "Token ID is outside range of tokens in contract");
1015         
1016         IERC20 _token = tokenList[_tokenID].token; // Trusted tokens
1017         uint256 _before = _token.balanceOf(address(this));
1018         _token.safeTransferFrom(_msgSender(), address(this), amount); // Transfer token to this address
1019         amount = _token.balanceOf(address(this)).sub(_before); // Some tokens lose amount (transfer fee) upon transfer
1020         require(amount > 0, "Cannot deposit 0");
1021         bool nonContract = false;
1022         if(tx.origin == _msgSender()){
1023             nonContract = true; // The sender is not a contract
1024         }
1025         uint256 _strategyBalance = currentStrategy.balance(); // Will get the balance of the value of the main tokens at the strategy
1026         // Now call the strategy to deposit
1027         pushTokensToStrategy(); // Push any strategy tokens here into the strategy
1028         currentStrategy.deposit(nonContract); // Activate strategy deposit
1029         require(currentStrategy.balance() > _strategyBalance, "No change in strategy balance"); // Balance should increase
1030         uint256 normalizedAmount = amount.mul(1e18).div(10**tokenList[_tokenID].decimals); // Make sure everything is same units
1031         uint256 mintAmount = normalizedAmount;
1032         if(totalSupply() > 0){
1033             // There is already a balance here, calculate our share
1034             mintAmount = normalizedAmount.mul(totalSupply()).div(total); // Our share of the total
1035         }
1036         _mint(_msgSender(),mintAmount); // Now mint new zs-token to the depositor
1037         
1038         // Add the user information
1039         userInfo[_msgSender()].depositTime = now;
1040         userInfo[_msgSender()].shareEstimate = userInfo[_msgSender()].shareEstimate.add(mintAmount);
1041 
1042         emit Wrapped(_msgSender(), amount);
1043     }
1044     
1045     function redeem(uint256 share) public nonReentrant {
1046         // Essentially withdraw our equivalent share of the pool based on share value
1047         // Users cannot choose which token they get. They get the largest quantity coin up to the lowest quantity
1048         require(share > 0, "Cannot withdraw 0");
1049         require(totalSupply() > 0, "No value redeemable");
1050         uint256 tokenTotal = totalSupply();
1051         // Now burn the token
1052         _burn(_msgSender(),share); // Burn the amount, will fail if user doesn't have enough
1053         
1054         bool nonContract = false;
1055         if(tx.origin == _msgSender()){
1056             nonContract = true; // The sender is not a contract, we will allow market sells and buys
1057         }else{
1058             // This is a contract redeeming
1059             require(userInfo[_msgSender()].depositTime < now && userInfo[_msgSender()].depositTime > 0, "Contract depositor cannot redeem in same transaction");
1060         }
1061         
1062         // Update user information
1063         if(share <= userInfo[_msgSender()].shareEstimate){
1064             userInfo[_msgSender()].shareEstimate = userInfo[_msgSender()].shareEstimate.sub(share);
1065         }else{
1066             // Share is greater than our share estimate, can happen if tokens are transferred
1067             userInfo[_msgSender()].shareEstimate = 0;
1068             require(nonContract == true, "Contract depositors cannot take out more than what they put in");
1069         }
1070 
1071         uint256 withdrawAmount = 0;
1072         if(currentStrategy != StabilizeStrategy(address(0))){
1073             withdrawAmount = currentStrategy.withdraw(_msgSender(), share, tokenTotal, nonContract); // Returns the amount of underlying removed
1074             require(withdrawAmount > 0, "Failed to withdraw from the strategy");
1075         }else{
1076             // Pull directly from this contract the token amount in relation to the share if strategy not used
1077             if(share < tokenTotal){
1078                 uint256 _balance = getNormalizedTotalBalance(address(this));
1079                 uint256 _myBalance = _balance.mul(share).div(tokenTotal);
1080                 withdrawPerBalance(_msgSender(), _myBalance, false); // This will withdraw based on token balanace
1081                 withdrawAmount = _myBalance;
1082             }else{
1083                 // We are all shares, transfer all
1084                 uint256 _balance = getNormalizedTotalBalance(address(this));
1085                 withdrawPerBalance(_msgSender(), _balance, true);
1086                 withdrawAmount = _balance;
1087             }
1088         }
1089         
1090         emit Unwrapped(_msgSender(), withdrawAmount);
1091     }
1092     
1093     // This will withdraw the tokens from the contract based on their balance, from highest balance to lowest
1094     function withdrawPerBalance(address _receiver, uint256 _withdrawAmount, bool _takeAll) internal {
1095         uint256 length = tokenList.length;
1096         if(_takeAll == true){
1097             // Send the entire balance
1098             for(uint256 i = 0; i < length; i++){
1099                 uint256 _bal = tokenList[i].token.balanceOf(address(this));
1100                 if(_bal > 0){
1101                     tokenList[i].token.safeTransfer(_receiver, _bal);
1102                 }
1103             }
1104             return;
1105         }
1106         bool[4] memory done;
1107         uint256 targetID = 0;
1108         uint256 targetNormBalance = 0;
1109         for(uint256 i = 0; i < length; i++){
1110             
1111             targetNormBalance = 0; // Reset the target balance
1112             // Find the highest balanced token to withdraw
1113             for(uint256 i2 = 0; i2 < length; i2++){
1114                 if(done[i2] == false){
1115                     uint256 _normBal = tokenList[i2].token.balanceOf(address(this)).mul(1e18).div(10**tokenList[i2].decimals);
1116                     if(targetNormBalance == 0 || _normBal >= targetNormBalance){
1117                         targetNormBalance = _normBal;
1118                         targetID = i2;
1119                     }
1120                 }
1121             }
1122             done[targetID] = true;
1123             
1124             // Determine the balance left
1125             uint256 _normalizedBalance = tokenList[targetID].token.balanceOf(address(this)).mul(1e18).div(10**tokenList[targetID].decimals);
1126             if(_normalizedBalance <= _withdrawAmount){
1127                 // Withdraw the entire balance of this token
1128                 if(_normalizedBalance > 0){
1129                     _withdrawAmount = _withdrawAmount.sub(_normalizedBalance);
1130                     tokenList[targetID].token.safeTransfer(_receiver, tokenList[targetID].token.balanceOf(address(this)));                    
1131                 }
1132             }else{
1133                 // Withdraw a partial amount of this token
1134                 if(_withdrawAmount > 0){
1135                     // Convert the withdraw amount to the token's decimal amount
1136                     uint256 _balance = _withdrawAmount.mul(10**tokenList[targetID].decimals).div(1e18);
1137                     _withdrawAmount = 0;
1138                     tokenList[targetID].token.safeTransfer(_receiver, _balance);
1139                 }
1140                 break; // Nothing more to withdraw
1141             }
1142         }
1143     }
1144     
1145     // Governance functions
1146     
1147     // Stop/start all deposits, no timelock required
1148     // --------------------
1149     function stopDeposits() external onlyGovernance {
1150         depositsOpen = false;
1151     }
1152 
1153     function startDeposits() external onlyGovernance {
1154         depositsOpen = true;
1155     }
1156 
1157     // A function used in case of strategy failure, possibly due to bug in the platform our strategy is using, governance can stop using it quick
1158     function emergencyStopStrategy() external onlyGovernance {
1159         depositsOpen = false;
1160         if(currentStrategy != StabilizeStrategy(address(0)) && totalSupply() > 0){
1161             currentStrategy.exit(); // Pulls all the tokens and accessory tokens from the strategy 
1162         }
1163         currentStrategy = StabilizeStrategy(address(0));
1164         _timelockType = 0; // Prevent governance from changing to new strategy without timelock
1165     }
1166 
1167     // --------------------
1168     
1169     // Timelock variables
1170     
1171     uint256 private _timelockStart; // The start of the timelock to change governance variables
1172     uint256 private _timelockType; // The function that needs to be changed
1173     uint256 constant _timelockDuration = 86400; // Timelock is 24 hours
1174     
1175     // Reusable timelock variables
1176     address private _timelock_address;
1177     
1178     modifier timelockConditionsMet(uint256 _type) {
1179         require(_timelockType == _type, "Timelock not acquired for this function");
1180         _timelockType = 0; // Reset the type once the timelock is used
1181         if(totalSupply() > 0){
1182             // Timelock is only required after tokens exist
1183             require(now >= _timelockStart + _timelockDuration, "Timelock time not met");
1184         }
1185         _;
1186     }
1187     
1188     // Change the owner of the token contract
1189     // --------------------
1190     function startGovernanceChange(address _address) external onlyGovernance {
1191         _timelockStart = now;
1192         _timelockType = 1;
1193         _timelock_address = _address;       
1194     }
1195     
1196     function finishGovernanceChange() external onlyGovernance timelockConditionsMet(1) {
1197         transferGovernance(_timelock_address);
1198     }
1199     // --------------------
1200     
1201     
1202     // Change the treasury address
1203     // --------------------
1204     function startChangeStrategy(address _address) external onlyGovernance {
1205         _timelockStart = now;
1206         _timelockType = 2;
1207         _timelock_address = _address;
1208         _pendingStrategy = _address;
1209         if(totalSupply() == 0){
1210             // Can change strategy with one call in this case
1211             finishChangeStrategy();
1212         }
1213     }
1214     
1215     function finishChangeStrategy() public onlyGovernance timelockConditionsMet(2) {
1216         if(currentStrategy != StabilizeStrategy(address(0)) && totalSupply() > 0){
1217             currentStrategy.exit(); // Pulls all the tokens and accessory tokens from the strategy 
1218         }
1219         currentStrategy = StabilizeStrategy(_timelock_address);
1220         if(currentStrategy != StabilizeStrategy(address(0)) && totalSupply() > 0){
1221             pushTokensToStrategy(); // It will push any strategy reward tokens here to the new strategy
1222             currentStrategy.enter(); // Puts all the tokens and accessory tokens into the new strategy 
1223         }
1224         _pendingStrategy = address(0);
1225     }
1226     
1227     function pushTokensToStrategy() internal {
1228         uint256 tokenCount = currentStrategy.rewardTokensCount();
1229         for(uint256 i = 0; i < tokenCount; i++){
1230             IERC20 _token = IERC20(address(currentStrategy.rewardTokenAddress(i)));
1231             uint256 _balance = _token.balanceOf(address(this));
1232             if(_balance > 0){
1233                 _token.safeTransfer(address(currentStrategy), _balance);
1234             }
1235         }
1236     }
1237     // --------------------
1238 
1239 }