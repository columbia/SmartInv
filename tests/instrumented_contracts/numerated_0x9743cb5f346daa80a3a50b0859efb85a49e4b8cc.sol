1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-07
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-02-07
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.7.4;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94  
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, with an overflow flag.
98      */
99     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
100         uint256 c = a + b;
101         if (c < a) return (false, 0);
102         return (true, c);
103     }
104 
105     /**
106      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
107      */
108     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
109         if (b > a) return (false, 0);
110         return (true, a - b);
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
115      */
116     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
118         // benefit is lost if 'b' is also tested.
119         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
120         if (a == 0) return (true, 0);
121         uint256 c = a * b;
122         if (c / a != b) return (false, 0);
123         return (true, c);
124     }
125 
126     /**
127      * @dev Returns the division of two unsigned integers, with a division by zero flag.
128      */
129     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         if (b == 0) return (false, 0);
131         return (true, a / b);
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
136      */
137     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         if (b == 0) return (false, 0);
139         return (true, a % b);
140     }
141 
142     /**
143      * @dev Returns the addition of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `+` operator.
147      *
148      * Requirements:
149      *
150      * - Addition cannot overflow.
151      */
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a, "SafeMath: addition overflow");
155         return c;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169         require(b <= a, "SafeMath: subtraction overflow");
170         return a - b;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      *
181      * - Multiplication cannot overflow.
182      */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         if (a == 0) return 0;
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers, reverting on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         require(b > 0, "SafeMath: division by zero");
204         return a / b;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * reverting when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         require(b > 0, "SafeMath: modulo by zero");
221         return a % b;
222     }
223 
224     /**
225      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
226      * overflow (when the result is negative).
227      *
228      * CAUTION: This function is deprecated because it requires allocating memory for the error
229      * message unnecessarily. For custom revert reasons use {trySub}.
230      *
231      * Counterpart to Solidity's `-` operator.
232      *
233      * Requirements:
234      *
235      * - Subtraction cannot overflow.
236      */
237     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b <= a, errorMessage);
239         return a - b;
240     }
241 
242     /**
243      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
244      * division by zero. The result is rounded towards zero.
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {tryDiv}.
248      *
249      * Counterpart to Solidity's `/` operator. Note: this function uses a
250      * `revert` opcode (which leaves remaining gas untouched) while Solidity
251      * uses an invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b > 0, errorMessage);
259         return a / b;
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * reverting with custom message when dividing by zero.
265      *
266      * CAUTION: This function is deprecated because it requires allocating memory for the error
267      * message unnecessarily. For custom revert reasons use {tryMod}.
268      *
269      * Counterpart to Solidity's `%` operator. This function uses a `revert`
270      * opcode (which leaves remaining gas untouched) while Solidity uses an
271      * invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b > 0, errorMessage);
279         return a % b;
280     }
281 }
282 
283 library Address {
284     /**
285      * @dev Returns true if `account` is a contract.
286      *
287      * [IMPORTANT]
288      * ====
289      * It is unsafe to assume that an address for which this function returns
290      * false is an externally-owned account (EOA) and not a contract.
291      *
292      * Among others, `isContract` will return false for the following
293      * types of addresses:
294      *
295      *  - an externally-owned account
296      *  - a contract in construction
297      *  - an address where a contract will be created
298      *  - an address where a contract lived, but was destroyed
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // This method relies on extcodesize, which returns 0 for contracts in
303         // construction, since the code is only stored at the end of the
304         // constructor execution.
305 
306         uint256 size;
307         // solhint-disable-next-line no-inline-assembly
308         assembly { size := extcodesize(account) }
309         return size > 0;
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      */
328     function sendValue(address payable recipient, uint256 amount) internal {
329         require(address(this).balance >= amount, "Address: insufficient balance");
330 
331         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
332         (bool success, ) = recipient.call{ value: amount }("");
333         require(success, "Address: unable to send value, recipient may have reverted");
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain`call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
355       return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
385      * with `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         require(isContract(target), "Address: call to non-contract");
392 
393         // solhint-disable-next-line avoid-low-level-calls
394         (bool success, bytes memory returndata) = target.call{ value: value }(data);
395         return _verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
405         return functionStaticCall(target, data, "Address: low-level static call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
410      * but performing a static call.
411      *
412      * _Available since v3.3._
413      */
414     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
415         require(isContract(target), "Address: static call to non-contract");
416 
417         // solhint-disable-next-line avoid-low-level-calls
418         (bool success, bytes memory returndata) = target.staticcall(data);
419         return _verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but performing a delegate call.
425      *
426      * _Available since v3.3._
427      */
428     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
429         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
434      * but performing a delegate call.
435      *
436      * _Available since v3.3._
437      */
438     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
439         require(isContract(target), "Address: delegate call to non-contract");
440 
441         // solhint-disable-next-line avoid-low-level-calls
442         (bool success, bytes memory returndata) = target.delegatecall(data);
443         return _verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 // solhint-disable-next-line no-inline-assembly
455                 assembly {
456                     let returndata_size := mload(returndata)
457                     revert(add(32, returndata), returndata_size)
458                 }
459             } else {
460                 revert(errorMessage);
461             }
462         }
463     }
464 }
465 
466 
467 abstract contract Ownable is Context {
468     address private _owner;
469 
470     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
471 
472     /**
473      * @dev Initializes the contract setting the deployer as the initial owner.
474      */
475     constructor ()  {
476         address msgSender = _msgSender();
477         _owner = msgSender;
478         emit OwnershipTransferred(address(0), msgSender);
479     }
480 
481     /**
482      * @dev Returns the address of the current owner.
483      */
484     function owner() public view returns (address) {
485         return _owner;
486     }
487 
488     /**
489      * @dev Throws if called by any account other than the owner.
490      */
491     modifier onlyOwner() {
492         require(_owner == _msgSender(), "Ownable: caller is not the owner");
493         _;
494     }
495 
496     /**
497      * @dev Leaves the contract without owner. It will not be possible to call
498      * `onlyOwner` functions anymore. Can only be called by the current owner.
499      *
500      * NOTE: Renouncing ownership will leave the contract without an owner,
501      * thereby removing any functionality that is only available to the owner.
502      */
503     function renounceOwnership() public virtual onlyOwner {
504         emit OwnershipTransferred(_owner, address(0));
505         _owner = address(0);
506     }
507 
508     /**
509      * @dev Transfers ownership of the contract to a new account (`newOwner`).
510      * Can only be called by the current owner.
511      */
512     function transferOwnership(address newOwner) public virtual onlyOwner {
513         require(newOwner != address(0), "Ownable: new owner is the zero address");
514         emit OwnershipTransferred(_owner, newOwner);
515         _owner = newOwner;
516     }
517 }
518 
519 
520 contract Fintex is Context, IERC20, Ownable {
521     using SafeMath for uint256;
522     using Address for address;
523 
524     string private constant NAME = "Fintex";
525     string private constant SYMBOL = "FTEX";
526     uint8 private constant DECIMALS = 18;
527 
528  
529     mapping(address => uint256) private actual;
530     mapping(address => mapping(address => uint256)) private allowances;
531 
532     mapping(address => bool) private excludedFromFees;
533     
534    
535 
536     uint256 private constant MAX = ~uint256(0);
537     uint256 private constant ACTUAL_TOTAL = 10000 * 1e18;
538    
539    
540     uint256 private rewardFeeTotal;
541     uint256 private lotteryFeeTotal;
542   
543 
544     uint256 public taxPercentage = 5;
545     uint256 public rewardTaxAlloc = 70;
546     uint256 public lotteryTaxAlloc = 30;
547    
548     uint256 public totalTaxAlloc = rewardTaxAlloc.add(lotteryTaxAlloc);
549 
550     address public rewardAddress;
551     address public lotteryAddress;
552     
553     constructor(address _rewardAddress, address _lotteryAddress) {
554         
555         emit Transfer(address(0), _msgSender(), ACTUAL_TOTAL);
556         actual[_msgSender()] = actual[_msgSender()].add(ACTUAL_TOTAL);
557         rewardAddress = _rewardAddress;
558         lotteryAddress = _lotteryAddress;
559 
560         excludeFromFees(rewardAddress);
561         excludeFromFees(lotteryAddress);
562         excludeFromFees(_msgSender());
563        
564  
565     }
566 
567     function name() external pure returns (string memory) {
568         return NAME;
569     }
570 
571     function symbol() external pure returns (string memory) {
572         return SYMBOL;
573     }
574 
575     function decimals() external pure returns (uint8) {
576         return DECIMALS;
577     }
578 
579     function totalSupply() external pure override returns (uint256) {
580         return ACTUAL_TOTAL;
581     }
582 
583     function balanceOf(address _account) public view override returns (uint256) {
584        
585             return actual[_account];
586       
587     }
588 
589     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
590         _transfer(_msgSender(), _recipient, _amount);
591         return true;
592     }
593 
594     function allowance(address _owner, address _spender) public view override returns (uint256) {
595         return allowances[_owner][_spender];
596     }
597 
598     function approve(address _spender, uint256 _amount) public override returns (bool) {
599         _approve(_msgSender(), _spender, _amount);
600         return true;
601     }
602 
603     function transferFrom(
604         address _sender,
605         address _recipient,
606         uint256 _amount
607     ) public override returns (bool) {
608         require(allowances[_sender][_msgSender()] > _amount, 'Not Allowed' );
609         allowances[_sender][_msgSender()] = allowances[_sender][_msgSender()].sub(_amount, "ERC20: decreased allowance below zero");
610        
611         _transfer(_sender, _recipient, _amount);
612 
613        
614 
615         return true;
616     }
617 
618 
619 
620 
621     
622 
623     function isExcludedFromFees(address _account) external view returns (bool) {
624         return excludedFromFees[_account];
625     }
626 
627   
628 
629  
630 
631     function totalRewardFees() external view returns (uint256) {
632         return rewardFeeTotal;
633     }
634 
635     function totalLotteryFees() external view returns (uint256) {
636         return lotteryFeeTotal;
637     }
638 
639 
640 
641     function excludeFromFees(address _account) public onlyOwner() {
642         require(!excludedFromFees[_account], "Account is already excluded from fee");
643         excludedFromFees[_account] = true;
644     }
645 
646     function includeInFees(address _account) public onlyOwner() {
647         require(excludedFromFees[_account], "Account is already included in fee");
648         excludedFromFees[_account] = false;
649     }
650 
651   
652 
653     function _approve(
654         address _owner,
655         address _spender,
656         uint256 _amount
657     ) private {
658         require(_owner != address(0), "ERC20: approve from the zero address");
659         require(_spender != address(0), "ERC20: approve to the zero address");
660         
661         allowances[_owner][_spender] = _amount;
662         emit Approval(_owner, _spender, _amount);
663     }
664 
665     function _transfer(
666         address _sender,
667         address _recipient,
668         uint256 _amount
669     ) private {
670         require(_sender != address(0), "ERC20: transfer from the zero address");
671         require(_recipient != address(0), "ERC20: transfer to the zero address");
672         require(_amount > 0, "Transfer amount must be greater than zero");
673 
674  
675         uint256 fee = 0;
676         if (excludedFromFees[_sender] || excludedFromFees[_recipient]) {
677              fee = 0;
678 
679         } else {
680             fee = _getFee(_amount);
681             uint256 rewardFee = _getrewardFee(fee);
682             uint256 lotteryFee = _getLotteryFee(fee);
683             
684             _updateRewardFee(rewardFee);
685             _updateLotteryFee(lotteryFee); 
686         }
687 
688         uint256 actualTransferAmount = _amount.sub(fee) ;  
689         actual[_recipient] = actual[_recipient].add(actualTransferAmount);
690         actual[_sender] = actual[_sender].sub(_amount);
691 
692         emit Transfer(_sender, _recipient, actualTransferAmount);
693  
694 
695        
696     }
697   
698     function _updateRewardFee(uint256 _rewardFee) private {
699         if (rewardAddress == address(0)) {
700             return;
701         }
702 
703         actual[rewardAddress] = actual[rewardAddress].add(_rewardFee);
704         
705     }
706 
707     function _updateLotteryFee(uint256 _lotteryFee) private {
708         if (lotteryAddress == address(0)) {
709             return;
710         }
711  
712         actual[lotteryAddress] = actual[lotteryAddress].add(_lotteryFee);
713         
714     }
715  
716  
717     function _getFee(uint256 _amount) private view returns (uint256) {
718         return _amount.mul(taxPercentage).div(100);
719     }
720  
721 
722     function _getrewardFee(uint256 _tax) private view returns (uint256) {
723         return _tax.mul(rewardTaxAlloc).div(totalTaxAlloc);
724     }
725 
726     function _getLotteryFee(uint256 _tax) private view returns (uint256) {
727         return _tax.mul(lotteryTaxAlloc).div(totalTaxAlloc);
728     }
729 
730    
731 
732     function setTaxPercentage(uint256 _taxPercentage) external onlyOwner {
733         taxPercentage = _taxPercentage;
734     }
735 
736  function setlotteryTaxAlloc(uint256 alloc) external onlyOwner {
737        
738         lotteryTaxAlloc = alloc;
739     }
740 
741  function setrewardTaxAlloc(uint256 alloc) external onlyOwner {
742        
743         rewardTaxAlloc = alloc;
744     }
745  
746 
747     function setRewardAddress(address _rewardAddress) external onlyOwner {
748         rewardAddress = _rewardAddress;
749     }
750 
751     function setLotetryAddress(address _lotteryAddress) external onlyOwner {
752         lotteryAddress = _lotteryAddress;
753     }
754 
755     
756 }