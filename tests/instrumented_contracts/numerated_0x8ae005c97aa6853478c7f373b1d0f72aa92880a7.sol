1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 library SafeMath {
80     /**
81      * @dev Returns the addition of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `+` operator.
85      *
86      * Requirements:
87      *
88      * - Addition cannot overflow.
89      */
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93 
94         return c;
95     }
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      *
104      * - Subtraction cannot overflow.
105      */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         return sub(a, b, "SafeMath: subtraction overflow");
108     }
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b <= a, errorMessage);
121         uint256 c = a - b;
122         return c;
123     }
124     /**
125      * @dev Returns the multiplication of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      *
132      * - Multiplication cannot overflow.
133      */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
138         if (a == 0) {
139             return 0;
140         }
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143         return c;
144     }
145     /**
146      * @dev Returns the integer division of two unsigned integers. Reverts on
147      * division by zero. The result is rounded towards zero.
148      *
149      * Counterpart to Solidity's `/` operator. Note: this function uses a
150      * `revert` opcode (which leaves remaining gas untouched) while Solidity
151      * uses an invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function div(uint256 a, uint256 b) internal pure returns (uint256) {
158         return div(a, b, "SafeMath: division by zero");
159     }
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      *
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b > 0, errorMessage);
174         uint256 c = a / b;
175         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
176         return c;
177     }
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * Reverts when dividing by zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
191         return mod(a, b, "SafeMath: modulo by zero");
192     }
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts with custom message when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b != 0, errorMessage);
207         return a % b;
208     }
209 }
210 
211 library Address {
212     /**
213      * @dev Returns true if `account` is a contract.
214      *
215      * [IMPORTANT]
216      * ====
217      * It is unsafe to assume that an address for which this function returns
218      * false is an externally-owned account (EOA) and not a contract.
219      *
220      * Among others, `isContract` will return false for the following
221      * types of addresses:
222      *
223      *  - an externally-owned account
224      *  - a contract in construction
225      *  - an address where a contract will be created
226      *  - an address where a contract lived, but was destroyed
227      * ====
228      */
229     function isContract(address account) internal view returns (bool) {
230         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
231         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
232         // for accounts without code, i.e. `keccak256('')`
233         bytes32 codehash;
234         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
235         // solhint-disable-next-line no-inline-assembly
236         assembly { codehash := extcodehash(account) }
237         return (codehash != accountHash && codehash != 0x0);
238     }
239     /**
240      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
241      * `recipient`, forwarding all available gas and reverting on errors.
242      *
243      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
244      * of certain opcodes, possibly making contracts go over the 2300 gas limit
245      * imposed by `transfer`, making them unable to receive funds via
246      * `transfer`. {sendValue} removes this limitation.
247      *
248      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
249      *
250      * IMPORTANT: because control is transferred to `recipient`, care must be
251      * taken to not create reentrancy vulnerabilities. Consider using
252      * {ReentrancyGuard} or the
253      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
254      */
255     function sendValue(address payable recipient, uint256 amount) internal {
256         require(address(this).balance >= amount, "Address: insufficient balance");
257 
258         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
259         (bool success, ) = recipient.call{ value: amount }("");
260         require(success, "Address: unable to send value, recipient may have reverted");
261     }
262     /**
263      * @dev Performs a Solidity function call using a low level `call`. A
264      * plain`call` is an unsafe replacement for a function call: use this
265      * function instead.
266      *
267      * If `target` reverts with a revert reason, it is bubbled up by this
268      * function (like regular Solidity function calls).
269      *
270      * Returns the raw returned data. To convert to the expected return value,
271      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
272      *
273      * Requirements:
274      *
275      * - `target` must be a contract.
276      * - calling `target` with `data` must not revert.
277      *
278      * _Available since v3.1._
279      */
280     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
281       return functionCall(target, data, "Address: low-level call failed");
282     }
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
285      * `errorMessage` as a fallback revert reason when `target` reverts.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
290         return _functionCallWithValue(target, data, 0, errorMessage);
291     }
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
294      * but also transferring `value` wei to `target`.
295      *
296      * Requirements:
297      *
298      * - the calling contract must have an ETH balance of at least `value`.
299      * - the called Solidity function must be `payable`.
300      *
301      * _Available since v3.1._
302      */
303     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
305     }
306     /**
307      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
308      * with `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
313         require(address(this).balance >= value, "Address: insufficient balance for call");
314         return _functionCallWithValue(target, data, value, errorMessage);
315     }
316 
317     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
318         require(isContract(target), "Address: call to non-contract");
319 
320         // solhint-disable-next-line avoid-low-level-calls
321         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
322         if (success) {
323             return returndata;
324         } else {
325             // Look for revert reason and bubble it up if present
326             if (returndata.length > 0) {
327                 // The easiest way to bubble the revert reason is using memory via assembly
328 
329                 // solhint-disable-next-line no-inline-assembly
330                 assembly {
331                     let returndata_size := mload(returndata)
332                     revert(add(32, returndata), returndata_size)
333                 }
334             } else {
335                 revert(errorMessage);
336             }
337         }
338     }
339 }
340 
341 contract Ownable is Context {
342     address private _owner;
343 
344     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
345     /**
346      * @dev Initializes the contract setting the deployer as the initial owner.
347      */
348     constructor () internal {
349         address msgSender = _msgSender();
350         _owner = msgSender;
351         emit OwnershipTransferred(address(0), msgSender);
352     }
353     /**
354      * @dev Returns the address of the current owner.
355      */
356     function owner() public view returns (address) {
357         return _owner;
358     }
359     /**
360      * @dev Throws if called by any account other than the owner.
361      */
362     modifier onlyOwner() {
363         require(_owner == _msgSender(), "Ownable: caller is not the owner");
364         _;
365     }
366     /**
367      * @dev Leaves the contract without owner. It will not be possible to call
368      * `onlyOwner` functions anymore. Can only be called by the current owner.
369      *
370      * NOTE: Renouncing ownership will leave the contract without an owner,
371      * thereby removing any functionality that is only available to the owner.
372      */
373     function renounceOwnership() public virtual onlyOwner {
374         emit OwnershipTransferred(_owner, address(0));
375         _owner = address(0);
376     }
377     /**
378      * @dev Transfers ownership of the contract to a new account (`newOwner`).
379      * Can only be called by the current owner.
380      */
381     function transferOwnership(address newOwner) public virtual onlyOwner {
382         require(newOwner != address(0), "Ownable: new owner is the zero address");
383         emit OwnershipTransferred(_owner, newOwner);
384         _owner = newOwner;
385     }
386 }
387 
388 contract YuangCoin is Context, IERC20, Ownable {
389     using SafeMath for uint256;
390     using Address for address;
391 
392     mapping (address => uint256) private _rOwned;
393     mapping (address => uint256) private _tOwned;
394     mapping (address => mapping (address => uint256)) private _allowances;
395 
396     mapping (address => bool) private _isExcluded;
397     address[] private _excluded;
398    
399     uint256 private constant MAX = ~uint256(0);
400     uint256 private constant _tTotal = 1000000000000000 * 10**18;
401     uint256 private _rTotal = (MAX - (MAX % _tTotal));
402     uint256 private _tBurnTotal;
403 
404     string private _name = 'YUANG COIN';
405     string private _symbol = 'YUANG';
406     uint8 private _decimals = 18;
407 
408     constructor () public {
409         _rOwned[_msgSender()] = _rTotal;
410         emit Transfer(address(0), _msgSender(), _tTotal);
411     }
412 
413     function name() public view returns (string memory) {
414         return _name;
415     }
416 
417     function symbol() public view returns (string memory) {
418         return _symbol;
419     }
420 
421     function decimals() public view returns (uint8) {
422         return _decimals;
423     }
424 
425     function totalSupply() public view override returns (uint256) {
426         return _tTotal;
427     }
428 
429     function balanceOf(address account) public view override returns (uint256) {
430         if (_isExcluded[account]) return _tOwned[account];
431         return tokenFromReflection(_rOwned[account]);
432     }
433 
434     function transfer(address recipient, uint256 amount) public override returns (bool) {
435         _transfer(_msgSender(), recipient, amount);
436         return true;
437     }
438 
439     function allowance(address owner, address spender) public view override returns (uint256) {
440         return _allowances[owner][spender];
441     }
442 
443     function approve(address spender, uint256 amount) public override returns (bool) {
444         _approve(_msgSender(), spender, amount);
445         return true;
446     }
447 
448     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
449         _transfer(sender, recipient, amount);
450         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
451         return true;
452     }
453 
454     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
455         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
456         return true;
457     }
458 
459     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
460         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
461         return true;
462     }
463 
464     function isExcluded(address account) public view returns (bool) {
465         return _isExcluded[account];
466     }
467 
468     function totalBurn() public view returns (uint256) {
469         return _tBurnTotal;
470     }
471 
472     function reflect(uint256 tAmount) public {
473         address sender = _msgSender();
474         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
475         (uint256 rAmount,,,,,,) = _getValues(tAmount);
476         _rOwned[sender] = _rOwned[sender].sub(rAmount);
477         _rTotal = _rTotal.sub(rAmount);
478         _tBurnTotal = _tBurnTotal.add(tAmount);
479     }
480 
481     function reflectionFromToken(uint256 tAmount, bool deductTransferHolders) public view returns(uint256) {
482         require(tAmount <= _tTotal, "Amount must be less than supply");
483         if (!deductTransferHolders) {
484             (uint256 rAmount,,,,,,) = _getValues(tAmount);
485             return rAmount;
486         } else {
487             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
488             return rTransferAmount;
489         }
490     }
491 
492     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
493         require(rAmount <= _rTotal, "Amount must be less than total reflections");
494         uint256 currentRate =  _getRate();
495         return rAmount.div(currentRate);
496     }
497 
498     function excludeAccount(address account) external onlyOwner() {
499         require(!_isExcluded[account], "Account is already excluded");
500         if(_rOwned[account] > 0) {
501             _tOwned[account] = tokenFromReflection(_rOwned[account]);
502         }
503         _isExcluded[account] = true;
504         _excluded.push(account);
505     }
506 
507     function includeAccount(address account) external onlyOwner() {
508         require(_isExcluded[account], "Account is already included");
509         for (uint256 i = 0; i < _excluded.length; i++) {
510             if (_excluded[i] == account) {
511                 _excluded[i] = _excluded[_excluded.length - 1];
512                 _tOwned[account] = 0;
513                 _isExcluded[account] = false;
514                 _excluded.pop();
515                 break;
516             }
517         }
518     }
519 
520     function _approve(address owner, address spender, uint256 amount) private {
521         require(owner != address(0), "ERC20: approve from the zero address");
522         require(spender != address(0), "ERC20: approve to the zero address");
523 
524         _allowances[owner][spender] = amount;
525         emit Approval(owner, spender, amount);
526     }
527 
528     function _transfer(address sender, address recipient, uint256 amount) private {
529         require(sender != address(0), "ERC20: transfer from the zero address");
530         require(recipient != address(0), "ERC20: transfer to the zero address");
531         require(amount > 0, "Transfer amount must be greater than zero");
532         if (_isExcluded[sender] && !_isExcluded[recipient]) {
533             _transferFromExcluded(sender, recipient, amount);
534         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
535             _transferToExcluded(sender, recipient, amount);
536         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
537             _transferStandard(sender, recipient, amount);
538         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
539             _transferBothExcluded(sender, recipient, amount);
540         } else {
541             _transferStandard(sender, recipient, amount);
542         }
543     }
544 
545     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
546         (uint256 rAmount, uint256 rTransferAmount, uint256 rHolders, uint256 tTransferAmount, uint256 tHolders,uint256 tBurnValue,uint256 tLiquidity) = _getValues(tAmount);
547         _rOwned[sender] = _rOwned[sender].sub(rAmount);
548         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
549         _reflectHolders(rHolders, tHolders, tBurnValue,tLiquidity);
550         emit Transfer(sender, recipient, tTransferAmount);
551         emit Transfer(sender, address(0), tBurnValue);
552     }
553 
554     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
555         (uint256 rAmount, uint256 rTransferAmount, uint256 rHolders, uint256 tTransferAmount, uint256 tHolders,uint256 tBurnValue,uint256 tLiquidity) = _getValues(tAmount);
556         _rOwned[sender] = _rOwned[sender].sub(rAmount);
557         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
558         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
559         _reflectHolders(rHolders, tHolders, tBurnValue,tLiquidity);
560         emit Transfer(sender, recipient, tTransferAmount);
561         emit Transfer(sender, address(0), tBurnValue);
562     }
563 
564     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
565         (uint256 rAmount, uint256 rTransferAmount, uint256 rHolders, uint256 tTransferAmount, uint256 tHolders,uint256 tBurnValue,uint256 tLiquidity) = _getValues(tAmount);
566         _tOwned[sender] = _tOwned[sender].sub(tAmount);
567         _rOwned[sender] = _rOwned[sender].sub(rAmount);
568         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
569        _reflectHolders(rHolders, tHolders, tBurnValue,tLiquidity);
570         emit Transfer(sender, recipient, tTransferAmount);
571         emit Transfer(sender, address(0), tBurnValue);
572     }
573 
574     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
575         (uint256 rAmount, uint256 rTransferAmount, uint256 rHolders, uint256 tTransferAmount, uint256 tHolders,uint256 tBurnValue,uint256 tLiquidity) = _getValues(tAmount);
576         _tOwned[sender] = _tOwned[sender].sub(tAmount);
577         _rOwned[sender] = _rOwned[sender].sub(rAmount);
578         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
579         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
580         _reflectHolders(rHolders, tHolders, tBurnValue,tLiquidity);
581         emit Transfer(sender, recipient, tTransferAmount);
582         emit Transfer(sender, address(0), tBurnValue);
583     }
584 
585     function _reflectHolders(uint256 rHolders, uint256 tHolders, uint256 tBurnValue,uint256 tLiquidity) private {
586         _rTotal = _rTotal.sub(rHolders);
587         _tBurnTotal = _tBurnTotal.add(tHolders).add(tBurnValue).add(tLiquidity);
588     }
589 
590     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256,uint256,uint256) {
591         uint256[10] memory _localVal;
592         (_localVal[0]/**tTransferAmount*/, _localVal[1]  /**tHolders*/, _localVal[2] /**tBurnValue*/,_localVal[8]/**tLiquidity*/) = _getTValues(tAmount);
593         _localVal[3] /**currentRate*/ =  _getRate();
594         ( _localVal[4] /**rAmount*/,  _localVal[5] /**rTransferAmount*/, _localVal[6] /**rHolders*/, _localVal[7] /**rBurnValue*/,_localVal[9]/**rLiquidity*/) = _getRValues(tAmount, _localVal[1], _localVal[3], _localVal[2],_localVal[8]);
595         return (_localVal[4], _localVal[5], _localVal[6], _localVal[0], _localVal[1], _localVal[2],_localVal[8]);
596     }
597     
598     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256, uint256,uint256) {
599         uint256 tBurnValue = tAmount.div(100).mul(1);
600         uint256 tHolders = tAmount.div(100).mul(1);
601         uint256 tLiquidity = tAmount.div(100).mul(0);
602         uint256 tTransferAmount = tAmount.sub(tBurnValue).sub(tHolders).sub(tLiquidity);
603         return (tTransferAmount, tHolders, tBurnValue, tLiquidity);
604     }
605 
606     function _getRValues(uint256 tAmount, uint256 tHolders, uint256 currentRate, uint256 tBurnValue,uint tLiquidity) private pure returns (uint256, uint256, uint256,uint256,uint256) {
607         uint256 rAmount = tAmount.mul(currentRate);
608         uint256 rHolders = tHolders.mul(currentRate);
609         uint256 rBurnValue = tBurnValue.mul(currentRate);
610         uint256 rLiqidity = tLiquidity.mul(currentRate);
611         uint256 rTransferAmount = rAmount.sub(rHolders).sub(rBurnValue).sub(rLiqidity);
612         return (rAmount, rTransferAmount, rHolders, rBurnValue,rLiqidity);
613     }
614 
615     function _getRate() private view returns(uint256) {
616         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
617         return rSupply.div(tSupply);
618     }
619 
620     function _getCurrentSupply() private view returns(uint256, uint256) {
621         uint256 rSupply = _rTotal;
622         uint256 tSupply = _tTotal;      
623         for (uint256 i = 0; i < _excluded.length; i++) {
624             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
625             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
626             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
627         }
628         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
629         return (rSupply, tSupply);
630     }
631 }