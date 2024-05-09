1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 library SafeMath {
41   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
42     uint256 c = a * b;
43     assert(a == 0 || c / a == b);
44     return c;
45   }
46 
47   function div(uint256 a, uint256 b) internal constant returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return c;
52   }
53 
54   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   function add(uint256 a, uint256 b) internal constant returns (uint256) {
60     uint256 c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
65 
66 contract RefundVault is Ownable {
67   using SafeMath for uint256;
68 
69   enum State { Active, Refunding, Closed }
70 
71   mapping (address => uint256) public deposited;
72   address public wallet;
73   State public state;
74 
75   event Closed();
76   event RefundsEnabled();
77   event Refunded(address indexed beneficiary, uint256 weiAmount);
78 
79   function RefundVault(address _wallet) {
80     require(_wallet != 0x0);
81     wallet = _wallet;
82     state = State.Active;
83   }
84 
85   function deposit(address investor) onlyOwner public payable {
86     require(state == State.Active);
87     deposited[investor] = deposited[investor].add(msg.value);
88   }
89 
90   function close() onlyOwner public {
91     require(state == State.Active);
92     state = State.Closed;
93     Closed();
94     wallet.transfer(this.balance);
95   }
96 
97   function enableRefunds() onlyOwner public {
98     require(state == State.Active);
99     state = State.Refunding;
100     RefundsEnabled();
101   }
102 
103   function refund(address investor) public {
104     require(state == State.Refunding);
105     uint256 depositedValue = deposited[investor];
106     deposited[investor] = 0;
107     investor.transfer(depositedValue);
108     Refunded(investor, depositedValue);
109   }
110 }
111 
112 contract Crowdsale {
113   using SafeMath for uint256;
114 
115   // The token being sold
116   MintableToken public token;
117 
118   // start and end timestamps where investments are allowed (both inclusive)
119   uint256 public startTime;
120   uint256 public endTime;
121 
122   // address where funds are collected
123   address public wallet;
124 
125   // how many token units a buyer gets per wei
126   uint256 public rate;
127 
128   // amount of raised money in wei
129   uint256 public weiRaised;
130 
131   /**
132    * event for token purchase logging
133    * @param purchaser who paid for the tokens
134    * @param beneficiary who got the tokens
135    * @param value weis paid for purchase
136    * @param amount amount of tokens purchased
137    */
138   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
139 
140 
141   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
142     require(_startTime >= now);
143     require(_endTime >= _startTime);
144     require(_rate > 0);
145     require(_wallet != 0x0);
146 
147     token = createTokenContract();
148     startTime = _startTime;
149     endTime = _endTime;
150     rate = _rate;
151     wallet = _wallet;
152   }
153 
154   // creates the token to be sold.
155   // override this method to have crowdsale of a specific mintable token.
156   function createTokenContract() internal returns (MintableToken) {
157     return new MintableToken();
158   }
159 
160 
161   // fallback function can be used to buy tokens
162   function () payable {
163     buyTokens(msg.sender);
164   }
165 
166   // low level token purchase function
167   function buyTokens(address beneficiary) public payable {
168     require(beneficiary != 0x0);
169     require(validPurchase());
170 
171     uint256 weiAmount = msg.value;
172 
173     // calculate token amount to be created
174     uint256 tokens = weiAmount.mul(rate);
175 
176     // update state
177     weiRaised = weiRaised.add(weiAmount);
178 
179     token.mint(beneficiary, tokens);
180     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
181 
182     forwardFunds();
183   }
184 
185   // send ether to the fund collection wallet
186   // override to create custom fund forwarding mechanisms
187   function forwardFunds() internal {
188     wallet.transfer(msg.value);
189   }
190 
191   // @return true if the transaction can buy tokens
192   function validPurchase() internal constant returns (bool) {
193     bool withinPeriod = now >= startTime && now <= endTime;
194     bool nonZeroPurchase = msg.value != 0;
195     return withinPeriod && nonZeroPurchase;
196   }
197 
198   // @return true if crowdsale event has ended
199   function hasEnded() public constant returns (bool) {
200     return now > endTime;
201   }
202 
203 
204 }
205 
206 contract Pausable is Ownable {
207   event Pause();
208   event Unpause();
209 
210   bool public paused = false;
211 
212 
213   /**
214    * @dev Modifier to make a function callable only when the contract is not paused.
215    */
216   modifier whenNotPaused() {
217     require(!paused);
218     _;
219   }
220 
221   /**
222    * @dev Modifier to make a function callable only when the contract is paused.
223    */
224   modifier whenPaused() {
225     require(paused);
226     _;
227   }
228 
229   /**
230    * @dev called by the owner to pause, triggers stopped state
231    */
232   function pause() onlyOwner whenNotPaused public {
233     paused = true;
234     Pause();
235   }
236 
237   /**
238    * @dev called by the owner to unpause, returns to normal state
239    */
240   function unpause() onlyOwner whenPaused public {
241     paused = false;
242     Unpause();
243   }
244 }
245 
246 contract CappedCrowdsale is Crowdsale {
247   using SafeMath for uint256;
248 
249   uint256 public cap;
250 
251   function CappedCrowdsale(uint256 _cap) {
252     require(_cap > 0);
253     cap = _cap;
254   }
255 
256   // overriding Crowdsale#validPurchase to add extra cap logic
257   // @return true if investors can buy at the moment
258   function validPurchase() internal constant returns (bool) {
259     bool withinCap = weiRaised.add(msg.value) <= cap;
260     return super.validPurchase() && withinCap;
261   }
262 
263   // overriding Crowdsale#hasEnded to add cap logic
264   // @return true if crowdsale event has ended
265   function hasEnded() public constant returns (bool) {
266     bool capReached = weiRaised >= cap;
267     return super.hasEnded() || capReached;
268   }
269 
270 }
271 
272 contract FinalizableCrowdsale is Crowdsale, Ownable {
273   using SafeMath for uint256;
274 
275   bool public isFinalized = false;
276 
277   event Finalized();
278 
279   /**
280    * @dev Must be called after crowdsale ends, to do some extra finalization
281    * work. Calls the contract's finalization function.
282    */
283   function finalize() onlyOwner public {
284     require(!isFinalized);
285     require(hasEnded());
286 
287     finalization();
288     Finalized();
289 
290     isFinalized = true;
291   }
292 
293   /**
294    * @dev Can be overridden to add finalization logic. The overriding function
295    * should call super.finalization() to ensure the chain of finalization is
296    * executed entirely.
297    */
298   function finalization() internal {
299   }
300 }
301 
302 contract ERC20Basic {
303   uint256 public totalSupply;
304   function balanceOf(address who) public constant returns (uint256);
305   function transfer(address to, uint256 value) public returns (bool);
306   event Transfer(address indexed from, address indexed to, uint256 value);
307 }
308 
309 contract BasicToken is ERC20Basic {
310   using SafeMath for uint256;
311 
312   mapping(address => uint256) balances;
313 
314   /**
315   * @dev transfer token for a specified address
316   * @param _to The address to transfer to.
317   * @param _value The amount to be transferred.
318   */
319   function transfer(address _to, uint256 _value) public returns (bool) {
320     require(_to != address(0));
321 
322     // SafeMath.sub will throw if there is not enough balance.
323     balances[msg.sender] = balances[msg.sender].sub(_value);
324     balances[_to] = balances[_to].add(_value);
325     Transfer(msg.sender, _to, _value);
326     return true;
327   }
328 
329   /**
330   * @dev Gets the balance of the specified address.
331   * @param _owner The address to query the the balance of.
332   * @return An uint256 representing the amount owned by the passed address.
333   */
334   function balanceOf(address _owner) public constant returns (uint256 balance) {
335     return balances[_owner];
336   }
337 
338 }
339 
340 contract ERC20 is ERC20Basic {
341   function allowance(address owner, address spender) public constant returns (uint256);
342   function transferFrom(address from, address to, uint256 value) public returns (bool);
343   function approve(address spender, uint256 value) public returns (bool);
344   event Approval(address indexed owner, address indexed spender, uint256 value);
345 }
346 
347 contract RefundableCrowdsale is FinalizableCrowdsale {
348   using SafeMath for uint256;
349 
350   // minimum amount of funds to be raised in weis
351   uint256 public goal;
352 
353   // refund vault used to hold funds while crowdsale is running
354   RefundVault public vault;
355 
356   function RefundableCrowdsale(uint256 _goal) {
357     require(_goal > 0);
358     vault = new RefundVault(wallet);
359     goal = _goal;
360   }
361 
362   // We're overriding the fund forwarding from Crowdsale.
363   // In addition to sending the funds, we want to call
364   // the RefundVault deposit function
365   function forwardFunds() internal {
366     vault.deposit.value(msg.value)(msg.sender);
367   }
368 
369   // if crowdsale is unsuccessful, investors can claim refunds here
370   function claimRefund() public {
371     require(isFinalized);
372     require(!goalReached());
373 
374     vault.refund(msg.sender);
375   }
376 
377   // vault finalization task, called when owner calls finalize()
378   function finalization() internal {
379     if (goalReached()) {
380       vault.close();
381     } else {
382       vault.enableRefunds();
383     }
384 
385     super.finalization();
386   }
387 
388   function goalReached() public constant returns (bool) {
389     return weiRaised >= goal;
390   }
391 
392 }
393 
394 contract ZakemFansCrowdsale is Pausable, RefundableCrowdsale, CappedCrowdsale {
395         /**
396            Address of the wallet of the founders.
397            In this wallet, part of the facilitating tokens will be stored, and they will be locked for 24 months.
398          */
399         address public foundersWallet;
400 
401         /**
402            Address of the wallet used to pay out bounties.
403            In this wallet, part of the facilitating tokens will be stored.
404          */
405         address public bountiesWallet;
406 
407         /**
408            Keeps track of how many tokens have been raised so far.
409            Used to know when `goal` and `cap` have been reached.
410          */
411         uint256 public purchasedTokensRaised;
412 
413         /**
414            The amount of tokens that were sold in the Presale before the Crowdsale.
415            Given during construction of this contract.
416          */
417         uint256 public purchasedTokensRaisedDuringPresale;
418 
419         /**
420            Helper property to ensure that 1/12 of `cap` does not need to be re-calculated every time.
421          */
422         uint256 oneTwelfthOfCap;
423 
424         /**
425            @dev Constructor of the ZakemFansCrowdsale contract
426 
427            @param _startTime time (Solidity UNIX timestamp) from when it is allowed to buy FINC.
428            @param _endTime time (Solidity UNIX timestamp) until which it is allowed to buy FINC. (Should be larger than startTime)
429            @param _rate Number of tokens created per ether. (Since Ether and ZakemCoin use the same number of decimal places, this can be read as direct conversion rate of Ether -> ZakemCoin.)
430            @param _wallet The wallet of ZakemFans itself, to which some of the facilitating tokens will be sent.
431            @param _bountiesWallet The wallet used to pay out bounties, to which some of the facilitating tokens will be sent.
432            @param _foundersWallet The wallet used for the founders, to which some of the facilitating tokens will be sent.
433            @param _goal The minimum goal (in 1 * 10^(-18) tokens) that the Crowdsale needs to reach.
434            @param _cap The maximum cap (in 1 * 10^(-18) tokens) that the Crowdsale can reach.
435            @param _token The address where the ZakemCoin contract was deployed prior to creating this contract.
436            @param _purchasedTokensRaisedDuringPresale The amount (in 1 * 18^18 tokens) that was purchased during the presale.
437          */
438         function ZakemFansCrowdsale (
439                 uint256 _startTime,
440                 uint256 _endTime,
441                 uint256 _rate,
442                 address _wallet,
443                 address _bountiesWallet,
444                 address _foundersWallet,
445                 uint256 _goal,
446                 uint256 _cap,
447                 address _token,
448                 uint256 _purchasedTokensRaisedDuringPresale
449                 )
450                 Crowdsale(_startTime, _endTime, _rate, _wallet)
451                 RefundableCrowdsale(_goal)
452                 CappedCrowdsale(_cap)
453         {
454                 require(_goal < _cap);
455 
456                 bountiesWallet = _bountiesWallet;
457                 foundersWallet = _foundersWallet;
458                 token = ZakemCoin(_token);
459                 weiRaised = 0;
460 
461                 purchasedTokensRaisedDuringPresale = _purchasedTokensRaisedDuringPresale;
462                 purchasedTokensRaised = purchasedTokensRaisedDuringPresale;
463 
464                 oneTwelfthOfCap = _cap / 12;
465         }
466 
467         /*
468           Overrides Crowdsale.createTokenContract,
469           because the ZakemFansCrowdsale uses an already-deployed
470           token, so there is no need to internally deploy a contract.
471         */
472         function createTokenContract() internal returns (MintableToken) {
473                 return MintableToken(0x0);
474         }
475 
476         /*
477          * Overrides version of Crowdsale.buyTokens because:
478          * - The Wei->FFC rate depends on how many tokens have already been sold (see `currentBonusRate()`).
479          * - Also mint tokens sent to ZakemFans and the Founders at the same time.
480          */
481         function buyTokens(address beneficiary) public payable whenNotPaused {
482                 require(beneficiary != 0x0);
483 
484                 uint256 weiAmount = msg.value;
485 
486                 // calculate token amount to be created
487                 uint256 purchasedTokens = weiAmount.div(rate);
488                 require(validPurchase(purchasedTokens));
489                 purchasedTokens = purchasedTokens.mul(currentBonusRate()).div(100);
490                 require(purchasedTokens != 0);
491 
492                 // update state
493                 weiRaised = weiRaised.add(weiAmount);
494                 purchasedTokensRaised = purchasedTokensRaised.add(purchasedTokens);
495 
496                 // Mint tokens for beneficiary
497                 token.mint(beneficiary, purchasedTokens);
498                 TokenPurchase(msg.sender, beneficiary, weiAmount, purchasedTokens);
499 
500                 mintTokensForFacilitators(purchasedTokens);
501 
502                 forwardFunds();
503         }
504 
505         /* Overrides RefundableCrowdsale#goalReached
506            since we count the goal in purchased tokens, instead of in Wei.
507            @return true if crowdsale has reached more funds than the minimum goal.
508         */
509         function goalReached() public constant returns (bool) {
510                 return purchasedTokensRaised >= goal;
511         }
512 
513         /**
514            Overrides CappedCrowdsale#hasEnded to add cap logic in tokens
515            @return true if crowdsale event has ended
516         */
517         function hasEnded() public constant returns (bool) {
518                 bool capReached = purchasedTokensRaised >= cap;
519                 return Crowdsale.hasEnded() || capReached;
520         }
521 
522         /**
523            replaces CappedCrowdsale#validPurchase to add extra cap logic in tokens
524            @param purchasedTokens Amount of tokens that were purchased (in the smallest, 1 * 10^(-18) denomination)
525            @return true if investors are allowed to purchase tokens at the moment.
526         */
527         function validPurchase(uint256 purchasedTokens) internal constant returns (bool) {
528                 /* bool withinCap = purchasedTokensRaised.add(purchasedTokens) <= cap; */
529                 /* return Crowdsale.validPurchase() && withinCap; */
530                 bool withinCap = purchasedTokensRaised.add(purchasedTokens) <= cap;
531                 return Crowdsale.validPurchase() && withinCap;
532         }
533 
534         /**
535            @dev Mints the tokens for the facilitating parties.
536 
537            @dev In total, (20/13) * `purchasedTokens` tokens are created.
538            @dev 13/13th of these are for the Beneficiary.
539            @dev 7/13th of these are minted for the Facilitators as follows:
540            @dev   1/13th -> Founders
541            @dev   2/13th -> Bounties
542            @dev   4/13th -> ZakemFans
543 
544            @dev Note that all result rational amounts are floored since the EVM only works with integer arithmetic.
545         */
546         function mintTokensForFacilitators(uint256 purchasedTokens) internal {
547                 // Mint tokens for ZakemFans and Founders
548                 uint256 fintechfans_tokens = purchasedTokens.mul(4).div(13);
549                 uint256 bounties_tokens = purchasedTokens.mul(2).div(13);
550                 uint256 founders_tokens = purchasedTokens.mul(1).div(13);
551                 token.mint(wallet, fintechfans_tokens);
552                 token.mint(bountiesWallet, bounties_tokens);
553                 token.mint(foundersWallet, founders_tokens);/* TODO Locked vault? */
554         }
555 
556         /**
557            @dev returns the current bonus rate. This is a call that can be done at any time.
558 
559            @return a fixed-size number that is the total percentage of tokens that will be created. (100 * the bonus ratio)
560 
561            @dev When < 2 million tokens purchased, this will be 125%, which is equivalent to a 20% discount
562            @dev When < 4 million tokens purchased, 118%, which is equivalent to a 15% discount.
563            @dev When < 6 million tokens purchased, 111%, which is equivalent to a 10% discount.
564            @dev When < 9 million tokens purchased, 105%, which is equivalent to a 5% discount.
565            @dev Otherwise, there is no bonus and the function returns 100%.
566         */
567         function currentBonusRate() public constant returns (uint) {
568                 if(purchasedTokensRaised < (2 * oneTwelfthOfCap)) return 125/*.25*/; // 20% discount
569                 if(purchasedTokensRaised < (4 * oneTwelfthOfCap)) return 118/*.1764705882352942*/; // 15% discount
570                 if(purchasedTokensRaised < (6 * oneTwelfthOfCap)) return 111/*.1111111111111112*/; // 10% discount
571                 if(purchasedTokensRaised < (9 * oneTwelfthOfCap)) return 105/*.0526315789473684*/; // 5% discount
572                 return 100;
573         }
574 }
575 
576 contract TheZakemFansCrowdsale is ZakemFansCrowdsale {
577     function TheZakemFansCrowdsale()
578         ZakemFansCrowdsale(
579             1511380200, // _startTime time (Solidity UNIX timestamp) from when it is allowed to buy FINC.
580             1511384400, // _endTime time (Solidity UNIX timestamp) until which it is allowed to buy FINC. (Should be larger than startTime)
581             2, // _rate Number of tokens created per ether. (Since Ether and ZakemCoin use the same number of decimal places, this can be read as direct conversion rate of Ether -> ZakemCoin.)
582             0xd5D29f18B8C2C7157B6BF38111C9318b9604BdED, // _wallet The wallet of ZakemFans itself, to which some of the facilitating tokens will be sent.
583             0x6B1964119841f3f5363D7EA08120642FE487410E, // _bountiesWallet The wallet used to pay out bounties, to which some of the facilitating tokens will be sent.
584             0x9a123fDd708eD0931Fb4938C5b2E2462B6D23390, // _foundersWallet The wallet used for the founders, to which some of the facilitating tokens will be sent.
585             1e16, // _goal The minimum goal (in 1 * 10^(-18) tokens) that the Crowdsale needs to reach.
586             12e16, // _cap The maximum cap (in 1 * 10^(-18) tokens) that the Crowdsale can reach.
587             0xaaC5b7048114d70b759E9EA17AFA4Ff969931a4a, // _token The address where the ZakemCoin contract was deployed prior to creating this contract.
588             0  // _purchasedTokensRaisedDuringPresale The amount (in 1 * 18^18 tokens) that was purchased during the presale.
589             )
590     {
591     }
592 }
593 
594 contract StandardToken is ERC20, BasicToken {
595 
596   mapping (address => mapping (address => uint256)) allowed;
597 
598 
599   /**
600    * @dev Transfer tokens from one address to another
601    * @param _from address The address which you want to send tokens from
602    * @param _to address The address which you want to transfer to
603    * @param _value uint256 the amount of tokens to be transferred
604    */
605   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
606     require(_to != address(0));
607 
608     uint256 _allowance = allowed[_from][msg.sender];
609 
610     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
611     // require (_value <= _allowance);
612 
613     balances[_from] = balances[_from].sub(_value);
614     balances[_to] = balances[_to].add(_value);
615     allowed[_from][msg.sender] = _allowance.sub(_value);
616     Transfer(_from, _to, _value);
617     return true;
618   }
619 
620   /**
621    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
622    *
623    * Beware that changing an allowance with this method brings the risk that someone may use both the old
624    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
625    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
626    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
627    * @param _spender The address which will spend the funds.
628    * @param _value The amount of tokens to be spent.
629    */
630   function approve(address _spender, uint256 _value) public returns (bool) {
631     allowed[msg.sender][_spender] = _value;
632     Approval(msg.sender, _spender, _value);
633     return true;
634   }
635 
636   /**
637    * @dev Function to check the amount of tokens that an owner allowed to a spender.
638    * @param _owner address The address which owns the funds.
639    * @param _spender address The address which will spend the funds.
640    * @return A uint256 specifying the amount of tokens still available for the spender.
641    */
642   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
643     return allowed[_owner][_spender];
644   }
645 
646   /**
647    * approve should be called when allowed[_spender] == 0. To increment
648    * allowed value is better to use this function to avoid 2 calls (and wait until
649    * the first transaction is mined)
650    * From MonolithDAO Token.sol
651    */
652   function increaseApproval (address _spender, uint _addedValue)
653     returns (bool success) {
654     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
655     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
656     return true;
657   }
658 
659   function decreaseApproval (address _spender, uint _subtractedValue)
660     returns (bool success) {
661     uint oldValue = allowed[msg.sender][_spender];
662     if (_subtractedValue > oldValue) {
663       allowed[msg.sender][_spender] = 0;
664     } else {
665       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
666     }
667     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
668     return true;
669   }
670 
671 }
672 
673 contract MintableToken is StandardToken, Ownable {
674   event Mint(address indexed to, uint256 amount);
675   event MintFinished();
676 
677   bool public mintingFinished = false;
678 
679 
680   modifier canMint() {
681     require(!mintingFinished);
682     _;
683   }
684 
685   /**
686    * @dev Function to mint tokens
687    * @param _to The address that will receive the minted tokens.
688    * @param _amount The amount of tokens to mint.
689    * @return A boolean that indicates if the operation was successful.
690    */
691   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
692     totalSupply = totalSupply.add(_amount);
693     balances[_to] = balances[_to].add(_amount);
694     Mint(_to, _amount);
695     Transfer(0x0, _to, _amount);
696     return true;
697   }
698 
699   /**
700    * @dev Function to stop minting new tokens.
701    * @return True if the operation was successful.
702    */
703   function finishMinting() onlyOwner public returns (bool) {
704     mintingFinished = true;
705     MintFinished();
706     return true;
707   }
708 }
709 
710 contract BurnableToken is StandardToken {
711 
712     event Burn(address indexed burner, uint256 value);
713 
714     /**
715      * @dev Burns a specific amount of tokens.
716      * @param _value The amount of token to be burned.
717      */
718     function burn(uint256 _value) public {
719         require(_value > 0);
720 
721         address burner = msg.sender;
722         balances[burner] = balances[burner].sub(_value);
723         totalSupply = totalSupply.sub(_value);
724         Burn(burner, _value);
725     }
726 }
727 
728 contract ApprovedBurnableToken is BurnableToken {
729 
730         /**
731            Sent when `burner` burns some `value` of `owners` tokens.
732         */
733         event BurnFrom(address indexed owner, // The address whose tokens were burned.
734                        address indexed burner, // The address that executed the `burnFrom` call
735                        uint256 value           // The amount of tokens that were burned.
736                 );
737 
738         /**
739            @dev Burns a specific amount of tokens of another account that `msg.sender`
740            was approved to burn tokens for using `approveBurn` earlier.
741            @param _owner The address to burn tokens from.
742            @param _value The amount of token to be burned.
743         */
744         function burnFrom(address _owner, uint256 _value) public {
745                 require(_value > 0);
746                 require(_value <= balances[_owner]);
747                 require(_value <= allowed[_owner][msg.sender]);
748                 // no need to require value <= totalSupply, since that would imply the
749                 // sender's balance is greater than the totalSupply, which *should* be an assertion failure
750 
751                 address burner = msg.sender;
752                 balances[_owner] = balances[_owner].sub(_value);
753                 allowed[_owner][burner] = allowed[_owner][burner].sub(_value);
754                 totalSupply = totalSupply.sub(_value);
755 
756                 BurnFrom(_owner, burner, _value);
757                 Burn(_owner, _value);
758         }
759 }
760 
761 contract UnlockedAfterMintingToken is MintableToken {
762 
763     /**
764        Ensures certain calls can only be made when minting is finished.
765 
766        The calls that are restricted are any calls that allow direct or indirect transferral of funds.
767      */
768     modifier whenMintingFinished() {
769         require(mintingFinished);
770         _;
771     }
772 
773     function transfer(address _to, uint256 _value) public whenMintingFinished returns (bool) {
774         return super.transfer(_to, _value);
775     }
776 
777     /**
778       @dev Transfer tokens from one address to another
779       @param _from address The address which you want to send tokens from
780       @param _to address The address which you want to transfer to
781       @param _value uint256 the amount of tokens to be transferred
782      */
783     function transferFrom(address _from, address _to, uint256 _value) public whenMintingFinished returns (bool) {
784         return super.transferFrom(_from, _to, _value);
785     }
786 
787     /**
788       @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
789       @dev NOTE: This call is considered deprecated, and only included for proper compliance with ERC20.
790       @dev Rather than use this call, use `increaseApproval` and `decreaseApproval` instead, whenever possible.
791       @dev The reason for this, is that using `approve` directly when your allowance is nonzero results in an exploitable situation:
792       @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
793 
794       @param _spender The address which will spend the funds.
795       @param _value The amount of tokens to be spent.
796      */
797     function approve(address _spender, uint256 _value) public whenMintingFinished returns (bool) {
798         return super.approve(_spender, _value);
799     }
800 
801     /**
802       @dev approve should only be called when allowed[_spender] == 0. To alter the
803       @dev allowed value it is better to use this function, because it is safer.
804       @dev (And making `approve` safe manually would require making two calls made in separate blocks.)
805 
806       This method was adapted from the one in use by the MonolithDAO Token.
807      */
808     function increaseApproval(address _spender, uint _addedValue) public whenMintingFinished returns (bool success) {
809         return super.increaseApproval(_spender, _addedValue);
810     }
811 
812     /**
813        @dev approve should only be called when allowed[_spender] == 0. To alter the
814        @dev allowed value it is better to use this function, because it is safer.
815        @dev (And making `approve` safe manually would require making two calls made in separate blocks.)
816 
817        This method was adapted from the one in use by the MonolithDAO Token.
818     */
819     function decreaseApproval(address _spender, uint _subtractedValue) public whenMintingFinished returns (bool success) {
820         return super.decreaseApproval(_spender, _subtractedValue);
821     }
822 
823     // TODO Prevent burning?
824 }
825 
826 contract ZakemCoin is UnlockedAfterMintingToken, ApprovedBurnableToken {
827         /**
828            @dev We do not expect this to change ever after deployment,
829            @dev but it is a way to identify different versions of the ZakemCoin during development.
830         */
831         uint8 public constant contractVersion = 1;
832 
833         /**
834            @dev The name of the ZakemCoin, specified as indicated in ERC20.
835          */
836         string public constant name = "ZakemCoin";
837 
838         /**
839            @dev The abbreviation FINC, specified as indicated in ERC20.
840         */
841         string public constant symbol = "FINC";
842 
843         /**
844            @dev The smallest denomination of the ZakemCoin is 1 * 10^(-18) FINC. `decimals` is specified as indicated in ERC20.
845         */
846         uint8 public constant decimals = 18;
847 
848         // TODO extractToken function to allow people to retrieve token-funds sent here by mistake?
849 
850         // TODO ERC223-interface
851 }