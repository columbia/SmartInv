1 // File: contracts/PriceOracle.sol
2 
3 pragma solidity >=0.4.24;
4 
5 interface PriceOracle {
6     /**
7      * @dev Returns the price to register or renew a name.
8      * @param name The name being registered or renewed.
9      * @param expires When the name presently expires (0 if this is a new registration).
10      * @param duration How long the name is being registered or extended for, in seconds.
11      * @return The price of this renewal or registration, in wei.
12      */
13     function price(string calldata name, uint expires, uint duration) external view returns(uint);
14 }
15 
16 // File: @ensdomains/ens/contracts/ENS.sol
17 
18 pragma solidity >=0.4.24;
19 
20 interface ENS {
21 
22     // Logged when the owner of a node assigns a new owner to a subnode.
23     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
24 
25     // Logged when the owner of a node transfers ownership to a new account.
26     event Transfer(bytes32 indexed node, address owner);
27 
28     // Logged when the resolver for a node changes.
29     event NewResolver(bytes32 indexed node, address resolver);
30 
31     // Logged when the TTL of a node changes
32     event NewTTL(bytes32 indexed node, uint64 ttl);
33 
34 
35     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
36     function setResolver(bytes32 node, address resolver) external;
37     function setOwner(bytes32 node, address owner) external;
38     function setTTL(bytes32 node, uint64 ttl) external;
39     function owner(bytes32 node) external view returns (address);
40     function resolver(bytes32 node) external view returns (address);
41     function ttl(bytes32 node) external view returns (uint64);
42 
43 }
44 
45 // File: @ensdomains/ens/contracts/Deed.sol
46 
47 pragma solidity >=0.4.24;
48 
49 interface Deed {
50 
51     function setOwner(address payable newOwner) external;
52     function setRegistrar(address newRegistrar) external;
53     function setBalance(uint newValue, bool throwOnFailure) external;
54     function closeDeed(uint refundRatio) external;
55     function destroyDeed() external;
56 
57     function owner() external view returns (address);
58     function previousOwner() external view returns (address);
59     function value() external view returns (uint);
60     function creationDate() external view returns (uint);
61 
62 }
63 
64 // File: @ensdomains/ens/contracts/Registrar.sol
65 
66 pragma solidity >=0.4.24;
67 
68 
69 interface Registrar {
70 
71     enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }
72 
73     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
74     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
75     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
76     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
77     event HashReleased(bytes32 indexed hash, uint value);
78     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
79 
80     function state(bytes32 _hash) external view returns (Mode);
81     function startAuction(bytes32 _hash) external;
82     function startAuctions(bytes32[] calldata _hashes) external;
83     function newBid(bytes32 sealedBid) external payable;
84     function startAuctionsAndBid(bytes32[] calldata hashes, bytes32 sealedBid) external payable;
85     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) external;
86     function cancelBid(address bidder, bytes32 seal) external;
87     function finalizeAuction(bytes32 _hash) external;
88     function transfer(bytes32 _hash, address payable newOwner) external;
89     function releaseDeed(bytes32 _hash) external;
90     function invalidateName(string calldata unhashedName) external;
91     function eraseNode(bytes32[] calldata labels) external;
92     function transferRegistrars(bytes32 _hash) external;
93     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) external;
94     function entries(bytes32 _hash) external view returns (Mode, address, uint, uint, uint);
95 }
96 
97 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
98 
99 pragma solidity ^0.5.0;
100 
101 /**
102  * @title IERC165
103  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
104  */
105 interface IERC165 {
106     /**
107      * @notice Query if a contract implements an interface
108      * @param interfaceId The interface identifier, as specified in ERC-165
109      * @dev Interface identification is specified in ERC-165. This function
110      * uses less than 30,000 gas.
111      */
112     function supportsInterface(bytes4 interfaceId) external view returns (bool);
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
116 
117 pragma solidity ^0.5.0;
118 
119 
120 /**
121  * @title ERC721 Non-Fungible Token Standard basic interface
122  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
123  */
124 contract IERC721 is IERC165 {
125     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
126     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
127     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
128 
129     function balanceOf(address owner) public view returns (uint256 balance);
130     function ownerOf(uint256 tokenId) public view returns (address owner);
131 
132     function approve(address to, uint256 tokenId) public;
133     function getApproved(uint256 tokenId) public view returns (address operator);
134 
135     function setApprovalForAll(address operator, bool _approved) public;
136     function isApprovedForAll(address owner, address operator) public view returns (bool);
137 
138     function transferFrom(address from, address to, uint256 tokenId) public;
139     function safeTransferFrom(address from, address to, uint256 tokenId) public;
140 
141     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
142 }
143 
144 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
145 
146 pragma solidity ^0.5.0;
147 
148 /**
149  * @title Ownable
150  * @dev The Ownable contract has an owner address, and provides basic authorization control
151  * functions, this simplifies the implementation of "user permissions".
152  */
153 contract Ownable {
154     address private _owner;
155 
156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
157 
158     /**
159      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160      * account.
161      */
162     constructor () internal {
163         _owner = msg.sender;
164         emit OwnershipTransferred(address(0), _owner);
165     }
166 
167     /**
168      * @return the address of the owner.
169      */
170     function owner() public view returns (address) {
171         return _owner;
172     }
173 
174     /**
175      * @dev Throws if called by any account other than the owner.
176      */
177     modifier onlyOwner() {
178         require(isOwner());
179         _;
180     }
181 
182     /**
183      * @return true if `msg.sender` is the owner of the contract.
184      */
185     function isOwner() public view returns (bool) {
186         return msg.sender == _owner;
187     }
188 
189     /**
190      * @dev Allows the current owner to relinquish control of the contract.
191      * @notice Renouncing to ownership will leave the contract without an owner.
192      * It will not be possible to call the functions with the `onlyOwner`
193      * modifier anymore.
194      */
195     function renounceOwnership() public onlyOwner {
196         emit OwnershipTransferred(_owner, address(0));
197         _owner = address(0);
198     }
199 
200     /**
201      * @dev Allows the current owner to transfer control of the contract to a newOwner.
202      * @param newOwner The address to transfer ownership to.
203      */
204     function transferOwnership(address newOwner) public onlyOwner {
205         _transferOwnership(newOwner);
206     }
207 
208     /**
209      * @dev Transfers control of the contract to a newOwner.
210      * @param newOwner The address to transfer ownership to.
211      */
212     function _transferOwnership(address newOwner) internal {
213         require(newOwner != address(0));
214         emit OwnershipTransferred(_owner, newOwner);
215         _owner = newOwner;
216     }
217 }
218 
219 // File: contracts/BaseRegistrar.sol
220 
221 pragma solidity >=0.4.24;
222 
223 
224 
225 
226 
227 contract BaseRegistrar is IERC721, Ownable {
228     uint constant public GRACE_PERIOD = 90 days;
229 
230     event ControllerAdded(address indexed controller);
231     event ControllerRemoved(address indexed controller);
232     event NameMigrated(uint256 indexed id, address indexed owner, uint expires);
233     event NameRegistered(uint256 indexed id, address indexed owner, uint expires);
234     event NameRenewed(uint256 indexed id, uint expires);
235 
236     // Expiration timestamp for migrated domains.
237     uint public transferPeriodEnds;
238 
239     // The ENS registry
240     ENS public ens;
241 
242     // The namehash of the TLD this registrar owns (eg, .eth)
243     bytes32 public baseNode;
244 
245     // The interim registrar
246     Registrar public previousRegistrar;
247 
248     // A map of addresses that are authorised to register and renew names.
249     mapping(address=>bool) public controllers;
250 
251     // Authorises a controller, who can register and renew domains.
252     function addController(address controller) external;
253 
254     // Revoke controller permission for an address.
255     function removeController(address controller) external;
256 
257     // Set the resolver for the TLD this registrar manages.
258     function setResolver(address resolver) external;
259 
260     // Returns the expiration timestamp of the specified label hash.
261     function nameExpires(uint256 id) external view returns(uint);
262 
263     // Returns true iff the specified name is available for registration.
264     function available(uint256 id) public view returns(bool);
265 
266     /**
267      * @dev Register a name.
268      */
269     function register(uint256 id, address owner, uint duration) external returns(uint);
270 
271     function renew(uint256 id, uint duration) external returns(uint);
272 
273     /**
274      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
275      */
276     function reclaim(uint256 id, address owner) external;
277 
278     /**
279      * @dev Transfers a registration from the initial registrar.
280      * This function is called by the initial registrar when a user calls `transferRegistrars`.
281      */
282     function acceptRegistrarTransfer(bytes32 label, Deed deed, uint) external;
283 }
284 
285 // File: contracts/StringUtils.sol
286 
287 pragma solidity >=0.4.24;
288 
289 library StringUtils {
290     /**
291      * @dev Returns the length of a given string
292      *
293      * @param s The string to measure the length of
294      * @return The length of the input string
295      */
296     function strlen(string memory s) internal pure returns (uint) {
297         uint len;
298         uint i = 0;
299         uint bytelength = bytes(s).length;
300         for(len = 0; i < bytelength; len++) {
301             byte b = bytes(s)[i];
302             if(b < 0x80) {
303                 i += 1;
304             } else if (b < 0xE0) {
305                 i += 2;
306             } else if (b < 0xF0) {
307                 i += 3;
308             } else if (b < 0xF8) {
309                 i += 4;
310             } else if (b < 0xFC) {
311                 i += 5;
312             } else {
313                 i += 6;
314             }
315         }
316         return len;
317     }
318 }
319 
320 // File: @ensdomains/resolver/contracts/Resolver.sol
321 
322 pragma solidity >=0.4.25;
323 
324 /**
325  * A generic resolver interface which includes all the functions including the ones deprecated
326  */
327 interface Resolver{
328     event AddrChanged(bytes32 indexed node, address a);
329     event AddressChanged(bytes32 indexed node, uint coinType, bytes newAddress);
330     event NameChanged(bytes32 indexed node, string name);
331     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
332     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
333     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
334     event ContenthashChanged(bytes32 indexed node, bytes hash);
335     /* Deprecated events */
336     event ContentChanged(bytes32 indexed node, bytes32 hash);
337 
338     function ABI(bytes32 node, uint256 contentTypes) external view returns (uint256, bytes memory);
339     function addr(bytes32 node) external view returns (address);
340     function addr(bytes32 node, uint coinType) external view returns(bytes memory);
341     function contenthash(bytes32 node) external view returns (bytes memory);
342     function dnsrr(bytes32 node) external view returns (bytes memory);
343     function name(bytes32 node) external view returns (string memory);
344     function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y);
345     function text(bytes32 node, string calldata key) external view returns (string memory);
346     function interfaceImplementer(bytes32 node, bytes4 interfaceID) external view returns (address);
347 
348     function setABI(bytes32 node, uint256 contentType, bytes calldata data) external;
349     function setAddr(bytes32 node, address addr) external;
350     function setAddr(bytes32 node, uint coinType, bytes calldata a) external;
351     function setContenthash(bytes32 node, bytes calldata hash) external;
352     function setDnsrr(bytes32 node, bytes calldata data) external;
353     function setName(bytes32 node, string calldata _name) external;
354     function setPubkey(bytes32 node, bytes32 x, bytes32 y) external;
355     function setText(bytes32 node, string calldata key, string calldata value) external;
356     function setInterface(bytes32 node, bytes4 interfaceID, address implementer) external;
357 
358     function supportsInterface(bytes4 interfaceID) external pure returns (bool);
359 
360     /* Deprecated functions */
361     function content(bytes32 node) external view returns (bytes32);
362     function multihash(bytes32 node) external view returns (bytes memory);
363     function setContent(bytes32 node, bytes32 hash) external;
364     function setMultihash(bytes32 node, bytes calldata hash) external;
365 }
366 
367 // File: contracts/ETHRegistrarController.sol
368 
369 pragma solidity ^0.5.0;
370 
371 
372 
373 
374 
375 
376 /**
377  * @dev A registrar controller for registering and renewing names at fixed cost.
378  */
379 contract ETHRegistrarController is Ownable {
380     using StringUtils for *;
381 
382     uint constant public MIN_REGISTRATION_DURATION = 28 days;
383 
384     bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));
385     bytes4 constant private COMMITMENT_CONTROLLER_ID = bytes4(
386         keccak256("rentPrice(string,uint256)") ^
387         keccak256("available(string)") ^
388         keccak256("makeCommitment(string,address,bytes32)") ^
389         keccak256("commit(bytes32)") ^
390         keccak256("register(string,address,uint256,bytes32)") ^
391         keccak256("renew(string,uint256)")
392     );
393 
394     bytes4 constant private COMMITMENT_WITH_CONFIG_CONTROLLER_ID = bytes4(
395         keccak256("registerWithConfig(string,address,uint256,bytes32,address,address)") ^
396         keccak256("makeCommitmentWithConfig(string,address,bytes32,address,address)")
397     );
398 
399     BaseRegistrar base;
400     PriceOracle prices;
401     uint public minCommitmentAge;
402     uint public maxCommitmentAge;
403 
404     mapping(bytes32=>uint) public commitments;
405 
406     event NameRegistered(string name, bytes32 indexed label, address indexed owner, uint cost, uint expires);
407     event NameRenewed(string name, bytes32 indexed label, uint cost, uint expires);
408     event NewPriceOracle(address indexed oracle);
409 
410     constructor(BaseRegistrar _base, PriceOracle _prices, uint _minCommitmentAge, uint _maxCommitmentAge) public {
411         require(_maxCommitmentAge > _minCommitmentAge);
412 
413         base = _base;
414         prices = _prices;
415         minCommitmentAge = _minCommitmentAge;
416         maxCommitmentAge = _maxCommitmentAge;
417     }
418 
419     function rentPrice(string memory name, uint duration) view public returns(uint) {
420         bytes32 hash = keccak256(bytes(name));
421         return prices.price(name, base.nameExpires(uint256(hash)), duration);
422     }
423 
424     function valid(string memory name) public pure returns(bool) {
425         return name.strlen() >= 3;
426     }
427 
428     function available(string memory name) public view returns(bool) {
429         bytes32 label = keccak256(bytes(name));
430         return valid(name) && base.available(uint256(label));
431     }
432 
433     function makeCommitment(string memory name, address owner, bytes32 secret) pure public returns(bytes32) {
434         return makeCommitmentWithConfig(name, owner, secret, address(0), address(0));
435     }
436 
437     function makeCommitmentWithConfig(string memory name, address owner, bytes32 secret, address resolver, address addr) pure public returns(bytes32) {
438         bytes32 label = keccak256(bytes(name));
439         if (resolver == address(0) && addr == address(0)) {
440             return keccak256(abi.encodePacked(label, owner, secret));
441         }
442         require(resolver != address(0));
443         return keccak256(abi.encodePacked(label, owner, resolver, addr, secret));
444     }
445 
446     function commit(bytes32 commitment) public {
447         require(commitments[commitment] + maxCommitmentAge < now);
448         commitments[commitment] = now;
449     }
450 
451     function register(string calldata name, address owner, uint duration, bytes32 secret) external payable {
452       registerWithConfig(name, owner, duration, secret, address(0), address(0));
453     }
454 
455     function registerWithConfig(string memory name, address owner, uint duration, bytes32 secret, address resolver, address addr) public payable {
456         bytes32 commitment = makeCommitmentWithConfig(name, owner, secret, resolver, addr);
457         uint cost = _consumeCommitment(name, duration, commitment);
458 
459         bytes32 label = keccak256(bytes(name));
460         uint256 tokenId = uint256(label);
461 
462         uint expires;
463         if(resolver != address(0)) {
464             // Set this contract as the (temporary) owner, giving it
465             // permission to set up the resolver.
466             expires = base.register(tokenId, address(this), duration);
467 
468             // The nodehash of this label
469             bytes32 nodehash = keccak256(abi.encodePacked(base.baseNode(), label));
470 
471             // Set the resolver
472             base.ens().setResolver(nodehash, resolver);
473 
474             // Configure the resolver
475             if (addr != address(0)) {
476                 Resolver(resolver).setAddr(nodehash, addr);
477             }
478 
479             // Now transfer full ownership to the expeceted owner
480             base.transferFrom(address(this), owner, tokenId);
481         } else {
482             require(addr == address(0));
483             expires = base.register(tokenId, owner, duration);
484         }
485 
486         emit NameRegistered(name, label, owner, cost, expires);
487 
488         // Refund any extra payment
489         if(msg.value > cost) {
490             msg.sender.transfer(msg.value - cost);
491         }
492     }
493 
494     function renew(string calldata name, uint duration) external payable {
495         uint cost = rentPrice(name, duration);
496         require(msg.value >= cost);
497 
498         bytes32 label = keccak256(bytes(name));
499         uint expires = base.renew(uint256(label), duration);
500 
501         if(msg.value > cost) {
502             msg.sender.transfer(msg.value - cost);
503         }
504 
505         emit NameRenewed(name, label, cost, expires);
506     }
507 
508     function setPriceOracle(PriceOracle _prices) public onlyOwner {
509         prices = _prices;
510         emit NewPriceOracle(address(prices));
511     }
512 
513     function setCommitmentAges(uint _minCommitmentAge, uint _maxCommitmentAge) public onlyOwner {
514         minCommitmentAge = _minCommitmentAge;
515         maxCommitmentAge = _maxCommitmentAge;
516     }
517 
518     function withdraw() public onlyOwner {
519         msg.sender.transfer(address(this).balance);
520     }
521 
522     function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
523         return interfaceID == INTERFACE_META_ID ||
524                interfaceID == COMMITMENT_CONTROLLER_ID ||
525                interfaceID == COMMITMENT_WITH_CONFIG_CONTROLLER_ID;
526     }
527 
528     function _consumeCommitment(string memory name, uint duration, bytes32 commitment) internal returns (uint256) {
529         // Require a valid commitment
530         require(commitments[commitment] + minCommitmentAge <= now);
531 
532         // If the commitment is too old, or the name is registered, stop
533         require(commitments[commitment] + maxCommitmentAge > now);
534         require(available(name));
535 
536         delete(commitments[commitment]);
537 
538         uint cost = rentPrice(name, duration);
539         require(duration >= MIN_REGISTRATION_DURATION);
540         require(msg.value >= cost);
541 
542         return cost;
543     }
544 }