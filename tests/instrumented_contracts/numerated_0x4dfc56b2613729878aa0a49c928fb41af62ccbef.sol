1 pragma solidity ^0.4.18;
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
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 /**
57  * @title ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) public view returns (uint256);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 
66 }
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72 
73   /**
74   * @dev Multiplies two numbers, throws on overflow.
75   */
76   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77     if (a == 0) {
78       return 0;
79     }
80     uint256 c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers, truncating the quotient.
87   */
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return c;
93   }
94 
95   /**
96   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   */
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   /**
104   * @dev Adds two numbers, throws on overflow.
105   */
106   function add(uint256 a, uint256 b) internal pure returns (uint256) {
107     uint256 c = a + b;
108     assert(c >= a);
109     return c;
110   }
111 }
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117 
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   /**
123   * @dev transfer token for a specified address
124   * @param _to The address to transfer to.
125   * @param _value The amount to be transferred.
126   */
127   function transfer(address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     require(_value <= balances[msg.sender]);
130 
131     // SafeMath.sub will throw if there is not enough balance.
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     Transfer(msg.sender, _to, _value);
135     return true;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) public view returns (uint256 balance) {
144     return balances[_owner];
145   }
146 }
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * @dev https://github.com/ethereum/EIPs/issues/20
153  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[_from]);
169     require(_value <= allowed[_from][msg.sender]);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174     Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    *
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(address _owner, address _spender) public view returns (uint256) {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * @dev Increase the amount of tokens that an owner allowed to a spender.
206    *
207    * approve should be called when allowed[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _addedValue The amount of tokens to increase the allowance by.
213    */
214   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
215     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   /**
221    * @dev Decrease the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
231     uint oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue > oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241 }
242 
243 
244 contract MintableToken is StandardToken, Ownable {
245   event Mint(address indexed to, uint256 amount);
246   event MintFinished();
247 
248   bool public mintingFinished = false;
249 
250 
251   modifier canMint() {
252     require(!mintingFinished);
253     _;
254   }
255 
256   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
257     totalSupply = totalSupply.add(_amount);
258     balances[_to] = balances[_to].add(_amount);
259     Mint(_to, _amount);
260     Transfer(address(0), _to, _amount);
261     return true;
262   }
263 
264   function finishMinting() onlyOwner canMint public returns (bool) {
265     mintingFinished = true;
266     MintFinished();
267     return true;
268   }
269 }
270 
271 contract GDR is MintableToken {
272 
273   string public constant name = "Golden Resource";
274 
275   string public constant symbol = "GDR";
276 
277   uint8 public constant decimals = 18;
278 
279 }
280 
281 contract ReentrancyGuard {
282 
283   /**
284    * @dev We use a single lock for the whole contract.
285    */
286   bool private rentrancy_lock = false;
287 
288   /**
289    * @dev Prevents a contract from calling itself, directly or indirectly.
290    * @notice If you mark a function `nonReentrant`, you should also
291    * mark it `external`. Calling one nonReentrant function from
292    * another is not supported. Instead, you can implement a
293    * `private` function doing the actual work, and a `external`
294    * wrapper marked as `nonReentrant`.
295    */
296   modifier nonReentrant() {
297     require(!rentrancy_lock);
298     rentrancy_lock = true;
299     _;
300     rentrancy_lock = false;
301   }
302 }
303 
304 contract PreICO is Ownable, ReentrancyGuard {
305   using SafeMath for uint256;
306 
307   // The token being sold
308   GDR public token;
309 
310   // start and end timestamps where investments are allowed (both inclusive)
311   uint256 public startTime;
312   uint256 public endTime;
313 
314   // address where funds are collected
315   address public wallet;
316 
317   // how many token units a buyer gets per wei
318   uint256 public rate; // tokens for one cent
319 
320   uint256 public priceUSD; // wei in one USD
321 
322   uint256 public centRaised;
323 
324   uint256 public hardCap;
325 
326   address oracle; //
327   address manager;
328 
329   // investors => amount of money
330   mapping(address => uint) public balances;
331   mapping(address => uint) public balancesInCent;
332 
333   /**
334    * event for token purchase logging
335    * @param purchaser who paid for the tokens
336    * @param beneficiary who got the tokens
337    * @param value weis paid for purchase
338    * @param amount amount of tokens purchased
339    */
340   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
341 
342 
343   function PreICO(
344   uint256 _startTime,
345   uint256 _period,
346   address _wallet,
347   address _token,
348   uint256 _priceUSD) public
349   {
350     require(_period != 0);
351     require(_priceUSD != 0);
352     require(_wallet != address(0));
353     require(_token != address(0));
354 
355     startTime = _startTime;
356     endTime = startTime + _period * 1 days;
357     priceUSD = _priceUSD;
358     rate = 12500000000000000; // 0.0125 * 1 ether
359     wallet = _wallet;
360     token = GDR(_token);
361     hardCap = 1000000000; // inCent
362   }
363 
364   // @return true if the transaction can buy tokens
365   modifier saleIsOn() {
366     bool withinPeriod = now >= startTime && now <= endTime;
367     require(withinPeriod);
368     _;
369   }
370 
371   modifier isUnderHardCap() {
372     require(centRaised <= hardCap);
373     _;
374   }
375 
376   modifier onlyOracle(){
377     require(msg.sender == oracle);
378     _;
379   }
380 
381   modifier onlyOwnerOrManager(){
382     require(msg.sender == manager || msg.sender == owner);
383     _;
384   }
385 
386   // @return true if crowdsale event has ended
387   function hasEnded() public view returns (bool) {
388     return now > endTime;
389   }
390 
391   // Override this method to have a way to add business logic to your crowdsale when buying
392   function getTokenAmount(uint256 centValue) internal view returns(uint256) {
393     return centValue.mul(rate);
394   }
395 
396   // send ether to the fund collection wallet
397   // override to create custom fund forwarding mechanisms
398   function forwardFunds(uint256 value) internal {
399     wallet.transfer(value);
400   }
401 
402   function finishPreSale() public onlyOwner {
403     token.transferOwnership(owner);
404     forwardFunds(this.balance);
405   }
406 
407   // set the address from which you can change the rate
408   function setOracle(address _oracle) public  onlyOwner {
409     require(_oracle != address(0));
410     oracle = _oracle;
411   }
412 
413   // set manager's address
414   function setManager(address _manager) public  onlyOwner {
415     require(_manager != address(0));
416     manager = _manager;
417   }
418 
419   function changePriceUSD(uint256 _priceUSD) public  onlyOracle {
420     require(_priceUSD != 0);
421     priceUSD = _priceUSD;
422   }
423 
424   // manual selling tokens for fiat
425   function manualTransfer(address _to, uint _valueUSD) public saleIsOn isUnderHardCap onlyOwnerOrManager {
426     uint256 centValue = _valueUSD * 100;
427     uint256 tokensAmount = getTokenAmount(centValue);
428     centRaised = centRaised.add(centValue);
429     token.mint(_to, tokensAmount);
430     balancesInCent[_to] = balancesInCent[_to].add(centValue);
431   }
432 
433   // low level token purchase function
434   function buyTokens(address beneficiary) saleIsOn isUnderHardCap nonReentrant public payable {
435     require(beneficiary != address(0) && msg.value != 0);
436     uint256 weiAmount = msg.value;
437     uint256 centValue = weiAmount.div(priceUSD);
438     uint256 tokens = getTokenAmount(centValue);
439     centRaised = centRaised.add(centValue);
440     token.mint(beneficiary, tokens);
441     balances[msg.sender] = balances[msg.sender].add(weiAmount);
442     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
443     forwardFunds(weiAmount);
444   }
445 
446   function () external payable {
447     buyTokens(msg.sender);
448   }
449 }