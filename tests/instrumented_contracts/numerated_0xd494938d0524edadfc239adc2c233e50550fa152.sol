1 contract Administrable {
2     using SafeMath for uint256;
3     mapping (address => bool) private admins;
4     uint256 private _nAdmin;
5     uint256 private _nLimit;
6 
7     event Activated(address indexed admin);
8     event Deactivated(address indexed admin);
9 
10     /**
11      * @dev The Administrable constructor sets the original `admin` of the contract to the sender
12      * account. The initial limit amount of admin is 2.
13      */
14     constructor() internal {
15         _setAdminLimit(2);
16         _activateAdmin(msg.sender);
17     }
18 
19     function isAdmin() public view returns(bool) {
20         return admins[msg.sender];
21     }
22 
23     /**
24      * @dev Throws if called by non-admin.
25      */
26     modifier onlyAdmin() {
27         require(isAdmin(), "sender not admin");
28         _;
29     }
30 
31     function activateAdmin(address admin) external onlyAdmin {
32         _activateAdmin(admin);
33     }
34 
35     function deactivateAdmin(address admin) external onlyAdmin {
36         _safeDeactivateAdmin(admin);
37     }
38 
39     function setAdminLimit(uint256 n) external onlyAdmin {
40         _setAdminLimit(n);
41     }
42 
43     function _setAdminLimit(uint256 n) internal {
44         require(_nLimit != n, "same limit");
45         _nLimit = n;
46     }
47 
48     /**
49      * @notice The Amount of admin should be bounded by _nLimit.
50      */
51     function _activateAdmin(address admin) internal {
52         require(admin != address(0), "invalid address");
53         require(_nAdmin < _nLimit, "too many admins existed");
54         require(!admins[admin], "already admin");
55         admins[admin] = true;
56         _nAdmin = _nAdmin.add(1);
57         emit Activated(admin);
58     }
59 
60     /**
61      * @notice At least one admin should exists.
62      */
63     function _safeDeactivateAdmin(address admin) internal {
64         require(_nAdmin > 1, "admin should > 1");
65         _deactivateAdmin(admin);
66     }
67 
68     function _deactivateAdmin(address admin) internal {
69         require(admins[admin], "not admin");
70         admins[admin] = false;
71         _nAdmin = _nAdmin.sub(1);
72         emit Deactivated(admin);
73     }
74 }
75 
76 library ErrorHandler {
77     function errorHandler(bytes memory ret) internal pure {
78         if (ret.length > 0) {
79             byte ec = abi.decode(ret, (byte));
80             if (ec != 0x00)
81                 revert(byteToHexString(ec));
82         }
83     }
84 
85     function byteToHexString(byte data) internal pure returns (string memory ret) {
86         bytes memory ec = bytes("0x00");
87         byte dataL = data & 0x0f;
88         byte dataH = data >> 4;
89         if (dataL < 0x0a)
90             ec[3] = byte(uint8(ec[3]) + uint8(dataL));
91         else
92             ec[3] = byte(uint8(ec[3]) + uint8(dataL) + 0x27);
93         if (dataH < 0x0a)
94             ec[2] = byte(uint8(ec[2]) + uint8(dataH));
95         else
96             ec[2] = byte(uint8(ec[2]) + uint8(dataH) + 0x27);
97 
98         return string(ec);
99     }
100 }
101 
102 library SafeMath {
103     /**
104      * @dev Multiplies two unsigned integers, reverts on overflow.
105      */
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108         // benefit is lost if 'b' is also tested.
109         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint256 c = a * b;
115         require(c / a == b);
116 
117         return c;
118     }
119 
120     /**
121      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
122      */
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         // Solidity only automatically asserts when dividing by 0
125         require(b > 0);
126         uint256 c = a / b;
127         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 
129         return c;
130     }
131 
132     /**
133      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
134      */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b <= a);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Adds two unsigned integers, reverts on overflow.
144      */
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         require(c >= a);
148 
149         return c;
150     }
151 
152     /**
153      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
154      * reverts when dividing by zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b != 0);
158         return a % b;
159     }
160 }
161 
162 contract Ownable {
163     address private _owner;
164 
165     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167     /**
168      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
169      * account.
170      */
171     constructor () internal {
172         _owner = msg.sender;
173         emit OwnershipTransferred(address(0), _owner);
174     }
175 
176     /**
177      * @return the address of the owner.
178      */
179     function owner() public view returns (address) {
180         return _owner;
181     }
182 
183     /**
184      * @dev Throws if called by any account other than the owner.
185      */
186     modifier onlyOwner() {
187         require(isOwner());
188         _;
189     }
190 
191     /**
192      * @return true if `msg.sender` is the owner of the contract.
193      */
194     function isOwner() public view returns (bool) {
195         return msg.sender == _owner;
196     }
197 
198     /**
199      * @dev Allows the current owner to relinquish control of the contract.
200      * It will not be possible to call the functions with the `onlyOwner`
201      * modifier anymore.
202      * @notice Renouncing ownership will leave the contract without an owner,
203      * thereby removing any functionality that is only available to the owner.
204      */
205     function renounceOwnership() public onlyOwner {
206         emit OwnershipTransferred(_owner, address(0));
207         _owner = address(0);
208     }
209 
210     /**
211      * @dev Allows the current owner to transfer control of the contract to a newOwner.
212      * @param newOwner The address to transfer ownership to.
213      */
214     function transferOwnership(address newOwner) public onlyOwner {
215         _transferOwnership(newOwner);
216     }
217 
218     /**
219      * @dev Transfers control of the contract to a newOwner.
220      * @param newOwner The address to transfer ownership to.
221      */
222     function _transferOwnership(address newOwner) internal {
223         require(newOwner != address(0));
224         emit OwnershipTransferred(_owner, newOwner);
225         _owner = newOwner;
226     }
227 }
228 
229 library Address {
230     /**
231      * Returns whether the target address is a contract
232      * @dev This function will return false if invoked during the constructor of a contract,
233      * as the code is not actually created until after the constructor finishes.
234      * @param account address of the account to check
235      * @return whether the target address is a contract
236      */
237     function isContract(address account) internal view returns (bool) {
238         uint256 size;
239         // XXX Currently there is no better way to check if there is a contract in an address
240         // than to check the size of the code at that address.
241         // See https://ethereum.stackexchange.com/a/14016/36603
242         // for more details about how this works.
243         // TODO Check this again before the Serenity release, because all addresses will be
244         // contracts then.
245         // solhint-disable-next-line no-inline-assembly
246         assembly { size := extcodesize(account) }
247         return size > 0;
248     }
249 }
250 
251 contract Proxy is Ownable {
252     using Address for address;
253 
254     // keccak256 hash of "dinngo.proxy.implementation"
255     bytes32 private constant IMPLEMENTATION_SLOT =
256         0x3b2ff02c0f36dba7cc1b20a669e540b974575f04ef71846d482983efb03bebb4;
257 
258     event Upgraded(address indexed implementation);
259 
260     constructor(address implementation) internal {
261         assert(IMPLEMENTATION_SLOT == keccak256("dinngo.proxy.implementation"));
262         _setImplementation(implementation);
263     }
264 
265     /**
266      * @notice Upgrade the implementation contract. Can only be triggered
267      * by the owner. Emits the Upgraded event.
268      * @param implementation The new implementation address.
269      */
270     function upgrade(address implementation) external onlyOwner {
271         _setImplementation(implementation);
272         emit Upgraded(implementation);
273     }
274 
275     /**
276      * @dev Set the implementation address in the storage slot.
277      * @param implementation The new implementation address.
278      */
279     function _setImplementation(address implementation) internal {
280         require(implementation.isContract(),
281             "Implementation address should be a contract address"
282         );
283         bytes32 slot = IMPLEMENTATION_SLOT;
284 
285         assembly {
286             sstore(slot, implementation)
287         }
288     }
289 
290     /**
291      * @dev Returns the current implementation address.
292      */
293     function _implementation() internal view returns (address implementation) {
294         bytes32 slot = IMPLEMENTATION_SLOT;
295 
296         assembly {
297             implementation := sload(slot)
298         }
299     }
300 }
301 
302 contract TimelockUpgradableProxy is Proxy {
303     // keccak256 hash of "dinngo.proxy.registration"
304     bytes32 private constant REGISTRATION_SLOT =
305         0x90215db359d12011b32ff0c897114c39e26956599904ee846adb0dd49f782e97;
306     // keccak256 hash of "dinngo.proxy.time"
307     bytes32 private constant TIME_SLOT =
308         0xe89d1a29650bdc8a918bc762afb8ef07e10f6180e461c3fc305f9f142e5591e6;
309     uint256 private constant UPGRADE_TIME = 14 days;
310 
311     event UpgradeAnnounced(address indexed implementation, uint256 time);
312 
313     constructor() internal {
314         assert(REGISTRATION_SLOT == keccak256("dinngo.proxy.registration"));
315         assert(TIME_SLOT == keccak256("dinngo.proxy.time"));
316     }
317 
318     /**
319      * @notice Register the implementation address as the candidate contract
320      * to be upgraded. Emits the UpgradeAnnounced event.
321      * @param implementation The implementation contract address to be registered.
322      */
323     function register(address implementation) external onlyOwner {
324         _registerImplementation(implementation);
325         emit UpgradeAnnounced(implementation, _time());
326     }
327 
328     /**
329      * @dev Overload the function in contract Proxy.
330      * @notice Upgrade the implementation contract.
331      * @param implementation The new implementation contract.
332      */
333     function upgrade(address implementation) external {
334         require(implementation == _registration());
335         upgradeAnnounced();
336     }
337 
338     /**
339      * @notice Upgrade the implementation contract to the announced address.
340      * Emits the Upgraded event.
341      */
342     function upgradeAnnounced() public onlyOwner {
343         require(now >= _time());
344         _setImplementation(_registration());
345         emit Upgraded(_registration());
346     }
347 
348     /**
349      * @dev Register the imeplemtation address to the registation slot. Record the
350      * valid time by adding the UPGRADE_TIME to the registration time to the time slot.
351      * @param implementation The implemetation address to be registered.
352      */
353     function _registerImplementation(address implementation) internal {
354         require(implementation.isContract(),
355             "Implementation address should be a contract address"
356         );
357         uint256 time = now + UPGRADE_TIME;
358 
359         bytes32 implSlot = REGISTRATION_SLOT;
360         bytes32 timeSlot = TIME_SLOT;
361 
362         assembly {
363             sstore(implSlot, implementation)
364             sstore(timeSlot, time)
365         }
366     }
367 
368     /**
369      * @dev Return the valid time of registered implementation address.
370      */
371     function _time() internal view returns (uint256 time) {
372         bytes32 slot = TIME_SLOT;
373 
374         assembly {
375             time := sload(slot)
376         }
377     }
378 
379     /**
380      * @dev Return the registered implementation address.
381      */
382     function _registration() internal view returns (address implementation) {
383         bytes32 slot = REGISTRATION_SLOT;
384 
385         assembly {
386             implementation := sload(slot)
387         }
388     }
389 }
390 
391 contract DinngoProxy is Ownable, Administrable, TimelockUpgradableProxy {
392     using ErrorHandler for bytes;
393 
394     uint256 public processTime;
395 
396     mapping (address => mapping (address => uint256)) public balances;
397     mapping (bytes32 => uint256) public orderFills;
398     mapping (uint256 => address payable) public userID_Address;
399     mapping (uint256 => address) public tokenID_Address;
400     mapping (address => uint256) public userRanks;
401     mapping (address => uint256) public tokenRanks;
402     mapping (address => uint256) public lockTimes;
403 
404     /**
405      * @dev User ID 0 is the management wallet.
406      * Token ID 0 is ETH (address 0). Token ID 1 is DGO.
407      * @param dinngoWallet The main address of dinngo
408      * @param dinngoToken The contract address of DGO
409      */
410     constructor(
411         address payable dinngoWallet,
412         address dinngoToken,
413         address impl
414     ) Proxy(impl) public {
415         processTime = 90 days;
416         userID_Address[0] = dinngoWallet;
417         userRanks[dinngoWallet] = 255;
418         tokenID_Address[0] = address(0);
419         tokenID_Address[1] = dinngoToken;
420     }
421 
422     /**
423      * @dev All ether directly sent to contract will be refunded
424      */
425     function() external payable {
426         revert();
427     }
428 
429     /**
430      * @notice Add the address to the user list. Event AddUser will be emitted
431      * after execution.
432      * @dev Record the user list to map the user address to a specific user ID, in
433      * order to compact the data size when transferring user address information
434      * @param id The user id to be assigned
435      * @param user The user address to be added
436      */
437     function addUser(uint256 id, address user) external onlyAdmin {
438         (bool ok,) = _implementation().delegatecall(
439             abi.encodeWithSignature("addUser(uint256,address)", id, user)
440         );
441         require(ok);
442     }
443 
444     /**
445      * @notice Remove the address from the user list.
446      * @dev The user rank is set to 0 to remove the user.
447      * @param user The user address to be added
448      */
449     function removeUser(address user) external onlyAdmin {
450         (bool ok,) = _implementation().delegatecall(
451             abi.encodeWithSignature("removeUser(address)", user)
452         );
453         require(ok);
454     }
455 
456     /**
457      * @notice Update the rank of user. Can only be called by owner.
458      * @param user The user address
459      * @param rank The rank to be assigned
460      */
461     function updateUserRank(address user, uint256 rank) external onlyAdmin {
462         (bool ok,) = _implementation().delegatecall(
463             abi.encodeWithSignature("updateUserRank(address,uint256)",user, rank)
464         );
465         require(ok);
466     }
467 
468     /**
469      * @notice Add the token to the token list. Event AddToken will be emitted
470      * after execution.
471      * @dev Record the token list to map the token contract address to a specific
472      * token ID, in order to compact the data size when transferring token contract
473      * address information
474      * @param id The token id to be assigned
475      * @param token The token contract address to be added
476      */
477     function addToken(uint256 id, address token) external onlyOwner {
478         (bool ok,) = _implementation().delegatecall(
479             abi.encodeWithSignature("addToken(uint256,address)", id, token)
480         );
481         require(ok);
482     }
483 
484     /**
485      * @notice Remove the token to the token list.
486      * @dev The token rank is set to 0 to remove the token.
487      * @param token The token contract address to be removed.
488      */
489     function removeToken(address token) external onlyOwner {
490         (bool ok,) = _implementation().delegatecall(
491             abi.encodeWithSignature("removeToken(address)", token)
492         );
493         require(ok);
494     }
495 
496     /**
497      * @notice Update the rank of token. Can only be called by owner.
498      * @param token The token contract address.
499      * @param rank The rank to be assigned.
500      */
501     function updateTokenRank(address token, uint256 rank) external onlyOwner {
502         (bool ok,) = _implementation().delegatecall(
503             abi.encodeWithSignature("updateTokenRank(address,uint256)", token, rank)
504         );
505         require(ok);
506     }
507 
508     function activateAdmin(address admin) external onlyOwner {
509         _activateAdmin(admin);
510     }
511 
512     function deactivateAdmin(address admin) external onlyOwner {
513         _safeDeactivateAdmin(admin);
514     }
515 
516     /**
517      * @notice Force-deactivate allows owner to deactivate admin even there will be
518      * no admin left. Should only be executed under emergency situation.
519      */
520     function forceDeactivateAdmin(address admin) external onlyOwner {
521         _deactivateAdmin(admin);
522     }
523 
524     function setAdminLimit(uint256 n) external onlyOwner {
525         _setAdminLimit(n);
526     }
527 
528     /**
529      * @notice The deposit function for ether. The ether that is sent with the function
530      * call will be deposited. The first time user will be added to the user list.
531      * Event Deposit will be emitted after execution.
532      */
533     function deposit() external payable {
534         (bool ok,) = _implementation().delegatecall(abi.encodeWithSignature("deposit()"));
535         require(ok);
536     }
537 
538     /**
539      * @notice The deposit function for tokens. The first time user will be added to
540      * the user list. Event Deposit will be emitted after execution.
541      * @param token Address of the token contract to be deposited
542      * @param amount Amount of the token to be depositied
543      */
544     function depositToken(address token, uint256 amount) external {
545         (bool ok,) = _implementation().delegatecall(
546             abi.encodeWithSignature("depositToken(address,uint256)", token, amount)
547         );
548         require(ok);
549     }
550 
551     /**
552      * @notice The withdraw function for ether. Event Withdraw will be emitted
553      * after execution. User needs to be locked before calling withdraw.
554      * @param amount The amount to be withdrawn.
555      */
556     function withdraw(uint256 amount) external {
557         (bool ok,) = _implementation().delegatecall(
558             abi.encodeWithSignature("withdraw(uint256)", amount)
559         );
560         require(ok);
561     }
562 
563     /**
564      * @notice The withdraw function for tokens. Event Withdraw will be emitted
565      * after execution. User needs to be locked before calling withdraw.
566      * @param token The token contract address to be withdrawn.
567      * @param amount The token amount to be withdrawn.
568      */
569     function withdrawToken(address token, uint256 amount) external {
570         (bool ok,) = _implementation().delegatecall(
571             abi.encodeWithSignature("withdrawToken(address,uint256)", token, amount)
572         );
573         require(ok);
574     }
575 
576     /**
577      * @notice The withdraw function that can only be triggered by owner.
578      * Event Withdraw will be emitted after execution.
579      * @param withdrawal The serialized withdrawal data
580      */
581     function withdrawByAdmin(bytes calldata withdrawal) external onlyAdmin {
582         (bool ok, bytes memory ret) = _implementation().delegatecall(
583             abi.encodeWithSignature("withdrawByAdmin(bytes)", withdrawal)
584         );
585         require(ok);
586         ret.errorHandler();
587     }
588 
589     /**
590      * @notice The settle function for orders. First order is taker order and the followings
591      * are maker orders.
592      * @param orders The serialized orders.
593      */
594     function settle(bytes calldata orders) external onlyAdmin {
595         (bool ok, bytes memory ret) = _implementation().delegatecall(
596             abi.encodeWithSignature("settle(bytes)", orders)
597         );
598         require(ok);
599         ret.errorHandler();
600     }
601 
602     /**
603      * @notice The migrate function that can only be triggered by admin.
604      * @param migration The serialized migration data
605      */
606     function migrateByAdmin(bytes calldata migration) external onlyAdmin {
607         (bool ok, bytes memory ret) = _implementation().delegatecall(
608             abi.encodeWithSignature("migrateByAdmin(bytes)", migration)
609         );
610         require(ok);
611         ret.errorHandler();
612     }
613 
614     /**
615      * @notice Announce lock of the sender
616      */
617     function lock() external {
618         (bool ok,) = _implementation().delegatecall(abi.encodeWithSignature("lock()"));
619         require(ok);
620     }
621 
622     /**
623      * @notice Unlock the sender
624      */
625     function unlock() external {
626         (bool ok,) = _implementation().delegatecall(abi.encodeWithSignature("unlock()"));
627         require(ok);
628     }
629 
630     /**
631      * @notice Change the processing time of locking the user address
632      */
633     function changeProcessTime(uint256 time) external onlyOwner {
634         (bool ok,) = _implementation().delegatecall(
635             abi.encodeWithSignature("changeProcessTime(uint256)", time)
636         );
637         require(ok);
638     }
639 }