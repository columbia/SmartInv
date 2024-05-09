1 /**************************************************************************
2  *            ____        _                              
3  *           / ___|      | |     __ _  _   _   ___  _ __ 
4  *          | |    _____ | |    / _` || | | | / _ \| '__|
5  *          | |___|_____|| |___| (_| || |_| ||  __/| |   
6  *           \____|      |_____|\__,_| \__, | \___||_|   
7  *                                     |___/             
8  * 
9  **************************************************************************
10  *
11  *  The MIT License (MIT)
12  *
13  * Copyright (c) 2016-2019 Cyril Lapinte
14  *
15  * Permission is hereby granted, free of charge, to any person obtaining
16  * a copy of this software and associated documentation files (the
17  * "Software"), to deal in the Software without restriction, including
18  * without limitation the rights to use, copy, modify, merge, publish,
19  * distribute, sublicense, and/or sell copies of the Software, and to
20  * permit persons to whom the Software is furnished to do so, subject to
21  * the following conditions:
22  *
23  * The above copyright notice and this permission notice shall be included
24  * in all copies or substantial portions of the Software.
25  *
26  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
27  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
28  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
29  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
30  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
31  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
32  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
33  *
34  **************************************************************************
35  *
36  * Flatten Contract: TokenProxy
37  *
38  * Git Commit:
39  * https://github.com/c-layer/contracts/tree/43925ba24cc22f42d0ff7711d0e169e8c2a0e09f
40  *
41  **************************************************************************/
42 
43 
44 // File: contracts/abstract/Storage.sol
45 
46 pragma solidity >=0.5.0 <0.6.0;
47 
48 
49 /**
50  * @title Storage
51  *
52  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
53  *
54  * Error messages
55  **/
56 contract Storage {
57 
58   mapping(address => address) public proxyDelegates;
59   address[] public delegates;
60 }
61 
62 // File: contracts/util/governance/Ownable.sol
63 
64 pragma solidity >=0.5.0 <0.6.0;
65 
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  *
72  * Error messages
73  *   OW01: Only accessible as owner
74  *   OW02: New owner must be non null
75  */
76 contract Ownable {
77   address public owner;
78 
79   event OwnershipRenounced(address indexed previousOwner);
80   event OwnershipTransferred(
81     address indexed previousOwner,
82     address indexed newOwner
83   );
84 
85   /**
86    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
87    * account.
88    */
89   constructor() public {
90     owner = msg.sender;
91   }
92 
93   /**
94    * @dev Throws if called by any account other than the owner.
95    */
96   modifier onlyOwner() {
97     require(msg.sender == owner, "OW01");
98     _;
99   }
100 
101   /**
102    * @dev Allows the current owner to relinquish control of the contract.
103    */
104   function renounceOwnership() public onlyOwner {
105     emit OwnershipRenounced(owner);
106     owner = address(0);
107   }
108 
109   /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address _newOwner) public onlyOwner {
114     _transferOwnership(_newOwner);
115   }
116 
117   /**
118    * @dev Transfers control of the contract to a newOwner.
119    * @param _newOwner The address to transfer ownership to.
120    */
121   function _transferOwnership(address _newOwner) internal {
122     require(_newOwner != address(0), "OW02");
123     emit OwnershipTransferred(owner, _newOwner);
124     owner = _newOwner;
125   }
126 }
127 
128 // File: contracts/operable/OperableStorage.sol
129 
130 pragma solidity >=0.5.0 <0.6.0;
131 
132 
133 
134 /**
135  * @title OperableStorage
136  * @dev The Operable contract enable the restrictions of operations to a set of operators
137  *
138  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
139  *
140  * Error messages
141  */
142 contract OperableStorage is Ownable, Storage {
143 
144   // Hardcoded role granting all - non sysop - privileges
145   bytes32 constant internal ALL_PRIVILEGES = bytes32("AllPrivileges");
146   address constant internal ALL_PROXIES = address(0x416c6c50726f78696573); // "AllProxies"
147 
148   struct RoleData {
149     mapping(bytes4 => bool) privileges;
150   }
151 
152   struct OperatorData {
153     bytes32 coreRole;
154     mapping(address => bytes32) proxyRoles;
155   }
156 
157   // Mapping address => role
158   // Mapping role => bytes4 => bool
159   mapping (address => OperatorData) internal operators;
160   mapping (bytes32 => RoleData) internal roles;
161 
162   /**
163    * @dev core role
164    * @param _address operator address
165    */
166   function coreRole(address _address) public view returns (bytes32) {
167     return operators[_address].coreRole;
168   }
169 
170   /**
171    * @dev proxy role
172    * @param _address operator address
173    */
174   function proxyRole(address _proxy, address _address)
175     public view returns (bytes32)
176   {
177     return operators[_address].proxyRoles[_proxy];
178   }
179 
180   /**
181    * @dev has role privilege
182    * @dev low level access to role privilege
183    * @dev ignores ALL_PRIVILEGES role
184    */
185   function rolePrivilege(bytes32 _role, bytes4 _privilege)
186     public view returns (bool)
187   {
188     return roles[_role].privileges[_privilege];
189   }
190 
191   /**
192    * @dev roleHasPrivilege
193    */
194   function roleHasPrivilege(bytes32 _role, bytes4 _privilege) public view returns (bool) {
195     return (_role == ALL_PRIVILEGES) || roles[_role].privileges[_privilege];
196   }
197 
198   /**
199    * @dev hasCorePrivilege
200    * @param _address operator address
201    */
202   function hasCorePrivilege(address _address, bytes4 _privilege) public view returns (bool) {
203     bytes32 role = operators[_address].coreRole;
204     return (role == ALL_PRIVILEGES) || roles[role].privileges[_privilege];
205   }
206 
207   /**
208    * @dev hasProxyPrivilege
209    * @dev the default proxy role can be set with proxy address(0)
210    * @param _address operator address
211    */
212   function hasProxyPrivilege(address _address, address _proxy, bytes4 _privilege) public view returns (bool) {
213     OperatorData storage data = operators[_address];
214     bytes32 role = (data.proxyRoles[_proxy] != bytes32(0)) ?
215       data.proxyRoles[_proxy] : data.proxyRoles[ALL_PROXIES];
216     return (role == ALL_PRIVILEGES) || roles[role].privileges[_privilege];
217   }
218 }
219 
220 // File: contracts/util/convert/BytesConvert.sol
221 
222 pragma solidity >=0.5.0 <0.6.0;
223 
224 
225 /**
226  * @title BytesConvert
227  * @dev Convert bytes into different types
228  *
229  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
230  *
231  * Error Messages:
232  *   BC01: source must be a valid 32-bytes length
233  *   BC02: source must not be greater than 32-bytes
234  **/
235 library BytesConvert {
236 
237   /**
238   * @dev toUint256
239   */
240   function toUint256(bytes memory _source) internal pure returns (uint256 result) {
241     require(_source.length == 32, "BC01");
242     // solhint-disable-next-line no-inline-assembly
243     assembly {
244       result := mload(add(_source, 0x20))
245     }
246   }
247 
248   /**
249   * @dev toBytes32
250   */
251   function toBytes32(bytes memory _source) internal pure returns (bytes32 result) {
252     require(_source.length <= 32, "BC02");
253     // solhint-disable-next-line no-inline-assembly
254     assembly {
255       result := mload(add(_source, 0x20))
256     }
257   }
258 }
259 
260 // File: contracts/abstract/Core.sol
261 
262 pragma solidity >=0.5.0 <0.6.0;
263 
264 
265 
266 
267 /**
268  * @title Core
269  * @dev Solidity version 0.5.x prevents to mark as view
270  * @dev functions using delegate call.
271  *
272  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
273  *
274  * Error messages
275  *   CO01: Only Proxy may access the function
276  *   CO02: The proxy has no delegates
277  *   CO03: Delegatecall should be successfull
278  *   CO04: Invalid delegateId
279  *   CO05: Proxy must exist
280  **/
281 contract Core is Storage {
282   using BytesConvert for bytes;
283 
284   modifier onlyProxy {
285     require(proxyDelegates[msg.sender] != address(0), "CO01");
286     _;
287   }
288 
289   function delegateCall(address _proxy) internal returns (bool status)
290   {
291     address delegate = proxyDelegates[_proxy];
292     require(delegate != address(0), "CO02");
293     // solhint-disable-next-line avoid-low-level-calls
294     (status, ) = delegate.delegatecall(msg.data);
295     require(status, "CO03");
296   }
297 
298   function delegateCallUint256(address _proxy)
299     internal returns (uint256)
300   {
301     return delegateCallBytes(_proxy).toUint256();
302   }
303 
304   function delegateCallBytes(address _proxy)
305     internal returns (bytes memory result)
306   {
307     bool status;
308     address delegate = proxyDelegates[_proxy];
309     require(delegate != address(0), "CO04");
310     // solhint-disable-next-line avoid-low-level-calls
311     (status, result) = delegate.delegatecall(msg.data);
312     require(status, "CO03");
313   }
314 
315   function defineProxy(
316     address _proxy,
317     uint256 _delegateId)
318     internal returns (bool)
319   {
320     require(_delegateId < delegates.length, "CO04");
321     address delegate = delegates[_delegateId];
322 
323     require(_proxy != address(0), "CO05");
324     proxyDelegates[_proxy] = delegate;
325     return true;
326   }
327 
328   function removeProxy(address _proxy)
329     internal returns (bool)
330   {
331     delete proxyDelegates[_proxy];
332     return true;
333   }
334 }
335 
336 // File: contracts/operable/OperableCore.sol
337 
338 pragma solidity >=0.5.0 <0.6.0;
339 
340 
341 
342 
343 /**
344  * @title OperableCore
345  * @dev The Operable contract enable the restrictions of operations to a set of operators
346  *
347  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
348  *
349  * Error messages
350  *   OC01: Sender is not a system operator
351  *   OC02: Sender is not a core operator
352  *   OC03: Sender is not a proxy operator
353  *   OC04: AllPrivileges is a reserved role
354  */
355 contract OperableCore is Core, OperableStorage {
356 
357   constructor() public {
358     operators[msg.sender].coreRole = ALL_PRIVILEGES;
359     operators[msg.sender].proxyRoles[ALL_PROXIES] = ALL_PRIVILEGES;
360   }
361 
362   /**
363    * @dev onlySysOp modifier
364    * @dev for safety reason, core owner
365    * @dev can always define roles and assign or revoke operatos
366    */
367   modifier onlySysOp() {
368     require(msg.sender == owner || hasCorePrivilege(msg.sender, msg.sig), "OC01");
369     _;
370   }
371 
372   /**
373    * @dev onlyCoreOp modifier
374    */
375   modifier onlyCoreOp() {
376     require(hasCorePrivilege(msg.sender, msg.sig), "OC02");
377     _;
378   }
379 
380   /**
381    * @dev onlyProxyOp modifier
382    */
383   modifier onlyProxyOp(address _proxy) {
384     require(hasProxyPrivilege(msg.sender, _proxy, msg.sig), "OC03");
385     _;
386   }
387 
388   /**
389    * @dev defineRoles
390    * @param _role operator role
391    * @param _privileges as 4 bytes of the method
392    */
393   function defineRole(bytes32 _role, bytes4[] memory _privileges)
394     public onlySysOp returns (bool)
395   {
396     require(_role != ALL_PRIVILEGES, "OC04");
397     delete roles[_role];
398     for (uint256 i=0; i < _privileges.length; i++) {
399       roles[_role].privileges[_privileges[i]] = true;
400     }
401     emit RoleDefined(_role);
402     return true;
403   }
404 
405   /**
406    * @dev assignOperators
407    * @param _role operator role. May be a role not defined yet.
408    * @param _operators addresses
409    */
410   function assignOperators(bytes32 _role, address[] memory _operators)
411     public onlySysOp returns (bool)
412   {
413     for (uint256 i=0; i < _operators.length; i++) {
414       operators[_operators[i]].coreRole = _role;
415       emit OperatorAssigned(_role, _operators[i]);
416     }
417     return true;
418   }
419 
420   /**
421    * @dev assignProxyOperators
422    * @param _role operator role. May be a role not defined yet.
423    * @param _operators addresses
424    */
425   function assignProxyOperators(
426     address _proxy, bytes32 _role, address[] memory _operators)
427     public onlySysOp returns (bool)
428   {
429     for (uint256 i=0; i < _operators.length; i++) {
430       operators[_operators[i]].proxyRoles[_proxy] = _role;
431       emit ProxyOperatorAssigned(_proxy, _role, _operators[i]);
432     }
433     return true;
434   }
435 
436   /**
437    * @dev removeOperator
438    * @param _operators addresses
439    */
440   function revokeOperators(address[] memory _operators)
441     public onlySysOp returns (bool)
442   {
443     for (uint256 i=0; i < _operators.length; i++) {
444       delete operators[_operators[i]];
445       emit OperatorRevoked(_operators[i]);
446     }
447     return true;
448   }
449 
450   event RoleDefined(bytes32 role);
451   event OperatorAssigned(bytes32 role, address operator);
452   event ProxyOperatorAssigned(address proxy, bytes32 role, address operator);
453   event OperatorRevoked(address operator);
454 }
455 
456 // File: contracts/abstract/Proxy.sol
457 
458 pragma solidity >=0.5.0 <0.6.0;
459 
460 /**
461  * @title Proxy
462  *
463  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
464  *
465  * Error messages
466  *   PR01: Only accessible by core
467  **/
468 contract Proxy {
469 
470   address public core;
471 
472   /**
473    * @dev Throws if called by any account other than a proxy
474    */
475   modifier onlyCore {
476     require(core == msg.sender, "PR01");
477     _;
478   }
479 
480   constructor(address _core) public {
481     core = _core;
482   }
483 }
484 
485 // File: contracts/operable/OperableProxy.sol
486 
487 pragma solidity >=0.5.0 <0.6.0;
488 
489 
490 
491 
492 /**
493  * @title OperableProxy
494  * @dev The OperableAs contract enable the restrictions of operations to a set of operators
495  * @dev It relies on another Operable contract and reuse the same list of operators
496  *
497  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
498  *
499  * Error messages
500  * OP01: Message sender must be authorized
501  */
502 contract OperableProxy is Proxy {
503 
504   // solhint-disable-next-line no-empty-blocks
505   constructor(address _core) public Proxy(_core) { }
506 
507   /**
508    * @dev rely on the core configuration for ownership
509    */
510   function owner() public view returns (address) {
511     return OperableCore(core).owner();
512   }
513 
514   /**
515    * @dev Throws if called by any account other than the operator
516    */
517   modifier onlyOperator {
518     require(OperableCore(core).hasProxyPrivilege(
519       msg.sender, address(this), msg.sig), "OP01");
520     _;
521   }
522 }
523 
524 // File: contracts/util/math/SafeMath.sol
525 
526 pragma solidity >=0.5.0 <0.6.0;
527 
528 
529 /**
530  * @title SafeMath
531  * @dev Math operations with safety checks that throw on error
532  */
533 library SafeMath {
534 
535   /**
536   * @dev Multiplies two numbers, throws on overflow.
537   */
538   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
539     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
540     // benefit is lost if 'b' is also tested.
541     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
542     if (a == 0) {
543       return 0;
544     }
545 
546     c = a * b;
547     assert(c / a == b);
548     return c;
549   }
550 
551   /**
552   * @dev Integer division of two numbers, truncating the quotient.
553   */
554   function div(uint256 a, uint256 b) internal pure returns (uint256) {
555     // assert(b > 0); // Solidity automatically throws when dividing by 0
556     // uint256 c = a / b;
557     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
558     return a / b;
559   }
560 
561   /**
562   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
563   */
564   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
565     assert(b <= a);
566     return a - b;
567   }
568 
569   /**
570   * @dev Adds two numbers, throws on overflow.
571   */
572   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
573     c = a + b;
574     assert(c >= a);
575     return c;
576   }
577 }
578 
579 // File: contracts/interface/IRule.sol
580 
581 pragma solidity >=0.5.0 <0.6.0;
582 
583 
584 /**
585  * @title IRule
586  * @dev IRule interface
587  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
588  **/
589 interface IRule {
590   function isAddressValid(address _address) external view returns (bool);
591   function isTransferValid(address _from, address _to, uint256 _amount)
592     external view returns (bool);
593 }
594 
595 // File: contracts/interface/IClaimable.sol
596 
597 pragma solidity >=0.5.0 <0.6.0;
598 
599 
600 /**
601  * @title IClaimable
602  * @dev IClaimable interface
603  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
604  **/
605 contract IClaimable {
606   function hasClaimsSince(address _address, uint256 at)
607     external view returns (bool);
608 }
609 
610 // File: contracts/interface/IUserRegistry.sol
611 
612 pragma solidity >=0.5.0 <0.6.0;
613 
614 
615 /**
616  * @title IUserRegistry
617  * @dev IUserRegistry interface
618  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
619  **/
620 contract IUserRegistry {
621 
622   event UserRegistered(uint256 indexed userId);
623   event AddressAttached(uint256 indexed userId, address address_);
624   event AddressDetached(uint256 indexed userId, address address_);
625 
626   function registerManyUsersExternal(address[] calldata _addresses, uint256 _validUntilTime)
627     external returns (bool);
628   function registerManyUsersFullExternal(
629     address[] calldata _addresses,
630     uint256 _validUntilTime,
631     uint256[] calldata _values) external returns (bool);
632   function attachManyAddressesExternal(uint256[] calldata _userIds, address[] calldata _addresses)
633     external returns (bool);
634   function detachManyAddressesExternal(address[] calldata _addresses)
635     external returns (bool);
636   function suspendManyUsers(uint256[] calldata _userIds) external returns (bool);
637   function unsuspendManyUsersExternal(uint256[] calldata _userIds) external returns (bool);
638   function updateManyUsersExternal(
639     uint256[] calldata _userIds,
640     uint256 _validUntilTime,
641     bool _suspended) external returns (bool);
642   function updateManyUsersExtendedExternal(
643     uint256[] calldata _userIds,
644     uint256 _key, uint256 _value) external returns (bool);
645   function updateManyUsersAllExtendedExternal(
646     uint256[] calldata _userIds,
647     uint256[] calldata _values) external returns (bool);
648   function updateManyUsersFullExternal(
649     uint256[] calldata _userIds,
650     uint256 _validUntilTime,
651     bool _suspended,
652     uint256[] calldata _values) external returns (bool);
653 
654   function name() public view returns (string memory);
655   function currency() public view returns (bytes32);
656 
657   function userCount() public view returns (uint256);
658   function userId(address _address) public view returns (uint256);
659   function validUserId(address _address) public view returns (uint256);
660   function validUser(address _address, uint256[] memory _keys)
661     public view returns (uint256, uint256[] memory);
662   function validity(uint256 _userId) public view returns (uint256, bool);
663 
664   function extendedKeys() public view returns (uint256[] memory);
665   function extended(uint256 _userId, uint256 _key)
666     public view returns (uint256);
667   function manyExtended(uint256 _userId, uint256[] memory _key)
668     public view returns (uint256[] memory);
669 
670   function isAddressValid(address _address) public view returns (bool);
671   function isValid(uint256 _userId) public view returns (bool);
672 
673   function defineExtendedKeys(uint256[] memory _extendedKeys) public returns (bool);
674 
675   function registerUser(address _address, uint256 _validUntilTime)
676     public returns (bool);
677   function registerUserFull(
678     address _address,
679     uint256 _validUntilTime,
680     uint256[] memory _values) public returns (bool);
681 
682   function attachAddress(uint256 _userId, address _address) public returns (bool);
683   function detachAddress(address _address) public returns (bool);
684   function detachSelf() public returns (bool);
685   function detachSelfAddress(address _address) public returns (bool);
686   function suspendUser(uint256 _userId) public returns (bool);
687   function unsuspendUser(uint256 _userId) public returns (bool);
688   function updateUser(uint256 _userId, uint256 _validUntilTime, bool _suspended)
689     public returns (bool);
690   function updateUserExtended(uint256 _userId, uint256 _key, uint256 _value)
691     public returns (bool);
692   function updateUserAllExtended(uint256 _userId, uint256[] memory _values)
693     public returns (bool);
694   function updateUserFull(
695     uint256 _userId,
696     uint256 _validUntilTime,
697     bool _suspended,
698     uint256[] memory _values) public returns (bool);
699 }
700 
701 // File: contracts/interface/IRatesProvider.sol
702 
703 pragma solidity >=0.5.0 <0.6.0;
704 
705 
706 /**
707  * @title IRatesProvider
708  * @dev IRatesProvider interface
709  *
710  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
711  */
712 contract IRatesProvider {
713 
714   function defineRatesExternal(uint256[] calldata _rates) external returns (bool);
715 
716   function name() public view returns (string memory);
717 
718   function rate(bytes32 _currency) public view returns (uint256);
719 
720   function currencies() public view
721     returns (bytes32[] memory, uint256[] memory, uint256);
722   function rates() public view returns (uint256, uint256[] memory);
723 
724   function convert(uint256 _amount, bytes32 _fromCurrency, bytes32 _toCurrency)
725     public view returns (uint256);
726 
727   function defineCurrencies(
728     bytes32[] memory _currencies,
729     uint256[] memory _decimals,
730     uint256 _rateOffset) public returns (bool);
731   function defineRates(uint256[] memory _rates) public returns (bool);
732 
733   event RateOffset(uint256 rateOffset);
734   event Currencies(bytes32[] currencies, uint256[] decimals);
735   event Rate(uint256 at, bytes32 indexed currency, uint256 rate);
736 }
737 
738 // File: contracts/TokenStorage.sol
739 
740 pragma solidity >=0.5.0 <0.6.0;
741 
742 
743 
744 
745 
746 
747 
748 
749 /**
750  * @title Token storage
751  * @dev Token storage
752  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
753  */
754 contract TokenStorage is OperableStorage {
755   using SafeMath for uint256;
756 
757   enum TransferCode {
758     UNKNOWN,
759     OK,
760     INVALID_SENDER,
761     NO_RECIPIENT,
762     INSUFFICIENT_TOKENS,
763     LOCKED,
764     FROZEN,
765     RULE,
766     LIMITED_RECEPTION
767   }
768 
769   struct Proof {
770     uint256 amount;
771     uint64 startAt;
772     uint64 endAt;
773   }
774 
775   struct AuditData {
776     uint64 createdAt;
777     uint64 lastTransactionAt;
778     uint64 lastEmissionAt;
779     uint64 lastReceptionAt;
780     uint256 cumulatedEmission;
781     uint256 cumulatedReception;
782   }
783 
784   struct AuditStorage {
785     mapping (address => bool) selector;
786 
787     AuditData sharedData;
788     mapping(uint256 => AuditData) userData;
789     mapping(address => AuditData) addressData;
790   }
791 
792   struct Lock {
793     uint256 startAt;
794     uint256 endAt;
795     mapping(address => bool) exceptions;
796   }
797 
798   struct TokenData {
799     string name;
800     string symbol;
801     uint256 decimals;
802 
803     uint256 totalSupply;
804     mapping (address => uint256) balances;
805     mapping (address => mapping (address => uint256)) allowed;
806 
807     bool mintingFinished;
808 
809     uint256 allTimeIssued; // potential overflow
810     uint256 allTimeRedeemed; // potential overflow
811     uint256 allTimeSeized; // potential overflow
812 
813     mapping (address => Proof[]) proofs;
814     mapping (address => uint256) frozenUntils;
815 
816     Lock lock;
817     IRule[] rules;
818     IClaimable[] claimables;
819   }
820   mapping (address => TokenData) internal tokens_;
821   mapping (address => mapping (uint256 => AuditStorage)) internal audits;
822 
823   IUserRegistry internal userRegistry;
824   IRatesProvider internal ratesProvider;
825 
826   bytes32 internal currency;
827   uint256[] internal userKeys;
828 
829   string internal name_;
830 
831   /**
832    * @dev currentTime()
833    */
834   function currentTime() internal view returns (uint64) {
835     // solhint-disable-next-line not-rely-on-time
836     return uint64(now);
837   }
838 
839   event OraclesDefined(
840     IUserRegistry userRegistry,
841     IRatesProvider ratesProvider,
842     bytes32 currency,
843     uint256[] userKeys);
844   event AuditSelectorDefined(
845     address indexed scope, uint256 scopeId, address[] addresses, bool[] values);
846   event Issue(address indexed token, uint256 amount);
847   event Redeem(address indexed token, uint256 amount);
848   event Mint(address indexed token, uint256 amount);
849   event MintFinished(address indexed token);
850   event ProofCreated(address indexed token, address indexed holder, uint256 proofId);
851   event RulesDefined(address indexed token, IRule[] rules);
852   event LockDefined(
853     address indexed token,
854     uint256 startAt,
855     uint256 endAt,
856     address[] exceptions
857   );
858   event Seize(address indexed token, address account, uint256 amount);
859   event Freeze(address address_, uint256 until);
860   event ClaimablesDefined(address indexed token, IClaimable[] claimables);
861   event TokenDefined(
862     address indexed token,
863     uint256 delegateId,
864     string name,
865     string symbol,
866     uint256 decimals);
867   event TokenRemoved(address indexed token);
868 }
869 
870 // File: contracts/interface/ITokenCore.sol
871 
872 pragma solidity >=0.5.0 <0.6.0;
873 
874 
875 
876 
877 
878 
879 
880 /**
881  * @title ITokenCore
882  *
883  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
884  *
885  * Error messages
886  **/
887 contract ITokenCore {
888 
889   function name() public view returns (string memory);
890   function oracles() public view returns
891     (IUserRegistry, IRatesProvider, bytes32, uint256[] memory);
892 
893   function auditSelector(
894     address _scope,
895     uint256 _scopeId,
896     address[] memory _addresses)
897     public view returns (bool[] memory);
898   function auditShared(
899     address _scope,
900     uint256 _scopeId) public view returns (
901     uint64 createdAt,
902     uint64 lastTransactionAt,
903     uint64 lastEmissionAt,
904     uint64 lastReceptionAt,
905     uint256 cumulatedEmission,
906     uint256 cumulatedReception);
907   function auditUser(
908     address _scope,
909     uint256 _scopeId,
910     uint256 _userId) public view returns (
911     uint64 createdAt,
912     uint64 lastTransactionAt,
913     uint64 lastEmissionAt,
914     uint64 lastReceptionAt,
915     uint256 cumulatedEmission,
916     uint256 cumulatedReception);
917   function auditAddress(
918     address _scope,
919     uint256 _scopeId,
920     address _holder) public view returns (
921     uint64 createdAt,
922     uint64 lastTransactionAt,
923     uint64 lastEmissionAt,
924     uint64 lastReceptionAt,
925     uint256 cumulatedEmission,
926     uint256 cumulatedReception);
927 
928   /***********  TOKEN DATA   ***********/
929   function token(address _token) public view returns (
930     bool mintingFinished,
931     uint256 allTimeIssued,
932     uint256 allTimeRedeemed,
933     uint256 allTimeSeized,
934     uint256[2] memory lock,
935     uint256 freezedUntil,
936     IRule[] memory,
937     IClaimable[] memory);
938   function tokenProofs(address _token, address _holder, uint256 _proofId)
939     public view returns (uint256, uint64, uint64);
940   function canTransfer(address, address, uint256)
941     public returns (uint256);
942 
943   /***********  TOKEN ADMIN  ***********/
944   function issue(address, uint256)
945     public returns (bool);
946   function redeem(address, uint256)
947     public returns (bool);
948   function mint(address, address, uint256)
949     public returns (bool);
950   function finishMinting(address)
951     public returns (bool);
952   function mintAtOnce(address, address[] memory, uint256[] memory)
953     public returns (bool);
954   function seize(address _token, address, uint256)
955     public returns (bool);
956   function freezeManyAddresses(
957     address _token,
958     address[] memory _addresses,
959     uint256 _until) public returns (bool);
960   function createProof(address, address)
961     public returns (bool);
962   function defineLock(address, uint256, uint256, address[] memory)
963     public returns (bool);
964   function defineRules(address, IRule[] memory) public returns (bool);
965   function defineClaimables(address, IClaimable[] memory) public returns (bool);
966 
967   /************  CORE ADMIN  ************/
968   function defineToken(
969     address _token,
970     uint256 _delegateId,
971     string memory _name,
972     string memory _symbol,
973     uint256 _decimals) public returns (bool);
974   function removeToken(address _token) public returns (bool);
975   function defineOracles(
976     IUserRegistry _userRegistry,
977     IRatesProvider _ratesProvider,
978     uint256[] memory _userKeys) public returns (bool);
979   function defineAuditSelector(
980     address _scope,
981     uint256 _scopeId,
982     address[] memory _selectorAddresses,
983     bool[] memory _selectorValues) public returns (bool);
984 
985 
986   event OraclesDefined(
987     IUserRegistry userRegistry,
988     IRatesProvider ratesProvider,
989     bytes32 currency,
990     uint256[] userKeys);
991   event AuditSelectorDefined(
992     address indexed scope, uint256 scopeId, address[] addresses, bool[] values);
993   event Issue(address indexed token, uint256 amount);
994   event Redeem(address indexed token, uint256 amount);
995   event Mint(address indexed token, uint256 amount);
996   event MintFinished(address indexed token);
997   event ProofCreated(address indexed token, address holder, uint256 proofId);
998   event RulesDefined(address indexed token, IRule[] rules);
999   event LockDefined(
1000     address indexed token,
1001     uint256 startAt,
1002     uint256 endAt,
1003     address[] exceptions
1004   );
1005   event Seize(address indexed token, address account, uint256 amount);
1006   event Freeze(address address_, uint256 until);
1007   event ClaimablesDefined(address indexed token, IClaimable[] claimables);
1008   event TokenDefined(
1009     address indexed token,
1010     uint256 delegateId,
1011     string name,
1012     string symbol,
1013     uint256 decimals);
1014   event TokenRemoved(address indexed token);
1015 }
1016 
1017 // File: contracts/TokenCore.sol
1018 
1019 pragma solidity >=0.5.0 <0.6.0;
1020 
1021 
1022 
1023 
1024 
1025 /**
1026  * @title TokenCore
1027  *
1028  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
1029  *
1030  * Error messages
1031  *   TC01: Currency stored values must remain consistent
1032  *   TC02: The audit selector definition requires the same number of addresses and values
1033  **/
1034 contract TokenCore is ITokenCore, OperableCore, TokenStorage {
1035 
1036   /**
1037    * @dev constructor
1038    *
1039    * @dev It is desired for now that delegates
1040    * @dev cannot be changed once the core has been deployed.
1041    */
1042   constructor(string memory _name, address[] memory _delegates) public {
1043     name_ = _name;
1044     delegates = _delegates;
1045   }
1046 
1047   function name() public view returns (string memory) {
1048     return name_;
1049   }
1050 
1051   function oracles() public view returns
1052     (IUserRegistry, IRatesProvider, bytes32, uint256[] memory)
1053   {
1054     return (userRegistry, ratesProvider, currency, userKeys);
1055   }
1056 
1057   function auditSelector(
1058     address _scope,
1059     uint256 _scopeId,
1060     address[] memory _addresses)
1061     public view returns (bool[] memory)
1062   {
1063     AuditStorage storage auditStorage = audits[_scope][_scopeId];
1064     bool[] memory selector = new bool[](_addresses.length);
1065     for (uint256 i=0; i < _addresses.length; i++) {
1066       selector[i] = auditStorage.selector[_addresses[i]];
1067     }
1068     return selector;
1069   }
1070 
1071   function auditShared(
1072     address _scope,
1073     uint256 _scopeId) public view returns (
1074     uint64 createdAt,
1075     uint64 lastTransactionAt,
1076     uint64 lastEmissionAt,
1077     uint64 lastReceptionAt,
1078     uint256 cumulatedEmission,
1079     uint256 cumulatedReception)
1080   {
1081     AuditData memory audit = audits[_scope][_scopeId].sharedData;
1082     createdAt = audit.createdAt;
1083     lastTransactionAt = audit.lastTransactionAt;
1084     lastReceptionAt = audit.lastReceptionAt;
1085     lastEmissionAt = audit.lastEmissionAt;
1086     cumulatedReception = audit.cumulatedReception;
1087     cumulatedEmission = audit.cumulatedEmission;
1088   }
1089 
1090   function auditUser(
1091     address _scope,
1092     uint256 _scopeId,
1093     uint256 _userId) public view returns (
1094     uint64 createdAt,
1095     uint64 lastTransactionAt,
1096     uint64 lastEmissionAt,
1097     uint64 lastReceptionAt,
1098     uint256 cumulatedEmission,
1099     uint256 cumulatedReception)
1100   {
1101     AuditData memory audit = audits[_scope][_scopeId].userData[_userId];
1102     createdAt = audit.createdAt;
1103     lastTransactionAt = audit.lastTransactionAt;
1104     lastReceptionAt = audit.lastReceptionAt;
1105     lastEmissionAt = audit.lastEmissionAt;
1106     cumulatedReception = audit.cumulatedReception;
1107     cumulatedEmission = audit.cumulatedEmission;
1108   }
1109 
1110   function auditAddress(
1111     address _scope,
1112     uint256 _scopeId,
1113     address _holder) public view returns (
1114     uint64 createdAt,
1115     uint64 lastTransactionAt,
1116     uint64 lastEmissionAt,
1117     uint64 lastReceptionAt,
1118     uint256 cumulatedEmission,
1119     uint256 cumulatedReception)
1120   {
1121     AuditData memory audit = audits[_scope][_scopeId].addressData[_holder];
1122     createdAt = audit.createdAt;
1123     lastTransactionAt = audit.lastTransactionAt;
1124     lastReceptionAt = audit.lastReceptionAt;
1125     lastEmissionAt = audit.lastEmissionAt;
1126     cumulatedReception = audit.cumulatedReception;
1127     cumulatedEmission = audit.cumulatedEmission;
1128   }
1129 
1130   /**************  ERC20  **************/
1131   function tokenName() public view returns (string memory) {
1132     return tokens_[msg.sender].name;
1133   }
1134 
1135   function tokenSymbol() public view returns (string memory) {
1136     return tokens_[msg.sender].symbol;
1137   }
1138 
1139   function tokenDecimals() public view returns (uint256) {
1140     return tokens_[msg.sender].decimals;
1141   }
1142 
1143   function tokenTotalSupply() public view returns (uint256) {
1144     return tokens_[msg.sender].totalSupply;
1145   }
1146 
1147   function tokenBalanceOf(address _owner) public view returns (uint256) {
1148     return tokens_[msg.sender].balances[_owner];
1149   }
1150 
1151   function tokenAllowance(address _owner, address _spender)
1152     public view returns (uint256)
1153   {
1154     return tokens_[msg.sender].allowed[_owner][_spender];
1155   }
1156 
1157   function transfer(address, address, uint256)
1158     public onlyProxy returns (bool status)
1159   {
1160     return delegateCall(msg.sender);
1161   }
1162 
1163   function transferFrom(address, address, address, uint256)
1164     public onlyProxy returns (bool status)
1165   {
1166     return delegateCall(msg.sender);
1167   }
1168 
1169   function approve(address, address, uint256)
1170     public onlyProxy returns (bool status)
1171   {
1172     return delegateCall(msg.sender);
1173   }
1174 
1175   function increaseApproval(address, address, uint256)
1176     public onlyProxy returns (bool status)
1177   {
1178     return delegateCall(msg.sender);
1179   }
1180 
1181   function decreaseApproval(address, address, uint256)
1182     public onlyProxy returns (bool status)
1183   {
1184     return delegateCall(msg.sender);
1185   }
1186 
1187   function canTransfer(address, address, uint256)
1188     public onlyProxy returns (uint256)
1189   {
1190     return delegateCallUint256(msg.sender);
1191   }
1192 
1193   /***********  TOKEN DATA   ***********/
1194   function token(address _token) public view returns (
1195     bool mintingFinished,
1196     uint256 allTimeIssued,
1197     uint256 allTimeRedeemed,
1198     uint256 allTimeSeized,
1199     uint256[2] memory lock,
1200     uint256 frozenUntil,
1201     IRule[] memory rules,
1202     IClaimable[] memory claimables) {
1203     TokenData storage tokenData = tokens_[_token];
1204 
1205     mintingFinished = tokenData.mintingFinished;
1206     allTimeIssued = tokenData.allTimeIssued;
1207     allTimeRedeemed = tokenData.allTimeRedeemed;
1208     allTimeSeized = tokenData.allTimeSeized;
1209     lock = [ tokenData.lock.startAt, tokenData.lock.endAt ];
1210     frozenUntil = tokenData.frozenUntils[msg.sender];
1211     rules = tokenData.rules;
1212     claimables = tokenData.claimables;
1213   }
1214 
1215   function tokenProofs(address _token, address _holder, uint256 _proofId)
1216     public view returns (uint256, uint64, uint64)
1217   {
1218     Proof[] storage proofs = tokens_[_token].proofs[_holder];
1219     if (_proofId < proofs.length) {
1220       Proof storage proof = proofs[_proofId];
1221       return (proof.amount, proof.startAt, proof.endAt);
1222     }
1223     return (uint256(0), uint64(0), uint64(0));
1224   }
1225 
1226   /***********  TOKEN ADMIN  ***********/
1227   function issue(address _token, uint256)
1228     public onlyProxyOp(_token) returns (bool)
1229   {
1230     return delegateCall(_token);
1231   }
1232 
1233   function redeem(address _token, uint256)
1234     public onlyProxyOp(_token) returns (bool)
1235   {
1236     return delegateCall(_token);
1237   }
1238 
1239   function mint(address _token, address, uint256)
1240     public onlyProxyOp(_token) returns (bool)
1241   {
1242     return delegateCall(_token);
1243   }
1244 
1245   function finishMinting(address _token)
1246     public onlyProxyOp(_token) returns (bool)
1247   {
1248     return delegateCall(_token);
1249   }
1250 
1251   function mintAtOnce(address _token, address[] memory, uint256[] memory)
1252     public onlyProxyOp(_token) returns (bool)
1253   {
1254     return delegateCall(_token);
1255   }
1256 
1257   function seize(address _token, address, uint256)
1258     public onlyProxyOp(_token) returns (bool)
1259   {
1260     return delegateCall(_token);
1261   }
1262 
1263   function freezeManyAddresses(
1264     address _token,
1265     address[] memory,
1266     uint256) public onlyProxyOp(_token) returns (bool)
1267   {
1268     return delegateCall(_token);
1269   }
1270 
1271   function createProof(address _token, address)
1272     public returns (bool)
1273   {
1274     return delegateCall(_token);
1275   }
1276 
1277   function defineLock(address _token, uint256, uint256, address[] memory)
1278     public onlyProxyOp(_token) returns (bool)
1279   {
1280     return delegateCall(_token);
1281   }
1282 
1283   function defineRules(address _token, IRule[] memory)
1284     public onlyProxyOp(_token) returns (bool)
1285   {
1286     return delegateCall(_token);
1287   }
1288 
1289   function defineClaimables(address _token, IClaimable[] memory)
1290     public onlyProxyOp(_token) returns (bool)
1291   {
1292     return delegateCall(_token);
1293   }
1294 
1295   /************  CORE ADMIN  ************/
1296   function defineToken(
1297     address _token,
1298     uint256 _delegateId,
1299     string memory _name,
1300     string memory _symbol,
1301     uint256 _decimals)
1302     public onlyCoreOp returns (bool)
1303   {
1304     defineProxy(_token, _delegateId);
1305     TokenData storage tokenData = tokens_[_token];
1306     tokenData.name = _name;
1307     tokenData.symbol = _symbol;
1308     tokenData.decimals = _decimals;
1309 
1310     emit TokenDefined(_token, _delegateId, _name, _symbol, _decimals);
1311     return true;
1312   }
1313 
1314   function removeToken(address _token)
1315     public onlyCoreOp returns (bool)
1316   {
1317     removeProxy(_token);
1318     delete tokens_[_token];
1319 
1320     emit TokenRemoved(_token);
1321     return true;
1322   }
1323 
1324   function defineOracles(
1325     IUserRegistry _userRegistry,
1326     IRatesProvider _ratesProvider,
1327     uint256[] memory _userKeys)
1328     public onlyCoreOp returns (bool)
1329   {
1330     if (currency != bytes32(0)) {
1331       // Updating the core currency is not yet supported
1332       require(_userRegistry.currency() == currency, "TC01");
1333     } else {
1334       currency = _userRegistry.currency();
1335     }
1336     userRegistry = _userRegistry;
1337     ratesProvider = _ratesProvider;
1338     userKeys = _userKeys;
1339 
1340     emit OraclesDefined(userRegistry, ratesProvider, currency, userKeys);
1341     return true;
1342   }
1343 
1344   function defineAuditSelector(
1345     address _scope,
1346     uint256 _scopeId,
1347     address[] memory _selectorAddresses,
1348     bool[] memory _selectorValues) public onlyCoreOp returns (bool)
1349   {
1350     require(_selectorAddresses.length == _selectorValues.length, "TC02");
1351 
1352     AuditStorage storage auditStorage = audits[_scope][_scopeId];
1353     for (uint256 i=0; i < _selectorAddresses.length; i++) {
1354       auditStorage.selector[_selectorAddresses[i]] = _selectorValues[i];
1355     }
1356 
1357     emit AuditSelectorDefined(_scope, _scopeId, _selectorAddresses, _selectorValues);
1358     return true;
1359   }
1360 }
1361 
1362 // File: contracts/interface/IERC20.sol
1363 
1364 pragma solidity >=0.5.0 <0.6.0;
1365 
1366 
1367 /**
1368  * @title ERC20 interface
1369  * @dev ERC20 interface
1370  */
1371 contract IERC20 {
1372 
1373   function name() public view returns (string memory);
1374   function symbol() public view returns (string memory);
1375   function decimals() public view returns (uint256);
1376 
1377   function totalSupply() public view returns (uint256);
1378   function balanceOf(address _owner) public view returns (uint256);
1379   function allowance(address _owner, address _spender)
1380     public view returns (uint256);
1381   function transfer(address _to, uint256 _value) public returns (bool);
1382   function transferFrom(address _from, address _to, uint256 _value)
1383     public returns (bool);
1384   function approve(address _spender, uint256 _value) public returns (bool);
1385   function increaseApproval(address _spender, uint _addedValue)
1386     public returns (bool);
1387   function decreaseApproval(address _spender, uint _subtractedValue)
1388     public returns (bool);
1389 
1390   event Transfer(address indexed from, address indexed to, uint256 value);
1391   event Approval(
1392     address indexed owner,
1393     address indexed spender,
1394     uint256 value
1395   );
1396 
1397 }
1398 
1399 // File: contracts/TokenProxy.sol
1400 
1401 pragma solidity >=0.5.0 <0.6.0;
1402 
1403 
1404 
1405 
1406 
1407 /**
1408  * @title Token proxy
1409  * @dev Token proxy default implementation
1410  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
1411  */
1412 contract TokenProxy is IERC20, OperableProxy {
1413 
1414   // solhint-disable-next-line no-empty-blocks
1415   constructor(address _core) public OperableProxy(_core) { }
1416 
1417   function name() public view returns (string memory) {
1418     return TokenCore(core).tokenName();
1419   }
1420 
1421   function symbol() public view returns (string memory) {
1422     return TokenCore(core).tokenSymbol();
1423   }
1424 
1425   function decimals() public view returns (uint256) {
1426     return TokenCore(core).tokenDecimals();
1427   }
1428 
1429   function totalSupply() public view returns (uint256) {
1430     return TokenCore(core).tokenTotalSupply();
1431   }
1432 
1433   function balanceOf(address _owner) public view returns (uint256) {
1434     return TokenCore(core).tokenBalanceOf(_owner);
1435   }
1436 
1437   function allowance(address _owner, address _spender)
1438     public view returns (uint256)
1439   {
1440     return TokenCore(core).tokenAllowance(_owner, _spender);
1441   }
1442 
1443   function transfer(address _to, uint256 _value) public returns (bool status)
1444   {
1445     return TokenCore(core).transfer(msg.sender, _to, _value);
1446   }
1447 
1448   function transferFrom(address _from, address _to, uint256 _value)
1449     public returns (bool status)
1450   {
1451     return TokenCore(core).transferFrom(msg.sender, _from, _to, _value);
1452   }
1453 
1454   function approve(address _spender, uint256 _value)
1455     public returns (bool status)
1456   {
1457     return TokenCore(core).approve(msg.sender, _spender, _value);
1458   }
1459 
1460   function increaseApproval(address _spender, uint256 _addedValue)
1461     public returns (bool status)
1462   {
1463     return TokenCore(core).increaseApproval(msg.sender, _spender, _addedValue);
1464   }
1465 
1466   function decreaseApproval(address _spender, uint256 _subtractedValue)
1467     public returns (bool status)
1468   {
1469     return TokenCore(core).decreaseApproval(msg.sender, _spender, _subtractedValue);
1470   }
1471 
1472   function canTransfer(address _from, address _to, uint256 _value)
1473     public returns (uint256)
1474   {
1475     return TokenCore(core).canTransfer(_from, _to, _value);
1476   }
1477 
1478   function emitTransfer(address _from, address _to, uint256 _value)
1479     public onlyCore returns (bool)
1480   {
1481     emit Transfer(_from, _to, _value);
1482     return true;
1483   }
1484 
1485   function emitApproval(address _owner, address _spender, uint256 _value)
1486     public onlyCore returns (bool)
1487   {
1488     emit Approval(_owner, _spender, _value);
1489     return true;
1490   }
1491 
1492   event Transfer(address indexed from, address indexed to, uint256 value);
1493   event Approval(
1494     address indexed owner,
1495     address indexed spender,
1496     uint256 value
1497   );
1498 }