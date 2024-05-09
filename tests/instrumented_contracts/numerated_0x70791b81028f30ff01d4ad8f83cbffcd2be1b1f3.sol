1 pragma solidity ^0.4.11;
2 
3  contract SafeMathLib {
4 
5   function safeMul(uint a, uint b) returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeSub(uint a, uint b) returns (uint) {
12     assert(b <= a);
13     return a - b;
14   }
15 
16   function safeAdd(uint a, uint b) returns (uint) {
17     uint c = a + b;
18     assert(c>=a);
19     return c;
20   }
21 
22   function assert(bool assertion) private {
23     if (!assertion) throw;
24   }
25 }
26 
27 contract Ownable {
28   address public owner;
29 
30 
31   function Ownable() {
32     owner = msg.sender;
33   }
34 
35 
36   modifier onlyOwner() {
37     if (msg.sender != owner) {
38       throw;
39     }
40     _;
41   }
42 
43 
44   function transferOwnership(address newOwner) onlyOwner {
45     if (newOwner != address(0)) {
46       owner = newOwner;
47     }
48   }
49 
50 }
51 
52 contract ERC20Basic {
53   uint public totalSupply;
54   function balanceOf(address who) constant returns (uint);
55   function transfer(address _to, uint _value) returns (bool success);
56   event Transfer(address indexed from, address indexed to, uint value);
57 }
58 
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) constant returns (uint);
61   function transferFrom(address _from, address _to, uint _value) returns (bool success);
62   function approve(address _spender, uint _value) returns (bool success);
63   event Approval(address indexed owner, address indexed spender, uint value);
64 }
65 
66 contract FractionalERC20 is ERC20 {
67 
68   uint public decimals;
69 
70 }
71 
72 contract StandardToken is ERC20, SafeMathLib{
73   
74   event Minted(address receiver, uint amount);
75 
76   
77   mapping(address => uint) balances;
78 
79   
80   mapping (address => mapping (address => uint)) allowed;
81 
82   modifier onlyPayloadSize(uint size) {
83      if(msg.data.length != size + 4) {
84        throw;
85      }
86      _;
87   }
88 
89   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
90    
91    
92     balances[msg.sender] = safeSub(balances[msg.sender],_value);
93     balances[_to] = safeAdd(balances[_to],_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
99     uint _allowance = allowed[_from][msg.sender];
100 
101     balances[_to] = safeAdd(balances[_to],_value);
102     balances[_from] = safeSub(balances[_from],_value);
103     allowed[_from][msg.sender] = safeSub(_allowance,_value);
104     Transfer(_from, _to, _value);
105     return true;
106   }
107 
108   function balanceOf(address _owner) constant returns (uint balance) {
109     return balances[_owner];
110   }
111 
112   function approve(address _spender, uint _value) returns (bool success) {
113 
114     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
115 
116     allowed[msg.sender][_spender] = _value;
117     Approval(msg.sender, _spender, _value);
118     return true;
119   }
120 
121   function allowance(address _owner, address _spender) constant returns (uint remaining) {
122     return allowed[_owner][_spender];
123   }
124 
125  function addApproval(address _spender, uint _addedValue)
126   onlyPayloadSize(2 * 32)
127   returns (bool success) {
128       uint oldValue = allowed[msg.sender][_spender];
129       allowed[msg.sender][_spender] = safeAdd(oldValue,_addedValue);
130       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131       return true;
132   }
133 
134   function subApproval(address _spender, uint _subtractedValue)
135   onlyPayloadSize(2 * 32)
136   returns (bool success) {
137 
138       uint oldVal = allowed[msg.sender][_spender];
139 
140       if (_subtractedValue > oldVal) {
141           allowed[msg.sender][_spender] = 0;
142       } else {
143           allowed[msg.sender][_spender] = safeSub(oldVal,_subtractedValue);
144       }
145       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146       return true;
147   }
148 
149 }
150 
151 contract UpgradeAgent {
152 
153   uint public originalSupply;
154 
155   
156   function isUpgradeAgent() public constant returns (bool) {
157     return true;
158   }
159 
160   function upgradeFrom(address _from, uint256 _value) public;
161 
162 }
163 
164  contract UpgradeableToken is StandardToken {
165 
166   
167   address public upgradeMaster;
168 
169   
170   UpgradeAgent public upgradeAgent;
171 
172   
173   uint256 public totalUpgraded;
174 
175   
176   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
177 
178   
179   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
180 
181   
182   event UpgradeAgentSet(address agent);
183 
184   
185   function UpgradeableToken(address _upgradeMaster) {
186     upgradeMaster = _upgradeMaster;
187   }
188 
189   
190   function upgrade(uint256 value) public {
191 
192       UpgradeState state = getUpgradeState();
193       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
194         
195         throw;
196       }
197 
198       
199       if (value == 0) throw;
200 
201       balances[msg.sender] = safeSub(balances[msg.sender],value);
202 
203       
204       totalSupply = safeSub(totalSupply,value);
205       totalUpgraded = safeAdd(totalUpgraded,value);
206 
207       
208       upgradeAgent.upgradeFrom(msg.sender, value);
209       Upgrade(msg.sender, upgradeAgent, value);
210   }
211 
212  
213   function setUpgradeAgent(address agent) external {
214 
215       if(!canUpgrade()) {
216         
217         throw;
218       }
219 
220       if (agent == 0x0) throw;
221       
222       if (msg.sender != upgradeMaster) throw;
223       
224       if (getUpgradeState() == UpgradeState.Upgrading) throw;
225 
226       upgradeAgent = UpgradeAgent(agent);
227 
228       
229       if(!upgradeAgent.isUpgradeAgent()) throw;
230       
231       if (upgradeAgent.originalSupply() != totalSupply) throw;
232 
233       UpgradeAgentSet(upgradeAgent);
234   }
235 
236   function getUpgradeState() public constant returns(UpgradeState) {
237     if(!canUpgrade()) return UpgradeState.NotAllowed;
238     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
239     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
240     else return UpgradeState.Upgrading;
241   }
242 
243   
244   function setUpgradeMaster(address master) public {
245       if (master == 0x0) throw;
246       if (msg.sender != upgradeMaster) throw;
247       upgradeMaster = master;
248   }
249 
250   
251   function canUpgrade() public constant returns(bool) {
252      return true;
253   }
254 
255 }
256 
257 contract ReleasableToken is ERC20, Ownable {
258 
259   
260   address public releaseAgent;
261 
262   
263   bool public released = false;
264 
265   
266   mapping (address => bool) public transferAgents;
267 
268 
269   modifier canTransfer(address _sender) {
270 
271     if(!released) {
272         if(!transferAgents[_sender]) {
273             throw;
274         }
275     }
276 
277     _;
278   }
279 
280 
281   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
282     releaseAgent = addr;
283   }
284 
285 
286   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
287     transferAgents[addr] = state;
288   }
289 
290 
291   function releaseTokenTransfer() public onlyReleaseAgent {
292     released = true;
293   }
294 
295   
296   modifier inReleaseState(bool releaseState) {
297     if(releaseState != released) {
298         throw;
299     }
300     _;
301   }
302 
303   
304   modifier onlyReleaseAgent() {
305     if(msg.sender != releaseAgent) {
306         throw;
307     }
308     _;
309   }
310 
311   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
312     
313    return super.transfer(_to, _value);
314   }
315 
316   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
317     
318     return super.transferFrom(_from, _to, _value);
319   }
320 
321 }
322 
323 contract MintableToken is StandardToken, Ownable {
324 
325   bool public mintingFinished = false;
326 
327   
328   mapping (address => bool) public mintAgents;
329 
330   event MintingAgentChanged(address addr, bool state  );
331 
332 
333   function mint(address receiver, uint amount) onlyMintAgent canMint public {
334     totalSupply = safeAdd(totalSupply,amount);
335     balances[receiver] = safeAdd(balances[receiver],amount);
336 
337 
338     Transfer(0, receiver, amount);
339   }
340 
341 
342   function setMintAgent(address addr, bool state) onlyOwner canMint public {
343     mintAgents[addr] = state;
344     MintingAgentChanged(addr, state);
345   }
346 
347   modifier onlyMintAgent() {
348     
349     if(!mintAgents[msg.sender]) {
350         throw;
351     }
352     _;
353   }
354 
355   
356   modifier canMint() {
357     if(mintingFinished) throw;
358     _;
359   }
360 }
361 
362 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
363 
364   event UpdatedTokenInformation(string newName, string newSymbol);
365 
366   string public name;
367 
368   string public symbol;
369 
370   uint public decimals;
371 
372   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
373     UpgradeableToken(msg.sender) {
374 
375     owner = msg.sender;
376 
377     name = _name;
378     symbol = _symbol;
379 
380     totalSupply = _initialSupply;
381 
382     decimals = _decimals;
383 
384     
385     balances[owner] = totalSupply;
386 
387     if(totalSupply > 0) {
388       Minted(owner, totalSupply);
389     }
390 
391     
392     if(!_mintable) {
393       mintingFinished = true;
394       if(totalSupply == 0) {
395         throw; 
396       }
397     }
398   }
399 
400 
401   function releaseTokenTransfer() public onlyReleaseAgent {
402     mintingFinished = true;
403     super.releaseTokenTransfer();
404   }
405 
406 
407   function canUpgrade() public constant returns(bool) {
408     return released && super.canUpgrade();
409   }
410 
411 
412   function setTokenInformation(string _name, string _symbol) onlyOwner {
413     name = _name;
414     symbol = _symbol;
415 
416     UpdatedTokenInformation(name, symbol);
417   }
418 
419 }
420 
421 contract FinalizeAgent {
422 
423   function isFinalizeAgent() public constant returns(bool) {
424     return true;
425   }
426   function isSane() public constant returns (bool);
427   function finalizeCrowdsale();
428 
429 }
430 
431 
432 
433 
434 
435  contract PricingStrategy {
436   function isPricingStrategy() public constant returns (bool) {
437     return true;
438   }
439   function isSane(address crowdsale) public constant returns (bool) {
440     return true;
441   }
442   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
443 }
444 
445 
446 
447 
448 
449  contract Haltable is Ownable {
450   bool public halted;
451 
452   modifier stopInEmergency {
453     if (halted) throw;
454     _;
455   }
456 
457   modifier onlyInEmergency {
458     if (!halted) throw;
459     _;
460   }
461   function halt() external onlyOwner {
462     halted = true;
463   }
464   function unhalt() external onlyOwner onlyInEmergency {
465     halted = false;
466   }
467 
468 }
469 
470 
471 
472 contract Crowdsale is Haltable, SafeMathLib {
473   FractionalERC20 public token;
474   PricingStrategy public pricingStrategy;
475   FinalizeAgent public finalizeAgent;
476   address public multisigWallet;
477   uint public minimumFundingGoal;
478   uint public startsAt;
479   uint public endsAt;
480   uint public tokensSold = 0;
481   uint public weiRaised = 0;
482   uint public investorCount = 0;
483   uint public loadedRefund = 0;
484   uint public weiRefunded = 0;
485   bool public finalized;
486   bool public requireCustomerId;
487   bool public requiredSignedAddress;
488   address public signerAddress;
489   mapping (address => uint256) public investedAmountOf;
490   mapping (address => uint256) public tokenAmountOf;
491   mapping (address => bool) public earlyParticipantWhitelist;
492   uint public ownerTestValue;
493   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
494   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
495   event Refund(address investor, uint weiAmount);
496   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
497   event Whitelisted(address addr, bool status);
498   event EndsAtChanged(uint endsAt);
499 
500   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
501 
502     owner = msg.sender;
503 
504     token = FractionalERC20(_token);
505 
506     setPricingStrategy(_pricingStrategy);
507 
508     multisigWallet = _multisigWallet;
509     if(multisigWallet == 0) {
510         throw;
511     }
512 
513     if(_start == 0) {
514         throw;
515     }
516 
517     startsAt = _start;
518 
519     if(_end == 0) {
520         throw;
521     }
522 
523     endsAt = _end;
524     if(startsAt >= endsAt) {
525         throw;
526     }
527     minimumFundingGoal = _minimumFundingGoal;
528   }
529   function() payable {
530     throw;
531   }
532   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
533     if(getState() == State.PreFunding) {
534       if(!earlyParticipantWhitelist[receiver]) {
535         throw;
536       }
537     } else if(getState() == State.Funding) {
538     } else {
539       throw;
540     }
541 
542     uint weiAmount = msg.value;
543     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
544 
545     if(tokenAmount == 0) {
546       throw;
547     }
548 
549     if(investedAmountOf[receiver] == 0) {
550        investorCount++;
551     }
552     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
553     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
554     weiRaised = safeAdd(weiRaised,weiAmount);
555     tokensSold = safeAdd(tokensSold,tokenAmount);
556     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
557       throw;
558     }
559 
560     assignTokens(receiver, tokenAmount);
561     if(!multisigWallet.send(weiAmount)) throw;
562     Invested(receiver, weiAmount, tokenAmount, customerId);
563   }
564   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
565 
566     uint tokenAmount = fullTokens * 10**token.decimals();
567     uint weiAmount = weiPrice * fullTokens;
568 
569     weiRaised = safeAdd(weiRaised,weiAmount);
570     tokensSold = safeAdd(tokensSold,tokenAmount);
571 
572     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
573     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
574 
575     assignTokens(receiver, tokenAmount);
576     Invested(receiver, weiAmount, tokenAmount, 0);
577   }
578   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
579      bytes32 hash = sha256(addr);
580      if (ecrecover(hash, v, r, s) != signerAddress) throw;
581      if(customerId == 0) throw;
582      investInternal(addr, customerId);
583   }
584   function investWithCustomerId(address addr, uint128 customerId) public payable {
585     if(requiredSignedAddress) throw;
586     if(customerId == 0) throw;
587     investInternal(addr, customerId);
588   }
589   function invest(address addr) public payable {
590     if(requireCustomerId) throw;
591     if(requiredSignedAddress) throw;
592     investInternal(addr, 0);
593   }
594   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
595     investWithSignedAddress(msg.sender, customerId, v, r, s);
596   }
597   function buyWithCustomerId(uint128 customerId) public payable {
598     investWithCustomerId(msg.sender, customerId);
599   }
600   function buy() public payable {
601     invest(msg.sender);
602   }
603   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
604     if(finalized) {
605       throw;
606     }
607     if(address(finalizeAgent) != 0) {
608       finalizeAgent.finalizeCrowdsale();
609     }
610 
611     finalized = true;
612   }
613   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
614     finalizeAgent = addr;
615     if(!finalizeAgent.isFinalizeAgent()) {
616       throw;
617     }
618   }
619 
620   function setRequireCustomerId(bool value) onlyOwner {
621     requireCustomerId = value;
622     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
623   }
624   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
625     requiredSignedAddress = value;
626     signerAddress = _signerAddress;
627     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
628   }
629   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
630     earlyParticipantWhitelist[addr] = status;
631     Whitelisted(addr, status);
632   }
633   function setEndsAt(uint time) onlyOwner {
634 
635     if(now > time) {
636       throw;
637     }
638 
639     endsAt = time;
640     EndsAtChanged(endsAt);
641   }
642   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
643     pricingStrategy = _pricingStrategy;
644     if(!pricingStrategy.isPricingStrategy()) {
645       throw;
646     }
647   }
648   function loadRefund() public payable inState(State.Failure) {
649     if(msg.value == 0) throw;
650     loadedRefund = safeAdd(loadedRefund,msg.value);
651   }
652   function refund() public inState(State.Refunding) {
653     uint256 weiValue = investedAmountOf[msg.sender];
654     if (weiValue == 0) throw;
655     investedAmountOf[msg.sender] = 0;
656     weiRefunded = safeAdd(weiRefunded,weiValue);
657     Refund(msg.sender, weiValue);
658     if (!msg.sender.send(weiValue)) throw;
659   }
660   function isMinimumGoalReached() public constant returns (bool reached) {
661     return weiRaised >= minimumFundingGoal;
662   }
663   function isFinalizerSane() public constant returns (bool sane) {
664     return finalizeAgent.isSane();
665   }
666   function isPricingSane() public constant returns (bool sane) {
667     return pricingStrategy.isSane(address(this));
668   }
669   function getState() public constant returns (State) {
670     if(finalized) return State.Finalized;
671     else if (address(finalizeAgent) == 0) return State.Preparing;
672     else if (!finalizeAgent.isSane()) return State.Preparing;
673     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
674     else if (block.timestamp < startsAt) return State.PreFunding;
675     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
676     else if (isMinimumGoalReached()) return State.Success;
677     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
678     else return State.Failure;
679   }
680   function setOwnerTestValue(uint val) onlyOwner {
681     ownerTestValue = val;
682   }
683   function isCrowdsale() public constant returns (bool) {
684     return true;
685   }
686   modifier inState(State state) {
687     if(getState() != state) throw;
688     _;
689   }
690   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
691   function isCrowdsaleFull() public constant returns (bool);
692   function assignTokens(address receiver, uint tokenAmount) private;
693 }
694 
695 
696 contract BonusFinalizeAgent is FinalizeAgent,SafeMathLib {
697 
698   CrowdsaleToken public token;
699   Crowdsale public crowdsale;
700   uint public totalMembers;
701   uint public allocatedBonus;
702   mapping (address=>uint) bonusOf;
703   address[] public teamAddresses;
704 
705 
706   function BonusFinalizeAgent(CrowdsaleToken _token, Crowdsale _crowdsale, uint[] _bonusBasePoints, address[] _teamAddresses) {
707     token = _token;
708     crowdsale = _crowdsale;
709     if(address(crowdsale) == 0) {
710       throw;
711     }
712     if(_bonusBasePoints.length != _teamAddresses.length){
713       throw;
714     }
715 
716     totalMembers = _teamAddresses.length;
717     teamAddresses = _teamAddresses;
718     for (uint i=0;i<totalMembers;i++){
719       if(_bonusBasePoints[i] == 0) throw;
720     }
721     for (uint j=0;j<totalMembers;j++){
722       if(_teamAddresses[j] == 0) throw;
723       bonusOf[_teamAddresses[j]] = _bonusBasePoints[j];
724     }
725   }
726   function isSane() public constant returns (bool) {
727     return (token.mintAgents(address(this)) == true) && (token.releaseAgent() == address(this));
728   }
729   function finalizeCrowdsale() {
730     if(msg.sender != address(crowdsale)) {
731       throw;
732     }
733     uint tokensSold = crowdsale.tokensSold();
734 
735     for (uint i=0;i<totalMembers;i++){
736       allocatedBonus = safeMul(tokensSold,bonusOf[teamAddresses[i]]) / 10000;
737       token.mint(teamAddresses[i], allocatedBonus);
738     }
739     token.releaseTokenTransfer();
740   }
741 
742 }
743 
744 
745 contract MintedEthCappedCrowdsale is Crowdsale {
746 
747   /* Maximum amount of wei this crowdsale can raise. */
748   uint public weiCap;
749 
750   function MintedEthCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _weiCap) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
751     weiCap = _weiCap;
752   }
753 
754   /**
755    * Called from invest() to confirm if the curret investment does not break our cap rule.
756    */
757   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
758     return weiRaisedTotal > weiCap;
759   }
760 
761   function isCrowdsaleFull() public constant returns (bool) {
762     return weiRaised >= weiCap;
763   }
764 
765   /**
766    * Dynamically create tokens and assign them to the investor.
767    */
768   function assignTokens(address receiver, uint tokenAmount) private {
769     MintableToken mintableToken = MintableToken(token);
770     mintableToken.mint(receiver, tokenAmount);
771   }
772 }