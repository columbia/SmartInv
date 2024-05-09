1 // SPDX-License-Identifier: UNLICENSED
2 
3 /*
4 `7MMF'     A     `7MF' db `7MMF'   `7MF'      
5   `MA     ,MA     ,V  ;MM:  `MA     ,V        
6    VM:   ,VVM:   ,V  ,V^MM.  VM:   ,V pd""b.  
7     MM.  M' MM.  M' ,M  `MM   MM.  M'(O)  `8b 
8     `MM A'  `MM A'  AbmmmqMA  `MM A'      ,89 
9      :MM;    :MM;  A'     VML  :MM;     ""Yb. 
10       VF      VF .AMA.   .AMMA. VF         88 
11                                      (O)  .M' 
12                                       bmmmd'  
13 
14 * Similar to water molecules — WAV3 join to the highly volatile Cryptocurrency market, it is not affected by a special deflation mechanism, but is highly yield.
15 * Get inspired by projects: Sav3, ETHY, K3PR, BOND, ...
16 * Each Transfer/Sell transaction on Uniswap will be charged 6% as transaction fee (of which 90% will be sent directly to WStake as rewards
17 * 10% will be burned immediately, the total supply will go down continuously until reaching 30,000 WAV3)
18 
19 */
20 
21 pragma solidity ^0.6.12;
22 
23 /*
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with GSN meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal virtual view returns (address payable) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal virtual view returns (bytes memory) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 /**
45  * @dev Interface of the ERC20 standard as defined in the EIP.
46  */
47 interface IERC20 {
48     /**
49      * @dev Returns the amount of tokens in existence.
50      */
51     function totalSupply() external view returns (uint256);
52 
53     /**
54      * @dev Returns the amount of tokens owned by `account`.
55      */
56     function balanceOf(address account) external view returns (uint256);
57 
58     /**
59      * @dev Moves `amount` tokens from the caller's account to `recipient`.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transfer(address recipient, uint256 amount)
66         external
67         returns (bool);
68 
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through {transferFrom}. This is
72      * zero by default.
73      *
74      * This value changes when {approve} or {transferFrom} are called.
75      */
76     function allowance(address owner, address spender)
77         external
78         view
79         returns (uint256);
80 
81     /**
82      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * IMPORTANT: Beware that changing an allowance with this method brings the risk
87      * that someone may use both the old and the new allowance by unfortunate
88      * transaction ordering. One possible solution to mitigate this race
89      * condition is to first reduce the spender's allowance to 0 and set the
90      * desired value afterwards:
91      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Moves `amount` tokens from `sender` to `recipient` using the
99      * allowance mechanism. `amount` is then deducted from the caller's
100      * allowance.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address sender,
108         address recipient,
109         uint256 amount
110     ) external returns (bool);
111 
112     /**
113      * @dev Emitted when `value` tokens are moved from one account (`from`) to
114      * another (`to`).
115      *
116      * Note that `value` may be zero.
117      */
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120     /**
121      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
122      * a call to {approve}. `value` is the new allowance.
123      */
124     event Approval(
125         address indexed owner,
126         address indexed spender,
127         uint256 value
128     );
129 }
130 
131 /**
132  * @dev Wrappers over Solidity's arithmetic operations with added overflow
133  * checks.
134  *
135  * Arithmetic operations in Solidity wrap on overflow. This can easily result
136  * in bugs, because programmers usually assume that an overflow raises an
137  * error, which is the standard behavior in high level programming languages.
138  * `SafeMath` restores this intuition by reverting the transaction when an
139  * operation overflows.
140  *
141  * Using this library instead of the unchecked operations eliminates an entire
142  * class of bugs, so it's recommended to use it always.
143  */
144 library SafeMath {
145     /**
146      * @dev Returns the addition of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `+` operator.
150      *
151      * Requirements:
152      *
153      * - Addition cannot overflow.
154      */
155     function add(uint256 a, uint256 b) internal pure returns (uint256) {
156         uint256 c = a + b;
157         require(c >= a, "SafeMath: addition overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         return sub(a, b, "SafeMath: subtraction overflow");
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(
187         uint256 a,
188         uint256 b,
189         string memory errorMessage
190     ) internal pure returns (uint256) {
191         require(b <= a, errorMessage);
192         uint256 c = a - b;
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the multiplication of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `*` operator.
202      *
203      * Requirements:
204      *
205      * - Multiplication cannot overflow.
206      */
207     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
208         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
209         // benefit is lost if 'b' is also tested.
210         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
211         if (a == 0) {
212             return 0;
213         }
214 
215         uint256 c = a * b;
216         require(c / a == b, "SafeMath: multiplication overflow");
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers. Reverts on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b) internal pure returns (uint256) {
234         return div(a, b, "SafeMath: division by zero");
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
239      * division by zero. The result is rounded towards zero.
240      *
241      * Counterpart to Solidity's `/` operator. Note: this function uses a
242      * `revert` opcode (which leaves remaining gas untouched) while Solidity
243      * uses an invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function div(
250         uint256 a,
251         uint256 b,
252         string memory errorMessage
253     ) internal pure returns (uint256) {
254         require(b > 0, errorMessage);
255         uint256 c = a / b;
256         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
257 
258         return c;
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * Reverts when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
274         return mod(a, b, "SafeMath: modulo by zero");
275     }
276 
277     /**
278      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
279      * Reverts with custom message when dividing by zero.
280      *
281      * Counterpart to Solidity's `%` operator. This function uses a `revert`
282      * opcode (which leaves remaining gas untouched) while Solidity uses an
283      * invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function mod(
290         uint256 a,
291         uint256 b,
292         string memory errorMessage
293     ) internal pure returns (uint256) {
294         require(b != 0, errorMessage);
295         return a % b;
296     }
297 }
298 
299 /**
300  * @dev Collection of functions related to the address type
301  */
302 library Address {
303     /**
304      * @dev Returns true if `account` is a contract.
305      *
306      * [IMPORTANT]
307      * ====
308      * It is unsafe to assume that an address for which this function returns
309      * false is an externally-owned account (EOA) and not a contract.
310      *
311      * Among others, `isContract` will return false for the following
312      * types of addresses:
313      *
314      *  - an externally-owned account
315      *  - a contract in construction
316      *  - an address where a contract will be created
317      *  - an address where a contract lived, but was destroyed
318      * ====
319      */
320     function isContract(address account) internal view returns (bool) {
321         // This method relies in extcodesize, which returns 0 for contracts in
322         // construction, since the code is only stored at the end of the
323         // constructor execution.
324 
325         uint256 size;
326         // solhint-disable-next-line no-inline-assembly
327         assembly {
328             size := extcodesize(account)
329         }
330         return size > 0;
331     }
332 
333     /**
334      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
335      * `recipient`, forwarding all available gas and reverting on errors.
336      *
337      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
338      * of certain opcodes, possibly making contracts go over the 2300 gas limit
339      * imposed by `transfer`, making them unable to receive funds via
340      * `transfer`. {sendValue} removes this limitation.
341      *
342      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
343      *
344      * IMPORTANT: because control is transferred to `recipient`, care must be
345      * taken to not create reentrancy vulnerabilities. Consider using
346      * {ReentrancyGuard} or the
347      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
348      */
349     function sendValue(address payable recipient, uint256 amount) internal {
350         require(
351             address(this).balance >= amount,
352             "Address: insufficient balance"
353         );
354 
355         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
356         (bool success, ) = recipient.call{value: amount}("");
357         require(
358             success,
359             "Address: unable to send value, recipient may have reverted"
360         );
361     }
362 
363     /**
364      * @dev Performs a Solidity function call using a low level `call`. A
365      * plain`call` is an unsafe replacement for a function call: use this
366      * function instead.
367      *
368      * If `target` reverts with a revert reason, it is bubbled up by this
369      * function (like regular Solidity function calls).
370      *
371      * Returns the raw returned data. To convert to the expected return value,
372      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
373      *
374      * Requirements:
375      *
376      * - `target` must be a contract.
377      * - calling `target` with `data` must not revert.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data)
382         internal
383         returns (bytes memory)
384     {
385         return functionCall(target, data, "Address: low-level call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
390      * `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         return _functionCallWithValue(target, data, 0, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but also transferring `value` wei to `target`.
405      *
406      * Requirements:
407      *
408      * - the calling contract must have an ETH balance of at least `value`.
409      * - the called Solidity function must be `payable`.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value
417     ) internal returns (bytes memory) {
418         return
419             functionCallWithValue(
420                 target,
421                 data,
422                 value,
423                 "Address: low-level call with value failed"
424             );
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429      * with `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(
434         address target,
435         bytes memory data,
436         uint256 value,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         require(
440             address(this).balance >= value,
441             "Address: insufficient balance for call"
442         );
443         return _functionCallWithValue(target, data, value, errorMessage);
444     }
445 
446     function _functionCallWithValue(
447         address target,
448         bytes memory data,
449         uint256 weiValue,
450         string memory errorMessage
451     ) private returns (bytes memory) {
452         require(isContract(target), "Address: call to non-contract");
453 
454         // solhint-disable-next-line avoid-low-level-calls
455         (bool success, bytes memory returndata) = target.call{value: weiValue}(
456             data
457         );
458         if (success) {
459             return returndata;
460         } else {
461             // Look for revert reason and bubble it up if present
462             if (returndata.length > 0) {
463                 // The easiest way to bubble the revert reason is using memory via assembly
464 
465                 // solhint-disable-next-line no-inline-assembly
466                 assembly {
467                     let returndata_size := mload(returndata)
468                     revert(add(32, returndata), returndata_size)
469                 }
470             } else {
471                 revert(errorMessage);
472             }
473         }
474     }
475 }
476 
477 /**
478  * @dev Contract module which provides a basic access control mechanism, where
479  * there is an account (an owner) that can be granted exclusive access to
480  * specific functions.
481  *
482  * By default, the owner account will be the one that deploys the contract. This
483  * can later be changed with {transferOwnership}.
484  *
485  * This module is used through inheritance. It will make available the modifier
486  * `onlyOwner`, which can be applied to your functions to restrict their use to
487  * the owner.
488  */
489 contract Ownable is Context {
490     address private _owner;
491 
492     event OwnershipTransferred(
493         address indexed previousOwner,
494         address indexed newOwner
495     );
496 
497     /**
498      * @dev Initializes the contract setting the deployer as the initial owner.
499      */
500     constructor() internal {
501         address msgSender = _msgSender();
502         _owner = msgSender;
503         emit OwnershipTransferred(address(0), msgSender);
504     }
505 
506     /**
507      * @dev Returns the address of the current owner.
508      */
509     function owner() public view returns (address) {
510         return _owner;
511     }
512 
513     /**
514      * @dev Throws if called by any account other than the owner.
515      */
516     modifier onlyOwner() {
517         require(_owner == _msgSender(), "Ownable: caller is not the owner");
518         _;
519     }
520 
521     /**
522      * @dev Leaves the contract without owner. It will not be possible to call
523      * `onlyOwner` functions anymore. Can only be called by the current owner.
524      *
525      * NOTE: Renouncing ownership will leave the contract without an owner,
526      * thereby removing any functionality that is only available to the owner.
527      */
528     function renounceOwnership() public virtual onlyOwner {
529         emit OwnershipTransferred(_owner, address(0));
530         _owner = address(0);
531     }
532 
533     /**
534      * @dev Transfers ownership of the contract to a new account (`newOwner`).
535      * Can only be called by the current owner.
536      */
537     function transferOwnership(address newOwner) public virtual onlyOwner {
538         require(
539             newOwner != address(0),
540             "Ownable: new owner is the zero address"
541         );
542         emit OwnershipTransferred(_owner, newOwner);
543         _owner = newOwner;
544     }
545 }
546 
547 /**
548  * @dev Implementation of the {IERC20} interface.
549  *
550  * This implementation is agnostic to the way tokens are created. This means
551  * that a supply mechanism has to be added in a derived contract using {_mint}.
552  * For a generic mechanism see {ERC20PresetMinterPauser}.
553  *
554  * TIP: For a detailed writeup see our guide
555  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
556  * to implement supply mechanisms].
557  *
558  * We have followed general OpenZeppelin guidelines: functions revert instead
559  * of returning `false` on failure. This behavior is nonetheless conventional
560  * and does not conflict with the expectations of ERC20 applications.
561  *
562  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
563  * This allows applications to reconstruct the allowance for all accounts just
564  * by listening to said events. Other implementations of the EIP may not emit
565  * these events, as it isn't required by the specification.
566  *
567  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
568  * functions have been added to mitigate the well-known issues around setting
569  * allowances. See {IERC20-approve}.
570  */
571 contract DeflationaryERC20 is Context, IERC20, Ownable {
572     using SafeMath for uint256;
573     using Address for address;
574 
575     mapping(address => uint256) private _balances;
576     mapping(address => mapping(address => uint256)) private _allowances;
577 
578     uint256 private _totalSupply;
579     
580     //minimumsupply is 30000 WAV3. When the supply reach 30000, no more fee for transaction.
581     uint256 private _minTotalSupply = 30000e18;
582 
583     string private _name;
584     string private _symbol;
585     uint8 private _decimals;
586 
587     // Transaction Fees:
588     uint8 public txFee = 60; // artifical cap of 255 e.g. 25.5%
589     address public feeDistributor; // fees are sent to fee distributer
590 
591     // Fee Whitelist
592     mapping(address => bool) public feelessSender;
593     mapping(address => bool) public feelessReciever;
594     // if this equals false whitelist can nolonger be added to.
595     bool public canWhitelist = true;
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
606     constructor(string memory name, string memory symbol) public {
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
647     function totalSupply() public override view returns (uint256) {
648         return _totalSupply;
649     }
650 
651     /**
652      * @dev See {IERC20-balanceOf}.
653      */
654     function balanceOf(address account) public override view returns (uint256) {
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
666     function transfer(address recipient, uint256 amount)
667         public
668         virtual
669         override
670         returns (bool)
671     {
672         _transfer(_msgSender(), recipient, amount);
673         return true;
674     }
675 
676     /**
677      * @dev See {IERC20-allowance}.
678      */
679     function allowance(address owner, address spender)
680         public
681         virtual
682         override
683         view
684         returns (uint256)
685     {
686         return _allowances[owner][spender];
687     }
688 
689     /**
690      * @dev See {IERC20-approve}.
691      *
692      * Requirements:
693      *
694      * - `spender` cannot be the zero address.
695      */
696     function approve(address spender, uint256 amount)
697         public
698         virtual
699         override
700         returns (bool)
701     {
702         _approve(_msgSender(), spender, amount);
703         return true;
704     }
705 
706     /**
707      * @dev See {IERC20-transferFrom}.
708      *
709      * Emits an {Approval} event indicating the updated allowance. This is not
710      * required by the EIP. See the note at the beginning of {ERC20};
711      *
712      * Requirements:
713      * - `sender` and `recipient` cannot be the zero address.
714      * - `sender` must have a balance of at least `amount`.
715      * - the caller must have allowance for ``sender``'s tokens of at least
716      * `amount`.
717      */
718     function transferFrom(
719         address sender,
720         address recipient,
721         uint256 amount
722     ) public virtual override returns (bool) {
723         _transfer(sender, recipient, amount);
724         _approve(
725             sender,
726             _msgSender(),
727             _allowances[sender][_msgSender()].sub(
728                 amount,
729                 "ERC20: transfer amount exceeds allowance"
730             )
731         );
732         return true;
733     }
734 
735     /**
736      * @dev Atomically increases the allowance granted to `spender` by the caller.
737      *
738      * This is an alternative to {approve} that can be used as a mitigation for
739      * problems described in {IERC20-approve}.
740      *
741      * Emits an {Approval} event indicating the updated allowance.
742      *
743      * Requirements:
744      *
745      * - `spender` cannot be the zero address.
746      */
747     function increaseAllowance(address spender, uint256 addedValue)
748         public
749         virtual
750         returns (bool)
751     {
752         _approve(
753             _msgSender(),
754             spender,
755             _allowances[_msgSender()][spender].add(addedValue)
756         );
757         return true;
758     }
759 
760     /**
761      * @dev Atomically decreases the allowance granted to `spender` by the caller.
762      *
763      * This is an alternative to {approve} that can be used as a mitigation for
764      * problems described in {IERC20-approve}.
765      *
766      * Emits an {Approval} event indicating the updated allowance.
767      *
768      * Requirements:
769      *
770      * - `spender` cannot be the zero address.
771      * - `spender` must have allowance for the caller of at least
772      * `subtractedValue`.
773      */
774     function decreaseAllowance(address spender, uint256 subtractedValue)
775         public
776         virtual
777         returns (bool)
778     {
779         _approve(
780             _msgSender(),
781             spender,
782             _allowances[_msgSender()][spender].sub(
783                 subtractedValue,
784                 "ERC20: decreased allowance below zero"
785             )
786         );
787         return true;
788     }
789 
790     // assign a new transactionfee
791     function setFee(uint8 _newTxFee) public onlyOwner {
792         txFee = _newTxFee;
793     }
794 
795     // assign a new fee distributor address
796     function setFeeDistributor(address _distributor) public onlyOwner {
797         feeDistributor = _distributor;
798     }
799 
800     // enable/disable sender who can send feeless transactions
801     function setFeelessSender(address _sender, bool _feeless) public onlyOwner {
802         require(
803             !_feeless || (_feeless && canWhitelist),
804             "cannot add to whitelist"
805         );
806         feelessSender[_sender] = _feeless;
807     }
808 
809     // enable/disable recipient who can reccieve feeless transactions
810     function setFeelessReciever(address _recipient, bool _feeless)
811         public
812         onlyOwner
813     {
814         require(
815             !_feeless || (_feeless && canWhitelist),
816             "cannot add to whitelist"
817         );
818         feelessReciever[_recipient] = _feeless;
819     }
820 
821     // disable adding to whitelist forever
822     function renounceWhitelist() public onlyOwner {
823         // adding to whitelist has been disabled forever:
824         canWhitelist = false;
825     }
826 
827     // to caclulate the amounts for recipient and distributer after fees have been applied
828     function calculateAmountsAfterFee(
829         address sender,
830         address recipient,
831         uint256 amount
832     )
833         public
834         view
835         returns (
836             uint256 transferToAmount,
837             uint256 transferToFeeDistributorAmount
838         )
839     {
840         // check if fees should apply to this transaction
841         if (
842             _minTotalSupply >= _totalSupply ||
843             feelessSender[sender] ||
844             feelessReciever[recipient]
845         ) {
846             return (amount, 0);
847         }
848 
849         // calculate fees and amounts
850         uint256 fee = amount.mul(txFee).div(1000);
851         return (amount.sub(fee), fee);
852     }
853 
854     /**
855      * @dev Moves tokens `amount` from `sender` to `recipient`.
856      *
857      * This is internal function is equivalent to {transfer}, and can be used to
858      * e.g. implement automatic token fees, slashing mechanisms, etc.
859      *
860      * Emits a {Transfer} event.
861      *
862      * Requirements:
863      *
864      * - `sender` cannot be the zero address.
865      * - `recipient` cannot be the zero address.
866      * - `sender` must have a balance of at least `amount`.
867      */
868     function _transfer(
869         address sender,
870         address recipient,
871         uint256 amount
872     ) internal virtual {
873         require(sender != address(0), "ERC20: transfer from the zero address");
874         require(recipient != address(0), "ERC20: transfer to the zero address");
875         require(amount > 1000, "amount to small, maths will break");
876         _beforeTokenTransfer(sender, recipient, amount);
877 
878         // subtract send balanced
879         _balances[sender] = _balances[sender].sub(
880             amount,
881             "ERC20: transfer amount exceeds balance"
882         );
883 
884         // calculate fee:
885         (
886             uint256 transferToAmount,
887             uint256 transferToFeeDistributorAmount
888         ) = calculateAmountsAfterFee(sender, recipient, amount);
889 
890         // update recipients balance:
891         _balances[recipient] = _balances[recipient].add(transferToAmount);
892         emit Transfer(sender, recipient, transferToAmount);
893 
894         // update distributers balance:
895         // burn 20% txfee in each transfer
896         if (
897             transferToFeeDistributorAmount > 0 && feeDistributor != address(0)
898         ) {
899             uint256 burnAmount = transferToFeeDistributorAmount.div(10);
900             _balances[feeDistributor] = _balances[feeDistributor].add(
901                 transferToFeeDistributorAmount.sub(burnAmount)
902             );
903             emit Transfer(
904                 sender,
905                 feeDistributor,
906                 transferToFeeDistributorAmount
907             );
908             _totalSupply = _totalSupply.sub(burnAmount);
909             emit Transfer(sender, address(0), burnAmount);
910         }
911     }
912 
913     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
914      * the total supply.
915      *
916      * Emits a {Transfer} event with `from` set to the zero address.
917      *
918      * Requirements
919      *
920      * - `to` cannot be the zero address.
921      */
922     function _mint(address account, uint256 amount) internal virtual {
923         require(account != address(0), "ERC20: mint to the zero address");
924 
925         _beforeTokenTransfer(address(0), account, amount);
926 
927         _totalSupply = _totalSupply.add(amount);
928         _balances[account] = _balances[account].add(amount);
929         emit Transfer(address(0), account, amount);
930     }
931 
932     /**
933      * @dev Destroys `amount` tokens from `account`, reducing the
934      * total supply.
935      *
936      * Emits a {Transfer} event with `to` set to the zero address.
937      *
938      * Requirements
939      *
940      * - `account` cannot be the zero address.
941      * - `account` must have at least `amount` tokens.
942      */
943     function _burn(address account, uint256 amount) internal virtual {
944         require(account != address(0), "ERC20: burn from the zero address");
945 
946         _beforeTokenTransfer(account, address(0), amount);
947 
948         _balances[account] = _balances[account].sub(
949             amount,
950             "ERC20: burn amount exceeds balance"
951         );
952         _totalSupply = _totalSupply.sub(amount);
953         emit Transfer(account, address(0), amount);
954     }
955 
956     /**
957      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
958      *
959      * This internal function is equivalent to `approve`, and can be used to
960      * e.g. set automatic allowances for certain subsystems, etc.
961      *
962      * Emits an {Approval} event.
963      *
964      * Requirements:
965      *
966      * - `owner` cannot be the zero address.
967      * - `spender` cannot be the zero address.
968      */
969     function _approve(
970         address owner,
971         address spender,
972         uint256 amount
973     ) internal virtual {
974         require(owner != address(0), "ERC20: approve from the zero address");
975         require(spender != address(0), "ERC20: approve to the zero address");
976 
977         _allowances[owner][spender] = amount;
978         emit Approval(owner, spender, amount);
979     }
980 
981     /**
982      * @dev Sets {decimals} to a value other than the default one of 18.
983      *
984      * WARNING: This function should only be called from the constructor. Most
985      * applications that interact with token contracts will not expect
986      * {decimals} to ever change, and may work incorrectly if it does.
987      */
988     function _setupDecimals(uint8 decimals_) internal {
989         _decimals = decimals_;
990     }
991 
992     /**
993      * @dev Hook that is called before any transfer of tokens. This includes
994      * minting and burning.
995      *
996      * Calling conditions:
997      *
998      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
999      * will be to transferred to `to`.
1000      * - when `from` is zero, `amount` tokens will be minted for `to`.
1001      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1002      * - `from` and `to` are never both zero.
1003      *
1004      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1005      */
1006     function _beforeTokenTransfer(
1007         address from,
1008         address to,
1009         uint256 amount
1010     ) internal virtual {}
1011 }
1012 
1013 /**
1014  * Waves are caused by energy passing through the water, causing the water to move in a circular motion.
1015  */
1016 contract Wav3Token is DeflationaryERC20 {
1017     constructor() public DeflationaryERC20("Wav3Token", "WAV3") {    
1018         _mint(msg.sender, 100000e18);
1019     }
1020 
1021     function burn(uint256 amount) public {
1022         _burn(msg.sender, amount);
1023     }
1024 }