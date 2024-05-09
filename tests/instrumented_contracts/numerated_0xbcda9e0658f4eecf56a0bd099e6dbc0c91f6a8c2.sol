1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function decimals() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12 }
13 
14 library Address {
15     function isContract(address account) internal view returns (bool) {
16         bytes32 codehash;
17         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
18         // solhint-disable-next-line no-inline-assembly
19         assembly { codehash := extcodehash(account) }
20         return (codehash != 0x0 && codehash != accountHash);
21     }
22 }
23 
24 library SafeERC20 {
25     using Address for address;
26 
27     function safeTransfer(IERC20 token, address to, uint value) internal {
28         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
29     }
30 
31     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
32         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
33     }
34 
35     function safeApprove(IERC20 token, address spender, uint value) internal {
36         require((value == 0) || (token.allowance(address(this), spender) == 0),
37             "SafeERC20: approve from non-zero to non-zero allowance"
38         );
39         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
40     }
41     function callOptionalReturn(IERC20 token, bytes memory data) private {
42         require(address(token).isContract(), "SafeERC20: call to non-contract");
43 
44         // solhint-disable-next-line avoid-low-level-calls
45         (bool success, bytes memory returndata) = address(token).call(data);
46         require(success, "SafeERC20: low-level call failed");
47 
48         if (returndata.length > 0) { // Return data is optional
49             // solhint-disable-next-line max-line-length
50             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
51         }
52     }
53 }
54 
55 interface Oracle {
56     function getPriceUSD(address reserve) external view returns (uint);
57 }
58 
59 interface ISushiswapV2Factory {
60     function getPair(address tokenA, address tokenB) external view returns (address pair);
61     function createPair(address tokenA, address tokenB) external returns (address pair);
62 }
63 
64 interface ISushiswapV2Pair {
65     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
66     function mint(address to) external returns (uint liquidity);
67     function burn(address to) external returns (uint amount0, uint amount1);
68     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
69     function sync() external;
70 }
71 
72 library SushiswapV2Library {
73     // returns sorted token addresses, used to handle return values from pairs sorted in this order
74     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
75         require(tokenA != tokenB, 'SushiswapV2Library: IDENTICAL_ADDRESSES');
76         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
77         require(token0 != address(0), 'SushiswapV2Library: ZERO_ADDRESS');
78     }
79 
80     // calculates the CREATE2 address for a pair without making any external calls
81     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
82         (address token0, address token1) = sortTokens(tokenA, tokenB);
83         pair = address(uint160(uint(keccak256(abi.encodePacked(
84                 hex'ff',
85                 factory,
86                 keccak256(abi.encodePacked(token0, token1)),
87                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
88             )))));
89     }
90 
91     // fetches and sorts the reserves for a pair
92     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
93         (address token0,) = sortTokens(tokenA, tokenB);
94         (uint reserve0, uint reserve1,) = ISushiswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
95         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
96     }
97 
98     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
99     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
100         require(amountA > 0, 'SushiswapV2Library: INSUFFICIENT_AMOUNT');
101         require(reserveA > 0 && reserveB > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
102         amountB = amountA * reserveB / reserveA;
103     }
104 }
105 
106 contract SushiswapV2SingleSidedILProtection {
107     using SafeERC20 for IERC20;
108 
109     /// @notice EIP-20 token name for this token
110     string public constant name = "SushiswapV2 IL Protection";
111 
112     /// @notice EIP-20 token symbol for this token
113     string public constant symbol = "sil";
114 
115     /// @notice EIP-20 token decimals for this token
116     uint8 public constant decimals = 8;
117 
118     /// @notice Total number of tokens in circulation
119     uint public totalSupply = 0;
120 
121     mapping(address => mapping (address => uint)) internal allowances;
122     mapping(address => uint) internal balances;
123 
124     /// @notice The EIP-712 typehash for the contract's domain
125     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint chainId,address verifyingContract)");
126     bytes32 public immutable DOMAINSEPARATOR;
127 
128     /// @notice The EIP-712 typehash for the permit struct used by the contract
129     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint value,uint nonce,uint deadline)");
130 
131     /// @notice A record of states for signing / validating signatures
132     mapping (address => uint) public nonces;
133 
134     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
135         require(n < 2**32, errorMessage);
136         return uint32(n);
137     }
138 
139     /// @notice The standard EIP-20 transfer event
140     event Transfer(address indexed from, address indexed to, uint amount);
141     
142     /// @notice The standard EIP-20 approval event
143     event Approval(address indexed owner, address indexed spender, uint amount);
144 
145     // Oracle used for price debt data (external to the AMM balance to avoid internal manipulation)
146     Oracle public constant LINK = Oracle(0x271bf4568fb737cc2e6277e9B1EE0034098cDA2a);
147     ISushiswapV2Factory public constant FACTORY = ISushiswapV2Factory(0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac);
148     address public constant WYFI = address(0x017E71e96f2Ae777C679740d2D8Dc15Ed4231981);
149     address public immutable PAIR;
150     
151     uint public constant FEE = 500;
152     
153     
154     // user => token => borrowed
155     mapping (address => mapping(address => uint)) public borrowed;
156     // user => token => lp
157     mapping (address => mapping(address => uint)) public lp;
158     
159     address[] private _markets;
160     mapping (address => bool) pairs;
161     
162     event Deposit(address indexed owner, address indexed lp, uint amountIn, uint minted);
163     event Withdraw(address indexed owner, address indexed lp, uint burned, uint amountOut);
164     
165     constructor () {
166         DOMAINSEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), _getChainId(), address(this)));
167         PAIR = FACTORY.createPair(address(this), WYFI);
168     }
169     
170     function markets() external view returns (address[] memory) {
171         return _markets;
172     }
173     
174     function _mint(address dst, uint amount) internal {
175         // mint the amount
176         totalSupply += amount;
177         // transfer the amount to the recipient
178         balances[dst] += amount;
179         emit Transfer(address(0), dst, amount);
180     }
181     
182     function _burn(address dst, uint amount) internal {
183         // burn the amount
184         totalSupply -= amount;
185         // transfer the amount from the recipient
186         balances[dst] -= amount;
187         emit Transfer(dst, address(0), amount);
188     }
189     
190     function depositAll(IERC20 token, uint minLiquidity) external {
191         _deposit(token, token.balanceOf(msg.sender), minLiquidity);
192     }
193     
194     function deposit(IERC20 token, uint amount, uint minLiquidity) external {
195         _deposit(token, amount, minLiquidity);
196     }
197     
198     function _addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired) internal returns (address pair, uint amountA, uint amountB) {
199         // create the pair if it doesn't exist yet
200         pair = FACTORY.getPair(tokenA, tokenB);
201         if (pair == address(0)) {
202             pair = FACTORY.createPair(tokenA, tokenB);
203             pairs[pair] = true;
204             _markets.push(tokenA);
205         } else if (!pairs[pair]) {
206             pairs[pair] = true;
207             _markets.push(tokenA);
208         }
209         
210         (uint reserveA, uint reserveB) = SushiswapV2Library.getReserves(address(FACTORY), tokenA, tokenB);
211         if (reserveA == 0 && reserveB == 0) {
212             (amountA, amountB) = (amountADesired, amountBDesired);
213         } else {
214             uint amountBOptimal = SushiswapV2Library.quote(amountADesired, reserveA, reserveB);
215             if (amountBOptimal <= amountBDesired) {
216                 (amountA, amountB) = (amountADesired, amountBOptimal);
217             } else {
218                 uint amountAOptimal = SushiswapV2Library.quote(amountBDesired, reserveB, reserveA);
219                 assert(amountAOptimal <= amountADesired);
220                 (amountA, amountB) = (amountAOptimal, amountBDesired);
221             }
222         }
223     }
224     
225     function pairFor(address token) public view returns (address) {
226         return FACTORY.getPair(token, address(this));
227     }
228     
229     function underlyingBalanceOf(address owner, address token) external view returns (uint) {
230         address _pair = pairFor(token);
231         uint _balance = IERC20(token).balanceOf(_pair);
232         return _balance * lp[owner][token] / IERC20(_pair).totalSupply();
233     }
234     
235     function getPriceOracle(address token) public view returns (uint) {
236         return LINK.getPriceUSD(address(token));
237     }
238     
239     function _deposit(IERC20 token, uint amount, uint minLiquidity) internal {
240         uint _price = LINK.getPriceUSD(address(token));
241         uint _value = _price * amount / uint(10)**token.decimals();
242         require(_value > 0, "!value");
243         
244         (address _pair, uint amountA, uint amountB) = _addLiquidity(address(token), address(this), amount, _value);
245         
246         token.safeTransferFrom(msg.sender, _pair, amountA);
247         
248         _value = _price * amountA / uint(10)**token.decimals();
249         require(amountB <= _value, "invalid oracle feed");
250         
251         _mint(_pair, amountB);
252         borrowed[msg.sender][address(token)] += amountB;
253         
254         uint _liquidity = ISushiswapV2Pair(_pair).mint(address(this));
255         require(_liquidity >= minLiquidity, "insufficient output liquidity");
256         lp[msg.sender][address(token)] += _liquidity;
257         
258         emit Deposit(msg.sender, address(token), amountA, amountB);
259     }
260     
261     function withdrawAll(IERC20 token, uint maxSettle) external {
262         _withdraw(token, IERC20(address(this)).balanceOf(msg.sender), maxSettle);
263     }
264     
265     function withdraw(IERC20 token, uint amount, uint maxSettle) external {
266         _withdraw(token, amount, maxSettle);
267     }
268     
269     function shortFall(IERC20 token, address owner, uint amount) public view returns (uint) {
270         uint _lp = lp[owner][address(token)];
271         uint _borrowed = borrowed[owner][address(token)];
272         
273         if (_lp < amount) {
274             amount = _lp;
275         }
276         
277         _borrowed = _borrowed * amount / _lp;
278         address _pair = FACTORY.getPair(address(token), address(this));
279         
280         uint _returned = balances[_pair] * amount / IERC20(_pair).totalSupply();
281         if (_returned < _borrowed) {
282             return _borrowed - _returned;
283         } else {
284             return 0;
285         }
286     }
287     
288     function shortFallInToken(IERC20 token, address owner, uint amount) external view returns (uint) {
289         uint _shortfall = shortFall(token, owner, amount);
290         if (_shortfall > 0) {
291             address _pair = FACTORY.getPair(address(token), address(this));
292             (uint reserveA, uint reserveB,) = ISushiswapV2Pair(_pair).getReserves();
293             (address token0,) = SushiswapV2Library.sortTokens(address(token), address(this));
294             (reserveA, reserveB) = address(token) == token0 ? (reserveA, reserveB) : (reserveB, reserveA);
295             return _getAmountIn(reserveA, reserveB, _shortfall);
296         } else {
297             return 0;
298         }
299         
300     }
301     
302     function profit(IERC20 token, address owner, uint amount) external view returns (uint) {
303         uint _lp = lp[owner][address(token)];
304         uint _borrowed = borrowed[owner][address(token)];
305         
306         if (_lp < amount) {
307             amount = _lp;
308         }
309         
310         _borrowed = _borrowed * amount / _lp;
311         address _pair = FACTORY.getPair(address(token), address(this));
312         
313         uint _returned = balances[_pair] * amount / IERC20(_pair).totalSupply();
314         if (_returned > _borrowed) {
315             return _returned - _borrowed;
316         } else {
317             return 0;
318         }
319     }
320     
321     function _getAmountIn(uint reserveA, uint reserveB, uint amountOut) internal pure returns (uint) {
322         uint numerator = reserveA * amountOut * 1000;
323         uint denominator = (reserveB - amountOut) * 997;
324         return (numerator / denominator) + 1;
325     }
326     
327     function _settle(IERC20 token, address token0, address pair, uint amountA, uint amountB, uint debt, uint maxSettle) internal returns (uint, uint) {
328         if (balances[msg.sender]+amountB < debt) {
329             uint _shortfall = debt - (balances[msg.sender]+amountB);
330             
331             (uint reserveA, uint reserveB,) = ISushiswapV2Pair(pair).getReserves();
332             (reserveA, reserveB) = address(token) == token0 ? (reserveA, reserveB) : (reserveB, reserveA);
333             
334             uint amountIn = _getAmountIn(reserveA, reserveB, _shortfall);
335             
336             require(amountIn <= amountA && amountIn <= maxSettle, 'ADDITIONAL_SETTLEMENT_REQUIRED');
337             token.safeTransfer(pair, amountIn);
338             (uint amount0Out, uint amount1Out) = address(token) == token0 ? (uint(0), _shortfall) : (_shortfall, uint(0));
339             ISushiswapV2Pair(pair).swap(amount0Out, amount1Out, address(this), new bytes(0));
340             amountA -= amountIn;
341             amountB += _shortfall;
342         }
343         return (amountA, amountB);
344     }
345     
346     function _unwrap(address pair, IERC20 token, uint burned, uint debt, uint maxSettle) internal returns (uint, uint) {
347         IERC20(pair).safeTransfer(pair, burned); // send liquidity to pair
348         (uint amountA, uint amountB) = ISushiswapV2Pair(pair).burn(address(this));
349         (address token0,) = SushiswapV2Library.sortTokens(address(token), address(this));
350         (amountA, amountB) = address(token) == token0 ? (amountA, amountB) : (amountB, amountA);
351         return _settle(token, token0, pair, amountA, amountB, debt, maxSettle);
352     }
353     
354     function _withdraw(IERC20 token, uint amount, uint maxSettle) internal {
355         uint _lp = lp[msg.sender][address(token)];
356         uint _borrowed = borrowed[msg.sender][address(token)];
357         
358         if (_lp < amount) {
359             amount = _lp;
360         }
361         
362         // Calculate % of collateral to release
363         _borrowed = _borrowed * amount / _lp;
364         address _pair = FACTORY.getPair(address(token), address(this));
365         
366         (uint amountA, uint amountB) = _unwrap(_pair, token, amount, _borrowed, maxSettle);
367         
368         lp[msg.sender][address(token)] -= amount;
369         borrowed[msg.sender][address(token)] -= _borrowed;
370         
371         token.safeTransfer(msg.sender, amountA);
372         _transferTokens(address(this), msg.sender, amountB);
373         _burn(msg.sender, _borrowed);
374         
375         emit Withdraw(msg.sender, address(token), amount, amountB);
376     }
377 
378     /**
379      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
380      * @param account The address of the account holding the funds
381      * @param spender The address of the account spending the funds
382      * @return The number of tokens approved
383      */
384     function allowance(address account, address spender) external view returns (uint) {
385         return allowances[account][spender];
386     }
387 
388     /**
389      * @notice Approve `spender` to transfer up to `amount` from `src`
390      * @dev This will overwrite the approval amount for `spender`
391      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
392      * @param spender The address of the account which may transfer tokens
393      * @param amount The number of tokens that are approved (2^256-1 means infinite)
394      * @return Whether or not the approval succeeded
395      */
396     function approve(address spender, uint amount) external returns (bool) {
397         allowances[msg.sender][spender] = amount;
398 
399         emit Approval(msg.sender, spender, amount);
400         return true;
401     }
402 
403     /**
404      * @notice Triggers an approval from owner to spends
405      * @param owner The address to approve from
406      * @param spender The address to be approved
407      * @param amount The number of tokens that are approved (2^256-1 means infinite)
408      * @param deadline The time at which to expire the signature
409      * @param v The recovery byte of the signature
410      * @param r Half of the ECDSA signature pair
411      * @param s Half of the ECDSA signature pair
412      */
413     function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
414         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
415         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
416         address signatory = ecrecover(digest, v, r, s);
417         require(signatory != address(0), "permit: signature");
418         require(signatory == owner, "permit: unauthorized");
419         require(block.timestamp <= deadline, "permit: expired");
420 
421         allowances[owner][spender] = amount;
422 
423         emit Approval(owner, spender, amount);
424     }
425 
426     /**
427      * @notice Get the number of tokens held by the `account`
428      * @param account The address of the account to get the balance of
429      * @return The number of tokens held
430      */
431     function balanceOf(address account) external view returns (uint) {
432         return balances[account];
433     }
434 
435     /**
436      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
437      * @param dst The address of the destination account
438      * @param amount The number of tokens to transfer
439      * @return Whether or not the transfer succeeded
440      */
441     function transfer(address dst, uint amount) external returns (bool) {
442         _transferTokens(msg.sender, dst, amount);
443         return true;
444     }
445 
446     /**
447      * @notice Transfer `amount` tokens from `src` to `dst`
448      * @param src The address of the source account
449      * @param dst The address of the destination account
450      * @param amount The number of tokens to transfer
451      * @return Whether or not the transfer succeeded
452      */
453     function transferFrom(address src, address dst, uint amount) external returns (bool) {
454         address spender = msg.sender;
455         uint spenderAllowance = allowances[src][spender];
456 
457         if (spender != src && spenderAllowance != type(uint).max) {
458             uint newAllowance = spenderAllowance - amount;
459             allowances[src][spender] = newAllowance;
460 
461             emit Approval(src, spender, newAllowance);
462         }
463 
464         _transferTokens(src, dst, amount);
465         return true;
466     }
467 
468     function _transferTokens(address src, address dst, uint amount) internal {
469         balances[src] -= amount;
470         balances[dst] += amount;
471         
472         emit Transfer(src, dst, amount);
473                 
474         if ((pairs[src] && dst != address(this))||(pairs[dst] && src != address(this))) {
475             _transferTokens(dst, PAIR, amount / FEE);
476             ISushiswapV2Pair(PAIR).sync();
477         }
478     }
479 
480     function _getChainId() internal view returns (uint) {
481         uint chainId;
482         assembly { chainId := chainid() }
483         return chainId;
484     }
485 }