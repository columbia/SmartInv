1 pragma solidity ^0.4.24;
2 
3 // File: contracts/libs/PointsCalculator.sol
4 
5 library PointsCalculator {
6 
7     uint8 constant MATCHES_NUMBER = 20;
8     uint8 constant BONUS_MATCHES = 5;
9     
10     uint16 constant EXTRA_STATS_MASK = 65535;
11     uint8 constant MATCH_UNDEROVER_MASK = 1;
12     uint8 constant MATCH_RESULT_MASK = 3;
13     uint8 constant MATCH_TOUCHDOWNS_MASK = 31;
14     uint8 constant BONUS_STAT_MASK = 63;
15 
16     struct MatchResult{
17         uint8 result; /*  0-> draw, 1-> won 1, 2-> won 2 */
18         uint8 under49;
19         uint8 touchdowns;
20     }
21 
22     struct Extras {
23         uint16 interceptions;
24         uint16 missedFieldGoals;
25         uint16 overtimes;
26         uint16 sacks;
27         uint16 fieldGoals;
28         uint16 fumbles;
29     }
30 
31     struct BonusMatch {
32         uint16 bonus;
33     }    
34     
35     /**
36     * @notice get points from a single match 
37     * @param matchIndex index of the match
38     * @param matches token predictions
39     * @return 
40     */
41     function getMatchPoints (uint256 matchIndex, uint160 matches, MatchResult[] matchResults, bool[] starMatches) private pure returns(uint16 matchPoints) {
42 
43         uint8 tResult = uint8(matches & MATCH_RESULT_MASK);
44         uint8 tUnder49 = uint8((matches >> 2) & MATCH_UNDEROVER_MASK);
45         uint8 tTouchdowns = uint8((matches >> 3) & MATCH_TOUCHDOWNS_MASK);
46 
47         uint8 rResult = matchResults[matchIndex].result;
48         uint8 rUnder49 = matchResults[matchIndex].under49;
49         uint8 rTouchdowns = matchResults[matchIndex].touchdowns;
50         
51         if (rResult == tResult) {
52             matchPoints += 5;
53             if(rResult == 0) {
54                 matchPoints += 5;
55             }
56             if(starMatches[matchIndex]) {
57                 matchPoints += 2;
58             }
59         }
60         if(tUnder49 == rUnder49) {
61             matchPoints += 1;
62         }
63         if(tTouchdowns == rTouchdowns) {
64             matchPoints += 4;
65         }
66     }
67 
68     /**
69     * @notice calculates points won by yellow and red cards predictions
70     * @param extras token predictions
71     * @return amount of points
72     */
73     function getExtraPoints(uint96 extras, Extras extraStats) private pure returns(uint16 extraPoints){
74 
75         uint16 interceptions = uint16(extras & EXTRA_STATS_MASK);
76         extras = extras >> 16;
77         uint16 missedFieldGoals = uint16(extras & EXTRA_STATS_MASK);
78         extras = extras >> 16;
79         uint16 overtimes = uint16(extras & EXTRA_STATS_MASK);
80         extras = extras >> 16;
81         uint16 sacks = uint16(extras & EXTRA_STATS_MASK);
82         extras = extras >> 16;
83         uint16 fieldGoals = uint16(extras & EXTRA_STATS_MASK);
84         extras = extras >> 16;
85         uint16 fumbles = uint16(extras & EXTRA_STATS_MASK);
86 
87         if (interceptions == extraStats.interceptions){
88             extraPoints += 6;
89         }
90         
91         if (missedFieldGoals == extraStats.missedFieldGoals){
92             extraPoints += 6;
93         }
94 
95         if (overtimes == extraStats.overtimes){
96             extraPoints += 6;
97         }
98 
99         if (sacks == extraStats.sacks){
100             extraPoints += 6;
101         }
102 
103         if (fieldGoals == extraStats.fieldGoals){
104             extraPoints += 6;
105         }
106 
107         if (fumbles == extraStats.fumbles){
108             extraPoints += 6;
109         }
110 
111     }
112 
113     /**
114     *
115     *
116     *
117     */
118     function getBonusPoints (uint256 bonusId, uint32 bonuses, BonusMatch[] bonusMatches) private pure returns(uint16 bonusPoints) {
119         uint8 bonus = uint8(bonuses & BONUS_STAT_MASK);
120 
121         if(bonusMatches[bonusId].bonus == bonus) {
122             bonusPoints += 2;
123         }
124     }
125 
126 
127     function calculateTokenPoints (uint160 tMatchResults, uint32 tBonusMatches, uint96 tExtraStats, MatchResult[] storage matchResults, Extras storage extraStats, BonusMatch[] storage bonusMatches, bool[] starMatches) 
128     external pure returns(uint16 points){
129         
130         //Matches
131         uint160 m = tMatchResults;
132         for (uint256 i = 0; i < MATCHES_NUMBER; i++){
133             points += getMatchPoints(MATCHES_NUMBER - i - 1, m, matchResults, starMatches);
134             m = m >> 8;
135         }
136 
137         //BonusMatches
138         uint32 b = tBonusMatches;
139         for(uint256 j = 0; j < BONUS_MATCHES; j++) {
140             points += getBonusPoints(BONUS_MATCHES - j - 1, b, bonusMatches);
141             b = b >> 6;
142         }
143 
144         //Extras
145         points += getExtraPoints(tExtraStats, extraStats);
146 
147     }
148 }
149 
150 // File: contracts/dataSource/DataSourceInterface.sol
151 
152 contract DataSourceInterface {
153 
154     function isDataSource() public pure returns (bool);
155 
156     function getMatchResults() external;
157     function getExtraStats() external;
158     function getBonusResults() external;
159 
160 }
161 
162 // File: contracts/game/GameStorage.sol
163 
164 // Matches
165     // 0  Baltimore,Cleveland   Bonus
166     // 1  Denver,New York       Bonus
167     // 2  Atlanta,Pittsburgh
168     // 3  New York,Carolina
169     // 4 Minnesota,Philadelphia Bonus
170     // 5 Arizona,San Francisco
171     // 6 Los Angeles,Seattle
172     // 7 Dallas,Houston         Star
173 
174 
175 
176 
177 
178 contract GameStorage{
179 
180     event LogTokenBuilt(address creatorAddress, uint256 tokenId, string message, uint160 m, uint96 e, uint32 b);
181     event LogTokenGift(address creatorAddress, address giftedAddress, uint256 tokenId, string message, uint160 m, uint96 e, uint32 b);
182     event LogPrepaidTokenBuilt(address creatorAddress, bytes32 secret);
183     event LogPrepaidRedeemed(address redeemer, uint256 tokenId, string message, uint160 m, uint96 e, uint32 b);
184 
185     uint256 constant STARTING_PRICE = 50 finney;
186     uint256 constant FIRST_PHASE  = 1540393200;
187     uint256 constant EVENT_START = 1541084400;
188 
189     uint8 constant MATCHES_NUMBER = 20;
190     uint8 constant BONUS_MATCHES = 5;
191 
192     //6, 12, 18    
193     bool[] internal starMatches = [false, false, false, false, false, false, true, false, false, false, false, false, true, false, false, false, false, false, true, false];
194     
195     uint16 constant EXTRA_STATS_MASK = 65535;
196     uint8 constant MATCH_UNDEROVER_MASK = 1;
197     uint8 constant MATCH_RESULT_MASK = 3;
198     uint8 constant MATCH_TOUCHDOWNS_MASK = 31;
199     uint8 constant BONUS_STAT_MASK = 63;
200 
201     uint256 public prizePool = 0;
202     uint256 public adminPool = 0;
203 
204     mapping (uint256 => uint16) public tokenToPointsMap;    
205     mapping (uint256 => uint256) public tokenToPayoutMap;
206     mapping (bytes32 => uint8) public secretsMap;
207 
208 
209     address public dataSourceAddress;
210     DataSourceInterface internal dataSource;
211 
212 
213     enum pointsValidationState { Unstarted, LimitSet, LimitCalculated, OrderChecked, TopWinnersAssigned, WinnersAssigned, Finished }
214     pointsValidationState public pValidationState = pointsValidationState.Unstarted;
215 
216     uint256 internal pointsLimit = 0;
217     uint32 internal lastCalculatedToken = 0;
218     uint32 internal lastCheckedToken = 0;
219     uint32 internal winnerCounter = 0;
220     uint32 internal lastAssigned = 0;
221     uint32 internal payoutRange = 0;
222     uint32 internal lastPrizeGiven = 0;
223 
224     uint16 internal superiorQuota;
225     
226     uint16[] internal payDistributionAmount = [1,1,1,1,1,1,1,1,1,1,5,5,10,20,50,100,100,200,500,1500,2500];
227     uint24[21] internal payoutDistribution;
228 
229     uint256[] internal sortedWinners;
230 
231     PointsCalculator.MatchResult[] public matchResults;
232     PointsCalculator.BonusMatch[] public bonusMatches;
233     PointsCalculator.Extras public extraStats;
234 
235 
236 }
237 
238 // File: contracts/CryptocupStorage.sol
239 
240 contract CryptocupStorage is GameStorage {
241 
242 }
243 
244 // File: contracts/ticket/TicketInterface.sol
245 
246 /**
247  * @title ERC721 Non-Fungible Token Standard basic interface
248  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
249  */
250 interface TicketInterface {
251 
252     event Transfer(
253         address indexed from,
254         address indexed to,
255         uint256 indexed tokenId
256     );
257     event Approval(
258         address indexed owner,
259         address indexed approved,
260         uint256 indexed tokenId
261     );
262     event ApprovalForAll(
263         address indexed owner,
264         address indexed operator,
265         bool approved
266     );
267 
268 
269     function balanceOf(address owner) public view returns (uint256 balance);
270     function ownerOf(uint256 tokenId) public view returns (address owner);
271     function getOwnedTokens(address _from) public view returns(uint256[]);
272 
273 
274     function approve(address to, uint256 tokenId) public;
275     function getApproved(uint256 tokenId) public view returns (address operator);
276 
277     function setApprovalForAll(address operator, bool _approved) public;
278     function isApprovedForAll(address owner, address operator) public view returns (bool);
279 
280     function transferFrom(address from, address to, uint256 tokenId) public;
281     function safeTransferFrom(address from, address to, uint256 tokenId) public;
282 
283     function safeTransferFrom(address from, address to, uint256 tokenId, bytes data) public;
284 
285 }
286 
287 // File: contracts/ticket/TicketStorage.sol
288 
289 contract TicketStorage is TicketInterface{
290 
291     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
292     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
293     bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
294 
295     struct Token {
296         uint160 matches;
297         uint32 bonusMatches;
298         uint96 extraStats;
299         uint64 timeStamp;
300         string message;  
301     }
302     
303     // List of all tokens
304     Token[] tokens;
305 
306     mapping (uint256 => address) public tokenOwner;
307     mapping (uint256 => address) public tokenApprovals;
308     mapping (address => uint256[]) internal ownedTokens;
309     mapping (address => mapping (address => bool)) public operatorApprovals;
310 
311 }
312 
313 // File: contracts/libs/SafeMath.sol
314 
315 /**
316  * @title SafeMath
317  * @dev Math operations with safety checks that throw on error
318  */
319 library SafeMath {
320 
321   /**
322   * @dev Multiplies two numbers, throws on overflow.
323   */
324   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
325     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
326     // benefit is lost if 'b' is also tested.
327     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
328     if (_a == 0) {
329       return 0;
330     }
331 
332     c = _a * _b;
333     assert(c / _a == _b);
334     return c;
335   }
336 
337   /**
338   * @dev Integer division of two numbers, truncating the quotient.
339   */
340   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
341     // assert(_b > 0); // Solidity automatically throws when dividing by 0
342     // uint256 c = _a / _b;
343     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
344     return _a / _b;
345   }
346 
347   /**
348   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
349   */
350   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
351     assert(_b <= _a);
352     return _a - _b;
353   }
354 
355   /**
356   * @dev Adds two numbers, throws on overflow.
357   */
358   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
359     c = _a + _b;
360     assert(c >= _a);
361     return c;
362   }
363 }
364 
365 // File: contracts/helpers/AddressUtils.sol
366 
367 /**
368  * Utility library of inline functions on addresses
369  */
370 library AddressUtils {
371 
372   /**
373    * Returns whether the target address is a contract
374    * @dev This function will return false if invoked during the constructor of a contract,
375    * as the code is not actually created until after the constructor finishes.
376    * @param _addr address to check
377    * @return whether the target address is a contract
378    */
379   function isContract(address _addr) internal view returns (bool) {
380     uint256 size;
381     // XXX Currently there is no better way to check if there is a contract in an address
382     // than to check the size of the code at that address.
383     // See https://ethereum.stackexchange.com/a/14016/36603
384     // for more details about how this works.
385     // TODO Check this again before the Serenity release, because all addresses will be
386     // contracts then.
387     // solium-disable-next-line security/no-inline-assembly
388     assembly { size := extcodesize(_addr) }
389     return size > 0;
390   }
391 
392 }
393 
394 // File: contracts/access/AccessStorage.sol
395 
396 contract AccessStorage{
397 
398 	bool public paused = false;
399     bool public finalized = false;
400     
401     address public adminAddress;
402     address public dataSourceAddress;
403     address public marketplaceAddress;
404 
405     uint256 internal deploymentTime = 0;
406     uint256 public gameFinishedTime = 0; 
407     uint256 public finalizedTime = 0;
408 
409 }
410 
411 // File: contracts/access/AccessRegistry.sol
412 
413 /**
414 * @title AccessControlLayer
415 * @author CryptoCup Team (https://cryptocup.io/about)
416 * @dev Containes basic admin modifiers to restrict access to some functions. Allows
417 * for pauseing, and setting emergency stops.
418 */
419 contract AccessRegistry is AccessStorage {
420 
421 
422    /**
423    * @dev Main modifier to limit access to delicate functions.
424    */
425     modifier onlyAdmin() {
426         require(msg.sender == adminAddress, "Only admin.");
427         _;
428     }
429 
430     /**
431    * @dev Main modifier to limit access to delicate functions.
432    */
433     modifier onlyDataSource() {
434         require(msg.sender == dataSourceAddress, "Only dataSource.");
435         _;
436     }
437 
438     /**
439    * @dev Main modifier to limit access to delicate functions.
440    */
441     modifier onlyMarketPlace() {
442         require(msg.sender == marketplaceAddress, "Only marketplace.");
443         _;
444     }
445 
446 
447     /**
448     * @dev Modifier that checks that the contract is not paused
449     */
450     modifier isNotPaused() {
451         require(!paused, "Only if not paused.");
452         _;
453     }
454 
455     /**
456     * @dev Modifier that checks that the contract is paused
457     */
458     modifier isPaused() {
459         require(paused, "Only if paused.");
460         _;
461     }
462 
463     /**
464     * @dev Modifier that checks that the contract has finished successfully
465     */
466     modifier hasFinished() {
467         require((gameFinishedTime != 0) && now >= (gameFinishedTime + (15 days)), "Only if game has finished.");
468         _;
469     }
470 
471     /**
472     * @dev Modifier that checks that the contract has finalized
473     */
474     modifier hasFinalized() {
475         require(finalized, "Only if game has finalized.");
476         _;
477     }
478 
479     function setPause () internal {
480         paused = true;
481     }
482 
483     function unSetPause() internal {
484         paused = false;
485     }
486 
487     /**
488     * @dev Transfer contract's ownership
489     * @param _newAdmin Address to be set
490     */
491     function setAdmin(address _newAdmin) external onlyAdmin {
492 
493         require(_newAdmin != address(0));
494         adminAddress = _newAdmin;
495     }
496 
497      /**
498     * @dev Adds contract's mkt
499     * @param _newMkt Address to be set
500     */
501     function setMarketplaceAddress(address _newMkt) external onlyAdmin {
502 
503         require(_newMkt != address(0));
504         marketplaceAddress = _newMkt;
505     }
506 
507     /**
508     * @dev Sets the contract pause state
509     * @param state True to pause
510     */
511     function setPauseState(bool state) external onlyAdmin {
512         paused = state;
513     }
514 
515     /**
516     * @dev Sets the contract to finalized
517     * @param state True to finalize
518     */
519     function setFinalized(bool state) external onlyAdmin {
520         paused = state;
521         finalized = state;
522         if(finalized == true)
523             finalizedTime = now;
524     }
525 }
526 
527 // File: contracts/ticket/TicketRegistry.sol
528 
529 /**
530  * @title ERC721 Non-Fungible Token Standard basic implementation
531  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
532  */
533 contract TicketRegistry is TicketInterface, TicketStorage, AccessRegistry{
534 
535     using SafeMath for uint256;
536     using AddressUtils for address;
537     
538     /**
539      * @dev Gets the balance of the specified address
540      * @param _owner address to query the balance of
541      * @return uint256 representing the amount owned by the passed address
542      */
543     function balanceOf(address _owner) public view returns (uint256) {
544         require(_owner != address(0));
545         return ownedTokens[_owner].length;
546     }
547 
548     /**
549      * @dev Gets the owner of the specified token ID
550      * @param _tokenId uint256 ID of the token to query the owner of
551      * @return owner address currently marked as the owner of the given token ID
552      */
553     function ownerOf(uint256 _tokenId) public view returns (address) {
554         address owner = tokenOwner[_tokenId];
555         require(owner != address(0));
556         return owner;
557     }
558 
559     /**
560      * @dev Gets tokens of owner
561      * @param _from address of the owner
562      * @return array with token ids
563      */
564     function getOwnedTokens(address _from) public view returns(uint256[]) {
565         return ownedTokens[_from];   
566     }
567 
568     /**
569      * @dev Returns whether the specified token exists
570      * @param _tokenId uint256 ID of the token to query the existence of
571      * @return whether the token exists
572      */
573     function exists(uint256 _tokenId) public view returns (bool) {
574         address owner = tokenOwner[_tokenId];
575         return owner != address(0);
576     }
577 
578     /**
579      * @dev Approves another address to transfer the given token ID
580      * The zero address indicates there is no approved address.
581      * There can only be one approved address per token at a given time.
582      * Can only be called by the token owner or an approved operator.
583      * @param _to address to be approved for the given token ID
584      * @param _tokenId uint256 ID of the token to be approved
585      */
586     function approve(address _to, uint256 _tokenId) public {
587         address owner = ownerOf(_tokenId);
588         require(_to != owner);
589         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
590 
591         tokenApprovals[_tokenId] = _to;
592         emit Approval(owner, _to, _tokenId);
593     }
594 
595     /**
596      * @dev Gets the approved address for a token ID, or zero if no address set
597      * @param _tokenId uint256 ID of the token to query the approval of
598      * @return address currently approved for the given token ID
599      */
600     function getApproved(uint256 _tokenId) public view returns (address) {
601         return tokenApprovals[_tokenId];
602     }
603 
604     /**
605      * @dev Sets or unsets the approval of a given operator
606      * An operator is allowed to transfer all tokens of the sender on their behalf
607      * @param _to operator address to set the approval
608      * @param _approved representing the status of the approval to be set
609      */
610     function setApprovalForAll(address _to, bool _approved) public {
611         require(_to != msg.sender);
612         operatorApprovals[msg.sender][_to] = _approved;
613         emit ApprovalForAll(msg.sender, _to, _approved);
614     }
615 
616     /**
617      * @dev Tells whether an operator is approved by a given owner
618      * @param _owner owner address which you want to query the approval of
619      * @param _operator operator address which you want to query the approval of
620      * @return bool whether the given operator is approved by the given owner
621      */
622     function isApprovedForAll(address _owner, address _operator) public view returns (bool)  {
623         return operatorApprovals[_owner][_operator];
624     }
625 
626     /**
627      * @dev Transfers the ownership of a given token ID to another address
628      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
629      * Requires the msg sender to be the owner, approved, or operator
630      * @param _from current owner of the token
631      * @param _to address to receive the ownership of the given token ID
632      * @param _tokenId uint256 ID of the token to be transferred
633     */
634     function transferFrom(address _from, address _to, uint256 _tokenId) public isNotPaused{
635         
636         require(isApprovedOrOwner(msg.sender, _tokenId));
637         require(_from != address(0));
638         require(_to != address(0));
639         require (_from != _to);
640         
641         clearApproval(_from, _tokenId);
642         removeTokenFrom(_from, _tokenId);
643         addTokenTo(_to, _tokenId);
644 
645         emit Transfer(_from, _to, _tokenId);
646     }
647 
648     /**
649      * @dev Safely transfers the ownership of a given token ID to another address
650      * If the target address is a contract, it must implement `onERC721Received`,
651      * which is called upon a safe transfer, and return the magic value
652      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
653      * the transfer is reverted.
654      *
655      * Requires the msg sender to be the owner, approved, or operator
656      * @param _from current owner of the token
657      * @param _to address to receive the ownership of the given token ID
658      * @param _tokenId uint256 ID of the token to be transferred
659     */
660     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
661         // solium-disable-next-line arg-overflow
662         safeTransferFrom(_from, _to, _tokenId, "");
663     }
664 
665     /**
666      * @dev Safely transfers the ownership of a given token ID to another address
667      * If the target address is a contract, it must implement `onERC721Received`,
668      * which is called upon a safe transfer, and return the magic value
669      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
670      * the transfer is reverted.
671      * Requires the msg sender to be the owner, approved, or operator
672      * @param _from current owner of the token
673      * @param _to address to receive the ownership of the given token ID
674      * @param _tokenId uint256 ID of the token to be transferred
675      * @param _data bytes data to send along with a safe transfer check
676      */
677     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public {
678         transferFrom(_from, _to, _tokenId);
679         // solium-disable-next-line arg-overflow
680         // require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
681     }
682 
683 
684     /**
685      * @dev Returns whether the given spender can transfer a given token ID
686      * @param _spender address of the spender to query
687      * @param _tokenId uint256 ID of the token to be transferred
688      * @return bool whether the msg.sender is approved for the given token ID,
689      *  is an operator of the owner, or is the owner of the token
690      */
691     function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool){
692         address owner = ownerOf(_tokenId);
693         // Disable solium check because of
694         // https://github.com/duaraghav8/Solium/issues/175
695         // solium-disable-next-line operator-whitespace
696         return (
697             _spender == owner ||
698             getApproved(_tokenId) == _spender ||
699             isApprovedForAll(owner, _spender)
700         );
701     }
702 
703     /**
704      * @dev Internal function to mint a new token
705      * Reverts if the given token ID already exists
706      * @param _to The address that will own the minted token
707      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
708      */
709     function _mint(address _to, uint256 _tokenId) internal {
710         require(_to != address(0));
711         addTokenTo(_to, _tokenId);
712         //emit Transfer(address(0), _to, _tokenId);
713     }
714 
715     /**
716      * @dev Internal function to clear current approval of a given token ID
717      * Reverts if the given address is not indeed the owner of the token
718      * @param _owner owner of the token
719      * @param _tokenId uint256 ID of the token to be transferred
720      */
721     function clearApproval(address _owner, uint256 _tokenId) internal {
722         require(ownerOf(_tokenId) == _owner);
723         if (tokenApprovals[_tokenId] != address(0)) {
724             tokenApprovals[_tokenId] = address(0);
725         }
726     }
727 
728     /**
729      * @dev Internal function to add a token ID to the list of a given address
730      * @param _to address representing the new owner of the given token ID
731      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
732      */
733     function addTokenTo(address _to, uint256 _tokenId) internal {
734         require(tokenOwner[_tokenId] == address(0));
735         tokenOwner[_tokenId] = _to;
736         ownedTokens[_to].push(_tokenId);
737     }
738 
739     /**
740      * @dev Internal function to remove a token ID from the list of a given address
741      * @param _from address representing the previous owner of the given token ID
742      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
743      */
744     function removeTokenFrom(address _from, uint256 _tokenId) internal {
745 
746         require(ownerOf(_tokenId) == _from);
747         require(ownedTokens[_from].length < 100);
748 
749         tokenOwner[_tokenId] = address(0);
750 
751         uint256[] storage tokenArray = ownedTokens[_from];
752         for (uint256 i = 0; i < tokenArray.length; i++){
753             if(tokenArray[i] == _tokenId){
754                 tokenArray[i] = tokenArray[tokenArray.length-1];
755             }
756         }
757         
758         delete tokenArray[tokenArray.length-1];
759         tokenArray.length--;
760 
761     }
762 
763 
764 
765 }
766 
767 // File: contracts/libs/PayoutDistribution.sol
768 
769 library PayoutDistribution {
770 
771 	function getDistribution(uint256 tokenCount) external pure returns (uint24[21] payoutDistribution) {
772 
773 		if(tokenCount < 101){
774             payoutDistribution = [289700, 189700, 120000, 92500, 75000, 62500, 52500, 42500, 40000, 35600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
775         }else if(tokenCount < 201){
776             payoutDistribution = [265500, 165500, 105500, 75500, 63000, 48000, 35500, 20500, 20000, 19500, 18500, 17800, 0, 0, 0, 0, 0, 0, 0, 0, 0];
777         }else if(tokenCount < 301){
778             payoutDistribution = [260700, 155700, 100700, 70900, 60700, 45700, 35500, 20500, 17900, 12500, 11500, 11000, 10670, 0, 0, 0, 0, 0, 0, 0, 0];
779         }else if(tokenCount < 501){
780             payoutDistribution = [238600, 138600, 88800, 63800, 53800, 43800, 33800, 18800, 17500, 12500, 9500, 7500, 7100, 6700, 0, 0, 0, 0, 0, 0, 0];
781         }else if(tokenCount < 1001){
782             payoutDistribution = [218300, 122300, 72300, 52400, 43900, 33900, 23900, 16000, 13000, 10000, 9000, 7000, 5000, 4000, 3600, 0, 0, 0, 0, 0, 0];
783         }else if(tokenCount < 2001){
784             payoutDistribution = [204500, 114000, 64000, 44100, 35700, 26700, 22000, 15000, 11000, 9500, 8500, 6500, 4600, 2500, 2000, 1800, 0, 0, 0, 0, 0];
785         }else if(tokenCount < 3001){
786             payoutDistribution = [189200, 104800, 53900, 34900, 29300, 19300, 15300, 14000, 10500, 8300, 8000, 6000, 3800, 2500, 2000, 1500, 1100, 0, 0, 0, 0];
787         }else if(tokenCount < 5001){
788             payoutDistribution = [178000, 100500, 47400, 30400, 24700, 15500, 15000, 12000, 10200, 7800, 7400, 5500, 3300, 2000, 1500, 1200, 900, 670, 0, 0, 0];
789         }else if(tokenCount < 10001){
790             payoutDistribution = [157600, 86500, 39000, 23100, 18900, 15000, 14000, 11000, 9300, 6100, 6000, 5000, 3800, 1500, 1100, 900, 700, 500, 360, 0, 0];
791         }else if(tokenCount < 25001){
792             payoutDistribution = [132500, 70200, 31300, 18500, 17500, 14000, 13500, 10500, 7500, 5500, 5000, 4000, 3000, 1000, 900, 700, 600, 400, 200, 152, 0];
793         } else {
794             payoutDistribution = [120000, 63000,  27000, 18800, 17300, 13700, 13000, 10000, 6300, 5000, 4500, 3900, 2500, 900, 800, 600, 500, 350, 150, 100, 70];
795         }
796 	}
797 
798 	function getSuperiorQuota(uint256 tokenCount) external pure returns (uint16 superiorQuota){
799 
800 		if(tokenCount < 101){
801             superiorQuota = 10;
802         }else if(tokenCount < 201){
803             superiorQuota = 20;
804         }else if(tokenCount < 301){
805             superiorQuota = 30;
806         }else if(tokenCount < 501){
807             superiorQuota = 50;
808         }else if(tokenCount < 1001){
809             superiorQuota = 100;
810         }else if(tokenCount < 2001){
811             superiorQuota = 200;
812         }else if(tokenCount < 3001){
813             superiorQuota = 300;
814         }else if(tokenCount < 5001){
815             superiorQuota = 500;
816         }else if(tokenCount < 10001){
817             superiorQuota = 1000;
818         }else if(tokenCount < 25001){
819             superiorQuota = 2500;
820         } else {
821             superiorQuota = 5000;
822         }
823 	}
824 
825 }
826 
827 // File: contracts/game/GameRegistry.sol
828 
829 contract GameRegistry is CryptocupStorage, TicketRegistry{
830 	
831     using PointsCalculator for PointsCalculator.MatchResult;
832     using PointsCalculator for PointsCalculator.BonusMatch;
833     using PointsCalculator for PointsCalculator.Extras;
834 
835      /**
836     * @dev Checks if pValidationState is in the provided stats
837     * @param state State required to run
838     */
839     modifier checkState(pointsValidationState state){
840         require(pValidationState == state, "Points validation stage invalid.");
841         _;
842     }
843     
844     /**
845     * @notice Gets current token price 
846     */
847     function _getTokenPrice() internal view returns(uint256 tokenPrice){
848 
849         if (now >= FIRST_PHASE) {
850             tokenPrice = (80 finney);
851         } else {
852             tokenPrice = STARTING_PRICE;
853         }
854 
855         require(tokenPrice >= STARTING_PRICE && tokenPrice <= (80 finney));
856 
857     }
858 
859     function _prepareMatchResultsArray() internal {
860         matchResults.length = MATCHES_NUMBER;
861     }
862 
863     function _prepareBonusResultsArray() internal {
864         bonusMatches.length = BONUS_MATCHES;
865     }
866 
867     /** 
868     * @notice Builds ERC721 token with the predictions provided by the user.
869     * @param matches  - Matches results (who wins, amount of points)
870     * @param bonusMatches -  Stats from bonus matches
871     * @param extraStats - Total number of extra stats like touchdonws, etc.
872     * @dev An automatic timestamp is added for internal use.
873     */
874     function _createToken(uint160 matches, uint32 bonusMatches, uint96 extraStats, string userMessage) internal returns (uint256){
875 
876         Token memory token = Token({
877             matches: matches,
878             bonusMatches: bonusMatches,
879             extraStats: extraStats,
880             timeStamp: uint64(now),
881             message: userMessage
882         });
883 
884         uint256 tokenId = tokens.push(token) - 1;
885         require(tokenId == uint256(uint32(tokenId)), "Failed to convert tokenId to uint256.");
886         
887         return tokenId;
888     }
889 
890     /**
891     * @dev Sets the data source contract address 
892     * @param _address Address to be set
893     */
894     function setDataSourceAddress(address _address) external onlyAdmin {
895         
896         DataSourceInterface c = DataSourceInterface(_address);
897 
898         require(c.isDataSource());
899 
900         dataSource = c;
901         dataSourceAddress = _address;
902     }
903 
904 
905     /**
906     * @notice Called by the development team once the World Cup has ended (adminPool is set) 
907     * @dev Allows dev team to retrieve adminPool
908     */
909     function adminWithdrawBalance() external onlyAdmin {
910 
911         uint256 adminPrize = adminPool;
912 
913         adminPool = 0;
914         adminAddress.transfer(adminPrize);
915 
916     }
917 
918 
919      /**
920     * @notice Let the admin cash-out the entire contract balance 10 days after game has finished.
921     */
922     function finishedGameWithdraw() external onlyAdmin hasFinished{
923 
924         uint256 balance = address(this).balance;
925         adminAddress.transfer(balance);
926 
927     }
928     
929     /**
930     * @notice Let the admin cash-out the entire contract balance 10 days after game has finished.
931     */
932     function emergencyWithdrawAdmin() external hasFinalized onlyAdmin{
933 
934         require(finalizedTime != 0 &&  now >= finalizedTime + 10 days );
935         msg.sender.transfer(address(this).balance);
936 
937     }
938 
939 
940     function isDataSourceCallback() external pure returns (bool){
941         return true;
942     }
943 
944     function dataSourceGetMatchesResults() external onlyAdmin {
945         dataSource.getMatchResults();
946     }
947 
948     function dataSourceGetBonusResults() external onlyAdmin{
949         dataSource.getBonusResults();
950     }
951 
952     function dataSourceGetExtraStats() external onlyAdmin{
953         dataSource.getExtraStats();
954     }
955 
956     function dataSourceCallbackMatch(uint160 matches) external onlyDataSource{
957         uint160 m = matches;
958         for(uint256 i = 0; i < MATCHES_NUMBER; i++) {
959             matchResults[MATCHES_NUMBER - i - 1].result = uint8(m & MATCH_RESULT_MASK);
960             matchResults[MATCHES_NUMBER - i - 1].under49 = uint8((m >> 2) & MATCH_UNDEROVER_MASK);
961             matchResults[MATCHES_NUMBER - i - 1].touchdowns = uint8((m >> 3) & MATCH_TOUCHDOWNS_MASK);
962             m = m >> 8;
963         }
964     }
965 
966     function dataSourceCallbackBonus(uint32 bonusResults) external onlyDataSource{
967         uint32 b = bonusResults;
968         for(uint256 i = 0; i < BONUS_MATCHES; i++) {
969             bonusMatches[BONUS_MATCHES - i - 1].bonus = uint8(b & BONUS_STAT_MASK);
970             b = b >> 6;
971         }
972     }
973 
974     function dataSourceCallbackExtras(uint96 es) external onlyDataSource{
975         uint96 e = es;
976         extraStats.interceptions = uint16(e & EXTRA_STATS_MASK);
977         e = e >> 16;
978         extraStats.missedFieldGoals = uint16(e & EXTRA_STATS_MASK);
979         e = e >> 16;
980         extraStats.overtimes = uint16(e & EXTRA_STATS_MASK);
981         e = e >> 16;
982         extraStats.sacks = uint16(e & EXTRA_STATS_MASK);
983         e = e >> 16;
984         extraStats.fieldGoals = uint16(e & EXTRA_STATS_MASK);
985         e = e >> 16;
986         extraStats.fumbles = uint16(e & EXTRA_STATS_MASK);
987     }
988 
989     /**
990     * @notice Sets the points of all the tokens between the last chunk set and the amount given.
991     * @dev This function uses all the data collected earlier by oraclize to calculate points.
992     * @param amount The amount of tokens that should be analyzed.
993     */
994     function calculatePointsBlock(uint32 amount) external{
995 
996         require (gameFinishedTime == 0);
997         require(amount + lastCheckedToken <= tokens.length);
998 
999         for (uint256 i = lastCalculatedToken; i < (lastCalculatedToken + amount); i++) {
1000             uint16 points = PointsCalculator.calculateTokenPoints(tokens[i].matches, tokens[i].bonusMatches,
1001                 tokens[i].extraStats, matchResults, extraStats, bonusMatches, starMatches);
1002             tokenToPointsMap[i] = points;
1003         }
1004 
1005         lastCalculatedToken += amount;
1006     }
1007 
1008     /**
1009     * @notice Sets the structures for payout distribution, last position and superior quota. Payout distribution is the
1010     * percentage of the pot each position gets, last position is the percentage of the pot the last position gets,
1011     * and superior quota is the total amount OF winners that are given a prize.
1012     * @dev Each of this structures is dynamic and is assigned depending on the total amount of tokens in the game  
1013     */
1014     function setPayoutDistributionId () internal {
1015 
1016         uint24[21] memory auxArr = PayoutDistribution.getDistribution(tokens.length);
1017 
1018         for(uint256 i = 0; i < auxArr.length; i++){
1019             payoutDistribution[i] = auxArr[i];
1020         }
1021         
1022         superiorQuota = PayoutDistribution.getSuperiorQuota(tokens.length);
1023     }
1024 
1025     /**
1026     * @notice Sets the id of the last token that will be given a prize.
1027     * @dev This is done to offload some of the calculations needed for sorting, and to cap the number of sorts
1028     * needed to just the winners and not the whole array of tokens.
1029     * @param tokenId last token id
1030     */
1031     function setLimit(uint256 tokenId) external onlyAdmin{
1032         require(tokenId < tokens.length);
1033         require(pValidationState == pointsValidationState.Unstarted || pValidationState == pointsValidationState.LimitSet);
1034         pointsLimit = tokenId;
1035         pValidationState = pointsValidationState.LimitSet;
1036         lastCheckedToken = 0;
1037         lastCalculatedToken = 0;
1038         winnerCounter = 0;
1039         
1040         setPause();
1041         setPayoutDistributionId();
1042     }
1043 
1044 
1045     /**
1046     * @notice Sets the 10th percentile of the sorted array of points
1047     * @param amount tokens in a chunk
1048     */
1049     function calculateWinners(uint32 amount) external onlyAdmin checkState(pointsValidationState.LimitSet){
1050         require(amount + lastCheckedToken <= tokens.length);
1051         uint256 points = tokenToPointsMap[pointsLimit];
1052 
1053         for(uint256 i = lastCheckedToken; i < lastCheckedToken + amount; i++){
1054             if(tokenToPointsMap[i] > points ||
1055                 (tokenToPointsMap[i] == points && i <= pointsLimit)){
1056                 winnerCounter++;
1057             }
1058         }
1059         lastCheckedToken += amount;
1060 
1061         if(lastCheckedToken == tokens.length){
1062             require(superiorQuota == winnerCounter);
1063             pValidationState = pointsValidationState.LimitCalculated;
1064         }
1065     }
1066 
1067     /**
1068     * @notice Checks if the order given offchain coincides with the order of the actual previously calculated points
1069     * in the smart contract.
1070     * @dev the token sorting is done offchain so as to save on the huge amount of gas and complications that 
1071     * could occur from doing all the sorting onchain.
1072     * @param sortedChunk chunk sorted by points
1073     */
1074     function checkOrder(uint32[] sortedChunk) external onlyAdmin checkState(pointsValidationState.LimitCalculated){
1075         require(sortedChunk.length + sortedWinners.length <= winnerCounter);
1076 
1077         for(uint256 i = 0; i < sortedChunk.length - 1; i++){
1078             uint256 id = sortedChunk[i];
1079             uint256 sigId = sortedChunk[i+1];
1080             require(tokenToPointsMap[id] > tokenToPointsMap[sigId] || (tokenToPointsMap[id] == tokenToPointsMap[sigId] &&
1081                 id < sigId));
1082         }
1083 
1084         if(sortedWinners.length != 0){
1085             uint256 id2 = sortedWinners[sortedWinners.length-1];
1086             uint256 sigId2 = sortedChunk[0];
1087             require(tokenToPointsMap[id2] > tokenToPointsMap[sigId2] ||
1088                 (tokenToPointsMap[id2] == tokenToPointsMap[sigId2] && id2 < sigId2));
1089         }
1090 
1091         for(uint256 j = 0; j < sortedChunk.length; j++){
1092             sortedWinners.push(sortedChunk[j]);
1093         }
1094 
1095         if(sortedWinners.length == winnerCounter){
1096             require(sortedWinners[sortedWinners.length-1] == pointsLimit);
1097             pValidationState = pointsValidationState.OrderChecked;
1098         }
1099 
1100     }
1101 
1102     /**
1103     * @notice If anything during the point calculation and sorting part should fail, this function can reset 
1104     * data structures to their initial position, so as to  
1105     */
1106     function resetWinners(uint256 newLength) external onlyAdmin checkState(pointsValidationState.LimitCalculated){
1107         
1108         sortedWinners.length = newLength;
1109     
1110     }
1111 
1112     /**
1113     * @notice Assigns prize percentage for the lucky top 30 winners. Each token will be assigned a uint256 inside
1114     * tokenToPayoutMap structure that represents the size of the pot that belongs to that token. If any tokens
1115     * tie inside of the first 30 tokens, the prize will be summed and divided equally. 
1116     */
1117     function setTopWinnerPrizes() external onlyAdmin checkState(pointsValidationState.OrderChecked){
1118 
1119         uint256 percent = 0;
1120         uint[] memory tokensEquals = new uint[](30);
1121         uint16 tokenEqualsCounter = 0;
1122         uint256 currentTokenId;
1123         uint256 currentTokenPoints;
1124         uint256 lastTokenPoints;
1125         uint32 counter = 0;
1126         uint256 maxRange = 13;
1127         if(tokens.length < 201){
1128             maxRange = 10;
1129         }
1130         
1131 
1132         while(payoutRange < maxRange){
1133             uint256 inRangecounter = payDistributionAmount[payoutRange];
1134             while(inRangecounter > 0){
1135                 currentTokenId = sortedWinners[counter];
1136                 currentTokenPoints = tokenToPointsMap[currentTokenId];
1137 
1138                 inRangecounter--;
1139 
1140                 //Special case for the last one
1141                 if(inRangecounter == 0 && payoutRange == maxRange - 1){
1142                     if(currentTokenPoints == lastTokenPoints){
1143                         percent += payoutDistribution[payoutRange];
1144                         tokensEquals[tokenEqualsCounter] = currentTokenId;
1145                         tokenEqualsCounter++;
1146                     } else {
1147                         tokenToPayoutMap[currentTokenId] = payoutDistribution[payoutRange];
1148                     }
1149                 }
1150 
1151                 //Fix second condition
1152                 if(counter != 0 && (currentTokenPoints != lastTokenPoints || (inRangecounter == 0 && payoutRange == maxRange - 1))){ 
1153                     for(uint256 i = 0; i < tokenEqualsCounter; i++){
1154                         tokenToPayoutMap[tokensEquals[i]] = percent.div(tokenEqualsCounter);
1155                     }
1156                     percent = 0;
1157                     tokensEquals = new uint[](30);
1158                     tokenEqualsCounter = 0;
1159                 }
1160 
1161                 percent += payoutDistribution[payoutRange];
1162                 tokensEquals[tokenEqualsCounter] = currentTokenId;
1163                 
1164                 tokenEqualsCounter++;
1165                 counter++;
1166 
1167                 lastTokenPoints = currentTokenPoints;
1168             }
1169             payoutRange++;
1170         }
1171 
1172         pValidationState = pointsValidationState.TopWinnersAssigned;
1173         lastPrizeGiven = counter;
1174     }
1175 
1176     /**
1177     * @notice Sets prize percentage to every address that wins from the position 30th onwards
1178     * @dev If there are less than 300 tokens playing, then this function will set nothing.
1179     * @param amount tokens in a chunk
1180     */
1181     function setWinnerPrizes(uint32 amount) external onlyAdmin checkState(pointsValidationState.TopWinnersAssigned){
1182         require(lastPrizeGiven + amount <= winnerCounter);
1183         
1184         uint16 inRangeCounter = payDistributionAmount[payoutRange];
1185         for(uint256 i = 0; i < amount; i++){
1186             if (inRangeCounter == 0){
1187                 payoutRange++;
1188                 inRangeCounter = payDistributionAmount[payoutRange];
1189             }
1190 
1191             uint256 tokenId = sortedWinners[i + lastPrizeGiven];
1192 
1193             tokenToPayoutMap[tokenId] = payoutDistribution[payoutRange];
1194 
1195             inRangeCounter--;
1196         }
1197         //i + amount prize was not given yet, so amount -1
1198         lastPrizeGiven += amount;
1199         payDistributionAmount[payoutRange] = inRangeCounter;
1200 
1201         if(lastPrizeGiven == winnerCounter){
1202             pValidationState = pointsValidationState.WinnersAssigned;
1203             return;
1204         }
1205     }
1206 
1207 
1208      /**
1209     * @notice Sets prizes for last tokens and sets prize pool amount
1210     */
1211     function setEnd() external onlyAdmin checkState(pointsValidationState.WinnersAssigned){
1212             
1213         uint256 balance = address(this).balance;
1214         adminPool = balance.mul(10).div(100);
1215         prizePool = balance.mul(90).div(100);
1216 
1217         pValidationState = pointsValidationState.Finished;
1218         gameFinishedTime = now;
1219         unSetPause();
1220     }
1221 
1222 }
1223 
1224 // File: contracts/CryptocupNFL.sol
1225 
1226 contract CryptocupNFL is GameRegistry {
1227 
1228 	constructor() public {
1229         adminAddress = msg.sender;
1230         deploymentTime = now;
1231 
1232         _prepareMatchResultsArray();
1233         _prepareBonusResultsArray();
1234     }
1235 
1236      /** 
1237     * @dev Only accept eth from the admin
1238     */
1239     function() external payable {
1240         require(msg.sender == adminAddress || msg.sender == marketplaceAddress);
1241 
1242     }
1243 
1244     function buildToken(uint160 matches, uint32 bonusMatches, uint96 extraStats, string message) external payable isNotPaused returns(uint256){
1245 
1246         require(msg.value >= _getTokenPrice(), "Eth sent is not enough.");
1247         require(msg.sender != address(0), "Sender cannot be 0 address.");
1248         require(ownedTokens[msg.sender].length < 100, "Sender cannot have more than 100 tokens.");
1249         require(now < EVENT_START, "Event already started."); //Event Start
1250         require (bytes(message).length <= 100);
1251         
1252 
1253         uint256 tokenId = _createToken(matches, bonusMatches, extraStats, message);
1254         
1255         _mint(msg.sender, tokenId);
1256         
1257         emit LogTokenBuilt(msg.sender, tokenId, message, matches, extraStats, bonusMatches);
1258 
1259         return tokenId;
1260     }
1261 
1262     function giftToken(address giftedAddress, uint160 matches, uint32 bonusMatches, uint96 extraStats, string message) external payable isNotPaused returns(uint256){
1263 
1264         require(msg.value >= _getTokenPrice(), "Eth sent is not enough.");
1265         require(msg.sender != address(0), "Sender cannot be 0 address.");
1266         require(ownedTokens[giftedAddress].length < 100, "Sender cannot have more than 100 tokens.");
1267         require(now < EVENT_START, "Event already started."); //Event Start
1268         require (bytes(message).length <= 100);
1269 
1270         uint256 tokenId = _createToken(matches, bonusMatches, extraStats, message);
1271 
1272         _mint(giftedAddress, tokenId);
1273         
1274         emit LogTokenGift(msg.sender, giftedAddress, tokenId, message, matches, extraStats, bonusMatches);
1275 
1276         return tokenId;
1277     }
1278 
1279     function buildPrepaidToken(bytes32 secret) external payable onlyAdmin isNotPaused {
1280 
1281         require(msg.value >= _getTokenPrice(), "Eth sent is not enough.");
1282         require(msg.sender != address(0), "Sender cannot be 0 address.");
1283         require(now < EVENT_START, "Event already started."); //Event Start
1284 
1285         secretsMap[secret] = 1;
1286         
1287         emit LogPrepaidTokenBuilt(msg.sender, secret);
1288     }
1289 
1290     function redeemPrepaidToken(bytes32 preSecret, uint160 matches, uint32 bonusMatches, uint96 extraStats, string message) external isNotPaused returns(uint256){
1291 
1292         require(msg.sender != address(0), "Sender cannot be 0 address.");
1293         require(ownedTokens[msg.sender].length < 100, "Sender cannot have more than 100 tokens.");
1294         require(now < EVENT_START, "Event already started."); //Event Start
1295         require (bytes(message).length <= 100);
1296 
1297         bytes32 secret = keccak256(preSecret);
1298 
1299         require (secretsMap[secret] == 1, "Invalid secret.");
1300         
1301         secretsMap[secret] = 0;
1302 
1303         uint256 tokenId = _createToken(matches, bonusMatches, extraStats, message);
1304         _mint(msg.sender, tokenId);
1305         
1306         emit LogPrepaidRedeemed(msg.sender, tokenId, message, matches, extraStats, bonusMatches);
1307 
1308         return tokenId;
1309     }
1310 
1311 
1312     /** 
1313     * @param tokenId - ID of token to get.
1314     * @return Returns all the valuable information about a specific token.
1315     */
1316     function getToken(uint256 tokenId) external view returns (uint160 matches, uint32 bonusMatches, uint96 extraStats, uint64 timeStamp, string message) {
1317 
1318         Token storage token = tokens[tokenId];
1319 
1320         matches = token.matches;
1321         bonusMatches = token.bonusMatches;
1322         extraStats = token.extraStats;
1323         timeStamp = token.timeStamp;
1324         message = token.message;
1325 
1326     }
1327 
1328     /**
1329     * @notice Allows any user to retrieve their asigned prize. This would be the sum of the price of all the tokens
1330     * owned by the caller of this function.
1331     * @dev If the caller has no prize, the function will revert costing no gas to the caller.
1332     */
1333     function withdrawPrize() external checkState(pointsValidationState.Finished){
1334         
1335         uint256 prize = 0;
1336         uint256[] memory tokenList = ownedTokens[msg.sender];
1337         
1338         for(uint256 i = 0;i < tokenList.length; i++){
1339             prize += tokenToPayoutMap[tokenList[i]];
1340             tokenToPayoutMap[tokenList[i]] = 0;
1341         }
1342         
1343         require(prize > 0);
1344         msg.sender.transfer((prizePool.mul(prize)).div(1000000));   
1345     }
1346 
1347 
1348     //EMERGENCY CALLS
1349     //If something goes wrong or fails, these functions will allow retribution for token holders 
1350 
1351     /**
1352     * @notice if there is an unresolvable problem, users can call to this function to get a refund.
1353     */
1354     function emergencyWithdraw() external hasFinalized{
1355 
1356         uint256 balance = STARTING_PRICE * ownedTokens[msg.sender].length;
1357 
1358         delete ownedTokens[msg.sender];
1359         msg.sender.transfer(balance);
1360 
1361     }
1362 
1363 }