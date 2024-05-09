1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be aplied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * > Note: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: @ensdomains/ens/contracts/ENS.sol
80 
81 pragma solidity >=0.4.24;
82 
83 interface ENS {
84 
85     // Logged when the owner of a node assigns a new owner to a subnode.
86     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
87 
88     // Logged when the owner of a node transfers ownership to a new account.
89     event Transfer(bytes32 indexed node, address owner);
90 
91     // Logged when the resolver for a node changes.
92     event NewResolver(bytes32 indexed node, address resolver);
93 
94     // Logged when the TTL of a node changes
95     event NewTTL(bytes32 indexed node, uint64 ttl);
96 
97 
98     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
99     function setResolver(bytes32 node, address resolver) external;
100     function setOwner(bytes32 node, address owner) external;
101     function setTTL(bytes32 node, uint64 ttl) external;
102     function owner(bytes32 node) external view returns (address);
103     function resolver(bytes32 node) external view returns (address);
104     function ttl(bytes32 node) external view returns (uint64);
105 
106 }
107 
108 // File: @ensdomains/resolver/contracts/ResolverBase.sol
109 
110 pragma solidity ^0.5.0;
111 
112 contract ResolverBase {
113     bytes4 private constant INTERFACE_META_ID = 0x01ffc9a7;
114 
115     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
116         return interfaceID == INTERFACE_META_ID;
117     }
118 
119     function isAuthorised(bytes32 node) internal view returns(bool);
120 
121     modifier authorised(bytes32 node) {
122         require(isAuthorised(node));
123         _;
124     }
125 }
126 
127 // File: @ensdomains/resolver/contracts/profiles/ABIResolver.sol
128 
129 pragma solidity ^0.5.0;
130 
131 
132 contract ABIResolver is ResolverBase {
133     bytes4 constant private ABI_INTERFACE_ID = 0x2203ab56;
134 
135     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
136 
137     mapping(bytes32=>mapping(uint256=>bytes)) abis;
138 
139     /**
140      * Sets the ABI associated with an ENS node.
141      * Nodes may have one ABI of each content type. To remove an ABI, set it to
142      * the empty string.
143      * @param node The node to update.
144      * @param contentType The content type of the ABI
145      * @param data The ABI data.
146      */
147     function setABI(bytes32 node, uint256 contentType, bytes calldata data) external authorised(node) {
148         // Content types must be powers of 2
149         require(((contentType - 1) & contentType) == 0);
150 
151         abis[node][contentType] = data;
152         emit ABIChanged(node, contentType);
153     }
154 
155     /**
156      * Returns the ABI associated with an ENS node.
157      * Defined in EIP205.
158      * @param node The ENS node to query
159      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
160      * @return contentType The content type of the return value
161      * @return data The ABI data
162      */
163     function ABI(bytes32 node, uint256 contentTypes) external view returns (uint256, bytes memory) {
164         mapping(uint256=>bytes) storage abiset = abis[node];
165 
166         for (uint256 contentType = 1; contentType <= contentTypes; contentType <<= 1) {
167             if ((contentType & contentTypes) != 0 && abiset[contentType].length > 0) {
168                 return (contentType, abiset[contentType]);
169             }
170         }
171 
172         return (0, bytes(""));
173     }
174 
175     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
176         return interfaceID == ABI_INTERFACE_ID || super.supportsInterface(interfaceID);
177     }
178 }
179 
180 // File: @ensdomains/resolver/contracts/profiles/AddrResolver.sol
181 
182 pragma solidity ^0.5.0;
183 
184 
185 contract AddrResolver is ResolverBase {
186     bytes4 constant private ADDR_INTERFACE_ID = 0x3b3b57de;
187 
188     event AddrChanged(bytes32 indexed node, address a);
189 
190     mapping(bytes32=>address) addresses;
191 
192     /**
193      * Sets the address associated with an ENS node.
194      * May only be called by the owner of that node in the ENS registry.
195      * @param node The node to update.
196      * @param addr The address to set.
197      */
198     function setAddr(bytes32 node, address addr) external authorised(node) {
199         addresses[node] = addr;
200         emit AddrChanged(node, addr);
201     }
202 
203     /**
204      * Returns the address associated with an ENS node.
205      * @param node The ENS node to query.
206      * @return The associated address.
207      */
208     function addr(bytes32 node) public view returns (address) {
209         return addresses[node];
210     }
211 
212     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
213         return interfaceID == ADDR_INTERFACE_ID || super.supportsInterface(interfaceID);
214     }
215 }
216 
217 // File: @ensdomains/resolver/contracts/profiles/ContentHashResolver.sol
218 
219 pragma solidity ^0.5.0;
220 
221 
222 contract ContentHashResolver is ResolverBase {
223     bytes4 constant private CONTENT_HASH_INTERFACE_ID = 0xbc1c58d1;
224 
225     event ContenthashChanged(bytes32 indexed node, bytes hash);
226 
227     mapping(bytes32=>bytes) hashes;
228 
229     /**
230      * Sets the contenthash associated with an ENS node.
231      * May only be called by the owner of that node in the ENS registry.
232      * @param node The node to update.
233      * @param hash The contenthash to set
234      */
235     function setContenthash(bytes32 node, bytes calldata hash) external authorised(node) {
236         hashes[node] = hash;
237         emit ContenthashChanged(node, hash);
238     }
239 
240     /**
241      * Returns the contenthash associated with an ENS node.
242      * @param node The ENS node to query.
243      * @return The associated contenthash.
244      */
245     function contenthash(bytes32 node) external view returns (bytes memory) {
246         return hashes[node];
247     }
248 
249     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
250         return interfaceID == CONTENT_HASH_INTERFACE_ID || super.supportsInterface(interfaceID);
251     }
252 }
253 
254 // File: @ensdomains/resolver/contracts/profiles/InterfaceResolver.sol
255 
256 pragma solidity ^0.5.0;
257 
258 
259 
260 contract InterfaceResolver is ResolverBase, AddrResolver {
261     bytes4 constant private INTERFACE_INTERFACE_ID = bytes4(keccak256("interfaceImplementer(bytes32,bytes4)"));
262     bytes4 private constant INTERFACE_META_ID = 0x01ffc9a7;
263 
264     event InterfaceChanged(bytes32 indexed node, bytes4 indexed interfaceID, address implementer);
265 
266     mapping(bytes32=>mapping(bytes4=>address)) interfaces;
267 
268     /**
269      * Sets an interface associated with a name.
270      * Setting the address to 0 restores the default behaviour of querying the contract at `addr()` for interface support.
271      * @param node The node to update.
272      * @param interfaceID The EIP 168 interface ID.
273      * @param implementer The address of a contract that implements this interface for this node.
274      */
275     function setInterface(bytes32 node, bytes4 interfaceID, address implementer) external authorised(node) {
276         interfaces[node][interfaceID] = implementer;
277         emit InterfaceChanged(node, interfaceID, implementer);
278     }
279 
280     /**
281      * Returns the address of a contract that implements the specified interface for this name.
282      * If an implementer has not been set for this interfaceID and name, the resolver will query
283      * the contract at `addr()`. If `addr()` is set, a contract exists at that address, and that
284      * contract implements EIP168 and returns `true` for the specified interfaceID, its address
285      * will be returned.
286      * @param node The ENS node to query.
287      * @param interfaceID The EIP 168 interface ID to check for.
288      * @return The address that implements this interface, or 0 if the interface is unsupported.
289      */
290     function interfaceImplementer(bytes32 node, bytes4 interfaceID) external view returns (address) {
291         address implementer = interfaces[node][interfaceID];
292         if(implementer != address(0)) {
293             return implementer;
294         }
295 
296         address a = addr(node);
297         if(a == address(0)) {
298             return address(0);
299         }
300 
301         (bool success, bytes memory returnData) = a.staticcall(abi.encodeWithSignature("supportsInterface(bytes4)", INTERFACE_META_ID));
302         if(!success || returnData.length < 32 || returnData[31] == 0) {
303             // EIP 168 not supported by target
304             return address(0);
305         }
306 
307         (success, returnData) = a.staticcall(abi.encodeWithSignature("supportsInterface(bytes4)", interfaceID));
308         if(!success || returnData.length < 32 || returnData[31] == 0) {
309             // Specified interface not supported by target
310             return address(0);
311         }
312 
313         return a;
314     }
315 
316     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
317         return interfaceID == INTERFACE_INTERFACE_ID || super.supportsInterface(interfaceID);
318     }
319 }
320 
321 // File: @ensdomains/resolver/contracts/profiles/NameResolver.sol
322 
323 pragma solidity ^0.5.0;
324 
325 
326 contract NameResolver is ResolverBase {
327     bytes4 constant private NAME_INTERFACE_ID = 0x691f3431;
328 
329     event NameChanged(bytes32 indexed node, string name);
330 
331     mapping(bytes32=>string) names;
332 
333     /**
334      * Sets the name associated with an ENS node, for reverse records.
335      * May only be called by the owner of that node in the ENS registry.
336      * @param node The node to update.
337      * @param name The name to set.
338      */
339     function setName(bytes32 node, string calldata name) external authorised(node) {
340         names[node] = name;
341         emit NameChanged(node, name);
342     }
343 
344     /**
345      * Returns the name associated with an ENS node, for reverse records.
346      * Defined in EIP181.
347      * @param node The ENS node to query.
348      * @return The associated name.
349      */
350     function name(bytes32 node) external view returns (string memory) {
351         return names[node];
352     }
353 
354     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
355         return interfaceID == NAME_INTERFACE_ID || super.supportsInterface(interfaceID);
356     }
357 }
358 
359 // File: @ensdomains/resolver/contracts/profiles/PubkeyResolver.sol
360 
361 pragma solidity ^0.5.0;
362 
363 
364 contract PubkeyResolver is ResolverBase {
365     bytes4 constant private PUBKEY_INTERFACE_ID = 0xc8690233;
366 
367     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
368 
369     struct PublicKey {
370         bytes32 x;
371         bytes32 y;
372     }
373 
374     mapping(bytes32=>PublicKey) pubkeys;
375 
376     /**
377      * Sets the SECP256k1 public key associated with an ENS node.
378      * @param node The ENS node to query
379      * @param x the X coordinate of the curve point for the public key.
380      * @param y the Y coordinate of the curve point for the public key.
381      */
382     function setPubkey(bytes32 node, bytes32 x, bytes32 y) external authorised(node) {
383         pubkeys[node] = PublicKey(x, y);
384         emit PubkeyChanged(node, x, y);
385     }
386 
387     /**
388      * Returns the SECP256k1 public key associated with an ENS node.
389      * Defined in EIP 619.
390      * @param node The ENS node to query
391      * @return x, y the X and Y coordinates of the curve point for the public key.
392      */
393     function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y) {
394         return (pubkeys[node].x, pubkeys[node].y);
395     }
396 
397     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
398         return interfaceID == PUBKEY_INTERFACE_ID || super.supportsInterface(interfaceID);
399     }
400 }
401 
402 // File: @ensdomains/resolver/contracts/profiles/TextResolver.sol
403 
404 pragma solidity ^0.5.0;
405 
406 
407 contract TextResolver is ResolverBase {
408     bytes4 constant private TEXT_INTERFACE_ID = 0x59d1d43c;
409 
410     event TextChanged(bytes32 indexed node, string indexedKey, string key);
411 
412     mapping(bytes32=>mapping(string=>string)) texts;
413 
414     /**
415      * Sets the text data associated with an ENS node and key.
416      * May only be called by the owner of that node in the ENS registry.
417      * @param node The node to update.
418      * @param key The key to set.
419      * @param value The text data value to set.
420      */
421     function setText(bytes32 node, string calldata key, string calldata value) external authorised(node) {
422         texts[node][key] = value;
423         emit TextChanged(node, key, key);
424     }
425 
426     /**
427      * Returns the text data associated with an ENS node and key.
428      * @param node The ENS node to query.
429      * @param key The text data key to query.
430      * @return The associated text data.
431      */
432     function text(bytes32 node, string calldata key) external view returns (string memory) {
433         return texts[node][key];
434     }
435 
436     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
437         return interfaceID == TEXT_INTERFACE_ID || super.supportsInterface(interfaceID);
438     }
439 }
440 
441 // File: @ensdomains/resolver/contracts/PublicResolver.sol
442 
443 pragma solidity ^0.5.0;
444 
445 
446 
447 
448 
449 
450 
451 
452 
453 /**
454  * A simple resolver anyone can use; only allows the owner of a node to set its
455  * address.
456  */
457 contract PublicResolver is ABIResolver, AddrResolver, ContentHashResolver, InterfaceResolver, NameResolver, PubkeyResolver, TextResolver {
458     ENS ens;
459 
460     /**
461      * A mapping of authorisations. An address that is authorised for a name
462      * may make any changes to the name that the owner could, but may not update
463      * the set of authorisations.
464      * (node, owner, caller) => isAuthorised
465      */
466     mapping(bytes32=>mapping(address=>mapping(address=>bool))) public authorisations;
467 
468     event AuthorisationChanged(bytes32 indexed node, address indexed owner, address indexed target, bool isAuthorised);
469 
470     constructor(ENS _ens) public {
471         ens = _ens;
472     }
473 
474     /**
475      * @dev Sets or clears an authorisation.
476      * Authorisations are specific to the caller. Any account can set an authorisation
477      * for any name, but the authorisation that is checked will be that of the
478      * current owner of a name. Thus, transferring a name effectively clears any
479      * existing authorisations, and new authorisations can be set in advance of
480      * an ownership transfer if desired.
481      *
482      * @param node The name to change the authorisation on.
483      * @param target The address that is to be authorised or deauthorised.
484      * @param isAuthorised True if the address should be authorised, or false if it should be deauthorised.
485      */
486     function setAuthorisation(bytes32 node, address target, bool isAuthorised) external {
487         authorisations[node][msg.sender][target] = isAuthorised;
488         emit AuthorisationChanged(node, msg.sender, target, isAuthorised);
489     }
490 
491     function isAuthorised(bytes32 node) internal view returns(bool) {
492         address owner = ens.owner(node);
493         return owner == msg.sender || authorisations[node][owner][msg.sender];
494     }
495 }
496 
497 // File: contracts/Strings.sol
498 
499 pragma solidity ^0.5.2;
500 
501 library Strings {
502   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
503   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
504     bytes memory _ba = bytes(_a);
505     bytes memory _bb = bytes(_b);
506     bytes memory _bc = bytes(_c);
507     bytes memory _bd = bytes(_d);
508     bytes memory _be = bytes(_e);
509     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
510     bytes memory babcde = bytes(abcde);
511     uint k = 0;
512     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
513     for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
514     for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
515     for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
516     for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
517     return string(babcde);
518   }
519 
520   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
521     return strConcat(_a, _b, _c, _d, "");
522   }
523 
524   function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
525     return strConcat(_a, _b, _c, "", "");
526   }
527 
528   function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
529     return strConcat(_a, _b, "", "", "");
530   }
531 
532   function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
533     if (_i == 0) {
534       return "0";
535     }
536     uint j = _i;
537     uint len;
538     while (j != 0) {
539       len++;
540       j /= 10;
541     }
542     bytes memory bstr = new bytes(len);
543     uint k = len - 1;
544     while (_i != 0) {
545       bstr[k--] = byte(uint8(48 + _i % 10));
546       _i /= 10;
547     }
548     return string(bstr);
549   }
550 
551   function fromAddress(address addr) internal pure returns(string memory) {
552     bytes20 addrBytes = bytes20(addr);
553     bytes16 hexAlphabet = "0123456789abcdef";
554     bytes memory result = new bytes(42);
555     result[0] = '0';
556     result[1] = 'x';
557     for (uint i = 0; i < 20; i++) {
558       result[i * 2 + 2] = hexAlphabet[uint8(addrBytes[i] >> 4)];
559       result[i * 2 + 3] = hexAlphabet[uint8(addrBytes[i] & 0x0f)];
560     }
561     return string(result);
562   }
563 }
564 
565 // File: contracts/OpenSeaENSResolver.sol
566 
567 pragma solidity ^0.5.2;
568 
569 
570 
571 
572 /**
573  * @title OpenSea ENS Resolver
574  * OpenSea ENS Resolver - A resolver for linking ENS domains to OpenSea listings.
575  */
576 contract OpenSeaENSResolver is Ownable, PublicResolver {
577   bytes32 private ETH_NAMEHASH = subNamehash(0, keccak256("eth"));
578   bytes32 private constant URL_KEYHASH = keccak256("url");
579   string private _baseURI = "https://opensea.io/assets/0xfac7bea255a6990f749363002136af6556b31e04/";
580   mapping(bytes32 => uint256) private tokenIds;
581 
582   function subNamehash(bytes32 base, bytes32 label) internal pure returns (bytes32) {
583     return keccak256(abi.encode(base, label));
584   }
585 
586   constructor(ENS _ens) PublicResolver(_ens) public {}
587 
588   function baseURI() public view returns (string memory) {
589     return _baseURI;
590   }
591 
592   function setBaseURI(string memory uri) public onlyOwner {
593     _baseURI = uri;
594   }
595 
596   function addTokenId(uint256 tokenId) external {
597     tokenIds[subNamehash(ETH_NAMEHASH, bytes32(tokenId))] = tokenId;
598   }
599 
600   function getTokenId(bytes32 node) external view returns (uint256) {
601     return tokenIds[node];
602   }
603 
604   function openSeaVersion() public pure returns (string memory) {
605     return "1.0.0";
606   }
607 
608   function text(bytes32 node, string calldata key) external view returns (string memory) {
609     if (keccak256(bytes(key)) == URL_KEYHASH && tokenIds[node] != 0) {
610       return Strings.strConcat(_baseURI, Strings.uint2str(tokenIds[node]));
611     }
612     return texts[node][key];
613   }
614 }