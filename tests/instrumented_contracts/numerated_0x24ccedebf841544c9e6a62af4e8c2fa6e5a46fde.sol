1 // SPDX-License-Identifier: Unlicensed
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
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 library SafeMath {
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b <= a, errorMessage);
131         uint256 c = a - b;
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the multiplication of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `*` operator.
141      *
142      * Requirements:
143      *
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      *
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b > 0, errorMessage);
190         uint256 c = a / b;
191         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * Reverts when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return mod(a, b, "SafeMath: modulo by zero");
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts with custom message when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 library Address {
231     /**
232      * @dev Returns true if `account` is a contract.
233      *
234      * [IMPORTANT]
235      * ====
236      * It is unsafe to assume that an address for which this function returns
237      * false is an externally-owned account (EOA) and not a contract.
238      *
239      * Among others, `isContract` will return false for the following
240      * types of addresses:
241      *
242      *  - an externally-owned account
243      *  - a contract in construction
244      *  - an address where a contract will be created
245      *  - an address where a contract lived, but was destroyed
246      * ====
247      */
248     function isContract(address account) internal view returns (bool) {
249         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
250         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
251         // for accounts without code, i.e. `keccak256('')`
252         bytes32 codehash;
253         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
254         // solhint-disable-next-line no-inline-assembly
255         assembly { codehash := extcodehash(account) }
256         return (codehash != accountHash && codehash != 0x0);
257     }
258 
259     /**
260      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
261      * `recipient`, forwarding all available gas and reverting on errors.
262      *
263      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
264      * of certain opcodes, possibly making contracts go over the 2300 gas limit
265      * imposed by `transfer`, making them unable to receive funds via
266      * `transfer`. {sendValue} removes this limitation.
267      *
268      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
269      *
270      * IMPORTANT: because control is transferred to `recipient`, care must be
271      * taken to not create reentrancy vulnerabilities. Consider using
272      * {ReentrancyGuard} or the
273      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
274      */
275     function sendValue(address payable recipient, uint256 amount) internal {
276         require(address(this).balance >= amount, "Address: insufficient balance");
277 
278         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
279         (bool success, ) = recipient.call{ value: amount }("");
280         require(success, "Address: unable to send value, recipient may have reverted");
281     }
282 
283     /**
284      * @dev Performs a Solidity function call using a low level `call`. A
285      * plain`call` is an unsafe replacement for a function call: use this
286      * function instead.
287      *
288      * If `target` reverts with a revert reason, it is bubbled up by this
289      * function (like regular Solidity function calls).
290      *
291      * Returns the raw returned data. To convert to the expected return value,
292      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
293      *
294      * Requirements:
295      *
296      * - `target` must be a contract.
297      * - calling `target` with `data` must not revert.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
302       return functionCall(target, data, "Address: low-level call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
307      * `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
312         return _functionCallWithValue(target, data, 0, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but also transferring `value` wei to `target`.
318      *
319      * Requirements:
320      *
321      * - the calling contract must have an ETH balance of at least `value`.
322      * - the called Solidity function must be `payable`.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
332      * with `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
337         require(address(this).balance >= value, "Address: insufficient balance for call");
338         return _functionCallWithValue(target, data, value, errorMessage);
339     }
340 
341     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
342         require(isContract(target), "Address: call to non-contract");
343 
344         // solhint-disable-next-line avoid-low-level-calls
345         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
346         if (success) {
347             return returndata;
348         } else {
349             // Look for revert reason and bubble it up if present
350             if (returndata.length > 0) {
351                 // The easiest way to bubble the revert reason is using memory via assembly
352 
353                 // solhint-disable-next-line no-inline-assembly
354                 assembly {
355                     let returndata_size := mload(returndata)
356                     revert(add(32, returndata), returndata_size)
357                 }
358             } else {
359                 revert(errorMessage);
360             }
361         }
362     }
363 }
364 
365 contract Ownable is Context {
366     address private _owner;
367 
368     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
369 
370     /**
371      * @dev Initializes the contract setting the deployer as the initial owner.
372      */
373     constructor () internal {
374         address msgSender = _msgSender();
375         _owner = msgSender;
376         emit OwnershipTransferred(address(0), msgSender);
377     }
378 
379     /**
380      * @dev Returns the address of the current owner.
381      */
382     function owner() public view returns (address) {
383         return _owner;
384     }
385 
386     /**
387      * @dev Throws if called by any account other than the owner.
388      */
389 
390     modifier onlyOwner() {
391         require(_owner == _msgSender(), "Ownable: caller is not the owner");
392         _;
393     }
394 
395 
396     /**
397      * @dev Leaves the contract without owner. It will not be possible to call
398      * `onlyOwner` functions anymore. Can only be called by the current owner.
399      *
400      * NOTE: Renouncing ownership will leave the contract without an owner,
401      * thereby removing any functionality that is only available to the owner.
402      */
403     function renounceOwnership() public virtual onlyOwner {
404         emit OwnershipTransferred(_owner, address(0));
405         _owner = address(0);
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Can only be called by the current owner.
411      */
412     function transferOwnership(address newOwner) public virtual onlyOwner {
413         require(newOwner != address(0), "Ownable: new owner is the zero address");
414         emit OwnershipTransferred(_owner, newOwner);
415         _owner = newOwner;
416     }
417 }
418 
419 
420 
421 contract BlueSparrow is Context, IERC20, Ownable {
422     using SafeMath for uint256;
423     using Address for address;
424 
425     mapping (address => uint256) private _rOwned;
426     mapping (address => uint256) private _tOwned;
427     mapping (address => mapping (address => uint256)) private _allowances;
428 
429     mapping (address => bool) public _withdrawWl;      
430     mapping (address => bool) public _depositWl;
431    
432     uint256 private constant MAX = ~uint256(0);
433     uint256 private constant _tTotal = 100000000 * 10**9;
434     uint256 private _rTotal = (MAX - (MAX % _tTotal));
435     uint256 private _tFeeTotal;
436 
437     string private _name = 'BlueSparrowToken';
438     string private _symbol = 'BlueSparrow';
439     uint8 private _decimals = 9;
440 
441 
442 
443 
444     // Addresses
445 
446     address public MaChWallet;                          // Marketing and charity wallet Address
447     address public DrawWallet;                          // Draw wallet address
448 
449 
450 
451     struct data {
452         uint256 rAmount;
453         uint256 rTransferAmount;
454         uint256 rFee;
455 
456         uint256 tTransferAmount;
457         uint256 tFee;
458     }
459 
460     bool private _taxFree;
461     
462     
463 
464 
465 
466 
467 
468     constructor (address _MaChWallet ,address _DrawWallet) public {
469 
470 
471         MaChWallet            = _MaChWallet;
472         DrawWallet            = _DrawWallet ;
473 
474         _rOwned[_msgSender()] = _rTotal;
475         emit Transfer(address(0), _msgSender(), _tTotal);
476     }
477 
478     function addTaxFree () public onlyOwner {
479          _taxFree = true;
480     }
481 
482     function reTaxFree () public onlyOwner {
483         _taxFree = false;
484     }
485 
486 
487     // Add and Remove Withdraw whiteList Addresses 
488 
489     function addWWL (address _add) public onlyOwner {
490         _withdrawWl[_add] = true;
491     }
492 
493 
494     function reWWL (address _add) public onlyOwner {
495         _withdrawWl[_add] = false;
496     }
497 
498     // Add and Remove Deposit whiteList Addresses
499 
500     function addDWL (address _add) public onlyOwner {
501         _depositWl[_add] = true;
502     }
503 
504     function reDWL (address _add) public onlyOwner {
505         _depositWl[_add] = false;
506     }
507 
508   // Change Wallet Addresses
509 
510     function changeDrawWallet(address _add) public onlyOwner {
511         DrawWallet = _add;
512     }
513  
514     function changeMaChAdd(address _add) public onlyOwner {
515         MaChWallet = _add;
516     }
517 
518 
519     // ERC20 Functions
520 
521     function name() public view returns (string memory) {
522         return _name;
523     }
524 
525     function symbol() public view returns (string memory) {
526         return _symbol;
527     }
528 
529     function decimals() public view returns (uint8) {
530         return _decimals;
531     }
532 
533     function totalSupply() public view override returns (uint256) {
534         return _tTotal;
535     }
536 
537     function balanceOf(address account) public view override returns (uint256) {
538         return tokenFromReflection(_rOwned[account]);
539     }
540 
541     function transfer(address recipient, uint256 amount) public override returns (bool) {
542         _transfer(_msgSender(), recipient, amount);
543         return true;
544     }
545 
546     function allowance(address owner, address spender) public view override returns (uint256) {
547         return _allowances[owner][spender];
548     }
549 
550     function approve(address spender, uint256 amount) public override returns (bool) {
551         _approve(_msgSender(), spender, amount);
552         return true;
553     }
554 
555     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
556         _transfer(sender, recipient, amount);
557         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
558         return true;
559     }
560 
561     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
562         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
563         return true;
564     }
565 
566     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
567         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
568         return true;
569     }
570 
571     function totalFees() public view returns (uint256) {
572         return _tFeeTotal;
573     }
574     
575 
576 
577     function reflect(uint256 tAmount) public {
578         address sender = _msgSender();
579         data memory _data = _getValues(tAmount);
580         _rOwned[sender] = _rOwned[sender].sub(_data.rAmount);
581         _rTotal = _rTotal.sub(_data.rAmount);
582         _tFeeTotal = _tFeeTotal.add(tAmount);
583     }
584 
585 
586     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
587         require(rAmount <= _rTotal, "Amount must be less than total reflections");
588         uint256 currentRate =  _getRate();
589         return rAmount.div(currentRate);
590     }
591 
592   
593 
594     function _approve(address owner, address spender, uint256 amount) private {
595         require(owner != address(0), "ERC20: approve from the zero address");
596         require(spender != address(0), "ERC20: approve to the zero address");
597 
598         _allowances[owner][spender] = amount;
599         emit Approval(owner, spender, amount);
600     }
601 
602     function _transfer(address sender, address recipient, uint256 amount) private {
603         require(sender != address(0), "ERC20: transfer from the zero address");
604         require(recipient != address(0), "ERC20: transfer to the zero address");
605         require(amount > 0, "Transfer amount must be greater than zero");
606         if( _withdrawWl[sender] || _depositWl[recipient] || _taxFree) {
607          _transferWhiteList(sender, recipient, amount);
608         } else {   
609          _transferStandard(sender, recipient, amount);
610         }
611     }
612 
613 
614    
615 
616     // Standard Transfer
617 
618     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
619         data memory _data = _getValues(tAmount);
620        _rOwned[sender] = _rOwned[sender].sub(_data.rAmount);
621        _rOwned[recipient] = _rOwned[recipient].add(_data.rTransferAmount);  
622        _rOwned[DrawWallet] = _rOwned[DrawWallet].add(_data.rFee.div(5));            
623        _rOwned[MaChWallet] = _rOwned[MaChWallet].add(_data.rFee.mul(2).div(5));
624        _rTotal = _rTotal.sub(_data.rFee.mul(2).div(5)); 
625         emit Transfer(sender, recipient, _data.tTransferAmount);
626     }
627 
628     // WhiteList Transfer 
629 
630     function _transferWhiteList(address sender, address recipient, uint256 tAmount) private {
631         data memory _data = _getValues(tAmount);
632         _rOwned[sender] = _rOwned[sender].sub(_data.rAmount);
633         _rOwned[recipient]= _rOwned[recipient].add(_data.rAmount);
634 
635         emit Transfer(sender, recipient, tAmount);
636     }
637 
638    
639     // Return Values
640 
641     function _getValues(uint256 tAmount) private view returns (data memory){
642         data memory _data;
643 
644         uint256 _tFee;
645         uint256 _currentRate = _getRate();
646 
647         uint256 _rFee;
648         uint256 _rAmount;
649 
650 
651       _rAmount = tAmount.mul(_currentRate);
652       _tFee    = tAmount.div(100);
653       _rFee    = _tFee.mul(_currentRate);
654      
655 
656 
657       _data.rAmount = _rAmount;
658       _data.rTransferAmount = _rAmount.sub(_rFee);
659       _data.rFee = _rFee;
660 
661       _data.tTransferAmount = tAmount.sub(_tFee);
662       _data.tFee = _tFee;
663 
664       return _data;  
665     }
666 
667 
668     function _getRate() private view returns(uint256) {
669 
670         uint256 rSupply = _rTotal;
671         uint256 tSupply = _tTotal;
672         
673       return rSupply.div(tSupply);
674     }
675 
676     
677 }