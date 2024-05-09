1 // SPDX-License-Identifier: MIT
2 
3 /* 
4  * Pinky Promise Token 
5  * Developed by DevHound
6  */
7  
8 // Partial License: MIT
9 
10 pragma solidity ^0.6.0;
11 
12 /*
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with GSN meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 
34 // Partial License: MIT
35 
36 pragma solidity ^0.6.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 contract Ownable is Context {
51     
52     address private _owner;
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor () internal {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         emit OwnershipTransferred(_owner, newOwner);
98         _owner = newOwner;
99     }
100 }
101 
102 // Partial License: MIT
103 
104 pragma solidity ^0.6.0;
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109  
110 interface IERC20 {
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `recipient`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address recipient, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     /**
140      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * IMPORTANT: Beware that changing an allowance with this method brings the risk
145      * that someone may use both the old and the new allowance by unfortunate
146      * transaction ordering. One possible solution to mitigate this race
147      * condition is to first reduce the spender's allowance to 0 and set the
148      * desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Moves `amount` tokens from `sender` to `recipient` using the
157      * allowance mechanism. `amount` is then deducted from the caller's
158      * allowance.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Emitted when `value` tokens are moved from one account (`from`) to
168      * another (`to`).
169      *
170      * Note that `value` may be zero.
171      */
172     event Transfer(address indexed from, address indexed to, uint256 value);
173 
174     /**
175      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
176      * a call to {approve}. `value` is the new allowance.
177      */
178     event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 
182 // Partial License: MIT
183 
184 pragma solidity ^0.6.0;
185 
186 /**
187  * @dev Wrappers over Solidity's arithmetic operations with added overflow
188  * checks.
189  *
190  * Arithmetic operations in Solidity wrap on overflow. This can easily result
191  * in bugs, because programmers usually assume that an overflow raises an
192  * error, which is the standard behavior in high level programming languages.
193  * `SafeMath` restores this intuition by reverting the transaction when an
194  * operation overflows.
195  *
196  * Using this library instead of the unchecked operations eliminates an entire
197  * class of bugs, so it's recommended to use it always.
198  */
199 library SafeMath {
200     /**
201      * @dev Returns the addition of two unsigned integers, reverting on
202      * overflow.
203      *
204      * Counterpart to Solidity's `+` operator.
205      *
206      * Requirements:
207      *
208      * - Addition cannot overflow.
209      */
210     function add(uint256 a, uint256 b) internal pure returns (uint256) {
211         uint256 c = a + b;
212         require(c >= a, "SafeMath: addition overflow");
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the subtraction of two unsigned integers, reverting on
219      * overflow (when the result is negative).
220      *
221      * Counterpart to Solidity's `-` operator.
222      *
223      * Requirements:
224      *
225      * - Subtraction cannot overflow.
226      */
227     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
228         return sub(a, b, "SafeMath: subtraction overflow");
229     }
230 
231     /**
232      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
233      * overflow (when the result is negative).
234      *
235      * Counterpart to Solidity's `-` operator.
236      *
237      * Requirements:
238      *
239      * - Subtraction cannot overflow.
240      */
241     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b <= a, errorMessage);
243         uint256 c = a - b;
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the multiplication of two unsigned integers, reverting on
250      * overflow.
251      *
252      * Counterpart to Solidity's `*` operator.
253      *
254      * Requirements:
255      *
256      * - Multiplication cannot overflow.
257      */
258     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
259         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
260         // benefit is lost if 'b' is also tested.
261         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
262         if (a == 0) {
263             return 0;
264         }
265 
266         uint256 c = a * b;
267         require(c / a == b, "SafeMath: multiplication overflow");
268 
269         return c;
270     }
271 
272     /**
273      * @dev Returns the integer division of two unsigned integers. Reverts on
274      * division by zero. The result is rounded towards zero.
275      *
276      * Counterpart to Solidity's `/` operator. Note: this function uses a
277      * `revert` opcode (which leaves remaining gas untouched) while Solidity
278      * uses an invalid opcode to revert (consuming all remaining gas).
279      *
280      * Requirements:
281      *
282      * - The divisor cannot be zero.
283      */
284     function div(uint256 a, uint256 b) internal pure returns (uint256) {
285         return div(a, b, "SafeMath: division by zero");
286     }
287 
288     /**
289      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
290      * division by zero. The result is rounded towards zero.
291      *
292      * Counterpart to Solidity's `/` operator. Note: this function uses a
293      * `revert` opcode (which leaves remaining gas untouched) while Solidity
294      * uses an invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
301         require(b > 0, errorMessage);
302         uint256 c = a / b;
303         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
304 
305         return c;
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * Reverts when dividing by zero.
311      *
312      * Counterpart to Solidity's `%` operator. This function uses a `revert`
313      * opcode (which leaves remaining gas untouched) while Solidity uses an
314      * invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
321         return mod(a, b, "SafeMath: modulo by zero");
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * Reverts with custom message when dividing by zero.
327      *
328      * Counterpart to Solidity's `%` operator. This function uses a `revert`
329      * opcode (which leaves remaining gas untouched) while Solidity uses an
330      * invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      *
334      * - The divisor cannot be zero.
335      */
336     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
337         require(b != 0, errorMessage);
338         return a % b;
339     }
340 }
341 
342 
343 // Partial License: MIT
344 
345 pragma solidity ^0.6.2;
346 
347 /**
348  * @dev Collection of functions related to the address type
349  */
350 library Address {
351     /**
352      * @dev Returns true if `account` is a contract.
353      *
354      * [IMPORTANT]
355      * ====
356      * It is unsafe to assume that an address for which this function returns
357      * false is an externally-owned account (EOA) and not a contract.
358      *
359      * Among others, `isContract` will return false for the following
360      * types of addresses:
361      *
362      *  - an externally-owned account
363      *  - a contract in construction
364      *  - an address where a contract will be created
365      *  - an address where a contract lived, but was destroyed
366      * ====
367      */
368     function isContract(address account) internal view returns (bool) {
369         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
370         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
371         // for accounts without code, i.e. `keccak256('')`
372         bytes32 codehash;
373         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
374         // solhint-disable-next-line no-inline-assembly
375         assembly { codehash := extcodehash(account) }
376         return (codehash != accountHash && codehash != 0x0);
377     }
378 
379     /**
380      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
381      * `recipient`, forwarding all available gas and reverting on errors.
382      *
383      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
384      * of certain opcodes, possibly making contracts go over the 2300 gas limit
385      * imposed by `transfer`, making them unable to receive funds via
386      * `transfer`. {sendValue} removes this limitation.
387      *
388      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
389      *
390      * IMPORTANT: because control is transferred to `recipient`, care must be
391      * taken to not create reentrancy vulnerabilities. Consider using
392      * {ReentrancyGuard} or the
393      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
394      */
395     function sendValue(address payable recipient, uint256 amount) internal {
396         require(address(this).balance >= amount, "Address: insufficient balance");
397 
398         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
399         (bool success, ) = recipient.call{ value: amount }("");
400         require(success, "Address: unable to send value, recipient may have reverted");
401     }
402 
403     /**
404      * @dev Performs a Solidity function call using a low level `call`. A
405      * plain`call` is an unsafe replacement for a function call: use this
406      * function instead.
407      *
408      * If `target` reverts with a revert reason, it is bubbled up by this
409      * function (like regular Solidity function calls).
410      *
411      * Returns the raw returned data. To convert to the expected return value,
412      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
413      *
414      * Requirements:
415      *
416      * - `target` must be a contract.
417      * - calling `target` with `data` must not revert.
418      *
419      * _Available since v3.1._
420      */
421     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
422       return functionCall(target, data, "Address: low-level call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
427      * `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
432         return _functionCallWithValue(target, data, 0, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but also transferring `value` wei to `target`.
438      *
439      * Requirements:
440      *
441      * - the calling contract must have an ETH balance of at least `value`.
442      * - the called Solidity function must be `payable`.
443      *
444      * _Available since v3.1._
445      */
446     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
447         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
452      * with `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
457         require(address(this).balance >= value, "Address: insufficient balance for call");
458         return _functionCallWithValue(target, data, value, errorMessage);
459     }
460 
461     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
462         require(isContract(target), "Address: call to non-contract");
463 
464         // solhint-disable-next-line avoid-low-level-calls
465         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
466         if (success) {
467             return returndata;
468         } else {
469             // Look for revert reason and bubble it up if present
470             if (returndata.length > 0) {
471                 // The easiest way to bubble the revert reason is using memory via assembly
472 
473                 // solhint-disable-next-line no-inline-assembly
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 
486 // Partial License: MIT
487 
488 pragma solidity ^0.6.0;
489 
490 /**
491  * @dev Implementation of the {IERC20} interface.
492  *
493  * This implementation is agnostic to the way tokens are created. This means
494  * that a supply mechanism has to be added in a derived contract using {_mint}.
495  * For a generic mechanism see {ERC20PresetMinterPauser}.
496  *
497  * TIP: For a detailed writeup see our guide
498  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
499  * to implement supply mechanisms].
500  *
501  * We have followed general OpenZeppelin guidelines: functions revert instead
502  * of returning `false` on failure. This behavior is nonetheless conventional
503  * and does not conflict with the expectations of ERC20 applications.
504  *
505  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
506  * This allows applications to reconstruct the allowance for all accounts just
507  * by listening to said events. Other implementations of the EIP may not emit
508  * these events, as it isn't required by the specification.
509  *
510  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
511  * functions have been added to mitigate the well-known issues around setting
512  * allowances. See {IERC20-approve}.
513  */
514 contract ERC20 is Context, IERC20 {
515     using SafeMath for uint256;
516     using Address for address;
517 
518     mapping (address => uint256) private _balances;
519 
520     mapping (address => mapping (address => uint256)) private _allowances;
521 
522     uint256 private _totalSupply;
523     uint256 public _minimumSupply = 5000000000000000000000;
524     uint256 public BURN_RATE = 2;
525     uint256 constant public PERCENTS_DIVIDER = 100;
526 
527     string private _name;
528     string private _symbol;
529     uint8 private _decimals;
530 
531     /**
532      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
533      * a default value of 18.
534      *
535      * To select a different value for {decimals}, use {_setupDecimals}.
536      *
537      * All three of these values are immutable: they can only be set once during
538      * construction.
539      */
540     constructor (string memory name, string memory symbol) public {
541         _name = name;
542         _symbol = symbol;
543         _decimals = 18;
544     }
545 
546     /**
547      * @dev Returns the name of the token.
548      */
549     function name() public view returns (string memory) {
550         return _name;
551     }
552 
553     /**
554      * @dev Returns the symbol of the token, usually a shorter version of the
555      * name.
556      */
557     function symbol() public view returns (string memory) {
558         return _symbol;
559     }
560 
561     /**
562      * @dev Returns the number of decimals used to get its user representation.
563      * For example, if `decimals` equals `2`, a balance of `505` tokens should
564      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
565      *
566      * Tokens usually opt for a value of 18, imitating the relationship between
567      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
568      * called.
569      *
570      * NOTE: This information is only used for _display_ purposes: it in
571      * no way affects any of the arithmetic of the contract, including
572      * {IERC20-balanceOf} and {IERC20-transfer}.
573      */
574     function decimals() public view returns (uint8) {
575         return _decimals;
576     }
577 
578     /**
579      * @dev See {IERC20-totalSupply}.
580      */
581     function totalSupply() public view override returns (uint256) {
582         return _totalSupply;
583     }
584     
585     /**
586      * @dev See {IERC20-minimumSupply}.
587      */
588     function minimumSupply() public view returns (uint256) {
589         return _minimumSupply;
590     }
591 
592     /**
593      * @dev See {IERC20-balanceOf}.
594      */
595     function balanceOf(address account) public view override returns (uint256) {
596         return _balances[account];
597     }
598 
599     /**
600      * @dev See {IERC20-transfer}.
601      *
602      * Requirements:
603      *
604      * - `recipient` cannot be the zero address.
605      * - the caller must have a balance of at least `amount`.
606      */
607     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
608         _transfer(_msgSender(), recipient, amount);
609         return true;
610     }
611 
612     /**
613      * @dev See {IERC20-allowance}.
614      */
615     function allowance(address owner, address spender) public view virtual override returns (uint256) {
616         return _allowances[owner][spender];
617     }
618 
619     /**
620      * @dev See {IERC20-approve}.
621      *
622      * Requirements:
623      *
624      * - `spender` cannot be the zero address.
625      */
626     function approve(address spender, uint256 amount) public virtual override returns (bool) {
627         _approve(_msgSender(), spender, amount);
628         return true;
629     }
630 
631     /**
632      * @dev See {IERC20-transferFrom}.
633      *
634      * Emits an {Approval} event indicating the updated allowance. This is not
635      * required by the EIP. See the note at the beginning of {ERC20};
636      *
637      * Requirements:
638      * - `sender` and `recipient` cannot be the zero address.
639      * - `sender` must have a balance of at least `amount`.
640      * - the caller must have allowance for ``sender``'s tokens of at least
641      * `amount`.
642      */
643     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
644         _transfer(sender, recipient, amount);
645         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
646         return true;
647     }
648 
649     /**
650      * @dev Atomically increases the allowance granted to `spender` by the caller.
651      *
652      * This is an alternative to {approve} that can be used as a mitigation for
653      * problems described in {IERC20-approve}.
654      *
655      * Emits an {Approval} event indicating the updated allowance.
656      *
657      * Requirements:
658      *
659      * - `spender` cannot be the zero address.
660      */
661     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
662         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
663         return true;
664     }
665 
666     /**
667      * @dev Atomically decreases the allowance granted to `spender` by the caller.
668      *
669      * This is an alternative to {approve} that can be used as a mitigation for
670      * problems described in {IERC20-approve}.
671      *
672      * Emits an {Approval} event indicating the updated allowance.
673      *
674      * Requirements:
675      *
676      * - `spender` cannot be the zero address.
677      * - `spender` must have allowance for the caller of at least
678      * `subtractedValue`.
679      */
680     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
681         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
682         return true;
683     }
684 
685     /**
686      * @dev Moves tokens `amount` from `sender` to `recipient`.
687      *
688      * This is internal function is equivalent to {transfer}, and can be used to
689      * e.g. implement automatic token fees, slashing mechanisms, etc.
690      *
691      * Emits a {Transfer} event.
692      *
693      * Requirements:
694      *
695      * - `sender` cannot be the zero address.
696      * - `recipient` cannot be the zero address.
697      * - `sender` must have a balance of at least `amount`.
698      */
699     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
700         require(sender != address(0), "ERC20: transfer from the zero address");
701         require(recipient != address(0), "ERC20: transfer to the zero address");
702 
703         _beforeTokenTransfer(sender, recipient, amount);
704 
705         uint256 remainingAmount = amount;
706         if(_totalSupply > _minimumSupply) {
707             if(BURN_RATE > 0) {
708                 uint256 burnAmount = amount.mul(BURN_RATE).div(PERCENTS_DIVIDER);
709                 _burn(sender, burnAmount);
710                 remainingAmount = remainingAmount.sub(burnAmount);
711             }
712         }
713         _balances[sender] = _balances[sender].sub(remainingAmount, "ERC20: transfer amount exceeds balance");
714         _balances[recipient] = _balances[recipient].add(remainingAmount);
715         emit Transfer(sender, recipient, remainingAmount);
716     }
717 
718     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
719      * the total supply.
720      *
721      * Emits a {Transfer} event with `from` set to the zero address.
722      *
723      * Requirements
724      *
725      * - `to` cannot be the zero address.
726      */
727     function _mint(address account, uint256 amount) internal virtual {
728         require(account != address(0), "ERC20: mint to the zero address");
729 
730         _beforeTokenTransfer(address(0), account, amount);
731 
732         _totalSupply = _totalSupply.add(amount);
733         _balances[account] = _balances[account].add(amount);
734         emit Transfer(address(0), account, amount);
735     }
736 
737     /**
738      * @dev Destroys `amount` tokens from `account`, reducing the
739      * total supply.
740      *
741      * Emits a {Transfer} event with `to` set to the zero address.
742      *
743      * Requirements
744      *
745      * - `account` cannot be the zero address.
746      * - `account` must have at least `amount` tokens.
747      */
748     function _burn(address account, uint256 amount) internal virtual {
749         require(account != address(0), "ERC20: burn from the zero address");
750 
751         _beforeTokenTransfer(account, address(0), amount);
752 
753         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
754         _totalSupply = _totalSupply.sub(amount);
755         emit Transfer(account, address(0), amount);
756     }
757 
758     /**
759      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
760      *
761      * This is internal function is equivalent to `approve`, and can be used to
762      * e.g. set automatic allowances for certain subsystems, etc.
763      *
764      * Emits an {Approval} event.
765      *
766      * Requirements:
767      *
768      * - `owner` cannot be the zero address.
769      * - `spender` cannot be the zero address.
770      */
771     function _approve(address owner, address spender, uint256 amount) internal virtual {
772         require(owner != address(0), "ERC20: approve from the zero address");
773         require(spender != address(0), "ERC20: approve to the zero address");
774 
775         _allowances[owner][spender] = amount;
776         emit Approval(owner, spender, amount);
777     }
778 
779     /**
780      * @dev Sets {decimals} to a value other than the default one of 18.
781      *
782      * WARNING: This function should only be called from the constructor. Most
783      * applications that interact with token contracts will not expect
784      * {decimals} to ever change, and may work incorrectly if it does.
785      */
786     function _setupDecimals(uint8 decimals_) internal {
787         _decimals = decimals_;
788     }
789 
790     /**
791      * @dev Hook that is called before any transfer of tokens. This includes
792      * minting and burning.
793      *
794      * Calling conditions:
795      *
796      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
797      * will be to transferred to `to`.
798      * - when `from` is zero, `amount` tokens will be minted for `to`.
799      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
800      * - `from` and `to` are never both zero.
801      *
802      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
803      */
804     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
805 }
806 
807 
808 // Partial License: MIT
809 
810 pragma solidity ^0.6.0;
811 
812 /**
813  * @dev Extension of {ERC20} that allows token holders to destroy both their own
814  * tokens and those that they have an allowance for, in a way that can be
815  * recognized off-chain (via event analysis).
816  */
817 abstract contract ERC20Burnable is Context, ERC20 {
818     /**
819      * @dev Destroys `amount` tokens from the caller.
820      *
821      * See {ERC20-_burn}.
822      */
823     function burn(uint256 amount) public virtual {
824         _burn(_msgSender(), amount);
825     }
826 
827     /**
828      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
829      * allowance.
830      *
831      * See {ERC20-_burn} and {ERC20-allowance}.
832      *
833      * Requirements:
834      *
835      * - the caller must have allowance for ``accounts``'s tokens of at least
836      * `amount`.
837      */
838     function burnFrom(address account, uint256 amount) public virtual {
839         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
840 
841         _approve(account, _msgSender(), decreasedAllowance);
842         _burn(account, amount);
843     }
844 }
845 
846 
847 // Partial License: MIT
848 
849 pragma solidity ^0.6.0;
850 
851 /**
852  * @dev Library for managing
853  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
854  * types.
855  *
856  * Sets have the following properties:
857  *
858  * - Elements are added, removed, and checked for existence in constant time
859  * (O(1)).
860  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
861  *
862  * ```
863  * contract Example {
864  *     // Add the library methods
865  *     using EnumerableSet for EnumerableSet.AddressSet;
866  *
867  *     // Declare a set state variable
868  *     EnumerableSet.AddressSet private mySet;
869  * }
870  * ```
871  *
872  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
873  * (`UintSet`) are supported.
874  */
875 library EnumerableSet {
876     // To implement this library for multiple types with as little code
877     // repetition as possible, we write it in terms of a generic Set type with
878     // bytes32 values.
879     // The Set implementation uses private functions, and user-facing
880     // implementations (such as AddressSet) are just wrappers around the
881     // underlying Set.
882     // This means that we can only create new EnumerableSets for types that fit
883     // in bytes32.
884 
885     struct Set {
886         // Storage of set values
887         bytes32[] _values;
888 
889         // Position of the value in the `values` array, plus 1 because index 0
890         // means a value is not in the set.
891         mapping (bytes32 => uint256) _indexes;
892     }
893 
894     /**
895      * @dev Add a value to a set. O(1).
896      *
897      * Returns true if the value was added to the set, that is if it was not
898      * already present.
899      */
900     function _add(Set storage set, bytes32 value) private returns (bool) {
901         if (!_contains(set, value)) {
902             set._values.push(value);
903             // The value is stored at length-1, but we add 1 to all indexes
904             // and use 0 as a sentinel value
905             set._indexes[value] = set._values.length;
906             return true;
907         } else {
908             return false;
909         }
910     }
911 
912     /**
913      * @dev Removes a value from a set. O(1).
914      *
915      * Returns true if the value was removed from the set, that is if it was
916      * present.
917      */
918     function _remove(Set storage set, bytes32 value) private returns (bool) {
919         // We read and store the value's index to prevent multiple reads from the same storage slot
920         uint256 valueIndex = set._indexes[value];
921 
922         if (valueIndex != 0) { // Equivalent to contains(set, value)
923             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
924             // the array, and then remove the last element (sometimes called as 'swap and pop').
925             // This modifies the order of the array, as noted in {at}.
926 
927             uint256 toDeleteIndex = valueIndex - 1;
928             uint256 lastIndex = set._values.length - 1;
929 
930             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
931             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
932 
933             bytes32 lastvalue = set._values[lastIndex];
934 
935             // Move the last value to the index where the value to delete is
936             set._values[toDeleteIndex] = lastvalue;
937             // Update the index for the moved value
938             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
939 
940             // Delete the slot where the moved value was stored
941             set._values.pop();
942 
943             // Delete the index for the deleted slot
944             delete set._indexes[value];
945 
946             return true;
947         } else {
948             return false;
949         }
950     }
951 
952     /**
953      * @dev Returns true if the value is in the set. O(1).
954      */
955     function _contains(Set storage set, bytes32 value) private view returns (bool) {
956         return set._indexes[value] != 0;
957     }
958 
959     /**
960      * @dev Returns the number of values on the set. O(1).
961      */
962     function _length(Set storage set) private view returns (uint256) {
963         return set._values.length;
964     }
965 
966    /**
967     * @dev Returns the value stored at position `index` in the set. O(1).
968     *
969     * Note that there are no guarantees on the ordering of values inside the
970     * array, and it may change when more values are added or removed.
971     *
972     * Requirements:
973     *
974     * - `index` must be strictly less than {length}.
975     */
976     function _at(Set storage set, uint256 index) private view returns (bytes32) {
977         require(set._values.length > index, "EnumerableSet: index out of bounds");
978         return set._values[index];
979     }
980 
981     // AddressSet
982 
983     struct AddressSet {
984         Set _inner;
985     }
986 
987     /**
988      * @dev Add a value to a set. O(1).
989      *
990      * Returns true if the value was added to the set, that is if it was not
991      * already present.
992      */
993     function add(AddressSet storage set, address value) internal returns (bool) {
994         return _add(set._inner, bytes32(uint256(value)));
995     }
996 
997     /**
998      * @dev Removes a value from a set. O(1).
999      *
1000      * Returns true if the value was removed from the set, that is if it was
1001      * present.
1002      */
1003     function remove(AddressSet storage set, address value) internal returns (bool) {
1004         return _remove(set._inner, bytes32(uint256(value)));
1005     }
1006 
1007     /**
1008      * @dev Returns true if the value is in the set. O(1).
1009      */
1010     function contains(AddressSet storage set, address value) internal view returns (bool) {
1011         return _contains(set._inner, bytes32(uint256(value)));
1012     }
1013 
1014     /**
1015      * @dev Returns the number of values in the set. O(1).
1016      */
1017     function length(AddressSet storage set) internal view returns (uint256) {
1018         return _length(set._inner);
1019     }
1020 
1021    /**
1022     * @dev Returns the value stored at position `index` in the set. O(1).
1023     *
1024     * Note that there are no guarantees on the ordering of values inside the
1025     * array, and it may change when more values are added or removed.
1026     *
1027     * Requirements:
1028     *
1029     * - `index` must be strictly less than {length}.
1030     */
1031     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1032         return address(uint256(_at(set._inner, index)));
1033     }
1034 
1035 
1036     // UintSet
1037 
1038     struct UintSet {
1039         Set _inner;
1040     }
1041 
1042     /**
1043      * @dev Add a value to a set. O(1).
1044      *
1045      * Returns true if the value was added to the set, that is if it was not
1046      * already present.
1047      */
1048     function add(UintSet storage set, uint256 value) internal returns (bool) {
1049         return _add(set._inner, bytes32(value));
1050     }
1051 
1052     /**
1053      * @dev Removes a value from a set. O(1).
1054      *
1055      * Returns true if the value was removed from the set, that is if it was
1056      * present.
1057      */
1058     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1059         return _remove(set._inner, bytes32(value));
1060     }
1061 
1062     /**
1063      * @dev Returns true if the value is in the set. O(1).
1064      */
1065     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1066         return _contains(set._inner, bytes32(value));
1067     }
1068 
1069     /**
1070      * @dev Returns the number of values on the set. O(1).
1071      */
1072     function length(UintSet storage set) internal view returns (uint256) {
1073         return _length(set._inner);
1074     }
1075 
1076     /**
1077     * @dev Returns the value stored at position `index` in the set. O(1).
1078     *
1079     * Note that there are no guarantees on the ordering of values inside the
1080     * array, and it may change when more values are added or removed.
1081     *
1082     * Requirements:
1083     *
1084     * - `index` must be strictly less than {length}.
1085     */
1086     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1087         return uint256(_at(set._inner, index));
1088     }
1089 }
1090 
1091 
1092 // Partial License: MIT
1093 
1094 pragma solidity ^0.6.0;
1095 
1096 /**
1097  * @dev Contract module that allows children to implement role-based access
1098  * control mechanisms.
1099  *
1100  * Roles are referred to by their `bytes32` identifier. These should be exposed
1101  * in the external API and be unique. The best way to achieve this is by
1102  * using `public constant` hash digests:
1103  *
1104  * ```
1105  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1106  * ```
1107  *
1108  * Roles can be used to represent a set of permissions. To restrict access to a
1109  * function call, use {hasRole}:
1110  *
1111  * ```
1112  * function foo() public {
1113  *     require(hasRole(MY_ROLE, msg.sender));
1114  *     ...
1115  * }
1116  * ```
1117  *
1118  * Roles can be granted and revoked dynamically via the {grantRole} and
1119  * {revokeRole} functions. Each role has an associated admin role, and only
1120  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1121  *
1122  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1123  * that only accounts with this role will be able to grant or revoke other
1124  * roles. More complex role relationships can be created by using
1125  * {_setRoleAdmin}.
1126  *
1127  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1128  * grant and revoke this role. Extra precautions should be taken to secure
1129  * accounts that have been granted it.
1130  */
1131 abstract contract AccessControl is Context {
1132     using EnumerableSet for EnumerableSet.AddressSet;
1133     using Address for address;
1134 
1135     struct RoleData {
1136         EnumerableSet.AddressSet members;
1137         bytes32 adminRole;
1138     }
1139 
1140     mapping (bytes32 => RoleData) private _roles;
1141 
1142     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1143 
1144     /**
1145      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1146      *
1147      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1148      * {RoleAdminChanged} not being emitted signaling this.
1149      *
1150      * _Available since v3.1._
1151      */
1152     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1153 
1154     /**
1155      * @dev Emitted when `account` is granted `role`.
1156      *
1157      * `sender` is the account that originated the contract call, an admin role
1158      * bearer except when using {_setupRole}.
1159      */
1160     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1161 
1162     /**
1163      * @dev Emitted when `account` is revoked `role`.
1164      *
1165      * `sender` is the account that originated the contract call:
1166      *   - if using `revokeRole`, it is the admin role bearer
1167      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1168      */
1169     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1170 
1171     /**
1172      * @dev Returns `true` if `account` has been granted `role`.
1173      */
1174     function hasRole(bytes32 role, address account) public view returns (bool) {
1175         return _roles[role].members.contains(account);
1176     }
1177 
1178     /**
1179      * @dev Returns the number of accounts that have `role`. Can be used
1180      * together with {getRoleMember} to enumerate all bearers of a role.
1181      */
1182     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1183         return _roles[role].members.length();
1184     }
1185 
1186     /**
1187      * @dev Returns one of the accounts that have `role`. `index` must be a
1188      * value between 0 and {getRoleMemberCount}, non-inclusive.
1189      *
1190      * Role bearers are not sorted in any particular way, and their ordering may
1191      * change at any point.
1192      *
1193      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1194      * you perform all queries on the same block. See the following
1195      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1196      * for more information.
1197      */
1198     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1199         return _roles[role].members.at(index);
1200     }
1201 
1202     /**
1203      * @dev Returns the admin role that controls `role`. See {grantRole} and
1204      * {revokeRole}.
1205      *
1206      * To change a role's admin, use {_setRoleAdmin}.
1207      */
1208     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1209         return _roles[role].adminRole;
1210     }
1211 
1212     /**
1213      * @dev Grants `role` to `account`.
1214      *
1215      * If `account` had not been already granted `role`, emits a {RoleGranted}
1216      * event.
1217      *
1218      * Requirements:
1219      *
1220      * - the caller must have ``role``'s admin role.
1221      */
1222     function grantRole(bytes32 role, address account) public virtual {
1223         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1224 
1225         _grantRole(role, account);
1226     }
1227 
1228     /**
1229      * @dev Revokes `role` from `account`.
1230      *
1231      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1232      *
1233      * Requirements:
1234      *
1235      * - the caller must have ``role``'s admin role.
1236      */
1237     function revokeRole(bytes32 role, address account) public virtual {
1238         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1239 
1240         _revokeRole(role, account);
1241     }
1242 
1243     /**
1244      * @dev Revokes `role` from the calling account.
1245      *
1246      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1247      * purpose is to provide a mechanism for accounts to lose their privileges
1248      * if they are compromised (such as when a trusted device is misplaced).
1249      *
1250      * If the calling account had been granted `role`, emits a {RoleRevoked}
1251      * event.
1252      *
1253      * Requirements:
1254      *
1255      * - the caller must be `account`.
1256      */
1257     function renounceRole(bytes32 role, address account) public virtual {
1258         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1259 
1260         _revokeRole(role, account);
1261     }
1262 
1263     /**
1264      * @dev Grants `role` to `account`.
1265      *
1266      * If `account` had not been already granted `role`, emits a {RoleGranted}
1267      * event. Note that unlike {grantRole}, this function doesn't perform any
1268      * checks on the calling account.
1269      *
1270      * [WARNING]
1271      * ====
1272      * This function should only be called from the constructor when setting
1273      * up the initial roles for the system.
1274      *
1275      * Using this function in any other way is effectively circumventing the admin
1276      * system imposed by {AccessControl}.
1277      * ====
1278      */
1279     function _setupRole(bytes32 role, address account) internal virtual {
1280         _grantRole(role, account);
1281     }
1282 
1283     /**
1284      * @dev Sets `adminRole` as ``role``'s admin role.
1285      *
1286      * Emits a {RoleAdminChanged} event.
1287      */
1288     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1289         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1290         _roles[role].adminRole = adminRole;
1291     }
1292 
1293     function _grantRole(bytes32 role, address account) private {
1294         if (_roles[role].members.add(account)) {
1295             emit RoleGranted(role, account, _msgSender());
1296         }
1297     }
1298 
1299     function _revokeRole(bytes32 role, address account) private {
1300         if (_roles[role].members.remove(account)) {
1301             emit RoleRevoked(role, account, _msgSender());
1302         }
1303     }
1304 }
1305 
1306 
1307 // Partial License: MIT
1308 
1309 pragma solidity ^0.6.0;
1310 
1311 /**
1312  * @dev Standard math utilities missing in the Solidity language.
1313  */
1314 library Math {
1315     /**
1316      * @dev Returns the largest of two numbers.
1317      */
1318     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1319         return a >= b ? a : b;
1320     }
1321 
1322     /**
1323      * @dev Returns the smallest of two numbers.
1324      */
1325     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1326         return a < b ? a : b;
1327     }
1328 
1329     /**
1330      * @dev Returns the average of two numbers. The result is rounded towards
1331      * zero.
1332      */
1333     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1334         // (a + b) / 2 can overflow, so we distribute
1335         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1336     }
1337 }
1338 
1339 
1340 // Partial License: MIT
1341 
1342 pragma solidity ^0.6.0;
1343 
1344 /**
1345  * @dev Collection of functions related to array types.
1346  */
1347 library Arrays {
1348    /**
1349      * @dev Searches a sorted `array` and returns the first index that contains
1350      * a value greater or equal to `element`. If no such index exists (i.e. all
1351      * values in the array are strictly less than `element`), the array length is
1352      * returned. Time complexity O(log n).
1353      *
1354      * `array` is expected to be sorted in ascending order, and to contain no
1355      * repeated elements.
1356      */
1357     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
1358         if (array.length == 0) {
1359             return 0;
1360         }
1361 
1362         uint256 low = 0;
1363         uint256 high = array.length;
1364 
1365         while (low < high) {
1366             uint256 mid = Math.average(low, high);
1367 
1368             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
1369             // because Math.average rounds down (it does integer division with truncation).
1370             if (array[mid] > element) {
1371                 high = mid;
1372             } else {
1373                 low = mid + 1;
1374             }
1375         }
1376 
1377         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1378         if (low > 0 && array[low - 1] == element) {
1379             return low - 1;
1380         } else {
1381             return low;
1382         }
1383     }
1384 }
1385 
1386 
1387 // Partial License: MIT
1388 
1389 pragma solidity ^0.6.0;
1390 
1391 /**
1392  * @title Counters
1393  * @author Matt Condon (@shrugs)
1394  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1395  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1396  *
1397  * Include with `using Counters for Counters.Counter;`
1398  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1399  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1400  * directly accessed.
1401  */
1402 library Counters {
1403     using SafeMath for uint256;
1404 
1405     struct Counter {
1406         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1407         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1408         // this feature: see https://github.com/ethereum/solidity/issues/4637
1409         uint256 _value; // default: 0
1410     }
1411 
1412     function current(Counter storage counter) internal view returns (uint256) {
1413         return counter._value;
1414     }
1415 
1416     function increment(Counter storage counter) internal {
1417         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1418         counter._value += 1;
1419     }
1420 
1421     function decrement(Counter storage counter) internal {
1422         counter._value = counter._value.sub(1);
1423     }
1424 }
1425 
1426 
1427 // Partial License: MIT
1428 
1429 pragma solidity ^0.6.0;
1430 
1431 /**
1432  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1433  * total supply at the time are recorded for later access.
1434  *
1435  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1436  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1437  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1438  * used to create an efficient ERC20 forking mechanism.
1439  *
1440  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1441  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1442  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1443  * and the account address.
1444  *
1445  * ==== Gas Costs
1446  *
1447  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1448  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1449  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1450  *
1451  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1452  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1453  * transfers will have normal cost until the next snapshot, and so on.
1454  */
1455 abstract contract ERC20Snapshot is ERC20 {
1456     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1457     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1458 
1459     using SafeMath for uint256;
1460     using Arrays for uint256[];
1461     using Counters for Counters.Counter;
1462 
1463     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1464     // Snapshot struct, but that would impede usage of functions that work on an array.
1465     struct Snapshots {
1466         uint256[] ids;
1467         uint256[] values;
1468     }
1469 
1470     mapping (address => Snapshots) private _accountBalanceSnapshots;
1471     Snapshots private _totalSupplySnapshots;
1472 
1473     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1474     Counters.Counter private _currentSnapshotId;
1475 
1476     /**
1477      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1478      */
1479     event Snapshot(uint256 id);
1480 
1481     /**
1482      * @dev Creates a new snapshot and returns its snapshot id.
1483      *
1484      * Emits a {Snapshot} event that contains the same id.
1485      *
1486      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1487      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1488      *
1489      * [WARNING]
1490      * ====
1491      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1492      * you must consider that it can potentially be used by attackers in two ways.
1493      *
1494      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1495      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1496      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1497      * section above.
1498      *
1499      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1500      * ====
1501      */
1502     function _snapshot() internal virtual returns (uint256) {
1503         _currentSnapshotId.increment();
1504 
1505         uint256 currentId = _currentSnapshotId.current();
1506         emit Snapshot(currentId);
1507         return currentId;
1508     }
1509 
1510     /**
1511      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1512      */
1513     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
1514         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1515 
1516         return snapshotted ? value : balanceOf(account);
1517     }
1518 
1519     /**
1520      * @dev Retrieves the total supply at the time `snapshotId` was created.
1521      */
1522     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
1523         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1524 
1525         return snapshotted ? value : totalSupply();
1526     }
1527 
1528     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
1529     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
1530     // The same is true for the total supply and _mint and _burn.
1531     function _transfer(address from, address to, uint256 value) internal virtual override {
1532         _updateAccountSnapshot(from);
1533         _updateAccountSnapshot(to);
1534 
1535         super._transfer(from, to, value);
1536     }
1537 
1538     function _mint(address account, uint256 value) internal virtual override {
1539         _updateAccountSnapshot(account);
1540         _updateTotalSupplySnapshot();
1541 
1542         super._mint(account, value);
1543     }
1544 
1545     function _burn(address account, uint256 value) internal virtual override {
1546         _updateAccountSnapshot(account);
1547         _updateTotalSupplySnapshot();
1548 
1549         super._burn(account, value);
1550     }
1551 
1552     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
1553         private view returns (bool, uint256)
1554     {
1555         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1556         // solhint-disable-next-line max-line-length
1557         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
1558 
1559         // When a valid snapshot is queried, there are three possibilities:
1560         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1561         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1562         //  to this id is the current one.
1563         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1564         //  requested id, and its value is the one to return.
1565         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1566         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1567         //  larger than the requested one.
1568         //
1569         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1570         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1571         // exactly this.
1572 
1573         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1574 
1575         if (index == snapshots.ids.length) {
1576             return (false, 0);
1577         } else {
1578             return (true, snapshots.values[index]);
1579         }
1580     }
1581 
1582     function _updateAccountSnapshot(address account) private {
1583         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1584     }
1585 
1586     function _updateTotalSupplySnapshot() private {
1587         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1588     }
1589 
1590     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1591         uint256 currentId = _currentSnapshotId.current();
1592         if (_lastSnapshotId(snapshots.ids) < currentId) {
1593             snapshots.ids.push(currentId);
1594             snapshots.values.push(currentValue);
1595         }
1596     }
1597 
1598     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1599         if (ids.length == 0) {
1600             return 0;
1601         } else {
1602             return ids[ids.length - 1];
1603         }
1604     }
1605 }
1606 
1607 
1608 pragma solidity ^0.6.0;
1609 
1610 abstract contract CMERC20Snapshot is Context, AccessControl, ERC20Snapshot {
1611 
1612     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1613     
1614     function snapshot() public {
1615         require(hasRole(SNAPSHOT_ROLE, _msgSender()), "ERC20Snapshot: must have snapshotter role to snapshot");
1616         _snapshot();
1617     }
1618 
1619 }
1620 
1621 
1622 pragma solidity ^0.6.0;
1623 
1624 // imports
1625 
1626 contract PINKY is ERC20Burnable, CMERC20Snapshot {
1627 
1628     constructor(string memory name, string memory symbol, uint256 amount, uint8 decimals) ERC20(name, symbol) public payable {
1629         _setupDecimals(decimals);
1630         _mint(msg.sender, amount);
1631         
1632         // set up required roles
1633         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1634         _setupRole(SNAPSHOT_ROLE, _msgSender());
1635     }
1636 
1637     
1638     // overrides
1639     function _burn(address account, uint256 value) internal override(ERC20, ERC20Snapshot) {
1640         super._burn(account, value);
1641     }
1642 
1643     function _mint(address account, uint256 value) internal override(ERC20, ERC20Snapshot) {
1644         super._mint(account, value);
1645     }
1646 
1647     function _transfer(address from, address to, uint256 value)internal override(ERC20, ERC20Snapshot) {
1648         super._transfer(from, to, value);
1649     }
1650 }