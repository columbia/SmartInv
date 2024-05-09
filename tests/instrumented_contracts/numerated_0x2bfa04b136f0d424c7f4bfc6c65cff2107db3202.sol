1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-15
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 pragma solidity ^0.8.0;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     /**
32      * @dev Returns the addition of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             uint256 c = a + b;
39             if (c < a) return (false, 0);
40             return (true, c);
41         }
42     }
43 
44     /**
45      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             if (b > a) return (false, 0);
52             return (true, a - b);
53         }
54     }
55 
56     /**
57      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64             // benefit is lost if 'b' is also tested.
65             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66             if (a == 0) return (true, 0);
67             uint256 c = a * b;
68             if (c / a != b) return (false, 0);
69             return (true, c);
70         }
71     }
72 
73     /**
74      * @dev Returns the division of two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a / b);
82         }
83     }
84 
85     /**
86      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             if (b == 0) return (false, 0);
93             return (true, a % b);
94         }
95     }
96 
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         return a + b;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a - b;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      *
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a * b;
137     }
138 
139     /**
140      * @dev Returns the integer division of two unsigned integers, reverting on
141      * division by zero. The result is rounded towards zero.
142      *
143      * Counterpart to Solidity's `/` operator.
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function div(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a / b;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * reverting when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         return a % b;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171      * overflow (when the result is negative).
172      *
173      * CAUTION: This function is deprecated because it requires allocating memory for the error
174      * message unnecessarily. For custom revert reasons use {trySub}.
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      *
180      * - Subtraction cannot overflow.
181      */
182     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         unchecked {
184             require(b <= a, errorMessage);
185             return a - b;
186         }
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `%` operator. This function uses a `revert`
194      * opcode (which leaves remaining gas untouched) while Solidity uses an
195      * invalid opcode to revert (consuming all remaining gas).
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         unchecked {
207             require(b > 0, errorMessage);
208             return a / b;
209         }
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * reverting with custom message when dividing by zero.
215      *
216      * CAUTION: This function is deprecated because it requires allocating memory for the error
217      * message unnecessarily. For custom revert reasons use {tryMod}.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         unchecked {
229             require(b > 0, errorMessage);
230             return a % b;
231         }
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
254         // This method relies on extcodesize, which returns 0 for contracts in
255         // construction, since the code is only stored at the end of the
256         // constructor execution.
257 
258         uint256 size;
259         // solhint-disable-next-line no-inline-assembly
260         assembly { size := extcodesize(account) }
261         return size > 0;
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
317         return functionCallWithValue(target, data, 0, errorMessage);
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
343         require(isContract(target), "Address: call to non-contract");
344 
345         // solhint-disable-next-line avoid-low-level-calls
346         (bool success, bytes memory returndata) = target.call{ value: value }(data);
347         return _verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a static call.
353      *
354      * _Available since v3.3._
355      */
356     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
357         return functionStaticCall(target, data, "Address: low-level static call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
367         require(isContract(target), "Address: static call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.staticcall(data);
371         return _verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a delegate call.
377      *
378      * _Available since v3.4._
379      */
380     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
381         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a delegate call.
387      *
388      * _Available since v3.4._
389      */
390     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
391         require(isContract(target), "Address: delegate call to non-contract");
392 
393         // solhint-disable-next-line avoid-low-level-calls
394         (bool success, bytes memory returndata) = target.delegatecall(data);
395         return _verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 // solhint-disable-next-line no-inline-assembly
407                 assembly {
408                     let returndata_size := mload(returndata)
409                     revert(add(32, returndata), returndata_size)
410                 }
411             } else {
412                 revert(errorMessage);
413             }
414         }
415     }
416 }
417 
418 abstract contract Ownable is Context {
419     address private _owner;
420 
421     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
422 
423     /**
424      * @dev Initializes the contract setting the deployer as the initial owner.
425      */
426     constructor () {
427         address msgSender = _msgSender();
428         _owner = msgSender;
429         emit OwnershipTransferred(address(0), msgSender);
430     }
431 
432     /**
433      * @dev Returns the address of the current owner.
434      */
435     function owner() public view virtual returns (address) {
436         return _owner;
437     }
438 
439     /**
440      * @dev Throws if called by any account other than the owner.
441      */
442     modifier onlyOwner() {
443         require(owner() == _msgSender(), "Ownable: caller is not the owner");
444         _;
445     }
446 
447     /**
448      * @dev Leaves the contract without owner. It will not be possible to call
449      * `onlyOwner` functions anymore. Can only be called by the current owner.
450      *
451      * NOTE: Renouncing ownership will leave the contract without an owner,
452      * thereby removing any functionality that is only available to the owner.
453      */
454     function renounceOwnership() public virtual onlyOwner {
455         emit OwnershipTransferred(_owner, address(0));
456         _owner = address(0);
457     }
458 
459     /**
460      * @dev Transfers ownership of the contract to a new account (`newOwner`).
461      * Can only be called by the current owner.
462      */
463     function transferOwnership(address newOwner) public virtual onlyOwner {
464         require(newOwner != address(0), "Ownable: new owner is the zero address");
465         emit OwnershipTransferred(_owner, newOwner);
466         _owner = newOwner;
467     }
468 }  
469 
470 interface IUniswapV2Factory {
471     function createPair(address tokenA, address tokenB) external returns (address pair);
472 }
473 
474 interface IUniswapV2Router02 {
475     function swapExactTokensForETHSupportingFeeOnTransferTokens(
476         uint amountIn,
477         uint amountOutMin,
478         address[] calldata path,
479         address to,
480         uint deadline
481     ) external;
482     function factory() external pure returns (address);
483     function WETH() external pure returns (address);
484     function addLiquidityETH(
485         address token,
486         uint amountTokenDesired,
487         uint amountTokenMin,
488         uint amountETHMin,
489         address to,
490         uint deadline
491     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
492 }
493 
494 contract POKA is Context, IERC20, Ownable {
495     using SafeMath for uint256;
496     using Address for address;
497 
498     mapping (address => uint256) private _rOwned;
499     mapping (address => uint256) private _tOwned;
500     mapping (address => mapping (address => uint256)) private _allowances;
501     mapping (address => bool) private _isExcludedFromFee;
502     mapping (address => bool) private _isExcluded;
503     mapping (address => uint) private cooldown;
504 
505     address[] private _excluded;
506     uint256 private constant MAX = ~uint256(0);
507     uint256 private constant _tTotal = 1e15 * 1e9;
508     uint256 private _rTotal = (MAX - (MAX % _tTotal));
509     uint256 private _tFeeTotal;
510     string private constant _name = "Pokadex";
511     string private constant _symbol = 'POKA';
512     uint8 private constant _decimals = 9;
513     uint256 private _taxFee = 2;
514     uint256 private _teamFee = 8;
515     uint256 private _previousTaxFee = _taxFee;
516     uint256 private _previousteamFee = _teamFee;
517     address payable private _marketingWalletAddress;
518     IUniswapV2Router02 private uniswapV2Router;
519     address private uniswapV2Pair;
520     bool private tradingOpen;
521     bool private inSwap = false;
522     bool private swapEnabled = false;
523     bool private cooldownEnabled = false;
524     uint256 private _maxTxAmount = _tTotal;
525 
526     event MaxTxAmountUpdated(uint _maxTxAmount);
527 
528     modifier lockTheSwap {
529         inSwap = true;
530         _;
531         inSwap = false;
532     }
533 
534     constructor ()  {
535         _marketingWalletAddress = payable(0xaAADE0E8458734a37Eb262902c9F94Fde92db431);
536         _rOwned[_msgSender()] = _rTotal;
537         _isExcludedFromFee[owner()] = true;
538         _isExcludedFromFee[address(this)] = true;
539         _isExcludedFromFee[_marketingWalletAddress] = true;
540         emit Transfer(address(0), _msgSender(), _tTotal);
541     }
542 
543     function name() public pure returns (string memory) {
544         return _name;
545     }
546 
547     function symbol() public pure returns (string memory) {
548         return _symbol;
549     }
550 
551     function decimals() public pure returns (uint8) {
552         return _decimals;
553     }
554 
555     function totalSupply() public pure override returns (uint256) {
556         return _tTotal;
557     }
558 
559     function balanceOf(address account) public view override returns (uint256) {
560         if (_isExcluded[account]) return _tOwned[account];
561         return tokenFromReflection(_rOwned[account]);
562     }
563 
564     function transfer(address recipient, uint256 amount) public override returns (bool) {
565         _transfer(_msgSender(), recipient, amount);
566         return true;
567     }
568 
569     function allowance(address owner, address spender) public view override returns (uint256) {
570         return _allowances[owner][spender];
571     }
572 
573     function approve(address spender, uint256 amount) public override returns (bool) {
574         _approve(_msgSender(), spender, amount);
575         return true;
576     }
577 
578     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
579         _transfer(sender, recipient, amount);
580         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
581         return true;
582     }
583 
584     function setCooldownEnabled(bool onoff) external onlyOwner() {
585         cooldownEnabled = onoff;
586     }
587 
588     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
589         require(rAmount <= _rTotal, "Amount must be less than total reflections");
590         uint256 currentRate =  _getRate();
591         return rAmount.div(currentRate);
592     }
593 
594     function removeAllFee() private {
595         if(_taxFee == 0 && _teamFee == 0) return;
596         _previousTaxFee = _taxFee;
597         _previousteamFee = _teamFee;
598         _taxFee = 0;
599         _teamFee = 0;
600     }
601     
602     function restoreAllFee() private {
603         _taxFee = _previousTaxFee;
604         _teamFee = _previousteamFee;
605     }
606 
607     function _approve(address owner, address spender, uint256 amount) private {
608         require(owner != address(0), "ERC20: approve from the zero address");
609         require(spender != address(0), "ERC20: approve to the zero address");
610         _allowances[owner][spender] = amount;
611         emit Approval(owner, spender, amount);
612     }
613 
614     function _transfer(address from, address to, uint256 amount) private {
615         require(from != address(0), "ERC20: transfer from the zero address");
616         require(to != address(0), "ERC20: transfer to the zero address");
617         require(amount > 0, "Transfer amount must be greater than zero");
618         
619         if (from != owner() && to != owner()) {
620             if (cooldownEnabled) {
621                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
622                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
623                 }
624             }
625             require(amount <= _maxTxAmount);
626 
627             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
628                 require(cooldown[to] < block.timestamp);
629                 cooldown[to] = block.timestamp + (30 seconds);
630             }
631             uint256 contractTokenBalance = balanceOf(address(this));
632             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
633                 swapTokensForEth(contractTokenBalance);
634                 uint256 contractETHBalance = address(this).balance;
635                 if(contractETHBalance > 0) {
636                     sendETHToFee(address(this).balance);
637                 }
638             }
639         }
640         bool takeFee = true;
641 
642         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
643             takeFee = false;
644         }
645 		
646         _tokenTransfer(from,to,amount,takeFee);
647     }
648 
649     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
650         address[] memory path = new address[](2);
651         path[0] = address(this);
652         path[1] = uniswapV2Router.WETH();
653         _approve(address(this), address(uniswapV2Router), tokenAmount);
654         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
655             tokenAmount,
656             0,
657             path,
658             address(this),
659             block.timestamp
660         );
661     }
662         
663     function sendETHToFee(uint256 amount) private {
664         _marketingWalletAddress.transfer(amount.div(2));
665     }
666     
667     function manualswap() external {
668         require(_msgSender() == _marketingWalletAddress);
669         uint256 contractBalance = balanceOf(address(this));
670         swapTokensForEth(contractBalance);
671     }
672     
673     function manualsend() external {
674         require(_msgSender() == _marketingWalletAddress);
675         uint256 contractETHBalance = address(this).balance;
676         sendETHToFee(contractETHBalance);
677     }
678         
679     function openTrading() external onlyOwner() {
680         require(!tradingOpen,"trading is already open");
681         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
682         uniswapV2Router = _uniswapV2Router;
683         _approve(address(this), address(uniswapV2Router), _tTotal);
684         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
685         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
686         swapEnabled = true;
687         cooldownEnabled = true;
688         _maxTxAmount = 5e12 * 1e9;
689         tradingOpen = true;
690         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
691     }
692         
693     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
694         if(!takeFee)
695             removeAllFee();
696         if (_isExcluded[sender] && !_isExcluded[recipient]) {
697             _transferFromExcluded(sender, recipient, amount);
698         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
699             _transferToExcluded(sender, recipient, amount);
700         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
701             _transferBothExcluded(sender, recipient, amount);
702         } else {
703             _transferStandard(sender, recipient, amount);
704         }
705         if(!takeFee)
706             restoreAllFee();
707     }
708 
709     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
710         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
711         _rOwned[sender] = _rOwned[sender].sub(rAmount);
712         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
713         _takeTeam(tTeam); 
714         _reflectFee(rFee, tFee);
715         emit Transfer(sender, recipient, tTransferAmount);
716     }
717 
718     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
719         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
720         _rOwned[sender] = _rOwned[sender].sub(rAmount);
721         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
722         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
723         _takeTeam(tTeam);           
724         _reflectFee(rFee, tFee);
725         emit Transfer(sender, recipient, tTransferAmount);
726     }
727 
728     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
729         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
730         _tOwned[sender] = _tOwned[sender].sub(tAmount);
731         _rOwned[sender] = _rOwned[sender].sub(rAmount);
732         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
733         _takeTeam(tTeam);   
734         _reflectFee(rFee, tFee);
735         emit Transfer(sender, recipient, tTransferAmount);
736     }
737 
738     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
739         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
740         _tOwned[sender] = _tOwned[sender].sub(tAmount);
741         _rOwned[sender] = _rOwned[sender].sub(rAmount);
742         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
743         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
744         _takeTeam(tTeam);         
745         _reflectFee(rFee, tFee);
746         emit Transfer(sender, recipient, tTransferAmount);
747     }
748 
749     function _takeTeam(uint256 tTeam) private {
750         uint256 currentRate =  _getRate();
751         uint256 rTeam = tTeam.mul(currentRate);
752         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
753         if(_isExcluded[address(this)])
754             _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
755     }
756 
757     function _reflectFee(uint256 rFee, uint256 tFee) private {
758         _rTotal = _rTotal.sub(rFee);
759         _tFeeTotal = _tFeeTotal.add(tFee);
760     }
761 
762     receive() external payable {}
763 
764     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
765         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
766         uint256 currentRate =  _getRate();
767         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
768         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
769     }
770 
771     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
772         uint256 tFee = tAmount.mul(taxFee).div(100);
773         uint256 tTeam = tAmount.mul(TeamFee).div(100);
774         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
775         return (tTransferAmount, tFee, tTeam);
776     }
777 
778     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
779         uint256 rAmount = tAmount.mul(currentRate);
780         uint256 rFee = tFee.mul(currentRate);
781         uint256 rTeam = tTeam.mul(currentRate);
782         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
783         return (rAmount, rTransferAmount, rFee);
784     }
785 
786     function _getRate() private view returns(uint256) {
787         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
788         return rSupply.div(tSupply);
789     }
790 
791     function _getCurrentSupply() private view returns(uint256, uint256) {
792         uint256 rSupply = _rTotal;
793         uint256 tSupply = _tTotal;      
794         for (uint256 i = 0; i < _excluded.length; i++) {
795             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
796             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
797             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
798         }
799         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
800         return (rSupply, tSupply);
801     }
802         
803     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
804         require(maxTxPercent > 0, "Amount must be greater than 0");
805         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
806         emit MaxTxAmountUpdated(_maxTxAmount);
807     }
808 }