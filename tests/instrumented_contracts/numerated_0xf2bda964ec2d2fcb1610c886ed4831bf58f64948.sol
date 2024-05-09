1 pragma solidity 0.8.7;     
2 // SPDX-License-Identifier: UNLICENSED 
3 
4 contract FEGmath {
5 
6     function btoi(uint256 a)
7         internal pure
8         returns (uint256)
9     {
10         return a / 1e18;
11     }
12 
13     function bfloor(uint256 a)
14         internal pure
15         returns (uint256)
16     {
17         return btoi(a) * 1e18;
18     }
19 
20     function badd(uint256 a, uint256 b)
21         internal pure
22         returns (uint256)
23     {
24         uint256 c = a + b;
25         require(c >= a, "ERR_ADD_OVERFLOW");
26         return c;
27     }
28 
29     function bsub(uint256 a, uint256 b)
30         internal pure
31         returns (uint256)
32     {
33         (uint256 c, bool flag) = bsubSign(a, b);
34         require(!flag, "ERR_SUB_UNDERFLOW");
35         return c;
36     }
37 
38     function bsubSign(uint256 a, uint256 b)
39         internal pure
40         returns (uint, bool)
41     {
42         if (a >= b) {
43             return (a - b, false);
44         } else {
45             return (b - a, true);
46         }
47     }
48 
49     function bmul(uint256 a, uint256 b)
50         internal pure
51         returns (uint256)
52     {
53         uint256 c0 = a * b;
54         require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
55         uint256 c1 = c0 + (1e18 / 2);
56         require(c1 >= c0, "ERR_MUL_OVERFLOW");
57         uint256 c2 = c1 / 1e18;
58         return c2;
59     }
60 
61     function bdiv(uint256 a, uint256 b)
62         internal pure
63         returns (uint256)
64     {
65         require(b != 0, "ERR_DIV_ZERO");
66         uint256 c0 = a * 1e18;
67         require(a == 0 || c0 / a == 1e18, "ERR_DIV_INTERNAL"); // bmul overflow
68         uint256 c1 = c0 + (b / 2);
69         require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
70         uint256 c2 = c1 / b;
71         return c2;
72     }
73 
74     function bpowi(uint256 a, uint256 n)
75         internal pure
76         returns (uint256)
77     {
78         uint256 z = n % 2 != 0 ? a : 1e18;
79 
80         for (n /= 2; n != 0; n /= 2) {
81             a = bmul(a, a);
82 
83             if (n % 2 != 0) {
84                 z = bmul(z, a);
85             }
86         }
87         return z;
88     }
89 
90     function bpow(uint256 base, uint256 exp)
91         internal pure
92         returns (uint256)
93     {
94         require(base >= 1 wei, "ERR_BPOW_BASE_TOO_LOW");
95         require(base <= (2 * 1e18) - 1 wei, "ERR_BPOW_BASE_TOO_HIGH");
96 
97         uint256 whole  = bfloor(exp);
98         uint256 remain = bsub(exp, whole);
99 
100         uint256 wholePow = bpowi(base, btoi(whole));
101 
102         if (remain == 0) {
103             return wholePow;
104         }
105 
106         uint256 partialResult = bpowApprox(base, remain, 1e18 / 1e10);
107         return bmul(wholePow, partialResult);
108     }
109 
110     function bpowApprox(uint256 base, uint256 exp, uint256 precision)
111         internal pure
112         returns (uint256)
113     {
114         uint256 a     = exp;
115         (uint256 x, bool xneg)  = bsubSign(base, 1e18);
116         uint256 term = 1e18;
117         uint256 sum   = term;
118         bool negative = false;
119 
120 
121         for (uint256 i = 1; term >= precision; i++) {
122             uint256 bigK = i * 1e18;
123             (uint256 c, bool cneg) = bsubSign(a, bsub(bigK, 1e18));
124             term = bmul(term, bmul(c, x));
125             term = bdiv(term, bigK);
126             if (term == 0) break;
127 
128             if (xneg) negative = !negative;
129             if (cneg) negative = !negative;
130             if (negative) {
131                 sum = bsub(sum, term);
132             } else {
133                 sum = badd(sum, term);
134             }
135         }
136 
137         return sum;
138     }
139 }
140 
141 contract FMath is FEGmath {
142     
143         function calcSpotPrice(
144         uint256 tokenBalanceIn,
145         uint256 tokenWeightIn,
146         uint256 tokenBalanceOut,
147         uint256 tokenWeightOut,
148         uint256 swapFee
149     )
150         public pure
151         returns (uint256 spotPrice)
152     {
153         uint256 numer = bdiv(tokenBalanceIn, tokenWeightIn);
154         uint256 denom = bdiv(tokenBalanceOut, tokenWeightOut);
155         uint256 ratio = bdiv(numer, denom);
156         uint256 scale = bdiv(10**18, bsub(10**18, swapFee));
157         return  (spotPrice = bmul(ratio, scale));
158     }
159 
160 
161     function calcOutGivenIn(
162         uint256 tokenBalanceIn,
163         uint256 tokenWeightIn,
164         uint256 tokenBalanceOut,
165         uint256 tokenWeightOut,
166         uint256 tokenAmountIn,
167         uint256 swapFee
168     )
169         public pure
170         returns (uint256 tokenAmountOut, uint256 tokenInFee)
171     {
172         uint256 weightRatio = bdiv(tokenWeightIn, tokenWeightOut);
173         uint256 adjustedIn = bsub(10**18, swapFee);
174         adjustedIn = bmul(tokenAmountIn, adjustedIn);
175         uint256 y = bdiv(tokenBalanceIn, badd(tokenBalanceIn, adjustedIn));
176         uint256 foo = bpow(y, weightRatio);
177         uint256 bar = bsub(1e18, foo);
178         tokenAmountOut = bmul(tokenBalanceOut, bar);
179         tokenInFee = bsub(tokenAmountIn, adjustedIn);
180         return (tokenAmountOut, tokenInFee);
181     }
182 
183 
184     function calcInGivenOut(
185         uint256 tokenBalanceIn,
186         uint256 tokenWeightIn,
187         uint256 tokenBalanceOut,
188         uint256 tokenWeightOut,
189         uint256 tokenAmountOut,
190         uint256 swapFee
191     )
192         public pure
193         returns (uint256 tokenAmountIn, uint256 tokenInFee)
194     {
195         uint256 weightRatio = bdiv(tokenWeightOut, tokenWeightIn);
196         uint256 diff = bsub(tokenBalanceOut, tokenAmountOut);
197         uint256 y = bdiv(tokenBalanceOut, diff);
198         uint256 foo = bpow(y, weightRatio);
199         foo = bsub(foo, 1e18);
200         foo = bmul(tokenBalanceIn, foo);
201         tokenAmountIn = bsub(1e18, swapFee);
202         tokenAmountIn = bdiv(foo, tokenAmountIn);
203         tokenInFee = bdiv(foo, 1e18);
204         tokenInFee = bsub(tokenAmountIn, tokenInFee);
205         return (tokenAmountIn, tokenInFee);
206     }
207 }
208 
209 interface IERC20 {
210 
211     function totalSupply() external view returns (uint256);
212     function balanceOf(address whom) external view returns (uint256);
213     function allowance(address src, address dst) external view returns (uint256);
214     function approve(address dst, uint256 amt) external returns (bool);
215     function transfer(address dst, uint256 amt) external returns (bool);
216     function transferFrom(
217         address src, address dst, uint256 amt
218     ) external returns (bool);
219 }
220 
221 interface wrap {
222     function deposit() external payable;
223     function withdraw(uint256 amt) external;
224     function transfer(address recipient, uint256 amount) external returns (bool);
225 }
226 
227 interface swap {
228     function depositInternal(address asset, uint256 amt) external;
229     function payMain(address payee, uint256 amount) external;
230     function payToken(address payee, uint256 amount) external;
231     function BUY(uint256 dot, address to, uint256 minAmountOut) external payable;
232 }
233 
234 library TransferHelper {
235     
236     function safeTransferFrom(address token, address from, address to, uint256 value) internal {
237         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
238         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
239     }
240 
241     function safeTransferETH(address to, uint256 value) internal {
242         (bool success,) = to.call{value:value}(new bytes(0));
243         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
244     }
245 }
246 
247 library Address {
248     
249     function isContract(address account) internal view returns (bool) {
250          bytes32 codehash;
251         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
252         assembly { codehash := extcodehash(account) }
253         return (codehash != accountHash && codehash != 0x0);
254     }
255     
256     function sendValue(address payable recipient, uint256 amount) internal {
257         require(address(this).balance >= amount, "Address: insufficient balance");
258 
259         (bool success, ) = recipient.call{ value: amount }("");
260         require(success, "Address: unable to send value, recipient may have reverted");
261     }
262    
263     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
264       return functionCall(target, data, "Address: low-level call failed");
265     }
266 
267     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
268         return _functionCallWithValue(target, data, 0, errorMessage);
269     }
270 
271     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
272         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
273     }
274 
275     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
276         require(address(this).balance >= value, "Address: insufficient balance for call");
277         return _functionCallWithValue(target, data, value, errorMessage);
278     }
279 
280     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
281         require(isContract(target), "Address: call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
284         if (success) {
285             return returndata;
286         } else {
287             if (returndata.length > 0) {
288                 assembly {
289                     let returndata_size := mload(returndata)
290                     revert(add(32, returndata), returndata_size)
291                 }
292             } else {
293                 revert(errorMessage);
294             }
295         }
296     }
297 }
298 
299 contract LPTokenBase is FEGmath {
300 
301     mapping(address => uint256)                   internal _balance;
302     mapping(address => mapping(address=>uint256)) internal _allowance;
303     uint256 public totalSupply = 0;
304     event Approval(address indexed src, address indexed dst, uint256 amt);
305     event Transfer(address indexed src, address indexed dst, uint256 amt);
306     
307     function _mint(uint256 amt) internal {
308         _balance[address(this)] = badd(_balance[address(this)], amt);
309         totalSupply = badd(totalSupply, amt);
310         emit Transfer(address(0), address(this), amt);
311     }
312 
313     function _burn(uint256 amt) internal {
314         require(_balance[address(this)] >= amt);
315         _balance[address(this)] = bsub(_balance[address(this)], amt);
316         totalSupply = bsub(totalSupply, amt);
317         emit Transfer(address(this), address(0), amt);
318     }
319 
320     function _move(address src, address dst, uint256 amt) internal {
321         require(_balance[src] >= amt);
322         _balance[src] = bsub(_balance[src], amt);
323         _balance[dst] = badd(_balance[dst], amt);
324         emit Transfer(src, dst, amt);
325     }
326 
327     function _push(address to, uint256 amt) internal {
328         _move(address(this), to, amt);
329     }
330 
331     function _pull(address from, uint256 amt) internal {
332         _move(from, address(this), amt);
333     }
334 }
335 
336 contract LPToken is LPTokenBase {
337 
338     string  public name     = "FEXex PRO";
339     string  public symbol   = "LP Token";
340     uint8   public decimals = 18;
341 
342     function allowance(address src, address dst) external view returns (uint256) {
343         return _allowance[src][dst];
344     }
345 
346     function balanceOf(address whom) external view returns (uint256) {
347         return _balance[whom];
348     }
349 
350     function approve(address dst, uint256 amt) external returns (bool) {
351         _allowance[msg.sender][dst] = amt;
352         emit Approval(msg.sender, dst, amt);
353         return true;
354     }
355 
356     function increaseApproval(address dst, uint256 amt) external returns (bool) {
357         _allowance[msg.sender][dst] = badd(_allowance[msg.sender][dst], amt);
358         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
359         return true;
360     }
361 
362     function decreaseApproval(address dst, uint256 amt) external returns (bool) {
363         uint256 oldValue = _allowance[msg.sender][dst];
364         if (amt > oldValue) {
365             _allowance[msg.sender][dst] = 0;
366         } else {
367             _allowance[msg.sender][dst] = bsub(oldValue, amt);
368         }
369         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
370         return true;
371     }
372 }
373 
374 interface FEgexPair {
375     function initialize(address, address, address, address, uint256) external; 
376     function deploySwap (address, uint256, uint256) external;
377     function userBalanceInternal(address _addr) external returns (uint256, uint256);
378 }
379 
380 contract FEGexPRO is LPToken, FMath {
381     using Address for address;
382     struct Record {
383         uint256 index;
384         uint256 balance;
385     }
386     
387     struct userLock {
388         bool setLock; // true = lockedLiquidity, false = unlockedLiquidity
389         uint256 unlockTime;
390     }
391     
392     function getUserLock(address usr) public view returns(bool lock){
393         return (_userlock[usr].setLock);
394     }
395 
396     event LOG_SWAP(
397         address indexed caller,
398         address indexed tokenIn,
399         address indexed tokenOut,
400         uint256         tokenAmountIn,
401         uint256         tokenAmountOut
402 );
403 
404     event LOG_JOIN(
405         address indexed caller,
406         address indexed tokenIn,
407         uint256         tokenAmountIn,
408         uint256         reservesAmount
409 );
410 
411     event LOG_EXIT(
412         address indexed caller,
413         address indexed tokenOut,
414         uint256         tokenAmountOut,
415         uint256         reservesAmount
416     );
417 
418     event LOG_SMARTSWAP(
419         address indexed caller,
420         address indexed tokenIn,
421         address indexed tokenOut,
422         uint256         AmountIn,
423         uint256         AmountOut
424 );
425 
426     event LOG_CALL(
427         bytes4  indexed sig,
428         address indexed caller,
429         bytes           data
430     ) anonymous;
431 
432     modifier _logs_() {
433         emit LOG_CALL(msg.sig, msg.sender, msg.data);
434         _;
435     }
436 
437     uint256 private spec;
438     address private _controller = 0x4c9BC793716e8dC05d1F48D8cA8f84318Ec3043C; 
439     address private _setter = 0x86882FA66aC57039b10D78e2D3205592A44664c0;
440     address private FEG = 0x389999216860AB8E0175387A0c90E5c52522C945;
441     address public _poolOwner = 0x4c9BC793716e8dC05d1F48D8cA8f84318Ec3043C;
442     address public Main = 0xf786c34106762Ab4Eeb45a51B42a62470E9D5332;
443     address public Token = 0x389999216860AB8E0175387A0c90E5c52522C945;
444     address public pairRewardPool = 0x94D4Ac11689C6EbbA91cDC1430fc7dfa9a858753;
445     address public FEGstake = 0x0f8bAA9bf4e0Ebaa9111F07F8125DF66166A1D9E;
446     address public Bonus;
447     uint256 public MAX_BUY_RATIO;
448     uint256 public MAX_SELL_RATIO;
449     uint256 public PSS = 20; // pairRewardPool Share 0.2% default
450     uint256 public RPF = 1000; // Smart Rising Price Floor Setting
451     address[] private _tokens;
452     uint256 public _totalSupply1 = 0;
453     uint256 public _totalSupply2 = 0;
454     uint256 public _totalSupply7 = 0;
455     uint256 public _totalSupply8 = 0;
456     uint256 public totalSentRebates = 0;
457     uint256 public lockedLiquidity = 0;
458     bool public live = false;
459     bool public open = false;
460     mapping(address=>Record) private  _records;
461     mapping(address=>userLock) private  _userlock;
462     mapping(address=>userLock) public  _unlockTime;
463     mapping(address=>bool) private whiteListContract;
464     mapping(address => uint256) private _balances1;
465     mapping(address => uint256) private _balances2;
466     uint256 public constant MAX_RATIO  = 50; // Max ratio for all trades based on liquidity amount
467     uint256 public tx1;
468     uint256 public tx2;
469     uint256 private constant _NOT_ENTERED = 1;
470     uint256 private constant _ENTERED = 2;
471     uint256 private _status = _NOT_ENTERED;
472     event rebate(address indexed user, uint256 amount);
473 
474     modifier nonReentrant() {
475         
476         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
477 
478         _status = _ENTERED;
479 
480         _;
481 
482         _status = _NOT_ENTERED;
483     
484     }
485     
486     receive() external payable {
487     }
488 
489     function userBalanceInternal(address _addr) public view returns(uint256, uint256) {
490         uint256 main  = _balances2[_addr];
491         uint256 token = _balances1[_addr];
492         return (token, main);
493     } 
494     
495     function isContract(address account) internal view returns(bool) {
496         
497         if(IsWhiteListContract(account)) {  return false; }
498         bytes32 codehash;
499         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
500         assembly { codehash := extcodehash(account) }
501         return (codehash != 0x0 && codehash != accountHash);
502     }
503     
504     function addWhiteListContract(address _addy, bool boolean) public {
505         require(msg.sender == _setter, "You do not have permission");
506         whiteListContract[_addy] = boolean;
507     }
508     
509     function IsWhiteListContract(address _addy) public view returns(bool){
510         return whiteListContract[_addy];
511     }
512     
513     modifier noContract() {
514         require(isContract(msg.sender) == false, "Unapproved contracts are not allowed to interact with the swap");
515         _;
516     }
517     
518     function setMaxBuySellRatio(uint256 sellmax, uint256 buymax) public {
519         require(msg.sender == _poolOwner, "You do not have permission");
520         uint256 tib = _records[Token].balance;
521         uint256 tob = _records[Main].balance;
522         require (sellmax >= 1e23 && sellmax <= tib, "min 10 T FEG, max 100% of liquidity"); 
523         require (buymax >= 100e18 && buymax <= tob, "min 100 ETH, max 100% of liquidity");
524         MAX_SELL_RATIO = sellmax;
525         MAX_BUY_RATIO = buymax;
526     }
527     
528     function openit() public{ // Since only sets to true, trading can never be turned off
529         require(msg.sender == _poolOwner);
530         open = true;
531     }
532     
533     function setBonus(address _bonus) public{ // For tokens that have a 3rd party token reflection
534         require(msg.sender == _poolOwner && _bonus != Main  && _bonus != Token, "Not permitted");
535         Bonus = _bonus;
536     }
537     
538     function setStakePool(address _stake) public {
539         require(msg.sender == _setter && _stake != address(0), "You do not have permission");
540         FEGstake = _stake;
541     }
542     
543     function setPairRewardPool(address _addy) public { // Gives ability to move rewards to future staking protocols 
544         require(msg.sender == _setter, "You do not have permission");
545         pairRewardPool = _addy;
546     }
547 
548     function getBalance(address token)
549         external view
550         returns (uint256)
551     {
552         
553         return _records[token].balance;
554     }
555 
556     function setCont(address manager, address set, address ad)
557         external
558     {
559         require(msg.sender == _controller, "You do not have permission");
560         require(manager != address(0) && set != address(0), "Cannot set 0 address");
561         _controller = manager;
562         _setter = set;
563         _poolOwner = ad; // Incase pool owner wallet was compromised and needs new access
564     }
565     
566     function setLockLiquidity() nonReentrant public { //
567         address user;
568         user = msg.sender;
569         bool loc = getUserLock(user);
570         require(loc == false, "Liquidity already locked");
571         uint256 total = IERC20(address(this)).balanceOf(user);
572         userLock storage ulock = _userlock[user];
573         userLock storage time = _unlockTime[user];
574         ulock.setLock = true;
575         time.unlockTime = block.timestamp + 90 days; 
576         lockedLiquidity += total;
577     }
578     
579     function deploySwap (uint256 liqmain, uint256 liqtoken, uint256 ol)
580         external
581         {
582         require(live == false, "Can only use once");
583         require(msg.sender == _poolOwner, "No permissions");
584         address _from = msg.sender;
585         spec = ol;
586         _pullUnderlying(Main, msg.sender, liqmain);
587         _pullUnderlying(Token, msg.sender, liqtoken);
588         MAX_SELL_RATIO = 5000000000000e9;
589         MAX_BUY_RATIO = 300e18;
590         uint256 much = IERC20(Token).balanceOf(address(this));
591         uint256 much1 = IERC20(Main).balanceOf(address(this));
592         
593         _records[Token] = Record({
594             index: _tokens.length,
595             balance: much
596             
597         });
598         
599         _records[Main] = Record({
600             index: _tokens.length,
601             balance: much1
602         });
603         
604         _tokens.push(Token);
605         _tokens.push(Main);
606         uint256 a = bdiv(_records[Token].balance, 1e9);
607         uint256 b = bdiv(_records[Main].balance, 1e18);
608         _mint(badd(a, b));
609         lockedLiquidity = badd(lockedLiquidity, badd(a, b));
610         _push(_from, badd(a, b)); 
611         userLock storage ulock = _userlock[_from];
612         userLock storage time = _unlockTime[_from];
613         ulock.setLock = true;
614         time.unlockTime = block.timestamp + 365 days; 
615         live = true;
616         PSS = 30;
617         tx1 = bmul(100, bdiv(much, liqtoken)); 
618         tx2 = bmul(100, bdiv(much1, liqmain)); 
619     }
620    
621     function getSpotPrice(address tokenIn, address tokenOut)
622         public view
623         returns (uint256 spotPrice)
624     {
625         
626         Record storage inRecord = _records[address(tokenIn)];
627         Record storage outRecord = _records[address(tokenOut)];
628         return calcSpotPrice(inRecord.balance, bmul(1e18, 25), outRecord.balance, bmul(1e18, 25), 2e15);
629         
630     }
631         
632     function depositInternal(address asset, uint256 amt)  external nonReentrant {
633         require(asset == Main || asset == Token);
634         require(open == true, "Swap not opened");
635         
636         if(asset == Token){
637         uint256 bef = _records[Token].balance;     
638         _pullUnderlying(Token, msg.sender, amt);
639         uint256 aft = bsub(IERC20(Token).balanceOf(address(this)), _totalSupply1);  
640         uint256 finalAmount = bsub(aft, bef);  
641         _totalSupply1 = badd(_totalSupply1, finalAmount);
642         _balances1[msg.sender] = badd(_balances1[msg.sender], finalAmount);
643         }
644         else{
645         uint256 bef = _records[Main].balance;
646         _pullUnderlying(Main, msg.sender, amt);
647         uint256 aft = bsub(IERC20(Main).balanceOf(address(this)), badd(_totalSupply2, badd(_totalSupply7, _totalSupply8)));
648         uint256 finalAmount = bsub(aft, bef);
649         _totalSupply2 = badd(_totalSupply2, finalAmount);
650         _balances2[msg.sender] = badd(_balances2[msg.sender], finalAmount);
651         }
652         payStake();
653     }
654 
655     function withdrawInternal(address asset, uint256 amt) external nonReentrant {
656         require(asset == Main || asset == Token);
657         
658         if(asset == Token){
659         require(_balances1[msg.sender] >= amt, "Not enough Token");
660         _totalSupply1 -= amt;
661         _balances1[msg.sender] -= amt;
662         _pushUnderlying(Token, msg.sender, amt);
663         }
664         else{
665         require(_balances2[msg.sender] >= amt, "Not enough Main");
666         _totalSupply2 -= amt;
667         _balances2[msg.sender] -= amt;
668         _pushUnderlying(Main, msg.sender, amt);
669         }
670         payStake();
671     }
672 
673     function swapToSwap(address path, address asset, address to, uint256 amt) external nonReentrant {
674         require(asset == Main || asset == Token);
675         
676         if(asset == Main){
677         require(_balances2[msg.sender] >= amt, "Not enough Main");
678         IERC20(address(Main)).approve(address(path), amt);   
679         _totalSupply2 -= amt;
680         _balances2[msg.sender] -= amt;
681         swap(path).depositInternal(Main, amt);
682         (uint256 tokens, uint256 mains) = FEgexPair(path).userBalanceInternal(address(this));
683         swap(path).payMain(to, mains);
684         tokens = 0;
685         }
686     
687         else{
688         require(_balances1[msg.sender] >= amt, "Not enough Token");
689         IERC20(address(Token)).approve(address(path), amt);
690         _totalSupply1 -= amt;
691         _balances1[msg.sender] -= amt;
692         swap(path).depositInternal(Token, amt);
693         (uint256 tokens, uint256 mains) = FEgexPair(path).userBalanceInternal(address(this));
694         swap(path).payToken(to, tokens);
695         mains = 0;
696         }
697         payStake();
698     }
699     
700     function transfer(address dst, uint256 amt) external returns(bool) {
701         bool loc = getUserLock(msg.sender);
702         require(loc == false, "Liquidity is locked, you cannot remove liquidity until after lock time.");
703         _move(msg.sender, dst, amt);
704         return true;
705     }
706 
707     function transferFrom(address src, address dst, uint256 amt) external returns(bool) {
708         require(msg.sender == src || amt <= _allowance[src][msg.sender]);
709         bool loc = getUserLock(msg.sender);
710         require(loc == false, "Liquidity is locked, you cannot remove liquidity until after lock time.");
711         _move(src, dst, amt);
712         if (msg.sender != src && _allowance[src][msg.sender] != type(uint256).max) {
713             _allowance[src][msg.sender] = bsub(_allowance[src][msg.sender], amt);
714             emit Approval(msg.sender, dst, _allowance[src][msg.sender]);
715         }
716         return true;
717     }
718     
719     function addBothLiquidity(uint256 poolAmountOut, uint[] calldata maxAmountsIn)
720     nonReentrant
721         external
722     {
723         sync();
724         uint256 poolTotal = totalSupply;
725         uint256 ratio = bdiv(poolAmountOut, poolTotal);
726         require(ratio != 0, "ERR_MATH_APPROX");
727         
728         
729         bool loc = getUserLock(msg.sender);
730         if(loc == true){
731         lockedLiquidity += poolAmountOut;    
732         }
733         
734         for (uint256 i = 0; i < _tokens.length; i++) {
735             address t = _tokens[i];
736             uint256 bal = _records[t].balance;
737             
738             uint256 tokenAmountIn = bmul(ratio, bal); 
739             require(tokenAmountIn != 0, "ERR_MATH_APPROX");
740             require(tokenAmountIn <= maxAmountsIn[i], "ERR_LIMIT_IN");
741             emit LOG_JOIN(msg.sender, t, tokenAmountIn, 0);
742             _pullUnderlying(t, msg.sender, tokenAmountIn);
743         }
744         payStake();
745         sync();
746         _mint(poolAmountOut);
747         _push(msg.sender, poolAmountOut);
748     }
749    
750     function removeBothLiquidity(uint256 poolAmountIn, uint[] calldata minAmountsOut)
751     nonReentrant
752         external
753     {
754         bool loc = getUserLock(msg.sender);
755         require(loc == false, "Liquidity is locked, you cannot remove liquidity until after lock time.");
756         sync();
757         uint256 poolTotal = totalSupply;
758         uint256 ratio = bdiv(poolAmountIn, poolTotal);
759         require(ratio != 0, "ERR_MATH_APPROX");
760 
761         _pull(msg.sender, poolAmountIn);
762         _burn(poolAmountIn);
763         
764         for (uint256 i = 0; i < _tokens.length; i++) {
765             address t = _tokens[i];
766             uint256 bal = _records[t].balance;
767             uint256 tokenAmountOut = bmul(ratio, bal);
768             require(tokenAmountOut != 0, "ERR_MATH_APPROX");
769             require(tokenAmountOut >= minAmountsOut[i], "Minimum amount out not met");
770             emit LOG_EXIT(msg.sender, t, tokenAmountOut, 0);
771             _pushUnderlying(t, msg.sender, tokenAmountOut);
772         }
773         sync();
774         
775         if(Bonus != address(0)){
776         uint256 bal1 = bmul(ratio, IERC20(Bonus).balanceOf(address(this)));
777         if(bal1 > 0){
778         _pushUnderlying(Bonus, msg.sender, bal1);
779         }
780         }
781     }
782     
783     function sendRebate() internal {
784         uint256 re = address(this).balance / 8;
785         TransferHelper.safeTransferETH(msg.sender, re);
786         totalSentRebates += re;
787         emit rebate(msg.sender, re);
788     }
789     
790     function BUYSmart(
791         uint256 tokenAmountIn,
792         uint256 minAmountOut
793     )  nonReentrant
794         external 
795         returns(uint256 tokenAmountOut)
796     {
797 
798         require(_balances2[msg.sender] >= tokenAmountIn, "Not enough Main, deposit more");
799         
800         uint256 hold = IERC20(FEG).balanceOf(address(msg.sender));
801         uint256 io = address(this).balance;
802         
803         if(io > 0 && tokenAmountIn >= 5e16 && hold >= 2e19){
804         sendRebate();
805         }
806         
807         Record storage inRecord = _records[address(Main)];
808         Record storage outRecord = _records[address(Token)];
809 
810         require(tokenAmountIn <= MAX_BUY_RATIO, "ERR_BUY_IN_RATIO");
811         require(tokenAmountOut <= bmul(outRecord.balance, bdiv(MAX_RATIO, 100)), "Over MAX_OUT_RATIO");
812         
813         uint256 tokenInFee;
814         (tokenAmountOut, tokenInFee) = calcOutGivenIn(
815                                             inRecord.balance,
816                                             bmul(1e18, 25),
817                                             outRecord.balance,
818                                             bmul(1e18, 25),
819                                             bmul(tokenAmountIn, bdiv(999, 1000)),
820                                             0
821                                         );
822                                         
823         require(tokenAmountOut >= minAmountOut, "Minimum amount out not met");   
824         emit LOG_SMARTSWAP(msg.sender, Main, Token, tokenAmountIn, tokenAmountOut);
825         _balances2[msg.sender] -= tokenAmountIn;
826         _totalSupply2 -= tokenAmountIn;
827         _balances1[msg.sender] += tokenAmountOut;
828         _totalSupply1 += tokenAmountOut;
829         _totalSupply8 += bmul(tokenAmountIn, bdiv(1, 1000));
830         sync();
831         
832         return(tokenAmountOut);
833     }
834     
835     function BUY(
836         uint256 dot,
837         address to,
838         uint256 minAmountOut
839     ) nonReentrant 
840         external payable
841         returns(uint256 tokenAmountOut)
842     {
843         
844         require(open == true, "Swap not opened");
845         wrap(Main).deposit{value: msg.value}();
846         if(Address.isContract(msg.sender) == true){ 
847         require(dot == spec, "Contracts are not allowed to interact with the Swap");
848         }
849         
850         uint256 hold = IERC20(FEG).balanceOf(address(msg.sender));
851         uint256 io = address(this).balance;
852         
853         if(io > 0 && msg.value >= 5e16 && hold >= 2e19){
854         sendRebate();
855         }
856         
857         Record storage inRecord = _records[address(Main)];
858         Record storage outRecord = _records[address(Token)];
859         
860         require(msg.value <= MAX_BUY_RATIO, "ERR_BUY_IN_RATIO");
861         require(tokenAmountOut <= bmul(outRecord.balance, bdiv(MAX_RATIO, 100)), "Over MAX_OUT_RATIO");
862         
863         uint256 tokenInFee;
864         (tokenAmountOut, tokenInFee) = calcOutGivenIn(
865                                             inRecord.balance,
866                                             bmul(1e18, 25),
867                                             outRecord.balance,
868                                             bmul(1e18, 25),
869                                             bmul(msg.value, bdiv(999, 1000)),
870                                             0
871                                         );
872                                         
873         require(tokenAmountOut >= minAmountOut, "Minimum amount out not met");
874         uint256 oi = bmul(msg.value, bdiv(1, 1000));
875         _totalSupply8 += bmul(oi, bdiv(tx2, 100));
876         _pushUnderlying(Token, to, tokenAmountOut);
877         sync();
878 
879         emit LOG_SWAP(msg.sender, Main, Token, msg.value, bmul(tokenAmountOut, bdiv(tx1, 100)));
880         return(tokenAmountOut);
881     }
882 
883     function SELL(
884         uint256 dot,
885         address to,
886         uint256 tokenAmountIn,
887         uint256 minAmountOut
888     )  nonReentrant 
889         external
890         returns(uint256 tokenAmountOut)
891     {
892         
893         require(open == true, "Swap not opened");
894         if(Address.isContract(msg.sender) == true){ 
895         require(dot == spec, "Contracts are not allowed to interact with the Swap");
896         }
897         
898         uint256 hold = IERC20(FEG).balanceOf(address(msg.sender));
899         if(address(this).balance > 0 && hold >= 2e19 && tokenAmountOut <= 1e18){
900         sendRebate();
901         }
902         
903         uint256 omm = _records[Token].balance;
904         _pullUnderlying(Token, msg.sender, tokenAmountIn);
905         setTokenBalance();
906         uint256 trueamount = bmul((_records[Token].balance - omm), bdiv(998, 1000));
907         require(tokenAmountIn <= MAX_SELL_RATIO, "ERR_SELL_RATIO");
908         require(tokenAmountOut <= bmul(_records[Main].balance, bdiv(MAX_RATIO, 100)), "Over MAX_OUT_RATIO"); 
909         
910         uint256 tokenInFee;
911         (tokenAmountOut, tokenInFee) = calcOutGivenIn(
912                                             omm,
913                                             bmul(1e18, 25),
914                                             _records[Main].balance,
915                                             bmul(1e18, 25),
916                                             trueamount,
917                                             2e15
918                                         );
919                                          
920         require(tokenAmountOut >= minAmountOut, "Minimum amount out not met");
921         uint256 toka = bmul(tokenAmountOut, bdiv(RPF, 1000));
922         uint256 tokAmountI  = bmul(toka, bdiv(15, 10000));
923         uint256 tok = bmul(toka, bdiv(15, 10000));
924         uint256 tokAmountI2 =  bmul(toka, bdiv(PSS, 10000));
925         uint256 io = (toka - (tokAmountI + tok + tokAmountI2));
926         uint256 tokAmountI1 = bmul(io, bdiv(999, 1000));
927         uint256 ox = _balances2[address(this)];
928         if(ox > 1e15){
929         _totalSupply2 -= ox;
930         _balances2[address(this)] = 0;
931         }
932         
933         wrap(Main).withdraw(tokAmountI1 + ox + tokAmountI);
934         TransferHelper.safeTransferETH(to, bmul(tokAmountI1, bdiv(99, 100)));
935         _totalSupply8 += bmul(io, bdiv(1, 1000));
936         _balances2[pairRewardPool] += tokAmountI2;
937         _totalSupply2 += tokAmountI2;
938         _totalSupply7 += tok;
939         addRebate();
940         setMainBalance(); 
941         emit LOG_SWAP(msg.sender, Token, Main, trueamount, bmul(tokAmountI1, bdiv(tx2, 100)));
942         return tokenAmountOut;
943     }
944     
945      function SELLSmart(
946         uint256 tokenAmountIn,
947         uint256 minAmountOut
948     )  nonReentrant
949         external
950         returns(uint256 tokenAmountOut)
951     {
952         uint256 hold = IERC20(FEG).balanceOf(address(msg.sender));
953         if(address(this).balance > 0 && hold >= 2e19 && tokenAmountOut <= 1e18){
954         sendRebate();
955         }
956         
957         uint256 tai = tokenAmountIn;
958         require(_balances1[msg.sender] >= tai, "Not enough Token");
959         Record storage inRecord = _records[address(Token)];
960         Record storage outRecord = _records[address(Main)];
961         require(tai <= MAX_SELL_RATIO, "ERR_SELL_RATIO");
962         require(tokenAmountOut <= bmul(outRecord.balance, bdiv(MAX_RATIO, 100)), "Over MAX_OUT_RATIO");
963         
964         uint256 tokenInFee;
965         (tokenAmountOut, tokenInFee) = calcOutGivenIn(
966                                             inRecord.balance,
967                                             bmul(1e18, 25),
968                                             outRecord.balance,
969                                             bmul(1e18, 25),
970                                             bmul(tai, bdiv(998, 1000)),
971                                             2e15
972                                         );
973         
974         uint256 toka = bmul(tokenAmountOut, bdiv(RPF, 1000));
975         uint256 tokAmountI  = bmul(toka, bdiv(15, 10000));
976         uint256 tok = bmul(toka, bdiv(15, 10000));
977         uint256 tokAmountI2 =  bmul(toka, bdiv(PSS, 10000));
978         uint256 io = (toka - (tokAmountI + tok + tokAmountI2));
979         uint256 tokAmountI1 = bmul(io, bdiv(999, 1000));
980         emit LOG_SMARTSWAP(msg.sender, Token, Main, tai, tokAmountI1);
981         _totalSupply8 += bmul(io, bdiv(1, 1000));
982         require(tokAmountI1 >= minAmountOut, "Minimum amount out not met");
983         _balances1[msg.sender] -= tai;
984         _totalSupply1 -= tai;
985         _balances2[msg.sender] += tokAmountI1;
986         _balances2[address(this)] += tokAmountI;
987         _balances2[pairRewardPool] += tokAmountI2;
988         _totalSupply2 += (tokAmountI + tokAmountI2 + tokAmountI1);
989         _totalSupply7 += tok;
990         sync();
991         addRebate();
992         return(tokenAmountOut);
993     }
994     
995     function sync() public {  // updates the liquidity to current state
996     setTokenBalance();
997     setMainBalance();
998     }
999     
1000     function setTokenBalance() internal {
1001         _records[Token].balance = IERC20(Token).balanceOf(address(this)) - _totalSupply1;  
1002     }
1003         
1004     function setMainBalance() internal {
1005         uint256 al = (_totalSupply2 +_totalSupply7 + _totalSupply8);
1006         _records[Main].balance = IERC20(Main).balanceOf(address(this)) - al;
1007     }
1008         
1009     function setRPF(uint256 _PSS, uint256 _RPF ) external {
1010         require(msg.sender == _poolOwner, "You do not have permission");
1011         require(_PSS <= 50 && _PSS != 0, " Cannot set over 0.5%"); 
1012         require(_RPF >= 990 && _RPF <= 1000, " Cannot set over 1%"); 
1013         RPF = _RPF;
1014         PSS = _PSS;
1015     }
1016     
1017     function releaseLiquidity() nonReentrant external { // Allows removal of liquidity after the lock period is over
1018         address user = msg.sender;
1019         bool loc = getUserLock(user);
1020         require(loc == true, "Liquidity not locked");
1021         uint256 total = IERC20(address(this)).balanceOf(user);
1022         lockedLiquidity -= total;
1023         userLock storage ulock = _userlock[user];
1024         userLock storage time = _unlockTime[user];
1025         require (block.timestamp >= time.unlockTime, "Liquidity is locked, you cannot remove liquidity until after lock time.");
1026         ulock.setLock = false; 
1027     }
1028     
1029     function initializeMigrate(address user) external { //Incase we upgrade to v3 in the future, will offer a 48 hour time delay to allow releasing liquidity for migration to new pools.
1030         require(msg.sender == _controller, "You do not have permission");
1031         bool loc = getUserLock(user);
1032         require(loc == true, "Liquidity not locked");
1033         userLock storage time = _unlockTime[user];
1034         time.unlockTime = block.timestamp + 2 days; 
1035     }
1036 
1037     function _pullUnderlying(address erc20, address from, uint256 amount)
1038         internal
1039     {   
1040         bool xfer = IERC20(erc20).transferFrom(from, address(this), amount);
1041         require(xfer, "ERR_ERC20_FALSE");
1042     }
1043 
1044     function _pushUnderlying(address erc20, address to, uint256 amount)
1045         internal
1046     {   
1047         bool xfer = IERC20(erc20).transfer(to, amount);
1048         require(xfer, "ERR_ERC20_FALSE");
1049     }
1050     
1051     function payStake() internal {
1052         if(_totalSupply7 > 5e15) {
1053         bool xfer = IERC20(Main).transfer(FEGstake, _totalSupply7);
1054         require(xfer, "ERR_ERC20_FALSE");
1055         _totalSupply7 = 0;
1056         }
1057     }
1058     
1059     function addRebate()
1060         internal
1061     {   
1062         if(_totalSupply8 > 5e15){
1063         wrap(Main).withdraw(_totalSupply8);
1064         _totalSupply8 = 0;
1065         }
1066     }
1067     
1068     function payMain(address payee, uint256 amount)
1069         external nonReentrant 
1070         
1071     {   
1072         require(_balances2[msg.sender] >= amount, "Not enough token");
1073         uint256 amt = bmul(amount, bdiv(997, 1000));
1074         uint256 amt1 = bsub(amount, amt);
1075         _balances2[msg.sender] -= amount;
1076         _balances2[payee] += amt;
1077         _balances2[_controller] += amt1;
1078     }
1079     
1080     function payToken(address payee, uint256 amount)
1081         external nonReentrant 
1082         
1083     {
1084         require(_balances1[msg.sender] >= amount, "Not enough token");
1085         uint256 amt = bmul(amount, bdiv(997, 1000));
1086         uint256 amt1 = bsub(amount, amt);
1087         _balances1[msg.sender] -= amount;
1088         _balances1[payee] += amt;
1089         _balances1[_controller] += amt1;
1090     }
1091 }