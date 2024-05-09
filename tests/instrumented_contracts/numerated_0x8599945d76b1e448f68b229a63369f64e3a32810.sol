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
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      * Returns a boolean value indicating whether the operation succeeded.
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
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
83      * Counterpart to Solidity's `+` operator.
84      * Requirements:
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the subtraction of two unsigned integers, reverting on
96      * overflow (when the result is negative).
97      *
98      * Counterpart to Solidity's `-` operator.
99      *
100      * Requirements:
101      *
102      * - Subtraction cannot overflow.
103      */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return sub(a, b, "SafeMath: subtraction overflow");
106     }
107 
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
121 
122         return c;
123     }
124 
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
142 
143         uint256 c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers. Reverts on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator. Note: this function uses a
154      * `revert` opcode (which leaves remaining gas untouched) while Solidity
155      * uses an invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         return div(a, b, "SafeMath: division by zero");
163     }
164 
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
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
187      * Reverts when dividing by zero.
188      *
189      * Counterpart to Solidity's `%` operator. This function uses a `revert`
190      * opcode (which leaves remaining gas untouched) while Solidity uses an
191      * invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
198         return mod(a, b, "SafeMath: modulo by zero");
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts with custom message when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         require(b != 0, errorMessage);
215         return a % b;
216     }
217 }
218 
219 library Address {
220     /**
221      * @dev Returns true if `account` is a contract.
222      *
223      * [IMPORTANT]
224      * ====
225      * It is unsafe to assume that an address for which this function returns
226      * false is an externally-owned account (EOA) and not a contract.
227      *
228      * Among others, `isContract` will return false for the following
229      * types of addresses:
230      *
231      *  - an externally-owned account
232      *  - a contract in construction
233      *  - an address where a contract will be created
234      *  - an address where a contract lived, but was destroyed
235      * ====
236      */
237     function isContract(address account) internal view returns (bool) {
238         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
239         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
240         // for accounts without code, i.e. `keccak256('')`
241         bytes32 codehash;
242         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
243         // solhint-disable-next-line no-inline-assembly
244         assembly { codehash := extcodehash(account) }
245         return (codehash != accountHash && codehash != 0x0);
246     }
247 
248     /**
249      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
250      * `recipient`, forwarding all available gas and reverting on errors.
251      *
252      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
253      * of certain opcodes, possibly making contracts go over the 2300 gas limit
254      * imposed by `transfer`, making them unable to receive funds via
255      * `transfer`. {sendValue} removes this limitation.
256      *
257      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
258      *
259      * IMPORTANT: because control is transferred to `recipient`, care must be
260      * taken to not create reentrancy vulnerabilities. Consider using
261      * {ReentrancyGuard} or the
262      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
263      */
264     function sendValue(address payable recipient, uint256 amount) internal {
265         require(address(this).balance >= amount, "Address: insufficient balance");
266 
267         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
268         (bool success, ) = recipient.call{ value: amount }("");
269         require(success, "Address: unable to send value, recipient may have reverted");
270     }
271 
272     /**
273      * @dev Performs a Solidity function call using a low level `call`. A
274      * plain`call` is an unsafe replacement for a function call: use this
275      * function instead.
276      *
277      * If `target` reverts with a revert reason, it is bubbled up by this
278      * function (like regular Solidity function calls).
279      *
280      * Returns the raw returned data. To convert to the expected return value,
281      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
282      *
283      * Requirements:
284      *
285      * - `target` must be a contract.
286      * - calling `target` with `data` must not revert.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
291       return functionCall(target, data, "Address: low-level call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
296      * `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
301         return _functionCallWithValue(target, data, 0, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but also transferring `value` wei to `target`.
307      *
308      * Requirements:
309      *
310      * - the calling contract must have an ETH balance of at least `value`.
311      * - the called Solidity function must be `payable`.
312      *
313      * _Available since v3.1._
314      */
315     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
316         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
321      * with `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
326         require(address(this).balance >= value, "Address: insufficient balance for call");
327         return _functionCallWithValue(target, data, value, errorMessage);
328     }
329 
330     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
331         require(isContract(target), "Address: call to non-contract");
332 
333         // solhint-disable-next-line avoid-low-level-calls
334         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
335         if (success) {
336             return returndata;
337         } else {
338             // Look for revert reason and bubble it up if present
339             if (returndata.length > 0) {
340                 // The easiest way to bubble the revert reason is using memory via assembly
341 
342                 // solhint-disable-next-line no-inline-assembly
343                 assembly {
344                     let returndata_size := mload(returndata)
345                     revert(add(32, returndata), returndata_size)
346                 }
347             } else {
348                 revert(errorMessage);
349             }
350         }
351     }
352 }
353 
354 contract Ownable is Context {
355     address private _owner;
356 
357     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
358 
359     /**
360      * @dev Initializes the contract setting the deployer as the initial owner.
361      */
362     constructor () internal {
363         address msgSender = _msgSender();
364         _owner = msgSender;
365         emit OwnershipTransferred(address(0), msgSender);
366     }
367 
368     /**
369      * @dev Returns the address of the current owner.
370      */
371     function owner() public view returns (address) {
372         return _owner;
373     }
374 
375     /**
376      * @dev Throws if called by any account other than the owner.
377      */
378     modifier onlyOwner() {
379         require(_owner == _msgSender(), "Ownable: caller is not the owner");
380         _;
381     }
382 
383     /**
384      * @dev Leaves the contract without owner. It will not be possible to call
385      * `onlyOwner` functions anymore. Can only be called by the current owner.
386      *
387      */
388     function renounceOwnership() public virtual onlyOwner {
389         emit OwnershipTransferred(_owner, address(0));
390         _owner = address(0);
391     }
392 
393     /**
394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
395      * Can only be called by the current owner.
396      */
397     function transferOwnership(address newOwner) public virtual onlyOwner {
398         require(newOwner != address(0), "Ownable: new owner is the zero address");
399         emit OwnershipTransferred(_owner, newOwner);
400         _owner = newOwner;
401     }
402 }
403 
404 
405 contract WEB3X is Context, IERC20, Ownable {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     mapping (address => uint256) private _rOwned;
410     mapping (address => uint256) private _tOwned;
411     mapping (address => mapping (address => uint256)) private _allowances;
412 
413     mapping (address => bool) private _isExcluded;
414     address[] private _excluded;
415    
416     uint256 private constant MAX = ~uint256(0);
417     uint256 private constant _tTotal = 1000000000 * 10**6 * 10**9;
418     uint256 private _rTotal = (MAX - (MAX % _tTotal));
419     uint256 private _tFeeTotal;
420 
421     string private _name = 'WEB3 X';
422     string private _symbol = 'WEB3X';
423     uint8 private _decimals = 9;
424     uint256 public _maxTxAmount = 10000000 * 10**6 * 10**9;
425 
426     uint8 public transfertimeout = 15;
427     address public uniswapPair;
428     mapping (address => uint256) public lastBuy; 
429 
430     constructor () public {
431         _rOwned[_msgSender()] = _rTotal;
432         emit Transfer(address(0), _msgSender(), _tTotal);
433     }
434 
435     function name() public view returns (string memory) {
436         return _name;
437     }
438 
439     function symbol() public view returns (string memory) {
440         return _symbol;
441     }
442 
443     function decimals() public view returns (uint8) {
444         return _decimals;
445     }
446 
447     function totalSupply() public view override returns (uint256) {
448         return _tTotal;
449     }
450 
451     function balanceOf(address account) public view override returns (uint256) {
452         if (_isExcluded[account]) return _tOwned[account];
453         return tokenFromReflection(_rOwned[account]);
454     }
455 
456     function transfer(address recipient, uint256 amount) public override returns (bool) {
457         _transfer(_msgSender(), recipient, amount);
458         return true;
459     }
460 
461     function allowance(address owner, address spender) public view override returns (uint256) {
462         return _allowances[owner][spender];
463     }
464 
465     function approve(address spender, uint256 amount) public override returns (bool) {
466         _approve(_msgSender(), spender, amount);
467         return true;
468     }
469 
470     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
471         _transfer(sender, recipient, amount);
472         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
473         return true;
474     }
475 
476     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
477         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
478         return true;
479     }
480 
481     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
482         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
483         return true;
484     }
485 
486     function isExcluded(address account) public view returns (bool) {
487         return _isExcluded[account];
488     }
489 
490     function totalFees() public view returns (uint256) {
491         return _tFeeTotal;
492     }
493     
494     
495     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
496         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
497             10**1
498         );
499     }
500 
501     function reflect(uint256 tAmount) public {
502         address sender = _msgSender();
503         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
504         (uint256 rAmount,,,,) = _getValues(tAmount);
505         _rOwned[sender] = _rOwned[sender].sub(rAmount);
506         _rTotal = _rTotal.sub(rAmount);
507         _tFeeTotal = _tFeeTotal.add(tAmount);
508     }
509 
510     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
511         require(tAmount <= _tTotal, "Amount must be less than supply");
512         if (!deductTransferFee) {
513             (uint256 rAmount,,,,) = _getValues(tAmount);
514             return rAmount;
515         } else {
516             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
517             return rTransferAmount;
518         }
519     }
520 
521     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
522         require(rAmount <= _rTotal, "Amount must be less than total reflections");
523         uint256 currentRate =  _getRate();
524         return rAmount.div(currentRate);
525     }
526 
527     function excludeAccount(address account) external onlyOwner() {
528         require(!_isExcluded[account], "Account is already excluded");
529         if(_rOwned[account] > 0) {
530             _tOwned[account] = tokenFromReflection(_rOwned[account]);
531         }
532         _isExcluded[account] = true;
533         _excluded.push(account);
534     }
535 
536     function includeAccount(address account) external onlyOwner() {
537         require(_isExcluded[account], "Account is already excluded");
538         for (uint256 i = 0; i < _excluded.length; i++) {
539             if (_excluded[i] == account) {
540                 _excluded[i] = _excluded[_excluded.length - 1];
541                 _tOwned[account] = 0;
542                 _isExcluded[account] = false;
543                 _excluded.pop();
544                 break;
545             }
546         }
547     }
548 
549     function _approve(address owner, address spender, uint256 amount) private {
550         require(owner != address(0), "ERC20: approve from the zero address");
551         require(spender != address(0), "ERC20: approve to the zero address");
552 
553         _allowances[owner][spender] = amount;
554         emit Approval(owner, spender, amount);
555     }
556 
557     function _transfer(address sender, address recipient, uint256 amount) private {
558         require(sender != address(0), "ERC20: transfer from the zero address");
559         require(recipient != address(0), "ERC20: transfer to the zero address");
560         require(amount > 0, "Transfer amount must be greater than zero");
561         if(sender != owner() && recipient != owner())
562           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
563         
564         //save last buy
565         if (sender == uniswapPair){
566             lastBuy[recipient] = block.timestamp; 
567         }
568 
569         //check if sell
570         if (recipient == uniswapPair){
571             require(block.timestamp >= lastBuy[sender] + transfertimeout, "anti bot 15 seconds lock");
572         }        
573 
574         if (_isExcluded[sender] && !_isExcluded[recipient]) {
575             _transferFromExcluded(sender, recipient, amount);
576         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
577             _transferToExcluded(sender, recipient, amount);
578         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
579             _transferStandard(sender, recipient, amount);
580         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
581             _transferBothExcluded(sender, recipient, amount);
582         } else {
583             _transferStandard(sender, recipient, amount);
584         }
585     }
586 
587     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
588         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
589         _rOwned[sender] = _rOwned[sender].sub(rAmount);
590         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
591         _reflectFee(rFee, tFee);
592         emit Transfer(sender, recipient, tTransferAmount);
593     }
594 
595     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
596         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
597         _rOwned[sender] = _rOwned[sender].sub(rAmount);
598         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
599         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
600         _reflectFee(rFee, tFee);
601         emit Transfer(sender, recipient, tTransferAmount);
602     }
603 
604     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
605         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
606         _tOwned[sender] = _tOwned[sender].sub(tAmount);
607         _rOwned[sender] = _rOwned[sender].sub(rAmount);
608         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
609         _reflectFee(rFee, tFee);
610         emit Transfer(sender, recipient, tTransferAmount);
611     }
612 
613     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
614         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
615         _tOwned[sender] = _tOwned[sender].sub(tAmount);
616         _rOwned[sender] = _rOwned[sender].sub(rAmount);
617         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
618         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
619         _reflectFee(rFee, tFee);
620         emit Transfer(sender, recipient, tTransferAmount);
621     }
622 
623     function _reflectFee(uint256 rFee, uint256 tFee) private {
624         _rTotal = _rTotal.sub(rFee);
625         _tFeeTotal = _tFeeTotal.add(tFee);
626     }
627 
628     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
629         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
630         uint256 currentRate =  _getRate();
631         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
632         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
633     }
634 
635     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
636         uint256 tFee = tAmount.div(1000).mul(4);
637         uint256 tTransferAmount = tAmount.sub(tFee);
638         return (tTransferAmount, tFee);
639     }
640 
641     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
642         uint256 rAmount = tAmount.mul(currentRate);
643         uint256 rFee = tFee.mul(currentRate);
644         uint256 rTransferAmount = rAmount.sub(rFee);
645         return (rAmount, rTransferAmount, rFee);
646     }
647 
648     function _getRate() private view returns(uint256) {
649         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
650         return rSupply.div(tSupply);
651     }
652 
653     function _getCurrentSupply() private view returns(uint256, uint256) {
654         uint256 rSupply = _rTotal;
655         uint256 tSupply = _tTotal;      
656         for (uint256 i = 0; i < _excluded.length; i++) {
657             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
658             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
659             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
660         }
661         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
662         return (rSupply, tSupply);
663     }
664 
665     function setUniswapPair(address pair) external onlyOwner() {
666         uniswapPair = pair;
667     }
668 }