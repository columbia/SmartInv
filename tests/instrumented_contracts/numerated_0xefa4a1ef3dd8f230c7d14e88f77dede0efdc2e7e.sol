1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances.
53  */
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   /**
60   * @dev transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66     require(_value <= balances[msg.sender]);
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public view returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public view returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * @dev https://github.com/ethereum/EIPs/issues/20
104  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
105  */
106 contract StandardToken is ERC20, BasicToken {
107 
108   mapping (address => mapping (address => uint256)) internal allowed;
109 
110 
111   /**
112    * @dev Transfer tokens from one address to another
113    * @param _from address The address which you want to send tokens from
114    * @param _to address The address which you want to transfer to
115    * @param _value uint256 the amount of tokens to be transferred
116    */
117   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    *
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public view returns (uint256) {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156    * @dev Increase the amount of tokens that an owner allowed to a spender.
157    *
158    * approve should be called when allowed[_spender] == 0. To increment
159    * allowed value is better to use this function to avoid 2 calls (and wait until
160    * the first transaction is mined)
161    * From MonolithDAO Token.sol
162    * @param _spender The address which will spend the funds.
163    * @param _addedValue The amount of tokens to increase the allowance by.
164    */
165   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
166     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   /**
172    * @dev Decrease the amount of tokens that an owner allowed to a spender.
173    *
174    * approve should be called when allowed[_spender] == 0. To decrement
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    * @param _spender The address which will spend the funds.
179    * @param _subtractedValue The amount of tokens to decrease the allowance by.
180    */
181   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
182     uint oldValue = allowed[msg.sender][_spender];
183     if (_subtractedValue > oldValue) {
184       allowed[msg.sender][_spender] = 0;
185     } else {
186       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187     }
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192 }
193 
194 
195 contract LongevityToken is StandardToken {
196     string public name = "Longevity";
197     string public symbol = "LTY";
198     uint8 public decimals = 2;
199     bool public mintingFinished = false;
200     mapping (address => bool) owners;
201     mapping (address => bool) minters;
202     // tap to limit mint speed
203     struct Tap {
204         uint256 startTime; // reference time point to start measuring
205         uint256 tokensIssued; // how much tokens issued from startTime
206         uint256 mintSpeed; // token fractions per second
207     }
208     Tap public mintTap;
209 
210     event Mint(address indexed to, uint256 amount);
211     event MintFinished();
212     event OwnerAdded(address indexed newOwner);
213     event OwnerRemoved(address indexed removedOwner);
214     event MinterAdded(address indexed newMinter);
215     event MinterRemoved(address indexed removedMinter);
216     event Burn(address indexed burner, uint256 value);
217     event MintTapSet(uint256 startTime, uint256 mintSpeed);
218 
219     function LongevityToken() public {
220         owners[msg.sender] = true;
221     }
222 
223     /**
224      * @dev Function to mint tokens
225      * @param _to The address that will receive the minted tokens.
226      * @param _amount The amount of tokens to mint.
227      * @return A boolean that indicates if the operation was successful.
228      */
229     function mint(address _to, uint256 _amount) onlyMinter public returns (bool) {
230         require(!mintingFinished);
231         passThroughTap(_amount);
232         totalSupply = totalSupply.add(_amount);
233         balances[_to] = balances[_to].add(_amount);
234         Mint(_to, _amount);
235         Transfer(address(0), _to, _amount);
236         return true;
237     }
238 
239     /**
240      * @dev Function to stop minting new tokens.
241      * @return True if the operation was successful.
242      */
243     function finishMinting() onlyOwner public returns (bool) {
244         require(!mintingFinished);
245         mintingFinished = true;
246         MintFinished();
247         return true;
248     }
249 
250     /**
251      * @dev Burns a specific amount of tokens.
252      * @param _value The amount of token to be burned.
253      */
254     function burn(uint256 _value) public {
255         require(_value <= balances[msg.sender]);
256         // no need to require value <= totalSupply, since that would imply the
257         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
258 
259         address burner = msg.sender;
260         balances[burner] = balances[burner].sub(_value);
261         totalSupply = totalSupply.sub(_value);
262         Burn(burner, _value);
263     }
264 
265     /**
266      * @dev Adds administrative role to address
267      * @param _address The address that will get administrative privileges
268      */
269     function addOwner(address _address) onlyOwner public {
270         owners[_address] = true;
271         OwnerAdded(_address);
272     }
273 
274     /**
275      * @dev Removes administrative role from address
276      * @param _address The address to remove administrative privileges from
277      */
278     function delOwner(address _address) onlyOwner public {
279         owners[_address] = false;
280         OwnerRemoved(_address);
281     }
282 
283     /**
284      * @dev Throws if called by any account other than the owner.
285      */
286     modifier onlyOwner() {
287         require(owners[msg.sender]);
288         _;
289     }
290 
291     /**
292      * @dev Adds minter role to address (able to create new tokens)
293      * @param _address The address that will get minter privileges
294      */
295     function addMinter(address _address) onlyOwner public {
296         minters[_address] = true;
297         MinterAdded(_address);
298     }
299 
300     /**
301      * @dev Removes minter role from address
302      * @param _address The address to remove minter privileges
303      */
304     function delMinter(address _address) onlyOwner public {
305         minters[_address] = false;
306         MinterRemoved(_address);
307     }
308 
309     /**
310      * @dev Throws if called by any account other than the minter.
311      */
312     modifier onlyMinter() {
313         require(minters[msg.sender]);
314         _;
315     }
316 
317     /**
318      * @dev passThroughTap allows minting tokens within the defined speed limit.
319      * Throws if requested more than allowed.
320      */
321     function passThroughTap(uint256 _tokensRequested) internal {
322         require(_tokensRequested <= getTapRemaining());
323         mintTap.tokensIssued = mintTap.tokensIssued.add(_tokensRequested);
324     }
325 
326     /**
327      * @dev Returns remaining amount of tokens allowed at the moment
328      */
329     function getTapRemaining() public view returns (uint256) {
330         uint256 tapTime = now.sub(mintTap.startTime).add(1);
331         uint256 totalTokensAllowed = tapTime.mul(mintTap.mintSpeed);
332         uint256 tokensRemaining = totalTokensAllowed.sub(mintTap.tokensIssued);
333         return tokensRemaining;
334     }
335 
336     /**
337      * @dev (Re)sets mint tap parameters
338      * @param _mintSpeed Allowed token amount to mint per second
339      */
340     function setMintTap(uint256 _mintSpeed) onlyOwner public {
341         mintTap.startTime = now;
342         mintTap.tokensIssued = 0;
343         mintTap.mintSpeed = _mintSpeed;
344         MintTapSet(mintTap.startTime, mintTap.mintSpeed);
345     }
346 }
347 
348 
349 /**
350  * @title LongevityCrowdsale
351  * @dev LongevityCrowdsale is a contract for managing a token crowdsale for Longevity project.
352  * Crowdsale have phases with start and end timestamps, where investors can make
353  * token purchases and the crowdsale will assign them tokens based
354  * on a token per ETH rate and bonuses. Collected funds are forwarded to a wallet
355  * as they arrive.
356  */
357 contract LongevityCrowdsale {
358     using SafeMath for uint256;
359 
360     // The token being sold
361     LongevityToken public token;
362 
363     // External wallet where funds get forwarded
364     address public wallet;
365 
366     // Crowdsale administrators
367     mapping (address => bool) public owners;
368 
369     // External bots updating rates
370     mapping (address => bool) public bots;
371 
372     // USD cents per ETH exchange rate
373     uint256 public rateUSDcETH;
374 
375     // Phases list, see schedule in constructor
376     mapping (uint => Phase) phases;
377 
378     // The total number of phases
379     uint public totalPhases = 0;
380 
381     // Description for each phase
382     struct Phase {
383         uint256 startTime;
384         uint256 endTime;
385         uint256 bonusPercent;
386     }
387 
388     // Minimum Deposit in USD cents
389     uint256 public constant minContributionUSDc = 1000;
390 
391 
392     // Amount of raised Ethers (in wei).
393     uint256 public weiRaised;
394 
395     /**
396      * event for token purchase logging
397      * @param purchaser who paid for the tokens
398      * @param beneficiary who got the tokens
399      * @param value weis paid for purchase
400      * @param bonusPercent free tokens percantage for the phase
401      * @param amount amount of tokens purchased
402      */
403     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 bonusPercent, uint256 amount);
404 
405     // event for rate update logging
406     event RateUpdate(uint256 rate);
407 
408     // event for wallet update
409     event WalletSet(address indexed wallet);
410 
411     // owners management events
412     event OwnerAdded(address indexed newOwner);
413     event OwnerRemoved(address indexed removedOwner);
414 
415     // bot management events
416     event BotAdded(address indexed newBot);
417     event BotRemoved(address indexed removedBot);
418 
419     // Phase edit events
420     event TotalPhasesChanged(uint value);
421     event SetPhase(uint index, uint256 _startTime, uint256 _endTime, uint256 _bonusPercent);
422     event DelPhase(uint index);
423 
424     function LongevityCrowdsale(address _tokenAddress, uint256 _initialRate) public {
425         require(_tokenAddress != address(0));
426         token = LongevityToken(_tokenAddress);
427         rateUSDcETH = _initialRate;
428         wallet = msg.sender;
429         owners[msg.sender] = true;
430         bots[msg.sender] = true;
431         phases[0].bonusPercent = 40;
432         phases[0].startTime = 1520453700;
433         phases[0].endTime = 1520460000;
434     }
435 
436     /**
437      * @dev Update collecting wallet address
438      * @param _address The address to send collected funds
439      */
440     function setWallet(address _address) onlyOwner public {
441         wallet = _address;
442         WalletSet(_address);
443     }
444 
445 
446     // fallback function can be used to buy tokens
447     function () external payable {
448         buyTokens(msg.sender);
449     }
450 
451     // low level token purchase function
452     function buyTokens(address beneficiary) public payable {
453         require(beneficiary != address(0));
454         require(msg.value != 0);
455         require(isInPhase(now));
456 
457         uint256 currentBonusPercent = getBonusPercent(now);
458 
459         uint256 weiAmount = msg.value;
460 
461         require(calculateUSDcValue(weiAmount) >= minContributionUSDc);
462 
463         // calculate token amount to be created
464         uint256 tokens = calculateTokenAmount(weiAmount, currentBonusPercent);
465 
466         // update state
467         weiRaised = weiRaised.add(weiAmount);
468 
469         token.mint(beneficiary, tokens);
470         TokenPurchase(msg.sender, beneficiary, weiAmount, currentBonusPercent, tokens);
471 
472         forwardFunds();
473     }
474 
475     // If phase exists return corresponding bonus for the given date
476     // else return 0 (percent)
477     function getBonusPercent(uint256 datetime) public view returns (uint256) {
478         require(isInPhase(datetime));
479         for (uint i = 0; i < totalPhases; i++) {
480             if (datetime >= phases[i].startTime && datetime <= phases[i].endTime) {
481                 return phases[i].bonusPercent;
482             }
483         }
484         return 0;
485     }
486 
487     // If phase exists for the given date return true
488     function isInPhase(uint256 datetime) public view returns (bool) {
489         for (uint i = 0; i < totalPhases; i++) {
490             if (datetime >= phases[i].startTime && datetime <= phases[i].endTime) {
491                 return true;
492             }
493         }
494     }
495 
496     // set rate
497     function setRate(uint256 _rateUSDcETH) public onlyBot {
498         // don't allow to change rate more than 10%
499         assert(_rateUSDcETH < rateUSDcETH.mul(110).div(100));
500         assert(_rateUSDcETH > rateUSDcETH.mul(90).div(100));
501         rateUSDcETH = _rateUSDcETH;
502         RateUpdate(rateUSDcETH);
503     }
504 
505     /**
506      * @dev Adds administrative role to address
507      * @param _address The address that will get administrative privileges
508      */
509     function addOwner(address _address) onlyOwner public {
510         owners[_address] = true;
511         OwnerAdded(_address);
512     }
513 
514     /**
515      * @dev Removes administrative role from address
516      * @param _address The address to remove administrative privileges from
517      */
518     function delOwner(address _address) onlyOwner public {
519         owners[_address] = false;
520         OwnerRemoved(_address);
521     }
522 
523     /**
524      * @dev Throws if called by any account other than the owner.
525      */
526     modifier onlyOwner() {
527         require(owners[msg.sender]);
528         _;
529     }
530 
531     /**
532      * @dev Adds rate updating bot
533      * @param _address The address of the rate bot
534      */
535     function addBot(address _address) onlyOwner public {
536         bots[_address] = true;
537         BotAdded(_address);
538     }
539 
540     /**
541      * @dev Removes rate updating bot address
542      * @param _address The address of the rate bot
543      */
544     function delBot(address _address) onlyOwner public {
545         bots[_address] = false;
546         BotRemoved(_address);
547     }
548 
549     /**
550      * @dev Throws if called by any account other than the bot.
551      */
552     modifier onlyBot() {
553         require(bots[msg.sender]);
554         _;
555     }
556 
557     // calculate deposit value in USD Cents
558     function calculateUSDcValue(uint256 _weiDeposit) public view returns (uint256) {
559 
560         // wei per USD cent
561         uint256 weiPerUSDc = 1 ether/rateUSDcETH;
562 
563         // Deposited value converted to USD cents
564         uint256 depositValueInUSDc = _weiDeposit.div(weiPerUSDc);
565         return depositValueInUSDc;
566     }
567 
568     // calculates how much tokens will beneficiary get
569     // for given amount of wei
570     function calculateTokenAmount(uint256 _weiDeposit, uint256 _bonusTokensPercent) public view returns (uint256) {
571         uint256 mainTokens = calculateUSDcValue(_weiDeposit);
572         uint256 bonusTokens = mainTokens.mul(_bonusTokensPercent).div(100);
573         return mainTokens.add(bonusTokens);
574     }
575 
576     // send ether to the fund collection wallet
577     // override to create custom fund forwarding mechanisms
578     function forwardFunds() internal {
579         wallet.transfer(msg.value);
580     }
581 
582     //Change number of phases
583     function setTotalPhases(uint value) onlyOwner public {
584         totalPhases = value;
585         TotalPhasesChanged(value);
586     }
587 
588     // Set phase: index and values
589     function setPhase(uint index, uint256 _startTime, uint256 _endTime, uint256 _bonusPercent) onlyOwner public {
590         require(index <= totalPhases);
591         phases[index] = Phase(_startTime, _endTime, _bonusPercent);
592         SetPhase(index, _startTime, _endTime, _bonusPercent);
593     }
594 
595     // Delete phase
596     function delPhase(uint index) onlyOwner public {
597         require(index <= totalPhases);
598         delete phases[index];
599         DelPhase(index);
600     }
601 }