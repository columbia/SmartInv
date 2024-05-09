1 // SPDX-License-Identifier: GCB
2 
3 pragma solidity ^0.6.2;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
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
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86  
87 library SafeMath {
88     /**
89      * @dev Returns the addition of two unsigned integers, with an overflow flag.
90      */
91     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
92         uint256 c = a + b;
93         if (c < a) return (false, 0);
94         return (true, c);
95     }
96 
97     /**
98      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
99      */
100     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
101         if (b > a) return (false, 0);
102         return (true, a - b);
103     }
104 
105     /**
106      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
107      */
108     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112         if (a == 0) return (true, 0);
113         uint256 c = a * b;
114         if (c / a != b) return (false, 0);
115         return (true, c);
116     }
117 
118     /**
119      * @dev Returns the division of two unsigned integers, with a division by zero flag.
120      */
121     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
122         if (b == 0) return (false, 0);
123         return (true, a / b);
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
128      */
129     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         if (b == 0) return (false, 0);
131         return (true, a % b);
132     }
133 
134     /**
135      * @dev Returns the addition of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `+` operator.
139      *
140      * Requirements:
141      *
142      * - Addition cannot overflow.
143      */
144     function add(uint256 a, uint256 b) internal pure returns (uint256) {
145         uint256 c = a + b;
146         require(c >= a, "SafeMath: addition overflow");
147         return c;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         require(b <= a, "SafeMath: subtraction overflow");
162         return a - b;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      *
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         if (a == 0) return 0;
177         uint256 c = a * b;
178         require(c / a == b, "SafeMath: multiplication overflow");
179         return c;
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers, reverting on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b) internal pure returns (uint256) {
195         require(b > 0, "SafeMath: division by zero");
196         return a / b;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         require(b > 0, "SafeMath: modulo by zero");
213         return a % b;
214     }
215 
216     /**
217      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
218      * overflow (when the result is negative).
219      *
220      * CAUTION: This function is deprecated because it requires allocating memory for the error
221      * message unnecessarily. For custom revert reasons use {trySub}.
222      *
223      * Counterpart to Solidity's `-` operator.
224      *
225      * Requirements:
226      *
227      * - Subtraction cannot overflow.
228      */
229     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b <= a, errorMessage);
231         return a - b;
232     }
233 
234     /**
235      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
236      * division by zero. The result is rounded towards zero.
237      *
238      * CAUTION: This function is deprecated because it requires allocating memory for the error
239      * message unnecessarily. For custom revert reasons use {tryDiv}.
240      *
241      * Counterpart to Solidity's `/` operator. Note: this function uses a
242      * `revert` opcode (which leaves remaining gas untouched) while Solidity
243      * uses an invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b > 0, errorMessage);
251         return a / b;
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * reverting with custom message when dividing by zero.
257      *
258      * CAUTION: This function is deprecated because it requires allocating memory for the error
259      * message unnecessarily. For custom revert reasons use {tryMod}.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b > 0, errorMessage);
271         return a % b;
272     }
273 }
274 
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
294         // This method relies on extcodesize, which returns 0 for contracts in
295         // construction, since the code is only stored at the end of the
296         // constructor execution.
297 
298         uint256 size;
299         // solhint-disable-next-line no-inline-assembly
300         assembly { size := extcodesize(account) }
301         return size > 0;
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(address(this).balance >= amount, "Address: insufficient balance");
322 
323         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
324         (bool success, ) = recipient.call{ value: amount }("");
325         require(success, "Address: unable to send value, recipient may have reverted");
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level `call`. A
330      * plain`call` is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If `target` reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
338      *
339      * Requirements:
340      *
341      * - `target` must be a contract.
342      * - calling `target` with `data` must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
347       return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
352      * `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, 0, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but also transferring `value` wei to `target`.
363      *
364      * Requirements:
365      *
366      * - the calling contract must have an ETH balance of at least `value`.
367      * - the called Solidity function must be `payable`.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
372         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
377      * with `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
382         require(address(this).balance >= value, "Address: insufficient balance for call");
383         require(isContract(target), "Address: call to non-contract");
384 
385         // solhint-disable-next-line avoid-low-level-calls
386         (bool success, bytes memory returndata) = target.call{ value: value }(data);
387         return _verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
397         return functionStaticCall(target, data, "Address: low-level static call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
407         require(isContract(target), "Address: static call to non-contract");
408 
409         // solhint-disable-next-line avoid-low-level-calls
410         (bool success, bytes memory returndata) = target.staticcall(data);
411         return _verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but performing a delegate call.
417      *
418      * _Available since v3.3._
419      */
420     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
421         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.3._
429      */
430     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
431         require(isContract(target), "Address: delegate call to non-contract");
432 
433         // solhint-disable-next-line avoid-low-level-calls
434         (bool success, bytes memory returndata) = target.delegatecall(data);
435         return _verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
439         if (success) {
440             return returndata;
441         } else {
442             // Look for revert reason and bubble it up if present
443             if (returndata.length > 0) {
444                 // The easiest way to bubble the revert reason is using memory via assembly
445 
446                 // solhint-disable-next-line no-inline-assembly
447                 assembly {
448                     let returndata_size := mload(returndata)
449                     revert(add(32, returndata), returndata_size)
450                 }
451             } else {
452                 revert(errorMessage);
453             }
454         }
455     }
456 }
457 
458 
459 abstract contract Ownable is Context {
460     address private _owner;
461 
462     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
463 
464     /**
465      * @dev Initializes the contract setting the deployer as the initial owner.
466      */
467     constructor () internal {
468         address msgSender = _msgSender();
469         _owner = msgSender;
470         emit OwnershipTransferred(address(0), msgSender);
471     }
472 
473     /**
474      * @dev Returns the address of the current owner.
475      */
476     function owner() public view returns (address) {
477         return _owner;
478     }
479 
480     /**
481      * @dev Throws if called by any account other than the owner.
482      */
483     modifier onlyOwner() {
484         require(_owner == _msgSender(), "Ownable: caller is not the owner");
485         _;
486     }
487 
488     /**
489      * @dev Leaves the contract without owner. It will not be possible to call
490      * `onlyOwner` functions anymore. Can only be called by the current owner.
491      *
492      * NOTE: Renouncing ownership will leave the contract without an owner,
493      * thereby removing any functionality that is only available to the owner.
494      */
495     function renounceOwnership() public virtual onlyOwner {
496         emit OwnershipTransferred(_owner, address(0));
497         _owner = address(0);
498     }
499 
500     /**
501      * @dev Transfers ownership of the contract to a new account (`newOwner`).
502      * Can only be called by the current owner.
503      */
504     function transferOwnership(address newOwner) public virtual onlyOwner {
505         require(newOwner != address(0), "Ownable: new owner is the zero address");
506         emit OwnershipTransferred(_owner, newOwner);
507         _owner = newOwner;
508     }
509 }
510 
511 contract GCB is Context, IERC20, Ownable {
512     using SafeMath for uint256;
513     using Address for address;
514 
515     mapping (address => uint256) private _gcbOwned;
516     mapping (address => uint256) private _gcbtOwned;
517     mapping (address => mapping (address => uint256)) private _allowances;
518 
519     mapping (address => bool) private _isExcluded;
520     address[] private _excluded;
521    
522     uint256 private constant MAX = ~uint256(0);
523     uint256 private constant _gcbtTotal = 10e21;
524     uint256 private _gcbTotal = (MAX - (MAX % _gcbtTotal));
525     uint256 private _tFeeTotal;
526 
527     string private _name = 'GCB';
528     string private _symbol = 'GCB';
529     uint8 private _decimals = 18;
530 
531     constructor () public {
532         _gcbOwned[_msgSender()] = _gcbTotal;
533         emit Transfer(address(0), _msgSender(), _gcbtTotal);
534     }
535 
536     function name() public view returns (string memory) {
537         return _name;
538     }
539 
540     function symbol() public view returns (string memory) {
541         return _symbol;
542     }
543 
544     function decimals() public view returns (uint8) {
545         return _decimals;
546     }
547 
548     function totalSupply() public view override returns (uint256) {
549         return _gcbtTotal;
550     }
551 
552     function balanceOf(address account) public view override returns (uint256) {
553         if (_isExcluded[account]) return _gcbtOwned[account];
554         return tokenFromGCB(_gcbOwned[account]);
555     }
556 
557     function transfer(address recipient, uint256 amount) public override returns (bool) {
558         _transfer(_msgSender(), recipient, amount);
559         return true;
560     }
561 
562     function allowance(address owner, address spender) public view override returns (uint256) {
563         return _allowances[owner][spender];
564     }
565 
566     function approve(address spender, uint256 amount) public override returns (bool) {
567         _approve(_msgSender(), spender, amount);
568         return true;
569     }
570 
571     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
572         _transfer(sender, recipient, amount);
573         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
574         return true;
575     }
576 
577     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
578         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
579         return true;
580     }
581 
582     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
583         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
584         return true;
585     }
586 
587     function isExcluded(address account) public view returns (bool) {
588         return _isExcluded[account];
589     }
590 
591     function totalFees() public view returns (uint256) {
592         return _tFeeTotal;
593     }
594 
595     function gcb(uint256 tAmount) public {
596         address sender = _msgSender();
597         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
598         (uint256 _gcbAmount,,,,) = _getValues(tAmount);
599         _gcbOwned[sender] = _gcbOwned[sender].sub(_gcbAmount);
600         _gcbTotal = _gcbTotal.sub(_gcbAmount);
601         _tFeeTotal = _tFeeTotal.add(tAmount);
602     }
603 
604     function gcbFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
605         require(tAmount <= _gcbtTotal, "Amount must be less than supply");
606         if (!deductTransferFee) {
607             (uint256 _gcbAmount,,,,) = _getValues(tAmount);
608             return _gcbAmount;
609         } else {
610             (,uint256 rTransfe_gcbAmount,,,) = _getValues(tAmount);
611             return rTransfe_gcbAmount;
612         }
613     }
614 
615     function tokenFromGCB(uint256 _gcbAmount) public view returns(uint256) {
616         require(_gcbAmount <= _gcbTotal, "Amount must be less than total tokens");
617         uint256 currentRate =  _getRate();
618         return _gcbAmount.div(currentRate);
619     }
620 
621     function excludeAccount(address account) external onlyOwner() {
622         require(!_isExcluded[account], "Account is already excluded");
623         if(_gcbOwned[account] > 0) {
624             _gcbtOwned[account] = tokenFromGCB(_gcbOwned[account]);
625         }
626         _isExcluded[account] = true;
627         _excluded.push(account);
628     }
629 
630     function includeAccount(address account) external onlyOwner() {
631         require(_isExcluded[account], "Account is already excluded");
632         for (uint256 i = 0; i < _excluded.length; i++) {
633             if (_excluded[i] == account) {
634                 _excluded[i] = _excluded[_excluded.length - 1];
635                 _gcbtOwned[account] = 0;
636                 _isExcluded[account] = false;
637                 _excluded.pop();
638                 break;
639             }
640         }
641     }
642 
643     function _approve(address owner, address spender, uint256 amount) private {
644         require(owner != address(0), "ERC20: approve from the zero address");
645         require(spender != address(0), "ERC20: approve to the zero address");
646 
647         _allowances[owner][spender] = amount;
648         emit Approval(owner, spender, amount);
649     }
650 
651     function _transfer(address sender, address recipient, uint256 amount) private {
652         require(sender != address(0), "ERC20: transfer from the zero address");
653         require(recipient != address(0), "ERC20: transfer to the zero address");
654         require(amount > 0, "Transfer amount must be greater than zero");
655         if (_isExcluded[sender] && !_isExcluded[recipient]) {
656             _transferFromExcluded(sender, recipient, amount);
657         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
658             _transferToExcluded(sender, recipient, amount);
659         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
660             _transferStandard(sender, recipient, amount);
661         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
662             _transferBothExcluded(sender, recipient, amount);
663         } else {
664             _transferStandard(sender, recipient, amount);
665         }
666     }
667 
668     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
669         (uint256 _gcbAmount, uint256 rTransfe_gcbAmount, uint256 rFee, uint256 tTransfe_gcbAmount, uint256 tFee) = _getValues(tAmount);
670         _gcbOwned[sender] = _gcbOwned[sender].sub(_gcbAmount);
671         _gcbOwned[recipient] = _gcbOwned[recipient].add(rTransfe_gcbAmount);       
672         _gcbFee(rFee, tFee);
673         emit Transfer(sender, recipient, tTransfe_gcbAmount);
674     }
675 
676     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
677         (uint256 _gcbAmount, uint256 rTransfe_gcbAmount, uint256 rFee, uint256 tTransfe_gcbAmount, uint256 tFee) = _getValues(tAmount);
678         _gcbOwned[sender] = _gcbOwned[sender].sub(_gcbAmount);
679         _gcbtOwned[recipient] = _gcbtOwned[recipient].add(tTransfe_gcbAmount);
680         _gcbOwned[recipient] = _gcbOwned[recipient].add(rTransfe_gcbAmount);           
681         _gcbFee(rFee, tFee);
682         emit Transfer(sender, recipient, tTransfe_gcbAmount);
683     }
684 
685     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
686         (uint256 _gcbAmount, uint256 rTransfe_gcbAmount, uint256 rFee, uint256 tTransfe_gcbAmount, uint256 tFee) = _getValues(tAmount);
687         _gcbtOwned[sender] = _gcbtOwned[sender].sub(tAmount);
688         _gcbOwned[sender] = _gcbOwned[sender].sub(_gcbAmount);
689         _gcbOwned[recipient] = _gcbOwned[recipient].add(rTransfe_gcbAmount);   
690         _gcbFee(rFee, tFee);
691         emit Transfer(sender, recipient, tTransfe_gcbAmount);
692     }
693 
694     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
695         (uint256 _gcbAmount, uint256 rTransfe_gcbAmount, uint256 rFee, uint256 tTransfe_gcbAmount, uint256 tFee) = _getValues(tAmount);
696         _gcbtOwned[sender] = _gcbtOwned[sender].sub(tAmount);
697         _gcbOwned[sender] = _gcbOwned[sender].sub(_gcbAmount);
698         _gcbtOwned[recipient] = _gcbtOwned[recipient].add(tTransfe_gcbAmount);
699         _gcbOwned[recipient] = _gcbOwned[recipient].add(rTransfe_gcbAmount);        
700         _gcbFee(rFee, tFee);
701         emit Transfer(sender, recipient, tTransfe_gcbAmount);
702     }
703 
704     function _gcbFee(uint256 rFee, uint256 tFee) private {
705         _gcbTotal = _gcbTotal.sub(rFee);
706         _tFeeTotal = _tFeeTotal.add(tFee);
707     }
708 
709     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
710         (uint256 tTransfe_gcbAmount, uint256 tFee) = _getTValues(tAmount);
711         uint256 currentRate =  _getRate();
712         (uint256 _gcbAmount, uint256 rTransfe_gcbAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
713         return (_gcbAmount, rTransfe_gcbAmount, rFee, tTransfe_gcbAmount, tFee);
714     }
715 
716     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
717         uint256 tFee = tAmount.div(100).mul(3500).div(1e3);
718         uint256 tTransfe_gcbAmount = tAmount.sub(tFee);
719         return (tTransfe_gcbAmount, tFee);
720     }
721 
722     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
723         uint256 _gcbAmount = tAmount.mul(currentRate);
724         uint256 rFee = tFee.mul(currentRate);
725         uint256 rTransfe_gcbAmount = _gcbAmount.sub(rFee);
726         return (_gcbAmount, rTransfe_gcbAmount, rFee);
727     }
728 
729     function _getRate() private view returns(uint256) {
730         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
731         return rSupply.div(tSupply);
732     }
733 
734     function _getCurrentSupply() private view returns(uint256, uint256) {
735         uint256 rSupply = _gcbTotal;
736         uint256 tSupply = _gcbtTotal;      
737         for (uint256 i = 0; i < _excluded.length; i++) {
738             if (_gcbOwned[_excluded[i]] > rSupply || _gcbtOwned[_excluded[i]] > tSupply) return (_gcbTotal, _gcbtTotal);
739             rSupply = rSupply.sub(_gcbOwned[_excluded[i]]);
740             tSupply = tSupply.sub(_gcbtOwned[_excluded[i]]);
741         }
742         if (rSupply < _gcbTotal.div(_gcbtTotal)) return (_gcbTotal, _gcbtTotal);
743         return (rSupply, tSupply);
744     }
745 }