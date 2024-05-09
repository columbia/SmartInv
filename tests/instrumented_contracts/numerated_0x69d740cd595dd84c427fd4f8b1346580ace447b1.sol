1 /*
2 
3     Copyright 2019 The Hydro Protocol Foundation
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9         http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 
17 */
18 
19 pragma solidity 0.5.8;
20 pragma experimental ABIEncoderV2;
21 
22 interface IEth2Dai{
23     function isClosed()
24         external
25         view
26         returns (bool);
27 
28     function buyEnabled()
29         external
30         view
31         returns (bool);
32 
33     function matchingEnabled()
34         external
35         view
36         returns (bool);
37 
38     function getBuyAmount(
39         address buy_gem,
40         address pay_gem,
41         uint256 pay_amt
42     )
43         external
44         view
45         returns (uint256);
46 
47     function getPayAmount(
48         address pay_gem,
49         address buy_gem,
50         uint256 buy_amt
51     )
52         external
53         view
54         returns (uint256);
55 }
56 
57 interface IMakerDaoOracle{
58     function peek()
59         external
60         view
61         returns (bytes32, bool);
62 }
63 
64 interface IStandardToken {
65     function transfer(
66         address _to,
67         uint256 _amount
68     )
69         external
70         returns (bool);
71 
72     function balanceOf(
73         address _owner)
74         external
75         view
76         returns (uint256 balance);
77 
78     function transferFrom(
79         address _from,
80         address _to,
81         uint256 _amount
82     )
83         external
84         returns (bool);
85 
86     function approve(
87         address _spender,
88         uint256 _amount
89     )
90         external
91         returns (bool);
92 
93     function allowance(
94         address _owner,
95         address _spender
96     )
97         external
98         view
99         returns (uint256);
100 }
101 
102 contract Ownable {
103     address private _owner;
104 
105     event OwnershipTransferred(
106         address indexed previousOwner,
107         address indexed newOwner
108     );
109 
110     /** @dev The Ownable constructor sets the original `owner` of the contract to the sender account. */
111     constructor()
112         internal
113     {
114         _owner = msg.sender;
115         emit OwnershipTransferred(address(0), _owner);
116     }
117 
118     /** @return the address of the owner. */
119     function owner()
120         public
121         view
122         returns(address)
123     {
124         return _owner;
125     }
126 
127     /** @dev Throws if called by any account other than the owner. */
128     modifier onlyOwner() {
129         require(isOwner(), "NOT_OWNER");
130         _;
131     }
132 
133     /** @return true if `msg.sender` is the owner of the contract. */
134     function isOwner()
135         public
136         view
137         returns(bool)
138     {
139         return msg.sender == _owner;
140     }
141 
142     /** @dev Allows the current owner to relinquish control of the contract.
143      * @notice Renouncing to ownership will leave the contract without an owner.
144      * It will not be possible to call the functions with the `onlyOwner`
145      * modifier anymore.
146      */
147     function renounceOwnership()
148         public
149         onlyOwner
150     {
151         emit OwnershipTransferred(_owner, address(0));
152         _owner = address(0);
153     }
154 
155     /** @dev Allows the current owner to transfer control of the contract to a newOwner.
156      * @param newOwner The address to transfer ownership to.
157      */
158     function transferOwnership(
159         address newOwner
160     )
161         public
162         onlyOwner
163     {
164         require(newOwner != address(0), "INVALID_OWNER");
165         emit OwnershipTransferred(_owner, newOwner);
166         _owner = newOwner;
167     }
168 }
169 
170 library SafeMath {
171 
172     // Multiplies two numbers, reverts on overflow.
173     function mul(
174         uint256 a,
175         uint256 b
176     )
177         internal
178         pure
179         returns (uint256)
180     {
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "MUL_ERROR");
187 
188         return c;
189     }
190 
191     // Integer division of two numbers truncating the quotient, reverts on division by zero.
192     function div(
193         uint256 a,
194         uint256 b
195     )
196         internal
197         pure
198         returns (uint256)
199     {
200         require(b > 0, "DIVIDING_ERROR");
201         return a / b;
202     }
203 
204     function divCeil(
205         uint256 a,
206         uint256 b
207     )
208         internal
209         pure
210         returns (uint256)
211     {
212         uint256 quotient = div(a, b);
213         uint256 remainder = a - quotient * b;
214         if (remainder > 0) {
215             return quotient + 1;
216         } else {
217             return quotient;
218         }
219     }
220 
221     // Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
222     function sub(
223         uint256 a,
224         uint256 b
225     )
226         internal
227         pure
228         returns (uint256)
229     {
230         require(b <= a, "SUB_ERROR");
231         return a - b;
232     }
233 
234     function sub(
235         int256 a,
236         uint256 b
237     )
238         internal
239         pure
240         returns (int256)
241     {
242         require(b <= 2**255-1, "INT256_SUB_ERROR");
243         int256 c = a - int256(b);
244         require(c <= a, "INT256_SUB_ERROR");
245         return c;
246     }
247 
248     // Adds two numbers, reverts on overflow.
249     function add(
250         uint256 a,
251         uint256 b
252     )
253         internal
254         pure
255         returns (uint256)
256     {
257         uint256 c = a + b;
258         require(c >= a, "ADD_ERROR");
259         return c;
260     }
261 
262     function add(
263         int256 a,
264         uint256 b
265     )
266         internal
267         pure
268         returns (int256)
269     {
270         require(b <= 2**255 - 1, "INT256_ADD_ERROR");
271         int256 c = a + int256(b);
272         require(c >= a, "INT256_ADD_ERROR");
273         return c;
274     }
275 
276     // Divides two numbers and returns the remainder (unsigned integer modulo), reverts when dividing by zero.
277     function mod(
278         uint256 a,
279         uint256 b
280     )
281         internal
282         pure
283         returns (uint256)
284     {
285         require(b != 0, "MOD_ERROR");
286         return a % b;
287     }
288 
289     /**
290      * Check the amount of precision lost by calculating multiple * (numerator / denominator). To
291      * do this, we check the remainder and make sure it's proportionally less than 0.1%. So we have:
292      *
293      *     ((numerator * multiple) % denominator)     1
294      *     -------------------------------------- < ----
295      *              numerator * multiple            1000
296      *
297      * To avoid further division, we can move the denominators to the other sides and we get:
298      *
299      *     ((numerator * multiple) % denominator) * 1000 < numerator * multiple
300      *
301      * Since we want to return true if there IS a rounding error, we simply flip the sign and our
302      * final equation becomes:
303      *
304      *     ((numerator * multiple) % denominator) * 1000 >= numerator * multiple
305      *
306      * @param numerator The numerator of the proportion
307      * @param denominator The denominator of the proportion
308      * @param multiple The amount we want a proportion of
309      * @return Boolean indicating if there is a rounding error when calculating the proportion
310      */
311     function isRoundingError(
312         uint256 numerator,
313         uint256 denominator,
314         uint256 multiple
315     )
316         internal
317         pure
318         returns (bool)
319     {
320         // numerator.mul(multiple).mod(denominator).mul(1000) >= numerator.mul(multiple)
321         return mul(mod(mul(numerator, multiple), denominator), 1000) >= mul(numerator, multiple);
322     }
323 
324     /**
325      * Takes an amount (multiple) and calculates a proportion of it given a numerator/denominator
326      * pair of values. The final value will be rounded down to the nearest integer value.
327      *
328      * This function will revert the transaction if rounding the final value down would lose more
329      * than 0.1% precision.
330      *
331      * @param numerator The numerator of the proportion
332      * @param denominator The denominator of the proportion
333      * @param multiple The amount we want a proportion of
334      * @return The final proportion of multiple rounded down
335      */
336     function getPartialAmountFloor(
337         uint256 numerator,
338         uint256 denominator,
339         uint256 multiple
340     )
341         internal
342         pure
343         returns (uint256)
344     {
345         require(!isRoundingError(numerator, denominator, multiple), "ROUNDING_ERROR");
346         // numerator.mul(multiple).div(denominator)
347         return div(mul(numerator, multiple), denominator);
348     }
349 
350     /**
351      * Returns the smaller integer of the two passed in.
352      *
353      * @param a Unsigned integer
354      * @param b Unsigned integer
355      * @return The smaller of the two integers
356      */
357     function min(
358         uint256 a,
359         uint256 b
360     )
361         internal
362         pure
363         returns (uint256)
364     {
365         return a < b ? a : b;
366     }
367 }
368 
369 contract DaiPriceOracle is Ownable{
370     using SafeMath for uint256;
371 
372     uint256 public price;
373 
374     uint256 constant ONE = 10**18;
375 
376     IMakerDaoOracle public constant makerDaoOracle = IMakerDaoOracle(0x729D19f657BD0614b4985Cf1D82531c67569197B);
377     IStandardToken public constant DAI = IStandardToken(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
378     IEth2Dai public constant Eth2Dai = IEth2Dai(0x39755357759cE0d7f32dC8dC45414CCa409AE24e);
379 
380     address public constant UNISWAP = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14;
381     address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
382     uint256 public constant eth2daiETHAmount = 10 ether;
383     uint256 public constant eth2daiMaxSpread = 2 * ONE / 100; // 2.00%
384     uint256 public constant uniswapMinETHAmount = 2000 ether;
385 
386     event UpdatePrice(uint256 newPrice);
387 
388     uint256 public minPrice;
389     uint256 public maxPrice;
390 
391     constructor (
392         uint256 _minPrice,
393         uint256 _maxPrice
394     )
395         public
396     {
397         require(_minPrice <= _maxPrice, "WRONG_PARAMS");
398         minPrice = _minPrice;
399         maxPrice = _maxPrice;
400     }
401 
402     function getPrice(
403         address asset
404     )
405         external
406         view
407         returns (uint256)
408     {
409         require(asset == address(DAI), "ASSET_NOT_MATCH");
410         return price;
411     }
412 
413     function adminSetPrice(
414         uint256 _price
415     )
416         external
417         onlyOwner
418     {
419         if (!updatePrice()){
420             price = _price;
421         }
422 
423         emit UpdatePrice(price);
424     }
425 
426     function adminSetParams(
427         uint256 _minPrice,
428         uint256 _maxPrice
429     )
430         external
431         onlyOwner
432     {
433         require(_minPrice <= _maxPrice, "WRONG_PARAMS");
434         minPrice = _minPrice;
435         maxPrice = _maxPrice;
436     }
437 
438     function updatePrice()
439         public
440         onlyOwner
441         returns (bool)
442     {
443         uint256 _price = peek();
444 
445         if (_price == 0) {
446             return false;
447         }
448 
449         if (_price == price) {
450             return true;
451         }
452 
453         if (_price > maxPrice) {
454             _price = maxPrice;
455         } else if (_price < minPrice) {
456             _price = minPrice;
457         }
458 
459         price = _price;
460         emit UpdatePrice(price);
461 
462         return true;
463     }
464 
465     function peek()
466         public
467         view
468         returns (uint256 _price)
469     {
470         uint256 makerDaoPrice = getMakerDaoPrice();
471 
472         if (makerDaoPrice == 0) {
473             return _price;
474         }
475 
476         uint256 eth2daiPrice = getEth2DaiPrice();
477 
478         if (eth2daiPrice > 0) {
479             _price = makerDaoPrice.mul(ONE).div(eth2daiPrice);
480             return _price;
481         }
482 
483         uint256 uniswapPrice = getUniswapPrice();
484 
485         if (uniswapPrice > 0) {
486             _price = makerDaoPrice.mul(ONE).div(uniswapPrice);
487             return _price;
488         }
489 
490         return _price;
491     }
492 
493     function getEth2DaiPrice()
494         public
495         view
496         returns (uint256)
497     {
498         if (Eth2Dai.isClosed() || !Eth2Dai.buyEnabled() || !Eth2Dai.matchingEnabled()) {
499             return 0;
500         }
501 
502         uint256 bidDai = Eth2Dai.getBuyAmount(address(DAI), WETH, eth2daiETHAmount);
503         uint256 askDai = Eth2Dai.getPayAmount(address(DAI), WETH, eth2daiETHAmount);
504 
505         uint256 bidPrice = bidDai.mul(ONE).div(eth2daiETHAmount);
506         uint256 askPrice = askDai.mul(ONE).div(eth2daiETHAmount);
507 
508         uint256 spread = askPrice.mul(ONE).div(bidPrice).sub(ONE);
509 
510         if (spread > eth2daiMaxSpread) {
511             return 0;
512         } else {
513             return bidPrice.add(askPrice).div(2);
514         }
515     }
516 
517     function getUniswapPrice()
518         public
519         view
520         returns (uint256)
521     {
522         uint256 ethAmount = UNISWAP.balance;
523         uint256 daiAmount = DAI.balanceOf(UNISWAP);
524         uint256 uniswapPrice = daiAmount.mul(10**18).div(ethAmount);
525 
526         if (ethAmount < uniswapMinETHAmount) {
527             return 0;
528         } else {
529             return uniswapPrice;
530         }
531     }
532 
533     function getMakerDaoPrice()
534         public
535         view
536         returns (uint256)
537     {
538         (bytes32 value, bool has) = makerDaoOracle.peek();
539 
540         if (has) {
541             return uint256(value);
542         } else {
543             return 0;
544         }
545     }
546 }