1 pragma solidity 0.7.6;     
2 
3 // SPDX-License-Identifier: UNLICENSED 
4 
5 
6 abstract contract ReentrancyGuard {
7 
8     uint256 private constant _NOT_ENTERED = 1;
9     uint256 private constant _ENTERED = 2;
10 
11     uint256 private _status;
12 
13     constructor () {
14         _status = _NOT_ENTERED;
15     }
16 
17     modifier nonReentrant() {
18 
19         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
20 
21         _status = _ENTERED;
22 
23         _;
24 
25         _status = _NOT_ENTERED;
26     }
27 }
28 
29 contract FSilver  {
30      function getColor()
31         external pure
32         returns (bytes32) {
33             return bytes32("BRONZE");
34         }
35 }
36 
37 
38 contract FConst is FSilver, ReentrancyGuard {
39     uint public constant BASE              = 10**18;
40 
41     uint public constant MIN_BOUND_TOKENS  = 2;
42     uint public constant MAX_BOUND_TOKENS  = 2;
43 
44     uint public constant MIN_FEE           = 2000000000000000; 
45     uint public constant MAX_FEE           = 2000000000000000; // FREE BUYS and sells pay 0.2% to liquidity providers
46     uint public constant EXIT_FEE          = BASE / 100;
47     uint public constant DEFAULT_RESERVES_RATIO = 0;
48 
49     uint public constant MIN_WEIGHT        = BASE;
50     uint public constant MAX_WEIGHT        = BASE * 50;
51     uint public constant MAX_TOTAL_WEIGHT  = BASE * 50;
52     uint public constant MIN_BALANCE       = BASE / 10**12;
53 
54     uint public constant INIT_POOL_SUPPLY  = BASE * 100;
55     
56     uint public  SM = 10;
57     address public FEGstake = 0x04788562Ab11eA3a5201d579e2b3Ee7A3F74F1fA;
58 
59     uint public constant MIN_BPOW_BASE     = 1 wei;
60     uint public constant MAX_BPOW_BASE     = (2 * BASE) - 1 wei;
61     uint public constant BPOW_PRECISION    = BASE / 10**10;
62 
63     uint public constant MAX_IN_RATIO      = BASE / 2;
64     uint public constant MAX_OUT_RATIO     = (BASE / 3) + 1 wei;
65     uint public MAX_SELL_RATIO             = BASE / SM;
66 }
67 
68 
69 contract FNum is ReentrancyGuard, FConst {
70 
71     function btoi(uint a)
72         internal pure
73         returns (uint)
74     {
75         return a / BASE;
76     }
77 
78     function bfloor(uint a)
79         internal pure
80         returns (uint)
81     {
82         return btoi(a) * BASE;
83     }
84 
85     function badd(uint a, uint b)
86         internal pure
87         returns (uint)
88     {
89         uint c = a + b;
90         require(c >= a, "ERR_ADD_OVERFLOW");
91         return c;
92     }
93 
94     function bsub(uint a, uint b)
95         internal pure
96         returns (uint)
97     {
98         (uint c, bool flag) = bsubSign(a, b);
99         require(!flag, "ERR_SUB_UNDERFLOW");
100         return c;
101     }
102 
103     function bsubSign(uint a, uint b)
104         internal pure
105         returns (uint, bool)
106     {
107         if (a >= b) {
108             return (a - b, false);
109         } else {
110             return (b - a, true);
111         }
112     }
113 
114     function bmul(uint a, uint b)
115         internal pure
116         returns (uint)
117     {
118         uint c0 = a * b;
119         require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
120         uint c1 = c0 + (BASE / 2);
121         require(c1 >= c0, "ERR_MUL_OVERFLOW");
122         uint c2 = c1 / BASE;
123         return c2;
124     }
125 
126     function bdiv(uint a, uint b)
127         internal pure
128         returns (uint)
129     {
130         require(b != 0, "ERR_DIV_ZERO");
131         uint c0 = a * BASE;
132         require(a == 0 || c0 / a == BASE, "ERR_DIV_INTERNAL"); // bmul overflow
133         uint c1 = c0 + (b / 2);
134         require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
135         uint c2 = c1 / b;
136         return c2;
137     }
138 
139     function bpowi(uint a, uint n)
140         internal pure
141         returns (uint)
142     {
143         uint z = n % 2 != 0 ? a : BASE;
144 
145         for (n /= 2; n != 0; n /= 2) {
146             a = bmul(a, a);
147 
148             if (n % 2 != 0) {
149                 z = bmul(z, a);
150             }
151         }
152         return z;
153     }
154 
155     function bpow(uint base, uint exp)
156         internal pure
157         returns (uint)
158     {
159         require(base >= MIN_BPOW_BASE, "ERR_BPOW_BASE_TOO_LOW");
160         require(base <= MAX_BPOW_BASE, "ERR_BPOW_BASE_TOO_HIGH");
161 
162         uint whole  = bfloor(exp);
163         uint remain = bsub(exp, whole);
164 
165         uint wholePow = bpowi(base, btoi(whole));
166 
167         if (remain == 0) {
168             return wholePow;
169         }
170 
171         uint partialResult = bpowApprox(base, remain, BPOW_PRECISION);
172         return bmul(wholePow, partialResult);
173     }
174 
175     function bpowApprox(uint base, uint exp, uint precision)
176         internal pure
177         returns (uint)
178     {
179         uint a     = exp;
180         (uint x, bool xneg)  = bsubSign(base, BASE);
181         uint term = BASE;
182         uint sum   = term;
183         bool negative = false;
184 
185 
186         for (uint i = 1; term >= precision; i++) {
187             uint bigK = i * BASE;
188             (uint c, bool cneg) = bsubSign(a, bsub(bigK, BASE));
189             term = bmul(term, bmul(c, x));
190             term = bdiv(term, bigK);
191             if (term == 0) break;
192 
193             if (xneg) negative = !negative;
194             if (cneg) negative = !negative;
195             if (negative) {
196                 sum = bsub(sum, term);
197             } else {
198                 sum = badd(sum, term);
199             }
200         }
201 
202         return sum;
203     }
204 }
205 
206 contract FMath is FSilver, FConst, FNum {
207     
208         function calcSpotPrice(
209         uint tokenBalanceIn,
210         uint tokenWeightIn,
211         uint tokenBalanceOut,
212         uint tokenWeightOut,
213         uint swapFee
214     )
215         public pure
216         returns (uint spotPrice)
217     {
218         uint numer = bdiv(tokenBalanceIn, tokenWeightIn);
219         uint denom = bdiv(tokenBalanceOut, tokenWeightOut);
220         uint ratio = bdiv(numer, denom);
221         uint scale = bdiv(BASE, bsub(BASE, swapFee));
222         return  (spotPrice = bmul(ratio, scale));
223     }
224 
225 
226     function calcOutGivenIn(
227         uint tokenBalanceIn,
228         uint tokenWeightIn,
229         uint tokenBalanceOut,
230         uint tokenWeightOut,
231         uint tokenAmountIn,
232         uint swapFee
233     )
234         public pure
235         returns (uint tokenAmountOut, uint tokenInFee)
236     {
237         uint weightRatio = bdiv(tokenWeightIn, tokenWeightOut);
238         uint adjustedIn = bsub(BASE, swapFee);
239         adjustedIn = bmul(tokenAmountIn, adjustedIn);
240         uint y = bdiv(tokenBalanceIn, badd(tokenBalanceIn, adjustedIn));
241         uint foo = bpow(y, weightRatio);
242         uint bar = bsub(BASE, foo);
243         tokenAmountOut = bmul(tokenBalanceOut, bar);
244         tokenInFee = bsub(tokenAmountIn, adjustedIn);
245         return (tokenAmountOut, tokenInFee);
246     }
247 
248 
249     function calcInGivenOut(
250         uint tokenBalanceIn,
251         uint tokenWeightIn,
252         uint tokenBalanceOut,
253         uint tokenWeightOut,
254         uint tokenAmountOut,
255         uint swapFee
256     )
257         public pure
258         returns (uint tokenAmountIn, uint tokenInFee)
259     {
260         uint weightRatio = bdiv(tokenWeightOut, tokenWeightIn);
261         uint diff = bsub(tokenBalanceOut, tokenAmountOut);
262         uint y = bdiv(tokenBalanceOut, diff);
263         uint foo = bpow(y, weightRatio);
264         foo = bsub(foo, BASE);
265         foo = bmul(tokenBalanceIn, foo);
266         tokenAmountIn = bsub(BASE, swapFee);
267         tokenAmountIn = bdiv(foo, tokenAmountIn);
268         tokenInFee = bdiv(foo, BASE);
269         tokenInFee = bsub(tokenAmountIn, tokenInFee);
270         return (tokenAmountIn, tokenInFee);
271     }
272 
273 
274     function calcPoolOutGivenSingleIn(
275         uint tokenBalanceIn,
276         uint tokenWeightIn,
277         uint poolSupply,
278         uint totalWeight,
279         uint tokenAmountIn,
280         uint swapFee,
281         uint reservesRatio
282     )
283         public pure
284         returns (uint poolAmountOut, uint reserves)
285     {
286 
287         uint normalizedWeight = bdiv(tokenWeightIn, totalWeight);
288          uint zaz = bmul(bsub(BASE, normalizedWeight), swapFee);
289         uint tokenAmountInAfterFee = bmul(tokenAmountIn, bsub(BASE, zaz));
290 
291         reserves = calcReserves(tokenAmountIn, tokenAmountInAfterFee, reservesRatio);
292         uint newTokenBalanceIn = badd(tokenBalanceIn, tokenAmountInAfterFee);
293         uint tokenInRatio = bdiv(newTokenBalanceIn, tokenBalanceIn);
294 
295  
296         uint poolRatio = bpow(tokenInRatio, normalizedWeight);
297         uint newPoolSupply = bmul(poolRatio, poolSupply);
298         poolAmountOut = bsub(newPoolSupply, poolSupply);
299         return (poolAmountOut, reserves);
300     }
301 
302     function calcSingleOutGivenPoolIn(
303         uint tokenBalanceOut,
304         uint tokenWeightOut,
305         uint poolSupply,
306         uint totalWeight,
307         uint poolAmountIn,
308         uint swapFee
309     )
310         public pure
311         returns (uint tokenAmountOut)
312     {
313         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
314 
315         uint poolAmountInAfterExitFee = bmul(poolAmountIn, bsub(BASE, EXIT_FEE));
316         uint newPoolSupply = bsub(poolSupply, poolAmountInAfterExitFee);
317         uint poolRatio = bdiv(newPoolSupply, poolSupply);
318 
319 
320         uint tokenOutRatio = bpow(poolRatio, bdiv(BASE, normalizedWeight));
321         uint newTokenBalanceOut = bmul(tokenOutRatio, tokenBalanceOut);
322 
323         uint tokenAmountOutBeforeSwapFee = bsub(tokenBalanceOut, newTokenBalanceOut);
324         uint zaz = bmul(bsub(BASE, normalizedWeight), swapFee);
325         tokenAmountOut = bmul(tokenAmountOutBeforeSwapFee, bsub(BASE, zaz));
326         return tokenAmountOut;
327     }
328 
329 
330     function calcPoolInGivenSingleOut(
331         uint tokenBalanceOut,
332         uint tokenWeightOut,
333         uint poolSupply,
334         uint totalWeight,
335         uint tokenAmountOut,
336         uint swapFee,
337         uint reservesRatio
338     )
339         public pure
340         returns (uint poolAmountIn, uint reserves)
341     {
342 
343 
344         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
345         uint zar = bmul(bsub(BASE, normalizedWeight), swapFee);
346         uint tokenAmountOutBeforeSwapFee = bdiv(tokenAmountOut, bsub(BASE, zar));
347         reserves = calcReserves(tokenAmountOutBeforeSwapFee, tokenAmountOut, reservesRatio);
348 
349         uint newTokenBalanceOut = bsub(tokenBalanceOut, tokenAmountOutBeforeSwapFee);
350         uint tokenOutRatio = bdiv(newTokenBalanceOut, tokenBalanceOut);
351 
352 
353         uint poolRatio = bpow(tokenOutRatio, normalizedWeight);
354         uint newPoolSupply = bmul(poolRatio, poolSupply);
355         uint poolAmountInAfterExitFee = bsub(poolSupply, newPoolSupply);
356 
357 
358         poolAmountIn = bdiv(poolAmountInAfterExitFee, bsub(BASE, EXIT_FEE));
359         return (poolAmountIn, reserves);
360     }
361 
362     function calcReserves(uint amountWithFee, uint amountWithoutFee, uint reservesRatio)
363         internal pure
364         returns (uint reserves)
365     {
366         require(amountWithFee >= amountWithoutFee, "ERR_MATH_APPROX");
367         require(reservesRatio <= BASE, "ERR_INVALID_RESERVE");
368         uint swapFeeAndReserves = bsub(amountWithFee, amountWithoutFee);
369         reserves = bmul(swapFeeAndReserves, reservesRatio);
370         require(swapFeeAndReserves >= reserves, "ERR_MATH_APPROX");
371     }
372 
373     function calcReservesFromFee(uint fee, uint reservesRatio)
374         internal pure
375         returns (uint reserves)
376     {
377         require(reservesRatio <= BASE, "ERR_INVALID_RESERVE");
378         reserves = bmul(fee, reservesRatio);
379     }
380 }
381 
382 interface IERC20 {
383 
384     function totalSupply() external view returns (uint);
385     function balanceOf(address whom) external view returns (uint);
386     function allowance(address src, address dst) external view returns (uint);
387 
388     function approve(address dst, uint amt) external returns (bool);
389     function transfer(address dst, uint amt) external returns (bool);
390     function transferFrom(
391         address src, address dst, uint amt
392     ) external returns (bool);
393 }
394 
395 interface wrap {
396     function deposit() external payable;
397     function withdraw(uint amt) external;
398     function transfer(address recipient, uint256 amount) external returns (bool);
399 }
400 
401 library TransferHelper {
402     function safeApprove(address token, address to, uint value) internal {
403         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
404         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
405     }
406 
407     function safeTransfer(address token, address to, uint value) internal {
408         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
409         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
410     }
411 
412     function safeTransferFrom(address token, address from, address to, uint value) internal {
413         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
414         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
415     }
416 
417     function safeTransferETH(address to, uint value) internal {
418         (bool success,) = to.call{value:value}(new bytes(0));
419         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
420     }
421 }
422 
423 contract FTokenBase is ReentrancyGuard, FNum {
424 
425     mapping(address => uint)                   internal _balance;
426     mapping(address => mapping(address=>uint)) internal _allowance;
427     uint internal _totalSupply;
428 
429     event Approval(address indexed src, address indexed dst, uint amt);
430     event Transfer(address indexed src, address indexed dst, uint amt);
431 
432     function _mint(uint amt) internal {
433         _balance[address(this)] = badd(_balance[address(this)], amt);
434         _totalSupply = badd(_totalSupply, amt);
435         emit Transfer(address(0), address(this), amt);
436     }
437 
438     function _burn(uint amt) internal {
439         require(_balance[address(this)] >= amt);
440         _balance[address(this)] = bsub(_balance[address(this)], amt);
441         _totalSupply = bsub(_totalSupply, amt);
442         emit Transfer(address(this), address(0), amt);
443     }
444 
445     function _move(address src, address dst, uint amt) internal {
446         require(_balance[src] >= amt);
447         _balance[src] = bsub(_balance[src], amt);
448         _balance[dst] = badd(_balance[dst], amt);
449         emit Transfer(src, dst, amt);
450     }
451 
452     function _push(address to, uint amt) internal {
453         _move(address(this), to, amt);
454     }
455 
456     function _pull(address from, uint amt) internal {
457         _move(from, address(this), amt);
458     }
459 }
460 
461 contract FToken is ReentrancyGuard, FTokenBase {
462 
463     string  private _name     = "FEGexV2";
464     string  private _symbol   = "FEGfETH";
465     uint8   private _decimals = 18;
466 
467     function name() public view returns (string memory) {
468         return _name;
469     }
470 
471     function symbol() public view returns (string memory) {
472         return _symbol;
473     }
474 
475     function decimals() public view returns(uint8) {
476         return _decimals;
477     }
478 
479     function allowance(address src, address dst) external view returns (uint) {
480         return _allowance[src][dst];
481     }
482 
483     function balanceOf(address whom) external view returns (uint) {
484         return _balance[whom];
485     }
486 
487     function totalSupply() public view returns (uint) {
488         return _totalSupply;
489     }
490 
491     function approve(address dst, uint amt) external returns (bool) {
492         _allowance[msg.sender][dst] = amt;
493         emit Approval(msg.sender, dst, amt);
494         return true;
495     }
496 
497     function increaseApproval(address dst, uint amt) external returns (bool) {
498         _allowance[msg.sender][dst] = badd(_allowance[msg.sender][dst], amt);
499         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
500         return true;
501     }
502 
503     function decreaseApproval(address dst, uint amt) external returns (bool) {
504         uint oldValue = _allowance[msg.sender][dst];
505         if (amt > oldValue) {
506             _allowance[msg.sender][dst] = 0;
507         } else {
508             _allowance[msg.sender][dst] = bsub(oldValue, amt);
509         }
510         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
511         return true;
512     }
513 
514     function transfer(address dst, uint amt) external returns (bool) {
515         FEGexV2 ulock;
516         bool getlock = ulock.getUserLock(msg.sender);
517         
518         require(getlock == true, 'Liquidity is locked, you cannot remove liquidity until after lock time.');
519         
520         _move(msg.sender, dst, amt);
521         return true;
522     }
523 
524     function transferFrom(address src, address dst, uint amt) external returns (bool) {
525         require(msg.sender == src || amt <= _allowance[src][msg.sender]);
526         FEGexV2 ulock;
527         bool getlock = ulock.getUserLock(msg.sender);
528         
529         require(getlock == true, 'Transfer is Locked ');
530         
531         
532         _move(src, dst, amt);
533         if (msg.sender != src && _allowance[src][msg.sender] != uint256(-1)) {
534             _allowance[src][msg.sender] = bsub(_allowance[src][msg.sender], amt);
535             emit Approval(msg.sender, dst, _allowance[src][msg.sender]);
536         }
537         return true;
538     }
539 }
540 
541 contract FEGexV2 is FSilver, ReentrancyGuard, FToken, FMath {
542 
543     struct Record {
544         bool bound;   // is token bound to pool
545         uint denorm;  // denormalized weight will always be even
546         uint index;
547         uint balance;
548     }
549     
550     struct userLock {
551         bool setLock; // true = locked, false = unlocked
552         uint unlockTime;
553     }
554     
555     function getUserLock(address usr) public view returns(bool lock){
556         return _userlock[usr].setLock;
557     }
558     
559     event LOG_SWAP(
560         address indexed caller,
561         address indexed tokenIn,
562         address indexed tokenOut,
563         uint256         tokenAmountIn,
564         uint256         tokenAmountOut
565 );
566 
567     event LOG_JOIN(
568         address indexed caller,
569         address indexed tokenIn,
570         uint256         tokenAmountIn,
571         uint256         reservesAmount
572 );
573 
574     event LOG_EXIT(
575         address indexed caller,
576         address indexed tokenOut,
577         uint256         tokenAmountOut,
578         uint256         reservesAmount
579     );
580 
581     event LOG_CLAIM_RESERVES(
582         address indexed caller,
583         address indexed tokenOut,
584         uint256         tokenAmountOut
585     );
586 
587     event LOG_ADD_RESERVES(
588         address indexed token,
589         uint256         reservesAmount
590     );
591 
592     event LOG_CALL(
593         bytes4  indexed sig,
594         address indexed caller,
595         bytes           data
596     ) anonymous;
597 
598     modifier _logs_() {
599         emit LOG_CALL(msg.sig, msg.sender, msg.data);
600         _;
601     }
602 
603     modifier _lock_() {
604         require(!_mutex);
605         _mutex = true;
606         _;
607         _mutex = false;
608     } 
609 
610     modifier _viewlock_() {
611         require(!_mutex);
612         _;
613     }
614 
615     bool private _mutex;
616 
617     wrap wrapp;
618     address private _factory = 0x1Eb421973d639C3422904c65Cccc2972b37a17e8;    
619     address private _controller = 0x4c9BC793716e8dC05d1F48D8cA8f84318Ec3043C; 
620     address private _poolOwner;
621     address public Wrap = 0xf786c34106762Ab4Eeb45a51B42a62470E9D5332;
622     address public Token = 0x389999216860AB8E0175387A0c90E5c52522C945;
623     address public pairRewardPool = 0x94D4Ac11689C6EbbA91cDC1430fc7dfa9a858753;
624     address public burn = 0x000000000000000000000000000000000000dEaD;
625     uint public FSS = 25; // FEGstake Share
626     uint public PSS = 20; // pairRewardPool Share
627     uint public RPF = 1000; //Smart Rising Price Floor Setting
628     uint public SHR = 995; //p2p fee Token
629     uint public SHR1 = 997; //p2p fee Wrap
630     uint private _swapFee;
631     address[] private _tokens;
632     uint256 public _totalSupply1;
633     uint256 public _totalSupply2;
634     bool public live = false;
635     mapping(address=>Record) private  _records;
636     mapping(address=>userLock) public  _userlock;
637     mapping(address=>userLock) public  _unlockTime;
638     mapping(address=>bool) public whiteListContract;
639     mapping(address => uint256) private _balances1;
640     mapping(address => uint256) private _balances2;
641     
642     uint private _totalWeight;
643 
644     constructor() {
645         wrapp = wrap(Wrap);
646         _poolOwner = msg.sender;
647         //pairRewardPool = msg.sender;
648         _swapFee = MIN_FEE;
649     }
650     
651     receive() external payable {
652     }
653 
654     function userBalanceInternal(address _addr) public view returns (uint256 token, uint256 fwrap) {
655         return (_balances1[_addr], _balances2[_addr]);
656     } 
657     
658     function isContract(address account) internal view returns (bool) {
659         
660         if(IsWhiteListContract(account)) {  return false; }
661         bytes32 codehash;
662         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
663         assembly { codehash := extcodehash(account) }
664         return (codehash != 0x0 && codehash != accountHash);
665     }
666     
667     function addWhiteListContract(address _addy, bool boolean) public {
668         require(msg.sender == _controller);
669         require(_addy != address(0), "setting 0 address;;");
670         
671         whiteListContract[_addy] = boolean;
672     }
673     
674     function IsWhiteListContract(address _addy) public view returns(bool){
675         require(_addy != address(0), "setting 0 address;;");
676         
677         return whiteListContract[_addy];
678     }
679     
680     modifier noContract() {
681         require(isContract(msg.sender) == false, 'Unapproved contracts are not allowed to interact with the swap');
682         _;
683     }
684     
685     function setMaxSellRatio(uint256 _amount) public {
686         require(msg.sender == _poolOwner, "You do not have permission");
687         require (_amount > 0, "cannot turn off");
688         require (_amount <= 100, "cannot set under 1%");
689         SM = _amount;
690     }
691     
692     function setStakePool(address _addy) public {
693         require(msg.sender == _controller);
694     FEGstake = _addy;
695     }
696     
697     function setPairRewardPool(address _addy) public {
698         require(msg.sender == _controller);
699     pairRewardPool = _addy;
700     }
701     
702     function setupWrap() public {
703         IERC20(address(this)).approve(address(Wrap), 100000000000000000e18);        
704     }  
705     
706     function isBound(address t)
707         external view
708         returns (bool)
709     {
710         return _records[t].bound;
711     }
712 
713     function getFinalTokens()
714         external view
715         _viewlock_
716         returns (address[] memory tokens)
717     {
718         
719         return _tokens;
720     }
721 
722     function getDenormalizedWeight(address token)
723         external view
724         _viewlock_
725     {
726 
727         require(_records[token].bound);
728     }
729 
730     function getTotalDenormalizedWeight()
731         external view
732         _viewlock_
733         returns (uint)
734     {
735         return _totalWeight;
736     }
737 
738     function getNormalizedWeight(address token)
739         external view
740         _viewlock_
741         returns (uint)
742     {
743 
744         require(_records[token].bound);
745         return _totalWeight;
746     }
747 
748     function getBalance(address token)
749         external view
750         _viewlock_
751         returns (uint)
752     {
753 
754         require(_records[token].bound);
755         return _records[token].balance;
756     }
757 
758     function getSwapFee()
759         external view
760         _viewlock_
761         returns (uint)
762     {
763         return _swapFee;
764     }
765 
766     function getController()
767         external view
768         _viewlock_
769         returns (address)
770     {
771         return _controller;
772     }
773 
774     function setController(address manager)
775         external
776         _logs_
777         _lock_
778     {
779         require(msg.sender == _controller);
780         _controller = manager;
781     }
782 
783     function deploySwap (uint256 amtoftoken, uint256 amtofwrap)
784         external
785         {
786         require(msg.sender == _poolOwner);
787         require(live == false);
788         address tokenIn = Token;
789         address tokenIn1 = Wrap;
790         
791         _records[Token] = Record({
792             bound: true,
793             denorm: BASE * 25,
794             index: _tokens.length,
795             balance: (amtoftoken * 98/100)
796             
797         });
798         
799         _records[Wrap] = Record({
800             bound: true,
801             denorm: BASE * 25,
802             index: _tokens.length,
803             balance: (amtofwrap * 99/100)
804         });
805         live = true;
806         _tokens.push(Token);
807         _tokens.push(Wrap);
808         _pullUnderlying(tokenIn, msg.sender, amtoftoken);
809         _pullUnderlying(tokenIn1, msg.sender, amtofwrap);
810         _mint(INIT_POOL_SUPPLY);
811         _pushPoolShare(msg.sender, INIT_POOL_SUPPLY); 
812         address user = msg.sender;
813         userLock storage ulock = _userlock[user];
814         userLock storage time = _unlockTime[user];
815         ulock.setLock = true;
816         time.unlockTime = block.timestamp + 365 days ; 
817     }
818    
819     function saveLostTokens(address token, uint amount)
820         external
821         _logs_
822         _lock_
823     {
824         require(msg.sender == _controller);
825         require(!_records[token].bound);
826 
827         uint bal = IERC20(token).balanceOf(address(this));
828         require(amount <= bal);
829 
830         _pushUnderlying(token, msg.sender, amount);
831     }
832 
833     function getSpotPrice(address tokenIn, address tokenOut)
834         external view
835         _viewlock_
836         returns (uint spotPrice)
837     {
838         
839         require(_records[tokenIn].bound, "ERR_NOT_BOUND");
840         require(_records[tokenOut].bound, "ERR_NOT_BOUND");
841         Record storage inRecord = _records[address(tokenIn)];
842         Record storage outRecord = _records[address(tokenOut)];
843         return calcSpotPrice(inRecord.balance, BASE * 25, outRecord.balance, BASE * 25, _swapFee);}
844         
845 
846     function depositToken(uint256 amt)  external noContract nonReentrant {
847         address tokenIn = Token;
848         _pullUnderlying(tokenIn, msg.sender, amt);
849         
850        
851         uint256 finalAmount = amt * 98/100;
852         _totalSupply1 = _totalSupply1 + finalAmount;
853         _balances1[msg.sender] = _balances1[msg.sender] + finalAmount;
854     }
855     
856     function depositWrap(uint256 amt)  external noContract nonReentrant {
857         address tokenIn = Wrap;
858         _pullUnderlying(tokenIn, msg.sender, amt);
859         
860        
861         uint256 finalAmount = amt * 99/100;
862         _totalSupply2  = _totalSupply2 + finalAmount;
863         _balances2[msg.sender] = _balances2[msg.sender] + finalAmount;
864     }
865     
866     function withdrawToken(uint256 amt) external noContract nonReentrant {
867         address tokenIn = Token;
868         require(_balances1[msg.sender] >= amt, "Not enough token");
869         
870         _totalSupply1 = _totalSupply1 - amt;
871         _balances1[msg.sender] = _balances1[msg.sender] - amt;
872         
873         _pushUnderlying(tokenIn, msg.sender, amt);
874         
875     }
876     
877     function withdrawWrap(uint256 amt) external noContract nonReentrant{
878         address tokenIn = Wrap;
879         require(_balances2[msg.sender] >= amt, "Not enough Wrap");
880         
881         _totalSupply2 = _totalSupply2 - amt;
882         _balances2[msg.sender] = _balances2[msg.sender] - amt;
883         
884         _pushUnderlying(tokenIn, msg.sender, amt);
885     }
886 
887     function addBothLiquidity(uint poolAmountOut, uint[] calldata maxAmountsIn)
888     noContract nonReentrant
889         external
890         _logs_
891         _lock_
892     {
893         
894 
895         uint poolTotal = totalSupply();
896         uint ratio = bdiv(poolAmountOut, poolTotal);
897         require(ratio != 0, "ERR_MATH_APPROX");
898 
899         for (uint i = 0; i < _tokens.length; i++) {
900             address t = _tokens[i];
901             uint bal = _records[t].balance;
902             uint tokenAmountIn = bmul(ratio, bal);
903             require(tokenAmountIn != 0, "ERR_MATH_APPROX");
904             require(tokenAmountIn <= maxAmountsIn[i], "ERR_LIMIT_IN");
905             emit LOG_JOIN(msg.sender, t, tokenAmountIn * 98/100, 0);
906             _pullUnderlying(t, msg.sender, tokenAmountIn);
907             _records[Token].balance = IERC20(Token).balanceOf(address(this)) - _totalSupply1;
908             _records[Wrap].balance = IERC20(Wrap).balanceOf(address(this)) - _totalSupply2;
909         }
910         _mintPoolShare(poolAmountOut);
911         _pushPoolShare(msg.sender, poolAmountOut);
912         
913     }
914    
915     function removeBothLiquidity(uint poolAmountIn, uint[] calldata minAmountsOut)
916     noContract nonReentrant
917         external
918         _logs_
919         _lock_
920     {
921         
922         userLock storage ulock = _userlock[msg.sender];
923         
924         if(ulock.setLock == true) {
925             require(ulock.unlockTime <= block.timestamp, "Liquidity is locked, you cannot remove liquidity until after lock time.");
926         }
927 
928         uint poolTotal = totalSupply();
929         uint exitFee = bmul(poolAmountIn, EXIT_FEE);
930         uint pAiAfterExitFee = bsub(poolAmountIn, exitFee);
931         uint ratio = bdiv(pAiAfterExitFee, poolTotal);
932         require(ratio != 0, "ERR_MATH_APPROX");
933 
934         _pullPoolShare(msg.sender, poolAmountIn);
935         _pushPoolShare(_factory, exitFee);
936         _burnPoolShare(pAiAfterExitFee);
937         
938         
939         for (uint i = 0; i < _tokens.length; i++) {
940             address t = _tokens[i];
941             uint bal = _records[t].balance;
942             uint tokenAmountOut = bmul(ratio, bal);
943             require(tokenAmountOut != 0, "ERR_MATH_APPROX");
944             require(tokenAmountOut >= minAmountsOut[i], "ERR_LIMIT_OUT");
945             emit LOG_EXIT(msg.sender, t, tokenAmountOut, 0);
946             _pushUnderlying(t, msg.sender, tokenAmountOut);
947             _records[Token].balance = IERC20(Token).balanceOf(address(this)) - _totalSupply1;
948             _records[Wrap].balance = IERC20(Wrap).balanceOf(address(this)) - _totalSupply2;
949         }
950 
951     }
952 
953 
954     function BUYSmart(
955         uint tokenAmountIn,
956         uint minAmountOut
957     ) noContract nonReentrant
958         external 
959         _logs_
960         _lock_
961         returns (uint tokenAmountOut, uint spotPriceAfter)
962     {
963         
964         address tokenIn = Wrap;
965         address tokenOut = Token;
966         require(_balances2[msg.sender] >= tokenAmountIn, "Not enough Wrap, deposit more");
967         
968         
969         Record storage inRecord = _records[address(tokenIn)];
970         Record storage outRecord = _records[address(tokenOut)];
971 
972         require(tokenAmountIn <= bmul(inRecord.balance, MAX_IN_RATIO), "ERR_MAX_IN_RATIO");
973         uint spotPriceBefore = calcSpotPrice(
974                                     inRecord.balance ,
975                                     BASE * 25,
976                                     outRecord.balance,
977                                     BASE * 25,
978                                     _swapFee * 0
979                                 );
980                                 
981         uint tokenInFee;
982         (tokenAmountOut, tokenInFee) = calcOutGivenIn(
983                                             inRecord.balance,
984                                             BASE * 25,
985                                             outRecord.balance,
986                                             BASE * 25,
987                                             tokenAmountIn * 99/100,
988                                             _swapFee * 0
989                                         );
990                                         
991         require(tokenAmountOut >= minAmountOut, "ERR_LIMIT_OUT");
992         require(spotPriceBefore <= bdiv(tokenAmountIn, tokenAmountOut), "ERR_MATH_APPROX");                     
993         _balances2[msg.sender] = _balances2[msg.sender] - tokenAmountIn;
994         _balances1[msg.sender] = _balances1[msg.sender] + tokenAmountOut;
995         _totalSupply2 = _totalSupply2 - tokenAmountIn;
996         _totalSupply1 = _totalSupply1 + tokenAmountOut;
997         _records[Token].balance = IERC20(Token).balanceOf(address(this)) - _totalSupply1;
998         _records[Wrap].balance = IERC20(Wrap).balanceOf(address(this)) - _totalSupply2;
999         
1000         spotPriceAfter = calcSpotPrice(
1001                                             inRecord.balance,
1002                                             BASE * 25,
1003                                             outRecord.balance,
1004                                             BASE * 25,
1005                                             _swapFee * 0
1006                             );
1007         require(spotPriceAfter >= spotPriceBefore, "ERR_MATH_APPROX");
1008         emit LOG_SWAP(msg.sender, tokenIn, tokenOut, tokenAmountIn, tokenAmountOut);
1009         return (tokenAmountOut, spotPriceAfter);
1010     }
1011     
1012     function BUY(
1013         address to,
1014         uint minAmountOut
1015     ) noContract nonReentrant
1016         external payable
1017         _logs_
1018         _lock_
1019         returns (uint tokenAmountOut, uint spotPriceAfter)
1020     {
1021         
1022         address tokenIn = Wrap;
1023         address tokenOut = Token;
1024         
1025         
1026         Record storage inRecord = _records[address(tokenIn)];
1027         Record storage outRecord = _records[address(tokenOut)];
1028 
1029         require(msg.value <= bmul(inRecord.balance, MAX_IN_RATIO), "ERR_MAX_IN_RATIO");
1030 
1031         uint spotPriceBefore = calcSpotPrice(
1032                                     inRecord.balance ,
1033                                     BASE * 25,
1034                                     outRecord.balance,
1035                                     BASE * 25,
1036                                     _swapFee * 0
1037                                 );
1038 
1039         uint tokenInFee;
1040         (tokenAmountOut, tokenInFee) = calcOutGivenIn(
1041                                             inRecord.balance,
1042                                             BASE * 25,
1043                                             outRecord.balance,
1044                                             BASE * 25,
1045                                             msg.value * 99/100,
1046                                             _swapFee * 0
1047                                         );
1048                                         
1049         require(tokenAmountOut >= minAmountOut, "ERR_LIMIT_OUT");
1050         require(spotPriceBefore <= bdiv(msg.value * 99/100, tokenAmountOut), "ERR_MATH_APPROX");
1051         wrap(Wrap).deposit{value: msg.value}();
1052         _pushUnderlying(tokenOut, to, tokenAmountOut);
1053         _records[Token].balance = IERC20(Token).balanceOf(address(this)) - _totalSupply1;
1054         _records[Wrap].balance = IERC20(Wrap).balanceOf(address(this)) - _totalSupply2;
1055         
1056         spotPriceAfter = calcSpotPrice(
1057                                             inRecord.balance,
1058                                             BASE * 25,
1059                                             outRecord.balance,
1060                                             BASE * 25,
1061                                             _swapFee * 0
1062                             );
1063         require(spotPriceAfter >= spotPriceBefore, "ERR_MATH_APPROX");
1064         
1065         emit LOG_SWAP(msg.sender, tokenIn, tokenOut, msg.value * 99/100, tokenAmountOut * 98/100);
1066         return (tokenAmountOut, spotPriceAfter);
1067     }
1068 
1069     function SELL(
1070     address to,
1071         uint tokenAmountIn,
1072         uint minAmountOut
1073     ) noContract nonReentrant 
1074         external
1075         _logs_
1076         _lock_
1077         returns (uint tokenAmountOut, uint spotPriceAfter)
1078     {
1079         
1080         address tokenIn = Token;
1081         address tokenOut = Wrap;
1082         
1083         Record storage inRecord = _records[address(tokenIn)];
1084         Record storage outRecord = _records[address(tokenOut)];
1085 
1086         require(tokenAmountIn <= bmul(inRecord.balance, MAX_SELL_RATIO), "ERR_SELL_RATIO");
1087                                                
1088         uint tokenInFee;
1089         (tokenAmountOut, tokenInFee) = calcOutGivenIn(
1090                                             inRecord.balance,
1091                                             BASE * 25,
1092                                             outRecord.balance,
1093                                             BASE * 25,
1094                                             tokenAmountIn * 98/100,
1095                                             _swapFee
1096                                         );
1097         require(tokenAmountOut >= minAmountOut, "ERR_LIMIT_OUT");
1098         
1099         emit LOG_SWAP(msg.sender, tokenIn, tokenOut, tokenAmountIn * 98/100, tokenAmountOut * 99/100);
1100 
1101         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1102         uint256 toka = bmul(tokenAmountOut, bdiv(RPF, 1000));
1103         uint256 tokAmountI  = bmul(tokenAmountOut, bdiv(FSS, 10000));
1104         uint256 tokAmountI2 =  bmul(tokenAmountOut, bdiv(PSS, 10000));
1105         uint256 tokAmountI1 = bsub(toka, badd(tokAmountI, tokAmountI2));
1106         uint256 out1 = tokAmountI1;
1107         wrap(Wrap).withdraw(out1); 
1108         TransferHelper.safeTransferETH(to, (out1 * 99/100)); 
1109         _pushUnderlying1(tokenOut, tokAmountI);
1110         _balances2[pairRewardPool] = _balances2[pairRewardPool] + tokAmountI2;
1111         _totalSupply2 = _totalSupply2 + tokAmountI2;
1112         uint spotPriceBefore = calcSpotPrice(
1113                                     inRecord.balance,
1114                                     BASE * 25,
1115                                     outRecord.balance,
1116                                     BASE * 25,
1117                                     _swapFee
1118                                 );
1119         require(spotPriceBefore <= bdiv(tokenAmountIn, tokenAmountOut), "ERR_MATH_APPROX");                        
1120         _records[Token].balance = IERC20(Token).balanceOf(address(this)) - _totalSupply1;
1121         _records[Wrap].balance = IERC20(Wrap).balanceOf(address(this)) - _totalSupply2;
1122         
1123         spotPriceAfter = calcSpotPrice(
1124                                             inRecord.balance,
1125                                             BASE * 25,
1126                                             outRecord.balance,
1127                                             BASE * 25,
1128                                             _swapFee
1129                             );
1130         require(spotPriceAfter >= spotPriceBefore, "ERR_MATH_APPROX");
1131         
1132         
1133         return (tokenAmountOut, spotPriceAfter);
1134     }
1135     
1136      function SELLSmart(
1137         uint tokenAmountIn,
1138         uint minAmountOut
1139     ) noContract nonReentrant
1140         external
1141         _logs_
1142         _lock_
1143         returns (uint tokenAmountOut, uint spotPriceAfter)
1144     {
1145         
1146         address tokenIn = Token;
1147         address tokenOut = Wrap;
1148         
1149         require(_balances1[msg.sender] >= tokenAmountIn, "Not enough Token");
1150         
1151         Record storage inRecord = _records[address(tokenIn)];
1152         Record storage outRecord = _records[address(tokenOut)];
1153 
1154         require(tokenAmountIn <= bmul(inRecord.balance, MAX_SELL_RATIO), "ERR_SELL_RATIO");
1155 
1156         uint spotPriceBefore = calcSpotPrice(
1157                                     inRecord.balance,
1158                                     BASE * 25,
1159                                     outRecord.balance,
1160                                     BASE * 25,
1161                                     _swapFee
1162                                 );
1163 
1164         uint tokenInFee;
1165         (tokenAmountOut, tokenInFee) = calcOutGivenIn(
1166                                             inRecord.balance,
1167                                             BASE * 25,
1168                                             outRecord.balance,
1169                                             BASE * 25,
1170                                             tokenAmountIn * 98/100,
1171                                             _swapFee
1172                                         );
1173         require(tokenAmountOut >= minAmountOut, "ERR_LIMIT_OUT");
1174         require(spotPriceBefore <= bdiv(tokenAmountIn, tokenAmountOut), "ERR_MATH_APPROX");
1175 
1176         emit LOG_SWAP(msg.sender, tokenIn, tokenOut, tokenAmountIn, tokenAmountOut);
1177         uint256 toka = bmul(tokenAmountOut, bdiv(RPF, 1000));
1178         uint256 tokAmountI  = bmul(tokenAmountOut, bdiv(FSS, 10000));
1179         uint256 tokAmountI2 =  bmul(tokenAmountOut, bdiv(PSS, 10000));
1180         uint256 tokAmountI1 = bsub(toka, badd(tokAmountI, tokAmountI2));
1181         uint256 tok2 = badd(tokAmountI1, tokAmountI2);
1182         _balances1[msg.sender] = _balances1[msg.sender] - tokenAmountIn;
1183         _balances2[msg.sender] = _balances2[msg.sender] + tokAmountI1;
1184         _totalSupply2 = _totalSupply2 + tok2;
1185         _totalSupply1 = _totalSupply1 - tokenAmountIn;
1186         _pushUnderlying1(tokenOut, tokAmountI);
1187         _balances2[pairRewardPool] = _balances2[pairRewardPool] + tokAmountI2;
1188         _records[Token].balance = IERC20(Token).balanceOf(address(this)) - _totalSupply1;
1189         _records[Wrap].balance = IERC20(Wrap).balanceOf(address(this)) - _totalSupply2;
1190                           
1191         spotPriceAfter = calcSpotPrice(
1192                                             inRecord.balance,
1193                                             BASE * 25,
1194                                             outRecord.balance,
1195                                             BASE * 25,
1196                                             _swapFee
1197                             );
1198         require(spotPriceAfter >= spotPriceBefore, "ERR_MATH_APPROX");
1199         
1200         return (tokenAmountOut, spotPriceAfter);
1201     }
1202     
1203     function setFSS(uint _FSS ) external {
1204         require(msg.sender == _controller);
1205         require(_FSS <= 100, " Cannot set over 1%");
1206         require(_FSS > 0, " Cannot set to 0");
1207         FSS = _FSS;
1208     }
1209     
1210     function setPSS(uint _PSS ) external {
1211         require(msg.sender == _poolOwner);
1212          require(_PSS <= 100, " Cannot set over 1%"); 
1213          require(_PSS > 0, " Cannot set to 0");
1214         PSS = _PSS;
1215     }
1216 
1217     function setRPF(uint _RPF ) external {
1218         require(msg.sender == _poolOwner);
1219          require(_RPF <= 200, " Cannot set over 20%"); 
1220          require(_RPF > 0, " Cannot set to 0");
1221         RPF = _RPF;
1222     }
1223     
1224     function setSHR(uint _SHR, uint _SHR1 ) external {
1225         require(msg.sender == _controller);
1226          require(_SHR <= 100 && _SHR1 <=100, " Cannot set over 10%"); 
1227          require(_SHR > 0 && _SHR1 > 0, " Cannot set to 0"); 
1228         SHR = _SHR;
1229         SHR1 = _SHR1;
1230     }
1231     
1232     function setLockLiquidity() external { //
1233         address user = msg.sender;
1234         userLock storage ulock = _userlock[user];
1235         userLock storage time = _unlockTime[user];
1236         ulock.setLock = true;
1237         time.unlockTime = block.timestamp + 365 days ; 
1238         }
1239     
1240     function releaseLiquidity() external { // Allows removal of liquidity after the lock period is over
1241         address user = msg.sender;
1242         userLock storage ulock = _userlock[user];
1243         userLock storage time = _unlockTime[user];
1244         require (block.timestamp >= time.unlockTime, "Liquidity is locked, you cannot remove liquidity until after lock time.");
1245         ulock.setLock = false; 
1246     }
1247     
1248     function emergencyLockOverride(address user, bool _bool, uint _time) external {
1249         require(msg.sender == _controller);
1250         userLock storage ulock = _userlock[user];
1251         userLock storage time = _unlockTime[user];
1252         ulock.setLock = _bool;
1253         time.unlockTime = _time;
1254     }
1255 
1256     function _pullUnderlying(address erc20, address from, uint amount)
1257         internal
1258     {   
1259         //require(amount > 0, "Cannot deposit nothing");
1260         bool xfer = IERC20(erc20).transferFrom(from, address(this), amount);
1261         require(xfer, "ERR_ERC20_FALSE");
1262         
1263     }
1264 
1265     function _pushUnderlying(address erc20, address to, uint amount)
1266         internal
1267     {   
1268         //require(amount > 0, "Cannot withdraw nothing");
1269         bool xfer = IERC20(erc20).transfer(to, amount);
1270         require(xfer, "ERR_ERC20_FALSE");
1271     }
1272     
1273     function _pushUnderlying1(address erc20, uint amount)
1274         internal
1275     {
1276         bool xfer = IERC20(erc20).transfer(FEGstake, amount);
1277         require(xfer, "ERR_ERC20_FALSE");
1278     }
1279 
1280     function _pullPoolShare(address from, uint amount)
1281         internal
1282     {
1283         _pull(from, amount);
1284     }
1285 
1286     function _pushPoolShare(address to, uint amount)
1287         internal
1288     {
1289         _push(to, amount);
1290     }
1291 
1292     function _mintPoolShare(uint amount)
1293         internal
1294     {
1295         _mint(amount);
1296     }
1297 
1298     function _burnPoolShare(uint amount)
1299         internal
1300     {
1301         _burn(amount);
1302     }
1303 
1304     function PayWrap(address payee, uint amount)
1305         external noContract nonReentrant 
1306         
1307     {   
1308         require(_balances2[msg.sender] >= amount, "Not enough token");
1309         uint256 amt = amount * SHR1/1000;
1310         uint256 amt1 = amount - amt;
1311         _balances2[msg.sender] = _balances2[msg.sender] - amount;
1312         _balances2[payee] = _balances2[payee] + amt;
1313         _balances2[_factory] = _balances2[_factory] + amt1;
1314     }
1315     
1316     function PayToken(address payee, uint amount)
1317         external noContract nonReentrant 
1318         
1319     {
1320         require(_balances1[msg.sender] >= amount, "Not enough token");
1321         uint256 amt = amount * SHR/1000;
1322         uint256 amt1 = amount - amt;
1323         _balances1[msg.sender] = _balances1[msg.sender] - amount;
1324         _balances1[payee] = _balances1[payee] + amt;
1325         _pushUnderlying(Token, burn, amt1);
1326         _totalSupply1 = _totalSupply1 - amt1;
1327     }
1328 }