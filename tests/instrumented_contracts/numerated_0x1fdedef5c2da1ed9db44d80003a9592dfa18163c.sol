1 pragma solidity ^0.4.19;
2 
3 
4 // Hedgely - v2
5 // radamosch@gmail.com
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13 
14   address public owner;
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 
48 
49 /**
50  * @title Syndicate
51  * @dev Syndicated profit sharing - for early adopters
52  * Shares are not transferable -
53  */
54 contract Syndicate is Ownable{
55 
56     uint256 public numberSyndicateMembers;
57     uint256 public totalSyndicateShares = 20000;
58     uint256 public playersShareAllocation = 5000; // 25%
59     uint256 public availableBuyInShares = 5000; // 25%
60     uint256 public minimumBuyIn = 10;
61     uint256 public buyInSharePrice = 1000000000000000; // wei = 0.001 ether
62     uint256 public shareCycleSessionSize = 1000; // number of sessions in a share cycle
63     uint256 public shareCycleIndex = 0; // current position in share cycle
64     uint256 public shareCycle = 1;
65     uint256 public currentSyndicateValue = 0; // total value of syndicate to be divided among members
66     uint256 public precision = 1000000000000000;
67 
68     // limit players/cycle to protect contract from multi-addres DOS gas attack (first 100 players on board counted)
69     // will monitor this at share distribution execution and adjust if there are gas problems due to high numbers of players.
70     uint256 public maxCyclePlayersConsidered = 100;
71 
72     address[] public cyclePlayers; // the players that have played this cycle
73     uint256 public numberOfCyclePlayers = 0;
74 
75     struct somePlayer {
76         uint256 playCount;
77         uint256 profitShare; // currently claimable profit
78         uint256 shareCycle; // represents the share cycle this player has last played
79         uint256 winnings; // current available winnings (for withdrawal)
80      }
81 
82     mapping(address => somePlayer ) private allPlayers; // all of the players
83 
84     struct member {
85         uint256 numShares;
86         uint256 profitShare;
87      }
88 
89     address[] private syndicateMembers;
90     mapping(address => member ) private members;
91 
92     event ProfitShare(
93           uint256 _currentSyndicateValue,
94           uint256 _numberSyndicateMembers,
95           uint256 _totalOwnedShares,
96           uint256 _profitPerShare
97     );
98 
99     function Syndicate() public {
100         members[msg.sender].numShares = 10000; // owner portion
101         members[msg.sender].profitShare = 0;
102         numberSyndicateMembers = 1;
103         syndicateMembers.push(msg.sender);
104     }
105 
106     // shareholder profit claim
107     function claimProfit() public {
108       if (members[msg.sender].numShares==0) revert();
109       uint256 profitShare = members[msg.sender].profitShare;
110       if (profitShare>0){
111         members[msg.sender].profitShare = 0;
112         msg.sender.transfer(profitShare);
113       }
114     }
115 
116     // player profit claim
117     function claimPlayerProfit() public {
118       if (allPlayers[msg.sender].profitShare==0) revert();
119       uint256 profitShare = allPlayers[msg.sender].profitShare;
120       if (profitShare>0){
121         allPlayers[msg.sender].profitShare = 0;
122         msg.sender.transfer(profitShare);
123       }
124     }
125 
126     // player winnings claim
127     function claimPlayerWinnings() public {
128       if (allPlayers[msg.sender].winnings==0) revert();
129       uint256 winnings = allPlayers[msg.sender].winnings;
130       if (winnings>0){
131         allPlayers[msg.sender].winnings = 0;
132         msg.sender.transfer(winnings);
133       }
134     }
135 
136     // allocate player winnings
137     function allocateWinnings(address _playerAddress, uint256 winnings) internal {
138       allPlayers[_playerAddress].winnings+=winnings;
139     }
140 
141     // utility to round to the game precision
142     function roundIt(uint256 amount) internal constant returns (uint256)
143     {
144         // round down to correct preicision
145         uint256 result = (amount/precision)*precision;
146         return result;
147     }
148 
149     // distribute profit among shareholders and players in top 10
150     function distributeProfit() internal {
151 
152       uint256 totalOwnedShares = totalSyndicateShares-(playersShareAllocation+availableBuyInShares);
153       uint256 profitPerShare = roundIt(SafeMath.div(currentSyndicateValue,totalOwnedShares));
154 
155       if (profitPerShare>0){
156           // foreach member , calculate their profitshare
157           for(uint i = 0; i< numberSyndicateMembers; i++)
158           {
159             // do += so that acrues across share cycles.
160             members[syndicateMembers[i]].profitShare+=SafeMath.mul(members[syndicateMembers[i]].numShares,profitPerShare);
161           }
162       } // end if profit for share
163 
164       uint256 topPlayerDistributableProfit =  SafeMath.div(currentSyndicateValue,4); // 25 %
165       // player profit calculation
166       uint256 numberOfRecipients = min(numberOfCyclePlayers,10); // even split among top players even if <10
167       uint256 profitPerTopPlayer = roundIt(SafeMath.div(topPlayerDistributableProfit,numberOfRecipients));
168 
169       if (profitPerTopPlayer>0){
170 
171           // begin sorting the cycle players
172           address[] memory arr = new address[](numberOfCyclePlayers);
173 
174           // copy the array to in memory - don't sort the global too expensive
175           for(i=0; i<numberOfCyclePlayers && i<maxCyclePlayersConsidered; i++) {
176             arr[i] = cyclePlayers[i];
177           }
178           address key;
179           uint j;
180           for(i = 1; i < arr.length; i++ ) {
181             key = arr[i];
182 
183             for(j = i; j > 0 && allPlayers[arr[j-1]].playCount > allPlayers[key].playCount; j-- ) {
184               arr[j] = arr[j-1];
185             }
186             arr[j] = key;
187           }  // end sorting cycle players
188 
189           //arr now contains the sorted set of addresses for distribution
190 
191           // for each of the top 10 players distribute their profit.
192           for(i = 0; i< numberOfRecipients; i++)
193           {
194             // do += so that acrues across share cycles - in case player profit is not claimed.
195             if (arr[i]!=0) { // check no null addresses
196               allPlayers[arr[i]].profitShare+=profitPerTopPlayer;
197             }
198           } // end for receipients
199 
200       } // end if profit for players
201 
202 
203       // emit a profit share event
204       ProfitShare(currentSyndicateValue, numberSyndicateMembers, totalOwnedShares , profitPerShare);
205 
206       // reset the cycle variables
207       numberOfCyclePlayers=0;
208       currentSyndicateValue=0;
209       shareCycleIndex = 1;
210       shareCycle++;
211     }
212 
213     // updates the count for this player
214     function updatePlayCount() internal{
215       // first time playing this share cycle?
216       if(allPlayers[msg.sender].shareCycle!=shareCycle){
217           allPlayers[msg.sender].playCount=0;
218           allPlayers[msg.sender].shareCycle=shareCycle;
219           insertCyclePlayer();
220       }
221         allPlayers[msg.sender].playCount++;
222         // note we don't touch profitShare or winnings because they need to roll over cycles if unclaimed
223     }
224 
225     // convenience to manage a growing array
226     function insertCyclePlayer() internal {
227         if(numberOfCyclePlayers == cyclePlayers.length) {
228             cyclePlayers.length += 1;
229         }
230         cyclePlayers[numberOfCyclePlayers++] = msg.sender;
231     }
232 
233     // add new member of syndicate
234     function addMember(address _memberAddress) internal {
235        if (members[_memberAddress].numShares == 0){
236               syndicateMembers.push(_memberAddress);
237               numberSyndicateMembers++;
238         }
239     }
240 
241     // buy into syndicate
242     function buyIntoSyndicate() public payable  {
243         if(msg.value==0 || availableBuyInShares==0) revert();
244         if(msg.value < minimumBuyIn*buyInSharePrice) revert();
245 
246         uint256 value = (msg.value/precision)*precision; // ensure precision
247         uint256 allocation = value/buyInSharePrice;
248 
249         if (allocation >= availableBuyInShares){
250             allocation = availableBuyInShares; // limit hit
251         }
252         availableBuyInShares-=allocation;
253         addMember(msg.sender); // possibly add this member to the syndicate
254         members[msg.sender].numShares+=allocation;
255     }
256 
257     // how many shares?
258     function memberShareCount() public  view returns (uint256) {
259         return members[msg.sender].numShares;
260     }
261 
262     // how much profit?
263     function memberProfitShare() public  view returns (uint256) {
264         return members[msg.sender].profitShare;
265     }
266 
267     // For previous contributors to hedgely v0.1
268     function allocateShares(uint256 allocation, address stakeholderAddress)  public onlyOwner {
269         if (allocation > availableBuyInShares) revert();
270         availableBuyInShares-=allocation;
271         addMember(stakeholderAddress); // possibly add this member to the syndicate
272         members[stakeholderAddress].numShares+=allocation;
273     }
274 
275     function setShareCycleSessionSize (uint256 size) public onlyOwner {
276         shareCycleSessionSize = size;
277     }
278 
279     function setMaxCyclePlayersConsidered (uint256 numPlayersConsidered) public onlyOwner {
280         maxCyclePlayersConsidered = numPlayersConsidered;
281     }
282 
283     // returns the status of the player
284     // note if the player share cycle!=shareCycle, then the playCount is stale - so return zero without setting it
285     function playerStatus(address _playerAddress) public constant returns(uint256, uint256, uint256, uint256) {
286          uint256 playCount = allPlayers[_playerAddress].playCount;
287          if (allPlayers[_playerAddress].shareCycle!=shareCycle){playCount=0;}
288         return (playCount, allPlayers[_playerAddress].shareCycle, allPlayers[_playerAddress].profitShare , allPlayers[_playerAddress].winnings);
289     }
290 
291     function min(uint a, uint b) private pure returns (uint) {
292            return a < b ? a : b;
293     }
294 
295 }
296 
297 
298 /**
299  * Core Hedgely Contract
300  */
301 contract Hedgely is Ownable, Syndicate {
302 
303    // Array of players
304    address[] private players;
305    mapping(address => bool) private activePlayers;
306    uint256 numPlayers = 0;
307 
308    // map each player address to their portfolio of investments
309    mapping(address => uint256 [10] ) private playerPortfolio;
310 
311    uint256[10] private marketOptions;
312 
313    // The total amount of Ether bet for this current market
314    uint256 public totalInvested;
315    // The amount of Ether used to see the market
316    uint256 private seedInvestment;
317 
318    // The total number of investments the users have made
319    uint256 public numberOfInvestments;
320 
321    // The number that won the last game
322    uint256 public numberWinner;
323 
324    // current session information
325    uint256 public startingBlock;
326    uint256 public endingBlock;
327    uint256 public sessionBlockSize;
328    uint256 public sessionNumber;
329    uint256 public currentLowest;
330    uint256 public currentLowestCount; // should count the number of currentLowest to prevent a tie
331 
332    uint256 public precision = 1000000000000000; // rounding to this will keep it to 1 finney resolution
333    uint256 public minimumStake = 1 finney;
334 
335    uint256 public winningMultiplier; // what this session will yield 5x - 8x
336 
337 
338      event Invest(
339            address _from,
340            uint256 _option,
341            uint256 _value,
342            uint256[10] _marketOptions,
343            uint _blockNumber
344      );
345 
346      event Winning(
347            address _to,
348            uint256 _amount,
349            uint256 _session,
350            uint256 _winningOption,
351            uint _blockNumber
352      );
353 
354      event EndSession(
355            address _sessionEnder,
356            uint256 _sessionNumber,
357            uint256 _winningOption,
358            uint256[10] _marketOptions,
359            uint256 _blockNumber
360      );
361 
362      event StartSession(
363            uint256 _sessionNumber,
364            uint256 _sessionBlockSize,
365            uint256[10] _marketOptions,
366            uint256 _blockNumber
367      );
368 
369 
370    function Hedgely() public {
371      owner = msg.sender;
372      sessionBlockSize = 100;
373      sessionNumber = 0;
374      numPlayers = 0;
375      resetMarket();
376    }
377 
378     // the full amount invested in each option
379    function getMarketOptions() public constant returns (uint256[10])
380     {
381         return marketOptions;
382     }
383 
384     // each player can get their own portfolio
385    function getPlayerPortfolio() public constant returns (uint256[10])
386     {
387         return playerPortfolio[msg.sender];
388     }
389 
390     // the number of investors this session
391     function numberOfInvestors() public constant returns(uint count) {
392         return numPlayers;
393     }
394 
395 
396     // pseudo random - but does that matter?
397     uint64 _seed = 0;
398     function random(uint64 upper) private returns (uint64 randomNumber) {
399        _seed = uint64(keccak256(keccak256(block.blockhash(block.number), _seed), now));
400        return _seed % upper;
401      }
402 
403     // resets the market conditions
404    function resetMarket() internal {
405 
406      // check if share cycle is complete and if required distribute profits
407      shareCycleIndex+=1;
408      if (shareCycleIndex > shareCycleSessionSize){
409        distributeProfit();
410      }
411 
412     sessionNumber ++;
413     winningMultiplier = random(3)+6; // random between 6-8 b) Proposal change
414     startingBlock = block.number;
415     endingBlock = startingBlock + sessionBlockSize; // approximately every 5 minutes - can play with this
416     numPlayers = 0;
417 
418     // randomize the initial market values
419     uint256 sumInvested = 0;
420     uint256[10] memory startingOptions;
421 
422     // player vs player optimized seeds
423     // ante up slots
424     startingOptions[0]=0;
425     startingOptions[1]=0;
426     startingOptions[2]=0;
427     startingOptions[3]=precision*(random(2)); // between 0 and 1
428     startingOptions[4]=precision*(random(3)); // between 0 and 2
429     startingOptions[5]=precision*(random(3)+1); // between 1 and 3
430     startingOptions[6]=precision*(random(2)+3); // between 3 and 4
431     startingOptions[7]=precision*(random(2)+3); // between 3 and 4
432     startingOptions[8]=precision*(random(4)+5); // between 5 and 8
433     startingOptions[9]=precision*(random(4)+5); // between 5 and 8
434 
435     // shuffle the deck
436 
437       uint64 currentIndex = uint64(marketOptions.length);
438       uint256 temporaryValue;
439       uint64 randomIndex;
440 
441       // While there remain elements to shuffle...
442       while (0 != currentIndex) {
443 
444         // Pick a remaining element...
445         randomIndex = random(currentIndex);
446         currentIndex -= 1;
447 
448         // And swap it with the current element.
449         temporaryValue = startingOptions[currentIndex];
450         startingOptions[currentIndex] = startingOptions[randomIndex];
451         startingOptions[randomIndex] = temporaryValue;
452       }
453 
454      marketOptions = startingOptions;
455      playerPortfolio[this] = marketOptions;
456      totalInvested =  sumInvested;
457      seedInvestment = sumInvested;
458      insertPlayer(this);
459      numPlayers=1;
460      numberOfInvestments = 10;
461 
462      currentLowest = findCurrentLowest();
463      StartSession(sessionNumber, sessionBlockSize, marketOptions , startingBlock);
464 
465    }
466 
467 
468     // main entry point for investors/players
469     function invest(uint256 optionNumber) public payable {
470 
471       // Check that the number is within the range (uints are always>=0 anyway)
472       assert(optionNumber <= 9);
473       uint256 amount = roundIt(msg.value); // round to precision
474       assert(amount >= minimumStake);
475 
476        // check for zero tie-breaker transaction
477        // in this case nobody wins and investment goes into next session.
478       if (block.number >= endingBlock && currentLowestCount>1 && marketOptions[currentLowest]==0){
479         endSession();
480         // auto invest them in the lowest market option  - reward for
481         optionNumber = currentLowest;
482       }
483 
484       uint256 holding = playerPortfolio[msg.sender][optionNumber];
485       holding = SafeMath.add(holding, amount);
486       playerPortfolio[msg.sender][optionNumber] = holding;
487 
488       marketOptions[optionNumber] = SafeMath.add(marketOptions[optionNumber],amount);
489 
490       numberOfInvestments += 1;
491       totalInvested += amount;
492       if (!activePlayers[msg.sender]){
493                     insertPlayer(msg.sender);
494                     activePlayers[msg.sender]=true;
495        }
496 
497       Invest(msg.sender, optionNumber, amount, marketOptions, block.number);
498       updatePlayCount(); // rank the player in leaderboard
499       currentLowest = findCurrentLowest();
500 
501       // overtime and there's a winner
502       if (block.number >= endingBlock && currentLowestCount==1){
503           // somebody wins here.
504           endSession();
505       }
506 
507     } // end invest
508 
509 
510     // find lowest option sets currentLowestCount>1 if there are more than 1 lowest
511     function findCurrentLowest() internal returns (uint lowestOption) {
512 
513       uint winner = 0;
514       uint lowestTotal = marketOptions[0];
515       currentLowestCount = 0;
516       for(uint i=0;i<10;i++)
517       {
518           if (marketOptions [i]<lowestTotal){
519               winner = i;
520               lowestTotal = marketOptions [i];
521               currentLowestCount = 0;
522           }
523          if (marketOptions [i]==lowestTotal){currentLowestCount+=1;}
524       }
525       return winner;
526     }
527 
528     // distribute winnings at the end of a session
529     function endSession() internal {
530 
531       uint256 sessionWinnings = 0;
532       if (currentLowestCount>1){
533         numberWinner = 10; // no winner
534       }else{
535         numberWinner = currentLowest;
536       }
537 
538       // record the end of session
539       for(uint j=1;j<numPlayers;j++)
540       {
541         if (numberWinner<10 && playerPortfolio[players[j]][numberWinner]>0){
542           uint256 winningAmount =  playerPortfolio[players[j]][numberWinner];
543           uint256 winnings = SafeMath.mul(winningMultiplier,winningAmount); // n times the invested amount.
544           sessionWinnings+=winnings;
545 
546           allocateWinnings(players[j],winnings); // allocate winnings
547 
548           Winning(players[j], winnings, sessionNumber, numberWinner,block.number); // we can pick this up on gui
549         }
550         playerPortfolio[players[j]] = [0,0,0,0,0,0,0,0,0,0];
551         activePlayers[players[j]]=false;
552       }
553 
554       EndSession(msg.sender, sessionNumber, numberWinner, marketOptions , block.number);
555 
556       uint256 playerInvestments = totalInvested-seedInvestment;
557 
558       if (sessionWinnings>playerInvestments){
559         uint256 loss = sessionWinnings-playerInvestments; // this is a loss
560         if (currentSyndicateValue>=loss){
561           currentSyndicateValue-=loss;
562         }else{
563           currentSyndicateValue = 0;
564         }
565       }
566 
567       if (playerInvestments>sessionWinnings){
568         currentSyndicateValue+=playerInvestments-sessionWinnings; // this is a gain
569       }
570       resetMarket();
571     } // end session
572 
573 
574     // convenience to manage a growing array
575     function insertPlayer(address value) internal {
576         if(numPlayers == players.length) {
577             players.length += 1;
578         }
579         players[numPlayers++] = value;
580     }
581 
582 
583     // ----- admin functions in event of an issue --
584     function setSessionBlockSize (uint256 blockCount) public onlyOwner {
585         sessionBlockSize = blockCount;
586     }
587 
588     function withdraw(uint256 amount) public onlyOwner {
589         require(amount<=this.balance);
590         if (amount==0){
591             amount=this.balance;
592         }
593         owner.transfer(amount);
594     }
595 
596    // In the event of catastrophe
597     function kill()  public onlyOwner {
598          if(msg.sender == owner)
599             selfdestruct(owner);
600     }
601 
602     // donations, funding, replenish
603      function() public payable {}
604 
605 }
606 
607 /**
608  * @title SafeMath
609  * @dev Math operations with safety checks that throw on error
610  */
611 library SafeMath {
612 
613   /**
614   * @dev Multiplies two numbers, throws on overflow.
615   */
616   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
617     if (a == 0) {
618       return 0;
619     }
620     uint256 c = a * b;
621     assert(c / a == b);
622     return c;
623   }
624 
625   /**
626   * @dev Integer division of two numbers, truncating the quotient.
627   */
628   function div(uint256 a, uint256 b) internal pure returns (uint256) {
629     // assert(b > 0); // Solidity automatically throws when dividing by 0
630     uint256 c = a / b;
631     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
632     return c;
633   }
634 
635   /**
636   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
637   */
638   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
639     assert(b <= a);
640     return a - b;
641   }
642 
643   /**
644   * @dev Adds two numbers, throws on overflow.
645   */
646   function add(uint256 a, uint256 b) internal pure returns (uint256) {
647     uint256 c = a + b;
648     assert(c >= a);
649     return c;
650   }
651 }