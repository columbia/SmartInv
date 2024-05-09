1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.6.12;
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
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 library SafeMath {
81     /**
82      * @dev Returns the addition of two unsigned integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `+` operator.
86      *
87      * Requirements:
88      *
89      * - Addition cannot overflow.
90      */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a, "SafeMath: addition overflow");
94 
95         return c;
96     }
97     /**
98      * @dev Returns the subtraction of two unsigned integers, reverting on
99      * overflow (when the result is negative).
100      *
101      * Counterpart to Solidity's `-` operator.
102      *
103      * Requirements:
104      *
105      * - Subtraction cannot overflow.
106      */
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         return sub(a, b, "SafeMath: subtraction overflow");
109     }
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b <= a, errorMessage);
122         uint256 c = a - b;
123         return c;
124     }
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      *
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137         // benefit is lost if 'b' is also tested.
138         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
139         if (a == 0) {
140             return 0;
141         }
142         uint256 c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144         return c;
145     }
146     /**
147      * @dev Returns the integer division of two unsigned integers. Reverts on
148      * division by zero. The result is rounded towards zero.
149      *
150      * Counterpart to Solidity's `/` operator. Note: this function uses a
151      * `revert` opcode (which leaves remaining gas untouched) while Solidity
152      * uses an invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         return div(a, b, "SafeMath: division by zero");
160     }
161     /**
162      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
163      * division by zero. The result is rounded towards zero.
164      *
165      * Counterpart to Solidity's `/` operator. Note: this function uses a
166      * `revert` opcode (which leaves remaining gas untouched) while Solidity
167      * uses an invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b > 0, errorMessage);
175         uint256 c = a / b;
176         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
177         return c;
178     }
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
192         return mod(a, b, "SafeMath: modulo by zero");
193     }
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * Reverts with custom message when dividing by zero.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b != 0, errorMessage);
208         return a % b;
209     }
210 }
211 
212 library Address {
213     /**
214      * @dev Returns true if `account` is a contract.
215      *
216      * [IMPORTANT]
217      * ====
218      * It is unsafe to assume that an address for which this function returns
219      * false is an externally-owned account (EOA) and not a contract.
220      *
221      * Among others, `isContract` will return false for the following
222      * types of addresses:
223      *
224      *  - an externally-owned account
225      *  - a contract in construction
226      *  - an address where a contract will be created
227      *  - an address where a contract lived, but was destroyed
228      * ====
229      */
230     function isContract(address account) internal view returns (bool) {
231         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
232         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
233         // for accounts without code, i.e. `keccak256('')`
234         bytes32 codehash;
235         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
236         // solhint-disable-next-line no-inline-assembly
237         assembly { codehash := extcodehash(account) }
238         return (codehash != accountHash && codehash != 0x0);
239     }
240     /**
241      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
242      * `recipient`, forwarding all available gas and reverting on errors.
243      *
244      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
245      * of certain opcodes, possibly making contracts go over the 2300 gas limit
246      * imposed by `transfer`, making them unable to receive funds via
247      * `transfer`. {sendValue} removes this limitation.
248      *
249      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
250      *
251      * IMPORTANT: because control is transferred to `recipient`, care must be
252      * taken to not create reentrancy vulnerabilities. Consider using
253      * {ReentrancyGuard} or the
254      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
255      */
256     function sendValue(address payable recipient, uint256 amount) internal {
257         require(address(this).balance >= amount, "Address: insufficient balance");
258 
259         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
260         (bool success, ) = recipient.call{ value: amount }("");
261         require(success, "Address: unable to send value, recipient may have reverted");
262     }
263     /**
264      * @dev Performs a Solidity function call using a low level `call`. A
265      * plain`call` is an unsafe replacement for a function call: use this
266      * function instead.
267      *
268      * If `target` reverts with a revert reason, it is bubbled up by this
269      * function (like regular Solidity function calls).
270      *
271      * Returns the raw returned data. To convert to the expected return value,
272      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
273      *
274      * Requirements:
275      *
276      * - `target` must be a contract.
277      * - calling `target` with `data` must not revert.
278      *
279      * _Available since v3.1._
280      */
281     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
282       return functionCall(target, data, "Address: low-level call failed");
283     }
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
286      * `errorMessage` as a fallback revert reason when `target` reverts.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
291         return _functionCallWithValue(target, data, 0, errorMessage);
292     }
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
295      * but also transferring `value` wei to `target`.
296      *
297      * Requirements:
298      *
299      * - the calling contract must have an ETH balance of at least `value`.
300      * - the called Solidity function must be `payable`.
301      *
302      * _Available since v3.1._
303      */
304     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
306     }
307     /**
308      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
309      * with `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
314         require(address(this).balance >= value, "Address: insufficient balance for call");
315         return _functionCallWithValue(target, data, value, errorMessage);
316     }
317 
318     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
319         require(isContract(target), "Address: call to non-contract");
320 
321         // solhint-disable-next-line avoid-low-level-calls
322         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
323         if (success) {
324             return returndata;
325         } else {
326             // Look for revert reason and bubble it up if present
327             if (returndata.length > 0) {
328                 // The easiest way to bubble the revert reason is using memory via assembly
329 
330                 // solhint-disable-next-line no-inline-assembly
331                 assembly {
332                     let returndata_size := mload(returndata)
333                     revert(add(32, returndata), returndata_size)
334                 }
335             } else {
336                 revert(errorMessage);
337             }
338         }
339     }
340 }
341 
342 contract Ownable is Context {
343     address private _owner;
344 
345     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
346     /**
347      * @dev Initializes the contract setting the deployer as the initial owner.
348      */
349     constructor () internal {
350         address msgSender = _msgSender();
351         _owner = msgSender;
352         emit OwnershipTransferred(address(0), msgSender);
353     }
354     /**
355      * @dev Returns the address of the current owner.
356      */
357     function owner() public view returns (address) {
358         return _owner;
359     }
360     /**
361      * @dev Throws if called by any account other than the owner.
362      */
363     modifier onlyOwner() {
364         require(_owner == _msgSender(), "Ownable: caller is not the owner");
365         _;
366     }
367     /**
368      * @dev Leaves the contract without owner. It will not be possible to call
369      * `onlyOwner` functions anymore. Can only be called by the current owner.
370      *
371      * NOTE: Renouncing ownership will leave the contract without an owner,
372      * thereby removing any functionality that is only available to the owner.
373      */
374     function renounceOwnership() public virtual onlyOwner {
375         emit OwnershipTransferred(_owner, address(0));
376         _owner = address(0);
377     }
378     /**
379      * @dev Transfers ownership of the contract to a new account (`newOwner`).
380      * Can only be called by the current owner.
381      */
382     function transferOwnership(address newOwner) public virtual onlyOwner {
383         require(newOwner != address(0), "Ownable: new owner is the zero address");
384         emit OwnershipTransferred(_owner, newOwner);
385         _owner = newOwner;
386     }
387 }
388 
389 contract Polkamoon is Context, IERC20, Ownable {
390     using SafeMath for uint256;
391     using Address for address;
392 
393     mapping (address => uint256) private _rOwned;
394     mapping (address => uint256) private _tOwned;
395     mapping (address => mapping (address => uint256)) private _allowances;
396 
397     mapping (address => bool) private _isExcluded;
398     address[] private _excluded;
399    
400     uint256 private constant MAX = ~uint256(0);
401     uint256 private constant _tTotal = 770000000000000 * 10**9;
402     uint256 private _rTotal = (MAX - (MAX % _tTotal));
403     uint256 private _tBurnTotal;
404 
405     string private _name = 'Polkamoon';
406     string private _symbol = 'PMOON';
407     uint8 private _decimals = 9;
408 
409     constructor () public {
410         _rOwned[_msgSender()] = _rTotal;
411         emit Transfer(address(0), _msgSender(), _tTotal);
412     }
413 
414     function name() public view returns (string memory) {
415         return _name;
416     }
417 
418     function symbol() public view returns (string memory) {
419         return _symbol;
420     }
421 
422     function decimals() public view returns (uint8) {
423         return _decimals;
424     }
425 
426     function totalSupply() public view override returns (uint256) {
427         return _tTotal;
428     }
429 
430     function balanceOf(address account) public view override returns (uint256) {
431         if (_isExcluded[account]) return _tOwned[account];
432         return tokenFromReflection(_rOwned[account]);
433     }
434 
435     function transfer(address recipient, uint256 amount) public override returns (bool) {
436         _transfer(_msgSender(), recipient, amount);
437         return true;
438     }
439 
440     function allowance(address owner, address spender) public view override returns (uint256) {
441         return _allowances[owner][spender];
442     }
443 
444     function approve(address spender, uint256 amount) public override returns (bool) {
445         _approve(_msgSender(), spender, amount);
446         return true;
447     }
448 
449     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
450         _transfer(sender, recipient, amount);
451         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
452         return true;
453     }
454 
455     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
456         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
457         return true;
458     }
459 
460     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
461         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
462         return true;
463     }
464 
465     function isExcluded(address account) public view returns (bool) {
466         return _isExcluded[account];
467     }
468 
469     function totalBurn() public view returns (uint256) {
470         return _tBurnTotal;
471     }
472 
473     function reflect(uint256 tAmount) public {
474         address sender = _msgSender();
475         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
476         (uint256 rAmount,,,,,,,) = _getValues(tAmount);
477         _rOwned[sender] = _rOwned[sender].sub(rAmount);
478         _rTotal = _rTotal.sub(rAmount);
479         _tBurnTotal = _tBurnTotal.add(tAmount);
480     }
481 
482     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
483         require(tAmount <= _tTotal, "Amount must be less than supply");
484         if (!deductTransferFee) {
485             (uint256 rAmount,,,,,,,) = _getValues(tAmount);
486             return rAmount;
487         } else {
488             (,uint256 rTransferAmount,,,,,,) = _getValues(tAmount);
489             return rTransferAmount;
490         }
491     }
492 
493     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
494         require(rAmount <= _rTotal, "Amount must be less than total reflections");
495         uint256 currentRate =  _getRate();
496         return rAmount.div(currentRate);
497     }
498 
499     function excludeAccount(address account) external onlyOwner() {
500         require(!_isExcluded[account], "Account is already excluded");
501         if(_rOwned[account] > 0) {
502             _tOwned[account] = tokenFromReflection(_rOwned[account]);
503         }
504         _isExcluded[account] = true;
505         _excluded.push(account);
506     }
507 
508     function includeAccount(address account) external onlyOwner() {
509         require(_isExcluded[account], "Account is already included");
510         for (uint256 i = 0; i < _excluded.length; i++) {
511             if (_excluded[i] == account) {
512                 _excluded[i] = _excluded[_excluded.length - 1];
513                 _tOwned[account] = 0;
514                 _isExcluded[account] = false;
515                 _excluded.pop();
516                 break;
517             }
518         }
519     }
520 
521     function _approve(address owner, address spender, uint256 amount) private {
522         require(owner != address(0), "ERC20: approve from the zero address");
523         require(spender != address(0), "ERC20: approve to the zero address");
524 
525         _allowances[owner][spender] = amount;
526         emit Approval(owner, spender, amount);
527     }
528 
529     function _transfer(address sender, address recipient, uint256 amount) private {
530         require(sender != address(0), "ERC20: transfer from the zero address");
531         require(recipient != address(0), "ERC20: transfer to the zero address");
532         require(amount > 0, "Transfer amount must be greater than zero");
533         if (_isExcluded[sender] && !_isExcluded[recipient]) {
534             _transferFromExcluded(sender, recipient, amount);
535         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
536             _transferToExcluded(sender, recipient, amount);
537         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
538             _transferStandard(sender, recipient, amount);
539         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
540             _transferBothExcluded(sender, recipient, amount);
541         } else {
542             _transferStandard(sender, recipient, amount);
543         }
544     }
545 
546     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
547         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee,uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) = _getValues(tAmount);
548         _rOwned[sender] = _rOwned[sender].sub(rAmount);
549         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
550         _reflectFee(rFee, tFee, tBurnValue,tTax,tLiquidity);
551         emit Transfer(sender, recipient, tTransferAmount);
552     }
553 
554     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
555         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee,uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) = _getValues(tAmount);
556         _rOwned[sender] = _rOwned[sender].sub(rAmount);
557         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
558         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
559         _reflectFee(rFee, tFee, tBurnValue,tTax,tLiquidity);
560         emit Transfer(sender, recipient, tTransferAmount);
561     }
562 
563     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
564         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee,uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) = _getValues(tAmount);
565         _tOwned[sender] = _tOwned[sender].sub(tAmount);
566         _rOwned[sender] = _rOwned[sender].sub(rAmount);
567         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
568        _reflectFee(rFee, tFee, tBurnValue,tTax,tLiquidity);
569         emit Transfer(sender, recipient, tTransferAmount);
570     }
571 
572     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
573         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee,uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) = _getValues(tAmount);
574         _tOwned[sender] = _tOwned[sender].sub(tAmount);
575         _rOwned[sender] = _rOwned[sender].sub(rAmount);
576         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
577         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
578         _reflectFee(rFee, tFee, tBurnValue,tTax,tLiquidity);
579         emit Transfer(sender, recipient, tTransferAmount);
580     }
581 
582     function _reflectFee(uint256 rFee, uint256 tFee, uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) private {
583         _rTotal = _rTotal.sub(rFee);
584         _tBurnTotal = _tBurnTotal.add(tFee).add(tBurnValue).add(tTax).add(tLiquidity);
585     }
586 
587     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256,uint256,uint256,uint256) {
588         uint256[12] memory _localVal;
589         (_localVal[0]/**tTransferAmount*/, _localVal[1]  /**tFee*/, _localVal[2] /**tBurnValue*/,_localVal[8]/*tTAx*/,_localVal[10]/**tLiquidity*/) = _getTValues(tAmount);
590         _localVal[3] /**currentRate*/ =  _getRate();
591         ( _localVal[4] /**rAmount*/,  _localVal[5] /**rTransferAmount*/, _localVal[6] /**rFee*/, _localVal[7] /**rBurnValue*/,_localVal[9]/*rTax*/,_localVal[11]/**rLiquidity*/) = _getRValues(tAmount, _localVal[1], _localVal[3], _localVal[2],_localVal[8],_localVal[10]);
592         return (_localVal[4], _localVal[5], _localVal[6], _localVal[0], _localVal[1], _localVal[2],_localVal[8],_localVal[10]);
593     }
594     
595     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256, uint256,uint256,uint256) {
596         uint256[5] memory _localVal;
597         
598         _localVal[0]/**tTax*/ = tAmount.div(10);
599         _localVal[1]/**tBurnValue*/ = tAmount.div(100).mul(5);
600         _localVal[2]/**tFee*/ = tAmount.div(100).mul(2);
601         _localVal[3]/**tLiquidity*/ = tAmount.div(100).mul(3);
602         _localVal[4]/**tTransferAmount*/ = tAmount.sub(_localVal[2]).sub(_localVal[1]).sub(_localVal[0]).sub(_localVal[3]);
603         return (_localVal[4], _localVal[2], _localVal[1],_localVal[0], _localVal[3]);
604     }
605 
606     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate, uint256 tBurnValue,uint256 tTax,uint tLiquidity) private pure returns (uint256, uint256, uint256,uint256,uint256,uint256) {
607         uint256 rAmount = tAmount.mul(currentRate);
608         uint256 rFee = tFee.mul(currentRate);
609         uint256 rBurnValue = tBurnValue.mul(currentRate);
610         uint256 rLiqidity = tLiquidity.mul(currentRate);
611         uint256 rTax = tTax.mul(currentRate);
612         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurnValue).sub(rTax).sub(rLiqidity);
613         return (rAmount, rTransferAmount, rFee, rBurnValue,rTax,rLiqidity);
614     }
615 
616     function _getRate() private view returns(uint256) {
617         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
618         return rSupply.div(tSupply);
619     }
620 
621     function _getCurrentSupply() private view returns(uint256, uint256) {
622         uint256 rSupply = _rTotal;
623         uint256 tSupply = _tTotal;      
624         for (uint256 i = 0; i < _excluded.length; i++) {
625             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
626             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
627             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
628         }
629         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
630         return (rSupply, tSupply);
631     }
632 }