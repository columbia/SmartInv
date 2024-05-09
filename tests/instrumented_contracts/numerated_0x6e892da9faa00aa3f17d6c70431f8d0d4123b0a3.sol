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
183     function calcOutGivenIn1(
184         uint256 tokenBalanceIn,
185         uint256 tokenWeightIn,
186         uint256 tokenBalanceOut,
187         uint256 tokenWeightOut,
188         uint256 tokenAmountIn
189     )
190         public pure
191         returns (uint256 tokenAmountOut)
192     {
193         uint256 weightRatio = bdiv(tokenWeightIn, tokenWeightOut);
194         uint256 adjustedIn = bsub(10**18, 0);
195         adjustedIn = bmul(tokenAmountIn, adjustedIn);
196         uint256 y = bdiv(tokenBalanceIn, badd(tokenBalanceIn, adjustedIn));
197         uint256 foo = bpow(y, weightRatio);
198         uint256 bar = bsub(1e18, foo);
199         tokenAmountOut = bmul(tokenBalanceOut, bar);
200         return tokenAmountOut;
201     }
202 
203     function calcInGivenOut(
204         uint256 tokenBalanceIn,
205         uint256 tokenWeightIn,
206         uint256 tokenBalanceOut,
207         uint256 tokenWeightOut,
208         uint256 tokenAmountOut,
209         uint256 swapFee
210     )
211         public pure
212         returns (uint256 tokenAmountIn, uint256 tokenInFee)
213     {
214         uint256 weightRatio = bdiv(tokenWeightOut, tokenWeightIn);
215         uint256 diff = bsub(tokenBalanceOut, tokenAmountOut);
216         uint256 y = bdiv(tokenBalanceOut, diff);
217         uint256 foo = bpow(y, weightRatio);
218         foo = bsub(foo, 1e18);
219         foo = bmul(tokenBalanceIn, foo);
220         tokenAmountIn = bsub(1e18, swapFee);
221         tokenAmountIn = bdiv(foo, tokenAmountIn);
222         tokenInFee = bdiv(foo, 1e18);
223         tokenInFee = bsub(tokenAmountIn, tokenInFee);
224         return (tokenAmountIn, tokenInFee);
225     }
226 }
227 
228 interface IERC20 {
229 
230     function totalSupply() external view returns (uint256);
231     function balanceOf(address whom) external view returns (uint256);
232     function allowance(address src, address dst) external view returns (uint256);
233     function approve(address dst, uint256 amt) external returns (bool);
234     function transfer(address dst, uint256 amt) external returns (bool);
235     function transferFrom(
236         address src, address dst, uint256 amt
237     ) external returns (bool);
238 }
239 
240 interface wrap {
241     function deposit() external payable;
242     function withdraw(uint256 amt) external;
243     function transfer(address recipient, uint256 amount) external returns (bool);
244 }
245 
246 interface swap {
247     function depositInternal(address asset, uint256 amt) external;
248     function payMain(address payee, uint256 amount) external;
249     function payToken(address payee, uint256 amount) external;
250     function BUY(uint256 dot, address to, uint256 minAmountOut) external payable;
251 }
252 
253 library TransferHelper {
254     
255     function safeTransferFrom(address token, address from, address to, uint256 value) internal {
256         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
257         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
258     }
259 
260     function safeTransferETH(address to, uint256 value) internal {
261         (bool success,) = to.call{value:value}(new bytes(0));
262         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
263     }
264 }
265 
266 library Address {
267     
268     function isContract(address account) internal view returns (bool) {
269          bytes32 codehash;
270         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
271         assembly { codehash := extcodehash(account) }
272         return (codehash != accountHash && codehash != 0x0);
273     }
274     
275     function sendValue(address payable recipient, uint256 amount) internal {
276         require(address(this).balance >= amount, "Address: insufficient balance");
277 
278         (bool success, ) = recipient.call{ value: amount }("");
279         require(success, "Address: unable to send value, recipient may have reverted");
280     }
281    
282     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
283       return functionCall(target, data, "Address: low-level call failed");
284     }
285 
286     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
287         return _functionCallWithValue(target, data, 0, errorMessage);
288     }
289 
290     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
292     }
293 
294     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
295         require(address(this).balance >= value, "Address: insufficient balance for call");
296         return _functionCallWithValue(target, data, value, errorMessage);
297     }
298 
299     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
300         require(isContract(target), "Address: call to non-contract");
301 
302         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
303         if (success) {
304             return returndata;
305         } else {
306             if (returndata.length > 0) {
307                 assembly {
308                     let returndata_size := mload(returndata)
309                     revert(add(32, returndata), returndata_size)
310                 }
311             } else {
312                 revert(errorMessage);
313             }
314         }
315     }
316 }
317 
318 contract LPTokenBase is FEGmath {
319 
320     mapping(address => uint256)                   internal _balance;
321     mapping(address => mapping(address=>uint256)) internal _allowance;
322     uint256 public totalSupply = 0;
323     event Approval(address indexed src, address indexed dst, uint256 amt);
324     event Transfer(address indexed src, address indexed dst, uint256 amt);
325     
326     function _mint(uint256 amt) internal {
327         _balance[address(this)] = badd(_balance[address(this)], amt);
328         totalSupply = badd(totalSupply, amt);
329         emit Transfer(address(0), address(this), amt);
330     }
331 
332     function _move(address src, address dst, uint256 amt) internal {
333         require(_balance[src] >= amt);
334         _balance[src] = bsub(_balance[src], amt);
335         _balance[dst] = badd(_balance[dst], amt);
336         emit Transfer(src, dst, amt);
337     }
338 
339     function _push(address to, uint256 amt) internal {
340         _move(address(this), to, amt);
341     }
342 }
343 
344 contract LPToken is LPTokenBase {
345 
346     string  public name     = "FEGex PRO";
347     string  public symbol   = "LP Token";
348     uint8   public decimals = 18;
349 
350     function allowance(address src, address dst) external view returns (uint256) {
351         return _allowance[src][dst];
352     }
353 
354     function balanceOf(address whom) external view returns (uint256) {
355         return _balance[whom];
356     }
357 
358     function approve(address dst, uint256 amt) external returns (bool) {
359         _allowance[msg.sender][dst] = amt;
360         emit Approval(msg.sender, dst, amt);
361         return true;
362     }
363 
364     function increaseApproval(address dst, uint256 amt) external returns (bool) {
365         _allowance[msg.sender][dst] = badd(_allowance[msg.sender][dst], amt);
366         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
367         return true;
368     }
369 
370     function decreaseApproval(address dst, uint256 amt) external returns (bool) {
371         uint256 oldValue = _allowance[msg.sender][dst];
372         if (amt > oldValue) {
373             _allowance[msg.sender][dst] = 0;
374         } else {
375             _allowance[msg.sender][dst] = bsub(oldValue, amt);
376         }
377         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
378         return true;
379     }
380 }
381 
382 
383 interface FEGexPair {
384     function initialize(address, address, address, address, uint256) external; 
385     function deploySwap(address, uint256) external;
386     function userBalanceInternal(address _addr) external returns (uint256, uint256);
387 }
388 
389 interface newDeployer {
390     function createPair(address token, uint256 liqmain, uint256 liqtoken, address owner) external;
391 }
392 
393 contract FEGexPRO is LPToken, FMath {
394     using Address for address;
395     struct Record {
396         uint256 index;
397         uint256 balance;
398     }
399     
400     struct userLock {
401         bool setLock; // true = lockedLiquidity, false = unlockedLiquidity
402         uint256 unlockTime; // time liquidity can be released
403     }
404     
405     function getUserLock(address usr) public view returns(bool lock){
406         return (_userlock[usr].setLock);
407     }
408 
409     event LOG_SWAP(
410         address indexed caller,
411         address indexed tokenIn,
412         address indexed tokenOut,
413         uint256         tokenAmountIn,
414         uint256         tokenAmountOut
415 );
416 
417     event LOG_JOIN(
418         address indexed caller,
419         address indexed tokenIn,
420         uint256         tokenAmountIn,
421         uint256         reservesAmount
422 );
423 
424     event LOG_EXIT(
425         address indexed caller,
426         address indexed tokenOut,
427         uint256         tokenAmountOut,
428         uint256         reservesAmount
429     );
430 
431     event LOG_SMARTSWAP(
432         address indexed caller,
433         address indexed tokenIn,
434         address indexed tokenOut,
435         uint256         AmountIn,
436         uint256         AmountOut
437 );
438 
439     uint256 private spec;
440     address private _controller = 0x4c9BC793716e8dC05d1F48D8cA8f84318Ec3043C; 
441     address private _setter = 0x86882FA66aC57039b10D78e2D3205592A44664c0;
442     address private fegp;
443     address private FEG = 0x389999216860AB8E0175387A0c90E5c52522C945;
444     address private burn = 0x000000000000000000000000000000000000dEaD;
445     address public _poolOwner;
446     address public Main = 0xf786c34106762Ab4Eeb45a51B42a62470E9D5332;
447     address private newDep;
448     address public Token;
449     address public pairRewardPool;
450     address private FEGstake;
451     address public Bonus;
452     uint256 public MAX_BUY_RATIO = 100e18;
453     uint256 public MAX_SELL_RATIO;
454     uint256 public PSS = 20; // pairRewardPool Share 0.2% default
455     uint256 public RPF = 1000; // Smart Rising Price Floor Setting
456     address[] private _tokens;
457     uint256 public _totalSupply1;
458     uint256 public _totalSupply2;
459     uint256 public _totalSupply7;
460     uint256 public _totalSupply8;
461     uint256 public lockedLiquidity;
462     uint256 public totalSentRebates;
463     bool private live = false;
464     //bool private on = true;
465     bool public open = false;
466     mapping(address=>Record) private  _records;
467     mapping(address=>userLock) private  _userlock;
468     mapping(address=>userLock) public  _unlockTime;
469     mapping(address=>bool) private whiteListContract;
470     mapping(address => uint256) private _balances1;
471     mapping(address => uint256) private _balances2;
472     uint256 private constant MAX_RATIO  = 50; // Max ratio for all trades based on liquidity amount
473     uint256 public tx1;
474     uint256 public tx2 = 99;
475     uint256 private status = 0;
476    
477     function initialize( address _token1, address owner, address _made, address _fegp, uint256 ol) external{
478         require(live == false, "Can only use once");
479         Token = _token1;
480         _poolOwner = owner;
481         pairRewardPool = owner;
482         spec = ol;
483         fegp = _fegp;
484         FEGstake = _made;
485         MAX_SELL_RATIO = bmul(IERC20(Token).totalSupply(), bdiv(1, 20));
486     }
487     
488     receive() external payable {
489     }
490 
491     function userBalanceInternal(address _addr) public view returns(uint256, uint256) {
492         uint256 main  = _balances2[_addr];
493         uint256 token = _balances1[_addr];
494         return (token, main);
495     } 
496     
497     function isContract(address account) internal view returns(bool) {
498         
499         if(IsWhiteListContract(account)) {  return false; }
500         bytes32 codehash;
501         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
502         assembly { codehash := extcodehash(account) }
503         return (codehash != 0x0 && codehash != accountHash);
504     }
505     
506     function addWhiteListContract(address _addy, bool boolean) public {
507         require(msg.sender == _setter);
508         whiteListContract[_addy] = boolean;
509     }
510     
511     function IsWhiteListContract(address _addy) public view returns(bool){
512         return whiteListContract[_addy];
513     }
514     
515     modifier noContract() {
516         require(isContract(msg.sender) == false, "Unapproved contracts are not allowed to interact with the swap");
517         _;
518     }
519     
520     function sync() public {  // updates the liquidity to current state
521         _records[Token].balance = IERC20(Token).balanceOf(address(this)) - _totalSupply1;  
522         uint256 al = (_totalSupply2 + _totalSupply7 + _totalSupply8);
523         _records[Main].balance = IERC20(Main).balanceOf(address(this)) - al;
524     }
525     
526     function setMaxBuySellRatio(uint256 sellmax, uint256 buymax) public {
527         require(msg.sender == _poolOwner, "You do not have permission");
528         uint256 tob = IERC20(Token).totalSupply();
529         require (sellmax >= tob/1000 && sellmax <= tob, "min 0.1% of token supply, max 100% of token supply"); 
530         require (buymax >= 1e18, "1 BNB minimum");
531         MAX_SELL_RATIO = sellmax;
532         MAX_BUY_RATIO = buymax;
533     }
534     
535     function openit() public{ // Since only sets to true, trading can never be turned off
536         require(msg.sender == _poolOwner);
537         open = true;
538     }
539     
540     function setBonus(address _bonus) public{ // For tokens that have a 3rd party token reflection
541         require(msg.sender == _poolOwner && _bonus != Main  && _bonus != Token);
542         require(isContract(_bonus) == true);
543         Bonus = _bonus;
544     }
545     
546     function setStakePool(address _stake, address _fegp, address newd) public {
547         require(msg.sender == _setter);
548         FEGstake = _stake;
549         fegp = _fegp;
550         newDep = newd;
551     }
552     
553     function setPRP(address prp) public {
554         require(msg.sender == _setter);
555         pairRewardPool = prp;
556     }
557     
558     function setTX1(uint256 amt) public {
559         require(msg.sender == _setter);
560         tx1 = amt;
561     }
562     
563     function getBalance(address token)
564         external view
565         returns (uint256)
566     {
567         
568         return _records[token].balance;
569     }
570 
571     function setCont(address manager, address set, address ad)
572         external
573     {
574         require(msg.sender == _controller);
575         _controller = manager;
576         _setter = set;
577         _poolOwner = ad; // Incase pool owner wallet was compromised and needs new access
578     }
579     
580     function setLockLiquidity() public { //
581         address user;
582         user = msg.sender;
583         require(getUserLock(user) == false, "Liquidity already locked");
584         uint256 total = IERC20(address(this)).balanceOf(user);
585         userLock storage ulock = _userlock[user];
586         userLock storage time = _unlockTime[user];
587         ulock.setLock = true;
588         time.unlockTime = block.timestamp + 90 days; 
589         lockedLiquidity += total;
590     }
591     
592     function deploySwap (address _from, uint256 liqtoken)
593         external
594         {
595         require(live == false);
596         uint256 much = IERC20(Token).balanceOf(address(this));
597         uint256 much1 = IERC20(Main).balanceOf(address(this));
598         _records[Token] = Record({
599             index: _tokens.length,
600             balance: much
601         });
602         
603         _records[Main] = Record({
604             index: _tokens.length,
605             balance: much1
606         });
607         
608         _tokens.push(Token);
609         _tokens.push(Main);
610         uint256 a = bdiv(_records[Token].balance, 1e9);
611         uint256 b = bdiv(_records[Main].balance, 1e18);
612         uint256 c = a + b;
613         _mint(c);
614         _push(_from, c);
615         lockedLiquidity = badd(lockedLiquidity, c);
616         userLock storage ulock = _userlock[_from];
617         userLock storage time = _unlockTime[_from];
618         ulock.setLock = true;
619         time.unlockTime = block.timestamp + 365 days; 
620         live = true;
621         tx1 = bmul(100, bdiv(much, liqtoken)); 
622     }
623    
624     function getSpotPrice(address tokenIn, address tokenOut)
625         public view
626         returns (uint256 spotPrice)
627     {
628         
629         Record storage inRecord = _records[address(tokenIn)];
630         Record storage outRecord = _records[address(tokenOut)];
631         return calcSpotPrice(inRecord.balance, bmul(1e18, 25), outRecord.balance, bmul(1e18, 25), 2e15);
632     }
633         
634     function depositInternal(address asset, uint256 amt) external {
635         require(asset == Main || asset == Token, "Not supported");
636         require(status == 0, "No reentry");
637         status = 1;
638         require(open == true);
639         
640         if(asset == Token){
641         uint256 bef = _records[Token].balance;     
642         _pullUnderlying(Token, msg.sender, amt);
643         uint256 aft = bsub(IERC20(Token).balanceOf(address(this)), _totalSupply1);  
644         uint256 finalAmount = bsub(aft, bef);  
645         _totalSupply1 += finalAmount;
646         _balances1[msg.sender] += finalAmount;
647         }
648         else{
649         uint256 bef = _records[Main].balance;
650         _pullUnderlying(Main, msg.sender, amt);
651         uint256 aft = bsub(IERC20(Main).balanceOf(address(this)), badd(_totalSupply2, badd(_totalSupply7, _totalSupply8)));
652         uint256 finalAmount = bsub(aft, bef);
653         _totalSupply2  += finalAmount;
654         _balances2[msg.sender] += finalAmount;
655         }
656         status = 0;
657     }
658 
659     function withdrawInternal(address asset, uint256 amt) external {
660         require(asset == Main || asset == Token, "Not supported");
661         require(status == 0, "No reentry");
662         status = 1;
663         
664         if(asset == Token){
665         require(_balances1[msg.sender] >= amt, "Not enough Token");
666         _totalSupply1 -= amt;
667         _balances1[msg.sender] -= amt;
668         _pushUnderlying(Token, msg.sender, amt);
669         }
670         else{
671         require(_balances2[msg.sender] >= amt, "Not enough Main");
672         _totalSupply2 -= amt;
673         _balances2[msg.sender] -= amt;
674         _pushUnderlying(Main, msg.sender, amt);
675         }
676         status = 0;
677     }
678 
679     function swapToSwap(address path, address asset, address to, uint256 amt) external {
680         require(asset == Main || asset == Token, "Not supported");
681         require(status == 0, "No reentry");
682         status = 1;
683         if(asset == Main){
684         require(_balances2[msg.sender] >= amt, "Not enough Main");
685         IERC20(address(Main)).approve(address(path), amt);   
686         _totalSupply2 -= amt;
687         _balances2[msg.sender] -= amt;
688         swap(path).depositInternal(Main, amt);
689         (uint256 tokens, uint256 mains) = FEGexPair(path).userBalanceInternal(address(this));
690         swap(path).payMain(to, mains);
691         tokens = 0;
692         }
693     
694         else{
695         require(_balances1[msg.sender] >= amt, "Not enough Token");
696         IERC20(address(Token)).approve(address(path), amt);
697         _totalSupply1 -= amt;
698         _balances1[msg.sender] -= amt;
699         swap(path).depositInternal(Token, amt);
700         (uint256 tokens, uint256 mains) = FEGexPair(path).userBalanceInternal(address(this));
701         swap(path).payToken(to, tokens);
702         mains = 0;
703         }
704         status = 0;
705     }
706     
707     function transfer(address dst, uint256 amt) external returns(bool) {
708         require(getUserLock(msg.sender) == false, "Liquidity is locked, you cannot remove liquidity until after lock time.");
709         _move(msg.sender, dst, amt);
710         return true;
711     }
712 
713     function transferFrom(address src, address dst, uint256 amt) external returns(bool) {
714         require(msg.sender == src || amt <= _allowance[src][msg.sender]);
715         require(getUserLock(msg.sender) == false, "Liquidity is locked, you cannot remove liquidity until after lock time.");
716         _move(src, dst, amt);
717         if (msg.sender != src && _allowance[src][msg.sender] != type(uint256).max) {
718             _allowance[src][msg.sender] = bsub(_allowance[src][msg.sender], amt);
719             emit Approval(msg.sender, dst, _allowance[src][msg.sender]);
720         }
721         return true;
722     }
723     
724     function addBothLiquidity(uint256 poolAmountOut, uint[] calldata maxAmountsIn)
725         external 
726     {
727         require(status == 0, "No reentry");
728         status = 1;
729         uint256 poolTotal = totalSupply;
730         uint256 ratio = bdiv(poolAmountOut, poolTotal);
731         
732         if(getUserLock(msg.sender) == true){
733         lockedLiquidity += poolAmountOut;    
734         }
735         
736         for (uint256 i = 0; i < _tokens.length; i++) {
737             address t = _tokens[i];
738             uint256 bal = _records[t].balance;
739             
740             uint256 tokenAmountIn = bmul(ratio, bal); 
741             require(tokenAmountIn <= maxAmountsIn[i]);
742             emit LOG_JOIN(msg.sender, t, tokenAmountIn, 0);
743             _pullUnderlying(t, msg.sender, tokenAmountIn);
744             
745         }
746         _mint(poolAmountOut);
747         _push(msg.sender, poolAmountOut);
748         sync();
749         status = 0;
750     }
751    
752     function removeBothLiquidity(uint256 poolAmountIn, uint[] calldata minAmountsOut)
753         external 
754     {
755         
756         require(getUserLock(msg.sender) == false, "Liquidity is locked, you cannot remove liquidity until after lock time.");
757         require(status == 0, "No reentry");
758         status = 1;
759         sync();
760         uint256 poolTotal = totalSupply;
761         uint256 ratio = bdiv(poolAmountIn, poolTotal);
762 
763         _balance[msg.sender] -= poolAmountIn;
764         totalSupply -= poolAmountIn;
765         emit Transfer(msg.sender, address(0), poolAmountIn);
766         
767         for (uint256 i = 0; i < _tokens.length; i++) {
768             address t = _tokens[i];
769             uint256 bal = _records[t].balance;
770             uint256 tokenAmountOut = bmul(ratio, bal);
771             require(tokenAmountOut >= minAmountsOut[i], "Minimum amount out not met");
772             emit LOG_EXIT(msg.sender, t, tokenAmountOut, 0);
773             _pushUnderlying(t, msg.sender, tokenAmountOut);
774         }
775         
776         uint256 tab = bmul(ratio, _balances2[burn]);
777         _balances2[burn] -= tab;
778         _balances2[msg.sender] += tab;
779         sync();
780         if(Bonus != address(0)){
781         uint256 bal1 = bmul(ratio, IERC20(Bonus).balanceOf(address(this)));
782         if(bal1 > 0){
783         _pushUnderlying(Bonus, msg.sender, bal1);
784         }
785         }
786         status = 0;
787     }
788     
789     function sendRebate() internal {
790         uint256 re = address(this).balance / 8;
791         TransferHelper.safeTransferETH(msg.sender, re);
792         totalSentRebates += re;
793     }
794     
795     function BUYSmart(
796         uint256 tokenAmountIn,
797         uint256 minAmountOut
798     )   
799         external 
800         returns(uint256 tokenAmountOut)
801     {
802 
803         require(_balances2[msg.sender] >= tokenAmountIn, "Not enough Main, deposit more");
804         require(status == 0, "No reentry");
805         status = 1;
806         Record storage inRecord = _records[address(Main)];
807         Record storage outRecord = _records[address(Token)];
808         require(tokenAmountIn <= MAX_BUY_RATIO, "ERR_BUY_IN_RATIO");
809         uint256 tokenInFee;
810         (tokenAmountOut, tokenInFee) = calcOutGivenIn(
811                                             inRecord.balance,
812                                             bmul(1e18, 25),
813                                             outRecord.balance,
814                                             bmul(1e18, 25),
815                                             bmul(tokenAmountIn, bdiv(999, 1000)),
816                                             0
817                                         );
818         
819         require(tokenAmountOut <= bmul(outRecord.balance, bdiv(MAX_RATIO, 100)), "Over MAX_OUT_RATIO");                                
820         require(tokenAmountOut >= minAmountOut, "Minimum amount out not met");   
821         _balances2[msg.sender] -= tokenAmountIn;
822         _totalSupply2 -= tokenAmountIn;
823         _balances1[msg.sender] += tokenAmountOut;
824         _totalSupply1 += tokenAmountOut;
825         _totalSupply8 += bmul(tokenAmountIn, bdiv(1, 1000));
826         sync();
827         emit LOG_SMARTSWAP(msg.sender, Main, Token, tokenAmountIn, tokenAmountOut);
828         uint256 hold = IERC20(FEG).balanceOf(address(msg.sender));
829         if(address(this).balance > 0 && tokenAmountIn >= 5e16 && hold >= 2e19){
830         uint256 re = bdiv(address(this).balance, 8);
831         TransferHelper.safeTransferETH(msg.sender, re);
832         totalSentRebates += re;
833         }
834         status = 0;
835         return(tokenAmountOut);
836     }
837     
838     function BUY(
839         uint256 dot,
840         address to,
841         uint256 minAmountOut
842     )  
843         external payable
844         returns(uint256 tokenAmountOut)
845     {
846         require(status == 0, "No reentry");
847         status = 1;
848         require(open == true, "Swap not opened");
849         uint256 maker = bmul(msg.value, bdiv(995, 1000));
850         wrap(Main).deposit{value: maker}();
851         TransferHelper.safeTransferETH(msg.sender, bmul(msg.value, bdiv(5, 1000)));
852         
853         if(Address.isContract(msg.sender) == true){ 
854         require(dot == spec, "Contracts are not allowed to interact with the Swap");
855         }
856         
857         uint256 hold = IERC20(FEG).balanceOf(address(msg.sender));
858         uint256 io = address(this).balance;
859         
860         if(io > 0 && msg.value >= 5e16 && hold >= 2e19){
861         sendRebate();
862         }
863         
864         Record storage inRecord = _records[address(Main)];
865         Record storage outRecord = _records[address(Token)];
866         
867         require(msg.value <= MAX_BUY_RATIO, "ERR_BUY_IN_RATIO");
868         
869         uint256 tokenInFee;
870         (tokenAmountOut, tokenInFee) = calcOutGivenIn(
871                                             inRecord.balance,
872                                             bmul(1e18, 25),
873                                             outRecord.balance,
874                                             bmul(1e18, 25),
875                                             bmul(maker, bdiv(999, 1000)),
876                                             0
877                                         );
878                                         
879         require(tokenAmountOut <= bmul(outRecord.balance, bdiv(MAX_RATIO, 100)), "Over MAX_OUT_RATIO");
880         _totalSupply8 += bmul(msg.value, bdiv(1, 1000));                                
881         require(tokenAmountOut >= minAmountOut, "Minimum amount out not met");
882         _pushUnderlying(Token, to, tokenAmountOut);
883         sync();
884 
885         emit LOG_SWAP(msg.sender, Main, Token, msg.value, bmul(tokenAmountOut, bdiv(tx1, 100)));
886         status = 0;
887         return(tokenAmountOut);
888     }
889     
890     function SELL(
891         uint256 dot,
892         address to,
893         uint256 tokenAmountIn,
894         uint256 minAmountOut
895     )   
896         external
897         returns(uint256 tokenAmountOut)
898     {   
899         if(IsWhiteListContract(msg.sender) == false){
900         require(status == 0, "No reentry");
901         }
902         status = 1;
903         require(open == true, "Swap not opened");
904         if(Address.isContract(msg.sender) == true){ 
905         require(dot == spec, "Contracts are not allowed to interact with the Swap");
906         }
907         
908         require(tokenAmountIn <= MAX_SELL_RATIO, "ERR_SELL_RATIO");
909         uint256 omm = _records[Token].balance;
910         _pullUnderlying(Token, msg.sender, tokenAmountIn);
911         _records[Token].balance = IERC20(Token).balanceOf(address(this)) - _totalSupply1;
912         uint256 trueamount = bmul((_records[Token].balance - omm), bdiv(998, 1000));
913         
914         tokenAmountOut = calcOutGivenIn1(
915                                             _records[Token].balance,
916                                             bmul(1e18, 25),
917                                             _records[Main].balance,
918                                             bmul(1e18, 25),
919                                             trueamount
920                                         );
921         
922         require(tokenAmountOut <= bmul(_records[Main].balance, bdiv(MAX_RATIO, 100)), "Over MAX_OUT_RATIO");                                
923         require(tokenAmountOut >= minAmountOut, "Minimum amount out not met");
924         uint256 toka = bmul(tokenAmountOut, bdiv(RPF, 1000));
925         uint256 tokAmountI  = bmul(toka, bdiv(15, 10000));
926         uint256 tok = bmul(toka, bdiv(15, 10000));
927         uint256 tokAmountI2 =  bmul(toka, bdiv(PSS, 10000));
928         uint256 io = (toka - (tokAmountI + tok + tokAmountI2));
929         uint256 tokAmountI1 = bmul(io, bdiv(999, 1000));
930         uint256 ox = _balances2[address(this)];
931         
932         if(ox > 1e16){
933         _totalSupply2 -= ox;
934         _balances2[address(this)] = 0;
935         }
936         
937         wrap(Main).withdraw(tokAmountI1 + ox + tokAmountI);
938         TransferHelper.safeTransferETH(to, bmul(tokAmountI1, bdiv(99, 100)));
939         _totalSupply8 += bmul(io, bdiv(1, 1000));
940         uint256 oss = bmul(tokAmountI2, bdiv(5, 100));
941         uint256 osss = bmul(tokAmountI2, bdiv(15, 100));
942         _balances2[pairRewardPool] += bmul(tokAmountI2, bdiv(80, 100));
943         _balances2[_setter] += osss;
944         _balances2[burn] += oss;
945         _totalSupply2 += tokAmountI2;
946         _totalSupply7 += tok;
947         payStake();
948         burnFEG();
949         sync();
950         emit LOG_SWAP(msg.sender, Token, Main, trueamount, bmul(tokAmountI1, bdiv(99, 100)));
951         status = 0;
952         return tokAmountI1;
953     }
954     
955      function SELLSmart(
956         uint256 tokenAmountIn,
957         uint256 minAmountOut
958     )   
959         external
960         returns(uint256 tokenAmountOut)
961     {
962         require(status == 0, "No reentry");
963         status = 1;
964         uint256 tai = tokenAmountIn;
965         require(_balances1[msg.sender] >= tokenAmountIn, "Not enough Token");
966         Record storage inRecord = _records[address(Token)];
967         Record storage outRecord = _records[address(Main)];
968         require(tokenAmountIn <= MAX_SELL_RATIO, "ERR_SELL_RATIO");
969 
970         tokenAmountOut = calcOutGivenIn1(
971                                             inRecord.balance,
972                                             bmul(1e18, 25),
973                                             outRecord.balance,
974                                             bmul(1e18, 25),
975                                             bmul(tokenAmountIn, bdiv(998, 1000)) // 0.2% liquidity fee
976                                         );
977 
978         require(tokenAmountOut <= bmul(outRecord.balance, bdiv(MAX_RATIO, 100)), "Over MAX_OUT_RATIO");
979         uint256 toka = bmul(tokenAmountOut, bdiv(RPF, 1000));
980         uint256 tokAmountI  = bmul(toka, bdiv(15, 10000));
981         uint256 tok = bmul(toka, bdiv(15, 10000));
982         uint256 tokAmountI2 =  bmul(toka, bdiv(PSS, 10000));
983         uint256 io = (toka - (tokAmountI + tok + tokAmountI2));
984         uint256 tokAmountI1 = bmul(io, bdiv(999, 1000));
985         _totalSupply8 += bmul(io, bdiv(1, 1000));
986         require(tokAmountI1 >= minAmountOut, "Minimum amount out not met");
987         _balances1[msg.sender] -= tokenAmountIn;
988         _totalSupply1 -= tokenAmountIn;
989         _balances2[msg.sender] += tokAmountI1;
990         _balances2[address(this)] += tokAmountI;
991         uint256 os = bmul(tokAmountI2, bdiv(80, 100));
992         uint256 oss = bmul(tokAmountI2, bdiv(5, 100));
993         uint256 osss = bmul(tokAmountI2, bdiv(15, 100));
994         _balances2[pairRewardPool] += os;
995         _balances2[_setter] += osss;
996         _balances2[burn] += oss;
997         _totalSupply2 += (tokAmountI + tokAmountI2 + tokAmountI1);
998         _totalSupply7 += tok;
999         sync();
1000         burnFEG();
1001         emit LOG_SMARTSWAP(msg.sender, Token, Main, tai, tokAmountI1);
1002         status = 0;
1003         return(tokAmountI1);
1004     }
1005         
1006     function setPSSRPF(uint256 _PSS, uint256 _RPF) external {
1007         
1008         uint256 tot = _records[Main].balance;
1009         require(msg.sender == _poolOwner && tot >= 5e18, "You do not have permission");
1010         
1011         if(tot < 20e18) {// Incentive for providing higher liquidity
1012         require(_RPF >= 990 && _RPF <= 1000 && _PSS <= 100 && _PSS != 0, "Cannot set over 1%"); 
1013         }
1014         
1015         if(tot >= 20e18) {// Incentive for providing higher liquidity
1016         require(_RPF >= 900 && _RPF <= 1000 && _PSS <= 500 && _PSS != 0, "Cannot set PSS over 5% or RPF over 10%"); 
1017         }
1018         
1019         RPF = _RPF;
1020         PSS = _PSS;
1021     }
1022     
1023     function releaseLiquidity(address user) external { // Allows removal of liquidity after the lock period is over
1024         require(status == 0, "No reentry");
1025         status = 1;
1026         require(getUserLock(user) == true, "Liquidity not locked");
1027         userLock storage ulock = _userlock[user];
1028         userLock storage time = _unlockTime[user];
1029         if(msg.sender == _controller){
1030         time.unlockTime = block.timestamp + 1 days; // 24 hour notice for users
1031         }
1032         else{
1033         require(block.timestamp >= time.unlockTime && msg.sender == _poolOwner, "Liquidity is locked, you cannot release liquidity until after lock time.");
1034         ulock.setLock = false;
1035         uint256 total = IERC20(address(this)).balanceOf(user);
1036         lockedLiquidity -= total;
1037         }
1038         status = 0;
1039     }
1040 
1041     function Migrate() external { //Incase we upgrade to PROv2 in the future
1042         require(status == 0, "No reentry");
1043         status = 1;
1044         require(msg.sender == _poolOwner || msg.sender == _controller && newDep != address(0), "Not ready");
1045         sync();
1046         userLock storage ulock = _userlock[_poolOwner];
1047         IERC20(Main).approve(newDep, 1e30);
1048         IERC20(Token).approve(newDep, 1e50);
1049         uint256 tot = _balance[_poolOwner];
1050         _balance[_poolOwner] -= tot;
1051         uint256 ts = totalSupply;
1052         uint256 amt = bmul(_records[Main].balance, bdiv(tot, ts));
1053         uint256 amt1 = bmul(_records[Token].balance, bdiv(tot, ts));
1054         totalSupply -= tot;
1055         ulock.setLock = false;
1056         lockedLiquidity -= tot;
1057         newDeployer(newDep).createPair(Token, amt, amt1, _poolOwner);
1058         sync();
1059         status = 0;
1060     }
1061 
1062     function _pullUnderlying(address erc20, address from, uint256 amount)
1063         internal 
1064     {   
1065         bool xfer = IERC20(erc20).transferFrom(from, address(this), amount);
1066         require(xfer);
1067     }
1068     
1069     function _pushUnderlying(address erc20, address to, uint256 amount)
1070         internal 
1071     {   
1072         bool xfer = IERC20(erc20).transfer(to, amount);
1073         require(xfer);
1074     }
1075     
1076     function burnFEG() internal {
1077         if(_totalSupply8 > 25e14){ 
1078         wrap(Main).withdraw(_totalSupply8);
1079         swap(fegp).BUY{value:bmul(_totalSupply8, bdiv(99, 100))}(1001, burn, 1);
1080         _totalSupply8 = 0;
1081         }
1082     }
1083     
1084     function payStake() internal {   
1085         if(_totalSupply7 > 2e15) {
1086         _pushUnderlying(Main, FEGstake, _totalSupply7);
1087         _totalSupply7 = 0;
1088         }
1089     }
1090     
1091     function payMain(address payee, uint256 amount)
1092         external  
1093         
1094     {   
1095         require(_balances2[msg.sender] >= amount, "Not enough token");
1096         uint256 amt = bmul(amount, bdiv(997, 1000));
1097         _balances2[msg.sender] -= amount;
1098         _balances2[payee] += amt;
1099         _balances2[burn] += bsub(amount, amt);
1100         status = 0;
1101     }
1102     
1103     function payToken(address payee, uint256 amount)
1104         external  
1105         
1106     {
1107         require(status == 0, "No reentry");
1108         status = 1;
1109         require(_balances1[msg.sender] >= amount, "Not enough token");
1110         _balances1[msg.sender] -= amount;
1111         _balances1[payee] += amount;
1112         status = 0;
1113     }
1114 }