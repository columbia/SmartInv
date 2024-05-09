1 // SPDX-License-Identifier: agpl-3.0
2 pragma solidity 0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  * From https://github.com/OpenZeppelin/openzeppelin-contracts
10  */
11 interface IERC20 {
12   /**
13    * @dev Returns the amount of tokens in existence.
14    */
15   function totalSupply() external view returns (uint256);
16 
17   /**
18    * @dev Returns the amount of tokens owned by `account`.
19    */
20   function balanceOf(address account) external view returns (uint256);
21 
22   /**
23    * 
24    * @dev Moves `amount` tokens from the caller's account to `recipient`.
25    *
26    * Returns a boolean value indicating whether the operation succeeded.
27    *
28    * Emits a {Transfer} event.
29    */
30   function transfer(address recipient, uint256 amount) external returns (bool);
31 
32   /**
33    * @dev Returns the remaining number of tokens that `spender` will be
34    * allowed to spend on behalf of `owner` through {transferFrom}. This is
35    * zero by default.
36    *
37    * This value changes when {approve} or {transferFrom} are called.
38    */
39   function allowance(address owner, address spender) external view returns (uint256);
40 
41   /**
42    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43    *
44    * Returns a boolean value indicating whether the operation succeeded.
45    *
46    * IMPORTANT: Beware that changing an allowance with this method brings the risk
47    * that someone may use both the old and the new allowance by unfortunate
48    * transaction ordering. One possible solution to mitigate this race
49    * condition is to first reduce the spender's allowance to 0 and set the
50    * desired value afterwards:
51    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52    *
53    * Emits an {Approval} event.
54    */
55   function approve(address spender, uint256 amount) external returns (bool);
56 
57   /**
58    * @dev Moves `amount` tokens from `sender` to `recipient` using the
59    * allowance mechanism. `amount` is then deducted from the caller's
60    * allowance.
61    *
62    * Returns a boolean value indicating whether the operation succeeded.
63    *
64    * Emits a {Transfer} event.
65    */
66   function transferFrom(
67     address sender,
68     address recipient,
69     uint256 amount
70   ) external returns (bool);
71 
72   /**
73    * @dev Emitted when `value` tokens are moved from one account (`from`) to
74    * another (`to`).
75    *
76    * Note that `value` may be zero.
77    */
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 
80   /**
81    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82    * a call to {approve}. `value` is the new allowance.
83    */
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File: contracts/interfaces/IStakedRoya.sol
88 
89 
90 pragma solidity 0.6.12;
91 
92 interface IStakedRoya {
93   function stake(address to, uint256 amount) external;
94 
95   function redeem(address to, uint256 amount) external;
96 
97   function cooldown() external;
98 
99   function claimRewards(address to, uint256 amount) external;
100 }
101 
102 // File: contracts/interfaces/ITransferHook.sol
103 
104 
105 pragma solidity 0.6.12;
106 
107 interface ITransferHook {
108     function onTransfer(address from, address to, uint256 amount) external;
109 }
110 
111 // File: contracts/lib/Context.sol
112 
113 
114 
115 pragma solidity 0.6.12;
116 
117 /**
118  * @dev From https://github.com/OpenZeppelin/openzeppelin-contracts
119  * Provides information about the current execution context, including the
120  * sender of the transaction and its data. While these are generally available
121  * via msg.sender and msg.data, they should not be accessed in such a direct
122  * manner, since when dealing with GSN meta-transactions the account sending and
123  * paying for execution may not be the actual sender (as far as an application
124  * is concerned).
125  *
126  * This contract is only required for intermediate, library-like contracts.
127  */
128 abstract contract Context {
129     function _msgSender() internal virtual view returns (address payable) {
130         return msg.sender;
131     }
132 
133     function _msgData() internal virtual view returns (bytes memory) {
134         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
135         return msg.data;
136     }
137 }
138 
139 // File: contracts/interfaces/IERC20Detailed.sol
140 
141 
142 pragma solidity 0.6.12;
143 
144 
145 /**
146  * @dev Interface for ERC20 including metadata
147  **/
148 interface IERC20Detailed is IERC20 {
149     function name() external view returns (string memory);
150     function symbol() external view returns (string memory);
151     function decimals() external view returns (uint8);
152 }
153 
154 // File: contracts/lib/SafeMath.sol
155 
156 
157 pragma solidity 0.6.12;
158 
159 /**
160  * @dev From https://github.com/OpenZeppelin/openzeppelin-contracts
161  * Wrappers over Solidity's arithmetic operations with added overflow
162  * checks.
163  *
164  * Arithmetic operations in Solidity wrap on overflow. This can easily result
165  * in bugs, because programmers usually assume that an overflow raises an
166  * error, which is the standard behavior in high level programming languages.
167  * `SafeMath` restores this intuition by reverting the transaction when an
168  * operation overflows.
169  *
170  * Using this library instead of the unchecked operations eliminates an entire
171  * class of bugs, so it's recommended to use it always.
172  */
173 library SafeMath {
174     /**
175      * @dev Returns the addition of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `+` operator.
179      *
180      * Requirements:
181      * - Addition cannot overflow.
182      */
183     function add(uint256 a, uint256 b) internal pure returns (uint256) {
184         uint256 c = a + b;
185         require(c >= a, 'SafeMath: addition overflow');
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the subtraction of two unsigned integers, reverting on
192      * overflow (when the result is negative).
193      *
194      * Counterpart to Solidity's `-` operator.
195      *
196      * Requirements:
197      * - Subtraction cannot overflow.
198      */
199     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200         return sub(a, b, 'SafeMath: subtraction overflow');
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
205      * overflow (when the result is negative).
206      *
207      * Counterpart to Solidity's `-` operator.
208      *
209      * Requirements:
210      * - Subtraction cannot overflow.
211      */
212     function sub(
213         uint256 a,
214         uint256 b,
215         string memory errorMessage
216     ) internal pure returns (uint256) {
217         require(b <= a, errorMessage);
218         uint256 c = a - b;
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the multiplication of two unsigned integers, reverting on
225      * overflow.
226      *
227      * Counterpart to Solidity's `*` operator.
228      *
229      * Requirements:
230      * - Multiplication cannot overflow.
231      */
232     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
233         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
234         // benefit is lost if 'b' is also tested.
235         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
236         if (a == 0) {
237             return 0;
238         }
239 
240         uint256 c = a * b;
241         require(c / a == b, 'SafeMath: multiplication overflow');
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the integer division of two unsigned integers. Reverts on
248      * division by zero. The result is rounded towards zero.
249      *
250      * Counterpart to Solidity's `/` operator. Note: this function uses a
251      * `revert` opcode (which leaves remaining gas untouched) while Solidity
252      * uses an invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      * - The divisor cannot be zero.
256      */
257     function div(uint256 a, uint256 b) internal pure returns (uint256) {
258         return div(a, b, 'SafeMath: division by zero');
259     }
260 
261     /**
262      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
263      * division by zero. The result is rounded towards zero.
264      *
265      * Counterpart to Solidity's `/` operator. Note: this function uses a
266      * `revert` opcode (which leaves remaining gas untouched) while Solidity
267      * uses an invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      * - The divisor cannot be zero.
271      */
272     function div(
273         uint256 a,
274         uint256 b,
275         string memory errorMessage
276     ) internal pure returns (uint256) {
277         // Solidity only automatically asserts when dividing by 0
278         require(b > 0, errorMessage);
279         uint256 c = a / b;
280         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * Reverts when dividing by zero.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      * - The divisor cannot be zero.
295      */
296     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
297         return mod(a, b, 'SafeMath: modulo by zero');
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * Reverts with custom message when dividing by zero.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      * - The divisor cannot be zero.
310      */
311     function mod(
312         uint256 a,
313         uint256 b,
314         string memory errorMessage
315     ) internal pure returns (uint256) {
316         require(b != 0, errorMessage);
317         return a % b;
318     }
319 }
320 
321 // File: contracts/lib/ERC20.sol
322 
323 
324 pragma solidity 0.6.12;
325 
326 
327 
328 
329 
330 /**
331  * @title ERC20
332  * @notice Basic ERC20 implementation
333  * @author Roya
334  **/
335 contract ERC20 is Context, IERC20, IERC20Detailed {
336   using SafeMath for uint256;
337 
338   mapping(address => uint256) private _balances;
339   mapping(address => mapping(address => uint256)) private _allowances;
340   uint256 private _totalSupply;
341   string private _name;
342   string private _symbol;
343   uint8 private _decimals;
344 
345   constructor(
346     string memory name,
347     string memory symbol,
348     uint8 decimals
349   ) public {
350     _name = name;
351     _symbol = symbol;
352     _decimals = decimals;
353   }
354 
355   /**
356    * @return the name of the token
357    **/
358   function name() public override view returns (string memory) {
359     return _name;
360   }
361 
362   /**
363    * @return the symbol of the token
364    **/
365   function symbol() public override view returns (string memory) {
366     return _symbol;
367   }
368 
369   /**
370    * @return the decimals of the token
371    **/
372   function decimals() public override view returns (uint8) {
373     return _decimals;
374   }
375 
376   /**
377    * @return the total supply of the token
378    **/
379   function totalSupply() public override view returns (uint256) {
380     return _totalSupply;
381   }
382 
383   /**
384    * @return the balance of the token
385    **/
386   function balanceOf(address account) public override view returns (uint256) {
387     return _balances[account];
388   }
389 
390   /**
391    * @dev executes a transfer of tokens from msg.sender to recipient
392    * @param recipient the recipient of the tokens
393    * @param amount the amount of tokens being transferred
394    * @return true if the transfer succeeds, false otherwise
395    **/
396   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
397     _transfer(_msgSender(), recipient, amount);
398     return true;
399   }
400 
401   /**
402    * @dev returns the allowance of spender on the tokens owned by owner
403    * @param owner the owner of the tokens
404    * @param spender the user allowed to spend the owner's tokens
405    * @return the amount of owner's tokens spender is allowed to spend
406    **/
407   function allowance(address owner, address spender)
408     public
409     virtual
410     override
411     view
412     returns (uint256)
413   {
414     return _allowances[owner][spender];
415   }
416 
417   /**
418    * @dev allows spender to spend the tokens owned by msg.sender
419    * @param spender the user allowed to spend msg.sender tokens
420    * @return true
421    **/
422   function approve(address spender, uint256 amount) public virtual override returns (bool) {
423     _approve(_msgSender(), spender, amount);
424     return true;
425   }
426 
427   /**
428    * @dev executes a transfer of token from sender to recipient, if msg.sender is allowed to do so
429    * @param sender the owner of the tokens
430    * @param recipient the recipient of the tokens
431    * @param amount the amount of tokens being transferred
432    * @return true if the transfer succeeds, false otherwise
433    **/
434   function transferFrom(
435     address sender,
436     address recipient,
437     uint256 amount
438   ) public virtual override returns (bool) {
439     _transfer(sender, recipient, amount);
440     _approve(
441       sender,
442       _msgSender(),
443       _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
444     );
445     return true;
446   }
447 
448   /**
449    * @dev increases the allowance of spender to spend msg.sender tokens
450    * @param spender the user allowed to spend on behalf of msg.sender
451    * @param addedValue the amount being added to the allowance
452    * @return true
453    **/
454   function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
455     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
456     return true;
457   }
458 
459   /**
460    * @dev decreases the allowance of spender to spend msg.sender tokens
461    * @param spender the user allowed to spend on behalf of msg.sender
462    * @param subtractedValue the amount being subtracted to the allowance
463    * @return true
464    **/
465   function decreaseAllowance(address spender, uint256 subtractedValue)
466     public
467     virtual
468     returns (bool)
469   {
470     _approve(
471       _msgSender(),
472       spender,
473       _allowances[_msgSender()][spender].sub(
474         subtractedValue,
475         'ERC20: decreased allowance below zero'
476       )
477     );
478     return true;
479   }
480 
481   function _transfer(
482     address sender,
483     address recipient,
484     uint256 amount
485   ) internal virtual {
486     require(sender != address(0), 'ERC20: transfer from the zero address');
487     require(recipient != address(0), 'ERC20: transfer to the zero address');
488 
489     _beforeTokenTransfer(sender, recipient, amount);
490 
491     _balances[sender] = _balances[sender].sub(amount, 'ERC20: transfer amount exceeds balance');
492     _balances[recipient] = _balances[recipient].add(amount);
493     emit Transfer(sender, recipient, amount);
494   }
495 
496   function _mint(address account, uint256 amount) internal virtual {
497     require(account != address(0), 'ERC20: mint to the zero address');
498 
499     _beforeTokenTransfer(address(0), account, amount);
500 
501     _totalSupply = _totalSupply.add(amount);
502     _balances[account] = _balances[account].add(amount);
503     emit Transfer(address(0), account, amount);
504   }
505 
506   function _burn(address account, uint256 amount) internal virtual {
507     require(account != address(0), 'ERC20: burn from the zero address');
508 
509     _beforeTokenTransfer(account, address(0), amount);
510 
511     _balances[account] = _balances[account].sub(amount, 'ERC20: burn amount exceeds balance');
512     _totalSupply = _totalSupply.sub(amount);
513     emit Transfer(account, address(0), amount);
514   }
515 
516   function _approve(
517     address owner,
518     address spender,
519     uint256 amount
520   ) internal virtual {
521     require(owner != address(0), 'ERC20: approve from the zero address');
522     require(spender != address(0), 'ERC20: approve to the zero address');
523 
524     _allowances[owner][spender] = amount;
525     emit Approval(owner, spender, amount);
526   }
527 
528   function _setName(string memory newName) internal {
529     _name = newName;
530   }
531 
532   function _setSymbol(string memory newSymbol) internal {
533     _symbol = newSymbol;
534   }
535 
536   function _setDecimals(uint8 newDecimals) internal {
537     _decimals = newDecimals;
538   }
539 
540   function _beforeTokenTransfer(
541     address from,
542     address to,
543     uint256 amount
544   ) internal virtual {}
545 }
546 
547 // File: contracts/lib/ERC20WithSnapshot.sol
548 
549 
550 pragma solidity 0.6.12;
551 
552 
553 
554 /**
555  * @title ERC20WithSnapshot
556  * @notice ERC20 including snapshots of balances on transfer-related actions
557  * @author Roya
558  **/
559 contract ERC20WithSnapshot is ERC20 {
560 
561     /// @dev snapshot of a value on a specific block, used for balances
562     struct Snapshot {
563         uint128 blockNumber;
564         uint128 value;
565     }
566 
567     mapping (address => mapping (uint256 => Snapshot)) public _snapshots;
568     mapping (address => uint256) public _countsSnapshots;
569     /// @dev reference to the Roya governance contract to call (if initialized) on _beforeTokenTransfer
570     /// !!! IMPORTANT The Roya governance is considered a trustable contract, being its responsibility
571     /// to control all potential reentrancies by calling back the this contract
572     ITransferHook public _royaGovernance;
573 
574     event SnapshotDone(address owner, uint128 oldValue, uint128 newValue);
575 
576     constructor(string memory name, string memory symbol, uint8 decimals) public ERC20(name, symbol, decimals) {}
577 
578     function _setRoyaGovernance(ITransferHook royaGovernance) internal virtual {
579         _royaGovernance = royaGovernance;
580     }
581 
582     /**
583     * @dev Writes a snapshot for an owner of tokens
584     * @param owner The owner of the tokens
585     * @param oldValue The value before the operation that is gonna be executed after the snapshot
586     * @param newValue The value after the operation
587     */
588     function _writeSnapshot(address owner, uint128 oldValue, uint128 newValue) internal virtual {
589         uint128 currentBlock = uint128(block.number);
590 
591         uint256 ownerCountOfSnapshots = _countsSnapshots[owner];
592         mapping (uint256 => Snapshot) storage snapshotsOwner = _snapshots[owner];
593 
594         // Doing multiple operations in the same block
595         if (ownerCountOfSnapshots != 0 && snapshotsOwner[ownerCountOfSnapshots.sub(1)].blockNumber == currentBlock) {
596             snapshotsOwner[ownerCountOfSnapshots.sub(1)].value = newValue;
597         } else {
598             snapshotsOwner[ownerCountOfSnapshots] = Snapshot(currentBlock, newValue);
599             _countsSnapshots[owner] = ownerCountOfSnapshots.add(1);
600         }
601 
602         emit SnapshotDone(owner, oldValue, newValue);
603     }
604 
605     /**
606     * @dev Writes a snapshot before any operation involving transfer of value: _transfer, _mint and _burn
607     * - On _transfer, it writes snapshots for both "from" and "to"
608     * - On _mint, only for _to
609     * - On _burn, only for _from
610     * @param from the from address
611     * @param to the to address
612     * @param amount the amount to transfer
613     */
614     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
615         if (from == to) {
616             return;
617         }
618 
619         if (from != address(0)) {
620             uint256 fromBalance = balanceOf(from);
621             _writeSnapshot(from, uint128(fromBalance), uint128(fromBalance.sub(amount)));
622         }
623         if (to != address(0)) {
624             uint256 toBalance = balanceOf(to);
625             _writeSnapshot(to, uint128(toBalance), uint128(toBalance.add(amount)));
626         }
627 
628         // caching the roya governance address to avoid multiple state loads
629         ITransferHook royaGovernance = _royaGovernance;
630         if (royaGovernance != ITransferHook(0)) {
631             royaGovernance.onTransfer(from, to, amount);
632         }
633     }
634 }
635 
636 // File: contracts/lib/Address.sol
637 
638 
639 pragma solidity 0.6.12;
640 
641 /**
642  * @dev Collection of functions related to the address type
643  * From https://github.com/OpenZeppelin/openzeppelin-contracts
644  */
645 library Address {
646     /**
647      * @dev Returns true if `account` is a contract.
648      *
649      * [IMPORTANT]
650      * ====
651      * It is unsafe to assume that an address for which this function returns
652      * false is an externally-owned account (EOA) and not a contract.
653      *
654      * Among others, `isContract` will return false for the following
655      * types of addresses:
656      *
657      *  - an externally-owned account
658      *  - a contract in construction
659      *  - an address where a contract will be created
660      *  - an address where a contract lived, but was destroyed
661      * ====
662      */
663     function isContract(address account) internal view returns (bool) {
664         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
665         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
666         // for accounts without code, i.e. `keccak256('')`
667         bytes32 codehash;
668         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
669         // solhint-disable-next-line no-inline-assembly
670         assembly {
671             codehash := extcodehash(account)
672         }
673         return (codehash != accountHash && codehash != 0x0);
674     }
675 
676     /**
677      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
678      * `recipient`, forwarding all available gas and reverting on errors.
679      *
680      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
681      * of certain opcodes, possibly making contracts go over the 2300 gas limit
682      * imposed by `transfer`, making them unable to receive funds via
683      * `transfer`. {sendValue} removes this limitation.
684      *
685      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
686      *
687      * IMPORTANT: because control is transferred to `recipient`, care must be
688      * taken to not create reentrancy vulnerabilities. Consider using
689      * {ReentrancyGuard} or the
690      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
691      */
692     function sendValue(address payable recipient, uint256 amount) internal {
693         require(address(this).balance >= amount, 'Address: insufficient balance');
694 
695         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
696         (bool success, ) = recipient.call{value: amount}('');
697         require(success, 'Address: unable to send value, recipient may have reverted');
698     }
699 }
700 
701 // File: contracts/lib/SafeERC20.sol
702 
703 
704 
705 pragma solidity 0.6.12;
706 
707 
708 
709 
710 /**
711  * @title SafeERC20
712  * @dev From https://github.com/OpenZeppelin/openzeppelin-contracts
713  * Wrappers around ERC20 operations that throw on failure (when the token
714  * contract returns false). Tokens that return no value (and instead revert or
715  * throw on failure) are also supported, non-reverting calls are assumed to be
716  * successful.
717  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
718  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
719  */
720 library SafeERC20 {
721     using SafeMath for uint256;
722     using Address for address;
723 
724     function safeTransfer(IERC20 token, address to, uint256 value) internal {
725         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
726     }
727 
728     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
729         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
730     }
731 
732     function safeApprove(IERC20 token, address spender, uint256 value) internal {
733         require((value == 0) || (token.allowance(address(this), spender) == 0),
734             "SafeERC20: approve from non-zero to non-zero allowance"
735         );
736         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
737     }
738     
739     function callOptionalReturn(IERC20 token, bytes memory data) private {
740         require(address(token).isContract(), "SafeERC20: call to non-contract");
741 
742         // solhint-disable-next-line avoid-low-level-calls
743         (bool success, bytes memory returndata) = address(token).call(data);
744         require(success, "SafeERC20: low-level call failed");
745 
746         if (returndata.length > 0) { // Return data is optional
747             // solhint-disable-next-line max-line-length
748             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
749         }
750     }
751 }
752 
753 // File: contracts/utils/VersionedInitializable.sol
754 
755 
756 pragma solidity 0.6.12;
757 
758 /**
759  * @title VersionedInitializable
760  *
761  * @dev Helper contract to support initializer functions. To use it, replace
762  * the constructor with a function that has the `initializer` modifier.
763  * WARNING: Unlike constructors, initializer functions must be manually
764  * invoked. This applies both to deploying an Initializable contract, as well
765  * as extending an Initializable contract via inheritance.
766  * WARNING: When used with inheritance, manual care must be taken to not invoke
767  * a parent initializer twice, or ensure that all initializers are idempotent,
768  * because this is not dealt with automatically as with constructors.
769  *
770  * @author Roya, inspired by the OpenZeppelin Initializable contract
771  */
772 abstract contract VersionedInitializable {
773     /**
774      * @dev Indicates that the contract has been initialized.
775      */
776     uint256 internal lastInitializedRevision = 0;
777 
778     /**
779      * @dev Modifier to use in the initializer function of a contract.
780      */
781     modifier initializer() {
782         uint256 revision = getRevision();
783         require(
784             revision > lastInitializedRevision,
785             'Contract instance has already been initialized'
786         );
787 
788         lastInitializedRevision = revision;
789 
790         _;
791     }
792 
793     /// @dev returns the revision number of the contract.
794     /// Needs to be defined in the inherited class as a constant.
795     function getRevision() internal virtual pure returns (uint256);
796 
797     // Reserved storage space to allow for layout changes in the future.
798     uint256[50] private ______gap;
799 }
800 
801 // File: contracts/lib/DistributionTypes.sol
802 
803 
804 pragma solidity 0.6.12;
805 
806 
807 library DistributionTypes {
808   struct AssetConfigInput {
809     uint128 emissionPerSecond;
810     uint256 totalStaked;
811     address underlyingAsset;
812   }
813 
814   struct UserStakeInput {
815     address underlyingAsset;
816     uint256 stakedByUser;
817     uint256 totalStaked;
818   }
819 }
820 
821 // File: contracts/interfaces/IRoyaDistributionManager.sol
822 
823 
824 pragma solidity 0.6.12;
825 
826 
827 
828 interface IRoyaDistributionManager {
829   function configureAssets(DistributionTypes.AssetConfigInput[] calldata assetsConfigInput) external;
830 }
831 
832 // File: contracts/stake/RoyaDistributionManager.sol
833 
834 
835 pragma solidity 0.6.12;
836 
837 
838 
839 
840 
841 /**
842  * @title RoyaDistributionManager
843  * @notice Accounting contract to manage multiple staking distributions
844  * @author Roya
845  **/
846 contract RoyaDistributionManager is IRoyaDistributionManager {
847   using SafeMath for uint256;
848 
849   struct AssetData {
850     uint128 emissionPerSecond;
851     uint128 lastUpdateTimestamp;
852     uint256 index;
853     mapping(address => uint256) users;
854   }
855 
856   uint256 public immutable DISTRIBUTION_END;
857 
858   address public immutable EMISSION_MANAGER;
859 
860   uint8 public constant PRECISION = 18;
861 
862   mapping(address => AssetData) public assets;
863 
864   event AssetConfigUpdated(address indexed asset, uint256 emission);
865   event AssetIndexUpdated(address indexed asset, uint256 index);
866   event UserIndexUpdated(address indexed user, address indexed asset, uint256 index);
867 
868   constructor(address emissionManager, uint256 distributionDuration) public {
869     DISTRIBUTION_END = block.timestamp.add(distributionDuration);
870     EMISSION_MANAGER = emissionManager;
871   }
872 
873   /**
874    * @dev Configures the distribution of rewards for a list of assets
875    * @param assetsConfigInput The list of configurations to apply
876    **/
877   function configureAssets(DistributionTypes.AssetConfigInput[] calldata assetsConfigInput) external override {
878     require(msg.sender == EMISSION_MANAGER, 'ONLY_EMISSION_MANAGER');
879 
880     for (uint256 i = 0; i < assetsConfigInput.length; i++) {
881       AssetData storage assetConfig = assets[assetsConfigInput[i].underlyingAsset];
882 
883       _updateAssetStateInternal(
884         assetsConfigInput[i].underlyingAsset,
885         assetConfig,
886         assetsConfigInput[i].totalStaked
887       );
888 
889       assetConfig.emissionPerSecond = assetsConfigInput[i].emissionPerSecond;
890 
891       emit AssetConfigUpdated(
892         assetsConfigInput[i].underlyingAsset,
893         assetsConfigInput[i].emissionPerSecond
894       );
895     }
896   }
897 
898   /**
899    * @dev Updates the state of one distribution, mainly rewards index and timestamp
900    * @param underlyingAsset The address used as key in the distribution, for example sAAVE or the aTokens addresses on Roya
901    * @param assetConfig Storage pointer to the distribution's config
902    * @param totalStaked Current total of staked assets for this distribution
903    * @return The new distribution index
904    **/
905   function _updateAssetStateInternal(
906     address underlyingAsset,
907     AssetData storage assetConfig,
908     uint256 totalStaked
909   ) internal returns (uint256) {
910     uint256 oldIndex = assetConfig.index;
911     uint128 lastUpdateTimestamp = assetConfig.lastUpdateTimestamp;
912 
913     if (block.timestamp == lastUpdateTimestamp) {
914       return oldIndex;
915     }
916 
917     uint256 newIndex = _getAssetIndex(
918       oldIndex,
919       assetConfig.emissionPerSecond,
920       lastUpdateTimestamp,
921       totalStaked
922     );
923 
924     if (newIndex != oldIndex) {
925       assetConfig.index = newIndex;
926       emit AssetIndexUpdated(underlyingAsset, newIndex);
927     }
928 
929     assetConfig.lastUpdateTimestamp = uint128(block.timestamp);
930 
931     return newIndex;
932   }
933 
934   /**
935    * @dev Updates the state of an user in a distribution
936    * @param user The user's address
937    * @param asset The address of the reference asset of the distribution
938    * @param stakedByUser Amount of tokens staked by the user in the distribution at the moment
939    * @param totalStaked Total tokens staked in the distribution
940    * @return The accrued rewards for the user until the moment
941    **/
942   function _updateUserAssetInternal(
943     address user,
944     address asset,
945     uint256 stakedByUser,
946     uint256 totalStaked
947   ) internal returns (uint256) {
948     AssetData storage assetData = assets[asset];
949     uint256 userIndex = assetData.users[user];
950     uint256 accruedRewards = 0;
951 
952     uint256 newIndex = _updateAssetStateInternal(asset, assetData, totalStaked);
953 
954     if (userIndex != newIndex) {
955       if (stakedByUser != 0) {
956         accruedRewards = _getRewards(stakedByUser, newIndex, userIndex);
957       }
958 
959       assetData.users[user] = newIndex;
960       emit UserIndexUpdated(user, asset, newIndex);
961     }
962 
963     return accruedRewards;
964   }
965 
966   /**
967    * @dev Used by "frontend" stake contracts to update the data of an user when claiming rewards from there
968    * @param user The address of the user
969    * @param stakes List of structs of the user data related with his stake
970    * @return The accrued rewards for the user until the moment
971    **/
972   function _claimRewards(address user, DistributionTypes.UserStakeInput[] memory stakes)
973     internal
974     returns (uint256)
975   {
976     uint256 accruedRewards = 0;
977 
978     for (uint256 i = 0; i < stakes.length; i++) {
979       accruedRewards = accruedRewards.add(
980         _updateUserAssetInternal(
981           user,
982           stakes[i].underlyingAsset,
983           stakes[i].stakedByUser,
984           stakes[i].totalStaked
985         )
986       );
987     }
988 
989     return accruedRewards;
990   }
991 
992   /**
993    * @dev Return the accrued rewards for an user over a list of distribution
994    * @param user The address of the user
995    * @param stakes List of structs of the user data related with his stake
996    * @return The accrued rewards for the user until the moment
997    **/
998   function _getUnclaimedRewards(address user, DistributionTypes.UserStakeInput[] memory stakes)
999     internal
1000     view
1001     returns (uint256)
1002   {
1003     uint256 accruedRewards = 0;
1004 
1005     for (uint256 i = 0; i < stakes.length; i++) {
1006       AssetData storage assetConfig = assets[stakes[i].underlyingAsset];
1007       uint256 assetIndex = _getAssetIndex(
1008         assetConfig.index,
1009         assetConfig.emissionPerSecond,
1010         assetConfig.lastUpdateTimestamp,
1011         stakes[i].totalStaked
1012       );
1013 
1014       accruedRewards = accruedRewards.add(
1015         _getRewards(stakes[i].stakedByUser, assetIndex, assetConfig.users[user])
1016       );
1017     }
1018     return accruedRewards;
1019   }
1020 
1021   /**
1022    * @dev Internal function for the calculation of user's rewards on a distribution
1023    * @param principalUserBalance Amount staked by the user on a distribution
1024    * @param reserveIndex Current index of the distribution
1025    * @param userIndex Index stored for the user, representation his staking moment
1026    * @return The rewards
1027    **/
1028   function _getRewards(
1029     uint256 principalUserBalance,
1030     uint256 reserveIndex,
1031     uint256 userIndex
1032   ) internal pure returns (uint256) {
1033     return principalUserBalance.mul(reserveIndex.sub(userIndex)).div(10**uint256(PRECISION));
1034   }
1035 
1036   /**
1037    * @dev Calculates the next value of an specific distribution index, with validations
1038    * @param currentIndex Current index of the distribution
1039    * @param emissionPerSecond Representing the total rewards distributed per second per asset unit, on the distribution
1040    * @param lastUpdateTimestamp Last moment this distribution was updated
1041    * @param totalBalance of tokens considered for the distribution
1042    * @return The new index.
1043    **/
1044   function _getAssetIndex(
1045     uint256 currentIndex,
1046     uint256 emissionPerSecond,
1047     uint128 lastUpdateTimestamp,
1048     uint256 totalBalance
1049   ) internal view returns (uint256) {
1050     if (
1051       emissionPerSecond == 0 ||
1052       totalBalance == 0 ||
1053       lastUpdateTimestamp == block.timestamp ||
1054       lastUpdateTimestamp >= DISTRIBUTION_END
1055     ) {
1056       return currentIndex;
1057     }
1058 
1059     uint256 currentTimestamp = block.timestamp > DISTRIBUTION_END
1060       ? DISTRIBUTION_END
1061       : block.timestamp;
1062     uint256 timeDelta = currentTimestamp.sub(lastUpdateTimestamp);
1063     return
1064       emissionPerSecond.mul(timeDelta).mul(10**uint256(PRECISION)).div(totalBalance).add(
1065         currentIndex
1066       );
1067   }
1068 
1069   /**
1070    * @dev Returns the data of an user on a distribution
1071    * @param user Address of the user
1072    * @param asset The address of the reference asset of the distribution
1073    * @return The new index
1074    **/
1075   function getUserAssetData(address user, address asset) public view returns (uint256) {
1076     return assets[asset].users[user];
1077   }
1078 }
1079 
1080 // File: contracts/stake/StakedToken.sol
1081 
1082 
1083 pragma solidity 0.6.12;
1084 
1085 
1086 
1087 
1088 
1089 
1090 
1091 
1092 
1093 
1094 /**
1095  * @title StakedToken
1096  * @notice Contract to stake Roya token, tokenize the position and get rewards, inheriting from a distribution manager contract
1097  * @author Roya
1098  **/
1099 contract StakedToken is IStakedRoya, ERC20WithSnapshot, VersionedInitializable, RoyaDistributionManager {
1100   using SafeERC20 for IERC20;
1101 
1102   uint256 public constant REVISION = 1;
1103 
1104   IERC20 public immutable STAKED_TOKEN;
1105   IERC20 public immutable REWARD_TOKEN;
1106   uint256 public immutable COOLDOWN_SECONDS;
1107 
1108   /// @notice Seconds available to redeem once the cooldown period is fullfilled
1109   uint256 public immutable UNSTAKE_WINDOW;
1110 
1111   /// @notice Address to pull from the rewards, needs to have approved this contract
1112   address public immutable REWARDS_VAULT;
1113 
1114   mapping(address => uint256) public stakerRewardsToClaim;
1115   mapping(address => uint256) public stakersCooldowns;
1116 
1117   event Staked(address indexed from, address indexed onBehalfOf, uint256 amount);
1118   event Redeem(address indexed from, address indexed to, uint256 amount);
1119 
1120   event RewardsAccrued(address user, uint256 amount);
1121   event RewardsClaimed(address indexed from, address indexed to, uint256 amount);
1122 
1123   event Cooldown(address indexed user);
1124 
1125   constructor(
1126     IERC20 stakedToken,
1127     IERC20 rewardToken,
1128     uint256 cooldownSeconds,
1129     uint256 unstakeWindow,
1130     address rewardsVault,
1131     address emissionManager,
1132     uint128 distributionDuration,
1133     string memory name,
1134     string memory symbol,
1135     uint8 decimals
1136   ) public ERC20WithSnapshot(name, symbol, decimals) RoyaDistributionManager(emissionManager, distributionDuration) {
1137     STAKED_TOKEN = stakedToken;
1138     REWARD_TOKEN = rewardToken;
1139     COOLDOWN_SECONDS = cooldownSeconds;
1140     UNSTAKE_WINDOW = unstakeWindow;
1141     REWARDS_VAULT = rewardsVault;
1142   }
1143 
1144   /**
1145    * @dev Called by the proxy contract
1146    **/
1147   function initialize(ITransferHook royaGovernance, string calldata name, string calldata symbol, uint8 decimals) external initializer {
1148     _setName(name);
1149     _setSymbol(symbol);
1150     _setDecimals(decimals);
1151     _setRoyaGovernance(royaGovernance);
1152   }
1153 
1154   function getStakersCooldowns(address user) public view returns(uint256){
1155     uint256 cooldownStartTimestamp = stakersCooldowns[user];
1156     if (block.timestamp < cooldownStartTimestamp.add(COOLDOWN_SECONDS))
1157         return 1;
1158     else if (block.timestamp.sub(cooldownStartTimestamp.add(COOLDOWN_SECONDS)) <= UNSTAKE_WINDOW)
1159         return 2;
1160     else 
1161         return 0;
1162   }
1163 
1164   function stake(address onBehalfOf, uint256 amount) external override {
1165     require(amount != 0, 'INVALID_ZERO_AMOUNT');
1166     uint256 balanceOfUser = balanceOf(onBehalfOf);
1167 
1168     uint256 accruedRewards = _updateUserAssetInternal(
1169       onBehalfOf,
1170       address(this),
1171       balanceOfUser,
1172       totalSupply()
1173     );
1174     if (accruedRewards != 0) {
1175       emit RewardsAccrued(onBehalfOf, accruedRewards);
1176       stakerRewardsToClaim[onBehalfOf] = stakerRewardsToClaim[onBehalfOf].add(accruedRewards);
1177     }
1178 
1179     stakersCooldowns[onBehalfOf] = getNextCooldownTimestamp(0, amount, onBehalfOf, balanceOfUser);
1180 
1181     _mint(onBehalfOf, amount);
1182     IERC20(STAKED_TOKEN).safeTransferFrom(msg.sender, address(this), amount);
1183 
1184     emit Staked(msg.sender, onBehalfOf, amount);
1185   }
1186 
1187   /**
1188    * @dev Redeems staked tokens, and stop earning rewards
1189    * @param to Address to redeem to
1190    * @param amount Amount to redeem
1191    **/
1192   function redeem(address to, uint256 amount) external override {
1193     require(amount != 0, 'INVALID_ZERO_AMOUNT');
1194     //solium-disable-next-line
1195     uint256 cooldownStartTimestamp = stakersCooldowns[msg.sender];
1196     require(
1197       block.timestamp > cooldownStartTimestamp.add(COOLDOWN_SECONDS),
1198       'INSUFFICIENT_COOLDOWN'
1199     );
1200     require(
1201       block.timestamp.sub(cooldownStartTimestamp.add(COOLDOWN_SECONDS)) <= UNSTAKE_WINDOW,
1202       'UNSTAKE_WINDOW_FINISHED'
1203     );
1204     uint256 balanceOfMessageSender = balanceOf(msg.sender);
1205 
1206     uint256 amountToRedeem = (amount > balanceOfMessageSender) ? balanceOfMessageSender : amount;
1207 
1208     _updateCurrentUnclaimedRewards(msg.sender, balanceOfMessageSender, true);
1209 
1210     _burn(msg.sender, amountToRedeem);
1211 
1212     if (balanceOfMessageSender.sub(amountToRedeem) == 0) {
1213       stakersCooldowns[msg.sender] = 0;
1214     }
1215 
1216     IERC20(STAKED_TOKEN).safeTransfer(to, amountToRedeem);
1217 
1218     emit Redeem(msg.sender, to, amountToRedeem);
1219   }
1220 
1221   /**
1222    * @dev Activates the cooldown period to unstake
1223    * - It can't be called if the user is not staking
1224    **/
1225   function cooldown() external override {
1226     require(balanceOf(msg.sender) != 0, "INVALID_BALANCE_ON_COOLDOWN");
1227     //solium-disable-next-line
1228     stakersCooldowns[msg.sender] = block.timestamp;
1229 
1230     emit Cooldown(msg.sender);
1231   }
1232 
1233   /**
1234    * @dev Claims an `amount` of `REWARD_TOKEN` to the address `to`
1235    * @param to Address to stake for
1236    * @param amount Amount to stake
1237    **/
1238   function claimRewards(address to, uint256 amount) external override {
1239     uint256 newTotalRewards = _updateCurrentUnclaimedRewards(
1240       msg.sender,
1241       balanceOf(msg.sender),
1242       false
1243     );
1244     uint256 amountToClaim = (amount == type(uint256).max) ? newTotalRewards : amount;
1245 
1246     stakerRewardsToClaim[msg.sender] = newTotalRewards.sub(amountToClaim, "INVALID_AMOUNT");
1247 
1248     REWARD_TOKEN.safeTransferFrom(REWARDS_VAULT, to, amountToClaim);
1249 
1250     emit RewardsClaimed(msg.sender, to, amountToClaim);
1251   }
1252 
1253   /**
1254    * @dev Internal ERC20 _transfer of the tokenized staked tokens
1255    * @param from Address to transfer from
1256    * @param to Address to transfer to
1257    * @param amount Amount to transfer
1258    **/
1259   function _transfer(
1260     address from,
1261     address to,
1262     uint256 amount
1263   ) internal override {
1264     uint256 balanceOfFrom = balanceOf(from);
1265     // Sender
1266     _updateCurrentUnclaimedRewards(from, balanceOfFrom, true);
1267 
1268     // Recipient
1269     if (from != to) {
1270       uint256 balanceOfTo = balanceOf(to);
1271       _updateCurrentUnclaimedRewards(to, balanceOfTo, true);
1272 
1273       uint256 previousSenderCooldown = stakersCooldowns[from];
1274       stakersCooldowns[to] = getNextCooldownTimestamp(previousSenderCooldown, amount, to, balanceOfTo);
1275       // if cooldown was set and whole balance of sender was transferred - clear cooldown
1276       if (balanceOfFrom == amount && previousSenderCooldown != 0) {
1277         stakersCooldowns[from] = 0;
1278       }
1279     }
1280 
1281     super._transfer(from, to, amount);
1282   }
1283 
1284   /**
1285    * @dev Updates the user state related with his accrued rewards
1286    * @param user Address of the user
1287    * @param userBalance The current balance of the user
1288    * @param updateStorage Boolean flag used to update or not the stakerRewardsToClaim of the user
1289    * @return The unclaimed rewards that were added to the total accrued
1290    **/
1291   function _updateCurrentUnclaimedRewards(
1292     address user,
1293     uint256 userBalance,
1294     bool updateStorage
1295   ) internal returns (uint256) {
1296     uint256 accruedRewards = _updateUserAssetInternal(
1297       user,
1298       address(this),
1299       userBalance,
1300       totalSupply()
1301     );
1302     uint256 unclaimedRewards = stakerRewardsToClaim[user].add(accruedRewards);
1303 
1304     if (accruedRewards != 0) {
1305       if (updateStorage) {
1306         stakerRewardsToClaim[user] = unclaimedRewards;
1307       }
1308       emit RewardsAccrued(user, accruedRewards);
1309     }
1310 
1311     return unclaimedRewards;
1312   }
1313 
1314   /**
1315    * @dev Calculates the how is gonna be a new cooldown timestamp depending on the sender/receiver situation
1316    *  - If the timestamp of the sender is "better" or the timestamp of the recipient is 0, we take the one of the recipient
1317    *  - Weighted average of from/to cooldown timestamps if:
1318    *    # The sender doesn't have the cooldown activated (timestamp 0).
1319    *    # The sender timestamp is expired
1320    *    # The sender has a "worse" timestamp
1321    *  - If the receiver's cooldown timestamp expired (too old), the next is 0
1322    * @param fromCooldownTimestamp Cooldown timestamp of the sender
1323    * @param amountToReceive Amount
1324    * @param toAddress Address of the recipient
1325    * @param toBalance Current balance of the receiver
1326    * @return The new cooldown timestamp
1327    **/
1328   function getNextCooldownTimestamp(
1329     uint256 fromCooldownTimestamp,
1330     uint256 amountToReceive,
1331     address toAddress,
1332     uint256 toBalance
1333   ) public view returns (uint256) {
1334     uint256 toCooldownTimestamp = stakersCooldowns[toAddress];
1335     if (toCooldownTimestamp == 0) {
1336       return 0;
1337     }
1338 
1339     uint256 minimalValidCooldownTimestamp = block.timestamp.sub(COOLDOWN_SECONDS).sub(
1340       UNSTAKE_WINDOW
1341     );
1342 
1343     if (minimalValidCooldownTimestamp > toCooldownTimestamp) {
1344       toCooldownTimestamp = 0;
1345     } else {
1346       uint256 fromCooldownTimestamp = (minimalValidCooldownTimestamp > fromCooldownTimestamp)
1347         ? block.timestamp
1348         : fromCooldownTimestamp;
1349 
1350       if (fromCooldownTimestamp < toCooldownTimestamp) {
1351         return toCooldownTimestamp;
1352       } else {
1353         toCooldownTimestamp = (
1354           amountToReceive.mul(fromCooldownTimestamp).add(toBalance.mul(toCooldownTimestamp))
1355         )
1356           .div(amountToReceive.add(toBalance));
1357       }
1358     }
1359     //stakersCooldowns[toAddress] = toCooldownTimestamp;
1360 
1361     return toCooldownTimestamp;
1362   }
1363 
1364   /**
1365    * @dev Return the total rewards pending to claim by an staker
1366    * @param staker The staker address
1367    * @return The rewards
1368    */
1369   function getTotalRewardsBalance(address staker) external view returns (uint256) {
1370 
1371       DistributionTypes.UserStakeInput[] memory userStakeInputs
1372      = new DistributionTypes.UserStakeInput[](1);
1373     userStakeInputs[0] = DistributionTypes.UserStakeInput({
1374       underlyingAsset: address(this),
1375       stakedByUser: balanceOf(staker),
1376       totalStaked: totalSupply()
1377     });
1378     return stakerRewardsToClaim[staker].add(_getUnclaimedRewards(staker, userStakeInputs));
1379   }
1380 
1381   /**
1382    * @dev returns the revision of the implementation contract
1383    * @return The revision
1384    */
1385   function getRevision() internal override pure returns (uint256) {
1386     return REVISION;
1387   }
1388 }
1389 
1390 // File: contracts/stake/StakedRoya.sol
1391 
1392 
1393 pragma solidity 0.6.12;
1394 
1395 
1396 
1397 
1398 /**
1399  * @title StakedRoya
1400  * @notice StakedToken with AAVE token as staked token
1401  * @author Roya
1402  **/
1403 contract StakedRoya is StakedToken {
1404   string internal constant NAME = 'Staked Roya';
1405   string internal constant SYMBOL = 'stkRoya';
1406   uint8 internal constant DECIMALS = 18;
1407   
1408   constructor(
1409     IERC20 stakedToken,
1410     IERC20 rewardToken,
1411     uint256 cooldownSeconds,
1412     uint256 unstakeWindow,
1413     address rewardsVault,
1414     address emissionManager,
1415     uint128 distributionDuration
1416   ) public StakedToken(
1417     stakedToken,
1418     rewardToken,
1419     cooldownSeconds,
1420     unstakeWindow,
1421     rewardsVault,
1422     emissionManager,
1423     distributionDuration,
1424     NAME,
1425     SYMBOL,
1426     DECIMALS) {}
1427 }