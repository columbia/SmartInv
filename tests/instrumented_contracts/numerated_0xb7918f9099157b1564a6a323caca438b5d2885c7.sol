1 pragma solidity 0.4.21;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
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
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61     require(_value <= balances[msg.sender]);
62 
63     // SafeMath.sub will throw if there is not enough balance.
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   /**
71   * @dev Gets the balance of the specified address.
72   * @param _owner The address to query the the balance of.
73   * @return An uint256 representing the amount owned by the passed address.
74   */
75   function balanceOf(address _owner) public constant returns (uint256 balance) {
76     return balances[_owner];
77   }
78 
79 }
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) public constant returns (uint256);
87   function transferFrom(address from, address to, uint256 value) public returns (bool);
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    *
126    * Beware that changing an allowance with this method brings the risk that someone may use both the old
127    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130    * @param _spender The address which will spend the funds.
131    * @param _value The amount of tokens to be spent.
132    */
133   function approve(address _spender, uint256 _value) public returns (bool) {
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150    * approve should be called when allowed[_spender] == 0. To increment
151    * allowed value is better to use this function to avoid 2 calls (and wait until
152    * the first transaction is mined)
153    * From MonolithDAO Token.sol
154    */
155   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
156     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
157     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158     return true;
159   }
160 
161   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
162     uint oldValue = allowed[msg.sender][_spender];
163     if (_subtractedValue > oldValue) {
164       allowed[msg.sender][_spender] = 0;
165     } else {
166       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167     }
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172 }
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  */
178 contract Ownable {
179   address public owner;
180 
181 
182   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   function Ownable() {
190     owner = msg.sender;
191   }
192 
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) onlyOwner public {
208     require(newOwner != address(0));
209     OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
212 
213 }
214 
215 
216 /**
217  * @title Burnable Token
218  * @dev Token that can be irreversibly burned (destroyed).
219  */
220 contract BurnableToken is StandardToken {
221 
222     event Burn(address indexed burner, uint256 value);
223 
224     /**
225      * @dev Burns a specific amount of tokens.
226      * @param _value The amount of token to be burned.
227      */
228     function burn(uint256 _value) public {
229         require(_value > 0);
230         require(_value <= balances[msg.sender]);
231         // no need to require value <= totalSupply, since that would imply the
232         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
233 
234         address burner = msg.sender;
235         balances[burner] = balances[burner].sub(_value);
236         totalSupply = totalSupply.sub(_value);
237         Burn(burner, _value);
238     }
239 }
240 
241 /**
242  * @title Mintable token
243  * @dev Simple ERC20 Token example, with mintable token creation
244  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
245  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
246  */
247 
248 contract MintableToken is StandardToken, Ownable {
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
270     Transfer(address(0), _to, _amount);
271     return true;
272   }
273 
274   /**
275    * @dev Function to stop minting new tokens.
276    * @return True if the operation was successful.
277    */
278   function finishMinting() onlyOwner canMint public returns (bool) {
279     mintingFinished = true;
280     MintFinished();
281     return true;
282   }
283 }
284 
285 contract KimeraToken is MintableToken, BurnableToken {
286     string public name = "Kimera";
287     string public symbol = "Kimera";
288     uint256 public decimals = 18;
289 }
290 
291 /**
292  * @title Crowdsale
293  * @dev Crowdsale is a base contract for managing a token crowdsale.
294  * Crowdsales have a start and end timestamps, where investors can make
295  * token purchases and the crowdsale will assign them tokens based
296  * on a token per ETH rate. Funds collected are forwarded to a wallet
297  * as they arrive.
298  */
299 contract Crowdsale {
300   using SafeMath for uint256;
301 
302   // The token being sold
303   MintableToken public token;
304 
305   // start and end timestamps where investments are allowed (both inclusive)
306   uint256 public startTime;
307   uint256 public endTime;
308 
309   // address where funds are collected
310   address public wallet;
311 
312   // how many token units a buyer gets per wei
313   uint256 public rate;
314 
315   // amount of raised money in wei
316   uint256 public weiRaised;
317 
318   /**
319    * event for token purchase logging
320    * @param purchaser who paid for the tokens
321    * @param beneficiary who got the tokens
322    * @param value weis paid for purchase
323    * @param amount amount of tokens purchased
324    */
325   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
326 
327 
328   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
329     require(_startTime >= now);
330     require(_endTime >= _startTime);
331     require(_rate > 0);
332     require(_wallet != address(0));
333 
334     token = createTokenContract();
335     startTime = _startTime;
336     endTime = _endTime;
337     rate = _rate;
338     wallet = _wallet;
339   }
340 
341   // creates the token to be sold.
342   // override this method to have crowdsale of a specific mintable token.
343   function createTokenContract() internal returns (MintableToken) {
344     return new MintableToken();
345   }
346 
347 
348   // fallback function can be used to buy tokens
349   function () payable {
350     buyTokens(msg.sender);
351   }
352 
353   // low level token purchase function
354   function buyTokens(address beneficiary) public payable {
355     require(beneficiary != address(0));
356     require(validPurchase());
357 
358     uint256 weiAmount = msg.value;
359 
360     // calculate token amount to be created
361     uint256 tokens = weiAmount.mul(rate);
362 
363     // update state
364     weiRaised = weiRaised.add(weiAmount);
365 
366     token.mint(beneficiary, tokens);
367     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
368 
369     forwardFunds();
370   }
371 
372   // send ether to the fund collection wallet
373   // override to create custom fund forwarding mechanisms
374   function forwardFunds() internal {
375     wallet.transfer(msg.value);
376   }
377 
378   // @return true if the transaction can buy tokens
379   function validPurchase() internal constant returns (bool) {
380     bool withinPeriod = now >= startTime && now <= endTime;
381     bool nonZeroPurchase = msg.value != 0;
382     return withinPeriod && nonZeroPurchase;
383   }
384 
385   // @return true if crowdsale event has ended
386   function hasEnded() public constant returns (bool) {
387     return now > endTime;
388   }
389 
390 
391 }
392 
393 
394 contract KimeraTokenCrowdsale is Ownable, Crowdsale {
395 
396     using SafeMath for uint256;
397   
398     //operational
399     bool public LockupTokensWithdrawn = false;
400     uint256 public constant toDec = 10**18;
401     uint256 public tokensLeft = 1000000000*toDec;
402     
403     enum State { BeforeSale, preSale, NormalSale, ShouldFinalize, Lockup, SaleOver }
404     State public state = State.BeforeSale;
405     uint256 public accumulated = 0;
406 
407 
408  /* --- Wallets --- */
409 
410     address[7] public wallets;
411 
412     uint256 public adminSum = 470000000*toDec; // 0 - 23.5%
413     uint256 public NigelFundSum = 400000000*toDec; // 1 - 20%
414     uint256 public teamSum = 100000000*toDec; // 2 - 5%
415     uint256 public advisor1Sum = 12000000*toDec; // 3 - 0.6%
416     uint256 public advisor2Sum = 12000000*toDec; // 4 - 0.6%
417     uint256 public advisor3Sum = 6000000*toDec; // 5 - 0.3%
418 
419     // /* --- Time periods --- */
420 
421     uint256 public lockupPeriod = 360 * 1 days; // 360 days - 15552000
422 
423     uint256 public presaleEndtime = 1529020800;
424     uint256 public ICOEndTime = 1531612800;
425 
426 
427 
428     event LockedUpTokensWithdrawn();
429     event Finalized();
430 
431     modifier canWithdrawLockup() {
432         require(state == State.Lockup);
433         require(endTime.add(lockupPeriod) < block.timestamp);
434         _;
435     }
436 
437     function KimeraTokenCrowdsale(
438         address _admin, /*used as the wallet for collecting Kimeras*/
439         address _NigelFund,
440         address _team,
441         address _advisor1,
442         address _advisor2,
443         address _advisor3,
444         address _unsold)
445     Crowdsale(
446         now + 5, // 2018-01-25T12:00:00+00:00 - 1516881600
447         ICOEndTime,// 2018-02-25T12:00:00+00:00 - 1519560000 
448         3333,/* start rate - 3333 */
449         _admin
450     )  
451     public 
452     {      
453         wallets[0] = _admin;
454         wallets[1] = _NigelFund;
455         wallets[2] = _team;
456         wallets[3] = _advisor1;
457         wallets[4] = _advisor2;
458         wallets[5] = _advisor3;
459         wallets[6] = _unsold;
460         owner = _admin;
461         token.mint(wallets[0], adminSum);
462         token.mint(wallets[1], NigelFundSum);
463         token.mint(wallets[3], advisor1Sum);
464         token.mint(wallets[4], advisor2Sum);
465         token.mint(wallets[5], advisor3Sum);
466     }
467 
468     // creates the token to be sold.
469     // override this method to have crowdsale of a specific MintableToken token.
470     function createTokenContract() internal returns (MintableToken) {
471         return new KimeraToken();
472     }
473 
474 
475     function forwardFunds() internal {
476         forwardFundsAmount(msg.value);
477     }
478 
479     function forwardFundsAmount(uint256 amount) internal {
480         var halfPercent = amount.div(200);
481         var adminAmount = halfPercent.mul(197);
482         var advisorAmount = halfPercent.mul(3);
483         wallets[0].transfer(adminAmount);
484         wallets[3].transfer(advisorAmount);
485         var left = amount.sub(adminAmount).sub(advisorAmount);
486         accumulated = accumulated.add(left);
487     }
488 
489     function refundAmount(uint256 amount) internal {
490         msg.sender.transfer(amount);
491     }
492 
493 
494     function fixAddress(address newAddress, uint256 walletIndex) onlyOwner public {
495         wallets[walletIndex] = newAddress;
496     }
497 
498     function calculateCurrentRate(State stat) internal {
499         if (stat == State.NormalSale) {
500             rate = 1666;
501         }
502     }
503 
504     function buyTokensUpdateState() internal {
505         var temp = state;
506         if(temp == State.BeforeSale && now >= startTime) { temp = State.preSale; }
507         if(temp == State.preSale && now >= presaleEndtime) { temp = State.NormalSale; }
508         if((temp == State.preSale || temp == State.BeforeSale) && tokensLeft <= 250000000*toDec) { temp = State.NormalSale; }
509         calculateCurrentRate(temp);
510         require(temp != State.ShouldFinalize && temp != State.Lockup && temp != State.SaleOver);
511         if(msg.value.mul(rate) >= tokensLeft) { temp = State.ShouldFinalize; }
512         state = temp;
513     }
514 
515     function buyTokens(address beneficiary) public payable {
516         buyTokensUpdateState();
517         var numTokens = msg.value.mul(rate);
518         if(state == State.ShouldFinalize) {
519             lastTokens(beneficiary);
520             numTokens = tokensLeft;
521         }
522         else {
523             super.buyTokens(beneficiary);
524         }
525         tokensLeft = tokensLeft.sub(numTokens);
526     }
527 
528     function lastTokens(address beneficiary) internal {
529         require(beneficiary != 0x0);
530         require(validPurchase());
531 
532         uint256 weiAmount = msg.value;
533 
534         // calculate token amount to be created
535         uint256 tokensForFullBuy = weiAmount.mul(rate);// must be bigger or equal to tokensLeft to get here
536         uint256 tokensToReKimeraFor = tokensForFullBuy.sub(tokensLeft);
537         uint256 tokensRemaining = tokensForFullBuy.sub(tokensToReKimeraFor);
538         uint256 weiAmountToReKimera = tokensToReKimeraFor.div(rate);
539         uint256 weiRemaining = weiAmount.sub(weiAmountToReKimera);
540         
541         // update state
542         weiRaised = weiRaised.add(weiRemaining);
543 
544         token.mint(beneficiary, tokensRemaining);
545 
546         TokenPurchase(msg.sender, beneficiary, weiRemaining, tokensRemaining);
547         forwardFundsAmount(weiRemaining);
548         refundAmount(weiAmountToReKimera);
549     }
550 
551     function withdrawLockupTokens() canWithdrawLockup public {
552         token.mint(wallets[2], teamSum);
553         
554         token.finishMinting();
555         LockupTokensWithdrawn = true;
556         LockedUpTokensWithdrawn();
557         state = State.SaleOver;
558     }
559 
560     function finalizeUpdateState() internal {
561         if(now > endTime) { state = State.ShouldFinalize; }
562         if(tokensLeft == 0) { state = State.ShouldFinalize; }
563     }
564 
565     function finalize() public {
566         finalizeUpdateState();
567         require (state == State.ShouldFinalize);
568 
569         finalization();
570         Finalized();
571     }
572 
573     function finalization() internal {
574         endTime = block.timestamp; // update to start lockup
575         token.mint(wallets[6], tokensLeft); // mint unsold tokens
576         state = State.Lockup;
577     }
578     
579 }