1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     // SafeMath.sub will throw if there is not enough balance.
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 /**
213  * @title Ownable
214  * @dev The Ownable contract has an owner address, and provides basic authorization control
215  * functions, this simplifies the implementation of "user permissions".
216  */
217 contract Ownable {
218   address public owner;
219 
220 
221   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   function Ownable() public {
229     owner = msg.sender;
230   }
231 
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address newOwner) public onlyOwner {
245     require(newOwner != address(0));
246     OwnershipTransferred(owner, newOwner);
247     owner = newOwner;
248   }
249 
250 }
251 
252 /**
253  * @title Mintable token
254  * @dev Simple ERC20 Token example, with mintable token creation
255  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
256  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
257  */
258 contract MintableToken is StandardToken, Ownable {
259   event Mint(address indexed to, uint256 amount);
260   event MintFinished();
261 
262   bool public mintingFinished = false;
263 
264 
265   modifier canMint() {
266     require(!mintingFinished);
267     _;
268   }
269 
270   /**
271    * @dev Function to mint tokens
272    * @param _to The address that will receive the minted tokens.
273    * @param _amount The amount of tokens to mint.
274    * @return A boolean that indicates if the operation was successful.
275    */
276   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
277     totalSupply_ = totalSupply_.add(_amount);
278     balances[_to] = balances[_to].add(_amount);
279     Mint(_to, _amount);
280     Transfer(address(0), _to, _amount);
281     return true;
282   }
283 
284   /**
285    * @dev Function to stop minting new tokens.
286    * @return True if the operation was successful.
287    */
288   function finishMinting() onlyOwner canMint public returns (bool) {
289     mintingFinished = true;
290     MintFinished();
291     return true;
292   }
293 }
294 
295 /**
296  * @title Crowdsale
297  * @dev Crowdsale is a base contract for managing a token crowdsale.
298  * Crowdsales have a start and end timestamps, where investors can make
299  * token purchases and the crowdsale will assign them tokens based
300  * on a token per ETH rate. Funds collected are forwarded to a wallet
301  * as they arrive. The contract requires a MintableToken that will be
302  * minted as contributions arrive, note that the crowdsale contract
303  * must be owner of the token in order to be able to mint it.
304  */
305 contract Crowdsale {
306   using SafeMath for uint256;
307 
308   // The token being sold
309   MintableToken public token;
310 
311   // start and end timestamps where investments are allowed (both inclusive)
312   uint256 public startTime;
313   uint256 public endTime;
314 
315   // address where funds are collected
316   address public wallet;
317 
318   // how many token units a buyer gets per wei
319   uint256 public rate;
320 
321   // amount of raised money in wei
322   uint256 public weiRaised;
323 
324   /**
325    * event for token purchase logging
326    * @param purchaser who paid for the tokens
327    * @param beneficiary who got the tokens
328    * @param value weis paid for purchase
329    * @param amount amount of tokens purchased
330    */
331   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
332 
333 
334   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, MintableToken _token) public {
335     require(_startTime >= now);
336     require(_endTime >= _startTime);
337     require(_rate > 0);
338     require(_wallet != address(0));
339     require(_token != address(0));
340 
341     startTime = _startTime;
342     endTime = _endTime;
343     rate = _rate;
344     wallet = _wallet;
345     token = _token;
346   }
347 
348   // fallback function can be used to buy tokens
349   function () external payable {
350     buyTokens(msg.sender);
351   }
352 
353   // low level token purchase function
354   function buyTokens(address beneficiary) public payable {
355     require(beneficiary != address(0));
356     require(validPurchase());
357 
358     uint256 weiAmount = msg.value;
359 
360     // calculate token amount to be created
361     uint256 tokens = getTokenAmount(weiAmount);
362 
363     // update state
364     weiRaised = weiRaised.add(weiAmount);
365 
366     token.mint(beneficiary, tokens);
367     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
368 
369     forwardFunds();
370   }
371 
372   // @return true if crowdsale event has ended
373   function hasEnded() public view returns (bool) {
374     return now > endTime;
375   }
376 
377   // Override this method to have a way to add business logic to your crowdsale when buying
378   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
379     return weiAmount.mul(rate);
380   }
381 
382   // send ether to the fund collection wallet
383   // override to create custom fund forwarding mechanisms
384   function forwardFunds() internal {
385     wallet.transfer(msg.value);
386   }
387 
388   // @return true if the transaction can buy tokens
389   function validPurchase() internal view returns (bool) {
390     bool withinPeriod = now >= startTime && now <= endTime;
391     bool nonZeroPurchase = msg.value != 0;
392     return withinPeriod && nonZeroPurchase;
393   }
394 
395 }
396 
397 contract CappedCrowdsale is Crowdsale {
398   using SafeMath for uint256;
399 
400   uint256 public cap;
401 
402   function CappedCrowdsale(uint256 _cap) public {
403     require(_cap > 0);
404     cap = _cap;
405   }
406 
407   // overriding Crowdsale#hasEnded to add cap logic
408   // @return true if crowdsale event has ended
409   function hasEnded() public view returns (bool) {
410     bool capReached = weiRaised >= cap;
411     return capReached || super.hasEnded();
412   }
413 
414   // overriding Crowdsale#validPurchase to add extra cap logic
415   // @return true if investors can buy at the moment
416   function validPurchase() internal view returns (bool) {
417     bool withinCap = weiRaised.add(msg.value) <= cap;
418     return withinCap && super.validPurchase();
419   }
420 
421 }
422 
423 contract HKYCrowdsale is CappedCrowdsale {
424 
425   function HKYCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, MintableToken _token) public
426     CappedCrowdsale(36000 ether)
427     Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
428   {
429   }
430 }