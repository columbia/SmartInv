1 pragma solidity ^0.6.12;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 library SafeMath {
79     /**
80      * @dev Returns the addition of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `+` operator.
84      *
85      * Requirements:
86      *
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92 
93         return c;
94     }
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b <= a, errorMessage);
120         uint256 c = a - b;
121         return c;
122     }
123     /**
124      * @dev Returns the multiplication of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `*` operator.
128      *
129      * Requirements:
130      *
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
137         if (a == 0) {
138             return 0;
139         }
140         uint256 c = a * b;
141         require(c / a == b, "SafeMath: multiplication overflow");
142         return c;
143     }
144     /**
145      * @dev Returns the integer division of two unsigned integers. Reverts on
146      * division by zero. The result is rounded towards zero.
147      *
148      * Counterpart to Solidity's `/` operator. Note: this function uses a
149      * `revert` opcode (which leaves remaining gas untouched) while Solidity
150      * uses an invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         return div(a, b, "SafeMath: division by zero");
158     }
159     /**
160      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator. Note: this function uses a
164      * `revert` opcode (which leaves remaining gas untouched) while Solidity
165      * uses an invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b > 0, errorMessage);
173         uint256 c = a / b;
174         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
175         return c;
176     }
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         return mod(a, b, "SafeMath: modulo by zero");
191     }
192     /**
193      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
194      * Reverts with custom message when dividing by zero.
195      *
196      * Counterpart to Solidity's `%` operator. This function uses a `revert`
197      * opcode (which leaves remaining gas untouched) while Solidity uses an
198      * invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b != 0, errorMessage);
206         return a % b;
207     }
208 }
209 
210 library Address {
211     /**
212      * @dev Returns true if `account` is a contract.
213      *
214      * [IMPORTANT]
215      * ====
216      * It is unsafe to assume that an address for which this function returns
217      * false is an externally-owned account (EOA) and not a contract.
218      *
219      * Among others, `isContract` will return false for the following
220      * types of addresses:
221      *
222      *  - an externally-owned account
223      *  - a contract in construction
224      *  - an address where a contract will be created
225      *  - an address where a contract lived, but was destroyed
226      * ====
227      */
228     function isContract(address account) internal view returns (bool) {
229         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
230         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
231         // for accounts without code, i.e. `keccak256('')`
232         bytes32 codehash;
233         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
234         // solhint-disable-next-line no-inline-assembly
235         assembly { codehash := extcodehash(account) }
236         return (codehash != accountHash && codehash != 0x0);
237     }
238     /**
239      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
240      * `recipient`, forwarding all available gas and reverting on errors.
241      *
242      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
243      * of certain opcodes, possibly making contracts go over the 2300 gas limit
244      * imposed by `transfer`, making them unable to receive funds via
245      * `transfer`. {sendValue} removes this limitation.
246      *
247      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
248      *
249      * IMPORTANT: because control is transferred to `recipient`, care must be
250      * taken to not create reentrancy vulnerabilities. Consider using
251      * {ReentrancyGuard} or the
252      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
253      */
254     function sendValue(address payable recipient, uint256 amount) internal {
255         require(address(this).balance >= amount, "Address: insufficient balance");
256 
257         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
258         (bool success, ) = recipient.call{ value: amount }("");
259         require(success, "Address: unable to send value, recipient may have reverted");
260     }
261     /**
262      * @dev Performs a Solidity function call using a low level `call`. A
263      * plain`call` is an unsafe replacement for a function call: use this
264      * function instead.
265      *
266      * If `target` reverts with a revert reason, it is bubbled up by this
267      * function (like regular Solidity function calls).
268      *
269      * Returns the raw returned data. To convert to the expected return value,
270      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
271      *
272      * Requirements:
273      *
274      * - `target` must be a contract.
275      * - calling `target` with `data` must not revert.
276      *
277      * _Available since v3.1._
278      */
279     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
280       return functionCall(target, data, "Address: low-level call failed");
281     }
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
284      * `errorMessage` as a fallback revert reason when `target` reverts.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
289         return _functionCallWithValue(target, data, 0, errorMessage);
290     }
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but also transferring `value` wei to `target`.
294      *
295      * Requirements:
296      *
297      * - the calling contract must have an ETH balance of at least `value`.
298      * - the called Solidity function must be `payable`.
299      *
300      * _Available since v3.1._
301      */
302     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
304     }
305     /**
306      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
307      * with `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
312         require(address(this).balance >= value, "Address: insufficient balance for call");
313         return _functionCallWithValue(target, data, value, errorMessage);
314     }
315 
316     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
317         require(isContract(target), "Address: call to non-contract");
318 
319         // solhint-disable-next-line avoid-low-level-calls
320         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
321         if (success) {
322             return returndata;
323         } else {
324             // Look for revert reason and bubble it up if present
325             if (returndata.length > 0) {
326                 // The easiest way to bubble the revert reason is using memory via assembly
327 
328                 // solhint-disable-next-line no-inline-assembly
329                 assembly {
330                     let returndata_size := mload(returndata)
331                     revert(add(32, returndata), returndata_size)
332                 }
333             } else {
334                 revert(errorMessage);
335             }
336         }
337     }
338 }
339 
340 contract Ownable is Context {
341     address private _owner;
342 
343     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
344     /**
345      * @dev Initializes the contract setting the deployer as the initial owner.
346      */
347     constructor () internal {
348         address msgSender = _msgSender();
349         _owner = msgSender;
350         emit OwnershipTransferred(address(0), msgSender);
351     }
352     /**
353      * @dev Returns the address of the current owner.
354      */
355     function owner() public view returns (address) {
356         return _owner;
357     }
358     /**
359      * @dev Throws if called by any account other than the owner.
360      */
361     modifier onlyOwner() {
362         require(_owner == _msgSender(), "Ownable: caller is not the owner");
363         _;
364     }
365     /**
366      * @dev Leaves the contract without owner. It will not be possible to call
367      * `onlyOwner` functions anymore. Can only be called by the current owner.
368      *
369      * NOTE: Renouncing ownership will leave the contract without an owner,
370      * thereby removing any functionality that is only available to the owner.
371      */
372     function renounceOwnership() public virtual onlyOwner {
373         emit OwnershipTransferred(_owner, address(0));
374         _owner = address(0);
375     }
376     /**
377      * @dev Transfers ownership of the contract to a new account (`newOwner`).
378      * Can only be called by the current owner.
379      */
380     function transferOwnership(address newOwner) public virtual onlyOwner {
381         require(newOwner != address(0), "Ownable: new owner is the zero address");
382         emit OwnershipTransferred(_owner, newOwner);
383         _owner = newOwner;
384     }
385 }
386 
387 contract RapDoge is Context, IERC20, Ownable {
388     using SafeMath for uint256;
389     using Address for address;
390 
391     mapping (address => uint256) private _rOwned;
392     mapping (address => uint256) private _tOwned;
393     mapping (address => mapping (address => uint256)) private _allowances;
394 
395     mapping (address => bool) private _isExcluded;
396     address[] private _excluded;
397    
398     uint256 private constant MAX = ~uint256(0);
399     uint256 private constant _tTotal = 1000000000000000 * 10**18;
400     uint256 private _rTotal = (MAX - (MAX % _tTotal));
401     uint256 private _tBurnTotal;
402 
403     string private _name = 'RapDoge';
404     string private _symbol = 'RAPDOGE';
405     uint8 private _decimals = 18;
406 
407     constructor () public {
408         _rOwned[_msgSender()] = _rTotal;
409         emit Transfer(address(0), _msgSender(), _tTotal);
410     }
411 
412     function name() public view returns (string memory) {
413         return _name;
414     }
415 
416     function symbol() public view returns (string memory) {
417         return _symbol;
418     }
419 
420     function decimals() public view returns (uint8) {
421         return _decimals;
422     }
423 
424     function totalSupply() public view override returns (uint256) {
425         return _tTotal;
426     }
427 
428     function balanceOf(address account) public view override returns (uint256) {
429         if (_isExcluded[account]) return _tOwned[account];
430         return tokenFromReflection(_rOwned[account]);
431     }
432 
433     function transfer(address recipient, uint256 amount) public override returns (bool) {
434         _transfer(_msgSender(), recipient, amount);
435         return true;
436     }
437 
438     function allowance(address owner, address spender) public view override returns (uint256) {
439         return _allowances[owner][spender];
440     }
441 
442     function approve(address spender, uint256 amount) public override returns (bool) {
443         _approve(_msgSender(), spender, amount);
444         return true;
445     }
446 
447     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
448         _transfer(sender, recipient, amount);
449         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
450         return true;
451     }
452 
453     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
454         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
455         return true;
456     }
457 
458     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
459         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
460         return true;
461     }
462 
463     function isExcluded(address account) public view returns (bool) {
464         return _isExcluded[account];
465     }
466 
467     function totalBurn() public view returns (uint256) {
468         return _tBurnTotal;
469     }
470 
471     function reflect(uint256 tAmount) public {
472         address sender = _msgSender();
473         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
474         (uint256 rAmount,,,,,,,) = _getValues(tAmount);
475         _rOwned[sender] = _rOwned[sender].sub(rAmount);
476         _rTotal = _rTotal.sub(rAmount);
477         _tBurnTotal = _tBurnTotal.add(tAmount);
478     }
479 
480     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
481         require(tAmount <= _tTotal, "Amount must be less than supply");
482         if (!deductTransferFee) {
483             (uint256 rAmount,,,,,,,) = _getValues(tAmount);
484             return rAmount;
485         } else {
486             (,uint256 rTransferAmount,,,,,,) = _getValues(tAmount);
487             return rTransferAmount;
488         }
489     }
490 
491     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
492         require(rAmount <= _rTotal, "Amount must be less than total reflections");
493         uint256 currentRate =  _getRate();
494         return rAmount.div(currentRate);
495     }
496 
497     function excludeAccount(address account) external onlyOwner() {
498         require(!_isExcluded[account], "Account is already excluded");
499         if(_rOwned[account] > 0) {
500             _tOwned[account] = tokenFromReflection(_rOwned[account]);
501         }
502         _isExcluded[account] = true;
503         _excluded.push(account);
504     }
505 
506     function includeAccount(address account) external onlyOwner() {
507         require(_isExcluded[account], "Account is already included");
508         for (uint256 i = 0; i < _excluded.length; i++) {
509             if (_excluded[i] == account) {
510                 _excluded[i] = _excluded[_excluded.length - 1];
511                 _tOwned[account] = 0;
512                 _isExcluded[account] = false;
513                 _excluded.pop();
514                 break;
515             }
516         }
517     }
518 
519     function _approve(address owner, address spender, uint256 amount) private {
520         require(owner != address(0), "ERC20: approve from the zero address");
521         require(spender != address(0), "ERC20: approve to the zero address");
522 
523         _allowances[owner][spender] = amount;
524         emit Approval(owner, spender, amount);
525     }
526 
527     function _transfer(address sender, address recipient, uint256 amount) private {
528         require(sender != address(0), "ERC20: transfer from the zero address");
529         require(recipient != address(0), "ERC20: transfer to the zero address");
530         require(amount > 0, "Transfer amount must be greater than zero");
531         if (_isExcluded[sender] && !_isExcluded[recipient]) {
532             _transferFromExcluded(sender, recipient, amount);
533         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
534             _transferToExcluded(sender, recipient, amount);
535         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
536             _transferStandard(sender, recipient, amount);
537         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
538             _transferBothExcluded(sender, recipient, amount);
539         } else {
540             _transferStandard(sender, recipient, amount);
541         }
542     }
543 
544     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
545         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee,uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) = _getValues(tAmount);
546         _rOwned[sender] = _rOwned[sender].sub(rAmount);
547         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
548         _reflectFee(rFee, tFee, tBurnValue,tTax,tLiquidity);
549         emit Transfer(sender, recipient, tTransferAmount);
550     }
551 
552     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
553         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee,uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) = _getValues(tAmount);
554         _rOwned[sender] = _rOwned[sender].sub(rAmount);
555         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
556         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
557         _reflectFee(rFee, tFee, tBurnValue,tTax,tLiquidity);
558         emit Transfer(sender, recipient, tTransferAmount);
559     }
560 
561     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
562         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee,uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) = _getValues(tAmount);
563         _tOwned[sender] = _tOwned[sender].sub(tAmount);
564         _rOwned[sender] = _rOwned[sender].sub(rAmount);
565         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
566        _reflectFee(rFee, tFee, tBurnValue,tTax,tLiquidity);
567         emit Transfer(sender, recipient, tTransferAmount);
568     }
569 
570     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
571         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee,uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) = _getValues(tAmount);
572         _tOwned[sender] = _tOwned[sender].sub(tAmount);
573         _rOwned[sender] = _rOwned[sender].sub(rAmount);
574         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
575         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
576         _reflectFee(rFee, tFee, tBurnValue,tTax,tLiquidity);
577         emit Transfer(sender, recipient, tTransferAmount);
578     }
579 
580     function _reflectFee(uint256 rFee, uint256 tFee, uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) private {
581         _rTotal = _rTotal.sub(rFee);
582         _tBurnTotal = _tBurnTotal.add(tFee).add(tBurnValue).add(tTax).add(tLiquidity);
583     }
584 
585     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256,uint256,uint256,uint256) {
586         uint256[12] memory _localVal;
587         (_localVal[0]/**tTransferAmount*/, _localVal[1]  /**tFee*/, _localVal[2] /**tBurnValue*/,_localVal[8]/*tTAx*/,_localVal[10]/**tLiquidity*/) = _getTValues(tAmount);
588         _localVal[3] /**currentRate*/ =  _getRate();
589         ( _localVal[4] /**rAmount*/,  _localVal[5] /**rTransferAmount*/, _localVal[6] /**rFee*/, _localVal[7] /**rBurnValue*/,_localVal[9]/*rTax*/,_localVal[11]/**rLiquidity*/) = _getRValues(tAmount, _localVal[1], _localVal[3], _localVal[2],_localVal[8],_localVal[10]);
590         return (_localVal[4], _localVal[5], _localVal[6], _localVal[0], _localVal[1], _localVal[2],_localVal[8],_localVal[10]);
591     }
592     
593     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256, uint256,uint256,uint256) {
594         uint256[5] memory _localVal;
595         
596         _localVal[0]/**supply*/ = tAmount.div(100).mul(0);
597         _localVal[1]/**tBurnValue*/ = tAmount.div(100).mul(0);
598         _localVal[2]/**tholder*/ = tAmount.div(100).mul(2);
599         _localVal[3]/**tLiquidity*/ = tAmount.div(100).mul(2);
600         _localVal[4]/**tTransferAmount*/ = tAmount.sub(_localVal[2]).sub(_localVal[1]).sub(_localVal[0]).sub(_localVal[3]);
601         return (_localVal[4], _localVal[2], _localVal[1],_localVal[0], _localVal[3]);
602     }
603 
604     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate, uint256 tBurnValue,uint256 tTax,uint tLiquidity) private pure returns (uint256, uint256, uint256,uint256,uint256,uint256) {
605         uint256 rAmount = tAmount.mul(currentRate);
606         uint256 rFee = tFee.mul(currentRate);
607         uint256 rBurnValue = tBurnValue.mul(currentRate);
608         uint256 rLiqidity = tLiquidity.mul(currentRate);
609         uint256 rTax = tTax.mul(currentRate);
610         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurnValue).sub(rTax).sub(rLiqidity);
611         return (rAmount, rTransferAmount, rFee, rBurnValue,rTax,rLiqidity);
612     }
613 
614     function _getRate() private view returns(uint256) {
615         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
616         return rSupply.div(tSupply);
617     }
618 
619     function _getCurrentSupply() private view returns(uint256, uint256) {
620         uint256 rSupply = _rTotal;
621         uint256 tSupply = _tTotal;      
622         for (uint256 i = 0; i < _excluded.length; i++) {
623             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
624             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
625             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
626         }
627         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
628         return (rSupply, tSupply);
629         
630     }    
631         
632 }