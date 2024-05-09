1 // Suck Elon's Cock (SEC)
2 // 420 blaze it
3 
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.6.12;
8 
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
424 contract SEC is Context, IERC20, Ownable {
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
436     uint256 private constant _tTotal = 100000000 * 10**6 * 10**9;
437     uint256 private _rTotal = (MAX - (MAX % _tTotal));
438     uint256 private _tFeeTotal;
439 
440     string private _name = 'Suck Elons Cock';
441     string private _symbol = 'SEC';
442     uint8 private _decimals = 9;
443 
444     constructor () public {
445         _rOwned[_msgSender()] = _rTotal;
446         emit Transfer(address(0), _msgSender(), _tTotal);
447     }
448 
449     function name() public view returns (string memory) {
450         return _name;
451     }
452 
453     function symbol() public view returns (string memory) {
454         return _symbol;
455     }
456 
457     function decimals() public view returns (uint8) {
458         return _decimals;
459     }
460 
461     function totalSupply() public view override returns (uint256) {
462         return _tTotal;
463     }
464 
465     function balanceOf(address account) public view override returns (uint256) {
466         if (_isExcluded[account]) return _tOwned[account];
467         return tokenFromReflection(_rOwned[account]);
468     }
469 
470     function transfer(address recipient, uint256 amount) public override returns (bool) {
471         _transfer(_msgSender(), recipient, amount);
472         return true;
473     }
474 
475     function allowance(address owner, address spender) public view override returns (uint256) {
476         return _allowances[owner][spender];
477     }
478 
479     function approve(address spender, uint256 amount) public override returns (bool) {
480         _approve(_msgSender(), spender, amount);
481         return true;
482     }
483 
484     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
485         _transfer(sender, recipient, amount);
486         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
487         return true;
488     }
489 
490     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
491         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
492         return true;
493     }
494 
495     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
496         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
497         return true;
498     }
499 
500     function isExcluded(address account) public view returns (bool) {
501         return _isExcluded[account];
502     }
503 
504     function totalFees() public view returns (uint256) {
505         return _tFeeTotal;
506     }
507 
508     function reflect(uint256 tAmount) public {
509         address sender = _msgSender();
510         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
511         (uint256 rAmount,,,,) = _getValues(tAmount);
512         _rOwned[sender] = _rOwned[sender].sub(rAmount);
513         _rTotal = _rTotal.sub(rAmount);
514         _tFeeTotal = _tFeeTotal.add(tAmount);
515     }
516 
517     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
518         require(tAmount <= _tTotal, "Amount must be less than supply");
519         if (!deductTransferFee) {
520             (uint256 rAmount,,,,) = _getValues(tAmount);
521             return rAmount;
522         } else {
523             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
524             return rTransferAmount;
525         }
526     }
527 
528     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
529         require(rAmount <= _rTotal, "Amount must be less than total reflections");
530         uint256 currentRate =  _getRate();
531         return rAmount.div(currentRate);
532     }
533 
534     function excludeAccount(address account) external onlyOwner() {
535         require(!_isExcluded[account], "Account is already excluded");
536         if(_rOwned[account] > 0) {
537             _tOwned[account] = tokenFromReflection(_rOwned[account]);
538         }
539         _isExcluded[account] = true;
540         _excluded.push(account);
541     }
542 
543     function includeAccount(address account) external onlyOwner() {
544         require(_isExcluded[account], "Account is already excluded");
545         for (uint256 i = 0; i < _excluded.length; i++) {
546             if (_excluded[i] == account) {
547                 _excluded[i] = _excluded[_excluded.length - 1];
548                 _tOwned[account] = 0;
549                 _isExcluded[account] = false;
550                 _excluded.pop();
551                 break;
552             }
553         }
554     }
555 
556     function _approve(address owner, address spender, uint256 amount) private {
557         require(owner != address(0), "ERC20: approve from the zero address");
558         require(spender != address(0), "ERC20: approve to the zero address");
559 
560         _allowances[owner][spender] = amount;
561         emit Approval(owner, spender, amount);
562     }
563 
564     function _transfer(address sender, address recipient, uint256 amount) private {
565         require(sender != address(0), "ERC20: transfer from the zero address");
566         require(recipient != address(0), "ERC20: transfer to the zero address");
567         require(amount > 0, "Transfer amount must be greater than zero");
568         if (_isExcluded[sender] && !_isExcluded[recipient]) {
569             _transferFromExcluded(sender, recipient, amount);
570         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
571             _transferToExcluded(sender, recipient, amount);
572         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
573             _transferStandard(sender, recipient, amount);
574         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
575             _transferBothExcluded(sender, recipient, amount);
576         } else {
577             _transferStandard(sender, recipient, amount);
578         }
579     }
580 
581     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
582         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
583         _rOwned[sender] = _rOwned[sender].sub(rAmount);
584         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
585         _reflectFee(rFee, tFee);
586         emit Transfer(sender, recipient, tTransferAmount);
587     }
588 
589     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
590         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
591         _rOwned[sender] = _rOwned[sender].sub(rAmount);
592         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
593         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
594         _reflectFee(rFee, tFee);
595         emit Transfer(sender, recipient, tTransferAmount);
596     }
597 
598     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
599         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
600         _tOwned[sender] = _tOwned[sender].sub(tAmount);
601         _rOwned[sender] = _rOwned[sender].sub(rAmount);
602         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
603         _reflectFee(rFee, tFee);
604         emit Transfer(sender, recipient, tTransferAmount);
605     }
606 
607     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
608         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
609         _tOwned[sender] = _tOwned[sender].sub(tAmount);
610         _rOwned[sender] = _rOwned[sender].sub(rAmount);
611         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
612         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
613         _reflectFee(rFee, tFee);
614         emit Transfer(sender, recipient, tTransferAmount);
615     }
616 
617     function _reflectFee(uint256 rFee, uint256 tFee) private {
618         _rTotal = _rTotal.sub(rFee);
619         _tFeeTotal = _tFeeTotal.add(tFee);
620     }
621 
622     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
623         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
624         uint256 currentRate =  _getRate();
625         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
626         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
627     }
628 
629     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
630         uint256 tFee = tAmount.div(1000).mul(42);
631         uint256 tTransferAmount = tAmount.sub(tFee);
632         return (tTransferAmount, tFee);
633     }
634 
635     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
636         uint256 rAmount = tAmount.mul(currentRate);
637         uint256 rFee = tFee.mul(currentRate);
638         uint256 rTransferAmount = rAmount.sub(rFee);
639         return (rAmount, rTransferAmount, rFee);
640     }
641 
642     function _getRate() private view returns(uint256) {
643         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
644         return rSupply.div(tSupply);
645     }
646 
647     function _getCurrentSupply() private view returns(uint256, uint256) {
648         uint256 rSupply = _rTotal;
649         uint256 tSupply = _tTotal;      
650         for (uint256 i = 0; i < _excluded.length; i++) {
651             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
652             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
653             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
654         }
655         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
656         return (rSupply, tSupply);
657     }
658 }