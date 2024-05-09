1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) returns (bool);
52   function approve(address spender, uint256 value) returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) returns (bool) {
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   /**
78   * @dev Gets the balance of the specified address.
79   * @param _owner The address to query the the balance of.
80   * @return An uint256 representing the amount owned by the passed address.
81   */
82   function balanceOf(address _owner) constant returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97   mapping (address => mapping (address => uint256)) allowed;
98 
99 
100   /**
101    * @dev Transfer tokens from one address to another
102    * @param _from address The address which you want to send tokens from
103    * @param _to address The address which you want to transfer to
104    * @param _value uint256 the amout of tokens to be transfered
105    */
106   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110     // require (_value <= _allowance);
111 
112     balances[_to] = balances[_to].add(_value);
113     balances[_from] = balances[_from].sub(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) returns (bool) {
125 
126     // To change the approve amount you first have to reduce the addresses`
127     //  allowance to zero by calling `approve(_spender, 0)` if it is not
128     //  already 0 to mitigate the race condition described here:
129     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still avaible for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155   address public owner;
156 
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166 
167   /**
168    * @dev Throws if called by any account other than the owner.
169    */
170   modifier onlyOwner() {
171     require(msg.sender == owner);
172     _;
173   }
174 
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner {
181     if (newOwner != address(0)) {
182       owner = newOwner;
183     }
184   }
185 
186 }
187 
188 /**
189  * @title Pausable
190  * @dev Base contract which allows children to implement an emergency stop mechanism.
191  */
192 contract Pausable is Ownable {
193   event Pause();
194   event Unpause();
195 
196   bool public paused = false;
197 
198 
199   /**
200    * @dev modifier to allow actions only when the contract IS paused
201    */
202   modifier whenNotPaused() {
203     require(!paused);
204     _;
205   }
206 
207   /**
208    * @dev modifier to allow actions only when the contract IS NOT paused
209    */
210   modifier whenPaused {
211     require(paused);
212     _;
213   }
214 
215   /**
216    * @dev called by the owner to pause, triggers stopped state
217    */
218   function pause() onlyOwner whenNotPaused returns (bool) {
219     paused = true;
220     Pause();
221     return true;
222   }
223 
224   /**
225    * @dev called by the owner to unpause, returns to normal state
226    */
227   function unpause() onlyOwner whenPaused returns (bool) {
228     paused = false;
229     Unpause();
230     return true;
231   }
232 }
233 
234 /**
235  * @title Burnable Token
236  * @dev Token that can be irreversibly burned (destroyed).
237  */
238 contract BurnableToken is StandardToken {
239  
240   /**
241    * @dev Burns a specific amount of tokens.
242    * @param _value The amount of token to be burned.
243    */
244   function burn(uint _value) public {
245     require(_value > 0);
246     address burner = msg.sender;
247     balances[burner] = balances[burner].sub(_value);
248     totalSupply = totalSupply.sub(_value);
249     Burn(burner, _value);
250   }
251  
252   event Burn(address indexed burner, uint indexed value);
253  
254 }
255 
256 /**
257  * @title WTF Token Network Token
258  * @dev ERC20 WTF Token Network Token (WTF)
259  *
260  * WTF Tokens are divisible by 1e8 (100,000,000) base
261  * units referred to as 'Grains'.
262  *
263  * WTF are displayed using 8 decimal places of precision.
264  *
265  * 1 WTF is equivalent to:
266  *   100000000 == 1 * 10**8 == 1e8 == One Hundred Million Grains
267  *
268  * 10 Million WTF (total supply) is equivalent to:
269  *   1000000000000000 == 10000000 * 10**8 == 1e15 == One Quadrillion Grains
270  *
271  * All initial WTF Grains are assigned to the creator of
272  * this contract.
273  *
274  */
275 contract WTFToken is BurnableToken, Pausable {
276 
277   string public constant name = 'WTF Token';                   // Set the token name for display
278   string public constant symbol = 'WTF';                                       // Set the token symbol for display
279   uint8 public constant decimals = 8;                                          // Set the number of decimals for display
280   uint256 constant INITIAL_SUPPLY = 10000000 * 10**uint256(decimals);          // 10 Million WTF specified in Grains
281   uint256 public sellPrice;
282   mapping(address => uint256) bonuses;
283   uint8 public freezingPercentage;
284   uint32 public constant unfreezingTimestamp = 1530403200;                     // 2018, July, 1, 00:00:00 UTC
285 
286   /**
287    * @dev WTFToken Constructor
288    * Runs only on initial contract creation.
289    */
290   function WTFToken() {
291     totalSupply = INITIAL_SUPPLY;                                              // Set the total supply
292     balances[msg.sender] = INITIAL_SUPPLY;                                     // Creator address is assigned all
293     sellPrice = 0;
294     freezingPercentage = 100;
295   }
296 
297   function balanceOf(address _owner) constant returns (uint256 balance) {
298     return super.balanceOf(_owner) - bonuses[_owner] * freezingPercentage / 100;
299   }
300 
301   /**
302    * @dev Transfer token for a specified address when not paused
303    * @param _to The address to transfer to.
304    * @param _value The amount to be transferred.
305    */
306   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
307     require(_to != address(0));
308     require(balances[msg.sender] - bonuses[msg.sender] * freezingPercentage / 100 >= _value);
309     return super.transfer(_to, _value);
310   }
311 
312   /**
313    * @dev Transfer tokens and bonus tokens to a specified address
314    * @param _to The address to transfer to.
315    * @param _value The amount to be transferred.
316    * @param _bonus The bonus amount.
317    */
318   function transferWithBonuses(address _to, uint256 _value, uint256 _bonus) onlyOwner returns (bool) {
319     require(_to != address(0));
320     require(balances[msg.sender] - bonuses[msg.sender] * freezingPercentage / 100 >= _value + _bonus);
321     bonuses[_to] = bonuses[_to].add(_bonus);
322     return super.transfer(_to, _value + _bonus);
323   }
324 
325   /**
326    * @dev Check the frozen bonus balance
327    * @param _owner The address to check the balance of.
328    */
329   function bonusesOf(address _owner) constant returns (uint256 balance) {
330     return bonuses[_owner] * freezingPercentage / 100;
331   }
332 
333   /**
334    * @dev Unfreezing part of bonus tokens by owner
335    * @param _percentage uint8 Percentage of bonus tokens to be left frozen
336    */
337   function setFreezingPercentage(uint8 _percentage) onlyOwner returns (bool) {
338     require(_percentage < freezingPercentage);
339     require(now < unfreezingTimestamp);
340     freezingPercentage = _percentage;
341     return true;
342   }
343 
344   /**
345    * @dev Unfreeze all bonus tokens
346    */
347   function unfreezeBonuses() returns (bool) {
348     require(now >= unfreezingTimestamp);
349     freezingPercentage = 0;
350     return true;
351   }
352 
353   /**
354    * @dev Transfer tokens from one address to another when not paused
355    * @param _from address The address which you want to send tokens from
356    * @param _to address The address which you want to transfer to
357    * @param _value uint256 the amount of tokens to be transferred
358    */
359   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
360     require(_to != address(0));
361     require(balances[_from] - bonuses[_from] * freezingPercentage / 100 >= _value);
362     return super.transferFrom(_from, _to, _value);
363   }
364 
365   /**
366    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
367    * @param _spender The address which will spend the funds.
368    * @param _value The amount of tokens to be spent.
369    */
370   function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
371     return super.approve(_spender, _value);
372   }
373 
374  /**
375   * @dev Gets the purchase price of tokens by contract
376   */
377   function getPrice() constant returns (uint256 _sellPrice) {
378       return sellPrice;
379   }
380 
381   /**
382   * @dev Sets the purchase price of tokens by contract
383   * @param newSellPrice New purchase price
384   */
385   function setPrice(uint256 newSellPrice) external onlyOwner returns (bool success) {
386       require(newSellPrice > 0);
387       sellPrice = newSellPrice;
388       return true;
389   }
390 
391   /**
392     * @dev Buying ethereum for tokens
393     * @param amount Number of tokens
394     */
395   function sell(uint256 amount) external returns (uint256 revenue){
396       require(balances[msg.sender] - bonuses[msg.sender] * freezingPercentage / 100 >= amount);           // Checks if the sender has enough to sell
397       balances[this] = balances[this].add(amount);                                                        // Adds the amount to owner's balance
398       balances[msg.sender] = balances[msg.sender].sub(amount);                                            // Subtracts the amount from seller's balance
399       revenue = amount.mul(sellPrice);                                                                    // Calculate the seller reward
400       msg.sender.transfer(revenue);                                                                       // Sends ether to the seller: it's important to do this last to prevent recursion attacks
401       Transfer(msg.sender, this, amount);                                                                 // Executes an event reflecting on the change
402       return revenue;                                                                                     // Ends function and returns
403   }
404 
405   /**
406   * @dev Allows you to get tokens from the contract
407   * @param amount Number of tokens
408   */
409   function getTokens(uint256 amount) onlyOwner external returns (bool success) {
410       require(balances[this] >= amount);
411       balances[msg.sender] = balances[msg.sender].add(amount);
412       balances[this] = balances[this].sub(amount);
413       Transfer(this, msg.sender, amount);
414       return true;
415   }
416 
417   /**
418   * @dev Allows you to put Ethereum to the smart contract
419   */
420   function sendEther() payable onlyOwner external returns (bool success) {
421       return true;
422   }
423 
424   /**
425   * @dev Allows you to get ethereum from the contract
426   * @param amount Number of tokens
427   */
428   function getEther(uint256 amount) onlyOwner external returns (bool success) {
429       require(amount > 0);
430       msg.sender.transfer(amount);
431       return true;
432   }
433 }