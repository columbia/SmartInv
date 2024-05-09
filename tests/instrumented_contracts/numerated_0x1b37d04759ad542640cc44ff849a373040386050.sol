1 // SPDX-License-Identifier: UNLICENSED
2 
3 // File: contracts/abstract/FundDistribution.sol
4 pragma solidity 0.8.9;
5 
6 /**
7  * @title Fund Distribution interface that could be used by other contracts to reference
8  * TokenFactory/MasterChef in order to enable minting/rewarding to a designated fund address.
9  */
10 interface FundDistribution {
11     /**
12      * @dev an operation that triggers reward distribution by minting to the designated address
13      * from TokenFactory. The fund address must be already configured in TokenFactory to receive
14      * funds, else no funds will be retrieved.
15      */
16     function sendReward(address _fundAddress) external returns (bool);
17 }
18 
19 // File: contracts/abstract/IERC20.sol
20 
21 
22 pragma solidity 0.8.9;
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
26  * the optional functions; to access them see {ERC20Detailed}.
27  */
28 interface IERC20 {
29 
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      * 
43      * Returns a boolean value indicating whether the operation succeeded.
44      * 
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      * 
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      * 
61      * Returns a boolean value indicating whether the operation succeeded.
62      * 
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      * 
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      * 
79      * Returns a boolean value indicating whether the operation succeeded.
80      * 
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      * 
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 
102 // File: contracts/abstract/Context.sol
103 
104 
105 pragma solidity 0.8.9;
106 
107 /*
108  * @dev Provides information about the current execution context, including the
109  * sender of the transaction and its data. While these are generally available
110  * via msg.sender and msg.data, they should not be accessed in such a direct
111  * manner, since when dealing with GSN meta-transactions the account sending and
112  * paying for execution may not be the actual sender (as far as an application
113  * is concerned).
114  * 
115  * This contract is only required for intermediate, library-like contracts.
116  */
117 abstract contract Context {
118     function _msgSender() internal view virtual returns (address) {
119         return msg.sender;
120     }
121 
122     function _msgData() internal view virtual returns (bytes calldata) {
123         return msg.data;
124     }
125 }
126 
127 
128 
129 // File: contracts/abstract/Ownable.sol
130 
131 
132 pragma solidity 0.8.9;
133 
134 
135 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/Ownable
136 
137 /**
138  * @dev Contract module which provides a basic access control mechanism, where
139  * there is an account (an owner) that can be granted exclusive access to
140  * specific functions.
141  *
142  * This module is used through inheritance. It will make available the modifier
143  * `onlyOwner`, which can be applied to your functions to restrict their use to
144  * the owner.
145  */
146 abstract contract Ownable is Context {
147     address private _owner;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151     /**
152      * @dev Initializes the contract setting the deployer as the initial owner.
153      */
154     constructor () {
155         _transferOwnership(_msgSender());
156     }
157 
158     /**
159      * @dev Returns the address of the current owner.
160      */
161     function owner() public view returns (address) {
162         return _owner;
163     }
164 
165     /**
166      * @dev Throws if called by any account other than the owner.
167      */
168     modifier onlyOwner() {
169         require(isOwner(), "Ownable: caller is not the owner");
170         _;
171     }
172 
173     /**
174      * @dev Returns true if the caller is the current owner.
175      */
176     function isOwner() public view returns (bool) {
177         return _msgSender() == _owner;
178     }
179 
180     /**
181      * @dev Leaves the contract without owner. It will not be possible to call
182      * `onlyOwner` functions anymore. Can only be called by the current owner.
183      *
184      * NOTE: Renouncing ownership will leave the contract without an owner,
185      * thereby removing any functionality that is only available to the owner.
186      */
187     function renounceOwnership() public onlyOwner {
188         emit OwnershipTransferred(_owner, address(0));
189         _owner = address(0);
190     }
191 
192     /**
193      * @dev Transfers ownership of the contract to a new account (`newOwner`).
194      * Can only be called by the current owner.
195      */
196     function transferOwnership(address newOwner) public onlyOwner {
197         _transferOwnership(newOwner);
198     }
199 
200     /**
201      * @dev Transfers ownership of the contract to a new account (`newOwner`).
202      */
203     function _transferOwnership(address newOwner) internal {
204         require(newOwner != address(0), "Ownable: new owner is the zero address");
205         emit OwnershipTransferred(_owner, newOwner);
206         _owner = newOwner;
207     }
208 }
209 
210 // File: contracts/abstract/SafeMath.sol
211 
212 
213 pragma solidity 0.8.9;
214 
215 /**
216  * @dev Wrappers over Solidity's arithmetic operations with added overflow
217  * checks.
218  * 
219  * Arithmetic operations in Solidity wrap on overflow. This can easily result
220  * in bugs, because programmers usually assume that an overflow raises an
221  * error, which is the standard behavior in high level programming languages.
222  * `SafeMath` restores this intuition by reverting the transaction when an
223  * operation overflows.
224  * 
225  * Using this library instead of the unchecked operations eliminates an entire
226  * class of bugs, so it's recommended to use it always.
227  */
228 library SafeMath {
229 
230     /**
231      * @dev Returns the addition of two unsigned integers, reverting on
232      * overflow.
233      * 
234      * Counterpart to Solidity's `+` operator.
235      * 
236      * Requirements:
237      * - Addition cannot overflow.
238      */
239     function add(uint256 a, uint256 b) internal pure returns (uint256) {
240         uint256 c = a + b;
241         require(c >= a, "SafeMath: addition overflow");
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the subtraction of two unsigned integers, reverting on
248      * overflow (when the result is negative).
249      * 
250      * Counterpart to Solidity's `-` operator.
251      * 
252      * Requirements:
253      * - Subtraction cannot overflow.
254      */
255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
256         return sub(a, b, "SafeMath: subtraction overflow");
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
261      * overflow (when the result is negative).
262      * 
263      * Counterpart to Solidity's `-` operator.
264      * 
265      * Requirements:
266      * - Subtraction cannot overflow.
267      * 
268      * _Available since v2.4.0._
269      */
270     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
271         require(b <= a, errorMessage);
272         uint256 c = a - b;
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the multiplication of two unsigned integers, reverting on
279      * overflow.
280      * 
281      * Counterpart to Solidity's `*` operator.
282      * 
283      * Requirements:
284      * - Multiplication cannot overflow.
285      */
286     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
287         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
288         // benefit is lost if 'b' is also tested.
289         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
290         if (a == 0) {
291             return 0;
292         }
293 
294         uint256 c = a * b;
295         require(c / a == b, "SafeMath: multiplication overflow");
296 
297         return c;
298     }
299 
300     /**
301      * @dev Returns the integer division of two unsigned integers. Reverts on
302      * division by zero. The result is rounded towards zero.
303      * 
304      * Counterpart to Solidity's `/` operator. Note: this function uses a
305      * `revert` opcode (which leaves remaining gas untouched) while Solidity
306      * uses an invalid opcode to revert (consuming all remaining gas).
307      * 
308      * Requirements:
309      * - The divisor cannot be zero.
310      */
311     function div(uint256 a, uint256 b) internal pure returns (uint256) {
312         return div(a, b, "SafeMath: division by zero");
313     }
314 
315     /**
316      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
317      * division by zero. The result is rounded towards zero.
318      * 
319      * Counterpart to Solidity's `/` operator. Note: this function uses a
320      * `revert` opcode (which leaves remaining gas untouched) while Solidity
321      * uses an invalid opcode to revert (consuming all remaining gas).
322      * 
323      * Requirements:
324      * - The divisor cannot be zero.
325      * 
326      * _Available since v2.4.0._
327      */
328     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
329         // Solidity only automatically asserts when dividing by 0
330         require(b > 0, errorMessage);
331         uint256 c = a / b;
332         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
333         return c;
334     }
335 
336     /**
337      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
338      * Reverts when dividing by zero.
339      * 
340      * Counterpart to Solidity's `%` operator. This function uses a `revert`
341      * opcode (which leaves remaining gas untouched) while Solidity uses an
342      * invalid opcode to revert (consuming all remaining gas).
343      * 
344      * Requirements:
345      * - The divisor cannot be zero.
346      */
347     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
348         return mod(a, b, "SafeMath: modulo by zero");
349     }
350 
351     /**
352      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
353      * Reverts with custom message when dividing by zero.
354      * 
355      * Counterpart to Solidity's `%` operator. This function uses a `revert`
356      * opcode (which leaves remaining gas untouched) while Solidity uses an
357      * invalid opcode to revert (consuming all remaining gas).
358      * 
359      * Requirements:
360      * - The divisor cannot be zero.
361      * 
362      * _Available since v2.4.0._
363      */
364     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
365         require(b != 0, errorMessage);
366         return a % b;
367     }
368 }
369 
370 
371 
372 // File: contracts/abstract/Address.sol
373 
374 
375 pragma solidity 0.8.9;
376 
377 /**
378  * @dev Collection of functions related to the address type
379  */
380 library Address {
381     /**
382      * @dev Returns true if `account` is a contract.
383      *
384      * [IMPORTANT]
385      * ====
386      * It is unsafe to assume that an address for which this function returns
387      * false is an externally-owned account (EOA) and not a contract.
388      *
389      * Among others, `isContract` will return false for the following
390      * types of addresses:
391      *
392      *  - an externally-owned account
393      *  - a contract in construction
394      *  - an address where a contract will be created
395      *  - an address where a contract lived, but was destroyed
396      * ====
397      */
398     function isContract(address account) internal view returns (bool) {
399         // This method relies on extcodesize, which returns 0 for contracts in
400         // construction, since the code is only stored at the end of the
401         // constructor execution.
402 
403         uint256 size;
404         // solhint-disable-next-line no-inline-assembly
405         assembly {
406             size := extcodesize(account)
407         }
408         return size > 0;
409     }
410 
411     /**
412      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
413      * `recipient`, forwarding all available gas and reverting on errors.
414      *
415      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
416      * of certain opcodes, possibly making contracts go over the 2300 gas limit
417      * imposed by `transfer`, making them unable to receive funds via
418      * `transfer`. {sendValue} removes this limitation.
419      *
420      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
421      *
422      * IMPORTANT: because control is transferred to `recipient`, care must be
423      * taken to not create reentrancy vulnerabilities. Consider using
424      * {ReentrancyGuard} or the
425      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
426      */
427     function sendValue(address payable recipient, uint256 amount) internal {
428         require(
429             address(this).balance >= amount,
430             "Address: insufficient balance"
431         );
432 
433         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
434         (bool success, ) = recipient.call{value: amount}("");
435         require(
436             success,
437             "Address: unable to send value, recipient may have reverted"
438         );
439     }
440 
441     /**
442      * @dev Performs a Solidity function call using a low level `call`. A
443      * plain`call` is an unsafe replacement for a function call: use this
444      * function instead.
445      *
446      * If `target` reverts with a revert reason, it is bubbled up by this
447      * function (like regular Solidity function calls).
448      *
449      * Returns the raw returned data. To convert to the expected return value,
450      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
451      *
452      * Requirements:
453      *
454      * - `target` must be a contract.
455      * - calling `target` with `data` must not revert.
456      *
457      * _Available since v3.1._
458      */
459     function functionCall(address target, bytes memory data)
460         internal
461         returns (bytes memory)
462     {
463         return functionCall(target, data, "Address: low-level call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
468      * `errorMessage` as a fallback revert reason when `target` reverts.
469      *
470      * _Available since v3.1._
471      */
472     function functionCall(
473         address target,
474         bytes memory data,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         return functionCallWithValue(target, data, 0, errorMessage);
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
482      * but also transferring `value` wei to `target`.
483      *
484      * Requirements:
485      *
486      * - the calling contract must have an ETH balance of at least `value`.
487      * - the called Solidity function must be `payable`.
488      *
489      * _Available since v3.1._
490      */
491     function functionCallWithValue(
492         address target,
493         bytes memory data,
494         uint256 value
495     ) internal returns (bytes memory) {
496         return
497             functionCallWithValue(
498                 target,
499                 data,
500                 value,
501                 "Address: low-level call with value failed"
502             );
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
507      * with `errorMessage` as a fallback revert reason when `target` reverts.
508      *
509      * _Available since v3.1._
510      */
511     function functionCallWithValue(
512         address target,
513         bytes memory data,
514         uint256 value,
515         string memory errorMessage
516     ) internal returns (bytes memory) {
517         require(
518             address(this).balance >= value,
519             "Address: insufficient balance for call"
520         );
521         require(isContract(target), "Address: call to non-contract");
522 
523         // solhint-disable-next-line avoid-low-level-calls
524         (bool success, bytes memory returndata) = target.call{value: value}(
525             data
526         );
527         return _verifyCallResult(success, returndata, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but performing a static call.
533      *
534      * _Available since v3.3._
535      */
536     function functionStaticCall(address target, bytes memory data)
537         internal
538         view
539         returns (bytes memory)
540     {
541         return
542             functionStaticCall(
543                 target,
544                 data,
545                 "Address: low-level static call failed"
546             );
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
551      * but performing a static call.
552      *
553      * _Available since v3.3._
554      */
555     function functionStaticCall(
556         address target,
557         bytes memory data,
558         string memory errorMessage
559     ) internal view returns (bytes memory) {
560         require(isContract(target), "Address: static call to non-contract");
561 
562         // solhint-disable-next-line avoid-low-level-calls
563         (bool success, bytes memory returndata) = target.staticcall(data);
564         return _verifyCallResult(success, returndata, errorMessage);
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
569      * but performing a delegate call.
570      *
571      * _Available since v3.3._
572      */
573     function functionDelegateCall(address target, bytes memory data)
574         internal
575         returns (bytes memory)
576     {
577         return
578             functionDelegateCall(
579                 target,
580                 data,
581                 "Address: low-level delegate call failed"
582             );
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
587      * but performing a delegate call.
588      *
589      * _Available since v3.3._
590      */
591     function functionDelegateCall(
592         address target,
593         bytes memory data,
594         string memory errorMessage
595     ) internal returns (bytes memory) {
596         require(isContract(target), "Address: delegate call to non-contract");
597 
598         // solhint-disable-next-line avoid-low-level-calls
599         (bool success, bytes memory returndata) = target.delegatecall(data);
600         return _verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     function _verifyCallResult(
604         bool success,
605         bytes memory returndata,
606         string memory errorMessage
607     ) private pure returns (bytes memory) {
608         if (success) {
609             return returndata;
610         } else {
611             // Look for revert reason and bubble it up if present
612             if (returndata.length > 0) {
613                 // The easiest way to bubble the revert reason is using memory via assembly
614 
615                 // solhint-disable-next-line no-inline-assembly
616                 assembly {
617                     let returndata_size := mload(returndata)
618                     revert(add(32, returndata), returndata_size)
619                 }
620             } else {
621                 revert(errorMessage);
622             }
623         }
624     }
625 }
626 
627 
628 
629 // File: contracts/abstract/ERC20.sol
630 
631 
632 pragma solidity 0.8.9;
633 
634 
635 
636 
637 
638 /**
639  * @dev Implementation of the {IERC20} interface.
640  *
641  * This implementation is agnostic to the way tokens are created. This means
642  * that a supply mechanism has to be added in a derived contract using {_mint}.
643  * For a generic mechanism see {ERC20PresetMinterPauser}.
644  *
645  * TIP: For a detailed writeup see our guide
646  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
647  * to implement supply mechanisms].
648  *
649  * We have followed general OpenZeppelin guidelines: functions revert instead
650  * of returning `false` on failure. This behavior is nonetheless conventional
651  * and does not conflict with the expectations of ERC20 applications.
652  *
653  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
654  * This allows applications to reconstruct the allowance for all accounts just
655  * by listening to said events. Other implementations of the EIP may not emit
656  * these events, as it isn't required by the specification.
657  *
658  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
659  * functions have been added to mitigate the well-known issues around setting
660  * allowances. See {IERC20-approve}.
661  */
662 abstract contract ERC20 is Context, IERC20 {
663 
664     using SafeMath for uint256;
665     using Address for address;
666 
667     mapping(address => uint256) private _balances;
668 
669     mapping(address => mapping(address => uint256)) private _allowances;
670 
671     uint256 private _totalSupply;
672 
673     string private _name;
674     string private _symbol;
675     uint8 private _decimals;
676 
677     /**
678      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
679      * a default value of 18.
680      *
681      * To select a different value for {decimals}, use {_setupDecimals}.
682      *
683      * All three of these values are immutable: they can only be set once during
684      * construction.
685      */
686     constructor(string memory tokenName, string memory tokenSymbol) {
687         _name = tokenName;
688         _symbol = tokenSymbol;
689         _decimals = 18;
690     }
691 
692     /**
693      * @dev Returns the name of the token.
694      */
695     function name() public view returns (string memory) {
696         return _name;
697     }
698 
699     /**
700      * @dev Returns the symbol of the token, usually a shorter version of the
701      * name.
702      */
703     function symbol() public view returns (string memory) {
704         return _symbol;
705     }
706 
707     /**
708      * @dev Returns the number of decimals used to get its user representation.
709      * For example, if `decimals` equals `2`, a balance of `505` tokens should
710      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
711      *
712      * Tokens usually opt for a value of 18, imitating the relationship between
713      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
714      * called.
715      *
716      * NOTE: This information is only used for _display_ purposes: it in
717      * no way affects any of the arithmetic of the contract, including
718      * {IERC20-balanceOf} and {IERC20-transfer}.
719      */
720     function decimals() public view returns (uint8) {
721         return _decimals;
722     }
723 
724     /**
725      * @dev See {IERC20-totalSupply}.
726      */
727     function totalSupply() public override view returns (uint256) {
728         return _totalSupply;
729     }
730 
731     /**
732      * @dev See {IERC20-balanceOf}.
733      */
734     function balanceOf(address account) public override view returns (uint256) {
735         return _balances[account];
736     }
737 
738     /**
739      * @dev See {IERC20-transfer}.
740      *
741      * Requirements:
742      *
743      * - `recipient` cannot be the zero address.
744      * - the caller must have a balance of at least `amount`.
745      */
746     function transfer(address recipient, uint256 amount)
747         public
748         virtual
749         override
750         returns (bool)
751     {
752         _transfer(_msgSender(), recipient, amount);
753         return true;
754     }
755 
756     /**
757      * @dev See {IERC20-allowance}.
758      */
759     function allowance(address owner, address spender)
760         public
761         virtual
762         override
763         view
764         returns (uint256)
765     {
766         return _allowances[owner][spender];
767     }
768 
769     /**
770      * @dev See {IERC20-approve}.
771      *
772      * Requirements:
773      *
774      * - `spender` cannot be the zero address.
775      */
776     function approve(address spender, uint256 amount)
777         public
778         virtual
779         override
780         returns (bool)
781     {
782         _approve(_msgSender(), spender, amount);
783         return true;
784     }
785 
786     /**
787      * @dev See {IERC20-transferFrom}.
788      *
789      * Emits an {Approval} event indicating the updated allowance. This is not
790      * required by the EIP. See the note at the beginning of {ERC20};
791      *
792      * Requirements:
793      * - `sender` and `recipient` cannot be the zero address.
794      * - `sender` must have a balance of at least `amount`.
795      * - the caller must have allowance for ``sender``'s tokens of at least
796      * `amount`.
797      */
798     function transferFrom(
799         address sender,
800         address recipient,
801         uint256 amount
802     ) public virtual override returns (bool) {
803         _transfer(sender, recipient, amount);
804         _approve(
805             sender,
806             _msgSender(),
807             _allowances[sender][_msgSender()].sub(
808                 amount,
809                 "ERC20: transfer amount exceeds allowance"
810             )
811         );
812         return true;
813     }
814 
815     /**
816      * @dev Atomically increases the allowance granted to `spender` by the caller.
817      *
818      * This is an alternative to {approve} that can be used as a mitigation for
819      * problems described in {IERC20-approve}.
820      *
821      * Emits an {Approval} event indicating the updated allowance.
822      *
823      * Requirements:
824      *
825      * - `spender` cannot be the zero address.
826      */
827     function increaseAllowance(address spender, uint256 addedValue)
828         public
829         virtual
830         returns (bool)
831     {
832         _approve(
833             _msgSender(),
834             spender,
835             _allowances[_msgSender()][spender].add(addedValue)
836         );
837         return true;
838     }
839 
840     /**
841      * @dev Atomically decreases the allowance granted to `spender` by the caller.
842      *
843      * This is an alternative to {approve} that can be used as a mitigation for
844      * problems described in {IERC20-approve}.
845      *
846      * Emits an {Approval} event indicating the updated allowance.
847      *
848      * Requirements:
849      *
850      * - `spender` cannot be the zero address.
851      * - `spender` must have allowance for the caller of at least
852      * `subtractedValue`.
853      */
854     function decreaseAllowance(address spender, uint256 subtractedValue)
855         public
856         virtual
857         returns (bool)
858     {
859         _approve(
860             _msgSender(),
861             spender,
862             _allowances[_msgSender()][spender].sub(
863                 subtractedValue,
864                 "ERC20: decreased allowance below zero"
865             )
866         );
867         return true;
868     }
869 
870     /**
871      * @dev Moves tokens `amount` from `sender` to `recipient`.
872      *
873      * This is internal function is equivalent to {transfer}, and can be used to
874      * e.g. implement automatic token fees, slashing mechanisms, etc.
875      *
876      * Emits a {Transfer} event.
877      *
878      * Requirements:
879      *
880      * - `sender` cannot be the zero address.
881      * - `recipient` cannot be the zero address.
882      * - `sender` must have a balance of at least `amount`.
883      */
884     function _transfer(
885         address sender,
886         address recipient,
887         uint256 amount
888     ) internal virtual {
889         require(sender != address(0), "ERC20: transfer from the zero address");
890         require(recipient != address(0), "ERC20: transfer to the zero address");
891 
892         _beforeTokenTransfer(sender, recipient, amount);
893 
894         _balances[sender] = _balances[sender].sub(
895             amount,
896             "ERC20: transfer amount exceeds balance"
897         );
898         _balances[recipient] = _balances[recipient].add(amount);
899         emit Transfer(sender, recipient, amount);
900     }
901 
902     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
903      * the total supply.
904      *
905      * Emits a {Transfer} event with `from` set to the zero address.
906      *
907      * Requirements
908      *
909      * - `to` cannot be the zero address.
910      */
911     function _mint(address account, uint256 amount) internal virtual {
912         require(account != address(0), "ERC20: mint to the zero address");
913 
914         _beforeTokenTransfer(address(0), account, amount);
915 
916         _totalSupply = _totalSupply.add(amount);
917         _balances[account] = _balances[account].add(amount);
918         emit Transfer(address(0), account, amount);
919     }
920 
921     /**
922      * @dev Destroys `amount` tokens from `account`, reducing the
923      * total supply.
924      *
925      * Emits a {Transfer} event with `to` set to the zero address.
926      *
927      * Requirements
928      *
929      * - `account` cannot be the zero address.
930      * - `account` must have at least `amount` tokens.
931      */
932     function _burn(address account, uint256 amount) internal virtual {
933         require(account != address(0), "ERC20: burn from the zero address");
934 
935         _beforeTokenTransfer(account, address(0), amount);
936 
937         _balances[account] = _balances[account].sub(
938             amount,
939             "ERC20: burn amount exceeds balance"
940         );
941         _totalSupply = _totalSupply.sub(amount);
942         emit Transfer(account, address(0), amount);
943     }
944 
945     /**
946      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
947      *
948      * This internal function is equivalent to `approve`, and can be used to
949      * e.g. set automatic allowances for certain subsystems, etc.
950      *
951      * Emits an {Approval} event.
952      *
953      * Requirements:
954      *
955      * - `owner` cannot be the zero address.
956      * - `spender` cannot be the zero address.
957      */
958     function _approve(
959         address owner,
960         address spender,
961         uint256 amount
962     ) internal virtual {
963         require(owner != address(0), "ERC20: approve from the zero address");
964         require(spender != address(0), "ERC20: approve to the zero address");
965 
966         _allowances[owner][spender] = amount;
967         emit Approval(owner, spender, amount);
968     }
969 
970     /**
971      * @dev Sets {decimals} to a value other than the default one of 18.
972      *
973      * WARNING: This function should only be called from the constructor. Most
974      * applications that interact with token contracts will not expect
975      * {decimals} to ever change, and may work incorrectly if it does.
976      */
977     function _setupDecimals(uint8 decimals_) internal {
978         _decimals = decimals_;
979     }
980 
981     /**
982      * @dev Hook that is called before any transfer of tokens. This includes
983      * minting and burning.
984      *
985      * Calling conditions:
986      *
987      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
988      * will be to transferred to `to`.
989      * - when `from` is zero, `amount` tokens will be minted for `to`.
990      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
991      * - `from` and `to` are never both zero.
992      *
993      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
994      */
995     function _beforeTokenTransfer(
996         address from,
997         address to,
998         uint256 amount
999     ) internal virtual {}
1000 }
1001 
1002 // File: contracts/abstract/MeedsToken.sol
1003 
1004 
1005 pragma solidity 0.8.9;
1006 
1007 
1008 
1009 contract MeedsToken is ERC20("Meeds Token", "MEED"), Ownable {
1010     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (TokenFactory).
1011     function mint(address _to, uint256 _amount) public onlyOwner {
1012         _mint(_to, _amount);
1013     }
1014 }
1015 
1016 // File: contracts/abstract/SafeERC20.sol
1017 
1018 
1019 pragma solidity 0.8.9;
1020 
1021 
1022 
1023 
1024 
1025 /**
1026  * @title SafeERC20
1027  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1028  * contract returns false). Tokens that return no value (and instead revert or
1029  * throw on failure) are also supported, non-reverting calls are assumed to be
1030  * successful.
1031  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1032  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1033  */
1034 
1035 library SafeERC20 {
1036     using SafeMath for uint256;
1037     using Address for address;
1038 
1039     function safeTransfer(
1040         IERC20 token,
1041         address to,
1042         uint256 value
1043     ) internal {
1044         _callOptionalReturn(
1045             token,
1046             abi.encodeWithSelector(token.transfer.selector, to, value)
1047         );
1048     }
1049 
1050     function safeTransferFrom(
1051         IERC20 token,
1052         address from,
1053         address to,
1054         uint256 value
1055     ) internal {
1056         _callOptionalReturn(
1057             token,
1058             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1059         );
1060     }
1061 
1062     /**
1063      * @dev Deprecated. This function has issues similar to the ones found in
1064      * {IERC20-approve}, and its usage is discouraged.
1065      *
1066      * Whenever possible, use {safeIncreaseAllowance} and
1067      * {safeDecreaseAllowance} instead.
1068      */
1069     function safeApprove(
1070         IERC20 token,
1071         address spender,
1072         uint256 value
1073     ) internal {
1074         // safeApprove should only be called when setting an initial allowance,
1075         // or when resetting it to zero. To increase and decrease it, use
1076         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1077         // solhint-disable-next-line max-line-length
1078         require(
1079             (value == 0) || (token.allowance(address(this), spender) == 0),
1080             "SafeERC20: approve from non-zero to non-zero allowance"
1081         );
1082         _callOptionalReturn(
1083             token,
1084             abi.encodeWithSelector(token.approve.selector, spender, value)
1085         );
1086     }
1087 
1088     function safeIncreaseAllowance(
1089         IERC20 token,
1090         address spender,
1091         uint256 value
1092     ) internal {
1093         uint256 newAllowance = token.allowance(address(this), spender).add(
1094             value
1095         );
1096         _callOptionalReturn(
1097             token,
1098             abi.encodeWithSelector(
1099                 token.approve.selector,
1100                 spender,
1101                 newAllowance
1102             )
1103         );
1104     }
1105 
1106     function safeDecreaseAllowance(
1107         IERC20 token,
1108         address spender,
1109         uint256 value
1110     ) internal {
1111         uint256 newAllowance = token.allowance(address(this), spender).sub(
1112             value,
1113             "SafeERC20: decreased allowance below zero"
1114         );
1115         _callOptionalReturn(
1116             token,
1117             abi.encodeWithSelector(
1118                 token.approve.selector,
1119                 spender,
1120                 newAllowance
1121             )
1122         );
1123     }
1124 
1125     /**
1126      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1127      * on the return value: the return value is optional (but if data is returned, it must not be false).
1128      * @param token The token targeted by the call.
1129      * @param data The call data (encoded using abi.encode or one of its variants).
1130      */
1131     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1132         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1133         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1134         // the target address contains contract code and also asserts for success in the low-level call.
1135 
1136         bytes memory returndata = address(token).functionCall(
1137             data,
1138             "SafeERC20: low-level call failed"
1139         );
1140         if (returndata.length > 0) {
1141             // Return data is optional
1142             // solhint-disable-next-line max-line-length
1143             require(
1144                 abi.decode(returndata, (bool)),
1145                 "SafeERC20: ERC20 operation did not succeed"
1146             );
1147         }
1148     }
1149 }
1150 
1151 // File: contracts/TokenFactory.sol
1152 
1153 
1154 pragma solidity 0.8.9;
1155 
1156 
1157 
1158 
1159 
1160 
1161 
1162 /**
1163  * @dev This contract will send MEED rewards to multiple funds by minting on MEED contract.
1164  * Since it is the only owner of the MEED Token, all minting operations will be exclusively
1165  * made here.
1166  * This contract will mint for the 3 type of Rewarding mechanisms as described in MEED white paper:
1167  * - Liquidity providers through renting and buying liquidity pools
1168  * - User Engagment within the software
1169  * - Work / services  provided by association members to build the DOM
1170  * 
1171  * In other words, MEEDs are created based on the involvment of three different categories
1172  * of stake holders:
1173  * - the capital owners
1174  * - the users
1175  * - the builders
1176  * 
1177  * Consequently, there will be two kind of Fund Contracts that will be managed by this one:
1178  * - ERC20 LP Token contracts: this contract will reward LP Token stakers
1179  * with a proportion of minted MEED per minute
1180  * - Fund contract : which will receive a proportion of minted MEED (unlike LP Token contract)
1181  *  to make the distribution switch its internal algorithm.
1182  */
1183 contract TokenFactory is Ownable, FundDistribution {
1184 
1185     using SafeMath for uint256;
1186     using SafeERC20 for IERC20;
1187     using Address for address;
1188 
1189     // Info of each user who staked LP Tokens
1190     struct UserInfo {
1191         uint256 amount; // How many LP tokens the user has staked
1192         uint256 rewardDebt; // How much MEED rewards the user had received
1193     }
1194 
1195     // Info of each fund
1196     // A fund can be either a Fund that will receive Minted MEED
1197     // to use its own rewarding distribution strategy or a Liquidity Pool.
1198     struct FundInfo {
1199         uint256 fixedPercentage; // How many fixed percentage of minted MEEDs will be sent to this fund contract
1200         uint256 allocationPoint; // How many allocation points assigned to this pool comparing to other pools
1201         uint256 lastRewardTime; // Last block timestamp that MEEDs distribution has occurred
1202         uint256 accMeedPerShare; // Accumulated MEEDs per share: price of LP Token comparing to 1 MEED (multiplied by 10^12 to make the computation more precise)
1203         bool isLPToken; // // The Liquidity Pool rewarding distribution will be handled by this contract
1204         // in contrary to a simple Fund Contract which will manage distribution by its own and thus, receive directly minted MEEDs.
1205     }
1206 
1207     // Since, the minting privilege is exclusively hold
1208     // by the current contract and it's not transferable,
1209     // this will be the absolute Maximum Supply of all MEED Token.
1210     uint256 public constant MAX_MEED_SUPPLY = 1e26;
1211 
1212     uint256 public constant MEED_REWARDING_PRECISION = 1e12;
1213 
1214     // The MEED TOKEN!
1215     MeedsToken public meed;
1216 
1217     // MEEDs minted per minute
1218     uint256 public meedPerMinute;
1219 
1220     // List of fund addresses
1221     address[] public fundAddresses;
1222 
1223     // Info of each pool
1224     mapping(address => FundInfo) public fundInfos;
1225 
1226     // Info of each user that stakes LP tokens
1227     mapping(address => mapping(address => UserInfo)) public userLpInfos;
1228 
1229     // Total allocation points. Must be the sum of all allocation points in all pools.
1230     uint256 public totalAllocationPoints = 0;
1231     // Total fixed percentage. Must be the sum of all allocation points in all pools.
1232     uint256 public totalFixedPercentage = 0;
1233 
1234     // The block time when MEED mining starts
1235     uint256 public startRewardsTime;
1236 
1237     // LP Operations Events
1238     event Deposit(address indexed user, address indexed lpAddress, uint256 amount);
1239     event Withdraw(address indexed user, address indexed lpAddress, uint256 amount);
1240     event EmergencyWithdraw(address indexed user, address indexed lpAddress, uint256 amount);
1241     event Harvest(address indexed user, address indexed lpAddress, uint256 amount);
1242 
1243     // Fund Events
1244     event FundAdded(address indexed fundAddress, uint256 allocation, bool fixedPercentage, bool isLPToken);
1245     event FundAllocationChanged(address indexed fundAddress, uint256 allocation, bool fixedPercentage);
1246 
1247     // Max MEED Supply Reached
1248     event MaxSupplyReached(uint256 timestamp);
1249 
1250     constructor (
1251         MeedsToken _meed,
1252         uint256 _meedPerMinute,
1253         uint256 _startRewardsTime
1254     ) {
1255         meed = _meed;
1256         meedPerMinute = _meedPerMinute;
1257         startRewardsTime = _startRewardsTime;
1258     }
1259 
1260     /**
1261      * @dev changes the rewarded MEEDs per minute
1262      */
1263     function setMeedPerMinute(uint256 _meedPerMinute) external onlyOwner {
1264         require(_meedPerMinute > 0, "TokenFactory#setMeedPerMinute: _meedPerMinute must be strictly positive integer");
1265         meedPerMinute = _meedPerMinute;
1266     }
1267 
1268     /**
1269      * @dev add a new Fund Address. The address must be an ERC20 LP Token contract address.
1270      * 
1271      * The proportion of MEED rewarding can be fixed (30% by example) or variable (using allocationPoints).
1272      * The allocationPoint will determine the proportion (percentage) of MEED rewarding that a fund will take
1273      * comparing to other funds using the same percentage mechanism.
1274      * 
1275      * The computing of percentage using allocationPoint mechanism is as following:
1276      * Allocation percentage = allocationPoint / totalAllocationPoints * (100 - totalFixedPercentage)
1277      * 
1278      * The computing of percentage using fixedPercentage mechanism is as following:
1279      * Allocation percentage = fixedPercentage
1280      * 
1281      * If the rewarding didn't started yet, no fund address will receive rewards.
1282      * 
1283      * See {sendReward} method for more details.
1284      */
1285     function addLPToken(IERC20 _lpToken, uint256 _value, bool _isFixedPercentage) external onlyOwner {
1286         require(address(_lpToken).isContract(), "TokenFactory#addLPToken: _fundAddress must be an ERC20 Token Address");
1287         _addFund(address(_lpToken), _value, _isFixedPercentage, true);
1288     }
1289 
1290     /**
1291      * @dev add a new Fund Address. The address can be a contract that will receive
1292      * funds and distribute MEED earnings switch a specific algorithm (User and/or Employee Engagement Program,
1293      * DAO, xMEED staking...)
1294      * 
1295      * The proportion of MEED rewarding can be fixed (30% by example) or variable (using allocationPoints).
1296      * The allocationPoint will determine the proportion (percentage) of MEED rewarding that a fund will take
1297      * comparing to other funds using the same percentage mechanism.
1298      * 
1299      * The computing of percentage using allocationPoint mechanism is as following:
1300      * Allocation percentage = allocationPoint / totalAllocationPoints * (100 - totalFixedPercentage)
1301      * 
1302      * The computing of percentage using fixedPercentage mechanism is as following:
1303      * Allocation percentage = fixedPercentage
1304      * 
1305      * If the rewarding didn't started yet, no fund will receive rewards.
1306      * 
1307      * See {sendReward} method for more details.
1308      */
1309     function addFund(address _fundAddress, uint256 _value, bool _isFixedPercentage) external onlyOwner {
1310         _addFund(_fundAddress, _value, _isFixedPercentage, false);
1311     }
1312 
1313     /**
1314      * @dev Updates the allocated rewarding ratio to the ERC20 LPToken or Fund address.
1315      * See #addLPToken and #addFund for more information.
1316      */
1317     function updateAllocation(address _fundAddress, uint256 _value, bool _isFixedPercentage) external onlyOwner {
1318         FundInfo storage fund = fundInfos[_fundAddress];
1319         require(fund.lastRewardTime > 0, "TokenFactory#updateAllocation: _fundAddress isn't a recognized LPToken nor a fund address");
1320 
1321         sendReward(_fundAddress);
1322 
1323         if (_isFixedPercentage) {
1324             require(fund.accMeedPerShare == 0, "TokenFactory#setFundAllocation Error: can't change fund percentage from variable to fixed");
1325             totalFixedPercentage = totalFixedPercentage.sub(fund.fixedPercentage).add(_value);
1326             require(totalFixedPercentage <= 100, "TokenFactory#setFundAllocation: total percentage can't be greater than 100%");
1327             fund.fixedPercentage = _value;
1328             totalAllocationPoints = totalAllocationPoints.sub(fund.allocationPoint);
1329             fund.allocationPoint = 0;
1330         } else {
1331             require(!fund.isLPToken || fund.fixedPercentage == 0, "TokenFactory#setFundAllocation Error: can't change Liquidity Pool percentage from fixed to variable");
1332             totalAllocationPoints = totalAllocationPoints.sub(fund.allocationPoint).add(_value);
1333             fund.allocationPoint = _value;
1334             totalFixedPercentage = totalFixedPercentage.sub(fund.fixedPercentage);
1335             fund.fixedPercentage = 0;
1336         }
1337         emit FundAllocationChanged(_fundAddress, _value, _isFixedPercentage);
1338     }
1339 
1340     /**
1341      * @dev update all fund allocations and send minted MEED
1342      * See {sendReward} method for more details.
1343      */
1344     function sendAllRewards() external {
1345         uint256 length = fundAddresses.length;
1346         for (uint256 index = 0; index < length; index++) {
1347             sendReward(fundAddresses[index]);
1348         }
1349     }
1350 
1351     /**
1352      * @dev update designated fund allocations and send minted MEED
1353      * See {sendReward} method for more details.
1354      */
1355     function batchSendRewards(address[] memory _fundAddresses) external {
1356         uint256 length = _fundAddresses.length;
1357         for (uint256 index = 0; index < length; index++) {
1358             sendReward(fundAddresses[index]);
1359         }
1360     }
1361 
1362     /**
1363      * @dev update designated fund allocation and send minted MEED.
1364      * 
1365      * @param _fundAddress The address can be an LP Token or another contract
1366      * that will receive funds and distribute MEED earnings switch a specific algorithm
1367      * (User and/or Employee Engagement Program, DAO, xMEED staking...)
1368      * 
1369      * The proportion of MEED rewarding can be fixed (30% by example) or variable (using allocationPoints).
1370      * The allocationPoint will determine the proportion (percentage) of MEED rewarding that a fund will take
1371      * comparing to other funds using the same percentage mechanism.
1372      * 
1373      * The computing of percentage using allocationPoint mechanism is as following:
1374      * Allocation percentage = allocationPoint / totalAllocationPoints * (100 - totalFixedPercentage)
1375      * 
1376      * The computing of percentage using fixedPercentage mechanism is as following:
1377      * Allocation percentage = fixedPercentage
1378      * 
1379      * If the rewarding didn't started yet, no fund will receive rewards.
1380      * 
1381      * For LP Token funds, the reward distribution per wallet will be managed in this contract,
1382      * thus, by calling this method, the LP Token rewards will be sent to this contract and then
1383      * the reward distribution can be claimed wallet by wallet by using method {harvest}, {deposit}
1384      * or {withdraw}.
1385      * for other type of funds, the Rewards will be sent directly to the contract/wallet address
1386      * to manage Reward distribution to wallets switch its specific algorithm outside this contract.
1387      */
1388     function sendReward(address _fundAddress) public override returns (bool) {
1389         // Minting didn't started yet
1390         if (block.timestamp < startRewardsTime) {
1391             return true;
1392         }
1393 
1394         FundInfo storage fund = fundInfos[_fundAddress];
1395         require(fund.lastRewardTime > 0, "TokenFactory#sendReward: _fundAddress isn't a recognized LPToken nor a fund address");
1396 
1397         uint256 pendingRewardAmount = _pendingRewardBalanceOf(fund);
1398         if (fund.isLPToken) {
1399           fund.accMeedPerShare = _getAccMeedPerShare(_fundAddress, pendingRewardAmount);
1400           _mint(address(this), pendingRewardAmount);
1401         } else {
1402           _mint(_fundAddress, pendingRewardAmount);
1403         }
1404         fund.lastRewardTime = block.timestamp;
1405         return true;
1406     }
1407 
1408     /**
1409      * @dev a wallet will stake an LP Token amount to an already configured address
1410      * (LP Token address).
1411      * 
1412      * When staking LP Tokens, the pending MEED rewards will be sent to current wallet
1413      * and LP Token will be staked in current contract address.
1414      * The LP Farming algorithm is inspired from ERC-2917 Demo:
1415      * 
1416      * https://github.com/gnufoo/ERC2917-Proposal/blob/master/contracts/ERC2917.sol
1417      */
1418     function deposit(IERC20 _lpToken, uint256 _amount) public {
1419         address _lpAddress = address(_lpToken);
1420         FundInfo storage fund = fundInfos[_lpAddress];
1421         require(fund.isLPToken, "TokenFactory#deposit Error: Liquidity Pool doesn't exist");
1422 
1423         // Update & Mint MEED for the designated pool
1424         // to ensure systematically to have enough
1425         // MEEDs balance in current contract
1426         sendReward(_lpAddress);
1427 
1428         UserInfo storage user = userLpInfos[_lpAddress][msg.sender];
1429         if (user.amount > 0) {
1430             uint256 pending = user
1431                 .amount
1432                 .mul(fund.accMeedPerShare).div(MEED_REWARDING_PRECISION)
1433                 .sub(user.rewardDebt);
1434             _safeMeedTransfer(msg.sender, pending);
1435         }
1436         IERC20(_lpAddress).safeTransferFrom(address(msg.sender), address(this), _amount);
1437         user.amount = user.amount.add(_amount);
1438         user.rewardDebt = user.amount.mul(fund.accMeedPerShare).div(MEED_REWARDING_PRECISION);
1439         emit Deposit(msg.sender, _lpAddress, _amount);
1440     }
1441 
1442     /**
1443      * @dev a wallet will withdraw an amount of already staked LP Tokens.
1444      * 
1445      * When this operation is triggered, the pending MEED rewards will be sent to current wallet
1446      * and LP Token will be send back to caller address from current contract balance of staked LP Tokens.
1447      * The LP Farming algorithm is inspired from ERC-2917 Demo:
1448      * https://github.com/gnufoo/ERC2917-Proposal/blob/master/contracts/ERC2917.sol
1449      * 
1450      * If the amount of withdrawn LP Tokens is 0, only {harvest}ing the pending reward will be made.
1451      */
1452     function withdraw(IERC20 _lpToken, uint256 _amount) public {
1453         address _lpAddress = address(_lpToken);
1454         FundInfo storage fund = fundInfos[_lpAddress];
1455         require(fund.isLPToken, "TokenFactory#withdraw Error: Liquidity Pool doesn't exist");
1456 
1457         // Update & Mint MEED for the designated pool
1458         // to ensure systematically to have enough
1459         // MEEDs balance in current contract
1460         sendReward(_lpAddress);
1461 
1462         UserInfo storage user = userLpInfos[_lpAddress][msg.sender];
1463         // Send pending MEED Reward to user
1464         uint256 pendingUserReward = user.amount.mul(fund.accMeedPerShare).div(1e12).sub(
1465             user.rewardDebt
1466         );
1467         _safeMeedTransfer(msg.sender, pendingUserReward);
1468         user.amount = user.amount.sub(_amount);
1469         user.rewardDebt = user.amount.mul(fund.accMeedPerShare).div(1e12);
1470 
1471         if (_amount > 0) {
1472           // Send pending Reward
1473           IERC20(_lpAddress).safeTransfer(address(msg.sender), _amount);
1474           emit Withdraw(msg.sender, _lpAddress, _amount);
1475         } else {
1476           emit Harvest(msg.sender, _lpAddress, pendingUserReward);
1477         }
1478     }
1479 
1480     /**
1481      * @dev Withdraw without caring about rewards. EMERGENCY ONLY.
1482      */
1483     function emergencyWithdraw(IERC20 _lpToken) public {
1484         address _lpAddress = address(_lpToken);
1485         FundInfo storage fund = fundInfos[_lpAddress];
1486         require(fund.isLPToken, "TokenFactory#emergencyWithdraw Error: Liquidity Pool doesn't exist");
1487 
1488         UserInfo storage user = userLpInfos[_lpAddress][msg.sender];
1489         uint256 amount = user.amount;
1490         user.amount = 0;
1491         user.rewardDebt = 0;
1492 
1493         IERC20(_lpAddress).safeTransfer(address(msg.sender), amount);
1494         emit EmergencyWithdraw(msg.sender, _lpAddress, amount);
1495     }
1496 
1497     /**
1498      * @dev Claim reward for current wallet from designated Liquidity Pool
1499      */
1500     function harvest(IERC20 _lpAddress) public {
1501         withdraw(_lpAddress, 0);
1502     }
1503 
1504     function fundsLength() public view returns (uint256) {
1505         return fundAddresses.length;
1506     }
1507 
1508     /**
1509      * @dev returns the pending amount of wallet rewarding from LP Token Fund.
1510      * this operation is possible only when the LP Token address is an ERC-20 Token.
1511      * If the rewarding program didn't started yet, 0 will be returned.
1512      */
1513     function pendingRewardBalanceOf(IERC20 _lpToken, address _user) public view returns (uint256) {
1514         address _lpAddress = address(_lpToken);
1515         if (block.timestamp < startRewardsTime) {
1516             return 0;
1517         }
1518         FundInfo storage fund = fundInfos[_lpAddress];
1519         if (!fund.isLPToken) {
1520             return 0;
1521         }
1522         uint256 pendingRewardAmount = _pendingRewardBalanceOf(fund);
1523         uint256 accMeedPerShare = _getAccMeedPerShare(_lpAddress, pendingRewardAmount);
1524         UserInfo storage user = userLpInfos[_lpAddress][_user];
1525         return user.amount.mul(accMeedPerShare).div(MEED_REWARDING_PRECISION).sub(user.rewardDebt);
1526     }
1527 
1528     /**
1529      * @dev returns the pending amount of MEED rewarding for a designated Fund address.
1530      * See {sendReward} method for more details.
1531      */
1532     function pendingRewardBalanceOf(address _fundAddress) public view returns (uint256) {
1533         if (block.timestamp < startRewardsTime) {
1534             return 0;
1535         }
1536         return _pendingRewardBalanceOf(fundInfos[_fundAddress]);
1537     }
1538 
1539     /**
1540      * @dev add a new Fund Address. The address can be an LP Token or another contract
1541      * that will receive funds and distribute MEED earnings switch a specific algorithm
1542      * (User and/or Employee Engagement Program, DAO, xMEED staking...)
1543      * 
1544      * The proportion of MEED rewarding can be fixed (30% by example) or variable (using allocationPoints).
1545      * The allocationPoint will determine the proportion (percentage) of MEED rewarding that a fund will take
1546      * comparing to other funds using the same percentage mechanism.
1547      * 
1548      * The computing of percentage using allocationPoint mechanism is as following:
1549      * Allocation percentage = allocationPoint / totalAllocationPoints * (100 - totalFixedPercentage)
1550      * 
1551      * The computing of percentage using fixedPercentage mechanism is as following:
1552      * Allocation percentage = fixedPercentage
1553      * 
1554      * If the rewarding didn't started yet, no fund will receive rewards.
1555      * 
1556      * See {sendReward} method for more details.
1557      */
1558     function _addFund(address _fundAddress, uint256 _value, bool _isFixedPercentage, bool _isLPToken) private {
1559         require(fundInfos[_fundAddress].lastRewardTime == 0, "TokenFactory#_addFund : Fund address already exists, use #setFundAllocation to change allocation");
1560 
1561         uint256 lastRewardTime = block.timestamp > startRewardsTime ? block.timestamp : startRewardsTime;
1562 
1563         fundAddresses.push(_fundAddress);
1564         fundInfos[_fundAddress] = FundInfo({
1565           lastRewardTime: lastRewardTime,
1566           isLPToken: _isLPToken,
1567           allocationPoint: 0,
1568           fixedPercentage: 0,
1569           accMeedPerShare: 0
1570         });
1571 
1572         if (_isFixedPercentage) {
1573             totalFixedPercentage = totalFixedPercentage.add(_value);
1574             fundInfos[_fundAddress].fixedPercentage = _value;
1575             require(totalFixedPercentage <= 100, "TokenFactory#_addFund: total percentage can't be greater than 100%");
1576         } else {
1577             totalAllocationPoints = totalAllocationPoints.add(_value);
1578             fundInfos[_fundAddress].allocationPoint = _value;
1579         }
1580         emit FundAdded(_fundAddress, _value, _isFixedPercentage, _isLPToken);
1581     }
1582 
1583     function _getMultiplier(uint256 _fromTimestamp, uint256 _toTimestamp) internal view returns (uint256) {
1584         return _toTimestamp.sub(_fromTimestamp).mul(meedPerMinute).div(1 minutes);
1585     }
1586 
1587     function _pendingRewardBalanceOf(FundInfo memory _fund) internal view returns (uint256) {
1588         uint256 periodTotalMeedRewards = _getMultiplier(_fund.lastRewardTime, block.timestamp);
1589         if (_fund.fixedPercentage > 0) {
1590           return periodTotalMeedRewards
1591             .mul(_fund.fixedPercentage)
1592             .div(100);
1593         } else if (_fund.allocationPoint > 0) {
1594           return periodTotalMeedRewards
1595             .mul(_fund.allocationPoint)
1596             .mul(100 - totalFixedPercentage)
1597             .div(totalAllocationPoints)
1598             .div(100);
1599         }
1600         return 0;
1601     }
1602 
1603     function _getAccMeedPerShare(address _lpAddress, uint256 pendingRewardAmount) internal view returns (uint256) {
1604         FundInfo memory fund = fundInfos[_lpAddress];
1605         if (block.timestamp > fund.lastRewardTime) {
1606             uint256 lpSupply = IERC20(_lpAddress).balanceOf(address(this));
1607             if (lpSupply > 0) {
1608               return fund.accMeedPerShare.add(pendingRewardAmount.mul(MEED_REWARDING_PRECISION).div(lpSupply));
1609             }
1610         }
1611         return fund.accMeedPerShare;
1612     }
1613 
1614     function _safeMeedTransfer(address _to, uint256 _amount) internal {
1615         uint256 meedBal = meed.balanceOf(address(this));
1616         if (_amount > meedBal) {
1617             meed.transfer(_to, meedBal);
1618         } else {
1619             meed.transfer(_to, _amount);
1620         }
1621     }
1622 
1623     function _mint(address _to, uint256 _amount) internal {
1624         uint256 totalSupply = meed.totalSupply();
1625         if (totalSupply.add(_amount) > MAX_MEED_SUPPLY) {
1626             if (MAX_MEED_SUPPLY > totalSupply) {
1627               uint256 remainingAmount = MAX_MEED_SUPPLY.sub(totalSupply);
1628               meed.mint(_to, remainingAmount);
1629               emit MaxSupplyReached(block.timestamp);
1630             }
1631         } else {
1632             meed.mint(_to, _amount);
1633         }
1634     }
1635 
1636 }