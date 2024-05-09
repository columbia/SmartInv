1 // File: @openzeppelin/contracts/utils/Address.sol
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Collection of functions related to the address type
6  */
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      */
25     function isContract(address account) internal view returns (bool) {
26         // This method relies on extcodesize, which returns 0 for contracts in
27         // construction, since the code is only stored at the end of the
28         // constructor execution.
29 
30         uint256 size;
31         // solhint-disable-next-line no-inline-assembly
32         assembly { size := extcodesize(account) }
33         return size > 0;
34     }
35 
36     /**
37      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
38      * `recipient`, forwarding all available gas and reverting on errors.
39      *
40      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
41      * of certain opcodes, possibly making contracts go over the 2300 gas limit
42      * imposed by `transfer`, making them unable to receive funds via
43      * `transfer`. {sendValue} removes this limitation.
44      *
45      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
46      *
47      * IMPORTANT: because control is transferred to `recipient`, care must be
48      * taken to not create reentrancy vulnerabilities. Consider using
49      * {ReentrancyGuard} or the
50      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
51      */
52     function sendValue(address payable recipient, uint256 amount) internal {
53         require(address(this).balance >= amount, "Address: insufficient balance");
54 
55         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
56         (bool success, ) = recipient.call{ value: amount }("");
57         require(success, "Address: unable to send value, recipient may have reverted");
58     }
59 
60     /**
61      * @dev Performs a Solidity function call using a low level `call`. A
62      * plain`call` is an unsafe replacement for a function call: use this
63      * function instead.
64      *
65      * If `target` reverts with a revert reason, it is bubbled up by this
66      * function (like regular Solidity function calls).
67      *
68      * Returns the raw returned data. To convert to the expected return value,
69      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
70      *
71      * Requirements:
72      *
73      * - `target` must be a contract.
74      * - calling `target` with `data` must not revert.
75      *
76      * _Available since v3.1._
77      */
78     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
79       return functionCall(target, data, "Address: low-level call failed");
80     }
81 
82     /**
83      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
84      * `errorMessage` as a fallback revert reason when `target` reverts.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
89         return functionCallWithValue(target, data, 0, errorMessage);
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
94      * but also transferring `value` wei to `target`.
95      *
96      * Requirements:
97      *
98      * - the calling contract must have an ETH balance of at least `value`.
99      * - the called Solidity function must be `payable`.
100      *
101      * _Available since v3.1._
102      */
103     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
109      * with `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
114         require(address(this).balance >= value, "Address: insufficient balance for call");
115         require(isContract(target), "Address: call to non-contract");
116 
117         // solhint-disable-next-line avoid-low-level-calls
118         (bool success, bytes memory returndata) = target.call{ value: value }(data);
119         return _verifyCallResult(success, returndata, errorMessage);
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
124      * but performing a static call.
125      *
126      * _Available since v3.3._
127      */
128     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
129         return functionStaticCall(target, data, "Address: low-level static call failed");
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
134      * but performing a static call.
135      *
136      * _Available since v3.3._
137      */
138     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
139         require(isContract(target), "Address: static call to non-contract");
140 
141         // solhint-disable-next-line avoid-low-level-calls
142         (bool success, bytes memory returndata) = target.staticcall(data);
143         return _verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a delegate call.
149      *
150      * _Available since v3.4._
151      */
152     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
158      * but performing a delegate call.
159      *
160      * _Available since v3.4._
161      */
162     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
163         require(isContract(target), "Address: delegate call to non-contract");
164 
165         // solhint-disable-next-line avoid-low-level-calls
166         (bool success, bytes memory returndata) = target.delegatecall(data);
167         return _verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
171         if (success) {
172             return returndata;
173         } else {
174             // Look for revert reason and bubble it up if present
175             if (returndata.length > 0) {
176                 // The easiest way to bubble the revert reason is using memory via assembly
177 
178                 // solhint-disable-next-line no-inline-assembly
179                 assembly {
180                     let returndata_size := mload(returndata)
181                     revert(add(32, returndata), returndata_size)
182                 }
183             } else {
184                 revert(errorMessage);
185             }
186         }
187     }
188 }
189 
190 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @dev Interface of the ERC20 standard as defined in the EIP.
195  */
196 interface IERC20 {
197     /**
198      * @dev Returns the amount of tokens in existence.
199      */
200     function totalSupply() external view returns (uint256);
201 
202     /**
203      * @dev Returns the amount of tokens owned by `account`.
204      */
205     function balanceOf(address account) external view returns (uint256);
206 
207     /**
208      * @dev Moves `amount` tokens from the caller's account to `recipient`.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transfer(address recipient, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Returns the remaining number of tokens that `spender` will be
218      * allowed to spend on behalf of `owner` through {transferFrom}. This is
219      * zero by default.
220      *
221      * This value changes when {approve} or {transferFrom} are called.
222      */
223     function allowance(address owner, address spender) external view returns (uint256);
224 
225     /**
226      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * IMPORTANT: Beware that changing an allowance with this method brings the risk
231      * that someone may use both the old and the new allowance by unfortunate
232      * transaction ordering. One possible solution to mitigate this race
233      * condition is to first reduce the spender's allowance to 0 and set the
234      * desired value afterwards:
235      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236      *
237      * Emits an {Approval} event.
238      */
239     function approve(address spender, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Moves `amount` tokens from `sender` to `recipient` using the
243      * allowance mechanism. `amount` is then deducted from the caller's
244      * allowance.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * Emits a {Transfer} event.
249      */
250     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
251 
252     /**
253      * @dev Emitted when `value` tokens are moved from one account (`from`) to
254      * another (`to`).
255      *
256      * Note that `value` may be zero.
257      */
258     event Transfer(address indexed from, address indexed to, uint256 value);
259 
260     /**
261      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
262      * a call to {approve}. `value` is the new allowance.
263      */
264     event Approval(address indexed owner, address indexed spender, uint256 value);
265 }
266 
267 // File: @openzeppelin/contracts/utils/Context.sol
268 pragma solidity ^0.8.0;
269 
270 /*
271  * @dev Provides information about the current execution context, including the
272  * sender of the transaction and its data. While these are generally available
273  * via msg.sender and msg.data, they should not be accessed in such a direct
274  * manner, since when dealing with meta-transactions the account sending and
275  * paying for execution may not be the actual sender (as far as an application
276  * is concerned).
277  *
278  * This contract is only required for intermediate, library-like contracts.
279  */
280 abstract contract Context {
281     function _msgSender() internal view virtual returns (address) {
282         return msg.sender;
283     }
284 
285     function _msgData() internal view virtual returns (bytes calldata) {
286         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
287         return msg.data;
288     }
289 }
290 
291 // File: @openzeppelin/contracts/access/Ownable.sol
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev Contract module which provides a basic access control mechanism, where
296  * there is an account (an owner) that can be granted exclusive access to
297  * specific functions.
298  *
299  * By default, the owner account will be the one that deploys the contract. This
300  * can later be changed with {transferOwnership}.
301  *
302  * This module is used through inheritance. It will make available the modifier
303  * `onlyOwner`, which can be applied to your functions to restrict their use to
304  * the owner.
305  */
306 abstract contract Ownable is Context {
307     address private _owner;
308 
309     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
310 
311     /**
312      * @dev Initializes the contract setting the deployer as the initial owner.
313      */
314     constructor () {
315         address msgSender = _msgSender();
316         _owner = msgSender;
317         emit OwnershipTransferred(address(0), msgSender);
318     }
319 
320     /**
321      * @dev Returns the address of the current owner.
322      */
323     function owner() public view virtual returns (address) {
324         return _owner;
325     }
326 
327     /**
328      * @dev Throws if called by any account other than the owner.
329      */
330     modifier onlyOwner() {
331         require(owner() == _msgSender(), "Ownable: caller is not the owner");
332         _;
333     }
334 
335     /**
336      * @dev Leaves the contract without owner. It will not be possible to call
337      * `onlyOwner` functions anymore. Can only be called by the current owner.
338      *
339      * NOTE: Renouncing ownership will leave the contract without an owner,
340      * thereby removing any functionality that is only available to the owner.
341      */
342     function renounceOwnership() public virtual onlyOwner {
343         emit OwnershipTransferred(_owner, address(0));
344         _owner = address(0);
345     }
346 
347     /**
348      * @dev Transfers ownership of the contract to a new account (`newOwner`).
349      * Can only be called by the current owner.
350      */
351     function transferOwnership(address newOwner) public virtual onlyOwner {
352         require(newOwner != address(0), "Ownable: new owner is the zero address");
353         emit OwnershipTransferred(_owner, newOwner);
354         _owner = newOwner;
355     }
356 }
357 
358 // File: Whalecom.sol
359 
360 // SPDX-License-Identifier: Unlicensed
361 pragma solidity >=0.8.0 <0.9.0;
362 
363 contract WHALECOM is Context, IERC20, Ownable {
364     using Address for address;
365     uint256 public constant MAX = ~uint256(0);
366 
367     mapping(address => uint256) private _rOwned;
368     mapping(address => uint256) private _tOwned;
369     mapping(address => mapping(address => uint256)) private _allowances;
370 
371     mapping(address => bool) private _isExcluded;
372     address[] private _excluded;
373 
374     uint256 private _tTotal = 10**15 * 10**18;
375     uint256 private _rTotal = (MAX - (MAX % _tTotal));
376     uint256 private _tFeeTotal;
377 
378     string private _name = "WHALECOM";
379     string private _symbol = "WCOM";
380     uint8 private _decimals = 18;
381 
382     constructor() {
383         _rOwned[_msgSender()] = _rTotal;
384         emit Transfer(address(0), _msgSender(), _tTotal);
385     }
386 
387     function name() public view returns (string memory) {
388         return _name;
389     }
390 
391     function symbol() public view returns (string memory) {
392         return _symbol;
393     }
394 
395     function decimals() public view returns (uint8) {
396         return _decimals;
397     }
398 
399     function totalSupply() public view override returns (uint256) {
400         return _tTotal;
401     }
402 
403     function balanceOf(address account) public view override returns (uint256) {
404         if (_isExcluded[account]) return _tOwned[account];
405         return tokenFromReflection(_rOwned[account]);
406     }
407 
408     function transfer(address recipient, uint256 amount) public override returns (bool) {
409         _transfer(_msgSender(), recipient, amount);
410         return true;
411     }
412 
413     function allowance(address owner, address spender) public view override returns (uint256) {
414         return _allowances[owner][spender];
415     }
416 
417     function approve(address spender, uint256 amount) public override returns (bool) {
418         _approve(_msgSender(), spender, amount);
419         return true;
420     }
421 
422     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
423         _transfer(sender, recipient, amount);
424         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
425         return true;
426     }
427 
428     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
429         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
430         return true;
431     }
432 
433     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
434         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
435         return true;
436     }
437 
438     function isExcluded(address account) public view returns (bool) {
439         return _isExcluded[account];
440     }
441 
442     function totalFees() public view returns (uint256) {
443         return _tFeeTotal;
444     }
445 
446     function reflect(uint256 tAmount) public {
447         address sender = _msgSender();
448         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
449         (uint256 rAmount, , , , ) = _getValues(tAmount);
450         _rOwned[sender] = _rOwned[sender] - rAmount;
451         _rTotal = _rTotal - rAmount;
452         _tFeeTotal = _tFeeTotal + tAmount;
453     }
454 
455     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
456         require(tAmount <= _tTotal, "Amount must be less than supply");
457         if (!deductTransferFee) {
458             (uint256 rAmount, , , , ) = _getValues(tAmount);
459             return rAmount;
460         } else {
461             (, uint256 rTransferAmount, , , ) = _getValues(tAmount);
462             return rTransferAmount;
463         }
464     }
465 
466     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
467         require(rAmount <= _rTotal, "Amount must be less than total reflections");
468         uint256 currentRate = _getRate();
469         return rAmount / currentRate;
470     }
471 
472     function excludeAccount(address account) external onlyOwner() {
473         require(!_isExcluded[account], "Account is already excluded");
474         if (_rOwned[account] > 0) {
475             _tOwned[account] = tokenFromReflection(_rOwned[account]);
476         }
477         _isExcluded[account] = true;
478         _excluded.push(account);
479     }
480 
481     function includeAccount(address account) external onlyOwner() {
482         require(_isExcluded[account], "Account is already excluded");
483         for (uint256 i = 0; i < _excluded.length; i++) {
484             if (_excluded[i] == account) {
485                 _excluded[i] = _excluded[_excluded.length - 1];
486                 _tOwned[account] = 0;
487                 _isExcluded[account] = false;
488                 _excluded.pop();
489                 break;
490             }
491         }
492     }
493 
494     function _approve(address owner, address spender, uint256 amount) private {
495         require(owner != address(0), "ERC20: approve from the zero address");
496         require(spender != address(0), "ERC20: approve to the zero address");
497 
498         _allowances[owner][spender] = amount;
499         emit Approval(owner, spender, amount);
500     }
501 
502     function _transfer(address sender, address recipient, uint256 amount) private {
503         require(sender != address(0), "ERC20: transfer from the zero address");
504         require(recipient != address(0), "ERC20: transfer to the zero address");
505         require(amount > 0, "Transfer amount must be greater than zero");
506         if (_isExcluded[sender] && !_isExcluded[recipient]) {
507             _transferFromExcluded(sender, recipient, amount);
508         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
509             _transferToExcluded(sender, recipient, amount);
510         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
511             _transferStandard(sender, recipient, amount);
512         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
513             _transferBothExcluded(sender, recipient, amount);
514         } else {
515             _transferStandard(sender, recipient, amount);
516         }
517     }
518 
519     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
520         (
521             uint256 rAmount,
522             uint256 rTransferAmount,
523             uint256 rFee,
524             uint256 tTransferAmount,
525             uint256 tFee
526         ) = _getValues(tAmount);
527 
528         _rOwned[sender] = _rOwned[sender] - rAmount;
529         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
530         _reflectFee(rFee, tFee);
531         emit Transfer(sender, recipient, tTransferAmount);
532     }
533 
534     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
535         (
536             uint256 rAmount,
537             uint256 rTransferAmount,
538             uint256 rFee,
539             uint256 tTransferAmount,
540             uint256 tFee
541         ) = _getValues(tAmount);
542 
543         _rOwned[sender] = _rOwned[sender] - rAmount;
544         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
545         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
546         _reflectFee(rFee, tFee);
547         emit Transfer(sender, recipient, tTransferAmount);
548     }
549 
550     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
551         (
552             uint256 rAmount,
553             uint256 rTransferAmount,
554             uint256 rFee,
555             uint256 tTransferAmount,
556             uint256 tFee
557         ) = _getValues(tAmount);
558 
559         _tOwned[sender] = _tOwned[sender] - tAmount;
560         _rOwned[sender] = _rOwned[sender] - rAmount;
561         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
562         _reflectFee(rFee, tFee);
563         emit Transfer(sender, recipient, tTransferAmount);
564     }
565 
566     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
567         (
568             uint256 rAmount,
569             uint256 rTransferAmount,
570             uint256 rFee,
571             uint256 tTransferAmount,
572             uint256 tFee
573         ) = _getValues(tAmount);
574 
575         _tOwned[sender] = _tOwned[sender] - tAmount;
576         _rOwned[sender] = _rOwned[sender] - rAmount;
577         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
578         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
579         _reflectFee(rFee, tFee);
580         emit Transfer(sender, recipient, tTransferAmount);
581     }
582 
583     function _reflectFee(uint256 rFee, uint256 tFee) private {
584         _rTotal = _rTotal - rFee;
585         _tFeeTotal = _tFeeTotal + tFee;
586     }
587 
588     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
589         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
590         uint256 currentRate = _getRate();
591         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
592         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
593     }
594 
595     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
596         uint256 tFee = tAmount / 100 * 2;
597         uint256 tTransferAmount = tAmount - tFee;
598         return (tTransferAmount, tFee);
599     }
600 
601     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate)
602         private
603         pure
604         returns (uint256, uint256, uint256)
605     {
606         uint256 rAmount = tAmount * currentRate;
607         uint256 rFee = tFee * currentRate;
608         uint256 rTransferAmount = rAmount - rFee;
609         return (rAmount, rTransferAmount, rFee);
610     }
611 
612     function _getRate() private view returns (uint256) {
613         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
614         return rSupply / tSupply;
615     }
616 
617     function _getCurrentSupply() private view returns (uint256, uint256) {
618         uint256 rSupply = _rTotal;
619         uint256 tSupply = _tTotal;
620         for (uint256 i = 0; i < _excluded.length; i++) {
621             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
622             rSupply = rSupply - _rOwned[_excluded[i]];
623             tSupply = tSupply - _tOwned[_excluded[i]];
624         }
625         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
626         return (rSupply, tSupply);
627     }
628 }