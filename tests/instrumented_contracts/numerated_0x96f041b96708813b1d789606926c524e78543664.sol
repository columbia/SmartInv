1 //File: contracts/acl/IACL.sol
2 pragma solidity ^0.4.18;
3 
4 
5 interface IACL {
6     function initialize(address permissionsCreator) public;
7     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
8 }
9 
10 //File: contracts/kernel/IKernel.sol
11 pragma solidity ^0.4.18;
12 
13 
14 
15 interface IKernel {
16     event SetApp(bytes32 indexed namespace, bytes32 indexed name, bytes32 indexed id, address app);
17 
18     function acl() public view returns (IACL);
19     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
20 
21     function setApp(bytes32 namespace, bytes32 name, address app) public returns (bytes32 id);
22     function getApp(bytes32 id) public view returns (address);
23 }
24 //File: contracts/apps/AppStorage.sol
25 pragma solidity ^0.4.18;
26 
27 
28 
29 
30 contract AppStorage {
31     IKernel public kernel;
32     bytes32 public appId;
33     address internal pinnedCode; // used by Proxy Pinned
34     uint256 internal initializationBlock; // used by Initializable
35     uint256[95] private storageOffset; // forces App storage to start at after 100 slots
36     uint256 private offset;
37 }
38 
39 //File: contracts/common/Initializable.sol
40 pragma solidity ^0.4.18;
41 
42 
43 
44 
45 contract Initializable is AppStorage {
46     modifier onlyInit {
47         require(initializationBlock == 0);
48         _;
49     }
50 
51     /**
52     * @return Block number in which the contract was initialized
53     */
54     function getInitializationBlock() public view returns (uint256) {
55         return initializationBlock;
56     }
57 
58     /**
59     * @dev Function to be called by top level contract after initialization has finished.
60     */
61     function initialized() internal onlyInit {
62         initializationBlock = getBlockNumber();
63     }
64 
65     /**
66     * @dev Returns the current block number.
67     *      Using a function rather than `block.number` allows us to easily mock the block number in
68     *      tests.
69     */
70     function getBlockNumber() internal view returns (uint256) {
71         return block.number;
72     }
73 }
74 
75 //File: contracts/evmscript/IEVMScriptExecutor.sol
76 pragma solidity ^0.4.18;
77 
78 
79 interface IEVMScriptExecutor {
80     function execScript(bytes script, bytes input, address[] blacklist) external returns (bytes);
81 }
82 
83 //File: contracts/evmscript/IEVMScriptRegistry.sol
84 pragma solidity 0.4.18;
85 
86 
87 contract EVMScriptRegistryConstants {
88     bytes32 constant public EVMSCRIPT_REGISTRY_APP_ID = keccak256("evmreg.aragonpm.eth");
89     bytes32 constant public EVMSCRIPT_REGISTRY_APP = keccak256(keccak256("app"), EVMSCRIPT_REGISTRY_APP_ID);
90 }
91 
92 
93 interface IEVMScriptRegistry {
94     function addScriptExecutor(address executor) external returns (uint id);
95     function disableScriptExecutor(uint256 executorId) external;
96 
97     function getScriptExecutor(bytes script) public view returns (address);
98 }
99 //File: contracts/evmscript/ScriptHelpers.sol
100 pragma solidity 0.4.18;
101 
102 
103 library ScriptHelpers {
104     // To test with JS and compare with actual encoder. Maintaining for reference.
105     // t = function() { return IEVMScriptExecutor.at('0x4bcdd59d6c77774ee7317fc1095f69ec84421e49').contract.execScript.getData(...[].slice.call(arguments)).slice(10).match(/.{1,64}/g) }
106     // run = function() { return ScriptHelpers.new().then(sh => { sh.abiEncode.call(...[].slice.call(arguments)).then(a => console.log(a.slice(2).match(/.{1,64}/g)) ) }) }
107     // This is truly not beautiful but lets no daydream to the day solidity gets reflection features
108 
109     function abiEncode(bytes _a, bytes _b, address[] _c) public pure returns (bytes d) {
110         return encode(_a, _b, _c);
111     }
112 
113     function encode(bytes memory _a, bytes memory _b, address[] memory _c) internal pure returns (bytes memory d) {
114         // A is positioned after the 3 position words
115         uint256 aPosition = 0x60;
116         uint256 bPosition = aPosition + 32 * abiLength(_a);
117         uint256 cPosition = bPosition + 32 * abiLength(_b);
118         uint256 length = cPosition + 32 * abiLength(_c);
119 
120         d = new bytes(length);
121         assembly {
122             // Store positions
123             mstore(add(d, 0x20), aPosition)
124             mstore(add(d, 0x40), bPosition)
125             mstore(add(d, 0x60), cPosition)
126         }
127 
128         // Copy memory to correct position
129         copy(d, getPtr(_a), aPosition, _a.length);
130         copy(d, getPtr(_b), bPosition, _b.length);
131         copy(d, getPtr(_c), cPosition, _c.length * 32); // 1 word per address
132     }
133 
134     function abiLength(bytes memory _a) internal pure returns (uint256) {
135         // 1 for length +
136         // memory words + 1 if not divisible for 32 to offset word
137         return 1 + (_a.length / 32) + (_a.length % 32 > 0 ? 1 : 0);
138     }
139 
140     function abiLength(address[] _a) internal pure returns (uint256) {
141         // 1 for length + 1 per item
142         return 1 + _a.length;
143     }
144 
145     function copy(bytes _d, uint256 _src, uint256 _pos, uint256 _length) internal pure {
146         uint dest;
147         assembly {
148             dest := add(add(_d, 0x20), _pos)
149         }
150         memcpy(dest, _src, _length + 32);
151     }
152 
153     function getPtr(bytes memory _x) internal pure returns (uint256 ptr) {
154         assembly {
155             ptr := _x
156         }
157     }
158 
159     function getPtr(address[] memory _x) internal pure returns (uint256 ptr) {
160         assembly {
161             ptr := _x
162         }
163     }
164 
165     function getSpecId(bytes _script) internal pure returns (uint32) {
166         return uint32At(_script, 0);
167     }
168 
169     function uint256At(bytes _data, uint256 _location) internal pure returns (uint256 result) {
170         assembly {
171             result := mload(add(_data, add(0x20, _location)))
172         }
173     }
174 
175     function addressAt(bytes _data, uint256 _location) internal pure returns (address result) {
176         uint256 word = uint256At(_data, _location);
177 
178         assembly {
179             result := div(and(word, 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000),
180             0x1000000000000000000000000)
181         }
182     }
183 
184     function uint32At(bytes _data, uint256 _location) internal pure returns (uint32 result) {
185         uint256 word = uint256At(_data, _location);
186 
187         assembly {
188             result := div(and(word, 0xffffffff00000000000000000000000000000000000000000000000000000000),
189             0x100000000000000000000000000000000000000000000000000000000)
190         }
191     }
192 
193     function locationOf(bytes _data, uint256 _location) internal pure returns (uint256 result) {
194         assembly {
195             result := add(_data, add(0x20, _location))
196         }
197     }
198 
199     function toBytes(bytes4 _sig) internal pure returns (bytes) {
200         bytes memory payload = new bytes(4);
201         payload[0] = bytes1(_sig);
202         payload[1] = bytes1(_sig << 8);
203         payload[2] = bytes1(_sig << 16);
204         payload[3] = bytes1(_sig << 24);
205         return payload;
206     }
207 
208     function memcpy(uint _dest, uint _src, uint _len) public pure {
209         uint256 src = _src;
210         uint256 dest = _dest;
211         uint256 len = _len;
212 
213         // Copy word-length chunks while possible
214         for (; len >= 32; len -= 32) {
215             assembly {
216                 mstore(dest, mload(src))
217             }
218             dest += 32;
219             src += 32;
220         }
221 
222         // Copy remaining bytes
223         uint mask = 256 ** (32 - len) - 1;
224         assembly {
225             let srcpart := and(mload(src), not(mask))
226             let destpart := and(mload(dest), mask)
227             mstore(dest, or(destpart, srcpart))
228         }
229     }
230 }
231 //File: contracts/evmscript/EVMScriptRunner.sol
232 pragma solidity ^0.4.18;
233 
234 
235 
236 
237 
238 
239 
240 
241 contract EVMScriptRunner is AppStorage, EVMScriptRegistryConstants {
242     using ScriptHelpers for bytes;
243 
244     function runScript(bytes _script, bytes _input, address[] _blacklist) protectState internal returns (bytes output) {
245         // TODO: Too much data flying around, maybe extracting spec id here is cheaper
246         address executorAddr = getExecutor(_script);
247         require(executorAddr != address(0));
248 
249         bytes memory calldataArgs = _script.encode(_input, _blacklist);
250         bytes4 sig = IEVMScriptExecutor(0).execScript.selector;
251 
252         require(executorAddr.delegatecall(sig, calldataArgs));
253 
254         return returnedDataDecoded();
255     }
256 
257     function getExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
258         return IEVMScriptExecutor(getExecutorRegistry().getScriptExecutor(_script));
259     }
260 
261     // TODO: Internal
262     function getExecutorRegistry() internal view returns (IEVMScriptRegistry) {
263         address registryAddr = kernel.getApp(EVMSCRIPT_REGISTRY_APP);
264         return IEVMScriptRegistry(registryAddr);
265     }
266 
267     /**
268     * @dev copies and returns last's call data. Needs to ABI decode first
269     */
270     function returnedDataDecoded() internal view returns (bytes ret) {
271         assembly {
272             let size := returndatasize
273             switch size
274             case 0 {}
275             default {
276                 ret := mload(0x40) // free mem ptr get
277                 mstore(0x40, add(ret, add(size, 0x20))) // free mem ptr set
278                 returndatacopy(ret, 0x20, sub(size, 0x20)) // copy return data
279             }
280         }
281         return ret;
282     }
283 
284     modifier protectState {
285         address preKernel = kernel;
286         bytes32 preAppId = appId;
287         _; // exec
288         require(kernel == preKernel);
289         require(appId == preAppId);
290     }
291 }
292 //File: contracts/acl/ACLSyntaxSugar.sol
293 pragma solidity 0.4.18;
294 
295 
296 contract ACLSyntaxSugar {
297     function arr() internal pure returns (uint256[] r) {}
298 
299     function arr(bytes32 _a) internal pure returns (uint256[] r) {
300         return arr(uint256(_a));
301     }
302 
303     function arr(bytes32 _a, bytes32 _b) internal pure returns (uint256[] r) {
304         return arr(uint256(_a), uint256(_b));
305     }
306 
307     function arr(address _a) internal pure returns (uint256[] r) {
308         return arr(uint256(_a));
309     }
310 
311     function arr(address _a, address _b) internal pure returns (uint256[] r) {
312         return arr(uint256(_a), uint256(_b));
313     }
314 
315     function arr(address _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
316         return arr(uint256(_a), _b, _c);
317     }
318 
319     function arr(address _a, uint256 _b) internal pure returns (uint256[] r) {
320         return arr(uint256(_a), uint256(_b));
321     }
322 
323     function arr(address _a, address _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
324         return arr(uint256(_a), uint256(_b), _c, _d, _e);
325     }
326 
327     function arr(address _a, address _b, address _c) internal pure returns (uint256[] r) {
328         return arr(uint256(_a), uint256(_b), uint256(_c));
329     }
330 
331     function arr(address _a, address _b, uint256 _c) internal pure returns (uint256[] r) {
332         return arr(uint256(_a), uint256(_b), uint256(_c));
333     }
334 
335     function arr(uint256 _a) internal pure returns (uint256[] r) {
336         r = new uint256[](1);
337         r[0] = _a;
338     }
339 
340     function arr(uint256 _a, uint256 _b) internal pure returns (uint256[] r) {
341         r = new uint256[](2);
342         r[0] = _a;
343         r[1] = _b;
344     }
345 
346     function arr(uint256 _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
347         r = new uint256[](3);
348         r[0] = _a;
349         r[1] = _b;
350         r[2] = _c;
351     }
352 
353     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
354         r = new uint256[](4);
355         r[0] = _a;
356         r[1] = _b;
357         r[2] = _c;
358         r[3] = _d;
359     }
360 
361     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
362         r = new uint256[](5);
363         r[0] = _a;
364         r[1] = _b;
365         r[2] = _c;
366         r[3] = _d;
367         r[4] = _e;
368     }
369 }
370 
371 
372 contract ACLHelpers {
373     function decodeParamOp(uint256 _x) internal pure returns (uint8 b) {
374         return uint8(_x >> (8 * 30));
375     }
376 
377     function decodeParamId(uint256 _x) internal pure returns (uint8 b) {
378         return uint8(_x >> (8 * 31));
379     }
380 
381     function decodeParamsList(uint256 _x) internal pure returns (uint32 a, uint32 b, uint32 c) {
382         a = uint32(_x);
383         b = uint32(_x >> (8 * 4));
384         c = uint32(_x >> (8 * 8));
385     }
386 }
387 
388 //File: contracts/apps/AragonApp.sol
389 pragma solidity ^0.4.18;
390 
391 
392 
393 
394 
395 
396 
397 contract AragonApp is AppStorage, Initializable, ACLSyntaxSugar, EVMScriptRunner {
398     modifier auth(bytes32 _role) {
399         require(canPerform(msg.sender, _role, new uint256[](0)));
400         _;
401     }
402 
403     modifier authP(bytes32 _role, uint256[] params) {
404         require(canPerform(msg.sender, _role, params));
405         _;
406     }
407 
408     function canPerform(address _sender, bytes32 _role, uint256[] params) public view returns (bool) {
409         bytes memory how; // no need to init memory as it is never used
410         if (params.length > 0) {
411             uint256 byteLength = params.length * 32;
412             assembly {
413                 how := params // forced casting
414                 mstore(how, byteLength)
415             }
416         }
417         return address(kernel) == 0 || kernel.hasPermission(_sender, address(this), _role, how);
418     }
419 }
420 
421 //File: contracts/acl/ACL.sol
422 pragma solidity 0.4.18;
423 
424 
425 
426 
427 
428 
429 interface ACLOracle {
430     function canPerform(address who, address where, bytes32 what) public view returns (bool);
431 }
432 
433 
434 contract ACL is IACL, AragonApp, ACLHelpers {
435     bytes32 constant public CREATE_PERMISSIONS_ROLE = keccak256("CREATE_PERMISSIONS_ROLE");
436 
437     // whether a certain entity has a permission
438     mapping (bytes32 => bytes32) permissions; // 0 for no permission, or parameters id
439     mapping (bytes32 => Param[]) public permissionParams;
440 
441     // who is the manager of a permission
442     mapping (bytes32 => address) permissionManager;
443 
444     enum Op { NONE, EQ, NEQ, GT, LT, GTE, LTE, NOT, AND, OR, XOR, IF_ELSE, RET } // op types
445 
446     struct Param {
447         uint8 id;
448         uint8 op;
449         uint240 value; // even though value is an uint240 it can store addresses
450         // in the case of 32 byte hashes losing 2 bytes precision isn't a huge deal
451         // op and id take less than 1 byte each so it can be kept in 1 sstore
452     }
453 
454     uint8 constant BLOCK_NUMBER_PARAM_ID = 200;
455     uint8 constant TIMESTAMP_PARAM_ID    = 201;
456     uint8 constant SENDER_PARAM_ID       = 202;
457     uint8 constant ORACLE_PARAM_ID       = 203;
458     uint8 constant LOGIC_OP_PARAM_ID     = 204;
459     uint8 constant PARAM_VALUE_PARAM_ID  = 205;
460     // TODO: Add execution times param type?
461 
462     bytes32 constant public EMPTY_PARAM_HASH = keccak256(uint256(0));
463     address constant ANY_ENTITY = address(-1);
464 
465     modifier onlyPermissionManager(address _app, bytes32 _role) {
466         require(msg.sender == getPermissionManager(_app, _role));
467         _;
468     }
469 
470     event SetPermission(address indexed entity, address indexed app, bytes32 indexed role, bool allowed);
471     event ChangePermissionManager(address indexed app, bytes32 indexed role, address indexed manager);
472 
473     /**
474     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
475     * @notice Initializes an ACL instance and sets `_permissionsCreator` as the entity that can create other permissions
476     * @param _permissionsCreator Entity that will be given permission over createPermission
477     */
478     function initialize(address _permissionsCreator) onlyInit public {
479         initialized();
480         require(msg.sender == address(kernel));
481 
482         _createPermission(_permissionsCreator, this, CREATE_PERMISSIONS_ROLE, _permissionsCreator);
483     }
484 
485     /**
486     * @dev Creates a permission that wasn't previously set. Access is limited by the ACL.
487     *      If a created permission is removed it is possible to reset it with createPermission.
488     * @notice Create a new permission granting `_entity` the ability to perform actions of role `_role` on `_app` (setting `_manager` as the permission manager)
489     * @param _entity Address of the whitelisted entity that will be able to perform the role
490     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
491     * @param _role Identifier for the group of actions in app given access to perform
492     * @param _manager Address of the entity that will be able to grant and revoke the permission further.
493     */
494     function createPermission(address _entity, address _app, bytes32 _role, address _manager) external {
495         require(hasPermission(msg.sender, address(this), CREATE_PERMISSIONS_ROLE));
496 
497         _createPermission(_entity, _app, _role, _manager);
498     }
499 
500     /**
501     * @dev Grants permission if allowed. This requires `msg.sender` to be the permission manager
502     * @notice Grants `_entity` the ability to perform actions of role `_role` on `_app`
503     * @param _entity Address of the whitelisted entity that will be able to perform the role
504     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
505     * @param _role Identifier for the group of actions in app given access to perform
506     */
507     function grantPermission(address _entity, address _app, bytes32 _role)
508         external
509     {
510         grantPermissionP(_entity, _app, _role, new uint256[](0));
511     }
512 
513     /**
514     * @dev Grants a permission with parameters if allowed. This requires `msg.sender` to be the permission manager
515     * @notice Grants `_entity` the ability to perform actions of role `_role` on `_app`
516     * @param _entity Address of the whitelisted entity that will be able to perform the role
517     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
518     * @param _role Identifier for the group of actions in app given access to perform
519     * @param _params Permission parameters
520     */
521     function grantPermissionP(address _entity, address _app, bytes32 _role, uint256[] _params)
522         onlyPermissionManager(_app, _role)
523         public
524     {
525         require(!hasPermission(_entity, _app, _role));
526 
527         bytes32 paramsHash = _params.length > 0 ? _saveParams(_params) : EMPTY_PARAM_HASH;
528         _setPermission(_entity, _app, _role, paramsHash);
529     }
530 
531     /**
532     * @dev Revokes permission if allowed. This requires `msg.sender` to be the the permission manager
533     * @notice Revokes `_entity` the ability to perform actions of role `_role` on `_app`
534     * @param _entity Address of the whitelisted entity to revoke access from
535     * @param _app Address of the app in which the role will be revoked
536     * @param _role Identifier for the group of actions in app being revoked
537     */
538     function revokePermission(address _entity, address _app, bytes32 _role)
539         onlyPermissionManager(_app, _role)
540         external
541     {
542         require(hasPermission(_entity, _app, _role));
543 
544         _setPermission(_entity, _app, _role, bytes32(0));
545     }
546 
547     /**
548     * @notice Sets `_newManager` as the manager of the permission `_role` in `_app`
549     * @param _newManager Address for the new manager
550     * @param _app Address of the app in which the permission management is being transferred
551     * @param _role Identifier for the group of actions being transferred
552     */
553     function setPermissionManager(address _newManager, address _app, bytes32 _role)
554         onlyPermissionManager(_app, _role)
555         external
556     {
557         _setPermissionManager(_newManager, _app, _role);
558     }
559 
560     /**
561     * @dev Get manager for permission
562     * @param _app Address of the app
563     * @param _role Identifier for a group of actions in app
564     * @return address of the manager for the permission
565     */
566     function getPermissionManager(address _app, bytes32 _role) public view returns (address) {
567         return permissionManager[roleHash(_app, _role)];
568     }
569 
570     /**
571     * @dev Function called by apps to check ACL on kernel or to check permission statu
572     * @param _who Sender of the original call
573     * @param _where Address of the app
574     * @param _where Identifier for a group of actions in app
575     * @param _how Permission parameters
576     * @return boolean indicating whether the ACL allows the role or not
577     */
578     function hasPermission(address _who, address _where, bytes32 _what, bytes memory _how) public view returns (bool) {
579         uint256[] memory how;
580         uint256 intsLength = _how.length / 32;
581         assembly {
582             how := _how // forced casting
583             mstore(how, intsLength)
584         }
585         // _how is invalid from this point fwd
586         return hasPermission(_who, _where, _what, how);
587     }
588 
589     function hasPermission(address _who, address _where, bytes32 _what, uint256[] memory _how) public view returns (bool) {
590         bytes32 whoParams = permissions[permissionHash(_who, _where, _what)];
591         if (whoParams != bytes32(0) && evalParams(whoParams, _who, _where, _what, _how)) {
592             return true;
593         }
594 
595         bytes32 anyParams = permissions[permissionHash(ANY_ENTITY, _where, _what)];
596         if (anyParams != bytes32(0) && evalParams(anyParams, ANY_ENTITY, _where, _what, _how)) {
597             return true;
598         }
599 
600         return false;
601     }
602 
603     function hasPermission(address _who, address _where, bytes32 _what) public view returns (bool) {
604         uint256[] memory empty = new uint256[](0);
605         return hasPermission(_who, _where, _what, empty);
606     }
607 
608     /**
609     * @dev Internal createPermission for access inside the kernel (on instantiation)
610     */
611     function _createPermission(address _entity, address _app, bytes32 _role, address _manager) internal {
612         // only allow permission creation (or re-creation) when there is no manager
613         require(getPermissionManager(_app, _role) == address(0));
614 
615         _setPermission(_entity, _app, _role, EMPTY_PARAM_HASH);
616         _setPermissionManager(_manager, _app, _role);
617     }
618 
619     /**
620     * @dev Internal function called to actually save the permission
621     */
622     function _setPermission(address _entity, address _app, bytes32 _role, bytes32 _paramsHash) internal {
623         permissions[permissionHash(_entity, _app, _role)] = _paramsHash;
624 
625         SetPermission(_entity, _app, _role, _paramsHash != bytes32(0));
626     }
627 
628     function _saveParams(uint256[] _encodedParams) internal returns (bytes32) {
629         bytes32 paramHash = keccak256(_encodedParams);
630         Param[] storage params = permissionParams[paramHash];
631 
632         if (params.length == 0) { // params not saved before
633             for (uint256 i = 0; i < _encodedParams.length; i++) {
634                 uint256 encodedParam = _encodedParams[i];
635                 Param memory param = Param(decodeParamId(encodedParam), decodeParamOp(encodedParam), uint240(encodedParam));
636                 params.push(param);
637             }
638         }
639 
640         return paramHash;
641     }
642 
643     function evalParams(
644         bytes32 _paramsHash,
645         address _who,
646         address _where,
647         bytes32 _what,
648         uint256[] _how
649     ) internal view returns (bool)
650     {
651         if (_paramsHash == EMPTY_PARAM_HASH) {
652             return true;
653         }
654 
655         return evalParam(_paramsHash, 0, _who, _where, _what, _how);
656     }
657 
658     function evalParam(
659         bytes32 _paramsHash,
660         uint32 _paramId,
661         address _who,
662         address _where,
663         bytes32 _what,
664         uint256[] _how
665     ) internal view returns (bool)
666     {
667         if (_paramId >= permissionParams[_paramsHash].length) {
668             return false; // out of bounds
669         }
670 
671         Param memory param = permissionParams[_paramsHash][_paramId];
672 
673         if (param.id == LOGIC_OP_PARAM_ID) {
674             return evalLogic(param, _paramsHash, _who, _where, _what, _how);
675         }
676 
677         uint256 value;
678         uint256 comparedTo = uint256(param.value);
679 
680         // get value
681         if (param.id == ORACLE_PARAM_ID) {
682             value = ACLOracle(param.value).canPerform(_who, _where, _what) ? 1 : 0;
683             comparedTo = 1;
684         } else if (param.id == BLOCK_NUMBER_PARAM_ID) {
685             value = blockN();
686         } else if (param.id == TIMESTAMP_PARAM_ID) {
687             value = time();
688         } else if (param.id == SENDER_PARAM_ID) {
689             value = uint256(msg.sender);
690         } else if (param.id == PARAM_VALUE_PARAM_ID) {
691             value = uint256(param.value);
692         } else {
693             if (param.id >= _how.length) {
694                 return false;
695             }
696             value = uint256(uint240(_how[param.id])); // force lost precision
697         }
698 
699         if (Op(param.op) == Op.RET) {
700             return uint256(value) > 0;
701         }
702 
703         return compare(value, Op(param.op), comparedTo);
704     }
705 
706     function evalLogic(Param _param, bytes32 _paramsHash, address _who, address _where, bytes32 _what, uint256[] _how) internal view returns (bool) {
707         if (Op(_param.op) == Op.IF_ELSE) {
708             var (condition, success, failure) = decodeParamsList(uint256(_param.value));
709             bool result = evalParam(_paramsHash, condition, _who, _where, _what, _how);
710 
711             return evalParam(_paramsHash, result ? success : failure, _who, _where, _what, _how);
712         }
713 
714         var (v1, v2,) = decodeParamsList(uint256(_param.value));
715         bool r1 = evalParam(_paramsHash, v1, _who, _where, _what, _how);
716 
717         if (Op(_param.op) == Op.NOT) {
718             return !r1;
719         }
720 
721         if (r1 && Op(_param.op) == Op.OR) {
722             return true;
723         }
724 
725         if (!r1 && Op(_param.op) == Op.AND) {
726             return false;
727         }
728 
729         bool r2 = evalParam(_paramsHash, v2, _who, _where, _what, _how);
730 
731         if (Op(_param.op) == Op.XOR) {
732             return (r1 && !r2) || (!r1 && r2);
733         }
734 
735         return r2; // both or and and depend on result of r2 after checks
736     }
737 
738     function compare(uint256 _a, Op _op, uint256 _b) internal pure returns (bool) {
739         if (_op == Op.EQ)  return _a == _b;                              // solium-disable-line lbrace
740         if (_op == Op.NEQ) return _a != _b;                              // solium-disable-line lbrace
741         if (_op == Op.GT)  return _a > _b;                               // solium-disable-line lbrace
742         if (_op == Op.LT)  return _a < _b;                               // solium-disable-line lbrace
743         if (_op == Op.GTE) return _a >= _b;                              // solium-disable-line lbrace
744         if (_op == Op.LTE) return _a <= _b;                              // solium-disable-line lbrace
745         return false;
746     }
747 
748     /**
749     * @dev Internal function that sets management
750     */
751     function _setPermissionManager(address _newManager, address _app, bytes32 _role) internal {
752         permissionManager[roleHash(_app, _role)] = _newManager;
753         ChangePermissionManager(_app, _role, _newManager);
754     }
755 
756     function roleHash(address _where, bytes32 _what) pure internal returns (bytes32) {
757         return keccak256(uint256(1), _where, _what);
758     }
759 
760     function permissionHash(address _who, address _where, bytes32 _what) pure internal returns (bytes32) {
761         return keccak256(uint256(2), _who, _where, _what);
762     }
763 
764     function time() internal view returns (uint64) { return uint64(block.timestamp); } // solium-disable-line security/no-block-members
765 
766     function blockN() internal view returns (uint256) { return block.number; }
767 }