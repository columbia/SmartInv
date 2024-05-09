1 pragma solidity ^0.4.15;
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
19   function Ownable() {
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
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
52     uint256 c = a * b;
53     assert(a == 0 || c / a == b);
54     return c;
55   }
56 
57   function div(uint256 a, uint256 b) internal constant returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   function add(uint256 a, uint256 b) internal constant returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/179
81  */
82 contract ERC20Basic {
83   uint256 public totalSupply;
84   function balanceOf(address who) public constant returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 
90 /**
91  * @title Basic token
92  * @dev Basic version of StandardToken, with no allowances.
93  */
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106 
107     // SafeMath.sub will throw if there is not enough balance.
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public constant returns (uint256 balance) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 
126 
127 
128 /**
129  * @title ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract ERC20 is ERC20Basic {
133   function allowance(address owner, address spender) public constant returns (uint256);
134   function transferFrom(address from, address to, uint256 value) public returns (bool);
135   function approve(address spender, uint256 value) public returns (bool);
136   event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) allowed;
150 
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amount of tokens to be transferred
157    */
158   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160 
161     uint256 _allowance = allowed[_from][msg.sender];
162 
163     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
164     // require (_value <= _allowance);
165 
166     balances[_from] = balances[_from].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     allowed[_from][msg.sender] = _allowance.sub(_value);
169     Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * approve should be called when allowed[_spender] == 0. To increment
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    */
205   function increaseApproval (address _spender, uint _addedValue)
206     returns (bool success) {
207     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212   function decreaseApproval (address _spender, uint _subtractedValue)
213     returns (bool success) {
214     uint oldValue = allowed[msg.sender][_spender];
215     if (_subtractedValue > oldValue) {
216       allowed[msg.sender][_spender] = 0;
217     } else {
218       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219     }
220     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224 }
225 
226 
227 /**
228  * @title Mintable token
229  * @dev Simple ERC20 Token example, with mintable token creation
230  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
231  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
232  */
233 
234 contract MintableToken is StandardToken, Ownable {
235   event Mint(address indexed to, uint256 amount);
236   event MintFinished();
237 
238   bool public mintingFinished = false;
239 
240 
241   modifier canMint() {
242     require(!mintingFinished);
243     _;
244   }
245 
246   /**
247    * @dev Function to mint tokens
248    * @param _to The address that will receive the minted tokens.
249    * @param _amount The amount of tokens to mint.
250    * @return A boolean that indicates if the operation was successful.
251    */
252   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
253     totalSupply = totalSupply.add(_amount);
254     balances[_to] = balances[_to].add(_amount);
255     Mint(_to, _amount);
256     Transfer(0x0, _to, _amount);
257     return true;
258   }
259 
260   /**
261    * @dev Function to stop minting new tokens.
262    * @return True if the operation was successful.
263    */
264   function finishMinting() onlyOwner public returns (bool) {
265     mintingFinished = true;
266     MintFinished();
267     return true;
268   }
269 }
270 
271 
272 
273 /**
274  * @title The Titanium BAR Token contract
275  * @dev The Titanium BAR Token contract
276  * @dev inherits from MintableToken and Ownable by Zeppelin
277  * @author James Connolly
278  */
279 contract BARToken is MintableToken {
280 
281   string public constant name = "PowH3D";
282   string public constant symbol = "P3D";
283   uint8 public constant decimals = 18;
284 
285 }
286 
287 /**
288  * @title BARTokenSale
289  * @dev 
290  * We add new features to a base crowdsale using multiple inheritance.
291  * We are using the following extensions:
292  * CappedCrowdsale - sets a max boundary for raised funds
293  
294  *
295  * The code is based on the contracts of Open Zeppelin and we add our contracts: BARTokenSale, and the BAR Token
296  *
297  * @author James Connolly
298  */
299 
300 
301 
302 
303 /**
304  * @title Crowdsale
305  * @dev Crowdsale is a base contract for managing a token crowdsale.
306  * Crowdsales have a start and end timestamps, where investors can make
307  * token purchases and the crowdsale will assign them tokens based
308  * on a token per ETH rate. Funds collected are forwarded to a wallet
309  * as they arrive.
310  */
311 contract Crowdsale {
312   using SafeMath for uint256;
313 
314   // The token being sold
315   MintableToken public token;
316 
317   // start and end timestamps where investments are allowed (both inclusive)
318   uint256 public startTime;
319   uint256 public endTime;
320 
321   // address where funds are collected
322   address public wallet;
323 
324   // how many token units a buyer gets per wei
325   uint256 public rate;
326 
327   // amount of raised money in wei
328   uint256 public weiRaised;
329 
330   /**
331    * event for token purchase logging
332    * @param purchaser who paid for the tokens
333    * @param beneficiary who got the tokens
334    * @param value weis paid for purchase
335    * @param amount amount of tokens purchased
336    */
337   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
338 
339 
340   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
341     require(_startTime >= now);
342     require(_endTime >= _startTime);
343     require(_rate > 0);
344     require(_wallet != 0x0);
345 
346     token = createTokenContract();
347     startTime = _startTime;
348     endTime = _endTime;
349     rate = _rate;
350     wallet = _wallet;
351   }
352 
353   // creates the token to be sold.
354   // override this method to have crowdsale of a specific mintable token.
355   function createTokenContract() internal returns (MintableToken) {
356     return new MintableToken();
357   }
358 
359 
360   // fallback function can be used to buy tokens
361   function () payable {
362     buyTokens(msg.sender);
363   }
364 
365   // low level token purchase function
366   function buyTokens(address beneficiary) public payable {
367     require(beneficiary != 0x0);
368     require(validPurchase());
369 
370     address team = 0x65dC43D9a882793B37d7bbe4f29566cD037e4474;
371     address bounty = 0x65dC43D9a882793B37d7bbe4f29566cD037e4474;
372     address reserve = 0x65dC43D9a882793B37d7bbe4f29566cD037e4474;
373 
374     uint256 weiAmount = msg.value;
375 
376     // calculate token amount to be created
377     uint256 tokens = weiAmount.mul(rate);
378     uint256 bountyAmount = weiAmount.mul(50);
379     uint256 teamAmount = weiAmount.mul(100);
380     uint256 reserveAmount = weiAmount.mul(50);
381 
382     // update state
383     weiRaised = weiRaised.add(weiAmount);
384 
385     token.mint(beneficiary, tokens);
386     token.mint(bounty, bountyAmount);
387     token.mint(team, teamAmount);
388     token.mint(reserve, reserveAmount);
389 
390     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
391 
392     forwardFunds();
393   }
394 
395   // send ether to the fund collection wallet
396   // override to create custom fund forwarding mechanisms
397   function forwardFunds() internal {
398     wallet.transfer(msg.value);
399   }
400 
401   // @return true if the transaction can buy tokens
402   function validPurchase() internal constant returns (bool) {
403     bool withinPeriod = now >= startTime && now <= endTime;
404     bool nonZeroPurchase = msg.value != 0;
405     return withinPeriod && nonZeroPurchase;
406   }
407 
408   // @return true if crowdsale event has ended
409   function hasEnded() public constant returns (bool) {
410     return now > endTime;
411   }
412 
413 
414 }
415 
416 /**
417  * @title CappedCrowdsale
418  * @dev Extension of Crowdsale with a max amount of funds raised
419  */
420 contract CappedCrowdsale is Crowdsale {
421   using SafeMath for uint256;
422 
423   uint256 public cap;
424 
425   function CappedCrowdsale(uint256 _cap) {
426     require(_cap > 0);
427     cap = _cap;
428   }
429 
430   // overriding Crowdsale#validPurchase to add extra cap logic
431   // @return true if investors can buy at the moment
432   function validPurchase() internal constant returns (bool) {
433     bool withinCap = weiRaised.add(msg.value) <= cap;
434     return super.validPurchase() && withinCap;
435   }
436 
437   // overriding Crowdsale#hasEnded to add cap logic
438   // @return true if crowdsale event has ended
439   function hasEnded() public constant returns (bool) {
440     bool capReached = weiRaised >= cap;
441     return super.hasEnded() || capReached;
442   }
443 
444 }
445 
446 contract BARTokenSale is CappedCrowdsale {
447 
448   uint256 public _startTime = 1511049540;
449   uint256 public _endTime = 1553144400;
450   uint256 public _rate = 300;
451   uint256 public _cap = 116666000000000000000000;
452   address public _wallet = 0x3472A603fED6345A87083b61eae0e0db7821959E;
453 
454   function BARTokenSale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet)
455     CappedCrowdsale(_cap)
456     //FinalizableCrowdsale()
457     Crowdsale(_startTime, _endTime, _rate, _wallet)
458   {
459     
460     
461     
462     //wallet = 0x3472A603fED6345A87083b61eae0e0db7821959E;
463     //As goal needs to be met for a successful crowdsale
464     //the value needs to less or equal than a cap which is limit for accepted funds
465     //require(_goal <= _cap);
466   }
467 
468   function createTokenContract() internal returns (MintableToken) {
469     return new BARToken();
470   }
471 
472 }