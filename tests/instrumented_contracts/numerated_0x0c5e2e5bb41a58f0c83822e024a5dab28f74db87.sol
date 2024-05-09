1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 
113 
114 
115 
116 
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender) public view returns (uint256);
124   function transferFrom(address from, address to, uint256 value) public returns (bool);
125   function approve(address spender, uint256 value) public returns (bool);
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) internal allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[_from]);
152     require(_value <= allowed[_from][msg.sender]);
153 
154     balances[_from] = balances[_from].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157     Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    *
164    * Beware that changing an allowance with this method brings the risk that someone may use both the old
165    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168    * @param _spender The address which will spend the funds.
169    * @param _value The amount of tokens to be spent.
170    */
171   function approve(address _spender, uint256 _value) public returns (bool) {
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(address _owner, address _spender) public view returns (uint256) {
184     return allowed[_owner][_spender];
185   }
186 
187   /**
188    * approve should be called when allowed[_spender] == 0. To increment
189    * allowed value is better to use this function to avoid 2 calls (and wait until
190    * the first transaction is mined)
191    * From MonolithDAO Token.sol
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
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
212 
213 
214 
215 
216 /**
217  * @title Mintable token
218  * @dev Simple ERC20 Token example, with mintable token creation
219  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
220  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
221  */
222 
223 contract MintableToken is StandardToken, Ownable {
224   event Mint(address indexed to, uint256 amount);
225   event MintFinished();
226 
227   bool public mintingFinished = false;
228 
229 
230   modifier canMint() {
231     require(!mintingFinished);
232     _;
233   }
234 
235   /**
236    * @dev Function to mint tokens
237    * @param _to The address that will receive the minted tokens.
238    * @param _amount The amount of tokens to mint.
239    * @return A boolean that indicates if the operation was successful.
240    */
241   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
242     totalSupply = totalSupply.add(_amount);
243     balances[_to] = balances[_to].add(_amount);
244     Mint(_to, _amount);
245     Transfer(address(0), _to, _amount);
246     return true;
247   }
248 
249   /**
250    * @dev Function to stop minting new tokens.
251    * @return True if the operation was successful.
252    */
253   function finishMinting() onlyOwner canMint public returns (bool) {
254     mintingFinished = true;
255     MintFinished();
256     return true;
257   }
258 }
259 
260 
261 contract PuregoldToken is MintableToken {
262     string public name = "Puregold Token";
263     string public symbol = "PGT";
264     uint public decimals = 18;
265 }
266 
267 
268 
269 
270 
271 
272 
273 /**
274  * @title SafeMath
275  * @dev Math operations with safety checks that throw on error
276  */
277 library SafeMath {
278   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
279     if (a == 0) {
280       return 0;
281     }
282     uint256 c = a * b;
283     assert(c / a == b);
284     return c;
285   }
286 
287   function div(uint256 a, uint256 b) internal pure returns (uint256) {
288     // assert(b > 0); // Solidity automatically throws when dividing by 0
289     uint256 c = a / b;
290     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
291     return c;
292   }
293 
294   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
295     assert(b <= a);
296     return a - b;
297   }
298 
299   function add(uint256 a, uint256 b) internal pure returns (uint256) {
300     uint256 c = a + b;
301     assert(c >= a);
302     return c;
303   }
304 }
305 
306 
307 /**
308  * @title Crowdsale
309  * @dev Crowdsale is a base contract for managing a token crowdsale.
310  * Crowdsales have a start and end timestamps, where investors can make
311  * token purchases and the crowdsale will assign them tokens based
312  * on a token per ETH rate. Funds collected are forwarded to a wallet
313  * as they arrive.
314  */
315 contract Crowdsale {
316   using SafeMath for uint256;
317 
318   // The token being sold
319   MintableToken public token;
320 
321   // start and end timestamps where investments are allowed (both inclusive)
322   uint256 public startTime;
323   uint256 public endTime;
324 
325   // address where funds are collected
326   address public wallet;
327 
328   // how many token units a buyer gets per wei
329   uint256 public rate;
330 
331   // amount of raised money in wei
332   uint256 public weiRaised;
333 
334   /**
335    * event for token purchase logging
336    * @param purchaser who paid for the tokens
337    * @param beneficiary who got the tokens
338    * @param value weis paid for purchase
339    * @param amount amount of tokens purchased
340    */
341   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
342 
343 
344   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
345     require(_startTime >= now);
346     require(_endTime >= _startTime);
347     require(_rate > 0);
348     require(_wallet != address(0));
349 
350     token = createTokenContract();
351     startTime = _startTime;
352     endTime = _endTime;
353     rate = _rate;
354     wallet = _wallet;
355   }
356 
357   // creates the token to be sold.
358   // override this method to have crowdsale of a specific mintable token.
359   function createTokenContract() internal returns (MintableToken) {
360     return new MintableToken();
361   }
362 
363 
364   // fallback function can be used to buy tokens
365   function () external payable {
366     buyTokens(msg.sender);
367   }
368 
369   // low level token purchase function
370   function buyTokens(address beneficiary) public payable {
371     require(beneficiary != address(0));
372     require(validPurchase());
373 
374     uint256 weiAmount = msg.value;
375 
376     // calculate token amount to be created
377     uint256 tokens = weiAmount.mul(rate);
378 
379     // update state
380     weiRaised = weiRaised.add(weiAmount);
381 
382     token.mint(beneficiary, tokens);
383     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
384 
385     forwardFunds();
386   }
387 
388   // send ether to the fund collection wallet
389   // override to create custom fund forwarding mechanisms
390   function forwardFunds() internal {
391     wallet.transfer(msg.value);
392   }
393 
394   // @return true if the transaction can buy tokens
395   function validPurchase() internal view returns (bool) {
396     bool withinPeriod = now >= startTime && now <= endTime;
397     bool nonZeroPurchase = msg.value != 0;
398     return withinPeriod && nonZeroPurchase;
399   }
400 
401   // @return true if crowdsale event has ended
402   function hasEnded() public view returns (bool) {
403     return now > endTime;
404   }
405 
406 
407 }
408 
409 
410 
411 
412 
413 
414 /**
415  * @title CappedCrowdsale
416  * @dev Extension of Crowdsale with a max amount of funds raised
417  */
418 contract CappedCrowdsale is Crowdsale {
419   using SafeMath for uint256;
420 
421   uint256 public cap;
422 
423   function CappedCrowdsale(uint256 _cap) public {
424     require(_cap > 0);
425     cap = _cap;
426   }
427 
428   // overriding Crowdsale#validPurchase to add extra cap logic
429   // @return true if investors can buy at the moment
430   function validPurchase() internal view returns (bool) {
431     bool withinCap = weiRaised.add(msg.value) <= cap;
432     return super.validPurchase() && withinCap;
433   }
434 
435   // overriding Crowdsale#hasEnded to add cap logic
436   // @return true if crowdsale event has ended
437   function hasEnded() public view returns (bool) {
438     bool capReached = weiRaised >= cap;
439     return super.hasEnded() || capReached;
440   }
441 
442 }
443 
444 
445 
446 contract PuregoldTokenICO is CappedCrowdsale {
447   address public owner;
448   uint256 public minimum;
449 
450   function PuregoldTokenICO(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap, uint256 _minimum) 
451     CappedCrowdsale(_cap)
452     Crowdsale(_startTime, _endTime, _rate, _wallet) public {
453     	owner = msg.sender;
454     	minimum = _minimum;
455     }
456 
457   // creates the token to be sold.
458   function createTokenContract() internal returns (MintableToken) {
459     return PuregoldToken(0x9b3E946E1a8ea0112b147aF4E6e020752F2446BC);
460   }
461 
462   // set a minimum purchase
463   // @return true if investors can buy at the moment
464   function validPurchase() internal view returns (bool) {
465     bool minValue = msg.value >= minimum;
466     return super.validPurchase() && minValue;
467   }
468   
469   /**
470    * @dev Throws if called by any account other than the owner.
471    */
472   modifier onlyOwner() {
473     require(msg.sender == owner);
474     _;
475   }
476 
477   function transferTokenOwnership(address _to) onlyOwner public {
478     token.transferOwnership(_to);
479   }
480   
481 }