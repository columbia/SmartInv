1 pragma solidity 0.4.26;
2 
3 
4 contract DSMath {
5     
6     /*
7     standard uint256 functions
8      */
9 
10     function add(uint256 x, uint256 y) pure internal returns (uint256 z) {
11         assert((z = x + y) >= x);
12     }
13 
14     function sub(uint256 x, uint256 y) pure internal returns (uint256 z) {
15         assert((z = x - y) <= x);
16     }
17 
18     function mul(uint256 x, uint256 y) pure internal returns (uint256 z) {
19         assert((z = x * y) >= x);
20     }
21     
22     function div(uint256 x, uint256 y) pure internal returns (uint256 z) {
23         require(y > 0);
24         z = x / y;
25     }
26     
27     function min(uint256 x, uint256 y) pure internal returns (uint256 z) {
28         return x <= y ? x : y;
29     }
30     function max(uint256 x, uint256 y) pure internal returns (uint256 z) {
31         return x >= y ? x : y;
32     }
33 
34     /*
35     uint128 functions (h is for half)
36      */
37 
38 
39     function hadd(uint128 x, uint128 y) pure internal returns (uint128 z) {
40         assert((z = x + y) >= x);
41     }
42 
43     function hsub(uint128 x, uint128 y) pure internal returns (uint128 z) {
44         assert((z = x - y) <= x);
45     }
46 
47     function hmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
48         assert((z = x * y) >= x);
49     }
50 
51     function hdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
52         assert(y > 0);
53         z = x / y;
54     }
55 
56     function hmin(uint128 x, uint128 y) pure internal returns (uint128 z) {
57         return x <= y ? x : y;
58     }
59     function hmax(uint128 x, uint128 y) pure internal returns (uint128 z) {
60         return x >= y ? x : y;
61     }
62 
63 
64     /*
65     int256 functions
66      */
67 
68     function imin(int256 x, int256 y) pure internal returns (int256 z) {
69         return x <= y ? x : y;
70     }
71     function imax(int256 x, int256 y) pure internal returns (int256 z) {
72         return x >= y ? x : y;
73     }
74 
75     /*
76     WAD math
77      */
78 
79     uint128 constant WAD = 10 ** 18;
80 
81     function wadd(uint128 x, uint128 y) pure internal returns (uint128) {
82         return hadd(x, y);
83     }
84 
85     function wsub(uint128 x, uint128 y) pure internal returns (uint128) {
86         return hsub(x, y);
87     }
88 
89     function wmul(uint128 x, uint128 y) view internal returns (uint128 z) {
90         z = cast((uint256(x) * y + WAD / 2) / WAD);
91     }
92 
93     function wdiv(uint128 x, uint128 y) view internal returns (uint128 z) {
94         z = cast((uint256(x) * WAD + y / 2) / y);
95     }
96 
97     function wmin(uint128 x, uint128 y) pure internal returns (uint128) {
98         return hmin(x, y);
99     }
100     function wmax(uint128 x, uint128 y) pure internal returns (uint128) {
101         return hmax(x, y);
102     }
103 
104     /*
105     RAY math
106      */
107 
108     uint128 constant RAY = 10 ** 27;
109 
110     function radd(uint128 x, uint128 y) pure internal returns (uint128) {
111         return hadd(x, y);
112     }
113 
114     function rsub(uint128 x, uint128 y) pure internal returns (uint128) {
115         return hsub(x, y);
116     }
117 
118     function rmul(uint128 x, uint128 y) view internal returns (uint128 z) {
119         z = cast((uint256(x) * y + RAY / 2) / RAY);
120     }
121 
122     function rdiv(uint128 x, uint128 y) view internal returns (uint128 z) {
123         z = cast((uint256(x) * RAY + y / 2) / y);
124     }
125 
126     function rpow(uint128 x, uint64 n) view internal returns (uint128 z) {
127         // This famous algorithm is called "exponentiation by squaring"
128         // and calculates x^n with x as fixed-point and n as regular unsigned.
129         //
130         // It's O(log n), instead of O(n) for naive repeated multiplication.
131         //
132         // These facts are why it works:
133         //
134         //  If n is even, then x^n = (x^2)^(n/2).
135         //  If n is odd,  then x^n = x * x^(n-1),
136         //   and applying the equation for even x gives
137         //    x^n = x * (x^2)^((n-1) / 2).
138         //
139         //  Also, EVM division is flooring and
140         //    floor[(n-1) / 2] = floor[n / 2].
141 
142         z = n % 2 != 0 ? x : RAY;
143 
144         for (n /= 2; n != 0; n /= 2) {
145             x = rmul(x, x);
146 
147             if (n % 2 != 0) {
148                 z = rmul(z, x);
149             }
150         }
151     }
152 
153     function rmin(uint128 x, uint128 y) pure internal returns (uint128) {
154         return hmin(x, y);
155     }
156     function rmax(uint128 x, uint128 y) pure internal returns (uint128) {
157         return hmax(x, y);
158     }
159 
160     function cast(uint256 x) pure internal returns (uint128 z) {
161         assert((z = uint128(x)) == x);
162     }
163 
164 }
165 
166 contract ERC20Basic {
167   uint256 public totalSupply;
168   function balanceOf(address who) public view returns (uint256);
169   function transfer(address to, uint256 value) public returns (bool);
170   event Transfer(address indexed from, address indexed to, uint256 value);
171 }
172 
173 contract ERC20 is ERC20Basic {
174   function allowance(address owner, address spender) public view returns (uint256);
175   function transferFrom(address from, address to, uint256 value) public returns (bool);
176   function approve(address spender, uint256 value) public returns (bool);
177   event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 contract WETH is ERC20 {
181     function deposit() public payable;
182     function withdraw(uint wad) public;
183     event  Deposit(address indexed dst, uint wad);
184     event  Withdrawal(address indexed src, uint wad);
185 }
186 
187 interface UniswapExchangeInterface {
188     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
189     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
190 }
191 
192 interface OracleInterface {
193   function bill() external view returns (uint256);
194   function update(uint128 payment_, address token_) external;
195   function peek() external view returns (bytes32,bool);
196   function read() external view returns (bytes32);
197   function expiry() external view returns (uint32);
198   function timeout() external view returns (uint32);
199 }
200 
201 interface MedianizerInterface {
202     function oracles(uint256) public view returns (address);
203     function peek() public view returns (bytes32, bool);
204     function read() public returns (bytes32);
205     function poke() public;
206     function poke(bytes32) public;
207     function fund (uint256 amount, ERC20 token) public;
208 }
209 
210 contract FundOracles is DSMath {
211   ERC20 link;
212   WETH weth;
213   UniswapExchangeInterface uniswapExchange;
214 
215   MedianizerInterface med;
216 
217   /**
218     * @notice Construct a new Fund Oracles contract
219     * @param med_ The address of the Medianizer
220     * @param link_ The LINK token address
221     * @param weth_ The WETH token address
222     * @param uniswapExchange_ The address of the LINK to ETH Uniswap Exchange
223     */
224   constructor(MedianizerInterface med_, ERC20 link_, WETH weth_, UniswapExchangeInterface uniswapExchange_) public {
225     med = med_;
226     link = link_;
227     weth = weth_;
228     uniswapExchange = uniswapExchange_;
229   }
230 
231   /**
232     * @notice Determines the last oracle token payment
233     * @param oracle_ Index of oracle
234     * @return Last payment to oracle in token (LINK for Chainlink, WETH for Oraclize)
235     */
236   function billWithEth(uint256 oracle_) public view returns (uint256) {
237       return OracleInterface(med.oracles(oracle_)).bill();
238   }
239 
240   /**
241     * @notice Determines the payment amount in ETH
242     * @param oracle_ Index of oracle
243     * @param payment_ Payment amount in tokens (LINK or WETH)
244     * @return Amount of ETH to pay in updateWithEth to update Oracle
245     */
246   function paymentWithEth(uint256 oracle_, uint128 payment_) public view returns(uint256) {
247       if (oracle_ < 5) {
248           return uniswapExchange.getEthToTokenOutputPrice(payment_);
249       } else {
250           return uint(payment_);
251       }
252   }
253 
254   /**
255     * @notice Update the Oracle using ETH
256     * @param oracle_ Index of oracle
257     * @param payment_ Payment amount in tokens (LINK or WETH)
258     * @param token_ Address of token to receive as a reward for updating Oracle
259     */
260   function updateWithEth(uint256 oracle_, uint128 payment_, address token_) public payable {
261     address oracleAddress = med.oracles(oracle_);
262     OracleInterface oracle = OracleInterface(oracleAddress);
263     if (oracle_ < 5) {
264       // ChainLink Oracle
265       uint256 ethPayment = uniswapExchange.getEthToTokenOutputPrice(uint(payment_));
266       require(msg.value >= ethPayment, "Insufficient ETH for LINK conversion for payment");
267       uniswapExchange.ethToTokenSwapOutput.value(ethPayment)(uint(payment_), now + 300);
268       link.approve(oracleAddress, uint(payment_));
269       oracle.update(payment_, token_);
270       msg.sender.transfer(msg.value - ethPayment);
271     } else {
272       // Oraclize Oracle
273       weth.deposit.value(msg.value)();
274       weth.approve(oracleAddress, uint(payment_));
275       oracle.update(payment_, token_);
276     }
277   }
278 }