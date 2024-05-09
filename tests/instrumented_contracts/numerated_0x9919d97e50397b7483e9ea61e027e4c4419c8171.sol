1 pragma solidity ^0.4.24;
2 
3 interface ConflictResolutionInterface {
4     function minHouseStake(uint activeGames) external pure returns(uint);
5 
6     function maxBalance() external pure returns(int);
7 
8     function conflictEndFine() external pure returns(int);
9 
10     function isValidBet(uint8 _gameType, uint _betNum, uint _betValue) external pure returns(bool);
11 
12     function endGameConflict(
13         uint8 _gameType,
14         uint _betNum,
15         uint _betValue,
16         int _balance,
17         uint _stake,
18         bytes32 _serverSeed,
19         bytes32 _userSeed
20     )
21         external
22         view
23         returns(int);
24 
25     function serverForceGameEnd(
26         uint8 gameType,
27         uint _betNum,
28         uint _betValue,
29         int _balance,
30         uint _stake,
31         uint _endInitiatedTime
32     )
33         external
34         view
35         returns(int);
36 
37     function userForceGameEnd(
38         uint8 _gameType,
39         uint _betNum,
40         uint _betValue,
41         int _balance,
42         uint _stake,
43         uint _endInitiatedTime
44     )
45         external
46         view
47         returns(int);
48 }
49 
50 library MathUtil {
51     /**
52      * @dev Returns the absolute value of _val.
53      * @param _val value
54      * @return The absolute value of _val.
55      */
56     function abs(int _val) internal pure returns(uint) {
57         if (_val < 0) {
58             return uint(-_val);
59         } else {
60             return uint(_val);
61         }
62     }
63 
64     /**
65      * @dev Calculate maximum.
66      */
67     function max(uint _val1, uint _val2) internal pure returns(uint) {
68         return _val1 >= _val2 ? _val1 : _val2;
69     }
70 
71     /**
72      * @dev Calculate minimum.
73      */
74     function min(uint _val1, uint _val2) internal pure returns(uint) {
75         return _val1 <= _val2 ? _val1 : _val2;
76     }
77 }
78 
79 contract Ownable {
80     address public owner;
81     address public pendingOwner;
82 
83     event LogOwnerShipTransferred(address indexed previousOwner, address indexed newOwner);
84     event LogOwnerShipTransferInitiated(address indexed previousOwner, address indexed newOwner);
85 
86     /**
87      * @dev Modifier, which throws if called by other account than owner.
88      */
89     modifier onlyOwner {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     /**
95      * @dev Modifier throws if called by any account other than the pendingOwner.
96      */
97     modifier onlyPendingOwner() {
98         require(msg.sender == pendingOwner);
99         _;
100     }
101 
102     /**
103      * @dev Set contract creator as initial owner
104      */
105     constructor() public {
106         owner = msg.sender;
107         pendingOwner = address(0);
108     }
109 
110     /**
111      * @dev Allows the current owner to set the pendingOwner address.
112      * @param _newOwner The address to transfer ownership to.
113      */
114     function transferOwnership(address _newOwner) public onlyOwner {
115         pendingOwner = _newOwner;
116         emit LogOwnerShipTransferInitiated(owner, _newOwner);
117     }
118 
119     /**
120      * @dev PendingOwner can accept ownership.
121      */
122     function claimOwnership() public onlyPendingOwner {
123         owner = pendingOwner;
124         pendingOwner = address(0);
125         emit LogOwnerShipTransferred(owner, pendingOwner);
126     }
127 }
128 
129 contract Activatable is Ownable {
130     bool public activated = false;
131 
132     /// @dev Event is fired if activated.
133     event LogActive();
134 
135     /// @dev Modifier, which only allows function execution if activated.
136     modifier onlyActivated() {
137         require(activated);
138         _;
139     }
140 
141     /// @dev Modifier, which only allows function execution if not activated.
142     modifier onlyNotActivated() {
143         require(!activated);
144         _;
145     }
146 
147     /// @dev activate contract, can be only called once by the contract owner.
148     function activate() public onlyOwner onlyNotActivated {
149         activated = true;
150         emit LogActive();
151     }
152 }
153 
154 contract ConflictResolutionManager is Ownable {
155     /// @dev Conflict resolution contract.
156     ConflictResolutionInterface public conflictRes;
157 
158     /// @dev New Conflict resolution contract.
159     address public newConflictRes = 0;
160 
161     /// @dev Time update of new conflict resolution contract was initiated.
162     uint public updateTime = 0;
163 
164     /// @dev Min time before new conflict res contract can be activated after initiating update.
165     uint public constant MIN_TIMEOUT = 3 days;
166 
167     /// @dev Min time before new conflict res contract can be activated after initiating update.
168     uint public constant MAX_TIMEOUT = 6 days;
169 
170     /// @dev Update of conflict resolution contract was initiated.
171     event LogUpdatingConflictResolution(address newConflictResolutionAddress);
172 
173     /// @dev New conflict resolution contract is active.
174     event LogUpdatedConflictResolution(address newConflictResolutionAddress);
175 
176     /**
177      * @dev Constructor
178      * @param _conflictResAddress conflict resolution contract address.
179      */
180     constructor(address _conflictResAddress) public {
181         conflictRes = ConflictResolutionInterface(_conflictResAddress);
182     }
183 
184     /**
185      * @dev Initiate conflict resolution contract update.
186      * @param _newConflictResAddress New conflict resolution contract address.
187      */
188     function updateConflictResolution(address _newConflictResAddress) public onlyOwner {
189         newConflictRes = _newConflictResAddress;
190         updateTime = block.timestamp;
191 
192         emit LogUpdatingConflictResolution(_newConflictResAddress);
193     }
194 
195     /**
196      * @dev Active new conflict resolution contract.
197      */
198     function activateConflictResolution() public onlyOwner {
199         require(newConflictRes != 0);
200         require(updateTime != 0);
201         require(updateTime + MIN_TIMEOUT <= block.timestamp && block.timestamp <= updateTime + MAX_TIMEOUT);
202 
203         conflictRes = ConflictResolutionInterface(newConflictRes);
204         newConflictRes = 0;
205         updateTime = 0;
206 
207         emit LogUpdatedConflictResolution(newConflictRes);
208     }
209 }
210 
211 contract Pausable is Activatable {
212     using SafeMath for uint;
213 
214     /// @dev Is contract paused. Initial it is paused.
215     bool public paused = true;
216 
217     /// @dev Time pause was called
218     uint public timePaused = block.timestamp;
219 
220     /// @dev Modifier, which only allows function execution if not paused.
221     modifier onlyNotPaused() {
222         require(!paused, "paused");
223         _;
224     }
225 
226     /// @dev Modifier, which only allows function execution if paused.
227     modifier onlyPaused() {
228         require(paused);
229         _;
230     }
231 
232     /// @dev Modifier, which only allows function execution if paused longer than timeSpan.
233     modifier onlyPausedSince(uint timeSpan) {
234         require(paused && (timePaused.add(timeSpan) <= block.timestamp));
235         _;
236     }
237 
238     /// @dev Event is fired if paused.
239     event LogPause();
240 
241     /// @dev Event is fired if pause is ended.
242     event LogUnpause();
243 
244     /**
245      * @dev Pause contract. No new game sessions can be created.
246      */
247     function pause() public onlyOwner onlyNotPaused {
248         paused = true;
249         timePaused = block.timestamp;
250         emit LogPause();
251     }
252 
253     /**
254      * @dev Unpause contract. Initial contract is paused and can only be unpaused after activating it.
255      */
256     function unpause() public onlyOwner onlyPaused onlyActivated {
257         paused = false;
258         timePaused = 0;
259         emit LogUnpause();
260     }
261 }
262 
263 contract Destroyable is Pausable {
264     /// @dev After pausing the contract for 20 days owner can selfdestruct it.
265     uint public constant TIMEOUT_DESTROY = 20 days;
266 
267     /**
268      * @dev Destroy contract and transfer ether to owner.
269      */
270     function destroy() public onlyOwner onlyPausedSince(TIMEOUT_DESTROY) {
271         selfdestruct(owner);
272     }
273 }
274 
275 contract GameChannelBase is Destroyable, ConflictResolutionManager {
276     using SafeCast for int;
277     using SafeCast for uint;
278     using SafeMath for int;
279     using SafeMath for uint;
280 
281 
282     /// @dev Different game session states.
283     enum GameStatus {
284         ENDED, ///< @dev Game session is ended.
285         ACTIVE, ///< @dev Game session is active.
286         USER_INITIATED_END, ///< @dev User initiated non regular end.
287         SERVER_INITIATED_END ///< @dev Server initiated non regular end.
288     }
289 
290     /// @dev Reason game session ended.
291     enum ReasonEnded {
292         REGULAR_ENDED, ///< @dev Game session is regularly ended.
293         SERVER_FORCED_END, ///< @dev User did not respond. Server forced end.
294         USER_FORCED_END, ///< @dev Server did not respond. User forced end.
295         CONFLICT_ENDED ///< @dev Server or user raised conflict ans pushed game state, opponent pushed same game state.
296     }
297 
298     struct Game {
299         /// @dev Game session status.
300         GameStatus status;
301 
302         /// @dev User's stake.
303         uint128 stake;
304 
305         /// @dev Last game round info if not regularly ended.
306         /// If game session is ended normally this data is not used.
307         uint8 gameType;
308         uint32 roundId;
309         uint betNum;
310         uint betValue;
311         int balance;
312         bytes32 userSeed;
313         bytes32 serverSeed;
314         uint endInitiatedTime;
315     }
316 
317     /// @dev Minimal time span between profit transfer.
318     uint public constant MIN_TRANSFER_TIMESPAN = 1 days;
319 
320     /// @dev Maximal time span between profit transfer.
321     uint public constant MAX_TRANSFER_TIMSPAN = 6 * 30 days;
322 
323     bytes32 public constant EIP712DOMAIN_TYPEHASH = keccak256(
324         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
325     );
326 
327     bytes32 public constant BET_TYPEHASH = keccak256(
328         "Bet(uint32 roundId,uint8 gameType,uint256 number,uint256 value,int256 balance,bytes32 serverHash,bytes32 userHash,uint256 gameId)"
329     );
330 
331     bytes32 public DOMAIN_SEPERATOR;
332 
333     /// @dev Current active game sessions.
334     uint public activeGames = 0;
335 
336     /// @dev Game session id counter. Points to next free game session slot. So gameIdCntr -1 is the
337     // number of game sessions created.
338     uint public gameIdCntr = 1;
339 
340     /// @dev Only this address can accept and end games.
341     address public serverAddress;
342 
343     /// @dev Address to transfer profit to.
344     address public houseAddress;
345 
346     /// @dev Current house stake.
347     uint public houseStake = 0;
348 
349     /// @dev House profit since last profit transfer.
350     int public houseProfit = 0;
351 
352     /// @dev Min value user needs to deposit for creating game session.
353     uint128 public minStake;
354 
355     /// @dev Max value user can deposit for creating game session.
356     uint128 public maxStake;
357 
358     /// @dev Timeout until next profit transfer is allowed.
359     uint public profitTransferTimeSpan = 14 days;
360 
361     /// @dev Last time profit transferred to house.
362     uint public lastProfitTransferTimestamp;
363 
364     /// @dev Maps gameId to game struct.
365     mapping (uint => Game) public gameIdGame;
366 
367     /// @dev Maps user address to current user game id.
368     mapping (address => uint) public userGameId;
369 
370     /// @dev Maps user address to pending returns.
371     mapping (address => uint) public pendingReturns;
372 
373     /// @dev Modifier, which only allows to execute if house stake is high enough.
374     modifier onlyValidHouseStake(uint _activeGames) {
375         uint minHouseStake = conflictRes.minHouseStake(_activeGames);
376         require(houseStake >= minHouseStake, "inv houseStake");
377         _;
378     }
379 
380     /// @dev Modifier to check if value send fulfills user stake requirements.
381     modifier onlyValidValue() {
382         require(minStake <= msg.value && msg.value <= maxStake, "inv stake");
383         _;
384     }
385 
386     /// @dev Modifier, which only allows server to call function.
387     modifier onlyServer() {
388         require(msg.sender == serverAddress);
389         _;
390     }
391 
392     /// @dev Modifier, which only allows to set valid transfer timeouts.
393     modifier onlyValidTransferTimeSpan(uint transferTimeout) {
394         require(transferTimeout >= MIN_TRANSFER_TIMESPAN
395                 && transferTimeout <= MAX_TRANSFER_TIMSPAN);
396         _;
397     }
398 
399     /// @dev This event is fired when user creates game session.
400     event LogGameCreated(address indexed user, uint indexed gameId, uint128 stake, bytes32 indexed serverEndHash, bytes32 userEndHash);
401 
402     /// @dev This event is fired when user requests conflict end.
403     event LogUserRequestedEnd(address indexed user, uint indexed gameId);
404 
405     /// @dev This event is fired when server requests conflict end.
406     event LogServerRequestedEnd(address indexed user, uint indexed gameId);
407 
408     /// @dev This event is fired when game session is ended.
409     event LogGameEnded(address indexed user, uint indexed gameId, uint32 roundId, int balance, ReasonEnded reason);
410 
411     /// @dev this event is fired when owner modifies user's stake limits.
412     event LogStakeLimitsModified(uint minStake, uint maxStake);
413 
414     /**
415      * @dev Contract constructor.
416      * @param _serverAddress Server address.
417      * @param _minStake Min value user needs to deposit to create game session.
418      * @param _maxStake Max value user can deposit to create game session.
419      * @param _conflictResAddress Conflict resolution contract address.
420      * @param _houseAddress House address to move profit to.
421      * @param _chainId Chain id for signature domain.
422      */
423     constructor(
424         address _serverAddress,
425         uint128 _minStake,
426         uint128 _maxStake,
427         address _conflictResAddress,
428         address _houseAddress,
429         uint _chainId
430     )
431         public
432         ConflictResolutionManager(_conflictResAddress)
433     {
434         require(_minStake > 0 && _minStake <= _maxStake);
435 
436         serverAddress = _serverAddress;
437         houseAddress = _houseAddress;
438         lastProfitTransferTimestamp = block.timestamp;
439         minStake = _minStake;
440         maxStake = _maxStake;
441 
442         DOMAIN_SEPERATOR =  keccak256(abi.encode(
443             EIP712DOMAIN_TYPEHASH,
444             keccak256("Dicether"),
445             keccak256("2"),
446             _chainId,
447             address(this)
448         ));
449     }
450 
451     /**
452      * @dev Set gameIdCntr. Can be only set before activating contract.
453      */
454     function setGameIdCntr(uint _gameIdCntr) public onlyOwner onlyNotActivated {
455         require(gameIdCntr > 0);
456         gameIdCntr = _gameIdCntr;
457     }
458 
459     /**
460      * @notice Withdraw pending returns.
461      */
462     function withdraw() public {
463         uint toTransfer = pendingReturns[msg.sender];
464         require(toTransfer > 0);
465 
466         pendingReturns[msg.sender] = 0;
467         msg.sender.transfer(toTransfer);
468     }
469 
470     /**
471      * @notice Transfer house profit to houseAddress.
472      */
473     function transferProfitToHouse() public {
474         require(lastProfitTransferTimestamp.add(profitTransferTimeSpan) <= block.timestamp);
475 
476         // update last transfer timestamp
477         lastProfitTransferTimestamp = block.timestamp;
478 
479         if (houseProfit <= 0) {
480             // no profit to transfer
481             return;
482         }
483 
484         uint toTransfer = houseProfit.castToUint();
485 
486         houseProfit = 0;
487         houseStake = houseStake.sub(toTransfer);
488 
489         houseAddress.transfer(toTransfer);
490     }
491 
492     /**
493      * @dev Set profit transfer time span.
494      */
495     function setProfitTransferTimeSpan(uint _profitTransferTimeSpan)
496         public
497         onlyOwner
498         onlyValidTransferTimeSpan(_profitTransferTimeSpan)
499     {
500         profitTransferTimeSpan = _profitTransferTimeSpan;
501     }
502 
503     /**
504      * @dev Increase house stake by msg.value
505      */
506     function addHouseStake() public payable onlyOwner {
507         houseStake = houseStake.add(msg.value);
508     }
509 
510     /**
511      * @dev Withdraw house stake.
512      */
513     function withdrawHouseStake(uint value) public onlyOwner {
514         uint minHouseStake = conflictRes.minHouseStake(activeGames);
515 
516         require(value <= houseStake && houseStake.sub(value) >= minHouseStake);
517         require(houseProfit <= 0 || houseProfit.castToUint() <= houseStake.sub(value));
518 
519         houseStake = houseStake.sub(value);
520         owner.transfer(value);
521     }
522 
523     /**
524      * @dev Withdraw house stake and profit.
525      */
526     function withdrawAll() public onlyOwner onlyPausedSince(3 days) {
527         houseProfit = 0;
528         uint toTransfer = houseStake;
529         houseStake = 0;
530         owner.transfer(toTransfer);
531     }
532 
533     /**
534      * @dev Set new house address.
535      * @param _houseAddress New house address.
536      */
537     function setHouseAddress(address _houseAddress) public onlyOwner {
538         houseAddress = _houseAddress;
539     }
540 
541     /**
542      * @dev Set stake min and max value.
543      * @param _minStake Min stake.
544      * @param _maxStake Max stake.
545      */
546     function setStakeRequirements(uint128 _minStake, uint128 _maxStake) public onlyOwner {
547         require(_minStake > 0 && _minStake <= _maxStake);
548         minStake = _minStake;
549         maxStake = _maxStake;
550         emit LogStakeLimitsModified(minStake, maxStake);
551     }
552 
553     /**
554      * @dev Close game session.
555      * @param _game Game session data.
556      * @param _gameId Id of game session.
557      * @param _userAddress User's address of game session.
558      * @param _reason Reason for closing game session.
559      * @param _balance Game session balance.
560      */
561     function closeGame(
562         Game storage _game,
563         uint _gameId,
564         uint32 _roundId,
565         address _userAddress,
566         ReasonEnded _reason,
567         int _balance
568     )
569         internal
570     {
571         _game.status = GameStatus.ENDED;
572 
573         activeGames = activeGames.sub(1);
574 
575         payOut(_userAddress, _game.stake, _balance);
576 
577         emit LogGameEnded(_userAddress, _gameId, _roundId, _balance, _reason);
578     }
579 
580     /**
581      * @dev End game by paying out user and server.
582      * @param _userAddress User's address.
583      * @param _stake User's stake.
584      * @param _balance User's balance.
585      */
586     function payOut(address _userAddress, uint128 _stake, int _balance) internal {
587         int stakeInt = _stake;
588         int houseStakeInt = houseStake.castToInt();
589 
590         assert(_balance <= conflictRes.maxBalance());
591         assert((stakeInt.add(_balance)) >= 0);
592 
593         if (_balance > 0 && houseStakeInt < _balance) {
594             // Should never happen!
595             // House is bankrupt.
596             // Payout left money.
597             _balance = houseStakeInt;
598         }
599 
600         houseProfit = houseProfit.sub(_balance);
601 
602         int newHouseStake = houseStakeInt.sub(_balance);
603         houseStake = newHouseStake.castToUint();
604 
605         uint valueUser = stakeInt.add(_balance).castToUint();
606         pendingReturns[_userAddress] += valueUser;
607         if (pendingReturns[_userAddress] > 0) {
608             safeSend(_userAddress);
609         }
610     }
611 
612     /**
613      * @dev Send value of pendingReturns[_address] to _address.
614      * @param _address Address to send value to.
615      */
616     function safeSend(address _address) internal {
617         uint valueToSend = pendingReturns[_address];
618         assert(valueToSend > 0);
619 
620         pendingReturns[_address] = 0;
621         if (_address.send(valueToSend) == false) {
622             pendingReturns[_address] = valueToSend;
623         }
624     }
625 
626     /**
627      * @dev Verify signature of given data. Throws on verification failure.
628      * @param _sig Signature of given data in the form of rsv.
629      * @param _address Address of signature signer.
630      */
631     function verifySig(
632         uint32 _roundId,
633         uint8 _gameType,
634         uint _num,
635         uint _value,
636         int _balance,
637         bytes32 _serverHash,
638         bytes32 _userHash,
639         uint _gameId,
640         address _contractAddress,
641         bytes _sig,
642         address _address
643     )
644         internal
645         view
646     {
647         // check if this is the correct contract
648         address contractAddress = this;
649         require(_contractAddress == contractAddress, "inv contractAddress");
650 
651         bytes32 roundHash = calcHash(
652                 _roundId,
653                 _gameType,
654                 _num,
655                 _value,
656                 _balance,
657                 _serverHash,
658                 _userHash,
659                 _gameId
660         );
661 
662         verify(
663                 roundHash,
664                 _sig,
665                 _address
666         );
667     }
668 
669      /**
670      * @dev Check if _sig is valid signature of _hash. Throws if invalid signature.
671      * @param _hash Hash to check signature of.
672      * @param _sig Signature of _hash.
673      * @param _address Address of signer.
674      */
675     function verify(
676         bytes32 _hash,
677         bytes _sig,
678         address _address
679     )
680         internal
681         pure
682     {
683         (bytes32 r, bytes32 s, uint8 v) = signatureSplit(_sig);
684         address addressRecover = ecrecover(_hash, v, r, s);
685         require(addressRecover == _address, "inv sig");
686     }
687 
688     /**
689      * @dev Calculate typed hash of given data (compare eth_signTypedData).
690      * @return Hash of given data.
691      */
692     function calcHash(
693         uint32 _roundId,
694         uint8 _gameType,
695         uint _num,
696         uint _value,
697         int _balance,
698         bytes32 _serverHash,
699         bytes32 _userHash,
700         uint _gameId
701     )
702         private
703         view
704         returns(bytes32)
705     {
706         bytes32 betHash = keccak256(abi.encode(
707             BET_TYPEHASH,
708             _roundId,
709             _gameType,
710             _num,
711             _value,
712             _balance,
713             _serverHash,
714             _userHash,
715             _gameId
716         ));
717 
718         return keccak256(abi.encodePacked(
719             "\x19\x01",
720             DOMAIN_SEPERATOR,
721             betHash
722         ));
723     }
724 
725     /**
726      * @dev Split the given signature of the form rsv in r s v. v is incremented with 27 if
727      * it is below 2.
728      * @param _signature Signature to split.
729      * @return r s v
730      */
731     function signatureSplit(bytes _signature)
732         private
733         pure
734         returns (bytes32 r, bytes32 s, uint8 v)
735     {
736         require(_signature.length == 65, "inv sig");
737 
738         assembly {
739             r := mload(add(_signature, 32))
740             s := mload(add(_signature, 64))
741             v := and(mload(add(_signature, 65)), 0xff)
742         }
743         if (v < 2) {
744             v = v + 27;
745         }
746     }
747 }
748 
749 contract GameChannelConflict is GameChannelBase {
750     using SafeCast for int;
751     using SafeCast for uint;
752     using SafeMath for int;
753     using SafeMath for uint;
754 
755     /**
756      * @dev Contract constructor.
757      * @param _serverAddress Server address.
758      * @param _minStake Min value user needs to deposit to create game session.
759      * @param _maxStake Max value user can deposit to create game session.
760      * @param _conflictResAddress Conflict resolution contract address
761      * @param _houseAddress House address to move profit to
762      * @param _chainId Chain id for signature domain.
763      */
764     constructor(
765         address _serverAddress,
766         uint128 _minStake,
767         uint128 _maxStake,
768         address _conflictResAddress,
769         address _houseAddress,
770         uint _chainId
771     )
772         public
773         GameChannelBase(_serverAddress, _minStake, _maxStake, _conflictResAddress, _houseAddress, _chainId)
774     {
775         // nothing to do
776     }
777 
778     /**
779      * @dev Used by server if user does not end game session.
780      * @param _roundId Round id of bet.
781      * @param _gameType Game type of bet.
782      * @param _num Number of bet.
783      * @param _value Value of bet.
784      * @param _balance Balance before this bet.
785      * @param _serverHash Hash of server seed for this bet.
786      * @param _userHash Hash of user seed for this bet.
787      * @param _gameId Game session id.
788      * @param _contractAddress Address of this contract.
789      * @param _userSig User signature of this bet.
790      * @param _userAddress Address of user.
791      * @param _serverSeed Server seed for this bet.
792      * @param _userSeed User seed for this bet.
793      */
794     function serverEndGameConflict(
795         uint32 _roundId,
796         uint8 _gameType,
797         uint _num,
798         uint _value,
799         int _balance,
800         bytes32 _serverHash,
801         bytes32 _userHash,
802         uint _gameId,
803         address _contractAddress,
804         bytes _userSig,
805         address _userAddress,
806         bytes32 _serverSeed,
807         bytes32 _userSeed
808     )
809         public
810         onlyServer
811     {
812         verifySig(
813                 _roundId,
814                 _gameType,
815                 _num,
816                 _value,
817                 _balance,
818                 _serverHash,
819                 _userHash,
820                 _gameId,
821                 _contractAddress,
822                 _userSig,
823                 _userAddress
824         );
825 
826         serverEndGameConflictImpl(
827                 _roundId,
828                 _gameType,
829                 _num,
830                 _value,
831                 _balance,
832                 _serverHash,
833                 _userHash,
834                 _serverSeed,
835                 _userSeed,
836                 _gameId,
837                 _userAddress
838         );
839     }
840 
841     /**
842      * @notice Can be used by user if server does not answer to the end game session request.
843      * @param _roundId Round id of bet.
844      * @param _gameType Game type of bet.
845      * @param _num Number of bet.
846      * @param _value Value of bet.
847      * @param _balance Balance before this bet.
848      * @param _serverHash Hash of server seed for this bet.
849      * @param _userHash Hash of user seed for this bet.
850      * @param _gameId Game session id.
851      * @param _contractAddress Address of this contract.
852      * @param _serverSig Server signature of this bet.
853      * @param _userSeed User seed for this bet.
854      */
855     function userEndGameConflict(
856         uint32 _roundId,
857         uint8 _gameType,
858         uint _num,
859         uint _value,
860         int _balance,
861         bytes32 _serverHash,
862         bytes32 _userHash,
863         uint _gameId,
864         address _contractAddress,
865         bytes _serverSig,
866         bytes32 _userSeed
867     )
868         public
869     {
870         verifySig(
871             _roundId,
872             _gameType,
873             _num,
874             _value,
875             _balance,
876             _serverHash,
877             _userHash,
878             _gameId,
879             _contractAddress,
880             _serverSig,
881             serverAddress
882         );
883 
884         userEndGameConflictImpl(
885             _roundId,
886             _gameType,
887             _num,
888             _value,
889             _balance,
890             _userHash,
891             _userSeed,
892             _gameId,
893             msg.sender
894         );
895     }
896 
897     /**
898      * @notice Cancel active game without playing. Useful if server stops responding before
899      * one game is played.
900      * @param _gameId Game session id.
901      */
902     function userCancelActiveGame(uint _gameId) public {
903         address userAddress = msg.sender;
904         uint gameId = userGameId[userAddress];
905         Game storage game = gameIdGame[gameId];
906 
907         require(gameId == _gameId, "inv gameId");
908 
909         if (game.status == GameStatus.ACTIVE) {
910             game.endInitiatedTime = block.timestamp;
911             game.status = GameStatus.USER_INITIATED_END;
912 
913             emit LogUserRequestedEnd(msg.sender, gameId);
914         } else if (game.status == GameStatus.SERVER_INITIATED_END && game.roundId == 0) {
915             cancelActiveGame(game, gameId, userAddress);
916         } else {
917             revert();
918         }
919     }
920 
921     /**
922      * @dev Cancel active game without playing. Useful if user starts game session and
923      * does not play.
924      * @param _userAddress Users' address.
925      * @param _gameId Game session id.
926      */
927     function serverCancelActiveGame(address _userAddress, uint _gameId) public onlyServer {
928         uint gameId = userGameId[_userAddress];
929         Game storage game = gameIdGame[gameId];
930 
931         require(gameId == _gameId, "inv gameId");
932 
933         if (game.status == GameStatus.ACTIVE) {
934             game.endInitiatedTime = block.timestamp;
935             game.status = GameStatus.SERVER_INITIATED_END;
936 
937             emit LogServerRequestedEnd(msg.sender, gameId);
938         } else if (game.status == GameStatus.USER_INITIATED_END && game.roundId == 0) {
939             cancelActiveGame(game, gameId, _userAddress);
940         } else {
941             revert();
942         }
943     }
944 
945     /**
946     * @dev Force end of game if user does not respond. Only possible after a certain period of time
947     * to give the user a chance to respond.
948     * @param _userAddress User's address.
949     */
950     function serverForceGameEnd(address _userAddress, uint _gameId) public onlyServer {
951         uint gameId = userGameId[_userAddress];
952         Game storage game = gameIdGame[gameId];
953 
954         require(gameId == _gameId, "inv gameId");
955         require(game.status == GameStatus.SERVER_INITIATED_END, "inv status");
956 
957         // theoretically we have enough data to calculate winner
958         // but as user did not respond assume he has lost.
959         int newBalance = conflictRes.serverForceGameEnd(
960             game.gameType,
961             game.betNum,
962             game.betValue,
963             game.balance,
964             game.stake,
965             game.endInitiatedTime
966         );
967 
968         closeGame(game, gameId, game.roundId, _userAddress, ReasonEnded.SERVER_FORCED_END, newBalance);
969     }
970 
971     /**
972     * @notice Force end of game if server does not respond. Only possible after a certain period of time
973     * to give the server a chance to respond.
974     */
975     function userForceGameEnd(uint _gameId) public {
976         address userAddress = msg.sender;
977         uint gameId = userGameId[userAddress];
978         Game storage game = gameIdGame[gameId];
979 
980         require(gameId == _gameId, "inv gameId");
981         require(game.status == GameStatus.USER_INITIATED_END, "inv status");
982 
983         int newBalance = conflictRes.userForceGameEnd(
984             game.gameType,
985             game.betNum,
986             game.betValue,
987             game.balance,
988             game.stake,
989             game.endInitiatedTime
990         );
991 
992         closeGame(game, gameId, game.roundId, userAddress, ReasonEnded.USER_FORCED_END, newBalance);
993     }
994 
995     /**
996      * @dev Conflict handling implementation. Stores game data and timestamp if game
997      * is active. If server has already marked conflict for game session the conflict
998      * resolution contract is used (compare conflictRes).
999      * @param _roundId Round id of bet.
1000      * @param _gameType Game type of bet.
1001      * @param _num Number of bet.
1002      * @param _value Value of bet.
1003      * @param _balance Balance before this bet.
1004      * @param _userHash Hash of user's seed for this bet.
1005      * @param _userSeed User's seed for this bet.
1006      * @param _gameId game Game session id.
1007      * @param _userAddress User's address.
1008      */
1009     function userEndGameConflictImpl(
1010         uint32 _roundId,
1011         uint8 _gameType,
1012         uint _num,
1013         uint _value,
1014         int _balance,
1015         bytes32 _userHash,
1016         bytes32 _userSeed,
1017         uint _gameId,
1018         address _userAddress
1019     )
1020         private
1021     {
1022         uint gameId = userGameId[_userAddress];
1023         Game storage game = gameIdGame[gameId];
1024         int maxBalance = conflictRes.maxBalance();
1025         int gameStake = game.stake;
1026 
1027         require(gameId == _gameId, "inv gameId");
1028         require(_roundId > 0, "inv roundId");
1029         require(keccak256(abi.encodePacked(_userSeed)) == _userHash, "inv userSeed");
1030         require(-gameStake <= _balance && _balance <= maxBalance, "inv balance"); // game.stake save to cast as uint128
1031         require(conflictRes.isValidBet(_gameType, _num, _value), "inv bet");
1032         require(gameStake.add(_balance).sub(_value.castToInt()) >= 0, "value too high"); // game.stake save to cast as uint128
1033 
1034         if (game.status == GameStatus.SERVER_INITIATED_END && game.roundId == _roundId) {
1035             game.userSeed = _userSeed;
1036             endGameConflict(game, gameId, _userAddress);
1037         } else if (game.status == GameStatus.ACTIVE
1038                 || (game.status == GameStatus.SERVER_INITIATED_END && game.roundId < _roundId)) {
1039             game.status = GameStatus.USER_INITIATED_END;
1040             game.endInitiatedTime = block.timestamp;
1041             game.roundId = _roundId;
1042             game.gameType = _gameType;
1043             game.betNum = _num;
1044             game.betValue = _value;
1045             game.balance = _balance;
1046             game.userSeed = _userSeed;
1047             game.serverSeed = bytes32(0);
1048 
1049             emit LogUserRequestedEnd(msg.sender, gameId);
1050         } else {
1051             revert("inv state");
1052         }
1053     }
1054 
1055     /**
1056      * @dev Conflict handling implementation. Stores game data and timestamp if game
1057      * is active. If user has already marked conflict for game session the conflict
1058      * resolution contract is used (compare conflictRes).
1059      * @param _roundId Round id of bet.
1060      * @param _gameType Game type of bet.
1061      * @param _num Number of bet.
1062      * @param _value Value of bet.
1063      * @param _balance Balance before this bet.
1064      * @param _serverHash Hash of server's seed for this bet.
1065      * @param _userHash Hash of user's seed for this bet.
1066      * @param _serverSeed Server's seed for this bet.
1067      * @param _userSeed User's seed for this bet.
1068      * @param _userAddress User's address.
1069      */
1070     function serverEndGameConflictImpl(
1071         uint32 _roundId,
1072         uint8 _gameType,
1073         uint _num,
1074         uint _value,
1075         int _balance,
1076         bytes32 _serverHash,
1077         bytes32 _userHash,
1078         bytes32 _serverSeed,
1079         bytes32 _userSeed,
1080         uint _gameId,
1081         address _userAddress
1082     )
1083         private
1084     {
1085         uint gameId = userGameId[_userAddress];
1086         Game storage game = gameIdGame[gameId];
1087         int maxBalance = conflictRes.maxBalance();
1088         int gameStake = game.stake;
1089 
1090         require(gameId == _gameId, "inv gameId");
1091         require(_roundId > 0, "inv roundId");
1092         require(keccak256(abi.encodePacked(_serverSeed)) == _serverHash, "inv serverSeed");
1093         require(keccak256(abi.encodePacked(_userSeed)) == _userHash, "inv userSeed");
1094         require(-gameStake <= _balance && _balance <= maxBalance, "inv balance"); // game.stake save to cast as uint128
1095         require(conflictRes.isValidBet(_gameType, _num, _value), "inv bet");
1096         require(gameStake.add(_balance).sub(_value.castToInt()) >= 0, "too high value"); // game.stake save to cast as uin128
1097 
1098         if (game.status == GameStatus.USER_INITIATED_END && game.roundId == _roundId) {
1099             game.serverSeed = _serverSeed;
1100             endGameConflict(game, gameId, _userAddress);
1101         } else if (game.status == GameStatus.ACTIVE
1102                 || (game.status == GameStatus.USER_INITIATED_END && game.roundId < _roundId)) {
1103             game.status = GameStatus.SERVER_INITIATED_END;
1104             game.endInitiatedTime = block.timestamp;
1105             game.roundId = _roundId;
1106             game.gameType = _gameType;
1107             game.betNum = _num;
1108             game.betValue = _value;
1109             game.balance = _balance;
1110             game.serverSeed = _serverSeed;
1111             game.userSeed = _userSeed;
1112 
1113             emit LogServerRequestedEnd(_userAddress, gameId);
1114         } else {
1115             revert("inv state");
1116         }
1117     }
1118 
1119     /**
1120      * @dev End conflicting game without placed bets.
1121      * @param _game Game session data.
1122      * @param _gameId Game session id.
1123      * @param _userAddress User's address.
1124      */
1125     function cancelActiveGame(Game storage _game, uint _gameId, address _userAddress) private {
1126         // user need to pay a fee when conflict ended.
1127         // this ensures a malicious, rich user can not just generate game sessions and then wait
1128         // for us to end the game session and then confirm the session status, so
1129         // we would have to pay a high gas fee without profit.
1130         int newBalance = -conflictRes.conflictEndFine();
1131 
1132         // do not allow balance below user stake
1133         int stake = _game.stake;
1134         if (newBalance < -stake) {
1135             newBalance = -stake;
1136         }
1137         closeGame(_game, _gameId, 0, _userAddress, ReasonEnded.CONFLICT_ENDED, newBalance);
1138     }
1139 
1140     /**
1141      * @dev End conflicting game.
1142      * @param _game Game session data.
1143      * @param _gameId Game session id.
1144      * @param _userAddress User's address.
1145      */
1146     function endGameConflict(Game storage _game, uint _gameId, address _userAddress) private {
1147         int newBalance = conflictRes.endGameConflict(
1148             _game.gameType,
1149             _game.betNum,
1150             _game.betValue,
1151             _game.balance,
1152             _game.stake,
1153             _game.serverSeed,
1154             _game.userSeed
1155         );
1156 
1157         closeGame(_game, _gameId, _game.roundId, _userAddress, ReasonEnded.CONFLICT_ENDED, newBalance);
1158     }
1159 }
1160 
1161 contract GameChannel is GameChannelConflict {
1162     /**
1163      * @dev contract constructor
1164      * @param _serverAddress Server address.
1165      * @param _minStake Min value user needs to deposit to create game session.
1166      * @param _maxStake Max value user can deposit to create game session.
1167      * @param _conflictResAddress Conflict resolution contract address.
1168      * @param _houseAddress House address to move profit to.
1169      * @param _chainId Chain id for signature domain.
1170      */
1171     constructor(
1172         address _serverAddress,
1173         uint128 _minStake,
1174         uint128 _maxStake,
1175         address _conflictResAddress,
1176         address _houseAddress,
1177         uint _chainId
1178     )
1179         public
1180         GameChannelConflict(_serverAddress, _minStake, _maxStake, _conflictResAddress, _houseAddress, _chainId)
1181     {
1182         // nothing to do
1183     }
1184 
1185     /**
1186      * @notice Create games session request. msg.value needs to be valid stake value.
1187      * @param _userEndHash Last entry of users' hash chain.
1188      * @param _previousGameId User's previous game id, initial 0.
1189      * @param _createBefore Game can be only created before this timestamp.
1190      * @param _serverEndHash Last entry of server's hash chain.
1191      * @param _serverSig Server signature. See verifyCreateSig
1192      */
1193     function createGame(
1194         bytes32 _userEndHash,
1195         uint _previousGameId,
1196         uint _createBefore,
1197         bytes32 _serverEndHash,
1198         bytes _serverSig
1199     )
1200         public
1201         payable
1202         onlyValidValue
1203         onlyValidHouseStake(activeGames + 1)
1204         onlyNotPaused
1205     {
1206         uint previousGameId = userGameId[msg.sender];
1207         Game storage game = gameIdGame[previousGameId];
1208 
1209         require(game.status == GameStatus.ENDED, "prev game not ended");
1210         require(previousGameId == _previousGameId, "inv gamePrevGameId");
1211         require(block.timestamp < _createBefore, "expired");
1212 
1213         verifyCreateSig(msg.sender, _previousGameId, _createBefore, _serverEndHash, _serverSig);
1214 
1215         uint gameId = gameIdCntr++;
1216         userGameId[msg.sender] = gameId;
1217         Game storage newGame = gameIdGame[gameId];
1218 
1219         newGame.stake = uint128(msg.value); // It's safe to cast msg.value as it is limited, see onlyValidValue
1220         newGame.status = GameStatus.ACTIVE;
1221 
1222         activeGames = activeGames.add(1);
1223 
1224         // It's safe to cast msg.value as it is limited, see onlyValidValue
1225         emit LogGameCreated(msg.sender, gameId, uint128(msg.value), _serverEndHash,  _userEndHash);
1226     }
1227 
1228 
1229     /**
1230      * @dev Regular end game session. Used if user and house have both
1231      * accepted current game session state.
1232      * The game session with gameId _gameId is closed
1233      * and the user paid out. This functions is called by the server after
1234      * the user requested the termination of the current game session.
1235      * @param _roundId Round id of bet.
1236      * @param _balance Current balance.
1237      * @param _serverHash Hash of server's seed for this bet.
1238      * @param _userHash Hash of user's seed for this bet.
1239      * @param _gameId Game session id.
1240      * @param _contractAddress Address of this contract.
1241      * @param _userAddress Address of user.
1242      * @param _userSig User's signature of this bet.
1243      */
1244     function serverEndGame(
1245         uint32 _roundId,
1246         int _balance,
1247         bytes32 _serverHash,
1248         bytes32 _userHash,
1249         uint _gameId,
1250         address _contractAddress,
1251         address _userAddress,
1252         bytes _userSig
1253     )
1254         public
1255         onlyServer
1256     {
1257         verifySig(
1258                 _roundId,
1259                 0,
1260                 0,
1261                 0,
1262                 _balance,
1263                 _serverHash,
1264                 _userHash,
1265                 _gameId,
1266                 _contractAddress,
1267                 _userSig,
1268                 _userAddress
1269         );
1270 
1271         regularEndGame(_userAddress, _roundId, _balance, _gameId, _contractAddress);
1272     }
1273 
1274     /**
1275      * @notice Regular end game session. Normally not needed as server ends game (@see serverEndGame).
1276      * Can be used by user if server does not end game session.
1277      * @param _roundId Round id of bet.
1278      * @param _balance Current balance.
1279      * @param _serverHash Hash of server's seed for this bet.
1280      * @param _userHash Hash of user's seed for this bet.
1281      * @param _gameId Game session id.
1282      * @param _contractAddress Address of this contract.
1283      * @param _serverSig Server's signature of this bet.
1284      */
1285     function userEndGame(
1286         uint32 _roundId,
1287         int _balance,
1288         bytes32 _serverHash,
1289         bytes32 _userHash,
1290         uint _gameId,
1291         address _contractAddress,
1292         bytes _serverSig
1293     )
1294         public
1295     {
1296         verifySig(
1297                 _roundId,
1298                 0,
1299                 0,
1300                 0,
1301                 _balance,
1302                 _serverHash,
1303                 _userHash,
1304                 _gameId,
1305                 _contractAddress,
1306                 _serverSig,
1307                 serverAddress
1308         );
1309 
1310         regularEndGame(msg.sender, _roundId, _balance, _gameId, _contractAddress);
1311     }
1312 
1313     /**
1314      * @dev Verify server signature.
1315      * @param _userAddress User's address.
1316      * @param _previousGameId User's previous game id, initial 0.
1317      * @param _createBefore Game can be only created before this timestamp.
1318      * @param _serverEndHash Last entry of server's hash chain.
1319      * @param _serverSig Server signature.
1320      */
1321     function verifyCreateSig(
1322         address _userAddress,
1323         uint _previousGameId,
1324         uint _createBefore,
1325         bytes32 _serverEndHash,
1326         bytes _serverSig
1327     )
1328         private view
1329     {
1330         address contractAddress = this;
1331         bytes32 hash = keccak256(abi.encodePacked(
1332             contractAddress, _userAddress, _previousGameId, _createBefore, _serverEndHash
1333         ));
1334 
1335         verify(hash, _serverSig, serverAddress);
1336     }
1337 
1338     /**
1339      * @dev Regular end game session implementation. Used if user and house have both
1340      * accepted current game session state. The game session with gameId _gameId is closed
1341      * and the user paid out.
1342      * @param _userAddress Address of user.
1343      * @param _balance Current balance.
1344      * @param _gameId Game session id.
1345      * @param _contractAddress Address of this contract.
1346      */
1347     function regularEndGame(
1348         address _userAddress,
1349         uint32 _roundId,
1350         int _balance,
1351         uint _gameId,
1352         address _contractAddress
1353     )
1354         private
1355     {
1356         uint gameId = userGameId[_userAddress];
1357         Game storage game = gameIdGame[gameId];
1358         int maxBalance = conflictRes.maxBalance();
1359         int gameStake = game.stake;
1360 
1361         require(_gameId == gameId, "inv gameId");
1362         require(_roundId > 0, "inv roundId");
1363         // save to cast as game.stake hash fixed range
1364         require(-gameStake <= _balance && _balance <= maxBalance, "inv balance");
1365         require(game.status == GameStatus.ACTIVE, "inv status");
1366 
1367         assert(_contractAddress == address(this));
1368 
1369         closeGame(game, gameId, _roundId, _userAddress, ReasonEnded.REGULAR_ENDED, _balance);
1370     }
1371 }
1372 
1373 library SafeCast {
1374     /**
1375      * Cast unsigned a to signed a.
1376      */
1377     function castToInt(uint a) internal pure returns(int) {
1378         assert(a < (1 << 255));
1379         return int(a);
1380     }
1381 
1382     /**
1383      * Cast signed a to unsigned a.
1384      */
1385     function castToUint(int a) internal pure returns(uint) {
1386         assert(a >= 0);
1387         return uint(a);
1388     }
1389 }
1390 
1391 library SafeMath {
1392 
1393     /**
1394     * @dev Multiplies two unsigned integers, throws on overflow.
1395     */
1396     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1397         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1398         // benefit is lost if 'b' is also tested.
1399         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1400         if (a == 0) {
1401             return 0;
1402         }
1403 
1404         c = a * b;
1405         assert(c / a == b);
1406         return c;
1407     }
1408 
1409     /**
1410     * @dev Multiplies two signed integers, throws on overflow.
1411     */
1412     function mul(int256 a, int256 b) internal pure returns (int256) {
1413         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1414         // benefit is lost if 'b' is also tested.
1415         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1416         if (a == 0) {
1417             return 0;
1418         }
1419         int256 c = a * b;
1420         assert(c / a == b);
1421         return c;
1422     }
1423 
1424     /**
1425     * @dev Integer division of two unsigned integers, truncating the quotient.
1426     */
1427     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1428         // assert(b > 0); // Solidity automatically throws when dividing by 0
1429         // uint256 c = a / b;
1430         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1431         return a / b;
1432     }
1433 
1434     /**
1435     * @dev Integer division of two signed integers, truncating the quotient.
1436     */
1437     function div(int256 a, int256 b) internal pure returns (int256) {
1438         // assert(b > 0); // Solidity automatically throws when dividing by 0
1439         // Overflow only happens when the smallest negative int is multiplied by -1.
1440         int256 INT256_MIN = int256((uint256(1) << 255));
1441         assert(a != INT256_MIN || b != - 1);
1442         return a / b;
1443     }
1444 
1445     /**
1446     * @dev Subtracts two unsigned integers, throws on overflow (i.e. if subtrahend is greater than minuend).
1447     */
1448     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1449         assert(b <= a);
1450         return a - b;
1451     }
1452 
1453     /**
1454     * @dev Subtracts two signed integers, throws on overflow.
1455     */
1456     function sub(int256 a, int256 b) internal pure returns (int256) {
1457         int256 c = a - b;
1458         assert((b >= 0 && c <= a) || (b < 0 && c > a));
1459         return c;
1460     }
1461 
1462     /**
1463     * @dev Adds two unsigned integers, throws on overflow.
1464     */
1465     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1466         c = a + b;
1467         assert(c >= a);
1468         return c;
1469     }
1470 
1471     /**
1472     * @dev Adds two signed integers, throws on overflow.
1473     */
1474     function add(int256 a, int256 b) internal pure returns (int256) {
1475         int256 c = a + b;
1476         assert((b >= 0 && c >= a) || (b < 0 && c < a));
1477         return c;
1478     }
1479 }