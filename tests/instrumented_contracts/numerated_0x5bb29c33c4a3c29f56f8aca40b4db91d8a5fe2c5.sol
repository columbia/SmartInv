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
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: contracts/owner/Operator.sol
99 
100 pragma solidity ^0.6.0;
101 
102 
103 
104 contract Operator is Context, Ownable {
105     address private _operator;
106 
107     event OperatorTransferred(
108         address indexed previousOperator,
109         address indexed newOperator
110     );
111 
112     constructor() internal {
113         _operator = _msgSender();
114         emit OperatorTransferred(address(0), _operator);
115     }
116 
117     function operator() public view returns (address) {
118         return _operator;
119     }
120 
121     modifier onlyOperator() {
122         require(
123             _operator == msg.sender,
124             'operator: caller is not the operator'
125         );
126         _;
127     }
128 
129     function isOperator() public view returns (bool) {
130         return _msgSender() == _operator;
131     }
132 
133     function transferOperator(address newOperator_) public onlyOwner {
134         _transferOperator(newOperator_);
135     }
136 
137     function _transferOperator(address newOperator_) internal {
138         require(
139             newOperator_ != address(0),
140             'operator: zero address given for new operator'
141         );
142         emit OperatorTransferred(address(0), newOperator_);
143         _operator = newOperator_;
144     }
145 }
146 
147 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
148 
149 
150 
151 pragma solidity ^0.6.0;
152 
153 /**
154  * @dev Interface of the ERC20 standard as defined in the EIP.
155  */
156 interface IERC20 {
157     /**
158      * @dev Returns the amount of tokens in existence.
159      */
160     function totalSupply() external view returns (uint256);
161 
162     /**
163      * @dev Returns the amount of tokens owned by `account`.
164      */
165     function balanceOf(address account) external view returns (uint256);
166 
167     /**
168      * @dev Moves `amount` tokens from the caller's account to `recipient`.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transfer(address recipient, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Returns the remaining number of tokens that `spender` will be
178      * allowed to spend on behalf of `owner` through {transferFrom}. This is
179      * zero by default.
180      *
181      * This value changes when {approve} or {transferFrom} are called.
182      */
183     function allowance(address owner, address spender) external view returns (uint256);
184 
185     /**
186      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * IMPORTANT: Beware that changing an allowance with this method brings the risk
191      * that someone may use both the old and the new allowance by unfortunate
192      * transaction ordering. One possible solution to mitigate this race
193      * condition is to first reduce the spender's allowance to 0 and set the
194      * desired value afterwards:
195      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196      *
197      * Emits an {Approval} event.
198      */
199     function approve(address spender, uint256 amount) external returns (bool);
200 
201     /**
202      * @dev Moves `amount` tokens from `sender` to `recipient` using the
203      * allowance mechanism. `amount` is then deducted from the caller's
204      * allowance.
205      *
206      * Returns a boolean value indicating whether the operation succeeded.
207      *
208      * Emits a {Transfer} event.
209      */
210     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
211 
212     /**
213      * @dev Emitted when `value` tokens are moved from one account (`from`) to
214      * another (`to`).
215      *
216      * Note that `value` may be zero.
217      */
218     event Transfer(address indexed from, address indexed to, uint256 value);
219 
220     /**
221      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
222      * a call to {approve}. `value` is the new allowance.
223      */
224     event Approval(address indexed owner, address indexed spender, uint256 value);
225 }
226 
227 // File: @openzeppelin/contracts/math/SafeMath.sol
228 
229 
230 
231 pragma solidity ^0.6.0;
232 
233 /**
234  * @dev Wrappers over Solidity's arithmetic operations with added overflow
235  * checks.
236  *
237  * Arithmetic operations in Solidity wrap on overflow. This can easily result
238  * in bugs, because programmers usually assume that an overflow raises an
239  * error, which is the standard behavior in high level programming languages.
240  * `SafeMath` restores this intuition by reverting the transaction when an
241  * operation overflows.
242  *
243  * Using this library instead of the unchecked operations eliminates an entire
244  * class of bugs, so it's recommended to use it always.
245  */
246 library SafeMath {
247     /**
248      * @dev Returns the addition of two unsigned integers, reverting on
249      * overflow.
250      *
251      * Counterpart to Solidity's `+` operator.
252      *
253      * Requirements:
254      *
255      * - Addition cannot overflow.
256      */
257     function add(uint256 a, uint256 b) internal pure returns (uint256) {
258         uint256 c = a + b;
259         require(c >= a, "SafeMath: addition overflow");
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the subtraction of two unsigned integers, reverting on
266      * overflow (when the result is negative).
267      *
268      * Counterpart to Solidity's `-` operator.
269      *
270      * Requirements:
271      *
272      * - Subtraction cannot overflow.
273      */
274     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
275         return sub(a, b, "SafeMath: subtraction overflow");
276     }
277 
278     /**
279      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
280      * overflow (when the result is negative).
281      *
282      * Counterpart to Solidity's `-` operator.
283      *
284      * Requirements:
285      *
286      * - Subtraction cannot overflow.
287      */
288     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
289         require(b <= a, errorMessage);
290         uint256 c = a - b;
291 
292         return c;
293     }
294 
295     /**
296      * @dev Returns the multiplication of two unsigned integers, reverting on
297      * overflow.
298      *
299      * Counterpart to Solidity's `*` operator.
300      *
301      * Requirements:
302      *
303      * - Multiplication cannot overflow.
304      */
305     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
306         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
307         // benefit is lost if 'b' is also tested.
308         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
309         if (a == 0) {
310             return 0;
311         }
312 
313         uint256 c = a * b;
314         require(c / a == b, "SafeMath: multiplication overflow");
315 
316         return c;
317     }
318 
319     /**
320      * @dev Returns the integer division of two unsigned integers. Reverts on
321      * division by zero. The result is rounded towards zero.
322      *
323      * Counterpart to Solidity's `/` operator. Note: this function uses a
324      * `revert` opcode (which leaves remaining gas untouched) while Solidity
325      * uses an invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function div(uint256 a, uint256 b) internal pure returns (uint256) {
332         return div(a, b, "SafeMath: division by zero");
333     }
334 
335     /**
336      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
337      * division by zero. The result is rounded towards zero.
338      *
339      * Counterpart to Solidity's `/` operator. Note: this function uses a
340      * `revert` opcode (which leaves remaining gas untouched) while Solidity
341      * uses an invalid opcode to revert (consuming all remaining gas).
342      *
343      * Requirements:
344      *
345      * - The divisor cannot be zero.
346      */
347     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
348         require(b > 0, errorMessage);
349         uint256 c = a / b;
350         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
351 
352         return c;
353     }
354 
355     /**
356      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
357      * Reverts when dividing by zero.
358      *
359      * Counterpart to Solidity's `%` operator. This function uses a `revert`
360      * opcode (which leaves remaining gas untouched) while Solidity uses an
361      * invalid opcode to revert (consuming all remaining gas).
362      *
363      * Requirements:
364      *
365      * - The divisor cannot be zero.
366      */
367     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
368         return mod(a, b, "SafeMath: modulo by zero");
369     }
370 
371     /**
372      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
373      * Reverts with custom message when dividing by zero.
374      *
375      * Counterpart to Solidity's `%` operator. This function uses a `revert`
376      * opcode (which leaves remaining gas untouched) while Solidity uses an
377      * invalid opcode to revert (consuming all remaining gas).
378      *
379      * Requirements:
380      *
381      * - The divisor cannot be zero.
382      */
383     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
384         require(b != 0, errorMessage);
385         return a % b;
386     }
387 }
388 
389 // File: @openzeppelin/contracts/utils/Address.sol
390 
391 
392 
393 pragma solidity ^0.6.2;
394 
395 /**
396  * @dev Collection of functions related to the address type
397  */
398 library Address {
399     /**
400      * @dev Returns true if `account` is a contract.
401      *
402      * [IMPORTANT]
403      * ====
404      * It is unsafe to assume that an address for which this function returns
405      * false is an externally-owned account (EOA) and not a contract.
406      *
407      * Among others, `isContract` will return false for the following
408      * types of addresses:
409      *
410      *  - an externally-owned account
411      *  - a contract in construction
412      *  - an address where a contract will be created
413      *  - an address where a contract lived, but was destroyed
414      * ====
415      */
416     function isContract(address account) internal view returns (bool) {
417         // This method relies in extcodesize, which returns 0 for contracts in
418         // construction, since the code is only stored at the end of the
419         // constructor execution.
420 
421         uint256 size;
422         // solhint-disable-next-line no-inline-assembly
423         assembly { size := extcodesize(account) }
424         return size > 0;
425     }
426 
427     /**
428      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
429      * `recipient`, forwarding all available gas and reverting on errors.
430      *
431      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
432      * of certain opcodes, possibly making contracts go over the 2300 gas limit
433      * imposed by `transfer`, making them unable to receive funds via
434      * `transfer`. {sendValue} removes this limitation.
435      *
436      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
437      *
438      * IMPORTANT: because control is transferred to `recipient`, care must be
439      * taken to not create reentrancy vulnerabilities. Consider using
440      * {ReentrancyGuard} or the
441      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
442      */
443     function sendValue(address payable recipient, uint256 amount) internal {
444         require(address(this).balance >= amount, "Address: insufficient balance");
445 
446         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
447         (bool success, ) = recipient.call{ value: amount }("");
448         require(success, "Address: unable to send value, recipient may have reverted");
449     }
450 
451     /**
452      * @dev Performs a Solidity function call using a low level `call`. A
453      * plain`call` is an unsafe replacement for a function call: use this
454      * function instead.
455      *
456      * If `target` reverts with a revert reason, it is bubbled up by this
457      * function (like regular Solidity function calls).
458      *
459      * Returns the raw returned data. To convert to the expected return value,
460      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
461      *
462      * Requirements:
463      *
464      * - `target` must be a contract.
465      * - calling `target` with `data` must not revert.
466      *
467      * _Available since v3.1._
468      */
469     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
470       return functionCall(target, data, "Address: low-level call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
475      * `errorMessage` as a fallback revert reason when `target` reverts.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
480         return _functionCallWithValue(target, data, 0, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but also transferring `value` wei to `target`.
486      *
487      * Requirements:
488      *
489      * - the calling contract must have an ETH balance of at least `value`.
490      * - the called Solidity function must be `payable`.
491      *
492      * _Available since v3.1._
493      */
494     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
495         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
500      * with `errorMessage` as a fallback revert reason when `target` reverts.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
505         require(address(this).balance >= value, "Address: insufficient balance for call");
506         return _functionCallWithValue(target, data, value, errorMessage);
507     }
508 
509     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
510         require(isContract(target), "Address: call to non-contract");
511 
512         // solhint-disable-next-line avoid-low-level-calls
513         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
514         if (success) {
515             return returndata;
516         } else {
517             // Look for revert reason and bubble it up if present
518             if (returndata.length > 0) {
519                 // The easiest way to bubble the revert reason is using memory via assembly
520 
521                 // solhint-disable-next-line no-inline-assembly
522                 assembly {
523                     let returndata_size := mload(returndata)
524                     revert(add(32, returndata), returndata_size)
525                 }
526             } else {
527                 revert(errorMessage);
528             }
529         }
530     }
531 }
532 
533 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
534 
535 
536 
537 pragma solidity ^0.6.0;
538 
539 
540 
541 
542 
543 /**
544  * @dev Implementation of the {IERC20} interface.
545  *
546  * This implementation is agnostic to the way tokens are created. This means
547  * that a supply mechanism has to be added in a derived contract using {_mint}.
548  * For a generic mechanism see {ERC20PresetMinterPauser}.
549  *
550  * TIP: For a detailed writeup see our guide
551  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
552  * to implement supply mechanisms].
553  *
554  * We have followed general OpenZeppelin guidelines: functions revert instead
555  * of returning `false` on failure. This behavior is nonetheless conventional
556  * and does not conflict with the expectations of ERC20 applications.
557  *
558  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
559  * This allows applications to reconstruct the allowance for all accounts just
560  * by listening to said events. Other implementations of the EIP may not emit
561  * these events, as it isn't required by the specification.
562  *
563  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
564  * functions have been added to mitigate the well-known issues around setting
565  * allowances. See {IERC20-approve}.
566  */
567 contract ERC20 is Context, IERC20 {
568     using SafeMath for uint256;
569     using Address for address;
570 
571     mapping (address => uint256) private _balances;
572 
573     mapping (address => mapping (address => uint256)) private _allowances;
574 
575     uint256 private _totalSupply;
576 
577     string private _name;
578     string private _symbol;
579     uint8 private _decimals;
580 
581     /**
582      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
583      * a default value of 18.
584      *
585      * To select a different value for {decimals}, use {_setupDecimals}.
586      *
587      * All three of these values are immutable: they can only be set once during
588      * construction.
589      */
590     constructor (string memory name, string memory symbol) public {
591         _name = name;
592         _symbol = symbol;
593         _decimals = 18;
594     }
595 
596     /**
597      * @dev Returns the name of the token.
598      */
599     function name() public view returns (string memory) {
600         return _name;
601     }
602 
603     /**
604      * @dev Returns the symbol of the token, usually a shorter version of the
605      * name.
606      */
607     function symbol() public view returns (string memory) {
608         return _symbol;
609     }
610 
611     /**
612      * @dev Returns the number of decimals used to get its user representation.
613      * For example, if `decimals` equals `2`, a balance of `505` tokens should
614      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
615      *
616      * Tokens usually opt for a value of 18, imitating the relationship between
617      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
618      * called.
619      *
620      * NOTE: This information is only used for _display_ purposes: it in
621      * no way affects any of the arithmetic of the contract, including
622      * {IERC20-balanceOf} and {IERC20-transfer}.
623      */
624     function decimals() public view returns (uint8) {
625         return _decimals;
626     }
627 
628     /**
629      * @dev See {IERC20-totalSupply}.
630      */
631     function totalSupply() public view override returns (uint256) {
632         return _totalSupply;
633     }
634 
635     /**
636      * @dev See {IERC20-balanceOf}.
637      */
638     function balanceOf(address account) public view override returns (uint256) {
639         return _balances[account];
640     }
641 
642     /**
643      * @dev See {IERC20-transfer}.
644      *
645      * Requirements:
646      *
647      * - `recipient` cannot be the zero address.
648      * - the caller must have a balance of at least `amount`.
649      */
650     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
651         _transfer(_msgSender(), recipient, amount);
652         return true;
653     }
654 
655     /**
656      * @dev See {IERC20-allowance}.
657      */
658     function allowance(address owner, address spender) public view virtual override returns (uint256) {
659         return _allowances[owner][spender];
660     }
661 
662     /**
663      * @dev See {IERC20-approve}.
664      *
665      * Requirements:
666      *
667      * - `spender` cannot be the zero address.
668      */
669     function approve(address spender, uint256 amount) public virtual override returns (bool) {
670         _approve(_msgSender(), spender, amount);
671         return true;
672     }
673 
674     /**
675      * @dev See {IERC20-transferFrom}.
676      *
677      * Emits an {Approval} event indicating the updated allowance. This is not
678      * required by the EIP. See the note at the beginning of {ERC20};
679      *
680      * Requirements:
681      * - `sender` and `recipient` cannot be the zero address.
682      * - `sender` must have a balance of at least `amount`.
683      * - the caller must have allowance for ``sender``'s tokens of at least
684      * `amount`.
685      */
686     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
687         _transfer(sender, recipient, amount);
688         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
689         return true;
690     }
691 
692     /**
693      * @dev Atomically increases the allowance granted to `spender` by the caller.
694      *
695      * This is an alternative to {approve} that can be used as a mitigation for
696      * problems described in {IERC20-approve}.
697      *
698      * Emits an {Approval} event indicating the updated allowance.
699      *
700      * Requirements:
701      *
702      * - `spender` cannot be the zero address.
703      */
704     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
705         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
706         return true;
707     }
708 
709     /**
710      * @dev Atomically decreases the allowance granted to `spender` by the caller.
711      *
712      * This is an alternative to {approve} that can be used as a mitigation for
713      * problems described in {IERC20-approve}.
714      *
715      * Emits an {Approval} event indicating the updated allowance.
716      *
717      * Requirements:
718      *
719      * - `spender` cannot be the zero address.
720      * - `spender` must have allowance for the caller of at least
721      * `subtractedValue`.
722      */
723     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
724         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
725         return true;
726     }
727 
728     /**
729      * @dev Moves tokens `amount` from `sender` to `recipient`.
730      *
731      * This is internal function is equivalent to {transfer}, and can be used to
732      * e.g. implement automatic token fees, slashing mechanisms, etc.
733      *
734      * Emits a {Transfer} event.
735      *
736      * Requirements:
737      *
738      * - `sender` cannot be the zero address.
739      * - `recipient` cannot be the zero address.
740      * - `sender` must have a balance of at least `amount`.
741      */
742     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
743         require(sender != address(0), "ERC20: transfer from the zero address");
744         require(recipient != address(0), "ERC20: transfer to the zero address");
745 
746         _beforeTokenTransfer(sender, recipient, amount);
747 
748         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
749         _balances[recipient] = _balances[recipient].add(amount);
750         emit Transfer(sender, recipient, amount);
751     }
752 
753     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
754      * the total supply.
755      *
756      * Emits a {Transfer} event with `from` set to the zero address.
757      *
758      * Requirements
759      *
760      * - `to` cannot be the zero address.
761      */
762     function _mint(address account, uint256 amount) internal virtual {
763         require(account != address(0), "ERC20: mint to the zero address");
764 
765         _beforeTokenTransfer(address(0), account, amount);
766 
767         _totalSupply = _totalSupply.add(amount);
768         _balances[account] = _balances[account].add(amount);
769         emit Transfer(address(0), account, amount);
770     }
771 
772     /**
773      * @dev Destroys `amount` tokens from `account`, reducing the
774      * total supply.
775      *
776      * Emits a {Transfer} event with `to` set to the zero address.
777      *
778      * Requirements
779      *
780      * - `account` cannot be the zero address.
781      * - `account` must have at least `amount` tokens.
782      */
783     function _burn(address account, uint256 amount) internal virtual {
784         require(account != address(0), "ERC20: burn from the zero address");
785 
786         _beforeTokenTransfer(account, address(0), amount);
787 
788         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
789         _totalSupply = _totalSupply.sub(amount);
790         emit Transfer(account, address(0), amount);
791     }
792 
793     /**
794      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
795      *
796      * This internal function is equivalent to `approve`, and can be used to
797      * e.g. set automatic allowances for certain subsystems, etc.
798      *
799      * Emits an {Approval} event.
800      *
801      * Requirements:
802      *
803      * - `owner` cannot be the zero address.
804      * - `spender` cannot be the zero address.
805      */
806     function _approve(address owner, address spender, uint256 amount) internal virtual {
807         require(owner != address(0), "ERC20: approve from the zero address");
808         require(spender != address(0), "ERC20: approve to the zero address");
809 
810         _allowances[owner][spender] = amount;
811         emit Approval(owner, spender, amount);
812     }
813 
814     /**
815      * @dev Sets {decimals} to a value other than the default one of 18.
816      *
817      * WARNING: This function should only be called from the constructor. Most
818      * applications that interact with token contracts will not expect
819      * {decimals} to ever change, and may work incorrectly if it does.
820      */
821     function _setupDecimals(uint8 decimals_) internal {
822         _decimals = decimals_;
823     }
824 
825     /**
826      * @dev Hook that is called before any transfer of tokens. This includes
827      * minting and burning.
828      *
829      * Calling conditions:
830      *
831      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
832      * will be to transferred to `to`.
833      * - when `from` is zero, `amount` tokens will be minted for `to`.
834      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
835      * - `from` and `to` are never both zero.
836      *
837      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
838      */
839     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
840 }
841 
842 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
843 
844 
845 
846 pragma solidity ^0.6.0;
847 
848 
849 
850 /**
851  * @dev Extension of {ERC20} that allows token holders to destroy both their own
852  * tokens and those that they have an allowance for, in a way that can be
853  * recognized off-chain (via event analysis).
854  */
855 abstract contract ERC20Burnable is Context, ERC20 {
856     /**
857      * @dev Destroys `amount` tokens from the caller.
858      *
859      * See {ERC20-_burn}.
860      */
861     function burn(uint256 amount) public virtual {
862         _burn(_msgSender(), amount);
863     }
864 
865     /**
866      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
867      * allowance.
868      *
869      * See {ERC20-_burn} and {ERC20-allowance}.
870      *
871      * Requirements:
872      *
873      * - the caller must have allowance for ``accounts``'s tokens of at least
874      * `amount`.
875      */
876     function burnFrom(address account, uint256 amount) public virtual {
877         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
878 
879         _approve(account, _msgSender(), decreasedAllowance);
880         _burn(account, amount);
881     }
882 }
883 
884 // File: contracts/Share.sol
885 
886 pragma solidity ^0.6.0;
887 
888 
889 
890 contract Share is ERC20Burnable, Operator {
891     constructor() public ERC20('ONS', 'ONS') {
892         // Mints 1 ONSis Share to contract creator for initial Uniswap oracle deployment.
893         // Will be burned after oracle deployment
894         _mint(msg.sender, 1 * 10**18);
895     }
896 
897     /**
898      * @notice Operator mints ONSis cash to a recipient
899      * @param recipient_ The address of recipient
900      * @param amount_ The amount of ONSis cash to mint to
901      */
902     function mint(address recipient_, uint256 amount_)
903         public
904         onlyOperator
905         returns (bool)
906     {
907         uint256 balanceBefore = balanceOf(recipient_);
908         _mint(recipient_, amount_);
909         uint256 balanceAfter = balanceOf(recipient_);
910         return balanceAfter >= balanceBefore;
911     }
912 
913     function burn(uint256 amount) public override onlyOperator {
914         super.burn(amount);
915     }
916 
917     function burnFrom(address account, uint256 amount)
918         public
919         override
920         onlyOperator
921     {
922         super.burnFrom(account, amount);
923     }
924 }