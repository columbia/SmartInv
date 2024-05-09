1 pragma solidity ^0.4.17;
2 
3 // File: contracts/ENS.sol
4 
5 /**
6  * The ENS registry contract.
7  */
8 contract ENS {
9     // Logged when the owner of a node assigns a new owner to a subnode.
10     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
11 
12     // Logged when the owner of a node transfers ownership to a new account.
13     event Transfer(bytes32 indexed node, address owner);
14 
15     // Logged when the resolver for a node changes.
16     event NewResolver(bytes32 indexed node, address resolver);
17 
18     // Logged when the TTL of a node changes
19     event NewTTL(bytes32 indexed node, uint64 ttl);
20 
21     struct Record {
22         address owner;
23         address resolver;
24         uint64 ttl;
25     }
26 
27     mapping (bytes32 => Record) records;
28 
29     // Permits modifications only by the owner of the specified node.
30     modifier only_owner(bytes32 node) {
31         if (records[node].owner != msg.sender) throw;
32         _;
33     }
34 
35     /**
36      * Constructs a new ENS registrar.
37      */
38     function ENS() public {
39         records[0].owner = msg.sender;
40     }
41 
42     /**
43      * Returns the address that owns the specified node.
44      */
45     function owner(bytes32 node) public constant returns (address) {
46         return records[node].owner;
47     }
48 
49     /**
50      * Returns the address of the resolver for the specified node.
51      */
52     function resolver(bytes32 node) public constant returns (address) {
53         return records[node].resolver;
54     }
55 
56     /**
57      * Returns the TTL of a node, and any records associated with it.
58      */
59     function ttl(bytes32 node) public constant returns (uint64) {
60         return records[node].ttl;
61     }
62 
63     /**
64      * Transfers ownership of a node to a new address. May only be called by the current
65      * owner of the node.
66      * @param node The node to transfer ownership of.
67      * @param owner The address of the new owner.
68      */
69     function setOwner(bytes32 node, address owner) public only_owner(node) {
70         Transfer(node, owner);
71         records[node].owner = owner;
72     }
73 
74     /**
75      * Transfers ownership of a subnode sha3(node, label) to a new address. May only be
76      * called by the owner of the parent node.
77      * @param node The parent node.
78      * @param label The hash of the label specifying the subnode.
79      * @param owner The address of the new owner.
80      */
81     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public only_owner(node) {
82         var subnode = sha3(node, label);
83         NewOwner(node, label, owner);
84         records[subnode].owner = owner;
85     }
86 
87     /**
88      * Sets the resolver address for the specified node.
89      * @param node The node to update.
90      * @param resolver The address of the resolver.
91      */
92     function setResolver(bytes32 node, address resolver) public only_owner(node) {
93         NewResolver(node, resolver);
94         records[node].resolver = resolver;
95     }
96 
97     /**
98      * Sets the TTL for the specified node.
99      * @param node The node to update.
100      * @param ttl The TTL in seconds.
101      */
102     function setTTL(bytes32 node, uint64 ttl) public only_owner(node) {
103         NewTTL(node, ttl);
104         records[node].ttl = ttl;
105     }
106 }
107 
108 // File: contracts/HashRegistrarSimplified.sol
109 
110 contract Deed {
111     address public owner;
112     address public previousOwner;
113 }
114 
115 contract HashRegistrarSimplified {
116     enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }
117 
118     bytes32 public rootNode;
119 
120     function entries(bytes32 _hash) public view returns (Mode, address, uint, uint, uint);
121     function transfer(bytes32 _hash, address newOwner) public;
122 }
123 
124 // File: contracts/RegistrarInterface.sol
125 
126 contract RegistrarInterface {
127     event OwnerChanged(bytes32 indexed label, address indexed oldOwner, address indexed newOwner);
128     event DomainConfigured(bytes32 indexed label);
129     event DomainUnlisted(bytes32 indexed label);
130     event NewRegistration(bytes32 indexed label, string subdomain, address indexed owner, address indexed referrer, uint price);
131     event RentPaid(bytes32 indexed label, string subdomain, uint amount, uint expirationDate);
132 
133     // InterfaceID of these four methods is 0xc1b15f5a
134     function query(bytes32 label, string subdomain) public view returns (string domain, uint signupFee, uint rent, uint referralFeePPM);
135     function register(bytes32 label, string subdomain, address owner, address referrer, address resolver) public payable;
136 
137     function rentDue(bytes32 label, string subdomain) public view returns (uint timestamp);
138     function payRent(bytes32 label, string subdomain) public payable;
139 }
140 
141 // File: contracts/Resolver.sol
142 
143 /**
144  * @dev A basic interface for ENS resolvers.
145  */
146 contract Resolver {
147     function supportsInterface(bytes4 interfaceID) public pure returns (bool);
148     function addr(bytes32 node) public view returns (address);
149     function setAddr(bytes32 node, address addr) public;
150 }
151 
152 // File: contracts/SubdomainRegistrar.sol
153 
154 /**
155  * @dev Implements an ENS registrar that sells subdomains on behalf of their owners.
156  *
157  * Users may register a subdomain by calling `register` with the name of the domain
158  * they wish to register under, and the label hash of the subdomain they want to
159  * register. They must also specify the new owner of the domain, and the referrer,
160  * who is paid an optional finder's fee. The registrar then configures a simple
161  * default resolver, which resolves `addr` lookups to the new owner, and sets
162  * the `owner` account as the owner of the subdomain in ENS.
163  *
164  * New domains may be added by calling `configureDomain`, then transferring
165  * ownership in the ENS registry to this contract. Ownership in the contract
166  * may be transferred using `transfer`, and a domain may be unlisted for sale
167  * using `unlistDomain`. There is (deliberately) no way to recover ownership
168  * in ENS once the name is transferred to this registrar.
169  *
170  * Critically, this contract does not check one key property of a listed domain:
171  *
172  * - Is the name UTS46 normalised?
173  *
174  * User applications MUST check these two elements for each domain before
175  * offering them to users for registration.
176  *
177  * Applications should additionally check that the domains they are offering to
178  * register are controlled by this registrar, since calls to `register` will
179  * fail if this is not the case.
180  */
181 contract SubdomainRegistrar is RegistrarInterface {
182 
183     // namehash('eth')
184     bytes32 constant public TLD_NODE = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
185 
186     bool public stopped = false;
187     address public registrarOwner;
188     address public migration;
189 
190     ENS public ens;
191     HashRegistrarSimplified public hashRegistrar;
192 
193     struct Domain {
194         string name;
195         address owner;
196         address transferAddress;
197         uint price;
198         uint referralFeePPM;
199     }
200 
201     mapping (bytes32 => Domain) domains;
202 
203     modifier new_registrar() {
204         require(ens.owner(TLD_NODE) != address(hashRegistrar));
205         _;
206     }
207 
208     modifier owner_only(bytes32 label) {
209         require(owner(label) == msg.sender);
210         _;
211     }
212 
213     modifier not_stopped() {
214         require(!stopped);
215         _;
216     }
217 
218     modifier registrar_owner_only() {
219         require(msg.sender == registrarOwner);
220         _;
221     }
222 
223     event TransferAddressSet(bytes32 indexed label, address addr);
224     event DomainTransferred(bytes32 indexed label, string name);
225 
226     function SubdomainRegistrar(ENS _ens) public {
227         ens = _ens;
228         hashRegistrar = HashRegistrarSimplified(ens.owner(TLD_NODE));
229         registrarOwner = msg.sender;
230     }
231 
232     /**
233      * @dev owner returns the address of the account that controls a domain.
234      *      Initially this is a null address. If the name has been
235      *      transferred to this contract, then the internal mapping is consulted
236      *      to determine who controls it. If the owner is not set,
237      *      the previous owner of the deed is returned.
238      * @param label The label hash of the deed to check.
239      * @return The address owning the deed.
240      */
241     function owner(bytes32 label) public view returns (address) {
242 
243         if (domains[label].owner != 0x0) {
244             return domains[label].owner;
245         }
246 
247         Deed domainDeed = deed(label);
248         if (domainDeed.owner() != address(this)) {
249             return 0x0;
250         }
251 
252         return domainDeed.previousOwner();
253     }
254 
255     /**
256      * @dev Transfers internal control of a name to a new account. Does not update
257      *      ENS.
258      * @param name The name to transfer.
259      * @param newOwner The address of the new owner.
260      */
261     function transfer(string name, address newOwner) public owner_only(keccak256(name)) {
262         bytes32 label = keccak256(name);
263         OwnerChanged(keccak256(name), domains[label].owner, newOwner);
264         domains[label].owner = newOwner;
265     }
266 
267     /**
268      * @dev Sets the resolver record for a name in ENS.
269      * @param name The name to set the resolver for.
270      * @param resolver The address of the resolver
271      */
272     function setResolver(string name, address resolver) public owner_only(keccak256(name)) {
273         bytes32 label = keccak256(name);
274         bytes32 node = keccak256(TLD_NODE, label);
275         ens.setResolver(node, resolver);
276     }
277 
278     /**
279      * @dev Configures a domain for sale.
280      * @param name The name to configure.
281      * @param price The price in wei to charge for subdomain registrations
282      * @param referralFeePPM The referral fee to offer, in parts per million
283      */
284     function configureDomain(string name, uint price, uint referralFeePPM) public {
285         configureDomainFor(name, price, referralFeePPM, msg.sender, 0x0);
286     }
287 
288     /**
289      * @dev Configures a domain, optionally transferring it to a new owner.
290      * @param name The name to configure.
291      * @param price The price in wei to charge for subdomain registrations.
292      * @param referralFeePPM The referral fee to offer, in parts per million.
293      * @param _owner The address to assign ownership of this domain to.
294      * @param _transfer The address to set as the transfer address for the name
295      *        when the permanent registrar is replaced. Can only be set to a non-zero
296      *        value once.
297      */
298     function configureDomainFor(string name, uint price, uint referralFeePPM, address _owner, address _transfer) public owner_only(keccak256(name)) {
299         bytes32 label = keccak256(name);
300         Domain storage domain = domains[label];
301 
302         // Don't allow changing the transfer address once set. Treat 0 as "don't change" for convenience.
303         require(domain.transferAddress == 0 || _transfer == 0 || domain.transferAddress == _transfer);
304 
305         if (domain.owner != _owner) {
306             domain.owner = _owner;
307         }
308 
309         if (keccak256(domain.name) != label) {
310             // New listing
311             domain.name = name;
312         }
313 
314         domain.price = price;
315         domain.referralFeePPM = referralFeePPM;
316 
317         if (domain.transferAddress != _transfer && _transfer != 0) {
318             domain.transferAddress = _transfer;
319             TransferAddressSet(label, _transfer);
320         }
321 
322         DomainConfigured(label);
323     }
324 
325     /**
326      * @dev Sets the transfer address of a domain for after an ENS update.
327      * @param name The name for which to set the transfer address.
328      * @param transfer The address to transfer to.
329      */
330     function setTransferAddress(string name, address transfer) public owner_only(keccak256(name)) {
331         bytes32 label = keccak256(name);
332         Domain storage domain = domains[label];
333 
334         require(domain.transferAddress == 0x0);
335 
336         domain.transferAddress = transfer;
337         TransferAddressSet(label, transfer);
338     }
339 
340     /**
341      * @dev Unlists a domain
342      * May only be called by the owner.
343      * @param name The name of the domain to unlist.
344      */
345     function unlistDomain(string name) public owner_only(keccak256(name)) {
346         bytes32 label = keccak256(name);
347         Domain storage domain = domains[label];
348         DomainUnlisted(label);
349 
350         domain.name = '';
351         domain.owner = owner(label);
352         domain.price = 0;
353         domain.referralFeePPM = 0;
354     }
355 
356     /**
357      * @dev Returns information about a subdomain.
358      * @param label The label hash for the domain.
359      * @param subdomain The label for the subdomain.
360      * @return domain The name of the domain, or an empty string if the subdomain
361      *                is unavailable.
362      * @return price The price to register a subdomain, in wei.
363      * @return rent The rent to retain a subdomain, in wei per second.
364      * @return referralFeePPM The referral fee for the dapp, in ppm.
365      */
366     function query(bytes32 label, string subdomain) public view returns (string domain, uint price, uint rent, uint referralFeePPM) {
367         bytes32 node = keccak256(TLD_NODE, label);
368         bytes32 subnode = keccak256(node, keccak256(subdomain));
369 
370         if (ens.owner(subnode) != 0) {
371             return ('', 0, 0, 0);
372         }
373 
374         Domain data = domains[label];
375         return (data.name, data.price, 0, data.referralFeePPM);
376     }
377 
378     /**
379      * @dev Registers a subdomain.
380      * @param label The label hash of the domain to register a subdomain of.
381      * @param subdomain The desired subdomain label.
382      * @param subdomainOwner The account that should own the newly configured subdomain.
383      * @param referrer The address of the account to receive the referral fee.
384      */
385     function register(bytes32 label, string subdomain, address subdomainOwner, address referrer, address resolver) public not_stopped payable {
386         bytes32 domainNode = keccak256(TLD_NODE, label);
387         bytes32 subdomainLabel = keccak256(subdomain);
388 
389         // Subdomain must not be registered already.
390         require(ens.owner(keccak256(domainNode, subdomainLabel)) == address(0));
391 
392         Domain storage domain = domains[label];
393 
394         // Domain must be available for registration
395         require(keccak256(domain.name) == label);
396 
397         // User must have paid enough
398         require(msg.value >= domain.price);
399 
400         // Send any extra back
401         if (msg.value > domain.price) {
402             msg.sender.transfer(msg.value - domain.price);
403         }
404 
405         // Send any referral fee
406         uint256 total = domain.price;
407         if (domain.referralFeePPM * domain.price > 0 && referrer != 0 && referrer != domain.owner) {
408             uint256 referralFee = (domain.price * domain.referralFeePPM) / 1000000;
409             referrer.transfer(referralFee);
410             total -= referralFee;
411         }
412 
413         // Send the registration fee
414         if (total > 0) {
415             domain.owner.transfer(total);
416         }
417 
418         // Register the domain
419         if (subdomainOwner == 0) {
420             subdomainOwner = msg.sender;
421         }
422         doRegistration(domainNode, subdomainLabel, subdomainOwner, Resolver(resolver));
423 
424         NewRegistration(label, subdomain, subdomainOwner, referrer, domain.price);
425     }
426 
427     function doRegistration(bytes32 node, bytes32 label, address subdomainOwner, Resolver resolver) internal {
428         // Get the subdomain so we can configure it
429         ens.setSubnodeOwner(node, label, this);
430 
431         bytes32 subnode = keccak256(node, label);
432         // Set the subdomain's resolver
433         ens.setResolver(subnode, resolver);
434 
435         // Set the address record on the resolver
436         resolver.setAddr(subnode, subdomainOwner);
437 
438         // Pass ownership of the new subdomain to the registrant
439         ens.setOwner(subnode, subdomainOwner);
440     }
441 
442     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
443         return (
444             (interfaceID == 0x01ffc9a7) // supportsInterface(bytes4)
445             || (interfaceID == 0xc1b15f5a) // RegistrarInterface
446         );
447     }
448 
449     function rentDue(bytes32 label, string subdomain) public view returns (uint timestamp) {
450         return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
451     }
452 
453     /**
454      * @dev Upgrades the domain to a new registrar.
455      * @param name The name of the domain to transfer.
456      */
457     function upgrade(string name) public owner_only(keccak256(name)) new_registrar {
458         bytes32 label = keccak256(name);
459         address transfer = domains[label].transferAddress;
460 
461         require(transfer != 0x0);
462 
463         delete domains[label];
464 
465         hashRegistrar.transfer(label, transfer);
466         DomainTransferred(label, name);
467     }
468 
469 
470     /**
471      * @dev Stops the registrar, disabling configuring of new domains.
472      */
473     function stop() public not_stopped registrar_owner_only {
474         stopped = true;
475     }
476 
477     /**
478      * @dev Sets the address where domains are migrated to.
479      * @param _migration Address of the new registrar.
480      */
481     function setMigrationAddress(address _migration) public registrar_owner_only {
482         require(stopped);
483         migration = _migration;
484     }
485 
486     /**
487      * @dev Migrates the domain to a new registrar.
488      * @param name The name of the domain to migrate.
489      */
490     function migrate(string name) public owner_only(keccak256(name)) {
491         require(stopped);
492         require(migration != 0x0);
493 
494         bytes32 label = keccak256(name);
495         Domain storage domain = domains[label];
496 
497         hashRegistrar.transfer(label, migration);
498 
499         SubdomainRegistrar(migration).configureDomainFor(
500             domain.name,
501             domain.price,
502             domain.referralFeePPM,
503             domain.owner,
504             domain.transferAddress
505         );
506 
507         delete domains[label];
508 
509         DomainTransferred(label, name);
510     }
511 
512     function transferOwnership(address newOwner) public registrar_owner_only {
513         registrarOwner = newOwner;
514     }
515 
516     function payRent(bytes32 label, string subdomain) public payable {
517         revert();
518     }
519 
520     function deed(bytes32 label) internal view returns (Deed) {
521         var (,deedAddress,,,) = hashRegistrar.entries(label);
522         return Deed(deedAddress);
523     }
524 }