1 pragma solidity 0.7.6;     
2 
3 // SPDX-License-Identifier: UNLICENSED 
4 /*
5 * Must wrap your ETH for fETH to use FEGex DEX
6 
7 Built for fETH - FEG Wapped ETH - Built in 1% frictionless rewards of ETH!  Stake ETH with fETHand earn rewards!
8 */
9 
10 
11 abstract contract ReentrancyGuard {
12 
13     uint256 private constant _NOT_ENTERED = 1;
14     uint256 private constant _ENTERED = 2;
15 
16     uint256 private _status;
17 
18     constructor () {
19         _status = _NOT_ENTERED;
20     }
21 
22     modifier nonReentrant() {
23 
24         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
25 
26         _status = _ENTERED;
27 
28         _;
29 
30         _status = _NOT_ENTERED;
31     }
32 }
33 
34 contract FSilver  {
35      function getColor()
36         external pure
37         returns (bytes32) {
38             return bytes32("BRONZE");
39         }
40 }
41 
42 
43 contract FConst is FSilver, ReentrancyGuard {
44     uint public constant BASE              = 10**18;
45 
46     uint public constant MIN_BOUND_TOKENS  = 2;
47     uint public constant MAX_BOUND_TOKENS  = 8;
48 
49     uint public constant MIN_FEE           = 2000000000000000; 
50     uint public constant MAX_FEE           = 2000000000000000; // FREE BUYS
51     uint public constant EXIT_FEE          = BASE / 200;
52     uint public constant DEFAULT_RESERVES_RATIO = 0;
53 
54     uint public constant MIN_WEIGHT        = BASE;
55     uint public constant MAX_WEIGHT        = BASE * 50;
56     uint public constant MAX_TOTAL_WEIGHT  = BASE * 50;
57     uint public constant MIN_BALANCE       = BASE / 10**12;
58 
59     uint public constant INIT_POOL_SUPPLY  = BASE * 100;
60     
61     uint public  SM = 10;
62     uint public  M1 = 10;
63     address public FEGstake = 0x4c9BC793716e8dC05d1F48D8cA8f84318Ec3043C;
64 
65     uint public constant MIN_BPOW_BASE     = 1 wei;
66     uint public constant MAX_BPOW_BASE     = (2 * BASE) - 1 wei;
67     uint public constant BPOW_PRECISION    = BASE / 10**10;
68 
69     uint public constant MAX_IN_RATIO      = BASE / 2;
70     uint public constant MAX_OUT_RATIO     = (BASE / 3) + 1 wei;
71     uint public MAX_SELL_RATIO             = BASE / SM;
72     uint public MAX_1_RATIO             = BASE / M1;
73 }
74 
75 
76 contract FNum is ReentrancyGuard, FConst {
77 
78     function btoi(uint a)
79         internal pure
80         returns (uint)
81     {
82         return a / BASE;
83     }
84 
85     function bfloor(uint a)
86         internal pure
87         returns (uint)
88     {
89         return btoi(a) * BASE;
90     }
91 
92     function badd(uint a, uint b)
93         internal pure
94         returns (uint)
95     {
96         uint c = a + b;
97         require(c >= a, "ERR_ADD_OVERFLOW");
98         return c;
99     }
100 
101     function bsub(uint a, uint b)
102         internal pure
103         returns (uint)
104     {
105         (uint c, bool flag) = bsubSign(a, b);
106         require(!flag, "ERR_SUB_UNDERFLOW");
107         return c;
108     }
109 
110     function bsubSign(uint a, uint b)
111         internal pure
112         returns (uint, bool)
113     {
114         if (a >= b) {
115             return (a - b, false);
116         } else {
117             return (b - a, true);
118         }
119     }
120 
121     function bmul(uint a, uint b)
122         internal pure
123         returns (uint)
124     {
125         uint c0 = a * b;
126         require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
127         uint c1 = c0 + (BASE / 2);
128         require(c1 >= c0, "ERR_MUL_OVERFLOW");
129         uint c2 = c1 / BASE;
130         return c2;
131     }
132 
133     function bdiv(uint a, uint b)
134         internal pure
135         returns (uint)
136     {
137         require(b != 0, "ERR_DIV_ZERO");
138         uint c0 = a * BASE;
139         require(a == 0 || c0 / a == BASE, "ERR_DIV_INTERNAL"); // bmul overflow
140         uint c1 = c0 + (b / 2);
141         require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
142         uint c2 = c1 / b;
143         return c2;
144     }
145 
146     // DSMath.wpow
147     function bpowi(uint a, uint n)
148         internal pure
149         returns (uint)
150     {
151         uint z = n % 2 != 0 ? a : BASE;
152 
153         for (n /= 2; n != 0; n /= 2) {
154             a = bmul(a, a);
155 
156             if (n % 2 != 0) {
157                 z = bmul(z, a);
158             }
159         }
160         return z;
161     }
162 
163     function bpow(uint base, uint exp)
164         internal pure
165         returns (uint)
166     {
167         require(base >= MIN_BPOW_BASE, "ERR_BPOW_BASE_TOO_LOW");
168         require(base <= MAX_BPOW_BASE, "ERR_BPOW_BASE_TOO_HIGH");
169 
170         uint whole  = bfloor(exp);
171         uint remain = bsub(exp, whole);
172 
173         uint wholePow = bpowi(base, btoi(whole));
174 
175         if (remain == 0) {
176             return wholePow;
177         }
178 
179         uint partialResult = bpowApprox(base, remain, BPOW_PRECISION);
180         return bmul(wholePow, partialResult);
181     }
182 
183     function bpowApprox(uint base, uint exp, uint precision)
184         internal pure
185         returns (uint)
186     {
187         // term 0:
188         uint a     = exp;
189         (uint x, bool xneg)  = bsubSign(base, BASE);
190         uint term = BASE;
191         uint sum   = term;
192         bool negative = false;
193 
194 
195         for (uint i = 1; term >= precision; i++) {
196             uint bigK = i * BASE;
197             (uint c, bool cneg) = bsubSign(a, bsub(bigK, BASE));
198             term = bmul(term, bmul(c, x));
199             term = bdiv(term, bigK);
200             if (term == 0) break;
201 
202             if (xneg) negative = !negative;
203             if (cneg) negative = !negative;
204             if (negative) {
205                 sum = bsub(sum, term);
206             } else {
207                 sum = badd(sum, term);
208             }
209         }
210 
211         return sum;
212     }
213 }
214 
215 contract FMath is FSilver, FConst, FNum {
216     
217         function calcSpotPrice(
218         uint tokenBalanceIn,
219         uint tokenWeightIn,
220         uint tokenBalanceOut,
221         uint tokenWeightOut,
222         uint swapFee
223     )
224         public pure
225         returns (uint spotPrice)
226     {
227         uint numer = bdiv(tokenBalanceIn, tokenWeightIn);
228         uint denom = bdiv(tokenBalanceOut, tokenWeightOut);
229         uint ratio = bdiv(numer, denom);
230         uint scale = bdiv(BASE, bsub(BASE, swapFee));
231         return  (spotPrice = bmul(ratio, scale));
232     }
233 
234 
235     function calcOutGivenIn(
236         uint tokenBalanceIn,
237         uint tokenWeightIn,
238         uint tokenBalanceOut,
239         uint tokenWeightOut,
240         uint tokenAmountIn,
241         uint swapFee
242     )
243         public pure
244         returns (uint tokenAmountOut, uint tokenInFee)
245     {
246         uint weightRatio = bdiv(tokenWeightIn, tokenWeightOut);
247         uint adjustedIn = bsub(BASE, swapFee);
248         adjustedIn = bmul(tokenAmountIn, adjustedIn);
249         uint y = bdiv(tokenBalanceIn, badd(tokenBalanceIn, adjustedIn));
250         uint foo = bpow(y, weightRatio);
251         uint bar = bsub(BASE, foo);
252         tokenAmountOut = bmul(tokenBalanceOut, bar);
253         tokenInFee = bsub(tokenAmountIn, adjustedIn);
254         return (tokenAmountOut, tokenInFee);
255     }
256 
257 
258     function calcInGivenOut(
259         uint tokenBalanceIn,
260         uint tokenWeightIn,
261         uint tokenBalanceOut,
262         uint tokenWeightOut,
263         uint tokenAmountOut,
264         uint swapFee
265     )
266         public pure
267         returns (uint tokenAmountIn, uint tokenInFee)
268     {
269         uint weightRatio = bdiv(tokenWeightOut, tokenWeightIn);
270         uint diff = bsub(tokenBalanceOut, tokenAmountOut);
271         uint y = bdiv(tokenBalanceOut, diff);
272         uint foo = bpow(y, weightRatio);
273         foo = bsub(foo, BASE);
274         foo = bmul(tokenBalanceIn, foo);
275         tokenAmountIn = bsub(BASE, swapFee);
276         tokenAmountIn = bdiv(foo, tokenAmountIn);
277         tokenInFee = bdiv(foo, BASE);
278         tokenInFee = bsub(tokenAmountIn, tokenInFee);
279         return (tokenAmountIn, tokenInFee);
280     }
281 
282 
283     function calcPoolOutGivenSingleIn(
284         uint tokenBalanceIn,
285         uint tokenWeightIn,
286         uint poolSupply,
287         uint totalWeight,
288         uint tokenAmountIn,
289         uint swapFee,
290         uint reservesRatio
291     )
292         public pure
293         returns (uint poolAmountOut, uint reserves)
294     {
295 
296         uint normalizedWeight = bdiv(tokenWeightIn, totalWeight);
297          uint zaz = bmul(bsub(BASE, normalizedWeight), swapFee);
298         uint tokenAmountInAfterFee = bmul(tokenAmountIn, bsub(BASE, zaz));
299 
300         reserves = calcReserves(tokenAmountIn, tokenAmountInAfterFee, reservesRatio);
301         uint newTokenBalanceIn = badd(tokenBalanceIn, tokenAmountInAfterFee);
302         uint tokenInRatio = bdiv(newTokenBalanceIn, tokenBalanceIn);
303 
304  
305         uint poolRatio = bpow(tokenInRatio, normalizedWeight);
306         uint newPoolSupply = bmul(poolRatio, poolSupply);
307         poolAmountOut = bsub(newPoolSupply, poolSupply);
308         return (poolAmountOut, reserves);
309     }
310 
311     function calcSingleOutGivenPoolIn(
312         uint tokenBalanceOut,
313         uint tokenWeightOut,
314         uint poolSupply,
315         uint totalWeight,
316         uint poolAmountIn,
317         uint swapFee
318     )
319         public pure
320         returns (uint tokenAmountOut)
321     {
322         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
323 
324         uint poolAmountInAfterExitFee = bmul(poolAmountIn, bsub(BASE, EXIT_FEE));
325         uint newPoolSupply = bsub(poolSupply, poolAmountInAfterExitFee);
326         uint poolRatio = bdiv(newPoolSupply, poolSupply);
327 
328 
329         uint tokenOutRatio = bpow(poolRatio, bdiv(BASE, normalizedWeight));
330         uint newTokenBalanceOut = bmul(tokenOutRatio, tokenBalanceOut);
331 
332         uint tokenAmountOutBeforeSwapFee = bsub(tokenBalanceOut, newTokenBalanceOut);
333         uint zaz = bmul(bsub(BASE, normalizedWeight), swapFee);
334         tokenAmountOut = bmul(tokenAmountOutBeforeSwapFee, bsub(BASE, zaz));
335         return tokenAmountOut;
336     }
337 
338 
339     function calcPoolInGivenSingleOut(
340         uint tokenBalanceOut,
341         uint tokenWeightOut,
342         uint poolSupply,
343         uint totalWeight,
344         uint tokenAmountOut,
345         uint swapFee,
346         uint reservesRatio
347     )
348         public pure
349         returns (uint poolAmountIn, uint reserves)
350     {
351 
352 
353         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
354         uint zar = bmul(bsub(BASE, normalizedWeight), swapFee);
355         uint tokenAmountOutBeforeSwapFee = bdiv(tokenAmountOut, bsub(BASE, zar));
356         reserves = calcReserves(tokenAmountOutBeforeSwapFee, tokenAmountOut, reservesRatio);
357 
358         uint newTokenBalanceOut = bsub(tokenBalanceOut, tokenAmountOutBeforeSwapFee);
359         uint tokenOutRatio = bdiv(newTokenBalanceOut, tokenBalanceOut);
360 
361 
362         uint poolRatio = bpow(tokenOutRatio, normalizedWeight);
363         uint newPoolSupply = bmul(poolRatio, poolSupply);
364         uint poolAmountInAfterExitFee = bsub(poolSupply, newPoolSupply);
365 
366 
367         poolAmountIn = bdiv(poolAmountInAfterExitFee, bsub(BASE, EXIT_FEE));
368         return (poolAmountIn, reserves);
369     }
370 
371     function calcReserves(uint amountWithFee, uint amountWithoutFee, uint reservesRatio)
372         internal pure
373         returns (uint reserves)
374     {
375         require(amountWithFee >= amountWithoutFee, "ERR_MATH_APPROX");
376         require(reservesRatio <= BASE, "ERR_INVALID_RESERVE");
377         uint swapFeeAndReserves = bsub(amountWithFee, amountWithoutFee);
378         reserves = bmul(swapFeeAndReserves, reservesRatio);
379         require(swapFeeAndReserves >= reserves, "ERR_MATH_APPROX");
380     }
381 
382     function calcReservesFromFee(uint fee, uint reservesRatio)
383         internal pure
384         returns (uint reserves)
385     {
386         require(reservesRatio <= BASE, "ERR_INVALID_RESERVE");
387         reserves = bmul(fee, reservesRatio);
388     }
389 }
390 // Highly opinionated token implementation
391 
392 interface IERC20 {
393 
394     function totalSupply() external view returns (uint);
395     function balanceOf(address whom) external view returns (uint);
396     function allowance(address src, address dst) external view returns (uint);
397 
398     function approve(address dst, uint amt) external returns (bool);
399     function transfer(address dst, uint amt) external returns (bool);
400     function transferFrom(
401         address src, address dst, uint amt
402     ) external returns (bool);
403 }
404 
405 contract FTokenBase is ReentrancyGuard, FNum {
406 
407     mapping(address => uint)                   internal _balance;
408     mapping(address => mapping(address=>uint)) internal _allowance;
409     uint internal _totalSupply;
410 
411     event Approval(address indexed src, address indexed dst, uint amt);
412     event Transfer(address indexed src, address indexed dst, uint amt);
413 
414     function _mint(uint amt) internal {
415         _balance[address(this)] = badd(_balance[address(this)], amt);
416         _totalSupply = badd(_totalSupply, amt);
417         emit Transfer(address(0), address(this), amt);
418     }
419 
420     function _burn(uint amt) internal {
421         require(_balance[address(this)] >= amt);
422         _balance[address(this)] = bsub(_balance[address(this)], amt);
423         _totalSupply = bsub(_totalSupply, amt);
424         emit Transfer(address(this), address(0), amt);
425     }
426 
427     function _move(address src, address dst, uint amt) internal {
428         require(_balance[src] >= amt);
429         _balance[src] = bsub(_balance[src], amt);
430         _balance[dst] = badd(_balance[dst], amt);
431         emit Transfer(src, dst, amt);
432     }
433 
434     function _push(address to, uint amt) internal {
435         _move(address(this), to, amt);
436     }
437 
438     function _pull(address from, uint amt) internal {
439         _move(from, address(this), amt);
440     }
441 }
442 
443 contract FToken is ReentrancyGuard, FTokenBase {
444 
445     string  private _name     = "FEGwETHpair";
446     string  private _symbol   = "FEGwETHLP";
447     uint8   private _decimals = 18;
448 
449     function name() public view returns (string memory) {
450         return _name;
451     }
452 
453     function symbol() public view returns (string memory) {
454         return _symbol;
455     }
456 
457     function decimals() public view returns(uint8) {
458         return _decimals;
459     }
460 
461     function allowance(address src, address dst) external view returns (uint) {
462         return _allowance[src][dst];
463     }
464 
465     function balanceOf(address whom) external view returns (uint) {
466         return _balance[whom];
467     }
468 
469     function totalSupply() public view returns (uint) {
470         return _totalSupply;
471     }
472 
473     function approve(address dst, uint amt) external returns (bool) {
474         _allowance[msg.sender][dst] = amt;
475         emit Approval(msg.sender, dst, amt);
476         return true;
477     }
478 
479     function increaseApproval(address dst, uint amt) external returns (bool) {
480         _allowance[msg.sender][dst] = badd(_allowance[msg.sender][dst], amt);
481         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
482         return true;
483     }
484 
485     function decreaseApproval(address dst, uint amt) external returns (bool) {
486         uint oldValue = _allowance[msg.sender][dst];
487         if (amt > oldValue) {
488             _allowance[msg.sender][dst] = 0;
489         } else {
490             _allowance[msg.sender][dst] = bsub(oldValue, amt);
491         }
492         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
493         return true;
494     }
495 
496     function transfer(address dst, uint amt) external returns (bool) {
497         FEGwETH ulock;
498         bool getlock = ulock.getUserLock(msg.sender);
499         
500         require(getlock == true, 'Liquidity is locked, you cannot removed liquidity until after lock time.');
501         
502         _move(msg.sender, dst, amt);
503         return true;
504     }
505 
506     function transferFrom(address src, address dst, uint amt) external returns (bool) {
507         require(msg.sender == src || amt <= _allowance[src][msg.sender]);
508         FEGwETH ulock;
509         bool getlock = ulock.getUserLock(msg.sender);
510         
511         require(getlock == true, 'Transfer is Locked ');
512         
513         
514         _move(src, dst, amt);
515         if (msg.sender != src && _allowance[src][msg.sender] != uint256(-1)) {
516             _allowance[src][msg.sender] = bsub(_allowance[src][msg.sender], amt);
517             emit Approval(msg.sender, dst, _allowance[src][msg.sender]);
518         }
519         return true;
520     }
521 }
522 
523 contract FEGwETH is FSilver, ReentrancyGuard, FToken, FMath {
524 
525     struct Record {
526         bool bound;   // is token bound to pool
527         uint index;   // private
528         uint denorm;  // denormalized weight
529         uint balance;
530     }
531     
532     struct userLock {
533         bool setLock; // true = locked, false=unlocked
534         uint unlockTime;
535     }
536     
537     function getUserLock(address usr) public view returns(bool lock){
538         return _userlock[usr].setLock;
539     }
540     
541     event LOG_SWAP(
542         address indexed caller,
543         address indexed tokenIn,
544         address indexed tokenOut,
545         uint256         tokenAmountIn,
546         uint256         tokenAmountOut,
547         uint256         reservesAmount
548 );
549 
550     event LOG_JOIN(
551         address indexed caller,
552         address indexed tokenIn,
553         uint256         tokenAmountIn,
554         uint256         reservesAmount
555 );
556 
557     event LOG_EXIT(
558         address indexed caller,
559         address indexed tokenOut,
560         uint256         tokenAmountOut,
561         uint256         reservesAmount
562     );
563 
564     event LOG_CLAIM_RESERVES(
565         address indexed caller,
566         address indexed tokenOut,
567         uint256         tokenAmountOut
568     );
569 
570     event LOG_ADD_RESERVES(
571         address indexed token,
572         uint256         reservesAmount
573     );
574 
575     event LOG_CALL(
576         bytes4  indexed sig,
577         address indexed caller,
578         bytes           data
579     ) anonymous;
580 
581     modifier _logs_() {
582         emit LOG_CALL(msg.sig, msg.sender, msg.data);
583         _;
584     }
585 
586     modifier _lock_() {
587         require(!_mutex);
588         _mutex = true;
589         _;
590         _mutex = false;
591     } 
592 
593     modifier _viewlock_() {
594         require(!_mutex);
595         _;
596     }
597 
598     bool private _mutex;
599 
600 
601     address private _factory = 0x4c9BC793716e8dC05d1F48D8cA8f84318Ec3043C;    // BFactory address to push token exitFee to
602     address private _controller = 0x4c9BC793716e8dC05d1F48D8cA8f84318Ec3043C; // has CONTROL role 
603     address private _poolOwner;
604     address public fETH = 0xf786c34106762Ab4Eeb45a51B42a62470E9D5332;
605     address public FEG = 0x389999216860AB8E0175387A0c90E5c52522C945;
606     address public pairRewardPool = 0x4c9BC793716e8dC05d1F48D8cA8f84318Ec3043C;
607     bool private _publicSwap; // true if PUBLIC can call SWAP functions
608 
609     // `setSwapFee` and `Launch' require CONTROL
610     // `Launch` sets `PUBLIC can SWAP`, `PUBLIC can JOIN`
611     uint private _swapFee;
612     uint private _reservesRatio;
613     bool private _launched;
614 
615     address[] private _tokens;
616     mapping(address=>Record) private  _records;
617     mapping(address=>userLock) public  _userlock;
618     mapping(address=>uint) public totalReserves;
619     mapping(address=>bool) public whiteListContract;
620     
621     uint private _totalWeight;
622 
623     constructor() {
624         _poolOwner = msg.sender;
625         _swapFee = MIN_FEE;
626         _reservesRatio = DEFAULT_RESERVES_RATIO;
627         _publicSwap = false;
628         _launched = false;
629     }
630 
631     function isContract(address account) internal view returns (bool) {
632         
633         if(IsWhiteListContract(account)) {  return false; }
634         bytes32 codehash;
635         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
636         assembly { codehash := extcodehash(account) }
637         return (codehash != 0x0 && codehash != accountHash);
638     }
639     
640     function addWhiteListContract(address _addy, bool boolean) public {
641         require(msg.sender == _controller);
642         require(_addy != address(0), "setting 0 address;;");
643         
644         whiteListContract[_addy] = boolean;
645     }
646     
647     function IsWhiteListContract(address _addy) public view returns(bool){
648         require(_addy != address(0), "setting 0 address;;");
649         
650         return whiteListContract[_addy];
651     }
652     
653     modifier noContract() {
654         require(isContract(msg.sender) == false, 'Unapproved contracts are not allowed to interact with the swap');
655         _;
656     }
657     
658     function setMaxSellRatio(uint256 _amount) public {
659         require(msg.sender == _poolOwner, "You do not have permission");
660         require (_amount > 0, "cannot turn off");
661         require (_amount <= 100, "cannot set under 1%");
662         SM = _amount;
663     }
664     
665     function setMax1SideLiquidityRatio(uint256 _amount) public {
666         require(msg.sender == _poolOwner, "You do not have permission");
667         require (_amount > 10, "cannot set over 10%");
668         require (_amount <= 200, "cannot set under 0.5%");
669         M1 = _amount;
670     }
671     
672     function setStakePool(address _addy) public {
673         require(msg.sender == _controller);
674     FEGstake = _addy;
675     }
676     
677     function setPairRewardPool(address _addy) public {
678         require(msg.sender == _controller);
679     pairRewardPool = _addy;
680     }
681     
682     function isPublicSwap()
683         external view
684         returns (bool)
685     {
686         return _publicSwap;
687         
688     }    
689     
690     function isBound(address t)
691         external view
692         returns (bool)
693     {
694         return _records[t].bound;
695     }
696 
697     function getFinalTokens()
698         external view
699         _viewlock_
700         returns (address[] memory tokens)
701     {
702         require(_launched);
703         return _tokens;
704     }
705 
706     function getDenormalizedWeight(address token)
707         external view
708         _viewlock_
709         returns (uint)
710     {
711 
712         require(_records[token].bound);
713         return _records[token].denorm;
714     }
715 
716     function getTotalDenormalizedWeight()
717         external view
718         _viewlock_
719         returns (uint)
720     {
721         return _totalWeight;
722     }
723 
724     function getNormalizedWeight(address token)
725         external view
726         _viewlock_
727         returns (uint)
728     {
729 
730         require(_records[token].bound);
731         uint denorm = _records[token].denorm;
732         return bdiv(denorm, _totalWeight);
733     }
734 
735     function getBalance(address token)
736         external view
737         _viewlock_
738         returns (uint)
739     {
740 
741         require(_records[token].bound);
742         return _records[token].balance;
743     }
744 
745     function getSwapFee()
746         external view
747         _viewlock_
748         returns (uint)
749     {
750         return _swapFee;
751     }
752 
753     function getController()
754         external view
755         _viewlock_
756         returns (address)
757     {
758         return _controller;
759     }
760 
761     function setController(address manager)
762         external
763         _logs_
764         _lock_
765     {
766         require(msg.sender == _controller);
767         _controller = manager;
768     }
769 
770 
771     function Launch()
772         external
773         _logs_
774         _lock_
775     {
776         require(msg.sender == _poolOwner);
777         require(!_launched);
778         require(_tokens.length >= MIN_BOUND_TOKENS);
779 
780         _launched = true;
781         _publicSwap = true;
782 
783         _mintPoolShare(INIT_POOL_SUPPLY);
784         _pushPoolShare(msg.sender, INIT_POOL_SUPPLY);
785     }
786 
787 
788     function AddTokenInitial(address token, uint balance, uint denorm)
789         external
790         _logs_
791         // _lock_  Bind does not lock because it jumps to `rebind`, which does
792     {
793         require(msg.sender == _poolOwner);
794         require(!_records[token].bound);
795         require(!_launched);
796 
797         require(_tokens.length < MAX_BOUND_TOKENS);
798 
799         _records[token] = Record({
800             bound: true,
801             index: _tokens.length,
802             denorm: 0,    // balance and denorm will be validated
803             balance: 0  // and set by `rebind`
804             //locktime: block.timestamp
805         });
806         _tokens.push(token);
807         rebind(token, balance * 98/100, denorm);
808     }
809     
810     function AddfETHInitial(address token, uint balance, uint denorm)
811         external
812         _logs_
813         // _lock_  Bind does not lock because it jumps to `rebind`, which does
814     {
815         require(token == fETH);
816         require(msg.sender == _poolOwner);
817         require(!_records[token].bound);
818         require(!_launched);
819 
820         require(_tokens.length < MAX_BOUND_TOKENS);
821 
822         _records[token] = Record({
823             bound: true,
824             index: _tokens.length,
825             denorm: 0,    // balance and denorm will be validated
826             balance: 0  // and set by `rebind`
827             //locktime: block.timestamp
828         });
829         _tokens.push(token);
830         rebind(token, balance * 99/100, denorm);
831     }
832 
833     function rebind(address token, uint balance, uint denorm)
834         public
835         _logs_
836         _lock_
837     {
838 
839         require(msg.sender == _poolOwner);
840         require(_records[token].bound);
841         require(!_launched);
842 
843         require(denorm >= MIN_WEIGHT);
844         require(denorm <= MAX_WEIGHT);
845         require(balance >= MIN_BALANCE);
846 
847         // Adjust the denorm and totalWeight
848         uint oldWeight = _records[token].denorm;
849         if (denorm > oldWeight) {
850             _totalWeight = badd(_totalWeight, bsub(denorm, oldWeight));
851             require(_totalWeight <= MAX_TOTAL_WEIGHT);
852         } else if (denorm < oldWeight) {
853             _totalWeight = bsub(_totalWeight, bsub(oldWeight, denorm));
854         }
855         _records[token].denorm = denorm;
856 
857         // Adjust the balance record and actual token balance
858         uint oldBalance = _records[token].balance;
859         _records[token].balance = balance;
860         if (balance > oldBalance) {
861             _pullUnderlying(token, msg.sender, bsub(balance, oldBalance));
862         } else if (balance < oldBalance) {
863             // In this case liquidity is being withdrawn, so charge EXIT_FEE
864             uint tokenBalanceWithdrawn = bsub(oldBalance, balance);
865             uint tokenExitFee = bmul(tokenBalanceWithdrawn, EXIT_FEE);
866             _pushUnderlying(token, msg.sender, bsub(tokenBalanceWithdrawn, tokenExitFee));
867             _pushUnderlying(token, _factory, tokenExitFee);
868         }
869     }
870    
871     function saveLostTokens(address token, uint amount)
872         external
873         _logs_
874         _lock_
875     {
876         require(msg.sender == _controller);
877         require(!_records[token].bound);
878 
879         uint bal = IERC20(token).balanceOf(address(this));
880         require(amount <= bal);
881 
882         _pushUnderlying(token, msg.sender, amount);
883     }
884 
885     function getSpotPrice(address tokenIn, address tokenOut)
886         external view
887         _viewlock_
888         returns (uint spotPrice)
889     {
890         require(_records[tokenIn].bound, "ERR_NOT_BOUND");
891         require(_records[tokenOut].bound, "ERR_NOT_BOUND");
892         Record storage inRecord = _records[tokenIn];
893         Record storage outRecord = _records[tokenOut];
894         return calcSpotPrice(inRecord.balance, inRecord.denorm, outRecord.balance, outRecord.denorm, _swapFee);
895     }
896 
897     function addBothLiquidity(uint poolAmountOut, uint[] calldata maxAmountsIn)
898         external
899         _logs_
900         _lock_
901     {
902         require(_launched, "ERR_NOT_LAUNCHED");
903 
904         uint poolTotal = totalSupply();
905         uint ratio = bdiv(poolAmountOut, poolTotal);
906         require(ratio != 0, "ERR_MATH_APPROX");
907 
908         for (uint i = 0; i < _tokens.length; i++) {
909             address t = _tokens[i];
910             uint bal = _records[t].balance;
911             uint tokenAmountIn = bmul(ratio, bal);
912             require(tokenAmountIn != 0, "ERR_MATH_APPROX");
913             require(tokenAmountIn <= maxAmountsIn[i], "ERR_LIMIT_IN");
914             emit LOG_JOIN(msg.sender, t, tokenAmountIn, 0);
915             _pullUnderlying(t, msg.sender, tokenAmountIn);
916             _records[FEG].balance = IERC20(FEG).balanceOf(address(this));
917             _records[fETH].balance = IERC20(fETH).balanceOf(address(this));
918         }
919         _mintPoolShare(poolAmountOut);
920         _pushPoolShare(msg.sender, poolAmountOut);
921         
922     }
923    
924     function removeBothLiquidity(uint poolAmountIn, uint[] calldata minAmountsOut)
925         external
926         _logs_
927         _lock_
928     {
929         require(_launched, "ERR_NOT_LAUNCHED");
930         userLock storage ulock = _userlock[msg.sender];
931         
932         if(ulock.setLock == true) {
933             require(ulock.unlockTime <= block.timestamp, "Liquidity is locked, you cannot removed liquidity until after lock time.");
934         }
935 
936         uint poolTotal = totalSupply();
937         uint exitFee = bmul(poolAmountIn, EXIT_FEE);
938         uint pAiAfterExitFee = bsub(poolAmountIn, exitFee);
939         uint ratio = bdiv(pAiAfterExitFee, poolTotal);
940         require(ratio != 0, "ERR_MATH_APPROX");
941 
942         _pullPoolShare(msg.sender, poolAmountIn);
943         _pushPoolShare(_factory, exitFee);
944         _burnPoolShare(pAiAfterExitFee);
945         
946         
947         for (uint i = 0; i < _tokens.length; i++) {
948             address t = _tokens[i];
949             uint bal = _records[t].balance;
950             uint tokenAmountOut = bmul(ratio, bal);
951             require(tokenAmountOut != 0, "ERR_MATH_APPROX");
952             require(tokenAmountOut >= minAmountsOut[i], "ERR_LIMIT_OUT");
953             emit LOG_EXIT(msg.sender, t, tokenAmountOut, 0);
954             _pushUnderlying(t, msg.sender, tokenAmountOut);
955             _records[FEG].balance = IERC20(FEG).balanceOf(address(this));
956             _records[fETH].balance = IERC20(fETH).balanceOf(address(this));
957         }
958 
959     }
960 
961 
962     function BUY(
963         address tokenIn,
964         uint tokenAmountIn,
965         address tokenOut,
966         uint minAmountOut,
967         uint maxPrice
968     ) noContract
969         external
970         _logs_
971         _lock_
972         returns (uint tokenAmountOut, uint spotPriceAfter)
973     {
974         
975         require(tokenIn == fETH, "Can only buy with fETH");
976         require(_records[tokenIn].bound, "ERR_NOT_BOUND");
977         require(_records[tokenOut].bound, "ERR_NOT_BOUND");
978         require(_publicSwap, "ERR_SWAP_NOT_PUBLIC");
979         
980         Record storage inRecord = _records[address(tokenIn)];
981         Record storage outRecord = _records[address(tokenOut)];
982 
983         require(tokenAmountIn <= bmul(inRecord.balance, MAX_IN_RATIO), "ERR_MAX_IN_RATIO");
984 
985         uint spotPriceBefore = calcSpotPrice(
986                                     inRecord.balance,
987                                     inRecord.denorm,
988                                     outRecord.balance,
989                                     outRecord.denorm,
990                                     _swapFee
991                                 );
992         require(spotPriceBefore <= maxPrice, "ERR_BAD_LIMIT_PRICE");
993 
994         uint tokenInFee;
995         (tokenAmountOut, tokenInFee) = calcOutGivenIn(
996                                             inRecord.balance,
997                                             inRecord.denorm,
998                                             outRecord.balance,
999                                             outRecord.denorm,
1000                                             tokenAmountIn * 99/100,
1001                                             _swapFee * 0
1002                                         );
1003         require(tokenAmountOut >= minAmountOut, "ERR_LIMIT_OUT");
1004 
1005         uint reserves = calcReservesFromFee(tokenInFee, _reservesRatio);
1006 
1007         spotPriceAfter = calcSpotPrice(
1008                                 inRecord.balance,
1009                                 inRecord.denorm,
1010                                 outRecord.balance,
1011                                 outRecord.denorm,
1012                                 _swapFee
1013                             );
1014         require(spotPriceAfter >= spotPriceBefore, "ERR_MATH_APPROX");
1015         require(spotPriceAfter <= maxPrice, "ERR_LIMIT_PRICE");
1016         require(spotPriceBefore <= bdiv(tokenAmountIn, tokenAmountOut), "ERR_MATH_APPROX");
1017 
1018         emit LOG_SWAP(msg.sender, tokenIn, tokenOut, tokenAmountIn * 99/100, tokenAmountOut, reserves);
1019 
1020         totalReserves[address(tokenIn)] = badd(totalReserves[address(tokenIn)], reserves);
1021         emit LOG_ADD_RESERVES(address(tokenIn), reserves);
1022 
1023         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1024         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1025         _records[FEG].balance = IERC20(FEG).balanceOf(address(this));
1026         _records[fETH].balance = IERC20(fETH).balanceOf(address(this));
1027         return (tokenAmountOut, spotPriceAfter);
1028     }
1029 
1030     function SELL(
1031         address tokenIn,
1032         uint tokenAmountIn,
1033         address tokenOut,
1034         uint minAmountOut,
1035         uint maxPrice
1036     ) noContract
1037         external
1038         _logs_
1039         _lock_
1040         returns (uint tokenAmountOut, uint spotPriceAfter)
1041     {
1042         
1043         require(tokenIn == FEG, "Can only sell FEG");
1044         require(_records[tokenIn].bound, "ERR_NOT_BOUND");
1045         require(_records[tokenOut].bound, "ERR_NOT_BOUND");
1046         require(_publicSwap, "ERR_SWAP_NOT_PUBLIC");
1047 
1048         Record storage inRecord = _records[address(tokenIn)];
1049         Record storage outRecord = _records[address(tokenOut)];
1050 
1051         require(tokenAmountIn <= bmul(inRecord.balance, MAX_SELL_RATIO), "ERR_SELL_RATIO");
1052 
1053         uint spotPriceBefore = calcSpotPrice(
1054                                     inRecord.balance,
1055                                     inRecord.denorm,
1056                                     outRecord.balance,
1057                                     outRecord.denorm,
1058                                     _swapFee
1059                                 );
1060         require(spotPriceBefore <= maxPrice, "ERR_BAD_LIMIT_PRICE");
1061 
1062         uint tokenInFee;
1063         (tokenAmountOut, tokenInFee) = calcOutGivenIn(
1064                                             inRecord.balance,
1065                                             inRecord.denorm,
1066                                             outRecord.balance,
1067                                             outRecord.denorm,
1068                                             tokenAmountIn * 98/100,
1069                                             _swapFee
1070                                         );
1071         require(tokenAmountOut >= minAmountOut, "ERR_LIMIT_OUT");
1072 
1073         uint reserves = calcReservesFromFee(tokenInFee, _reservesRatio);
1074 
1075         spotPriceAfter = calcSpotPrice(
1076                                 inRecord.balance,
1077                                 inRecord.denorm,
1078                                 outRecord.balance,
1079                                 outRecord.denorm,
1080                                 _swapFee
1081                             );
1082         require(spotPriceAfter >= spotPriceBefore, "ERR_MATH_APPROX");
1083         require(spotPriceAfter <= maxPrice, "ERR_LIMIT_PRICE");
1084         require(spotPriceBefore <= bdiv(tokenAmountIn, tokenAmountOut), "ERR_MATH_APPROX");
1085 
1086         emit LOG_SWAP(msg.sender, tokenIn, tokenOut, tokenAmountIn * 98/100, tokenAmountOut, reserves);
1087 
1088         totalReserves[address(tokenIn)] = badd(totalReserves[address(tokenIn)], reserves);
1089         emit LOG_ADD_RESERVES(address(tokenIn), reserves);
1090         
1091         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1092         uint256 tokAmountI  = bmul(tokenAmountOut, bdiv(25, 10000));
1093         //uint256 tokAmountI2 =  bmul(tokenAmountOut, bdiv(10, 10000));
1094         //uint256 tokAmountI1 = bsub(tokenAmountOut, badd(tokAmountI, tokAmountI2));
1095         uint256 tokAmountI1 = bsub(tokenAmountOut, tokAmountI);
1096         _pushUnderlying(tokenOut, msg.sender, tokAmountI1);
1097         _pushUnderlying1(tokenOut, tokAmountI);
1098         //_pushUnderlying2(tokenOut, tokAmountI2);
1099         
1100         _records[FEG].balance = IERC20(FEG).balanceOf(address(this));
1101         _records[fETH].balance = IERC20(fETH).balanceOf(address(this));
1102         return (tokenAmountOut, spotPriceAfter);
1103     }
1104     
1105     function setLockLiquidity() external {
1106         address user = msg.sender;
1107         userLock storage ulock = _userlock[user];
1108         
1109         ulock.setLock = true;
1110         ulock.unlockTime = block.timestamp + 90 days ; 
1111     }
1112     
1113     function emergencyLockOverride(address user, bool _bool) external {
1114         require(msg.sender == _controller);
1115         //address user = msg.sender;
1116         userLock storage ulock = _userlock[user];
1117         ulock.setLock = _bool;
1118     }
1119   
1120     
1121     function addLiquidityfETH(address tokenIn, uint tokenAmountIn, uint minPoolAmountOut)
1122         external
1123         _logs_
1124         _lock_
1125         returns (uint poolAmountOut)
1126 
1127     {
1128         require(tokenIn == fETH, "Can only add fETH");
1129         require(_launched, "ERR_NOT_FINALIZED");
1130         require(_records[tokenIn].bound, "ERR_NOT_BOUND");
1131         require(tokenAmountIn <= bmul(_records[tokenIn].balance, MAX_1_RATIO), "ERR_MAX_IN_RATIO");
1132 
1133         Record storage inRecord = _records[tokenIn];
1134 
1135         uint reserves;
1136         (poolAmountOut, reserves) = calcPoolOutGivenSingleIn(
1137                             inRecord.balance,
1138                             inRecord.denorm,
1139                             _totalSupply,
1140                             _totalWeight,
1141                             tokenAmountIn,
1142                             _swapFee,
1143                             _reservesRatio
1144                         );
1145 
1146         require(poolAmountOut >= minPoolAmountOut, "ERR_LIMIT_OUT");
1147 
1148         //inRecord.balance = bsub(badd(inRecord.balance, reserves);
1149 
1150         emit LOG_JOIN(msg.sender, tokenIn, tokenAmountIn, reserves);
1151 
1152         totalReserves[address(tokenIn)] = badd(totalReserves[address(tokenIn)], reserves);
1153         emit LOG_ADD_RESERVES(address(tokenIn), reserves);
1154 
1155         _mintPoolShare(poolAmountOut);
1156         _pushPoolShare(msg.sender, poolAmountOut);
1157         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1158         _records[FEG].balance = IERC20(FEG).balanceOf(address(this));
1159         _records[fETH].balance = IERC20(fETH).balanceOf(address(this));
1160         return poolAmountOut;
1161     }
1162 
1163     function addLiquidityFEG(address tokenIn, uint tokenAmountIn, uint minPoolAmountOut)
1164         external
1165         _logs_
1166         _lock_
1167         returns (uint poolAmountOut)
1168 
1169     {
1170         require(tokenIn == FEG, "Can only add FEG");
1171         require(_launched, "ERR_NOT_FINALIZED");
1172         require(_records[tokenIn].bound, "ERR_NOT_BOUND");
1173         require(tokenAmountIn <= bmul(_records[tokenIn].balance, MAX_1_RATIO), "ERR_MAX_IN_RATIO");
1174 
1175         Record storage inRecord = _records[tokenIn];
1176 
1177         uint reserves;
1178         (poolAmountOut, reserves) = calcPoolOutGivenSingleIn(
1179                             inRecord.balance,
1180                             inRecord.denorm,
1181                             _totalSupply,
1182                             _totalWeight,
1183                             tokenAmountIn,
1184                             _swapFee,
1185                             _reservesRatio
1186                         );
1187 
1188         require(poolAmountOut >= minPoolAmountOut, "ERR_LIMIT_OUT");
1189 
1190        // inRecord.balance = bsub(badd(inRecord.balance, tokenAmountIn * 98/100), reserves);
1191 
1192         emit LOG_JOIN(msg.sender, tokenIn, tokenAmountIn, reserves);
1193 
1194         totalReserves[address(tokenIn)] = badd(totalReserves[address(tokenIn)], reserves);
1195         emit LOG_ADD_RESERVES(address(tokenIn), reserves);
1196 
1197         _mintPoolShare(poolAmountOut);
1198         _pushPoolShare(msg.sender, poolAmountOut);
1199         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1200     
1201         return poolAmountOut;
1202     }
1203 
1204     function RemoveLiquidityPoolAmountIn(address tokenOut, uint poolAmountIn, uint minAmountOut)
1205         external
1206         _logs_
1207         _lock_
1208         returns (uint tokenAmountOut)
1209     {
1210         require(_launched, "ERR_NOT_LAUNCHED");
1211         require(_records[tokenOut].bound, "ERR_NOT_BOUND");
1212         
1213         userLock storage ulock = _userlock[msg.sender];
1214         
1215         if(ulock.setLock == true) {
1216             require(ulock.unlockTime <= block.timestamp, "Liquidity is locked, you cannot removed liquidity until after lock time.");
1217         }
1218 
1219         Record storage outRecord = _records[tokenOut];
1220 
1221         tokenAmountOut = calcSingleOutGivenPoolIn(
1222                             outRecord.balance,
1223                             outRecord.denorm,
1224                             _totalSupply,
1225                             _totalWeight,
1226                             poolAmountIn,
1227                             _swapFee
1228                         );
1229 
1230         require(tokenAmountOut >= minAmountOut, "ERR_LIMIT_OUT");
1231 
1232         require(tokenAmountOut <= bmul(_records[tokenOut].balance, MAX_1_RATIO), "ERR_MAX_OUT_RATIO");
1233 
1234         uint tokenAmountOutZeroFee = calcSingleOutGivenPoolIn(
1235             outRecord.balance,
1236             outRecord.denorm,
1237             _totalSupply,
1238             _totalWeight,
1239             poolAmountIn,
1240             0
1241         );
1242         uint reserves = calcReserves(
1243             tokenAmountOutZeroFee,
1244             tokenAmountOut,
1245             _reservesRatio
1246         );
1247 
1248         //outRecord.balance = bsub(bsub(outRecord.balance, tokenAmountOut), reserves);
1249 
1250         uint exitFee = bmul(poolAmountIn, EXIT_FEE);
1251 
1252         emit LOG_EXIT(msg.sender, tokenOut, tokenAmountOut, reserves);
1253 
1254         totalReserves[address(tokenOut)] = badd(totalReserves[address(tokenOut)], reserves);
1255         emit LOG_ADD_RESERVES(address(tokenOut), reserves);
1256 
1257         _pullPoolShare(msg.sender, poolAmountIn);
1258         _burnPoolShare(bsub(poolAmountIn, exitFee));
1259         _pushPoolShare(_factory, exitFee);
1260         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1261         _records[FEG].balance = IERC20(FEG).balanceOf(address(this));
1262         _records[fETH].balance = IERC20(fETH).balanceOf(address(this));
1263         return tokenAmountOut;
1264     }
1265 
1266     function RemoveLiquidityExtactAmountOut(address tokenOut, uint tokenAmountOut, uint maxPoolAmountIn)
1267         external
1268         _logs_
1269         _lock_
1270         returns (uint poolAmountIn)
1271     {
1272         require(_launched, "ERR_NOT_LAUNCHED");
1273         require(_records[tokenOut].bound, "ERR_NOT_BOUND");
1274         require(tokenAmountOut <= bmul(_records[tokenOut].balance, MAX_1_RATIO), "ERR_MAX_OUT_RATIO");
1275 
1276         userLock storage ulock = _userlock[msg.sender];
1277         
1278         if(ulock.setLock == true) {
1279             require(ulock.unlockTime <= block.timestamp, "Liquidity is locked, you cannot removed liquidity until after lock time.");
1280         }
1281         
1282         
1283         Record storage outRecord = _records[tokenOut];
1284 
1285         uint reserves;
1286         (poolAmountIn, reserves) = calcPoolInGivenSingleOut(
1287                             outRecord.balance,
1288                             outRecord.denorm,
1289                             _totalSupply,
1290                             _totalWeight,
1291                             tokenAmountOut,
1292                             _swapFee,
1293                             _reservesRatio
1294                         );
1295 
1296         require(poolAmountIn != 0, "ERR_MATH_APPROX");
1297         require(poolAmountIn <= maxPoolAmountIn, "ERR_LIMIT_IN");
1298 
1299         outRecord.balance = bsub(bsub(outRecord.balance, tokenAmountOut), reserves);
1300 
1301         uint exitFee = bmul(poolAmountIn, EXIT_FEE);
1302 
1303         emit LOG_EXIT(msg.sender, tokenOut, tokenAmountOut, reserves);
1304 
1305         totalReserves[address(tokenOut)] = badd(totalReserves[address(tokenOut)], reserves);
1306         emit LOG_ADD_RESERVES(address(tokenOut), reserves);
1307 
1308         _pullPoolShare(msg.sender, poolAmountIn);
1309         _burnPoolShare(bsub(poolAmountIn, exitFee));
1310         _pushPoolShare(_factory, exitFee);
1311         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1312         _records[FEG].balance = IERC20(FEG).balanceOf(address(this));
1313         _records[fETH].balance = IERC20(fETH).balanceOf(address(this));
1314         return poolAmountIn;
1315     }
1316 
1317     function claimTotalReserves(address reservesAddress)
1318         external
1319         _logs_
1320         _lock_
1321     {
1322         require(msg.sender == _factory);
1323 
1324         for (uint i = 0; i < _tokens.length; i++) {
1325             address t = _tokens[i];
1326             uint tokenAmountOut = totalReserves[t];
1327             totalReserves[t] = 0;
1328             emit LOG_CLAIM_RESERVES(reservesAddress, t, tokenAmountOut);
1329             _pushUnderlying(t, reservesAddress, tokenAmountOut);
1330         }
1331     }
1332 
1333     // ==
1334     // 'Underlying' token-manipulation functions make external calls but are NOT locked
1335     // You must `_lock_` or otherwise ensure reentry-safety
1336 
1337     function _pullUnderlying(address erc20, address from, uint amount)
1338         internal
1339     {
1340         bool xfer = IERC20(erc20).transferFrom(from, address(this), amount);
1341         require(xfer, "ERR_ERC20_FALSE");
1342     }
1343 
1344     function _pushUnderlying(address erc20, address to, uint amount)
1345         internal
1346     {
1347         bool xfer = IERC20(erc20).transfer(to, amount);
1348         require(xfer, "ERR_ERC20_FALSE");
1349     }
1350     
1351     function _pushUnderlying1(address erc20, uint amount)
1352         internal
1353     {
1354         bool xfer = IERC20(erc20).transfer(FEGstake, amount);
1355         require(xfer, "ERR_ERC20_FALSE");
1356     }
1357     
1358     function _pushUnderlying2(address erc20, uint amount)
1359         internal
1360     {
1361         bool xfer = IERC20(erc20).transfer(pairRewardPool, amount);
1362         require(xfer, "ERR_ERC20_FALSE");
1363     }
1364 
1365     function _pullPoolShare(address from, uint amount)
1366         internal
1367     {
1368         _pull(from, amount);
1369     }
1370 
1371     function _pushPoolShare(address to, uint amount)
1372         internal
1373     {
1374         _push(to, amount);
1375     }
1376 
1377     function _mintPoolShare(uint amount)
1378         internal
1379     {
1380         _mint(amount);
1381     }
1382 
1383     function _burnPoolShare(uint amount)
1384         internal
1385     {
1386         _burn(amount);
1387     }
1388 
1389 }