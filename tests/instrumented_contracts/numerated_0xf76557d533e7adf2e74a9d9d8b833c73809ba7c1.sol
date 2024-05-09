1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two numbers, throws on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     /**
17     * @dev Integer division of two numbers, truncating the quotient.
18     */
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     /**
27     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28     */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     /**
35     * @dev Adds two numbers, throws on overflow.
36     */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 contract CryptoCupVirtualMatch {
45 
46     // evsoftware.co.uk
47     // cryptocup.online
48 
49     /*****------ EVENTS -----*****/
50     event MatchCreated(uint256 indexed id, uint256 playerEntryPrice, uint256 homeTeam, uint256 awayTeam, uint256 kickOff, uint256 fullTime);
51     event MatchFinished(uint256 indexed id, uint256 homeTeam, uint256 awayTeam, uint256 winningTeam, uint256 teamAllocation);
52     event PlayerJoined(uint256 indexed id, uint256 team, string playerName, address account);
53     event TeamOwnerPaid(uint256 indexed id, uint256 amount);
54 
55     /*****------- STORAGE -------******/
56     CryptoCupToken cryptoCupTokenContract;
57     address public contractModifierAddress;
58     address public developerAddress;
59     mapping (uint256 => Match) public matches;
60     mapping (address => Player) public players;
61     mapping (uint256 => Team) public teams;
62     uint256 private developerBalance;
63     bool private allowInPlayJoining = true;
64     bool private allowPublicMatches = true;
65     uint256 private entryPrice = 0.05 ether; 
66     uint256 private startInSeconds = 300;
67     uint256 private durationInSeconds = 120;
68     uint256 private dataVisibleWindow = 21600; // Initial 6 hours
69     uint256 private matchCounter;
70     uint256 private playerCounter;
71     uint256 private teamCounter;
72     bool private commentating = false;
73     
74     /*****------- DATATYPES -------******/
75     struct Match {
76         uint256 id;
77         uint256 playerEntryPrice;
78         uint256 homeTeam;
79         mapping (uint256 => Player) homeTeamPlayers;
80         uint256 homeTeamPlayersCount;
81         uint256 awayTeam;
82         mapping (uint256 => Player) awayTeamPlayers;
83         uint256 awayTeamPlayersCount;
84         uint256 kickOff;
85         uint256 fullTime;
86         uint256 prize;
87         uint256 homeScore;
88         uint256 awayScore;
89         uint256 winningTeam;
90         uint256 winningTeamBonus;
91         bool reported;
92     }
93 
94     struct Player {
95         uint256 id;
96         string name;
97         address account;
98         uint256 balance;
99     }
100     
101     struct Team {
102         uint256 id;
103         address owner;
104         uint256 balance;
105         bool init;
106     }
107 
108     /*****------- MODIFIERS -------******/
109     modifier onlyContractModifier() {
110         require(msg.sender == contractModifierAddress);
111         _;
112     }
113     
114     /*****------- CONSTRUCTOR -------******/
115     constructor() public {
116         contractModifierAddress = msg.sender;
117         developerAddress = msg.sender;
118     }
119 
120 	function destroy() public onlyContractModifier {
121 		selfdestruct(contractModifierAddress);
122     }
123 
124     function setDeveloper(address _newDeveloperAddress) public onlyContractModifier {
125         require(_newDeveloperAddress != address(0));
126         developerAddress = _newDeveloperAddress;
127     }
128 
129     function setCryptoCupTokenContractAddress(address _cryptoCupTokenAddress) public onlyContractModifier {
130         cryptoCupTokenContract = CryptoCupToken(_cryptoCupTokenAddress);
131     }
132     
133     function togglePublicMatches() public onlyContractModifier {
134         // If we find an issue with people creating matches
135         allowPublicMatches = !allowPublicMatches;
136     }
137     
138     function toggleInPlayJoining() public onlyContractModifier {
139         // If we find an issue with people trying to join games that are in progress, we can change the logic to not allow this and they can only join before a game starts
140         allowInPlayJoining = !allowInPlayJoining;
141     }
142     
143     function toggleMatchStartEnd(uint256 _startInSeconds, uint256 _durationInSeconds) public onlyContractModifier {
144         startInSeconds = _startInSeconds;
145         durationInSeconds = _durationInSeconds;
146     }
147     
148     function toggleDataViewWindow(uint256 _periodInSeconds) public onlyContractModifier {
149         dataVisibleWindow = _periodInSeconds;
150     }
151 
152     function doubleEntryPrice() public onlyContractModifier {
153         // May want to ramp up during knockouts
154         entryPrice = SafeMath.mul(entryPrice,2);
155     }
156     
157     function halveEntryPrice() public onlyContractModifier {
158         // Ability to ramp down
159         entryPrice = SafeMath.div(entryPrice,2);
160     }
161     
162     function developerPrizeClaim() public onlyContractModifier {
163         developerAddress.transfer(developerBalance);
164         developerBalance = 0;
165     }
166     
167     function getBalance()  public constant returns(uint256) {
168         return address(this).balance;
169     }
170     
171     function getTotalMatches() public constant returns(uint256) {
172         return matchCounter;
173     }
174     
175     function getTotalPlayers() public constant returns(uint256) {
176         return playerCounter;
177     }
178     
179     function getCryptoCupTokenContractAddress() public view returns (address contractAddress) {
180         return cryptoCupTokenContract;
181     }
182     
183     function getTeamOwner(uint256 _tokenId) public view returns(address owner)
184     {
185         owner = cryptoCupTokenContract.ownerOf(_tokenId);
186     }
187 
188     function getEntryPrice() public constant returns(uint256) {
189         return entryPrice;
190     }
191     
192     function createPlayerMatch(uint256 _homeTeam, uint256 _awayTeam, uint256 _entryPrice, uint256 _startInSecondsTime, uint256 _matchDuration) public {
193         require(allowPublicMatches);
194         require(_homeTeam != _awayTeam);
195         require(_homeTeam < 32 && _awayTeam < 32);
196         require(_entryPrice >= entryPrice);
197         require(_startInSecondsTime > 0);
198         require(_matchDuration >= durationInSeconds);
199         
200         // Does home team exist?
201         if (!teams[_homeTeam].init) {
202             teams[_homeTeam] = Team(_homeTeam, cryptoCupTokenContract.ownerOf(_homeTeam), 0, true);
203         }
204         
205         // Does away team exist?
206         if (!teams[_awayTeam].init) {
207             teams[_awayTeam] = Team(_awayTeam, cryptoCupTokenContract.ownerOf(_awayTeam), 0, true);
208         }
209         
210         // Does the user own one of these teams?
211         require(teams[_homeTeam].owner == msg.sender || teams[_awayTeam].owner == msg.sender);
212 
213         uint256 _kickOff = now + _startInSecondsTime;
214         uint256 _fullTime = _kickOff + _matchDuration;
215         matchCounter++;
216         matches[matchCounter] = Match(matchCounter, _entryPrice, _homeTeam, 0, _awayTeam, 0, _kickOff, _fullTime, 0, 0, 0, 0, 0, false);
217         emit MatchCreated(matchCounter, entryPrice, _homeTeam, _awayTeam, _kickOff, _fullTime);
218     }
219 
220     function createMatch(uint256 _homeTeam, uint256 _awayTeam) public onlyContractModifier {
221         require(_homeTeam != _awayTeam);
222         
223         // Does home team exist?
224         if (!teams[_homeTeam].init) {
225             teams[_homeTeam] = Team(_homeTeam, cryptoCupTokenContract.ownerOf(_homeTeam), 0, true);
226         }
227         
228         // Does away team exist?
229         if (!teams[_awayTeam].init) {
230             teams[_awayTeam] = Team(_awayTeam, cryptoCupTokenContract.ownerOf(_awayTeam), 0, true);
231         }
232         
233         // match starts in five mins, lasts for 3 mins
234         uint256 _kickOff = now + startInSeconds;
235         uint256 _fullTime = _kickOff + durationInSeconds;
236         matchCounter++;
237         matches[matchCounter] = Match(matchCounter, entryPrice, _homeTeam, 0, _awayTeam, 0, _kickOff, _fullTime, 0, 0, 0, 0, 0, false);
238         emit MatchCreated(matchCounter, entryPrice, _homeTeam, _awayTeam, _kickOff, _fullTime);
239     }
240 
241     function joinMatch(uint256 _matchId, uint256 _team, string _playerName) public payable {
242 
243         // Does player exist?
244         if (players[msg.sender].id == 0) {
245             players[msg.sender] = Player(playerCounter++, _playerName, msg.sender, 0);
246         } else {
247             players[msg.sender].name = _playerName;
248         }
249         
250         // Get match
251         Match storage theMatch = matches[_matchId];
252         
253         // Validation
254         require(theMatch.id != 0); 
255         require(msg.value >= theMatch.playerEntryPrice);
256 	    require(_addressNotNull(msg.sender));
257 
258         // Match status
259         if (allowInPlayJoining) {
260             require(now < theMatch.fullTime);    
261         } else {
262             require(now < theMatch.kickOff);
263         }
264 
265         // Spaces left on team
266         if (theMatch.homeTeam == _team)
267         {
268             require(theMatch.homeTeamPlayersCount < 11);
269             theMatch.homeTeamPlayers[theMatch.homeTeamPlayersCount++] = players[msg.sender];
270         } else {
271             require(theMatch.awayTeamPlayersCount < 11);
272             theMatch.awayTeamPlayers[theMatch.awayTeamPlayersCount++] = players[msg.sender];
273         }
274 
275         theMatch.prize += theMatch.playerEntryPrice;
276 
277         // Overpayments are refunded
278         uint256 purchaseExcess = SafeMath.sub(msg.value, theMatch.playerEntryPrice);
279 	    msg.sender.transfer(purchaseExcess);
280 	    
281         emit PlayerJoined(_matchId, _team, players[msg.sender].name, msg.sender);
282     }
283     
284     function getMatchHomePlayers(uint256 matchId) public constant returns(address[]) {
285         if(matchCounter == 0) {
286             return new address[](0x0);
287         }
288         
289         // We only return matches that are in play
290         address[] memory matchPlayers = new address[](matches[matchId].homeTeamPlayersCount);
291         for (uint256 i = 0; i < matches[matchId].homeTeamPlayersCount; i++) {
292             matchPlayers[i] =  matches[matchId].homeTeamPlayers[i].account;
293         }
294         return (matchPlayers);
295     }
296         
297     function getMatchAwayPlayers(uint256 matchId) public constant returns(address[]) {
298         if(matchCounter == 0) {
299             return new address[](0x0);
300         }
301         
302         // We only return matches that are in play
303         address[] memory matchPlayers = new address[](matches[matchId].awayTeamPlayersCount);
304         for (uint256 i = 0; i < matches[matchId].awayTeamPlayersCount; i++) {
305             matchPlayers[i] =  matches[matchId].awayTeamPlayers[i].account;
306         }
307         return (matchPlayers);
308     }
309 
310     function getFixtures() public constant returns(uint256[]) {
311         if(matchCounter == 0) {
312             return new uint[](0);
313         }
314 
315         uint256[] memory matchIds = new uint256[](matchCounter);
316         uint256 numberOfMatches = 0;
317         for (uint256 i = 1; i <= matchCounter; i++) {
318             if (now < matches[i].kickOff) {
319                 matchIds[numberOfMatches] = matches[i].id;
320                 numberOfMatches++;
321             }
322         }
323 
324         // copy it to a shorter array
325         uint[] memory smallerArray = new uint[](numberOfMatches);
326         for (uint j = 0; j < numberOfMatches; j++) {
327             smallerArray[j] = matchIds[j];
328         }
329         return (smallerArray);
330     }
331     
332     function getInPlayGames() public constant returns(uint256[]) {
333         if(matchCounter == 0) {
334             return new uint[](0);
335         }
336         
337         // We only return matches that are in play
338         uint256[] memory matchIds = new uint256[](matchCounter);
339         uint256 numberOfMatches = 0;
340         for (uint256 i = 1; i <= matchCounter; i++) {
341             if (now > matches[i].kickOff && now < matches[i].fullTime) {
342                 matchIds[numberOfMatches] = matches[i].id;
343                 numberOfMatches++;
344             }
345         }
346 
347         // copy it to a shorter array
348         uint[] memory smallerArray = new uint[](numberOfMatches);
349         for (uint j = 0; j < numberOfMatches; j++) {
350             smallerArray[j] = matchIds[j];
351         }
352         return (smallerArray);
353     }
354     
355     function getUnReportedMatches() public constant returns(uint256[]) {
356         if(matchCounter == 0) {
357             return new uint[](0);
358         }
359         
360         // We only return matches that are finished and unreported that had players
361         uint256[] memory matchIds = new uint256[](matchCounter);
362         uint256 numberOfMatches = 0;
363         for (uint256 i = 1; i <= matchCounter; i++) {
364             if (!matches[i].reported && now > matches[i].fullTime && (matches[i].homeTeamPlayersCount + matches[i].awayTeamPlayersCount) > 0) {
365                 matchIds[numberOfMatches] = matches[i].id;
366                 numberOfMatches++;
367             }
368         }
369 
370         // copy it to a shorter array
371         uint[] memory smallerArray = new uint[](numberOfMatches);
372         for (uint j = 0; j < numberOfMatches; j++) {
373             smallerArray[j] = matchIds[j];
374         }
375         return (smallerArray);
376     }
377 
378     function getMatchReport(uint256 _matchId) public {
379         
380         Match storage theMatch = matches[_matchId];
381         
382         require(theMatch.id > 0 && !theMatch.reported);
383         
384         uint256 index;
385         // if a match was one sided, refund all players
386         if (theMatch.homeTeamPlayersCount == 0 || theMatch.awayTeamPlayersCount == 0)
387         {
388             for (index = 0; index < theMatch.homeTeamPlayersCount; index++) {
389                 players[theMatch.homeTeamPlayers[index].account].balance += theMatch.playerEntryPrice;
390             }
391 
392             for (index = 0; index < theMatch.awayTeamPlayersCount; index++) {
393                 players[theMatch.awayTeamPlayers[index].account].balance += theMatch.playerEntryPrice;
394             }
395 
396         } else {
397             
398             // Get the account balances of each team, NOT the in game balance.
399             uint256 htpBalance = 0;
400             for (index = 0; index < theMatch.homeTeamPlayersCount; index++) {
401                htpBalance += theMatch.homeTeamPlayers[index].account.balance;
402             }
403             
404             uint256 atpBalance = 0;
405             for (index = 0; index < theMatch.awayTeamPlayersCount; index++) {
406                atpBalance += theMatch.awayTeamPlayers[index].account.balance;
407             }
408             
409             theMatch.homeScore = htpBalance % 5;
410             theMatch.awayScore = atpBalance % 5;
411             
412             // We want a distinct winner
413             if (theMatch.homeScore == theMatch.awayScore)
414             {
415                 if(block.timestamp % 2 == 0){
416                   theMatch.homeScore += 1;
417                 } else {
418                   theMatch.awayScore += 1;
419                 }
420             }
421     
422             uint256 prizeMoney = 0;
423             if(theMatch.homeScore > theMatch.awayScore){
424               // home wins
425               theMatch.winningTeam = theMatch.homeTeam;
426               prizeMoney = SafeMath.mul(theMatch.playerEntryPrice, theMatch.awayTeamPlayersCount);
427             } else {
428               // away wins
429               theMatch.winningTeam = theMatch.awayTeam;
430               prizeMoney = SafeMath.mul(theMatch.playerEntryPrice, theMatch.homeTeamPlayersCount);
431             }
432             
433     	    uint256 onePercent = SafeMath.div(prizeMoney, 100);
434             uint256 developerAllocation = SafeMath.mul(onePercent, 1);
435             uint256 teamOwnerAllocation = SafeMath.mul(onePercent, 9);
436             uint256 playersProfit = SafeMath.mul(onePercent, 90);
437             
438             uint256 playersProfitShare = 0;
439             
440             // Allocate funds to players
441             if (theMatch.winningTeam == theMatch.homeTeam)
442             {
443                 playersProfitShare = SafeMath.add(SafeMath.div(playersProfit, theMatch.homeTeamPlayersCount), theMatch.playerEntryPrice);
444                 
445                 for (index = 0; index < theMatch.homeTeamPlayersCount; index++) {
446                     players[theMatch.homeTeamPlayers[index].account].balance += playersProfitShare;
447                 }
448                 
449             } else {
450                 playersProfitShare = SafeMath.add(SafeMath.div(playersProfit, theMatch.awayTeamPlayersCount), theMatch.playerEntryPrice);
451                 
452                 for (index = 0; index < theMatch.awayTeamPlayersCount; index++) {
453                     players[theMatch.awayTeamPlayers[index].account].balance += playersProfitShare;
454                 }
455             }
456     
457             // Allocate to team owner
458             teams[theMatch.winningTeam].balance += teamOwnerAllocation;
459             theMatch.winningTeamBonus = teamOwnerAllocation;
460 
461             // Allocate to developer
462 	        developerBalance += developerAllocation;
463             
464             emit MatchFinished(theMatch.id, theMatch.homeTeam, theMatch.awayTeam, theMatch.winningTeam, teamOwnerAllocation);
465         }
466         
467         theMatch.reported = true;
468     }
469 
470     function getReportedMatches() public constant returns(uint256[]) {
471         if(matchCounter == 0) {
472             return new uint[](0);
473         }
474         
475         // We only return matches for the last x hours - everything else is on chain
476         uint256[] memory matchIds = new uint256[](matchCounter);
477         uint256 numberOfMatches = 0;
478         for (uint256 i = 1; i <= matchCounter; i++) {
479             if (matches[i].reported && now > matches[i].fullTime && matches[i].fullTime + dataVisibleWindow > now) {
480                 matchIds[numberOfMatches] = matches[i].id;
481                 numberOfMatches++;
482             }
483         }
484 
485         // copy it to a shorter array
486         uint[] memory smallerArray = new uint[](numberOfMatches);
487         for (uint j = 0; j < numberOfMatches; j++) {
488             smallerArray[j] = matchIds[j];
489         }
490         return (smallerArray);
491     }
492     
493     function playerPrizeClaim() public {
494         require(_addressNotNull(msg.sender));
495         require(players[msg.sender].account != address(0));
496         
497         msg.sender.transfer(players[msg.sender].balance);
498         players[msg.sender].balance = 0;
499     }
500     
501     function teamPrizeClaim(uint256 _teamId) public {
502         require(_addressNotNull(msg.sender));
503         require(teams[_teamId].init);
504         
505         // This allows for sniping of teams. If a balance increases because teams have won games with bets on them
506         // then it is down to the owner to claim the prize. If someone spots a build up of balance on a team
507         // and then buys the team they can claim the prize. This is the intent.
508         teams[_teamId].owner = cryptoCupTokenContract.ownerOf(_teamId);
509         
510         // This way the claimant either gets the balance because he sniped the team
511         // Or he initiates the transfer to the rightful owner
512         teams[_teamId].owner.transfer(teams[_teamId].balance);
513         emit TeamOwnerPaid(_teamId, teams[_teamId].balance);
514         teams[_teamId].balance = 0;
515     }
516 
517     /********----------- PRIVATE FUNCTIONS ------------********/
518     function _addressNotNull(address _to) private pure returns (bool) {
519         return _to != address(0);
520     }  
521 }
522 
523 contract CryptoCupToken {
524     function ownerOf(uint256 _tokenId) public view returns (address addr);
525 }