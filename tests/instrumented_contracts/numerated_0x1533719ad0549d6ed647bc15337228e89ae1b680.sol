1 /*
2 
3 REWARDS SO SIMPLELE AN AUTIST CAN HANDLELE IT! 
4 
5 Twitter: https://twitter.com/AutistWealthMgt
6 TG: https://t.me/AWM_Portal
7 Website: http://www.autistwealthmanagement.com/
8 
9 */
10 
11 // SPDX-License-Identifier: UNLICENSED
12 
13 pragma solidity 0.8.17;
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address who) external view returns (uint256);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function transfer(address to, uint256 value) external returns (bool);
20     function approve(address spender, uint256 value) external returns (bool);
21     function transferFrom(address from, address to, uint256 value) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25 }
26 
27 interface InterfaceLP {
28     function sync() external;
29 }
30 
31 abstract contract ERC20Detailed is IERC20 {
32     string private _name;
33     string private _symbol;
34     uint8 private _decimals;
35 
36     constructor(
37         string memory _tokenName,
38         string memory _tokenSymbol,
39         uint8 _tokenDecimals
40     ) {
41         _name = _tokenName;
42         _symbol = _tokenSymbol;
43         _decimals = _tokenDecimals;
44     }
45 
46     function name() public view returns (string memory) {
47         return _name;
48     }
49 
50     function symbol() public view returns (string memory) {
51         return _symbol;
52     }
53 
54     function decimals() public view returns (uint8) {
55         return _decimals;
56     }
57 }
58 
59 interface IDEXRouter {
60     function factory() external pure returns (address);
61     function WETH() external pure returns (address);
62     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
63     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
64     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
65 }
66 
67 interface IDEXFactory {
68     function createPair(address tokenA, address tokenB)
69     external
70     returns (address pair);
71 }
72 
73 contract Ownable {
74     address private _owner;
75 
76     event OwnershipRenounced(address indexed previousOwner);
77 
78     event OwnershipTransferred(
79         address indexed previousOwner,
80         address indexed newOwner
81     );
82 
83     constructor() {
84         _owner = msg.sender;
85     }
86 
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     modifier onlyOwner() {
92         require(msg.sender == _owner, "Not owner");
93         _;
94     }
95 
96     function renounceOwnership() public onlyOwner {
97         emit OwnershipRenounced(_owner);
98         _owner = address(0);
99     }
100 
101     function transferOwnership(address newOwner) public onlyOwner {
102         _transferOwnership(newOwner);
103     }
104 
105     function _transferOwnership(address newOwner) internal {
106         require(newOwner != address(0));
107         emit OwnershipTransferred(_owner, newOwner);
108         _owner = newOwner;
109     }
110 }
111 
112 contract TokenHandler is Ownable {
113     function sendTokenToOwner(address token) external onlyOwner {
114         if(IERC20(token).balanceOf(address(this)) > 0){
115             IERC20(token).transfer(owner(), IERC20(token).balanceOf(address(this)));
116         }
117     }
118 }
119 
120 library Address {
121     function isContract(address account) internal view returns (bool) {
122         return account.code.length > 0;
123     }
124 
125     function sendValue(address payable recipient, uint256 amount) internal {
126         require(address(this).balance >= amount, "Address: insufficient balance");
127 
128         (bool success, ) = recipient.call{value: amount}("");
129         require(success, "Address: unable to send value, recipient may have reverted");
130     }
131 
132     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
133         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
134     }
135 
136     function functionCall(
137         address target,
138         bytes memory data,
139         string memory errorMessage
140     ) internal returns (bytes memory) {
141         return functionCallWithValue(target, data, 0, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but also transferring `value` wei to `target`.
147      *
148      * Requirements:
149      *
150      * - the calling contract must have an ETH balance of at least `value`.
151      * - the called Solidity function must be `payable`.
152      *
153      * _Available since v3.1._
154      */
155     function functionCallWithValue(
156         address target,
157         bytes memory data,
158         uint256 value
159     ) internal returns (bytes memory) {
160         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
165      * with `errorMessage` as a fallback revert reason when `target` reverts.
166      *
167      * _Available since v3.1._
168      */
169     function functionCallWithValue(
170         address target,
171         bytes memory data,
172         uint256 value,
173         string memory errorMessage
174     ) internal returns (bytes memory) {
175         require(address(this).balance >= value, "Address: insufficient balance for call");
176         (bool success, bytes memory returndata) = target.call{value: value}(data);
177         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
182      * but performing a static call.
183      *
184      * _Available since v3.3._
185      */
186     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
187         return functionStaticCall(target, data, "Address: low-level static call failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
192      * but performing a static call.
193      *
194      * _Available since v3.3._
195      */
196     function functionStaticCall(
197         address target,
198         bytes memory data,
199         string memory errorMessage
200     ) internal view returns (bytes memory) {
201         (bool success, bytes memory returndata) = target.staticcall(data);
202         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but performing a delegate call.
208      *
209      * _Available since v3.4._
210      */
211     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
212         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
217      * but performing a delegate call.
218      *
219      * _Available since v3.4._
220      */
221     function functionDelegateCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         (bool success, bytes memory returndata) = target.delegatecall(data);
227         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
232      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
233      *
234      * _Available since v4.8._
235      */
236     function verifyCallResultFromTarget(
237         address target,
238         bool success,
239         bytes memory returndata,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         if (success) {
243             if (returndata.length == 0) {
244                 // only check isContract if the call was successful and the return data is empty
245                 // otherwise we already know that it was a contract
246                 require(isContract(target), "Address: call to non-contract");
247             }
248             return returndata;
249         } else {
250             _revert(returndata, errorMessage);
251         }
252     }
253 
254     /**
255      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
256      * revert reason or using the provided one.
257      *
258      * _Available since v4.3._
259      */
260     function verifyCallResult(
261         bool success,
262         bytes memory returndata,
263         string memory errorMessage
264     ) internal pure returns (bytes memory) {
265         if (success) {
266             return returndata;
267         } else {
268             _revert(returndata, errorMessage);
269         }
270     }
271 
272     function _revert(bytes memory returndata, string memory errorMessage) private pure {
273         // Look for revert reason and bubble it up if present
274         if (returndata.length > 0) {
275             // The easiest way to bubble the revert reason is using memory via assembly
276             /// @solidity memory-safe-assembly
277             assembly {
278                 let returndata_size := mload(returndata)
279                 revert(add(32, returndata), returndata_size)
280             }
281         } else {
282             revert(errorMessage);
283         }
284     }
285 }
286 
287 library SafeERC20 {
288     using Address for address;
289 
290     function safeTransfer(
291         IERC20 token,
292         address to,
293         uint256 value
294     ) internal {
295         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
296     }
297 
298     function _callOptionalReturn(IERC20 token, bytes memory data) private {
299         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
300         if (returndata.length > 0) {
301             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
302         }
303     }
304 }
305 
306 contract AWM is ERC20Detailed, Ownable {
307 
308     bool public tradingActive = false;
309     bool public swapEnabled = true;
310 
311     uint256 public rewardYield = 315920639267394;
312     uint256 public rewardYieldDenominator = 100000000000000000;
313 
314     uint256 public rebaseFrequency = 1 days / 12; // 7200 seconds - every 2 hours
315     uint256 public nextRebase;
316     bool public autoRebase = true;
317 
318     uint256 public timeBetweenRebaseReduction = 15 days;
319     uint256 public rebaseReductionAmount = 3; // 30% reduction
320     uint256 public lastReduction;
321 
322     uint256 public maxTxnAmount;
323     uint256 public maxWallet;
324 
325     mapping(address => bool) _isFeeExempt;
326     address[] public _makerPairs;
327     mapping (address => bool) public automatedMarketMakerPairs;
328 
329     uint256 public constant MAX_FEE_RATE = 5;
330     uint256 public constant MAX_REBASE_FREQUENCY = 7200;
331     uint256 public constant MIN_REBASE_FREQUENCY = 7200;
332     uint256 private constant DECIMALS = 18;
333     uint256 private constant MAX_UINT256 = type(uint256).max;
334     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 6_942_000 * 10**DECIMALS;
335     uint256 private constant TOTAL_GONS = type(uint256).max - (type(uint256).max % INITIAL_FRAGMENTS_SUPPLY);
336     uint256 private constant MAX_SUPPLY = 69_420_000 * 10**DECIMALS; 
337 
338     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
339     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
340     event RemovedLimits();
341 
342     address DEAD = 0x000000000000000000000000000000000000dEaD;
343     address ZERO = 0x0000000000000000000000000000000000000000;
344 
345     address public marketingAddress;
346     address public treasuryAddress;
347     address public PAIREDTOKEN;
348 
349     IDEXRouter public immutable router;
350     address public pair;
351 
352     TokenHandler public tokenHandler;
353 
354      // Anti-bot and anti-whale mappings and variables
355     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
356     bool public transferDelayEnabled = true;
357 
358     uint256 public liquidityFee = 0;
359     uint256 public marketingFee = 3;
360     uint256 public treasuryFee = 2;
361     uint256 public totalFee = liquidityFee + marketingFee + treasuryFee;
362     uint256 public feeDenominator = 100;
363     
364     bool public limitsInEffect = true;
365 
366     bool inSwap;
367 
368     modifier swapping() {
369         inSwap = true;
370         _;
371         inSwap = false;
372     }
373     
374     uint256 private _totalSupply;
375     uint256 private _gonsPerFragment;
376     uint256 private gonSwapThreshold = (TOTAL_GONS / 100000 * 25);
377 
378     mapping(address => uint256) private _gonBalances;
379     mapping(address => mapping(address => uint256)) private _allowedFragments;
380 
381     modifier validRecipient(address to) {
382         require(to != address(0x0));
383         _;
384     }
385 
386     constructor() ERC20Detailed(block.chainid==1 ? "Autist Wealth Management" : "AWM", block.chainid==1 ? "AWM" : "AWM", 18) {
387     //constructor() ERC20Detailed(block.chainid==1 ? "Autist Wealth Management" : "AWM", block.chainid==1 ? "AWM" : "AWM", 18) {
388         address dexAddress;
389         address pairedTokenAddress;
390         if(block.chainid == 1){
391             dexAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
392             pairedTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; //WETH
393         } else {
394             revert("Chain not configured");
395         }
396 
397         marketingAddress = address(0xa773aC8751AE7F4b9B5D4393Ce3204fDA32346ef); //Marketing
398         treasuryAddress = address(0x40bF1fd3578Bc4F8BadD3cbCbD419027E8614073); //Treasury
399 
400         nextRebase = block.timestamp + rebaseFrequency;
401         
402         PAIREDTOKEN = pairedTokenAddress;
403 
404         router = IDEXRouter(dexAddress);
405 
406         tokenHandler = new TokenHandler();
407 
408         _allowedFragments[address(this)][address(router)] = ~uint256(0);
409         _allowedFragments[address(msg.sender)][address(router)] = ~uint256(0);
410         _allowedFragments[address(this)][address(this)] = ~uint256(0);
411 
412         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
413         _gonBalances[msg.sender] = TOTAL_GONS / 100 * 95;
414         _gonBalances[treasuryAddress] += TOTAL_GONS - _gonBalances[msg.sender];
415         _gonsPerFragment = TOTAL_GONS/(_totalSupply);
416 
417         maxTxnAmount = _totalSupply * 1 / 100; // 1% max txn
418         maxWallet = _totalSupply * 1 / 100; // 1% max wallet
419         
420         _isFeeExempt[address(this)] = true;
421         _isFeeExempt[address(msg.sender)] = true;
422         _isFeeExempt[address(dexAddress)] = true;
423         _isFeeExempt[address(0xdead)] = true;
424 
425         emit Transfer(address(0x0), msg.sender, balanceOf(msg.sender));
426         emit Transfer(address(0x0), treasuryAddress, balanceOf(treasuryAddress));  
427     }
428 
429     function totalSupply() external view override returns (uint256) {
430         return _totalSupply;
431     }
432 
433     function allowance(address owner_, address spender) external view override returns (uint256){
434         return _allowedFragments[owner_][spender];
435     }
436 
437     function balanceOf(address who) public view override returns (uint256) {
438         return _gonBalances[who]/(_gonsPerFragment);
439     }
440 
441     function checkFeeExempt(address _addr) external view returns (bool) {
442         return _isFeeExempt[_addr];
443     }
444 
445     function checkSwapThreshold() external view returns (uint256) {
446         return gonSwapThreshold/(_gonsPerFragment);
447     }
448 
449     function shouldRebase() public view returns (bool) {
450         return nextRebase <= block.timestamp;
451     }
452 
453     function shouldTakeFee(address from, address to) internal view returns (bool) {
454         if(_isFeeExempt[from] || _isFeeExempt[to]){
455             return false;
456         } else {
457             return (automatedMarketMakerPairs[from] || automatedMarketMakerPairs[to]);
458         }
459     }
460 
461     function shouldSwapBack() internal view returns (bool) {
462         return
463         !inSwap &&
464         swapEnabled &&
465         totalFee > 0 &&
466         _gonBalances[address(this)] >= gonSwapThreshold;
467     }
468 
469     function manualSync() public {
470         for(uint i = 0; i < _makerPairs.length; i++){
471             try InterfaceLP(_makerPairs[i]).sync(){} catch {}
472         }
473     }
474 
475     function transfer(address to, uint256 value) external override validRecipient(to) returns (bool){
476         _transferFrom(msg.sender, to, value);
477         return true;
478     }
479 
480     // remove limits after token is stable
481     function removeLimits() external onlyOwner {
482         limitsInEffect = false;
483         emit RemovedLimits();
484     }
485 
486     // alter the paired token so bots can't prep for new path (hypothetically)
487     function alterToken(address newToken) external onlyOwner {
488         require(newToken != address(0), "Zero address");
489         require(!tradingActive, "trading already active");
490         pair = IDEXFactory(router.factory()).createPair(address(this), newToken);
491         _allowedFragments[address(this)][pair] = ~uint256(0);
492         setAutomatedMarketMakerPair(pair, true);
493         PAIREDTOKEN = newToken;
494     }
495 
496     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
497 
498         if(!tradingActive){
499             require(_isFeeExempt[sender] || _isFeeExempt[recipient], "Trading is paused");
500         }
501 
502         if(limitsInEffect){
503             if (!_isFeeExempt[sender] && !_isFeeExempt[recipient]){
504 
505                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
506                 if (transferDelayEnabled){
507                     if (recipient != address(router) && !automatedMarketMakerPairs[recipient]){
508                         require(_holderLastTransferBlock[tx.origin] + 2 < block.number && _holderLastTransferBlock[recipient] + 2 < block.number, "_transfer:: Transfer Delay enabled.  Try again later.");
509                         _holderLastTransferBlock[tx.origin] = block.number;
510                         _holderLastTransferBlock[recipient] = block.number;
511                     }
512                 }
513                 //when buy
514                 if (automatedMarketMakerPairs[sender]) {
515                     require(amount <= maxTxnAmount, "Buy transfer amount exceeds the max buy.");
516                 }
517                 if (!automatedMarketMakerPairs[recipient]){
518                     require(balanceOf(recipient) + amount <= maxWallet, "Max Wallet Exceeded");
519                 }
520             }
521         }
522 
523         if(!_isFeeExempt[sender] && !_isFeeExempt[recipient] && shouldSwapBack() && !automatedMarketMakerPairs[sender]){
524             inSwap = true;
525             swapBack();
526             inSwap = false;
527         }
528 
529         if(autoRebase && !automatedMarketMakerPairs[sender] && !inSwap && shouldRebase() && !_isFeeExempt[recipient] && !_isFeeExempt[sender]){
530             rebase();
531         }
532 
533         uint256 gonAmount = amount*(_gonsPerFragment);
534 
535         _gonBalances[sender] = _gonBalances[sender]-(gonAmount);
536 
537         uint256 gonAmountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, gonAmount) : gonAmount;
538         _gonBalances[recipient] = _gonBalances[recipient]+(gonAmountReceived);
539 
540         emit Transfer(sender, recipient, gonAmountReceived/(_gonsPerFragment));
541 
542         return true;
543     }
544 
545     function transferFrom(address from, address to,  uint256 value) external override validRecipient(to) returns (bool) {
546         if (_allowedFragments[from][msg.sender] != MAX_UINT256) {
547             require(_allowedFragments[from][msg.sender] >= value,"Insufficient Allowance");
548             _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender]-(value);
549         }
550         _transferFrom(from, to, value);
551         return true;
552     }
553 
554     
555     function swapBack() public {
556 
557         uint256 contractBalance = balanceOf(address(this));
558 
559         if(contractBalance > gonSwapThreshold/(_gonsPerFragment) * 20){
560             contractBalance = gonSwapThreshold/(_gonsPerFragment) * 20;
561         }
562 
563         uint256 tokensForLiquidity = contractBalance * liquidityFee / totalFee;
564 
565         if(tokensForLiquidity > 0 && contractBalance >= tokensForLiquidity){
566             _transferFrom(address(this), pair, tokensForLiquidity);
567             manualSync();
568             contractBalance -= tokensForLiquidity;
569             tokensForLiquidity = 0;
570         }
571         
572         swapTokensForPAIREDTOKEN(contractBalance);
573 
574         tokenHandler.sendTokenToOwner(address(PAIREDTOKEN));
575         
576         uint256 pairedTokenBalance = IERC20(PAIREDTOKEN).balanceOf(address(this));
577 
578         uint256 pairedTokenForTreasury = pairedTokenBalance * treasuryFee / (treasuryFee + marketingFee);
579 
580         if(pairedTokenForTreasury > 0){
581             IERC20(PAIREDTOKEN).transfer(treasuryAddress, pairedTokenForTreasury);
582         }
583 
584         if(IERC20(PAIREDTOKEN).balanceOf(address(this)) > 0){
585             IERC20(PAIREDTOKEN).transfer(marketingAddress, IERC20(PAIREDTOKEN).balanceOf(address(this)));
586         }
587     }
588 
589     function swapTokensForPAIREDTOKEN(uint256 tokenAmount) private {
590         address[] memory path = new address[](2);
591         path[0] = address(this);
592         path[1] = address(PAIREDTOKEN);
593 
594         // make the swap
595         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
596             tokenAmount,
597             0, // accept any amount
598             path,
599             address(tokenHandler),
600             block.timestamp
601         );
602     }
603 
604     function takeFee(address sender, uint256 gonAmount) internal returns (uint256){
605 
606         uint256 feeAmount = gonAmount*(totalFee)/(feeDenominator);
607 
608         _gonBalances[address(this)] = _gonBalances[address(this)]+(feeAmount);
609         emit Transfer(sender, address(this), feeAmount/(_gonsPerFragment));
610 
611         return gonAmount-(feeAmount);
612     }
613 
614     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool){
615         uint256 oldValue = _allowedFragments[msg.sender][spender];
616         if (subtractedValue >= oldValue) {
617             _allowedFragments[msg.sender][spender] = 0;
618         } else {
619             _allowedFragments[msg.sender][spender] = oldValue-(
620                 subtractedValue
621             );
622         }
623         emit Approval(
624             msg.sender,
625             spender,
626             _allowedFragments[msg.sender][spender]
627         );
628         return true;
629     }
630 
631     function increaseAllowance(address spender, uint256 addedValue) external returns (bool){
632         _allowedFragments[msg.sender][spender] = _allowedFragments[msg.sender][
633         spender
634         ]+(addedValue);
635         emit Approval(
636             msg.sender,
637             spender,
638             _allowedFragments[msg.sender][spender]
639         );
640         return true;
641     }
642 
643     function approve(address spender, uint256 value) public override returns (bool){
644         _allowedFragments[msg.sender][spender] = value;
645         emit Approval(msg.sender, spender, value);
646         return true;
647     }
648 
649     function getSupplyDeltaOnNextRebase() external view returns (uint256){
650         return (_totalSupply*rewardYield)/rewardYieldDenominator;
651     }
652 
653     function rebase() private returns (uint256) {
654         uint256 epoch = block.timestamp;
655 
656         if(lastReduction + timeBetweenRebaseReduction <= block.timestamp){
657             rewardYield -= rewardYield * rebaseReductionAmount / 10;
658             lastReduction = block.timestamp;
659         }
660 
661         uint256 supplyDelta = (_totalSupply*rewardYield)/rewardYieldDenominator;
662         
663         nextRebase = nextRebase + rebaseFrequency;
664 
665         if (supplyDelta == 0) {
666             emit LogRebase(epoch, _totalSupply);
667             return _totalSupply;
668         }
669 
670         _totalSupply = _totalSupply+supplyDelta;
671 
672         if (_totalSupply > MAX_SUPPLY) {
673             _totalSupply = MAX_SUPPLY;
674         }
675 
676         _gonsPerFragment = TOTAL_GONS/(_totalSupply);
677 
678         manualSync();
679 
680         emit LogRebase(epoch, _totalSupply);
681         return _totalSupply;
682     }
683 
684     function manualRebase() external {
685         require(!inSwap, "Try again");
686         require(shouldRebase(), "Not in time");
687         rebase();
688     }
689     
690     function setAutomatedMarketMakerPair(address _pair, bool _value) public onlyOwner {
691         require(automatedMarketMakerPairs[_pair] != _value, "Value already set");
692 
693         automatedMarketMakerPairs[_pair] = _value;
694 
695         if(_value){
696             _makerPairs.push(_pair);
697         } else {
698             require(_makerPairs.length > 1, "Required 1 pair");
699             for (uint256 i = 0; i < _makerPairs.length; i++) {
700                 if (_makerPairs[i] == _pair) {
701                     _makerPairs[i] = _makerPairs[_makerPairs.length - 1];
702                     _makerPairs.pop();
703                     break;
704                 }
705             }
706         }
707 
708         emit SetAutomatedMarketMakerPair(_pair, _value);
709     }
710 
711     function enableTrading() external onlyOwner {
712         require(!tradingActive, "Trading already active");
713         tradingActive = true;
714         nextRebase = block.timestamp + rebaseFrequency;
715         lastReduction = block.timestamp;
716     }
717 
718     // disable Transfer delay - cannot be reenabled
719     function disableTransferDelay() external onlyOwner {
720         transferDelayEnabled = false;
721     }
722 
723     function setFeeExempt(address _addr, bool _value) external onlyOwner {
724         require(_isFeeExempt[_addr] != _value, "Not changed");
725         _isFeeExempt[_addr] = _value;
726     }
727 
728     function setFeeReceivers(address _marketingReceiver, address _treasuryReceiver) external onlyOwner {
729         require(_marketingReceiver != address(0) && _treasuryReceiver != address(0), "zero address");
730         treasuryAddress = _treasuryReceiver;
731         marketingAddress = _marketingReceiver;
732     }
733 
734     function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _treasuryFee) external onlyOwner {
735         liquidityFee = _liquidityFee;
736         marketingFee = _marketingFee;
737         treasuryFee = _treasuryFee;
738         totalFee = liquidityFee + marketingFee + treasuryFee;
739         require(totalFee <= MAX_FEE_RATE, "Fees set too high");
740     }
741 
742     function rescueToken(address tokenAddress, uint256 tokens, address destination) external onlyOwner returns (bool success){
743         require(tokenAddress != address(this), "Cannot take native tokens");
744         return ERC20Detailed(tokenAddress).transfer(destination, tokens);
745     }
746 
747     function setNextRebase(uint256 _nextRebase) external onlyOwner {
748         require(_nextRebase > block.timestamp, "Must set rebase in the future");
749         nextRebase = _nextRebase;
750     }
751 }