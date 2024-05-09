1 pragma solidity ^0.4.18;
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
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75 
76     // SafeMath.sub will throw if there is not enough balance.
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of.
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) public constant returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92 }
93 
94 
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) allowed;
106 
107 
108   /**
109    * @dev Transfer tokens from one address to another
110    * @param _from address The address which you want to send tokens from
111    * @param _to address The address which you want to transfer to
112    * @param _value uint256 the amount of tokens to be transferred
113    */
114   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116 
117     uint256 _allowance = allowed[_from][msg.sender];
118 
119     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
120     // require (_value <= _allowance);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = _allowance.sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    *
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    */
161   function increaseApproval (address _spender, uint _addedValue)
162     returns (bool success) {
163     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 
168   function decreaseApproval (address _spender, uint _subtractedValue)
169     returns (bool success) {
170     uint oldValue = allowed[msg.sender][_spender];
171     if (_subtractedValue > oldValue) {
172       allowed[msg.sender][_spender] = 0;
173     } else {
174       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175     }
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180 }
181 
182 
183 /**
184  * @title Ownable
185  * @dev The Ownable contract has an owner address, and provides basic authorization control
186  * functions, this simplifies the implementation of "user permissions".
187  */
188 contract Ownable {
189   address public owner;
190 
191 
192   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194 
195   /**
196    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
197    * account.
198    */
199   function Ownable() {
200     owner = msg.sender;
201   }
202 
203 
204   /**
205    * @dev Throws if called by any account other than the owner.
206    */
207   modifier onlyOwner() {
208     require(msg.sender == owner);
209     _;
210   }
211 
212 
213   /**
214    * @dev Allows the current owner to transfer control of the contract to a newOwner.
215    * @param newOwner The address to transfer ownership to.
216    */
217   function transferOwnership(address newOwner) onlyOwner public {
218     require(newOwner != address(0));
219     OwnershipTransferred(owner, newOwner);
220     owner = newOwner;
221   }
222 
223 }
224 
225 /**
226  * @title Mintable token
227  * @dev Simple ERC20 Token example, with mintable token creation
228  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
229  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
230  */
231 
232 contract MintableToken is StandardToken, Ownable {
233   event Mint(address indexed to, uint256 amount);
234   event MintFinished();
235 
236   bool public mintingFinished = false;
237 
238 
239   modifier canMint() {
240     require(!mintingFinished);
241     _;
242   }
243 
244   /**
245    * @dev Function to mint tokens
246    * @param _to The address that will receive the minted tokens.
247    * @param _amount The amount of tokens to mint.
248    * @return A boolean that indicates if the operation was successful.
249    */
250   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
251     totalSupply = totalSupply.add(_amount);
252     balances[_to] = balances[_to].add(_amount);
253     Mint(_to, _amount);
254     Transfer(0x0, _to, _amount);
255     return true;
256   }
257 
258   /**
259    * @dev Function to stop minting new tokens.
260    * @return True if the operation was successful.
261    */
262   function finishMinting() onlyOwner public returns (bool) {
263     mintingFinished = true;
264     MintFinished();
265     return true;
266   }
267 }
268 
269 
270 contract YobCoin is MintableToken {
271   string public name = "YOBANK";
272   string public symbol = "YOB";
273   uint256 public decimals = 18;
274 }
275 
276 /* -------------------------------------------*/
277 
278 /**
279  * @title Crowdsale
280  * @dev Crowdsale is a base contract for managing a token crowdsale.
281  * Crowdsales have a start and end timestamps, where investors can make
282  * token purchases and the crowdsale will assign them tokens based
283  * on a token per ETH rate. Funds collected are forwarded to a wallet
284  * as they arrive.
285  */
286 contract Crowdsale {
287   using SafeMath for uint256;
288 
289   // The token being sold
290   MintableToken public token;
291 
292   // start and end timestamps where investments are allowed (both inclusive)
293   uint256 public startTime;
294   uint256 public endTime;
295 
296   // address where funds are collected
297   address public wallet;
298 
299   // how many token units a buyer gets per wei
300   uint256 public rate;
301 
302   // amount of raised money in wei
303   uint256 public weiRaised;
304 
305   /**
306    * event for token purchase logging
307    * @param purchaser who paid for the tokens
308    * @param beneficiary who got the tokens
309    * @param value weis paid for purchase
310    * @param amount amount of tokens purchased
311    */
312   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
313 
314 
315   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
316     require(_startTime >= 0);
317     require(_endTime >= _startTime);
318     require(_rate > 0);
319     require(_wallet != 0x0);
320 
321     //token = createTokenContract();
322     startTime = _startTime;
323     endTime = _endTime;
324     rate = _rate;
325     wallet = _wallet;
326   }
327 
328   // creates the token to be sold.
329   // override this method to have crowdsale of a specific mintable token.
330   function createTokenContract() internal returns (MintableToken) {
331     return new MintableToken();
332   }
333 
334 
335   // fallback function can be used to buy tokens
336   function () payable {
337     buyTokens(msg.sender);
338   }
339 
340   // low level token purchase function
341   function buyTokens(address beneficiary) public payable {
342     require(beneficiary != 0x0);
343     require(validPurchase());
344 
345     uint256 weiAmount = msg.value;
346 
347     // calculate token amount to be created
348     uint256 tokens = weiAmount.mul(rate);
349 
350     // update state
351     weiRaised = weiRaised.add(weiAmount);
352 
353     token.mint(beneficiary, tokens);
354     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
355 
356     forwardFunds();
357   }
358 
359   // send ether to the fund collection wallet
360   // override to create custom fund forwarding mechanisms
361   function forwardFunds() internal {
362     wallet.transfer(msg.value);
363   }
364 
365   // @return true if the transaction can buy tokens
366   function validPurchase() internal constant returns (bool) {
367     bool withinPeriod = now >= startTime && now <= endTime;
368     bool nonZeroPurchase = msg.value != 0;
369     return withinPeriod && nonZeroPurchase;
370   }
371 
372   // @return true if crowdsale event has ended
373   function hasEnded() public constant returns (bool) {
374     return now > endTime;
375   }
376 
377 
378 }
379 
380 contract CappedCrowdsale is Crowdsale {
381   using SafeMath for uint256;
382 
383   uint256 public cap;
384 
385   function CappedCrowdsale(uint256 _cap) {
386     require(_cap > 0);
387     cap = _cap;
388   }
389 
390   // overriding Crowdsale#validPurchase to add extra cap logic
391   // @return true if investors can buy at the moment
392   function validPurchase() internal constant returns (bool) {
393     bool withinCap = weiRaised.add(msg.value) <= cap;
394     return super.validPurchase() && withinCap;
395   }
396 
397   // overriding Crowdsale#hasEnded to add cap logic
398   // @return true if crowdsale event has ended
399   function hasEnded() public constant returns (bool) {
400     bool capReached = weiRaised >= cap;
401     return super.hasEnded() || capReached;
402   }
403 
404 }
405 
406 
407 contract YobCoinCrowdsale is CappedCrowdsale, Ownable {
408 
409   function YobCoinCrowdsale()
410     //uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet
411     CappedCrowdsale(4000000000000000000000000000)
412     Crowdsale(1509186546, 1513376946, 2222, msg.sender) {          
413   }
414 
415   // creates the token to be sold.
416   // override this method to have crowdsale of a specific MintableToken token.
417   function createTokenContract() internal returns (MintableToken) {
418     //return new YobCoin();
419   }
420 
421   function changeTime(uint256 _startTime, uint256 _endTime) onlyOwner public returns (bool) {
422     startTime = _startTime;
423     endTime = _endTime;
424     return true;
425   }
426   
427   function changeCap(uint256 _cap) onlyOwner public returns (bool) {
428     cap = _cap;
429     return true;
430   }
431   
432   function changeRate(uint256 _rate) onlyOwner public returns (bool) {
433     rate = _rate;
434     return true;
435   }
436   
437   function changeWalletAddress(address _wallet) onlyOwner public returns (bool) {
438     wallet = _wallet;
439     return true;
440   }
441   
442   function extraMint(uint256 _amount) onlyOwner public returns (bool) {
443     token.mint(owner, _amount);
444     return true;
445   }
446   
447   function changeTokenContract(address _tokenAddress) onlyOwner public returns (bool) {
448     token = YobCoin(_tokenAddress);
449     return true;
450   }
451   
452   
453 }