1 // kong.finance (KONG)
2 // KONG, it’s DeFi for apes
3 // KONG is a deflationary farming meme powered currency
4 
5 /*
6 KKKKKKKKK    KKKKKKK     OOOOOOOOO     NNNNNNNN        NNNNNNNN        GGGGGGGGGGGGG
7 K:::::::K    K:::::K   OO:::::::::OO   N:::::::N       N::::::N     GGG::::::::::::G
8 K:::::::K    K:::::K OO:::::::::::::OO N::::::::N      N::::::N   GG:::::::::::::::G
9 K:::::::K   K::::::KO:::::::OOO:::::::ON:::::::::N     N::::::N  G:::::GGGGGGGG::::G
10 KK::::::K  K:::::KKKO::::::O   O::::::ON::::::::::N    N::::::N G:::::G       GGGGGG
11   K:::::K K:::::K   O:::::O     O:::::ON:::::::::::N   N::::::NG:::::G              
12   K::::::K:::::K    O:::::O     O:::::ON:::::::N::::N  N::::::NG:::::G              
13   K:::::::::::K     O:::::O     O:::::ON::::::N N::::N N::::::NG:::::G    GGGGGGGGGG
14   K:::::::::::K     O:::::O     O:::::ON::::::N  N::::N:::::::NG:::::G    G::::::::G
15   K::::::K:::::K    O:::::O     O:::::ON::::::N   N:::::::::::NG:::::G    GGGGG::::G
16   K:::::K K:::::K   O:::::O     O:::::ON::::::N    N::::::::::NG:::::G        G::::G
17 KK::::::K  K:::::KKKO::::::O   O::::::ON::::::N     N:::::::::N G:::::G       G::::G
18 K:::::::K   K::::::KO:::::::OOO:::::::ON::::::N      N::::::::N  G:::::GGGGGGGG::::G
19 K:::::::K    K:::::K OO:::::::::::::OO N::::::N       N:::::::N   GG:::::::::::::::G
20 K:::::::K    K:::::K   OO:::::::::OO   N::::::N        N::::::N     GGG::::::GGG:::G
21 KKKKKKKKK    KKKKKKK     OOOOOOOOO     NNNNNNNN         NNNNNNN        GGGGGG   GGGG
22 */
23 
24 
25 // SPDX-License-Identifier: Unlicensed
26 
27 pragma solidity ^0.6.12;
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address payable) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes memory) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 library SafeMath {
112     /**
113      * @dev Returns the addition of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `+` operator.
117      *
118      * Requirements:
119      *
120      * - Addition cannot overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a, "SafeMath: addition overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b <= a, errorMessage);
155         uint256 c = a - b;
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the multiplication of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `*` operator.
165      *
166      * Requirements:
167      *
168      * - Multiplication cannot overflow.
169      */
170     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
172         // benefit is lost if 'b' is also tested.
173         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
174         if (a == 0) {
175             return 0;
176         }
177 
178         uint256 c = a * b;
179         require(c / a == b, "SafeMath: multiplication overflow");
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
197         return div(a, b, "SafeMath: division by zero");
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         uint256 c = a / b;
215         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         return mod(a, b, "SafeMath: modulo by zero");
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts with custom message when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b != 0, errorMessage);
250         return a % b;
251     }
252 }
253 
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      */
272     function isContract(address account) internal view returns (bool) {
273         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
274         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
275         // for accounts without code, i.e. `keccak256('')`
276         bytes32 codehash;
277         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
278         // solhint-disable-next-line no-inline-assembly
279         assembly { codehash := extcodehash(account) }
280         return (codehash != accountHash && codehash != 0x0);
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
303         (bool success, ) = recipient.call{ value: amount }("");
304         require(success, "Address: unable to send value, recipient may have reverted");
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level `call`. A
309      * plain`call` is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If `target` reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
317      *
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326       return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
331      * `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
336         return _functionCallWithValue(target, data, 0, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but also transferring `value` wei to `target`.
342      *
343      * Requirements:
344      *
345      * - the calling contract must have an ETH balance of at least `value`.
346      * - the called Solidity function must be `payable`.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         return _functionCallWithValue(target, data, value, errorMessage);
363     }
364 
365     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
366         require(isContract(target), "Address: call to non-contract");
367 
368         // solhint-disable-next-line avoid-low-level-calls
369         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 // solhint-disable-next-line no-inline-assembly
378                 assembly {
379                     let returndata_size := mload(returndata)
380                     revert(add(32, returndata), returndata_size)
381                 }
382             } else {
383                 revert(errorMessage);
384             }
385         }
386     }
387 }
388 
389 contract Ownable is Context {
390     address private _owner;
391 
392     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
393 
394     /**
395      * @dev Initializes the contract setting the deployer as the initial owner.
396      */
397     constructor () internal {
398         address msgSender = _msgSender();
399         _owner = msgSender;
400         emit OwnershipTransferred(address(0), msgSender);
401     }
402 
403     /**
404      * @dev Returns the address of the current owner.
405      */
406     function owner() public view returns (address) {
407         return _owner;
408     }
409 
410     /**
411      * @dev Throws if called by any account other than the owner.
412      */
413     modifier onlyOwner() {
414         require(_owner == _msgSender(), "Ownable: caller is not the owner");
415         _;
416     }
417 
418     /**
419      * @dev Leaves the contract without owner. It will not be possible to call
420      * `onlyOwner` functions anymore. Can only be called by the current owner.
421      *
422      * NOTE: Renouncing ownership will leave the contract without an owner,
423      * thereby removing any functionality that is only available to the owner.
424      */
425     function renounceOwnership() public virtual onlyOwner {
426         emit OwnershipTransferred(_owner, address(0));
427         _owner = address(0);
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Can only be called by the current owner.
433      */
434     function transferOwnership(address newOwner) public virtual onlyOwner {
435         require(newOwner != address(0), "Ownable: new owner is the zero address");
436         emit OwnershipTransferred(_owner, newOwner);
437         _owner = newOwner;
438     }
439 }
440 
441 
442 
443 contract KONG is Context, IERC20, Ownable {
444     using SafeMath for uint256;
445     using Address for address;
446 
447     mapping (address => uint256) private _rOwned;
448     mapping (address => uint256) private _tOwned;
449     mapping (address => mapping (address => uint256)) private _allowances;
450 
451     mapping (address => bool) private _isExcluded;
452     address[] private _excluded;
453    
454     uint256 private constant MAX = ~uint256(0);
455     uint256 private constant _tTotal = 1000000 * 10**6 * 10**9;
456     uint256 private _rTotal = (MAX - (MAX % _tTotal));
457     uint256 private _tFeeTotal;
458 
459     string private _name = 'kongdefi.finance';
460     string private _symbol = 'KONG';
461     uint8 private _decimals = 9;
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
527     function reflect(uint256 tAmount) public {
528         address sender = _msgSender();
529         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
530         (uint256 rAmount,,,,) = _getValues(tAmount);
531         _rOwned[sender] = _rOwned[sender].sub(rAmount);
532         _rTotal = _rTotal.sub(rAmount);
533         _tFeeTotal = _tFeeTotal.add(tAmount);
534     }
535 
536     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
537         require(tAmount <= _tTotal, "Amount must be less than supply");
538         if (!deductTransferFee) {
539             (uint256 rAmount,,,,) = _getValues(tAmount);
540             return rAmount;
541         } else {
542             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
543             return rTransferAmount;
544         }
545     }
546 
547     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
548         require(rAmount <= _rTotal, "Amount must be less than total reflections");
549         uint256 currentRate =  _getRate();
550         return rAmount.div(currentRate);
551     }
552 
553     function excludeAccount(address account) external onlyOwner() {
554         require(!_isExcluded[account], "Account is already excluded");
555         if(_rOwned[account] > 0) {
556             _tOwned[account] = tokenFromReflection(_rOwned[account]);
557         }
558         _isExcluded[account] = true;
559         _excluded.push(account);
560     }
561 
562     function includeAccount(address account) external onlyOwner() {
563         require(_isExcluded[account], "Account is already excluded");
564         for (uint256 i = 0; i < _excluded.length; i++) {
565             if (_excluded[i] == account) {
566                 _excluded[i] = _excluded[_excluded.length - 1];
567                 _tOwned[account] = 0;
568                 _isExcluded[account] = false;
569                 _excluded.pop();
570                 break;
571             }
572         }
573     }
574 
575     function _approve(address owner, address spender, uint256 amount) private {
576         require(owner != address(0), "ERC20: approve from the zero address");
577         require(spender != address(0), "ERC20: approve to the zero address");
578 
579         _allowances[owner][spender] = amount;
580         emit Approval(owner, spender, amount);
581     }
582 
583     function _transfer(address sender, address recipient, uint256 amount) private {
584         require(sender != address(0), "ERC20: transfer from the zero address");
585         require(recipient != address(0), "ERC20: transfer to the zero address");
586         require(amount > 0, "Transfer amount must be greater than zero");
587         if (_isExcluded[sender] && !_isExcluded[recipient]) {
588             _transferFromExcluded(sender, recipient, amount);
589         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
590             _transferToExcluded(sender, recipient, amount);
591         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
592             _transferStandard(sender, recipient, amount);
593         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
594             _transferBothExcluded(sender, recipient, amount);
595         } else {
596             _transferStandard(sender, recipient, amount);
597         }
598     }
599 
600     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
601         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
602         _rOwned[sender] = _rOwned[sender].sub(rAmount);
603         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);      
604         _reflectFee(rFee, tFee);
605         emit Transfer(sender, recipient, tTransferAmount);
606     }
607 
608     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
609         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
610         _rOwned[sender] = _rOwned[sender].sub(rAmount);
611         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
612         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);          
613         _reflectFee(rFee, tFee);
614         emit Transfer(sender, recipient, tTransferAmount);
615     }
616 
617     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
618         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
619         _tOwned[sender] = _tOwned[sender].sub(tAmount);
620         _rOwned[sender] = _rOwned[sender].sub(rAmount);
621         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);  
622         _reflectFee(rFee, tFee);
623         emit Transfer(sender, recipient, tTransferAmount);
624     }
625 
626     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
627         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
628         _tOwned[sender] = _tOwned[sender].sub(tAmount);
629         _rOwned[sender] = _rOwned[sender].sub(rAmount);
630         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
631         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
632         _reflectFee(rFee, tFee);
633         emit Transfer(sender, recipient, tTransferAmount);
634     }
635 
636     function _reflectFee(uint256 rFee, uint256 tFee) private {
637         _rTotal = _rTotal.sub(rFee);
638         _tFeeTotal = _tFeeTotal.add(tFee);
639     }
640 
641     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
642         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
643         uint256 currentRate =  _getRate();
644         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
645         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
646     }
647 
648     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
649         uint256 tFee = tAmount.div(100).mul(2);
650         uint256 tTransferAmount = tAmount.sub(tFee);
651         return (tTransferAmount, tFee);
652     }
653 
654     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
655         uint256 rAmount = tAmount.mul(currentRate);
656         uint256 rFee = tFee.mul(currentRate);
657         uint256 rTransferAmount = rAmount.sub(rFee);
658         return (rAmount, rTransferAmount, rFee);
659     }
660 
661     function _getRate() private view returns(uint256) {
662         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
663         return rSupply.div(tSupply);
664     }
665 
666     function _getCurrentSupply() private view returns(uint256, uint256) {
667         uint256 rSupply = _rTotal;
668         uint256 tSupply = _tTotal;      
669         for (uint256 i = 0; i < _excluded.length; i++) {
670             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
671             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
672             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
673         }
674         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
675         return (rSupply, tSupply);
676     }
677 }