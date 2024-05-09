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
30 pragma solidity ^0.6.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File: contracts/owner/Operator.sol
97 
98 pragma solidity ^0.6.0;
99 
100 
101 
102 contract Operator is Context, Ownable {
103     address private _operator;
104 
105     event OperatorTransferred(
106         address indexed previousOperator,
107         address indexed newOperator
108     );
109 
110     constructor() internal {
111         _operator = _msgSender();
112         emit OperatorTransferred(address(0), _operator);
113     }
114 
115     function operator() public view returns (address) {
116         return _operator;
117     }
118 
119     modifier onlyOperator() {
120         require(
121             _operator == msg.sender,
122             'operator: caller is not the operator'
123         );
124         _;
125     }
126 
127     function isOperator() public view returns (bool) {
128         return _msgSender() == _operator;
129     }
130 
131     function transferOperator(address newOperator_) public onlyOwner {
132         _transferOperator(newOperator_);
133     }
134 
135     function _transferOperator(address newOperator_) internal {
136         require(
137             newOperator_ != address(0),
138             'operator: zero address given for new operator'
139         );
140         emit OperatorTransferred(address(0), newOperator_);
141         _operator = newOperator_;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
146 
147 pragma solidity ^0.6.0;
148 
149 /**
150  * @dev Interface of the ERC20 standard as defined in the EIP.
151  */
152 interface IERC20 {
153     /**
154      * @dev Returns the amount of tokens in existence.
155      */
156     function totalSupply() external view returns (uint256);
157 
158     /**
159      * @dev Returns the amount of tokens owned by `account`.
160      */
161     function balanceOf(address account) external view returns (uint256);
162 
163     /**
164      * @dev Moves `amount` tokens from the caller's account to `recipient`.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transfer(address recipient, uint256 amount) external returns (bool);
171 
172     /**
173      * @dev Returns the remaining number of tokens that `spender` will be
174      * allowed to spend on behalf of `owner` through {transferFrom}. This is
175      * zero by default.
176      *
177      * This value changes when {approve} or {transferFrom} are called.
178      */
179     function allowance(address owner, address spender) external view returns (uint256);
180 
181     /**
182      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * IMPORTANT: Beware that changing an allowance with this method brings the risk
187      * that someone may use both the old and the new allowance by unfortunate
188      * transaction ordering. One possible solution to mitigate this race
189      * condition is to first reduce the spender's allowance to 0 and set the
190      * desired value afterwards:
191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192      *
193      * Emits an {Approval} event.
194      */
195     function approve(address spender, uint256 amount) external returns (bool);
196 
197     /**
198      * @dev Moves `amount` tokens from `sender` to `recipient` using the
199      * allowance mechanism. `amount` is then deducted from the caller's
200      * allowance.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a {Transfer} event.
205      */
206     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Emitted when `value` tokens are moved from one account (`from`) to
210      * another (`to`).
211      *
212      * Note that `value` may be zero.
213      */
214     event Transfer(address indexed from, address indexed to, uint256 value);
215 
216     /**
217      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
218      * a call to {approve}. `value` is the new allowance.
219      */
220     event Approval(address indexed owner, address indexed spender, uint256 value);
221 }
222 
223 // File: @openzeppelin/contracts/math/SafeMath.sol
224 
225 pragma solidity ^0.6.0;
226 
227 /**
228  * @dev Wrappers over Solidity's arithmetic operations with added overflow
229  * checks.
230  *
231  * Arithmetic operations in Solidity wrap on overflow. This can easily result
232  * in bugs, because programmers usually assume that an overflow raises an
233  * error, which is the standard behavior in high level programming languages.
234  * `SafeMath` restores this intuition by reverting the transaction when an
235  * operation overflows.
236  *
237  * Using this library instead of the unchecked operations eliminates an entire
238  * class of bugs, so it's recommended to use it always.
239  */
240 library SafeMath {
241     /**
242      * @dev Returns the addition of two unsigned integers, reverting on
243      * overflow.
244      *
245      * Counterpart to Solidity's `+` operator.
246      *
247      * Requirements:
248      *
249      * - Addition cannot overflow.
250      */
251     function add(uint256 a, uint256 b) internal pure returns (uint256) {
252         uint256 c = a + b;
253         require(c >= a, "SafeMath: addition overflow");
254 
255         return c;
256     }
257 
258     /**
259      * @dev Returns the subtraction of two unsigned integers, reverting on
260      * overflow (when the result is negative).
261      *
262      * Counterpart to Solidity's `-` operator.
263      *
264      * Requirements:
265      *
266      * - Subtraction cannot overflow.
267      */
268     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
269         return sub(a, b, "SafeMath: subtraction overflow");
270     }
271 
272     /**
273      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
274      * overflow (when the result is negative).
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      *
280      * - Subtraction cannot overflow.
281      */
282     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         require(b <= a, errorMessage);
284         uint256 c = a - b;
285 
286         return c;
287     }
288 
289     /**
290      * @dev Returns the multiplication of two unsigned integers, reverting on
291      * overflow.
292      *
293      * Counterpart to Solidity's `*` operator.
294      *
295      * Requirements:
296      *
297      * - Multiplication cannot overflow.
298      */
299     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
300         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
301         // benefit is lost if 'b' is also tested.
302         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
303         if (a == 0) {
304             return 0;
305         }
306 
307         uint256 c = a * b;
308         require(c / a == b, "SafeMath: multiplication overflow");
309 
310         return c;
311     }
312 
313     /**
314      * @dev Returns the integer division of two unsigned integers. Reverts on
315      * division by zero. The result is rounded towards zero.
316      *
317      * Counterpart to Solidity's `/` operator. Note: this function uses a
318      * `revert` opcode (which leaves remaining gas untouched) while Solidity
319      * uses an invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      *
323      * - The divisor cannot be zero.
324      */
325     function div(uint256 a, uint256 b) internal pure returns (uint256) {
326         return div(a, b, "SafeMath: division by zero");
327     }
328 
329     /**
330      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
331      * division by zero. The result is rounded towards zero.
332      *
333      * Counterpart to Solidity's `/` operator. Note: this function uses a
334      * `revert` opcode (which leaves remaining gas untouched) while Solidity
335      * uses an invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      *
339      * - The divisor cannot be zero.
340      */
341     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
342         require(b > 0, errorMessage);
343         uint256 c = a / b;
344         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
345 
346         return c;
347     }
348 
349     /**
350      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
351      * Reverts when dividing by zero.
352      *
353      * Counterpart to Solidity's `%` operator. This function uses a `revert`
354      * opcode (which leaves remaining gas untouched) while Solidity uses an
355      * invalid opcode to revert (consuming all remaining gas).
356      *
357      * Requirements:
358      *
359      * - The divisor cannot be zero.
360      */
361     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
362         return mod(a, b, "SafeMath: modulo by zero");
363     }
364 
365     /**
366      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
367      * Reverts with custom message when dividing by zero.
368      *
369      * Counterpart to Solidity's `%` operator. This function uses a `revert`
370      * opcode (which leaves remaining gas untouched) while Solidity uses an
371      * invalid opcode to revert (consuming all remaining gas).
372      *
373      * Requirements:
374      *
375      * - The divisor cannot be zero.
376      */
377     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
378         require(b != 0, errorMessage);
379         return a % b;
380     }
381 }
382 
383 // File: @openzeppelin/contracts/utils/Address.sol
384 
385 pragma solidity ^0.6.2;
386 
387 /**
388  * @dev Collection of functions related to the address type
389  */
390 library Address {
391     /**
392      * @dev Returns true if `account` is a contract.
393      *
394      * [IMPORTANT]
395      * ====
396      * It is unsafe to assume that an address for which this function returns
397      * false is an externally-owned account (EOA) and not a contract.
398      *
399      * Among others, `isContract` will return false for the following
400      * types of addresses:
401      *
402      *  - an externally-owned account
403      *  - a contract in construction
404      *  - an address where a contract will be created
405      *  - an address where a contract lived, but was destroyed
406      * ====
407      */
408     function isContract(address account) internal view returns (bool) {
409         // This method relies in extcodesize, which returns 0 for contracts in
410         // construction, since the code is only stored at the end of the
411         // constructor execution.
412 
413         uint256 size;
414         // solhint-disable-next-line no-inline-assembly
415         assembly { size := extcodesize(account) }
416         return size > 0;
417     }
418 
419     /**
420      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
421      * `recipient`, forwarding all available gas and reverting on errors.
422      *
423      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
424      * of certain opcodes, possibly making contracts go over the 2300 gas limit
425      * imposed by `transfer`, making them unable to receive funds via
426      * `transfer`. {sendValue} removes this limitation.
427      *
428      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
429      *
430      * IMPORTANT: because control is transferred to `recipient`, care must be
431      * taken to not create reentrancy vulnerabilities. Consider using
432      * {ReentrancyGuard} or the
433      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
434      */
435     function sendValue(address payable recipient, uint256 amount) internal {
436         require(address(this).balance >= amount, "Address: insufficient balance");
437 
438         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
439         (bool success, ) = recipient.call{ value: amount }("");
440         require(success, "Address: unable to send value, recipient may have reverted");
441     }
442 
443     /**
444      * @dev Performs a Solidity function call using a low level `call`. A
445      * plain`call` is an unsafe replacement for a function call: use this
446      * function instead.
447      *
448      * If `target` reverts with a revert reason, it is bubbled up by this
449      * function (like regular Solidity function calls).
450      *
451      * Returns the raw returned data. To convert to the expected return value,
452      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
453      *
454      * Requirements:
455      *
456      * - `target` must be a contract.
457      * - calling `target` with `data` must not revert.
458      *
459      * _Available since v3.1._
460      */
461     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
462       return functionCall(target, data, "Address: low-level call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
467      * `errorMessage` as a fallback revert reason when `target` reverts.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
472         return _functionCallWithValue(target, data, 0, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but also transferring `value` wei to `target`.
478      *
479      * Requirements:
480      *
481      * - the calling contract must have an ETH balance of at least `value`.
482      * - the called Solidity function must be `payable`.
483      *
484      * _Available since v3.1._
485      */
486     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
487         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
492      * with `errorMessage` as a fallback revert reason when `target` reverts.
493      *
494      * _Available since v3.1._
495      */
496     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
497         require(address(this).balance >= value, "Address: insufficient balance for call");
498         return _functionCallWithValue(target, data, value, errorMessage);
499     }
500 
501     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
502         require(isContract(target), "Address: call to non-contract");
503 
504         // solhint-disable-next-line avoid-low-level-calls
505         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
506         if (success) {
507             return returndata;
508         } else {
509             // Look for revert reason and bubble it up if present
510             if (returndata.length > 0) {
511                 // The easiest way to bubble the revert reason is using memory via assembly
512 
513                 // solhint-disable-next-line no-inline-assembly
514                 assembly {
515                     let returndata_size := mload(returndata)
516                     revert(add(32, returndata), returndata_size)
517                 }
518             } else {
519                 revert(errorMessage);
520             }
521         }
522     }
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
526 
527 pragma solidity ^0.6.0;
528 
529 
530 
531 
532 
533 /**
534  * @dev Implementation of the {IERC20} interface.
535  *
536  * This implementation is agnostic to the way tokens are created. This means
537  * that a supply mechanism has to be added in a derived contract using {_mint}.
538  * For a generic mechanism see {ERC20PresetMinterPauser}.
539  *
540  * TIP: For a detailed writeup see our guide
541  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
542  * to implement supply mechanisms].
543  *
544  * We have followed general OpenZeppelin guidelines: functions revert instead
545  * of returning `false` on failure. This behavior is nonetheless conventional
546  * and does not conflict with the expectations of ERC20 applications.
547  *
548  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
549  * This allows applications to reconstruct the allowance for all accounts just
550  * by listening to said events. Other implementations of the EIP may not emit
551  * these events, as it isn't required by the specification.
552  *
553  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
554  * functions have been added to mitigate the well-known issues around setting
555  * allowances. See {IERC20-approve}.
556  */
557 contract ERC20 is Context, IERC20 {
558     using SafeMath for uint256;
559     using Address for address;
560 
561     mapping (address => uint256) private _balances;
562 
563     mapping (address => mapping (address => uint256)) private _allowances;
564 
565     uint256 private _totalSupply;
566 
567     string private _name;
568     string private _symbol;
569     uint8 private _decimals;
570 
571     /**
572      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
573      * a default value of 18.
574      *
575      * To select a different value for {decimals}, use {_setupDecimals}.
576      *
577      * All three of these values are immutable: they can only be set once during
578      * construction.
579      */
580     constructor (string memory name, string memory symbol) public {
581         _name = name;
582         _symbol = symbol;
583         _decimals = 18;
584     }
585 
586     /**
587      * @dev Returns the name of the token.
588      */
589     function name() public view returns (string memory) {
590         return _name;
591     }
592 
593     /**
594      * @dev Returns the symbol of the token, usually a shorter version of the
595      * name.
596      */
597     function symbol() public view returns (string memory) {
598         return _symbol;
599     }
600 
601     /**
602      * @dev Returns the number of decimals used to get its user representation.
603      * For example, if `decimals` equals `2`, a balance of `505` tokens should
604      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
605      *
606      * Tokens usually opt for a value of 18, imitating the relationship between
607      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
608      * called.
609      *
610      * NOTE: This information is only used for _display_ purposes: it in
611      * no way affects any of the arithmetic of the contract, including
612      * {IERC20-balanceOf} and {IERC20-transfer}.
613      */
614     function decimals() public view returns (uint8) {
615         return _decimals;
616     }
617 
618     /**
619      * @dev See {IERC20-totalSupply}.
620      */
621     function totalSupply() public view override returns (uint256) {
622         return _totalSupply;
623     }
624 
625     /**
626      * @dev See {IERC20-balanceOf}.
627      */
628     function balanceOf(address account) public view override returns (uint256) {
629         return _balances[account];
630     }
631 
632     /**
633      * @dev See {IERC20-transfer}.
634      *
635      * Requirements:
636      *
637      * - `recipient` cannot be the zero address.
638      * - the caller must have a balance of at least `amount`.
639      */
640     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
641         _transfer(_msgSender(), recipient, amount);
642         return true;
643     }
644 
645     /**
646      * @dev See {IERC20-allowance}.
647      */
648     function allowance(address owner, address spender) public view virtual override returns (uint256) {
649         return _allowances[owner][spender];
650     }
651 
652     /**
653      * @dev See {IERC20-approve}.
654      *
655      * Requirements:
656      *
657      * - `spender` cannot be the zero address.
658      */
659     function approve(address spender, uint256 amount) public virtual override returns (bool) {
660         _approve(_msgSender(), spender, amount);
661         return true;
662     }
663 
664     /**
665      * @dev See {IERC20-transferFrom}.
666      *
667      * Emits an {Approval} event indicating the updated allowance. This is not
668      * required by the EIP. See the note at the beginning of {ERC20};
669      *
670      * Requirements:
671      * - `sender` and `recipient` cannot be the zero address.
672      * - `sender` must have a balance of at least `amount`.
673      * - the caller must have allowance for ``sender``'s tokens of at least
674      * `amount`.
675      */
676     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
677         _transfer(sender, recipient, amount);
678         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
679         return true;
680     }
681 
682     /**
683      * @dev Atomically increases the allowance granted to `spender` by the caller.
684      *
685      * This is an alternative to {approve} that can be used as a mitigation for
686      * problems described in {IERC20-approve}.
687      *
688      * Emits an {Approval} event indicating the updated allowance.
689      *
690      * Requirements:
691      *
692      * - `spender` cannot be the zero address.
693      */
694     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
695         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
696         return true;
697     }
698 
699     /**
700      * @dev Atomically decreases the allowance granted to `spender` by the caller.
701      *
702      * This is an alternative to {approve} that can be used as a mitigation for
703      * problems described in {IERC20-approve}.
704      *
705      * Emits an {Approval} event indicating the updated allowance.
706      *
707      * Requirements:
708      *
709      * - `spender` cannot be the zero address.
710      * - `spender` must have allowance for the caller of at least
711      * `subtractedValue`.
712      */
713     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
714         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
715         return true;
716     }
717 
718     /**
719      * @dev Moves tokens `amount` from `sender` to `recipient`.
720      *
721      * This is internal function is equivalent to {transfer}, and can be used to
722      * e.g. implement automatic token fees, slashing mechanisms, etc.
723      *
724      * Emits a {Transfer} event.
725      *
726      * Requirements:
727      *
728      * - `sender` cannot be the zero address.
729      * - `recipient` cannot be the zero address.
730      * - `sender` must have a balance of at least `amount`.
731      */
732     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
733         require(sender != address(0), "ERC20: transfer from the zero address");
734         require(recipient != address(0), "ERC20: transfer to the zero address");
735 
736         _beforeTokenTransfer(sender, recipient, amount);
737 
738         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
739         _balances[recipient] = _balances[recipient].add(amount);
740         emit Transfer(sender, recipient, amount);
741     }
742 
743     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
744      * the total supply.
745      *
746      * Emits a {Transfer} event with `from` set to the zero address.
747      *
748      * Requirements
749      *
750      * - `to` cannot be the zero address.
751      */
752     function _mint(address account, uint256 amount) internal virtual {
753         require(account != address(0), "ERC20: mint to the zero address");
754 
755         _beforeTokenTransfer(address(0), account, amount);
756 
757         _totalSupply = _totalSupply.add(amount);
758         _balances[account] = _balances[account].add(amount);
759         emit Transfer(address(0), account, amount);
760     }
761 
762     /**
763      * @dev Destroys `amount` tokens from `account`, reducing the
764      * total supply.
765      *
766      * Emits a {Transfer} event with `to` set to the zero address.
767      *
768      * Requirements
769      *
770      * - `account` cannot be the zero address.
771      * - `account` must have at least `amount` tokens.
772      */
773     function _burn(address account, uint256 amount) internal virtual {
774         require(account != address(0), "ERC20: burn from the zero address");
775 
776         _beforeTokenTransfer(account, address(0), amount);
777 
778         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
779         _totalSupply = _totalSupply.sub(amount);
780         emit Transfer(account, address(0), amount);
781     }
782 
783     /**
784      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
785      *
786      * This internal function is equivalent to `approve`, and can be used to
787      * e.g. set automatic allowances for certain subsystems, etc.
788      *
789      * Emits an {Approval} event.
790      *
791      * Requirements:
792      *
793      * - `owner` cannot be the zero address.
794      * - `spender` cannot be the zero address.
795      */
796     function _approve(address owner, address spender, uint256 amount) internal virtual {
797         require(owner != address(0), "ERC20: approve from the zero address");
798         require(spender != address(0), "ERC20: approve to the zero address");
799 
800         _allowances[owner][spender] = amount;
801         emit Approval(owner, spender, amount);
802     }
803 
804     /**
805      * @dev Sets {decimals} to a value other than the default one of 18.
806      *
807      * WARNING: This function should only be called from the constructor. Most
808      * applications that interact with token contracts will not expect
809      * {decimals} to ever change, and may work incorrectly if it does.
810      */
811     function _setupDecimals(uint8 decimals_) internal {
812         _decimals = decimals_;
813     }
814 
815     /**
816      * @dev Hook that is called before any transfer of tokens. This includes
817      * minting and burning.
818      *
819      * Calling conditions:
820      *
821      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
822      * will be to transferred to `to`.
823      * - when `from` is zero, `amount` tokens will be minted for `to`.
824      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
825      * - `from` and `to` are never both zero.
826      *
827      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
828      */
829     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
830 }
831 
832 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
833 
834 pragma solidity ^0.6.0;
835 
836 
837 
838 /**
839  * @dev Extension of {ERC20} that allows token holders to destroy both their own
840  * tokens and those that they have an allowance for, in a way that can be
841  * recognized off-chain (via event analysis).
842  */
843 abstract contract ERC20Burnable is Context, ERC20 {
844     /**
845      * @dev Destroys `amount` tokens from the caller.
846      *
847      * See {ERC20-_burn}.
848      */
849     function burn(uint256 amount) public virtual {
850         _burn(_msgSender(), amount);
851     }
852 
853     /**
854      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
855      * allowance.
856      *
857      * See {ERC20-_burn} and {ERC20-allowance}.
858      *
859      * Requirements:
860      *
861      * - the caller must have allowance for ``accounts``'s tokens of at least
862      * `amount`.
863      */
864     function burnFrom(address account, uint256 amount) public virtual {
865         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
866 
867         _approve(account, _msgSender(), decreasedAllowance);
868         _burn(account, amount);
869     }
870 }
871 
872 // File: contracts/Share.sol
873 
874 pragma solidity ^0.6.0;
875 
876 
877 
878 contract Share is ERC20Burnable, Operator {
879     constructor() public ERC20('MIS', 'MIS') {
880         // Mints 1 Basis Share to contract creator for initial Uniswap oracle deployment.
881         // Will be burned after oracle deployment
882         _mint(msg.sender, 1 * 10**18);
883     }
884 
885     /**
886      * @notice Operator mints basis cash to a recipient
887      * @param recipient_ The address of recipient
888      * @param amount_ The amount of basis cash to mint to
889      */
890     function mint(address recipient_, uint256 amount_)
891         public
892         onlyOperator
893         returns (bool)
894     {
895         uint256 balanceBefore = balanceOf(recipient_);
896         _mint(recipient_, amount_);
897         uint256 balanceAfter = balanceOf(recipient_);
898         return balanceAfter >= balanceBefore;
899     }
900 
901     function burn(uint256 amount) public override onlyOperator {
902         super.burn(amount);
903     }
904 
905     function burnFrom(address account, uint256 amount)
906         public
907         override
908         onlyOperator
909     {
910         super.burnFrom(account, amount);
911     }
912 }