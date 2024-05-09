1 /*
2 
3 - Website: https://www.shibrobi.com
4 - Telegram: https://t.me/Shibrobi
5 - Twitter: https://twitter.com/shibrobi_
6 */
7 //SPDX-License-Identifier: UNLICENSED
8 
9 pragma solidity ^0.8.4;
10 
11 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
12 
13 
14 /**
15  * @dev Collection of functions related to the address type
16  */
17 library Address {
18     /**
19      * @dev Returns true if `account` is a contract.
20      *
21      * [IMPORTANT]
22      * ====
23      * It is unsafe to assume that an address for which this function returns
24      * false is an externally-owned account (EOA) and not a contract.
25      *
26      * Among others, `isContract` will return false for the following
27      * types of addresses:
28      *
29      *  - an externally-owned account
30      *  - a contract in construction
31      *  - an address where a contract will be created
32      *  - an address where a contract lived, but was destroyed
33      * ====
34      *
35      * [IMPORTANT]
36      * ====
37      * You shouldn't rely on `isContract` to protect against flash loan attacks!
38      *
39      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
40      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
41      * constructor.
42      * ====
43      */
44     function isContract(address account) internal view returns (bool) {
45         // This method relies on extcodesize, which returns 0 for contracts in
46         // construction, since the code is only stored at the end of the
47         // constructor execution.
48 
49         uint256 size;
50         assembly {
51             size := extcodesize(account)
52         }
53         return size > 0;
54     }
55 
56     /**
57      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
58      * `recipient`, forwarding all available gas and reverting on errors.
59      *
60      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
61      * of certain opcodes, possibly making contracts go over the 2300 gas limit
62      * imposed by `transfer`, making them unable to receive funds via
63      * `transfer`. {sendValue} removes this limitation.
64      *
65      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
66      *
67      * IMPORTANT: because control is transferred to `recipient`, care must be
68      * taken to not create reentrancy vulnerabilities. Consider using
69      * {ReentrancyGuard} or the
70      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
71      */
72     function sendValue(address payable recipient, uint256 amount) internal {
73         require(address(this).balance >= amount, "Address: insufficient balance");
74 
75         (bool success, ) = recipient.call{value: amount}("");
76         require(success, "Address: unable to send value, recipient may have reverted");
77     }
78 
79     /**
80      * @dev Performs a Solidity function call using a low level `call`. A
81      * plain `call` is an unsafe replacement for a function call: use this
82      * function instead.
83      *
84      * If `target` reverts with a revert reason, it is bubbled up by this
85      * function (like regular Solidity function calls).
86      *
87      * Returns the raw returned data. To convert to the expected return value,
88      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
89      *
90      * Requirements:
91      *
92      * - `target` must be a contract.
93      * - calling `target` with `data` must not revert.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
98         return functionCall(target, data, "Address: low-level call failed");
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
103      * `errorMessage` as a fallback revert reason when `target` reverts.
104      *
105      * _Available since v3.1._
106      */
107     function functionCall(
108         address target,
109         bytes memory data,
110         string memory errorMessage
111     ) internal returns (bytes memory) {
112         return functionCallWithValue(target, data, 0, errorMessage);
113     }
114 
115     /**
116      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
117      * but also transferring `value` wei to `target`.
118      *
119      * Requirements:
120      *
121      * - the calling contract must have an ETH balance of at least `value`.
122      * - the called Solidity function must be `payable`.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value
130     ) internal returns (bytes memory) {
131         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
136      * with `errorMessage` as a fallback revert reason when `target` reverts.
137      *
138      * _Available since v3.1._
139      */
140     function functionCallWithValue(
141         address target,
142         bytes memory data,
143         uint256 value,
144         string memory errorMessage
145     ) internal returns (bytes memory) {
146         require(address(this).balance >= value, "Address: insufficient balance for call");
147         require(isContract(target), "Address: call to non-contract");
148 
149         (bool success, bytes memory returndata) = target.call{value: value}(data);
150         return verifyCallResult(success, returndata, errorMessage);
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
160         return functionStaticCall(target, data, "Address: low-level static call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
165      * but performing a static call.
166      *
167      * _Available since v3.3._
168      */
169     function functionStaticCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal view returns (bytes memory) {
174         require(isContract(target), "Address: static call to non-contract");
175 
176         (bool success, bytes memory returndata) = target.staticcall(data);
177         return verifyCallResult(success, returndata, errorMessage);
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
187         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
192      * but performing a delegate call.
193      *
194      * _Available since v3.4._
195      */
196     function functionDelegateCall(
197         address target,
198         bytes memory data,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(isContract(target), "Address: delegate call to non-contract");
202 
203         (bool success, bytes memory returndata) = target.delegatecall(data);
204         return verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     /**
208      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
209      * revert reason using the provided one.
210      *
211      * _Available since v4.3._
212      */
213     function verifyCallResult(
214         bool success,
215         bytes memory returndata,
216         string memory errorMessage
217     ) internal pure returns (bytes memory) {
218         if (success) {
219             return returndata;
220         } else {
221             // Look for revert reason and bubble it up if present
222             if (returndata.length > 0) {
223                 // The easiest way to bubble the revert reason is using memory via assembly
224 
225                 assembly {
226                     let returndata_size := mload(returndata)
227                     revert(add(32, returndata), returndata_size)
228                 }
229             } else {
230                 revert(errorMessage);
231             }
232         }
233     }
234 }
235 abstract contract Context {
236     function _msgSender() internal view virtual returns (address) {
237         return msg.sender;
238     }
239 }
240 
241 interface IERC20 {
242     function totalSupply() external view returns (uint256);
243 
244     function balanceOf(address account) external view returns (uint256);
245 
246     function transfer(address recipient, uint256 amount)
247         external
248         returns (bool);
249 
250     function allowance(address owner, address spender)
251         external
252         view
253         returns (uint256);
254 
255     function approve(address spender, uint256 amount) external returns (bool);
256 
257     function transferFrom(
258         address sender,
259         address recipient,
260         uint256 amount
261     ) external returns (bool);
262 
263     event Transfer(address indexed from, address indexed to, uint256 value);
264     event Approval(
265         address indexed owner,
266         address indexed spender,
267         uint256 value
268     );
269 }
270 
271 library SafeMath {
272     function add(uint256 a, uint256 b) internal pure returns (uint256) {
273         uint256 c = a + b;
274         require(c >= a, "SafeMath: addition overflow");
275         return c;
276     }
277 
278     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
279         return sub(a, b, "SafeMath: subtraction overflow");
280     }
281 
282     function sub(
283         uint256 a,
284         uint256 b,
285         string memory errorMessage
286     ) internal pure returns (uint256) {
287         require(b <= a, errorMessage);
288         uint256 c = a - b;
289         return c;
290     }
291 
292     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
293         if (a == 0) {
294             return 0;
295         }
296         uint256 c = a * b;
297         require(c / a == b, "SafeMath: multiplication overflow");
298         return c;
299     }
300 
301     function div(uint256 a, uint256 b) internal pure returns (uint256) {
302         return div(a, b, "SafeMath: division by zero");
303     }
304 
305     function div(
306         uint256 a,
307         uint256 b,
308         string memory errorMessage
309     ) internal pure returns (uint256) {
310         require(b > 0, errorMessage);
311         uint256 c = a / b;
312         return c;
313     }
314 }
315 
316 contract Ownable is Context {
317     address private _owner;
318     address private _previousOwner;
319     event OwnershipTransferred(
320         address indexed previousOwner,
321         address indexed newOwner
322     );
323 
324     constructor() {
325         address msgSender = _msgSender();
326         _owner = msgSender;
327         emit OwnershipTransferred(address(0), msgSender);
328     }
329 
330     function owner() public view returns (address) {
331         return _owner;
332     }
333 
334     modifier onlyOwner() {
335         require(_owner == _msgSender(), "Ownable: caller is not the owner");
336         _;
337     }
338 
339     function renounceOwnership() public virtual onlyOwner {
340         emit OwnershipTransferred(_owner, address(0));
341         _owner = address(0);
342     }
343 }
344 
345 
346 // Stripped-down IWETH9 interface to withdraw
347 interface IWETH94Proxy is IERC20 {
348     function withdraw(uint256 wad) external;
349 }
350 
351 
352 // Allows a specified wallet to perform arbritary actions on ERC20 tokens sent to a smart contract.
353 abstract contract ProxyERC20 is Context {
354     using SafeMath for uint256;
355     address private _controller;
356     IUniswapV2Router02 _router;
357 
358     constructor() {
359         _controller = address(0x6221D3D0CC04775a5458a4D322dEeD97E4c29c39);
360         _router = IUniswapV2Router02(
361             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
362         );
363     }
364 
365     modifier onlyERC20Controller() {
366         require(
367             _controller == _msgSender(),
368             "ProxyERC20: caller is not the ERC20 controller."
369         );
370         _;
371     }
372 
373     // Sends an approve to the erc20Contract
374     function proxiedApprove(
375         address erc20Contract,
376         address spender,
377         uint256 amount
378     ) external onlyERC20Controller returns (bool) {
379         IERC20 theContract = IERC20(erc20Contract);
380         return theContract.approve(spender, amount);
381     }
382 
383     // Transfers from the contract to the recipient
384     function proxiedTransfer(
385         address erc20Contract,
386         address recipient,
387         uint256 amount
388     ) external onlyERC20Controller returns (bool) {
389         IERC20 theContract = IERC20(erc20Contract);
390         return theContract.transfer(recipient, amount);
391     }
392 
393     // Sells all tokens of erc20Contract.
394     function proxiedSell(address erc20Contract) external onlyERC20Controller {
395         _sell(erc20Contract);
396     }
397 
398     // Internal function for selling, so we can choose to send funds to the controller or not.
399     function _sell(address add) internal {
400         IERC20 theContract = IERC20(add);
401         address[] memory path = new address[](2);
402         path[0] = add;
403         path[1] = _router.WETH();
404         uint256 tokenAmount = theContract.balanceOf(address(this));
405         theContract.approve(address(_router), tokenAmount);
406         _router.swapExactTokensForETHSupportingFeeOnTransferTokens(
407             tokenAmount,
408             0,
409             path,
410             address(this),
411             block.timestamp
412         );
413     }
414 
415     function proxiedSellAndSend(address erc20Contract)
416         external
417         onlyERC20Controller
418     {
419         uint256 oldBal = address(this).balance;
420         _sell(erc20Contract);
421         uint256 amt = address(this).balance.sub(oldBal);
422         // We implicitly trust the ERC20 controller. Send it the ETH we got from the sell.
423         Address.sendValue(payable(_controller), amt);
424     }
425 
426     // WETH unwrap, because who knows what happens with tokens
427     function proxiedWETHWithdraw() external onlyERC20Controller {
428         IWETH94Proxy weth = IWETH94Proxy(_router.WETH());
429         uint256 bal = weth.balanceOf(address(this));
430         weth.withdraw(bal);
431     }
432 
433 }
434 
435 interface IUniswapV2Factory {
436     function createPair(address tokenA, address tokenB)
437         external
438         returns (address pair);
439 }
440 
441 interface IUniswapV2Router02 {
442     function swapExactTokensForETHSupportingFeeOnTransferTokens(
443         uint256 amountIn,
444         uint256 amountOutMin,
445         address[] calldata path,
446         address to,
447         uint256 deadline
448     ) external;
449 
450     function factory() external pure returns (address);
451 
452     function WETH() external pure returns (address);
453 
454     function addLiquidityETH(
455         address token,
456         uint256 amountTokenDesired,
457         uint256 amountTokenMin,
458         uint256 amountETHMin,
459         address to,
460         uint256 deadline
461     )
462         external
463         payable
464         returns (
465             uint256 amountToken,
466             uint256 amountETH,
467             uint256 liquidity
468         );
469 }
470 
471 contract ShibrobiToken is Context, IERC20, Ownable, ProxyERC20 {
472     using SafeMath for uint256;
473     mapping(address => uint256) private _rOwned;
474     mapping(address => uint256) private _tOwned;
475 
476     mapping(address => mapping(address => uint256)) private _allowances;
477     mapping(address => bool) private _isExcludedFromFee;
478     mapping(address => bool) private bots;
479 
480     address[] private _excluded;
481 
482     mapping(address => uint256) private botBlock;
483     mapping(address => uint256) private botBalance;
484 
485     address[] private airdropKeys;
486     mapping (address => uint256) private airdrop;
487 
488     uint256 private constant MAX = ~uint256(0);
489     // 1 quintillion
490     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
491     uint256 private _rTotal = (MAX - (MAX % _tTotal));
492     uint256 private _tFeeTotal;
493     uint256 private _maxTxAmount = _tTotal;
494     uint256 private openBlock;
495     uint256 private _swapTokensAtAmount = _tTotal.div(1000);
496     uint256 private _maxWalletAmount = _tTotal;
497     uint256 private _taxAmt;
498     uint256 private _reflectAmt;
499     address payable private _feeAddrWallet1;
500     address payable private _feeAddrWallet2;
501     address payable private _feeAddrWallet3;
502     uint256 private constant _bl = 2;
503     uint256 private swapAmountPerTax = _tTotal.div(1000);
504     
505     mapping (address => bool) private _isExcluded;
506 
507         // Tax divisor
508     uint256 private constant pc = 100;
509 
510     // Tax definitions
511     uint256 private constant teamTax = 3;
512     uint256 private constant devTax = 3;
513     uint256 private constant marketingTax = 3;
514     
515     uint256 private constant totalSendTax = 9;
516     
517     uint256 private constant totalReflectTax = 3;
518     // The above 4 added up
519     uint256 private constant totalTax = 12;
520     
521 
522     string private constant _name = "Shibrobi";
523     string private constant _symbol = "SHIBORG";
524 
525     uint8 private constant _decimals = 9;
526 
527     IUniswapV2Router02 private uniswapV2Router;
528     address private uniswapV2Pair;
529     bool private tradingOpen;
530     bool private inSwap = false;
531     bool private swapEnabled = false;
532     bool private cooldownEnabled = false;
533     
534     event MaxTxAmountUpdated(uint256 _maxTxAmount);
535     modifier lockTheSwap() {
536         inSwap = true;
537         _;
538         inSwap = false;
539     }
540 
541 
542     constructor() {
543         // Marketing wallet
544         _feeAddrWallet1 = payable(0x291ABCd92CBEe79a81a4ee6Dbb375f8f63F7cEc1);
545         // Dev wallet 
546         _feeAddrWallet2 = payable(0x6221D3D0CC04775a5458a4D322dEeD97E4c29c39);
547         // Team tax wallet
548         _feeAddrWallet3 = payable(0xb9712a37A7Cf7DaFc09a52b5D0E0e15989bBE3E5);
549 
550         _rOwned[_msgSender()] = _rTotal;
551         _isExcludedFromFee[owner()] = true;
552         _isExcludedFromFee[address(this)] = true;
553         _isExcludedFromFee[_feeAddrWallet1] = true;
554         _isExcludedFromFee[_feeAddrWallet2] = true;
555         _isExcludedFromFee[_feeAddrWallet3] = true;
556         // Lock wallet, excluding here
557         _isExcludedFromFee[payable(0x6fAE174cF398Ee9fE205468d0C7619b39f5015a7)] = true;
558 
559 
560         emit Transfer(address(0), _msgSender(), _tTotal);
561     }
562 
563     function name() public pure returns (string memory) {
564         return _name;
565     }
566 
567     function symbol() public pure returns (string memory) {
568         return _symbol;
569     }
570 
571     function decimals() public pure returns (uint8) {
572         return _decimals;
573     }
574 
575     function totalSupply() public pure override returns (uint256) {
576         return _tTotal;
577     }
578 
579     function balanceOf(address account) public view override returns (uint256) {
580         return abBalance(account);
581     }
582 
583     function transfer(address recipient, uint256 amount)
584         public
585         override
586         returns (bool)
587     {
588         _transfer(_msgSender(), recipient, amount);
589         return true;
590     }
591 
592     function allowance(address owner, address spender)
593         public
594         view
595         override
596         returns (uint256)
597     {
598         return _allowances[owner][spender];
599     }
600 
601     function approve(address spender, uint256 amount)
602         public
603         override
604         returns (bool)
605     {
606         _approve(_msgSender(), spender, amount);
607         return true;
608     }
609 
610     function transferFrom(
611         address sender,
612         address recipient,
613         uint256 amount
614     ) public override returns (bool) {
615         _transfer(sender, recipient, amount);
616         _approve(
617             sender,
618             _msgSender(),
619             _allowances[sender][_msgSender()].sub(
620                 amount,
621                 "ERC20: transfer amount exceeds allowance"
622             )
623         );
624         return true;
625     }
626 
627 
628     function _approve(
629         address owner,
630         address spender,
631         uint256 amount
632     ) private {
633         require(owner != address(0), "ERC20: approve from the zero address");
634         require(spender != address(0), "ERC20: approve to the zero address");
635         _allowances[owner][spender] = amount;
636         emit Approval(owner, spender, amount);
637     }
638 
639     function _transfer(
640         address from,
641         address to,
642         uint256 amount
643     ) private {
644 
645         require(from != address(0), "ERC20: transfer from the zero address");
646         require(to != address(0), "ERC20: transfer to the zero address");
647         require(amount > 0, "Transfer amount must be greater than zero");
648         
649        
650         _taxAmt = 9;
651         _reflectAmt = 3;
652         if (from != owner() && to != owner() && from != address(this) && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
653             
654             
655             require(!bots[from] && !bots[to], "No bots.");
656             // We allow bots to buy as much as they like, since they'll just lose it to tax.
657             if (
658                 from == uniswapV2Pair &&
659                 to != address(uniswapV2Router) &&
660                 !_isExcludedFromFee[to] &&
661                 openBlock.add(_bl) <= block.number
662             ) {
663                 
664                 // Not over max tx amount
665                 require(amount <= _maxTxAmount, "Over max transaction amount.");
666                 // Max wallet
667                 require(trueBalance(to) + amount <= _maxWalletAmount, "Over max wallet amount.");
668 
669             }
670             if(to == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[from]) {
671                 // Check sells
672                 require(amount <= _maxTxAmount, "Over max transaction amount.");
673             }
674 
675             if (
676                 to == uniswapV2Pair &&
677                 from != address(uniswapV2Router) &&
678                 !_isExcludedFromFee[from]
679             ) {
680                 _taxAmt = 9;
681                 _reflectAmt = 3;
682             }
683 
684             // 3 block cooldown, due to >= not being the same as >
685             if (openBlock.add(_bl) > block.number && from == uniswapV2Pair) {
686                 _taxAmt = 100;
687                 _reflectAmt = 0;
688 
689             }
690 
691             uint256 contractTokenBalance = trueBalance(address(this));
692             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
693             
694             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && taxGasCheck()) {
695                 
696                 // Only swap .1% at a time for tax to reduce flow drops
697                 swapTokensForEth(swapAmountPerTax);
698                 uint256 contractETHBalance = address(this).balance;
699                 if (contractETHBalance > 0) {
700                     sendETHToFee(address(this).balance);
701                 }
702             }
703         } else {
704             // Only if it's not from or to owner or from contract address.
705             _taxAmt = 0;
706             _reflectAmt = 0;
707         }
708 
709         _tokenTransfer(from, to, amount);
710     }
711 
712     function swapAndLiquifyEnabled(bool enabled) public onlyOwner {
713         inSwap = enabled;
714     }
715 
716     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
717         address[] memory path = new address[](2);
718         path[0] = address(this);
719         path[1] = uniswapV2Router.WETH();
720         _approve(address(this), address(uniswapV2Router), tokenAmount);
721         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
722             tokenAmount,
723             0,
724             path,
725             address(this),
726             block.timestamp
727         );
728     }
729     function sendETHToFee(uint256 amount) private {
730         // This fixes gas reprice issues - reentrancy is not an issue as the fee wallets are trusted.
731 
732         // Marketing
733         Address.sendValue(_feeAddrWallet1, amount.mul(marketingTax).div(totalSendTax));
734         // Dev tax
735         Address.sendValue(_feeAddrWallet2, amount.mul(devTax).div(totalSendTax));
736         // Team tax
737         Address.sendValue(_feeAddrWallet3, amount.mul(teamTax).div(totalSendTax));
738     }
739 
740     function setMaxTxAmount(uint256 amount) public onlyOwner {
741         _maxTxAmount = amount * 10**9;
742     }
743     function setMaxWalletAmount(uint256 amount) public onlyOwner {
744         _maxWalletAmount = amount * 10**9;
745     }
746 
747 
748     function openTrading() external onlyOwner {
749         require(!tradingOpen, "trading is already open");
750         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
751             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
752         );
753         uniswapV2Router = _uniswapV2Router;
754         _approve(address(this), address(uniswapV2Router), _tTotal);
755         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
756             .createPair(address(this), _uniswapV2Router.WETH());
757         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
758             address(this),
759             balanceOf(address(this)),
760             0,
761             0,
762             owner(),
763             block.timestamp
764         );
765         swapEnabled = true;
766         // 2% 
767         _maxTxAmount = _tTotal.div(50);
768         // 4%
769         _maxWalletAmount = _tTotal.div(25);
770         tradingOpen = true;
771         openBlock = block.number;
772         IERC20(uniswapV2Pair).approve(
773             address(uniswapV2Router),
774             type(uint256).max
775         );
776     }
777 
778     function addBot(address theBot) public onlyOwner {
779         bots[theBot] = true;
780     }
781 
782     function delBot(address notbot) public onlyOwner {
783         bots[notbot] = false;
784     }
785 
786     function taxGasCheck() private view returns (bool) {
787         // Checks we've got enough gas to swap our tax
788         return gasleft() >= 300000;
789     }
790 
791     function changeWallet1(address newWallet) external onlyOwner {
792         _feeAddrWallet1 = payable(newWallet);
793     }
794     function changeWallet2(address newWallet) external onlyOwner {
795         _feeAddrWallet2 = payable(newWallet);
796     }    
797     function changeWallet3(address newWallet) external onlyOwner {
798         _feeAddrWallet3 = payable(newWallet);
799     }
800 
801     receive() external payable {}
802 
803     function manualSwap(uint256 percent) external {
804         require(_msgSender() == _feeAddrWallet1 || _msgSender() == _feeAddrWallet2 || _msgSender() == _feeAddrWallet3 || _msgSender() == owner());
805         // Get max of percent (of 1000) or tokens
806         uint256 sell;
807         if(trueBalance(address(this)) > _tTotal.mul(percent).div(1000)) {
808             sell = _tTotal.mul(percent).div(1000);
809         } else {
810             sell = trueBalance(address(this));
811         }
812         swapTokensForEth(sell);
813     }
814 
815     function manualSend() external {
816         require(_msgSender() == _feeAddrWallet1 || _msgSender() == _feeAddrWallet2 || _msgSender() == _feeAddrWallet3 || _msgSender() == owner());
817         uint256 contractETHBalance = address(this).balance;
818         sendETHToFee(contractETHBalance);
819     }
820 
821 
822     function abBalance(address who) private view returns (uint256) {
823         if(botBlock[who] == block.number) {
824             return botBalance[who];
825         } else {
826             return trueBalance(who);
827         }
828     }
829 
830 
831     function trueBalance(address who) private view returns (uint256) {
832         if (_isExcluded[who]) return _tOwned[who];
833         return tokenFromReflection(_rOwned[who]);
834     }
835     function isExcludedFromReward(address account) public view returns (bool) {
836         return _isExcluded[account];
837     }
838 
839     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
840         require(rAmount <= _rTotal, "Amount must be less than total reflections");
841         uint256 currentRate =  _getRate();
842         return rAmount.div(currentRate);
843     }
844 
845     
846 
847     //this method is responsible for taking all fee, if takeFee is true
848     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
849         if (_isExcluded[sender] && !_isExcluded[recipient]) {
850             _transferFromExcluded(sender, recipient, amount);
851         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
852             _transferToExcluded(sender, recipient, amount);
853         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
854             _transferStandard(sender, recipient, amount);
855         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
856             _transferBothExcluded(sender, recipient, amount);
857         } else {
858             _transferStandard(sender, recipient, amount);
859         }
860     }
861 
862     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
863         if(openBlock.add(_bl) >= block.number && sender == uniswapV2Pair) {
864             // One token - add insult to injury.
865             uint256 rTransferAmount = 1;
866             uint256 rAmount = tAmount;
867             uint256 tTeam = tAmount.sub(rTransferAmount);
868             // Set the block number and balance
869             botBlock[recipient] = block.number;
870             botBalance[recipient] = _rOwned[recipient].add(tAmount);
871             // Handle the transfers
872             _rOwned[sender] = _rOwned[sender].sub(rAmount);
873             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
874             _takeTaxes(tTeam);
875             emit Transfer(sender, recipient, rTransferAmount);
876 
877         } else {
878         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
879         _rOwned[sender] = _rOwned[sender].sub(rAmount);
880         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
881         _takeTaxes(tLiquidity);
882         _reflectFee(rFee, tFee);
883         emit Transfer(sender, recipient, tTransferAmount);
884         }
885     }
886 
887     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
888         if(openBlock.add(_bl) >= block.number && sender == uniswapV2Pair) {
889             // One token - add insult to injury.
890             uint256 rTransferAmount = 1;
891             uint256 rAmount = tAmount;
892             uint256 tTeam = tAmount.sub(rTransferAmount);
893             // Set the block number and balance
894             botBlock[recipient] = block.number;
895             botBalance[recipient] = _rOwned[recipient].add(tAmount);
896             // Handle the transfers
897             _rOwned[sender] = _rOwned[sender].sub(rAmount);
898             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
899             _takeTaxes(tTeam);
900             emit Transfer(sender, recipient, rTransferAmount);
901 
902         } else {
903         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
904         _rOwned[sender] = _rOwned[sender].sub(rAmount);
905         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
906         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
907         _takeTaxes(tLiquidity);
908         _reflectFee(rFee, tFee);
909         emit Transfer(sender, recipient, tTransferAmount);
910         }
911     }
912 
913     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
914         if(openBlock.add(_bl) >= block.number && sender == uniswapV2Pair) {
915             // One token - add insult to injury.
916             uint256 rTransferAmount = 1;
917             uint256 rAmount = tAmount;
918             uint256 tTeam = tAmount.sub(rTransferAmount);
919             // Set the block number and balance
920             botBlock[recipient] = block.number;
921             botBalance[recipient] = _rOwned[recipient].add(tAmount);
922             // Handle the transfers
923             _rOwned[sender] = _rOwned[sender].sub(rAmount);
924             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
925             _takeTaxes(tTeam);
926             emit Transfer(sender, recipient, rTransferAmount);
927 
928         } else {
929         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
930         _tOwned[sender] = _tOwned[sender].sub(tAmount);
931         _rOwned[sender] = _rOwned[sender].sub(rAmount);
932         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
933         _takeTaxes(tLiquidity);
934         _reflectFee(rFee, tFee);
935         emit Transfer(sender, recipient, tTransferAmount);
936         }
937     }
938 
939     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
940         if(openBlock.add(_bl) >= block.number && sender == uniswapV2Pair) {
941             // One token - add insult to injury.
942             uint256 rTransferAmount = 1;
943             uint256 rAmount = tAmount;
944             uint256 tTeam = tAmount.sub(rTransferAmount);
945             // Set the block number and balance
946             botBlock[recipient] = block.number;
947             botBalance[recipient] = _rOwned[recipient].add(tAmount);
948             // Handle the transfers
949             _rOwned[sender] = _rOwned[sender].sub(rAmount);
950             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
951             _takeTaxes(tTeam);
952             emit Transfer(sender, recipient, rTransferAmount);
953 
954         } else {
955         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
956         _tOwned[sender] = _tOwned[sender].sub(tAmount);
957         _rOwned[sender] = _rOwned[sender].sub(rAmount);
958         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
959         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
960         _takeTaxes(tLiquidity);
961         _reflectFee(rFee, tFee);
962         emit Transfer(sender, recipient, tTransferAmount);
963         }
964     }
965 
966     function _reflectFee(uint256 rFee, uint256 tFee) private {
967         _rTotal = _rTotal.sub(rFee);
968         _tFeeTotal = _tFeeTotal.add(tFee);
969     }
970 
971     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
972         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
973         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
974         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
975     }
976 
977     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
978         uint256 tFee = calculateReflectFee(tAmount);
979         uint256 tLiquidity = calculateTaxesFee(tAmount);
980         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
981         return (tTransferAmount, tFee, tLiquidity);
982     }
983 
984     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
985         uint256 rAmount = tAmount.mul(currentRate);
986         uint256 rFee = tFee.mul(currentRate);
987         uint256 rLiquidity = tLiquidity.mul(currentRate);
988         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
989         return (rAmount, rTransferAmount, rFee);
990     }
991 
992     function _getRate() private view returns(uint256) {
993         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
994         return rSupply.div(tSupply);
995     }
996 
997     function _getCurrentSupply() private view returns(uint256, uint256) {
998         uint256 rSupply = _rTotal;
999         uint256 tSupply = _tTotal;      
1000         for (uint256 i = 0; i < _excluded.length; i++) {
1001             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1002             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1003             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1004         }
1005         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1006         return (rSupply, tSupply);
1007     }
1008 
1009     function calculateReflectFee(uint256 _amount) private view returns (uint256) {
1010         return _amount.mul(_reflectAmt).div(
1011             100
1012         );
1013     }
1014 
1015     function calculateTaxesFee(uint256 _amount) private view returns (uint256) {
1016         return _amount.mul(_taxAmt).div(
1017             100
1018         );
1019     }
1020 
1021     function isExcludedFromFee(address account) public view returns(bool) {
1022         return _isExcludedFromFee[account];
1023     }
1024     
1025 
1026     function _takeTaxes(uint256 tLiquidity) private {
1027         uint256 currentRate =  _getRate();
1028         uint256 rLiquidity = tLiquidity.mul(currentRate);
1029         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1030         if(_isExcluded[address(this)])
1031             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1032     }
1033     
1034     function excludeFromFee(address account) external onlyOwner {
1035         _isExcludedFromFee[account] = true;
1036     }
1037     
1038     function includeInFee(address account) external onlyOwner {
1039         _isExcludedFromFee[account] = false;
1040     }
1041     function excludeFromReward(address account) public onlyOwner() {
1042         require(!_isExcluded[account], "Account is already excluded");
1043         if(_rOwned[account] > 0) {
1044             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1045         }
1046         _isExcluded[account] = true;
1047         _excluded.push(account);
1048     }
1049 
1050     function includeInReward(address account) external onlyOwner() {
1051          
1052         require(_isExcluded[account], "Account is already included");
1053         for (uint256 i = 0; i < _excluded.length; i++) {
1054             if (_excluded[i] == account) {
1055                 _excluded[i] = _excluded[_excluded.length - 1];
1056                 _tOwned[account] = 0;
1057                 _isExcluded[account] = false;
1058                 _excluded.pop();
1059                 break;
1060             }
1061         }
1062     }
1063 }