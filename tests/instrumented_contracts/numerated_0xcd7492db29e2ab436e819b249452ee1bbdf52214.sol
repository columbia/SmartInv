1 /**
2    #SafeMoon Inu - SafeMoon Inu Smart Contract   
3    Community based project. All memes.
4    The community is in charge.
5        !
6        !
7        ^
8       / \
9      /___\
10     |=   =|
11     |     |
12     |     |
13     |     |
14     |     |
15     |     |
16     |     |
17     |     |
18     |     |
19     |     |
20    /|#SMI#|\
21   / |#SMI#| \
22  /  |#SMI#|  \
23 |  / ^ | ^ \  |
24 | /  ( | )  \ |
25 |/   ( | )   \|
26     ((   ))
27    ((  :  ))
28    ((  :  ))
29     ((   ))
30      (( ))
31       ( )
32        .
33        .
34        .
35 */
36 
37 // SafeMoon Inu
38 
39 
40 // SPDX-License-Identifier: Unlicensed
41 
42 pragma solidity ^0.6.12;
43 
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address payable) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes memory) {
50         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
51         return msg.data;
52     }
53 }
54 
55 interface IERC20 {
56     /**
57      * @dev Returns the amount of tokens in existence.
58      */
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by `account`.
63      */
64     function balanceOf(address account) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `recipient`.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transfer(address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Returns the remaining number of tokens that `spender` will be
77      * allowed to spend on behalf of `owner` through {transferFrom}. This is
78      * zero by default.
79      *
80      * This value changes when {approve} or {transferFrom} are called.
81      */
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     /**
85      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * IMPORTANT: Beware that changing an allowance with this method brings the risk
90      * that someone may use both the old and the new allowance by unfortunate
91      * transaction ordering. One possible solution to mitigate this race
92      * condition is to first reduce the spender's allowance to 0 and set the
93      * desired value afterwards:
94      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
95      *
96      * Emits an {Approval} event.
97      */
98     function approve(address spender, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Moves `amount` tokens from `sender` to `recipient` using the
102      * allowance mechanism. `amount` is then deducted from the caller's
103      * allowance.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Emitted when `value` tokens are moved from one account (`from`) to
113      * another (`to`).
114      *
115      * Note that `value` may be zero.
116      */
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119     /**
120      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
121      * a call to {approve}. `value` is the new allowance.
122      */
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      *
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      *
183      * - Multiplication cannot overflow.
184      */
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
187         // benefit is lost if 'b' is also tested.
188         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
189         if (a == 0) {
190             return 0;
191         }
192 
193         uint256 c = a * b;
194         require(c / a == b, "SafeMath: multiplication overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return mod(a, b, "SafeMath: modulo by zero");
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts with custom message when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
289         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
290         // for accounts without code, i.e. `keccak256('')`
291         bytes32 codehash;
292         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
293         // solhint-disable-next-line no-inline-assembly
294         assembly { codehash := extcodehash(account) }
295         return (codehash != accountHash && codehash != 0x0);
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
318         (bool success, ) = recipient.call{ value: amount }("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain`call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341       return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
351         return _functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but also transferring `value` wei to `target`.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least `value`.
361      * - the called Solidity function must be `payable`.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         return _functionCallWithValue(target, data, value, errorMessage);
378     }
379 
380     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
381         require(isContract(target), "Address: call to non-contract");
382 
383         // solhint-disable-next-line avoid-low-level-calls
384         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 // solhint-disable-next-line no-inline-assembly
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 contract Ownable is Context {
405     address private _owner;
406 
407     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
408 
409     /**
410      * @dev Initializes the contract setting the deployer as the initial owner.
411      */
412     constructor () internal {
413         address msgSender = _msgSender();
414         _owner = msgSender;
415         emit OwnershipTransferred(address(0), msgSender);
416     }
417 
418     /**
419      * @dev Returns the address of the current owner.
420      */
421     function owner() public view returns (address) {
422         return _owner;
423     }
424 
425     /**
426      * @dev Throws if called by any account other than the owner.
427      */
428     modifier onlyOwner() {
429         require(_owner == _msgSender(), "Ownable: caller is not the owner");
430         _;
431     }
432 
433     /**
434      * @dev Leaves the contract without owner. It will not be possible to call
435      * `onlyOwner` functions anymore. Can only be called by the current owner.
436      *
437      * NOTE: Renouncing ownership will leave the contract without an owner,
438      * thereby removing any functionality that is only available to the owner.
439      */
440     function renounceOwnership() public virtual onlyOwner {
441         emit OwnershipTransferred(_owner, address(0));
442         _owner = address(0);
443     }
444 
445     /**
446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
447      * Can only be called by the current owner.
448      */
449     function transferOwnership(address newOwner) public virtual onlyOwner {
450         require(newOwner != address(0), "Ownable: new owner is the zero address");
451         emit OwnershipTransferred(_owner, newOwner);
452         _owner = newOwner;
453     }
454 }
455 
456 
457 
458 contract SMI is Context, IERC20, Ownable {
459     using SafeMath for uint256;
460     using Address for address;
461 
462     mapping (address => uint256) private _rOwned;
463     mapping (address => uint256) private _tOwned;
464     mapping (address => mapping (address => uint256)) private _allowances;
465 
466     mapping (address => bool) private _isExcluded;
467     address[] private _excluded;
468    
469     uint256 private constant MAX = ~uint256(0);
470     uint256 private constant _tTotal = 100000 * 10**6 * 10**9;
471     uint256 private _rTotal = (MAX - (MAX % _tTotal));
472     uint256 private _tFeeTotal;
473 
474     string private _name = 'SafeMoon Inu';
475     string private _symbol = 'SMI';
476     uint8 private _decimals = 8;
477 
478     constructor () public {
479         _rOwned[_msgSender()] = _rTotal;
480         emit Transfer(address(0), _msgSender(), _tTotal);
481     }
482 
483     function name() public view returns (string memory) {
484         return _name;
485     }
486 
487     function symbol() public view returns (string memory) {
488         return _symbol;
489     }
490 
491     function decimals() public view returns (uint8) {
492         return _decimals;
493     }
494 
495     function totalSupply() public view override returns (uint256) {
496         return _tTotal;
497     }
498 
499     function balanceOf(address account) public view override returns (uint256) {
500         if (_isExcluded[account]) return _tOwned[account];
501         return tokenFromReflection(_rOwned[account]);
502     }
503 
504     function transfer(address recipient, uint256 amount) public override returns (bool) {
505         _transfer(_msgSender(), recipient, amount);
506         return true;
507     }
508 
509     function allowance(address owner, address spender) public view override returns (uint256) {
510         return _allowances[owner][spender];
511     }
512 
513     function approve(address spender, uint256 amount) public override returns (bool) {
514         _approve(_msgSender(), spender, amount);
515         return true;
516     }
517 
518     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
519         _transfer(sender, recipient, amount);
520         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
521         return true;
522     }
523 
524     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
525         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
526         return true;
527     }
528 
529     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
530         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
531         return true;
532     }
533 
534     function isExcluded(address account) public view returns (bool) {
535         return _isExcluded[account];
536     }
537 
538     function totalFees() public view returns (uint256) {
539         return _tFeeTotal;
540     }
541 
542     function reflect(uint256 tAmount) public {
543         address sender = _msgSender();
544         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
545         (uint256 rAmount,,,,) = _getValues(tAmount);
546         _rOwned[sender] = _rOwned[sender].sub(rAmount);
547         _rTotal = _rTotal.sub(rAmount);
548         _tFeeTotal = _tFeeTotal.add(tAmount);
549     }
550 
551     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
552         require(tAmount <= _tTotal, "Amount must be less than supply");
553         if (!deductTransferFee) {
554             (uint256 rAmount,,,,) = _getValues(tAmount);
555             return rAmount;
556         } else {
557             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
558             return rTransferAmount;
559         }
560     }
561 
562     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
563         require(rAmount <= _rTotal, "Amount must be less than total reflections");
564         uint256 currentRate =  _getRate();
565         return rAmount.div(currentRate);
566     }
567 
568     function excludeAccount(address account) external onlyOwner() {
569         require(!_isExcluded[account], "Account is already excluded");
570         if(_rOwned[account] > 0) {
571             _tOwned[account] = tokenFromReflection(_rOwned[account]);
572         }
573         _isExcluded[account] = true;
574         _excluded.push(account);
575     }
576 
577     function includeAccount(address account) external onlyOwner() {
578         require(_isExcluded[account], "Account is already excluded");
579         for (uint256 i = 0; i < _excluded.length; i++) {
580             if (_excluded[i] == account) {
581                 _excluded[i] = _excluded[_excluded.length - 1];
582                 _tOwned[account] = 0;
583                 _isExcluded[account] = false;
584                 _excluded.pop();
585                 break;
586             }
587         }
588     }
589 
590     function _approve(address owner, address spender, uint256 amount) private {
591         require(owner != address(0), "ERC20: approve from the zero address");
592         require(spender != address(0), "ERC20: approve to the zero address");
593 
594         _allowances[owner][spender] = amount;
595         emit Approval(owner, spender, amount);
596     }
597 
598     function _transfer(address sender, address recipient, uint256 amount) private {
599         require(sender != address(0), "ERC20: transfer from the zero address");
600         require(recipient != address(0), "ERC20: transfer to the zero address");
601         require(amount > 0, "Transfer amount must be greater than zero");
602         if (_isExcluded[sender] && !_isExcluded[recipient]) {
603             _transferFromExcluded(sender, recipient, amount);
604         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
605             _transferToExcluded(sender, recipient, amount);
606         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
607             _transferStandard(sender, recipient, amount);
608         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
609             _transferBothExcluded(sender, recipient, amount);
610         } else {
611             _transferStandard(sender, recipient, amount);
612         }
613     }
614 
615     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
616         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
617         _rOwned[sender] = _rOwned[sender].sub(rAmount);
618         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
619         _reflectFee(rFee, tFee);
620         emit Transfer(sender, recipient, tTransferAmount);
621     }
622 
623     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
624         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
625         _rOwned[sender] = _rOwned[sender].sub(rAmount);
626         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
627         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
628         _reflectFee(rFee, tFee);
629         emit Transfer(sender, recipient, tTransferAmount);
630     }
631 
632     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
633         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
634         _tOwned[sender] = _tOwned[sender].sub(tAmount);
635         _rOwned[sender] = _rOwned[sender].sub(rAmount);
636         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
637         _reflectFee(rFee, tFee);
638         emit Transfer(sender, recipient, tTransferAmount);
639     }
640 
641     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
642         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
643         _tOwned[sender] = _tOwned[sender].sub(tAmount);
644         _rOwned[sender] = _rOwned[sender].sub(rAmount);
645         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
646         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
647         _reflectFee(rFee, tFee);
648         emit Transfer(sender, recipient, tTransferAmount);
649     }
650 
651     function _reflectFee(uint256 rFee, uint256 tFee) private {
652         _rTotal = _rTotal.sub(rFee);
653         _tFeeTotal = _tFeeTotal.add(tFee);
654     }
655 
656     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
657         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
658         uint256 currentRate =  _getRate();
659         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
660         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
661     }
662 
663     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
664         uint256 tFee = tAmount.div(100).mul(2);
665         uint256 tTransferAmount = tAmount.sub(tFee);
666         return (tTransferAmount, tFee);
667     }
668 
669     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
670         uint256 rAmount = tAmount.mul(currentRate);
671         uint256 rFee = tFee.mul(currentRate);
672         uint256 rTransferAmount = rAmount.sub(rFee);
673         return (rAmount, rTransferAmount, rFee);
674     }
675 
676     function _getRate() private view returns(uint256) {
677         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
678         return rSupply.div(tSupply);
679     }
680 
681     function _getCurrentSupply() private view returns(uint256, uint256) {
682         uint256 rSupply = _rTotal;
683         uint256 tSupply = _tTotal;      
684         for (uint256 i = 0; i < _excluded.length; i++) {
685             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
686             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
687             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
688         }
689         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
690         return (rSupply, tSupply);
691     }
692 }