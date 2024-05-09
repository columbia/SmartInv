1 pragma solidity ^0.4.11;
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
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50     
51   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
52     uint256 c = a * b;
53     assert(a == 0 || c / a == b);
54     return c;
55   }
56 
57   function div(uint256 a, uint256 b) internal constant returns (uint256) {
58     uint256 c = a / b;
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal constant returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72   
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) constant returns (uint256);
83   function transfer(address to, uint256 value) returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) constant returns (uint256);
93   function transferFrom(address from, address to, uint256 value) returns (bool);
94   function approve(address spender, uint256 value) returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances. 
101  */
102 contract BasicToken is ERC20Basic {
103     
104   using SafeMath for uint256;
105 
106   mapping(address => uint256) balances;
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) returns (bool) {
114     balances[msg.sender] = balances[msg.sender].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     Transfer(msg.sender, _to, _value);
117     return true;
118   }
119 
120   /**
121   * @dev Gets the balance of the specified address.
122   * @param _owner The address to query the the balance of. 
123   * @return An uint256 representing the amount owned by the passed address.
124   */
125   function balanceOf(address _owner) constant returns (uint256 balance) {
126     return balances[_owner];
127   }
128 
129 }
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
140   mapping (address => mapping (address => uint256)) allowed;
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint256 the amout of tokens to be transfered
147    */
148   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
149     var _allowance = allowed[_from][msg.sender];
150 
151     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
152     // require (_value <= _allowance);
153 
154     balances[_to] = balances[_to].add(_value);
155     balances[_from] = balances[_from].sub(_value);
156     allowed[_from][msg.sender] = _allowance.sub(_value);
157     Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) returns (bool) {
167 
168     // To change the approve amount you first have to reduce the addresses`
169     //  allowance to zero by calling `approve(_spender, 0)` if it is not
170     //  already 0 to mitigate the race condition described here:
171     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
173 
174     allowed[msg.sender][_spender] = _value;
175     Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifing the amount of tokens still available for the spender.
184    */
185   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
186     return allowed[_owner][_spender];
187   }
188 
189 }
190 
191 /**
192  * @title Mintable token
193  * @dev Simple ERC20 Token example, with mintable token creation
194  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
195  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
196  */
197 
198 contract MintableToken is StandardToken, Ownable {
199     
200   event Mint(address indexed to, uint256 amount);
201   
202   event MintFinished();
203 
204   bool public mintingFinished = false;
205 
206   modifier canMint() {
207     require(!mintingFinished);
208     _;
209   }
210 
211   /**
212    * @dev Function to mint tokens
213    * @param _to The address that will recieve the minted tokens.
214    * @param _amount The amount of tokens to mint.
215    * @return A boolean that indicates if the operation was successful.
216    */
217   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
218     totalSupply = totalSupply.add(_amount);
219     balances[_to] = balances[_to].add(_amount);
220     Mint(_to, _amount);
221     return true;
222   }
223 
224   /**
225    * @dev Function to stop minting new tokens.
226    * @return True if the operation was successful.
227    */
228   function finishMinting() onlyOwner returns (bool) {
229     mintingFinished = true;
230     MintFinished();
231     return true;
232   }
233   
234 }
235 
236 contract EstateCoin is MintableToken {
237     
238     string public constant name = "EstateCoin";
239     
240     string public constant symbol = "ESC";
241     
242     uint32 public constant decimals = 2;
243     
244     uint256 public maxTokens = 12100000000000000000000000;
245 
246   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
247     if (totalSupply.add(_amount) > maxTokens) {
248         throw;
249     }
250 
251     return super.mint(_to, _amount);
252   }
253 }
254 
255 /**
256  * @title RefundVault
257  * @dev This contract is used for storing funds while a crowdsale
258  * is in progress. Supports refunding the money if crowdsale fails,
259  * and forwarding it if crowdsale is successful.
260  */
261 contract RefundVault is Ownable {
262   using SafeMath for uint256;
263 
264   enum State { Active, Refunding, Closed }
265 
266   mapping (address => uint256) public deposited;
267   address public wallet;
268   State public state;
269 
270   event Closed();
271   event RefundsEnabled();
272   event Refunded(address indexed beneficiary, uint256 weiAmount);
273 
274   function RefundVault(address _wallet) {
275     require(_wallet != 0x0);
276     wallet = _wallet;
277     state = State.Active;
278   }
279 
280   function deposit(address investor) onlyOwner public payable {
281     require(state == State.Active);
282     deposited[investor] = deposited[investor].add(msg.value);
283   }
284 
285   function close() onlyOwner public {
286     require(state == State.Active);
287     state = State.Closed;
288     Closed();
289     wallet.transfer(this.balance);
290   }
291 
292   function enableRefunds() onlyOwner public {
293     require(state == State.Active);
294     state = State.Refunding;
295     RefundsEnabled();
296   }
297 
298   function refund(address investor) public {
299     require(state == State.Refunding);
300     uint256 depositedValue = deposited[investor];
301     deposited[investor] = 0;
302     investor.transfer(depositedValue);
303     Refunded(investor, depositedValue);
304   }
305 }
306 
307 /**
308  * @title ESCCrowdsale
309  */
310 contract ESCCrowdsale is Ownable {
311   using SafeMath for uint256;
312 
313   // The token being sold
314   MintableToken public token;
315 
316   // start and end timestamps where investments are allowed (both inclusive)
317   uint256 public startTime;
318   uint256 public endTime;
319 
320   // address where funds are collected
321   address public wallet;
322 
323   // how many token units a buyer gets per wei
324   uint256 public rate;
325 
326   // amount of raised money in wei
327   uint256 public weiRaised;
328   
329   //amount of sold money in wei
330   uint256 public tokenSold = 0;
331   
332   uint256 public cap;
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
343   /**
344    * event for bonuses logging
345    * @param purchaser who paid for the tokens
346    * @param beneficiary who got the bonus
347    * @param amount amount of bonuses
348    */
349   event TokenBonus(address indexed purchaser, address indexed beneficiary, uint256 amount);
350 
351   bool public isFinalized = false;
352 
353   event Finalized();
354 
355   // minimum amount of funds to be raised in weis
356   uint256 public goal;
357 
358   // refund vault used to hold funds while crowdsale is running
359   RefundVault public vault;
360 
361   function ESCCrowdsale() {
362     startTime = 1507204800;//1507204800 //5rd October 2017 12:00:00 GMT
363     endTime = 1507982400; //14th October 2017 12:00:00 GMT
364     rate = 250; //250ESC = 1ETH
365     wallet = msg.sender;
366     cap = 42550000000000000000000;
367     vault = new RefundVault(wallet);
368     goal = 2950000000000000000000; // Minimal goal is 2950ETH = 4400ETH - 1450ETH(funding on Waves Platform)
369 
370     token = createTokenContract();
371   }
372 
373   // creates the token to be sold.
374   // override this method to have crowdsale of a specific mintable token.
375   function createTokenContract() internal returns (MintableToken) {
376     return EstateCoin(0xAb519Ef511ee029adC74a469d1ed44955E9d5Cdf);
377   }
378 
379   // fallback function can be used to buy tokens
380   function () payable {
381     buyTokens(msg.sender);
382   }
383 
384   // low level token purchase function
385   function buyTokens(address beneficiary) public payable {
386     require(beneficiary != 0x0);
387     require(validPurchase());
388 
389     if (weiRaised.add(msg.value) > cap) {
390         throw;
391     }
392 
393     uint256 weiAmount = msg.value;
394 
395     // calculate token amount to be created
396     uint256 tokens = weiAmount.mul(rate);
397     
398     if (token.mint(beneficiary, tokens)) {
399         // update state
400         weiRaised = weiRaised.add(weiAmount);
401 
402         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
403     
404         forwardFunds();
405     
406         tokenSold = tokenSold.add(tokens);
407         uint256 bonus = 0;
408         if (now < 1507291200) {
409             bonus = tokens.div(20); //5%
410         } else if (now < 1507377600) {
411             bonus = tokens.div(25); //4%
412         } else if (now < 1507464000) {
413             bonus = tokens.div(33); //3%
414         } else if (now < 1507550400) {
415             bonus = tokens.div(50); //2%
416         } else if (now < 1507636800) {
417             bonus = tokens.div(100); //1%
418         }
419         
420         if (bonus > 0) {
421             token.mint(beneficiary, bonus);
422             TokenBonus(msg.sender, beneficiary, bonus);
423         }
424     }
425   }
426     
427   //manually transfer tokens
428   function transferTokens(address _to, uint256 _amount) onlyOwner public returns (bool) {
429     require(!isFinalized);
430     require(!hasEnded());
431     require(_to != 0x0);
432     require(_amount > 0);
433     
434     token.mint(_to, _amount);
435     tokenSold += _amount;
436     
437     return true;
438   }
439 
440   // send ether to the fund collection wallet
441   // In addition to sending the funds, we want to call
442   // the RefundVault deposit function
443   function forwardFunds() internal {
444     vault.deposit.value(msg.value)(msg.sender);
445   }
446 
447   // @return true if the transaction can buy tokens
448   // @return true if investors can buy at the moment
449   function validPurchase() internal constant returns (bool) {
450     bool withinPeriod = now >= startTime && now <= endTime;
451     bool nonZeroPurchase = msg.value != 0;
452     return withinPeriod && nonZeroPurchase;
453   }
454 
455   // @return true if crowdsale event has ended
456   function hasEnded() public constant returns (bool) {
457     bool capReached = weiRaised >= cap;
458     return (now > endTime) || capReached;
459   }
460     
461   /**
462    * @dev Must be called after crowdsale ends, to do some extra finalization
463    * work. Calls the contract's finalization function.
464    */
465   function finalize() onlyOwner public {
466     require(!isFinalized);
467     require(hasEnded());
468 
469     finalization();
470     Finalized();
471 
472     isFinalized = true;
473   }
474   
475   // if crowdsale is unsuccessful, investors can claim refunds here
476   function claimRefund() public {
477     require(isFinalized);
478     require(!goalReached());
479 
480     vault.refund(msg.sender);
481   }
482 
483   // vault finalization task, called when owner calls finalize()
484   function finalization() internal {
485     if (goalReached()) {
486       token.mint(wallet, tokenSold.div(10)); //10% for owners, bounty, promo...
487       vault.close();
488     } else {
489       vault.enableRefunds();
490     }
491   }
492 
493   function goalReached() public constant returns (bool) {
494     return weiRaised >= goal;
495   }
496 
497 }