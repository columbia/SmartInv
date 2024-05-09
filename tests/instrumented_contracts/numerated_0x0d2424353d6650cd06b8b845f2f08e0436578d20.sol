1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract ERC20Basic {
67   uint256 public totalSupply;
68   function balanceOf(address who) public constant returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85 
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public constant returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public constant returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124 
125     uint256 _allowance = allowed[_from][msg.sender];
126 
127     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
128     // require (_value <= _allowance);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = _allowance.sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    */
169   function increaseApproval (address _spender, uint _addedValue)
170     returns (bool success) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   function decreaseApproval (address _spender, uint _subtractedValue)
177     returns (bool success) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 contract MintableToken is StandardToken, Ownable {
191   event Mint(address indexed to, uint256 amount);
192   event MintFinished();
193 
194   bool public mintingFinished = false;
195 
196 
197   modifier canMint() {
198     require(!mintingFinished);
199     _;
200   }
201 
202   /**
203    * @dev Function to mint tokens
204    * @param _to The address that will receive the minted tokens.
205    * @param _amount The amount of tokens to mint.
206    * @return A boolean that indicates if the operation was successful.
207    */
208   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
209     totalSupply = totalSupply.add(_amount);
210     balances[_to] = balances[_to].add(_amount);
211     Mint(_to, _amount);
212     Transfer(0x0, _to, _amount);
213     return true;
214   }
215 
216   /**
217    * @dev Function to stop minting new tokens.
218    * @return True if the operation was successful.
219    */
220   function finishMinting() onlyOwner public returns (bool) {
221     mintingFinished = true;
222     MintFinished();
223     return true;
224   }
225 }
226 
227 contract Ballot {
228     using SafeMath for uint256;
229     EthearnalRepToken public tokenContract;
230 
231     // Date when vote has started
232     uint256 public ballotStarted;
233 
234     // Registry of votes
235     mapping(address => bool) public votesByAddress;
236 
237     // Sum of weights of YES votes
238     uint256 public yesVoteSum = 0;
239 
240     // Sum of weights of NO votes
241     uint256 public noVoteSum = 0;
242 
243     // Length of `voters`
244     uint256 public votersLength = 0;
245 
246     uint256 public initialQuorumPercent = 51;
247 
248     VotingProxy public proxyVotingContract;
249 
250     // Tells if voting process is active
251     bool public isVotingActive = false;
252 
253     event FinishBallot(uint256 _time);
254     event Vote(address indexed sender, bytes vote);
255     
256     modifier onlyWhenBallotStarted {
257         require(ballotStarted != 0);
258         _;
259     }
260 
261     function Ballot(address _tokenContract) {
262         tokenContract = EthearnalRepToken(_tokenContract);
263         proxyVotingContract = VotingProxy(msg.sender);
264         ballotStarted = getTime();
265         isVotingActive = true;
266     }
267     
268     function getQuorumPercent() public constant returns (uint256) {
269         require(isVotingActive);
270         // find number of full weeks alapsed since voting started
271         uint256 weeksNumber = getTime().sub(ballotStarted).div(1 weeks);
272         if(weeksNumber == 0) {
273             return initialQuorumPercent;
274         }
275         if (initialQuorumPercent < weeksNumber * 10) {
276             return 0;
277         } else {
278             return initialQuorumPercent.sub(weeksNumber * 10);
279         }
280     }
281 
282     function vote(bytes _vote) public onlyWhenBallotStarted {
283         require(_vote.length > 0);
284         if (isDataYes(_vote)) {
285             processVote(true);
286         } else if (isDataNo(_vote)) {
287             processVote(false);
288         }
289         Vote(msg.sender, _vote);
290     }
291 
292     function isDataYes(bytes data) public constant returns (bool) {
293         // compare data with "YES" string
294         return (
295             data.length == 3 &&
296             (data[0] == 0x59 || data[0] == 0x79) &&
297             (data[1] == 0x45 || data[1] == 0x65) &&
298             (data[2] == 0x53 || data[2] == 0x73)
299         );
300     }
301 
302     // TESTED
303     function isDataNo(bytes data) public constant returns (bool) {
304         // compare data with "NO" string
305         return (
306             data.length == 2 &&
307             (data[0] == 0x4e || data[0] == 0x6e) &&
308             (data[1] == 0x4f || data[1] == 0x6f)
309         );
310     }
311     
312     function processVote(bool isYes) internal {
313         require(isVotingActive);
314         require(!votesByAddress[msg.sender]);
315         votersLength = votersLength.add(1);
316         uint256 voteWeight = tokenContract.balanceOf(msg.sender);
317         if (isYes) {
318             yesVoteSum = yesVoteSum.add(voteWeight);
319         } else {
320             noVoteSum = noVoteSum.add(voteWeight);
321         }
322         require(getTime().sub(tokenContract.lastMovement(msg.sender)) > 7 days);
323         uint256 quorumPercent = getQuorumPercent();
324         if (quorumPercent == 0) {
325             isVotingActive = false;
326         } else {
327             decide();
328         }
329         votesByAddress[msg.sender] = true;
330     }
331 
332     function decide() internal {
333         uint256 quorumPercent = getQuorumPercent();
334         uint256 quorum = quorumPercent.mul(tokenContract.totalSupply()).div(100);
335         uint256 soFarVoted = yesVoteSum.add(noVoteSum);
336         if (soFarVoted >= quorum) {
337             uint256 percentYes = (100 * yesVoteSum).div(soFarVoted);
338             if (percentYes >= initialQuorumPercent) {
339                 // does not matter if it would be greater than weiRaised
340                 proxyVotingContract.proxyIncreaseWithdrawalChunk();
341                 FinishBallot(now);
342                 isVotingActive = false;
343             } else {
344                 // do nothing, just deactivate voting
345                 isVotingActive = false;
346                 FinishBallot(now);
347             }
348         }
349         
350     }
351 
352     function getTime() internal returns (uint256) {
353         // Just returns `now` value
354         // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
355         // to allow testing contract behaviour at different time moments
356         return now;
357     }
358     
359 }
360 
361 contract LockableToken is StandardToken, Ownable {
362     bool public isLocked = true;
363     mapping (address => uint256) public lastMovement;
364     event Burn(address _owner, uint256 _amount);
365 
366 
367     function unlock() public onlyOwner {
368         isLocked = false;
369     }
370 
371     function transfer(address _to, uint256 _amount) public returns (bool) {
372         require(!isLocked);
373         lastMovement[msg.sender] = getTime();
374         lastMovement[_to] = getTime();
375         return super.transfer(_to, _amount);
376     }
377 
378     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
379         require(!isLocked);
380         lastMovement[_from] = getTime();
381         lastMovement[_to] = getTime();
382         super.transferFrom(_from, _to, _value);
383     }
384 
385     function approve(address _spender, uint256 _value) public returns (bool) {
386         require(!isLocked);
387         super.approve(_spender, _value);
388     }
389 
390     function burnFrom(address _from, uint256 _value) public  returns (bool) {
391         require(_value <= balances[_from]);
392         require(_value <= allowed[_from][msg.sender]);
393         balances[_from] = balances[_from].sub(_value);
394         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
395 
396         totalSupply = totalSupply.sub(_value);
397         Burn(_from, _value);
398         return true;
399     }
400 
401     function getTime() internal returns (uint256) {
402         // Just returns `now` value
403         // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
404         // to allow testing contract behaviour at different time moments
405         return now;
406     }
407 
408     function claimTokens(address _token) public onlyOwner {
409         if (_token == 0x0) {
410             owner.transfer(this.balance);
411             return;
412         }
413     
414         ERC20Basic token = ERC20Basic(_token);
415         uint256 balance = token.balanceOf(this);
416         token.transfer(owner, balance);
417     }
418 
419 }
420 
421 contract EthearnalRepToken is MintableToken, LockableToken {
422     string public constant name = 'Ethearnal Rep Token';
423     string public constant symbol = 'ERT';
424     uint8 public constant decimals = 18;
425 }
426 
427 contract MultiOwnable {
428     mapping (address => bool) public ownerRegistry;
429     address[] owners;
430     address public multiOwnableCreator = 0x0;
431 
432     function MultiOwnable() public {
433         multiOwnableCreator = msg.sender;
434     }
435 
436     function setupOwners(address[] _owners) public {
437         // Owners are allowed to be set up only one time
438         require(multiOwnableCreator == msg.sender);
439         require(owners.length == 0);
440         for(uint256 idx=0; idx < _owners.length; idx++) {
441             require(
442                 !ownerRegistry[_owners[idx]] &&
443                 _owners[idx] != 0x0 &&
444                 _owners[idx] != address(this)
445             );
446             ownerRegistry[_owners[idx]] = true;
447         }
448         owners = _owners;
449     }
450 
451     modifier onlyOwner() {
452         require(ownerRegistry[msg.sender] == true);
453         _;
454     }
455 
456     function getOwners() public constant returns (address[]) {
457         return owners;
458     }
459 }
460 
461 contract EthearnalRepTokenCrowdsale is MultiOwnable {
462     using SafeMath for uint256;
463 
464     /* *********************
465      * Variables & Constants
466      */
467 
468     // Token Contract
469     EthearnalRepToken public token;
470 
471     // Ethereum rate, how much USD does 1 ether cost
472     // The actual value is set by setEtherRateUsd
473     uint256 etherRateUsd = 1000;
474 
475     // Token price in Usd, 1 token is 1.0 USD, 3 decimals. So, 1000 = $1.000
476     uint256 public tokenRateUsd = 1000;
477 
478     // Mainsale Start Date February 28, 2018 3:00:00 PM
479     uint256 public constant saleStartDate = 1519830000;
480 
481     // Mainsale End Date March 31, 2018 11:59:59 PM GMT
482     uint256 public constant saleEndDate = 1522540799;
483 
484     // How many tokens generate for the team, ratio with 3 decimals digits
485     uint256 public constant teamTokenRatio = uint256(1 * 1000) / 3;
486 
487     // Crowdsale State
488     enum State {
489         BeforeMainSale, // pre-sale finisehd, before main sale
490         MainSale, // main sale is active
491         MainSaleDone, // main sale done, ICO is not finalized
492         Finalized // the final state till the end of the world
493     }
494 
495     // Hard cap for total sale
496     uint256 public saleCapUsd = 30 * (10**6);
497 
498     // Money raised totally
499     uint256 public weiRaised = 0;
500 
501     // This event means everything is finished and tokens
502     // are allowed to be used by their owners
503     bool public isFinalized = false;
504 
505     // Wallet to send team tokens
506     address public teamTokenWallet = 0x0;
507 
508     // money received from each customer
509     mapping(address => uint256) public raisedByAddress;
510 
511     // whitelisted investors
512     mapping(address => bool) public whitelist;
513     // how many whitelisted investors
514     uint256 public whitelistedInvestorCounter;
515 
516 
517     // Extra money each address can spend each hour
518     uint256 hourLimitByAddressUsd = 1000;
519 
520     // Wallet to store all raised money
521     Treasury public treasuryContract = Treasury(0x0);
522 
523     /* *******
524      * Events
525      */
526     
527     event ChangeReturn(address indexed recipient, uint256 amount);
528     event TokenPurchase(address indexed buyer, uint256 weiAmount, uint256 tokenAmount);
529     /* **************
530      * Public methods
531      */
532 
533     function EthearnalRepTokenCrowdsale(
534         address[] _owners,
535         address _treasuryContract,
536         address _teamTokenWallet
537     ) {
538         require(_owners.length > 1);
539         require(_treasuryContract != address(0));
540         require(_teamTokenWallet != address(0));
541         require(Treasury(_treasuryContract).votingProxyContract() != address(0));
542         require(Treasury(_treasuryContract).tokenContract() != address(0));
543         treasuryContract = Treasury(_treasuryContract);
544         teamTokenWallet = _teamTokenWallet;
545         setupOwners(_owners);
546     }
547 
548     function() public payable {
549         if (whitelist[msg.sender]) {
550             buyForWhitelisted();
551         } else {
552             buyTokens();
553         }
554     }
555 
556     function setTokenContract(address _token) public onlyOwner {
557         require(_token != address(0) && token == address(0));
558         require(EthearnalRepToken(_token).owner() == address(this));
559         require(EthearnalRepToken(_token).totalSupply() == 0);
560         require(EthearnalRepToken(_token).isLocked());
561         require(!EthearnalRepToken(_token).mintingFinished());
562         token = EthearnalRepToken(_token);
563     }
564 
565     function buyForWhitelisted() public payable {
566         require(token != address(0));
567         address whitelistedInvestor = msg.sender;
568         require(whitelist[whitelistedInvestor]);
569         uint256 weiToBuy = msg.value;
570         require(weiToBuy > 0);
571         uint256 tokenAmount = getTokenAmountForEther(weiToBuy);
572         require(tokenAmount > 0);
573         weiRaised = weiRaised.add(weiToBuy);
574         raisedByAddress[whitelistedInvestor] = raisedByAddress[whitelistedInvestor].add(weiToBuy);
575         forwardFunds(weiToBuy);
576         assert(token.mint(whitelistedInvestor, tokenAmount));
577         TokenPurchase(whitelistedInvestor, weiToBuy, tokenAmount);
578     }
579 
580     function buyTokens() public payable {
581         require(token != address(0));
582         address recipient = msg.sender;
583         State state = getCurrentState();
584         uint256 weiToBuy = msg.value;
585         require(
586             (state == State.MainSale) &&
587             (weiToBuy > 0)
588         );
589         weiToBuy = min(weiToBuy, getWeiAllowedFromAddress(recipient));
590         require(weiToBuy > 0);
591         weiToBuy = min(weiToBuy, convertUsdToEther(saleCapUsd).sub(weiRaised));
592         require(weiToBuy > 0);
593         uint256 tokenAmount = getTokenAmountForEther(weiToBuy);
594         require(tokenAmount > 0);
595         uint256 weiToReturn = msg.value.sub(weiToBuy);
596         weiRaised = weiRaised.add(weiToBuy);
597         raisedByAddress[recipient] = raisedByAddress[recipient].add(weiToBuy);
598         if (weiToReturn > 0) {
599             recipient.transfer(weiToReturn);
600             ChangeReturn(recipient, weiToReturn);
601         }
602         forwardFunds(weiToBuy);
603         require(token.mint(recipient, tokenAmount));
604         TokenPurchase(recipient, weiToBuy, tokenAmount);
605     }
606 
607     // TEST
608     function finalizeByAdmin() public onlyOwner {
609         finalize();
610     }
611 
612     /* ****************
613      * Internal methods
614      */
615 
616     function forwardFunds(uint256 _weiToBuy) internal {
617         treasuryContract.transfer(_weiToBuy);
618     }
619 
620     // TESTED
621     function convertUsdToEther(uint256 usdAmount) constant internal returns (uint256) {
622         return usdAmount.mul(1 ether).div(etherRateUsd);
623     }
624 
625     // TESTED
626     function getTokenRateEther() public constant returns (uint256) {
627         // div(1000) because 3 decimals in tokenRateUsd
628         return convertUsdToEther(tokenRateUsd).div(1000);
629     }
630 
631     // TESTED
632     function getTokenAmountForEther(uint256 weiAmount) constant internal returns (uint256) {
633         return weiAmount
634             .div(getTokenRateEther())
635             .mul(10 ** uint256(token.decimals()));
636     }
637 
638     // TESTED
639     function isReadyToFinalize() internal returns (bool) {
640         return(
641             (weiRaised >= convertUsdToEther(saleCapUsd)) ||
642             (getCurrentState() == State.MainSaleDone)
643         );
644     }
645 
646     // TESTED
647     function min(uint256 a, uint256 b) internal returns (uint256) {
648         return (a < b) ? a: b;
649     }
650 
651     // TESTED
652     function max(uint256 a, uint256 b) internal returns (uint256) {
653         return (a > b) ? a: b;
654     }
655 
656     // TESTED
657     function ceil(uint a, uint b) internal returns (uint) {
658         return ((a.add(b).sub(1)).div(b)).mul(b);
659     }
660 
661     // TESTED
662     function getWeiAllowedFromAddress(address _sender) internal returns (uint256) {
663         uint256 secondsElapsed = getTime().sub(saleStartDate);
664         uint256 fullHours = ceil(secondsElapsed, 3600).div(3600);
665         fullHours = max(1, fullHours);
666         uint256 weiLimit = fullHours.mul(convertUsdToEther(hourLimitByAddressUsd));
667         return weiLimit.sub(raisedByAddress[_sender]);
668     }
669 
670     function getTime() internal returns (uint256) {
671         // Just returns `now` value
672         // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
673         // to allow testing contract behaviour at different time moments
674         return now;
675     }
676 
677     // TESTED
678     function getCurrentState() internal returns (State) {
679         return getStateForTime(getTime());
680     }
681 
682     // TESTED
683     function getStateForTime(uint256 unixTime) internal returns (State) {
684         if (isFinalized) {
685             // This could be before end date of ICO
686             // if hard cap is reached
687             return State.Finalized;
688         }
689         if (unixTime < saleStartDate) {
690             return State.BeforeMainSale;
691         }
692         if (unixTime < saleEndDate) {
693             return State.MainSale;
694         }
695         return State.MainSaleDone;
696     }
697 
698     // TESTED
699     function finalize() private {
700         if (!isFinalized) {
701             require(isReadyToFinalize());
702             isFinalized = true;
703             mintTeamTokens();
704             token.unlock();
705             treasuryContract.setCrowdsaleFinished();
706         }
707     }
708 
709     // TESTED
710     function mintTeamTokens() private {
711         // div by 1000 because of 3 decimals digits in teamTokenRatio
712         uint256 tokenAmount = token.totalSupply().mul(teamTokenRatio).div(1000);
713         token.mint(teamTokenWallet, tokenAmount);
714     }
715 
716 
717     function whitelistInvestor(address _newInvestor) public onlyOwner {
718         if(!whitelist[_newInvestor]) {
719             whitelist[_newInvestor] = true;
720             whitelistedInvestorCounter++;
721         }
722     }
723     function whitelistInvestors(address[] _investors) external onlyOwner {
724         require(_investors.length <= 250);
725         for(uint8 i=0; i<_investors.length;i++) {
726             address newInvestor = _investors[i];
727             if(!whitelist[newInvestor]) {
728                 whitelist[newInvestor] = true;
729                 whitelistedInvestorCounter++;
730             }
731         }
732     }
733     function blacklistInvestor(address _investor) public onlyOwner {
734         if(whitelist[_investor]) {
735             delete whitelist[_investor];
736             if(whitelistedInvestorCounter != 0) {
737                 whitelistedInvestorCounter--;
738             }
739         }
740     }
741 
742     function claimTokens(address _token, address _to) public onlyOwner {
743         if (_token == 0x0) {
744             _to.transfer(this.balance);
745             return;
746         }
747     
748         ERC20Basic token = ERC20Basic(_token);
749         uint256 balance = token.balanceOf(this);
750         token.transfer(_to, balance);
751     }
752 
753 }
754 
755 contract RefundInvestorsBallot {
756 
757     using SafeMath for uint256;
758     EthearnalRepToken public tokenContract;
759 
760     // Date when vote has started
761     uint256 public ballotStarted;
762 
763     // Registry of votes
764     mapping(address => bool) public votesByAddress;
765 
766     // Sum of weights of YES votes
767     uint256 public yesVoteSum = 0;
768 
769     // Sum of weights of NO votes
770     uint256 public noVoteSum = 0;
771 
772     // Length of `voters`
773     uint256 public votersLength = 0;
774 
775     uint256 public initialQuorumPercent = 51;
776 
777     VotingProxy public proxyVotingContract;
778 
779     // Tells if voting process is active
780     bool public isVotingActive = false;
781     uint256 public requiredMajorityPercent = 65;
782 
783     event FinishBallot(uint256 _time);
784     event Vote(address indexed sender, bytes vote);
785     
786     modifier onlyWhenBallotStarted {
787         require(ballotStarted != 0);
788         _;
789     }
790 
791     function vote(bytes _vote) public onlyWhenBallotStarted {
792         require(_vote.length > 0);
793         if (isDataYes(_vote)) {
794             processVote(true);
795         } else if (isDataNo(_vote)) {
796             processVote(false);
797         }
798         Vote(msg.sender, _vote);
799     }
800 
801     function isDataYes(bytes data) public constant returns (bool) {
802         // compare data with "YES" string
803         return (
804             data.length == 3 &&
805             (data[0] == 0x59 || data[0] == 0x79) &&
806             (data[1] == 0x45 || data[1] == 0x65) &&
807             (data[2] == 0x53 || data[2] == 0x73)
808         );
809     }
810 
811     // TESTED
812     function isDataNo(bytes data) public constant returns (bool) {
813         // compare data with "NO" string
814         return (
815             data.length == 2 &&
816             (data[0] == 0x4e || data[0] == 0x6e) &&
817             (data[1] == 0x4f || data[1] == 0x6f)
818         );
819     }
820     
821     function processVote(bool isYes) internal {
822         require(isVotingActive);
823         require(!votesByAddress[msg.sender]);
824         votersLength = votersLength.add(1);
825         uint256 voteWeight = tokenContract.balanceOf(msg.sender);
826         if (isYes) {
827             yesVoteSum = yesVoteSum.add(voteWeight);
828         } else {
829             noVoteSum = noVoteSum.add(voteWeight);
830         }
831         require(getTime().sub(tokenContract.lastMovement(msg.sender)) > 7 days);
832         uint256 quorumPercent = getQuorumPercent();
833         if (quorumPercent == 0) {
834             isVotingActive = false;
835         } else {
836             decide();
837         }
838         votesByAddress[msg.sender] = true;
839     }
840 
841     function getTime() internal returns (uint256) {
842         // Just returns `now` value
843         // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
844         // to allow testing contract behaviour at different time moments
845         return now;
846     }
847 
848     function RefundInvestorsBallot(address _tokenContract) {
849         tokenContract = EthearnalRepToken(_tokenContract);
850         proxyVotingContract = VotingProxy(msg.sender);
851         ballotStarted = getTime();
852         isVotingActive = true;
853     }
854 
855     function decide() internal {
856         uint256 quorumPercent = getQuorumPercent();
857         uint256 quorum = quorumPercent.mul(tokenContract.totalSupply()).div(100);
858         uint256 soFarVoted = yesVoteSum.add(noVoteSum);
859         if (soFarVoted >= quorum) {
860             uint256 percentYes = (100 * yesVoteSum).div(soFarVoted);
861             if (percentYes >= requiredMajorityPercent) {
862                 // does not matter if it would be greater than weiRaised
863                 proxyVotingContract.proxyEnableRefunds();
864                 FinishBallot(now);
865                 isVotingActive = false;
866             } else {
867                 // do nothing, just deactivate voting
868                 isVotingActive = false;
869             }
870         }
871     }
872     
873     function getQuorumPercent() public constant returns (uint256) {
874         uint256 isMonthPassed = getTime().sub(ballotStarted).div(5 weeks);
875         if(isMonthPassed == 1){
876             return 0;
877         }
878         return initialQuorumPercent;
879     }
880     
881 }
882 
883 contract Treasury is MultiOwnable {
884     using SafeMath for uint256;
885 
886     // Total amount of ether withdrawed
887     uint256 public weiWithdrawed = 0;
888 
889     // Total amount of ther unlocked
890     uint256 public weiUnlocked = 0;
891 
892     // Wallet withdraw is locked till end of crowdsale
893     bool public isCrowdsaleFinished = false;
894 
895     // Withdrawed team funds go to this wallet
896     address teamWallet = 0x0;
897 
898     // Crowdsale contract address
899     EthearnalRepTokenCrowdsale public crowdsaleContract;
900     EthearnalRepToken public tokenContract;
901     bool public isRefundsEnabled = false;
902 
903     // Amount of ether that could be withdrawed each withdraw iteration
904     uint256 public withdrawChunk = 0;
905     VotingProxy public votingProxyContract;
906     uint256 public refundsIssued = 0;
907     uint256 public percentLeft = 0;
908 
909 
910     event Deposit(uint256 amount);
911     event Withdraw(uint256 amount);
912     event UnlockWei(uint256 amount);
913     event RefundedInvestor(address indexed investor, uint256 amountRefunded, uint256 tokensBurn);
914 
915     function Treasury(address _teamWallet) public {
916         require(_teamWallet != 0x0);
917         // TODO: check address integrity
918         teamWallet = _teamWallet;
919     }
920 
921     // TESTED
922     function() public payable {
923         require(msg.sender == address(crowdsaleContract));
924         Deposit(msg.value);
925     }
926 
927     function setVotingProxy(address _votingProxyContract) public onlyOwner {
928         require(votingProxyContract == address(0x0));
929         votingProxyContract = VotingProxy(_votingProxyContract);
930     }
931 
932     // TESTED
933     function setCrowdsaleContract(address _address) public onlyOwner {
934         // Could be set only once
935         require(crowdsaleContract == address(0x0));
936         require(_address != 0x0);
937         crowdsaleContract = EthearnalRepTokenCrowdsale(_address); 
938     }
939 
940     function setTokenContract(address _address) public onlyOwner {
941         // Could be set only once
942         require(tokenContract == address(0x0));
943         require(_address != 0x0);
944         tokenContract = EthearnalRepToken(_address);
945     }
946 
947     // TESTED
948     function setCrowdsaleFinished() public {
949         require(crowdsaleContract != address(0x0));
950         require(msg.sender == address(crowdsaleContract));
951         withdrawChunk = getWeiRaised().div(10);
952         weiUnlocked = withdrawChunk;
953         isCrowdsaleFinished = true;
954     }
955 
956     // TESTED
957     function withdrawTeamFunds() public onlyOwner {
958         require(isCrowdsaleFinished);
959         require(weiUnlocked > weiWithdrawed);
960         uint256 toWithdraw = weiUnlocked.sub(weiWithdrawed);
961         weiWithdrawed = weiUnlocked;
962         teamWallet.transfer(toWithdraw);
963         Withdraw(toWithdraw);
964     }
965 
966     function getWeiRaised() public constant returns(uint256) {
967        return crowdsaleContract.weiRaised();
968     }
969 
970     function increaseWithdrawalChunk() {
971         require(isCrowdsaleFinished);
972         require(msg.sender == address(votingProxyContract));
973         weiUnlocked = weiUnlocked.add(withdrawChunk);
974         UnlockWei(weiUnlocked);
975     }
976 
977     function getTime() internal returns (uint256) {
978         // Just returns `now` value
979         // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
980         // to allow testing contract behaviour at different time moments
981         return now;
982     }
983 
984     function enableRefunds() public {
985         require(msg.sender == address(votingProxyContract));
986         isRefundsEnabled = true;
987     }
988     
989     function refundInvestor(uint256 _tokensToBurn) public {
990         require(isRefundsEnabled);
991         require(address(tokenContract) != address(0x0));
992         if (refundsIssued == 0) {
993             percentLeft = percentLeftFromTotalRaised().mul(100*1000).div(1 ether);
994         }
995         uint256 tokenRate = crowdsaleContract.getTokenRateEther();
996         uint256 toRefund = tokenRate.mul(_tokensToBurn).div(1 ether);
997         
998         toRefund = toRefund.mul(percentLeft).div(100*1000);
999         require(toRefund > 0);
1000         tokenContract.burnFrom(msg.sender, _tokensToBurn);
1001         msg.sender.transfer(toRefund);
1002         refundsIssued = refundsIssued.add(1);
1003         RefundedInvestor(msg.sender, toRefund, _tokensToBurn);
1004     }
1005 
1006     function percentLeftFromTotalRaised() public constant returns(uint256) {
1007         return percent(this.balance, getWeiRaised(), 18);
1008     }
1009 
1010     function percent(uint numerator, uint denominator, uint precision) internal constant returns(uint quotient) {
1011         // caution, check safe-to-multiply here
1012         uint _numerator  = numerator * 10 ** (precision+1);
1013         // with rounding of last digit
1014         uint _quotient =  ((_numerator / denominator) + 5) / 10;
1015         return ( _quotient);
1016     }
1017 
1018     function claimTokens(address _token, address _to) public onlyOwner {    
1019         ERC20Basic token = ERC20Basic(_token);
1020         uint256 balance = token.balanceOf(this);
1021         token.transfer(_to, balance);
1022     }
1023 }
1024 
1025 contract VotingProxy is Ownable {
1026     using SafeMath for uint256;    
1027     Treasury public treasuryContract;
1028     EthearnalRepToken public tokenContract;
1029     Ballot public currentIncreaseWithdrawalTeamBallot;
1030     RefundInvestorsBallot public currentRefundInvestorsBallot;
1031 
1032     function  VotingProxy(address _treasuryContract, address _tokenContract) {
1033         treasuryContract = Treasury(_treasuryContract);
1034         tokenContract = EthearnalRepToken(_tokenContract);
1035     }
1036 
1037     function startincreaseWithdrawalTeam() onlyOwner {
1038         require(treasuryContract.isCrowdsaleFinished());
1039         require(address(currentRefundInvestorsBallot) == 0x0 || currentRefundInvestorsBallot.isVotingActive() == false);
1040         if(address(currentIncreaseWithdrawalTeamBallot) == 0x0) {
1041             currentIncreaseWithdrawalTeamBallot =  new Ballot(tokenContract);
1042         } else {
1043             require(getDaysPassedSinceLastTeamFundsBallot() > 2);
1044             currentIncreaseWithdrawalTeamBallot =  new Ballot(tokenContract);
1045         }
1046     }
1047 
1048     function startRefundInvestorsBallot() public {
1049         require(treasuryContract.isCrowdsaleFinished());
1050         require(address(currentIncreaseWithdrawalTeamBallot) == 0x0 || currentIncreaseWithdrawalTeamBallot.isVotingActive() == false);
1051         if(address(currentRefundInvestorsBallot) == 0x0) {
1052             currentRefundInvestorsBallot =  new RefundInvestorsBallot(tokenContract);
1053         } else {
1054             require(getDaysPassedSinceLastRefundBallot() > 2);
1055             currentRefundInvestorsBallot =  new RefundInvestorsBallot(tokenContract);
1056         }
1057     }
1058 
1059     function getDaysPassedSinceLastRefundBallot() public constant returns(uint256) {
1060         return getTime().sub(currentRefundInvestorsBallot.ballotStarted()).div(1 days);
1061     }
1062 
1063     function getDaysPassedSinceLastTeamFundsBallot() public constant returns(uint256) {
1064         return getTime().sub(currentIncreaseWithdrawalTeamBallot.ballotStarted()).div(1 days);
1065     }
1066 
1067     function proxyIncreaseWithdrawalChunk() public {
1068         require(msg.sender == address(currentIncreaseWithdrawalTeamBallot));
1069         treasuryContract.increaseWithdrawalChunk();
1070     }
1071 
1072     function proxyEnableRefunds() public {
1073         require(msg.sender == address(currentRefundInvestorsBallot));
1074         treasuryContract.enableRefunds();
1075     }
1076 
1077     function() {
1078         revert();
1079     }
1080 
1081     function getTime() internal returns (uint256) {
1082         // Just returns `now` value
1083         // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
1084         // to allow testing contract behaviour at different time moments
1085         return now;
1086     }
1087 
1088     function claimTokens(address _token) public onlyOwner {
1089         if (_token == 0x0) {
1090             owner.transfer(this.balance);
1091             return;
1092         }
1093     
1094         ERC20Basic token = ERC20Basic(_token);
1095         uint256 balance = token.balanceOf(this);
1096         token.transfer(owner, balance);
1097     }
1098 
1099 }