1 pragma solidity =0.8.0;
2 
3 interface INimbusFactory {
4     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
5 
6     function feeTo() external view returns (address);
7     function feeToSetter() external view returns (address);
8     function nimbusReferralProgram() external view returns (address);
9 
10     function getPair(address tokenA, address tokenB) external view returns (address pair);
11     function allPairs(uint) external view returns (address pair);
12     function allPairsLength() external view returns (uint);
13 
14     function createPair(address tokenA, address tokenB) external returns (address pair);
15 
16     function setFeeTo(address) external;
17     function setFeeToSetter(address) external;
18 }
19 
20 interface INimbusBEP20 {
21     event Approval(address indexed owner, address indexed spender, uint value);
22     event Transfer(address indexed from, address indexed to, uint value);
23 
24     function name() external pure returns (string memory);
25     function symbol() external pure returns (string memory);
26     function decimals() external pure returns (uint8);
27     function totalSupply() external view returns (uint);
28     function balanceOf(address owner) external view returns (uint);
29     function allowance(address owner, address spender) external view returns (uint);
30 
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34 
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external pure returns (bytes32);
37     function nonces(address owner) external view returns (uint);
38 
39     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
40 }
41 
42 interface INimbusPair is INimbusBEP20 {
43     event Mint(address indexed sender, uint amount0, uint amount1);
44     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
45     event Swap(
46         address indexed sender,
47         uint amount0In,
48         uint amount1In,
49         uint amount0Out,
50         uint amount1Out,
51         address indexed to
52     );
53     event Sync(uint112 reserve0, uint112 reserve1);
54 
55     function MINIMUM_LIQUIDITY() external pure returns (uint);
56     function factory() external view returns (address);
57     function token0() external view returns (address);
58     function token1() external view returns (address);
59     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
60     function price0CumulativeLast() external view returns (uint);
61     function price1CumulativeLast() external view returns (uint);
62     function kLast() external view returns (uint);
63 
64     function mint(address to) external returns (uint liquidity);
65     function burn(address to) external returns (uint amount0, uint amount1);
66     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
67     function skim(address to) external;
68     function sync() external;
69 
70     function initialize(address, address) external;
71 }
72 
73 contract NimbusBEP20 is INimbusBEP20 {
74     string public constant override name = 'Nimbus LP';
75     string public constant override symbol = 'NBU_LP';
76     uint8 public constant override decimals = 18;
77     uint  public override totalSupply;
78     mapping(address => uint) public override balanceOf;
79     mapping(address => mapping(address => uint)) public override allowance;
80 
81     bytes32 public override DOMAIN_SEPARATOR;
82     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
83     bytes32 public constant override PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
84     mapping(address => uint) public override nonces;
85 
86     constructor() {
87         uint chainId = block.chainid;
88         DOMAIN_SEPARATOR = keccak256(
89             abi.encode(
90                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
91                 keccak256(bytes(name)),
92                 keccak256(bytes('1')),
93                 chainId,
94                 address(this)
95             )
96         );
97     }
98 
99     function _mint(address to, uint value) internal {
100         totalSupply += value;
101         balanceOf[to] += value;
102         emit Transfer(address(0), to, value);
103     }
104 
105     function _burn(address from, uint value) internal {
106         balanceOf[from] -= value;
107         totalSupply -= value;
108         emit Transfer(from, address(0), value);
109     }
110 
111     function _approve(address owner, address spender, uint value) private {
112         allowance[owner][spender] = value;
113         emit Approval(owner, spender, value);
114     }
115 
116     function _transfer(address from, address to, uint value) private {
117         balanceOf[from] -= value;
118         balanceOf[to] += value;
119         emit Transfer(from, to, value);
120     }
121 
122     function approve(address spender, uint value) external override returns (bool) {
123         _approve(msg.sender, spender, value);
124         return true;
125     }
126 
127     function transfer(address to, uint value) external override returns (bool) {
128         _transfer(msg.sender, to, value);
129         return true;
130     }
131 
132     function transferFrom(address from, address to, uint value) external override returns (bool) {
133         if (allowance[from][msg.sender] != type(uint256).max) {
134             allowance[from][msg.sender] -= value;
135         }
136         _transfer(from, to, value);
137         return true;
138     }
139 
140     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external override {
141         require(deadline >= block.timestamp, 'Nimbus: EXPIRED');
142         bytes32 digest = keccak256(
143             abi.encodePacked(
144                 '\x19\x01',
145                 DOMAIN_SEPARATOR,
146                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
147             )
148         );
149         address recoveredAddress = ecrecover(digest, v, r, s);
150         require(recoveredAddress != address(0) && recoveredAddress == owner, 'Nimbus: INVALID_SIGNATURE');
151         _approve(owner, spender, value);
152     }
153 }
154 
155 library Math {
156     function min(uint x, uint y) internal pure returns (uint z) {
157         z = x < y ? x : y;
158     }
159 
160     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
161     function sqrt(uint y) internal pure returns (uint z) {
162         if (y > 3) {
163             z = y;
164             uint x = y / 2 + 1;
165             while (x < z) {
166                 z = x;
167                 x = (y / x + x) / 2;
168             }
169         } else if (y != 0) {
170             z = 1;
171         }
172     }
173 }
174 
175 library UQ112x112 {
176     uint224 constant Q112 = 2**112;
177 
178     // encode a uint112 as a UQ112x112
179     function encode(uint112 y) internal pure returns (uint224 z) {
180         z = uint224(y) * Q112; // never overflows
181     }
182 
183     // divide a UQ112x112 by a uint112, returning a UQ112x112
184     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
185         z = x / uint224(y);
186     }
187 }
188 
189 interface IBEP20 {
190     event Approval(address indexed owner, address indexed spender, uint value);
191     event Transfer(address indexed from, address indexed to, uint value);
192 
193     function name() external view returns (string memory);
194     function symbol() external view returns (string memory);
195     function decimals() external view returns (uint8);
196     function totalSupply() external view returns (uint);
197     function balanceOf(address owner) external view returns (uint);
198     function allowance(address owner, address spender) external view returns (uint);
199     function getOwner() external view returns (address);
200 
201     function approve(address spender, uint value) external returns (bool);
202     function transfer(address to, uint value) external returns (bool);
203     function transferFrom(address from, address to, uint value) external returns (bool);
204 }
205 
206 interface INimbusCallee {
207     function NimbusCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
208 }
209 
210 interface INimbusReferralProgram {
211     function recordFee(address token, address recipient, uint amount) external;
212 }
213 
214 contract NimbusPair is INimbusPair, NimbusBEP20 {
215     using UQ112x112 for uint224;
216 
217     uint public constant override MINIMUM_LIQUIDITY = 10**3;
218     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
219 
220     address public override immutable factory;
221     address public override token0;
222     address public override token1;
223 
224     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
225     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
226     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
227 
228     uint public override price0CumulativeLast;
229     uint public override price1CumulativeLast;
230     uint public override kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
231 
232     uint private unlocked = 1;
233     modifier lock() {
234         require(unlocked == 1, 'Nimbus: LOCKED');
235         unlocked = 0;
236         _;
237         unlocked = 1;
238     }
239 
240     function getReserves() public view override returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
241         _reserve0 = reserve0;
242         _reserve1 = reserve1;
243         _blockTimestampLast = blockTimestampLast;
244     }
245 
246     function _safeTransfer(address token, address to, uint value) private {
247         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
248         require(success && (data.length == 0 || abi.decode(data, (bool))), 'Nimbus: TRANSFER_FAILED');
249     }
250 
251     constructor() {
252         factory = msg.sender;
253     }
254 
255     // called once by the factory at time of deployment
256     function initialize(address _token0, address _token1) external override {
257         require(msg.sender == factory, 'Nimbus: FORBIDDEN'); // sufficient check
258         token0 = _token0;
259         token1 = _token1;
260     }
261 
262     // update reserves and, on the first call per block, price accumulators
263     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
264         require(balance0 <= (2**112 - 1) && balance1 <= (2**112 - 1), 'Nimbus: OVERFLOW'); // uint112(-1) = 2 ** 112 - 1
265         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
266         uint32 timeElapsed;
267         unchecked {
268             timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
269         }
270         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
271             // * never overflows, and + overflow is desired
272             unchecked {
273                 price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
274                 price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
275             }
276         }
277         reserve0 = uint112(balance0);
278         reserve1 = uint112(balance1);
279         blockTimestampLast = blockTimestamp;
280         emit Sync(reserve0, reserve1);
281     }
282 
283     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
284     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
285         address feeTo = INimbusFactory(factory).feeTo();
286         feeOn = feeTo != address(0);
287         uint _kLast = kLast; // gas savings
288         if (feeOn) {
289             if (_kLast != 0) {
290                 uint rootK = Math.sqrt(uint(_reserve0) * _reserve1);
291                 uint rootKLast = Math.sqrt(_kLast);
292                 if (rootK > rootKLast) {
293                     uint numerator = totalSupply * (rootK - rootKLast);
294                     uint denominator = rootK * 5 + rootKLast;
295                     uint liquidity = numerator / denominator;
296                     if (liquidity > 0) _mint(feeTo, liquidity);
297                 }
298             }
299         } else if (_kLast != 0) {
300             kLast = 0;
301         }
302     }
303 
304     // this low-level function should be called from a contract which performs important safety checks
305     function mint(address to) external override lock returns (uint liquidity) {
306         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
307         uint balance0 = IBEP20(token0).balanceOf(address(this));
308         uint balance1 = IBEP20(token1).balanceOf(address(this));
309         uint amount0 = balance0 - _reserve0;
310         uint amount1 = balance1 - _reserve1;
311 
312         bool feeOn = _mintFee(_reserve0, _reserve1);
313         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
314         if (_totalSupply == 0) {
315             liquidity = Math.sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY;
316            _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
317         } else {
318             liquidity = Math.min(amount0 * _totalSupply / _reserve0, amount1 * _totalSupply / _reserve1);
319         }
320         require(liquidity > 0, 'Nimbus: INSUFFICIENT_LIQUIDITY_MINTED');
321         _mint(to, liquidity);
322 
323         _update(balance0, balance1, _reserve0, _reserve1);
324         if (feeOn) kLast = uint(reserve0) * reserve1; // reserve0 and reserve1 are up-to-date
325         emit Mint(msg.sender, amount0, amount1);
326     }
327 
328     // this low-level function should be called from a contract which performs important safety checks
329     function burn(address to) external override lock returns (uint amount0, uint amount1) {
330         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
331         address _token0 = token0;                                // gas savings
332         address _token1 = token1;                                // gas savings
333         uint balance0 = IBEP20(_token0).balanceOf(address(this));
334         uint balance1 = IBEP20(_token1).balanceOf(address(this));
335         uint liquidity = balanceOf[address(this)];
336 
337         bool feeOn = _mintFee(_reserve0, _reserve1);
338         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
339         amount0 = liquidity * balance0 / _totalSupply; // using balances ensures pro-rata distribution
340         amount1 = liquidity * balance1 / _totalSupply; // using balances ensures pro-rata distribution
341         require(amount0 > 0 && amount1 > 0, 'Nimbus: INSUFFICIENT_LIQUIDITY_BURNED');
342         _burn(address(this), liquidity);
343         _safeTransfer(_token0, to, amount0);
344         _safeTransfer(_token1, to, amount1);
345         balance0 = IBEP20(_token0).balanceOf(address(this));
346         balance1 = IBEP20(_token1).balanceOf(address(this));
347 
348         _update(balance0, balance1, _reserve0, _reserve1);
349         if (feeOn) kLast = uint(reserve0) * reserve1; // reserve0 and reserve1 are up-to-date
350         emit Burn(msg.sender, amount0, amount1, to);
351     }
352 
353     // this low-level function should be called from a contract which performs important safety checks
354     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external override lock {
355         require(amount0Out > 0 || amount1Out > 0, 'Nimbus: INSUFFICIENT_OUTPUT_AMOUNT');
356         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
357         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'Nimbus: INSUFFICIENT_LIQUIDITY');
358 
359         uint balance0;
360         uint balance1;
361         { // scope for _token{0,1}, avoids stack too deep errors
362         address _token0 = token0;
363         address _token1 = token1;
364         require(to != _token0 && to != _token1, 'Nimbus: INVALID_TO');
365         if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
366         if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
367         if (data.length > 0) INimbusCallee(to).NimbusCall(msg.sender, amount0Out, amount1Out, data);
368         balance0 = IBEP20(_token0).balanceOf(address(this));
369         balance1 = IBEP20(_token1).balanceOf(address(this));
370         }
371         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
372         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
373         require(amount0In > 0 || amount1In > 0, 'Nimbus: INSUFFICIENT_INPUT_AMOUNT');
374 
375         {
376         address referralProgram = INimbusFactory(factory).nimbusReferralProgram();
377         if (amount0In > 0) {
378             address _token0 = token0;
379             uint refFee = amount0In * 3/ 2000;
380             _safeTransfer(_token0, referralProgram, refFee);
381             INimbusReferralProgram(referralProgram).recordFee(_token0, to, refFee);
382             balance0 -= refFee;
383         } 
384         if (amount1In > 0) {
385             uint refFee = amount1In * 3 / 2000;
386             address _token1 = token1;
387             _safeTransfer(_token1, referralProgram, refFee);
388             INimbusReferralProgram(referralProgram).recordFee(_token1, to, refFee);
389             balance1 -= refFee;
390         }
391         }
392         
393         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
394         uint balance0Adjusted = balance0 * 10000 - (amount0In * 15);
395         uint balance1Adjusted = balance1 * 10000 - (amount1In * 15);
396         require(balance0Adjusted * balance1Adjusted >= uint(_reserve0) * _reserve1 * (10000**2), 'Nimbus: K');
397         }
398 
399         _update(balance0, balance1, _reserve0, _reserve1);
400         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
401     }
402 
403     // force balances to match reserves
404     function skim(address to) external override lock {
405         address _token0 = token0; // gas savings
406         address _token1 = token1; // gas savings
407         _safeTransfer(_token0, to, IBEP20(_token0).balanceOf(address(this)) - reserve0);
408         _safeTransfer(_token1, to, IBEP20(_token1).balanceOf(address(this)) - reserve1);
409     }
410 
411     // force reserves to match balances
412     function sync() external override lock {
413         _update(IBEP20(token0).balanceOf(address(this)), IBEP20(token1).balanceOf(address(this)), reserve0, reserve1);
414     }
415 }
416 
417 
418 contract NimbusFactory is INimbusFactory {
419     address public override feeTo;
420     address public override feeToSetter;
421     address public override nimbusReferralProgram;
422 
423     mapping(address => mapping(address => address)) public override getPair;
424     address[] public override allPairs;
425 
426     constructor(address _feeToSetter) {
427         require(_feeToSetter != address(0), "Nimbus: Zero address");
428         feeToSetter = _feeToSetter;
429     }
430 
431     function allPairsLength() external override view returns (uint) {
432         return allPairs.length;
433     }
434 
435     function createPair(address tokenA, address tokenB) external override returns (address pair) {
436         require(tokenA != tokenB, 'Nimbus: IDENTICAL_ADDRESSES');
437         (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
438         require(token0 != address(0), 'Nimbus: ZERO_ADDRESS');
439         require(getPair[token0][token1] == address(0), 'Nimbus: PAIR_EXISTS'); // single check is sufficient
440         bytes memory bytecode = type(NimbusPair).creationCode;
441         bytes32 salt = keccak256(abi.encodePacked(token0, token1));
442         assembly {
443             pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
444         }
445         INimbusPair(pair).initialize(token0, token1);
446         getPair[token0][token1] = pair;
447         getPair[token1][token0] = pair; // populate mapping in the reverse direction
448         allPairs.push(pair);
449         emit PairCreated(token0, token1, pair, allPairs.length);
450     }
451 
452     function setFeeTo(address _feeTo) external override {
453         require(msg.sender == feeToSetter, 'Nimbus: FORBIDDEN');
454         feeTo = _feeTo;
455     }
456 
457     function setFeeToSetter(address _feeToSetter) external override {
458         require(msg.sender == feeToSetter, 'Nimbus: FORBIDDEN');
459         require(_feeToSetter != address(0), 'Nimbus: ZERO_ADDRESS');
460         feeToSetter = _feeToSetter;
461     }
462 
463     function setNimbusReferralProgram(address _nimbusReferralProgram) external {
464         require(msg.sender == feeToSetter, 'Nimbus: FORBIDDEN');
465         require(_nimbusReferralProgram != address(0), 'Nimbus: ZERO_ADDRESS');
466         nimbusReferralProgram = _nimbusReferralProgram;
467     }
468 }