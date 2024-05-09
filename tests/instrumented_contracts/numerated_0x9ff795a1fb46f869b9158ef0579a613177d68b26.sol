1 // File: contracts/OpenOracleData.sol
2 
3 // SPDX-License-Identifier: GPL-3.0
4 
5 pragma solidity ^0.6.10;
6 pragma experimental ABIEncoderV2;
7 
8 /**
9  * @title The Open Oracle Data Base Contract
10  * @author Compound Labs, Inc.
11  */
12 contract OpenOracleData {
13     /**
14      * @notice The event emitted when a source writes to its storage
15      */
16     //event Write(address indexed source, <Key> indexed key, string kind, uint64 timestamp, <Value> value);
17 
18     /**
19      * @notice Write a bunch of signed datum to the authenticated storage mapping
20      * @param message The payload containing the timestamp, and (key, value) pairs
21      * @param signature The cryptographic signature of the message payload, authorizing the source to write
22      * @return The keys that were written
23      */
24     //function put(bytes calldata message, bytes calldata signature) external returns (<Key> memory);
25 
26     /**
27      * @notice Read a single key with a pre-defined type signature from an authenticated source
28      * @param source The verifiable author of the data
29      * @param key The selector for the value to return
30      * @return The claimed Unix timestamp for the data and the encoded value (defaults to (0, 0x))
31      */
32     //function get(address source, <Key> key) external view returns (uint, <Value>);
33 
34     /**
35      * @notice Recovers the source address which signed a message
36      * @dev Comparing to a claimed address would add nothing,
37      *  as the caller could simply perform the recover and claim that address.
38      * @param message The data that was presumably signed
39      * @param signature The fingerprint of the data + private key
40      * @return The source address which signed the message, presumably
41      */
42     function source(bytes memory message, bytes memory signature) public pure returns (address) {
43         (bytes32 r, bytes32 s, uint8 v) = abi.decode(signature, (bytes32, bytes32, uint8));
44         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(message)));
45         return ecrecover(hash, v, r, s);
46     }
47 }
48 
49 // File: contracts/OpenOraclePriceData.sol
50 
51 
52 pragma solidity ^0.6.10;
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
133 // File: contracts/Uniswap/UniswapConfig.sol
134 
135 
136 pragma solidity ^0.6.10;
137 
138 interface SLErc20 {
139     function underlying() external view returns (address);
140 }
141 
142 contract UniswapConfig {
143     /// @dev Describe how to interpret the fixedPrice in the TokenConfig.
144     enum PriceSource {
145         FIXED_ETH, /// implies the fixedPrice is a constant multiple of the ETH price (which varies)
146         FIXED_USD, /// implies the fixedPrice is a constant multiple of the USD price (which is 1)
147         REPORTER   /// implies the price is set by the reporter
148     }
149 
150     /// @dev Describe how the USD price should be determined for an asset.
151     ///  There should be 1 TokenConfig object for each supported asset, passed in the constructor.
152     struct TokenConfig {
153         address slToken;
154         address underlying;
155         bytes32 symbolHash;
156         uint256 baseUnit;
157         PriceSource priceSource;
158         uint256 fixedPrice;
159         address uniswapMarket;
160         address sashimiswapMarket;
161         bool isUniswapReversed;
162         bool isSashimiswapReversed;
163         uint256 uniswapWeight;
164         uint256 sashimiswapWeight;
165         bool isDoubleAnchorTolerance;
166     }
167 
168     /// @notice The max number of tokens this contract is hardcoded to support
169     /// @dev Do not change this variable without updating all the fields throughout the contract.
170     uint public constant maxTokens = 30;
171 
172     /// @notice The number of tokens this contract actually supports
173     uint public immutable numTokens;
174 
175     TokenConfig[] internal tokenConfigs;
176 
177     address internal immutable slToken00;
178     address internal immutable slToken01;
179     address internal immutable slToken02;
180     address internal immutable slToken03;
181     address internal immutable slToken04;
182     address internal immutable slToken05;
183     address internal immutable slToken06;
184     address internal immutable slToken07;
185     address internal immutable slToken08;
186     address internal immutable slToken09;
187     address internal immutable slToken10;
188     address internal immutable slToken11;
189     address internal immutable slToken12;
190     address internal immutable slToken13;
191     address internal immutable slToken14;
192     address internal immutable slToken15;
193     address internal immutable slToken16;
194     address internal immutable slToken17;
195     address internal immutable slToken18;
196     address internal immutable slToken19;
197     address internal immutable slToken20;
198     address internal immutable slToken21;
199     address internal immutable slToken22;
200     address internal immutable slToken23;
201     address internal immutable slToken24;
202     address internal immutable slToken25;
203     address internal immutable slToken26;
204     address internal immutable slToken27;
205     address internal immutable slToken28;
206     address internal immutable slToken29;
207 
208     address internal immutable underlying00;
209     address internal immutable underlying01;
210     address internal immutable underlying02;
211     address internal immutable underlying03;
212     address internal immutable underlying04;
213     address internal immutable underlying05;
214     address internal immutable underlying06;
215     address internal immutable underlying07;
216     address internal immutable underlying08;
217     address internal immutable underlying09;
218     address internal immutable underlying10;
219     address internal immutable underlying11;
220     address internal immutable underlying12;
221     address internal immutable underlying13;
222     address internal immutable underlying14;
223     address internal immutable underlying15;
224     address internal immutable underlying16;
225     address internal immutable underlying17;
226     address internal immutable underlying18;
227     address internal immutable underlying19;
228     address internal immutable underlying20;
229     address internal immutable underlying21;
230     address internal immutable underlying22;
231     address internal immutable underlying23;
232     address internal immutable underlying24;
233     address internal immutable underlying25;
234     address internal immutable underlying26;
235     address internal immutable underlying27;
236     address internal immutable underlying28;
237     address internal immutable underlying29;
238 
239     bytes32 internal immutable symbolHash00;
240     bytes32 internal immutable symbolHash01;
241     bytes32 internal immutable symbolHash02;
242     bytes32 internal immutable symbolHash03;
243     bytes32 internal immutable symbolHash04;
244     bytes32 internal immutable symbolHash05;
245     bytes32 internal immutable symbolHash06;
246     bytes32 internal immutable symbolHash07;
247     bytes32 internal immutable symbolHash08;
248     bytes32 internal immutable symbolHash09;
249     bytes32 internal immutable symbolHash10;
250     bytes32 internal immutable symbolHash11;
251     bytes32 internal immutable symbolHash12;
252     bytes32 internal immutable symbolHash13;
253     bytes32 internal immutable symbolHash14;
254     bytes32 internal immutable symbolHash15;
255     bytes32 internal immutable symbolHash16;
256     bytes32 internal immutable symbolHash17;
257     bytes32 internal immutable symbolHash18;
258     bytes32 internal immutable symbolHash19;
259     bytes32 internal immutable symbolHash20;
260     bytes32 internal immutable symbolHash21;
261     bytes32 internal immutable symbolHash22;
262     bytes32 internal immutable symbolHash23;
263     bytes32 internal immutable symbolHash24;
264     bytes32 internal immutable symbolHash25;
265     bytes32 internal immutable symbolHash26;
266     bytes32 internal immutable symbolHash27;
267     bytes32 internal immutable symbolHash28;
268     bytes32 internal immutable symbolHash29;
269 
270     /**
271      * @notice Construct an immutable store of configs into the contract data
272      * @param configs The configs for the supported assets
273      */
274     constructor(TokenConfig[] memory configs) public {
275         require(configs.length <= maxTokens, "too many configs");
276         numTokens = configs.length;
277         for(uint i = 0; i < configs.length; i++){
278             tokenConfigs.push(configs[i]);
279         }
280         slToken00 = get(configs, 0).slToken;
281         slToken01 = get(configs, 1).slToken;
282         slToken02 = get(configs, 2).slToken;
283         slToken03 = get(configs, 3).slToken;
284         slToken04 = get(configs, 4).slToken;
285         slToken05 = get(configs, 5).slToken;
286         slToken06 = get(configs, 6).slToken;
287         slToken07 = get(configs, 7).slToken;
288         slToken08 = get(configs, 8).slToken;
289         slToken09 = get(configs, 9).slToken;
290         slToken10 = get(configs, 10).slToken;
291         slToken11 = get(configs, 11).slToken;
292         slToken12 = get(configs, 12).slToken;
293         slToken13 = get(configs, 13).slToken;
294         slToken14 = get(configs, 14).slToken;
295         slToken15 = get(configs, 15).slToken;
296         slToken16 = get(configs, 16).slToken;
297         slToken17 = get(configs, 17).slToken;
298         slToken18 = get(configs, 18).slToken;
299         slToken19 = get(configs, 19).slToken;
300         slToken20 = get(configs, 20).slToken;
301         slToken21 = get(configs, 21).slToken;
302         slToken22 = get(configs, 22).slToken;
303         slToken23 = get(configs, 23).slToken;
304         slToken24 = get(configs, 24).slToken;
305         slToken25 = get(configs, 25).slToken;
306         slToken26 = get(configs, 26).slToken;
307         slToken27 = get(configs, 27).slToken;
308         slToken28 = get(configs, 28).slToken;
309         slToken29 = get(configs, 29).slToken;
310 
311         underlying00 = get(configs, 0).underlying;
312         underlying01 = get(configs, 1).underlying;
313         underlying02 = get(configs, 2).underlying;
314         underlying03 = get(configs, 3).underlying;
315         underlying04 = get(configs, 4).underlying;
316         underlying05 = get(configs, 5).underlying;
317         underlying06 = get(configs, 6).underlying;
318         underlying07 = get(configs, 7).underlying;
319         underlying08 = get(configs, 8).underlying;
320         underlying09 = get(configs, 9).underlying;
321         underlying10 = get(configs, 10).underlying;
322         underlying11 = get(configs, 11).underlying;
323         underlying12 = get(configs, 12).underlying;
324         underlying13 = get(configs, 13).underlying;
325         underlying14 = get(configs, 14).underlying;
326         underlying15 = get(configs, 15).underlying;
327         underlying16 = get(configs, 16).underlying;
328         underlying17 = get(configs, 17).underlying;
329         underlying18 = get(configs, 18).underlying;
330         underlying19 = get(configs, 19).underlying;
331         underlying20 = get(configs, 20).underlying;
332         underlying21 = get(configs, 21).underlying;
333         underlying22 = get(configs, 22).underlying;
334         underlying23 = get(configs, 23).underlying;
335         underlying24 = get(configs, 24).underlying;
336         underlying25 = get(configs, 25).underlying;
337         underlying26 = get(configs, 26).underlying;
338         underlying27 = get(configs, 27).underlying;
339         underlying28 = get(configs, 28).underlying;
340         underlying29 = get(configs, 29).underlying;
341 
342         symbolHash00 = get(configs, 0).symbolHash;
343         symbolHash01 = get(configs, 1).symbolHash;
344         symbolHash02 = get(configs, 2).symbolHash;
345         symbolHash03 = get(configs, 3).symbolHash;
346         symbolHash04 = get(configs, 4).symbolHash;
347         symbolHash05 = get(configs, 5).symbolHash;
348         symbolHash06 = get(configs, 6).symbolHash;
349         symbolHash07 = get(configs, 7).symbolHash;
350         symbolHash08 = get(configs, 8).symbolHash;
351         symbolHash09 = get(configs, 9).symbolHash;
352         symbolHash10 = get(configs, 10).symbolHash;
353         symbolHash11 = get(configs, 11).symbolHash;
354         symbolHash12 = get(configs, 12).symbolHash;
355         symbolHash13 = get(configs, 13).symbolHash;
356         symbolHash14 = get(configs, 14).symbolHash;
357         symbolHash15 = get(configs, 15).symbolHash;
358         symbolHash16 = get(configs, 16).symbolHash;
359         symbolHash17 = get(configs, 17).symbolHash;
360         symbolHash18 = get(configs, 18).symbolHash;
361         symbolHash19 = get(configs, 19).symbolHash;
362         symbolHash20 = get(configs, 20).symbolHash;
363         symbolHash21 = get(configs, 21).symbolHash;
364         symbolHash22 = get(configs, 22).symbolHash;
365         symbolHash23 = get(configs, 23).symbolHash;
366         symbolHash24 = get(configs, 24).symbolHash;
367         symbolHash25 = get(configs, 25).symbolHash;
368         symbolHash26 = get(configs, 26).symbolHash;
369         symbolHash27 = get(configs, 27).symbolHash;
370         symbolHash28 = get(configs, 28).symbolHash;
371         symbolHash29 = get(configs, 29).symbolHash;
372     }
373 
374     function get(TokenConfig[] memory configs, uint i) internal pure returns (TokenConfig memory) {
375         if (i < configs.length)
376             return configs[i];
377         return TokenConfig({
378             slToken: address(0),
379             underlying: address(0),
380             symbolHash: bytes32(0),
381             baseUnit: uint256(0),
382             priceSource: PriceSource(0),
383             fixedPrice: uint256(0),
384             uniswapMarket: address(0),
385             sashimiswapMarket: address(0),
386             isUniswapReversed: false,
387             isSashimiswapReversed: false,
388             uniswapWeight: 0,
389             sashimiswapWeight: 0,
390             isDoubleAnchorTolerance: false
391         });
392     }
393 
394     function getSLTokenIndex(address slToken) internal view returns (uint) {
395         if (slToken == slToken00) return 0;
396         if (slToken == slToken01) return 1;
397         if (slToken == slToken02) return 2;
398         if (slToken == slToken03) return 3;
399         if (slToken == slToken04) return 4;
400         if (slToken == slToken05) return 5;
401         if (slToken == slToken06) return 6;
402         if (slToken == slToken07) return 7;
403         if (slToken == slToken08) return 8;
404         if (slToken == slToken09) return 9;
405         if (slToken == slToken10) return 10;
406         if (slToken == slToken11) return 11;
407         if (slToken == slToken12) return 12;
408         if (slToken == slToken13) return 13;
409         if (slToken == slToken14) return 14;
410         if (slToken == slToken15) return 15;
411         if (slToken == slToken16) return 16;
412         if (slToken == slToken17) return 17;
413         if (slToken == slToken18) return 18;
414         if (slToken == slToken19) return 19;
415         if (slToken == slToken20) return 20;
416         if (slToken == slToken21) return 21;
417         if (slToken == slToken22) return 22;
418         if (slToken == slToken23) return 23;
419         if (slToken == slToken24) return 24;
420         if (slToken == slToken25) return 25;
421         if (slToken == slToken26) return 26;
422         if (slToken == slToken27) return 27;
423         if (slToken == slToken28) return 28;
424         if (slToken == slToken29) return 29;
425 
426         return uint(-1);
427     }
428 
429     function getUnderlyingIndex(address underlying) internal view returns (uint) {
430         if (underlying == underlying00) return 0;
431         if (underlying == underlying01) return 1;
432         if (underlying == underlying02) return 2;
433         if (underlying == underlying03) return 3;
434         if (underlying == underlying04) return 4;
435         if (underlying == underlying05) return 5;
436         if (underlying == underlying06) return 6;
437         if (underlying == underlying07) return 7;
438         if (underlying == underlying08) return 8;
439         if (underlying == underlying09) return 9;
440         if (underlying == underlying10) return 10;
441         if (underlying == underlying11) return 11;
442         if (underlying == underlying12) return 12;
443         if (underlying == underlying13) return 13;
444         if (underlying == underlying14) return 14;
445         if (underlying == underlying15) return 15;
446         if (underlying == underlying16) return 16;
447         if (underlying == underlying17) return 17;
448         if (underlying == underlying18) return 18;
449         if (underlying == underlying19) return 19;
450         if (underlying == underlying20) return 20;
451         if (underlying == underlying21) return 21;
452         if (underlying == underlying22) return 22;
453         if (underlying == underlying23) return 23;
454         if (underlying == underlying24) return 24;
455         if (underlying == underlying25) return 25;
456         if (underlying == underlying26) return 26;
457         if (underlying == underlying27) return 27;
458         if (underlying == underlying28) return 28;
459         if (underlying == underlying29) return 29;
460 
461         return uint(-1);
462     }
463 
464     function getSymbolHashIndex(bytes32 symbolHash) internal view returns (uint) {
465         if (symbolHash == symbolHash00) return 0;
466         if (symbolHash == symbolHash01) return 1;
467         if (symbolHash == symbolHash02) return 2;
468         if (symbolHash == symbolHash03) return 3;
469         if (symbolHash == symbolHash04) return 4;
470         if (symbolHash == symbolHash05) return 5;
471         if (symbolHash == symbolHash06) return 6;
472         if (symbolHash == symbolHash07) return 7;
473         if (symbolHash == symbolHash08) return 8;
474         if (symbolHash == symbolHash09) return 9;
475         if (symbolHash == symbolHash10) return 10;
476         if (symbolHash == symbolHash11) return 11;
477         if (symbolHash == symbolHash12) return 12;
478         if (symbolHash == symbolHash13) return 13;
479         if (symbolHash == symbolHash14) return 14;
480         if (symbolHash == symbolHash15) return 15;
481         if (symbolHash == symbolHash16) return 16;
482         if (symbolHash == symbolHash17) return 17;
483         if (symbolHash == symbolHash18) return 18;
484         if (symbolHash == symbolHash19) return 19;
485         if (symbolHash == symbolHash20) return 20;
486         if (symbolHash == symbolHash21) return 21;
487         if (symbolHash == symbolHash22) return 22;
488         if (symbolHash == symbolHash23) return 23;
489         if (symbolHash == symbolHash24) return 24;
490         if (symbolHash == symbolHash25) return 25;
491         if (symbolHash == symbolHash26) return 26;
492         if (symbolHash == symbolHash27) return 27;
493         if (symbolHash == symbolHash28) return 28;
494         if (symbolHash == symbolHash29) return 29;
495 
496         return uint(-1);
497     }
498 
499     /**
500      * @notice Get the i-th config, according to the order they were passed in originally
501      * @param i The index of the config to get
502      * @return The config object
503      */
504     function getTokenConfig(uint i) public view returns (TokenConfig memory) {
505         require(i < numTokens, "token config not found");
506 
507         return tokenConfigs[i];}
508 
509     /**
510      * @notice Get the config for symbol
511      * @param symbol The symbol of the config to get
512      * @return The config object
513      */
514     function getTokenConfigBySymbol(string memory symbol) public view returns (TokenConfig memory) {
515         return getTokenConfigBySymbolHash(keccak256(abi.encodePacked(symbol)));
516     }
517 
518     /**
519      * @notice Get the config for the symbolHash
520      * @param symbolHash The keccack256 of the symbol of the config to get
521      * @return The config object
522      */
523     function getTokenConfigBySymbolHash(bytes32 symbolHash) public view returns (TokenConfig memory) {
524         uint index = getSymbolHashIndex(symbolHash);
525         if (index != uint(-1)) {
526             return getTokenConfig(index);
527         }
528 
529         revert("token config not found");
530     }
531 
532     /**
533      * @notice Get the config for the slToken
534      * @dev If a config for the slToken is not found, falls back to searching for the underlying.
535      * @param slToken The address of the slToken of the config to get
536      * @return The config object
537      */
538     function getTokenConfigBySLToken(address slToken) public view returns (TokenConfig memory) {
539         uint index = getSLTokenIndex(slToken);
540         if (index != uint(-1)) {
541             return getTokenConfig(index);
542         }
543 
544         return getTokenConfigByUnderlying(SLErc20(slToken).underlying());
545     }
546 
547     /**
548      * @notice Get the config for an underlying asset
549      * @param underlying The address of the underlying asset of the config to get
550      * @return The config object
551      */
552     function getTokenConfigByUnderlying(address underlying) public view returns (TokenConfig memory) {
553         uint index = getUnderlyingIndex(underlying);
554         if (index != uint(-1)) {
555             return getTokenConfig(index);
556         }
557 
558         revert("token config not found");
559     }
560 }
561 
562 // File: contracts/Uniswap/UniswapLib.sol
563 
564 
565 pragma solidity ^0.6.10;
566 
567 // Based on code from https://github.com/Uniswap/uniswap-v2-periphery
568 
569 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
570 library FixedPoint {
571     // range: [0, 2**112 - 1]
572     // resolution: 1 / 2**112
573     struct uq112x112 {
574         uint224 _x;
575     }
576 
577     // returns a uq112x112 which represents the ratio of the numerator to the denominator
578     // equivalent to encode(numerator).div(denominator)
579     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
580         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
581         return uq112x112((uint224(numerator) << 112) / denominator);
582     }
583 
584     // decode a uq112x112 into a uint with 18 decimals of precision
585     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
586         // we only have 256 - 224 = 32 bits to spare, so scaling up by ~60 bits is dangerous
587         // instead, get close to:
588         //  (x * 1e18) >> 112
589         // without risk of overflowing, e.g.:
590         //  (x) / 2 ** (112 - lg(1e18))
591         return uint(self._x) / 5192296858534827;
592     }
593 }
594 
595 // library with helper methods for oracles that are concerned with computing average prices
596 library UniswapV2OracleLibrary {
597     using FixedPoint for *;
598 
599     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
600     function currentBlockTimestamp() internal view returns (uint32) {
601         return uint32(block.timestamp % 2 ** 32);
602     }
603 
604     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
605     function currentCumulativePrices(
606         address pair
607     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
608         blockTimestamp = currentBlockTimestamp();
609         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
610         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
611 
612         // if time has elapsed since the last update on the pair, mock the accumulated price values
613         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
614         if (blockTimestampLast != blockTimestamp) {
615             // subtraction overflow is desired
616             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
617             // addition overflow is desired
618             // counterfactual
619             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
620             // counterfactual
621             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
622         }
623     }
624 }
625 
626 interface IUniswapV2Pair {
627     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
628     function price0CumulativeLast() external view returns (uint);
629     function price1CumulativeLast() external view returns (uint);
630 }
631 
632 // File: contracts/Uniswap/UniswapAnchoredView.sol
633 
634 
635 pragma solidity ^0.6.10;
636 
637 
638 
639 
640 struct Observation {
641     uint timestamp;
642     uint acc;
643 }
644 
645 contract UniswapAnchoredView is UniswapConfig {
646     using FixedPoint for *;
647 
648     /// @notice The Open Oracle Price Data contract
649     OpenOraclePriceData public immutable priceData;
650 
651     /// @notice The number of wei in 1 ETH
652     uint public constant ethBaseUnit = 1e18;
653 
654     /// @notice A common scaling factor to maintain precision
655     uint public constant expScale = 1e18;
656 
657     /// @notice The Open Oracle Reporter
658     address public immutable reporter;
659 
660     /// @notice The highest ratio of the new price to the anchor price that will still trigger the price to be updated
661     uint public immutable upperBoundAnchorRatio;
662 
663     /// @notice The lowest ratio of the new price to the anchor price that will still trigger the price to be updated
664     uint public immutable lowerBoundAnchorRatio;
665 
666     uint public immutable upperBoundAnchorRatio2;
667 
668     uint public immutable lowerBoundAnchorRatio2;
669 
670     /// @notice The minimum amount of time in seconds required for the old uniswap price accumulator to be replaced
671     uint public immutable anchorPeriod;
672 
673     /// @notice Official prices by symbol hash
674     mapping(bytes32 => uint) public prices;
675 
676     /// @notice Circuit breaker for using anchor price oracle directly, ignoring reporter
677     bool public reporterInvalidated;
678 
679     /// @notice The old observation for each symbolHash
680     mapping(bytes32 => Observation) public oldUniswapObservations;
681 
682     /// @notice The new observation for each symbolHash
683     mapping(bytes32 => Observation) public newUniswapObservations;
684 
685      /// @notice The old observation for each symbolHash
686     mapping(bytes32 => Observation) public oldSashimiswapObservations;
687 
688     /// @notice The new observation for each symbolHash
689     mapping(bytes32 => Observation) public newSashimiswapObservations;
690 
691     /// @notice The event emitted when new prices are posted but the stored price is not updated due to the anchor
692     event PriceGuarded(string symbol, uint reporter, uint anchor);
693 
694     /// @notice The event emitted when the stored price is updated
695     event PriceUpdated(string symbol, uint price);
696 
697     /// @notice The event emitted when anchor price is updated
698     event AnchorPriceUpdated(string symbol, uint anchorPrice, uint oldTimestamp, uint newTimestamp);
699 
700     /// @notice The event emitted when the uniswap window changes
701     event UniswapWindowUpdated(bytes32 indexed symbolHash, uint oldTimestamp, uint newTimestamp, uint oldPrice, uint newPrice);
702 
703     /// @notice The event emitted when the uniswap window changes
704     event SashimiswapWindowUpdated(bytes32 indexed symbolHash, uint oldTimestamp, uint newTimestamp, uint oldPrice, uint newPrice);
705 
706     /// @notice The event emitted when reporter invalidates itself
707     event ReporterInvalidated(address reporter);
708 
709     bytes32 constant ethHash = keccak256(abi.encodePacked("ETH"));
710     bytes32 constant rotateHash = keccak256(abi.encodePacked("rotate"));
711 
712     /**
713      * @notice Construct a uniswap anchored view for a set of token configurations
714      * @dev Note that to avoid immature TWAPs, the system must run for at least a single anchorPeriod before using.
715      * @param reporter_ The reporter whose prices are to be used
716      * @param anchorToleranceMantissa_ The percentage tolerance that the reporter may deviate from the uniswap anchor
717      * @param anchorPeriod_ The minimum amount of time required for the old uniswap price accumulator to be replaced
718      * @param configs The static token configurations which define what prices are supported and how
719      */
720     constructor(OpenOraclePriceData priceData_,
721                 address reporter_,
722                 uint anchorToleranceMantissa_,
723                 uint anchorPeriod_,
724                 TokenConfig[] memory configs) UniswapConfig(configs) public {
725         priceData = priceData_;
726         reporter = reporter_;
727         anchorPeriod = anchorPeriod_;
728 
729         // Allow the tolerance to be whatever the deployer chooses, but prevent under/overflow (and prices from being 0)
730         upperBoundAnchorRatio = anchorToleranceMantissa_ > uint(-1) - 100e16 ? uint(-1) : 100e16 + anchorToleranceMantissa_;
731         lowerBoundAnchorRatio = anchorToleranceMantissa_ < 100e16 ? 100e16 - anchorToleranceMantissa_ : 1;
732         uint doubleAnchorToleranceMantissa = mul(anchorToleranceMantissa_, 2);
733         upperBoundAnchorRatio2 = doubleAnchorToleranceMantissa > uint(-1) - 100e16 ? uint(-1) : 100e16 + doubleAnchorToleranceMantissa;
734         lowerBoundAnchorRatio2 = doubleAnchorToleranceMantissa < 100e16 ? 100e16 - doubleAnchorToleranceMantissa : 1;
735 
736         for (uint i = 0; i < configs.length; i++) {
737             TokenConfig memory config = configs[i];
738             require(config.baseUnit > 0, "baseUnit must be greater than zero");
739             address uniswapMarket = config.uniswapMarket;
740             if (config.priceSource == PriceSource.REPORTER) {
741                 require(uniswapMarket != address(0), "reported prices must have an anchor");
742                 bytes32 symbolHash = config.symbolHash;
743                 uint uniswapCumulativePrice = currentCumulativePrice(config.uniswapMarket, config.isUniswapReversed);
744                 oldUniswapObservations[symbolHash].timestamp = block.timestamp;
745                 newUniswapObservations[symbolHash].timestamp = block.timestamp;
746                 oldUniswapObservations[symbolHash].acc = uniswapCumulativePrice;
747                 newUniswapObservations[symbolHash].acc = uniswapCumulativePrice;
748                 emit UniswapWindowUpdated(symbolHash, block.timestamp, block.timestamp, uniswapCumulativePrice, uniswapCumulativePrice);
749                 if(config.sashimiswapMarket != address(0)){
750                     uint sashimiswapCumulativePrice = currentCumulativePrice(config.sashimiswapMarket, config.isSashimiswapReversed);
751                     oldSashimiswapObservations[symbolHash].timestamp = block.timestamp;
752                     newSashimiswapObservations[symbolHash].timestamp = block.timestamp;
753                     oldSashimiswapObservations[symbolHash].acc = sashimiswapCumulativePrice;
754                     newSashimiswapObservations[symbolHash].acc = sashimiswapCumulativePrice;
755                     emit SashimiswapWindowUpdated(symbolHash, block.timestamp, block.timestamp, sashimiswapCumulativePrice, sashimiswapCumulativePrice);
756                 }
757                 
758             } else {
759                 require(uniswapMarket == address(0), "only reported prices utilize an anchor");
760             }
761         }
762     }
763 
764     /**
765      * @notice Get the official price for a symbol
766      * @param symbol The symbol to fetch the price of
767      * @return Price denominated in USD, with 6 decimals
768      */
769     function price(string memory symbol) external view returns (uint) {
770         TokenConfig memory config = getTokenConfigBySymbol(symbol);
771         return priceInternal(config);
772     }
773 
774     function priceInternal(TokenConfig memory config) internal view returns (uint) {
775         if (config.priceSource == PriceSource.REPORTER) return prices[config.symbolHash];
776         if (config.priceSource == PriceSource.FIXED_USD) return config.fixedPrice;
777         if (config.priceSource == PriceSource.FIXED_ETH) {
778             uint usdPerEth = prices[ethHash];
779             require(usdPerEth > 0, "ETH price not set, cannot convert to dollars");
780             return mul(usdPerEth, config.fixedPrice) / ethBaseUnit;
781         }
782     }
783 
784     /**
785      * @notice Get the underlying price of a slToken
786      * @dev Implements the PriceOracle interface for Compound v2.
787      * @param slToken The slToken address for price retrieval
788      * @return Price denominated in USD, with 18 decimals, for the given slToken address
789      */
790     function getUnderlyingPrice(address slToken) external view returns (uint) {
791         TokenConfig memory config = getTokenConfigBySLToken(slToken);
792          // Comptroller needs prices in the format: ${raw price} * 1e(36 - baseUnit)
793          // Since the prices in this view have 6 decimals, we must scale them by 1e(36 - 6 - baseUnit)
794         return mul(1e30, priceInternal(config)) / config.baseUnit;
795     }
796 
797     /**
798      * @notice Post open oracle reporter prices, and recalculate stored price by comparing to anchor
799      * @dev We let anyone pay to post anything, but only prices from configured reporter will be stored in the view.
800      * @param messages The messages to post to the oracle
801      * @param signatures The signatures for the corresponding messages
802      * @param symbols The symbols to compare to anchor for authoritative reading
803      */
804     function postPrices(bytes[] calldata messages, bytes[] calldata signatures, string[] calldata symbols) external {
805         require(messages.length == signatures.length, "messages and signatures must be 1:1");
806 
807         // Save the prices
808         for (uint i = 0; i < messages.length; i++) {
809             priceData.put(messages[i], signatures[i]);
810         }
811 
812         uint ethPrice = fetchEthPrice();
813 
814         // Try to update the view storage
815         for (uint i = 0; i < symbols.length; i++) {
816             postPriceInternal(symbols[i], ethPrice);
817         }
818     }
819 
820     function postPriceInternal(string memory symbol, uint ethPrice) internal {
821         TokenConfig memory config = getTokenConfigBySymbol(symbol);
822         require(config.priceSource == PriceSource.REPORTER, "only reporter prices get posted");
823 
824         bytes32 symbolHash = keccak256(abi.encodePacked(symbol));
825         uint reporterPrice = priceData.getPrice(reporter, symbol);
826         uint anchorPrice;
827         if (symbolHash == ethHash) {
828             anchorPrice = ethPrice;
829         } else {
830             anchorPrice = fetchAnchorPrice(symbol, config, ethPrice);
831         }
832 
833         if (reporterInvalidated) {
834             prices[symbolHash] = anchorPrice;
835             emit PriceUpdated(symbol, anchorPrice);
836         } else if (isWithinAnchor(reporterPrice, anchorPrice, config)) {
837             prices[symbolHash] = reporterPrice;
838             emit PriceUpdated(symbol, reporterPrice);
839         } else {
840             emit PriceGuarded(symbol, reporterPrice, anchorPrice);
841         }
842     }
843 
844     function isWithinAnchor(uint reporterPrice, uint anchorPrice, TokenConfig memory config) internal view returns (bool) {
845         if (reporterPrice > 0) {
846             uint anchorRatio = mul(anchorPrice, 100e16) / reporterPrice;
847             if(config.isDoubleAnchorTolerance){
848                 return anchorRatio <= upperBoundAnchorRatio2 && anchorRatio >= lowerBoundAnchorRatio2;
849             }
850             return anchorRatio <= upperBoundAnchorRatio && anchorRatio >= lowerBoundAnchorRatio;
851         }
852         return false;
853     }
854 
855     /**
856      * @dev Fetches the current token/eth price accumulator from uniswap.
857      */
858     function currentCumulativePrice(address swapMarket, bool isSwapReversed) internal view returns (uint) {
859         (uint cumulativePrice0, uint cumulativePrice1,) = UniswapV2OracleLibrary.currentCumulativePrices(swapMarket);
860         if (isSwapReversed) {
861             return cumulativePrice1;
862         } else {
863             return cumulativePrice0;
864         }
865     }
866 
867     /**
868      * @dev Fetches the current eth/usd price from uniswap, with 6 decimals of precision.
869      *  Conversion factor is 1e18 for eth/usdc market, since we decode uniswap price statically with 18 decimals.
870      */
871     function fetchEthPrice() internal returns (uint) {
872         return fetchAnchorPrice("ETH", getTokenConfigBySymbolHash(ethHash), ethBaseUnit);
873     }
874 
875     /**
876      * @dev Fetches the current token/usd price from uniswap, with 6 decimals of precision.
877      * @param conversionFactor 1e18 if seeking the ETH price, and a 6 decimal ETH-USDC price in the case of other assets
878      */
879     function fetchAnchorPrice(string memory symbol, TokenConfig memory config, uint conversionFactor) internal virtual returns (uint) {
880         (uint nowCumulativePrice, uint oldCumulativePrice, uint oldTimestamp) = pokeUniswapWindowValues(config.symbolHash, config.uniswapMarket,config.isUniswapReversed);
881         uint priceAverage = getPriceAverage(nowCumulativePrice, oldCumulativePrice, oldTimestamp);
882 
883         if(config.sashimiswapMarket != address(0)){
884             (uint nowSashimiswapCumulativePrice, uint oldSashimiswapCumulativePrice, uint oldSashimiswapTimestamp) = pokeSashimiswapWindowValues(config.symbolHash, config.sashimiswapMarket,config.isSashimiswapReversed);
885             uint sashimiswapPriceAverage = getPriceAverage(nowSashimiswapCumulativePrice, oldSashimiswapCumulativePrice, oldSashimiswapTimestamp);
886             if(sashimiswapPriceAverage > 0){
887                 priceAverage = (mul(priceAverage, config.uniswapWeight) + mul(sashimiswapPriceAverage, config.sashimiswapWeight)) / 10000;
888             }
889         }
890 
891         uint unscaledPriceMantissa = mul(priceAverage, conversionFactor);
892         uint anchorPrice;
893 
894         // Adjust rawUniswapPrice according to the units of the non-ETH asset
895         // In the case of ETH, we would have to scale by 1e6 / USDC_UNITS, but since baseUnit2 is 1e6 (USDC), it cancels
896         if (config.isUniswapReversed) {
897             // unscaledPriceMantissa * ethBaseUnit / config.baseUnit / expScale, but we simplify bc ethBaseUnit == expScale
898             anchorPrice = unscaledPriceMantissa / config.baseUnit;
899         } else {
900             anchorPrice = mul(unscaledPriceMantissa, config.baseUnit) / ethBaseUnit / expScale;
901         }
902 
903         emit AnchorPriceUpdated(symbol, anchorPrice, oldTimestamp, block.timestamp);
904 
905         return anchorPrice;
906     }
907 
908     function getPriceAverage(uint nowCumulativePrice, uint oldCumulativePrice, uint oldTimestamp) internal view returns (uint){
909         // This should be impossible, but better safe than sorry
910         require(block.timestamp > oldTimestamp, "now must come after before");
911         uint timeElapsed = block.timestamp - oldTimestamp;
912 
913         // Calculate uniswap time-weighted average price
914         // Underflow is a property of the accumulators: https://uniswap.org/audit.html#orgc9b3190
915         FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(uint224((nowCumulativePrice - oldCumulativePrice) / timeElapsed));
916         uint rawSwapPriceMantissa = priceAverage.decode112with18();
917         return rawSwapPriceMantissa;
918     }
919 
920     /**
921      * @dev Get time-weighted average prices for a token at the current timestamp.
922      *  Update new and old observations of lagging window if period elapsed.
923      */
924     function pokeUniswapWindowValues(bytes32 symbolHash, address swapMarket,bool isSwapReversed) internal returns (uint, uint, uint) {
925         uint cumulativePrice = currentCumulativePrice(swapMarket, isSwapReversed);
926 
927         Observation memory newObservation = newUniswapObservations[symbolHash];
928 
929         // Update new and old observations if elapsed time is greater than or equal to anchor period
930         uint timeElapsed = block.timestamp - newObservation.timestamp;
931         if (timeElapsed >= anchorPeriod) {
932             oldUniswapObservations[symbolHash].timestamp = newObservation.timestamp;
933             oldUniswapObservations[symbolHash].acc = newObservation.acc;
934 
935             newUniswapObservations[symbolHash].timestamp = block.timestamp;
936             newUniswapObservations[symbolHash].acc = cumulativePrice;
937             emit UniswapWindowUpdated(symbolHash, newObservation.timestamp, block.timestamp, newObservation.acc, cumulativePrice);
938         }
939         return (cumulativePrice, oldUniswapObservations[symbolHash].acc, oldUniswapObservations[symbolHash].timestamp);
940     }
941 
942     /**
943      * @dev Get time-weighted average prices for a token at the current timestamp.
944      *  Update new and old observations of lagging window if period elapsed.
945      */
946     function pokeSashimiswapWindowValues(bytes32 symbolHash, address swapMarket,bool isSwapReversed) internal returns (uint, uint, uint) {
947         uint cumulativePrice = currentCumulativePrice(swapMarket, isSwapReversed);
948 
949         Observation memory newObservation = newSashimiswapObservations[symbolHash];
950 
951         // Update new and old observations if elapsed time is greater than or equal to anchor period
952         uint timeElapsed = block.timestamp - newObservation.timestamp;
953         if (timeElapsed >= anchorPeriod) {
954             oldSashimiswapObservations[symbolHash].timestamp = newObservation.timestamp;
955             oldSashimiswapObservations[symbolHash].acc = newObservation.acc;
956 
957             newSashimiswapObservations[symbolHash].timestamp = block.timestamp;
958             newSashimiswapObservations[symbolHash].acc = cumulativePrice;
959             emit SashimiswapWindowUpdated(symbolHash, newObservation.timestamp, block.timestamp, newObservation.acc, cumulativePrice);
960         }
961         return (cumulativePrice, oldSashimiswapObservations[symbolHash].acc, oldSashimiswapObservations[symbolHash].timestamp);
962     }
963 
964     /**
965      * @notice Invalidate the reporter, and fall back to using anchor directly in all cases
966      * @dev Only the reporter may sign a message which allows it to invalidate itself.
967      *  To be used in cases of emergency, if the reporter thinks their key may be compromised.
968      * @param message The data that was presumably signed
969      * @param signature The fingerprint of the data + private key
970      */
971     function invalidateReporter(bytes memory message, bytes memory signature) external {
972         (string memory decodedMessage, ) = abi.decode(message, (string, address));
973         require(keccak256(abi.encodePacked(decodedMessage)) == rotateHash, "invalid message must be 'rotate'");
974         require(source(message, signature) == reporter, "invalidation message must come from the reporter");
975         reporterInvalidated = true;
976         emit ReporterInvalidated(reporter);
977     }
978 
979     /**
980      * @notice Recovers the source address which signed a message
981      * @dev Comparing to a claimed address would add nothing,
982      *  as the caller could simply perform the recover and claim that address.
983      * @param message The data that was presumably signed
984      * @param signature The fingerprint of the data + private key
985      * @return The source address which signed the message, presumably
986      */
987     function source(bytes memory message, bytes memory signature) public pure returns (address) {
988         (bytes32 r, bytes32 s, uint8 v) = abi.decode(signature, (bytes32, bytes32, uint8));
989         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(message)));
990         return ecrecover(hash, v, r, s);
991     }
992 
993     /// @dev Overflow proof multiplication
994     function mul(uint a, uint b) internal pure returns (uint) {
995         if (a == 0) return 0;
996         uint c = a * b;
997         require(c / a == b, "multiplication overflow");
998         return c;
999     }
1000 }