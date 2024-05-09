1 // File: @ensdomains/ethregistrar/contracts/PriceOracle.sol
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
34     // Logged when an operator is added or removed.
35     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
36 
37     function setRecord(bytes32 node, address owner, address resolver, uint64 ttl) external;
38     function setSubnodeRecord(bytes32 node, bytes32 label, address owner, address resolver, uint64 ttl) external;
39     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns(bytes32);
40     function setResolver(bytes32 node, address resolver) external;
41     function setOwner(bytes32 node, address owner) external;
42     function setTTL(bytes32 node, uint64 ttl) external;
43     function setApprovalForAll(address operator, bool approved) external;
44     function owner(bytes32 node) external view returns (address);
45     function resolver(bytes32 node) external view returns (address);
46     function ttl(bytes32 node) external view returns (uint64);
47     function recordExists(bytes32 node) external view returns (bool);
48     function isApprovedForAll(address owner, address operator) external view returns (bool);
49 }
50 
51 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
52 
53 pragma solidity ^0.5.0;
54 
55 /**
56  * @title IERC165
57  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
58  */
59 interface IERC165 {
60     /**
61      * @notice Query if a contract implements an interface
62      * @param interfaceId The interface identifier, as specified in ERC-165
63      * @dev Interface identification is specified in ERC-165. This function
64      * uses less than 30,000 gas.
65      */
66     function supportsInterface(bytes4 interfaceId) external view returns (bool);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
70 
71 pragma solidity ^0.5.0;
72 
73 
74 /**
75  * @title ERC721 Non-Fungible Token Standard basic interface
76  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
77  */
78 contract IERC721 is IERC165 {
79     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
80     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
81     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
82 
83     function balanceOf(address owner) public view returns (uint256 balance);
84     function ownerOf(uint256 tokenId) public view returns (address owner);
85 
86     function approve(address to, uint256 tokenId) public;
87     function getApproved(uint256 tokenId) public view returns (address operator);
88 
89     function setApprovalForAll(address operator, bool _approved) public;
90     function isApprovedForAll(address owner, address operator) public view returns (bool);
91 
92     function transferFrom(address from, address to, uint256 tokenId) public;
93     function safeTransferFrom(address from, address to, uint256 tokenId) public;
94 
95     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
96 }
97 
98 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
99 
100 pragma solidity ^0.5.0;
101 
102 /**
103  * @title Ownable
104  * @dev The Ownable contract has an owner address, and provides basic authorization control
105  * functions, this simplifies the implementation of "user permissions".
106  */
107 contract Ownable {
108     address private _owner;
109 
110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112     /**
113      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
114      * account.
115      */
116     constructor () internal {
117         _owner = msg.sender;
118         emit OwnershipTransferred(address(0), _owner);
119     }
120 
121     /**
122      * @return the address of the owner.
123      */
124     function owner() public view returns (address) {
125         return _owner;
126     }
127 
128     /**
129      * @dev Throws if called by any account other than the owner.
130      */
131     modifier onlyOwner() {
132         require(isOwner());
133         _;
134     }
135 
136     /**
137      * @return true if `msg.sender` is the owner of the contract.
138      */
139     function isOwner() public view returns (bool) {
140         return msg.sender == _owner;
141     }
142 
143     /**
144      * @dev Allows the current owner to relinquish control of the contract.
145      * @notice Renouncing to ownership will leave the contract without an owner.
146      * It will not be possible to call the functions with the `onlyOwner`
147      * modifier anymore.
148      */
149     function renounceOwnership() public onlyOwner {
150         emit OwnershipTransferred(_owner, address(0));
151         _owner = address(0);
152     }
153 
154     /**
155      * @dev Allows the current owner to transfer control of the contract to a newOwner.
156      * @param newOwner The address to transfer ownership to.
157      */
158     function transferOwnership(address newOwner) public onlyOwner {
159         _transferOwnership(newOwner);
160     }
161 
162     /**
163      * @dev Transfers control of the contract to a newOwner.
164      * @param newOwner The address to transfer ownership to.
165      */
166     function _transferOwnership(address newOwner) internal {
167         require(newOwner != address(0));
168         emit OwnershipTransferred(_owner, newOwner);
169         _owner = newOwner;
170     }
171 }
172 
173 // File: @ensdomains/ethregistrar/contracts/BaseRegistrar.sol
174 
175 pragma solidity >=0.4.24;
176 
177 
178 
179 
180 contract BaseRegistrar is IERC721, Ownable {
181     uint constant public GRACE_PERIOD = 90 days;
182 
183     event ControllerAdded(address indexed controller);
184     event ControllerRemoved(address indexed controller);
185     event NameMigrated(uint256 indexed id, address indexed owner, uint expires);
186     event NameRegistered(uint256 indexed id, address indexed owner, uint expires);
187     event NameRenewed(uint256 indexed id, uint expires);
188 
189     // The ENS registry
190     ENS public ens;
191 
192     // The namehash of the TLD this registrar owns (eg, .eth)
193     bytes32 public baseNode;
194 
195     // A map of addresses that are authorised to register and renew names.
196     mapping(address=>bool) public controllers;
197 
198     // Authorises a controller, who can register and renew domains.
199     function addController(address controller) external;
200 
201     // Revoke controller permission for an address.
202     function removeController(address controller) external;
203 
204     // Set the resolver for the TLD this registrar manages.
205     function setResolver(address resolver) external;
206 
207     // Returns the expiration timestamp of the specified label hash.
208     function nameExpires(uint256 id) external view returns(uint);
209 
210     // Returns true iff the specified name is available for registration.
211     function available(uint256 id) public view returns(bool);
212 
213     /**
214      * @dev Register a name.
215      */
216     function register(uint256 id, address owner, uint duration) external returns(uint);
217 
218     function renew(uint256 id, uint duration) external returns(uint);
219 
220     /**
221      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
222      */
223     function reclaim(uint256 id, address owner) external;
224 }
225 
226 // File: @ensdomains/ethregistrar/contracts/StringUtils.sol
227 
228 pragma solidity >=0.4.24;
229 
230 library StringUtils {
231     /**
232      * @dev Returns the length of a given string
233      *
234      * @param s The string to measure the length of
235      * @return The length of the input string
236      */
237     function strlen(string memory s) internal pure returns (uint) {
238         uint len;
239         uint i = 0;
240         uint bytelength = bytes(s).length;
241         for(len = 0; i < bytelength; len++) {
242             byte b = bytes(s)[i];
243             if(b < 0x80) {
244                 i += 1;
245             } else if (b < 0xE0) {
246                 i += 2;
247             } else if (b < 0xF0) {
248                 i += 3;
249             } else if (b < 0xF8) {
250                 i += 4;
251             } else if (b < 0xFC) {
252                 i += 5;
253             } else {
254                 i += 6;
255             }
256         }
257         return len;
258     }
259 }
260 
261 // File: @ensdomains/resolver/contracts/Resolver.sol
262 
263 pragma solidity >=0.4.25;
264 
265 /**
266  * A generic resolver interface which includes all the functions including the ones deprecated
267  */
268 interface Resolver{
269     event AddrChanged(bytes32 indexed node, address a);
270     event AddressChanged(bytes32 indexed node, uint coinType, bytes newAddress);
271     event NameChanged(bytes32 indexed node, string name);
272     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
273     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
274     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
275     event ContenthashChanged(bytes32 indexed node, bytes hash);
276     /* Deprecated events */
277     event ContentChanged(bytes32 indexed node, bytes32 hash);
278 
279     function ABI(bytes32 node, uint256 contentTypes) external view returns (uint256, bytes memory);
280     function addr(bytes32 node) external view returns (address);
281     function addr(bytes32 node, uint coinType) external view returns(bytes memory);
282     function contenthash(bytes32 node) external view returns (bytes memory);
283     function dnsrr(bytes32 node) external view returns (bytes memory);
284     function name(bytes32 node) external view returns (string memory);
285     function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y);
286     function text(bytes32 node, string calldata key) external view returns (string memory);
287     function interfaceImplementer(bytes32 node, bytes4 interfaceID) external view returns (address);
288 
289     function setABI(bytes32 node, uint256 contentType, bytes calldata data) external;
290     function setAddr(bytes32 node, address addr) external;
291     function setAddr(bytes32 node, uint coinType, bytes calldata a) external;
292     function setContenthash(bytes32 node, bytes calldata hash) external;
293     function setDnsrr(bytes32 node, bytes calldata data) external;
294     function setName(bytes32 node, string calldata _name) external;
295     function setPubkey(bytes32 node, bytes32 x, bytes32 y) external;
296     function setText(bytes32 node, string calldata key, string calldata value) external;
297     function setInterface(bytes32 node, bytes4 interfaceID, address implementer) external;
298 
299     function supportsInterface(bytes4 interfaceID) external pure returns (bool);
300 
301     /* Deprecated functions */
302     function content(bytes32 node) external view returns (bytes32);
303     function multihash(bytes32 node) external view returns (bytes memory);
304     function setContent(bytes32 node, bytes32 hash) external;
305     function setMultihash(bytes32 node, bytes calldata hash) external;
306 }
307 
308 // File: @ensdomains/ethregistrar/contracts/ETHRegistrarController.sol
309 
310 pragma solidity ^0.5.0;
311 
312 
313 
314 
315 
316 
317 /**
318  * @dev A registrar controller for registering and renewing names at fixed cost.
319  */
320 contract ETHRegistrarController is Ownable {
321     using StringUtils for *;
322 
323     uint constant public MIN_REGISTRATION_DURATION = 28 days;
324 
325     bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));
326     bytes4 constant private COMMITMENT_CONTROLLER_ID = bytes4(
327         keccak256("rentPrice(string,uint256)") ^
328         keccak256("available(string)") ^
329         keccak256("makeCommitment(string,address,bytes32)") ^
330         keccak256("commit(bytes32)") ^
331         keccak256("register(string,address,uint256,bytes32)") ^
332         keccak256("renew(string,uint256)")
333     );
334 
335     bytes4 constant private COMMITMENT_WITH_CONFIG_CONTROLLER_ID = bytes4(
336         keccak256("registerWithConfig(string,address,uint256,bytes32,address,address)") ^
337         keccak256("makeCommitmentWithConfig(string,address,bytes32,address,address)")
338     );
339 
340     BaseRegistrar base;
341     PriceOracle prices;
342     uint public minCommitmentAge;
343     uint public maxCommitmentAge;
344 
345     mapping(bytes32=>uint) public commitments;
346 
347     event NameRegistered(string name, bytes32 indexed label, address indexed owner, uint cost, uint expires);
348     event NameRenewed(string name, bytes32 indexed label, uint cost, uint expires);
349     event NewPriceOracle(address indexed oracle);
350 
351     constructor(BaseRegistrar _base, PriceOracle _prices, uint _minCommitmentAge, uint _maxCommitmentAge) public {
352         require(_maxCommitmentAge > _minCommitmentAge);
353 
354         base = _base;
355         prices = _prices;
356         minCommitmentAge = _minCommitmentAge;
357         maxCommitmentAge = _maxCommitmentAge;
358     }
359 
360     function rentPrice(string memory name, uint duration) view public returns(uint) {
361         bytes32 hash = keccak256(bytes(name));
362         return prices.price(name, base.nameExpires(uint256(hash)), duration);
363     }
364 
365     function valid(string memory name) public pure returns(bool) {
366         return name.strlen() >= 3;
367     }
368 
369     function available(string memory name) public view returns(bool) {
370         bytes32 label = keccak256(bytes(name));
371         return valid(name) && base.available(uint256(label));
372     }
373 
374     function makeCommitment(string memory name, address owner, bytes32 secret) pure public returns(bytes32) {
375         return makeCommitmentWithConfig(name, owner, secret, address(0), address(0));
376     }
377 
378     function makeCommitmentWithConfig(string memory name, address owner, bytes32 secret, address resolver, address addr) pure public returns(bytes32) {
379         bytes32 label = keccak256(bytes(name));
380         if (resolver == address(0) && addr == address(0)) {
381             return keccak256(abi.encodePacked(label, owner, secret));
382         }
383         require(resolver != address(0));
384         return keccak256(abi.encodePacked(label, owner, resolver, addr, secret));
385     }
386 
387     function commit(bytes32 commitment) public {
388         require(commitments[commitment] + maxCommitmentAge < now);
389         commitments[commitment] = now;
390     }
391 
392     function register(string calldata name, address owner, uint duration, bytes32 secret) external payable {
393       registerWithConfig(name, owner, duration, secret, address(0), address(0));
394     }
395 
396     function registerWithConfig(string memory name, address owner, uint duration, bytes32 secret, address resolver, address addr) public payable {
397         bytes32 commitment = makeCommitmentWithConfig(name, owner, secret, resolver, addr);
398         uint cost = _consumeCommitment(name, duration, commitment);
399 
400         bytes32 label = keccak256(bytes(name));
401         uint256 tokenId = uint256(label);
402 
403         uint expires;
404         if(resolver != address(0)) {
405             // Set this contract as the (temporary) owner, giving it
406             // permission to set up the resolver.
407             expires = base.register(tokenId, address(this), duration);
408 
409             // The nodehash of this label
410             bytes32 nodehash = keccak256(abi.encodePacked(base.baseNode(), label));
411 
412             // Set the resolver
413             base.ens().setResolver(nodehash, resolver);
414 
415             // Configure the resolver
416             if (addr != address(0)) {
417                 Resolver(resolver).setAddr(nodehash, addr);
418             }
419 
420             // Now transfer full ownership to the expeceted owner
421             base.reclaim(tokenId, owner);
422             base.transferFrom(address(this), owner, tokenId);
423         } else {
424             require(addr == address(0));
425             expires = base.register(tokenId, owner, duration);
426         }
427 
428         emit NameRegistered(name, label, owner, cost, expires);
429 
430         // Refund any extra payment
431         if(msg.value > cost) {
432             msg.sender.transfer(msg.value - cost);
433         }
434     }
435 
436     function renew(string calldata name, uint duration) external payable {
437         uint cost = rentPrice(name, duration);
438         require(msg.value >= cost);
439 
440         bytes32 label = keccak256(bytes(name));
441         uint expires = base.renew(uint256(label), duration);
442 
443         if(msg.value > cost) {
444             msg.sender.transfer(msg.value - cost);
445         }
446 
447         emit NameRenewed(name, label, cost, expires);
448     }
449 
450     function setPriceOracle(PriceOracle _prices) public onlyOwner {
451         prices = _prices;
452         emit NewPriceOracle(address(prices));
453     }
454 
455     function setCommitmentAges(uint _minCommitmentAge, uint _maxCommitmentAge) public onlyOwner {
456         minCommitmentAge = _minCommitmentAge;
457         maxCommitmentAge = _maxCommitmentAge;
458     }
459 
460     function withdraw() public onlyOwner {
461         msg.sender.transfer(address(this).balance);
462     }
463 
464     function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
465         return interfaceID == INTERFACE_META_ID ||
466                interfaceID == COMMITMENT_CONTROLLER_ID ||
467                interfaceID == COMMITMENT_WITH_CONFIG_CONTROLLER_ID;
468     }
469 
470     function _consumeCommitment(string memory name, uint duration, bytes32 commitment) internal returns (uint256) {
471         // Require a valid commitment
472         require(commitments[commitment] + minCommitmentAge <= now);
473 
474         // If the commitment is too old, or the name is registered, stop
475         require(commitments[commitment] + maxCommitmentAge > now);
476         require(available(name));
477 
478         delete(commitments[commitment]);
479 
480         uint cost = rentPrice(name, duration);
481         require(duration >= MIN_REGISTRATION_DURATION);
482         require(msg.value >= cost);
483 
484         return cost;
485     }
486 }