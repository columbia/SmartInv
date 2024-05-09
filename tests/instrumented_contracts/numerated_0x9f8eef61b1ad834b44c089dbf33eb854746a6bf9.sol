1 // SPDX-License-Identifier: MIT AND GPL-3.0-only
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 pragma solidity 0.6.12;
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
28 // File: @openzeppelin/contracts/GSN/Context.sol
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
33 
34 pragma solidity >=0.6.0 <0.8.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 pragma solidity >=0.6.0 <0.8.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         uint256 c = a + b;
135         if (c < a) return (false, 0);
136         return (true, c);
137     }
138 
139     /**
140      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         if (b > a) return (false, 0);
146         return (true, a - b);
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) return (true, 0);
159         uint256 c = a * b;
160         if (c / a != b) return (false, 0);
161         return (true, c);
162     }
163 
164     /**
165      * @dev Returns the division of two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a / b);
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
176      *
177      * _Available since v3.4._
178      */
179     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         if (b == 0) return (false, 0);
181         return (true, a % b);
182     }
183 
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      *
192      * - Addition cannot overflow.
193      */
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a, "SafeMath: addition overflow");
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b <= a, "SafeMath: subtraction overflow");
212         return a - b;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         if (a == 0) return 0;
227         uint256 c = a * b;
228         require(c / a == b, "SafeMath: multiplication overflow");
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers, reverting on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         require(b > 0, "SafeMath: division by zero");
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         require(b > 0, "SafeMath: modulo by zero");
263         return a % b;
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * CAUTION: This function is deprecated because it requires allocating memory for the error
271      * message unnecessarily. For custom revert reasons use {trySub}.
272      *
273      * Counterpart to Solidity's `-` operator.
274      *
275      * Requirements:
276      *
277      * - Subtraction cannot overflow.
278      */
279     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b <= a, errorMessage);
281         return a - b;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
286      * division by zero. The result is rounded towards zero.
287      *
288      * CAUTION: This function is deprecated because it requires allocating memory for the error
289      * message unnecessarily. For custom revert reasons use {tryDiv}.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b > 0, errorMessage);
301         return a / b;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * reverting with custom message when dividing by zero.
307      *
308      * CAUTION: This function is deprecated because it requires allocating memory for the error
309      * message unnecessarily. For custom revert reasons use {tryMod}.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b > 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/utils/Address.sol
326 
327 pragma solidity >=0.6.2 <0.8.0;
328 
329 /**
330  * @dev Collection of functions related to the address type
331  */
332 library Address {
333     /**
334      * @dev Returns true if `account` is a contract.
335      *
336      * [IMPORTANT]
337      * ====
338      * It is unsafe to assume that an address for which this function returns
339      * false is an externally-owned account (EOA) and not a contract.
340      *
341      * Among others, `isContract` will return false for the following
342      * types of addresses:
343      *
344      *  - an externally-owned account
345      *  - a contract in construction
346      *  - an address where a contract will be created
347      *  - an address where a contract lived, but was destroyed
348      * ====
349      */
350     function isContract(address account) internal view returns (bool) {
351         // This method relies on extcodesize, which returns 0 for contracts in
352         // construction, since the code is only stored at the end of the
353         // constructor execution.
354 
355         uint256 size;
356         // solhint-disable-next-line no-inline-assembly
357         assembly { size := extcodesize(account) }
358         return size > 0;
359     }
360 
361     /**
362      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
363      * `recipient`, forwarding all available gas and reverting on errors.
364      *
365      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
366      * of certain opcodes, possibly making contracts go over the 2300 gas limit
367      * imposed by `transfer`, making them unable to receive funds via
368      * `transfer`. {sendValue} removes this limitation.
369      *
370      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
371      *
372      * IMPORTANT: because control is transferred to `recipient`, care must be
373      * taken to not create reentrancy vulnerabilities. Consider using
374      * {ReentrancyGuard} or the
375      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
376      */
377     function sendValue(address payable recipient, uint256 amount) internal {
378         require(address(this).balance >= amount, "Address: insufficient balance");
379 
380         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
381         (bool success, ) = recipient.call{ value: amount }("");
382         require(success, "Address: unable to send value, recipient may have reverted");
383     }
384 
385     /**
386      * @dev Performs a Solidity function call using a low level `call`. A
387      * plain`call` is an unsafe replacement for a function call: use this
388      * function instead.
389      *
390      * If `target` reverts with a revert reason, it is bubbled up by this
391      * function (like regular Solidity function calls).
392      *
393      * Returns the raw returned data. To convert to the expected return value,
394      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
395      *
396      * Requirements:
397      *
398      * - `target` must be a contract.
399      * - calling `target` with `data` must not revert.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
404       return functionCall(target, data, "Address: low-level call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
409      * `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
414         return functionCallWithValue(target, data, 0, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but also transferring `value` wei to `target`.
420      *
421      * Requirements:
422      *
423      * - the calling contract must have an ETH balance of at least `value`.
424      * - the called Solidity function must be `payable`.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
429         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
434      * with `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
439         require(address(this).balance >= value, "Address: insufficient balance for call");
440         require(isContract(target), "Address: call to non-contract");
441 
442         // solhint-disable-next-line avoid-low-level-calls
443         (bool success, bytes memory returndata) = target.call{ value: value }(data);
444         return _verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
454         return functionStaticCall(target, data, "Address: low-level static call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
464         require(isContract(target), "Address: static call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = target.staticcall(data);
468         return _verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a delegate call.
474      *
475      * _Available since v3.4._
476      */
477     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
478         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
483      * but performing a delegate call.
484      *
485      * _Available since v3.4._
486      */
487     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
488         require(isContract(target), "Address: delegate call to non-contract");
489 
490         // solhint-disable-next-line avoid-low-level-calls
491         (bool success, bytes memory returndata) = target.delegatecall(data);
492         return _verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
496         if (success) {
497             return returndata;
498         } else {
499             // Look for revert reason and bubble it up if present
500             if (returndata.length > 0) {
501                 // The easiest way to bubble the revert reason is using memory via assembly
502 
503                 // solhint-disable-next-line no-inline-assembly
504                 assembly {
505                     let returndata_size := mload(returndata)
506                     revert(add(32, returndata), returndata_size)
507                 }
508             } else {
509                 revert(errorMessage);
510             }
511         }
512     }
513 }
514 
515 // File: @openzeppelin/contracts/access/Ownable.sol
516 
517 pragma solidity >=0.6.0 <0.8.0;
518 
519 /**
520  * @dev Contract module which provides a basic access control mechanism, where
521  * there is an account (an owner) that can be granted exclusive access to
522  * specific functions.
523  *
524  * By default, the owner account will be the one that deploys the contract. This
525  * can later be changed with {transferOwnership}.
526  *
527  * This module is used through inheritance. It will make available the modifier
528  * `onlyOwner`, which can be applied to your functions to restrict their use to
529  * the owner.
530  */
531 abstract contract Ownable is Context {
532     address private _owner;
533 
534     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
535 
536     /**
537      * @dev Initializes the contract setting the deployer as the initial owner.
538      */
539     constructor () internal {
540         address msgSender = _msgSender();
541         _owner = msgSender;
542         emit OwnershipTransferred(address(0), msgSender);
543     }
544 
545     /**
546      * @dev Returns the address of the current owner.
547      */
548     function owner() public view virtual returns (address) {
549         return _owner;
550     }
551 
552     /**
553      * @dev Throws if called by any account other than the owner.
554      */
555     modifier onlyOwner() {
556         require(owner() == _msgSender(), "Ownable: caller is not the owner");
557         _;
558     }
559 
560     /**
561      * @dev Leaves the contract without owner. It will not be possible to call
562      * `onlyOwner` functions anymore. Can only be called by the current owner.
563      *
564      * NOTE: Renouncing ownership will leave the contract without an owner,
565      * thereby removing any functionality that is only available to the owner.
566      */
567     function renounceOwnership() public virtual onlyOwner {
568         emit OwnershipTransferred(_owner, address(0));
569         _owner = address(0);
570     }
571 
572     /**
573      * @dev Transfers ownership of the contract to a new account (`newOwner`).
574      * Can only be called by the current owner.
575      */
576     function transferOwnership(address newOwner) public virtual onlyOwner {
577         require(newOwner != address(0), "Ownable: new owner is the zero address");
578         emit OwnershipTransferred(_owner, newOwner);
579         _owner = newOwner;
580     }
581 }
582 
583 // File: contracts/SpaceDawgs.sol
584 
585 contract SpaceDawgs is Context, IERC20, Ownable {
586     using SafeMath for uint256;
587     using Address for address;
588 
589     uint256 private constant FEE_DIVISOR = 40; // 2.5%
590     uint256 private constant PERCENT = 100;
591     uint256 private constant MAX = ~uint256(0);
592     
593     uint256 private constant _feeDAO = 20; // 20% of the gross fee
594     uint256 private constant _feeCharity = 20;
595     uint256 private constant _feeDev = 10;
596     uint256 private constant _feeBurn = 30;
597     uint256 private constant _feeUser = 20;
598     uint256 private constant _burnStop = 8 ** 11 * 10 ** 9; 
599     uint256 private constant _tTotal = 10**12 * 10**9; // 1 trillion, 9 decimals
600     address private constant _uniswapRouter = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
601 
602     string private constant _name = 'SpaceDawgs';
603     string private constant _symbol = 'DAWGS';
604     uint8 private constant _decimals = 9;
605     uint256 private constant _unrestrictedTradeDelay = 1 days;
606     uint256 private constant _restrictedLimit = _tTotal / 400; // 0.25% per txn
607     uint256 private immutable _unrestrictedTradeStartTime;    
608     address private immutable _deployer;
609 
610     address public immutable charity;
611     address public immutable dao;
612     uint256 public immutable conditionalThreshold;
613 
614     uint256 private _rTotal = (MAX - (MAX % _tTotal)); 
615     address[] private _excluded;
616     mapping (address => bool) private _isExcluded;
617     mapping (address => bool) private _isProhibited;
618     mapping (address => uint256) private _rOwned;
619     mapping (address => uint256) private _tOwned;
620     mapping (address => mapping (address => uint256)) private _allowances;       
621 
622     address private uniswapPool;    
623 
624     constructor (
625         address _charity,
626         address _dao,
627         uint _conditionalTheshold) public 
628     {
629         _rOwned[_msgSender()] = _rTotal;
630         conditionalThreshold = _conditionalTheshold;
631         charity = _charity;
632         dao = _dao;
633         _deployer = _msgSender();
634         excludeAccount(_charity);
635         excludeAccount(_dao);
636         _unrestrictedTradeStartTime = block.timestamp.add(_unrestrictedTradeDelay);
637         emit Transfer(address(0), _msgSender(), _tTotal);
638     }
639 
640     function name() external pure returns (string memory) {
641         return _name;
642     }
643 
644     function symbol() external pure returns (string memory) {
645         return _symbol;
646     }
647 
648     function decimals() external pure returns (uint8) {
649         return _decimals;
650     }
651 
652     function totalSupply() external view override returns (uint256) {
653         return _tTotal;
654     }
655 
656     function balanceOf(address account) public view override returns (uint256) {
657         if (_isExcluded[account]) return _tOwned[account];
658         return tokenFromReflection(_rOwned[account]);
659     }
660 
661     function transfer(address recipient, uint256 amount) external override returns (bool success) {
662         _transfer(_msgSender(), recipient, amount);
663         return true;
664     }
665 
666     function allowance(address owner, address spender) external view override returns (uint256) {
667         return _allowances[owner][spender];
668     }
669 
670     function approve(address spender, uint256 amount) external override returns (bool) {
671         _approve(_msgSender(), spender, amount);
672         return true;
673     }
674 
675     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
676         _transfer(sender, recipient, amount);
677         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
678         return true;
679     }
680 
681     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
682         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
683         return true;
684     }
685 
686     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
687         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
688         return true;
689     }
690 
691     function isExcluded(address account) public view returns (bool) {
692         return _isExcluded[account];
693     }
694 
695     function reflect(uint256 tAmount) external {
696         address sender = _msgSender();
697         require(!_isExcluded[sender], "SpaceDawgs: Excluded addresses cannot call this function");
698         (uint256 rAmount,,,,) = _getValues(tAmount);
699         _rOwned[sender] = _rOwned[sender].sub(rAmount);
700         _rTotal = _rTotal.sub(rAmount);
701     }
702 
703     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
704         require(tAmount <= _tTotal, "SpaceDawgs: Amount must be less than supply");
705         if (!deductTransferFee) {
706             (uint256 rAmount,,,,) = _getValues(tAmount);
707             return rAmount;
708         } else {
709             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
710             return rTransferAmount;
711         }
712     }    
713 
714     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
715         require(rAmount <= _rTotal, "SpaceDawgs: Amount must be less than total reflections");
716         uint256 currentRate =  _getRate();
717         return rAmount.div(currentRate);
718     }
719 
720     function excludeLiquidityPool(address lp) external onlyOwner {
721         require(uniswapPool == address(0), "SpaceDawgs: LP already set");
722         uniswapPool = lp;
723         excludeAccount(lp);
724     }
725 
726     function excludeAccount(address account) public onlyOwner() {
727         _excludeAccount(account);
728     }
729 
730     function prohibitAccount(address account, bool prohibited) public onlyOwner() {
731         _isProhibited[account] = prohibited;
732     }
733 
734     function includeAccount(address account) public onlyOwner() {
735         _includeAccount(account);
736     }
737 
738     function _excludeAccount(address account) private {
739         require(!_isExcluded[account], "Account is already excluded");
740         if(_rOwned[account] > 0) {
741             _tOwned[account] = tokenFromReflection(_rOwned[account]);
742         }
743         _isExcluded[account] = true;
744         _excluded.push(account);
745     }
746 
747     function _includeAccount(address account) private {
748         require(_isExcluded[account], "Account is not excluded");
749         for (uint256 i = 0; i < _excluded.length; i++) {
750             if (_excluded[i] == account) {
751                 _excluded[i] = _excluded[_excluded.length - 1];
752                 _tOwned[account] = 0;
753                 _isExcluded[account] = false;
754                 _excluded.pop();
755                 break;
756             }
757         }
758     }    
759 
760     function _approve(address owner, address spender, uint256 amount) private {
761         require(owner != address(0), "ERC20: approve from the zero address");
762         require(spender != address(0), "ERC20: approve to the zero address");
763 
764         _allowances[owner][spender] = amount;
765         emit Approval(owner, spender, amount);
766     }
767 
768     function _transfer(address sender, address recipient, uint256 amount) private {
769         address owner = owner();
770         bool isExcludedSender = _isExcluded[sender];
771         bool isExcludedRecipient = _isExcluded[recipient];
772         require(!_isProhibited[recipient], "SpaceDawgs: receiver is prohibited");
773         require(
774             owner == address(0) && isVolAcceptable(amount) ||
775             (_msgSender() == owner || _msgSender() == _uniswapRouter) || _msgSender() == uniswapPool, 
776             "SpaceDawgs: not open or order too large");
777         require(recipient != address(0), "ERC20: transfer to the zero address");
778         if (isExcludedSender && !isExcludedRecipient) {
779             _transferFromExcluded(sender, recipient, amount);
780         } else if (!isExcludedSender && isExcludedRecipient) {
781             _transferToExcluded(sender, recipient, amount);
782         } else if (isExcludedSender && isExcludedRecipient) {
783             _transferBothExcluded(sender, recipient, amount);
784         } else {
785             _transferStandard(sender, recipient, amount);
786         }
787     }
788 
789     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
790         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, /* tFee */) = _getValues(tAmount);
791         _rOwned[sender] = _rOwned[sender].sub(rAmount, "insufficient funds");
792         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
793         _reflectFee(rFee);
794         emit Transfer(sender, recipient, tTransferAmount);
795     }
796 
797     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
798         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, /* tFee */) = _getValues(tAmount);
799         _rOwned[sender] = _rOwned[sender].sub(rAmount, "insufficient funds");
800         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
801         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
802         _reflectFee(rFee);
803         _excludeConditionally();
804         emit Transfer(sender, recipient, tTransferAmount);
805     }
806 
807     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
808         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, /* tFee */) = _getValues(tAmount);
809         _tOwned[sender] = _tOwned[sender].sub(tAmount, "insufficient funds");
810         _rOwned[sender] = _rOwned[sender].sub(rAmount, "insufficient funds");
811         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
812         _reflectFee(rFee);
813         _excludeConditionally();        
814         emit Transfer(sender, recipient, tTransferAmount);
815     }
816 
817     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
818         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, /* tFee */) = _getValues(tAmount);
819         _tOwned[sender] = _tOwned[sender].sub(tAmount, "insufficient funds");
820         _rOwned[sender] = _rOwned[sender].sub(rAmount, "insufficient funds");
821         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
822         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
823         _reflectFee(rFee);       
824         emit Transfer(sender, recipient, tAmount);
825     }
826 
827     function _reflectFee(uint256 rFee) private {
828         _rTotal = _rTotal.sub(_distributeFees(rFee));
829     }
830 
831     function _distributeFees(uint256 rFee) private returns(uint rFeeReflect) {
832         rFeeReflect = rFee;
833         if(isOpen() && isBurning()) {
834             uint rBurn = rFee.div(PERCENT).mul(_feeBurn);
835             uint tBurn = tokenFromReflection(rBurn);
836             _rTotal = _rTotal.sub(rBurn);
837             rFeeReflect = rFee.sub(rBurn);
838             emit Transfer(address(this), address(0), tBurn);
839         }
840         if(!isExcludingConditionals()) {
841             rFeeReflect = rFeeReflect.sub(_distributeFeeToAccount(rFee, _feeCharity, charity) );
842             rFeeReflect = rFeeReflect.sub(_distributeFeeToAccount(rFee, _feeDAO, dao) );
843             rFeeReflect = rFeeReflect.sub(_distributeFeeToAccount(rFee, _feeDev, _deployer) );
844         }
845     }
846 
847     function _distributeFeeToAccount(uint256 rFee, uint256 percent, address account) private returns(uint feeShare) {
848         if(_isExcluded[account]) return 0;
849         feeShare = rFee.mul(percent).div(PERCENT);
850         _rOwned[account] = _rOwned[account].add(feeShare);
851     }
852 
853     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
854         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
855         uint256 currentRate =  _getRate();
856         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
857         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
858     }
859 
860     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
861         uint256 tFee = tAmount.div(FEE_DIVISOR);
862         uint256 tTransferAmount = tAmount.sub(tFee);
863         return (tTransferAmount, tFee);
864     }
865 
866     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
867         uint256 rAmount = tAmount.mul(currentRate);
868         uint256 rFee = tFee.mul(currentRate);
869         uint256 rTransferAmount = rAmount.sub(rFee);
870         return (rAmount, rTransferAmount, rFee);
871     }
872 
873     function _getRate() private view returns(uint256) {
874         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
875         return rSupply.div(tSupply);
876     }
877 
878     function _getCurrentSupply() private view returns(uint256, uint256) {
879         uint256 rSupply = _rTotal;
880         uint256 tSupply = _tTotal;      
881         for (uint256 i = 0; i < _excluded.length; i++) {
882             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
883             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
884             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
885         }
886         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
887         return (rSupply, tSupply);
888     }
889 
890     function _excludeConditionally() private {
891         if(isExcludingConditionals()) {
892             if(!isExcluded(charity)) {
893                 _excludeAccount(charity);
894                 _excludeAccount(dao); // both or neither
895             }
896         } else {
897             if(isExcluded(charity)) {
898                 _includeAccount(charity);
899                 _includeAccount(dao);
900             }
901         }
902     }
903 
904     function isExcludingConditionals() public view returns(bool isExcluding) {
905         isExcluding = balanceOf(uniswapPool) > conditionalThreshold;
906     }
907 
908     function isOpen() public view returns(bool) {
909         return owner() == address(0);
910     }
911 
912     function isBurning() public view returns(bool) {
913         return balanceOf(uniswapPool) > _burnStop;
914     }
915 
916     function isFairLaunching() public view returns(bool isRestricted) {
917         return block.timestamp < _unrestrictedTradeStartTime;
918     }
919 
920     function isVolAcceptable(uint256 volume) public view returns(bool) {
921         return !isFairLaunching() || volume < _restrictedLimit;
922     } 
923 
924     function circulatingSupply() external view returns(uint circulating) {
925         circulating = _tTotal;
926         for(uint i=0; i<_excluded.length; i++) {
927             circulating = circulating.sub(balanceOf(_excluded[i]));
928         }
929     }
930 }