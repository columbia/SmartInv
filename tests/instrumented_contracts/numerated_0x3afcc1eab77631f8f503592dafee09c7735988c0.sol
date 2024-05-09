1 /**
2 
3 */
4 
5 // Elon Musk just tweeted about it: Floki Santa
6 
7 // tg: FlokiSantaTokenETH
8 
9 
10 // SPDX-License-Identifier: Unlicensed
11 
12 pragma solidity ^0.8.7;
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 /*
64  * @dev Provides information about the current execution context, including the
65  * sender of the transaction and its data. While these are generally available
66  * via msg.sender and msg.data, they should not be accessed in such a direct
67  * manner, since when dealing with meta-transactions the account sending and
68  * paying for execution may not be the actual sender (as far as an application
69  * is concerned).
70  *
71  * This contract is only required for intermediate, library-like contracts.
72  */
73 abstract contract Context {
74     function _msgSender() internal view virtual returns (address) {
75         return msg.sender;
76     }
77 
78     function _msgData() internal view virtual returns (bytes calldata) {
79         return msg.data;
80     }
81 }
82 
83 /**
84  * @dev Collection of functions related to the address type
85  */
86 library Address {
87     /**
88      * @dev Returns true if `account` is a contract.
89      *
90      * [IMPORTANT]
91      * ====
92      * It is unsafe to assume that an address for which this function returns
93      * false is an externally-owned account (EOA) and not a contract.
94      *
95      * Among others, `isContract` will return false for the following
96      * types of addresses:
97      *
98      *  - an externally-owned account
99      *  - a contract in construction
100      *  - an address where a contract will be created
101      *  - an address where a contract lived, but was destroyed
102      * ====
103      */
104     function isContract(address account) internal view returns (bool) {
105         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
106         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
107         // for accounts without code, i.e. `keccak256('')`
108         bytes32 codehash;
109         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
110         // solhint-disable-next-line no-inline-assembly
111         assembly { codehash := extcodehash(account) }
112         return (codehash != accountHash && codehash != 0x0);
113     }
114 
115     /**
116      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
117      * `recipient`, forwarding all available gas and reverting on errors.
118      *
119      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
120      * of certain opcodes, possibly making contracts go over the 2300 gas limit
121      * imposed by `transfer`, making them unable to receive funds via
122      * `transfer`. {sendValue} removes this limitation.
123      *
124      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
125      *
126      * IMPORTANT: because control is transferred to `recipient`, care must be
127      * taken to not create reentrancy vulnerabilities. Consider using
128      * {ReentrancyGuard} or the
129      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
130      */
131     function sendValue(address payable recipient, uint256 amount) internal {
132         require(address(this).balance >= amount, "Address: insufficient balance");
133 
134         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
135         (bool success, ) = recipient.call{ value: amount }("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain`call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         return _functionCallWithValue(target, data, 0, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but also transferring `value` wei to `target`.
174      *
175      * Requirements:
176      *
177      * - the calling contract must have an ETH balance of at least `value`.
178      * - the called Solidity function must be `payable`.
179      *
180      * _Available since v3.1._
181      */
182     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
188      * with `errorMessage` as a fallback revert reason when `target` reverts.
189      *
190      * _Available since v3.1._
191      */
192     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
193         require(address(this).balance >= value, "Address: insufficient balance for call");
194         return _functionCallWithValue(target, data, value, errorMessage);
195     }
196 
197     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
198         require(isContract(target), "Address: call to non-contract");
199 
200         // solhint-disable-next-line avoid-low-level-calls
201         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
202         if (success) {
203             return returndata;
204         } else {
205             // Look for revert reason and bubble it up if present
206             if (returndata.length > 0) {
207                 // The easiest way to bubble the revert reason is using memory via assembly
208 
209                 // solhint-disable-next-line no-inline-assembly
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 }
220 
221 contract Ownable is Context {
222     address private _owner;
223     address private _previousOwner;
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     constructor () {
227         address msgSender = _msgSender();
228         _owner = msgSender;
229         emit OwnershipTransferred(address(0), msgSender);
230     }
231 
232     function owner() public view returns (address) {
233         return _owner;
234     }
235 
236     modifier onlyOwner() {
237         require(_owner == _msgSender(), "Ownable: caller is not the owner");
238         _;
239     }
240 
241     function renounceOwnership() public virtual onlyOwner {
242         emit OwnershipTransferred(_owner, address(0));
243         _owner = address(0);
244     }
245 
246 }  
247 
248 interface IUniswapV2Factory {
249     function createPair(address tokenA, address tokenB) external returns (address pair);
250 }
251 
252 interface IUniswapV2Pair {
253     event Approval(address indexed owner, address indexed spender, uint value);
254     event Transfer(address indexed from, address indexed to, uint value);
255 
256     function name() external pure returns (string memory);
257     function symbol() external pure returns (string memory);
258     function decimals() external pure returns (uint8);
259     function totalSupply() external view returns (uint);
260     function balanceOf(address owner) external view returns (uint);
261     function allowance(address owner, address spender) external view returns (uint);
262 
263     function approve(address spender, uint value) external returns (bool);
264     function transfer(address to, uint value) external returns (bool);
265     function transferFrom(address from, address to, uint value) external returns (bool);
266 
267     function DOMAIN_SEPARATOR() external view returns (bytes32);
268     function PERMIT_TYPEHASH() external pure returns (bytes32);
269     function nonces(address owner) external view returns (uint);
270 
271     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
272 
273     event Mint(address indexed sender, uint amount0, uint amount1);
274     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
275     event Swap(
276         address indexed sender,
277         uint amount0In,
278         uint amount1In,
279         uint amount0Out,
280         uint amount1Out,
281         address indexed to
282     );
283     event Sync(uint112 reserve0, uint112 reserve1);
284 
285     function MINIMUM_LIQUIDITY() external pure returns (uint);
286     function factory() external view returns (address);
287     function token0() external view returns (address);
288     function token1() external view returns (address);
289     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
290     function price0CumulativeLast() external view returns (uint);
291     function price1CumulativeLast() external view returns (uint);
292     function kLast() external view returns (uint);
293 
294     function mint(address to) external returns (uint liquidity);
295     function burn(address to) external returns (uint amount0, uint amount1);
296     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
297     function skim(address to) external;
298     function sync() external;
299 
300     function initialize(address, address) external;
301 }
302 
303 interface IUniswapV2Router02 {
304     function swapExactTokensForETHSupportingFeeOnTransferTokens(
305         uint amountIn,
306         uint amountOutMin,
307         address[] calldata path,
308         address to,
309         uint deadline
310     ) external;
311     function factory() external pure returns (address);
312     function WETH() external pure returns (address);
313     function addLiquidityETH(
314         address token,
315         uint amountTokenDesired,
316         uint amountTokenMin,
317         uint amountETHMin,
318         address to,
319         uint deadline
320     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
321 }
322 
323 contract FlokiSanta is Context, IERC20, Ownable {
324     using SafeMath for uint256;
325     using Address for address;
326 
327     mapping (address => uint256) private _rOwned;
328     mapping (address => uint256) private _tOwned;
329     mapping (address => mapping (address => uint256)) private _allowances;
330 
331     mapping (address => bool) private _isExcludedFromFee;
332 
333     mapping (address => bool) private _isExcluded;
334     address[] private _excluded;
335 
336     mapping(address => bool) private _isSniper;
337     address[] private _confirmedSnipers;
338 
339     address payable public _marketingAddress = payable(0x235e35eF03F194C5449c40717589125524a651A0);
340 
341     uint256 private constant MAX = ~uint256(0);
342     uint256 private _tTotal = 100 * 10**9 * 10**9;
343     uint256 private _rTotal = (MAX - (MAX % _tTotal));
344     uint256 private _tFeeTotal;
345 
346     string private _name = "Floki Santa";
347     string private _symbol = "$FS";
348     uint8 private _decimals = 9;
349 
350     uint256 public _taxFee = 3;
351     uint256 private _previousTaxFee = _taxFee;
352 
353     uint256 public _marketingFee = 7;
354     uint256 private _previousmarketingFee = _marketingFee;
355 
356     uint256 launchTime;
357 
358     IUniswapV2Router02 public immutable uniswapV2Router;
359     address public immutable uniswapV2Pair;
360 
361     bool inSwapAndLiquify;
362     bool public swapAndLiquifyEnabled = true;
363     bool tradingOpen = false;
364 
365     uint256 public _maxTxAmount = 20 * 10**9 * 10**9;
366 
367     // Liquify when 400m tokens are stored
368     uint256 private numTokensSellToLiquify = 400 * 10**6 * 10**9;
369 
370     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
371     event SwapAndLiquifyEnabledUpdated(bool enabled);
372     event SwapAndLiquify(
373         uint256 tokensSwapped,
374         uint256 ethReceived
375     );
376     event TransferToMarketing(uint256 ethTransferred);
377 
378     modifier lockTheSwap {
379         inSwapAndLiquify = true;
380         _;
381         inSwapAndLiquify = false;
382     }
383 
384     constructor () {
385         _rOwned[_msgSender()] = _rTotal;
386 
387         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
388         // Create a uniswap pair for token
389         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
390         .createPair(address(this), _uniswapV2Router.WETH());
391 
392         // set the rest of the contract variables
393         uniswapV2Router = _uniswapV2Router;
394 
395         //exclude owner and this contract from fee
396         _isExcludedFromFee[owner()] = true;
397         _isExcludedFromFee[address(this)] = true;
398         _isExcludedFromFee[_marketingAddress] = true;
399 
400         emit Transfer(address(0), _msgSender(), _tTotal);
401     }
402 
403     function openTrading() external onlyOwner {
404         tradingOpen = true;
405         launchTime = block.timestamp;
406     }
407 
408     function name() public view returns (string memory) {
409         return _name;
410     }
411 
412     function symbol() public view returns (string memory) {
413         return _symbol;
414     }
415 
416     function decimals() public view returns (uint8) {
417         return _decimals;
418     }
419 
420     function totalSupply() public view override returns (uint256) {
421         return _tTotal;
422     }
423 
424     function balanceOf(address account) public view override returns (uint256) {
425         if (_isExcluded[account]) return _tOwned[account];
426         return tokenFromReflection(_rOwned[account]);
427     }
428 
429     function transfer(address recipient, uint256 amount) public override returns (bool) {
430         _transfer(_msgSender(), recipient, amount);
431         return true;
432     }
433 
434     function allowance(address owner, address spender) public view override returns (uint256) {
435         return _allowances[owner][spender];
436     }
437 
438     function approve(address spender, uint256 amount) public override returns (bool) {
439         _approve(_msgSender(), spender, amount);
440         return true;
441     }
442 
443     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
444         _transfer(sender, recipient, amount);
445         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
446         return true;
447     }
448 
449     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
450         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
451         return true;
452     }
453 
454     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
455         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
456         return true;
457     }
458 
459     function isExcludedFromReward(address account) public view returns (bool) {
460         return _isExcluded[account];
461     }
462 
463     function totalFees() public view returns (uint256) {
464         return _tFeeTotal;
465     }
466 
467     function deliver(uint256 tAmount) public {
468         address sender = _msgSender();
469         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
470         (uint256 rAmount,,,,,) = _getValues(tAmount);
471         _rOwned[sender] = _rOwned[sender].sub(rAmount);
472         _rTotal = _rTotal.sub(rAmount);
473         _tFeeTotal = _tFeeTotal.add(tAmount);
474     }
475 
476     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
477         require(tAmount <= _tTotal, "Amount must be less than supply");
478         if (!deductTransferFee) {
479             (uint256 rAmount,,,,,) = _getValues(tAmount);
480             return rAmount;
481         } else {
482             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
483             return rTransferAmount;
484         }
485     }
486 
487     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
488         require(rAmount <= _rTotal, "Amount must be less than total reflections");
489         uint256 currentRate =  _getRate();
490         return rAmount.div(currentRate);
491     }
492 
493     function excludeFromReward(address account) public onlyOwner() {
494         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
495         require(!_isExcluded[account], "Account is already excluded");
496         if(_rOwned[account] > 0) {
497             _tOwned[account] = tokenFromReflection(_rOwned[account]);
498         }
499         _isExcluded[account] = true;
500         _excluded.push(account);
501     }
502 
503     function includeInReward(address account) external onlyOwner() {
504         require(_isExcluded[account], "Account is already excluded");
505         for (uint256 i = 0; i < _excluded.length; i++) {
506             if (_excluded[i] == account) {
507                 _excluded[i] = _excluded[_excluded.length - 1];
508                 _tOwned[account] = 0;
509                 _isExcluded[account] = false;
510                 _excluded.pop();
511                 break;
512             }
513         }
514     }
515     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
516         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
517         _tOwned[sender] = _tOwned[sender].sub(tAmount);
518         _rOwned[sender] = _rOwned[sender].sub(rAmount);
519         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
520         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
521         _takeLiquidity(tLiquidity);
522         _reflectFee(rFee, tFee);
523         emit Transfer(sender, recipient, tTransferAmount);
524     }
525 
526     function excludeFromFee(address account) public onlyOwner {
527         _isExcludedFromFee[account] = true;
528     }
529 
530     function includeInFee(address account) public onlyOwner {
531         _isExcludedFromFee[account] = false;
532     }
533 
534     function setmarketingFeePercent(uint256 marketingFee) external onlyOwner() {
535         _marketingFee = marketingFee;
536     }
537 
538     function setTaxFeePercent(uint256 taxFee) external onlyOwner {
539         _taxFee = taxFee;
540     }
541 
542     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
543         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
544             10**2
545         );
546     }
547 
548     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
549         swapAndLiquifyEnabled = _enabled;
550         emit SwapAndLiquifyEnabledUpdated(_enabled);
551     }
552 
553     //to receive ETH from uniswapV2Router when swapping
554     receive() external payable {}
555 
556     function _reflectFee(uint256 rFee, uint256 tFee) private {
557         _rTotal = _rTotal.sub(rFee);
558         _tFeeTotal = _tFeeTotal.add(tFee);
559     }
560 
561     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
562         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
563         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
564         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
565     }
566 
567     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
568         uint256 tFee = calculateTaxFee(tAmount);
569         uint256 tLiquidity = calculatemarketingFee(tAmount);
570         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
571         return (tTransferAmount, tFee, tLiquidity);
572     }
573 
574     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
575         uint256 rAmount = tAmount.mul(currentRate);
576         uint256 rFee = tFee.mul(currentRate);
577         uint256 rLiquidity = tLiquidity.mul(currentRate);
578         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
579         return (rAmount, rTransferAmount, rFee);
580     }
581 
582     function _getRate() private view returns(uint256) {
583         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
584         return rSupply.div(tSupply);
585     }
586 
587     function _getCurrentSupply() private view returns(uint256, uint256) {
588         uint256 rSupply = _rTotal;
589         uint256 tSupply = _tTotal;
590         for (uint256 i = 0; i < _excluded.length; i++) {
591             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
592             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
593             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
594         }
595         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
596         return (rSupply, tSupply);
597     }
598 
599     function _takeLiquidity(uint256 tLiquidity) private {
600         uint256 currentRate =  _getRate();
601         uint256 rLiquidity = tLiquidity.mul(currentRate);
602         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
603         if(_isExcluded[address(this)])
604             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
605     }
606 
607     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
608         return _amount.mul(_taxFee).div(
609             10**2
610         );
611     }
612 
613     function calculatemarketingFee(uint256 _amount) private view returns (uint256) {
614         return _amount.mul(_marketingFee).div(
615             10**2
616         );
617     }
618 
619     function removeAllFee() private {
620         if(_taxFee == 0 && _marketingFee == 0) return;
621 
622         _previousTaxFee = _taxFee;
623         _previousmarketingFee = _marketingFee;
624 
625         _taxFee = 0;
626         _marketingFee = 0;
627     }
628 
629     function restoreAllFee() private {
630         _taxFee = _previousTaxFee;
631         _marketingFee = _previousmarketingFee;
632     }
633 
634     function isExcludedFromFee(address account) public view returns(bool) {
635         return _isExcludedFromFee[account];
636     }
637 
638     function _approve(address owner, address spender, uint256 amount) private {
639         require(owner != address(0), "ERC20: approve from the zero address");
640         require(spender != address(0), "ERC20: approve to the zero address");
641 
642         _allowances[owner][spender] = amount;
643         emit Approval(owner, spender, amount);
644     }
645 
646     function _transfer(
647         address from,
648         address to,
649         uint256 amount
650     ) private {
651         require(from != address(0), "ERC20: transfer from the zero address");
652         require(to != address(0), "ERC20: transfer to the zero address");
653         require(amount > 0, "Transfer amount must be greater than zero");
654         require(!_isSniper[to], 'You have no power here!');
655         require(!_isSniper[msg.sender], 'You have no power here!');
656         if(from != owner() && to != owner())
657             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
658 
659         // is the token balance of this contract address over the min number of
660         // tokens that we need to initiate a swap?
661         // also, don't get caught in a circular liquidity event.
662         // also, don't swap & liquify if sender is uniswap pair.
663         uint256 contractTokenBalance = balanceOf(address(this));
664 
665         if(contractTokenBalance >= _maxTxAmount)
666         {
667             contractTokenBalance = _maxTxAmount;
668         }
669 
670         // buy
671         if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
672             require(tradingOpen, 'Trading not yet enabled.');
673 
674             //antibot
675             if (block.timestamp == launchTime) {
676                 _isSniper[to] = true;
677                 _confirmedSnipers.push(to);
678             }
679         }
680 
681         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToLiquify;
682         if (
683             overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled
684         ) {
685             contractTokenBalance = numTokensSellToLiquify;
686             swapAndLiquify(contractTokenBalance);
687         }
688 
689         //indicates if fee should be deducted from transfer
690         bool takeFee = true;
691 
692         //if any account belongs to _isExcludedFromFee account then remove the fee
693         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
694             takeFee = false;
695         }
696 
697         //transfer amount, it will take tax, burn, liquidity fee
698         _tokenTransfer(from,to,amount,takeFee);
699     }
700 
701     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
702         
703         uint256 marketingTokenBalance = contractTokenBalance;
704 
705         // capture the contract's current eth balance.
706         // this is so that we can capture exactly the amount of eth that the
707         // swap creates, and not make the liquidity event include any eth that
708         // has been manually sent to the contract
709         uint256 initialBalance = address(this).balance;
710 
711         // swap tokens for eth
712         swapTokensForEth(marketingTokenBalance);
713 
714         // Total eth that has been swapped
715         uint256 ethSwapped = address(this).balance.sub(initialBalance);
716 
717         emit SwapAndLiquify(marketingTokenBalance, ethSwapped);
718 
719         // The remaining eth balance is to be Transferred to the marketing wallet
720         uint256 marketingethToTransfer = ethSwapped;
721 
722         // Transfer the eth to the marketing wallet
723         _marketingAddress.transfer(marketingethToTransfer);
724         emit TransferToMarketing(marketingethToTransfer);
725     }
726 
727     function swapTokensForEth(uint256 tokenAmount) private {
728         // generate the uniswap pair path of token -> weth
729         address[] memory path = new address[](2);
730         path[0] = address(this);
731         path[1] = uniswapV2Router.WETH();
732 
733         _approve(address(this), address(uniswapV2Router), tokenAmount);
734 
735         // make the swap
736         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
737             tokenAmount,
738             0, // accept any amount of ETH
739             path,
740             address(this),
741             block.timestamp
742         );
743     }
744 
745     //this method is responsible for taking all fee, if takeFee is true
746     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
747         if(!takeFee)
748             removeAllFee();
749 
750         if (_isExcluded[sender] && !_isExcluded[recipient]) {
751             _transferFromExcluded(sender, recipient, amount);
752         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
753             _transferToExcluded(sender, recipient, amount);
754         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
755             _transferStandard(sender, recipient, amount);
756         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
757             _transferBothExcluded(sender, recipient, amount);
758         } else {
759             _transferStandard(sender, recipient, amount);
760         }
761 
762         if(!takeFee)
763             restoreAllFee();
764     }
765 
766     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
767         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
768         _rOwned[sender] = _rOwned[sender].sub(rAmount);
769         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
770         _takeLiquidity(tLiquidity);
771         _reflectFee(rFee, tFee);
772         emit Transfer(sender, recipient, tTransferAmount);
773     }
774 
775     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
776         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
777         _rOwned[sender] = _rOwned[sender].sub(rAmount);
778         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
779         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
780         _takeLiquidity(tLiquidity);
781         _reflectFee(rFee, tFee);
782         emit Transfer(sender, recipient, tTransferAmount);
783     }
784 
785     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
786         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
787         _tOwned[sender] = _tOwned[sender].sub(tAmount);
788         _rOwned[sender] = _rOwned[sender].sub(rAmount);
789         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
790         _takeLiquidity(tLiquidity);
791         _reflectFee(rFee, tFee);
792         emit Transfer(sender, recipient, tTransferAmount);
793     }
794 
795     function isRemovedSniper(address account) public view returns (bool) {
796         return _isSniper[account];
797     }
798 
799     function _removeSniper(address account) external onlyOwner {
800         require(
801             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
802             'We can not blacklist Uniswap'
803         );
804         require(!_isSniper[account], 'Account is already blacklisted');
805         _isSniper[account] = true;
806         _confirmedSnipers.push(account);
807     }
808 
809     function _amnestySniper(address account) external onlyOwner {
810         require(_isSniper[account], 'Account is not blacklisted');
811         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
812             if (_confirmedSnipers[i] == account) {
813                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
814                 _isSniper[account] = false;
815                 _confirmedSnipers.pop();
816                 break;
817             }
818         }
819     }
820 }