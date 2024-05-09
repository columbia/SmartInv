1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() {
49     owner = msg.sender;
50   }
51 
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) onlyOwner {
67     require(newOwner != address(0));      
68     owner = newOwner;
69   }
70 
71 }
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   uint256 public totalSupply;
80   function balanceOf(address who) constant returns (uint256);
81   function transfer(address to, uint256 value) returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) constant returns (uint256);
91   function transferFrom(address from, address to, uint256 value) returns (bool);
92   function approve(address spender, uint256 value) returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances. 
100  */
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) balances;
105 
106   /**
107   * @dev transfer token for a specified address
108   * @param _to The address to transfer to.
109   * @param _value The amount to be transferred.
110   */
111   function transfer(address _to, uint256 _value) returns (bool) {
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of. 
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) constant returns (uint256 balance) {
124     return balances[_owner];
125   }
126 
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * @dev https://github.com/ethereum/EIPs/issues/20
134  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
148     require(_to != address(0));
149 
150     var _allowance = allowed[_from][msg.sender];
151 
152     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
153     // require (_value <= _allowance);
154 
155     balances[_from] = balances[_from].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     allowed[_from][msg.sender] = _allowance.sub(_value);
158     Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) returns (bool) {
168 
169     // To change the approve amount you first have to reduce the addresses`
170     //  allowance to zero by calling `approve(_spender, 0)` if it is not
171     //  already 0 to mitigate the race condition described here:
172     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
174 
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
187     return allowed[_owner][_spender];
188   }
189   
190     /*
191    * approve should be called when allowed[_spender] == 0. To increment
192    * allowed value is better to use this function to avoid 2 calls (and wait until 
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    */
196   function increaseApproval (address _spender, uint _addedValue) 
197     returns (bool success) {
198     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203   function decreaseApproval (address _spender, uint _subtractedValue) 
204     returns (bool success) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207       allowed[msg.sender][_spender] = 0;
208     } else {
209       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 }
215 
216 contract SmokeExchangeCoin is StandardToken {
217   string public name = "Smoke Exchange Token";
218   string public symbol = "SMX";
219   uint256 public decimals = 18;  
220   address public ownerAddress;
221     
222   event Distribute(address indexed to, uint256 value);
223   
224   function SmokeExchangeCoin(uint256 _totalSupply, address _ownerAddress, address smxTeamAddress, uint256 allocCrowdsale, uint256 allocAdvBounties, uint256 allocTeam) {
225     ownerAddress = _ownerAddress;
226     totalSupply = _totalSupply;
227     balances[ownerAddress] += allocCrowdsale;
228     balances[ownerAddress] += allocAdvBounties;
229     balances[smxTeamAddress] += allocTeam;
230   }
231   
232   function distribute(address _to, uint256 _value) returns (bool) {
233     require(balances[ownerAddress] >= _value);
234     balances[ownerAddress] = balances[ownerAddress].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     Distribute(_to, _value);
237     return true;
238   }
239 }
240 
241 contract SmokeExchangeCoinCrowdsale is Ownable {
242   using SafeMath for uint256;
243 
244   // The token being sold
245   SmokeExchangeCoin public token;
246   
247   // start and end timestamps where investments are allowed (both inclusive)
248   uint256 public startTime;
249   uint256 public endTime;
250   uint256 public privateStartTime;
251   uint256 public privateEndTime;
252 
253   // address where funds are collected
254   address public wallet;
255 
256   // amount of raised money in wei
257   uint256 public weiRaised;
258   
259   uint private constant DECIMALS = 1000000000000000000;
260   //PRICES
261   uint public constant TOTAL_SUPPLY = 28500000 * DECIMALS; //28.5 millions
262   uint public constant BASIC_RATE = 300; //300 tokens per 1 eth
263   uint public constant PRICE_STANDARD    = BASIC_RATE * DECIMALS; 
264   uint public constant PRICE_PREBUY = PRICE_STANDARD * 150/100;
265   uint public constant PRICE_STAGE_ONE   = PRICE_STANDARD * 125/100;
266   uint public constant PRICE_STAGE_TWO   = PRICE_STANDARD * 115/100;
267   uint public constant PRICE_STAGE_THREE   = PRICE_STANDARD * 107/100;
268   uint public constant PRICE_STAGE_FOUR = PRICE_STANDARD;
269   
270   uint public constant PRICE_PREBUY_BONUS = PRICE_STANDARD * 165/100;
271   uint public constant PRICE_STAGE_ONE_BONUS = PRICE_STANDARD * 145/100;
272   uint public constant PRICE_STAGE_TWO_BONUS = PRICE_STANDARD * 125/100;
273   uint public constant PRICE_STAGE_THREE_BONUS = PRICE_STANDARD * 115/100;
274   uint public constant PRICE_STAGE_FOUR_BONUS = PRICE_STANDARD;
275   
276   //uint public constant PRICE_WHITELIST_BONUS = PRICE_STANDARD * 165/100;
277   
278   //TIME LIMITS
279   uint public constant STAGE_ONE_TIME_END = 1 weeks;
280   uint public constant STAGE_TWO_TIME_END = 2 weeks;
281   uint public constant STAGE_THREE_TIME_END = 3 weeks;
282   uint public constant STAGE_FOUR_TIME_END = 4 weeks;
283   
284   uint public constant ALLOC_CROWDSALE = TOTAL_SUPPLY * 75/100;
285   uint public constant ALLOC_TEAM = TOTAL_SUPPLY * 15/100;  
286   uint public constant ALLOC_ADVISORS_BOUNTIES = TOTAL_SUPPLY * 10/100;
287   
288   uint256 public smxSold = 0;
289   
290   address public ownerAddress;
291   address public smxTeamAddress;
292   
293   //active = false/not active = true
294   bool public halted;
295   
296   //in wei
297   uint public cap; 
298   
299   //in wei, prebuy hardcap
300   uint public privateCap;
301   
302   uint256 public bonusThresholdWei;
303   
304   /**
305    * event for token purchase logging
306    * @param purchaser who paid for the tokens
307    * @param beneficiary who got the tokens
308    * @param value weis paid for purchase
309    * @param amount amount of tokens purchased
310    */ 
311   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
312   
313   /**
314   * Modifier to run function only if contract is active (not halted)
315   */
316   modifier isNotHalted() {
317     require(!halted);
318     _;
319   }
320   
321   /**
322   * Constructor for SmokeExchageCoinCrowdsale
323   * @param _privateStartTime start time for presale
324   * @param _startTime start time for public sale
325   * @param _ethWallet all incoming eth transfered here. Use multisig wallet
326   * @param _privateWeiCap hard cap for presale
327   * @param _weiCap hard cap in wei for the crowdsale
328   * @param _bonusThresholdWei in wei. Minimum amount of wei required for bonus
329   * @param _smxTeamAddress team address 
330   */
331   function SmokeExchangeCoinCrowdsale(uint256 _privateStartTime, uint256 _startTime, address _ethWallet, uint256 _privateWeiCap, uint256 _weiCap, uint256 _bonusThresholdWei, address _smxTeamAddress) {
332     require(_privateStartTime >= now);
333     require(_ethWallet != 0x0);    
334     require(_smxTeamAddress != 0x0);    
335     
336     privateStartTime = _privateStartTime;
337     //presale 10 days
338     privateEndTime = privateStartTime + 10 days;    
339     startTime = _startTime;
340     
341     //ICO start time after presale end
342     require(_startTime >= privateEndTime);
343     
344     endTime = _startTime + STAGE_FOUR_TIME_END;
345     
346     wallet = _ethWallet;   
347     smxTeamAddress = _smxTeamAddress;
348     ownerAddress = msg.sender;
349     
350     cap = _weiCap;    
351     privateCap = _privateWeiCap;
352     bonusThresholdWei = _bonusThresholdWei;
353                  
354     token = new SmokeExchangeCoin(TOTAL_SUPPLY, ownerAddress, smxTeamAddress, ALLOC_CROWDSALE, ALLOC_ADVISORS_BOUNTIES, ALLOC_TEAM);
355   }
356   
357   // fallback function can be used to buy tokens
358   function () payable {
359     buyTokens(msg.sender);
360   }
361   
362   // @return true if investors can buy at the moment
363   function validPurchase() internal constant returns (bool) {
364     bool privatePeriod = now >= privateStartTime && now < privateEndTime;
365     bool withinPeriod = (now >= startTime && now <= endTime) || (privatePeriod);
366     bool nonZeroPurchase = (msg.value != 0);
367     //cap depends on stage.
368     bool withinCap = privatePeriod ? (weiRaised.add(msg.value) <= privateCap) : (weiRaised.add(msg.value) <= cap);
369     // check if there are smx token left
370     bool smxAvailable = (ALLOC_CROWDSALE - smxSold > 0); 
371     return withinPeriod && nonZeroPurchase && withinCap && smxAvailable;
372     //return true;
373   }
374 
375   // @return true if crowdsale event has ended
376   function hasEnded() public constant returns (bool) {
377     bool capReached = weiRaised >= cap;
378     bool tokenSold = ALLOC_CROWDSALE - smxSold == 0;
379     bool timeEnded = now > endTime;
380     return timeEnded || capReached || tokenSold;
381   }  
382   
383   /**
384   * Main function for buying tokens
385   * @param beneficiary purchased tokens go to this address
386   */
387   function buyTokens(address beneficiary) payable isNotHalted {
388     require(beneficiary != 0x0);
389     require(validPurchase());
390 
391     uint256 weiAmount = msg.value;
392 
393     // calculate token amount to be distributed
394     uint256 tokens = SafeMath.div(SafeMath.mul(weiAmount, getCurrentRate(weiAmount)), 1 ether);
395     //require that there are more or equal tokens available for sell
396     require(ALLOC_CROWDSALE - smxSold >= tokens);
397 
398     //update total weiRaised
399     weiRaised = weiRaised.add(weiAmount);
400     //updated total smxSold
401     smxSold = smxSold.add(tokens);
402     
403     //add token to beneficiary and subtract from ownerAddress balance
404     token.distribute(beneficiary, tokens);
405     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
406 
407     //forward eth received to walletEth
408     forwardFunds();
409   }
410   
411   // send ether to the fund collection wallet  
412   function forwardFunds() internal {
413     wallet.transfer(msg.value);
414   }
415   
416   /**
417   * Get rate. Depends on current time
418   *
419   */
420   function getCurrentRate(uint256 _weiAmount) constant returns (uint256) {  
421       
422       bool hasBonus = _weiAmount >= bonusThresholdWei;
423   
424       if (now < startTime) {
425         return hasBonus ? PRICE_PREBUY_BONUS : PRICE_PREBUY;
426       }
427       uint delta = SafeMath.sub(now, startTime);
428 
429       //3+weeks from start
430       if (delta > STAGE_THREE_TIME_END) {
431         return hasBonus ? PRICE_STAGE_FOUR_BONUS : PRICE_STAGE_FOUR;
432       }
433       //2+weeks from start
434       if (delta > STAGE_TWO_TIME_END) {
435         return hasBonus ? PRICE_STAGE_THREE_BONUS : PRICE_STAGE_THREE;
436       }
437       //1+week from start
438       if (delta > STAGE_ONE_TIME_END) {
439         return hasBonus ? PRICE_STAGE_TWO_BONUS : PRICE_STAGE_TWO;
440       }
441 
442       //less than 1 week from start
443       return hasBonus ? PRICE_STAGE_ONE_BONUS : PRICE_STAGE_ONE;
444   }
445   
446   /**
447   * Enable/disable halted
448   */
449   function toggleHalt(bool _halted) onlyOwner {
450     halted = _halted;
451   }
452 }