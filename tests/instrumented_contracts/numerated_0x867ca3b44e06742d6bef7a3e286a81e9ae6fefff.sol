1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-04-21
7 */
8 
9 //Vitaliks IQ ($VitalikIQ), hello Buterin fans. Vitalik IQ is a deflationary coin with burn/distribute mechanics that is here to spread the knowledge and wealth of Vitalik Buterin.
10 
11 //Bot's will be blacklisted + their auto script will be declined.
12 
13 //Liqudity lOCKED
14 
15 //Website: http://vitalikiq.com/
16 
17 //TG: https://t.me/VitalikIQ
18 
19 // SPDX-License-Identifier: Unlicensed
20 
21 pragma solidity ^0.6.12;    
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b <= a, errorMessage);
149         uint256 c = a - b;
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      *
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166         // benefit is lost if 'b' is also tested.
167         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "SafeMath: multiplication overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b) internal pure returns (uint256) {
191         return div(a, b, "SafeMath: division by zero");
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b > 0, errorMessage);
208         uint256 c = a / b;
209         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return mod(a, b, "SafeMath: modulo by zero");
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts with custom message when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b != 0, errorMessage);
244         return a % b;
245     }
246 }
247 
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269         // for accounts without code, i.e. `keccak256('')`
270         bytes32 codehash;
271         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { codehash := extcodehash(account) }
274         return (codehash != accountHash && codehash != 0x0);
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 contract Ownable is Context {
384     address private _owner;
385 
386     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
387 
388     /**
389      * @dev Initializes the contract setting the deployer as the initial owner.
390      */
391     constructor () internal {
392         address msgSender = _msgSender();
393         _owner = msgSender;
394         emit OwnershipTransferred(address(0), msgSender);
395     }
396 
397     /**
398      * @dev Returns the address of the current owner.
399      */
400     function owner() public view returns (address) {
401         return _owner;
402     }
403 
404     /**
405      * @dev Throws if called by any account other than the owner.
406      */
407     modifier onlyOwner() {
408         require(_owner == _msgSender(), "Ownable: caller is not the owner");
409         _;
410     }
411 
412     /**
413      * @dev Leaves the contract without owner. It will not be possible to call
414      * `onlyOwner` functions anymore. Can only be called by the current owner.
415      *
416      * NOTE: Renouncing ownership will leave the contract without an owner,
417      * thereby removing any functionality that is only available to the owner.
418      */
419     function renounceOwnership() public virtual onlyOwner {
420         emit OwnershipTransferred(_owner, address(0));
421         _owner = address(0);
422     }
423 
424     /**
425      * @dev Transfers ownership of the contract to a new account (`newOwner`).
426      * Can only be called by the current owner.
427      */
428     function transferOwnership(address newOwner) public virtual onlyOwner {
429         require(newOwner != address(0), "Ownable: new owner is the zero address");
430         emit OwnershipTransferred(_owner, newOwner);
431         _owner = newOwner;
432     }
433 }
434 
435 
436 
437 contract VitalikIQ is Context, IERC20, Ownable {
438     using SafeMath for uint256;
439     using Address for address;
440 
441     mapping (address => uint256) private _rOwned;
442     mapping (address => uint256) private _tOwned;
443     mapping (address => mapping (address => uint256)) private _allowances;
444 
445     mapping (address => bool) private _isExcluded;
446     address[] private _excluded;
447    
448     uint256 private constant MAX = ~uint256(0);
449     uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;
450     uint256 private _rTotal = (MAX - (MAX % _tTotal));
451     uint256 private _tFeeTotal;
452 
453     string private _name = 'Vitalik IQ';
454     string private _symbol = 'VitalikIQ';
455     uint8 private _decimals = 9;
456     
457     uint256 public _maxTxAmount = 100000000 * 10**6 * 10**9;
458 
459     constructor () public {
460         _rOwned[_msgSender()] = _rTotal;
461         emit Transfer(address(0), _msgSender(), _tTotal);
462     }
463 
464     function name() public view returns (string memory) {
465         return _name;
466     }
467 
468     function symbol() public view returns (string memory) {
469         return _symbol;
470     }
471 
472     function decimals() public view returns (uint8) {
473         return _decimals;
474     }
475 
476     function totalSupply() public view override returns (uint256) {
477         return _tTotal;
478     }
479 
480     function balanceOf(address account) public view override returns (uint256) {
481         if (_isExcluded[account]) return _tOwned[account];
482         return tokenFromReflection(_rOwned[account]);
483     }
484 
485     function transfer(address recipient, uint256 amount) public override returns (bool) {
486         _transfer(_msgSender(), recipient, amount);
487         return true;
488     }
489 
490     function allowance(address owner, address spender) public view override returns (uint256) {
491         return _allowances[owner][spender];
492     }
493 
494     function approve(address spender, uint256 amount) public override returns (bool) {
495         _approve(_msgSender(), spender, amount);
496         return true;
497     }
498 
499     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
500         _transfer(sender, recipient, amount);
501         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
502         return true;
503     }
504 
505     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
506         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
507         return true;
508     }
509 
510     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
512         return true;
513     }
514 
515     function isExcluded(address account) public view returns (bool) {
516         return _isExcluded[account];
517     }
518 
519     function totalFees() public view returns (uint256) {
520         return _tFeeTotal;
521     }
522     
523     
524     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
525         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
526             10**2
527         );
528     }
529 
530     function reflect(uint256 tAmount) public {
531         address sender = _msgSender();
532         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
533         (uint256 rAmount,,,,) = _getValues(tAmount);
534         _rOwned[sender] = _rOwned[sender].sub(rAmount);
535         _rTotal = _rTotal.sub(rAmount);
536         _tFeeTotal = _tFeeTotal.add(tAmount);
537     }
538 
539     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
540         require(tAmount <= _tTotal, "Amount must be less than supply");
541         if (!deductTransferFee) {
542             (uint256 rAmount,,,,) = _getValues(tAmount);
543             return rAmount;
544         } else {
545             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
546             return rTransferAmount;
547         }
548     }
549 
550     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
551         require(rAmount <= _rTotal, "Amount must be less than total reflections");
552         uint256 currentRate =  _getRate();
553         return rAmount.div(currentRate);
554     }
555 
556     function excludeAccount(address account) external onlyOwner() {
557         require(!_isExcluded[account], "Account is already excluded");
558         if(_rOwned[account] > 0) {
559             _tOwned[account] = tokenFromReflection(_rOwned[account]);
560         }
561         _isExcluded[account] = true;
562         _excluded.push(account);
563     }
564 
565     function includeAccount(address account) external onlyOwner() {
566         require(_isExcluded[account], "Account is already excluded");
567         for (uint256 i = 0; i < _excluded.length; i++) {
568             if (_excluded[i] == account) {
569                 _excluded[i] = _excluded[_excluded.length - 1];
570                 _tOwned[account] = 0;
571                 _isExcluded[account] = false;
572                 _excluded.pop();
573                 break;
574             }
575         }
576     }
577 
578     function _approve(address owner, address spender, uint256 amount) private {
579         require(owner != address(0), "ERC20: approve from the zero address");
580         require(spender != address(0), "ERC20: approve to the zero address");
581 
582         _allowances[owner][spender] = amount;
583         emit Approval(owner, spender, amount);
584     }
585 
586     function _transfer(address sender, address recipient, uint256 amount) private {
587         require(sender != address(0), "ERC20: transfer from the zero address");
588         require(recipient != address(0), "ERC20: transfer to the zero address");
589         require(amount > 0, "Transfer amount must be greater than zero");
590         if(sender != owner() && recipient != owner())
591           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
592             
593         if (_isExcluded[sender] && !_isExcluded[recipient]) {
594             _transferFromExcluded(sender, recipient, amount);
595         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
596             _transferToExcluded(sender, recipient, amount);
597         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
598             _transferStandard(sender, recipient, amount);
599         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
600             _transferBothExcluded(sender, recipient, amount);
601         } else {
602             _transferStandard(sender, recipient, amount);
603         }
604     }
605 
606     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
607         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
608         _rOwned[sender] = _rOwned[sender].sub(rAmount);
609         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
610         _reflectFee(rFee, tFee);
611         emit Transfer(sender, recipient, tTransferAmount);
612     }
613 
614     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
615         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
616         _rOwned[sender] = _rOwned[sender].sub(rAmount);
617         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
618         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
619         _reflectFee(rFee, tFee);
620         emit Transfer(sender, recipient, tTransferAmount);
621     }
622 
623     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
624         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
625         _tOwned[sender] = _tOwned[sender].sub(tAmount);
626         _rOwned[sender] = _rOwned[sender].sub(rAmount);
627         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
628         _reflectFee(rFee, tFee);
629         emit Transfer(sender, recipient, tTransferAmount);
630     }
631 
632     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
633         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
634         _tOwned[sender] = _tOwned[sender].sub(tAmount);
635         _rOwned[sender] = _rOwned[sender].sub(rAmount);
636         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
637         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
638         _reflectFee(rFee, tFee);
639         emit Transfer(sender, recipient, tTransferAmount);
640     }
641 
642     function _reflectFee(uint256 rFee, uint256 tFee) private {
643         _rTotal = _rTotal.sub(rFee);
644         _tFeeTotal = _tFeeTotal.add(tFee);
645     }
646 
647     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
648         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
649         uint256 currentRate =  _getRate();
650         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
651         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
652     }
653 
654     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
655         uint256 tFee = tAmount.div(100).mul(2);
656         uint256 tTransferAmount = tAmount.sub(tFee);
657         return (tTransferAmount, tFee);
658     }
659 
660     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
661         uint256 rAmount = tAmount.mul(currentRate);
662         uint256 rFee = tFee.mul(currentRate);
663         uint256 rTransferAmount = rAmount.sub(rFee);
664         return (rAmount, rTransferAmount, rFee);
665     }
666 
667     function _getRate() private view returns(uint256) {
668         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
669         return rSupply.div(tSupply);
670     }
671 
672     function _getCurrentSupply() private view returns(uint256, uint256) {
673         uint256 rSupply = _rTotal;
674         uint256 tSupply = _tTotal;      
675         for (uint256 i = 0; i < _excluded.length; i++) {
676             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
677             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
678             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
679         }
680         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
681         return (rSupply, tSupply);
682     }
683 }