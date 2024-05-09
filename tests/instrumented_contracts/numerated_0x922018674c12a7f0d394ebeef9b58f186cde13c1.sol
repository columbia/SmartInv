1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-03
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0
6 
7 pragma solidity ^0.6.10;
8 pragma experimental ABIEncoderV2;
9 
10 
11 
12 
13 
14 
15 
16 
17 /**
18  * @title The Open Oracle Data Base Contract
19  * @author Compound Labs, Inc.
20  */
21 contract OpenOracleData {
22     /**
23      * @notice The event emitted when a source writes to its storage
24      */
25     //event Write(address indexed source, <Key> indexed key, string kind, uint64 timestamp, <Value> value);
26 
27     /**
28      * @notice Write a bunch of signed datum to the authenticated storage mapping
29      * @param message The payload containing the timestamp, and (key, value) pairs
30      * @param signature The cryptographic signature of the message payload, authorizing the source to write
31      * @return The keys that were written
32      */
33     //function put(bytes calldata message, bytes calldata signature) external returns (<Key> memory);
34 
35     /**
36      * @notice Read a single key with a pre-defined type signature from an authenticated source
37      * @param source The verifiable author of the data
38      * @param key The selector for the value to return
39      * @return The claimed Unix timestamp for the data and the encoded value (defaults to (0, 0x))
40      */
41     //function get(address source, <Key> key) external view returns (uint, <Value>);
42 
43     /**
44      * @notice Recovers the source address which signed a message
45      * @dev Comparing to a claimed address would add nothing,
46      *  as the caller could simply perform the recover and claim that address.
47      * @param message The data that was presumably signed
48      * @param signature The fingerprint of the data + private key
49      * @return The source address which signed the message, presumably
50      */
51     function source(bytes memory message, bytes memory signature) public pure returns (address) {
52         (bytes32 r, bytes32 s, uint8 v) = abi.decode(signature, (bytes32, bytes32, uint8));
53         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(message)));
54         return ecrecover(hash, v, r, s);
55     }
56 }
57 
58 
59 /**
60  * @title The Open Oracle Price Data Contract
61  * @notice Values stored in this contract should represent a USD price with 6 decimals precision
62  * @author Compound Labs, Inc.
63  */
64 contract OpenOraclePriceData is OpenOracleData {
65     ///@notice The event emitted when a source writes to its storage
66     event Write(address indexed source, string key, uint64 timestamp, uint64 value);
67     ///@notice The event emitted when the timestamp on a price is invalid and it is not written to storage
68     event NotWritten(uint64 priorTimestamp, uint256 messageTimestamp, uint256 blockTimestamp);
69 
70     ///@notice The fundamental unit of storage for a reporter source
71     struct Datum {
72         uint64 timestamp;
73         uint64 value;
74     }
75 
76     /**
77      * @dev The most recent authenticated data from all sources.
78      *  This is private because dynamic mapping keys preclude auto-generated getters.
79      */
80     mapping(address => mapping(string => Datum)) private data;
81 
82     /**
83      * @notice Write a bunch of signed datum to the authenticated storage mapping
84      * @param message The payload containing the timestamp, and (key, value) pairs
85      * @param signature The cryptographic signature of the message payload, authorizing the source to write
86      * @return The keys that were written
87      */
88     function put(bytes calldata message, bytes calldata signature) external returns (string memory) {
89         (address source, uint64 timestamp, string memory key, uint64 value) = decodeMessage(message, signature);
90         return putInternal(source, timestamp, key, value);
91     }
92 
93     function putInternal(address source, uint64 timestamp, string memory key, uint64 value) internal returns (string memory) {
94         // Only update if newer than stored, according to source
95         Datum storage prior = data[source][key];
96         if (timestamp > prior.timestamp && timestamp < block.timestamp + 60 minutes && source != address(0)) {
97             data[source][key] = Datum(timestamp, value);
98             emit Write(source, key, timestamp, value);
99         } else {
100             emit NotWritten(prior.timestamp, timestamp, block.timestamp);
101         }
102         return key;
103     }
104 
105     function decodeMessage(bytes calldata message, bytes calldata signature) internal pure returns (address, uint64, string memory, uint64) {
106         // Recover the source address
107         address source = source(message, signature);
108 
109         // Decode the message and check the kind
110         (string memory kind, uint64 timestamp, string memory key, uint64 value) = abi.decode(message, (string, uint64, string, uint64));
111         require(keccak256(abi.encodePacked(kind)) == keccak256(abi.encodePacked("prices")), "Kind of data must be 'prices'");
112         return (source, timestamp, key, value);
113     }
114 
115     /**
116      * @notice Read a single key from an authenticated source
117      * @param source The verifiable author of the data
118      * @param key The selector for the value to return
119      * @return The claimed Unix timestamp for the data and the price value (defaults to (0, 0))
120      */
121     function get(address source, string calldata key) external view returns (uint64, uint64) {
122         Datum storage datum = data[source][key];
123         return (datum.timestamp, datum.value);
124     }
125 
126     /**
127      * @notice Read only the value for a single key from an authenticated source
128      * @param source The verifiable author of the data
129      * @param key The selector for the value to return
130      * @return The price value (defaults to 0)
131      */
132     function getPrice(address source, string calldata key) external view returns (uint64) {
133         return data[source][key].value;
134     }
135 }
136 
137 
138 
139 
140 
141 interface CErc20 {
142     function underlying() external view returns (address);
143 }
144 
145 contract UniswapConfig {
146     /// @dev Describe how to interpret the fixedPrice in the TokenConfig.
147     enum PriceSource {
148         FIXED_ETH, /// implies the fixedPrice is a constant multiple of the ETH price (which varies)
149         FIXED_USD, /// implies the fixedPrice is a constant multiple of the USD price (which is 1)
150         REPORTER   /// implies the price is set by the reporter
151     }
152 
153     /// @dev Describe how the USD price should be determined for an asset.
154     ///  There should be 1 TokenConfig object for each supported asset, passed in the constructor.
155     struct TokenConfig {
156         address cToken;
157         address underlying;
158         bytes32 symbolHash;
159         uint256 baseUnit;
160         PriceSource priceSource;
161         uint256 fixedPrice;
162         address uniswapMarket;
163         bool isUniswapReversed;
164     }
165 
166     /// @notice The max number of tokens this contract is hardcoded to support
167     /// @dev Do not change this variable without updating all the fields throughout the contract.
168     uint public constant maxTokens = 30;
169 
170     /// @notice The number of tokens this contract actually supports
171     uint public immutable numTokens;
172 
173     address internal immutable cToken00;
174     address internal immutable cToken01;
175     address internal immutable cToken02;
176     address internal immutable cToken03;
177     address internal immutable cToken04;
178     address internal immutable cToken05;
179     address internal immutable cToken06;
180     address internal immutable cToken07;
181     address internal immutable cToken08;
182     address internal immutable cToken09;
183     address internal immutable cToken10;
184     address internal immutable cToken11;
185     address internal immutable cToken12;
186     address internal immutable cToken13;
187     address internal immutable cToken14;
188     address internal immutable cToken15;
189     address internal immutable cToken16;
190     address internal immutable cToken17;
191     address internal immutable cToken18;
192     address internal immutable cToken19;
193     address internal immutable cToken20;
194     address internal immutable cToken21;
195     address internal immutable cToken22;
196     address internal immutable cToken23;
197     address internal immutable cToken24;
198     address internal immutable cToken25;
199     address internal immutable cToken26;
200     address internal immutable cToken27;
201     address internal immutable cToken28;
202     address internal immutable cToken29;
203 
204     address internal immutable underlying00;
205     address internal immutable underlying01;
206     address internal immutable underlying02;
207     address internal immutable underlying03;
208     address internal immutable underlying04;
209     address internal immutable underlying05;
210     address internal immutable underlying06;
211     address internal immutable underlying07;
212     address internal immutable underlying08;
213     address internal immutable underlying09;
214     address internal immutable underlying10;
215     address internal immutable underlying11;
216     address internal immutable underlying12;
217     address internal immutable underlying13;
218     address internal immutable underlying14;
219     address internal immutable underlying15;
220     address internal immutable underlying16;
221     address internal immutable underlying17;
222     address internal immutable underlying18;
223     address internal immutable underlying19;
224     address internal immutable underlying20;
225     address internal immutable underlying21;
226     address internal immutable underlying22;
227     address internal immutable underlying23;
228     address internal immutable underlying24;
229     address internal immutable underlying25;
230     address internal immutable underlying26;
231     address internal immutable underlying27;
232     address internal immutable underlying28;
233     address internal immutable underlying29;
234 
235     bytes32 internal immutable symbolHash00;
236     bytes32 internal immutable symbolHash01;
237     bytes32 internal immutable symbolHash02;
238     bytes32 internal immutable symbolHash03;
239     bytes32 internal immutable symbolHash04;
240     bytes32 internal immutable symbolHash05;
241     bytes32 internal immutable symbolHash06;
242     bytes32 internal immutable symbolHash07;
243     bytes32 internal immutable symbolHash08;
244     bytes32 internal immutable symbolHash09;
245     bytes32 internal immutable symbolHash10;
246     bytes32 internal immutable symbolHash11;
247     bytes32 internal immutable symbolHash12;
248     bytes32 internal immutable symbolHash13;
249     bytes32 internal immutable symbolHash14;
250     bytes32 internal immutable symbolHash15;
251     bytes32 internal immutable symbolHash16;
252     bytes32 internal immutable symbolHash17;
253     bytes32 internal immutable symbolHash18;
254     bytes32 internal immutable symbolHash19;
255     bytes32 internal immutable symbolHash20;
256     bytes32 internal immutable symbolHash21;
257     bytes32 internal immutable symbolHash22;
258     bytes32 internal immutable symbolHash23;
259     bytes32 internal immutable symbolHash24;
260     bytes32 internal immutable symbolHash25;
261     bytes32 internal immutable symbolHash26;
262     bytes32 internal immutable symbolHash27;
263     bytes32 internal immutable symbolHash28;
264     bytes32 internal immutable symbolHash29;
265 
266     uint256 internal immutable baseUnit00;
267     uint256 internal immutable baseUnit01;
268     uint256 internal immutable baseUnit02;
269     uint256 internal immutable baseUnit03;
270     uint256 internal immutable baseUnit04;
271     uint256 internal immutable baseUnit05;
272     uint256 internal immutable baseUnit06;
273     uint256 internal immutable baseUnit07;
274     uint256 internal immutable baseUnit08;
275     uint256 internal immutable baseUnit09;
276     uint256 internal immutable baseUnit10;
277     uint256 internal immutable baseUnit11;
278     uint256 internal immutable baseUnit12;
279     uint256 internal immutable baseUnit13;
280     uint256 internal immutable baseUnit14;
281     uint256 internal immutable baseUnit15;
282     uint256 internal immutable baseUnit16;
283     uint256 internal immutable baseUnit17;
284     uint256 internal immutable baseUnit18;
285     uint256 internal immutable baseUnit19;
286     uint256 internal immutable baseUnit20;
287     uint256 internal immutable baseUnit21;
288     uint256 internal immutable baseUnit22;
289     uint256 internal immutable baseUnit23;
290     uint256 internal immutable baseUnit24;
291     uint256 internal immutable baseUnit25;
292     uint256 internal immutable baseUnit26;
293     uint256 internal immutable baseUnit27;
294     uint256 internal immutable baseUnit28;
295     uint256 internal immutable baseUnit29;
296 
297     PriceSource internal immutable priceSource00;
298     PriceSource internal immutable priceSource01;
299     PriceSource internal immutable priceSource02;
300     PriceSource internal immutable priceSource03;
301     PriceSource internal immutable priceSource04;
302     PriceSource internal immutable priceSource05;
303     PriceSource internal immutable priceSource06;
304     PriceSource internal immutable priceSource07;
305     PriceSource internal immutable priceSource08;
306     PriceSource internal immutable priceSource09;
307     PriceSource internal immutable priceSource10;
308     PriceSource internal immutable priceSource11;
309     PriceSource internal immutable priceSource12;
310     PriceSource internal immutable priceSource13;
311     PriceSource internal immutable priceSource14;
312     PriceSource internal immutable priceSource15;
313     PriceSource internal immutable priceSource16;
314     PriceSource internal immutable priceSource17;
315     PriceSource internal immutable priceSource18;
316     PriceSource internal immutable priceSource19;
317     PriceSource internal immutable priceSource20;
318     PriceSource internal immutable priceSource21;
319     PriceSource internal immutable priceSource22;
320     PriceSource internal immutable priceSource23;
321     PriceSource internal immutable priceSource24;
322     PriceSource internal immutable priceSource25;
323     PriceSource internal immutable priceSource26;
324     PriceSource internal immutable priceSource27;
325     PriceSource internal immutable priceSource28;
326     PriceSource internal immutable priceSource29;
327 
328     uint256 internal immutable fixedPrice00;
329     uint256 internal immutable fixedPrice01;
330     uint256 internal immutable fixedPrice02;
331     uint256 internal immutable fixedPrice03;
332     uint256 internal immutable fixedPrice04;
333     uint256 internal immutable fixedPrice05;
334     uint256 internal immutable fixedPrice06;
335     uint256 internal immutable fixedPrice07;
336     uint256 internal immutable fixedPrice08;
337     uint256 internal immutable fixedPrice09;
338     uint256 internal immutable fixedPrice10;
339     uint256 internal immutable fixedPrice11;
340     uint256 internal immutable fixedPrice12;
341     uint256 internal immutable fixedPrice13;
342     uint256 internal immutable fixedPrice14;
343     uint256 internal immutable fixedPrice15;
344     uint256 internal immutable fixedPrice16;
345     uint256 internal immutable fixedPrice17;
346     uint256 internal immutable fixedPrice18;
347     uint256 internal immutable fixedPrice19;
348     uint256 internal immutable fixedPrice20;
349     uint256 internal immutable fixedPrice21;
350     uint256 internal immutable fixedPrice22;
351     uint256 internal immutable fixedPrice23;
352     uint256 internal immutable fixedPrice24;
353     uint256 internal immutable fixedPrice25;
354     uint256 internal immutable fixedPrice26;
355     uint256 internal immutable fixedPrice27;
356     uint256 internal immutable fixedPrice28;
357     uint256 internal immutable fixedPrice29;
358 
359     address internal immutable uniswapMarket00;
360     address internal immutable uniswapMarket01;
361     address internal immutable uniswapMarket02;
362     address internal immutable uniswapMarket03;
363     address internal immutable uniswapMarket04;
364     address internal immutable uniswapMarket05;
365     address internal immutable uniswapMarket06;
366     address internal immutable uniswapMarket07;
367     address internal immutable uniswapMarket08;
368     address internal immutable uniswapMarket09;
369     address internal immutable uniswapMarket10;
370     address internal immutable uniswapMarket11;
371     address internal immutable uniswapMarket12;
372     address internal immutable uniswapMarket13;
373     address internal immutable uniswapMarket14;
374     address internal immutable uniswapMarket15;
375     address internal immutable uniswapMarket16;
376     address internal immutable uniswapMarket17;
377     address internal immutable uniswapMarket18;
378     address internal immutable uniswapMarket19;
379     address internal immutable uniswapMarket20;
380     address internal immutable uniswapMarket21;
381     address internal immutable uniswapMarket22;
382     address internal immutable uniswapMarket23;
383     address internal immutable uniswapMarket24;
384     address internal immutable uniswapMarket25;
385     address internal immutable uniswapMarket26;
386     address internal immutable uniswapMarket27;
387     address internal immutable uniswapMarket28;
388     address internal immutable uniswapMarket29;
389 
390     bool internal immutable isUniswapReversed00;
391     bool internal immutable isUniswapReversed01;
392     bool internal immutable isUniswapReversed02;
393     bool internal immutable isUniswapReversed03;
394     bool internal immutable isUniswapReversed04;
395     bool internal immutable isUniswapReversed05;
396     bool internal immutable isUniswapReversed06;
397     bool internal immutable isUniswapReversed07;
398     bool internal immutable isUniswapReversed08;
399     bool internal immutable isUniswapReversed09;
400     bool internal immutable isUniswapReversed10;
401     bool internal immutable isUniswapReversed11;
402     bool internal immutable isUniswapReversed12;
403     bool internal immutable isUniswapReversed13;
404     bool internal immutable isUniswapReversed14;
405     bool internal immutable isUniswapReversed15;
406     bool internal immutable isUniswapReversed16;
407     bool internal immutable isUniswapReversed17;
408     bool internal immutable isUniswapReversed18;
409     bool internal immutable isUniswapReversed19;
410     bool internal immutable isUniswapReversed20;
411     bool internal immutable isUniswapReversed21;
412     bool internal immutable isUniswapReversed22;
413     bool internal immutable isUniswapReversed23;
414     bool internal immutable isUniswapReversed24;
415     bool internal immutable isUniswapReversed25;
416     bool internal immutable isUniswapReversed26;
417     bool internal immutable isUniswapReversed27;
418     bool internal immutable isUniswapReversed28;
419     bool internal immutable isUniswapReversed29;
420 
421     /**
422      * @notice Construct an immutable store of configs into the contract data
423      * @param configs The configs for the supported assets
424      */
425     constructor(TokenConfig[] memory configs) public {
426         require(configs.length <= maxTokens, "too many configs");
427         numTokens = configs.length;
428 
429         cToken00 = get(configs, 0).cToken;
430         cToken01 = get(configs, 1).cToken;
431         cToken02 = get(configs, 2).cToken;
432         cToken03 = get(configs, 3).cToken;
433         cToken04 = get(configs, 4).cToken;
434         cToken05 = get(configs, 5).cToken;
435         cToken06 = get(configs, 6).cToken;
436         cToken07 = get(configs, 7).cToken;
437         cToken08 = get(configs, 8).cToken;
438         cToken09 = get(configs, 9).cToken;
439         cToken10 = get(configs, 10).cToken;
440         cToken11 = get(configs, 11).cToken;
441         cToken12 = get(configs, 12).cToken;
442         cToken13 = get(configs, 13).cToken;
443         cToken14 = get(configs, 14).cToken;
444         cToken15 = get(configs, 15).cToken;
445         cToken16 = get(configs, 16).cToken;
446         cToken17 = get(configs, 17).cToken;
447         cToken18 = get(configs, 18).cToken;
448         cToken19 = get(configs, 19).cToken;
449         cToken20 = get(configs, 20).cToken;
450         cToken21 = get(configs, 21).cToken;
451         cToken22 = get(configs, 22).cToken;
452         cToken23 = get(configs, 23).cToken;
453         cToken24 = get(configs, 24).cToken;
454         cToken25 = get(configs, 25).cToken;
455         cToken26 = get(configs, 26).cToken;
456         cToken27 = get(configs, 27).cToken;
457         cToken28 = get(configs, 28).cToken;
458         cToken29 = get(configs, 29).cToken;
459 
460         underlying00 = get(configs, 0).underlying;
461         underlying01 = get(configs, 1).underlying;
462         underlying02 = get(configs, 2).underlying;
463         underlying03 = get(configs, 3).underlying;
464         underlying04 = get(configs, 4).underlying;
465         underlying05 = get(configs, 5).underlying;
466         underlying06 = get(configs, 6).underlying;
467         underlying07 = get(configs, 7).underlying;
468         underlying08 = get(configs, 8).underlying;
469         underlying09 = get(configs, 9).underlying;
470         underlying10 = get(configs, 10).underlying;
471         underlying11 = get(configs, 11).underlying;
472         underlying12 = get(configs, 12).underlying;
473         underlying13 = get(configs, 13).underlying;
474         underlying14 = get(configs, 14).underlying;
475         underlying15 = get(configs, 15).underlying;
476         underlying16 = get(configs, 16).underlying;
477         underlying17 = get(configs, 17).underlying;
478         underlying18 = get(configs, 18).underlying;
479         underlying19 = get(configs, 19).underlying;
480         underlying20 = get(configs, 20).underlying;
481         underlying21 = get(configs, 21).underlying;
482         underlying22 = get(configs, 22).underlying;
483         underlying23 = get(configs, 23).underlying;
484         underlying24 = get(configs, 24).underlying;
485         underlying25 = get(configs, 25).underlying;
486         underlying26 = get(configs, 26).underlying;
487         underlying27 = get(configs, 27).underlying;
488         underlying28 = get(configs, 28).underlying;
489         underlying29 = get(configs, 29).underlying;
490 
491         symbolHash00 = get(configs, 0).symbolHash;
492         symbolHash01 = get(configs, 1).symbolHash;
493         symbolHash02 = get(configs, 2).symbolHash;
494         symbolHash03 = get(configs, 3).symbolHash;
495         symbolHash04 = get(configs, 4).symbolHash;
496         symbolHash05 = get(configs, 5).symbolHash;
497         symbolHash06 = get(configs, 6).symbolHash;
498         symbolHash07 = get(configs, 7).symbolHash;
499         symbolHash08 = get(configs, 8).symbolHash;
500         symbolHash09 = get(configs, 9).symbolHash;
501         symbolHash10 = get(configs, 10).symbolHash;
502         symbolHash11 = get(configs, 11).symbolHash;
503         symbolHash12 = get(configs, 12).symbolHash;
504         symbolHash13 = get(configs, 13).symbolHash;
505         symbolHash14 = get(configs, 14).symbolHash;
506         symbolHash15 = get(configs, 15).symbolHash;
507         symbolHash16 = get(configs, 16).symbolHash;
508         symbolHash17 = get(configs, 17).symbolHash;
509         symbolHash18 = get(configs, 18).symbolHash;
510         symbolHash19 = get(configs, 19).symbolHash;
511         symbolHash20 = get(configs, 20).symbolHash;
512         symbolHash21 = get(configs, 21).symbolHash;
513         symbolHash22 = get(configs, 22).symbolHash;
514         symbolHash23 = get(configs, 23).symbolHash;
515         symbolHash24 = get(configs, 24).symbolHash;
516         symbolHash25 = get(configs, 25).symbolHash;
517         symbolHash26 = get(configs, 26).symbolHash;
518         symbolHash27 = get(configs, 27).symbolHash;
519         symbolHash28 = get(configs, 28).symbolHash;
520         symbolHash29 = get(configs, 29).symbolHash;
521 
522         baseUnit00 = get(configs, 0).baseUnit;
523         baseUnit01 = get(configs, 1).baseUnit;
524         baseUnit02 = get(configs, 2).baseUnit;
525         baseUnit03 = get(configs, 3).baseUnit;
526         baseUnit04 = get(configs, 4).baseUnit;
527         baseUnit05 = get(configs, 5).baseUnit;
528         baseUnit06 = get(configs, 6).baseUnit;
529         baseUnit07 = get(configs, 7).baseUnit;
530         baseUnit08 = get(configs, 8).baseUnit;
531         baseUnit09 = get(configs, 9).baseUnit;
532         baseUnit10 = get(configs, 10).baseUnit;
533         baseUnit11 = get(configs, 11).baseUnit;
534         baseUnit12 = get(configs, 12).baseUnit;
535         baseUnit13 = get(configs, 13).baseUnit;
536         baseUnit14 = get(configs, 14).baseUnit;
537         baseUnit15 = get(configs, 15).baseUnit;
538         baseUnit16 = get(configs, 16).baseUnit;
539         baseUnit17 = get(configs, 17).baseUnit;
540         baseUnit18 = get(configs, 18).baseUnit;
541         baseUnit19 = get(configs, 19).baseUnit;
542         baseUnit20 = get(configs, 20).baseUnit;
543         baseUnit21 = get(configs, 21).baseUnit;
544         baseUnit22 = get(configs, 22).baseUnit;
545         baseUnit23 = get(configs, 23).baseUnit;
546         baseUnit24 = get(configs, 24).baseUnit;
547         baseUnit25 = get(configs, 25).baseUnit;
548         baseUnit26 = get(configs, 26).baseUnit;
549         baseUnit27 = get(configs, 27).baseUnit;
550         baseUnit28 = get(configs, 28).baseUnit;
551         baseUnit29 = get(configs, 29).baseUnit;
552 
553         priceSource00 = get(configs, 0).priceSource;
554         priceSource01 = get(configs, 1).priceSource;
555         priceSource02 = get(configs, 2).priceSource;
556         priceSource03 = get(configs, 3).priceSource;
557         priceSource04 = get(configs, 4).priceSource;
558         priceSource05 = get(configs, 5).priceSource;
559         priceSource06 = get(configs, 6).priceSource;
560         priceSource07 = get(configs, 7).priceSource;
561         priceSource08 = get(configs, 8).priceSource;
562         priceSource09 = get(configs, 9).priceSource;
563         priceSource10 = get(configs, 10).priceSource;
564         priceSource11 = get(configs, 11).priceSource;
565         priceSource12 = get(configs, 12).priceSource;
566         priceSource13 = get(configs, 13).priceSource;
567         priceSource14 = get(configs, 14).priceSource;
568         priceSource15 = get(configs, 15).priceSource;
569         priceSource16 = get(configs, 16).priceSource;
570         priceSource17 = get(configs, 17).priceSource;
571         priceSource18 = get(configs, 18).priceSource;
572         priceSource19 = get(configs, 19).priceSource;
573         priceSource20 = get(configs, 20).priceSource;
574         priceSource21 = get(configs, 21).priceSource;
575         priceSource22 = get(configs, 22).priceSource;
576         priceSource23 = get(configs, 23).priceSource;
577         priceSource24 = get(configs, 24).priceSource;
578         priceSource25 = get(configs, 25).priceSource;
579         priceSource26 = get(configs, 26).priceSource;
580         priceSource27 = get(configs, 27).priceSource;
581         priceSource28 = get(configs, 28).priceSource;
582         priceSource29 = get(configs, 29).priceSource;
583 
584         fixedPrice00 = get(configs, 0).fixedPrice;
585         fixedPrice01 = get(configs, 1).fixedPrice;
586         fixedPrice02 = get(configs, 2).fixedPrice;
587         fixedPrice03 = get(configs, 3).fixedPrice;
588         fixedPrice04 = get(configs, 4).fixedPrice;
589         fixedPrice05 = get(configs, 5).fixedPrice;
590         fixedPrice06 = get(configs, 6).fixedPrice;
591         fixedPrice07 = get(configs, 7).fixedPrice;
592         fixedPrice08 = get(configs, 8).fixedPrice;
593         fixedPrice09 = get(configs, 9).fixedPrice;
594         fixedPrice10 = get(configs, 10).fixedPrice;
595         fixedPrice11 = get(configs, 11).fixedPrice;
596         fixedPrice12 = get(configs, 12).fixedPrice;
597         fixedPrice13 = get(configs, 13).fixedPrice;
598         fixedPrice14 = get(configs, 14).fixedPrice;
599         fixedPrice15 = get(configs, 15).fixedPrice;
600         fixedPrice16 = get(configs, 16).fixedPrice;
601         fixedPrice17 = get(configs, 17).fixedPrice;
602         fixedPrice18 = get(configs, 18).fixedPrice;
603         fixedPrice19 = get(configs, 19).fixedPrice;
604         fixedPrice20 = get(configs, 20).fixedPrice;
605         fixedPrice21 = get(configs, 21).fixedPrice;
606         fixedPrice22 = get(configs, 22).fixedPrice;
607         fixedPrice23 = get(configs, 23).fixedPrice;
608         fixedPrice24 = get(configs, 24).fixedPrice;
609         fixedPrice25 = get(configs, 25).fixedPrice;
610         fixedPrice26 = get(configs, 26).fixedPrice;
611         fixedPrice27 = get(configs, 27).fixedPrice;
612         fixedPrice28 = get(configs, 28).fixedPrice;
613         fixedPrice29 = get(configs, 29).fixedPrice;
614 
615         uniswapMarket00 = get(configs, 0).uniswapMarket;
616         uniswapMarket01 = get(configs, 1).uniswapMarket;
617         uniswapMarket02 = get(configs, 2).uniswapMarket;
618         uniswapMarket03 = get(configs, 3).uniswapMarket;
619         uniswapMarket04 = get(configs, 4).uniswapMarket;
620         uniswapMarket05 = get(configs, 5).uniswapMarket;
621         uniswapMarket06 = get(configs, 6).uniswapMarket;
622         uniswapMarket07 = get(configs, 7).uniswapMarket;
623         uniswapMarket08 = get(configs, 8).uniswapMarket;
624         uniswapMarket09 = get(configs, 9).uniswapMarket;
625         uniswapMarket10 = get(configs, 10).uniswapMarket;
626         uniswapMarket11 = get(configs, 11).uniswapMarket;
627         uniswapMarket12 = get(configs, 12).uniswapMarket;
628         uniswapMarket13 = get(configs, 13).uniswapMarket;
629         uniswapMarket14 = get(configs, 14).uniswapMarket;
630         uniswapMarket15 = get(configs, 15).uniswapMarket;
631         uniswapMarket16 = get(configs, 16).uniswapMarket;
632         uniswapMarket17 = get(configs, 17).uniswapMarket;
633         uniswapMarket18 = get(configs, 18).uniswapMarket;
634         uniswapMarket19 = get(configs, 19).uniswapMarket;
635         uniswapMarket20 = get(configs, 20).uniswapMarket;
636         uniswapMarket21 = get(configs, 21).uniswapMarket;
637         uniswapMarket22 = get(configs, 22).uniswapMarket;
638         uniswapMarket23 = get(configs, 23).uniswapMarket;
639         uniswapMarket24 = get(configs, 24).uniswapMarket;
640         uniswapMarket25 = get(configs, 25).uniswapMarket;
641         uniswapMarket26 = get(configs, 26).uniswapMarket;
642         uniswapMarket27 = get(configs, 27).uniswapMarket;
643         uniswapMarket28 = get(configs, 28).uniswapMarket;
644         uniswapMarket29 = get(configs, 29).uniswapMarket;
645 
646         isUniswapReversed00 = get(configs, 0).isUniswapReversed;
647         isUniswapReversed01 = get(configs, 1).isUniswapReversed;
648         isUniswapReversed02 = get(configs, 2).isUniswapReversed;
649         isUniswapReversed03 = get(configs, 3).isUniswapReversed;
650         isUniswapReversed04 = get(configs, 4).isUniswapReversed;
651         isUniswapReversed05 = get(configs, 5).isUniswapReversed;
652         isUniswapReversed06 = get(configs, 6).isUniswapReversed;
653         isUniswapReversed07 = get(configs, 7).isUniswapReversed;
654         isUniswapReversed08 = get(configs, 8).isUniswapReversed;
655         isUniswapReversed09 = get(configs, 9).isUniswapReversed;
656         isUniswapReversed10 = get(configs, 10).isUniswapReversed;
657         isUniswapReversed11 = get(configs, 11).isUniswapReversed;
658         isUniswapReversed12 = get(configs, 12).isUniswapReversed;
659         isUniswapReversed13 = get(configs, 13).isUniswapReversed;
660         isUniswapReversed14 = get(configs, 14).isUniswapReversed;
661         isUniswapReversed15 = get(configs, 15).isUniswapReversed;
662         isUniswapReversed16 = get(configs, 16).isUniswapReversed;
663         isUniswapReversed17 = get(configs, 17).isUniswapReversed;
664         isUniswapReversed18 = get(configs, 18).isUniswapReversed;
665         isUniswapReversed19 = get(configs, 19).isUniswapReversed;
666         isUniswapReversed20 = get(configs, 20).isUniswapReversed;
667         isUniswapReversed21 = get(configs, 21).isUniswapReversed;
668         isUniswapReversed22 = get(configs, 22).isUniswapReversed;
669         isUniswapReversed23 = get(configs, 23).isUniswapReversed;
670         isUniswapReversed24 = get(configs, 24).isUniswapReversed;
671         isUniswapReversed25 = get(configs, 25).isUniswapReversed;
672         isUniswapReversed26 = get(configs, 26).isUniswapReversed;
673         isUniswapReversed27 = get(configs, 27).isUniswapReversed;
674         isUniswapReversed28 = get(configs, 28).isUniswapReversed;
675         isUniswapReversed29 = get(configs, 29).isUniswapReversed;
676     }
677 
678     function get(TokenConfig[] memory configs, uint i) internal pure returns (TokenConfig memory) {
679         if (i < configs.length)
680             return configs[i];
681         return TokenConfig({
682             cToken: address(0),
683             underlying: address(0),
684             symbolHash: bytes32(0),
685             baseUnit: uint256(0),
686             priceSource: PriceSource(0),
687             fixedPrice: uint256(0),
688             uniswapMarket: address(0),
689             isUniswapReversed: false
690         });
691     }
692 
693     function getCTokenIndex(address cToken) internal view returns (uint) {
694         if (cToken == cToken00) return 0;
695         if (cToken == cToken01) return 1;
696         if (cToken == cToken02) return 2;
697         if (cToken == cToken03) return 3;
698         if (cToken == cToken04) return 4;
699         if (cToken == cToken05) return 5;
700         if (cToken == cToken06) return 6;
701         if (cToken == cToken07) return 7;
702         if (cToken == cToken08) return 8;
703         if (cToken == cToken09) return 9;
704         if (cToken == cToken10) return 10;
705         if (cToken == cToken11) return 11;
706         if (cToken == cToken12) return 12;
707         if (cToken == cToken13) return 13;
708         if (cToken == cToken14) return 14;
709         if (cToken == cToken15) return 15;
710         if (cToken == cToken16) return 16;
711         if (cToken == cToken17) return 17;
712         if (cToken == cToken18) return 18;
713         if (cToken == cToken19) return 19;
714         if (cToken == cToken20) return 20;
715         if (cToken == cToken21) return 21;
716         if (cToken == cToken22) return 22;
717         if (cToken == cToken23) return 23;
718         if (cToken == cToken24) return 24;
719         if (cToken == cToken25) return 25;
720         if (cToken == cToken26) return 26;
721         if (cToken == cToken27) return 27;
722         if (cToken == cToken28) return 28;
723         if (cToken == cToken29) return 29;
724 
725         return uint(-1);
726     }
727 
728     function getUnderlyingIndex(address underlying) internal view returns (uint) {
729         if (underlying == underlying00) return 0;
730         if (underlying == underlying01) return 1;
731         if (underlying == underlying02) return 2;
732         if (underlying == underlying03) return 3;
733         if (underlying == underlying04) return 4;
734         if (underlying == underlying05) return 5;
735         if (underlying == underlying06) return 6;
736         if (underlying == underlying07) return 7;
737         if (underlying == underlying08) return 8;
738         if (underlying == underlying09) return 9;
739         if (underlying == underlying10) return 10;
740         if (underlying == underlying11) return 11;
741         if (underlying == underlying12) return 12;
742         if (underlying == underlying13) return 13;
743         if (underlying == underlying14) return 14;
744         if (underlying == underlying15) return 15;
745         if (underlying == underlying16) return 16;
746         if (underlying == underlying17) return 17;
747         if (underlying == underlying18) return 18;
748         if (underlying == underlying19) return 19;
749         if (underlying == underlying20) return 20;
750         if (underlying == underlying21) return 21;
751         if (underlying == underlying22) return 22;
752         if (underlying == underlying23) return 23;
753         if (underlying == underlying24) return 24;
754         if (underlying == underlying25) return 25;
755         if (underlying == underlying26) return 26;
756         if (underlying == underlying27) return 27;
757         if (underlying == underlying28) return 28;
758         if (underlying == underlying29) return 29;
759 
760         return uint(-1);
761     }
762 
763     function getSymbolHashIndex(bytes32 symbolHash) internal view returns (uint) {
764         if (symbolHash == symbolHash00) return 0;
765         if (symbolHash == symbolHash01) return 1;
766         if (symbolHash == symbolHash02) return 2;
767         if (symbolHash == symbolHash03) return 3;
768         if (symbolHash == symbolHash04) return 4;
769         if (symbolHash == symbolHash05) return 5;
770         if (symbolHash == symbolHash06) return 6;
771         if (symbolHash == symbolHash07) return 7;
772         if (symbolHash == symbolHash08) return 8;
773         if (symbolHash == symbolHash09) return 9;
774         if (symbolHash == symbolHash10) return 10;
775         if (symbolHash == symbolHash11) return 11;
776         if (symbolHash == symbolHash12) return 12;
777         if (symbolHash == symbolHash13) return 13;
778         if (symbolHash == symbolHash14) return 14;
779         if (symbolHash == symbolHash15) return 15;
780         if (symbolHash == symbolHash16) return 16;
781         if (symbolHash == symbolHash17) return 17;
782         if (symbolHash == symbolHash18) return 18;
783         if (symbolHash == symbolHash19) return 19;
784         if (symbolHash == symbolHash20) return 20;
785         if (symbolHash == symbolHash21) return 21;
786         if (symbolHash == symbolHash22) return 22;
787         if (symbolHash == symbolHash23) return 23;
788         if (symbolHash == symbolHash24) return 24;
789         if (symbolHash == symbolHash25) return 25;
790         if (symbolHash == symbolHash26) return 26;
791         if (symbolHash == symbolHash27) return 27;
792         if (symbolHash == symbolHash28) return 28;
793         if (symbolHash == symbolHash29) return 29;
794 
795         return uint(-1);
796     }
797 
798     /**
799      * @notice Get the i-th config, according to the order they were passed in originally
800      * @param i The index of the config to get
801      * @return The config object
802      */
803     function getTokenConfig(uint i) public view returns (TokenConfig memory) {
804         require(i < numTokens, "token config not found");
805 
806         if (i == 0) return TokenConfig({cToken: cToken00, underlying: underlying00, symbolHash: symbolHash00, baseUnit: baseUnit00, priceSource: priceSource00, fixedPrice: fixedPrice00, uniswapMarket: uniswapMarket00, isUniswapReversed: isUniswapReversed00});
807         if (i == 1) return TokenConfig({cToken: cToken01, underlying: underlying01, symbolHash: symbolHash01, baseUnit: baseUnit01, priceSource: priceSource01, fixedPrice: fixedPrice01, uniswapMarket: uniswapMarket01, isUniswapReversed: isUniswapReversed01});
808         if (i == 2) return TokenConfig({cToken: cToken02, underlying: underlying02, symbolHash: symbolHash02, baseUnit: baseUnit02, priceSource: priceSource02, fixedPrice: fixedPrice02, uniswapMarket: uniswapMarket02, isUniswapReversed: isUniswapReversed02});
809         if (i == 3) return TokenConfig({cToken: cToken03, underlying: underlying03, symbolHash: symbolHash03, baseUnit: baseUnit03, priceSource: priceSource03, fixedPrice: fixedPrice03, uniswapMarket: uniswapMarket03, isUniswapReversed: isUniswapReversed03});
810         if (i == 4) return TokenConfig({cToken: cToken04, underlying: underlying04, symbolHash: symbolHash04, baseUnit: baseUnit04, priceSource: priceSource04, fixedPrice: fixedPrice04, uniswapMarket: uniswapMarket04, isUniswapReversed: isUniswapReversed04});
811         if (i == 5) return TokenConfig({cToken: cToken05, underlying: underlying05, symbolHash: symbolHash05, baseUnit: baseUnit05, priceSource: priceSource05, fixedPrice: fixedPrice05, uniswapMarket: uniswapMarket05, isUniswapReversed: isUniswapReversed05});
812         if (i == 6) return TokenConfig({cToken: cToken06, underlying: underlying06, symbolHash: symbolHash06, baseUnit: baseUnit06, priceSource: priceSource06, fixedPrice: fixedPrice06, uniswapMarket: uniswapMarket06, isUniswapReversed: isUniswapReversed06});
813         if (i == 7) return TokenConfig({cToken: cToken07, underlying: underlying07, symbolHash: symbolHash07, baseUnit: baseUnit07, priceSource: priceSource07, fixedPrice: fixedPrice07, uniswapMarket: uniswapMarket07, isUniswapReversed: isUniswapReversed07});
814         if (i == 8) return TokenConfig({cToken: cToken08, underlying: underlying08, symbolHash: symbolHash08, baseUnit: baseUnit08, priceSource: priceSource08, fixedPrice: fixedPrice08, uniswapMarket: uniswapMarket08, isUniswapReversed: isUniswapReversed08});
815         if (i == 9) return TokenConfig({cToken: cToken09, underlying: underlying09, symbolHash: symbolHash09, baseUnit: baseUnit09, priceSource: priceSource09, fixedPrice: fixedPrice09, uniswapMarket: uniswapMarket09, isUniswapReversed: isUniswapReversed09});
816 
817         if (i == 10) return TokenConfig({cToken: cToken10, underlying: underlying10, symbolHash: symbolHash10, baseUnit: baseUnit10, priceSource: priceSource10, fixedPrice: fixedPrice10, uniswapMarket: uniswapMarket10, isUniswapReversed: isUniswapReversed10});
818         if (i == 11) return TokenConfig({cToken: cToken11, underlying: underlying11, symbolHash: symbolHash11, baseUnit: baseUnit11, priceSource: priceSource11, fixedPrice: fixedPrice11, uniswapMarket: uniswapMarket11, isUniswapReversed: isUniswapReversed11});
819         if (i == 12) return TokenConfig({cToken: cToken12, underlying: underlying12, symbolHash: symbolHash12, baseUnit: baseUnit12, priceSource: priceSource12, fixedPrice: fixedPrice12, uniswapMarket: uniswapMarket12, isUniswapReversed: isUniswapReversed12});
820         if (i == 13) return TokenConfig({cToken: cToken13, underlying: underlying13, symbolHash: symbolHash13, baseUnit: baseUnit13, priceSource: priceSource13, fixedPrice: fixedPrice13, uniswapMarket: uniswapMarket13, isUniswapReversed: isUniswapReversed13});
821         if (i == 14) return TokenConfig({cToken: cToken14, underlying: underlying14, symbolHash: symbolHash14, baseUnit: baseUnit14, priceSource: priceSource14, fixedPrice: fixedPrice14, uniswapMarket: uniswapMarket14, isUniswapReversed: isUniswapReversed14});
822         if (i == 15) return TokenConfig({cToken: cToken15, underlying: underlying15, symbolHash: symbolHash15, baseUnit: baseUnit15, priceSource: priceSource15, fixedPrice: fixedPrice15, uniswapMarket: uniswapMarket15, isUniswapReversed: isUniswapReversed15});
823         if (i == 16) return TokenConfig({cToken: cToken16, underlying: underlying16, symbolHash: symbolHash16, baseUnit: baseUnit16, priceSource: priceSource16, fixedPrice: fixedPrice16, uniswapMarket: uniswapMarket16, isUniswapReversed: isUniswapReversed16});
824         if (i == 17) return TokenConfig({cToken: cToken17, underlying: underlying17, symbolHash: symbolHash17, baseUnit: baseUnit17, priceSource: priceSource17, fixedPrice: fixedPrice17, uniswapMarket: uniswapMarket17, isUniswapReversed: isUniswapReversed17});
825         if (i == 18) return TokenConfig({cToken: cToken18, underlying: underlying18, symbolHash: symbolHash18, baseUnit: baseUnit18, priceSource: priceSource18, fixedPrice: fixedPrice18, uniswapMarket: uniswapMarket18, isUniswapReversed: isUniswapReversed18});
826         if (i == 19) return TokenConfig({cToken: cToken19, underlying: underlying19, symbolHash: symbolHash19, baseUnit: baseUnit19, priceSource: priceSource19, fixedPrice: fixedPrice19, uniswapMarket: uniswapMarket19, isUniswapReversed: isUniswapReversed19});
827 
828         if (i == 20) return TokenConfig({cToken: cToken20, underlying: underlying20, symbolHash: symbolHash20, baseUnit: baseUnit20, priceSource: priceSource20, fixedPrice: fixedPrice20, uniswapMarket: uniswapMarket20, isUniswapReversed: isUniswapReversed20});
829         if (i == 21) return TokenConfig({cToken: cToken21, underlying: underlying21, symbolHash: symbolHash21, baseUnit: baseUnit21, priceSource: priceSource21, fixedPrice: fixedPrice21, uniswapMarket: uniswapMarket21, isUniswapReversed: isUniswapReversed21});
830         if (i == 22) return TokenConfig({cToken: cToken22, underlying: underlying22, symbolHash: symbolHash22, baseUnit: baseUnit22, priceSource: priceSource22, fixedPrice: fixedPrice22, uniswapMarket: uniswapMarket22, isUniswapReversed: isUniswapReversed22});
831         if (i == 23) return TokenConfig({cToken: cToken23, underlying: underlying23, symbolHash: symbolHash23, baseUnit: baseUnit23, priceSource: priceSource23, fixedPrice: fixedPrice23, uniswapMarket: uniswapMarket23, isUniswapReversed: isUniswapReversed23});
832         if (i == 24) return TokenConfig({cToken: cToken24, underlying: underlying24, symbolHash: symbolHash24, baseUnit: baseUnit24, priceSource: priceSource24, fixedPrice: fixedPrice24, uniswapMarket: uniswapMarket24, isUniswapReversed: isUniswapReversed24});
833         if (i == 25) return TokenConfig({cToken: cToken25, underlying: underlying25, symbolHash: symbolHash25, baseUnit: baseUnit25, priceSource: priceSource25, fixedPrice: fixedPrice25, uniswapMarket: uniswapMarket25, isUniswapReversed: isUniswapReversed25});
834         if (i == 26) return TokenConfig({cToken: cToken26, underlying: underlying26, symbolHash: symbolHash26, baseUnit: baseUnit26, priceSource: priceSource26, fixedPrice: fixedPrice26, uniswapMarket: uniswapMarket26, isUniswapReversed: isUniswapReversed26});
835         if (i == 27) return TokenConfig({cToken: cToken27, underlying: underlying27, symbolHash: symbolHash27, baseUnit: baseUnit27, priceSource: priceSource27, fixedPrice: fixedPrice27, uniswapMarket: uniswapMarket27, isUniswapReversed: isUniswapReversed27});
836         if (i == 28) return TokenConfig({cToken: cToken28, underlying: underlying28, symbolHash: symbolHash28, baseUnit: baseUnit28, priceSource: priceSource28, fixedPrice: fixedPrice28, uniswapMarket: uniswapMarket28, isUniswapReversed: isUniswapReversed28});
837         if (i == 29) return TokenConfig({cToken: cToken29, underlying: underlying29, symbolHash: symbolHash29, baseUnit: baseUnit29, priceSource: priceSource29, fixedPrice: fixedPrice29, uniswapMarket: uniswapMarket29, isUniswapReversed: isUniswapReversed29});
838     }
839 
840     /**
841      * @notice Get the config for symbol
842      * @param symbol The symbol of the config to get
843      * @return The config object
844      */
845     function getTokenConfigBySymbol(string memory symbol) public view returns (TokenConfig memory) {
846         return getTokenConfigBySymbolHash(keccak256(abi.encodePacked(symbol)));
847     }
848 
849     /**
850      * @notice Get the config for the symbolHash
851      * @param symbolHash The keccack256 of the symbol of the config to get
852      * @return The config object
853      */
854     function getTokenConfigBySymbolHash(bytes32 symbolHash) public view returns (TokenConfig memory) {
855         uint index = getSymbolHashIndex(symbolHash);
856         if (index != uint(-1)) {
857             return getTokenConfig(index);
858         }
859 
860         revert("token config not found");
861     }
862 
863     /**
864      * @notice Get the config for the cToken
865      * @dev If a config for the cToken is not found, falls back to searching for the underlying.
866      * @param cToken The address of the cToken of the config to get
867      * @return The config object
868      */
869     function getTokenConfigByCToken(address cToken) public view returns (TokenConfig memory) {
870         uint index = getCTokenIndex(cToken);
871         if (index != uint(-1)) {
872             return getTokenConfig(index);
873         }
874 
875         return getTokenConfigByUnderlying(CErc20(cToken).underlying());
876     }
877 
878     /**
879      * @notice Get the config for an underlying asset
880      * @param underlying The address of the underlying asset of the config to get
881      * @return The config object
882      */
883     function getTokenConfigByUnderlying(address underlying) public view returns (TokenConfig memory) {
884         uint index = getUnderlyingIndex(underlying);
885         if (index != uint(-1)) {
886             return getTokenConfig(index);
887         }
888 
889         revert("token config not found");
890     }
891 }
892 
893 
894 
895 
896 // Based on code from https://github.com/Uniswap/uniswap-v2-periphery
897 
898 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
899 library FixedPoint {
900     // range: [0, 2**112 - 1]
901     // resolution: 1 / 2**112
902     struct uq112x112 {
903         uint224 _x;
904     }
905 
906     // returns a uq112x112 which represents the ratio of the numerator to the denominator
907     // equivalent to encode(numerator).div(denominator)
908     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
909         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
910         return uq112x112((uint224(numerator) << 112) / denominator);
911     }
912 
913     // decode a uq112x112 into a uint with 18 decimals of precision
914     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
915         // we only have 256 - 224 = 32 bits to spare, so scaling up by ~60 bits is dangerous
916         // instead, get close to:
917         //  (x * 1e18) >> 112
918         // without risk of overflowing, e.g.:
919         //  (x) / 2 ** (112 - lg(1e18))
920         return uint(self._x) / 5192296858534827;
921     }
922 }
923 
924 // library with helper methods for oracles that are concerned with computing average prices
925 library UniswapV2OracleLibrary {
926     using FixedPoint for *;
927 
928     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
929     function currentBlockTimestamp() internal view returns (uint32) {
930         return uint32(block.timestamp % 2 ** 32);
931     }
932 
933     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
934     function currentCumulativePrices(
935         address pair
936     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
937         blockTimestamp = currentBlockTimestamp();
938         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
939         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
940 
941         // if time has elapsed since the last update on the pair, mock the accumulated price values
942         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
943         if (blockTimestampLast != blockTimestamp) {
944             // subtraction overflow is desired
945             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
946             // addition overflow is desired
947             // counterfactual
948             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
949             // counterfactual
950             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
951         }
952     }
953 }
954 
955 interface IUniswapV2Pair {
956     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
957     function price0CumulativeLast() external view returns (uint);
958     function price1CumulativeLast() external view returns (uint);
959 }
960 
961 
962 struct Observation {
963     uint timestamp;
964     uint acc;
965 }
966 
967 contract UniswapAnchoredView is UniswapConfig {
968     using FixedPoint for *;
969 
970     /// @notice The Open Oracle Price Data contract
971     OpenOraclePriceData public immutable priceData;
972 
973     /// @notice The number of wei in 1 ETH
974     uint public constant ethBaseUnit = 1e18;
975 
976     /// @notice A common scaling factor to maintain precision
977     uint public constant expScale = 1e18;
978 
979     /// @notice The Open Oracle Reporter
980     address public immutable reporter;
981 
982     /// @notice The highest ratio of the new price to the anchor price that will still trigger the price to be updated
983     uint public immutable upperBoundAnchorRatio;
984 
985     /// @notice The lowest ratio of the new price to the anchor price that will still trigger the price to be updated
986     uint public immutable lowerBoundAnchorRatio;
987 
988     /// @notice The minimum amount of time in seconds required for the old uniswap price accumulator to be replaced
989     uint public immutable anchorPeriod;
990 
991     /// @notice Official prices by symbol hash
992     mapping(bytes32 => uint) public prices;
993 
994     /// @notice Circuit breaker for using anchor price oracle directly, ignoring reporter
995     bool public reporterInvalidated;
996 
997     /// @notice The old observation for each symbolHash
998     mapping(bytes32 => Observation) public oldObservations;
999 
1000     /// @notice The new observation for each symbolHash
1001     mapping(bytes32 => Observation) public newObservations;
1002 
1003     /// @notice The event emitted when new prices are posted but the stored price is not updated due to the anchor
1004     event PriceGuarded(string symbol, uint reporter, uint anchor);
1005 
1006     /// @notice The event emitted when the stored price is updated
1007     event PriceUpdated(string symbol, uint price);
1008 
1009     /// @notice The event emitted when anchor price is updated
1010     event AnchorPriceUpdated(string symbol, uint anchorPrice, uint oldTimestamp, uint newTimestamp);
1011 
1012     /// @notice The event emitted when the uniswap window changes
1013     event UniswapWindowUpdated(bytes32 indexed symbolHash, uint oldTimestamp, uint newTimestamp, uint oldPrice, uint newPrice);
1014 
1015     /// @notice The event emitted when reporter invalidates itself
1016     event ReporterInvalidated(address reporter);
1017 
1018     bytes32 constant ethHash = keccak256(abi.encodePacked("ETH"));
1019     bytes32 constant rotateHash = keccak256(abi.encodePacked("rotate"));
1020 
1021     /**
1022      * @notice Construct a uniswap anchored view for a set of token configurations
1023      * @dev Note that to avoid immature TWAPs, the system must run for at least a single anchorPeriod before using.
1024      * @param reporter_ The reporter whose prices are to be used
1025      * @param anchorToleranceMantissa_ The percentage tolerance that the reporter may deviate from the uniswap anchor
1026      * @param anchorPeriod_ The minimum amount of time required for the old uniswap price accumulator to be replaced
1027      * @param configs The static token configurations which define what prices are supported and how
1028      */
1029     constructor(OpenOraclePriceData priceData_,
1030                 address reporter_,
1031                 uint anchorToleranceMantissa_,
1032                 uint anchorPeriod_,
1033                 TokenConfig[] memory configs) UniswapConfig(configs) public {
1034         priceData = priceData_;
1035         reporter = reporter_;
1036         anchorPeriod = anchorPeriod_;
1037 
1038         // Allow the tolerance to be whatever the deployer chooses, but prevent under/overflow (and prices from being 0)
1039         upperBoundAnchorRatio = anchorToleranceMantissa_ > uint(-1) - 100e16 ? uint(-1) : 100e16 + anchorToleranceMantissa_;
1040         lowerBoundAnchorRatio = anchorToleranceMantissa_ < 100e16 ? 100e16 - anchorToleranceMantissa_ : 1;
1041 
1042         for (uint i = 0; i < configs.length; i++) {
1043             TokenConfig memory config = configs[i];
1044             require(config.baseUnit > 0, "baseUnit must be greater than zero");
1045             address uniswapMarket = config.uniswapMarket;
1046             if (config.priceSource == PriceSource.REPORTER) {
1047                 require(uniswapMarket != address(0), "reported prices must have an anchor");
1048                 bytes32 symbolHash = config.symbolHash;
1049                 uint cumulativePrice = currentCumulativePrice(config);
1050                 oldObservations[symbolHash].timestamp = block.timestamp;
1051                 newObservations[symbolHash].timestamp = block.timestamp;
1052                 oldObservations[symbolHash].acc = cumulativePrice;
1053                 newObservations[symbolHash].acc = cumulativePrice;
1054                 emit UniswapWindowUpdated(symbolHash, block.timestamp, block.timestamp, cumulativePrice, cumulativePrice);
1055             } else {
1056                 require(uniswapMarket == address(0), "only reported prices utilize an anchor");
1057             }
1058         }
1059     }
1060 
1061     /**
1062      * @notice Get the official price for a symbol
1063      * @param symbol The symbol to fetch the price of
1064      * @return Price denominated in USD, with 6 decimals
1065      */
1066     function price(string memory symbol) external view returns (uint) {
1067         TokenConfig memory config = getTokenConfigBySymbol(symbol);
1068         return priceInternal(config);
1069     }
1070 
1071     function priceInternal(TokenConfig memory config) internal view returns (uint) {
1072         if (config.priceSource == PriceSource.REPORTER) return prices[config.symbolHash];
1073         if (config.priceSource == PriceSource.FIXED_USD) return config.fixedPrice;
1074         if (config.priceSource == PriceSource.FIXED_ETH) {
1075             uint usdPerEth = prices[ethHash];
1076             require(usdPerEth > 0, "ETH price not set, cannot convert to dollars");
1077             return mul(usdPerEth, config.fixedPrice) / ethBaseUnit;
1078         }
1079     }
1080 
1081     /**
1082      * @notice Get the underlying price of a cToken
1083      * @dev Implements the PriceOracle interface for Compound v2.
1084      * @param cToken The cToken address for price retrieval
1085      * @return Price denominated in USD, with 18 decimals, for the given cToken address
1086      */
1087     function getUnderlyingPrice(address cToken) external view returns (uint) {
1088         TokenConfig memory config = getTokenConfigByCToken(cToken);
1089          // Comptroller needs prices in the format: ${raw price} * 1e(36 - baseUnit)
1090          // Since the prices in this view have 6 decimals, we must scale them by 1e(36 - 6 - baseUnit)
1091         return mul(1e30, priceInternal(config)) / config.baseUnit;
1092     }
1093 
1094     /**
1095      * @notice Post open oracle reporter prices, and recalculate stored price by comparing to anchor
1096      * @dev We let anyone pay to post anything, but only prices from configured reporter will be stored in the view.
1097      * @param messages The messages to post to the oracle
1098      * @param signatures The signatures for the corresponding messages
1099      * @param symbols The symbols to compare to anchor for authoritative reading
1100      */
1101     function postPrices(bytes[] calldata messages, bytes[] calldata signatures, string[] calldata symbols) external {
1102         require(messages.length == signatures.length, "messages and signatures must be 1:1");
1103 
1104         // Save the prices
1105         for (uint i = 0; i < messages.length; i++) {
1106             priceData.put(messages[i], signatures[i]);
1107         }
1108 
1109         uint ethPrice = fetchEthPrice();
1110 
1111         // Try to update the view storage
1112         for (uint i = 0; i < symbols.length; i++) {
1113             postPriceInternal(symbols[i], ethPrice);
1114         }
1115     }
1116 
1117     function postPriceInternal(string memory symbol, uint ethPrice) internal {
1118         TokenConfig memory config = getTokenConfigBySymbol(symbol);
1119         require(config.priceSource == PriceSource.REPORTER, "only reporter prices get posted");
1120 
1121         bytes32 symbolHash = keccak256(abi.encodePacked(symbol));
1122         uint reporterPrice = priceData.getPrice(reporter, symbol);
1123         uint anchorPrice;
1124         if (symbolHash == ethHash) {
1125             anchorPrice = ethPrice;
1126         } else {
1127             anchorPrice = fetchAnchorPrice(symbol, config, ethPrice);
1128         }
1129 
1130         if (reporterInvalidated) {
1131             prices[symbolHash] = anchorPrice;
1132             emit PriceUpdated(symbol, anchorPrice);
1133         } else if (isWithinAnchor(reporterPrice, anchorPrice)) {
1134             prices[symbolHash] = reporterPrice;
1135             emit PriceUpdated(symbol, reporterPrice);
1136         } else {
1137             emit PriceGuarded(symbol, reporterPrice, anchorPrice);
1138         }
1139     }
1140 
1141     function isWithinAnchor(uint reporterPrice, uint anchorPrice) internal view returns (bool) {
1142         if (reporterPrice > 0) {
1143             uint anchorRatio = mul(anchorPrice, 100e16) / reporterPrice;
1144             return anchorRatio <= upperBoundAnchorRatio && anchorRatio >= lowerBoundAnchorRatio;
1145         }
1146         return false;
1147     }
1148 
1149     /**
1150      * @dev Fetches the current token/eth price accumulator from uniswap.
1151      */
1152     function currentCumulativePrice(TokenConfig memory config) internal view returns (uint) {
1153         (uint cumulativePrice0, uint cumulativePrice1,) = UniswapV2OracleLibrary.currentCumulativePrices(config.uniswapMarket);
1154         if (config.isUniswapReversed) {
1155             return cumulativePrice1;
1156         } else {
1157             return cumulativePrice0;
1158         }
1159     }
1160 
1161     /**
1162      * @dev Fetches the current eth/usd price from uniswap, with 6 decimals of precision.
1163      *  Conversion factor is 1e18 for eth/usdc market, since we decode uniswap price statically with 18 decimals.
1164      */
1165     function fetchEthPrice() internal returns (uint) {
1166         return fetchAnchorPrice("ETH", getTokenConfigBySymbolHash(ethHash), ethBaseUnit);
1167     }
1168 
1169     /**
1170      * @dev Fetches the current token/usd price from uniswap, with 6 decimals of precision.
1171      * @param conversionFactor 1e18 if seeking the ETH price, and a 6 decimal ETH-USDC price in the case of other assets
1172      */
1173     function fetchAnchorPrice(string memory symbol, TokenConfig memory config, uint conversionFactor) internal virtual returns (uint) {
1174         (uint nowCumulativePrice, uint oldCumulativePrice, uint oldTimestamp) = pokeWindowValues(config);
1175 
1176         // This should be impossible, but better safe than sorry
1177         require(block.timestamp > oldTimestamp, "now must come after before");
1178         uint timeElapsed = block.timestamp - oldTimestamp;
1179 
1180         // Calculate uniswap time-weighted average price
1181         // Underflow is a property of the accumulators: https://uniswap.org/audit.html#orgc9b3190
1182         FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(uint224((nowCumulativePrice - oldCumulativePrice) / timeElapsed));
1183         uint rawUniswapPriceMantissa = priceAverage.decode112with18();
1184         uint unscaledPriceMantissa = mul(rawUniswapPriceMantissa, conversionFactor);
1185         uint anchorPrice;
1186 
1187         // Adjust rawUniswapPrice according to the units of the non-ETH asset
1188         // In the case of ETH, we would have to scale by 1e6 / USDC_UNITS, but since baseUnit2 is 1e6 (USDC), it cancels
1189         if (config.isUniswapReversed) {
1190             // unscaledPriceMantissa * ethBaseUnit / config.baseUnit / expScale, but we simplify bc ethBaseUnit == expScale
1191             anchorPrice = unscaledPriceMantissa / config.baseUnit;
1192         } else {
1193             anchorPrice = mul(unscaledPriceMantissa, config.baseUnit) / ethBaseUnit / expScale;
1194         }
1195 
1196         emit AnchorPriceUpdated(symbol, anchorPrice, oldTimestamp, block.timestamp);
1197 
1198         return anchorPrice;
1199     }
1200 
1201     /**
1202      * @dev Get time-weighted average prices for a token at the current timestamp.
1203      *  Update new and old observations of lagging window if period elapsed.
1204      */
1205     function pokeWindowValues(TokenConfig memory config) internal returns (uint, uint, uint) {
1206         bytes32 symbolHash = config.symbolHash;
1207         uint cumulativePrice = currentCumulativePrice(config);
1208 
1209         Observation memory newObservation = newObservations[symbolHash];
1210 
1211         // Update new and old observations if elapsed time is greater than or equal to anchor period
1212         uint timeElapsed = block.timestamp - newObservation.timestamp;
1213         if (timeElapsed >= anchorPeriod) {
1214             oldObservations[symbolHash].timestamp = newObservation.timestamp;
1215             oldObservations[symbolHash].acc = newObservation.acc;
1216 
1217             newObservations[symbolHash].timestamp = block.timestamp;
1218             newObservations[symbolHash].acc = cumulativePrice;
1219             emit UniswapWindowUpdated(config.symbolHash, newObservation.timestamp, block.timestamp, newObservation.acc, cumulativePrice);
1220         }
1221         return (cumulativePrice, oldObservations[symbolHash].acc, oldObservations[symbolHash].timestamp);
1222     }
1223 
1224     /**
1225      * @notice Invalidate the reporter, and fall back to using anchor directly in all cases
1226      * @dev Only the reporter may sign a message which allows it to invalidate itself.
1227      *  To be used in cases of emergency, if the reporter thinks their key may be compromised.
1228      * @param message The data that was presumably signed
1229      * @param signature The fingerprint of the data + private key
1230      */
1231     function invalidateReporter(bytes memory message, bytes memory signature) external {
1232         (string memory decodedMessage, ) = abi.decode(message, (string, address));
1233         require(keccak256(abi.encodePacked(decodedMessage)) == rotateHash, "invalid message must be 'rotate'");
1234         require(source(message, signature) == reporter, "invalidation message must come from the reporter");
1235         reporterInvalidated = true;
1236         emit ReporterInvalidated(reporter);
1237     }
1238 
1239     /**
1240      * @notice Recovers the source address which signed a message
1241      * @dev Comparing to a claimed address would add nothing,
1242      *  as the caller could simply perform the recover and claim that address.
1243      * @param message The data that was presumably signed
1244      * @param signature The fingerprint of the data + private key
1245      * @return The source address which signed the message, presumably
1246      */
1247     function source(bytes memory message, bytes memory signature) public pure returns (address) {
1248         (bytes32 r, bytes32 s, uint8 v) = abi.decode(signature, (bytes32, bytes32, uint8));
1249         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(message)));
1250         return ecrecover(hash, v, r, s);
1251     }
1252 
1253     /// @dev Overflow proof multiplication
1254     function mul(uint a, uint b) internal pure returns (uint) {
1255         if (a == 0) return 0;
1256         uint c = a * b;
1257         require(c / a == b, "multiplication overflow");
1258         return c;
1259     }
1260 }