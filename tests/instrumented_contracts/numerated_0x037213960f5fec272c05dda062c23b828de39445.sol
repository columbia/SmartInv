1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 // File: zeppelin-solidity/contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   /**
122   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
140 
141 /**
142  * @title ERC20Basic
143  * @dev Simpler version of ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/179
145  */
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address who) public view returns (uint256);
149   function transfer(address to, uint256 value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
154 
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  */
159 contract BasicToken is ERC20Basic {
160   using SafeMath for uint256;
161 
162   mapping(address => uint256) balances;
163 
164   uint256 totalSupply_;
165 
166   /**
167   * @dev total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[msg.sender]);
181 
182     // SafeMath.sub will throw if there is not enough balance.
183     balances[msg.sender] = balances[msg.sender].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     Transfer(msg.sender, _to, _value);
186     return true;
187   }
188 
189   /**
190   * @dev Gets the balance of the specified address.
191   * @param _owner The address to query the the balance of.
192   * @return An uint256 representing the amount owned by the passed address.
193   */
194   function balanceOf(address _owner) public view returns (uint256 balance) {
195     return balances[_owner];
196   }
197 
198 }
199 
200 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
201 
202 /**
203  * @title ERC20 interface
204  * @dev see https://github.com/ethereum/EIPs/issues/20
205  */
206 contract ERC20 is ERC20Basic {
207   function allowance(address owner, address spender) public view returns (uint256);
208   function transferFrom(address from, address to, uint256 value) public returns (bool);
209   function approve(address spender, uint256 value) public returns (bool);
210   event Approval(address indexed owner, address indexed spender, uint256 value);
211 }
212 
213 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * @dev https://github.com/ethereum/EIPs/issues/20
220  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
221  */
222 contract StandardToken is ERC20, BasicToken {
223 
224   mapping (address => mapping (address => uint256)) internal allowed;
225 
226 
227   /**
228    * @dev Transfer tokens from one address to another
229    * @param _from address The address which you want to send tokens from
230    * @param _to address The address which you want to transfer to
231    * @param _value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
234     require(_to != address(0));
235     require(_value <= balances[_from]);
236     require(_value <= allowed[_from][msg.sender]);
237 
238     balances[_from] = balances[_from].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241     Transfer(_from, _to, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247    *
248    * Beware that changing an allowance with this method brings the risk that someone may use both the old
249    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252    * @param _spender The address which will spend the funds.
253    * @param _value The amount of tokens to be spent.
254    */
255   function approve(address _spender, uint256 _value) public returns (bool) {
256     allowed[msg.sender][_spender] = _value;
257     Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param _owner address The address which owns the funds.
264    * @param _spender address The address which will spend the funds.
265    * @return A uint256 specifying the amount of tokens still available for the spender.
266    */
267   function allowance(address _owner, address _spender) public view returns (uint256) {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    *
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _addedValue The amount of tokens to increase the allowance by.
280    */
281   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
282     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
283     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287   /**
288    * @dev Decrease the amount of tokens that an owner allowed to a spender.
289    *
290    * approve should be called when allowed[_spender] == 0. To decrement
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _subtractedValue The amount of tokens to decrease the allowance by.
296    */
297   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
298     uint oldValue = allowed[msg.sender][_spender];
299     if (_subtractedValue > oldValue) {
300       allowed[msg.sender][_spender] = 0;
301     } else {
302       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303     }
304     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308 }
309 
310 // File: contracts/CurrentToken.sol
311 
312 contract CurrentToken is StandardToken, Pausable {
313     string constant public name = "CurrentCoin";
314     string constant public symbol = "CUR";
315     uint8 constant public decimals = 18;
316 
317     uint256 constant public INITIAL_TOTAL_SUPPLY = 1e11 * (uint256(10) ** decimals);
318 
319     address private addressIco;
320 
321     modifier onlyIco() {
322         require(msg.sender == addressIco);
323         _;
324     }
325 
326     /**
327     * @dev Create CurrentToken contract and set pause
328     * @param _ico The address of ICO contract.
329     */
330     function CurrentToken (address _ico) public {
331         require(_ico != address(0));
332 
333         addressIco = _ico;
334 
335         totalSupply_ = totalSupply_.add(INITIAL_TOTAL_SUPPLY);
336         balances[_ico] = balances[_ico].add(INITIAL_TOTAL_SUPPLY);
337         Transfer(address(0), _ico, INITIAL_TOTAL_SUPPLY);
338 
339         pause();
340     }
341 
342     /**
343     * @dev Transfer token for a specified address with pause feature for owner.
344     * @dev Only applies when the transfer is allowed by the owner.
345     * @param _to The address to transfer to.
346     * @param _value The amount to be transferred.
347     */
348     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
349         super.transfer(_to, _value);
350     }
351 
352     /**
353     * @dev Transfer tokens from one address to another with pause feature for owner.
354     * @dev Only applies when the transfer is allowed by the owner.
355     * @param _from address The address which you want to send tokens from
356     * @param _to address The address which you want to transfer to
357     * @param _value uint256 the amount of tokens to be transferred
358     */
359     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
360         super.transferFrom(_from, _to, _value);
361     }
362 
363     /**
364     * @dev Transfer tokens from ICO address to another address.
365     * @param _to The address to transfer to.
366     * @param _value The amount to be transferred.
367     */
368     function transferFromIco(address _to, uint256 _value) onlyIco public returns (bool) {
369         super.transfer(_to, _value);
370     }
371 
372     /**
373     * @dev Burn remaining tokens from the ICO balance.
374     */
375     function burnFromIco() onlyIco public {
376         uint256 remainingTokens = balanceOf(addressIco);
377 
378         balances[addressIco] = balances[addressIco].sub(remainingTokens);
379         totalSupply_ = totalSupply_.sub(remainingTokens);
380         Transfer(addressIco, address(0), remainingTokens);
381     }
382 
383     /**
384     * @dev Burn all tokens form balance of token holder during refund process.
385     * @param _from The address of token holder whose tokens to be burned.
386     */
387     function burnFromAddress(address _from) onlyIco public {
388         uint256 amount = balances[_from];
389 
390         balances[_from] = 0;
391         totalSupply_ = totalSupply_.sub(amount);
392         Transfer(_from, address(0), amount);
393     }
394 }
395 
396 // File: contracts/Whitelist.sol
397 
398 /**
399  * @title Whitelist contract
400  * @dev Whitelist for wallets.
401 */
402 contract Whitelist is Ownable {
403     mapping(address => bool) whitelist;
404 
405     uint256 public whitelistLength = 0;
406 
407     /**
408     * @dev Add wallet to whitelist.
409     * @dev Accept request from the owner only.
410     * @param _wallet The address of wallet to add.
411     */  
412     function addWallet(address _wallet) onlyOwner public {
413         require(_wallet != address(0));
414         require(!isWhitelisted(_wallet));
415         whitelist[_wallet] = true;
416         whitelistLength++;
417     }
418 
419     /**
420     * @dev Remove wallet from whitelist.
421     * @dev Accept request from the owner only.
422     * @param _wallet The address of whitelisted wallet to remove.
423     */  
424     function removeWallet(address _wallet) onlyOwner public {
425         require(_wallet != address(0));
426         require(isWhitelisted(_wallet));
427         whitelist[_wallet] = false;
428         whitelistLength--;
429     }
430 
431     /**
432     * @dev Check the specified wallet whether it is in the whitelist.
433     * @param _wallet The address of wallet to check.
434     */ 
435     function isWhitelisted(address _wallet) constant public returns (bool) {
436         return whitelist[_wallet];
437     }
438 
439 }
440 
441 // File: contracts/Whitelistable.sol
442 
443 contract Whitelistable {
444     Whitelist public whitelist;
445 
446     modifier whenWhitelisted(address _wallet) {
447         require(whitelist.isWhitelisted(_wallet));
448         _;
449     }
450 
451     /**
452     * @dev Constructor for Whitelistable contract.
453     */
454     function Whitelistable() public {
455         whitelist = new Whitelist();
456     }
457 }
458 
459 // File: contracts/CurrentCrowdsale.sol
460 
461 contract CurrentCrowdsale is Pausable, Whitelistable {
462     using SafeMath for uint256;
463 
464     uint256 constant private DECIMALS = 18;
465     uint256 constant public RESERVED_TOKENS_FOUNDERS = 40e9 * (10 ** DECIMALS);
466     uint256 constant public RESERVED_TOKENS_OPERATIONAL_EXPENSES = 10e9 * (10 ** DECIMALS);
467     uint256 constant public HARDCAP_TOKENS_PRE_ICO = 100e6 * (10 ** DECIMALS);
468     uint256 constant public HARDCAP_TOKENS_ICO = 499e8 * (10 ** DECIMALS);
469 
470     uint256 public startTimePreIco = 0;
471     uint256 public endTimePreIco = 0;
472 
473     uint256 public startTimeIco = 0;
474     uint256 public endTimeIco = 0;
475 
476     uint256 public exchangeRatePreIco = 0;
477 
478     bool public isTokenRateCalculated = false;
479 
480     uint256 public exchangeRateIco = 0;
481 
482     uint256 public mincap = 0;
483     uint256 public maxcap = 0;
484 
485     mapping(address => uint256) private investments;    
486 
487     uint256 public tokensSoldIco = 0;
488     uint256 public tokensRemainingIco = HARDCAP_TOKENS_ICO;
489     uint256 public tokensSoldTotal = 0;
490 
491     uint256 public weiRaisedPreIco = 0;
492     uint256 public weiRaisedIco = 0;
493     uint256 public weiRaisedTotal = 0;
494 
495     mapping(address => uint256) private investmentsPreIco;
496     address[] private investorsPreIco;
497 
498     address private withdrawalWallet;
499 
500     bool public isTokensPreIcoDistributed = false;
501     uint256 public distributionPreIcoCount = 0;
502 
503     CurrentToken public token = new CurrentToken(this);
504 
505     modifier beforeReachingHardCap() {
506         require(tokensRemainingIco > 0 && weiRaisedTotal < maxcap);
507         _;
508     }
509 
510     modifier whenPreIcoSaleHasEnded() {
511         require(now > endTimePreIco);
512         _;
513     }
514 
515     modifier whenIcoSaleHasEnded() {
516         require(endTimeIco > 0 && now > endTimeIco);
517         _;
518     }
519 
520     /**
521     * @dev Constructor for CurrentCrowdsale contract.
522     * @dev Set the owner who can manage whitelist and token.
523     * @param _mincap The mincap value.
524     * @param _startTimePreIco The pre-ICO start time.
525     * @param _endTimePreIco The pre-ICO end time.
526     * @param _foundersWallet The address to which reserved tokens for founders will be transferred.
527     * @param _operationalExpensesWallet The address to which reserved tokens for operational expenses will be transferred.
528     * @param _withdrawalWallet The address to which raised funds will be withdrawn.
529     */
530     function CurrentCrowdsale(
531         uint256 _mincap,
532         uint256 _maxcap,
533         uint256 _startTimePreIco,
534         uint256 _endTimePreIco,
535         address _foundersWallet,
536         address _operationalExpensesWallet,
537         address _withdrawalWallet
538     ) Whitelistable() public
539     {
540         require(_foundersWallet != address(0) && _operationalExpensesWallet != address(0) && _withdrawalWallet != address(0));
541         require(_startTimePreIco >= now && _endTimePreIco > _startTimePreIco);
542         require(_mincap > 0 && _maxcap > _mincap);
543 
544         startTimePreIco = _startTimePreIco;
545         endTimePreIco = _endTimePreIco;
546 
547         withdrawalWallet = _withdrawalWallet;
548 
549         mincap = _mincap;
550         maxcap = _maxcap;
551 
552         whitelist.transferOwnership(msg.sender);
553 
554         token.transferFromIco(_foundersWallet, RESERVED_TOKENS_FOUNDERS);
555         token.transferFromIco(_operationalExpensesWallet, RESERVED_TOKENS_OPERATIONAL_EXPENSES);
556         token.transferOwnership(msg.sender);
557     }
558 
559     /**
560     * @dev Fallback function can be used to buy tokens.
561     */
562     function() public payable {
563         if (isPreIco()) {
564             sellTokensPreIco();
565         } else if (isIco()) {
566             sellTokensIco();
567         } else {
568             revert();
569         }
570     }
571 
572     /**
573     * @dev Check whether the pre-ICO is active at the moment.
574     */
575     function isPreIco() public constant returns (bool) {
576         bool withinPreIco = now >= startTimePreIco && now <= endTimePreIco;
577         return withinPreIco;
578     }
579 
580     /**
581     * @dev Check whether the ICO is active at the moment.
582     */
583     function isIco() public constant returns (bool) {
584         bool withinIco = now >= startTimeIco && now <= endTimeIco;
585         return withinIco;
586     }
587 
588     /**
589     * @dev Manual refund if mincap has not been reached.
590     * @dev Only applies when the ICO was ended. 
591     */
592     function manualRefund() whenIcoSaleHasEnded public {
593         require(weiRaisedTotal < mincap);
594 
595         uint256 weiAmountTotal = investments[msg.sender];
596         require(weiAmountTotal > 0);
597 
598         investments[msg.sender] = 0;
599 
600         uint256 weiAmountPreIco = investmentsPreIco[msg.sender];
601         uint256 weiAmountIco = weiAmountTotal;
602 
603         if (weiAmountPreIco > 0) {
604             investmentsPreIco[msg.sender] = 0;
605             weiRaisedPreIco = weiRaisedPreIco.sub(weiAmountPreIco);
606             weiAmountIco = weiAmountIco.sub(weiAmountPreIco);
607         }
608 
609         if (weiAmountIco > 0) {
610             weiRaisedIco = weiRaisedIco.sub(weiAmountIco);
611             uint256 tokensIco = weiAmountIco.mul(exchangeRateIco);
612             tokensSoldIco = tokensSoldIco.sub(tokensIco);
613         }
614 
615         weiRaisedTotal = weiRaisedTotal.sub(weiAmountTotal);
616 
617         uint256 tokensAmount = token.balanceOf(msg.sender);
618 
619         tokensSoldTotal = tokensSoldTotal.sub(tokensAmount);
620 
621         token.burnFromAddress(msg.sender);
622 
623         msg.sender.transfer(weiAmountTotal);
624     }
625 
626     /**
627     * @dev Sell tokens during pre-ICO.
628     * @dev Sell tokens only for whitelisted wallets.
629     */
630     function sellTokensPreIco() beforeReachingHardCap whenWhitelisted(msg.sender) whenNotPaused public payable {
631         require(isPreIco());
632         require(msg.value > 0);
633 
634         uint256 weiAmount = msg.value;
635         uint256 excessiveFunds = 0;
636 
637         uint256 plannedWeiTotal = weiRaisedTotal.add(weiAmount);
638 
639         if (plannedWeiTotal > maxcap) {
640             excessiveFunds = plannedWeiTotal.sub(maxcap);
641             weiAmount = maxcap.sub(weiRaisedTotal);
642         }
643 
644         investments[msg.sender] = investments[msg.sender].add(weiAmount);
645 
646         weiRaisedPreIco = weiRaisedPreIco.add(weiAmount);
647         weiRaisedTotal = weiRaisedTotal.add(weiAmount);
648 
649         addInvestmentPreIco(msg.sender, weiAmount);
650 
651         if (excessiveFunds > 0) {
652             msg.sender.transfer(excessiveFunds);
653         }
654     }
655 
656     /**
657     * @dev Sell tokens during ICO.
658     * @dev Sell tokens only for whitelisted wallets.
659     */
660     function sellTokensIco() beforeReachingHardCap whenWhitelisted(msg.sender) whenNotPaused public payable {
661         require(isIco());
662         require(msg.value > 0);
663 
664         uint256 weiAmount = msg.value;
665         uint256 excessiveFunds = 0;
666 
667         uint256 plannedWeiTotal = weiRaisedTotal.add(weiAmount);
668 
669         if (plannedWeiTotal > maxcap) {
670             excessiveFunds = plannedWeiTotal.sub(maxcap);
671             weiAmount = maxcap.sub(weiRaisedTotal);
672         }
673 
674         uint256 tokensAmount = weiAmount.mul(exchangeRateIco);
675 
676         if (tokensAmount > tokensRemainingIco) {
677             uint256 weiToAccept = tokensRemainingIco.div(exchangeRateIco);
678             excessiveFunds = excessiveFunds.add(weiAmount.sub(weiToAccept));
679             
680             tokensAmount = tokensRemainingIco;
681             weiAmount = weiToAccept;
682         }
683 
684         investments[msg.sender] = investments[msg.sender].add(weiAmount);
685 
686         tokensSoldIco = tokensSoldIco.add(tokensAmount);
687         tokensSoldTotal = tokensSoldTotal.add(tokensAmount);
688         tokensRemainingIco = tokensRemainingIco.sub(tokensAmount);
689 
690         weiRaisedIco = weiRaisedIco.add(weiAmount);
691         weiRaisedTotal = weiRaisedTotal.add(weiAmount);
692 
693         token.transferFromIco(msg.sender, tokensAmount);
694 
695         if (excessiveFunds > 0) {
696             msg.sender.transfer(excessiveFunds);
697         }
698     }
699 
700     /**
701     * @dev Send raised funds to the withdrawal wallet.
702     */
703     function forwardFunds() onlyOwner public {
704         require(weiRaisedTotal >= mincap);
705         withdrawalWallet.transfer(this.balance);
706     }
707 
708     /**
709     * @dev Calculate token exchange rate for pre-ICO and ICO.
710     * @dev Only applies when the pre-ICO was ended.
711     * @dev May be called only once.
712     */
713     function calcTokenRate() whenPreIcoSaleHasEnded onlyOwner public {
714         require(!isTokenRateCalculated);
715         require(weiRaisedPreIco > 0);
716 
717         exchangeRatePreIco = HARDCAP_TOKENS_PRE_ICO.div(weiRaisedPreIco);
718 
719         exchangeRateIco = exchangeRatePreIco.div(2);
720 
721         isTokenRateCalculated = true;
722     }
723 
724     /**
725     * @dev Distribute tokens to pre-ICO investors using pagination.
726     * @dev Pagination proceeds the set value (paginationCount) of tokens distributions per one function call.
727     * @param _paginationCount The value that used for pagination.
728     */
729     function distributeTokensPreIco(uint256 _paginationCount) onlyOwner public {
730         require(isTokenRateCalculated && !isTokensPreIcoDistributed);
731         require(_paginationCount > 0);
732 
733         uint256 count = 0;
734         for (uint256 i = distributionPreIcoCount; i < getPreIcoInvestorsCount(); i++) {
735             if (count == _paginationCount) {
736                 break;
737             }
738             uint256 investment = getPreIcoInvestment(getPreIcoInvestor(i));
739             uint256 tokensAmount = investment.mul(exchangeRatePreIco);
740             
741             tokensSoldTotal = tokensSoldTotal.add(tokensAmount);
742 
743             token.transferFromIco(getPreIcoInvestor(i), tokensAmount);
744 
745             count++;
746         }
747 
748         distributionPreIcoCount = distributionPreIcoCount.add(count);
749 
750         if (distributionPreIcoCount == getPreIcoInvestorsCount()) {
751             isTokensPreIcoDistributed = true;
752         }
753     }
754 
755     /**
756     * @dev Burn unsold tokens from the ICO balance.
757     * @dev Only applies when the ICO was ended.
758     */
759     function burnUnsoldTokens() whenIcoSaleHasEnded onlyOwner public {
760         require(tokensRemainingIco > 0);
761         token.burnFromIco();
762         tokensRemainingIco = 0;
763     }
764 
765     /**
766     * @dev Count the pre-ICO investors total.
767     */
768     function getPreIcoInvestorsCount() constant public returns (uint256) {
769         return investorsPreIco.length;
770     }
771 
772     /**
773     * @dev Get the pre-ICO investor address.
774     * @param _index the index of investor in the array. 
775     */
776     function getPreIcoInvestor(uint256 _index) constant public returns (address) {
777         return investorsPreIco[_index];
778     }
779 
780     /**
781     * @dev Gets the amount of tokens for pre-ICO investor.
782     * @param _investorPreIco the pre-ICO investor address.
783     */
784     function getPreIcoInvestment(address _investorPreIco) constant public returns (uint256) {
785         return investmentsPreIco[_investorPreIco];
786     }
787 
788     /**
789     * @dev Set start time and end time for ICO.
790     * @dev Only applies when tokens distributions to pre-ICO investors were processed.
791     * @param _startTimeIco The ICO start time.
792     * @param _endTimeIco The ICO end time.
793     */
794     function setStartTimeIco(uint256 _startTimeIco, uint256 _endTimeIco) whenPreIcoSaleHasEnded beforeReachingHardCap onlyOwner public {
795         require(_startTimeIco >= now && _endTimeIco > _startTimeIco);
796         require(isTokenRateCalculated);
797 
798         startTimeIco = _startTimeIco;
799         endTimeIco = _endTimeIco;
800     }
801 
802     /**
803     * @dev Add new investment to the pre-ICO investments storage.
804     * @param _from The address of a pre-ICO investor.
805     * @param _value The investment received from a pre-ICO investor.
806     */
807     function addInvestmentPreIco(address _from, uint256 _value) internal {
808         if (investmentsPreIco[_from] == 0) {
809             investorsPreIco.push(_from);
810         }
811         investmentsPreIco[_from] = investmentsPreIco[_from].add(_value);
812     }  
813 }