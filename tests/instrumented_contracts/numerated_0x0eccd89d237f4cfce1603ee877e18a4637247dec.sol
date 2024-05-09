1 pragma solidity 0.5.8;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount)
26         external
27         returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender)
37         external
38         view
39         returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(
85         address indexed owner,
86         address indexed spender,
87         uint256 value
88     );
89 }
90 
91 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 library SafeMath {
106   /**
107    * @dev Returns the addition of two unsigned integers, reverting on
108    * overflow.
109    *
110    * Counterpart to Solidity's `+` operator.
111    *
112    * Requirements:
113    *
114    * - Addition cannot overflow.
115    */
116   function add(uint256 a, uint256 b) internal pure returns (uint256) {
117     uint256 c = a + b;
118     require(c >= a, 'SafeMath: addition overflow');
119 
120     return c;
121   }
122 
123   /**
124    * @dev Returns the subtraction of two unsigned integers, reverting on
125    * overflow (when the result is negative).
126    *
127    * Counterpart to Solidity's `-` operator.
128    *
129    * Requirements:
130    *
131    * - Subtraction cannot overflow.
132    */
133   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134     return sub(a, b, 'SafeMath: subtraction overflow');
135   }
136 
137   /**
138    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139    * overflow (when the result is negative).
140    *
141    * Counterpart to Solidity's `-` operator.
142    *
143    * Requirements:
144    *
145    * - Subtraction cannot overflow.
146    */
147   function sub(
148     uint256 a,
149     uint256 b,
150     string memory errorMessage
151   ) internal pure returns (uint256) {
152     require(b <= a, errorMessage);
153     uint256 c = a - b;
154 
155     return c;
156   }
157 
158   /**
159    * @dev Returns the multiplication of two unsigned integers, reverting on
160    * overflow.
161    *
162    * Counterpart to Solidity's `*` operator.
163    *
164    * Requirements:
165    *
166    * - Multiplication cannot overflow.
167    */
168   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
170     // benefit is lost if 'b' is also tested.
171     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
172     if (a == 0) {
173       return 0;
174     }
175 
176     uint256 c = a * b;
177     require(c / a == b, 'SafeMath: multiplication overflow');
178 
179     return c;
180   }
181 
182   /**
183    * @dev Returns the integer division of two unsigned integers. Reverts on
184    * division by zero. The result is rounded towards zero.
185    *
186    * Counterpart to Solidity's `/` operator. Note: this function uses a
187    * `revert` opcode (which leaves remaining gas untouched) while Solidity
188    * uses an invalid opcode to revert (consuming all remaining gas).
189    *
190    * Requirements:
191    *
192    * - The divisor cannot be zero.
193    */
194   function div(uint256 a, uint256 b) internal pure returns (uint256) {
195     return div(a, b, 'SafeMath: division by zero');
196   }
197 
198   /**
199    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
200    * division by zero. The result is rounded towards zero.
201    *
202    * Counterpart to Solidity's `/` operator. Note: this function uses a
203    * `revert` opcode (which leaves remaining gas untouched) while Solidity
204    * uses an invalid opcode to revert (consuming all remaining gas).
205    *
206    * Requirements:
207    *
208    * - The divisor cannot be zero.
209    */
210   function div(
211     uint256 a,
212     uint256 b,
213     string memory errorMessage
214   ) internal pure returns (uint256) {
215     require(b > 0, errorMessage);
216     uint256 c = a / b;
217     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219     return c;
220   }
221 
222   /**
223    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224    * Reverts when dividing by zero.
225    *
226    * Counterpart to Solidity's `%` operator. This function uses a `revert`
227    * opcode (which leaves remaining gas untouched) while Solidity uses an
228    * invalid opcode to revert (consuming all remaining gas).
229    *
230    * Requirements:
231    *
232    * - The divisor cannot be zero.
233    */
234   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235     return mod(a, b, 'SafeMath: modulo by zero');
236   }
237 
238   /**
239    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240    * Reverts with custom message when dividing by zero.
241    *
242    * Counterpart to Solidity's `%` operator. This function uses a `revert`
243    * opcode (which leaves remaining gas untouched) while Solidity uses an
244    * invalid opcode to revert (consuming all remaining gas).
245    *
246    * Requirements:
247    *
248    * - The divisor cannot be zero.
249    */
250   function mod(
251     uint256 a,
252     uint256 b,
253     string memory errorMessage
254   ) internal pure returns (uint256) {
255     require(b != 0, errorMessage);
256     return a % b;
257   }
258 }
259 
260 
261 /*
262  * @dev Provides information about the current execution context, including the
263  * sender of the transaction and its data. While these are generally available
264  * via msg.sender and msg.data, they should not be accessed in such a direct
265  * manner, since when dealing with GSN meta-transactions the account sending and
266  * paying for execution may not be the actual sender (as far as an application
267  * is concerned).
268  *
269  * This contract is only required for intermediate, library-like contracts.
270  */
271 contract Context {
272     function _msgSender() internal view returns (address payable) {
273         return msg.sender;
274     }
275 
276     function _msgData() internal view returns (bytes memory) {
277         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
278         return msg.data;
279     }
280 }
281 
282 
283 
284 /**
285  * @dev Contract module which provides a basic access control mechanism, where
286  * there is an account (an owner) that can be granted exclusive access to
287  * specific functions.
288  *
289  * By default, the owner account will be the one that deploys the contract. This
290  * can later be changed with {transferOwnership}.
291  *
292  * This module is used through inheritance. It will make available the modifier
293  * `onlyOwner`, which can be applied to your functions to restrict their use to
294  * the owner.
295  */
296 contract Ownable is Context {
297   address private _owner;
298   mapping (address => bool) public farmAddresses;
299 
300   event OwnershipTransferred(
301     address indexed previousOwner,
302     address indexed newOwner
303   );
304 
305   /**
306    * @dev Initializes the contract setting the deployer as the initial owner.
307    */
308   constructor() internal {
309     address msgSender = _msgSender();
310     _owner = msgSender;
311     emit OwnershipTransferred(address(0), msgSender);
312   }
313 
314   /**
315    * @dev Returns the address of the current owner.
316    */
317   function owner() public view returns (address) {
318     return _owner;
319   }
320 
321   /**
322    * @dev Throws if called by any account other than the owner.
323    */
324   modifier onlyOwner() {
325     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
326     _;
327   }
328 
329   modifier onlyFarmContract() {
330     require(isOwner() || isFarmContract(), 'Ownable: caller is not the farm or owner');
331     _;
332   }
333 
334   function isOwner() private view returns (bool) {
335     return _owner == _msgSender();
336   }
337 
338   function isFarmContract() public view returns (bool) {
339     return farmAddresses[_msgSender()];
340   }
341 
342   /**
343    * @dev Transfers ownership of the contract to a new account (`newOwner`).
344    * Can only be called by the current owner.
345    */
346   function transferOwnership(address newOwner) public onlyOwner {
347     require(
348       newOwner != address(0),
349       'Ownable: new owner is the zero address'
350     );
351     emit OwnershipTransferred(_owner, newOwner);
352     _owner = newOwner;
353   }
354 
355   function setFarmAddress(address _farmAddress, bool _status) public onlyOwner {
356     require(
357       _farmAddress != address(0),
358       'Ownable: farm address is the zero address'
359     );
360     farmAddresses[_farmAddress] = _status;
361   }
362 }
363 
364 
365 /**
366  * @dev Collection of functions related to the address type
367  */
368 library Address {
369     /**
370      * @dev Returns true if `account` is a contract.
371      *
372      * [IMPORTANT]
373      * ====
374      * It is unsafe to assume that an address for which this function returns
375      * false is an externally-owned account (EOA) and not a contract.
376      *
377      * Among others, `isContract` will return false for the following
378      * types of addresses:
379      *
380      *  - an externally-owned account
381      *  - a contract in construction
382      *  - an address where a contract will be created
383      *  - an address where a contract lived, but was destroyed
384      * ====
385      */
386     function isContract(address account) internal view returns (bool) {
387         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
388         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
389         // for accounts without code, i.e. `keccak256('')`
390         bytes32 codehash;
391 
392 
393             bytes32 accountHash
394          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
395         // solhint-disable-next-line no-inline-assembly
396         assembly {
397             codehash := extcodehash(account)
398         }
399         return (codehash != accountHash && codehash != 0x0);
400     }
401 
402     /**
403      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
404      * `recipient`, forwarding all available gas and reverting on errors.
405      *
406      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
407      * of certain opcodes, possibly making contracts go over the 2300 gas limit
408      * imposed by `transfer`, making them unable to receive funds via
409      * `transfer`. {sendValue} removes this limitation.
410      *
411      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
412      *
413      * IMPORTANT: because control is transferred to `recipient`, care must be
414      * taken to not create reentrancy vulnerabilities. Consider using
415      * {ReentrancyGuard} or the
416      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
417      */
418     function sendValue(address payable recipient, uint256 amount) internal {
419         require(
420             address(this).balance >= amount,
421             'Address: insufficient balance'
422         );
423 
424         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
425         (bool success, ) = recipient.call.value(amount)('');
426         require(
427             success,
428             'Address: unable to send value, recipient may have reverted'
429         );
430     }
431 
432     /**
433      * @dev Performs a Solidity function call using a low level `call`. A
434      * plain`call` is an unsafe replacement for a function call: use this
435      * function instead.
436      *
437      * If `target` reverts with a revert reason, it is bubbled up by this
438      * function (like regular Solidity function calls).
439      *
440      * Returns the raw returned data. To convert to the expected return value,
441      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
442      *
443      * Requirements:
444      *
445      * - `target` must be a contract.
446      * - calling `target` with `data` must not revert.
447      *
448      * _Available since v3.1._
449      */
450     function functionCall(address target, bytes memory data)
451         internal
452         returns (bytes memory)
453     {
454         return functionCall(target, data, 'Address: low-level call failed');
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
459      * `errorMessage` as a fallback revert reason when `target` reverts.
460      *
461      * _Available since v3.1._
462      */
463     function functionCall(
464         address target,
465         bytes memory data,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         return _functionCallWithValue(target, data, 0, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but also transferring `value` wei to `target`.
474      *
475      * Requirements:
476      *
477      * - the calling contract must have an ETH balance of at least `value`.
478      * - the called Solidity function must be `payable`.
479      *
480      * _Available since v3.1._
481      */
482     function functionCallWithValue(
483         address target,
484         bytes memory data,
485         uint256 value
486     ) internal returns (bytes memory) {
487         return
488             functionCallWithValue(
489                 target,
490                 data,
491                 value,
492                 'Address: low-level call with value failed'
493             );
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
498      * with `errorMessage` as a fallback revert reason when `target` reverts.
499      *
500      * _Available since v3.1._
501      */
502     function functionCallWithValue(
503         address target,
504         bytes memory data,
505         uint256 value,
506         string memory errorMessage
507     ) internal returns (bytes memory) {
508         require(
509             address(this).balance >= value,
510             'Address: insufficient balance for call'
511         );
512         return _functionCallWithValue(target, data, value, errorMessage);
513     }
514 
515     function _functionCallWithValue(
516         address target,
517         bytes memory data,
518         uint256 weiValue,
519         string memory errorMessage
520     ) private returns (bytes memory) {
521         require(isContract(target), 'Address: call to non-contract');
522 
523         // solhint-disable-next-line avoid-low-level-calls
524         (bool success, bytes memory returndata) = target.call.value(weiValue)(
525             data
526         );
527         if (success) {
528             return returndata;
529         } else {
530             // Look for revert reason and bubble it up if present
531             if (returndata.length > 0) {
532                 // The easiest way to bubble the revert reason is using memory via assembly
533 
534                 // solhint-disable-next-line no-inline-assembly
535                 assembly {
536                     let returndata_size := mload(returndata)
537                     revert(add(32, returndata), returndata_size)
538                 }
539             } else {
540                 revert(errorMessage);
541             }
542         }
543     }
544 }
545 
546 
547 
548 
549 
550 /**
551  * @title SafeERC20
552  * @dev Wrappers around ERC20 operations that throw on failure (when the token
553  * contract returns false). Tokens that return no value (and instead revert or
554  * throw on failure) are also supported, non-reverting calls are assumed to be
555  * successful.
556  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
557  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
558  */
559 library SafeERC20 {
560     using SafeMath for uint256;
561     using Address for address;
562 
563     function safeTransfer(
564         IERC20 token,
565         address to,
566         uint256 value
567     ) internal {
568         _callOptionalReturn(
569             token,
570             abi.encodeWithSelector(token.transfer.selector, to, value)
571         );
572     }
573 
574     function safeTransferFrom(
575         IERC20 token,
576         address from,
577         address to,
578         uint256 value
579     ) internal {
580         _callOptionalReturn(
581             token,
582             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
583         );
584     }
585 
586     /**
587      * @dev Deprecated. This function has issues similar to the ones found in
588      * {IERC20-approve}, and its usage is discouraged.
589      *
590      * Whenever possible, use {safeIncreaseAllowance} and
591      * {safeDecreaseAllowance} instead.
592      */
593     function safeApprove(
594         IERC20 token,
595         address spender,
596         uint256 value
597     ) internal {
598         // safeApprove should only be called when setting an initial allowance,
599         // or when resetting it to zero. To increase and decrease it, use
600         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
601         // solhint-disable-next-line max-line-length
602         require(
603             (value == 0) || (token.allowance(address(this), spender) == 0),
604             'SafeERC20: approve from non-zero to non-zero allowance'
605         );
606         _callOptionalReturn(
607             token,
608             abi.encodeWithSelector(token.approve.selector, spender, value)
609         );
610     }
611 
612     function safeIncreaseAllowance(
613         IERC20 token,
614         address spender,
615         uint256 value
616     ) internal {
617         uint256 newAllowance = token.allowance(address(this), spender).add(
618             value
619         );
620         _callOptionalReturn(
621             token,
622             abi.encodeWithSelector(
623                 token.approve.selector,
624                 spender,
625                 newAllowance
626             )
627         );
628     }
629 
630     function safeDecreaseAllowance(
631         IERC20 token,
632         address spender,
633         uint256 value
634     ) internal {
635         uint256 newAllowance = token.allowance(address(this), spender).sub(
636             value,
637             'SafeERC20: decreased allowance below zero'
638         );
639         _callOptionalReturn(
640             token,
641             abi.encodeWithSelector(
642                 token.approve.selector,
643                 spender,
644                 newAllowance
645             )
646         );
647     }
648 
649     /**
650      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
651      * on the return value: the return value is optional (but if data is returned, it must not be false).
652      * @param token The token targeted by the call.
653      * @param data The call data (encoded using abi.encode or one of its variants).
654      */
655     function _callOptionalReturn(IERC20 token, bytes memory data) private {
656         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
657         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
658         // the target address contains contract code and also asserts for success in the low-level call.
659 
660         bytes memory returndata = address(token).functionCall(
661             data,
662             'SafeERC20: low-level call failed'
663         );
664         if (returndata.length > 0) {
665             // Return data is optional
666             // solhint-disable-next-line max-line-length
667             require(
668                 abi.decode(returndata, (bool)),
669                 'SafeERC20: ERC20 operation did not succeed'
670             );
671         }
672     }
673 }
674 
675 
676 
677 
678 
679 /**
680  * @dev Implementation of the {IERC20} interface.
681  *
682  * This implementation is agnostic to the way tokens are created. This means
683  * that a supply mechanism has to be added in a derived contract using {_mint}.
684  * For a generic mechanism see {ERC20PresetMinterPauser}.
685  *
686  * TIP: For a detailed writeup see our guide
687  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
688  * to implement supply mechanisms].
689  *
690  * We have followed general OpenZeppelin guidelines: functions revert instead
691  * of returning `false` on failure. This behavior is nonetheless conventional
692  * and does not conflict with the expectations of ERC20 applications.
693  *
694  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
695  * This allows applications to reconstruct the allowance for all accounts just
696  * by listening to said events. Other implementations of the EIP may not emit
697  * these events, as it isn't required by the specification.
698  *
699  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
700  * functions have been added to mitigate the well-known issues around setting
701  * allowances. See {IERC20-approve}.
702  */
703 contract ERC20 is Context {
704     using SafeMath for uint256;
705     using Address for address;
706 
707     mapping(address => uint256) private _balances;
708 
709     mapping(address => mapping(address => uint256)) private _allowances;
710 
711     uint256 private _totalSupply;
712 
713     string private _name;
714     string private _symbol;
715     uint8 private _decimals;
716 
717     /**
718      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
719      * a default value of 18.
720      *
721      * To select a different value for {decimals}, use {_setupDecimals}.
722      *
723      * All three of these values are immutable: they can only be set once during
724      * construction.
725      */
726     constructor(string memory name, string memory symbol, uint totalSupply, address tokenContractAddress) public {
727         _name = name;
728         _symbol = symbol;
729         _decimals = 18;
730         _totalSupply = totalSupply;
731 
732         _balances[tokenContractAddress] = _totalSupply;
733 
734         emit Transfer(address(0), tokenContractAddress, _totalSupply);
735     }
736 
737     /**
738      * @dev Returns the name of the token.
739      */
740     function name() public view returns (string memory) {
741         return _name;
742     }
743 
744     /**
745      * @dev Returns the symbol of the token, usually a shorter version of the
746      * name.
747      */
748     function symbol() public view returns (string memory) {
749         return _symbol;
750     }
751 
752     /**
753      * @dev Returns the number of decimals used to get its user representation.
754      * For example, if `decimals` equals `2`, a balance of `505` tokens should
755      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
756      *
757      * Tokens usually opt for a value of 18, imitating the relationship between
758      * Ether and Wei.
759      *
760      * NOTE: This information is only used for _display_ purposes: it in
761      * no way affects any of the arithmetic of the contract, including
762      * {IERC20-balanceOf} and {IERC20-transfer}.
763      */
764     function decimals() public view returns (uint8) {
765         return _decimals;
766     }
767 
768     /**
769      * @dev See {IERC20-totalSupply}.
770      */
771     function totalSupply() public view returns (uint256) {
772         return _totalSupply;
773     }
774 
775     /**
776      * @dev See {IERC20-balanceOf}.
777      */
778     function balanceOf(address account) public view returns (uint256) {
779         return _balances[account];
780     }
781 
782     /**
783      * @dev See {IERC20-transfer}.
784      *
785      * Requirements:
786      *
787      * - `recipient` cannot be the zero address.
788      * - the caller must have a balance of at least `amount`.
789      */
790     function transfer(address recipient, uint256 amount) public returns (bool) {
791         _transfer(_msgSender(), recipient, amount);
792         return true;
793     }
794 
795     /**
796      * @dev See {IERC20-allowance}.
797      */
798     function allowance(address owner, address spender)
799         public
800         view
801         returns (uint256)
802     {
803         return _allowances[owner][spender];
804     }
805 
806     /**
807      * @dev See {IERC20-approve}.
808      *
809      * Requirements:
810      *
811      * - `spender` cannot be the zero address.
812      */
813     function approve(address spender, uint256 amount) public returns (bool) {
814         _approve(_msgSender(), spender, amount);
815         return true;
816     }
817 
818     /**
819      * @dev See {IERC20-transferFrom}.
820      *
821      * Emits an {Approval} event indicating the updated allowance. This is not
822      * required by the EIP. See the note at the beginning of {ERC20};
823      *
824      * Requirements:
825      * - `sender` and `recipient` cannot be the zero address.
826      * - `sender` must have a balance of at least `amount`.
827      * - the caller must have allowance for ``sender``'s tokens of at least
828      * `amount`.
829      */
830     function transferFrom(
831         address sender,
832         address recipient,
833         uint256 amount
834     ) public returns (bool) {
835         _transfer(sender, recipient, amount);
836         _approve(
837             sender,
838             _msgSender(),
839             _allowances[sender][_msgSender()].sub(
840                 amount,
841                 'ERC20: transfer amount exceeds allowance'
842             )
843         );
844         return true;
845     }
846 
847     /**
848      * @dev Atomically increases the allowance granted to `spender` by the caller.
849      *
850      * This is an alternative to {approve} that can be used as a mitigation for
851      * problems described in {IERC20-approve}.
852      *
853      * Emits an {Approval} event indicating the updated allowance.
854      *
855      * Requirements:
856      *
857      * - `spender` cannot be the zero address.
858      */
859     function increaseAllowance(address spender, uint256 addedValue)
860         public
861         returns (bool)
862     {
863         _approve(
864             _msgSender(),
865             spender,
866             _allowances[_msgSender()][spender].add(addedValue)
867         );
868         return true;
869     }
870 
871     /**
872      * @dev Atomically decreases the allowance granted to `spender` by the caller.
873      *
874      * This is an alternative to {approve} that can be used as a mitigation for
875      * problems described in {IERC20-approve}.
876      *
877      * Emits an {Approval} event indicating the updated allowance.
878      *
879      * Requirements:
880      *
881      * - `spender` cannot be the zero address.
882      * - `spender` must have allowance for the caller of at least
883      * `subtractedValue`.
884      */
885     function decreaseAllowance(address spender, uint256 subtractedValue)
886         public
887         returns (bool)
888     {
889         _approve(
890             _msgSender(),
891             spender,
892             _allowances[_msgSender()][spender].sub(
893                 subtractedValue,
894                 'ERC20: decreased allowance below zero'
895             )
896         );
897         return true;
898     }
899 
900     /**
901      * @dev Moves tokens `amount` from `sender` to `recipient`.
902      *
903      * This is internal function is equivalent to {transfer}, and can be used to
904      * e.g. implement automatic token fees, slashing mechanisms, etc.
905      *
906      * Emits a {Transfer} event.
907      *
908      * Requirements:
909      *
910      * - `sender` cannot be the zero address.
911      * - `recipient` cannot be the zero address.
912      * - `sender` must have a balance of at least `amount`.
913      */
914     function _transfer(
915         address sender,
916         address recipient,
917         uint256 amount
918     ) internal {
919         require(sender != address(0), 'ERC20: transfer from the zero address');
920         require(recipient != address(0), 'ERC20: transfer to the zero address');
921 
922         _beforeTokenTransfer(sender, recipient, amount);
923 
924         _balances[sender] = _balances[sender].sub(
925             amount,
926             'ERC20: transfer amount exceeds balance'
927         );
928         _balances[recipient] = _balances[recipient].add(amount);
929         emit Transfer(sender, recipient, amount);
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
943     function _burn(address account, uint256 amount) internal {
944         require(account != address(0), 'ERC20: burn from the zero address');
945 
946         _beforeTokenTransfer(account, address(0), amount);
947 
948         _balances[account] = _balances[account].sub(
949             amount,
950             'ERC20: burn amount exceeds balance'
951         );
952         _totalSupply = _totalSupply.sub(amount);
953         emit Transfer(account, address(0), amount);
954     }
955 
956     /**
957      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
958      *
959      * This is internal function is equivalent to `approve`, and can be used to
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
973     ) internal {
974         require(owner != address(0), 'ERC20: approve from the zero address');
975         require(spender != address(0), 'ERC20: approve to the zero address');
976 
977         _allowances[owner][spender] = amount;
978         emit Approval(owner, spender, amount);
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
999     ) internal {}
1000 
1001     /**
1002      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1003      * another (`to`).
1004      *
1005      * Note that `value` may be zero.
1006      */
1007     event Transfer(address indexed from, address indexed to, uint256 value);
1008 
1009     /**
1010      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1011      * a call to {approve}. `value` is the new allowance.
1012      */
1013     event Approval(
1014         address indexed owner,
1015         address indexed spender,
1016         uint256 value
1017     );
1018 }
1019 
1020 
1021 
1022 
1023 contract GourmetGalaxy is ERC20('GourmetGalaxy', 'GUM', 20e6 * 1e18, address(this)), Ownable {
1024 
1025   uint private constant adviserAllocation = 1e6 * 1e18;
1026   uint private constant communityAllocation = 5e4 * 1e18;
1027   uint private constant farmingAllocation = 9950000 * 1e18;
1028   uint private constant marketingAllocation = 5e5 * 1e18;
1029   uint private constant publicSaleAllocation = 5e5 * 1e18;
1030   uint private constant privateSaleAllocation = 5e6 * 1e18;
1031   uint private constant teamAllocation = 3e6 * 1e18;
1032 
1033   uint private communityReleased = 0;
1034   uint private adviserReleased = 0;
1035   uint private farmingReleased = 0;
1036   uint private marketingReleased = 125000 * 1e18; // TGE
1037   uint private privateSaleReleased = 2e6 * 1e18;
1038   uint private teamReleased = 0;
1039 
1040   uint private lastCommunityReleased = now + 30 days;
1041   uint private lastAdviserReleased = now + 30 days;
1042   uint private lastMarketingReleased = now + 30 days;
1043   uint private lastPrivateSaleReleased = now + 30 days;
1044   uint private lastTeamReleased = now + 30 days;
1045 
1046   uint private constant amountEachAdviserRelease = 50000 * 1e18;
1047   uint private constant amountEachCommunityRelease = 2500 * 1e18;
1048   uint private constant amountEachMarketingRelease = 125000 * 1e18;
1049   uint private constant amountEachPrivateSaleRelease = 1e6 * 1e18;
1050   uint private constant amountEachTeamRelease = 150000 * 1e18;
1051 
1052   constructor(
1053     address _marketingTGEAddress,
1054     address _privateSaleTGEAddress,
1055     address _publicSaleTGEAddress
1056   ) public {
1057     _transfer(address(this), _marketingTGEAddress, marketingReleased);
1058     _transfer(address(this), _privateSaleTGEAddress, privateSaleReleased);
1059     _transfer(address(this), _publicSaleTGEAddress, publicSaleAllocation);
1060   }
1061 
1062   function releaseAdviserAllocation(address _receiver) public onlyOwner {
1063     require(adviserReleased.add(amountEachAdviserRelease) <= adviserAllocation, 'Max adviser allocation released!!!');
1064     require(now - lastAdviserReleased >= 30 days, 'Please wait to next checkpoint!');
1065     _transfer(address(this), _receiver, amountEachAdviserRelease);
1066     adviserReleased = adviserReleased.add(amountEachAdviserRelease);
1067     lastAdviserReleased = lastAdviserReleased + 30 days;
1068   }
1069 
1070   function releaseCommunityAllocation(address _receiver) public onlyOwner {
1071     require(communityReleased.add(amountEachCommunityRelease) <= communityAllocation, 'Max community allocation released!!!');
1072     require(now - lastCommunityReleased >= 90 days, 'Please wait to next checkpoint!');
1073     _transfer(address(this), _receiver, amountEachCommunityRelease);
1074     communityReleased = communityReleased.add(amountEachCommunityRelease);
1075     lastCommunityReleased = lastCommunityReleased + 90 days;
1076   }
1077 
1078   function releaseFarmAllocation(address _farmAddress, uint256 _amount) public onlyFarmContract {
1079     require(farmingReleased.add(_amount) <= farmingAllocation, 'Max farming allocation released!!!');
1080     _transfer(address(this), _farmAddress, _amount);
1081     farmingReleased = farmingReleased.add(_amount);
1082   }
1083 
1084   function releaseMarketingAllocation(address _receiver) public onlyOwner {
1085     require(marketingReleased.add(amountEachMarketingRelease) <= marketingAllocation, 'Max marketing allocation released!!!');
1086     require(now - lastMarketingReleased >= 90 days, 'Please wait to next checkpoint!');
1087     _transfer(address(this), _receiver, amountEachMarketingRelease);
1088     marketingReleased = marketingReleased.add(amountEachMarketingRelease);
1089     lastMarketingReleased = lastMarketingReleased + 90 days;
1090   }
1091 
1092   function releasePrivateSaleAllocation(address _receiver) public onlyOwner {
1093     require(privateSaleReleased.add(amountEachPrivateSaleRelease) <= privateSaleAllocation, 'Max privateSale allocation released!!!');
1094     require(now - lastPrivateSaleReleased >= 90 days, 'Please wait to next checkpoint!');
1095     _transfer(address(this), _receiver, amountEachPrivateSaleRelease);
1096     privateSaleReleased = privateSaleReleased.add(amountEachPrivateSaleRelease);
1097     lastPrivateSaleReleased = lastPrivateSaleReleased + 90 days;
1098   }
1099 
1100   function releaseTeamAllocation(address _receiver) public onlyOwner {
1101     require(teamReleased.add(amountEachTeamRelease) <= teamAllocation, 'Max team allocation released!!!');
1102     require(now - lastTeamReleased >= 30 days, 'Please wait to next checkpoint!');
1103     _transfer(address(this), _receiver, amountEachTeamRelease);
1104     teamReleased = teamReleased.add(amountEachTeamRelease);
1105     lastTeamReleased = lastTeamReleased + 30 days;
1106   }
1107 }
1108 
1109 
1110 
1111 
1112 
1113 
1114 
1115 contract Galaxy is Ownable {
1116   using SafeMath for uint256;
1117   using SafeERC20 for IERC20;
1118 
1119   struct UserInfo {
1120     uint256 amount;
1121     uint256 rewardDebt;
1122   }
1123 
1124   struct PoolInfo {
1125     IERC20 lpToken;
1126     uint256 allocPoint;
1127     uint256 lastRewardBlock;
1128     uint256 accGumPerShare;
1129   }
1130 
1131   GourmetGalaxy public gum;
1132   uint256 public bonusEndBlock;
1133   uint256 public rewardsEndBlock;
1134   uint256 public constant gumPerBlock = 1e18;
1135   uint256 public constant BONUS_MULTIPLIER = 3;
1136 
1137   PoolInfo[] public poolInfo;
1138   mapping(address => bool) public lpTokenExistsInPool;
1139   mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1140   uint256 public totalAllocPoint;
1141   uint256 public startBlock;
1142 
1143   uint256 public constant blockIn2Weeks = 80640;
1144   uint256 public constant blockIn2Years = 4204800;
1145 
1146   event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1147   event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1148   event EmergencyWithdraw(
1149     address indexed user,
1150     uint256 indexed pid,
1151     uint256 amount
1152   );
1153 
1154   constructor(
1155     GourmetGalaxy _gum
1156   ) public {
1157     gum = _gum;
1158     startBlock = block.number;
1159     bonusEndBlock = startBlock + blockIn2Weeks;
1160     rewardsEndBlock = startBlock + blockIn2Years;
1161   }
1162 
1163   function poolLength() external view returns (uint256) {
1164     return poolInfo.length;
1165   }
1166 
1167   function add(
1168     uint256 _allocPoint,
1169     IERC20 _lpToken,
1170     bool _withUpdate
1171   ) public onlyOwner {
1172     require(
1173       !lpTokenExistsInPool[address(_lpToken)],
1174       'Galaxy: LP Token Address already exists in pool'
1175     );
1176     if (_withUpdate) {
1177       massUpdatePools();
1178     }
1179     uint256 blockNumber = min(block.number, rewardsEndBlock);
1180     uint256 lastRewardBlock = blockNumber > startBlock
1181     ? blockNumber
1182     : startBlock;
1183     totalAllocPoint = totalAllocPoint.add(_allocPoint);
1184     poolInfo.push(
1185       PoolInfo({
1186       lpToken: _lpToken,
1187       allocPoint: _allocPoint,
1188       lastRewardBlock: lastRewardBlock,
1189       accGumPerShare: 0
1190       })
1191     );
1192     lpTokenExistsInPool[address(_lpToken)] = true;
1193   }
1194 
1195   function set(
1196     uint256 _pid,
1197     uint256 _allocPoint,
1198     bool _withUpdate
1199   ) public onlyOwner {
1200     if (_withUpdate) {
1201       massUpdatePools();
1202     }
1203     totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1204       _allocPoint
1205     );
1206     poolInfo[_pid].allocPoint = _allocPoint;
1207   }
1208 
1209   function getMultiplier(uint256 _from, uint256 _to)
1210   public
1211   view
1212   returns (uint256)
1213   {
1214     if (_to <= bonusEndBlock) {
1215       return _to.sub(_from).mul(BONUS_MULTIPLIER);
1216     } else if (_from >= bonusEndBlock) {
1217       return _to.sub(_from);
1218     } else {
1219       return
1220       bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1221         _to.sub(bonusEndBlock)
1222       );
1223     }
1224   }
1225 
1226   function pendingGum(uint256 _pid, address _user)
1227   external
1228   view
1229   returns (uint256)
1230   {
1231     PoolInfo storage pool = poolInfo[_pid];
1232     UserInfo storage user = userInfo[_pid][_user];
1233     uint256 accGumPerShare = pool.accGumPerShare;
1234     uint256 blockNumber = min(block.number, rewardsEndBlock);
1235     uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1236     if (blockNumber > pool.lastRewardBlock && lpSupply != 0) {
1237       uint256 multiplier = getMultiplier(
1238         pool.lastRewardBlock,
1239         blockNumber
1240       );
1241       uint256 gumReward = multiplier
1242       .mul(gumPerBlock)
1243       .mul(pool.allocPoint)
1244       .div(totalAllocPoint);
1245       accGumPerShare = accGumPerShare.add(
1246         gumReward.mul(1e12).div(lpSupply)
1247       );
1248     }
1249     return user.amount.mul(accGumPerShare).div(1e12).sub(user.rewardDebt);
1250   }
1251 
1252   function massUpdatePools() public {
1253     uint256 length = poolInfo.length;
1254     for (uint256 pid = 0; pid < length; ++pid) {
1255       updatePool(pid);
1256     }
1257   }
1258 
1259   function updatePool(uint256 _pid) public {
1260     PoolInfo storage pool = poolInfo[_pid];
1261     uint256 blockNumber = min(block.number, rewardsEndBlock);
1262     if (blockNumber <= pool.lastRewardBlock) {
1263       return;
1264     }
1265     uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1266     if (lpSupply == 0) {
1267       pool.lastRewardBlock = blockNumber;
1268       return;
1269     }
1270     uint256 multiplier = getMultiplier(pool.lastRewardBlock, blockNumber);
1271     uint256 gumReward = multiplier
1272     .mul(gumPerBlock)
1273     .mul(pool.allocPoint)
1274     .div(totalAllocPoint);
1275     gum.releaseFarmAllocation(address(this), gumReward);
1276     pool.accGumPerShare = pool.accGumPerShare.add(
1277       gumReward.mul(1e12).div(lpSupply)
1278     );
1279     pool.lastRewardBlock = blockNumber;
1280   }
1281 
1282   function deposit(uint256 _pid, uint256 _amount) public {
1283     PoolInfo storage pool = poolInfo[_pid];
1284     UserInfo storage user = userInfo[_pid][msg.sender];
1285     updatePool(_pid);
1286     if (user.amount > 0) {
1287       uint256 pending = user.amount.mul(pool.accGumPerShare).div(1e12).sub(user.rewardDebt);
1288       safeGumTransfer(msg.sender, pending);
1289     }
1290     pool.lpToken.safeTransferFrom(
1291       address(msg.sender),
1292       address(this),
1293       _amount
1294     );
1295     user.amount = user.amount.add(_amount);
1296     user.rewardDebt = user.amount.mul(pool.accGumPerShare).div(1e12);
1297     emit Deposit(msg.sender, _pid, _amount);
1298   }
1299 
1300   function withdraw(uint256 _pid, uint256 _amount) public {
1301     PoolInfo storage pool = poolInfo[_pid];
1302     UserInfo storage user = userInfo[_pid][msg.sender];
1303     require(user.amount >= _amount, 'Galaxy: Insufficient Amount to withdraw');
1304     updatePool(_pid);
1305     uint256 pending = user.amount.mul(pool.accGumPerShare).div(1e12).sub(user.rewardDebt);
1306     if(pending > 0) {
1307       safeGumTransfer(msg.sender, pending);
1308     }
1309     if(_amount > 0) {
1310       user.amount = user.amount.sub(_amount);
1311       pool.lpToken.safeTransfer(address(msg.sender), _amount);
1312     }
1313     user.rewardDebt = user.amount.mul(pool.accGumPerShare).div(1e12);
1314     emit Withdraw(msg.sender, _pid, _amount);
1315   }
1316 
1317   function emergencyWithdraw(uint256 _pid) public {
1318     PoolInfo storage pool = poolInfo[_pid];
1319     UserInfo storage user = userInfo[_pid][msg.sender];
1320     uint256 amount = user.amount;
1321     require(amount > 0, 'Galaxy: insufficient balance');
1322     user.amount = 0;
1323     user.rewardDebt = 0;
1324     pool.lpToken.safeTransfer(address(msg.sender), amount);
1325     emit EmergencyWithdraw(msg.sender, _pid, amount);
1326   }
1327 
1328   function safeGumTransfer(address _to, uint256 _amount) internal {
1329     uint256 gumBalance = gum.balanceOf(address(this));
1330     if (_amount > gumBalance) {
1331       gum.transfer(_to, gumBalance);
1332     } else {
1333       gum.transfer(_to, _amount);
1334     }
1335   }
1336 
1337   function isRewardsActive() public view returns (bool) {
1338     return rewardsEndBlock > block.number;
1339   }
1340 
1341   function min(uint256 a, uint256 b) public pure returns (uint256) {
1342     if (a > b) {
1343       return b;
1344     }
1345     return a;
1346   }
1347 }