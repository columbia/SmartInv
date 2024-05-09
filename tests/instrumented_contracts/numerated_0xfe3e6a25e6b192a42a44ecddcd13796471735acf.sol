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
364         // This method relies in extcodesize, which returns 0 for contracts in
365         // construction, since the code is only stored at the end of the
366         // constructor execution.
367 
368         uint256 size;
369         // solhint-disable-next-line no-inline-assembly
370         assembly { size := extcodesize(account) }
371         return size > 0;
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
480 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
481 
482 
483 pragma solidity ^0.6.0;
484 
485 
486 
487 
488 
489 /**
490  * @dev Implementation of the {IERC20} interface.
491  *
492  * This implementation is agnostic to the way tokens are created. This means
493  * that a supply mechanism has to be added in a derived contract using {_mint}.
494  * For a generic mechanism see {ERC20PresetMinterPauser}.
495  *
496  * TIP: For a detailed writeup see our guide
497  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
498  * to implement supply mechanisms].
499  *
500  * We have followed general OpenZeppelin guidelines: functions revert instead
501  * of returning `false` on failure. This behavior is nonetheless conventional
502  * and does not conflict with the expectations of ERC20 applications.
503  *
504  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
505  * This allows applications to reconstruct the allowance for all accounts just
506  * by listening to said events. Other implementations of the EIP may not emit
507  * these events, as it isn't required by the specification.
508  *
509  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
510  * functions have been added to mitigate the well-known issues around setting
511  * allowances. See {IERC20-approve}.
512  */
513 contract ERC20 is Context, IERC20 {
514     using SafeMath for uint256;
515     using Address for address;
516 
517     mapping (address => uint256) private _balances;
518 
519     mapping (address => mapping (address => uint256)) private _allowances;
520 
521     uint256 private _totalSupply;
522 
523     string private _name;
524     string private _symbol;
525     uint8 private _decimals;
526 
527     /**
528      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
529      * a default value of 18.
530      *
531      * To select a different value for {decimals}, use {_setupDecimals}.
532      *
533      * All three of these values are immutable: they can only be set once during
534      * construction.
535      */
536     constructor (string memory name, string memory symbol) public {
537         _name = name;
538         _symbol = symbol;
539         _decimals = 18;
540     }
541 
542     /**
543      * @dev Returns the name of the token.
544      */
545     function name() public view returns (string memory) {
546         return _name;
547     }
548 
549     /**
550      * @dev Returns the symbol of the token, usually a shorter version of the
551      * name.
552      */
553     function symbol() public view returns (string memory) {
554         return _symbol;
555     }
556 
557     /**
558      * @dev Returns the number of decimals used to get its user representation.
559      * For example, if `decimals` equals `2`, a balance of `505` tokens should
560      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
561      *
562      * Tokens usually opt for a value of 18, imitating the relationship between
563      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
564      * called.
565      *
566      * NOTE: This information is only used for _display_ purposes: it in
567      * no way affects any of the arithmetic of the contract, including
568      * {IERC20-balanceOf} and {IERC20-transfer}.
569      */
570     function decimals() public view returns (uint8) {
571         return _decimals;
572     }
573 
574     /**
575      * @dev See {IERC20-totalSupply}.
576      */
577     function totalSupply() public view override returns (uint256) {
578         return _totalSupply;
579     }
580 
581     /**
582      * @dev See {IERC20-balanceOf}.
583      */
584     function balanceOf(address account) public view override returns (uint256) {
585         return _balances[account];
586     }
587 
588     /**
589      * @dev See {IERC20-transfer}.
590      *
591      * Requirements:
592      *
593      * - `recipient` cannot be the zero address.
594      * - the caller must have a balance of at least `amount`.
595      */
596     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
597         _transfer(_msgSender(), recipient, amount);
598         return true;
599     }
600 
601     /**
602      * @dev See {IERC20-allowance}.
603      */
604     function allowance(address owner, address spender) public view virtual override returns (uint256) {
605         return _allowances[owner][spender];
606     }
607 
608     /**
609      * @dev See {IERC20-approve}.
610      *
611      * Requirements:
612      *
613      * - `spender` cannot be the zero address.
614      */
615     function approve(address spender, uint256 amount) public virtual override returns (bool) {
616         _approve(_msgSender(), spender, amount);
617         return true;
618     }
619 
620     /**
621      * @dev See {IERC20-transferFrom}.
622      *
623      * Emits an {Approval} event indicating the updated allowance. This is not
624      * required by the EIP. See the note at the beginning of {ERC20};
625      *
626      * Requirements:
627      * - `sender` and `recipient` cannot be the zero address.
628      * - `sender` must have a balance of at least `amount`.
629      * - the caller must have allowance for ``sender``'s tokens of at least
630      * `amount`.
631      */
632     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
633         _transfer(sender, recipient, amount);
634         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
635         return true;
636     }
637 
638     /**
639      * @dev Atomically increases the allowance granted to `spender` by the caller.
640      *
641      * This is an alternative to {approve} that can be used as a mitigation for
642      * problems described in {IERC20-approve}.
643      *
644      * Emits an {Approval} event indicating the updated allowance.
645      *
646      * Requirements:
647      *
648      * - `spender` cannot be the zero address.
649      */
650     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
651         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
652         return true;
653     }
654 
655     /**
656      * @dev Atomically decreases the allowance granted to `spender` by the caller.
657      *
658      * This is an alternative to {approve} that can be used as a mitigation for
659      * problems described in {IERC20-approve}.
660      *
661      * Emits an {Approval} event indicating the updated allowance.
662      *
663      * Requirements:
664      *
665      * - `spender` cannot be the zero address.
666      * - `spender` must have allowance for the caller of at least
667      * `subtractedValue`.
668      */
669     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
670         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
671         return true;
672     }
673 
674     /**
675      * @dev Moves tokens `amount` from `sender` to `recipient`.
676      *
677      * This is internal function is equivalent to {transfer}, and can be used to
678      * e.g. implement automatic token fees, slashing mechanisms, etc.
679      *
680      * Emits a {Transfer} event.
681      *
682      * Requirements:
683      *
684      * - `sender` cannot be the zero address.
685      * - `recipient` cannot be the zero address.
686      * - `sender` must have a balance of at least `amount`.
687      */
688     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
689         require(sender != address(0), "ERC20: transfer from the zero address");
690         require(recipient != address(0), "ERC20: transfer to the zero address");
691 
692         _beforeTokenTransfer(sender, recipient, amount);
693 
694         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
695         _balances[recipient] = _balances[recipient].add(amount);
696         emit Transfer(sender, recipient, amount);
697     }
698 
699     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
700      * the total supply.
701      *
702      * Emits a {Transfer} event with `from` set to the zero address.
703      *
704      * Requirements
705      *
706      * - `to` cannot be the zero address.
707      */
708     function _mint(address account, uint256 amount) internal virtual {
709         require(account != address(0), "ERC20: mint to the zero address");
710 
711         _beforeTokenTransfer(address(0), account, amount);
712 
713         _totalSupply = _totalSupply.add(amount);
714         _balances[account] = _balances[account].add(amount);
715         emit Transfer(address(0), account, amount);
716     }
717 
718     /**
719      * @dev Destroys `amount` tokens from `account`, reducing the
720      * total supply.
721      *
722      * Emits a {Transfer} event with `to` set to the zero address.
723      *
724      * Requirements
725      *
726      * - `account` cannot be the zero address.
727      * - `account` must have at least `amount` tokens.
728      */
729     function _burn(address account, uint256 amount) internal virtual {
730         require(account != address(0), "ERC20: burn from the zero address");
731 
732         _beforeTokenTransfer(account, address(0), amount);
733 
734         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
735         _totalSupply = _totalSupply.sub(amount);
736         emit Transfer(account, address(0), amount);
737     }
738 
739     /**
740      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
741      *
742      * This internal function is equivalent to `approve`, and can be used to
743      * e.g. set automatic allowances for certain subsystems, etc.
744      *
745      * Emits an {Approval} event.
746      *
747      * Requirements:
748      *
749      * - `owner` cannot be the zero address.
750      * - `spender` cannot be the zero address.
751      */
752     function _approve(address owner, address spender, uint256 amount) internal virtual {
753         require(owner != address(0), "ERC20: approve from the zero address");
754         require(spender != address(0), "ERC20: approve to the zero address");
755 
756         _allowances[owner][spender] = amount;
757         emit Approval(owner, spender, amount);
758     }
759 
760     /**
761      * @dev Sets {decimals} to a value other than the default one of 18.
762      *
763      * WARNING: This function should only be called from the constructor. Most
764      * applications that interact with token contracts will not expect
765      * {decimals} to ever change, and may work incorrectly if it does.
766      */
767     function _setupDecimals(uint8 decimals_) internal {
768         _decimals = decimals_;
769     }
770 
771     /**
772      * @dev Hook that is called before any transfer of tokens. This includes
773      * minting and burning.
774      *
775      * Calling conditions:
776      *
777      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
778      * will be to transferred to `to`.
779      * - when `from` is zero, `amount` tokens will be minted for `to`.
780      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
781      * - `from` and `to` are never both zero.
782      *
783      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
784      */
785     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
786 }
787 
788 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
789 
790 
791 pragma solidity ^0.6.0;
792 
793 
794 
795 /**
796  * @dev Extension of {ERC20} that allows token holders to destroy both their own
797  * tokens and those that they have an allowance for, in a way that can be
798  * recognized off-chain (via event analysis).
799  */
800 abstract contract ERC20Burnable is Context, ERC20 {
801     /**
802      * @dev Destroys `amount` tokens from the caller.
803      *
804      * See {ERC20-_burn}.
805      */
806     function burn(uint256 amount) public virtual {
807         _burn(_msgSender(), amount);
808     }
809 
810     /**
811      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
812      * allowance.
813      *
814      * See {ERC20-_burn} and {ERC20-allowance}.
815      *
816      * Requirements:
817      *
818      * - the caller must have allowance for ``accounts``'s tokens of at least
819      * `amount`.
820      */
821     function burnFrom(address account, uint256 amount) public virtual {
822         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
823 
824         _approve(account, _msgSender(), decreasedAllowance);
825         _burn(account, amount);
826     }
827 }
828 
829 // File: contracts/ReefToken.sol
830 
831 pragma solidity 0.6.12;
832 
833 
834 
835 
836 contract ReefToken is ERC20, Ownable, ERC20Burnable {
837     constructor() public ERC20("Reef.finance", "REEF") {
838     }
839 
840     function mint(address to, uint256 amount) public virtual onlyOwner {
841         _mint(to, amount);
842         _moveDelegates(address(0), _delegates[to], amount);
843     }
844 
845     // Copied and modified from YAM code:
846     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
847     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
848     // Which is copied and modified from COMPOUND:
849     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
850 
851     /// @notice A record of each accounts delegate
852     mapping (address => address) internal _delegates;
853 
854     /// @notice A checkpoint for marking number of votes from a given block
855     struct Checkpoint {
856         uint32 fromBlock;
857         uint256 votes;
858     }
859 
860     /// @notice A record of votes checkpoints for each account, by index
861     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
862 
863     /// @notice The number of checkpoints for each account
864     mapping (address => uint32) public numCheckpoints;
865 
866     /// @notice The EIP-712 typehash for the contract's domain
867     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
868 
869     /// @notice The EIP-712 typehash for the delegation struct used by the contract
870     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
871 
872     /// @notice A record of states for signing / validating signatures
873     mapping (address => uint) public nonces;
874 
875     /// @notice An event thats emitted when an account changes its delegate
876     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
877 
878     /// @notice An event thats emitted when a delegate account's vote balance changes
879     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
880 
881     /**
882      * @notice Delegate votes from `msg.sender` to `delegatee`
883      * @param delegator The address to get delegatee for
884      */
885     function delegates(address delegator)
886         external
887         view
888         returns (address)
889     {
890         return _delegates[delegator];
891     }
892 
893    /**
894     * @notice Delegate votes from `msg.sender` to `delegatee`
895     * @param delegatee The address to delegate votes to
896     */
897     function delegate(address delegatee) external {
898         return _delegate(msg.sender, delegatee);
899     }
900 
901     /**
902      * @notice Delegates votes from signatory to `delegatee`
903      * @param delegatee The address to delegate votes to
904      * @param nonce The contract state required to match the signature
905      * @param expiry The time at which to expire the signature
906      * @param v The recovery byte of the signature
907      * @param r Half of the ECDSA signature pair
908      * @param s Half of the ECDSA signature pair
909      */
910     function delegateBySig(
911         address delegatee,
912         uint nonce,
913         uint expiry,
914         uint8 v,
915         bytes32 r,
916         bytes32 s
917     )
918         external
919     {
920         bytes32 domainSeparator = keccak256(
921             abi.encode(
922                 DOMAIN_TYPEHASH,
923                 keccak256(bytes(name())),
924                 getChainId(),
925                 address(this)
926             )
927         );
928 
929         bytes32 structHash = keccak256(
930             abi.encode(
931                 DELEGATION_TYPEHASH,
932                 delegatee,
933                 nonce,
934                 expiry
935             )
936         );
937 
938         bytes32 digest = keccak256(
939             abi.encodePacked(
940                 "\x19\x01",
941                 domainSeparator,
942                 structHash
943             )
944         );
945 
946         address signatory = ecrecover(digest, v, r, s);
947         require(signatory != address(0), "REEF::delegateBySig: invalid signature");
948         require(nonce == nonces[signatory]++, "REEF::delegateBySig: invalid nonce");
949         require(now <= expiry, "REEF::delegateBySig: signature expired");
950         return _delegate(signatory, delegatee);
951     }
952 
953     /**
954      * @notice Gets the current votes balance for `account`
955      * @param account The address to get votes balance
956      * @return The number of current votes for `account`
957      */
958     function getCurrentVotes(address account)
959         external
960         view
961         returns (uint256)
962     {
963         uint32 nCheckpoints = numCheckpoints[account];
964         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
965     }
966 
967     /**
968      * @notice Determine the prior number of votes for an account as of a block number
969      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
970      * @param account The address of the account to check
971      * @param blockNumber The block number to get the vote balance at
972      * @return The number of votes the account had as of the given block
973      */
974     function getPriorVotes(address account, uint blockNumber)
975         external
976         view
977         returns (uint256)
978     {
979         require(blockNumber < block.number, "REEF::getPriorVotes: not yet determined");
980 
981         uint32 nCheckpoints = numCheckpoints[account];
982         if (nCheckpoints == 0) {
983             return 0;
984         }
985 
986         // First check most recent balance
987         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
988             return checkpoints[account][nCheckpoints - 1].votes;
989         }
990 
991         // Next check implicit zero balance
992         if (checkpoints[account][0].fromBlock > blockNumber) {
993             return 0;
994         }
995 
996         uint32 lower = 0;
997         uint32 upper = nCheckpoints - 1;
998         while (upper > lower) {
999             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1000             Checkpoint memory cp = checkpoints[account][center];
1001             if (cp.fromBlock == blockNumber) {
1002                 return cp.votes;
1003             } else if (cp.fromBlock < blockNumber) {
1004                 lower = center;
1005             } else {
1006                 upper = center - 1;
1007             }
1008         }
1009         return checkpoints[account][lower].votes;
1010     }
1011 
1012     function _delegate(address delegator, address delegatee)
1013         internal
1014     {
1015         address currentDelegate = _delegates[delegator];
1016         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying REEF (not scaled);
1017         _delegates[delegator] = delegatee;
1018 
1019         emit DelegateChanged(delegator, currentDelegate, delegatee);
1020 
1021         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1022     }
1023 
1024     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1025         if (srcRep != dstRep && amount > 0) {
1026             if (srcRep != address(0)) {
1027                 // decrease old representative
1028                 uint32 srcRepNum = numCheckpoints[srcRep];
1029                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1030                 uint256 srcRepNew = srcRepOld.sub(amount);
1031                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1032             }
1033 
1034             if (dstRep != address(0)) {
1035                 // increase new representative
1036                 uint32 dstRepNum = numCheckpoints[dstRep];
1037                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1038                 uint256 dstRepNew = dstRepOld.add(amount);
1039                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1040             }
1041         }
1042     }
1043 
1044     function _writeCheckpoint(
1045         address delegatee,
1046         uint32 nCheckpoints,
1047         uint256 oldVotes,
1048         uint256 newVotes
1049     )
1050         internal
1051     {
1052         uint32 blockNumber = safe32(block.number, "REEF::_writeCheckpoint: block number exceeds 32 bits");
1053 
1054         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1055             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1056         } else {
1057             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1058             numCheckpoints[delegatee] = nCheckpoints + 1;
1059         }
1060 
1061         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1062     }
1063 
1064     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1065         require(n < 2**32, errorMessage);
1066         return uint32(n);
1067     }
1068 
1069     function getChainId() internal pure returns (uint) {
1070         uint256 chainId;
1071         assembly { chainId := chainid() }
1072         return chainId;
1073     }
1074 }