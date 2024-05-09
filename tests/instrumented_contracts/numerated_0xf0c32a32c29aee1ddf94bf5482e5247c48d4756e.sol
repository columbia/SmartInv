1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 // This program is distributed in the hope that it will be useful,
10 // but WITHOUT ANY WARRANTY; without even the implied warranty of
11 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
12 // GNU General Public License for more details.
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 library BConst {
16     uint public constant BONE                     = 10**18;
17 
18     uint public constant MIN_BOUND_TOKENS         = 2;
19     uint public constant MAX_BOUND_TOKENS         = 8;
20 
21     uint public constant DEFAULT_FEE              = BONE * 3 / 1000; // 0.3%
22     uint public constant MIN_FEE                  = BONE / 10**6;
23     uint public constant MAX_FEE                  = BONE / 10;
24 
25     uint public constant DEFAULT_COLLECTED_FEE    = BONE / 2000; // 0.05%
26     uint public constant MAX_COLLECTED_FEE        = BONE / 200; // 0.5%
27 
28     uint public constant DEFAULT_EXIT_FEE         = 0;
29     uint public constant MAX_EXIT_FEE             = BONE / 1000; // 0.1%
30 
31     uint public constant MIN_WEIGHT               = BONE;
32     uint public constant MAX_WEIGHT               = BONE * 50;
33     uint public constant MAX_TOTAL_WEIGHT         = BONE * 50;
34     uint public constant MIN_BALANCE              = BONE / 10**12;
35 
36     uint public constant DEFAULT_INIT_POOL_SUPPLY = BONE * 100;
37     uint public constant MIN_INIT_POOL_SUPPLY     = BONE / 1000;
38     uint public constant MAX_INIT_POOL_SUPPLY     = BONE * 10**18;
39 
40     uint public constant MIN_BPOW_BASE            = 1 wei;
41     uint public constant MAX_BPOW_BASE            = (2 * BONE) - 1 wei;
42     uint public constant BPOW_PRECISION           = BONE / 10**10;
43 
44     uint public constant MAX_IN_RATIO             = BONE / 2;
45     uint public constant MAX_OUT_RATIO            = (BONE / 3) + 1 wei;
46 }
47 
48 // This program is free software: you can redistribute it and/or modify
49 // it under the terms of the GNU General Public License as published by
50 // the Free Software Foundation, either version 3 of the License, or
51 // (at your option) any later version.
52 // This program is distributed in the hope that it will be useful,
53 // but WITHOUT ANY WARRANTY; without even the implied warranty of
54 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
55 // GNU General Public License for more details.
56 // You should have received a copy of the GNU General Public License
57 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
58 contract BNum {
59 
60     function btoi(uint a)
61         internal pure 
62         returns (uint)
63     {
64         return a / BConst.BONE;
65     }
66 
67     function bfloor(uint a)
68         internal pure
69         returns (uint)
70     {
71         return btoi(a) * BConst.BONE;
72     }
73 
74     function badd(uint a, uint b)
75         internal pure
76         returns (uint)
77     {
78         uint c = a + b;
79         require(c >= a, "add overflow");
80         return c;
81     }
82 
83     function bsub(uint a, uint b)
84         internal pure
85         returns (uint)
86     {
87         (uint c, bool flag) = bsubSign(a, b);
88         require(!flag, "sub underflow");
89         return c;
90     }
91 
92     function bsubSign(uint a, uint b)
93         internal pure
94         returns (uint, bool)
95     {
96         if (a >= b) {
97             return (a - b, false);
98         } else {
99             return (b - a, true);
100         }
101     }
102 
103     function bmul(uint a, uint b)
104         internal pure
105         returns (uint)
106     {
107         uint c0 = a * b;
108         require(a == 0 || c0 / a == b, "mul overflow");
109         uint c1 = c0 + (BConst.BONE / 2);
110         require(c1 >= c0, "mul overflow");
111         uint c2 = c1 / BConst.BONE;
112         return c2;
113     }
114 
115     function bdiv(uint a, uint b)
116         internal pure
117         returns (uint)
118     {
119         require(b != 0, "div by 0");
120         uint c0 = a * BConst.BONE;
121         require(a == 0 || c0 / a == BConst.BONE, "div internal"); // bmul overflow
122         uint c1 = c0 + (b / 2);
123         require(c1 >= c0, "div internal"); //  badd require
124         uint c2 = c1 / b;
125         return c2;
126     }
127 
128     // DSMath.wpow
129     function bpowi(uint a, uint n)
130         internal pure
131         returns (uint)
132     {
133         uint z = n % 2 != 0 ? a : BConst.BONE;
134 
135         for (n /= 2; n != 0; n /= 2) {
136             a = bmul(a, a);
137 
138             if (n % 2 != 0) {
139                 z = bmul(z, a);
140             }
141         }
142         return z;
143     }
144 
145     // Compute b^(e.w) by splitting it into (b^e)*(b^0.w).
146     // Use `bpowi` for `b^e` and `bpowK` for k iterations
147     // of approximation of b^0.w
148     function bpow(uint base, uint exp)
149         internal pure
150         returns (uint)
151     {
152         require(base >= BConst.MIN_BPOW_BASE, "base too low");
153         require(base <= BConst.MAX_BPOW_BASE, "base too high");
154 
155         uint whole  = bfloor(exp);   
156         uint remain = bsub(exp, whole);
157 
158         uint wholePow = bpowi(base, btoi(whole));
159 
160         if (remain == 0) {
161             return wholePow;
162         }
163 
164         uint partialResult = bpowApprox(base, remain, BConst.BPOW_PRECISION);
165         return bmul(wholePow, partialResult);
166     }
167 
168     function bpowApprox(uint base, uint exp, uint precision)
169         internal pure
170         returns (uint)
171     {
172         // term 0:
173         uint a     = exp;
174         (uint x, bool xneg)  = bsubSign(base, BConst.BONE);
175         uint term = BConst.BONE;
176         uint sum   = term;
177         bool negative = false;
178 
179 
180         // term(k) = numer / denom 
181         //         = (product(a - i - 1, i=1-->k) * x^k) / (k!)
182         // each iteration, multiply previous term by (a-(k-1)) * x / k
183         // continue until term is less than precision
184         for (uint i = 1; term >= precision; i++) {
185             uint bigK = i * BConst.BONE;
186             (uint c, bool cneg) = bsubSign(a, bsub(bigK, BConst.BONE));
187             term = bmul(term, bmul(c, x));
188             term = bdiv(term, bigK);
189             if (term == 0) break;
190 
191             if (xneg) negative = !negative;
192             if (cneg) negative = !negative;
193             if (negative) {
194                 sum = bsub(sum, term);
195             } else {
196                 sum = badd(sum, term);
197             }
198         }
199 
200         return sum;
201     }
202 
203 }
204 
205 // This program is free software: you can redistribute it and/or modify
206 // it under the terms of the GNU General Public License as published by
207 // the Free Software Foundation, either version 3 of the License, or
208 // (at your option) any later version.
209 // This program is distributed in the hope that it will be useful,
210 // but WITHOUT ANY WARRANTY; without even the implied warranty of
211 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
212 // GNU General Public License for more details.
213 // You should have received a copy of the GNU General Public License
214 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
215 // Highly opinionated token implementation
216 interface IERC20 {
217     event Approval(address indexed src, address indexed dst, uint amt);
218     event Transfer(address indexed src, address indexed dst, uint amt);
219 
220     function totalSupply() external view returns (uint);
221     function balanceOf(address whom) external view returns (uint);
222     function allowance(address src, address dst) external view returns (uint);
223 
224     function approve(address dst, uint amt) external returns (bool);
225     function transfer(address dst, uint amt) external returns (bool);
226     function transferFrom(
227         address src, address dst, uint amt
228     ) external returns (bool);
229 }
230 
231 contract BTokenBase is BNum {
232 
233     mapping(address => uint)                   internal _balance;
234     mapping(address => mapping(address=>uint)) internal _allowance;
235     uint internal _totalSupply;
236 
237     event Approval(address indexed src, address indexed dst, uint amt);
238     event Transfer(address indexed src, address indexed dst, uint amt);
239 
240     function _mint(uint amt) internal {
241         _balance[address(this)] = badd(_balance[address(this)], amt);
242         _totalSupply = badd(_totalSupply, amt);
243         emit Transfer(address(0), address(this), amt);
244     }
245 
246     function _burn(uint amt) internal {
247         require(_balance[address(this)] >= amt, "!bal");
248         _balance[address(this)] = bsub(_balance[address(this)], amt);
249         _totalSupply = bsub(_totalSupply, amt);
250         emit Transfer(address(this), address(0), amt);
251     }
252 
253     function _move(address src, address dst, uint amt) internal {
254         require(_balance[src] >= amt, "!bal");
255         _balance[src] = bsub(_balance[src], amt);
256         _balance[dst] = badd(_balance[dst], amt);
257         emit Transfer(src, dst, amt);
258     }
259 
260     function _push(address to, uint amt) internal {
261         _move(address(this), to, amt);
262     }
263 
264     function _pull(address from, uint amt) internal {
265         _move(from, address(this), amt);
266     }
267 }
268 
269 contract BToken is BTokenBase, IERC20 {
270     string  private _name     = "Value Liquidity Provider";
271     string  private _symbol   = "VLP";
272     uint8   private _decimals = 18;
273 
274     function name() public view returns (string memory) {
275         return _name;
276     }
277 
278     function symbol() public view returns (string memory) {
279         return _symbol;
280     }
281 
282     function decimals() public view returns(uint8) {
283         return _decimals;
284     }
285 
286     function allowance(address src, address dst) external override view returns (uint) {
287         return _allowance[src][dst];
288     }
289 
290     function balanceOf(address whom) external override view returns (uint) {
291         return _balance[whom];
292     }
293 
294     function totalSupply() public override view returns (uint) {
295         return _totalSupply;
296     }
297 
298     function approve(address dst, uint amt) external override returns (bool) {
299         _allowance[msg.sender][dst] = amt;
300         emit Approval(msg.sender, dst, amt);
301         return true;
302     }
303 
304     function increaseApproval(address dst, uint amt) external returns (bool) {
305         _allowance[msg.sender][dst] = badd(_allowance[msg.sender][dst], amt);
306         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
307         return true;
308     }
309 
310     function decreaseApproval(address dst, uint amt) external returns (bool) {
311         uint oldValue = _allowance[msg.sender][dst];
312         if (amt > oldValue) {
313             _allowance[msg.sender][dst] = 0;
314         } else {
315             _allowance[msg.sender][dst] = bsub(oldValue, amt);
316         }
317         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
318         return true;
319     }
320 
321     function transfer(address dst, uint amt) external override returns (bool) {
322         _move(msg.sender, dst, amt);
323         return true;
324     }
325 
326     function transferFrom(address src, address dst, uint amt) external override returns (bool) {
327         require(msg.sender == src || amt <= _allowance[src][msg.sender], "!spender");
328         _move(src, dst, amt);
329         if (msg.sender != src && _allowance[src][msg.sender] != uint256(-1)) {
330             _allowance[src][msg.sender] = bsub(_allowance[src][msg.sender], amt);
331             emit Approval(msg.sender, dst, _allowance[src][msg.sender]);
332         }
333         return true;
334     }
335 }
336 
337 // This program is free software: you can redistribute it and/or modify
338 // it under the terms of the GNU General Public License as published by
339 // the Free Software Foundation, either version 3 of the License, or
340 // (at your option) any later version.
341 // This program is distributed in the hope that it will be useful,
342 // but WITHOUT ANY WARRANTY; without even the implied warranty of
343 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
344 // GNU General Public License for more details.
345 // You should have received a copy of the GNU General Public License
346 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
347 contract BMath is BNum {
348     /**********************************************************************************************
349     // calcSpotPrice                                                                             //
350     // sP = spotPrice                                                                            //
351     // bI = tokenBalanceIn                ( bI / wI )         1                                  //
352     // bO = tokenBalanceOut         sP =  -----------  *  ----------                             //
353     // wI = tokenWeightIn                 ( bO / wO )     ( 1 - sF )                             //
354     // wO = tokenWeightOut                                                                       //
355     // sF = swapFee (+ collectedFee)                                                             //
356     **********************************************************************************************/
357     function calcSpotPrice(
358         uint tokenBalanceIn,
359         uint tokenWeightIn,
360         uint tokenBalanceOut,
361         uint tokenWeightOut,
362         uint swapFee
363     )
364         public pure
365         returns (uint spotPrice)
366     {
367         uint numer = bdiv(tokenBalanceIn, tokenWeightIn);
368         uint denom = bdiv(tokenBalanceOut, tokenWeightOut);
369         uint ratio = bdiv(numer, denom);
370         uint scale = bdiv(BConst.BONE, bsub(BConst.BONE, swapFee));
371         return  (spotPrice = bmul(ratio, scale));
372     }
373 
374     /**********************************************************************************************
375     // calcOutGivenIn                                                                            //
376     // aO = tokenAmountOut                                                                       //
377     // bO = tokenBalanceOut                                                                      //
378     // bI = tokenBalanceIn              /      /            bI             \    (wI / wO) \      //
379     // aI = tokenAmountIn    aO = bO * |  1 - | --------------------------  | ^            |     //
380     // wI = tokenWeightIn               \      \ ( bI + ( aI * ( 1 - sF )) /              /      //
381     // wO = tokenWeightOut                                                                       //
382     // sF = swapFee (+ collectedFee)                                                             //
383     **********************************************************************************************/
384     function calcOutGivenIn(
385         uint tokenBalanceIn,
386         uint tokenWeightIn,
387         uint tokenBalanceOut,
388         uint tokenWeightOut,
389         uint tokenAmountIn,
390         uint swapFee
391     )
392         public pure
393         returns (uint tokenAmountOut)
394     {
395         uint weightRatio = bdiv(tokenWeightIn, tokenWeightOut);
396         uint adjustedIn = bsub(BConst.BONE, swapFee);
397         adjustedIn = bmul(tokenAmountIn, adjustedIn);
398         uint y = bdiv(tokenBalanceIn, badd(tokenBalanceIn, adjustedIn));
399         uint foo = bpow(y, weightRatio);
400         uint bar = bsub(BConst.BONE, foo);
401         tokenAmountOut = bmul(tokenBalanceOut, bar);
402         return tokenAmountOut;
403     }
404 
405     /**********************************************************************************************
406     // calcInGivenOut                                                                            //
407     // aI = tokenAmountIn                                                                        //
408     // bO = tokenBalanceOut               /  /     bO      \    (wO / wI)      \                 //
409     // bI = tokenBalanceIn          bI * |  | ------------  | ^            - 1  |                //
410     // aO = tokenAmountOut    aI =        \  \ ( bO - aO ) /                   /                 //
411     // wI = tokenWeightIn           --------------------------------------------                 //
412     // wO = tokenWeightOut                          ( 1 - sF )                                   //
413     // sF = swapFee (+ collectedFee)                                                             //
414     **********************************************************************************************/
415     function calcInGivenOut(
416         uint tokenBalanceIn,
417         uint tokenWeightIn,
418         uint tokenBalanceOut,
419         uint tokenWeightOut,
420         uint tokenAmountOut,
421         uint swapFee
422     )
423         public pure
424         returns (uint tokenAmountIn)
425     {
426         uint weightRatio = bdiv(tokenWeightOut, tokenWeightIn);
427         uint diff = bsub(tokenBalanceOut, tokenAmountOut);
428         uint y = bdiv(tokenBalanceOut, diff);
429         uint foo = bpow(y, weightRatio);
430         foo = bsub(foo, BConst.BONE);
431         tokenAmountIn = bsub(BConst.BONE, swapFee);
432         tokenAmountIn = bdiv(bmul(tokenBalanceIn, foo), tokenAmountIn);
433         return tokenAmountIn;
434     }
435 
436     /**********************************************************************************************
437     // calcPoolOutGivenSingleIn                                                                  //
438     // pAo = poolAmountOut         /                                              \              //
439     // tAi = tokenAmountIn        ///      /     //    wI \      \\       \     wI \             //
440     // wI = tokenWeightIn        //| tAi *| 1 - || 1 - --  | * sF || + tBi \    --  \            //
441     // tW = totalWeight     pAo=||  \      \     \\    tW /      //         | ^ tW   | * pS - pS //
442     // tBi = tokenBalanceIn      \\  ------------------------------------- /        /            //
443     // pS = poolSupply            \\                    tBi               /        /             //
444     // sF = swapFee (+ collectedFee)\                                              /              //
445     **********************************************************************************************/
446     function calcPoolOutGivenSingleIn(
447         uint tokenBalanceIn,
448         uint tokenWeightIn,
449         uint poolSupply,
450         uint totalWeight,
451         uint tokenAmountIn,
452         uint swapFee
453     )
454         public pure
455         returns (uint poolAmountOut)
456     {
457         // @dev Charge the trading fee for the proportion of tokenAi
458         // which is implicitly traded to the other pool tokens.
459         // That proportion is (1- weightTokenIn)
460         // tokenAiAfterFee = tAi * (1 - (1-weightTi) * poolFee);
461         uint normalizedWeight = bdiv(tokenWeightIn, totalWeight);
462         uint zaz = bmul(bsub(BConst.BONE, normalizedWeight), swapFee);
463         uint tokenAmountInAfterFee = bmul(tokenAmountIn, bsub(BConst.BONE, zaz));
464 
465         uint newTokenBalanceIn = badd(tokenBalanceIn, tokenAmountInAfterFee);
466         uint tokenInRatio = bdiv(newTokenBalanceIn, tokenBalanceIn);
467 
468         // uint newPoolSupply = (ratioTi ^ weightTi) * poolSupply;
469         uint poolRatio = bpow(tokenInRatio, normalizedWeight);
470         uint newPoolSupply = bmul(poolRatio, poolSupply);
471         poolAmountOut = bsub(newPoolSupply, poolSupply);
472         return poolAmountOut;
473     }
474 
475     /**********************************************************************************************
476     // calcSingleInGivenPoolOut                                                                  //
477     // tAi = tokenAmountIn              //(pS + pAo)\     /    1    \\                           //
478     // pS = poolSupply                 || ---------  | ^ | --------- || * bI - bI                //
479     // pAo = poolAmountOut              \\    pS    /     \(wI / tW)//                           //
480     // bI = balanceIn          tAi =  --------------------------------------------               //
481     // wI = weightIn                              /      wI  \                                   //
482     // tW = totalWeight                          |  1 - ----  |  * sF                            //
483     // sF = swapFee (+ collectedFee)              \      tW  /                                   //
484     **********************************************************************************************/
485     function calcSingleInGivenPoolOut(
486         uint tokenBalanceIn,
487         uint tokenWeightIn,
488         uint poolSupply,
489         uint totalWeight,
490         uint poolAmountOut,
491         uint swapFee
492     )
493         public pure
494         returns (uint tokenAmountIn)
495     {
496         uint normalizedWeight = bdiv(tokenWeightIn, totalWeight);
497         uint newPoolSupply = badd(poolSupply, poolAmountOut);
498         uint poolRatio = bdiv(newPoolSupply, poolSupply);
499       
500         //uint newBalTi = poolRatio^(1/weightTi) * balTi;
501         uint boo = bdiv(BConst.BONE, normalizedWeight);
502         uint tokenInRatio = bpow(poolRatio, boo);
503         uint newTokenBalanceIn = bmul(tokenInRatio, tokenBalanceIn);
504         uint tokenAmountInAfterFee = bsub(newTokenBalanceIn, tokenBalanceIn);
505         // Do reverse order of fees charged in joinswap_ExternAmountIn, this way 
506         //     ``` pAo == joinswap_ExternAmountIn(Ti, joinswap_PoolAmountOut(pAo, Ti)) ```
507         //uint tAi = tAiAfterFee / (1 - (1-weightTi) * swapFee) ;
508         uint zar = bmul(bsub(BConst.BONE, normalizedWeight), swapFee);
509         tokenAmountIn = bdiv(tokenAmountInAfterFee, bsub(BConst.BONE, zar));
510         return tokenAmountIn;
511     }
512 
513     /**********************************************************************************************
514     // calcSingleOutGivenPoolIn                                                                  //
515     // tAo = tokenAmountOut            /      /                                             \\   //
516     // bO = tokenBalanceOut           /      // pS - (pAi * (1 - eF)) \     /    1    \      \\  //
517     // pAi = poolAmountIn            | bO - || ----------------------- | ^ | --------- | * b0 || //
518     // ps = poolSupply                \      \\          pS           /     \(wO / tW)/      //  //
519     // wI = tokenWeightIn      tAo =   \      \                                             //   //
520     // tW = totalWeight                    /     /      wO \       \                             //
521     // sF = swapFee (+ collectedFee)   *  | 1 - |  1 - ---- | * sF  |                            //
522     // eF = exitFee                        \     \      tW /       /                             //
523     **********************************************************************************************/
524     function calcSingleOutGivenPoolIn(
525         uint tokenBalanceOut,
526         uint tokenWeightOut,
527         uint poolSupply,
528         uint totalWeight,
529         uint poolAmountIn,
530         uint swapFee,
531         uint exitFee
532     )
533         public pure
534         returns (uint tokenAmountOut)
535     {
536         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
537         // charge exit fee on the pool token side
538         // pAiAfterExitFee = pAi*(1-exitFee)
539         uint poolAmountInAfterExitFee = bmul(poolAmountIn, bsub(BConst.BONE, exitFee));
540         uint newPoolSupply = bsub(poolSupply, poolAmountInAfterExitFee);
541         uint poolRatio = bdiv(newPoolSupply, poolSupply);
542      
543         // newBalTo = poolRatio^(1/weightTo) * balTo;
544         uint tokenOutRatio = bpow(poolRatio, bdiv(BConst.BONE, normalizedWeight));
545         uint newTokenBalanceOut = bmul(tokenOutRatio, tokenBalanceOut);
546 
547         uint tokenAmountOutBeforeSwapFee = bsub(tokenBalanceOut, newTokenBalanceOut);
548 
549         // charge swap fee on the output token side 
550         //uint tAo = tAoBeforeSwapFee * (1 - (1-weightTo) * swapFee)
551         uint zaz = bmul(bsub(BConst.BONE, normalizedWeight), swapFee);
552         tokenAmountOut = bmul(tokenAmountOutBeforeSwapFee, bsub(BConst.BONE, zaz));
553         return tokenAmountOut;
554     }
555 
556     /**********************************************************************************************
557     // calcPoolInGivenSingleOut                                                                  //
558     // pAi = poolAmountIn               // /               tAo             \\     / wO \     \   //
559     // bO = tokenBalanceOut            // | bO - -------------------------- |\   | ---- |     \  //
560     // tAo = tokenAmountOut      pS - ||   \     1 - ((1 - (tO / tW)) * sF)/  | ^ \ tW /  * pS | //
561     // ps = poolSupply                 \\ -----------------------------------/                /  //
562     // wO = tokenWeightOut  pAi =       \\               bO                 /                /   //
563     // tW = totalWeight           -------------------------------------------------------------  //
564     // sF = swapFee (+ collectedFee)                       ( 1 - eF )                            //
565     // eF = exitFee                                                                              //
566     **********************************************************************************************/
567     function calcPoolInGivenSingleOut(
568         uint tokenBalanceOut,
569         uint tokenWeightOut,
570         uint poolSupply,
571         uint totalWeight,
572         uint tokenAmountOut,
573         uint swapFee,
574         uint exitFee
575     )
576         public pure
577         returns (uint poolAmountIn)
578     {
579 
580         // charge swap fee on the output token side 
581         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
582         //uint tAoBeforeSwapFee = tAo / (1 - (1-weightTo) * swapFee) ;
583         uint zoo = bsub(BConst.BONE, normalizedWeight);
584         uint zar = bmul(zoo, swapFee);
585         uint tokenAmountOutBeforeSwapFee = bdiv(tokenAmountOut, bsub(BConst.BONE, zar));
586 
587         uint newTokenBalanceOut = bsub(tokenBalanceOut, tokenAmountOutBeforeSwapFee);
588         uint tokenOutRatio = bdiv(newTokenBalanceOut, tokenBalanceOut);
589 
590         //uint newPoolSupply = (ratioTo ^ weightTo) * poolSupply;
591         uint poolRatio = bpow(tokenOutRatio, normalizedWeight);
592         uint newPoolSupply = bmul(poolRatio, poolSupply);
593         uint poolAmountInAfterExitFee = bsub(poolSupply, newPoolSupply);
594 
595         // charge exit fee on the pool token side
596         // pAi = pAiAfterExitFee/(1-exitFee)
597         poolAmountIn = bdiv(poolAmountInAfterExitFee, bsub(BConst.BONE, exitFee));
598         return poolAmountIn;
599     }
600 
601 
602 }
603 
604 // This program is free software: you can redistribute it and/or modify
605 // it under the terms of the GNU General Public License as published by
606 // the Free Software Foundation, either version 3 of the License, or
607 // (at your option) any later version.
608 // This program is distributed in the hope that it will be useful,
609 // but WITHOUT ANY WARRANTY; without even the implied warranty of
610 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
611 // GNU General Public License for more details.
612 // You should have received a copy of the GNU General Public License
613 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
614 interface IBFactory {
615     function collectedToken() external view returns(address);
616 }
617 
618 contract BPool is BToken, BMath {
619     struct Record {
620         bool bound;   // is token bound to pool
621         uint index;   // private
622         uint denorm;  // denormalized weight
623         uint balance;
624     }
625 
626     event LOG_SWAP(
627         address indexed caller,
628         address indexed tokenIn,
629         address indexed tokenOut,
630         uint256         tokenAmountIn,
631         uint256         tokenAmountOut
632     );
633 
634     event LOG_JOIN(
635         address indexed caller,
636         address indexed tokenIn,
637         uint256         tokenAmountIn
638     );
639 
640     event LOG_EXIT(
641         address indexed caller,
642         address indexed tokenOut,
643         uint256         tokenAmountOut
644     );
645     event LOG_CALL(
646         bytes4  indexed sig,
647         address indexed caller,
648         bytes           data
649     ) anonymous;
650 
651     modifier _logs_() {
652         emit LOG_CALL(msg.sig, msg.sender, msg.data);
653         _;
654     }
655     event LOG_COLLECTED_FUND(
656         address indexed collectedToken,
657         uint256         collectedAmount
658     );
659 
660     modifier _lock_() {
661         require(!_mutex, "reentry");
662         _mutex = true;
663         _;
664         _mutex = false;
665     }
666 
667     modifier _viewlock_() {
668         require(!_mutex, "reentry");
669         _;
670     }
671 
672     bool private _mutex;
673 
674     uint public version = 1001;
675     address public factory;    // BFactory address to push token exitFee to
676     address public controller; // has CONTROL role
677     bool public publicSwap;
678 
679     // `setSwapFee` and `finalize` require CONTROL
680     // `finalize` sets `PUBLIC can SWAP`, `PUBLIC can JOIN`
681     uint public initPoolSupply;
682     uint public swapFee;
683     uint public collectedFee; // 0.05% | https://yfv.finance/vip-vote/vip_5
684     uint public exitFee;
685     bool public finalized;
686 
687     address[] private _tokens;
688     mapping(address => Record) private _records;
689     uint private _totalWeight;
690 
691     constructor(address _factory) public {
692         controller = _factory;
693         factory = _factory;
694         initPoolSupply = BConst.DEFAULT_INIT_POOL_SUPPLY;
695         swapFee = BConst.DEFAULT_FEE;
696         collectedFee = BConst.DEFAULT_COLLECTED_FEE;
697         exitFee = BConst.DEFAULT_EXIT_FEE;
698         publicSwap = false;
699         finalized = false;
700     }
701 
702     function setInitPoolSupply(uint _initPoolSupply) public _logs_ {
703         require(!finalized, "finalized");
704         require(msg.sender == controller, "!controller");
705         require(_initPoolSupply >= BConst.MIN_INIT_POOL_SUPPLY, "<minInitPoolSup");
706         require(_initPoolSupply <= BConst.MAX_INIT_POOL_SUPPLY, ">maxInitPoolSup");
707         initPoolSupply = _initPoolSupply;
708     }
709 
710     function setCollectedFee(uint _collectedFee) public _logs_ {
711         require(msg.sender == factory, "!factory");
712         require(_collectedFee <= BConst.MAX_COLLECTED_FEE, ">maxCoFee");
713         require(bmul(_collectedFee, 2) <= swapFee, ">swapFee/2");
714         collectedFee = _collectedFee;
715     }
716 
717     function setExitFee(uint _exitFee) public _logs_ {
718         require(!finalized, "finalized");
719         require(msg.sender == factory, "!factory");
720         require(_exitFee <= BConst.MAX_EXIT_FEE, ">maxExitFee");
721         exitFee = _exitFee;
722     }
723 
724     function isBound(address t)
725         external view
726         returns (bool)
727     {
728         return _records[t].bound;
729     }
730 
731     function getNumTokens()
732         external view
733         returns (uint) 
734     {
735         return _tokens.length;
736     }
737 
738     function getCurrentTokens()
739         external view _viewlock_
740         returns (address[] memory tokens)
741     {
742         return _tokens;
743     }
744 
745     function getFinalTokens()
746         external view
747         _viewlock_
748         returns (address[] memory tokens)
749     {
750         require(finalized, "!finalized");
751         return _tokens;
752     }
753 
754     function getDenormalizedWeight(address token)
755         external view
756         _viewlock_
757         returns (uint)
758     {
759 
760         require(_records[token].bound, "!bound");
761         return _records[token].denorm;
762     }
763 
764     function getTotalDenormalizedWeight()
765         external view
766         _viewlock_
767         returns (uint)
768     {
769         return _totalWeight;
770     }
771 
772     function getNormalizedWeight(address token)
773         external view
774         _viewlock_
775         returns (uint)
776     {
777 
778         require(_records[token].bound, "!bound");
779         uint denorm = _records[token].denorm;
780         return bdiv(denorm, _totalWeight);
781     }
782 
783     function getBalance(address token)
784         external view
785         _viewlock_
786         returns (uint)
787     {
788 
789         require(_records[token].bound, "!bound");
790         return _records[token].balance;
791     }
792 
793     function setSwapFee(uint _swapFee)
794         external
795         _lock_
796         _logs_
797     {
798         require(!finalized, "finalized");
799         require(msg.sender == controller, "!controller");
800         require(_swapFee >= BConst.MIN_FEE, "<minFee");
801         require(_swapFee <= BConst.MAX_FEE, ">maxFee");
802         require(bmul(collectedFee, 2) <= _swapFee, "<collectedFee*2");
803         swapFee = _swapFee;
804     }
805 
806     function setController(address _controller)
807         external
808         _lock_
809         _logs_
810     {
811         require(msg.sender == controller, "!controller");
812         controller = _controller;
813     }
814 
815     function setPublicSwap(bool _publicSwap)
816         external
817         _lock_
818         _logs_
819     {
820         require(!finalized, "finalized");
821         require(msg.sender == controller, "!controller");
822         publicSwap = _publicSwap;
823     }
824 
825     function finalize()
826         external
827         _lock_
828         _logs_
829     {
830         require(msg.sender == controller, "!controller");
831         require(!finalized, "finalized");
832         require(_tokens.length >= BConst.MIN_BOUND_TOKENS, "<minTokens");
833 
834         finalized = true;
835         publicSwap = true;
836 
837         _mintPoolShare(initPoolSupply);
838         _pushPoolShare(msg.sender, initPoolSupply);
839     }
840 
841 
842     function bind(address token, uint balance, uint denorm)
843         external
844         _logs_
845         // _lock_  Bind does not lock because it jumps to `rebind`, which does
846     {
847         require(msg.sender == controller, "!controller");
848         require(!_records[token].bound, "bound");
849         require(!finalized, "finalized");
850 
851         require(_tokens.length < BConst.MAX_BOUND_TOKENS, ">maxTokens");
852 
853         _records[token] = Record({
854             bound: true,
855             index: _tokens.length,
856             denorm: 0,    // balance and denorm will be validated
857             balance: 0   // and set by `rebind`
858         });
859         _tokens.push(token);
860         rebind(token, balance, denorm);
861     }
862 
863     function rebind(address token, uint balance, uint denorm)
864         public
865         _lock_
866         _logs_
867     {
868 
869         require(msg.sender == controller, "!controller");
870         require(_records[token].bound, "!bound");
871         require(!finalized, "finalized");
872 
873         require(denorm >= BConst.MIN_WEIGHT, "<minWeight");
874         require(denorm <= BConst.MAX_WEIGHT, ">maxWeight");
875         require(balance >= BConst.MIN_BALANCE, "<minBal");
876 
877         // Adjust the denorm and totalWeight
878         uint oldWeight = _records[token].denorm;
879         if (denorm > oldWeight) {
880             _totalWeight = badd(_totalWeight, bsub(denorm, oldWeight));
881             require(_totalWeight <= BConst.MAX_TOTAL_WEIGHT, ">maxTWeight");
882         } else if (denorm < oldWeight) {
883             _totalWeight = bsub(_totalWeight, bsub(oldWeight, denorm));
884         }        
885         _records[token].denorm = denorm;
886 
887         // Adjust the balance record and actual token balance
888         uint oldBalance = _records[token].balance;
889         _records[token].balance = balance;
890         if (balance > oldBalance) {
891             _pullUnderlying(token, msg.sender, bsub(balance, oldBalance));
892         } else if (balance < oldBalance) {
893             // In this case liquidity is being withdrawn, so charge EXIT_FEE
894             uint tokenBalanceWithdrawn = bsub(oldBalance, balance);
895             uint tokenExitFee = bmul(tokenBalanceWithdrawn, exitFee);
896             _pushUnderlying(token, msg.sender, bsub(tokenBalanceWithdrawn, tokenExitFee));
897             _pushUnderlying(token, factory, tokenExitFee);
898         }
899     }
900 
901     function unbind(address token)
902         external
903         _lock_
904         _logs_
905     {
906 
907         require(msg.sender == controller, "!controller");
908         require(_records[token].bound, "!bound");
909         require(!finalized, "finalized");
910 
911         uint tokenBalance = _records[token].balance;
912         uint tokenExitFee = bmul(tokenBalance, exitFee);
913 
914         _totalWeight = bsub(_totalWeight, _records[token].denorm);
915 
916         // Swap the token-to-unbind with the last token,
917         // then delete the last token
918         uint index = _records[token].index;
919         uint last = _tokens.length - 1;
920         _tokens[index] = _tokens[last];
921         _records[_tokens[index]].index = index;
922         _tokens.pop();
923         _records[token] = Record({
924             bound: false,
925             index: 0,
926             denorm: 0,
927             balance: 0
928         });
929 
930         _pushUnderlying(token, msg.sender, bsub(tokenBalance, tokenExitFee));
931         _pushUnderlying(token, factory, tokenExitFee);
932     }
933 
934     // Absorb any tokens that have been sent to this contract into the pool
935     function gulp(address token)
936         external
937         _logs_
938         _lock_
939     {
940         require(_records[token].bound, "!bound");
941         _records[token].balance = IERC20(token).balanceOf(address(this));
942     }
943 
944     function getSpotPrice(address tokenIn, address tokenOut)
945         external view
946         _viewlock_
947         returns (uint spotPrice)
948     {
949         require(_records[tokenIn].bound, "!bound");
950         require(_records[tokenOut].bound, "!bound");
951         Record storage inRecord = _records[tokenIn];
952         Record storage outRecord = _records[tokenOut];
953         return calcSpotPrice(inRecord.balance, inRecord.denorm, outRecord.balance, outRecord.denorm, swapFee);
954     }
955 
956     function getSpotPriceSansFee(address tokenIn, address tokenOut)
957         external view
958         _viewlock_
959         returns (uint spotPrice)
960     {
961         require(_records[tokenIn].bound, "!bound");
962         require(_records[tokenOut].bound, "!bound");
963         Record storage inRecord = _records[tokenIn];
964         Record storage outRecord = _records[tokenOut];
965         return calcSpotPrice(inRecord.balance, inRecord.denorm, outRecord.balance, outRecord.denorm, 0);
966     }
967 
968     function joinPool(uint poolAmountOut, uint[] calldata maxAmountsIn)
969         external
970         _lock_
971         _logs_
972     {
973         require(finalized, "!finalized");
974 
975         uint poolTotal = totalSupply();
976         uint ratio = bdiv(poolAmountOut, poolTotal);
977         require(ratio != 0, "errMathAprox");
978 
979         for (uint i = 0; i < _tokens.length; i++) {
980             address t = _tokens[i];
981             uint bal = _records[t].balance;
982             uint tokenAmountIn = bmul(ratio, bal);
983             require(tokenAmountIn != 0, "errMathAprox");
984             require(tokenAmountIn <= maxAmountsIn[i], "<limIn");
985             _records[t].balance = badd(_records[t].balance, tokenAmountIn);
986             emit LOG_JOIN(msg.sender, t, tokenAmountIn);
987             _pullUnderlying(t, msg.sender, tokenAmountIn);
988         }
989         _mintPoolShare(poolAmountOut);
990         _pushPoolShare(msg.sender, poolAmountOut);
991     }
992 
993     function exitPool(uint poolAmountIn, uint[] calldata minAmountsOut)
994         external
995         _lock_
996         _logs_
997     {
998         require(finalized, "!finalized");
999 
1000         uint poolTotal = totalSupply();
1001         uint _exitFee = bmul(poolAmountIn, exitFee);
1002         uint pAiAfterExitFee = bsub(poolAmountIn, _exitFee);
1003         uint ratio = bdiv(pAiAfterExitFee, poolTotal);
1004         require(ratio != 0, "errMathAprox");
1005 
1006         _pullPoolShare(msg.sender, poolAmountIn);
1007         _pushPoolShare(factory, _exitFee);
1008         _burnPoolShare(pAiAfterExitFee);
1009 
1010         for (uint i = 0; i < _tokens.length; i++) {
1011             address t = _tokens[i];
1012             uint bal = _records[t].balance;
1013             uint tokenAmountOut = bmul(ratio, bal);
1014             require(tokenAmountOut != 0, "errMathAprox");
1015             require(tokenAmountOut >= minAmountsOut[i], "<limO");
1016             _records[t].balance = bsub(_records[t].balance, tokenAmountOut);
1017             emit LOG_EXIT(msg.sender, t, tokenAmountOut);
1018             _pushUnderlying(t, msg.sender, tokenAmountOut);
1019         }
1020     }
1021 
1022 
1023     function swapExactAmountIn(
1024         address tokenIn,
1025         uint tokenAmountIn,
1026         address tokenOut,
1027         uint minAmountOut,
1028         uint maxPrice
1029     )
1030         external
1031         _lock_
1032         _logs_
1033         returns (uint tokenAmountOut, uint spotPriceAfter)
1034     {
1035 
1036         require(_records[tokenIn].bound, "!bound");
1037         require(_records[tokenOut].bound, "!bound");
1038         require(publicSwap, "!publicSwap");
1039 
1040         Record storage inRecord = _records[address(tokenIn)];
1041         Record storage outRecord = _records[address(tokenOut)];
1042 
1043         require(tokenAmountIn <= bmul(inRecord.balance, BConst.MAX_IN_RATIO), ">maxIRat");
1044 
1045         uint spotPriceBefore = calcSpotPrice(
1046                                     inRecord.balance,
1047                                     inRecord.denorm,
1048                                     outRecord.balance,
1049                                     outRecord.denorm,
1050                                     swapFee
1051                                 );
1052         require(spotPriceBefore <= maxPrice, "badLimPrice");
1053 
1054         tokenAmountOut = calcOutGivenIn(
1055                             inRecord.balance,
1056                             inRecord.denorm,
1057                             outRecord.balance,
1058                             outRecord.denorm,
1059                             tokenAmountIn,
1060                             swapFee
1061                         );
1062         require(tokenAmountOut >= minAmountOut, "<limO");
1063 
1064         inRecord.balance = badd(inRecord.balance, tokenAmountIn);
1065         outRecord.balance = bsub(outRecord.balance, tokenAmountOut);
1066 
1067         spotPriceAfter = calcSpotPrice(
1068                                 inRecord.balance,
1069                                 inRecord.denorm,
1070                                 outRecord.balance,
1071                                 outRecord.denorm,
1072                                 swapFee
1073                             );
1074         require(spotPriceAfter >= spotPriceBefore, "errMathAprox");
1075         require(spotPriceAfter <= maxPrice, ">limPrice");
1076         require(spotPriceBefore <= bdiv(tokenAmountIn, tokenAmountOut), "errMathAprox");
1077 
1078         emit LOG_SWAP(msg.sender, tokenIn, tokenOut, tokenAmountIn, tokenAmountOut);
1079 
1080         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1081         uint _subTokenAmountIn;
1082         (_subTokenAmountIn, tokenAmountOut) = _pushCollectedFundGivenOut(tokenIn, tokenAmountIn, tokenOut, tokenAmountOut);
1083         if (_subTokenAmountIn > 0) inRecord.balance = bsub(inRecord.balance, _subTokenAmountIn);
1084         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1085 
1086         return (tokenAmountOut, spotPriceAfter);
1087     }
1088 
1089     function swapExactAmountOut(
1090         address tokenIn,
1091         uint maxAmountIn,
1092         address tokenOut,
1093         uint tokenAmountOut,
1094         uint maxPrice
1095     )
1096         external
1097         _lock_
1098         _logs_
1099         returns (uint tokenAmountIn, uint spotPriceAfter)
1100     {
1101         require(_records[tokenIn].bound, "!bound");
1102         require(_records[tokenOut].bound, "!bound");
1103         require(publicSwap, "!publicSwap");
1104 
1105         Record storage inRecord = _records[address(tokenIn)];
1106         Record storage outRecord = _records[address(tokenOut)];
1107 
1108         require(tokenAmountOut <= bmul(outRecord.balance, BConst.MAX_OUT_RATIO), ">maxORat");
1109 
1110         uint spotPriceBefore = calcSpotPrice(
1111                                     inRecord.balance,
1112                                     inRecord.denorm,
1113                                     outRecord.balance,
1114                                     outRecord.denorm,
1115                                     swapFee
1116                                 );
1117         require(spotPriceBefore <= maxPrice, "badLimPrice");
1118 
1119         tokenAmountIn = calcInGivenOut(
1120                             inRecord.balance,
1121                             inRecord.denorm,
1122                             outRecord.balance,
1123                             outRecord.denorm,
1124                             tokenAmountOut,
1125                             swapFee
1126                         );
1127         require(tokenAmountIn <= maxAmountIn, "<limIn");
1128 
1129         inRecord.balance = badd(inRecord.balance, tokenAmountIn);
1130         outRecord.balance = bsub(outRecord.balance, tokenAmountOut);
1131 
1132         spotPriceAfter = calcSpotPrice(
1133                                 inRecord.balance,
1134                                 inRecord.denorm,
1135                                 outRecord.balance,
1136                                 outRecord.denorm,
1137                                 swapFee
1138                             );
1139         require(spotPriceAfter >= spotPriceBefore, "errMathAprox");
1140         require(spotPriceAfter <= maxPrice, ">limPrice");
1141         require(spotPriceBefore <= bdiv(tokenAmountIn, tokenAmountOut), "errMathAprox");
1142 
1143         emit LOG_SWAP(msg.sender, tokenIn, tokenOut, tokenAmountIn, tokenAmountOut);
1144 
1145         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1146         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1147         uint _collectedFeeAmount = _pushCollectedFundGivenIn(tokenIn, tokenAmountIn);
1148         if (_collectedFeeAmount > 0) inRecord.balance = bsub(inRecord.balance, _collectedFeeAmount);
1149 
1150         return (tokenAmountIn, spotPriceAfter);
1151     }
1152 
1153 
1154     function joinswapExternAmountIn(address tokenIn, uint tokenAmountIn, uint minPoolAmountOut)
1155         external
1156         _lock_
1157         _logs_
1158         returns (uint poolAmountOut)
1159 
1160     {        
1161         require(finalized, "!finalized");
1162         require(_records[tokenIn].bound, "!bound");
1163         require(tokenAmountIn <= bmul(_records[tokenIn].balance, BConst.MAX_IN_RATIO), ">maxIRat");
1164 
1165         Record storage inRecord = _records[tokenIn];
1166 
1167         poolAmountOut = calcPoolOutGivenSingleIn(
1168                             inRecord.balance,
1169                             inRecord.denorm,
1170                             _totalSupply,
1171                             _totalWeight,
1172                             tokenAmountIn,
1173                             swapFee
1174                         );
1175 
1176         require(poolAmountOut >= minPoolAmountOut, "<limO");
1177 
1178         inRecord.balance = badd(inRecord.balance, tokenAmountIn);
1179 
1180         emit LOG_JOIN(msg.sender, tokenIn, tokenAmountIn);
1181 
1182         _mintPoolShare(poolAmountOut);
1183         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1184         uint _subTokenAmountIn;
1185         (_subTokenAmountIn, poolAmountOut) = _pushCollectedFundGivenOut(tokenIn, tokenAmountIn, address(this), poolAmountOut);
1186         if (_subTokenAmountIn > 0) inRecord.balance = bsub(inRecord.balance, _subTokenAmountIn);
1187         _pushPoolShare(msg.sender, poolAmountOut);
1188 
1189         return poolAmountOut;
1190     }
1191 
1192     function joinswapPoolAmountOut(address tokenIn, uint poolAmountOut, uint maxAmountIn)
1193         external
1194         _lock_
1195         _logs_
1196         returns (uint tokenAmountIn)
1197     {
1198         require(finalized, "!finalized");
1199         require(_records[tokenIn].bound, "!bound");
1200 
1201         Record storage inRecord = _records[tokenIn];
1202 
1203         tokenAmountIn = calcSingleInGivenPoolOut(
1204                             inRecord.balance,
1205                             inRecord.denorm,
1206                             _totalSupply,
1207                             _totalWeight,
1208                             poolAmountOut,
1209                             swapFee
1210                         );
1211 
1212         require(tokenAmountIn != 0, "errMathAprox");
1213         require(tokenAmountIn <= maxAmountIn, "<limIn");
1214         
1215         require(tokenAmountIn <= bmul(_records[tokenIn].balance, BConst.MAX_IN_RATIO), ">maxIRat");
1216 
1217         inRecord.balance = badd(inRecord.balance, tokenAmountIn);
1218 
1219         emit LOG_JOIN(msg.sender, tokenIn, tokenAmountIn);
1220 
1221         _mintPoolShare(poolAmountOut);
1222         _pushPoolShare(msg.sender, poolAmountOut);
1223         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1224         uint _collectedFeeAmount = _pushCollectedFundGivenIn(tokenIn, tokenAmountIn);
1225         if (_collectedFeeAmount > 0) inRecord.balance = bsub(inRecord.balance, _collectedFeeAmount);
1226 
1227         return tokenAmountIn;
1228     }
1229 
1230     function exitswapPoolAmountIn(address tokenOut, uint poolAmountIn, uint minAmountOut)
1231         external
1232         _lock_
1233         _logs_
1234         returns (uint tokenAmountOut)
1235     {
1236         require(finalized, "!finalized");
1237         require(_records[tokenOut].bound, "!bound");
1238 
1239         Record storage outRecord = _records[tokenOut];
1240 
1241         tokenAmountOut = calcSingleOutGivenPoolIn(
1242                             outRecord.balance,
1243                             outRecord.denorm,
1244                             _totalSupply,
1245                             _totalWeight,
1246                             poolAmountIn,
1247                             swapFee,
1248                             exitFee
1249                         );
1250 
1251         require(tokenAmountOut >= minAmountOut, "<limO");
1252         
1253         require(tokenAmountOut <= bmul(_records[tokenOut].balance, BConst.MAX_OUT_RATIO), ">maxORat");
1254 
1255         outRecord.balance = bsub(outRecord.balance, tokenAmountOut);
1256 
1257         uint _exitFee = bmul(poolAmountIn, exitFee);
1258 
1259         emit LOG_EXIT(msg.sender, tokenOut, tokenAmountOut);
1260 
1261         _pullPoolShare(msg.sender, poolAmountIn);
1262         _burnPoolShare(bsub(poolAmountIn, _exitFee));
1263         _pushPoolShare(factory, _exitFee);
1264         (, tokenAmountOut) = _pushCollectedFundGivenOut(address(this), poolAmountIn, tokenOut, tokenAmountOut);
1265         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1266 
1267         return tokenAmountOut;
1268     }
1269 
1270     function exitswapExternAmountOut(address tokenOut, uint tokenAmountOut, uint maxPoolAmountIn)
1271         external
1272         _lock_
1273         _logs_
1274         returns (uint poolAmountIn)
1275     {
1276         require(finalized, "!finalized");
1277         require(_records[tokenOut].bound, "!bound");
1278         require(tokenAmountOut <= bmul(_records[tokenOut].balance, BConst.MAX_OUT_RATIO), ">maxORat");
1279 
1280         Record storage outRecord = _records[tokenOut];
1281 
1282         poolAmountIn = calcPoolInGivenSingleOut(
1283                             outRecord.balance,
1284                             outRecord.denorm,
1285                             _totalSupply,
1286                             _totalWeight,
1287                             tokenAmountOut,
1288                             swapFee,
1289                             exitFee
1290                         );
1291 
1292         require(poolAmountIn != 0, "errMathAprox");
1293         require(poolAmountIn <= maxPoolAmountIn, "<limIn");
1294 
1295         outRecord.balance = bsub(outRecord.balance, tokenAmountOut);
1296 
1297         uint _exitFee = bmul(poolAmountIn, exitFee);
1298 
1299         emit LOG_EXIT(msg.sender, tokenOut, tokenAmountOut);
1300 
1301         _pullPoolShare(msg.sender, poolAmountIn);
1302         uint _collectedFeeAmount = _pushCollectedFundGivenIn(address(this), poolAmountIn);
1303         _burnPoolShare(bsub(bsub(poolAmountIn, _exitFee), _collectedFeeAmount));
1304         _pushPoolShare(factory, _exitFee);
1305         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1306 
1307         return poolAmountIn;
1308     }
1309 
1310 
1311     // ==
1312     // 'Underlying' token-manipulation functions make external calls but are NOT locked
1313     // You must `_lock_` or otherwise ensure reentry-safety
1314 
1315     function _pullUnderlying(address erc20, address from, uint amount)
1316         internal
1317     {
1318         bool xfer = IERC20(erc20).transferFrom(from, address(this), amount);
1319         require(xfer, "errErc20");
1320     }
1321 
1322     function _pushUnderlying(address erc20, address to, uint amount)
1323         internal
1324     {
1325         bool xfer = IERC20(erc20).transfer(to, amount);
1326         require(xfer, "errErc20");
1327     }
1328 
1329     function _pullPoolShare(address from, uint amount)
1330         internal
1331     {
1332         _pull(from, amount);
1333     }
1334 
1335     function _pushPoolShare(address to, uint amount)
1336         internal
1337     {
1338         _push(to, amount);
1339     }
1340 
1341     function _mintPoolShare(uint amount)
1342         internal
1343     {
1344         _mint(amount);
1345     }
1346 
1347     function _burnPoolShare(uint amount)
1348         internal
1349     {
1350         _burn(amount);
1351     }
1352 
1353     function _pushCollectedFundGivenOut(address _tokenIn, uint _tokenAmountIn, address _tokenOut, uint _tokenAmountOut) internal returns (uint subTokenAmountIn, uint tokenAmountOut) {
1354         subTokenAmountIn = 0;
1355         tokenAmountOut = _tokenAmountOut;
1356         if (collectedFee > 0) {
1357             address _collectedToken = IBFactory(factory).collectedToken();
1358             if (_collectedToken == _tokenIn) {
1359                 subTokenAmountIn = bdiv(bmul(_tokenAmountIn, collectedFee), BConst.BONE);
1360                 _pushUnderlying(_tokenIn, factory, subTokenAmountIn);
1361                 emit LOG_COLLECTED_FUND(_tokenIn, subTokenAmountIn);
1362             } else {
1363                 uint _collectedFeeAmount = bdiv(bmul(_tokenAmountOut, collectedFee), BConst.BONE);
1364                 _pushUnderlying(_tokenOut, factory, _collectedFeeAmount);
1365                 tokenAmountOut = bsub(_tokenAmountOut, _collectedFeeAmount);
1366                 emit LOG_COLLECTED_FUND(_tokenOut, _collectedFeeAmount);
1367             }
1368         }
1369     }
1370 
1371     // always push out _tokenIn (already have)
1372     function _pushCollectedFundGivenIn(address _tokenIn, uint _tokenAmountIn) internal returns (uint collectedFeeAmount) {
1373         collectedFeeAmount = 0;
1374         if (collectedFee > 0) {
1375             address _collectedToken = IBFactory(factory).collectedToken();
1376             if (_collectedToken != address(0)) {
1377                 collectedFeeAmount = bdiv(bmul(_tokenAmountIn, collectedFee), BConst.BONE);
1378                 _pushUnderlying(_tokenIn, factory, collectedFeeAmount);
1379                 emit LOG_COLLECTED_FUND(_tokenIn, collectedFeeAmount);
1380             }
1381         }
1382     }
1383 }