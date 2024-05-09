1 pragma solidity 0.5.17;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) 
7             return 0;
8         uint256 c = a * b;
9         require(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0);
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a);
21         uint256 c = a - b;
22         return c;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a);
28         return c;
29     }
30 
31     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b != 0);
33         return a % b;
34     }
35 }
36 
37 contract Ownable {
38     address public owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     modifier onlyOwner() {
47         require(msg.sender == owner, "permission denied");
48         _;
49     }
50 
51     function transferOwnership(address newOwner) public onlyOwner {
52         require(newOwner != address(0), "invalid address");
53         emit OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55     }
56 }
57 
58 contract ERC20 {
59     using SafeMath for uint256;
60 
61     mapping (address => uint256) internal _balances;
62     mapping (address => mapping (address => uint256)) internal _allowed;
63     
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 
67     uint256 internal _totalSupply;
68 
69     /**
70     * @dev Total number of tokens in existence
71     */
72     function totalSupply() public view returns (uint256) {
73         return _totalSupply;
74     }
75 
76     /**
77     * @dev Gets the balance of the specified address.
78     * @param owner The address to query the balance of.
79     * @return A uint256 representing the amount owned by the passed address.
80     */
81     function balanceOf(address owner) public view returns (uint256) {
82         return _balances[owner];
83     }
84 
85     /**
86     * @dev Function to check the amount of tokens that an owner allowed to a spender.
87     * @param owner address The address which owns the funds.
88     * @param spender address The address which will spend the funds.
89     * @return A uint256 specifying the amount of tokens still available for the spender.
90     */
91     function allowance(address owner, address spender) public view returns (uint256) {
92         return _allowed[owner][spender];
93     }
94 
95     /**
96     * @dev Transfer token to a specified address
97     * @param to The address to transfer to.
98     * @param value The amount to be transferred.
99     */
100     function transfer(address to, uint256 value) public returns (bool) {
101         _transfer(msg.sender, to, value);
102         return true;
103     }
104 
105     /**
106     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
107     * Beware that changing an allowance with this method brings the risk that someone may use both the old
108     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
109     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
110     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111     * @param spender The address which will spend the funds.
112     * @param value The amount of tokens to be spent.
113     */
114     function approve(address spender, uint256 value) public returns (bool) {
115         _allowed[msg.sender][spender] = value;
116         emit Approval(msg.sender, spender, value);
117         return true;
118     }
119 
120     /**
121     * @dev Transfer tokens from one address to another.
122     * Note that while this function emits an Approval event, this is not required as per the specification,
123     * and other compliant implementations may not emit the event.
124     * @param from address The address which you want to send tokens from
125     * @param to address The address which you want to transfer to
126     * @param value uint256 the amount of tokens to be transferred
127     */
128     function transferFrom(address from, address to, uint256 value) public returns (bool) {
129         if (from != msg.sender && _allowed[from][msg.sender] != uint256(-1))
130             _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
131         _transfer(from, to, value);
132         return true;
133     }
134 
135     function _transfer(address from, address to, uint256 value) internal {
136         require(to != address(0));
137         _balances[from] = _balances[from].sub(value);
138         _balances[to] = _balances[to].add(value);
139         emit Transfer(from, to, value);
140     }
141 
142 }
143 
144 contract ERC20Mintable is ERC20 {
145     string public name;
146     string public symbol;
147     uint8 public decimals;
148 
149     function _mint(address to, uint256 amount) internal {
150         _balances[to] = _balances[to].add(amount);
151         _totalSupply = _totalSupply.add(amount);
152         emit Transfer(address(0), to, amount);
153     }
154 
155     function _burn(address from, uint256 amount) internal {
156         _balances[from] = _balances[from].sub(amount);
157         _totalSupply = _totalSupply.sub(amount);
158         emit Transfer(from, address(0), amount);
159     }
160 }
161 
162 contract Seal is ERC20Mintable, Ownable {
163     using SafeMath for uint256;
164     
165     mapping (address => bool) public isMinter;
166 
167     constructor() public {
168         name = "Seal Finance";
169         symbol = "Seal";
170         decimals = 18;
171     }
172 
173     function setMinter(address minter, bool flag) external onlyOwner {
174         isMinter[minter] = flag;
175     }
176 
177     function mint(address to, uint256 amount) external {
178         require(isMinter[msg.sender], "Not Minter");
179         _mint(to, amount);
180     }
181 
182     function burn(address from, uint256 amount) external {
183         if (from != msg.sender && _allowed[from][msg.sender] != uint256(-1))
184             _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(amount);
185         require(_balances[from] >= amount, "insufficient-balance");
186         _burn(from, amount);
187     }
188     
189 }
190 
191 interface IUniswapV2Pair {
192     event Approval(address indexed owner, address indexed spender, uint value);
193     event Transfer(address indexed from, address indexed to, uint value);
194 
195     function name() external pure returns (string memory);
196     function symbol() external pure returns (string memory);
197     function decimals() external pure returns (uint8);
198     function totalSupply() external view returns (uint);
199     function balanceOf(address owner) external view returns (uint);
200     function allowance(address owner, address spender) external view returns (uint);
201 
202     function approve(address spender, uint value) external returns (bool);
203     function transfer(address to, uint value) external returns (bool);
204     function transferFrom(address from, address to, uint value) external returns (bool);
205 
206     function DOMAIN_SEPARATOR() external view returns (bytes32);
207     function PERMIT_TYPEHASH() external pure returns (bytes32);
208     function nonces(address owner) external view returns (uint);
209 
210     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
211 
212     event Mint(address indexed sender, uint amount0, uint amount1);
213     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
214     event Swap(
215         address indexed sender,
216         uint amount0In,
217         uint amount1In,
218         uint amount0Out,
219         uint amount1Out,
220         address indexed to
221     );
222     event Sync(uint112 reserve0, uint112 reserve1);
223 
224     function MINIMUM_LIQUIDITY() external pure returns (uint);
225     function factory() external view returns (address);
226     function token0() external view returns (address);
227     function token1() external view returns (address);
228     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
229     function price0CumulativeLast() external view returns (uint);
230     function price1CumulativeLast() external view returns (uint);
231     function kLast() external view returns (uint);
232 
233     function mint(address to) external returns (uint liquidity);
234     function burn(address to) external returns (uint amount0, uint amount1);
235     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
236     function skim(address to) external;
237     function sync() external;
238 
239     function initialize(address, address) external;
240 }
241 
242 library UniswapV2Library {
243     using SafeMath for uint;
244 
245     // returns sorted token addresses, used to handle return values from pairs sorted in this order
246     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
247         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
248         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
249         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
250     }
251 
252     // calculates the CREATE2 address for a pair without making any external calls
253     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
254         (address token0, address token1) = sortTokens(tokenA, tokenB);
255         pair = address(uint(keccak256(abi.encodePacked(
256                 hex'ff',
257                 factory,
258                 keccak256(abi.encodePacked(token0, token1)),
259                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
260             ))));
261     }
262 
263     // fetches and sorts the reserves for a pair
264     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
265         (address token0,) = sortTokens(tokenA, tokenB);
266         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
267         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
268     }
269 
270     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
271     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
272         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
273         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
274         amountB = amountA.mul(reserveB) / reserveA;
275     }
276 
277     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
278     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
279         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
280         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
281         uint amountInWithFee = amountIn.mul(997);
282         uint numerator = amountInWithFee.mul(reserveOut);
283         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
284         amountOut = numerator / denominator;
285     }
286 
287     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
288     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
289         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
290         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
291         uint numerator = reserveIn.mul(amountOut).mul(1000);
292         uint denominator = reserveOut.sub(amountOut).mul(997);
293         amountIn = (numerator / denominator).add(1);
294     }
295 
296     // performs chained getAmountOut calculations on any number of pairs
297     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
298         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
299         amounts = new uint[](path.length);
300         amounts[0] = amountIn;
301         for (uint i; i < path.length - 1; i++) {
302             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
303             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
304         }
305     }
306 
307     // performs chained getAmountIn calculations on any number of pairs
308     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
309         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
310         amounts = new uint[](path.length);
311         amounts[amounts.length - 1] = amountOut;
312         for (uint i = path.length - 1; i > 0; i--) {
313             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
314             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
315         }
316     }
317 }
318 
319 
320 contract Farm is Ownable {
321     using SafeMath for uint256;
322 
323     Seal public seal; //white seal
324     IUniswapV2Pair public cSeal; //colored seal
325     ERC20 public token; //token
326     uint256 public today;
327     uint256 public spawnRate;
328     uint256 public withdrawRate;
329     uint256 public timeLock;
330 
331     uint256 internal _totalSupply;
332     mapping(address => uint256) internal _balances;
333     mapping(address => uint256) public depositTimeStamp;
334 
335     constructor(uint256 _spawnRate, uint256 _withdrawRate, uint256 _timeLock, address _seal, address _cSeal, address _token) public {
336         today = now / 1 days;
337         spawnRate = _spawnRate;
338         withdrawRate = _withdrawRate;
339         timeLock = _timeLock;
340         seal = Seal(_seal);
341         cSeal = IUniswapV2Pair(_cSeal);
342         token = ERC20(_token);
343     }
344 
345     function setParams(uint256 _spawnRate, uint256 _withdrawRate, uint256 _timeLock) external onlyOwner {
346         require(_spawnRate <= 0.1e18);
347         require(_withdrawRate >= 0.85e18 && _withdrawRate <= 1e18);
348         require(_timeLock <= 15 days);
349         spawnRate = _spawnRate;
350         withdrawRate = _withdrawRate;
351         timeLock = _timeLock;
352     }
353 
354     function totalSupply() public view returns (uint256) {
355         return _totalSupply;
356     }
357 
358     function balanceOf(address account) public view returns (uint256) {
359         return _balances[account];
360     }
361 
362     function totalValue() public view returns(uint256) {
363         return cSeal.balanceOf(address(this));
364     }
365 
366     function deposit(uint256 amount) external returns (uint256 share) {
367         if(totalSupply() > 0) 
368             share = totalSupply().mul(amount).div(totalValue());
369         else
370             share = amount;
371         _balances[msg.sender] = _balances[msg.sender].add(share);
372         depositTimeStamp[msg.sender] = now;
373         _totalSupply = _totalSupply.add(share);
374         require(cSeal.transferFrom(msg.sender, address(this), amount));
375     }
376 
377     function withdraw(address to, uint256 share) external returns (uint256 amount) {
378         require(depositTimeStamp[msg.sender].add(timeLock) <= now, "locked");
379         amount = share.mul(totalValue()).div(totalSupply());
380         if(share < _totalSupply)
381             amount = amount.mul(withdrawRate).div(1e18);
382         _balances[msg.sender] = _balances[msg.sender].sub(share);
383         _totalSupply = _totalSupply.sub(share);
384         require(cSeal.transfer(to, amount));
385     }
386 
387     function rescueToken(ERC20 _token, uint256 _amount) onlyOwner public {
388         require(_token != ERC20(address(cSeal)));
389         _token.transfer(msg.sender, _amount);
390     }
391 
392     function breed() external {
393         require(now / 1 days > today);
394         today += 1;
395 
396         uint256 sealPairAmount = seal.balanceOf(address(cSeal));
397         uint256 tokenPairAmount = token.balanceOf(address(cSeal));
398         uint256 newSeal = sealPairAmount.mul(spawnRate).div(1e18);
399         uint256 amount = UniswapV2Library.getAmountOut(newSeal, sealPairAmount, tokenPairAmount);
400 
401         seal.mint(address(cSeal), newSeal);
402         if(address(seal) < address(token))
403             cSeal.swap(0, amount, address(this), "");
404         else
405             cSeal.swap(amount, 0, address(this), "");
406         token.transfer(address(cSeal), amount);
407         seal.mint(address(cSeal), newSeal);
408         cSeal.mint(address(this));
409     }
410 }