1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.2;
3 
4 interface IUniswapV2Pair {
5     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
6     function price0CumulativeLast() external view returns (uint);
7     function price1CumulativeLast() external view returns (uint);
8     function token0() external view returns (address);
9     function token1() external view returns (address);
10 }
11 
12 interface IKeep3rV1 {
13     function keepers(address keeper) external returns (bool);
14     function KPRH() external view returns (IKeep3rV1Helper);
15     function receipt(address credit, address keeper, uint amount) external;
16 }
17 
18 interface IKeep3rV1Helper {
19     function getQuoteLimit(uint gasUsed) external view returns (uint);
20 }
21 
22 // sliding oracle that uses observations collected to provide moving price averages in the past
23 contract Keep3rV2Oracle {
24     
25     constructor(address _pair) {
26         _factory = msg.sender;
27         pair = _pair;
28         (,,uint32 timestamp) = IUniswapV2Pair(_pair).getReserves();
29         uint112 _price0CumulativeLast = uint112(IUniswapV2Pair(_pair).price0CumulativeLast() * e10 / Q112);
30         uint112 _price1CumulativeLast = uint112(IUniswapV2Pair(_pair).price1CumulativeLast() * e10 / Q112);
31         observations[length++] = Observation(timestamp, _price0CumulativeLast, _price1CumulativeLast);
32     }
33 
34     struct Observation {
35         uint32 timestamp;
36         uint112 price0Cumulative;
37         uint112 price1Cumulative;
38     }
39 
40     modifier factory() {
41         require(msg.sender == _factory, "!F");
42         _;
43     }
44     
45     Observation[65535] public observations;
46     uint16 public length;
47 
48     address immutable _factory;
49     address immutable public pair;
50     // this is redundant with granularity and windowSize, but stored for gas savings & informational purposes.
51     uint constant periodSize = 1800;
52     uint Q112 = 2**112;
53     uint e10 = 10**18;
54     
55     // Pre-cache slots for cheaper oracle writes
56     function cache(uint size) external {
57         uint _length = length+size;
58         for (uint i = length; i < _length; i++) observations[i].timestamp = 1;
59     }
60 
61     // update the current feed for free
62     function update() external factory returns (bool) {
63         return _update();
64     }
65 
66     function updateable() external view returns (bool) {
67         Observation memory _point = observations[length-1];
68         (,, uint timestamp) = IUniswapV2Pair(pair).getReserves();
69         uint timeElapsed = timestamp - _point.timestamp;
70         return timeElapsed > periodSize;
71     }
72 
73     function _update() internal returns (bool) {
74         Observation memory _point = observations[length-1];
75         (,, uint32 timestamp) = IUniswapV2Pair(pair).getReserves();
76         uint32 timeElapsed = timestamp - _point.timestamp;
77         if (timeElapsed > periodSize) {
78             uint112 _price0CumulativeLast = uint112(IUniswapV2Pair(pair).price0CumulativeLast() * e10 / Q112);
79             uint112 _price1CumulativeLast = uint112(IUniswapV2Pair(pair).price1CumulativeLast() * e10 / Q112);
80             observations[length++] = Observation(timestamp, _price0CumulativeLast, _price1CumulativeLast);
81             return true;
82         }
83         return false;
84     }
85 
86     function _computeAmountOut(uint start, uint end, uint elapsed, uint amountIn) internal view returns (uint amountOut) {
87         amountOut = amountIn * (end - start) / e10 / elapsed;
88     }
89 
90     function current(address tokenIn, uint amountIn, address tokenOut) external view returns (uint amountOut, uint lastUpdatedAgo) {
91         (address token0,) = tokenIn < tokenOut ? (tokenIn, tokenOut) : (tokenOut, tokenIn);
92 
93         Observation memory _observation = observations[length-1];
94         uint price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast() * e10 / Q112;
95         uint price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast() * e10 / Q112;
96         (,,uint timestamp) = IUniswapV2Pair(pair).getReserves();
97         
98         // Handle edge cases where we have no updates, will revert on first reading set
99         if (timestamp == _observation.timestamp) {
100             _observation = observations[length-2];
101         }
102         
103         uint timeElapsed = timestamp - _observation.timestamp;
104         timeElapsed = timeElapsed == 0 ? 1 : timeElapsed;
105         if (token0 == tokenIn) {
106             amountOut = _computeAmountOut(_observation.price0Cumulative, price0Cumulative, timeElapsed, amountIn);
107         } else {
108             amountOut = _computeAmountOut(_observation.price1Cumulative, price1Cumulative, timeElapsed, amountIn);
109         }
110         lastUpdatedAgo = timeElapsed;
111     }
112 
113     function quote(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint amountOut, uint lastUpdatedAgo) {
114         (address token0,) = tokenIn < tokenOut ? (tokenIn, tokenOut) : (tokenOut, tokenIn);
115 
116         uint priceAverageCumulative = 0;
117         uint _length = length-1;
118         uint i = _length - points;
119         Observation memory currentObservation;
120         Observation memory nextObservation;
121 
122         uint nextIndex = 0;
123         if (token0 == tokenIn) {
124             for (; i < _length; i++) {
125                 nextIndex = i+1;
126                 currentObservation = observations[i];
127                 nextObservation = observations[nextIndex];
128                 priceAverageCumulative += _computeAmountOut(
129                     currentObservation.price0Cumulative,
130                     nextObservation.price0Cumulative, 
131                     nextObservation.timestamp - currentObservation.timestamp, amountIn);
132             }
133         } else {
134             for (; i < _length; i++) {
135                 nextIndex = i+1;
136                 currentObservation = observations[i];
137                 nextObservation = observations[nextIndex];
138                 priceAverageCumulative += _computeAmountOut(
139                     currentObservation.price1Cumulative,
140                     nextObservation.price1Cumulative, 
141                     nextObservation.timestamp - currentObservation.timestamp, amountIn);
142             }
143         }
144         amountOut = priceAverageCumulative / points;
145         
146         (,,uint timestamp) = IUniswapV2Pair(pair).getReserves();
147         lastUpdatedAgo = timestamp - nextObservation.timestamp;
148     }
149     
150     function sample(address tokenIn, uint amountIn, address tokenOut, uint points, uint window) external view returns (uint[] memory prices, uint lastUpdatedAgo) {
151         (address token0,) = tokenIn < tokenOut ? (tokenIn, tokenOut) : (tokenOut, tokenIn);
152         prices = new uint[](points);
153         
154         if (token0 == tokenIn) {
155             {
156                 uint _length = length-1;
157                 uint i = _length - (points * window);
158                 uint _index = 0;
159                 Observation memory nextObservation;
160                 for (; i < _length; i+=window) {
161                     Observation memory currentObservation;
162                     currentObservation = observations[i];
163                     nextObservation = observations[i + window];
164                     prices[_index] = _computeAmountOut(
165                         currentObservation.price0Cumulative,
166                         nextObservation.price0Cumulative, 
167                         nextObservation.timestamp - currentObservation.timestamp, amountIn);
168                     _index = _index + 1;
169                 }
170                 
171                 (,,uint timestamp) = IUniswapV2Pair(pair).getReserves();
172                 lastUpdatedAgo = timestamp - nextObservation.timestamp;
173             }
174         } else {
175             {
176                 uint _length = length-1;
177                 uint i = _length - (points * window);
178                 uint _index = 0;
179                 Observation memory nextObservation;
180                 for (; i < _length; i+=window) {
181                     Observation memory currentObservation;
182                     currentObservation = observations[i];
183                     nextObservation = observations[i + window];
184                     prices[_index] = _computeAmountOut(
185                         currentObservation.price1Cumulative,
186                         nextObservation.price1Cumulative, 
187                         nextObservation.timestamp - currentObservation.timestamp, amountIn);
188                     _index = _index + 1;
189                 }
190                 
191                 (,,uint timestamp) = IUniswapV2Pair(pair).getReserves();
192                 lastUpdatedAgo = timestamp - nextObservation.timestamp;
193             }
194         }
195     }
196 }
197 
198 contract Keep3rV2OracleFactory {
199     
200     function pairForSushi(address tokenA, address tokenB) internal pure returns (address pair) {
201         (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
202         pair = address(uint160(uint256(keccak256(abi.encodePacked(
203                 hex'ff',
204                 0xc35DADB65012eC5796536bD9864eD8773aBc74C4,
205                 keccak256(abi.encodePacked(token0, token1)),
206                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
207             )))));
208     }
209     
210     function pairForUni(address tokenA, address tokenB) internal pure returns (address pair) {
211         (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
212         pair = address(uint160(uint256(keccak256(abi.encodePacked(
213                 hex'ff',
214                 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f,
215                 keccak256(abi.encodePacked(token0, token1)),
216                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
217             )))));
218     }
219     
220     modifier keeper() {
221         require(KP3R.keepers(msg.sender), "!K");
222         _;
223     }
224 
225     modifier upkeep() {
226         uint _gasUsed = gasleft();
227         require(KP3R.keepers(msg.sender), "!K");
228         _;
229         uint _received = KP3R.KPRH().getQuoteLimit(_gasUsed - gasleft());
230         KP3R.receipt(address(KP3R), msg.sender, _received);
231     }
232 
233     address public governance;
234     address public pendingGovernance;
235 
236     /**
237      * @notice Allows governance to change governance (for future upgradability)
238      * @param _governance new governance address to set
239      */
240     function setGovernance(address _governance) external {
241         require(msg.sender == governance, "!G");
242         pendingGovernance = _governance;
243     }
244 
245     /**
246      * @notice Allows pendingGovernance to accept their role as governance (protection pattern)
247      */
248     function acceptGovernance() external {
249         require(msg.sender == pendingGovernance, "!pG");
250         governance = pendingGovernance;
251     }
252 
253     IKeep3rV1 public constant KP3R = IKeep3rV1(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);
254 
255     address[] internal _pairs;
256     mapping(address => Keep3rV2Oracle) public feeds;
257 
258     function pairs() external view returns (address[] memory) {
259         return _pairs;
260     }
261 
262     constructor() {
263         governance = msg.sender;
264     }
265 
266     function update(address pair) external keeper returns (bool) {
267         return feeds[pair].update();
268     }
269     
270     function byteCode(address pair) external pure returns (bytes memory bytecode) {
271         bytecode = abi.encodePacked(type(Keep3rV2Oracle).creationCode, abi.encode(pair));
272     }
273 
274     function deploy(address pair) external returns (address feed) {
275         require(msg.sender == governance, "!G");
276         require(address(feeds[pair]) == address(0), 'PE');
277         bytes memory bytecode = abi.encodePacked(type(Keep3rV2Oracle).creationCode, abi.encode(pair));
278         bytes32 salt = keccak256(abi.encodePacked(pair));
279         assembly {
280             feed := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
281             if iszero(extcodesize(feed)) {
282                 revert(0, 0)
283             }
284         }
285         feeds[pair] = Keep3rV2Oracle(feed);
286         _pairs.push(pair);
287     }
288     
289     function work() external upkeep {
290         require(workable(), "!W");
291         for (uint i = 0; i < _pairs.length; i++) {
292             feeds[_pairs[i]].update();
293         }
294     }
295 
296     function work(address pair) external upkeep {
297         require(feeds[pair].update(), "!W");
298     }
299     
300     function workForFree() external keeper {
301         for (uint i = 0; i < _pairs.length; i++) {
302             feeds[_pairs[i]].update();
303         }
304     }
305 
306     function workForFree(address pair) external keeper {
307         feeds[pair].update();
308     }
309     
310     function cache(uint size) external {
311         for (uint i = 0; i < _pairs.length; i++) {
312             feeds[_pairs[i]].cache(size);
313         }
314     }
315     
316     function cache(address pair, uint size) external {
317         feeds[pair].cache(size);
318     }
319 
320     function workable() public view returns (bool canWork) {
321         canWork = true;
322         for (uint i = 0; i < _pairs.length; i++) {
323             if (!feeds[_pairs[i]].updateable()) {
324                 canWork = false;
325             }
326         }
327     }
328 
329     function workable(address pair) public view returns (bool) {
330         return feeds[pair].updateable();
331     }
332     
333     function sample(address tokenIn, uint amountIn, address tokenOut, uint points, uint window, bool sushiswap) external view returns (uint[] memory prices, uint lastUpdatedAgo) {
334         address _pair = sushiswap ? pairForSushi(tokenIn, tokenOut) : pairForUni(tokenIn, tokenOut);
335         return feeds[_pair].sample(tokenIn, amountIn, tokenOut, points, window);
336     }
337     
338     function sample(address pair, address tokenIn, uint amountIn, address tokenOut, uint points, uint window) external view returns (uint[] memory prices, uint lastUpdatedAgo) {
339         return feeds[pair].sample(tokenIn, amountIn, tokenOut, points, window);
340     }
341     
342     function quote(address tokenIn, uint amountIn, address tokenOut, uint points, bool sushiswap) external view returns (uint amountOut, uint lastUpdatedAgo) {
343         address _pair = sushiswap ? pairForSushi(tokenIn, tokenOut) : pairForUni(tokenIn, tokenOut);
344         return feeds[_pair].quote(tokenIn, amountIn, tokenOut, points);
345     }
346     
347     function quote(address pair, address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint amountOut, uint lastUpdatedAgo) {
348         return feeds[pair].quote(tokenIn, amountIn, tokenOut, points);
349     }
350     
351     function current(address tokenIn, uint amountIn, address tokenOut, bool sushiswap) external view returns (uint amountOut, uint lastUpdatedAgo) {
352         address _pair = sushiswap ? pairForSushi(tokenIn, tokenOut) : pairForUni(tokenIn, tokenOut);
353         return feeds[_pair].current(tokenIn, amountIn, tokenOut);
354     }
355     
356     function current(address pair, address tokenIn, uint amountIn, address tokenOut) external view returns (uint amountOut, uint lastUpdatedAgo) {
357         return feeds[pair].current(tokenIn, amountIn, tokenOut);
358     }
359 }