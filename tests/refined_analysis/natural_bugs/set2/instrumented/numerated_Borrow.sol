1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from '../interfaces/IConvenience.sol';
5 import {IFactory} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IFactory.sol';
6 import {IWETH} from '../interfaces/IWETH.sol';
7 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
8 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
9 import {IBorrow} from '../interfaces/IBorrow.sol';
10 import {BorrowMath} from './BorrowMath.sol';
11 import {Deploy} from './Deploy.sol';
12 import {MsgValue} from './MsgValue.sol';
13 import {ETH} from './ETH.sol';
14 
15 library Borrow {
16     using BorrowMath for IPair;
17     using Deploy for IConvenience.Native;
18 
19     function borrowGivenDebt(
20         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
21         IConvenience convenience,
22         IFactory factory,
23         IBorrow.BorrowGivenDebt calldata params
24     )
25         external
26         returns (
27             uint256 assetOut,
28             uint256 id,
29             IPair.Due memory dueOut
30         )
31     {
32         (assetOut, id, dueOut) = _borrowGivenDebt(
33             natives,
34             IBorrow._BorrowGivenDebt(
35                 convenience,
36                 factory,
37                 params.asset,
38                 params.collateral,
39                 params.maturity,
40                 msg.sender,
41                 params.assetTo,
42                 params.dueTo,
43                 params.assetOut,
44                 params.debtIn,
45                 params.maxCollateral,
46                 params.deadline
47             )
48         );
49     }
50 
51     function borrowGivenDebtETHAsset(
52         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
53         IConvenience convenience,
54         IFactory factory,
55         IWETH weth,
56         IBorrow.BorrowGivenDebtETHAsset calldata params
57     )
58         external
59         returns (
60             uint256 assetOut,
61             uint256 id,
62             IPair.Due memory dueOut
63         )
64     {
65         (assetOut, id, dueOut) = _borrowGivenDebt(
66             natives,
67             IBorrow._BorrowGivenDebt(
68                 convenience,
69                 factory,
70                 weth,
71                 params.collateral,
72                 params.maturity,
73                 msg.sender,
74                 address(this),
75                 params.dueTo,
76                 params.assetOut,
77                 params.debtIn,
78                 params.maxCollateral,
79                 params.deadline
80             )
81         );
82 
83         weth.withdraw(params.assetOut);
84         ETH.transfer(params.assetTo, params.assetOut);
85     }
86 
87     function borrowGivenDebtETHCollateral(
88         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
89         IConvenience convenience,
90         IFactory factory,
91         IWETH weth,
92         IBorrow.BorrowGivenDebtETHCollateral calldata params
93     )
94         external
95         returns (
96             uint256 assetOut,
97             uint256 id,
98             IPair.Due memory dueOut
99         )
100     {
101         uint112 maxCollateral = MsgValue.getUint112();
102 
103         (assetOut, id, dueOut) = _borrowGivenDebt(
104             natives,
105             IBorrow._BorrowGivenDebt(
106                 convenience,
107                 factory,
108                 params.asset,
109                 weth,
110                 params.maturity,
111                 address(this),
112                 params.assetTo,
113                 params.dueTo,
114                 params.assetOut,
115                 params.debtIn,
116                 maxCollateral,
117                 params.deadline
118             )
119         );
120 
121         if (maxCollateral > dueOut.collateral) {
122             uint256 excess;
123             unchecked {
124                 excess -= dueOut.collateral;
125             }
126             ETH.transfer(payable(msg.sender), excess);
127         }
128     }
129 
130     function borrowGivenCollateral(
131         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
132         IConvenience convenience,
133         IFactory factory,
134         IBorrow.BorrowGivenCollateral calldata params
135     )
136         external
137         returns (
138             uint256 assetOut,
139             uint256 id,
140             IPair.Due memory dueOut
141         )
142     {
143         (assetOut, id, dueOut) = _borrowGivenCollateral(
144             natives,
145             IBorrow._BorrowGivenCollateral(
146                 convenience,
147                 factory,
148                 params.asset,
149                 params.collateral,
150                 params.maturity,
151                 msg.sender,
152                 params.assetTo,
153                 params.dueTo,
154                 params.assetOut,
155                 params.collateralIn,
156                 params.maxDebt,
157                 params.deadline
158             )
159         );
160     }
161 
162     function borrowGivenCollateralETHAsset(
163         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
164         IConvenience convenience,
165         IFactory factory,
166         IWETH weth,
167         IBorrow.BorrowGivenCollateralETHAsset calldata params
168     )
169         external
170         returns (
171             uint256 assetOut,
172             uint256 id,
173             IPair.Due memory dueOut
174         )
175     {
176         (assetOut, id, dueOut) = _borrowGivenCollateral(
177             natives,
178             IBorrow._BorrowGivenCollateral(
179                 convenience,
180                 factory,
181                 weth,
182                 params.collateral,
183                 params.maturity,
184                 msg.sender,
185                 address(this),
186                 params.dueTo,
187                 params.assetOut,
188                 params.collateralIn,
189                 params.maxDebt,
190                 params.deadline
191             )
192         );
193 
194         weth.withdraw(assetOut);
195         ETH.transfer(payable(params.assetTo), assetOut);
196     }
197 
198     function borrowGivenCollateralETHCollateral(
199         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
200         IConvenience convenience,
201         IFactory factory,
202         IWETH weth,
203         IBorrow.BorrowGivenCollateralETHCollateral calldata params
204     )
205         external
206         returns (
207             uint256 assetOut,
208             uint256 id,
209             IPair.Due memory dueOut
210         )
211     {
212         uint112 collateralIn = MsgValue.getUint112();
213 
214         (assetOut, id, dueOut) = _borrowGivenCollateral(
215             natives,
216             IBorrow._BorrowGivenCollateral(
217                 convenience,
218                 factory,
219                 params.asset,
220                 weth,
221                 params.maturity,
222                 address(this),
223                 params.assetTo,
224                 params.dueTo,
225                 params.assetOut,
226                 collateralIn,
227                 params.maxDebt,
228                 params.deadline
229             )
230         );
231 
232         if (collateralIn > dueOut.collateral) {
233             uint256 excess = collateralIn;
234             unchecked {
235                 excess -= dueOut.collateral;
236             }
237             ETH.transfer(payable(msg.sender), excess);
238         }
239     }
240 
241     function borrowGivenPercent(
242         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
243         IConvenience convenience,
244         IFactory factory,
245         IBorrow.BorrowGivenPercent calldata params
246     )
247         external
248         returns (
249             uint256 assetOut,
250             uint256 id,
251             IPair.Due memory dueOut
252         )
253     {
254         (assetOut, id, dueOut) = _borrowGivenPercent(
255             natives,
256             IBorrow._BorrowGivenPercent(
257                 convenience,
258                 factory,
259                 params.asset,
260                 params.collateral,
261                 params.maturity,
262                 msg.sender,
263                 params.assetTo,
264                 params.dueTo,
265                 params.assetOut,
266                 params.percent,
267                 params.maxDebt,
268                 params.maxCollateral,
269                 params.deadline
270             )
271         );
272     }
273 
274     function borrowGivenPercentETHAsset(
275         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
276         IConvenience convenience,
277         IFactory factory,
278         IWETH weth,
279         IBorrow.BorrowGivenPercentETHAsset calldata params
280     )
281         external
282         returns (
283             uint256 assetOut,
284             uint256 id,
285             IPair.Due memory dueOut
286         )
287     {
288         (assetOut, id, dueOut) = _borrowGivenPercent(
289             natives,
290             IBorrow._BorrowGivenPercent(
291                 convenience,
292                 factory,
293                 weth,
294                 params.collateral,
295                 params.maturity,
296                 msg.sender,
297                 address(this),
298                 params.dueTo,
299                 params.assetOut,
300                 params.percent,
301                 params.maxDebt,
302                 params.maxCollateral,
303                 params.deadline
304             )
305         );
306 
307         weth.withdraw(assetOut);
308         ETH.transfer(params.assetTo, assetOut);
309     }
310 
311     function borrowGivenPercentETHCollateral(
312         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
313         IConvenience convenience,
314         IFactory factory,
315         IWETH weth,
316         IBorrow.BorrowGivenPercentETHCollateral calldata params
317     )
318         external
319         returns (
320             uint256 assetOut,
321             uint256 id,
322             IPair.Due memory dueOut
323         )
324     {
325         uint112 maxCollateral = MsgValue.getUint112();
326 
327         (assetOut, id, dueOut) = _borrowGivenPercent(
328             natives,
329             IBorrow._BorrowGivenPercent(
330                 convenience,
331                 factory,
332                 params.asset,
333                 weth,
334                 params.maturity,
335                 address(this),
336                 params.assetTo,
337                 params.dueTo,
338                 params.assetOut,
339                 params.percent,
340                 params.maxDebt,
341                 maxCollateral,
342                 params.deadline
343             )
344         );
345 
346         if (maxCollateral > dueOut.collateral) {
347             uint256 excess = maxCollateral;
348             unchecked {
349                 excess -= dueOut.collateral;
350             }
351             ETH.transfer(payable(msg.sender), excess);
352         }
353     }
354 
355     function _borrowGivenDebt(
356         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
357         IBorrow._BorrowGivenDebt memory params
358     )
359         private
360         returns (
361             uint256 assetOut,
362             uint256 id,
363             IPair.Due memory dueOut
364         )
365     {
366         require(params.debtIn > params.assetOut, 'E518');
367 
368         IPair pair = params.factory.getPair(params.asset, params.collateral);
369         require(address(pair) != address(0), 'E501');
370 
371         (uint112 xDecrease, uint112 yIncrease, uint112 zIncrease) = pair.givenDebt(
372             params.maturity,
373             params.assetOut,
374             params.debtIn
375         );
376 
377         (assetOut, id, dueOut) = _borrow(
378             natives,
379             IBorrow._Borrow(
380                 params.convenience,
381                 pair,
382                 params.asset,
383                 params.collateral,
384                 params.maturity,
385                 params.from,
386                 params.assetTo,
387                 params.dueTo,
388                 xDecrease,
389                 yIncrease,
390                 zIncrease,
391                 params.deadline
392             )
393         );
394 
395         require(dueOut.collateral <= params.maxCollateral, 'E513');
396     }
397 
398     function _borrowGivenCollateral(
399         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
400         IBorrow._BorrowGivenCollateral memory params
401     )
402         private
403         returns (
404             uint256 assetOut,
405             uint256 id,
406             IPair.Due memory dueOut
407         )
408     {
409         IPair pair = params.factory.getPair(params.asset, params.collateral);
410         require(address(pair) != address(0), 'E501');
411 
412         (uint112 xDecrease, uint112 yIncrease, uint112 zIncrease) = pair.givenCollateral(
413             params.maturity,
414             params.assetOut,
415             params.collateralIn
416         );
417 
418         (assetOut, id, dueOut) = _borrow(
419             natives,
420             IBorrow._Borrow(
421                 params.convenience,
422                 pair,
423                 params.asset,
424                 params.collateral,
425                 params.maturity,
426                 params.from,
427                 params.assetTo,
428                 params.dueTo,
429                 xDecrease,
430                 yIncrease,
431                 zIncrease,
432                 params.deadline
433             )
434         );
435 
436         require(dueOut.debt <= params.maxDebt, 'E512');
437     }
438 
439     function _borrowGivenPercent(
440         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
441         IBorrow._BorrowGivenPercent memory params
442     )
443         private
444         returns (
445             uint256 assetOut,
446             uint256 id,
447             IPair.Due memory dueOut
448         )
449     {
450         require(params.percent <= 0x100000000, 'E505');
451 
452         IPair pair = params.factory.getPair(params.asset, params.collateral);
453         require(address(pair) != address(0), 'E501');
454 
455         (uint112 xDecrease, uint112 yIncrease, uint112 zIncrease) = pair.givenPercent(
456             params.maturity,
457             params.assetOut,
458             params.percent
459         );
460 
461         (assetOut, id, dueOut) = _borrow(
462             natives,
463             IBorrow._Borrow(
464                 params.convenience,
465                 pair,
466                 params.asset,
467                 params.collateral,
468                 params.maturity,
469                 params.from,
470                 params.assetTo,
471                 params.dueTo,
472                 xDecrease,
473                 yIncrease,
474                 zIncrease,
475                 params.deadline
476             )
477         );
478 
479 
480         require(dueOut.debt <= params.maxDebt, 'E512');
481         require(dueOut.collateral <= params.maxCollateral, 'E513');
482     }
483 
484     function _borrow(
485         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
486         IBorrow._Borrow memory params
487     )
488         private
489         returns (
490             uint256 assetOut,
491             uint256 id,
492             IPair.Due memory dueOut
493         )
494     {
495         require(params.deadline >= block.timestamp, 'E504');
496         require(params.maturity > block.timestamp, 'E508');
497 
498         IConvenience.Native storage native = natives[params.asset][params.collateral][params.maturity];
499         if (address(native.liquidity) == address(0))
500             native.deploy(params.convenience, params.pair, params.asset, params.collateral, params.maturity);
501 
502         (assetOut, id, dueOut) = params.pair.borrow(
503             IPair.BorrowParam(
504                 params.maturity,
505                 params.assetTo,
506                 address(this),
507                 params.xDecrease,
508                 params.yIncrease,
509                 params.zIncrease,
510                 bytes(abi.encode(params.asset, params.collateral, params.from))
511             )
512         );
513 
514         native.collateralizedDebt.mint(params.dueTo, id);
515     }
516 }
