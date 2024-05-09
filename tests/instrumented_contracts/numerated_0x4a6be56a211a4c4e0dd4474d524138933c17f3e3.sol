1 // Baby Shiba (BHIBA). the cutest of them all
2 
3 //CMC and CG listing application in place. 
4 
5 //Marketing budget in place
6 
7 //Limit Buy to remove bots : on
8 
9 //Liqudity Locked
10 
11 //TG: https://t.me/BabyShiba
12 
13 //Website: http://babyshiba.finance/
14 
15 // SPDX-License-Identifier: Unlicensed
16 
17 pragma solidity ^0.6.12;    
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.s
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      *
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return sub(a, b, "SafeMath: subtraction overflow");
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `*` operator.
155      *
156      * Requirements:
157      *
158      * - Multiplication cannot overflow.
159      */
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164         if (a == 0) {
165             return 0;
166         }
167 
168         uint256 c = a * b;
169         require(c / a == b, "SafeMath: multiplication overflow");
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         return div(a, b, "SafeMath: division by zero");
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
202     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b > 0, errorMessage);
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223         return mod(a, b, "SafeMath: modulo by zero");
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts with custom message when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b != 0, errorMessage);
240         return a % b;
241     }
242 }
243 
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
264         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
265         // for accounts without code, i.e. `keccak256('')`
266         bytes32 codehash;
267         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
268         // solhint-disable-next-line no-inline-assembly
269         assembly { codehash := extcodehash(account) }
270         return (codehash != accountHash && codehash != 0x0);
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
293         (bool success, ) = recipient.call{ value: amount }("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain`call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316       return functionCall(target, data, "Address: low-level call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321      * `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
326         return _functionCallWithValue(target, data, 0, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but also transferring `value` wei to `target`.
332      *
333      * Requirements:
334      *
335      * - the calling contract must have an ETH balance of at least `value`.
336      * - the called Solidity function must be `payable`.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
351         require(address(this).balance >= value, "Address: insufficient balance for call");
352         return _functionCallWithValue(target, data, value, errorMessage);
353     }
354 
355     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
356         require(isContract(target), "Address: call to non-contract");
357 
358         // solhint-disable-next-line avoid-low-level-calls
359         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
360         if (success) {
361             return returndata;
362         } else {
363             // Look for revert reason and bubble it up if present
364             if (returndata.length > 0) {
365                 // The easiest way to bubble the revert reason is using memory via assembly
366 
367                 // solhint-disable-next-line no-inline-assembly
368                 assembly {
369                     let returndata_size := mload(returndata)
370                     revert(add(32, returndata), returndata_size)
371                 }
372             } else {
373                 revert(errorMessage);
374             }
375         }
376     }
377 }
378 
379 contract Ownable is Context {
380     address private _owner;
381 
382     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
383 
384     /**
385      * @dev Initializes the contract setting the deployer as the initial owner.
386      */
387     constructor () internal {
388         address msgSender = _msgSender();
389         _owner = msgSender;
390         emit OwnershipTransferred(address(0), msgSender);
391     }
392 
393     /**
394      * @dev Returns the address of the current owner.
395      */
396     function owner() public view returns (address) {
397         return _owner;
398     }
399 
400     /**
401      * @dev Throws if called by any account other than the owner.
402      */
403     modifier onlyOwner() {
404         require(_owner == _msgSender(), "Ownable: caller is not the owner");
405         _;
406     }
407 
408     /**
409      * @dev Leaves the contract without owner. It will not be possible to call
410      * `onlyOwner` functions anymore. Can only be called by the current owner.
411      *
412      * NOTE: Renouncing ownership will leave the contract without an owner,
413      * thereby removing any functionality that is only available to the owner.
414      */
415     function renounceOwnership() public virtual onlyOwner {
416         emit OwnershipTransferred(_owner, address(0));
417         _owner = address(0);
418     }
419 
420     /**
421      * @dev Transfers ownership of the contract to a new account (`newOwner`).
422      * Can only be called by the current owner.
423      */
424     function transferOwnership(address newOwner) public virtual onlyOwner {
425         require(newOwner != address(0), "Ownable: new owner is the zero address");
426         emit OwnershipTransferred(_owner, newOwner);
427         _owner = newOwner;
428     }
429 }
430 
431 
432 
433 contract BabyShiba is Context, IERC20, Ownable {
434     using SafeMath for uint256;
435     using Address for address;
436 
437     mapping (address => uint256) private _rOwned;
438     mapping (address => uint256) private _tOwned;
439     mapping (address => mapping (address => uint256)) private _allowances;
440 
441     mapping (address => bool) private _isExcluded;
442     address[] private _excluded;
443    
444     uint256 private constant MAX = ~uint256(0);
445     uint256 private constant _tTotal = 10000000 * 10**5 * 10**9;
446     uint256 private _rTotal = (MAX - (MAX % _tTotal));
447     uint256 private _tFeeTotal;
448 
449     string private _name = 'Baby Shiba';
450     string private _symbol = 'BHIBA';
451     uint8 private _decimals = 9;
452     
453     uint256 public _maxTxAmount = 10000000 * 10**5 * 10**9;
454 
455     constructor () public {
456         _rOwned[_msgSender()] = _rTotal;
457         emit Transfer(address(0), _msgSender(), _tTotal);
458     }
459 
460     function name() public view returns (string memory) {
461         return _name;
462     }
463 
464     function symbol() public view returns (string memory) {
465         return _symbol;
466     }
467 
468     function decimals() public view returns (uint8) {
469         return _decimals;
470     }
471 
472     function totalSupply() public view override returns (uint256) {
473         return _tTotal;
474     }
475 
476     function balanceOf(address account) public view override returns (uint256) {
477         if (_isExcluded[account]) return _tOwned[account];
478         return tokenFromReflection(_rOwned[account]);
479     }
480 
481     function transfer(address recipient, uint256 amount) public override returns (bool) {
482         _transfer(_msgSender(), recipient, amount);
483         return true;
484     }
485 
486     function allowance(address owner, address spender) public view override returns (uint256) {
487         return _allowances[owner][spender];
488     }
489 
490     function approve(address spender, uint256 amount) public override returns (bool) {
491         _approve(_msgSender(), spender, amount);
492         return true;
493     }
494 
495     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
496         _transfer(sender, recipient, amount);
497         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
498         return true;
499     }
500 
501     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
503         return true;
504     }
505 
506     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
507         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
508         return true;
509     }
510 
511     function isExcluded(address account) public view returns (bool) {
512         return _isExcluded[account];
513     }
514 
515     function totalFees() public view returns (uint256) {
516         return _tFeeTotal;
517     }
518     
519     
520     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
521         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
522             10**2
523         );
524     }
525 
526     function reflect(uint256 tAmount) public {
527         address sender = _msgSender();
528         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
529         (uint256 rAmount,,,,) = _getValues(tAmount);
530         _rOwned[sender] = _rOwned[sender].sub(rAmount);
531         _rTotal = _rTotal.sub(rAmount);
532         _tFeeTotal = _tFeeTotal.add(tAmount);
533     }
534 
535     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
536         require(tAmount <= _tTotal, "Amount must be less than supply");
537         if (!deductTransferFee) {
538             (uint256 rAmount,,,,) = _getValues(tAmount);
539             return rAmount;
540         } else {
541             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
542             return rTransferAmount;
543         }
544     }
545 
546     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
547         require(rAmount <= _rTotal, "Amount must be less than total reflections");
548         uint256 currentRate =  _getRate();
549         return rAmount.div(currentRate);
550     }
551 
552     function excludeAccount(address account) external onlyOwner() {
553         require(!_isExcluded[account], "Account is already excluded");
554         if(_rOwned[account] > 0) {
555             _tOwned[account] = tokenFromReflection(_rOwned[account]);
556         }
557         _isExcluded[account] = true;
558         _excluded.push(account);
559     }
560 
561     function includeAccount(address account) external onlyOwner() {
562         require(_isExcluded[account], "Account is already excluded");
563         for (uint256 i = 0; i < _excluded.length; i++) {
564             if (_excluded[i] == account) {
565                 _excluded[i] = _excluded[_excluded.length - 1];
566                 _tOwned[account] = 0;
567                 _isExcluded[account] = false;
568                 _excluded.pop();
569                 break;
570             }
571         }
572     }
573 
574     function _approve(address owner, address spender, uint256 amount) private {
575         require(owner != address(0), "ERC20: approve from the zero address");
576         require(spender != address(0), "ERC20: approve to the zero address");
577 
578         _allowances[owner][spender] = amount;
579         emit Approval(owner, spender, amount);
580     }
581 
582     function _transfer(address sender, address recipient, uint256 amount) private {
583         require(sender != address(0), "ERC20: transfer from the zero address");
584         require(recipient != address(0), "ERC20: transfer to the zero address");
585         require(amount > 0, "Transfer amount must be greater than zero");
586         if(sender != owner() && recipient != owner())
587           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
588             
589         if (_isExcluded[sender] && !_isExcluded[recipient]) {
590             _transferFromExcluded(sender, recipient, amount);
591         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
592             _transferToExcluded(sender, recipient, amount);
593         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
594             _transferStandard(sender, recipient, amount);
595         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
596             _transferBothExcluded(sender, recipient, amount);
597         } else {
598             _transferStandard(sender, recipient, amount);
599         }
600     }
601 
602     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
603         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
604         _rOwned[sender] = _rOwned[sender].sub(rAmount);
605         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
606         _reflectFee(rFee, tFee);
607         emit Transfer(sender, recipient, tTransferAmount);
608     }
609 
610     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
611         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
612         _rOwned[sender] = _rOwned[sender].sub(rAmount);
613         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
614         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
615         _reflectFee(rFee, tFee);
616         emit Transfer(sender, recipient, tTransferAmount);
617     }
618 
619     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
620         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
621         _tOwned[sender] = _tOwned[sender].sub(tAmount);
622         _rOwned[sender] = _rOwned[sender].sub(rAmount);
623         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
624         _reflectFee(rFee, tFee);
625         emit Transfer(sender, recipient, tTransferAmount);
626     }
627 
628     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
629         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
630         _tOwned[sender] = _tOwned[sender].sub(tAmount);
631         _rOwned[sender] = _rOwned[sender].sub(rAmount);
632         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
633         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
634         _reflectFee(rFee, tFee);
635         emit Transfer(sender, recipient, tTransferAmount);
636     }
637 
638     function _reflectFee(uint256 rFee, uint256 tFee) private {
639         _rTotal = _rTotal.sub(rFee);
640         _tFeeTotal = _tFeeTotal.add(tFee);
641     }
642 
643     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
644         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
645         uint256 currentRate =  _getRate();
646         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
647         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
648     }
649 
650     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
651         uint256 tFee = tAmount.div(100).mul(2);
652         uint256 tTransferAmount = tAmount.sub(tFee);
653         return (tTransferAmount, tFee);
654     }
655 
656     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
657         uint256 rAmount = tAmount.mul(currentRate);
658         uint256 rFee = tFee.mul(currentRate);
659         uint256 rTransferAmount = rAmount.sub(rFee);
660         return (rAmount, rTransferAmount, rFee);
661     }
662 
663     function _getRate() private view returns(uint256) {
664         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
665         return rSupply.div(tSupply);
666     }
667 
668     function _getCurrentSupply() private view returns(uint256, uint256) {
669         uint256 rSupply = _rTotal;
670         uint256 tSupply = _tTotal;      
671         for (uint256 i = 0; i < _excluded.length; i++) {
672             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
673             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
674             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
675         }
676         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
677         return (rSupply, tSupply);
678     }
679 }