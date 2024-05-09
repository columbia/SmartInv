1 pragma solidity ^0.4.11;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) constant returns (uint256);
10   function transfer(address to, uint256 value) returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() {
26     owner = msg.sender;
27   }
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner {
40     require(newOwner != address(0));      
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 }
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a * b;
52     assert(a == 0 || c / a == b);
53     return c;
54   }
55   function div(uint256 a, uint256 b) internal constant returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65   function add(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 /*
72  * Haltable
73  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
74  * Originally envisioned in FirstBlood ICO contract.
75  */
76 contract Haltable is Ownable {
77   bool public halted;
78   modifier stopInEmergency {
79     require(!halted);
80     _;
81   }
82   modifier stopNonOwnersInEmergency {
83     require(!halted && msg.sender == owner);
84     _;
85   }
86   modifier onlyInEmergency {
87     require(halted);
88     _;
89   }
90   // called by the owner on emergency, triggers stopped state
91   function halt() external onlyOwner {
92     halted = true;
93   }
94   // called by the owner on end of emergency, returns to normal state
95   function unhalt() external onlyOwner onlyInEmergency {
96     halted = false;
97   }
98 }
99 /**
100  * @title RefundVault
101  * @dev This contract is used for storing funds while a crowdsale
102  * is in progress. Supports refunding the money if crowdsale fails,
103  * and forwarding it if crowdsale is successful.
104  */
105 contract RefundVault is Ownable {
106   using SafeMath for uint256;
107   enum State { Active, Refunding, Closed }
108   mapping (address => uint256) public deposited;
109   
110   address public wallet;
111   State public state;
112   event Closed();
113   event RefundsEnabled();
114   event Refunded(address indexed beneficiary, uint256 weiAmount);
115   function RefundVault(address _wallet) {
116     require(_wallet != 0x0);
117     wallet = _wallet;
118     state = State.Active;
119   }
120   function deposit(address investor) onlyOwner payable {
121     require(state == State.Active);
122     deposited[investor] = deposited[investor].add(msg.value);
123   }
124   function close() onlyOwner payable {
125     require(state == State.Active);
126     state = State.Closed;
127     Closed();
128     wallet.transfer(this.balance);
129   }
130   function enableRefunds() onlyOwner {
131     require(state == State.Active);
132     state = State.Refunding;
133     RefundsEnabled();
134   }
135   function refund(address investor) payable {
136     require(state == State.Refunding);
137     uint256 depositedValue = deposited[investor];
138     deposited[investor] = 0;
139     investor.transfer(depositedValue);
140     Refunded(investor, depositedValue);
141   }
142 }
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances. 
146  */
147 contract BasicToken is ERC20Basic {
148   using SafeMath for uint256;
149   mapping(address => uint256) balances;
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) returns (bool) {
156     require(_to != address(0));
157     // SafeMath.sub will throw if there is not enough balance.
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     Transfer(msg.sender, _to, _value);
161     return true;
162   }
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of. 
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) constant returns (uint256 balance) {
169     return balances[_owner];
170   }
171 }
172 /**
173  * @title ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/20
175  */
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender) constant returns (uint256);
178   function transferFrom(address from, address to, uint256 value) returns (bool);
179   function approve(address spender, uint256 value) returns (bool);
180   event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * @dev https://github.com/ethereum/EIPs/issues/20
187  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract StandardToken is ERC20, BasicToken {
190   mapping (address => mapping (address => uint256)) allowed;
191   /**
192    * @dev Transfer tokens from one address to another
193    * @param _from address The address which you want to send tokens from
194    * @param _to address The address which you want to transfer to
195    * @param _value uint256 the amount of tokens to be transferred
196    */
197   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
198     require(_to != address(0));
199     var _allowance = allowed[_from][msg.sender];
200     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
201     // require (_value <= _allowance);
202     balances[_from] = balances[_from].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     allowed[_from][msg.sender] = _allowance.sub(_value);
205     Transfer(_from, _to, _value);
206     return true;
207   }
208   /**
209    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210    * @param _spender The address which will spend the funds.
211    * @param _value The amount of tokens to be spent.
212    */
213   function approve(address _spender, uint256 _value) returns (bool) {
214     // To change the approve amount you first have to reduce the addresses`
215     //  allowance to zero by calling `approve(_spender, 0)` if it is not
216     //  already 0 to mitigate the race condition described here:
217     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
219     allowed[msg.sender][_spender] = _value;
220     Approval(msg.sender, _spender, _value);
221     return true;
222   }
223   /**
224    * @dev Function to check the amount of tokens that an owner allowed to a spender.
225    * @param _owner address The address which owns the funds.
226    * @param _spender address The address which will spend the funds.
227    * @return A uint256 specifying the amount of tokens still available for the spender.
228    */
229   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
230     return allowed[_owner][_spender];
231   }
232   
233   /**
234    * approve should be called when allowed[_spender] == 0. To increment
235    * allowed value is better to use this function to avoid 2 calls (and wait until 
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    */
239   function increaseApproval (address _spender, uint _addedValue) 
240     returns (bool success) {
241     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
242     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245   function decreaseApproval (address _spender, uint _subtractedValue) 
246     returns (bool success) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 }
257 /**
258  * @title Harbor token
259  * @dev Simple ERC20 Token example, with mintable token creation
260  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
261  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
262  */
263 contract HarborToken is StandardToken, Ownable {
264   //define HarborToken
265   string public constant name = "HarborToken";
266   string public constant symbol = "HBR";
267   uint8 public constant decimals = 18;
268    /** List of agents that are allowed to create new tokens */
269   mapping (address => bool) public mintAgents;
270   event Mint(address indexed to, uint256 amount);
271   event MintOpened();
272   event MintFinished();
273   event MintingAgentChanged(address addr, bool state  );
274   event BurnToken(address addr,uint256 amount);
275   bool public mintingFinished = false;
276   modifier canMint() {
277     require(!mintingFinished);
278     _;
279   }
280   modifier onlyMintAgent() {
281     // Only crowdsale contracts are allowed to mint new tokens
282     require(mintAgents[msg.sender]);
283     _;
284   }
285   /**
286    * Owner can allow a crowdsale contract to mint new tokens.
287    */
288   function setMintAgent(address addr, bool state) onlyOwner canMint public {
289     mintAgents[addr] = state;
290     MintingAgentChanged(addr, state);
291   }
292   /**
293    * @dev Function to mint tokens
294    * @param _to The address that will receive the minted tokens.
295    * @param _amount The amount of tokens to mint.
296    * @return A boolean that indicates if the operation was successful.
297    */
298   function mint(address _to, uint256 _amount) onlyMintAgent canMint returns (bool) {
299     totalSupply = totalSupply.add(_amount);
300     balances[_to] = balances[_to].add(_amount);
301     Mint(_to, _amount);
302     Transfer(0x0, _to, _amount);
303     return true;
304   }
305   /**
306    * @dev Function to burn down tokens
307    * @param _addr The address that will burn the tokens.
308    * @param  _amount The amount of tokens to burn.
309    * @return A boolean that indicates if the burn up was successful.
310    */
311   function burn(address _addr,uint256 _amount) onlyMintAgent canMint  returns (bool) {
312     require(_amount > 0);
313     totalSupply = totalSupply.sub(_amount);
314     balances[_addr] = balances[_addr].sub(_amount);
315     BurnToken(_addr,_amount);
316     return true;
317   }
318   /**
319    * @dev Function to resume minting new tokens.
320    * @return True if the operation was successful.
321    */
322   function openMinting() onlyOwner returns (bool) {
323     mintingFinished = false;
324     MintOpened();
325      return true;
326   }
327  /**
328    * @dev Function to stop minting new tokens.
329    * @return True if the operation was successful.
330    */
331   function finishMinting() onlyOwner returns (bool) {
332     mintingFinished = true;
333     MintFinished();
334     return true;
335   }
336 }
337 /**
338  * @title HarborCrowdsale 
339  * @dev HarborCrowdsale is a base contract for managing a token crowdsale.
340  * HarborCrowdsale have a start and end timestamps, where investors can make
341  * token purchases and the crowdsale will assign them tokens based
342  * on a token per ETH rate buyprice(). Funds collected are forwarded to a wallet 
343  * as they arrive.
344  */
345 contract HarborCrowdsale is Haltable {
346   using SafeMath for uint256;
347   // The token being sold
348   HarborToken public token;
349   // start and end timestamps where investments are allowed (both inclusive)
350   uint256 public startTime;
351   uint256 public endTime;
352   // address where funds are collected
353   address public wallet;
354   // amount of raised money in wei
355   uint256 public weiRaised;
356   
357   //max amount of funds raised
358   uint256 public cap;
359   //is crowdsale end
360   bool public isFinalized = false;
361    // minimum amount of funds to be raised in weis
362   uint256 public minimumFundingGoal;
363   // refund vault used to hold funds while crowdsale is running
364   RefundVault public vault;
365   //project assign budget amount per inventer
366   mapping (address => uint256) public projectBuget;
367   //event for crowdsale end
368   event Finalized();
369   /**
370    * event for token purchase logging
371    * @param purchaser who paid for the tokens
372    * @param beneficiary who got the tokens
373    * @param value weis paid for purchase
374    * @param amount amount of tokens purchased
375    */ 
376   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount,uint256 projectamount);
377     // Crowdsale end time has been changed
378   event EndsAtChanged(uint newEndsAt);
379   function HarborCrowdsale(uint256 _startTime, uint256 _endTime,  address _wallet, uint256 _cap, uint256 _minimumFundingGoal) {
380     require(_startTime >= now);
381     require(_endTime >= _startTime);
382     require(_wallet != 0x0);
383     require(_cap > 0);
384     require(_minimumFundingGoal > 0);
385     token = createTokenContract();
386     startTime = _startTime;
387     endTime = _endTime;
388     wallet = _wallet;
389     cap = _cap;
390     vault = new RefundVault(wallet);
391     minimumFundingGoal = _minimumFundingGoal;
392     //grant token control to HarborCrowdsale
393     token.setMintAgent(address(this), true);
394   }
395   // creates the token to be sold. 
396   // override this method to have crowdsale of a specific HarborToken.
397   function createTokenContract() internal returns (HarborToken) {
398     return new HarborToken();
399   }
400   // fallback function can be used to buy tokens
401   function () payable stopInEmergency{
402     buyTokens(msg.sender);
403   }
404   // ------------------------------------------------------------------------
405     // Tokens per ETH
406     // Day  1   : 2200 HBR = 1 Ether
407     // Days 2–7 : 2100 HBR = 1 Ether
408     // Days 8–30: 2000 HBR = 1 Ether
409     // ------------------------------------------------------------------------
410     function buyPrice() constant returns (uint) {
411         return buyPriceAt(now);
412     }
413     function buyPriceAt(uint at) constant returns (uint) {
414         if (at < startTime) {
415             return 0;
416         } else if (at < (startTime + 1 days)) {
417             return 2200;
418         } else if (at < (startTime + 7 days)) {
419             return 2100;
420         } else if (at <= endTime) {
421             return 2000;
422         } else {
423             return 0;
424         }
425     }
426   // low level token purchase function
427   function buyTokens(address beneficiary) payable stopInEmergency {
428     require(beneficiary != 0x0);
429     require(validPurchase());
430     require(buyPrice() > 0);
431     uint256 weiAmount = msg.value;
432     uint256 price = buyPrice();
433     // calculate token amount to be created
434     uint256 tokens = weiAmount.mul(price);
435     //founder & financial services stake (investor token *2/3)
436     uint256 projectTokens = tokens.mul(2);
437     projectTokens = projectTokens.div(3);
438     //update state
439     weiRaised = weiRaised.add(weiAmount);
440     token.mint(beneficiary, tokens);
441     token.mint(wallet,projectTokens);
442     projectBuget[beneficiary] = projectBuget[beneficiary].add(projectTokens);
443     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, projectTokens);
444     forwardFunds();
445   }
446   // send ether to the fund collection wallet
447   // override to create custom fund forwarding mechanisms
448   function forwardFunds() internal {
449     vault.deposit.value(msg.value)(msg.sender);
450   }
451   // @return true if the transaction can buy tokens
452   function validPurchase() internal constant returns (bool) {
453     bool withinPeriod = now >= startTime && now <= endTime;
454     bool nonZeroPurchase = msg.value != 0;
455     bool withinCap = weiRaised <= cap;
456     return withinPeriod && nonZeroPurchase && withinCap;
457   }
458   // @return true if crowdsale event has ended
459   function hasEnded() public constant returns (bool) {
460     bool capReached = weiRaised >= cap;
461     return (now > endTime) || capReached;
462   }
463    /**
464    *  called after crowdsale ends, to do some extra finalization
465    */
466   function finalize() onlyOwner {
467     require(!isFinalized);
468     require(hasEnded());
469     finalization();
470     Finalized();
471     
472     isFinalized = true;
473   }
474   /**
475    *  finalization  refund check.
476    */
477   function finalization() internal {
478     if (minFundingGoalReached()) {
479       vault.close();
480     } else {
481       vault.enableRefunds();
482     }
483   }
484    // if crowdsale is unsuccessful, investors can claim refunds here
485   function claimRefund() payable stopInEmergency{
486     require(isFinalized);
487     require(!minFundingGoalReached());
488     vault.refund(msg.sender);
489     //burn distribute tokens
490     uint256 _hbr_amount = token.balanceOf(msg.sender);
491     token.burn(msg.sender,_hbr_amount);
492     //after refund, project tokens is burn out
493     uint256 _hbr_project = projectBuget[msg.sender];
494     projectBuget[msg.sender] = 0;
495     token.burn(wallet,_hbr_project);
496   }
497   function minFundingGoalReached() public constant returns (bool) {
498     return weiRaised >= minimumFundingGoal;
499   }
500   /**
501    * Allow crowdsale owner to close early or extend the crowdsale.
502    * This is useful e.g. for a manual soft cap implementation:
503    * - after X amount is reached determine manual closing
504    * It may be delay if the crowdsale is interrupted or paused for unexpected reasons.
505    */
506   function setEndsAt(uint time) onlyOwner {
507     require(now <= time);
508     endTime = time;
509     EndsAtChanged(endTime);
510   }
511 }