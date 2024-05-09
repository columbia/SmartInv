1 pragma solidity 0.4.25;
2 
3 // File: contracts/SafeMath.sol
4 
5 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
6 
7 // @title SafeMath: overflow/underflow checks
8 // @notice Math operations with safety checks that throw on error
9 library SafeMath {
10 
11   // @notice Multiplies two numbers, throws on overflow.
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   // @notice Integer division of two numbers, truncating the quotient.
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     // uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return a / b;
27   }
28 
29   // @notice Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   // @notice Adds two numbers, throws on overflow.
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 
42 }
43 
44 // File: contracts/ERC20Interface.sol
45 
46 // ----------------------------------------------------------------------------
47 // ERC Token Standard #20 Interface
48 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
49 // ----------------------------------------------------------------------------
50 interface ERC20Interface {
51     function totalSupply() external returns (uint);
52     function balanceOf(address tokenOwner) external returns (uint balance);
53     function allowance(address tokenOwner, address spender) external returns (uint remaining);
54     function transfer(address to, uint tokens) external returns (bool success);
55     function approve(address spender, uint tokens) external returns (bool success);
56     function transferFrom(address from, address to, uint tokens) external returns (bool success);
57     function burn(uint _amount) external returns (bool success);
58     function burnFrom(address _from, uint _amount) external returns (bool success);
59 
60     event Transfer(address indexed from, address indexed to, uint tokens);
61     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
62     event LogBurn(address indexed _spender, uint256 _value);
63 }
64 
65 // File: contracts/TokenSale.sol
66 
67 // @title MyBit Tokensale
68 // @notice A tokensale extending for 365 days. (0....364)
69 // @notice 100,000 MYB are releases everyday and split proportionaly to funders of that day
70 // @notice Anyone can fund the current or future days with ETH
71 // @dev The current day is (timestamp - startTimestamp) / 24 hours
72 // @author Kyle Dewhurst, MyBit Foundation
73 contract TokenSale {
74   using SafeMath for *;
75 
76   ERC20Interface mybToken;
77 
78   struct Day {
79     uint totalWeiContributed;
80     mapping (address => uint) weiContributed;
81   }
82 
83   // Constants
84   uint256 constant internal scalingFactor = 10**32;      // helps avoid rounding errors
85   uint256 constant public tokensPerDay = 10**23;    // 100,000 MYB
86 
87   // MyBit addresses
88   address public owner;
89   address public mybitFoundation;
90   address public developmentFund;
91 
92   uint256 public start;      // The timestamp when sale starts
93 
94   mapping (uint16 => Day) public day;
95 
96   constructor(address _mybToken, address _mybFoundation, address _developmentFund)
97   public {
98     mybToken = ERC20Interface(_mybToken);
99     developmentFund = _developmentFund;
100     mybitFoundation = _mybFoundation;
101     owner = msg.sender;
102   }
103 
104   // @notice owner can start the sale by transferring in required amount of MYB
105   // @dev the start time is used to determine which day the sale is on (day 0 = first day)
106   function startSale(uint _timestamp)
107   external
108   onlyOwner
109   returns (bool){
110     require(start == 0, 'Already started');
111     require(_timestamp >= now  && _timestamp.sub(now) < 2592000, 'Start time not in range');
112     uint saleAmount = tokensPerDay.mul(365);
113     require(mybToken.transferFrom(msg.sender, address(this), saleAmount));
114     start = _timestamp;
115     emit LogSaleStarted(msg.sender, mybitFoundation, developmentFund, saleAmount, _timestamp);
116     return true;
117   }
118 
119 
120   // @notice contributor can contribute wei to sale on any current/future _day
121   // @dev only accepts contributions between days 0 - 364
122   function fund(uint16 _day)
123   payable
124   public
125   returns (bool) {
126       require(addContribution(msg.sender, msg.value, _day));
127       return true;
128   }
129 
130   // @notice Send an index of days and your payment will be divided equally among them
131   // @dev WEI sent must divide equally into number of days.
132   function batchFund(uint16[] _day)
133   payable
134   external
135   returns (bool) {
136     require(_day.length <= 50);       // Limit to 50 days to avoid exceeding blocklimit
137     require(msg.value >= _day.length);   // need at least 1 wei per day
138     uint256 amountPerDay = msg.value.div(_day.length);
139     assert (amountPerDay.mul(_day.length) == msg.value);   // Don't allow any rounding error
140     for (uint8 i = 0; i < _day.length; i++){
141       require(addContribution(msg.sender, amountPerDay, _day[i]));
142     }
143     return true;
144   }
145 
146 
147   // @notice Updates claimableTokens, sends all wei to the token holder
148   function withdraw(uint16 _day)
149   external
150   returns (bool) {
151       require(dayFinished(_day), "day has not finished funding");
152       Day storage thisDay = day[_day];
153       uint256 amount = getTokensOwed(msg.sender, _day);
154       delete thisDay.weiContributed[msg.sender];
155       mybToken.transfer(msg.sender, amount);
156       emit LogTokensCollected(msg.sender, amount, _day);
157       return true;
158   }
159 
160   // @notice Updates claimableTokens, sends all tokens to contributor from previous days
161   // @param (uint16[]) _day, list of token sale days msg.sender contributed wei towards
162   function batchWithdraw(uint16[] _day)
163   external
164   returns (bool) {
165     uint256 amount;
166     require(_day.length <= 50);     // Limit to 50 days to avoid exceeding blocklimit
167     for (uint8 i = 0; i < _day.length; i++){
168       require(dayFinished(_day[i]));
169       uint256 amountToAdd = getTokensOwed(msg.sender, _day[i]);
170       amount = amount.add(amountToAdd);
171       delete day[_day[i]].weiContributed[msg.sender];
172       emit LogTokensCollected(msg.sender, amountToAdd, _day[i]);
173     }
174     mybToken.transfer(msg.sender, amount);
175     return true;
176   }
177 
178   // @notice owner can withdraw funds to the foundation wallet and ddf wallet
179   // @param (uint) _amount, The amount of wei to withdraw
180   // @dev must put in an _amount equally divisible by 2
181   function foundationWithdraw(uint _amount)
182   external
183   onlyOwner
184   returns (bool){
185     uint256 half = _amount.div(2);
186     assert (half.mul(2) == _amount);   // check for rounding error
187     mybitFoundation.transfer(half);
188     developmentFund.transfer(half);
189     emit LogFoundationWithdraw(msg.sender, _amount, dayFor(now));
190     return true;
191   }
192 
193   // @notice updates ledger with the contribution from _investor
194   // @param (address) _investor: The sender of WEI to the contract
195   // @param (uint) _amount: The amount of WEI to add to _day
196   // @param (uint16) _day: The day to fund
197   function addContribution(address _investor, uint _amount, uint16 _day)
198   internal
199   returns (bool) {
200     require(_amount > 0, "must send ether with the call");
201     require(duringSale(_day), "day is not during the sale");
202     require(!dayFinished(_day), "day has already finished");
203     Day storage today = day[_day];
204     today.totalWeiContributed = today.totalWeiContributed.add(_amount);
205     today.weiContributed[_investor] = today.weiContributed[_investor].add(_amount);
206     emit LogTokensPurchased(_investor, _amount, _day);
207     return true;
208   }
209 
210   // @notice Calculates how many tokens user is owed. (userContribution / totalContribution) * tokensPerDay
211   function getTokensOwed(address _contributor, uint16 _day)
212   public
213   view
214   returns (uint256) {
215       require(dayFinished(_day));
216       Day storage thisDay = day[_day];
217       uint256 percentage = thisDay.weiContributed[_contributor].mul(scalingFactor).div(thisDay.totalWeiContributed);
218       return percentage.mul(tokensPerDay).div(scalingFactor);
219   }
220 
221   // @notice gets the total amount of mybit owed to the contributor
222   // @dev this function doesn't check for duplicate days. Output may not reflect actual amount owed if this happens.
223   function getTotalTokensOwed(address _contributor, uint16[] _days)
224   public
225   view
226   returns (uint256 amount) {
227     require(_days.length < 100);          // Limit to 100 days to avoid exceeding block gas limit
228     for (uint16 i = 0; i < _days.length; i++){
229       amount = amount.add(getTokensOwed(_contributor, _days[i]));
230     }
231     return amount;
232   }
233 
234   // @notice returns the amount of wei contributed by _contributor on _day
235   function getWeiContributed(uint16 _day, address _contributor)
236   public
237   view
238   returns (uint256) {
239     return day[_day].weiContributed[_contributor];
240   }
241 
242   // @notice returns amount of wei contributed on _day
243   // @dev if _day is outside of tokensale range it will return 0
244   function getTotalWeiContributed(uint16 _day)
245   public
246   view
247   returns (uint256) {
248     return day[_day].totalWeiContributed;
249   }
250 
251   // @notice return the day associated with this timestamp
252   function dayFor(uint _timestamp)
253   public
254   view
255   returns (uint16) {
256       require(_timestamp >= start);
257       return uint16(_timestamp.sub(start).div(86400));
258   }
259 
260   // @notice returns true if _day is finished
261   function dayFinished(uint16 _day)
262   public
263   view
264   returns (bool) {
265     if (now <= start) { return false; }   // hasn't yet reached first day, so cannot be finished
266     return dayFor(now) > _day;
267   }
268 
269   // @notice reverts if the current day isn't less than 365
270   function duringSale(uint16 _day)
271   public
272   view
273   returns (bool){
274     return start > 0 && _day <= uint16(364);
275   }
276 
277 
278   // @notice return the current day
279   function currentDay()
280   public
281   view
282   returns (uint16) {
283     return dayFor(now);
284   }
285 
286   // @notice Fallback function: Purchases contributor stake in the tokens for the current day
287   // @dev rejects contributions by means of the fallback function until timestamp > start
288   function ()
289   external
290   payable {
291       require(addContribution(msg.sender, msg.value, currentDay()));
292   }
293 
294   // @notice only owner address can call
295   modifier onlyOwner {
296     require(msg.sender == owner);
297     _;
298   }
299 
300   event LogSaleStarted(address _owner, address _mybFoundation, address _developmentFund, uint _totalMYB, uint _startTime);
301   event LogFoundationWithdraw(address _mybFoundation, uint _amount, uint16 _day);
302   event LogTokensPurchased(address indexed _contributor, uint _amount, uint16 indexed _day);
303   event LogTokensCollected(address indexed _contributor, uint _amount, uint16 indexed _day);
304 
305 }