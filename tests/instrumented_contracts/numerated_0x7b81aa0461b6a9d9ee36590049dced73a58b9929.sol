1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-12
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.6.12;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
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
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 library SafeMath {
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a, "SafeMath: addition overflow");
98 
99         return c;
100     }
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return sub(a, b, "SafeMath: subtraction overflow");
113     }
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
125         require(b <= a, errorMessage);
126         uint256 c = a - b;
127         return c;
128     }
129     /**
130      * @dev Returns the multiplication of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `*` operator.
134      *
135      * Requirements:
136      *
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
143         if (a == 0) {
144             return 0;
145         }
146         uint256 c = a * b;
147         require(c / a == b, "SafeMath: multiplication overflow");
148         return c;
149     }
150     /**
151      * @dev Returns the integer division of two unsigned integers. Reverts on
152      * division by zero. The result is rounded towards zero.
153      *
154      * Counterpart to Solidity's `/` operator. Note: this function uses a
155      * `revert` opcode (which leaves remaining gas untouched) while Solidity
156      * uses an invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         return div(a, b, "SafeMath: division by zero");
164     }
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b > 0, errorMessage);
179         uint256 c = a / b;
180         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181         return c;
182     }
183     /**
184      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
185      * Reverts when dividing by zero.
186      *
187      * Counterpart to Solidity's `%` operator. This function uses a `revert`
188      * opcode (which leaves remaining gas untouched) while Solidity uses an
189      * invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
196         return mod(a, b, "SafeMath: modulo by zero");
197     }
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts with custom message when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b != 0, errorMessage);
212         return a % b;
213     }
214 }
215 
216 library Address {
217     /**
218      * @dev Returns true if `account` is a contract.
219      *
220      * [IMPORTANT]
221      * ====
222      * It is unsafe to assume that an address for which this function returns
223      * false is an externally-owned account (EOA) and not a contract.
224      *
225      * Among others, `isContract` will return false for the following
226      * types of addresses:
227      *
228      *  - an externally-owned account
229      *  - a contract in construction
230      *  - an address where a contract will be created
231      *  - an address where a contract lived, but was destroyed
232      * ====
233      */
234     function isContract(address account) internal view returns (bool) {
235         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
236         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
237         // for accounts without code, i.e. `keccak256('')`
238         bytes32 codehash;
239         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
240         // solhint-disable-next-line no-inline-assembly
241         assembly { codehash := extcodehash(account) }
242         return (codehash != accountHash && codehash != 0x0);
243     }
244     /**
245      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
246      * `recipient`, forwarding all available gas and reverting on errors.
247      *
248      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
249      * of certain opcodes, possibly making contracts go over the 2300 gas limit
250      * imposed by `transfer`, making them unable to receive funds via
251      * `transfer`. {sendValue} removes this limitation.
252      *
253      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
254      *
255      * IMPORTANT: because control is transferred to `recipient`, care must be
256      * taken to not create reentrancy vulnerabilities. Consider using
257      * {ReentrancyGuard} or the
258      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
259      */
260     function sendValue(address payable recipient, uint256 amount) internal {
261         require(address(this).balance >= amount, "Address: insufficient balance");
262 
263         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
264         (bool success, ) = recipient.call{ value: amount }("");
265         require(success, "Address: unable to send value, recipient may have reverted");
266     }
267     /**
268      * @dev Performs a Solidity function call using a low level `call`. A
269      * plain`call` is an unsafe replacement for a function call: use this
270      * function instead.
271      *
272      * If `target` reverts with a revert reason, it is bubbled up by this
273      * function (like regular Solidity function calls).
274      *
275      * Returns the raw returned data. To convert to the expected return value,
276      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
277      *
278      * Requirements:
279      *
280      * - `target` must be a contract.
281      * - calling `target` with `data` must not revert.
282      *
283      * _Available since v3.1._
284      */
285     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
286       return functionCall(target, data, "Address: low-level call failed");
287     }
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
290      * `errorMessage` as a fallback revert reason when `target` reverts.
291      *
292      * _Available since v3.1._
293      */
294     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
295         return _functionCallWithValue(target, data, 0, errorMessage);
296     }
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
299      * but also transferring `value` wei to `target`.
300      *
301      * Requirements:
302      *
303      * - the calling contract must have an ETH balance of at least `value`.
304      * - the called Solidity function must be `payable`.
305      *
306      * _Available since v3.1._
307      */
308     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
309         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
310     }
311     /**
312      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
313      * with `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
318         require(address(this).balance >= value, "Address: insufficient balance for call");
319         return _functionCallWithValue(target, data, value, errorMessage);
320     }
321 
322     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
323         require(isContract(target), "Address: call to non-contract");
324 
325         // solhint-disable-next-line avoid-low-level-calls
326         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
327         if (success) {
328             return returndata;
329         } else {
330             // Look for revert reason and bubble it up if present
331             if (returndata.length > 0) {
332                 // The easiest way to bubble the revert reason is using memory via assembly
333 
334                 // solhint-disable-next-line no-inline-assembly
335                 assembly {
336                     let returndata_size := mload(returndata)
337                     revert(add(32, returndata), returndata_size)
338                 }
339             } else {
340                 revert(errorMessage);
341             }
342         }
343     }
344 }
345 
346 contract Ownable is Context {
347     address private _owner;
348 
349     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
350     /**
351      * @dev Initializes the contract setting the deployer as the initial owner.
352      */
353     constructor () internal {
354         address msgSender = _msgSender();
355         _owner = msgSender;
356         emit OwnershipTransferred(address(0), msgSender);
357     }
358     /**
359      * @dev Returns the address of the current owner.
360      */
361     function owner() public view returns (address) {
362         return _owner;
363     }
364     /**
365      * @dev Throws if called by any account other than the owner.
366      */
367     modifier onlyOwner() {
368         require(_owner == _msgSender(), "Ownable: caller is not the owner");
369         _;
370     }
371     /**
372      * @dev Leaves the contract without owner. It will not be possible to call
373      * `onlyOwner` functions anymore. Can only be called by the current owner.
374      *
375      * NOTE: Renouncing ownership will leave the contract without an owner,
376      * thereby removing any functionality that is only available to the owner.
377      */
378     function renounceOwnership() public virtual onlyOwner {
379         emit OwnershipTransferred(_owner, address(0));
380         _owner = address(0);
381     }
382     /**
383      * @dev Transfers ownership of the contract to a new account (`newOwner`).
384      * Can only be called by the current owner.
385      */
386     function transferOwnership(address newOwner) public virtual onlyOwner {
387         require(newOwner != address(0), "Ownable: new owner is the zero address");
388         emit OwnershipTransferred(_owner, newOwner);
389         _owner = newOwner;
390     }
391 }
392 
393 contract MATRIXNINJA is Context, IERC20, Ownable {
394     using SafeMath for uint256;
395     using Address for address;
396 
397     mapping (address => uint256) private _rOwned;
398     mapping (address => uint256) private _tOwned;
399     mapping (address => mapping (address => uint256)) private _allowances;
400 
401     mapping (address => bool) private _isExcluded;
402     address[] private _excluded;
403    
404     uint256 private constant MAX = ~uint256(0);
405     uint256 private constant _tTotal = 1000000000 * 10**18;
406     uint256 private _rTotal = (MAX - (MAX % _tTotal));
407     uint256 private _tBurnTotal;
408 
409     string private _name = 'MATRIX NINJA';
410     string private _symbol = 'MXN';
411     uint8 private _decimals = 18;
412 
413     constructor () public {
414         _rOwned[_msgSender()] = _rTotal;
415         emit Transfer(address(0), _msgSender(), _tTotal);
416     }
417 
418     function name() public view returns (string memory) {
419         return _name;
420     }
421 
422     function symbol() public view returns (string memory) {
423         return _symbol;
424     }
425 
426     function decimals() public view returns (uint8) {
427         return _decimals;
428     }
429 
430     function totalSupply() public view override returns (uint256) {
431         return _tTotal;
432     }
433 
434     function balanceOf(address account) public view override returns (uint256) {
435         if (_isExcluded[account]) return _tOwned[account];
436         return tokenFromReflection(_rOwned[account]);
437     }
438 
439     function transfer(address recipient, uint256 amount) public override returns (bool) {
440         _transfer(_msgSender(), recipient, amount);
441         return true;
442     }
443 
444     function allowance(address owner, address spender) public view override returns (uint256) {
445         return _allowances[owner][spender];
446     }
447 
448     function approve(address spender, uint256 amount) public override returns (bool) {
449         _approve(_msgSender(), spender, amount);
450         return true;
451     }
452 
453     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
454         _transfer(sender, recipient, amount);
455         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
456         return true;
457     }
458 
459     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
460         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
461         return true;
462     }
463 
464     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
465         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
466         return true;
467     }
468 
469     function isExcluded(address account) public view returns (bool) {
470         return _isExcluded[account];
471     }
472 
473     function totalBurn() public view returns (uint256) {
474         return _tBurnTotal;
475     }
476 
477     function reflect(uint256 tAmount) public {
478         address sender = _msgSender();
479         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
480         (uint256 rAmount,,,,,,,) = _getValues(tAmount);
481         _rOwned[sender] = _rOwned[sender].sub(rAmount);
482         _rTotal = _rTotal.sub(rAmount);
483         _tBurnTotal = _tBurnTotal.add(tAmount);
484     }
485 
486     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
487         require(tAmount <= _tTotal, "Amount must be less than supply");
488         if (!deductTransferFee) {
489             (uint256 rAmount,,,,,,,) = _getValues(tAmount);
490             return rAmount;
491         } else {
492             (,uint256 rTransferAmount,,,,,,) = _getValues(tAmount);
493             return rTransferAmount;
494         }
495     }
496 
497     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
498         require(rAmount <= _rTotal, "Amount must be less than total reflections");
499         uint256 currentRate =  _getRate();
500         return rAmount.div(currentRate);
501     }
502 
503     function excludeAccount(address account) external onlyOwner() {
504         require(!_isExcluded[account], "Account is already excluded");
505         if(_rOwned[account] > 0) {
506             _tOwned[account] = tokenFromReflection(_rOwned[account]);
507         }
508         _isExcluded[account] = true;
509         _excluded.push(account);
510     }
511 
512     function includeAccount(address account) external onlyOwner() {
513         require(_isExcluded[account], "Account is already included");
514         for (uint256 i = 0; i < _excluded.length; i++) {
515             if (_excluded[i] == account) {
516                 _excluded[i] = _excluded[_excluded.length - 1];
517                 _tOwned[account] = 0;
518                 _isExcluded[account] = false;
519                 _excluded.pop();
520                 break;
521             }
522         }
523     }
524 
525     function _approve(address owner, address spender, uint256 amount) private {
526         require(owner != address(0), "ERC20: approve from the zero address");
527         require(spender != address(0), "ERC20: approve to the zero address");
528 
529         _allowances[owner][spender] = amount;
530         emit Approval(owner, spender, amount);
531     }
532 
533     function _transfer(address sender, address recipient, uint256 amount) private {
534         require(sender != address(0), "ERC20: transfer from the zero address");
535         require(recipient != address(0), "ERC20: transfer to the zero address");
536         require(amount > 0, "Transfer amount must be greater than zero");
537         if (_isExcluded[sender] && !_isExcluded[recipient]) {
538             _transferFromExcluded(sender, recipient, amount);
539         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
540             _transferToExcluded(sender, recipient, amount);
541         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
542             _transferStandard(sender, recipient, amount);
543         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
544             _transferBothExcluded(sender, recipient, amount);
545         } else {
546             _transferStandard(sender, recipient, amount);
547         }
548     }
549 
550     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
551         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee,uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) = _getValues(tAmount);
552         _rOwned[sender] = _rOwned[sender].sub(rAmount);
553         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
554         _reflectFee(rFee, tFee, tBurnValue,tTax,tLiquidity);
555         emit Transfer(sender, recipient, tTransferAmount);
556     }
557 
558     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
559         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee,uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) = _getValues(tAmount);
560         _rOwned[sender] = _rOwned[sender].sub(rAmount);
561         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
562         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
563         _reflectFee(rFee, tFee, tBurnValue,tTax,tLiquidity);
564         emit Transfer(sender, recipient, tTransferAmount);
565     }
566 
567     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
568         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee,uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) = _getValues(tAmount);
569         _tOwned[sender] = _tOwned[sender].sub(tAmount);
570         _rOwned[sender] = _rOwned[sender].sub(rAmount);
571         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
572        _reflectFee(rFee, tFee, tBurnValue,tTax,tLiquidity);
573         emit Transfer(sender, recipient, tTransferAmount);
574     }
575 
576     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
577         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee,uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) = _getValues(tAmount);
578         _tOwned[sender] = _tOwned[sender].sub(tAmount);
579         _rOwned[sender] = _rOwned[sender].sub(rAmount);
580         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
581         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
582         _reflectFee(rFee, tFee, tBurnValue,tTax,tLiquidity);
583         emit Transfer(sender, recipient, tTransferAmount);
584     }
585 
586     function _reflectFee(uint256 rFee, uint256 tFee, uint256 tBurnValue,uint256 tTax,uint256 tLiquidity) private {
587         _rTotal = _rTotal.sub(rFee);
588         _tBurnTotal = _tBurnTotal.add(tFee).add(tBurnValue).add(tTax).add(tLiquidity);
589     }
590 
591     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256,uint256,uint256,uint256) {
592         uint256[12] memory _localVal;
593         (_localVal[0]/**tTransferAmount*/, _localVal[1]  /**tFee*/, _localVal[2] /**tBurnValue*/,_localVal[8]/*tTAx*/,_localVal[10]/**tLiquidity*/) = _getTValues(tAmount);
594         _localVal[3] /**currentRate*/ =  _getRate();
595         ( _localVal[4] /**rAmount*/,  _localVal[5] /**rTransferAmount*/, _localVal[6] /**rFee*/, _localVal[7] /**rBurnValue*/,_localVal[9]/*rTax*/,_localVal[11]/**rLiquidity*/) = _getRValues(tAmount, _localVal[1], _localVal[3], _localVal[2],_localVal[8],_localVal[10]);
596         return (_localVal[4], _localVal[5], _localVal[6], _localVal[0], _localVal[1], _localVal[2],_localVal[8],_localVal[10]);
597     }
598     
599     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256, uint256,uint256,uint256) {
600         uint256[5] memory _localVal;
601         
602         _localVal[0]/**supply*/ = tAmount.div(100).mul(0);
603         _localVal[1]/**tBurnValue*/ = tAmount.div(100).mul(0);
604         _localVal[2]/**tholder*/ = tAmount.div(100).mul(3);
605         _localVal[3]/**tLiquidity*/ = tAmount.div(100).mul(5);
606         _localVal[4]/**tTransferAmount*/ = tAmount.sub(_localVal[2]).sub(_localVal[1]).sub(_localVal[0]).sub(_localVal[3]);
607         return (_localVal[4], _localVal[2], _localVal[1],_localVal[0], _localVal[3]);
608     }
609 
610     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate, uint256 tBurnValue,uint256 tTax,uint tLiquidity) private pure returns (uint256, uint256, uint256,uint256,uint256,uint256) {
611         uint256 rAmount = tAmount.mul(currentRate);
612         uint256 rFee = tFee.mul(currentRate);
613         uint256 rBurnValue = tBurnValue.mul(currentRate);
614         uint256 rLiqidity = tLiquidity.mul(currentRate);
615         uint256 rTax = tTax.mul(currentRate);
616         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurnValue).sub(rTax).sub(rLiqidity);
617         return (rAmount, rTransferAmount, rFee, rBurnValue,rTax,rLiqidity);
618     }
619 
620     function _getRate() private view returns(uint256) {
621         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
622         return rSupply.div(tSupply);
623     }
624 
625     function _getCurrentSupply() private view returns(uint256, uint256) {
626         uint256 rSupply = _rTotal;
627         uint256 tSupply = _tTotal;      
628         for (uint256 i = 0; i < _excluded.length; i++) {
629             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
630             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
631             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
632         }
633         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
634         return (rSupply, tSupply);
635     }
636 }