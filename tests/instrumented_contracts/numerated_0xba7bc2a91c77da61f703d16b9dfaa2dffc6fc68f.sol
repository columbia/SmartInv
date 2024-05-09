1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   /**
26   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27   */
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   /**
34   * @dev Adds two numbers, throws on overflow.
35   */
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 contract Ownable {
58   address public owner;
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   constructor() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 contract CryptoProtect is Ownable {
91     using SafeMath for uint256;
92     
93     ERC20Interface tokenInterface;
94     
95     // Policy State --
96     // 1 - active
97     // 2 - inactive
98     // 3 - claimed
99     struct Policy {
100         uint256 premiumAmount;
101         uint256 payoutAmount;
102         uint256 endDate;
103         uint8 state;
104     }
105     
106     struct Token {
107         mapping (string => Policy) token;
108     }
109     
110     struct Exchange {
111         mapping (string => Token) exchange;
112     }
113     
114     struct Pool{
115         uint256 endDate;
116         uint256 amount;
117     }
118     
119     mapping(address => Exchange) policies;
120     
121     Pool[]              private poolRecords;
122     uint                private poolRecordsIndex;
123     uint256             private poolBackedAmount;
124     
125     // poolState state --
126     // 1 - active
127     // 2 - not active
128     uint8               public poolState;
129     uint256             public poolMaxAmount;
130     uint256             public poolStartDate;
131     
132     uint256             public minPremium;
133     uint256             public maxPremium;
134     
135     string             public contractName;
136     
137     event PoolStateUpdate(uint8 indexed state);
138     event PremiumReceived(address indexed addr, uint256 indexed amount, uint indexed id);
139     event ClaimSubmitted(address indexed addr, string indexed exchange, string indexed token);
140     event ClaimPayout(address indexed addr, string indexed exchange, string indexed token);
141     event PoolBackedAmountUpdate(uint256 indexed amount);
142     event PoolPremiumLimitUpdate(uint256 indexed min, uint256 indexed max);
143 
144     constructor(
145         string _contractName,
146         address _tokenContract,
147         uint256 _poolMaxAmount,
148         uint256 _poolBackedAmount,
149         uint256 _minPremium,
150         uint256 _maxPremium
151     )
152         public
153     {
154         contractName = _contractName;
155         tokenInterface = ERC20Interface(_tokenContract);
156         
157         poolState = 1;
158         poolStartDate = now;
159         poolMaxAmount = _poolMaxAmount;
160         poolBackedAmount = _poolBackedAmount;
161         
162         minPremium = _minPremium;
163         maxPremium = _maxPremium;
164     }
165     
166     /**
167      * @dev Modifier to check pool state
168      */
169     modifier verifyPoolState() {
170         require(poolState == 1);
171         _;
172     }
173     
174     /**
175      * @dev Check policy eligibility
176      */
177     function isEligible(address _addr, string _exchange, string _token) internal view 
178         returns (bool)
179     {
180         if (
181             policies[_addr].exchange[_exchange].token[_token].state == 0 ||
182             policies[_addr].exchange[_exchange].token[_token].endDate < now
183         ) {
184             return true;
185         }
186         
187         return false;
188     }
189     
190     /**
191      * @dev Compute Pool Amount
192      */
193     function computePoolAmount() internal view 
194         returns (uint256)
195     {
196         uint256 currentPoolAmount = 0;
197         
198         // limited by gas
199         for (uint i = poolRecordsIndex; i< poolRecords.length; i++) {
200             if (poolRecords[i].endDate < now) {
201                 continue;
202             }
203             
204             currentPoolAmount = currentPoolAmount.add(poolRecords[i].amount);
205         }
206         
207         return currentPoolAmount.add(poolBackedAmount);
208     }
209     
210     /**
211      * @dev Make Transaction
212      * Make transaction using transferFrom
213      */
214     function MakeTransaction(
215         address _tokenOwner,
216         uint256 _premiumAmount,
217         uint256 _payoutAmount,
218         string _exchange,
219         string _token,
220         uint8 _id
221     ) 
222         external
223         verifyPoolState()
224     {
225         // check parameters
226         require(_tokenOwner != address(0));
227         
228         require(_premiumAmount < _payoutAmount);
229         require(_premiumAmount >= minPremium);
230         require(_premiumAmount <= maxPremium);
231         
232         require(bytes(_exchange).length > 0);
233         require(bytes(_token).length > 0);
234         require(_id > 0);
235         
236         // require(computePoolAmount() < poolMaxAmount); // reduce cost
237         
238         // check eligibility
239         require(isEligible(_tokenOwner, _exchange, _token));
240         
241         // check that token owner address has valid amount
242         require(tokenInterface.balanceOf(_tokenOwner) >= _premiumAmount);
243         require(tokenInterface.allowance(_tokenOwner, address(this)) >= _premiumAmount);
244         
245         // record data
246         policies[_tokenOwner].exchange[_exchange].token[_token].premiumAmount = _premiumAmount;
247         policies[_tokenOwner].exchange[_exchange].token[_token].payoutAmount = _payoutAmount;
248         policies[_tokenOwner].exchange[_exchange].token[_token].endDate = now.add(90 * 1 days);
249         policies[_tokenOwner].exchange[_exchange].token[_token].state = 1;
250         
251         // record pool
252         poolRecords.push(Pool(now.add(90 * 1 days), _premiumAmount));
253         
254         // transfer amount
255         tokenInterface.transferFrom(_tokenOwner, address(this), _premiumAmount);
256         
257         emit PremiumReceived(_tokenOwner, _premiumAmount, _id);
258     }
259     
260     /**
261      * @dev Get Policy
262      */
263     function GetPolicy(address _addr, string _exchange, string _token) public view 
264         returns (
265             uint256 premiumAmount,
266             uint256 payoutAmount,
267             uint256 endDate,
268             uint8 state
269         )
270     {
271         return (
272             policies[_addr].exchange[_exchange].token[_token].premiumAmount,
273             policies[_addr].exchange[_exchange].token[_token].payoutAmount,
274             policies[_addr].exchange[_exchange].token[_token].endDate,
275             policies[_addr].exchange[_exchange].token[_token].state
276         );
277     }
278     
279     /**
280      * @dev Get Policy
281      */
282     function SubmitClaim(address _addr, string _exchange, string _token) public 
283         returns (bool submitted)
284     {
285         require(policies[_addr].exchange[_exchange].token[_token].state == 1);
286         require(policies[_addr].exchange[_exchange].token[_token].endDate > now);
287         
288         emit ClaimSubmitted(_addr, _exchange, _token);
289         
290         return true;
291     }
292     
293     /**
294      * @dev Get Current Pool Amount
295      */
296     function GetCurrentPoolAmount() public view 
297         returns (uint256)
298     {
299         return computePoolAmount();
300     }
301     
302     /**
303      * @dev Check Eligibility
304      */
305     function CheckEligibility(address _addr, string _exchange, string _token) public view
306         returns (bool) 
307     {
308         return(isEligible(_addr, _exchange, _token));
309     }
310     
311     /**
312      * @dev Check Token Balance
313      */
314     function CheckBalance(address _addr) public view returns (uint256){
315         return tokenInterface.balanceOf(_addr);
316     }
317     
318     /**
319      * @dev Check Token Allowance
320      */
321     function CheckAllowance(address _addr) public view returns (uint256){
322         return tokenInterface.allowance(_addr, address(this));
323     }
324     
325     /**
326      * @dev Update Pool State
327      */
328     function UpdatePolicyState(address _addr, string _exchange, string _token, uint8 _state) external
329         onlyOwner
330     {
331         require(policies[_addr].exchange[_exchange].token[_token].state != 0);
332         policies[_addr].exchange[_exchange].token[_token].state = _state;
333         
334         if (_state == 3) {
335             emit ClaimPayout(_addr, _exchange, _token);
336         }
337     }
338     
339     /**
340      * @dev Update Pool State
341      */
342     function UpdatePoolState(uint8 _state) external
343         onlyOwner
344     {
345         poolState = _state;
346         emit PoolStateUpdate(_state);
347     }
348     
349     /**
350      * @dev Update Backed Amount
351      */
352     function UpdateBackedAmount(uint256 _amount) external
353         onlyOwner
354     {
355         poolBackedAmount = _amount;
356         
357         emit PoolBackedAmountUpdate(_amount);
358     }
359     
360     /**
361      * @dev Update Premium Limit
362      */
363     function UpdatePremiumLimit(uint256 _min, uint256 _max) external
364         onlyOwner
365     {
366         require(_min < _max);
367         minPremium = _min;
368         maxPremium = _max;
369         
370         emit PoolPremiumLimitUpdate(_min, _max);
371     }
372     
373     /**
374      * @dev Initiate Payout
375      */
376     function InitiatePayout(address _addr, string _exchange, string _token) external
377         onlyOwner
378     {
379         require(policies[_addr].exchange[_exchange].token[_token].state == 1);
380         require(policies[_addr].exchange[_exchange].token[_token].payoutAmount > 0);
381         
382         uint256 payoutAmount = policies[_addr].exchange[_exchange].token[_token].payoutAmount;
383         require(payoutAmount <= tokenInterface.balanceOf(address(this)));
384         
385         policies[_addr].exchange[_exchange].token[_token].state = 3;
386         tokenInterface.transfer(_addr, payoutAmount);
387         
388         emit ClaimPayout(_addr, _exchange, _token);
389     }
390     
391     /**
392      * @dev Withdraw Fee
393      */
394     function WithdrawFee(uint256 _amount) external
395         onlyOwner
396     {
397         require(_amount <= tokenInterface.balanceOf(address(this)));
398         tokenInterface.transfer(owner, _amount);
399     }
400     
401     /**
402      * @dev Emergency Drain
403      * in case something went wrong and token is stuck in contract
404      */
405     function EmergencyDrain(ERC20Interface _anyToken) external
406         onlyOwner
407         returns(bool)
408     {
409         if (address(this).balance > 0) {
410             owner.transfer(address(this).balance);
411         }
412         
413         if (_anyToken != address(0)) {
414             _anyToken.transfer(owner, _anyToken.balanceOf(this));
415         }
416         return true;
417     }
418 }