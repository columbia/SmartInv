1 pragma solidity ^0.4.19;
2 
3 
4 // Hedgely - v3
5 // radamosch@gmail.com
6 // https://hedgely.net
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14 
15   address public owner;
16 
17   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 
46 }
47 
48 
49 
50 /**
51  * Core Hedgely Contract
52  */
53 contract Hedgely is Ownable {
54 
55     uint256 public numberSyndicateMembers;
56     uint256 public totalSyndicateShares = 20000;
57     uint256 public playersShareAllocation = 5000; // 25%
58     uint256 public availableBuyInShares = 5000; // 25%
59     uint256 public minimumBuyIn = 10;
60     uint256 public buyInSharePrice = 1000000000000000; // wei = 0.001 ether
61     uint256 public shareCycleSessionSize = 1000; // number of sessions in a share cycle
62     uint256 public shareCycleIndex = 0; // current position in share cycle
63     uint256 public shareCycle = 1;
64     uint256 public currentSyndicateValue = 150000000000000000; // total value of syndicate to be divided among members
65 
66     // limit players/cycle to protect contract from multi-addres DOS gas attack (first 100 players on board counted)
67     // will monitor this at share distribution execution and adjust if there are gas problems due to high numbers of players.
68     uint256 public maxCyclePlayersConsidered = 100;
69 
70     address[] public cyclePlayers; // the players that have played this cycle
71     uint256 public numberOfCyclePlayers = 0;
72 
73     struct somePlayer {
74         uint256 playCount;
75         uint256 profitShare; // currently claimable profit
76         uint256 shareCycle; // represents the share cycle this player has last played
77         uint256 winnings; // current available winnings (for withdrawal)
78      }
79 
80     mapping(address => somePlayer ) private allPlayers; // all of the players
81 
82     struct member {
83         uint256 numShares;
84         uint256 profitShare;
85      }
86 
87     address[] private syndicateMembers;
88     mapping(address => member ) private members;
89 
90     event ProfitShare(
91           uint256 _currentSyndicateValue,
92           uint256 _numberSyndicateMembers,
93           uint256 _totalOwnedShares,
94           uint256 _profitPerShare
95     );
96 
97     event Invest(
98           address _from,
99           uint256 _option,
100           uint256 _value,
101           uint256[10] _marketOptions,
102           uint _blockNumber
103     );
104 
105     event Winning(
106           address _to,
107           uint256 _amount,
108           uint256 _session,
109           uint256 _winningOption,
110           uint _blockNumber
111     );
112 
113     event EndSession(
114           address _sessionEnder,
115           uint256 _sessionNumber,
116           uint256 _winningOption,
117           uint256[10] _marketOptions,
118           uint256 _blockNumber
119     );
120 
121     event StartSession(
122           uint256 _sessionNumber,
123           uint256 _sessionEndTime,
124           uint256[10] _marketOptions,
125           uint256 _blockNumber
126     );
127 
128 
129     // shareholder profit claim
130     function claimProfit() public {
131       if (members[msg.sender].numShares==0) revert();
132       uint256 profitShare = members[msg.sender].profitShare;
133       if (profitShare>0){
134         members[msg.sender].profitShare = 0;
135         msg.sender.transfer(profitShare);
136       }
137     }
138 
139     // player profit claim
140     function claimPlayerProfit() public {
141       if (allPlayers[msg.sender].profitShare==0) revert();
142       uint256 profitShare = allPlayers[msg.sender].profitShare;
143       if (profitShare>0){
144         allPlayers[msg.sender].profitShare = 0;
145         msg.sender.transfer(profitShare);
146       }
147     }
148 
149     // player winnings claim
150     function claimPlayerWinnings() public {
151       if (allPlayers[msg.sender].winnings==0) revert();
152       uint256 winnings = allPlayers[msg.sender].winnings;
153 
154       if (now > sessionEndTime && playerPortfolio[msg.sender][currentLowest]>0){
155           // session has ended, this player may have winnings not yet allocated, but they should show up
156          winnings+= SafeMath.mul(playerPortfolio[msg.sender][currentLowest],winningMultiplier);
157          playerPortfolio[msg.sender][currentLowest]=0;
158       }
159 
160       if (winnings>0){
161         allPlayers[msg.sender].winnings = 0;
162         msg.sender.transfer(winnings);
163       }
164     }
165 
166     // allocate player winnings
167     function allocateWinnings(address _playerAddress, uint256 winnings) internal {
168       allPlayers[_playerAddress].winnings+=winnings;
169     }
170 
171     // utility to round to the game precision
172     function roundIt(uint256 amount) internal constant returns (uint256)
173     {
174         // round down to correct preicision
175         uint256 result = (amount/precision)*precision;
176         return result;
177     }
178 
179     // distribute profit among shareholders and players in top 10
180     function distributeProfit() internal {
181 
182       uint256 totalOwnedShares = totalSyndicateShares-(playersShareAllocation+availableBuyInShares);
183       uint256 profitPerShare = SafeMath.div(currentSyndicateValue,totalOwnedShares);
184 
185       if (profitPerShare>0){
186           // foreach member , calculate their profitshare
187           for(uint i = 0; i< numberSyndicateMembers; i++)
188           {
189             // do += so that acrues across share cycles.
190             members[syndicateMembers[i]].profitShare+=SafeMath.mul(members[syndicateMembers[i]].numShares,profitPerShare);
191           }
192       } // end if profit for share
193 
194       uint256 topPlayerDistributableProfit =  SafeMath.div(currentSyndicateValue,4); // 25 %
195       // player profit calculation
196       uint256 numberOfRecipients = min(numberOfCyclePlayers,10); // even split among top players even if <10
197       uint256 profitPerTopPlayer = roundIt(SafeMath.div(topPlayerDistributableProfit,numberOfRecipients));
198 
199       if (profitPerTopPlayer>0){
200 
201           // begin sorting the cycle players
202           address[] memory arr = new address[](numberOfCyclePlayers);
203 
204           // copy the array to in memory - don't sort the global too expensive
205           for(i=0; i<numberOfCyclePlayers && i<maxCyclePlayersConsidered; i++) {
206             arr[i] = cyclePlayers[i];
207           }
208           address key;
209           uint j;
210           for(i = 1; i < arr.length; i++ ) {
211             key = arr[i];
212 
213             for(j = i; j > 0 && allPlayers[arr[j-1]].playCount > allPlayers[key].playCount; j-- ) {
214               arr[j] = arr[j-1];
215             }
216             arr[j] = key;
217           }  // end sorting cycle players
218 
219           //arr now contains the sorted set of addresses for distribution
220 
221           // for each of the top 10 players distribute their profit.
222           for(i = 0; i< numberOfRecipients; i++)
223           {
224             // do += so that acrues across share cycles - in case player profit is not claimed.
225             if (arr[i]!=0) { // check no null addresses
226               allPlayers[arr[i]].profitShare+=profitPerTopPlayer;
227             }
228           } // end for receipients
229 
230       } // end if profit for players
231 
232 
233       // emit a profit share event
234       ProfitShare(currentSyndicateValue, numberSyndicateMembers, totalOwnedShares , profitPerShare);
235 
236       // reset the cycle variables
237       numberOfCyclePlayers=0;
238       currentSyndicateValue=0;
239       shareCycleIndex = 1;
240       shareCycle++;
241     }
242 
243     // updates the count for this player
244     function updatePlayCount() internal{
245       // first time playing this share cycle?
246       if(allPlayers[msg.sender].shareCycle!=shareCycle){
247           allPlayers[msg.sender].playCount=0;
248           allPlayers[msg.sender].shareCycle=shareCycle;
249           insertCyclePlayer();
250       }
251         allPlayers[msg.sender].playCount++;
252         // note we don't touch profitShare or winnings because they need to roll over cycles if unclaimed
253     }
254 
255     // convenience to manage a growing array
256     function insertCyclePlayer() internal {
257         if(numberOfCyclePlayers == cyclePlayers.length) {
258             cyclePlayers.length += 1;
259         }
260         cyclePlayers[numberOfCyclePlayers++] = msg.sender;
261     }
262 
263     // add new member of syndicate
264     function addMember(address _memberAddress) internal {
265        if (members[_memberAddress].numShares == 0){
266               syndicateMembers.push(_memberAddress);
267               numberSyndicateMembers++;
268         }
269     }
270 
271     // buy into syndicate
272     function buyIntoSyndicate() public payable  {
273         if(msg.value==0 || availableBuyInShares==0) revert();
274         if(msg.value < minimumBuyIn*buyInSharePrice) revert();
275 
276         uint256 value = (msg.value/precision)*precision; // ensure precision
277         uint256 allocation = value/buyInSharePrice;
278 
279         if (allocation >= availableBuyInShares){
280             allocation = availableBuyInShares; // limit hit
281         }
282         availableBuyInShares-=allocation;
283         addMember(msg.sender); // possibly add this member to the syndicate
284         members[msg.sender].numShares+=allocation;
285     }
286 
287     // how many shares?
288     function memberShareCount() public  view returns (uint256) {
289         return members[msg.sender].numShares;
290     }
291 
292     // how much profit?
293     function memberProfitShare() public  view returns (uint256) {
294         return members[msg.sender].profitShare;
295     }
296 
297     // For previous contributors to hedgely v0.1
298     function allocateShares(uint256 allocation, address stakeholderAddress)  public onlyOwner {
299         if (allocation > availableBuyInShares) revert();
300         availableBuyInShares-=allocation;
301         addMember(stakeholderAddress); // possibly add this member to the syndicate
302         members[stakeholderAddress].numShares+=allocation;
303     }
304 
305     function setShareCycleSessionSize (uint256 size) public onlyOwner {
306         shareCycleSessionSize = size;
307     }
308 
309     function setMaxCyclePlayersConsidered (uint256 numPlayersConsidered) public onlyOwner {
310         maxCyclePlayersConsidered = numPlayersConsidered;
311     }
312 
313     // returns the status of the player
314     // note if the player share cycle!=shareCycle, then the playCount is stale - so return zero without setting it
315     function playerStatus(address _playerAddress) public constant returns(uint256, uint256, uint256, uint256) {
316          uint256 playCount = allPlayers[_playerAddress].playCount;
317          if (allPlayers[_playerAddress].shareCycle!=shareCycle){playCount=0;}
318          uint256 winnings = allPlayers[_playerAddress].winnings;
319            if (now >sessionEndTime){
320              // session has ended, this player may have winnings not yet allocated, but they should show up
321               winnings+=  SafeMath.mul(playerPortfolio[_playerAddress][currentLowest],winningMultiplier);
322            }
323         return (playCount, allPlayers[_playerAddress].shareCycle, allPlayers[_playerAddress].profitShare , winnings);
324     }
325 
326     function min(uint a, uint b) private pure returns (uint) {
327            return a < b ? a : b;
328     }
329 
330 
331    // Array of players
332    address[] private players;
333    mapping(address => bool) private activePlayers;
334    uint256 numPlayers = 0;
335 
336    // map each player address to their portfolio of investments
337    mapping(address => uint256 [10] ) private playerPortfolio;
338 
339    uint256[10] private marketOptions;
340 
341    // The total amount of Ether bet for this current market
342    uint256 public totalInvested;
343    // The amount of Ether used to see the market
344    uint256 private seedInvestment;
345 
346    // The total number of investments the users have made
347    uint256 public numberOfInvestments;
348 
349    // The number that won the last game
350    uint256 public numberWinner;
351 
352    // current session information
353    uint256 public sessionNumber;
354    uint256 public currentLowest;
355    uint256 public currentLowestCount; // should count the number of currentLowest to prevent a tie
356 
357    uint256 public precision = 1000000000000000; // rounding to this will keep it to 1 finney resolution
358    uint256 public minimumStake = 1 finney;
359 
360    uint256 public winningMultiplier; // what this session will yield 5x - 8x
361 
362    uint256 public sessionDuration = 20 minutes;
363    uint256 public sessionEndTime = 0;
364 
365    function Hedgely() public {
366      owner = msg.sender;
367      members[msg.sender].numShares = 10000; // owner portion
368      members[msg.sender].profitShare = 0;
369      numberSyndicateMembers = 1;
370      syndicateMembers.push(msg.sender);
371      sessionNumber = 0;
372      numPlayers = 0;
373      resetMarket();
374    }
375 
376     // the full amount invested in each option
377    function getMarketOptions() public constant returns (uint256[10])
378     {
379         return marketOptions;
380     }
381 
382     // each player can get their own portfolio
383    function getPlayerPortfolio() public constant returns (uint256[10])
384     {
385         return playerPortfolio[msg.sender];
386     }
387 
388     // the number of investors this session
389     function numberOfInvestors() public constant returns(uint count) {
390         return numPlayers;
391     }
392 
393 
394     // pseudo random - but does that matter?
395     uint64 _seed = 0;
396     function random(uint64 upper) private returns (uint64 randomNumber) {
397        _seed = uint64(keccak256(keccak256(block.blockhash(block.number), _seed), now));
398        return _seed % upper;
399      }
400 
401     // resets the market conditions
402    function resetMarket() internal {
403 
404      // check if share cycle is complete and if required distribute profits
405      shareCycleIndex+=1;
406      if (shareCycleIndex > shareCycleSessionSize){
407        distributeProfit();
408      }
409 
410     sessionNumber ++;
411     winningMultiplier = 8; // always 8 better incentive to play
412     numPlayers = 0;
413 
414     // randomize the initial market values
415     uint256 sumInvested = 0;
416     uint256[10] memory startingOptions;
417 
418     // player vs player optimized seeds
419     // ante up slots
420     startingOptions[0]=0;
421     startingOptions[1]=0;
422     startingOptions[2]=0;
423     startingOptions[3]=precision*(random(2)); // between 0 and 1
424     startingOptions[4]=precision*(random(3)+1); // between 1 and 3
425     startingOptions[5]=precision*(random(2)+3); // between 3 and 4
426     startingOptions[6]=precision*(random(3)+4); // between 4 and 6
427     startingOptions[7]=precision*(random(3)+5); // between 5 and 7
428     startingOptions[8]=precision*(random(3)+8); // between 8 and 10
429     startingOptions[9]=precision*(random(3)+8); // between 8 and 10
430 
431     // shuffle the deck
432 
433       uint64 currentIndex = uint64(marketOptions.length);
434       uint256 temporaryValue;
435       uint64 randomIndex;
436 
437       // While there remain elements to shuffle...
438       while (0 != currentIndex) {
439 
440         // Pick a remaining element...
441         randomIndex = random(currentIndex);
442         currentIndex -= 1;
443 
444         // And swap it with the current element.
445         temporaryValue = startingOptions[currentIndex];
446         startingOptions[currentIndex] = startingOptions[randomIndex];
447         startingOptions[randomIndex] = temporaryValue;
448       }
449 
450      marketOptions = startingOptions;
451      playerPortfolio[this] = marketOptions;
452      totalInvested =  sumInvested;
453      seedInvestment = sumInvested;
454      insertPlayer(this);
455      numPlayers=1;
456      numberOfInvestments = 10;
457 
458      currentLowest = findCurrentLowest();
459      sessionEndTime = now + sessionDuration;
460      StartSession(sessionNumber, sessionEndTime, marketOptions , now);
461 
462    }
463 
464 
465     // main entry point for investors/players
466     function invest(uint256 optionNumber) public payable {
467 
468       // Check that the number is within the range (uints are always>=0 anyway)
469       assert(optionNumber <= 9);
470       uint256 amount = roundIt(msg.value); // round to precision
471       assert(amount >= minimumStake);
472 
473        // is this a new session starting?
474       if (now> sessionEndTime){
475         endSession();
476         // auto invest them in the lowest market option (only fair, they missed transaction or hit start button)
477         optionNumber = currentLowest;
478       }
479 
480       uint256 holding = playerPortfolio[msg.sender][optionNumber];
481       holding = SafeMath.add(holding, amount);
482       playerPortfolio[msg.sender][optionNumber] = holding;
483 
484       marketOptions[optionNumber] = SafeMath.add(marketOptions[optionNumber],amount);
485 
486       numberOfInvestments += 1;
487       totalInvested += amount;
488       if (!activePlayers[msg.sender]){
489                     insertPlayer(msg.sender);
490                     activePlayers[msg.sender]=true;
491        }
492 
493       Invest(msg.sender, optionNumber, amount, marketOptions, block.number);
494       updatePlayCount(); // rank the player in leaderboard
495       currentLowest = findCurrentLowest();
496 
497     } // end invest
498 
499 
500     // find lowest option sets currentLowestCount>1 if there are more than 1 lowest
501     function findCurrentLowest() internal returns (uint lowestOption) {
502 
503       uint winner = 0;
504       uint lowestTotal = marketOptions[0];
505       currentLowestCount = 0;
506       for(uint i=0;i<10;i++)
507       {
508           if (marketOptions [i]<lowestTotal){
509               winner = i;
510               lowestTotal = marketOptions [i];
511               currentLowestCount = 0;
512           }
513          if (marketOptions [i]==lowestTotal){currentLowestCount+=1;}
514       }
515       return winner;
516     }
517 
518     // distribute winnings at the end of a session
519     function endSession() internal {
520 
521       uint256 sessionWinnings = 0;
522       if (currentLowestCount>1){
523         numberWinner = 10; // no winner
524       }else{
525         numberWinner = currentLowest;
526       }
527 
528       // record the end of session
529       for(uint j=1;j<numPlayers;j++)
530       {
531         if (numberWinner<10 && playerPortfolio[players[j]][numberWinner]>0){
532           uint256 winningAmount =  playerPortfolio[players[j]][numberWinner];
533           uint256 winnings = SafeMath.mul(winningMultiplier,winningAmount); // n times the invested amount.
534           sessionWinnings+=winnings;
535 
536           allocateWinnings(players[j],winnings); // allocate winnings
537 
538           Winning(players[j], winnings, sessionNumber, numberWinner,block.number); // we can pick this up on gui
539         }
540         playerPortfolio[players[j]] = [0,0,0,0,0,0,0,0,0,0];
541         activePlayers[players[j]]=false;
542       }
543 
544       EndSession(msg.sender, sessionNumber, numberWinner, marketOptions , block.number);
545 
546       uint256 playerInvestments = totalInvested-seedInvestment;
547 
548       if (sessionWinnings>playerInvestments){
549         uint256 loss = sessionWinnings-playerInvestments; // this is a loss
550         if (currentSyndicateValue>=loss){
551           currentSyndicateValue-=loss;
552         }else{
553           currentSyndicateValue = 0;
554         }
555       }
556 
557       if (playerInvestments>sessionWinnings){
558         currentSyndicateValue+=playerInvestments-sessionWinnings; // this is a gain
559       }
560       resetMarket();
561     } // end session
562 
563 
564     // convenience to manage a growing array
565     function insertPlayer(address value) internal {
566         if(numPlayers == players.length) {
567             players.length += 1;
568         }
569         players[numPlayers++] = value;
570     }
571 
572 
573     // ----- admin functions in event of an issue --
574     function setSessionDurationMinutes (uint256 _m) public onlyOwner {
575         sessionDuration = _m * 1 minutes ;
576     }
577 
578     function withdraw(uint256 amount) public onlyOwner {
579         require(amount<=this.balance);
580         if (amount==0){
581             amount=this.balance;
582         }
583         owner.transfer(amount);
584     }
585 
586    // In the event of catastrophe
587     function kill()  public onlyOwner {
588          if(msg.sender == owner)
589             selfdestruct(owner);
590     }
591 
592     // donations, funding, replenish
593      function() public payable {}
594 
595 }
596 
597 /**
598  * @title SafeMath
599  * @dev Math operations with safety checks that throw on error
600  */
601 library SafeMath {
602 
603   /**
604   * @dev Multiplies two numbers, throws on overflow.
605   */
606   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
607     if (a == 0) {
608       return 0;
609     }
610     uint256 c = a * b;
611     assert(c / a == b);
612     return c;
613   }
614 
615   /**
616   * @dev Integer division of two numbers, truncating the quotient.
617   */
618   function div(uint256 a, uint256 b) internal pure returns (uint256) {
619     // assert(b > 0); // Solidity automatically throws when dividing by 0
620     uint256 c = a / b;
621     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
622     return c;
623   }
624 
625   /**
626   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
627   */
628   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
629     assert(b <= a);
630     return a - b;
631   }
632 
633   /**
634   * @dev Adds two numbers, throws on overflow.
635   */
636   function add(uint256 a, uint256 b) internal pure returns (uint256) {
637     uint256 c = a + b;
638     assert(c >= a);
639     return c;
640   }
641 }