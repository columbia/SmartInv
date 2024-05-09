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
275     string public name = "Goal Coin";
276     string public symbol = "GC";
277     uint256 public decimals = 18;
278     bool public locked = true; // Lock the transfer of tokens during the crowdsale
279 
280     event Migrate(address indexed _from, address indexed _to, uint256 _value);
281 
282     event Locked();
283 
284     event Unlocked();
285 
286     modifier onlyUnlocked() {
287         if (locked) 
288             revert();
289         _;
290     }
291 
292     modifier onlyAuthorized() {
293         if (msg.sender != owner && msg.sender != crowdSaleAddress && msg.sender != admin) 
294             revert();
295         _;
296     }
297 
298 
299     function UnitedfansToken(address _admin) public {
300         // Lock the transfCrowdsaleer function during the crowdsale
301         locked = true; // Lock the transfer of tokens during the crowdsale
302         // transferOwnership(_admin);
303         admin = _admin;
304         crowdSaleAddress = msg.sender;
305         migrationMaster = _admin;
306     }
307 
308     function unlock() public onlyAuthorized {
309         locked = false;
310         Unlocked();
311     }
312 
313     function lock() public onlyAuthorized {
314         locked = true;
315         Locked();
316     }
317 
318     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns (bool) {
319         return super.transferFrom(_from, _to, _value);
320     }
321 
322     function transfer(address _to, uint256 _value) public onlyUnlocked returns (bool) {
323         return super.transfer(_to, _value);
324     }
325 
326 
327 
328     // Token migration support:
329 
330     /// @notice Migrate tokens to the new token contract.
331     /// @dev Required state: Operational Migration
332     /// @param _value The amount of token to be migrated
333     function migrate(uint256 _value) external {
334         // Abort if not in Operational Migration state.
335         
336         if (migrationAgent == 0) 
337             revert();
338         
339         // Validate input value.
340         if (_value == 0) 
341             revert();
342         if (_value > balances[msg.sender]) 
343             revert();
344 
345         balances[msg.sender] -= _value;
346         totalSupply -= _value;
347         totalMigrated += _value;
348         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
349         Migrate(msg.sender, migrationAgent, _value);
350     }
351 
352 
353     /// @notice Set address of migration target contract and enable migration
354     /// process.
355     /// @dev Required state: Operational Normal
356     /// @dev State transition: -> Operational Migration
357     /// @param _agent The address of the MigrationAgent contract
358     function setMigrationAgent(address _agent) external onlyUnlocked() {
359         // Abort if not in Operational Normal state.
360         
361         require(migrationAgent == 0);
362         require(msg.sender == migrationMaster);
363         migrationAgent = _agent;
364     }
365 
366     function resetCrowdSaleAddress(address _newCrowdSaleAddress) external onlyAuthorized() {
367         crowdSaleAddress = _newCrowdSaleAddress;
368     }
369     
370     function setMigrationMaster(address _master) external {       
371         require(msg.sender == migrationMaster);
372         require(_master != 0);
373         migrationMaster = _master;
374     }
375 }
376 
377 
378 /**
379  * @title Crowdsale
380  * @dev Crowdsale is a base contract for managing a token crowdsale.
381  * Crowdsales have a start and end timestamps, where investors can make
382  * token purchases and the crowdsale will assign them tokens based
383  * on a token per ETH rate. Funds collected are forwarded to a wallet
384  * as they arrive.
385  */
386 contract Crowdsale {
387   using SafeMath for uint256;
388 
389   // The token being sold
390   MintableToken public token;
391 
392   // start and end timestamps where investments are allowed (both inclusive)
393   uint256 public startTime;
394   uint256 public endTime;
395 
396   // address where funds are collected
397   address public wallet;
398 
399   // how many token units a buyer gets per wei
400   uint256 public rate;
401 
402   // amount of raised money in wei
403   uint256 public weiRaised;
404 
405   /**
406    * event for token purchase logging
407    * @param purchaser who paid for the tokens
408    * @param beneficiary who got the tokens
409    * @param value weis paid for purchase
410    * @param amount amount of tokens purchased
411    */
412   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
413 
414 
415   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
416     require(_startTime >= now);
417     require(_endTime >= _startTime);
418     require(_rate > 0);
419     require(_wallet != address(0));
420 
421     token = createTokenContract();
422     startTime = _startTime;
423     endTime = _endTime;
424     rate = _rate;
425     wallet = _wallet;
426   }
427 
428   // creates the token to be sold.
429   // override this method to have crowdsale of a specific mintable token.
430   function createTokenContract() internal returns (MintableToken) {
431     return new MintableToken();
432   }
433 
434 
435   // fallback function can be used to buy tokens
436   function () payable {
437     buyTokens(msg.sender);
438   }
439 
440   // low level token purchase function
441   function buyTokens(address beneficiary) public payable {
442     require(beneficiary != address(0));
443     require(validPurchase());
444 
445     uint256 weiAmount = msg.value;
446 
447     // calculate token amount to be created
448     uint256 tokens = weiAmount.mul(rate);
449 
450     // update state
451     weiRaised = weiRaised.add(weiAmount);
452 
453     token.mint(beneficiary, tokens);
454     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
455 
456     forwardFunds();
457   }
458 
459   // send ether to the fund collection wallet
460   // override to create custom fund forwarding mechanisms
461   function forwardFunds() internal {
462     wallet.transfer(msg.value);
463   }
464 
465   // @return true if the transaction can buy tokens
466   function validPurchase() internal constant returns (bool) {
467     bool withinPeriod = now >= startTime && now <= endTime;
468     bool nonZeroPurchase = msg.value != 0;
469     return withinPeriod && nonZeroPurchase;
470   }
471 
472   // @return true if crowdsale event has ended
473   function hasEnded() public constant returns (bool) {
474     return now > endTime;
475   }
476 
477 
478 }
479 
480 
481 contract UnitedfansTokenCrowdsale is Ownable, Crowdsale {
482 
483     using SafeMath for uint256;
484  
485     //operational
486     bool public LockupTokensWithdrawn = false;
487     uint256 public constant toDec = 10**18;
488     uint256 public tokensLeft = 30303030*toDec;
489     uint256 public constant cap = 30303030*toDec;
490     uint256 public constant startRate = 12000;
491 
492     enum State { BeforeSale, NormalSale, ShouldFinalize, SaleOver }
493     State public state = State.BeforeSale;
494 
495 
496     // /* --- Time periods --- */
497 
498     uint256 public startTimeNumber = 1500000000;
499 
500     uint256 public endTimeNumber = 1530316800;// Wed, 31 May 2018 12:00:00 +0000
501 
502     event Finalized();
503 
504     function UnitedfansTokenCrowdsale(address _admin)
505     Crowdsale(
506         now + 10, // 2018-02-01T00:00:00+00:00 - 1517443200
507         endTimeNumber, // 2018-06-30T00:00:00+00:00 - 
508         12000,/* start rate - 1000 */
509         _admin
510     )  
511     public 
512     {}
513 
514     // creates the token to be sold.
515     // override this method to have crowdsale of a specific MintableToken token.
516     function createTokenContract() internal returns (MintableToken) {
517         return new UnitedfansToken(msg.sender);
518     }
519 
520     function forwardFunds() internal {
521         forwardFundsAmount(msg.value);
522     }
523 
524     function forwardFundsAmount(uint256 amount) internal {
525         wallet.transfer(amount);
526     }
527 
528     function refundAmount(uint256 amount) internal {
529         msg.sender.transfer(amount);
530     }
531 
532     function buyTokensUpdateState() internal {
533         if(state == State.BeforeSale && now >= startTimeNumber) { state = State.NormalSale; }
534         require(state != State.ShouldFinalize && state != State.SaleOver && msg.value >= toDec.div(10));
535         if(msg.value < toDec.mul(25)) { rate = 6000; }
536         else { rate = 12000; }
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
555         require(state != State.ShouldFinalize && state != State.SaleOver);
556         if(amount < 25) { rate = 6000; }
557         else { rate = 12000; }
558         if(amount.mul(rate) >= tokensLeft) { state = State.ShouldFinalize; }
559     }
560 
561     function buyCoins(address beneficiary, uint256 amount) public onlyOwner {
562         buyCoinsUpdateState(amount);
563         var numTokens = amount.mul(rate);
564         if(state == State.ShouldFinalize) {
565             lastTokens(beneficiary);
566             numTokens = tokensLeft;
567         }
568         else {
569             tokensLeft = tokensLeft.sub(numTokens); // if negative, should finalize
570             super.buyTokens(beneficiary);
571         }
572     }
573 
574     function lastTokens(address beneficiary) internal {
575         require(beneficiary != 0x0);
576         require(validPurchase());
577 
578         uint256 weiAmount = msg.value;
579 
580         // calculate token amount to be created
581         uint256 tokensForFullBuy = weiAmount.mul(rate);// must be bigger or equal to tokensLeft to get here
582         uint256 tokensToRefundFor = tokensForFullBuy.sub(tokensLeft);
583         uint256 tokensRemaining = tokensForFullBuy.sub(tokensToRefundFor);
584         uint256 weiAmountToRefund = tokensToRefundFor.div(rate);
585         uint256 weiRemaining = weiAmount.sub(weiAmountToRefund);
586         
587         // update state
588         weiRaised = weiRaised.add(weiRemaining);
589 
590         token.mint(beneficiary, tokensRemaining);
591         TokenPurchase(msg.sender, beneficiary, weiRemaining, tokensRemaining);
592 
593         forwardFundsAmount(weiRemaining);
594         refundAmount(weiAmountToRefund);
595     }
596 
597     function finalizeUpdateState() internal {
598         if(now > endTime) { state = State.ShouldFinalize; }
599         if(tokensLeft == 0) { state = State.ShouldFinalize; }
600     }
601 
602     function finalize() public {
603         finalizeUpdateState();
604         require (state == State.ShouldFinalize);
605 
606         finalization();
607         Finalized();
608     }
609 
610     function finalization() internal {
611         endTime = block.timestamp;
612         state = State.SaleOver;
613     }
614 }