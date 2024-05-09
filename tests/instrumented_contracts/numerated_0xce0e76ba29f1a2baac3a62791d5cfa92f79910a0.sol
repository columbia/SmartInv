1 pragma solidity 0.4.24;
2 
3 // File: contracts/ds-auth/auth.sol
4 
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU General Public License for more details.
14 
15 // You should have received a copy of the GNU General Public License
16 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
17 
18 pragma solidity 0.4.24;
19 
20 contract DSAuthority {
21     function canCall(
22         address src, address dst, bytes4 sig
23     ) public view returns (bool);
24 }
25 
26 contract DSAuthEvents {
27     event LogSetAuthority (address indexed authority);
28     event LogSetOwner     (address indexed owner);
29 }
30 
31 contract DSAuth is DSAuthEvents {
32     DSAuthority  public  authority;
33     address      public  owner;
34 
35     constructor() public {
36         owner = msg.sender;
37         emit LogSetOwner(msg.sender);
38     }
39 
40     function setOwner(address owner_)
41         public
42         auth
43     {
44         owner = owner_;
45         emit LogSetOwner(owner);
46     }
47 
48     function setAuthority(DSAuthority authority_)
49         public
50         auth
51     {
52         authority = authority_;
53         emit LogSetAuthority(authority);
54     }
55 
56     modifier auth {
57         require(isAuthorized(msg.sender, msg.sig));
58         _;
59     }
60 
61     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
62         if (src == address(this)) {
63             return true;
64         } else if (src == owner) {
65             return true;
66         } else if (authority == DSAuthority(0)) {
67             return false;
68         } else {
69             return authority.canCall(src, this, sig);
70         }
71     }
72 }
73 
74 // File: contracts/AssetPriceOracle.sol
75 
76 contract AssetPriceOracle is DSAuth {
77     // Maximum value expressible with uint128 is 340282366920938463463374607431768211456.
78     // Using 18 decimals for price records (standard Ether precision), 
79     // the possible values are between 0 and 340282366920938463463.374607431768211456.
80 
81     struct AssetPriceRecord {
82         uint128 price;
83         bool isRecord;
84     }
85 
86     mapping(uint128 => mapping(uint128 => AssetPriceRecord)) public assetPriceRecords;
87 
88     event AssetPriceRecorded(
89         uint128 indexed assetId,
90         uint128 indexed blockNumber,
91         uint128 indexed price
92     );
93 
94     constructor() public {
95     }
96     
97     function recordAssetPrice(uint128 assetId, uint128 blockNumber, uint128 price) public auth {
98         assetPriceRecords[assetId][blockNumber].price = price;
99         assetPriceRecords[assetId][blockNumber].isRecord = true;
100         emit AssetPriceRecorded(assetId, blockNumber, price);
101     }
102 
103     function getAssetPrice(uint128 assetId, uint128 blockNumber) public view returns (uint128 price) {
104         AssetPriceRecord storage priceRecord = assetPriceRecords[assetId][blockNumber];
105         require(priceRecord.isRecord);
106         return priceRecord.price;
107     }
108 
109     function () public {
110         // dont receive ether via fallback method (by not having 'payable' modifier on this function).
111     }
112 }
113 
114 // File: contracts/lib/SafeMath.sol
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that throw on error
119  * Source: https://github.com/facuspagnuolo/zeppelin-solidity/blob/feature/705_add_safe_math_int_ops/contracts/math/SafeMath.sol
120  */
121 library SafeMath {
122 
123   /**
124   * @dev Multiplies two unsigned integers, throws on overflow.
125   */
126   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
127     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
128     // benefit is lost if 'b' is also tested.
129     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
130     if (a == 0) {
131       return 0;
132     }
133 
134     c = a * b;
135     assert(c / a == b);
136     return c;
137   }
138 
139   /**
140   * @dev Multiplies two signed integers, throws on overflow.
141   */
142   function mul(int256 a, int256 b) internal pure returns (int256) {
143     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
144     // benefit is lost if 'b' is also tested.
145     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
146     if (a == 0) {
147       return 0;
148     }
149     int256 c = a * b;
150     assert(c / a == b);
151     return c;
152   }
153 
154   /**
155   * @dev Integer division of two unsigned integers, truncating the quotient.
156   */
157   function div(uint256 a, uint256 b) internal pure returns (uint256) {
158     // assert(b > 0); // Solidity automatically throws when dividing by 0
159     // uint256 c = a / b;
160     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161     return a / b;
162   }
163 
164   /**
165   * @dev Integer division of two signed integers, truncating the quotient.
166   */
167   function div(int256 a, int256 b) internal pure returns (int256) {
168     // assert(b > 0); // Solidity automatically throws when dividing by 0
169     // Overflow only happens when the smallest negative int is multiplied by -1.
170     int256 INT256_MIN = int256((uint256(1) << 255));
171     assert(a != INT256_MIN || b != -1);
172     return a / b;
173   }
174 
175   /**
176   * @dev Subtracts two unsigned integers, throws on overflow (i.e. if subtrahend is greater than minuend).
177   */
178   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179     assert(b <= a);
180     return a - b;
181   }
182 
183   /**
184   * @dev Subtracts two signed integers, throws on overflow.
185   */
186   function sub(int256 a, int256 b) internal pure returns (int256) {
187     int256 c = a - b;
188     assert((b >= 0 && c <= a) || (b < 0 && c > a));
189     return c;
190   }
191 
192   /**
193   * @dev Adds two unsigned integers, throws on overflow.
194   */
195   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
196     c = a + b;
197     assert(c >= a);
198     return c;
199   }
200 
201   /**
202   * @dev Adds two signed integers, throws on overflow.
203   */
204   function add(int256 a, int256 b) internal pure returns (int256) {
205     int256 c = a + b;
206     assert((b >= 0 && c >= a) || (b < 0 && c < a));
207     return c;
208   }
209 }
210 
211 // File: contracts/ContractForDifference.sol
212 
213 contract ContractForDifference is DSAuth {
214     using SafeMath for int256;
215 
216     enum Position { Long, Short }
217     
218     /**
219      * A party to the contract. Either the maker or the taker.
220      */
221     struct Party {
222         address addr;
223         uint128 withdrawBalance; // Amount the Party can withdraw, as a result of settled contract.
224         Position position;
225         bool isPaid;
226     }
227     
228     struct Cfd {
229         Party maker;
230         Party taker;
231 
232         uint128 assetId;
233         uint128 amount; // in Wei.
234         uint128 contractStartBlock; // Block number
235         uint128 contractEndBlock; // Block number
236 
237         // CFD state variables
238         bool isTaken;
239         bool isSettled;
240         bool isRefunded;
241     }
242 
243     uint128 public leverage = 1; // Global leverage of the CFD contract.
244     AssetPriceOracle public priceOracle;
245 
246     mapping(uint128 => Cfd) public contracts;
247     uint128                 public numberOfContracts;
248 
249     event LogMakeCfd (
250     uint128 indexed cfdId, 
251     address indexed makerAddress, 
252     Position indexed makerPosition,
253     uint128 assetId,
254     uint128 amount,
255     uint128 contractEndBlock);
256 
257     event LogTakeCfd (
258     uint128 indexed cfdId,
259     address indexed makerAddress,
260     Position makerPosition,
261     address indexed takerAddress,
262     Position takerPosition,
263     uint128 assetId,
264     uint128 amount,
265     uint128 contractStartBlock,
266     uint128 contractEndBlock);
267 
268     event LogCfdSettled (
269     uint128 indexed cfdId,
270     address indexed makerAddress,
271     address indexed takerAddress,
272     uint128 amount,
273     uint128 startPrice,
274     uint128 endPrice,
275     uint128 makerSettlement,
276     uint128 takerSettlement);
277 
278     event LogCfdRefunded (
279     uint128 indexed cfdId,
280     address indexed makerAddress,
281     uint128 amount);
282 
283     event LogCfdForceRefunded (
284     uint128 indexed cfdId,
285     address indexed makerAddress,
286     uint128 makerAmount,
287     address indexed takerAddress,
288     uint128 takerAmount);
289 
290     event LogWithdrawal (
291     uint128 indexed cfdId,
292     address indexed withdrawalAddress,
293     uint128 amount);
294 
295     // event Debug (
296     //     string description,
297     //     uint128 uintValue,
298     //     int128 intValue
299     // );
300 
301     constructor(address priceOracleAddress) public {
302         priceOracle = AssetPriceOracle(priceOracleAddress);
303     }
304 
305     function makeCfd(
306         address makerAddress,
307         uint128 assetId,
308         Position makerPosition,
309         uint128 contractEndBlock
310         )
311         public
312         payable
313         returns (uint128)
314     {
315         require(contractEndBlock > block.number); // Contract end block must be after current block.
316         require(msg.value > 0); // Contract Wei amount must be more than zero - contracts for zero Wei does not make sense.
317         require(makerAddress != address(0)); // Maker must provide a non-zero address.
318         
319         uint128 contractId = numberOfContracts;
320 
321         /**
322          * Initialize CFD struct using tight variable packing pattern.
323          * See https://fravoll.github.io/solidity-patterns/tight_variable_packing.html
324          */
325         Party memory maker = Party(makerAddress, 0, makerPosition, false);
326         Party memory taker = Party(address(0), 0, Position.Long, false);
327         Cfd memory newCfd = Cfd(
328             maker,
329             taker,
330             assetId,
331             uint128(msg.value),
332             0,
333             contractEndBlock,
334             false,
335             false,
336             false
337         );
338 
339         contracts[contractId] = newCfd;
340 
341         // contracts[contractId].maker.addr = makerAddress;
342         // contracts[contractId].maker.position = makerPosition;
343         // contracts[contractId].assetId = assetId;
344         // contracts[contractId].amount = uint128(msg.value);
345         // contracts[contractId].contractEndBlock = contractEndBlock;
346 
347         numberOfContracts++;
348         
349         emit LogMakeCfd(
350             contractId,
351             contracts[contractId].maker.addr,
352             contracts[contractId].maker.position,
353             contracts[contractId].assetId,
354             contracts[contractId].amount,
355             contracts[contractId].contractEndBlock
356         );
357 
358         return contractId;
359     }
360 
361     function getCfd(
362         uint128 cfdId
363         ) 
364         public 
365         view 
366         returns (address makerAddress, Position makerPosition, address takerAddress, Position takerPosition, uint128 assetId, uint128 amount, uint128 startTime, uint128 endTime, bool isTaken, bool isSettled, bool isRefunded)
367         {
368         Cfd storage cfd = contracts[cfdId];
369         return (
370             cfd.maker.addr,
371             cfd.maker.position,
372             cfd.taker.addr,
373             cfd.taker.position,
374             cfd.assetId,
375             cfd.amount,
376             cfd.contractStartBlock,
377             cfd.contractEndBlock,
378             cfd.isTaken,
379             cfd.isSettled,
380             cfd.isRefunded
381         );
382     }
383 
384     function takeCfd(
385         uint128 cfdId, 
386         address takerAddress
387         ) 
388         public
389         payable
390         returns (bool success) {
391         Cfd storage cfd = contracts[cfdId];
392         
393         require(cfd.isTaken != true);                  // Contract must not be taken.
394         require(cfd.isSettled != true);                // Contract must not be settled.
395         require(cfd.isRefunded != true);               // Contract must not be refunded.
396         require(cfd.maker.addr != address(0));         // Contract must have a maker,
397         require(cfd.taker.addr == address(0));         // and no taker.
398         // require(takerAddress != cfd.maker.addr);       // Maker and Taker must not be the same address. (disabled for now)
399         require(msg.value == cfd.amount);              // Takers deposit must match makers deposit.
400         require(takerAddress != address(0));           // Taker must provide a non-zero address.
401         require(block.number <= cfd.contractEndBlock); // Taker must take contract before end block.
402 
403         cfd.taker.addr = takerAddress;
404         // Make taker position the inverse of maker position
405         cfd.taker.position = cfd.maker.position == Position.Long ? Position.Short : Position.Long;
406         cfd.contractStartBlock = uint128(block.number);
407         cfd.isTaken = true;
408 
409         emit LogTakeCfd(
410             cfdId,
411             cfd.maker.addr,
412             cfd.maker.position,
413             cfd.taker.addr,
414             cfd.taker.position,
415             cfd.assetId,
416             cfd.amount,
417             cfd.contractStartBlock,
418             cfd.contractEndBlock
419         );
420             
421         return true;
422     }
423 
424     function settleAndWithdrawCfd(
425         uint128 cfdId
426         )
427         public {
428         address makerAddr = contracts[cfdId].maker.addr;
429         address takerAddr = contracts[cfdId].taker.addr;
430 
431         settleCfd(cfdId);
432         withdraw(cfdId, makerAddr);
433         withdraw(cfdId, takerAddr);
434     }
435 
436     function settleCfd(
437         uint128 cfdId
438         )
439         public
440         returns (bool success) {
441         Cfd storage cfd = contracts[cfdId];
442 
443         require(cfd.contractEndBlock <= block.number); // Contract must have met its end time.
444         require(!cfd.isSettled);                       // Contract must not be settled already.
445         require(!cfd.isRefunded);                      // Contract must not be refunded.
446         require(cfd.isTaken);                          // Contract must be taken.
447         require(cfd.maker.addr != address(0));         // Contract must have a maker address.
448         require(cfd.taker.addr != address(0));         // Contract must have a taker address.
449 
450         // Get relevant variables
451         uint128 amount = cfd.amount;
452         uint128 startPrice = priceOracle.getAssetPrice(cfd.assetId, cfd.contractStartBlock);
453         uint128 endPrice = priceOracle.getAssetPrice(cfd.assetId, cfd.contractEndBlock);
454 
455         /**
456          * Register settlements for maker and taker.
457          * Maker recieves any leftover wei from integer division.
458          */
459         uint128 takerSettlement = getSettlementAmount(amount, startPrice, endPrice, cfd.taker.position);
460         if (takerSettlement > 0) {
461             cfd.taker.withdrawBalance = takerSettlement;
462         }
463 
464         uint128 makerSettlement = (amount * 2) - takerSettlement;
465         cfd.maker.withdrawBalance = makerSettlement;
466 
467         // Mark contract as settled.
468         cfd.isSettled = true;
469 
470         emit LogCfdSettled (
471             cfdId,
472             cfd.maker.addr,
473             cfd.taker.addr,
474             amount,
475             startPrice,
476             endPrice,
477             makerSettlement,
478             takerSettlement
479         );
480 
481         return true;
482     }
483 
484     function withdraw(
485         uint128 cfdId, 
486         address partyAddress
487     )
488     public {
489         Cfd storage cfd = contracts[cfdId];
490         Party storage party = partyAddress == cfd.maker.addr ? cfd.maker : cfd.taker;
491         require(party.withdrawBalance > 0); // The party must have a withdraw balance from previous settlement.
492         require(!party.isPaid); // The party must have already been paid out, fx from a refund.
493         
494         uint128 amount = party.withdrawBalance;
495         party.withdrawBalance = 0;
496         party.isPaid = true;
497         
498         party.addr.transfer(amount);
499 
500         emit LogWithdrawal(
501             cfdId,
502             party.addr,
503             amount
504         );
505     }
506 
507     function getSettlementAmount(
508         uint128 amountUInt,
509         uint128 entryPriceUInt,
510         uint128 exitPriceUInt,
511         Position position
512     )
513     public
514     view
515     returns (uint128) {
516         require(position == Position.Long || position == Position.Short);
517 
518         // If price didn't change, settle for equal amount to long and short.
519         if (entryPriceUInt == exitPriceUInt) {return amountUInt;}
520 
521         // If entry price is 0 and exit price is more than 0, all must go to long position and nothing to short.
522         if (entryPriceUInt == 0 && exitPriceUInt > 0) {
523             return position == Position.Long ? amountUInt * 2 : 0;
524         }
525 
526         // Cast uint128 to int256 to support negative numbers and increase over- and underflow limits
527         int256 entryPrice = int256(entryPriceUInt);
528         int256 exitPrice = int256(exitPriceUInt);
529         int256 amount = int256(amountUInt);
530 
531         // Price diff calc depends on which position we are calculating settlement for.
532         int256 priceDiff = position == Position.Long ? exitPrice.sub(entryPrice) : entryPrice.sub(exitPrice);
533         int256 settlement = amount.add(priceDiff.mul(amount).mul(leverage).div(entryPrice));
534         if (settlement < 0) {
535             return 0; // Calculated settlement was negative. But a party can't lose more than his deposit, so he's just awarded 0.
536         } else if (settlement > amount * 2) {
537             return amountUInt * 2; // Calculated settlement was more than the total deposits, so settle for the total deposits.
538         } else {
539             return uint128(settlement); // Settlement was more than zero and less than sum of deposit amounts, so we can settle it as is.
540         }
541     }
542 
543     function refundCfd(
544         uint128 cfdId
545     )
546     public
547     returns (bool success) {
548         Cfd storage cfd = contracts[cfdId];
549         require(!cfd.isSettled);                // Contract must not be settled already.
550         require(!cfd.isTaken);                  // Contract must not be taken.
551         require(!cfd.isRefunded);               // Contract must not be refunded already.
552         require(msg.sender == cfd.maker.addr);  // Function caller must be the contract maker.
553 
554         cfd.isRefunded = true;
555         cfd.maker.isPaid = true;
556         cfd.maker.addr.transfer(cfd.amount);
557 
558         emit LogCfdRefunded(
559             cfdId,
560             cfd.maker.addr,
561             cfd.amount
562         );
563 
564         return true;
565     }
566 
567     function forceRefundCfd(
568         uint128 cfdId
569     )
570     public
571     auth
572     {
573         Cfd storage cfd = contracts[cfdId];
574         require(!cfd.isRefunded); // Contract must not be refunded already.
575 
576         cfd.isRefunded = true;
577 
578         // Refund Taker
579         uint128 takerAmount = 0;
580         if (cfd.taker.addr != address(0)) {
581             takerAmount = cfd.amount;
582             cfd.taker.withdrawBalance = 0; // Refunding must reset withdraw balance, if any.
583             cfd.taker.addr.transfer(cfd.amount);
584         }
585 
586         // Refund Maker
587         cfd.maker.withdrawBalance = 0; // Refunding must reset withdraw balance, if any.
588         cfd.maker.addr.transfer(cfd.amount);
589         
590         emit LogCfdForceRefunded(
591             cfdId,
592             cfd.maker.addr,
593             cfd.amount,
594             cfd.taker.addr,
595             takerAmount
596         );
597     } 
598 
599     function () public {
600         // dont receive ether via fallback method (by not having 'payable' modifier on this function).
601     }
602 }