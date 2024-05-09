1 pragma solidity ^0.4.17;
2 
3 /**
4    @title SafeMath
5    @notice Implements SafeMath
6 */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11 
12         assert(a == 0 || c / a == b);
13 
14         return c;
15     }
16 
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21 
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29 
30         return a - b;
31     }
32 
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36 
37         assert(c >= a);
38 
39         return c;
40     }
41 }
42 
43 contract Hasher {
44 
45     /*
46      *  Public pure functions
47      */
48     function hashUuid(
49         string _symbol,
50         string _name,
51         uint256 _chainIdValue,
52         uint256 _chainIdUtility,
53         address _openSTUtility,
54         uint256 _conversionRate,
55         uint8 _conversionRateDecimals)
56         public
57         pure
58         returns (bytes32)
59     {
60         return keccak256(
61             _symbol,
62             _name,
63             _chainIdValue,
64             _chainIdUtility,
65             _openSTUtility,
66             _conversionRate,
67             _conversionRateDecimals);
68     }
69 
70     function hashStakingIntent(
71         bytes32 _uuid,
72         address _account,
73         uint256 _accountNonce,
74         address _beneficiary,
75         uint256 _amountST,
76         uint256 _amountUT,
77         uint256 _escrowUnlockHeight)
78         public
79         pure
80         returns (bytes32)
81     {
82         return keccak256(
83             _uuid,
84             _account,
85             _accountNonce,
86             _beneficiary,
87             _amountST,
88             _amountUT,
89             _escrowUnlockHeight);
90     }
91 
92     function hashRedemptionIntent(
93         bytes32 _uuid,
94         address _account,
95         uint256 _accountNonce,
96         address _beneficiary,
97         uint256 _amountUT,
98         uint256 _escrowUnlockHeight)
99         public
100         pure
101         returns (bytes32)
102     {
103         return keccak256(
104             _uuid,
105             _account,
106             _accountNonce,
107             _beneficiary,
108             _amountUT,
109             _escrowUnlockHeight);
110     }
111 }
112 
113 /**
114    @title Owned
115    @notice Implements basic ownership with 2-step transfers
116 */
117 contract Owned {
118 
119     address public owner;
120     address public proposedOwner;
121 
122     event OwnershipTransferInitiated(address indexed _proposedOwner);
123     event OwnershipTransferCompleted(address indexed _newOwner);
124 
125 
126     function Owned() public {
127         owner = msg.sender;
128     }
129 
130 
131     modifier onlyOwner() {
132         require(isOwner(msg.sender));
133         _;
134     }
135 
136 
137     function isOwner(address _address) internal view returns (bool) {
138         return (_address == owner);
139     }
140 
141 
142     function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
143         proposedOwner = _proposedOwner;
144 
145         OwnershipTransferInitiated(_proposedOwner);
146 
147         return true;
148     }
149 
150 
151     function completeOwnershipTransfer() public returns (bool) {
152         require(msg.sender == proposedOwner);
153 
154         owner = proposedOwner;
155         proposedOwner = address(0);
156 
157         OwnershipTransferCompleted(owner);
158 
159         return true;
160     }
161 }
162 
163 /**
164    @title OpsManaged
165    @notice Implements OpenST ownership and permission model
166 */
167 contract OpsManaged is Owned {
168 
169     address public opsAddress;
170     address public adminAddress;
171 
172     event AdminAddressChanged(address indexed _newAddress);
173     event OpsAddressChanged(address indexed _newAddress);
174 
175 
176     function OpsManaged() public
177         Owned()
178     {
179     }
180 
181 
182     modifier onlyAdmin() {
183         require(isAdmin(msg.sender));
184         _;
185     }
186 
187 
188     modifier onlyAdminOrOps() {
189         require(isAdmin(msg.sender) || isOps(msg.sender));
190         _;
191     }
192 
193 
194     modifier onlyOwnerOrAdmin() {
195         require(isOwner(msg.sender) || isAdmin(msg.sender));
196         _;
197     }
198 
199 
200     modifier onlyOps() {
201         require(isOps(msg.sender));
202         _;
203     }
204 
205 
206     function isAdmin(address _address) internal view returns (bool) {
207         return (adminAddress != address(0) && _address == adminAddress);
208     }
209 
210 
211     function isOps(address _address) internal view returns (bool) {
212         return (opsAddress != address(0) && _address == opsAddress);
213     }
214 
215 
216     function isOwnerOrOps(address _address) internal view returns (bool) {
217         return (isOwner(_address) || isOps(_address));
218     }
219 
220 
221     // Owner and Admin can change the admin address. Address can also be set to 0 to 'disable' it.
222     function setAdminAddress(address _adminAddress) external onlyOwnerOrAdmin returns (bool) {
223         require(_adminAddress != owner);
224         require(_adminAddress != address(this));
225         require(!isOps(_adminAddress));
226 
227         adminAddress = _adminAddress;
228 
229         AdminAddressChanged(_adminAddress);
230 
231         return true;
232     }
233 
234 
235     // Owner and Admin can change the operations address. Address can also be set to 0 to 'disable' it.
236     function setOpsAddress(address _opsAddress) external onlyOwnerOrAdmin returns (bool) {
237         require(_opsAddress != owner);
238         require(_opsAddress != address(this));
239         require(!isAdmin(_opsAddress));
240 
241         opsAddress = _opsAddress;
242 
243         OpsAddressChanged(_opsAddress);
244 
245         return true;
246     }
247 }
248 
249 /**
250    @title EIP20Interface
251    @notice Provides EIP20 token interface
252 */
253 contract EIP20Interface {
254     event Transfer(address indexed _from, address indexed _to, uint256 _value);
255     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
256 
257     function name() public view returns (string);
258     function symbol() public view returns (string);
259     function decimals() public view returns (uint8);
260     function totalSupply() public view returns (uint256);
261 
262     function balanceOf(address _owner) public view returns (uint256 balance);
263     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
264 
265     function transfer(address _to, uint256 _value) public returns (bool success);
266     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
267     function approve(address _spender, uint256 _value) public returns (bool success);
268 }
269 
270 contract CoreInterface {
271     
272     function registrar() public view returns (address /* registrar */);
273 
274     function chainIdRemote() public view returns (uint256 /* chainIdRemote */);
275     function openSTRemote() public view returns (address /* OpenSTRemote */);
276 }
277 
278 contract ProtocolVersioned {
279 
280     /*
281      *  Events
282      */
283     event ProtocolTransferInitiated(address indexed _existingProtocol, address indexed _proposedProtocol, uint256 _activationHeight);
284     event ProtocolTransferRevoked(address indexed _existingProtocol, address indexed _revokedProtocol);
285     event ProtocolTransferCompleted(address indexed _newProtocol);
286 
287     /*
288      *  Constants
289      */
290     /// Blocks to wait before the protocol transfer can be completed
291     /// This allows anyone with a stake to unstake under the existing
292     /// protocol if they disagree with the new proposed protocol
293     /// @dev from OpenST ^v1.0 this constant will be set to a significant value
294     /// ~ 1 week at 15 seconds per block
295     uint256 constant private PROTOCOL_TRANSFER_BLOCKS_TO_WAIT = 40320;
296     
297     /*
298      *  Storage
299      */
300     /// OpenST protocol contract
301     address public openSTProtocol;
302     /// proposed OpenST protocol
303     address public proposedProtocol;
304     /// earliest protocol transfer height
305     uint256 public earliestTransferHeight;
306 
307     /*
308      * Modifiers
309      */
310     modifier onlyProtocol() {
311         require(msg.sender == openSTProtocol);
312         _;
313     }
314 
315     modifier onlyProposedProtocol() {
316         require(msg.sender == proposedProtocol);
317         _;
318     }
319 
320     modifier afterWait() {
321         require(earliestTransferHeight <= block.number);
322         _;
323     }
324 
325     modifier notNull(address _address) {
326         require(_address != 0);
327         _;
328     }
329     
330     // TODO: [ben] add hasCode modifier so that for 
331     //       a significant wait time the code at the proposed new
332     //       protocol can be reviewed
333 
334     /*
335      *  Public functions
336      */
337     /// @dev Constructor set the OpenST Protocol
338     function ProtocolVersioned(address _protocol) 
339         public
340         notNull(_protocol)
341     {
342         openSTProtocol = _protocol;
343     }
344 
345     /// @dev initiate protocol transfer
346     function initiateProtocolTransfer(
347         address _proposedProtocol)
348         public 
349         onlyProtocol
350         notNull(_proposedProtocol)
351         returns (bool)
352     {
353         require(_proposedProtocol != openSTProtocol);
354         require(proposedProtocol == address(0));
355 
356         earliestTransferHeight = block.number + blocksToWaitForProtocolTransfer();
357         proposedProtocol = _proposedProtocol;
358 
359         ProtocolTransferInitiated(openSTProtocol, _proposedProtocol, earliestTransferHeight);
360 
361         return true;
362     }
363 
364     /// @dev only after the waiting period, can
365     ///      proposed protocol complete the transfer
366     function completeProtocolTransfer()
367         public
368         onlyProposedProtocol
369         afterWait
370         returns (bool) 
371     {
372         openSTProtocol = proposedProtocol;
373         proposedProtocol = address(0);
374         earliestTransferHeight = 0;
375 
376         ProtocolTransferCompleted(openSTProtocol);
377 
378         return true;
379     }
380 
381     /// @dev protocol can revoke initiated protocol
382     ///      transfer
383     function revokeProtocolTransfer()
384         public
385         onlyProtocol
386         returns (bool)
387     {
388         require(proposedProtocol != address(0));
389 
390         address revokedProtocol = proposedProtocol;
391         proposedProtocol = address(0);
392         earliestTransferHeight = 0;
393 
394         ProtocolTransferRevoked(openSTProtocol, revokedProtocol);
395 
396         return true;
397     }
398 
399     function blocksToWaitForProtocolTransfer() public pure returns (uint256) {
400         return PROTOCOL_TRANSFER_BLOCKS_TO_WAIT;
401     }
402 }
403 
404 /// @title SimpleStake - stakes the value of an EIP20 token on Ethereum
405 ///        for a utility token on the OpenST platform
406 /// @author OpenST Ltd.
407 contract SimpleStake is ProtocolVersioned {
408     using SafeMath for uint256;
409 
410     /*
411      *  Events
412      */
413     event ReleasedStake(address indexed _protocol, address indexed _to, uint256 _amount);
414 
415     /*
416      *  Storage
417      */
418     /// EIP20 token contract that can be staked
419     EIP20Interface public eip20Token;
420     /// UUID for the utility token
421     bytes32 public uuid;
422 
423     /*
424      *  Public functions
425      */
426     /// @dev Contract constructor sets the protocol and the EIP20 token to stake
427     /// @param _eip20Token EIP20 token that will be staked
428     /// @param _openSTProtocol OpenSTProtocol contract that governs staking
429     /// @param _uuid Unique Universal Identifier of the registered utility token
430     function SimpleStake(
431         EIP20Interface _eip20Token,
432         address _openSTProtocol,
433         bytes32 _uuid)
434         ProtocolVersioned(_openSTProtocol)
435         public
436     {
437         eip20Token = _eip20Token;
438         uuid = _uuid;
439     }
440 
441     /// @dev Allows the protocol to release the staked amount
442     ///      into provided address.
443     ///      The protocol MUST be a contract that sets the rules
444     ///      on how the stake can be released and to who.
445     ///      The protocol takes the role of an "owner" of the stake.
446     /// @param _to Beneficiary of the amount of the stake
447     /// @param _amount Amount of stake to release to beneficiary
448     function releaseTo(address _to, uint256 _amount) 
449         public 
450         onlyProtocol
451         returns (bool)
452     {
453         require(_to != address(0));
454         require(eip20Token.transfer(_to, _amount));
455         
456         ReleasedStake(msg.sender, _to, _amount);
457 
458         return true;
459     }
460 
461     /*
462      * Web3 call functions
463      */
464     /// @dev total stake is the balance of the staking contract
465     ///      accidental transfers directly to SimpleStake bypassing
466     ///      the OpenST protocol will not mint new utility tokens,
467     ///      but will add to the total stake.
468     ///      (accidental) donations can not be prevented
469     function getTotalStake()
470         public
471         view
472         returns (uint256)
473     {
474         return eip20Token.balanceOf(this);
475     }
476 }
477 
478 /// @title AM1OpenSTValue - value staking contract for OpenST
479 contract AM1OpenSTValue is OpsManaged, Hasher {
480     using SafeMath for uint256;
481     
482     /*
483      *  Events
484      */
485     event UtilityTokenRegistered(bytes32 indexed _uuid, address indexed stake,
486         string _symbol, string _name, uint8 _decimals, uint256 _conversionRate, uint8 _conversionRateDecimals,
487         uint256 _chainIdUtility, address indexed _stakingAccount);
488 
489     event StakingIntentDeclared(bytes32 indexed _uuid, address indexed _staker,
490         uint256 _stakerNonce, address _beneficiary, uint256 _amountST,
491         uint256 _amountUT, uint256 _unlockHeight, bytes32 _stakingIntentHash,
492         uint256 _chainIdUtility);
493 
494     event ProcessedStake(bytes32 indexed _uuid, bytes32 indexed _stakingIntentHash,
495         address _stake, address _staker, uint256 _amountST, uint256 _amountUT);
496 
497     event RevertedStake(bytes32 indexed _uuid, bytes32 indexed _stakingIntentHash,
498         address _staker, uint256 _amountST, uint256 _amountUT);
499 
500     event RedemptionIntentConfirmed(bytes32 indexed _uuid, bytes32 _redemptionIntentHash,
501         address _redeemer, address _beneficiary, uint256 _amountST, uint256 _amountUT, uint256 _expirationHeight);
502 
503     event ProcessedUnstake(bytes32 indexed _uuid, bytes32 indexed _redemptionIntentHash,
504         address stake, address _redeemer, address _beneficiary, uint256 _amountST);
505 
506     event RevertedUnstake(bytes32 indexed _uuid, bytes32 indexed _redemptionIntentHash,
507         address _redeemer, address _beneficiary, uint256 _amountST);
508 
509     /*
510      *  Constants
511      */
512     uint8 public constant TOKEN_DECIMALS = 18;
513     uint256 public constant DECIMALSFACTOR = 10**uint256(TOKEN_DECIMALS);
514     // ~3 weeks, assuming ~15s per block
515     uint256 private constant BLOCKS_TO_WAIT_LONG = 120960;
516     // ~3 days, assuming ~15s per block
517     uint256 private constant BLOCKS_TO_WAIT_SHORT = 17280;
518 
519     /*
520      *  Structures
521      */
522     struct UtilityToken {
523         string  symbol;
524         string  name;
525         uint256 conversionRate;
526         uint8 conversionRateDecimals;
527         uint8   decimals;
528         uint256 chainIdUtility;
529         SimpleStake simpleStake;
530         address stakingAccount;
531     }
532 
533     struct Stake {
534         bytes32 uuid;
535         address staker;
536         address beneficiary;
537         uint256 nonce;
538         uint256 amountST;
539         uint256 amountUT;
540         uint256 unlockHeight;
541     }
542 
543     struct Unstake {
544         bytes32 uuid;
545         address redeemer;
546         address beneficiary;
547         uint256 amountST;
548         // @dev consider removal of amountUT
549         uint256 amountUT;
550         uint256 expirationHeight;
551     }
552 
553     /*
554      *  Storage
555      */
556     uint256 public chainIdValue;
557     EIP20Interface public valueToken;
558     address public registrar;
559     bytes32[] public uuids;
560     bool public deactivated;
561     mapping(uint256 /* chainIdUtility */ => CoreInterface) internal cores;
562     mapping(bytes32 /* uuid */ => UtilityToken) public utilityTokens;
563     /// nonce makes the staking process atomic across the two-phased process
564     /// and protects against replay attack on (un)staking proofs during the process.
565     /// On the value chain nonces need to strictly increase by one; on the utility
566     /// chain the nonce need to strictly increase (as one value chain can have multiple
567     /// utility chains)
568     mapping(address /* (un)staker */ => uint256) internal nonces;
569     /// register the active stakes and unstakes
570     mapping(bytes32 /* hashStakingIntent */ => Stake) public stakes;
571     mapping(bytes32 /* hashRedemptionIntent */ => Unstake) public unstakes;
572 
573     /*
574      *  Modifiers
575      */
576     modifier onlyRegistrar() {
577         // for now keep unique registrar
578         require(msg.sender == registrar);
579         _;
580     }
581 
582     function AM1OpenSTValue(
583         uint256 _chainIdValue,
584         EIP20Interface _eip20token,
585         address _registrar)
586         public
587         OpsManaged()
588     {
589         require(_chainIdValue != 0);
590         require(_eip20token != address(0));
591         require(_registrar != address(0));
592 
593         chainIdValue = _chainIdValue;
594         valueToken = _eip20token;
595         // registrar cannot be reset
596         // TODO: require it to be a contract
597         registrar = _registrar;
598         deactivated = false;
599     }
600 
601     /*
602      *  External functions
603      */
604     /// @dev In order to stake the tx.origin needs to set an allowance
605     ///      for the OpenSTValue contract to transfer to itself to hold
606     ///      during the staking process.
607     function stake(
608         bytes32 _uuid,
609         uint256 _amountST,
610         address _beneficiary)
611         external
612         returns (
613         uint256 amountUT,
614         uint256 nonce,
615         uint256 unlockHeight,
616         bytes32 stakingIntentHash)
617         /* solhint-disable-next-line function-max-lines */
618     {
619         require(!deactivated);
620         /* solhint-disable avoid-tx-origin */
621         // check the staking contract has been approved to spend the amount to stake
622         // OpenSTValue needs to be able to transfer the stake into its balance for
623         // keeping until the two-phase process is completed on both chains.
624         require(_amountST > 0);
625         // Consider the security risk of using tx.origin; at the same time an allowance
626         // needs to be set before calling stake over a potentially malicious contract at stakingAccount.
627         // The second protection is that the staker needs to check the intent hash before
628         // signing off on completing the two-phased process.
629         require(valueToken.allowance(tx.origin, address(this)) >= _amountST);
630 
631         require(utilityTokens[_uuid].simpleStake != address(0));
632         require(_beneficiary != address(0));
633 
634         UtilityToken storage utilityToken = utilityTokens[_uuid];
635 
636         // if the staking account is set to a non-zero address,
637         // then all transactions have come (from/over) the staking account,
638         // whether this is an EOA or a contract; tx.origin is putting forward the funds
639         if (utilityToken.stakingAccount != address(0)) require(msg.sender == utilityToken.stakingAccount);
640         require(valueToken.transferFrom(tx.origin, address(this), _amountST));
641 
642         amountUT = (_amountST.mul(utilityToken.conversionRate))
643             .div(10**uint256(utilityToken.conversionRateDecimals));
644         unlockHeight = block.number + blocksToWaitLong();
645 
646         nonces[tx.origin]++;
647         nonce = nonces[tx.origin];
648 
649         stakingIntentHash = hashStakingIntent(
650             _uuid,
651             tx.origin,
652             nonce,
653             _beneficiary,
654             _amountST,
655             amountUT,
656             unlockHeight
657         );
658 
659         stakes[stakingIntentHash] = Stake({
660             uuid:         _uuid,
661             staker:       tx.origin,
662             beneficiary:  _beneficiary,
663             nonce:        nonce,
664             amountST:     _amountST,
665             amountUT:     amountUT,
666             unlockHeight: unlockHeight
667         });
668 
669         StakingIntentDeclared(_uuid, tx.origin, nonce, _beneficiary,
670             _amountST, amountUT, unlockHeight, stakingIntentHash, utilityToken.chainIdUtility);
671 
672         return (amountUT, nonce, unlockHeight, stakingIntentHash);
673         /* solhint-enable avoid-tx-origin */
674     }
675 
676     function processStaking(
677         bytes32 _stakingIntentHash)
678         external
679         returns (address stakeAddress)
680     {
681         require(_stakingIntentHash != "");
682 
683         Stake storage stake = stakes[_stakingIntentHash];
684 
685         // note: as processStaking incurs a cost for the staker, we provide a fallback
686         // in v0.9 for registrar to process the staking on behalf of the staker,
687         // as the staker could fail to process the stake and avoid the cost of staking;
688         // this will be replaced with a signature carry-over implementation instead, where
689         // the signature of the intent hash suffices on value and utility chain, decoupling
690         // it from the transaction to processStaking and processMinting
691         require(stake.staker == msg.sender || registrar == msg.sender);
692         // as this bears the cost, there is no need to require
693         // that the stake.unlockHeight is not yet surpassed
694         // as is required on processMinting
695 
696         UtilityToken storage utilityToken = utilityTokens[stake.uuid];
697         stakeAddress = address(utilityToken.simpleStake);
698         require(stakeAddress != address(0));
699 
700         assert(valueToken.balanceOf(address(this)) >= stake.amountST);
701         require(valueToken.transfer(stakeAddress, stake.amountST));
702 
703         ProcessedStake(stake.uuid, _stakingIntentHash, stakeAddress, stake.staker,
704             stake.amountST, stake.amountUT);
705 
706         delete stakes[_stakingIntentHash];
707 
708         return stakeAddress;
709     }
710 
711     function revertStaking(
712         bytes32 _stakingIntentHash)
713         external
714         returns (
715         bytes32 uuid,
716         uint256 amountST,
717         address staker)
718     {
719         require(_stakingIntentHash != "");
720 
721         Stake storage stake = stakes[_stakingIntentHash];
722 
723         // require that the stake is unlocked and exists
724         require(stake.unlockHeight > 0);
725         require(stake.unlockHeight <= block.number);
726 
727         assert(valueToken.balanceOf(address(this)) >= stake.amountST);
728         // revert the amount that was intended to be staked back to staker
729         require(valueToken.transfer(stake.staker, stake.amountST));
730 
731         uuid = stake.uuid;
732         amountST = stake.amountST;
733         staker = stake.staker;
734 
735         RevertedStake(stake.uuid, _stakingIntentHash, stake.staker,
736             stake.amountST, stake.amountUT);
737 
738         delete stakes[_stakingIntentHash];
739 
740         return (uuid, amountST, staker);
741     }
742 
743     function confirmRedemptionIntent(
744         bytes32 _uuid,
745         address _redeemer,
746         uint256 _redeemerNonce,
747         address _beneficiary,
748         uint256 _amountUT,
749         uint256 _redemptionUnlockHeight,
750         bytes32 _redemptionIntentHash)
751         external
752         onlyRegistrar
753         returns (
754         uint256 amountST,
755         uint256 expirationHeight)
756     {
757         require(utilityTokens[_uuid].simpleStake != address(0));
758         require(_amountUT > 0);
759         require(_beneficiary != address(0));
760         // later core will provide a view on the block height of the
761         // utility chain
762         require(_redemptionUnlockHeight > 0);
763         require(_redemptionIntentHash != "");
764 
765         require(nonces[_redeemer] + 1 == _redeemerNonce);
766         nonces[_redeemer]++;
767 
768         bytes32 redemptionIntentHash = hashRedemptionIntent(
769             _uuid,
770             _redeemer,
771             nonces[_redeemer],
772             _beneficiary,
773             _amountUT,
774             _redemptionUnlockHeight
775         );
776 
777         require(_redemptionIntentHash == redemptionIntentHash);
778 
779         expirationHeight = block.number + blocksToWaitShort();
780 
781         UtilityToken storage utilityToken = utilityTokens[_uuid];
782         // minimal precision to unstake 1 STWei
783         require(_amountUT >= (utilityToken.conversionRate.div(10**uint256(utilityToken.conversionRateDecimals))));
784         amountST = (_amountUT
785             .mul(10**uint256(utilityToken.conversionRateDecimals))).div(utilityToken.conversionRate);
786 
787         require(valueToken.balanceOf(address(utilityToken.simpleStake)) >= amountST);
788 
789         unstakes[redemptionIntentHash] = Unstake({
790             uuid:         _uuid,
791             redeemer:     _redeemer,
792             beneficiary:  _beneficiary,
793             amountUT:     _amountUT,
794             amountST:     amountST,
795             expirationHeight: expirationHeight
796         });
797 
798         RedemptionIntentConfirmed(_uuid, redemptionIntentHash, _redeemer,
799             _beneficiary, amountST, _amountUT, expirationHeight);
800 
801         return (amountST, expirationHeight);
802     }
803 
804     function processUnstaking(
805         bytes32 _redemptionIntentHash)
806         external
807         returns (
808         address stakeAddress)
809     {
810         require(_redemptionIntentHash != "");
811 
812         Unstake storage unstake = unstakes[_redemptionIntentHash];
813         require(unstake.redeemer == msg.sender);
814 
815         // as the process unstake results in a gain for the caller
816         // it needs to expire well before the process redemption can
817         // be reverted in OpenSTUtility
818         require(unstake.expirationHeight > block.number);
819 
820         UtilityToken storage utilityToken = utilityTokens[unstake.uuid];
821         stakeAddress = address(utilityToken.simpleStake);
822         require(stakeAddress != address(0));
823 
824         require(utilityToken.simpleStake.releaseTo(unstake.beneficiary, unstake.amountST));
825 
826         ProcessedUnstake(unstake.uuid, _redemptionIntentHash, stakeAddress,
827             unstake.redeemer, unstake.beneficiary, unstake.amountST);
828 
829         delete unstakes[_redemptionIntentHash];
830 
831         return stakeAddress;
832     }
833 
834     function revertUnstaking(
835         bytes32 _redemptionIntentHash)
836         external
837         returns (
838         bytes32 uuid,
839         address redeemer,
840         address beneficiary,
841         uint256 amountST)
842     {
843         require(_redemptionIntentHash != "");
844 
845         Unstake storage unstake = unstakes[_redemptionIntentHash];
846 
847         // require that the unstake has expired and that the redeemer has not
848         // processed the unstaking, ie unstake has not been deleted
849         require(unstake.expirationHeight > 0);
850         require(unstake.expirationHeight <= block.number);
851 
852         uuid = unstake.uuid;
853         redeemer = unstake.redeemer;
854         beneficiary = unstake.beneficiary;
855         amountST = unstake.amountST;
856 
857         delete unstakes[_redemptionIntentHash];
858 
859         RevertedUnstake(uuid, _redemptionIntentHash, redeemer, beneficiary, amountST);
860 
861         return (uuid, redeemer, beneficiary, amountST);
862     }
863 
864     function core(
865         uint256 _chainIdUtility)
866         external
867         view
868         returns (address /* core address */ )
869     {
870         return address(cores[_chainIdUtility]);
871     }
872 
873     /*
874      *  Public view functions
875      */
876     function getNextNonce(
877         address _account)
878         public
879         view
880         returns (uint256 /* nextNonce */)
881     {
882         return (nonces[_account] + 1);
883     }
884 
885     function blocksToWaitLong() public pure returns (uint256) {
886         return BLOCKS_TO_WAIT_LONG;
887     }
888 
889     function blocksToWaitShort() public pure returns (uint256) {
890         return BLOCKS_TO_WAIT_SHORT;
891     }
892 
893     /// @dev Returns size of uuids
894     /// @return size
895     function getUuidsSize() public view returns (uint256) {
896         return uuids.length;
897     }
898 
899     /*
900      *  Registrar functions
901      */
902     function addCore(
903         CoreInterface _core)
904         public
905         onlyRegistrar
906         returns (bool /* success */)
907     {
908         require(address(_core) != address(0));
909         // core constructed with same registrar
910         require(registrar == _core.registrar());
911         // on value chain core only tracks a remote utility chain
912         uint256 chainIdUtility = _core.chainIdRemote();
913         require(chainIdUtility != 0);
914         // cannot overwrite core for given chainId
915         require(cores[chainIdUtility] == address(0));
916 
917         cores[chainIdUtility] = _core;
918 
919         return true;
920     }
921 
922     function registerUtilityToken(
923         string _symbol,
924         string _name,
925         uint256 _conversionRate,
926         uint8 _conversionRateDecimals,
927         uint256 _chainIdUtility,
928         address _stakingAccount,
929         bytes32 _checkUuid)
930         public
931         onlyRegistrar
932         returns (bytes32 uuid)
933     {
934         require(bytes(_name).length > 0);
935         require(bytes(_symbol).length > 0);
936         require(_conversionRate > 0);
937         require(_conversionRateDecimals <= 5);
938 
939         address openSTRemote = cores[_chainIdUtility].openSTRemote();
940         require(openSTRemote != address(0));
941 
942         uuid = hashUuid(
943             _symbol,
944             _name,
945             chainIdValue,
946             _chainIdUtility,
947             openSTRemote,
948             _conversionRate,
949             _conversionRateDecimals);
950 
951         require(uuid == _checkUuid);
952 
953         require(address(utilityTokens[uuid].simpleStake) == address(0));
954 
955         SimpleStake simpleStake = new SimpleStake(
956             valueToken, address(this), uuid);
957 
958         utilityTokens[uuid] = UtilityToken({
959             symbol:         _symbol,
960             name:           _name,
961             conversionRate: _conversionRate,
962             conversionRateDecimals: _conversionRateDecimals,
963             decimals:       TOKEN_DECIMALS,
964             chainIdUtility: _chainIdUtility,
965             simpleStake:    simpleStake,
966             stakingAccount: _stakingAccount
967         });
968         uuids.push(uuid);
969 
970         UtilityTokenRegistered(uuid, address(simpleStake), _symbol, _name,
971             TOKEN_DECIMALS, _conversionRate, _conversionRateDecimals, _chainIdUtility, _stakingAccount);
972 
973         return uuid;
974     }
975 
976     /*
977      *  Administrative functions
978      */
979     function initiateProtocolTransfer(
980         ProtocolVersioned _simpleStake,
981         address _proposedProtocol)
982         public
983         onlyAdmin
984         returns (bool)
985     {
986         _simpleStake.initiateProtocolTransfer(_proposedProtocol);
987 
988         return true;
989     }
990 
991     // on the very first released version v0.9.1 there is no need
992     // to completeProtocolTransfer from a previous version
993 
994     /* solhint-disable-next-line separate-by-one-line-in-contract */
995     function revokeProtocolTransfer(
996         ProtocolVersioned _simpleStake)
997         public
998         onlyAdmin
999         returns (bool)
1000     {
1001         _simpleStake.revokeProtocolTransfer();
1002 
1003         return true;
1004     }
1005 
1006     function deactivate()
1007         public
1008         onlyAdmin
1009         returns (
1010         bool result)
1011     {
1012         deactivated = true;
1013         return deactivated;
1014     }
1015 }