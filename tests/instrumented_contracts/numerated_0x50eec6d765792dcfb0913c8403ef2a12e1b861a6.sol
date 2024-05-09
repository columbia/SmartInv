1 /*
2 
3 TG : https://t.me/Z3_Portal
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.17;
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address who) external view returns (uint256);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function transfer(address to, uint256 value) external returns (bool);
16     function approve(address spender, uint256 value) external returns (bool);
17     function transferFrom(address from, address to, uint256 value) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21 }
22 
23 interface InterfaceLP {
24     function sync() external;
25 }
26 
27 abstract contract ERC20Detailed is IERC20 {
28     string private _name;
29     string private _symbol;
30     uint8 private _decimals;
31 
32     constructor(
33         string memory _tokenName,
34         string memory _tokenSymbol,
35         uint8 _tokenDecimals
36     ) {
37         _name = _tokenName;
38         _symbol = _tokenSymbol;
39         _decimals = _tokenDecimals;
40     }
41 
42     function name() public view returns (string memory) {
43         return _name;
44     }
45 
46     function symbol() public view returns (string memory) {
47         return _symbol;
48     }
49 
50     function decimals() public view returns (uint8) {
51         return _decimals;
52     }
53 }
54 
55 interface IDEXRouter {
56     function factory() external pure returns (address);
57     function WETH() external pure returns (address);
58     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
59     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
60     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
61 }
62 
63 interface IDEXFactory {
64     function createPair(address tokenA, address tokenB)
65     external
66     returns (address pair);
67 }
68 
69 contract Ownable {
70     address private _owner;
71 
72     event OwnershipRenounced(address indexed previousOwner);
73 
74     event OwnershipTransferred(
75         address indexed previousOwner,
76         address indexed newOwner
77     );
78 
79     constructor() {
80         _owner = msg.sender;
81     }
82 
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     modifier onlyOwner() {
88         require(msg.sender == _owner, "Not owner");
89         _;
90     }
91 
92     function renounceOwnership() public onlyOwner {
93         emit OwnershipRenounced(_owner);
94         _owner = address(0);
95     }
96 
97     function transferOwnership(address newOwner) public onlyOwner {
98         _transferOwnership(newOwner);
99     }
100 
101     function _transferOwnership(address newOwner) internal {
102         require(newOwner != address(0));
103         emit OwnershipTransferred(_owner, newOwner);
104         _owner = newOwner;
105     }
106 }
107 
108 contract TokenHandler is Ownable {
109     function sendTokenToOwner(address token) external onlyOwner {
110         if(IERC20(token).balanceOf(address(this)) > 0){
111             IERC20(token).transfer(owner(), IERC20(token).balanceOf(address(this)));
112         }
113     }
114 }
115 
116 library Address {
117     function isContract(address account) internal view returns (bool) {
118         return account.code.length > 0;
119     }
120 
121     function sendValue(address payable recipient, uint256 amount) internal {
122         require(address(this).balance >= amount, "Address: insufficient balance");
123 
124         (bool success, ) = recipient.call{value: amount}("");
125         require(success, "Address: unable to send value, recipient may have reverted");
126     }
127 
128     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
129         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
130     }
131 
132     function functionCall(
133         address target,
134         bytes memory data,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         return functionCallWithValue(target, data, 0, errorMessage);
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
142      * but also transferring `value` wei to `target`.
143      *
144      * Requirements:
145      *
146      * - the calling contract must have an ETH balance of at least `value`.
147      * - the called Solidity function must be `payable`.
148      *
149      * _Available since v3.1._
150      */
151     function functionCallWithValue(
152         address target,
153         bytes memory data,
154         uint256 value
155     ) internal returns (bytes memory) {
156         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
161      * with `errorMessage` as a fallback revert reason when `target` reverts.
162      *
163      * _Available since v3.1._
164      */
165     function functionCallWithValue(
166         address target,
167         bytes memory data,
168         uint256 value,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         require(address(this).balance >= value, "Address: insufficient balance for call");
172         (bool success, bytes memory returndata) = target.call{value: value}(data);
173         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but performing a static call.
179      *
180      * _Available since v3.3._
181      */
182     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
183         return functionStaticCall(target, data, "Address: low-level static call failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
188      * but performing a static call.
189      *
190      * _Available since v3.3._
191      */
192     function functionStaticCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal view returns (bytes memory) {
197         (bool success, bytes memory returndata) = target.staticcall(data);
198         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
203      * but performing a delegate call.
204      *
205      * _Available since v3.4._
206      */
207     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
208         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
213      * but performing a delegate call.
214      *
215      * _Available since v3.4._
216      */
217     function functionDelegateCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         (bool success, bytes memory returndata) = target.delegatecall(data);
223         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
224     }
225 
226     /**
227      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
228      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
229      *
230      * _Available since v4.8._
231      */
232     function verifyCallResultFromTarget(
233         address target,
234         bool success,
235         bytes memory returndata,
236         string memory errorMessage
237     ) internal view returns (bytes memory) {
238         if (success) {
239             if (returndata.length == 0) {
240                 // only check isContract if the call was successful and the return data is empty
241                 // otherwise we already know that it was a contract
242                 require(isContract(target), "Address: call to non-contract");
243             }
244             return returndata;
245         } else {
246             _revert(returndata, errorMessage);
247         }
248     }
249 
250     /**
251      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
252      * revert reason or using the provided one.
253      *
254      * _Available since v4.3._
255      */
256     function verifyCallResult(
257         bool success,
258         bytes memory returndata,
259         string memory errorMessage
260     ) internal pure returns (bytes memory) {
261         if (success) {
262             return returndata;
263         } else {
264             _revert(returndata, errorMessage);
265         }
266     }
267 
268     function _revert(bytes memory returndata, string memory errorMessage) private pure {
269         // Look for revert reason and bubble it up if present
270         if (returndata.length > 0) {
271             // The easiest way to bubble the revert reason is using memory via assembly
272             /// @solidity memory-safe-assembly
273             assembly {
274                 let returndata_size := mload(returndata)
275                 revert(add(32, returndata), returndata_size)
276             }
277         } else {
278             revert(errorMessage);
279         }
280     }
281 }
282 
283 library SafeERC20 {
284     using Address for address;
285 
286     function safeTransfer(
287         IERC20 token,
288         address to,
289         uint256 value
290     ) internal {
291         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
292     }
293 
294     function _callOptionalReturn(IERC20 token, bytes memory data) private {
295         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
296         if (returndata.length > 0) {
297             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
298         }
299     }
300 }
301 
302 contract ZCubed is ERC20Detailed, Ownable {
303 
304     bool public tradingActive = false;
305     bool public swapEnabled = true;
306 
307     uint256 public rewardYield = 315920639267394;
308     uint256 public rewardYieldDenominator = 100000000000000000;
309 
310     uint256 public rebaseFrequency = 1 days / 2; // 43200 seconds - every 12 hours
311     uint256 public nextRebase;
312     bool public autoRebase = true;
313 
314     uint256 public timeBetweenRebaseReduction = 90 days; // 90 days
315     uint256 public rebaseReductionAmount = 3; // 30% reduction
316     uint256 public lastReduction;
317 
318     uint256 public maxTxnAmount;
319     uint256 public maxWallet;
320 
321     mapping(address => bool) _isFeeExempt;
322     address[] public _makerPairs;
323     mapping (address => bool) public automatedMarketMakerPairs;
324 
325     uint256 public constant MAX_FEE_RATE = 4;
326     uint256 public constant MAX_REBASE_FREQUENCY = 43200;
327     uint256 public constant MIN_REBASE_FREQUENCY = 43200;
328     uint256 private constant DECIMALS = 18;
329     uint256 private constant MAX_UINT256 = type(uint256).max;
330     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 2_100_000 * 10**DECIMALS;
331     uint256 private constant TOTAL_GONS = type(uint256).max - (type(uint256).max % INITIAL_FRAGMENTS_SUPPLY);
332     uint256 private constant MAX_SUPPLY = 21_000_000 * 10**DECIMALS;
333 
334     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
335     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
336     event RemovedLimits();
337 
338     address DEAD = 0x000000000000000000000000000000000000dEaD;
339     address ZERO = 0x0000000000000000000000000000000000000000;
340 
341     address public marketingAddress;
342     address public treasuryAddress;
343     address public PAIREDTOKEN;
344 
345     IDEXRouter public immutable router;
346     address public pair;
347 
348     TokenHandler public tokenHandler;
349 
350      // Anti-bot and anti-whale mappings and variables
351     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
352     bool public transferDelayEnabled = true;
353 
354     uint256 public liquidityFee = 1;
355     uint256 public marketingFee = 2;
356     uint256 public treasuryFee = 1;
357     uint256 public totalFee = liquidityFee + marketingFee + treasuryFee;
358     uint256 public feeDenominator = 100;
359     
360     bool public limitsInEffect = true;
361 
362     bool inSwap;
363 
364     modifier swapping() {
365         inSwap = true;
366         _;
367         inSwap = false;
368     }
369     
370     uint256 private _totalSupply;
371     uint256 private _gonsPerFragment;
372     uint256 private gonSwapThreshold = (TOTAL_GONS / 100000 * 25);
373 
374     mapping(address => uint256) private _gonBalances;
375     mapping(address => mapping(address => uint256)) private _allowedFragments;
376 
377     modifier validRecipient(address to) {
378         require(to != address(0x0));
379         _;
380     }
381 
382     constructor() ERC20Detailed(block.chainid==1 ? "Z-Cubed" : "ZTEST", block.chainid==1 ? "Z3" : "ZTEST", 18) {
383         address dexAddress;
384         address pairedTokenAddress;
385         if(block.chainid == 1){
386             dexAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
387             pairedTokenAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
388         } else if(block.chainid == 5){
389             dexAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
390             pairedTokenAddress = 0x2f3A40A3db8a7e3D09B0adfEfbCe4f6F81927557;
391         } else if (block.chainid == 97){
392             dexAddress = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
393             pairedTokenAddress  = 0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7;
394         } else {
395             revert("Chain not configured");
396         }
397 
398         marketingAddress = address(0x77B2aE7647afAa8Eef08572CF7b77803C5aE95d7);
399         treasuryAddress = address(0x4f013300A0DcE6193388Cd057108eecB9e1054aC);
400 
401         nextRebase = block.timestamp + rebaseFrequency;
402         
403         PAIREDTOKEN = pairedTokenAddress;
404 
405         router = IDEXRouter(dexAddress);
406 
407         tokenHandler = new TokenHandler();
408 
409         _allowedFragments[address(this)][address(router)] = ~uint256(0);
410         _allowedFragments[address(msg.sender)][address(router)] = ~uint256(0);
411         _allowedFragments[address(this)][address(this)] = ~uint256(0);
412 
413         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
414         _gonBalances[msg.sender] = TOTAL_GONS / 100 * 95;
415         _gonBalances[treasuryAddress] += TOTAL_GONS - _gonBalances[msg.sender];
416         _gonsPerFragment = TOTAL_GONS/(_totalSupply);
417 
418         maxTxnAmount = _totalSupply * 5 / 1000; // 0.5%
419         maxWallet = _totalSupply * 1 / 100;
420         
421         _isFeeExempt[address(this)] = true;
422         _isFeeExempt[address(msg.sender)] = true;
423         _isFeeExempt[address(dexAddress)] = true;
424         _isFeeExempt[address(0xdead)] = true;
425 
426         emit Transfer(address(0x0), msg.sender, balanceOf(msg.sender));
427         emit Transfer(address(0x0), treasuryAddress, balanceOf(treasuryAddress));  
428     }
429 
430     function totalSupply() external view override returns (uint256) {
431         return _totalSupply;
432     }
433 
434     function allowance(address owner_, address spender) external view override returns (uint256){
435         return _allowedFragments[owner_][spender];
436     }
437 
438     function balanceOf(address who) public view override returns (uint256) {
439         return _gonBalances[who]/(_gonsPerFragment);
440     }
441 
442     function checkFeeExempt(address _addr) external view returns (bool) {
443         return _isFeeExempt[_addr];
444     }
445 
446     function checkSwapThreshold() external view returns (uint256) {
447         return gonSwapThreshold/(_gonsPerFragment);
448     }
449 
450     function shouldRebase() public view returns (bool) {
451         return nextRebase <= block.timestamp;
452     }
453 
454     function shouldTakeFee(address from, address to) internal view returns (bool) {
455         if(_isFeeExempt[from] || _isFeeExempt[to]){
456             return false;
457         } else {
458             return (automatedMarketMakerPairs[from] || automatedMarketMakerPairs[to]);
459         }
460     }
461 
462     function shouldSwapBack() internal view returns (bool) {
463         return
464         !inSwap &&
465         swapEnabled &&
466         totalFee > 0 &&
467         _gonBalances[address(this)] >= gonSwapThreshold;
468     }
469 
470     function manualSync() public {
471         for(uint i = 0; i < _makerPairs.length; i++){
472             try InterfaceLP(_makerPairs[i]).sync(){} catch {}
473         }
474     }
475 
476     function transfer(address to, uint256 value) external override validRecipient(to) returns (bool){
477         _transferFrom(msg.sender, to, value);
478         return true;
479     }
480 
481     // remove limits after token is stable
482     function removeLimits() external onlyOwner {
483         limitsInEffect = false;
484         emit RemovedLimits();
485     }
486 
487     // alter the paired token so bots can't prep for new path (hypothetically)
488     function alterToken(address newToken) external onlyOwner {
489         require(newToken != address(0), "Zero address");
490         require(!tradingActive, "trading already active");
491         pair = IDEXFactory(router.factory()).createPair(address(this), newToken);
492         _allowedFragments[address(this)][pair] = ~uint256(0);
493         setAutomatedMarketMakerPair(pair, true);
494         PAIREDTOKEN = newToken;
495     }
496 
497     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
498 
499         if(!tradingActive){
500             require(_isFeeExempt[sender] || _isFeeExempt[recipient], "Trading is paused");
501         }
502 
503         if(limitsInEffect){
504             if (!_isFeeExempt[sender] && !_isFeeExempt[recipient]){
505 
506                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
507                 if (transferDelayEnabled){
508                     if (recipient != address(router) && !automatedMarketMakerPairs[recipient]){
509                         require(_holderLastTransferBlock[tx.origin] + 2 < block.number && _holderLastTransferBlock[recipient] + 2 < block.number, "_transfer:: Transfer Delay enabled.  Try again later.");
510                         _holderLastTransferBlock[tx.origin] = block.number;
511                         _holderLastTransferBlock[recipient] = block.number;
512                     }
513                 }
514                 //when buy
515                 if (automatedMarketMakerPairs[sender]) {
516                     require(amount <= maxTxnAmount, "Buy transfer amount exceeds the max buy.");
517                 }
518                 if (!automatedMarketMakerPairs[recipient]){
519                     require(balanceOf(recipient) + amount <= maxWallet, "Max Wallet Exceeded");
520                 }
521             }
522         }
523 
524         if(!_isFeeExempt[sender] && !_isFeeExempt[recipient] && shouldSwapBack() && !automatedMarketMakerPairs[sender]){
525             inSwap = true;
526             swapBack();
527             inSwap = false;
528         }
529 
530         if(autoRebase && !automatedMarketMakerPairs[sender] && !inSwap && shouldRebase() && !_isFeeExempt[recipient] && !_isFeeExempt[sender]){
531             rebase();
532         }
533 
534         uint256 gonAmount = amount*(_gonsPerFragment);
535 
536         _gonBalances[sender] = _gonBalances[sender]-(gonAmount);
537 
538         uint256 gonAmountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, gonAmount) : gonAmount;
539         _gonBalances[recipient] = _gonBalances[recipient]+(gonAmountReceived);
540 
541         emit Transfer(sender, recipient, gonAmountReceived/(_gonsPerFragment));
542 
543         return true;
544     }
545 
546     function transferFrom(address from, address to,  uint256 value) external override validRecipient(to) returns (bool) {
547         if (_allowedFragments[from][msg.sender] != MAX_UINT256) {
548             require(_allowedFragments[from][msg.sender] >= value,"Insufficient Allowance");
549             _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender]-(value);
550         }
551         _transferFrom(from, to, value);
552         return true;
553     }
554 
555     
556 
557     function swapBack() public {
558 
559         uint256 contractBalance = balanceOf(address(this));
560 
561         if(contractBalance > gonSwapThreshold/(_gonsPerFragment) * 20){
562             contractBalance = gonSwapThreshold/(_gonsPerFragment) * 20;
563         }
564 
565         uint256 tokensForLiquidity = contractBalance * liquidityFee / totalFee;
566 
567         if(tokensForLiquidity > 0 && contractBalance >= tokensForLiquidity){
568             _transferFrom(address(this), pair, tokensForLiquidity);
569             manualSync();
570             contractBalance -= tokensForLiquidity;
571             tokensForLiquidity = 0;
572         }
573         
574         swapTokensForPAIREDTOKEN(contractBalance);
575 
576         tokenHandler.sendTokenToOwner(address(PAIREDTOKEN));
577         
578         uint256 pairedTokenBalance = IERC20(PAIREDTOKEN).balanceOf(address(this));
579 
580         uint256 pairedTokenForTreasury = pairedTokenBalance * treasuryFee / (treasuryFee + marketingFee);
581 
582         if(pairedTokenForTreasury > 0){
583             IERC20(PAIREDTOKEN).transfer(treasuryAddress, pairedTokenForTreasury);
584         }
585 
586         if(IERC20(PAIREDTOKEN).balanceOf(address(this)) > 0){
587             IERC20(PAIREDTOKEN).transfer(marketingAddress, IERC20(PAIREDTOKEN).balanceOf(address(this)));
588         }
589     }
590 
591     function swapTokensForPAIREDTOKEN(uint256 tokenAmount) private {
592         address[] memory path = new address[](2);
593         path[0] = address(this);
594         path[1] = address(PAIREDTOKEN);
595 
596         // make the swap
597         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
598             tokenAmount,
599             0, // accept any amount
600             path,
601             address(tokenHandler),
602             block.timestamp
603         );
604     }
605 
606     function takeFee(address sender, uint256 gonAmount) internal returns (uint256){
607 
608         uint256 feeAmount = gonAmount*(totalFee)/(feeDenominator);
609 
610         _gonBalances[address(this)] = _gonBalances[address(this)]+(feeAmount);
611         emit Transfer(sender, address(this), feeAmount/(_gonsPerFragment));
612 
613         return gonAmount-(feeAmount);
614     }
615 
616     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool){
617         uint256 oldValue = _allowedFragments[msg.sender][spender];
618         if (subtractedValue >= oldValue) {
619             _allowedFragments[msg.sender][spender] = 0;
620         } else {
621             _allowedFragments[msg.sender][spender] = oldValue-(
622                 subtractedValue
623             );
624         }
625         emit Approval(
626             msg.sender,
627             spender,
628             _allowedFragments[msg.sender][spender]
629         );
630         return true;
631     }
632 
633     function increaseAllowance(address spender, uint256 addedValue) external returns (bool){
634         _allowedFragments[msg.sender][spender] = _allowedFragments[msg.sender][
635         spender
636         ]+(addedValue);
637         emit Approval(
638             msg.sender,
639             spender,
640             _allowedFragments[msg.sender][spender]
641         );
642         return true;
643     }
644 
645     function approve(address spender, uint256 value) public override returns (bool){
646         _allowedFragments[msg.sender][spender] = value;
647         emit Approval(msg.sender, spender, value);
648         return true;
649     }
650 
651     function getSupplyDeltaOnNextRebase() external view returns (uint256){
652         return (_totalSupply*rewardYield)/rewardYieldDenominator;
653     }
654 
655     function rebase() private returns (uint256) {
656         uint256 epoch = block.timestamp;
657 
658         if(lastReduction + timeBetweenRebaseReduction <= block.timestamp){
659             rewardYield -= rewardYield * rebaseReductionAmount / 10;
660             lastReduction = block.timestamp;
661         }
662 
663         uint256 supplyDelta = (_totalSupply*rewardYield)/rewardYieldDenominator;
664         
665         nextRebase = nextRebase + rebaseFrequency;
666 
667         if (supplyDelta == 0) {
668             emit LogRebase(epoch, _totalSupply);
669             return _totalSupply;
670         }
671 
672         _totalSupply = _totalSupply+supplyDelta;
673 
674         if (_totalSupply > MAX_SUPPLY) {
675             _totalSupply = MAX_SUPPLY;
676         }
677 
678         _gonsPerFragment = TOTAL_GONS/(_totalSupply);
679 
680         manualSync();
681 
682         emit LogRebase(epoch, _totalSupply);
683         return _totalSupply;
684     }
685 
686     function manualRebase() external {
687         require(!inSwap, "Try again");
688         require(shouldRebase(), "Not in time");
689         rebase();
690     }
691     
692     function setAutomatedMarketMakerPair(address _pair, bool _value) public onlyOwner {
693         require(automatedMarketMakerPairs[_pair] != _value, "Value already set");
694 
695         automatedMarketMakerPairs[_pair] = _value;
696 
697         if(_value){
698             _makerPairs.push(_pair);
699         } else {
700             require(_makerPairs.length > 1, "Required 1 pair");
701             for (uint256 i = 0; i < _makerPairs.length; i++) {
702                 if (_makerPairs[i] == _pair) {
703                     _makerPairs[i] = _makerPairs[_makerPairs.length - 1];
704                     _makerPairs.pop();
705                     break;
706                 }
707             }
708         }
709 
710         emit SetAutomatedMarketMakerPair(_pair, _value);
711     }
712 
713     function enableTrading() external onlyOwner {
714         require(!tradingActive, "Trading already active");
715         tradingActive = true;
716         nextRebase = block.timestamp + rebaseFrequency;
717         lastReduction = block.timestamp;
718     }
719 
720     // disable Transfer delay - cannot be reenabled
721     function disableTransferDelay() external onlyOwner {
722         transferDelayEnabled = false;
723     }
724 
725     function setFeeExempt(address _addr, bool _value) external onlyOwner {
726         require(_isFeeExempt[_addr] != _value, "Not changed");
727         _isFeeExempt[_addr] = _value;
728     }
729 
730     function setFeeReceivers(address _marketingReceiver, address _treasuryReceiver) external onlyOwner {
731         require(_marketingReceiver != address(0) && _treasuryReceiver != address(0), "zero address");
732         treasuryAddress = _treasuryReceiver;
733         marketingAddress = _marketingReceiver;
734     }
735 
736     function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _treasuryFee) external onlyOwner {
737         liquidityFee = _liquidityFee;
738         marketingFee = _marketingFee;
739         treasuryFee = _treasuryFee;
740         totalFee = liquidityFee + marketingFee + treasuryFee;
741         require(totalFee <= MAX_FEE_RATE, "Fees set too high");
742     }
743 
744     function rescueToken(address tokenAddress, uint256 tokens, address destination) external onlyOwner returns (bool success){
745         require(tokenAddress != address(this), "Cannot take native tokens");
746         return ERC20Detailed(tokenAddress).transfer(destination, tokens);
747     }
748 
749     function setNextRebase(uint256 _nextRebase) external onlyOwner {
750         require(_nextRebase > block.timestamp, "Must set rebase in the future");
751         nextRebase = _nextRebase;
752     }
753 }