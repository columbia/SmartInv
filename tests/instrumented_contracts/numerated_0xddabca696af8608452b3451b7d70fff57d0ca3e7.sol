1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10      * @dev Multiplies two numbers, throws on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22      * @dev Integer division of two numbers, truncating the quotient.
23      */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33      */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40      * @dev Adds two numbers, throws on overflow.
41      */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55 
56     address public owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62      * account.
63      */
64     function Ownable() public {
65         owner = msg.sender;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      * @param newOwner The address to transfer ownership to.
79      */
80     function transferOwnership(address newOwner) public onlyOwner {
81         require(newOwner != address(0));
82         OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84     }
85 }
86 
87 contract MultiOwnable {
88 
89     mapping(address => bool) public isOwner;
90     address[] public ownerHistory;
91     uint8 public ownerCount;
92 
93     event OwnerAddedEvent(address indexed _newOwner);
94     event OwnerRemovedEvent(address indexed _oldOwner);
95 
96     function MultiOwnable() public {
97         // Add default owner
98         address owner = msg.sender;
99         ownerHistory.push(owner);
100         isOwner[owner] = true;
101         ownerCount++;
102     }
103 
104     modifier onlyOwner() {
105         require(isOwner[msg.sender]);
106         _;
107     }
108 
109     function ownerHistoryCount() public view returns (uint) {
110         return ownerHistory.length;
111     }
112 
113     /** Add extra owner. */
114     function addOwner(address owner) onlyOwner public {
115         require(owner != address(0));
116         require(!isOwner[owner]);
117         ownerHistory.push(owner);
118         isOwner[owner] = true;
119         ownerCount++;
120         OwnerAddedEvent(owner);
121     }
122 
123     /** Remove extra owner. */
124     function removeOwner(address owner) onlyOwner public {
125 
126         // This check is neccessary to prevent a situation where all owners 
127         // are accidentally removed, because we do not want an ownable contract 
128         // to become an orphan.
129         require(ownerCount > 1);
130 
131         require(isOwner[owner]);
132         isOwner[owner] = false;
133         ownerCount--;
134         OwnerRemovedEvent(owner);
135     }
136 }
137 
138 contract Pausable is Ownable {
139 
140     bool public paused;
141 
142     modifier ifNotPaused {
143         require(!paused);
144         _;
145     }
146 
147     modifier ifPaused {
148         require(paused);
149         _;
150     }
151 
152     // Called by the owner on emergency, triggers paused state
153     function pause() external onlyOwner ifNotPaused {
154         paused = true;
155     }
156 
157     // Called by the owner on end of emergency, returns to normal state
158     function resume() external onlyOwner ifPaused {
159         paused = false;
160     }
161 }
162 
163 contract ERC20 {
164 
165     uint256 public totalSupply;
166 
167     function balanceOf(address _owner) public view returns (uint256 balance);
168 
169     function transfer(address _to, uint256 _value) public returns (bool success);
170 
171     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
172 
173     function approve(address _spender, uint256 _value) public returns (bool success);
174 
175     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
176 
177     event Transfer(address indexed _from, address indexed _to, uint256 _value);
178 
179     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
180 }
181 
182 contract StandardToken is ERC20 {
183 
184     using SafeMath for uint;
185 
186     mapping(address => uint256) balances;
187 
188     mapping(address => mapping(address => uint256)) allowed;
189 
190     function balanceOf(address _owner) public view returns (uint256 balance) {
191         return balances[_owner];
192     }
193 
194     function transfer(address _to, uint256 _value) public returns (bool) {
195         require(_to != address(0));
196 
197         balances[msg.sender] = balances[msg.sender].sub(_value);
198         balances[_to] = balances[_to].add(_value);
199         Transfer(msg.sender, _to, _value);
200         return true;
201     }
202 
203     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
204     /// @param _from Address from where tokens are withdrawn.
205     /// @param _to Address to where tokens are sent.
206     /// @param _value Number of tokens to transfer.
207     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
208         require(_to != address(0));
209 
210         balances[_from] = balances[_from].sub(_value);
211         balances[_to] = balances[_to].add(_value);
212         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
213         Transfer(_from, _to, _value);
214         return true;
215     }
216 
217     /// @dev Sets approved amount of tokens for spender. Returns success.
218     /// @param _spender Address of allowed account.
219     /// @param _value Number of approved tokens.
220     function approve(address _spender, uint256 _value) public returns (bool) {
221         allowed[msg.sender][_spender] = _value;
222         Approval(msg.sender, _spender, _value);
223         return true;
224     }
225 
226     /// @dev Returns number of allowed tokens for given address.
227     /// @param _owner Address of token owner.
228     /// @param _spender Address of token spender.
229     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
230         return allowed[_owner][_spender];
231     }
232 }
233 
234 contract CommonToken is StandardToken, MultiOwnable {
235 
236     string public constant name = 'White Rabbit Token';
237     string public constant symbol = 'WRT';
238     uint8 public constant decimals = 18;
239 
240     // The main account that holds all tokens from the time token created and during all tokensales.
241     address public seller;
242 
243     // saleLimit (e18) Maximum amount of tokens for sale across all tokensales.
244     // Reserved tokens formula: 16% Team + 6% Partners + 5% Advisory Board + 15% WR reserve 1 = 42%
245     // For sale formula: 40% for sale + 1.5% Bounty + 16.5% WR reserve 2 = 58%
246     uint256 public constant saleLimit = 110200000 ether;
247 
248     // Next fields are for stats:
249     uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.
250     uint256 public totalSales; // Total number of sales (including external sales) made through all tiers or tokensales.
251 
252     // Lock the transfer functions during tokensales to prevent price speculations.
253     bool public locked = true;
254 
255     event SellEvent(address indexed _seller, address indexed _buyer, uint256 _value);
256     event ChangeSellerEvent(address indexed _oldSeller, address indexed _newSeller);
257     event Burn(address indexed _burner, uint256 _value);
258     event Unlock();
259 
260     function CommonToken(
261         address _seller
262     ) MultiOwnable() public {
263 
264         require(_seller != 0);
265         seller = _seller;
266 
267         totalSupply = 190000000 ether;
268         balances[seller] = totalSupply;
269         Transfer(0x0, seller, totalSupply);
270     }
271 
272     modifier ifUnlocked() {
273         require(isOwner[msg.sender] || !locked);
274         _;
275     }
276 
277     /**
278      * An address can become a new seller only in case it has no tokens.
279      * This is required to prevent stealing of tokens  from newSeller via 
280      * 2 calls of this function.
281      */
282     function changeSeller(address newSeller) onlyOwner public returns (bool) {
283         require(newSeller != address(0));
284         require(seller != newSeller);
285 
286         // To prevent stealing of tokens from newSeller via 2 calls of changeSeller:
287         require(balances[newSeller] == 0);
288 
289         address oldSeller = seller;
290         uint256 unsoldTokens = balances[oldSeller];
291         balances[oldSeller] = 0;
292         balances[newSeller] = unsoldTokens;
293         Transfer(oldSeller, newSeller, unsoldTokens);
294 
295         seller = newSeller;
296         ChangeSellerEvent(oldSeller, newSeller);
297         return true;
298     }
299 
300     /**
301      * User-friendly alternative to sell() function.
302      */
303     function sellNoDecimals(address _to, uint256 _value) public returns (bool) {
304         return sell(_to, _value * 1e18);
305     }
306 
307     function sell(address _to, uint256 _value) onlyOwner public returns (bool) {
308 
309         // Check that we are not out of limit and still can sell tokens:
310         if (saleLimit > 0) require(tokensSold.add(_value) <= saleLimit);
311 
312         require(_to != address(0));
313         require(_value > 0);
314         require(_value <= balances[seller]);
315 
316         balances[seller] = balances[seller].sub(_value);
317         balances[_to] = balances[_to].add(_value);
318         Transfer(seller, _to, _value);
319 
320         totalSales++;
321         tokensSold = tokensSold.add(_value);
322         SellEvent(seller, _to, _value);
323         return true;
324     }
325 
326     function transfer(address _to, uint256 _value) ifUnlocked public returns (bool) {
327         return super.transfer(_to, _value);
328     }
329 
330     function transferFrom(address _from, address _to, uint256 _value) ifUnlocked public returns (bool) {
331         return super.transferFrom(_from, _to, _value);
332     }
333 
334     function burn(uint256 _value) public returns (bool) {
335         require(_value > 0);
336 
337         balances[msg.sender] = balances[msg.sender].sub(_value);
338         totalSupply = totalSupply.sub(_value);
339         Transfer(msg.sender, 0x0, _value);
340         Burn(msg.sender, _value);
341         return true;
342     }
343 
344     /** Can be called once by super owner. */
345     function unlock() onlyOwner public {
346         require(locked);
347         locked = false;
348         Unlock();
349     }
350 }
351 
352 contract CommonWhitelist is MultiOwnable {
353 
354     mapping(address => bool) public isAllowed;
355 
356     // Historical array of wallet that have bben added to whitelist,
357     // even if some addresses have been removed later such wallet still remaining
358     // in the history. This is Solidity optimization for work with large arrays.
359     address[] public history;
360 
361     event AddedEvent(address indexed wallet);
362     event RemovedEvent(address indexed wallet);
363 
364     function CommonWhitelist() MultiOwnable() public {}
365 
366     function historyCount() public view returns (uint) {
367         return history.length;
368     }
369 
370     function add(address _wallet) internal {
371         require(_wallet != address(0));
372         require(!isAllowed[_wallet]);
373 
374         history.push(_wallet);
375         isAllowed[_wallet] = true;
376         AddedEvent(_wallet);
377     }
378 
379     function addMany(address[] _wallets) public onlyOwner {
380         for (uint i = 0; i < _wallets.length; i++) {
381             add(_wallets[i]);
382         }
383     }
384 
385     function remove(address _wallet) internal {
386         require(isAllowed[_wallet]);
387 
388         isAllowed[_wallet] = false;
389         RemovedEvent(_wallet);
390     }
391 
392     function removeMany(address[] _wallets) public onlyOwner {
393         for (uint i = 0; i < _wallets.length; i++) {
394             remove(_wallets[i]);
395         }
396     }
397 }
398 
399 //---------------------------------------------------------------
400 // Wings contracts: Start
401 // DO NOT CHANGE the next contracts. They were copied from Wings 
402 // and left unformated.
403 
404 contract HasManager {
405     address public manager;
406 
407     modifier onlyManager {
408         require(msg.sender == manager);
409         _;
410     }
411 
412     function transferManager(address _newManager) public onlyManager() {
413         require(_newManager != address(0));
414         manager = _newManager;
415     }
416 }
417 
418 // Crowdsale contracts interface
419 contract ICrowdsaleProcessor is Ownable, HasManager {
420     modifier whenCrowdsaleAlive() {
421         require(isActive());
422         _;
423     }
424 
425     modifier whenCrowdsaleFailed() {
426         require(isFailed());
427         _;
428     }
429 
430     modifier whenCrowdsaleSuccessful() {
431         require(isSuccessful());
432         _;
433     }
434 
435     modifier hasntStopped() {
436         require(!stopped);
437         _;
438     }
439 
440     modifier hasBeenStopped() {
441         require(stopped);
442         _;
443     }
444 
445     modifier hasntStarted() {
446         require(!started);
447         _;
448     }
449 
450     modifier hasBeenStarted() {
451         require(started);
452         _;
453     }
454 
455     // Minimal acceptable hard cap
456     uint256 constant public MIN_HARD_CAP = 1 ether;
457 
458     // Minimal acceptable duration of crowdsale
459     uint256 constant public MIN_CROWDSALE_TIME = 3 days;
460 
461     // Maximal acceptable duration of crowdsale
462     uint256 constant public MAX_CROWDSALE_TIME = 50 days;
463 
464     // Becomes true when timeframe is assigned
465     bool public started;
466 
467     // Becomes true if cancelled by owner
468     bool public stopped;
469 
470     // Total collected Ethereum: must be updated every time tokens has been sold
471     uint256 public totalCollected;
472 
473     // Total amount of project's token sold: must be updated every time tokens has been sold
474     uint256 public totalSold;
475 
476     // Crowdsale minimal goal, must be greater or equal to Forecasting min amount
477     uint256 public minimalGoal;
478 
479     // Crowdsale hard cap, must be less or equal to Forecasting max amount
480     uint256 public hardCap;
481 
482     // Crowdsale duration in seconds.
483     // Accepted range is MIN_CROWDSALE_TIME..MAX_CROWDSALE_TIME.
484     uint256 public duration;
485 
486     // Start timestamp of crowdsale, absolute UTC time
487     uint256 public startTimestamp;
488 
489     // End timestamp of crowdsale, absolute UTC time
490     uint256 public endTimestamp;
491 
492     // Allows to transfer some ETH into the contract without selling tokens
493     function deposit() public payable {}
494 
495     // Returns address of crowdsale token, must be ERC20 compilant
496     function getToken() public returns (address);
497 
498     // Transfers ETH rewards amount (if ETH rewards is configured) to Forecasting contract
499     function mintETHRewards(address _contract, uint256 _amount) public onlyManager();
500 
501     // Mints token Rewards to Forecasting contract
502     function mintTokenRewards(address _contract, uint256 _amount) public onlyManager();
503 
504     // Releases tokens (transfers crowdsale token from mintable to transferrable state)
505     function releaseTokens() public onlyManager() hasntStopped() whenCrowdsaleSuccessful();
506 
507     // Stops crowdsale. Called by CrowdsaleController, the latter is called by owner.
508     // Crowdsale may be stopped any time before it finishes.
509     function stop() public onlyManager() hasntStopped();
510 
511     // Validates parameters and starts crowdsale
512     function start(uint256 _startTimestamp, uint256 _endTimestamp, address _fundingAddress)
513     public onlyManager() hasntStarted() hasntStopped();
514 
515     // Is crowdsale failed (completed, but minimal goal wasn't reached)
516     function isFailed() public constant returns (bool);
517 
518     // Is crowdsale active (i.e. the token can be sold)
519     function isActive() public constant returns (bool);
520 
521     // Is crowdsale completed successfully
522     function isSuccessful() public constant returns (bool);
523 }
524 
525 // Basic crowdsale implementation both for regualt and 3rdparty Crowdsale contracts
526 contract BasicCrowdsale is ICrowdsaleProcessor {
527     event CROWDSALE_START(uint256 startTimestamp, uint256 endTimestamp, address fundingAddress);
528 
529     // Where to transfer collected ETH
530     address public fundingAddress;
531 
532     // Ctor.
533     function BasicCrowdsale(
534         address _owner,
535         address _manager
536     )
537     public
538     {
539         owner = _owner;
540         manager = _manager;
541     }
542 
543     // called by CrowdsaleController to transfer reward part of ETH
544     // collected by successful crowdsale to Forecasting contract.
545     // This call is made upon closing successful crowdfunding process
546     // iff agreed ETH reward part is not zero
547     function mintETHRewards(
548         address _contract, // Forecasting contract
549         uint256 _amount     // agreed part of totalCollected which is intended for rewards
550     )
551     public
552     onlyManager() // manager is CrowdsaleController instance
553     {
554         require(_contract.call.value(_amount)());
555     }
556 
557     // cancels crowdsale
558     function stop() public onlyManager() hasntStopped() {
559         // we can stop only not started and not completed crowdsale
560         if (started) {
561             require(!isFailed());
562             require(!isSuccessful());
563         }
564         stopped = true;
565     }
566 
567     // called by CrowdsaleController to setup start and end time of crowdfunding process
568     // as well as funding address (where to transfer ETH upon successful crowdsale)
569     function start(
570         uint256 _startTimestamp,
571         uint256 _endTimestamp,
572         address _fundingAddress
573     )
574     public
575     onlyManager() // manager is CrowdsaleController instance
576     hasntStarted() // not yet started
577     hasntStopped() // crowdsale wasn't cancelled
578     {
579         require(_fundingAddress != address(0));
580 
581         // start time must not be earlier than current time
582         require(_startTimestamp >= block.timestamp);
583 
584         // range must be sane
585         require(_endTimestamp > _startTimestamp);
586         duration = _endTimestamp - _startTimestamp;
587 
588         // duration must fit constraints
589         require(duration >= MIN_CROWDSALE_TIME && duration <= MAX_CROWDSALE_TIME);
590 
591         startTimestamp = _startTimestamp;
592         endTimestamp = _endTimestamp;
593         fundingAddress = _fundingAddress;
594 
595         // now crowdsale is considered started, even if the current time is before startTimestamp
596         started = true;
597 
598         CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);
599     }
600 
601     // must return true if crowdsale is over, but it failed
602     function isFailed()
603     public
604     constant
605     returns (bool)
606     {
607         return (
608         // it was started
609         started &&
610 
611         // crowdsale period has finished
612         block.timestamp >= endTimestamp &&
613 
614         // but collected ETH is below the required minimum
615         totalCollected < minimalGoal
616         );
617     }
618 
619     // must return true if crowdsale is active (i.e. the token can be bought)
620     function isActive()
621     public
622     constant
623     returns (bool)
624     {
625         return (
626         // it was started
627         started &&
628 
629         // hard cap wasn't reached yet
630         totalCollected < hardCap &&
631 
632         // and current time is within the crowdfunding period
633         block.timestamp >= startTimestamp &&
634         block.timestamp < endTimestamp
635         );
636     }
637 
638     // must return true if crowdsale completed successfully
639     function isSuccessful()
640     public
641     constant
642     returns (bool)
643     {
644         return (
645         // either the hard cap is collected
646         totalCollected >= hardCap ||
647 
648         // ...or the crowdfunding period is over, but the minimum has been reached
649         (block.timestamp >= endTimestamp && totalCollected >= minimalGoal)
650         );
651     }
652 }
653 
654 // Minimal crowdsale token for custom contracts
655 contract IWingsController {
656     uint256 public ethRewardPart;
657     uint256 public tokenRewardPart;
658 }
659 
660 /*
661   Implements custom crowdsale as bridge
662 */
663 contract Bridge is BasicCrowdsale {
664     using SafeMath for uint256;
665 
666     modifier onlyCrowdsale() {
667         require(msg.sender == crowdsaleAddress);
668         _;
669     }
670 
671     // Crowdsale token
672     StandardToken token;
673 
674     // Address of crowdsale
675     address public crowdsaleAddress;
676 
677     // is crowdsale completed
678     bool public completed;
679 
680     // Ctor. In this example, minimalGoal, hardCap, and price are not changeable.
681     // In more complex cases, those parameters may be changed until start() is called.
682     function Bridge(
683         uint256 _minimalGoal,
684         uint256 _hardCap,
685         address _token,
686         address _crowdsaleAddress
687     )
688     public
689         // simplest case where manager==owner. See onlyOwner() and onlyManager() modifiers
690         // before functions to figure out the cases in which those addresses should differ
691     BasicCrowdsale(msg.sender, msg.sender)
692     {
693         // just setup them once...
694         minimalGoal = _minimalGoal;
695         hardCap = _hardCap;
696         crowdsaleAddress = _crowdsaleAddress;
697         token = StandardToken(_token);
698     }
699 
700     // Here goes ICrowdsaleProcessor implementation
701 
702     // returns address of crowdsale token. The token must be ERC20-compliant
703     function getToken()
704     public
705     returns (address)
706     {
707         return address(token);
708     }
709 
710     // called by CrowdsaleController to transfer reward part of
711     // tokens sold by successful crowdsale to Forecasting contract.
712     // This call is made upon closing successful crowdfunding process.
713     function mintTokenRewards(
714         address _contract, // Forecasting contract
715         uint256 _amount     // agreed part of totalSold which is intended for rewards
716     )
717     public
718     onlyManager() // manager is CrowdsaleController instance
719     {
720         // crowdsale token is mintable in this example, tokens are created here
721         token.transfer(_contract, _amount);
722     }
723 
724     // transfers crowdsale token from mintable to transferrable state
725     function releaseTokens()
726     public
727     onlyManager() // manager is CrowdsaleController instance
728     hasntStopped() // crowdsale wasn't cancelled
729     whenCrowdsaleSuccessful() // crowdsale was successful
730     {
731         // empty for bridge
732     }
733 
734     // Here go crowdsale process itself and token manipulations
735 
736     // default function allows for ETH transfers to the contract
737     function() payable public {
738     }
739 
740     function notifySale(uint256 _ethAmount, uint256 _tokensAmount) public
741     hasBeenStarted() // crowdsale started
742     hasntStopped() // wasn't cancelled by owner
743     whenCrowdsaleAlive() // in active state
744     onlyCrowdsale() // can do only crowdsale
745     {
746         totalCollected = totalCollected.add(_ethAmount);
747         totalSold = totalSold.add(_tokensAmount);
748     }
749 
750     // finish collecting data
751     function finish() public
752     hasntStopped()
753     hasBeenStarted()
754     whenCrowdsaleAlive()
755     onlyCrowdsale()
756     {
757         completed = true;
758     }
759 
760     // project's owner withdraws ETH funds to the funding address upon successful crowdsale
761     function withdraw(
762         uint256 _amount // can be done partially
763     )
764     public
765     onlyOwner() // project's owner
766     hasntStopped() // crowdsale wasn't cancelled
767     whenCrowdsaleSuccessful() // crowdsale completed successfully
768     {
769         // nothing to withdraw
770     }
771 
772     // backers refund their ETH if the crowdsale was cancelled or has failed
773     function refund()
774     public
775     {
776         // nothing to refund
777     }
778 
779     // called by CrowdsaleController to setup start and end time of crowdfunding process
780     // as well as funding address (where to transfer ETH upon successful crowdsale)
781     function start(
782         uint256 _startTimestamp,
783         uint256 _endTimestamp,
784         address _fundingAddress
785     )
786     public
787     onlyManager() // manager is CrowdsaleController instance
788     hasntStarted() // not yet started
789     hasntStopped() // crowdsale wasn't cancelled
790     {
791         // just start crowdsale
792         started = true;
793 
794         CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);
795     }
796 
797     // must return true if crowdsale is over, but it failed
798     function isFailed()
799     public
800     constant
801     returns (bool)
802     {
803         return (
804         false
805         );
806     }
807 
808     // must return true if crowdsale is active (i.e. the token can be bought)
809     function isActive()
810     public
811     constant
812     returns (bool)
813     {
814         return (
815         // we remove timelines
816         started && !completed
817         );
818     }
819 
820     // must return true if crowdsale completed successfully
821     function isSuccessful()
822     public
823     constant
824     returns (bool)
825     {
826         return (
827         completed
828         );
829     }
830 
831     function calculateRewards() public view returns (uint256, uint256) {
832         uint256 tokenRewardPart = IWingsController(manager).tokenRewardPart();
833         uint256 ethRewardPart = IWingsController(manager).ethRewardPart();
834 
835         uint256 tokenReward = totalSold.mul(tokenRewardPart) / 1000000;
836         bool hasEthReward = (ethRewardPart != 0);
837 
838         uint256 ethReward = 0;
839         if (hasEthReward) {
840             ethReward = totalCollected.mul(ethRewardPart) / 1000000;
841         }
842 
843         return (ethReward, tokenReward);
844     }
845 }
846 
847 contract Connector is Ownable {
848     modifier bridgeInitialized() {
849         require(address(bridge) != address(0x0));
850         _;
851     }
852 
853     Bridge public bridge;
854 
855     function changeBridge(address _bridge) public onlyOwner {
856         require(_bridge != address(0x0));
857         bridge = Bridge(_bridge);
858     }
859 
860     function notifySale(uint256 _ethAmount, uint256 _tokenAmount) internal bridgeInitialized {
861         bridge.notifySale(_ethAmount, _tokenAmount);
862     }
863 
864     function closeBridge() internal bridgeInitialized {
865         bridge.finish();
866     }
867 }
868 
869 // Wings contracts: End
870 //---------------------------------------------------------------
871 
872 contract CommonTokensale is Connector, Pausable {
873 
874     using SafeMath for uint;
875 
876     CommonToken public token;         // Token contract reference.
877     CommonWhitelist public whitelist; // Whitelist contract reference.
878 
879     address public beneficiary;       // Address that will receive ETH raised during this tokensale.
880     address public bsWallet = 0x8D5bd2aBa04A07Bfa0cc976C73eD45B23cC6D6a2;
881 
882     bool public whitelistEnabled = true;
883 
884     uint public constant preSaleMinPaymentWei = 5 ether;    // Hint: Set to lower amount (ex. 0.001 ETH) for tests.
885     uint public constant mainSaleMinPaymentWei = 0.05 ether; // Hint: Set to lower amount (ex. 0.001 ETH) for tests.
886 
887     uint public defaultTokensPerWei = 4750; // TODO To be determined based on ETH to USD price at the date of sale.
888     uint public tokensPerWei5;
889     uint public tokensPerWei7;
890     uint public tokensPerWei10;
891     uint public tokensPerWei15;
892     uint public tokensPerWei20;
893 
894     uint public minCapWei = 3200 ether;  // TODO  2m USD. Recalculate based on ETH to USD price at the date of tokensale.
895     uint public maxCapWei = 16000 ether; // TODO 10m USD. Recalculate based on ETH to USD price at the date of tokensale.
896 
897     uint public constant startTime = 1525701600; // May 7, 2018 2:00:00 PM
898     uint public constant preSaleEndTime = 1526306400; // May 14, 2018 2:00:00 PM
899     uint public constant mainSaleStartTime = 1526392800; // May 15, 2018 2:00:00 PM
900     uint public constant endTime = 1528639200; // June 10, 2018 2:00:00 PM
901 
902     // At main sale bonuses will be available only during the first 48 hours.
903     uint public mainSaleBonusEndTime;
904 
905     // In case min (soft) cap is not reached, token buyers will be able to 
906     // refund their contributions during one month after sale is finished.
907     uint public refundDeadlineTime;
908 
909     // Stats for current tokensale:
910 
911     uint public totalTokensSold;  // Total amount of tokens sold during this tokensale.
912     uint public totalWeiReceived; // Total amount of wei received during this tokensale.
913     uint public totalWeiRefunded; // Total amount of wei refunded if min (soft) cap is not reached.
914 
915     // This mapping stores info on how many ETH (wei) have been sent to this tokensale from specific address.
916     mapping(address => uint256) public buyerToSentWei;
917 
918     mapping(bytes32 => bool) public calledOnce;
919 
920     event ChangeBeneficiaryEvent(address indexed _oldAddress, address indexed _newAddress);
921     event ChangeWhitelistEvent(address indexed _oldAddress, address indexed _newAddress);
922     event ReceiveEthEvent(address indexed _buyer, uint256 _amountWei);
923     event RefundEthEvent(address indexed _buyer, uint256 _amountWei);
924 
925     function CommonTokensale(
926         address _token,
927         address _whitelist,
928         address _beneficiary
929     ) public Connector() {
930         require(_token != 0);
931         require(_whitelist != 0);
932         require(_beneficiary != 0);
933 
934         token = CommonToken(_token);
935         whitelist = CommonWhitelist(_whitelist);
936         beneficiary = _beneficiary;
937 
938         mainSaleBonusEndTime = mainSaleStartTime + 48 hours;
939         refundDeadlineTime = endTime + 30 days;
940 
941         recalcBonuses();
942     }
943 
944     modifier canBeCalledOnce(bytes32 _flag) {
945         require(!calledOnce[_flag]);
946         calledOnce[_flag] = true;
947         _;
948     }
949 
950     function updateMinCapEthOnce(uint _amountInEth) public onlyOwner canBeCalledOnce("updateMinCapEth") {
951         minCapWei = _amountInEth * 1e18;
952         // Convert ETH to Wei and update a min cap.
953     }
954 
955     function updateMaxCapEthOnce(uint _amountInEth) public onlyOwner canBeCalledOnce("updateMaxCapEth") {
956         maxCapWei = _amountInEth * 1e18;
957         // Convert ETH to Wei and update a max cap.
958     }
959 
960     function updateTokensPerEthOnce(uint _amountInEth) public onlyOwner canBeCalledOnce("updateTokensPerEth") {
961         defaultTokensPerWei = _amountInEth;
962         recalcBonuses();
963     }
964 
965     function setBeneficiary(address _beneficiary) public onlyOwner {
966         require(_beneficiary != 0);
967         ChangeBeneficiaryEvent(beneficiary, _beneficiary);
968         beneficiary = _beneficiary;
969     }
970 
971     function setWhitelist(address _whitelist) public onlyOwner {
972         require(_whitelist != 0);
973         ChangeWhitelistEvent(whitelist, _whitelist);
974         whitelist = CommonWhitelist(_whitelist);
975     }
976 
977     function setWhitelistEnabled(bool _enabled) public onlyOwner {
978         whitelistEnabled = _enabled;
979     }
980 
981     /** The fallback function corresponds to a donation in ETH. */
982     function() public payable {
983         sellTokensForEth(msg.sender, msg.value);
984     }
985 
986     function sellTokensForEth(
987         address _buyer,
988         uint256 _amountWei
989     ) ifNotPaused internal {
990 
991         // Check that buyer is in whitelist onlist if whitelist check is enabled.
992         if (whitelistEnabled) require(whitelist.isAllowed(_buyer));
993 
994         require(canAcceptPayment(_amountWei));
995         require(totalWeiReceived < maxCapWei);
996 
997         uint256 newTotalReceived = totalWeiReceived.add(_amountWei);
998 
999         // Don't sell anything above the hard cap
1000         if (newTotalReceived > maxCapWei) {
1001             uint refundWei = newTotalReceived.sub(maxCapWei);
1002             _amountWei = _amountWei.sub(refundWei);
1003 
1004             // We need to check payment amount once more such as we updated 
1005             // (reduced) it in this if-clause.
1006             require(canAcceptPayment(_amountWei));
1007 
1008             // Send the ETH part which exceeds the hard cap back to the buyer:
1009             _buyer.transfer(refundWei);
1010         }
1011 
1012         uint tokensE18 = weiToTokens(_amountWei);
1013         // Transfer tokens to buyer.
1014         token.sell(_buyer, tokensE18);
1015 
1016         // 0.75% of sold tokens go to BS account:
1017         uint bsTokens = tokensE18.mul(75).div(10000);
1018         token.sell(bsWallet, bsTokens);
1019 
1020         // Update total stats:
1021         totalTokensSold = totalTokensSold.add(tokensE18).add(bsTokens);
1022         totalWeiReceived = totalWeiReceived.add(_amountWei);
1023         buyerToSentWei[_buyer] = buyerToSentWei[_buyer].add(_amountWei);
1024         ReceiveEthEvent(_buyer, _amountWei);
1025 
1026         // Notify Wings about successful sale of tokens:
1027         notifySale(_amountWei, tokensE18.add(bsTokens));
1028     }
1029 
1030     function recalcBonuses() internal {
1031         tokensPerWei5 = tokensPerWeiPlusBonus(5);
1032         tokensPerWei7 = tokensPerWeiPlusBonus(7);
1033         tokensPerWei10 = tokensPerWeiPlusBonus(10);
1034         tokensPerWei15 = tokensPerWeiPlusBonus(15);
1035         tokensPerWei20 = tokensPerWeiPlusBonus(20);
1036     }
1037 
1038     function tokensPerWeiPlusBonus(uint _per) public view returns (uint) {
1039         return defaultTokensPerWei.add(
1040             amountPercentage(defaultTokensPerWei, _per)
1041         );
1042     }
1043 
1044     function amountPercentage(uint _amount, uint _per) public pure returns (uint) {
1045         return _amount.mul(_per).div(100);
1046     }
1047 
1048     /** Calc how much tokens you can buy at current time. */
1049     function weiToTokens(uint _amountWei) public view returns (uint) {
1050         return _amountWei.mul(tokensPerWei(_amountWei));
1051     }
1052 
1053     function tokensPerWei(uint _amountWei) public view returns (uint256) {
1054         // Presale bonuses:
1055         if (isPreSaleTime()) {
1056             if (5 ether <= _amountWei && _amountWei < 10 ether) return tokensPerWei10;
1057             if (_amountWei < 20 ether) return tokensPerWei15;
1058             if (20 ether <= _amountWei) return tokensPerWei20;
1059         }
1060         // Main sale bonues:
1061         if (isMainSaleBonusTime()) {
1062             if (0.05 ether <= _amountWei && _amountWei < 10 ether) return tokensPerWei5;
1063             if (_amountWei < 20 ether) return tokensPerWei7;
1064             if (20 ether <= _amountWei) return tokensPerWei10;
1065         }
1066         return defaultTokensPerWei;
1067     }
1068 
1069     function canAcceptPayment(uint _amountWei) public view returns (bool) {
1070         if (isPreSaleTime()) return _amountWei >= preSaleMinPaymentWei;
1071         if (isMainSaleTime()) return _amountWei >= mainSaleMinPaymentWei;
1072         return false;
1073     }
1074 
1075     function isPreSaleTime() public view returns (bool) {
1076         return startTime <= now && now <= preSaleEndTime;
1077     }
1078 
1079     function isMainSaleBonusTime() public view returns (bool) {
1080         return mainSaleStartTime <= now && now <= mainSaleBonusEndTime;
1081     }
1082 
1083     function isMainSaleTime() public view returns (bool) {
1084         return mainSaleStartTime <= now && now <= endTime;
1085     }
1086 
1087     function isFinishedSuccessfully() public view returns (bool) {
1088         return totalWeiReceived >= minCapWei && now > endTime;
1089     }
1090 
1091     /** 
1092      * During tokensale it will be possible to withdraw only in two cases:
1093      * min cap reached OR refund period expired.
1094      */
1095     function canWithdraw() public view returns (bool) {
1096         return totalWeiReceived >= minCapWei || now > refundDeadlineTime;
1097     }
1098 
1099     /** 
1100      * This method allows to withdraw to any arbitrary ETH address. 
1101      * This approach gives more flexibility.
1102      */
1103     function withdraw(address _to, uint256 _amount) public {
1104         require(canWithdraw());
1105         require(msg.sender == beneficiary);
1106         require(_amount <= this.balance);
1107 
1108         _to.transfer(_amount);
1109     }
1110 
1111     function withdraw(address _to) public {
1112         withdraw(_to, this.balance);
1113     }
1114 
1115     /** 
1116      * It will be possible to refund only if min (soft) cap is not reached and 
1117      * refund requested during 30 days after tokensale finished.
1118      */
1119     function canRefund() public view returns (bool) {
1120         return totalWeiReceived < minCapWei && endTime < now && now <= refundDeadlineTime;
1121     }
1122 
1123     function refund() public {
1124         require(canRefund());
1125 
1126         address buyer = msg.sender;
1127         uint amount = buyerToSentWei[buyer];
1128         require(amount > 0);
1129 
1130         RefundEthEvent(buyer, amount);
1131         buyerToSentWei[buyer] = 0;
1132         totalWeiRefunded = totalWeiRefunded.add(amount);
1133         buyer.transfer(amount);
1134     }
1135 
1136     /**
1137      * If there is ETH rewards and all ETH already withdrawn but contract 
1138      * needs to pay for transfering transactions. 
1139      */
1140     function deposit() public payable {
1141         require(isFinishedSuccessfully());
1142     }
1143 
1144     /** 
1145      * This function should be called only once only after 
1146      * successfully finished tokensale. Once - because Wings bridge 
1147      * will be closed at the end of this function call.
1148      */
1149     function sendWingsRewardsOnce() public onlyOwner canBeCalledOnce("sendWingsRewards") {
1150         require(isFinishedSuccessfully());
1151 
1152         uint256 ethReward = 0;
1153         uint256 tokenReward = 0;
1154 
1155         (ethReward, tokenReward) = bridge.calculateRewards();
1156 
1157         if (ethReward > 0) {
1158             bridge.transfer(ethReward);
1159         }
1160 
1161         if (tokenReward > 0) {
1162             token.sell(bridge, tokenReward);
1163         }
1164 
1165         // Close Wings bridge
1166         closeBridge();
1167     }
1168 }
1169 
1170 
1171 // >> Start:
1172 // >> EXAMPLE: How to deploy Token, Whitelist and Tokensale.
1173 
1174 // token = new CommonToken(
1175 //     0x123 // TODO Set seller address
1176 // );
1177 // whitelist = new CommonWhitelist();
1178 // tokensale = new Tokensale(
1179 //     token,
1180 //     whitelist,
1181 //     0x123 // TODO Set beneficiary address
1182 // );
1183 // token.addOwner(tokensale);
1184 
1185 // << EXAMPLE: How to deploy Token, Whitelist and Tokensale.
1186 // << End
1187 
1188 
1189 // TODO After Tokensale deployed, call token.addOwner(address_of_deployed_tokensale)
1190 contract ProdTokensale is CommonTokensale {
1191     function ProdTokensale() CommonTokensale(
1192         0x123, // TODO Set token address
1193         0x123, // TODO Set whitelist address
1194         0x123  // TODO Set beneficiary address
1195     ) public {}
1196 }