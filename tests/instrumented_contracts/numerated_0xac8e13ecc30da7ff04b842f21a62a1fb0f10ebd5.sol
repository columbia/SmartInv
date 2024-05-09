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
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     function allowance(address owner, address spender) external view returns (uint256);
22 
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53         // benefit is lost if 'b' is also tested.
54         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55         if (a == 0) {
56             return 0;
57         }
58 
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the integer division of two unsigned integers. Reverts on
67      * division by zero. The result is rounded towards zero.
68      *
69      * Counterpart to Solidity's `/` operator. Note: this function uses a
70      * `revert` opcode (which leaves remaining gas untouched) while Solidity
71      * uses an invalid opcode to revert (consuming all remaining gas).
72      *
73      * Requirements:
74      *
75      * - The divisor cannot be zero.
76      */
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         return div(a, b, "SafeMath: division by zero");
79     }
80 
81     /**
82      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
83      * division by zero. The result is rounded towards zero.
84      *
85      * Counterpart to Solidity's `/` operator. Note: this function uses a
86      * `revert` opcode (which leaves remaining gas untouched) while Solidity
87      * uses an invalid opcode to revert (consuming all remaining gas).
88      *
89      * Requirements:
90      *
91      * - The divisor cannot be zero.
92      */
93     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         require(b > 0, errorMessage);
95         uint256 c = a / b;
96         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
103      * Reverts when dividing by zero.
104      *
105      * Counterpart to Solidity's `%` operator. This function uses a `revert`
106      * opcode (which leaves remaining gas untouched) while Solidity uses an
107      * invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      *
111      * - The divisor cannot be zero.
112      */
113     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114         return mod(a, b, "SafeMath: modulo by zero");
115     }
116 
117     /**
118      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
119      * Reverts with custom message when dividing by zero.
120      *
121      * Counterpart to Solidity's `%` operator. This function uses a `revert`
122      * opcode (which leaves remaining gas untouched) while Solidity uses an
123      * invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      *
127      * - The divisor cannot be zero.
128      */
129     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b != 0, errorMessage);
131         return a % b;
132     }
133 }
134 
135 library Address {
136     /**
137      * @dev Returns true if `account` is a contract.
138      *
139      * [IMPORTANT]
140      * ====
141      * It is unsafe to assume that an address for which this function returns
142      * false is an externally-owned account (EOA) and not a contract.
143      *
144      * Among others, `isContract` will return false for the following
145      * types of addresses:
146      *
147      *  - an externally-owned account
148      *  - a contract in construction
149      *  - an address where a contract will be created
150      *  - an address where a contract lived, but was destroyed
151      * ====
152      */
153     function isContract(address account) internal view returns (bool) {
154         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
155         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
156         // for accounts without code, i.e. `keccak256('')`
157         bytes32 codehash;
158         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
159         // solhint-disable-next-line no-inline-assembly
160         assembly { codehash := extcodehash(account) }
161         return (codehash != accountHash && codehash != 0x0);
162     }
163 
164     /**
165      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
166      * `recipient`, forwarding all available gas and reverting on errors.
167      *
168      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
169      * of certain opcodes, possibly making contracts go over the 2300 gas limit
170      * imposed by `transfer`, making them unable to receive funds via
171      * `transfer`. {sendValue} removes this limitation.
172      *
173      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
174      *
175      * IMPORTANT: because control is transferred to `recipient`, care must be
176      * taken to not create reentrancy vulnerabilities. Consider using
177      * {ReentrancyGuard} or the
178      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
179      */
180     function sendValue(address payable recipient, uint256 amount) internal {
181         require(address(this).balance >= amount, "Address: insufficient balance");
182 
183         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
184         (bool success, ) = recipient.call{ value: amount }("");
185         require(success, "Address: unable to send value, recipient may have reverted");
186     }
187 
188     /**
189      * @dev Performs a Solidity function call using a low level `call`. A
190      * plain`call` is an unsafe replacement for a function call: use this
191      * function instead.
192      *
193      * If `target` reverts with a revert reason, it is bubbled up by this
194      * function (like regular Solidity function calls).
195      *
196      * Returns the raw returned data. To convert to the expected return value,
197      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
198      *
199      * Requirements:
200      *
201      * - `target` must be a contract.
202      * - calling `target` with `data` must not revert.
203      *
204      * _Available since v3.1._
205      */
206     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
207       return functionCall(target, data, "Address: low-level call failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
212      * `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
217         return _functionCallWithValue(target, data, 0, errorMessage);
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
222      * but also transferring `value` wei to `target`.
223      *
224      * Requirements:
225      *
226      * - the calling contract must have an ETH balance of at least `value`.
227      * - the called Solidity function must be `payable`.
228      *
229      * _Available since v3.1._
230      */
231     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
232         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
237      * with `errorMessage` as a fallback revert reason when `target` reverts.
238      *
239      * _Available since v3.1._
240      */
241     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
242         require(address(this).balance >= value, "Address: insufficient balance for call");
243         return _functionCallWithValue(target, data, value, errorMessage);
244     }
245 
246     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
247         require(isContract(target), "Address: call to non-contract");
248 
249         // solhint-disable-next-line avoid-low-level-calls
250         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
251         if (success) {
252             return returndata;
253         } else {
254             // Look for revert reason and bubble it up if present
255             if (returndata.length > 0) {
256                 // The easiest way to bubble the revert reason is using memory via assembly
257 
258                 // solhint-disable-next-line no-inline-assembly
259                 assembly {
260                     let returndata_size := mload(returndata)
261                     revert(add(32, returndata), returndata_size)
262                 }
263             } else {
264                 revert(errorMessage);
265             }
266         }
267     }
268 }
269 
270 contract Ownable is Context {
271     address private _owner;
272 
273     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
274 
275     /**
276      * @dev Initializes the contract setting the deployer as the initial owner.
277      */
278     constructor () internal {
279         address msgSender = _msgSender();
280         _owner = msgSender;
281         emit OwnershipTransferred(address(0), msgSender);
282     }
283 
284     /**
285      * @dev Returns the address of the current owner.
286      */
287     function owner() public view returns (address) {
288         return _owner;
289     }
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         require(_owner == _msgSender(), "Ownable: caller is not the owner");
296         _;
297     }
298 
299     /**
300      * @dev Leaves the contract without owner. It will not be possible to call
301      * `onlyOwner` functions anymore. Can only be called by the current owner.
302      *
303      * NOTE: Renouncing ownership will leave the contract without an owner,
304      * thereby removing any functionality that is only available to the owner.
305      */
306     function renounceOwnership() public virtual onlyOwner {
307         emit OwnershipTransferred(_owner, address(0));
308         _owner = address(0);
309     }
310 
311     /**
312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
313      * Can only be called by the current owner.
314      */
315     function transferOwnership(address newOwner) public virtual onlyOwner {
316         require(newOwner != address(0), "Ownable: new owner is the zero address");
317         emit OwnershipTransferred(_owner, newOwner);
318         _owner = newOwner;
319     }
320 }
321 
322 
323 contract BABYDOGECOIN is Context, IERC20, Ownable {
324     using SafeMath for uint256;
325     using Address for address;
326 
327     mapping (address => uint256) private _rOwned;
328     mapping (address => uint256) private _tOwned;
329     mapping (address => mapping (address => uint256)) private _allowances;
330 
331     mapping (address => bool) private _isExcluded;
332     address[] private _excluded;
333    
334     uint256 private constant MAX = ~uint256(0);
335     uint256 private constant _tTotal = 1000000000 * 10**6 * 10**9;
336     uint256 private _rTotal = (MAX - (MAX % _tTotal));
337     uint256 private _tFeeTotal;
338 
339     string private _name = 'BabyDoge Coin';
340     string private _symbol = 'BABYDOGE';
341     uint8 private _decimals = 9;
342     uint8 public transfertimeout = 15;
343     uint256 public _maxTxAmount = 10000000 * 10**6 * 10**9;
344 
345     address public uniswapPair;
346     mapping (address => uint256) public lastBuy;
347 
348     constructor () public {
349         _rOwned[_msgSender()] = _rTotal;
350         emit Transfer(address(0), _msgSender(), _tTotal);
351     }
352 
353     function name() public view returns (string memory) {
354         return _name;
355     }
356 
357     function symbol() public view returns (string memory) {
358         return _symbol;
359     }
360 
361     function decimals() public view returns (uint8) {
362         return _decimals;
363     }
364 
365     function totalSupply() public view override returns (uint256) {
366         return _tTotal;
367     }
368 
369     function balanceOf(address account) public view override returns (uint256) {
370         if (_isExcluded[account]) return _tOwned[account];
371         return tokenFromReflection(_rOwned[account]);
372     }
373 
374     function transfer(address recipient, uint256 amount) public override returns (bool) {
375         _transfer(_msgSender(), recipient, amount);
376         return true;
377     }
378 
379     function allowance(address owner, address spender) public view override returns (uint256) {
380         return _allowances[owner][spender];
381     }
382 
383     function approve(address spender, uint256 amount) public override returns (bool) {
384         _approve(_msgSender(), spender, amount);
385         return true;
386     }
387 
388     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
389         _transfer(sender, recipient, amount);
390         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
391         return true;
392     }
393 
394     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
395         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
396         return true;
397     }
398 
399     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
400         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
401         return true;
402     }
403 
404     function isExcluded(address account) public view returns (bool) {
405         return _isExcluded[account];
406     }
407 
408     function totalFees() public view returns (uint256) {
409         return _tFeeTotal;
410     }
411     
412     
413     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
414         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
415             10**2
416         );
417     }
418 
419     function reflect(uint256 tAmount) public {
420         address sender = _msgSender();
421         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
422         (uint256 rAmount,,,,) = _getValues(tAmount);
423         _rOwned[sender] = _rOwned[sender].sub(rAmount);
424         _rTotal = _rTotal.sub(rAmount);
425         _tFeeTotal = _tFeeTotal.add(tAmount);
426     }
427 
428     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
429         require(tAmount <= _tTotal, "Amount must be less than supply");
430         if (!deductTransferFee) {
431             (uint256 rAmount,,,,) = _getValues(tAmount);
432             return rAmount;
433         } else {
434             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
435             return rTransferAmount;
436         }
437     }
438 
439     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
440         require(rAmount <= _rTotal, "Amount must be less than total reflections");
441         uint256 currentRate =  _getRate();
442         return rAmount.div(currentRate);
443     }
444 
445     function excludeAccount(address account) external onlyOwner() {
446         require(!_isExcluded[account], "Account is already excluded");
447         if(_rOwned[account] > 0) {
448             _tOwned[account] = tokenFromReflection(_rOwned[account]);
449         }
450         _isExcluded[account] = true;
451         _excluded.push(account);
452     }
453 
454     function includeAccount(address account) external onlyOwner() {
455         require(_isExcluded[account], "Account is already excluded");
456         for (uint256 i = 0; i < _excluded.length; i++) {
457             if (_excluded[i] == account) {
458                 _excluded[i] = _excluded[_excluded.length - 1];
459                 _tOwned[account] = 0;
460                 _isExcluded[account] = false;
461                 _excluded.pop();
462                 break;
463             }
464         }
465     }
466 
467     function _approve(address owner, address spender, uint256 amount) private {
468         require(owner != address(0), "ERC20: approve from the zero address");
469         require(spender != address(0), "ERC20: approve to the zero address");
470 
471         _allowances[owner][spender] = amount;
472         emit Approval(owner, spender, amount);
473     }
474 
475     function _transfer(address sender, address recipient, uint256 amount) private {
476         require(sender != address(0), "ERC20: transfer from the zero address");
477         require(recipient != address(0), "ERC20: transfer to the zero address");
478         require(amount > 0, "Transfer amount must be greater than zero");
479         if(sender != owner() && recipient != owner())
480           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
481         
482         //save last buy
483         if (sender == uniswapPair){
484             lastBuy[recipient] = block.timestamp; 
485         }
486 
487         //check if sell
488         if (recipient == uniswapPair){
489             require(block.timestamp >= lastBuy[sender] + transfertimeout, "15s lock");
490         }        
491 
492         if (_isExcluded[sender] && !_isExcluded[recipient]) {
493             _transferFromExcluded(sender, recipient, amount);
494         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
495             _transferToExcluded(sender, recipient, amount);
496         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
497             _transferStandard(sender, recipient, amount);
498         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
499             _transferBothExcluded(sender, recipient, amount);
500         } else {
501             _transferStandard(sender, recipient, amount);
502         }
503     }
504 
505     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
506         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
507         _rOwned[sender] = _rOwned[sender].sub(rAmount);
508         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
509         _reflectFee(rFee, tFee);
510         emit Transfer(sender, recipient, tTransferAmount);
511     }
512 
513     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
514         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
515         _rOwned[sender] = _rOwned[sender].sub(rAmount);
516         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
517         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
518         _reflectFee(rFee, tFee);
519         emit Transfer(sender, recipient, tTransferAmount);
520     }
521 
522     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
523         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
524         _tOwned[sender] = _tOwned[sender].sub(tAmount);
525         _rOwned[sender] = _rOwned[sender].sub(rAmount);
526         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
527         _reflectFee(rFee, tFee);
528         emit Transfer(sender, recipient, tTransferAmount);
529     }
530 
531     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
532         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
533         _tOwned[sender] = _tOwned[sender].sub(tAmount);
534         _rOwned[sender] = _rOwned[sender].sub(rAmount);
535         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
536         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
537         _reflectFee(rFee, tFee);
538         emit Transfer(sender, recipient, tTransferAmount);
539     }
540 
541     function _reflectFee(uint256 rFee, uint256 tFee) private {
542         _rTotal = _rTotal.sub(rFee);
543         _tFeeTotal = _tFeeTotal.add(tFee);
544     }
545 
546     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
547         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
548         uint256 currentRate =  _getRate();
549         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
550         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
551     }
552 
553     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
554         uint256 tFee = tAmount.div(100).mul(2);
555         uint256 tTransferAmount = tAmount.sub(tFee);
556         return (tTransferAmount, tFee);
557     }
558 
559     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
560         uint256 rAmount = tAmount.mul(currentRate);
561         uint256 rFee = tFee.mul(currentRate);
562         uint256 rTransferAmount = rAmount.sub(rFee);
563         return (rAmount, rTransferAmount, rFee);
564     }
565 
566     function _getRate() private view returns(uint256) {
567         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
568         return rSupply.div(tSupply);
569     }
570 
571     function _getCurrentSupply() private view returns(uint256, uint256) {
572         uint256 rSupply = _rTotal;
573         uint256 tSupply = _tTotal;      
574         for (uint256 i = 0; i < _excluded.length; i++) {
575             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
576             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
577             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
578         }
579         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
580         return (rSupply, tSupply);
581     }
582 
583     function setUniswapPair(address pair) external onlyOwner() {
584         uniswapPair = pair;
585     }
586 }