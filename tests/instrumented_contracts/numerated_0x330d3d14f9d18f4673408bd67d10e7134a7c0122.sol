1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
164 
165 // SPDX-License-Identifier: MIT
166 
167 pragma solidity ^0.6.0;
168 
169 /**
170  * @dev Contract module that helps prevent reentrant calls to a function.
171  *
172  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
173  * available, which can be applied to functions to make sure there are no nested
174  * (reentrant) calls to them.
175  *
176  * Note that because there is a single `nonReentrant` guard, functions marked as
177  * `nonReentrant` may not call one another. This can be worked around by making
178  * those functions `private`, and then adding `external` `nonReentrant` entry
179  * points to them.
180  *
181  * TIP: If you would like to learn more about reentrancy and alternative ways
182  * to protect against it, check out our blog post
183  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
184  */
185 contract ReentrancyGuard {
186     // Booleans are more expensive than uint256 or any type that takes up a full
187     // word because each write operation emits an extra SLOAD to first read the
188     // slot's contents, replace the bits taken up by the boolean, and then write
189     // back. This is the compiler's defense against contract upgrades and
190     // pointer aliasing, and it cannot be disabled.
191 
192     // The values being non-zero value makes deployment a bit more expensive,
193     // but in exchange the refund on every call to nonReentrant will be lower in
194     // amount. Since refunds are capped to a percentage of the total
195     // transaction's gas, it is best to keep them low in cases like this one, to
196     // increase the likelihood of the full refund coming into effect.
197     uint256 private constant _NOT_ENTERED = 1;
198     uint256 private constant _ENTERED = 2;
199 
200     uint256 private _status;
201 
202     constructor () internal {
203         _status = _NOT_ENTERED;
204     }
205 
206     /**
207      * @dev Prevents a contract from calling itself, directly or indirectly.
208      * Calling a `nonReentrant` function from another `nonReentrant`
209      * function is not supported. It is possible to prevent this from happening
210      * by making the `nonReentrant` function external, and make it call a
211      * `private` function that does the actual work.
212      */
213     modifier nonReentrant() {
214         // On the first call to nonReentrant, _notEntered will be true
215         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
216 
217         // Any calls to nonReentrant after this point will fail
218         _status = _ENTERED;
219 
220         _;
221 
222         // By storing the original value once again, a refund is triggered (see
223         // https://eips.ethereum.org/EIPS/eip-2200)
224         _status = _NOT_ENTERED;
225     }
226 }
227 
228 // File: @openzeppelin/contracts/GSN/Context.sol
229 
230 // SPDX-License-Identifier: MIT
231 
232 pragma solidity ^0.6.0;
233 
234 /*
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with GSN meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address payable) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes memory) {
250         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
251         return msg.data;
252     }
253 }
254 
255 // File: @openzeppelin/contracts/access/Ownable.sol
256 
257 // SPDX-License-Identifier: MIT
258 
259 pragma solidity ^0.6.0;
260 
261 /**
262  * @dev Contract module which provides a basic access control mechanism, where
263  * there is an account (an owner) that can be granted exclusive access to
264  * specific functions.
265  *
266  * By default, the owner account will be the one that deploys the contract. This
267  * can later be changed with {transferOwnership}.
268  *
269  * This module is used through inheritance. It will make available the modifier
270  * `onlyOwner`, which can be applied to your functions to restrict their use to
271  * the owner.
272  */
273 contract Ownable is Context {
274     address private _owner;
275 
276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277 
278     /**
279      * @dev Initializes the contract setting the deployer as the initial owner.
280      */
281     constructor () internal {
282         address msgSender = _msgSender();
283         _owner = msgSender;
284         emit OwnershipTransferred(address(0), msgSender);
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         require(_owner == _msgSender(), "Ownable: caller is not the owner");
299         _;
300     }
301 
302     /**
303      * @dev Leaves the contract without owner. It will not be possible to call
304      * `onlyOwner` functions anymore. Can only be called by the current owner.
305      *
306      * NOTE: Renouncing ownership will leave the contract without an owner,
307      * thereby removing any functionality that is only available to the owner.
308      */
309     function renounceOwnership() public virtual onlyOwner {
310         emit OwnershipTransferred(_owner, address(0));
311         _owner = address(0);
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Can only be called by the current owner.
317      */
318     function transferOwnership(address newOwner) public virtual onlyOwner {
319         require(newOwner != address(0), "Ownable: new owner is the zero address");
320         emit OwnershipTransferred(_owner, newOwner);
321         _owner = newOwner;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
326 
327 // SPDX-License-Identifier: MIT
328 
329 pragma solidity ^0.6.0;
330 
331 /**
332  * @dev Interface of the ERC20 standard as defined in the EIP.
333  */
334 interface IERC20 {
335     /**
336      * @dev Returns the amount of tokens in existence.
337      */
338     function totalSupply() external view returns (uint256);
339 
340     /**
341      * @dev Returns the amount of tokens owned by `account`.
342      */
343     function balanceOf(address account) external view returns (uint256);
344 
345     /**
346      * @dev Moves `amount` tokens from the caller's account to `recipient`.
347      *
348      * Returns a boolean value indicating whether the operation succeeded.
349      *
350      * Emits a {Transfer} event.
351      */
352     function transfer(address recipient, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Returns the remaining number of tokens that `spender` will be
356      * allowed to spend on behalf of `owner` through {transferFrom}. This is
357      * zero by default.
358      *
359      * This value changes when {approve} or {transferFrom} are called.
360      */
361     function allowance(address owner, address spender) external view returns (uint256);
362 
363     /**
364      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
365      *
366      * Returns a boolean value indicating whether the operation succeeded.
367      *
368      * IMPORTANT: Beware that changing an allowance with this method brings the risk
369      * that someone may use both the old and the new allowance by unfortunate
370      * transaction ordering. One possible solution to mitigate this race
371      * condition is to first reduce the spender's allowance to 0 and set the
372      * desired value afterwards:
373      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
374      *
375      * Emits an {Approval} event.
376      */
377     function approve(address spender, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Moves `amount` tokens from `sender` to `recipient` using the
381      * allowance mechanism. `amount` is then deducted from the caller's
382      * allowance.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
389 
390     /**
391      * @dev Emitted when `value` tokens are moved from one account (`from`) to
392      * another (`to`).
393      *
394      * Note that `value` may be zero.
395      */
396     event Transfer(address indexed from, address indexed to, uint256 value);
397 
398     /**
399      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
400      * a call to {approve}. `value` is the new allowance.
401      */
402     event Approval(address indexed owner, address indexed spender, uint256 value);
403 }
404 
405 // File: @openzeppelin/contracts/utils/Address.sol
406 
407 // SPDX-License-Identifier: MIT
408 
409 pragma solidity ^0.6.2;
410 
411 /**
412  * @dev Collection of functions related to the address type
413  */
414 library Address {
415     /**
416      * @dev Returns true if `account` is a contract.
417      *
418      * [IMPORTANT]
419      * ====
420      * It is unsafe to assume that an address for which this function returns
421      * false is an externally-owned account (EOA) and not a contract.
422      *
423      * Among others, `isContract` will return false for the following
424      * types of addresses:
425      *
426      *  - an externally-owned account
427      *  - a contract in construction
428      *  - an address where a contract will be created
429      *  - an address where a contract lived, but was destroyed
430      * ====
431      */
432     function isContract(address account) internal view returns (bool) {
433         // This method relies in extcodesize, which returns 0 for contracts in
434         // construction, since the code is only stored at the end of the
435         // constructor execution.
436 
437         uint256 size;
438         // solhint-disable-next-line no-inline-assembly
439         assembly { size := extcodesize(account) }
440         return size > 0;
441     }
442 
443     /**
444      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
445      * `recipient`, forwarding all available gas and reverting on errors.
446      *
447      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
448      * of certain opcodes, possibly making contracts go over the 2300 gas limit
449      * imposed by `transfer`, making them unable to receive funds via
450      * `transfer`. {sendValue} removes this limitation.
451      *
452      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
453      *
454      * IMPORTANT: because control is transferred to `recipient`, care must be
455      * taken to not create reentrancy vulnerabilities. Consider using
456      * {ReentrancyGuard} or the
457      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
458      */
459     function sendValue(address payable recipient, uint256 amount) internal {
460         require(address(this).balance >= amount, "Address: insufficient balance");
461 
462         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
463         (bool success, ) = recipient.call{ value: amount }("");
464         require(success, "Address: unable to send value, recipient may have reverted");
465     }
466 
467     /**
468      * @dev Performs a Solidity function call using a low level `call`. A
469      * plain`call` is an unsafe replacement for a function call: use this
470      * function instead.
471      *
472      * If `target` reverts with a revert reason, it is bubbled up by this
473      * function (like regular Solidity function calls).
474      *
475      * Returns the raw returned data. To convert to the expected return value,
476      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
477      *
478      * Requirements:
479      *
480      * - `target` must be a contract.
481      * - calling `target` with `data` must not revert.
482      *
483      * _Available since v3.1._
484      */
485     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
486       return functionCall(target, data, "Address: low-level call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
491      * `errorMessage` as a fallback revert reason when `target` reverts.
492      *
493      * _Available since v3.1._
494      */
495     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
496         return _functionCallWithValue(target, data, 0, errorMessage);
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
501      * but also transferring `value` wei to `target`.
502      *
503      * Requirements:
504      *
505      * - the calling contract must have an ETH balance of at least `value`.
506      * - the called Solidity function must be `payable`.
507      *
508      * _Available since v3.1._
509      */
510     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
511         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
516      * with `errorMessage` as a fallback revert reason when `target` reverts.
517      *
518      * _Available since v3.1._
519      */
520     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
521         require(address(this).balance >= value, "Address: insufficient balance for call");
522         return _functionCallWithValue(target, data, value, errorMessage);
523     }
524 
525     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
526         require(isContract(target), "Address: call to non-contract");
527 
528         // solhint-disable-next-line avoid-low-level-calls
529         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
530         if (success) {
531             return returndata;
532         } else {
533             // Look for revert reason and bubble it up if present
534             if (returndata.length > 0) {
535                 // The easiest way to bubble the revert reason is using memory via assembly
536 
537                 // solhint-disable-next-line no-inline-assembly
538                 assembly {
539                     let returndata_size := mload(returndata)
540                     revert(add(32, returndata), returndata_size)
541                 }
542             } else {
543                 revert(errorMessage);
544             }
545         }
546     }
547 }
548 
549 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
550 
551 // SPDX-License-Identifier: MIT
552 
553 pragma solidity ^0.6.0;
554 
555 
556 
557 
558 
559 /**
560  * @dev Implementation of the {IERC20} interface.
561  *
562  * This implementation is agnostic to the way tokens are created. This means
563  * that a supply mechanism has to be added in a derived contract using {_mint}.
564  * For a generic mechanism see {ERC20PresetMinterPauser}.
565  *
566  * TIP: For a detailed writeup see our guide
567  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
568  * to implement supply mechanisms].
569  *
570  * We have followed general OpenZeppelin guidelines: functions revert instead
571  * of returning `false` on failure. This behavior is nonetheless conventional
572  * and does not conflict with the expectations of ERC20 applications.
573  *
574  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
575  * This allows applications to reconstruct the allowance for all accounts just
576  * by listening to said events. Other implementations of the EIP may not emit
577  * these events, as it isn't required by the specification.
578  *
579  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
580  * functions have been added to mitigate the well-known issues around setting
581  * allowances. See {IERC20-approve}.
582  */
583 contract ERC20 is Context, IERC20 {
584     using SafeMath for uint256;
585     using Address for address;
586 
587     mapping (address => uint256) private _balances;
588 
589     mapping (address => mapping (address => uint256)) private _allowances;
590 
591     uint256 private _totalSupply;
592 
593     string private _name;
594     string private _symbol;
595     uint8 private _decimals;
596 
597     /**
598      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
599      * a default value of 18.
600      *
601      * To select a different value for {decimals}, use {_setupDecimals}.
602      *
603      * All three of these values are immutable: they can only be set once during
604      * construction.
605      */
606     constructor (string memory name, string memory symbol) public {
607         _name = name;
608         _symbol = symbol;
609         _decimals = 18;
610     }
611 
612     /**
613      * @dev Returns the name of the token.
614      */
615     function name() public view returns (string memory) {
616         return _name;
617     }
618 
619     /**
620      * @dev Returns the symbol of the token, usually a shorter version of the
621      * name.
622      */
623     function symbol() public view returns (string memory) {
624         return _symbol;
625     }
626 
627     /**
628      * @dev Returns the number of decimals used to get its user representation.
629      * For example, if `decimals` equals `2`, a balance of `505` tokens should
630      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
631      *
632      * Tokens usually opt for a value of 18, imitating the relationship between
633      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
634      * called.
635      *
636      * NOTE: This information is only used for _display_ purposes: it in
637      * no way affects any of the arithmetic of the contract, including
638      * {IERC20-balanceOf} and {IERC20-transfer}.
639      */
640     function decimals() public view returns (uint8) {
641         return _decimals;
642     }
643 
644     /**
645      * @dev See {IERC20-totalSupply}.
646      */
647     function totalSupply() public view override returns (uint256) {
648         return _totalSupply;
649     }
650 
651     /**
652      * @dev See {IERC20-balanceOf}.
653      */
654     function balanceOf(address account) public view override returns (uint256) {
655         return _balances[account];
656     }
657 
658     /**
659      * @dev See {IERC20-transfer}.
660      *
661      * Requirements:
662      *
663      * - `recipient` cannot be the zero address.
664      * - the caller must have a balance of at least `amount`.
665      */
666     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
667         _transfer(_msgSender(), recipient, amount);
668         return true;
669     }
670 
671     /**
672      * @dev See {IERC20-allowance}.
673      */
674     function allowance(address owner, address spender) public view virtual override returns (uint256) {
675         return _allowances[owner][spender];
676     }
677 
678     /**
679      * @dev See {IERC20-approve}.
680      *
681      * Requirements:
682      *
683      * - `spender` cannot be the zero address.
684      */
685     function approve(address spender, uint256 amount) public virtual override returns (bool) {
686         _approve(_msgSender(), spender, amount);
687         return true;
688     }
689 
690     /**
691      * @dev See {IERC20-transferFrom}.
692      *
693      * Emits an {Approval} event indicating the updated allowance. This is not
694      * required by the EIP. See the note at the beginning of {ERC20};
695      *
696      * Requirements:
697      * - `sender` and `recipient` cannot be the zero address.
698      * - `sender` must have a balance of at least `amount`.
699      * - the caller must have allowance for ``sender``'s tokens of at least
700      * `amount`.
701      */
702     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
703         _transfer(sender, recipient, amount);
704         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
705         return true;
706     }
707 
708     /**
709      * @dev Atomically increases the allowance granted to `spender` by the caller.
710      *
711      * This is an alternative to {approve} that can be used as a mitigation for
712      * problems described in {IERC20-approve}.
713      *
714      * Emits an {Approval} event indicating the updated allowance.
715      *
716      * Requirements:
717      *
718      * - `spender` cannot be the zero address.
719      */
720     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
721         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
722         return true;
723     }
724 
725     /**
726      * @dev Atomically decreases the allowance granted to `spender` by the caller.
727      *
728      * This is an alternative to {approve} that can be used as a mitigation for
729      * problems described in {IERC20-approve}.
730      *
731      * Emits an {Approval} event indicating the updated allowance.
732      *
733      * Requirements:
734      *
735      * - `spender` cannot be the zero address.
736      * - `spender` must have allowance for the caller of at least
737      * `subtractedValue`.
738      */
739     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
740         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
741         return true;
742     }
743 
744     /**
745      * @dev Moves tokens `amount` from `sender` to `recipient`.
746      *
747      * This is internal function is equivalent to {transfer}, and can be used to
748      * e.g. implement automatic token fees, slashing mechanisms, etc.
749      *
750      * Emits a {Transfer} event.
751      *
752      * Requirements:
753      *
754      * - `sender` cannot be the zero address.
755      * - `recipient` cannot be the zero address.
756      * - `sender` must have a balance of at least `amount`.
757      */
758     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
759         require(sender != address(0), "ERC20: transfer from the zero address");
760         require(recipient != address(0), "ERC20: transfer to the zero address");
761 
762         _beforeTokenTransfer(sender, recipient, amount);
763 
764         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
765         _balances[recipient] = _balances[recipient].add(amount);
766         emit Transfer(sender, recipient, amount);
767     }
768 
769     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
770      * the total supply.
771      *
772      * Emits a {Transfer} event with `from` set to the zero address.
773      *
774      * Requirements
775      *
776      * - `to` cannot be the zero address.
777      */
778     function _mint(address account, uint256 amount) internal virtual {
779         require(account != address(0), "ERC20: mint to the zero address");
780 
781         _beforeTokenTransfer(address(0), account, amount);
782 
783         _totalSupply = _totalSupply.add(amount);
784         _balances[account] = _balances[account].add(amount);
785         emit Transfer(address(0), account, amount);
786     }
787 
788     /**
789      * @dev Destroys `amount` tokens from `account`, reducing the
790      * total supply.
791      *
792      * Emits a {Transfer} event with `to` set to the zero address.
793      *
794      * Requirements
795      *
796      * - `account` cannot be the zero address.
797      * - `account` must have at least `amount` tokens.
798      */
799     function _burn(address account, uint256 amount) internal virtual {
800         require(account != address(0), "ERC20: burn from the zero address");
801 
802         _beforeTokenTransfer(account, address(0), amount);
803 
804         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
805         _totalSupply = _totalSupply.sub(amount);
806         emit Transfer(account, address(0), amount);
807     }
808 
809     /**
810      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
811      *
812      * This internal function is equivalent to `approve`, and can be used to
813      * e.g. set automatic allowances for certain subsystems, etc.
814      *
815      * Emits an {Approval} event.
816      *
817      * Requirements:
818      *
819      * - `owner` cannot be the zero address.
820      * - `spender` cannot be the zero address.
821      */
822     function _approve(address owner, address spender, uint256 amount) internal virtual {
823         require(owner != address(0), "ERC20: approve from the zero address");
824         require(spender != address(0), "ERC20: approve to the zero address");
825 
826         _allowances[owner][spender] = amount;
827         emit Approval(owner, spender, amount);
828     }
829 
830     /**
831      * @dev Sets {decimals} to a value other than the default one of 18.
832      *
833      * WARNING: This function should only be called from the constructor. Most
834      * applications that interact with token contracts will not expect
835      * {decimals} to ever change, and may work incorrectly if it does.
836      */
837     function _setupDecimals(uint8 decimals_) internal {
838         _decimals = decimals_;
839     }
840 
841     /**
842      * @dev Hook that is called before any transfer of tokens. This includes
843      * minting and burning.
844      *
845      * Calling conditions:
846      *
847      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
848      * will be to transferred to `to`.
849      * - when `from` is zero, `amount` tokens will be minted for `to`.
850      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
851      * - `from` and `to` are never both zero.
852      *
853      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
854      */
855     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
856 }
857 
858 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
859 
860 // SPDX-License-Identifier: MIT
861 
862 pragma solidity ^0.6.0;
863 
864 
865 
866 /**
867  * @dev Extension of {ERC20} that allows token holders to destroy both their own
868  * tokens and those that they have an allowance for, in a way that can be
869  * recognized off-chain (via event analysis).
870  */
871 abstract contract ERC20Burnable is Context, ERC20 {
872     /**
873      * @dev Destroys `amount` tokens from the caller.
874      *
875      * See {ERC20-_burn}.
876      */
877     function burn(uint256 amount) public virtual {
878         _burn(_msgSender(), amount);
879     }
880 
881     /**
882      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
883      * allowance.
884      *
885      * See {ERC20-_burn} and {ERC20-allowance}.
886      *
887      * Requirements:
888      *
889      * - the caller must have allowance for ``accounts``'s tokens of at least
890      * `amount`.
891      */
892     function burnFrom(address account, uint256 amount) public virtual {
893         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
894 
895         _approve(account, _msgSender(), decreasedAllowance);
896         _burn(account, amount);
897     }
898 }
899 
900 // File: contracts/AlohaSale.sol
901 
902 pragma solidity 0.6.4;
903 
904 
905 
906 
907 
908 
909 contract AlohaSale is ReentrancyGuard, Ownable {
910 
911     using SafeMath for uint256;
912     using Address for address payable;
913 
914     // Participants for posible refunds
915     mapping(address => uint256) participants;
916 
917     mapping(address => uint256) public claimableTokens;
918 
919     // ALOHA per ETH price
920     uint256 buyPrice;
921     uint256 minimalGoal;
922     uint256 hardCap;
923 
924     ERC20Burnable crowdsaleToken;
925 
926     uint256 tokenDecimals = 18;
927 
928     event SellToken(address recepient, uint tokensSold, uint value);
929 
930     address payable fundingAddress;
931     uint256 startTimestamp;
932     uint256 endTimestamp;
933     bool started;
934     bool stopped;
935     uint256 public totalCollected;
936     uint256 totalSold;
937     bool claimEnabled = false;
938     uint256 claimWaitTime = 2 days;
939 
940 
941     /**
942     19,980,000 for Presale 
943     Buy price: 50000000000000 wei | 0,00005 eth
944     */
945     constructor(
946         ERC20Burnable _token
947     ) public {
948         minimalGoal = 333000000000000000000;
949         hardCap = 999000000000000000000;
950         buyPrice = 50000000000000;
951         crowdsaleToken = _token;
952     }
953 
954     function getToken()
955     external
956     view
957     returns(address)
958     {
959         return address(crowdsaleToken);
960     }
961 
962     function getClaimableTokens(address wallet)
963     external 
964     view
965     returns(uint256)
966     {
967       return claimableTokens[wallet];
968     }
969 
970     receive() external payable {
971         require(msg.value >= 100000000000000000, "Min 0.1 eth");
972         require(msg.value <= 10000000000000000000, "Max 10 eth");
973         sell(msg.sender, msg.value);
974     }
975 
976     // For users to claim their tokens after a successful tge
977     function claim() external 
978       nonReentrant 
979       hasntStopped()
980       whenCrowdsaleSuccessful()
981     returns (uint256) {
982         require(canClaim(), "Claim is not yet possible");
983         uint256 amount = claimableTokens[msg.sender];
984         claimableTokens[msg.sender] = 0;
985         require(crowdsaleToken.transfer(msg.sender, amount), "Error transfering");
986         return amount;
987     }
988 
989     function canClaim() public view returns (bool) {
990       return claimEnabled || block.timestamp > (endTimestamp + claimWaitTime);
991     }
992 
993     function sell(address payable _recepient, uint256 _value) internal
994         nonReentrant
995         hasBeenStarted()
996         hasntStopped()
997         whenCrowdsaleAlive()
998     {
999         uint256 newTotalCollected = totalCollected.add(_value);
1000 
1001         if (hardCap < newTotalCollected) {
1002             // Refund anything above the hard cap
1003             uint256 refund = newTotalCollected.sub(hardCap);
1004             uint256 diff = _value.sub(refund);
1005             _recepient.sendValue(refund);
1006             _value = diff;
1007             newTotalCollected = totalCollected.add(_value);
1008         }
1009         uint256 tokensSold = (_value).div(buyPrice).mul(10 ** tokenDecimals);
1010         claimableTokens[_recepient] = claimableTokens[_recepient].add(tokensSold);
1011 
1012         emit SellToken(_recepient, tokensSold, _value);
1013 
1014         participants[_recepient] = participants[_recepient].add(_value);
1015         totalCollected = totalCollected.add(_value);
1016         totalSold = totalSold.add(tokensSold);
1017     }
1018 
1019     function enableClaim(
1020     )
1021     external
1022     onlyOwner()
1023     {
1024         claimEnabled = true;
1025     }
1026 
1027     // Called to withdraw the eth on a succesful sale
1028     function withdraw(
1029         uint256 _amount
1030     )
1031     external
1032     nonReentrant
1033     onlyOwner()
1034     hasntStopped()
1035     whenCrowdsaleSuccessful()
1036     {
1037         require(_amount <= address(this).balance, "Not enough funds");
1038         fundingAddress.sendValue(_amount);
1039     }
1040 
1041     function burnUnsold()
1042     external
1043     nonReentrant
1044     onlyOwner()
1045     hasntStopped()
1046     whenCrowdsaleSuccessful()
1047     {
1048         crowdsaleToken.burn(crowdsaleToken.balanceOf(address(this)));
1049     }
1050 
1051     // Is sale fails, users will be able to get their ETH back
1052     function refund()
1053     external
1054     nonReentrant
1055     {
1056         require(stopped || isFailed(), "Not cancelled or failed");
1057         uint256 amount = participants[msg.sender];
1058 
1059         require(amount > 0, "Only once");
1060         participants[msg.sender] = 0;
1061 
1062         msg.sender.sendValue(amount);
1063     }
1064 
1065   // Cancels the presale
1066   function stop() public onlyOwner() hasntStopped()  {
1067     if (started) {
1068       require(!isFailed());
1069       require(!isSuccessful());
1070     }
1071     stopped = true;
1072   }
1073 
1074   function start(
1075     uint256 _startTimestamp,
1076     uint256 _endTimestamp,
1077     address payable _fundingAddress
1078   )
1079     public
1080     onlyOwner()
1081     hasntStarted()
1082     hasntStopped()
1083   {
1084     require(_fundingAddress != address(0));
1085     require(_endTimestamp > _startTimestamp);
1086     require(crowdsaleToken.balanceOf(address(this)) >= hardCap.div(buyPrice).mul(10 ** tokenDecimals), "Not enough tokens transfered for the sale");
1087 
1088     startTimestamp = _startTimestamp;
1089     endTimestamp = _endTimestamp;
1090     fundingAddress = _fundingAddress;
1091     started = true;
1092   }
1093 
1094   function totalTokensNeeded() external view returns (uint256) {
1095     return hardCap.div(buyPrice).mul(10 ** tokenDecimals);
1096   }
1097 
1098   function getTime()
1099     public
1100     view
1101     returns(uint256)
1102   {
1103     return block.timestamp;
1104   }
1105 
1106   function isFailed()
1107     public
1108     view
1109     returns(bool)
1110   {
1111     return (
1112       started &&
1113       block.timestamp >= endTimestamp &&
1114       totalCollected < minimalGoal
1115     );
1116   }
1117 
1118   function isActive()
1119     public
1120     view
1121     returns(bool)
1122   {
1123     return (
1124       started &&
1125       totalCollected < hardCap &&
1126       block.timestamp >= startTimestamp &&
1127       block.timestamp < endTimestamp
1128     );
1129   }
1130 
1131   function isSuccessful()
1132     public
1133     view
1134     returns(bool)
1135   {
1136     return (
1137       totalCollected >= hardCap ||
1138       (block.timestamp >= endTimestamp && totalCollected >= minimalGoal)
1139     );
1140   }
1141 
1142   modifier whenCrowdsaleAlive() {
1143     require(isActive());
1144     _;
1145   }
1146 
1147   modifier whenCrowdsaleSuccessful() {
1148     require(isSuccessful());
1149     _;
1150   }
1151 
1152   modifier hasntStopped() {
1153     require(!stopped);
1154     _;
1155   }
1156 
1157   modifier hasntStarted() {
1158     require(!started);
1159     _;
1160   }
1161 
1162   modifier hasBeenStarted() {
1163     require(started);
1164     _;
1165   }
1166 }