1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   uint256 public totalSupply;
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
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
110   * @dev transfer token for a specified address
111   * @param _to The address to transfer to.
112   * @param _value The amount to be transferred.
113   */
114   function transfer(address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value <= balances[msg.sender]);
117 
118     // SafeMath.sub will throw if there is not enough balance.
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) public view returns (uint256 balance) {
131     return balances[_owner];
132   }
133 
134 }
135 
136 
137 
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) internal allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    */
201   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
202     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206 
207   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
208     uint oldValue = allowed[msg.sender][_spender];
209     if (_subtractedValue > oldValue) {
210       allowed[msg.sender][_spender] = 0;
211     } else {
212       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213     }
214     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218 }
219 
220 /**
221  * @title Mintable token
222  * @dev Simple ERC20 Token example, with mintable token creation
223  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
224  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
225  */
226 
227 contract MintableToken is StandardToken, Ownable {
228   event Mint(address indexed to, uint256 amount);
229   event MintFinished();
230 
231   bool public mintingFinished = false;
232 
233 
234   modifier canMint() {
235     require(!mintingFinished);
236     _;
237   }
238 
239   /**
240    * @dev Function to mint tokens
241    * @param _to The address that will receive the minted tokens.
242    * @param _amount The amount of tokens to mint.
243    * @return A boolean that indicates if the operation was successful.
244    */
245   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
246     totalSupply = totalSupply.add(_amount);
247     balances[_to] = balances[_to].add(_amount);
248     Mint(_to, _amount);
249     Transfer(address(0), _to, _amount);
250     return true;
251   }
252 
253   /**
254    * @dev Function to stop minting new tokens.
255    * @return True if the operation was successful.
256    */
257   function finishMinting() onlyOwner public returns (bool) {
258     mintingFinished = true;
259     MintFinished();
260     return true;
261   }
262 }
263 
264 
265 /**
266  * @title Crowdsale
267  * @dev Crowdsale is a base contract for managing a token crowdsale.
268  * Crowdsales have a start and end timestamps, where investors can make
269  * token purchases and the crowdsale will assign them tokens based
270  * on a token per ETH rate. Funds collected are forwarded to a wallet
271  * as they arrive.
272  */
273 contract Crowdsale {
274   using SafeMath for uint256;
275 
276   // The token being sold
277   MintableToken public token;
278 
279   // start and end timestamps where investments are allowed (both inclusive)
280   uint256 public startTime;
281   uint256 public endTime;
282 
283   // address where funds are collected
284   address public wallet;
285 
286   // how many token units a buyer gets per wei
287   uint256 public rate;
288 
289   // amount of raised money in wei
290   uint256 public weiRaised;
291 
292   /**
293    * event for token purchase logging
294    * @param purchaser who paid for the tokens
295    * @param beneficiary who got the tokens
296    * @param value weis paid for purchase
297    * @param amount amount of tokens purchased
298    */
299   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
300 
301 
302   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
303     require(_startTime >= now);
304     require(_endTime >= _startTime);
305     require(_rate > 0);
306     require(_wallet != address(0));
307 
308     token = createTokenContract();
309     startTime = _startTime;
310     endTime = _endTime;
311     rate = _rate;
312     wallet = _wallet;
313   }
314 
315   // creates the token to be sold.
316   // override this method to have crowdsale of a specific mintable token.
317   function createTokenContract() internal returns (MintableToken) {
318     return new MintableToken();
319   }
320 
321 
322   // fallback function can be used to buy tokens
323   function () payable public {
324     buyTokens(msg.sender);
325   }
326 
327   // low level token purchase function
328   function buyTokens(address beneficiary) public payable {
329     require(beneficiary != address(0));
330     require(validPurchase());
331 
332     uint256 weiAmount = msg.value;
333 
334     // calculate token amount to be created
335     uint256 tokens = weiAmount.mul(rate);
336 
337     // update state
338     weiRaised = weiRaised.add(weiAmount);
339 
340     token.mint(beneficiary, tokens);
341     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
342 
343     forwardFunds();
344   }
345 
346   // send ether to the fund collection wallet
347   // override to create custom fund forwarding mechanisms
348   function forwardFunds() internal {
349     wallet.transfer(msg.value);
350   }
351 
352   // @return true if the transaction can buy tokens
353   function validPurchase() internal view returns (bool) {
354     bool withinPeriod = now >= startTime && now <= endTime;
355     bool nonZeroPurchase = msg.value != 0;
356     return withinPeriod && nonZeroPurchase;
357   }
358 
359   // @return true if crowdsale event has ended
360   function hasEnded() public view returns (bool) {
361     return now > endTime;
362   }
363 
364 
365 }
366 
367 
368 /**
369  * @title CappedCrowdsale
370  * @dev Extension of Crowdsale with a max amount of funds raised
371  */
372 contract CappedCrowdsale is Crowdsale {
373   using SafeMath for uint256;
374 
375   uint256 public cap;
376 
377   function CappedCrowdsale(uint256 _cap) public {
378     require(_cap > 0);
379     cap = _cap;
380   }
381 
382   // overriding Crowdsale#validPurchase to add extra cap logic
383   // @return true if investors can buy at the moment
384   function validPurchase() internal view returns (bool) {
385     bool withinCap = weiRaised.add(msg.value) <= cap;
386     return super.validPurchase() && withinCap;
387   }
388 
389   // overriding Crowdsale#hasEnded to add cap logic
390   // @return true if crowdsale event has ended
391   function hasEnded() public view returns (bool) {
392     bool capReached = weiRaised >= cap;
393     return super.hasEnded() || capReached;
394   }
395 
396 }
397 
398 
399 
400 /**
401  * @title PumpKoin
402  * @dev Very simple ERC20 Token that can be minted.
403  * It is meant to be used in a crowdsale contract.
404  */
405 contract PumpKoin is MintableToken {
406 
407   string public constant name = "PumpKoin";
408   string public constant symbol = "PMPK";
409   uint8 public constant decimals = 18;
410 
411 }
412 
413 /**
414  * @title PumpKoinCrowdsale
415  * @dev This is an example of a fully fledged crowdsale.
416  * The way to add new features to a base crowdsale is by multiple inheritance.
417  * In this example we are providing following extensions:
418  * CappedCrowdsale - sets a max boundary for raised funds
419  *
420  * After adding multiple features it's good practice to run integration tests
421  * to ensure that subcontracts works together as intended.
422  */
423 contract PumpKoinCrowdsale is CappedCrowdsale {
424 
425  function PumpKoinCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet) public
426     CappedCrowdsale(_cap)
427     Crowdsale(_startTime, _endTime, _rate, _wallet)
428   {
429   }
430 
431   function createTokenContract() internal returns (MintableToken) {
432     MintableToken pcoin = new PumpKoin();
433    
434 
435     pcoin.mint(0x2e05Fbca01669B20CF9a51Dcd0ca9F1C88b534d4, 500000000000000000000000);
436     return pcoin;
437   }
438 
439 }