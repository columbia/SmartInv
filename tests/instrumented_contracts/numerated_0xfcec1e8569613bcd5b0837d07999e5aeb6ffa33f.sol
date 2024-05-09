1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipRenounced(address indexed previousOwner);
14     event OwnershipTransferred(
15         address indexed previousOwner,
16         address indexed newOwner
17     );
18 
19 
20     /**
21     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22     * account.
23     */
24     constructor() public {
25         owner = msg.sender;
26     }
27 
28     /**
29     * @dev Throws if called by any account other than the owner.
30     */
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     /**
37     * @dev Allows the current owner to transfer control of the contract to a newOwner.
38     * @param newOwner The address to transfer ownership to.
39     */
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 
46     /**
47     * @dev Allows the current owner to relinquish control of the contract.
48     */
49     function renounceOwnership() public onlyOwner {
50         emit OwnershipRenounced(owner);
51         owner = address(0);
52     }
53 }
54 
55 
56 
57 
58 
59 /**
60   * @title StockPortfolio
61   * @author aflesher
62   * @dev StockPortfolio is smart contract for keeping a record
63   * @dev stock purchases. Trades can more or less be validated
64   * @dev using the trade timestamp and comparing the data to
65   * @dev historical values.
66   */
67 contract StockPortfolio is Ownable {
68 
69     struct Position {
70         uint32 quantity;
71         uint32 avgPrice;
72     }
73 
74     mapping (bytes12 => Position) positions;
75     bytes12[] private holdings;
76     bytes6[] private markets;
77 
78     event Bought(bytes6 market, bytes6 symbol, uint32 quantity, uint32 price, uint256 timestamp);
79     event Sold(bytes6 market, bytes6 symbol, uint32 quantity, uint32 price, int64 profits, uint256 timestamp);
80     event ForwardSplit(bytes6 market, bytes6 symbol, uint8 multiple, uint256 timestamp);
81     event ReverseSplit(bytes6 market, bytes6 symbol, uint8 divisor, uint256 timestamp);
82 
83     // Profits have to be separated because of different curriences so
84     // separate them by market. Market profit to currency can be worked
85     // out by client
86     mapping (bytes6 => int) public profits;
87 
88     constructor () public {
89         markets.push(0x6e7973650000); //nyse 0
90         markets.push(0x6e6173646171); //nasdaq 1
91         markets.push(0x747378000000); //tsx 2
92         markets.push(0x747378760000); //tsxv 3
93         markets.push(0x6f7463000000); //otc 4
94         markets.push(0x637365000000); //cse 5
95     }
96 
97     function () public payable {}
98 
99     /**
100      * @dev Adds to or creates new position
101      * @param _marketIndex The index of the market
102      * @param _symbol A stock symbol
103      * @param _quantity Quantity of shares to buy
104      * @param _price Price per share * 100 ($10.24 = 1024)
105      */
106     function buy
107     (
108         uint8 _marketIndex,
109         bytes6 _symbol,
110         uint32 _quantity,
111         uint32 _price
112     )
113         external
114         onlyOwner
115     {
116         _buy(_marketIndex, _symbol, _quantity, _price);
117     }
118 
119     /**
120      * @dev Adds to or creates a series of positions
121      * @param _marketIndexes The indexes of the markets
122      * @param _symbols Stock symbols
123      * @param _quantities Quantities of shares to buy
124      * @param _prices Prices per share * 100 ($10.24 = 1024)
125      */
126     function bulkBuy
127     (
128         uint8[] _marketIndexes,
129         bytes6[] _symbols,
130         uint32[] _quantities,
131         uint32[] _prices
132     )
133         external
134         onlyOwner
135     {
136         for (uint i = 0; i < _symbols.length; i++) {
137             _buy(_marketIndexes[i], _symbols[i], _quantities[i], _prices[i]);
138         }
139     }
140 
141     /**
142      * @dev Tracks a stock split
143      * @param _marketIndex The index of the market
144      * @param _symbol A stock symbol
145      * @param _multiple Number of new shares per share created
146      */
147     function split
148     (
149         uint8 _marketIndex,
150         bytes6 _symbol,
151         uint8 _multiple
152     )
153         external
154         onlyOwner
155     {
156         bytes6 market = markets[_marketIndex];
157         bytes12 stockKey = getStockKey(market, _symbol);
158         Position storage position = positions[stockKey];
159         require(position.quantity > 0);
160         uint32 quantity = (_multiple * position.quantity) - position.quantity;
161         position.avgPrice = (position.quantity * position.avgPrice) / (position.quantity + quantity);
162         position.quantity += quantity;
163 
164         emit ForwardSplit(market, _symbol, _multiple, now);
165     }
166 
167     /**
168      * @dev Tracks a reverse stock split
169      * @param _marketIndex The index of the market
170      * @param _symbol A stock symbol
171      * @param _divisor Number of existing shares that will equal 1 new share
172      * @param _price The current stock price. Remainder shares will sold at this price
173      */
174     function reverseSplit
175     (
176         uint8 _marketIndex,
177         bytes6 _symbol,
178         uint8 _divisor,
179         uint32 _price
180     )
181         external
182         onlyOwner
183     {
184         bytes6 market = markets[_marketIndex];
185         bytes12 stockKey = getStockKey(market, _symbol);
186         Position storage position = positions[stockKey];
187         require(position.quantity > 0);
188         uint32 quantity = position.quantity / _divisor;
189         uint32 extraQuantity = position.quantity - (quantity * _divisor);
190         if (extraQuantity > 0) {
191             _sell(_marketIndex, _symbol, extraQuantity, _price);
192         }
193         position.avgPrice = position.avgPrice * _divisor;
194         position.quantity = quantity;
195 
196         emit ReverseSplit(market, _symbol, _divisor, now);
197     }
198 
199     /**
200      * @dev Sells a position, adds a new trade and adds profits/lossses
201      * @param _symbol Stock symbol
202      * @param _quantity Quantity of shares to sale
203      * @param _price Price per share * 100 ($10.24 = 1024)
204      */
205     function sell
206     (
207         uint8 _marketIndex,
208         bytes6 _symbol,
209         uint32 _quantity,
210         uint32 _price
211     )
212         external
213         onlyOwner
214     {
215         _sell(_marketIndex, _symbol, _quantity, _price);
216     }
217 
218     /**
219      * @dev Sells positions, adds a new trades and adds profits/lossses
220      * @param _symbols Stock symbols
221      * @param _quantities Quantities of shares to sale
222      * @param _prices Prices per share * 100 ($10.24 = 1024)
223      */
224     function bulkSell
225     (
226         uint8[] _marketIndexes,
227         bytes6[] _symbols,
228         uint32[] _quantities,
229         uint32[] _prices
230     )
231         external
232         onlyOwner
233     {
234         for (uint i = 0; i < _symbols.length; i++) {
235             _sell(_marketIndexes[i], _symbols[i], _quantities[i], _prices[i]);
236         }
237     }
238 
239     /**
240      * @dev Get the number of markets
241      * @return uint
242      */
243     function getMarketsCount() public view returns(uint) {
244         return markets.length;
245     }
246 
247     /**
248      * @dev Get a market at a given index
249      * @param _index The market index
250      * @return bytes6 market name
251      */
252     function getMarket(uint _index) public view returns(bytes6) {
253         return markets[_index];
254     }
255 
256     /**
257      * @dev Get profits
258      * @param _market The market name
259      * @return int
260      */
261     function getProfits(bytes6 _market) public view returns(int) {
262         return profits[_market];
263     }
264 
265     /**
266      * @dev Gets a position
267      * @param _stockKey The stock key
268      * @return quantity Quantity of shares held
269      * @return avgPrice Average price paid for shares
270      */
271     function getPosition
272     (
273         bytes12 _stockKey
274     )
275         public
276         view
277         returns
278         (
279             uint32 quantity,
280             uint32 avgPrice
281         )
282     {
283         Position storage position = positions[_stockKey];
284         quantity = position.quantity;
285         avgPrice = position.avgPrice;
286     }
287 
288     /**
289      * @dev Gets a postion at the given index
290      * @param _index The index of the holding
291      * @return market Market name
292      * @return stock Stock name
293      * @return quantity Quantity of shares held
294      * @return avgPrice Average price paid for shares
295      */  
296     function getPositionFromHolding
297     (
298         uint _index
299     )
300         public
301         view
302         returns
303         (
304             bytes6 market, 
305             bytes6 symbol,
306             uint32 quantity,
307             uint32 avgPrice
308         )
309     {
310         bytes12 stockKey = holdings[_index];
311         (market, symbol) = recoverStockKey(stockKey);
312         Position storage position = positions[stockKey];
313         quantity = position.quantity;
314         avgPrice = position.avgPrice;
315     }
316 
317     /**
318      * @dev Get the number of stocks being held
319      * @return uint
320      */
321     function getHoldingsCount() public view returns(uint) {
322         return holdings.length;
323     }
324 
325     /**
326      * @dev Gets the stock key at the given index
327      * @return bytes32 The unique stock key
328      */
329     function getHolding(uint _index) public view returns(bytes12) {
330         return holdings[_index];
331     }
332 
333     /**
334      * @dev Generates a unique key for a stock by combining the market and symbol
335      * @param _market Stock market
336      * @param _symbol Stock symbol
337      * @return key The key
338      */
339     function getStockKey(bytes6 _market, bytes6 _symbol) public pure returns(bytes12 key) {
340         bytes memory combined = new bytes(12);
341         for (uint i = 0; i < 6; i++) {
342             combined[i] = _market[i];
343         }
344         for (uint j = 0; j < 6; j++) {
345             combined[j + 6] = _symbol[j];
346         }
347         assembly {
348             key := mload(add(combined, 32))
349         }
350     }
351     
352     /**
353      * @dev Splits a unique key for a stock and returns the market and symbol
354      * @param _key Unique stock key
355      * @return market Stock market
356      * @return symbol Stock symbol
357      */
358     function recoverStockKey(bytes12 _key) public pure returns(bytes6 market, bytes6 symbol) {
359         bytes memory _market = new bytes(6);
360         bytes memory _symbol = new bytes(6);
361         for (uint i = 0; i < 6; i++) {
362             _market[i] = _key[i];
363         }
364         for (uint j = 0; j < 6; j++) {
365             _symbol[j] = _key[j + 6];
366         }
367         assembly {
368             market := mload(add(_market, 32))
369             symbol := mload(add(_symbol, 32))
370         }
371     }
372 
373     function addMarket(bytes6 _market) public onlyOwner {
374         markets.push(_market);
375     }
376 
377     function _addHolding(bytes12 _stockKey) private {
378         holdings.push(_stockKey);
379     }
380 
381     function _removeHolding(bytes12 _stockKey) private {
382         if (holdings.length == 0) {
383             return;
384         }
385         bool found = false;
386         for (uint i = 0; i < holdings.length; i++) {
387             if (found) {
388                 holdings[i - 1] = holdings[i];
389             }
390 
391             if (holdings[i] == _stockKey) {
392                 found = true;
393             }
394         }
395         if (found) {
396             delete holdings[holdings.length - 1];
397             holdings.length--;
398         }
399     }
400 
401     function _sell
402     (
403         uint8 _marketIndex,
404         bytes6 _symbol,
405         uint32 _quantity,
406         uint32 _price
407     )
408         private
409     {
410         bytes6 market = markets[_marketIndex];
411         bytes12 stockKey = getStockKey(market, _symbol);
412         Position storage position = positions[stockKey];
413         require(position.quantity >= _quantity);
414         int64 profit = int64(_quantity * _price) - int64(_quantity * position.avgPrice);
415         position.quantity -= _quantity;
416         if (position.quantity <= 0) {
417             _removeHolding(stockKey);
418             delete positions[stockKey];
419         }
420         profits[market] += profit;
421         emit Sold(market, _symbol, _quantity, _price, profit, now);
422     }
423 
424     function _buy
425     (
426         uint8 _marketIndex,
427         bytes6 _symbol,
428         uint32 _quantity,
429         uint32 _price
430     )
431         private
432     {
433         bytes6 market = markets[_marketIndex];
434         bytes12 stockKey = getStockKey(market, _symbol);
435         Position storage position = positions[stockKey];
436         if (position.quantity == 0) {
437             _addHolding(stockKey);
438         }
439         position.avgPrice = ((position.quantity * position.avgPrice) + (_quantity * _price)) /
440             (position.quantity + _quantity);
441         position.quantity += _quantity;
442 
443         emit Bought(market, _symbol, _quantity, _price, now);
444     }
445 
446 }