1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() public {
47     owner = msg.sender;
48   }
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56   /**
57    * @dev Allows the current owner to transfer control of the contract to a newOwner.
58    * @param newOwner The address to transfer ownership to.
59    */
60   function transferOwnership(address newOwner) public onlyOwner {
61     require(newOwner != address(0));
62     OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 }
66 
67 
68 /**
69  * @title ERC20Basic
70  * @dev Simpler version of ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/179
72  */
73 contract ERC20Basic {
74   uint256 public totalSupply;
75   function balanceOf(address who) public view returns (uint256);
76   function transfer(address to, uint256 value) public returns (bool);
77   event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) public view returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances.
94  */
95 contract BasicToken is ERC20Basic {
96   using SafeMath for uint256;
97   mapping(address => uint256) balances;
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     // SafeMath.sub will throw if there is not enough balance.
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     Transfer(msg.sender, _to, _value);
111     return true;
112   }
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256 balance) {
119     return balances[_owner];
120   }
121 }
122 
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20, BasicToken {
132   mapping (address => mapping (address => uint256)) internal allowed;
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143     balances[_from] = balances[_from].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146     Transfer(_from, _to, _value);
147     return true;
148   }
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164   /**
165    * @dev Function to check the amount of tokens that an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for the spender.
169    */
170   function allowance(address _owner, address _spender) public view returns (uint256) {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175    * @dev Increase the amount of tokens that an owner allowed to a spender.
176    *
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    * @param _spender The address which will spend the funds.
182    * @param _addedValue The amount of tokens to increase the allowance by.
183    */
184   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
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
209 }
210 
211 
212 /**
213  * @title Mintable token
214  * @dev Simple ERC20 Token example, with mintable token creation
215  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
216  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
217  */
218 contract MintableToken is StandardToken, Ownable {
219   event Mint(address indexed to, uint256 amount);
220   event MintFinished();
221   bool public mintingFinished = false;
222   modifier canMint() {
223     require(!mintingFinished);
224     _;
225   }  
226   //NMY Jan 2018: added constructor
227   string public constant symbol = "SIZ";
228   string public  constant name = "SIZ Token";
229   uint8 public constant decimals = 18;
230   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
231   function MintableToken(address _wallet) public {
232      totalSupply = INITIAL_SUPPLY;
233      balances[_wallet] = INITIAL_SUPPLY;
234      Mint(_wallet, INITIAL_SUPPLY);
235   }
236 
237   /**
238    * @dev Function to mint tokens
239    * @param _to The address that will receive the minted tokens.
240    * @param _amount The amount of tokens to mint.
241    * @return A boolean that indicates if the operation was successful.
242    */
243   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
244     totalSupply = totalSupply.add(_amount);
245     balances[_to] = balances[_to].add(_amount);
246     Mint(_to, _amount);
247     Transfer(address(0), _to, _amount);
248     return true;
249   }
250   /**
251    * @dev Function to stop minting new tokens.
252    * @return True if the operation was successful.
253    */
254   function finishMinting() onlyOwner canMint public returns (bool) {
255     mintingFinished = true;
256     MintFinished();
257     return true;
258   }
259 }
260 
261 
262 /**
263  * @title Crowdsale
264  * @dev Crowdsale is a base contract for managing a token crowdsale.
265  * Crowdsales have a start and end timestamps, where investors can make
266  * token purchases and the crowdsale will assign them tokens based
267  * on a token per ETH rate. Funds collected are forwarded to a wallet
268  * as they arrive.
269  */
270 contract Crowdsale {
271   using SafeMath for uint256;
272   // The token being sold
273   MintableToken public token;
274   // start and end timestamps where investments are allowed (both inclusive)
275   uint256 public startTime = now + 86400*31 seconds;
276   uint256 public endTime =  startTime + 86400*365 seconds;
277   
278   //uint256 public startTime = now + 120 seconds;
279   //uint256 public endTime =  startTime + 3600 seconds;
280   // address where funds are collected
281   address public wallet = 0xc96c60469E38Fb5f725A7e1a134394a91aC9488f;
282   // how many minimum-token units a buyer gets per wei 
283   // (ie for 18 decimals token: how many tokens per ether)
284   uint256 public rate =  100000;
285   // amount of raised money in wei
286   uint256 public weiRaised;
287 
288 
289   /**
290    * event for token purchase logging
291    * @param purchaser who paid for the tokens
292    * @param beneficiary who got the tokens
293    * @param value weis paid for purchase
294    * @param amount amount of tokens purchased
295    */
296   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
297   function Crowdsale() public {
298     require(startTime >= now);
299     require(endTime >= startTime);
300     require(rate > 0);
301     require(wallet != address(0));
302     // NMY Jan 2018: added _wallet parameter
303     token = createTokenContract(wallet);
304   }
305   // creates the token to be sold.
306   // override this method to have crowdsale of a specific mintable token.
307   // NMY Jan 2018: added _wallet parameter
308   function createTokenContract(address _wallet) internal returns (MintableToken) {
309     return new MintableToken(_wallet);
310   }
311   // fallback function can be used to buy tokens
312   function () external payable {
313     buyTokens(msg.sender);
314   }
315   // low level token purchase function
316   function buyTokens(address beneficiary) public payable {
317     require(beneficiary != address(0));
318     require(validPurchase());
319     uint256 weiAmount = msg.value;
320     // calculate token amount to be created
321     // uint256 tokens = weiAmount.mul(rate);
322     uint256 rateScaled = rate.mul
323             (2 ** uint256(11*(now-startTime)/(endTime-startTime+1))); 
324     uint256 tokens = weiAmount.mul(rateScaled);
325     
326     // update state
327     weiRaised = weiRaised.add(weiAmount);
328     token.mint(beneficiary, tokens);
329     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
330     forwardFunds();
331   }
332   // send ether to the fund collection wallet
333   // override to create custom fund forwarding mechanisms
334   function forwardFunds() internal {
335     wallet.transfer(msg.value);
336   }
337   // @return true if the transaction can buy tokens
338   function validPurchase() internal view returns (bool) {
339     bool withinPeriod = now >= startTime && now <= endTime;
340     bool nonZeroPurchase = msg.value != 0;
341     return withinPeriod && nonZeroPurchase;
342   }
343   // @return true if crowdsale event has ended
344   function hasEnded() public view returns (bool) {
345     return now > endTime;
346   }
347 }
348 
349 
350 /**
351  * @title FinalizableCrowdsale
352  * @dev Extension of Crowdsale where an owner can do extra work
353  * after finishing.
354  */
355 contract FinalizableCrowdsale is Crowdsale, Ownable {
356   using SafeMath for uint256;
357   bool public isFinalized = false;
358   event Finalized();
359   /**
360    * @dev Must be called after crowdsale ends, to do some extra finalization
361    * work. Calls the contract's finalization function.
362    */
363   function finalize() onlyOwner public {
364     require(!isFinalized);
365     require(hasEnded());
366     finalization();
367     Finalized();
368     isFinalized = true;
369   }
370   /**
371    * @dev Can be overridden to add finalization logic. The overriding function
372    * should call super.finalization() to ensure the chain of finalization is
373    * executed entirely.
374    */
375   function finalization() internal {
376       //NMY
377       //isFinalized = false;
378   }
379 }
380 
381 
382 /**
383  * @title RefundVault
384  * @dev This contract is used for storing funds while a crowdsale
385  * is in progress. Supports refunding the money if crowdsale fails,
386  * and forwarding it if crowdsale is successful.
387  */
388 contract RefundVault is Ownable {
389   using SafeMath for uint256;
390   enum State { Active, Refunding, Closed }
391   mapping (address => uint256) public deposited;
392   address public wallet;
393   State public state;
394   event Closed();
395   event RefundsEnabled();
396   event Refunded(address indexed beneficiary, uint256 weiAmount);
397   function RefundVault(address _wallet) public {
398     require(_wallet != address(0));
399     wallet = _wallet;
400     state = State.Active;
401   }
402 /**/
403   function deposit(address investor) onlyOwner public payable {
404     require(state == State.Active);
405     deposited[investor] = deposited[investor].add(msg.value);
406     //deposited[investor] = SafeMath.add(deposited[investor], msg.value);
407   }
408   function close() onlyOwner public {
409     require(state == State.Active);
410     state = State.Closed;
411     Closed();
412     wallet.transfer(this.balance);
413   }
414   function enableRefunds() onlyOwner public {
415     require(state == State.Active);
416     state = State.Refunding;
417     RefundsEnabled();
418   }
419   function refund(address investor) public {
420     require(state == State.Refunding);
421     uint256 depositedValue = deposited[investor];
422     deposited[investor] = 0;
423     investor.transfer(depositedValue);
424     Refunded(investor, depositedValue);
425   }
426   /**/
427   
428 }
429 
430 
431 
432 /**
433  * @title RefundableCrowdsale
434  * @dev Extension of Crowdsale contract that adds a funding goal, and
435  * the possibility of users getting a refund if goal is not met.
436  * Uses a RefundVault as the crowdsale's vault.
437  */
438 contract RefundableCrowdsale is FinalizableCrowdsale {
439   using SafeMath for uint256;  
440   // minimum amount of funds to be raised in weis
441   uint256 public goal = 5000 * (10 ** 18);
442   // refund vault used to hold funds while crowdsale is running
443   RefundVault public vault;
444   function RefundableCrowdsale() public {
445     require(goal > 0);
446     vault = new RefundVault(wallet);
447   }
448   // We're overriding the fund forwarding from Crowdsale.
449   // In addition to sending the funds, we want to call
450   // the RefundVault deposit function
451   // NMY Jan 2018: forwardFunds after the goal is reached
452   /**/
453   function forwardFunds() internal {
454     if (goalReached()) {
455         super.forwardFunds();
456         if(vault.balance >= 1) vault.close();
457     } else {
458         vault.deposit.value(msg.value)(msg.sender);
459     }
460   }
461   
462   // if crowdsale is unsuccessful, investors can claim refunds here
463   function claimRefund() public {
464     require(isFinalized);
465     require(!goalReached());
466     vault.refund(msg.sender);
467   }
468   
469   // vault finalization task, called when owner calls finalize()
470   function finalization() internal {
471     if (goalReached()) {
472         if(vault.balance >= 1)
473            vault.close();
474     } else {
475         vault.enableRefunds();
476     }
477     super.finalization();
478   }
479   
480   function goalReached() public view returns (bool) {
481     return weiRaised >= goal;
482   }
483   /**/
484 }