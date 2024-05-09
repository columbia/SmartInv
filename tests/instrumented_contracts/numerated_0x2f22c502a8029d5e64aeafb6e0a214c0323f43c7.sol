1 pragma solidity 0.4.15;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 
37 /*
38  * @title This is proxy for analytics. Target contract can be found at field m_analytics (see "read contract").
39  * @author Eenae
40 
41  * FIXME after fix of truffle issue #560: refactor to a separate contract file which uses InvestmentAnalytics interface
42  */
43 contract AnalyticProxy {
44 
45     function AnalyticProxy() {
46         m_analytics = InvestmentAnalytics(msg.sender);
47     }
48 
49     /// @notice forward payment to analytics-capable contract
50     function() payable {
51         m_analytics.iaInvestedBy.value(msg.value)(msg.sender);
52     }
53 
54     InvestmentAnalytics public m_analytics;
55 }
56 
57 
58 /*
59  * @title Mixin contract which supports different payment channels and provides analytical per-channel data.
60  * @author Eenae
61  */
62 contract InvestmentAnalytics {
63     using SafeMath for uint256;
64 
65     function InvestmentAnalytics(){
66     }
67 
68     /// @dev creates more payment channels, up to the limit but not exceeding gas stipend
69     function createMorePaymentChannelsInternal(uint limit) internal returns (uint) {
70         uint paymentChannelsCreated;
71         for (uint i = 0; i < limit; i++) {
72             uint startingGas = msg.gas;
73             /*
74              * ~170k of gas per paymentChannel,
75              * using gas price = 4Gwei 2k paymentChannels will cost ~1.4 ETH.
76              */
77 
78             address paymentChannel = new AnalyticProxy();
79             m_validPaymentChannels[paymentChannel] = true;
80             m_paymentChannels.push(paymentChannel);
81             paymentChannelsCreated++;
82 
83             // cost of creating one channel
84             uint gasPerChannel = startingGas.sub(msg.gas);
85             if (gasPerChannel.add(50000) > msg.gas)
86                 break;  // enough proxies for this call
87         }
88         return paymentChannelsCreated;
89     }
90 
91 
92     /// @dev process payments - record analytics and pass control to iaOnInvested callback
93     function iaInvestedBy(address investor) external payable {
94         address paymentChannel = msg.sender;
95         if (m_validPaymentChannels[paymentChannel]) {
96             // payment received by one of our channels
97             uint value = msg.value;
98             m_investmentsByPaymentChannel[paymentChannel] = m_investmentsByPaymentChannel[paymentChannel].add(value);
99             // We know for sure that investment came from specified investor (see AnalyticProxy).
100             iaOnInvested(investor, value, true);
101         } else {
102             // Looks like some user has paid to this method, this payment is not included in the analytics,
103             // but, of course, processed.
104             iaOnInvested(msg.sender, msg.value, false);
105         }
106     }
107 
108     /// @dev callback
109     function iaOnInvested(address investor, uint payment, bool usingPaymentChannel) internal {
110     }
111 
112 
113     function paymentChannelsCount() external constant returns (uint) {
114         return m_paymentChannels.length;
115     }
116 
117     function readAnalyticsMap() external constant returns (address[], uint[]) {
118         address[] memory keys = new address[](m_paymentChannels.length);
119         uint[] memory values = new uint[](m_paymentChannels.length);
120 
121         for (uint i = 0; i < m_paymentChannels.length; i++) {
122             address key = m_paymentChannels[i];
123             keys[i] = key;
124             values[i] = m_investmentsByPaymentChannel[key];
125         }
126 
127         return (keys, values);
128     }
129 
130     function readPaymentChannels() external constant returns (address[]) {
131         return m_paymentChannels;
132     }
133 
134 
135     mapping(address => uint256) public m_investmentsByPaymentChannel;
136     mapping(address => bool) m_validPaymentChannels;
137 
138     address[] public m_paymentChannels;
139 }
140 
141 /**
142  * @title Helps contracts guard agains rentrancy attacks.
143  * @author Remco Bloemen <remco@2π.com>
144  * @notice If you mark a function `nonReentrant`, you should also
145  * mark it `external`.
146  */
147 contract ReentrancyGuard {
148 
149   /**
150    * @dev We use a single lock for the whole contract.
151    */
152   bool private rentrancy_lock = false;
153 
154   /**
155    * @dev Prevents a contract from calling itself, directly or indirectly.
156    * @notice If you mark a function `nonReentrant`, you should also
157    * mark it `external`. Calling one nonReentrant function from
158    * another is not supported. Instead, you can implement a
159    * `private` function doing the actual work, and a `external`
160    * wrapper marked as `nonReentrant`.
161    */
162   modifier nonReentrant() {
163     require(!rentrancy_lock);
164     rentrancy_lock = true;
165     _;
166     rentrancy_lock = false;
167   }
168 
169 }
170 
171 /**
172  * @title Ownable
173  * @dev The Ownable contract has an owner address, and provides basic authorization control
174  * functions, this simplifies the implementation of "user permissions".
175  */
176 contract Ownable {
177   address public owner;
178 
179 
180   /**
181    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
182    * account.
183    */
184   function Ownable() {
185     owner = msg.sender;
186   }
187 
188 
189   /**
190    * @dev Throws if called by any account other than the owner.
191    */
192   modifier onlyOwner() {
193     require(msg.sender == owner);
194     _;
195   }
196 
197 
198   /**
199    * @dev Allows the current owner to transfer control of the contract to a newOwner.
200    * @param newOwner The address to transfer ownership to.
201    */
202   function transferOwnership(address newOwner) onlyOwner {
203     if (newOwner != address(0)) {
204       owner = newOwner;
205     }
206   }
207 
208 }
209 
210 
211 contract STQToken {
212     function mint(address _to, uint256 _amount) external;
213 }
214 
215 /// @title Storiqa pre-ICO contract
216 contract STQPreICO is Ownable, ReentrancyGuard, InvestmentAnalytics {
217     using SafeMath for uint256;
218 
219     event FundTransfer(address backer, uint amount, bool isContribution);
220 
221     function STQPreICO(address token, address funds) {
222         require(address(0) != address(token) && address(0) != address(funds));
223 
224         m_token = STQToken(token);
225         m_funds = funds;
226     }
227 
228 
229     // PUBLIC interface: payments
230 
231     // fallback function as a shortcut
232     function() payable {
233         require(0 == msg.data.length);
234         buy();  // only internal call here!
235     }
236 
237     /// @notice ICO participation
238     function buy() public payable {     // dont mark as external!
239         iaOnInvested(msg.sender, msg.value, false);
240     }
241 
242 
243     // PUBLIC interface: maintenance
244 
245     function createMorePaymentChannels(uint limit) external onlyOwner returns (uint) {
246         return createMorePaymentChannelsInternal(limit);
247     }
248 
249     /// @notice Tests ownership of the current caller.
250     /// @return true if it's an owner
251     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
252     // addOwner/changeOwner and to isOwner.
253     function amIOwner() external constant onlyOwner returns (bool) {
254         return true;
255     }
256 
257 
258     // INTERNAL
259 
260     /// @dev payment callback
261     function iaOnInvested(address investor, uint payment, bool usingPaymentChannel)
262         internal
263         nonReentrant
264     {
265         require(payment >= c_MinInvestment);
266         require(getCurrentTime() >= c_startTime && getCurrentTime() < c_endTime || msg.sender == owner);
267 
268         uint startingInvariant = this.balance.add(m_funds.balance);
269 
270         // return or update payment if needed
271         uint paymentAllowed = getMaximumFunds().sub(m_totalInvested);
272         if (0 == paymentAllowed) {
273             investor.transfer(payment);
274             return;
275         }
276         uint change;
277         if (paymentAllowed < payment) {
278             change = payment.sub(paymentAllowed);
279             payment = paymentAllowed;
280         }
281 
282         // calculate rate
283         uint bonusPercent = c_preICOBonusPercent;
284         bonusPercent += getLargePaymentBonus(payment);
285         if (usingPaymentChannel)
286             bonusPercent += c_paymentChannelBonusPercent;
287 
288         uint rate = c_STQperETH.mul(100 + bonusPercent).div(100);
289 
290         // issue tokens
291         uint stq = payment.mul(rate);
292         m_token.mint(investor, stq);
293 
294         // record payment
295         m_funds.transfer(payment);
296         m_totalInvested = m_totalInvested.add(payment);
297         assert(m_totalInvested <= getMaximumFunds());
298         FundTransfer(investor, payment, true);
299 
300         if (change > 0)
301             investor.transfer(change);
302 
303         assert(startingInvariant == this.balance.add(m_funds.balance).add(change));
304     }
305 
306     function getLargePaymentBonus(uint payment) private constant returns (uint) {
307         if (payment > 1000 ether) return 10;
308         if (payment > 800 ether) return 8;
309         if (payment > 500 ether) return 5;
310         if (payment > 200 ether) return 2;
311         return 0;
312     }
313 
314     /// @dev to be overridden in tests
315     function getCurrentTime() internal constant returns (uint) {
316         return now;
317     }
318 
319     /// @dev to be overridden in tests
320     function getMaximumFunds() internal constant returns (uint) {
321         return c_MaximumFunds;
322     }
323 
324 
325     // FIELDS
326 
327     /// @notice start time of the pre-ICO
328     uint public constant c_startTime = 1507766400;
329 
330     /// @notice end time of the pre-ICO
331     uint public constant c_endTime = c_startTime + (1 days);
332 
333     /// @notice minimum investment
334     uint public constant c_MinInvestment = 10 finney;
335 
336     /// @notice maximum investments to be accepted during pre-ICO
337     uint public constant c_MaximumFunds = 8000 ether;
338 
339 
340     /// @notice starting exchange rate of STQ
341     uint public constant c_STQperETH = 100000;
342 
343     /// @notice pre-ICO bonus
344     uint public constant c_preICOBonusPercent = 40;
345 
346     /// @notice authorised payment bonus
347     uint public constant c_paymentChannelBonusPercent = 2;
348 
349 
350     /// @dev total investments amount
351     uint public m_totalInvested;
352 
353     /// @dev contract responsible for token accounting
354     STQToken public m_token;
355 
356     /// @dev address responsible for investments accounting
357     address public m_funds;
358 }