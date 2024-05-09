1 //File: contracts/lib/ens/AbstractENS.sol
2 pragma solidity ^0.4.15;
3 
4 
5 interface AbstractENS {
6     function owner(bytes32 _node) constant returns (address);
7     function resolver(bytes32 _node) constant returns (address);
8     function ttl(bytes32 _node) constant returns (uint64);
9     function setOwner(bytes32 _node, address _owner);
10     function setSubnodeOwner(bytes32 _node, bytes32 label, address _owner);
11     function setResolver(bytes32 _node, address _resolver);
12     function setTTL(bytes32 _node, uint64 _ttl);
13 
14     // Logged when the owner of a node assigns a new owner to a subnode.
15     event NewOwner(bytes32 indexed _node, bytes32 indexed _label, address _owner);
16 
17     // Logged when the owner of a node transfers ownership to a new account.
18     event Transfer(bytes32 indexed _node, address _owner);
19 
20     // Logged when the resolver for a node changes.
21     event NewResolver(bytes32 indexed _node, address _resolver);
22 
23     // Logged when the TTL of a node changes
24     event NewTTL(bytes32 indexed _node, uint64 _ttl);
25 }
26 
27 //File: contracts/lib/ens/PublicResolver.sol
28 pragma solidity ^0.4.0;
29 
30 
31 
32 /**
33  * A simple resolver anyone can use; only allows the owner of a node to set its
34  * address.
35  */
36 contract PublicResolver {
37     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
38     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
39     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
40     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
41     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
42     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
43     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
44 
45     event AddrChanged(bytes32 indexed node, address a);
46     event ContentChanged(bytes32 indexed node, bytes32 hash);
47     event NameChanged(bytes32 indexed node, string name);
48     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
49     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
50     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
51 
52     struct PublicKey {
53         bytes32 x;
54         bytes32 y;
55     }
56 
57     struct Record {
58         address addr;
59         bytes32 content;
60         string name;
61         PublicKey pubkey;
62         mapping(string=>string) text;
63         mapping(uint256=>bytes) abis;
64     }
65 
66     AbstractENS ens;
67     mapping(bytes32=>Record) records;
68 
69     modifier only_owner(bytes32 node) {
70         if (ens.owner(node) != msg.sender) throw;
71         _;
72     }
73 
74     /**
75      * Constructor.
76      * @param ensAddr The ENS registrar contract.
77      */
78     function PublicResolver(AbstractENS ensAddr) {
79         ens = ensAddr;
80     }
81 
82     /**
83      * Returns true if the resolver implements the interface specified by the provided hash.
84      * @param interfaceID The ID of the interface to check for.
85      * @return True if the contract implements the requested interface.
86      */
87     function supportsInterface(bytes4 interfaceID) constant returns (bool) {
88         return interfaceID == ADDR_INTERFACE_ID ||
89                interfaceID == CONTENT_INTERFACE_ID ||
90                interfaceID == NAME_INTERFACE_ID ||
91                interfaceID == ABI_INTERFACE_ID ||
92                interfaceID == PUBKEY_INTERFACE_ID ||
93                interfaceID == TEXT_INTERFACE_ID ||
94                interfaceID == INTERFACE_META_ID;
95     }
96 
97     /**
98      * Returns the address associated with an ENS node.
99      * @param node The ENS node to query.
100      * @return The associated address.
101      */
102     function addr(bytes32 node) constant returns (address ret) {
103         ret = records[node].addr;
104     }
105 
106     /**
107      * Sets the address associated with an ENS node.
108      * May only be called by the owner of that node in the ENS registry.
109      * @param node The node to update.
110      * @param addr The address to set.
111      */
112     function setAddr(bytes32 node, address addr) only_owner(node) {
113         records[node].addr = addr;
114         AddrChanged(node, addr);
115     }
116 
117     /**
118      * Returns the content hash associated with an ENS node.
119      * Note that this resource type is not standardized, and will likely change
120      * in future to a resource type based on multihash.
121      * @param node The ENS node to query.
122      * @return The associated content hash.
123      */
124     function content(bytes32 node) constant returns (bytes32 ret) {
125         ret = records[node].content;
126     }
127 
128     /**
129      * Sets the content hash associated with an ENS node.
130      * May only be called by the owner of that node in the ENS registry.
131      * Note that this resource type is not standardized, and will likely change
132      * in future to a resource type based on multihash.
133      * @param node The node to update.
134      * @param hash The content hash to set
135      */
136     function setContent(bytes32 node, bytes32 hash) only_owner(node) {
137         records[node].content = hash;
138         ContentChanged(node, hash);
139     }
140 
141     /**
142      * Returns the name associated with an ENS node, for reverse records.
143      * Defined in EIP181.
144      * @param node The ENS node to query.
145      * @return The associated name.
146      */
147     function name(bytes32 node) constant returns (string ret) {
148         ret = records[node].name;
149     }
150 
151     /**
152      * Sets the name associated with an ENS node, for reverse records.
153      * May only be called by the owner of that node in the ENS registry.
154      * @param node The node to update.
155      * @param name The name to set.
156      */
157     function setName(bytes32 node, string name) only_owner(node) {
158         records[node].name = name;
159         NameChanged(node, name);
160     }
161 
162     /**
163      * Returns the ABI associated with an ENS node.
164      * Defined in EIP205.
165      * @param node The ENS node to query
166      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
167      * @return contentType The content type of the return value
168      * @return data The ABI data
169      */
170     function ABI(bytes32 node, uint256 contentTypes) constant returns (uint256 contentType, bytes data) {
171         var record = records[node];
172         for(contentType = 1; contentType <= contentTypes; contentType <<= 1) {
173             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
174                 data = record.abis[contentType];
175                 return;
176             }
177         }
178         contentType = 0;
179     }
180 
181     /**
182      * Sets the ABI associated with an ENS node.
183      * Nodes may have one ABI of each content type. To remove an ABI, set it to
184      * the empty string.
185      * @param node The node to update.
186      * @param contentType The content type of the ABI
187      * @param data The ABI data.
188      */
189     function setABI(bytes32 node, uint256 contentType, bytes data) only_owner(node) {
190         // Content types must be powers of 2
191         if (((contentType - 1) & contentType) != 0) throw;
192 
193         records[node].abis[contentType] = data;
194         ABIChanged(node, contentType);
195     }
196 
197     /**
198      * Returns the SECP256k1 public key associated with an ENS node.
199      * Defined in EIP 619.
200      * @param node The ENS node to query
201      * @return x, y the X and Y coordinates of the curve point for the public key.
202      */
203     function pubkey(bytes32 node) constant returns (bytes32 x, bytes32 y) {
204         return (records[node].pubkey.x, records[node].pubkey.y);
205     }
206 
207     /**
208      * Sets the SECP256k1 public key associated with an ENS node.
209      * @param node The ENS node to query
210      * @param x the X coordinate of the curve point for the public key.
211      * @param y the Y coordinate of the curve point for the public key.
212      */
213     function setPubkey(bytes32 node, bytes32 x, bytes32 y) only_owner(node) {
214         records[node].pubkey = PublicKey(x, y);
215         PubkeyChanged(node, x, y);
216     }
217 
218     /**
219      * Returns the text data associated with an ENS node and key.
220      * @param node The ENS node to query.
221      * @param key The text data key to query.
222      * @return The associated text data.
223      */
224     function text(bytes32 node, string key) constant returns (string ret) {
225         ret = records[node].text[key];
226     }
227 
228     /**
229      * Sets the text data associated with an ENS node and key.
230      * May only be called by the owner of that node in the ENS registry.
231      * @param node The node to update.
232      * @param key The key to set.
233      * @param value The text data value to set.
234      */
235     function setText(bytes32 node, string key, string value) only_owner(node) {
236         records[node].text[key] = value;
237         TextChanged(node, key, key);
238     }
239 }
240 
241 //File: contracts/ens/ENSConstants.sol
242 pragma solidity ^0.4.18;
243 
244 
245 contract ENSConstants {
246     bytes32 constant public ENS_ROOT = bytes32(0);
247     bytes32 constant public ETH_TLD_LABEL = keccak256("eth");
248     bytes32 constant public ETH_TLD_NODE = keccak256(ENS_ROOT, ETH_TLD_LABEL);
249     bytes32 constant public PUBLIC_RESOLVER_LABEL = keccak256("resolver");
250     bytes32 constant public PUBLIC_RESOLVER_NODE = keccak256(ETH_TLD_NODE, PUBLIC_RESOLVER_LABEL);
251 }
252 
253 //File: contracts/acl/IACL.sol
254 pragma solidity ^0.4.18;
255 
256 
257 interface IACL {
258     function initialize(address permissionsCreator) public;
259     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
260 }
261 
262 //File: contracts/kernel/IKernel.sol
263 pragma solidity ^0.4.18;
264 
265 
266 
267 interface IKernel {
268     event SetApp(bytes32 indexed namespace, bytes32 indexed name, bytes32 indexed id, address app);
269 
270     function acl() public view returns (IACL);
271     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
272 
273     function setApp(bytes32 namespace, bytes32 name, address app) public returns (bytes32 id);
274     function getApp(bytes32 id) public view returns (address);
275 }
276 //File: contracts/apps/AppStorage.sol
277 pragma solidity ^0.4.18;
278 
279 
280 
281 
282 contract AppStorage {
283     IKernel public kernel;
284     bytes32 public appId;
285     address internal pinnedCode; // used by Proxy Pinned
286     uint256 internal initializationBlock; // used by Initializable
287     uint256[95] private storageOffset; // forces App storage to start at after 100 slots
288     uint256 private offset;
289 }
290 
291 //File: contracts/common/Initializable.sol
292 pragma solidity ^0.4.18;
293 
294 
295 
296 
297 contract Initializable is AppStorage {
298     modifier onlyInit {
299         require(initializationBlock == 0);
300         _;
301     }
302 
303     /**
304     * @return Block number in which the contract was initialized
305     */
306     function getInitializationBlock() public view returns (uint256) {
307         return initializationBlock;
308     }
309 
310     /**
311     * @dev Function to be called by top level contract after initialization has finished.
312     */
313     function initialized() internal onlyInit {
314         initializationBlock = getBlockNumber();
315     }
316 
317     /**
318     * @dev Returns the current block number.
319     *      Using a function rather than `block.number` allows us to easily mock the block number in
320     *      tests.
321     */
322     function getBlockNumber() internal view returns (uint256) {
323         return block.number;
324     }
325 }
326 
327 //File: contracts/evmscript/IEVMScriptExecutor.sol
328 pragma solidity ^0.4.18;
329 
330 
331 interface IEVMScriptExecutor {
332     function execScript(bytes script, bytes input, address[] blacklist) external returns (bytes);
333 }
334 
335 //File: contracts/evmscript/IEVMScriptRegistry.sol
336 pragma solidity 0.4.18;
337 
338 
339 contract EVMScriptRegistryConstants {
340     bytes32 constant public EVMSCRIPT_REGISTRY_APP_ID = keccak256("evmreg.aragonpm.eth");
341     bytes32 constant public EVMSCRIPT_REGISTRY_APP = keccak256(keccak256("app"), EVMSCRIPT_REGISTRY_APP_ID);
342 }
343 
344 
345 interface IEVMScriptRegistry {
346     function addScriptExecutor(address executor) external returns (uint id);
347     function disableScriptExecutor(uint256 executorId) external;
348 
349     function getScriptExecutor(bytes script) public view returns (address);
350 }
351 //File: contracts/evmscript/ScriptHelpers.sol
352 pragma solidity 0.4.18;
353 
354 
355 library ScriptHelpers {
356     // To test with JS and compare with actual encoder. Maintaining for reference.
357     // t = function() { return IEVMScriptExecutor.at('0x4bcdd59d6c77774ee7317fc1095f69ec84421e49').contract.execScript.getData(...[].slice.call(arguments)).slice(10).match(/.{1,64}/g) }
358     // run = function() { return ScriptHelpers.new().then(sh => { sh.abiEncode.call(...[].slice.call(arguments)).then(a => console.log(a.slice(2).match(/.{1,64}/g)) ) }) }
359     // This is truly not beautiful but lets no daydream to the day solidity gets reflection features
360 
361     function abiEncode(bytes _a, bytes _b, address[] _c) public pure returns (bytes d) {
362         return encode(_a, _b, _c);
363     }
364 
365     function encode(bytes memory _a, bytes memory _b, address[] memory _c) internal pure returns (bytes memory d) {
366         // A is positioned after the 3 position words
367         uint256 aPosition = 0x60;
368         uint256 bPosition = aPosition + 32 * abiLength(_a);
369         uint256 cPosition = bPosition + 32 * abiLength(_b);
370         uint256 length = cPosition + 32 * abiLength(_c);
371 
372         d = new bytes(length);
373         assembly {
374             // Store positions
375             mstore(add(d, 0x20), aPosition)
376             mstore(add(d, 0x40), bPosition)
377             mstore(add(d, 0x60), cPosition)
378         }
379 
380         // Copy memory to correct position
381         copy(d, getPtr(_a), aPosition, _a.length);
382         copy(d, getPtr(_b), bPosition, _b.length);
383         copy(d, getPtr(_c), cPosition, _c.length * 32); // 1 word per address
384     }
385 
386     function abiLength(bytes memory _a) internal pure returns (uint256) {
387         // 1 for length +
388         // memory words + 1 if not divisible for 32 to offset word
389         return 1 + (_a.length / 32) + (_a.length % 32 > 0 ? 1 : 0);
390     }
391 
392     function abiLength(address[] _a) internal pure returns (uint256) {
393         // 1 for length + 1 per item
394         return 1 + _a.length;
395     }
396 
397     function copy(bytes _d, uint256 _src, uint256 _pos, uint256 _length) internal pure {
398         uint dest;
399         assembly {
400             dest := add(add(_d, 0x20), _pos)
401         }
402         memcpy(dest, _src, _length + 32);
403     }
404 
405     function getPtr(bytes memory _x) internal pure returns (uint256 ptr) {
406         assembly {
407             ptr := _x
408         }
409     }
410 
411     function getPtr(address[] memory _x) internal pure returns (uint256 ptr) {
412         assembly {
413             ptr := _x
414         }
415     }
416 
417     function getSpecId(bytes _script) internal pure returns (uint32) {
418         return uint32At(_script, 0);
419     }
420 
421     function uint256At(bytes _data, uint256 _location) internal pure returns (uint256 result) {
422         assembly {
423             result := mload(add(_data, add(0x20, _location)))
424         }
425     }
426 
427     function addressAt(bytes _data, uint256 _location) internal pure returns (address result) {
428         uint256 word = uint256At(_data, _location);
429 
430         assembly {
431             result := div(and(word, 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000),
432             0x1000000000000000000000000)
433         }
434     }
435 
436     function uint32At(bytes _data, uint256 _location) internal pure returns (uint32 result) {
437         uint256 word = uint256At(_data, _location);
438 
439         assembly {
440             result := div(and(word, 0xffffffff00000000000000000000000000000000000000000000000000000000),
441             0x100000000000000000000000000000000000000000000000000000000)
442         }
443     }
444 
445     function locationOf(bytes _data, uint256 _location) internal pure returns (uint256 result) {
446         assembly {
447             result := add(_data, add(0x20, _location))
448         }
449     }
450 
451     function toBytes(bytes4 _sig) internal pure returns (bytes) {
452         bytes memory payload = new bytes(4);
453         payload[0] = bytes1(_sig);
454         payload[1] = bytes1(_sig << 8);
455         payload[2] = bytes1(_sig << 16);
456         payload[3] = bytes1(_sig << 24);
457         return payload;
458     }
459 
460     function memcpy(uint _dest, uint _src, uint _len) public pure {
461         uint256 src = _src;
462         uint256 dest = _dest;
463         uint256 len = _len;
464 
465         // Copy word-length chunks while possible
466         for (; len >= 32; len -= 32) {
467             assembly {
468                 mstore(dest, mload(src))
469             }
470             dest += 32;
471             src += 32;
472         }
473 
474         // Copy remaining bytes
475         uint mask = 256 ** (32 - len) - 1;
476         assembly {
477             let srcpart := and(mload(src), not(mask))
478             let destpart := and(mload(dest), mask)
479             mstore(dest, or(destpart, srcpart))
480         }
481     }
482 }
483 //File: contracts/evmscript/EVMScriptRunner.sol
484 pragma solidity ^0.4.18;
485 
486 
487 
488 
489 
490 
491 
492 
493 contract EVMScriptRunner is AppStorage, EVMScriptRegistryConstants {
494     using ScriptHelpers for bytes;
495 
496     function runScript(bytes _script, bytes _input, address[] _blacklist) protectState internal returns (bytes output) {
497         // TODO: Too much data flying around, maybe extracting spec id here is cheaper
498         address executorAddr = getExecutor(_script);
499         require(executorAddr != address(0));
500 
501         bytes memory calldataArgs = _script.encode(_input, _blacklist);
502         bytes4 sig = IEVMScriptExecutor(0).execScript.selector;
503 
504         require(executorAddr.delegatecall(sig, calldataArgs));
505 
506         return returnedDataDecoded();
507     }
508 
509     function getExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
510         return IEVMScriptExecutor(getExecutorRegistry().getScriptExecutor(_script));
511     }
512 
513     // TODO: Internal
514     function getExecutorRegistry() internal view returns (IEVMScriptRegistry) {
515         address registryAddr = kernel.getApp(EVMSCRIPT_REGISTRY_APP);
516         return IEVMScriptRegistry(registryAddr);
517     }
518 
519     /**
520     * @dev copies and returns last's call data. Needs to ABI decode first
521     */
522     function returnedDataDecoded() internal view returns (bytes ret) {
523         assembly {
524             let size := returndatasize
525             switch size
526             case 0 {}
527             default {
528                 ret := mload(0x40) // free mem ptr get
529                 mstore(0x40, add(ret, add(size, 0x20))) // free mem ptr set
530                 returndatacopy(ret, 0x20, sub(size, 0x20)) // copy return data
531             }
532         }
533         return ret;
534     }
535 
536     modifier protectState {
537         address preKernel = kernel;
538         bytes32 preAppId = appId;
539         _; // exec
540         require(kernel == preKernel);
541         require(appId == preAppId);
542     }
543 }
544 //File: contracts/acl/ACLSyntaxSugar.sol
545 pragma solidity 0.4.18;
546 
547 
548 contract ACLSyntaxSugar {
549     function arr() internal pure returns (uint256[] r) {}
550 
551     function arr(bytes32 _a) internal pure returns (uint256[] r) {
552         return arr(uint256(_a));
553     }
554 
555     function arr(bytes32 _a, bytes32 _b) internal pure returns (uint256[] r) {
556         return arr(uint256(_a), uint256(_b));
557     }
558 
559     function arr(address _a) internal pure returns (uint256[] r) {
560         return arr(uint256(_a));
561     }
562 
563     function arr(address _a, address _b) internal pure returns (uint256[] r) {
564         return arr(uint256(_a), uint256(_b));
565     }
566 
567     function arr(address _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
568         return arr(uint256(_a), _b, _c);
569     }
570 
571     function arr(address _a, uint256 _b) internal pure returns (uint256[] r) {
572         return arr(uint256(_a), uint256(_b));
573     }
574 
575     function arr(address _a, address _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
576         return arr(uint256(_a), uint256(_b), _c, _d, _e);
577     }
578 
579     function arr(address _a, address _b, address _c) internal pure returns (uint256[] r) {
580         return arr(uint256(_a), uint256(_b), uint256(_c));
581     }
582 
583     function arr(address _a, address _b, uint256 _c) internal pure returns (uint256[] r) {
584         return arr(uint256(_a), uint256(_b), uint256(_c));
585     }
586 
587     function arr(uint256 _a) internal pure returns (uint256[] r) {
588         r = new uint256[](1);
589         r[0] = _a;
590     }
591 
592     function arr(uint256 _a, uint256 _b) internal pure returns (uint256[] r) {
593         r = new uint256[](2);
594         r[0] = _a;
595         r[1] = _b;
596     }
597 
598     function arr(uint256 _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
599         r = new uint256[](3);
600         r[0] = _a;
601         r[1] = _b;
602         r[2] = _c;
603     }
604 
605     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
606         r = new uint256[](4);
607         r[0] = _a;
608         r[1] = _b;
609         r[2] = _c;
610         r[3] = _d;
611     }
612 
613     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
614         r = new uint256[](5);
615         r[0] = _a;
616         r[1] = _b;
617         r[2] = _c;
618         r[3] = _d;
619         r[4] = _e;
620     }
621 }
622 
623 
624 contract ACLHelpers {
625     function decodeParamOp(uint256 _x) internal pure returns (uint8 b) {
626         return uint8(_x >> (8 * 30));
627     }
628 
629     function decodeParamId(uint256 _x) internal pure returns (uint8 b) {
630         return uint8(_x >> (8 * 31));
631     }
632 
633     function decodeParamsList(uint256 _x) internal pure returns (uint32 a, uint32 b, uint32 c) {
634         a = uint32(_x);
635         b = uint32(_x >> (8 * 4));
636         c = uint32(_x >> (8 * 8));
637     }
638 }
639 
640 //File: contracts/apps/AragonApp.sol
641 pragma solidity ^0.4.18;
642 
643 
644 
645 
646 
647 
648 
649 contract AragonApp is AppStorage, Initializable, ACLSyntaxSugar, EVMScriptRunner {
650     modifier auth(bytes32 _role) {
651         require(canPerform(msg.sender, _role, new uint256[](0)));
652         _;
653     }
654 
655     modifier authP(bytes32 _role, uint256[] params) {
656         require(canPerform(msg.sender, _role, params));
657         _;
658     }
659 
660     function canPerform(address _sender, bytes32 _role, uint256[] params) public view returns (bool) {
661         bytes memory how; // no need to init memory as it is never used
662         if (params.length > 0) {
663             uint256 byteLength = params.length * 32;
664             assembly {
665                 how := params // forced casting
666                 mstore(how, byteLength)
667             }
668         }
669         return address(kernel) == 0 || kernel.hasPermission(_sender, address(this), _role, how);
670     }
671 }
672 
673 //File: contracts/ens/ENSSubdomainRegistrar.sol
674 pragma solidity 0.4.18;
675 
676 
677 
678 
679 
680 
681 
682 
683 contract ENSSubdomainRegistrar is AragonApp, ENSConstants {
684     bytes32 constant public CREATE_NAME_ROLE = bytes32(1);
685     bytes32 constant public DELETE_NAME_ROLE = bytes32(2);
686     bytes32 constant public POINT_ROOTNODE_ROLE = bytes32(3);
687 
688     AbstractENS public ens;
689     bytes32 public rootNode;
690 
691     event NewName(bytes32 indexed node, bytes32 indexed label);
692     event DeleteName(bytes32 indexed node, bytes32 indexed label);
693 
694     function initialize(AbstractENS _ens, bytes32 _rootNode) onlyInit public {
695         initialized();
696 
697         // We need ownership to create subnodes
698         require(_ens.owner(_rootNode) == address(this));
699 
700         ens = _ens;
701         rootNode = _rootNode;
702     }
703 
704     function createName(bytes32 _label, address _owner) auth(CREATE_NAME_ROLE) external returns (bytes32 node) {
705         return _createName(_label, _owner);
706     }
707 
708     function createNameAndPoint(bytes32 _label, address _target) auth(CREATE_NAME_ROLE) external returns (bytes32 node) {
709         node = _createName(_label, this);
710         _pointToResolverAndResolve(node, _target);
711     }
712 
713     function deleteName(bytes32 _label) auth(DELETE_NAME_ROLE) external {
714         bytes32 node = keccak256(rootNode, _label);
715 
716         address currentOwner = ens.owner(node);
717 
718         require(currentOwner != address(0)); // fail if deleting unset name
719 
720         if (currentOwner != address(this)) { // needs to reclaim ownership so it can set resolver
721             ens.setSubnodeOwner(rootNode, _label, this);
722         }
723 
724         ens.setResolver(node, address(0)); // remove resolver so it ends resolving
725         ens.setOwner(node, address(0));
726 
727         DeleteName(node, _label);
728     }
729 
730     function pointRootNode(address _target) auth(POINT_ROOTNODE_ROLE) external {
731         _pointToResolverAndResolve(rootNode, _target);
732     }
733 
734     function _createName(bytes32 _label, address _owner) internal returns (bytes32 node) {
735         node = keccak256(rootNode, _label);
736         require(ens.owner(node) == address(0)); // avoid name reset
737 
738         ens.setSubnodeOwner(rootNode, _label, _owner);
739 
740         NewName(node, _label);
741     }
742 
743     function _pointToResolverAndResolve(bytes32 _node, address _target) internal {
744         address publicResolver = getAddr(PUBLIC_RESOLVER_NODE);
745         ens.setResolver(_node, publicResolver);
746 
747         PublicResolver(publicResolver).setAddr(_node, _target);
748     }
749 
750     function getAddr(bytes32 node) internal view returns (address) {
751         address resolver = ens.resolver(node);
752         return PublicResolver(resolver).addr(node);
753     }
754 }
755 
756 //File: contracts/apps/IAppProxy.sol
757 pragma solidity 0.4.18;
758 
759 interface IAppProxy {
760     function isUpgradeable() public pure returns (bool);
761     function getCode() public view returns (address);
762 }
763 
764 //File: contracts/common/DelegateProxy.sol
765 pragma solidity 0.4.18;
766 
767 
768 contract DelegateProxy {
769     /**
770     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
771     * @param _dst Destination address to perform the delegatecall
772     * @param _calldata Calldata for the delegatecall
773     */
774     function delegatedFwd(address _dst, bytes _calldata) internal {
775         require(isContract(_dst));
776         assembly {
777             let result := delegatecall(sub(gas, 10000), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
778             let size := returndatasize
779 
780             let ptr := mload(0x40)
781             returndatacopy(ptr, 0, size)
782 
783             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
784             // if the call returned error data, forward it
785             switch result case 0 { revert(ptr, size) }
786             default { return(ptr, size) }
787         }
788     }
789 
790     function isContract(address _target) internal view returns (bool) {
791         uint256 size;
792         assembly { size := extcodesize(_target) }
793         return size > 0;
794     }
795 }
796 
797 //File: contracts/kernel/KernelStorage.sol
798 pragma solidity 0.4.18;
799 
800 
801 contract KernelConstants {
802     bytes32 constant public CORE_NAMESPACE = keccak256("core");
803     bytes32 constant public APP_BASES_NAMESPACE = keccak256("base");
804     bytes32 constant public APP_ADDR_NAMESPACE = keccak256("app");
805 
806     bytes32 constant public KERNEL_APP_ID = keccak256("kernel.aragonpm.eth");
807     bytes32 constant public KERNEL_APP = keccak256(CORE_NAMESPACE, KERNEL_APP_ID);
808 
809     bytes32 constant public ACL_APP_ID = keccak256("acl.aragonpm.eth");
810     bytes32 constant public ACL_APP = keccak256(APP_ADDR_NAMESPACE, ACL_APP_ID);
811 }
812 
813 
814 contract KernelStorage is KernelConstants {
815     mapping (bytes32 => address) public apps;
816 }
817 
818 //File: contracts/apps/AppProxyBase.sol
819 pragma solidity 0.4.18;
820 
821 
822 
823 
824 
825 
826 
827 contract AppProxyBase is IAppProxy, AppStorage, DelegateProxy, KernelConstants {
828     /**
829     * @dev Initialize AppProxy
830     * @param _kernel Reference to organization kernel for the app
831     * @param _appId Identifier for app
832     * @param _initializePayload Payload for call to be made after setup to initialize
833     */
834     function AppProxyBase(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public {
835         kernel = _kernel;
836         appId = _appId;
837 
838         // Implicit check that kernel is actually a Kernel
839         // The EVM doesn't actually provide a way for us to make sure, but we can force a revert to
840         // occur if the kernel is set to 0x0 or a non-code address when we try to call a method on
841         // it.
842         address appCode = getAppBase(appId);
843 
844         // If initialize payload is provided, it will be executed
845         if (_initializePayload.length > 0) {
846             require(isContract(appCode));
847             // Cannot make delegatecall as a delegateproxy.delegatedFwd as it
848             // returns ending execution context and halts contract deployment
849             require(appCode.delegatecall(_initializePayload));
850         }
851     }
852 
853     function getAppBase(bytes32 _appId) internal view returns (address) {
854         return kernel.getApp(keccak256(APP_BASES_NAMESPACE, _appId));
855     }
856 
857     function () payable public {
858         address target = getCode();
859         require(target != 0); // if app code hasn't been set yet, don't call
860         delegatedFwd(target, msg.data);
861     }
862 }
863 //File: contracts/apps/AppProxyUpgradeable.sol
864 pragma solidity 0.4.18;
865 
866 
867 
868 
869 contract AppProxyUpgradeable is AppProxyBase {
870     address public pinnedCode;
871 
872     /**
873     * @dev Initialize AppProxyUpgradeable (makes it an upgradeable Aragon app)
874     * @param _kernel Reference to organization kernel for the app
875     * @param _appId Identifier for app
876     * @param _initializePayload Payload for call to be made after setup to initialize
877     */
878     function AppProxyUpgradeable(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
879              AppProxyBase(_kernel, _appId, _initializePayload) public
880     {
881 
882     }
883 
884     function getCode() public view returns (address) {
885         return getAppBase(appId);
886     }
887 
888     function isUpgradeable() public pure returns (bool) {
889         return true;
890     }
891 }
892 
893 //File: contracts/apps/AppProxyPinned.sol
894 pragma solidity 0.4.18;
895 
896 
897 
898 
899 contract AppProxyPinned is AppProxyBase {
900     /**
901     * @dev Initialize AppProxyPinned (makes it an un-upgradeable Aragon app)
902     * @param _kernel Reference to organization kernel for the app
903     * @param _appId Identifier for app
904     * @param _initializePayload Payload for call to be made after setup to initialize
905     */
906     function AppProxyPinned(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
907              AppProxyBase(_kernel, _appId, _initializePayload) public
908     {
909         pinnedCode = getAppBase(appId);
910         require(pinnedCode != address(0));
911     }
912 
913     function getCode() public view returns (address) {
914         return pinnedCode;
915     }
916 
917     function isUpgradeable() public pure returns (bool) {
918         return false;
919     }
920 
921     function () payable public {
922         delegatedFwd(getCode(), msg.data);
923     }
924 }
925 //File: contracts/factory/AppProxyFactory.sol
926 pragma solidity 0.4.18;
927 
928 
929 
930 
931 
932 contract AppProxyFactory {
933     event NewAppProxy(address proxy);
934 
935     function newAppProxy(IKernel _kernel, bytes32 _appId) public returns (AppProxyUpgradeable) {
936         return newAppProxy(_kernel, _appId, new bytes(0));
937     }
938 
939     function newAppProxy(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyUpgradeable) {
940         AppProxyUpgradeable proxy = new AppProxyUpgradeable(_kernel, _appId, _initializePayload);
941         NewAppProxy(address(proxy));
942         return proxy;
943     }
944 
945     function newAppProxyPinned(IKernel _kernel, bytes32 _appId) public returns (AppProxyPinned) {
946         return newAppProxyPinned(_kernel, _appId, new bytes(0));
947     }
948 
949     function newAppProxyPinned(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyPinned) {
950         AppProxyPinned proxy = new AppProxyPinned(_kernel, _appId, _initializePayload);
951         NewAppProxy(address(proxy));
952         return proxy;
953     }
954 }
955 
956 //File: contracts/acl/ACL.sol
957 pragma solidity 0.4.18;
958 
959 
960 
961 
962 
963 
964 interface ACLOracle {
965     function canPerform(address who, address where, bytes32 what) public view returns (bool);
966 }
967 
968 
969 contract ACL is IACL, AragonApp, ACLHelpers {
970     bytes32 constant public CREATE_PERMISSIONS_ROLE = keccak256("CREATE_PERMISSIONS_ROLE");
971 
972     // whether a certain entity has a permission
973     mapping (bytes32 => bytes32) permissions; // 0 for no permission, or parameters id
974     mapping (bytes32 => Param[]) public permissionParams;
975 
976     // who is the manager of a permission
977     mapping (bytes32 => address) permissionManager;
978 
979     enum Op { NONE, EQ, NEQ, GT, LT, GTE, LTE, NOT, AND, OR, XOR, IF_ELSE, RET } // op types
980 
981     struct Param {
982         uint8 id;
983         uint8 op;
984         uint240 value; // even though value is an uint240 it can store addresses
985         // in the case of 32 byte hashes losing 2 bytes precision isn't a huge deal
986         // op and id take less than 1 byte each so it can be kept in 1 sstore
987     }
988 
989     uint8 constant BLOCK_NUMBER_PARAM_ID = 200;
990     uint8 constant TIMESTAMP_PARAM_ID    = 201;
991     uint8 constant SENDER_PARAM_ID       = 202;
992     uint8 constant ORACLE_PARAM_ID       = 203;
993     uint8 constant LOGIC_OP_PARAM_ID     = 204;
994     uint8 constant PARAM_VALUE_PARAM_ID  = 205;
995     // TODO: Add execution times param type?
996 
997     bytes32 constant public EMPTY_PARAM_HASH = keccak256(uint256(0));
998     address constant ANY_ENTITY = address(-1);
999 
1000     modifier onlyPermissionManager(address _app, bytes32 _role) {
1001         require(msg.sender == getPermissionManager(_app, _role));
1002         _;
1003     }
1004 
1005     event SetPermission(address indexed entity, address indexed app, bytes32 indexed role, bool allowed);
1006     event ChangePermissionManager(address indexed app, bytes32 indexed role, address indexed manager);
1007 
1008     /**
1009     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
1010     * @notice Initializes an ACL instance and sets `_permissionsCreator` as the entity that can create other permissions
1011     * @param _permissionsCreator Entity that will be given permission over createPermission
1012     */
1013     function initialize(address _permissionsCreator) onlyInit public {
1014         initialized();
1015         require(msg.sender == address(kernel));
1016 
1017         _createPermission(_permissionsCreator, this, CREATE_PERMISSIONS_ROLE, _permissionsCreator);
1018     }
1019 
1020     /**
1021     * @dev Creates a permission that wasn't previously set. Access is limited by the ACL.
1022     *      If a created permission is removed it is possible to reset it with createPermission.
1023     * @notice Create a new permission granting `_entity` the ability to perform actions of role `_role` on `_app` (setting `_manager` as the permission manager)
1024     * @param _entity Address of the whitelisted entity that will be able to perform the role
1025     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1026     * @param _role Identifier for the group of actions in app given access to perform
1027     * @param _manager Address of the entity that will be able to grant and revoke the permission further.
1028     */
1029     function createPermission(address _entity, address _app, bytes32 _role, address _manager) external {
1030         require(hasPermission(msg.sender, address(this), CREATE_PERMISSIONS_ROLE));
1031 
1032         _createPermission(_entity, _app, _role, _manager);
1033     }
1034 
1035     /**
1036     * @dev Grants permission if allowed. This requires `msg.sender` to be the permission manager
1037     * @notice Grants `_entity` the ability to perform actions of role `_role` on `_app`
1038     * @param _entity Address of the whitelisted entity that will be able to perform the role
1039     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1040     * @param _role Identifier for the group of actions in app given access to perform
1041     */
1042     function grantPermission(address _entity, address _app, bytes32 _role)
1043         external
1044     {
1045         grantPermissionP(_entity, _app, _role, new uint256[](0));
1046     }
1047 
1048     /**
1049     * @dev Grants a permission with parameters if allowed. This requires `msg.sender` to be the permission manager
1050     * @notice Grants `_entity` the ability to perform actions of role `_role` on `_app`
1051     * @param _entity Address of the whitelisted entity that will be able to perform the role
1052     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1053     * @param _role Identifier for the group of actions in app given access to perform
1054     * @param _params Permission parameters
1055     */
1056     function grantPermissionP(address _entity, address _app, bytes32 _role, uint256[] _params)
1057         onlyPermissionManager(_app, _role)
1058         public
1059     {
1060         require(!hasPermission(_entity, _app, _role));
1061 
1062         bytes32 paramsHash = _params.length > 0 ? _saveParams(_params) : EMPTY_PARAM_HASH;
1063         _setPermission(_entity, _app, _role, paramsHash);
1064     }
1065 
1066     /**
1067     * @dev Revokes permission if allowed. This requires `msg.sender` to be the the permission manager
1068     * @notice Revokes `_entity` the ability to perform actions of role `_role` on `_app`
1069     * @param _entity Address of the whitelisted entity to revoke access from
1070     * @param _app Address of the app in which the role will be revoked
1071     * @param _role Identifier for the group of actions in app being revoked
1072     */
1073     function revokePermission(address _entity, address _app, bytes32 _role)
1074         onlyPermissionManager(_app, _role)
1075         external
1076     {
1077         require(hasPermission(_entity, _app, _role));
1078 
1079         _setPermission(_entity, _app, _role, bytes32(0));
1080     }
1081 
1082     /**
1083     * @notice Sets `_newManager` as the manager of the permission `_role` in `_app`
1084     * @param _newManager Address for the new manager
1085     * @param _app Address of the app in which the permission management is being transferred
1086     * @param _role Identifier for the group of actions being transferred
1087     */
1088     function setPermissionManager(address _newManager, address _app, bytes32 _role)
1089         onlyPermissionManager(_app, _role)
1090         external
1091     {
1092         _setPermissionManager(_newManager, _app, _role);
1093     }
1094 
1095     /**
1096     * @dev Get manager for permission
1097     * @param _app Address of the app
1098     * @param _role Identifier for a group of actions in app
1099     * @return address of the manager for the permission
1100     */
1101     function getPermissionManager(address _app, bytes32 _role) public view returns (address) {
1102         return permissionManager[roleHash(_app, _role)];
1103     }
1104 
1105     /**
1106     * @dev Function called by apps to check ACL on kernel or to check permission statu
1107     * @param _who Sender of the original call
1108     * @param _where Address of the app
1109     * @param _where Identifier for a group of actions in app
1110     * @param _how Permission parameters
1111     * @return boolean indicating whether the ACL allows the role or not
1112     */
1113     function hasPermission(address _who, address _where, bytes32 _what, bytes memory _how) public view returns (bool) {
1114         uint256[] memory how;
1115         uint256 intsLength = _how.length / 32;
1116         assembly {
1117             how := _how // forced casting
1118             mstore(how, intsLength)
1119         }
1120         // _how is invalid from this point fwd
1121         return hasPermission(_who, _where, _what, how);
1122     }
1123 
1124     function hasPermission(address _who, address _where, bytes32 _what, uint256[] memory _how) public view returns (bool) {
1125         bytes32 whoParams = permissions[permissionHash(_who, _where, _what)];
1126         if (whoParams != bytes32(0) && evalParams(whoParams, _who, _where, _what, _how)) {
1127             return true;
1128         }
1129 
1130         bytes32 anyParams = permissions[permissionHash(ANY_ENTITY, _where, _what)];
1131         if (anyParams != bytes32(0) && evalParams(anyParams, ANY_ENTITY, _where, _what, _how)) {
1132             return true;
1133         }
1134 
1135         return false;
1136     }
1137 
1138     function hasPermission(address _who, address _where, bytes32 _what) public view returns (bool) {
1139         uint256[] memory empty = new uint256[](0);
1140         return hasPermission(_who, _where, _what, empty);
1141     }
1142 
1143     /**
1144     * @dev Internal createPermission for access inside the kernel (on instantiation)
1145     */
1146     function _createPermission(address _entity, address _app, bytes32 _role, address _manager) internal {
1147         // only allow permission creation (or re-creation) when there is no manager
1148         require(getPermissionManager(_app, _role) == address(0));
1149 
1150         _setPermission(_entity, _app, _role, EMPTY_PARAM_HASH);
1151         _setPermissionManager(_manager, _app, _role);
1152     }
1153 
1154     /**
1155     * @dev Internal function called to actually save the permission
1156     */
1157     function _setPermission(address _entity, address _app, bytes32 _role, bytes32 _paramsHash) internal {
1158         permissions[permissionHash(_entity, _app, _role)] = _paramsHash;
1159 
1160         SetPermission(_entity, _app, _role, _paramsHash != bytes32(0));
1161     }
1162 
1163     function _saveParams(uint256[] _encodedParams) internal returns (bytes32) {
1164         bytes32 paramHash = keccak256(_encodedParams);
1165         Param[] storage params = permissionParams[paramHash];
1166 
1167         if (params.length == 0) { // params not saved before
1168             for (uint256 i = 0; i < _encodedParams.length; i++) {
1169                 uint256 encodedParam = _encodedParams[i];
1170                 Param memory param = Param(decodeParamId(encodedParam), decodeParamOp(encodedParam), uint240(encodedParam));
1171                 params.push(param);
1172             }
1173         }
1174 
1175         return paramHash;
1176     }
1177 
1178     function evalParams(
1179         bytes32 _paramsHash,
1180         address _who,
1181         address _where,
1182         bytes32 _what,
1183         uint256[] _how
1184     ) internal view returns (bool)
1185     {
1186         if (_paramsHash == EMPTY_PARAM_HASH) {
1187             return true;
1188         }
1189 
1190         return evalParam(_paramsHash, 0, _who, _where, _what, _how);
1191     }
1192 
1193     function evalParam(
1194         bytes32 _paramsHash,
1195         uint32 _paramId,
1196         address _who,
1197         address _where,
1198         bytes32 _what,
1199         uint256[] _how
1200     ) internal view returns (bool)
1201     {
1202         if (_paramId >= permissionParams[_paramsHash].length) {
1203             return false; // out of bounds
1204         }
1205 
1206         Param memory param = permissionParams[_paramsHash][_paramId];
1207 
1208         if (param.id == LOGIC_OP_PARAM_ID) {
1209             return evalLogic(param, _paramsHash, _who, _where, _what, _how);
1210         }
1211 
1212         uint256 value;
1213         uint256 comparedTo = uint256(param.value);
1214 
1215         // get value
1216         if (param.id == ORACLE_PARAM_ID) {
1217             value = ACLOracle(param.value).canPerform(_who, _where, _what) ? 1 : 0;
1218             comparedTo = 1;
1219         } else if (param.id == BLOCK_NUMBER_PARAM_ID) {
1220             value = blockN();
1221         } else if (param.id == TIMESTAMP_PARAM_ID) {
1222             value = time();
1223         } else if (param.id == SENDER_PARAM_ID) {
1224             value = uint256(msg.sender);
1225         } else if (param.id == PARAM_VALUE_PARAM_ID) {
1226             value = uint256(param.value);
1227         } else {
1228             if (param.id >= _how.length) {
1229                 return false;
1230             }
1231             value = uint256(uint240(_how[param.id])); // force lost precision
1232         }
1233 
1234         if (Op(param.op) == Op.RET) {
1235             return uint256(value) > 0;
1236         }
1237 
1238         return compare(value, Op(param.op), comparedTo);
1239     }
1240 
1241     function evalLogic(Param _param, bytes32 _paramsHash, address _who, address _where, bytes32 _what, uint256[] _how) internal view returns (bool) {
1242         if (Op(_param.op) == Op.IF_ELSE) {
1243             var (condition, success, failure) = decodeParamsList(uint256(_param.value));
1244             bool result = evalParam(_paramsHash, condition, _who, _where, _what, _how);
1245 
1246             return evalParam(_paramsHash, result ? success : failure, _who, _where, _what, _how);
1247         }
1248 
1249         var (v1, v2,) = decodeParamsList(uint256(_param.value));
1250         bool r1 = evalParam(_paramsHash, v1, _who, _where, _what, _how);
1251 
1252         if (Op(_param.op) == Op.NOT) {
1253             return !r1;
1254         }
1255 
1256         if (r1 && Op(_param.op) == Op.OR) {
1257             return true;
1258         }
1259 
1260         if (!r1 && Op(_param.op) == Op.AND) {
1261             return false;
1262         }
1263 
1264         bool r2 = evalParam(_paramsHash, v2, _who, _where, _what, _how);
1265 
1266         if (Op(_param.op) == Op.XOR) {
1267             return (r1 && !r2) || (!r1 && r2);
1268         }
1269 
1270         return r2; // both or and and depend on result of r2 after checks
1271     }
1272 
1273     function compare(uint256 _a, Op _op, uint256 _b) internal pure returns (bool) {
1274         if (_op == Op.EQ)  return _a == _b;                              // solium-disable-line lbrace
1275         if (_op == Op.NEQ) return _a != _b;                              // solium-disable-line lbrace
1276         if (_op == Op.GT)  return _a > _b;                               // solium-disable-line lbrace
1277         if (_op == Op.LT)  return _a < _b;                               // solium-disable-line lbrace
1278         if (_op == Op.GTE) return _a >= _b;                              // solium-disable-line lbrace
1279         if (_op == Op.LTE) return _a <= _b;                              // solium-disable-line lbrace
1280         return false;
1281     }
1282 
1283     /**
1284     * @dev Internal function that sets management
1285     */
1286     function _setPermissionManager(address _newManager, address _app, bytes32 _role) internal {
1287         permissionManager[roleHash(_app, _role)] = _newManager;
1288         ChangePermissionManager(_app, _role, _newManager);
1289     }
1290 
1291     function roleHash(address _where, bytes32 _what) pure internal returns (bytes32) {
1292         return keccak256(uint256(1), _where, _what);
1293     }
1294 
1295     function permissionHash(address _who, address _where, bytes32 _what) pure internal returns (bytes32) {
1296         return keccak256(uint256(2), _who, _where, _what);
1297     }
1298 
1299     function time() internal view returns (uint64) { return uint64(block.timestamp); } // solium-disable-line security/no-block-members
1300 
1301     function blockN() internal view returns (uint256) { return block.number; }
1302 }
1303 
1304 //File: contracts/apm/Repo.sol
1305 pragma solidity ^0.4.15;
1306 
1307 
1308 
1309 
1310 contract Repo is AragonApp {
1311     struct Version {
1312         uint16[3] semanticVersion;
1313         address contractAddress;
1314         bytes contentURI;
1315     }
1316 
1317     Version[] versions;
1318     mapping (bytes32 => uint256) versionIdForSemantic;
1319     mapping (address => uint256) latestVersionIdForContract;
1320 
1321     bytes32 constant public CREATE_VERSION_ROLE = bytes32(1);
1322 
1323     event NewVersion(uint256 versionId, uint16[3] semanticVersion);
1324 
1325     /**
1326     * @notice Create new version for repo
1327     * @param _newSemanticVersion Semantic version for new repo version
1328     * @param _contractAddress address for smart contract logic for version (if set to 0, it uses last versions' contractAddress)
1329     * @param _contentURI External URI for fetching new version's content
1330     */
1331     function newVersion(
1332         uint16[3] _newSemanticVersion,
1333         address _contractAddress,
1334         bytes _contentURI
1335     ) auth(CREATE_VERSION_ROLE) public
1336     {
1337         address contractAddress = _contractAddress;
1338         if (versions.length > 0) {
1339             Version storage lastVersion = versions[versions.length - 1];
1340             require(isValidBump(lastVersion.semanticVersion, _newSemanticVersion));
1341             if (contractAddress == 0) {
1342                 contractAddress = lastVersion.contractAddress;
1343             }
1344             // Only allows smart contract change on major version bumps
1345             require(lastVersion.contractAddress == contractAddress || _newSemanticVersion[0] > lastVersion.semanticVersion[0]);
1346         } else {
1347             versions.length += 1;
1348             uint16[3] memory zeroVersion;
1349             require(isValidBump(zeroVersion, _newSemanticVersion));
1350         }
1351 
1352         uint versionId = versions.push(Version(_newSemanticVersion, contractAddress, _contentURI)) - 1;
1353         versionIdForSemantic[semanticVersionHash(_newSemanticVersion)] = versionId;
1354         latestVersionIdForContract[contractAddress] = versionId;
1355 
1356         NewVersion(versionId, _newSemanticVersion);
1357     }
1358 
1359     function getLatest() public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
1360         return getByVersionId(versions.length - 1);
1361     }
1362 
1363     function getLatestForContractAddress(address _contractAddress) public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
1364         return getByVersionId(latestVersionIdForContract[_contractAddress]);
1365     }
1366 
1367     function getBySemanticVersion(uint16[3] _semanticVersion) public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
1368         return getByVersionId(versionIdForSemantic[semanticVersionHash(_semanticVersion)]);
1369     }
1370 
1371     function getByVersionId(uint _versionId) public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
1372         require(_versionId > 0);
1373         Version storage version = versions[_versionId];
1374         return (version.semanticVersion, version.contractAddress, version.contentURI);
1375     }
1376 
1377     function getVersionsCount() public view returns (uint256) {
1378         uint256 len = versions.length;
1379         return len > 0 ? len - 1 : 0;
1380     }
1381 
1382     function isValidBump(uint16[3] _oldVersion, uint16[3] _newVersion) public pure returns (bool) {
1383         bool hasBumped;
1384         uint i = 0;
1385         while (i < 3) {
1386             if (hasBumped) {
1387                 if (_newVersion[i] != 0) {
1388                     return false;
1389                 }
1390             } else if (_newVersion[i] != _oldVersion[i]) {
1391                 if (_oldVersion[i] > _newVersion[i] || _newVersion[i] - _oldVersion[i] != 1) {
1392                     return false;
1393                 }
1394                 hasBumped = true;
1395             }
1396             i++;
1397         }
1398         return hasBumped;
1399     }
1400 
1401     function semanticVersionHash(uint16[3] version) internal pure returns (bytes32) {
1402         return keccak256(version[0], version[1], version[2]);
1403     }
1404 }
1405 
1406 //File: contracts/apm/APMRegistry.sol
1407 pragma solidity 0.4.18;
1408 
1409 
1410 
1411 
1412 
1413 
1414 
1415 
1416 
1417 contract APMRegistryConstants {
1418     // Cant have a regular APM appId because it is used to build APM
1419     // TODO: recheck this
1420     string constant public APM_APP_NAME = "apm-registry";
1421     string constant public REPO_APP_NAME = "apm-repo";
1422     string constant public ENS_SUB_APP_NAME = "apm-enssub";
1423 }
1424 
1425 
1426 contract APMRegistry is AragonApp, AppProxyFactory, APMRegistryConstants {
1427     AbstractENS ens;
1428     ENSSubdomainRegistrar public registrar;
1429 
1430     bytes32 constant public CREATE_REPO_ROLE = bytes32(1);
1431 
1432     event NewRepo(bytes32 id, string name, address repo);
1433 
1434     /**
1435     * NEEDS CREATE_NAME_ROLE and POINT_ROOTNODE_ROLE permissions on registrar
1436     * @param _registrar ENSSubdomainRegistrar instance that holds registry root node ownership
1437     */
1438     function initialize(ENSSubdomainRegistrar _registrar) onlyInit public {
1439         initialized();
1440 
1441         registrar = _registrar;
1442         ens = registrar.ens();
1443 
1444         registrar.pointRootNode(this);
1445 
1446         // Check APM has all permissions it needss
1447         ACL acl = ACL(kernel.acl());
1448         require(acl.hasPermission(this, registrar, registrar.CREATE_NAME_ROLE()));
1449         require(acl.hasPermission(this, acl, acl.CREATE_PERMISSIONS_ROLE()));
1450     }
1451 
1452     /**
1453     * @notice Create new repo in registry with `_name`
1454     * @param _name Repo name, must be ununsed
1455     * @param _dev Address that will be given permission to create versions
1456     */
1457     function newRepo(string _name, address _dev) auth(CREATE_REPO_ROLE) public returns (Repo) {
1458         return _newRepo(_name, _dev);
1459     }
1460 
1461     /**
1462     * @notice Create new repo in registry with `_name` and first repo version
1463     * @param _name Repo name
1464     * @param _dev Address that will be given permission to create versions
1465     * @param _initialSemanticVersion Semantic version for new repo version
1466     * @param _contractAddress address for smart contract logic for version (if set to 0, it uses last versions' contractAddress)
1467     * @param _contentURI External URI for fetching new version's content
1468     */
1469     function newRepoWithVersion(
1470         string _name,
1471         address _dev,
1472         uint16[3] _initialSemanticVersion,
1473         address _contractAddress,
1474         bytes _contentURI
1475     ) auth(CREATE_REPO_ROLE) public returns (Repo)
1476     {
1477         Repo repo = _newRepo(_name, this); // need to have permissions to create version
1478         repo.newVersion(_initialSemanticVersion, _contractAddress, _contentURI);
1479 
1480         // Give permissions to _dev
1481         ACL acl = ACL(kernel.acl());
1482         acl.revokePermission(this, repo, repo.CREATE_VERSION_ROLE());
1483         acl.grantPermission(_dev, repo, repo.CREATE_VERSION_ROLE());
1484         acl.setPermissionManager(_dev, repo, repo.CREATE_VERSION_ROLE());
1485         return repo;
1486     }
1487 
1488     function _newRepo(string _name, address _dev) internal returns (Repo) {
1489         require(bytes(_name).length > 0);
1490 
1491         Repo repo = newClonedRepo();
1492 
1493         ACL(kernel.acl()).createPermission(_dev, repo, repo.CREATE_VERSION_ROLE(), _dev);
1494 
1495         // Creates [name] subdomain in the rootNode and sets registry as resolver
1496         // This will fail if repo name already exists
1497         bytes32 node = registrar.createNameAndPoint(keccak256(_name), repo);
1498 
1499         NewRepo(node, _name, repo);
1500 
1501         return repo;
1502     }
1503 
1504     function newClonedRepo() internal returns (Repo) {
1505         return Repo(newAppProxy(kernel, repoAppId()));
1506     }
1507 
1508     function repoAppId() internal view returns (bytes32) {
1509         return keccak256(registrar.rootNode(), keccak256(REPO_APP_NAME));
1510     }
1511 }
1512 
1513 //File: contracts/kernel/Kernel.sol
1514 pragma solidity 0.4.18;
1515 
1516 
1517 
1518 
1519 
1520 
1521 
1522 
1523 
1524 contract Kernel is IKernel, KernelStorage, Initializable, AppProxyFactory, ACLSyntaxSugar {
1525     bytes32 constant public APP_MANAGER_ROLE = keccak256("APP_MANAGER_ROLE");
1526 
1527     /**
1528     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
1529     * @notice Initializes a kernel instance along with its ACL and sets `_permissionsCreator` as the entity that can create other permissions
1530     * @param _baseAcl Address of base ACL app
1531     * @param _permissionsCreator Entity that will be given permission over createPermission
1532     */
1533     function initialize(address _baseAcl, address _permissionsCreator) onlyInit public {
1534         initialized();
1535 
1536         IACL acl = IACL(newAppProxy(this, ACL_APP_ID));
1537 
1538         _setApp(APP_BASES_NAMESPACE, ACL_APP_ID, _baseAcl);
1539         _setApp(APP_ADDR_NAMESPACE, ACL_APP_ID, acl);
1540 
1541         acl.initialize(_permissionsCreator);
1542     }
1543 
1544     /**
1545     * @dev Create a new instance of an app linked to this kernel and set its base
1546     *      implementation if it was not already set
1547     * @param _name Name of the app
1548     * @param _appBase Address of the app's base implementation
1549     * @return AppProxy instance
1550     */
1551     function newAppInstance(bytes32 _name, address _appBase) auth(APP_MANAGER_ROLE, arr(APP_BASES_NAMESPACE, _name)) public returns (IAppProxy appProxy) {
1552         _setAppIfNew(APP_BASES_NAMESPACE, _name, _appBase);
1553         appProxy = newAppProxy(this, _name);
1554     }
1555 
1556     /**
1557     * @dev Create a new pinned instance of an app linked to this kernel and set
1558     *      its base implementation if it was not already set
1559     * @param _name Name of the app
1560     * @param _appBase Address of the app's base implementation
1561     * @return AppProxy instance
1562     */
1563     function newPinnedAppInstance(bytes32 _name, address _appBase) auth(APP_MANAGER_ROLE, arr(APP_BASES_NAMESPACE, _name)) public returns (IAppProxy appProxy) {
1564         _setAppIfNew(APP_BASES_NAMESPACE, _name, _appBase);
1565         appProxy = newAppProxyPinned(this, _name);
1566     }
1567 
1568     /**
1569     * @dev Set the resolving address of an app instance or base implementation
1570     * @param _namespace App namespace to use
1571     * @param _name Name of the app
1572     * @param _app Address of the app
1573     * @return ID of app
1574     */
1575     function setApp(bytes32 _namespace, bytes32 _name, address _app) auth(APP_MANAGER_ROLE, arr(_namespace, _name)) kernelIntegrity public returns (bytes32 id) {
1576         return _setApp(_namespace, _name, _app);
1577     }
1578 
1579     /**
1580     * @dev Get the address of an app instance or base implementation
1581     * @param _id App identifier
1582     * @return Address of the app
1583     */
1584     function getApp(bytes32 _id) public view returns (address) {
1585         return apps[_id];
1586     }
1587 
1588     /**
1589     * @dev Get the installed ACL app
1590     * @return ACL app
1591     */
1592     function acl() public view returns (IACL) {
1593         return IACL(getApp(ACL_APP));
1594     }
1595 
1596     /**
1597     * @dev Function called by apps to check ACL on kernel or to check permission status
1598     * @param _who Sender of the original call
1599     * @param _where Address of the app
1600     * @param _what Identifier for a group of actions in app
1601     * @param _how Extra data for ACL auth
1602     * @return boolean indicating whether the ACL allows the role or not
1603     */
1604     function hasPermission(address _who, address _where, bytes32 _what, bytes _how) public view returns (bool) {
1605         return acl().hasPermission(_who, _where, _what, _how);
1606     }
1607 
1608     function _setApp(bytes32 _namespace, bytes32 _name, address _app) internal returns (bytes32 id) {
1609         id = keccak256(_namespace, _name);
1610         apps[id] = _app;
1611         SetApp(_namespace, _name, id, _app);
1612     }
1613 
1614     function _setAppIfNew(bytes32 _namespace, bytes32 _name, address _app) internal returns (bytes32 id) {
1615         id = keccak256(_namespace, _name);
1616 
1617         if (_app != address(0)) {
1618             address app = getApp(id);
1619             if (app != address(0)) {
1620                 require(app == _app);
1621             } else {
1622                 apps[id] = _app;
1623                 SetApp(_namespace, _name, id, _app);
1624             }
1625         }
1626     }
1627 
1628     modifier auth(bytes32 _role, uint256[] memory params) {
1629         bytes memory how;
1630         uint256 byteLength = params.length * 32;
1631         assembly {
1632             how := params // forced casting
1633             mstore(how, byteLength)
1634         }
1635         // Params is invalid from this point fwd
1636         require(hasPermission(msg.sender, address(this), _role, how));
1637         _;
1638     }
1639 
1640     modifier kernelIntegrity {
1641         _; // After execution check integrity
1642         address kernel = getApp(KERNEL_APP);
1643         uint256 size;
1644         assembly { size := extcodesize(kernel) }
1645         require(size > 0);
1646     }
1647 }
1648 
1649 //File: contracts/kernel/KernelProxy.sol
1650 pragma solidity 0.4.18;
1651 
1652 
1653 
1654 
1655 
1656 contract KernelProxy is KernelStorage, DelegateProxy {
1657     /**
1658     * @dev KernelProxy is a proxy contract to a kernel implementation. The implementation
1659     *      can update the reference, which effectively upgrades the contract
1660     * @param _kernelImpl Address of the contract used as implementation for kernel
1661     */
1662     function KernelProxy(address _kernelImpl) public {
1663         apps[keccak256(CORE_NAMESPACE, KERNEL_APP_ID)] = _kernelImpl;
1664     }
1665 
1666     /**
1667     * @dev All calls made to the proxy are forwarded to the kernel implementation via a delegatecall
1668     * @return Any bytes32 value the implementation returns
1669     */
1670     function () payable public {
1671         delegatedFwd(apps[KERNEL_APP], msg.data);
1672     }
1673 }
1674 //File: contracts/evmscript/EVMScriptRegistry.sol
1675 pragma solidity 0.4.18;
1676 
1677 
1678 
1679 
1680 
1681 
1682 
1683 
1684 contract EVMScriptRegistry is IEVMScriptRegistry, EVMScriptRegistryConstants, AragonApp {
1685     using ScriptHelpers for bytes;
1686 
1687     // WARN: Manager can censor all votes and the like happening in an org
1688     bytes32 constant public REGISTRY_MANAGER_ROLE = bytes32(1);
1689 
1690     struct ExecutorEntry {
1691         address executor;
1692         bool enabled;
1693     }
1694 
1695     ExecutorEntry[] public executors;
1696 
1697     function initialize() onlyInit public {
1698         initialized();
1699         // Create empty record to begin executor IDs at 1
1700         executors.push(ExecutorEntry(address(0), false));
1701     }
1702 
1703     function addScriptExecutor(address _executor) external auth(REGISTRY_MANAGER_ROLE) returns (uint id) {
1704         return executors.push(ExecutorEntry(_executor, true));
1705     }
1706 
1707     function disableScriptExecutor(uint256 _executorId) external auth(REGISTRY_MANAGER_ROLE) {
1708         executors[_executorId].enabled = false;
1709     }
1710 
1711     function getScriptExecutor(bytes _script) public view returns (address) {
1712         uint256 id = _script.getSpecId();
1713 
1714         if (id == 0 || id >= executors.length) {
1715             return address(0);
1716         }
1717 
1718         ExecutorEntry storage entry = executors[id];
1719         return entry.enabled ? entry.executor : address(0);
1720     }
1721 }
1722 
1723 //File: contracts/evmscript/executors/CallsScript.sol
1724 pragma solidity ^0.4.18;
1725 
1726 // Inspired by https://github.com/reverendus/tx-manager
1727 
1728 
1729 
1730 
1731 
1732 contract CallsScript is IEVMScriptExecutor {
1733     using ScriptHelpers for bytes;
1734 
1735     uint256 constant internal SCRIPT_START_LOCATION = 4;
1736 
1737     event LogScriptCall(address indexed sender, address indexed src, address indexed dst);
1738 
1739     /**
1740     * @notice Executes a number of call scripts
1741     * @param _script [ specId (uint32) ] many calls with this structure ->
1742     *    [ to (address: 20 bytes) ] [ calldataLength (uint32: 4 bytes) ] [ calldata (calldataLength bytes) ]
1743     * @param _input Input is ignored in callscript
1744     * @param _blacklist Addresses the script cannot call to, or will revert.
1745     * @return always returns empty byte array
1746     */
1747     function execScript(bytes _script, bytes _input, address[] _blacklist) external returns (bytes) {
1748         uint256 location = SCRIPT_START_LOCATION; // first 32 bits are spec id
1749         while (location < _script.length) {
1750             address contractAddress = _script.addressAt(location);
1751             // Check address being called is not blacklist
1752             for (uint i = 0; i < _blacklist.length; i++) {
1753                 require(contractAddress != _blacklist[i]);
1754             }
1755 
1756             // logged before execution to ensure event ordering in receipt
1757             // if failed entire execution is reverted regardless
1758             LogScriptCall(msg.sender, address(this), contractAddress);
1759 
1760             uint256 calldataLength = uint256(_script.uint32At(location + 0x14));
1761             uint256 calldataStart = _script.locationOf(location + 0x14 + 0x04);
1762 
1763             assembly {
1764                 let success := call(sub(gas, 5000), contractAddress, 0, calldataStart, calldataLength, 0, 0)
1765                 switch success case 0 { revert(0, 0) }
1766             }
1767 
1768             location += (0x14 + 0x04 + calldataLength);
1769         }
1770     }
1771 }
1772 //File: contracts/evmscript/executors/DelegateScript.sol
1773 pragma solidity 0.4.18;
1774 
1775 
1776 
1777 
1778 
1779 interface DelegateScriptTarget {
1780     function exec() public;
1781 }
1782 
1783 
1784 contract DelegateScript is IEVMScriptExecutor {
1785     using ScriptHelpers for *;
1786 
1787     uint256 constant internal SCRIPT_START_LOCATION = 4;
1788 
1789     /**
1790     * @notice Executes script by delegatecall into a contract
1791     * @param _script [ specId (uint32) ][ contract address (20 bytes) ]
1792     * @param _input ABI encoded call to be made to contract (if empty executes default exec() function)
1793     * @param _blacklist If any address is passed, will revert.
1794     * @return Call return data
1795     */
1796     function execScript(bytes _script, bytes _input, address[] _blacklist) external returns (bytes) {
1797         require(_blacklist.length == 0); // dont have ability to control bans, so fail.
1798 
1799         // Script should be spec id + address (20 bytes)
1800         require(_script.length == SCRIPT_START_LOCATION + 20);
1801         return delegate(_script.addressAt(SCRIPT_START_LOCATION), _input);
1802     }
1803 
1804     /**
1805     * @dev Delegatecall to contract with input data
1806     */
1807     function delegate(address _addr, bytes memory _input) internal returns (bytes memory output) {
1808         require(isContract(_addr));
1809         require(_addr.delegatecall(_input.length > 0 ? _input : defaultInput()));
1810         return returnedData();
1811     }
1812 
1813     function isContract(address _target) internal view returns (bool) {
1814         uint256 size;
1815         assembly { size := extcodesize(_target) }
1816         return size > 0;
1817     }
1818 
1819     function defaultInput() internal pure returns (bytes) {
1820         return DelegateScriptTarget(0).exec.selector.toBytes();
1821     }
1822 
1823     /**
1824     * @dev copies and returns last's call data
1825     */
1826     function returnedData() internal view returns (bytes ret) {
1827         assembly {
1828             let size := returndatasize
1829             ret := mload(0x40) // free mem ptr get
1830             mstore(0x40, add(ret, add(size, 0x20))) // free mem ptr set
1831             mstore(ret, size) // set array length
1832             returndatacopy(add(ret, 0x20), 0, size) // copy return data
1833         }
1834         return ret;
1835     }
1836 }
1837 //File: contracts/evmscript/executors/DeployDelegateScript.sol
1838 pragma solidity 0.4.18;
1839 
1840 
1841 
1842 // Inspired by: https://github.com/dapphub/ds-proxy/blob/master/src/proxy.sol
1843 
1844 
1845 contract DeployDelegateScript is DelegateScript {
1846     uint256 constant internal SCRIPT_START_LOCATION = 4;
1847 
1848     mapping (bytes32 => address) cache;
1849 
1850     /**
1851     * @notice Executes script by delegatecall into a deployed contract (exec() function)
1852     * @param _script [ specId (uint32) ][ contractInitcode (bytecode) ]
1853     * @param _input ABI encoded call to be made to contract (if empty executes default exec() function)
1854     * @param _blacklist If any address is passed, will revert.
1855     * @return Call return data
1856     */
1857     function execScript(bytes _script, bytes _input, address[] _blacklist) external returns (bytes) {
1858         require(_blacklist.length == 0); // dont have ability to control bans, so fail.
1859 
1860         bytes32 id = keccak256(_script);
1861         address deployed = cache[id];
1862         if (deployed == address(0)) {
1863             deployed = deploy(_script);
1864             cache[id] = deployed;
1865         }
1866 
1867         return DelegateScript.delegate(deployed, _input);
1868     }
1869 
1870     /**
1871     * @dev Deploys contract byte code to network
1872     */
1873     function deploy(bytes _script) internal returns (address addr) {
1874         assembly {
1875             // 0x24 = 0x20 (length) + 0x04 (spec id uint32)
1876             // Length of code is 4 bytes less than total script size
1877             addr := create(0, add(_script, 0x24), sub(mload(_script), 0x04))
1878             switch iszero(extcodesize(addr))
1879             case 1 { revert(0, 0) } // throw if contract failed to deploy
1880         }
1881     }
1882 }
1883 //File: contracts/factory/EVMScriptRegistryFactory.sol
1884 pragma solidity 0.4.18;
1885 
1886 
1887 
1888 
1889 
1890 
1891 
1892 
1893 
1894 
1895 
1896 
1897 contract EVMScriptRegistryFactory is AppProxyFactory, EVMScriptRegistryConstants {
1898     address public baseReg;
1899     address public baseCalls;
1900     address public baseDel;
1901     address public baseDeployDel;
1902 
1903     function EVMScriptRegistryFactory() public {
1904         baseReg = address(new EVMScriptRegistry());
1905         baseCalls = address(new CallsScript());
1906         baseDel = address(new DelegateScript());
1907         baseDeployDel = address(new DeployDelegateScript());
1908     }
1909 
1910     function newEVMScriptRegistry(Kernel _dao, address _root) public returns (EVMScriptRegistry reg) {
1911         reg = EVMScriptRegistry(_dao.newPinnedAppInstance(EVMSCRIPT_REGISTRY_APP_ID, baseReg));
1912         reg.initialize();
1913 
1914         ACL acl = ACL(_dao.acl());
1915 
1916         _dao.setApp(_dao.APP_ADDR_NAMESPACE(), EVMSCRIPT_REGISTRY_APP_ID, reg);
1917         acl.createPermission(this, reg, reg.REGISTRY_MANAGER_ROLE(), this);
1918 
1919         reg.addScriptExecutor(baseCalls);     // spec 1 = CallsScript
1920         reg.addScriptExecutor(baseDel);       // spec 2 = DelegateScript
1921         reg.addScriptExecutor(baseDeployDel); // spec 3 = DeployDelegateScript
1922 
1923         acl.revokePermission(this, reg, reg.REGISTRY_MANAGER_ROLE());
1924         acl.setPermissionManager(_root, reg, reg.REGISTRY_MANAGER_ROLE());
1925 
1926         return reg;
1927     }
1928 }
1929 
1930 //File: contracts/factory/DAOFactory.sol
1931 pragma solidity 0.4.18;
1932 
1933 
1934 
1935 
1936 
1937 
1938 
1939 
1940 
1941 contract DAOFactory {
1942     address public baseKernel;
1943     address public baseACL;
1944     EVMScriptRegistryFactory public regFactory;
1945 
1946     event DeployDAO(address dao);
1947     event DeployEVMScriptRegistry(address reg);
1948 
1949     function DAOFactory(address _baseKernel, address _baseACL, address _regFactory) public {
1950         // No need to init as it cannot be killed by devops199
1951         if (_regFactory != address(0)) {
1952             regFactory = EVMScriptRegistryFactory(_regFactory);
1953         }
1954 
1955         baseKernel = _baseKernel;
1956         baseACL = _baseACL;
1957     }
1958 
1959     /**
1960     * @param _root Address that will be granted control to setup DAO permissions
1961     */
1962     function newDAO(address _root) public returns (Kernel dao) {
1963         dao = Kernel(new KernelProxy(baseKernel));
1964 
1965         address initialRoot = address(regFactory) != address(0) ? this : _root;
1966         dao.initialize(baseACL, initialRoot);
1967 
1968         ACL acl = ACL(dao.acl());
1969 
1970         if (address(regFactory) != address(0)) {
1971             bytes32 permRole = acl.CREATE_PERMISSIONS_ROLE();
1972             bytes32 appManagerRole = dao.APP_MANAGER_ROLE();
1973 
1974             acl.grantPermission(regFactory, acl, permRole);
1975 
1976             acl.createPermission(regFactory, dao, appManagerRole, this);
1977 
1978             EVMScriptRegistry reg = regFactory.newEVMScriptRegistry(dao, _root);
1979             DeployEVMScriptRegistry(address(reg));
1980 
1981             acl.revokePermission(regFactory, dao, appManagerRole);
1982             acl.grantPermission(_root, acl, permRole);
1983 
1984             acl.setPermissionManager(address(0), dao, appManagerRole);
1985             acl.setPermissionManager(_root, acl, permRole);
1986         }
1987 
1988         DeployDAO(dao);
1989     }
1990 }
1991 
1992 //File: contracts/lib/ens/ENS.sol
1993 pragma solidity ^0.4.0;
1994 
1995 
1996 
1997 
1998 /**
1999  * The ENS registry contract.
2000  */
2001 contract ENS is AbstractENS {
2002     struct Record {
2003         address owner;
2004         address resolver;
2005         uint64 ttl;
2006     }
2007 
2008     mapping(bytes32=>Record) records;
2009 
2010     // Permits modifications only by the owner of the specified node.
2011     modifier only_owner(bytes32 node) {
2012         if (records[node].owner != msg.sender) throw;
2013         _;
2014     }
2015 
2016     /**
2017      * Constructs a new ENS registrar.
2018      */
2019     function ENS() {
2020         records[0].owner = msg.sender;
2021     }
2022 
2023     /**
2024      * Returns the address that owns the specified node.
2025      */
2026     function owner(bytes32 node) constant returns (address) {
2027         return records[node].owner;
2028     }
2029 
2030     /**
2031      * Returns the address of the resolver for the specified node.
2032      */
2033     function resolver(bytes32 node) constant returns (address) {
2034         return records[node].resolver;
2035     }
2036 
2037     /**
2038      * Returns the TTL of a node, and any records associated with it.
2039      */
2040     function ttl(bytes32 node) constant returns (uint64) {
2041         return records[node].ttl;
2042     }
2043 
2044     /**
2045      * Transfers ownership of a node to a new address. May only be called by the current
2046      * owner of the node.
2047      * @param node The node to transfer ownership of.
2048      * @param owner The address of the new owner.
2049      */
2050     function setOwner(bytes32 node, address owner) only_owner(node) {
2051         Transfer(node, owner);
2052         records[node].owner = owner;
2053     }
2054 
2055     /**
2056      * Transfers ownership of a subnode keccak256(node, label) to a new address. May only be
2057      * called by the owner of the parent node.
2058      * @param node The parent node.
2059      * @param label The hash of the label specifying the subnode.
2060      * @param owner The address of the new owner.
2061      */
2062     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) only_owner(node) {
2063         var subnode = keccak256(node, label);
2064         NewOwner(node, label, owner);
2065         records[subnode].owner = owner;
2066     }
2067 
2068     /**
2069      * Sets the resolver address for the specified node.
2070      * @param node The node to update.
2071      * @param resolver The address of the resolver.
2072      */
2073     function setResolver(bytes32 node, address resolver) only_owner(node) {
2074         NewResolver(node, resolver);
2075         records[node].resolver = resolver;
2076     }
2077 
2078     /**
2079      * Sets the TTL for the specified node.
2080      * @param node The node to update.
2081      * @param ttl The TTL in seconds.
2082      */
2083     function setTTL(bytes32 node, uint64 ttl) only_owner(node) {
2084         NewTTL(node, ttl);
2085         records[node].ttl = ttl;
2086     }
2087 }
2088 
2089 //File: contracts/factory/ENSFactory.sol
2090 pragma solidity 0.4.18;
2091 
2092 
2093 
2094 
2095 
2096 
2097 contract ENSFactory is ENSConstants {
2098     event DeployENS(address ens);
2099 
2100     // This is an incredibly trustfull ENS deployment, only use for testing
2101     function newENS(address _owner) public returns (ENS ens) {
2102         ens = new ENS();
2103 
2104         // Setup .eth TLD
2105         ens.setSubnodeOwner(ENS_ROOT, ETH_TLD_LABEL, this);
2106 
2107         // Setup public resolver
2108         PublicResolver resolver = new PublicResolver(ens);
2109         ens.setSubnodeOwner(ETH_TLD_NODE, PUBLIC_RESOLVER_LABEL, this);
2110         ens.setResolver(PUBLIC_RESOLVER_NODE, resolver);
2111         resolver.setAddr(PUBLIC_RESOLVER_NODE, resolver);
2112 
2113         ens.setOwner(ETH_TLD_NODE, _owner);
2114         ens.setOwner(ENS_ROOT, _owner);
2115 
2116         DeployENS(ens);
2117     }
2118 }
2119 
2120 //File: contracts/factory/APMRegistryFactory.sol
2121 pragma solidity 0.4.18;
2122 
2123 
2124 
2125 
2126 
2127 
2128 
2129 
2130 
2131 
2132 contract APMRegistryFactory is APMRegistryConstants {
2133     DAOFactory public daoFactory;
2134     APMRegistry public registryBase;
2135     Repo public repoBase;
2136     ENSSubdomainRegistrar public ensSubdomainRegistrarBase;
2137     ENS public ens;
2138 
2139     event DeployAPM(bytes32 indexed node, address apm);
2140 
2141     // Needs either one ENS or ENSFactory
2142     function APMRegistryFactory(
2143         DAOFactory _daoFactory,
2144         APMRegistry _registryBase,
2145         Repo _repoBase,
2146         ENSSubdomainRegistrar _ensSubBase,
2147         ENS _ens,
2148         ENSFactory _ensFactory
2149     ) public // DAO initialized without evmscript run support
2150     {
2151         daoFactory = _daoFactory;
2152         registryBase = _registryBase;
2153         repoBase = _repoBase;
2154         ensSubdomainRegistrarBase = _ensSubBase;
2155 
2156         // Either the ENS address provided is used, if any.
2157         // Or we use the ENSFactory to generate a test instance of ENS
2158         // If not the ENS address nor factory address are provided, this will revert
2159         ens = _ens != address(0) ? _ens : _ensFactory.newENS(this);
2160     }
2161 
2162     function newAPM(bytes32 _tld, bytes32 _label, address _root) public returns (APMRegistry) {
2163         bytes32 node = keccak256(_tld, _label);
2164 
2165         // Assume it is the test ENS
2166         if (ens.owner(node) != address(this)) {
2167             // If we weren't in test ens and factory doesn't have ownership, will fail
2168             ens.setSubnodeOwner(_tld, _label, this);
2169         }
2170 
2171         Kernel dao = daoFactory.newDAO(this);
2172         ACL acl = ACL(dao.acl());
2173 
2174         acl.createPermission(this, dao, dao.APP_MANAGER_ROLE(), this);
2175 
2176         bytes32 namespace = dao.APP_BASES_NAMESPACE();
2177 
2178         // Deploy app proxies
2179         ENSSubdomainRegistrar ensSub = ENSSubdomainRegistrar(dao.newAppInstance(keccak256(node, keccak256(ENS_SUB_APP_NAME)), ensSubdomainRegistrarBase));
2180         APMRegistry apm = APMRegistry(dao.newAppInstance(keccak256(node, keccak256(APM_APP_NAME)), registryBase));
2181 
2182         // APMRegistry controls Repos
2183         dao.setApp(namespace, keccak256(node, keccak256(REPO_APP_NAME)), repoBase);
2184 
2185         DeployAPM(node, apm);
2186 
2187         // Grant permissions needed for APM on ENSSubdomainRegistrar
2188         acl.createPermission(apm, ensSub, ensSub.CREATE_NAME_ROLE(), _root);
2189         acl.createPermission(apm, ensSub, ensSub.POINT_ROOTNODE_ROLE(), _root);
2190 
2191         // allow apm to create permissions for Repos in Kernel
2192         bytes32 permRole = acl.CREATE_PERMISSIONS_ROLE();
2193 
2194         acl.grantPermission(apm, acl, permRole);
2195 
2196         // Initialize
2197         ens.setOwner(node, ensSub);
2198         ensSub.initialize(ens, node);
2199         apm.initialize(ensSub);
2200 
2201         uint16[3] memory firstVersion;
2202         firstVersion[0] = 1;
2203 
2204         acl.createPermission(this, apm, apm.CREATE_REPO_ROLE(), this);
2205 
2206         apm.newRepoWithVersion(APM_APP_NAME, _root, firstVersion, registryBase, b("ipfs:apm"));
2207         apm.newRepoWithVersion(ENS_SUB_APP_NAME, _root, firstVersion, ensSubdomainRegistrarBase, b("ipfs:enssub"));
2208         apm.newRepoWithVersion(REPO_APP_NAME, _root, firstVersion, repoBase, b("ipfs:repo"));
2209 
2210         configureAPMPermissions(acl, apm, _root);
2211 
2212         // Permission transition to _root
2213         acl.setPermissionManager(_root, dao, dao.APP_MANAGER_ROLE());
2214         acl.revokePermission(this, acl, permRole);
2215         acl.grantPermission(_root, acl, permRole);
2216         acl.setPermissionManager(_root, acl, permRole);
2217 
2218         return apm;
2219     }
2220 
2221     function b(string memory x) internal pure returns (bytes memory y) {
2222         y = bytes(x);
2223     }
2224 
2225     // Factory can be subclassed and permissions changed
2226     function configureAPMPermissions(ACL _acl, APMRegistry _apm, address _root) internal {
2227         _acl.grantPermission(_root, _apm, _apm.CREATE_REPO_ROLE());
2228         _acl.setPermissionManager(_root, _apm, _apm.CREATE_REPO_ROLE());
2229     }
2230 }