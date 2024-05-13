1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.16;
4 
5 import '../interfaces/IBabyPair.sol';
6 import '../token/BabyERC20.sol';
7 import '../libraries/Math.sol';
8 import '../libraries/UQ112x112.sol';
9 import '../interfaces/IERC20.sol';
10 import '../interfaces/IBabyFactory.sol';
11 import '../interfaces/IBabyCallee.sol';
12 
13 contract BabyPair is BabyERC20 {
14     using SafeMath  for uint;
15     using UQ112x112 for uint224;
16 
17     uint public constant MINIMUM_LIQUIDITY = 10**3;
18     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
19 
20     address public factory;
21     address public token0;
22     address public token1;
23 
24     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
25     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
26     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
27 
28     uint public price0CumulativeLast;
29     uint public price1CumulativeLast;
30     uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
31 
32     uint private unlocked = 1;
33     modifier lock() {
34         require(unlocked == 1, 'Baby: LOCKED');
35         unlocked = 0;
36         _;
37         unlocked = 1;
38     }
39 
40     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
41         _reserve0 = reserve0;
42         _reserve1 = reserve1;
43         _blockTimestampLast = blockTimestampLast;
44     }
45 
46     function _safeTransfer(address token, address to, uint value) private {
47         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
48         require(success && (data.length == 0 || abi.decode(data, (bool))), 'Baby: TRANSFER_FAILED');
49     }
50 
51     event Mint(address indexed sender, uint amount0, uint amount1);
52     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
53     event Swap(
54         address indexed sender,
55         uint amount0In,
56         uint amount1In,
57         uint amount0Out,
58         uint amount1Out,
59         address indexed to
60     );
61     event Sync(uint112 reserve0, uint112 reserve1);
62 
63     constructor() {
64         factory = msg.sender;
65     }
66 
67     // called once by the factory at time of deployment
68     function initialize(address _token0, address _token1) external {
69         require(msg.sender == factory, 'Baby: FORBIDDEN'); // sufficient check
70         token0 = _token0;
71         token1 = _token1;
72     }
73 
74     // update reserves and, on the first call per block, price accumulators
75     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
76         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'Baby: OVERFLOW');
77         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
78         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
79         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
80             // * never overflows, and + overflow is desired
81             price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
82             price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
83         }
84         reserve0 = uint112(balance0);
85         reserve1 = uint112(balance1);
86         blockTimestampLast = blockTimestamp;
87         emit Sync(reserve0, reserve1);
88     }
89 
90     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
91     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
92         address feeTo = IBabyFactory(factory).feeTo();
93         feeOn = feeTo != address(0);
94         uint _kLast = kLast; // gas savings
95         if (feeOn) {
96             if (_kLast != 0) {
97                 uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
98                 uint rootKLast = Math.sqrt(_kLast);
99                 if (rootK > rootKLast) {
100                     uint numerator = totalSupply.mul(rootK.sub(rootKLast));
101                     uint denominator = rootK.mul(3).add(rootKLast);
102                     uint liquidity = numerator / denominator;
103                     if (liquidity > 0) _mint(feeTo, liquidity);
104                 }
105             }
106         } else if (_kLast != 0) {
107             kLast = 0;
108         }
109     }
110 
111     // this low-level function should be called from a contract which performs important safety checks
112     function mint(address to) external lock returns (uint liquidity) {
113         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
114         uint balance0 = IERC20(token0).balanceOf(address(this));
115         uint balance1 = IERC20(token1).balanceOf(address(this));
116         uint amount0 = balance0.sub(_reserve0);
117         uint amount1 = balance1.sub(_reserve1);
118 
119         bool feeOn = _mintFee(_reserve0, _reserve1);
120         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
121         if (_totalSupply == 0) {
122             liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
123            _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
124         } else {
125             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
126         }
127         require(liquidity > 0, 'Baby: INSUFFICIENT_LIQUIDITY_MINTED');
128         _mint(to, liquidity);
129 
130         _update(balance0, balance1, _reserve0, _reserve1);
131         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
132         emit Mint(msg.sender, amount0, amount1);
133     }
134 
135     // this low-level function should be called from a contract which performs important safety checks
136     function burn(address to) external lock returns (uint amount0, uint amount1) {
137         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
138         address _token0 = token0;                                // gas savings
139         address _token1 = token1;                                // gas savings
140         uint balance0 = IERC20(_token0).balanceOf(address(this));
141         uint balance1 = IERC20(_token1).balanceOf(address(this));
142         uint liquidity = balanceOf[address(this)];
143 
144         bool feeOn = _mintFee(_reserve0, _reserve1);
145         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
146         require(_totalSupply != 0, "influence balance");
147         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
148         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
149         require(amount0 > 0 && amount1 > 0, 'Baby: INSUFFICIENT_LIQUIDITY_BURNED');
150         _burn(address(this), liquidity);
151         _safeTransfer(_token0, to, amount0);
152         _safeTransfer(_token1, to, amount1);
153         balance0 = IERC20(_token0).balanceOf(address(this));
154         balance1 = IERC20(_token1).balanceOf(address(this));
155 
156         _update(balance0, balance1, _reserve0, _reserve1);
157         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
158         emit Burn(msg.sender, amount0, amount1, to);
159     }
160 
161     // this low-level function should be called from a contract which performs important safety checks
162     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
163         require(amount0Out > 0 || amount1Out > 0, 'Baby: INSUFFICIENT_OUTPUT_AMOUNT');
164         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
165         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'Baby: INSUFFICIENT_LIQUIDITY');
166 
167         uint balance0;
168         uint balance1;
169         { // scope for _token{0,1}, avoids stack too deep errors
170         address _token0 = token0;
171         address _token1 = token1;
172         require(to != _token0 && to != _token1, 'Baby: INVALID_TO');
173         if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
174         if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
175         if (data.length > 0) IBabyCallee(to).babyCall(msg.sender, amount0Out, amount1Out, data);
176         balance0 = IERC20(_token0).balanceOf(address(this));
177         balance1 = IERC20(_token1).balanceOf(address(this));
178         }
179         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
180         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
181         require(amount0In > 0 || amount1In > 0, 'Baby: INSUFFICIENT_INPUT_AMOUNT');
182         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
183         uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(2));
184         uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(2));
185         require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'Baby: K');
186         }
187 
188         _update(balance0, balance1, _reserve0, _reserve1);
189         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
190     }
191 
192     // force balances to match reserves
193     function skim(address to) external lock {
194         address _token0 = token0; // gas savings
195         address _token1 = token1; // gas savings
196         _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
197         _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
198     }
199 
200     // force reserves to match balances
201     function sync() external lock {
202         _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
203     }
204 }
