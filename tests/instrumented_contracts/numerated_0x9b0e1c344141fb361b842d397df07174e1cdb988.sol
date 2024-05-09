1 // Welcome to EmotiCoin, where innovation meets the future of memecoins. 
2 // Our groundbreaking Reverse Split Protocol (RSP) is here to redefine the crypto experience. 
3 // With a total of 84 captivating supply cuts, EmotiCoin is changing the game.
4 
5 // Website: www.emoticoin.io
6 // Twitter: https://twitter.com/Emoticoin_io
7 // Telegram: https://t.me/emoticoin_io
8 // Instagram: https://www.instagram.com/emoticoin_io/
9 
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.17;
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address who) external view returns (uint256);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function transfer(address to, uint256 value) external returns (bool);
19     function approve(address spender, uint256 value) external returns (bool);
20     function transferFrom(address from, address to, uint256 value) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 interface InterfaceLP {
26     function sync() external;
27     function mint(address to) external returns (uint liquidity);
28 }
29 
30 abstract contract ERC20Detailed is IERC20 {
31     string private _name;
32     string private _symbol;
33     uint8 private _decimals;
34 
35     constructor(
36         string memory _tokenName,
37         string memory _tokenSymbol,
38         uint8 _tokenDecimals
39     ) {
40         _name = _tokenName;
41         _symbol = _tokenSymbol;
42         _decimals = _tokenDecimals;
43     }
44 
45     function name() public view returns (string memory) {
46         return _name;
47     }
48 
49     function symbol() public view returns (string memory) {
50         return _symbol;
51     }
52 
53     function decimals() public view returns (uint8) {
54         return _decimals;
55     }
56 }
57 
58 interface IDEXRouter {
59     function factory() external pure returns (address);
60     function WETH() external pure returns (address);
61     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
62 }
63 
64 interface IDEXFactory {
65     function createPair(address tokenA, address tokenB)
66     external
67     returns (address pair);
68 }
69 
70 contract Ownable {
71     address private _owner;
72 
73     event OwnershipRenounced(address indexed previousOwner);
74 
75     event OwnershipTransferred(
76         address indexed previousOwner,
77         address indexed newOwner
78     );
79 
80     constructor() {
81         _owner = msg.sender;
82     }
83 
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     modifier onlyOwner() {
89         require(msg.sender == _owner, "Not owner");
90         _;
91     }
92 
93     function renounceOwnership() public onlyOwner {
94         emit OwnershipRenounced(_owner);
95         _owner = address(0);
96     }
97 
98     function transferOwnership(address newOwner) public onlyOwner {
99         _transferOwnership(newOwner);
100     }
101 
102     function _transferOwnership(address newOwner) internal {
103         require(newOwner != address(0));
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 library Address {
110     /**
111      * @dev The ETH balance of the account is not enough to perform the operation.
112      */
113     error AddressInsufficientBalance(address account);
114 
115     /**
116      * @dev There's no code at `target` (it is not a contract).
117      */
118     error AddressEmptyCode(address target);
119 
120     /**
121      * @dev A call to an address target failed. The target may have reverted.
122      */
123     error FailedInnerCall();
124 
125     /**
126      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
127      * `recipient`, forwarding all available gas and reverting on errors.
128      *
129      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
130      * of certain opcodes, possibly making contracts go over the 2300 gas limit
131      * imposed by `transfer`, making them unable to receive funds via
132      * `transfer`. {sendValue} removes this limitation.
133      *
134      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
135      *
136      * IMPORTANT: because control is transferred to `recipient`, care must be
137      * taken to not create reentrancy vulnerabilities. Consider using
138      * {ReentrancyGuard} or the
139      * https://solidity.readthedocs.io/en/v0.8.20/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
140      */
141     function sendValue(address payable recipient, uint256 amount) internal {
142         if (address(this).balance < amount) {
143             revert AddressInsufficientBalance(address(this));
144         }
145 
146         (bool success, ) = recipient.call{value: amount}("");
147         if (!success) {
148             revert FailedInnerCall();
149         }
150     }
151 
152     /**
153      * @dev Performs a Solidity function call using a low level `call`. A
154      * plain `call` is an unsafe replacement for a function call: use this
155      * function instead.
156      *
157      * If `target` reverts with a revert reason or custom error, it is bubbled
158      * up by this function (like regular Solidity function calls). However, if
159      * the call reverted with no returned reason, this function reverts with a
160      * {FailedInnerCall} error.
161      *
162      * Returns the raw returned data. To convert to the expected return value,
163      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
164      *
165      * Requirements:
166      *
167      * - `target` must be a contract.
168      * - calling `target` with `data` must not revert.
169      */
170     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
171         return functionCallWithValue(target, data, 0);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but also transferring `value` wei to `target`.
177      *
178      * Requirements:
179      *
180      * - the calling contract must have an ETH balance of at least `value`.
181      * - the called Solidity function must be `payable`.
182      */
183     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
184         if (address(this).balance < value) {
185             revert AddressInsufficientBalance(address(this));
186         }
187         (bool success, bytes memory returndata) = target.call{value: value}(data);
188         return verifyCallResultFromTarget(target, success, returndata);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but performing a static call.
194      */
195     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
196         (bool success, bytes memory returndata) = target.staticcall(data);
197         return verifyCallResultFromTarget(target, success, returndata);
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
202      * but performing a delegate call.
203      */
204     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
205         (bool success, bytes memory returndata) = target.delegatecall(data);
206         return verifyCallResultFromTarget(target, success, returndata);
207     }
208 
209     /**
210      * @dev Tool to verify that a low level call to smart-contract was successful, and reverts if the target
211      * was not a contract or bubbling up the revert reason (falling back to {FailedInnerCall}) in case of an
212      * unsuccessful call.
213      */
214     function verifyCallResultFromTarget(
215         address target,
216         bool success,
217         bytes memory returndata
218     ) internal view returns (bytes memory) {
219         if (!success) {
220             _revert(returndata);
221         } else {
222             // only check if target is a contract if the call was successful and the return data is empty
223             // otherwise we already know that it was a contract
224             if (returndata.length == 0 && target.code.length == 0) {
225                 revert AddressEmptyCode(target);
226             }
227             return returndata;
228         }
229     }
230 
231     /**
232      * @dev Tool to verify that a low level call was successful, and reverts if it wasn't, either by bubbling the
233      * revert reason or with a default {FailedInnerCall} error.
234      */
235     function verifyCallResult(bool success, bytes memory returndata) internal pure returns (bytes memory) {
236         if (!success) {
237             _revert(returndata);
238         } else {
239             return returndata;
240         }
241     }
242 
243     /**
244      * @dev Reverts with returndata if present. Otherwise reverts with {FailedInnerCall}.
245      */
246     function _revert(bytes memory returndata) private pure {
247         // Look for revert reason and bubble it up if present
248         if (returndata.length > 0) {
249             // The easiest way to bubble the revert reason is using memory via assembly
250             /// @solidity memory-safe-assembly
251             assembly {
252                 let returndata_size := mload(returndata)
253                 revert(add(32, returndata), returndata_size)
254             }
255         } else {
256             revert FailedInnerCall();
257         }
258     }
259 }
260 
261 interface IWETH {
262     function deposit() external payable;
263 }
264 
265 contract Emoticoin is ERC20Detailed, Ownable {
266 
267     uint256 public rebaseFrequency = 4 hours;
268     uint256 public nextRebase;
269     uint256 public finalRebase;
270     bool public autoRebase = true;
271     bool public rebaseStarted = false;
272     uint256 public rebasesThisCycle;
273     uint256 public lastRebaseThisCycle;
274 
275     uint256 public maxTxnAmount;
276     uint256 public maxWallet;
277 
278     address public taxWallet;
279     uint256 public taxPercentBuy;
280     uint256 public taxPercentSell;
281 
282     string public _1_x;
283     string public _2_telegram;
284     string public _3_website;
285 
286     mapping (address => bool) public isWhitelisted;
287 
288     uint8 private constant DECIMALS = 9;
289     uint256 private constant INITIAL_TOKENS_SUPPLY = 18_236_939_125_700_000 * 10**DECIMALS;
290     uint256 private constant TOTAL_PARTS = type(uint256).max - (type(uint256).max % INITIAL_TOKENS_SUPPLY);
291 
292     event Rebase(uint256 indexed time, uint256 totalSupply);
293     event RemovedLimits();
294 
295     IWETH public immutable weth;
296 
297     IDEXRouter public immutable router;
298     address public immutable pair;
299     
300     bool public limitsInEffect = true;
301     bool public tradingIsLive = false;
302     
303     uint256 private _totalSupply;
304     uint256 private _partsPerToken;
305     uint256 private partsSwapThreshold = (TOTAL_PARTS / 100000 * 25);
306 
307     mapping(address => uint256) private _partBalances;
308     mapping(address => mapping(address => uint256)) private _allowedTokens;
309     
310     mapping(address => bool) private _bots;
311 
312     modifier validRecipient(address to) {
313         require(to != address(0x0));
314         _;
315     }
316 
317     bool inSwap;
318 
319     modifier swapping() {
320         inSwap = true;
321         _;
322         inSwap = false;
323     }
324 
325     constructor() ERC20Detailed(block.chainid==1 ? "EmotiCoin" : "ETEST", block.chainid==1 ? "Emoti" : "ETEST", DECIMALS) {
326         address dexAddress;
327         if(block.chainid == 1){
328             dexAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
329         } else if(block.chainid == 5){
330             dexAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
331         } else if (block.chainid == 97){
332             dexAddress = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
333         } else if (block.chainid == 56){
334             dexAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
335         } else {
336             revert("Chain not configured");
337         }
338 
339        _1_x = "x.com/emoticoin_io"; // @dev update
340         _2_telegram = "t.me/emoticoin_io";
341         _3_website = "Emoticoin.io";
342 
343         taxWallet = msg.sender; // update
344         taxPercentBuy = 20;
345         taxPercentSell = 80;
346 
347         finalRebase = type(uint256).max;
348         nextRebase = type(uint256).max;
349 
350         router = IDEXRouter(dexAddress);
351 
352         _totalSupply = INITIAL_TOKENS_SUPPLY;
353         _partBalances[msg.sender] = TOTAL_PARTS;
354         _partsPerToken = TOTAL_PARTS/(_totalSupply);
355 
356         isWhitelisted[address(this)] = true;
357         isWhitelisted[address(router)] = true;
358         isWhitelisted[msg.sender] = true;
359 
360         maxTxnAmount = _totalSupply * 2 / 100;
361         maxWallet = _totalSupply * 2 / 100;
362 
363         weth = IWETH(router.WETH());
364         pair = IDEXFactory(router.factory()).createPair(address(this), router.WETH());
365 
366         _allowedTokens[address(this)][address(router)] = type(uint256).max;
367         _allowedTokens[address(this)][address(this)] = type(uint256).max;
368         _allowedTokens[address(msg.sender)][address(router)] = type(uint256).max;
369 
370         emit Transfer(address(0x0), address(msg.sender), balanceOf(address(this)));
371     }
372 
373     function totalSupply() external view override returns (uint256) {
374         return _totalSupply;
375     }
376 
377     function allowance(address owner_, address spender) external view override returns (uint256){
378         return _allowedTokens[owner_][spender];
379     }
380 
381     function balanceOf(address who) public view override returns (uint256) {
382         return _partBalances[who]/(_partsPerToken);
383     }
384 
385     function shouldRebase() public view returns (bool) {
386         return nextRebase <= block.timestamp || (autoRebase && rebaseStarted && rebasesThisCycle < 10 && lastRebaseThisCycle + 60 <= block.timestamp);
387     }
388 
389     function lpSync() internal {
390         InterfaceLP _pair = InterfaceLP(pair);
391         _pair.sync();
392     }
393 
394     function transfer(address to, uint256 value) external override validRecipient(to) returns (bool){
395         _transferFrom(msg.sender, to, value);
396         return true;
397     }
398 
399     function removeLimits() external onlyOwner {
400         require(limitsInEffect, "Limits already removed");
401         limitsInEffect = false;
402         emit RemovedLimits();
403     }
404 
405     function whitelistWallet(address _address, bool _isWhitelisted) external onlyOwner {
406         isWhitelisted[_address] = _isWhitelisted;
407     }
408 
409     function updateTaxWallet(address _address) external onlyOwner {
410         require(_address != address(0), "Zero Address");
411         taxWallet = _address;
412     }
413 
414     function updateTaxPercent(uint256 _taxPercentBuy, uint256 _taxPercentSell) external onlyOwner {
415         require(_taxPercentBuy <= taxPercentBuy || _taxPercentBuy <= 10, "Tax too high");
416         require(_taxPercentSell <= taxPercentSell  || _taxPercentSell <= 10, "Tax too high");
417         taxPercentBuy = _taxPercentBuy;
418         taxPercentSell = _taxPercentSell;
419     }
420 
421     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
422         address pairAddress = pair;
423         uint256 partAmount = amount*(_partsPerToken);
424 
425         require(!_bots[sender] && !_bots[recipient] && !_bots[msg.sender], "Blacklisted");
426 
427         if(autoRebase && !inSwap && !isWhitelisted[sender] && !isWhitelisted[recipient]){
428             require(tradingIsLive, "Trading not live");
429             if(limitsInEffect){
430                 if (sender == pairAddress || recipient == pairAddress){
431                     require(amount <= maxTxnAmount, "Max Tx Exceeded");
432                 }
433                 if (recipient != pairAddress){
434                     require(balanceOf(recipient) + amount <= maxWallet, "Max Wallet Exceeded");
435                 }
436             }
437 
438             if(recipient == pairAddress){
439                 if(balanceOf(address(this)) >= partsSwapThreshold/(_partsPerToken)){
440                     try this.swapBack(){} catch {}
441                 }
442                 if(shouldRebase()){
443                     rebase();
444                 }
445             }
446 
447             uint256 taxPartAmount;
448 
449             if(sender == pairAddress){
450                 taxPartAmount = partAmount * taxPercentBuy / 100;
451             }
452             else if (recipient == pairAddress) {
453                 taxPartAmount = partAmount * taxPercentSell / 100;
454             }
455 
456             if(taxPartAmount > 0){
457                 _partBalances[sender] -= taxPartAmount;
458                 _partBalances[address(this)] += taxPartAmount;
459                 emit Transfer(sender, address(this), taxPartAmount / _partsPerToken);
460                 partAmount -= taxPartAmount;
461             }
462             
463         }
464 
465         _partBalances[sender] = _partBalances[sender]-(partAmount);
466         _partBalances[recipient] = _partBalances[recipient]+(partAmount);
467 
468         emit Transfer(sender, recipient, partAmount/(_partsPerToken));
469 
470         return true;
471     }
472 
473     function transferFrom(address from, address to,  uint256 value) external override validRecipient(to) returns (bool) {
474         if (_allowedTokens[from][msg.sender] != type(uint256).max) {
475             require(_allowedTokens[from][msg.sender] >= value,"Insufficient Allowance");
476             _allowedTokens[from][msg.sender] = _allowedTokens[from][msg.sender]-(value);
477         }
478         _transferFrom(from, to, value);
479         return true;
480     }
481 
482     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool){
483         uint256 oldValue = _allowedTokens[msg.sender][spender];
484         if (subtractedValue >= oldValue) {
485             _allowedTokens[msg.sender][spender] = 0;
486         } else {
487             _allowedTokens[msg.sender][spender] = oldValue-(
488                 subtractedValue
489             );
490         }
491         emit Approval(
492             msg.sender,
493             spender,
494             _allowedTokens[msg.sender][spender]
495         );
496         return true;
497     }
498 
499     function increaseAllowance(address spender, uint256 addedValue) external returns (bool){
500         _allowedTokens[msg.sender][spender] = _allowedTokens[msg.sender][
501         spender
502         ]+(addedValue);
503         emit Approval(
504             msg.sender,
505             spender,
506             _allowedTokens[msg.sender][spender]
507         );
508         return true;
509     }
510 
511     function approve(address spender, uint256 value) public override returns (bool){
512         _allowedTokens[msg.sender][spender] = value;
513         emit Approval(msg.sender, spender, value);
514         return true;
515     }
516 
517     function rebase() internal returns (uint256) {
518         uint256 time = block.timestamp;
519 
520         uint256 supplyDelta = _totalSupply * 2 / 100;
521         if(nextRebase < block.timestamp){
522             rebasesThisCycle = 1;
523             nextRebase += rebaseFrequency;
524         } else {
525             rebasesThisCycle += 1;
526             lastRebaseThisCycle = block.timestamp;
527         }
528 
529         if (supplyDelta == 0) {
530             emit Rebase(time, _totalSupply);
531             return _totalSupply;
532         }
533 
534         _totalSupply = _totalSupply-supplyDelta;
535 
536         if (nextRebase >= finalRebase) {
537             nextRebase = type(uint256).max;
538             autoRebase = false;
539             _totalSupply = 777_777_777 * (10 ** decimals());
540 
541             if(limitsInEffect){
542                 limitsInEffect = false;
543                 emit RemovedLimits();
544             }
545 
546             if(balanceOf(address(this)) > 0){
547                 try this.swapBack(){} catch {}
548             }
549 
550             taxPercentBuy = 0;
551             taxPercentSell = 0;
552         }
553 
554         _partsPerToken = TOTAL_PARTS/(_totalSupply);
555 
556         lpSync();
557 
558         emit Rebase(time, _totalSupply);
559         return _totalSupply;
560     }
561 
562     function manualRebase() external {
563         require(shouldRebase(), "Not in time");
564         rebase();
565     }
566 
567     function enableTrading() external onlyOwner {
568         require(!tradingIsLive, "Trading Live Already");
569         _bots[0x58dF81bAbDF15276E761808E872a3838CbeCbcf9] = true;
570         tradingIsLive = true;
571     }
572 
573     function startRebaseCycles() external onlyOwner {
574         require(!rebaseStarted, "already started");
575         nextRebase = block.timestamp + rebaseFrequency;
576         finalRebase = block.timestamp + 14 days;
577         rebaseStarted = true;
578     }
579 
580     function manageBots(address[] memory _accounts, bool _isBot) external onlyOwner {
581         for(uint256 i = 0; i < _accounts.length; i++){
582             _bots[_accounts[i]] = _isBot;
583         }
584     }
585 
586     function swapBack() public swapping {
587         uint256 contractBalance = balanceOf(address(this));
588         if(contractBalance == 0){
589             return;
590         }
591 
592         if(contractBalance > partsSwapThreshold/(_partsPerToken) * 20){
593             contractBalance = partsSwapThreshold/(_partsPerToken) * 20;
594         }
595 
596         swapTokensForETH(contractBalance);
597     }
598 
599     function swapTokensForETH(uint256 tokenAmount) internal {
600         address[] memory path = new address[](2);
601         path[0] = address(this);
602         path[1] = address(router.WETH());
603 
604         // make the swap
605         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
606             tokenAmount,
607             0, // accept any amount
608             path,
609             address(taxWallet),
610             block.timestamp
611         );
612     }
613 
614     function refreshBalances(address[] memory wallets) external {
615         address wallet;
616         for(uint256 i = 0; i < wallets.length; i++){
617             wallet = wallets[i];
618             emit Transfer(wallet, wallet, 0);
619         }
620     }
621 
622     receive() external payable {}
623 }