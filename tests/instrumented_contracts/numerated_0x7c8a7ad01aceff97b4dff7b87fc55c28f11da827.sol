1 /**
2 //
3 //  A long time ago in a galaxy far, far away...
4 //	
5 //
6 //  ░██████╗░░█████╗░██╗░░░░░░█████╗░░█████╗░████████╗██╗░█████╗░  ░██████╗██╗░░██╗██╗██████╗░░█████╗░
7 //  ██╔════╝░██╔══██╗██║░░░░░██╔══██╗██╔══██╗╚══██╔══╝██║██╔══██╗  ██╔════╝██║░░██║██║██╔══██╗██╔══██╗
8 //  ██║░░██╗░███████║██║░░░░░███████║██║░░╚═╝░░░██║░░░██║██║░░╚═╝  ╚█████╗░███████║██║██████╦╝███████║
9 //  ██║░░╚██╗██╔══██║██║░░░░░██╔══██║██║░░██╗░░░██║░░░██║██║░░██╗  ░╚═══██╗██╔══██║██║██╔══██╗██╔══██║
10 //  ╚██████╔╝██║░░██║███████╗██║░░██║╚█████╔╝░░░██║░░░██║╚█████╔╝  ██████╔╝██║░░██║██║██████╦╝██║░░██║
11 //  ░╚═════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░╚═╝░╚════╝░  ╚═════╝░╚═╝░░╚═╝╚═╝╚═════╝░╚═╝░░╚═╝
12 //
13 //
14 // Website: https://www.galacticshiba.com/
15 // Twitter: https://twitter.com/GalacticShiba
16 // Telegram: https://t.me/GalacticShibaToken
17 // Be sure to go through our whitepaper on the website!
18 */
19 
20 // SPDX-License-Identifier: Unlicensed
21 
22 pragma solidity ^0.6.12;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 library SafeMath {
107     /**
108      * @dev Returns the addition of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `+` operator.
112      *
113      * Requirements:
114      *
115      * - Addition cannot overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return sub(a, b, "SafeMath: subtraction overflow");
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `*` operator.
160      *
161      * Requirements:
162      *
163      * - Multiplication cannot overflow.
164      */
165     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
167         // benefit is lost if 'b' is also tested.
168         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
169         if (a == 0) {
170             return 0;
171         }
172 
173         uint256 c = a * b;
174         require(c / a == b, "SafeMath: multiplication overflow");
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
208         require(b > 0, errorMessage);
209         uint256 c = a / b;
210         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
228         return mod(a, b, "SafeMath: modulo by zero");
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts with custom message when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b != 0, errorMessage);
245         return a % b;
246     }
247 }
248 
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
269         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
270         // for accounts without code, i.e. `keccak256('')`
271         bytes32 codehash;
272         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { codehash := extcodehash(account) }
275         return (codehash != accountHash && codehash != 0x0);
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{ value: amount }("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321       return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331         return _functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         return _functionCallWithValue(target, data, value, errorMessage);
358     }
359 
360     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
361         require(isContract(target), "Address: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371 
372                 // solhint-disable-next-line no-inline-assembly
373                 assembly {
374                     let returndata_size := mload(returndata)
375                     revert(add(32, returndata), returndata_size)
376                 }
377             } else {
378                 revert(errorMessage);
379             }
380         }
381     }
382 }
383 
384 contract Ownable is Context {
385     address private _owner;
386 
387     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
388 
389     /**
390      * @dev Initializes the contract setting the deployer as the initial owner.
391      */
392     constructor () internal {
393         address msgSender = _msgSender();
394         _owner = msgSender;
395         emit OwnershipTransferred(address(0), msgSender);
396     }
397 
398     /**
399      * @dev Returns the address of the current owner.
400      */
401     function owner() public view returns (address) {
402         return _owner;
403     }
404 
405     /**
406      * @dev Throws if called by any account other than the owner.
407      */
408     modifier onlyOwner() {
409         require(_owner == _msgSender(), "Ownable: caller is not the owner");
410         _;
411     }
412 
413     /**
414      * @dev Leaves the contract without owner. It will not be possible to call
415      * `onlyOwner` functions anymore. Can only be called by the current owner.
416      *
417      * NOTE: Renouncing ownership will leave the contract without an owner,
418      * thereby removing any functionality that is only available to the owner.
419      */
420     function renounceOwnership() public virtual onlyOwner {
421         emit OwnershipTransferred(_owner, address(0));
422         _owner = address(0);
423     }
424 
425     /**
426      * @dev Transfers ownership of the contract to a new account (`newOwner`).
427      * Can only be called by the current owner.
428      */
429     function transferOwnership(address newOwner) public virtual onlyOwner {
430         require(newOwner != address(0), "Ownable: new owner is the zero address");
431         emit OwnershipTransferred(_owner, newOwner);
432         _owner = newOwner;
433     }
434 }
435 
436 
437 
438 contract GSHIBA is Context, IERC20, Ownable {
439     using SafeMath for uint256;
440     using Address for address;
441 
442     mapping (address => uint256) private _rOwned;
443     mapping (address => uint256) private _tOwned;
444     mapping (address => mapping (address => uint256)) private _allowances;
445 
446     mapping (address => bool) private _isExcluded;
447     address[] private _excluded;
448    
449     uint256 private constant MAX = ~uint256(0);
450     uint256 private constant _tTotal = 1000000000 * 10**6 * 10**9;
451     uint256 private _rTotal = (MAX - (MAX % _tTotal));
452     uint256 private _tFeeTotal;
453 
454     string private _name = 'Galactic Shiba (GalacticShiba.com) ';
455     string private _symbol = '$GSHIBA';
456     uint8 private _decimals = 9;
457     
458     uint256 public _maxTxAmount = 10000000 * 10**6 * 10**9;
459 
460     constructor () public {
461         _rOwned[_msgSender()] = _rTotal;
462         emit Transfer(address(0), _msgSender(), _tTotal);
463     }
464 
465     function name() public view returns (string memory) {
466         return _name;
467     }
468 
469     function symbol() public view returns (string memory) {
470         return _symbol;
471     }
472 
473     function decimals() public view returns (uint8) {
474         return _decimals;
475     }
476 
477     function totalSupply() public view override returns (uint256) {
478         return _tTotal;
479     }
480 
481     function balanceOf(address account) public view override returns (uint256) {
482         if (_isExcluded[account]) return _tOwned[account];
483         return tokenFromReflection(_rOwned[account]);
484     }
485 
486     function transfer(address recipient, uint256 amount) public override returns (bool) {
487         _transfer(_msgSender(), recipient, amount);
488         return true;
489     }
490 
491     function allowance(address owner, address spender) public view override returns (uint256) {
492         return _allowances[owner][spender];
493     }
494 
495     function approve(address spender, uint256 amount) public override returns (bool) {
496         _approve(_msgSender(), spender, amount);
497         return true;
498     }
499 
500     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
501         _transfer(sender, recipient, amount);
502         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
503         return true;
504     }
505 
506     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
507         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
508         return true;
509     }
510 
511     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
512         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
513         return true;
514     }
515 
516     function isExcluded(address account) public view returns (bool) {
517         return _isExcluded[account];
518     }
519 
520     function totalFees() public view returns (uint256) {
521         return _tFeeTotal;
522     }
523     
524     
525     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
526         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
527             10**2
528         );
529     }
530 
531     function reflect(uint256 tAmount) public {
532         address sender = _msgSender();
533         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
534         (uint256 rAmount,,,,) = _getValues(tAmount);
535         _rOwned[sender] = _rOwned[sender].sub(rAmount);
536         _rTotal = _rTotal.sub(rAmount);
537         _tFeeTotal = _tFeeTotal.add(tAmount);
538     }
539 
540     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
541         require(tAmount <= _tTotal, "Amount must be less than supply");
542         if (!deductTransferFee) {
543             (uint256 rAmount,,,,) = _getValues(tAmount);
544             return rAmount;
545         } else {
546             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
547             return rTransferAmount;
548         }
549     }
550 
551     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
552         require(rAmount <= _rTotal, "Amount must be less than total reflections");
553         uint256 currentRate =  _getRate();
554         return rAmount.div(currentRate);
555     }
556 
557     function excludeAccount(address account) external onlyOwner() {
558         require(!_isExcluded[account], "Account is already excluded");
559         if(_rOwned[account] > 0) {
560             _tOwned[account] = tokenFromReflection(_rOwned[account]);
561         }
562         _isExcluded[account] = true;
563         _excluded.push(account);
564     }
565 
566     function includeAccount(address account) external onlyOwner() {
567         require(_isExcluded[account], "Account is already excluded");
568         for (uint256 i = 0; i < _excluded.length; i++) {
569             if (_excluded[i] == account) {
570                 _excluded[i] = _excluded[_excluded.length - 1];
571                 _tOwned[account] = 0;
572                 _isExcluded[account] = false;
573                 _excluded.pop();
574                 break;
575             }
576         }
577     }
578 
579     function _approve(address owner, address spender, uint256 amount) private {
580         require(owner != address(0), "ERC20: approve from the zero address");
581         require(spender != address(0), "ERC20: approve to the zero address");
582 
583         _allowances[owner][spender] = amount;
584         emit Approval(owner, spender, amount);
585     }
586 
587     function _transfer(address sender, address recipient, uint256 amount) private {
588         require(sender != address(0), "ERC20: transfer from the zero address");
589         require(recipient != address(0), "ERC20: transfer to the zero address");
590         require(amount > 0, "Transfer amount must be greater than zero");
591         if(sender != owner() && recipient != owner())
592           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
593             
594         if (_isExcluded[sender] && !_isExcluded[recipient]) {
595             _transferFromExcluded(sender, recipient, amount);
596         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
597             _transferToExcluded(sender, recipient, amount);
598         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
599             _transferStandard(sender, recipient, amount);
600         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
601             _transferBothExcluded(sender, recipient, amount);
602         } else {
603             _transferStandard(sender, recipient, amount);
604         }
605     }
606 
607     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
608         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
609         _rOwned[sender] = _rOwned[sender].sub(rAmount);
610         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
611         _reflectFee(rFee, tFee);
612         emit Transfer(sender, recipient, tTransferAmount);
613     }
614 
615     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
616         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
617         _rOwned[sender] = _rOwned[sender].sub(rAmount);
618         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
619         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
620         _reflectFee(rFee, tFee);
621         emit Transfer(sender, recipient, tTransferAmount);
622     }
623 
624     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
625         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
626         _tOwned[sender] = _tOwned[sender].sub(tAmount);
627         _rOwned[sender] = _rOwned[sender].sub(rAmount);
628         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
629         _reflectFee(rFee, tFee);
630         emit Transfer(sender, recipient, tTransferAmount);
631     }
632 
633     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
634         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
635         _tOwned[sender] = _tOwned[sender].sub(tAmount);
636         _rOwned[sender] = _rOwned[sender].sub(rAmount);
637         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
638         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
639         _reflectFee(rFee, tFee);
640         emit Transfer(sender, recipient, tTransferAmount);
641     }
642 
643     function _reflectFee(uint256 rFee, uint256 tFee) private {
644         _rTotal = _rTotal.sub(rFee);
645         _tFeeTotal = _tFeeTotal.add(tFee);
646     }
647 
648     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
649         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
650         uint256 currentRate =  _getRate();
651         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
652         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
653     }
654 
655     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
656         uint256 tFee = tAmount.div(100).mul(2);
657         uint256 tTransferAmount = tAmount.sub(tFee);
658         return (tTransferAmount, tFee);
659     }
660 
661     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
662         uint256 rAmount = tAmount.mul(currentRate);
663         uint256 rFee = tFee.mul(currentRate);
664         uint256 rTransferAmount = rAmount.sub(rFee);
665         return (rAmount, rTransferAmount, rFee);
666     }
667 
668     function _getRate() private view returns(uint256) {
669         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
670         return rSupply.div(tSupply);
671     }
672 
673     function _getCurrentSupply() private view returns(uint256, uint256) {
674         uint256 rSupply = _rTotal;
675         uint256 tSupply = _tTotal;      
676         for (uint256 i = 0; i < _excluded.length; i++) {
677             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
678             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
679             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
680         }
681         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
682         return (rSupply, tSupply);
683     }
684 }