1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     function Ownable() {
21         owner = msg.sender;
22     }
23 
24 
25     /**
26      * @dev Throws if called by any account other than the owner.
27      */
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33 
34     /**
35      * @dev Allows the current owner to transfer control of the contract to a newOwner.
36      * @param newOwner The address to transfer ownership to.
37      */
38     function transferOwnership(address newOwner) onlyOwner {
39         require(newOwner != address(0));
40         OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 
44 }
45 
46 contract usingMyWishConsts {
47     uint constant TOKEN_DECIMALS = 18;
48     uint8 constant TOKEN_DECIMALS_UINT8 = 18;
49     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
50 
51     uint constant TEAM_TOKENS =   3161200 * TOKEN_DECIMAL_MULTIPLIER;
52     uint constant BOUNTY_TOKENS = 2000000 * TOKEN_DECIMAL_MULTIPLIER;
53     uint constant PREICO_TOKENS = 3038800 * TOKEN_DECIMAL_MULTIPLIER;
54     uint constant MINIMAL_PURCHASE = 0.05 ether;
55 
56     address constant TEAM_ADDRESS = 0xE4F0Ff4641f3c99de342b06c06414d94A585eFfb;
57     address constant BOUNTY_ADDRESS = 0x76d4136d6EE53DB4cc087F2E2990283d5317A5e9;
58     address constant PREICO_ADDRESS = 0x195610851A43E9685643A8F3b49F0F8a019204f1;
59     address constant COLD_WALLET = 0x80826b5b717aDd3E840343364EC9d971FBa3955C;
60 
61     string constant TOKEN_NAME = "MyWish Token";
62     bytes32 constant TOKEN_SYMBOL = "WISH";
63 }
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
70     uint256 c = a * b;
71     assert(a == 0 || c / a == b);
72     return c;
73   }
74 
75   function div(uint256 a, uint256 b) internal constant returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return c;
80   }
81 
82   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   function add(uint256 a, uint256 b) internal constant returns (uint256) {
88     uint256 c = a + b;
89     assert(c >= a);
90     return c;
91   }
92 }
93 
94 /**
95  * @title ERC20Basic
96  * @dev Simpler version of ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/179
98  */
99 contract ERC20Basic {
100   uint256 public totalSupply;
101   function balanceOf(address who) constant returns (uint256);
102   function transfer(address to, uint256 value) returns (bool);
103   event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) constant returns (uint256);
112   function transferFrom(address from, address to, uint256 value) returns (bool);
113   function approve(address spender, uint256 value) returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 /**
117  * @title Basic token
118  * @dev Basic version of StandardToken, with no allowances. 
119  */
120 contract BasicToken is ERC20Basic {
121     using SafeMath for uint256;
122 
123     mapping (address => uint256) balances;
124 
125     /**
126     * @dev transfer token for a specified address
127     * @param _to The address to transfer to.
128     * @param _value The amount to be transferred.
129     */
130     function transfer(address _to, uint256 _value) returns (bool) {
131         require(_to != address(0));
132 
133         // SafeMath.sub will throw if there is not enough balance.
134         balances[msg.sender] = balances[msg.sender].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         Transfer(msg.sender, _to, _value);
137         return true;
138     }
139 
140     /**
141     * @dev Gets the balance of the specified address.
142     * @param _owner The address to query the the balance of.
143     * @return An uint256 representing the amount owned by the passed address.
144     */
145     function balanceOf(address _owner) constant returns (uint256 balance) {
146         return balances[_owner];
147     }
148 
149 }
150 
151 /**
152  * @title Standard ERC20 token
153  *
154  * @dev Implementation of the basic standard token.
155  * @dev https://github.com/ethereum/EIPs/issues/20
156  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
157  */
158 contract StandardToken is ERC20, BasicToken {
159 
160     mapping (address => mapping (address => uint256)) allowed;
161 
162 
163     /**
164      * @dev Transfer tokens from one address to another
165      * @param _from address The address which you want to send tokens from
166      * @param _to address The address which you want to transfer to
167      * @param _value uint256 the amount of tokens to be transferred
168      */
169     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
170         require(_to != address(0));
171 
172         var _allowance = allowed[_from][msg.sender];
173 
174         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
175         // require (_value <= _allowance);
176 
177         balances[_from] = balances[_from].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         allowed[_from][msg.sender] = _allowance.sub(_value);
180         Transfer(_from, _to, _value);
181         return true;
182     }
183 
184     /**
185      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186      * @param _spender The address which will spend the funds.
187      * @param _value The amount of tokens to be spent.
188      */
189     function approve(address _spender, uint256 _value) returns (bool) {
190 
191         // To change the approve amount you first have to reduce the addresses`
192         //  allowance to zero by calling `approve(_spender, 0)` if it is not
193         //  already 0 to mitigate the race condition described here:
194         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
196 
197         allowed[msg.sender][_spender] = _value;
198         Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     /**
203      * @dev Function to check the amount of tokens that an owner allowed to a spender.
204      * @param _owner address The address which owns the funds.
205      * @param _spender address The address which will spend the funds.
206      * @return A uint256 specifying the amount of tokens still available for the spender.
207      */
208     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
209         return allowed[_owner][_spender];
210     }
211 
212     /**
213      * approve should be called when allowed[_spender] == 0. To increment
214      * allowed value is better to use this function to avoid 2 calls (and wait until
215      * the first transaction is mined)
216      * From MonolithDAO Token.sol
217      */
218     function increaseApproval(address _spender, uint _addedValue) returns (bool success) {
219         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
220         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221         return true;
222     }
223 
224     function decreaseApproval(address _spender, uint _subtractedValue) returns (bool success) {
225         uint oldValue = allowed[msg.sender][_spender];
226         if (_subtractedValue > oldValue) {
227             allowed[msg.sender][_spender] = 0;
228         }
229         else {
230             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231         }
232         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233         return true;
234     }
235 
236 }
237 
238 /**
239  * @title Mintable token
240  * @dev Simple ERC20 Token example, with mintable token creation
241  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
242  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
243  */
244 
245 contract MintableToken is StandardToken, Ownable {
246     event Mint(address indexed to, uint256 amount);
247 
248     event MintFinished();
249 
250     bool public mintingFinished = false;
251 
252 
253     modifier canMint() {
254         require(!mintingFinished);
255         _;
256     }
257 
258     /**
259      * @dev Function to mint tokens
260      * @param _to The address that will receive the minted tokens.
261      * @param _amount The amount of tokens to mint.
262      * @return A boolean that indicates if the operation was successful.
263      */
264     function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
265         totalSupply = totalSupply.add(_amount);
266         balances[_to] = balances[_to].add(_amount);
267         Mint(_to, _amount);
268         Transfer(0x0, _to, _amount);
269         return true;
270     }
271 
272     /**
273      * @dev Function to stop minting new tokens.
274      * @return True if the operation was successful.
275      */
276     function finishMinting() onlyOwner returns (bool) {
277         mintingFinished = true;
278         MintFinished();
279         return true;
280     }
281 }
282 
283 /**
284  * @title Burnable Token
285  * @dev Token that can be irreversibly burned (destroyed).
286  */
287 contract BurnableToken is StandardToken {
288 
289     event Burn(address indexed burner, uint256 value);
290 
291     /**
292      * @dev Burns a specific amount of tokens.
293      * @param _value The amount of token to be burned.
294      */
295     function burn(uint256 _value) public {
296         require(_value > 0);
297 
298         address burner = msg.sender;
299         balances[burner] = balances[burner].sub(_value);
300         totalSupply = totalSupply.sub(_value);
301         Burn(burner, _value);
302     }
303 }
304 
305 contract MyWishToken is usingMyWishConsts, MintableToken, BurnableToken {
306     /**
307      * @dev Pause token transfer. After successfully finished crowdsale it becomes true.
308      */
309     bool public paused = true;
310     /**
311      * @dev Accounts who can transfer token even if paused. Works only during crowdsale.
312      */
313     mapping(address => bool) excluded;
314 
315     function name() constant public returns (string _name) {
316         return TOKEN_NAME;
317     }
318 
319     function symbol() constant public returns (bytes32 _symbol) {
320         return TOKEN_SYMBOL;
321     }
322 
323     function decimals() constant public returns (uint8 _decimals) {
324         return TOKEN_DECIMALS_UINT8;
325     }
326 
327     function crowdsaleFinished() onlyOwner {
328         paused = false;
329         finishMinting();
330     }
331 
332     function addExcluded(address _toExclude) onlyOwner {
333         excluded[_toExclude] = true;
334     }
335 
336     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
337         require(!paused || excluded[_from]);
338         return super.transferFrom(_from, _to, _value);
339     }
340 
341     function transfer(address _to, uint256 _value) returns (bool) {
342         require(!paused || excluded[msg.sender]);
343         return super.transfer(_to, _value);
344     }
345 
346     /**
347      * @dev Burn tokens from the specified address.
348      * @param _from     address The address which you want to burn tokens from.
349      * @param _value    uint    The amount of tokens to be burned.
350      */
351     function burnFrom(address _from, uint256 _value) returns (bool) {
352         require(_value > 0);
353         var allowance = allowed[_from][msg.sender];
354         balances[_from] = balances[_from].sub(_value);
355         totalSupply = totalSupply.sub(_value);
356         allowed[_from][msg.sender] = allowance.sub(_value);
357         Burn(_from, _value);
358         return true;
359     }
360 }
361 contract MyWishRateProviderI {
362     /**
363      * @dev Calculate actual rate using the specified parameters.
364      * @param buyer     Investor (buyer) address.
365      * @param totalSold Amount of sold tokens.
366      * @param amountWei Amount of wei to purchase.
367      * @return ETH to Token rate.
368      */
369     function getRate(address buyer, uint totalSold, uint amountWei) public constant returns (uint);
370 
371     /**
372      * @dev rate scale (or divider), to support not integer rates.
373      * @return Rate divider.
374      */
375     function getRateScale() public constant returns (uint);
376 
377     /**
378      * @return Absolute base rate.
379      */
380     function getBaseRate() public constant returns (uint);
381 }
382 
383 contract MyWishRateProvider is usingMyWishConsts, MyWishRateProviderI, Ownable {
384     // rate calculate accuracy
385     uint constant RATE_SCALE = 10000;
386     uint constant STEP_30 = 3200000 * TOKEN_DECIMAL_MULTIPLIER;
387     uint constant STEP_20 = 6400000 * TOKEN_DECIMAL_MULTIPLIER;
388     uint constant STEP_10 = 9600000 * TOKEN_DECIMAL_MULTIPLIER;
389     uint constant RATE_30 = 1950 * RATE_SCALE;
390     uint constant RATE_20 = 1800 * RATE_SCALE;
391     uint constant RATE_10 = 1650 * RATE_SCALE;
392     uint constant BASE_RATE = 1500 * RATE_SCALE;
393 
394     struct ExclusiveRate {
395         // be careful, accuracies this about 15 minutes
396         uint32 workUntil;
397         // exclusive rate or 0
398         uint rate;
399         // rate bonus percent, which will be divided by 1000 or 0
400         uint16 bonusPercent1000;
401         // flag to check, that record exists
402         bool exists;
403     }
404 
405     mapping(address => ExclusiveRate) exclusiveRate;
406 
407     function getRateScale() public constant returns (uint) {
408         return RATE_SCALE;
409     }
410 
411     function getBaseRate() public constant returns (uint) {
412         return BASE_RATE;
413     }
414 
415     function getRate(address buyer, uint totalSold, uint amountWei) public constant returns (uint) {
416         uint rate;
417         // apply sale
418         if (totalSold < STEP_30) {
419             rate = RATE_30;
420         }
421         else if (totalSold < STEP_20) {
422             rate = RATE_20;
423         }
424         else if (totalSold < STEP_10) {
425             rate = RATE_10;
426         }
427         else {
428             rate = BASE_RATE;
429         }
430 
431         // apply bonus for amount
432         if (amountWei >= 1000 ether) {
433             rate += rate * 13 / 100;
434         }
435         else if (amountWei >= 500 ether) {
436             rate += rate * 10 / 100;
437         }
438         else if (amountWei >= 100 ether) {
439             rate += rate * 7 / 100;
440         }
441         else if (amountWei >= 50 ether) {
442             rate += rate * 5 / 100;
443         }
444         else if (amountWei >= 30 ether) {
445             rate += rate * 4 / 100;
446         }
447         else if (amountWei >= 10 ether) {
448             rate += rate * 25 / 1000;
449         }
450 
451         ExclusiveRate memory eRate = exclusiveRate[buyer];
452         if (eRate.exists && eRate.workUntil >= now) {
453             if (eRate.rate != 0) {
454                 rate = eRate.rate;
455             }
456             rate += rate * eRate.bonusPercent1000 / 1000;
457         }
458         return rate;
459     }
460 
461     function setExclusiveRate(address _investor, uint _rate, uint16 _bonusPercent1000, uint32 _workUntil) onlyOwner {
462         exclusiveRate[_investor] = ExclusiveRate(_workUntil, _rate, _bonusPercent1000, true);
463     }
464 
465     function removeExclusiveRate(address _investor) onlyOwner {
466         delete exclusiveRate[_investor];
467     }
468 }
469 /**
470  * @title Crowdsale 
471  * @dev Crowdsale is a base contract for managing a token crowdsale.
472  *
473  * Crowdsales have a start and end timestamps, where investors can make
474  * token purchases and the crowdsale will assign them tokens based
475  * on a token per ETH rate. Funds collected are forwarded to a wallet 
476  * as they arrive.
477  */
478 contract Crowdsale {
479     using SafeMath for uint;
480 
481     // The token being sold
482     MintableToken public token;
483 
484     // start and end timestamps where investments are allowed (both inclusive)
485     uint32 internal startTime;
486     uint32 internal endTime;
487 
488     // address where funds are collected
489     address public wallet;
490 
491     // amount of raised money in wei
492     uint public weiRaised;
493 
494     /**
495      * @dev Amount of already sold tokens.
496      */
497     uint public soldTokens;
498 
499     /**
500      * @dev Maximum amount of tokens to mint.
501      */
502     uint internal hardCap;
503 
504     /**
505      * event for token purchase logging
506      * @param purchaser who paid for the tokens
507      * @param beneficiary who got the tokens
508      * @param value weis paid for purchase
509      * @param amount amount of tokens purchased
510      */
511     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);
512 
513     function Crowdsale(uint _startTime, uint _endTime, uint _hardCap, address _wallet) {
514         require(_endTime >= _startTime);
515         require(_wallet != 0x0);
516         require(_hardCap > 0);
517 
518         token = createTokenContract();
519         startTime = uint32(_startTime);
520         endTime = uint32(_endTime);
521         hardCap = _hardCap;
522         wallet = _wallet;
523     }
524 
525     // creates the token to be sold.
526     // override this method to have crowdsale of a specific mintable token.
527     function createTokenContract() internal returns (MintableToken) {
528         return new MintableToken();
529     }
530 
531     /**
532      * @dev this method might be overridden for implementing any sale logic.
533      * @return Actual rate.
534      */
535     function getRate(uint amount) internal constant returns (uint);
536 
537     function getBaseRate() internal constant returns (uint);
538 
539     /**
540      * @dev rate scale (or divider), to support not integer rates.
541      * @return Rate divider.
542      */
543     function getRateScale() internal constant returns (uint) {
544         return 1;
545     }
546 
547     // fallback function can be used to buy tokens
548     function() payable {
549         buyTokens(msg.sender, msg.value);
550     }
551 
552     // low level token purchase function
553     function buyTokens(address beneficiary, uint amountWei) internal {
554         require(beneficiary != 0x0);
555 
556         // total minted tokens
557         uint totalSupply = token.totalSupply();
558 
559         // actual token minting rate (with considering bonuses and discounts)
560         uint actualRate = getRate(amountWei);
561         uint rateScale = getRateScale();
562 
563         require(validPurchase(amountWei, actualRate, totalSupply));
564 
565         // calculate token amount to be created
566         uint tokens = amountWei.mul(actualRate).div(rateScale);
567 
568         // update state
569         weiRaised = weiRaised.add(amountWei);
570         soldTokens = soldTokens.add(tokens);
571 
572         token.mint(beneficiary, tokens);
573         TokenPurchase(msg.sender, beneficiary, amountWei, tokens);
574 
575         forwardFunds(amountWei);
576     }
577 
578     // send ether to the fund collection wallet
579     // override to create custom fund forwarding mechanisms
580     function forwardFunds(uint amountWei) internal {
581         wallet.transfer(amountWei);
582     }
583 
584     /**
585      * @dev Check if the specified purchase is valid.
586      * @return true if the transaction can buy tokens
587      */
588     function validPurchase(uint _amountWei, uint _actualRate, uint _totalSupply) internal constant returns (bool) {
589         bool withinPeriod = now >= startTime && now <= endTime;
590         bool nonZeroPurchase = _amountWei != 0;
591         bool hardCapNotReached = _totalSupply <= hardCap;
592 
593         return withinPeriod && nonZeroPurchase && hardCapNotReached;
594     }
595 
596     /**
597      * @dev Because of discount hasEnded might be true, but validPurchase returns false.
598      * @return true if crowdsale event has ended
599      */
600     function hasEnded() public constant returns (bool) {
601         return now > endTime || token.totalSupply() > hardCap;
602     }
603 
604     /**
605      * @return true if crowdsale event has started
606      */
607     function hasStarted() public constant returns (bool) {
608         return now >= startTime;
609     }
610 }
611 
612 contract FinalizableCrowdsale is Crowdsale, Ownable {
613     using SafeMath for uint256;
614 
615     bool public isFinalized = false;
616 
617     event Finalized();
618 
619     function FinalizableCrowdsale(uint _startTime, uint _endTime, uint _hardCap, address _wallet)
620             Crowdsale(_startTime, _endTime, _hardCap, _wallet) {
621     }
622 
623     /**
624      * @dev Must be called after crowdsale ends, to do some extra finalization
625      * work. Calls the contract's finalization function.
626      */
627     function finalize() onlyOwner notFinalized {
628         require(hasEnded());
629 
630         finalization();
631         Finalized();
632 
633         isFinalized = true;
634     }
635 
636     /**
637      * @dev Can be overriden to add finalization logic. The overriding function
638      * should call super.finalization() to ensure the chain of finalization is
639      * executed entirely.
640      */
641     function finalization() internal {
642     }
643 
644     modifier notFinalized() {
645         require(!isFinalized);
646         _;
647     }
648 }
649 
650 contract MyWishCrowdsale is usingMyWishConsts, FinalizableCrowdsale {
651     MyWishRateProviderI public rateProvider;
652 
653     function MyWishCrowdsale(
654             uint _startTime,
655             uint _endTime,
656             uint _hardCapTokens
657     )
658             FinalizableCrowdsale(_startTime, _endTime, _hardCapTokens * TOKEN_DECIMAL_MULTIPLIER, COLD_WALLET) {
659 
660         token.mint(TEAM_ADDRESS, TEAM_TOKENS);
661         token.mint(BOUNTY_ADDRESS, BOUNTY_TOKENS);
662         token.mint(PREICO_ADDRESS, PREICO_TOKENS);
663 
664         MyWishToken(token).addExcluded(TEAM_ADDRESS);
665         MyWishToken(token).addExcluded(BOUNTY_ADDRESS);
666         MyWishToken(token).addExcluded(PREICO_ADDRESS);
667 
668         MyWishRateProvider provider = new MyWishRateProvider();
669         provider.transferOwnership(owner);
670         rateProvider = provider;
671     }
672 
673     /**
674      * @dev override token creation to integrate with MyWill token.
675      */
676     function createTokenContract() internal returns (MintableToken) {
677         return new MyWishToken();
678     }
679 
680     /**
681      * @dev override getRate to integrate with rate provider.
682      */
683     function getRate(uint _value) internal constant returns (uint) {
684         return rateProvider.getRate(msg.sender, soldTokens, _value);
685     }
686 
687     function getBaseRate() internal constant returns (uint) {
688         return rateProvider.getRate(msg.sender, soldTokens, MINIMAL_PURCHASE);
689     }
690 
691     /**
692      * @dev override getRateScale to integrate with rate provider.
693      */
694     function getRateScale() internal constant returns (uint) {
695         return rateProvider.getRateScale();
696     }
697 
698     /**
699      * @dev Admin can set new rate provider.
700      * @param _rateProviderAddress New rate provider.
701      */
702     function setRateProvider(address _rateProviderAddress) onlyOwner {
703         require(_rateProviderAddress != 0);
704         rateProvider = MyWishRateProviderI(_rateProviderAddress);
705     }
706 
707     /**
708      * @dev Admin can move end time.
709      * @param _endTime New end time.
710      */
711     function setEndTime(uint _endTime) onlyOwner notFinalized {
712         require(_endTime > startTime);
713         endTime = uint32(_endTime);
714     }
715 
716     function setHardCap(uint _hardCapTokens) onlyOwner notFinalized {
717         require(_hardCapTokens * TOKEN_DECIMAL_MULTIPLIER > hardCap);
718         hardCap = _hardCapTokens * TOKEN_DECIMAL_MULTIPLIER;
719     }
720 
721     function setStartTime(uint _startTime) onlyOwner notFinalized {
722         require(_startTime < endTime);
723         startTime = uint32(_startTime);
724     }
725 
726     function addExcluded(address _address) onlyOwner notFinalized {
727         MyWishToken(token).addExcluded(_address);
728     }
729 
730     function validPurchase(uint _amountWei, uint _actualRate, uint _totalSupply) internal constant returns (bool) {
731         if (_amountWei < MINIMAL_PURCHASE) {
732             return false;
733         }
734         return super.validPurchase(_amountWei, _actualRate, _totalSupply);
735     }
736 
737     function finalization() internal {
738         super.finalization();
739         token.finishMinting();
740         MyWishToken(token).crowdsaleFinished();
741         token.transferOwnership(owner);
742     }
743 }