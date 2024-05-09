1 pragma solidity ^0.4.11;
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
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) onlyOwner public {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 /**
78  * @title RefundVault
79  * @dev This contract is used for storing funds while a crowdsale
80  * is in progress. Supports refunding the money if crowdsale fails,
81  * and forwarding it if crowdsale is successful.
82  */
83 contract RefundVault is Ownable {
84   using SafeMath for uint256;
85 
86   enum State { Active, Refunding, Closed }
87 
88   mapping (address => uint256) public deposited;
89   address public wallet;
90   State public state;
91 
92   event Closed();
93   event RefundsEnabled();
94   event Refunded(address indexed beneficiary, uint256 weiAmount);
95 
96   function RefundVault(address _wallet) public {
97     require(_wallet != 0x0);
98     wallet = _wallet;
99     state = State.Active;
100   }
101 
102   function deposit(address investor) onlyOwner public payable {
103     require(state == State.Active);
104     deposited[investor] = deposited[investor].add(msg.value);
105   }
106 
107   function close() onlyOwner public {
108     require(state == State.Active);
109     state = State.Closed;
110     Closed();
111     wallet.transfer(this.balance);
112   }
113 
114   function ownerTakesAllNotClaimedFunds() public onlyOwner {
115         wallet.transfer(this.balance);
116   }
117 
118   function enableRefunds() onlyOwner public {
119     require(state == State.Active);
120     state = State.Refunding;
121     RefundsEnabled();
122   }
123 
124   function refund(address investor) onlyOwner public {
125     require(state == State.Refunding);
126     uint256 depositedValue = deposited[investor];
127     deposited[investor] = 0;
128     investor.transfer(depositedValue);
129     Refunded(investor, depositedValue);
130   }
131 }
132 
133 /**
134  * @title Standard + Mintable + Burnable ERC20 token
135  *
136  * @dev Implementation of the basic standard token with function of minting and burn
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardMintableBurnableToken is Ownable {
141   using SafeMath for uint256;
142   
143   mapping (address => mapping (address => uint256)) internal allowed;
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145   uint256 public totalSupply;
146 
147   event Transfer(address indexed from, address indexed to, uint256 value);
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    *
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
191     return allowed[_owner][_spender];
192   }
193 
194   /**
195    * approve should be called when allowed[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    */
200   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
201     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
207     uint oldValue = allowed[msg.sender][_spender];
208     if (_subtractedValue > oldValue) {
209       allowed[msg.sender][_spender] = 0;
210     } else {
211       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212     }
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217     mapping(address => uint256) balances;
218 
219   /**
220   * @dev transfer token for a specified address
221   * @param _to The address to transfer to.
222   * @param _value The amount to be transferred.
223   */
224   function transfer(address _to, uint256 _value) public returns (bool) {
225     require(_to != address(0));
226     require(_value <= balances[msg.sender]);
227 
228     // SafeMath.sub will throw if there is not enough balance.
229     balances[msg.sender] = balances[msg.sender].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     Transfer(msg.sender, _to, _value);
232     return true;
233   }
234 
235 
236 
237   /**
238   * @dev Gets the balance of the specified address.
239   * @param _owner The address to query the the balance of.
240   * @return An uint256 representing the amount owned by the passed address.
241   */
242   function balanceOf(address _owner) public constant returns (uint256 balance) {
243     return balances[_owner];
244   }
245 
246 
247 // MINATABLE PART
248 
249   event Mint(address indexed to, uint256 amount);
250   event MintFinished();
251   
252   bool public mintingFinished = false;
253 
254 
255   modifier canMint() {
256     require(!mintingFinished);
257     _;
258   }
259 
260   /**
261    * @dev Function to mint tokens
262    * @param _to The address that will receive the minted tokens.
263    * @param _amount The amount of tokens to mint.
264    * @return A boolean that indicates if the operation was successful.
265    */
266   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
267     totalSupply = totalSupply.add(_amount);
268     balances[_to] = balances[_to].add(_amount);
269     Mint(_to, _amount);
270     Transfer(0x0, _to, _amount);
271     return true;
272   }
273 
274   /**
275    * @dev Function to stop minting new tokens.
276    * @return True if the operation was successful.
277    */
278   function finishMinting() onlyOwner public returns (bool) {
279     mintingFinished = true;
280     MintFinished();
281     return true;
282   }
283 
284 
285 // BURNABLE PART
286 
287 
288     event Burn(address indexed burner, uint256 value);
289 
290     /**
291      * @dev Burns a specific amount of tokens.
292      * @param _value The amount of token to be burned.
293      */
294     function burn(uint256 _value) public {
295         require(_value > 0);
296         require(_value <= balances[msg.sender]);
297         // no need to require value <= totalSupply, since that would imply the
298         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
299 
300         address burner = msg.sender;
301         balances[burner] = balances[burner].sub(_value);
302         totalSupply = totalSupply.sub(_value);
303         Burn(burner, _value);
304     }
305 
306 }
307 
308 
309 /**
310  * @title MainassetPreICO
311  * @dev MainassetPreICO is a base contract for managing a token crowdsale.
312  * Crowdsales have a start and end timestamps, where investors can make
313  * token purchases and the crowdsale will assign them tokens based
314  * on a token per ETH rate. Funds collected are forwarded to a wallet
315  * as they arrive.
316  */
317 contract MainassetPreICO is Ownable {
318   using SafeMath for uint256;
319 
320   // The token being sold
321   StandardMintableBurnableToken public token;
322   
323   // start and end timestamps where investments are allowed (both inclusive)
324   uint256 public startTime;
325   uint256 public endTime;
326 
327   // address where funds are collected
328   address public wallet;
329 
330   // how many token units a buyer gets per wei
331   uint256 public rate;
332 
333   // amount of raised money in wei
334   uint256 public weiRaised;
335 
336   /**
337    * event for token purchase logging
338    * @param purchaser who paid for the tokens
339    * @param beneficiary who got the tokens
340    * @param value weis paid for purchase
341    * @param amount amount of tokens purchased
342    */
343   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
344 
345 
346   function MainassetPreICO() {
347     
348     // address of wallet
349     wallet = 0x99Ad01334E387d212458c71dac87AEa0E272F973;
350     // address of MasToken
351     token = StandardMintableBurnableToken(0x20fc9efc67e49347e05188e5f2bfecbd8c01dd20);
352     
353 
354 
355 
356     // PRE-ICO starts exactly at 2017-11-11 11:11:11 UTC (1510398671)
357     startTime = 1510398671;
358     // PRE-ICO does until 2017-12-12 12:12:12 UTC (1513080732) 
359     endTime = 1513080732;
360 
361 
362     // 1 ETH = 1000 MAS
363     rate = 1000;
364 
365     vault = new RefundVault(wallet);
366 
367     /// pre-ico goal
368     cap = 1500 ether;
369 
370     /// minimum goal
371     goal = 500 ether;
372 
373   }
374   
375   // fallback function can be used to buy tokens
376   function () payable {
377     buyTokens(msg.sender);
378   }
379 
380   // low level token purchase function
381   function buyTokens(address beneficiary) public payable {
382     require(beneficiary != 0x0);
383     require(validPurchase());
384     
385 
386     uint256 weiAmount = msg.value;
387 
388     // calculate token amount to be created
389     uint256 tokens = weiAmount.mul(rate);
390 
391     // update state
392     weiRaised = weiRaised.add(weiAmount);
393 
394     token.mint(beneficiary, tokens);
395     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
396 
397     forwardFunds();
398   }
399 
400 
401 
402     uint256 public cap;
403 
404   // overriding Crowdsale#validPurchase to add extra cap logic
405   // @return true if investors can buy at the moment
406   function validPurchase() internal constant returns (bool) {
407     bool withinCap = weiRaised.add(msg.value) <= cap;
408     bool withinPeriod = now >= startTime && now <= endTime;
409     bool nonZeroPurchase = msg.value != 0;
410 
411     return withinPeriod && nonZeroPurchase && withinCap;
412   }
413 
414   // overriding Crowdsale#hasEnded to add cap logic
415   // @return true if crowdsale event has ended
416   function hasEnded() public constant returns (bool) {
417     bool capReached = weiRaised >= cap;
418     bool tooLate = now > endTime;
419     return tooLate || capReached;
420   }
421 
422 
423   /// finalazation part
424 
425   bool public isFinalized = false;
426 
427   event Finalized();
428 
429   /**
430    * @dev Must be called after crowdsale ends, to do some extra finalization
431    * work. Calls the contract's finalization function.
432    */
433   function finalize() public {
434     require(!isFinalized);
435     require(hasEnded());
436 
437     finalization();
438     Finalized();
439 
440     isFinalized = true;
441   }
442 
443 
444     // vault finalization task, called when owner calls finalize()
445   function finalization() internal {
446     if (goalReached()) {
447       vault.close();
448     } else {
449       vault.enableRefunds();
450     }
451     token.transferOwnership(owner);
452   }
453 
454   
455 
456   // refundable part
457 
458    // minimum amount of funds to be raised in weis
459   uint256 public goal;
460 
461   // refund vault used to hold funds while crowdsale is running
462   RefundVault public vault;
463 
464   // We're overriding the fund forwarding from Crowdsale.
465   // In addition to sending the funds, we want to call
466   // the RefundVault deposit function
467   function forwardFunds() internal {
468     vault.deposit.value(msg.value)(msg.sender);
469   }
470 
471   // if crowdsale is unsuccessful, investors can claim refunds here
472   // In case of refund - investor need to burn all his tokens
473   function claimRefund() public {
474     require(isFinalized);
475     require(!goalReached());
476     // Investors can claim funds before 19 Dec. 2017 midnight (00:00:00) (1513641600)
477     require(now < 1513641600);
478     // Investor need to burn all his MAS tokens for fund to be returned
479     require(token.balanceOf(msg.sender) == 0);
480 
481     vault.refund(msg.sender);
482   }
483 
484 
485   // Founders can take non-claimed funds after 19 Dec. 2017 midnight (00:00:00) (1513641600)
486   function takeAllNotClaimedForRefundMoney() public {
487     // Founders can take all non-claimed funds after 19 Dec. 2017 (1513641600)
488     require(now >= 1513641600);
489     vault.ownerTakesAllNotClaimedFunds();
490   }
491 
492   function goalReached() public constant returns (bool) {
493     return weiRaised >= goal;
494   }
495 
496 
497 }