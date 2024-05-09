1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a / b;
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal constant returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53   
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances. 
59  */
60 contract BasicToken is ERC20Basic {
61     
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) returns (bool) {
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of. 
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20, BasicToken {
97 
98   mapping (address => mapping (address => uint256)) allowed;
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
141    * @return A uint256 specifing the amount of tokens still available for the spender.
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
155     
156   address public owner;
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166   /**
167    * @dev Throws if called by any account other than the owner.
168    */
169   modifier onlyOwner() {
170     require(msg.sender == owner);
171     _;
172   }
173 
174 }
175 
176 /**
177  * @title Mintable token
178  * @dev Simple ERC20 Token example, with mintable token creation
179  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
180  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
181  */
182 
183 contract MintableToken is StandardToken, Ownable {
184     
185   event Mint(address indexed to, uint256 amount);
186   
187   event MintFinished();
188 
189   bool public mintingFinished = false;
190 
191   modifier canMint() {
192     require(!mintingFinished);
193     _;
194   }
195 
196   /**
197    * @dev Function to mint tokens
198    * @param _to The address that will recieve the minted tokens.
199    * @param _amount The amount of tokens to mint.
200    * @return A boolean that indicates if the operation was successful.
201    */
202   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
203     totalSupply = totalSupply.add(_amount);
204     balances[_to] = balances[_to].add(_amount);
205     Mint(_to, _amount);
206     return true;
207   }
208 
209   /**
210    * @dev Function to stop minting new tokens.
211    * @return True if the operation was successful.
212    */
213   function finishMinting() onlyOwner returns (bool) {
214     mintingFinished = true;
215     MintFinished();
216     return true;
217   }
218   
219 }
220 
221 contract EstateCoin is MintableToken {
222     
223     string public constant name = "EstateCoin";
224     
225     string public constant symbol = "ESC";
226     
227     uint32 public constant decimals = 2;
228     
229 }
230 
231 /**
232  * @title RefundVault
233  * @dev This contract is used for storing funds while a crowdsale
234  * is in progress. Supports refunding the money if crowdsale fails,
235  * and forwarding it if crowdsale is successful.
236  */
237 contract RefundVault is Ownable {
238   using SafeMath for uint256;
239 
240   enum State { Active, Refunding, Closed }
241 
242   mapping (address => uint256) public deposited;
243   address public wallet;
244   State public state;
245 
246   event Closed();
247   event RefundsEnabled();
248   event Refunded(address indexed beneficiary, uint256 weiAmount);
249 
250   function RefundVault(address _wallet) {
251     require(_wallet != 0x0);
252     wallet = _wallet;
253     state = State.Active;
254   }
255 
256   function deposit(address investor) onlyOwner public payable {
257     require(state == State.Active);
258     deposited[investor] = deposited[investor].add(msg.value);
259   }
260 
261   function close() onlyOwner public {
262     require(state == State.Active);
263     state = State.Closed;
264     Closed();
265     wallet.transfer(this.balance);
266   }
267 
268   function enableRefunds() onlyOwner public {
269     require(state == State.Active);
270     state = State.Refunding;
271     RefundsEnabled();
272   }
273 
274   function refund(address investor) public {
275     require(state == State.Refunding);
276     uint256 depositedValue = deposited[investor];
277     deposited[investor] = 0;
278     investor.transfer(depositedValue);
279     Refunded(investor, depositedValue);
280   }
281 }
282 
283 /**
284  * @title ESCCrowdsale
285  */
286 contract ESCCrowdsale is Ownable {
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
305   //amount of sold money in wei
306   uint256 public tokenSold = 0;
307   
308   uint256 public cap;
309 
310   /**
311    * event for token purchase logging
312    * @param purchaser who paid for the tokens
313    * @param beneficiary who got the tokens
314    * @param value weis paid for purchase
315    * @param amount amount of tokens purchased
316    */
317   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
318 
319   /**
320    * event for bonuses logging
321    * @param purchaser who paid for the tokens
322    * @param beneficiary who got the bonus
323    * @param amount amount of bonuses
324    */
325   event TokenBonus(address indexed purchaser, address indexed beneficiary, uint256 amount);
326 
327   bool public isFinalized = false;
328 
329   event Finalized();
330 
331   // minimum amount of funds to be raised in weis
332   uint256 public goal;
333 
334   // refund vault used to hold funds while crowdsale is running
335   RefundVault public vault;
336 
337   function ESCCrowdsale() {
338     startTime = 1506118400;//1506118400
339     endTime = 1507896000;
340     rate = 250;
341     wallet = msg.sender;
342     cap = 42550000000000000000000;
343     vault = new RefundVault(wallet);
344     goal = 2950000000000000000000;
345 
346     //startTime = 1506118400; //4rd October 2017 12:00:00 GMT //1507118400
347     //endTime = 1507896000; //13th October 2017 12:00:00 GMT
348     //rate = 250; //250ESC = 1ETH
349     //wallet = msg.sender;
350     //uint256 _cap = 42550000000000000000000;
351     //uint256 _goal = 2950000000000000000000; // Minimal goal is 2950ETH = 4400ETH - 1450ETH(funding on Waves Platform)
352 
353     require(startTime <= now);
354     require(endTime >= startTime);
355     require(rate > 0);
356     require(wallet != 0x0);
357     require(cap > 0);
358     require(goal > 0);
359 
360     token = createTokenContract();
361   }
362 
363   // creates the token to be sold.
364   // override this method to have crowdsale of a specific mintable token.
365   function createTokenContract() internal returns (MintableToken) {
366     return EstateCoin(0xE554056146fad6f2A7B5D5dbBb6f6763d58926c5);
367     //return new EstateCoin();
368   }
369 
370   // fallback function can be used to buy tokens
371   function () payable {
372     buyTokens(msg.sender);
373   }
374 
375   // low level token purchase function
376   function buyTokens(address beneficiary) public payable {
377     require(beneficiary != 0x0);
378     require(validPurchase());
379 
380     uint256 weiAmount = msg.value;
381 
382     // calculate token amount to be created
383     uint256 tokens = weiAmount.mul(rate);
384 
385     // update state
386     weiRaised = weiRaised.add(weiAmount);
387 
388     token.mint(beneficiary, tokens);
389     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
390 
391     forwardFunds();
392 
393     tokenSold += msg.value.mul(rate);
394     uint256 bonus = 0;
395     if (now < 1507204800) {
396         bonus = tokenSold.div(20); //5%
397     } else if (now < 1507291200) {
398         bonus = tokenSold.div(25); //4%
399     } else if (now < 1507377600) {
400         bonus = tokenSold.div(33); //3%
401     } else if (now < 1507464000) {
402         bonus = tokenSold.div(50); //2%
403     } else if (now < 1507550400) {
404         bonus = tokenSold.div(100); //1%
405     }
406     
407     if (bonus > 0) {
408         token.mint(beneficiary, bonus);
409         TokenBonus(msg.sender, beneficiary, bonus);
410     }
411   }
412 
413   // send ether to the fund collection wallet
414   // override to create custom fund forwarding mechanisms...
415   // We're overriding the fund forwarding from Crowdsale.
416   // In addition to sending the funds, we want to call
417   // the RefundVault deposit function
418   function forwardFunds() internal {
419     //wallet.transfer(msg.value);
420     vault.deposit.value(msg.value)(msg.sender);
421   }
422 
423   // @return true if the transaction can buy tokens
424   // overriding Crowdsale#validPurchase to add extra cap logic
425   // @return true if investors can buy at the moment
426   function validPurchase() internal constant returns (bool) {
427     bool withinPeriod = now >= startTime && now <= endTime;
428     bool nonZeroPurchase = msg.value != 0;
429     bool withinCap = weiRaised.add(msg.value) <= cap;
430     return withinPeriod && nonZeroPurchase && withinCap;
431   }
432 
433   // @return true if crowdsale event has ended
434   function hasEnded() public constant returns (bool) {
435     bool capReached = weiRaised >= cap;
436     return (now > endTime) || capReached;
437   }
438     
439   /**
440    * @dev Must be called after crowdsale ends, to do some extra finalization
441    * work. Calls the contract's finalization function.
442    */
443   function finalize() onlyOwner public {
444     require(!isFinalized);
445     require(hasEnded());
446 
447     finalization();
448     Finalized();
449 
450     isFinalized = true;
451   }
452   
453   // if crowdsale is unsuccessful, investors can claim refunds here
454   function claimRefund() public {
455     require(isFinalized);
456     require(!goalReached());
457 
458     vault.refund(msg.sender);
459   }
460 
461   // vault finalization task, called when owner calls finalize()
462   function finalization() internal {
463     if (goalReached()) {
464       token.mint(wallet, tokenSold.div(10)); //10% for owners, bounty, promo...
465       vault.close();
466     } else {
467       vault.enableRefunds();
468     }
469   }
470 
471   function goalReached() public constant returns (bool) {
472     return weiRaised >= goal;
473   }
474 
475 }