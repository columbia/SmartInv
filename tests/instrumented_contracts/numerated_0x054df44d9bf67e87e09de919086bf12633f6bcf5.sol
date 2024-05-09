1 pragma solidity ^0.4.18;
2 
3 
4 contract DataSourceInterface {
5 
6     function isDataSource() public pure returns (bool);
7 
8     function getGroupResult(uint matchId) external;
9     function getRoundOfSixteenTeams(uint index) external;
10     function getRoundOfSixteenResult(uint matchId) external;
11     function getQuarterResult(uint matchId) external;
12     function getSemiResult(uint matchId) external;
13     function getFinalTeams() external;
14     function getYellowCards() external;
15     function getRedCards() external;
16 
17 }
18 
19 
20 /**
21 * @title DataLayer.
22 * @author CryptoCup Team (https://cryptocup.io/about)
23 */
24 contract DataLayer{
25 
26     
27     uint256 constant WCCTOKEN_CREATION_LIMIT = 5000000;
28     uint256 constant STARTING_PRICE = 45 finney;
29     
30     /// Epoch times based on when the prices change.
31     uint256 constant FIRST_PHASE  = 1527476400;
32     uint256 constant SECOND_PHASE = 1528081200;
33     uint256 constant THIRD_PHASE  = 1528686000;
34     uint256 constant WORLD_CUP_START = 1528945200;
35 
36     DataSourceInterface public dataSource;
37     address public dataSourceAddress;
38 
39     address public adminAddress;
40     uint256 public deploymentTime = 0;
41     uint256 public gameFinishedTime = 0; //set this to now when oraclize was called.
42     uint32 public lastCalculatedToken = 0;
43     uint256 public pointsLimit = 0;
44     uint32 public lastCheckedToken = 0;
45     uint32 public winnerCounter = 0;
46     uint32 public lastAssigned = 0;
47     uint256 public auxWorstPoints = 500000000;
48     uint32 public payoutRange = 0;
49     uint32 public lastPrizeGiven = 0;
50     uint256 public prizePool = 0;
51     uint256 public adminPool = 0;
52     uint256 public finalizedTime = 0;
53 
54     enum teamState { None, ROS, QUARTERS, SEMIS, FINAL }
55     enum pointsValidationState { Unstarted, LimitSet, LimitCalculated, OrderChecked, TopWinnersAssigned, WinnersAssigned, Finished }
56     
57     /**
58     * groups1     scores of the first half of matches (8 bits each)
59     * groups2     scores of the second half of matches (8 bits each)
60     * brackets    winner's team ids of each round (5 bits each)
61     * timeStamp   creation timestamp
62     * extra       number of yellow and red cards (16 bits each)
63     */
64     struct Token {
65         uint192 groups1;
66         uint192 groups2;
67         uint160 brackets;
68         uint64 timeStamp;
69         uint32  extra;
70     }
71 
72     struct GroupResult{
73         uint8 teamOneGoals;
74         uint8 teamTwoGoals;
75     }
76 
77     struct BracketPhase{
78         uint8[16] roundOfSixteenTeamsIds;
79         mapping (uint8 => bool) teamExists;
80         mapping (uint8 => teamState) middlePhaseTeamsIds;
81         uint8[4] finalsTeamsIds;
82     }
83 
84     struct Extras {
85         uint16 yellowCards;
86         uint16 redCards;
87     }
88 
89     
90     // List of all tokens
91     Token[] tokens;
92 
93     GroupResult[48] groupsResults;
94     BracketPhase bracketsResults;
95     Extras extraResults;
96 
97     // List of all tokens that won 
98     uint256[] sortedWinners;
99 
100     // List of the worst tokens (they also win)
101     uint256[] worstTokens;
102     pointsValidationState public pValidationState = pointsValidationState.Unstarted;
103 
104     mapping (address => uint256[]) public tokensOfOwnerMap;
105     mapping (uint256 => address) public ownerOfTokenMap;
106     mapping (uint256 => address) public tokensApprovedMap;
107     mapping (uint256 => uint256) public tokenToPayoutMap;
108     mapping (uint256 => uint16) public tokenToPointsMap;    
109 
110 
111     event LogTokenBuilt(address creatorAddress, uint256 tokenId, Token token);
112     event LogDataSourceCallbackList(uint8[] result);
113     event LogDataSourceCallbackInt(uint8 result);
114     event LogDataSourceCallbackTwoInt(uint8 result, uint8 result2);
115 
116 }
117 
118 
119 ///Author Dieter Shirley (https://github.com/dete)
120 contract ERC721 {
121 
122     event LogTransfer(address from, address to, uint256 tokenId);
123     event LogApproval(address owner, address approved, uint256 tokenId);
124 
125     function name() public view returns (string);
126     function symbol() public view returns (string);
127     function totalSupply() public view returns (uint256 total);
128     function balanceOf(address _owner) public view returns (uint256 balance);
129     function ownerOf(uint256 _tokenId) external view returns (address owner);
130     function approve(address _to, uint256 _tokenId) external;
131     function transfer(address _to, uint256 _tokenId) external;
132     function transferFrom(address _from, address _to, uint256 _tokenId) external;
133     function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
134 
135 }
136 
137 
138 
139 
140 
141 
142 
143 
144 
145 
146 
147 
148 /**
149 * @title AccessControlLayer
150 * @author CryptoCup Team (https://cryptocup.io/about)
151 * @dev Containes basic admin modifiers to restrict access to some functions. Allows
152 * for pauseing, and setting emergency stops.
153 */
154 contract AccessControlLayer is DataLayer{
155 
156     bool public paused = false;
157     bool public finalized = false;
158     bool public saleOpen = true;
159 
160    /**
161    * @dev Main modifier to limit access to delicate functions.
162    */
163     modifier onlyAdmin() {
164         require(msg.sender == adminAddress);
165         _;
166     }
167 
168     /**
169     * @dev Modifier that checks that the contract is not paused
170     */
171     modifier isNotPaused() {
172         require(!paused);
173         _;
174     }
175 
176     /**
177     * @dev Modifier that checks that the contract is paused
178     */
179     modifier isPaused() {
180         require(paused);
181         _;
182     }
183 
184     /**
185     * @dev Modifier that checks that the contract has finished successfully
186     */
187     modifier hasFinished() {
188         require((gameFinishedTime != 0) && now >= (gameFinishedTime + (15 days)));
189         _;
190     }
191 
192     /**
193     * @dev Modifier that checks that the contract has finalized
194     */
195     modifier hasFinalized() {
196         require(finalized);
197         _;
198     }
199 
200     /**
201     * @dev Checks if pValidationState is in the provided stats
202     * @param state State required to run
203     */
204     modifier checkState(pointsValidationState state){
205         require(pValidationState == state);
206         _;
207     }
208 
209     /**
210     * @dev Transfer contract's ownership
211     * @param _newAdmin Address to be set
212     */
213     function setAdmin(address _newAdmin) external onlyAdmin {
214 
215         require(_newAdmin != address(0));
216         adminAddress = _newAdmin;
217     }
218 
219     /**
220     * @dev Sets the contract pause state
221     * @param state True to pause
222     */
223     function setPauseState(bool state) external onlyAdmin {
224         paused = state;
225     }
226 
227     /**
228     * @dev Sets the contract to finalized
229     * @param state True to finalize
230     */
231     function setFinalized(bool state) external onlyAdmin {
232         paused = state;
233         finalized = state;
234         if(finalized == true)
235             finalizedTime = now;
236     }
237 }
238 
239 /**
240 * @title CryptoCupToken, main implemantations of the ERC721 standard
241 * @author CryptoCup Team (https://cryptocup.io/about)
242 */
243 contract CryptocupToken is AccessControlLayer, ERC721 {
244 
245     //FUNCTIONALTIY
246     /**
247     * @notice checks if a user owns a token
248     * @param userAddress - The address to check.
249     * @param tokenId - ID of the token that needs to be verified.
250     * @return true if the userAddress provided owns the token.
251     */
252     function _userOwnsToken(address userAddress, uint256 tokenId) internal view returns (bool){
253 
254          return ownerOfTokenMap[tokenId] == userAddress;
255 
256     }
257 
258     /**
259     * @notice checks if the address provided is approved for a given token 
260     * @param userAddress 
261     * @param tokenId 
262     * @return true if it is aproved
263     */
264     function _tokenIsApproved(address userAddress, uint256 tokenId) internal view returns (bool) {
265 
266         return tokensApprovedMap[tokenId] == userAddress;
267     }
268 
269     /**
270     * @notice transfers the token specified from sneder address to receiver address.
271     * @param fromAddress the sender address that initially holds the token.
272     * @param toAddress the receipient of the token.
273     * @param tokenId ID of the token that will be sent.
274     */
275     function _transfer(address fromAddress, address toAddress, uint256 tokenId) internal {
276 
277       require(tokensOfOwnerMap[toAddress].length < 100);
278       require(pValidationState == pointsValidationState.Unstarted);
279       
280       tokensOfOwnerMap[toAddress].push(tokenId);
281       ownerOfTokenMap[tokenId] = toAddress;
282 
283       uint256[] storage tokenArray = tokensOfOwnerMap[fromAddress];
284       for (uint256 i = 0; i < tokenArray.length; i++){
285         if(tokenArray[i] == tokenId){
286           tokenArray[i] = tokenArray[tokenArray.length-1];
287         }
288       }
289       delete tokenArray[tokenArray.length-1];
290       tokenArray.length--;
291 
292       delete tokensApprovedMap[tokenId];
293 
294     }
295 
296     /**
297     * @notice Approve the address for a given token
298     * @param tokenId - ID of token to be approved
299     * @param userAddress - Address that will be approved
300     */
301     function _approve(uint256 tokenId, address userAddress) internal {
302         tokensApprovedMap[tokenId] = userAddress;
303     }
304 
305     /**
306     * @notice set token owner to an address
307     * @dev sets token owner on the contract data structures
308     * @param ownerAddress address to be set
309     * @param tokenId Id of token to be used
310     */
311     function _setTokenOwner(address ownerAddress, uint256 tokenId) internal{
312 
313     	tokensOfOwnerMap[ownerAddress].push(tokenId);
314       ownerOfTokenMap[tokenId] = ownerAddress;
315     
316     }
317 
318     //ERC721 INTERFACE
319     function name() public view returns (string){
320       return "Cryptocup";
321     }
322 
323     function symbol() public view returns (string){
324       return "CC";
325     }
326 
327     
328     function balanceOf(address userAddress) public view returns (uint256 count) {
329       return tokensOfOwnerMap[userAddress].length;
330 
331     }
332 
333     function transfer(address toAddress,uint256 tokenId) external isNotPaused {
334 
335       require(toAddress != address(0));
336       require(toAddress != address(this));
337       require(_userOwnsToken(msg.sender, tokenId));
338 
339       _transfer(msg.sender, toAddress, tokenId);
340       LogTransfer(msg.sender, toAddress, tokenId);
341 
342     }
343 
344 
345     function transferFrom(address fromAddress, address toAddress, uint256 tokenId) external isNotPaused {
346 
347       require(toAddress != address(0));
348       require(toAddress != address(this));
349       require(_tokenIsApproved(msg.sender, tokenId));
350       require(_userOwnsToken(fromAddress, tokenId));
351 
352       _transfer(fromAddress, toAddress, tokenId);
353       LogTransfer(fromAddress, toAddress, tokenId);
354 
355     }
356 
357     function approve( address toAddress, uint256 tokenId) external isNotPaused {
358 
359         require(toAddress != address(0));
360         require(_userOwnsToken(msg.sender, tokenId));
361 
362         _approve(tokenId, toAddress);
363         LogApproval(msg.sender, toAddress, tokenId);
364 
365     }
366 
367     function totalSupply() public view returns (uint) {
368 
369         return tokens.length;
370 
371     }
372 
373     function ownerOf(uint256 tokenId) external view returns (address ownerAddress) {
374 
375         ownerAddress = ownerOfTokenMap[tokenId];
376         require(ownerAddress != address(0));
377 
378     }
379 
380     function tokensOfOwner(address ownerAddress) external view returns(uint256[] tokenIds) {
381 
382         tokenIds = tokensOfOwnerMap[ownerAddress];
383 
384     }
385 
386 }
387 
388 
389 
390 /**
391  * @title SafeMath
392  * @dev Math operations with safety checks that throw on error
393  */
394 library SafeMath {
395 
396   /**
397   * @dev Multiplies two numbers, throws on overflow.
398   */
399   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
400     if (a == 0) {
401       return 0;
402     }
403     uint256 c = a * b;
404     assert(c / a == b);
405     return c;
406   }
407 
408   /**
409   * @dev Integer division of two numbers, truncating the quotient.
410   */
411   function div(uint256 a, uint256 b) internal pure returns (uint256) {
412     // assert(b > 0); // Solidity automatically throws when dividing by 0
413     uint256 c = a / b;
414     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
415     return c;
416   }
417 
418   /**
419   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
420   */
421   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
422     assert(b <= a);
423     return a - b;
424   }
425 
426   /**
427   * @dev Adds two numbers, throws on overflow.
428   */
429   function add(uint256 a, uint256 b) internal pure returns (uint256) {
430     uint256 c = a + b;
431     assert(c >= a);
432     return c;
433   }
434 }
435 
436 
437 /**
438 * @title GameLogicLayer, contract in charge of everything related to calculating points, asigning
439 * winners, and distributing prizes.
440 * @author CryptoCup Team (https://cryptocup.io/about)
441 */
442 contract GameLogicLayer is CryptocupToken{
443 
444     using SafeMath for *;
445 
446     uint8 TEAM_RESULT_MASK_GROUPS = 15;
447     uint160 RESULT_MASK_BRACKETS = 31;
448     uint16 EXTRA_MASK_BRACKETS = 65535;
449 
450     uint16 private lastPosition;
451     uint16 private superiorQuota;
452     
453     uint16[] private payDistributionAmount = [1,1,1,1,1,1,1,1,1,1,5,5,10,20,50,100,100,200,500,1500,2500];
454     uint32[] private payoutDistribution;
455 
456 	event LogGroupDataArrived(uint matchId, uint8 result, uint8 result2);
457     event LogRoundOfSixteenArrived(uint id, uint8 result);
458     event LogMiddlePhaseArrived(uint matchId, uint8 result);
459     event LogFinalsArrived(uint id, uint8[4] result);
460     event LogExtrasArrived(uint id, uint16 result);
461     
462     //ORACLIZE
463     function dataSourceGetGroupResult(uint matchId) external onlyAdmin{
464         dataSource.getGroupResult(matchId);
465     }
466 
467     function dataSourceGetRoundOfSixteen(uint index) external onlyAdmin{
468         dataSource.getRoundOfSixteenTeams(index);
469     }
470 
471     function dataSourceGetRoundOfSixteenResult(uint matchId) external onlyAdmin{
472         dataSource.getRoundOfSixteenResult(matchId);
473     }
474 
475     function dataSourceGetQuarterResult(uint matchId) external onlyAdmin{
476         dataSource.getQuarterResult(matchId);
477     }
478     
479     function dataSourceGetSemiResult(uint matchId) external onlyAdmin{
480         dataSource.getSemiResult(matchId);
481     }
482 
483     function dataSourceGetFinals() external onlyAdmin{
484         dataSource.getFinalTeams();
485     }
486 
487     function dataSourceGetYellowCards() external onlyAdmin{
488         dataSource.getYellowCards();
489     }
490 
491     function dataSourceGetRedCards() external onlyAdmin{
492         dataSource.getRedCards();
493     }
494 
495     /**
496     * @notice sets a match result to the contract storage
497     * @param matchId id of match to check
498     * @param result number of goals the first team scored
499     * @param result2 number of goals the second team scored
500     */
501     
502     function dataSourceCallbackGroup(uint matchId, uint8 result, uint8 result2) public {
503 
504         require (msg.sender == dataSourceAddress);
505         require (matchId >= 0 && matchId <= 47);
506 
507         groupsResults[matchId].teamOneGoals = result;
508         groupsResults[matchId].teamTwoGoals = result2;
509 
510         LogGroupDataArrived(matchId, result, result2);
511 
512     }
513 
514     /**
515     * @notice sets the sixteen teams that made it through groups to the contract storage
516     * @param id index of sixteen teams
517     * @param result results to be set
518     */
519 
520     function dataSourceCallbackRoundOfSixteen(uint id, uint8 result) public {
521 
522         require (msg.sender == dataSourceAddress);
523 
524         bracketsResults.roundOfSixteenTeamsIds[id] = result;
525         bracketsResults.teamExists[result] = true;
526         
527         LogRoundOfSixteenArrived(id, result);
528 
529     }
530 
531     function dataSourceCallbackTeamId(uint matchId, uint8 result) public {
532         require (msg.sender == dataSourceAddress);
533 
534         teamState state = bracketsResults.middlePhaseTeamsIds[result];
535 
536         if (matchId >= 48 && matchId <= 55){
537             if (state < teamState.ROS)
538                 bracketsResults.middlePhaseTeamsIds[result] = teamState.ROS;
539         } else if (matchId >= 56 && matchId <= 59){
540             if (state < teamState.QUARTERS)
541                 bracketsResults.middlePhaseTeamsIds[result] = teamState.QUARTERS;
542         } else if (matchId == 60 || matchId == 61){
543             if (state < teamState.SEMIS)
544                 bracketsResults.middlePhaseTeamsIds[result] = teamState.SEMIS;
545         }
546 
547         LogMiddlePhaseArrived(matchId, result);
548     }
549 
550     /**
551     * @notice sets the champion, second, third and fourth teams to the contract storage
552     * @param id 
553     * @param result ids of the four teams
554     */
555     function dataSourceCallbackFinals(uint id, uint8[4] result) public {
556 
557         require (msg.sender == dataSourceAddress);
558 
559         uint256 i;
560 
561         for(i = 0; i < 4; i++){
562             bracketsResults.finalsTeamsIds[i] = result[i];
563         }
564 
565         LogFinalsArrived(id, result);
566 
567     }
568 
569     /**
570     * @notice sets the number of cards to the contract storage
571     * @param id 101 for yellow cards, 102 for red cards
572     * @param result amount of cards
573     */
574     function dataSourceCallbackExtras(uint id, uint16 result) public {
575 
576         require (msg.sender == dataSourceAddress);
577 
578         if (id == 101){
579             extraResults.yellowCards = result;
580         } else if (id == 102){
581             extraResults.redCards = result;
582         }
583 
584         LogExtrasArrived(id, result);
585 
586     }
587 
588     /**
589     * @notice check if prediction for a match winner is correct
590     * @param realResultOne amount of goals team one scored
591     * @param realResultTwo amount of goals team two scored
592     * @param tokenResultOne amount of goals team one was predicted to score
593     * @param tokenResultTwo amount of goals team two was predicted to score
594     * @return 
595     */
596     function matchWinnerOk(uint8 realResultOne, uint8 realResultTwo, uint8 tokenResultOne, uint8 tokenResultTwo) internal pure returns(bool){
597 
598         int8 realR = int8(realResultOne - realResultTwo);
599         int8 tokenR = int8(tokenResultOne - tokenResultTwo);
600 
601         return (realR > 0 && tokenR > 0) || (realR < 0 && tokenR < 0) || (realR == 0 && tokenR == 0);
602 
603     }
604 
605     /**
606     * @notice get points from a single match 
607     * @param matchIndex 
608     * @param groupsPhase token predictions
609     * @return 10 if predicted score correctly, 3 if predicted only who would win
610     * and 0 if otherwise
611     */
612     function getMatchPointsGroups (uint256 matchIndex, uint192 groupsPhase) internal view returns(uint16 matchPoints) {
613 
614         uint8 tokenResultOne = uint8(groupsPhase & TEAM_RESULT_MASK_GROUPS);
615         uint8 tokenResultTwo = uint8((groupsPhase >> 4) & TEAM_RESULT_MASK_GROUPS);
616 
617         uint8 teamOneGoals = groupsResults[matchIndex].teamOneGoals;
618         uint8 teamTwoGoals = groupsResults[matchIndex].teamTwoGoals;
619 
620         if (teamOneGoals == tokenResultOne && teamTwoGoals == tokenResultTwo){
621             matchPoints += 10;
622         } else {
623             if (matchWinnerOk(teamOneGoals, teamTwoGoals, tokenResultOne, tokenResultTwo)){
624                 matchPoints += 3;
625             }
626         }
627 
628     }
629 
630     /**
631     * @notice calculates points from the last two matches
632     * @param brackets token predictions
633     * @return amount of points gained from the last two matches
634     */
635     function getFinalRoundPoints (uint160 brackets) internal view returns(uint16 finalRoundPoints) {
636 
637         uint8[3] memory teamsIds;
638 
639         for (uint i = 0; i <= 2; i++){
640             brackets = brackets >> 5; //discard 4th place
641             teamsIds[2-i] = uint8(brackets & RESULT_MASK_BRACKETS);
642         }
643 
644         if (teamsIds[0] == bracketsResults.finalsTeamsIds[0]){
645             finalRoundPoints += 100;
646         }
647 
648         if (teamsIds[2] == bracketsResults.finalsTeamsIds[2]){
649             finalRoundPoints += 25;
650         }
651 
652         if (teamsIds[0] == bracketsResults.finalsTeamsIds[1]){
653             finalRoundPoints += 50;
654         }
655 
656         if (teamsIds[1] == bracketsResults.finalsTeamsIds[0] || teamsIds[1] == bracketsResults.finalsTeamsIds[1]){
657             finalRoundPoints += 50;
658         }
659 
660     }
661 
662     /**
663     * @notice calculates points for round of sixteen, quarter-finals and semifinals
664     * @param size amount of matches in round
665     * @param round ros, qf, sf or f
666     * @param brackets predictions
667     * @return amount of points
668     */
669     function getMiddleRoundPoints(uint8 size, teamState round, uint160 brackets) internal view returns(uint16 middleRoundResults){
670 
671         uint8 teamId;
672 
673         for (uint i = 0; i < size; i++){
674             teamId = uint8(brackets & RESULT_MASK_BRACKETS);
675 
676             if (uint(bracketsResults.middlePhaseTeamsIds[teamId]) >= uint(round) ) {
677                 middleRoundResults+=60;
678             }
679 
680             brackets = brackets >> 5;
681         }
682 
683     }
684 
685     /**
686     * @notice calculates points for correct predictions of group winners
687     * @param brackets token predictions
688     * @return amount of points
689     */
690     function getQualifiersPoints(uint160 brackets) internal view returns(uint16 qualifiersPoints){
691 
692         uint8 teamId;
693 
694         for (uint256 i = 0; i <= 15; i++){
695             teamId = uint8(brackets & RESULT_MASK_BRACKETS);
696 
697             if (teamId == bracketsResults.roundOfSixteenTeamsIds[15-i]){
698                 qualifiersPoints+=30;
699             } else if (bracketsResults.teamExists[teamId]){
700                 qualifiersPoints+=25;
701             }
702             
703             brackets = brackets >> 5;
704         }
705 
706     }
707 
708     /**
709     * @notice calculates points won by yellow and red cards predictions
710     * @param extras token predictions
711     * @return amount of points
712     */
713     function getExtraPoints(uint32 extras) internal view returns(uint16 extraPoints){
714 
715         uint16 redCards = uint16(extras & EXTRA_MASK_BRACKETS);
716         extras = extras >> 16;
717         uint16 yellowCards = uint16(extras);
718 
719         if (redCards == extraResults.redCards){
720             extraPoints+=20;
721         }
722 
723         if (yellowCards == extraResults.yellowCards){
724             extraPoints+=20;
725         }
726 
727     }
728 
729     /**
730     * @notice calculates total amount of points for a token
731     * @param t token to calculate points for
732     * @return total amount of points
733     */
734     function calculateTokenPoints (Token memory t) internal view returns(uint16 points){
735         
736         //Groups phase 1
737         uint192 g1 = t.groups1;
738         for (uint256 i = 0; i <= 23; i++){
739             points+=getMatchPointsGroups(23-i, g1);
740             g1 = g1 >> 8;
741         }
742 
743         //Groups phase 2
744         uint192 g2 = t.groups2;
745         for (i = 0; i <= 23; i++){
746             points+=getMatchPointsGroups(47-i, g2);
747             g2 = g2 >> 8;
748         }
749         
750         uint160 bracketsLocal = t.brackets;
751 
752         //Brackets phase 1
753         points+=getFinalRoundPoints(bracketsLocal);
754         bracketsLocal = bracketsLocal >> 20;
755 
756         //Brackets phase 2 
757         points+=getMiddleRoundPoints(4, teamState.QUARTERS, bracketsLocal);
758         bracketsLocal = bracketsLocal >> 20;
759 
760         //Brackets phase 3 
761         points+=getMiddleRoundPoints(8, teamState.ROS, bracketsLocal);
762         bracketsLocal = bracketsLocal >> 40;
763 
764         //Brackets phase 4
765         points+=getQualifiersPoints(bracketsLocal);
766 
767         //Extras
768         points+=getExtraPoints(t.extra);
769 
770     }
771 
772     /**
773     * @notice Sets the points of all the tokens between the last chunk set and the amount given.
774     * @dev This function uses all the data collected earlier by oraclize to calculate points.
775     * @param amount The amount of tokens that should be analyzed.
776     */
777 	function calculatePointsBlock(uint32 amount) external{
778 
779         require (gameFinishedTime == 0);
780         require(amount + lastCheckedToken <= tokens.length);
781 
782 
783         for (uint256 i = lastCalculatedToken; i < (lastCalculatedToken + amount); i++) {
784             uint16 points = calculateTokenPoints(tokens[i]);
785             tokenToPointsMap[i] = points;
786             if(worstTokens.length == 0 || points <= auxWorstPoints){
787                 if(worstTokens.length != 0 && points < auxWorstPoints){
788                   worstTokens.length = 0;
789                 }
790                 if(worstTokens.length < 100){
791                     auxWorstPoints = points;
792                     worstTokens.push(i);
793                 }
794             }
795         }
796 
797         lastCalculatedToken += amount;
798   	}
799 
800     /**
801     * @notice Sets the structures for payout distribution, last position and superior quota. Payout distribution is the
802     * percentage of the pot each position gets, last position is the percentage of the pot the last position gets,
803     * and superior quota is the total amount OF winners that are given a prize.
804     * @dev Each of this structures is dynamic and is assigned depending on the total amount of tokens in the game  
805     */
806     function setPayoutDistributionId () internal {
807         if(tokens.length < 101){
808             payoutDistribution = [289700, 189700, 120000, 92500, 75000, 62500, 52500, 42500, 40000, 35600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
809             lastPosition = 0;
810             superiorQuota = 10;
811         }else if(tokens.length < 201){
812             payoutDistribution = [265500, 165500, 105500, 75500, 63000, 48000, 35500, 20500, 20000, 19500, 18500, 17800, 0, 0, 0, 0, 0, 0, 0, 0, 0];
813             lastPosition = 0;
814             superiorQuota = 20;
815         }else if(tokens.length < 301){
816             payoutDistribution = [260700, 155700, 100700, 70900, 60700, 45700, 35500, 20500, 17900, 12500, 11500, 11000, 10670, 0, 0, 0, 0, 0, 0, 0, 0];
817             lastPosition = 0;
818             superiorQuota = 30;
819         }else if(tokens.length < 501){
820             payoutDistribution = [238600, 138600, 88800, 63800, 53800, 43800, 33800, 18800, 17500, 12500, 9500, 7500, 7100, 6700, 0, 0, 0, 0, 0, 0, 0];
821             lastPosition = 0;
822             superiorQuota = 50;
823         }else if(tokens.length < 1001){
824             payoutDistribution = [218300, 122300, 72300, 52400, 43900, 33900, 23900, 16000, 13000, 10000, 9000, 7000, 5000, 4000, 3600, 0, 0, 0, 0, 0, 0];
825             lastPosition = 4000;
826             superiorQuota = 100;
827         }else if(tokens.length < 2001){
828             payoutDistribution = [204500, 114000, 64000, 44100, 35700, 26700, 22000, 15000, 11000, 9500, 8500, 6500, 4600, 2500, 2000, 1800, 0, 0, 0, 0, 0];
829             lastPosition = 2500;
830             superiorQuota = 200;
831         }else if(tokens.length < 3001){
832             payoutDistribution = [189200, 104800, 53900, 34900, 29300, 19300, 15300, 14000, 10500, 8300, 8000, 6000, 3800, 2500, 2000, 1500, 1100, 0, 0, 0, 0];
833             lastPosition = 2500;
834             superiorQuota = 300;
835         }else if(tokens.length < 5001){
836             payoutDistribution = [178000, 100500, 47400, 30400, 24700, 15500, 15000, 12000, 10200, 7800, 7400, 5500, 3300, 2000, 1500, 1200, 900, 670, 0, 0, 0];
837             lastPosition = 2000;
838             superiorQuota = 500;
839         }else if(tokens.length < 10001){
840             payoutDistribution = [157600, 86500, 39000, 23100, 18900, 15000, 14000, 11000, 9300, 6100, 6000, 5000, 3800, 1500, 1100, 900, 700, 500, 360, 0, 0];
841             lastPosition = 1500;
842             superiorQuota = 1000;
843         }else if(tokens.length < 25001){
844             payoutDistribution = [132500, 70200, 31300, 18500, 17500, 14000, 13500, 10500, 7500, 5500, 5000, 4000, 3000, 1000, 900, 700, 600, 400, 200, 152, 0];
845             lastPosition = 1000;
846             superiorQuota = 2500;
847         } else {
848             payoutDistribution = [120000, 63000,  27000, 18800, 17300, 13700, 13000, 10000, 6300, 5000, 4500, 3900, 2500, 900, 800, 600, 500, 350, 150, 100, 70];
849             lastPosition = 900;
850             superiorQuota = 5000;
851         }
852 
853     }
854 
855     /**
856     * @notice Sets the id of the last token that will be given a prize.
857     * @dev This is done to offload some of the calculations needed for sorting, and to cap the number of sorts
858     * needed to just the winners and not the whole array of tokens.
859     * @param tokenId last token id
860     */
861     function setLimit(uint256 tokenId) external onlyAdmin{
862         require(tokenId < tokens.length);
863         require(pValidationState == pointsValidationState.Unstarted || pValidationState == pointsValidationState.LimitSet);
864         pointsLimit = tokenId;
865         pValidationState = pointsValidationState.LimitSet;
866         lastCheckedToken = 0;
867         lastCalculatedToken = 0;
868         winnerCounter = 0;
869         
870         setPayoutDistributionId();
871     }
872 
873     /**
874     * @notice Sets the 10th percentile of the sorted array of points
875     * @param amount tokens in a chunk
876     */
877     function calculateWinners(uint32 amount) external onlyAdmin checkState(pointsValidationState.LimitSet){
878         require(amount + lastCheckedToken <= tokens.length);
879         uint256 points = tokenToPointsMap[pointsLimit];
880 
881         for(uint256 i = lastCheckedToken; i < lastCheckedToken + amount; i++){
882             if(tokenToPointsMap[i] > points ||
883                 (tokenToPointsMap[i] == points && i <= pointsLimit)){
884                 winnerCounter++;
885             }
886         }
887         lastCheckedToken += amount;
888 
889         if(lastCheckedToken == tokens.length){
890             require(superiorQuota == winnerCounter);
891             pValidationState = pointsValidationState.LimitCalculated;
892         }
893     }
894 
895     /**
896     * @notice Checks if the order given offchain coincides with the order of the actual previously calculated points
897     * in the smart contract.
898     * @dev the token sorting is done offchain so as to save on the huge amount of gas and complications that 
899     * could occur from doing all the sorting onchain.
900     * @param sortedChunk chunk sorted by points
901     */
902     function checkOrder(uint32[] sortedChunk) external onlyAdmin checkState(pointsValidationState.LimitCalculated){
903         require(sortedChunk.length + sortedWinners.length <= winnerCounter);
904 
905         for(uint256 i=0;i < sortedChunk.length-1;i++){
906             uint256 id = sortedChunk[i];
907             uint256 sigId = sortedChunk[i+1];
908             require(tokenToPointsMap[id] > tokenToPointsMap[sigId] ||
909                 (tokenToPointsMap[id] == tokenToPointsMap[sigId] &&  id < sigId));
910         }
911 
912         if(sortedWinners.length != 0){
913             uint256 id2 = sortedWinners[sortedWinners.length-1];
914             uint256 sigId2 = sortedChunk[0];
915             require(tokenToPointsMap[id2] > tokenToPointsMap[sigId2] ||
916                 (tokenToPointsMap[id2] == tokenToPointsMap[sigId2] && id2 < sigId2));
917         }
918 
919         for(uint256 j=0;j < sortedChunk.length;j++){
920             sortedWinners.push(sortedChunk[j]);
921         }
922 
923         if(sortedWinners.length == winnerCounter){
924             require(sortedWinners[sortedWinners.length-1] == pointsLimit);
925             pValidationState = pointsValidationState.OrderChecked;
926         }
927 
928     }
929 
930     /**
931     * @notice If anything during the point calculation and sorting part should fail, this function can reset 
932     * data structures to their initial position, so as to  
933     */
934     function resetWinners(uint256 newLength) external onlyAdmin checkState(pointsValidationState.LimitCalculated){
935         
936         sortedWinners.length = newLength;
937     
938     }
939 
940     /**
941     * @notice Assigns prize percentage for the lucky top 30 winners. Each token will be assigned a uint256 inside
942     * tokenToPayoutMap structure that represents the size of the pot that belongs to that token. If any tokens
943     * tie inside of the first 30 tokens, the prize will be summed and divided equally. 
944     */
945     function setTopWinnerPrizes() external onlyAdmin checkState(pointsValidationState.OrderChecked){
946 
947         uint256 percent = 0;
948         uint[] memory tokensEquals = new uint[](30);
949         uint16 tokenEqualsCounter = 0;
950         uint256 currentTokenId;
951         uint256 currentTokenPoints;
952         uint256 lastTokenPoints;
953         uint32 counter = 0;
954         uint256 maxRange = 13;
955         if(tokens.length < 201){
956           maxRange = 10;
957         }
958         
959 
960         while(payoutRange < maxRange){
961           uint256 inRangecounter = payDistributionAmount[payoutRange];
962           while(inRangecounter > 0){
963             currentTokenId = sortedWinners[counter];
964             currentTokenPoints = tokenToPointsMap[currentTokenId];
965 
966             inRangecounter--;
967 
968             //Special case for the last one
969             if(inRangecounter == 0 && payoutRange == maxRange - 1){
970                 if(currentTokenPoints == lastTokenPoints){
971                   percent += payoutDistribution[payoutRange];
972                   tokensEquals[tokenEqualsCounter] = currentTokenId;
973                   tokenEqualsCounter++;
974                 }else{
975                   tokenToPayoutMap[currentTokenId] = payoutDistribution[payoutRange];
976                 }
977             }
978 
979             if(counter != 0 && (currentTokenPoints != lastTokenPoints || (inRangecounter == 0 && payoutRange == maxRange - 1))){ //Fix second condition
980                     for(uint256 i=0;i < tokenEqualsCounter;i++){
981                         tokenToPayoutMap[tokensEquals[i]] = percent.div(tokenEqualsCounter);
982                     }
983                     percent = 0;
984                     tokensEquals = new uint[](30);
985                     tokenEqualsCounter = 0;
986             }
987 
988             percent += payoutDistribution[payoutRange];
989             tokensEquals[tokenEqualsCounter] = currentTokenId;
990             
991             tokenEqualsCounter++;
992             counter++;
993 
994             lastTokenPoints = currentTokenPoints;
995            }
996            payoutRange++;
997         }
998 
999         pValidationState = pointsValidationState.TopWinnersAssigned;
1000         lastPrizeGiven = counter;
1001     }
1002 
1003     /**
1004     * @notice Sets prize percentage to every address that wins from the position 30th onwards
1005     * @dev If there are less than 300 tokens playing, then this function will set nothing.
1006     * @param amount tokens in a chunk
1007     */
1008     function setWinnerPrizes(uint32 amount) external onlyAdmin checkState(pointsValidationState.TopWinnersAssigned){
1009         require(lastPrizeGiven + amount <= winnerCounter);
1010         
1011         uint16 inRangeCounter = payDistributionAmount[payoutRange];
1012         for(uint256 i = 0; i < amount; i++){
1013           if (inRangeCounter == 0){
1014             payoutRange++;
1015             inRangeCounter = payDistributionAmount[payoutRange];
1016           }
1017 
1018           uint256 tokenId = sortedWinners[i + lastPrizeGiven];
1019 
1020           tokenToPayoutMap[tokenId] = payoutDistribution[payoutRange];
1021 
1022           inRangeCounter--;
1023         }
1024         //i + amount prize was not given yet, so amount -1
1025         lastPrizeGiven += amount;
1026         payDistributionAmount[payoutRange] = inRangeCounter;
1027 
1028         if(lastPrizeGiven == winnerCounter){
1029             pValidationState = pointsValidationState.WinnersAssigned;
1030             return;
1031         }
1032     }
1033 
1034     /**
1035     * @notice Sets prizes for last tokens and sets prize pool amount
1036     */
1037     function setLastPositions() external onlyAdmin checkState(pointsValidationState.WinnersAssigned){
1038         
1039             
1040         for(uint256 j = 0;j < worstTokens.length;j++){
1041             uint256 tokenId = worstTokens[j];
1042             tokenToPayoutMap[tokenId] += lastPosition.div(worstTokens.length);
1043         }
1044 
1045         uint256 balance = address(this).balance;
1046         adminPool = balance.mul(25).div(100);
1047         prizePool = balance.mul(75).div(100);
1048 
1049         pValidationState = pointsValidationState.Finished;
1050         gameFinishedTime = now;
1051     }
1052 
1053 }
1054 
1055 
1056 /**
1057 * @title CoreLayer
1058 * @author CryptoCup Team (https://cryptocup.io/about)
1059 * @notice Main contract
1060 */
1061 contract CoreLayer is GameLogicLayer {
1062     
1063     function CoreLayer() public {
1064         adminAddress = msg.sender;
1065         deploymentTime = now;
1066     }
1067 
1068     /** 
1069     * @dev Only accept eth from the admin
1070     */
1071     function() external payable {
1072         require(msg.sender == adminAddress);
1073 
1074     }
1075 
1076     function isDataSourceCallback() public pure returns (bool){
1077         return true;
1078     }   
1079 
1080     /** 
1081     * @notice Builds ERC721 token with the predictions provided by the user.
1082     * @param groups1  - First half of the group matches scores encoded in a uint192.
1083     * @param groups2 -  Second half of the groups matches scores encoded in a uint192.
1084     * @param brackets - Bracket information encoded in a uint160.
1085     * @param extra -    Extra information (number of red cards and yellow cards) encoded in a uint32.
1086     * @dev An automatic timestamp is added for internal use.
1087     */
1088     function buildToken(uint192 groups1, uint192 groups2, uint160 brackets, uint32 extra) external payable isNotPaused {
1089 
1090         Token memory token = Token({
1091             groups1: groups1,
1092             groups2: groups2,
1093             brackets: brackets,
1094             timeStamp: uint64(now),
1095             extra: extra
1096         });
1097 
1098         require(msg.value >= _getTokenPrice());
1099         require(msg.sender != address(0));
1100         require(tokens.length < WCCTOKEN_CREATION_LIMIT);
1101         require(tokensOfOwnerMap[msg.sender].length < 100);
1102         require(now < WORLD_CUP_START); //World cup Start
1103 
1104         uint256 tokenId = tokens.push(token) - 1;
1105         require(tokenId == uint256(uint32(tokenId)));
1106 
1107         _setTokenOwner(msg.sender, tokenId);
1108         LogTokenBuilt(msg.sender, tokenId, token);
1109 
1110     }
1111 
1112     /** 
1113     * @param tokenId - ID of token to get.
1114     * @return Returns all the valuable information about a specific token.
1115     */
1116     function getToken(uint256 tokenId) external view returns (uint192 groups1, uint192 groups2, uint160 brackets, uint64 timeStamp, uint32 extra) {
1117 
1118         Token storage token = tokens[tokenId];
1119 
1120         groups1 = token.groups1;
1121         groups2 = token.groups2;
1122         brackets = token.brackets;
1123         timeStamp = token.timeStamp;
1124         extra = token.extra;
1125 
1126     }
1127 
1128     /**
1129     * @notice Called by the development team once the World Cup has ended (adminPool is set) 
1130     * @dev Allows dev team to retrieve adminPool
1131     */
1132     function adminWithdrawBalance() external onlyAdmin {
1133 
1134         adminAddress.transfer(adminPool);
1135         adminPool = 0;
1136 
1137     }
1138 
1139     /**
1140     * @notice Allows any user to retrieve their asigned prize. This would be the sum of the price of all the tokens
1141     * owned by the caller of this function.
1142     * @dev If the caller has no prize, the function will revert costing no gas to the caller.
1143     */
1144     function withdrawPrize() external checkState(pointsValidationState.Finished){
1145         uint256 prize = 0;
1146         uint256[] memory tokenList = tokensOfOwnerMap[msg.sender];
1147         
1148         for(uint256 i = 0;i < tokenList.length; i++){
1149             prize += tokenToPayoutMap[tokenList[i]];
1150             tokenToPayoutMap[tokenList[i]] = 0;
1151         }
1152         
1153         require(prize > 0);
1154         msg.sender.transfer((prizePool.mul(prize)).div(1000000));
1155       
1156     }
1157 
1158     
1159     /**
1160     * @notice Gets current token price 
1161     */
1162     function _getTokenPrice() internal view returns(uint256 tokenPrice){
1163 
1164         if ( now >= THIRD_PHASE){
1165             tokenPrice = (150 finney);
1166         } else if (now >= SECOND_PHASE) {
1167             tokenPrice = (110 finney);
1168         } else if (now >= FIRST_PHASE) {
1169             tokenPrice = (75 finney);
1170         } else {
1171             tokenPrice = STARTING_PRICE;
1172         }
1173 
1174         require(tokenPrice >= STARTING_PRICE && tokenPrice <= (200 finney));
1175 
1176     }
1177 
1178     /**
1179     * @dev Sets the data source contract address 
1180     * @param _address Address to be set
1181     */
1182     function setDataSourceAddress(address _address) external onlyAdmin {
1183         
1184         DataSourceInterface c = DataSourceInterface(_address);
1185 
1186         require(c.isDataSource());
1187 
1188         dataSource = c;
1189         dataSourceAddress = _address;
1190     }
1191 
1192     /**
1193     * @notice Testing function to corroborate group data from oraclize call
1194     * @param x Id of the match to get
1195     * @return uint8 Team 1 goals
1196     * @return uint8 Team 2 goals
1197     */
1198     function getGroupData(uint x) external view returns(uint8 a, uint8 b){
1199         a = groupsResults[x].teamOneGoals;
1200         b = groupsResults[x].teamTwoGoals;  
1201     }
1202 
1203     /**
1204     * @notice Testing function to corroborate round of sixteen data from oraclize call
1205     * @return An array with the ids of the round of sixteen teams
1206     */
1207     function getBracketData() external view returns(uint8[16] a){
1208         a = bracketsResults.roundOfSixteenTeamsIds;
1209     }
1210 
1211     /**
1212     * @notice Testing function to corroborate brackets data from oraclize call
1213     * @param x Team id
1214     * @return The place the team reached
1215     */
1216     function getBracketDataMiddleTeamIds(uint8 x) external view returns(teamState a){
1217         a = bracketsResults.middlePhaseTeamsIds[x];
1218     }
1219 
1220     /**
1221     * @notice Testing function to corroborate finals data from oraclize call
1222     * @return the 4 (four) final teams ids
1223     */
1224     function getBracketDataFinals() external view returns(uint8[4] a){
1225         a = bracketsResults.finalsTeamsIds;
1226     }
1227 
1228     /**
1229     * @notice Testing function to corroborate extra data from oraclize call
1230     * @return amount of yellow and red cards
1231     */
1232     function getExtrasData() external view returns(uint16 a, uint16 b){
1233         a = extraResults.yellowCards;
1234         b = extraResults.redCards;  
1235     }
1236 
1237     //EMERGENCY CALLS
1238     //If something goes wrong or fails, these functions will allow retribution for token holders 
1239 
1240     /**
1241     * @notice if there is an unresolvable problem, users can call to this function to get a refund.
1242     */
1243     function emergencyWithdraw() external hasFinalized{
1244 
1245         uint256 balance = STARTING_PRICE * tokensOfOwnerMap[msg.sender].length;
1246 
1247         delete tokensOfOwnerMap[msg.sender];
1248         msg.sender.transfer(balance);
1249 
1250     }
1251 
1252      /**
1253     * @notice Let the admin cash-out the entire contract balance 10 days after game has finished.
1254     */
1255     function finishedGameWithdraw() external onlyAdmin hasFinished{
1256 
1257         uint256 balance = address(this).balance;
1258         adminAddress.transfer(balance);
1259 
1260     }
1261     
1262     /**
1263     * @notice Let the admin cash-out the entire contract balance 10 days after game has finished.
1264     */
1265     function emergencyWithdrawAdmin() external hasFinalized onlyAdmin{
1266 
1267         require(finalizedTime != 0 &&  now >= finalizedTime + 10 days );
1268         msg.sender.transfer(address(this).balance);
1269 
1270     }
1271 }