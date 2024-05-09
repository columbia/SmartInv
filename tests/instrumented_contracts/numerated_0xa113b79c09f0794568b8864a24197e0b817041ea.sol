1 /**
2 https://pink-nft.com/
3 **/
4 
5 
6 // SPDX-License-Identifier: Unlicensed
7 
8 pragma solidity ^0.6.12;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address payable) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes memory) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
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
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 library Address {
236     /**
237      * @dev Returns true if `account` is a contract.
238      *
239      * [IMPORTANT]
240      * ====
241      * It is unsafe to assume that an address for which this function returns
242      * false is an externally-owned account (EOA) and not a contract.
243      *
244      * Among others, `isContract` will return false for the following
245      * types of addresses:
246      *
247      *  - an externally-owned account
248      *  - a contract in construction
249      *  - an address where a contract will be created
250      *  - an address where a contract lived, but was destroyed
251      * ====
252      */
253     function isContract(address account) internal view returns (bool) {
254         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
255         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
256         // for accounts without code, i.e. `keccak256('')`
257         bytes32 codehash;
258         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
259         // solhint-disable-next-line no-inline-assembly
260         assembly { codehash := extcodehash(account) }
261         return (codehash != accountHash && codehash != 0x0);
262     }
263 
264     /**
265      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
266      * `recipient`, forwarding all available gas and reverting on errors.
267      *
268      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
269      * of certain opcodes, possibly making contracts go over the 2300 gas limit
270      * imposed by `transfer`, making them unable to receive funds via
271      * `transfer`. {sendValue} removes this limitation.
272      *
273      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
274      *
275      * IMPORTANT: because control is transferred to `recipient`, care must be
276      * taken to not create reentrancy vulnerabilities. Consider using
277      * {ReentrancyGuard} or the
278      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
279      */
280     function sendValue(address payable recipient, uint256 amount) internal {
281         require(address(this).balance >= amount, "Address: insufficient balance");
282 
283         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
284         (bool success, ) = recipient.call{ value: amount }("");
285         require(success, "Address: unable to send value, recipient may have reverted");
286     }
287 
288     /**
289      * @dev Performs a Solidity function call using a low level `call`. A
290      * plain`call` is an unsafe replacement for a function call: use this
291      * function instead.
292      *
293      * If `target` reverts with a revert reason, it is bubbled up by this
294      * function (like regular Solidity function calls).
295      *
296      * Returns the raw returned data. To convert to the expected return value,
297      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
298      *
299      * Requirements:
300      *
301      * - `target` must be a contract.
302      * - calling `target` with `data` must not revert.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
307       return functionCall(target, data, "Address: low-level call failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
312      * `errorMessage` as a fallback revert reason when `target` reverts.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
317         return _functionCallWithValue(target, data, 0, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but also transferring `value` wei to `target`.
323      *
324      * Requirements:
325      *
326      * - the calling contract must have an ETH balance of at least `value`.
327      * - the called Solidity function must be `payable`.
328      *
329      * _Available since v3.1._
330      */
331     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
337      * with `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
342         require(address(this).balance >= value, "Address: insufficient balance for call");
343         return _functionCallWithValue(target, data, value, errorMessage);
344     }
345 
346     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
347         require(isContract(target), "Address: call to non-contract");
348 
349         // solhint-disable-next-line avoid-low-level-calls
350         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
351         if (success) {
352             return returndata;
353         } else {
354             // Look for revert reason and bubble it up if present
355             if (returndata.length > 0) {
356                 // The easiest way to bubble the revert reason is using memory via assembly
357 
358                 // solhint-disable-next-line no-inline-assembly
359                 assembly {
360                     let returndata_size := mload(returndata)
361                     revert(add(32, returndata), returndata_size)
362                 }
363             } else {
364                 revert(errorMessage);
365             }
366         }
367     }
368 }
369 
370 contract Ownable is Context {
371     address private _owner;
372 
373     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375     /**
376      * @dev Initializes the contract setting the deployer as the initial owner.
377      */
378     constructor () internal {
379         address msgSender = _msgSender();
380         _owner = msgSender;
381         emit OwnershipTransferred(address(0), msgSender);
382     }
383 
384     /**
385      * @dev Returns the address of the current owner.
386      */
387     function owner() public view returns (address) {
388         return _owner;
389     }
390 
391     /**
392      * @dev Throws if called by any account other than the owner.
393      */
394     modifier onlyOwner() {
395         require(_owner == _msgSender(), "Ownable: caller is not the owner");
396         _;
397     }
398 
399     /**
400      * @dev Leaves the contract without owner. It will not be possible to call
401      * `onlyOwner` functions anymore. Can only be called by the current owner.
402      *
403      * NOTE: Renouncing ownership will leave the contract without an owner,
404      * thereby removing any functionality that is only available to the owner.
405      */
406     function renounceOwnership() public virtual onlyOwner {
407         emit OwnershipTransferred(_owner, address(0));
408         _owner = address(0);
409     }
410 
411     /**
412      * @dev Transfers ownership of the contract to a new account (`newOwner`).
413      * Can only be called by the current owner.
414      */
415     function transferOwnership(address newOwner) public virtual onlyOwner {
416         require(newOwner != address(0), "Ownable: new owner is the zero address");
417         emit OwnershipTransferred(_owner, newOwner);
418         _owner = newOwner;
419     }
420 }
421 
422 
423 
424 contract PinkPanther is Context, IERC20, Ownable {
425     using SafeMath for uint256;
426     using Address for address;
427 
428     mapping (address => uint256) private _rOwned;
429     mapping (address => uint256) private _tOwned;
430     mapping (address => mapping (address => uint256)) private _allowances;
431 
432     mapping (address => bool) private _isExcluded;
433     address[] private _excluded;
434    
435     uint256 private constant MAX = ~uint256(0);
436     uint256 private constant _tTotal = 100000000 * 10**6 * 10**18;
437     uint256 private _rTotal = (MAX - (MAX % _tTotal));
438     uint256 private _tFeeTotal;
439 
440     string private _name = 'Pink Panther';
441     string private _symbol = 'PINK';
442     uint8 private _decimals = 18;
443     
444     uint256 public _maxTxAmount = 100000000 * 10**6 * 10**18;
445 
446     constructor () public {
447         _rOwned[_msgSender()] = _rTotal;
448         emit Transfer(address(0), _msgSender(), _tTotal);
449     }
450 
451     function name() public view returns (string memory) {
452         return _name;
453     }
454 
455     function symbol() public view returns (string memory) {
456         return _symbol;
457     }
458 
459     function decimals() public view returns (uint8) {
460         return _decimals;
461     }
462 
463     function totalSupply() public view override returns (uint256) {
464         return _tTotal;
465     }
466 
467     function balanceOf(address account) public view override returns (uint256) {
468         if (_isExcluded[account]) return _tOwned[account];
469         return tokenFromReflection(_rOwned[account]);
470     }
471 
472     function transfer(address recipient, uint256 amount) public override returns (bool) {
473         _transfer(_msgSender(), recipient, amount);
474         return true;
475     }
476 
477     function allowance(address owner, address spender) public view override returns (uint256) {
478         return _allowances[owner][spender];
479     }
480 
481     function approve(address spender, uint256 amount) public override returns (bool) {
482         _approve(_msgSender(), spender, amount);
483         return true;
484     }
485 
486     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
487         _transfer(sender, recipient, amount);
488         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
489         return true;
490     }
491 
492     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
494         return true;
495     }
496 
497     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
498         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
499         return true;
500     }
501 
502     function isExcluded(address account) public view returns (bool) {
503         return _isExcluded[account];
504     }
505 
506     function totalFees() public view returns (uint256) {
507         return _tFeeTotal;
508     }
509     
510     
511     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
512         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
513             10**2
514         );
515     }
516     
517     function rescueFromContract() external onlyOwner {
518         address payable _owner = _msgSender();
519         _owner.transfer(address(this).balance);
520     }
521 
522     function reflect(uint256 tAmount) public {
523         address sender = _msgSender();
524         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
525         (uint256 rAmount,,,,) = _getValues(tAmount);
526         _rOwned[sender] = _rOwned[sender].sub(rAmount);
527         _rTotal = _rTotal.sub(rAmount);
528         _tFeeTotal = _tFeeTotal.add(tAmount);
529     }
530 
531     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
532         require(tAmount <= _tTotal, "Amount must be less than supply");
533         if (!deductTransferFee) {
534             (uint256 rAmount,,,,) = _getValues(tAmount);
535             return rAmount;
536         } else {
537             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
538             return rTransferAmount;
539         }
540     }
541 
542     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
543         require(rAmount <= _rTotal, "Amount must be less than total reflections");
544         uint256 currentRate =  _getRate();
545         return rAmount.div(currentRate);
546     }
547 
548     function excludeAccount(address account) external onlyOwner() {
549         require(!_isExcluded[account], "Account is already excluded");
550         if(_rOwned[account] > 0) {
551             _tOwned[account] = tokenFromReflection(_rOwned[account]);
552         }
553         _isExcluded[account] = true;
554         _excluded.push(account);
555     }
556 
557     function includeAccount(address account) external onlyOwner() {
558         require(_isExcluded[account], "Account is already excluded");
559         for (uint256 i = 0; i < _excluded.length; i++) {
560             if (_excluded[i] == account) {
561                 _excluded[i] = _excluded[_excluded.length - 1];
562                 _tOwned[account] = 0;
563                 _isExcluded[account] = false;
564                 _excluded.pop();
565                 break;
566             }
567         }
568     }
569 
570     function _approve(address owner, address spender, uint256 amount) private {
571         require(owner != address(0), "ERC20: approve from the zero address");
572         require(spender != address(0), "ERC20: approve to the zero address");
573 
574         _allowances[owner][spender] = amount;
575         emit Approval(owner, spender, amount);
576     }
577 
578     function _transfer(address sender, address recipient, uint256 amount) private {
579         require(sender != address(0), "ERC20: transfer from the zero address");
580         require(recipient != address(0), "ERC20: transfer to the zero address");
581         require(amount > 0, "Transfer amount must be greater than zero");
582         if(sender != owner() && recipient != owner())
583           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
584             
585         if (_isExcluded[sender] && !_isExcluded[recipient]) {
586             _transferFromExcluded(sender, recipient, amount);
587         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
588             _transferToExcluded(sender, recipient, amount);
589         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
590             _transferStandard(sender, recipient, amount);
591         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
592             _transferBothExcluded(sender, recipient, amount);
593         } else {
594             _transferStandard(sender, recipient, amount);
595         }
596     }
597 
598     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
599         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
600         _rOwned[sender] = _rOwned[sender].sub(rAmount);
601         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
602         _reflectFee(rFee, tFee);
603         emit Transfer(sender, recipient, tTransferAmount);
604     }
605 
606     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
607         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
608         _rOwned[sender] = _rOwned[sender].sub(rAmount);
609         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
610         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
611         _reflectFee(rFee, tFee);
612         emit Transfer(sender, recipient, tTransferAmount);
613     }
614 
615     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
616         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
617         _tOwned[sender] = _tOwned[sender].sub(tAmount);
618         _rOwned[sender] = _rOwned[sender].sub(rAmount);
619         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
620         _reflectFee(rFee, tFee);
621         emit Transfer(sender, recipient, tTransferAmount);
622     }
623 
624     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
625         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
626         _tOwned[sender] = _tOwned[sender].sub(tAmount);
627         _rOwned[sender] = _rOwned[sender].sub(rAmount);
628         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
629         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
630         _reflectFee(rFee, tFee);
631         emit Transfer(sender, recipient, tTransferAmount);
632     }
633 
634     function _reflectFee(uint256 rFee, uint256 tFee) private {
635         _rTotal = _rTotal.sub(rFee);
636         _tFeeTotal = _tFeeTotal.add(tFee);
637     }
638 
639     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
640         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
641         uint256 currentRate =  _getRate();
642         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
643         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
644     }
645 
646     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
647         uint256 tFee = tAmount.div(100).mul(2);
648         uint256 tTransferAmount = tAmount.sub(tFee);
649         return (tTransferAmount, tFee);
650     }
651 
652     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
653         uint256 rAmount = tAmount.mul(currentRate);
654         uint256 rFee = tFee.mul(currentRate);
655         uint256 rTransferAmount = rAmount.sub(rFee);
656         return (rAmount, rTransferAmount, rFee);
657     }
658 
659     function _getRate() private view returns(uint256) {
660         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
661         return rSupply.div(tSupply);
662     }
663 
664     function _getCurrentSupply() private view returns(uint256, uint256) {
665         uint256 rSupply = _rTotal;
666         uint256 tSupply = _tTotal;      
667         for (uint256 i = 0; i < _excluded.length; i++) {
668             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
669             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
670             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
671         }
672         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
673         return (rSupply, tSupply);
674     }
675 }