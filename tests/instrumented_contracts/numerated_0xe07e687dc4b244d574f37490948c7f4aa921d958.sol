1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a * b;
12         assert(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 
36 
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  */
42 contract ERC20Basic {
43     uint256 public totalSupply;
44     function balanceOf(address who) public constant returns (uint256);
45     function transfer(address to, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title ERC20 interface
51  */
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) public constant returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65     address public owner;
66 
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72      * account.
73      */
74     function Ownable() public {
75         owner = msg.sender;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     /**
87      * @dev Allows the current owner to transfer control of the contract to a newOwner.
88      * @param newOwner The address to transfer ownership to.
89      */
90     function transferOwnership(address newOwner) public onlyOwner {
91         require(newOwner != address(0));
92         OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94     }
95 
96 }
97 
98 /**
99  * @title Pausable
100  * @dev Base contract which allows children to implement an emergency stop mechanism.
101  */
102 contract Pausable is Ownable {
103     event Pause();
104     event Unpause();
105 
106     bool public paused = false;
107 
108     /**
109      * @dev Modifier to make a function callable only when the contract is not paused.
110      */
111     modifier whenNotPaused() {
112         require(!paused);
113         _;
114     }
115 
116     /**
117      * @dev Modifier to make a function callable only when the contract is paused.
118      */
119     modifier whenPaused() {
120         require(paused);
121         _;
122     }
123 
124     /**
125      * @dev called by the owner to pause, triggers stopped state
126      */
127     function pause() public onlyOwner whenNotPaused {
128         paused = true;
129         Pause();
130     }
131 
132     /**
133      * @dev called by the owner to unpause, returns to normal state
134      */
135     function unpause() public onlyOwner whenPaused {
136         paused = false;
137         Unpause();
138     }
139 }
140 
141 
142 
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances.
146  */
147 contract BasicToken is ERC20Basic {
148     using SafeMath for uint256;
149 
150     mapping(address => uint256) balances;
151 
152     /**
153     * @dev transfer token for a specified address
154     * @param _to The address to transfer to.
155     * @param _value The amount to be transferred.
156     */
157     function transfer(address _to, uint256 _value) public returns (bool) {
158         require(_to != address(0));
159         require(_value <= balances[msg.sender]);
160 
161         // SafeMath.sub will throw if there is not enough balance.
162         balances[msg.sender] = balances[msg.sender].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         Transfer(msg.sender, _to, _value);
165         return true;
166     }
167 
168     /**
169     * @dev Gets the balance of the specified address.
170     * @param _owner The address to query the the balance of.
171     * @return An uint256 representing the amount owned by the passed address.
172     */
173     function balanceOf(address _owner) public constant returns (uint256 balance) {
174         return balances[_owner];
175     }
176 
177 }
178 
179 
180 /**
181  * @title RefundVault
182  * @dev This contract is used for storing funds while a crowdsale
183  * is in progress. Supports refunding the money if crowdsale fails,
184  * and forwarding it if crowdsale is successful.
185  */
186 contract RefundVault is Ownable {
187     using SafeMath for uint256;
188 
189     enum State { Active, Refunding, Closed }
190 
191     mapping (address => uint256) public deposited;
192     address public wallet;
193     State public state;
194 
195     event Closed();
196     event RefundsEnabled();
197     event Refunded(address indexed beneficiary, uint256 weiAmount);
198 
199     function RefundVault(address _wallet) public {
200         require(_wallet != 0x0);
201         wallet = _wallet;
202         state = State.Active;
203     }
204 
205     function deposit(address investor) public onlyOwner  payable {
206         require(state == State.Active);
207         deposited[investor] = deposited[investor].add(msg.value);
208     }
209 
210     function close() public onlyOwner {
211         require(state == State.Active);
212         state = State.Closed;
213         Closed();
214         wallet.transfer(this.balance);
215     }
216 
217     function enableRefunds() public onlyOwner {
218         require(state == State.Active);
219         state = State.Refunding;
220         RefundsEnabled();
221     }
222 
223     function refund(address investor) public {
224         require(state == State.Refunding);
225         uint256 depositedValue = deposited[investor];
226         deposited[investor] = 0;
227         investor.transfer(depositedValue);
228         Refunded(investor, depositedValue);
229     }
230 }
231 
232 
233 /**
234  * @title Standard ERC20 token
235  *
236  * @dev Implementation of the basic standard token.
237  * @dev Based on code by FirstBlood:
238  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
239  */
240 contract StandardToken is ERC20, BasicToken {
241 
242     mapping (address => mapping (address => uint256)) internal allowed;
243 
244     /**
245      * @dev Transfer tokens from one address to another
246      * @param _from address The address which you want to send tokens from
247      * @param _to address The address which you want to transfer to
248      * @param _value uint256 the amount of tokens to be transferred
249      */
250     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
251         require(_to != address(0));
252         require(_value <= balances[_from]);
253         require(_value <= allowed[_from][msg.sender]);
254 
255         balances[_from] = balances[_from].sub(_value);
256         balances[_to] = balances[_to].add(_value);
257         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
258         Transfer(_from, _to, _value);
259         return true;
260     }
261 
262     /**
263      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
264      *
265      * Beware that changing an allowance with this method brings the risk that someone may use both the old
266      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
267      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
268      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269      * @param _spender The address which will spend the funds.
270      * @param _value The amount of tokens to be spent.
271      */
272     function approve(address _spender, uint256 _value) public returns (bool) {
273 
274         // To change the approve amount you first have to reduce the addresses`
275         //  allowance to zero by calling `approve(_spender, 0)` if it is not
276         //  already 0 to mitigate the race condition described here:
277         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
278         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
279 
280         allowed[msg.sender][_spender] = _value;
281         Approval(msg.sender, _spender, _value);
282         return true;
283     }
284 
285     /**
286      * @dev Function to check the amount of tokens that an owner allowed to a spender.
287      * @param _owner address The address which owns the funds.
288      * @param _spender address The address which will spend the funds.
289      * @return A uint256 specifying the amount of tokens still available for the spender.
290      */
291     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
292         return allowed[_owner][_spender];
293     }
294 
295     /**
296      * approve should be called when allowed[_spender] == 0. To increment
297      * allowed value is better to use this function to avoid 2 calls (and wait until
298      * the first transaction is mined)
299      * From MonolithDAO Token.sol
300      */
301     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
302         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
303         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304         return true;
305     }
306 
307     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
308         uint oldValue = allowed[msg.sender][_spender];
309         if (_subtractedValue > oldValue) {
310             allowed[msg.sender][_spender] = 0;
311         } else {
312             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
313         }
314         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315         return true;
316     }
317 
318 }
319 
320 
321 contract PausableToken is StandardToken, Pausable {
322 
323     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
324         return super.transfer(_to, _value);
325     }
326 
327     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
328         return super.transferFrom(_from, _to, _value);
329     }
330 
331     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
332         return super.approve(_spender, _value);
333     }
334 
335     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
336         return super.increaseApproval(_spender, _addedValue);
337     }
338 
339     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
340         return super.decreaseApproval(_spender, _subtractedValue);
341     }
342 }
343 
344 
345 contract ApplauseCashToken is StandardToken, PausableToken {
346     string public constant name = "ApplauseCash";
347     string public constant symbol = "APLC";
348     uint8 public constant decimals = 4;
349     uint256 public INITIAL_SUPPLY = 300000000 * 10000;
350 
351     function ApplauseCashToken() public {
352         totalSupply = INITIAL_SUPPLY;
353         balances[msg.sender] = INITIAL_SUPPLY;
354     }
355 }
356 
357 
358 
359 /**
360  * @title Crowdsale
361  * @dev Modified contract for managing a token crowdsale.
362  * ApplauseCashCrowdsale have pre-sale and main sale periods,
363  * where investors can make token purchases and the crowdsale will assign
364  * them tokens based on a token per ETH rate and the system of bonuses.
365  * Funds collected are forwarded to a wallet as they arrive.
366  * pre-sale and main sale periods both have caps defined in tokens.
367  */
368 
369 contract ApplauseCashCrowdsale is Ownable {
370 
371     using SafeMath for uint256;
372 
373     struct Bonus {
374         uint duration;
375         uint percent;
376     }
377 
378     // minimum amount of funds to be raised in tokens
379     uint256 public softcap;
380 
381     // refund vault used to hold funds while crowdsale is running
382     RefundVault public vault;
383 
384     // true for finalised crowdsale
385     bool public isFinalized;
386 
387     // The token being sold
388     ApplauseCashToken public token = new ApplauseCashToken();
389 
390     // start and end timestamps where pre-investments are allowed (both inclusive)
391     uint256 public preIcoStartTime;
392     uint256 public preIcoEndTime;
393 
394     // start and end timestamps where main-investments are allowed (both inclusive)
395     uint256 public icoStartTime;
396     uint256 public icoEndTime;
397 
398     // maximum amout of tokens for pre-sale and main sale
399     uint256 public preIcoHardcap;
400     uint256 public icoHardcap;
401 
402     // address where funds are collected
403     address public wallet;
404 
405     // how many token units a buyer gets per ETH
406     uint256 public rate;
407 
408     // amount of raised tokens
409     uint256 public tokensInvested;
410 
411     Bonus[] public preIcoBonuses;
412     Bonus[] public icoBonuses;
413 
414     // Invstors can't invest less then specified numbers in wei
415     uint256 public preIcoMinimumWei;
416     uint256 public icoMinimumWei;
417 
418     // Default bonus %
419     uint256 public defaultPercent;
420 
421     /**
422      * event for token purchase logging
423      * @param purchaser who paid for the tokens
424      * @param beneficiary who got the tokens
425      * @param value weis paid for purchase
426      * @param amount amount of tokens purchased
427      */
428     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
429 
430     function ApplauseCashCrowdsale(
431         uint256 _preIcoStartTime,
432         uint256 _preIcoEndTime,
433         uint256 _preIcoHardcap,
434         uint256 _icoStartTime,
435         uint256 _icoEndTime,
436         uint256 _icoHardcap,
437         uint256 _softcap,
438         uint256 _rate,
439         address _wallet
440     ) public {
441 
442         //require(_softcap > 0);
443 
444         // can't start pre-sale in the past
445         require(_preIcoStartTime >= now);
446 
447         // can't start main sale in the past
448         require(_icoStartTime >= now);
449 
450         // can't start main sale before the end of pre-sale
451         require(_preIcoEndTime < _icoStartTime);
452 
453         // the end of pre-sale can't happen before it's start
454         require(_preIcoStartTime < _preIcoEndTime);
455 
456         // the end of main sale can't happen before it's start
457         require(_icoStartTime < _icoEndTime);
458 
459         require(_rate > 0);
460         require(_preIcoHardcap > 0);
461         require(_icoHardcap > 0);
462         require(_wallet != 0x0);
463 
464         preIcoMinimumWei = 20000000000000000;  // 0.02 Ether default minimum
465         icoMinimumWei = 20000000000000000; // 0.02 Ether default minimum
466         defaultPercent = 0;
467 
468         preIcoBonuses.push(Bonus({duration: 1 hours, percent: 90}));
469         preIcoBonuses.push(Bonus({duration: 6 days + 5 hours, percent: 50}));
470 
471         icoBonuses.push(Bonus({duration: 1 hours, percent: 45}));
472         icoBonuses.push(Bonus({duration: 7 days + 15 hours, percent: 40}));
473         icoBonuses.push(Bonus({duration: 6 days, percent: 30}));
474         icoBonuses.push(Bonus({duration: 6 days, percent: 20}));
475         icoBonuses.push(Bonus({duration: 7 days, percent: 10}));
476 
477         preIcoStartTime = _preIcoStartTime;
478         preIcoEndTime = _preIcoEndTime;
479         preIcoHardcap = _preIcoHardcap;
480         icoStartTime = _icoStartTime;
481         icoEndTime = _icoEndTime;
482         icoHardcap = _icoHardcap;
483         softcap = _softcap;
484         rate = _rate;
485         wallet = _wallet;
486 
487         isFinalized = false;
488 
489         vault = new RefundVault(wallet);
490     }
491 
492     // fallback function can be used to buy tokens
493     function () public payable {
494         buyTokens(msg.sender);
495     }
496 
497     // low level token purchase function
498     function buyTokens(address beneficiary) public payable {
499 
500         require(beneficiary != 0x0);
501         require(msg.value != 0);
502         require(!isFinalized);
503 
504         uint256 weiAmount = msg.value;
505 
506         validateWithinPeriods();
507 
508         // calculate token amount to be created.
509         // ETH and our tokens have different numbers of decimals after comma
510         // ETH - 18 decimals, our tokes - 4. so we need to divide our value
511         // by 1e14 (18 - 4 == 14).
512         uint256 tokens = weiAmount.mul(rate).div(100000000000000);
513 
514         uint256 percent = getBonusPercent(now);
515 
516         // add bonus to tokens depends on the period
517         uint256 bonusedTokens = applyBonus(tokens, percent);
518 
519         validateWithinCaps(bonusedTokens, weiAmount);
520 
521         // update state
522         tokensInvested = tokensInvested.add(bonusedTokens);
523         token.transfer(beneficiary, bonusedTokens);
524         TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
525 
526         forwardFunds();
527     }
528     
529     // owner can transfer tokens
530     function transferTokens(address beneficiary, uint256 tokens) public onlyOwner {
531         token.transfer(beneficiary, tokens);
532     }
533 
534     // set new dates for pre-salev (emergency case)
535     function setPreIcoParameters(
536         uint256 _preIcoStartTime,
537         uint256 _preIcoEndTime,
538         uint256 _preIcoHardcap,
539         uint256 _preIcoMinimumWei
540     ) public onlyOwner {
541         require(!isFinalized);
542         require(_preIcoStartTime < _preIcoEndTime);
543         require(_preIcoHardcap > 0);
544         preIcoStartTime = _preIcoStartTime;
545         preIcoEndTime = _preIcoEndTime;
546         preIcoHardcap = _preIcoHardcap;
547         preIcoMinimumWei = _preIcoMinimumWei;
548     }
549 
550     // set new dates for main-sale (emergency case)
551     function setIcoParameters(
552         uint256 _icoStartTime,
553         uint256 _icoEndTime,
554         uint256 _icoHardcap,
555         uint256 _icoMinimumWei
556     ) public onlyOwner {
557 
558         require(!isFinalized);
559         require(_icoStartTime < _icoEndTime);
560         require(_icoHardcap > 0);
561         icoStartTime = _icoStartTime;
562         icoEndTime = _icoEndTime;
563         icoHardcap = _icoHardcap;
564         icoMinimumWei = _icoMinimumWei;
565     }
566 
567     // set new wallets (emergency case)
568     function setWallet(address _wallet) public onlyOwner {
569         require(!isFinalized);
570         require(_wallet != 0x0);
571         wallet = _wallet;
572     }
573 
574       // set new rate (emergency case)
575     function setRate(uint256 _rate) public onlyOwner {
576         require(!isFinalized);
577         require(_rate > 0);
578         rate = _rate;
579     }
580 
581         // set new softcap (emergency case)
582     function setSoftcap(uint256 _softcap) public onlyOwner {
583         require(!isFinalized);
584         require(_softcap > 0);
585         softcap = _softcap;
586     }
587 
588 
589     // set token on pause
590     function pauseToken() external onlyOwner {
591         require(!isFinalized);
592         token.pause();
593     }
594 
595     // unset token's pause
596     function unpauseToken() external onlyOwner {
597         token.unpause();
598     }
599 
600     // set token Ownership
601     function transferTokenOwnership(address newOwner) external onlyOwner {
602         token.transferOwnership(newOwner);
603     }
604 
605     // @return true if main sale event has ended
606     function icoHasEnded() external constant returns (bool) {
607         return now > icoEndTime;
608     }
609 
610     // @return true if pre sale event has ended
611     function preIcoHasEnded() external constant returns (bool) {
612         return now > preIcoEndTime;
613     }
614 
615     // send ether to the fund collection wallet
616     function forwardFunds() internal {
617         //wallet.transfer(msg.value);
618         vault.deposit.value(msg.value)(msg.sender);
619     }
620 
621     // we want to be able to check all bonuses in already deployed contract
622     // that's why we pass currentTime as a parameter instead of using "now"
623     function getBonusPercent(uint256 currentTime) public constant returns (uint256 percent) {
624       //require(currentTime >= preIcoStartTime);
625         uint i = 0;
626         bool isPreIco = currentTime >= preIcoStartTime && currentTime <= preIcoEndTime;
627         uint256 offset = 0;
628         if (isPreIco) {
629             uint256 preIcoDiffInSeconds = currentTime.sub(preIcoStartTime);
630             for (i = 0; i < preIcoBonuses.length; i++) {
631                 if (preIcoDiffInSeconds <= preIcoBonuses[i].duration + offset) {
632                     return preIcoBonuses[i].percent;
633                 }
634                 offset = offset.add(preIcoBonuses[i].duration);
635             }
636         } else {
637             uint256 icoDiffInSeconds = currentTime.sub(icoStartTime);
638             for (i = 0; i < icoBonuses.length; i++) {
639                 if (icoDiffInSeconds <= icoBonuses[i].duration + offset) {
640                     return icoBonuses[i].percent;
641                 }
642                 offset = offset.add(icoBonuses[i].duration);
643             }
644         }
645         return defaultPercent;
646     }
647 
648     function applyBonus(uint256 tokens, uint256 percent) internal pure returns  (uint256 bonusedTokens) {
649         uint256 tokensToAdd = tokens.mul(percent).div(100);
650         return tokens.add(tokensToAdd);
651     }
652 
653     function validateWithinPeriods() internal constant {
654         // within pre-sale or main sale
655         require((now >= preIcoStartTime && now <= preIcoEndTime) || (now >= icoStartTime && now <= icoEndTime));
656     }
657 
658     function validateWithinCaps(uint256 tokensAmount, uint256 weiAmount) internal constant {
659         uint256 expectedTokensInvested = tokensInvested.add(tokensAmount);
660 
661         // within pre-sale
662         if (now >= preIcoStartTime && now <= preIcoEndTime) {
663             require(weiAmount >= preIcoMinimumWei);
664             require(expectedTokensInvested <= preIcoHardcap);
665         }
666 
667         // within main sale
668         if (now >= icoStartTime && now <= icoEndTime) {
669             require(expectedTokensInvested <= icoHardcap);
670         }
671     }
672 
673     // if crowdsale is unsuccessful, investors can claim refunds here
674     function claimRefund() public {
675         require(isFinalized);
676         require(!softcapReached());
677         vault.refund(msg.sender);
678     }
679 
680     function softcapReached() public constant returns (bool) {
681         return tokensInvested >= softcap;
682     }
683 
684     // finish crowdsale
685     function finaliseCrowdsale() external onlyOwner returns (bool) {
686         require(!isFinalized);
687         if (softcapReached()) {
688             vault.close();
689         } else {
690             vault.enableRefunds();
691         }
692 
693         isFinalized = true;
694         return true;
695     }
696 
697 }
698 
699 
700 contract Deployer is Ownable {
701 
702     ApplauseCashCrowdsale public applauseCashCrowdsale;
703     uint256 public constant TOKEN_DECIMALS_MULTIPLIER = 10000;
704     address public multisig = 0xaB188aCBB8a401277DC2D83C242677ca3C96fF05;
705 
706     function deploy() public onlyOwner {
707         applauseCashCrowdsale = new ApplauseCashCrowdsale(
708             1516280400, //Pre ICO Start: 18 Jan 2018 at 8:00 am EST
709             1516856400, //Pre ICO End: 24 Jan 2018 at 11:59 pm EST
710             3000000 * TOKEN_DECIMALS_MULTIPLIER, //Pre ICO hardcap
711             1517490000,  // ICO Start: 1 Feb 2018 at 8 am EST
712             1519880400, // ICO End: 28 Feb 2018 at 11.59 pm EST
713             144000000 * TOKEN_DECIMALS_MULTIPLIER,  // ICO hardcap
714             50000 * TOKEN_DECIMALS_MULTIPLIER, // Overal crowdsale softcap
715             500, // 1 ETH = 500 APLC
716             multisig // Multisignature wallet (controlled by multiple accounts)
717         );
718     }
719 
720     function setOwner() public onlyOwner {
721         applauseCashCrowdsale.transferOwnership(owner);
722     }
723 
724 
725 }