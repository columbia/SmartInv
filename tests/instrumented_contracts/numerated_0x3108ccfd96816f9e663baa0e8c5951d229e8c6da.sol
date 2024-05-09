1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT + WTFPL
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
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 pragma solidity ^0.6.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () internal {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
98 
99 
100 pragma solidity ^0.6.0;
101 
102 /**
103  * @dev Interface of the ERC20 standard as defined in the EIP.
104  */
105 interface IERC20 {
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `recipient`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address recipient, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 // File: @openzeppelin/contracts/math/SafeMath.sol
177 
178 
179 pragma solidity ^0.6.0;
180 
181 /**
182  * @dev Wrappers over Solidity's arithmetic operations with added overflow
183  * checks.
184  *
185  * Arithmetic operations in Solidity wrap on overflow. This can easily result
186  * in bugs, because programmers usually assume that an overflow raises an
187  * error, which is the standard behavior in high level programming languages.
188  * `SafeMath` restores this intuition by reverting the transaction when an
189  * operation overflows.
190  *
191  * Using this library instead of the unchecked operations eliminates an entire
192  * class of bugs, so it's recommended to use it always.
193  */
194 library SafeMath {
195     /**
196      * @dev Returns the addition of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `+` operator.
200      *
201      * Requirements:
202      *
203      * - Addition cannot overflow.
204      */
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         uint256 c = a + b;
207         require(c >= a, "SafeMath: addition overflow");
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting on
214      * overflow (when the result is negative).
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      *
220      * - Subtraction cannot overflow.
221      */
222     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223         return sub(a, b, "SafeMath: subtraction overflow");
224     }
225 
226     /**
227      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
228      * overflow (when the result is negative).
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      *
234      * - Subtraction cannot overflow.
235      */
236     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b <= a, errorMessage);
238         uint256 c = a - b;
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the multiplication of two unsigned integers, reverting on
245      * overflow.
246      *
247      * Counterpart to Solidity's `*` operator.
248      *
249      * Requirements:
250      *
251      * - Multiplication cannot overflow.
252      */
253     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
254         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
255         // benefit is lost if 'b' is also tested.
256         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
257         if (a == 0) {
258             return 0;
259         }
260 
261         uint256 c = a * b;
262         require(c / a == b, "SafeMath: multiplication overflow");
263 
264         return c;
265     }
266 
267     /**
268      * @dev Returns the integer division of two unsigned integers. Reverts on
269      * division by zero. The result is rounded towards zero.
270      *
271      * Counterpart to Solidity's `/` operator. Note: this function uses a
272      * `revert` opcode (which leaves remaining gas untouched) while Solidity
273      * uses an invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function div(uint256 a, uint256 b) internal pure returns (uint256) {
280         return div(a, b, "SafeMath: division by zero");
281     }
282 
283     /**
284      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
285      * division by zero. The result is rounded towards zero.
286      *
287      * Counterpart to Solidity's `/` operator. Note: this function uses a
288      * `revert` opcode (which leaves remaining gas untouched) while Solidity
289      * uses an invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b > 0, errorMessage);
297         uint256 c = a / b;
298         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
305      * Reverts when dividing by zero.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
316         return mod(a, b, "SafeMath: modulo by zero");
317     }
318 
319     /**
320      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
321      * Reverts with custom message when dividing by zero.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         require(b != 0, errorMessage);
333         return a % b;
334     }
335 }
336 
337 // File: @openzeppelin/contracts/utils/Address.sol
338 
339 
340 pragma solidity ^0.6.2;
341 
342 /**
343  * @dev Collection of functions related to the address type
344  */
345 library Address {
346     /**
347      * @dev Returns true if `account` is a contract.
348      *
349      * [IMPORTANT]
350      * ====
351      * It is unsafe to assume that an address for which this function returns
352      * false is an externally-owned account (EOA) and not a contract.
353      *
354      * Among others, `isContract` will return false for the following
355      * types of addresses:
356      *
357      *  - an externally-owned account
358      *  - a contract in construction
359      *  - an address where a contract will be created
360      *  - an address where a contract lived, but was destroyed
361      * ====
362      */
363     function isContract(address account) internal view returns (bool) {
364         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
365         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
366         // for accounts without code, i.e. `keccak256('')`
367         bytes32 codehash;
368         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
369         // solhint-disable-next-line no-inline-assembly
370         assembly { codehash := extcodehash(account) }
371         return (codehash != accountHash && codehash != 0x0);
372     }
373 
374     /**
375      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
376      * `recipient`, forwarding all available gas and reverting on errors.
377      *
378      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
379      * of certain opcodes, possibly making contracts go over the 2300 gas limit
380      * imposed by `transfer`, making them unable to receive funds via
381      * `transfer`. {sendValue} removes this limitation.
382      *
383      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
384      *
385      * IMPORTANT: because control is transferred to `recipient`, care must be
386      * taken to not create reentrancy vulnerabilities. Consider using
387      * {ReentrancyGuard} or the
388      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
389      */
390     function sendValue(address payable recipient, uint256 amount) internal {
391         require(address(this).balance >= amount, "Address: insufficient balance");
392 
393         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
394         (bool success, ) = recipient.call{ value: amount }("");
395         require(success, "Address: unable to send value, recipient may have reverted");
396     }
397 
398     /**
399      * @dev Performs a Solidity function call using a low level `call`. A
400      * plain`call` is an unsafe replacement for a function call: use this
401      * function instead.
402      *
403      * If `target` reverts with a revert reason, it is bubbled up by this
404      * function (like regular Solidity function calls).
405      *
406      * Returns the raw returned data. To convert to the expected return value,
407      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
408      *
409      * Requirements:
410      *
411      * - `target` must be a contract.
412      * - calling `target` with `data` must not revert.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
417       return functionCall(target, data, "Address: low-level call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
422      * `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
427         return _functionCallWithValue(target, data, 0, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but also transferring `value` wei to `target`.
433      *
434      * Requirements:
435      *
436      * - the calling contract must have an ETH balance of at least `value`.
437      * - the called Solidity function must be `payable`.
438      *
439      * _Available since v3.1._
440      */
441     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
442         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
447      * with `errorMessage` as a fallback revert reason when `target` reverts.
448      *
449      * _Available since v3.1._
450      */
451     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
452         require(address(this).balance >= value, "Address: insufficient balance for call");
453         return _functionCallWithValue(target, data, value, errorMessage);
454     }
455 
456     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
457         require(isContract(target), "Address: call to non-contract");
458 
459         // solhint-disable-next-line avoid-low-level-calls
460         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 // solhint-disable-next-line no-inline-assembly
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 // File: contracts/SakeToken.sol
481 
482 pragma solidity 0.6.12;
483 
484 
485 
486 
487 
488 
489 // DarkToken with Governance.
490 contract DarkToken is Context, IERC20, Ownable {
491     using SafeMath for uint256;
492     using Address for address;
493 
494     mapping (address => uint256) private _balances;
495 
496     mapping (address => mapping (address => uint256)) private _allowances;
497 
498     uint256 private _totalSupply;
499 
500     string private _name = "DarkToken";
501     string private _symbol = "DARK";
502     uint8 private _decimals = 18;
503 
504     /**
505      * @dev Returns the name of the token.
506      */
507     function name() public view returns (string memory) {
508         return _name;
509     }
510 
511     /**
512      * @dev Returns the symbol of the token, usually a shorter version of the
513      * name.
514      */
515     function symbol() public view returns (string memory) {
516         return _symbol;
517     }
518 
519     /**
520      * @dev Returns the number of decimals used to get its user representation.
521      * For example, if `decimals` equals `2`, a balance of `505` tokens should
522      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
523      *
524      * Tokens usually opt for a value of 18, imitating the relationship between
525      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
526      * called.
527      *
528      * NOTE: This information is only used for _display_ purposes: it in
529      * no way affects any of the arithmetic of the contract, including
530      * {IERC20-balanceOf} and {IERC20-transfer}.
531      */
532     function decimals() public view returns (uint8) {
533         return _decimals;
534     }
535 
536     /**
537      * @dev See {IERC20-totalSupply}.
538      */
539     function totalSupply() public view override returns (uint256) {
540         return _totalSupply;
541     }
542 
543     /**
544      * @dev See {IERC20-balanceOf}.
545      */
546     function balanceOf(address account) public view override returns (uint256) {
547         return _balances[account];
548     }
549 
550     /**
551      * @dev See {IERC20-transfer}.
552      *
553      * Requirements:
554      *
555      * - `recipient` cannot be the zero address.
556      * - the caller must have a balance of at least `amount`.
557      */
558     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
559         _transfer(_msgSender(), recipient, amount);
560         return true;
561     }
562 
563     /**
564      * @dev See {IERC20-allowance}.
565      */
566     function allowance(address owner, address spender) public view virtual override returns (uint256) {
567         return _allowances[owner][spender];
568     }
569 
570     /**
571      * @dev See {IERC20-approve}.
572      *
573      * Requirements:
574      *
575      * - `spender` cannot be the zero address.
576      */
577     function approve(address spender, uint256 amount) public virtual override returns (bool) {
578         _approve(_msgSender(), spender, amount);
579         return true;
580     }
581 
582     /**
583      * @dev See {IERC20-transferFrom}.
584      *
585      * Emits an {Approval} event indicating the updated allowance. This is not
586      * required by the EIP. See the note at the beginning of {ERC20};
587      *
588      * Requirements:
589      * - `sender` and `recipient` cannot be the zero address.
590      * - `sender` must have a balance of at least `amount`.
591      * - the caller must have allowance for ``sender``'s tokens of at least
592      * `amount`.
593      */
594     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
595         _transfer(sender, recipient, amount);
596         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
597         return true;
598     }
599 
600     /**
601      * @dev Atomically increases the allowance granted to `spender` by the caller.
602      *
603      * This is an alternative to {approve} that can be used as a mitigation for
604      * problems described in {IERC20-approve}.
605      *
606      * Emits an {Approval} event indicating the updated allowance.
607      *
608      * Requirements:
609      *
610      * - `spender` cannot be the zero address.
611      */
612     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
613         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
614         return true;
615     }
616 
617     /**
618      * @dev Atomically decreases the allowance granted to `spender` by the caller.
619      *
620      * This is an alternative to {approve} that can be used as a mitigation for
621      * problems described in {IERC20-approve}.
622      *
623      * Emits an {Approval} event indicating the updated allowance.
624      *
625      * Requirements:
626      *
627      * - `spender` cannot be the zero address.
628      * - `spender` must have allowance for the caller of at least
629      * `subtractedValue`.
630      */
631     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
632         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
633         return true;
634     }
635 
636     /**
637      * @dev Moves tokens `amount` from `sender` to `recipient`.
638      *
639      * This is internal function is equivalent to {transfer}, and can be used to
640      * e.g. implement automatic token fees, slashing mechanisms, etc.
641      *
642      * Emits a {Transfer} event.
643      *
644      * Requirements:
645      *
646      * - `sender` cannot be the zero address.
647      * - `recipient` cannot be the zero address.
648      * - `sender` must have a balance of at least `amount`.
649      */
650     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
651         require(sender != address(0), "ERC20: transfer from the zero address");
652         require(recipient != address(0), "ERC20: transfer to the zero address");
653 
654         _beforeTokenTransfer(sender, recipient, amount);
655 
656         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
657         _balances[recipient] = _balances[recipient].add(amount);
658         emit Transfer(sender, recipient, amount);
659 
660         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
661     }
662 
663     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
664      * the total supply.
665      *
666      * Emits a {Transfer} event with `from` set to the zero address.
667      *
668      * Requirements
669      *
670      * - `to` cannot be the zero address.
671      */
672     function _mint(address account, uint256 amount) internal virtual {
673         require(account != address(0), "ERC20: mint to the zero address");
674 
675         _beforeTokenTransfer(address(0), account, amount);
676 
677         _totalSupply = _totalSupply.add(amount);
678         _balances[account] = _balances[account].add(amount);
679         emit Transfer(address(0), account, amount);
680     }
681 
682     /**
683      * @dev Destroys `amount` tokens from `account`, reducing the
684      * total supply.
685      *
686      * Emits a {Transfer} event with `to` set to the zero address.
687      *
688      * Requirements
689      *
690      * - `account` cannot be the zero address.
691      * - `account` must have at least `amount` tokens.
692      */
693     function _burn(address account, uint256 amount) internal virtual {
694         require(account != address(0), "ERC20: burn from the zero address");
695 
696         _beforeTokenTransfer(account, address(0), amount);
697 
698         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
699         _totalSupply = _totalSupply.sub(amount);
700         emit Transfer(account, address(0), amount);
701     }
702 
703     /**
704      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
705      *
706      * This is internal function is equivalent to `approve`, and can be used to
707      * e.g. set automatic allowances for certain subsystems, etc.
708      *
709      * Emits an {Approval} event.
710      *
711      * Requirements:
712      *
713      * - `owner` cannot be the zero address.
714      * - `spender` cannot be the zero address.
715      */
716     function _approve(address owner, address spender, uint256 amount) internal virtual {
717         require(owner != address(0), "ERC20: approve from the zero address");
718         require(spender != address(0), "ERC20: approve to the zero address");
719 
720         _allowances[owner][spender] = amount;
721         emit Approval(owner, spender, amount);
722     }
723 
724     /**
725      * @dev Sets {decimals} to a value other than the default one of 18.
726      *
727      * WARNING: This function should only be called from the constructor. Most
728      * applications that interact with token contracts will not expect
729      * {decimals} to ever change, and may work incorrectly if it does.
730      */
731     function _setupDecimals(uint8 decimals_) internal {
732         _decimals = decimals_;
733     }
734 
735     /**
736      * @dev Hook that is called before any transfer of tokens. This includes
737      * minting and burning.
738      *
739      * Calling conditions:
740      *
741      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
742      * will be to transferred to `to`.
743      * - when `from` is zero, `amount` tokens will be minted for `to`.
744      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
745      * - `from` and `to` are never both zero.
746      *
747      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
748      */
749     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
750 
751     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (DarkMaster).
752     function mint(address _to, uint256 _amount) public onlyOwner {
753         _mint(_to, _amount);
754         _moveDelegates(address(0), _delegates[_to], _amount);
755     }
756 
757     // Copied and modified from YAM code:
758     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
759     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
760     // Which is copied and modified from COMPOUND:
761     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
762 
763     /// @notice A record of each accounts delegate
764     mapping (address => address) internal _delegates;
765 
766     /// @notice A checkpoint for marking number of votes from a given block
767     struct Checkpoint {
768         uint32 fromBlock;
769         uint256 votes;
770     }
771 
772     /// @notice A record of votes checkpoints for each account, by index
773     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
774 
775     /// @notice The number of checkpoints for each account
776     mapping (address => uint32) public numCheckpoints;
777 
778     /// @notice The EIP-712 typehash for the contract's domain
779     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
780 
781     /// @notice The EIP-712 typehash for the delegation struct used by the contract
782     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
783 
784     /// @notice A record of states for signing / validating signatures
785     mapping (address => uint) public nonces;
786 
787     /// @notice An event thats emitted when an account changes its delegate
788     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
789 
790     /// @notice An event thats emitted when a delegate account's vote balance changes
791     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
792 
793     /**
794      * @notice Delegate votes from `msg.sender` to `delegatee`
795      * @param delegator The address to get delegatee for
796      */
797     function delegates(address delegator)
798         external
799         view
800         returns (address)
801     {
802         return _delegates[delegator];
803     }
804 
805    /**
806     * @notice Delegate votes from `msg.sender` to `delegatee`
807     * @param delegatee The address to delegate votes to
808     */
809     function delegate(address delegatee) external {
810         return _delegate(msg.sender, delegatee);
811     }
812 
813     /**
814      * @notice Delegates votes from signatory to `delegatee`
815      * @param delegatee The address to delegate votes to
816      * @param nonce The contract state required to match the signature
817      * @param expiry The time at which to expire the signature
818      * @param v The recovery byte of the signature
819      * @param r Half of the ECDSA signature pair
820      * @param s Half of the ECDSA signature pair
821      */
822     function delegateBySig(
823         address delegatee,
824         uint nonce,
825         uint expiry,
826         uint8 v,
827         bytes32 r,
828         bytes32 s
829     )
830         external
831     {
832         bytes32 domainSeparator = keccak256(
833             abi.encode(
834                 DOMAIN_TYPEHASH,
835                 keccak256(bytes(name())),
836                 getChainId(),
837                 address(this)
838             )
839         );
840 
841         bytes32 structHash = keccak256(
842             abi.encode(
843                 DELEGATION_TYPEHASH,
844                 delegatee,
845                 nonce,
846                 expiry
847             )
848         );
849 
850         bytes32 digest = keccak256(
851             abi.encodePacked(
852                 "\x19\x01",
853                 domainSeparator,
854                 structHash
855             )
856         );
857 
858         address signatory = ecrecover(digest, v, r, s);
859         require(signatory != address(0), "DARK::delegateBySig: invalid signature");
860         require(nonce == nonces[signatory]++, "DARK::delegateBySig: invalid nonce");
861         require(now <= expiry, "DARK::delegateBySig: signature expired");
862         return _delegate(signatory, delegatee);
863     }
864 
865     /**
866      * @notice Gets the current votes balance for `account`
867      * @param account The address to get votes balance
868      * @return The number of current votes for `account`
869      */
870     function getCurrentVotes(address account)
871         external
872         view
873         returns (uint256)
874     {
875         uint32 nCheckpoints = numCheckpoints[account];
876         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
877     }
878 
879     /**
880      * @notice Determine the prior number of votes for an account as of a block number
881      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
882      * @param account The address of the account to check
883      * @param blockNumber The block number to get the vote balance at
884      * @return The number of votes the account had as of the given block
885      */
886     function getPriorVotes(address account, uint blockNumber)
887         external
888         view
889         returns (uint256)
890     {
891         require(blockNumber < block.number, "DARK::getPriorVotes: not yet determined");
892 
893         uint32 nCheckpoints = numCheckpoints[account];
894         if (nCheckpoints == 0) {
895             return 0;
896         }
897 
898         // First check most recent balance
899         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
900             return checkpoints[account][nCheckpoints - 1].votes;
901         }
902 
903         // Next check implicit zero balance
904         if (checkpoints[account][0].fromBlock > blockNumber) {
905             return 0;
906         }
907 
908         uint32 lower = 0;
909         uint32 upper = nCheckpoints - 1;
910         while (upper > lower) {
911             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
912             Checkpoint memory cp = checkpoints[account][center];
913             if (cp.fromBlock == blockNumber) {
914                 return cp.votes;
915             } else if (cp.fromBlock < blockNumber) {
916                 lower = center;
917             } else {
918                 upper = center - 1;
919             }
920         }
921         return checkpoints[account][lower].votes;
922     }
923 
924     function _delegate(address delegator, address delegatee)
925         internal
926     {
927         address currentDelegate = _delegates[delegator];
928         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying DARKs (not scaled);
929         _delegates[delegator] = delegatee;
930 
931         emit DelegateChanged(delegator, currentDelegate, delegatee);
932 
933         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
934     }
935 
936     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
937         if (srcRep != dstRep && amount > 0) {
938             if (srcRep != address(0)) {
939                 // decrease old representative
940                 uint32 srcRepNum = numCheckpoints[srcRep];
941                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
942                 uint256 srcRepNew = srcRepOld.sub(amount);
943                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
944             }
945 
946             if (dstRep != address(0)) {
947                 // increase new representative
948                 uint32 dstRepNum = numCheckpoints[dstRep];
949                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
950                 uint256 dstRepNew = dstRepOld.add(amount);
951                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
952             }
953         }
954     }
955 
956     function _writeCheckpoint(
957         address delegatee,
958         uint32 nCheckpoints,
959         uint256 oldVotes,
960         uint256 newVotes
961     )
962         internal
963     {
964         uint32 blockNumber = safe32(block.number, "DARK::_writeCheckpoint: block number exceeds 32 bits");
965 
966         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
967             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
968         } else {
969             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
970             numCheckpoints[delegatee] = nCheckpoints + 1;
971         }
972 
973         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
974     }
975 
976     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
977         require(n < 2**32, errorMessage);
978         return uint32(n);
979     }
980 
981     function getChainId() internal pure returns (uint) {
982         uint256 chainId;
983         assembly { chainId := chainid() }
984         return chainId;
985     }
986 }