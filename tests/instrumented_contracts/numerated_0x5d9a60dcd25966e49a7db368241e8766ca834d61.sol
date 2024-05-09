1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract BasicToken is ERC20Basic {
37   using SafeMath for uint256;
38 
39   mapping(address => uint256) balances;
40 
41   /**
42   * @dev transfer token for a specified address
43   * @param _to The address to transfer to.
44   * @param _value The amount to be transferred.
45   */
46   function transfer(address _to, uint256 _value) public returns (bool) {
47     require(_to != address(0));
48 
49     // SafeMath.sub will throw if there is not enough balance.
50     balances[msg.sender] = balances[msg.sender].sub(_value);
51     balances[_to] = balances[_to].add(_value);
52     Transfer(msg.sender, _to, _value);
53     return true;
54   }
55 
56   /**
57   * @dev Gets the balance of the specified address.
58   * @param _owner The address to query the the balance of.
59   * @return An uint256 representing the amount owned by the passed address.
60   */
61   function balanceOf(address _owner) public constant returns (uint256 balance) {
62     return balances[_owner];
63   }
64 
65 }
66 
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public constant returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76   mapping (address => mapping (address => uint256)) allowed;
77 
78 
79   /**
80    * @dev Transfer tokens from one address to another
81    * @param _from address The address which you want to send tokens from
82    * @param _to address The address which you want to transfer to
83    * @param _value uint256 the amount of tokens to be transferred
84    */
85   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87 
88     uint256 _allowance = allowed[_from][msg.sender];
89 
90     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
91     // require (_value <= _allowance);
92 
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = _allowance.sub(_value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   /**
101    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
102    *
103    * Beware that changing an allowance with this method brings the risk that someone may use both the old
104    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
105    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
106    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107    * @param _spender The address which will spend the funds.
108    * @param _value The amount of tokens to be spent.
109    */
110   function approve(address _spender, uint256 _value) public returns (bool) {
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Function to check the amount of tokens that an owner allowed to a spender.
118    * @param _owner address The address which owns the funds.
119    * @param _spender address The address which will spend the funds.
120    * @return A uint256 specifying the amount of tokens still available for the spender.
121    */
122   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
123     return allowed[_owner][_spender];
124   }
125 
126   /**
127    * approve should be called when allowed[_spender] == 0. To increment
128    * allowed value is better to use this function to avoid 2 calls (and wait until
129    * the first transaction is mined)
130    * From MonolithDAO Token.sol
131    */
132   function increaseApproval (address _spender, uint _addedValue)
133     returns (bool success) {
134     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
135     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136     return true;
137   }
138 
139   function decreaseApproval (address _spender, uint _subtractedValue)
140     returns (bool success) {
141     uint oldValue = allowed[msg.sender][_spender];
142     if (_subtractedValue > oldValue) {
143       allowed[msg.sender][_spender] = 0;
144     } else {
145       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146     }
147     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 
151 }
152 
153 contract BurnableToken is StandardToken {
154 
155     event Burn(address indexed burner, uint256 value);
156 
157     /**
158      * @dev Burns a specific amount of tokens.
159      * @param _value The amount of token to be burned.
160      */
161     function burn(uint256 _value) public {
162         require(_value > 0);
163 
164         address burner = msg.sender;
165         balances[burner] = balances[burner].sub(_value);
166         totalSupply = totalSupply.sub(_value);
167         Burn(burner, _value);
168     }
169 }
170 
171 contract ApprovedBurnableToken is BurnableToken {
172 
173         /**
174            Sent when `burner` burns some `value` of `owners` tokens.
175         */
176         event BurnFrom(address indexed owner, // The address whose tokens were burned.
177                        address indexed burner, // The address that executed the `burnFrom` call
178                        uint256 value           // The amount of tokens that were burned.
179                 );
180 
181         /**
182            @dev Burns a specific amount of tokens of another account that `msg.sender`
183            was approved to burn tokens for using `approveBurn` earlier.
184            @param _owner The address to burn tokens from.
185            @param _value The amount of token to be burned.
186         */
187         function burnFrom(address _owner, uint256 _value) public {
188                 require(_value > 0);
189                 require(_value <= balances[_owner]);
190                 require(_value <= allowed[_owner][msg.sender]);
191                 // no need to require value <= totalSupply, since that would imply the
192                 // sender's balance is greater than the totalSupply, which *should* be an assertion failure
193 
194                 address burner = msg.sender;
195                 balances[_owner] = balances[_owner].sub(_value);
196                 allowed[_owner][burner] = allowed[_owner][burner].sub(_value);
197                 totalSupply = totalSupply.sub(_value);
198 
199                 BurnFrom(_owner, burner, _value);
200                 Burn(_owner, _value);
201         }
202 }
203 
204 contract Crowdsale {
205   using SafeMath for uint256;
206 
207   // The token being sold
208   MintableToken public token;
209 
210   // start and end timestamps where investments are allowed (both inclusive)
211   uint256 public startTime;
212   uint256 public endTime;
213 
214   // address where funds are collected
215   address public wallet;
216 
217   // how many token units a buyer gets per wei
218   uint256 public rate;
219 
220   // amount of raised money in wei
221   uint256 public weiRaised;
222 
223   /**
224    * event for token purchase logging
225    * @param purchaser who paid for the tokens
226    * @param beneficiary who got the tokens
227    * @param value weis paid for purchase
228    * @param amount amount of tokens purchased
229    */
230   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
231 
232 
233   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
234     require(_startTime >= now);
235     require(_endTime >= _startTime);
236     require(_rate > 0);
237     require(_wallet != 0x0);
238 
239     token = createTokenContract();
240     startTime = _startTime;
241     endTime = _endTime;
242     rate = _rate;
243     wallet = _wallet;
244   }
245 
246   // creates the token to be sold.
247   // override this method to have crowdsale of a specific mintable token.
248   function createTokenContract() internal returns (MintableToken) {
249     return new MintableToken();
250   }
251 
252 
253   // fallback function can be used to buy tokens
254   function () payable {
255     buyTokens(msg.sender);
256   }
257 
258   // low level token purchase function
259   function buyTokens(address beneficiary) public payable {
260     require(beneficiary != 0x0);
261     require(validPurchase());
262 
263     uint256 weiAmount = msg.value;
264 
265     // calculate token amount to be created
266     uint256 tokens = weiAmount.mul(rate);
267 
268     // update state
269     weiRaised = weiRaised.add(weiAmount);
270 
271     token.mint(beneficiary, tokens);
272     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
273 
274     forwardFunds();
275   }
276 
277   // send ether to the fund collection wallet
278   // override to create custom fund forwarding mechanisms
279   function forwardFunds() internal {
280     wallet.transfer(msg.value);
281   }
282 
283   // @return true if the transaction can buy tokens
284   function validPurchase() internal constant returns (bool) {
285     bool withinPeriod = now >= startTime && now <= endTime;
286     bool nonZeroPurchase = msg.value != 0;
287     return withinPeriod && nonZeroPurchase;
288   }
289 
290   // @return true if crowdsale event has ended
291   function hasEnded() public constant returns (bool) {
292     return now > endTime;
293   }
294 
295 
296 }
297 
298 contract CappedCrowdsale is Crowdsale {
299   using SafeMath for uint256;
300 
301   uint256 public cap;
302 
303   function CappedCrowdsale(uint256 _cap) {
304     require(_cap > 0);
305     cap = _cap;
306   }
307 
308   // overriding Crowdsale#validPurchase to add extra cap logic
309   // @return true if investors can buy at the moment
310   function validPurchase() internal constant returns (bool) {
311     bool withinCap = weiRaised.add(msg.value) <= cap;
312     return super.validPurchase() && withinCap;
313   }
314 
315   // overriding Crowdsale#hasEnded to add cap logic
316   // @return true if crowdsale event has ended
317   function hasEnded() public constant returns (bool) {
318     bool capReached = weiRaised >= cap;
319     return super.hasEnded() || capReached;
320   }
321 
322 }
323 
324 contract Ownable {
325   address public owner;
326 
327 
328   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
329 
330 
331   /**
332    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
333    * account.
334    */
335   function Ownable() {
336     owner = msg.sender;
337   }
338 
339 
340   /**
341    * @dev Throws if called by any account other than the owner.
342    */
343   modifier onlyOwner() {
344     require(msg.sender == owner);
345     _;
346   }
347 
348 
349   /**
350    * @dev Allows the current owner to transfer control of the contract to a newOwner.
351    * @param newOwner The address to transfer ownership to.
352    */
353   function transferOwnership(address newOwner) onlyOwner public {
354     require(newOwner != address(0));
355     OwnershipTransferred(owner, newOwner);
356     owner = newOwner;
357   }
358 
359 }
360 
361 contract FinalizableCrowdsale is Crowdsale, Ownable {
362   using SafeMath for uint256;
363 
364   bool public isFinalized = false;
365 
366   event Finalized();
367 
368   /**
369    * @dev Must be called after crowdsale ends, to do some extra finalization
370    * work. Calls the contract's finalization function.
371    */
372   function finalize() onlyOwner public {
373     require(!isFinalized);
374     require(hasEnded());
375 
376     finalization();
377     Finalized();
378 
379     isFinalized = true;
380   }
381 
382   /**
383    * @dev Can be overridden to add finalization logic. The overriding function
384    * should call super.finalization() to ensure the chain of finalization is
385    * executed entirely.
386    */
387   function finalization() internal {
388   }
389 }
390 
391 contract Pausable is Ownable {
392   event Pause();
393   event Unpause();
394 
395   bool public paused = false;
396 
397 
398   /**
399    * @dev Modifier to make a function callable only when the contract is not paused.
400    */
401   modifier whenNotPaused() {
402     require(!paused);
403     _;
404   }
405 
406   /**
407    * @dev Modifier to make a function callable only when the contract is paused.
408    */
409   modifier whenPaused() {
410     require(paused);
411     _;
412   }
413 
414   /**
415    * @dev called by the owner to pause, triggers stopped state
416    */
417   function pause() onlyOwner whenNotPaused public {
418     paused = true;
419     Pause();
420   }
421 
422   /**
423    * @dev called by the owner to unpause, returns to normal state
424    */
425   function unpause() onlyOwner whenPaused public {
426     paused = false;
427     Unpause();
428   }
429 }
430 
431 contract MintableToken is StandardToken, Ownable {
432   event Mint(address indexed to, uint256 amount);
433   event MintFinished();
434 
435   bool public mintingFinished = false;
436 
437 
438   modifier canMint() {
439     require(!mintingFinished);
440     _;
441   }
442 
443   /**
444    * @dev Function to mint tokens
445    * @param _to The address that will receive the minted tokens.
446    * @param _amount The amount of tokens to mint.
447    * @return A boolean that indicates if the operation was successful.
448    */
449   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
450     totalSupply = totalSupply.add(_amount);
451     balances[_to] = balances[_to].add(_amount);
452     Mint(_to, _amount);
453     Transfer(0x0, _to, _amount);
454     return true;
455   }
456 
457   /**
458    * @dev Function to stop minting new tokens.
459    * @return True if the operation was successful.
460    */
461   function finishMinting() onlyOwner public returns (bool) {
462     mintingFinished = true;
463     MintFinished();
464     return true;
465   }
466 }
467 
468 contract UnlockedAfterMintingToken is MintableToken {
469 
470     /**
471        Ensures certain calls can only be made when minting is finished.
472 
473        The calls that are restricted are any calls that allow direct or indirect transferral of funds.
474      */
475     modifier whenMintingFinished() {
476         require(mintingFinished);
477         _;
478     }
479 
480     function transfer(address _to, uint256 _value) public whenMintingFinished returns (bool) {
481         return super.transfer(_to, _value);
482     }
483 
484     /**
485       @dev Transfer tokens from one address to another
486       @param _from address The address which you want to send tokens from
487       @param _to address The address which you want to transfer to
488       @param _value uint256 the amount of tokens to be transferred
489      */
490     function transferFrom(address _from, address _to, uint256 _value) public whenMintingFinished returns (bool) {
491         return super.transferFrom(_from, _to, _value);
492     }
493 
494     /**
495       @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
496       @dev NOTE: This call is considered deprecated, and only included for proper compliance with ERC20.
497       @dev Rather than use this call, use `increaseApproval` and `decreaseApproval` instead, whenever possible.
498       @dev The reason for this, is that using `approve` directly when your allowance is nonzero results in an exploitable situation:
499       @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
500 
501       @param _spender The address which will spend the funds.
502       @param _value The amount of tokens to be spent.
503      */
504     function approve(address _spender, uint256 _value) public whenMintingFinished returns (bool) {
505         return super.approve(_spender, _value);
506     }
507 
508     /**
509       @dev approve should only be called when allowed[_spender] == 0. To alter the
510       @dev allowed value it is better to use this function, because it is safer.
511       @dev (And making `approve` safe manually would require making two calls made in separate blocks.)
512 
513       This method was adapted from the one in use by the MonolithDAO Token.
514      */
515     function increaseApproval(address _spender, uint _addedValue) public whenMintingFinished returns (bool success) {
516         return super.increaseApproval(_spender, _addedValue);
517     }
518 
519     /**
520        @dev approve should only be called when allowed[_spender] == 0. To alter the
521        @dev allowed value it is better to use this function, because it is safer.
522        @dev (And making `approve` safe manually would require making two calls made in separate blocks.)
523 
524        This method was adapted from the one in use by the MonolithDAO Token.
525     */
526     function decreaseApproval(address _spender, uint _subtractedValue) public whenMintingFinished returns (bool success) {
527         return super.decreaseApproval(_spender, _subtractedValue);
528     }
529 
530     // TODO Prevent burning?
531 }
532 
533 contract ZakemCoin is UnlockedAfterMintingToken, ApprovedBurnableToken {
534         /**
535            @dev We do not expect this to change ever after deployment,
536            @dev but it is a way to identify different versions of the ZakemCoin during development.
537         */
538         uint8 public constant contractVersion = 1;
539 
540         /**
541            @dev The name of the ZakemCoin, specified as indicated in ERC20.
542          */
543         string public constant name = "ZakemCoin";
544 
545         /**
546            @dev The abbreviation FINC, specified as indicated in ERC20.
547         */
548         string public constant symbol = "FINC";
549 
550         /**
551            @dev The smallest denomination of the ZakemCoin is 1 * 10^(-18) FINC. `decimals` is specified as indicated in ERC20.
552         */
553         uint8 public constant decimals = 18;
554 
555         // TODO extractToken function to allow people to retrieve token-funds sent here by mistake?
556 
557         // TODO ERC223-interface
558 }
559 
560 contract RefundVault is Ownable {
561   using SafeMath for uint256;
562 
563   enum State { Active, Refunding, Closed }
564 
565   mapping (address => uint256) public deposited;
566   address public wallet;
567   State public state;
568 
569   event Closed();
570   event RefundsEnabled();
571   event Refunded(address indexed beneficiary, uint256 weiAmount);
572 
573   function RefundVault(address _wallet) {
574     require(_wallet != 0x0);
575     wallet = _wallet;
576     state = State.Active;
577   }
578 
579   function deposit(address investor) onlyOwner public payable {
580     require(state == State.Active);
581     deposited[investor] = deposited[investor].add(msg.value);
582   }
583 
584   function close() onlyOwner public {
585     require(state == State.Active);
586     state = State.Closed;
587     Closed();
588     wallet.transfer(this.balance);
589   }
590 
591   function enableRefunds() onlyOwner public {
592     require(state == State.Active);
593     state = State.Refunding;
594     RefundsEnabled();
595   }
596 
597   function refund(address investor) public {
598     require(state == State.Refunding);
599     uint256 depositedValue = deposited[investor];
600     deposited[investor] = 0;
601     investor.transfer(depositedValue);
602     Refunded(investor, depositedValue);
603   }
604 }
605 
606 contract RefundableCrowdsale is FinalizableCrowdsale {
607   using SafeMath for uint256;
608 
609   // minimum amount of funds to be raised in weis
610   uint256 public goal;
611 
612   // refund vault used to hold funds while crowdsale is running
613   RefundVault public vault;
614 
615   function RefundableCrowdsale(uint256 _goal) {
616     require(_goal > 0);
617     vault = new RefundVault(wallet);
618     goal = _goal;
619   }
620 
621   // We're overriding the fund forwarding from Crowdsale.
622   // In addition to sending the funds, we want to call
623   // the RefundVault deposit function
624   function forwardFunds() internal {
625     vault.deposit.value(msg.value)(msg.sender);
626   }
627 
628   // if crowdsale is unsuccessful, investors can claim refunds here
629   function claimRefund() public {
630     require(isFinalized);
631     require(!goalReached());
632 
633     vault.refund(msg.sender);
634   }
635 
636   // vault finalization task, called when owner calls finalize()
637   function finalization() internal {
638     if (goalReached()) {
639       vault.close();
640     } else {
641       vault.enableRefunds();
642     }
643 
644     super.finalization();
645   }
646 
647   function goalReached() public constant returns (bool) {
648     return weiRaised >= goal;
649   }
650 
651 }
652 
653 contract ZakemFansCrowdsale is Pausable, RefundableCrowdsale, CappedCrowdsale {
654         /**
655            Address of the wallet of the founders.
656            In this wallet, part of the facilitating tokens will be stored, and they will be locked for 24 months.
657          */
658         address public foundersWallet;
659 
660         /**
661            Address of the wallet used to pay out bounties.
662            In this wallet, part of the facilitating tokens will be stored.
663          */
664         address public bountiesWallet;
665 
666         /**
667            Keeps track of how many tokens have been raised so far.
668            Used to know when `goal` and `cap` have been reached.
669          */
670         uint256 public purchasedTokensRaised;
671 
672         /**
673            The amount of tokens that were sold in the Presale before the Crowdsale.
674            Given during construction of this contract.
675          */
676         uint256 public purchasedTokensRaisedDuringPresale;
677 
678         /**
679            Helper property to ensure that 1/12 of `cap` does not need to be re-calculated every time.
680          */
681         uint256 oneTwelfthOfCap;
682 
683         /**
684            @dev Constructor of the ZakemFansCrowdsale contract
685 
686            @param _startTime time (Solidity UNIX timestamp) from when it is allowed to buy FINC.
687            @param _endTime time (Solidity UNIX timestamp) until which it is allowed to buy FINC. (Should be larger than startTime)
688            @param _rate Number of tokens created per ether. (Since Ether and ZakemCoin use the same number of decimal places, this can be read as direct conversion rate of Ether -> ZakemCoin.)
689            @param _wallet The wallet of ZakemFans itself, to which some of the facilitating tokens will be sent.
690            @param _bountiesWallet The wallet used to pay out bounties, to which some of the facilitating tokens will be sent.
691            @param _foundersWallet The wallet used for the founders, to which some of the facilitating tokens will be sent.
692            @param _goal The minimum goal (in 1 * 10^(-18) tokens) that the Crowdsale needs to reach.
693            @param _cap The maximum cap (in 1 * 10^(-18) tokens) that the Crowdsale can reach.
694            @param _token The address where the ZakemCoin contract was deployed prior to creating this contract.
695            @param _purchasedTokensRaisedDuringPresale The amount (in 1 * 18^18 tokens) that was purchased during the presale.
696          */
697         function ZakemFansCrowdsale (
698                 uint256 _startTime,
699                 uint256 _endTime,
700                 uint256 _rate,
701                 address _wallet,
702                 address _bountiesWallet,
703                 address _foundersWallet,
704                 uint256 _goal,
705                 uint256 _cap,
706                 address _token,
707                 uint256 _purchasedTokensRaisedDuringPresale
708                 )
709                 Crowdsale(_startTime, _endTime, _rate, _wallet)
710                 RefundableCrowdsale(_goal)
711                 CappedCrowdsale(_cap)
712         {
713                 require(_goal < _cap);
714 
715                 bountiesWallet = _bountiesWallet;
716                 foundersWallet = _foundersWallet;
717                 token = ZakemCoin(_token);
718                 weiRaised = 0;
719 
720                 purchasedTokensRaisedDuringPresale = _purchasedTokensRaisedDuringPresale;
721                 purchasedTokensRaised = purchasedTokensRaisedDuringPresale;
722 
723                 oneTwelfthOfCap = _cap / 12;
724         }
725 
726         /*
727           Overrides Crowdsale.createTokenContract,
728           because the ZakemFansCrowdsale uses an already-deployed
729           token, so there is no need to internally deploy a contract.
730         */
731         function createTokenContract() internal returns (MintableToken) {
732                 return MintableToken(0x0);
733         }
734 
735         /*
736          * Overrides version of Crowdsale.buyTokens because:
737          * - The Wei->FFC rate depends on how many tokens have already been sold (see `currentBonusRate()`).
738          * - Also mint tokens sent to ZakemFans and the Founders at the same time.
739          */
740         function buyTokens(address beneficiary) public payable whenNotPaused {
741                 require(beneficiary != 0x0);
742 
743                 uint256 weiAmount = msg.value;
744 
745                 // calculate token amount to be created
746                 uint256 purchasedTokens = weiAmount.div(rate);
747                 require(validPurchase(purchasedTokens));
748                 purchasedTokens = purchasedTokens.mul(currentBonusRate()).div(100);
749                 require(purchasedTokens != 0);
750 
751                 // update state
752                 weiRaised = weiRaised.add(weiAmount);
753                 purchasedTokensRaised = purchasedTokensRaised.add(purchasedTokens);
754 
755                 // Mint tokens for beneficiary
756                 token.mint(beneficiary, purchasedTokens);
757                 TokenPurchase(msg.sender, beneficiary, weiAmount, purchasedTokens);
758 
759                 mintTokensForFacilitators(purchasedTokens);
760 
761                 forwardFunds();
762         }
763 
764         /* Overrides RefundableCrowdsale#goalReached
765            since we count the goal in purchased tokens, instead of in Wei.
766            @return true if crowdsale has reached more funds than the minimum goal.
767         */
768         function goalReached() public constant returns (bool) {
769                 return purchasedTokensRaised >= goal;
770         }
771 
772         /**
773            Overrides CappedCrowdsale#hasEnded to add cap logic in tokens
774            @return true if crowdsale event has ended
775         */
776         function hasEnded() public constant returns (bool) {
777                 bool capReached = purchasedTokensRaised >= cap;
778                 return Crowdsale.hasEnded() || capReached;
779         }
780 
781         /**
782            replaces CappedCrowdsale#validPurchase to add extra cap logic in tokens
783            @param purchasedTokens Amount of tokens that were purchased (in the smallest, 1 * 10^(-18) denomination)
784            @return true if investors are allowed to purchase tokens at the moment.
785         */
786         function validPurchase(uint256 purchasedTokens) internal constant returns (bool) {
787                 /* bool withinCap = purchasedTokensRaised.add(purchasedTokens) <= cap; */
788                 /* return Crowdsale.validPurchase() && withinCap; */
789                 bool withinCap = purchasedTokensRaised.add(purchasedTokens) <= cap;
790                 return Crowdsale.validPurchase() && withinCap;
791         }
792 
793         /**
794            @dev Mints the tokens for the facilitating parties.
795 
796            @dev In total, (20/13) * `purchasedTokens` tokens are created.
797            @dev 13/13th of these are for the Beneficiary.
798            @dev 7/13th of these are minted for the Facilitators as follows:
799            @dev   1/13th -> Founders
800            @dev   2/13th -> Bounties
801            @dev   4/13th -> ZakemFans
802 
803            @dev Note that all result rational amounts are floored since the EVM only works with integer arithmetic.
804         */
805         function mintTokensForFacilitators(uint256 purchasedTokens) internal {
806                 // Mint tokens for ZakemFans and Founders
807                 uint256 fintechfans_tokens = purchasedTokens.mul(4).div(13);
808                 uint256 bounties_tokens = purchasedTokens.mul(2).div(13);
809                 uint256 founders_tokens = purchasedTokens.mul(1).div(13);
810                 token.mint(wallet, fintechfans_tokens);
811                 token.mint(bountiesWallet, bounties_tokens);
812                 token.mint(foundersWallet, founders_tokens);/* TODO Locked vault? */
813         }
814 
815         /**
816            @dev returns the current bonus rate. This is a call that can be done at any time.
817 
818            @return a fixed-size number that is the total percentage of tokens that will be created. (100 * the bonus ratio)
819 
820            @dev When < 2 million tokens purchased, this will be 125%, which is equivalent to a 20% discount
821            @dev When < 4 million tokens purchased, 118%, which is equivalent to a 15% discount.
822            @dev When < 6 million tokens purchased, 111%, which is equivalent to a 10% discount.
823            @dev When < 9 million tokens purchased, 105%, which is equivalent to a 5% discount.
824            @dev Otherwise, there is no bonus and the function returns 100%.
825         */
826         function currentBonusRate() public constant returns (uint) {
827                 if(purchasedTokensRaised < (2 * oneTwelfthOfCap)) return 125/*.25*/; // 20% discount
828                 if(purchasedTokensRaised < (4 * oneTwelfthOfCap)) return 118/*.1764705882352942*/; // 15% discount
829                 if(purchasedTokensRaised < (6 * oneTwelfthOfCap)) return 111/*.1111111111111112*/; // 10% discount
830                 if(purchasedTokensRaised < (9 * oneTwelfthOfCap)) return 105/*.0526315789473684*/; // 5% discount
831                 return 100;
832         }
833 }
834 
835 contract TheZakemFansCrowdsale is ZakemFansCrowdsale {
836     function TheZakemFansCrowdsale()
837         ZakemFansCrowdsale(
838             1511433000, // _startTime time (Solidity UNIX timestamp) from when it is allowed to buy FINC.
839             1511445600, // _endTime time (Solidity UNIX timestamp) until which it is allowed to buy FINC. (Should be larger than startTime)
840             3890, // _rate Number of tokens created per ether. (Since Ether and ZakemCoin use the same number of decimal places, this can be read as direct conversion rate of Ether -> ZakemCoin.)
841             0x99A5450C9019Cde36b4aaFf9b232D0bc16253C95, // _wallet The wallet of ZakemFans itself, to which some of the facilitating tokens will be sent.
842             0x88921f514699906AD47D11F9c5fDbb8B00569484, // _bountiesWallet The wallet used to pay out bounties, to which some of the facilitating tokens will be sent.
843             0x0C669E325CeB58D8a436dc3466D4DFaC9d5Eb2F0, // _foundersWallet The wallet used for the founders, to which some of the facilitating tokens will be sent.
844             39800000000000000, // _goal The minimum goal (in 1 * 10^(-18) tokens) that the Crowdsale needs to reach.
845             398000000000000000, // _cap The maximum cap (in 1 * 10^(-18) tokens) that the Crowdsale can reach.
846             0x145ea59782c0468510459f9219e863555b1868a5, // _token The address where the ZakemCoin contract was deployed prior to creating this contract.
847             0  // _purchasedTokensRaisedDuringPresale The amount (in 1 * 18^18 tokens) that was purchased during the presale.
848             )
849     {
850     }
851 }