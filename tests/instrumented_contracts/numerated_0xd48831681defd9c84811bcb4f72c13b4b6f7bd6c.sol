1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 // This program is free software: you can redistribute it and/or modify
162 // it under the terms of the GNU General Public License as published by
163 // the Free Software Foundation, either version 3 of the License, or
164 // (at your option) any later version.
165 // This program is distributed in the hope that it will be useful,
166 // but WITHOUT ANY WARRANTY; without even the implied warranty of
167 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
168 // GNU General Public License for more details.
169 // You should have received a copy of the GNU General Public License
170 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
171 library BConst {
172     uint public constant BONE                     = 10**18;
173 
174     uint public constant MIN_BOUND_TOKENS         = 2;
175     uint public constant MAX_BOUND_TOKENS         = 8;
176 
177     uint public constant DEFAULT_FEE              = BONE * 3 / 1000; // 0.3%
178     uint public constant MIN_FEE                  = BONE / 1000; // 0.1%
179     uint public constant MAX_FEE                  = BONE / 10; // 10%
180 
181     uint public constant DEFAULT_COLLECTED_FEE    = BONE * 33 / 10000; // 0.33%
182     uint public constant MAX_COLLECTED_FEE        = BONE * 334 / 10000; // 3.34%
183 
184     uint public constant DEFAULT_EXIT_FEE         = 0;
185     uint public constant MAX_EXIT_FEE             = BONE / 1000; // 0.1%
186 
187     uint public constant MIN_WEIGHT               = BONE;
188     uint public constant MAX_WEIGHT               = BONE * 50;
189     uint public constant MAX_TOTAL_WEIGHT         = BONE * 50;
190     uint public constant MIN_BALANCE              = BONE / 10**12;
191 
192     uint public constant DEFAULT_INIT_POOL_SUPPLY = BONE * 100;
193     uint public constant MIN_INIT_POOL_SUPPLY     = BONE / 1000;
194     uint public constant MAX_INIT_POOL_SUPPLY     = BONE * 10**18;
195 
196     uint public constant MIN_BPOW_BASE            = 1 wei;
197     uint public constant MAX_BPOW_BASE            = (2 * BONE) - 1 wei;
198     uint public constant BPOW_PRECISION           = BONE / 10**10;
199 
200     uint public constant MAX_IN_RATIO             = BONE / 2;
201     uint public constant MAX_OUT_RATIO            = (BONE / 3) + 1 wei;
202 }
203 
204 // This program is free software: you can redistribute it and/or modify
205 // it under the terms of the GNU General Public License as published by
206 // the Free Software Foundation, either version 3 of the License, or
207 // (at your option) any later version.
208 // This program is distributed in the hope that it will be useful,
209 // but WITHOUT ANY WARRANTY; without even the implied warranty of
210 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
211 // GNU General Public License for more details.
212 // You should have received a copy of the GNU General Public License
213 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
214 contract BNum {
215 
216     function btoi(uint a)
217         internal pure 
218         returns (uint)
219     {
220         return a / BConst.BONE;
221     }
222 
223     function bfloor(uint a)
224         internal pure
225         returns (uint)
226     {
227         return btoi(a) * BConst.BONE;
228     }
229 
230     function badd(uint a, uint b)
231         internal pure
232         returns (uint)
233     {
234         uint c = a + b;
235         require(c >= a, "add overflow");
236         return c;
237     }
238 
239     function bsub(uint a, uint b)
240         internal pure
241         returns (uint)
242     {
243         (uint c, bool flag) = bsubSign(a, b);
244         require(!flag, "sub underflow");
245         return c;
246     }
247 
248     function bsubSign(uint a, uint b)
249         internal pure
250         returns (uint, bool)
251     {
252         if (a >= b) {
253             return (a - b, false);
254         } else {
255             return (b - a, true);
256         }
257     }
258 
259     function bmul(uint a, uint b)
260         internal pure
261         returns (uint)
262     {
263         uint c0 = a * b;
264         require(a == 0 || c0 / a == b, "mul overflow");
265         uint c1 = c0 + (BConst.BONE / 2);
266         require(c1 >= c0, "mul overflow");
267         uint c2 = c1 / BConst.BONE;
268         return c2;
269     }
270 
271     function bdiv(uint a, uint b)
272         internal pure
273         returns (uint)
274     {
275         require(b != 0, "div by 0");
276         uint c0 = a * BConst.BONE;
277         require(a == 0 || c0 / a == BConst.BONE, "div internal"); // bmul overflow
278         uint c1 = c0 + (b / 2);
279         require(c1 >= c0, "div internal"); //  badd require
280         uint c2 = c1 / b;
281         return c2;
282     }
283 
284     // DSMath.wpow
285     function bpowi(uint a, uint n)
286         internal pure
287         returns (uint)
288     {
289         uint z = n % 2 != 0 ? a : BConst.BONE;
290 
291         for (n /= 2; n != 0; n /= 2) {
292             a = bmul(a, a);
293 
294             if (n % 2 != 0) {
295                 z = bmul(z, a);
296             }
297         }
298         return z;
299     }
300 
301     // Compute b^(e.w) by splitting it into (b^e)*(b^0.w).
302     // Use `bpowi` for `b^e` and `bpowK` for k iterations
303     // of approximation of b^0.w
304     function bpow(uint base, uint exp)
305         internal pure
306         returns (uint)
307     {
308         require(base >= BConst.MIN_BPOW_BASE, "base too low");
309         require(base <= BConst.MAX_BPOW_BASE, "base too high");
310 
311         uint whole  = bfloor(exp);   
312         uint remain = bsub(exp, whole);
313 
314         uint wholePow = bpowi(base, btoi(whole));
315 
316         if (remain == 0) {
317             return wholePow;
318         }
319 
320         uint partialResult = bpowApprox(base, remain, BConst.BPOW_PRECISION);
321         return bmul(wholePow, partialResult);
322     }
323 
324     function bpowApprox(uint base, uint exp, uint precision)
325         internal pure
326         returns (uint)
327     {
328         // term 0:
329         uint a     = exp;
330         (uint x, bool xneg)  = bsubSign(base, BConst.BONE);
331         uint term = BConst.BONE;
332         uint sum   = term;
333         bool negative = false;
334 
335 
336         // term(k) = numer / denom 
337         //         = (product(a - i - 1, i=1-->k) * x^k) / (k!)
338         // each iteration, multiply previous term by (a-(k-1)) * x / k
339         // continue until term is less than precision
340         for (uint i = 1; term >= precision; i++) {
341             uint bigK = i * BConst.BONE;
342             (uint c, bool cneg) = bsubSign(a, bsub(bigK, BConst.BONE));
343             term = bmul(term, bmul(c, x));
344             term = bdiv(term, bigK);
345             if (term == 0) break;
346 
347             if (xneg) negative = !negative;
348             if (cneg) negative = !negative;
349             if (negative) {
350                 sum = bsub(sum, term);
351             } else {
352                 sum = badd(sum, term);
353             }
354         }
355 
356         return sum;
357     }
358 
359 }
360 
361 // This program is free software: you can redistribute it and/or modify
362 // it under the terms of the GNU General Public License as published by
363 // the Free Software Foundation, either version 3 of the License, or
364 // (at your option) any later version.
365 // This program is distributed in the hope that it will be useful,
366 // but WITHOUT ANY WARRANTY; without even the implied warranty of
367 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
368 // GNU General Public License for more details.
369 // You should have received a copy of the GNU General Public License
370 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
371 // Highly opinionated token implementation
372 interface IERC20 {
373     event Approval(address indexed src, address indexed dst, uint amt);
374     event Transfer(address indexed src, address indexed dst, uint amt);
375 
376     function totalSupply() external view returns (uint);
377     function balanceOf(address whom) external view returns (uint);
378     function allowance(address src, address dst) external view returns (uint);
379 
380     function approve(address dst, uint amt) external returns (bool);
381     function transfer(address dst, uint amt) external returns (bool);
382     function transferFrom(
383         address src, address dst, uint amt
384     ) external returns (bool);
385 }
386 
387 contract BTokenBase is BNum {
388 
389     mapping(address => uint)                   internal _balance;
390     mapping(address => mapping(address=>uint)) internal _allowance;
391     uint internal _totalSupply;
392 
393     event Approval(address indexed src, address indexed dst, uint amt);
394     event Transfer(address indexed src, address indexed dst, uint amt);
395 
396     function _mint(uint amt) internal {
397         _balance[address(this)] = badd(_balance[address(this)], amt);
398         _totalSupply = badd(_totalSupply, amt);
399         emit Transfer(address(0), address(this), amt);
400     }
401 
402     function _burn(uint amt) internal {
403         require(_balance[address(this)] >= amt, "!bal");
404         _balance[address(this)] = bsub(_balance[address(this)], amt);
405         _totalSupply = bsub(_totalSupply, amt);
406         emit Transfer(address(this), address(0), amt);
407     }
408 
409     function _move(address src, address dst, uint amt) internal {
410         require(_balance[src] >= amt, "!bal");
411         _balance[src] = bsub(_balance[src], amt);
412         _balance[dst] = badd(_balance[dst], amt);
413         emit Transfer(src, dst, amt);
414     }
415 
416     function _push(address to, uint amt) internal {
417         _move(address(this), to, amt);
418     }
419 
420     function _pull(address from, uint amt) internal {
421         _move(from, address(this), amt);
422     }
423 }
424 
425 contract BToken is BTokenBase, IERC20 {
426     string  private _name     = "Value Liquidity Provider";
427     string  private _symbol   = "VLP";
428     uint8   private _decimals = 18;
429 
430     function name() public view returns (string memory) {
431         return _name;
432     }
433 
434     function symbol() public view returns (string memory) {
435         return _symbol;
436     }
437 
438     function decimals() public view returns(uint8) {
439         return _decimals;
440     }
441 
442     function allowance(address src, address dst) external override view returns (uint) {
443         return _allowance[src][dst];
444     }
445 
446     function balanceOf(address whom) public override view returns (uint) {
447         return _balance[whom];
448     }
449 
450     function totalSupply() public override view returns (uint) {
451         return _totalSupply;
452     }
453 
454     function approve(address dst, uint amt) external override returns (bool) {
455         _allowance[msg.sender][dst] = amt;
456         emit Approval(msg.sender, dst, amt);
457         return true;
458     }
459 
460     function increaseApproval(address dst, uint amt) external returns (bool) {
461         _allowance[msg.sender][dst] = badd(_allowance[msg.sender][dst], amt);
462         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
463         return true;
464     }
465 
466     function decreaseApproval(address dst, uint amt) external returns (bool) {
467         uint oldValue = _allowance[msg.sender][dst];
468         if (amt > oldValue) {
469             _allowance[msg.sender][dst] = 0;
470         } else {
471             _allowance[msg.sender][dst] = bsub(oldValue, amt);
472         }
473         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
474         return true;
475     }
476 
477     function transfer(address dst, uint amt) external override returns (bool) {
478         _move(msg.sender, dst, amt);
479         return true;
480     }
481 
482     function transferFrom(address src, address dst, uint amt) external override returns (bool) {
483         require(msg.sender == src || amt <= _allowance[src][msg.sender], "!spender");
484         _move(src, dst, amt);
485         if (msg.sender != src && _allowance[src][msg.sender] != uint256(-1)) {
486             _allowance[src][msg.sender] = bsub(_allowance[src][msg.sender], amt);
487             emit Approval(msg.sender, dst, _allowance[src][msg.sender]);
488         }
489         return true;
490     }
491 }
492 
493 // This program is free software: you can redistribute it and/or modify
494 // it under the terms of the GNU General Public License as published by
495 // the Free Software Foundation, either version 3 of the License, or
496 // (at your option) any later version.
497 // This program is distributed in the hope that it will be useful,
498 // but WITHOUT ANY WARRANTY; without even the implied warranty of
499 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
500 // GNU General Public License for more details.
501 // You should have received a copy of the GNU General Public License
502 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
503 contract BMathLite is BNum {
504     /**********************************************************************************************
505     // calcSpotPrice                                                                             //
506     // sP = spotPrice                                                                            //
507     // bI = tokenBalanceIn                ( bI / wI )         1                                  //
508     // bO = tokenBalanceOut         sP =  -----------  *  ----------                             //
509     // wI = tokenWeightIn                 ( bO / wO )     ( 1 - sF )                             //
510     // wO = tokenWeightOut                                                                       //
511     // sF = swapFee (+ collectedFee)                                                             //
512     **********************************************************************************************/
513     function calcSpotPrice(
514         uint tokenBalanceIn,
515         uint tokenWeightIn,
516         uint tokenBalanceOut,
517         uint tokenWeightOut,
518         uint swapFee
519     )
520         public pure
521         returns (uint spotPrice)
522     {
523         uint numer = bdiv(tokenBalanceIn, tokenWeightIn);
524         uint denom = bdiv(tokenBalanceOut, tokenWeightOut);
525         uint ratio = bdiv(numer, denom);
526         uint scale = bdiv(BConst.BONE, bsub(BConst.BONE, swapFee));
527         return  (spotPrice = bmul(ratio, scale));
528     }
529 
530     /**********************************************************************************************
531     // calcOutGivenIn                                                                            //
532     // aO = tokenAmountOut                                                                       //
533     // bO = tokenBalanceOut                                                                      //
534     // bI = tokenBalanceIn              /      /            bI             \    (wI / wO) \      //
535     // aI = tokenAmountIn    aO = bO * |  1 - | --------------------------  | ^            |     //
536     // wI = tokenWeightIn               \      \ ( bI + ( aI * ( 1 - sF )) /              /      //
537     // wO = tokenWeightOut                                                                       //
538     // sF = swapFee (+ collectedFee)                                                             //
539     **********************************************************************************************/
540     function calcOutGivenIn(
541         uint tokenBalanceIn,
542         uint tokenWeightIn,
543         uint tokenBalanceOut,
544         uint tokenWeightOut,
545         uint tokenAmountIn,
546         uint swapFee
547     )
548         public pure
549         returns (uint tokenAmountOut)
550     {
551         uint weightRatio = bdiv(tokenWeightIn, tokenWeightOut);
552         uint adjustedIn = bsub(BConst.BONE, swapFee);
553         adjustedIn = bmul(tokenAmountIn, adjustedIn);
554         uint y = bdiv(tokenBalanceIn, badd(tokenBalanceIn, adjustedIn));
555         uint foo = bpow(y, weightRatio);
556         uint bar = bsub(BConst.BONE, foo);
557         tokenAmountOut = bmul(tokenBalanceOut, bar);
558         return tokenAmountOut;
559     }
560 
561     /**********************************************************************************************
562     // calcInGivenOut                                                                            //
563     // aI = tokenAmountIn                                                                        //
564     // bO = tokenBalanceOut               /  /     bO      \    (wO / wI)      \                 //
565     // bI = tokenBalanceIn          bI * |  | ------------  | ^            - 1  |                //
566     // aO = tokenAmountOut    aI =        \  \ ( bO - aO ) /                   /                 //
567     // wI = tokenWeightIn           --------------------------------------------                 //
568     // wO = tokenWeightOut                          ( 1 - sF )                                   //
569     // sF = swapFee (+ collectedFee)                                                             //
570     **********************************************************************************************/
571     function calcInGivenOut(
572         uint tokenBalanceIn,
573         uint tokenWeightIn,
574         uint tokenBalanceOut,
575         uint tokenWeightOut,
576         uint tokenAmountOut,
577         uint swapFee
578     )
579         public pure
580         returns (uint tokenAmountIn)
581     {
582         uint weightRatio = bdiv(tokenWeightOut, tokenWeightIn);
583         uint diff = bsub(tokenBalanceOut, tokenAmountOut);
584         uint y = bdiv(tokenBalanceOut, diff);
585         uint foo = bpow(y, weightRatio);
586         foo = bsub(foo, BConst.BONE);
587         tokenAmountIn = bsub(BConst.BONE, swapFee);
588         tokenAmountIn = bdiv(bmul(tokenBalanceIn, foo), tokenAmountIn);
589         return tokenAmountIn;
590     }
591 
592     /**********************************************************************************************
593     // calcPoolOutGivenSingleIn                                                                  //
594     // pAo = poolAmountOut         /                                              \              //
595     // tAi = tokenAmountIn        ///      /     //    wI \      \\       \     wI \             //
596     // wI = tokenWeightIn        //| tAi *| 1 - || 1 - --  | * sF || + tBi \    --  \            //
597     // tW = totalWeight     pAo=||  \      \     \\    tW /      //         | ^ tW   | * pS - pS //
598     // tBi = tokenBalanceIn      \\  ------------------------------------- /        /            //
599     // pS = poolSupply            \\                    tBi               /        /             //
600     // sF = swapFee (+ collectedFee)\                                              /              //
601     **********************************************************************************************/
602     function calcPoolOutGivenSingleIn(
603         uint tokenBalanceIn,
604         uint tokenWeightIn,
605         uint poolSupply,
606         uint totalWeight,
607         uint tokenAmountIn,
608         uint swapFee
609     )
610         public pure
611         returns (uint poolAmountOut)
612     {
613         // @dev Charge the trading fee for the proportion of tokenAi
614         // which is implicitly traded to the other pool tokens.
615         // That proportion is (1- weightTokenIn)
616         // tokenAiAfterFee = tAi * (1 - (1-weightTi) * poolFee);
617         uint normalizedWeight = bdiv(tokenWeightIn, totalWeight);
618         uint zaz = bmul(bsub(BConst.BONE, normalizedWeight), swapFee);
619         uint tokenAmountInAfterFee = bmul(tokenAmountIn, bsub(BConst.BONE, zaz));
620 
621         uint newTokenBalanceIn = badd(tokenBalanceIn, tokenAmountInAfterFee);
622         uint tokenInRatio = bdiv(newTokenBalanceIn, tokenBalanceIn);
623 
624         // uint newPoolSupply = (ratioTi ^ weightTi) * poolSupply;
625         uint poolRatio = bpow(tokenInRatio, normalizedWeight);
626         uint newPoolSupply = bmul(poolRatio, poolSupply);
627         poolAmountOut = bsub(newPoolSupply, poolSupply);
628         return poolAmountOut;
629     }
630 
631     /**********************************************************************************************
632     // calcSingleOutGivenPoolIn                                                                  //
633     // tAo = tokenAmountOut            /      /                                             \\   //
634     // bO = tokenBalanceOut           /      // pS - (pAi * (1 - eF)) \     /    1    \      \\  //
635     // pAi = poolAmountIn            | bO - || ----------------------- | ^ | --------- | * b0 || //
636     // ps = poolSupply                \      \\          pS           /     \(wO / tW)/      //  //
637     // wI = tokenWeightIn      tAo =   \      \                                             //   //
638     // tW = totalWeight                    /     /      wO \       \                             //
639     // sF = swapFee (+ collectedFee)   *  | 1 - |  1 - ---- | * sF  |                            //
640     // eF = exitFee                        \     \      tW /       /                             //
641     **********************************************************************************************/
642     function calcSingleOutGivenPoolIn(
643         uint tokenBalanceOut,
644         uint tokenWeightOut,
645         uint poolSupply,
646         uint totalWeight,
647         uint poolAmountIn,
648         uint swapFee,
649         uint exitFee
650     )
651         public pure
652         returns (uint tokenAmountOut)
653     {
654         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
655         // charge exit fee on the pool token side
656         // pAiAfterExitFee = pAi*(1-exitFee)
657         uint poolAmountInAfterExitFee = bmul(poolAmountIn, bsub(BConst.BONE, exitFee));
658         uint newPoolSupply = bsub(poolSupply, poolAmountInAfterExitFee);
659         uint poolRatio = bdiv(newPoolSupply, poolSupply);
660      
661         // newBalTo = poolRatio^(1/weightTo) * balTo;
662         uint tokenOutRatio = bpow(poolRatio, bdiv(BConst.BONE, normalizedWeight));
663         uint newTokenBalanceOut = bmul(tokenOutRatio, tokenBalanceOut);
664 
665         uint tokenAmountOutBeforeSwapFee = bsub(tokenBalanceOut, newTokenBalanceOut);
666 
667         // charge swap fee on the output token side 
668         //uint tAo = tAoBeforeSwapFee * (1 - (1-weightTo) * swapFee)
669         uint zaz = bmul(bsub(BConst.BONE, normalizedWeight), swapFee);
670         tokenAmountOut = bmul(tokenAmountOutBeforeSwapFee, bsub(BConst.BONE, zaz));
671         return tokenAmountOut;
672     }
673 
674 
675 }
676 
677 interface IBFactory {
678     function collectedToken() external view returns (address);
679 }
680 
681 contract BPoolLite is BToken, BMathLite {
682     struct Record {
683         bool bound;   // is token bound to pool
684         uint index;   // private
685         uint denorm;  // denormalized weight
686         uint balance;
687     }
688 
689     event LOG_SWAP(
690         address indexed caller,
691         address indexed tokenIn,
692         address indexed tokenOut,
693         uint256 tokenAmountIn,
694         uint256 tokenAmountOut
695     );
696 
697     event LOG_JOIN(
698         address indexed caller,
699         address indexed tokenIn,
700         uint256 tokenAmountIn
701     );
702 
703     event LOG_EXIT(
704         address indexed caller,
705         address indexed tokenOut,
706         uint256 tokenAmountOut
707     );
708 
709     event LOG_COLLECTED_FUND(
710         address indexed collectedToken,
711         uint256 collectedAmount
712     );
713 
714     event LOG_FINALIZE(
715         uint swapFee,
716         uint initPoolSupply,
717         uint version,
718         address[] bindTokens,
719         uint[] bindDenorms,
720         uint[] balances
721     );
722 
723     modifier _lock_() {
724         require(!_mutex, "reentry");
725         _mutex = true;
726         _;
727         _mutex = false;
728     }
729 
730     modifier _viewlock_() {
731         require(!_mutex, "reentry");
732         _;
733     }
734 
735     bool private _mutex;
736 
737     uint public version = 2001;
738     address public factory;    // BFactory address to push token exitFee to
739     address public controller; // has CONTROL role
740 
741     // `setSwapFee` and `finalize` require CONTROL
742     // `finalize` sets `PUBLIC can SWAP`, `PUBLIC can JOIN`
743     uint public swapFee;
744     uint public collectedFee; // 0.05% | https://yfv.finance/vip-vote/vip_5
745     uint public exitFee;
746     bool public finalized;
747 
748     address[] internal _tokens;
749     mapping(address => Record) internal _records;
750     uint private _totalWeight;
751 
752     constructor(address _factory) public {
753         controller = _factory;
754         factory = _factory;
755         swapFee = BConst.DEFAULT_FEE;
756         collectedFee = BConst.DEFAULT_COLLECTED_FEE;
757         exitFee = BConst.DEFAULT_EXIT_FEE;
758         finalized = false;
759     }
760 
761     function setCollectedFee(uint _collectedFee) public {
762         require(msg.sender == factory, "!fctr");
763         require(_collectedFee <= BConst.MAX_COLLECTED_FEE, ">maxCoFee");
764         require(bmul(_collectedFee, 2) <= swapFee, ">sFee/2");
765         collectedFee = _collectedFee;
766     }
767 
768     function setExitFee(uint _exitFee) public {
769         require(!finalized, "fnl");
770         require(msg.sender == factory, "!fctr");
771         require(_exitFee <= BConst.MAX_EXIT_FEE, ">maxExitFee");
772         exitFee = _exitFee;
773     }
774 
775     function isBound(address t)
776     external view
777     returns (bool)
778     {
779         return _records[t].bound;
780     }
781 
782     function getNumTokens()
783     external view
784     returns (uint)
785     {
786         return _tokens.length;
787     }
788 
789     function getCurrentTokens()
790     external view _viewlock_
791     returns (address[] memory tokens)
792     {
793         return _tokens;
794     }
795 
796     function getFinalTokens()
797     external view
798     _viewlock_
799     returns (address[] memory tokens)
800     {
801         require(finalized, "!fnl");
802         return _tokens;
803     }
804 
805     function getDenormalizedWeight(address token)
806     external view
807     _viewlock_
808     returns (uint)
809     {
810 
811         require(_records[token].bound, "!bound");
812         return _records[token].denorm;
813     }
814 
815     function getTotalDenormalizedWeight()
816     external view
817     _viewlock_
818     returns (uint)
819     {
820         return _totalWeight;
821     }
822 
823     function getNormalizedWeight(address token)
824     external view
825     _viewlock_
826     returns (uint)
827     {
828 
829         require(_records[token].bound, "!bound");
830         uint denorm = _records[token].denorm;
831         return bdiv(denorm, _totalWeight);
832     }
833 
834     function getBalance(address token)
835     external view
836     _viewlock_
837     returns (uint)
838     {
839 
840         require(_records[token].bound, "!bound");
841         return _records[token].balance;
842     }
843 
844     function setController(address _controller)
845     external
846     _lock_
847     {
848         require(msg.sender == controller, "!cntler");
849         controller = _controller;
850     }
851 
852     function finalize(
853         uint _swapFee,
854         uint _initPoolSupply,
855         address[] calldata _bindTokens,
856         uint[] calldata _bindDenorms
857     ) external _lock_ {
858         require(msg.sender == controller, "!cntler");
859         require(!finalized, "fnl");
860 
861         require(_swapFee >= BConst.MIN_FEE, "<minFee");
862         require(_swapFee <= BConst.MAX_FEE, ">maxFee");
863         swapFee = _swapFee;
864         collectedFee = _swapFee / 3;
865 
866         require(_initPoolSupply >= BConst.MIN_INIT_POOL_SUPPLY, "<minInitPSup");
867         require(_initPoolSupply <= BConst.MAX_INIT_POOL_SUPPLY, ">maxInitPSup");
868 
869         require(_bindTokens.length >= BConst.MIN_BOUND_TOKENS, "<minTokens");
870         require(_bindTokens.length < BConst.MAX_BOUND_TOKENS, ">maxTokens");
871         require(_bindTokens.length == _bindDenorms.length, "erLengMism");
872 
873         uint totalWeight = 0;
874         uint256[] memory balances = new uint[](_bindTokens.length);
875         for (uint i = 0; i < _bindTokens.length; i++) {
876             address token = _bindTokens[i];
877             uint denorm = _bindDenorms[i];
878             uint balance = BToken(token).balanceOf(address(this));
879             balances[i] = balance;
880             require(!_records[token].bound, "bound");
881             require(denorm >= BConst.MIN_WEIGHT, "<minWeight");
882             require(denorm <= BConst.MAX_WEIGHT, ">maxWeight");
883             require(balance >= BConst.MIN_BALANCE, "<minBal");
884             _records[token] = Record({
885                 bound : true,
886                 index : i,
887                 denorm : denorm,
888                 balance : balance
889                 });
890             totalWeight = badd(totalWeight, denorm);
891         }
892         require(totalWeight <= BConst.MAX_TOTAL_WEIGHT, ">maxTWeight");
893         _totalWeight = totalWeight;
894         _tokens = _bindTokens;
895         finalized = true;
896         _mintPoolShare(_initPoolSupply);
897         _pushPoolShare(msg.sender, _initPoolSupply);
898         emit LOG_FINALIZE(swapFee, _initPoolSupply, version, _bindTokens, _bindDenorms, balances);
899     }
900 
901     // Absorb any tokens that have been sent to this contract into the pool
902     function gulp(address token)
903     external
904     _lock_
905     {
906         require(_records[token].bound, "!bound");
907         _records[token].balance = IERC20(token).balanceOf(address(this));
908     }
909 
910     function getSpotPrice(address tokenIn, address tokenOut)
911     external view
912     _viewlock_
913     returns (uint spotPrice)
914     {
915         require(_records[tokenIn].bound, "!bound");
916         require(_records[tokenOut].bound, "!bound");
917         Record storage inRecord = _records[tokenIn];
918         Record storage outRecord = _records[tokenOut];
919         return calcSpotPrice(inRecord.balance, inRecord.denorm, outRecord.balance, outRecord.denorm, swapFee);
920     }
921 
922     function getSpotPriceSansFee(address tokenIn, address tokenOut)
923     external view
924     _viewlock_
925     returns (uint spotPrice)
926     {
927         require(_records[tokenIn].bound, "!bound");
928         require(_records[tokenOut].bound, "!bound");
929         Record storage inRecord = _records[tokenIn];
930         Record storage outRecord = _records[tokenOut];
931         return calcSpotPrice(inRecord.balance, inRecord.denorm, outRecord.balance, outRecord.denorm, 0);
932     }
933 
934     function joinPool(uint poolAmountOut, uint[] calldata maxAmountsIn)
935     external virtual
936     _lock_
937     {
938         require(finalized, "!fnl");
939 
940         uint poolTotal = totalSupply();
941         uint ratio = bdiv(poolAmountOut, poolTotal);
942         require(ratio != 0, "erMApr");
943 
944         for (uint i = 0; i < _tokens.length; i++) {
945             address t = _tokens[i];
946             uint bal = _records[t].balance;
947             uint tokenAmountIn = bmul(ratio, bal);
948             require(tokenAmountIn != 0, "erMApr");
949             require(tokenAmountIn <= maxAmountsIn[i], "<limIn");
950             _records[t].balance = badd(_records[t].balance, tokenAmountIn);
951             emit LOG_JOIN(msg.sender, t, tokenAmountIn);
952             _pullUnderlying(t, msg.sender, tokenAmountIn);
953         }
954         _mintPoolShare(poolAmountOut);
955         _pushPoolShare(msg.sender, poolAmountOut);
956     }
957 
958     function exitPool(uint poolAmountIn, uint[] calldata minAmountsOut)
959     external virtual
960     _lock_
961     {
962         require(finalized, "!fnl");
963 
964         uint poolTotal = totalSupply();
965         uint _exitFee = bmul(poolAmountIn, exitFee);
966         uint pAiAfterExitFee = bsub(poolAmountIn, _exitFee);
967         uint ratio = bdiv(pAiAfterExitFee, poolTotal);
968         require(ratio != 0, "erMApr");
969 
970         _pullPoolShare(msg.sender, poolAmountIn);
971         if (_exitFee > 0) {
972             _pushPoolShare(factory, _exitFee);
973         }
974         _burnPoolShare(pAiAfterExitFee);
975 
976         for (uint i = 0; i < _tokens.length; i++) {
977             address t = _tokens[i];
978             uint bal = _records[t].balance;
979             uint tokenAmountOut = bmul(ratio, bal);
980             require(tokenAmountOut != 0, "erMApr");
981             require(tokenAmountOut >= minAmountsOut[i], "<limO");
982             _records[t].balance = bsub(_records[t].balance, tokenAmountOut);
983             emit LOG_EXIT(msg.sender, t, tokenAmountOut);
984             _pushUnderlying(t, msg.sender, tokenAmountOut);
985         }
986     }
987 
988     function swapExactAmountIn(
989         address tokenIn,
990         uint tokenAmountIn,
991         address tokenOut,
992         uint minAmountOut,
993         uint maxPrice
994     )
995     external
996     _lock_
997     returns (uint tokenAmountOut, uint spotPriceAfter)
998     {
999 
1000         require(_records[tokenIn].bound, "!bound");
1001         require(_records[tokenOut].bound, "!bound");
1002 
1003         Record storage inRecord = _records[address(tokenIn)];
1004         Record storage outRecord = _records[address(tokenOut)];
1005 
1006         require(tokenAmountIn <= bmul(inRecord.balance, BConst.MAX_IN_RATIO), ">maxIRat");
1007 
1008         uint spotPriceBefore = calcSpotPrice(
1009             inRecord.balance,
1010             inRecord.denorm,
1011             outRecord.balance,
1012             outRecord.denorm,
1013             swapFee
1014         );
1015         require(spotPriceBefore <= maxPrice, "badLimPrice");
1016 
1017         tokenAmountOut = calcOutGivenIn(
1018             inRecord.balance,
1019             inRecord.denorm,
1020             outRecord.balance,
1021             outRecord.denorm,
1022             tokenAmountIn,
1023             swapFee
1024         );
1025         require(tokenAmountOut >= minAmountOut, "<limO");
1026 
1027         inRecord.balance = badd(inRecord.balance, tokenAmountIn);
1028         outRecord.balance = bsub(outRecord.balance, tokenAmountOut);
1029 
1030         spotPriceAfter = calcSpotPrice(
1031             inRecord.balance,
1032             inRecord.denorm,
1033             outRecord.balance,
1034             outRecord.denorm,
1035             swapFee
1036         );
1037         require(spotPriceAfter >= spotPriceBefore, "erMApr");
1038         require(spotPriceAfter <= maxPrice, ">limPrice");
1039         require(spotPriceBefore <= bdiv(tokenAmountIn, tokenAmountOut), "erMApr");
1040 
1041         emit LOG_SWAP(msg.sender, tokenIn, tokenOut, tokenAmountIn, tokenAmountOut);
1042 
1043         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1044         uint _subTokenAmountIn;
1045         (_subTokenAmountIn, tokenAmountOut) = _pushCollectedFundGivenOut(tokenIn, tokenAmountIn, tokenOut, tokenAmountOut);
1046         if (_subTokenAmountIn > 0) inRecord.balance = bsub(inRecord.balance, _subTokenAmountIn);
1047         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1048 
1049         return (tokenAmountOut, spotPriceAfter);
1050     }
1051 
1052     function swapExactAmountOut(
1053         address tokenIn,
1054         uint maxAmountIn,
1055         address tokenOut,
1056         uint tokenAmountOut,
1057         uint maxPrice
1058     )
1059     external
1060     _lock_
1061     returns (uint tokenAmountIn, uint spotPriceAfter)
1062     {
1063         require(_records[tokenIn].bound, "!bound");
1064         require(_records[tokenOut].bound, "!bound");
1065 
1066         Record storage inRecord = _records[address(tokenIn)];
1067         Record storage outRecord = _records[address(tokenOut)];
1068 
1069         require(tokenAmountOut <= bmul(outRecord.balance, BConst.MAX_OUT_RATIO), ">maxORat");
1070 
1071         uint spotPriceBefore = calcSpotPrice(
1072             inRecord.balance,
1073             inRecord.denorm,
1074             outRecord.balance,
1075             outRecord.denorm,
1076             swapFee
1077         );
1078         require(spotPriceBefore <= maxPrice, "badLimPrice");
1079 
1080         tokenAmountIn = calcInGivenOut(
1081             inRecord.balance,
1082             inRecord.denorm,
1083             outRecord.balance,
1084             outRecord.denorm,
1085             tokenAmountOut,
1086             swapFee
1087         );
1088         require(tokenAmountIn <= maxAmountIn, "<limIn");
1089 
1090         inRecord.balance = badd(inRecord.balance, tokenAmountIn);
1091         outRecord.balance = bsub(outRecord.balance, tokenAmountOut);
1092 
1093         spotPriceAfter = calcSpotPrice(
1094             inRecord.balance,
1095             inRecord.denorm,
1096             outRecord.balance,
1097             outRecord.denorm,
1098             swapFee
1099         );
1100         require(spotPriceAfter >= spotPriceBefore, "erMApr");
1101         require(spotPriceAfter <= maxPrice, ">limPrice");
1102         require(spotPriceBefore <= bdiv(tokenAmountIn, tokenAmountOut), "erMApr");
1103 
1104         emit LOG_SWAP(msg.sender, tokenIn, tokenOut, tokenAmountIn, tokenAmountOut);
1105 
1106         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1107         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1108         uint _collectedFeeAmount = _pushCollectedFundGivenIn(tokenIn, tokenAmountIn);
1109         if (_collectedFeeAmount > 0) inRecord.balance = bsub(inRecord.balance, _collectedFeeAmount);
1110 
1111         return (tokenAmountIn, spotPriceAfter);
1112     }
1113 
1114     function joinswapExternAmountIn(address tokenIn, uint tokenAmountIn, uint minPoolAmountOut)
1115     external
1116     _lock_
1117     returns (uint poolAmountOut)
1118 
1119     {
1120         require(finalized, "!fnl");
1121         require(_records[tokenIn].bound, "!bound");
1122         require(tokenAmountIn <= bmul(_records[tokenIn].balance, BConst.MAX_IN_RATIO), ">maxIRat");
1123 
1124         Record storage inRecord = _records[tokenIn];
1125 
1126         poolAmountOut = calcPoolOutGivenSingleIn(
1127             inRecord.balance,
1128             inRecord.denorm,
1129             _totalSupply,
1130             _totalWeight,
1131             tokenAmountIn,
1132             swapFee
1133         );
1134 
1135         require(poolAmountOut >= minPoolAmountOut, "<limO");
1136 
1137         inRecord.balance = badd(inRecord.balance, tokenAmountIn);
1138 
1139         emit LOG_JOIN(msg.sender, tokenIn, tokenAmountIn);
1140 
1141         _mintPoolShare(poolAmountOut);
1142         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
1143         uint _subTokenAmountIn;
1144         (_subTokenAmountIn, poolAmountOut) = _pushCollectedFundGivenOut(tokenIn, tokenAmountIn, address(this), poolAmountOut);
1145         if (_subTokenAmountIn > 0) inRecord.balance = bsub(inRecord.balance, _subTokenAmountIn);
1146         _pushPoolShare(msg.sender, poolAmountOut);
1147 
1148         return poolAmountOut;
1149     }
1150 
1151     function exitswapPoolAmountIn(address tokenOut, uint poolAmountIn, uint minAmountOut)
1152     external
1153     _lock_
1154     returns (uint tokenAmountOut)
1155     {
1156         require(finalized, "!fnl");
1157         require(_records[tokenOut].bound, "!bound");
1158 
1159         Record storage outRecord = _records[tokenOut];
1160 
1161         tokenAmountOut = calcSingleOutGivenPoolIn(
1162             outRecord.balance,
1163             outRecord.denorm,
1164             _totalSupply,
1165             _totalWeight,
1166             poolAmountIn,
1167             swapFee,
1168             exitFee
1169         );
1170 
1171         require(tokenAmountOut >= minAmountOut, "<limO");
1172 
1173         require(tokenAmountOut <= bmul(_records[tokenOut].balance, BConst.MAX_OUT_RATIO), ">maxORat");
1174 
1175         outRecord.balance = bsub(outRecord.balance, tokenAmountOut);
1176 
1177         uint _exitFee = bmul(poolAmountIn, exitFee);
1178 
1179         emit LOG_EXIT(msg.sender, tokenOut, tokenAmountOut);
1180 
1181         _pullPoolShare(msg.sender, poolAmountIn);
1182         _burnPoolShare(bsub(poolAmountIn, _exitFee));
1183         if (_exitFee > 0) {
1184             _pushPoolShare(factory, _exitFee);
1185         }
1186         (, tokenAmountOut) = _pushCollectedFundGivenOut(address(this), poolAmountIn, tokenOut, tokenAmountOut);
1187         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
1188 
1189         return tokenAmountOut;
1190     }
1191 
1192     // ==
1193     // 'Underlying' token-manipulation functions make external calls but are NOT locked
1194     // You must `_lock_` or otherwise ensure reentry-safety
1195     //
1196     // Fixed ERC-20 transfer revert for some special token such as USDT
1197     function _pullUnderlying(address erc20, address from, uint amount) internal {
1198         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
1199         (bool success, bytes memory data) = erc20.call(abi.encodeWithSelector(0x23b872dd, from, address(this), amount));
1200         require(success && (data.length == 0 || abi.decode(data, (bool))), '!_pullU');
1201     }
1202 
1203     function _pushUnderlying(address erc20, address to, uint amount) internal
1204     {
1205         // bytes4(keccak256(bytes('transfer(address,uint256)')));
1206         (bool success, bytes memory data) = erc20.call(abi.encodeWithSelector(0xa9059cbb, to, amount));
1207         require(success && (data.length == 0 || abi.decode(data, (bool))), '!_pushU');
1208     }
1209 
1210     function _pullPoolShare(address from, uint amount)
1211     internal
1212     {
1213         _pull(from, amount);
1214     }
1215 
1216     function _pushPoolShare(address to, uint amount)
1217     internal
1218     {
1219         _push(to, amount);
1220     }
1221 
1222     function _mintPoolShare(uint amount)
1223     internal
1224     {
1225         _mint(amount);
1226     }
1227 
1228     function _burnPoolShare(uint amount)
1229     internal
1230     {
1231         _burn(amount);
1232     }
1233 
1234     function _pushCollectedFundGivenOut(address _tokenIn, uint _tokenAmountIn, address _tokenOut, uint _tokenAmountOut) internal returns (uint subTokenAmountIn, uint tokenAmountOut) {
1235         subTokenAmountIn = 0;
1236         tokenAmountOut = _tokenAmountOut;
1237         if (collectedFee > 0) {
1238             address _collectedToken = IBFactory(factory).collectedToken();
1239             if (_collectedToken == _tokenIn) {
1240                 subTokenAmountIn = bdiv(bmul(_tokenAmountIn, collectedFee), BConst.BONE);
1241                 _pushUnderlying(_tokenIn, factory, subTokenAmountIn);
1242                 emit LOG_COLLECTED_FUND(_tokenIn, subTokenAmountIn);
1243             } else {
1244                 uint _collectedFeeAmount = bdiv(bmul(_tokenAmountOut, collectedFee), BConst.BONE);
1245                 _pushUnderlying(_tokenOut, factory, _collectedFeeAmount);
1246                 tokenAmountOut = bsub(_tokenAmountOut, _collectedFeeAmount);
1247                 emit LOG_COLLECTED_FUND(_tokenOut, _collectedFeeAmount);
1248             }
1249         }
1250     }
1251 
1252     // always push out _tokenIn (already have)
1253     function _pushCollectedFundGivenIn(address _tokenIn, uint _tokenAmountIn) internal returns (uint collectedFeeAmount) {
1254         collectedFeeAmount = 0;
1255         if (collectedFee > 0) {
1256             address _collectedToken = IBFactory(factory).collectedToken();
1257             if (_collectedToken != address(0)) {
1258                 collectedFeeAmount = bdiv(bmul(_tokenAmountIn, collectedFee), BConst.BONE);
1259                 _pushUnderlying(_tokenIn, factory, collectedFeeAmount);
1260                 emit LOG_COLLECTED_FUND(_tokenIn, collectedFeeAmount);
1261             }
1262         }
1263     }
1264 }
1265 
1266 interface IFaaSPool {
1267     function stake(uint) external;
1268     function withdraw(uint) external;
1269     function getReward(uint8 _pid, address _account) external;
1270     function getAllRewards(address _account) external;
1271     function pendingReward(uint8 _pid, address _account) external view returns (uint);
1272     function emergencyWithdraw() external;
1273 }
1274 
1275 interface IFaaSRewardFund {
1276     function balance(IERC20 _token) external view returns (uint);
1277     function safeTransfer(IERC20 _token, address _to, uint _value) external;
1278 }
1279 
1280 // This implements BPool contract, and allows for generalized staking, yield farming, and token distribution.
1281 contract FaaSPoolLite is BPoolLite, IFaaSPool {
1282     using SafeMath for uint;
1283 
1284     // Info of each user.
1285     struct UserInfo {
1286         uint amount;
1287         mapping(uint8 => uint) rewardDebt;
1288         mapping(uint8 => uint) accumulatedEarned; // will accumulate every time user harvest
1289         mapping(uint8 => uint) lockReward;
1290         mapping(uint8 => uint) lockRewardReleased;
1291         uint lastStakeTime;
1292     }
1293 
1294     // Info of each rewardPool funding.
1295     struct RewardPoolInfo {
1296         IERC20 rewardToken;     // Address of rewardPool token contract.
1297         uint lastRewardBlock;   // Last block number that rewardPool distribution occurs.
1298         uint endRewardBlock;    // Block number which rewardPool distribution ends.
1299         uint rewardPerBlock;    // Reward token amount to distribute per block.
1300         uint accRewardPerShare; // Accumulated rewardPool per share, times 1e18.
1301 
1302         uint lockRewardPercent; // Lock reward percent - 0 to disable lock & vesting
1303         uint startVestingBlock; // Block number which vesting starts.
1304         uint endVestingBlock;   // Block number which vesting ends.
1305         uint numOfVestingBlocks;
1306 
1307         uint totalPaidRewards;
1308     }
1309 
1310     mapping(address => UserInfo) private userInfo;
1311     RewardPoolInfo[] public rewardPoolInfo;
1312 
1313     IFaaSRewardFund public rewardFund;
1314     address public exchangeProxy;
1315     uint public unstakingFrozenTime = 0 days;
1316 
1317     event Deposit(address indexed account, uint256 amount);
1318     event Withdraw(address indexed account, uint256 amount);
1319     event RewardPaid(uint8 pid, address indexed account, uint256 amount);
1320 
1321     constructor(address _factory) public BPoolLite(_factory) {
1322     }
1323 
1324     modifier onlyController() {
1325         require(msg.sender == controller, "!cntler");
1326         _;
1327     }
1328 
1329     function finalizeRewardFundInfo(IFaaSRewardFund _rewardFund, uint _unstakingFrozenTime) external onlyController {
1330         require(address(rewardFund) == address(0), "rewardFund!=null");
1331         assert(unstakingFrozenTime <= 30 days);
1332         // do not lock fund for too long, please!
1333         unstakingFrozenTime = _unstakingFrozenTime;
1334         rewardFund = _rewardFund;
1335     }
1336 
1337     function setExchangeProxy(address _exchangeProxy) public onlyController {
1338         exchangeProxy = _exchangeProxy;
1339     }
1340 
1341     function addRewardPool(IERC20 _rewardToken, uint256 _startBlock, uint256 _endRewardBlock, uint256 _rewardPerBlock,
1342         uint256 _lockRewardPercent, uint256 _startVestingBlock, uint256 _endVestingBlock) external onlyController {
1343         require(rewardPoolInfo.length < 8, "exceed rwdPoolLim");
1344         require(_startVestingBlock <= _endVestingBlock, "sVB>eVB");
1345         _startBlock = (block.number > _startBlock) ? block.number : _startBlock;
1346         require(_startBlock < _endRewardBlock, "sB>=eB");
1347         updateReward();
1348         rewardPoolInfo.push(RewardPoolInfo({
1349             rewardToken : _rewardToken,
1350             lastRewardBlock : _startBlock,
1351             endRewardBlock : _endRewardBlock,
1352             rewardPerBlock : _rewardPerBlock,
1353             accRewardPerShare : 0,
1354             lockRewardPercent : _lockRewardPercent,
1355             startVestingBlock : _startVestingBlock,
1356             endVestingBlock : _endVestingBlock,
1357             numOfVestingBlocks: _endVestingBlock - _startVestingBlock,
1358             totalPaidRewards: 0
1359             }));
1360     }
1361 
1362     function updateRewardPool(uint8 _pid, uint256 _endRewardBlock, uint256 _rewardPerBlock) public onlyController {
1363         updateReward(_pid);
1364         RewardPoolInfo storage rewardPool = rewardPoolInfo[_pid];
1365         require(block.number <= rewardPool.endRewardBlock, "late");
1366         rewardPool.endRewardBlock = _endRewardBlock;
1367         rewardPool.rewardPerBlock = _rewardPerBlock;
1368     }
1369 
1370     function joinPool(uint poolAmountOut, uint[] calldata maxAmountsIn) external override {
1371         joinPoolFor(msg.sender, poolAmountOut, maxAmountsIn);
1372     }
1373 
1374     function joinPoolFor(address account, uint poolAmountOut, uint[] calldata maxAmountsIn) public _lock_ {
1375         require(msg.sender == account || msg.sender == exchangeProxy, "!(prx||own)");
1376         _joinPool(account, poolAmountOut, maxAmountsIn);
1377         _stakePoolShare(account, poolAmountOut);
1378     }
1379 
1380     function joinPoolNotStake(uint poolAmountOut, uint[] calldata maxAmountsIn) external _lock_ {
1381         _joinPool(msg.sender, poolAmountOut, maxAmountsIn);
1382         _pushPoolShare(msg.sender, poolAmountOut);
1383     }
1384 
1385     function _joinPool(address account, uint poolAmountOut, uint[] calldata maxAmountsIn) internal {
1386         require(finalized, "!fnl");
1387 
1388         uint rewardTotal = totalSupply();
1389         uint ratio = bdiv(poolAmountOut, rewardTotal);
1390         require(ratio != 0, "erMApr");
1391 
1392         for (uint i = 0; i < _tokens.length; i++) {
1393             address t = _tokens[i];
1394             uint bal = _records[t].balance;
1395             uint tokenAmountIn = bmul(ratio, bal);
1396             require(tokenAmountIn != 0 && tokenAmountIn <= maxAmountsIn[i], "erMApr||<limIn");
1397             _records[t].balance = badd(_records[t].balance, tokenAmountIn);
1398             emit LOG_JOIN(account, t, tokenAmountIn);
1399             _pullUnderlying(t, msg.sender, tokenAmountIn);
1400         }
1401         _mintPoolShare(poolAmountOut);
1402     }
1403 
1404     function stake(uint _shares) external override {
1405         uint _before = balanceOf(address(this));
1406         _pullPoolShare(msg.sender, _shares);
1407         uint _after = balanceOf(address(this));
1408         _shares = bsub(_after, _before); // Additional check for deflationary tokens
1409         _stakePoolShare(msg.sender, _shares);
1410     }
1411 
1412     function _stakePoolShare(address _account, uint _shares) internal {
1413         UserInfo storage user = userInfo[_account];
1414         getAllRewards(_account);
1415         user.amount = user.amount.add(_shares);
1416         uint8 rewardPoolLength = uint8(rewardPoolInfo.length);
1417         for (uint8 _pid = 0; _pid < rewardPoolLength; ++_pid) {
1418             user.rewardDebt[_pid] = user.amount.mul(rewardPoolInfo[_pid].accRewardPerShare).div(1e18);
1419         }
1420         user.lastStakeTime = block.timestamp;
1421         emit Deposit(_account, _shares);
1422     }
1423 
1424     function unfrozenStakeTime(address _account) public view returns (uint) {
1425         return userInfo[_account].lastStakeTime + unstakingFrozenTime;
1426     }
1427 
1428     function withdraw(uint _amount) public override {
1429         UserInfo storage user = userInfo[msg.sender];
1430         require(user.amount >= _amount, "am>us.am");
1431         require(block.timestamp >= user.lastStakeTime.add(unstakingFrozenTime), "frozen");
1432         getAllRewards(msg.sender);
1433         user.amount = bsub(user.amount, _amount);
1434         uint8 rewardPoolLength = uint8(rewardPoolInfo.length);
1435         for (uint8 _pid = 0; _pid < rewardPoolLength; ++_pid) {
1436             user.rewardDebt[_pid] = user.amount.mul(rewardPoolInfo[_pid].accRewardPerShare).div(1e18);
1437         }
1438         _pushPoolShare(msg.sender, _amount);
1439         emit Withdraw(msg.sender, _amount);
1440     }
1441 
1442     // using PUSH pattern for using by Proxy if needed
1443     function getAllRewards(address _account) public override {
1444         uint8 rewardPoolLength = uint8(rewardPoolInfo.length);
1445         for (uint8 _pid = 0; _pid < rewardPoolLength; ++_pid) {
1446             getReward(_pid, _account);
1447         }
1448     }
1449 
1450     function getReward(uint8 _pid, address _account) public override {
1451         updateReward(_pid);
1452         UserInfo storage user = userInfo[_account];
1453         RewardPoolInfo storage rewardPool = rewardPoolInfo[_pid];
1454         uint _pendingReward = user.amount.mul(rewardPool.accRewardPerShare).div(1e18).sub(user.rewardDebt[_pid]);
1455         uint _lockRewardPercent = rewardPool.lockRewardPercent;
1456         if (_lockRewardPercent > 0) {
1457             if (block.number > rewardPool.endVestingBlock) {
1458                 uint _unlockReward = user.lockReward[_pid].sub(user.lockRewardReleased[_pid]);
1459                 if (_unlockReward > 0) {
1460                     _pendingReward = _pendingReward.add(_unlockReward);
1461                     user.lockRewardReleased[_pid] = user.lockRewardReleased[_pid].add(_unlockReward);
1462                 }
1463             } else {
1464                 if (_pendingReward > 0) {
1465                     uint _toLocked = _pendingReward.mul(_lockRewardPercent).div(100);
1466                     _pendingReward = _pendingReward.sub(_toLocked);
1467                     user.lockReward[_pid] = user.lockReward[_pid].add(_toLocked);
1468                 }
1469                 if (block.number > rewardPool.startVestingBlock) {
1470                     uint _toReleased = user.lockReward[_pid].mul(block.number.sub(rewardPool.startVestingBlock)).div(rewardPool.numOfVestingBlocks);
1471                     uint _lockRewardReleased = user.lockRewardReleased[_pid];
1472                     if (_toReleased > _lockRewardReleased) {
1473                         uint _unlockReward = _toReleased.sub(_lockRewardReleased);
1474                         user.lockRewardReleased[_pid] = _lockRewardReleased.add(_unlockReward);
1475                         _pendingReward = _pendingReward.add(_unlockReward);
1476                     }
1477                 }
1478             }
1479         }
1480         if (_pendingReward > 0) {
1481             user.accumulatedEarned[_pid] = user.accumulatedEarned[_pid].add(_pendingReward);
1482             rewardPool.totalPaidRewards = rewardPool.totalPaidRewards.add(_pendingReward);
1483             rewardFund.safeTransfer(rewardPool.rewardToken, _account, _pendingReward);
1484             emit RewardPaid(_pid, _account, _pendingReward);
1485             user.rewardDebt[_pid] = user.amount.mul(rewardPoolInfo[_pid].accRewardPerShare).div(1e18);
1486         }
1487     }
1488 
1489     function pendingReward(uint8 _pid, address _account) public override view returns (uint _pending) {
1490         UserInfo storage user = userInfo[_account];
1491         RewardPoolInfo storage rewardPool = rewardPoolInfo[_pid];
1492         uint _accRewardPerShare = rewardPool.accRewardPerShare;
1493         uint lpSupply = balanceOf(address(this));
1494         uint _endRewardBlockApplicable = block.number > rewardPool.endRewardBlock ? rewardPool.endRewardBlock : block.number;
1495         if (_endRewardBlockApplicable > rewardPool.lastRewardBlock && lpSupply != 0) {
1496             uint _numBlocks = _endRewardBlockApplicable.sub(rewardPool.lastRewardBlock);
1497             uint _incRewardPerShare = _numBlocks.mul(rewardPool.rewardPerBlock).mul(1e18).div(lpSupply);
1498             _accRewardPerShare = _accRewardPerShare.add(_incRewardPerShare);
1499         }
1500         _pending = user.amount.mul(_accRewardPerShare).div(1e18).sub(user.rewardDebt[_pid]);
1501     }
1502 
1503     // Withdraw without caring about rewards. EMERGENCY ONLY.
1504     function emergencyWithdraw() external override {
1505         UserInfo storage user = userInfo[msg.sender];
1506         uint _amount = user.amount;
1507         _pushPoolShare(msg.sender, _amount);
1508         user.amount = 0;
1509         uint8 rewardPoolLength = uint8(rewardPoolInfo.length);
1510         for (uint8 _pid = 0; _pid < rewardPoolLength; ++_pid) {
1511             user.rewardDebt[_pid] = 0;
1512         }
1513         emit Withdraw(msg.sender, _amount);
1514     }
1515 
1516     function getUserInfo(uint8 _pid, address _account) public view returns (uint amount, uint rewardDebt, uint accumulatedEarned, uint lockReward, uint lockRewardReleased) {
1517         UserInfo storage user = userInfo[_account];
1518         amount = user.amount;
1519         rewardDebt = user.rewardDebt[_pid];
1520         accumulatedEarned = user.accumulatedEarned[_pid];
1521         lockReward = user.lockReward[_pid];
1522         lockRewardReleased = user.lockRewardReleased[_pid];
1523     }
1524 
1525     function exitPool(uint poolAmountIn, uint[] calldata minAmountsOut) external override _lock_ {
1526         require(finalized, "!fnl");
1527 
1528         uint rewardTotal = totalSupply();
1529         uint _exitFee = bmul(poolAmountIn, exitFee);
1530         uint pAiAfterExitFee = bsub(poolAmountIn, _exitFee);
1531         uint ratio = bdiv(pAiAfterExitFee, rewardTotal);
1532         require(ratio != 0, "erMApr");
1533 
1534         uint _externalShares = balanceOf(msg.sender);
1535         if (_externalShares < poolAmountIn) {
1536             uint _withdrawShares = bsub(poolAmountIn, _externalShares);
1537             uint _stakedShares = userInfo[msg.sender].amount;
1538             require(_stakedShares >= _withdrawShares, "stk<wdr");
1539             withdraw(_withdrawShares);
1540         }
1541 
1542         _pullPoolShare(msg.sender, poolAmountIn);
1543         if (_exitFee > 0) {
1544             _pushPoolShare(factory, _exitFee);
1545         }
1546         _burnPoolShare(pAiAfterExitFee);
1547 
1548         for (uint i = 0; i < _tokens.length; i++) {
1549             address t = _tokens[i];
1550             uint bal = _records[t].balance;
1551             uint tokenAmountOut = bmul(ratio, bal);
1552             require(tokenAmountOut != 0, "erMApr");
1553             require(tokenAmountOut >= minAmountsOut[i], "<limO");
1554             _records[t].balance = bsub(_records[t].balance, tokenAmountOut);
1555             emit LOG_EXIT(msg.sender, t, tokenAmountOut);
1556             _pushUnderlying(t, msg.sender, tokenAmountOut);
1557         }
1558     }
1559 
1560     function updateReward() public {
1561         uint8 rewardPoolLength = uint8(rewardPoolInfo.length);
1562         for (uint8 _pid = 0; _pid < rewardPoolLength; ++_pid) {
1563             updateReward(_pid);
1564         }
1565     }
1566 
1567     function updateReward(uint8 _pid) public {
1568         RewardPoolInfo storage rewardPool = rewardPoolInfo[_pid];
1569         uint _endRewardBlockApplicable = block.number > rewardPool.endRewardBlock ? rewardPool.endRewardBlock : block.number;
1570         if (_endRewardBlockApplicable > rewardPool.lastRewardBlock) {
1571             uint lpSupply = balanceOf(address(this));
1572             if (lpSupply > 0) {
1573                 uint _numBlocks = _endRewardBlockApplicable.sub(rewardPool.lastRewardBlock);
1574                 uint _incRewardPerShare = _numBlocks.mul(rewardPool.rewardPerBlock).mul(1e18).div(lpSupply);
1575                 rewardPool.accRewardPerShare = rewardPool.accRewardPerShare.add(_incRewardPerShare);
1576             }
1577             rewardPool.lastRewardBlock = _endRewardBlockApplicable;
1578         }
1579     }
1580 }