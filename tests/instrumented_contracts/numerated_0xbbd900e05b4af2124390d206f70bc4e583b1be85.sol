1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.6;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _setOwner(_msgSender());
124     }
125 
126     /**
127      * @dev Returns the address of the current owner.
128      */
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140 
141     /**
142      * @dev Leaves the contract without owner. It will not be possible to call
143      * `onlyOwner` functions anymore. Can only be called by the current owner.
144      *
145      * NOTE: Renouncing ownership will leave the contract without an owner,
146      * thereby removing any functionality that is only available to the owner.
147      */
148     function renounceOwnership() public virtual onlyOwner {
149         _setOwner(address(0));
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         _setOwner(newOwner);
159     }
160 
161     function _setOwner(address newOwner) private {
162         address oldOwner = _owner;
163         _owner = newOwner;
164         emit OwnershipTransferred(oldOwner, newOwner);
165     }
166 }
167 
168 // CAUTION
169 // This version of SafeMath should only be used with Solidity 0.8 or later,
170 // because it relies on the compiler's built in overflow checks.
171 
172 /**
173  * @dev Wrappers over Solidity's arithmetic operations.
174  *
175  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
176  * now has built in overflow checking.
177  */
178 library SafeMath {
179     /**
180      * @dev Returns the addition of two unsigned integers, with an overflow flag.
181      *
182      * _Available since v3.4._
183      */
184     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
185         unchecked {
186             uint256 c = a + b;
187             if (c < a) return (false, 0);
188             return (true, c);
189         }
190     }
191 
192     /**
193      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
194      *
195      * _Available since v3.4._
196      */
197     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
198         unchecked {
199             if (b > a) return (false, 0);
200             return (true, a - b);
201         }
202     }
203 
204     /**
205      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
206      *
207      * _Available since v3.4._
208      */
209     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
210         unchecked {
211             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
212             // benefit is lost if 'b' is also tested.
213             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
214             if (a == 0) return (true, 0);
215             uint256 c = a * b;
216             if (c / a != b) return (false, 0);
217             return (true, c);
218         }
219     }
220 
221     /**
222      * @dev Returns the division of two unsigned integers, with a division by zero flag.
223      *
224      * _Available since v3.4._
225      */
226     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         unchecked {
228             if (b == 0) return (false, 0);
229             return (true, a / b);
230         }
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
235      *
236      * _Available since v3.4._
237      */
238     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
239         unchecked {
240             if (b == 0) return (false, 0);
241             return (true, a % b);
242         }
243     }
244 
245     /**
246      * @dev Returns the addition of two unsigned integers, reverting on
247      * overflow.
248      *
249      * Counterpart to Solidity's `+` operator.
250      *
251      * Requirements:
252      *
253      * - Addition cannot overflow.
254      */
255     function add(uint256 a, uint256 b) internal pure returns (uint256) {
256         return a + b;
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting on
261      * overflow (when the result is negative).
262      *
263      * Counterpart to Solidity's `-` operator.
264      *
265      * Requirements:
266      *
267      * - Subtraction cannot overflow.
268      */
269     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a - b;
271     }
272 
273     /**
274      * @dev Returns the multiplication of two unsigned integers, reverting on
275      * overflow.
276      *
277      * Counterpart to Solidity's `*` operator.
278      *
279      * Requirements:
280      *
281      * - Multiplication cannot overflow.
282      */
283     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
284         return a * b;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers, reverting on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator.
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a / b;
299     }
300 
301     /**
302      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303      * reverting when dividing by zero.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a % b;
315     }
316 
317     /**
318      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
319      * overflow (when the result is negative).
320      *
321      * CAUTION: This function is deprecated because it requires allocating memory for the error
322      * message unnecessarily. For custom revert reasons use {trySub}.
323      *
324      * Counterpart to Solidity's `-` operator.
325      *
326      * Requirements:
327      *
328      * - Subtraction cannot overflow.
329      */
330     function sub(
331         uint256 a,
332         uint256 b,
333         string memory errorMessage
334     ) internal pure returns (uint256) {
335         unchecked {
336             require(b <= a, errorMessage);
337             return a - b;
338         }
339     }
340 
341     /**
342      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
343      * division by zero. The result is rounded towards zero.
344      *
345      * Counterpart to Solidity's `/` operator. Note: this function uses a
346      * `revert` opcode (which leaves remaining gas untouched) while Solidity
347      * uses an invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function div(
354         uint256 a,
355         uint256 b,
356         string memory errorMessage
357     ) internal pure returns (uint256) {
358         unchecked {
359             require(b > 0, errorMessage);
360             return a / b;
361         }
362     }
363 
364     /**
365      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
366      * reverting with custom message when dividing by zero.
367      *
368      * CAUTION: This function is deprecated because it requires allocating memory for the error
369      * message unnecessarily. For custom revert reasons use {tryMod}.
370      *
371      * Counterpart to Solidity's `%` operator. This function uses a `revert`
372      * opcode (which leaves remaining gas untouched) while Solidity uses an
373      * invalid opcode to revert (consuming all remaining gas).
374      *
375      * Requirements:
376      *
377      * - The divisor cannot be zero.
378      */
379     function mod(
380         uint256 a,
381         uint256 b,
382         string memory errorMessage
383     ) internal pure returns (uint256) {
384         unchecked {
385             require(b > 0, errorMessage);
386             return a % b;
387         }
388     }
389 }
390 
391 /**
392  * @dev Collection of functions related to the address type
393  */
394 library Address {
395     /**
396      * @dev Returns true if `account` is a contract.
397      *
398      * [IMPORTANT]
399      * ====
400      * It is unsafe to assume that an address for which this function returns
401      * false is an externally-owned account (EOA) and not a contract.
402      *
403      * Among others, `isContract` will return false for the following
404      * types of addresses:
405      *
406      *  - an externally-owned account
407      *  - a contract in construction
408      *  - an address where a contract will be created
409      *  - an address where a contract lived, but was destroyed
410      * ====
411      */
412     function isContract(address account) internal view returns (bool) {
413         // This method relies on extcodesize, which returns 0 for contracts in
414         // construction, since the code is only stored at the end of the
415         // constructor execution.
416 
417         uint256 size;
418         assembly {
419             size := extcodesize(account)
420         }
421         return size > 0;
422     }
423 
424     /**
425      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
426      * `recipient`, forwarding all available gas and reverting on errors.
427      *
428      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
429      * of certain opcodes, possibly making contracts go over the 2300 gas limit
430      * imposed by `transfer`, making them unable to receive funds via
431      * `transfer`. {sendValue} removes this limitation.
432      *
433      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
434      *
435      * IMPORTANT: because control is transferred to `recipient`, care must be
436      * taken to not create reentrancy vulnerabilities. Consider using
437      * {ReentrancyGuard} or the
438      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
439      */
440     function sendValue(address payable recipient, uint256 amount) internal {
441         require(address(this).balance >= amount, "Address: insufficient balance");
442 
443         (bool success, ) = recipient.call{value: amount}("");
444         require(success, "Address: unable to send value, recipient may have reverted");
445     }
446 
447     /**
448      * @dev Performs a Solidity function call using a low level `call`. A
449      * plain `call` is an unsafe replacement for a function call: use this
450      * function instead.
451      *
452      * If `target` reverts with a revert reason, it is bubbled up by this
453      * function (like regular Solidity function calls).
454      *
455      * Returns the raw returned data. To convert to the expected return value,
456      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
457      *
458      * Requirements:
459      *
460      * - `target` must be a contract.
461      * - calling `target` with `data` must not revert.
462      *
463      * _Available since v3.1._
464      */
465     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
466         return functionCall(target, data, "Address: low-level call failed");
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
471      * `errorMessage` as a fallback revert reason when `target` reverts.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(
476         address target,
477         bytes memory data,
478         string memory errorMessage
479     ) internal returns (bytes memory) {
480         return functionCallWithValue(target, data, 0, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but also transferring `value` wei to `target`.
486      *
487      * Requirements:
488      *
489      * - the calling contract must have an ETH balance of at least `value`.
490      * - the called Solidity function must be `payable`.
491      *
492      * _Available since v3.1._
493      */
494     function functionCallWithValue(
495         address target,
496         bytes memory data,
497         uint256 value
498     ) internal returns (bytes memory) {
499         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
504      * with `errorMessage` as a fallback revert reason when `target` reverts.
505      *
506      * _Available since v3.1._
507      */
508     function functionCallWithValue(
509         address target,
510         bytes memory data,
511         uint256 value,
512         string memory errorMessage
513     ) internal returns (bytes memory) {
514         require(address(this).balance >= value, "Address: insufficient balance for call");
515         require(isContract(target), "Address: call to non-contract");
516 
517         (bool success, bytes memory returndata) = target.call{value: value}(data);
518         return _verifyCallResult(success, returndata, errorMessage);
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
523      * but performing a static call.
524      *
525      * _Available since v3.3._
526      */
527     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
528         return functionStaticCall(target, data, "Address: low-level static call failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
533      * but performing a static call.
534      *
535      * _Available since v3.3._
536      */
537     function functionStaticCall(
538         address target,
539         bytes memory data,
540         string memory errorMessage
541     ) internal view returns (bytes memory) {
542         require(isContract(target), "Address: static call to non-contract");
543 
544         (bool success, bytes memory returndata) = target.staticcall(data);
545         return _verifyCallResult(success, returndata, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but performing a delegate call.
551      *
552      * _Available since v3.4._
553      */
554     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
555         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
560      * but performing a delegate call.
561      *
562      * _Available since v3.4._
563      */
564     function functionDelegateCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal returns (bytes memory) {
569         require(isContract(target), "Address: delegate call to non-contract");
570 
571         (bool success, bytes memory returndata) = target.delegatecall(data);
572         return _verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     function _verifyCallResult(
576         bool success,
577         bytes memory returndata,
578         string memory errorMessage
579     ) private pure returns (bytes memory) {
580         if (success) {
581             return returndata;
582         } else {
583             // Look for revert reason and bubble it up if present
584             if (returndata.length > 0) {
585                 // The easiest way to bubble the revert reason is using memory via assembly
586 
587                 assembly {
588                     let returndata_size := mload(returndata)
589                     revert(add(32, returndata), returndata_size)
590                 }
591             } else {
592                 revert(errorMessage);
593             }
594         }
595     }
596 }
597 
598 contract MintySwapToken is Context, IERC20, Ownable {
599   using SafeMath for uint256;
600   using Address for address;
601 
602   mapping(address => uint256) private _rOwned;
603   mapping(address => uint256) private _tOwned;
604   mapping(address => mapping(address => uint256)) private _allowances;
605 
606   mapping(address => bool) private _isExcluded;
607   address[] private _excluded;
608 
609   uint256 constant private FEE_PERCENT = 1;
610   uint256 constant private BURN_PERCENT = 1;
611   uint8 constant private DECIMALS = 9;
612   uint256 constant private TOTAL_SUPPLY = 1 * (10 ** 9) * (10 ** DECIMALS);
613   uint256 constant private MAX = ~uint256(0);
614 
615   uint256 private _rTotal = (MAX - (MAX % TOTAL_SUPPLY));
616   uint256 private _tTotal = TOTAL_SUPPLY;
617   uint256 private _tFeeTotal;
618 
619   constructor () {
620     address sender = _msgSender();
621     _rOwned[sender] = _rTotal;
622     emit Transfer(address(0), sender, TOTAL_SUPPLY);
623   }
624 
625   function name() public pure returns (string memory) {
626     return "MintySwap";
627   }
628 
629   function symbol() public pure returns (string memory) {
630     return "MINTYS";
631   }
632 
633   function decimals() public pure returns (uint8) {
634     return DECIMALS;
635   }
636 
637   function totalSupply() public view override returns (uint256) {
638     return _tTotal;
639   }
640 
641   function balanceOf(address account) public view override returns (uint256) {
642     return isExcluded(account) ? _tOwned[account] : tokenFromReflection(_rOwned[account]);
643   }
644 
645   function transfer(address recipient, uint256 amount) public override returns (bool) {
646     _transfer(_msgSender(), recipient, amount);
647     return true;
648   }
649 
650   function allowance(address owner, address spender) public view override returns (uint256) {
651     return _allowances[owner][spender];
652   }
653 
654   function approve(address spender, uint256 amount) public override returns (bool) {
655     _approve(_msgSender(), spender, amount);
656     return true;
657   }
658 
659   function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
660     _transfer(sender, recipient, amount);
661     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
662     return true;
663   }
664 
665   function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
666     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
667     return true;
668   }
669 
670   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
671     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
672     return true;
673   }
674 
675   function isExcluded(address account) public view returns (bool) {
676     return _isExcluded[account];
677   }
678 
679   function totalFees() public view returns (uint256) {
680     return _tFeeTotal;
681   }
682 
683   function totalBurned() public view returns (uint256) {
684     return TOTAL_SUPPLY - _tTotal;
685   }
686 
687   function reflect(uint256 tAmount) public {
688     address sender = _msgSender();
689     require(!_isExcluded[sender], "Excluded addresses cannot call this function");
690 
691     (uint256 rAmount,,,,,,) = _getValues(tAmount);
692     _rOwned[sender] = _rOwned[sender].sub(rAmount);
693     _rTotal = _rTotal.sub(rAmount);
694     _tFeeTotal = _tFeeTotal.add(tAmount);
695   }
696 
697   function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
698     require(tAmount <= _tTotal, "Amount must be less than supply");
699     (uint256 rAmount,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
700     return deductTransferFee ? rTransferAmount : rAmount;
701   }
702 
703   function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
704     require(rAmount <= _rTotal, "Amount must be less than total reflections");
705     return rAmount.div(_getRate());
706   }
707 
708   function excludeAccount(address account) external onlyOwner() {
709     require(!_isExcluded[account], "Account is already excluded");
710     if (_rOwned[account] > 0) {
711       _tOwned[account] = tokenFromReflection(_rOwned[account]);
712     }
713     _isExcluded[account] = true;
714     _excluded.push(account);
715   }
716 
717   function includeAccount(address account) external onlyOwner() {
718     require(_isExcluded[account], "Account is already excluded");
719     for (uint256 i = 0; i < _excluded.length; i++) {
720       if (_excluded[i] == account) {
721         _excluded[i] = _excluded[_excluded.length - 1];
722         _tOwned[account] = 0;
723         _isExcluded[account] = false;
724         _excluded.pop();
725         break;
726       }
727     }
728   }
729 
730   function airdrop(address recipient, uint256 amount) public onlyOwner() {
731     require(amount > 0, "Invalid transfer amount");
732 
733     (uint256 rAmount,,,,,,) = _getValues(amount);
734     address sender = _msgSender();
735     require(rAmount <= _rOwned[sender], "Insufficient amount");
736 
737     _rOwned[sender] = _rOwned[sender].sub(rAmount);
738     _rOwned[recipient] = _rOwned[recipient].add(rAmount);
739     emit Transfer(sender, recipient, amount);
740   }
741 
742   function _approve(address owner, address spender, uint256 amount) private {
743     require(owner != address(0), "ERC20: approve from the zero address");
744     require(spender != address(0), "ERC20: approve to the zero address");
745     _allowances[owner][spender] = amount;
746     emit Approval(owner, spender, amount);
747   }
748 
749   function _transfer(address sender, address recipient, uint256 amount) private {
750     require(sender != address(0), "ERC20: transfer from the zero address");
751     require(recipient != address(0), "ERC20: transfer to the zero address");
752     require(amount > 0, "Transfer amount must be greater than zero");
753 
754     if (_isExcluded[sender] && !_isExcluded[recipient]) {
755       _transferFromExcluded(sender, recipient, amount);
756     } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
757       _transferToExcluded(sender, recipient, amount);
758     } else if (_isExcluded[sender] && _isExcluded[recipient]) {
759       _transferBothExcluded(sender, recipient, amount);
760     } else {
761       _transferStandard(sender, recipient, amount);
762     }
763   }
764 
765   function _transferStandard(address sender, address recipient, uint256 tAmount) private {
766     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rBurn, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
767     _rOwned[sender] = _rOwned[sender].sub(rAmount);
768     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
769 
770     _reflectFee(rFee, tFee, rBurn, tBurn);
771     emit Transfer(sender, recipient, tTransferAmount);
772     emit Transfer(sender, address(0), tBurn);
773   }
774 
775   function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
776     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rBurn, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
777     _rOwned[sender] = _rOwned[sender].sub(rAmount);
778     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
779     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
780 
781     _reflectFee(rFee, tFee, rBurn, tBurn);
782     emit Transfer(sender, recipient, tTransferAmount);
783     emit Transfer(sender, address(0), tBurn);
784   }
785 
786   function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
787     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rBurn, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
788     _tOwned[sender] = _tOwned[sender].sub(tAmount);
789     _rOwned[sender] = _rOwned[sender].sub(rAmount);
790     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
791 
792     _reflectFee(rFee, tFee, rBurn, tBurn);
793     emit Transfer(sender, recipient, tTransferAmount);
794     emit Transfer(sender, address(0), tBurn);
795   }
796 
797   function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
798     (,,,,uint256 tTransferAmount,,) = _getValues(tAmount);
799     emit Transfer(sender, recipient, tTransferAmount);
800   }
801 
802   function _reflectFee(uint256 rFee, uint256 tFee, uint256 rBurn, uint256 tBurn) private {
803     _rTotal = _rTotal.sub(rFee.add(rBurn));
804     _tTotal = _tTotal.sub(tBurn);
805     _tFeeTotal = _tFeeTotal.add(tFee);
806   }
807 
808   function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
809     (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount);
810     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rBurn) = _getRValues(tAmount, tFee, tBurn, _getRate());
811     return (rAmount, rTransferAmount, rFee, rBurn, tTransferAmount, tFee, tBurn);
812   }
813 
814   function _getTValues(uint256 tAmount) private pure returns (uint256, uint256, uint256) {
815     uint256 tFee = tAmount.div(100).mul(FEE_PERCENT);
816     uint256 tBurn = tAmount.div(100).mul(BURN_PERCENT);
817     uint256 tTransferAmount = tAmount.sub(tFee.add(tBurn));
818     return (tTransferAmount, tFee, tBurn);
819   }
820 
821   function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 rate) private pure returns (uint256, uint256, uint256, uint256) {
822     uint256 rAmount = tAmount.mul(rate);
823     uint256 rFee = tFee.mul(rate);
824     uint256 rBurn = tBurn.mul(rate);
825     uint256 rTransferAmount = rAmount.sub(rFee.add(rBurn));
826     return (rAmount, rTransferAmount, rFee, rBurn);
827   }
828 
829   function _getRate() private view returns (uint256) {
830     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
831     return rSupply.div(tSupply);
832   }
833 
834   function _getCurrentSupply() private view returns (uint256, uint256) {
835     uint256 rSupply = _rTotal;
836     uint256 tSupply = _tTotal;
837     for (uint256 i = 0; i < _excluded.length; i++) {
838       if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
839       rSupply = rSupply.sub(_rOwned[_excluded[i]]);
840       tSupply = tSupply.sub(_tOwned[_excluded[i]]);
841     }
842     if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
843     return (rSupply, tSupply);
844   }
845 }