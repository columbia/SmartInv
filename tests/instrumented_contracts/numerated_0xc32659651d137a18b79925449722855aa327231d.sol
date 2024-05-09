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
19 
20     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
21     function setResolver(bytes32 node, address resolver) external;
22     function setOwner(bytes32 node, address owner) external;
23     function setTTL(bytes32 node, uint64 ttl) external;
24     function owner(bytes32 node) external view returns (address);
25     function resolver(bytes32 node) external view returns (address);
26     function ttl(bytes32 node) external view returns (uint64);
27 
28 }
29 
30 // File: @ensdomains/ens/contracts/Deed.sol
31 
32 pragma solidity >=0.4.24;
33 
34 interface Deed {
35 
36     function setOwner(address payable newOwner) external;
37     function setRegistrar(address newRegistrar) external;
38     function setBalance(uint newValue, bool throwOnFailure) external;
39     function closeDeed(uint refundRatio) external;
40     function destroyDeed() external;
41 
42     function owner() external view returns (address);
43     function previousOwner() external view returns (address);
44     function value() external view returns (uint);
45     function creationDate() external view returns (uint);
46 
47 }
48 
49 // File: @ensdomains/ens/contracts/DeedImplementation.sol
50 
51 pragma solidity ^0.5.0;
52 
53 
54 /**
55  * @title Deed to hold ether in exchange for ownership of a node
56  * @dev The deed can be controlled only by the registrar and can only send ether back to the owner.
57  */
58 contract DeedImplementation is Deed {
59 
60     address payable constant burn = address(0xdead);
61 
62     address payable private _owner;
63     address private _previousOwner;
64     address private _registrar;
65 
66     uint private _creationDate;
67     uint private _value;
68 
69     bool active;
70 
71     event OwnerChanged(address newOwner);
72     event DeedClosed();
73 
74     modifier onlyRegistrar {
75         require(msg.sender == _registrar);
76         _;
77     }
78 
79     modifier onlyActive {
80         require(active);
81         _;
82     }
83 
84     constructor(address payable initialOwner) public payable {
85         _owner = initialOwner;
86         _registrar = msg.sender;
87         _creationDate = now;
88         active = true;
89         _value = msg.value;
90     }
91 
92     function setOwner(address payable newOwner) external onlyRegistrar {
93         require(newOwner != address(0x0));
94         _previousOwner = _owner;  // This allows contracts to check who sent them the ownership
95         _owner = newOwner;
96         emit OwnerChanged(newOwner);
97     }
98 
99     function setRegistrar(address newRegistrar) external onlyRegistrar {
100         _registrar = newRegistrar;
101     }
102 
103     function setBalance(uint newValue, bool throwOnFailure) external onlyRegistrar onlyActive {
104         // Check if it has enough balance to set the value
105         require(_value >= newValue);
106         _value = newValue;
107         // Send the difference to the owner
108         require(_owner.send(address(this).balance - newValue) || !throwOnFailure);
109     }
110 
111     /**
112      * @dev Close a deed and refund a specified fraction of the bid value
113      *
114      * @param refundRatio The amount*1/1000 to refund
115      */
116     function closeDeed(uint refundRatio) external onlyRegistrar onlyActive {
117         active = false;
118         require(burn.send(((1000 - refundRatio) * address(this).balance)/1000));
119         emit DeedClosed();
120         _destroyDeed();
121     }
122 
123     /**
124      * @dev Close a deed and refund a specified fraction of the bid value
125      */
126     function destroyDeed() external {
127         _destroyDeed();
128     }
129 
130     function owner() external view returns (address) {
131         return _owner;
132     }
133 
134     function previousOwner() external view returns (address) {
135         return _previousOwner;
136     }
137 
138     function value() external view returns (uint) {
139         return _value;
140     }
141 
142     function creationDate() external view returns (uint) {
143         _creationDate;
144     }
145 
146     function _destroyDeed() internal {
147         require(!active);
148 
149         // Instead of selfdestruct(owner), invoke owner fallback function to allow
150         // owner to log an event if desired; but owner should also be aware that
151         // its fallback function can also be invoked by setBalance
152         if (_owner.send(address(this).balance)) {
153             selfdestruct(burn);
154         }
155     }
156 }
157 
158 // File: @ensdomains/ens/contracts/Registrar.sol
159 
160 pragma solidity >=0.4.24;
161 
162 
163 interface Registrar {
164 
165     enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }
166 
167     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
168     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
169     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
170     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
171     event HashReleased(bytes32 indexed hash, uint value);
172     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
173 
174     function startAuction(bytes32 _hash) external;
175     function startAuctions(bytes32[] calldata _hashes) external;
176     function newBid(bytes32 sealedBid) external payable;
177     function startAuctionsAndBid(bytes32[] calldata hashes, bytes32 sealedBid) external payable;
178     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) external;
179     function cancelBid(address bidder, bytes32 seal) external;
180     function finalizeAuction(bytes32 _hash) external;
181     function transfer(bytes32 _hash, address payable newOwner) external;
182     function releaseDeed(bytes32 _hash) external;
183     function invalidateName(string calldata unhashedName) external;
184     function eraseNode(bytes32[] calldata labels) external;
185     function transferRegistrars(bytes32 _hash) external;
186     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) external;
187     function entries(bytes32 _hash) external view returns (Mode, address, uint, uint, uint);
188 }
189 
190 // File: @ensdomains/ens/contracts/HashRegistrar.sol
191 
192 pragma solidity ^0.5.0;
193 
194 
195 /*
196 
197 Temporary Hash Registrar
198 ========================
199 
200 This is a simplified version of a hash registrar. It is purporsefully limited:
201 names cannot be six letters or shorter, new auctions will stop after 4 years.
202 
203 The plan is to test the basic features and then move to a new contract in at most
204 2 years, when some sort of renewal mechanism will be enabled.
205 */
206 
207 
208 
209 
210 /**
211  * @title Registrar
212  * @dev The registrar handles the auction process for each subnode of the node it owns.
213  */
214 contract HashRegistrar is Registrar {
215     ENS public ens;
216     bytes32 public rootNode;
217 
218     mapping (bytes32 => Entry) _entries;
219     mapping (address => mapping (bytes32 => Deed)) public sealedBids;
220 
221     uint32 constant totalAuctionLength = 5 days;
222     uint32 constant revealPeriod = 48 hours;
223     uint32 public constant launchLength = 8 weeks;
224 
225     uint constant minPrice = 0.01 ether;
226     uint public registryStarted;
227 
228     struct Entry {
229         Deed deed;
230         uint registrationDate;
231         uint value;
232         uint highestBid;
233     }
234 
235     modifier inState(bytes32 _hash, Mode _state) {
236         require(state(_hash) == _state);
237         _;
238     }
239 
240     modifier onlyOwner(bytes32 _hash) {
241         require(state(_hash) == Mode.Owned && msg.sender == _entries[_hash].deed.owner());
242         _;
243     }
244 
245     modifier registryOpen() {
246         require(now >= registryStarted && now <= registryStarted + (365 * 4) * 1 days && ens.owner(rootNode) == address(this));
247         _;
248     }
249 
250     /**
251      * @dev Constructs a new Registrar, with the provided address as the owner of the root node.
252      *
253      * @param _ens The address of the ENS
254      * @param _rootNode The hash of the rootnode.
255      */
256     constructor(ENS _ens, bytes32 _rootNode, uint _startDate) public {
257         ens = _ens;
258         rootNode = _rootNode;
259         registryStarted = _startDate > 0 ? _startDate : now;
260     }
261 
262     /**
263      * @dev Start an auction for an available hash
264      *
265      * @param _hash The hash to start an auction on
266      */
267     function startAuction(bytes32 _hash) external {
268         _startAuction(_hash);
269     }
270 
271     /**
272      * @dev Start multiple auctions for better anonymity
273      *
274      * Anyone can start an auction by sending an array of hashes that they want to bid for.
275      * Arrays are sent so that someone can open up an auction for X dummy hashes when they
276      * are only really interested in bidding for one. This will increase the cost for an
277      * attacker to simply bid blindly on all new auctions. Dummy auctions that are
278      * open but not bid on are closed after a week.
279      *
280      * @param _hashes An array of hashes, at least one of which you presumably want to bid on
281      */
282     function startAuctions(bytes32[] calldata _hashes) external {
283         _startAuctions(_hashes);
284     }
285 
286     /**
287      * @dev Submit a new sealed bid on a desired hash in a blind auction
288      *
289      * Bids are sent by sending a message to the main contract with a hash and an amount. The hash
290      * contains information about the bid, including the bidded hash, the bid amount, and a random
291      * salt. Bids are not tied to any one auction until they are revealed. The value of the bid
292      * itself can be masqueraded by sending more than the value of your actual bid. This is
293      * followed by a 48h reveal period. Bids revealed after this period will be burned and the ether unrecoverable.
294      * Since this is an auction, it is expected that most public hashes, like known domains and common dictionary
295      * words, will have multiple bidders pushing the price up.
296      *
297      * @param sealedBid A sealedBid, created by the shaBid function
298      */
299     function newBid(bytes32 sealedBid) external payable {
300         _newBid(sealedBid);
301     }
302 
303     /**
304      * @dev Start a set of auctions and bid on one of them
305      *
306      * This method functions identically to calling `startAuctions` followed by `newBid`,
307      * but all in one transaction.
308      *
309      * @param hashes A list of hashes to start auctions on.
310      * @param sealedBid A sealed bid for one of the auctions.
311      */
312     function startAuctionsAndBid(bytes32[] calldata hashes, bytes32 sealedBid) external payable {
313         _startAuctions(hashes);
314         _newBid(sealedBid);
315     }
316 
317     /**
318      * @dev Submit the properties of a bid to reveal them
319      *
320      * @param _hash The node in the sealedBid
321      * @param _value The bid amount in the sealedBid
322      * @param _salt The sale in the sealedBid
323      */
324     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) external {
325         bytes32 seal = shaBid(_hash, msg.sender, _value, _salt);
326         Deed bid = sealedBids[msg.sender][seal];
327         require(address(bid) != address(0x0));
328 
329         sealedBids[msg.sender][seal] = Deed(address(0x0));
330         Entry storage h = _entries[_hash];
331         uint value = min(_value, bid.value());
332         bid.setBalance(value, true);
333 
334         Mode auctionState = state(_hash);
335         if (auctionState == Mode.Owned) {
336             // Too late! Bidder loses their bid. Gets 0.5% back.
337             bid.closeDeed(5);
338             emit BidRevealed(_hash, msg.sender, value, 1);
339         } else if (auctionState != Mode.Reveal) {
340             // Invalid phase
341             revert();
342         } else if (value < minPrice || bid.creationDate() > h.registrationDate - revealPeriod) {
343             // Bid too low or too late, refund 99.5%
344             bid.closeDeed(995);
345             emit BidRevealed(_hash, msg.sender, value, 0);
346         } else if (value > h.highestBid) {
347             // New winner
348             // Cancel the other bid, refund 99.5%
349             if (address(h.deed) != address(0x0)) {
350                 Deed previousWinner = h.deed;
351                 previousWinner.closeDeed(995);
352             }
353 
354             // Set new winner
355             // Per the rules of a vickery auction, the value becomes the previous highestBid
356             h.value = h.highestBid;  // will be zero if there's only 1 bidder
357             h.highestBid = value;
358             h.deed = bid;
359             emit BidRevealed(_hash, msg.sender, value, 2);
360         } else if (value > h.value) {
361             // Not winner, but affects second place
362             h.value = value;
363             bid.closeDeed(995);
364             emit BidRevealed(_hash, msg.sender, value, 3);
365         } else {
366             // Bid doesn't affect auction
367             bid.closeDeed(995);
368             emit BidRevealed(_hash, msg.sender, value, 4);
369         }
370     }
371 
372     /**
373      * @dev Cancel a bid
374      *
375      * @param seal The value returned by the shaBid function
376      */
377     function cancelBid(address bidder, bytes32 seal) external {
378         Deed bid = sealedBids[bidder][seal];
379         
380         // If a sole bidder does not `unsealBid` in time, they have a few more days
381         // where they can call `startAuction` (again) and then `unsealBid` during
382         // the revealPeriod to get back their bid value.
383         // For simplicity, they should call `startAuction` within
384         // 9 days (2 weeks - totalAuctionLength), otherwise their bid will be
385         // cancellable by anyone.
386         require(address(bid) != address(0x0) && now >= bid.creationDate() + totalAuctionLength + 2 weeks);
387 
388         // Send the canceller 0.5% of the bid, and burn the rest.
389         bid.setOwner(msg.sender);
390         bid.closeDeed(5);
391         sealedBids[bidder][seal] = Deed(0);
392         emit BidRevealed(seal, bidder, 0, 5);
393     }
394 
395     /**
396      * @dev Finalize an auction after the registration date has passed
397      *
398      * @param _hash The hash of the name the auction is for
399      */
400     function finalizeAuction(bytes32 _hash) external onlyOwner(_hash) {
401         Entry storage h = _entries[_hash];
402         
403         // Handles the case when there's only a single bidder (h.value is zero)
404         h.value = max(h.value, minPrice);
405         h.deed.setBalance(h.value, true);
406 
407         trySetSubnodeOwner(_hash, h.deed.owner());
408         emit HashRegistered(_hash, h.deed.owner(), h.value, h.registrationDate);
409     }
410 
411     /**
412      * @dev The owner of a domain may transfer it to someone else at any time.
413      *
414      * @param _hash The node to transfer
415      * @param newOwner The address to transfer ownership to
416      */
417     function transfer(bytes32 _hash, address payable newOwner) external onlyOwner(_hash) {
418         require(newOwner != address(0x0));
419 
420         Entry storage h = _entries[_hash];
421         h.deed.setOwner(newOwner);
422         trySetSubnodeOwner(_hash, newOwner);
423     }
424 
425     /**
426      * @dev After some time, or if we're no longer the registrar, the owner can release
427      *      the name and get their ether back.
428      *
429      * @param _hash The node to release
430      */
431     function releaseDeed(bytes32 _hash) external onlyOwner(_hash) {
432         Entry storage h = _entries[_hash];
433         Deed deedContract = h.deed;
434 
435         require(now >= h.registrationDate + 365 days || ens.owner(rootNode) != address(this));
436 
437         h.value = 0;
438         h.highestBid = 0;
439         h.deed = Deed(0);
440 
441         _tryEraseSingleNode(_hash);
442         deedContract.closeDeed(1000);
443         emit HashReleased(_hash, h.value);        
444     }
445 
446     /**
447      * @dev Submit a name 6 characters long or less. If it has been registered,
448      *      the submitter will earn 50% of the deed value. 
449      * 
450      * We are purposefully handicapping the simplified registrar as a way 
451      * to force it into being restructured in a few years.
452      *
453      * @param unhashedName An invalid name to search for in the registry.
454      */
455     function invalidateName(string calldata unhashedName)
456         external
457         inState(keccak256(abi.encode(unhashedName)), Mode.Owned)
458     {
459         require(strlen(unhashedName) <= 6);
460         bytes32 hash = keccak256(abi.encode(unhashedName));
461 
462         Entry storage h = _entries[hash];
463 
464         _tryEraseSingleNode(hash);
465 
466         if (address(h.deed) != address(0x0)) {
467             // Reward the discoverer with 50% of the deed
468             // The previous owner gets 50%
469             h.value = max(h.value, minPrice);
470             h.deed.setBalance(h.value/2, false);
471             h.deed.setOwner(msg.sender);
472             h.deed.closeDeed(1000);
473         }
474 
475         emit HashInvalidated(hash, unhashedName, h.value, h.registrationDate);
476 
477         h.value = 0;
478         h.highestBid = 0;
479         h.deed = Deed(0);
480     }
481 
482     /**
483      * @dev Allows anyone to delete the owner and resolver records for a (subdomain of) a
484      *      name that is not currently owned in the registrar. If passing, eg, 'foo.bar.eth',
485      *      the owner and resolver fields on 'foo.bar.eth' and 'bar.eth' will all be cleared.
486      *
487      * @param labels A series of label hashes identifying the name to zero out, rooted at the
488      *        registrar's root. Must contain at least one element. For instance, to zero 
489      *        'foo.bar.eth' on a registrar that owns '.eth', pass an array containing
490      *        [keccak256('foo'), keccak256('bar')].
491      */
492     function eraseNode(bytes32[] calldata labels) external {
493         require(labels.length != 0);
494         require(state(labels[labels.length - 1]) != Mode.Owned);
495 
496         _eraseNodeHierarchy(labels.length - 1, labels, rootNode);
497     }
498 
499     /**
500      * @dev Transfers the deed to the current registrar, if different from this one.
501      *
502      * Used during the upgrade process to a permanent registrar.
503      *
504      * @param _hash The name hash to transfer.
505      */
506     function transferRegistrars(bytes32 _hash) external onlyOwner(_hash) {
507         address registrar = ens.owner(rootNode);
508         require(registrar != address(this));
509 
510         // Migrate the deed
511         Entry storage h = _entries[_hash];
512         h.deed.setRegistrar(registrar);
513 
514         // Call the new registrar to accept the transfer
515         Registrar(registrar).acceptRegistrarTransfer(_hash, h.deed, h.registrationDate);
516 
517         // Zero out the Entry
518         h.deed = Deed(0);
519         h.registrationDate = 0;
520         h.value = 0;
521         h.highestBid = 0;
522     }
523 
524     /**
525      * @dev Accepts a transfer from a previous registrar; stubbed out here since there
526      *      is no previous registrar implementing this interface.
527      *
528      * @param hash The sha3 hash of the label to transfer.
529      * @param deed The Deed object for the name being transferred in.
530      * @param registrationDate The date at which the name was originally registered.
531      */
532     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) external {
533         hash; deed; registrationDate; // Don't warn about unused variables
534     }
535 
536     function entries(bytes32 _hash) external view returns (Mode, address, uint, uint, uint) {
537         Entry storage h = _entries[_hash];
538         return (state(_hash), address(h.deed), h.registrationDate, h.value, h.highestBid);
539     }
540 
541     // State transitions for names:
542     //   Open -> Auction (startAuction)
543     //   Auction -> Reveal
544     //   Reveal -> Owned
545     //   Reveal -> Open (if nobody bid)
546     //   Owned -> Open (releaseDeed or invalidateName)
547     function state(bytes32 _hash) public view returns (Mode) {
548         Entry storage entry = _entries[_hash];
549 
550         if (!isAllowed(_hash, now)) {
551             return Mode.NotYetAvailable;
552         } else if (now < entry.registrationDate) {
553             if (now < entry.registrationDate - revealPeriod) {
554                 return Mode.Auction;
555             } else {
556                 return Mode.Reveal;
557             }
558         } else {
559             if (entry.highestBid == 0) {
560                 return Mode.Open;
561             } else {
562                 return Mode.Owned;
563             }
564         }
565     }
566 
567     /**
568      * @dev Determines if a name is available for registration yet
569      *
570      * Each name will be assigned a random date in which its auction
571      * can be started, from 0 to 8 weeks
572      *
573      * @param _hash The hash to start an auction on
574      * @param _timestamp The timestamp to query about
575      */
576     function isAllowed(bytes32 _hash, uint _timestamp) public view returns (bool allowed) {
577         return _timestamp > getAllowedTime(_hash);
578     }
579 
580     /**
581      * @dev Returns available date for hash
582      *
583      * The available time from the `registryStarted` for a hash is proportional
584      * to its numeric value.
585      *
586      * @param _hash The hash to start an auction on
587      */
588     function getAllowedTime(bytes32 _hash) public view returns (uint) {
589         return registryStarted + ((launchLength * (uint(_hash) >> 128)) >> 128);
590         // Right shift operator: a >> b == a / 2**b
591     }
592 
593     /**
594      * @dev Hash the values required for a secret bid
595      *
596      * @param hash The node corresponding to the desired namehash
597      * @param value The bid amount
598      * @param salt A random value to ensure secrecy of the bid
599      * @return The hash of the bid values
600      */
601     function shaBid(bytes32 hash, address owner, uint value, bytes32 salt) public pure returns (bytes32) {
602         return keccak256(abi.encodePacked(hash, owner, value, salt));
603     }
604 
605     function _tryEraseSingleNode(bytes32 label) internal {
606         if (ens.owner(rootNode) == address(this)) {
607             ens.setSubnodeOwner(rootNode, label, address(this));
608             bytes32 node = keccak256(abi.encodePacked(rootNode, label));
609             ens.setResolver(node, address(0x0));
610             ens.setOwner(node, address(0x0));
611         }
612     }
613 
614     function _startAuction(bytes32 _hash) internal registryOpen() {
615         Mode mode = state(_hash);
616         if (mode == Mode.Auction) return;
617         require(mode == Mode.Open);
618 
619         Entry storage newAuction = _entries[_hash];
620         newAuction.registrationDate = now + totalAuctionLength;
621         newAuction.value = 0;
622         newAuction.highestBid = 0;
623         emit AuctionStarted(_hash, newAuction.registrationDate);
624     }
625 
626     function _startAuctions(bytes32[] memory _hashes) internal {
627         for (uint i = 0; i < _hashes.length; i ++) {
628             _startAuction(_hashes[i]);
629         }
630     }
631 
632     function _newBid(bytes32 sealedBid) internal {
633         require(address(sealedBids[msg.sender][sealedBid]) == address(0x0));
634         require(msg.value >= minPrice);
635 
636         // Creates a new hash contract with the owner
637         Deed bid = (new DeedImplementation).value(msg.value)(msg.sender);
638         sealedBids[msg.sender][sealedBid] = bid;
639         emit NewBid(sealedBid, msg.sender, msg.value);
640     }
641 
642     function _eraseNodeHierarchy(uint idx, bytes32[] memory labels, bytes32 node) internal {
643         // Take ownership of the node
644         ens.setSubnodeOwner(node, labels[idx], address(this));
645         node = keccak256(abi.encodePacked(node, labels[idx]));
646 
647         // Recurse if there are more labels
648         if (idx > 0) {
649             _eraseNodeHierarchy(idx - 1, labels, node);
650         }
651 
652         // Erase the resolver and owner records
653         ens.setResolver(node, address(0x0));
654         ens.setOwner(node, address(0x0));
655     }
656 
657     /**
658      * @dev Assign the owner in ENS, if we're still the registrar
659      *
660      * @param _hash hash to change owner
661      * @param _newOwner new owner to transfer to
662      */
663     function trySetSubnodeOwner(bytes32 _hash, address _newOwner) internal {
664         if (ens.owner(rootNode) == address(this))
665             ens.setSubnodeOwner(rootNode, _hash, _newOwner);
666     }
667 
668     /**
669      * @dev Returns the maximum of two unsigned integers
670      *
671      * @param a A number to compare
672      * @param b A number to compare
673      * @return The maximum of two unsigned integers
674      */
675     function max(uint a, uint b) internal pure returns (uint) {
676         if (a > b)
677             return a;
678         else
679             return b;
680     }
681 
682     /**
683      * @dev Returns the minimum of two unsigned integers
684      *
685      * @param a A number to compare
686      * @param b A number to compare
687      * @return The minimum of two unsigned integers
688      */
689     function min(uint a, uint b) internal pure returns (uint) {
690         if (a < b)
691             return a;
692         else
693             return b;
694     }
695 
696     /**
697      * @dev Returns the length of a given string
698      *
699      * @param s The string to measure the length of
700      * @return The length of the input string
701      */
702     function strlen(string memory s) internal pure returns (uint) {
703         s; // Don't warn about unused variables
704         // Starting here means the LSB will be the byte we care about
705         uint ptr;
706         uint end;
707         assembly {
708             ptr := add(s, 1)
709             end := add(mload(s), ptr)
710         }
711         uint len = 0;
712         for (len; ptr < end; len++) {
713             uint8 b;
714             assembly { b := and(mload(ptr), 0xFF) }
715             if (b < 0x80) {
716                 ptr += 1;
717             } else if (b < 0xE0) {
718                 ptr += 2;
719             } else if (b < 0xF0) {
720                 ptr += 3;
721             } else if (b < 0xF8) {
722                 ptr += 4;
723             } else if (b < 0xFC) {
724                 ptr += 5;
725             } else {
726                 ptr += 6;
727             }
728         }
729         return len;
730     }
731 
732 }
733 
734 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
735 
736 pragma solidity ^0.5.0;
737 
738 /**
739  * @title IERC165
740  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
741  */
742 interface IERC165 {
743     /**
744      * @notice Query if a contract implements an interface
745      * @param interfaceId The interface identifier, as specified in ERC-165
746      * @dev Interface identification is specified in ERC-165. This function
747      * uses less than 30,000 gas.
748      */
749     function supportsInterface(bytes4 interfaceId) external view returns (bool);
750 }
751 
752 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
753 
754 pragma solidity ^0.5.0;
755 
756 
757 /**
758  * @title ERC721 Non-Fungible Token Standard basic interface
759  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
760  */
761 contract IERC721 is IERC165 {
762     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
763     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
764     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
765 
766     function balanceOf(address owner) public view returns (uint256 balance);
767     function ownerOf(uint256 tokenId) public view returns (address owner);
768 
769     function approve(address to, uint256 tokenId) public;
770     function getApproved(uint256 tokenId) public view returns (address operator);
771 
772     function setApprovalForAll(address operator, bool _approved) public;
773     function isApprovedForAll(address owner, address operator) public view returns (bool);
774 
775     function transferFrom(address from, address to, uint256 tokenId) public;
776     function safeTransferFrom(address from, address to, uint256 tokenId) public;
777 
778     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
779 }
780 
781 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
782 
783 pragma solidity ^0.5.0;
784 
785 /**
786  * @title ERC721 token receiver interface
787  * @dev Interface for any contract that wants to support safeTransfers
788  * from ERC721 asset contracts.
789  */
790 contract IERC721Receiver {
791     /**
792      * @notice Handle the receipt of an NFT
793      * @dev The ERC721 smart contract calls this function on the recipient
794      * after a `safeTransfer`. This function MUST return the function selector,
795      * otherwise the caller will revert the transaction. The selector to be
796      * returned can be obtained as `this.onERC721Received.selector`. This
797      * function MAY throw to revert and reject the transfer.
798      * Note: the ERC721 contract address is always the message sender.
799      * @param operator The address which called `safeTransferFrom` function
800      * @param from The address which previously owned the token
801      * @param tokenId The NFT identifier which is being transferred
802      * @param data Additional data with no specified format
803      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
804      */
805     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
806     public returns (bytes4);
807 }
808 
809 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
810 
811 pragma solidity ^0.5.0;
812 
813 /**
814  * @title SafeMath
815  * @dev Unsigned math operations with safety checks that revert on error
816  */
817 library SafeMath {
818     /**
819     * @dev Multiplies two unsigned integers, reverts on overflow.
820     */
821     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
822         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
823         // benefit is lost if 'b' is also tested.
824         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
825         if (a == 0) {
826             return 0;
827         }
828 
829         uint256 c = a * b;
830         require(c / a == b);
831 
832         return c;
833     }
834 
835     /**
836     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
837     */
838     function div(uint256 a, uint256 b) internal pure returns (uint256) {
839         // Solidity only automatically asserts when dividing by 0
840         require(b > 0);
841         uint256 c = a / b;
842         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
843 
844         return c;
845     }
846 
847     /**
848     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
849     */
850     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
851         require(b <= a);
852         uint256 c = a - b;
853 
854         return c;
855     }
856 
857     /**
858     * @dev Adds two unsigned integers, reverts on overflow.
859     */
860     function add(uint256 a, uint256 b) internal pure returns (uint256) {
861         uint256 c = a + b;
862         require(c >= a);
863 
864         return c;
865     }
866 
867     /**
868     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
869     * reverts when dividing by zero.
870     */
871     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
872         require(b != 0);
873         return a % b;
874     }
875 }
876 
877 // File: openzeppelin-solidity/contracts/utils/Address.sol
878 
879 pragma solidity ^0.5.0;
880 
881 /**
882  * Utility library of inline functions on addresses
883  */
884 library Address {
885     /**
886      * Returns whether the target address is a contract
887      * @dev This function will return false if invoked during the constructor of a contract,
888      * as the code is not actually created until after the constructor finishes.
889      * @param account address of the account to check
890      * @return whether the target address is a contract
891      */
892     function isContract(address account) internal view returns (bool) {
893         uint256 size;
894         // XXX Currently there is no better way to check if there is a contract in an address
895         // than to check the size of the code at that address.
896         // See https://ethereum.stackexchange.com/a/14016/36603
897         // for more details about how this works.
898         // TODO Check this again before the Serenity release, because all addresses will be
899         // contracts then.
900         // solhint-disable-next-line no-inline-assembly
901         assembly { size := extcodesize(account) }
902         return size > 0;
903     }
904 }
905 
906 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
907 
908 pragma solidity ^0.5.0;
909 
910 
911 /**
912  * @title ERC165
913  * @author Matt Condon (@shrugs)
914  * @dev Implements ERC165 using a lookup table.
915  */
916 contract ERC165 is IERC165 {
917     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
918     /**
919      * 0x01ffc9a7 ===
920      *     bytes4(keccak256('supportsInterface(bytes4)'))
921      */
922 
923     /**
924      * @dev a mapping of interface id to whether or not it's supported
925      */
926     mapping(bytes4 => bool) private _supportedInterfaces;
927 
928     /**
929      * @dev A contract implementing SupportsInterfaceWithLookup
930      * implement ERC165 itself
931      */
932     constructor () internal {
933         _registerInterface(_INTERFACE_ID_ERC165);
934     }
935 
936     /**
937      * @dev implement supportsInterface(bytes4) using a lookup table
938      */
939     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
940         return _supportedInterfaces[interfaceId];
941     }
942 
943     /**
944      * @dev internal method for registering an interface
945      */
946     function _registerInterface(bytes4 interfaceId) internal {
947         require(interfaceId != 0xffffffff);
948         _supportedInterfaces[interfaceId] = true;
949     }
950 }
951 
952 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
953 
954 pragma solidity ^0.5.0;
955 
956 
957 
958 
959 
960 
961 /**
962  * @title ERC721 Non-Fungible Token Standard basic implementation
963  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
964  */
965 contract ERC721 is ERC165, IERC721 {
966     using SafeMath for uint256;
967     using Address for address;
968 
969     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
970     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
971     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
972 
973     // Mapping from token ID to owner
974     mapping (uint256 => address) private _tokenOwner;
975 
976     // Mapping from token ID to approved address
977     mapping (uint256 => address) private _tokenApprovals;
978 
979     // Mapping from owner to number of owned token
980     mapping (address => uint256) private _ownedTokensCount;
981 
982     // Mapping from owner to operator approvals
983     mapping (address => mapping (address => bool)) private _operatorApprovals;
984 
985     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
986     /*
987      * 0x80ac58cd ===
988      *     bytes4(keccak256('balanceOf(address)')) ^
989      *     bytes4(keccak256('ownerOf(uint256)')) ^
990      *     bytes4(keccak256('approve(address,uint256)')) ^
991      *     bytes4(keccak256('getApproved(uint256)')) ^
992      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
993      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
994      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
995      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
996      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
997      */
998 
999     constructor () public {
1000         // register the supported interfaces to conform to ERC721 via ERC165
1001         _registerInterface(_INTERFACE_ID_ERC721);
1002     }
1003 
1004     /**
1005      * @dev Gets the balance of the specified address
1006      * @param owner address to query the balance of
1007      * @return uint256 representing the amount owned by the passed address
1008      */
1009     function balanceOf(address owner) public view returns (uint256) {
1010         require(owner != address(0));
1011         return _ownedTokensCount[owner];
1012     }
1013 
1014     /**
1015      * @dev Gets the owner of the specified token ID
1016      * @param tokenId uint256 ID of the token to query the owner of
1017      * @return owner address currently marked as the owner of the given token ID
1018      */
1019     function ownerOf(uint256 tokenId) public view returns (address) {
1020         address owner = _tokenOwner[tokenId];
1021         require(owner != address(0));
1022         return owner;
1023     }
1024 
1025     /**
1026      * @dev Approves another address to transfer the given token ID
1027      * The zero address indicates there is no approved address.
1028      * There can only be one approved address per token at a given time.
1029      * Can only be called by the token owner or an approved operator.
1030      * @param to address to be approved for the given token ID
1031      * @param tokenId uint256 ID of the token to be approved
1032      */
1033     function approve(address to, uint256 tokenId) public {
1034         address owner = ownerOf(tokenId);
1035         require(to != owner);
1036         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1037 
1038         _tokenApprovals[tokenId] = to;
1039         emit Approval(owner, to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev Gets the approved address for a token ID, or zero if no address set
1044      * Reverts if the token ID does not exist.
1045      * @param tokenId uint256 ID of the token to query the approval of
1046      * @return address currently approved for the given token ID
1047      */
1048     function getApproved(uint256 tokenId) public view returns (address) {
1049         require(_exists(tokenId));
1050         return _tokenApprovals[tokenId];
1051     }
1052 
1053     /**
1054      * @dev Sets or unsets the approval of a given operator
1055      * An operator is allowed to transfer all tokens of the sender on their behalf
1056      * @param to operator address to set the approval
1057      * @param approved representing the status of the approval to be set
1058      */
1059     function setApprovalForAll(address to, bool approved) public {
1060         require(to != msg.sender);
1061         _operatorApprovals[msg.sender][to] = approved;
1062         emit ApprovalForAll(msg.sender, to, approved);
1063     }
1064 
1065     /**
1066      * @dev Tells whether an operator is approved by a given owner
1067      * @param owner owner address which you want to query the approval of
1068      * @param operator operator address which you want to query the approval of
1069      * @return bool whether the given operator is approved by the given owner
1070      */
1071     function isApprovedForAll(address owner, address operator) public view returns (bool) {
1072         return _operatorApprovals[owner][operator];
1073     }
1074 
1075     /**
1076      * @dev Transfers the ownership of a given token ID to another address
1077      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1078      * Requires the msg sender to be the owner, approved, or operator
1079      * @param from current owner of the token
1080      * @param to address to receive the ownership of the given token ID
1081      * @param tokenId uint256 ID of the token to be transferred
1082     */
1083     function transferFrom(address from, address to, uint256 tokenId) public {
1084         require(_isApprovedOrOwner(msg.sender, tokenId));
1085 
1086         _transferFrom(from, to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Safely transfers the ownership of a given token ID to another address
1091      * If the target address is a contract, it must implement `onERC721Received`,
1092      * which is called upon a safe transfer, and return the magic value
1093      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1094      * the transfer is reverted.
1095      *
1096      * Requires the msg sender to be the owner, approved, or operator
1097      * @param from current owner of the token
1098      * @param to address to receive the ownership of the given token ID
1099      * @param tokenId uint256 ID of the token to be transferred
1100     */
1101     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1102         safeTransferFrom(from, to, tokenId, "");
1103     }
1104 
1105     /**
1106      * @dev Safely transfers the ownership of a given token ID to another address
1107      * If the target address is a contract, it must implement `onERC721Received`,
1108      * which is called upon a safe transfer, and return the magic value
1109      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1110      * the transfer is reverted.
1111      * Requires the msg sender to be the owner, approved, or operator
1112      * @param from current owner of the token
1113      * @param to address to receive the ownership of the given token ID
1114      * @param tokenId uint256 ID of the token to be transferred
1115      * @param _data bytes data to send along with a safe transfer check
1116      */
1117     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
1118         transferFrom(from, to, tokenId);
1119         require(_checkOnERC721Received(from, to, tokenId, _data));
1120     }
1121 
1122     /**
1123      * @dev Returns whether the specified token exists
1124      * @param tokenId uint256 ID of the token to query the existence of
1125      * @return whether the token exists
1126      */
1127     function _exists(uint256 tokenId) internal view returns (bool) {
1128         address owner = _tokenOwner[tokenId];
1129         return owner != address(0);
1130     }
1131 
1132     /**
1133      * @dev Returns whether the given spender can transfer a given token ID
1134      * @param spender address of the spender to query
1135      * @param tokenId uint256 ID of the token to be transferred
1136      * @return bool whether the msg.sender is approved for the given token ID,
1137      *    is an operator of the owner, or is the owner of the token
1138      */
1139     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1140         address owner = ownerOf(tokenId);
1141         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1142     }
1143 
1144     /**
1145      * @dev Internal function to mint a new token
1146      * Reverts if the given token ID already exists
1147      * @param to The address that will own the minted token
1148      * @param tokenId uint256 ID of the token to be minted
1149      */
1150     function _mint(address to, uint256 tokenId) internal {
1151         require(to != address(0));
1152         require(!_exists(tokenId));
1153 
1154         _tokenOwner[tokenId] = to;
1155         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
1156 
1157         emit Transfer(address(0), to, tokenId);
1158     }
1159 
1160     /**
1161      * @dev Internal function to burn a specific token
1162      * Reverts if the token does not exist
1163      * Deprecated, use _burn(uint256) instead.
1164      * @param owner owner of the token to burn
1165      * @param tokenId uint256 ID of the token being burned
1166      */
1167     function _burn(address owner, uint256 tokenId) internal {
1168         require(ownerOf(tokenId) == owner);
1169 
1170         _clearApproval(tokenId);
1171 
1172         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
1173         _tokenOwner[tokenId] = address(0);
1174 
1175         emit Transfer(owner, address(0), tokenId);
1176     }
1177 
1178     /**
1179      * @dev Internal function to burn a specific token
1180      * Reverts if the token does not exist
1181      * @param tokenId uint256 ID of the token being burned
1182      */
1183     function _burn(uint256 tokenId) internal {
1184         _burn(ownerOf(tokenId), tokenId);
1185     }
1186 
1187     /**
1188      * @dev Internal function to transfer ownership of a given token ID to another address.
1189      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1190      * @param from current owner of the token
1191      * @param to address to receive the ownership of the given token ID
1192      * @param tokenId uint256 ID of the token to be transferred
1193     */
1194     function _transferFrom(address from, address to, uint256 tokenId) internal {
1195         require(ownerOf(tokenId) == from);
1196         require(to != address(0));
1197 
1198         _clearApproval(tokenId);
1199 
1200         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
1201         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
1202 
1203         _tokenOwner[tokenId] = to;
1204 
1205         emit Transfer(from, to, tokenId);
1206     }
1207 
1208     /**
1209      * @dev Internal function to invoke `onERC721Received` on a target address
1210      * The call is not executed if the target address is not a contract
1211      * @param from address representing the previous owner of the given token ID
1212      * @param to target address that will receive the tokens
1213      * @param tokenId uint256 ID of the token to be transferred
1214      * @param _data bytes optional data to send along with the call
1215      * @return whether the call correctly returned the expected magic value
1216      */
1217     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1218         internal returns (bool)
1219     {
1220         if (!to.isContract()) {
1221             return true;
1222         }
1223 
1224         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1225         return (retval == _ERC721_RECEIVED);
1226     }
1227 
1228     /**
1229      * @dev Private function to clear current approval of a given token ID
1230      * @param tokenId uint256 ID of the token to be transferred
1231      */
1232     function _clearApproval(uint256 tokenId) private {
1233         if (_tokenApprovals[tokenId] != address(0)) {
1234             _tokenApprovals[tokenId] = address(0);
1235         }
1236     }
1237 }
1238 
1239 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1240 
1241 pragma solidity ^0.5.0;
1242 
1243 /**
1244  * @title Ownable
1245  * @dev The Ownable contract has an owner address, and provides basic authorization control
1246  * functions, this simplifies the implementation of "user permissions".
1247  */
1248 contract Ownable {
1249     address private _owner;
1250 
1251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1252 
1253     /**
1254      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1255      * account.
1256      */
1257     constructor () internal {
1258         _owner = msg.sender;
1259         emit OwnershipTransferred(address(0), _owner);
1260     }
1261 
1262     /**
1263      * @return the address of the owner.
1264      */
1265     function owner() public view returns (address) {
1266         return _owner;
1267     }
1268 
1269     /**
1270      * @dev Throws if called by any account other than the owner.
1271      */
1272     modifier onlyOwner() {
1273         require(isOwner());
1274         _;
1275     }
1276 
1277     /**
1278      * @return true if `msg.sender` is the owner of the contract.
1279      */
1280     function isOwner() public view returns (bool) {
1281         return msg.sender == _owner;
1282     }
1283 
1284     /**
1285      * @dev Allows the current owner to relinquish control of the contract.
1286      * @notice Renouncing to ownership will leave the contract without an owner.
1287      * It will not be possible to call the functions with the `onlyOwner`
1288      * modifier anymore.
1289      */
1290     function renounceOwnership() public onlyOwner {
1291         emit OwnershipTransferred(_owner, address(0));
1292         _owner = address(0);
1293     }
1294 
1295     /**
1296      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1297      * @param newOwner The address to transfer ownership to.
1298      */
1299     function transferOwnership(address newOwner) public onlyOwner {
1300         _transferOwnership(newOwner);
1301     }
1302 
1303     /**
1304      * @dev Transfers control of the contract to a newOwner.
1305      * @param newOwner The address to transfer ownership to.
1306      */
1307     function _transferOwnership(address newOwner) internal {
1308         require(newOwner != address(0));
1309         emit OwnershipTransferred(_owner, newOwner);
1310         _owner = newOwner;
1311     }
1312 }
1313 
1314 // File: @ensdomains/ethregistrar/contracts/BaseRegistrar.sol
1315 
1316 pragma solidity >=0.4.24;
1317 
1318 
1319 
1320 
1321 
1322 contract BaseRegistrar is ERC721, Ownable {
1323     uint constant public GRACE_PERIOD = 90 days;
1324 
1325     event ControllerAdded(address indexed controller);
1326     event ControllerRemoved(address indexed controller);
1327     event NameMigrated(uint256 indexed id, address indexed owner, uint expires);
1328     event NameRegistered(uint256 indexed id, address indexed owner, uint expires);
1329     event NameRenewed(uint256 indexed id, uint expires);
1330 
1331     // Expiration timestamp for migrated domains.
1332     uint public transferPeriodEnds;
1333 
1334     // The ENS registry
1335     ENS public ens;
1336 
1337     // The namehash of the TLD this registrar owns (eg, .eth)
1338     bytes32 public baseNode;
1339 
1340     // The interim registrar
1341     HashRegistrar public previousRegistrar;
1342 
1343     // A map of addresses that are authorised to register and renew names.
1344     mapping(address=>bool) public controllers;
1345 
1346     // Authorises a controller, who can register and renew domains.
1347     function addController(address controller) external;
1348 
1349     // Revoke controller permission for an address.
1350     function removeController(address controller) external;
1351 
1352     // Set the resolver for the TLD this registrar manages.
1353     function setResolver(address resolver) external;
1354 
1355     // Returns the expiration timestamp of the specified label hash.
1356     function nameExpires(uint256 id) external view returns(uint);
1357 
1358     // Returns true iff the specified name is available for registration.
1359     function available(uint256 id) public view returns(bool);
1360 
1361     /**
1362      * @dev Register a name.
1363      */
1364     function register(uint256 id, address owner, uint duration) external returns(uint);
1365 
1366     function renew(uint256 id, uint duration) external returns(uint);
1367 
1368     /**
1369      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
1370      */
1371     function reclaim(uint256 id, address owner) external;
1372 
1373     /**
1374      * @dev Transfers a registration from the initial registrar.
1375      * This function is called by the initial registrar when a user calls `transferRegistrars`.
1376      */
1377     function acceptRegistrarTransfer(bytes32 label, Deed deed, uint) external;
1378 }
1379 
1380 // File: contracts/Resolver.sol
1381 
1382 pragma solidity ^0.5.0;
1383 
1384 
1385 /**
1386  * @dev A basic interface for ENS resolvers.
1387  */
1388 contract Resolver {
1389     function supportsInterface(bytes4 interfaceID) public pure returns (bool);
1390     function addr(bytes32 node) public view returns (address);
1391     function setAddr(bytes32 node, address addr) public;
1392 }
1393 
1394 // File: contracts/RegistrarInterface.sol
1395 
1396 pragma solidity ^0.5.0;
1397 
1398 contract RegistrarInterface {
1399     event OwnerChanged(bytes32 indexed label, address indexed oldOwner, address indexed newOwner);
1400     event DomainConfigured(bytes32 indexed label);
1401     event DomainUnlisted(bytes32 indexed label);
1402     event NewRegistration(bytes32 indexed label, string subdomain, address indexed owner, address indexed referrer, uint price);
1403     event RentPaid(bytes32 indexed label, string subdomain, uint amount, uint expirationDate);
1404 
1405     // InterfaceID of these four methods is 0xc1b15f5a
1406     function query(bytes32 label, string calldata subdomain) external view returns (string memory domain, uint signupFee, uint rent, uint referralFeePPM);
1407     function register(bytes32 label, string calldata subdomain, address owner, address payable referrer, address resolver) external payable;
1408 
1409     function rentDue(bytes32 label, string calldata subdomain) external view returns (uint timestamp);
1410     function payRent(bytes32 label, string calldata subdomain) external payable;
1411 }
1412 
1413 // File: contracts/AbstractSubdomainRegistrar.sol
1414 
1415 pragma solidity ^0.5.0;
1416 
1417 
1418 
1419 
1420 contract AbstractSubdomainRegistrar is RegistrarInterface {
1421 
1422     // namehash('eth')
1423     bytes32 constant public TLD_NODE = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
1424 
1425     bool public stopped = false;
1426     address public registrarOwner;
1427     address public migration;
1428 
1429     address public registrar;
1430 
1431     ENS public ens;
1432 
1433     modifier owner_only(bytes32 label) {
1434         require(owner(label) == msg.sender);
1435         _;
1436     }
1437 
1438     modifier not_stopped() {
1439         require(!stopped);
1440         _;
1441     }
1442 
1443     modifier registrar_owner_only() {
1444         require(msg.sender == registrarOwner);
1445         _;
1446     }
1447 
1448     event DomainTransferred(bytes32 indexed label, string name);
1449 
1450     constructor(ENS _ens) public {
1451         ens = _ens;
1452         registrar = ens.owner(TLD_NODE);
1453         registrarOwner = msg.sender;
1454     }
1455 
1456     function doRegistration(bytes32 node, bytes32 label, address subdomainOwner, Resolver resolver) internal {
1457         // Get the subdomain so we can configure it
1458         ens.setSubnodeOwner(node, label, address(this));
1459 
1460         bytes32 subnode = keccak256(abi.encodePacked(node, label));
1461         // Set the subdomain's resolver
1462         ens.setResolver(subnode, address(resolver));
1463 
1464         // Set the address record on the resolver
1465         resolver.setAddr(subnode, subdomainOwner);
1466 
1467         // Pass ownership of the new subdomain to the registrant
1468         ens.setOwner(subnode, subdomainOwner);
1469     }
1470 
1471     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
1472         return (
1473             (interfaceID == 0x01ffc9a7) // supportsInterface(bytes4)
1474             || (interfaceID == 0xc1b15f5a) // RegistrarInterface
1475         );
1476     }
1477 
1478     function rentDue(bytes32 label, string calldata subdomain) external view returns (uint timestamp) {
1479         return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1480     }
1481 
1482     /**
1483      * @dev Sets the resolver record for a name in ENS.
1484      * @param name The name to set the resolver for.
1485      * @param resolver The address of the resolver
1486      */
1487     function setResolver(string memory name, address resolver) public owner_only(keccak256(bytes(name))) {
1488         bytes32 label = keccak256(bytes(name));
1489         bytes32 node = keccak256(abi.encodePacked(TLD_NODE, label));
1490         ens.setResolver(node, resolver);
1491     }
1492 
1493     /**
1494      * @dev Configures a domain for sale.
1495      * @param name The name to configure.
1496      * @param price The price in wei to charge for subdomain registrations
1497      * @param referralFeePPM The referral fee to offer, in parts per million
1498      */
1499     function configureDomain(string memory name, uint price, uint referralFeePPM) public {
1500         configureDomainFor(name, price, referralFeePPM, msg.sender, address(0x0));
1501     }
1502 
1503     /**
1504      * @dev Stops the registrar, disabling configuring of new domains.
1505      */
1506     function stop() public not_stopped registrar_owner_only {
1507         stopped = true;
1508     }
1509 
1510     /**
1511      * @dev Sets the address where domains are migrated to.
1512      * @param _migration Address of the new registrar.
1513      */
1514     function setMigrationAddress(address _migration) public registrar_owner_only {
1515         require(stopped);
1516         migration = _migration;
1517     }
1518 
1519     function transferOwnership(address newOwner) public registrar_owner_only {
1520         registrarOwner = newOwner;
1521     }
1522 
1523     function owner(bytes32 label) public view returns (address);
1524     function configureDomainFor(string memory name, uint price, uint referralFeePPM, address payable _owner, address _transfer) public;
1525 }
1526 
1527 // File: contracts/EthRegistrarSubdomainRegistrar.sol
1528 
1529 pragma solidity ^0.5.0;
1530 
1531 
1532 
1533 /**
1534  * @dev Implements an ENS registrar that sells subdomains on behalf of their owners.
1535  *
1536  * Users may register a subdomain by calling `register` with the name of the domain
1537  * they wish to register under, and the label hash of the subdomain they want to
1538  * register. They must also specify the new owner of the domain, and the referrer,
1539  * who is paid an optional finder's fee. The registrar then configures a simple
1540  * default resolver, which resolves `addr` lookups to the new owner, and sets
1541  * the `owner` account as the owner of the subdomain in ENS.
1542  *
1543  * New domains may be added by calling `configureDomain`, then transferring
1544  * ownership in the ENS registry to this contract. Ownership in the contract
1545  * may be transferred using `transfer`, and a domain may be unlisted for sale
1546  * using `unlistDomain`. There is (deliberately) no way to recover ownership
1547  * in ENS once the name is transferred to this registrar.
1548  *
1549  * Critically, this contract does not check one key property of a listed domain:
1550  *
1551  * - Is the name UTS46 normalised?
1552  *
1553  * User applications MUST check these two elements for each domain before
1554  * offering them to users for registration.
1555  *
1556  * Applications should additionally check that the domains they are offering to
1557  * register are controlled by this registrar, since calls to `register` will
1558  * fail if this is not the case.
1559  */
1560 contract EthRegistrarSubdomainRegistrar is AbstractSubdomainRegistrar {
1561 
1562     struct Domain {
1563         string name;
1564         address payable owner;
1565         uint price;
1566         uint referralFeePPM;
1567     }
1568 
1569     mapping (bytes32 => Domain) domains;
1570 
1571     constructor(ENS ens) AbstractSubdomainRegistrar(ens) public { }
1572 
1573     /**
1574      * @dev owner returns the address of the account that controls a domain.
1575      *      Initially this is a null address. If the name has been
1576      *      transferred to this contract, then the internal mapping is consulted
1577      *      to determine who controls it. If the owner is not set,
1578      *      the owner of the domain in the Registrar is returned.
1579      * @param label The label hash of the deed to check.
1580      * @return The address owning the deed.
1581      */
1582     function owner(bytes32 label) public view returns (address) {
1583         if (domains[label].owner != address(0x0)) {
1584             return domains[label].owner;
1585         }
1586 
1587         return BaseRegistrar(registrar).ownerOf(uint256(label));
1588     }
1589 
1590     /**
1591      * @dev Transfers internal control of a name to a new account. Does not update
1592      *      ENS.
1593      * @param name The name to transfer.
1594      * @param newOwner The address of the new owner.
1595      */
1596     function transfer(string memory name, address payable newOwner) public owner_only(keccak256(bytes(name))) {
1597         bytes32 label = keccak256(bytes(name));
1598         emit OwnerChanged(label, domains[label].owner, newOwner);
1599         domains[label].owner = newOwner;
1600     }
1601 
1602     /**
1603      * @dev Configures a domain, optionally transferring it to a new owner.
1604      * @param name The name to configure.
1605      * @param price The price in wei to charge for subdomain registrations.
1606      * @param referralFeePPM The referral fee to offer, in parts per million.
1607      * @param _owner The address to assign ownership of this domain to.
1608      * @param _transfer The address to set as the transfer address for the name
1609      *        when the permanent registrar is replaced. Can only be set to a non-zero
1610      *        value once.
1611      */
1612     function configureDomainFor(string memory name, uint price, uint referralFeePPM, address payable _owner, address _transfer) public owner_only(keccak256(bytes(name))) {
1613         bytes32 label = keccak256(bytes(name));
1614         Domain storage domain = domains[label];
1615 
1616         if (BaseRegistrar(registrar).ownerOf(uint256(label)) != address(this)) {
1617             BaseRegistrar(registrar).transferFrom(msg.sender, address(this), uint256(label));
1618             BaseRegistrar(registrar).reclaim(uint256(label), address(this));
1619         }
1620 
1621         if (domain.owner != _owner) {
1622             domain.owner = _owner;
1623         }
1624 
1625         if (keccak256(bytes(domain.name)) != label) {
1626             // New listing
1627             domain.name = name;
1628         }
1629 
1630         domain.price = price;
1631         domain.referralFeePPM = referralFeePPM;
1632 
1633         emit DomainConfigured(label);
1634     }
1635 
1636     /**
1637      * @dev Unlists a domain
1638      * May only be called by the owner.
1639      * @param name The name of the domain to unlist.
1640      */
1641     function unlistDomain(string memory name) public owner_only(keccak256(bytes(name))) {
1642         bytes32 label = keccak256(bytes(name));
1643         Domain storage domain = domains[label];
1644         emit DomainUnlisted(label);
1645 
1646         domain.name = '';
1647         domain.price = 0;
1648         domain.referralFeePPM = 0;
1649     }
1650 
1651     /**
1652      * @dev Returns information about a subdomain.
1653      * @param label The label hash for the domain.
1654      * @param subdomain The label for the subdomain.
1655      * @return domain The name of the domain, or an empty string if the subdomain
1656      *                is unavailable.
1657      * @return price The price to register a subdomain, in wei.
1658      * @return rent The rent to retain a subdomain, in wei per second.
1659      * @return referralFeePPM The referral fee for the dapp, in ppm.
1660      */
1661     function query(bytes32 label, string calldata subdomain) external view returns (string memory domain, uint price, uint rent, uint referralFeePPM) {
1662         bytes32 node = keccak256(abi.encodePacked(TLD_NODE, label));
1663         bytes32 subnode = keccak256(abi.encodePacked(node, keccak256(bytes(subdomain))));
1664 
1665         if (ens.owner(subnode) != address(0x0)) {
1666             return ('', 0, 0, 0);
1667         }
1668 
1669         Domain storage data = domains[label];
1670         return (data.name, data.price, 0, data.referralFeePPM);
1671     }
1672 
1673     /**
1674      * @dev Registers a subdomain.
1675      * @param label The label hash of the domain to register a subdomain of.
1676      * @param subdomain The desired subdomain label.
1677      * @param _subdomainOwner The account that should own the newly configured subdomain.
1678      * @param referrer The address of the account to receive the referral fee.
1679      */
1680     function register(bytes32 label, string calldata subdomain, address _subdomainOwner, address payable referrer, address resolver) external not_stopped payable {
1681         address subdomainOwner = _subdomainOwner;
1682         bytes32 domainNode = keccak256(abi.encodePacked(TLD_NODE, label));
1683         bytes32 subdomainLabel = keccak256(bytes(subdomain));
1684 
1685         // Subdomain must not be registered already.
1686         require(ens.owner(keccak256(abi.encodePacked(domainNode, subdomainLabel))) == address(0));
1687 
1688         Domain storage domain = domains[label];
1689 
1690         // Domain must be available for registration
1691         require(keccak256(bytes(domain.name)) == label);
1692 
1693         // User must have paid enough
1694         require(msg.value >= domain.price);
1695 
1696         // Send any extra back
1697         if (msg.value > domain.price) {
1698             msg.sender.transfer(msg.value - domain.price);
1699         }
1700 
1701         // Send any referral fee
1702         uint256 total = domain.price;
1703         if (domain.referralFeePPM > 0 && referrer != address(0x0) && referrer != domain.owner) {
1704             uint256 referralFee = (domain.price * domain.referralFeePPM) / 1000000;
1705             referrer.transfer(referralFee);
1706             total -= referralFee;
1707         }
1708 
1709         // Send the registration fee
1710         if (total > 0) {
1711             domain.owner.transfer(total);
1712         }
1713 
1714         // Register the domain
1715         if (subdomainOwner == address(0x0)) {
1716             subdomainOwner = msg.sender;
1717         }
1718         doRegistration(domainNode, subdomainLabel, subdomainOwner, Resolver(resolver));
1719 
1720         emit NewRegistration(label, subdomain, subdomainOwner, referrer, domain.price);
1721     }
1722 
1723     function rentDue(bytes32 label, string calldata subdomain) external view returns (uint timestamp) {
1724         return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1725     }
1726 
1727     /**
1728      * @dev Migrates the domain to a new registrar.
1729      * @param name The name of the domain to migrate.
1730      */
1731     function migrate(string memory name) public owner_only(keccak256(bytes(name))) {
1732         require(stopped);
1733         require(migration != address(0x0));
1734 
1735         bytes32 label = keccak256(bytes(name));
1736         Domain storage domain = domains[label];
1737 
1738         BaseRegistrar(registrar).approve(migration, uint256(label));
1739 
1740         EthRegistrarSubdomainRegistrar(migration).configureDomainFor(
1741             domain.name,
1742             domain.price,
1743             domain.referralFeePPM,
1744             domain.owner,
1745             address(0x0)
1746         );
1747 
1748         delete domains[label];
1749 
1750         emit DomainTransferred(label, name);
1751     }
1752 
1753     function payRent(bytes32 label, string calldata subdomain) external payable {
1754         revert();
1755     }
1756 }