1 /*
2 ██████╗░██████╗░░█████╗░░░░░░██╗███████╗░█████╗░████████╗  ██████╗░███████╗██████╗░
3 ██╔══██╗██╔══██╗██╔══██╗░░░░░██║██╔════╝██╔══██╗╚══██╔══╝  ██╔══██╗██╔════╝██╔══██╗
4 ██████╔╝██████╔╝██║░░██║░░░░░██║█████╗░░██║░░╚═╝░░░██║░░░  ██████╔╝█████╗░░██║░░██║
5 ██╔═══╝░██╔══██╗██║░░██║██╗░░██║██╔══╝░░██║░░██╗░░░██║░░░  ██╔══██╗██╔══╝░░██║░░██║
6 ██║░░░░░██║░░██║╚█████╔╝╚█████╔╝███████╗╚█████╔╝░░░██║░░░  ██║░░██║███████╗██████╔╝
7 ╚═╝░░░░░╚═╝░░╚═╝░╚════╝░░╚════╝░╚══════╝░╚════╝░░░░╚═╝░░░  ╚═╝░░╚═╝╚══════╝╚═════╝░
8 */
9 
10 // SPDX-License-Identifier: MIT
11 
12 //GOVERN,YIELD,#CLIFF
13 //https://t.me/Cliffordinuofficial
14 //https://cliffordinu.io/
15 
16 pragma solidity >=0.4.0;
17 
18 /*
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with GSN meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 contract Context {
29     // Empty internal constructor, to prevent people from mistakenly deploying
30     // an instance of this contract, which should be used via inheritance.
31     constructor() internal {}
32 
33     function _msgSender() internal view returns (address payable) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view returns (bytes memory) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 pragma solidity >=0.4.0;
44 
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() internal {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
84         _;
85     }
86 
87     /**
88      * @dev Leaves the contract without owner. It will not be possible to call
89      * `onlyOwner` functions anymore. Can only be called by the current owner.
90      *
91      * NOTE: Renouncing ownership will leave the contract without an owner,
92      * thereby removing any functionality that is only available to the owner.
93      */
94     function renounceOwnership() public onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Can only be called by the current owner.
102      */
103     function transferOwnership(address newOwner) public onlyOwner {
104         _transferOwnership(newOwner);
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      */
110     function _transferOwnership(address newOwner) internal {
111         require(newOwner != address(0), 'Ownable: new owner is the zero address');
112         emit OwnershipTransferred(_owner, newOwner);
113         _owner = newOwner;
114     }
115 }
116 
117 pragma solidity >=0.4.0;
118 
119 interface IERC20 {
120     /**
121      * @dev Returns the amount of tokens in existence.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     /**
126      * @dev Returns the token decimals.
127      */
128     function decimals() external view returns (uint8);
129 
130     /**
131      * @dev Returns the token symbol.
132      */
133     function symbol() external view returns (string memory);
134 
135     /**
136      * @dev Returns the token name.
137      */
138     function name() external view returns (string memory);
139 
140     /**
141      * @dev Returns the bep token owner.
142      */
143     function getOwner() external view returns (address);
144 
145     /**
146      * @dev Returns the amount of tokens owned by `account`.
147      */
148     function balanceOf(address account) external view returns (uint256);
149 
150     /**
151      * @dev Moves `amount` tokens from the caller's account to `recipient`.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transfer(address recipient, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Returns the remaining number of tokens that `spender` will be
161      * allowed to spend on behalf of `owner` through {transferFrom}. This is
162      * zero by default.
163      *
164      * This value changes when {approve} or {transferFrom} are called.
165      */
166     function allowance(address _owner, address spender) external view returns (uint256);
167 
168     /**
169      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * IMPORTANT: Beware that changing an allowance with this method brings the risk
174      * that someone may use both the old and the new allowance by unfortunate
175      * transaction ordering. One possible solution to mitigate this race
176      * condition is to first reduce the spender's allowance to 0 and set the
177      * desired value afterwards:
178      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179      *
180      * Emits an {Approval} event.
181      */
182     function approve(address spender, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Moves `amount` tokens from `sender` to `recipient` using the
186      * allowance mechanism. `amount` is then deducted from the caller's
187      * allowance.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transferFrom(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) external returns (bool);
198 
199     /**
200      * @dev Emitted when `value` tokens are moved from one account (`from`) to
201      * another (`to`).
202      *
203      * Note that `value` may be zero.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 value);
206 
207     /**
208      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
209      * a call to {approve}. `value` is the new allowance.
210      */
211     event Approval(address indexed owner, address indexed spender, uint256 value);
212 }
213 
214 pragma solidity >=0.4.0;
215 
216 /**
217  * @dev Wrappers over Solidity's arithmetic operations with added overflow
218  * checks.
219  *
220  * Arithmetic operations in Solidity wrap on overflow. This can easily result
221  * in bugs, because programmers usually assume that an overflow raises an
222  * error, which is the standard behavior in high level programming languages.
223  * `SafeMath` restores this intuition by reverting the transaction when an
224  * operation overflows.
225  *
226  * Using this library instead of the unchecked operations eliminates an entire
227  * class of bugs, so it's recommended to use it always.
228  */
229 library SafeMath {
230     /**
231      * @dev Returns the addition of two unsigned integers, reverting on
232      * overflow.
233      *
234      * Counterpart to Solidity's `+` operator.
235      *
236      * Requirements:
237      *
238      * - Addition cannot overflow.
239      */
240     function add(uint256 a, uint256 b) internal pure returns (uint256) {
241         uint256 c = a + b;
242         require(c >= a, 'SafeMath: addition overflow');
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the subtraction of two unsigned integers, reverting on
249      * overflow (when the result is negative).
250      *
251      * Counterpart to Solidity's `-` operator.
252      *
253      * Requirements:
254      *
255      * - Subtraction cannot overflow.
256      */
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         return sub(a, b, 'SafeMath: subtraction overflow');
259     }
260 
261     /**
262      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
263      * overflow (when the result is negative).
264      *
265      * Counterpart to Solidity's `-` operator.
266      *
267      * Requirements:
268      *
269      * - Subtraction cannot overflow.
270      */
271     function sub(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         require(b <= a, errorMessage);
277         uint256 c = a - b;
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the multiplication of two unsigned integers, reverting on
284      * overflow.
285      *
286      * Counterpart to Solidity's `*` operator.
287      *
288      * Requirements:
289      *
290      * - Multiplication cannot overflow.
291      */
292     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
293         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
294         // benefit is lost if 'b' is also tested.
295         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
296         if (a == 0) {
297             return 0;
298         }
299 
300         uint256 c = a * b;
301         require(c / a == b, 'SafeMath: multiplication overflow');
302 
303         return c;
304     }
305 
306     /**
307      * @dev Returns the integer division of two unsigned integers. Reverts on
308      * division by zero. The result is rounded towards zero.
309      *
310      * Counterpart to Solidity's `/` operator. Note: this function uses a
311      * `revert` opcode (which leaves remaining gas untouched) while Solidity
312      * uses an invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function div(uint256 a, uint256 b) internal pure returns (uint256) {
319         return div(a, b, 'SafeMath: division by zero');
320     }
321 
322     /**
323      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
324      * division by zero. The result is rounded towards zero.
325      *
326      * Counterpart to Solidity's `/` operator. Note: this function uses a
327      * `revert` opcode (which leaves remaining gas untouched) while Solidity
328      * uses an invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function div(
335         uint256 a,
336         uint256 b,
337         string memory errorMessage
338     ) internal pure returns (uint256) {
339         require(b > 0, errorMessage);
340         uint256 c = a / b;
341         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
342 
343         return c;
344     }
345 
346     /**
347      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
348      * Reverts when dividing by zero.
349      *
350      * Counterpart to Solidity's `%` operator. This function uses a `revert`
351      * opcode (which leaves remaining gas untouched) while Solidity uses an
352      * invalid opcode to revert (consuming all remaining gas).
353      *
354      * Requirements:
355      *
356      * - The divisor cannot be zero.
357      */
358     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
359         return mod(a, b, 'SafeMath: modulo by zero');
360     }
361 
362     /**
363      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
364      * Reverts with custom message when dividing by zero.
365      *
366      * Counterpart to Solidity's `%` operator. This function uses a `revert`
367      * opcode (which leaves remaining gas untouched) while Solidity uses an
368      * invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      *
372      * - The divisor cannot be zero.
373      */
374     function mod(
375         uint256 a,
376         uint256 b,
377         string memory errorMessage
378     ) internal pure returns (uint256) {
379         require(b != 0, errorMessage);
380         return a % b;
381     }
382 
383     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
384         z = x < y ? x : y;
385     }
386 
387     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
388     function sqrt(uint256 y) internal pure returns (uint256 z) {
389         if (y > 3) {
390             z = y;
391             uint256 x = y / 2 + 1;
392             while (x < z) {
393                 z = x;
394                 x = (y / x + x) / 2;
395             }
396         } else if (y != 0) {
397             z = 1;
398         }
399     }
400 }
401 
402 pragma solidity ^0.6.2;
403 
404 /**
405  * @dev Collection of functions related to the address type
406  */
407 library Address {
408     /**
409      * @dev Returns true if `account` is a contract.
410      *
411      * [IMPORTANT]
412      * ====
413      * It is unsafe to assume that an address for which this function returns
414      * false is an externally-owned account (EOA) and not a contract.
415      *
416      * Among others, `isContract` will return false for the following
417      * types of addresses:
418      *
419      *  - an externally-owned account
420      *  - a contract in construction
421      *  - an address where a contract will be created
422      *  - an address where a contract lived, but was destroyed
423      * ====
424      */
425     function isContract(address account) internal view returns (bool) {
426         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
427         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
428         // for accounts without code, i.e. `keccak256('')`
429         bytes32 codehash;
430         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
431         // solhint-disable-next-line no-inline-assembly
432         assembly {
433             codehash := extcodehash(account)
434         }
435         return (codehash != accountHash && codehash != 0x0);
436     }
437 
438     /**
439      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
440      * `recipient`, forwarding all available gas and reverting on errors.
441      *
442      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
443      * of certain opcodes, possibly making contracts go over the 2300 gas limit
444      * imposed by `transfer`, making them unable to receive funds via
445      * `transfer`. {sendValue} removes this limitation.
446      *
447      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
448      *
449      * IMPORTANT: because control is transferred to `recipient`, care must be
450      * taken to not create reentrancy vulnerabilities. Consider using
451      * {ReentrancyGuard} or the
452      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
453      */
454     function sendValue(address payable recipient, uint256 amount) internal {
455         require(address(this).balance >= amount, 'Address: insufficient balance');
456 
457         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
458         (bool success, ) = recipient.call{value: amount}('');
459         require(success, 'Address: unable to send value, recipient may have reverted');
460     }
461 
462     /**
463      * @dev Performs a Solidity function call using a low level `call`. A
464      * plain`call` is an unsafe replacement for a function call: use this
465      * function instead.
466      *
467      * If `target` reverts with a revert reason, it is bubbled up by this
468      * function (like regular Solidity function calls).
469      *
470      * Returns the raw returned data. To convert to the expected return value,
471      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
472      *
473      * Requirements:
474      *
475      * - `target` must be a contract.
476      * - calling `target` with `data` must not revert.
477      *
478      * _Available since v3.1._
479      */
480     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
481         return functionCall(target, data, 'Address: low-level call failed');
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
486      * `errorMessage` as a fallback revert reason when `target` reverts.
487      *
488      * _Available since v3.1._
489      */
490     function functionCall(
491         address target,
492         bytes memory data,
493         string memory errorMessage
494     ) internal returns (bytes memory) {
495         return _functionCallWithValue(target, data, 0, errorMessage);
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but also transferring `value` wei to `target`.
501      *
502      * Requirements:
503      *
504      * - the calling contract must have an ETH balance of at least `value`.
505      * - the called Solidity function must be `payable`.
506      *
507      * _Available since v3.1._
508      */
509     function functionCallWithValue(
510         address target,
511         bytes memory data,
512         uint256 value
513     ) internal returns (bytes memory) {
514         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
519      * with `errorMessage` as a fallback revert reason when `target` reverts.
520      *
521      * _Available since v3.1._
522      */
523     function functionCallWithValue(
524         address target,
525         bytes memory data,
526         uint256 value,
527         string memory errorMessage
528     ) internal returns (bytes memory) {
529         require(address(this).balance >= value, 'Address: insufficient balance for call');
530         return _functionCallWithValue(target, data, value, errorMessage);
531     }
532 
533     function _functionCallWithValue(
534         address target,
535         bytes memory data,
536         uint256 weiValue,
537         string memory errorMessage
538     ) private returns (bytes memory) {
539         require(isContract(target), 'Address: call to non-contract');
540 
541         // solhint-disable-next-line avoid-low-level-calls
542         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
543         if (success) {
544             return returndata;
545         } else {
546             // Look for revert reason and bubble it up if present
547             if (returndata.length > 0) {
548                 // The easiest way to bubble the revert reason is using memory via assembly
549 
550                 // solhint-disable-next-line no-inline-assembly
551                 assembly {
552                     let returndata_size := mload(returndata)
553                     revert(add(32, returndata), returndata_size)
554                 }
555             } else {
556                 revert(errorMessage);
557             }
558         }
559     }
560 }
561 
562 pragma solidity >=0.4.0;
563 
564 
565 
566 
567 
568 
569 /**
570  * @dev Implementation of the {IERC20} interface.
571  *
572  * This implementation is agnostic to the way tokens are created. This means
573  * that a supply mechanism has to be added in a derived contract using {_mint}.
574  * For a generic mechanism see {ERC20PresetMinterPauser}.
575  *
576  * TIP: For a detailed writeup see our guide
577  * https://forum.zeppelin.solutions/t/how-to-implement-ERC20-supply-mechanisms/226[How
578  * to implement supply mechanisms].
579  *
580  * We have followed general OpenZeppelin guidelines: functions revert instead
581  * of returning `false` on failure. This behavior is nonetheless conventional
582  * and does not conflict with the expectations of ERC20 applications.
583  *
584  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
585  * This allows applications to reconstruct the allowance for all accounts just
586  * by listening to said events. Other implementations of the EIP may not emit
587  * these events, as it isn't required by the specification.
588  *
589  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
590  * functions have been added to mitigate the well-known issues around setting
591  * allowances. See {IERC20-approve}.
592  */
593 contract ERC20 is Context, IERC20, Ownable {
594     using SafeMath for uint256;
595     using Address for address;
596 
597     mapping(address => uint256) private _balances;
598 
599     mapping(address => mapping(address => uint256)) private _allowances;
600 
601     uint256 private _totalSupply;
602 
603     string private _name;
604     string private _symbol;
605     uint8 private _decimals;
606 
607     /**
608      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
609      * a default value of 18.
610      *
611      * To select a different value for {decimals}, use {_setupDecimals}.
612      *
613      * All three of these values are immutable: they can only be set once during
614      * construction.
615      */
616     constructor(string memory name, string memory symbol, uint8 decimals) public {
617         _name = name;
618         _symbol = symbol;
619         _decimals = decimals;
620     }
621 
622     /**
623      * @dev Returns the bep token owner.
624      */
625     function getOwner() external override view returns (address) {
626         return owner();
627     }
628 
629     /**
630      * @dev Returns the token name.
631      */
632     function name() public override view returns (string memory) {
633         return _name;
634     }
635 
636     /**
637      * @dev Returns the token decimals.
638      */
639     function decimals() public override view returns (uint8) {
640         return _decimals;
641     }
642 
643     /**
644      * @dev Returns the token symbol.
645      */
646     function symbol() public override view returns (string memory) {
647         return _symbol;
648     }
649 
650     /**
651      * @dev See {ERC20-totalSupply}.
652      */
653     function totalSupply() public override view returns (uint256) {
654         return _totalSupply;
655     }
656 
657     /**
658      * @dev See {ERC20-balanceOf}.
659      */
660     function balanceOf(address account) public override view returns (uint256) {
661         return _balances[account];
662     }
663 
664     /**
665      * @dev See {ERC20-transfer}.
666      *
667      * Requirements:
668      *
669      * - `recipient` cannot be the zero address.
670      * - the caller must have a balance of at least `amount`.
671      */
672     function transfer(address recipient, uint256 amount) public override returns (bool) {
673         _transfer(_msgSender(), recipient, amount);
674         return true;
675     }
676 
677     /**
678      * @dev See {ERC20-allowance}.
679      */
680     function allowance(address owner, address spender) public override view returns (uint256) {
681         return _allowances[owner][spender];
682     }
683 
684     /**
685      * @dev See {ERC20-approve}.
686      *
687      * Requirements:
688      *
689      * - `spender` cannot be the zero address.
690      */
691     function approve(address spender, uint256 amount) public override returns (bool) {
692         _approve(_msgSender(), spender, amount);
693         return true;
694     }
695 
696     /**
697      * @dev See {ERC20-transferFrom}.
698      *
699      * Emits an {Approval} event indicating the updated allowance. This is not
700      * required by the EIP. See the note at the beginning of {ERC20};
701      *
702      * Requirements:
703      * - `sender` and `recipient` cannot be the zero address.
704      * - `sender` must have a balance of at least `amount`.
705      * - the caller must have allowance for `sender`'s tokens of at least
706      * `amount`.
707      */
708     function transferFrom(
709         address sender,
710         address recipient,
711         uint256 amount
712     ) public override returns (bool) {
713         _transfer(sender, recipient, amount);
714         _approve(
715             sender,
716             _msgSender(),
717             _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
718         );
719         return true;
720     }
721 
722     /**
723      * @dev Atomically increases the allowance granted to `spender` by the caller.
724      *
725      * This is an alternative to {approve} that can be used as a mitigation for
726      * problems described in {ERC20-approve}.
727      *
728      * Emits an {Approval} event indicating the updated allowance.
729      *
730      * Requirements:
731      *
732      * - `spender` cannot be the zero address.
733      */
734     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
735         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
736         return true;
737     }
738 
739     /**
740      * @dev Atomically decreases the allowance granted to `spender` by the caller.
741      *
742      * This is an alternative to {approve} that can be used as a mitigation for
743      * problems described in {ERC20-approve}.
744      *
745      * Emits an {Approval} event indicating the updated allowance.
746      *
747      * Requirements:
748      *
749      * - `spender` cannot be the zero address.
750      * - `spender` must have allowance for the caller of at least
751      * `subtractedValue`.
752      */
753     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
754         _approve(
755             _msgSender(),
756             spender,
757             _allowances[_msgSender()][spender].sub(subtractedValue, 'ERC20: decreased allowance below zero')
758         );
759         return true;
760     }
761 
762     /**
763      * @dev Moves tokens `amount` from `sender` to `recipient`.
764      *
765      * This is internal function is equivalent to {transfer}, and can be used to
766      * e.g. implement automatic token fees, slashing mechanisms, etc.
767      *
768      * Emits a {Transfer} event.
769      *
770      * Requirements:
771      *
772      * - `sender` cannot be the zero address.
773      * - `recipient` cannot be the zero address.
774      * - `sender` must have a balance of at least `amount`.
775      */
776     function _transfer(
777         address sender,
778         address recipient,
779         uint256 amount
780     ) internal {
781         require(sender != address(0), 'ERC20: transfer from the zero address');
782         require(recipient != address(0), 'ERC20: transfer to the zero address');
783 
784         _balances[sender] = _balances[sender].sub(amount, 'ERC20: transfer amount exceeds balance');
785         _balances[recipient] = _balances[recipient].add(amount);
786         emit Transfer(sender, recipient, amount);
787     }
788 
789     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
790      * the total supply.
791      *
792      * Emits a {Transfer} event with `from` set to the zero address.
793      *
794      * Requirements
795      *
796      * - `to` cannot be the zero address.
797      */
798     function _mint(address account, uint256 amount) internal {
799         require(account != address(0), 'ERC20: mint to the zero address');
800 
801         _totalSupply = _totalSupply.add(amount);
802         _balances[account] = _balances[account].add(amount);
803         emit Transfer(address(0), account, amount);
804     }
805 
806     /**
807      * @dev Destroys `amount` tokens from `account`, reducing the
808      * total supply.
809      *
810      * Emits a {Transfer} event with `to` set to the zero address.
811      *
812      * Requirements
813      *
814      * - `account` cannot be the zero address.
815      * - `account` must have at least `amount` tokens.
816      */
817     function _burn(address account, uint256 amount) internal {
818         require(account != address(0), 'ERC20: burn from the zero address');
819 
820         _balances[account] = _balances[account].sub(amount, 'ERC20: burn amount exceeds balance');
821         _totalSupply = _totalSupply.sub(amount);
822         emit Transfer(account, address(0), amount);
823     }
824 
825     /**
826      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
827      *
828      * This is internal function is equivalent to `approve`, and can be used to
829      * e.g. set automatic allowances for certain subsystems, etc.
830      *
831      * Emits an {Approval} event.
832      *
833      * Requirements:
834      *
835      * - `owner` cannot be the zero address.
836      * - `spender` cannot be the zero address.
837      */
838     function _approve(
839         address owner,
840         address spender,
841         uint256 amount
842     ) internal {
843         require(owner != address(0), 'ERC20: approve from the zero address');
844         require(spender != address(0), 'ERC20: approve to the zero address');
845 
846         _allowances[owner][spender] = amount;
847         emit Approval(owner, spender, amount);
848     }
849 
850     /**
851      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
852      * from the caller's allowance.
853      *
854      * See {_burn} and {_approve}.
855      */
856     function _burnFrom(address account, uint256 amount) internal {
857         _burn(account, amount);
858         _approve(
859             account,
860             _msgSender(),
861             _allowances[account][_msgSender()].sub(amount, 'ERC20: burn amount exceeds allowance')
862         );
863     }
864 }
865 
866 // File: contracts\MainToken.sol
867 
868 pragma solidity 0.6.12;
869 
870 
871 // MainToken with Governance.
872 contract ProjectRed is ERC20('PRJCT', 'RED', 9) {
873     /// @notice Mint tokens in the constructor
874     constructor(uint256 totalSupply) public {
875 	_mint(msg.sender, totalSupply);
876         _moveDelegates(address(0), _delegates[msg.sender], totalSupply);
877     }
878 
879     // Copied and modified from YAM code:
880     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
881     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
882     // Which is copied and modified from COMPOUND:
883     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
884 
885     /// @dev A record of each accounts delegate
886     mapping (address => address) internal _delegates;
887 
888     /// @notice A checkpoint for marking number of votes from a given block
889     struct Checkpoint {
890         uint32 fromBlock;
891         uint256 votes;
892     }
893 
894     /// @notice A record of votes checkpoints for each account, by index
895     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
896 
897     /// @notice The number of checkpoints for each account
898     mapping (address => uint32) public numCheckpoints;
899 
900     /// @notice The EIP-712 typehash for the contract's domain
901     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
902 
903     /// @notice The EIP-712 typehash for the delegation struct used by the contract
904     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
905 
906     /// @notice A record of states for signing / validating signatures
907     mapping (address => uint) public nonces;
908 
909       /// @notice An event thats emitted when an account changes its delegate
910     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
911 
912     /// @notice An event thats emitted when a delegate account's vote balance changes
913     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
914 
915     /**
916      * @notice Delegate votes from `msg.sender` to `delegatee`
917      * @param delegator The address to get delegatee for
918      */
919     function delegates(address delegator)
920         external
921         view
922         returns (address)
923     {
924         return _delegates[delegator];
925     }
926 
927    /**
928     * @notice Delegate votes from `msg.sender` to `delegatee`
929     * @param delegatee The address to delegate votes to
930     */
931     function delegate(address delegatee) external {
932         return _delegate(msg.sender, delegatee);
933     }
934 
935     /**
936      * @notice Delegates votes from signatory to `delegatee`
937      * @param delegatee The address to delegate votes to
938      * @param nonce The contract state required to match the signature
939      * @param expiry The time at which to expire the signature
940      * @param v The recovery byte of the signature
941      * @param r Half of the ECDSA signature pair
942      * @param s Half of the ECDSA signature pair
943      */
944     function delegateBySig(
945         address delegatee,
946         uint nonce,
947         uint expiry,
948         uint8 v,
949         bytes32 r,
950         bytes32 s
951     )
952         external
953     {
954         bytes32 domainSeparator = keccak256(
955             abi.encode(
956                 DOMAIN_TYPEHASH,
957                 keccak256(bytes(name())),
958                 getChainId(),
959                 address(this)
960             )
961         );
962 
963         bytes32 structHash = keccak256(
964             abi.encode(
965                 DELEGATION_TYPEHASH,
966                 delegatee,
967                 nonce,
968                 expiry
969             )
970         );
971 
972         bytes32 digest = keccak256(
973             abi.encodePacked(
974                 "\x19\x01",
975                 domainSeparator,
976                 structHash
977             )
978         );
979 
980         address signatory = ecrecover(digest, v, r, s);
981         require(signatory != address(0), "LABIS::delegateBySig: invalid signature");
982         require(nonce == nonces[signatory]++, "LABIS::delegateBySig: invalid nonce");
983         require(now <= expiry, "LABIS::delegateBySig: signature expired");
984         return _delegate(signatory, delegatee);
985     }
986 
987     /**
988      * @notice Gets the current votes balance for `account`
989      * @param account The address to get votes balance
990      * @return The number of current votes for `account`
991      */
992     function getCurrentVotes(address account)
993         external
994         view
995         returns (uint256)
996     {
997         uint32 nCheckpoints = numCheckpoints[account];
998         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
999     }
1000 
1001     /**
1002      * @notice Determine the prior number of votes for an account as of a block number
1003      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1004      * @param account The address of the account to check
1005      * @param blockNumber The block number to get the vote balance at
1006      * @return The number of votes the account had as of the given block
1007      */
1008     function getPriorVotes(address account, uint blockNumber)
1009         external
1010         view
1011         returns (uint256)
1012     {
1013         require(blockNumber < block.number, "LABIS::getPriorVotes: not yet determined");
1014 
1015         uint32 nCheckpoints = numCheckpoints[account];
1016         if (nCheckpoints == 0) {
1017             return 0;
1018         }
1019 
1020         // First check most recent balance
1021         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1022             return checkpoints[account][nCheckpoints - 1].votes;
1023         }
1024 
1025         // Next check implicit zero balance
1026         if (checkpoints[account][0].fromBlock > blockNumber) {
1027             return 0;
1028         }
1029 
1030         uint32 lower = 0;
1031         uint32 upper = nCheckpoints - 1;
1032         while (upper > lower) {
1033             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1034             Checkpoint memory cp = checkpoints[account][center];
1035             if (cp.fromBlock == blockNumber) {
1036                 return cp.votes;
1037             } else if (cp.fromBlock < blockNumber) {
1038                 lower = center;
1039             } else {
1040                 upper = center - 1;
1041             }
1042         }
1043         return checkpoints[account][lower].votes;
1044     }
1045 
1046     function _delegate(address delegator, address delegatee)
1047         internal
1048     {
1049         address currentDelegate = _delegates[delegator];
1050         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying LABISs (not scaled);
1051         _delegates[delegator] = delegatee;
1052 
1053         emit DelegateChanged(delegator, currentDelegate, delegatee);
1054 
1055         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1056     }
1057 
1058     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1059         if (srcRep != dstRep && amount > 0) {
1060             if (srcRep != address(0)) {
1061                 // decrease old representative
1062                 uint32 srcRepNum = numCheckpoints[srcRep];
1063                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1064                 uint256 srcRepNew = srcRepOld.sub(amount);
1065                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1066             }
1067 
1068             if (dstRep != address(0)) {
1069                 // increase new representative
1070                 uint32 dstRepNum = numCheckpoints[dstRep];
1071                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1072                 uint256 dstRepNew = dstRepOld.add(amount);
1073                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1074             }
1075         }
1076     }
1077 
1078     function _writeCheckpoint(
1079         address delegatee,
1080         uint32 nCheckpoints,
1081         uint256 oldVotes,
1082         uint256 newVotes
1083     )
1084         internal
1085     {
1086         uint32 blockNumber = safe32(block.number, "LABIS::_writeCheckpoint: block number exceeds 32 bits");
1087 
1088         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1089             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1090         } else {
1091             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1092             numCheckpoints[delegatee] = nCheckpoints + 1;
1093         }
1094 
1095         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1096     }
1097 
1098     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1099         require(n < 2**32, errorMessage);
1100         return uint32(n);
1101     }
1102 
1103     function getChainId() internal pure returns (uint) {
1104         uint256 chainId;
1105         assembly { chainId := chainid() }
1106         return chainId;
1107     }
1108 }