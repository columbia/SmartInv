1 pragma solidity 0.4.20;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44   uint256 public totalSupply;
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67     require(_value <= balances[msg.sender]);
68 
69     // SafeMath.sub will throw if there is not enough balance.
70     balances[msg.sender] = balances[msg.sender].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     Transfer(msg.sender, _to, _value);
73     return true;
74   }
75 
76   /**
77   * @dev Gets the balance of the specified address.
78   * @param _owner The address to query the the balance of.
79   * @return An uint256 representing the amount owned by the passed address.
80   */
81   function balanceOf(address _owner) public view returns (uint256 balance) {
82     return balances[_owner];
83   }
84 
85 }
86 
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[_from]);
121     require(_value <= allowed[_from][msg.sender]);
122 
123     balances[_from] = balances[_from].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    *
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Function to check the amount of tokens that an owner allowed to a spender.
148    * @param _owner address The address which owns the funds.
149    * @param _spender address The address which will spend the funds.
150    * @return A uint256 specifying the amount of tokens still available for the spender.
151    */
152   function allowance(address _owner, address _spender) public view returns (uint256) {
153     return allowed[_owner][_spender];
154   }
155 
156   /**
157    * @dev Increase the amount of tokens that an owner allowed to a spender.
158    *
159    * approve should be called when allowed[_spender] == 0. To increment
160    * allowed value is better to use this function to avoid 2 calls (and wait until
161    * the first transaction is mined)
162    * From MonolithDAO Token.sol
163    * @param _spender The address which will spend the funds.
164    * @param _addedValue The amount of tokens to increase the allowance by.
165    */
166   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   /**
173    * @dev Decrease the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To decrement
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _subtractedValue The amount of tokens to decrease the allowance by.
181    */
182   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
183     uint oldValue = allowed[msg.sender][_spender];
184     if (_subtractedValue > oldValue) {
185       allowed[msg.sender][_spender] = 0;
186     } else {
187       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
188     }
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193 }
194 
195 
196 contract LongevityToken is StandardToken {
197     string public name = "Longevity";
198     string public symbol = "LTY";
199     uint8 public decimals = 2;
200     uint256 public cap = 2**256 - 1; // maximum possible uint256. Decreased on finalization
201     bool public mintingFinished = false;
202     mapping (address => bool) owners;
203     mapping (address => bool) minters;
204     // tap to limit mint speed
205     struct Tap {
206         uint256 startTime; // reference time point to start measuring
207         uint256 tokensIssued; // how much tokens issued from startTime
208         uint256 mintSpeed; // token fractions per second
209     }
210     Tap public mintTap;
211     bool public capFinalized = false;
212 
213     event Mint(address indexed to, uint256 amount);
214     event MintFinished();
215     event OwnerAdded(address indexed newOwner);
216     event OwnerRemoved(address indexed removedOwner);
217     event MinterAdded(address indexed newMinter);
218     event MinterRemoved(address indexed removedMinter);
219     event Burn(address indexed burner, uint256 value);
220     event MintTapSet(uint256 startTime, uint256 mintSpeed);
221     event SetCap(uint256 currectTotalSupply, uint256 cap);
222 
223     function LongevityToken() public {
224         owners[msg.sender] = true;
225     }
226 
227     /**
228      * @dev Function to mint tokens
229      * @param _to The address that will receive the minted tokens.
230      * @param _amount The amount of tokens to mint.
231      * @return A boolean that indicates if the operation was successful.
232      */
233     function mint(address _to, uint256 _amount) onlyMinter public returns (bool) {
234         require(!mintingFinished);
235         require(totalSupply.add(_amount) <= cap);
236         passThroughTap(_amount);
237         totalSupply = totalSupply.add(_amount);
238         balances[_to] = balances[_to].add(_amount);
239         Mint(_to, _amount);
240         Transfer(address(0), _to, _amount);
241         return true;
242     }
243 
244     /**
245      * @dev Function to stop minting new tokens.
246      * @return True if the operation was successful.
247      */
248     function finishMinting() onlyOwner public returns (bool) {
249         require(!mintingFinished);
250         mintingFinished = true;
251         MintFinished();
252         return true;
253     }
254 
255     /**
256      * @dev Burns a specific amount of tokens.
257      * @param _value The amount of token to be burned.
258      */
259     function burn(uint256 _value) public {
260         require(_value <= balances[msg.sender]);
261         // no need to require value <= totalSupply, since that would imply the
262         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
263 
264         address burner = msg.sender;
265         balances[burner] = balances[burner].sub(_value);
266         totalSupply = totalSupply.sub(_value);
267         Burn(burner, _value);
268     }
269 
270     /**
271      * @dev Adds administrative role to address
272      * @param _address The address that will get administrative privileges
273      */
274     function addOwner(address _address) onlyOwner public {
275         owners[_address] = true;
276         OwnerAdded(_address);
277     }
278 
279     /**
280      * @dev Removes administrative role from address
281      * @param _address The address to remove administrative privileges from
282      */
283     function delOwner(address _address) onlyOwner public {
284         owners[_address] = false;
285         OwnerRemoved(_address);
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(owners[msg.sender]);
293         _;
294     }
295 
296     /**
297      * @dev Adds minter role to address (able to create new tokens)
298      * @param _address The address that will get minter privileges
299      */
300     function addMinter(address _address) onlyOwner public {
301         minters[_address] = true;
302         MinterAdded(_address);
303     }
304 
305     /**
306      * @dev Removes minter role from address
307      * @param _address The address to remove minter privileges
308      */
309     function delMinter(address _address) onlyOwner public {
310         minters[_address] = false;
311         MinterRemoved(_address);
312     }
313 
314     /**
315      * @dev Throws if called by any account other than the minter.
316      */
317     modifier onlyMinter() {
318         require(minters[msg.sender]);
319         _;
320     }
321 
322     /**
323      * @dev passThroughTap allows minting tokens within the defined speed limit.
324      * Throws if requested more than allowed.
325      */
326     function passThroughTap(uint256 _tokensRequested) internal {
327         require(_tokensRequested <= getTapRemaining());
328         mintTap.tokensIssued = mintTap.tokensIssued.add(_tokensRequested);
329     }
330 
331     /**
332      * @dev Returns remaining amount of tokens allowed at the moment
333      */
334     function getTapRemaining() public view returns (uint256) {
335         uint256 tapTime = now.sub(mintTap.startTime).add(1);
336         uint256 totalTokensAllowed = tapTime.mul(mintTap.mintSpeed);
337         uint256 tokensRemaining = totalTokensAllowed.sub(mintTap.tokensIssued);
338         return tokensRemaining;
339     }
340 
341     /**
342      * @dev (Re)sets mint tap parameters
343      * @param _mintSpeed Allowed token amount to mint per second
344      */
345     function setMintTap(uint256 _mintSpeed) onlyOwner public {
346         mintTap.startTime = now;
347         mintTap.tokensIssued = 0;
348         mintTap.mintSpeed = _mintSpeed;
349         MintTapSet(mintTap.startTime, mintTap.mintSpeed);
350     }
351     /**
352      * @dev sets token Cap (maximum possible totalSupply) on Crowdsale finalization
353      * Cap will be set to (sold tokens + team tokens) * 2
354      */
355     function setCap() onlyOwner public {
356         require(!capFinalized);
357         require(cap == 2**256 - 1);
358         cap = totalSupply.mul(2);
359         capFinalized = true;
360         SetCap(totalSupply, cap);
361     }
362 }
363 
364 
365 /**
366  * @title LongevityCrowdsale
367  * @dev LongevityCrowdsale is a contract for managing a token crowdsale for Longevity project.
368  * Crowdsale have phases with start and end timestamps, where investors can make
369  * token purchases and the crowdsale will assign them tokens based
370  * on a token per ETH rate and bonuses. Collected funds are forwarded to a wallet
371  * as they arrive.
372  */
373 contract LongevityCrowdsale {
374     using SafeMath for uint256;
375 
376     // The token being sold
377     LongevityToken public token;
378 
379     // Crowdsale administrators
380     mapping (address => bool) public owners;
381 
382     // External bots updating rates
383     mapping (address => bool) public bots;
384 
385     // Cashiers responsible for manual token issuance
386     mapping (address => bool) public cashiers;
387 
388     // USD cents per ETH exchange rate
389     uint256 public rateUSDcETH;
390 
391     // Phases list, see schedule in constructor
392     mapping (uint => Phase) phases;
393 
394     // The total number of phases
395     uint public totalPhases = 0;
396 
397     // Description for each phase
398     struct Phase {
399         uint256 startTime;
400         uint256 endTime;
401         uint256 bonusPercent;
402     }
403 
404     // Minimum Deposit in USD cents
405     uint256 public constant minContributionUSDc = 1000;
406 
407     bool public finalized = false;
408 
409     // Amount of raised Ethers (in wei).
410     // And raised Dollars in cents
411     uint256 public weiRaised;
412     uint256 public USDcRaised;
413 
414     // Wallets management
415     address[] public wallets;
416     mapping (address => bool) inList;
417 
418     /**
419      * event for token purchase logging
420      * @param purchaser who paid for the tokens
421      * @param beneficiary who got the tokens
422      * @param value weis paid for purchase
423      * @param bonusPercent free tokens percantage for the phase
424      * @param amount amount of tokens purchased
425      */
426     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 bonusPercent, uint256 amount);
427     event OffChainTokenPurchase(address indexed beneficiary, uint256 tokensSold, uint256 USDcAmount);
428 
429     // event for rate update logging
430     event RateUpdate(uint256 rate);
431 
432     // event for wallet update
433     event WalletAdded(address indexed wallet);
434     event WalletRemoved(address indexed wallet);
435 
436     // owners management events
437     event OwnerAdded(address indexed newOwner);
438     event OwnerRemoved(address indexed removedOwner);
439 
440     // bot management events
441     event BotAdded(address indexed newBot);
442     event BotRemoved(address indexed removedBot);
443 
444     // cashier management events
445     event CashierAdded(address indexed newBot);
446     event CashierRemoved(address indexed removedBot);
447 
448     // Phase edit events
449     event TotalPhasesChanged(uint value);
450     event SetPhase(uint index, uint256 _startTime, uint256 _endTime, uint256 _bonusPercent);
451     event DelPhase(uint index);
452 
453     function LongevityCrowdsale(address _tokenAddress, uint256 _initialRate) public {
454         require(_tokenAddress != address(0));
455         token = LongevityToken(_tokenAddress);
456         rateUSDcETH = _initialRate;
457         owners[msg.sender] = true;
458         bots[msg.sender] = true;
459         phases[0].bonusPercent = 40;
460         phases[0].startTime = 1520453700;
461         phases[0].endTime = 1520460000;
462 
463         addWallet(msg.sender);
464     }
465 
466     // fallback function can be used to buy tokens
467     function () external payable {
468         buyTokens(msg.sender);
469     }
470 
471     // low level token purchase function
472     function buyTokens(address beneficiary) public payable {
473         require(beneficiary != address(0));
474         require(msg.value != 0);
475         require(isInPhase(now));
476 
477         uint256 currentBonusPercent = getBonusPercent(now);
478 
479         uint256 weiAmount = msg.value;
480 
481         require(calculateUSDcValue(weiAmount) >= minContributionUSDc);
482 
483         // calculate token amount to be created
484         uint256 tokens = calculateTokenAmount(weiAmount, currentBonusPercent);
485         
486         weiRaised = weiRaised.add(weiAmount);
487         USDcRaised = USDcRaised.add(calculateUSDcValue(weiRaised));
488 
489         token.mint(beneficiary, tokens);
490         TokenPurchase(msg.sender, beneficiary, weiAmount, currentBonusPercent, tokens);
491 
492         forwardFunds();
493     }
494 
495     // Sell any amount of tokens for cash or CryptoCurrency
496     function offChainPurchase(address beneficiary, uint256 tokensSold, uint256 USDcAmount) onlyCashier public {
497         require(beneficiary != address(0));
498         USDcRaised = USDcRaised.add(USDcAmount);
499         token.mint(beneficiary, tokensSold);
500         OffChainTokenPurchase(beneficiary, tokensSold, USDcAmount);
501     }
502 
503     // If phase exists return corresponding bonus for the given date
504     // else return 0 (percent)
505     function getBonusPercent(uint256 datetime) public view returns (uint256) {
506         require(isInPhase(datetime));
507         for (uint i = 0; i < totalPhases; i++) {
508             if (datetime >= phases[i].startTime && datetime <= phases[i].endTime) {
509                 return phases[i].bonusPercent;
510             }
511         }
512     }
513 
514     // If phase exists for the given date return true
515     function isInPhase(uint256 datetime) public view returns (bool) {
516         for (uint i = 0; i < totalPhases; i++) {
517             if (datetime >= phases[i].startTime && datetime <= phases[i].endTime) {
518                 return true;
519             }
520         }
521     }
522 
523     // set rate
524     function setRate(uint256 _rateUSDcETH) public onlyBot {
525         // don't allow to change rate more than 10%
526         assert(_rateUSDcETH < rateUSDcETH.mul(110).div(100));
527         assert(_rateUSDcETH > rateUSDcETH.mul(90).div(100));
528         rateUSDcETH = _rateUSDcETH;
529         RateUpdate(rateUSDcETH);
530     }
531 
532     /**
533      * @dev Adds administrative role to address
534      * @param _address The address that will get administrative privileges
535      */
536     function addOwner(address _address) onlyOwner public {
537         owners[_address] = true;
538         OwnerAdded(_address);
539     }
540 
541     /**
542      * @dev Removes administrative role from address
543      * @param _address The address to remove administrative privileges from
544      */
545     function delOwner(address _address) onlyOwner public {
546         owners[_address] = false;
547         OwnerRemoved(_address);
548     }
549 
550     /**
551      * @dev Throws if called by any account other than the owner.
552      */
553     modifier onlyOwner() {
554         require(owners[msg.sender]);
555         _;
556     }
557 
558     /**
559      * @dev Adds rate updating bot
560      * @param _address The address of the rate bot
561      */
562     function addBot(address _address) onlyOwner public {
563         bots[_address] = true;
564         BotAdded(_address);
565     }
566 
567     /**
568      * @dev Removes rate updating bot address
569      * @param _address The address of the rate bot
570      */
571     function delBot(address _address) onlyOwner public {
572         bots[_address] = false;
573         BotRemoved(_address);
574     }
575 
576     /**
577      * @dev Throws if called by any account other than the bot.
578      */
579     modifier onlyBot() {
580         require(bots[msg.sender]);
581         _;
582     }
583 
584     /**
585      * @dev Adds cashier account responsible for manual token issuance
586      * @param _address The address of the Cashier
587      */
588     function addCashier(address _address) onlyOwner public {
589         cashiers[_address] = true;
590         CashierAdded(_address);
591     }
592 
593     /**
594      * @dev Removes cashier account responsible for manual token issuance
595      * @param _address The address of the Cashier
596      */
597     function delCashier(address _address) onlyOwner public {
598         cashiers[_address] = false;
599         CashierRemoved(_address);
600     }
601 
602     /**
603      * @dev Throws if called by any account other than Cashier.
604      */
605     modifier onlyCashier() {
606         require(cashiers[msg.sender]);
607         _;
608     }
609 
610     // calculate deposit value in USD Cents
611     function calculateUSDcValue(uint256 _weiDeposit) public view returns (uint256) {
612 
613         // wei per USD cent
614         uint256 weiPerUSDc = 1 ether/rateUSDcETH;
615 
616         // Deposited value converted to USD cents
617         uint256 depositValueInUSDc = _weiDeposit.div(weiPerUSDc);
618         return depositValueInUSDc;
619     }
620 
621     // calculates how much tokens will beneficiary get
622     // for given amount of wei
623     function calculateTokenAmount(uint256 _weiDeposit, uint256 _bonusTokensPercent) public view returns (uint256) {
624         uint256 mainTokens = calculateUSDcValue(_weiDeposit);
625         uint256 bonusTokens = mainTokens.mul(_bonusTokensPercent).div(100);
626         return mainTokens.add(bonusTokens);
627     }
628 
629     // send ether to the fund collection wallet
630     function forwardFunds() internal {
631         uint256 value = msg.value / wallets.length;
632         uint256 rest = msg.value - (value * wallets.length);
633         for (uint i = 0; i < wallets.length - 1; i++) {
634             wallets[i].transfer(value);
635         }
636         wallets[wallets.length - 1].transfer(value + rest);
637     }
638 
639     // Add wallet address to wallets list
640     function addWallet(address _address) onlyOwner public {
641         require(!inList[_address]);
642         wallets.push(_address);
643         inList[_address] = true;
644         WalletAdded(_address);
645     }
646 
647     //Change number of phases
648     function setTotalPhases(uint value) onlyOwner public {
649         totalPhases = value;
650         TotalPhasesChanged(value);
651     }
652 
653     // Set phase: index and values
654     function setPhase(uint index, uint256 _startTime, uint256 _endTime, uint256 _bonusPercent) onlyOwner public {
655         require(index <= totalPhases);
656         phases[index] = Phase(_startTime, _endTime, _bonusPercent);
657         SetPhase(index, _startTime, _endTime, _bonusPercent);
658     }
659 
660     // Delete phase
661     function delPhase(uint index) onlyOwner public {
662         require(index <= totalPhases);
663         delete phases[index];
664         DelPhase(index);
665     }
666 
667     // Delete wallet from wallets list
668     function delWallet(uint index) onlyOwner public {
669         require(index < wallets.length);
670         address remove = wallets[index];
671         inList[remove] = false;
672         for (uint i = index; i < wallets.length-1; i++) {
673             wallets[i] = wallets[i+1];
674         }
675         wallets.length--;
676         WalletRemoved(remove);
677     }
678 
679     // Return wallets array size
680     function getWalletsCount() public view returns (uint256) {
681         return wallets.length;
682     }
683 
684     // finalizeCrowdsale issues tokens for the Team.
685     // Team gets 30/70 of harvested funds then token gets capped (upper emission boundary locked) to totalSupply * 2
686     // The token split after finalization will be in % of total token cap:
687     // 1. Tokens issued and distributed during pre-ICO and ICO = 35%
688     // 2. Tokens issued for the team on ICO finalization = 30%
689     // 3. Tokens for future in-app emission = 35%
690     function finalizeCrowdsale(address _teamAccount) onlyOwner public {
691         require(!finalized);
692         uint256 soldTokens = token.totalSupply();
693         uint256 teamTokens = soldTokens.div(70).mul(30);
694         token.mint(_teamAccount, teamTokens);
695         token.setCap();
696         finalized = true;
697     }
698 }