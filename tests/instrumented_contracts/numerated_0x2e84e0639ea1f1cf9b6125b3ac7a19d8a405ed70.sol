1 pragma solidity 0.4.21;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal constant returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances.
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[msg.sender]);
63 
64     // SafeMath.sub will throw if there is not enough balance.
65     balances[msg.sender] = balances[msg.sender].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     Transfer(msg.sender, _to, _value);
68     return true;
69   }
70 
71   /**
72   * @dev Gets the balance of the specified address.
73   * @param _owner The address to query the the balance of.
74   * @return An uint256 representing the amount owned by the passed address.
75   */
76   function balanceOf(address _owner) public constant returns (uint256 balance) {
77     return balances[_owner];
78   }
79 
80 }
81 
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public constant returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) internal allowed;
104 
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amount of tokens to be transferred
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    *
127    * Beware that changing an allowance with this method brings the risk that someone may use both the old
128    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151    * approve should be called when allowed[_spender] == 0. To increment
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    */
156   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
157     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 
162   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
163     uint oldValue = allowed[msg.sender][_spender];
164     if (_subtractedValue > oldValue) {
165       allowed[msg.sender][_spender] = 0;
166     } else {
167       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168     }
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173 }
174 
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Ownable {
182   address public owner;
183 
184 
185   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187 
188   /**
189    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190    * account.
191    */
192   function Ownable() {
193     owner = msg.sender;
194   }
195 
196 
197   /**
198    * @dev Throws if called by any account other than the owner.
199    */
200   modifier onlyOwner() {
201     require(msg.sender == owner);
202     _;
203   }
204 
205 
206   /**
207    * @dev Allows the current owner to transfer control of the contract to a newOwner.
208    * @param newOwner The address to transfer ownership to.
209    */
210   function transferOwnership(address newOwner) onlyOwner public {
211     require(newOwner != address(0));
212     OwnershipTransferred(owner, newOwner);
213     owner = newOwner;
214   }
215 
216 }
217 
218 
219 /**
220  * @title Mintable token
221  * @dev Simple ERC20 Token example, with mintable token creation
222  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
223  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
224  */
225 
226 contract MintableToken is StandardToken, Ownable {
227   event Mint(address indexed to, uint256 amount);
228   event MintFinished();
229 
230   bool public mintingFinished = false;
231 
232 
233   modifier canMint() {
234     require(!mintingFinished);
235     _;
236   }
237 
238   /**
239    * @dev Function to mint tokens
240    * @param _to The address that will receive the minted tokens.
241    * @param _amount The amount of tokens to mint.
242    * @return A boolean that indicates if the operation was successful.
243    */
244   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
245     totalSupply = totalSupply.add(_amount);
246     balances[_to] = balances[_to].add(_amount);
247     Mint(_to, _amount);
248     Transfer(address(0), _to, _amount);
249     return true;
250   }
251 
252   /**
253    * @dev Function to stop minting new tokens.
254    * @return True if the operation was successful.
255    */
256   function finishMinting() onlyOwner canMint public returns (bool) {
257     mintingFinished = true;
258     MintFinished();
259     return true;
260   }
261 }
262 
263 /// @title Migration Agent interface
264 contract MigrationAgent {
265 
266     function migrateFrom(address _from, uint256 _value) public;
267 }
268 
269 contract UnitedfansToken is MintableToken {
270     address public migrationMaster;
271     address public migrationAgent;
272     address public admin;
273     address public crowdSaleAddress;
274     uint256 public totalMigrated;
275     string public name = "UnitedFans";
276     string public symbol = "UFN";
277     uint256 public decimals = 18;
278     bool public locked = true; // Lock the transfer of tokens during the crowdsale
279 
280     event Migrate(address indexed _from, address indexed _to, uint256 _value);
281 
282     event Locked();
283 
284     event Error(address adrs1, address adrs2, address adrs3);
285 
286     event Unlocked();
287 
288     modifier onlyUnlocked() {
289         if (locked) 
290             revert();
291         _;
292     }
293 
294     modifier onlyAuthorized() {
295         if (msg.sender != owner && msg.sender != crowdSaleAddress && msg.sender != admin) 
296             revert();
297         _;
298     }
299 
300 
301     function UnitedfansToken(address _admin) public {
302         // Lock the transfCrowdsaleer function during the crowdsale
303         locked = true; // Lock the transfer of tokens during the crowdsale
304         // transferOwnership(_admin);
305         admin = _admin;
306         crowdSaleAddress = msg.sender;
307         migrationMaster = _admin;
308     }
309 
310     function unlock() public onlyAuthorized {
311         locked = false;
312         Unlocked();
313     }
314 
315     function lock() public onlyAuthorized {
316         locked = true;
317         Locked();
318     }
319 
320     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns (bool) {
321         return super.transferFrom(_from, _to, _value);
322     }
323 
324     function transfer(address _to, uint256 _value) public onlyUnlocked returns (bool) {
325         return super.transfer(_to, _value);
326     }
327 
328 
329 
330     // Token migration support:
331 
332     /// @notice Migrate tokens to the new token contract.
333     /// @dev Required state: Operational Migration
334     /// @param _value The amount of token to be migrated
335     function migrate(uint256 _value) external {
336         // Abort if not in Operational Migration state.
337         
338         if (migrationAgent == 0) 
339             revert();
340         
341         // Validate input value.
342         if (_value == 0) 
343             revert();
344         if (_value > balances[msg.sender]) 
345             revert();
346 
347         balances[msg.sender] -= _value;
348         totalSupply -= _value;
349         totalMigrated += _value;
350         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
351         Migrate(msg.sender, migrationAgent, _value);
352     }
353 
354 
355     /// @notice Set address of migration target contract and enable migration
356     /// process.
357     /// @dev Required state: Operational Normal
358     /// @dev State transition: -> Operational Migration
359     /// @param _agent The address of the MigrationAgent contract
360     function setMigrationAgent(address _agent) external onlyUnlocked() {
361         // Abort if not in Operational Normal state.
362         
363         require(migrationAgent == 0);
364         require(msg.sender == migrationMaster);
365         migrationAgent = _agent;
366     }
367 
368     function resetCrowdSaleAddress(address _newCrowdSaleAddress) external onlyAuthorized() {
369         crowdSaleAddress = _newCrowdSaleAddress;
370     }
371     
372     function setMigrationMaster(address _master) external {       
373         require(msg.sender == migrationMaster);
374         require(_master != 0);
375         migrationMaster = _master;
376     }
377 }
378 
379 
380 /**
381  * @title Crowdsale
382  * @dev Crowdsale is a base contract for managing a token crowdsale.
383  * Crowdsales have a start and end timestamps, where investors can make
384  * token purchases and the crowdsale will assign them tokens based
385  * on a token per ETH rate. Funds collected are forwarded to a wallet
386  * as they arrive.
387  */
388 contract Crowdsale {
389   using SafeMath for uint256;
390 
391   // The token being sold
392   MintableToken public token;
393 
394   // start and end timestamps where investments are allowed (both inclusive)
395   uint256 public startTime;
396   uint256 public endTime;
397 
398   // address where funds are collected
399   address public wallet;
400 
401   // how many token units a buyer gets per wei
402   uint256 public rate;
403 
404   // amount of raised money in wei
405   uint256 public weiRaised;
406 
407   /**
408    * event for token purchase logging
409    * @param purchaser who paid for the tokens
410    * @param beneficiary who got the tokens
411    * @param value weis paid for purchase
412    * @param amount amount of tokens purchased
413    */
414   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
415 
416 
417   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
418     require(_startTime >= now);
419     require(_endTime >= _startTime);
420     require(_rate > 0);
421     require(_wallet != address(0));
422 
423     token = createTokenContract();
424     startTime = _startTime;
425     endTime = _endTime;
426     rate = _rate;
427     wallet = _wallet;
428   }
429 
430   // creates the token to be sold.
431   // override this method to have crowdsale of a specific mintable token.
432   function createTokenContract() internal returns (MintableToken) {
433     return new MintableToken();
434   }
435 
436 
437   // fallback function can be used to buy tokens
438   function () payable {
439     buyTokens(msg.sender);
440   }
441 
442   // low level token purchase function
443   function buyTokens(address beneficiary) public payable {
444     require(beneficiary != address(0));
445     require(validPurchase());
446 
447     uint256 weiAmount = msg.value;
448 
449     // calculate token amount to be created
450     uint256 tokens = weiAmount.mul(rate);
451 
452     // update state
453     weiRaised = weiRaised.add(weiAmount);
454 
455     token.mint(beneficiary, tokens);
456     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
457 
458     forwardFunds();
459   }
460 
461   // send ether to the fund collection wallet
462   // override to create custom fund forwarding mechanisms
463   function forwardFunds() internal {
464     wallet.transfer(msg.value);
465   }
466 
467   // @return true if the transaction can buy tokens
468   function validPurchase() internal constant returns (bool) {
469     bool withinPeriod = now >= startTime && now <= endTime;
470     bool nonZeroPurchase = msg.value != 0;
471     return withinPeriod && nonZeroPurchase;
472   }
473 
474   // @return true if crowdsale event has ended
475   function hasEnded() public constant returns (bool) {
476     return now > endTime;
477   }
478 
479 
480 }
481 
482 
483 contract UnitedfansTokenCrowdsale is Ownable, Crowdsale {
484 
485     using SafeMath for uint256;
486  
487     //operational
488     bool public LockupTokensWithdrawn = false;
489     uint256 public constant toDec = 10**18;
490     uint256 public tokensLeft = 30303030*toDec;
491     uint256 public constant cap = 30303030*toDec;
492     uint256 public constant startRate = 12000;
493 
494     enum State { BeforeSale, NormalSale, ShouldFinalize, SaleOver }
495     State public state = State.BeforeSale;
496 
497 
498     // /* --- Time periods --- */
499 
500     uint256 public startTimeNumber = 1500000000;
501 
502     uint256 public endTimeNumber = 1527724800;// Wed, 31 May 2018 12:00:00 +0000
503 
504     event Finalized();
505 
506     function UnitedfansTokenCrowdsale(address _admin)
507     Crowdsale(
508         now + 10, // 2018-02-01T00:00:00+00:00 - 1517443200
509         endTimeNumber, // 2018-08-01T00:00:00+00:00 - 
510         12000,/* start rate - 1000 */
511         _admin
512     )  
513     public 
514     {}
515 
516     // creates the token to be sold.
517     // override this method to have crowdsale of a specific MintableToken token.
518     function createTokenContract() internal returns (MintableToken) {
519         return new UnitedfansToken(msg.sender);
520     }
521 
522     function forwardFunds() internal {
523         forwardFundsAmount(msg.value);
524     }
525 
526     function forwardFundsAmount(uint256 amount) internal {
527         wallet.transfer(amount);
528     }
529 
530     function refundAmount(uint256 amount) internal {
531         msg.sender.transfer(amount);
532     }
533 
534     function buyTokensUpdateState() internal {
535         if(state == State.BeforeSale && now >= startTimeNumber) { state = State.NormalSale; }
536         require(state != State.ShouldFinalize && state != State.SaleOver && msg.value >= 25 * toDec);
537         if(msg.value.mul(rate) >= tokensLeft) { state = State.ShouldFinalize; }
538     }
539 
540     function buyTokens(address beneficiary) public payable {
541         buyTokensUpdateState();
542         var numTokens = msg.value.mul(rate);
543         if(state == State.ShouldFinalize) {
544             lastTokens(beneficiary);
545             numTokens = tokensLeft;
546         }
547         else {
548             tokensLeft = tokensLeft.sub(numTokens); // if negative, should finalize
549             super.buyTokens(beneficiary);
550         }
551     }
552 
553     function buyCoinsUpdateState(uint256 amount) internal {
554         if(state == State.BeforeSale && now >= startTimeNumber) { state = State.NormalSale; }
555         require(state != State.ShouldFinalize && state != State.SaleOver && amount >= 25 * toDec);
556         if(amount.mul(rate) >= tokensLeft) { state = State.ShouldFinalize; }
557     }
558 
559     function buyCoins(address beneficiary, uint256 amount) public onlyOwner {
560         buyCoinsUpdateState(amount);
561         var numTokens = amount.mul(rate);
562         if(state == State.ShouldFinalize) {
563             lastTokens(beneficiary);
564             numTokens = tokensLeft;
565         }
566         else {
567             tokensLeft = tokensLeft.sub(numTokens); // if negative, should finalize
568             super.buyTokens(beneficiary);
569         }
570     }
571 
572     function lastTokens(address beneficiary) internal {
573         require(beneficiary != 0x0);
574         require(validPurchase());
575 
576         uint256 weiAmount = msg.value;
577 
578         // calculate token amount to be created
579         uint256 tokensForFullBuy = weiAmount.mul(rate);// must be bigger or equal to tokensLeft to get here
580         uint256 tokensToRefundFor = tokensForFullBuy.sub(tokensLeft);
581         uint256 tokensRemaining = tokensForFullBuy.sub(tokensToRefundFor);
582         uint256 weiAmountToRefund = tokensToRefundFor.div(rate);
583         uint256 weiRemaining = weiAmount.sub(weiAmountToRefund);
584         
585         // update state
586         weiRaised = weiRaised.add(weiRemaining);
587 
588         token.mint(beneficiary, tokensRemaining);
589         TokenPurchase(msg.sender, beneficiary, weiRemaining, tokensRemaining);
590 
591         forwardFundsAmount(weiRemaining);
592         refundAmount(weiAmountToRefund);
593     }
594 
595     function finalizeUpdateState() internal {
596         if(now > endTime) { state = State.ShouldFinalize; }
597         if(tokensLeft == 0) { state = State.ShouldFinalize; }
598     }
599 
600     function finalize() public {
601         finalizeUpdateState();
602         require (state == State.ShouldFinalize);
603 
604         finalization();
605         Finalized();
606     }
607 
608     function finalization() internal {
609         endTime = block.timestamp;
610         state = State.SaleOver;
611     }
612 }