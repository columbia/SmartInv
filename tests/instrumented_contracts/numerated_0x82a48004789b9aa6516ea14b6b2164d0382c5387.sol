1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is paused.
66    */
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused public {
76     paused = true;
77     Pause();
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     Unpause();
86   }
87 }
88 
89 
90 
91 /**
92  * @title SafeMath
93  * @dev Math operations with safety checks that throw on error
94  */
95 library SafeMath {
96 
97   /**
98   * @dev Multiplies two numbers, throws on overflow.
99   */
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers, truncating the quotient.
111   */
112   function div(uint256 a, uint256 b) internal pure returns (uint256) {
113     // assert(b > 0); // Solidity automatically throws when dividing by 0
114     uint256 c = a / b;
115     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116     return c;
117   }
118 
119   /**
120   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
121   */
122   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123     assert(b <= a);
124     return a - b;
125   }
126 
127   /**
128   * @dev Adds two numbers, throws on overflow.
129   */
130   function add(uint256 a, uint256 b) internal pure returns (uint256) {
131     uint256 c = a + b;
132     assert(c >= a);
133     return c;
134   }
135 }
136 
137 
138 // This is an ERC-20 token contract based on Open Zepplin's StandardToken
139 // and MintableToken plus the ability to burn tokens.
140 //
141 // We had to copy over the code instead of inheriting because of changes
142 // to the modifier lists of some functions:
143 //   * transfer(), transferFrom() and approve() are not callable during
144 //     the minting period, only after MintingFinished()
145 //   * mint() can only be called by the minter who is not the owner
146 //     but the HoloTokenSale contract.
147 //
148 // Token can be burned by a special 'destroyer' role that can only
149 // burn its tokens.
150 contract HoloToken is Ownable {
151   string public constant name = "HoloToken";
152   string public constant symbol = "HOT";
153   uint8 public constant decimals = 18;
154 
155   event Transfer(address indexed from, address indexed to, uint256 value);
156   event Approval(address indexed owner, address indexed spender, uint256 value);
157   event Mint(address indexed to, uint256 amount);
158   event MintingFinished();
159   event Burn(uint256 amount);
160 
161   uint256 public totalSupply;
162 
163 
164   //==================================================================================
165   // Zeppelin BasicToken (plus modifier to not allow transfers during minting period):
166   //==================================================================================
167 
168   using SafeMath for uint256;
169 
170   mapping(address => uint256) public balances;
171 
172   /**
173   * @dev transfer token for a specified address
174   * @param _to The address to transfer to.
175   * @param _value The amount to be transferred.
176   */
177   function transfer(address _to, uint256 _value) public whenMintingFinished returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[msg.sender]);
180 
181     // SafeMath.sub will throw if there is not enough balance.
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public view returns (uint256 balance) {
194     return balances[_owner];
195   }
196 
197 
198   //=====================================================================================
199   // Zeppelin StandardToken (plus modifier to not allow transfers during minting period):
200   //=====================================================================================
201   mapping (address => mapping (address => uint256)) public allowed;
202 
203 
204   /**
205    * @dev Transfer tokens from one address to another
206    * @param _from address The address which you want to send tokens from
207    * @param _to address The address which you want to transfer to
208    * @param _value uint256 the amout of tokens to be transfered
209    */
210   function transferFrom(address _from, address _to, uint256 _value) public whenMintingFinished returns (bool) {
211     require(_to != address(0));
212     require(_value <= balances[_from]);
213     require(_value <= allowed[_from][msg.sender]);
214 
215     balances[_from] = balances[_from].sub(_value);
216     balances[_to] = balances[_to].add(_value);
217     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
218     Transfer(_from, _to, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
224    *
225    * Beware that changing an allowance with this method brings the risk that someone may use both the old
226    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
227    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
228    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229    * @param _spender The address which will spend the funds.
230    * @param _value The amount of tokens to be spent.
231    */
232   function approve(address _spender, uint256 _value) public whenMintingFinished returns (bool) {
233     allowed[msg.sender][_spender] = _value;
234     Approval(msg.sender, _spender, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Function to check the amount of tokens that an owner allowed to a spender.
240    * @param _owner address The address which owns the funds.
241    * @param _spender address The address which will spend the funds.
242    * @return A uint256 specifying the amount of tokens still available for the spender.
243    */
244   function allowance(address _owner, address _spender) public view returns (uint256) {
245     return allowed[_owner][_spender];
246   }
247 
248   /**
249    * approve should be called when allowed[_spender] == 0. To increment
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    */
254   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
255     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
256     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
261     uint oldValue = allowed[msg.sender][_spender];
262     if (_subtractedValue > oldValue) {
263       allowed[msg.sender][_spender] = 0;
264     } else {
265       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266     }
267     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271 
272   //=====================================================================================
273   // Minting:
274   //=====================================================================================
275 
276   bool public mintingFinished = false;
277   address public destroyer;
278   address public minter;
279 
280   modifier canMint() {
281     require(!mintingFinished);
282     _;
283   }
284 
285   modifier whenMintingFinished() {
286     require(mintingFinished);
287     _;
288   }
289 
290   modifier onlyMinter() {
291     require(msg.sender == minter);
292     _;
293   }
294 
295   function setMinter(address _minter) external onlyOwner {
296     minter = _minter;
297   }
298 
299   function mint(address _to, uint256 _amount) external onlyMinter canMint  returns (bool) {
300     require(balances[_to] + _amount > balances[_to]); // Guard against overflow
301     require(totalSupply + _amount > totalSupply);     // Guard against overflow  (this should never happen)
302     totalSupply = totalSupply.add(_amount);
303     balances[_to] = balances[_to].add(_amount);
304     Mint(_to, _amount);
305     return true;
306   }
307 
308   function finishMinting() external onlyMinter returns (bool) {
309     mintingFinished = true;
310     MintingFinished();
311     return true;
312   }
313 
314 
315   //=====================================================================================
316   // Burning:
317   //=====================================================================================
318 
319 
320   modifier onlyDestroyer() {
321      require(msg.sender == destroyer);
322      _;
323   }
324 
325   function setDestroyer(address _destroyer) external onlyOwner {
326     destroyer = _destroyer;
327   }
328 
329   function burn(uint256 _amount) external onlyDestroyer {
330     require(balances[destroyer] >= _amount && _amount > 0);
331     balances[destroyer] = balances[destroyer].sub(_amount);
332     totalSupply = totalSupply.sub(_amount);
333     Burn(_amount);
334   }
335 }
336 
337 
338 // This contract holds a mapping of known funders with:
339 // * a boolean flag for whitelist status
340 // * number of reserved tokens for each day
341 contract HoloWhitelist is Ownable {
342   address public updater;
343 
344   struct KnownFunder {
345     bool whitelisted;
346     mapping(uint => uint256) reservedTokensPerDay;
347   }
348 
349   mapping(address => KnownFunder) public knownFunders;
350 
351   event Whitelisted(address[] funders);
352   event ReservedTokensSet(uint day, address[] funders, uint256[] reservedTokens);
353 
354   modifier onlyUpdater {
355     require(msg.sender == updater);
356     _;
357   }
358 
359   function HoloWhitelist() public {
360     updater = msg.sender;
361   }
362 
363   function setUpdater(address new_updater) external onlyOwner {
364     updater = new_updater;
365   }
366 
367   // Adds funders to the whitelist in batches.
368   function whitelist(address[] funders) external onlyUpdater {
369     for (uint i = 0; i < funders.length; i++) {
370         knownFunders[funders[i]].whitelisted = true;
371     }
372     Whitelisted(funders);
373   }
374 
375   // Removes funders from the whitelist in batches.
376   function unwhitelist(address[] funders) external onlyUpdater {
377     for (uint i = 0; i < funders.length; i++) {
378         knownFunders[funders[i]].whitelisted = false;
379     }
380   }
381 
382   // Stores reserved tokens for several funders in a batch
383   // but all for the same day.
384   // * day is 0-based
385   function setReservedTokens(uint day, address[] funders, uint256[] reservedTokens) external onlyUpdater {
386     for (uint i = 0; i < funders.length; i++) {
387         knownFunders[funders[i]].reservedTokensPerDay[day] = reservedTokens[i];
388     }
389     ReservedTokensSet(day, funders, reservedTokens);
390   }
391 
392   // Used in HoloSale to check if funder is allowed
393   function isWhitelisted(address funder) external view returns (bool) {
394     return knownFunders[funder].whitelisted;
395   }
396 
397   // Used in HoloSale to get reserved tokens per funder
398   // and per day.
399   // * day is 0-based
400   function reservedTokens(address funder, uint day) external view returns (uint256) {
401     return knownFunders[funder].reservedTokensPerDay[day];
402   }
403 
404 
405 }
406 
407 
408 // This contract is a crowdsale based on Zeppelin's Crowdsale.sol but with
409 // several changes:
410 //   * the token contract as well as the supply contract get injected
411 //     with setTokenContract() and setSupplyContract()
412 //   * we have a dynamic token supply per day which we hold in the statsByDay
413 //   * once per day, the *updater* role runs the update function to make the
414 //     contract read the new supply and switch to the next day
415 //   * we have a minimum amount in ETH per transaction
416 //   * we have a maximum amount per transaction relative to the daily supply
417 //
418 //
419 contract HoloSale is Ownable, Pausable{
420   using SafeMath for uint256;
421 
422   // Start and end block where purchases are allowed (both inclusive)
423   uint256 public startBlock;
424   uint256 public endBlock;
425   // Factor between wei and full Holo tokens.
426   // (i.e. a rate of 10^18 means one Holo per Ether)
427   uint256 public rate;
428   // Ratio of the current supply a transaction is allowed to by
429   uint256 public maximumPercentageOfDaysSupply;
430   // Minimum amount of wei a transaction has to send
431   uint256 public minimumAmountWei;
432   // address where funds are being send to on successful buy
433   address public wallet;
434 
435   // The token being minted on sale
436   HoloToken private tokenContract;
437   // The contract to check beneficiaries' address against
438   // and to hold number of reserved tokens per day
439   HoloWhitelist private whitelistContract;
440 
441   // The account that is allowed to call update()
442   // which will happen once per day during the sale period
443   address private updater;
444 
445   // Will be set to true by finalize()
446   bool private finalized = false;
447 
448   uint256 public totalSupply;
449 
450   // For every day of the sale we store one instance of this struct
451   struct Day {
452     // The supply available to sell on this day
453     uint256 supply;
454     // The number of unreserved tokens sold on this day
455     uint256 soldFromUnreserved;
456     // Number of tokens reserved today
457     uint256 reserved;
458     // Number of reserved tokens sold today
459     uint256 soldFromReserved;
460     // We are storing how much fuel each user has bought per day
461     // to be able to apply our relative cap per user per day
462     // (i.e. nobody is allowed to buy more than 10% of each day's supply)
463     mapping(address => uint256) fuelBoughtByAddress;
464   }
465 
466   // Growing list of days
467   Day[] public statsByDay;
468 
469   event CreditsCreated(address beneficiary, uint256 amountWei, uint256 amountHolos);
470   event Update(uint256 newTotalSupply, uint256 reservedTokensNextDay);
471 
472   modifier onlyUpdater {
473     require(msg.sender == updater);
474     _;
475   }
476 
477   // Converts wei to smallest fraction of Holo tokens.
478   // 'rate' is meant to give the factor between weis and full Holo tokens,
479   // hence the division by 10^18.
480   function holosForWei(uint256 amountWei) internal view returns (uint256) {
481     return amountWei * rate / 1000000000000000000;
482   }
483 
484   // Contstructor takes start and end block of the sale period,
485   // the rate that defines how many full Holo token are being minted per wei
486   // (since the Holo token has 18 decimals, 1000000000000000000 would mean that
487   // one full Holo is minted per Ether),
488   // minimum and maximum limits for incoming ETH transfers
489   // and the wallet to which the Ethers are being transfered on updated()
490   function HoloSale(
491     uint256 _startBlock, uint256 _endBlock,
492     uint256 _rate,
493     uint256 _minimumAmountWei, uint256 _maximumPercentageOfDaysSupply,
494     address _wallet) public
495   {
496     require(_startBlock >= block.number);
497     require(_endBlock >= _startBlock);
498     require(_rate > 0);
499     require(_wallet != 0x0);
500 
501     updater = msg.sender;
502     startBlock = _startBlock;
503     endBlock = _endBlock;
504     rate = _rate;
505     maximumPercentageOfDaysSupply = _maximumPercentageOfDaysSupply;
506     minimumAmountWei = _minimumAmountWei;
507     wallet = _wallet;
508   }
509 
510   //---------------------------------------------------------------------------
511   // Setters and Getters:
512   //---------------------------------------------------------------------------
513 
514   function setUpdater(address _updater) external onlyOwner {
515     updater = _updater;
516   }
517 
518   function setTokenContract(HoloToken _tokenContract) external onlyOwner {
519     tokenContract = _tokenContract;
520   }
521 
522   function setWhitelistContract(HoloWhitelist _whitelistContract) external onlyOwner {
523     whitelistContract = _whitelistContract;
524   }
525 
526   function currentDay() public view returns (uint) {
527     return statsByDay.length;
528   }
529 
530   function todaysSupply() external view returns (uint) {
531     return statsByDay[currentDay()-1].supply;
532   }
533 
534   function todaySold() external view returns (uint) {
535     return statsByDay[currentDay()-1].soldFromUnreserved + statsByDay[currentDay()-1].soldFromReserved;
536   }
537 
538   function todayReserved() external view returns (uint) {
539     return statsByDay[currentDay()-1].reserved;
540   }
541 
542   function boughtToday(address beneficiary) external view returns (uint) {
543     return statsByDay[currentDay()-1].fuelBoughtByAddress[beneficiary];
544   }
545 
546   //---------------------------------------------------------------------------
547   // Sending money / adding asks
548   //---------------------------------------------------------------------------
549 
550   // Fallback function can be used to buy fuel
551   function () public payable {
552     buyFuel(msg.sender);
553   }
554 
555   // Main function that checks all conditions and then mints fuel tokens
556   // and transfers the ETH to our wallet
557   function buyFuel(address beneficiary) public payable whenNotPaused{
558     require(currentDay() > 0);
559     require(whitelistContract.isWhitelisted(beneficiary));
560     require(beneficiary != 0x0);
561     require(withinPeriod());
562 
563     // Calculate how many Holos this transaction would buy
564     uint256 amountOfHolosAsked = holosForWei(msg.value);
565 
566     // Get current day
567     uint dayIndex = statsByDay.length-1;
568     Day storage today = statsByDay[dayIndex];
569 
570     // Funders who took part in the crowdfund could have reserved tokens
571     uint256 reservedHolos = whitelistContract.reservedTokens(beneficiary, dayIndex);
572     // If they do, make sure to subtract what they bought already today
573     uint256 alreadyBought = today.fuelBoughtByAddress[beneficiary];
574     if(alreadyBought >= reservedHolos) {
575       reservedHolos = 0;
576     } else {
577       reservedHolos = reservedHolos.sub(alreadyBought);
578     }
579 
580     // Calculate if they asked more than they have reserved
581     uint256 askedMoreThanReserved;
582     uint256 useFromReserved;
583     if(amountOfHolosAsked > reservedHolos) {
584       askedMoreThanReserved = amountOfHolosAsked.sub(reservedHolos);
585       useFromReserved = reservedHolos;
586     } else {
587       askedMoreThanReserved = 0;
588       useFromReserved = amountOfHolosAsked;
589     }
590 
591     if(reservedHolos == 0) {
592       // If this transaction is not claiming reserved tokens
593       // it has to be over the minimum.
594       // (Reserved tokens must be claimable even if it would be just few)
595       require(msg.value >= minimumAmountWei);
596     }
597 
598     // The non-reserved tokens asked must not exceed the max-ratio
599     // nor the available supply.
600     require(lessThanMaxRatio(beneficiary, askedMoreThanReserved, today));
601     require(lessThanSupply(askedMoreThanReserved, today));
602 
603     // Everything fine if we're here
604     // Send ETH to our wallet
605     wallet.transfer(msg.value);
606     // Mint receipts
607     tokenContract.mint(beneficiary, amountOfHolosAsked);
608     // Log this sale
609     today.soldFromUnreserved = today.soldFromUnreserved.add(askedMoreThanReserved);
610     today.soldFromReserved = today.soldFromReserved.add(useFromReserved);
611     today.fuelBoughtByAddress[beneficiary] = today.fuelBoughtByAddress[beneficiary].add(amountOfHolosAsked);
612     CreditsCreated(beneficiary, msg.value, amountOfHolosAsked);
613   }
614 
615   // Returns true if we are in the live period of the sale
616   function withinPeriod() internal constant returns (bool) {
617     uint256 current = block.number;
618     return current >= startBlock && current <= endBlock;
619   }
620 
621   // Returns true if amount + plus fuel bought today already is not above
622   // the maximum share one could buy today
623   function lessThanMaxRatio(address beneficiary, uint256 amount, Day storage today) internal view returns (bool) {
624     uint256 boughtTodayBefore = today.fuelBoughtByAddress[beneficiary];
625     return boughtTodayBefore.add(amount).mul(100).div(maximumPercentageOfDaysSupply) <= today.supply;
626   }
627 
628   // Returns false if amount would buy more fuel than we can sell today
629   function lessThanSupply(uint256 amount, Day today) internal pure returns (bool) {
630     return today.soldFromUnreserved.add(amount) <= today.supply.sub(today.reserved);
631   }
632 
633   //---------------------------------------------------------------------------
634   // Update
635   //---------------------------------------------------------------------------
636 
637 
638   function update(uint256 newTotalSupply, uint256 reservedTokensNextDay) external onlyUpdater {
639     totalSupply = newTotalSupply;
640     // daysSupply is the amount of tokens (*10^18) that we can sell today
641     uint256 daysSupply = newTotalSupply.sub(tokenContract.totalSupply());
642     statsByDay.push(Day(daysSupply, 0, reservedTokensNextDay, 0));
643     Update(newTotalSupply, reservedTokensNextDay);
644   }
645 
646   //---------------------------------------------------------------------------
647   // Finalize
648   //---------------------------------------------------------------------------
649 
650   // Returns true if crowdsale event has ended
651   function hasEnded() public constant returns (bool) {
652     return block.number > endBlock;
653   }
654 
655   // Mints a third of all tokens minted so far for the team.
656   // => Team ends up with 25% of all tokens.
657   // Also calls finishMinting() on the token contract which makes it
658   // impossible to mint more.
659   function finalize() external onlyOwner {
660     require(!finalized);
661     require(hasEnded());
662     uint256 receiptsMinted = tokenContract.totalSupply();
663     uint256 shareForTheTeam = receiptsMinted.div(3);
664     tokenContract.mint(wallet, shareForTheTeam);
665     tokenContract.finishMinting();
666     finalized = true;
667   }
668 }