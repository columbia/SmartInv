1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal constant returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 /**
73  * @title RefundVault
74  * @dev This contract is used for storing funds while a crowdsale
75  * is in progress. Supports refunding the money if crowdsale fails,
76  * and forwarding it if crowdsale is successful.
77  */
78 contract RefundVault is Ownable {
79   using SafeMath for uint256;
80 
81   enum State { Active, Refunding, Closed }
82 
83   mapping (address => uint256) public deposited;
84   address public wallet;
85   State public state;
86 
87   event Closed();
88   event RefundsEnabled();
89   event Refunded(address indexed beneficiary, uint256 weiAmount);
90 
91   function RefundVault(address _wallet) {
92     require(_wallet != 0x0);
93     wallet = _wallet;
94     state = State.Active;
95   }
96 
97   function deposit(address buyer) onlyOwner payable {
98     require(state == State.Active);
99     deposited[buyer] = deposited[buyer].add(msg.value);
100   }
101 
102   function close() onlyOwner {
103     require(state == State.Active);
104     state = State.Closed;
105     Closed();
106     wallet.transfer(this.balance);
107   }
108 
109   function enableRefunds() onlyOwner {
110     require(state == State.Active);
111     state = State.Refunding;
112     RefundsEnabled();
113   }
114 
115   function refund(address buyer) {
116     require(state == State.Refunding);
117     uint256 depositedValue = deposited[buyer];
118     deposited[buyer] = 0;
119     buyer.transfer(depositedValue);
120     Refunded(buyer, depositedValue);
121   }
122 }
123 
124 
125 /**
126  * @title ERC20Basic
127  * @dev Simpler version of ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/179
129  */
130 contract ERC20Basic {
131   uint256 public totalSupply;
132   function balanceOf(address who) constant returns (uint256);
133   function transfer(address to, uint256 value) returns (bool);
134   event Transfer(address indexed from, address indexed to, uint256 value);
135 }
136 
137 /**
138  * @title Basic token
139  * @dev Basic version of StandardToken, with no allowances. 
140  */
141 contract BasicToken is ERC20Basic {
142   using SafeMath for uint256;
143 
144   mapping(address => uint256) balances;
145 
146   /**
147   * @dev transfer token for a specified address
148   * @param _to The address to transfer to.
149   * @param _value The amount to be transferred.
150   */
151   function transfer(address _to, uint256 _value) returns (bool) {
152     balances[msg.sender] = balances[msg.sender].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     Transfer(msg.sender, _to, _value);
155     return true;
156   }
157 
158   /**
159   * @dev Gets the balance of the specified address.
160   * @param _owner The address to query the the balance of. 
161   * @return An uint256 representing the amount owned by the passed address.
162   */
163   function balanceOf(address _owner) constant returns (uint256 balance) {
164     return balances[_owner];
165   }
166 
167 }
168 
169 /**
170  * @title ERC20 interface
171  * @dev see https://github.com/ethereum/EIPs/issues/20
172  */
173 contract ERC20 is ERC20Basic {
174   function allowance(address owner, address spender) constant returns (uint256);
175   function transferFrom(address from, address to, uint256 value) returns (bool);
176   function approve(address spender, uint256 value) returns (bool);
177   event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 /**
181  * @title Standard ERC20 token
182  *
183  * @dev Implementation of the basic standard token.
184  * @dev https://github.com/ethereum/EIPs/issues/20
185  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
186  */
187 contract StandardToken is ERC20, BasicToken {
188 
189   mapping (address => mapping (address => uint256)) allowed;
190 
191 
192   /**
193    * @dev Transfer tokens from one address to another
194    * @param _from address The address which you want to send tokens from
195    * @param _to address The address which you want to transfer to
196    * @param _value uint256 the amout of tokens to be transfered
197    */
198   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
199     var _allowance = allowed[_from][msg.sender];
200 
201     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
202     // require (_value <= _allowance);
203 
204     balances[_to] = balances[_to].add(_value);
205     balances[_from] = balances[_from].sub(_value);
206     allowed[_from][msg.sender] = _allowance.sub(_value);
207     Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    * @param _spender The address which will spend the funds.
214    * @param _value The amount of tokens to be spent.
215    */
216   function approve(address _spender, uint256 _value) returns (bool) {
217 
218     // To change the approve amount you first have to reduce the addresses`
219     //  allowance to zero by calling `approve(_spender, 0)` if it is not
220     //  already 0 to mitigate the race condition described here:
221     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
223 
224     allowed[msg.sender][_spender] = _value;
225     Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Function to check the amount of tokens that an owner allowed to a spender.
231    * @param _owner address The address which owns the funds.
232    * @param _spender address The address which will spend the funds.
233    * @return A uint256 specifing the amount of tokens still avaible for the spender.
234    */
235   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
236     return allowed[_owner][_spender];
237   }
238 
239 }
240 
241 /**
242  * @title CirclesTokenOffering
243  * @dev Modified from OpenZeppelin's Crowdsale.sol, RefundableCrowdsale.sol,
244  * CappedCrowdsale.sol, and FinalizableCrowdsale.sol
245  * Uses PausableToken rather than MintableToken.
246  *
247  * Requires that 350m tokens (entire supply minus team's portion) be deposited.
248  */
249 contract CirclesTokenOffering is Ownable {
250   using SafeMath for uint256;
251 
252   // Token allocations
253   mapping (address => uint256) allocations;
254 
255   // manual early close flag
256   bool public isFinalized = false;
257 
258   // cap for crowdsale in wei
259   uint256 public cap;
260 
261   // minimum amount of funds to be raised in weis
262   uint256 public goal;
263 
264   // refund vault used to hold funds while crowdsale is running
265   RefundVault public vault;
266 
267   // The token being sold
268   StandardToken public token;
269 
270   // start and end timestamps where contributions are allowed (both inclusive)
271   uint256 public startTime;
272   uint256 public endTime;
273 
274   // address where funds are collected
275   address public wallet;
276 
277   // address to hold team / advisor tokens until vesting complete
278   address public safe;
279 
280   // how many token units a buyer gets per wei
281   uint256 public rate;
282 
283   // amount of raised money in wei
284   uint256 public weiRaised;
285 
286   /**
287    * event for token purchase logging
288    * @param purchaser who paid for the tokens
289    * @param beneficiary who got the tokens
290    * @param value weis paid for purchase
291    * @param amount amount of tokens purchased
292    */
293   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
294 
295   /**
296    * event for token redemption logging
297    * @param beneficiary who got the tokens
298    * @param amount amount of tokens redeemed
299    */
300   event TokenRedeem(address indexed beneficiary, uint256 amount);
301 
302   // termination early or otherwise
303   event Finalized();
304 
305   function CirclesTokenOffering(address _token, uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, uint256 _goal, address _wallet) {
306 
307     require(_startTime >= now);
308     require(_endTime >= _startTime);
309     require(_rate > 0);
310     require(_cap > 0);
311     require(_wallet != 0x0);
312     require(_goal > 0);
313 
314     vault = new RefundVault(_wallet);
315     goal = _goal;
316     token = StandardToken(_token);
317     startTime = _startTime;
318     endTime = _endTime;
319     rate = _rate;
320     cap = _cap;
321     goal = _goal;
322     wallet = _wallet;
323   }
324 
325   // fallback function can be used to buy tokens
326   function () payable {
327     buyTokens(msg.sender);
328   }
329 
330   // low level token purchase function
331   // caution: tokens must be redeemed by beneficiary address
332   function buyTokens(address beneficiary) payable {
333     require(beneficiary != 0x0);
334     require(validPurchase());
335 
336     // calculate token amount to be purchased
337     uint256 weiAmount = msg.value;
338     uint256 tokens = weiAmount.mul(rate);
339 
340     // update state
341     weiRaised = weiRaised.add(weiAmount);
342 
343     // allocate tokens to purchaser
344     allocations[beneficiary] = tokens;
345 
346     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
347 
348     forwardFunds();
349   }
350 
351   // redeem tokens
352   function claimTokens() {
353     require(isFinalized);
354     require(goalReached());
355 
356     // confirm there are tokens remaining
357     uint256 amount = token.balanceOf(this);
358     require(amount > 0);
359 
360     // send tokens to purchaser
361     uint256 tokens = allocations[msg.sender];
362     allocations[msg.sender] = 0;
363     require(token.transfer(msg.sender, tokens));
364 
365     TokenRedeem(msg.sender, tokens);
366   }
367 
368   // redeem tokens (admin fallback)
369   function sendTokens(address beneficiary) onlyOwner {
370     require(isFinalized);
371     require(goalReached());
372 
373     // confirm there are tokens remaining
374     uint256 amount = token.balanceOf(this);
375     require(amount > 0);
376 
377     // send tokens to purchaser
378     uint256 tokens = allocations[beneficiary];
379     allocations[beneficiary] = 0;
380     require(token.transfer(beneficiary, tokens));
381 
382     TokenRedeem(beneficiary, tokens);
383   }
384 
385   // send ether to the fund collection wallet
386   // override to create custom fund forwarding mechanisms
387   function forwardFunds() internal {
388     vault.deposit.value(msg.value)(msg.sender);
389   }
390 
391   // @return true if the transaction can buy tokens
392   function validPurchase() internal constant returns (bool) {
393     bool withinCap = weiRaised.add(msg.value) <= cap;
394     bool withinPeriod = now >= startTime && now <= endTime;
395     bool nonZeroPurchase = msg.value != 0;
396     return withinPeriod && nonZeroPurchase && withinCap;
397   }
398 
399   // @return true if crowdsale event has ended or cap reached
400   function hasEnded() public constant returns (bool) {
401     bool capReached = weiRaised >= cap;
402     bool passedEndTime = now > endTime;
403     return passedEndTime || capReached;
404   }
405 
406   // if crowdsale is unsuccessful, contributors can claim refunds here
407   function claimRefund() {
408     require(isFinalized);
409     require(!goalReached());
410 
411     vault.refund(msg.sender);
412   }
413 
414   function goalReached() public constant returns (bool) {
415    return weiRaised >= goal;
416   }
417 
418     // @dev does not require that crowdsale `hasEnded()` to leave safegaurd
419   // in place if ETH rises in price too much during crowdsale.
420   // Allows team to close early if cap is exceeded in USD in this event.
421   function finalize() onlyOwner {
422     require(!isFinalized);
423     if (goalReached()) {
424       vault.close();
425     } else {
426       vault.enableRefunds();
427     }
428 
429     Finalized();
430 
431     isFinalized = true;
432   }
433 
434   function unsoldCleanUp() onlyOwner { 
435     uint256 amount = token.balanceOf(this);
436     if(amount > 0) {
437       require(token.transfer(msg.sender, amount));
438     } 
439 
440   }
441 
442 }