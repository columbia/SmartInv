1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // ----------------------------------------------------------------------------
5 // Billion Token
6 //
7 // Deployed to : 0x217373AB5e0082B2Ce622169672ECa6F4462319C
8 // Symbol : -
9 // Name : -
10 // Total supply: -
11 // Decimals :18
12 //
13 // Deployed by - Ecosystem
14 // ----------------------------------------------------------------------------
15 
16 
17 
18 /**
19  * @dev Interface of the ERC20 standard as defined in the EIP.
20  */
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Burn `amount` tokens from 'owner'
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function burn(uint256 amount) external returns (bool);
85     
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 /**
102  * @dev Interface for the optional metadata functions from the ERC20 standard.
103  */
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 abstract contract Context {
122     function _msgSender() internal view virtual returns (address) {
123         return msg.sender;
124     }
125 
126     function _msgData() internal view virtual returns (bytes calldata) {
127         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
128         return msg.data;
129     }
130 }
131 
132 /**
133  * @title Ownable
134  * @dev The Ownable contract has an owner address, and provides basic authorization control
135  * functions, this simplifies the implementation of "user permissions".
136  */
137 contract Ownable is Context {
138   address public owner;
139 
140 
141   event OwnershipRenounced(address indexed previousOwner);
142   event OwnershipTransferred(
143     address indexed previousOwner,
144     address indexed newOwner
145   );
146 
147 
148   /**
149    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
150    * account.
151    */
152   constructor() {
153     owner = msg.sender;
154   }
155 
156   /**
157    * @dev Throws if called by any account other than the owner.
158    */
159   modifier onlyOwner() {
160     require(msg.sender == owner);
161     _;
162   }
163 
164   /**
165    * @dev Allows the current owner to transfer control of the contract to a newOwner.
166    * @param newOwner The address to transfer ownership to.
167    */
168   function transferOwnership(address newOwner) public onlyOwner {
169     require(newOwner != address(0));
170     emit OwnershipTransferred(owner, newOwner);
171     owner = newOwner;
172   }
173 
174   /**
175    * @dev Allows the current owner to relinquish control of the contract.
176    */
177   function renounceOwnership() public onlyOwner {
178     emit OwnershipRenounced(owner);
179     owner = address(0);
180   }
181 }
182 
183 /**
184  * @dev Wrappers over Solidity's arithmetic operations with added overflow
185  * checks.
186  *
187  * Arithmetic operations in Solidity wrap on overflow. This can easily result
188  * in bugs, because programmers usually assume that an overflow raises an
189  * error, which is the standard behavior in high level programming languages.
190  * `SafeMath` restores this intuition by reverting the transaction when an
191  * operation overflows.
192  *
193  * Using this library instead of the unchecked operations eliminates an entire
194  * class of bugs, so it's recommended to use it always.
195  */
196 library SafeMath {
197     /**
198      * @dev Returns the addition of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `+` operator.
202      *
203      * Requirements:
204      * - Addition cannot overflow.
205      */
206     function add(uint256 a, uint256 b) internal pure returns (uint256) {
207         uint256 c = a + b;
208         require(c >= a, "SafeMath: addition overflow");
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the subtraction of two unsigned integers, reverting on
215      * overflow (when the result is negative).
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
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
233      * - Subtraction cannot overflow.
234      *
235      * _Available since v2.4.0._
236      */
237     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b <= a, errorMessage);
239         uint256 c = a - b;
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the multiplication of two unsigned integers, reverting on
246      * overflow.
247      *
248      * Counterpart to Solidity's `*` operator.
249      *
250      * Requirements:
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
276      * - The divisor cannot be zero.
277      */
278     function div(uint256 a, uint256 b) internal pure returns (uint256) {
279         return div(a, b, "SafeMath: division by zero");
280     }
281 
282     /**
283      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
284      * division by zero. The result is rounded towards zero.
285      *
286      * Counterpart to Solidity's `/` operator. Note: this function uses a
287      * `revert` opcode (which leaves remaining gas untouched) while Solidity
288      * uses an invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      * - The divisor cannot be zero.
292      *
293      * _Available since v2.4.0._
294      */
295     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         // Solidity only automatically asserts when dividing by 0
297         require(b > 0, errorMessage);
298         uint256 c = a / b;
299         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
300 
301         return c;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * Reverts when dividing by zero.
307      *
308      * Counterpart to Solidity's `%` operator. This function uses a `revert`
309      * opcode (which leaves remaining gas untouched) while Solidity uses an
310      * invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
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
328      * - The divisor cannot be zero.
329      *
330      * _Available since v2.4.0._
331      */
332     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
333         require(b != 0, errorMessage);
334         return a % b;
335     }
336 }
337 
338 /**
339  * @dev Collection of functions related to the address type
340  */
341 /**
342  * @dev Collection of functions related to the address type
343  */
344 library Address {
345     /**
346      * @dev Returns true if `account` is a contract.
347      *
348      * [IMPORTANT]
349      * ====
350      * It is unsafe to assume that an address for which this function returns
351      * false is an externally-owned account (EOA) and not a contract.
352      *
353      * Among others, `isContract` will return false for the following
354      * types of addresses:
355      *
356      *  - an externally-owned account
357      *  - a contract in construction
358      *  - an address where a contract will be created
359      *  - an address where a contract lived, but was destroyed
360      * ====
361      */
362     function isContract(address account) internal view returns (bool) {
363         // This method relies on extcodesize, which returns 0 for contracts in
364         // construction, since the code is only stored at the end of the
365         // constructor execution.
366 
367         uint256 size;
368         // solhint-disable-next-line no-inline-assembly
369         assembly { size := extcodesize(account) }
370         return size > 0;
371     }
372 
373     /**
374      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
375      * `recipient`, forwarding all available gas and reverting on errors.
376      *
377      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
378      * of certain opcodes, possibly making contracts go over the 2300 gas limit
379      * imposed by `transfer`, making them unable to receive funds via
380      * `transfer`. {sendValue} removes this limitation.
381      *
382      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
383      *
384      * IMPORTANT: because control is transferred to `recipient`, care must be
385      * taken to not create reentrancy vulnerabilities. Consider using
386      * {ReentrancyGuard} or the
387      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
388      */
389     function sendValue(address payable recipient, uint256 amount) internal {
390         require(address(this).balance >= amount, "Address: insufficient balance");
391 
392         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
393         (bool success, ) = recipient.call{ value: amount }("");
394         require(success, "Address: unable to send value, recipient may have reverted");
395     }
396 
397     /**
398      * @dev Performs a Solidity function call using a low level `call`. A
399      * plain`call` is an unsafe replacement for a function call: use this
400      * function instead.
401      *
402      * If `target` reverts with a revert reason, it is bubbled up by this
403      * function (like regular Solidity function calls).
404      *
405      * Returns the raw returned data. To convert to the expected return value,
406      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
407      *
408      * Requirements:
409      *
410      * - `target` must be a contract.
411      * - calling `target` with `data` must not revert.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
416       return functionCall(target, data, "Address: low-level call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
421      * `errorMessage` as a fallback revert reason when `target` reverts.
422      *
423      * _Available since v3.1._
424      */
425     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
426         return functionCallWithValue(target, data, 0, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but also transferring `value` wei to `target`.
432      *
433      * Requirements:
434      *
435      * - the calling contract must have an ETH balance of at least `value`.
436      * - the called Solidity function must be `payable`.
437      *
438      * _Available since v3.1._
439      */
440     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
441         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
446      * with `errorMessage` as a fallback revert reason when `target` reverts.
447      *
448      * _Available since v3.1._
449      */
450     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
451         require(address(this).balance >= value, "Address: insufficient balance for call");
452         require(isContract(target), "Address: call to non-contract");
453 
454         // solhint-disable-next-line avoid-low-level-calls
455         (bool success, bytes memory returndata) = target.call{ value: value }(data);
456         return _verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
461      * but performing a static call.
462      *
463      * _Available since v3.3._
464      */
465     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
466         return functionStaticCall(target, data, "Address: low-level static call failed");
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
471      * but performing a static call.
472      *
473      * _Available since v3.3._
474      */
475     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
476         require(isContract(target), "Address: static call to non-contract");
477 
478         // solhint-disable-next-line avoid-low-level-calls
479         (bool success, bytes memory returndata) = target.staticcall(data);
480         return _verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.4._
488      */
489     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
490         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
495      * but performing a delegate call.
496      *
497      * _Available since v3.4._
498      */
499     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
500         require(isContract(target), "Address: delegate call to non-contract");
501 
502         // solhint-disable-next-line avoid-low-level-calls
503         (bool success, bytes memory returndata) = target.delegatecall(data);
504         return _verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514 
515                 // solhint-disable-next-line no-inline-assembly
516                 assembly {
517                     let returndata_size := mload(returndata)
518                     revert(add(32, returndata), returndata_size)
519                 }
520             } else {
521                 revert(errorMessage);
522             }
523         }
524     }
525 }
526 
527 /**
528  * @dev Implementation of the {IERC20} interface.
529  *
530  * This implementation is agnostic to the way tokens are created. This means
531  * that a supply mechanism has to be added in a derived contract using {_mint}.
532  * For a generic mechanism see {ERC20PresetMinterPauser}.
533  *
534  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
535  * This allows applications to reconstruct the allowance for all accounts just
536  * by listening to said events. Other implementations of the EIP may not emit
537  * these events, as it isn't required by the specification.
538  *
539  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
540  * functions have been added to mitigate the well-known issues around setting
541  * allowances. See {IERC20-approve}.
542  */
543 contract ERC20 is Context, IERC20, IERC20Metadata, Ownable {
544     using SafeMath for uint256;
545     using Address for address;
546     mapping (address => uint256) private _balances;
547 
548     mapping (address => mapping (address => uint256)) private _allowances;
549     
550     mapping (address => uint256) private _rOwned;
551     mapping (address => uint256) private _tOwned;
552     
553     mapping (address => bool) private _isExcluded;
554     address[] private _excluded;
555     
556     uint256 private constant MAX = ~uint256(0);
557     
558     uint256 private _rTotal;
559     uint256 private _tFeeTotal;
560 
561     uint256 private _totalSupply;
562     uint8 private _decimal;
563     string private _name;
564     string private _symbol;
565     uint8 private _charity_percentage = 5;
566     uint8 private _marketing_percentage = 5;
567     uint8 private _reward_percentage = 2;
568     uint8 private _transaction_burn = 5;
569     address private _charity_address;
570     address private _marketing_address;
571     address private _burn_address = 0x0000000000000000000000000000000000000000;
572 
573     /**
574      * @dev Sets the values for {name} and {symbol}.
575      *
576      * The defaut value of {decimals} is 18. To select a different value for
577      * {decimals} you should overload it.
578      *
579      * All two of these values are immutable: they can only be set once during
580      * construction.
581      */
582     constructor (string memory name_, string memory symbol_, uint8 decimal_, uint256 totalSupply_, address charity_address_, address marketing_address_) {
583         _name = name_;
584         _symbol = symbol_;
585         _decimal = decimal_;
586         _charity_address = charity_address_;
587         _marketing_address = marketing_address_;
588         _totalSupply = totalSupply_;
589 
590         _rTotal = (MAX - (MAX % _totalSupply));
591         _rOwned[_msgSender()] = _rTotal;
592         _balances[_msgSender()] += _totalSupply;
593         emit Transfer(address(0), _msgSender(), _totalSupply);
594     }
595 
596     /**
597      * @dev Returns the name of the token.
598      */
599     function name() public view virtual override returns (string memory) {
600         return _name;
601     }
602 
603     /**
604      * @dev Returns the symbol of the token, usually a shorter version of the
605      * name.
606      */
607     function symbol() public view virtual override returns (string memory) {
608         return _symbol;
609     }
610 
611     /**
612      * @dev Returns the number of decimals used to get its user representation.
613      * For example, if `decimals` equals `2`, a balance of `505` tokens should
614      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
615      *
616      * Tokens usually opt for a value of 18, imitating the relationship between
617      * Ether and Wei. This is the value {ERC20} uses, unless this function is
618      * overridden;
619      *
620      * NOTE: This information is only used for _display_ purposes: it in
621      * no way affects any of the arithmetic of the contract, including
622      * {IERC20-balanceOf} and {IERC20-transfer}.
623      */
624     function decimals() public view virtual override returns (uint8) {
625         return _decimal;
626     }
627 
628     /**
629      * @dev See {IERC20-totalSupply}.
630      */
631     function totalSupply() public view virtual override returns (uint256) {
632         return _totalSupply;
633     }
634 
635     /**
636      * @dev See {IERC20-balanceOf}.
637      */
638     function balanceOf(address account) public view virtual override returns (uint256) {
639         if(account == _charity_address || account == _marketing_address) return _balances[account];
640         if (_isExcluded[account]) return _tOwned[account];
641         return tokenFromReflection(_rOwned[account]);
642     }
643 
644     /**
645      * @dev See {IERC20-transfer}.
646      *
647      * Requirements:
648      *
649      * - `recipient` cannot be the zero address.
650      * - the caller must have a balance of at least `amount`.
651      */
652     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
653         _transfer(_msgSender(), recipient, amount);
654         return true;
655     }
656 
657     /**
658      * @dev See {IERC20-allowance}.
659      */
660     function allowance(address owner, address spender) public view virtual override returns (uint256) {
661         return _allowances[owner][spender];
662     }
663 
664     /**
665      * @dev See {IERC20-approve}.
666      *
667      * Requirements:
668      *
669      * - `spender` cannot be the zero address.
670      */
671     function approve(address spender, uint256 amount) public virtual override returns (bool) {
672         _approve(_msgSender(), spender, amount);
673         return true;
674     }
675 
676     /**
677      * @dev See {IERC20-transferFrom}.
678      *
679      * Emits an {Approval} event indicating the updated allowance. This is not
680      * required by the EIP. See the note at the beginning of {ERC20}.
681      *
682      * Requirements:
683      *
684      * - `sender` and `recipient` cannot be the zero address.
685      * - `sender` must have a balance of at least `amount`.
686      * - the caller must have allowance for ``sender``'s tokens of at least
687      * `amount`.
688      */
689     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
690         _transfer(sender, recipient, amount);
691 
692         uint256 currentAllowance = _allowances[sender][_msgSender()];
693         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
694         _approve(sender, _msgSender(), currentAllowance - amount);
695 
696         return true;
697     }
698 
699     /**
700      * @dev Atomically increases the allowance granted to `spender` by the caller.
701      *
702      * This is an alternative to {approve} that can be used as a mitigation for
703      * problems described in {IERC20-approve}.
704      *
705      * Emits an {Approval} event indicating the updated allowance.
706      *
707      * Requirements:
708      *
709      * - `spender` cannot be the zero address.
710      */
711     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
712         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
713         return true;
714     }
715 
716     /**
717      * @dev Atomically decreases the allowance granted to `spender` by the caller.
718      *
719      * This is an alternative to {approve} that can be used as a mitigation for
720      * problems described in {IERC20-approve}.
721      *
722      * Emits an {Approval} event indicating the updated allowance.
723      *
724      * Requirements:
725      *
726      * - `spender` cannot be the zero address.
727      * - `spender` must have allowance for the caller of at least
728      * `subtractedValue`.
729      */
730     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
731         uint256 currentAllowance = _allowances[_msgSender()][spender];
732         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
733         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
734 
735         return true;
736     }
737     
738         /**
739      * @dev Destroys `amount` tokens from the caller.
740      *
741      * See {ERC20-_burn}.
742      */
743     function burn(uint256 amount) public virtual onlyOwner override returns (bool) {
744         _burn(_msgSender(), amount);
745         return true;
746     }
747 
748     /**
749      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
750      * allowance.
751      *
752      * See {ERC20-_burn} and {ERC20-allowance}.
753      *
754      * Requirements:
755      *
756      * - the caller must have allowance for ``accounts``'s tokens of at least
757      * `amount`.
758      */
759     function burnFrom(address account, uint256 amount) public virtual {
760         uint256 currentAllowance = allowance(account, _msgSender());
761         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
762         _approve(account, _msgSender(), currentAllowance - amount);
763         _burn(account, amount);
764     }
765 
766     /**
767      * @dev Moves tokens `amount` from `sender` to `recipient`.
768      *
769      * This is internal function is equivalent to {transfer}, and can be used to
770      * e.g. implement automatic token fees, slashing mechanisms, etc.
771      *
772      * Emits a {Transfer} event.
773      *
774      * Requirements:
775      *
776      * - `sender` cannot be the zero address.
777      * - `recipient` cannot be the zero address.
778      * - `sender` must have a balance of at least `amount`.
779      */
780     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
781         require(sender != address(0), "ERC20: transfer from the zero address");
782         require(recipient != address(0), "ERC20: transfer to the zero address");
783         require(amount > 0, "Transfer amount must be greater than zero");
784         
785         _transferStandard(sender, recipient, amount);
786     }
787 
788     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
789      * the total supply.
790      *
791      * Emits a {Transfer} event with `from` set to the zero address.
792      *
793      * Requirements:
794      *
795      * - `to` cannot be the zero address.
796      */
797     function _mint(address account, uint256 amount) internal virtual {
798         require(account != address(0), "ERC20: mint to the zero address");
799 
800         _beforeTokenTransfer(address(0), account, amount);
801 
802         _totalSupply += amount;
803         _balances[account] += amount;
804         emit Transfer(address(0), account, amount);
805     }
806 
807     /**
808      * @dev Destroys `amount` tokens from `account`, reducing the
809      * total supply.
810      *
811      * Emits a {Transfer} event with `to` set to the zero address.
812      *
813      * Requirements:
814      *
815      * - `account` cannot be the zero address.
816      * - `account` must have at least `amount` tokens.
817      */
818     function _burn(address account, uint256 amount) internal virtual {
819         require(account != address(0), "ERC20: burn from the zero address");
820 
821         _beforeTokenTransfer(account, address(0), amount);
822 
823         uint256 accountBalance = _balances[account];
824         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
825         _balances[account] = accountBalance - amount;
826         _totalSupply -= amount;
827 
828         emit Transfer(account, address(0), amount);
829     }
830 
831     function _approve(address owner, address spender, uint256 amount) internal virtual {
832         require(owner != address(0), "ERC20: approve from the zero address");
833         require(spender != address(0), "ERC20: approve to the zero address");
834 
835         _allowances[owner][spender] = amount;
836         emit Approval(owner, spender, amount);
837     }
838 
839     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
840     
841     function isExcluded(address account) public view returns (bool) {
842         return _isExcluded[account];
843     }
844 
845     function totalFees() public view returns (uint256) {
846         return _tFeeTotal;
847     }
848     
849     function reflect(uint256 tAmount) public {
850         address sender = _msgSender();
851         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
852         (uint256 rAmount,) = _getValues(tAmount);
853         _rOwned[sender] = _rOwned[sender].sub(rAmount);
854         _rTotal = _rTotal.sub(rAmount);
855         _tFeeTotal = _tFeeTotal.add(tAmount);
856     }
857 
858     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
859         require(tAmount <= _totalSupply, "Amount must be less than supply");
860         if (!deductTransferFee) {
861             (uint256 rAmount,) = _getValues(tAmount);
862             return rAmount;
863         } else {
864             (,uint256 rTransferAmount) = _getValues(tAmount);
865             return rTransferAmount;
866         }
867     }
868 
869     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
870         require(rAmount <= _rTotal, "Amount must be less than total reflections");
871         uint256 currentRate =  _getRate();
872         return rAmount.div(currentRate);
873     }
874 
875     function _transferStandard(address sender_address, address recipient_address, uint256 tAmount) private {
876         (uint256 tTransferAmount, uint256 tFee, uint256 charity_amount, uint256 marketing_amount, uint256 burn_amount) = _getTValues(tAmount);
877         uint256 currentRate =  _getRate();
878         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
879         
880         address sender = sender_address;
881         address recipient = recipient_address;
882         
883         // subtract from sender
884         uint256 sub_amount = rAmount - charity_amount - marketing_amount - burn_amount;
885         _rOwned[sender] = _rOwned[sender].sub(sub_amount);
886         
887         
888         // update amount in recipient address
889         uint256 transfer_amount = rTransferAmount - charity_amount - marketing_amount - burn_amount;
890         _rOwned[recipient] = _rOwned[recipient].add(transfer_amount);
891         
892         // reflect fee
893         _reflectFee(rFee, tFee);
894         
895         // add amount in charity and marketing address
896         _balances[_charity_address] += charity_amount;
897         _balances[_marketing_address] += marketing_amount;
898         
899         emit Transfer(sender, recipient, tTransferAmount);
900         emit Transfer(sender, _charity_address, charity_amount);
901         emit Transfer(sender, _marketing_address, marketing_amount);
902         
903         // burn transacton %
904         emit Transfer(sender, _burn_address, burn_amount);
905     }
906 
907     function _reflectFee(uint256 rFee, uint256 tFee) private {
908         _rTotal = _rTotal.sub(rFee);
909         _tFeeTotal = _tFeeTotal.add(tFee);
910     }
911 
912     function _getValues(uint256 tAmount) private view returns (uint256, uint256) {
913         uint256 total_amount = tAmount;
914         (,uint256 tFee,,,) = _getTValues(tAmount);
915         uint256 currentRate =  _getRate();
916         (uint256 rAmount, uint256 rTransferAmount,) = _getRValues(total_amount, tFee, currentRate);
917         return (rAmount, rTransferAmount);
918     }
919 
920     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
921         uint256 totalAmount = tAmount;
922         uint256 tFee = totalAmount.mul(_reward_percentage).div(10**2);
923         uint256 charity_amount = totalAmount.mul(_charity_percentage).div(10**3);
924         uint256 marketing_amount = totalAmount.mul(_marketing_percentage).div(10**3);
925         uint256 burn_amount = totalAmount.mul(_transaction_burn).div(10**3);
926         uint256 tTransferAmount = totalAmount.sub(tFee).sub(charity_amount).sub(marketing_amount).sub(burn_amount);
927         return (tTransferAmount, tFee, charity_amount, marketing_amount, burn_amount);
928     }
929 
930     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
931         uint256 rAmount = tAmount.mul(currentRate);
932         uint256 rFee = tFee.mul(currentRate);
933         uint256 rTransferAmount = rAmount.sub(rFee);
934         return (rAmount, rTransferAmount, rFee);
935     }
936 
937     function _getRate() private view returns(uint256) {
938         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
939         return rSupply.div(tSupply);
940     }
941 
942     function _getCurrentSupply() private view returns(uint256, uint256) {
943         uint256 rSupply = _rTotal;
944         uint256 tSupply = _totalSupply;      
945         for (uint256 i = 0; i < _excluded.length; i++) {
946             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _totalSupply);
947             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
948             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
949         }
950         if (rSupply < _rTotal.div(_totalSupply)) return (_rTotal, _totalSupply);
951         return (rSupply, tSupply);
952     }
953 }