1 pragma solidity ^0.4.18;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8     address public owner;
9 
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     function Ownable() {
19         owner = msg.sender;
20     }
21 
22 
23     /**
24      * @dev Throws if called by any account other than the owner.
25      */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31 
32     /**
33      * @dev Allows the current owner to transfer control of the contract to a newOwner.
34      * @param newOwner The address to transfer ownership to.
35      */
36     function transferOwnership(address newOwner) onlyOwner {
37         require(newOwner != address(0));
38         OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 
42 }
43 
44 contract usingEthereumV2Erc20Consts {
45     uint constant TOKEN_DECIMALS = 18;
46     uint8 constant TOKEN_DECIMALS_UINT8 = 18;
47     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
48 
49     uint constant TEAM_TOKENS =   0 * TOKEN_DECIMAL_MULTIPLIER;
50     uint constant BOUNTY_TOKENS = 0 * TOKEN_DECIMAL_MULTIPLIER;
51     uint constant PREICO_TOKENS = 0 * TOKEN_DECIMAL_MULTIPLIER;
52     uint constant MINIMAL_PURCHASE = 0.00001 ether;
53 
54     address constant TEAM_ADDRESS = 0x78cd8f794686ee8f6644447e961ef52776edf0cb;
55     address constant BOUNTY_ADDRESS = 0xff823588500d3ecd7777a1cfa198958df4deea11;
56     address constant PREICO_ADDRESS = 0xff823588500d3ecd7777a1cfa198958df4deea11;
57     address constant COLD_WALLET = 0x439415b03708bde585856b46666f34b65af6a5c3;
58 
59     string constant TOKEN_NAME = "Ethereum V2 Erc20";
60     bytes32 constant TOKEN_SYMBOL = "ETH20";
61 }
62 /**
63  * @title SafeMath
64  * @dev Math operations with safety checks that throw on error
65  */
66 library SafeMath {
67   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
68     uint256 c = a * b;
69     assert(a == 0 || c / a == b);
70     return c;
71   }
72 
73   function div(uint256 a, uint256 b) internal constant returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return c;
78   }
79 
80   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   function add(uint256 a, uint256 b) internal constant returns (uint256) {
86     uint256 c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   uint256 public totalSupply;
99   function balanceOf(address who) constant returns (uint256);
100   function transfer(address to, uint256 value) returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) constant returns (uint256);
110   function transferFrom(address from, address to, uint256 value) returns (bool);
111   function approve(address spender, uint256 value) returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances. 
117  */
118 contract BasicToken is ERC20Basic {
119     using SafeMath for uint256;
120 
121     mapping (address => uint256) balances;
122 
123     /**
124     * @dev transfer token for a specified address
125     * @param _to The address to transfer to.
126     * @param _value The amount to be transferred.
127     */
128     function transfer(address _to, uint256 _value) returns (bool) {
129         require(_to != address(0));
130 
131         // SafeMath.sub will throw if there is not enough balance.
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         Transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138     /**
139     * @dev Gets the balance of the specified address.
140     * @param _owner The address to query the the balance of.
141     * @return An uint256 representing the amount owned by the passed address.
142     */
143     function balanceOf(address _owner) constant returns (uint256 balance) {
144         return balances[_owner];
145     }
146 
147 }
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158     mapping (address => mapping (address => uint256)) allowed;
159 
160 
161     /**
162      * @dev Transfer tokens from one address to another
163      * @param _from address The address which you want to send tokens from
164      * @param _to address The address which you want to transfer to
165      * @param _value uint256 the amount of tokens to be transferred
166      */
167     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
168         require(_to != address(0));
169 
170         var _allowance = allowed[_from][msg.sender];
171 
172         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
173         // require (_value <= _allowance);
174 
175         balances[_from] = balances[_from].sub(_value);
176         balances[_to] = balances[_to].add(_value);
177         allowed[_from][msg.sender] = _allowance.sub(_value);
178         Transfer(_from, _to, _value);
179         return true;
180     }
181 
182     /**
183      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
184      * @param _spender The address which will spend the funds.
185      * @param _value The amount of tokens to be spent.
186      */
187     function approve(address _spender, uint256 _value) returns (bool) {
188 
189         // To change the approve amount you first have to reduce the addresses`
190         //  allowance to zero by calling `approve(_spender, 0)` if it is not
191         //  already 0 to mitigate the race condition described here:
192         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
194 
195         allowed[msg.sender][_spender] = _value;
196         Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200     /**
201      * @dev Function to check the amount of tokens that an owner allowed to a spender.
202      * @param _owner address The address which owns the funds.
203      * @param _spender address The address which will spend the funds.
204      * @return A uint256 specifying the amount of tokens still available for the spender.
205      */
206     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
207         return allowed[_owner][_spender];
208     }
209 
210     /**
211      * approve should be called when allowed[_spender] == 0. To increment
212      * allowed value is better to use this function to avoid 2 calls (and wait until
213      * the first transaction is mined)
214      * From MonolithDAO Token.sol
215      */
216     function increaseApproval(address _spender, uint _addedValue) returns (bool success) {
217         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
218         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219         return true;
220     }
221 
222     function decreaseApproval(address _spender, uint _subtractedValue) returns (bool success) {
223         uint oldValue = allowed[msg.sender][_spender];
224         if (_subtractedValue > oldValue) {
225             allowed[msg.sender][_spender] = 0;
226         }
227         else {
228             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
229         }
230         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231         return true;
232     }
233 
234 }
235 
236 /**
237  * @title Mintable token
238  * @dev Simple ERC20 Token example, with mintable token creation
239  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
240  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
241  */
242 
243 contract MintableToken is StandardToken, Ownable {
244     event Mint(address indexed to, uint256 amount);
245 
246     event MintFinished();
247 
248     bool public mintingFinished = false;
249 
250 
251     modifier canMint() {
252         require(!mintingFinished);
253         _;
254     }
255 
256     /**
257      * @dev Function to mint tokens
258      * @param _to The address that will receive the minted tokens.
259      * @param _amount The amount of tokens to mint.
260      * @return A boolean that indicates if the operation was successful.
261      */
262     function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
263         totalSupply = totalSupply.add(_amount);
264         balances[_to] = balances[_to].add(_amount);
265         Mint(_to, _amount);
266         Transfer(0x0, _to, _amount);
267         return true;
268     }
269 
270     /**
271      * @dev Function to stop minting new tokens.
272      * @return True if the operation was successful.
273      */
274     function finishMinting() onlyOwner returns (bool) {
275         mintingFinished = true;
276         MintFinished();
277         return true;
278     }
279 }
280 
281 /**
282  * @title Burnable Token
283  * @dev Token that can be irreversibly burned (destroyed).
284  */
285 contract BurnableToken is StandardToken {
286 
287     event Burn(address indexed burner, uint256 value);
288 
289     /**
290      * @dev Burns a specific amount of tokens.
291      * @param _value The amount of token to be burned.
292      */
293     function burn(uint256 _value) public {
294         require(_value > 0);
295 
296         address burner = msg.sender;
297         balances[burner] = balances[burner].sub(_value);
298         totalSupply = totalSupply.sub(_value);
299         Burn(burner, _value);
300     }
301 }
302 
303 contract EthereumV2Erc20 is usingEthereumV2Erc20Consts, MintableToken, BurnableToken {
304     /**
305      * @dev Pause token transfer. After successfully finished crowdsale it becomes true.
306      */
307     bool public paused = false;
308     /**
309      * @dev Accounts who can transfer token even if paused. Works only during crowdsale.
310      */
311     mapping(address => bool) excluded;
312 
313     function name() constant public returns (string _name) {
314         return TOKEN_NAME;
315     }
316 
317     function symbol() constant public returns (bytes32 _symbol) {
318         return TOKEN_SYMBOL;
319     }
320 
321     function decimals() constant public returns (uint8 _decimals) {
322         return TOKEN_DECIMALS_UINT8;
323     }
324 
325     function crowdsaleFinished() onlyOwner {
326         paused = false;
327         finishMinting();
328     }
329 
330     function addExcluded(address _toExclude) onlyOwner {
331         excluded[_toExclude] = true;
332     }
333 
334     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
335         require(!paused || excluded[_from]);
336         return super.transferFrom(_from, _to, _value);
337     }
338 
339     function transfer(address _to, uint256 _value) returns (bool) {
340         require(!paused || excluded[msg.sender]);
341         return super.transfer(_to, _value);
342     }
343 
344     /**
345      * @dev Burn tokens from the specified address.
346      * @param _from     address The address which you want to burn tokens from.
347      * @param _value    uint    The amount of tokens to be burned.
348      */
349     function burnFrom(address _from, uint256 _value) returns (bool) {
350         require(_value > 0);
351         var allowance = allowed[_from][msg.sender];
352         balances[_from] = balances[_from].sub(_value);
353         totalSupply = totalSupply.sub(_value);
354         allowed[_from][msg.sender] = allowance.sub(_value);
355         Burn(_from, _value);
356         return true;
357     }
358 }
359 contract EthereumV2Erc20RateProviderI {
360     /**
361      * @dev Calculate actual rate using the specified parameters.
362      * @param buyer     Investor (buyer) address.
363      * @param totalSold Amount of sold tokens.
364      * @param amountWei Amount of wei to purchase.
365      * @return ETH to Token rate.
366      */
367     function getRate(address buyer, uint totalSold, uint amountWei) public constant returns (uint);
368 
369     /**
370      * @dev rate scale (or divider), to support not integer rates.
371      * @return Rate divider.
372      */
373     function getRateScale() public constant returns (uint);
374 
375     /**
376      * @return Absolute base rate.
377      */
378     function getBaseRate() public constant returns (uint);
379 }
380 
381 contract EthereumV2Erc20RateProvider is usingEthereumV2Erc20Consts, EthereumV2Erc20RateProviderI, Ownable {
382     // rate calculate accuracy
383     uint constant RATE_SCALE = 1;
384     // Start time: Human time (GMT): Sunday, May 5, 2019 5:05:05 PM
385     // End time: Human time (GMT): Saturday, May 5, 2029 5:05:05 PM
386     
387     // Guaranteed by 100% ETH. 
388     // Contract to buy 100% token to burn off. 
389     // Service fee 2%. 98% of the funds were bought back by all contracts and then burned.
390     
391     uint constant STEP_9 =         50000 * TOKEN_DECIMAL_MULTIPLIER;           // Start from  0.00001      to  1.49 ETH         Price 100000 ETH20 = 1 ETH
392     uint constant STEP_8 =        150000 * TOKEN_DECIMAL_MULTIPLIER;         // Continue the next 0.5        - 2.99 ETH         Price  99000 ETH20 = 1 ETH
393     uint constant STEP_7 =       1150000 * TOKEN_DECIMAL_MULTIPLIER;         // Continue the next 1.5       - 19.99 ETH         Price  90000 ETH20 = 1 ETH
394     uint constant STEP_6 =      11150000 * TOKEN_DECIMAL_MULTIPLIER;        // Continue the next 11.5      - 199.99 ETH         Price  50000 ETH20 = 1 ETH
395     uint constant STEP_5 =     111150000 * TOKEN_DECIMAL_MULTIPLIER;       // Continue the next 111.5     - 1999.99 ETH         Price  10000 ETH20 = 1 ETH
396     uint constant STEP_4 =    1111150000 * TOKEN_DECIMAL_MULTIPLIER;      // Continue the next 1111.5    - 19999.99 ETH         Price   1000 ETH20 = 1 ETH
397     uint constant STEP_3 =   11111150000 * TOKEN_DECIMAL_MULTIPLIER;     // Continue the next 11111.5   - 199999.99 ETH         Price    100 ETH20 = 1 ETH
398     uint constant STEP_2 =  111111150000 * TOKEN_DECIMAL_MULTIPLIER;    // Continue the next 111111.5  - 1999999.99 ETH         Price     10 ETH20 = 1 ETH
399     uint constant STEP_1 = 2000000000000 * TOKEN_DECIMAL_MULTIPLIER;   // Continue the next 1111111.99 -19999999.99 ETH         Price      1 ETH20 = 1 ETH
400     
401     uint constant RATE_9 =   100000 * RATE_SCALE; // Price increases 0 %                       // Redemption price 98 %  Buy back burned
402     uint constant RATE_8 =    99000 * RATE_SCALE; // Price increases 1 %                       // Redemption price 98 %  Buy back burned
403     uint constant RATE_7 =    90000 * RATE_SCALE; // Price increases 10 %                      // Redemption price 98 %  Buy back burned
404     uint constant RATE_6 =    50000 * RATE_SCALE; // Price increases 100 % Increase by 2 times // Redemption price 98 %  Buy back burned
405     uint constant RATE_5 =    10000 * RATE_SCALE; // Price increases by 10 times               // Redemption price 98 %  Buy back burned
406     uint constant RATE_4 =    1000 * RATE_SCALE; // Price Increase by   100 times              // Redemption price 98 %  Buy back burned
407     uint constant RATE_3 =    100 * RATE_SCALE; // Price increase by    1000  times            // Redemption price 98 %  Buy back burned
408     uint constant RATE_2 =    10 * RATE_SCALE; // Price increase by     10000 times            // Redemption price 98 %  Buy back burned
409     uint constant RATE_1 =    1 * RATE_SCALE; // Price increase by      100000 times            // Redemption price 98 %  Buy back burned
410     
411     
412     uint constant BASE_RATE = 0 * RATE_SCALE;                                             // 1 ETH = 1 ETH20.  Standard price 0 %
413 
414     struct ExclusiveRate {
415         // be careful, accuracies this about 1 minutes
416         uint32 workUntil;
417         // exclusive rate or 0
418         uint rate;
419         // rate bonus percent, which will be divided by 1000 or 0
420         uint16 bonusPercent1000;
421         // flag to check, that record exists
422         bool exists;
423     }
424 
425     mapping(address => ExclusiveRate) exclusiveRate;
426 
427     function getRateScale() public constant returns (uint) {
428         return RATE_SCALE;
429     }
430 
431     function getBaseRate() public constant returns (uint) {
432         return BASE_RATE;
433     }
434     
435 
436     function getRate(address buyer, uint totalSold, uint amountWei) public constant returns (uint) {
437         uint rate;
438         // apply sale
439         if (totalSold < STEP_9) {
440             rate = RATE_9;
441         }
442         else if (totalSold < STEP_8) {
443             rate = RATE_8;
444         }
445         else if (totalSold < STEP_7) {
446             rate = RATE_7;
447         }
448         else if (totalSold < STEP_6) {
449             rate = RATE_6;
450         }
451         else if (totalSold < STEP_5) {
452             rate = RATE_5;
453         }
454         else if (totalSold < STEP_4) {
455             rate = RATE_4;
456         }
457         else if (totalSold < STEP_3) {
458             rate = RATE_3;
459         }
460         else if (totalSold < STEP_2) {
461             rate = RATE_2;
462         }
463         else if (totalSold < STEP_1) {
464             rate = RATE_1;
465         }
466         else {
467             rate = BASE_RATE;
468         }
469     // apply bonus for amount
470         if (amountWei >= 100000 ether) {
471             rate += rate * 0 / 100;
472         }
473         else if (amountWei >= 10000 ether) {
474             rate += rate * 0 / 100;
475         }
476         else if (amountWei >= 1000 ether) {
477             rate += rate * 0 / 100;
478         }
479         else if (amountWei >= 100 ether) {
480             rate += rate * 0 / 100;
481         }
482         else if (amountWei >= 10 ether) {
483             rate += rate * 0 / 100;
484         }
485         else if (amountWei >= 1 ether) {
486             rate += rate * 0 / 1000;
487         }
488 
489         ExclusiveRate memory eRate = exclusiveRate[buyer];
490         if (eRate.exists && eRate.workUntil >= now) {
491             if (eRate.rate != 0) {
492                 rate = eRate.rate;
493             }
494             rate += rate * eRate.bonusPercent1000 / 1000;
495         }
496         return rate;
497     }
498 
499     function setExclusiveRate(address _investor, uint _rate, uint16 _bonusPercent1000, uint32 _workUntil) onlyOwner {
500         exclusiveRate[_investor] = ExclusiveRate(_workUntil, _rate, _bonusPercent1000, true);
501     }
502 
503     function removeExclusiveRate(address _investor) onlyOwner {
504         delete exclusiveRate[_investor];
505     }
506 }
507 /**
508  * @title Crowdsale 
509  * @dev Crowdsale is a base contract for managing a token crowdsale.
510  *
511  * Crowdsales have a start and end timestamps, where investors can make
512  * token purchases and the crowdsale will assign them tokens based
513  * on a token per ETH rate. Funds collected are forwarded to a wallet 
514  * as they arrive.
515  */
516 contract Crowdsale {
517     using SafeMath for uint;
518 
519     // The token being sold
520     MintableToken public token;
521 
522     // start and end timestamps where investments are allowed (both inclusive)
523     uint32 internal startTime;
524     uint32 internal endTime;
525 
526     // address where funds are collected
527     address public wallet;
528 
529     // amount of raised money in wei
530     uint public weiRaised;
531 
532     /**
533      * @dev Amount of already sold tokens.
534      */
535     uint public soldTokens;
536 
537     /**
538      * @dev Maximum amount of tokens to mint.
539      */
540     uint internal hardCap;
541 
542     /**
543      * event for token purchase logging
544      * @param purchaser who paid for the tokens
545      * @param beneficiary who got the tokens
546      * @param value weis paid for purchase
547      * @param amount amount of tokens purchased
548      */
549     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);
550 
551     function Crowdsale(uint _startTime, uint _endTime, uint _hardCap, address _wallet) {
552         require(_endTime >= _startTime);
553         require(_wallet != 0x0);
554         require(_hardCap > 0);
555 
556         token = createTokenContract();
557         startTime = uint32(_startTime);
558         endTime = uint32(_endTime);
559         hardCap = _hardCap;
560         wallet = _wallet;
561     }
562 
563     // creates the token to be sold.
564     // override this method to have crowdsale of a specific mintable token.
565     function createTokenContract() internal returns (MintableToken) {
566         return new MintableToken();
567     }
568 
569     /**
570      * @dev this method might be overridden for implementing any sale logic.
571      * @return Actual rate.
572      */
573     function getRate(uint amount) internal constant returns (uint);
574 
575     function getBaseRate() internal constant returns (uint);
576 
577     /**
578      * @dev rate scale (or divider), to support not integer rates.
579      * @return Rate divider.
580      */
581     function getRateScale() internal constant returns (uint) {
582         return 1;
583     }
584 
585     // fallback function can be used to buy tokens
586     function() payable {
587         buyTokens(msg.sender, msg.value);
588     }
589 
590     // low level token purchase function
591     function buyTokens(address beneficiary, uint amountWei) internal {
592         require(beneficiary != 0x0);
593 
594         // total minted tokens
595         uint totalSupply = token.totalSupply();
596 
597         // actual token minting rate (with considering bonuses and discounts)
598         uint actualRate = getRate(amountWei);
599         uint rateScale = getRateScale();
600 
601         require(validPurchase(amountWei, actualRate, totalSupply));
602 
603         // calculate token amount to be created
604         uint tokens = amountWei.mul(actualRate).div(rateScale);
605 
606         // update state
607         weiRaised = weiRaised.add(amountWei);
608         soldTokens = soldTokens.add(tokens);
609 
610         token.mint(beneficiary, tokens);
611         TokenPurchase(msg.sender, beneficiary, amountWei, tokens);
612 
613         forwardFunds(amountWei);
614     }
615 
616     // send ether to the fund collection wallet
617     // override to create custom fund forwarding mechanisms
618     function forwardFunds(uint amountWei) internal {
619         wallet.transfer(amountWei);
620     }
621 
622     /**
623      * @dev Check if the specified purchase is valid.
624      * @return true if the transaction can buy tokens
625      */
626     function validPurchase(uint _amountWei, uint _actualRate, uint _totalSupply) internal constant returns (bool) {
627         bool withinPeriod = now >= startTime && now <= endTime;
628         bool nonZeroPurchase = _amountWei != 0;
629         bool hardCapNotReached = _totalSupply <= hardCap;
630 
631         return withinPeriod && nonZeroPurchase && hardCapNotReached;
632     }
633 
634     /**
635      * @dev Because of discount hasEnded might be true, but validPurchase returns false.
636      * @return true if crowdsale event has ended
637      */
638     function hasEnded() public constant returns (bool) {
639         return now > endTime || token.totalSupply() > hardCap;
640     }
641 
642     /**
643      * @return true if crowdsale event has started
644      */
645     function hasStarted() public constant returns (bool) {
646         return now >= startTime;
647     }
648 }
649 
650 contract FinalizableCrowdsale is Crowdsale, Ownable {
651     using SafeMath for uint256;
652 
653     bool public isFinalized = false;
654 
655     event Finalized();
656 
657     function FinalizableCrowdsale(uint _startTime, uint _endTime, uint _hardCap, address _wallet)
658             Crowdsale(_startTime, _endTime, _hardCap, _wallet) {
659     }
660 
661     /**
662      * @dev Must be called after crowdsale ends, to do some extra finalization
663      * work. Calls the contract's finalization function.
664      */
665     function finalize() onlyOwner notFinalized {
666         require(hasEnded());
667 
668         finalization();
669         Finalized();
670 
671         isFinalized = true;
672     }
673 
674     /**
675      * @dev Can be overriden to add finalization logic. The overriding function
676      * should call super.finalization() to ensure the chain of finalization is
677      * executed entirely.
678      */
679     function finalization() internal {
680     }
681 
682     modifier notFinalized() {
683         require(!isFinalized);
684         _;
685     }
686 }
687 
688 contract EthereumV2Erc20Crowdsale is usingEthereumV2Erc20Consts, FinalizableCrowdsale {
689     EthereumV2Erc20RateProviderI public rateProvider;
690 
691     function EthereumV2Erc20Crowdsale(
692             uint _startTime,
693             uint _endTime,
694             uint _hardCapTokens
695     )
696             FinalizableCrowdsale(_startTime, _endTime, _hardCapTokens * TOKEN_DECIMAL_MULTIPLIER, COLD_WALLET) {
697 
698         token.mint(TEAM_ADDRESS, TEAM_TOKENS);
699         token.mint(BOUNTY_ADDRESS, BOUNTY_TOKENS);
700         token.mint(PREICO_ADDRESS, PREICO_TOKENS);
701 
702         EthereumV2Erc20(token).addExcluded(TEAM_ADDRESS);
703         EthereumV2Erc20(token).addExcluded(BOUNTY_ADDRESS);
704         EthereumV2Erc20(token).addExcluded(PREICO_ADDRESS);
705 
706         EthereumV2Erc20RateProvider provider = new EthereumV2Erc20RateProvider();
707         provider.transferOwnership(owner);
708         rateProvider = provider;
709     }
710 
711     /**
712      * @dev override token creation to integrate with MyWill token.
713      */
714     function createTokenContract() internal returns (MintableToken) {
715         return new EthereumV2Erc20();
716     }
717 
718     /**
719      * @dev override getRate to integrate with rate provider.
720      */
721     function getRate(uint _value) internal constant returns (uint) {
722         return rateProvider.getRate(msg.sender, soldTokens, _value);
723     }
724 
725     function getBaseRate() internal constant returns (uint) {
726         return rateProvider.getRate(msg.sender, soldTokens, MINIMAL_PURCHASE);
727     }
728 
729     /**
730      * @dev override getRateScale to integrate with rate provider.
731      */
732     function getRateScale() internal constant returns (uint) {
733         return rateProvider.getRateScale();
734     }
735 
736     /**
737      * @dev Admin can set new rate provider.
738      * @param _rateProviderAddress New rate provider.
739      */
740     function setRateProvider(address _rateProviderAddress) onlyOwner {
741         require(_rateProviderAddress != 0);
742         rateProvider = EthereumV2Erc20RateProviderI(_rateProviderAddress);
743     }
744 
745     /**
746      * @dev Admin can move end time.
747      * @param _endTime New end time.
748      */
749     function setEndTime(uint _endTime) onlyOwner notFinalized {
750         require(_endTime > startTime);
751         endTime = uint32(_endTime);
752     }
753 
754     function setHardCap(uint _hardCapTokens) onlyOwner notFinalized {
755         require(_hardCapTokens * TOKEN_DECIMAL_MULTIPLIER > hardCap);
756         hardCap = _hardCapTokens * TOKEN_DECIMAL_MULTIPLIER;
757     }
758 
759     function setStartTime(uint _startTime) onlyOwner notFinalized {
760         require(_startTime < endTime);
761         startTime = uint32(_startTime);
762     }
763 
764     function addExcluded(address _address) onlyOwner notFinalized {
765         EthereumV2Erc20(token).addExcluded(_address);
766     }
767 
768     function validPurchase(uint _amountWei, uint _actualRate, uint _totalSupply) internal constant returns (bool) {
769         if (_amountWei < MINIMAL_PURCHASE) {
770             return false;
771         }
772         return super.validPurchase(_amountWei, _actualRate, _totalSupply);
773     }
774 
775     function finalization() internal {
776         super.finalization();
777         token.finishMinting();
778         EthereumV2Erc20(token).crowdsaleFinished();
779         token.transferOwnership(owner);
780     }
781 }
782 
783 
784 /**
785  * @title Proxy
786  * @dev Implements delegation of calls to other contracts, with proper
787  * forwarding of return values and bubbling of failures.
788  * It defines a fallback function that delegates all calls to the address
789  * returned by the abstract _implementation() internal function.
790  */
791 contract Proxy {
792     /**
793      * @dev Fallback function.
794      * Implemented entirely in `_fallback`.
795      */
796     function () payable external {
797         _fallback();
798     }
799 
800     /**
801      * @return The Address of the implementation.
802      */
803     function _implementation() internal view returns (address);
804 
805     /**
806      * @dev Delegates execution to an implementation contract.
807      * This is a low level function that doesn't return to its internal call site.
808      * It will return to the external caller whatever the implementation returns.
809      * @param implementation Address to delegate.
810      */
811     function _delegate(address implementation) internal {
812         assembly {
813         // Copy msg.data. We take full control of memory in this inline assembly
814         // block because it will not return to Solidity code. We overwrite the
815         // Solidity scratch pad at memory position 0.
816             calldatacopy(0, 0, calldatasize)
817 
818         // Call the implementation.
819         // out and outsize are 0 because we don't know the size yet.
820             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
821 
822         // Copy the returned data.
823             returndatacopy(0, 0, returndatasize)
824 
825             switch result
826             // delegatecall returns 0 on error.
827             case 0 { revert(0, returndatasize) }
828             default { return(0, returndatasize) }
829         }
830     }
831 
832     /**
833      * @dev Function that is run as the first thing in the fallback function.
834      * Can be redefined in derived contracts to add functionality.
835      * Redefinitions must call super._willFallback().
836      */
837     function _willFallback() internal {
838     }
839 
840     /**
841      * @dev fallback implementation.
842      * Extracted to enable manual triggering.
843      */
844     function _fallback() internal {
845         _willFallback();
846         _delegate(_implementation());
847     }
848 }
849 
850 // File: contracts/zeppelin/AddressUtils.sol
851 
852 /**
853  * Utility library of inline functions on addresses
854  */
855 library AddressUtils {
856 
857     /**
858      * Returns whether the target address is a contract
859      * @dev This function will return false if invoked during the constructor of a contract,
860      * as the code is not actually created until after the constructor finishes.
861      * @param addr address to check
862      * @return whether the target address is a contract
863      */
864     function isContract(address addr) internal view returns (bool) {
865         uint256 size;
866         // XXX Currently there is no better way to check if there is a contract in an address
867         // than to check the size of the code at that address.
868         // See https://ethereum.stackexchange.com/a/14016/36603
869         // for more details about how this works.
870         // TODO Check this again before the Serenity release, because all addresses will be
871         // contracts then.
872         // solium-disable-next-line security/no-inline-assembly
873         assembly { size := extcodesize(addr) }
874         return size > 0;
875     }
876 
877 }
878 
879 
880 
881 
882 contract Token {
883     bytes32 public standard;
884     bytes32 public name;
885     bytes32 public symbol;
886     uint256 public totalSupply;
887     uint8 public decimals;
888     bool public allowTransactions;
889     mapping (address => uint256) public balanceOf;
890     mapping (address => mapping (address => uint256)) public allowance;
891     function transfer(address _to, uint256 _value) returns (bool success);
892     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
893     function approve(address _spender, uint256 _value) returns (bool success);
894     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
895 }
896 
897 contract Promotion {
898     mapping(address => address[]) public referrals; // mapping of affiliate address to referral addresses
899     mapping(address => address) public affiliates; // mapping of referrals addresses to affiliate addresses
900     mapping(address => bool) public admins; // mapping of admin accounts
901     string[] public affiliateList;
902     address public owner;
903 
904     function setOwner(address newOwner);
905     function setAdmin(address admin, bool isAdmin) public;
906     function assignReferral (address affiliate, address referral) public;
907 
908     function getAffiliateCount() returns (uint);
909     function getAffiliate(address refferal) public returns (address);
910     function getReferrals(address affiliate) public returns (address[]);
911 }
912 
913 contract TokenList {
914     function isTokenInList(address tokenAddress) public constant returns (bool);
915 }
916 
917 
918 contract BTC20Exchange {
919     function assert(bool assertion) {
920         if (!assertion) throw;
921     }
922     function safeMul(uint a, uint b) returns (uint) {
923         uint c = a * b;
924         assert(a == 0 || c / a == b);
925         return c;
926     }
927 
928     function safeSub(uint a, uint b) returns (uint) {
929         assert(b <= a);
930         return a - b;
931     }
932 
933     function safeAdd(uint a, uint b) returns (uint) {
934         uint c = a + b;
935         assert(c>=a && c>=b);
936         return c;
937     }
938     address public owner;
939     mapping (address => uint256) public invalidOrder;
940 
941     event SetOwner(address indexed previousOwner, address indexed newOwner);
942     modifier onlyOwner {
943         assert(msg.sender == owner);
944         _;
945     }
946     function setOwner(address newOwner) onlyOwner {
947         SetOwner(owner, newOwner);
948         owner = newOwner;
949     }
950     function getOwner() returns (address out) {
951         return owner;
952     }
953     function invalidateOrdersBefore(address user, uint256 nonce) onlyAdmin {
954         if (nonce < invalidOrder[user]) throw;
955         invalidOrder[user] = nonce;
956     }
957 
958     mapping (address => mapping (address => uint256)) public tokens; //mapping of token addresses to mapping of account balances
959 
960     mapping (address => bool) public admins;
961     mapping (address => uint256) public lastActiveTransaction;
962     mapping (bytes32 => uint256) public orderFills;
963     address public feeAccount;
964     uint256 public feeAffiliate; // percentage times (1 ether)
965     uint256 public inactivityReleasePeriod;
966     mapping (bytes32 => bool) public traded;
967     mapping (bytes32 => bool) public withdrawn;
968     uint256 public makerFee; // fraction * 1 ether
969     uint256 public takerFee; // fraction * 1 ether
970     uint256 public affiliateFee; // fraction as proportion of 1 ether
971     uint256 public makerAffiliateFee; // wei deductible from makerFee
972     uint256 public takerAffiliateFee; // wei deductible form takerFee
973 
974     mapping (address => address) public referrer;  // mapping of user addresses to their referrer addresses
975 
976     address public affiliateContract;
977     address public tokenListContract;
978 
979 
980     enum Errors {
981         INVLID_PRICE,           // Order prices don't match
982         INVLID_SIGNATURE,       // Signature is invalid
983         TOKENS_DONT_MATCH,      // Maker/taker tokens don't match
984         ORDER_ALREADY_FILLED,   // Order was already filled
985         GAS_TOO_HIGH            // Too high gas fee
986     }
987 
988     //event Order(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
989     //event Cancel(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
990     event Trade(
991         address takerTokenBuy, uint256 takerAmountBuy,
992         address takerTokenSell, uint256 takerAmountSell,
993         address maker, address indexed taker,
994         uint256 makerFee, uint256 takerFee,
995         uint256 makerAmountTaken, uint256 takerAmountTaken,
996         bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash
997     );
998     event Deposit(address indexed token, address indexed user, uint256 amount, uint256 balance, address indexed referrerAddress);
999     event Withdraw(address indexed token, address indexed user, uint256 amount, uint256 balance, uint256 withdrawFee);
1000     event FeeChange(uint256 indexed makerFee, uint256 indexed takerFee, uint256 indexed affiliateFee);
1001     //event AffiliateFeeChange(uint256 newAffiliateFee);
1002     event LogError(uint8 indexed errorId, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
1003     event CancelOrder(
1004         bytes32 indexed cancelHash,
1005         bytes32 indexed orderHash,
1006         address indexed user,
1007         address tokenSell,
1008         uint256 amountSell,
1009         uint256 cancelFee
1010     );
1011 
1012     function setInactivityReleasePeriod(uint256 expiry) onlyAdmin returns (bool success) {
1013         if (expiry > 1000000) throw;
1014         inactivityReleasePeriod = expiry;
1015         return true;
1016     }
1017 
1018     function Exchange(address feeAccount_, uint256 makerFee_, uint256 takerFee_, uint256 affiliateFee_, address affiliateContract_, address tokenListContract_) {
1019         owner = msg.sender;
1020         feeAccount = feeAccount_;
1021         inactivityReleasePeriod = 100000;
1022         makerFee = makerFee_;
1023         takerFee = takerFee_;
1024         affiliateFee = affiliateFee_;
1025 
1026 
1027 
1028         makerAffiliateFee = safeMul(makerFee, affiliateFee_) / (1 ether);
1029         takerAffiliateFee = safeMul(takerFee, affiliateFee_) / (1 ether);
1030 
1031         affiliateContract = affiliateContract_;
1032         tokenListContract = tokenListContract_;
1033     }
1034 
1035     function setFees(uint256 makerFee_, uint256 takerFee_, uint256 affiliateFee_) onlyOwner {
1036         require(makerFee_ < 10 finney && takerFee_ < 10 finney);
1037         require(affiliateFee_ > affiliateFee);
1038         makerFee = makerFee_;
1039         takerFee = takerFee_;
1040         affiliateFee = affiliateFee_;
1041         makerAffiliateFee = safeMul(makerFee, affiliateFee_) / (1 ether);
1042         takerAffiliateFee = safeMul(takerFee, affiliateFee_) / (1 ether);
1043 
1044         FeeChange(makerFee, takerFee, affiliateFee_);
1045     }
1046 
1047     function setAdmin(address admin, bool isAdmin) onlyOwner {
1048         admins[admin] = isAdmin;
1049     }
1050 
1051     modifier onlyAdmin {
1052         if (msg.sender != owner && !admins[msg.sender]) throw;
1053         _;
1054     }
1055 
1056     function() external {
1057         throw;
1058     }
1059 
1060     function depositToken(address token, uint256 amount, address referrerAddress) {
1061         //require(EthermiumTokenList(tokenListContract).isTokenInList(token));
1062         if (referrerAddress == msg.sender) referrerAddress = address(0);
1063         if (referrer[msg.sender] == address(0x0))   {
1064             if (referrerAddress != address(0x0) && Promotion(affiliateContract).getAffiliate(msg.sender) == address(0))
1065             {
1066                 referrer[msg.sender] = referrerAddress;
1067                 Promotion(affiliateContract).assignReferral(referrerAddress, msg.sender);
1068             }
1069             else
1070             {
1071                 referrer[msg.sender] = Promotion(affiliateContract).getAffiliate(msg.sender);
1072             }
1073         }
1074         tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
1075         lastActiveTransaction[msg.sender] = block.number;
1076         if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
1077         Deposit(token, msg.sender, amount, tokens[token][msg.sender], referrer[msg.sender]);
1078     }
1079 
1080     function deposit(address referrerAddress) payable {
1081         if (referrerAddress == msg.sender) referrerAddress = address(0);
1082         if (referrer[msg.sender] == address(0x0))   {
1083             if (referrerAddress != address(0x0) && Promotion(affiliateContract).getAffiliate(msg.sender) == address(0))
1084             {
1085                 referrer[msg.sender] = referrerAddress;
1086                 Promotion(affiliateContract).assignReferral(referrerAddress, msg.sender);
1087             }
1088             else
1089             {
1090                 referrer[msg.sender] = Promotion(affiliateContract).getAffiliate(msg.sender);
1091             }
1092         }
1093         tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
1094         lastActiveTransaction[msg.sender] = block.number;
1095         Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender], referrer[msg.sender]);
1096     }
1097 
1098     function withdraw(address token, uint256 amount) returns (bool success) {
1099         if (safeSub(block.number, lastActiveTransaction[msg.sender]) < inactivityReleasePeriod) throw;
1100         if (tokens[token][msg.sender] < amount) throw;
1101         tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
1102         if (token == address(0)) {
1103             if (!msg.sender.send(amount)) throw;
1104         } else {
1105             if (!Token(token).transfer(msg.sender, amount)) throw;
1106         }
1107         Withdraw(token, msg.sender, amount, tokens[token][msg.sender], 0);
1108     }
1109 
1110     function adminWithdraw(address token, uint256 amount, address user, uint256 nonce, uint8 v, bytes32 r, bytes32 s, uint256 feeWithdrawal) onlyAdmin returns (bool success) {
1111         bytes32 hash = keccak256(this, token, amount, user, nonce);
1112         if (withdrawn[hash]) throw;
1113         withdrawn[hash] = true;
1114         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) != user) throw;
1115         if (feeWithdrawal > 50 finney) feeWithdrawal = 50 finney;
1116         if (tokens[token][user] < amount) throw;
1117         tokens[token][user] = safeSub(tokens[token][user], amount);
1118         tokens[address(0)][user] = safeSub(tokens[address(0x0)][user], feeWithdrawal);
1119         //tokens[token][feeAccount] = safeAdd(tokens[token][feeAccount], safeMul(feeWithdrawal, amount) / 1 ether);
1120         tokens[address(0)][feeAccount] = safeAdd(tokens[address(0)][feeAccount], feeWithdrawal);
1121 
1122         //amount = safeMul((1 ether - feeWithdrawal), amount) / 1 ether;
1123         if (token == address(0)) {
1124             if (!user.send(amount)) throw;
1125         } else {
1126             if (!Token(token).transfer(user, amount)) throw;
1127         }
1128         lastActiveTransaction[user] = block.number;
1129         Withdraw(token, user, amount, tokens[token][user], feeWithdrawal);
1130     }
1131 
1132     function balanceOf(address token, address user) constant returns (uint256) {
1133         return tokens[token][user];
1134     }
1135 
1136     struct OrderPair {
1137         uint256 makerAmountBuy;
1138         uint256 makerAmountSell;
1139         uint256 makerNonce;
1140         uint256 takerAmountBuy;
1141         uint256 takerAmountSell;
1142         uint256 takerNonce;
1143         uint256 takerGasFee;
1144 
1145         address makerTokenBuy;
1146         address makerTokenSell;
1147         address maker;
1148         address takerTokenBuy;
1149         address takerTokenSell;
1150         address taker;
1151 
1152         bytes32 makerOrderHash;
1153         bytes32 takerOrderHash;
1154     }
1155 
1156     struct TradeValues {
1157         uint256 qty;
1158         uint256 invQty;
1159         uint256 makerAmountTaken;
1160         uint256 takerAmountTaken;
1161         address makerReferrer;
1162         address takerReferrer;
1163     }
1164 
1165 
1166 
1167 
1168     function trade(
1169         uint8[2] v,
1170         bytes32[4] rs,
1171         uint256[7] tradeValues,
1172         address[6] tradeAddresses
1173     ) onlyAdmin returns (uint filledTakerTokenAmount)
1174     {
1175 
1176         /* tradeValues
1177           [0] makerAmountBuy
1178           [1] makerAmountSell
1179           [2] makerNonce
1180           [3] takerAmountBuy
1181           [4] takerAmountSell
1182           [5] takerNonce
1183           [6] takerGasFee
1184 
1185           tradeAddresses
1186           [0] makerTokenBuy
1187           [1] makerTokenSell
1188           [2] maker
1189           [3] takerTokenBuy
1190           [4] takerTokenSell
1191           [5] taker
1192         */
1193 
1194         OrderPair memory t  = OrderPair({
1195             makerAmountBuy  : tradeValues[0],
1196             makerAmountSell : tradeValues[1],
1197             makerNonce      : tradeValues[2],
1198             takerAmountBuy  : tradeValues[3],
1199             takerAmountSell : tradeValues[4],
1200             takerNonce      : tradeValues[5],
1201             takerGasFee     : tradeValues[6],
1202 
1203             makerTokenBuy   : tradeAddresses[0],
1204             makerTokenSell  : tradeAddresses[1],
1205             maker           : tradeAddresses[2],
1206             takerTokenBuy   : tradeAddresses[3],
1207             takerTokenSell  : tradeAddresses[4],
1208             taker           : tradeAddresses[5],
1209 
1210             makerOrderHash  : keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeAddresses[2]),
1211             takerOrderHash  : keccak256(this, tradeAddresses[3], tradeValues[3], tradeAddresses[4], tradeValues[4], tradeValues[5], tradeAddresses[5])
1212         });
1213 
1214         //bytes32 makerOrderHash = keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeAddresses[2]);
1215         //bytes32 makerOrderHash = §
1216         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker)
1217         {
1218             LogError(uint8(Errors.INVLID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
1219             return 0;
1220         }
1221         //bytes32 takerOrderHash = keccak256(this, tradeAddresses[3], tradeValues[3], tradeAddresses[4], tradeValues[4], tradeValues[5], tradeAddresses[5]);
1222         //bytes32 takerOrderHash = keccak256(this, t.takerTokenBuy, t.takerAmountBuy, t.takerTokenSell, t.takerAmountSell, t.takerNonce, t.taker);
1223         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)
1224         {
1225             LogError(uint8(Errors.INVLID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
1226             return 0;
1227         }
1228 
1229         if (t.makerTokenBuy != t.takerTokenSell || t.makerTokenSell != t.takerTokenBuy)
1230         {
1231             LogError(uint8(Errors.TOKENS_DONT_MATCH), t.makerOrderHash, t.takerOrderHash);
1232             return 0;
1233         } // tokens don't match
1234 
1235         if (t.takerGasFee > 1 finney)
1236         {
1237             LogError(uint8(Errors.GAS_TOO_HIGH), t.makerOrderHash, t.takerOrderHash);
1238             return 0;
1239         } // takerGasFee too high
1240 
1241 
1242 
1243         if (!(
1244         (t.makerTokenBuy != address(0x0) && safeMul(t.makerAmountSell, 5 finney) / t.makerAmountBuy >= safeMul(t.takerAmountBuy, 5 finney) / t.takerAmountSell)
1245         ||
1246         (t.makerTokenBuy == address(0x0) && safeMul(t.makerAmountBuy, 5 finney) / t.makerAmountSell <= safeMul(t.takerAmountSell, 5 finney) / t.takerAmountBuy)
1247         ))
1248         {
1249             LogError(uint8(Errors.INVLID_PRICE), t.makerOrderHash, t.takerOrderHash);
1250             return 0; // prices don't match
1251         }
1252 
1253         TradeValues memory tv = TradeValues({
1254             qty                 : 0,
1255             invQty              : 0,
1256             makerAmountTaken    : 0,
1257             takerAmountTaken    : 0,
1258             makerReferrer       : referrer[t.maker],
1259             takerReferrer       : referrer[t.taker]
1260         });
1261 
1262         if (tv.makerReferrer == address(0x0)) tv.makerReferrer = feeAccount;
1263         if (tv.takerReferrer == address(0x0)) tv.takerReferrer = feeAccount;
1264 
1265 
1266 
1267         // maker buy, taker sell
1268         if (t.makerTokenBuy != address(0x0))
1269         {
1270 
1271 
1272             tv.qty = min(safeSub(t.makerAmountBuy, orderFills[t.makerOrderHash]), safeSub(t.takerAmountSell, safeMul(orderFills[t.takerOrderHash], t.takerAmountSell) / t.takerAmountBuy));
1273             if (tv.qty == 0)
1274             {
1275                 LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
1276                 return 0;
1277             }
1278 
1279             tv.invQty = safeMul(tv.qty, t.makerAmountSell) / t.makerAmountBuy;
1280 
1281             tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.invQty);
1282             tv.makerAmountTaken                         = safeSub(tv.qty, safeMul(tv.qty, makerFee) / (1 ether));
1283             tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken);
1284             tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.qty,    makerAffiliateFee) / (1 ether));
1285 
1286             tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.qty);
1287             tv.takerAmountTaken                         = safeSub(safeSub(tv.invQty, safeMul(tv.invQty, takerFee) / (1 ether)), safeMul(tv.invQty, t.takerGasFee) / (1 ether));
1288             tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken);
1289             tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.invQty, takerAffiliateFee) / (1 ether));
1290 
1291             tokens[t.makerTokenBuy][feeAccount]     = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.qty,    safeSub(makerFee, makerAffiliateFee)) / (1 ether));
1292             tokens[t.takerTokenBuy][feeAccount]     = safeAdd(tokens[t.takerTokenBuy][feeAccount],      safeAdd(safeMul(tv.invQty, safeSub(takerFee, takerAffiliateFee)) / (1 ether), safeMul(tv.invQty, t.takerGasFee) / (1 ether)));
1293 
1294 
1295             orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.qty);
1296             orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], safeMul(tv.qty, t.takerAmountBuy) / t.takerAmountSell);
1297             lastActiveTransaction[t.maker]          = block.number;
1298             lastActiveTransaction[t.taker]          = block.number;
1299 
1300             Trade(
1301                 t.takerTokenBuy, tv.qty,
1302                 t.takerTokenSell, tv.invQty,
1303                 t.maker, t.taker,
1304                 makerFee, takerFee,
1305                 tv.makerAmountTaken , tv.takerAmountTaken,
1306                 t.makerOrderHash, t.takerOrderHash
1307             );
1308             return tv.qty;
1309         }
1310         // maker sell, taker buy
1311         else
1312         {
1313 
1314             tv.qty = min(safeSub(t.makerAmountSell,  safeMul(orderFills[t.makerOrderHash], t.makerAmountSell) / t.makerAmountBuy), safeSub(t.takerAmountBuy, orderFills[t.takerOrderHash]));
1315             if (tv.qty == 0)
1316             {
1317                 LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
1318                 return 0;
1319             }
1320 
1321             tv.invQty = safeMul(tv.qty, t.makerAmountBuy) / t.makerAmountSell;
1322 
1323             tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.qty);
1324             tv.makerAmountTaken                         = safeSub(tv.invQty, safeMul(tv.invQty, makerFee) / (1 ether));
1325             tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken);
1326             tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.invQty, makerAffiliateFee) / (1 ether));
1327 
1328             tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.invQty);
1329             tv.takerAmountTaken                         = safeSub(safeSub(tv.qty,    safeMul(tv.qty, takerFee) / (1 ether)), safeMul(tv.qty, t.takerGasFee) / (1 ether));
1330             tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken);
1331             tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.qty,    takerAffiliateFee) / (1 ether));
1332 
1333             tokens[t.makerTokenBuy][feeAccount]     = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.invQty, safeSub(makerFee, makerAffiliateFee)) / (1 ether));
1334             tokens[t.takerTokenBuy][feeAccount]     = safeAdd(tokens[t.takerTokenBuy][feeAccount],      safeAdd(safeMul(tv.qty,    safeSub(takerFee, takerAffiliateFee)) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether)));
1335 
1336             orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.invQty);
1337             orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty); //safeMul(qty, tradeValues[takerAmountBuy]) / tradeValues[takerAmountSell]);
1338 
1339             lastActiveTransaction[t.maker]          = block.number;
1340             lastActiveTransaction[t.taker]          = block.number;
1341 
1342             Trade(
1343                 t.takerTokenBuy, tv.qty,
1344                 t.takerTokenSell, tv.invQty,
1345                 t.maker, t.taker,
1346                 makerFee, takerFee,
1347                 tv.makerAmountTaken , tv.takerAmountTaken,
1348                 t.makerOrderHash, t.takerOrderHash
1349             );
1350             return tv.qty;
1351         }
1352     }
1353 
1354     function batchOrderTrade(
1355         uint8[2][] v,
1356         bytes32[4][] rs,
1357         uint256[7][] tradeValues,
1358         address[6][] tradeAddresses
1359     )
1360     {
1361         for (uint i = 0; i < tradeAddresses.length; i++) {
1362             trade(
1363                 v[i],
1364                 rs[i],
1365                 tradeValues[i],
1366                 tradeAddresses[i]
1367             );
1368         }
1369     }
1370 
1371     function cancelOrder(
1372 		/*
1373 		[0] orderV
1374 		[1] cancelV
1375 		*/
1376 	    uint8[2] v,
1377 
1378 		/*
1379 		[0] orderR
1380 		[1] orderS
1381 		[2] cancelR
1382 		[3] cancelS
1383 		*/
1384 	    bytes32[4] rs,
1385 
1386 		/*
1387 		[0] orderAmountBuy
1388 		[1] orderAmountSell
1389 		[2] orderNonce
1390 		[3] cancelNonce
1391 		[4] cancelFee
1392 		*/
1393 		uint256[5] cancelValues,
1394 
1395 		/*
1396 		[0] orderTokenBuy
1397 		[1] orderTokenSell
1398 		[2] orderUser
1399 		[3] cancelUser
1400 		*/
1401 		address[4] cancelAddresses
1402     ) public onlyAdmin {
1403         // Order values should be valid and signed by order owner
1404         bytes32 orderHash = keccak256(
1405 	        this, cancelAddresses[0], cancelValues[0], cancelAddresses[1],
1406 	        cancelValues[1], cancelValues[2], cancelAddresses[2]
1407         );
1408         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), v[0], rs[0], rs[1]) == cancelAddresses[2]);
1409 
1410         // Cancel action should be signed by cancel's initiator
1411         bytes32 cancelHash = keccak256(this, orderHash, cancelAddresses[3], cancelValues[3]);
1412         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", cancelHash), v[1], rs[2], rs[3]) == cancelAddresses[3]);
1413 
1414         // Order owner should be same as cancel's initiator
1415         require(cancelAddresses[2] == cancelAddresses[3]);
1416 
1417         // Do not allow to cancel already canceled or filled orders
1418         require(orderFills[orderHash] != cancelValues[0]);
1419 
1420         // Limit cancel fee
1421         if (cancelValues[4] > 6 finney) {
1422             cancelValues[4] = 6 finney;
1423         }
1424 
1425         // Take cancel fee
1426         // This operation throw an error if fee amount is more than user balance
1427         tokens[address(0)][cancelAddresses[3]] = safeSub(tokens[address(0)][cancelAddresses[3]], cancelValues[4]);
1428 
1429         // Cancel order by filling it with amount buy value
1430         orderFills[orderHash] = cancelValues[0];
1431 
1432         // Emit cancel order
1433         CancelOrder(cancelHash, orderHash, cancelAddresses[3], cancelAddresses[1], cancelValues[1], cancelValues[4]);
1434     }
1435 
1436     function min(uint a, uint b) private pure returns (uint) {
1437         return a < b ? a : b;
1438     }
1439 }
1440 
1441 
1442 
1443 
1444 /**
1445  * @title Token
1446  * @dev Token interface necessary for working with tokens within the exchange contract.
1447  */
1448 contract IToken {
1449     /// @return total amount of tokens
1450     function totalSupply() public constant returns (uint256 supply);
1451 
1452     /// @param _owner The address from which the balance will be retrieved
1453     /// @return The balance
1454     function balanceOf(address _owner) public constant returns (uint256 balance);
1455 
1456     /// @notice send `_value` token to `_to` from `msg.sender`
1457     /// @param _to The address of the recipient
1458     /// @param _value The amount of token to be transferred
1459     /// @return Whether the transfer was successful or not
1460     function transfer(address _to, uint256 _value) public returns (bool success);
1461 
1462     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
1463     /// @param _from The address of the sender
1464     /// @param _to The address of the recipient
1465     /// @param _value The amount of token to be transferred
1466     /// @return Whether the transfer was successful or not
1467     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
1468 
1469     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
1470     /// @param _spender The address of the account able to transfer the tokens
1471     /// @param _value The amount of wei to be approved for transfer
1472     /// @return Whether the approval was successful or not
1473     function approve(address _spender, uint256 _value) public returns (bool success);
1474 
1475     /// @param _owner The address of the account owning tokens
1476     /// @param _spender The address of the account able to transfer the tokens
1477     /// @return Amount of remaining tokens allowed to spent
1478     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
1479 
1480     event Transfer(address indexed _from, address indexed _to, uint256 _value);
1481     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
1482 
1483     uint public decimals;
1484     string public name;
1485 }
1486 
1487 pragma solidity ^0.4.17;
1488 
1489 
1490 /**
1491  * @title SafeMath
1492  * @dev Math operations with safety checks that throw on error
1493  */
1494 library LSafeMath {
1495 
1496     uint256 constant WAD = 1 ether;
1497     
1498     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1499         if (a == 0) {
1500             return 0;
1501         }
1502         uint256 c = a * b;
1503         if (c / a == b)
1504             return c;
1505         revert();
1506     }
1507     
1508     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1509         if (b > 0) { 
1510             uint256 c = a / b;
1511             return c;
1512         }
1513         revert();
1514     }
1515     
1516     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1517         if (b <= a)
1518             return a - b;
1519         revert();
1520     }
1521     
1522     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1523         uint256 c = a + b;
1524         if (c >= a) 
1525             return c;
1526         revert();
1527     }
1528 
1529     function wmul(uint a, uint b) internal pure returns (uint256) {
1530         return add(mul(a, b), WAD / 2) / WAD;
1531     }
1532 
1533     function wdiv(uint a, uint b) internal pure returns (uint256) {
1534         return add(mul(a, WAD), b / 2) / b;
1535     }
1536 }
1537 
1538 /**
1539  * @title Coinchangex
1540  * @dev This is the main contract for the Coinchangex exchange.
1541  */
1542 contract Tokenchange {
1543   
1544   using LSafeMath for uint;
1545   
1546   struct SpecialTokenBalanceFeeTake {
1547       bool exist;
1548       address token;
1549       uint256 balance;
1550       uint256 feeTake;
1551   }
1552   
1553   uint constant private MAX_SPECIALS = 10;
1554 
1555   /// Variables
1556   address public admin; // the admin address
1557   address public feeAccount; // the account that will receive fees
1558   uint public feeTake; // percentage times (1 ether)
1559   bool private depositingTokenFlag; // True when Token.transferFrom is being called from depositToken
1560   mapping (address => mapping (address => uint)) public tokens; // mapping of token addresses to mapping of account balances (token=0 means Ether)
1561   mapping (address => mapping (bytes32 => uint)) public orderFills; // mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
1562   SpecialTokenBalanceFeeTake[] public specialFees;
1563   
1564 
1565   /// Logging Events
1566   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
1567   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
1568   event Deposit(address token, address user, uint amount, uint balance);
1569   event Withdraw(address token, address user, uint amount, uint balance);
1570 
1571   /// This is a modifier for functions to check if the sending user address is the same as the admin user address.
1572   modifier isAdmin() {
1573       require(msg.sender == admin);
1574       _;
1575   }
1576 
1577   /// Constructor function. This is only called on contract creation.
1578   function Coinchangex(address admin_, address feeAccount_, uint feeTake_) public {
1579     admin = admin_;
1580     feeAccount = feeAccount_;
1581     feeTake = feeTake_;
1582     depositingTokenFlag = false;
1583   }
1584 
1585   /// The fallback function. Ether transfered into the contract is not accepted.
1586   function() public {
1587     revert();
1588   }
1589 
1590   /// Changes the official admin user address. Accepts Ethereum address.
1591   function changeAdmin(address admin_) public isAdmin {
1592     require(admin_ != address(0));
1593     admin = admin_;
1594   }
1595 
1596   /// Changes the account address that receives trading fees. Accepts Ethereum address.
1597   function changeFeeAccount(address feeAccount_) public isAdmin {
1598     feeAccount = feeAccount_;
1599   }
1600 
1601   /// Changes the fee on takes. Can only be changed to a value less than it is currently set at.
1602   function changeFeeTake(uint feeTake_) public isAdmin {
1603     // require(feeTake_ <= feeTake);
1604     feeTake = feeTake_;
1605   }
1606   
1607   // add special promotion fee
1608   function addSpecialFeeTake(address token, uint256 balance, uint256 feeTake) public isAdmin {
1609       uint id = specialFees.push(SpecialTokenBalanceFeeTake(
1610           true,
1611           token,
1612           balance,
1613           feeTake
1614       ));
1615   }
1616   
1617   // chnage special promotion fee
1618   function chnageSpecialFeeTake(uint id, address token, uint256 balance, uint256 feeTake) public isAdmin {
1619       require(id < specialFees.length);
1620       specialFees[id] = SpecialTokenBalanceFeeTake(
1621           true,
1622           token,
1623           balance,
1624           feeTake
1625       );
1626   }
1627   
1628     // remove special promotion fee
1629    function removeSpecialFeeTake(uint id) public isAdmin {
1630        if (id >= specialFees.length) revert();
1631 
1632         uint last = specialFees.length-1;
1633         for (uint i = id; i<last; i++){
1634             specialFees[i] = specialFees[i+1];
1635         }
1636         
1637         delete specialFees[last];
1638         specialFees.length--;
1639   } 
1640   
1641   //return total count promotion fees
1642   function TotalSpecialFeeTakes() public constant returns(uint)  {
1643       return specialFees.length;
1644   }
1645   
1646   
1647   ////////////////////////////////////////////////////////////////////////////////
1648   // Deposits, Withdrawals, Balances
1649   ////////////////////////////////////////////////////////////////////////////////
1650 
1651   /**
1652   * This function handles deposits of Ether into the contract.
1653   * Emits a Deposit event.
1654   * Note: With the payable modifier, this function accepts Ether.
1655   */
1656   function deposit() public payable {
1657     tokens[0][msg.sender] = tokens[0][msg.sender].add(msg.value);
1658     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
1659   }
1660 
1661   /**
1662   * This function handles withdrawals of Ether from the contract.
1663   * Verifies that the user has enough funds to cover the withdrawal.
1664   * Emits a Withdraw event.
1665   * @param amount uint of the amount of Ether the user wishes to withdraw
1666   */
1667   function withdraw(uint amount) public {
1668     require(tokens[0][msg.sender] >= amount);
1669     tokens[0][msg.sender] = tokens[0][msg.sender].sub(amount);
1670     msg.sender.transfer(amount);
1671     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
1672   }
1673 
1674   /**
1675   * This function handles deposits of Ethereum based tokens to the contract.
1676   * Does not allow Ether.
1677   * If token transfer fails, transaction is reverted and remaining gas is refunded.
1678   * Emits a Deposit event.
1679   * Note: Remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
1680   * @param token Ethereum contract address of the token or 0 for Ether
1681   * @param amount uint of the amount of the token the user wishes to deposit
1682   */
1683   function depositToken(address token, uint amount) public {
1684     require(token != 0);
1685     depositingTokenFlag = true;
1686     require(IToken(token).transferFrom(msg.sender, this, amount));
1687     depositingTokenFlag = false;
1688     tokens[token][msg.sender] = tokens[token][msg.sender].add(amount);
1689     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
1690  }
1691 
1692   /**
1693   * This function provides a fallback solution as outlined in ERC223.
1694   * If tokens are deposited through depositToken(), the transaction will continue.
1695   * If tokens are sent directly to this contract, the transaction is reverted.
1696   * @param sender Ethereum address of the sender of the token
1697   * @param amount amount of the incoming tokens
1698   * @param data attached data similar to msg.data of Ether transactions
1699   */
1700   function tokenFallback( address sender, uint amount, bytes data) public returns (bool ok) {
1701       if (depositingTokenFlag) {
1702         // Transfer was initiated from depositToken(). User token balance will be updated there.
1703         return true;
1704       } else {
1705         // Direct ECR223 Token.transfer into this contract not allowed, to keep it consistent
1706         // with direct transfers of ECR20 and ETH.
1707         revert();
1708       }
1709   }
1710   
1711   /**
1712   * This function handles withdrawals of Ethereum based tokens from the contract.
1713   * Does not allow Ether.
1714   * If token transfer fails, transaction is reverted and remaining gas is refunded.
1715   * Emits a Withdraw event.
1716   * @param token Ethereum contract address of the token or 0 for Ether
1717   * @param amount uint of the amount of the token the user wishes to withdraw
1718   */
1719   function withdrawToken(address token, uint amount) public {
1720     require(token != 0);
1721     require(tokens[token][msg.sender] >= amount);
1722     tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);
1723     require(IToken(token).transfer(msg.sender, amount));
1724     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
1725   }
1726 
1727   /**
1728   * Retrieves the balance of a token based on a user address and token address.
1729   * @param token Ethereum contract address of the token or 0 for Ether
1730   * @param user Ethereum address of the user
1731   * @return the amount of tokens on the exchange for a given user address
1732   */
1733   function balanceOf(address token, address user) public constant returns (uint) {
1734     return tokens[token][user];
1735   }
1736 
1737   ////////////////////////////////////////////////////////////////////////////////
1738   // Trading
1739   ////////////////////////////////////////////////////////////////////////////////
1740 
1741   /**
1742   * Facilitates a trade from one user to another.
1743   * Requires that the transaction is signed properly, the trade isn't past its expiration, and all funds are present to fill the trade.
1744   * Calls tradeBalances().
1745   * Updates orderFills with the amount traded.
1746   * Emits a Trade event.
1747   * Note: tokenGet & tokenGive can be the Ethereum contract address.
1748   * Note: amount is in amountGet / tokenGet terms.
1749   * @param tokenGet Ethereum contract address of the token to receive
1750   * @param amountGet uint amount of tokens being received
1751   * @param tokenGive Ethereum contract address of the token to give
1752   * @param amountGive uint amount of tokens being given
1753   * @param expires uint of block number when this order should expire
1754   * @param nonce arbitrary random number
1755   * @param user Ethereum address of the user who placed the order
1756   * @param v part of signature for the order hash as signed by user
1757   * @param r part of signature for the order hash as signed by user
1758   * @param s part of signature for the order hash as signed by user
1759   * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
1760   */
1761   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
1762     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
1763     require((
1764       (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user) &&
1765       block.number <= expires &&
1766       orderFills[user][hash].add(amount) <= amountGet
1767     ));
1768     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
1769     orderFills[user][hash] = orderFills[user][hash].add(amount);
1770     Trade(tokenGet, amount, tokenGive, amountGive.mul(amount) / amountGet, user, msg.sender);
1771   }
1772 
1773   /**
1774   * This is a private function and is only being called from trade().
1775   * Handles the movement of funds when a trade occurs.
1776   * Takes fees.
1777   * Updates token balances for both buyer and seller.
1778   * Note: tokenGet & tokenGive can be the Ethereum contract address.
1779   * Note: amount is in amountGet / tokenGet terms.
1780   * @param tokenGet Ethereum contract address of the token to receive
1781   * @param amountGet uint amount of tokens being received
1782   * @param tokenGive Ethereum contract address of the token to give
1783   * @param amountGive uint amount of tokens being given
1784   * @param user Ethereum address of the user who placed the order
1785   * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
1786   */
1787   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
1788     
1789     uint256 feeTakeXfer = calculateFee(amount);
1790     
1791     tokens[tokenGet][msg.sender] = tokens[tokenGet][msg.sender].sub(amount.add(feeTakeXfer));
1792     tokens[tokenGet][user] = tokens[tokenGet][user].add(amount);
1793     tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].add(feeTakeXfer);
1794     tokens[tokenGive][user] = tokens[tokenGive][user].sub(amountGive.mul(amount).div(amountGet));
1795     tokens[tokenGive][msg.sender] = tokens[tokenGive][msg.sender].add(amountGive.mul(amount).div(amountGet));
1796   }
1797   
1798   //calculate fee including special promotions
1799   function calculateFee(uint amount) private constant returns(uint256)  {
1800     uint256 feeTakeXfer = 0;
1801     
1802     uint length = specialFees.length;
1803     bool applied = false;
1804     for(uint i = 0; length > 0 && i < length; i++) {
1805         SpecialTokenBalanceFeeTake memory special = specialFees[i];
1806         if(special.exist && special.balance <= tokens[special.token][msg.sender]) {
1807             applied = true;
1808             feeTakeXfer = amount.mul(special.feeTake).div(1 ether);
1809             break;
1810         }
1811         if(i >= MAX_SPECIALS)
1812             break;
1813     }
1814     
1815     if(!applied)
1816         feeTakeXfer = amount.mul(feeTake).div(1 ether);
1817     
1818     
1819     return feeTakeXfer;
1820   }
1821 
1822   /**
1823   * This function is to test if a trade would go through.
1824   * Note: tokenGet & tokenGive can be the Ethereum contract address.
1825   * Note: amount is in amountGet / tokenGet terms.
1826   * @param tokenGet Ethereum contract address of the token to receive
1827   * @param amountGet uint amount of tokens being received
1828   * @param tokenGive Ethereum contract address of the token to give
1829   * @param amountGive uint amount of tokens being given
1830   * @param expires uint of block number when this order should expire
1831   * @param nonce arbitrary random number
1832   * @param user Ethereum address of the user who placed the order
1833   * @param v part of signature for the order hash as signed by user
1834   * @param r part of signature for the order hash as signed by user
1835   * @param s part of signature for the order hash as signed by user
1836   * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
1837   * @param sender Ethereum address of the user taking the order
1838   * @return bool: true if the trade would be successful, false otherwise
1839   */
1840   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns(bool) {
1841     if (!(
1842       tokens[tokenGet][sender] >= amount &&
1843       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
1844       )) { 
1845       return false;
1846     } else {
1847       return true;
1848     }
1849   }
1850 
1851   /**
1852   * This function checks the available volume for a given order.
1853   * Note: tokenGet & tokenGive can be the Ethereum contract address.
1854   * @param tokenGet Ethereum contract address of the token to receive
1855   * @param amountGet uint amount of tokens being received
1856   * @param tokenGive Ethereum contract address of the token to give
1857   * @param amountGive uint amount of tokens being given
1858   * @param expires uint of block number when this order should expire
1859   * @param nonce arbitrary random number
1860   * @param user Ethereum address of the user who placed the order
1861   * @param v part of signature for the order hash as signed by user
1862   * @param r part of signature for the order hash as signed by user
1863   * @param s part of signature for the order hash as signed by user
1864   * @return uint: amount of volume available for the given order in terms of amountGet / tokenGet
1865   */
1866   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
1867     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
1868     if (!(
1869       (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user) &&
1870       block.number <= expires
1871       )) {
1872       return 0;
1873     }
1874     uint[2] memory available;
1875     available[0] = amountGet.sub(orderFills[user][hash]);
1876     available[1] = tokens[tokenGive][user].mul(amountGet) / amountGive;
1877     if (available[0] < available[1]) {
1878       return available[0];
1879     } else {
1880       return available[1];
1881     }
1882   }
1883 
1884   /**
1885   * This function checks the amount of an order that has already been filled.
1886   * Note: tokenGet & tokenGive can be the Ethereum contract address.
1887   * @param tokenGet Ethereum contract address of the token to receive
1888   * @param amountGet uint amount of tokens being received
1889   * @param tokenGive Ethereum contract address of the token to give
1890   * @param amountGive uint amount of tokens being given
1891   * @param expires uint of block number when this order should expire
1892   * @param nonce arbitrary random number
1893   * @param user Ethereum address of the user who placed the order
1894   * @param v part of signature for the order hash as signed by user
1895   * @param r part of signature for the order hash as signed by user
1896   * @param s part of signature for the order hash as signed by user
1897   * @return uint: amount of the given order that has already been filled in terms of amountGet / tokenGet
1898   */
1899   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
1900     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
1901     return orderFills[user][hash];
1902   }
1903 
1904   /**
1905   * This function cancels a given order by editing its fill data to the full amount.
1906   * Requires that the transaction is signed properly.
1907   * Updates orderFills to the full amountGet
1908   * Emits a Cancel event.
1909   * Note: tokenGet & tokenGive can be the Ethereum contract address.
1910   * @param tokenGet Ethereum contract address of the token to receive
1911   * @param amountGet uint amount of tokens being received
1912   * @param tokenGive Ethereum contract address of the token to give
1913   * @param amountGive uint amount of tokens being given
1914   * @param expires uint of block number when this order should expire
1915   * @param nonce arbitrary random number
1916   * @param v part of signature for the order hash as signed by user
1917   * @param r part of signature for the order hash as signed by user
1918   * @param s part of signature for the order hash as signed by user
1919   * @return uint: amount of the given order that has already been filled in terms of amountGet / tokenGet
1920   */
1921   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
1922     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
1923     require ((ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == msg.sender));
1924     orderFills[msg.sender][hash] = amountGet;
1925     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
1926   }
1927 
1928   
1929   /**
1930   * This function handles deposits of Ether into the contract, but allows specification of a user.
1931   * Note: This is generally used in migration of funds.
1932   * Note: With the payable modifier, this function accepts Ether.
1933   */
1934   function depositForUser(address user) public payable {
1935     require(user != address(0));
1936     require(msg.value > 0);
1937     tokens[0][user] = tokens[0][user].add(msg.value);
1938   }
1939   
1940   /**
1941   * This function handles deposits of Ethereum based tokens into the contract, but allows specification of a user.
1942   * Does not allow Ether.
1943   * If token transfer fails, transaction is reverted and remaining gas is refunded.
1944   * Note: This is generally used in migration of funds.
1945   * Note: Remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
1946   * @param token Ethereum contract address of the token
1947   * @param amount uint of the amount of the token the user wishes to deposit
1948   */
1949   function depositTokenForUser(address token, uint amount, address user) public {
1950     require(token != address(0));
1951     require(user != address(0));
1952     require(amount > 0);
1953     depositingTokenFlag = true;
1954     require(IToken(token).transferFrom(msg.sender, this, amount));
1955     depositingTokenFlag = false;
1956     tokens[token][user] = tokens[token][user].add(amount);
1957   }
1958   
1959 }