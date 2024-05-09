1 // File: @ensdomains/ethregistrar/contracts/PriceOracle.sol
2 pragma solidity >=0.4.24;
3 
4 interface PriceOracle {
5     /**
6      * @dev Returns the price to register or renew a name.
7      * @param name The name being registered or renewed.
8      * @param expires When the name presently expires (0 if this is a new registration).
9      * @param duration How long the name is being registered or extended for, in seconds.
10      * @return The price of this renewal or registration, in wei.
11      */
12     function price(string calldata name, uint expires, uint duration) external view returns(uint);
13 }
14 
15 // File: @ensdomains/ens/contracts/ENS.sol
16 
17 pragma solidity >=0.4.24;
18 
19 interface ENS {
20 
21     // Logged when the owner of a node assigns a new owner to a subnode.
22     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
23 
24     // Logged when the owner of a node transfers ownership to a new account.
25     event Transfer(bytes32 indexed node, address owner);
26 
27     // Logged when the resolver for a node changes.
28     event NewResolver(bytes32 indexed node, address resolver);
29 
30     // Logged when the TTL of a node changes
31     event NewTTL(bytes32 indexed node, uint64 ttl);
32 
33     // Logged when an operator is added or removed.
34     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
35 
36     function setRecord(bytes32 node, address owner, address resolver, uint64 ttl) external;
37     function setSubnodeRecord(bytes32 node, bytes32 label, address owner, address resolver, uint64 ttl) external;
38     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns(bytes32);
39     function setResolver(bytes32 node, address resolver) external;
40     function setOwner(bytes32 node, address owner) external;
41     function setTTL(bytes32 node, uint64 ttl) external;
42     function setApprovalForAll(address operator, bool approved) external;
43     function owner(bytes32 node) external view returns (address);
44     function resolver(bytes32 node) external view returns (address);
45     function ttl(bytes32 node) external view returns (uint64);
46     function recordExists(bytes32 node) external view returns (bool);
47     function isApprovedForAll(address owner, address operator) external view returns (bool);
48 }
49 
50 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
51 
52 pragma solidity ^0.5.0;
53 
54 /**
55  * @title IERC165
56  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
57  */
58 interface IERC165 {
59     /**
60      * @notice Query if a contract implements an interface
61      * @param interfaceId The interface identifier, as specified in ERC-165
62      * @dev Interface identification is specified in ERC-165. This function
63      * uses less than 30,000 gas.
64      */
65     function supportsInterface(bytes4 interfaceId) external view returns (bool);
66 }
67 
68 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
69 
70 pragma solidity ^0.5.0;
71 
72 
73 /**
74  * @title ERC721 Non-Fungible Token Standard basic interface
75  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
76  */
77 contract IERC721 is IERC165 {
78     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
79     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
80     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
81 
82     function balanceOf(address owner) public view returns (uint256 balance);
83     function ownerOf(uint256 tokenId) public view returns (address owner);
84 
85     function approve(address to, uint256 tokenId) public;
86     function getApproved(uint256 tokenId) public view returns (address operator);
87 
88     function setApprovalForAll(address operator, bool _approved) public;
89     function isApprovedForAll(address owner, address operator) public view returns (bool);
90 
91     function transferFrom(address from, address to, uint256 tokenId) public;
92     function safeTransferFrom(address from, address to, uint256 tokenId) public;
93 
94     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
95 }
96 
97 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
98 
99 pragma solidity ^0.5.0;
100 
101 /**
102  * @title Ownable
103  * @dev The Ownable contract has an owner address, and provides basic authorization control
104  * functions, this simplifies the implementation of "user permissions".
105  */
106 contract Ownable {
107     address private _owner;
108 
109     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111     /**
112      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
113      * account.
114      */
115     constructor () internal {
116         _owner = msg.sender;
117         emit OwnershipTransferred(address(0), _owner);
118     }
119 
120     /**
121      * @return the address of the owner.
122      */
123     function owner() public view returns (address) {
124         return _owner;
125     }
126 
127     /**
128      * @dev Throws if called by any account other than the owner.
129      */
130     modifier onlyOwner() {
131         require(isOwner());
132         _;
133     }
134 
135     /**
136      * @return true if `msg.sender` is the owner of the contract.
137      */
138     function isOwner() public view returns (bool) {
139         return msg.sender == _owner;
140     }
141 
142     /**
143      * @dev Allows the current owner to relinquish control of the contract.
144      * @notice Renouncing to ownership will leave the contract without an owner.
145      * It will not be possible to call the functions with the `onlyOwner`
146      * modifier anymore.
147      */
148     function renounceOwnership() public onlyOwner {
149         emit OwnershipTransferred(_owner, address(0));
150         _owner = address(0);
151     }
152 
153     /**
154      * @dev Allows the current owner to transfer control of the contract to a newOwner.
155      * @param newOwner The address to transfer ownership to.
156      */
157     function transferOwnership(address newOwner) public onlyOwner {
158         _transferOwnership(newOwner);
159     }
160 
161     /**
162      * @dev Transfers control of the contract to a newOwner.
163      * @param newOwner The address to transfer ownership to.
164      */
165     function _transferOwnership(address newOwner) internal {
166         require(newOwner != address(0));
167         emit OwnershipTransferred(_owner, newOwner);
168         _owner = newOwner;
169     }
170 }
171 
172 // File: @ensdomains/ethregistrar/contracts/BaseRegistrar.sol
173 
174 pragma solidity >=0.4.24;
175 
176 
177 
178 
179 contract BaseRegistrar is IERC721, Ownable {
180     uint constant public GRACE_PERIOD = 90 days;
181 
182     event ControllerAdded(address indexed controller);
183     event ControllerRemoved(address indexed controller);
184     event NameMigrated(uint256 indexed id, address indexed owner, uint expires);
185     event NameRegistered(uint256 indexed id, address indexed owner, uint expires);
186     event NameRenewed(uint256 indexed id, uint expires);
187 
188     // The ENS registry
189     ENS public ens;
190 
191     // The namehash of the TLD this registrar owns (eg, .eth)
192     bytes32 public baseNode;
193 
194     // A map of addresses that are authorised to register and renew names.
195     mapping(address=>bool) public controllers;
196 
197     // Authorises a controller, who can register and renew domains.
198     function addController(address controller) external;
199 
200     // Revoke controller permission for an address.
201     function removeController(address controller) external;
202 
203     // Set the resolver for the TLD this registrar manages.
204     function setResolver(address resolver) external;
205 
206     // Returns the expiration timestamp of the specified label hash.
207     function nameExpires(uint256 id) external view returns(uint);
208 
209     // Returns true iff the specified name is available for registration.
210     function available(uint256 id) public view returns(bool);
211 
212     /**
213      * @dev Register a name.
214      */
215     function register(uint256 id, address owner, uint duration) external returns(uint);
216 
217     function renew(uint256 id, uint duration) external returns(uint);
218 
219     /**
220      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
221      */
222     function reclaim(uint256 id, address owner) external;
223 }
224 
225 // File: @ensdomains/ethregistrar/contracts/StringUtils.sol
226 
227 pragma solidity >=0.4.24;
228 
229 library StringUtils {
230     /**
231      * @dev Returns the length of a given string
232      *
233      * @param s The string to measure the length of
234      * @return The length of the input string
235      */
236     function strlen(string memory s) internal pure returns (uint) {
237         uint len;
238         uint i = 0;
239         uint bytelength = bytes(s).length;
240         for(len = 0; i < bytelength; len++) {
241             byte b = bytes(s)[i];
242             if(b < 0x80) {
243                 i += 1;
244             } else if (b < 0xE0) {
245                 i += 2;
246             } else if (b < 0xF0) {
247                 i += 3;
248             } else if (b < 0xF8) {
249                 i += 4;
250             } else if (b < 0xFC) {
251                 i += 5;
252             } else {
253                 i += 6;
254             }
255         }
256         return len;
257     }
258 }
259 
260 // File: @ensdomains/resolver/contracts/Resolver.sol
261 
262 pragma solidity >=0.4.25;
263 
264 /**
265  * A generic resolver interface which includes all the functions including the ones deprecated
266  */
267 interface Resolver{
268     event AddrChanged(bytes32 indexed node, address a);
269     event AddressChanged(bytes32 indexed node, uint coinType, bytes newAddress);
270     event NameChanged(bytes32 indexed node, string name);
271     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
272     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
273     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
274     event ContenthashChanged(bytes32 indexed node, bytes hash);
275     /* Deprecated events */
276     event ContentChanged(bytes32 indexed node, bytes32 hash);
277 
278     function ABI(bytes32 node, uint256 contentTypes) external view returns (uint256, bytes memory);
279     function addr(bytes32 node) external view returns (address);
280     function addr(bytes32 node, uint coinType) external view returns(bytes memory);
281     function contenthash(bytes32 node) external view returns (bytes memory);
282     function dnsrr(bytes32 node) external view returns (bytes memory);
283     function name(bytes32 node) external view returns (string memory);
284     function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y);
285     function text(bytes32 node, string calldata key) external view returns (string memory);
286     function interfaceImplementer(bytes32 node, bytes4 interfaceID) external view returns (address);
287 
288     function setABI(bytes32 node, uint256 contentType, bytes calldata data) external;
289     function setAddr(bytes32 node, address addr) external;
290     function setAddr(bytes32 node, uint coinType, bytes calldata a) external;
291     function setContenthash(bytes32 node, bytes calldata hash) external;
292     function setDnsrr(bytes32 node, bytes calldata data) external;
293     function setName(bytes32 node, string calldata _name) external;
294     function setPubkey(bytes32 node, bytes32 x, bytes32 y) external;
295     function setText(bytes32 node, string calldata key, string calldata value) external;
296     function setInterface(bytes32 node, bytes4 interfaceID, address implementer) external;
297 
298     function supportsInterface(bytes4 interfaceID) external pure returns (bool);
299 
300     /* Deprecated functions */
301     function content(bytes32 node) external view returns (bytes32);
302     function multihash(bytes32 node) external view returns (bytes memory);
303     function setContent(bytes32 node, bytes32 hash) external;
304     function setMultihash(bytes32 node, bytes calldata hash) external;
305 }
306 
307 // File: @ensdomains/ethregistrar/contracts/ETHRegistrarController.sol
308 
309 pragma solidity ^0.5.0;
310 pragma experimental ABIEncoderV2;
311 
312 
313 interface IWhitelist {
314   function pass(address whiteAddress) external view returns(bool);
315 }
316 
317 
318 interface IReStorage {
319   function contain(bytes32 _name) external view returns(bool);
320 }
321 
322 /**
323  * @dev A registrar controller for registering and renewing names at fixed cost.
324  */
325 contract ETHRegistrarController is Ownable {
326     using StringUtils for *;
327 
328     bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));
329     bytes4 constant private COMMITMENT_CONTROLLER_ID = bytes4(
330         keccak256("rentPrice(string,uint256)") ^
331         keccak256("available(string)") ^
332         keccak256("makeCommitment(string,address,bytes32)") ^
333         keccak256("commit(bytes32)") ^
334         keccak256("register(string,address,uint256,bytes32)") ^
335         keccak256("renew(string,uint256)")
336     );
337 
338     bytes4 constant private COMMITMENT_WITH_CONFIG_CONTROLLER_ID = bytes4(
339         keccak256("registerWithConfig(string,address,uint256,bytes32,address,address)") ^
340         keccak256("makeCommitmentWithConfig(string,address,bytes32,address,address)")
341     );
342 
343     uint public minRegistrationDuration = 36135 days;
344     BaseRegistrar base;
345     PriceOracle prices;
346     uint public minCommitmentAge;
347     uint public maxCommitmentAge;
348 
349     mapping(bytes32=>uint) public commitments;
350     mapping(address=>uint) public mintCount;
351 
352     uint256 public mintFreeCount;
353     uint256 public minLen;
354     IWhitelist public white;
355     IReStorage public reStorage;
356 
357     event NameRegistered(string name, bytes32 indexed label, address indexed owner, uint cost, uint expires);
358     event NameRenewed(string name, bytes32 indexed label, uint cost, uint expires);
359     event NewPriceOracle(address indexed oracle);
360 
361     constructor(BaseRegistrar _base, PriceOracle _prices, uint _minCommitmentAge, uint _maxCommitmentAge, IWhitelist _white, IReStorage _reStorage, uint256 _minLen, uint256 _mintFreeCount) public {
362         require(_maxCommitmentAge > _minCommitmentAge);
363         minLen = _minLen;
364         base = _base;
365         prices = _prices;
366         minCommitmentAge = _minCommitmentAge;
367         maxCommitmentAge = _maxCommitmentAge;
368         white =_white;
369         mintFreeCount = _mintFreeCount;
370         reStorage = _reStorage;
371     }
372 
373     function rentPrice(string memory name, uint duration) view public returns(uint) {
374         bytes32 hash = keccak256(bytes(name));
375         return prices.price(name, base.nameExpires(uint256(hash)), duration);
376     }
377 
378     function rentPrice(address _addr, string memory name,  uint duration) view public returns(uint) {
379         if(mintCount[_addr] < mintFreeCount)
380             return 0;
381         if(owner() == _addr)
382             return 0;
383         bytes32 hash = keccak256(bytes(name));
384         return prices.price(name, base.nameExpires(uint256(hash)), duration);
385     }
386 
387     function valid(string memory name) public view returns(bool) {
388         return name.strlen() >= minLen;
389     }
390 
391     function available(address _addr, string memory name) public view returns(uint) {
392         bytes32 label = keccak256(bytes(name));
393         bool isOk = base.available(uint256(label));
394         if(owner() == _addr && isOk)
395             return 0;
396         if(!isOk)
397             return 2;
398         if(!valid(name))
399             return 1;
400         if(reStorage.contain(label))
401             return 3;
402         
403         if(!white.pass(_addr))
404             return 4;
405         return 0;
406     }
407 
408     function available(string memory name) public view returns(uint) {
409         bytes32 label = keccak256(bytes(name));
410         if(!base.available(uint256(label)))
411             return 2;
412         if(!valid(name))
413             return 1;
414         if(reStorage.contain(label))
415             return 3;
416         return 0;
417     }
418 
419     function makeCommitment(string memory name, address owner, bytes32 secret) pure public returns(bytes32) {
420         return makeCommitmentWithConfig(name, owner, secret, address(0), address(0));
421     }
422 
423     function makeCommitmentWithConfig(string memory name, address owner, bytes32 secret, address resolver, address addr) pure public returns(bytes32) {
424         bytes32 label = keccak256(bytes(name));
425         if (resolver == address(0) && addr == address(0)) {
426             return keccak256(abi.encodePacked(label, owner, secret));
427         }
428         require(resolver != address(0));
429         return keccak256(abi.encodePacked(label, owner, resolver, addr, secret));
430     }
431 
432     function commit(bytes32 commitment) public {
433         require(commitments[commitment] + maxCommitmentAge < now);
434         commitments[commitment] = now;
435     }
436 
437     function register(string calldata name, address owner, uint duration, bytes32 secret) external payable {
438       registerWithConfig(name, owner, duration, secret, address(0), address(0));
439     }
440 
441     function registerWithConfig(string memory name, address owner, uint duration, bytes32 secret, address resolver, address addr) public payable {
442         bytes32 commitment = makeCommitmentWithConfig(name, owner, secret, resolver, addr);
443         uint cost = _consumeCommitment(name, duration, commitment);
444 
445         bytes32 label = keccak256(bytes(name));
446         uint256 tokenId = uint256(label);
447 
448         uint expires;
449         if(resolver != address(0)) {
450             // Set this contract as the (temporary) owner, giving it
451             // permission to set up the resolver.
452             expires = base.register(tokenId, address(this), duration);
453 
454             // The nodehash of this label
455             bytes32 nodehash = keccak256(abi.encodePacked(base.baseNode(), label));
456 
457             // Set the resolver
458             base.ens().setResolver(nodehash, resolver);
459 
460             // Configure the resolver
461             if (addr != address(0)) {
462                 Resolver(resolver).setAddr(nodehash, addr);
463             }
464 
465             // Now transfer full ownership to the expeceted owner
466             base.reclaim(tokenId, owner);
467             base.transferFrom(address(this), owner, tokenId);
468         } else {
469             require(addr == address(0));
470             expires = base.register(tokenId, owner, duration);
471         }
472         mintCount[msg.sender] ++;
473         emit NameRegistered(name, label, owner, cost, expires);
474 
475         // Refund any extra payment
476         if(msg.value > cost) {
477             msg.sender.transfer(msg.value - cost);
478         }
479     }
480 
481     function renew(string calldata name, uint duration) external payable {
482         uint cost = rentPrice(msg.sender, name, duration);
483         require(msg.value >= cost);
484 
485         bytes32 label = keccak256(bytes(name));
486         uint expires = base.renew(uint256(label), duration);
487 
488         if(msg.value > cost) {
489             msg.sender.transfer(msg.value - cost);
490         }
491 
492         emit NameRenewed(name, label, cost, expires);
493     }
494 
495     function setPriceOracle(PriceOracle _prices) public onlyOwner {
496         prices = _prices;
497         emit NewPriceOracle(address(prices));
498     }
499 
500     function setCommitmentAges(uint _minCommitmentAge, uint _maxCommitmentAge) public onlyOwner {
501         minCommitmentAge = _minCommitmentAge;
502         maxCommitmentAge = _maxCommitmentAge;
503     }
504 
505     function setMinLen(uint _value) public onlyOwner {
506        minLen = _value;
507     }
508 
509     function setFreeCount(uint _count) public onlyOwner {
510        mintFreeCount = _count;
511     }
512 
513     function setWhite(IWhitelist _white) public onlyOwner {
514        white = _white;
515     }
516     function setStorage(IReStorage _storage) public onlyOwner {
517        reStorage = _storage;
518     }
519     
520     function setMinRegistrationDuration(uint _value) public onlyOwner {
521        minRegistrationDuration = _value;
522     }
523     
524     function withdraw() public onlyOwner {
525         msg.sender.transfer(address(this).balance);
526     }
527 
528     function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
529         return interfaceID == INTERFACE_META_ID ||
530                interfaceID == COMMITMENT_CONTROLLER_ID ||
531                interfaceID == COMMITMENT_WITH_CONFIG_CONTROLLER_ID;
532     }
533 
534     function _consumeCommitment(string memory name, uint duration, bytes32 commitment) internal returns (uint256) {
535         // Require a valid commitment
536         require(commitments[commitment] + minCommitmentAge <= now);
537 
538         // If the commitment is too old, or the name is registered, stop
539         require(commitments[commitment] + maxCommitmentAge > now);
540         require(available(msg.sender, name) == 0);
541 
542         delete(commitments[commitment]);
543 
544         uint cost = rentPrice(msg.sender, name, duration);
545         require(duration >= minRegistrationDuration);
546 
547         require(msg.value >= cost);
548        
549         return cost;
550     }
551     
552     function multicall(bytes[] calldata data) external onlyOwner returns(bytes[] memory results) {
553         results = new bytes[](data.length);
554         for(uint i = 0; i < data.length; i++) {
555             (bool success, bytes memory result) = address(this).delegatecall(data[i]);
556             require(success);
557             results[i] = result;
558         }
559         return results;
560     }
561 
562     function mintFix(address _addr, uint256 _num) external onlyOwner returns(bool result) {
563         mintCount[_addr] =_num;
564         return true;
565     }
566 }