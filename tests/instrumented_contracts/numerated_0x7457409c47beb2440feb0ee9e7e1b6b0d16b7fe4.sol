1 pragma solidity 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
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
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72 
73     // SafeMath.sub will throw if there is not enough balance.
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of.
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) public constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 contract Ownable {
92   address public owner;
93 
94 
95   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97 
98   /**
99    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100    * account.
101    */
102   function Ownable() {
103     owner = msg.sender;
104   }
105 
106 
107   /**
108    * @dev Throws if called by any account other than the owner.
109    */
110   modifier onlyOwner() {
111     require(msg.sender == owner);
112     _;
113   }
114 
115 
116   /**
117    * @dev Allows the current owner to transfer control of the contract to a newOwner.
118    * @param newOwner The address to transfer ownership to.
119    */
120   function transferOwnership(address newOwner) onlyOwner public {
121     require(newOwner != address(0));
122     OwnershipTransferred(owner, newOwner);
123     owner = newOwner;
124   }
125 
126 }
127 
128 contract StandardToken is ERC20, BasicToken {
129 
130     mapping (address => mapping (address => uint256)) allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140         require(_to != address(0));
141 
142         uint256 _allowance = allowed[_from][msg.sender];
143 
144     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
145     // require (_value <= _allowance);
146 
147         balances[_from] = balances[_from].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149         allowed[_from][msg.sender] = _allowance.sub(_value);
150         Transfer(_from, _to, _value);
151         return true;
152     }
153 
154   /**
155    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156    *
157    * Beware that changing an allowance with this method brings the risk that someone may use both the old
158    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164     function approve(address _spender, uint256 _value) public returns (bool) {
165         allowed[msg.sender][_spender] = _value;
166         Approval(msg.sender, _spender, _value);
167         return true;
168     }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
177         return allowed[_owner][_spender];
178     }
179 
180   /**
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    */
186     function increaseApproval (address _spender, uint _addedValue)
187         returns (bool success) {
188         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190         return true;
191     }
192 
193     function decreaseApproval (address _spender, uint _subtractedValue) public
194     returns (bool success) {
195         uint oldValue = allowed[msg.sender][_spender];
196         if (_subtractedValue > oldValue) {
197             allowed[msg.sender][_spender] = 0;
198         } else {
199             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
200         }
201         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202         return true;
203     }
204 
205 }
206 
207 contract BurnableToken is StandardToken {
208 
209     event Burn(address indexed burner, uint256 value);
210 
211     /**
212      * @dev Burns a specific amount of tokens.
213      * @param _value The amount of token to be burned.
214      */
215     function burn(uint256 _value) public {
216         require(_value > 0);
217         require(_value <= balances[msg.sender]);
218         // no need to require value <= totalSupply, since that would imply the
219         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
220 
221         address burner = msg.sender;
222         balances[burner] = balances[burner].sub(_value);
223         totalSupply = totalSupply.sub(_value);
224         Burn(burner, _value);
225     }
226 }
227 
228 contract MintableToken is StandardToken, Ownable {
229   event Mint(address indexed to, uint256 amount);
230   event MintFinished();
231 
232   bool public mintingFinished = false;
233 
234 
235   modifier canMint() {
236     require(!mintingFinished);
237     _;
238   }
239 
240   /**
241    * @dev Function to mint tokens
242    * @param _to The address that will receive the minted tokens.
243    * @param _amount The amount of tokens to mint.
244    * @return A boolean that indicates if the operation was successful.
245    */
246   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
247     totalSupply = totalSupply.add(_amount);
248     balances[_to] = balances[_to].add(_amount);
249     Mint(_to, _amount);
250     Transfer(0x0, _to, _amount);
251     return true;
252   }
253 
254   /**
255    * @dev Function to stop minting new tokens.
256    * @return True if the operation was successful.
257    */
258   function finishMinting() onlyOwner public returns (bool) {
259     mintingFinished = true;
260     MintFinished();
261     return true;
262   }
263 }
264 
265 contract Tigereum is MintableToken, BurnableToken {
266     string public webAddress = "www.tigereum.io";
267     string public name = "Tigereum";
268     string public symbol = "TIG";
269     uint8 public decimals = 18;
270 }
271 
272 /**
273  * @title Crowdsale
274  * @dev Crowdsale is a base contract for managing a token crowdsale.
275  * Crowdsales have a start and end timestamps, where investors can make
276  * token purchases and the crowdsale will assign them tokens based
277  * on a token per ETH rate. Funds collected are forwarded to a wallet
278  * as they arrive.
279  */
280 contract Crowdsale {
281   using SafeMath for uint256;
282 
283   // The token being sold
284   MintableToken public token;
285 
286   // start and end timestamps where investments are allowed (both inclusive)
287   uint256 public startTime;
288   uint256 public endTime;
289 
290   // address where funds are collected
291   address public wallet;
292 
293   // how many token units a buyer gets per wei
294   uint256 public rate;
295 
296   // amount of raised money in wei
297   uint256 public weiRaised;
298 
299   /**
300    * event for token purchase logging
301    * @param purchaser who paid for the tokens
302    * @param beneficiary who got the tokens
303    * @param value weis paid for purchase
304    * @param amount amount of tokens purchased
305    */
306   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
307 
308 
309   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
310     require(_startTime >= now);
311     require(_endTime >= _startTime);
312     require(_rate > 0);
313     require(_wallet != 0x0);
314 
315     token = createTokenContract();
316     startTime = _startTime;
317     endTime = _endTime;
318     rate = _rate;
319     wallet = _wallet;
320   }
321 
322   // creates the token to be sold.
323   // override this method to have crowdsale of a specific mintable token.
324   function createTokenContract() internal returns (MintableToken) {
325     return new MintableToken();
326   }
327 
328 
329   // fallback function can be used to buy tokens
330   function () payable {
331     buyTokens(msg.sender);
332   }
333 
334   // low level token purchase function
335   function buyTokens(address beneficiary) public payable {
336     require(beneficiary != 0x0);
337     require(validPurchase());
338 
339     uint256 weiAmount = msg.value;
340 
341     // calculate token amount to be created
342     uint256 tokens = weiAmount.mul(rate);
343 
344     // update state
345     weiRaised = weiRaised.add(weiAmount);
346 
347     token.mint(beneficiary, tokens);
348     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
349 
350     forwardFunds();
351   }
352 
353   // send ether to the fund collection wallet
354   // override to create custom fund forwarding mechanisms
355   function forwardFunds() internal {
356     wallet.transfer(msg.value);
357   }
358 
359   // @return true if the transaction can buy tokens
360   function validPurchase() internal constant returns (bool) {
361     var curtime = now;
362     bool withinPeriod = now >= startTime && now <= endTime;
363     bool nonZeroPurchase = msg.value != 0;
364     return withinPeriod && nonZeroPurchase;
365   }
366 
367   // @return true if crowdsale event has ended
368   function hasEnded() public constant returns (bool) {
369     return now > endTime;
370   }
371 
372 
373 }
374 
375 contract TigereumCrowdsale is Ownable, Crowdsale {
376 
377     using SafeMath for uint256;
378   
379     //operational
380     bool public LockupTokensWithdrawn = false;
381     bool public isFinalized = false;
382     uint256 public constant toDec = 10**18;
383     uint256 public tokensLeft = 32800000*toDec;
384     uint256 public constant cap = 32800000*toDec;
385     uint256 public constant startRate = 1333;
386     uint256 private accumulated = 0;
387 
388     enum State { BeforeSale, Bonus, NormalSale, ShouldFinalize, Lockup, SaleOver }
389     State public state = State.BeforeSale;
390 
391     /* --- Ether wallets --- */
392 
393     address public admin;// = 0x021e366d41cd25209a9f1197f238f10854a0c662; // 0 - get 99% of ether
394     address public ICOadvisor1;// = 0xBD1b96D30E1a202a601Fa8823Fc83Da94D71E3cc; // 1 - get 1% of ether
395     uint256 private constant ICOadvisor1Sum = 400000*toDec; // also gets tokens - 0.8% - 400,000
396 
397     // Pre ICO wallets
398 
399     address public hundredKInvestor;// = 0x93da612b3DA1eF05c5D80c9B906bf9e7aAdc4a23;
400     uint256 private constant hundredKInvestorSum = 3200000*toDec; // 2 - 6.4% - 3,200,000
401 
402     address public additionalPresaleInvestors;// = 0x095e80F85f3D260bF959Aa524F2f3918f56a2493;
403     uint256 private constant additionalPresaleInvestorsSum = 1000000*toDec; // 3 - 2% - 1,000,000
404 
405     address public preSaleBotReserve;// = 0x095e80F85f3D260bF959Aa524F2f3918f56a2493; // same as additionalPresaleInvestors
406     uint256 private constant preSaleBotReserveSum = 2500000*toDec; // 4 - 5% - 2,500,000
407 
408     address public ICOadvisor2;// = 0xe05416EAD6d997C8bC88A7AE55eC695c06693C58;
409     uint256 private constant ICOadvisor2Sum = 100000*toDec; // 5 - 0.2% - 100,000
410 
411     address public team;// = 0xA919B56D099C12cC8921DF605Df2D696b30526B0;
412     uint256 private constant teamSum = 1820000*toDec; // 6 - 3.64% - 1,820,000
413  
414     address public bounty;// = 0x20065A723d43c753AD83689C5f9F4786a73Be6e6;
415     uint256 private constant bountySum = 1000000*toDec; // 7 - 2% - 1,000,000
416 
417     
418     // Lockup wallets
419     address public founders;// = 0x49ddcD8b4B1F54f3E5c4fEf705025C1DaDC753f6;
420     uint256 private constant foundersSum = 7180000*toDec; // 8 - 14.36% - 7,180,000
421 
422 
423     /* --- Time periods --- */
424 
425 
426     uint256 public constant startTimeNumber = 1512723600 + 1; // 8/12/17-9:00:00 - 1512723600
427     uint256 public constant endTimeNumber = 1513641540; // 18/12/17-23:59:00 - 1513641540
428 
429     uint256 public constant lockupPeriod = 90 * 1 days; // 90 days - 7776000
430     uint256 public constant bonusPeriod = 12 * 1 hours; // 12 hours - 43,200
431 
432     uint256 public constant bonusEndTime = bonusPeriod + startTimeNumber;
433 
434 
435 
436     event LockedUpTokensWithdrawn();
437     event Finalized();
438 
439     modifier canWithdrawLockup() {
440         require(state == State.Lockup);
441         require(endTime.add(lockupPeriod) < block.timestamp);
442         _;
443     }
444 
445     function TigereumCrowdsale(
446         address _admin,
447         address _ICOadvisor1,
448         address _hundredKInvestor,
449         address _additionalPresaleInvestors,
450         address _preSaleBotReserve,
451         address _ICOadvisor2,
452         address _team,
453         address _bounty,
454         address _founders)
455     Crowdsale(
456         startTimeNumber /* start date - 8/12/17-9:00:00 */, 
457         endTimeNumber /* end date - 18/12/17-23:59:00 */, 
458         startRate /* start rate - 1333 */, 
459         _admin
460     )  
461     public 
462     {      
463         admin = _admin;
464         ICOadvisor1 = _ICOadvisor1;
465         hundredKInvestor = _hundredKInvestor;
466         additionalPresaleInvestors = _additionalPresaleInvestors;
467         preSaleBotReserve = _preSaleBotReserve;
468         ICOadvisor2 = _ICOadvisor2;
469         team = _team;
470         bounty = _bounty;
471         founders = _founders;
472         owner = admin;
473     }
474 
475     function isContract(address addr) private returns (bool) {
476       uint size;
477       assembly { size := extcodesize(addr) }
478       return size > 0;
479     }
480 
481     // creates the token to be sold.
482     // override this method to have crowdsale of a specific MintableToken token.
483     function createTokenContract() internal returns (MintableToken) {
484         return new Tigereum();
485     }
486 
487     function forwardFunds() internal {
488         forwardFundsAmount(msg.value);
489     }
490 
491     function forwardFundsAmount(uint256 amount) internal {
492         var onePercent = amount / 100;
493         var adminAmount = onePercent.mul(99);
494         admin.transfer(adminAmount);
495         ICOadvisor1.transfer(onePercent);
496         var left = amount.sub(adminAmount).sub(onePercent);
497         accumulated = accumulated.add(left);
498     }
499 
500     function refundAmount(uint256 amount) internal {
501         msg.sender.transfer(amount);
502     }
503 
504     function fixAddress(address newAddress, uint256 walletIndex) onlyOwner public {
505         require(state != State.ShouldFinalize && state != State.Lockup && state != State.SaleOver);
506         if (walletIndex == 0 && !isContract(newAddress)) {
507             admin = newAddress;
508         }
509         if (walletIndex == 1 && !isContract(newAddress)) {
510             ICOadvisor1 = newAddress;
511         }
512         if (walletIndex == 2) {
513             hundredKInvestor = newAddress;
514         }
515         if (walletIndex == 3) {
516             additionalPresaleInvestors = newAddress;
517         }
518         if (walletIndex == 4) {
519             preSaleBotReserve = newAddress;
520         }
521         if (walletIndex == 5) {
522             ICOadvisor2 = newAddress;
523         }
524         if (walletIndex == 6) {
525             team = newAddress;
526         }
527         if (walletIndex == 7) {
528             bounty = newAddress;
529         }
530         if (walletIndex == 8) {
531             founders = newAddress;
532         }
533     }
534 
535     function calculateCurrentRate() internal {
536         if (state == State.NormalSale) {
537             rate = 1000;
538         }
539     }
540 
541     function buyTokensUpdateState() internal {
542         if(state == State.BeforeSale && now >= startTimeNumber) { state = State.Bonus; }
543         if(state == State.Bonus && now >= bonusEndTime) { state = State.NormalSale; }
544         calculateCurrentRate();
545         require(state != State.ShouldFinalize && state != State.Lockup && state != State.SaleOver);
546         if(msg.value.mul(rate) >= tokensLeft) { state = State.ShouldFinalize; }
547     }
548 
549     function buyTokens(address beneficiary) public payable {
550         buyTokensUpdateState();
551         var numTokens = msg.value.mul(rate);
552         if(state == State.ShouldFinalize) {
553             lastTokens(beneficiary);
554             finalize();
555         }
556         else {
557             tokensLeft = tokensLeft.sub(numTokens); // if negative, should finalize
558             super.buyTokens(beneficiary);
559         }
560     }
561 
562     function lastTokens(address beneficiary) internal {
563         require(beneficiary != 0x0);
564         require(validPurchase());
565 
566         uint256 weiAmount = msg.value;
567 
568         // calculate token amount to be created
569         uint256 tokensForFullBuy = weiAmount.mul(rate);// must be bigger or equal to tokensLeft to get here
570         uint256 tokensToRefundFor = tokensForFullBuy.sub(tokensLeft);
571         uint256 tokensRemaining = tokensForFullBuy.sub(tokensToRefundFor);
572         uint256 weiAmountToRefund = tokensToRefundFor.div(rate);
573         uint256 weiRemaining = weiAmount.sub(weiAmountToRefund);
574         
575         // update state
576         weiRaised = weiRaised.add(weiRemaining);
577 
578         token.mint(beneficiary, tokensRemaining);
579         TokenPurchase(msg.sender, beneficiary, weiRemaining, tokensRemaining);
580 
581         forwardFundsAmount(weiRemaining);
582         refundAmount(weiAmountToRefund);
583     }
584 
585     function withdrawLockupTokens() canWithdrawLockup public {
586         rate = 1000;
587         token.mint(founders, foundersSum);
588         token.finishMinting();
589         LockupTokensWithdrawn = true;
590         LockedUpTokensWithdrawn();
591         state = State.SaleOver;
592     }
593 
594     function finalizeUpdateState() internal {
595         if(now > endTimeNumber) { state = State.ShouldFinalize; }
596         if(tokensLeft == 0) { state = State.ShouldFinalize; }
597     }
598 
599     function finalize() public {
600         finalizeUpdateState();
601         require (!isFinalized);
602         require (state == State.ShouldFinalize);
603 
604         finalization();
605         Finalized();
606 
607         isFinalized = true;
608     }
609 
610     function finalization() internal {
611         endTime = block.timestamp;
612         /* - preICO investors - */
613         token.mint(ICOadvisor1, ICOadvisor1Sum);
614         token.mint(hundredKInvestor, hundredKInvestorSum);
615         token.mint(additionalPresaleInvestors, additionalPresaleInvestorsSum);
616         token.mint(preSaleBotReserve, preSaleBotReserveSum);
617         token.mint(ICOadvisor2, ICOadvisor2Sum);
618         token.mint(team, teamSum);
619         token.mint(bounty, bountySum);
620         forwardFundsAmount(accumulated);
621         tokensLeft = 0;
622         state = State.Lockup;
623     }
624 }