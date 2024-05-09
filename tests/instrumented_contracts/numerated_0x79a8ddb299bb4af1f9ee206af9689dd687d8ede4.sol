1 pragma solidity ^0.4.13;
2 
3 contract DSMath {
4     function add(uint x, uint y) internal pure returns (uint z) {
5         require((z = x + y) >= x);
6     }
7     function sub(uint x, uint y) internal pure returns (uint z) {
8         require((z = x - y) <= x);
9     }
10     function mul(uint x, uint y) internal pure returns (uint z) {
11         require(y == 0 || (z = x * y) / y == x);
12     }
13 
14     function min(uint x, uint y) internal pure returns (uint z) {
15         return x <= y ? x : y;
16     }
17     function max(uint x, uint y) internal pure returns (uint z) {
18         return x >= y ? x : y;
19     }
20     function imin(int x, int y) internal pure returns (int z) {
21         return x <= y ? x : y;
22     }
23     function imax(int x, int y) internal pure returns (int z) {
24         return x >= y ? x : y;
25     }
26 
27     uint constant WAD = 10 ** 18;
28     uint constant RAY = 10 ** 27;
29 
30     function wmul(uint x, uint y) internal pure returns (uint z) {
31         z = add(mul(x, y), WAD / 2) / WAD;
32     }
33     function rmul(uint x, uint y) internal pure returns (uint z) {
34         z = add(mul(x, y), RAY / 2) / RAY;
35     }
36     function wdiv(uint x, uint y) internal pure returns (uint z) {
37         z = add(mul(x, WAD), y / 2) / y;
38     }
39     function rdiv(uint x, uint y) internal pure returns (uint z) {
40         z = add(mul(x, RAY), y / 2) / y;
41     }
42 
43     // This famous algorithm is called "exponentiation by squaring"
44     // and calculates x^n with x as fixed-point and n as regular unsigned.
45     //
46     // It's O(log n), instead of O(n) for naive repeated multiplication.
47     //
48     // These facts are why it works:
49     //
50     //  If n is even, then x^n = (x^2)^(n/2).
51     //  If n is odd,  then x^n = x * x^(n-1),
52     //   and applying the equation for even x gives
53     //    x^n = x * (x^2)^((n-1) / 2).
54     //
55     //  Also, EVM division is flooring and
56     //    floor[(n-1) / 2] = floor[n / 2].
57     //
58     function rpow(uint x, uint n) internal pure returns (uint z) {
59         z = n % 2 != 0 ? x : RAY;
60 
61         for (n /= 2; n != 0; n /= 2) {
62             x = rmul(x, x);
63 
64             if (n % 2 != 0) {
65                 z = rmul(z, x);
66             }
67         }
68     }
69 }
70 
71 contract DBC {
72 
73     // MODIFIERS
74 
75     modifier pre_cond(bool condition) {
76         require(condition);
77         _;
78     }
79 
80     modifier post_cond(bool condition) {
81         _;
82         assert(condition);
83     }
84 
85     modifier invariant(bool condition) {
86         require(condition);
87         _;
88         assert(condition);
89     }
90 }
91 
92 contract Owned is DBC {
93 
94     // FIELDS
95 
96     address public owner;
97 
98     // NON-CONSTANT METHODS
99 
100     function Owned() { owner = msg.sender; }
101 
102     function changeOwner(address ofNewOwner) pre_cond(isOwner()) { owner = ofNewOwner; }
103 
104     // PRE, POST, INVARIANT CONDITIONS
105 
106     function isOwner() internal returns (bool) { return msg.sender == owner; }
107 
108 }
109 
110 contract AssetRegistrar is DBC, Owned {
111 
112     // TYPES
113 
114     struct Asset {
115         address breakIn; // Break in contract on destination chain
116         address breakOut; // Break out contract on this chain; A way to leave
117         bytes32 chainId; // On which chain this asset resides
118         uint decimal; // Decimal, order of magnitude of precision, of the Asset as in ERC223 token standard
119         bool exists; // Is this asset registered
120         string ipfsHash; // Same as url but for ipfs
121         string name; // Human-readable name of the Asset as in ERC223 token standard
122         uint price; // Price of asset quoted against `QUOTE_ASSET` * 10 ** decimals
123         string symbol; // Human-readable symbol of the Asset as in ERC223 token standard
124         uint timestamp; // Timestamp of last price update of this asset
125         string url; // URL for additional information of Asset
126     }
127 
128     // FIELDS
129 
130     // Methods fields
131     mapping (address => Asset) public information;
132 
133     // METHODS
134 
135     // PUBLIC METHODS
136 
137     /// @notice Registers an Asset residing in a chain
138     /// @dev Pre: Only registrar owner should be able to register
139     /// @dev Post: Address ofAsset is registered
140     /// @param ofAsset Address of asset to be registered
141     /// @param name Human-readable name of the Asset as in ERC223 token standard
142     /// @param symbol Human-readable symbol of the Asset as in ERC223 token standard
143     /// @param decimal Human-readable symbol of the Asset as in ERC223 token standard
144     /// @param url Url for extended information of the asset
145     /// @param ipfsHash Same as url but for ipfs
146     /// @param chainId Chain where the asset resides
147     /// @param breakIn Address of break in contract on destination chain
148     /// @param breakOut Address of break out contract on this chain
149     function register(
150         address ofAsset,
151         string name,
152         string symbol,
153         uint decimal,
154         string url,
155         string ipfsHash,
156         bytes32 chainId,
157         address breakIn,
158         address breakOut
159     )
160         pre_cond(isOwner())
161         pre_cond(!information[ofAsset].exists)
162     {
163         Asset asset = information[ofAsset];
164         asset.name = name;
165         asset.symbol = symbol;
166         asset.decimal = decimal;
167         asset.url = url;
168         asset.ipfsHash = ipfsHash;
169         asset.breakIn = breakIn;
170         asset.breakOut = breakOut;
171         asset.exists = true;
172         assert(information[ofAsset].exists);
173     }
174 
175     /// @notice Updates description information of a registered Asset
176     /// @dev Pre: Owner can change an existing entry
177     /// @dev Post: Changed Name, Symbol, URL and/or IPFSHash
178     /// @param ofAsset Address of the asset to be updated
179     /// @param name Human-readable name of the Asset as in ERC223 token standard
180     /// @param symbol Human-readable symbol of the Asset as in ERC223 token standard
181     /// @param url Url for extended information of the asset
182     /// @param ipfsHash Same as url but for ipfs
183     function updateDescriptiveInformation(
184         address ofAsset,
185         string name,
186         string symbol,
187         string url,
188         string ipfsHash
189     )
190         pre_cond(isOwner())
191         pre_cond(information[ofAsset].exists)
192     {
193         Asset asset = information[ofAsset];
194         asset.name = name;
195         asset.symbol = symbol;
196         asset.url = url;
197         asset.ipfsHash = ipfsHash;
198     }
199 
200     /// @notice Deletes an existing entry
201     /// @dev Owner can delete an existing entry
202     /// @param ofAsset address for which specific information is requested
203     function remove(
204         address ofAsset
205     )
206         pre_cond(isOwner())
207         pre_cond(information[ofAsset].exists)
208     {
209         delete information[ofAsset]; // Sets exists boolean to false
210         assert(!information[ofAsset].exists);
211     }
212 
213     // PUBLIC VIEW METHODS
214 
215     // Get asset specific information
216     function getName(address ofAsset) view returns (string) { return information[ofAsset].name; }
217     function getSymbol(address ofAsset) view returns (string) { return information[ofAsset].symbol; }
218     function getDecimals(address ofAsset) view returns (uint) { return information[ofAsset].decimal; }
219 
220 }
221 
222 interface PriceFeedInterface {
223 
224     // EVENTS
225 
226     event PriceUpdated(uint timestamp);
227 
228     // PUBLIC METHODS
229 
230     function update(address[] ofAssets, uint[] newPrices);
231 
232     // PUBLIC VIEW METHODS
233 
234     // Get asset specific information
235     function getName(address ofAsset) view returns (string);
236     function getSymbol(address ofAsset) view returns (string);
237     function getDecimals(address ofAsset) view returns (uint);
238     // Get price feed operation specific information
239     function getQuoteAsset() view returns (address);
240     function getInterval() view returns (uint);
241     function getValidity() view returns (uint);
242     function getLastUpdateId() view returns (uint);
243     // Get asset specific information as updated in price feed
244     function hasRecentPrice(address ofAsset) view returns (bool isRecent);
245     function hasRecentPrices(address[] ofAssets) view returns (bool areRecent);
246     function getPrice(address ofAsset) view returns (bool isRecent, uint price, uint decimal);
247     function getPrices(address[] ofAssets) view returns (bool areRecent, uint[] prices, uint[] decimals);
248     function getInvertedPrice(address ofAsset) view returns (bool isRecent, uint invertedPrice, uint decimal);
249     function getReferencePrice(address ofBase, address ofQuote) view returns (bool isRecent, uint referencePrice, uint decimal);
250     function getOrderPrice(
251         address sellAsset,
252         address buyAsset,
253         uint sellQuantity,
254         uint buyQuantity
255     ) view returns (uint orderPrice);
256     function existsPriceOnAssetPair(address sellAsset, address buyAsset) view returns (bool isExistent);
257 }
258 
259 contract PriceFeed is PriceFeedInterface, AssetRegistrar, DSMath {
260 
261     // FIELDS
262 
263     // Constructor fields
264     address public QUOTE_ASSET; // Asset of a portfolio against which all other assets are priced
265     /// Note: Interval is purely self imposed and for information purposes only
266     uint public INTERVAL; // Frequency of updates in seconds
267     uint public VALIDITY; // Time in seconds for which data is considered recent
268     uint updateId;        // Update counter for this pricefeed; used as a check during investment
269 
270     // METHODS
271 
272     // CONSTRUCTOR
273 
274     /// @dev Define and register a quote asset against which all prices are measured/based against
275     /// @param ofQuoteAsset Address of quote asset
276     /// @param quoteAssetName Name of quote asset
277     /// @param quoteAssetSymbol Symbol for quote asset
278     /// @param quoteAssetDecimals Decimal places for quote asset
279     /// @param quoteAssetUrl URL related to quote asset
280     /// @param quoteAssetIpfsHash IPFS hash associated with quote asset
281     /// @param quoteAssetChainId Chain ID associated with quote asset (e.g. "1" for main Ethereum network)
282     /// @param quoteAssetBreakIn Break-in address for the quote asset
283     /// @param quoteAssetBreakOut Break-out address for the quote asset
284     /// @param interval Number of seconds between pricefeed updates (this interval is not enforced on-chain, but should be followed by the datafeed maintainer)
285     /// @param validity Number of seconds that datafeed update information is valid for
286     function PriceFeed(
287         address ofQuoteAsset, // Inital entry in asset registrar contract is Melon (QUOTE_ASSET)
288         string quoteAssetName,
289         string quoteAssetSymbol,
290         uint quoteAssetDecimals,
291         string quoteAssetUrl,
292         string quoteAssetIpfsHash,
293         bytes32 quoteAssetChainId,
294         address quoteAssetBreakIn,
295         address quoteAssetBreakOut,
296         uint interval,
297         uint validity
298     ) {
299         QUOTE_ASSET = ofQuoteAsset;
300         register(
301             QUOTE_ASSET,
302             quoteAssetName,
303             quoteAssetSymbol,
304             quoteAssetDecimals,
305             quoteAssetUrl,
306             quoteAssetIpfsHash,
307             quoteAssetChainId,
308             quoteAssetBreakIn,
309             quoteAssetBreakOut
310         );
311         INTERVAL = interval;
312         VALIDITY = validity;
313     }
314 
315     // PUBLIC METHODS
316 
317     /// @dev Only Owner; Same sized input arrays
318     /// @dev Updates price of asset relative to QUOTE_ASSET
319     /** Ex:
320      *  Let QUOTE_ASSET == MLN (base units), let asset == EUR-T,
321      *  let Value of 1 EUR-T := 1 EUR == 0.080456789 MLN, hence price 0.080456789 MLN / EUR-T
322      *  and let EUR-T decimals == 8.
323      *  Input would be: information[EUR-T].price = 8045678 [MLN/ (EUR-T * 10**8)]
324      */
325     /// @param ofAssets list of asset addresses
326     /// @param newPrices list of prices for each of the assets
327     function update(address[] ofAssets, uint[] newPrices)
328         pre_cond(isOwner())
329         pre_cond(ofAssets.length == newPrices.length)
330     {
331         updateId += 1;
332         for (uint i = 0; i < ofAssets.length; ++i) {
333             require(information[ofAssets[i]].timestamp != now); // prevent two updates in one block
334             require(information[ofAssets[i]].exists);
335             information[ofAssets[i]].timestamp = now;
336             information[ofAssets[i]].price = newPrices[i];
337         }
338         PriceUpdated(now);
339     }
340 
341     // PUBLIC VIEW METHODS
342 
343     // Get pricefeed specific information
344     function getQuoteAsset() view returns (address) { return QUOTE_ASSET; }
345     function getInterval() view returns (uint) { return INTERVAL; }
346     function getValidity() view returns (uint) { return VALIDITY; }
347     function getLastUpdateId() view returns (uint) { return updateId; }
348 
349     /// @notice Whether price of asset has been updated less than VALIDITY seconds ago
350     /// @param ofAsset Existend asset in AssetRegistrar
351     /// @return isRecent Price information ofAsset is recent
352     function hasRecentPrice(address ofAsset)
353         view
354         pre_cond(information[ofAsset].exists)
355         returns (bool isRecent)
356     {
357         return sub(now, information[ofAsset].timestamp) <= VALIDITY;
358     }
359 
360     /// @notice Whether prices of assets have been updated less than VALIDITY seconds ago
361     /// @param ofAssets All asstes existend in AssetRegistrar
362     /// @return isRecent Price information ofAssets array is recent
363     function hasRecentPrices(address[] ofAssets)
364         view
365         returns (bool areRecent)
366     {
367         for (uint i; i < ofAssets.length; i++) {
368             if (!hasRecentPrice(ofAssets[i])) {
369                 return false;
370             }
371         }
372         return true;
373     }
374 
375     /**
376     @notice Gets price of an asset multiplied by ten to the power of assetDecimals
377     @dev Asset has been registered
378     @param ofAsset Asset for which price should be returned
379     @return {
380       "isRecent": "Whether the returned price is valid (as defined by VALIDITY)",
381       "price": "Price formatting: mul(exchangePrice, 10 ** decimal), to avoid floating numbers",
382       "decimal": "Decimal, order of magnitude of precision, of the Asset as in ERC223 token standard",
383     }
384     */
385     function getPrice(address ofAsset)
386         view
387         returns (bool isRecent, uint price, uint decimal)
388     {
389         return (
390             hasRecentPrice(ofAsset),
391             information[ofAsset].price,
392             information[ofAsset].decimal
393         );
394     }
395 
396     /**
397     @notice Price of a registered asset in format (bool areRecent, uint[] prices, uint[] decimals)
398     @dev Convention for price formatting: mul(price, 10 ** decimal), to avoid floating numbers
399     @param ofAssets Assets for which prices should be returned
400     @return {
401         "areRecent":    "Whether all of the prices are fresh, given VALIDITY interval",
402         "prices":       "Array of prices",
403         "decimals":     "Array of decimal places for returned assets"
404     }
405     */
406     function getPrices(address[] ofAssets)
407         view
408         returns (bool areRecent, uint[] prices, uint[] decimals)
409     {
410         areRecent = true;
411         for (uint i; i < ofAssets.length; i++) {
412             var (isRecent, price, decimal) = getPrice(ofAssets[i]);
413             if (!isRecent) {
414                 areRecent = false;
415             }
416             prices[i] = price;
417             decimals[i] = decimal;
418         }
419     }
420 
421     /**
422     @notice Gets inverted price of an asset
423     @dev Asset has been initialised and its price is non-zero
424     @dev Existing price ofAssets quoted in QUOTE_ASSET (convention)
425     @param ofAsset Asset for which inverted price should be return
426     @return {
427         "isRecent": "Whether the price is fresh, given VALIDITY interval",
428         "invertedPrice": "Price based (instead of quoted) against QUOTE_ASSET",
429         "decimal": "Decimal places for this asset"
430     }
431     */
432     function getInvertedPrice(address ofAsset)
433         view
434         returns (bool isRecent, uint invertedPrice, uint decimal)
435     {
436         // inputPrice quoted in QUOTE_ASSET and multiplied by 10 ** assetDecimal
437         var (isInvertedRecent, inputPrice, assetDecimal) = getPrice(ofAsset);
438 
439         // outputPrice based in QUOTE_ASSET and multiplied by 10 ** quoteDecimal
440         uint quoteDecimal = getDecimals(QUOTE_ASSET);
441 
442         return (
443             isInvertedRecent,
444             mul(10 ** uint(quoteDecimal), 10 ** uint(assetDecimal)) / inputPrice,
445             quoteDecimal
446         );
447     }
448 
449     /**
450     @notice Gets reference price of an asset pair
451     @dev One of the address is equal to quote asset
452     @dev either ofBase == QUOTE_ASSET or ofQuote == QUOTE_ASSET
453     @param ofBase Address of base asset
454     @param ofQuote Address of quote asset
455     @return {
456         "isRecent": "Whether the price is fresh, given VALIDITY interval",
457         "referencePrice": "Reference price",
458         "decimal": "Decimal places for this asset"
459     }
460     */
461     function getReferencePrice(address ofBase, address ofQuote)
462         view
463         returns (bool isRecent, uint referencePrice, uint decimal)
464     {
465         if (getQuoteAsset() == ofQuote) {
466             (isRecent, referencePrice, decimal) = getPrice(ofBase);
467         } else if (getQuoteAsset() == ofBase) {
468             (isRecent, referencePrice, decimal) = getInvertedPrice(ofQuote);
469         } else {
470             revert(); // no suitable reference price available
471         }
472     }
473 
474     /// @notice Gets price of Order
475     /// @param sellAsset Address of the asset to be sold
476     /// @param buyAsset Address of the asset to be bought
477     /// @param sellQuantity Quantity in base units being sold of sellAsset
478     /// @param buyQuantity Quantity in base units being bought of buyAsset
479     /// @return orderPrice Price as determined by an order
480     function getOrderPrice(
481         address sellAsset,
482         address buyAsset,
483         uint sellQuantity,
484         uint buyQuantity
485     )
486         view
487         returns (uint orderPrice)
488     {
489         return mul(buyQuantity, 10 ** uint(getDecimals(sellAsset))) / sellQuantity;
490     }
491 
492     /// @notice Checks whether data exists for a given asset pair
493     /// @dev Prices are only upated against QUOTE_ASSET
494     /// @param sellAsset Asset for which check to be done if data exists
495     /// @param buyAsset Asset for which check to be done if data exists
496     /// @return Whether assets exist for given asset pair
497     function existsPriceOnAssetPair(address sellAsset, address buyAsset)
498         view
499         returns (bool isExistent)
500     {
501         return
502             hasRecentPrice(sellAsset) && // Is tradable asset (TODO cleaner) and datafeed delivering data
503             hasRecentPrice(buyAsset) && // Is tradable asset (TODO cleaner) and datafeed delivering data
504             (buyAsset == QUOTE_ASSET || sellAsset == QUOTE_ASSET) && // One asset must be QUOTE_ASSET
505             (buyAsset != QUOTE_ASSET || sellAsset != QUOTE_ASSET); // Pair must consists of diffrent assets
506     }
507 }