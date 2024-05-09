1 // File: openzeppelin-solidity/contracts/access/Roles.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
45 
46 pragma solidity ^0.5.0;
47 
48 
49 /**
50  * @title WhitelistAdminRole
51  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
52  */
53 contract WhitelistAdminRole {
54     using Roles for Roles.Role;
55 
56     event WhitelistAdminAdded(address indexed account);
57     event WhitelistAdminRemoved(address indexed account);
58 
59     Roles.Role private _whitelistAdmins;
60 
61     constructor () internal {
62         _addWhitelistAdmin(msg.sender);
63     }
64 
65     modifier onlyWhitelistAdmin() {
66         require(isWhitelistAdmin(msg.sender));
67         _;
68     }
69 
70     function isWhitelistAdmin(address account) public view returns (bool) {
71         return _whitelistAdmins.has(account);
72     }
73 
74     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
75         _addWhitelistAdmin(account);
76     }
77 
78     function renounceWhitelistAdmin() public {
79         _removeWhitelistAdmin(msg.sender);
80     }
81 
82     function _addWhitelistAdmin(address account) internal {
83         _whitelistAdmins.add(account);
84         emit WhitelistAdminAdded(account);
85     }
86 
87     function _removeWhitelistAdmin(address account) internal {
88         _whitelistAdmins.remove(account);
89         emit WhitelistAdminRemoved(account);
90     }
91 }
92 
93 // File: @ensdomains/ens/contracts/ENS.sol
94 
95 pragma solidity >=0.4.24;
96 
97 interface ENS {
98 
99     // Logged when the owner of a node assigns a new owner to a subnode.
100     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
101 
102     // Logged when the owner of a node transfers ownership to a new account.
103     event Transfer(bytes32 indexed node, address owner);
104 
105     // Logged when the resolver for a node changes.
106     event NewResolver(bytes32 indexed node, address resolver);
107 
108     // Logged when the TTL of a node changes
109     event NewTTL(bytes32 indexed node, uint64 ttl);
110 
111 
112     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
113     function setResolver(bytes32 node, address resolver) external;
114     function setOwner(bytes32 node, address owner) external;
115     function setTTL(bytes32 node, uint64 ttl) external;
116     function owner(bytes32 node) external view returns (address);
117     function resolver(bytes32 node) external view returns (address);
118     function ttl(bytes32 node) external view returns (uint64);
119 
120 }
121 
122 // File: @ensdomains/ens/contracts/Deed.sol
123 
124 pragma solidity >=0.4.24;
125 
126 interface Deed {
127 
128     function setOwner(address payable newOwner) external;
129     function setRegistrar(address newRegistrar) external;
130     function setBalance(uint newValue, bool throwOnFailure) external;
131     function closeDeed(uint refundRatio) external;
132     function destroyDeed() external;
133 
134     function owner() external view returns (address);
135     function previousOwner() external view returns (address);
136     function value() external view returns (uint);
137     function creationDate() external view returns (uint);
138 
139 }
140 
141 // File: @ensdomains/ens/contracts/DeedImplementation.sol
142 
143 pragma solidity ^0.5.0;
144 
145 
146 /**
147  * @title Deed to hold ether in exchange for ownership of a node
148  * @dev The deed can be controlled only by the registrar and can only send ether back to the owner.
149  */
150 contract DeedImplementation is Deed {
151 
152     address payable constant burn = address(0xdead);
153 
154     address payable private _owner;
155     address private _previousOwner;
156     address private _registrar;
157 
158     uint private _creationDate;
159     uint private _value;
160 
161     bool active;
162 
163     event OwnerChanged(address newOwner);
164     event DeedClosed();
165 
166     modifier onlyRegistrar {
167         require(msg.sender == _registrar);
168         _;
169     }
170 
171     modifier onlyActive {
172         require(active);
173         _;
174     }
175 
176     constructor(address payable initialOwner) public payable {
177         _owner = initialOwner;
178         _registrar = msg.sender;
179         _creationDate = now;
180         active = true;
181         _value = msg.value;
182     }
183 
184     function setOwner(address payable newOwner) external onlyRegistrar {
185         require(newOwner != address(0x0));
186         _previousOwner = _owner;  // This allows contracts to check who sent them the ownership
187         _owner = newOwner;
188         emit OwnerChanged(newOwner);
189     }
190 
191     function setRegistrar(address newRegistrar) external onlyRegistrar {
192         _registrar = newRegistrar;
193     }
194 
195     function setBalance(uint newValue, bool throwOnFailure) external onlyRegistrar onlyActive {
196         // Check if it has enough balance to set the value
197         require(_value >= newValue);
198         _value = newValue;
199         // Send the difference to the owner
200         require(_owner.send(address(this).balance - newValue) || !throwOnFailure);
201     }
202 
203     /**
204      * @dev Close a deed and refund a specified fraction of the bid value
205      *
206      * @param refundRatio The amount*1/1000 to refund
207      */
208     function closeDeed(uint refundRatio) external onlyRegistrar onlyActive {
209         active = false;
210         require(burn.send(((1000 - refundRatio) * address(this).balance)/1000));
211         emit DeedClosed();
212         _destroyDeed();
213     }
214 
215     /**
216      * @dev Close a deed and refund a specified fraction of the bid value
217      */
218     function destroyDeed() external {
219         _destroyDeed();
220     }
221 
222     function owner() external view returns (address) {
223         return _owner;
224     }
225 
226     function previousOwner() external view returns (address) {
227         return _previousOwner;
228     }
229 
230     function value() external view returns (uint) {
231         return _value;
232     }
233 
234     function creationDate() external view returns (uint) {
235         _creationDate;
236     }
237 
238     function _destroyDeed() internal {
239         require(!active);
240 
241         // Instead of selfdestruct(owner), invoke owner fallback function to allow
242         // owner to log an event if desired; but owner should also be aware that
243         // its fallback function can also be invoked by setBalance
244         if (_owner.send(address(this).balance)) {
245             selfdestruct(burn);
246         }
247     }
248 }
249 
250 // File: @ensdomains/ens/contracts/Registrar.sol
251 
252 pragma solidity >=0.4.24;
253 
254 
255 interface Registrar {
256 
257     enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }
258 
259     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
260     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
261     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
262     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
263     event HashReleased(bytes32 indexed hash, uint value);
264     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
265 
266     function startAuction(bytes32 _hash) external;
267     function startAuctions(bytes32[] calldata _hashes) external;
268     function newBid(bytes32 sealedBid) external payable;
269     function startAuctionsAndBid(bytes32[] calldata hashes, bytes32 sealedBid) external payable;
270     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) external;
271     function cancelBid(address bidder, bytes32 seal) external;
272     function finalizeAuction(bytes32 _hash) external;
273     function transfer(bytes32 _hash, address payable newOwner) external;
274     function releaseDeed(bytes32 _hash) external;
275     function invalidateName(string calldata unhashedName) external;
276     function eraseNode(bytes32[] calldata labels) external;
277     function transferRegistrars(bytes32 _hash) external;
278     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) external;
279     function entries(bytes32 _hash) external view returns (Mode, address, uint, uint, uint);
280 }
281 
282 // File: @ensdomains/ens/contracts/HashRegistrar.sol
283 
284 pragma solidity ^0.5.0;
285 
286 
287 /*
288 
289 Temporary Hash Registrar
290 ========================
291 
292 This is a simplified version of a hash registrar. It is purporsefully limited:
293 names cannot be six letters or shorter, new auctions will stop after 4 years.
294 
295 The plan is to test the basic features and then move to a new contract in at most
296 2 years, when some sort of renewal mechanism will be enabled.
297 */
298 
299 
300 
301 
302 /**
303  * @title Registrar
304  * @dev The registrar handles the auction process for each subnode of the node it owns.
305  */
306 contract HashRegistrar is Registrar {
307     ENS public ens;
308     bytes32 public rootNode;
309 
310     mapping (bytes32 => Entry) _entries;
311     mapping (address => mapping (bytes32 => Deed)) public sealedBids;
312 
313     uint32 constant totalAuctionLength = 5 days;
314     uint32 constant revealPeriod = 48 hours;
315     uint32 public constant launchLength = 8 weeks;
316 
317     uint constant minPrice = 0.01 ether;
318     uint public registryStarted;
319 
320     struct Entry {
321         Deed deed;
322         uint registrationDate;
323         uint value;
324         uint highestBid;
325     }
326 
327     modifier inState(bytes32 _hash, Mode _state) {
328         require(state(_hash) == _state);
329         _;
330     }
331 
332     modifier onlyOwner(bytes32 _hash) {
333         require(state(_hash) == Mode.Owned && msg.sender == _entries[_hash].deed.owner());
334         _;
335     }
336 
337     modifier registryOpen() {
338         require(now >= registryStarted && now <= registryStarted + (365 * 4) * 1 days && ens.owner(rootNode) == address(this));
339         _;
340     }
341 
342     /**
343      * @dev Constructs a new Registrar, with the provided address as the owner of the root node.
344      *
345      * @param _ens The address of the ENS
346      * @param _rootNode The hash of the rootnode.
347      */
348     constructor(ENS _ens, bytes32 _rootNode, uint _startDate) public {
349         ens = _ens;
350         rootNode = _rootNode;
351         registryStarted = _startDate > 0 ? _startDate : now;
352     }
353 
354     /**
355      * @dev Start an auction for an available hash
356      *
357      * @param _hash The hash to start an auction on
358      */
359     function startAuction(bytes32 _hash) external {
360         _startAuction(_hash);
361     }
362 
363     /**
364      * @dev Start multiple auctions for better anonymity
365      *
366      * Anyone can start an auction by sending an array of hashes that they want to bid for.
367      * Arrays are sent so that someone can open up an auction for X dummy hashes when they
368      * are only really interested in bidding for one. This will increase the cost for an
369      * attacker to simply bid blindly on all new auctions. Dummy auctions that are
370      * open but not bid on are closed after a week.
371      *
372      * @param _hashes An array of hashes, at least one of which you presumably want to bid on
373      */
374     function startAuctions(bytes32[] calldata _hashes) external {
375         _startAuctions(_hashes);
376     }
377 
378     /**
379      * @dev Submit a new sealed bid on a desired hash in a blind auction
380      *
381      * Bids are sent by sending a message to the main contract with a hash and an amount. The hash
382      * contains information about the bid, including the bidded hash, the bid amount, and a random
383      * salt. Bids are not tied to any one auction until they are revealed. The value of the bid
384      * itself can be masqueraded by sending more than the value of your actual bid. This is
385      * followed by a 48h reveal period. Bids revealed after this period will be burned and the ether unrecoverable.
386      * Since this is an auction, it is expected that most public hashes, like known domains and common dictionary
387      * words, will have multiple bidders pushing the price up.
388      *
389      * @param sealedBid A sealedBid, created by the shaBid function
390      */
391     function newBid(bytes32 sealedBid) external payable {
392         _newBid(sealedBid);
393     }
394 
395     /**
396      * @dev Start a set of auctions and bid on one of them
397      *
398      * This method functions identically to calling `startAuctions` followed by `newBid`,
399      * but all in one transaction.
400      *
401      * @param hashes A list of hashes to start auctions on.
402      * @param sealedBid A sealed bid for one of the auctions.
403      */
404     function startAuctionsAndBid(bytes32[] calldata hashes, bytes32 sealedBid) external payable {
405         _startAuctions(hashes);
406         _newBid(sealedBid);
407     }
408 
409     /**
410      * @dev Submit the properties of a bid to reveal them
411      *
412      * @param _hash The node in the sealedBid
413      * @param _value The bid amount in the sealedBid
414      * @param _salt The sale in the sealedBid
415      */
416     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) external {
417         bytes32 seal = shaBid(_hash, msg.sender, _value, _salt);
418         Deed bid = sealedBids[msg.sender][seal];
419         require(address(bid) != address(0x0));
420 
421         sealedBids[msg.sender][seal] = Deed(address(0x0));
422         Entry storage h = _entries[_hash];
423         uint value = min(_value, bid.value());
424         bid.setBalance(value, true);
425 
426         Mode auctionState = state(_hash);
427         if (auctionState == Mode.Owned) {
428             // Too late! Bidder loses their bid. Gets 0.5% back.
429             bid.closeDeed(5);
430             emit BidRevealed(_hash, msg.sender, value, 1);
431         } else if (auctionState != Mode.Reveal) {
432             // Invalid phase
433             revert();
434         } else if (value < minPrice || bid.creationDate() > h.registrationDate - revealPeriod) {
435             // Bid too low or too late, refund 99.5%
436             bid.closeDeed(995);
437             emit BidRevealed(_hash, msg.sender, value, 0);
438         } else if (value > h.highestBid) {
439             // New winner
440             // Cancel the other bid, refund 99.5%
441             if (address(h.deed) != address(0x0)) {
442                 Deed previousWinner = h.deed;
443                 previousWinner.closeDeed(995);
444             }
445 
446             // Set new winner
447             // Per the rules of a vickery auction, the value becomes the previous highestBid
448             h.value = h.highestBid;  // will be zero if there's only 1 bidder
449             h.highestBid = value;
450             h.deed = bid;
451             emit BidRevealed(_hash, msg.sender, value, 2);
452         } else if (value > h.value) {
453             // Not winner, but affects second place
454             h.value = value;
455             bid.closeDeed(995);
456             emit BidRevealed(_hash, msg.sender, value, 3);
457         } else {
458             // Bid doesn't affect auction
459             bid.closeDeed(995);
460             emit BidRevealed(_hash, msg.sender, value, 4);
461         }
462     }
463 
464     /**
465      * @dev Cancel a bid
466      *
467      * @param seal The value returned by the shaBid function
468      */
469     function cancelBid(address bidder, bytes32 seal) external {
470         Deed bid = sealedBids[bidder][seal];
471         
472         // If a sole bidder does not `unsealBid` in time, they have a few more days
473         // where they can call `startAuction` (again) and then `unsealBid` during
474         // the revealPeriod to get back their bid value.
475         // For simplicity, they should call `startAuction` within
476         // 9 days (2 weeks - totalAuctionLength), otherwise their bid will be
477         // cancellable by anyone.
478         require(address(bid) != address(0x0) && now >= bid.creationDate() + totalAuctionLength + 2 weeks);
479 
480         // Send the canceller 0.5% of the bid, and burn the rest.
481         bid.setOwner(msg.sender);
482         bid.closeDeed(5);
483         sealedBids[bidder][seal] = Deed(0);
484         emit BidRevealed(seal, bidder, 0, 5);
485     }
486 
487     /**
488      * @dev Finalize an auction after the registration date has passed
489      *
490      * @param _hash The hash of the name the auction is for
491      */
492     function finalizeAuction(bytes32 _hash) external onlyOwner(_hash) {
493         Entry storage h = _entries[_hash];
494         
495         // Handles the case when there's only a single bidder (h.value is zero)
496         h.value = max(h.value, minPrice);
497         h.deed.setBalance(h.value, true);
498 
499         trySetSubnodeOwner(_hash, h.deed.owner());
500         emit HashRegistered(_hash, h.deed.owner(), h.value, h.registrationDate);
501     }
502 
503     /**
504      * @dev The owner of a domain may transfer it to someone else at any time.
505      *
506      * @param _hash The node to transfer
507      * @param newOwner The address to transfer ownership to
508      */
509     function transfer(bytes32 _hash, address payable newOwner) external onlyOwner(_hash) {
510         require(newOwner != address(0x0));
511 
512         Entry storage h = _entries[_hash];
513         h.deed.setOwner(newOwner);
514         trySetSubnodeOwner(_hash, newOwner);
515     }
516 
517     /**
518      * @dev After some time, or if we're no longer the registrar, the owner can release
519      *      the name and get their ether back.
520      *
521      * @param _hash The node to release
522      */
523     function releaseDeed(bytes32 _hash) external onlyOwner(_hash) {
524         Entry storage h = _entries[_hash];
525         Deed deedContract = h.deed;
526 
527         require(now >= h.registrationDate + 365 days || ens.owner(rootNode) != address(this));
528 
529         h.value = 0;
530         h.highestBid = 0;
531         h.deed = Deed(0);
532 
533         _tryEraseSingleNode(_hash);
534         deedContract.closeDeed(1000);
535         emit HashReleased(_hash, h.value);        
536     }
537 
538     /**
539      * @dev Submit a name 6 characters long or less. If it has been registered,
540      *      the submitter will earn 50% of the deed value. 
541      * 
542      * We are purposefully handicapping the simplified registrar as a way 
543      * to force it into being restructured in a few years.
544      *
545      * @param unhashedName An invalid name to search for in the registry.
546      */
547     function invalidateName(string calldata unhashedName)
548         external
549         inState(keccak256(abi.encode(unhashedName)), Mode.Owned)
550     {
551         require(strlen(unhashedName) <= 6);
552         bytes32 hash = keccak256(abi.encode(unhashedName));
553 
554         Entry storage h = _entries[hash];
555 
556         _tryEraseSingleNode(hash);
557 
558         if (address(h.deed) != address(0x0)) {
559             // Reward the discoverer with 50% of the deed
560             // The previous owner gets 50%
561             h.value = max(h.value, minPrice);
562             h.deed.setBalance(h.value/2, false);
563             h.deed.setOwner(msg.sender);
564             h.deed.closeDeed(1000);
565         }
566 
567         emit HashInvalidated(hash, unhashedName, h.value, h.registrationDate);
568 
569         h.value = 0;
570         h.highestBid = 0;
571         h.deed = Deed(0);
572     }
573 
574     /**
575      * @dev Allows anyone to delete the owner and resolver records for a (subdomain of) a
576      *      name that is not currently owned in the registrar. If passing, eg, 'foo.bar.eth',
577      *      the owner and resolver fields on 'foo.bar.eth' and 'bar.eth' will all be cleared.
578      *
579      * @param labels A series of label hashes identifying the name to zero out, rooted at the
580      *        registrar's root. Must contain at least one element. For instance, to zero 
581      *        'foo.bar.eth' on a registrar that owns '.eth', pass an array containing
582      *        [keccak256('foo'), keccak256('bar')].
583      */
584     function eraseNode(bytes32[] calldata labels) external {
585         require(labels.length != 0);
586         require(state(labels[labels.length - 1]) != Mode.Owned);
587 
588         _eraseNodeHierarchy(labels.length - 1, labels, rootNode);
589     }
590 
591     /**
592      * @dev Transfers the deed to the current registrar, if different from this one.
593      *
594      * Used during the upgrade process to a permanent registrar.
595      *
596      * @param _hash The name hash to transfer.
597      */
598     function transferRegistrars(bytes32 _hash) external onlyOwner(_hash) {
599         address registrar = ens.owner(rootNode);
600         require(registrar != address(this));
601 
602         // Migrate the deed
603         Entry storage h = _entries[_hash];
604         h.deed.setRegistrar(registrar);
605 
606         // Call the new registrar to accept the transfer
607         Registrar(registrar).acceptRegistrarTransfer(_hash, h.deed, h.registrationDate);
608 
609         // Zero out the Entry
610         h.deed = Deed(0);
611         h.registrationDate = 0;
612         h.value = 0;
613         h.highestBid = 0;
614     }
615 
616     /**
617      * @dev Accepts a transfer from a previous registrar; stubbed out here since there
618      *      is no previous registrar implementing this interface.
619      *
620      * @param hash The sha3 hash of the label to transfer.
621      * @param deed The Deed object for the name being transferred in.
622      * @param registrationDate The date at which the name was originally registered.
623      */
624     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) external {
625         hash; deed; registrationDate; // Don't warn about unused variables
626     }
627 
628     function entries(bytes32 _hash) external view returns (Mode, address, uint, uint, uint) {
629         Entry storage h = _entries[_hash];
630         return (state(_hash), address(h.deed), h.registrationDate, h.value, h.highestBid);
631     }
632 
633     // State transitions for names:
634     //   Open -> Auction (startAuction)
635     //   Auction -> Reveal
636     //   Reveal -> Owned
637     //   Reveal -> Open (if nobody bid)
638     //   Owned -> Open (releaseDeed or invalidateName)
639     function state(bytes32 _hash) public view returns (Mode) {
640         Entry storage entry = _entries[_hash];
641 
642         if (!isAllowed(_hash, now)) {
643             return Mode.NotYetAvailable;
644         } else if (now < entry.registrationDate) {
645             if (now < entry.registrationDate - revealPeriod) {
646                 return Mode.Auction;
647             } else {
648                 return Mode.Reveal;
649             }
650         } else {
651             if (entry.highestBid == 0) {
652                 return Mode.Open;
653             } else {
654                 return Mode.Owned;
655             }
656         }
657     }
658 
659     /**
660      * @dev Determines if a name is available for registration yet
661      *
662      * Each name will be assigned a random date in which its auction
663      * can be started, from 0 to 8 weeks
664      *
665      * @param _hash The hash to start an auction on
666      * @param _timestamp The timestamp to query about
667      */
668     function isAllowed(bytes32 _hash, uint _timestamp) public view returns (bool allowed) {
669         return _timestamp > getAllowedTime(_hash);
670     }
671 
672     /**
673      * @dev Returns available date for hash
674      *
675      * The available time from the `registryStarted` for a hash is proportional
676      * to its numeric value.
677      *
678      * @param _hash The hash to start an auction on
679      */
680     function getAllowedTime(bytes32 _hash) public view returns (uint) {
681         return registryStarted + ((launchLength * (uint(_hash) >> 128)) >> 128);
682         // Right shift operator: a >> b == a / 2**b
683     }
684 
685     /**
686      * @dev Hash the values required for a secret bid
687      *
688      * @param hash The node corresponding to the desired namehash
689      * @param value The bid amount
690      * @param salt A random value to ensure secrecy of the bid
691      * @return The hash of the bid values
692      */
693     function shaBid(bytes32 hash, address owner, uint value, bytes32 salt) public pure returns (bytes32) {
694         return keccak256(abi.encodePacked(hash, owner, value, salt));
695     }
696 
697     function _tryEraseSingleNode(bytes32 label) internal {
698         if (ens.owner(rootNode) == address(this)) {
699             ens.setSubnodeOwner(rootNode, label, address(this));
700             bytes32 node = keccak256(abi.encodePacked(rootNode, label));
701             ens.setResolver(node, address(0x0));
702             ens.setOwner(node, address(0x0));
703         }
704     }
705 
706     function _startAuction(bytes32 _hash) internal registryOpen() {
707         Mode mode = state(_hash);
708         if (mode == Mode.Auction) return;
709         require(mode == Mode.Open);
710 
711         Entry storage newAuction = _entries[_hash];
712         newAuction.registrationDate = now + totalAuctionLength;
713         newAuction.value = 0;
714         newAuction.highestBid = 0;
715         emit AuctionStarted(_hash, newAuction.registrationDate);
716     }
717 
718     function _startAuctions(bytes32[] memory _hashes) internal {
719         for (uint i = 0; i < _hashes.length; i ++) {
720             _startAuction(_hashes[i]);
721         }
722     }
723 
724     function _newBid(bytes32 sealedBid) internal {
725         require(address(sealedBids[msg.sender][sealedBid]) == address(0x0));
726         require(msg.value >= minPrice);
727 
728         // Creates a new hash contract with the owner
729         Deed bid = (new DeedImplementation).value(msg.value)(msg.sender);
730         sealedBids[msg.sender][sealedBid] = bid;
731         emit NewBid(sealedBid, msg.sender, msg.value);
732     }
733 
734     function _eraseNodeHierarchy(uint idx, bytes32[] memory labels, bytes32 node) internal {
735         // Take ownership of the node
736         ens.setSubnodeOwner(node, labels[idx], address(this));
737         node = keccak256(abi.encodePacked(node, labels[idx]));
738 
739         // Recurse if there are more labels
740         if (idx > 0) {
741             _eraseNodeHierarchy(idx - 1, labels, node);
742         }
743 
744         // Erase the resolver and owner records
745         ens.setResolver(node, address(0x0));
746         ens.setOwner(node, address(0x0));
747     }
748 
749     /**
750      * @dev Assign the owner in ENS, if we're still the registrar
751      *
752      * @param _hash hash to change owner
753      * @param _newOwner new owner to transfer to
754      */
755     function trySetSubnodeOwner(bytes32 _hash, address _newOwner) internal {
756         if (ens.owner(rootNode) == address(this))
757             ens.setSubnodeOwner(rootNode, _hash, _newOwner);
758     }
759 
760     /**
761      * @dev Returns the maximum of two unsigned integers
762      *
763      * @param a A number to compare
764      * @param b A number to compare
765      * @return The maximum of two unsigned integers
766      */
767     function max(uint a, uint b) internal pure returns (uint) {
768         if (a > b)
769             return a;
770         else
771             return b;
772     }
773 
774     /**
775      * @dev Returns the minimum of two unsigned integers
776      *
777      * @param a A number to compare
778      * @param b A number to compare
779      * @return The minimum of two unsigned integers
780      */
781     function min(uint a, uint b) internal pure returns (uint) {
782         if (a < b)
783             return a;
784         else
785             return b;
786     }
787 
788     /**
789      * @dev Returns the length of a given string
790      *
791      * @param s The string to measure the length of
792      * @return The length of the input string
793      */
794     function strlen(string memory s) internal pure returns (uint) {
795         s; // Don't warn about unused variables
796         // Starting here means the LSB will be the byte we care about
797         uint ptr;
798         uint end;
799         assembly {
800             ptr := add(s, 1)
801             end := add(mload(s), ptr)
802         }
803         uint len = 0;
804         for (len; ptr < end; len++) {
805             uint8 b;
806             assembly { b := and(mload(ptr), 0xFF) }
807             if (b < 0x80) {
808                 ptr += 1;
809             } else if (b < 0xE0) {
810                 ptr += 2;
811             } else if (b < 0xF0) {
812                 ptr += 3;
813             } else if (b < 0xF8) {
814                 ptr += 4;
815             } else if (b < 0xFC) {
816                 ptr += 5;
817             } else {
818                 ptr += 6;
819             }
820         }
821         return len;
822     }
823 
824 }
825 
826 // File: contracts/CustodialContract.sol
827 
828 pragma solidity ^0.5.0;
829 
830 
831 
832 
833 contract CustodialContract is WhitelistAdminRole {
834     HashRegistrar registrar;
835 
836     mapping (bytes32 => Ownership) domains;
837 
838     struct Ownership {
839         address primary;
840         address secondary;
841     }
842 
843     event NewPrimaryOwner(bytes32 indexed labelHash, address indexed owner);
844     event NewSecondaryOwner(bytes32 indexed labelHash, address indexed owner);
845     event DomainWithdrawal(bytes32 indexed labelHash, address indexed recipient);
846 
847     function() external payable {}
848     
849     constructor(address _registrar) public {
850         registrar = HashRegistrar(_registrar);
851     }
852 
853     modifier onlyOwner(bytes32 _labelHash) {
854         require(isOwner(_labelHash));
855         _;
856     }
857 
858     modifier onlyTransferred(bytes32 _labelHash) {
859         require(isTransferred(_labelHash));
860         _;
861     }
862 
863     function isTransferred(bytes32 _labelHash) public view returns (bool) {
864         (, address deedAddress, , , ) = registrar.entries(_labelHash);
865         Deed deed = Deed(deedAddress);
866 
867         return (deed.owner() == address(this));
868     }
869 
870     function isOwner(bytes32 _labelHash) public view returns (bool) {
871         return (isPrimaryOwner(_labelHash) || isSecondaryOwner(_labelHash));
872     }
873 
874     function isPrimaryOwner(bytes32 _labelHash) public view returns (bool) {
875         (, address deedAddress, , , ) = registrar.entries(_labelHash);
876         Deed deed = Deed(deedAddress);
877 
878         if (
879             domains[_labelHash].primary == address(0) &&
880             deed.previousOwner() == msg.sender
881         ) {
882             return true;
883         }
884         return (domains[_labelHash].primary == msg.sender);
885     }
886 
887     function isSecondaryOwner(bytes32 _labelHash) public view returns (bool) {
888         return (domains[_labelHash].secondary == msg.sender);
889     }
890 
891     function setPrimaryOwners(bytes32[] memory _labelHashes, address _address) public {
892         for (uint i=0; i<_labelHashes.length; i++) {
893             setPrimaryOwner(_labelHashes[i], _address);
894         }
895     }
896 
897     function setSecondaryOwners(bytes32[] memory _labelHashes, address _address) public {
898         for (uint i=0; i<_labelHashes.length; i++) {
899             setSecondaryOwner(_labelHashes[i], _address);
900         }
901     }
902 
903     function setPrimaryOwner(bytes32 _labelHash, address _address) public onlyTransferred(_labelHash) onlyOwner(_labelHash) {
904         domains[_labelHash].primary = _address;
905         emit NewPrimaryOwner(_labelHash, _address);
906     }
907 
908     function setSecondaryOwner(bytes32 _labelHash, address _address) public onlyTransferred(_labelHash) onlyOwner(_labelHash) {
909         domains[_labelHash].secondary = _address;
910         emit NewSecondaryOwner(_labelHash, _address);
911     }
912 
913     function setPrimaryAndSecondaryOwner(bytes32 _labelHash, address _primary, address _secondary) public onlyTransferred(_labelHash) onlyOwner(_labelHash) {
914         setPrimaryOwner(_labelHash, _primary);
915         setSecondaryOwner(_labelHash, _secondary);
916     }
917 
918     function withdrawDomain(bytes32 _labelHash, address payable _address) public onlyTransferred(_labelHash) onlyOwner(_labelHash) {
919         domains[_labelHash].primary = address(0);
920         domains[_labelHash].secondary = address(0);
921         registrar.transfer(_labelHash, _address);
922         emit DomainWithdrawal(_labelHash, _address);
923     }
924 
925     function call(address _to, bytes memory _data) public payable onlyWhitelistAdmin {
926         require(_to != address(registrar));
927         (bool success,) = _to.call.value(msg.value)(_data);
928         require(success);
929     }
930 }