1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47 }
48 
49 /*
50  * Ownable
51  *
52  * Base contract with an owner.
53  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
54  */
55 contract Ownable {
56   address public owner;
57 
58   function Ownable() {
59     owner = msg.sender;
60   }
61 
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67   function transferOwnership(address newOwner) onlyOwner {
68     if (newOwner != address(0)) {
69       owner = newOwner;
70     }
71   }
72 
73 }
74 
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20Basic {
82   uint256 public totalSupply;
83   function balanceOf(address who) constant returns (uint256);
84   function transfer(address to, uint256 value);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) constant returns (uint256);
94   function transferFrom(address from, address to, uint256 value);
95   function approve(address spender, uint256 value);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  */
104 contract BasicToken is ERC20Basic {
105   using SafeMath for uint256;
106 
107   mapping(address => uint256) balances;
108 
109   /**
110    * @dev Fix for the ERC20 short address attack.
111    */
112   modifier onlyPayloadSize(uint256 size) {
113      require(msg.data.length >= size + 4);
114      _;
115   }
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     Transfer(msg.sender, _to, _value);
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) constant returns (uint256 balance) {
134     return balances[_owner];
135   }
136 
137 }
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implemantation of the basic standart token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is BasicToken, ERC20 {
147 
148   mapping (address => mapping (address => uint256)) allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amout of tokens to be transfered
156    */
157   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
158     var _allowance = allowed[_from][msg.sender];
159 
160     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
161     // if (_value > _allowance) throw;
162 
163     balances[_to] = balances[_to].add(_value);
164     balances[_from] = balances[_from].sub(_value);
165     allowed[_from][msg.sender] = _allowance.sub(_value);
166     Transfer(_from, _to, _value);
167   }
168 
169   /**
170    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) {
175 
176     // To change the approve amount you first have to reduce the addresses`
177     //  allowance to zero by calling `approve(_spender, 0)` if it is not
178     //  already 0 to mitigate the race condition described here:
179     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
181 
182     allowed[msg.sender][_spender] = _value;
183     Approval(msg.sender, _spender, _value);
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens that an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint256 specifing the amount of tokens still avaible for the spender.
191    */
192   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
193     return allowed[_owner][_spender];
194   }
195 
196 }
197 
198 /// @title Migration Agent interface
199 contract MigrationAgent {
200   function migrateFrom(address _from, uint256 _value);
201 }
202 
203 /// @title Votes Platform Token
204 contract VotesPlatformToken is StandardToken, Ownable {
205 
206   string public name = "Votes Platform Token";
207   string public symbol = "VOTES";
208   uint256 public decimals = 2;
209   uint256 public INITIAL_SUPPLY = 100000000 * 100;
210 
211   mapping(address => bool) refundAllowed;
212 
213   address public migrationAgent;
214   uint256 public totalMigrated;
215 
216   /**
217    * @dev Contructor that gives msg.sender all of existing tokens.
218    */
219   function VotesPlatformToken() {
220     totalSupply = INITIAL_SUPPLY;
221     balances[msg.sender] = INITIAL_SUPPLY;
222   }
223 
224   /**
225    * Allow refund from given presale contract address.
226    * Only token owner may do that.
227    */
228   function allowRefund(address _contractAddress) onlyOwner {
229     refundAllowed[_contractAddress] = true;
230   }
231 
232   /**
233    * Refund _count presale tokens from _from to msg.sender.
234    * msg.sender must be a trusted presale contract.
235    */
236   function refundPresale(address _from, uint _count) {
237     require(refundAllowed[msg.sender]);
238     balances[_from] = balances[_from].sub(_count);
239     balances[msg.sender] = balances[msg.sender].add(_count);
240   }
241 
242   function setMigrationAgent(address _agent) external onlyOwner {
243     migrationAgent = _agent;
244   }
245 
246   function migrate(uint256 _value) external {
247     // Abort if not in Operational Migration state.
248     require(migrationAgent != 0);
249 
250     // Validate input value.
251     require(_value > 0);
252     require(_value <= balances[msg.sender]);
253 
254     balances[msg.sender] -= _value;
255     totalSupply -= _value;
256     totalMigrated += _value;
257     MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
258   }
259 }
260 
261 /**
262  * Workflow:
263  * 1) owner: create token contract
264  * 2) owner: create presale contract
265  * 3) owner: transfer required amount of tokens to presale contract
266  * 4) owner: allow refund from presale contract by calling token.allowRefund
267  * 5) <wait for start time>
268  * 6) everyone sends ether to the presale contract and receives tokens in exchange
269  * 7) <wait until end time or until hard cap is reached>
270  * 8) if soft cap is reached:
271  * 8.1) beneficiary calls withdraw() and receives
272  * 8.2) beneficiary calls withdrawTokens() and receives the rest of non-sold tokens
273  * 9) if soft cap is not reached:
274  * 9.1) everyone calls refund() and receives their ether back in exchange for tokens
275  * 9.2) owner calls withdrawTokens() and receives the refunded tokens
276  */
277 contract VotesPlatformTokenPreSale is Ownable {
278     using SafeMath for uint;
279 
280     string public name = "Votes Platform Token ICO";
281 
282     VotesPlatformToken public token;
283     address public beneficiary;
284 
285     uint public hardCap;
286     uint public softCap;
287     uint public tokenPrice;
288     uint public purchaseLimit;
289 
290     uint public tokensSold = 0;
291     uint public weiRaised = 0;
292     uint public investorCount = 0;
293     uint public weiRefunded = 0;
294 
295     uint public startTime;
296     uint public endTime;
297 
298     bool public softCapReached = false;
299     bool public crowdsaleFinished = false;
300 
301     mapping(address => uint) sold;
302 
303     event GoalReached(uint amountRaised);
304     event SoftCapReached(uint softCap1);
305     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
306     event Refunded(address indexed holder, uint256 amount);
307 
308     modifier onlyAfter(uint time) {
309         require(now >= time);
310         _;
311     }
312 
313     modifier onlyBefore(uint time) {
314         require(now <= time);
315         _;
316     }
317 
318     function VotesPlatformTokenPreSale(
319         uint _hardCapUSD,       // maximum allowed fundraising in USD
320         uint _softCapUSD,       // minimum amount in USD required for withdrawal by beneficiary
321         address _token,         // token contract address
322         address _beneficiary,   // beneficiary address
323         uint _totalTokens,      // in token-wei. i.e. number of presale tokens * 10^18
324         uint _priceETH,         // ether price in USD
325         uint _purchaseLimitUSD, // purchase limit in USD
326         uint _startTime,        // start time (unix time, in seconds since 1970-01-01)
327         uint _duration          // presale duration in hours
328     ) {
329         hardCap = _hardCapUSD * 1 ether / _priceETH;
330         softCap = _softCapUSD * 1 ether / _priceETH;
331         tokenPrice = hardCap / _totalTokens;
332 
333         purchaseLimit = _purchaseLimitUSD * 1 ether / _priceETH / tokenPrice;
334         token = VotesPlatformToken(_token);
335         beneficiary = _beneficiary;
336 
337         startTime = _startTime;
338         endTime = _startTime + _duration * 1 hours;
339     }
340 
341     function () payable {
342         require(msg.value / tokenPrice > 0);
343         doPurchase(msg.sender);
344     }
345 
346     function refund() external onlyAfter(endTime) {
347         require(!softCapReached);
348         uint balance = sold[msg.sender];
349         require(balance > 0);
350         uint refund = balance * tokenPrice;
351         msg.sender.transfer(refund);
352         delete sold[msg.sender];
353         weiRefunded = weiRefunded.add(refund);
354         token.refundPresale(msg.sender, balance);
355         Refunded(msg.sender, refund);
356     }
357 
358     function withdrawTokens() onlyOwner onlyAfter(endTime) {
359         token.transfer(beneficiary, token.balanceOf(this));
360     }
361 
362     function withdraw() onlyOwner {
363         require(softCapReached);
364         beneficiary.transfer(weiRaised);
365         token.transfer(beneficiary, token.balanceOf(this));
366         crowdsaleFinished = true;
367     }
368 
369     function doPurchase(address _to) private onlyAfter(startTime) onlyBefore(endTime) {
370         assert(crowdsaleFinished == false);
371 
372         require(weiRaised.add(msg.value) <= hardCap);
373 
374         if (!softCapReached && weiRaised < softCap && weiRaised.add(msg.value) >= softCap) {
375             softCapReached = true;
376             SoftCapReached(softCap);
377         }
378 
379         uint tokens = msg.value / tokenPrice;
380         require(token.balanceOf(_to) + tokens <= purchaseLimit);
381 
382         if (sold[_to] == 0)
383             investorCount++;
384 
385         token.transfer(_to, tokens);
386         sold[_to] += tokens;
387         tokensSold = tokensSold.add(tokens);
388 
389         weiRaised = weiRaised.add(msg.value);
390 
391         NewContribution(_to, tokens, msg.value);
392 
393         if (weiRaised == hardCap) {
394             GoalReached(hardCap);
395         }
396     }
397 }