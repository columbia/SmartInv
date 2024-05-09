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
21 library Decimal {
22     using SafeMath for uint256;
23 
24     uint256 constant BASE = 10**18;
25 
26     function one()
27         internal
28         pure
29         returns (uint256)
30     {
31         return BASE;
32     }
33 
34     function onePlus(
35         uint256 d
36     )
37         internal
38         pure
39         returns (uint256)
40     {
41         return d.add(BASE);
42     }
43 
44     function mulFloor(
45         uint256 target,
46         uint256 d
47     )
48         internal
49         pure
50         returns (uint256)
51     {
52         return target.mul(d) / BASE;
53     }
54 
55     function mulCeil(
56         uint256 target,
57         uint256 d
58     )
59         internal
60         pure
61         returns (uint256)
62     {
63         return target.mul(d).divCeil(BASE);
64     }
65 
66     function divFloor(
67         uint256 target,
68         uint256 d
69     )
70         internal
71         pure
72         returns (uint256)
73     {
74         return target.mul(BASE).div(d);
75     }
76 
77     function divCeil(
78         uint256 target,
79         uint256 d
80     )
81         internal
82         pure
83         returns (uint256)
84     {
85         return target.mul(BASE).divCeil(d);
86     }
87 }
88 
89 contract Ownable {
90     address private _owner;
91 
92     event OwnershipTransferred(
93         address indexed previousOwner,
94         address indexed newOwner
95     );
96 
97     /** @dev The Ownable constructor sets the original `owner` of the contract to the sender account. */
98     constructor()
99         internal
100     {
101         _owner = msg.sender;
102         emit OwnershipTransferred(address(0), _owner);
103     }
104 
105     /** @return the address of the owner. */
106     function owner()
107         public
108         view
109         returns(address)
110     {
111         return _owner;
112     }
113 
114     /** @dev Throws if called by any account other than the owner. */
115     modifier onlyOwner() {
116         require(isOwner(), "NOT_OWNER");
117         _;
118     }
119 
120     /** @return true if `msg.sender` is the owner of the contract. */
121     function isOwner()
122         public
123         view
124         returns(bool)
125     {
126         return msg.sender == _owner;
127     }
128 
129     /** @dev Allows the current owner to relinquish control of the contract.
130      * @notice Renouncing to ownership will leave the contract without an owner.
131      * It will not be possible to call the functions with the `onlyOwner`
132      * modifier anymore.
133      */
134     function renounceOwnership()
135         public
136         onlyOwner
137     {
138         emit OwnershipTransferred(_owner, address(0));
139         _owner = address(0);
140     }
141 
142     /** @dev Allows the current owner to transfer control of the contract to a newOwner.
143      * @param newOwner The address to transfer ownership to.
144      */
145     function transferOwnership(
146         address newOwner
147     )
148         public
149         onlyOwner
150     {
151         require(newOwner != address(0), "INVALID_OWNER");
152         emit OwnershipTransferred(_owner, newOwner);
153         _owner = newOwner;
154     }
155 }
156 
157 library SafeMath {
158 
159     // Multiplies two numbers, reverts on overflow.
160     function mul(
161         uint256 a,
162         uint256 b
163     )
164         internal
165         pure
166         returns (uint256)
167     {
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "MUL_ERROR");
174 
175         return c;
176     }
177 
178     // Integer division of two numbers truncating the quotient, reverts on division by zero.
179     function div(
180         uint256 a,
181         uint256 b
182     )
183         internal
184         pure
185         returns (uint256)
186     {
187         require(b > 0, "DIVIDING_ERROR");
188         return a / b;
189     }
190 
191     function divCeil(
192         uint256 a,
193         uint256 b
194     )
195         internal
196         pure
197         returns (uint256)
198     {
199         uint256 quotient = div(a, b);
200         uint256 remainder = a - quotient * b;
201         if (remainder > 0) {
202             return quotient + 1;
203         } else {
204             return quotient;
205         }
206     }
207 
208     // Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
209     function sub(
210         uint256 a,
211         uint256 b
212     )
213         internal
214         pure
215         returns (uint256)
216     {
217         require(b <= a, "SUB_ERROR");
218         return a - b;
219     }
220 
221     function sub(
222         int256 a,
223         uint256 b
224     )
225         internal
226         pure
227         returns (int256)
228     {
229         require(b <= 2**255-1, "INT256_SUB_ERROR");
230         int256 c = a - int256(b);
231         require(c <= a, "INT256_SUB_ERROR");
232         return c;
233     }
234 
235     // Adds two numbers, reverts on overflow.
236     function add(
237         uint256 a,
238         uint256 b
239     )
240         internal
241         pure
242         returns (uint256)
243     {
244         uint256 c = a + b;
245         require(c >= a, "ADD_ERROR");
246         return c;
247     }
248 
249     function add(
250         int256 a,
251         uint256 b
252     )
253         internal
254         pure
255         returns (int256)
256     {
257         require(b <= 2**255 - 1, "INT256_ADD_ERROR");
258         int256 c = a + int256(b);
259         require(c >= a, "INT256_ADD_ERROR");
260         return c;
261     }
262 
263     // Divides two numbers and returns the remainder (unsigned integer modulo), reverts when dividing by zero.
264     function mod(
265         uint256 a,
266         uint256 b
267     )
268         internal
269         pure
270         returns (uint256)
271     {
272         require(b != 0, "MOD_ERROR");
273         return a % b;
274     }
275 
276     /**
277      * Check the amount of precision lost by calculating multiple * (numerator / denominator). To
278      * do this, we check the remainder and make sure it's proportionally less than 0.1%. So we have:
279      *
280      *     ((numerator * multiple) % denominator)     1
281      *     -------------------------------------- < ----
282      *              numerator * multiple            1000
283      *
284      * To avoid further division, we can move the denominators to the other sides and we get:
285      *
286      *     ((numerator * multiple) % denominator) * 1000 < numerator * multiple
287      *
288      * Since we want to return true if there IS a rounding error, we simply flip the sign and our
289      * final equation becomes:
290      *
291      *     ((numerator * multiple) % denominator) * 1000 >= numerator * multiple
292      *
293      * @param numerator The numerator of the proportion
294      * @param denominator The denominator of the proportion
295      * @param multiple The amount we want a proportion of
296      * @return Boolean indicating if there is a rounding error when calculating the proportion
297      */
298     function isRoundingError(
299         uint256 numerator,
300         uint256 denominator,
301         uint256 multiple
302     )
303         internal
304         pure
305         returns (bool)
306     {
307         // numerator.mul(multiple).mod(denominator).mul(1000) >= numerator.mul(multiple)
308         return mul(mod(mul(numerator, multiple), denominator), 1000) >= mul(numerator, multiple);
309     }
310 
311     /**
312      * Takes an amount (multiple) and calculates a proportion of it given a numerator/denominator
313      * pair of values. The final value will be rounded down to the nearest integer value.
314      *
315      * This function will revert the transaction if rounding the final value down would lose more
316      * than 0.1% precision.
317      *
318      * @param numerator The numerator of the proportion
319      * @param denominator The denominator of the proportion
320      * @param multiple The amount we want a proportion of
321      * @return The final proportion of multiple rounded down
322      */
323     function getPartialAmountFloor(
324         uint256 numerator,
325         uint256 denominator,
326         uint256 multiple
327     )
328         internal
329         pure
330         returns (uint256)
331     {
332         require(!isRoundingError(numerator, denominator, multiple), "ROUNDING_ERROR");
333         // numerator.mul(multiple).div(denominator)
334         return div(mul(numerator, multiple), denominator);
335     }
336 
337     /**
338      * Returns the smaller integer of the two passed in.
339      *
340      * @param a Unsigned integer
341      * @param b Unsigned integer
342      * @return The smaller of the two integers
343      */
344     function min(
345         uint256 a,
346         uint256 b
347     )
348         internal
349         pure
350         returns (uint256)
351     {
352         return a < b ? a : b;
353     }
354 }
355 
356 contract FeedPriceOracle is Ownable {
357     using SafeMath for uint256;
358 
359     address public asset;
360     uint256 public price;
361     uint256 public lastBlockNumber;
362     uint256 public validBlockNumber;
363     uint256 public maxChangeRate;
364     uint256 public minPrice;
365     uint256 public maxPrice;
366 
367     event PriceFeed(
368         uint256 price,
369         uint256 blockNumber
370     );
371 
372     constructor (
373         address _asset,
374         uint256 _validBlockNumber,
375         uint256 _maxChangeRate,
376         uint256 _minPrice,
377         uint256 _maxPrice
378     )
379         public
380     {
381         asset = _asset;
382 
383         setParams(
384             _validBlockNumber,
385             _maxChangeRate,
386             _minPrice,
387             _maxPrice
388         );
389     }
390 
391     function setParams(
392         uint256 _validBlockNumber,
393         uint256 _maxChangeRate,
394         uint256 _minPrice,
395         uint256 _maxPrice
396     )
397         public
398         onlyOwner
399     {
400         require(_minPrice <= _maxPrice, "MIN_PRICE_MUST_LESS_OR_EQUAL_THAN_MAX_PRICE");
401         validBlockNumber = _validBlockNumber;
402         maxChangeRate = _maxChangeRate;
403         minPrice = _minPrice;
404         maxPrice = _maxPrice;
405     }
406 
407     function feed(
408         uint256 newPrice
409     )
410         external
411         onlyOwner
412     {
413         require(newPrice > 0, "PRICE_MUST_GREATER_THAN_0");
414         require(lastBlockNumber < block.number, "BLOCKNUMBER_WRONG");
415         require(newPrice <= maxPrice, "PRICE_EXCEED_MAX_LIMIT");
416         require(newPrice >= minPrice, "PRICE_EXCEED_MIN_LIMIT");
417 
418         if (price > 0) {
419             uint256 changeRate = Decimal.divFloor(newPrice, price);
420             if (changeRate > Decimal.one()) {
421                 changeRate = changeRate.sub(Decimal.one());
422             } else {
423                 changeRate = Decimal.one().sub(changeRate);
424             }
425             require(changeRate <= maxChangeRate, "PRICE_CHANGE_RATE_EXCEED");
426         }
427 
428         price = newPrice;
429         lastBlockNumber = block.number;
430 
431         emit PriceFeed(price, lastBlockNumber);
432     }
433 
434     function getPrice(
435         address _asset
436     )
437         external
438         view
439         returns (uint256)
440     {
441         require(asset == _asset, "ASSET_NOT_MATCH");
442         require(block.number.sub(lastBlockNumber) <= validBlockNumber, "PRICE_EXPIRED");
443         return price;
444     }
445 
446 }