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
22 library Decimal {
23     using SafeMath for uint256;
24 
25     uint256 constant BASE = 10**18;
26 
27     function one()
28         internal
29         pure
30         returns (uint256)
31     {
32         return BASE;
33     }
34 
35     function onePlus(
36         uint256 d
37     )
38         internal
39         pure
40         returns (uint256)
41     {
42         return d.add(BASE);
43     }
44 
45     function mulFloor(
46         uint256 target,
47         uint256 d
48     )
49         internal
50         pure
51         returns (uint256)
52     {
53         return target.mul(d) / BASE;
54     }
55 
56     function mulCeil(
57         uint256 target,
58         uint256 d
59     )
60         internal
61         pure
62         returns (uint256)
63     {
64         return target.mul(d).divCeil(BASE);
65     }
66 
67     function divFloor(
68         uint256 target,
69         uint256 d
70     )
71         internal
72         pure
73         returns (uint256)
74     {
75         return target.mul(BASE).div(d);
76     }
77 
78     function divCeil(
79         uint256 target,
80         uint256 d
81     )
82         internal
83         pure
84         returns (uint256)
85     {
86         return target.mul(BASE).divCeil(d);
87     }
88 }
89 
90 contract Ownable {
91     address private _owner;
92 
93     event OwnershipTransferred(
94         address indexed previousOwner,
95         address indexed newOwner
96     );
97 
98     /** @dev The Ownable constructor sets the original `owner` of the contract to the sender account. */
99     constructor()
100         internal
101     {
102         _owner = msg.sender;
103         emit OwnershipTransferred(address(0), _owner);
104     }
105 
106     /** @return the address of the owner. */
107     function owner()
108         public
109         view
110         returns(address)
111     {
112         return _owner;
113     }
114 
115     /** @dev Throws if called by any account other than the owner. */
116     modifier onlyOwner() {
117         require(isOwner(), "NOT_OWNER");
118         _;
119     }
120 
121     /** @return true if `msg.sender` is the owner of the contract. */
122     function isOwner()
123         public
124         view
125         returns(bool)
126     {
127         return msg.sender == _owner;
128     }
129 
130     /** @dev Allows the current owner to relinquish control of the contract.
131      * @notice Renouncing to ownership will leave the contract without an owner.
132      * It will not be possible to call the functions with the `onlyOwner`
133      * modifier anymore.
134      */
135     function renounceOwnership()
136         public
137         onlyOwner
138     {
139         emit OwnershipTransferred(_owner, address(0));
140         _owner = address(0);
141     }
142 
143     /** @dev Allows the current owner to transfer control of the contract to a newOwner.
144      * @param newOwner The address to transfer ownership to.
145      */
146     function transferOwnership(
147         address newOwner
148     )
149         public
150         onlyOwner
151     {
152         require(newOwner != address(0), "INVALID_OWNER");
153         emit OwnershipTransferred(_owner, newOwner);
154         _owner = newOwner;
155     }
156 }
157 
158 library SafeMath {
159 
160     // Multiplies two numbers, reverts on overflow.
161     function mul(
162         uint256 a,
163         uint256 b
164     )
165         internal
166         pure
167         returns (uint256)
168     {
169         if (a == 0) {
170             return 0;
171         }
172 
173         uint256 c = a * b;
174         require(c / a == b, "MUL_ERROR");
175 
176         return c;
177     }
178 
179     // Integer division of two numbers truncating the quotient, reverts on division by zero.
180     function div(
181         uint256 a,
182         uint256 b
183     )
184         internal
185         pure
186         returns (uint256)
187     {
188         require(b > 0, "DIVIDING_ERROR");
189         return a / b;
190     }
191 
192     function divCeil(
193         uint256 a,
194         uint256 b
195     )
196         internal
197         pure
198         returns (uint256)
199     {
200         uint256 quotient = div(a, b);
201         uint256 remainder = a - quotient * b;
202         if (remainder > 0) {
203             return quotient + 1;
204         } else {
205             return quotient;
206         }
207     }
208 
209     // Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
210     function sub(
211         uint256 a,
212         uint256 b
213     )
214         internal
215         pure
216         returns (uint256)
217     {
218         require(b <= a, "SUB_ERROR");
219         return a - b;
220     }
221 
222     function sub(
223         int256 a,
224         uint256 b
225     )
226         internal
227         pure
228         returns (int256)
229     {
230         require(b <= 2**255-1, "INT256_SUB_ERROR");
231         int256 c = a - int256(b);
232         require(c <= a, "INT256_SUB_ERROR");
233         return c;
234     }
235 
236     // Adds two numbers, reverts on overflow.
237     function add(
238         uint256 a,
239         uint256 b
240     )
241         internal
242         pure
243         returns (uint256)
244     {
245         uint256 c = a + b;
246         require(c >= a, "ADD_ERROR");
247         return c;
248     }
249 
250     function add(
251         int256 a,
252         uint256 b
253     )
254         internal
255         pure
256         returns (int256)
257     {
258         require(b <= 2**255 - 1, "INT256_ADD_ERROR");
259         int256 c = a + int256(b);
260         require(c >= a, "INT256_ADD_ERROR");
261         return c;
262     }
263 
264     // Divides two numbers and returns the remainder (unsigned integer modulo), reverts when dividing by zero.
265     function mod(
266         uint256 a,
267         uint256 b
268     )
269         internal
270         pure
271         returns (uint256)
272     {
273         require(b != 0, "MOD_ERROR");
274         return a % b;
275     }
276 
277     /**
278      * Check the amount of precision lost by calculating multiple * (numerator / denominator). To
279      * do this, we check the remainder and make sure it's proportionally less than 0.1%. So we have:
280      *
281      *     ((numerator * multiple) % denominator)     1
282      *     -------------------------------------- < ----
283      *              numerator * multiple            1000
284      *
285      * To avoid further division, we can move the denominators to the other sides and we get:
286      *
287      *     ((numerator * multiple) % denominator) * 1000 < numerator * multiple
288      *
289      * Since we want to return true if there IS a rounding error, we simply flip the sign and our
290      * final equation becomes:
291      *
292      *     ((numerator * multiple) % denominator) * 1000 >= numerator * multiple
293      *
294      * @param numerator The numerator of the proportion
295      * @param denominator The denominator of the proportion
296      * @param multiple The amount we want a proportion of
297      * @return Boolean indicating if there is a rounding error when calculating the proportion
298      */
299     function isRoundingError(
300         uint256 numerator,
301         uint256 denominator,
302         uint256 multiple
303     )
304         internal
305         pure
306         returns (bool)
307     {
308         // numerator.mul(multiple).mod(denominator).mul(1000) >= numerator.mul(multiple)
309         return mul(mod(mul(numerator, multiple), denominator), 1000) >= mul(numerator, multiple);
310     }
311 
312     /**
313      * Takes an amount (multiple) and calculates a proportion of it given a numerator/denominator
314      * pair of values. The final value will be rounded down to the nearest integer value.
315      *
316      * This function will revert the transaction if rounding the final value down would lose more
317      * than 0.1% precision.
318      *
319      * @param numerator The numerator of the proportion
320      * @param denominator The denominator of the proportion
321      * @param multiple The amount we want a proportion of
322      * @return The final proportion of multiple rounded down
323      */
324     function getPartialAmountFloor(
325         uint256 numerator,
326         uint256 denominator,
327         uint256 multiple
328     )
329         internal
330         pure
331         returns (uint256)
332     {
333         require(!isRoundingError(numerator, denominator, multiple), "ROUNDING_ERROR");
334         // numerator.mul(multiple).div(denominator)
335         return div(mul(numerator, multiple), denominator);
336     }
337 
338     /**
339      * Returns the smaller integer of the two passed in.
340      *
341      * @param a Unsigned integer
342      * @param b Unsigned integer
343      * @return The smaller of the two integers
344      */
345     function min(
346         uint256 a,
347         uint256 b
348     )
349         internal
350         pure
351         returns (uint256)
352     {
353         return a < b ? a : b;
354     }
355 }
356 
357 contract FeedPriceOracle is Ownable {
358     using SafeMath for uint256;
359 
360     address[] public assets;
361     uint256 public price;
362     uint256 public lastBlockNumber;
363     uint256 public validBlockNumber;
364     uint256 public maxChangeRate;
365     uint256 public minPrice;
366     uint256 public maxPrice;
367 
368     event PriceFeed(
369         uint256 price,
370         uint256 blockNumber
371     );
372 
373     constructor (
374         address[] memory _assets,
375         uint256 _validBlockNumber,
376         uint256 _maxChangeRate,
377         uint256 _minPrice,
378         uint256 _maxPrice
379     )
380         public
381     {
382         assets = _assets;
383 
384         setParams(
385             _validBlockNumber,
386             _maxChangeRate,
387             _minPrice,
388             _maxPrice
389         );
390     }
391 
392     function setParams(
393         uint256 _validBlockNumber,
394         uint256 _maxChangeRate,
395         uint256 _minPrice,
396         uint256 _maxPrice
397     )
398         public
399         onlyOwner
400     {
401         require(_minPrice <= _maxPrice, "MIN_PRICE_MUST_LESS_OR_EQUAL_THAN_MAX_PRICE");
402         validBlockNumber = _validBlockNumber;
403         maxChangeRate = _maxChangeRate;
404         minPrice = _minPrice;
405         maxPrice = _maxPrice;
406     }
407 
408     function feed(
409         uint256 newPrice
410     )
411         external
412         onlyOwner
413     {
414         require(newPrice > 0, "PRICE_MUST_GREATER_THAN_0");
415         require(lastBlockNumber < block.number, "BLOCKNUMBER_WRONG");
416         require(newPrice <= maxPrice, "PRICE_EXCEED_MAX_LIMIT");
417         require(newPrice >= minPrice, "PRICE_EXCEED_MIN_LIMIT");
418 
419         if (price > 0) {
420             uint256 changeRate = Decimal.divFloor(newPrice, price);
421             if (changeRate > Decimal.one()) {
422                 changeRate = changeRate.sub(Decimal.one());
423             } else {
424                 changeRate = Decimal.one().sub(changeRate);
425             }
426             require(changeRate <= maxChangeRate, "PRICE_CHANGE_RATE_EXCEED");
427         }
428 
429         price = newPrice;
430         lastBlockNumber = block.number;
431 
432         emit PriceFeed(price, lastBlockNumber);
433     }
434 
435     function isValidAsset(
436         address asset
437     )
438         private
439         view
440         returns (bool)
441     {
442         for (uint256 i = 0; i < assets.length; i++ ) {
443             if (assets[i] == asset) {
444                 return true;
445             }
446         }
447         return false;
448     }
449 
450     function getPrice(
451         address _asset
452     )
453         external
454         view
455         returns (uint256)
456     {
457         require(isValidAsset(_asset), "ASSET_NOT_MATCH");
458         require(block.number.sub(lastBlockNumber) <= validBlockNumber, "PRICE_EXPIRED");
459         return price;
460     }
461 
462 }