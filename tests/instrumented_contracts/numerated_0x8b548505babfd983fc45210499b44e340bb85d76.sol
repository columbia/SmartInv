1 pragma solidity ^0.4.19;
2 
3 // Hedgely - The Ethereum Inverted Market
4 // radamosch@gmail.com
5 // Contract based investment game
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
56     uint256 public totalSyndicateShares = 20000;
57     uint256 public availableEarlyPlayerShares = 5000;
58     uint256 public availableBuyInShares = 5000;
59     uint256 public minimumBuyIn = 10;
60     uint256 public buyInSharePrice = 500000000000000; // wei = 0.0005 ether
61     uint256 public shareCycleSessionSize = 1000; // number of sessions in a share cycle
62     uint256 public shareCycleIndex = 0; // current position in share cycle
63     uint256 public currentSyndicateValue = 0; // total value of syndicate to be divided among members
64     uint256 public numberSyndicateMembers = 0;
65     uint256 public syndicatePrecision = 1000000000000000;
66 
67     struct member {
68         uint256 numShares;
69         uint256 profitShare;
70      }
71 
72     address[] private syndicateMembers;
73     mapping(address => member ) private members;
74 
75     event ProfitShare(
76           uint256 _currentSyndicateValue,
77           uint256 _numberSyndicateMembers,
78           uint256 _totalOwnedShares,
79           uint256 _profitPerShare
80     );
81 
82     function Syndicate() public {
83         members[msg.sender].numShares = 10000; // owner portion
84         members[msg.sender].profitShare = 0;
85         numberSyndicateMembers = 1;
86         syndicateMembers.push(msg.sender);
87     }
88 
89     // initiates a dividend of necessary, sends
90     function claimProfit() public {
91       if (members[msg.sender].numShares==0) revert(); // only syndicate members.
92       uint256 profitShare = members[msg.sender].profitShare;
93       if (profitShare>0){
94         members[msg.sender].profitShare = 0;
95         msg.sender.transfer(profitShare);
96       }
97     }
98 
99     // distribute profit amonge syndicate members on a percentage share basis
100     function distributeProfit() internal {
101 
102       uint256 totalOwnedShares = totalSyndicateShares-(availableEarlyPlayerShares+availableBuyInShares);
103       uint256 profitPerShare = SafeMath.div(currentSyndicateValue,totalOwnedShares);
104 
105       // foreach member , calculate their profitshare
106       for(uint i = 0; i< numberSyndicateMembers; i++)
107       {
108         // do += so that acrues across share cycles.
109         members[syndicateMembers[i]].profitShare+=SafeMath.mul(members[syndicateMembers[i]].numShares,profitPerShare);
110       }
111 
112       // emit a profit share event
113       ProfitShare(currentSyndicateValue, numberSyndicateMembers, totalOwnedShares , profitPerShare);
114 
115       currentSyndicateValue=0; // all the profit has been divided up
116       shareCycleIndex = 0; // restart the share cycle count.
117     }
118 
119     // allocate syndicate shares up to the limit.
120     function allocateEarlyPlayerShare() internal {
121         if (availableEarlyPlayerShares==0) return;
122 		    availableEarlyPlayerShares--;
123        	addMember(); // possibly add this member to the syndicate
124         members[msg.sender].numShares+=1;
125 
126     }
127 
128     // add new member of syndicate
129     function addMember() internal {
130     	 if (members[msg.sender].numShares == 0){
131 		          syndicateMembers.push(msg.sender);
132 		          numberSyndicateMembers++;
133 		    }
134     }
135 
136     // buy into syndicate
137     function buyIntoSyndicate() public payable  {
138     		if(msg.value==0 || availableBuyInShares==0) revert();
139       		if(msg.value < minimumBuyIn*buyInSharePrice) revert();
140 
141      		uint256 value = (msg.value/syndicatePrecision)*syndicatePrecision; // ensure precision
142 		    uint256 allocation = value/buyInSharePrice;
143 
144 		    if (allocation >= availableBuyInShares){
145 		        allocation = availableBuyInShares; // limit hit
146 		    }
147 		    availableBuyInShares-=allocation;
148 		    addMember(); // possibly add this member to the syndicate
149 	      members[msg.sender].numShares+=allocation;
150 
151     }
152 
153     // how many shares?
154     function memberShareCount() public  view returns (uint256) {
155         return members[msg.sender].numShares;
156     }
157 
158     // how much profit?
159     function memberProfitShare() public  view returns (uint256) {
160         return members[msg.sender].profitShare;
161     }
162 
163 }
164 
165 
166 /**
167  * Core Hedgely Contract
168  */
169 contract Hedgely is Ownable, Syndicate {
170 
171    // Array of players
172    address[] private players;
173    mapping(address => bool) private activePlayers;
174    uint256 numPlayers = 0;
175 
176    // map each player address to their portfolio of investments
177    mapping(address => uint256 [10] ) private playerPortfolio;
178 
179    uint256 public totalHedgelyWinnings;
180    uint256 public totalHedgelyInvested;
181 
182    uint256[10] private marketOptions;
183 
184    // The total amount of Ether bet for this current market
185    uint256 public totalInvested;
186    // The amount of Ether used to see the market
187    uint256 private seedInvestment;
188 
189    // The total number of investments the users have made
190    uint256 public numberOfInvestments;
191 
192    // The number that won the last game
193    uint256 public numberWinner;
194 
195    // current session information
196    uint256 public startingBlock;
197    uint256 public endingBlock;
198    uint256 public sessionBlockSize;
199    uint256 public sessionNumber;
200    uint256 public currentLowest;
201    uint256 public currentLowestCount; // should count the number of currentLowest to prevent a tie
202 
203    uint256 public precision = 1000000000000000; // rounding to this will keep it to 1 finney resolution
204    uint256 public minimumStake = 1 finney;
205 
206      event Invest(
207            address _from,
208            uint256 _option,
209            uint256 _value,
210            uint256[10] _marketOptions,
211            uint _blockNumber
212      );
213 
214      event EndSession(
215            uint256 _sessionNumber,
216            uint256 _winningOption,
217            uint256[10] _marketOptions,
218            uint256 _blockNumber
219      );
220 
221      event StartSession(
222            uint256 _sessionNumber,
223            uint256 _sessionBlockSize,
224            uint256[10] _marketOptions,
225            uint256 _blockNumber
226      );
227 
228     bool locked;
229     modifier noReentrancy() {
230         require(!locked);
231         locked = true;
232         _;
233         locked = false;
234     }
235 
236    function Hedgely() public {
237      owner = msg.sender;
238      sessionBlockSize = 100;
239      sessionNumber = 0;
240      totalHedgelyWinnings = 0;
241      totalHedgelyInvested = 0;
242      numPlayers = 0;
243      resetMarket();
244    }
245 
246     // the full amount invested in each option
247    function getMarketOptions() public constant returns (uint256[10])
248     {
249         return marketOptions;
250     }
251 
252     // each player can get their own portfolio
253    function getPlayerPortfolio() public constant returns (uint256[10])
254     {
255         return playerPortfolio[msg.sender];
256     }
257 
258     // the number of investors this session
259     function numberOfInvestors() public constant returns(uint count) {
260         return numPlayers;
261     }
262 
263     // generate a random number between 1 and 20 to seed a symbol
264     function rand() internal returns (uint64) {
265       return random(19)+1;
266     }
267 
268     // pseudo random - but does that matter?
269     uint64 _seed = 0;
270     function random(uint64 upper) private returns (uint64 randomNumber) {
271        _seed = uint64(keccak256(keccak256(block.blockhash(block.number), _seed), now));
272        return _seed % upper;
273      }
274 
275     // resets the market conditions
276    function resetMarket() internal {
277 
278     sessionNumber ++;
279     startingBlock = block.number;
280     endingBlock = startingBlock + sessionBlockSize; // approximately every 5 minutes - can play with this
281     numPlayers = 0;
282 
283     // randomize the initial market values
284     uint256 sumInvested = 0;
285     for(uint i=0;i<10;i++)
286     {
287         uint256 num =  rand();
288         marketOptions[i] =num * precision; // wei
289         sumInvested+=  marketOptions[i];
290     }
291 
292      playerPortfolio[this] = marketOptions;
293      totalInvested =  sumInvested;
294      seedInvestment = sumInvested;
295      insertPlayer(this);
296      numPlayers=1;
297      numberOfInvestments = 10;
298 
299      currentLowest = findCurrentLowest();
300      StartSession(sessionNumber, sessionBlockSize, marketOptions , startingBlock);
301 
302    }
303 
304 
305     // utility to round to the game precision
306     function roundIt(uint256 amount) internal constant returns (uint256)
307     {
308         // round down to correct preicision
309         uint256 result = (amount/precision)*precision;
310         return result;
311     }
312 
313     // main entry point for investors/players
314     function invest(uint256 optionNumber) public payable noReentrancy {
315 
316       // Check that the number is within the range (uints are always>=0 anyway)
317       assert(optionNumber <= 9);
318       uint256 amount = roundIt(msg.value); // round to precision
319       assert(amount >= minimumStake);
320 
321       uint256 holding = playerPortfolio[msg.sender][optionNumber];
322       holding = SafeMath.add(holding, amount);
323       playerPortfolio[msg.sender][optionNumber] = holding;
324 
325       marketOptions[optionNumber] = SafeMath.add(marketOptions[optionNumber],amount);
326 
327       numberOfInvestments += 1;
328       totalInvested += amount;
329       totalHedgelyInvested += amount;
330       if (!activePlayers[msg.sender]){
331                     insertPlayer(msg.sender);
332                     activePlayers[msg.sender]=true;
333        }
334 
335       Invest(msg.sender, optionNumber, amount, marketOptions, block.number);
336 
337       // possibly allocate syndicate shares
338       allocateEarlyPlayerShare(); // allocate a single share per investment for early adopters
339 
340       currentLowest = findCurrentLowest();
341       if (block.number >= endingBlock && currentLowestCount==1) distributeWinnings();
342 
343     } // end invest
344 
345 
346     // find lowest option sets currentLowestCount>1 if there are more than 1 lowest
347     function findCurrentLowest() internal returns (uint lowestOption) {
348 
349       uint winner = 0;
350       uint lowestTotal = marketOptions[0];
351       currentLowestCount = 0;
352       for(uint i=0;i<10;i++)
353       {
354           if (marketOptions [i]<lowestTotal){
355               winner = i;
356               lowestTotal = marketOptions [i];
357               currentLowestCount = 0;
358           }
359          if (marketOptions [i]==lowestTotal){currentLowestCount+=1;}
360       }
361       return winner;
362     }
363 
364     // distribute winnings at the end of a session
365     function distributeWinnings() internal {
366 
367       if (currentLowestCount>1){
368       return; // cannot end session because there is no lowest.
369       }
370 
371       numberWinner = currentLowest;
372 
373       // record the end of session
374       EndSession(sessionNumber, numberWinner, marketOptions , block.number);
375 
376       uint256 sessionWinnings = 0;
377       for(uint j=1;j<numPlayers;j++)
378       {
379       if (playerPortfolio[players[j]][numberWinner]>0){
380         uint256 winningAmount =  playerPortfolio[players[j]][numberWinner];
381         uint256 winnings = SafeMath.mul(8,winningAmount); // eight times the invested amount.
382         totalHedgelyWinnings+=winnings;
383         sessionWinnings+=winnings;
384         players[j].transfer(winnings); // don't throw here
385       }
386 
387       playerPortfolio[players[j]] = [0,0,0,0,0,0,0,0,0,0];
388       activePlayers[players[j]]=false;
389 
390       }
391 
392       uint256 playerInvestments = totalInvested-seedInvestment;
393 
394       if (sessionWinnings>playerInvestments){
395         uint256 loss = sessionWinnings-playerInvestments; // this is a loss
396         if (currentSyndicateValue>=loss){
397           currentSyndicateValue-=loss;
398         }else{
399           currentSyndicateValue = 0;
400         }
401       }
402 
403       if (playerInvestments>sessionWinnings){
404         currentSyndicateValue+=playerInvestments-sessionWinnings; // this is a gain
405       }
406 
407       // check if share cycle is complete and if required distribute profits
408       shareCycleIndex+=1;
409       if (shareCycleIndex >= shareCycleSessionSize){
410         distributeProfit();
411       }
412 
413       resetMarket();
414     } // end distribute winnings
415 
416 
417     // convenience to manage a growing array
418     function insertPlayer(address value) internal {
419         if(numPlayers == players.length) {
420             players.length += 1;
421         }
422         players[numPlayers++] = value;
423     }
424 
425    // We might vary this at some point
426     function setsessionBlockSize (uint256 blockCount) public onlyOwner {
427         sessionBlockSize = blockCount;
428     }
429 
430     // ----- admin functions in event of an issue --
431 
432     function withdraw(uint256 amount) public onlyOwner {
433         require(amount<=this.balance);
434         if (amount==0){
435             amount=this.balance;
436         }
437         owner.transfer(amount);
438     }
439 
440 
441    // In the event of catastrophe
442     function kill()  public onlyOwner {
443          if(msg.sender == owner)
444             selfdestruct(owner);
445     }
446 
447     // donations, funding, replenish
448      function() public payable {}
449 
450 
451 }
452 
453 /**
454  * @title SafeMath
455  * @dev Math operations with safety checks that throw on error
456  */
457 library SafeMath {
458 
459   /**
460   * @dev Multiplies two numbers, throws on overflow.
461   */
462   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
463     if (a == 0) {
464       return 0;
465     }
466     uint256 c = a * b;
467     assert(c / a == b);
468     return c;
469   }
470 
471   /**
472   * @dev Integer division of two numbers, truncating the quotient.
473   */
474   function div(uint256 a, uint256 b) internal pure returns (uint256) {
475     // assert(b > 0); // Solidity automatically throws when dividing by 0
476     uint256 c = a / b;
477     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
478     return c;
479   }
480 
481   /**
482   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
483   */
484   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
485     assert(b <= a);
486     return a - b;
487   }
488 
489   /**
490   * @dev Adds two numbers, throws on overflow.
491   */
492   function add(uint256 a, uint256 b) internal pure returns (uint256) {
493     uint256 c = a + b;
494     assert(c >= a);
495     return c;
496   }
497 }