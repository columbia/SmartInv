1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
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
28 // File: contracts/Owned.sol
29 
30 
31 
32 pragma solidity 0.6.12;
33 
34 
35 // Requried one small change in openzeppelin version of ownable, so imported
36 // source code here. Notice line 26 for change.
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
51     /**
52      * @dev Changed _owner from 'private' to 'internal'
53      */
54     address internal _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59      * @dev Initializes the contract setting the deployer as the initial owner.
60      */
61     constructor() internal {
62         address msgSender = _msgSender();
63         _owner = msgSender;
64         emit OwnershipTransferred(address(0), msgSender);
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         emit OwnershipTransferred(_owner, newOwner);
101         _owner = newOwner;
102     }
103 }
104 
105 /**
106  * @dev Contract module extends Ownable and provide a way for safe transfer ownership.
107  * New owner has to call acceptOwnership in order to complete ownership trasnfer.
108  */
109 contract Owned is Ownable {
110     address private _newOwner;
111 
112     /**
113      * @dev Initiate transfer ownership of the contract to a new account (`newOwner`).
114      * Can only be called by the current owner. Current owner will still be owner until
115      * new owner accept ownership.
116      * @param newOwner new owner address
117      */
118     function transferOwnership(address newOwner) public override onlyOwner {
119         require(newOwner != address(0), "New owner is the zero address");
120         _newOwner = newOwner;
121     }
122 
123     /**
124      * @dev Allows new owner to accept ownership of the contract.
125      */
126     function acceptOwnership() public {
127         require(msg.sender == _newOwner, "Caller is not the new owner");
128         emit OwnershipTransferred(_owner, _newOwner);
129         _owner = _newOwner;
130         _newOwner = address(0);
131     }
132 }
133 
134 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
135 
136 
137 
138 pragma solidity ^0.6.0;
139 
140 /**
141  * @dev Interface of the ERC20 standard as defined in the EIP.
142  */
143 interface IERC20 {
144     /**
145      * @dev Returns the amount of tokens in existence.
146      */
147     function totalSupply() external view returns (uint256);
148 
149     /**
150      * @dev Returns the amount of tokens owned by `account`.
151      */
152     function balanceOf(address account) external view returns (uint256);
153 
154     /**
155      * @dev Moves `amount` tokens from the caller's account to `recipient`.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transfer(address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Returns the remaining number of tokens that `spender` will be
165      * allowed to spend on behalf of `owner` through {transferFrom}. This is
166      * zero by default.
167      *
168      * This value changes when {approve} or {transferFrom} are called.
169      */
170     function allowance(address owner, address spender) external view returns (uint256);
171 
172     /**
173      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * IMPORTANT: Beware that changing an allowance with this method brings the risk
178      * that someone may use both the old and the new allowance by unfortunate
179      * transaction ordering. One possible solution to mitigate this race
180      * condition is to first reduce the spender's allowance to 0 and set the
181      * desired value afterwards:
182      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183      *
184      * Emits an {Approval} event.
185      */
186     function approve(address spender, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Moves `amount` tokens from `sender` to `recipient` using the
190      * allowance mechanism. `amount` is then deducted from the caller's
191      * allowance.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
198 
199     /**
200      * @dev Emitted when `value` tokens are moved from one account (`from`) to
201      * another (`to`).
202      *
203      * Note that `value` may be zero.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 value);
206 
207     /**
208      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
209      * a call to {approve}. `value` is the new allowance.
210      */
211     event Approval(address indexed owner, address indexed spender, uint256 value);
212 }
213 
214 // File: @openzeppelin/contracts/math/SafeMath.sol
215 
216 
217 
218 pragma solidity ^0.6.0;
219 
220 /**
221  * @dev Wrappers over Solidity's arithmetic operations with added overflow
222  * checks.
223  *
224  * Arithmetic operations in Solidity wrap on overflow. This can easily result
225  * in bugs, because programmers usually assume that an overflow raises an
226  * error, which is the standard behavior in high level programming languages.
227  * `SafeMath` restores this intuition by reverting the transaction when an
228  * operation overflows.
229  *
230  * Using this library instead of the unchecked operations eliminates an entire
231  * class of bugs, so it's recommended to use it always.
232  */
233 library SafeMath {
234     /**
235      * @dev Returns the addition of two unsigned integers, reverting on
236      * overflow.
237      *
238      * Counterpart to Solidity's `+` operator.
239      *
240      * Requirements:
241      *
242      * - Addition cannot overflow.
243      */
244     function add(uint256 a, uint256 b) internal pure returns (uint256) {
245         uint256 c = a + b;
246         require(c >= a, "SafeMath: addition overflow");
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the subtraction of two unsigned integers, reverting on
253      * overflow (when the result is negative).
254      *
255      * Counterpart to Solidity's `-` operator.
256      *
257      * Requirements:
258      *
259      * - Subtraction cannot overflow.
260      */
261     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
262         return sub(a, b, "SafeMath: subtraction overflow");
263     }
264 
265     /**
266      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
267      * overflow (when the result is negative).
268      *
269      * Counterpart to Solidity's `-` operator.
270      *
271      * Requirements:
272      *
273      * - Subtraction cannot overflow.
274      */
275     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b <= a, errorMessage);
277         uint256 c = a - b;
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the multiplication of two unsigned integers, reverting on
284      * overflow.
285      *
286      * Counterpart to Solidity's `*` operator.
287      *
288      * Requirements:
289      *
290      * - Multiplication cannot overflow.
291      */
292     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
293         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
294         // benefit is lost if 'b' is also tested.
295         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
296         if (a == 0) {
297             return 0;
298         }
299 
300         uint256 c = a * b;
301         require(c / a == b, "SafeMath: multiplication overflow");
302 
303         return c;
304     }
305 
306     /**
307      * @dev Returns the integer division of two unsigned integers. Reverts on
308      * division by zero. The result is rounded towards zero.
309      *
310      * Counterpart to Solidity's `/` operator. Note: this function uses a
311      * `revert` opcode (which leaves remaining gas untouched) while Solidity
312      * uses an invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function div(uint256 a, uint256 b) internal pure returns (uint256) {
319         return div(a, b, "SafeMath: division by zero");
320     }
321 
322     /**
323      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
324      * division by zero. The result is rounded towards zero.
325      *
326      * Counterpart to Solidity's `/` operator. Note: this function uses a
327      * `revert` opcode (which leaves remaining gas untouched) while Solidity
328      * uses an invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
335         require(b > 0, errorMessage);
336         uint256 c = a / b;
337         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
338 
339         return c;
340     }
341 
342     /**
343      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
344      * Reverts when dividing by zero.
345      *
346      * Counterpart to Solidity's `%` operator. This function uses a `revert`
347      * opcode (which leaves remaining gas untouched) while Solidity uses an
348      * invalid opcode to revert (consuming all remaining gas).
349      *
350      * Requirements:
351      *
352      * - The divisor cannot be zero.
353      */
354     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
355         return mod(a, b, "SafeMath: modulo by zero");
356     }
357 
358     /**
359      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
360      * Reverts with custom message when dividing by zero.
361      *
362      * Counterpart to Solidity's `%` operator. This function uses a `revert`
363      * opcode (which leaves remaining gas untouched) while Solidity uses an
364      * invalid opcode to revert (consuming all remaining gas).
365      *
366      * Requirements:
367      *
368      * - The divisor cannot be zero.
369      */
370     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
371         require(b != 0, errorMessage);
372         return a % b;
373     }
374 }
375 
376 // File: @openzeppelin/contracts/utils/Address.sol
377 
378 
379 
380 pragma solidity ^0.6.2;
381 
382 /**
383  * @dev Collection of functions related to the address type
384  */
385 library Address {
386     /**
387      * @dev Returns true if `account` is a contract.
388      *
389      * [IMPORTANT]
390      * ====
391      * It is unsafe to assume that an address for which this function returns
392      * false is an externally-owned account (EOA) and not a contract.
393      *
394      * Among others, `isContract` will return false for the following
395      * types of addresses:
396      *
397      *  - an externally-owned account
398      *  - a contract in construction
399      *  - an address where a contract will be created
400      *  - an address where a contract lived, but was destroyed
401      * ====
402      */
403     function isContract(address account) internal view returns (bool) {
404         // This method relies in extcodesize, which returns 0 for contracts in
405         // construction, since the code is only stored at the end of the
406         // constructor execution.
407 
408         uint256 size;
409         // solhint-disable-next-line no-inline-assembly
410         assembly { size := extcodesize(account) }
411         return size > 0;
412     }
413 
414     /**
415      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
416      * `recipient`, forwarding all available gas and reverting on errors.
417      *
418      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
419      * of certain opcodes, possibly making contracts go over the 2300 gas limit
420      * imposed by `transfer`, making them unable to receive funds via
421      * `transfer`. {sendValue} removes this limitation.
422      *
423      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
424      *
425      * IMPORTANT: because control is transferred to `recipient`, care must be
426      * taken to not create reentrancy vulnerabilities. Consider using
427      * {ReentrancyGuard} or the
428      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
429      */
430     function sendValue(address payable recipient, uint256 amount) internal {
431         require(address(this).balance >= amount, "Address: insufficient balance");
432 
433         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
434         (bool success, ) = recipient.call{ value: amount }("");
435         require(success, "Address: unable to send value, recipient may have reverted");
436     }
437 
438     /**
439      * @dev Performs a Solidity function call using a low level `call`. A
440      * plain`call` is an unsafe replacement for a function call: use this
441      * function instead.
442      *
443      * If `target` reverts with a revert reason, it is bubbled up by this
444      * function (like regular Solidity function calls).
445      *
446      * Returns the raw returned data. To convert to the expected return value,
447      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
448      *
449      * Requirements:
450      *
451      * - `target` must be a contract.
452      * - calling `target` with `data` must not revert.
453      *
454      * _Available since v3.1._
455      */
456     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
457       return functionCall(target, data, "Address: low-level call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
462      * `errorMessage` as a fallback revert reason when `target` reverts.
463      *
464      * _Available since v3.1._
465      */
466     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
467         return _functionCallWithValue(target, data, 0, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but also transferring `value` wei to `target`.
473      *
474      * Requirements:
475      *
476      * - the calling contract must have an ETH balance of at least `value`.
477      * - the called Solidity function must be `payable`.
478      *
479      * _Available since v3.1._
480      */
481     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
482         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
487      * with `errorMessage` as a fallback revert reason when `target` reverts.
488      *
489      * _Available since v3.1._
490      */
491     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
492         require(address(this).balance >= value, "Address: insufficient balance for call");
493         return _functionCallWithValue(target, data, value, errorMessage);
494     }
495 
496     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
497         require(isContract(target), "Address: call to non-contract");
498 
499         // solhint-disable-next-line avoid-low-level-calls
500         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
501         if (success) {
502             return returndata;
503         } else {
504             // Look for revert reason and bubble it up if present
505             if (returndata.length > 0) {
506                 // The easiest way to bubble the revert reason is using memory via assembly
507 
508                 // solhint-disable-next-line no-inline-assembly
509                 assembly {
510                     let returndata_size := mload(returndata)
511                     revert(add(32, returndata), returndata_size)
512                 }
513             } else {
514                 revert(errorMessage);
515             }
516         }
517     }
518 }
519 
520 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
521 
522 
523 
524 pragma solidity ^0.6.0;
525 
526 
527 
528 
529 
530 /**
531  * @dev Implementation of the {IERC20} interface.
532  *
533  * This implementation is agnostic to the way tokens are created. This means
534  * that a supply mechanism has to be added in a derived contract using {_mint}.
535  * For a generic mechanism see {ERC20PresetMinterPauser}.
536  *
537  * TIP: For a detailed writeup see our guide
538  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
539  * to implement supply mechanisms].
540  *
541  * We have followed general OpenZeppelin guidelines: functions revert instead
542  * of returning `false` on failure. This behavior is nonetheless conventional
543  * and does not conflict with the expectations of ERC20 applications.
544  *
545  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
546  * This allows applications to reconstruct the allowance for all accounts just
547  * by listening to said events. Other implementations of the EIP may not emit
548  * these events, as it isn't required by the specification.
549  *
550  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
551  * functions have been added to mitigate the well-known issues around setting
552  * allowances. See {IERC20-approve}.
553  */
554 contract ERC20 is Context, IERC20 {
555     using SafeMath for uint256;
556     using Address for address;
557 
558     mapping (address => uint256) private _balances;
559 
560     mapping (address => mapping (address => uint256)) private _allowances;
561 
562     uint256 private _totalSupply;
563 
564     string private _name;
565     string private _symbol;
566     uint8 private _decimals;
567 
568     /**
569      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
570      * a default value of 18.
571      *
572      * To select a different value for {decimals}, use {_setupDecimals}.
573      *
574      * All three of these values are immutable: they can only be set once during
575      * construction.
576      */
577     constructor (string memory name, string memory symbol) public {
578         _name = name;
579         _symbol = symbol;
580         _decimals = 18;
581     }
582 
583     /**
584      * @dev Returns the name of the token.
585      */
586     function name() public view returns (string memory) {
587         return _name;
588     }
589 
590     /**
591      * @dev Returns the symbol of the token, usually a shorter version of the
592      * name.
593      */
594     function symbol() public view returns (string memory) {
595         return _symbol;
596     }
597 
598     /**
599      * @dev Returns the number of decimals used to get its user representation.
600      * For example, if `decimals` equals `2`, a balance of `505` tokens should
601      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
602      *
603      * Tokens usually opt for a value of 18, imitating the relationship between
604      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
605      * called.
606      *
607      * NOTE: This information is only used for _display_ purposes: it in
608      * no way affects any of the arithmetic of the contract, including
609      * {IERC20-balanceOf} and {IERC20-transfer}.
610      */
611     function decimals() public view returns (uint8) {
612         return _decimals;
613     }
614 
615     /**
616      * @dev See {IERC20-totalSupply}.
617      */
618     function totalSupply() public view override returns (uint256) {
619         return _totalSupply;
620     }
621 
622     /**
623      * @dev See {IERC20-balanceOf}.
624      */
625     function balanceOf(address account) public view override returns (uint256) {
626         return _balances[account];
627     }
628 
629     /**
630      * @dev See {IERC20-transfer}.
631      *
632      * Requirements:
633      *
634      * - `recipient` cannot be the zero address.
635      * - the caller must have a balance of at least `amount`.
636      */
637     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
638         _transfer(_msgSender(), recipient, amount);
639         return true;
640     }
641 
642     /**
643      * @dev See {IERC20-allowance}.
644      */
645     function allowance(address owner, address spender) public view virtual override returns (uint256) {
646         return _allowances[owner][spender];
647     }
648 
649     /**
650      * @dev See {IERC20-approve}.
651      *
652      * Requirements:
653      *
654      * - `spender` cannot be the zero address.
655      */
656     function approve(address spender, uint256 amount) public virtual override returns (bool) {
657         _approve(_msgSender(), spender, amount);
658         return true;
659     }
660 
661     /**
662      * @dev See {IERC20-transferFrom}.
663      *
664      * Emits an {Approval} event indicating the updated allowance. This is not
665      * required by the EIP. See the note at the beginning of {ERC20};
666      *
667      * Requirements:
668      * - `sender` and `recipient` cannot be the zero address.
669      * - `sender` must have a balance of at least `amount`.
670      * - the caller must have allowance for ``sender``'s tokens of at least
671      * `amount`.
672      */
673     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
674         _transfer(sender, recipient, amount);
675         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
676         return true;
677     }
678 
679     /**
680      * @dev Atomically increases the allowance granted to `spender` by the caller.
681      *
682      * This is an alternative to {approve} that can be used as a mitigation for
683      * problems described in {IERC20-approve}.
684      *
685      * Emits an {Approval} event indicating the updated allowance.
686      *
687      * Requirements:
688      *
689      * - `spender` cannot be the zero address.
690      */
691     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
692         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
693         return true;
694     }
695 
696     /**
697      * @dev Atomically decreases the allowance granted to `spender` by the caller.
698      *
699      * This is an alternative to {approve} that can be used as a mitigation for
700      * problems described in {IERC20-approve}.
701      *
702      * Emits an {Approval} event indicating the updated allowance.
703      *
704      * Requirements:
705      *
706      * - `spender` cannot be the zero address.
707      * - `spender` must have allowance for the caller of at least
708      * `subtractedValue`.
709      */
710     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
711         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
712         return true;
713     }
714 
715     /**
716      * @dev Moves tokens `amount` from `sender` to `recipient`.
717      *
718      * This is internal function is equivalent to {transfer}, and can be used to
719      * e.g. implement automatic token fees, slashing mechanisms, etc.
720      *
721      * Emits a {Transfer} event.
722      *
723      * Requirements:
724      *
725      * - `sender` cannot be the zero address.
726      * - `recipient` cannot be the zero address.
727      * - `sender` must have a balance of at least `amount`.
728      */
729     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
730         require(sender != address(0), "ERC20: transfer from the zero address");
731         require(recipient != address(0), "ERC20: transfer to the zero address");
732 
733         _beforeTokenTransfer(sender, recipient, amount);
734 
735         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
736         _balances[recipient] = _balances[recipient].add(amount);
737         emit Transfer(sender, recipient, amount);
738     }
739 
740     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
741      * the total supply.
742      *
743      * Emits a {Transfer} event with `from` set to the zero address.
744      *
745      * Requirements
746      *
747      * - `to` cannot be the zero address.
748      */
749     function _mint(address account, uint256 amount) internal virtual {
750         require(account != address(0), "ERC20: mint to the zero address");
751 
752         _beforeTokenTransfer(address(0), account, amount);
753 
754         _totalSupply = _totalSupply.add(amount);
755         _balances[account] = _balances[account].add(amount);
756         emit Transfer(address(0), account, amount);
757     }
758 
759     /**
760      * @dev Destroys `amount` tokens from `account`, reducing the
761      * total supply.
762      *
763      * Emits a {Transfer} event with `to` set to the zero address.
764      *
765      * Requirements
766      *
767      * - `account` cannot be the zero address.
768      * - `account` must have at least `amount` tokens.
769      */
770     function _burn(address account, uint256 amount) internal virtual {
771         require(account != address(0), "ERC20: burn from the zero address");
772 
773         _beforeTokenTransfer(account, address(0), amount);
774 
775         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
776         _totalSupply = _totalSupply.sub(amount);
777         emit Transfer(account, address(0), amount);
778     }
779 
780     /**
781      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
782      *
783      * This internal function is equivalent to `approve`, and can be used to
784      * e.g. set automatic allowances for certain subsystems, etc.
785      *
786      * Emits an {Approval} event.
787      *
788      * Requirements:
789      *
790      * - `owner` cannot be the zero address.
791      * - `spender` cannot be the zero address.
792      */
793     function _approve(address owner, address spender, uint256 amount) internal virtual {
794         require(owner != address(0), "ERC20: approve from the zero address");
795         require(spender != address(0), "ERC20: approve to the zero address");
796 
797         _allowances[owner][spender] = amount;
798         emit Approval(owner, spender, amount);
799     }
800 
801     /**
802      * @dev Sets {decimals} to a value other than the default one of 18.
803      *
804      * WARNING: This function should only be called from the constructor. Most
805      * applications that interact with token contracts will not expect
806      * {decimals} to ever change, and may work incorrectly if it does.
807      */
808     function _setupDecimals(uint8 decimals_) internal {
809         _decimals = decimals_;
810     }
811 
812     /**
813      * @dev Hook that is called before any transfer of tokens. This includes
814      * minting and burning.
815      *
816      * Calling conditions:
817      *
818      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
819      * will be to transferred to `to`.
820      * - when `from` is zero, `amount` tokens will be minted for `to`.
821      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
822      * - `from` and `to` are never both zero.
823      *
824      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
825      */
826     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
827 }
828 
829 // File: contracts/governor/VSPGovernanceToken.sol
830 
831 // From https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
832 
833 // Copyright 2020 Compound Labs, Inc.
834 // Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
835 // 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
836 // 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
837 // 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
838 // THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
839 
840 pragma solidity 0.6.12;
841 
842 
843 // solhint-disable reason-string, no-empty-blocks
844 abstract contract VSPGovernanceToken is ERC20 {
845     /// @dev A record of each accounts delegate
846     mapping(address => address) public delegates;
847 
848     /// @dev A checkpoint for marking number of votes from a given block
849     struct Checkpoint {
850         uint32 fromBlock;
851         uint256 votes;
852     }
853 
854     /// @dev A record of votes checkpoints for each account, by index
855     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
856 
857     /// @dev The number of checkpoints for each account
858     mapping(address => uint32) public numCheckpoints;
859 
860     /// @dev The EIP-712 typehash for the contract's domain
861     bytes32 public constant DOMAIN_TYPEHASH =
862         keccak256(
863             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
864         );
865 
866     /// @dev The EIP-712 typehash for the delegation struct used by the contract
867     bytes32 public constant DELEGATION_TYPEHASH =
868         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
869 
870     /// @dev A record of states for signing / validating signatures
871     mapping(address => uint256) public nonces;
872 
873     /// @dev An event thats emitted when an account changes its delegate
874     event DelegateChanged(
875         address indexed delegator,
876         address indexed fromDelegate,
877         address indexed toDelegate
878     );
879 
880     /// @dev An event thats emitted when a delegate account's vote balance changes
881     event DelegateVotesChanged(
882         address indexed delegate,
883         uint256 previousBalance,
884         uint256 newBalance
885     );
886 
887     /**
888      * @dev Constructor.
889      */
890     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {}
891 
892     /**
893      * @dev Delegate votes from `msg.sender` to `delegatee`
894      * @param delegatee The address to delegate votes to
895      */
896     function delegate(address delegatee) external {
897         return _delegate(msg.sender, delegatee);
898     }
899 
900     /**
901      * @dev Delegates votes from signatory to `delegatee`
902      * @param delegatee The address to delegate votes to
903      * @param nonce The contract state required to match the signature
904      * @param expiry The time at which to expire the signature
905      * @param v The recovery byte of the signature
906      * @param r Half of the ECDSA signature pair
907      * @param s Half of the ECDSA signature pair
908      */
909     function delegateBySig(
910         address delegatee,
911         uint256 nonce,
912         uint256 expiry,
913         uint8 v,
914         bytes32 r,
915         bytes32 s
916     ) external {
917         bytes32 domainSeparator =
918             keccak256(
919                 abi.encode(
920                     DOMAIN_TYPEHASH,
921                     keccak256(bytes(name())),
922                     keccak256(bytes("1")),
923                     getChainId(),
924                     address(this)
925                 )
926             );
927 
928         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
929 
930         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
931 
932         address signatory = ecrecover(digest, v, r, s);
933         require(signatory != address(0), "VSP::delegateBySig: invalid signature");
934         require(nonce == nonces[signatory]++, "VSP::delegateBySig: invalid nonce");
935         require(now <= expiry, "VSP::delegateBySig: signature expired");
936         return _delegate(signatory, delegatee);
937     }
938 
939     /**
940      * @dev Gets the current votes balance for `account`
941      * @param account The address to get votes balance
942      * @return The number of current votes for `account`
943      */
944     function getCurrentVotes(address account) external view returns (uint256) {
945         uint32 nCheckpoints = numCheckpoints[account];
946         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
947     }
948 
949     /**
950      * @dev Determine the prior number of votes for an account as of a block number
951      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
952      * @param account The address of the account to check
953      * @param blockNumber The block number to get the vote balance at
954      * @return The number of votes the account had as of the given block
955      */
956     function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256) {
957         require(blockNumber < block.number, "VSP::getPriorVotes: not yet determined");
958 
959         uint32 nCheckpoints = numCheckpoints[account];
960         if (nCheckpoints == 0) {
961             return 0;
962         }
963 
964         // First check most recent balance
965         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
966             return checkpoints[account][nCheckpoints - 1].votes;
967         }
968 
969         // Next check implicit zero balance
970         if (checkpoints[account][0].fromBlock > blockNumber) {
971             return 0;
972         }
973 
974         uint32 lower = 0;
975         uint32 upper = nCheckpoints - 1;
976         while (upper > lower) {
977             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
978             Checkpoint memory cp = checkpoints[account][center];
979             if (cp.fromBlock == blockNumber) {
980                 return cp.votes;
981             } else if (cp.fromBlock < blockNumber) {
982                 lower = center;
983             } else {
984                 upper = center - 1;
985             }
986         }
987         return checkpoints[account][lower].votes;
988     }
989 
990     function _delegate(address delegator, address delegatee) internal {
991         address currentDelegate = delegates[delegator];
992         uint256 delegatorBalance = balanceOf(delegator);
993         delegates[delegator] = delegatee;
994 
995         emit DelegateChanged(delegator, currentDelegate, delegatee);
996 
997         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
998     }
999 
1000     function _moveDelegates(
1001         address srcRep,
1002         address dstRep,
1003         uint256 amount
1004     ) internal {
1005         if (srcRep != dstRep && amount > 0) {
1006             if (srcRep != address(0)) {
1007                 // decrease old representative
1008                 uint32 srcRepNum = numCheckpoints[srcRep];
1009                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1010                 uint256 srcRepNew = srcRepOld.sub(amount);
1011                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1012             }
1013 
1014             if (dstRep != address(0)) {
1015                 // increase new representative
1016                 uint32 dstRepNum = numCheckpoints[dstRep];
1017                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1018                 uint256 dstRepNew = dstRepOld.add(amount);
1019                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1020             }
1021         }
1022     }
1023 
1024     function _writeCheckpoint(
1025         address delegatee,
1026         uint32 nCheckpoints,
1027         uint256 oldVotes,
1028         uint256 newVotes
1029     ) internal {
1030         uint32 blockNumber =
1031             safe32(block.number, "VSP::_writeCheckpoint: block number exceeds 32 bits");
1032 
1033         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1034             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1035         } else {
1036             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1037             numCheckpoints[delegatee] = nCheckpoints + 1;
1038         }
1039 
1040         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1041     }
1042 
1043     function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
1044         require(n < 2**32, errorMessage);
1045         return uint32(n);
1046     }
1047 
1048     function getChainId() internal pure returns (uint256) {
1049         uint256 chainId;
1050         assembly {
1051             chainId := chainid()
1052         }
1053         return chainId;
1054     }
1055 }
1056 
1057 // File: contracts/governor/VSP.sol
1058 
1059 
1060 
1061 pragma solidity 0.6.12;
1062 
1063 
1064 
1065 // solhint-disable no-empty-blocks
1066 contract VSP is VSPGovernanceToken, Owned {
1067     /// @dev The EIP-712 typehash for the permit struct used by the contract
1068     bytes32 public constant PERMIT_TYPEHASH =
1069         keccak256(
1070             "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
1071         );
1072 
1073     uint256 internal immutable mintLockPeriod;
1074     uint256 internal constant INITIAL_MINT_LIMIT = 10000000 * (10**18);
1075 
1076     constructor() public VSPGovernanceToken("VesperToken", "VSP") {
1077         mintLockPeriod = block.timestamp + (365 days);
1078     }
1079 
1080     /// @dev Mint VSP. Only owner can mint
1081     function mint(address _recipient, uint256 _amount) external onlyOwner {
1082         require(
1083             (totalSupply().add(_amount) <= INITIAL_MINT_LIMIT) ||
1084                 (block.timestamp > mintLockPeriod),
1085             "Minting not allowed"
1086         );
1087         _mint(_recipient, _amount);
1088         _moveDelegates(address(0), delegates[_recipient], _amount);
1089     }
1090 
1091     /// @dev Burn VSP from caller
1092     function burn(uint256 _amount) external {
1093         _burn(_msgSender(), _amount);
1094         _moveDelegates(delegates[_msgSender()], address(0), _amount);
1095     }
1096 
1097     /// @dev Burn VSP from given account. Caller must have proper allowance.
1098     function burnFrom(address _account, uint256 _amount) external {
1099         uint256 decreasedAllowance =
1100             allowance(_account, _msgSender()).sub(_amount, "ERC20: burn amount exceeds allowance");
1101 
1102         _approve(_account, _msgSender(), decreasedAllowance);
1103         _burn(_account, _amount);
1104         _moveDelegates(delegates[_account], address(0), _amount);
1105     }
1106 
1107     /**
1108      * @notice Transfer tokens to multiple recipient
1109      * @dev Left 160 bits are the recipient address and the right 96 bits are the token amount.
1110      * @param bits array of uint
1111      * @return true/false
1112      */
1113     function multiTransfer(uint256[] memory bits) external returns (bool) {
1114         for (uint256 i = 0; i < bits.length; i++) {
1115             address a = address(bits[i] >> 96);
1116             uint256 amount = bits[i] & ((1 << 96) - 1);
1117             require(transfer(a, amount), "Transfer failed");
1118         }
1119         return true;
1120     }
1121 
1122     /**
1123      * @notice Triggers an approval from owner to spends
1124      * @param _owner The address to approve from
1125      * @param _spender The address to be approved
1126      * @param _amount The number of tokens that are approved (2^256-1 means infinite)
1127      * @param _deadline The time at which to expire the signature
1128      * @param _v The recovery byte of the signature
1129      * @param _r Half of the ECDSA signature pair
1130      * @param _s Half of the ECDSA signature pair
1131      */
1132     function permit(
1133         address _owner,
1134         address _spender,
1135         uint256 _amount,
1136         uint256 _deadline,
1137         uint8 _v,
1138         bytes32 _r,
1139         bytes32 _s
1140     ) external {
1141         require(_deadline >= block.timestamp, "VSP:permit: signature expired");
1142 
1143         bytes32 domainSeparator =
1144             keccak256(
1145                 abi.encode(
1146                     DOMAIN_TYPEHASH,
1147                     keccak256(bytes(name())),
1148                     keccak256(bytes("1")),
1149                     getChainId(),
1150                     address(this)
1151                 )
1152             );
1153         bytes32 structHash =
1154             keccak256(
1155                 abi.encode(PERMIT_TYPEHASH, _owner, _spender, _amount, nonces[_owner]++, _deadline)
1156             );
1157         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1158         address signatory = ecrecover(digest, _v, _r, _s);
1159         require(signatory != address(0) && signatory == _owner, "VSP::permit: invalid signature");
1160         _approve(_owner, _spender, _amount);
1161     }
1162 
1163     /// @dev Overridden ERC20 transfer
1164     function transfer(address recipient, uint256 amount) public override returns (bool) {
1165         _transfer(_msgSender(), recipient, amount);
1166         _moveDelegates(delegates[_msgSender()], delegates[recipient], amount);
1167         return true;
1168     }
1169 
1170     /// @dev Overridden ERC20 transferFrom
1171     function transferFrom(
1172         address sender,
1173         address recipient,
1174         uint256 amount
1175     ) public override returns (bool) {
1176         _transfer(sender, recipient, amount);
1177         _approve(
1178             sender,
1179             _msgSender(),
1180             allowance(sender, _msgSender()).sub(
1181                 amount,
1182                 "VSP::transferFrom: transfer amount exceeds allowance"
1183             )
1184         );
1185         _moveDelegates(delegates[sender], delegates[recipient], amount);
1186         return true;
1187     }
1188 }