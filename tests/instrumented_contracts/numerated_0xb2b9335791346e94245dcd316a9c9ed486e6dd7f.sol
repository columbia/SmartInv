1 /*
2 https://powerpool.finance/
3 
4           wrrrw r wrr
5          ppwr rrr wppr0       prwwwrp                                 prwwwrp                   wr0
6         rr 0rrrwrrprpwp0      pp   pr  prrrr0 pp   0r  prrrr0  0rwrrr pp   pr  prrrr0  prrrr0    r0
7         rrp pr   wr00rrp      prwww0  pp   wr pp w00r prwwwpr  0rw    prwww0  pp   wr pp   wr    r0
8         r0rprprwrrrp pr0      pp      wr   pr pp rwwr wr       0r     pp      wr   pr wr   pr    r0
9          prwr wrr0wpwr        00        www0   0w0ww    www0   0w     00        www0    www0   0www0
10           wrr ww0rrrr
11 
12 */
13 
14 // File: contracts/balancer-core/BConst.sol
15 
16 // This program is free software: you can redistribute it and/or modify
17 // it under the terms of the GNU General Public License as published by
18 // the Free Software Foundation, either version 3 of the License, or
19 // (at your option) any later version.
20 
21 // This program is distributed in the hope that it will be useful,
22 // but WITHOUT ANY WARRANTY; without even the implied warranty of
23 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
24 // GNU General Public License for more details.
25 
26 // You should have received a copy of the GNU General Public License
27 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
28 
29 pragma solidity 0.6.12;
30 
31 contract BConst {
32     uint public constant BONE              = 10**18;
33 
34     uint public constant MIN_BOUND_TOKENS  = 2;
35     uint public constant MAX_BOUND_TOKENS  = 8;
36 
37     uint public constant MIN_FEE           = BONE / 10**6;
38     uint public constant MAX_FEE           = BONE / 10;
39 
40     uint public constant MIN_WEIGHT        = BONE;
41     uint public constant MAX_WEIGHT        = BONE * 50;
42     uint public constant MAX_TOTAL_WEIGHT  = BONE * 50;
43     uint public constant MIN_BALANCE       = BONE / 10**12;
44 
45     uint public constant INIT_POOL_SUPPLY  = BONE * 100;
46 
47     uint public constant MIN_BPOW_BASE     = 1 wei;
48     uint public constant MAX_BPOW_BASE     = (2 * BONE) - 1 wei;
49     uint public constant BPOW_PRECISION    = BONE / 10**10;
50 
51     uint public constant MAX_IN_RATIO      = BONE / 2;
52     uint public constant MAX_OUT_RATIO     = (BONE / 3) + 1 wei;
53 }
54 
55 // File: contracts/balancer-core/BNum.sol
56 
57 // This program is free software: you can redistribute it and/or modify
58 // it under the terms of the GNU General Public License as published by
59 // the Free Software Foundation, either version 3 of the License, or
60 // (at your option) any later version.
61 
62 // This program is distributed in the hope that it will be useful,
63 // but WITHOUT ANY WARRANTY; without even the implied warranty of
64 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
65 // GNU General Public License for more details.
66 
67 // You should have received a copy of the GNU General Public License
68 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
69 
70 pragma solidity 0.6.12;
71 
72 
73 contract BNum is BConst {
74 
75     function btoi(uint a)
76         internal pure 
77         returns (uint)
78     {
79         return a / BONE;
80     }
81 
82     function bfloor(uint a)
83         internal pure
84         returns (uint)
85     {
86         return btoi(a) * BONE;
87     }
88 
89     function badd(uint a, uint b)
90         internal pure
91         returns (uint)
92     {
93         uint c = a + b;
94         require(c >= a, "ERR_ADD_OVERFLOW");
95         return c;
96     }
97 
98     function bsub(uint a, uint b)
99         internal pure
100         returns (uint)
101     {
102         (uint c, bool flag) = bsubSign(a, b);
103         require(!flag, "ERR_SUB_UNDERFLOW");
104         return c;
105     }
106 
107     function bsubSign(uint a, uint b)
108         internal pure
109         returns (uint, bool)
110     {
111         if (a >= b) {
112             return (a - b, false);
113         } else {
114             return (b - a, true);
115         }
116     }
117 
118     function bmul(uint a, uint b)
119         internal pure
120         returns (uint)
121     {
122         uint c0 = a * b;
123         require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
124         uint c1 = c0 + (BONE / 2);
125         require(c1 >= c0, "ERR_MUL_OVERFLOW");
126         uint c2 = c1 / BONE;
127         return c2;
128     }
129 
130     function bdiv(uint a, uint b)
131         internal pure
132         returns (uint)
133     {
134         require(b != 0, "ERR_DIV_ZERO");
135         uint c0 = a * BONE;
136         require(a == 0 || c0 / a == BONE, "ERR_DIV_INTERNAL"); // bmul overflow
137         uint c1 = c0 + (b / 2);
138         require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
139         uint c2 = c1 / b;
140         return c2;
141     }
142 
143     // DSMath.wpow
144     function bpowi(uint a, uint n)
145         internal pure
146         returns (uint)
147     {
148         uint z = n % 2 != 0 ? a : BONE;
149 
150         for (n /= 2; n != 0; n /= 2) {
151             a = bmul(a, a);
152 
153             if (n % 2 != 0) {
154                 z = bmul(z, a);
155             }
156         }
157         return z;
158     }
159 
160     // Compute b^(e.w) by splitting it into (b^e)*(b^0.w).
161     // Use `bpowi` for `b^e` and `bpowK` for k iterations
162     // of approximation of b^0.w
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
189         (uint x, bool xneg)  = bsubSign(base, BONE);
190         uint term = BONE;
191         uint sum   = term;
192         bool negative = false;
193 
194 
195         // term(k) = numer / denom 
196         //         = (product(a - i - 1, i=1-->k) * x^k) / (k!)
197         // each iteration, multiply previous term by (a-(k-1)) * x / k
198         // continue until term is less than precision
199         for (uint i = 1; term >= precision; i++) {
200             uint bigK = i * BONE;
201             (uint c, bool cneg) = bsubSign(a, bsub(bigK, BONE));
202             term = bmul(term, bmul(c, x));
203             term = bdiv(term, bigK);
204             if (term == 0) break;
205 
206             if (xneg) negative = !negative;
207             if (cneg) negative = !negative;
208             if (negative) {
209                 sum = bsub(sum, term);
210             } else {
211                 sum = badd(sum, term);
212             }
213         }
214 
215         return sum;
216     }
217 
218 }
219 
220 // File: contracts/balancer-core/BToken.sol
221 
222 // This program is free software: you can redistribute it and/or modify
223 // it under the terms of the GNU General Public License as published by
224 // the Free Software Foundation, either version 3 of the License, or
225 // (at your option) any later version.
226 
227 // This program is distributed in the hope that it will be useful,
228 // but WITHOUT ANY WARRANTY; without even the implied warranty of
229 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
230 // GNU General Public License for more details.
231 
232 // You should have received a copy of the GNU General Public License
233 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
234 
235 pragma solidity 0.6.12;
236 
237 
238 // Highly opinionated token implementation
239 
240 interface IERC20 {
241     event Approval(address indexed src, address indexed dst, uint amt);
242     event Transfer(address indexed src, address indexed dst, uint amt);
243 
244     function totalSupply() external view returns (uint);
245     function balanceOf(address whom) external view returns (uint);
246     function allowance(address src, address dst) external view returns (uint);
247 
248     function approve(address dst, uint amt) external returns (bool);
249     function transfer(address dst, uint amt) external returns (bool);
250     function transferFrom(
251         address src, address dst, uint amt
252     ) external returns (bool);
253 }
254 
255 contract BTokenBase is BNum {
256 
257     mapping(address => uint)                   internal _balance;
258     mapping(address => mapping(address=>uint)) internal _allowance;
259     uint internal _totalSupply;
260 
261     event Approval(address indexed src, address indexed dst, uint amt);
262     event Transfer(address indexed src, address indexed dst, uint amt);
263 
264     function _mint(uint amt) internal {
265         _balance[address(this)] = badd(_balance[address(this)], amt);
266         _totalSupply = badd(_totalSupply, amt);
267         emit Transfer(address(0), address(this), amt);
268     }
269 
270     function _burn(uint amt) internal {
271         require(_balance[address(this)] >= amt, "ERR_INSUFFICIENT_BAL");
272         _balance[address(this)] = bsub(_balance[address(this)], amt);
273         _totalSupply = bsub(_totalSupply, amt);
274         emit Transfer(address(this), address(0), amt);
275     }
276 
277     function _move(address src, address dst, uint amt) internal {
278         require(_balance[src] >= amt, "ERR_INSUFFICIENT_BAL");
279         _balance[src] = bsub(_balance[src], amt);
280         _balance[dst] = badd(_balance[dst], amt);
281         emit Transfer(src, dst, amt);
282     }
283 
284     function _push(address to, uint amt) internal {
285         _move(address(this), to, amt);
286     }
287 
288     function _pull(address from, uint amt) internal {
289         _move(from, address(this), amt);
290     }
291 }
292 
293 contract BToken is BTokenBase, IERC20 {
294 
295     string  internal _name;
296     string  internal _symbol;
297     uint8   private _decimals = 18;
298 
299     function name() public view returns (string memory) {
300         return _name;
301     }
302 
303     function symbol() public view returns (string memory) {
304         return _symbol;
305     }
306 
307     function decimals() public view returns(uint8) {
308         return _decimals;
309     }
310 
311     function allowance(address src, address dst) external override view returns (uint) {
312         return _allowance[src][dst];
313     }
314 
315     function balanceOf(address whom) external override view returns (uint) {
316         return _balance[whom];
317     }
318 
319     function totalSupply() public override view returns (uint) {
320         return _totalSupply;
321     }
322 
323     function approve(address dst, uint amt) external override returns (bool) {
324         _allowance[msg.sender][dst] = amt;
325         emit Approval(msg.sender, dst, amt);
326         return true;
327     }
328 
329     function increaseApproval(address dst, uint amt) external returns (bool) {
330         _allowance[msg.sender][dst] = badd(_allowance[msg.sender][dst], amt);
331         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
332         return true;
333     }
334 
335     function decreaseApproval(address dst, uint amt) external returns (bool) {
336         uint oldValue = _allowance[msg.sender][dst];
337         if (amt > oldValue) {
338             _allowance[msg.sender][dst] = 0;
339         } else {
340             _allowance[msg.sender][dst] = bsub(oldValue, amt);
341         }
342         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
343         return true;
344     }
345 
346     function transfer(address dst, uint amt) external override returns (bool) {
347         _move(msg.sender, dst, amt);
348         return true;
349     }
350 
351     function transferFrom(address src, address dst, uint amt) external override returns (bool) {
352         require(msg.sender == src || amt <= _allowance[src][msg.sender], "ERR_BTOKEN_BAD_CALLER");
353         _move(src, dst, amt);
354         if (msg.sender != src && _allowance[src][msg.sender] != uint256(-1)) {
355             _allowance[src][msg.sender] = bsub(_allowance[src][msg.sender], amt);
356             emit Approval(msg.sender, dst, _allowance[src][msg.sender]);
357         }
358         return true;
359     }
360 }
361 
362 // File: contracts/balancer-core/BMath.sol
363 
364 // This program is free software: you can redistribute it and/or modify
365 // it under the terms of the GNU General Public License as published by
366 // the Free Software Foundation, either version 3 of the License, or
367 // (at your option) any later version.
368 
369 // This program is distributed in the hope that it will be useful,
370 // but WITHOUT ANY WARRANTY; without even the implied warranty of
371 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
372 // GNU General Public License for more details.
373 
374 // You should have received a copy of the GNU General Public License
375 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
376 
377 pragma solidity 0.6.12;
378 
379 
380 contract BMath is BConst, BNum {
381     /**********************************************************************************************
382     // calcSpotPrice                                                                             //
383     // sP = spotPrice                                                                            //
384     // bI = tokenBalanceIn                ( bI / wI )         1                                  //
385     // bO = tokenBalanceOut         sP =  -----------  *  ----------                             //
386     // wI = tokenWeightIn                 ( bO / wO )     ( 1 - sF )                             //
387     // wO = tokenWeightOut                                                                       //
388     // sF = swapFee                                                                              //
389     **********************************************************************************************/
390     function calcSpotPrice(
391         uint tokenBalanceIn,
392         uint tokenWeightIn,
393         uint tokenBalanceOut,
394         uint tokenWeightOut,
395         uint swapFee
396     )
397         public pure
398         returns (uint spotPrice)
399     {
400         uint numer = bdiv(tokenBalanceIn, tokenWeightIn);
401         uint denom = bdiv(tokenBalanceOut, tokenWeightOut);
402         uint ratio = bdiv(numer, denom);
403         uint scale = bdiv(BONE, bsub(BONE, swapFee));
404         return  (spotPrice = bmul(ratio, scale));
405     }
406 
407     /**********************************************************************************************
408     // calcOutGivenIn                                                                            //
409     // aO = tokenAmountOut                                                                       //
410     // bO = tokenBalanceOut                                                                      //
411     // bI = tokenBalanceIn              /      /            bI             \    (wI / wO) \      //
412     // aI = tokenAmountIn    aO = bO * |  1 - | --------------------------  | ^            |     //
413     // wI = tokenWeightIn               \      \ ( bI + ( aI * ( 1 - sF )) /              /      //
414     // wO = tokenWeightOut                                                                       //
415     // sF = swapFee                                                                              //
416     **********************************************************************************************/
417     function calcOutGivenIn(
418         uint tokenBalanceIn,
419         uint tokenWeightIn,
420         uint tokenBalanceOut,
421         uint tokenWeightOut,
422         uint tokenAmountIn,
423         uint swapFee
424     )
425         public pure
426         returns (uint tokenAmountOut)
427     {
428         uint weightRatio = bdiv(tokenWeightIn, tokenWeightOut);
429         uint adjustedIn = bsub(BONE, swapFee);
430         adjustedIn = bmul(tokenAmountIn, adjustedIn);
431         uint y = bdiv(tokenBalanceIn, badd(tokenBalanceIn, adjustedIn));
432         uint foo = bpow(y, weightRatio);
433         uint bar = bsub(BONE, foo);
434         tokenAmountOut = bmul(tokenBalanceOut, bar);
435         return tokenAmountOut;
436     }
437 
438     /**********************************************************************************************
439     // calcInGivenOut                                                                            //
440     // aI = tokenAmountIn                                                                        //
441     // bO = tokenBalanceOut               /  /     bO      \    (wO / wI)      \                 //
442     // bI = tokenBalanceIn          bI * |  | ------------  | ^            - 1  |                //
443     // aO = tokenAmountOut    aI =        \  \ ( bO - aO ) /                   /                 //
444     // wI = tokenWeightIn           --------------------------------------------                 //
445     // wO = tokenWeightOut                          ( 1 - sF )                                   //
446     // sF = swapFee                                                                              //
447     **********************************************************************************************/
448     function calcInGivenOut(
449         uint tokenBalanceIn,
450         uint tokenWeightIn,
451         uint tokenBalanceOut,
452         uint tokenWeightOut,
453         uint tokenAmountOut,
454         uint swapFee
455     )
456         public pure
457         returns (uint tokenAmountIn)
458     {
459         uint weightRatio = bdiv(tokenWeightOut, tokenWeightIn);
460         uint diff = bsub(tokenBalanceOut, tokenAmountOut);
461         uint y = bdiv(tokenBalanceOut, diff);
462         uint foo = bpow(y, weightRatio);
463         foo = bsub(foo, BONE);
464         tokenAmountIn = bsub(BONE, swapFee);
465         tokenAmountIn = bdiv(bmul(tokenBalanceIn, foo), tokenAmountIn);
466         return tokenAmountIn;
467     }
468 
469     /**********************************************************************************************
470     // calcPoolOutGivenSingleIn                                                                  //
471     // pAo = poolAmountOut         /                                              \              //
472     // tAi = tokenAmountIn        ///      /     //    wI \      \\       \     wI \             //
473     // wI = tokenWeightIn        //| tAi *| 1 - || 1 - --  | * sF || + tBi \    --  \            //
474     // tW = totalWeight     pAo=||  \      \     \\    tW /      //         | ^ tW   | * pS - pS //
475     // tBi = tokenBalanceIn      \\  ------------------------------------- /        /            //
476     // pS = poolSupply            \\                    tBi               /        /             //
477     // sF = swapFee                \                                              /              //
478     **********************************************************************************************/
479     function calcPoolOutGivenSingleIn(
480         uint tokenBalanceIn,
481         uint tokenWeightIn,
482         uint poolSupply,
483         uint totalWeight,
484         uint tokenAmountIn,
485         uint swapFee
486     )
487         public pure
488         returns (uint poolAmountOut)
489     {
490         // Charge the trading fee for the proportion of tokenAi
491         ///  which is implicitly traded to the other pool tokens.
492         // That proportion is (1- weightTokenIn)
493         // tokenAiAfterFee = tAi * (1 - (1-weightTi) * poolFee);
494         uint normalizedWeight = bdiv(tokenWeightIn, totalWeight);
495         uint zaz = bmul(bsub(BONE, normalizedWeight), swapFee); 
496         uint tokenAmountInAfterFee = bmul(tokenAmountIn, bsub(BONE, zaz));
497 
498         uint newTokenBalanceIn = badd(tokenBalanceIn, tokenAmountInAfterFee);
499         uint tokenInRatio = bdiv(newTokenBalanceIn, tokenBalanceIn);
500 
501         // uint newPoolSupply = (ratioTi ^ weightTi) * poolSupply;
502         uint poolRatio = bpow(tokenInRatio, normalizedWeight);
503         uint newPoolSupply = bmul(poolRatio, poolSupply);
504         poolAmountOut = bsub(newPoolSupply, poolSupply);
505         return poolAmountOut;
506     }
507 
508     /**********************************************************************************************
509     // calcSingleInGivenPoolOut                                                                  //
510     // tAi = tokenAmountIn              //(pS + pAo)\     /    1    \\                           //
511     // pS = poolSupply                 || ---------  | ^ | --------- || * bI - bI                //
512     // pAo = poolAmountOut              \\    pS    /     \(wI / tW)//                           //
513     // bI = balanceIn          tAi =  --------------------------------------------               //
514     // wI = weightIn                              /      wI  \                                   //
515     // tW = totalWeight                          |  1 - ----  |  * sF                            //
516     // sF = swapFee                               \      tW  /                                   //
517     **********************************************************************************************/
518     function calcSingleInGivenPoolOut(
519         uint tokenBalanceIn,
520         uint tokenWeightIn,
521         uint poolSupply,
522         uint totalWeight,
523         uint poolAmountOut,
524         uint swapFee
525     )
526         public pure
527         returns (uint tokenAmountIn)
528     {
529         uint normalizedWeight = bdiv(tokenWeightIn, totalWeight);
530         uint newPoolSupply = badd(poolSupply, poolAmountOut);
531         uint poolRatio = bdiv(newPoolSupply, poolSupply);
532       
533         //uint newBalTi = poolRatio^(1/weightTi) * balTi;
534         uint boo = bdiv(BONE, normalizedWeight); 
535         uint tokenInRatio = bpow(poolRatio, boo);
536         uint newTokenBalanceIn = bmul(tokenInRatio, tokenBalanceIn);
537         uint tokenAmountInAfterFee = bsub(newTokenBalanceIn, tokenBalanceIn);
538         // Do reverse order of fees charged in joinswap_ExternAmountIn, this way 
539         //     ``` pAo == joinswap_ExternAmountIn(Ti, joinswap_PoolAmountOut(pAo, Ti)) ```
540         //uint tAi = tAiAfterFee / (1 - (1-weightTi) * swapFee) ;
541         uint zar = bmul(bsub(BONE, normalizedWeight), swapFee);
542         tokenAmountIn = bdiv(tokenAmountInAfterFee, bsub(BONE, zar));
543         return tokenAmountIn;
544     }
545 
546     /**********************************************************************************************
547     // calcSingleOutGivenPoolIn                                                                  //
548     // tAo = tokenAmountOut            /      /                                             \\   //
549     // bO = tokenBalanceOut           /      //       pS - pAi        \     /    1    \      \\  //
550     // pAi = poolAmountIn            | bO - || ----------------------- | ^ | --------- | * b0 || //
551     // ps = poolSupply                \      \\          pS           /     \(wO / tW)/      //  //
552     // wI = tokenWeightIn      tAo =   \      \                                             //   //
553     // tW = totalWeight                    /     /      wO \       \                             //
554     // sF = swapFee                    *  | 1 - |  1 - ---- | * sF  |                            //
555     // eF = exitFee                        \     \      tW /       /                             //
556     **********************************************************************************************/
557     function calcSingleOutGivenPoolIn(
558         uint tokenBalanceOut,
559         uint tokenWeightOut,
560         uint poolSupply,
561         uint totalWeight,
562         uint poolAmountIn,
563         uint swapFee
564     )
565         public pure
566         returns (uint tokenAmountOut)
567     {
568         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
569         uint newPoolSupply = bsub(poolSupply, poolAmountIn);
570         uint poolRatio = bdiv(newPoolSupply, poolSupply);
571      
572         // newBalTo = poolRatio^(1/weightTo) * balTo;
573         uint tokenOutRatio = bpow(poolRatio, bdiv(BONE, normalizedWeight));
574         uint newTokenBalanceOut = bmul(tokenOutRatio, tokenBalanceOut);
575 
576         uint tokenAmountOutBeforeSwapFee = bsub(tokenBalanceOut, newTokenBalanceOut);
577 
578         // charge swap fee on the output token side 
579         //uint tAo = tAoBeforeSwapFee * (1 - (1-weightTo) * swapFee)
580         uint zaz = bmul(bsub(BONE, normalizedWeight), swapFee); 
581         tokenAmountOut = bmul(tokenAmountOutBeforeSwapFee, bsub(BONE, zaz));
582         return tokenAmountOut;
583     }
584 
585     /**********************************************************************************************
586     // calcPoolInGivenSingleOut                                                                  //
587     // pAi = poolAmountIn               // /               tAo             \\     / wO \     \   //
588     // bO = tokenBalanceOut            // | bO - -------------------------- |\   | ---- |     \  //
589     // tAo = tokenAmountOut      pS - ||   \     1 - ((1 - (tO / tW)) * sF)/  | ^ \ tW /  * pS | //
590     // ps = poolSupply                 \\ -----------------------------------/                /  //
591     // wO = tokenWeightOut  pAi =       \\               bO                 /                /   //
592     // tW = totalWeight                                                                          //
593     // sF = swapFee                                                                              //
594     **********************************************************************************************/
595     function calcPoolInGivenSingleOut(
596         uint tokenBalanceOut,
597         uint tokenWeightOut,
598         uint poolSupply,
599         uint totalWeight,
600         uint tokenAmountOut,
601         uint swapFee
602     )
603         public pure
604         returns (uint poolAmountIn)
605     {
606 
607         // charge swap fee on the output token side 
608         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
609         //uint tAoBeforeSwapFee = tAo / (1 - (1-weightTo) * swapFee) ;
610         uint zoo = bsub(BONE, normalizedWeight);
611         uint zar = bmul(zoo, swapFee); 
612         uint tokenAmountOutBeforeSwapFee = bdiv(tokenAmountOut, bsub(BONE, zar));
613 
614         uint newTokenBalanceOut = bsub(tokenBalanceOut, tokenAmountOutBeforeSwapFee);
615         uint tokenOutRatio = bdiv(newTokenBalanceOut, tokenBalanceOut);
616 
617         //uint newPoolSupply = (ratioTo ^ weightTo) * poolSupply;
618         uint poolRatio = bpow(tokenOutRatio, normalizedWeight);
619         uint newPoolSupply = bmul(poolRatio, poolSupply);
620         uint poolAmountIn = bsub(poolSupply, newPoolSupply);
621         return poolAmountIn;
622     }
623 }
624 
625 // File: contracts/IPoolRestrictions.sol
626 
627 pragma solidity 0.6.12;
628 
629 
630 interface IPoolRestrictions {
631     function getMaxTotalSupply(address _pool) external virtual view returns(uint256);
632     function isVotingSignatureAllowed(address _votingAddress, bytes4 _signature) external virtual view returns(bool);
633     function isWithoutFee(address _addr) external virtual view returns(bool);
634 }
635 
636 // File: contracts/balancer-core/BPool.sol
637 
638 // This program is free software: you can redistribute it and/or modify
639 // it under the terms of the GNU General Public License as published by
640 // the Free Software Foundation, either version 3 of the License, or
641 // (at your option) any later version.
642 
643 // This program is distributed in the hope that it will be useful,
644 // but WITHOUT ANY WARRANTY; without even the implied warranty of
645 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
646 // GNU General Public License for more details.
647 
648 // You should have received a copy of the GNU General Public License
649 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
650 
651 pragma solidity 0.6.12;
652 
653 
654 
655 
656 contract BPool is BToken, BMath {
657 
658     struct Record {
659         bool bound;   // is token bound to pool
660         uint index;   // private
661         uint denorm;  // denormalized weight
662         uint balance;
663     }
664 
665     event LOG_SWAP(
666         address indexed caller,
667         address indexed tokenIn,
668         address indexed tokenOut,
669         uint256         tokenAmountIn,
670         uint256         tokenAmountOut
671     );
672 
673     event LOG_JOIN(
674         address indexed caller,
675         address indexed tokenIn,
676         uint256         tokenAmountIn
677     );
678 
679     event LOG_EXIT(
680         address indexed caller,
681         address indexed tokenOut,
682         uint256         tokenAmountOut
683     );
684 
685     event LOG_CALL(
686         bytes4  indexed sig,
687         address indexed caller,
688         bytes           data
689     ) anonymous;
690 
691     event LOG_CALL_VOTING(
692         address indexed voting,
693         bool    indexed success,
694         bytes4  indexed inputSig,
695         bytes           inputData,
696         bytes           outputData
697     );
698 
699     modifier _logs_() {
700         emit LOG_CALL(msg.sig, msg.sender, msg.data);
701         _;
702     }
703 
704     modifier _lock_() {
705         require(!_mutex, "REENTRY");
706         _mutex = true;
707         _;
708         _mutex = false;
709     }
710 
711     modifier _viewlock_() {
712         require(!_mutex, "REENTRY");
713         _;
714     }
715 
716     bool private _mutex;
717 
718     address private _controller; // has CONTROL role
719     bool private _publicSwap; // true if PUBLIC can call SWAP functions
720 
721     IPoolRestrictions private _restrictions;
722 
723     // `setSwapFee` and `finalize` require CONTROL
724     // `finalize` sets `PUBLIC can SWAP`, `PUBLIC can JOIN`
725     uint private _swapFee;
726     uint private _communitySwapFee;
727     uint private _communityJoinFee;
728     uint private _communityExitFee;
729     address private _communityFeeReceiver;
730     bool private _finalized;
731 
732     address[] private _tokens;
733     mapping(address=>Record) private  _records;
734     uint private _totalWeight;
735 
736     constructor(string memory name, string memory symbol) public {
737         _name = name;
738         _symbol = symbol;
739         _controller = msg.sender;
740         _swapFee = MIN_FEE;
741         _communitySwapFee = 0;
742         _communityJoinFee = 0;
743         _communityExitFee = 0;
744         _publicSwap = false;
745         _finalized = false;
746     }
747 
748     function isPublicSwap()
749         external view
750         returns (bool)
751     {
752         return _publicSwap;
753     }
754 
755     function isFinalized()
756         external view
757         returns (bool)
758     {
759         return _finalized;
760     }
761 
762     function isBound(address t)
763         external view
764         returns (bool)
765     {
766         return _records[t].bound;
767     }
768 
769     function getNumTokens()
770         external view
771         returns (uint) 
772     {
773         return _tokens.length;
774     }
775 
776     function getCurrentTokens()
777         external view _viewlock_
778         returns (address[] memory tokens)
779     {
780         return _tokens;
781     }
782 
783     function getFinalTokens()
784         external view
785         _viewlock_
786         returns (address[] memory tokens)
787     {
788         require(_finalized, "NOT_FINALIZED");
789         return _tokens;
790     }
791 
792     function getDenormalizedWeight(address token)
793         external view
794         _viewlock_
795         returns (uint)
796     {
797 
798         _checkBound(token);
799         return _records[token].denorm;
800     }
801 
802     function getTotalDenormalizedWeight()
803         external view
804         _viewlock_
805         returns (uint)
806     {
807         return _totalWeight;
808     }
809 
810     function getNormalizedWeight(address token)
811         external view
812         _viewlock_
813         returns (uint)
814     {
815 
816         _checkBound(token);
817         return bdiv(_records[token].denorm, _totalWeight);
818     }
819 
820     function getBalance(address token)
821         external view
822         _viewlock_
823         returns (uint)
824     {
825 
826         _checkBound(token);
827         return _records[token].balance;
828     }
829 
830     function getSwapFee()
831         external view
832         _viewlock_
833         returns (uint)
834     {
835         return _swapFee;
836     }
837 
838     function getCommunityFee()
839         external view
840         _viewlock_
841         returns (uint communitySwapFee, uint communityJoinFee, uint communityExitFee, address communityFeeReceiver)
842     {
843         return (_communitySwapFee, _communityJoinFee, _communityExitFee, _communityFeeReceiver);
844     }
845 
846     function getController()
847         external view
848         _viewlock_
849         returns (address)
850     {
851         return _controller;
852     }
853 
854     function getRestrictions()
855         external view
856         _viewlock_
857         returns (address)
858     {
859         return address(_restrictions);
860     }
861 
862     function setSwapFee(uint swapFee)
863         external
864         _logs_
865         _lock_
866     {
867         _checkController();
868         require(swapFee >= MIN_FEE && swapFee <= MAX_FEE, "FEE_BOUNDS");
869         _swapFee = swapFee;
870     }
871 
872     function setCommunityFeeAndReceiver(
873         uint communitySwapFee,
874         uint communityJoinFee,
875         uint communityExitFee,
876         address communityFeeReceiver
877     )
878         external
879         _logs_
880         _lock_
881     {
882         _checkController();
883         require(communitySwapFee >= MIN_FEE && communitySwapFee <= MAX_FEE, "FEE_BOUNDS");
884         require(communityJoinFee >= MIN_FEE && communityJoinFee <= MAX_FEE, "FEE_BOUNDS");
885         require(communityExitFee >= MIN_FEE && communityExitFee <= MAX_FEE, "FEE_BOUNDS");
886         _communitySwapFee = communitySwapFee;
887         _communityJoinFee = communityJoinFee;
888         _communityExitFee = communityExitFee;
889         _communityFeeReceiver = communityFeeReceiver;
890     }
891 
892     function setRestrictions(IPoolRestrictions restrictions)
893         external
894         _logs_
895         _lock_
896     {
897         _checkController();
898         _restrictions = restrictions;
899     }
900 
901     function setController(address manager)
902         external
903         _logs_
904         _lock_
905     {
906         _checkController();
907         _controller = manager;
908     }
909 
910     function setPublicSwap(bool public_)
911         external
912         _logs_
913         _lock_
914     {
915         _checkFinalized();
916         _checkController();
917         _publicSwap = public_;
918     }
919 
920     function finalize()
921         external
922         _logs_
923         _lock_
924     {
925         _checkController();
926         _checkFinalized();
927         require(_tokens.length >= MIN_BOUND_TOKENS, "MIN_TOKENS");
928 
929         _finalized = true;
930         _publicSwap = true;
931 
932         _mintPoolShare(INIT_POOL_SUPPLY);
933         _pushPoolShare(msg.sender, INIT_POOL_SUPPLY);
934     }
935 
936     function callVoting(address voting, bytes4 signature, bytes calldata args, uint value)
937         external
938         _logs_
939         _lock_
940     {
941         require(_restrictions.isVotingSignatureAllowed(voting, signature), "NOT_ALLOWED_SIG");
942         _checkController();
943 
944         (bool success, bytes memory data) = voting.call{ value: value }(abi.encodePacked(signature, args));
945         require(success, "NOT_SUCCESS");
946         emit LOG_CALL_VOTING(voting, success, signature, msg.data, data);
947     }
948 
949     function bind(address token, uint balance, uint denorm)
950         external
951         _logs_
952         // _lock_  Bind does not lock because it jumps to `rebind`, which does
953     {
954         _checkController();
955         require(!_records[token].bound, "IS_BOUND");
956         _checkFinalized();
957 
958         require(_tokens.length < MAX_BOUND_TOKENS, "MAX_TOKENS");
959 
960         _records[token] = Record({
961             bound: true,
962             index: _tokens.length,
963             denorm: 0,    // balance and denorm will be validated
964             balance: 0   // and set by `rebind`
965         });
966         _tokens.push(token);
967         rebind(token, balance, denorm);
968     }
969 
970     function rebind(address token, uint balance, uint denorm)
971         public
972         _logs_
973         _lock_
974     {
975 
976         _checkController();
977         _checkBound(token);
978         _checkFinalized();
979 
980         require(denorm >= MIN_WEIGHT && denorm <= MAX_WEIGHT, "WEIGHT_BOUNDS");
981         require(balance >= MIN_BALANCE, "MIN_BALANCE");
982 
983         // Adjust the denorm and totalWeight
984         uint oldWeight = _records[token].denorm;
985         if (denorm > oldWeight) {
986             _totalWeight = badd(_totalWeight, bsub(denorm, oldWeight));
987             require(_totalWeight <= MAX_TOTAL_WEIGHT, "MAX_TOTAL_WEIGHT");
988         } else if (denorm < oldWeight) {
989             _totalWeight = bsub(_totalWeight, bsub(oldWeight, denorm));
990         }        
991         _records[token].denorm = denorm;
992 
993         // Adjust the balance record and actual token balance
994         uint oldBalance = _records[token].balance;
995         _records[token].balance = balance;
996         if (balance > oldBalance) {
997             _pullUnderlying(token, msg.sender, bsub(balance, oldBalance));
998         } else if (balance < oldBalance) {
999             uint tokenBalanceWithdrawn = bsub(oldBalance, balance);
1000             _pushUnderlying(token, msg.sender, tokenBalanceWithdrawn);
1001         }
1002     }
1003 
1004     function unbind(address token)
1005         external
1006         _logs_
1007         _lock_
1008     {
1009 
1010         _checkController();
1011         _checkBound(token);
1012         _checkFinalized();
1013 
1014         uint tokenBalance = _records[token].balance;
1015 
1016         _totalWeight = bsub(_totalWeight, _records[token].denorm);
1017 
1018         // Swap the token-to-unbind with the last token,
1019         // then delete the last token
1020         uint index = _records[token].index;
1021         uint last = _tokens.length - 1;
1022         _tokens[index] = _tokens[last];
1023         _records[_tokens[index]].index = index;
1024         _tokens.pop();
1025         _records[token] = Record({
1026             bound: false,
1027             index: 0,
1028             denorm: 0,
1029             balance: 0
1030         });
1031 
1032         _pushUnderlying(token, msg.sender, tokenBalance);
1033     }
1034 
1035     // Absorb any tokens that have been sent to this contract into the pool
1036     function gulp(address token)
1037         external
1038         _logs_
1039         _lock_
1040     {
1041         _checkBound(token);
1042         _records[token].balance = IERC20(token).balanceOf(address(this));
1043     }
1044 
1045     function getSpotPrice(address tokenIn, address tokenOut)
1046         external view
1047         _viewlock_
1048         returns (uint spotPrice)
1049     {
1050         require(_records[tokenIn].bound && _records[tokenOut].bound, "NOT_BOUND");
1051         Record storage inRecord = _records[tokenIn];
1052         Record storage outRecord = _records[tokenOut];
1053         return calcSpotPrice(inRecord.balance, inRecord.denorm, outRecord.balance, outRecord.denorm, _swapFee);
1054     }
1055 
1056     function getSpotPriceSansFee(address tokenIn, address tokenOut)
1057         external view
1058         _viewlock_
1059         returns (uint spotPrice)
1060     {
1061         _checkBound(tokenIn);
1062         _checkBound(tokenOut);
1063         Record storage inRecord = _records[tokenIn];
1064         Record storage outRecord = _records[tokenOut];
1065         return calcSpotPrice(inRecord.balance, inRecord.denorm, outRecord.balance, outRecord.denorm, 0);
1066     }
1067 
1068     function joinPool(uint poolAmountOut, uint[] calldata maxAmountsIn)
1069         external
1070         _logs_
1071         _lock_
1072     {
1073         require(_finalized, "NOT_FINALIZED");
1074 
1075         uint poolTotal = totalSupply();
1076         uint ratio = bdiv(poolAmountOut, poolTotal);
1077         require(ratio != 0, "MATH_APPROX");
1078 
1079         for (uint i = 0; i < _tokens.length; i++) {
1080             address t = _tokens[i];
1081             uint bal = _records[t].balance;
1082             uint tokenAmountIn = bmul(ratio, bal);
1083             require(tokenAmountIn != 0, "MATH_APPROX");
1084             require(tokenAmountIn <= maxAmountsIn[i], "LIMIT_IN");
1085             _records[t].balance = badd(_records[t].balance, tokenAmountIn);
1086             emit LOG_JOIN(msg.sender, t, tokenAmountIn);
1087             _pullUnderlying(t, msg.sender, tokenAmountIn);
1088         }
1089 
1090         (uint poolAmountOutAfterFee, uint poolAmountOutFee) = calcAmountWithCommunityFee(
1091             poolAmountOut,
1092             _communityJoinFee,
1093             msg.sender
1094         );
1095 
1096         _mintPoolShare(poolAmountOut);
1097         _pushPoolShare(msg.sender, poolAmountOutAfterFee);
1098         _pushPoolShare(_communityFeeReceiver, poolAmountOutFee);
1099     }
1100 
1101     function exitPool(uint poolAmountIn, uint[] calldata minAmountsOut)
1102         external
1103         _logs_
1104         _lock_
1105     {
1106         require(_finalized, "NOT_FINALIZED");
1107 
1108         (uint poolAmountInAfterFee, uint poolAmountInFee) = calcAmountWithCommunityFee(
1109             poolAmountIn,
1110             _communityExitFee,
1111             msg.sender
1112         );
1113 
1114         uint poolTotal = totalSupply();
1115         uint ratio = bdiv(poolAmountInAfterFee, poolTotal);
1116         require(ratio != 0, "MATH_APPROX");
1117 
1118         _pullPoolShare(msg.sender, poolAmountIn);
1119         _pushPoolShare(_communityFeeReceiver, poolAmountInFee);
1120         _burnPoolShare(poolAmountInAfterFee);
1121 
1122         for (uint i = 0; i < _tokens.length; i++) {
1123             address t = _tokens[i];
1124             uint bal = _records[t].balance;
1125             uint tokenAmountOut = bmul(ratio, bal);
1126             require(tokenAmountOut != 0, "MATH_APPROX");
1127             require(tokenAmountOut >= minAmountsOut[i], "LIMIT_OUT");
1128             _records[t].balance = bsub(_records[t].balance, tokenAmountOut);
1129             emit LOG_EXIT(msg.sender, t, tokenAmountOut);
1130             _pushUnderlying(t, msg.sender, tokenAmountOut);
1131         }
1132 
1133     }
1134 
1135 
1136     function swapExactAmountIn(
1137         address tokenIn,
1138         uint tokenAmountIn,
1139         address tokenOut,
1140         uint minAmountOut,
1141         uint maxPrice
1142     )
1143         external
1144         _logs_
1145         _lock_
1146         returns (uint tokenAmountOut, uint spotPriceAfter)
1147     {
1148         _checkBound(tokenIn);
1149         _checkBound(tokenOut);
1150         require(_publicSwap, "NOT_PUBLIC");
1151 
1152         Record storage inRecord = _records[address(tokenIn)];
1153         Record storage outRecord = _records[address(tokenOut)];
1154 
1155         uint spotPriceBefore = calcSpotPrice(
1156                                     inRecord.balance,
1157                                     inRecord.denorm,
1158                                     outRecord.balance,
1159                                     outRecord.denorm,
1160                                     _swapFee
1161                                 );
1162         require(spotPriceBefore <= maxPrice, "LIMIT_PRICE");
1163 
1164         (uint tokenAmountInAfterFee, uint tokenAmountInFee) = calcAmountWithCommunityFee(
1165                                                                 tokenAmountIn,
1166                                                                 _communitySwapFee,
1167                                                                 msg.sender
1168                                                             );
1169 
1170         require(tokenAmountInAfterFee <= bmul(inRecord.balance, MAX_IN_RATIO), "MAX_IN_RATIO");
1171 
1172         tokenAmountOut = calcOutGivenIn(
1173                             inRecord.balance,
1174                             inRecord.denorm,
1175                             outRecord.balance,
1176                             outRecord.denorm,
1177                             tokenAmountInAfterFee,
1178                             _swapFee
1179                         );
1180         require(tokenAmountOut >= minAmountOut, "LIMIT_OUT");
1181 
1182         inRecord.balance = badd(inRecord.balance, tokenAmountInAfterFee);
1183         outRecord.balance = bsub(outRecord.balance, tokenAmountOut);
1184 
1185         spotPriceAfter = calcSpotPrice(
1186                                 inRecord.balance,
1187                                 inRecord.denorm,
1188                                 outRecord.balance,
1189                                 outRecord.denorm,
1190                                 _swapFee
1191                             );
1192         require(
1193             spotPriceAfter >= spotPriceBefore &&
1194             spotPriceBefore <= bdiv(tokenAmountInAfterFee, tokenAmountOut),
1195             "MATH_APPROX"
1196         );
1197         require(spotPriceAfter <= maxPrice, "LIMIT_PRICE");
1198 
1199         emit LOG_SWAP(msg.sender, tokenIn, tokenOut, tokenAmountInAfterFee, tokenAmountOut);
1200 
1201         _pullCommunityFeeUnderlying(tokenIn, msg.sender, tokenAmountInFee);
1202         _pullUnderlying(tokenIn, msg.sender, tokenAmountInAfterFee);
1203         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1204 
1205         return (tokenAmountOut, spotPriceAfter);
1206     }
1207 
1208     function swapExactAmountOut(
1209         address tokenIn,
1210         uint maxAmountIn,
1211         address tokenOut,
1212         uint tokenAmountOut,
1213         uint maxPrice
1214     )
1215         external
1216         _logs_
1217         _lock_ 
1218         returns (uint tokenAmountIn, uint spotPriceAfter)
1219     {
1220         _checkBound(tokenIn);
1221         _checkBound(tokenOut);
1222         require(_publicSwap, "NOT_PUBLIC");
1223 
1224         Record storage inRecord = _records[address(tokenIn)];
1225         Record storage outRecord = _records[address(tokenOut)];
1226 
1227         require(tokenAmountOut <= bmul(outRecord.balance, MAX_OUT_RATIO), "OUT_RATIO");
1228 
1229         uint spotPriceBefore = calcSpotPrice(
1230                                     inRecord.balance,
1231                                     inRecord.denorm,
1232                                     outRecord.balance,
1233                                     outRecord.denorm,
1234                                     _swapFee
1235                                 );
1236         require(spotPriceBefore <= maxPrice, "LIMIT_PRICE");
1237 
1238         (uint tokenAmountOutAfterFee, uint tokenAmountOutFee) = calcAmountWithCommunityFee(
1239             tokenAmountOut,
1240             _communitySwapFee,
1241             msg.sender
1242         );
1243 
1244         tokenAmountIn = calcInGivenOut(
1245                             inRecord.balance,
1246                             inRecord.denorm,
1247                             outRecord.balance,
1248                             outRecord.denorm,
1249                             tokenAmountOut,
1250                             _swapFee
1251                         );
1252         require(tokenAmountIn <= maxAmountIn, "LIMIT_IN");
1253 
1254         inRecord.balance = badd(inRecord.balance, tokenAmountIn);
1255         outRecord.balance = bsub(outRecord.balance, tokenAmountOut);
1256 
1257         spotPriceAfter = calcSpotPrice(
1258                                 inRecord.balance,
1259                                 inRecord.denorm,
1260                                 outRecord.balance,
1261                                 outRecord.denorm,
1262                                 _swapFee
1263                             );
1264         require(
1265             spotPriceAfter >= spotPriceBefore &&
1266             spotPriceBefore <= bdiv(tokenAmountIn, tokenAmountOutAfterFee),
1267             "MATH_APPROX"
1268         );
1269         require(spotPriceAfter <= maxPrice, "LIMIT_PRICE");
1270 
1271         emit LOG_SWAP(msg.sender, tokenIn, tokenOut, tokenAmountIn, tokenAmountOutAfterFee);
1272 
1273         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1274         _pushUnderlying(tokenOut, msg.sender, tokenAmountOutAfterFee);
1275         _pushUnderlying(tokenOut, _communityFeeReceiver, tokenAmountOutFee);
1276 
1277         return (tokenAmountIn, spotPriceAfter);
1278     }
1279 
1280 
1281     function joinswapExternAmountIn(address tokenIn, uint tokenAmountIn, uint minPoolAmountOut)
1282         external
1283         _logs_
1284         _lock_
1285         returns (uint poolAmountOut)
1286 
1287     {        
1288         require(_finalized, "NOT_FINALIZED");
1289         _checkBound(tokenIn);
1290         require(tokenAmountIn <= bmul(_records[tokenIn].balance, MAX_IN_RATIO), "MAX_IN_RATIO");
1291 
1292         (uint tokenAmountInAfterFee, uint tokenAmountInFee) = calcAmountWithCommunityFee(
1293             tokenAmountIn,
1294             _communityJoinFee,
1295             msg.sender
1296         );
1297 
1298         Record storage inRecord = _records[tokenIn];
1299 
1300         poolAmountOut = calcPoolOutGivenSingleIn(
1301                             inRecord.balance,
1302                             inRecord.denorm,
1303                             _totalSupply,
1304                             _totalWeight,
1305                             tokenAmountInAfterFee,
1306                             _swapFee
1307                         );
1308 
1309         require(poolAmountOut >= minPoolAmountOut, "LIMIT_OUT");
1310 
1311         inRecord.balance = badd(inRecord.balance, tokenAmountInAfterFee);
1312 
1313         emit LOG_JOIN(msg.sender, tokenIn, tokenAmountInAfterFee);
1314 
1315         _mintPoolShare(poolAmountOut);
1316         _pushPoolShare(msg.sender, poolAmountOut);
1317         _pullCommunityFeeUnderlying(tokenIn, msg.sender, tokenAmountInFee);
1318         _pullUnderlying(tokenIn, msg.sender, tokenAmountInAfterFee);
1319 
1320         return poolAmountOut;
1321     }
1322 
1323     function joinswapPoolAmountOut(address tokenIn, uint poolAmountOut, uint maxAmountIn)
1324         external
1325         _logs_
1326         _lock_
1327         returns (uint tokenAmountIn)
1328     {
1329         require(_finalized, "NOT_FINALIZED");
1330         _checkBound(tokenIn);
1331 
1332         Record storage inRecord = _records[tokenIn];
1333 
1334         (uint poolAmountOutAfterFee, uint poolAmountOutFee) = calcAmountWithCommunityFee(
1335             poolAmountOut,
1336             _communityJoinFee,
1337             msg.sender
1338         );
1339 
1340         tokenAmountIn = calcSingleInGivenPoolOut(
1341                             inRecord.balance,
1342                             inRecord.denorm,
1343                             _totalSupply,
1344                             _totalWeight,
1345                             poolAmountOut,
1346                             _swapFee
1347                         );
1348 
1349         require(tokenAmountIn != 0, "MATH_APPROX");
1350         require(tokenAmountIn <= maxAmountIn, "LIMIT_IN");
1351 
1352         require(tokenAmountIn <= bmul(_records[tokenIn].balance, MAX_IN_RATIO), "MAX_IN_RATIO");
1353 
1354         inRecord.balance = badd(inRecord.balance, tokenAmountIn);
1355 
1356         emit LOG_JOIN(msg.sender, tokenIn, tokenAmountIn);
1357 
1358         _mintPoolShare(poolAmountOut);
1359         _pushPoolShare(msg.sender, poolAmountOutAfterFee);
1360         _pushPoolShare(_communityFeeReceiver, poolAmountOutFee);
1361         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1362 
1363         return tokenAmountIn;
1364     }
1365 
1366     function exitswapPoolAmountIn(address tokenOut, uint poolAmountIn, uint minAmountOut)
1367         external
1368         _logs_
1369         _lock_
1370         returns (uint tokenAmountOut)
1371     {
1372         require(_finalized, "NOT_FINALIZED");
1373         _checkBound(tokenOut);
1374 
1375         Record storage outRecord = _records[tokenOut];
1376 
1377         tokenAmountOut = calcSingleOutGivenPoolIn(
1378                             outRecord.balance,
1379                             outRecord.denorm,
1380                             _totalSupply,
1381                             _totalWeight,
1382                             poolAmountIn,
1383                             _swapFee
1384                         );
1385 
1386         require(tokenAmountOut >= minAmountOut, "LIMIT_OUT");
1387         
1388         require(tokenAmountOut <= bmul(_records[tokenOut].balance, MAX_OUT_RATIO), "OUT_RATIO");
1389 
1390         outRecord.balance = bsub(outRecord.balance, tokenAmountOut);
1391 
1392         (uint tokenAmountOutAfterFee, uint tokenAmountOutFee) = calcAmountWithCommunityFee(
1393             tokenAmountOut,
1394             _communityExitFee,
1395             msg.sender
1396         );
1397 
1398         emit LOG_EXIT(msg.sender, tokenOut, tokenAmountOutAfterFee);
1399 
1400         _pullPoolShare(msg.sender, poolAmountIn);
1401         _burnPoolShare(poolAmountIn);
1402         _pushUnderlying(tokenOut, msg.sender, tokenAmountOutAfterFee);
1403         _pushUnderlying(tokenOut, _communityFeeReceiver, tokenAmountOutFee);
1404 
1405         return tokenAmountOut;
1406     }
1407 
1408     function exitswapExternAmountOut(address tokenOut, uint tokenAmountOut, uint maxPoolAmountIn)
1409         external
1410         _logs_
1411         _lock_
1412         returns (uint poolAmountIn)
1413     {
1414         require(_finalized, "NOT_FINALIZED");
1415         _checkBound(tokenOut);
1416         require(tokenAmountOut <= bmul(_records[tokenOut].balance, MAX_OUT_RATIO), "OUT_RATIO");
1417 
1418         Record storage outRecord = _records[tokenOut];
1419 
1420         (uint tokenAmountOutAfterFee, uint tokenAmountOutFee) = calcAmountWithCommunityFee(
1421             tokenAmountOut,
1422             _communityExitFee,
1423             msg.sender
1424         );
1425 
1426         poolAmountIn = calcPoolInGivenSingleOut(
1427                             outRecord.balance,
1428                             outRecord.denorm,
1429                             _totalSupply,
1430                             _totalWeight,
1431                             tokenAmountOut,
1432                             _swapFee
1433                         );
1434 
1435         require(poolAmountIn != 0, "MATH_APPROX");
1436         require(poolAmountIn <= maxPoolAmountIn, "LIMIT_IN");
1437 
1438         outRecord.balance = bsub(outRecord.balance, tokenAmountOut);
1439 
1440         emit LOG_EXIT(msg.sender, tokenOut, tokenAmountOutAfterFee);
1441 
1442         _pullPoolShare(msg.sender, poolAmountIn);
1443         _burnPoolShare(poolAmountIn);
1444         _pushUnderlying(tokenOut, msg.sender, tokenAmountOutAfterFee);
1445         _pushUnderlying(tokenOut, _communityFeeReceiver, tokenAmountOutFee);
1446 
1447         return poolAmountIn;
1448     }
1449 
1450 
1451     // ==
1452     // 'Underlying' token-manipulation functions make external calls but are NOT locked
1453     // You must `_lock_` or otherwise ensure reentry-safety
1454 
1455     function _pullUnderlying(address erc20, address from, uint amount)
1456         internal
1457     {
1458         bool xfer = IERC20(erc20).transferFrom(from, address(this), amount);
1459         require(xfer, "ERC20_FALSE");
1460     }
1461 
1462     function _pushUnderlying(address erc20, address to, uint amount)
1463         internal
1464     {
1465         bool xfer = IERC20(erc20).transfer(to, amount);
1466         require(xfer, "ERC20_FALSE");
1467     }
1468 
1469     function _pullCommunityFeeUnderlying(address erc20, address from, uint amount)
1470         internal
1471     {
1472         bool xfer = IERC20(erc20).transferFrom(from, _communityFeeReceiver, amount);
1473         require(xfer, "ERC20_FALSE");
1474     }
1475 
1476     function _pullPoolShare(address from, uint amount)
1477         internal
1478     {
1479         _pull(from, amount);
1480     }
1481 
1482     function _pushPoolShare(address to, uint amount)
1483         internal
1484     {
1485         _push(to, amount);
1486     }
1487 
1488     function _mintPoolShare(uint amount)
1489         internal
1490     {
1491         if(address(_restrictions) != address(0)) {
1492             uint maxTotalSupply = _restrictions.getMaxTotalSupply(address(this));
1493             require(badd(_totalSupply, amount) <= maxTotalSupply, "MAX_SUPPLY");
1494         }
1495         _mint(amount);
1496     }
1497 
1498     function _burnPoolShare(uint amount)
1499         internal
1500     {
1501         _burn(amount);
1502     }
1503 
1504     function _checkBound(address token)
1505         internal view
1506     {
1507         require(_records[token].bound, "NOT_BOUND");
1508     }
1509 
1510     function _checkController()
1511         internal view
1512     {
1513         require(msg.sender == _controller, "NOT_CONTROLLER");
1514     }
1515 
1516     function _checkFinalized()
1517         internal view
1518     {
1519         require(!_finalized, "IS_FINALIZED");
1520     }
1521 
1522     function calcAmountWithCommunityFee(
1523         uint tokenAmountIn,
1524         uint communityFee,
1525         address operator
1526     )
1527         public view
1528         returns (uint tokenAmountInAfterFee, uint tokenAmountFee)
1529     {
1530         if (address(_restrictions) != address(0) && _restrictions.isWithoutFee(operator)) {
1531             return (tokenAmountIn, 0);
1532         }
1533         uint adjustedIn = bsub(BONE, communityFee);
1534         tokenAmountInAfterFee = bmul(tokenAmountIn, adjustedIn);
1535         uint tokenAmountFee = bsub(tokenAmountIn, tokenAmountInAfterFee);
1536         return (tokenAmountInAfterFee, tokenAmountFee);
1537     }
1538 }