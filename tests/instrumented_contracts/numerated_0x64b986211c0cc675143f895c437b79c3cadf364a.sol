1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-27
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2021-06-26
7 */
8 
9 /**
10  *Submitted for verification at BscScan.com on 2021-05-05
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity 0.6.12;
16 
17 
18 // 
19 /*
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with GSN meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 contract Context {
30     // Empty internal constructor, to prevent people from mistakenly deploying
31     // an instance of this contract, which should be used via inheritance.
32     constructor() internal {}
33 
34     function _msgSender() internal view returns (address payable) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view returns (bytes memory) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 // 
45 /**
46  * @dev Contract module which provides a basic access control mechanism, where
47  * there is an account (an owner) that can be granted exclusive access to
48  * specific functions.
49  *
50  * By default, the owner account will be the one that deploys the contract. This
51  * can later be changed with {transferOwnership}.
52  *
53  * This module is used through inheritance. It will make available the modifier
54  * `onlyOwner`, which can be applied to your functions to restrict their use to
55  * the owner.
56  */
57 contract Ownable is Context {
58     address private _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev Initializes the contract setting the deployer as the initial owner.
64      */
65     constructor() internal {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
83         _;
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Can only be called by the current owner.
101      */
102     function transferOwnership(address newOwner) public onlyOwner {
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      */
109     function _transferOwnership(address newOwner) internal {
110         require(newOwner != address(0), 'Ownable: new owner is the zero address');
111         emit OwnershipTransferred(_owner, newOwner);
112         _owner = newOwner;
113     }
114 }
115 
116 // 
117 interface IBEP20 {
118     /**
119      * @dev Returns the amount of tokens in existence.
120      */
121     function totalSupply() external view returns (uint256);
122 
123     /**
124      * @dev Returns the token decimals.
125      */
126     function decimals() external view returns (uint8);
127 
128     /**
129      * @dev Returns the token symbol.
130      */
131     function symbol() external view returns (string memory);
132 
133     /**
134      * @dev Returns the token name.
135      */
136     function name() external view returns (string memory);
137 
138     /**
139      * @dev Returns the amount of tokens owned by `account`.
140      */
141     function balanceOf(address account) external view returns (uint256);
142 
143     /**
144      * @dev Moves `amount` tokens from the caller's account to `recipient`.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transfer(address recipient, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Returns the remaining number of tokens that `spender` will be
154      * allowed to spend on behalf of `owner` through {transferFrom}. This is
155      * zero by default.
156      *
157      * This value changes when {approve} or {transferFrom} are called.
158      */
159     function allowance(address _owner, address spender) external view returns (uint256);
160 
161     /**
162      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * IMPORTANT: Beware that changing an allowance with this method brings the risk
167      * that someone may use both the old and the new allowance by unfortunate
168      * transaction ordering. One possible solution to mitigate this race
169      * condition is to first reduce the spender's allowance to 0 and set the
170      * desired value afterwards:
171      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172      *
173      * Emits an {Approval} event.
174      */
175     function approve(address spender, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Moves `amount` tokens from `sender` to `recipient` using the
179      * allowance mechanism. `amount` is then deducted from the caller's
180      * allowance.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transferFrom(
187         address sender,
188         address recipient,
189         uint256 amount
190     ) external returns (bool);
191 
192     /**
193      * @dev Emitted when `value` tokens are moved from one account (`from`) to
194      * another (`to`).
195      *
196      * Note that `value` may be zero.
197      */
198     event Transfer(address indexed from, address indexed to, uint256 value);
199 
200     /**
201      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
202      * a call to {approve}. `value` is the new allowance.
203      */
204     event Approval(address indexed owner, address indexed spender, uint256 value);
205 }
206 
207 // 
208 /**
209  * @dev Wrappers over Solidity's arithmetic operations with added overflow
210  * checks.
211  *
212  * Arithmetic operations in Solidity wrap on overflow. This can easily result
213  * in bugs, because programmers usually assume that an overflow raises an
214  * error, which is the standard behavior in high level programming languages.
215  * `SafeMath` restores this intuition by reverting the transaction when an
216  * operation overflows.
217  *
218  * Using this library instead of the unchecked operations eliminates an entire
219  * class of bugs, so it's recommended to use it always.
220  */
221 library SafeMath {
222     /**
223      * @dev Returns the addition of two unsigned integers, reverting on
224      * overflow.
225      *
226      * Counterpart to Solidity's `+` operator.
227      *
228      * Requirements:
229      *
230      * - Addition cannot overflow.
231      */
232     function add(uint256 a, uint256 b) internal pure returns (uint256) {
233         uint256 c = a + b;
234         require(c >= a, 'SafeMath: addition overflow');
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the subtraction of two unsigned integers, reverting on
241      * overflow (when the result is negative).
242      *
243      * Counterpart to Solidity's `-` operator.
244      *
245      * Requirements:
246      *
247      * - Subtraction cannot overflow.
248      */
249     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
250         return sub(a, b, 'SafeMath: subtraction overflow');
251     }
252 
253     /**
254      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
255      * overflow (when the result is negative).
256      *
257      * Counterpart to Solidity's `-` operator.
258      *
259      * Requirements:
260      *
261      * - Subtraction cannot overflow.
262      */
263     function sub(
264         uint256 a,
265         uint256 b,
266         string memory errorMessage
267     ) internal pure returns (uint256) {
268         require(b <= a, errorMessage);
269         uint256 c = a - b;
270 
271         return c;
272     }
273 
274     /**
275      * @dev Returns the multiplication of two unsigned integers, reverting on
276      * overflow.
277      *
278      * Counterpart to Solidity's `*` operator.
279      *
280      * Requirements:
281      *
282      * - Multiplication cannot overflow.
283      */
284     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
285         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
286         // benefit is lost if 'b' is also tested.
287         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
288         if (a == 0) {
289             return 0;
290         }
291 
292         uint256 c = a * b;
293         require(c / a == b, 'SafeMath: multiplication overflow');
294 
295         return c;
296     }
297 
298     /**
299      * @dev Returns the integer division of two unsigned integers. Reverts on
300      * division by zero. The result is rounded towards zero.
301      *
302      * Counterpart to Solidity's `/` operator. Note: this function uses a
303      * `revert` opcode (which leaves remaining gas untouched) while Solidity
304      * uses an invalid opcode to revert (consuming all remaining gas).
305      *
306      * Requirements:
307      *
308      * - The divisor cannot be zero.
309      */
310     function div(uint256 a, uint256 b) internal pure returns (uint256) {
311         return div(a, b, 'SafeMath: division by zero');
312     }
313 
314     /**
315      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
316      * division by zero. The result is rounded towards zero.
317      *
318      * Counterpart to Solidity's `/` operator. Note: this function uses a
319      * `revert` opcode (which leaves remaining gas untouched) while Solidity
320      * uses an invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      *
324      * - The divisor cannot be zero.
325      */
326     function div(
327         uint256 a,
328         uint256 b,
329         string memory errorMessage
330     ) internal pure returns (uint256) {
331         require(b > 0, errorMessage);
332         uint256 c = a / b;
333         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
334 
335         return c;
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
340      * Reverts when dividing by zero.
341      *
342      * Counterpart to Solidity's `%` operator. This function uses a `revert`
343      * opcode (which leaves remaining gas untouched) while Solidity uses an
344      * invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      *
348      * - The divisor cannot be zero.
349      */
350     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
351         return mod(a, b, 'SafeMath: modulo by zero');
352     }
353 
354     /**
355      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
356      * Reverts with custom message when dividing by zero.
357      *
358      * Counterpart to Solidity's `%` operator. This function uses a `revert`
359      * opcode (which leaves remaining gas untouched) while Solidity uses an
360      * invalid opcode to revert (consuming all remaining gas).
361      *
362      * Requirements:
363      *
364      * - The divisor cannot be zero.
365      */
366     function mod(
367         uint256 a,
368         uint256 b,
369         string memory errorMessage
370     ) internal pure returns (uint256) {
371         require(b != 0, errorMessage);
372         return a % b;
373     }
374 
375     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
376         z = x < y ? x : y;
377     }
378 
379     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
380     function sqrt(uint256 y) internal pure returns (uint256 z) {
381         if (y > 3) {
382             z = y;
383             uint256 x = y / 2 + 1;
384             while (x < z) {
385                 z = x;
386                 x = (y / x + x) / 2;
387             }
388         } else if (y != 0) {
389             z = 1;
390         }
391     }
392 }
393 
394 // 
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
417         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
418         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
419         // for accounts without code, i.e. `keccak256('')`
420         bytes32 codehash;
421         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
422         // solhint-disable-next-line no-inline-assembly
423         assembly {
424             codehash := extcodehash(account)
425         }
426         return (codehash != accountHash && codehash != 0x0);
427     }
428 
429     /**
430      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
431      * `recipient`, forwarding all available gas and reverting on errors.
432      *
433      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
434      * of certain opcodes, possibly making contracts go over the 2300 gas limit
435      * imposed by `transfer`, making them unable to receive funds via
436      * `transfer`. {sendValue} removes this limitation.
437      *
438      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
439      *
440      * IMPORTANT: because control is transferred to `recipient`, care must be
441      * taken to not create reentrancy vulnerabilities. Consider using
442      * {ReentrancyGuard} or the
443      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
444      */
445     function sendValue(address payable recipient, uint256 amount) internal {
446         require(address(this).balance >= amount, 'Address: insufficient balance');
447 
448         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
449         (bool success, ) = recipient.call{value: amount}('');
450         require(success, 'Address: unable to send value, recipient may have reverted');
451     }
452 
453     /**
454      * @dev Performs a Solidity function call using a low level `call`. A
455      * plain`call` is an unsafe replacement for a function call: use this
456      * function instead.
457      *
458      * If `target` reverts with a revert reason, it is bubbled up by this
459      * function (like regular Solidity function calls).
460      *
461      * Returns the raw returned data. To convert to the expected return value,
462      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
463      *
464      * Requirements:
465      *
466      * - `target` must be a contract.
467      * - calling `target` with `data` must not revert.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
472         return functionCall(target, data, 'Address: low-level call failed');
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
477      * `errorMessage` as a fallback revert reason when `target` reverts.
478      *
479      * _Available since v3.1._
480      */
481     function functionCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         return _functionCallWithValue(target, data, 0, errorMessage);
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
491      * but also transferring `value` wei to `target`.
492      *
493      * Requirements:
494      *
495      * - the calling contract must have an ETH balance of at least `value`.
496      * - the called Solidity function must be `payable`.
497      *
498      * _Available since v3.1._
499      */
500     function functionCallWithValue(
501         address target,
502         bytes memory data,
503         uint256 value
504     ) internal returns (bytes memory) {
505         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
510      * with `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(
515         address target,
516         bytes memory data,
517         uint256 value,
518         string memory errorMessage
519     ) internal returns (bytes memory) {
520         require(address(this).balance >= value, 'Address: insufficient balance for call');
521         return _functionCallWithValue(target, data, value, errorMessage);
522     }
523 
524     function _functionCallWithValue(
525         address target,
526         bytes memory data,
527         uint256 weiValue,
528         string memory errorMessage
529     ) private returns (bytes memory) {
530         require(isContract(target), 'Address: call to non-contract');
531 
532         // solhint-disable-next-line avoid-low-level-calls
533         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
534         if (success) {
535             return returndata;
536         } else {
537             // Look for revert reason and bubble it up if present
538             if (returndata.length > 0) {
539                 // The easiest way to bubble the revert reason is using memory via assembly
540 
541                 // solhint-disable-next-line no-inline-assembly
542                 assembly {
543                     let returndata_size := mload(returndata)
544                     revert(add(32, returndata), returndata_size)
545                 }
546             } else {
547                 revert(errorMessage);
548             }
549         }
550     }
551 }
552 
553 // 
554 /**
555  * @dev Implementation of the {IBEP20} interface.
556  *
557  * This implementation is agnostic to the way tokens are created. This means
558  * that a supply mechanism has to be added in a derived contract using {_mint}.
559  * For a generic mechanism see {BEP20PresetMinterPauser}.
560  *
561  * TIP: For a detailed writeup see our guide
562  * https://forum.zeppelin.solutions/t/how-to-implement-BEP20-supply-mechanisms/226[How
563  * to implement supply mechanisms].
564  *
565  * We have followed general OpenZeppelin guidelines: functions revert instead
566  * of returning `false` on failure. This behavior is nonetheless conventional
567  * and does not conflict with the expectations of BEP20 applications.
568  *
569  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
570  * This allows applications to reconstruct the allowance for all accounts just
571  * by listening to said events. Other implementations of the EIP may not emit
572  * these events, as it isn't required by the specification.
573  *
574  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
575  * functions have been added to mitigate the well-known issues around setting
576  * allowances. See {IBEP20-approve}.
577  */
578 contract BEP20 is Context, IBEP20 {
579     using SafeMath for uint256;
580     using Address for address;
581 
582     mapping(address => uint256) private _balances;
583 
584     mapping(address => mapping(address => uint256)) private _allowances;
585 
586     uint256 private _totalSupply;
587 
588     string private _name;
589     string private _symbol;
590     uint8 private _decimals;
591 
592     /**
593      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
594      * a default value of 18.
595      *
596      * To select a different value for {decimals}, use {_setupDecimals}.
597      *
598      * All three of these values are immutable: they can only be set once during
599      * construction.
600      */
601     constructor(string memory name, string memory symbol) public {
602         _name = name;
603         _symbol = symbol;
604         _decimals = 18;
605     }
606 
607     /**
608      * @dev Returns the token name.
609      */
610     function name() public override view returns (string memory) {
611         return _name;
612     }
613 
614     /**
615      * @dev Returns the token decimals.
616      */
617     function decimals() public override view returns (uint8) {
618         return _decimals;
619     }
620 
621     /**
622      * @dev Returns the token symbol.
623      */
624     function symbol() public override view returns (string memory) {
625         return _symbol;
626     }
627 
628     /**
629      * @dev See {BEP20-totalSupply}.
630      */
631     function totalSupply() public override view returns (uint256) {
632         return _totalSupply;
633     }
634 
635     /**
636      * @dev See {BEP20-balanceOf}.
637      */
638     function balanceOf(address account) public override view returns (uint256) {
639         return _balances[account];
640     }
641 
642     /**
643      * @dev See {BEP20-transfer}.
644      *
645      * Requirements:
646      *
647      * - `recipient` cannot be the zero address.
648      * - the caller must have a balance of at least `amount`.
649      */
650     function transfer(address recipient, uint256 amount) public override returns (bool) {
651         _transfer(_msgSender(), recipient, amount);
652         return true;
653     }
654 
655     /**
656      * @dev See {BEP20-allowance}.
657      */
658     function allowance(address owner, address spender) public override view returns (uint256) {
659         return _allowances[owner][spender];
660     }
661 
662     /**
663      * @dev See {BEP20-approve}.
664      *
665      * Requirements:
666      *
667      * - `spender` cannot be the zero address.
668      */
669     function approve(address spender, uint256 amount) public override returns (bool) {
670         _approve(_msgSender(), spender, amount);
671         return true;
672     }
673 
674     /**
675      * @dev See {BEP20-transferFrom}.
676      *
677      * Emits an {Approval} event indicating the updated allowance. This is not
678      * required by the EIP. See the note at the beginning of {BEP20};
679      *
680      * Requirements:
681      * - `sender` and `recipient` cannot be the zero address.
682      * - `sender` must have a balance of at least `amount`.
683      * - the caller must have allowance for `sender`'s tokens of at least
684      * `amount`.
685      */
686     function transferFrom(
687         address sender,
688         address recipient,
689         uint256 amount
690     ) public override returns (bool) {
691         _transfer(sender, recipient, amount);
692         _approve(
693             sender,
694             _msgSender(),
695             _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
696         );
697         return true;
698     }
699 
700     /**
701      * @dev Atomically increases the allowance granted to `spender` by the caller.
702      *
703      * This is an alternative to {approve} that can be used as a mitigation for
704      * problems described in {BEP20-approve}.
705      *
706      * Emits an {Approval} event indicating the updated allowance.
707      *
708      * Requirements:
709      *
710      * - `spender` cannot be the zero address.
711      */
712     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
713         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
714         return true;
715     }
716 
717     /**
718      * @dev Atomically decreases the allowance granted to `spender` by the caller.
719      *
720      * This is an alternative to {approve} that can be used as a mitigation for
721      * problems described in {BEP20-approve}.
722      *
723      * Emits an {Approval} event indicating the updated allowance.
724      *
725      * Requirements:
726      *
727      * - `spender` cannot be the zero address.
728      * - `spender` must have allowance for the caller of at least
729      * `subtractedValue`.
730      */
731     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
732         _approve(
733             _msgSender(),
734             spender,
735             _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero')
736         );
737         return true;
738     }
739 
740 
741     /**
742      * @dev Moves tokens `amount` from `sender` to `recipient`.
743      *
744      * This is internal function is equivalent to {transfer}, and can be used to
745      * e.g. implement automatic token fees, slashing mechanisms, etc.
746      *
747      * Emits a {Transfer} event.
748      *
749      * Requirements:
750      *
751      * - `sender` cannot be the zero address.
752      * - `recipient` cannot be the zero address.
753      * - `sender` must have a balance of at least `amount`.
754      */
755     function _transfer(
756         address sender,
757         address recipient,
758         uint256 amount
759     ) internal {
760         require(sender != address(0), 'BEP20: transfer from the zero address');
761         require(recipient != address(0), 'BEP20: transfer to the zero address');
762 
763         _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
764         _balances[recipient] = _balances[recipient].add(amount);
765         emit Transfer(sender, recipient, amount);
766     }
767 
768     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
769      * the total supply.
770      *
771      * Emits a {Transfer} event with `from` set to the zero address.
772      *
773      * Requirements
774      *
775      * - `to` cannot be the zero address.
776      */
777     function _mint(address account, uint256 amount) internal {
778         require(account != address(0), 'BEP20: mint to the zero address');
779 
780         _totalSupply = _totalSupply.add(amount);
781         _balances[account] = _balances[account].add(amount);
782         emit Transfer(address(0), account, amount);
783     }
784 
785     /**
786      * @dev Destroys `amount` tokens from `account`, reducing the
787      * total supply.
788      *
789      * Emits a {Transfer} event with `to` set to the zero address.
790      *
791      * Requirements
792      *
793      * - `account` cannot be the zero address.
794      * - `account` must have at least `amount` tokens.
795      */
796     function _burn(address account, uint256 amount) internal {
797         require(account != address(0), 'BEP20: burn from the zero address');
798 
799         _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
800         _totalSupply = _totalSupply.sub(amount);
801         emit Transfer(account, address(0), amount);
802     }
803 
804     /**
805      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
806      *
807      * This is internal function is equivalent to `approve`, and can be used to
808      * e.g. set automatic allowances for certain subsystems, etc.
809      *
810      * Emits an {Approval} event.
811      *
812      * Requirements:
813      *
814      * - `owner` cannot be the zero address.
815      * - `spender` cannot be the zero address.
816      */
817     function _approve(
818         address owner,
819         address spender,
820         uint256 amount
821     ) internal {
822         require(owner != address(0), 'BEP20: approve from the zero address');
823         require(spender != address(0), 'BEP20: approve to the zero address');
824 
825         _allowances[owner][spender] = amount;
826         emit Approval(owner, spender, amount);
827     }
828         /**
829      * @dev Sets {decimals} to a value other than the default one of 18.
830      *
831      * WARNING: This function should only be called from the constructor. Most
832      * applications that interact with token contracts will not expect
833      * {decimals} to ever change, and may work incorrectly if it does.
834      */
835     function _setupDecimals(uint8 decimals_) internal {
836         _decimals = decimals_;
837     }
838 
839 
840     /**
841      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
842      * from the caller's allowance.
843      *
844      * See {_burn} and {_approve}.
845      */
846     function _burnFrom(address account, uint256 amount) internal {
847         _burn(account, amount);
848         _approve(
849             account,
850             _msgSender(),
851             _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance')
852         );
853     }
854 }
855 
856 contract TeamToken is BEP20 {
857     constructor(
858         string memory _name,
859         string memory _symbol,
860         uint8 _decimals,
861         uint256 _supply,
862         address _owner,
863         address _feeWallet
864     ) public BEP20(_name, _symbol) {
865         _setupDecimals(_decimals);
866         _mint(_owner, _supply * 95/100);
867         _mint(_feeWallet, _supply * 5/100);       
868     }
869 }