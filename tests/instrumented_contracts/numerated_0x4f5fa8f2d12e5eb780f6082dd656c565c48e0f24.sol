1 pragma solidity 0.5.8;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     function _msgSender() internal view returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 contract Ownable is Context {
37   address private _owner;
38   mapping (address => bool) public farmAddresses;
39 
40   event OwnershipTransferred(
41     address indexed previousOwner,
42     address indexed newOwner
43   );
44 
45   /**
46    * @dev Initializes the contract setting the deployer as the initial owner.
47    */
48   constructor() internal {
49     address msgSender = _msgSender();
50     _owner = msgSender;
51     emit OwnershipTransferred(address(0), msgSender);
52   }
53 
54   /**
55    * @dev Returns the address of the current owner.
56    */
57   function owner() public view returns (address) {
58     return _owner;
59   }
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
66     _;
67   }
68 
69   modifier onlyFarmContract() {
70     require(isOwner() || isFarmContract(), 'Ownable: caller is not the farm or owner');
71     _;
72   }
73 
74   function isOwner() private view returns (bool) {
75     return _owner == _msgSender();
76   }
77 
78   function isFarmContract() public view returns (bool) {
79     return farmAddresses[_msgSender()];
80   }
81 
82   /**
83    * @dev Transfers ownership of the contract to a new account (`newOwner`).
84    * Can only be called by the current owner.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(
88       newOwner != address(0),
89       'Ownable: new owner is the zero address'
90     );
91     emit OwnershipTransferred(_owner, newOwner);
92     _owner = newOwner;
93   }
94 
95   function setFarmAddress(address _farmAddress, bool _status) public onlyOwner {
96     require(
97       _farmAddress != address(0),
98       'Ownable: farm address is the zero address'
99     );
100     farmAddresses[_farmAddress] = _status;
101   }
102 }
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118   /**
119    * @dev Returns the addition of two unsigned integers, reverting on
120    * overflow.
121    *
122    * Counterpart to Solidity's `+` operator.
123    *
124    * Requirements:
125    *
126    * - Addition cannot overflow.
127    */
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     require(c >= a, 'SafeMath: addition overflow');
131 
132     return c;
133   }
134 
135   /**
136    * @dev Returns the subtraction of two unsigned integers, reverting on
137    * overflow (when the result is negative).
138    *
139    * Counterpart to Solidity's `-` operator.
140    *
141    * Requirements:
142    *
143    * - Subtraction cannot overflow.
144    */
145   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146     return sub(a, b, 'SafeMath: subtraction overflow');
147   }
148 
149   /**
150    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151    * overflow (when the result is negative).
152    *
153    * Counterpart to Solidity's `-` operator.
154    *
155    * Requirements:
156    *
157    * - Subtraction cannot overflow.
158    */
159   function sub(
160     uint256 a,
161     uint256 b,
162     string memory errorMessage
163   ) internal pure returns (uint256) {
164     require(b <= a, errorMessage);
165     uint256 c = a - b;
166 
167     return c;
168   }
169 
170   /**
171    * @dev Returns the multiplication of two unsigned integers, reverting on
172    * overflow.
173    *
174    * Counterpart to Solidity's `*` operator.
175    *
176    * Requirements:
177    *
178    * - Multiplication cannot overflow.
179    */
180   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182     // benefit is lost if 'b' is also tested.
183     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184     if (a == 0) {
185       return 0;
186     }
187 
188     uint256 c = a * b;
189     require(c / a == b, 'SafeMath: multiplication overflow');
190 
191     return c;
192   }
193 
194   /**
195    * @dev Returns the integer division of two unsigned integers. Reverts on
196    * division by zero. The result is rounded towards zero.
197    *
198    * Counterpart to Solidity's `/` operator. Note: this function uses a
199    * `revert` opcode (which leaves remaining gas untouched) while Solidity
200    * uses an invalid opcode to revert (consuming all remaining gas).
201    *
202    * Requirements:
203    *
204    * - The divisor cannot be zero.
205    */
206   function div(uint256 a, uint256 b) internal pure returns (uint256) {
207     return div(a, b, 'SafeMath: division by zero');
208   }
209 
210   /**
211    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212    * division by zero. The result is rounded towards zero.
213    *
214    * Counterpart to Solidity's `/` operator. Note: this function uses a
215    * `revert` opcode (which leaves remaining gas untouched) while Solidity
216    * uses an invalid opcode to revert (consuming all remaining gas).
217    *
218    * Requirements:
219    *
220    * - The divisor cannot be zero.
221    */
222   function div(
223     uint256 a,
224     uint256 b,
225     string memory errorMessage
226   ) internal pure returns (uint256) {
227     require(b > 0, errorMessage);
228     uint256 c = a / b;
229     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231     return c;
232   }
233 
234   /**
235    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236    * Reverts when dividing by zero.
237    *
238    * Counterpart to Solidity's `%` operator. This function uses a `revert`
239    * opcode (which leaves remaining gas untouched) while Solidity uses an
240    * invalid opcode to revert (consuming all remaining gas).
241    *
242    * Requirements:
243    *
244    * - The divisor cannot be zero.
245    */
246   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247     return mod(a, b, 'SafeMath: modulo by zero');
248   }
249 
250   /**
251    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252    * Reverts with custom message when dividing by zero.
253    *
254    * Counterpart to Solidity's `%` operator. This function uses a `revert`
255    * opcode (which leaves remaining gas untouched) while Solidity uses an
256    * invalid opcode to revert (consuming all remaining gas).
257    *
258    * Requirements:
259    *
260    * - The divisor cannot be zero.
261    */
262   function mod(
263     uint256 a,
264     uint256 b,
265     string memory errorMessage
266   ) internal pure returns (uint256) {
267     require(b != 0, errorMessage);
268     return a % b;
269   }
270 }
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
295         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
296         // for accounts without code, i.e. `keccak256('')`
297         bytes32 codehash;
298 
299 
300             bytes32 accountHash
301          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
302         // solhint-disable-next-line no-inline-assembly
303         assembly {
304             codehash := extcodehash(account)
305         }
306         return (codehash != accountHash && codehash != 0x0);
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(
327             address(this).balance >= amount,
328             'Address: insufficient balance'
329         );
330 
331         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
332         (bool success, ) = recipient.call.value(amount)('');
333         require(
334             success,
335             'Address: unable to send value, recipient may have reverted'
336         );
337     }
338 
339     /**
340      * @dev Performs a Solidity function call using a low level `call`. A
341      * plain`call` is an unsafe replacement for a function call: use this
342      * function instead.
343      *
344      * If `target` reverts with a revert reason, it is bubbled up by this
345      * function (like regular Solidity function calls).
346      *
347      * Returns the raw returned data. To convert to the expected return value,
348      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
349      *
350      * Requirements:
351      *
352      * - `target` must be a contract.
353      * - calling `target` with `data` must not revert.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data)
358         internal
359         returns (bytes memory)
360     {
361         return functionCall(target, data, 'Address: low-level call failed');
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
366      * `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         return _functionCallWithValue(target, data, 0, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but also transferring `value` wei to `target`.
381      *
382      * Requirements:
383      *
384      * - the calling contract must have an ETH balance of at least `value`.
385      * - the called Solidity function must be `payable`.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(
390         address target,
391         bytes memory data,
392         uint256 value
393     ) internal returns (bytes memory) {
394         return
395             functionCallWithValue(
396                 target,
397                 data,
398                 value,
399                 'Address: low-level call with value failed'
400             );
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
405      * with `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(
410         address target,
411         bytes memory data,
412         uint256 value,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         require(
416             address(this).balance >= value,
417             'Address: insufficient balance for call'
418         );
419         return _functionCallWithValue(target, data, value, errorMessage);
420     }
421 
422     function _functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 weiValue,
426         string memory errorMessage
427     ) private returns (bytes memory) {
428         require(isContract(target), 'Address: call to non-contract');
429 
430         // solhint-disable-next-line avoid-low-level-calls
431         (bool success, bytes memory returndata) = target.call.value(weiValue)(
432             data
433         );
434         if (success) {
435             return returndata;
436         } else {
437             // Look for revert reason and bubble it up if present
438             if (returndata.length > 0) {
439                 // The easiest way to bubble the revert reason is using memory via assembly
440 
441                 // solhint-disable-next-line no-inline-assembly
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 /**
454  * @dev Implementation of the {IERC20} interface.
455  *
456  * This implementation is agnostic to the way tokens are created. This means
457  * that a supply mechanism has to be added in a derived contract using {_mint}.
458  * For a generic mechanism see {ERC20PresetMinterPauser}.
459  *
460  * TIP: For a detailed writeup see our guide
461  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
462  * to implement supply mechanisms].
463  *
464  * We have followed general OpenZeppelin guidelines: functions revert instead
465  * of returning `false` on failure. This behavior is nonetheless conventional
466  * and does not conflict with the expectations of ERC20 applications.
467  *
468  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
469  * This allows applications to reconstruct the allowance for all accounts just
470  * by listening to said events. Other implementations of the EIP may not emit
471  * these events, as it isn't required by the specification.
472  *
473  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
474  * functions have been added to mitigate the well-known issues around setting
475  * allowances. See {IERC20-approve}.
476  */
477 contract ERC20 is Context {
478     using SafeMath for uint256;
479     using Address for address;
480 
481     mapping(address => uint256) private _balances;
482 
483     mapping(address => mapping(address => uint256)) private _allowances;
484 
485     uint256 private _totalSupply;
486 
487     string private _name;
488     string private _symbol;
489     uint8 private _decimals;
490 
491     /**
492      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
493      * a default value of 18.
494      *
495      * To select a different value for {decimals}, use {_setupDecimals}.
496      *
497      * All three of these values are immutable: they can only be set once during
498      * construction.
499      */
500     constructor(string memory name, string memory symbol, uint totalSupply, address tokenContractAddress) public {
501         _name = name;
502         _symbol = symbol;
503         _decimals = 18;
504         _totalSupply = totalSupply;
505 
506         _balances[tokenContractAddress] = _totalSupply;
507 
508         emit Transfer(address(0), tokenContractAddress, _totalSupply);
509     }
510 
511     /**
512      * @dev Returns the name of the token.
513      */
514     function name() public view returns (string memory) {
515         return _name;
516     }
517 
518     /**
519      * @dev Returns the symbol of the token, usually a shorter version of the
520      * name.
521      */
522     function symbol() public view returns (string memory) {
523         return _symbol;
524     }
525 
526     /**
527      * @dev Returns the number of decimals used to get its user representation.
528      * For example, if `decimals` equals `2`, a balance of `505` tokens should
529      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
530      *
531      * Tokens usually opt for a value of 18, imitating the relationship between
532      * Ether and Wei.
533      *
534      * NOTE: This information is only used for _display_ purposes: it in
535      * no way affects any of the arithmetic of the contract, including
536      * {IERC20-balanceOf} and {IERC20-transfer}.
537      */
538     function decimals() public view returns (uint8) {
539         return _decimals;
540     }
541 
542     /**
543      * @dev See {IERC20-totalSupply}.
544      */
545     function totalSupply() public view returns (uint256) {
546         return _totalSupply;
547     }
548 
549     /**
550      * @dev See {IERC20-balanceOf}.
551      */
552     function balanceOf(address account) public view returns (uint256) {
553         return _balances[account];
554     }
555 
556     /**
557      * @dev See {IERC20-transfer}.
558      *
559      * Requirements:
560      *
561      * - `recipient` cannot be the zero address.
562      * - the caller must have a balance of at least `amount`.
563      */
564     function transfer(address recipient, uint256 amount) public returns (bool) {
565         _transfer(_msgSender(), recipient, amount);
566         return true;
567     }
568 
569     /**
570      * @dev See {IERC20-allowance}.
571      */
572     function allowance(address owner, address spender)
573         public
574         view
575         returns (uint256)
576     {
577         return _allowances[owner][spender];
578     }
579 
580     /**
581      * @dev See {IERC20-approve}.
582      *
583      * Requirements:
584      *
585      * - `spender` cannot be the zero address.
586      */
587     function approve(address spender, uint256 amount) public returns (bool) {
588         _approve(_msgSender(), spender, amount);
589         return true;
590     }
591 
592     /**
593      * @dev See {IERC20-transferFrom}.
594      *
595      * Emits an {Approval} event indicating the updated allowance. This is not
596      * required by the EIP. See the note at the beginning of {ERC20};
597      *
598      * Requirements:
599      * - `sender` and `recipient` cannot be the zero address.
600      * - `sender` must have a balance of at least `amount`.
601      * - the caller must have allowance for ``sender``'s tokens of at least
602      * `amount`.
603      */
604     function transferFrom(
605         address sender,
606         address recipient,
607         uint256 amount
608     ) public returns (bool) {
609         _transfer(sender, recipient, amount);
610         _approve(
611             sender,
612             _msgSender(),
613             _allowances[sender][_msgSender()].sub(
614                 amount,
615                 'ERC20: transfer amount exceeds allowance'
616             )
617         );
618         return true;
619     }
620 
621     /**
622      * @dev Atomically increases the allowance granted to `spender` by the caller.
623      *
624      * This is an alternative to {approve} that can be used as a mitigation for
625      * problems described in {IERC20-approve}.
626      *
627      * Emits an {Approval} event indicating the updated allowance.
628      *
629      * Requirements:
630      *
631      * - `spender` cannot be the zero address.
632      */
633     function increaseAllowance(address spender, uint256 addedValue)
634         public
635         returns (bool)
636     {
637         _approve(
638             _msgSender(),
639             spender,
640             _allowances[_msgSender()][spender].add(addedValue)
641         );
642         return true;
643     }
644 
645     /**
646      * @dev Atomically decreases the allowance granted to `spender` by the caller.
647      *
648      * This is an alternative to {approve} that can be used as a mitigation for
649      * problems described in {IERC20-approve}.
650      *
651      * Emits an {Approval} event indicating the updated allowance.
652      *
653      * Requirements:
654      *
655      * - `spender` cannot be the zero address.
656      * - `spender` must have allowance for the caller of at least
657      * `subtractedValue`.
658      */
659     function decreaseAllowance(address spender, uint256 subtractedValue)
660         public
661         returns (bool)
662     {
663         _approve(
664             _msgSender(),
665             spender,
666             _allowances[_msgSender()][spender].sub(
667                 subtractedValue,
668                 'ERC20: decreased allowance below zero'
669             )
670         );
671         return true;
672     }
673 
674     /**
675      * @dev Moves tokens `amount` from `sender` to `recipient`.
676      *
677      * This is internal function is equivalent to {transfer}, and can be used to
678      * e.g. implement automatic token fees, slashing mechanisms, etc.
679      *
680      * Emits a {Transfer} event.
681      *
682      * Requirements:
683      *
684      * - `sender` cannot be the zero address.
685      * - `recipient` cannot be the zero address.
686      * - `sender` must have a balance of at least `amount`.
687      */
688     function _transfer(
689         address sender,
690         address recipient,
691         uint256 amount
692     ) internal {
693         require(sender != address(0), 'ERC20: transfer from the zero address');
694         require(recipient != address(0), 'ERC20: transfer to the zero address');
695 
696         _beforeTokenTransfer(sender, recipient, amount);
697 
698         _balances[sender] = _balances[sender].sub(
699             amount,
700             'ERC20: transfer amount exceeds balance'
701         );
702         _balances[recipient] = _balances[recipient].add(amount);
703         emit Transfer(sender, recipient, amount);
704     }
705 
706     /**
707      * @dev Destroys `amount` tokens from `account`, reducing the
708      * total supply.
709      *
710      * Emits a {Transfer} event with `to` set to the zero address.
711      *
712      * Requirements
713      *
714      * - `account` cannot be the zero address.
715      * - `account` must have at least `amount` tokens.
716      */
717     function _burn(address account, uint256 amount) internal {
718         require(account != address(0), 'ERC20: burn from the zero address');
719 
720         _beforeTokenTransfer(account, address(0), amount);
721 
722         _balances[account] = _balances[account].sub(
723             amount,
724             'ERC20: burn amount exceeds balance'
725         );
726         _totalSupply = _totalSupply.sub(amount);
727         emit Transfer(account, address(0), amount);
728     }
729 
730     /**
731      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
732      *
733      * This is internal function is equivalent to `approve`, and can be used to
734      * e.g. set automatic allowances for certain subsystems, etc.
735      *
736      * Emits an {Approval} event.
737      *
738      * Requirements:
739      *
740      * - `owner` cannot be the zero address.
741      * - `spender` cannot be the zero address.
742      */
743     function _approve(
744         address owner,
745         address spender,
746         uint256 amount
747     ) internal {
748         require(owner != address(0), 'ERC20: approve from the zero address');
749         require(spender != address(0), 'ERC20: approve to the zero address');
750 
751         _allowances[owner][spender] = amount;
752         emit Approval(owner, spender, amount);
753     }
754 
755     /**
756      * @dev Hook that is called before any transfer of tokens. This includes
757      * minting and burning.
758      *
759      * Calling conditions:
760      *
761      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
762      * will be to transferred to `to`.
763      * - when `from` is zero, `amount` tokens will be minted for `to`.
764      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
765      * - `from` and `to` are never both zero.
766      *
767      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
768      */
769     function _beforeTokenTransfer(
770         address from,
771         address to,
772         uint256 amount
773     ) internal {}
774 
775     /**
776      * @dev Emitted when `value` tokens are moved from one account (`from`) to
777      * another (`to`).
778      *
779      * Note that `value` may be zero.
780      */
781     event Transfer(address indexed from, address indexed to, uint256 value);
782 
783     /**
784      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
785      * a call to {approve}. `value` is the new allowance.
786      */
787     event Approval(
788         address indexed owner,
789         address indexed spender,
790         uint256 value
791     );
792 }
793 
794 contract GourmetGalaxy is ERC20('GourmetGalaxy', 'GUM', 20e6 * 1e18, address(this)), Ownable {
795 
796   uint private constant adviserAllocation = 1e6 * 1e18;
797   uint private constant communityAllocation = 5e4 * 1e18;
798   uint private constant farmingAllocation = 9950000 * 1e18;
799   uint private constant marketingAllocation = 5e5 * 1e18;
800   uint private constant publicSaleAllocation = 5e5 * 1e18;
801   uint private constant privateSaleAllocation = 5e6 * 1e18;
802   uint private constant teamAllocation = 3e6 * 1e18;
803 
804   uint private communityReleased = 0;
805   uint private adviserReleased = 0;
806   uint private farmingReleased = 0;
807   uint private marketingReleased = 125000 * 1e18; // TGE
808   uint private privateSaleReleased = 2e6 * 1e18;
809   uint private teamReleased = 0;
810 
811   uint private lastCommunityReleased = now + 30 days;
812   uint private lastAdviserReleased = now + 30 days;
813   uint private lastMarketingReleased = now + 30 days;
814   uint private lastPrivateSaleReleased = now + 30 days;
815   uint private lastTeamReleased = now + 30 days;
816 
817   uint private constant amountEachAdviserRelease = 50000 * 1e18;
818   uint private constant amountEachCommunityRelease = 2500 * 1e18;
819   uint private constant amountEachMarketingRelease = 125000 * 1e18;
820   uint private constant amountEachPrivateSaleRelease = 1e6 * 1e18;
821   uint private constant amountEachTeamRelease = 150000 * 1e18;
822 
823   constructor(
824     address _marketingTGEAddress,
825     address _privateSaleTGEAddress,
826     address _publicSaleTGEAddress
827   ) public {
828     _transfer(address(this), _marketingTGEAddress, marketingReleased);
829     _transfer(address(this), _privateSaleTGEAddress, privateSaleReleased);
830     _transfer(address(this), _publicSaleTGEAddress, publicSaleAllocation);
831   }
832 
833   function releaseAdviserAllocation(address _receiver) public onlyOwner {
834     require(adviserReleased.add(amountEachAdviserRelease) <= adviserAllocation, 'Max adviser allocation released!!!');
835     require(now - lastAdviserReleased >= 30 days, 'Please wait to next checkpoint!');
836     _transfer(address(this), _receiver, amountEachAdviserRelease);
837     adviserReleased = adviserReleased.add(amountEachAdviserRelease);
838     lastAdviserReleased = lastAdviserReleased + 30 days;
839   }
840 
841   function releaseCommunityAllocation(address _receiver) public onlyOwner {
842     require(communityReleased.add(amountEachCommunityRelease) <= communityAllocation, 'Max community allocation released!!!');
843     require(now - lastCommunityReleased >= 90 days, 'Please wait to next checkpoint!');
844     _transfer(address(this), _receiver, amountEachCommunityRelease);
845     communityReleased = communityReleased.add(amountEachCommunityRelease);
846     lastCommunityReleased = lastCommunityReleased + 90 days;
847   }
848 
849   function releaseFarmAllocation(address _farmAddress, uint256 _amount) public onlyFarmContract {
850     require(farmingReleased.add(_amount) <= farmingAllocation, 'Max farming allocation released!!!');
851     _transfer(address(this), _farmAddress, _amount);
852     farmingReleased = farmingReleased.add(_amount);
853   }
854 
855   function releaseMarketingAllocation(address _receiver) public onlyOwner {
856     require(marketingReleased.add(amountEachMarketingRelease) <= marketingAllocation, 'Max marketing allocation released!!!');
857     require(now - lastMarketingReleased >= 90 days, 'Please wait to next checkpoint!');
858     _transfer(address(this), _receiver, amountEachMarketingRelease);
859     marketingReleased = marketingReleased.add(amountEachMarketingRelease);
860     lastMarketingReleased = lastMarketingReleased + 90 days;
861   }
862 
863   function releasePrivateSaleAllocation(address _receiver) public onlyOwner {
864     require(privateSaleReleased.add(amountEachPrivateSaleRelease) <= privateSaleAllocation, 'Max privateSale allocation released!!!');
865     require(now - lastPrivateSaleReleased >= 90 days, 'Please wait to next checkpoint!');
866     _transfer(address(this), _receiver, amountEachPrivateSaleRelease);
867     privateSaleReleased = privateSaleReleased.add(amountEachPrivateSaleRelease);
868     lastPrivateSaleReleased = lastPrivateSaleReleased + 90 days;
869   }
870 
871   function releaseTeamAllocation(address _receiver) public onlyOwner {
872     require(teamReleased.add(amountEachTeamRelease) <= teamAllocation, 'Max team allocation released!!!');
873     require(now - lastTeamReleased >= 30 days, 'Please wait to next checkpoint!');
874     _transfer(address(this), _receiver, amountEachTeamRelease);
875     teamReleased = teamReleased.add(amountEachTeamRelease);
876     lastTeamReleased = lastTeamReleased + 30 days;
877   }
878 }