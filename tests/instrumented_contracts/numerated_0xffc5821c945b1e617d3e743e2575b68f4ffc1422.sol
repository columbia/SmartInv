1 //   _    _ _   _                __ _                            
2 //  | |  (_) | | |              / _(_)                           
3 //  | | ___| |_| |_ ___ _ __   | |_ _ _ __   __ _ _ __   ___ ___ 
4 //  | |/ / | __| __/ _ \ '_ \  |  _| | '_ \ / _` | '_ \ / __/ _ \
5 //  |   <| | |_| ||  __/ | | |_| | | | | | | (_| | | | | (_|  __/
6 //  |_|\_\_|\__|\__\___|_| |_(_)_| |_|_| |_|\__,_|_| |_|\___\___|
7 //
8 pragma solidity ^0.5.16;
9 
10 library SafeMath {
11     function add(uint a, uint b) internal pure returns (uint) {
12         uint c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14 
15         return c;
16     }
17     function sub(uint a, uint b) internal pure returns (uint) {
18         return sub(a, b, "SafeMath: subtraction overflow");
19     }
20     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
21         require(b <= a, errorMessage);
22         uint c = a - b;
23 
24         return c;
25     }
26     function mul(uint a, uint b) internal pure returns (uint) {
27         if (a == 0) {
28             return 0;
29         }
30 
31         uint c = a * b;
32         require(c / a == b, "SafeMath: multiplication overflow");
33 
34         return c;
35     }
36     function div(uint a, uint b) internal pure returns (uint) {
37         return div(a, b, "SafeMath: division by zero");
38     }
39     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
40         // Solidity only automatically asserts when dividing by 0
41         require(b > 0, errorMessage);
42         uint c = a / b;
43 
44         return c;
45     }
46 }
47 
48 interface IUniswapV2Pair {
49     event Approval(address indexed owner, address indexed spender, uint value);
50     event Transfer(address indexed from, address indexed to, uint value);
51 
52     function name() external pure returns (string memory);
53     function symbol() external pure returns (string memory);
54     function decimals() external pure returns (uint8);
55     function totalSupply() external view returns (uint);
56     function balanceOf(address owner) external view returns (uint);
57     function allowance(address owner, address spender) external view returns (uint);
58 
59     function approve(address spender, uint value) external returns (bool);
60     function transfer(address to, uint value) external returns (bool);
61     function transferFrom(address from, address to, uint value) external returns (bool);
62 
63     function DOMAIN_SEPARATOR() external view returns (bytes32);
64     function PERMIT_TYPEHASH() external pure returns (bytes32);
65     function nonces(address owner) external view returns (uint);
66 
67     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
68 
69     event Mint(address indexed sender, uint amount0, uint amount1);
70     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
71     event Swap(
72         address indexed sender,
73         uint amount0In,
74         uint amount1In,
75         uint amount0Out,
76         uint amount1Out,
77         address indexed to
78     );
79     event Sync(uint112 reserve0, uint112 reserve1);
80 
81     function MINIMUM_LIQUIDITY() external pure returns (uint);
82     function factory() external view returns (address);
83     function token0() external view returns (address);
84     function token1() external view returns (address);
85     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
86     function price0CumulativeLast() external view returns (uint);
87     function price1CumulativeLast() external view returns (uint);
88     function kLast() external view returns (uint);
89 
90     function mint(address to) external returns (uint liquidity);
91     function burn(address to) external returns (uint amount0, uint amount1);
92     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
93     function skim(address to) external;
94     function sync() external;
95 
96     function initialize(address, address) external;
97 }
98 
99 interface kBASEv0 {
100   function allowance ( address owner, address spender ) external view returns ( uint256 );
101   function approve ( address spender, uint256 amount ) external returns ( bool );
102   function balanceOf ( address account ) external view returns ( uint256 );
103   function decimals (  ) external view returns ( uint8 );
104   function decreaseAllowance ( address spender, uint256 subtractedValue ) external returns ( bool );
105   function governance (  ) external view returns ( address );
106   function increaseAllowance ( address spender, uint256 addedValue ) external returns ( bool );
107   function monetaryPolicy (  ) external view returns ( address );
108   function name (  ) external view returns ( string memory );
109   function rebase ( uint256 epoch, int256 supplyDelta ) external returns ( uint256 );
110   function setGovernance ( address _governance ) external;
111   function setMonetaryPolicy ( address monetaryPolicy_ ) external;
112   function symbol (  ) external view returns ( string memory );
113   function totalSupply (  ) external view returns ( uint256 );
114   function transfer ( address recipient, uint256 amount ) external returns ( bool );
115   function transferFrom ( address sender, address recipient, uint256 amount ) external returns ( bool );
116 }
117 
118 contract kBASEPolicyV0 {
119     using SafeMath for uint;
120 
121     uint public constant PERIOD = 10 minutes; // will be 10 minutes in REAL CONTRACT
122 
123     IUniswapV2Pair public pair;
124     kBASEv0 public token;
125 
126     uint    public price0CumulativeLast = 0;
127     uint32  public blockTimestampLast = 0;
128     uint224 public price0RawAverage = 0;
129     
130     uint    public epoch = 0;
131 
132     constructor(address _pair) public {
133         pair = IUniswapV2Pair(_pair);
134         token = kBASEv0(pair.token0());
135         price0CumulativeLast = pair.price0CumulativeLast();
136         uint112 reserve0;
137         uint112 reserve1;
138         (reserve0, reserve1, blockTimestampLast) = pair.getReserves();
139         require(reserve0 != 0 && reserve1 != 0, 'NO_RESERVES');
140     }
141     
142     uint private constant MAX_INT256 = ~(uint(1) << 255);
143     function toInt256Safe(uint a) internal pure returns (int) {
144         require(a <= MAX_INT256);
145         return int(a);
146     }
147 
148     function rebase() external {
149         uint timestamp = block.timestamp;
150         require(timestamp % 3600 < 3 * 60); // rebase can only happen between XX:00:00 ~ XX:02:59 of every hour
151         
152         uint price0Cumulative = pair.price0CumulativeLast();
153         uint112 reserve0;
154         uint112 reserve1;
155         uint32 blockTimestamp;
156         (reserve0, reserve1, blockTimestamp) = pair.getReserves();
157         require(reserve0 != 0 && reserve1 != 0, 'NO_RESERVES');
158         
159         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
160 
161         // ensure that at least one full period has passed since the last update
162         require(timeElapsed >= PERIOD, 'PERIOD_NOT_ELAPSED');
163 
164         // overflow is desired, casting never truncates
165         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
166         price0RawAverage = uint224((price0Cumulative - price0CumulativeLast) / timeElapsed);
167 
168         price0CumulativeLast = price0Cumulative;
169         blockTimestampLast = blockTimestamp;
170         
171         // compute rebase
172         
173         uint price = price0RawAverage;
174         price = price.mul(10 ** 17).div(2 ** 112); // USDC decimals = 6, 100000 = 10^5, 18 - 6 + 5 = 17
175  
176         require(price != 100000, 'NO_NEED_TO_REBASE'); // don't rebase if price = 1.00000
177         
178         // rebase & sync
179         
180         if (price > 100000) { // positive rebase
181             uint delta = price.sub(100000);
182             token.rebase(epoch, toInt256Safe(token.totalSupply().mul(delta).div(100000 * 10))); // rebase using 10% of price delta
183         } 
184         else { // negative rebase
185             uint delta = 100000;
186             delta = delta.sub(price);
187             token.rebase(epoch, -toInt256Safe(token.totalSupply().mul(delta).div(100000 * 2))); // get out of "death spiral" ASAP
188         }
189         
190         pair.sync();
191         epoch = epoch.add(1);
192     }
193 }