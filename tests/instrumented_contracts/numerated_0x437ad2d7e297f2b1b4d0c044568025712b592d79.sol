1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    */
39   function renounceOwnership() public onlyOwner {
40     emit OwnershipRenounced(owner);
41     owner = address(0);
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param _newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address _newOwner) public onlyOwner {
49     _transferOwnership(_newOwner);
50   }
51 
52   /**
53    * @dev Transfers control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function _transferOwnership(address _newOwner) internal {
57     require(_newOwner != address(0));
58     emit OwnershipTransferred(owner, _newOwner);
59     owner = _newOwner;
60   }
61 }
62 
63 
64 
65 
66 
67 
68 
69 
70 /**
71  * @title SafeMath
72  * @dev Math operations with safety checks that throw on error
73  */
74 library SafeMath {
75 
76   /**
77   * @dev Multiplies two numbers, throws on overflow.
78   */
79   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
80     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
81     // benefit is lost if 'b' is also tested.
82     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
83     if (a == 0) {
84       return 0;
85     }
86 
87     c = a * b;
88     assert(c / a == b);
89     return c;
90   }
91 
92   /**
93   * @dev Integer division of two numbers, truncating the quotient.
94   */
95   function div(uint256 a, uint256 b) internal pure returns (uint256) {
96     // assert(b > 0); // Solidity automatically throws when dividing by 0
97     // uint256 c = a / b;
98     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99     return a / b;
100   }
101 
102   /**
103   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
104   */
105   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106     assert(b <= a);
107     return a - b;
108   }
109 
110   /**
111   * @dev Adds two numbers, throws on overflow.
112   */
113   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
114     c = a + b;
115     assert(c >= a);
116     return c;
117   }
118 }
119 
120 
121 
122 contract ExchangeOracle is Ownable {
123 
124     using SafeMath for uint256;
125 
126     uint256 public rate;
127     uint256 public lastRate;
128     uint256 public rateMultiplier = 1000;
129     uint256 public usdMultiplier = 100;
130     address public admin;
131 
132     event RateChanged(uint256 _oldRate, uint256 _newRate);
133     event RateMultiplierChanged(uint256 _oldRateMultiplier, uint256 _newRateMultiplier);
134     event USDMultiplierChanged(uint256 _oldUSDMultiplier, uint256 _newUSDMultiplier);
135     event AdminChanged(address _oldAdmin, address _newAdmin);
136 
137     constructor(address _initialAdmin, uint256 _initialRate) public {
138         require(_initialAdmin != address(0), "Invalid initial admin address");
139         require(_initialRate > 0, "Invalid initial rate value");
140 
141         admin = _initialAdmin;
142         rate = _initialRate;
143         lastRate = _initialRate;
144     }
145 
146     modifier onlyAdmin() {
147         require(msg.sender == admin, "Not allowed to execute");
148         _;
149     }
150 
151     /*
152      * The new rate has to be passed in format:
153      *      250.567 rate = 250 567 passed rate ( 1 ether = 250.567 USD )
154      *      100 rate = 100 000 passed rate ( 1 ether = 100 USD )
155      *      1 rate = 1 000 passed rate ( 1 ether = 1 USD )
156      *      0.01 rate = 10 passed rate ( 100 ethers = 1 USD )
157      */
158     function setRate(uint256 _newRate) public onlyAdmin {
159         require(_newRate > 0, "Invalid rate value");
160 
161         lastRate = rate;
162         rate = _newRate;
163 
164         emit RateChanged(lastRate, _newRate);
165     }
166 
167     /*
168      * By default rateMultiplier = 1000.
169      * With rate multiplier we can set the rate to be a float number.
170      *
171      * We use it as a multiplier because we can not pass float numbers in Ethereum.
172      * If the USD price becomes bigger than ether one, for example -> 1 USD = 10 ethers.
173      * We will pass 100 as rate and this will be relevant to 0.1 USD = 1 ether.
174      */
175     function setRateMultiplier(uint256 _newRateMultiplier) public onlyAdmin {
176         require(_newRateMultiplier > 0, "Invalid rate multiplier value");
177 
178         uint256 oldRateMultiplier = rateMultiplier;
179         rateMultiplier = _newRateMultiplier;
180 
181         emit RateMultiplierChanged(oldRateMultiplier, _newRateMultiplier);
182     }
183 
184     /*
185      * By default usdMultiplier is = 100.
186      * With usd multiplier we can set the usd amount to be a float number.
187      *
188      * We use it as a multiplier because we can not pass float numbers in Ethereum.
189      * We will pass 100 as usd amount and this will be relevant to 1 USD.
190      */
191     function setUSDMultiplier(uint256 _newUSDMultiplier) public onlyAdmin {
192         require(_newUSDMultiplier > 0, "Invalid USD multiplier value");
193 
194         uint256 oldUSDMultiplier = usdMultiplier;
195         usdMultiplier = _newUSDMultiplier;
196 
197         emit USDMultiplierChanged(oldUSDMultiplier, _newUSDMultiplier);
198     }
199 
200     /*
201      * Set address with admin rights, allowed to execute:
202      *    - setRate()
203      *    - setRateMultiplier()
204      *    - setUSDMultiplier()
205      */
206     function setAdmin(address _newAdmin) public onlyOwner {
207         require(_newAdmin != address(0), "Invalid admin address");
208 
209         address oldAdmin = admin;
210         admin = _newAdmin;
211 
212         emit AdminChanged(oldAdmin, _newAdmin);
213     }
214 
215 }
216 
217 
218 contract TokenExchangeOracle is ExchangeOracle {
219 
220     constructor(address _admin, uint256 _initialRate) ExchangeOracle(_admin, _initialRate) public {}
221 
222     /*
223      * Converts the specified USD amount in tokens (usdAmount is multiplied by
224      * corresponding usdMultiplier value, which by default is 100).
225      */
226     function convertUSDToTokens(uint256 _usdAmount) public view returns (uint256) {
227         return usdToTokens(_usdAmount, rate);
228     }
229 
230     /*
231      * Converts the specified USD amount in tokens (usdAmount is multiplied by
232      * corresponding usdMultiplier value, which by default is 100) using the
233      * lastRate value for the calculation.
234      */
235     function convertUSDToTokensByLastRate(uint256 _usdAmount) public view returns (uint256) {
236         return usdToTokens(_usdAmount, lastRate);
237     }
238 
239     /*
240      * Converts the specified USD amount in tokens.
241      *
242      * Example:
243      *    Token/USD -> 298.758
244      *    convert -> 39.99 USD
245      *
246      *               usdAmount     rateMultiplier
247      *    tokens = ------------- * -------------- * ONE_ETHER_IN_WEI
248      *             usdMultiplier        rate
249      *
250      */
251     function usdToTokens(uint256 _usdAmount, uint256 _rate) internal view returns (uint256) {
252         require(_usdAmount > 0, "Invalid USD amount");
253 
254         uint256 tokens = _usdAmount.mul(rateMultiplier);
255         tokens = tokens.mul(1 ether);
256         tokens = tokens.div(usdMultiplier);
257         tokens = tokens.div(_rate);
258 
259         return tokens;
260     }
261 
262     /*
263      * Converts the specified tokens amount in USD. The returned value is multiplied
264      * by the usdMultiplier value, which is by default 100.
265      */
266     function convertTokensToUSD(uint256 _tokens) public view returns (uint256) {
267         return tokensToUSD(_tokens, rate);
268     }
269 
270     /*
271      * Converts the specified tokens amount in USD, using the lastRate value for the
272      * calculation. The returned value is multiplied by the usdMultiplier value,
273      * which is by default 100.
274      */
275     function convertTokensToUSDByLastRate(uint256 _tokens) public view returns (uint256) {
276         return tokensToUSD(_tokens, lastRate);
277     }
278 
279     /*
280      * Converts the specified tokens amount in USD.
281      *
282      *                     tokens             rate
283      *    usdAmount = ---------------- * -------------- * usdMultiplier
284      *                ONE_ETHER_IN_WEI   rateMultiplier
285      *
286      */
287     function tokensToUSD(uint256 _tokens, uint256 _rate) internal view returns (uint256) {
288         require(_tokens > 0, "Invalid token amount");
289 
290         uint256 usdAmount = _tokens.mul(_rate);
291         usdAmount = usdAmount.mul(usdMultiplier);
292         usdAmount = usdAmount.div(rateMultiplier);
293         usdAmount = usdAmount.div(1 ether);
294 
295         return usdAmount;
296     }
297 
298 }