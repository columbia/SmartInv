1 /*
2  * CollateralMonitor
3  *
4  * This contract reports aggregated issuance
5  * and collateralisation statistics for the 
6  * Havven stablecoin system.
7  * 
8  * Author: Anton Jurisevic
9  * Date: 14/06/2018
10  * Version: nUSDa 1.0
11  */
12 
13 pragma solidity ^0.4.24;
14 
15 
16 contract Havven {
17     uint public price;
18     uint public issuanceRatio;
19     mapping(address => uint) public nominsIssued;
20     function balanceOf(address account) public view returns (uint);
21     function totalSupply() public view returns (uint);
22     function availableHavvens(address account) public view returns (uint);
23 }
24 
25 contract Nomin {
26     function totalSupply() public view returns (uint);
27 }
28 
29 contract HavvenEscrow {
30     function balanceOf(address account) public view returns (uint);
31 }
32 
33 /**
34  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
35  * @dev Functions accepting uints in this contract and derived contracts
36  * are taken to be such fixed point decimals (including fiat, ether, and nomin quantities).
37  */
38 contract SafeDecimalMath {
39 
40     /* Number of decimal places in the representation. */
41     uint8 public constant decimals = 18;
42 
43     /* The number representing 1.0. */
44     uint public constant UNIT = 10 ** uint(decimals);
45 
46     /**
47      * @return True iff adding x and y will not overflow.
48      */
49     function addIsSafe(uint x, uint y)
50         pure
51         internal
52         returns (bool)
53     {
54         return x + y >= y;
55     }
56 
57     /**
58      * @return The result of adding x and y, throwing an exception in case of overflow.
59      */
60     function safeAdd(uint x, uint y)
61         pure
62         internal
63         returns (uint)
64     {
65         require(x + y >= y);
66         return x + y;
67     }
68 
69     /**
70      * @return True iff subtracting y from x will not overflow in the negative direction.
71      */
72     function subIsSafe(uint x, uint y)
73         pure
74         internal
75         returns (bool)
76     {
77         return y <= x;
78     }
79 
80     /**
81      * @return The result of subtracting y from x, throwing an exception in case of overflow.
82      */
83     function safeSub(uint x, uint y)
84         pure
85         internal
86         returns (uint)
87     {
88         require(y <= x);
89         return x - y;
90     }
91 
92     /**
93      * @return True iff multiplying x and y would not overflow.
94      */
95     function mulIsSafe(uint x, uint y)
96         pure
97         internal
98         returns (bool)
99     {
100         if (x == 0) {
101             return true;
102         }
103         return (x * y) / x == y;
104     }
105 
106     /**
107      * @return The result of multiplying x and y, throwing an exception in case of overflow.
108      */
109     function safeMul(uint x, uint y)
110         pure
111         internal
112         returns (uint)
113     {
114         if (x == 0) {
115             return 0;
116         }
117         uint p = x * y;
118         require(p / x == y);
119         return p;
120     }
121 
122     /**
123      * @return The result of multiplying x and y, interpreting the operands as fixed-point
124      * decimals. Throws an exception in case of overflow.
125      * 
126      * @dev A unit factor is divided out after the product of x and y is evaluated,
127      * so that product must be less than 2**256.
128      * Incidentally, the internal division always rounds down: one could have rounded to the nearest integer,
129      * but then one would be spending a significant fraction of a cent (of order a microether
130      * at present gas prices) in order to save less than one part in 0.5 * 10^18 per operation, if the operands
131      * contain small enough fractional components. It would also marginally diminish the 
132      * domain this function is defined upon. 
133      */
134     function safeMul_dec(uint x, uint y)
135         pure
136         internal
137         returns (uint)
138     {
139         /* Divide by UNIT to remove the extra factor introduced by the product. */
140         return safeMul(x, y) / UNIT;
141 
142     }
143 
144     /**
145      * @return True iff the denominator of x/y is nonzero.
146      */
147     function divIsSafe(uint x, uint y)
148         pure
149         internal
150         returns (bool)
151     {
152         return y != 0;
153     }
154 
155     /**
156      * @return The result of dividing x by y, throwing an exception if the divisor is zero.
157      */
158     function safeDiv(uint x, uint y)
159         pure
160         internal
161         returns (uint)
162     {
163         /* Although a 0 denominator already throws an exception,
164          * it is equivalent to a THROW operation, which consumes all gas.
165          * A require statement emits REVERT instead, which remits remaining gas. */
166         require(y != 0);
167         return x / y;
168     }
169 
170     /**
171      * @return The result of dividing x by y, interpreting the operands as fixed point decimal numbers.
172      * @dev Throws an exception in case of overflow or zero divisor; x must be less than 2^256 / UNIT.
173      * Internal rounding is downward: a similar caveat holds as with safeDecMul().
174      */
175     function safeDiv_dec(uint x, uint y)
176         pure
177         internal
178         returns (uint)
179     {
180         /* Reintroduce the UNIT factor that will be divided out by y. */
181         return safeDiv(safeMul(x, UNIT), y);
182     }
183 
184     /**
185      * @dev Convert an unsigned integer to a unsigned fixed-point decimal.
186      * Throw an exception if the result would be out of range.
187      */
188     function intToDec(uint i)
189         pure
190         internal
191         returns (uint)
192     {
193         return safeMul(i, UNIT);
194     }
195 
196     function min(uint a, uint b) 
197         pure
198         internal
199         returns (uint)
200     {
201         return a < b ? a : b;
202     }
203 
204     function max(uint a, uint b) 
205         pure
206         internal
207         returns (uint)
208     {
209         return a > b ? a : b;
210     }
211 }
212 
213 /**
214  * @title A contract with an owner.
215  * @notice Contract ownership can be transferred by first nominating the new owner,
216  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
217  */
218 contract Owned {
219     address public owner;
220     address public nominatedOwner;
221 
222     /**
223      * @dev Owned Constructor
224      */
225     constructor(address _owner)
226         public
227     {
228         require(_owner != address(0));
229         owner = _owner;
230         emit OwnerChanged(address(0), _owner);
231     }
232 
233     /**
234      * @notice Nominate a new owner of this contract.
235      * @dev Only the current owner may nominate a new owner.
236      */
237     function nominateNewOwner(address _owner)
238         external
239         onlyOwner
240     {
241         nominatedOwner = _owner;
242         emit OwnerNominated(_owner);
243     }
244 
245     /**
246      * @notice Accept the nomination to be owner.
247      */
248     function acceptOwnership()
249         external
250         onlyNominatedOwner
251     {
252         owner = nominatedOwner;
253         nominatedOwner = address(0);
254         emit OwnerChanged(owner, nominatedOwner);
255     }
256 
257     modifier onlyOwner
258     {
259         require(msg.sender == owner);
260         _;
261     }
262 
263     modifier onlyNominatedOwner
264     {
265         require(msg.sender == nominatedOwner);
266         _;
267     }
268 
269     event OwnerNominated(address newOwner);
270     event OwnerChanged(address oldOwner, address newOwner);
271 }
272 
273 
274 /*
275  * The CollateralMonitor queries and reports information
276  * about collateralisation levels of the network.
277  */
278 contract CollateralMonitor is Owned, SafeDecimalMath {
279     
280     Havven havven;
281     Nomin nomin;
282     HavvenEscrow escrow;
283 
284     address[] issuers;
285     uint maxIssuers = 10;
286 
287     constructor(Havven _havven, Nomin _nomin, HavvenEscrow _escrow)
288         Owned(msg.sender)
289         public
290     {
291         havven = _havven;
292         nomin = _nomin;
293         escrow = _escrow;
294     }
295 
296     function setHavven(Havven _havven)
297         onlyOwner
298         external
299     {
300         havven = _havven;
301     }
302 
303     function setNomin(Nomin _nomin)
304          onlyOwner
305          external
306     {
307         nomin = _nomin;
308     }
309 
310     function setEscrow(HavvenEscrow _escrow)
311         onlyOwner
312         external
313     {
314         escrow = _escrow;
315     }
316 
317     function setMaxIssuers(uint newMax)
318         onlyOwner
319         external
320     {
321         maxIssuers = newMax;
322     }
323 
324     modifier onlyOwner {
325         require(msg.sender == owner);
326         _;
327     }
328 
329     modifier onlyNominatedOwner {
330         require(msg.sender == nominatedOwner);
331         _;
332     }
333 
334     function pushIssuer(address issuer)
335         onlyOwner
336         public
337     {
338         for (uint i = 0; i < issuers.length; i++) {
339             require(issuers[i] != issuer);
340         }
341         issuers.push(issuer);
342     }
343 
344     function pushIssuers(address[] newIssuers)
345         onlyOwner
346         external
347     {
348         for (uint i = 0; i < issuers.length; i++) {
349             pushIssuer(newIssuers[i]);
350         }
351     }
352 
353     function deleteIssuer(uint index)
354         onlyOwner
355         external
356     {
357         uint length = issuers.length;
358         require(index < length);
359         issuers[index] = issuers[length - 1];
360         delete issuers[length - 1];
361     }
362 
363     function resizeIssuersArray(uint size)
364         onlyOwner
365         external
366     {
367         issuers.length = size;
368     }
369 
370 
371     /**********************************\
372       collateral()
373 
374       Reports the collateral available 
375       for issuance of a given issuer.
376     \**********************************/
377 
378     function collateral(address account)
379         public
380         view
381         returns (uint)
382     {
383         return safeAdd(havven.balanceOf(account), escrow.balanceOf(account));
384     }
385 
386 
387     /**********************************\
388       totalIssuingCollateral()
389 
390       Reports the collateral available 
391       for issuance of all issuers.
392     \**********************************/
393 
394     function _limitedTotalIssuingCollateral(uint sumLimit)
395         internal
396         view
397         returns (uint)
398     {
399         uint sum;
400         uint limit = min(sumLimit, issuers.length);
401         for (uint i = 0; i < limit; i++) {
402             sum += collateral(issuers[i]);
403         } 
404         return sum;
405     }
406 
407     function totalIssuingCollateral()
408         public
409         view
410         returns (uint)
411     {
412         return _limitedTotalIssuingCollateral(issuers.length);
413     }
414 
415     function totalIssuingCollateral_limitedSum()
416         public
417         view
418         returns (uint)
419     {
420         return _limitedTotalIssuingCollateral(maxIssuers);
421     } 
422 
423 
424 
425     /********************************\
426       collateralisation()
427     
428       Reports the collateralisation
429       ratio of one account, assuming
430       a nomin price of one dollar.
431     \********************************/
432 
433     function collateralisation(address account)
434         public
435         view
436         returns (uint)
437     {
438         safeDiv_dec(safeMul_dec(collateral(account), havven.price()), 
439                     havven.nominsIssued(account));
440     }
441 
442 
443     /********************************\
444       totalIssuerCollateralisation()
445     
446       Reports the collateralisation
447       ratio of all issuers, assuming
448       a nomin price of one dollar.
449     \********************************/
450 
451     function totalIssuerCollateralisation()
452         public
453         view
454         returns (uint)
455     {
456         safeDiv_dec(safeMul_dec(totalIssuingCollateral(), havven.price()),
457                     nomin.totalSupply());
458     }
459 
460 
461     /********************************\
462       totalNetworkCollateralisation()
463     
464       Reports the collateralisation
465       ratio of the entire network,
466       assuming a nomin price of one
467       dollar, and that havvens can
468       flow from non-issuer to issuer
469       accounts.
470     \********************************/
471 
472     function totalNetworkCollateralisation()
473         public
474         view
475         returns (uint)
476     {
477         safeDiv_dec(safeMul_dec(havven.totalSupply(), havven.price()),
478                     nomin.totalSupply());
479     }
480 
481 
482     /**************************************\
483       totalIssuanceDebt()
484 
485       Reports the the (unbounded) number
486       of havvens that would be locked by
487       all issued nomins, if the collateral
488       backing them was unlimited.
489     \**************************************/
490 
491     function totalIssuanceDebt()
492         public
493         view
494         returns (uint)
495     {
496         return safeDiv_dec(nomin.totalSupply(),
497                            safeMul_dec(havven.issuanceRatio(), havven.price()));
498     }
499 
500     function totalIssuanceDebt_limitedSum()
501         public
502         view
503         returns (uint)
504     {
505         uint sum;
506         uint limit = min(maxIssuers, issuers.length);
507         for (uint i = 0; i < limit; i++) {
508             sum += havven.nominsIssued(issuers[i]);
509         }
510         return safeDiv_dec(sum,
511                            safeMul_dec(havven.issuanceRatio(), havven.price()));
512     }
513 
514 
515     /*************************************\
516       totalLockedHavvens()
517 
518       Reports the the number of havvens
519       locked by all issued nomins.
520       This is capped by the actual number
521       of havvens in circulation.
522     \*************************************/
523 
524     function totalLockedHavvens()
525         public
526         view
527         returns (uint)
528     {
529         return min(totalIssuanceDebt(), totalIssuingCollateral());
530     }
531 
532     function totalLockedHavvens_limitedSum()
533         public
534         view
535         returns (uint)
536     { 
537         return min(totalIssuanceDebt_limitedSum(), totalIssuingCollateral());
538     }
539 
540 
541     /****************************************************\
542       totalLockedHavvens_byAvailableHavvens_limitedSum()
543       
544       Should be equivalent to
545       totalLockedHavvens_limitedSum() but it uses an
546       alternate computation method.
547     \****************************************************/
548 
549     function totalLockedHavvens_byAvailableHavvens_limitedSum()
550         public
551         view
552         returns (uint)
553     {
554         uint sum;
555         uint limit = min(maxIssuers, issuers.length);
556         for (uint i = 0; i < limit; i++) {
557             address issuer = issuers[i];
558             sum += safeSub(collateral(issuer), havven.availableHavvens(issuer));
559         }
560         return sum;
561     }
562 }