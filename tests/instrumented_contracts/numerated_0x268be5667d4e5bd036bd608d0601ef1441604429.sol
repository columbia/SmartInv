1 // File: openzeppelin-solidity/contracts/utils/Address.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Collection of functions related to the address type,
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * This test is non-exhaustive, and there may be false-negatives: during the
13      * execution of a contract's constructor, its address will be reported as
14      * not containing a contract.
15      *
16      * > It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      */
19     function isContract(address account) internal view returns (bool) {
20         // This method relies in extcodesize, which returns 0 for contracts in
21         // construction, since the code is only stored at the end of the
22         // constructor execution.
23 
24         uint256 size;
25         // solhint-disable-next-line no-inline-assembly
26         assembly { size := extcodesize(account) }
27         return size > 0;
28     }
29 }
30 
31 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be aplied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         _owner = msg.sender;
54         emit OwnershipTransferred(address(0), _owner);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(isOwner(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Returns true if the caller is the current owner.
74      */
75     function isOwner() public view returns (bool) {
76         return msg.sender == _owner;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * > Note: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public onlyOwner {
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      */
102     function _transferOwnership(address newOwner) internal {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 // File: localhost/contracts/proxy/Proxy.sol
110 
111 pragma solidity ^0.5.0;
112 
113 
114 
115 /**
116  * @title Proxy interface for Dinngo exchange contract.
117  * @author Ben Huang
118  * @dev Referenced the proxy contract from zeppelin-os project.
119  * https://github.com/zeppelinos/zos/tree/master/packages/lib
120  */
121 contract Proxy is Ownable {
122     using Address for address;
123 
124     // keccak256 hash of "dinngo.proxy.implementation"
125     bytes32 private constant IMPLEMENTATION_SLOT =
126         0x3b2ff02c0f36dba7cc1b20a669e540b974575f04ef71846d482983efb03bebb4;
127 
128     event Upgraded(address indexed implementation);
129 
130     constructor(address implementation) internal {
131         assert(IMPLEMENTATION_SLOT == keccak256("dinngo.proxy.implementation"));
132         _setImplementation(implementation);
133     }
134 
135     /**
136      * @notice Upgrade the implementation contract. Can only be triggered
137      * by the owner. Emits the Upgraded event.
138      * @param implementation The new implementation address.
139      */
140     function upgrade(address implementation) external onlyOwner {
141         _setImplementation(implementation);
142         emit Upgraded(implementation);
143     }
144 
145     /**
146      * @notice Return the version information of implementation
147      * @return version The version
148      */
149     function implementationVersion() external view returns (uint256 version){
150         (bool ok, bytes memory ret) = _implementation().staticcall(
151             abi.encodeWithSignature("version()")
152         );
153         require(ok);
154         assembly {
155             version := mload(add(add(ret, 0x20), 0))
156         }
157         return version;
158     }
159 
160     /**
161      * @dev Set the implementation address in the storage slot.
162      * @param implementation The new implementation address.
163      */
164     function _setImplementation(address implementation) internal {
165         require(implementation.isContract(),
166             "Implementation address should be a contract address"
167         );
168         bytes32 slot = IMPLEMENTATION_SLOT;
169 
170         assembly {
171             sstore(slot, implementation)
172         }
173     }
174 
175     /**
176      * @dev Returns the current implementation address.
177      */
178     function _implementation() internal view returns (address implementation) {
179         bytes32 slot = IMPLEMENTATION_SLOT;
180 
181         assembly {
182             implementation := sload(slot)
183         }
184     }
185 }
186 
187 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
188 
189 pragma solidity ^0.5.0;
190 
191 /**
192  * @dev Wrappers over Solidity's arithmetic operations with added overflow
193  * checks.
194  *
195  * Arithmetic operations in Solidity wrap on overflow. This can easily result
196  * in bugs, because programmers usually assume that an overflow raises an
197  * error, which is the standard behavior in high level programming languages.
198  * `SafeMath` restores this intuition by reverting the transaction when an
199  * operation overflows.
200  *
201  * Using this library instead of the unchecked operations eliminates an entire
202  * class of bugs, so it's recommended to use it always.
203  */
204 library SafeMath {
205     /**
206      * @dev Returns the addition of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `+` operator.
210      *
211      * Requirements:
212      * - Addition cannot overflow.
213      */
214     function add(uint256 a, uint256 b) internal pure returns (uint256) {
215         uint256 c = a + b;
216         require(c >= a, "SafeMath: addition overflow");
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting on
223      * overflow (when the result is negative).
224      *
225      * Counterpart to Solidity's `-` operator.
226      *
227      * Requirements:
228      * - Subtraction cannot overflow.
229      */
230     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231         require(b <= a, "SafeMath: subtraction overflow");
232         uint256 c = a - b;
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the multiplication of two unsigned integers, reverting on
239      * overflow.
240      *
241      * Counterpart to Solidity's `*` operator.
242      *
243      * Requirements:
244      * - Multiplication cannot overflow.
245      */
246     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
247         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
248         // benefit is lost if 'b' is also tested.
249         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
250         if (a == 0) {
251             return 0;
252         }
253 
254         uint256 c = a * b;
255         require(c / a == b, "SafeMath: multiplication overflow");
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the integer division of two unsigned integers. Reverts on
262      * division by zero. The result is rounded towards zero.
263      *
264      * Counterpart to Solidity's `/` operator. Note: this function uses a
265      * `revert` opcode (which leaves remaining gas untouched) while Solidity
266      * uses an invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         // Solidity only automatically asserts when dividing by 0
273         require(b > 0, "SafeMath: division by zero");
274         uint256 c = a / b;
275         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
276 
277         return c;
278     }
279 
280     /**
281      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
282      * Reverts when dividing by zero.
283      *
284      * Counterpart to Solidity's `%` operator. This function uses a `revert`
285      * opcode (which leaves remaining gas untouched) while Solidity uses an
286      * invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      * - The divisor cannot be zero.
290      */
291     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
292         require(b != 0, "SafeMath: modulo by zero");
293         return a % b;
294     }
295 }
296 
297 // File: localhost/contracts/Administrable.sol
298 
299 pragma solidity ^0.5.0;
300 
301 
302 /**
303  * @title Administrable
304  * @dev The administrator structure
305  */
306 /**
307  * @title Administrable
308  */
309 contract Administrable {
310     using SafeMath for uint256;
311     mapping (address => bool) private admins;
312     uint256 private _nAdmin;
313     uint256 private _nLimit;
314 
315     event Activated(address indexed admin);
316     event Deactivated(address indexed admin);
317 
318     /**
319      * @dev The Administrable constructor sets the original `admin` of the contract to the sender
320      * account. The initial limit amount of admin is 2.
321      */
322     constructor() internal {
323         _setAdminLimit(2);
324         _activateAdmin(msg.sender);
325     }
326 
327     function isAdmin() public view returns(bool) {
328         return admins[msg.sender];
329     }
330 
331     /**
332      * @dev Throws if called by non-admin.
333      */
334     modifier onlyAdmin() {
335         require(isAdmin(), "sender not admin");
336         _;
337     }
338 
339     function activateAdmin(address admin) external onlyAdmin {
340         _activateAdmin(admin);
341     }
342 
343     function deactivateAdmin(address admin) external onlyAdmin {
344         _safeDeactivateAdmin(admin);
345     }
346 
347     function setAdminLimit(uint256 n) external onlyAdmin {
348         _setAdminLimit(n);
349     }
350 
351     function _setAdminLimit(uint256 n) internal {
352         require(_nLimit != n, "same limit");
353         _nLimit = n;
354     }
355 
356     /**
357      * @notice The Amount of admin should be bounded by _nLimit.
358      */
359     function _activateAdmin(address admin) internal {
360         require(admin != address(0), "invalid address");
361         require(_nAdmin < _nLimit, "too many admins existed");
362         require(!admins[admin], "already admin");
363         admins[admin] = true;
364         _nAdmin = _nAdmin.add(1);
365         emit Activated(admin);
366     }
367 
368     /**
369      * @notice At least one admin should exists.
370      */
371     function _safeDeactivateAdmin(address admin) internal {
372         require(_nAdmin > 1, "admin should > 1");
373         _deactivateAdmin(admin);
374     }
375 
376     function _deactivateAdmin(address admin) internal {
377         require(admins[admin], "not admin");
378         admins[admin] = false;
379         _nAdmin = _nAdmin.sub(1);
380         emit Deactivated(admin);
381     }
382 }
383 
384 // File: localhost/contracts/DinngoProxy.sol
385 
386 pragma solidity 0.5.12;
387 
388 
389 
390 
391 
392 /**
393  * @title Dinngo
394  * @author Ben Huang
395  * @notice Main exchange contract for Dinngo
396  */
397 contract DinngoProxy is Ownable, Administrable, Proxy {
398     uint256 public processTime;
399 
400     mapping (address => mapping (address => uint256)) public balances;
401     mapping (bytes32 => uint256) public orderFills;
402     mapping (uint256 => address payable) public userID_Address;
403     mapping (uint256 => address) public tokenID_Address;
404     mapping (address => uint256) public nonces;
405     mapping (address => uint256) public ranks;
406     mapping (address => uint256) public lockTimes;
407 
408     address public walletOwner;
409     address public DGOToken;
410     uint8 public eventConf;
411 
412     uint256 constant public version = 2;
413 
414     /**
415      * @dev User ID 0 is the management wallet.
416      * Token ID 0 is ETH (address 0). Token ID 1 is DGO.
417      * @param _walletOwner The fee wallet owner
418      * @param _dinngoToken The contract address of DGO
419      * @param _impl The implementation contract address
420      */
421     constructor(
422         address payable _walletOwner,
423         address _dinngoToken,
424         address _impl
425     ) Proxy(_impl) public {
426         processTime = 90 days;
427         walletOwner = _walletOwner;
428         tokenID_Address[0] = address(0);
429         ranks[address(0)] = 1;
430         tokenID_Address[1] = _dinngoToken;
431         ranks[_dinngoToken] = 1;
432         DGOToken = _dinngoToken;
433         eventConf = 0xff;
434     }
435 
436     function setEvent(uint8 conf) external onlyAdmin {
437         (bool ok,) = _implementation().delegatecall(
438             abi.encodeWithSignature("setEvent(uint8)", conf)
439         );
440         require(ok);
441     }
442 
443     /**
444      * @notice Add the address to the user list. Event AddUser will be emitted
445      * after execution.
446      * @dev Record the user list to map the user address to a specific user ID, in
447      * order to compact the data size when transferring user address information
448      * @param id The user id to be assigned
449      * @param user The user address to be added
450      */
451     function addUser(uint256 id, address user) external onlyAdmin {
452         (bool ok,) = _implementation().delegatecall(
453             abi.encodeWithSignature("addUser(uint256,address)", id, user)
454         );
455         require(ok);
456     }
457 
458     /**
459      * @notice Remove the address from the user list.
460      * @dev The user rank is set to 0 to remove the user.
461      * @param user The user address to be removed
462      */
463     function removeUser(address user) external onlyAdmin {
464         (bool ok,) = _implementation().delegatecall(
465             abi.encodeWithSignature("remove(address)", user)
466         );
467         require(ok);
468     }
469 
470     /**
471      * @notice Update the rank of user. Can only be called by admin.
472      * @param user The user address
473      * @param rank The rank to be assigned
474      */
475     function updateUserRank(address user, uint256 rank) external onlyAdmin {
476         (bool ok,) = _implementation().delegatecall(
477             abi.encodeWithSignature("updateRank(address,uint256)", user, rank)
478         );
479         require(ok);
480     }
481 
482     /**
483      * @notice Add the token to the token list. Event AddToken will be emitted
484      * after execution.
485      * @dev Record the token list to map the token contract address to a specific
486      * token ID, in order to compact the data size when transferring token contract
487      * address information
488      * @param id The token id to be assigned
489      * @param token The token contract address to be added
490      */
491     function addToken(uint256 id, address token) external onlyOwner {
492         (bool ok,) = _implementation().delegatecall(
493             abi.encodeWithSignature("addToken(uint256,address)", id, token)
494         );
495         require(ok);
496     }
497 
498     /**
499      * @notice Remove the token from the token list.
500      * @dev The token rank is set to 0 to remove the token.
501      * @param token The token contract address to be removed.
502      */
503     function removeToken(address token) external onlyOwner {
504         (bool ok,) = _implementation().delegatecall(
505             abi.encodeWithSignature("remove(address)", token)
506         );
507         require(ok);
508     }
509 
510     /**
511      * @notice Update the rank of token. Can only be called by owner.
512      * @param token The token contract address.
513      * @param rank The rank to be assigned.
514      */
515     function updateTokenRank(address token, uint256 rank) external onlyOwner {
516         (bool ok,) = _implementation().delegatecall(
517             abi.encodeWithSignature("updateRank(address,uint256)", token, rank)
518         );
519         require(ok);
520     }
521 
522     function activateAdmin(address admin) external onlyOwner {
523         _activateAdmin(admin);
524     }
525 
526     function deactivateAdmin(address admin) external onlyOwner {
527         _safeDeactivateAdmin(admin);
528     }
529 
530     /**
531      * @notice Force-deactivate allows owner to deactivate admin even there will be
532      * no admin left. Should only be executed under emergency situation.
533      */
534     function forceDeactivateAdmin(address admin) external onlyOwner {
535         _deactivateAdmin(admin);
536     }
537 
538     function setAdminLimit(uint256 n) external onlyOwner {
539         _setAdminLimit(n);
540     }
541 
542     /**
543      * @notice The deposit function for ether. The ether that is sent with the function
544      * call will be deposited. The first time user will be added to the user list.
545      * Event Deposit will be emitted after execution.
546      */
547     function deposit() external payable {
548         (bool ok,) = _implementation().delegatecall(abi.encodeWithSignature("deposit()"));
549         require(ok);
550     }
551 
552     /**
553      * @notice The deposit function for tokens. The first time user will be added to
554      * the user list. Event Deposit will be emitted after execution.
555      * @param token Address of the token contract to be deposited
556      * @param amount Amount of the token to be depositied
557      */
558     function depositToken(address token, uint256 amount) external {
559         (bool ok,) = _implementation().delegatecall(
560             abi.encodeWithSignature("depositToken(address,uint256)", token, amount)
561         );
562         require(ok);
563     }
564 
565     /**
566      * @notice The withdraw function for ether. Event Withdraw will be emitted
567      * after execution. User needs to be locked before calling withdraw.
568      * @param amount The amount to be withdrawn.
569      */
570     function withdraw(uint256 amount) external {
571         (bool ok,) = _implementation().delegatecall(
572             abi.encodeWithSignature("withdraw(uint256)", amount)
573         );
574         require(ok);
575     }
576 
577     /**
578      * @notice The withdraw function for tokens. Event Withdraw will be emitted
579      * after execution. User needs to be locked before calling withdraw.
580      * @param token The token contract address to be withdrawn.
581      * @param amount The token amount to be withdrawn.
582      */
583     function withdrawToken(address token, uint256 amount) external {
584         (bool ok,) = _implementation().delegatecall(
585             abi.encodeWithSignature("withdrawToken(address,uint256)", token, amount)
586         );
587         require(ok);
588     }
589 
590     /**
591      * @notice The function to extract the fee from the fee account. This function can
592      * only be triggered by the income wallet owner.
593      * @param amount The amount to be extracted
594      */
595     function extractFee(uint256 amount) external {
596         (bool ok,) = _implementation().delegatecall(
597             abi.encodeWithSignature("extractFee(uint256)", amount)
598         );
599         require(ok);
600     }
601 
602     /**
603      * @notice The function to extract the fee from the fee account. This function can
604      * only be triggered by the income wallet owner.
605      * @param token The token to be extracted
606      * @param amount The amount to be extracted
607      */
608     function extractTokenFee(address token, uint256 amount) external {
609         (bool ok,) = _implementation().delegatecall(
610             abi.encodeWithSignature("extractTokenFee(address,uint256)", token, amount)
611         );
612         require(ok);
613     }
614 
615     /**
616      * @notice The function to get the balance from fee account.
617      * @param token The token of the balance to be queried
618      */
619     function getWalletBalance(address token) external returns (uint256 balance) {
620         (bool ok, bytes memory ret) = _implementation().delegatecall(
621             abi.encodeWithSignature("getWalletBalance(address)", token)
622         );
623         require(ok);
624         balance = abi.decode(ret, (uint256));
625     }
626 
627     /**
628      * @notice The function to change the owner of fee wallet.
629      * @param newOwner The new wallet owner to be assigned
630      */
631     function changeWalletOwner(address newOwner) external onlyOwner {
632         (bool ok,) = _implementation().delegatecall(
633             abi.encodeWithSignature("changeWalletOwner(address)", newOwner)
634         );
635         require(ok);
636     }
637 
638     /**
639      * @notice The withdraw function that can only be triggered by owner.
640      * Event Withdraw will be emitted after execution.
641      * @param withdrawal The serialized withdrawal data
642      */
643     function withdrawByAdmin(bytes calldata withdrawal, bytes calldata signature) external onlyAdmin {
644         (bool ok, bytes memory ret) = _implementation().delegatecall(
645             abi.encodeWithSignature("withdrawByAdmin(bytes,bytes)", withdrawal, signature)
646         );
647         require(ok, string(ret));
648     }
649 
650     /**
651      * @notice The transfer function that can only be triggered by owner.
652      * Event Transfer will be emitted afer execution.
653      * @param transferral The serialized transferral data.
654      */
655     function transferByAdmin(bytes calldata transferral, bytes calldata signature) external onlyAdmin {
656         (bool ok, bytes memory ret) = _implementation().delegatecall(
657             abi.encodeWithSignature("transferByAdmin(bytes,bytes)", transferral, signature)
658         );
659         require(ok, string(ret));
660     }
661 
662     /**
663      * @notice The settle function for orders. First order is taker order and the followings
664      * are maker orders.
665      * @param orders The serialized orders.
666      */
667     function settle(bytes calldata orders, bytes calldata signature) external onlyAdmin {
668         (bool ok, bytes memory ret) = _implementation().delegatecall(
669             abi.encodeWithSignature("settle(bytes,bytes)", orders, signature)
670         );
671         require(ok, string(ret));
672     }
673 
674     /**
675      * @notice The migrate function that can only be triggered by admin.
676      * @param migration The serialized migration data
677      */
678     function migrateByAdmin(bytes calldata migration, bytes calldata signature) external onlyAdmin {
679         (bool ok, bytes memory ret) = _implementation().delegatecall(
680             abi.encodeWithSignature("migrateByAdmin(bytes,bytes)", migration, signature)
681         );
682         require(ok, string(ret));
683     }
684 
685     /**
686      * @notice The migration handler
687      * @param user The user address to receive the migrated amount.
688      * @param token The token address to be migrated.
689      * @param amount The amount to be migrated.
690      */
691     function migrateTo(address user, address token, uint256 amount) payable external {
692         (bool ok,) = _implementation().delegatecall(
693             abi.encodeWithSignature("migrateTo(address,address,uint256)", user, token, amount)
694         );
695         require(ok);
696     }
697 
698     /**
699      * @notice Announce lock of the sender
700      */
701     function lock() external {
702         (bool ok,) = _implementation().delegatecall(abi.encodeWithSignature("lock()"));
703         require(ok);
704     }
705 
706     /**
707      * @notice Unlock the sender
708      */
709     function unlock() external {
710         (bool ok,) = _implementation().delegatecall(abi.encodeWithSignature("unlock()"));
711         require(ok);
712     }
713 
714     /**
715      * @notice Change the processing time of locking the user address
716      */
717     function changeProcessTime(uint256 time) external onlyOwner {
718         (bool ok,) = _implementation().delegatecall(
719             abi.encodeWithSignature("changeProcessTime(uint256)", time)
720         );
721         require(ok);
722     }
723 
724     /**
725      * @notice Get hash from the transferral parameters.
726      */
727     function getTransferralHash(
728         address from,
729         uint8 config,
730         uint32 nonce,
731         address[] calldata tos,
732         uint16[] calldata tokenIDs,
733         uint256[] calldata amounts,
734         uint256[] calldata fees
735     ) external view returns (bytes32 hash) {
736         (bool ok, bytes memory ret) = _implementation().staticcall(
737             abi.encodeWithSignature(
738                 "getTransferralHash(address,uint8,uint32,address[],uint16[],uint256[],uint256[])",
739                 from, config, nonce, tos, tokenIDs, amounts, fees
740             )
741         );
742         require(ok);
743         hash = abi.decode(ret, (bytes32));
744     }
745 }