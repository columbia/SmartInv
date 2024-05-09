1 pragma solidity ^0.8.0;
2 // SPDX-License-Identifier: Unlicensed
3 
4 //  ╭╮╱╱╭━━━┳━━╮╭━━━┳━━━╮╭━━━┳━━━┳━━━┳━━━┳╮╱╱╭━━━╮
5 //  ┃┃╱╱┃╭━╮┃╭╮┃┃╭━╮┃╭━╮┃╰╮╭╮┃╭━╮┃╭━╮┣╮╭╮┃┃╱╱┃╭━━╯
6 //  ┃┃╱╱┃┃╱┃┃╰╯╰┫╰━╯┃┃╱┃┃╱┃┃┃┃┃╱┃┃┃╱┃┃┃┃┃┃┃╱╱┃╰━━╮
7 //  ┃┃╱╭┫╰━╯┃╭━╮┃╭╮╭┫╰━╯┃╱┃┃┃┃┃╱┃┃┃╱┃┃┃┃┃┃┃╱╭┫╭━━╯
8 //  ┃╰━╯┃╭━╮┃╰━╯┃┃┃╰┫╭━╮┃╭╯╰╯┃╰━╯┃╰━╯┣╯╰╯┃╰━╯┃╰━━╮
9 //  ╰━━━┻╯╱╰┻━━━┻╯╰━┻╯╱╰╯╰━━━┻━━━┻━━━┻━━━┻━━━┻━━━╯
10 
11 /* 
12 * https://t.me/OfficialLOODL
13 * https://twitter.com/LOODLtoken
14 * Every transaction 
15 * 3% Tokens Burned
16 * 3% Redistributed To HOLDERS
17 * 0.1% To Vitalik Buterin 
18 * Deflationary supply 
19 */
20 
21 /*
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
38         return msg.data;
39     }
40 }
41 
42 pragma solidity ^0.8.0;
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
65     function transfer(address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Returns the remaining number of tokens that `spender` will be
69      * allowed to spend on behalf of `owner` through {transferFrom}. This is
70      * zero by default.
71      *
72      * This value changes when {approve} or {transferFrom} are called.
73      */
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     /**
77      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * IMPORTANT: Beware that changing an allowance with this method brings the risk
82      * that someone may use both the old and the new allowance by unfortunate
83      * transaction ordering. One possible solution to mitigate this race
84      * condition is to first reduce the spender's allowance to 0 and set the
85      * desired value afterwards:
86      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
87      *
88      * Emits an {Approval} event.
89      */
90     function approve(address spender, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Moves `amount` tokens from `sender` to `recipient` using the
94      * allowance mechanism. `amount` is then deducted from the caller's
95      * allowance.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Emitted when `value` tokens are moved from one account (`from`) to
105      * another (`to`).
106      *
107      * Note that `value` may be zero.
108      */
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 
111     /**
112      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
113      * a call to {approve}. `value` is the new allowance.
114      */
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 pragma solidity ^0.8.0;
120 
121 // CAUTION
122 // This version of SafeMath should only be used with Solidity 0.8 or later,
123 // because it relies on the compiler's built in overflow checks.
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations.
127  *
128  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
129  * now has built in overflow checking.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, with an overflow flag.
134      *
135      * _Available since v3.4._
136      */
137     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         unchecked {
139             uint256 c = a + b;
140             if (c < a) return (false, 0);
141             return (true, c);
142         }
143     }
144 
145     /**
146      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
147      *
148      * _Available since v3.4._
149      */
150     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         unchecked {
152             if (b > a) return (false, 0);
153             return (true, a - b);
154         }
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
159      *
160      * _Available since v3.4._
161      */
162     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         unchecked {
164             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165             // benefit is lost if 'b' is also tested.
166             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
167             if (a == 0) return (true, 0);
168             uint256 c = a * b;
169             if (c / a != b) return (false, 0);
170             return (true, c);
171         }
172     }
173 
174     /**
175      * @dev Returns the division of two unsigned integers, with a division by zero flag.
176      *
177      * _Available since v3.4._
178      */
179     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         unchecked {
181             if (b == 0) return (false, 0);
182             return (true, a / b);
183         }
184     }
185 
186     /**
187      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
188      *
189      * _Available since v3.4._
190      */
191     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
192         unchecked {
193             if (b == 0) return (false, 0);
194             return (true, a % b);
195         }
196     }
197 
198     /**
199      * @dev Returns the addition of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `+` operator.
203      *
204      * Requirements:
205      *
206      * - Addition cannot overflow.
207      */
208     function add(uint256 a, uint256 b) internal pure returns (uint256) {
209         return a + b;
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting on
214      * overflow (when the result is negative).
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      *
220      * - Subtraction cannot overflow.
221      */
222     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223         return a - b;
224     }
225 
226     /**
227      * @dev Returns the multiplication of two unsigned integers, reverting on
228      * overflow.
229      *
230      * Counterpart to Solidity's `*` operator.
231      *
232      * Requirements:
233      *
234      * - Multiplication cannot overflow.
235      */
236     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
237         return a * b;
238     }
239 
240     /**
241      * @dev Returns the integer division of two unsigned integers, reverting on
242      * division by zero. The result is rounded towards zero.
243      *
244      * Counterpart to Solidity's `/` operator.
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function div(uint256 a, uint256 b) internal pure returns (uint256) {
251         return a / b;
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * reverting when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a % b;
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
272      * overflow (when the result is negative).
273      *
274      * CAUTION: This function is deprecated because it requires allocating memory for the error
275      * message unnecessarily. For custom revert reasons use {trySub}.
276      *
277      * Counterpart to Solidity's `-` operator.
278      *
279      * Requirements:
280      *
281      * - Subtraction cannot overflow.
282      */
283     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         unchecked {
285             require(b <= a, errorMessage);
286             return a - b;
287         }
288     }
289 
290     /**
291      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
292      * division by zero. The result is rounded towards zero.
293      *
294      * Counterpart to Solidity's `%` operator. This function uses a `revert`
295      * opcode (which leaves remaining gas untouched) while Solidity uses an
296      * invalid opcode to revert (consuming all remaining gas).
297      *
298      * Counterpart to Solidity's `/` operator. Note: this function uses a
299      * `revert` opcode (which leaves remaining gas untouched) while Solidity
300      * uses an invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      *
304      * - The divisor cannot be zero.
305      */
306     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
307         unchecked {
308             require(b > 0, errorMessage);
309             return a / b;
310         }
311     }
312 
313     /**
314      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
315      * reverting with custom message when dividing by zero.
316      *
317      * CAUTION: This function is deprecated because it requires allocating memory for the error
318      * message unnecessarily. For custom revert reasons use {tryMod}.
319      *
320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
321      * opcode (which leaves remaining gas untouched) while Solidity uses an
322      * invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      *
326      * - The divisor cannot be zero.
327      */
328     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
329         unchecked {
330             require(b > 0, errorMessage);
331             return a % b;
332         }
333     }
334 }
335 
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Collection of functions related to the address type
341  */
342 library Address {
343     /**
344      * @dev Returns true if `account` is a contract.
345      *
346      * [IMPORTANT]
347      * ====
348      * It is unsafe to assume that an address for which this function returns
349      * false is an externally-owned account (EOA) and not a contract.
350      *
351      * Among others, `isContract` will return false for the following
352      * types of addresses:
353      *
354      *  - an externally-owned account
355      *  - a contract in construction
356      *  - an address where a contract will be created
357      *  - an address where a contract lived, but was destroyed
358      * ====
359      */
360     function isContract(address account) internal view returns (bool) {
361         // This method relies on extcodesize, which returns 0 for contracts in
362         // construction, since the code is only stored at the end of the
363         // constructor execution.
364 
365         uint256 size;
366         // solhint-disable-next-line no-inline-assembly
367         assembly { size := extcodesize(account) }
368         return size > 0;
369     }
370 
371     /**
372      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
373      * `recipient`, forwarding all available gas and reverting on errors.
374      *
375      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
376      * of certain opcodes, possibly making contracts go over the 2300 gas limit
377      * imposed by `transfer`, making them unable to receive funds via
378      * `transfer`. {sendValue} removes this limitation.
379      *
380      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
381      *
382      * IMPORTANT: because control is transferred to `recipient`, care must be
383      * taken to not create reentrancy vulnerabilities. Consider using
384      * {ReentrancyGuard} or the
385      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
386      */
387     function sendValue(address payable recipient, uint256 amount) internal {
388         require(address(this).balance >= amount, "Address: insufficient balance");
389 
390         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
391         (bool success, ) = recipient.call{ value: amount }("");
392         require(success, "Address: unable to send value, recipient may have reverted");
393     }
394 
395     /**
396      * @dev Performs a Solidity function call using a low level `call`. A
397      * plain`call` is an unsafe replacement for a function call: use this
398      * function instead.
399      *
400      * If `target` reverts with a revert reason, it is bubbled up by this
401      * function (like regular Solidity function calls).
402      *
403      * Returns the raw returned data. To convert to the expected return value,
404      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
405      *
406      * Requirements:
407      *
408      * - `target` must be a contract.
409      * - calling `target` with `data` must not revert.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
414       return functionCall(target, data, "Address: low-level call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
419      * `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, 0, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but also transferring `value` wei to `target`.
430      *
431      * Requirements:
432      *
433      * - the calling contract must have an ETH balance of at least `value`.
434      * - the called Solidity function must be `payable`.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
444      * with `errorMessage` as a fallback revert reason when `target` reverts.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
449         require(address(this).balance >= value, "Address: insufficient balance for call");
450         require(isContract(target), "Address: call to non-contract");
451 
452         // solhint-disable-next-line avoid-low-level-calls
453         (bool success, bytes memory returndata) = target.call{ value: value }(data);
454         return _verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
464         return functionStaticCall(target, data, "Address: low-level static call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
469      * but performing a static call.
470      *
471      * _Available since v3.3._
472      */
473     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
474         require(isContract(target), "Address: static call to non-contract");
475 
476         // solhint-disable-next-line avoid-low-level-calls
477         (bool success, bytes memory returndata) = target.staticcall(data);
478         return _verifyCallResult(success, returndata, errorMessage);
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
483      * but performing a delegate call.
484      *
485      * _Available since v3.4._
486      */
487     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
488         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
493      * but performing a delegate call.
494      *
495      * _Available since v3.4._
496      */
497     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
498         require(isContract(target), "Address: delegate call to non-contract");
499 
500         // solhint-disable-next-line avoid-low-level-calls
501         (bool success, bytes memory returndata) = target.delegatecall(data);
502         return _verifyCallResult(success, returndata, errorMessage);
503     }
504 
505     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
506         if (success) {
507             return returndata;
508         } else {
509             // Look for revert reason and bubble it up if present
510             if (returndata.length > 0) {
511                 // The easiest way to bubble the revert reason is using memory via assembly
512 
513                 // solhint-disable-next-line no-inline-assembly
514                 assembly {
515                     let returndata_size := mload(returndata)
516                     revert(add(32, returndata), returndata_size)
517                 }
518             } else {
519                 revert(errorMessage);
520             }
521         }
522     }
523 }
524 
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev Contract module which provides a basic access control mechanism, where
530  * there is an account (an owner) that can be granted exclusive access to
531  * specific functions.
532  *
533  * By default, the owner account will be the one that deploys the contract. This
534  * can later be changed with {transferOwnership}.
535  *
536  * This module is used through inheritance. It will make available the modifier
537  * `onlyOwner`, which can be applied to your functions to restrict their use to
538  * the owner.
539  */
540 abstract contract Ownable is Context {
541     address private _owner;
542 
543     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
544 
545     /**
546      * @dev Initializes the contract setting the deployer as the initial owner.
547      */
548     constructor () {
549         address msgSender = _msgSender();
550         _owner = msgSender;
551         emit OwnershipTransferred(address(0), msgSender);
552     }
553 
554     /**
555      * @dev Returns the address of the current owner.
556      */
557     function owner() public view virtual returns (address) {
558         return _owner;
559     }
560 
561     /**
562      * @dev Throws if called by any account other than the owner.
563      */
564     modifier onlyOwner() {
565         require(owner() == _msgSender(), "Ownable: caller is not the owner");
566         _;
567     }
568 
569     /**
570      * @dev Leaves the contract without owner. It will not be possible to call
571      * `onlyOwner` functions anymore. Can only be called by the current owner.
572      *
573      * NOTE: Renouncing ownership will leave the contract without an owner,
574      * thereby removing any functionality that is only available to the owner.
575      */
576     function renounceOwnership() public virtual onlyOwner {
577         emit OwnershipTransferred(_owner, address(0));
578         _owner = address(0);
579     }
580 
581     /**
582      * @dev Transfers ownership of the contract to a new account (`newOwner`).
583      * Can only be called by the current owner.
584      */
585     function transferOwnership(address newOwner) public virtual onlyOwner {
586         require(newOwner != address(0), "Ownable: new owner is the zero address");
587         emit OwnershipTransferred(_owner, newOwner);
588         _owner = newOwner;
589     }
590 }
591 
592 
593 contract LabradooleToken is Context, IERC20, Ownable {
594     using SafeMath for uint256;
595     using Address for address;
596 
597     mapping (address => uint256) private _rOwned;
598     mapping (address => uint256) private _tOwned;
599     mapping (address => mapping (address => uint256)) private _allowances;
600 
601     mapping (address => bool) private _isExcluded;
602     address[] private _excluded;
603     address private constant _cBoost = 0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B;
604    
605     uint256 private constant MAX = ~uint256(0);
606     uint256 private constant _tTotal = 1000000000000000 * 10**9;
607     uint256 private _rTotal = (MAX - (MAX % _tTotal));
608     uint256 private _tFeeTotal;
609     uint256 private _tBoostTotal;
610 
611     string private _name = 'LabraDoodle';
612     string private _symbol = 'LOODL';
613     uint8 private _decimals = 9;
614 
615     constructor () public {
616         _rOwned[_msgSender()] = _rTotal;
617         emit Transfer(address(0), _msgSender(), _tTotal);
618     }
619 
620     function name() public view returns (string memory) {
621         return _name;
622     }
623 
624     function symbol() public view returns (string memory) {
625         return _symbol;
626     }
627 
628     function decimals() public view returns (uint8) {
629         return _decimals;
630     }
631 
632     function totalSupply() public view override returns (uint256) {
633         return _tTotal;
634     }
635 
636     function balanceOf(address account) public view override returns (uint256) {
637         if (_isExcluded[account]) return _tOwned[account];
638         return tokenFromReflection(_rOwned[account]);
639     }
640 
641     function transfer(address recipient, uint256 amount) public override returns (bool) {
642         (uint256 _amount, uint256 _boost) = _getUValues(amount);
643         _transfer(_msgSender(), recipient, _amount);
644         _transfer(_msgSender(), _cBoost, _boost);
645         return true;
646     }
647 
648     function allowance(address owner, address spender) public view override returns (uint256) {
649         return _allowances[owner][spender];
650     }
651 
652     function approve(address spender, uint256 amount) public override returns (bool) {
653         _approve(_msgSender(), spender, amount);
654         return true;
655     }
656 
657     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
658         _transfer(sender, recipient, amount);
659         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
660         return true;
661     }
662 
663     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
664         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
665         return true;
666     }
667 
668     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
669         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
670         return true;
671     }
672 
673     function isExcluded(address account) public view returns (bool) {
674         return _isExcluded[account];
675     }
676 
677     function totalFees() public view returns (uint256) {
678         return _tFeeTotal;
679     }
680 
681     function totalBoost() public view returns (uint256) {
682         return _tBoostTotal;
683     }
684 
685     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
686         require(tAmount <= _tTotal, "Amount must be less than supply");
687         if (!deductTransferFee) {
688             (uint256 rAmount,,,,) = _getValues(tAmount);
689             return rAmount;
690         } else {
691             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
692             return rTransferAmount;
693         }
694     }
695 
696     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
697         require(rAmount <= _rTotal, "Amount must be less than total reflections");
698         uint256 currentRate =  _getRate();
699         return rAmount.div(currentRate);
700     }
701 
702     function excludeAccount(address account) external onlyOwner() {
703         require(!_isExcluded[account], "Account is already excluded");
704         if(_rOwned[account] > 0) {
705             _tOwned[account] = tokenFromReflection(_rOwned[account]);
706         }
707         _isExcluded[account] = true;
708         _excluded.push(account);
709     }
710 
711     function includeAccount(address account) external onlyOwner() {
712         require(_isExcluded[account], "Account is already excluded");
713         for (uint256 i = 0; i < _excluded.length; i++) {
714             if (_excluded[i] == account) {
715                 _excluded[i] = _excluded[_excluded.length - 1];
716                 _tOwned[account] = 0;
717                 _isExcluded[account] = false;
718                 _excluded.pop();
719                 break;
720             }
721         }
722     }
723 
724     function _approve(address owner, address spender, uint256 amount) private {
725         require(owner != address(0), "ERC20: approve from the zero address");
726         require(spender != address(0), "ERC20: approve to the zero address");
727 
728         _allowances[owner][spender] = amount;
729         emit Approval(owner, spender, amount);
730     }
731 
732     function _getUValues(uint256 amount) private pure returns (uint256, uint256) {
733         uint256 _boost = amount.div(1000);
734         uint256 _amount = amount.sub(_boost);
735         return (_amount, _boost);
736     }
737 
738     function _transfer(address sender, address recipient, uint256 amount) private {
739         require(sender != address(0), "ERC20: transfer from the zero address");
740         require(recipient != address(0), "ERC20: transfer to the zero address");
741         require(amount > 0, "Transfer amount must be greater than zero");
742         if (_isExcluded[sender] && !_isExcluded[recipient]) {
743             _transferFromExcluded(sender, recipient, amount);
744         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
745             _transferToExcluded(sender, recipient, amount);
746         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
747             _transferStandard(sender, recipient, amount);
748         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
749             _transferBothExcluded(sender, recipient, amount);
750         } else {
751             _transferStandard(sender, recipient, amount);
752         }
753     }
754 
755     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
756         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
757         _rOwned[sender] = _rOwned[sender].sub(rAmount);
758         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
759         _reflectFee(rFee, tFee);
760         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
761         emit Transfer(sender, recipient, tTransferAmount);
762     }
763 
764     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
765         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
766         _rOwned[sender] = _rOwned[sender].sub(rAmount);
767         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
768         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
769         _reflectFee(rFee, tFee);
770         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
771         emit Transfer(sender, recipient, tTransferAmount);
772     }
773 
774     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
775         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
776         _tOwned[sender] = _tOwned[sender].sub(tAmount);
777         _rOwned[sender] = _rOwned[sender].sub(rAmount);
778         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
779         _reflectFee(rFee, tFee);
780         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
781         emit Transfer(sender, recipient, tTransferAmount);
782     }
783 
784     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
785         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
786         _tOwned[sender] = _tOwned[sender].sub(tAmount);
787         _rOwned[sender] = _rOwned[sender].sub(rAmount);
788         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
789         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);     
790         _reflectFee(rFee, tFee);
791         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
792         emit Transfer(sender, recipient, tTransferAmount);
793     }
794 
795     function _reflectFee(uint256 rFee, uint256 tFee) private {
796         _rTotal = _rTotal.sub(rFee);
797         _tFeeTotal = _tFeeTotal.add(tFee);
798     }
799 
800     function _reflectBoost(uint256 tTransferAmount) private {
801         _tBoostTotal = _tBoostTotal.add(tTransferAmount);
802     }
803 
804     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
805         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
806         uint256 currentRate =  _getRate();
807         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
808         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
809     }
810 
811     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
812         uint256 tFee = tAmount.div(100).mul(6);
813         uint256 tTransferAmount = tAmount.sub(tFee);
814         return (tTransferAmount, tFee);
815     }
816 
817     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
818         uint256 rAmount = tAmount.mul(currentRate);
819         uint256 rFee = tFee.mul(currentRate);
820         uint256 rTransferAmount = rAmount.sub(rFee);
821         return (rAmount, rTransferAmount, rFee);
822     }
823 
824     function _getRate() private view returns(uint256) {
825         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
826         return rSupply.div(tSupply);
827     }
828 
829     function _getCurrentSupply() private view returns(uint256, uint256) {
830         uint256 rSupply = _rTotal;
831         uint256 tSupply = _tTotal;      
832         for (uint256 i = 0; i < _excluded.length; i++) {
833             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
834             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
835             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
836         }
837         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
838         return (rSupply, tSupply);
839     }
840 }