1 /**
2 //
3 //  This shiba is on the way to infinity & beyond!
4 //
5 //  $ASHIBA is fully decentralized, peer-to-peer digital currency that is owned in whole by its' own community!
6 //	
7 // 
8 //  ░█████╗░░██████╗████████╗██████╗░░█████╗░███╗░░██╗░█████╗░██╗░░░██╗████████╗  ░██████╗██╗░░██╗██╗██████╗░░█████╗░
9 //  ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗████╗░██║██╔══██╗██║░░░██║╚══██╔══╝  ██╔════╝██║░░██║██║██╔══██╗██╔══██╗
10 //  ███████║╚█████╗░░░░██║░░░██████╔╝██║░░██║██╔██╗██║███████║██║░░░██║░░░██║░░░  ╚█████╗░███████║██║██████╦╝███████║
11 //  ██╔══██║░╚═══██╗░░░██║░░░██╔══██╗██║░░██║██║╚████║██╔══██║██║░░░██║░░░██║░░░  ░╚═══██╗██╔══██║██║██╔══██╗██╔══██║
12 //  ██║░░██║██████╔╝░░░██║░░░██║░░██║╚█████╔╝██║░╚███║██║░░██║╚██████╔╝░░░██║░░░  ██████╔╝██║░░██║██║██████╦╝██║░░██║
13 //  ╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝░╚════╝░╚═╝░░╚══╝╚═╝░░╚═╝░╚═════╝░░░░╚═╝░░░  ╚═════╝░╚═╝░░╚═╝╚═╝╚═════╝░╚═╝░░╚═╝
14 //
15 //
16 //
17 // Website:  https://www.astronautshiba.com
18 // Twitter:  https://twitter.com/AstronautShiba	
19 // Telegram: https://t.me/AstronautShiba
20 // Be sure to go through our whitepaper on the website!
21 */
22 
23 // SPDX-License-Identifier: Unlicensed
24 
25 pragma solidity ^0.6.12;
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address payable) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes memory) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 library SafeMath {
110     /**
111      * @dev Returns the addition of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `+` operator.
115      *
116      * Requirements:
117      *
118      * - Addition cannot overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, "SafeMath: addition overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         return sub(a, b, "SafeMath: subtraction overflow");
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b <= a, errorMessage);
153         uint256 c = a - b;
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the multiplication of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `*` operator.
163      *
164      * Requirements:
165      *
166      * - Multiplication cannot overflow.
167      */
168     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
170         // benefit is lost if 'b' is also tested.
171         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
172         if (a == 0) {
173             return 0;
174         }
175 
176         uint256 c = a * b;
177         require(c / a == b, "SafeMath: multiplication overflow");
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b) internal pure returns (uint256) {
195         return div(a, b, "SafeMath: division by zero");
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b > 0, errorMessage);
212         uint256 c = a / b;
213         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
214 
215         return c;
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         return mod(a, b, "SafeMath: modulo by zero");
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts with custom message when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b != 0, errorMessage);
248         return a % b;
249     }
250 }
251 
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
272         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
273         // for accounts without code, i.e. `keccak256('')`
274         bytes32 codehash;
275         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { codehash := extcodehash(account) }
278         return (codehash != accountHash && codehash != 0x0);
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 contract Ownable is Context {
388     address private _owner;
389 
390     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
391 
392     /**
393      * @dev Initializes the contract setting the deployer as the initial owner.
394      */
395     constructor () internal {
396         address msgSender = _msgSender();
397         _owner = msgSender;
398         emit OwnershipTransferred(address(0), msgSender);
399     }
400 
401     /**
402      * @dev Returns the address of the current owner.
403      */
404     function owner() public view returns (address) {
405         return _owner;
406     }
407 
408     /**
409      * @dev Throws if called by any account other than the owner.
410      */
411     modifier onlyOwner() {
412         require(_owner == _msgSender(), "Ownable: caller is not the owner");
413         _;
414     }
415 
416     /**
417      * @dev Leaves the contract without owner. It will not be possible to call
418      * `onlyOwner` functions anymore. Can only be called by the current owner.
419      *
420      * NOTE: Renouncing ownership will leave the contract without an owner,
421      * thereby removing any functionality that is only available to the owner.
422      */
423     function renounceOwnership() public virtual onlyOwner {
424         emit OwnershipTransferred(_owner, address(0));
425         _owner = address(0);
426     }
427 
428     /**
429      * @dev Transfers ownership of the contract to a new account (`newOwner`).
430      * Can only be called by the current owner.
431      */
432     function transferOwnership(address newOwner) public virtual onlyOwner {
433         require(newOwner != address(0), "Ownable: new owner is the zero address");
434         emit OwnershipTransferred(_owner, newOwner);
435         _owner = newOwner;
436     }
437 }
438 
439 
440 
441 contract ASHIBA is Context, IERC20, Ownable {
442     using SafeMath for uint256;
443     using Address for address;
444 
445     mapping (address => uint256) private _rOwned;
446     mapping (address => uint256) private _tOwned;
447     mapping (address => mapping (address => uint256)) private _allowances;
448 
449     mapping (address => bool) private _isExcluded;
450     address[] private _excluded;
451    
452     uint256 private constant MAX = ~uint256(0);
453     uint256 private constant _tTotal = 1000000000 * 10**6 * 10**9;
454     uint256 private _rTotal = (MAX - (MAX % _tTotal));
455     uint256 private _tFeeTotal;
456 
457     string private _name = 'Astronaut Shiba (astronautshiba.com) ';
458     string private _symbol = '$ASHIBA';
459     uint8 private _decimals = 9;
460     
461     uint256 public _maxTxAmount = 10000000 * 10**6 * 10**9;
462 
463     constructor () public {
464         _rOwned[_msgSender()] = _rTotal;
465         emit Transfer(address(0), _msgSender(), _tTotal);
466     }
467 
468     function name() public view returns (string memory) {
469         return _name;
470     }
471 
472     function symbol() public view returns (string memory) {
473         return _symbol;
474     }
475 
476     function decimals() public view returns (uint8) {
477         return _decimals;
478     }
479 
480     function totalSupply() public view override returns (uint256) {
481         return _tTotal;
482     }
483 
484     function balanceOf(address account) public view override returns (uint256) {
485         if (_isExcluded[account]) return _tOwned[account];
486         return tokenFromReflection(_rOwned[account]);
487     }
488 
489     function transfer(address recipient, uint256 amount) public override returns (bool) {
490         _transfer(_msgSender(), recipient, amount);
491         return true;
492     }
493 
494     function allowance(address owner, address spender) public view override returns (uint256) {
495         return _allowances[owner][spender];
496     }
497 
498     function approve(address spender, uint256 amount) public override returns (bool) {
499         _approve(_msgSender(), spender, amount);
500         return true;
501     }
502 
503     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
504         _transfer(sender, recipient, amount);
505         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
506         return true;
507     }
508 
509     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
510         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
511         return true;
512     }
513 
514     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
515         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
516         return true;
517     }
518 
519     function isExcluded(address account) public view returns (bool) {
520         return _isExcluded[account];
521     }
522 
523     function totalFees() public view returns (uint256) {
524         return _tFeeTotal;
525     }
526     
527     
528     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
529         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
530             10**2
531         );
532     }
533 
534     function reflect(uint256 tAmount) public {
535         address sender = _msgSender();
536         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
537         (uint256 rAmount,,,,) = _getValues(tAmount);
538         _rOwned[sender] = _rOwned[sender].sub(rAmount);
539         _rTotal = _rTotal.sub(rAmount);
540         _tFeeTotal = _tFeeTotal.add(tAmount);
541     }
542 
543     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
544         require(tAmount <= _tTotal, "Amount must be less than supply");
545         if (!deductTransferFee) {
546             (uint256 rAmount,,,,) = _getValues(tAmount);
547             return rAmount;
548         } else {
549             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
550             return rTransferAmount;
551         }
552     }
553 
554     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
555         require(rAmount <= _rTotal, "Amount must be less than total reflections");
556         uint256 currentRate =  _getRate();
557         return rAmount.div(currentRate);
558     }
559 
560     function excludeAccount(address account) external onlyOwner() {
561         require(!_isExcluded[account], "Account is already excluded");
562         if(_rOwned[account] > 0) {
563             _tOwned[account] = tokenFromReflection(_rOwned[account]);
564         }
565         _isExcluded[account] = true;
566         _excluded.push(account);
567     }
568 
569     function includeAccount(address account) external onlyOwner() {
570         require(_isExcluded[account], "Account is already excluded");
571         for (uint256 i = 0; i < _excluded.length; i++) {
572             if (_excluded[i] == account) {
573                 _excluded[i] = _excluded[_excluded.length - 1];
574                 _tOwned[account] = 0;
575                 _isExcluded[account] = false;
576                 _excluded.pop();
577                 break;
578             }
579         }
580     }
581 
582     function _approve(address owner, address spender, uint256 amount) private {
583         require(owner != address(0), "ERC20: approve from the zero address");
584         require(spender != address(0), "ERC20: approve to the zero address");
585 
586         _allowances[owner][spender] = amount;
587         emit Approval(owner, spender, amount);
588     }
589 
590     function _transfer(address sender, address recipient, uint256 amount) private {
591         require(sender != address(0), "ERC20: transfer from the zero address");
592         require(recipient != address(0), "ERC20: transfer to the zero address");
593         require(amount > 0, "Transfer amount must be greater than zero");
594         if(sender != owner() && recipient != owner())
595           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
596             
597         if (_isExcluded[sender] && !_isExcluded[recipient]) {
598             _transferFromExcluded(sender, recipient, amount);
599         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
600             _transferToExcluded(sender, recipient, amount);
601         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
602             _transferStandard(sender, recipient, amount);
603         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
604             _transferBothExcluded(sender, recipient, amount);
605         } else {
606             _transferStandard(sender, recipient, amount);
607         }
608     }
609 
610     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
611         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
612         _rOwned[sender] = _rOwned[sender].sub(rAmount);
613         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
614         _reflectFee(rFee, tFee);
615         emit Transfer(sender, recipient, tTransferAmount);
616     }
617 
618     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
619         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
620         _rOwned[sender] = _rOwned[sender].sub(rAmount);
621         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
622         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
623         _reflectFee(rFee, tFee);
624         emit Transfer(sender, recipient, tTransferAmount);
625     }
626 
627     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
628         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
629         _tOwned[sender] = _tOwned[sender].sub(tAmount);
630         _rOwned[sender] = _rOwned[sender].sub(rAmount);
631         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
632         _reflectFee(rFee, tFee);
633         emit Transfer(sender, recipient, tTransferAmount);
634     }
635 
636     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
637         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
638         _tOwned[sender] = _tOwned[sender].sub(tAmount);
639         _rOwned[sender] = _rOwned[sender].sub(rAmount);
640         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
641         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
642         _reflectFee(rFee, tFee);
643         emit Transfer(sender, recipient, tTransferAmount);
644     }
645 
646     function _reflectFee(uint256 rFee, uint256 tFee) private {
647         _rTotal = _rTotal.sub(rFee);
648         _tFeeTotal = _tFeeTotal.add(tFee);
649     }
650 
651     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
652         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
653         uint256 currentRate =  _getRate();
654         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
655         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
656     }
657 
658     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
659         uint256 tFee = tAmount.div(100).mul(2);
660         uint256 tTransferAmount = tAmount.sub(tFee);
661         return (tTransferAmount, tFee);
662     }
663 
664     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
665         uint256 rAmount = tAmount.mul(currentRate);
666         uint256 rFee = tFee.mul(currentRate);
667         uint256 rTransferAmount = rAmount.sub(rFee);
668         return (rAmount, rTransferAmount, rFee);
669     }
670 
671     function _getRate() private view returns(uint256) {
672         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
673         return rSupply.div(tSupply);
674     }
675 
676     function _getCurrentSupply() private view returns(uint256, uint256) {
677         uint256 rSupply = _rTotal;
678         uint256 tSupply = _tTotal;      
679         for (uint256 i = 0; i < _excluded.length; i++) {
680             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
681             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
682             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
683         }
684         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
685         return (rSupply, tSupply);
686     }
687 }