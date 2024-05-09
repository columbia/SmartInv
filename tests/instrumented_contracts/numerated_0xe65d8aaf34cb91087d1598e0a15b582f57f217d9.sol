1 // File: @ensdomains/ens/contracts/ENS.sol
2 
3 pragma solidity >=0.4.24;
4 
5 interface ENS {
6 
7     // Logged when the owner of a node assigns a new owner to a subnode.
8     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
9 
10     // Logged when the owner of a node transfers ownership to a new account.
11     event Transfer(bytes32 indexed node, address owner);
12 
13     // Logged when the resolver for a node changes.
14     event NewResolver(bytes32 indexed node, address resolver);
15 
16     // Logged when the TTL of a node changes
17     event NewTTL(bytes32 indexed node, uint64 ttl);
18 
19     // Logged when an operator is added or removed.
20     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
21 
22     function setRecord(bytes32 node, address owner, address resolver, uint64 ttl) external;
23     function setSubnodeRecord(bytes32 node, bytes32 label, address owner, address resolver, uint64 ttl) external;
24     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns(bytes32);
25     function setResolver(bytes32 node, address resolver) external;
26     function setOwner(bytes32 node, address owner) external;
27     function setTTL(bytes32 node, uint64 ttl) external;
28     function setApprovalForAll(address operator, bool approved) external;
29     function owner(bytes32 node) external view returns (address);
30     function resolver(bytes32 node) external view returns (address);
31     function ttl(bytes32 node) external view returns (uint64);
32     function recordExists(bytes32 node) external view returns (bool);
33     function isApprovedForAll(address owner, address operator) external view returns (bool);
34 }
35 
36 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
37 
38 pragma solidity ^0.5.0;
39 
40 /**
41  * @title IERC165
42  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
43  */
44 interface IERC165 {
45     /**
46      * @notice Query if a contract implements an interface
47      * @param interfaceId The interface identifier, as specified in ERC-165
48      * @dev Interface identification is specified in ERC-165. This function
49      * uses less than 30,000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
55 
56 pragma solidity ^0.5.0;
57 
58 
59 /**
60  * @title ERC721 Non-Fungible Token Standard basic interface
61  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
62  */
63 contract IERC721 is IERC165 {
64     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
65     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
66     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
67 
68     function balanceOf(address owner) public view returns (uint256 balance);
69     function ownerOf(uint256 tokenId) public view returns (address owner);
70 
71     function approve(address to, uint256 tokenId) public;
72     function getApproved(uint256 tokenId) public view returns (address operator);
73 
74     function setApprovalForAll(address operator, bool _approved) public;
75     function isApprovedForAll(address owner, address operator) public view returns (bool);
76 
77     function transferFrom(address from, address to, uint256 tokenId) public;
78     function safeTransferFrom(address from, address to, uint256 tokenId) public;
79 
80     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
81 }
82 
83 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
84 
85 pragma solidity ^0.5.0;
86 
87 /**
88  * @title Ownable
89  * @dev The Ownable contract has an owner address, and provides basic authorization control
90  * functions, this simplifies the implementation of "user permissions".
91  */
92 contract Ownable {
93     address private _owner;
94 
95     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97     /**
98      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99      * account.
100      */
101     constructor () internal {
102         _owner = msg.sender;
103         emit OwnershipTransferred(address(0), _owner);
104     }
105 
106     /**
107      * @return the address of the owner.
108      */
109     function owner() public view returns (address) {
110         return _owner;
111     }
112 
113     /**
114      * @dev Throws if called by any account other than the owner.
115      */
116     modifier onlyOwner() {
117         require(isOwner());
118         _;
119     }
120 
121     /**
122      * @return true if `msg.sender` is the owner of the contract.
123      */
124     function isOwner() public view returns (bool) {
125         return msg.sender == _owner;
126     }
127 
128     /**
129      * @dev Allows the current owner to relinquish control of the contract.
130      * @notice Renouncing to ownership will leave the contract without an owner.
131      * It will not be possible to call the functions with the `onlyOwner`
132      * modifier anymore.
133      */
134     function renounceOwnership() public onlyOwner {
135         emit OwnershipTransferred(_owner, address(0));
136         _owner = address(0);
137     }
138 
139     /**
140      * @dev Allows the current owner to transfer control of the contract to a newOwner.
141      * @param newOwner The address to transfer ownership to.
142      */
143     function transferOwnership(address newOwner) public onlyOwner {
144         _transferOwnership(newOwner);
145     }
146 
147     /**
148      * @dev Transfers control of the contract to a newOwner.
149      * @param newOwner The address to transfer ownership to.
150      */
151     function _transferOwnership(address newOwner) internal {
152         require(newOwner != address(0));
153         emit OwnershipTransferred(_owner, newOwner);
154         _owner = newOwner;
155     }
156 }
157 
158 // File: @ensdomains/ethregistrar/contracts/BaseRegistrar.sol
159 
160 pragma solidity >=0.4.24;
161 
162 
163 
164 
165 contract BaseRegistrar is IERC721, Ownable {
166     uint constant public GRACE_PERIOD = 90 days;
167 
168     event ControllerAdded(address indexed controller);
169     event ControllerRemoved(address indexed controller);
170     event NameMigrated(uint256 indexed id, address indexed owner, uint expires);
171     event NameRegistered(uint256 indexed id, address indexed owner, uint expires);
172     event NameRenewed(uint256 indexed id, uint expires);
173 
174     // The ENS registry
175     ENS public ens;
176 
177     // The namehash of the TLD this registrar owns (eg, .eth)
178     bytes32 public baseNode;
179 
180     // A map of addresses that are authorised to register and renew names.
181     mapping(address=>bool) public controllers;
182 
183     // Authorises a controller, who can register and renew domains.
184     function addController(address controller) external;
185 
186     // Revoke controller permission for an address.
187     function removeController(address controller) external;
188 
189     // Set the resolver for the TLD this registrar manages.
190     function setResolver(address resolver) external;
191 
192     // Returns the expiration timestamp of the specified label hash.
193     function nameExpires(uint256 id) external view returns(uint);
194 
195     // Returns true iff the specified name is available for registration.
196     function available(uint256 id) public view returns(bool);
197 
198     /**
199      * @dev Register a name.
200      */
201     function register(uint256 id, address owner, uint duration) external returns(uint);
202 
203     function renew(uint256 id, uint duration) external returns(uint);
204 
205     /**
206      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
207      */
208     function reclaim(uint256 id, address owner) external;
209 }
210 
211 // File: @ensdomains/subdomain-registrar/contracts/Resolver.sol
212 
213 pragma solidity ^0.5.0;
214 
215 
216 /**
217  * @dev A basic interface for ENS resolvers.
218  */
219 contract Resolver {
220     function supportsInterface(bytes4 interfaceID) public pure returns (bool);
221     function addr(bytes32 node) public view returns (address);
222     function setAddr(bytes32 node, address addr) public;
223 }
224 
225 // File: @ensdomains/subdomain-registrar/contracts/RegistrarInterface.sol
226 
227 pragma solidity ^0.5.0;
228 
229 contract RegistrarInterface {
230     event OwnerChanged(bytes32 indexed label, address indexed oldOwner, address indexed newOwner);
231     event DomainConfigured(bytes32 indexed label);
232     event DomainUnlisted(bytes32 indexed label);
233     event NewRegistration(bytes32 indexed label, string subdomain, address indexed owner, address indexed referrer, uint price);
234     event RentPaid(bytes32 indexed label, string subdomain, uint amount, uint expirationDate);
235 
236     // InterfaceID of these four methods is 0xc1b15f5a
237     function query(bytes32 label, string calldata subdomain) external view returns (string memory domain, uint signupFee, uint rent, uint referralFeePPM);
238     function register(bytes32 label, string calldata subdomain, address owner, address payable referrer, address resolver) external payable;
239 
240     function rentDue(bytes32 label, string calldata subdomain) external view returns (uint timestamp);
241     function payRent(bytes32 label, string calldata subdomain) external payable;
242 }
243 
244 // File: @ensdomains/subdomain-registrar/contracts/AbstractSubdomainRegistrar.sol
245 
246 pragma solidity ^0.5.0;
247 
248 
249 
250 
251 contract AbstractSubdomainRegistrar is RegistrarInterface {
252 
253     // namehash('eth')
254     bytes32 constant public TLD_NODE = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
255 
256     bool public stopped = false;
257     address public registrarOwner;
258     address public migration;
259 
260     address public registrar;
261 
262     ENS public ens;
263 
264     modifier owner_only(bytes32 label) {
265         require(owner(label) == msg.sender);
266         _;
267     }
268 
269     modifier not_stopped() {
270         require(!stopped);
271         _;
272     }
273 
274     modifier registrar_owner_only() {
275         require(msg.sender == registrarOwner);
276         _;
277     }
278 
279     event DomainTransferred(bytes32 indexed label, string name);
280 
281     constructor(ENS _ens) public {
282         ens = _ens;
283         registrar = ens.owner(TLD_NODE);
284         registrarOwner = msg.sender;
285     }
286 
287     function doRegistration(bytes32 node, bytes32 label, address subdomainOwner, Resolver resolver) internal {
288         // Get the subdomain so we can configure it
289         ens.setSubnodeOwner(node, label, address(this));
290 
291         bytes32 subnode = keccak256(abi.encodePacked(node, label));
292         // Set the subdomain's resolver
293         ens.setResolver(subnode, address(resolver));
294 
295         // Set the address record on the resolver
296         resolver.setAddr(subnode, subdomainOwner);
297 
298         // Pass ownership of the new subdomain to the registrant
299         ens.setOwner(subnode, subdomainOwner);
300     }
301 
302     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
303         return (
304             (interfaceID == 0x01ffc9a7) // supportsInterface(bytes4)
305             || (interfaceID == 0xc1b15f5a) // RegistrarInterface
306         );
307     }
308 
309     function rentDue(bytes32 label, string calldata subdomain) external view returns (uint timestamp) {
310         return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
311     }
312 
313     /**
314      * @dev Sets the resolver record for a name in ENS.
315      * @param name The name to set the resolver for.
316      * @param resolver The address of the resolver
317      */
318     function setResolver(string memory name, address resolver) public owner_only(keccak256(bytes(name))) {
319         bytes32 label = keccak256(bytes(name));
320         bytes32 node = keccak256(abi.encodePacked(TLD_NODE, label));
321         ens.setResolver(node, resolver);
322     }
323 
324     /**
325      * @dev Configures a domain for sale.
326      * @param name The name to configure.
327      * @param price The price in wei to charge for subdomain registrations
328      * @param referralFeePPM The referral fee to offer, in parts per million
329      */
330     function configureDomain(string memory name, uint price, uint referralFeePPM) public {
331         configureDomainFor(name, price, referralFeePPM, msg.sender, address(0x0));
332     }
333 
334     /**
335      * @dev Stops the registrar, disabling configuring of new domains.
336      */
337     function stop() public not_stopped registrar_owner_only {
338         stopped = true;
339     }
340 
341     /**
342      * @dev Sets the address where domains are migrated to.
343      * @param _migration Address of the new registrar.
344      */
345     function setMigrationAddress(address _migration) public registrar_owner_only {
346         require(stopped);
347         migration = _migration;
348     }
349 
350     function transferOwnership(address newOwner) public registrar_owner_only {
351         registrarOwner = newOwner;
352     }
353 
354     /**
355      * @dev Returns information about a subdomain.
356      * @param label The label hash for the domain.
357      * @param subdomain The label for the subdomain.
358      * @return domain The name of the domain, or an empty string if the subdomain
359      *                is unavailable.
360      * @return price The price to register a subdomain, in wei.
361      * @return rent The rent to retain a subdomain, in wei per second.
362      * @return referralFeePPM The referral fee for the dapp, in ppm.
363      */
364     function query(bytes32 label, string calldata subdomain) external view returns (string memory domain, uint price, uint rent, uint referralFeePPM);
365 
366     function owner(bytes32 label) public view returns (address);
367     function configureDomainFor(string memory name, uint price, uint referralFeePPM, address payable _owner, address _transfer) public;
368 }
369 
370 // File: @ensdomains/subdomain-registrar/contracts/EthRegistrarSubdomainRegistrar.sol
371 
372 pragma solidity ^0.5.0;
373 
374 
375 
376 /**
377  * @dev Implements an ENS registrar that sells subdomains on behalf of their owners.
378  *
379  * Users may register a subdomain by calling `register` with the name of the domain
380  * they wish to register under, and the label hash of the subdomain they want to
381  * register. They must also specify the new owner of the domain, and the referrer,
382  * who is paid an optional finder's fee. The registrar then configures a simple
383  * default resolver, which resolves `addr` lookups to the new owner, and sets
384  * the `owner` account as the owner of the subdomain in ENS.
385  *
386  * New domains may be added by calling `configureDomain`, then transferring
387  * ownership in the ENS registry to this contract. Ownership in the contract
388  * may be transferred using `transfer`, and a domain may be unlisted for sale
389  * using `unlistDomain`. There is (deliberately) no way to recover ownership
390  * in ENS once the name is transferred to this registrar.
391  *
392  * Critically, this contract does not check one key property of a listed domain:
393  *
394  * - Is the name UTS46 normalised?
395  *
396  * User applications MUST check these two elements for each domain before
397  * offering them to users for registration.
398  *
399  * Applications should additionally check that the domains they are offering to
400  * register are controlled by this registrar, since calls to `register` will
401  * fail if this is not the case.
402  */
403 contract EthRegistrarSubdomainRegistrar is AbstractSubdomainRegistrar {
404 
405     struct Domain {
406         string name;
407         address payable owner;
408         uint price;
409         uint referralFeePPM;
410     }
411 
412     mapping (bytes32 => Domain) domains;
413 
414     constructor(ENS ens) AbstractSubdomainRegistrar(ens) public { }
415 
416     /**
417      * @dev owner returns the address of the account that controls a domain.
418      *      Initially this is a null address. If the name has been
419      *      transferred to this contract, then the internal mapping is consulted
420      *      to determine who controls it. If the owner is not set,
421      *      the owner of the domain in the Registrar is returned.
422      * @param label The label hash of the deed to check.
423      * @return The address owning the deed.
424      */
425     function owner(bytes32 label) public view returns (address) {
426         if (domains[label].owner != address(0x0)) {
427             return domains[label].owner;
428         }
429 
430         return BaseRegistrar(registrar).ownerOf(uint256(label));
431     }
432 
433     /**
434      * @dev Transfers internal control of a name to a new account. Does not update
435      *      ENS.
436      * @param name The name to transfer.
437      * @param newOwner The address of the new owner.
438      */
439     function transfer(string memory name, address payable newOwner) public owner_only(keccak256(bytes(name))) {
440         bytes32 label = keccak256(bytes(name));
441         emit OwnerChanged(label, domains[label].owner, newOwner);
442         domains[label].owner = newOwner;
443     }
444 
445     /**
446      * @dev Configures a domain, optionally transferring it to a new owner.
447      * @param name The name to configure.
448      * @param price The price in wei to charge for subdomain registrations.
449      * @param referralFeePPM The referral fee to offer, in parts per million.
450      * @param _owner The address to assign ownership of this domain to.
451      * @param _transfer The address to set as the transfer address for the name
452      *        when the permanent registrar is replaced. Can only be set to a non-zero
453      *        value once.
454      */
455     function configureDomainFor(string memory name, uint price, uint referralFeePPM, address payable _owner, address _transfer) public owner_only(keccak256(bytes(name))) {
456         bytes32 label = keccak256(bytes(name));
457         Domain storage domain = domains[label];
458 
459         if (BaseRegistrar(registrar).ownerOf(uint256(label)) != address(this)) {
460             BaseRegistrar(registrar).transferFrom(msg.sender, address(this), uint256(label));
461             BaseRegistrar(registrar).reclaim(uint256(label), address(this));
462         }
463 
464         if (domain.owner != _owner) {
465             domain.owner = _owner;
466         }
467 
468         if (keccak256(bytes(domain.name)) != label) {
469             // New listing
470             domain.name = name;
471         }
472 
473         domain.price = price;
474         domain.referralFeePPM = referralFeePPM;
475 
476         emit DomainConfigured(label);
477     }
478 
479     /**
480      * @dev Unlists a domain
481      * May only be called by the owner.
482      * @param name The name of the domain to unlist.
483      */
484     function unlistDomain(string memory name) public owner_only(keccak256(bytes(name))) {
485         bytes32 label = keccak256(bytes(name));
486         Domain storage domain = domains[label];
487         emit DomainUnlisted(label);
488 
489         domain.name = '';
490         domain.price = 0;
491         domain.referralFeePPM = 0;
492     }
493 
494     /**
495      * @dev Returns information about a subdomain.
496      * @param label The label hash for the domain.
497      * @param subdomain The label for the subdomain.
498      * @return domain The name of the domain, or an empty string if the subdomain
499      *                is unavailable.
500      * @return price The price to register a subdomain, in wei.
501      * @return rent The rent to retain a subdomain, in wei per second.
502      * @return referralFeePPM The referral fee for the dapp, in ppm.
503      */
504     function query(bytes32 label, string calldata subdomain) external view returns (string memory domain, uint price, uint rent, uint referralFeePPM) {
505         bytes32 node = keccak256(abi.encodePacked(TLD_NODE, label));
506         bytes32 subnode = keccak256(abi.encodePacked(node, keccak256(bytes(subdomain))));
507 
508         if (ens.owner(subnode) != address(0x0)) {
509             return ('', 0, 0, 0);
510         }
511 
512         Domain storage data = domains[label];
513         return (data.name, data.price, 0, data.referralFeePPM);
514     }
515 
516     /**
517      * @dev Registers a subdomain.
518      * @param label The label hash of the domain to register a subdomain of.
519      * @param subdomain The desired subdomain label.
520      * @param _subdomainOwner The account that should own the newly configured subdomain.
521      * @param referrer The address of the account to receive the referral fee.
522      */
523     function register(bytes32 label, string calldata subdomain, address _subdomainOwner, address payable referrer, address resolver) external not_stopped payable {
524         address subdomainOwner = _subdomainOwner;
525         bytes32 domainNode = keccak256(abi.encodePacked(TLD_NODE, label));
526         bytes32 subdomainLabel = keccak256(bytes(subdomain));
527 
528         // Subdomain must not be registered already.
529         require(ens.owner(keccak256(abi.encodePacked(domainNode, subdomainLabel))) == address(0));
530 
531         Domain storage domain = domains[label];
532 
533         // Domain must be available for registration
534         require(keccak256(bytes(domain.name)) == label);
535 
536         // User must have paid enough
537         require(msg.value >= domain.price);
538 
539         // Send any extra back
540         if (msg.value > domain.price) {
541             msg.sender.transfer(msg.value - domain.price);
542         }
543 
544         // Send any referral fee
545         uint256 total = domain.price;
546         if (domain.referralFeePPM > 0 && referrer != address(0x0) && referrer != domain.owner) {
547             uint256 referralFee = (domain.price * domain.referralFeePPM) / 1000000;
548             referrer.transfer(referralFee);
549             total -= referralFee;
550         }
551 
552         // Send the registration fee
553         if (total > 0) {
554             domain.owner.transfer(total);
555         }
556 
557         // Register the domain
558         if (subdomainOwner == address(0x0)) {
559             subdomainOwner = msg.sender;
560         }
561         doRegistration(domainNode, subdomainLabel, subdomainOwner, Resolver(resolver));
562 
563         emit NewRegistration(label, subdomain, subdomainOwner, referrer, domain.price);
564     }
565 
566     function rentDue(bytes32 label, string calldata subdomain) external view returns (uint timestamp) {
567         return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
568     }
569 
570     /**
571      * @dev Migrates the domain to a new registrar.
572      * @param name The name of the domain to migrate.
573      */
574     function migrate(string memory name) public owner_only(keccak256(bytes(name))) {
575         require(stopped);
576         require(migration != address(0x0));
577 
578         bytes32 label = keccak256(bytes(name));
579         Domain storage domain = domains[label];
580 
581         BaseRegistrar(registrar).approve(migration, uint256(label));
582 
583         EthRegistrarSubdomainRegistrar(migration).configureDomainFor(
584             domain.name,
585             domain.price,
586             domain.referralFeePPM,
587             domain.owner,
588             address(0x0)
589         );
590 
591         delete domains[label];
592 
593         emit DomainTransferred(label, name);
594     }
595 
596     function payRent(bytes32 label, string calldata subdomain) external payable {
597         revert();
598     }
599 }
600 
601 // File: @ensdomains/subdomain-registrar/contracts/ENSMigrationSubdomainRegistrar.sol
602 
603 pragma solidity ^0.5.0;
604 
605 
606 
607 /**
608  * @dev Implements an ENS registrar that sells subdomains on behalf of their owners.
609  *
610  * Users may register a subdomain by calling `register` with the name of the domain
611  * they wish to register under, and the label hash of the subdomain they want to
612  * register. They must also specify the new owner of the domain, and the referrer,
613  * who is paid an optional finder's fee. The registrar then configures a simple
614  * default resolver, which resolves `addr` lookups to the new owner, and sets
615  * the `owner` account as the owner of the subdomain in ENS.
616  *
617  * New domains may be added by calling `configureDomain`, then transferring
618  * ownership in the ENS registry to this contract. Ownership in the contract
619  * may be transferred using `transfer`, and a domain may be unlisted for sale
620  * using `unlistDomain`. There is (deliberately) no way to recover ownership
621  * in ENS once the name is transferred to this registrar.
622  *
623  * Critically, this contract does not check one key property of a listed domain:
624  *
625  * - Is the name UTS46 normalised?
626  *
627  * User applications MUST check these two elements for each domain before
628  * offering them to users for registration.
629  *
630  * Applications should additionally check that the domains they are offering to
631  * register are controlled by this registrar, since calls to `register` will
632  * fail if this is not the case.
633  */
634 contract ENSMigrationSubdomainRegistrar is EthRegistrarSubdomainRegistrar {
635 
636     constructor(ENS ens) EthRegistrarSubdomainRegistrar(ens) public { }
637 
638     function migrateSubdomain(bytes32 node, bytes32 label) external {
639         bytes32 subnode = keccak256(abi.encodePacked(node, label));
640         address previous = ens.owner(subnode);
641 
642         // only allow a contract to run their own migration
643         require(!isContract(previous) || msg.sender == previous);
644 
645         ens.setSubnodeRecord(node, label, previous, ens.resolver(subnode), ens.ttl(subnode));
646     }
647 
648     function isContract(address addr) private returns (bool) {
649         uint size;
650         assembly { size := extcodesize(addr) }
651         return size > 0;
652     }
653 }