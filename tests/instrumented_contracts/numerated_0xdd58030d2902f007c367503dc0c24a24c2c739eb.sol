1 /**
2 *
3 _________       ______             ________              
4 __  ____/____  ____  /_________________  _/__________  __
5 _  /    __  / / /_  __ \  _ \_  ___/__  / __  __ \  / / /
6 / /___  _  /_/ /_  /_/ /  __/  /   __/ /  _  / / / /_/ / 
7 \____/  _\__, / /_.___/\___//_/    /___/  /_/ /_/\__,_/  
8         /____/                                           
9 *
10 * 
11 CYBER INU ($CYBINU) COMMUNITY TOKEN
12 *
13 LP tokens will be burned, ownnership wil be renounced
14 Frictionless Rewards in a 100% transparent way!
15 6% Tax (3% Burn // 3% back to Holders)
16 Initial liquidty burned: 50% of Total Supply
17 10% of Total Liquidity for DEV / Marketing
18 *
19 Website: www.cyberinu.finance
20 Telegram: https://t.me/cyberinutoken
21 *
22 *
23 *
24 SPDX-License-Identifier: Unlicensed
25 *
26 */
27 
28 pragma solidity ^0.7.6;
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address payable) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes memory) {
36         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
37         return msg.data;
38     }
39 }
40 
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 library SafeMath {
113     /**
114      * @dev Returns the addition of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `+` operator.
118      *
119      * Requirements:
120      *
121      * - Addition cannot overflow.
122      */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return sub(a, b, "SafeMath: subtraction overflow");
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b <= a, errorMessage);
156         uint256 c = a - b;
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the multiplication of two unsigned integers, reverting on
163      * overflow.
164      *
165      * Counterpart to Solidity's `*` operator.
166      *
167      * Requirements:
168      *
169      * - Multiplication cannot overflow.
170      */
171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173         // benefit is lost if 'b' is also tested.
174         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175         if (a == 0) {
176             return 0;
177         }
178 
179         uint256 c = a * b;
180         require(c / a == b, "SafeMath: multiplication overflow");
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         return div(a, b, "SafeMath: division by zero");
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         require(b > 0, errorMessage);
215         uint256 c = a / b;
216         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         return mod(a, b, "SafeMath: modulo by zero");
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts with custom message when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
275         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
276         // for accounts without code, i.e. `keccak256('')`
277         bytes32 codehash;
278         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { codehash := extcodehash(account) }
281         return (codehash != accountHash && codehash != 0x0);
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304         (bool success, ) = recipient.call{ value: amount }("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain`call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327       return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337         return _functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         return _functionCallWithValue(target, data, value, errorMessage);
364     }
365 
366     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
367         require(isContract(target), "Address: call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 // solhint-disable-next-line no-inline-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 contract Ownable is Context {
391     address private _owner;
392 
393     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
394 
395     /**
396      * @dev Initializes the contract setting the deployer as the initial owner.
397      */
398     constructor () {
399         address msgSender = _msgSender();
400         _owner = msgSender;
401         emit OwnershipTransferred(address(0), msgSender);
402     }
403 
404     /**
405      * @dev Returns the address of the current owner.
406      */
407     function owner() public view returns (address) {
408         return _owner;
409     }
410 
411     /**
412      * @dev Throws if called by any account other than the owner.
413      */
414     modifier onlyOwner() {
415         require(_owner == _msgSender(), "Ownable: caller is not the owner");
416         _;
417     }
418 
419     /**
420      * @dev Leaves the contract without owner. It will not be possible to call
421      * `onlyOwner` functions anymore. Can only be called by the current owner.
422      *
423      * NOTE: Renouncing ownership will leave the contract without an owner,
424      * thereby removing any functionality that is only available to the owner.
425      */
426     function renounceOwnership() public virtual onlyOwner {
427         emit OwnershipTransferred(_owner, address(0));
428         _owner = address(0);
429     }
430 
431     /**
432      * @dev Transfers ownership of the contract to a new account (`newOwner`).
433      * Can only be called by the current owner.
434      */
435     function transferOwnership(address newOwner) public virtual onlyOwner {
436         require(newOwner != address(0), "Ownable: new owner is the zero address");
437         emit OwnershipTransferred(_owner, newOwner);
438         _owner = newOwner;
439     }
440 }
441 
442 
443 
444 contract CYBERINU is Context, IERC20, Ownable {
445     using SafeMath for uint256;
446     using Address for address;
447 
448     mapping (address => uint256) private _rOwned;
449     mapping (address => uint256) private _tOwned;
450     mapping (address => mapping (address => uint256)) private _allowances;
451 
452     mapping (address => bool) private _isExcluded;
453     address[] private _excluded;
454    
455     uint256 private constant MAX = ~uint256(0);
456     uint256 private constant _tTotal = 1000000000 * 10**6 * 10**9;
457     uint256 private _rTotal = (MAX - (MAX % _tTotal));
458     uint256 private _tFeeTotal;
459     string private _name = 'Cyber Inu';
460     string private _symbol = 'CYBINU';
461     uint8 private _decimals = 9;
462     uint256 public allowTradeAt;
463     
464     constructor () {
465         _rOwned[_msgSender()] = _rTotal;
466         emit Transfer(address(0), _msgSender(), _tTotal);
467     }
468 
469     function name() public view returns (string memory) {
470         return _name;
471     }
472 
473     function symbol() public view returns (string memory) {
474         return _symbol;
475     }
476 
477     function decimals() public view returns (uint8) {
478         return _decimals;
479     }
480 
481     function totalSupply() public pure override returns (uint256) {
482         return _tTotal;
483     }
484 
485     function balanceOf(address account) public view override returns (uint256) {
486         if (_isExcluded[account]) return _tOwned[account];
487         return tokenFromReflection(_rOwned[account]);
488     }
489 
490     function transfer(address recipient, uint256 amount) public override returns (bool) {
491         _transfer(_msgSender(), recipient, amount);
492         return true;
493     }
494 
495     function allowance(address owner, address spender) public view override returns (uint256) {
496         return _allowances[owner][spender];
497     }
498 
499     function approve(address spender, uint256 amount) public override returns (bool) {
500         _approve(_msgSender(), spender, amount);
501         return true;
502     }
503 
504     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
505         _transfer(sender, recipient, amount);
506         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
507         return true;
508     }
509 
510     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
512         return true;
513     }
514 
515     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
516         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
517         return true;
518     }
519 
520     function isExcluded(address account) public view returns (bool) {
521         return _isExcluded[account];
522     }
523 
524     function totalFees() public view returns (uint256) {
525         return _tFeeTotal;
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
584     function enableFairLaunch() external onlyOwner() {
585         require(msg.sender != address(0), "ERC20: approve from the zero address");
586         allowTradeAt = block.timestamp;
587     }
588 
589     function _transfer(address sender, address recipient, uint256 amount) private {
590         require(sender != address(0), "ERC20: transfer from the zero address");
591         require(recipient != address(0), "ERC20: transfer to the zero address");
592         require(amount > 0, "Transfer amount must be greater than zero");
593         if (block.timestamp < allowTradeAt + 24 hours && amount >= 10**6 * 10**9 ) {
594              revert("You cannot transfer more than 1 billion now");  }
595         if (_isExcluded[sender] && !_isExcluded[recipient]) {
596             _transferFromExcluded(sender, recipient, amount);
597         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
598             _transferToExcluded(sender, recipient, amount);
599         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
600             _transferStandard(sender, recipient, amount);
601         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
602             _transferBothExcluded(sender, recipient, amount);
603         } else {
604             _transferStandard(sender, recipient, amount);
605         }
606     }
607 
608     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
609         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
610         _rOwned[sender] = _rOwned[sender].sub(rAmount);
611         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
612         _reflectFee(rFee, tFee);
613         emit Transfer(sender, recipient, tTransferAmount);
614     }
615 
616     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
617         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
618         _rOwned[sender] = _rOwned[sender].sub(rAmount);
619         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
620         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
621         _reflectFee(rFee, tFee);
622         emit Transfer(sender, recipient, tTransferAmount);
623     }
624 
625     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
626         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
627         _tOwned[sender] = _tOwned[sender].sub(tAmount);
628         _rOwned[sender] = _rOwned[sender].sub(rAmount);
629         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
630         _reflectFee(rFee, tFee);
631         emit Transfer(sender, recipient, tTransferAmount);
632     }
633 
634     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
635         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
636         _tOwned[sender] = _tOwned[sender].sub(tAmount);
637         _rOwned[sender] = _rOwned[sender].sub(rAmount);
638         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
639         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
640         _reflectFee(rFee, tFee);
641         emit Transfer(sender, recipient, tTransferAmount);
642     }
643 
644     function _reflectFee(uint256 rFee, uint256 tFee) private {
645         _rTotal = _rTotal.sub(rFee);
646         _tFeeTotal = _tFeeTotal.add(tFee);
647     }
648 
649     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
650         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
651         uint256 currentRate =  _getRate();
652         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
653         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
654     }
655 
656     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
657         uint256 tFee = tAmount.div(100).mul(6);
658         uint256 tTransferAmount = tAmount.sub(tFee);
659         return (tTransferAmount, tFee);
660     }
661 
662     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
663         uint256 rAmount = tAmount.mul(currentRate);
664         uint256 rFee = tFee.mul(currentRate);
665         uint256 rTransferAmount = rAmount.sub(rFee);
666         return (rAmount, rTransferAmount, rFee);
667     }
668 
669     function _getRate() private view returns(uint256) {
670         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
671         return rSupply.div(tSupply);
672     }
673 
674     function _getCurrentSupply() private view returns(uint256, uint256) {
675         uint256 rSupply = _rTotal;
676         uint256 tSupply = _tTotal;      
677         for (uint256 i = 0; i < _excluded.length; i++) {
678             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
679             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
680             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
681         }
682         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
683         return (rSupply, tSupply);
684     }
685 }