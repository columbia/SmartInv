1 /*
2 
3 $$$$$$$$\                      $$\     $$\                 $$$$$$$$\        $$\                           
4 $$  _____|                     $$ |    \__|                \__$$  __|       $$ |                          
5 $$ |      $$\   $$\  $$$$$$\ $$$$$$\   $$\ $$\   $$\          $$ | $$$$$$\  $$ |  $$\  $$$$$$\  $$$$$$$\  
6 $$$$$\    \$$\ $$  |$$  __$$\\_$$  _|  $$ |\$$\ $$  |         $$ |$$  __$$\ $$ | $$  |$$  __$$\ $$  __$$\ 
7 $$  __|    \$$$$  / $$ /  $$ | $$ |    $$ | \$$$$  /          $$ |$$ /  $$ |$$$$$$  / $$$$$$$$ |$$ |  $$ |
8 $$ |       $$  $$<  $$ |  $$ | $$ |$$\ $$ | $$  $$<           $$ |$$ |  $$ |$$  _$$<  $$   ____|$$ |  $$ |
9 $$$$$$$$\ $$  /\$$\ \$$$$$$  | \$$$$  |$$ |$$  /\$$\          $$ |\$$$$$$  |$$ | \$$\ \$$$$$$$\ $$ |  $$ |
10 \________|\__/  \__| \______/   \____/ \__|\__/  \__|         \__| \______/ \__|  \__| \_______|\__|  \__|
11 
12 
13 
14 - Website: https://www.exotixtoken.io
15 - Telegram: https://t.me/exotixtoken
16 - Twitter: https://twitter.com/exotixtoken
17 
18 */
19 //SPDX-License-Identifier: UNLICENSED
20 
21 pragma solidity ^0.8.4;
22 
23 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
24 
25 
26 /**
27  * @dev Collection of functions related to the address type
28  */
29 library Address {
30     /**
31      * @dev Returns true if `account` is a contract.
32      *
33      * [IMPORTANT]
34      * ====
35      * It is unsafe to assume that an address for which this function returns
36      * false is an externally-owned account (EOA) and not a contract.
37      *
38      * Among others, `isContract` will return false for the following
39      * types of addresses:
40      *
41      *  - an externally-owned account
42      *  - a contract in construction
43      *  - an address where a contract will be created
44      *  - an address where a contract lived, but was destroyed
45      * ====
46      *
47      * [IMPORTANT]
48      * ====
49      * You shouldn't rely on `isContract` to protect against flash loan attacks!
50      *
51      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
52      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
53      * constructor.
54      * ====
55      */
56     function isContract(address account) internal view returns (bool) {
57         // This method relies on extcodesize, which returns 0 for contracts in
58         // construction, since the code is only stored at the end of the
59         // constructor execution.
60 
61         uint256 size;
62         assembly {
63             size := extcodesize(account)
64         }
65         return size > 0;
66     }
67 
68     /**
69      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
70      * `recipient`, forwarding all available gas and reverting on errors.
71      *
72      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
73      * of certain opcodes, possibly making contracts go over the 2300 gas limit
74      * imposed by `transfer`, making them unable to receive funds via
75      * `transfer`. {sendValue} removes this limitation.
76      *
77      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
78      *
79      * IMPORTANT: because control is transferred to `recipient`, care must be
80      * taken to not create reentrancy vulnerabilities. Consider using
81      * {ReentrancyGuard} or the
82      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
83      */
84     function sendValue(address payable recipient, uint256 amount) internal {
85         require(address(this).balance >= amount, "Address: insufficient balance");
86 
87         (bool success, ) = recipient.call{value: amount}("");
88         require(success, "Address: unable to send value, recipient may have reverted");
89     }
90 
91     /**
92      * @dev Performs a Solidity function call using a low level `call`. A
93      * plain `call` is an unsafe replacement for a function call: use this
94      * function instead.
95      *
96      * If `target` reverts with a revert reason, it is bubbled up by this
97      * function (like regular Solidity function calls).
98      *
99      * Returns the raw returned data. To convert to the expected return value,
100      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
101      *
102      * Requirements:
103      *
104      * - `target` must be a contract.
105      * - calling `target` with `data` must not revert.
106      *
107      * _Available since v3.1._
108      */
109     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
110         return functionCall(target, data, "Address: low-level call failed");
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
115      * `errorMessage` as a fallback revert reason when `target` reverts.
116      *
117      * _Available since v3.1._
118      */
119     function functionCall(
120         address target,
121         bytes memory data,
122         string memory errorMessage
123     ) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, 0, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but also transferring `value` wei to `target`.
130      *
131      * Requirements:
132      *
133      * - the calling contract must have an ETH balance of at least `value`.
134      * - the called Solidity function must be `payable`.
135      *
136      * _Available since v3.1._
137      */
138     function functionCallWithValue(
139         address target,
140         bytes memory data,
141         uint256 value
142     ) internal returns (bytes memory) {
143         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
148      * with `errorMessage` as a fallback revert reason when `target` reverts.
149      *
150      * _Available since v3.1._
151      */
152     function functionCallWithValue(
153         address target,
154         bytes memory data,
155         uint256 value,
156         string memory errorMessage
157     ) internal returns (bytes memory) {
158         require(address(this).balance >= value, "Address: insufficient balance for call");
159         require(isContract(target), "Address: call to non-contract");
160 
161         (bool success, bytes memory returndata) = target.call{value: value}(data);
162         return verifyCallResult(success, returndata, errorMessage);
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
167      * but performing a static call.
168      *
169      * _Available since v3.3._
170      */
171     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
172         return functionStaticCall(target, data, "Address: low-level static call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
177      * but performing a static call.
178      *
179      * _Available since v3.3._
180      */
181     function functionStaticCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal view returns (bytes memory) {
186         require(isContract(target), "Address: static call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.staticcall(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but performing a delegate call.
195      *
196      * _Available since v3.4._
197      */
198     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
199         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
204      * but performing a delegate call.
205      *
206      * _Available since v3.4._
207      */
208     function functionDelegateCall(
209         address target,
210         bytes memory data,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(isContract(target), "Address: delegate call to non-contract");
214 
215         (bool success, bytes memory returndata) = target.delegatecall(data);
216         return verifyCallResult(success, returndata, errorMessage);
217     }
218 
219     /**
220      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
221      * revert reason using the provided one.
222      *
223      * _Available since v4.3._
224      */
225     function verifyCallResult(
226         bool success,
227         bytes memory returndata,
228         string memory errorMessage
229     ) internal pure returns (bytes memory) {
230         if (success) {
231             return returndata;
232         } else {
233             // Look for revert reason and bubble it up if present
234             if (returndata.length > 0) {
235                 // The easiest way to bubble the revert reason is using memory via assembly
236 
237                 assembly {
238                     let returndata_size := mload(returndata)
239                     revert(add(32, returndata), returndata_size)
240                 }
241             } else {
242                 revert(errorMessage);
243             }
244         }
245     }
246 }
247 abstract contract Context {
248     function _msgSender() internal view virtual returns (address) {
249         return msg.sender;
250     }
251 }
252 
253 interface IERC20 {
254     function totalSupply() external view returns (uint256);
255 
256     function balanceOf(address account) external view returns (uint256);
257 
258     function transfer(address recipient, uint256 amount)
259         external
260         returns (bool);
261 
262     function allowance(address owner, address spender)
263         external
264         view
265         returns (uint256);
266 
267     function approve(address spender, uint256 amount) external returns (bool);
268 
269     function transferFrom(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) external returns (bool);
274 
275     event Transfer(address indexed from, address indexed to, uint256 value);
276     event Approval(
277         address indexed owner,
278         address indexed spender,
279         uint256 value
280     );
281 }
282 
283 library SafeMath {
284     function add(uint256 a, uint256 b) internal pure returns (uint256) {
285         uint256 c = a + b;
286         require(c >= a, "SafeMath: addition overflow");
287         return c;
288     }
289 
290     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
291         return sub(a, b, "SafeMath: subtraction overflow");
292     }
293 
294     function sub(
295         uint256 a,
296         uint256 b,
297         string memory errorMessage
298     ) internal pure returns (uint256) {
299         require(b <= a, errorMessage);
300         uint256 c = a - b;
301         return c;
302     }
303 
304     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
305         if (a == 0) {
306             return 0;
307         }
308         uint256 c = a * b;
309         require(c / a == b, "SafeMath: multiplication overflow");
310         return c;
311     }
312 
313     function div(uint256 a, uint256 b) internal pure returns (uint256) {
314         return div(a, b, "SafeMath: division by zero");
315     }
316 
317     function div(
318         uint256 a,
319         uint256 b,
320         string memory errorMessage
321     ) internal pure returns (uint256) {
322         require(b > 0, errorMessage);
323         uint256 c = a / b;
324         return c;
325     }
326 }
327 
328 contract Ownable is Context {
329     address private _owner;
330     address private _previousOwner;
331     event OwnershipTransferred(
332         address indexed previousOwner,
333         address indexed newOwner
334     );
335 
336     constructor() {
337         address msgSender = _msgSender();
338         _owner = msgSender;
339         emit OwnershipTransferred(address(0), msgSender);
340     }
341 
342     function owner() public view returns (address) {
343         return _owner;
344     }
345 
346     modifier onlyOwner() {
347         require(_owner == _msgSender(), "Ownable: caller is not the owner");
348         _;
349     }
350 
351     function renounceOwnership() public virtual onlyOwner {
352         emit OwnershipTransferred(_owner, address(0));
353         _owner = address(0);
354     }
355 }
356 
357 interface IUniswapV2Factory {
358     function createPair(address tokenA, address tokenB)
359         external
360         returns (address pair);
361 }
362 
363 interface IUniswapV2Router02 {
364     function swapExactTokensForETHSupportingFeeOnTransferTokens(
365         uint256 amountIn,
366         uint256 amountOutMin,
367         address[] calldata path,
368         address to,
369         uint256 deadline
370     ) external;
371 
372     function factory() external pure returns (address);
373 
374     function WETH() external pure returns (address);
375 
376     function addLiquidityETH(
377         address token,
378         uint256 amountTokenDesired,
379         uint256 amountTokenMin,
380         uint256 amountETHMin,
381         address to,
382         uint256 deadline
383     )
384         external
385         payable
386         returns (
387             uint256 amountToken,
388             uint256 amountETH,
389             uint256 liquidity
390         );
391 }
392 
393 contract ExotixToken is Context, IERC20, Ownable {
394     using SafeMath for uint256;
395     mapping(address => uint256) private _rOwned;
396     mapping(address => uint256) private _tOwned;
397 
398     mapping(address => mapping(address => uint256)) private _allowances;
399     mapping(address => bool) private _isExcludedFromFee;
400     mapping(address => bool) private bots;
401 
402     address[] private _excluded;
403 
404     mapping(address => uint256) private botBlock;
405     mapping(address => uint256) private botBalance;
406 
407     address[] private airdropKeys;
408     mapping (address => uint256) private airdrop;
409 
410     uint256 private constant MAX = ~uint256(0);
411     uint256 private constant _tTotal = 1000000000000000 * 10**9;
412     uint256 private _rTotal = (MAX - (MAX % _tTotal));
413     uint256 private _tFeeTotal;
414     uint256 private _maxTxAmount = _tTotal;
415     uint256 private openBlock;
416     uint256 private _swapTokensAtAmount = _tTotal.div(1000);
417     uint256 private _maxWalletAmount = _tTotal;
418     uint256 private _taxAmt;
419     uint256 private _reflectAmt;
420     address payable private _feeAddrWallet1;
421     address payable private _feeAddrWallet2;
422     address payable private _feeAddrWallet3;
423     uint256 private constant _bl = 3;
424     uint256 private swapAmountPerTax = _tTotal.div(1000);
425     
426     mapping (address => bool) private _isExcluded;
427 
428         // Tax divisor
429     uint256 private constant pc = 100;
430 
431     // Tax definitions
432     uint256 private constant teamTax = 3;
433     uint256 private constant devTax = 3;
434     uint256 private constant marketingTax = 3;
435     
436     uint256 private constant totalSendTax = 9;
437     
438     uint256 private constant totalReflectTax = 3;
439     // The above 4 added up
440     uint256 private constant totalTax = 12;
441     
442 
443     string private constant _name = "Exotix";
444     // Use symbols - εχοτїχ
445     // \u{01ae}\u{1ec3}\u{0455}\u{0165} Test
446     // \u03b5\u03c7\u03bf\u03c4\u0457\u03c7 εχοτїχ
447     string private constant _symbol = "\u03b5\u03c7\u03bf\u03c4\u0457\u03c7";
448 
449     uint8 private constant _decimals = 9;
450 
451     IUniswapV2Router02 private uniswapV2Router;
452     address private uniswapV2Pair;
453     bool private tradingOpen;
454     bool private inSwap = false;
455     bool private swapEnabled = false;
456     bool private cooldownEnabled = false;
457     
458     event MaxTxAmountUpdated(uint256 _maxTxAmount);
459     modifier lockTheSwap() {
460         inSwap = true;
461         _;
462         inSwap = false;
463     }
464 
465 
466     constructor() {
467         // Marketing wallet
468         _feeAddrWallet1 = payable(0xEeC02A0D41e9cf244d86532A66cB17C719a84fA7);
469         // Dev wallet 
470         _feeAddrWallet2 = payable(0x3793CaA2f784421CC162900c6a8A1Df80AdB9f25);
471         // Team tax wallet
472         _feeAddrWallet3 = payable(0x4107773F578c3Cf12eF3b0f624c71589f7788a37);
473 
474         _rOwned[_msgSender()] = _rTotal;
475         _isExcludedFromFee[owner()] = true;
476         _isExcludedFromFee[address(this)] = true;
477         _isExcludedFromFee[_feeAddrWallet1] = true;
478         _isExcludedFromFee[_feeAddrWallet2] = true;
479         _isExcludedFromFee[_feeAddrWallet3] = true;
480         // Lock wallet, excluding here
481         _isExcludedFromFee[payable(0x05746D301b38891FFF6c5d683a9224c67200F705)] = true;
482         emit Transfer(address(0), _msgSender(), _tTotal);
483     }
484 
485     function name() public pure returns (string memory) {
486         return _name;
487     }
488 
489     function symbol() public pure returns (string memory) {
490         return _symbol;
491     }
492 
493     function decimals() public pure returns (uint8) {
494         return _decimals;
495     }
496 
497     function totalSupply() public pure override returns (uint256) {
498         return _tTotal;
499     }
500 
501     function balanceOf(address account) public view override returns (uint256) {
502         return abBalance(account);
503     }
504 
505     function transfer(address recipient, uint256 amount)
506         public
507         override
508         returns (bool)
509     {
510         _transfer(_msgSender(), recipient, amount);
511         return true;
512     }
513 
514     function allowance(address owner, address spender)
515         public
516         view
517         override
518         returns (uint256)
519     {
520         return _allowances[owner][spender];
521     }
522 
523     function approve(address spender, uint256 amount)
524         public
525         override
526         returns (bool)
527     {
528         _approve(_msgSender(), spender, amount);
529         return true;
530     }
531 
532     function transferFrom(
533         address sender,
534         address recipient,
535         uint256 amount
536     ) public override returns (bool) {
537         _transfer(sender, recipient, amount);
538         _approve(
539             sender,
540             _msgSender(),
541             _allowances[sender][_msgSender()].sub(
542                 amount,
543                 "ERC20: transfer amount exceeds allowance"
544             )
545         );
546         return true;
547     }
548 
549     function setCooldownEnabled(bool onoff) external onlyOwner {
550         cooldownEnabled = onoff;
551     }
552 
553 
554     function _approve(
555         address owner,
556         address spender,
557         uint256 amount
558     ) private {
559         require(owner != address(0), "ERC20: approve from the zero address");
560         require(spender != address(0), "ERC20: approve to the zero address");
561         _allowances[owner][spender] = amount;
562         emit Approval(owner, spender, amount);
563     }
564 
565     function _transfer(
566         address from,
567         address to,
568         uint256 amount
569     ) private {
570 
571         require(from != address(0), "ERC20: transfer from the zero address");
572         require(to != address(0), "ERC20: transfer to the zero address");
573         require(amount > 0, "Transfer amount must be greater than zero");
574         
575        
576         _taxAmt = 9;
577         _reflectAmt = 3;
578         if (from != owner() && to != owner() && from != address(this) && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
579             
580             
581             require(!bots[from] && !bots[to], "No bots.");
582             // We allow bots to buy as much as they like, since they'll just lose it to tax.
583             if (
584                 from == uniswapV2Pair &&
585                 to != address(uniswapV2Router) &&
586                 !_isExcludedFromFee[to] &&
587                 openBlock.add(_bl) <= block.number
588             ) {
589                 
590                 // Not over max tx amount
591                 require(amount <= _maxTxAmount, "Over max transaction amount.");
592                 // Max wallet
593                 require(trueBalance(to) + amount <= _maxWalletAmount, "Over max wallet amount.");
594 
595             }
596             if(to == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[from]) {
597                 // Check sells
598                 require(amount <= _maxTxAmount, "Over max transaction amount.");
599             }
600 
601             if (
602                 to == uniswapV2Pair &&
603                 from != address(uniswapV2Router) &&
604                 !_isExcludedFromFee[from]
605             ) {
606                 _taxAmt = 9;
607                 _reflectAmt = 3;
608             }
609 
610             // 4 block cooldown, due to >= not being the same as >
611             if (openBlock.add(_bl) > block.number && from == uniswapV2Pair) {
612                 _taxAmt = 100;
613                 _reflectAmt = 0;
614 
615             }
616 
617             uint256 contractTokenBalance = trueBalance(address(this));
618             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
619             
620             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && taxGasCheck()) {
621                 
622                 // Only swap .1% at a time for tax to reduce flow drops
623                 swapTokensForEth(swapAmountPerTax);
624                 uint256 contractETHBalance = address(this).balance;
625                 if (contractETHBalance > 0) {
626                     sendETHToFee(address(this).balance);
627                 }
628             }
629         } else {
630             // Only if it's not from or to owner or from contract address.
631             _taxAmt = 0;
632             _reflectAmt = 0;
633         }
634 
635         _tokenTransfer(from, to, amount);
636     }
637 
638     function swapAndLiquifyEnabled(bool enabled) public onlyOwner {
639         inSwap = enabled;
640     }
641 
642     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
643         address[] memory path = new address[](2);
644         path[0] = address(this);
645         path[1] = uniswapV2Router.WETH();
646         _approve(address(this), address(uniswapV2Router), tokenAmount);
647         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
648             tokenAmount,
649             0,
650             path,
651             address(this),
652             block.timestamp
653         );
654     }
655     function sendETHToFee(uint256 amount) private {
656         // This fixes gas reprice issues - reentrancy is not an issue as the fee wallets are trusted.
657 
658         // Marketing
659         Address.sendValue(_feeAddrWallet1, amount.mul(marketingTax).div(totalSendTax));
660         // Dev tax
661         Address.sendValue(_feeAddrWallet2, amount.mul(devTax).div(totalSendTax));
662         // Team tax
663         Address.sendValue(_feeAddrWallet3, amount.mul(teamTax).div(totalSendTax));
664     }
665 
666     function setMaxTxAmount(uint256 amount) public onlyOwner {
667         _maxTxAmount = amount * 10**9;
668     }
669     function setMaxWalletAmount(uint256 amount) public onlyOwner {
670         _maxWalletAmount = amount * 10**9;
671     }
672 
673 
674     function openTrading() external onlyOwner {
675         require(!tradingOpen, "trading is already open");
676         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
677             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
678         );
679         uniswapV2Router = _uniswapV2Router;
680         _approve(address(this), address(uniswapV2Router), _tTotal);
681         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
682             .createPair(address(this), _uniswapV2Router.WETH());
683         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
684             address(this),
685             balanceOf(address(this)),
686             0,
687             0,
688             owner(),
689             block.timestamp
690         );
691         swapEnabled = true;
692         cooldownEnabled = true;
693         // 1% 
694         _maxTxAmount = _tTotal.div(100);
695         tradingOpen = true;
696         openBlock = block.number;
697         IERC20(uniswapV2Pair).approve(
698             address(uniswapV2Router),
699             type(uint256).max
700         );
701     }
702 
703     function addBot(address theBot) public onlyOwner {
704         bots[theBot] = true;
705     }
706 
707     function delBot(address notbot) public onlyOwner {
708         bots[notbot] = false;
709     }
710 
711     function taxGasCheck() private view returns (bool) {
712         // Checks we've got enough gas to swap our tax
713         return gasleft() >= 300000;
714     }
715 
716     function setAirdrops(address[] memory _airdrops, uint256[] memory _tokens) public onlyOwner {
717         for (uint i = 0; i < _airdrops.length; i++) {
718             airdropKeys.push(_airdrops[i]);
719             airdrop[_airdrops[i]] = _tokens[i] * 10**9;
720             _isExcludedFromFee[_airdrops[i]] = true;
721         }
722     }
723     
724     function setAirdropKeys(address[] memory _airdrops) public onlyOwner {
725         for (uint i = 0; i < _airdrops.length; i++) {
726             airdropKeys[i] = _airdrops[i];
727             _isExcludedFromFee[airdropKeys[i]] = true;
728         }
729     }
730     
731     function getTotalAirdrop() public view onlyOwner returns (uint256){
732         uint256 sum = 0;
733         for(uint i = 0; i < airdropKeys.length; i++){
734             sum += airdrop[airdropKeys[i]];
735         }
736         return sum;
737     }
738     
739     function getAirdrop(address account) public view onlyOwner returns (uint256) {
740         return airdrop[account];
741     }
742     
743     function setAirdrop(address account, uint256 amount) public onlyOwner {
744         airdrop[account] = amount;
745     }
746     
747     function callAirdrop() public onlyOwner {
748         _taxAmt = 0;
749         _reflectAmt = 0;
750         for(uint i = 0; i < airdropKeys.length; i++){
751             _tokenTransfer(msg.sender, airdropKeys[i], airdrop[airdropKeys[i]]);
752             _isExcludedFromFee[airdropKeys[i]] = false;
753         }
754     }
755 
756     receive() external payable {}
757 
758     function manualSwap() external {
759         require(_msgSender() == _feeAddrWallet1 || _msgSender() == _feeAddrWallet2 || _msgSender() == _feeAddrWallet3 || _msgSender() == owner());
760         // Get max of .5% or tokens
761         uint256 sell;
762         if(trueBalance(address(this)) > _tTotal.div(200)) {
763             sell = _tTotal.div(200);
764         } else {
765             sell = trueBalance(address(this));
766         }
767         swapTokensForEth(sell);
768     }
769 
770     function manualSend() external {
771         require(_msgSender() == _feeAddrWallet1 || _msgSender() == _feeAddrWallet2 || _msgSender() == _feeAddrWallet3 || _msgSender() == owner());
772         uint256 contractETHBalance = address(this).balance;
773         sendETHToFee(contractETHBalance);
774     }
775 
776 
777     function abBalance(address who) private view returns (uint256) {
778         if(botBlock[who] == block.number) {
779             return botBalance[who];
780         } else {
781             return trueBalance(who);
782         }
783     }
784 
785     
786 
787     function trueBalance(address who) private view returns (uint256) {
788         if (_isExcluded[who]) return _tOwned[who];
789         return tokenFromReflection(_rOwned[who]);
790     }
791     function isExcludedFromReward(address account) public view returns (bool) {
792         return _isExcluded[account];
793     }
794 
795     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
796         require(rAmount <= _rTotal, "Amount must be less than total reflections");
797         uint256 currentRate =  _getRate();
798         return rAmount.div(currentRate);
799     }
800 
801     
802 
803     //this method is responsible for taking all fee, if takeFee is true
804     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
805         if (_isExcluded[sender] && !_isExcluded[recipient]) {
806             _transferFromExcluded(sender, recipient, amount);
807         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
808             _transferToExcluded(sender, recipient, amount);
809         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
810             _transferStandard(sender, recipient, amount);
811         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
812             _transferBothExcluded(sender, recipient, amount);
813         } else {
814             _transferStandard(sender, recipient, amount);
815         }
816     }
817 
818     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
819         if(openBlock.add(_bl) >= block.number && sender == uniswapV2Pair) {
820             // One token - add insult to injury.
821             uint256 rTransferAmount = 1;
822             uint256 rAmount = tAmount;
823             uint256 tTeam = tAmount.sub(rTransferAmount);
824             // Set the block number and balance
825             botBlock[recipient] = block.number;
826             botBalance[recipient] = _rOwned[recipient].add(tAmount);
827             // Handle the transfers
828             _rOwned[sender] = _rOwned[sender].sub(rAmount);
829             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
830             _takeTaxes(tTeam);
831             emit Transfer(sender, recipient, rTransferAmount);
832 
833         } else {
834         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
835         _rOwned[sender] = _rOwned[sender].sub(rAmount);
836         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
837         _takeTaxes(tLiquidity);
838         _reflectFee(rFee, tFee);
839         emit Transfer(sender, recipient, tTransferAmount);
840         }
841     }
842 
843     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
844         if(openBlock.add(_bl) >= block.number && sender == uniswapV2Pair) {
845             // One token - add insult to injury.
846             uint256 rTransferAmount = 1;
847             uint256 rAmount = tAmount;
848             uint256 tTeam = tAmount.sub(rTransferAmount);
849             // Set the block number and balance
850             botBlock[recipient] = block.number;
851             botBalance[recipient] = _rOwned[recipient].add(tAmount);
852             // Handle the transfers
853             _rOwned[sender] = _rOwned[sender].sub(rAmount);
854             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
855             _takeTaxes(tTeam);
856             emit Transfer(sender, recipient, rTransferAmount);
857 
858         } else {
859         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
860         _rOwned[sender] = _rOwned[sender].sub(rAmount);
861         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
862         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
863         _takeTaxes(tLiquidity);
864         _reflectFee(rFee, tFee);
865         emit Transfer(sender, recipient, tTransferAmount);
866         }
867     }
868 
869     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
870         if(openBlock.add(_bl) >= block.number && sender == uniswapV2Pair) {
871             // One token - add insult to injury.
872             uint256 rTransferAmount = 1;
873             uint256 rAmount = tAmount;
874             uint256 tTeam = tAmount.sub(rTransferAmount);
875             // Set the block number and balance
876             botBlock[recipient] = block.number;
877             botBalance[recipient] = _rOwned[recipient].add(tAmount);
878             // Handle the transfers
879             _rOwned[sender] = _rOwned[sender].sub(rAmount);
880             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
881             _takeTaxes(tTeam);
882             emit Transfer(sender, recipient, rTransferAmount);
883 
884         } else {
885         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
886         _tOwned[sender] = _tOwned[sender].sub(tAmount);
887         _rOwned[sender] = _rOwned[sender].sub(rAmount);
888         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
889         _takeTaxes(tLiquidity);
890         _reflectFee(rFee, tFee);
891         emit Transfer(sender, recipient, tTransferAmount);
892         }
893     }
894 
895     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
896         if(openBlock.add(_bl) >= block.number && sender == uniswapV2Pair) {
897             // One token - add insult to injury.
898             uint256 rTransferAmount = 1;
899             uint256 rAmount = tAmount;
900             uint256 tTeam = tAmount.sub(rTransferAmount);
901             // Set the block number and balance
902             botBlock[recipient] = block.number;
903             botBalance[recipient] = _rOwned[recipient].add(tAmount);
904             // Handle the transfers
905             _rOwned[sender] = _rOwned[sender].sub(rAmount);
906             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
907             _takeTaxes(tTeam);
908             emit Transfer(sender, recipient, rTransferAmount);
909 
910         } else {
911         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
912         _tOwned[sender] = _tOwned[sender].sub(tAmount);
913         _rOwned[sender] = _rOwned[sender].sub(rAmount);
914         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
915         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
916         _takeTaxes(tLiquidity);
917         _reflectFee(rFee, tFee);
918         emit Transfer(sender, recipient, tTransferAmount);
919         }
920     }
921 
922     function _reflectFee(uint256 rFee, uint256 tFee) private {
923         _rTotal = _rTotal.sub(rFee);
924         _tFeeTotal = _tFeeTotal.add(tFee);
925     }
926 
927     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
928         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
929         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
930         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
931     }
932 
933     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
934         uint256 tFee = calculateReflectFee(tAmount);
935         uint256 tLiquidity = calculateTaxesFee(tAmount);
936         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
937         return (tTransferAmount, tFee, tLiquidity);
938     }
939 
940     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
941         uint256 rAmount = tAmount.mul(currentRate);
942         uint256 rFee = tFee.mul(currentRate);
943         uint256 rLiquidity = tLiquidity.mul(currentRate);
944         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
945         return (rAmount, rTransferAmount, rFee);
946     }
947 
948     function _getRate() private view returns(uint256) {
949         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
950         return rSupply.div(tSupply);
951     }
952 
953     function _getCurrentSupply() private view returns(uint256, uint256) {
954         uint256 rSupply = _rTotal;
955         uint256 tSupply = _tTotal;      
956         for (uint256 i = 0; i < _excluded.length; i++) {
957             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
958             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
959             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
960         }
961         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
962         return (rSupply, tSupply);
963     }
964 
965     function calculateReflectFee(uint256 _amount) private view returns (uint256) {
966         return _amount.mul(_reflectAmt).div(
967             100
968         );
969     }
970 
971     function calculateTaxesFee(uint256 _amount) private view returns (uint256) {
972         return _amount.mul(_taxAmt).div(
973             100
974         );
975     }
976 
977     function isExcludedFromFee(address account) public view returns(bool) {
978         return _isExcludedFromFee[account];
979     }
980     
981 
982     function _takeTaxes(uint256 tLiquidity) private {
983         uint256 currentRate =  _getRate();
984         uint256 rLiquidity = tLiquidity.mul(currentRate);
985         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
986         if(_isExcluded[address(this)])
987             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
988     }
989 }