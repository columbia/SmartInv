1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42     uint256 public totalSupply;
43 
44     function balanceOf(address who) public view returns (uint256);
45 
46     function transfer(address to, uint256 value) public returns (bool);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 is ERC20Basic {
57     function allowance(address owner, address spender) public view returns (uint256);
58 
59     function transferFrom(address from, address to, uint256 value) public returns (bool);
60 
61     function approve(address spender, uint256 value) public returns (bool);
62 
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract ShortAddressProtection {
67 
68     modifier onlyPayloadSize(uint256 numwords) {
69         assert(msg.data.length >= numwords * 32 + 4);
70         _;
71     }
72 }
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic, ShortAddressProtection {
79     using SafeMath for uint256;
80 
81     mapping(address => uint256) internal balances;
82 
83     /**
84     * @dev transfer token for a specified address
85     * @param _to The address to transfer to.
86     * @param _value The amount to be transferred.
87     */
88     function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool) {
89         require(_to != address(0));
90         require(_value <= balances[msg.sender]);
91 
92         // SafeMath.sub will throw if there is not enough balance.
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         Transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     /**
100     * @dev Gets the balance of the specified address.
101     * @param _owner The address to query the the balance of.
102     * @return An uint256 representing the amount owned by the passed address.
103     */
104     function balanceOf(address _owner) public view returns (uint256 balance) {
105         return balances[_owner];
106     }
107 
108 }
109 
110 /**
111  * @title Standard ERC20 token
112  *
113  * @dev Implementation of the basic standard token.
114  * @dev https://github.com/ethereum/EIPs/issues/20
115  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
116  */
117 contract StandardToken is ERC20, BasicToken {
118 
119     mapping(address => mapping(address => uint256)) internal allowed;
120 
121 
122     /**
123      * @dev Transfer tokens from one address to another
124      * @param _from address The address which you want to send tokens from
125      * @param _to address The address which you want to transfer to
126      * @param _value uint256 the amount of tokens to be transferred
127      */
128     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool) {
129         require(_to != address(0));
130         require(_value <= balances[_from]);
131         require(_value <= allowed[_from][msg.sender]);
132 
133         balances[_from] = balances[_from].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136         Transfer(_from, _to, _value);
137         return true;
138     }
139 
140     /**
141      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
142      *
143      * Beware that changing an allowance with this method brings the risk that someone may use both the old
144      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
145      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      * @param _spender The address which will spend the funds.
148      * @param _value The amount of tokens to be spent.
149      */
150     function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool) {
151         //require user to set to zero before resetting to nonzero
152         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
153 
154         allowed[msg.sender][_spender] = _value;
155         Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159     /**
160      * @dev Function to check the amount of tokens that an owner allowed to a spender.
161      * @param _owner address The address which owns the funds.
162      * @param _spender address The address which will spend the funds.
163      * @return A uint256 specifying the amount of tokens still available for the spender.
164      */
165     function allowance(address _owner, address _spender) public view returns (uint256) {
166         return allowed[_owner][_spender];
167     }
168 
169     /**
170      * @dev Increase the amount of tokens that an owner allowed to a spender.
171      *
172      * approve should be called when allowed[_spender] == 0. To increment
173      * allowed value is better to use this function to avoid 2 calls (and wait until
174      * the first transaction is mined)
175      * From MonolithDAO Token.sol
176      * @param _spender The address which will spend the funds.
177      * @param _addedValue The amount of tokens to increase the allowance by.
178      */
179     function increaseApproval(address _spender, uint _addedValue) onlyPayloadSize(2) public returns (bool) {
180         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 
185     /**
186      * @dev Decrease the amount of tokens that an owner allowed to a spender.
187      *
188      * approve should be called when allowed[_spender] == 0. To decrement
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * @param _spender The address which will spend the funds.
193      * @param _subtractedValue The amount of tokens to decrease the allowance by.
194      */
195     function decreaseApproval(address _spender, uint _subtractedValue) onlyPayloadSize(2) public returns (bool) {
196         uint oldValue = allowed[msg.sender][_spender];
197         if (_subtractedValue > oldValue) {
198             allowed[msg.sender][_spender] = 0;
199         } else {
200             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
201         }
202         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203         return true;
204     }
205 }
206 
207 contract Ownable {
208     address public owner;
209 
210     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
211 
212 
213     /**
214      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
215      * account.
216      */
217     function Ownable() public {
218         owner = msg.sender;
219     }
220 
221     /**
222      * @dev Throws if called by any account other than the owner.
223      */
224     modifier onlyOwner() {
225         require(msg.sender == owner);
226         _;
227     }
228 
229     /**
230      * @dev Allows the current owner to transfer control of the contract to a newOwner.
231      * @param newOwner The address to transfer ownership to.
232      */
233     function transferOwnership(address newOwner) public onlyOwner {
234         require(newOwner != address(0));
235         OwnershipTransferred(owner, newOwner);
236         owner = newOwner;
237     }
238 }
239 
240 /**
241  * @title MintableToken token
242  */
243 contract MintableToken is Ownable, StandardToken {
244 
245     event Mint(address indexed to, uint256 amount);
246     event MintFinished();
247 
248     bool public mintingFinished = false;
249 
250     address public saleAgent;
251 
252     modifier canMint() {
253         require(!mintingFinished);
254         _;
255     }
256 
257     modifier onlySaleAgent() {
258         require(msg.sender == saleAgent);
259         _;
260     }
261 
262     function setSaleAgent(address _saleAgent) onlyOwner public {
263         require(_saleAgent != address(0));
264         saleAgent = _saleAgent;
265     }
266 
267     /**
268      * @dev Function to mint tokens
269      * @param _to The address that will receive the minted tokens.
270      * @param _amount The amount of tokens to mint.
271      * @return A boolean that indicates if the operation was successful.
272      */
273     function mint(address _to, uint256 _amount) onlySaleAgent canMint public returns (bool) {
274         totalSupply = totalSupply.add(_amount);
275         balances[_to] = balances[_to].add(_amount);
276         Mint(_to, _amount);
277         Transfer(address(0), _to, _amount);
278         return true;
279     }
280 
281     /**
282      * @dev Function to stop minting new tokens.
283      * @return True if the operation was successful.
284      */
285     function finishMinting() onlySaleAgent canMint public returns (bool) {
286         mintingFinished = true;
287         MintFinished();
288         return true;
289     }
290 }
291 
292 contract Token is MintableToken {
293     string public constant name = "TOKPIE";
294     string public constant symbol = "TKP";
295     uint8 public constant decimals = 18;
296 }
297 
298 /**
299  * @title Pausable
300  * @dev Base contract which allows children to implement an emergency stop mechanism.
301  */
302 contract Pausable is Ownable {
303     event Pause();
304     event Unpause();
305 
306     bool public paused = false;
307 
308 
309     /**
310      * @dev Modifier to make a function callable only when the contract is not paused.
311      */
312     modifier whenNotPaused() {
313         require(!paused);
314         _;
315     }
316 
317     /**
318      * @dev Modifier to make a function callable only when the contract is paused.
319      */
320     modifier whenPaused() {
321         require(paused);
322         _;
323     }
324 
325     /**
326      * @dev called by the owner to pause, triggers stopped state
327      */
328     function pause() onlyOwner whenNotPaused public {
329         paused = true;
330         Pause();
331     }
332 
333     /**
334      * @dev called by the owner to unpause, returns to normal state
335      */
336     function unpause() onlyOwner whenPaused public {
337         paused = false;
338         Unpause();
339     }
340 }
341 
342 /**
343  * @title WhitelistedCrowdsale
344  * @dev Crowdsale in which only whitelisted users can contribute.
345  */
346 contract WhitelistedCrowdsale is Ownable {
347 
348     mapping(address => bool) public whitelist;
349 
350     /**
351      * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
352      */
353     modifier isWhitelisted(address _beneficiary) {
354         require(whitelist[_beneficiary]);
355         _;
356     }
357 
358     /**
359      * @dev Adds single address to whitelist.
360      * @param _beneficiary Address to be added to the whitelist
361      */
362     function addToWhitelist(address _beneficiary) external onlyOwner {
363         whitelist[_beneficiary] = true;
364     }
365 
366     /**
367      * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
368      * @param _beneficiaries Addresses to be added to the whitelist
369      */
370     function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
371         for (uint256 i = 0; i < _beneficiaries.length; i++) {
372             whitelist[_beneficiaries[i]] = true;
373         }
374     }
375 }
376 
377 /**
378  * @title FinalizableCrowdsale
379  * @dev Extension of Crowdsale where an owner can do extra work
380  * after finishing.
381  */
382 contract FinalizableCrowdsale is Pausable {
383     using SafeMath for uint256;
384 
385     bool public isFinalized = false;
386 
387     event Finalized();
388 
389     /**
390      * @dev Must be called after crowdsale ends, to do some extra finalization
391      * work. Calls the contract's finalization function.
392      */
393     function finalize() onlyOwner public {
394         require(!isFinalized);
395 
396         finalization();
397         Finalized();
398 
399         isFinalized = true;
400     }
401 
402     /**
403      * @dev Can be overridden to add finalization logic. The overriding function
404      * should call super.finalization() to ensure the chain of finalization is
405      * executed entirely.
406      */
407     function finalization() internal;
408 }
409 
410 /**
411  * @title RefundVault
412  * @dev This contract is used for storing funds while a crowdsale
413  * is in progress. Supports refunding the money if crowdsale fails,
414  * and forwarding it if crowdsale is successful.
415  */
416 contract RefundVault is Ownable {
417     using SafeMath for uint256;
418 
419     enum State {Active, Refunding, Closed}
420 
421     mapping(address => uint256) public deposited;
422     address public wallet;
423     State public state;
424 
425     event Closed();
426     event RefundsEnabled();
427     event Refunded(address indexed beneficiary, uint256 weiAmount);
428 
429     /**
430      * @param _wallet Vault address
431      */
432     function RefundVault(address _wallet) public {
433         require(_wallet != address(0));
434         wallet = _wallet;
435         state = State.Active;
436     }
437 
438     /**
439      * @param investor Investor address
440      */
441     function deposit(address investor) onlyOwner public payable {
442         require(state == State.Active);
443         deposited[investor] = deposited[investor].add(msg.value);
444     }
445 
446     function close() onlyOwner public {
447         require(state == State.Active);
448         state = State.Closed;
449         Closed();
450         wallet.transfer(this.balance);
451     }
452 
453     function enableRefunds() onlyOwner public {
454         require(state == State.Active);
455         state = State.Refunding;
456         RefundsEnabled();
457     }
458 
459     /**
460      * @param investor Investor address
461      */
462     function refund(address investor) public {
463         require(state == State.Refunding);
464         uint256 depositedValue = deposited[investor];
465         deposited[investor] = 0;
466         investor.transfer(depositedValue);
467         Refunded(investor, depositedValue);
468     }
469 }
470 
471 contract preICO is FinalizableCrowdsale, WhitelistedCrowdsale {
472     Token public token;
473 
474     // May 01, 2018 @ UTC 0:01
475     uint256 public startDate;
476 
477     // May 14, 2018 @ UTC 23:59
478     uint256 public endDate;
479 
480     // amount of raised money in wei
481     uint256 public weiRaised;
482 
483     // how many token units a buyer gets per wei
484     uint256 public constant rate = 1920;
485 
486     uint256 public constant softCap = 500 * (1 ether);
487 
488     uint256 public constant hardCap = 1000 * (1 ether);
489 
490     // refund vault used to hold funds while crowdsale is running
491     RefundVault public vault;
492 
493     /**
494      * event for token purchase logging
495      * @param purchaser who paid for the tokens
496      * @param beneficiary who got the tokens
497      * @param value weis paid for purchase
498      * @param amount amount of tokens purchased
499      */
500     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
501 
502     /**
503      * @dev _wallet where collect funds during crowdsale
504      * @dev _startDate should be 1525132860
505      * @dev _endDate should be 1526342340
506      * @dev _maxEtherPerInvestor should be 10 ether
507      */
508     function preICO(address _token, address _wallet, uint256 _startDate, uint256 _endDate) public {
509         require(_token != address(0) && _wallet != address(0));
510         require(_endDate > _startDate);
511         startDate = _startDate;
512         endDate = _endDate;
513         token = Token(_token);
514         vault = new RefundVault(_wallet);
515     }
516 
517     /**
518      * @dev Investors can claim refunds here if crowdsale is unsuccessful
519      */
520     function claimRefund() public {
521         require(isFinalized);
522         require(!goalReached());
523 
524         vault.refund(msg.sender);
525     }
526 
527     /**
528      * @dev Checks whether funding goal was reached.
529      * @return Whether funding goal was reached
530      */
531     function goalReached() public view returns (bool) {
532         return weiRaised >= softCap;
533     }
534 
535     /**
536      * @dev vault finalization task, called when owner calls finalize()
537      */
538     function finalization() internal {
539         require(hasEnded());
540         if (goalReached()) {
541             vault.close();
542         } else {
543             vault.enableRefunds();
544         }
545     }
546 
547     // fallback function can be used to buy tokens
548     function() external payable {
549         buyTokens(msg.sender);
550     }
551 
552     // low level token purchase function
553     function buyTokens(address beneficiary) whenNotPaused isWhitelisted(beneficiary) isWhitelisted(msg.sender) public payable {
554         require(beneficiary != address(0));
555         require(validPurchase());
556         require(!hasEnded());
557 
558         uint256 weiAmount = msg.value;
559 
560         // calculate token amount to be created
561         uint256 tokens = weiAmount.mul(rate);
562 
563         // Minimum contribution level in TKP tokens for each investor = 100 TKP
564         require(tokens >= 100 * (10 ** 18));
565 
566         // update state
567         weiRaised = weiRaised.add(weiAmount);
568 
569         token.mint(beneficiary, tokens);
570         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
571         forwardFunds();
572     }
573 
574     // send ether to the fund collection wallet
575     function forwardFunds() internal {
576         vault.deposit.value(msg.value)(msg.sender);
577     }
578 
579     // @return true if the transaction can buy tokens
580     function validPurchase() internal view returns (bool) {
581         return !isFinalized && now >= startDate && msg.value != 0;
582     }
583 
584     // @return true if crowdsale event has ended
585     function hasEnded() public view returns (bool) {
586         return (now > endDate || weiRaised >= hardCap);
587     }
588 }
589 
590 contract ICO is Pausable, WhitelistedCrowdsale {
591     using SafeMath for uint256;
592 
593     Token public token;
594 
595     // June 01, 2018 @ UTC 0:01
596     uint256 public startDate;
597 
598     // July 05, 2018 on UTC 23:59
599     uint256 public endDate;
600 
601     uint256 public hardCap;
602 
603     // amount of raised money in wei
604     uint256 public weiRaised;
605 
606     address public wallet;
607 
608     mapping(address => uint256) public deposited;
609 
610     /**
611      * event for token purchase logging
612      * @param purchaser who paid for the tokens
613      * @param beneficiary who got the tokens
614      * @param value weis paid for purchase
615      * @param amount amount of tokens purchased
616      */
617     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
618 
619     /**
620      * @dev _wallet where collect funds during crowdsale
621      * @dev _startDate should be 1527811260
622      * @dev _endDate should be 1530835140
623      * @dev _maxEtherPerInvestor should be 10 ether
624      * @dev _hardCap should be 8700 ether
625      */
626     function ICO(address _token, address _wallet, uint256 _startDate, uint256 _endDate, uint256 _hardCap) public {
627         require(_token != address(0) && _wallet != address(0));
628         require(_endDate > _startDate);
629         require(_hardCap > 0);
630         startDate = _startDate;
631         endDate = _endDate;
632         hardCap = _hardCap;
633         token = Token(_token);
634         wallet = _wallet;
635     }
636 
637     function claimFunds() onlyOwner public {
638         require(hasEnded());
639         wallet.transfer(this.balance);
640     }
641 
642     function getRate() public view returns (uint256) {
643         if (now < startDate || hasEnded()) return 0;
644 
645         // Period: from June 01, 2018 @ UTC 0:01 to June 7, 2018 @ UTC 23:59; Price: 1 ETH = 1840 TKP
646         if (now >= startDate && now < startDate + 604680) return 1840;
647         // Period: from June 08, 2018 @ UTC 0:00 to June 14, 2018 @ UTC 23:59; Price: 1 ETH = 1760 TKP
648         if (now >= startDate + 604680 && now < startDate + 1209480) return 1760;
649         // Period: from June 15, 2018 @ UTC 0:00 to June 21, 2018 @ UTC 23:59; Price: 1 ETH = 1680 TKP
650         if (now >= startDate + 1209480 && now < startDate + 1814280) return 1680;
651         // Period: from June 22, 2018 @ UTC 0:00 to June 28, 2018 @ UTC 23:59; Price: 1 ETH = 1648 TKP
652         if (now >= startDate + 1814280 && now < startDate + 2419080) return 1648;
653         // Period: from June 29, 2018 @ UTC 0:00 to July 5, 2018 @ UTC 23:59; Price: 1 ETH = 1600 TKP
654         if (now >= startDate + 2419080) return 1600;
655     }
656 
657     // fallback function can be used to buy tokens
658     function() external payable {
659         buyTokens(msg.sender);
660     }
661 
662     // low level token purchase function
663     function buyTokens(address beneficiary) whenNotPaused isWhitelisted(beneficiary) isWhitelisted(msg.sender) public payable {
664         require(beneficiary != address(0));
665         require(validPurchase());
666         require(!hasEnded());
667 
668         uint256 weiAmount = msg.value;
669 
670         // calculate token amount to be created
671         uint256 tokens = weiAmount.mul(getRate());
672 
673         // Minimum contribution level in TKP tokens for each investor = 100 TKP
674         require(tokens >= 100 * (10 ** 18));
675 
676         // update state
677         weiRaised = weiRaised.add(weiAmount);
678 
679         token.mint(beneficiary, tokens);
680         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
681     }
682 
683     // @return true if the transaction can buy tokens
684     function validPurchase() internal view returns (bool) {
685         return now >= startDate && msg.value != 0;
686     }
687 
688     // @return true if crowdsale event has ended
689     function hasEnded() public view returns (bool) {
690         return (now > endDate || weiRaised >= hardCap);
691     }
692 }
693 
694 contract postICO is Ownable {
695     using SafeMath for uint256;
696 
697     Token public token;
698 
699     address public walletE;
700     address public walletB;
701     address public walletC;
702     address public walletF;
703     address public walletG;
704 
705     // 05.07.18 @ UTC 23:59
706     uint256 public endICODate;
707 
708     bool public finished = false;
709 
710     uint256 public FTST;
711 
712     // Save complete of transfers (due to schedule) to these wallets 
713     mapping(uint8 => bool) completedE;
714     mapping(uint8 => bool) completedBC;
715 
716     uint256 public paymentSizeE;
717     uint256 public paymentSizeB;
718     uint256 public paymentSizeC;
719 
720     /**
721      * @dev _endICODate should be 1530835140
722      */
723     function postICO(
724         address _token,
725         address _walletE,
726         address _walletB,
727         address _walletC,
728         address _walletF,
729         address _walletG,
730         uint256 _endICODate
731     ) public {
732         require(_token != address(0));
733         require(_walletE != address(0));
734         require(_walletB != address(0));
735         require(_walletC != address(0));
736         require(_walletF != address(0));
737         require(_walletG != address(0));
738         require(_endICODate >= now);
739 
740         token = Token(_token);
741         endICODate = _endICODate;
742 
743         walletE = _walletE;
744         walletB = _walletB;
745         walletC = _walletC;
746         walletF = _walletF;
747         walletG = _walletG;
748     }
749 
750     function finish() onlyOwner public {
751         require(now > endICODate);
752         require(!finished);
753         require(token.saleAgent() == address(this));
754 
755         FTST = token.totalSupply().mul(100).div(65);
756 
757         // post ICO token allocation: 35% of final total supply of tokens (FTST) will be distributed to the wallets E, B, C, F, G due to the schedule described below. Where FTST = the number of tokens sold during crowdsale x 100 / 65.
758         // Growth reserve: 21% (4-years lock). Distribute 2.625% of the final total supply of tokens (FTST*2625/100000) 8 (eight) times every half a year during 4 (four) years after the endICODate to the wallet [E].
759         // hold this tokens on postICO contract
760         paymentSizeE = FTST.mul(2625).div(100000);
761         uint256 tokensE = paymentSizeE.mul(8);
762         token.mint(this, tokensE);
763 
764         // Team: 9.6% (2-years lock).
765         // Distribute 0.25% of final total supply of tokens (FTST*25/10000) 4 (four) times every half a year during 2 (two) years after endICODate to the wallet [B].
766         // hold this tokens on postICO contract
767         paymentSizeB = FTST.mul(25).div(10000);
768         uint256 tokensB = paymentSizeB.mul(4);
769         token.mint(this, tokensB);
770 
771         // Distribute 2.15% of final total supply of tokens (FTST*215/10000) 4 (four) times every half a year during 2 (two) years after endICODate to the wallet [C]. 
772         // hold this tokens on postICO contract
773         paymentSizeC = FTST.mul(215).div(10000);
774         uint256 tokensC = paymentSizeC.mul(4);
775         token.mint(this, tokensC);
776 
777         // Angel investors: 2%. Distribute 2% of final total supply of tokens (FTST*2/100) after endICODate to the wallet [F].
778         uint256 tokensF = FTST.mul(2).div(100);
779         token.mint(walletF, tokensF);
780 
781         // Referral program 1,3% + Bounty program: 1,1%. Distribute 2,4% of final total supply of tokens (FTST*24/1000) after endICODate to the wallet [G]. 
782         uint256 tokensG = FTST.mul(24).div(1000);
783         token.mint(walletG, tokensG);
784 
785         token.finishMinting();
786         finished = true;
787     }
788 
789     function claimTokensE(uint8 order) onlyOwner public {
790         require(finished);
791         require(order >= 1 && order <= 8);
792         require(!completedE[order]);
793 
794         // On January 03, 2019 @ UTC 23:59 = FTST*2625/100000 (2.625% of final total supply of tokens) to the wallet [E].
795         if (order == 1) {
796             // Thursday, 3 January 2019 г., 23:59:00
797             require(now >= endICODate + 15724800);
798             token.transfer(walletE, paymentSizeE);
799             completedE[order] = true;
800         }
801         // On July 05, 2019 @ UTC 23:59 = FTST*2625/100000 (2.625% of final total supply of tokens) to the wallet [E].
802         if (order == 2) {
803             // Friday, 5 July 2019 г., 23:59:00
804             require(now >= endICODate + 31536000);
805             token.transfer(walletE, paymentSizeE);
806             completedE[order] = true;
807         }
808         // On January 03, 2020 @ UTC 23:59 = FTST*2625/100000 (2.625% of final total supply of tokens) to the wallet [E].
809         if (order == 3) {
810             // Friday, 3 January 2020 г., 23:59:00
811             require(now >= endICODate + 47260800);
812             token.transfer(walletE, paymentSizeE);
813             completedE[order] = true;
814         }
815         // On July 04, 2020 @ UTC 23:59 = FTST*2625/100000 (2.625% of final total supply of tokens) to the wallet [E].
816         if (order == 4) {
817             // Saturday, 4 July 2020 г., 23:59:00
818             require(now >= endICODate + 63072000);
819             token.transfer(walletE, paymentSizeE);
820             completedE[order] = true;
821         }
822         // On January 02, 2021 @ UTC 23:59 = FTST*2625/100000 (2.625% of final total supply of tokens) to the wallet [E].
823         if (order == 5) {
824             // Saturday, 2 January 2021 г., 23:59:00
825             require(now >= endICODate + 78796800);
826             token.transfer(walletE, paymentSizeE);
827             completedE[order] = true;
828         }
829         // On July 04, 2021 @ UTC 23:59 = FTST*2625/100000 (2.625% of final total supply of tokens) to the wallet [E].
830         if (order == 6) {
831             // Sunday, 4 July 2021 г., 23:59:00
832             require(now >= endICODate + 94608000);
833             token.transfer(walletE, paymentSizeE);
834             completedE[order] = true;
835         }
836         // On January 02, 2022 @ UTC 23:59 = FTST*2625/100000 (2.625% of final total supply of tokens) to the wallet [E].
837         if (order == 7) {
838             // Sunday, 2 January 2022 г., 23:59:00
839             require(now >= endICODate + 110332800);
840             token.transfer(walletE, paymentSizeE);
841             completedE[order] = true;
842         }
843         // On July 04, 2022@ UTC 23:59 = FTST*2625/100000 (2.625% of final total supply of tokens) to the wallet [E].
844         if (order == 8) {
845             // Monday, 4 July 2022 г., 23:59:00
846             require(now >= endICODate + 126144000);
847             token.transfer(walletE, paymentSizeE);
848             completedE[order] = true;
849         }
850     }
851 
852     function claimTokensBC(uint8 order) onlyOwner public {
853         require(finished);
854         require(order >= 1 && order <= 4);
855         require(!completedBC[order]);
856 
857         // On January 03, 2019 @ UTC 23:59 = FTST*25/10000 (0.25% of final total supply of tokens) to the wallet [B] and FTST*215/10000 (2.15% of final total supply of tokens) to the wallet [C].
858         if (order == 1) {
859             // Thursday, 3 January 2019 г., 23:59:00
860             require(now >= endICODate + 15724800);
861             token.transfer(walletB, paymentSizeB);
862             token.transfer(walletC, paymentSizeC);
863             completedBC[order] = true;
864         }
865         // On July 05, 2019 @ UTC 23:59 = FTST*25/10000 (0.25% of final total supply of tokens) to the wallet [B] and FTST*215/10000 (2.15% of final total supply of tokens) to the wallet [C].
866         if (order == 2) {
867             // Friday, 5 July 2019 г., 23:59:00
868             require(now >= endICODate + 31536000);
869             token.transfer(walletB, paymentSizeB);
870             token.transfer(walletC, paymentSizeC);
871             completedBC[order] = true;
872         }
873         // On January 03, 2020 @ UTC 23:59 = FTST*25/10000 (0.25% of final total supply of tokens) to the wallet [B] and FTST*215/10000 (2.15% of final total supply of tokens) to the wallet [C].
874         if (order == 3) {
875             // Friday, 3 January 2020 г., 23:59:00
876             require(now >= endICODate + 47260800);
877             token.transfer(walletB, paymentSizeB);
878             token.transfer(walletC, paymentSizeC);
879             completedBC[order] = true;
880         }
881         // On July 04, 2020 @ UTC 23:59 = FTST*25/10000 (0.25% of final total supply of tokens) to the wallet [B] and FTST*215/10000 (2.15% of final total supply of tokens) to the wallet [C].
882         if (order == 4) {
883             // Saturday, 4 July 2020 г., 23:59:00
884             require(now >= endICODate + 63072000);
885             token.transfer(walletB, paymentSizeB);
886             token.transfer(walletC, paymentSizeC);
887             completedBC[order] = true;
888         }
889     }
890 }
891 
892 contract Controller is Ownable {
893     Token public token;
894     preICO public pre;
895     ICO public ico;
896     postICO public post;
897 
898     enum State {NONE, PRE_ICO, ICO, POST}
899 
900     State public state;
901 
902     function Controller(address _token, address _preICO, address _ico, address _postICO) public {
903         require(_token != address(0x0));
904         token = Token(_token);
905         pre = preICO(_preICO);
906         ico = ICO(_ico);
907         post = postICO(_postICO);
908 
909         require(post.endICODate() == ico.endDate());
910 
911         require(pre.weiRaised() == 0);
912         require(ico.weiRaised() == 0);
913 
914         require(token.totalSupply() == 0);
915         state = State.NONE;
916     }
917 
918     function startPreICO() onlyOwner public {
919         require(state == State.NONE);
920         require(token.owner() == address(this));
921         token.setSaleAgent(pre);
922         state = State.PRE_ICO;
923     }
924 
925     function startICO() onlyOwner public {
926         require(now > pre.endDate());
927         require(state == State.PRE_ICO);
928         require(token.owner() == address(this));
929         token.setSaleAgent(ico);
930         state = State.ICO;
931     }
932 
933     function startPostICO() onlyOwner public {
934         require(now > ico.endDate());
935         require(state == State.ICO);
936         require(token.owner() == address(this));
937         token.setSaleAgent(post);
938         state = State.POST;
939     }
940 }