1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-22
3 */
4 
5 /**
6 //
7 //
8 //  Kishu Ken $KishuKen is a fully decentralized, peer-to-peer digital currency, owned in whole by its community with instant rewards for holders.
9 //	
10 //
11 // Website:  https://www.kenkishu.com
12 // Twitter:  https://twitter.com/Kishu_Ken	
13 // Telegram: https://t.me/KishuKen
14 // Make sure to read through our whitepaper found on our website!
15 */
16 
17 // SPDX-License-Identifier: Unlicensed
18 
19 pragma solidity ^0.6.12;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, reverting on
106      * overflow.
107      *
108      * Counterpart to Solidity's `+` operator.
109      *
110      * Requirements:
111      *
112      * - Addition cannot overflow.
113      */
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         require(c >= a, "SafeMath: addition overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return sub(a, b, "SafeMath: subtraction overflow");
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b <= a, errorMessage);
147         uint256 c = a - b;
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `*` operator.
157      *
158      * Requirements:
159      *
160      * - Multiplication cannot overflow.
161      */
162     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164         // benefit is lost if 'b' is also tested.
165         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
166         if (a == 0) {
167             return 0;
168         }
169 
170         uint256 c = a * b;
171         require(c / a == b, "SafeMath: multiplication overflow");
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b) internal pure returns (uint256) {
189         return div(a, b, "SafeMath: division by zero");
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b > 0, errorMessage);
206         uint256 c = a / b;
207         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
225         return mod(a, b, "SafeMath: modulo by zero");
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts with custom message when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b != 0, errorMessage);
242         return a % b;
243     }
244 }
245 
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
266         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
267         // for accounts without code, i.e. `keccak256('')`
268         bytes32 codehash;
269         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { codehash := extcodehash(account) }
272         return (codehash != accountHash && codehash != 0x0);
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293 
294         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
295         (bool success, ) = recipient.call{ value: amount }("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain`call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318       return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
328         return _functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         return _functionCallWithValue(target, data, value, errorMessage);
355     }
356 
357     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
358         require(isContract(target), "Address: call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
362         if (success) {
363             return returndata;
364         } else {
365             // Look for revert reason and bubble it up if present
366             if (returndata.length > 0) {
367                 // The easiest way to bubble the revert reason is using memory via assembly
368 
369                 // solhint-disable-next-line no-inline-assembly
370                 assembly {
371                     let returndata_size := mload(returndata)
372                     revert(add(32, returndata), returndata_size)
373                 }
374             } else {
375                 revert(errorMessage);
376             }
377         }
378     }
379 }
380 
381 contract Ownable is Context {
382     address private _owner;
383 
384     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
385 
386     /**
387      * @dev Initializes the contract setting the deployer as the initial owner.
388      */
389     constructor () internal {
390         address msgSender = _msgSender();
391         _owner = msgSender;
392         emit OwnershipTransferred(address(0), msgSender);
393     }
394 
395     /**
396      * @dev Returns the address of the current owner.
397      */
398     function owner() public view returns (address) {
399         return _owner;
400     }
401 
402     /**
403      * @dev Throws if called by any account other than the owner.
404      */
405     modifier onlyOwner() {
406         require(_owner == _msgSender(), "Ownable: caller is not the owner");
407         _;
408     }
409 
410     /**
411      * @dev Leaves the contract without owner. It will not be possible to call
412      * `onlyOwner` functions anymore. Can only be called by the current owner.
413      *
414      * NOTE: Renouncing ownership will leave the contract without an owner,
415      * thereby removing any functionality that is only available to the owner.
416      */
417     function renounceOwnership() public virtual onlyOwner {
418         emit OwnershipTransferred(_owner, address(0));
419         _owner = address(0);
420     }
421 
422     /**
423      * @dev Transfers ownership of the contract to a new account (`newOwner`).
424      * Can only be called by the current owner.
425      */
426     function transferOwnership(address newOwner) public virtual onlyOwner {
427         require(newOwner != address(0), "Ownable: new owner is the zero address");
428         emit OwnershipTransferred(_owner, newOwner);
429         _owner = newOwner;
430     }
431 }
432 
433 
434 
435 contract KishuKen is Context, IERC20, Ownable {
436     using SafeMath for uint256;
437     using Address for address;
438 
439     mapping (address => uint256) private _rOwned;
440     mapping (address => uint256) private _tOwned;
441     mapping (address => mapping (address => uint256)) private _allowances;
442 
443     mapping (address => bool) private _isExcluded;
444     address[] private _excluded;
445    
446     uint256 private constant MAX = ~uint256(0);
447     uint256 private constant _tTotal = 1000000000 * 10**6 * 10**9;
448     uint256 private _rTotal = (MAX - (MAX % _tTotal));
449     uint256 private _tFeeTotal;
450 
451     string private _name = 'Kishu Ken';
452     string private _symbol = 'KishuKen';
453     uint8 private _decimals = 9;
454     
455     uint256 public _maxTxAmount = 10000000 * 10**6 * 10**9;
456 
457     constructor () public {
458         _rOwned[_msgSender()] = _rTotal;
459         emit Transfer(address(0), _msgSender(), _tTotal);
460     }
461 
462     function name() public view returns (string memory) {
463         return _name;
464     }
465 
466     function symbol() public view returns (string memory) {
467         return _symbol;
468     }
469 
470     function decimals() public view returns (uint8) {
471         return _decimals;
472     }
473 
474     function totalSupply() public view override returns (uint256) {
475         return _tTotal;
476     }
477 
478     function balanceOf(address account) public view override returns (uint256) {
479         if (_isExcluded[account]) return _tOwned[account];
480         return tokenFromReflection(_rOwned[account]);
481     }
482 
483     function transfer(address recipient, uint256 amount) public override returns (bool) {
484         _transfer(_msgSender(), recipient, amount);
485         return true;
486     }
487 
488     function allowance(address owner, address spender) public view override returns (uint256) {
489         return _allowances[owner][spender];
490     }
491 
492     function approve(address spender, uint256 amount) public override returns (bool) {
493         _approve(_msgSender(), spender, amount);
494         return true;
495     }
496 
497     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
498         _transfer(sender, recipient, amount);
499         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
500         return true;
501     }
502 
503     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
504         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
505         return true;
506     }
507 
508     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
509         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
510         return true;
511     }
512 
513     function isExcluded(address account) public view returns (bool) {
514         return _isExcluded[account];
515     }
516 
517     function totalFees() public view returns (uint256) {
518         return _tFeeTotal;
519     }
520     
521     
522     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
523         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
524             10**2
525         );
526     }
527 
528     function reflect(uint256 tAmount) public {
529         address sender = _msgSender();
530         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
531         (uint256 rAmount,,,,) = _getValues(tAmount);
532         _rOwned[sender] = _rOwned[sender].sub(rAmount);
533         _rTotal = _rTotal.sub(rAmount);
534         _tFeeTotal = _tFeeTotal.add(tAmount);
535     }
536 
537     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
538         require(tAmount <= _tTotal, "Amount must be less than supply");
539         if (!deductTransferFee) {
540             (uint256 rAmount,,,,) = _getValues(tAmount);
541             return rAmount;
542         } else {
543             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
544             return rTransferAmount;
545         }
546     }
547 
548     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
549         require(rAmount <= _rTotal, "Amount must be less than total reflections");
550         uint256 currentRate =  _getRate();
551         return rAmount.div(currentRate);
552     }
553 
554     function excludeAccount(address account) external onlyOwner() {
555         require(!_isExcluded[account], "Account is already excluded");
556         if(_rOwned[account] > 0) {
557             _tOwned[account] = tokenFromReflection(_rOwned[account]);
558         }
559         _isExcluded[account] = true;
560         _excluded.push(account);
561     }
562 
563     function includeAccount(address account) external onlyOwner() {
564         require(_isExcluded[account], "Account is already excluded");
565         for (uint256 i = 0; i < _excluded.length; i++) {
566             if (_excluded[i] == account) {
567                 _excluded[i] = _excluded[_excluded.length - 1];
568                 _tOwned[account] = 0;
569                 _isExcluded[account] = false;
570                 _excluded.pop();
571                 break;
572             }
573         }
574     }
575 
576     function _approve(address owner, address spender, uint256 amount) private {
577         require(owner != address(0), "ERC20: approve from the zero address");
578         require(spender != address(0), "ERC20: approve to the zero address");
579 
580         _allowances[owner][spender] = amount;
581         emit Approval(owner, spender, amount);
582     }
583 
584     function _transfer(address sender, address recipient, uint256 amount) private {
585         require(sender != address(0), "ERC20: transfer from the zero address");
586         require(recipient != address(0), "ERC20: transfer to the zero address");
587         require(amount > 0, "Transfer amount must be greater than zero");
588         if(sender != owner() && recipient != owner())
589           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
590             
591         if (_isExcluded[sender] && !_isExcluded[recipient]) {
592             _transferFromExcluded(sender, recipient, amount);
593         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
594             _transferToExcluded(sender, recipient, amount);
595         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
596             _transferStandard(sender, recipient, amount);
597         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
598             _transferBothExcluded(sender, recipient, amount);
599         } else {
600             _transferStandard(sender, recipient, amount);
601         }
602     }
603 
604     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
605         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
606         _rOwned[sender] = _rOwned[sender].sub(rAmount);
607         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
608         _reflectFee(rFee, tFee);
609         emit Transfer(sender, recipient, tTransferAmount);
610     }
611 
612     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
613         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
614         _rOwned[sender] = _rOwned[sender].sub(rAmount);
615         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
616         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
617         _reflectFee(rFee, tFee);
618         emit Transfer(sender, recipient, tTransferAmount);
619     }
620 
621     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
622         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
623         _tOwned[sender] = _tOwned[sender].sub(tAmount);
624         _rOwned[sender] = _rOwned[sender].sub(rAmount);
625         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
626         _reflectFee(rFee, tFee);
627         emit Transfer(sender, recipient, tTransferAmount);
628     }
629 
630     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
631         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
632         _tOwned[sender] = _tOwned[sender].sub(tAmount);
633         _rOwned[sender] = _rOwned[sender].sub(rAmount);
634         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
635         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
636         _reflectFee(rFee, tFee);
637         emit Transfer(sender, recipient, tTransferAmount);
638     }
639 
640     function _reflectFee(uint256 rFee, uint256 tFee) private {
641         _rTotal = _rTotal.sub(rFee);
642         _tFeeTotal = _tFeeTotal.add(tFee);
643     }
644 
645     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
646         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
647         uint256 currentRate =  _getRate();
648         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
649         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
650     }
651 
652     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
653         uint256 tFee = tAmount.div(100).mul(2);
654         uint256 tTransferAmount = tAmount.sub(tFee);
655         return (tTransferAmount, tFee);
656     }
657 
658     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
659         uint256 rAmount = tAmount.mul(currentRate);
660         uint256 rFee = tFee.mul(currentRate);
661         uint256 rTransferAmount = rAmount.sub(rFee);
662         return (rAmount, rTransferAmount, rFee);
663     }
664 
665     function _getRate() private view returns(uint256) {
666         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
667         return rSupply.div(tSupply);
668     }
669 
670     function _getCurrentSupply() private view returns(uint256, uint256) {
671         uint256 rSupply = _rTotal;
672         uint256 tSupply = _tTotal;      
673         for (uint256 i = 0; i < _excluded.length; i++) {
674             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
675             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
676             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
677         }
678         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
679         return (rSupply, tSupply);
680     }
681 }