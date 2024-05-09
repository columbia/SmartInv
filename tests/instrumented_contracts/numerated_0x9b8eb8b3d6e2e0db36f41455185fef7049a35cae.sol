1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity ^0.6.10;
4 pragma experimental ABIEncoderV2;
5 
6 
7 
8 
9 
10 
11 
12 
13 /**
14  * @title The Open Oracle Data Base Contract
15  * @author Compound Labs, Inc.
16  */
17 contract OpenOracleData {
18     /**
19      * @notice The event emitted when a source writes to its storage
20      */
21     //event Write(address indexed source, <Key> indexed key, string kind, uint64 timestamp, <Value> value);
22 
23     /**
24      * @notice Write a bunch of signed datum to the authenticated storage mapping
25      * @param message The payload containing the timestamp, and (key, value) pairs
26      * @param signature The cryptographic signature of the message payload, authorizing the source to write
27      * @return The keys that were written
28      */
29     //function put(bytes calldata message, bytes calldata signature) external returns (<Key> memory);
30 
31     /**
32      * @notice Read a single key with a pre-defined type signature from an authenticated source
33      * @param source The verifiable author of the data
34      * @param key The selector for the value to return
35      * @return The claimed Unix timestamp for the data and the encoded value (defaults to (0, 0x))
36      */
37     //function get(address source, <Key> key) external view returns (uint, <Value>);
38 
39     /**
40      * @notice Recovers the source address which signed a message
41      * @dev Comparing to a claimed address would add nothing,
42      *  as the caller could simply perform the recover and claim that address.
43      * @param message The data that was presumably signed
44      * @param signature The fingerprint of the data + private key
45      * @return The source address which signed the message, presumably
46      */
47     function source(bytes memory message, bytes memory signature) public pure returns (address) {
48         (bytes32 r, bytes32 s, uint8 v) = abi.decode(signature, (bytes32, bytes32, uint8));
49         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(message)));
50         return ecrecover(hash, v, r, s);
51     }
52 }
53 
54 
55 /**
56  * @title The Open Oracle Price Data Contract
57  * @notice Values stored in this contract should represent a USD price with 6 decimals precision
58  * @author Compound Labs, Inc.
59  */
60 contract OpenOraclePriceData is OpenOracleData {
61     ///@notice The event emitted when a source writes to its storage
62     event Write(address indexed source, string key, uint64 timestamp, uint64 value);
63     ///@notice The event emitted when the timestamp on a price is invalid and it is not written to storage
64     event NotWritten(uint64 priorTimestamp, uint256 messageTimestamp, uint256 blockTimestamp);
65 
66     ///@notice The fundamental unit of storage for a reporter source
67     struct Datum {
68         uint64 timestamp;
69         uint64 value;
70     }
71 
72     /**
73      * @dev The most recent authenticated data from all sources.
74      *  This is private because dynamic mapping keys preclude auto-generated getters.
75      */
76     mapping(address => mapping(string => Datum)) private data;
77 
78     /**
79      * @notice Write a bunch of signed datum to the authenticated storage mapping
80      * @param message The payload containing the timestamp, and (key, value) pairs
81      * @param signature The cryptographic signature of the message payload, authorizing the source to write
82      * @return The keys that were written
83      */
84     function put(bytes calldata message, bytes calldata signature) external returns (string memory) {
85         (address source, uint64 timestamp, string memory key, uint64 value) = decodeMessage(message, signature);
86         return putInternal(source, timestamp, key, value);
87     }
88 
89     function putInternal(address source, uint64 timestamp, string memory key, uint64 value) internal returns (string memory) {
90         // Only update if newer than stored, according to source
91         Datum storage prior = data[source][key];
92         if (timestamp > prior.timestamp && timestamp < block.timestamp + 60 minutes && source != address(0)) {
93             data[source][key] = Datum(timestamp, value);
94             emit Write(source, key, timestamp, value);
95         } else {
96             emit NotWritten(prior.timestamp, timestamp, block.timestamp);
97         }
98         return key;
99     }
100 
101     function decodeMessage(bytes calldata message, bytes calldata signature) internal pure returns (address, uint64, string memory, uint64) {
102         // Recover the source address
103         address source = source(message, signature);
104 
105         // Decode the message and check the kind
106         (string memory kind, uint64 timestamp, string memory key, uint64 value) = abi.decode(message, (string, uint64, string, uint64));
107         require(keccak256(abi.encodePacked(kind)) == keccak256(abi.encodePacked("prices")), "Kind of data must be 'prices'");
108         return (source, timestamp, key, value);
109     }
110 
111     /**
112      * @notice Read a single key from an authenticated source
113      * @param source The verifiable author of the data
114      * @param key The selector for the value to return
115      * @return The claimed Unix timestamp for the data and the price value (defaults to (0, 0))
116      */
117     function get(address source, string calldata key) external view returns (uint64, uint64) {
118         Datum storage datum = data[source][key];
119         return (datum.timestamp, datum.value);
120     }
121 
122     /**
123      * @notice Read only the value for a single key from an authenticated source
124      * @param source The verifiable author of the data
125      * @param key The selector for the value to return
126      * @return The price value (defaults to 0)
127      */
128     function getPrice(address source, string calldata key) external view returns (uint64) {
129         return data[source][key].value;
130     }
131 }
132 
133 
134 
135 
136 
137 interface CErc20 {
138     function underlying() external view returns (address);
139 }
140 
141 contract UniswapConfig {
142     /// @dev Describe how to interpret the fixedPrice in the TokenConfig.
143     enum PriceSource {
144         FIXED_ETH, /// implies the fixedPrice is a constant multiple of the ETH price (which varies)
145         FIXED_USD, /// implies the fixedPrice is a constant multiple of the USD price (which is 1)
146         REPORTER   /// implies the price is set by the reporter
147     }
148 
149     /// @dev Describe how the USD price should be determined for an asset.
150     ///  There should be 1 TokenConfig object for each supported asset, passed in the constructor.
151     struct TokenConfig {
152         address cToken;
153         address underlying;
154         bytes32 symbolHash;
155         uint256 baseUnit;
156         PriceSource priceSource;
157         uint256 fixedPrice;
158         address uniswapMarket;
159         bool isUniswapReversed;
160     }
161 
162     /// @notice The max number of tokens this contract is hardcoded to support
163     /// @dev Do not change this variable without updating all the fields throughout the contract.
164     uint public constant maxTokens = 30;
165 
166     /// @notice The number of tokens this contract actually supports
167     uint public immutable numTokens;
168 
169     address internal immutable cToken00;
170     address internal immutable cToken01;
171     address internal immutable cToken02;
172     address internal immutable cToken03;
173     address internal immutable cToken04;
174     address internal immutable cToken05;
175     address internal immutable cToken06;
176     address internal immutable cToken07;
177     address internal immutable cToken08;
178     address internal immutable cToken09;
179     address internal immutable cToken10;
180     address internal immutable cToken11;
181     address internal immutable cToken12;
182     address internal immutable cToken13;
183     address internal immutable cToken14;
184     address internal immutable cToken15;
185     address internal immutable cToken16;
186     address internal immutable cToken17;
187     address internal immutable cToken18;
188     address internal immutable cToken19;
189     address internal immutable cToken20;
190     address internal immutable cToken21;
191     address internal immutable cToken22;
192     address internal immutable cToken23;
193     address internal immutable cToken24;
194     address internal immutable cToken25;
195     address internal immutable cToken26;
196     address internal immutable cToken27;
197     address internal immutable cToken28;
198     address internal immutable cToken29;
199 
200     address internal immutable underlying00;
201     address internal immutable underlying01;
202     address internal immutable underlying02;
203     address internal immutable underlying03;
204     address internal immutable underlying04;
205     address internal immutable underlying05;
206     address internal immutable underlying06;
207     address internal immutable underlying07;
208     address internal immutable underlying08;
209     address internal immutable underlying09;
210     address internal immutable underlying10;
211     address internal immutable underlying11;
212     address internal immutable underlying12;
213     address internal immutable underlying13;
214     address internal immutable underlying14;
215     address internal immutable underlying15;
216     address internal immutable underlying16;
217     address internal immutable underlying17;
218     address internal immutable underlying18;
219     address internal immutable underlying19;
220     address internal immutable underlying20;
221     address internal immutable underlying21;
222     address internal immutable underlying22;
223     address internal immutable underlying23;
224     address internal immutable underlying24;
225     address internal immutable underlying25;
226     address internal immutable underlying26;
227     address internal immutable underlying27;
228     address internal immutable underlying28;
229     address internal immutable underlying29;
230 
231     bytes32 internal immutable symbolHash00;
232     bytes32 internal immutable symbolHash01;
233     bytes32 internal immutable symbolHash02;
234     bytes32 internal immutable symbolHash03;
235     bytes32 internal immutable symbolHash04;
236     bytes32 internal immutable symbolHash05;
237     bytes32 internal immutable symbolHash06;
238     bytes32 internal immutable symbolHash07;
239     bytes32 internal immutable symbolHash08;
240     bytes32 internal immutable symbolHash09;
241     bytes32 internal immutable symbolHash10;
242     bytes32 internal immutable symbolHash11;
243     bytes32 internal immutable symbolHash12;
244     bytes32 internal immutable symbolHash13;
245     bytes32 internal immutable symbolHash14;
246     bytes32 internal immutable symbolHash15;
247     bytes32 internal immutable symbolHash16;
248     bytes32 internal immutable symbolHash17;
249     bytes32 internal immutable symbolHash18;
250     bytes32 internal immutable symbolHash19;
251     bytes32 internal immutable symbolHash20;
252     bytes32 internal immutable symbolHash21;
253     bytes32 internal immutable symbolHash22;
254     bytes32 internal immutable symbolHash23;
255     bytes32 internal immutable symbolHash24;
256     bytes32 internal immutable symbolHash25;
257     bytes32 internal immutable symbolHash26;
258     bytes32 internal immutable symbolHash27;
259     bytes32 internal immutable symbolHash28;
260     bytes32 internal immutable symbolHash29;
261 
262     uint256 internal immutable baseUnit00;
263     uint256 internal immutable baseUnit01;
264     uint256 internal immutable baseUnit02;
265     uint256 internal immutable baseUnit03;
266     uint256 internal immutable baseUnit04;
267     uint256 internal immutable baseUnit05;
268     uint256 internal immutable baseUnit06;
269     uint256 internal immutable baseUnit07;
270     uint256 internal immutable baseUnit08;
271     uint256 internal immutable baseUnit09;
272     uint256 internal immutable baseUnit10;
273     uint256 internal immutable baseUnit11;
274     uint256 internal immutable baseUnit12;
275     uint256 internal immutable baseUnit13;
276     uint256 internal immutable baseUnit14;
277     uint256 internal immutable baseUnit15;
278     uint256 internal immutable baseUnit16;
279     uint256 internal immutable baseUnit17;
280     uint256 internal immutable baseUnit18;
281     uint256 internal immutable baseUnit19;
282     uint256 internal immutable baseUnit20;
283     uint256 internal immutable baseUnit21;
284     uint256 internal immutable baseUnit22;
285     uint256 internal immutable baseUnit23;
286     uint256 internal immutable baseUnit24;
287     uint256 internal immutable baseUnit25;
288     uint256 internal immutable baseUnit26;
289     uint256 internal immutable baseUnit27;
290     uint256 internal immutable baseUnit28;
291     uint256 internal immutable baseUnit29;
292 
293     PriceSource internal immutable priceSource00;
294     PriceSource internal immutable priceSource01;
295     PriceSource internal immutable priceSource02;
296     PriceSource internal immutable priceSource03;
297     PriceSource internal immutable priceSource04;
298     PriceSource internal immutable priceSource05;
299     PriceSource internal immutable priceSource06;
300     PriceSource internal immutable priceSource07;
301     PriceSource internal immutable priceSource08;
302     PriceSource internal immutable priceSource09;
303     PriceSource internal immutable priceSource10;
304     PriceSource internal immutable priceSource11;
305     PriceSource internal immutable priceSource12;
306     PriceSource internal immutable priceSource13;
307     PriceSource internal immutable priceSource14;
308     PriceSource internal immutable priceSource15;
309     PriceSource internal immutable priceSource16;
310     PriceSource internal immutable priceSource17;
311     PriceSource internal immutable priceSource18;
312     PriceSource internal immutable priceSource19;
313     PriceSource internal immutable priceSource20;
314     PriceSource internal immutable priceSource21;
315     PriceSource internal immutable priceSource22;
316     PriceSource internal immutable priceSource23;
317     PriceSource internal immutable priceSource24;
318     PriceSource internal immutable priceSource25;
319     PriceSource internal immutable priceSource26;
320     PriceSource internal immutable priceSource27;
321     PriceSource internal immutable priceSource28;
322     PriceSource internal immutable priceSource29;
323 
324     uint256 internal immutable fixedPrice00;
325     uint256 internal immutable fixedPrice01;
326     uint256 internal immutable fixedPrice02;
327     uint256 internal immutable fixedPrice03;
328     uint256 internal immutable fixedPrice04;
329     uint256 internal immutable fixedPrice05;
330     uint256 internal immutable fixedPrice06;
331     uint256 internal immutable fixedPrice07;
332     uint256 internal immutable fixedPrice08;
333     uint256 internal immutable fixedPrice09;
334     uint256 internal immutable fixedPrice10;
335     uint256 internal immutable fixedPrice11;
336     uint256 internal immutable fixedPrice12;
337     uint256 internal immutable fixedPrice13;
338     uint256 internal immutable fixedPrice14;
339     uint256 internal immutable fixedPrice15;
340     uint256 internal immutable fixedPrice16;
341     uint256 internal immutable fixedPrice17;
342     uint256 internal immutable fixedPrice18;
343     uint256 internal immutable fixedPrice19;
344     uint256 internal immutable fixedPrice20;
345     uint256 internal immutable fixedPrice21;
346     uint256 internal immutable fixedPrice22;
347     uint256 internal immutable fixedPrice23;
348     uint256 internal immutable fixedPrice24;
349     uint256 internal immutable fixedPrice25;
350     uint256 internal immutable fixedPrice26;
351     uint256 internal immutable fixedPrice27;
352     uint256 internal immutable fixedPrice28;
353     uint256 internal immutable fixedPrice29;
354 
355     address internal immutable uniswapMarket00;
356     address internal immutable uniswapMarket01;
357     address internal immutable uniswapMarket02;
358     address internal immutable uniswapMarket03;
359     address internal immutable uniswapMarket04;
360     address internal immutable uniswapMarket05;
361     address internal immutable uniswapMarket06;
362     address internal immutable uniswapMarket07;
363     address internal immutable uniswapMarket08;
364     address internal immutable uniswapMarket09;
365     address internal immutable uniswapMarket10;
366     address internal immutable uniswapMarket11;
367     address internal immutable uniswapMarket12;
368     address internal immutable uniswapMarket13;
369     address internal immutable uniswapMarket14;
370     address internal immutable uniswapMarket15;
371     address internal immutable uniswapMarket16;
372     address internal immutable uniswapMarket17;
373     address internal immutable uniswapMarket18;
374     address internal immutable uniswapMarket19;
375     address internal immutable uniswapMarket20;
376     address internal immutable uniswapMarket21;
377     address internal immutable uniswapMarket22;
378     address internal immutable uniswapMarket23;
379     address internal immutable uniswapMarket24;
380     address internal immutable uniswapMarket25;
381     address internal immutable uniswapMarket26;
382     address internal immutable uniswapMarket27;
383     address internal immutable uniswapMarket28;
384     address internal immutable uniswapMarket29;
385 
386     bool internal immutable isUniswapReversed00;
387     bool internal immutable isUniswapReversed01;
388     bool internal immutable isUniswapReversed02;
389     bool internal immutable isUniswapReversed03;
390     bool internal immutable isUniswapReversed04;
391     bool internal immutable isUniswapReversed05;
392     bool internal immutable isUniswapReversed06;
393     bool internal immutable isUniswapReversed07;
394     bool internal immutable isUniswapReversed08;
395     bool internal immutable isUniswapReversed09;
396     bool internal immutable isUniswapReversed10;
397     bool internal immutable isUniswapReversed11;
398     bool internal immutable isUniswapReversed12;
399     bool internal immutable isUniswapReversed13;
400     bool internal immutable isUniswapReversed14;
401     bool internal immutable isUniswapReversed15;
402     bool internal immutable isUniswapReversed16;
403     bool internal immutable isUniswapReversed17;
404     bool internal immutable isUniswapReversed18;
405     bool internal immutable isUniswapReversed19;
406     bool internal immutable isUniswapReversed20;
407     bool internal immutable isUniswapReversed21;
408     bool internal immutable isUniswapReversed22;
409     bool internal immutable isUniswapReversed23;
410     bool internal immutable isUniswapReversed24;
411     bool internal immutable isUniswapReversed25;
412     bool internal immutable isUniswapReversed26;
413     bool internal immutable isUniswapReversed27;
414     bool internal immutable isUniswapReversed28;
415     bool internal immutable isUniswapReversed29;
416 
417     /**
418      * @notice Construct an immutable store of configs into the contract data
419      * @param configs The configs for the supported assets
420      */
421     constructor(TokenConfig[] memory configs) public {
422         require(configs.length <= maxTokens, "too many configs");
423         numTokens = configs.length;
424 
425         cToken00 = get(configs, 0).cToken;
426         cToken01 = get(configs, 1).cToken;
427         cToken02 = get(configs, 2).cToken;
428         cToken03 = get(configs, 3).cToken;
429         cToken04 = get(configs, 4).cToken;
430         cToken05 = get(configs, 5).cToken;
431         cToken06 = get(configs, 6).cToken;
432         cToken07 = get(configs, 7).cToken;
433         cToken08 = get(configs, 8).cToken;
434         cToken09 = get(configs, 9).cToken;
435         cToken10 = get(configs, 10).cToken;
436         cToken11 = get(configs, 11).cToken;
437         cToken12 = get(configs, 12).cToken;
438         cToken13 = get(configs, 13).cToken;
439         cToken14 = get(configs, 14).cToken;
440         cToken15 = get(configs, 15).cToken;
441         cToken16 = get(configs, 16).cToken;
442         cToken17 = get(configs, 17).cToken;
443         cToken18 = get(configs, 18).cToken;
444         cToken19 = get(configs, 19).cToken;
445         cToken20 = get(configs, 20).cToken;
446         cToken21 = get(configs, 21).cToken;
447         cToken22 = get(configs, 22).cToken;
448         cToken23 = get(configs, 23).cToken;
449         cToken24 = get(configs, 24).cToken;
450         cToken25 = get(configs, 25).cToken;
451         cToken26 = get(configs, 26).cToken;
452         cToken27 = get(configs, 27).cToken;
453         cToken28 = get(configs, 28).cToken;
454         cToken29 = get(configs, 29).cToken;
455 
456         underlying00 = get(configs, 0).underlying;
457         underlying01 = get(configs, 1).underlying;
458         underlying02 = get(configs, 2).underlying;
459         underlying03 = get(configs, 3).underlying;
460         underlying04 = get(configs, 4).underlying;
461         underlying05 = get(configs, 5).underlying;
462         underlying06 = get(configs, 6).underlying;
463         underlying07 = get(configs, 7).underlying;
464         underlying08 = get(configs, 8).underlying;
465         underlying09 = get(configs, 9).underlying;
466         underlying10 = get(configs, 10).underlying;
467         underlying11 = get(configs, 11).underlying;
468         underlying12 = get(configs, 12).underlying;
469         underlying13 = get(configs, 13).underlying;
470         underlying14 = get(configs, 14).underlying;
471         underlying15 = get(configs, 15).underlying;
472         underlying16 = get(configs, 16).underlying;
473         underlying17 = get(configs, 17).underlying;
474         underlying18 = get(configs, 18).underlying;
475         underlying19 = get(configs, 19).underlying;
476         underlying20 = get(configs, 20).underlying;
477         underlying21 = get(configs, 21).underlying;
478         underlying22 = get(configs, 22).underlying;
479         underlying23 = get(configs, 23).underlying;
480         underlying24 = get(configs, 24).underlying;
481         underlying25 = get(configs, 25).underlying;
482         underlying26 = get(configs, 26).underlying;
483         underlying27 = get(configs, 27).underlying;
484         underlying28 = get(configs, 28).underlying;
485         underlying29 = get(configs, 29).underlying;
486 
487         symbolHash00 = get(configs, 0).symbolHash;
488         symbolHash01 = get(configs, 1).symbolHash;
489         symbolHash02 = get(configs, 2).symbolHash;
490         symbolHash03 = get(configs, 3).symbolHash;
491         symbolHash04 = get(configs, 4).symbolHash;
492         symbolHash05 = get(configs, 5).symbolHash;
493         symbolHash06 = get(configs, 6).symbolHash;
494         symbolHash07 = get(configs, 7).symbolHash;
495         symbolHash08 = get(configs, 8).symbolHash;
496         symbolHash09 = get(configs, 9).symbolHash;
497         symbolHash10 = get(configs, 10).symbolHash;
498         symbolHash11 = get(configs, 11).symbolHash;
499         symbolHash12 = get(configs, 12).symbolHash;
500         symbolHash13 = get(configs, 13).symbolHash;
501         symbolHash14 = get(configs, 14).symbolHash;
502         symbolHash15 = get(configs, 15).symbolHash;
503         symbolHash16 = get(configs, 16).symbolHash;
504         symbolHash17 = get(configs, 17).symbolHash;
505         symbolHash18 = get(configs, 18).symbolHash;
506         symbolHash19 = get(configs, 19).symbolHash;
507         symbolHash20 = get(configs, 20).symbolHash;
508         symbolHash21 = get(configs, 21).symbolHash;
509         symbolHash22 = get(configs, 22).symbolHash;
510         symbolHash23 = get(configs, 23).symbolHash;
511         symbolHash24 = get(configs, 24).symbolHash;
512         symbolHash25 = get(configs, 25).symbolHash;
513         symbolHash26 = get(configs, 26).symbolHash;
514         symbolHash27 = get(configs, 27).symbolHash;
515         symbolHash28 = get(configs, 28).symbolHash;
516         symbolHash29 = get(configs, 29).symbolHash;
517 
518         baseUnit00 = get(configs, 0).baseUnit;
519         baseUnit01 = get(configs, 1).baseUnit;
520         baseUnit02 = get(configs, 2).baseUnit;
521         baseUnit03 = get(configs, 3).baseUnit;
522         baseUnit04 = get(configs, 4).baseUnit;
523         baseUnit05 = get(configs, 5).baseUnit;
524         baseUnit06 = get(configs, 6).baseUnit;
525         baseUnit07 = get(configs, 7).baseUnit;
526         baseUnit08 = get(configs, 8).baseUnit;
527         baseUnit09 = get(configs, 9).baseUnit;
528         baseUnit10 = get(configs, 10).baseUnit;
529         baseUnit11 = get(configs, 11).baseUnit;
530         baseUnit12 = get(configs, 12).baseUnit;
531         baseUnit13 = get(configs, 13).baseUnit;
532         baseUnit14 = get(configs, 14).baseUnit;
533         baseUnit15 = get(configs, 15).baseUnit;
534         baseUnit16 = get(configs, 16).baseUnit;
535         baseUnit17 = get(configs, 17).baseUnit;
536         baseUnit18 = get(configs, 18).baseUnit;
537         baseUnit19 = get(configs, 19).baseUnit;
538         baseUnit20 = get(configs, 20).baseUnit;
539         baseUnit21 = get(configs, 21).baseUnit;
540         baseUnit22 = get(configs, 22).baseUnit;
541         baseUnit23 = get(configs, 23).baseUnit;
542         baseUnit24 = get(configs, 24).baseUnit;
543         baseUnit25 = get(configs, 25).baseUnit;
544         baseUnit26 = get(configs, 26).baseUnit;
545         baseUnit27 = get(configs, 27).baseUnit;
546         baseUnit28 = get(configs, 28).baseUnit;
547         baseUnit29 = get(configs, 29).baseUnit;
548 
549         priceSource00 = get(configs, 0).priceSource;
550         priceSource01 = get(configs, 1).priceSource;
551         priceSource02 = get(configs, 2).priceSource;
552         priceSource03 = get(configs, 3).priceSource;
553         priceSource04 = get(configs, 4).priceSource;
554         priceSource05 = get(configs, 5).priceSource;
555         priceSource06 = get(configs, 6).priceSource;
556         priceSource07 = get(configs, 7).priceSource;
557         priceSource08 = get(configs, 8).priceSource;
558         priceSource09 = get(configs, 9).priceSource;
559         priceSource10 = get(configs, 10).priceSource;
560         priceSource11 = get(configs, 11).priceSource;
561         priceSource12 = get(configs, 12).priceSource;
562         priceSource13 = get(configs, 13).priceSource;
563         priceSource14 = get(configs, 14).priceSource;
564         priceSource15 = get(configs, 15).priceSource;
565         priceSource16 = get(configs, 16).priceSource;
566         priceSource17 = get(configs, 17).priceSource;
567         priceSource18 = get(configs, 18).priceSource;
568         priceSource19 = get(configs, 19).priceSource;
569         priceSource20 = get(configs, 20).priceSource;
570         priceSource21 = get(configs, 21).priceSource;
571         priceSource22 = get(configs, 22).priceSource;
572         priceSource23 = get(configs, 23).priceSource;
573         priceSource24 = get(configs, 24).priceSource;
574         priceSource25 = get(configs, 25).priceSource;
575         priceSource26 = get(configs, 26).priceSource;
576         priceSource27 = get(configs, 27).priceSource;
577         priceSource28 = get(configs, 28).priceSource;
578         priceSource29 = get(configs, 29).priceSource;
579 
580         fixedPrice00 = get(configs, 0).fixedPrice;
581         fixedPrice01 = get(configs, 1).fixedPrice;
582         fixedPrice02 = get(configs, 2).fixedPrice;
583         fixedPrice03 = get(configs, 3).fixedPrice;
584         fixedPrice04 = get(configs, 4).fixedPrice;
585         fixedPrice05 = get(configs, 5).fixedPrice;
586         fixedPrice06 = get(configs, 6).fixedPrice;
587         fixedPrice07 = get(configs, 7).fixedPrice;
588         fixedPrice08 = get(configs, 8).fixedPrice;
589         fixedPrice09 = get(configs, 9).fixedPrice;
590         fixedPrice10 = get(configs, 10).fixedPrice;
591         fixedPrice11 = get(configs, 11).fixedPrice;
592         fixedPrice12 = get(configs, 12).fixedPrice;
593         fixedPrice13 = get(configs, 13).fixedPrice;
594         fixedPrice14 = get(configs, 14).fixedPrice;
595         fixedPrice15 = get(configs, 15).fixedPrice;
596         fixedPrice16 = get(configs, 16).fixedPrice;
597         fixedPrice17 = get(configs, 17).fixedPrice;
598         fixedPrice18 = get(configs, 18).fixedPrice;
599         fixedPrice19 = get(configs, 19).fixedPrice;
600         fixedPrice20 = get(configs, 20).fixedPrice;
601         fixedPrice21 = get(configs, 21).fixedPrice;
602         fixedPrice22 = get(configs, 22).fixedPrice;
603         fixedPrice23 = get(configs, 23).fixedPrice;
604         fixedPrice24 = get(configs, 24).fixedPrice;
605         fixedPrice25 = get(configs, 25).fixedPrice;
606         fixedPrice26 = get(configs, 26).fixedPrice;
607         fixedPrice27 = get(configs, 27).fixedPrice;
608         fixedPrice28 = get(configs, 28).fixedPrice;
609         fixedPrice29 = get(configs, 29).fixedPrice;
610 
611         uniswapMarket00 = get(configs, 0).uniswapMarket;
612         uniswapMarket01 = get(configs, 1).uniswapMarket;
613         uniswapMarket02 = get(configs, 2).uniswapMarket;
614         uniswapMarket03 = get(configs, 3).uniswapMarket;
615         uniswapMarket04 = get(configs, 4).uniswapMarket;
616         uniswapMarket05 = get(configs, 5).uniswapMarket;
617         uniswapMarket06 = get(configs, 6).uniswapMarket;
618         uniswapMarket07 = get(configs, 7).uniswapMarket;
619         uniswapMarket08 = get(configs, 8).uniswapMarket;
620         uniswapMarket09 = get(configs, 9).uniswapMarket;
621         uniswapMarket10 = get(configs, 10).uniswapMarket;
622         uniswapMarket11 = get(configs, 11).uniswapMarket;
623         uniswapMarket12 = get(configs, 12).uniswapMarket;
624         uniswapMarket13 = get(configs, 13).uniswapMarket;
625         uniswapMarket14 = get(configs, 14).uniswapMarket;
626         uniswapMarket15 = get(configs, 15).uniswapMarket;
627         uniswapMarket16 = get(configs, 16).uniswapMarket;
628         uniswapMarket17 = get(configs, 17).uniswapMarket;
629         uniswapMarket18 = get(configs, 18).uniswapMarket;
630         uniswapMarket19 = get(configs, 19).uniswapMarket;
631         uniswapMarket20 = get(configs, 20).uniswapMarket;
632         uniswapMarket21 = get(configs, 21).uniswapMarket;
633         uniswapMarket22 = get(configs, 22).uniswapMarket;
634         uniswapMarket23 = get(configs, 23).uniswapMarket;
635         uniswapMarket24 = get(configs, 24).uniswapMarket;
636         uniswapMarket25 = get(configs, 25).uniswapMarket;
637         uniswapMarket26 = get(configs, 26).uniswapMarket;
638         uniswapMarket27 = get(configs, 27).uniswapMarket;
639         uniswapMarket28 = get(configs, 28).uniswapMarket;
640         uniswapMarket29 = get(configs, 29).uniswapMarket;
641 
642         isUniswapReversed00 = get(configs, 0).isUniswapReversed;
643         isUniswapReversed01 = get(configs, 1).isUniswapReversed;
644         isUniswapReversed02 = get(configs, 2).isUniswapReversed;
645         isUniswapReversed03 = get(configs, 3).isUniswapReversed;
646         isUniswapReversed04 = get(configs, 4).isUniswapReversed;
647         isUniswapReversed05 = get(configs, 5).isUniswapReversed;
648         isUniswapReversed06 = get(configs, 6).isUniswapReversed;
649         isUniswapReversed07 = get(configs, 7).isUniswapReversed;
650         isUniswapReversed08 = get(configs, 8).isUniswapReversed;
651         isUniswapReversed09 = get(configs, 9).isUniswapReversed;
652         isUniswapReversed10 = get(configs, 10).isUniswapReversed;
653         isUniswapReversed11 = get(configs, 11).isUniswapReversed;
654         isUniswapReversed12 = get(configs, 12).isUniswapReversed;
655         isUniswapReversed13 = get(configs, 13).isUniswapReversed;
656         isUniswapReversed14 = get(configs, 14).isUniswapReversed;
657         isUniswapReversed15 = get(configs, 15).isUniswapReversed;
658         isUniswapReversed16 = get(configs, 16).isUniswapReversed;
659         isUniswapReversed17 = get(configs, 17).isUniswapReversed;
660         isUniswapReversed18 = get(configs, 18).isUniswapReversed;
661         isUniswapReversed19 = get(configs, 19).isUniswapReversed;
662         isUniswapReversed20 = get(configs, 20).isUniswapReversed;
663         isUniswapReversed21 = get(configs, 21).isUniswapReversed;
664         isUniswapReversed22 = get(configs, 22).isUniswapReversed;
665         isUniswapReversed23 = get(configs, 23).isUniswapReversed;
666         isUniswapReversed24 = get(configs, 24).isUniswapReversed;
667         isUniswapReversed25 = get(configs, 25).isUniswapReversed;
668         isUniswapReversed26 = get(configs, 26).isUniswapReversed;
669         isUniswapReversed27 = get(configs, 27).isUniswapReversed;
670         isUniswapReversed28 = get(configs, 28).isUniswapReversed;
671         isUniswapReversed29 = get(configs, 29).isUniswapReversed;
672     }
673 
674     function get(TokenConfig[] memory configs, uint i) internal pure returns (TokenConfig memory) {
675         if (i < configs.length)
676             return configs[i];
677         return TokenConfig({
678             cToken: address(0),
679             underlying: address(0),
680             symbolHash: bytes32(0),
681             baseUnit: uint256(0),
682             priceSource: PriceSource(0),
683             fixedPrice: uint256(0),
684             uniswapMarket: address(0),
685             isUniswapReversed: false
686         });
687     }
688 
689     function getCTokenIndex(address cToken) internal view returns (uint) {
690         if (cToken == cToken00) return 0;
691         if (cToken == cToken01) return 1;
692         if (cToken == cToken02) return 2;
693         if (cToken == cToken03) return 3;
694         if (cToken == cToken04) return 4;
695         if (cToken == cToken05) return 5;
696         if (cToken == cToken06) return 6;
697         if (cToken == cToken07) return 7;
698         if (cToken == cToken08) return 8;
699         if (cToken == cToken09) return 9;
700         if (cToken == cToken10) return 10;
701         if (cToken == cToken11) return 11;
702         if (cToken == cToken12) return 12;
703         if (cToken == cToken13) return 13;
704         if (cToken == cToken14) return 14;
705         if (cToken == cToken15) return 15;
706         if (cToken == cToken16) return 16;
707         if (cToken == cToken17) return 17;
708         if (cToken == cToken18) return 18;
709         if (cToken == cToken19) return 19;
710         if (cToken == cToken20) return 20;
711         if (cToken == cToken21) return 21;
712         if (cToken == cToken22) return 22;
713         if (cToken == cToken23) return 23;
714         if (cToken == cToken24) return 24;
715         if (cToken == cToken25) return 25;
716         if (cToken == cToken26) return 26;
717         if (cToken == cToken27) return 27;
718         if (cToken == cToken28) return 28;
719         if (cToken == cToken29) return 29;
720 
721         return uint(-1);
722     }
723 
724     function getUnderlyingIndex(address underlying) internal view returns (uint) {
725         if (underlying == underlying00) return 0;
726         if (underlying == underlying01) return 1;
727         if (underlying == underlying02) return 2;
728         if (underlying == underlying03) return 3;
729         if (underlying == underlying04) return 4;
730         if (underlying == underlying05) return 5;
731         if (underlying == underlying06) return 6;
732         if (underlying == underlying07) return 7;
733         if (underlying == underlying08) return 8;
734         if (underlying == underlying09) return 9;
735         if (underlying == underlying10) return 10;
736         if (underlying == underlying11) return 11;
737         if (underlying == underlying12) return 12;
738         if (underlying == underlying13) return 13;
739         if (underlying == underlying14) return 14;
740         if (underlying == underlying15) return 15;
741         if (underlying == underlying16) return 16;
742         if (underlying == underlying17) return 17;
743         if (underlying == underlying18) return 18;
744         if (underlying == underlying19) return 19;
745         if (underlying == underlying20) return 20;
746         if (underlying == underlying21) return 21;
747         if (underlying == underlying22) return 22;
748         if (underlying == underlying23) return 23;
749         if (underlying == underlying24) return 24;
750         if (underlying == underlying25) return 25;
751         if (underlying == underlying26) return 26;
752         if (underlying == underlying27) return 27;
753         if (underlying == underlying28) return 28;
754         if (underlying == underlying29) return 29;
755 
756         return uint(-1);
757     }
758 
759     function getSymbolHashIndex(bytes32 symbolHash) internal view returns (uint) {
760         if (symbolHash == symbolHash00) return 0;
761         if (symbolHash == symbolHash01) return 1;
762         if (symbolHash == symbolHash02) return 2;
763         if (symbolHash == symbolHash03) return 3;
764         if (symbolHash == symbolHash04) return 4;
765         if (symbolHash == symbolHash05) return 5;
766         if (symbolHash == symbolHash06) return 6;
767         if (symbolHash == symbolHash07) return 7;
768         if (symbolHash == symbolHash08) return 8;
769         if (symbolHash == symbolHash09) return 9;
770         if (symbolHash == symbolHash10) return 10;
771         if (symbolHash == symbolHash11) return 11;
772         if (symbolHash == symbolHash12) return 12;
773         if (symbolHash == symbolHash13) return 13;
774         if (symbolHash == symbolHash14) return 14;
775         if (symbolHash == symbolHash15) return 15;
776         if (symbolHash == symbolHash16) return 16;
777         if (symbolHash == symbolHash17) return 17;
778         if (symbolHash == symbolHash18) return 18;
779         if (symbolHash == symbolHash19) return 19;
780         if (symbolHash == symbolHash20) return 20;
781         if (symbolHash == symbolHash21) return 21;
782         if (symbolHash == symbolHash22) return 22;
783         if (symbolHash == symbolHash23) return 23;
784         if (symbolHash == symbolHash24) return 24;
785         if (symbolHash == symbolHash25) return 25;
786         if (symbolHash == symbolHash26) return 26;
787         if (symbolHash == symbolHash27) return 27;
788         if (symbolHash == symbolHash28) return 28;
789         if (symbolHash == symbolHash29) return 29;
790 
791         return uint(-1);
792     }
793 
794     /**
795      * @notice Get the i-th config, according to the order they were passed in originally
796      * @param i The index of the config to get
797      * @return The config object
798      */
799     function getTokenConfig(uint i) public view returns (TokenConfig memory) {
800         require(i < numTokens, "token config not found");
801 
802         if (i == 0) return TokenConfig({cToken: cToken00, underlying: underlying00, symbolHash: symbolHash00, baseUnit: baseUnit00, priceSource: priceSource00, fixedPrice: fixedPrice00, uniswapMarket: uniswapMarket00, isUniswapReversed: isUniswapReversed00});
803         if (i == 1) return TokenConfig({cToken: cToken01, underlying: underlying01, symbolHash: symbolHash01, baseUnit: baseUnit01, priceSource: priceSource01, fixedPrice: fixedPrice01, uniswapMarket: uniswapMarket01, isUniswapReversed: isUniswapReversed01});
804         if (i == 2) return TokenConfig({cToken: cToken02, underlying: underlying02, symbolHash: symbolHash02, baseUnit: baseUnit02, priceSource: priceSource02, fixedPrice: fixedPrice02, uniswapMarket: uniswapMarket02, isUniswapReversed: isUniswapReversed02});
805         if (i == 3) return TokenConfig({cToken: cToken03, underlying: underlying03, symbolHash: symbolHash03, baseUnit: baseUnit03, priceSource: priceSource03, fixedPrice: fixedPrice03, uniswapMarket: uniswapMarket03, isUniswapReversed: isUniswapReversed03});
806         if (i == 4) return TokenConfig({cToken: cToken04, underlying: underlying04, symbolHash: symbolHash04, baseUnit: baseUnit04, priceSource: priceSource04, fixedPrice: fixedPrice04, uniswapMarket: uniswapMarket04, isUniswapReversed: isUniswapReversed04});
807         if (i == 5) return TokenConfig({cToken: cToken05, underlying: underlying05, symbolHash: symbolHash05, baseUnit: baseUnit05, priceSource: priceSource05, fixedPrice: fixedPrice05, uniswapMarket: uniswapMarket05, isUniswapReversed: isUniswapReversed05});
808         if (i == 6) return TokenConfig({cToken: cToken06, underlying: underlying06, symbolHash: symbolHash06, baseUnit: baseUnit06, priceSource: priceSource06, fixedPrice: fixedPrice06, uniswapMarket: uniswapMarket06, isUniswapReversed: isUniswapReversed06});
809         if (i == 7) return TokenConfig({cToken: cToken07, underlying: underlying07, symbolHash: symbolHash07, baseUnit: baseUnit07, priceSource: priceSource07, fixedPrice: fixedPrice07, uniswapMarket: uniswapMarket07, isUniswapReversed: isUniswapReversed07});
810         if (i == 8) return TokenConfig({cToken: cToken08, underlying: underlying08, symbolHash: symbolHash08, baseUnit: baseUnit08, priceSource: priceSource08, fixedPrice: fixedPrice08, uniswapMarket: uniswapMarket08, isUniswapReversed: isUniswapReversed08});
811         if (i == 9) return TokenConfig({cToken: cToken09, underlying: underlying09, symbolHash: symbolHash09, baseUnit: baseUnit09, priceSource: priceSource09, fixedPrice: fixedPrice09, uniswapMarket: uniswapMarket09, isUniswapReversed: isUniswapReversed09});
812 
813         if (i == 10) return TokenConfig({cToken: cToken10, underlying: underlying10, symbolHash: symbolHash10, baseUnit: baseUnit10, priceSource: priceSource10, fixedPrice: fixedPrice10, uniswapMarket: uniswapMarket10, isUniswapReversed: isUniswapReversed10});
814         if (i == 11) return TokenConfig({cToken: cToken11, underlying: underlying11, symbolHash: symbolHash11, baseUnit: baseUnit11, priceSource: priceSource11, fixedPrice: fixedPrice11, uniswapMarket: uniswapMarket11, isUniswapReversed: isUniswapReversed11});
815         if (i == 12) return TokenConfig({cToken: cToken12, underlying: underlying12, symbolHash: symbolHash12, baseUnit: baseUnit12, priceSource: priceSource12, fixedPrice: fixedPrice12, uniswapMarket: uniswapMarket12, isUniswapReversed: isUniswapReversed12});
816         if (i == 13) return TokenConfig({cToken: cToken13, underlying: underlying13, symbolHash: symbolHash13, baseUnit: baseUnit13, priceSource: priceSource13, fixedPrice: fixedPrice13, uniswapMarket: uniswapMarket13, isUniswapReversed: isUniswapReversed13});
817         if (i == 14) return TokenConfig({cToken: cToken14, underlying: underlying14, symbolHash: symbolHash14, baseUnit: baseUnit14, priceSource: priceSource14, fixedPrice: fixedPrice14, uniswapMarket: uniswapMarket14, isUniswapReversed: isUniswapReversed14});
818         if (i == 15) return TokenConfig({cToken: cToken15, underlying: underlying15, symbolHash: symbolHash15, baseUnit: baseUnit15, priceSource: priceSource15, fixedPrice: fixedPrice15, uniswapMarket: uniswapMarket15, isUniswapReversed: isUniswapReversed15});
819         if (i == 16) return TokenConfig({cToken: cToken16, underlying: underlying16, symbolHash: symbolHash16, baseUnit: baseUnit16, priceSource: priceSource16, fixedPrice: fixedPrice16, uniswapMarket: uniswapMarket16, isUniswapReversed: isUniswapReversed16});
820         if (i == 17) return TokenConfig({cToken: cToken17, underlying: underlying17, symbolHash: symbolHash17, baseUnit: baseUnit17, priceSource: priceSource17, fixedPrice: fixedPrice17, uniswapMarket: uniswapMarket17, isUniswapReversed: isUniswapReversed17});
821         if (i == 18) return TokenConfig({cToken: cToken18, underlying: underlying18, symbolHash: symbolHash18, baseUnit: baseUnit18, priceSource: priceSource18, fixedPrice: fixedPrice18, uniswapMarket: uniswapMarket18, isUniswapReversed: isUniswapReversed18});
822         if (i == 19) return TokenConfig({cToken: cToken19, underlying: underlying19, symbolHash: symbolHash19, baseUnit: baseUnit19, priceSource: priceSource19, fixedPrice: fixedPrice19, uniswapMarket: uniswapMarket19, isUniswapReversed: isUniswapReversed19});
823 
824         if (i == 20) return TokenConfig({cToken: cToken20, underlying: underlying20, symbolHash: symbolHash20, baseUnit: baseUnit20, priceSource: priceSource20, fixedPrice: fixedPrice20, uniswapMarket: uniswapMarket20, isUniswapReversed: isUniswapReversed20});
825         if (i == 21) return TokenConfig({cToken: cToken21, underlying: underlying21, symbolHash: symbolHash21, baseUnit: baseUnit21, priceSource: priceSource21, fixedPrice: fixedPrice21, uniswapMarket: uniswapMarket21, isUniswapReversed: isUniswapReversed21});
826         if (i == 22) return TokenConfig({cToken: cToken22, underlying: underlying22, symbolHash: symbolHash22, baseUnit: baseUnit22, priceSource: priceSource22, fixedPrice: fixedPrice22, uniswapMarket: uniswapMarket22, isUniswapReversed: isUniswapReversed22});
827         if (i == 23) return TokenConfig({cToken: cToken23, underlying: underlying23, symbolHash: symbolHash23, baseUnit: baseUnit23, priceSource: priceSource23, fixedPrice: fixedPrice23, uniswapMarket: uniswapMarket23, isUniswapReversed: isUniswapReversed23});
828         if (i == 24) return TokenConfig({cToken: cToken24, underlying: underlying24, symbolHash: symbolHash24, baseUnit: baseUnit24, priceSource: priceSource24, fixedPrice: fixedPrice24, uniswapMarket: uniswapMarket24, isUniswapReversed: isUniswapReversed24});
829         if (i == 25) return TokenConfig({cToken: cToken25, underlying: underlying25, symbolHash: symbolHash25, baseUnit: baseUnit25, priceSource: priceSource25, fixedPrice: fixedPrice25, uniswapMarket: uniswapMarket25, isUniswapReversed: isUniswapReversed25});
830         if (i == 26) return TokenConfig({cToken: cToken26, underlying: underlying26, symbolHash: symbolHash26, baseUnit: baseUnit26, priceSource: priceSource26, fixedPrice: fixedPrice26, uniswapMarket: uniswapMarket26, isUniswapReversed: isUniswapReversed26});
831         if (i == 27) return TokenConfig({cToken: cToken27, underlying: underlying27, symbolHash: symbolHash27, baseUnit: baseUnit27, priceSource: priceSource27, fixedPrice: fixedPrice27, uniswapMarket: uniswapMarket27, isUniswapReversed: isUniswapReversed27});
832         if (i == 28) return TokenConfig({cToken: cToken28, underlying: underlying28, symbolHash: symbolHash28, baseUnit: baseUnit28, priceSource: priceSource28, fixedPrice: fixedPrice28, uniswapMarket: uniswapMarket28, isUniswapReversed: isUniswapReversed28});
833         if (i == 29) return TokenConfig({cToken: cToken29, underlying: underlying29, symbolHash: symbolHash29, baseUnit: baseUnit29, priceSource: priceSource29, fixedPrice: fixedPrice29, uniswapMarket: uniswapMarket29, isUniswapReversed: isUniswapReversed29});
834     }
835 
836     /**
837      * @notice Get the config for symbol
838      * @param symbol The symbol of the config to get
839      * @return The config object
840      */
841     function getTokenConfigBySymbol(string memory symbol) public view returns (TokenConfig memory) {
842         return getTokenConfigBySymbolHash(keccak256(abi.encodePacked(symbol)));
843     }
844 
845     /**
846      * @notice Get the config for the symbolHash
847      * @param symbolHash The keccack256 of the symbol of the config to get
848      * @return The config object
849      */
850     function getTokenConfigBySymbolHash(bytes32 symbolHash) public view returns (TokenConfig memory) {
851         uint index = getSymbolHashIndex(symbolHash);
852         if (index != uint(-1)) {
853             return getTokenConfig(index);
854         }
855 
856         revert("token config not found");
857     }
858 
859     /**
860      * @notice Get the config for the cToken
861      * @dev If a config for the cToken is not found, falls back to searching for the underlying.
862      * @param cToken The address of the cToken of the config to get
863      * @return The config object
864      */
865     function getTokenConfigByCToken(address cToken) public view returns (TokenConfig memory) {
866         uint index = getCTokenIndex(cToken);
867         if (index != uint(-1)) {
868             return getTokenConfig(index);
869         }
870 
871         return getTokenConfigByUnderlying(CErc20(cToken).underlying());
872     }
873 
874     /**
875      * @notice Get the config for an underlying asset
876      * @param underlying The address of the underlying asset of the config to get
877      * @return The config object
878      */
879     function getTokenConfigByUnderlying(address underlying) public view returns (TokenConfig memory) {
880         uint index = getUnderlyingIndex(underlying);
881         if (index != uint(-1)) {
882             return getTokenConfig(index);
883         }
884 
885         revert("token config not found");
886     }
887 }
888 
889 
890 
891 
892 // Based on code from https://github.com/Uniswap/uniswap-v2-periphery
893 
894 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
895 library FixedPoint {
896     // range: [0, 2**112 - 1]
897     // resolution: 1 / 2**112
898     struct uq112x112 {
899         uint224 _x;
900     }
901 
902     // returns a uq112x112 which represents the ratio of the numerator to the denominator
903     // equivalent to encode(numerator).div(denominator)
904     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
905         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
906         return uq112x112((uint224(numerator) << 112) / denominator);
907     }
908 
909     // decode a uq112x112 into a uint with 18 decimals of precision
910     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
911         // we only have 256 - 224 = 32 bits to spare, so scaling up by ~60 bits is dangerous
912         // instead, get close to:
913         //  (x * 1e18) >> 112
914         // without risk of overflowing, e.g.:
915         //  (x) / 2 ** (112 - lg(1e18))
916         return uint(self._x) / 5192296858534827;
917     }
918 }
919 
920 // library with helper methods for oracles that are concerned with computing average prices
921 library UniswapV2OracleLibrary {
922     using FixedPoint for *;
923 
924     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
925     function currentBlockTimestamp() internal view returns (uint32) {
926         return uint32(block.timestamp % 2 ** 32);
927     }
928 
929     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
930     function currentCumulativePrices(
931         address pair
932     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
933         blockTimestamp = currentBlockTimestamp();
934         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
935         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
936 
937         // if time has elapsed since the last update on the pair, mock the accumulated price values
938         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
939         if (blockTimestampLast != blockTimestamp) {
940             // subtraction overflow is desired
941             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
942             // addition overflow is desired
943             // counterfactual
944             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
945             // counterfactual
946             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
947         }
948     }
949 }
950 
951 interface IUniswapV2Pair {
952     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
953     function price0CumulativeLast() external view returns (uint);
954     function price1CumulativeLast() external view returns (uint);
955 }
956 
957 
958 struct Observation {
959     uint timestamp;
960     uint acc;
961 }
962 
963 contract UniswapAnchoredView is UniswapConfig {
964     using FixedPoint for *;
965 
966     /// @notice The Open Oracle Price Data contract
967     OpenOraclePriceData public immutable priceData;
968 
969     /// @notice The number of wei in 1 ETH
970     uint public constant ethBaseUnit = 1e18;
971 
972     /// @notice A common scaling factor to maintain precision
973     uint public constant expScale = 1e18;
974 
975     /// @notice The Open Oracle Reporter
976     address public immutable reporter;
977 
978     /// @notice The highest ratio of the new price to the anchor price that will still trigger the price to be updated
979     uint public immutable upperBoundAnchorRatio;
980 
981     /// @notice The lowest ratio of the new price to the anchor price that will still trigger the price to be updated
982     uint public immutable lowerBoundAnchorRatio;
983 
984     /// @notice The minimum amount of time in seconds required for the old uniswap price accumulator to be replaced
985     uint public immutable anchorPeriod;
986 
987     /// @notice Official prices by symbol hash
988     mapping(bytes32 => uint) public prices;
989 
990     /// @notice Circuit breaker for using anchor price oracle directly, ignoring reporter
991     bool public reporterInvalidated;
992 
993     /// @notice The old observation for each symbolHash
994     mapping(bytes32 => Observation) public oldObservations;
995 
996     /// @notice The new observation for each symbolHash
997     mapping(bytes32 => Observation) public newObservations;
998 
999     /// @notice The event emitted when new prices are posted but the stored price is not updated due to the anchor
1000     event PriceGuarded(string symbol, uint reporter, uint anchor);
1001 
1002     /// @notice The event emitted when the stored price is updated
1003     event PriceUpdated(string symbol, uint price);
1004 
1005     /// @notice The event emitted when anchor price is updated
1006     event AnchorPriceUpdated(string symbol, uint anchorPrice, uint oldTimestamp, uint newTimestamp);
1007 
1008     /// @notice The event emitted when the uniswap window changes
1009     event UniswapWindowUpdated(bytes32 indexed symbolHash, uint oldTimestamp, uint newTimestamp, uint oldPrice, uint newPrice);
1010 
1011     /// @notice The event emitted when reporter invalidates itself
1012     event ReporterInvalidated(address reporter);
1013 
1014     bytes32 constant ethHash = keccak256(abi.encodePacked("ETH"));
1015     bytes32 constant rotateHash = keccak256(abi.encodePacked("rotate"));
1016 
1017     /**
1018      * @notice Construct a uniswap anchored view for a set of token configurations
1019      * @dev Note that to avoid immature TWAPs, the system must run for at least a single anchorPeriod before using.
1020      * @param reporter_ The reporter whose prices are to be used
1021      * @param anchorToleranceMantissa_ The percentage tolerance that the reporter may deviate from the uniswap anchor
1022      * @param anchorPeriod_ The minimum amount of time required for the old uniswap price accumulator to be replaced
1023      * @param configs The static token configurations which define what prices are supported and how
1024      */
1025     constructor(OpenOraclePriceData priceData_,
1026                 address reporter_,
1027                 uint anchorToleranceMantissa_,
1028                 uint anchorPeriod_,
1029                 TokenConfig[] memory configs) UniswapConfig(configs) public {
1030         priceData = priceData_;
1031         reporter = reporter_;
1032         anchorPeriod = anchorPeriod_;
1033 
1034         // Allow the tolerance to be whatever the deployer chooses, but prevent under/overflow (and prices from being 0)
1035         upperBoundAnchorRatio = anchorToleranceMantissa_ > uint(-1) - 100e16 ? uint(-1) : 100e16 + anchorToleranceMantissa_;
1036         lowerBoundAnchorRatio = anchorToleranceMantissa_ < 100e16 ? 100e16 - anchorToleranceMantissa_ : 1;
1037 
1038         for (uint i = 0; i < configs.length; i++) {
1039             TokenConfig memory config = configs[i];
1040             require(config.baseUnit > 0, "baseUnit must be greater than zero");
1041             address uniswapMarket = config.uniswapMarket;
1042             if (config.priceSource == PriceSource.REPORTER) {
1043                 require(uniswapMarket != address(0), "reported prices must have an anchor");
1044                 bytes32 symbolHash = config.symbolHash;
1045                 uint cumulativePrice = currentCumulativePrice(config);
1046                 oldObservations[symbolHash].timestamp = block.timestamp;
1047                 newObservations[symbolHash].timestamp = block.timestamp;
1048                 oldObservations[symbolHash].acc = cumulativePrice;
1049                 newObservations[symbolHash].acc = cumulativePrice;
1050                 emit UniswapWindowUpdated(symbolHash, block.timestamp, block.timestamp, cumulativePrice, cumulativePrice);
1051             } else {
1052                 require(uniswapMarket == address(0), "only reported prices utilize an anchor");
1053             }
1054         }
1055     }
1056 
1057     /**
1058      * @notice Get the official price for a symbol
1059      * @param symbol The symbol to fetch the price of
1060      * @return Price denominated in USD, with 6 decimals
1061      */
1062     function price(string memory symbol) external view returns (uint) {
1063         TokenConfig memory config = getTokenConfigBySymbol(symbol);
1064         return priceInternal(config);
1065     }
1066 
1067     function priceInternal(TokenConfig memory config) internal view returns (uint) {
1068         if (config.priceSource == PriceSource.REPORTER) return prices[config.symbolHash];
1069         if (config.priceSource == PriceSource.FIXED_USD) return config.fixedPrice;
1070         if (config.priceSource == PriceSource.FIXED_ETH) {
1071             uint usdPerEth = prices[ethHash];
1072             require(usdPerEth > 0, "ETH price not set, cannot convert to dollars");
1073             return mul(usdPerEth, config.fixedPrice) / ethBaseUnit;
1074         }
1075     }
1076 
1077     /**
1078      * @notice Get the underlying price of a cToken
1079      * @dev Implements the PriceOracle interface for Compound v2.
1080      * @param cToken The cToken address for price retrieval
1081      * @return Price denominated in USD, with 18 decimals, for the given cToken address
1082      */
1083     function getUnderlyingPrice(address cToken) external view returns (uint) {
1084         TokenConfig memory config = getTokenConfigByCToken(cToken);
1085          // Comptroller needs prices in the format: ${raw price} * 1e(36 - baseUnit)
1086          // Since the prices in this view have 6 decimals, we must scale them by 1e(36 - 6 - baseUnit)
1087         return mul(1e30, priceInternal(config)) / config.baseUnit;
1088     }
1089 
1090     /**
1091      * @notice Post open oracle reporter prices, and recalculate stored price by comparing to anchor
1092      * @dev We let anyone pay to post anything, but only prices from configured reporter will be stored in the view.
1093      * @param messages The messages to post to the oracle
1094      * @param signatures The signatures for the corresponding messages
1095      * @param symbols The symbols to compare to anchor for authoritative reading
1096      */
1097     function postPrices(bytes[] calldata messages, bytes[] calldata signatures, string[] calldata symbols) external {
1098         require(messages.length == signatures.length, "messages and signatures must be 1:1");
1099 
1100         // Save the prices
1101         for (uint i = 0; i < messages.length; i++) {
1102             priceData.put(messages[i], signatures[i]);
1103         }
1104 
1105         uint ethPrice = fetchEthPrice();
1106 
1107         // Try to update the view storage
1108         for (uint i = 0; i < symbols.length; i++) {
1109             postPriceInternal(symbols[i], ethPrice);
1110         }
1111     }
1112 
1113     function postPriceInternal(string memory symbol, uint ethPrice) internal {
1114         TokenConfig memory config = getTokenConfigBySymbol(symbol);
1115         require(config.priceSource == PriceSource.REPORTER, "only reporter prices get posted");
1116 
1117         bytes32 symbolHash = keccak256(abi.encodePacked(symbol));
1118         uint reporterPrice = priceData.getPrice(reporter, symbol);
1119         uint anchorPrice;
1120         if (symbolHash == ethHash) {
1121             anchorPrice = ethPrice;
1122         } else {
1123             anchorPrice = fetchAnchorPrice(symbol, config, ethPrice);
1124         }
1125 
1126         if (reporterInvalidated) {
1127             prices[symbolHash] = anchorPrice;
1128             emit PriceUpdated(symbol, anchorPrice);
1129         } else if (isWithinAnchor(reporterPrice, anchorPrice)) {
1130             prices[symbolHash] = reporterPrice;
1131             emit PriceUpdated(symbol, reporterPrice);
1132         } else {
1133             emit PriceGuarded(symbol, reporterPrice, anchorPrice);
1134         }
1135     }
1136 
1137     function isWithinAnchor(uint reporterPrice, uint anchorPrice) internal view returns (bool) {
1138         if (reporterPrice > 0) {
1139             uint anchorRatio = mul(anchorPrice, 100e16) / reporterPrice;
1140             return anchorRatio <= upperBoundAnchorRatio && anchorRatio >= lowerBoundAnchorRatio;
1141         }
1142         return false;
1143     }
1144 
1145     /**
1146      * @dev Fetches the current token/eth price accumulator from uniswap.
1147      */
1148     function currentCumulativePrice(TokenConfig memory config) internal view returns (uint) {
1149         (uint cumulativePrice0, uint cumulativePrice1,) = UniswapV2OracleLibrary.currentCumulativePrices(config.uniswapMarket);
1150         if (config.isUniswapReversed) {
1151             return cumulativePrice1;
1152         } else {
1153             return cumulativePrice0;
1154         }
1155     }
1156 
1157     /**
1158      * @dev Fetches the current eth/usd price from uniswap, with 6 decimals of precision.
1159      *  Conversion factor is 1e18 for eth/usdc market, since we decode uniswap price statically with 18 decimals.
1160      */
1161     function fetchEthPrice() internal returns (uint) {
1162         return fetchAnchorPrice("ETH", getTokenConfigBySymbolHash(ethHash), ethBaseUnit);
1163     }
1164 
1165     /**
1166      * @dev Fetches the current token/usd price from uniswap, with 6 decimals of precision.
1167      * @param conversionFactor 1e18 if seeking the ETH price, and a 6 decimal ETH-USDC price in the case of other assets
1168      */
1169     function fetchAnchorPrice(string memory symbol, TokenConfig memory config, uint conversionFactor) internal virtual returns (uint) {
1170         (uint nowCumulativePrice, uint oldCumulativePrice, uint oldTimestamp) = pokeWindowValues(config);
1171 
1172         // This should be impossible, but better safe than sorry
1173         require(block.timestamp > oldTimestamp, "now must come after before");
1174         uint timeElapsed = block.timestamp - oldTimestamp;
1175 
1176         // Calculate uniswap time-weighted average price
1177         // Underflow is a property of the accumulators: https://uniswap.org/audit.html#orgc9b3190
1178         FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(uint224((nowCumulativePrice - oldCumulativePrice) / timeElapsed));
1179         uint rawUniswapPriceMantissa = priceAverage.decode112with18();
1180         uint unscaledPriceMantissa = mul(rawUniswapPriceMantissa, conversionFactor);
1181         uint anchorPrice;
1182 
1183         // Adjust rawUniswapPrice according to the units of the non-ETH asset
1184         // In the case of ETH, we would have to scale by 1e6 / USDC_UNITS, but since baseUnit2 is 1e6 (USDC), it cancels
1185         if (config.isUniswapReversed) {
1186             // unscaledPriceMantissa * ethBaseUnit / config.baseUnit / expScale, but we simplify bc ethBaseUnit == expScale
1187             anchorPrice = unscaledPriceMantissa / config.baseUnit;
1188         } else {
1189             anchorPrice = mul(unscaledPriceMantissa, config.baseUnit) / ethBaseUnit / expScale;
1190         }
1191 
1192         emit AnchorPriceUpdated(symbol, anchorPrice, oldTimestamp, block.timestamp);
1193 
1194         return anchorPrice;
1195     }
1196 
1197     /**
1198      * @dev Get time-weighted average prices for a token at the current timestamp.
1199      *  Update new and old observations of lagging window if period elapsed.
1200      */
1201     function pokeWindowValues(TokenConfig memory config) internal returns (uint, uint, uint) {
1202         bytes32 symbolHash = config.symbolHash;
1203         uint cumulativePrice = currentCumulativePrice(config);
1204 
1205         Observation memory newObservation = newObservations[symbolHash];
1206 
1207         // Update new and old observations if elapsed time is greater than or equal to anchor period
1208         uint timeElapsed = block.timestamp - newObservation.timestamp;
1209         if (timeElapsed >= anchorPeriod) {
1210             oldObservations[symbolHash].timestamp = newObservation.timestamp;
1211             oldObservations[symbolHash].acc = newObservation.acc;
1212 
1213             newObservations[symbolHash].timestamp = block.timestamp;
1214             newObservations[symbolHash].acc = cumulativePrice;
1215             emit UniswapWindowUpdated(config.symbolHash, newObservation.timestamp, block.timestamp, newObservation.acc, cumulativePrice);
1216         }
1217         return (cumulativePrice, oldObservations[symbolHash].acc, oldObservations[symbolHash].timestamp);
1218     }
1219 
1220     /**
1221      * @notice Invalidate the reporter, and fall back to using anchor directly in all cases
1222      * @dev Only the reporter may sign a message which allows it to invalidate itself.
1223      *  To be used in cases of emergency, if the reporter thinks their key may be compromised.
1224      * @param message The data that was presumably signed
1225      * @param signature The fingerprint of the data + private key
1226      */
1227     function invalidateReporter(bytes memory message, bytes memory signature) external {
1228         (string memory decodedMessage, ) = abi.decode(message, (string, address));
1229         require(keccak256(abi.encodePacked(decodedMessage)) == rotateHash, "invalid message must be 'rotate'");
1230         require(source(message, signature) == reporter, "invalidation message must come from the reporter");
1231         reporterInvalidated = true;
1232         emit ReporterInvalidated(reporter);
1233     }
1234 
1235     /**
1236      * @notice Recovers the source address which signed a message
1237      * @dev Comparing to a claimed address would add nothing,
1238      *  as the caller could simply perform the recover and claim that address.
1239      * @param message The data that was presumably signed
1240      * @param signature The fingerprint of the data + private key
1241      * @return The source address which signed the message, presumably
1242      */
1243     function source(bytes memory message, bytes memory signature) public pure returns (address) {
1244         (bytes32 r, bytes32 s, uint8 v) = abi.decode(signature, (bytes32, bytes32, uint8));
1245         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(message)));
1246         return ecrecover(hash, v, r, s);
1247     }
1248 
1249     /// @dev Overflow proof multiplication
1250     function mul(uint a, uint b) internal pure returns (uint) {
1251         if (a == 0) return 0;
1252         uint c = a * b;
1253         require(c / a == b, "multiplication overflow");
1254         return c;
1255     }
1256 }