1 // File: contracts/AvastarTypes.sol
2 
3 pragma solidity 0.5.14;
4 
5 /**
6  * @title Avastar Data Types
7  * @author Cliff Hall
8  */
9 contract AvastarTypes {
10 
11     enum Generation {
12         ONE,
13         TWO,
14         THREE,
15         FOUR,
16         FIVE
17     }
18 
19     enum Series {
20         PROMO,
21         ONE,
22         TWO,
23         THREE,
24         FOUR,
25         FIVE
26     }
27 
28     enum Wave {
29         PRIME,
30         REPLICANT
31     }
32 
33     enum Gene {
34         SKIN_TONE,
35         HAIR_COLOR,
36         EYE_COLOR,
37         BG_COLOR,
38         BACKDROP,
39         EARS,
40         FACE,
41         NOSE,
42         MOUTH,
43         FACIAL_FEATURE,
44         EYES,
45         HAIR_STYLE
46     }
47 
48     enum Gender {
49         ANY,
50         MALE,
51         FEMALE
52     }
53 
54     enum Rarity {
55         COMMON,
56         UNCOMMON,
57         RARE,
58         EPIC,
59         LEGENDARY
60     }
61 
62     struct Trait {
63         uint256 id;
64         Generation generation;
65         Gender gender;
66         Gene gene;
67         Rarity rarity;
68         uint8 variation;
69         Series[] series;
70         string name;
71         string svg;
72 
73     }
74 
75     struct Prime {
76         uint256 id;
77         uint256 serial;
78         uint256 traits;
79         bool[12] replicated;
80         Generation generation;
81         Series series;
82         Gender gender;
83         uint8 ranking;
84     }
85 
86     struct Replicant {
87         uint256 id;
88         uint256 serial;
89         uint256 traits;
90         Generation generation;
91         Gender gender;
92         uint8 ranking;
93     }
94 
95     struct Avastar {
96         uint256 id;
97         uint256 serial;
98         uint256 traits;
99         Generation generation;
100         Wave wave;
101     }
102 
103     struct Attribution {
104         Generation generation;
105         string artist;
106         string infoURI;
107     }
108 
109 }
110 
111 // File: contracts/IAvastarTeleporter.sol
112 
113 pragma solidity 0.5.14;
114 
115 
116 /**
117  * @title AvastarTeleporter Interface
118  * @author Cliff Hall
119  * @notice Declared as abstract contract rather than interface as it must inherit for enum types.
120  * Used by AvastarMinter contract to interact with subset of AvastarTeleporter contract functions.
121  */
122 contract IAvastarTeleporter is AvastarTypes {
123 
124     /**
125      * @notice Acknowledge contract is `AvastarTeleporter`
126      * @return always true if the contract is in fact `AvastarTeleporter`
127      */
128     function isAvastarTeleporter() external pure returns (bool);
129 
130     /**
131      * @notice Get token URI for a given Avastar Token ID.
132      * Reverts if given token id is not a valid Avastar Token ID.
133      * @param _tokenId the Token ID of a previously minted Avastar Prime or Replicant
134      * @return uri the off-chain URI to the JSON metadata for the given Avastar
135      */
136     function tokenURI(uint _tokenId)
137     external view
138     returns (string memory uri);
139 
140     /**
141      * @notice Get an Avastar's Wave by token ID.
142      * @param _tokenId the token id of the given Avastar
143      * @return wave the Avastar's wave (Prime/Replicant)
144      */
145     function getAvastarWaveByTokenId(uint256 _tokenId)
146     external view
147     returns (Wave wave);
148 
149     /**
150      * @notice Get the Avastar Prime metadata associated with a given Token ID.
151      * @param _tokenId the Token ID of the specified Prime
152      * @return tokenId the Prime's token ID
153      * @return serial the Prime's serial
154      * @return traits the Prime's trait hash
155      * @return generation the Prime's generation
156      * @return series the Prime's series
157      * @return gender the Prime's gender
158      * @return ranking the Prime's ranking
159      */
160     function getPrimeByTokenId(uint256 _tokenId)
161     external view
162     returns (
163         uint256 tokenId,
164         uint256 serial,
165         uint256 traits,
166         Generation generation,
167         Series series,
168         Gender gender,
169         uint8 ranking
170     );
171 
172     /**
173      * @notice Get the Avastar Replicant metadata associated with a given Token ID
174      * @param _tokenId the token ID of the specified Replicant
175      * @return tokenId the Replicant's token ID
176      * @return serial the Replicant's serial
177      * @return traits the Replicant's trait hash
178      * @return generation the Replicant's generation
179      * @return gender the Replicant's gender
180      * @return ranking the Replicant's ranking
181      */
182     function getReplicantByTokenId(uint256 _tokenId)
183     external view
184     returns (
185         uint256 tokenId,
186         uint256 serial,
187         uint256 traits,
188         Generation generation,
189         Gender gender,
190         uint8 ranking
191     );
192 
193     /**
194      * @notice Retrieve a Trait's info by ID.
195      * @param _traitId the ID of the Trait to retrieve
196      * @return id the ID of the trait
197      * @return generation generation of the trait
198      * @return series list of series the trait may appear in
199      * @return gender gender(s) the trait is valid for
200      * @return gene gene the trait belongs to
201      * @return variation variation of the gene the trait represents
202      * @return rarity the rarity level of this trait
203      * @return name name of the trait
204      */
205     function getTraitInfoById(uint256 _traitId)
206     external view
207     returns (
208         uint256 id,
209         Generation generation,
210         Series[] memory series,
211         Gender gender,
212         Gene gene,
213         Rarity rarity,
214         uint8 variation,
215         string memory name
216     );
217 
218 
219     /**
220      * @notice Retrieve a Trait's name by ID.
221      * @param _traitId the ID of the Trait to retrieve
222      * @return name name of the trait
223      */
224     function getTraitNameById(uint256 _traitId)
225     external view
226     returns (string memory name);
227 
228     /**
229      * @notice Get Trait ID by Generation, Gene, and Variation.
230      * @param _generation the generation the trait belongs to
231      * @param _gene gene the trait belongs to
232      * @param _variation the variation of the gene
233      * @return traitId the ID of the specified trait
234      */
235     function getTraitIdByGenerationGeneAndVariation(
236         Generation _generation,
237         Gene _gene,
238         uint8 _variation
239     )
240     external view
241     returns (uint256 traitId);
242 
243     /**
244      * @notice Get the artist Attribution for a given Generation, combined into a single string.
245      * @param _generation the generation to retrieve artist attribution for
246      * @return attribution a single string with the artist and artist info URI
247      */
248     function getAttributionByGeneration(Generation _generation)
249     external view
250     returns (
251         string memory attribution
252     );
253 
254     /**
255      * @notice Mint an Avastar Prime
256      * Only invokable by minter role, when contract is not paused.
257      * If successful, emits a `NewPrime` event.
258      * @param _owner the address of the new Avastar's owner
259      * @param _traits the new Prime's trait hash
260      * @param _generation the new Prime's generation
261      * @return _series the new Prime's series
262      * @param _gender the new Prime's gender
263      * @param _ranking the new Prime's rarity ranking
264      * @return tokenId the newly minted Prime's token ID
265      * @return serial the newly minted Prime's serial
266      */
267     function mintPrime(
268         address _owner,
269         uint256 _traits,
270         Generation _generation,
271         Series _series,
272         Gender _gender,
273         uint8 _ranking
274     )
275     external
276     returns (uint256, uint256);
277 
278     /**
279      * @notice Mint an Avastar Replicant.
280      * Only invokable by minter role, when contract is not paused.
281      * If successful, emits a `NewReplicant` event.
282      * @param _owner the address of the new Avastar's owner
283      * @param _traits the new Replicant's trait hash
284      * @param _generation the new Replicant's generation
285      * @param _gender the new Replicant's gender
286      * @param _ranking the new Replicant's rarity ranking
287      * @return tokenId the newly minted Replicant's token ID
288      * @return serial the newly minted Replicant's serial
289      */
290     function mintReplicant(
291         address _owner,
292         uint256 _traits,
293         Generation _generation,
294         Gender _gender,
295         uint8 _ranking
296     )
297     external
298     returns (uint256, uint256);
299 
300     /**
301      * Gets the owner of the specified token ID.
302      * @param tokenId the token ID to search for the owner of
303      * @return owner the owner of the given token ID
304      */
305     function ownerOf(uint256 tokenId) external view returns (address owner);
306 
307     /**
308      * @notice Gets the total amount of tokens stored by the contract.
309      * @return count total number of tokens
310      */
311     function totalSupply() public view returns (uint256 count);
312 }
313 
314 // File: @openzeppelin/contracts/access/Roles.sol
315 
316 pragma solidity ^0.5.0;
317 
318 /**
319  * @title Roles
320  * @dev Library for managing addresses assigned to a Role.
321  */
322 library Roles {
323     struct Role {
324         mapping (address => bool) bearer;
325     }
326 
327     /**
328      * @dev Give an account access to this role.
329      */
330     function add(Role storage role, address account) internal {
331         require(!has(role, account), "Roles: account already has role");
332         role.bearer[account] = true;
333     }
334 
335     /**
336      * @dev Remove an account's access to this role.
337      */
338     function remove(Role storage role, address account) internal {
339         require(has(role, account), "Roles: account does not have role");
340         role.bearer[account] = false;
341     }
342 
343     /**
344      * @dev Check if an account has this role.
345      * @return bool
346      */
347     function has(Role storage role, address account) internal view returns (bool) {
348         require(account != address(0), "Roles: account is the zero address");
349         return role.bearer[account];
350     }
351 }
352 
353 // File: @openzeppelin/contracts/math/SafeMath.sol
354 
355 pragma solidity ^0.5.0;
356 
357 /**
358  * @dev Wrappers over Solidity's arithmetic operations with added overflow
359  * checks.
360  *
361  * Arithmetic operations in Solidity wrap on overflow. This can easily result
362  * in bugs, because programmers usually assume that an overflow raises an
363  * error, which is the standard behavior in high level programming languages.
364  * `SafeMath` restores this intuition by reverting the transaction when an
365  * operation overflows.
366  *
367  * Using this library instead of the unchecked operations eliminates an entire
368  * class of bugs, so it's recommended to use it always.
369  */
370 library SafeMath {
371     /**
372      * @dev Returns the addition of two unsigned integers, reverting on
373      * overflow.
374      *
375      * Counterpart to Solidity's `+` operator.
376      *
377      * Requirements:
378      * - Addition cannot overflow.
379      */
380     function add(uint256 a, uint256 b) internal pure returns (uint256) {
381         uint256 c = a + b;
382         require(c >= a, "SafeMath: addition overflow");
383 
384         return c;
385     }
386 
387     /**
388      * @dev Returns the subtraction of two unsigned integers, reverting on
389      * overflow (when the result is negative).
390      *
391      * Counterpart to Solidity's `-` operator.
392      *
393      * Requirements:
394      * - Subtraction cannot overflow.
395      */
396     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
397         return sub(a, b, "SafeMath: subtraction overflow");
398     }
399 
400     /**
401      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
402      * overflow (when the result is negative).
403      *
404      * Counterpart to Solidity's `-` operator.
405      *
406      * Requirements:
407      * - Subtraction cannot overflow.
408      *
409      * _Available since v2.4.0._
410      */
411     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
412         require(b <= a, errorMessage);
413         uint256 c = a - b;
414 
415         return c;
416     }
417 
418     /**
419      * @dev Returns the multiplication of two unsigned integers, reverting on
420      * overflow.
421      *
422      * Counterpart to Solidity's `*` operator.
423      *
424      * Requirements:
425      * - Multiplication cannot overflow.
426      */
427     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
428         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
429         // benefit is lost if 'b' is also tested.
430         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
431         if (a == 0) {
432             return 0;
433         }
434 
435         uint256 c = a * b;
436         require(c / a == b, "SafeMath: multiplication overflow");
437 
438         return c;
439     }
440 
441     /**
442      * @dev Returns the integer division of two unsigned integers. Reverts on
443      * division by zero. The result is rounded towards zero.
444      *
445      * Counterpart to Solidity's `/` operator. Note: this function uses a
446      * `revert` opcode (which leaves remaining gas untouched) while Solidity
447      * uses an invalid opcode to revert (consuming all remaining gas).
448      *
449      * Requirements:
450      * - The divisor cannot be zero.
451      */
452     function div(uint256 a, uint256 b) internal pure returns (uint256) {
453         return div(a, b, "SafeMath: division by zero");
454     }
455 
456     /**
457      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
458      * division by zero. The result is rounded towards zero.
459      *
460      * Counterpart to Solidity's `/` operator. Note: this function uses a
461      * `revert` opcode (which leaves remaining gas untouched) while Solidity
462      * uses an invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      * - The divisor cannot be zero.
466      *
467      * _Available since v2.4.0._
468      */
469     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
470         // Solidity only automatically asserts when dividing by 0
471         require(b > 0, errorMessage);
472         uint256 c = a / b;
473         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
474 
475         return c;
476     }
477 
478     /**
479      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
480      * Reverts when dividing by zero.
481      *
482      * Counterpart to Solidity's `%` operator. This function uses a `revert`
483      * opcode (which leaves remaining gas untouched) while Solidity uses an
484      * invalid opcode to revert (consuming all remaining gas).
485      *
486      * Requirements:
487      * - The divisor cannot be zero.
488      */
489     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
490         return mod(a, b, "SafeMath: modulo by zero");
491     }
492 
493     /**
494      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
495      * Reverts with custom message when dividing by zero.
496      *
497      * Counterpart to Solidity's `%` operator. This function uses a `revert`
498      * opcode (which leaves remaining gas untouched) while Solidity uses an
499      * invalid opcode to revert (consuming all remaining gas).
500      *
501      * Requirements:
502      * - The divisor cannot be zero.
503      *
504      * _Available since v2.4.0._
505      */
506     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
507         require(b != 0, errorMessage);
508         return a % b;
509     }
510 }
511 
512 // File: contracts/AccessControl.sol
513 
514 pragma solidity 0.5.14;
515 
516 
517 
518 /**
519  * @title Access Control
520  * @author Cliff Hall
521  * @notice Role-based access control and contract upgrade functionality.
522  */
523 contract AccessControl {
524 
525     using SafeMath for uint256;
526     using SafeMath for uint16;
527     using Roles for Roles.Role;
528 
529     Roles.Role private admins;
530     Roles.Role private minters;
531     Roles.Role private owners;
532 
533     /**
534      * @notice Sets `msg.sender` as system admin by default.
535      * Starts paused. System admin must unpause, and add other roles after deployment.
536      */
537     constructor() public {
538         admins.add(msg.sender);
539     }
540 
541     /**
542      * @notice Emitted when contract is paused by system administrator.
543      */
544     event ContractPaused();
545 
546     /**
547      * @notice Emitted when contract is unpaused by system administrator.
548      */
549     event ContractUnpaused();
550 
551     /**
552      * @notice Emitted when contract is upgraded by system administrator.
553      * @param newContract address of the new version of the contract.
554      */
555     event ContractUpgrade(address newContract);
556 
557 
558     bool public paused = true;
559     bool public upgraded = false;
560     address public newContractAddress;
561 
562     /**
563      * @notice Modifier to scope access to minters
564      */
565     modifier onlyMinter() {
566         require(minters.has(msg.sender));
567         _;
568     }
569 
570     /**
571      * @notice Modifier to scope access to owners
572      */
573     modifier onlyOwner() {
574         require(owners.has(msg.sender));
575         _;
576     }
577 
578     /**
579      * @notice Modifier to scope access to system administrators
580      */
581     modifier onlySysAdmin() {
582         require(admins.has(msg.sender));
583         _;
584     }
585 
586     /**
587      * @notice Modifier to make a function callable only when the contract is not paused.
588      */
589     modifier whenNotPaused() {
590         require(!paused);
591         _;
592     }
593 
594     /**
595      * @notice Modifier to make a function callable only when the contract is paused.
596      */
597     modifier whenPaused() {
598         require(paused);
599         _;
600     }
601 
602     /**
603      * @notice Modifier to make a function callable only when the contract not upgraded.
604      */
605     modifier whenNotUpgraded() {
606         require(!upgraded);
607         _;
608     }
609 
610     /**
611      * @notice Called by a system administrator to  mark the smart contract as upgraded,
612      * in case there is a serious breaking bug. This method stores the new contract
613      * address and emits an event to that effect. Clients of the contract should
614      * update to the new contract address upon receiving this event. This contract will
615      * remain paused indefinitely after such an upgrade.
616      * @param _newAddress address of new contract
617      */
618     function upgradeContract(address _newAddress) external onlySysAdmin whenPaused whenNotUpgraded {
619         require(_newAddress != address(0));
620         upgraded = true;
621         newContractAddress = _newAddress;
622         emit ContractUpgrade(_newAddress);
623     }
624 
625     /**
626      * @notice Called by a system administrator to add a minter.
627      * Reverts if `_minterAddress` already has minter role
628      * @param _minterAddress approved minter
629      */
630     function addMinter(address _minterAddress) external onlySysAdmin {
631         minters.add(_minterAddress);
632         require(minters.has(_minterAddress));
633     }
634 
635     /**
636      * @notice Called by a system administrator to add an owner.
637      * Reverts if `_ownerAddress` already has owner role
638      * @param _ownerAddress approved owner
639      * @return added boolean indicating whether the role was granted
640      */
641     function addOwner(address _ownerAddress) external onlySysAdmin {
642         owners.add(_ownerAddress);
643         require(owners.has(_ownerAddress));
644     }
645 
646     /**
647      * @notice Called by a system administrator to add another system admin.
648      * Reverts if `_sysAdminAddress` already has sysAdmin role
649      * @param _sysAdminAddress approved owner
650      */
651     function addSysAdmin(address _sysAdminAddress) external onlySysAdmin {
652         admins.add(_sysAdminAddress);
653         require(admins.has(_sysAdminAddress));
654     }
655 
656     /**
657      * @notice Called by an owner to remove all roles from an address.
658      * Reverts if address had no roles to be removed.
659      * @param _address address having its roles stripped
660      */
661     function stripRoles(address _address) external onlyOwner {
662         require(msg.sender != _address);
663         bool stripped = false;
664         if (admins.has(_address)) {
665             admins.remove(_address);
666             stripped = true;
667         }
668         if (minters.has(_address)) {
669             minters.remove(_address);
670             stripped = true;
671         }
672         if (owners.has(_address)) {
673             owners.remove(_address);
674             stripped = true;
675         }
676         require(stripped == true);
677     }
678 
679     /**
680      * @notice Called by a system administrator to pause, triggers stopped state
681      */
682     function pause() external onlySysAdmin whenNotPaused {
683         paused = true;
684         emit ContractPaused();
685     }
686 
687     /**
688      * @notice Called by a system administrator to un-pause, returns to normal state
689      */
690     function unpause() external onlySysAdmin whenPaused whenNotUpgraded {
691         paused = false;
692         emit ContractUnpaused();
693     }
694 
695 }
696 
697 // File: contracts/AvastarPrimeMinter.sol
698 
699 pragma solidity 0.5.14;
700 
701 
702 
703 
704 /**
705  * @title Avastar Prime Minter Proxy
706  * @author Cliff Hall
707  * @notice Mints Avastar Primes using the `AvastarTeleporter` contract on behalf of depositors.
708  * Allows system admin to set current generation and series.
709  * Manages accounting of depositor and franchise balances.
710  */
711 contract AvastarPrimeMinter is AvastarTypes, AccessControl {
712 
713     /**
714      * @notice Event emitted when the current Generation is changed
715      * @param currentGeneration the new value of currentGeneration
716      */
717     event CurrentGenerationSet(Generation currentGeneration);
718 
719     /**
720      * @notice Event emitted when the current Series is changed
721      * @param currentSeries the new value of currentSeries
722      */
723     event CurrentSeriesSet(Series currentSeries);
724 
725     /**
726      * @notice Event emitted when ETH is deposited or withdrawn by a depositor
727      * @param depositor the address who deposited or withdrew ETH
728      * @param balance the depositor's resulting ETH balance in the contract
729      */
730     event DepositorBalance(address indexed depositor, uint256 balance);
731 
732     /**
733      * @notice Event emitted upon the withdrawal of the franchise's balance
734      * @param owner the contract owner
735      * @param amount total ETH withdrawn
736      */
737     event FranchiseBalanceWithdrawn(address indexed owner, uint256 amount);
738 
739     /**
740      * @notice Event emitted when AvastarTeleporter contract is set
741      * @param contractAddress the address of the AvastarTeleporter contract
742      */
743     event TeleporterContractSet(address contractAddress);
744 
745     /**
746      * @notice Address of the AvastarTeleporter contract
747      */
748     IAvastarTeleporter private teleporterContract ;
749 
750     /**
751      * @notice The current Generation of Avastars being minted
752      */
753     Generation private currentGeneration;
754 
755     /**
756      * @notice The current Series of Avastars being minted
757      */
758     Series private currentSeries;
759 
760     /**
761      * @notice Track the deposits made by address
762      */
763     mapping (address => uint256) private depositsByAddress;
764 
765     /**
766      * @notice Current total of unspent deposits by all depositors
767      */
768     uint256 private unspentDeposits;
769 
770     /**
771      * @notice Set the address of the `AvastarTeleporter` contract.
772      * Only invokable by system admin role, when contract is paused and not upgraded.
773      * To be used if the Teleporter contract has to be upgraded and a new instance deployed.
774      * If successful, emits an `TeleporterContractSet` event.
775      * @param _address address of `AvastarTeleporter` contract
776      */
777     function setTeleporterContract(address _address) external onlySysAdmin whenPaused whenNotUpgraded {
778 
779         // Cast the candidate contract to the IAvastarTeleporter interface
780         IAvastarTeleporter candidateContract = IAvastarTeleporter(_address);
781 
782         // Verify that we have the appropriate address
783         require(candidateContract.isAvastarTeleporter());
784 
785         // Set the contract address
786         teleporterContract = IAvastarTeleporter(_address);
787 
788         // Emit the event
789         emit TeleporterContractSet(_address);
790     }
791 
792     /**
793      * @notice Set the Generation to be minted.
794      * Resets `currentSeries` to `Series.ONE`.
795      * Only invokable by system admin role, when contract is paused and not upgraded.
796      * Emits `GenerationSet` event with new value of `currentGeneration`.
797      * @param _generation the new value for currentGeneration
798      */
799     function setCurrentGeneration(Generation _generation) external onlySysAdmin whenPaused whenNotUpgraded {
800         currentGeneration = _generation;
801         emit CurrentGenerationSet(currentGeneration);
802         setCurrentSeries(Series.ONE);
803     }
804 
805     /**
806      * @notice Set the Series to be minted.
807      * Only invokable by system admin role, when contract is paused and not upgraded.
808      * Emits `CurrentSeriesSet` event with new value of `currentSeries`.
809      * @param _series the new value for currentSeries
810      */
811     function setCurrentSeries(Series _series) public onlySysAdmin whenPaused whenNotUpgraded {
812         currentSeries = _series;
813         emit CurrentSeriesSet(currentSeries);
814     }
815 
816     /**
817      * @notice Allow owner to check the withdrawable franchise balance.
818      * Remaining balance must be enough for all unspent deposits to be withdrawn by depositors.
819      * Invokable only by owner role.
820      * @return franchiseBalance the available franchise balance
821      */
822     function checkFranchiseBalance() external view onlyOwner returns (uint256 franchiseBalance) {
823         return uint256(address(this).balance).sub(unspentDeposits);
824     }
825 
826     /**
827      * @notice Allow an owner to withdraw the franchise balance.
828      * Invokable only by owner role.
829      * Entire franchise balance is transferred to `msg.sender`.
830      * If successful, emits `FranchiseBalanceWithdrawn` event with amount withdrawn.
831      * @return amountWithdrawn amount withdrawn
832      */
833     function withdrawFranchiseBalance() external onlyOwner returns (uint256 amountWithdrawn) {
834         uint256 franchiseBalance = uint256(address(this).balance).sub(unspentDeposits);
835         require(franchiseBalance > 0);
836         msg.sender.transfer(franchiseBalance);
837         emit FranchiseBalanceWithdrawn(msg.sender, franchiseBalance);
838         return franchiseBalance;
839     }
840 
841     /**
842      * @notice Allow anyone to deposit ETH.
843      * Before contract will mint on behalf of a user, they must have sufficient ETH on deposit.
844      * Invokable by any address (other than 0) when contract is not paused.
845      * Must have a non-zero ETH value.
846      * If successful, emits a `DepositorBalance` event with depositor's resulting balance.
847      */
848     function deposit() external payable whenNotPaused {
849         require(msg.value > 0);
850         depositsByAddress[msg.sender] = depositsByAddress[msg.sender].add(msg.value);
851         unspentDeposits = unspentDeposits.add(msg.value);
852         emit DepositorBalance(msg.sender, depositsByAddress[msg.sender]);
853     }
854 
855     /**
856      * @notice Allow anyone to check their deposit balance.
857      * Invokable by any address (other than 0).
858      * @return the depositor's current ETH balance in the contract
859      */
860     function checkDepositorBalance() external view returns (uint256){
861         return depositsByAddress[msg.sender];
862     }
863 
864     /**
865      * @notice Allow a depositor with a balance to withdraw it.
866      * Invokable by any address (other than 0) with an ETH balance on deposit.
867      * Entire depositor balance is transferred to `msg.sender`.
868      * Emits `DepositorBalance` event of 0 amount once transfer is complete.
869      * @return amountWithdrawn amount withdrawn
870      */
871     function withdrawDepositorBalance() external returns (uint256 amountWithdrawn) {
872         uint256 depositorBalance = depositsByAddress[msg.sender];
873         require(depositorBalance > 0 && address(this).balance >= depositorBalance);
874         depositsByAddress[msg.sender] = 0;
875         unspentDeposits = unspentDeposits.sub(depositorBalance);
876         msg.sender.transfer(depositorBalance);
877         emit DepositorBalance(msg.sender, 0);
878         return depositorBalance;
879     }
880 
881     /**
882      * @notice Mint an Avastar Prime for a purchaser who has previously deposited funds.
883      * Invokable only by minter role, when contract is not paused.
884      * Minted token will be owned by `_purchaser` address.
885      * If successful, emits a `DepositorBalance` event with the depositor's remaining balance,
886      * and the `AvastarTeleporter` contract will emit a `NewPrime` event.
887      * @param _purchaser address that will own the token
888      * @param _price price in ETH of token, removed from purchaser's deposit balance
889      * @param _traits the Avastar's Trait hash
890      * @param _gender the Avastar's Gender
891      * @param _ranking the Avastar's Ranking
892      * @return tokenId the Avastar's tokenId
893      * @return serial the Prime's serial
894      */
895     function purchasePrime(
896         address _purchaser,
897         uint256 _price,
898         uint256 _traits,
899         Gender _gender,
900         uint8 _ranking
901     )
902     external
903     onlyMinter
904     whenNotPaused
905     returns (uint256 tokenId, uint256 serial)
906     {
907         require(_purchaser != address(0));
908         require (depositsByAddress[_purchaser] >= _price);
909         require(_gender > Gender.ANY);
910         depositsByAddress[_purchaser] = depositsByAddress[_purchaser].sub(_price);
911         unspentDeposits = unspentDeposits.sub(_price);
912         (tokenId, serial) = teleporterContract.mintPrime(_purchaser, _traits, currentGeneration, currentSeries, _gender, _ranking);
913         emit DepositorBalance(_purchaser, depositsByAddress[_purchaser]);
914         return (tokenId, serial);
915     }
916 
917 }