1 // File: contracts/XVersion.sol
2 
3 pragma solidity 0.5.17;
4 
5 contract XVersion {
6     function getVersion() external view returns (bytes32);
7 }
8 
9 contract XApollo is XVersion {
10     function getVersion() external view returns (bytes32) {
11         return bytes32("APOLLO");
12     }
13 }
14 
15 // File: contracts/XConst.sol
16 
17 pragma solidity 0.5.17;
18 
19 contract XConst {
20     uint256 public constant BONE = 10**18;
21 
22     uint256 public constant MIN_BOUND_TOKENS = 2;
23     uint256 public constant MAX_BOUND_TOKENS = 8;
24 
25     uint256 public constant EXIT_ZERO_FEE = 0;
26 
27     uint256 public constant MIN_WEIGHT = BONE;
28     uint256 public constant MAX_WEIGHT = BONE * 50;
29     uint256 public constant MAX_TOTAL_WEIGHT = BONE * 50;
30 
31     // min effective value: 0.000001 TOKEN
32     uint256 public constant MIN_BALANCE = 10**6;
33 
34     // BONE/(10**10) XPT
35     uint256 public constant MIN_POOL_AMOUNT = 10**8;
36 
37     uint256 public constant INIT_POOL_SUPPLY = BONE * 100;
38 
39     uint256 public constant MAX_IN_RATIO = BONE / 2;
40     uint256 public constant MAX_OUT_RATIO = (BONE / 3) + 1 wei;
41 }
42 
43 // File: contracts/lib/XNum.sol
44 
45 pragma solidity 0.5.17;
46 
47 library XNum {
48     uint256 public constant BONE = 10**18;
49     uint256 public constant MIN_BPOW_BASE = 1 wei;
50     uint256 public constant MAX_BPOW_BASE = (2 * BONE) - 1 wei;
51     uint256 public constant BPOW_PRECISION = BONE / 10**10;
52 
53     function btoi(uint256 a) internal pure returns (uint256) {
54         return a / BONE;
55     }
56 
57     function bfloor(uint256 a) internal pure returns (uint256) {
58         return btoi(a) * BONE;
59     }
60 
61     function badd(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "ERR_ADD_OVERFLOW");
64         return c;
65     }
66 
67     function bsub(uint256 a, uint256 b) internal pure returns (uint256) {
68         (uint256 c, bool flag) = bsubSign(a, b);
69         require(!flag, "ERR_SUB_UNDERFLOW");
70         return c;
71     }
72 
73     function bsubSign(uint256 a, uint256 b)
74         internal
75         pure
76         returns (uint256, bool)
77     {
78         if (a >= b) {
79             return (a - b, false);
80         } else {
81             return (b - a, true);
82         }
83     }
84 
85     function bmul(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c0 = a * b;
87         require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
88         uint256 c1 = c0 + (BONE / 2);
89         require(c1 >= c0, "ERR_MUL_OVERFLOW");
90         uint256 c2 = c1 / BONE;
91         return c2;
92     }
93 
94     function bdiv(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b != 0, "ERR_DIV_ZERO");
96         uint256 c0 = a * BONE;
97         require(a == 0 || c0 / a == BONE, "ERR_DIV_INTERNAL"); // bmul overflow
98         uint256 c1 = c0 + (b / 2);
99         require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
100         uint256 c2 = c1 / b;
101         return c2;
102     }
103 
104     // DSMath.wpow
105     function bpowi(uint256 a, uint256 n) internal pure returns (uint256) {
106         uint256 z = n % 2 != 0 ? a : BONE;
107 
108         for (n /= 2; n != 0; n /= 2) {
109             a = bmul(a, a);
110 
111             if (n % 2 != 0) {
112                 z = bmul(z, a);
113             }
114         }
115         return z;
116     }
117 
118     // Compute b^(e.w) by splitting it into (b^e)*(b^0.w).
119     // Use `bpowi` for `b^e` and `bpowK` for k iterations
120     // of approximation of b^0.w
121     function bpow(uint256 base, uint256 exp) internal pure returns (uint256) {
122         require(base >= MIN_BPOW_BASE, "ERR_BPOW_BASE_TOO_LOW");
123         require(base <= MAX_BPOW_BASE, "ERR_BPOW_BASE_TOO_HIGH");
124 
125         uint256 whole = bfloor(exp);
126         uint256 remain = bsub(exp, whole);
127 
128         uint256 wholePow = bpowi(base, btoi(whole));
129 
130         if (remain == 0) {
131             return wholePow;
132         }
133 
134         uint256 partialResult = bpowApprox(base, remain, BPOW_PRECISION);
135         return bmul(wholePow, partialResult);
136     }
137 
138     function bpowApprox(
139         uint256 base,
140         uint256 exp,
141         uint256 precision
142     ) internal pure returns (uint256) {
143         // term 0:
144         uint256 a = exp;
145         (uint256 x, bool xneg) = bsubSign(base, BONE);
146         uint256 term = BONE;
147         uint256 sum = term;
148         bool negative = false;
149 
150         // term(k) = numer / denom
151         //         = (product(a - i + 1, i=1-->k) * x^k) / (k!)
152         // each iteration, multiply previous term by (a-(k-1)) * x / k
153         // continue until term is less than precision
154         for (uint256 i = 1; term >= precision; i++) {
155             uint256 bigK = i * BONE;
156             (uint256 c, bool cneg) = bsubSign(a, bsub(bigK, BONE));
157             term = bmul(term, bmul(c, x));
158             term = bdiv(term, bigK);
159             if (term == 0) break;
160 
161             if (xneg) negative = !negative;
162             if (cneg) negative = !negative;
163             if (negative) {
164                 sum = bsub(sum, term);
165             } else {
166                 sum = badd(sum, term);
167             }
168         }
169 
170         return sum;
171     }
172 }
173 
174 // File: contracts/interface/IERC20.sol
175 
176 pragma solidity 0.5.17;
177 
178 interface IERC20 {
179     function name() external view returns (string memory);
180 
181     function symbol() external view returns (string memory);
182 
183     function decimals() external view returns (uint8);
184 
185     function totalSupply() external view returns (uint256);
186 
187     function balanceOf(address _owner) external view returns (uint256 balance);
188 
189     function transfer(address _to, uint256 _value)
190         external
191         returns (bool success);
192 
193     function transferFrom(
194         address _from,
195         address _to,
196         uint256 _value
197     ) external returns (bool success);
198 
199     function approve(address _spender, uint256 _value)
200         external
201         returns (bool success);
202 
203     function allowance(address _owner, address _spender)
204         external
205         view
206         returns (uint256 remaining);
207 }
208 
209 // File: contracts/XPToken.sol
210 
211 pragma solidity 0.5.17;
212 
213 
214 
215 
216 // Highly opinionated token implementation
217 contract XTokenBase {
218     using XNum for uint256;
219 
220     mapping(address => uint256) internal _balance;
221     mapping(address => mapping(address => uint256)) internal _allowance;
222     uint256 internal _totalSupply;
223 
224     event Approval(address indexed src, address indexed dst, uint256 amt);
225     event Transfer(address indexed src, address indexed dst, uint256 amt);
226 
227     function _mint(uint256 amt) internal {
228         _balance[address(this)] = (_balance[address(this)]).badd(amt);
229         _totalSupply = _totalSupply.badd(amt);
230         emit Transfer(address(0), address(this), amt);
231     }
232 
233     function _burn(uint256 amt) internal {
234         require(_balance[address(this)] >= amt, "ERR_INSUFFICIENT_BAL");
235         _balance[address(this)] = (_balance[address(this)]).bsub(amt);
236         _totalSupply = _totalSupply.bsub(amt);
237         emit Transfer(address(this), address(0), amt);
238     }
239 
240     function _move(
241         address src,
242         address dst,
243         uint256 amt
244     ) internal {
245         require(_balance[src] >= amt, "ERR_INSUFFICIENT_BAL");
246         _balance[src] = (_balance[src]).bsub(amt);
247         _balance[dst] = (_balance[dst]).badd(amt);
248         emit Transfer(src, dst, amt);
249     }
250 }
251 
252 contract XPToken is XTokenBase, IERC20, XApollo {
253     using XNum for uint256;
254 
255     string private constant _name = "XDeFi Pool Token";
256     string private constant _symbol = "XPT";
257     uint8 private constant _decimals = 18;
258 
259     function name() external view returns (string memory) {
260         return _name;
261     }
262 
263     function symbol() external view returns (string memory) {
264         return _symbol;
265     }
266 
267     function decimals() external view returns (uint8) {
268         return _decimals;
269     }
270 
271     function allowance(address src, address dst)
272         external
273         view
274         returns (uint256)
275     {
276         return _allowance[src][dst];
277     }
278 
279     function balanceOf(address whom) external view returns (uint256) {
280         return _balance[whom];
281     }
282 
283     function totalSupply() public view returns (uint256) {
284         return _totalSupply;
285     }
286 
287     function approve(address dst, uint256 amt) external returns (bool) {
288         _allowance[msg.sender][dst] = amt;
289         emit Approval(msg.sender, dst, amt);
290         return true;
291     }
292 
293     function transfer(address dst, uint256 amt) external returns (bool) {
294         _move(msg.sender, dst, amt);
295         return true;
296     }
297 
298     function transferFrom(
299         address src,
300         address dst,
301         uint256 amt
302     ) external returns (bool) {
303         require(
304             msg.sender == src || amt <= _allowance[src][msg.sender],
305             "ERR_BTOKEN_BAD_CALLER"
306         );
307         _move(src, dst, amt);
308         if (msg.sender != src && _allowance[src][msg.sender] != uint256(-1)) {
309             _allowance[src][msg.sender] = (_allowance[src][msg.sender]).bsub(
310                 amt
311             );
312             emit Approval(msg.sender, dst, _allowance[src][msg.sender]);
313         }
314         return true;
315     }
316 }
317 
318 // File: contracts/lib/XMath.sol
319 
320 // This program is free software: you can redistribute it and/or modify
321 // it under the terms of the GNU General Public License as published by
322 // the Free Software Foundation, either version 3 of the License, or
323 // (at your option) any later version.
324 
325 // This program is distributed in the hope that it will be useful,
326 // but WITHOUT ANY WARRANTY; without even the implied warranty of
327 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
328 // GNU General Public License for more details.
329 
330 // You should have received a copy of the GNU General Public License
331 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
332 
333 pragma solidity 0.5.17;
334 
335 
336 library XMath {
337     using XNum for uint256;
338 
339     uint256 public constant BONE = 10**18;
340     uint256 public constant EXIT_ZERO_FEE = 0;
341 
342     /**********************************************************************************************
343     // calcSpotPrice                                                                             //
344     // sP = spotPrice                                                                            //
345     // bI = tokenBalanceIn                ( bI / wI )         1                                  //
346     // bO = tokenBalanceOut         sP =  -----------  *  ----------                             //
347     // wI = tokenWeightIn                 ( bO / wO )     ( 1 - sF )                             //
348     // wO = tokenWeightOut                                                                       //
349     // sF = swapFee                                                                              //
350     **********************************************************************************************/
351     function calcSpotPrice(
352         uint256 tokenBalanceIn,
353         uint256 tokenWeightIn,
354         uint256 tokenBalanceOut,
355         uint256 tokenWeightOut,
356         uint256 swapFee
357     ) public pure returns (uint256 spotPrice) {
358         uint256 numer = tokenBalanceIn.bdiv(tokenWeightIn);
359         uint256 denom = tokenBalanceOut.bdiv(tokenWeightOut);
360         uint256 ratio = numer.bdiv(denom);
361         uint256 scale = BONE.bdiv(BONE.bsub(swapFee));
362         return (spotPrice = ratio.bmul(scale));
363     }
364 
365     /**********************************************************************************************
366     // calcOutGivenIn                                                                            //
367     // aO = tokenAmountOut                                                                       //
368     // bO = tokenBalanceOut                                                                      //
369     // bI = tokenBalanceIn              /      /            bI             \    (wI / wO) \      //
370     // aI = tokenAmountIn    aO = bO * |  1 - | --------------------------  | ^            |     //
371     // wI = tokenWeightIn               \      \ ( bI + ( aI * ( 1 - sF )) /              /      //
372     // wO = tokenWeightOut                                                                       //
373     // sF = swapFee                                                                              //
374     **********************************************************************************************/
375     function calcOutGivenIn(
376         uint256 tokenBalanceIn,
377         uint256 tokenWeightIn,
378         uint256 tokenBalanceOut,
379         uint256 tokenWeightOut,
380         uint256 tokenAmountIn,
381         uint256 swapFee
382     ) public pure returns (uint256 tokenAmountOut) {
383         uint256 weightRatio;
384         if (tokenWeightIn == tokenWeightOut) {
385             weightRatio = 1 * BONE;
386         } else if (tokenWeightIn >> 1 == tokenWeightOut) {
387             weightRatio = 2 * BONE;
388         } else {
389             weightRatio = tokenWeightIn.bdiv(tokenWeightOut);
390         }
391         uint256 adjustedIn = BONE.bsub(swapFee);
392         adjustedIn = tokenAmountIn.bmul(adjustedIn);
393         uint256 y = tokenBalanceIn.bdiv(tokenBalanceIn.badd(adjustedIn));
394         uint256 foo;
395         if (tokenWeightIn == tokenWeightOut) {
396             foo = y;
397         } else if (tokenWeightIn >> 1 == tokenWeightOut) {
398             foo = y.bmul(y);
399         } else {
400             foo = y.bpow(weightRatio);
401         }
402         uint256 bar = BONE.bsub(foo);
403         tokenAmountOut = tokenBalanceOut.bmul(bar);
404         return tokenAmountOut;
405     }
406 
407     /**********************************************************************************************
408     // calcInGivenOut                                                                            //
409     // aI = tokenAmountIn                                                                        //
410     // bO = tokenBalanceOut               /  /     bO      \    (wO / wI)      \                 //
411     // bI = tokenBalanceIn          bI * |  | ------------  | ^            - 1  |                //
412     // aO = tokenAmountOut    aI =        \  \ ( bO - aO ) /                   /                 //
413     // wI = tokenWeightIn           --------------------------------------------                 //
414     // wO = tokenWeightOut                          ( 1 - sF )                                   //
415     // sF = swapFee                                                                              //
416     **********************************************************************************************/
417     function calcInGivenOut(
418         uint256 tokenBalanceIn,
419         uint256 tokenWeightIn,
420         uint256 tokenBalanceOut,
421         uint256 tokenWeightOut,
422         uint256 tokenAmountOut,
423         uint256 swapFee
424     ) public pure returns (uint256 tokenAmountIn) {
425         uint256 weightRatio;
426         if (tokenWeightOut == tokenWeightIn) {
427             weightRatio = 1 * BONE;
428         } else if (tokenWeightOut >> 1 == tokenWeightIn) {
429             weightRatio = 2 * BONE;
430         } else {
431             weightRatio = tokenWeightOut.bdiv(tokenWeightIn);
432         }
433         uint256 diff = tokenBalanceOut.bsub(tokenAmountOut);
434         uint256 y = tokenBalanceOut.bdiv(diff);
435         uint256 foo;
436         if (tokenWeightOut == tokenWeightIn) {
437             foo = y;
438         } else if (tokenWeightOut >> 1 == tokenWeightIn) {
439             foo = y.bmul(y);
440         } else {
441             foo = y.bpow(weightRatio);
442         }
443         foo = foo.bsub(BONE);
444         tokenAmountIn = BONE.bsub(swapFee);
445         tokenAmountIn = tokenBalanceIn.bmul(foo).bdiv(tokenAmountIn);
446         return tokenAmountIn;
447     }
448 
449     /**********************************************************************************************
450     // calcPoolOutGivenSingleIn                                                                  //
451     // pAo = poolAmountOut         /                                              \              //
452     // tAi = tokenAmountIn        ///      /     //    wI \      \\       \     wI \             //
453     // wI = tokenWeightIn        //| tAi *| 1 - || 1 - --  | * sF || + tBi \    --  \            //
454     // tW = totalWeight     pAo=||  \      \     \\    tW /      //         | ^ tW   | * pS - pS //
455     // tBi = tokenBalanceIn      \\  ------------------------------------- /        /            //
456     // pS = poolSupply            \\                    tBi               /        /             //
457     // sF = swapFee                \                                              /              //
458     **********************************************************************************************/
459     function calcPoolOutGivenSingleIn(
460         uint256 tokenBalanceIn,
461         uint256 tokenWeightIn,
462         uint256 poolSupply,
463         uint256 totalWeight,
464         uint256 tokenAmountIn,
465         uint256 swapFee
466     ) public pure returns (uint256 poolAmountOut) {
467         // Charge the trading fee for the proportion of tokenAi
468         ///  which is implicitly traded to the other pool tokens.
469         // That proportion is (1- weightTokenIn)
470         // tokenAiAfterFee = tAi * (1 - (1-weightTi) * poolFee);
471         uint256 normalizedWeight = tokenWeightIn.bdiv(totalWeight);
472         uint256 zaz = BONE.bsub(normalizedWeight).bmul(swapFee);
473         uint256 tokenAmountInAfterFee = tokenAmountIn.bmul(BONE.bsub(zaz));
474 
475         uint256 newTokenBalanceIn = tokenBalanceIn.badd(tokenAmountInAfterFee);
476         uint256 tokenInRatio = newTokenBalanceIn.bdiv(tokenBalanceIn);
477 
478         // uint newPoolSupply = (ratioTi ^ weightTi) * poolSupply;
479         uint256 poolRatio = tokenInRatio.bpow(normalizedWeight);
480         uint256 newPoolSupply = poolRatio.bmul(poolSupply);
481         poolAmountOut = newPoolSupply.bsub(poolSupply);
482         return poolAmountOut;
483     }
484 
485     /**********************************************************************************************
486     // calcSingleOutGivenPoolIn                                                                  //
487     // tAo = tokenAmountOut            /      /                                             \\   //
488     // bO = tokenBalanceOut           /      // pS - (pAi * (1 - eF)) \     /    1    \      \\  //
489     // pAi = poolAmountIn            | bO - || ----------------------- | ^ | --------- | * b0 || //
490     // ps = poolSupply                \      \\          pS           /     \(wO / tW)/      //  //
491     // wI = tokenWeightIn      tAo =   \      \                                             //   //
492     // tW = totalWeight                    /     /      wO \       \                             //
493     // sF = swapFee                    *  | 1 - |  1 - ---- | * sF  |                            //
494     // eF = exitFee                        \     \      tW /       /                             //
495     **********************************************************************************************/
496     function calcSingleOutGivenPoolIn(
497         uint256 tokenBalanceOut,
498         uint256 tokenWeightOut,
499         uint256 poolSupply,
500         uint256 totalWeight,
501         uint256 poolAmountIn,
502         uint256 swapFee
503     ) public pure returns (uint256 tokenAmountOut) {
504         uint256 normalizedWeight = tokenWeightOut.bdiv(totalWeight);
505         // charge exit fee on the pool token side
506         // pAiAfterExitFee = pAi*(1-exitFee)
507         uint256 poolAmountInAfterExitFee =
508             poolAmountIn.bmul(BONE.bsub(EXIT_ZERO_FEE));
509         uint256 newPoolSupply = poolSupply.bsub(poolAmountInAfterExitFee);
510         uint256 poolRatio = newPoolSupply.bdiv(poolSupply);
511 
512         // newBalTo = poolRatio^(1/weightTo) * balTo;
513         uint256 tokenOutRatio = poolRatio.bpow(BONE.bdiv(normalizedWeight));
514         uint256 newTokenBalanceOut = tokenOutRatio.bmul(tokenBalanceOut);
515 
516         uint256 tokenAmountOutBeforeSwapFee =
517             tokenBalanceOut.bsub(newTokenBalanceOut);
518 
519         // charge swap fee on the output token side
520         //uint tAo = tAoBeforeSwapFee * (1 - (1-weightTo) * swapFee)
521         uint256 zaz = BONE.bsub(normalizedWeight).bmul(swapFee);
522         tokenAmountOut = tokenAmountOutBeforeSwapFee.bmul(BONE.bsub(zaz));
523         return tokenAmountOut;
524     }
525 }
526 
527 // File: contracts/interface/IXConfig.sol
528 
529 pragma solidity 0.5.17;
530 
531 interface IXConfig {
532     function getCore() external view returns (address);
533 
534     function getSAFU() external view returns (address);
535 
536     function getMaxExitFee() external view returns (uint256);
537 
538     function getSafuFee() external view returns (uint256);
539 
540     function getSwapProxy() external view returns (address);
541 
542     function dedupPool(address[] calldata tokens, uint256[] calldata denorms)
543         external
544         returns (bool exist, bytes32 sig);
545 
546     function addPoolSig(bytes32 sig, address pool) external;
547 }
548 
549 // File: contracts/XPool.sol
550 
551 pragma solidity 0.5.17;
552 
553 
554 
555 
556 
557 
558 
559 contract XPool is XApollo, XPToken, XConst {
560     using XNum for uint256;
561 
562     //Swap Fees: 0.1%, 0.25%, 1%, 2.5%, 10%
563     uint256[5] public SWAP_FEES = [
564         BONE / 1000,
565         (25 * BONE) / 10000,
566         BONE / 100,
567         (25 * BONE) / 1000,
568         BONE / 10
569     ];
570 
571     struct Record {
572         bool bound; // is token bound to pool
573         uint256 index; // private
574         uint256 denorm; // denormalized weight
575         uint256 balance;
576     }
577 
578     event LOG_SWAP(
579         address indexed caller,
580         address indexed tokenIn,
581         address indexed tokenOut,
582         uint256 tokenAmountIn,
583         uint256 tokenAmountOut
584     );
585 
586     event LOG_REFER(
587         address indexed caller,
588         address indexed ref,
589         address indexed tokenIn,
590         uint256 fee
591     );
592 
593     event LOG_JOIN(
594         address indexed caller,
595         address indexed tokenIn,
596         uint256 tokenAmountIn
597     );
598 
599     event LOG_EXIT(
600         address indexed caller,
601         address indexed tokenOut,
602         uint256 tokenAmountOut
603     );
604 
605     event LOG_BIND(
606         address indexed caller,
607         address indexed token,
608         uint256 denorm,
609         uint256 balance
610     );
611 
612     event LOG_UPDATE_SAFU(address indexed safu, uint256 fee);
613 
614     event LOG_EXIT_FEE(uint256 fee);
615 
616     event LOG_FINAL(uint256 swapFee);
617 
618     event SET_CONTROLLER(address indexed manager);
619 
620     event UPDATE_FARM(address indexed caller, bool isFarm);
621 
622     // anonymous event
623     event LOG_CALL(
624         bytes4 indexed sig,
625         address indexed caller,
626         bytes data
627     ) anonymous;
628 
629     modifier _logs_() {
630         emit LOG_CALL(msg.sig, msg.sender, msg.data);
631         _;
632     }
633 
634     modifier _lock_() {
635         require(!_mutex, "ERR_REENTRY");
636         _mutex = true;
637         _;
638         _mutex = false;
639     }
640 
641     modifier _viewlock_() {
642         require(!_mutex, "ERR_REENTRY");
643         _;
644     }
645 
646     bool private _mutex;
647 
648     address public controller; // has CONTROL role
649 
650     // `finalize` require CONTROL, `finalize` sets `can SWAP and can JOIN`
651     bool public finalized;
652 
653     uint256 public swapFee;
654     uint256 public exitFee;
655 
656     // Pool Governance
657     address public SAFU;
658     uint256 public safuFee;
659     bool public isFarmPool;
660 
661     address[] internal _tokens;
662     mapping(address => Record) internal _records;
663     uint256 private _totalWeight;
664 
665     IXConfig public xconfig;
666     address public origin;
667 
668     constructor(address _xconfig, address _controller) public {
669         controller = _controller;
670         origin = tx.origin;
671         swapFee = SWAP_FEES[1];
672         exitFee = EXIT_ZERO_FEE;
673         finalized = false;
674         xconfig = IXConfig(_xconfig);
675         SAFU = xconfig.getSAFU();
676         safuFee = xconfig.getSafuFee();
677     }
678 
679     function isBound(address t) external view returns (bool) {
680         return _records[t].bound;
681     }
682 
683     function getNumTokens() external view returns (uint256) {
684         return _tokens.length;
685     }
686 
687     function getFinalTokens()
688         external
689         view
690         _viewlock_
691         returns (address[] memory tokens)
692     {
693         require(finalized, "ERR_NOT_FINALIZED");
694         return _tokens;
695     }
696 
697     function getDenormalizedWeight(address token)
698         external
699         view
700         _viewlock_
701         returns (uint256)
702     {
703         require(_records[token].bound, "ERR_NOT_BOUND");
704         return _records[token].denorm;
705     }
706 
707     function getTotalDenormalizedWeight()
708         external
709         view
710         _viewlock_
711         returns (uint256)
712     {
713         return _totalWeight;
714     }
715 
716     function getNormalizedWeight(address token)
717         external
718         view
719         _viewlock_
720         returns (uint256)
721     {
722         require(_records[token].bound, "ERR_NOT_BOUND");
723         uint256 denorm = _records[token].denorm;
724         return denorm.bdiv(_totalWeight);
725     }
726 
727     function getBalance(address token)
728         external
729         view
730         _viewlock_
731         returns (uint256)
732     {
733         require(_records[token].bound, "ERR_NOT_BOUND");
734         return _records[token].balance;
735     }
736 
737     function setController(address manager) external _logs_ {
738         require(msg.sender == controller, "ERR_NOT_CONTROLLER");
739         require(manager != address(0), "ERR_ZERO_ADDR");
740         controller = manager;
741         emit SET_CONTROLLER(manager);
742     }
743 
744     function setExitFee(uint256 fee) external {
745         require(!finalized, "ERR_IS_FINALIZED");
746         require(msg.sender == controller, "ERR_NOT_CONTROLLER");
747         require(fee <= xconfig.getMaxExitFee(), "INVALID_EXIT_FEE");
748         exitFee = fee;
749         emit LOG_EXIT_FEE(fee);
750     }
751 
752     // allow SAFU address and SAFE FEE be updated by xconfig
753     function updateSafu(address safu, uint256 fee) external {
754         require(msg.sender == address(xconfig), "ERR_NOT_CONFIG");
755         require(safu != address(0), "ERR_ZERO_ADDR");
756         SAFU = safu;
757         safuFee = fee;
758 
759         emit LOG_UPDATE_SAFU(safu, fee);
760     }
761 
762     // allow isFarmPool be updated by xconfig
763     function updateFarm(bool isFarm) external {
764         require(msg.sender == address(xconfig), "ERR_NOT_CONFIG");
765         isFarmPool = isFarm;
766         emit UPDATE_FARM(msg.sender, isFarm);
767     }
768 
769     function bind(address token, uint256 denorm) external _lock_ {
770         require(msg.sender == controller, "ERR_NOT_CONTROLLER");
771         require(!_records[token].bound, "ERR_IS_BOUND");
772         require(!finalized, "ERR_IS_FINALIZED");
773 
774         require(_tokens.length < MAX_BOUND_TOKENS, "ERR_MAX_TOKENS");
775 
776         require(denorm >= MIN_WEIGHT, "ERR_MIN_WEIGHT");
777         require(denorm <= MAX_WEIGHT, "ERR_MAX_WEIGHT");
778 
779         uint256 balance = IERC20(token).balanceOf(address(this));
780 
781         uint256 decimal = 10**uint256(IERC20(token).decimals());
782         require(decimal >= 10**6, "ERR_TOO_SMALL");
783 
784         // 0.000001 TOKEN
785         require(balance >= decimal / MIN_BALANCE, "ERR_MIN_BALANCE");
786 
787         _totalWeight = _totalWeight.badd(denorm);
788         require(_totalWeight <= MAX_TOTAL_WEIGHT, "ERR_MAX_TOTAL_WEIGHT");
789 
790         _records[token] = Record({
791             bound: true,
792             index: _tokens.length,
793             denorm: denorm,
794             balance: balance
795         });
796         _tokens.push(token);
797 
798         emit LOG_BIND(msg.sender, token, denorm, balance);
799     }
800 
801     // _swapFee must be one of SWAP_FEES
802     function finalize(uint256 _swapFee) external _lock_ {
803         require(msg.sender == controller, "ERR_NOT_CONTROLLER");
804         require(!finalized, "ERR_IS_FINALIZED");
805         require(_tokens.length >= MIN_BOUND_TOKENS, "ERR_MIN_TOKENS");
806         require(_tokens.length <= MAX_BOUND_TOKENS, "ERR_MAX_TOKENS");
807 
808         require(_swapFee >= SWAP_FEES[0], "ERR_MIN_FEE");
809         require(_swapFee <= SWAP_FEES[SWAP_FEES.length - 1], "ERR_MAX_FEE");
810 
811         bool found = false;
812         for (uint256 i = 0; i < SWAP_FEES.length; i++) {
813             if (_swapFee == SWAP_FEES[i]) {
814                 found = true;
815                 break;
816             }
817         }
818         require(found, "ERR_INVALID_SWAP_FEE");
819         swapFee = _swapFee;
820 
821         finalized = true;
822 
823         _mintPoolShare(INIT_POOL_SUPPLY);
824         _pushPoolShare(msg.sender, INIT_POOL_SUPPLY);
825 
826         emit LOG_FINAL(swapFee);
827     }
828 
829     // Absorb any tokens that have been sent to this contract into the pool
830     function gulp(address token) external _logs_ _lock_ {
831         require(_records[token].bound, "ERR_NOT_BOUND");
832         _records[token].balance = IERC20(token).balanceOf(address(this));
833     }
834 
835     function getSpotPrice(address tokenIn, address tokenOut)
836         external
837         view
838         _viewlock_
839         returns (uint256 spotPrice)
840     {
841         require(_records[tokenIn].bound, "ERR_NOT_BOUND");
842         require(_records[tokenOut].bound, "ERR_NOT_BOUND");
843         Record storage inRecord = _records[tokenIn];
844         Record storage outRecord = _records[tokenOut];
845         return
846             XMath.calcSpotPrice(
847                 inRecord.balance,
848                 inRecord.denorm,
849                 outRecord.balance,
850                 outRecord.denorm,
851                 swapFee
852             );
853     }
854 
855     function getSpotPriceSansFee(address tokenIn, address tokenOut)
856         external
857         view
858         _viewlock_
859         returns (uint256 spotPrice)
860     {
861         require(_records[tokenIn].bound, "ERR_NOT_BOUND");
862         require(_records[tokenOut].bound, "ERR_NOT_BOUND");
863         Record storage inRecord = _records[tokenIn];
864         Record storage outRecord = _records[tokenOut];
865         return
866             XMath.calcSpotPrice(
867                 inRecord.balance,
868                 inRecord.denorm,
869                 outRecord.balance,
870                 outRecord.denorm,
871                 0
872             );
873     }
874 
875     function joinPool(uint256 poolAmountOut, uint256[] calldata maxAmountsIn)
876         external
877         _lock_
878     {
879         require(finalized, "ERR_NOT_FINALIZED");
880         require(maxAmountsIn.length == _tokens.length, "ERR_LENGTH_MISMATCH");
881 
882         uint256 poolTotal = totalSupply();
883         uint256 ratio = poolAmountOut.bdiv(poolTotal);
884         require(ratio != 0, "ERR_MATH_APPROX");
885 
886         for (uint256 i = 0; i < _tokens.length; i++) {
887             address t = _tokens[i];
888             uint256 bal = _records[t].balance;
889             uint256 tokenAmountIn = ratio.bmul(bal);
890             require(tokenAmountIn != 0, "ERR_MATH_APPROX");
891             require(tokenAmountIn <= maxAmountsIn[i], "ERR_LIMIT_IN");
892             _records[t].balance = (_records[t].balance).badd(tokenAmountIn);
893             emit LOG_JOIN(msg.sender, t, tokenAmountIn);
894             _pullUnderlying(t, msg.sender, tokenAmountIn);
895         }
896         _mintPoolShare(poolAmountOut);
897         _pushPoolShare(msg.sender, poolAmountOut);
898     }
899 
900     function exitPool(uint256 poolAmountIn, uint256[] calldata minAmountsOut)
901         external
902         _lock_
903     {
904         require(finalized, "ERR_NOT_FINALIZED");
905         require(minAmountsOut.length == _tokens.length, "ERR_LENGTH_MISMATCH");
906 
907         // min pool amount
908         require(poolAmountIn >= MIN_POOL_AMOUNT, "ERR_MIN_AMOUNT");
909 
910         uint256 poolTotal = totalSupply();
911         uint256 _exitFee = poolAmountIn.bmul(exitFee);
912 
913         // never charge exitFee to pool origin
914         if (msg.sender == origin) {
915             _exitFee = 0;
916         }
917         uint256 pAiAfterExitFee = poolAmountIn.bsub(_exitFee);
918         uint256 ratio = pAiAfterExitFee.bdiv(poolTotal);
919         require(ratio != 0, "ERR_MATH_APPROX");
920 
921         _pullPoolShare(msg.sender, poolAmountIn);
922         // send exitFee to origin
923         if (_exitFee > 0) {
924             _pushPoolShare(origin, _exitFee);
925         }
926         _burnPoolShare(pAiAfterExitFee);
927 
928         for (uint256 i = 0; i < _tokens.length; i++) {
929             address t = _tokens[i];
930             uint256 bal = _records[t].balance;
931             uint256 tokenAmountOut = ratio.bmul(bal);
932             require(tokenAmountOut != 0, "ERR_MATH_APPROX");
933             require(tokenAmountOut >= minAmountsOut[i], "ERR_LIMIT_OUT");
934             _records[t].balance = (_records[t].balance).bsub(tokenAmountOut);
935             emit LOG_EXIT(msg.sender, t, tokenAmountOut);
936             _pushUnderlying(t, msg.sender, tokenAmountOut);
937         }
938     }
939 
940     function swapExactAmountIn(
941         address tokenIn,
942         uint256 tokenAmountIn,
943         address tokenOut,
944         uint256 minAmountOut,
945         uint256 maxPrice
946     ) external returns (uint256 tokenAmountOut, uint256 spotPriceAfter) {
947         return
948             swapExactAmountInRefer(
949                 tokenIn,
950                 tokenAmountIn,
951                 tokenOut,
952                 minAmountOut,
953                 maxPrice,
954                 address(0x0)
955             );
956     }
957 
958     function swapExactAmountInRefer(
959         address tokenIn,
960         uint256 tokenAmountIn,
961         address tokenOut,
962         uint256 minAmountOut,
963         uint256 maxPrice,
964         address referrer
965     ) public _lock_ returns (uint256 tokenAmountOut, uint256 spotPriceAfter) {
966         require(_records[tokenIn].bound, "ERR_NOT_BOUND");
967         require(_records[tokenOut].bound, "ERR_NOT_BOUND");
968         require(finalized, "ERR_NOT_FINALIZED");
969 
970         Record storage inRecord = _records[address(tokenIn)];
971         Record storage outRecord = _records[address(tokenOut)];
972 
973         require(
974             tokenAmountIn <= (inRecord.balance).bmul(MAX_IN_RATIO),
975             "ERR_MAX_IN_RATIO"
976         );
977 
978         uint256 spotPriceBefore =
979             XMath.calcSpotPrice(
980                 inRecord.balance,
981                 inRecord.denorm,
982                 outRecord.balance,
983                 outRecord.denorm,
984                 swapFee
985             );
986         require(spotPriceBefore <= maxPrice, "ERR_BAD_LIMIT_PRICE");
987 
988         tokenAmountOut = calcOutGivenIn(
989             inRecord.balance,
990             inRecord.denorm,
991             outRecord.balance,
992             outRecord.denorm,
993             tokenAmountIn,
994             swapFee
995         );
996         require(tokenAmountOut >= minAmountOut, "ERR_LIMIT_OUT");
997         require(
998             spotPriceBefore <= tokenAmountIn.bdiv(tokenAmountOut),
999             "ERR_MATH_APPROX"
1000         );
1001 
1002         inRecord.balance = (inRecord.balance).badd(tokenAmountIn);
1003         outRecord.balance = (outRecord.balance).bsub(tokenAmountOut);
1004 
1005         spotPriceAfter = XMath.calcSpotPrice(
1006             inRecord.balance,
1007             inRecord.denorm,
1008             outRecord.balance,
1009             outRecord.denorm,
1010             swapFee
1011         );
1012         require(spotPriceAfter >= spotPriceBefore, "ERR_MATH_APPROX");
1013         require(spotPriceAfter <= maxPrice, "ERR_LIMIT_PRICE");
1014 
1015         emit LOG_SWAP(
1016             msg.sender,
1017             tokenIn,
1018             tokenOut,
1019             tokenAmountIn,
1020             tokenAmountOut
1021         );
1022 
1023         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1024 
1025         uint256 _swapFee = tokenAmountIn.bmul(swapFee);
1026 
1027         // to referral
1028         uint256 _referFee = 0;
1029         if (
1030             referrer != address(0) &&
1031             referrer != msg.sender &&
1032             referrer != tx.origin
1033         ) {
1034             _referFee = _swapFee / 5; // 20% to referrer
1035             _pushUnderlying(tokenIn, referrer, _referFee);
1036             inRecord.balance = (inRecord.balance).bsub(_referFee);
1037             emit LOG_REFER(msg.sender, referrer, tokenIn, _referFee);
1038         }
1039 
1040         // to SAFU
1041         uint256 _safuFee = tokenAmountIn.bmul(safuFee);
1042         if (isFarmPool) {
1043             _safuFee = _swapFee.bsub(_referFee);
1044         }
1045         require(_safuFee.badd(_referFee) <= _swapFee, "ERR_FEE_LIMIT");
1046         _pushUnderlying(tokenIn, SAFU, _safuFee);
1047         inRecord.balance = (inRecord.balance).bsub(_safuFee);
1048 
1049         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1050         return (tokenAmountOut, spotPriceAfter);
1051     }
1052 
1053     function swapExactAmountOut(
1054         address tokenIn,
1055         uint256 maxAmountIn,
1056         address tokenOut,
1057         uint256 tokenAmountOut,
1058         uint256 maxPrice
1059     ) external returns (uint256 tokenAmountIn, uint256 spotPriceAfter) {
1060         return
1061             swapExactAmountOutRefer(
1062                 tokenIn,
1063                 maxAmountIn,
1064                 tokenOut,
1065                 tokenAmountOut,
1066                 maxPrice,
1067                 address(0x0)
1068             );
1069     }
1070 
1071     function swapExactAmountOutRefer(
1072         address tokenIn,
1073         uint256 maxAmountIn,
1074         address tokenOut,
1075         uint256 tokenAmountOut,
1076         uint256 maxPrice,
1077         address referrer
1078     ) public _lock_ returns (uint256 tokenAmountIn, uint256 spotPriceAfter) {
1079         require(_records[tokenIn].bound, "ERR_NOT_BOUND");
1080         require(_records[tokenOut].bound, "ERR_NOT_BOUND");
1081         require(finalized, "ERR_NOT_FINALIZED");
1082 
1083         Record storage inRecord = _records[address(tokenIn)];
1084         Record storage outRecord = _records[address(tokenOut)];
1085 
1086         require(
1087             tokenAmountOut <= (outRecord.balance).bmul(MAX_OUT_RATIO),
1088             "ERR_MAX_OUT_RATIO"
1089         );
1090 
1091         uint256 spotPriceBefore =
1092             XMath.calcSpotPrice(
1093                 inRecord.balance,
1094                 inRecord.denorm,
1095                 outRecord.balance,
1096                 outRecord.denorm,
1097                 swapFee
1098             );
1099         require(spotPriceBefore <= maxPrice, "ERR_BAD_LIMIT_PRICE");
1100 
1101         tokenAmountIn = calcInGivenOut(
1102             inRecord.balance,
1103             inRecord.denorm,
1104             outRecord.balance,
1105             outRecord.denorm,
1106             tokenAmountOut,
1107             swapFee
1108         );
1109         require(tokenAmountIn <= maxAmountIn, "ERR_LIMIT_IN");
1110         require(
1111             spotPriceBefore <= tokenAmountIn.bdiv(tokenAmountOut),
1112             "ERR_MATH_APPROX"
1113         );
1114 
1115         inRecord.balance = (inRecord.balance).badd(tokenAmountIn);
1116         outRecord.balance = (outRecord.balance).bsub(tokenAmountOut);
1117 
1118         spotPriceAfter = XMath.calcSpotPrice(
1119             inRecord.balance,
1120             inRecord.denorm,
1121             outRecord.balance,
1122             outRecord.denorm,
1123             swapFee
1124         );
1125         require(spotPriceAfter >= spotPriceBefore, "ERR_MATH_APPROX");
1126         require(spotPriceAfter <= maxPrice, "ERR_LIMIT_PRICE");
1127 
1128         emit LOG_SWAP(
1129             msg.sender,
1130             tokenIn,
1131             tokenOut,
1132             tokenAmountIn,
1133             tokenAmountOut
1134         );
1135 
1136         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1137 
1138         uint256 _swapFee = tokenAmountIn.bmul(swapFee);
1139         // to referral
1140         uint256 _referFee = 0;
1141         if (
1142             referrer != address(0) &&
1143             referrer != msg.sender &&
1144             referrer != tx.origin
1145         ) {
1146             _referFee = _swapFee / 5; // 20% to referrer
1147             _pushUnderlying(tokenIn, referrer, _referFee);
1148             inRecord.balance = (inRecord.balance).bsub(_referFee);
1149             emit LOG_REFER(msg.sender, referrer, tokenIn, _referFee);
1150         }
1151 
1152         // to SAFU
1153         uint256 _safuFee = tokenAmountIn.bmul(safuFee);
1154         if (isFarmPool) {
1155             _safuFee = _swapFee.bsub(_referFee);
1156         }
1157         require(_safuFee.badd(_referFee) <= _swapFee, "ERR_FEE_LIMIT");
1158         _pushUnderlying(tokenIn, SAFU, _safuFee);
1159         inRecord.balance = (inRecord.balance).bsub(_safuFee);
1160 
1161         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1162         return (tokenAmountIn, spotPriceAfter);
1163     }
1164 
1165     function joinswapExternAmountIn(
1166         address tokenIn,
1167         uint256 tokenAmountIn,
1168         uint256 minPoolAmountOut
1169     ) external _lock_ returns (uint256 poolAmountOut) {
1170         require(finalized, "ERR_NOT_FINALIZED");
1171         require(_records[tokenIn].bound, "ERR_NOT_BOUND");
1172         require(
1173             tokenAmountIn <= (_records[tokenIn].balance).bmul(MAX_IN_RATIO),
1174             "ERR_MAX_IN_RATIO"
1175         );
1176 
1177         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1178 
1179         // to SAFU
1180         uint256 _safuFee = tokenAmountIn.bmul(safuFee);
1181         if (isFarmPool) {
1182             _safuFee = tokenAmountIn.bmul(swapFee);
1183         }
1184         tokenAmountIn = tokenAmountIn.bsub(_safuFee);
1185 
1186         Record storage inRecord = _records[tokenIn];
1187         poolAmountOut = XMath.calcPoolOutGivenSingleIn(
1188             inRecord.balance,
1189             inRecord.denorm,
1190             _totalSupply,
1191             _totalWeight,
1192             tokenAmountIn,
1193             swapFee
1194         );
1195         require(poolAmountOut >= minPoolAmountOut, "ERR_LIMIT_OUT");
1196 
1197         inRecord.balance = (inRecord.balance).badd(tokenAmountIn);
1198 
1199         _pushUnderlying(tokenIn, SAFU, _safuFee);
1200         emit LOG_JOIN(msg.sender, tokenIn, tokenAmountIn);
1201         _mintPoolShare(poolAmountOut);
1202         _pushPoolShare(msg.sender, poolAmountOut);
1203         return poolAmountOut;
1204     }
1205 
1206     function exitswapPoolAmountIn(
1207         address tokenOut,
1208         uint256 poolAmountIn,
1209         uint256 minAmountOut
1210     ) external _logs_ _lock_ returns (uint256 tokenAmountOut) {
1211         require(finalized, "ERR_NOT_FINALIZED");
1212         require(_records[tokenOut].bound, "ERR_NOT_BOUND");
1213         require(poolAmountIn >= MIN_POOL_AMOUNT, "ERR_MIN_AMOUNT");
1214 
1215         _pullPoolShare(msg.sender, poolAmountIn);
1216 
1217         // exit fee to origin
1218         if (exitFee > 0 && msg.sender != origin) {
1219             uint256 _exitFee = poolAmountIn.bmul(exitFee);
1220             _pushPoolShare(origin, _exitFee);
1221             poolAmountIn = poolAmountIn.bsub(_exitFee);
1222         }
1223 
1224         _burnPoolShare(poolAmountIn);
1225 
1226         Record storage outRecord = _records[tokenOut];
1227         tokenAmountOut = XMath.calcSingleOutGivenPoolIn(
1228             outRecord.balance,
1229             outRecord.denorm,
1230             _totalSupply,
1231             _totalWeight,
1232             poolAmountIn,
1233             swapFee
1234         );
1235 
1236         require(tokenAmountOut >= minAmountOut, "ERR_LIMIT_OUT");
1237         require(
1238             tokenAmountOut <= (_records[tokenOut].balance).bmul(MAX_OUT_RATIO),
1239             "ERR_MAX_OUT_RATIO"
1240         );
1241 
1242         outRecord.balance = (outRecord.balance).bsub(tokenAmountOut);
1243 
1244         // to SAFU
1245         uint256 _safuFee = tokenAmountOut.bmul(safuFee);
1246         if (isFarmPool) {
1247             _safuFee = tokenAmountOut.bmul(swapFee);
1248         }
1249 
1250         emit LOG_EXIT(msg.sender, tokenOut, tokenAmountOut);
1251         _pushUnderlying(tokenOut, SAFU, _safuFee);
1252         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut.bsub(_safuFee));
1253         return tokenAmountOut;
1254     }
1255 
1256     function calcOutGivenIn(
1257         uint256 tokenBalanceIn,
1258         uint256 tokenWeightIn,
1259         uint256 tokenBalanceOut,
1260         uint256 tokenWeightOut,
1261         uint256 tokenAmountIn,
1262         uint256 _swapFee
1263     ) public pure returns (uint256) {
1264         return
1265             XMath.calcOutGivenIn(
1266                 tokenBalanceIn,
1267                 tokenWeightIn,
1268                 tokenBalanceOut,
1269                 tokenWeightOut,
1270                 tokenAmountIn,
1271                 _swapFee
1272             );
1273     }
1274 
1275     function calcInGivenOut(
1276         uint256 tokenBalanceIn,
1277         uint256 tokenWeightIn,
1278         uint256 tokenBalanceOut,
1279         uint256 tokenWeightOut,
1280         uint256 tokenAmountOut,
1281         uint256 _swapFee
1282     ) public pure returns (uint256) {
1283         return
1284             XMath.calcInGivenOut(
1285                 tokenBalanceIn,
1286                 tokenWeightIn,
1287                 tokenBalanceOut,
1288                 tokenWeightOut,
1289                 tokenAmountOut,
1290                 _swapFee
1291             );
1292     }
1293 
1294     // ==
1295     // 'Underlying' token-manipulation functions make external calls but are NOT locked
1296     // You must `_lock_` or otherwise ensure reentry-safety
1297     // Fixed ERC-20 transfer revert for some special token such as USDT
1298     function _pullUnderlying(
1299         address erc20,
1300         address from,
1301         uint256 amount
1302     ) internal {
1303         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
1304         (bool success, bytes memory data) =
1305             erc20.call(
1306                 abi.encodeWithSelector(0x23b872dd, from, address(this), amount)
1307             );
1308         require(
1309             success && (data.length == 0 || abi.decode(data, (bool))),
1310             "ERC20_TRANSFER_FROM_FAILED"
1311         );
1312     }
1313 
1314     function _pushUnderlying(
1315         address erc20,
1316         address to,
1317         uint256 amount
1318     ) internal {
1319         // bytes4(keccak256(bytes('transfer(address,uint256)')));
1320         (bool success, bytes memory data) =
1321             erc20.call(abi.encodeWithSelector(0xa9059cbb, to, amount));
1322         require(
1323             success && (data.length == 0 || abi.decode(data, (bool))),
1324             "ERC20_TRANSFER_FAILED"
1325         );
1326     }
1327 
1328     function _pullPoolShare(address from, uint256 amount) internal {
1329         _move(from, address(this), amount);
1330     }
1331 
1332     function _pushPoolShare(address to, uint256 amount) internal {
1333         _move(address(this), to, amount);
1334     }
1335 
1336     function _mintPoolShare(uint256 amount) internal {
1337         _mint(amount);
1338     }
1339 
1340     function _burnPoolShare(uint256 amount) internal {
1341         _burn(amount);
1342     }
1343 }