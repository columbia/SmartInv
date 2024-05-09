1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.18;
4 
5 interface IUniswapV2Factory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function feeTo() external view returns (address);
9     function feeToSetter() external view returns (address);
10     function getPair(address tokenA, address tokenB) external view returns (address pair);
11     function allPairs(uint) external view returns (address pair);
12     function allPairsLength() external view returns (uint);
13     function createPair(address tokenA, address tokenB) external returns (address pair);
14     function setFeeTo(address) external;
15     function setFeeToSetter(address) external;
16 }
17 
18 interface IUniswapV2Router01 {
19     function factory() external pure returns (address);
20     function WETH() external pure returns (address);
21 
22     function addLiquidity(
23         address tokenA,
24         address tokenB,
25         uint amountADesired,
26         uint amountBDesired,
27         uint amountAMin,
28         uint amountBMin,
29         address to,
30         uint deadline
31     ) external returns (uint amountA, uint amountB, uint liquidity);
32     function addLiquidityETH(
33         address token,
34         uint amountTokenDesired,
35         uint amountTokenMin,
36         uint amountETHMin,
37         address to,
38         uint deadline
39     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
40     function removeLiquidity(
41         address tokenA,
42         address tokenB,
43         uint liquidity,
44         uint amountAMin,
45         uint amountBMin,
46         address to,
47         uint deadline
48     ) external returns (uint amountA, uint amountB);
49     function removeLiquidityETH(
50         address token,
51         uint liquidity,
52         uint amountTokenMin,
53         uint amountETHMin,
54         address to,
55         uint deadline
56     ) external returns (uint amountToken, uint amountETH);
57     function removeLiquidityWithPermit(
58         address tokenA,
59         address tokenB,
60         uint liquidity,
61         uint amountAMin,
62         uint amountBMin,
63         address to,
64         uint deadline,
65         bool approveMax, uint8 v, bytes32 r, bytes32 s
66     ) external returns (uint amountA, uint amountB);
67     function removeLiquidityETHWithPermit(
68         address token,
69         uint liquidity,
70         uint amountTokenMin,
71         uint amountETHMin,
72         address to,
73         uint deadline,
74         bool approveMax, uint8 v, bytes32 r, bytes32 s
75     ) external returns (uint amountToken, uint amountETH);
76     function swapExactTokensForTokens(
77         uint amountIn,
78         uint amountOutMin,
79         address[] calldata path,
80         address to,
81         uint deadline
82     ) external returns (uint[] memory amounts);
83     function swapTokensForExactTokens(
84         uint amountOut,
85         uint amountInMax,
86         address[] calldata path,
87         address to,
88         uint deadline
89     ) external returns (uint[] memory amounts);
90     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
91         external
92         payable
93         returns (uint[] memory amounts);
94     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
95         external
96         returns (uint[] memory amounts);
97     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
98         external
99         returns (uint[] memory amounts);
100     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
101         external
102         payable
103         returns (uint[] memory amounts);
104 
105     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
106     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
107     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
108     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
109     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
110 }
111 
112 interface IUniswapV2Router02 is IUniswapV2Router01 {
113     function removeLiquidityETHSupportingFeeOnTransferTokens(
114         address token,
115         uint liquidity,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external returns (uint amountETH);
121     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
122         address token,
123         uint liquidity,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline,
128         bool approveMax, uint8 v, bytes32 r, bytes32 s
129     ) external returns (uint amountETH);
130 
131     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external;
138     function swapExactETHForTokensSupportingFeeOnTransferTokens(
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external payable;
144     function swapExactTokensForETHSupportingFeeOnTransferTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external;
151 }
152 
153 interface IERC20 {
154     function totalSupply() external view returns (uint256);
155     function balanceOf(address account) external view returns (uint256);
156     function transfer(address recipient, uint256 amount) external returns (bool);
157     function allowance(address owner, address spender) external view returns (uint256);
158     function approve(address spender, uint256 amount) external returns (bool);
159     function transferFrom(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) external returns (bool);
164    
165     event Transfer(address indexed from, address indexed to, uint256 value);
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 interface IERC20Metadata is IERC20 {
170     function name() external view returns (string memory);
171     function symbol() external view returns (string memory);
172     function decimals() external view returns (uint8);
173 }
174 
175 library Address {
176     /**
177      * @dev Returns true if `account` is a contract.
178      *
179      * [IMPORTANT]
180      * ====
181      * It is unsafe to assume that an address for which this function returns
182      * false is an externally-owned account (EOA) and not a contract.
183      *
184      * Among others, `isContract` will return false for the following
185      * types of addresses:
186      *
187      *  - an externally-owned account
188      *  - a contract in construction
189      *  - an address where a contract will be created
190      *  - an address where a contract lived, but was destroyed
191      * ====
192      *
193      * [IMPORTANT]
194      * ====
195      * You shouldn't rely on `isContract` to protect against flash loan attacks!
196      *
197      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
198      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
199      * constructor.
200      * ====
201      */
202     function isContract(address account) internal view returns (bool) {
203         // This method relies on extcodesize/address.code.length, which returns 0
204         // for contracts in construction, since the code is only stored at the end
205         // of the constructor execution.
206 
207         return account.code.length > 0;
208     }
209 
210     /**
211      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
212      * `recipient`, forwarding all available gas and reverting on errors.
213      *
214      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
215      * of certain opcodes, possibly making contracts go over the 2300 gas limit
216      * imposed by `transfer`, making them unable to receive funds via
217      * `transfer`. {sendValue} removes this limitation.
218      *
219      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
220      *
221      * IMPORTANT: because control is transferred to `recipient`, care must be
222      * taken to not create reentrancy vulnerabilities. Consider using
223      * {ReentrancyGuard} or the
224      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
225      */
226     function sendValue(address payable recipient, uint256 amount) internal {
227         require(address(this).balance >= amount, "Address: insufficient balance");
228 
229         (bool success, ) = recipient.call{value: amount}("");
230         require(success, "Address: unable to send value, recipient may have reverted");
231     }
232 
233     /**
234      * @dev Performs a Solidity function call using a low level `call`. A
235      * plain `call` is an unsafe replacement for a function call: use this
236      * function instead.
237      *
238      * If `target` reverts with a revert reason, it is bubbled up by this
239      * function (like regular Solidity function calls).
240      *
241      * Returns the raw returned data. To convert to the expected return value,
242      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
243      *
244      * Requirements:
245      *
246      * - `target` must be a contract.
247      * - calling `target` with `data` must not revert.
248      *
249      * _Available since v3.1._
250      */
251     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
257      * `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         return functionCallWithValue(target, data, 0, errorMessage);
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
271      * but also transferring `value` wei to `target`.
272      *
273      * Requirements:
274      *
275      * - the calling contract must have an ETH balance of at least `value`.
276      * - the called Solidity function must be `payable`.
277      *
278      * _Available since v3.1._
279      */
280     function functionCallWithValue(
281         address target,
282         bytes memory data,
283         uint256 value
284     ) internal returns (bytes memory) {
285         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
290      * with `errorMessage` as a fallback revert reason when `target` reverts.
291      *
292      * _Available since v3.1._
293      */
294     function functionCallWithValue(
295         address target,
296         bytes memory data,
297         uint256 value,
298         string memory errorMessage
299     ) internal returns (bytes memory) {
300         require(address(this).balance >= value, "Address: insufficient balance for call");
301         (bool success, bytes memory returndata) = target.call{value: value}(data);
302         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but performing a static call.
308      *
309      * _Available since v3.3._
310      */
311     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
312         return functionStaticCall(target, data, "Address: low-level static call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
317      * but performing a static call.
318      *
319      * _Available since v3.3._
320      */
321     function functionStaticCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal view returns (bytes memory) {
326         (bool success, bytes memory returndata) = target.staticcall(data);
327         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but performing a delegate call.
333      *
334      * _Available since v3.4._
335      */
336     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
337         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
342      * but performing a delegate call.
343      *
344      * _Available since v3.4._
345      */
346     function functionDelegateCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         (bool success, bytes memory returndata) = target.delegatecall(data);
352         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
357      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
358      *
359      * _Available since v4.8._
360      */
361     function verifyCallResultFromTarget(
362         address target,
363         bool success,
364         bytes memory returndata,
365         string memory errorMessage
366     ) internal view returns (bytes memory) {
367         if (success) {
368             if (returndata.length == 0) {
369                 // only check isContract if the call was successful and the return data is empty
370                 // otherwise we already know that it was a contract
371                 require(isContract(target), "Address: call to non-contract");
372             }
373             return returndata;
374         } else {
375             _revert(returndata, errorMessage);
376         }
377     }
378 
379     /**
380      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
381      * revert reason or using the provided one.
382      *
383      * _Available since v4.3._
384      */
385     function verifyCallResult(
386         bool success,
387         bytes memory returndata,
388         string memory errorMessage
389     ) internal pure returns (bytes memory) {
390         if (success) {
391             return returndata;
392         } else {
393             _revert(returndata, errorMessage);
394         }
395     }
396 
397     function _revert(bytes memory returndata, string memory errorMessage) private pure {
398         // Look for revert reason and bubble it up if present
399         if (returndata.length > 0) {
400             // The easiest way to bubble the revert reason is using memory via assembly
401             /// @solidity memory-safe-assembly
402             assembly {
403                 let returndata_size := mload(returndata)
404                 revert(add(32, returndata), returndata_size)
405             }
406         } else {
407             revert(errorMessage);
408         }
409     }
410 }
411 
412 abstract contract Context {
413     function _msgSender() internal view virtual returns (address) {
414         return msg.sender;
415     }
416 
417     function _msgData() internal view virtual returns (bytes calldata) {
418         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
419         return msg.data;
420     }
421 }
422 
423 abstract contract Ownable is Context {
424     address private _owner;
425 
426     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
427 
428     constructor () {
429         address msgSender = _msgSender();
430         _owner = msgSender;
431         emit OwnershipTransferred(address(0), msgSender);
432     }
433 
434     function owner() public view returns (address) {
435         return _owner;
436     }
437 
438     modifier onlyOwner() {
439         require(_owner == _msgSender(), "Ownable: caller is not the owner");
440         _;
441     }
442 
443     function renounceOwnership() public virtual onlyOwner {
444         emit OwnershipTransferred(_owner, address(0));
445         _owner = address(0);
446     }
447 
448     function transferOwnership(address newOwner) public virtual onlyOwner {
449         require(newOwner != address(0), "Ownable: new owner is the zero address");
450         emit OwnershipTransferred(_owner, newOwner);
451         _owner = newOwner;
452     }
453 }
454 
455 contract ERC20 is Context, IERC20, IERC20Metadata {
456     mapping(address => uint256) private _balances;
457 
458     mapping(address => mapping(address => uint256)) private _allowances;
459 
460     uint256 private _totalSupply;
461 
462     string private _name;
463     string private _symbol;
464 
465     constructor(string memory name_, string memory symbol_) {
466         _name = name_;
467         _symbol = symbol_;
468     }
469 
470     function name() public view virtual override returns (string memory) {
471         return _name;
472     }
473 
474     function symbol() public view virtual override returns (string memory) {
475         return _symbol;
476     }
477 
478     function decimals() public view virtual override returns (uint8) {
479         return 18;
480     }
481 
482     function totalSupply() public view virtual override returns (uint256) {
483         return _totalSupply;
484     }
485 
486     function balanceOf(address account) public view virtual override returns (uint256) {
487         return _balances[account];
488     }
489 
490     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
491         _transfer(_msgSender(), recipient, amount);
492         return true;
493     }
494 
495     function allowance(address owner, address spender) public view virtual override returns (uint256) {
496         return _allowances[owner][spender];
497     }
498 
499     function approve(address spender, uint256 amount) public virtual override returns (bool) {
500         _approve(_msgSender(), spender, amount);
501         return true;
502     }
503 
504     function transferFrom(
505         address sender,
506         address recipient,
507         uint256 amount
508     ) public virtual override returns (bool) {
509         uint256 currentAllowance = _allowances[sender][_msgSender()];
510         if (currentAllowance != type(uint256).max) {
511             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
512             unchecked {
513                 _approve(sender, _msgSender(), currentAllowance - amount);
514             }
515         }
516 
517         _transfer(sender, recipient, amount);
518 
519         return true;
520     }
521 
522     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
523         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
524         return true;
525     }
526 
527     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
528         uint256 currentAllowance = _allowances[_msgSender()][spender];
529         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
530         unchecked {
531             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
532         }
533 
534         return true;
535     }
536 
537     function _transfer(
538         address sender,
539         address recipient,
540         uint256 amount
541     ) internal virtual {
542         require(sender != address(0), "ERC20: transfer from the zero address");
543         require(recipient != address(0), "ERC20: transfer to the zero address");
544 
545         _beforeTokenTransfer(sender, recipient, amount);
546 
547         uint256 senderBalance = _balances[sender];
548         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
549         unchecked {
550             _balances[sender] = senderBalance - amount;
551         }
552         _balances[recipient] += amount;
553 
554         emit Transfer(sender, recipient, amount);
555 
556         _afterTokenTransfer(sender, recipient, amount);
557     }
558 
559     function _mint(address account, uint256 amount) internal virtual {
560         require(account != address(0), "ERC20: mint to the zero address");
561 
562         _beforeTokenTransfer(address(0), account, amount);
563 
564         _totalSupply += amount;
565         _balances[account] += amount;
566         emit Transfer(address(0), account, amount);
567 
568         _afterTokenTransfer(address(0), account, amount);
569     }
570 
571     function _burn(address account, uint256 amount) internal virtual {
572         require(account != address(0), "ERC20: burn from the zero address");
573 
574         _beforeTokenTransfer(account, address(0), amount);
575 
576         uint256 accountBalance = _balances[account];
577         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
578         unchecked {
579             _balances[account] = accountBalance - amount;
580         }
581         _totalSupply -= amount;
582 
583         emit Transfer(account, address(0), amount);
584 
585         _afterTokenTransfer(account, address(0), amount);
586     }
587 
588     function _approve(
589         address owner,
590         address spender,
591         uint256 amount
592     ) internal virtual {
593         require(owner != address(0), "ERC20: approve from the zero address");
594         require(spender != address(0), "ERC20: approve to the zero address");
595 
596         _allowances[owner][spender] = amount;
597         emit Approval(owner, spender, amount);
598     }
599 
600     function _beforeTokenTransfer(
601         address from,
602         address to,
603         uint256 amount
604     ) internal virtual {}
605 
606     function _afterTokenTransfer(
607         address from,
608         address to,
609         uint256 amount
610     ) internal virtual {}
611 }
612 
613 contract Mule is ERC20, Ownable {
614     using Address for address payable;
615 
616     mapping(address => bool) private _isWhitelisted;
617     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
618 
619     address public uniswapV2Pair;
620     uint256 public maxWalletAmount;
621     bool    public maxWalletLimitEnabled;
622     bool    public tradingEnabled; 
623 
624     event ExcludedFromMaxWalletLimit(address indexed account, bool isExcluded);
625     event MaxWalletLimitAmountChanged(uint256 maxWalletLimitRate);
626     event MaxWalletLimitStateChanged(bool maxWalletLimit);
627     event WhitelistAddress(address indexed account, bool _isWhitelisted);
628 
629     constructor () ERC20("Mule", "MULE") 
630     {   
631         transferOwnership(0x80fd6234F119B7A82B62c91eC88f930b35178f82);  
632 
633         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap Router
634         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
635         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
636             .createPair(address(this), _uniswapV2Router.WETH()); 
637 
638         uniswapV2Pair = _uniswapV2Pair;    
639 
640         _isExcludedFromMaxWalletLimit[owner()] = true;
641         _isExcludedFromMaxWalletLimit[address(0xdead)] = true;
642 
643         _isWhitelisted[owner()] = true;
644 
645         _mint(owner(), 420_690_000_000_000 ether);
646 
647         maxWalletLimitEnabled = true;
648         maxWalletAmount = (totalSupply() / 100);
649     }
650 
651     receive() external payable { }
652 
653     function claimStuckTokens(address token) external onlyOwner {
654         if (token == address(0)) {
655             payable(msg.sender).sendValue(address(this).balance);
656             return;
657         }
658         IERC20 ERC20token = IERC20(token);
659         uint256 balance = ERC20token.balanceOf(address(this));
660         ERC20token.transfer(msg.sender, balance);
661     }
662 
663     function addWhitelistedAddress(address _addr) external onlyOwner {
664         _isWhitelisted[_addr] = true;
665         emit WhitelistAddress(_addr, true);
666     }
667 
668     function removeWhitelistedAddress(address _addr) external onlyOwner {
669         _isWhitelisted[_addr] = false;
670         emit WhitelistAddress(_addr, false);
671     }
672 
673     function isWhitelisted(address _addr) external view returns (bool) {
674         return _isWhitelisted[_addr];
675     }
676 
677     function enableMaxWalletLimit() external onlyOwner {
678         require(!maxWalletLimitEnabled, "Max Wallet Limit is already enabled");
679         maxWalletLimitEnabled = true;
680         emit MaxWalletLimitStateChanged(maxWalletLimitEnabled);
681     }
682 
683     function disableMaxWalletLimit() external onlyOwner {
684         require(maxWalletLimitEnabled, "Max Wallet Limit is already disabled");
685         maxWalletLimitEnabled = false;
686         emit MaxWalletLimitStateChanged(maxWalletLimitEnabled);
687     }
688 
689     function setMaxWalletAmount(uint256 _maxWalletAmount) external onlyOwner {
690         maxWalletAmount = _maxWalletAmount * (10 ** decimals());
691         emit MaxWalletLimitAmountChanged(maxWalletAmount);
692     }
693 
694     function setExcludeFromMaxWallet(address account, bool exclude) external onlyOwner {
695         require(
696             _isExcludedFromMaxWalletLimit[account] != exclude, 
697             "Account is already set to that state"
698         );
699         _isExcludedFromMaxWalletLimit[account] = exclude;
700         emit ExcludedFromMaxWalletLimit(account, exclude);
701     }
702 
703     function isExcludedFromMaxWalletLimit(address account) public view returns(bool) {
704         return _isExcludedFromMaxWalletLimit[account];
705     } 
706 
707     function enableTrading() external onlyOwner {
708         require(!tradingEnabled, "Trading is already enabled");
709         tradingEnabled = true;
710     }
711 
712     function disableTrading() external onlyOwner {
713         require(tradingEnabled, "Trading is already disabled");
714         tradingEnabled = false;
715     }
716    
717     function _transfer(address from,address to,uint256 amount) internal  override {
718         require(from != address(0), "ERC20: transfer from the zero address");
719         require(to != address(0), "ERC20: transfer to the zero address");    
720         require(tradingEnabled || _isWhitelisted[from] || _isWhitelisted[to], "Trading is not enabled");
721        
722         if (amount == 0) {
723             super._transfer(from, to, 0);
724             return;
725         }
726 
727         if (maxWalletLimitEnabled) {
728             if (_isExcludedFromMaxWalletLimit[from]  == false && 
729                 _isExcludedFromMaxWalletLimit[to]    == false &&
730                 to != uniswapV2Pair
731             ) {
732                 uint256 balance = balanceOf(to);
733                 require(
734                     balance + amount <= maxWalletAmount, 
735                     "Recipient exceeds the max wallet limit"
736                 );
737             }
738         }	
739         
740         super._transfer(from, to, amount);
741     }       
742 }