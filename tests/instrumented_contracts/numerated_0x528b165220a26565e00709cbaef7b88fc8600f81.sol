1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who) constant returns (uint256);
11     function transfer(address to, uint256 value) returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender) constant returns (uint256);
21     function transferFrom(address from, address to, uint256 value) returns (bool);
22     function approve(address spender, uint256 value) returns (bool);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33         uint256 c = a * b;
34         assert(a == 0 || c / a == b);
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal constant returns (uint256) {
39         // assert(b > 0); // Solidity automatically throws when dividing by 0
40         uint256 c = a / b;
41         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46         assert(b <= a);
47         return a - b;
48     }
49 
50     function add(uint256 a, uint256 b) internal constant returns (uint256) {
51         uint256 c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63 
64     using SafeMath for uint256;
65 
66     mapping(address => uint256) balances;
67 
68     /**
69     * @dev transfer token for a specified address
70     * @param _to The address to transfer to.
71     * @param _value The amount to be transferred.
72     */
73     function transfer(address _to, uint256 _value) returns (bool) {
74         balances[msg.sender] = balances[msg.sender].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76         Transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80     /**
81     * @dev Gets the balance of the specified address.
82     * @param _owner The address to query the the balance of.
83     * @return An uint256 representing the amount owned by the passed address.
84     */
85     function balanceOf(address _owner) constant returns (uint256 balance) {
86         return balances[_owner];
87     }
88 
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100     mapping (address => mapping (address => uint256)) allowed;
101 
102     /**
103      * @dev Transfer tokens from one address to another
104      * @param _from address The address which you want to send tokens from
105      * @param _to address The address which you want to transfer to
106      * @param _value uint256 the amout of tokens to be transfered
107      */
108     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
109         var _allowance = allowed[_from][msg.sender];
110 
111         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112         // require (_value <= _allowance);
113 
114         balances[_to] = balances[_to].add(_value);
115         balances[_from] = balances[_from].sub(_value);
116         allowed[_from][msg.sender] = _allowance.sub(_value);
117         Transfer(_from, _to, _value);
118         return true;
119     }
120 
121     /**
122      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123      * @param _spender The address which will spend the funds.
124      * @param _value The amount of tokens to be spent.
125      */
126     function approve(address _spender, uint256 _value) returns (bool) {
127 
128         // To change the approve amount you first have to reduce the addresses`
129         //  allowance to zero by calling `approve(_spender, 0)` if it is not
130         //  already 0 to mitigate the race condition described here:
131         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134         allowed[msg.sender][_spender] = _value;
135         Approval(msg.sender, _spender, _value);
136         return true;
137     }
138 
139     /**
140      * @dev Function to check the amount of tokens that an owner allowed to a spender.
141      * @param _owner address The address which owns the funds.
142      * @param _spender address The address which will spend the funds.
143      * @return A uint256 specifing the amount of tokens still available for the spender.
144      */
145     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146         return allowed[_owner][_spender];
147     }
148 
149 }
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157 
158     address public owner;
159 
160     /**
161      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162      * account.
163      */
164     function Ownable() {
165         owner = msg.sender;
166     }
167 
168     /**
169      * @dev Throws if called by any account other than the owner.
170      */
171     modifier onlyOwner() {
172         require(msg.sender == owner);
173         _;
174     }
175 
176     /**
177      * @dev Allows the current owner to transfer control of the contract to a newOwner.
178      * @param newOwner The address to transfer ownership to.
179      */
180     function transferOwnership(address newOwner) onlyOwner {
181         require(newOwner != address(0));
182         owner = newOwner;
183     }
184 
185 }
186 
187 /**
188  * @title Mintable token
189  * @dev Simple ERC20 Token example, with mintable token creation
190  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
191  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
192  */
193 
194 contract MintableToken is StandardToken, Ownable {
195 
196     event Mint(address indexed to, uint256 amount);
197 
198     event MintFinished();
199 
200     bool public mintingFinished = false;
201 
202     address public saleAgent;
203 
204     function setSaleAgent(address newSaleAgnet) {
205         require(msg.sender == saleAgent || msg.sender == owner);
206         saleAgent = newSaleAgnet;
207     }
208 
209     function mint(address _to, uint256 _amount) returns (bool) {
210         require(msg.sender == saleAgent && !mintingFinished);
211         totalSupply = totalSupply.add(_amount);
212         balances[_to] = balances[_to].add(_amount);
213         Mint(_to, _amount);
214         return true;
215     }
216 
217     /**
218      * @dev Function to stop minting new tokens.
219      * @return True if the operation was successful.
220      */
221     function finishMinting() returns (bool) {
222         require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
223         mintingFinished = true;
224         MintFinished();
225         return true;
226     }
227 
228 
229 }
230 
231 /**
232  * @title Pausable
233  * @dev Base contract which allows children to implement an emergency stop mechanism.
234  */
235 contract Pausable is Ownable {
236 
237     event Pause();
238 
239     event Unpause();
240 
241     bool public paused = false;
242 
243     /**
244      * @dev modifier to allow actions only when the contract IS paused
245      */
246     modifier whenNotPaused() {
247         require(!paused);
248         _;
249     }
250 
251     /**
252      * @dev modifier to allow actions only when the contract IS NOT paused
253      */
254     modifier whenPaused() {
255         require(paused);
256         _;
257     }
258 
259     /**
260      * @dev called by the owner to pause, triggers stopped state
261      */
262     function pause() onlyOwner whenNotPaused {
263         paused = true;
264         Pause();
265     }
266 
267     /**
268      * @dev called by the owner to unpause, returns to normal state
269      */
270     function unpause() onlyOwner whenPaused {
271         paused = false;
272         Unpause();
273     }
274 
275 }
276 
277 contract CovestingToken is MintableToken {
278 
279     string public constant name = "Covesting";
280 
281     string public constant symbol = "COV";
282 
283     uint32 public constant decimals = 18;
284 
285     mapping (address => uint) public locked;
286 
287     function transfer(address _to, uint256 _value) returns (bool) {
288         require(locked[msg.sender] < now);
289         return super.transfer(_to, _value);
290     }
291 
292     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
293         require(locked[_from] < now);
294         return super.transferFrom(_from, _to, _value);
295     }
296 
297     function lock(address addr, uint periodInDays) {
298         require(locked[addr] < now && (msg.sender == saleAgent || msg.sender == addr));
299         locked[addr] = now + periodInDays * 1 days;
300     }
301 
302     function () payable {
303         revert();
304     }
305 
306 }
307 
308 contract StagedCrowdsale is Pausable {
309 
310     using SafeMath for uint;
311 
312     struct Stage {
313     uint hardcap;
314     uint price;
315     uint invested;
316     uint closed;
317     }
318 
319     uint public start;
320 
321     uint public period;
322 
323     uint public totalHardcap;
324 
325     uint public totalInvested;
326 
327     Stage[] public stages;
328 
329     function stagesCount() public constant returns(uint) {
330         return stages.length;
331     }
332 
333     function setStart(uint newStart) public onlyOwner {
334         start = newStart;
335     }
336 
337     function setPeriod(uint newPeriod) public onlyOwner {
338         period = newPeriod;
339     }
340 
341     function addStage(uint hardcap, uint price) public onlyOwner {
342         require(hardcap > 0 && price > 0);
343         Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
344         stages.push(stage);
345         totalHardcap = totalHardcap.add(stage.hardcap);
346     }
347 
348     function removeStage(uint8 number) public onlyOwner {
349         require(number >=0 && number < stages.length);
350         Stage storage stage = stages[number];
351         totalHardcap = totalHardcap.sub(stage.hardcap);
352         delete stages[number];
353         for (uint i = number; i < stages.length - 1; i++) {
354             stages[i] = stages[i+1];
355         }
356         stages.length--;
357     }
358 
359     function changeStage(uint8 number, uint hardcap, uint price) public onlyOwner {
360         require(number >= 0 &&number < stages.length);
361         Stage storage stage = stages[number];
362         totalHardcap = totalHardcap.sub(stage.hardcap);
363         stage.hardcap = hardcap.mul(1 ether);
364         stage.price = price;
365         totalHardcap = totalHardcap.add(stage.hardcap);
366     }
367 
368     function insertStage(uint8 numberAfter, uint hardcap, uint price) public onlyOwner {
369         require(numberAfter < stages.length);
370         Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
371         totalHardcap = totalHardcap.add(stage.hardcap);
372         stages.length++;
373         for (uint i = stages.length - 2; i > numberAfter; i--) {
374             stages[i + 1] = stages[i];
375         }
376         stages[numberAfter + 1] = stage;
377     }
378 
379     function clearStages() public onlyOwner {
380         for (uint i = 0; i < stages.length; i++) {
381             delete stages[i];
382         }
383         stages.length -= stages.length;
384         totalHardcap = 0;
385     }
386 
387     function lastSaleDate() public constant returns(uint) {
388         return start + period * 1 days;
389     }
390 
391     modifier saleIsOn() {
392         require(stages.length > 0 && now >= start && now < lastSaleDate());
393         _;
394     }
395 
396     modifier isUnderHardcap() {
397         require(totalInvested <= totalHardcap);
398         _;
399     }
400 
401     function currentStage() public saleIsOn isUnderHardcap constant returns(uint) {
402         for(uint i=0; i < stages.length; i++) {
403             if(stages[i].closed == 0) {
404                 return i;
405             }
406         }
407         revert();
408     }
409 
410 }
411 
412 contract CommonSale is StagedCrowdsale {
413 
414     address public multisigWallet;
415 
416     uint public minPrice;
417 
418     uint public totalTokensMinted;
419 
420     CovestingToken public token;
421 
422     function setMinPrice(uint newMinPrice) public onlyOwner {
423         minPrice = newMinPrice;
424     }
425 
426     function setMultisigWallet(address newMultisigWallet) public onlyOwner {
427         multisigWallet = newMultisigWallet;
428     }
429 
430     function setToken(address newToken) public onlyOwner {
431         token = CovestingToken(newToken);
432     }
433 
434     function createTokens() public whenNotPaused payable {
435         require(msg.value >= minPrice);
436         uint stageIndex = currentStage();
437         multisigWallet.transfer(msg.value);
438         Stage storage stage = stages[stageIndex];
439         uint tokens = msg.value.mul(stage.price);
440         token.mint(this, tokens);
441         token.transfer(msg.sender, tokens);
442         totalTokensMinted = totalTokensMinted.add(tokens);
443         totalInvested = totalInvested.add(msg.value);
444         stage.invested = stage.invested.add(msg.value);
445         if(stage.invested >= stage.hardcap) {
446             stage.closed = now;
447         }
448     }
449 
450     function() external payable {
451         createTokens();
452     }
453 
454     function retrieveTokens(address anotherToken) public onlyOwner {
455         ERC20 alienToken = ERC20(anotherToken);
456         alienToken.transfer(multisigWallet, token.balanceOf(this));
457     }
458 
459 }
460 
461 contract Presale is CommonSale {
462 
463     Mainsale public mainsale;
464 
465     function setMainsale(address newMainsale) public onlyOwner {
466         mainsale = Mainsale(newMainsale);
467     }
468 
469     function setMultisigWallet(address newMultisigWallet) public onlyOwner {
470         multisigWallet = newMultisigWallet;
471     }
472 
473     function finishMinting() public whenNotPaused onlyOwner {
474         token.setSaleAgent(mainsale);
475     }
476 
477     function() external payable {
478         createTokens();
479     }
480 
481     function retrieveTokens(address anotherToken) public onlyOwner {
482         ERC20 alienToken = ERC20(anotherToken);
483         alienToken.transfer(multisigWallet, token.balanceOf(this));
484     }
485 
486 }
487 
488 
489 contract Mainsale is CommonSale {
490 
491     enum Currency { BTC, LTC, ZEC, DASH, WAVES, USD, EUR }
492 
493     event ExternalSale(
494         Currency _currency,
495         bytes32 _txIdSha3,
496         address indexed _buyer,
497         uint256 _amountWei,
498         uint256 _tokensE18
499     );
500 
501     event NotifierChanged(
502         address indexed _oldAddress,
503         address indexed _newAddress
504     );
505 
506     // Address that can this crowdsale about changed external conditions.
507     address public notifier;
508 
509     // currency_code => (sha3_of_tx_id => tokens_e18)
510     mapping(uint8 => mapping(bytes32 => uint256)) public externalTxs;
511 
512     // Total amount of external contributions (BTC, LTC, USD, etc.) during this crowdsale.
513     uint256 public totalExternalSales = 0;
514 
515     modifier canNotify() {
516         require(msg.sender == owner || msg.sender == notifier);
517         _;
518     }
519 
520     // ----------------
521 
522     address public foundersTokensWallet;
523 
524     address public bountyTokensWallet;
525 
526     uint public foundersTokensPercent;
527 
528     uint public bountyTokensPercent;
529 
530     uint public percentRate = 100;
531 
532     uint public lockPeriod;
533 
534     function setLockPeriod(uint newLockPeriod) public onlyOwner {
535         lockPeriod = newLockPeriod;
536     }
537 
538     function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner {
539         foundersTokensPercent = newFoundersTokensPercent;
540     }
541 
542     function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
543         bountyTokensPercent = newBountyTokensPercent;
544     }
545 
546     function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
547         foundersTokensWallet = newFoundersTokensWallet;
548     }
549 
550     function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
551         bountyTokensWallet = newBountyTokensWallet;
552     }
553 
554     function finishMinting() public whenNotPaused onlyOwner {
555         uint summaryTokensPercent = bountyTokensPercent + foundersTokensPercent;
556         uint mintedTokens = token.totalSupply();
557         uint summaryFoundersTokens = mintedTokens.mul(summaryTokensPercent).div(percentRate - summaryTokensPercent);
558         uint totalSupply = summaryFoundersTokens + mintedTokens;
559         uint foundersTokens = totalSupply.mul(foundersTokensPercent).div(percentRate);
560         uint bountyTokens = totalSupply.mul(bountyTokensPercent).div(percentRate);
561         token.mint(this, foundersTokens);
562         token.lock(foundersTokensWallet, lockPeriod * 1 days);
563         token.transfer(foundersTokensWallet, foundersTokens);
564         token.mint(this, bountyTokens);
565         token.transfer(bountyTokensWallet, bountyTokens);
566         totalTokensMinted = totalTokensMinted.add(foundersTokens).add(bountyTokens);
567         token.finishMinting();
568     }
569 
570     //----------------------------------------------------------------------
571     // Begin of external sales.
572 
573     function setNotifier(address _notifier) public onlyOwner {
574         NotifierChanged(notifier, _notifier);
575         notifier = _notifier;
576     }
577 
578     function externalSales(
579         uint8[] _currencies,
580         bytes32[] _txIdSha3,
581         address[] _buyers,
582         uint256[] _amountsWei,
583         uint256[] _tokensE18
584     ) public whenNotPaused canNotify {
585 
586         require(_currencies.length > 0);
587         require(_currencies.length == _txIdSha3.length);
588         require(_currencies.length == _buyers.length);
589         require(_currencies.length == _amountsWei.length);
590         require(_currencies.length == _tokensE18.length);
591 
592         for (uint i = 0; i < _txIdSha3.length; i++) {
593             _externalSaleSha3(
594                 Currency(_currencies[i]),
595                 _txIdSha3[i],
596                 _buyers[i],
597                 _amountsWei[i],
598                 _tokensE18[i]
599             );
600         }
601     }
602 
603     function _externalSaleSha3(
604         Currency _currency,
605         bytes32 _txIdSha3, // To get bytes32 use keccak256(txId) OR sha3(txId)
606         address _buyer,
607         uint256 _amountWei,
608         uint256 _tokensE18
609     ) internal {
610 
611         require(_buyer > 0 && _amountWei > 0 && _tokensE18 > 0);
612 
613         var txsByCur = externalTxs[uint8(_currency)];
614 
615         // If this foreign transaction has been already processed in this contract.
616         require(txsByCur[_txIdSha3] == 0);
617         txsByCur[_txIdSha3] = _tokensE18;
618 
619         uint stageIndex = currentStage();
620         Stage storage stage = stages[stageIndex];
621 
622         token.mint(this, _tokensE18);
623         token.transfer(_buyer, _tokensE18);
624         totalTokensMinted = totalTokensMinted.add(_tokensE18);
625         totalExternalSales++;
626 
627         totalInvested = totalInvested.add(_amountWei);
628         stage.invested = stage.invested.add(_amountWei);
629         if (stage.invested >= stage.hardcap) {
630             stage.closed = now;
631         }
632 
633         ExternalSale(_currency, _txIdSha3, _buyer, _amountWei, _tokensE18);
634     }
635 
636     // Get id of currency enum. --------------------------------------------
637 
638     function btcId() public constant returns (uint8) {
639         return uint8(Currency.BTC);
640     }
641 
642     function ltcId() public constant returns (uint8) {
643         return uint8(Currency.LTC);
644     }
645 
646     function zecId() public constant returns (uint8) {
647         return uint8(Currency.ZEC);
648     }
649 
650     function dashId() public constant returns (uint8) {
651         return uint8(Currency.DASH);
652     }
653 
654     function wavesId() public constant returns (uint8) {
655         return uint8(Currency.WAVES);
656     }
657 
658     function usdId() public constant returns (uint8) {
659         return uint8(Currency.USD);
660     }
661 
662     function eurId() public constant returns (uint8) {
663         return uint8(Currency.EUR);
664     }
665 
666     // Get token count by transaction id. ----------------------------------
667 
668     function _tokensByTx(Currency _currency, string _txId) internal constant returns (uint256) {
669         return tokensByTx(uint8(_currency), _txId);
670     }
671 
672     function tokensByTx(uint8 _currency, string _txId) public constant returns (uint256) {
673         return externalTxs[_currency][keccak256(_txId)];
674     }
675 
676     function tokensByBtcTx(string _txId) public constant returns (uint256) {
677         return _tokensByTx(Currency.BTC, _txId);
678     }
679 
680     function tokensByLtcTx(string _txId) public constant returns (uint256) {
681         return _tokensByTx(Currency.LTC, _txId);
682     }
683 
684     function tokensByZecTx(string _txId) public constant returns (uint256) {
685         return _tokensByTx(Currency.ZEC, _txId);
686     }
687 
688     function tokensByDashTx(string _txId) public constant returns (uint256) {
689         return _tokensByTx(Currency.DASH, _txId);
690     }
691 
692     function tokensByWavesTx(string _txId) public constant returns (uint256) {
693         return _tokensByTx(Currency.WAVES, _txId);
694     }
695 
696     function tokensByUsdTx(string _txId) public constant returns (uint256) {
697         return _tokensByTx(Currency.USD, _txId);
698     }
699 
700     function tokensByEurTx(string _txId) public constant returns (uint256) {
701         return _tokensByTx(Currency.EUR, _txId);
702     }
703 
704     // End of external sales.
705     //----------------------------------------------------------------------
706 }
707 
708 contract Configurator is Ownable {
709 
710     CovestingToken public token;
711 
712     Mainsale public mainsale;
713 
714     function deploy() public onlyOwner {
715         mainsale = new Mainsale();
716         token = CovestingToken(0xE2FB6529EF566a080e6d23dE0bd351311087D567);
717         mainsale.setToken(token);
718         mainsale.addStage(5000,200);
719         mainsale.addStage(5000,180);
720         mainsale.addStage(10000,170);
721         mainsale.addStage(20000,160);
722         mainsale.addStage(20000,150);
723         mainsale.addStage(40000,130);
724         mainsale.setMultisigWallet(0x15A071B83396577cCbd86A979Af7d2aBa9e18970);
725         mainsale.setFoundersTokensWallet(0x25ED4f0D260D5e5218D95390036bc8815Ff38262);
726         mainsale.setBountyTokensWallet(0x717bfD30f039424B049D918F935DEdD069B66810);
727         mainsale.setStart(1511222400);
728         mainsale.setPeriod(30);
729         mainsale.setLockPeriod(90);
730         mainsale.setMinPrice(100000000000000000);
731         mainsale.setFoundersTokensPercent(13);
732         mainsale.setBountyTokensPercent(5);
733         mainsale.setNotifier(owner);
734         mainsale.transferOwnership(owner);
735     }
736 
737 }