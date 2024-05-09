1 // pragma solidity ^0.5.6;
2 
3 // /**
4 //  * @dev A registrar controller for registering and renewing names at fixed cost.
5 //  */
6 // contract ETHRegistrarController {
7 
8 //     uint constant public MIN_REGISTRATION_DURATION = 28 days;
9 
10 //     uint public minCommitmentAge;
11 //     uint public maxCommitmentAge;
12 
13 //     mapping(bytes32=>uint) public commitments;
14 
15 //     event NameRegistered(string name, bytes32 indexed label, address indexed owner, uint cost, uint expires);
16 //     event NameRenewed(string name, bytes32 indexed label, uint cost, uint expires);
17 //     event NewPriceOracle(address indexed oracle);
18 
19 //     function rentPrice(string memory name, uint duration) view public returns(uint);
20 
21 //     function valid(string memory name) public view returns(bool);
22 
23 //     function available(string memory name) public view returns(bool);
24 
25 //     function makeCommitment(string memory name, address owner, bytes32 secret) pure public returns(bytes32);
26 
27 //     function commit(bytes32 commitment) public;
28 
29 //     function register(string calldata name, address owner, uint duration, bytes32 secret) external payable;
30 
31 //     function renew(string calldata name, uint duration) external payable;
32 
33 //     function supportsInterface(bytes4 interfaceID) external pure returns (bool);
34 // }
35 
36 /**
37  * Source Code first verified at https://etherscan.io on Tuesday, April 30, 2019
38  (UTC) */
39 
40 // File: contracts/PriceOracle.sol
41 
42 pragma solidity >=0.4.24;
43 
44 interface PriceOracle {
45     /**
46      * @dev Returns the price to register or renew a name.
47      * @param name The name being registered or renewed.
48      * @param expires When the name presently expires (0 if this is a new registration).
49      * @param duration How long the name is being registered or extended for, in seconds.
50      * @return The price of this renewal or registration, in wei.
51      */
52     function price(string calldata name, uint expires, uint duration) external view returns(uint);
53 }
54 
55 // File: @ensdomains/ens/contracts/ENS.sol
56 
57 pragma solidity >=0.4.24;
58 
59 interface ENS {
60 
61     // Logged when the owner of a node assigns a new owner to a subnode.
62     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
63 
64     // Logged when the owner of a node transfers ownership to a new account.
65     event Transfer(bytes32 indexed node, address owner);
66 
67     // Logged when the resolver for a node changes.
68     event NewResolver(bytes32 indexed node, address resolver);
69 
70     // Logged when the TTL of a node changes
71     event NewTTL(bytes32 indexed node, uint64 ttl);
72 
73 
74     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
75     function setResolver(bytes32 node, address resolver) external;
76     function setOwner(bytes32 node, address owner) external;
77     function setTTL(bytes32 node, uint64 ttl) external;
78     function owner(bytes32 node) external view returns (address);
79     function resolver(bytes32 node) external view returns (address);
80     function ttl(bytes32 node) external view returns (uint64);
81 
82 }
83 
84 // File: @ensdomains/ens/contracts/Deed.sol
85 
86 pragma solidity >=0.4.24;
87 
88 interface Deed {
89 
90     function setOwner(address payable newOwner) external;
91     function setRegistrar(address newRegistrar) external;
92     function setBalance(uint newValue, bool throwOnFailure) external;
93     function closeDeed(uint refundRatio) external;
94     function destroyDeed() external;
95 
96     function owner() external view returns (address);
97     function previousOwner() external view returns (address);
98     function value() external view returns (uint);
99     function creationDate() external view returns (uint);
100 
101 }
102 
103 // File: @ensdomains/ens/contracts/DeedImplementation.sol
104 
105 pragma solidity ^0.5.0;
106 
107 
108 /**
109  * @title Deed to hold ether in exchange for ownership of a node
110  * @dev The deed can be controlled only by the registrar and can only send ether back to the owner.
111  */
112 contract DeedImplementation is Deed {
113 
114     address payable constant burn = address(0xdead);
115 
116     address payable private _owner;
117     address private _previousOwner;
118     address private _registrar;
119 
120     uint private _creationDate;
121     uint private _value;
122 
123     bool active;
124 
125     event OwnerChanged(address newOwner);
126     event DeedClosed();
127 
128     modifier onlyRegistrar {
129         require(msg.sender == _registrar);
130         _;
131     }
132 
133     modifier onlyActive {
134         require(active);
135         _;
136     }
137 
138     constructor(address payable initialOwner) public payable {
139         _owner = initialOwner;
140         _registrar = msg.sender;
141         _creationDate = now;
142         active = true;
143         _value = msg.value;
144     }
145 
146     function setOwner(address payable newOwner) external onlyRegistrar {
147         require(newOwner != address(0x0));
148         _previousOwner = _owner;  // This allows contracts to check who sent them the ownership
149         _owner = newOwner;
150         emit OwnerChanged(newOwner);
151     }
152 
153     function setRegistrar(address newRegistrar) external onlyRegistrar {
154         _registrar = newRegistrar;
155     }
156 
157     function setBalance(uint newValue, bool throwOnFailure) external onlyRegistrar onlyActive {
158         // Check if it has enough balance to set the value
159         require(_value >= newValue);
160         _value = newValue;
161         // Send the difference to the owner
162         require(_owner.send(address(this).balance - newValue) || !throwOnFailure);
163     }
164 
165     /**
166      * @dev Close a deed and refund a specified fraction of the bid value
167      *
168      * @param refundRatio The amount*1/1000 to refund
169      */
170     function closeDeed(uint refundRatio) external onlyRegistrar onlyActive {
171         active = false;
172         require(burn.send(((1000 - refundRatio) * address(this).balance)/1000));
173         emit DeedClosed();
174         _destroyDeed();
175     }
176 
177     /**
178      * @dev Close a deed and refund a specified fraction of the bid value
179      */
180     function destroyDeed() external {
181         _destroyDeed();
182     }
183 
184     function owner() external view returns (address) {
185         return _owner;
186     }
187 
188     function previousOwner() external view returns (address) {
189         return _previousOwner;
190     }
191 
192     function value() external view returns (uint) {
193         return _value;
194     }
195 
196     function creationDate() external view returns (uint) {
197         _creationDate;
198     }
199 
200     function _destroyDeed() internal {
201         require(!active);
202 
203         // Instead of selfdestruct(owner), invoke owner fallback function to allow
204         // owner to log an event if desired; but owner should also be aware that
205         // its fallback function can also be invoked by setBalance
206         if (_owner.send(address(this).balance)) {
207             selfdestruct(burn);
208         }
209     }
210 }
211 
212 // File: @ensdomains/ens/contracts/Registrar.sol
213 
214 pragma solidity >=0.4.24;
215 
216 
217 interface Registrar {
218 
219     enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }
220 
221     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
222     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
223     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
224     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
225     event HashReleased(bytes32 indexed hash, uint value);
226     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
227 
228     function startAuction(bytes32 _hash) external;
229     function startAuctions(bytes32[] calldata _hashes) external;
230     function newBid(bytes32 sealedBid) external payable;
231     function startAuctionsAndBid(bytes32[] calldata hashes, bytes32 sealedBid) external payable;
232     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) external;
233     function cancelBid(address bidder, bytes32 seal) external;
234     function finalizeAuction(bytes32 _hash) external;
235     function transfer(bytes32 _hash, address payable newOwner) external;
236     function releaseDeed(bytes32 _hash) external;
237     function invalidateName(string calldata unhashedName) external;
238     function eraseNode(bytes32[] calldata labels) external;
239     function transferRegistrars(bytes32 _hash) external;
240     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) external;
241     function entries(bytes32 _hash) external view returns (Mode, address, uint, uint, uint);
242 }
243 
244 // File: @ensdomains/ens/contracts/HashRegistrar.sol
245 
246 pragma solidity ^0.5.0;
247 
248 
249 /*
250 
251 Temporary Hash Registrar
252 ========================
253 
254 This is a simplified version of a hash registrar. It is purporsefully limited:
255 names cannot be six letters or shorter, new auctions will stop after 4 years.
256 
257 The plan is to test the basic features and then move to a new contract in at most
258 2 years, when some sort of renewal mechanism will be enabled.
259 */
260 
261 
262 
263 
264 /**
265  * @title Registrar
266  * @dev The registrar handles the auction process for each subnode of the node it owns.
267  */
268 contract HashRegistrar is Registrar {
269     ENS public ens;
270     bytes32 public rootNode;
271 
272     mapping (bytes32 => Entry) _entries;
273     mapping (address => mapping (bytes32 => Deed)) public sealedBids;
274 
275     uint32 constant totalAuctionLength = 5 days;
276     uint32 constant revealPeriod = 48 hours;
277     uint32 public constant launchLength = 8 weeks;
278 
279     uint constant minPrice = 0.01 ether;
280     uint public registryStarted;
281 
282     struct Entry {
283         Deed deed;
284         uint registrationDate;
285         uint value;
286         uint highestBid;
287     }
288 
289     modifier inState(bytes32 _hash, Mode _state) {
290         require(state(_hash) == _state);
291         _;
292     }
293 
294     modifier onlyOwner(bytes32 _hash) {
295         require(state(_hash) == Mode.Owned && msg.sender == _entries[_hash].deed.owner());
296         _;
297     }
298 
299     modifier registryOpen() {
300         require(now >= registryStarted && now <= registryStarted + (365 * 4) * 1 days && ens.owner(rootNode) == address(this));
301         _;
302     }
303 
304     /**
305      * @dev Constructs a new Registrar, with the provided address as the owner of the root node.
306      *
307      * @param _ens The address of the ENS
308      * @param _rootNode The hash of the rootnode.
309      */
310     constructor(ENS _ens, bytes32 _rootNode, uint _startDate) public {
311         ens = _ens;
312         rootNode = _rootNode;
313         registryStarted = _startDate > 0 ? _startDate : now;
314     }
315 
316     /**
317      * @dev Start an auction for an available hash
318      *
319      * @param _hash The hash to start an auction on
320      */
321     function startAuction(bytes32 _hash) external {
322         _startAuction(_hash);
323     }
324 
325     /**
326      * @dev Start multiple auctions for better anonymity
327      *
328      * Anyone can start an auction by sending an array of hashes that they want to bid for.
329      * Arrays are sent so that someone can open up an auction for X dummy hashes when they
330      * are only really interested in bidding for one. This will increase the cost for an
331      * attacker to simply bid blindly on all new auctions. Dummy auctions that are
332      * open but not bid on are closed after a week.
333      *
334      * @param _hashes An array of hashes, at least one of which you presumably want to bid on
335      */
336     function startAuctions(bytes32[] calldata _hashes) external {
337         _startAuctions(_hashes);
338     }
339 
340     /**
341      * @dev Submit a new sealed bid on a desired hash in a blind auction
342      *
343      * Bids are sent by sending a message to the main contract with a hash and an amount. The hash
344      * contains information about the bid, including the bidded hash, the bid amount, and a random
345      * salt. Bids are not tied to any one auction until they are revealed. The value of the bid
346      * itself can be masqueraded by sending more than the value of your actual bid. This is
347      * followed by a 48h reveal period. Bids revealed after this period will be burned and the ether unrecoverable.
348      * Since this is an auction, it is expected that most public hashes, like known domains and common dictionary
349      * words, will have multiple bidders pushing the price up.
350      *
351      * @param sealedBid A sealedBid, created by the shaBid function
352      */
353     function newBid(bytes32 sealedBid) external payable {
354         _newBid(sealedBid);
355     }
356 
357     /**
358      * @dev Start a set of auctions and bid on one of them
359      *
360      * This method functions identically to calling `startAuctions` followed by `newBid`,
361      * but all in one transaction.
362      *
363      * @param hashes A list of hashes to start auctions on.
364      * @param sealedBid A sealed bid for one of the auctions.
365      */
366     function startAuctionsAndBid(bytes32[] calldata hashes, bytes32 sealedBid) external payable {
367         _startAuctions(hashes);
368         _newBid(sealedBid);
369     }
370 
371     /**
372      * @dev Submit the properties of a bid to reveal them
373      *
374      * @param _hash The node in the sealedBid
375      * @param _value The bid amount in the sealedBid
376      * @param _salt The sale in the sealedBid
377      */
378     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) external {
379         bytes32 seal = shaBid(_hash, msg.sender, _value, _salt);
380         Deed bid = sealedBids[msg.sender][seal];
381         require(address(bid) != address(0x0));
382 
383         sealedBids[msg.sender][seal] = Deed(address(0x0));
384         Entry storage h = _entries[_hash];
385         uint value = min(_value, bid.value());
386         bid.setBalance(value, true);
387 
388         Mode auctionState = state(_hash);
389         if (auctionState == Mode.Owned) {
390             // Too late! Bidder loses their bid. Gets 0.5% back.
391             bid.closeDeed(5);
392             emit BidRevealed(_hash, msg.sender, value, 1);
393         } else if (auctionState != Mode.Reveal) {
394             // Invalid phase
395             revert();
396         } else if (value < minPrice || bid.creationDate() > h.registrationDate - revealPeriod) {
397             // Bid too low or too late, refund 99.5%
398             bid.closeDeed(995);
399             emit BidRevealed(_hash, msg.sender, value, 0);
400         } else if (value > h.highestBid) {
401             // New winner
402             // Cancel the other bid, refund 99.5%
403             if (address(h.deed) != address(0x0)) {
404                 Deed previousWinner = h.deed;
405                 previousWinner.closeDeed(995);
406             }
407 
408             // Set new winner
409             // Per the rules of a vickery auction, the value becomes the previous highestBid
410             h.value = h.highestBid;  // will be zero if there's only 1 bidder
411             h.highestBid = value;
412             h.deed = bid;
413             emit BidRevealed(_hash, msg.sender, value, 2);
414         } else if (value > h.value) {
415             // Not winner, but affects second place
416             h.value = value;
417             bid.closeDeed(995);
418             emit BidRevealed(_hash, msg.sender, value, 3);
419         } else {
420             // Bid doesn't affect auction
421             bid.closeDeed(995);
422             emit BidRevealed(_hash, msg.sender, value, 4);
423         }
424     }
425 
426     /**
427      * @dev Cancel a bid
428      *
429      * @param seal The value returned by the shaBid function
430      */
431     function cancelBid(address bidder, bytes32 seal) external {
432         Deed bid = sealedBids[bidder][seal];
433         
434         // If a sole bidder does not `unsealBid` in time, they have a few more days
435         // where they can call `startAuction` (again) and then `unsealBid` during
436         // the revealPeriod to get back their bid value.
437         // For simplicity, they should call `startAuction` within
438         // 9 days (2 weeks - totalAuctionLength), otherwise their bid will be
439         // cancellable by anyone.
440         require(address(bid) != address(0x0) && now >= bid.creationDate() + totalAuctionLength + 2 weeks);
441 
442         // Send the canceller 0.5% of the bid, and burn the rest.
443         bid.setOwner(msg.sender);
444         bid.closeDeed(5);
445         sealedBids[bidder][seal] = Deed(0);
446         emit BidRevealed(seal, bidder, 0, 5);
447     }
448 
449     /**
450      * @dev Finalize an auction after the registration date has passed
451      *
452      * @param _hash The hash of the name the auction is for
453      */
454     function finalizeAuction(bytes32 _hash) external onlyOwner(_hash) {
455         Entry storage h = _entries[_hash];
456         
457         // Handles the case when there's only a single bidder (h.value is zero)
458         h.value = max(h.value, minPrice);
459         h.deed.setBalance(h.value, true);
460 
461         trySetSubnodeOwner(_hash, h.deed.owner());
462         emit HashRegistered(_hash, h.deed.owner(), h.value, h.registrationDate);
463     }
464 
465     /**
466      * @dev The owner of a domain may transfer it to someone else at any time.
467      *
468      * @param _hash The node to transfer
469      * @param newOwner The address to transfer ownership to
470      */
471     function transfer(bytes32 _hash, address payable newOwner) external onlyOwner(_hash) {
472         require(newOwner != address(0x0));
473 
474         Entry storage h = _entries[_hash];
475         h.deed.setOwner(newOwner);
476         trySetSubnodeOwner(_hash, newOwner);
477     }
478 
479     /**
480      * @dev After some time, or if we're no longer the registrar, the owner can release
481      *      the name and get their ether back.
482      *
483      * @param _hash The node to release
484      */
485     function releaseDeed(bytes32 _hash) external onlyOwner(_hash) {
486         Entry storage h = _entries[_hash];
487         Deed deedContract = h.deed;
488 
489         require(now >= h.registrationDate + 365 days || ens.owner(rootNode) != address(this));
490 
491         h.value = 0;
492         h.highestBid = 0;
493         h.deed = Deed(0);
494 
495         _tryEraseSingleNode(_hash);
496         deedContract.closeDeed(1000);
497         emit HashReleased(_hash, h.value);        
498     }
499 
500     /**
501      * @dev Submit a name 6 characters long or less. If it has been registered,
502      *      the submitter will earn 50% of the deed value. 
503      * 
504      * We are purposefully handicapping the simplified registrar as a way 
505      * to force it into being restructured in a few years.
506      *
507      * @param unhashedName An invalid name to search for in the registry.
508      */
509     function invalidateName(string calldata unhashedName)
510         external
511         inState(keccak256(abi.encode(unhashedName)), Mode.Owned)
512     {
513         require(strlen(unhashedName) <= 6);
514         bytes32 hash = keccak256(abi.encode(unhashedName));
515 
516         Entry storage h = _entries[hash];
517 
518         _tryEraseSingleNode(hash);
519 
520         if (address(h.deed) != address(0x0)) {
521             // Reward the discoverer with 50% of the deed
522             // The previous owner gets 50%
523             h.value = max(h.value, minPrice);
524             h.deed.setBalance(h.value/2, false);
525             h.deed.setOwner(msg.sender);
526             h.deed.closeDeed(1000);
527         }
528 
529         emit HashInvalidated(hash, unhashedName, h.value, h.registrationDate);
530 
531         h.value = 0;
532         h.highestBid = 0;
533         h.deed = Deed(0);
534     }
535 
536     /**
537      * @dev Allows anyone to delete the owner and resolver records for a (subdomain of) a
538      *      name that is not currently owned in the registrar. If passing, eg, 'foo.bar.eth',
539      *      the owner and resolver fields on 'foo.bar.eth' and 'bar.eth' will all be cleared.
540      *
541      * @param labels A series of label hashes identifying the name to zero out, rooted at the
542      *        registrar's root. Must contain at least one element. For instance, to zero 
543      *        'foo.bar.eth' on a registrar that owns '.eth', pass an array containing
544      *        [keccak256('foo'), keccak256('bar')].
545      */
546     function eraseNode(bytes32[] calldata labels) external {
547         require(labels.length != 0);
548         require(state(labels[labels.length - 1]) != Mode.Owned);
549 
550         _eraseNodeHierarchy(labels.length - 1, labels, rootNode);
551     }
552 
553     /**
554      * @dev Transfers the deed to the current registrar, if different from this one.
555      *
556      * Used during the upgrade process to a permanent registrar.
557      *
558      * @param _hash The name hash to transfer.
559      */
560     function transferRegistrars(bytes32 _hash) external onlyOwner(_hash) {
561         address registrar = ens.owner(rootNode);
562         require(registrar != address(this));
563 
564         // Migrate the deed
565         Entry storage h = _entries[_hash];
566         h.deed.setRegistrar(registrar);
567 
568         // Call the new registrar to accept the transfer
569         Registrar(registrar).acceptRegistrarTransfer(_hash, h.deed, h.registrationDate);
570 
571         // Zero out the Entry
572         h.deed = Deed(0);
573         h.registrationDate = 0;
574         h.value = 0;
575         h.highestBid = 0;
576     }
577 
578     /**
579      * @dev Accepts a transfer from a previous registrar; stubbed out here since there
580      *      is no previous registrar implementing this interface.
581      *
582      * @param hash The sha3 hash of the label to transfer.
583      * @param deed The Deed object for the name being transferred in.
584      * @param registrationDate The date at which the name was originally registered.
585      */
586     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) external {
587         hash; deed; registrationDate; // Don't warn about unused variables
588     }
589 
590     function entries(bytes32 _hash) external view returns (Mode, address, uint, uint, uint) {
591         Entry storage h = _entries[_hash];
592         return (state(_hash), address(h.deed), h.registrationDate, h.value, h.highestBid);
593     }
594 
595     // State transitions for names:
596     //   Open -> Auction (startAuction)
597     //   Auction -> Reveal
598     //   Reveal -> Owned
599     //   Reveal -> Open (if nobody bid)
600     //   Owned -> Open (releaseDeed or invalidateName)
601     function state(bytes32 _hash) public view returns (Mode) {
602         Entry storage entry = _entries[_hash];
603 
604         if (!isAllowed(_hash, now)) {
605             return Mode.NotYetAvailable;
606         } else if (now < entry.registrationDate) {
607             if (now < entry.registrationDate - revealPeriod) {
608                 return Mode.Auction;
609             } else {
610                 return Mode.Reveal;
611             }
612         } else {
613             if (entry.highestBid == 0) {
614                 return Mode.Open;
615             } else {
616                 return Mode.Owned;
617             }
618         }
619     }
620 
621     /**
622      * @dev Determines if a name is available for registration yet
623      *
624      * Each name will be assigned a random date in which its auction
625      * can be started, from 0 to 8 weeks
626      *
627      * @param _hash The hash to start an auction on
628      * @param _timestamp The timestamp to query about
629      */
630     function isAllowed(bytes32 _hash, uint _timestamp) public view returns (bool allowed) {
631         return _timestamp > getAllowedTime(_hash);
632     }
633 
634     /**
635      * @dev Returns available date for hash
636      *
637      * The available time from the `registryStarted` for a hash is proportional
638      * to its numeric value.
639      *
640      * @param _hash The hash to start an auction on
641      */
642     function getAllowedTime(bytes32 _hash) public view returns (uint) {
643         return registryStarted + ((launchLength * (uint(_hash) >> 128)) >> 128);
644         // Right shift operator: a >> b == a / 2**b
645     }
646 
647     /**
648      * @dev Hash the values required for a secret bid
649      *
650      * @param hash The node corresponding to the desired namehash
651      * @param value The bid amount
652      * @param salt A random value to ensure secrecy of the bid
653      * @return The hash of the bid values
654      */
655     function shaBid(bytes32 hash, address owner, uint value, bytes32 salt) public pure returns (bytes32) {
656         return keccak256(abi.encodePacked(hash, owner, value, salt));
657     }
658 
659     function _tryEraseSingleNode(bytes32 label) internal {
660         if (ens.owner(rootNode) == address(this)) {
661             ens.setSubnodeOwner(rootNode, label, address(this));
662             bytes32 node = keccak256(abi.encodePacked(rootNode, label));
663             ens.setResolver(node, address(0x0));
664             ens.setOwner(node, address(0x0));
665         }
666     }
667 
668     function _startAuction(bytes32 _hash) internal registryOpen() {
669         Mode mode = state(_hash);
670         if (mode == Mode.Auction) return;
671         require(mode == Mode.Open);
672 
673         Entry storage newAuction = _entries[_hash];
674         newAuction.registrationDate = now + totalAuctionLength;
675         newAuction.value = 0;
676         newAuction.highestBid = 0;
677         emit AuctionStarted(_hash, newAuction.registrationDate);
678     }
679 
680     function _startAuctions(bytes32[] memory _hashes) internal {
681         for (uint i = 0; i < _hashes.length; i ++) {
682             _startAuction(_hashes[i]);
683         }
684     }
685 
686     function _newBid(bytes32 sealedBid) internal {
687         require(address(sealedBids[msg.sender][sealedBid]) == address(0x0));
688         require(msg.value >= minPrice);
689 
690         // Creates a new hash contract with the owner
691         Deed bid = (new DeedImplementation).value(msg.value)(msg.sender);
692         sealedBids[msg.sender][sealedBid] = bid;
693         emit NewBid(sealedBid, msg.sender, msg.value);
694     }
695 
696     function _eraseNodeHierarchy(uint idx, bytes32[] memory labels, bytes32 node) internal {
697         // Take ownership of the node
698         ens.setSubnodeOwner(node, labels[idx], address(this));
699         node = keccak256(abi.encodePacked(node, labels[idx]));
700 
701         // Recurse if there are more labels
702         if (idx > 0) {
703             _eraseNodeHierarchy(idx - 1, labels, node);
704         }
705 
706         // Erase the resolver and owner records
707         ens.setResolver(node, address(0x0));
708         ens.setOwner(node, address(0x0));
709     }
710 
711     /**
712      * @dev Assign the owner in ENS, if we're still the registrar
713      *
714      * @param _hash hash to change owner
715      * @param _newOwner new owner to transfer to
716      */
717     function trySetSubnodeOwner(bytes32 _hash, address _newOwner) internal {
718         if (ens.owner(rootNode) == address(this))
719             ens.setSubnodeOwner(rootNode, _hash, _newOwner);
720     }
721 
722     /**
723      * @dev Returns the maximum of two unsigned integers
724      *
725      * @param a A number to compare
726      * @param b A number to compare
727      * @return The maximum of two unsigned integers
728      */
729     function max(uint a, uint b) internal pure returns (uint) {
730         if (a > b)
731             return a;
732         else
733             return b;
734     }
735 
736     /**
737      * @dev Returns the minimum of two unsigned integers
738      *
739      * @param a A number to compare
740      * @param b A number to compare
741      * @return The minimum of two unsigned integers
742      */
743     function min(uint a, uint b) internal pure returns (uint) {
744         if (a < b)
745             return a;
746         else
747             return b;
748     }
749 
750     /**
751      * @dev Returns the length of a given string
752      *
753      * @param s The string to measure the length of
754      * @return The length of the input string
755      */
756     function strlen(string memory s) internal pure returns (uint) {
757         s; // Don't warn about unused variables
758         // Starting here means the LSB will be the byte we care about
759         uint ptr;
760         uint end;
761         assembly {
762             ptr := add(s, 1)
763             end := add(mload(s), ptr)
764         }
765         uint len = 0;
766         for (len; ptr < end; len++) {
767             uint8 b;
768             assembly { b := and(mload(ptr), 0xFF) }
769             if (b < 0x80) {
770                 ptr += 1;
771             } else if (b < 0xE0) {
772                 ptr += 2;
773             } else if (b < 0xF0) {
774                 ptr += 3;
775             } else if (b < 0xF8) {
776                 ptr += 4;
777             } else if (b < 0xFC) {
778                 ptr += 5;
779             } else {
780                 ptr += 6;
781             }
782         }
783         return len;
784     }
785 
786 }
787 
788 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
789 
790 pragma solidity ^0.5.0;
791 
792 /**
793  * @title IERC165
794  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
795  */
796 interface IERC165 {
797     /**
798      * @notice Query if a contract implements an interface
799      * @param interfaceId The interface identifier, as specified in ERC-165
800      * @dev Interface identification is specified in ERC-165. This function
801      * uses less than 30,000 gas.
802      */
803     function supportsInterface(bytes4 interfaceId) external view returns (bool);
804 }
805 
806 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
807 
808 pragma solidity ^0.5.0;
809 
810 
811 /**
812  * @title ERC721 Non-Fungible Token Standard basic interface
813  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
814  */
815 contract IERC721 is IERC165 {
816     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
817     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
818     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
819 
820     function balanceOf(address owner) public view returns (uint256 balance);
821     function ownerOf(uint256 tokenId) public view returns (address owner);
822 
823     function approve(address to, uint256 tokenId) public;
824     function getApproved(uint256 tokenId) public view returns (address operator);
825 
826     function setApprovalForAll(address operator, bool _approved) public;
827     function isApprovedForAll(address owner, address operator) public view returns (bool);
828 
829     function transferFrom(address from, address to, uint256 tokenId) public;
830     function safeTransferFrom(address from, address to, uint256 tokenId) public;
831 
832     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
833 }
834 
835 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
836 
837 pragma solidity ^0.5.0;
838 
839 /**
840  * @title ERC721 token receiver interface
841  * @dev Interface for any contract that wants to support safeTransfers
842  * from ERC721 asset contracts.
843  */
844 contract IERC721Receiver {
845     /**
846      * @notice Handle the receipt of an NFT
847      * @dev The ERC721 smart contract calls this function on the recipient
848      * after a `safeTransfer`. This function MUST return the function selector,
849      * otherwise the caller will revert the transaction. The selector to be
850      * returned can be obtained as `this.onERC721Received.selector`. This
851      * function MAY throw to revert and reject the transfer.
852      * Note: the ERC721 contract address is always the message sender.
853      * @param operator The address which called `safeTransferFrom` function
854      * @param from The address which previously owned the token
855      * @param tokenId The NFT identifier which is being transferred
856      * @param data Additional data with no specified format
857      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
858      */
859     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
860     public returns (bytes4);
861 }
862 
863 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
864 
865 pragma solidity ^0.5.0;
866 
867 /**
868  * @title SafeMath
869  * @dev Unsigned math operations with safety checks that revert on error
870  */
871 library SafeMath {
872     /**
873     * @dev Multiplies two unsigned integers, reverts on overflow.
874     */
875     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
876         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
877         // benefit is lost if 'b' is also tested.
878         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
879         if (a == 0) {
880             return 0;
881         }
882 
883         uint256 c = a * b;
884         require(c / a == b);
885 
886         return c;
887     }
888 
889     /**
890     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
891     */
892     function div(uint256 a, uint256 b) internal pure returns (uint256) {
893         // Solidity only automatically asserts when dividing by 0
894         require(b > 0);
895         uint256 c = a / b;
896         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
897 
898         return c;
899     }
900 
901     /**
902     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
903     */
904     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
905         require(b <= a);
906         uint256 c = a - b;
907 
908         return c;
909     }
910 
911     /**
912     * @dev Adds two unsigned integers, reverts on overflow.
913     */
914     function add(uint256 a, uint256 b) internal pure returns (uint256) {
915         uint256 c = a + b;
916         require(c >= a);
917 
918         return c;
919     }
920 
921     /**
922     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
923     * reverts when dividing by zero.
924     */
925     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
926         require(b != 0);
927         return a % b;
928     }
929 }
930 
931 // File: openzeppelin-solidity/contracts/utils/Address.sol
932 
933 pragma solidity ^0.5.0;
934 
935 /**
936  * Utility library of inline functions on addresses
937  */
938 library Address {
939     /**
940      * Returns whether the target address is a contract
941      * @dev This function will return false if invoked during the constructor of a contract,
942      * as the code is not actually created until after the constructor finishes.
943      * @param account address of the account to check
944      * @return whether the target address is a contract
945      */
946     function isContract(address account) internal view returns (bool) {
947         uint256 size;
948         // XXX Currently there is no better way to check if there is a contract in an address
949         // than to check the size of the code at that address.
950         // See https://ethereum.stackexchange.com/a/14016/36603
951         // for more details about how this works.
952         // TODO Check this again before the Serenity release, because all addresses will be
953         // contracts then.
954         // solhint-disable-next-line no-inline-assembly
955         assembly { size := extcodesize(account) }
956         return size > 0;
957     }
958 }
959 
960 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
961 
962 pragma solidity ^0.5.0;
963 
964 
965 /**
966  * @title ERC165
967  * @author Matt Condon (@shrugs)
968  * @dev Implements ERC165 using a lookup table.
969  */
970 contract ERC165 is IERC165 {
971     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
972     /**
973      * 0x01ffc9a7 ===
974      *     bytes4(keccak256('supportsInterface(bytes4)'))
975      */
976 
977     /**
978      * @dev a mapping of interface id to whether or not it's supported
979      */
980     mapping(bytes4 => bool) private _supportedInterfaces;
981 
982     /**
983      * @dev A contract implementing SupportsInterfaceWithLookup
984      * implement ERC165 itself
985      */
986     constructor () internal {
987         _registerInterface(_INTERFACE_ID_ERC165);
988     }
989 
990     /**
991      * @dev implement supportsInterface(bytes4) using a lookup table
992      */
993     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
994         return _supportedInterfaces[interfaceId];
995     }
996 
997     /**
998      * @dev internal method for registering an interface
999      */
1000     function _registerInterface(bytes4 interfaceId) internal {
1001         require(interfaceId != 0xffffffff);
1002         _supportedInterfaces[interfaceId] = true;
1003     }
1004 }
1005 
1006 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
1007 
1008 pragma solidity ^0.5.0;
1009 
1010 
1011 
1012 
1013 
1014 
1015 /**
1016  * @title ERC721 Non-Fungible Token Standard basic implementation
1017  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1018  */
1019 contract ERC721 is ERC165, IERC721 {
1020     using SafeMath for uint256;
1021     using Address for address;
1022 
1023     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1024     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1025     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1026 
1027     // Mapping from token ID to owner
1028     mapping (uint256 => address) private _tokenOwner;
1029 
1030     // Mapping from token ID to approved address
1031     mapping (uint256 => address) private _tokenApprovals;
1032 
1033     // Mapping from owner to number of owned token
1034     mapping (address => uint256) private _ownedTokensCount;
1035 
1036     // Mapping from owner to operator approvals
1037     mapping (address => mapping (address => bool)) private _operatorApprovals;
1038 
1039     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1040     /*
1041      * 0x80ac58cd ===
1042      *     bytes4(keccak256('balanceOf(address)')) ^
1043      *     bytes4(keccak256('ownerOf(uint256)')) ^
1044      *     bytes4(keccak256('approve(address,uint256)')) ^
1045      *     bytes4(keccak256('getApproved(uint256)')) ^
1046      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
1047      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
1048      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1049      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
1050      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1051      */
1052 
1053     constructor () public {
1054         // register the supported interfaces to conform to ERC721 via ERC165
1055         _registerInterface(_INTERFACE_ID_ERC721);
1056     }
1057 
1058     /**
1059      * @dev Gets the balance of the specified address
1060      * @param owner address to query the balance of
1061      * @return uint256 representing the amount owned by the passed address
1062      */
1063     function balanceOf(address owner) public view returns (uint256) {
1064         require(owner != address(0));
1065         return _ownedTokensCount[owner];
1066     }
1067 
1068     /**
1069      * @dev Gets the owner of the specified token ID
1070      * @param tokenId uint256 ID of the token to query the owner of
1071      * @return owner address currently marked as the owner of the given token ID
1072      */
1073     function ownerOf(uint256 tokenId) public view returns (address) {
1074         address owner = _tokenOwner[tokenId];
1075         require(owner != address(0));
1076         return owner;
1077     }
1078 
1079     /**
1080      * @dev Approves another address to transfer the given token ID
1081      * The zero address indicates there is no approved address.
1082      * There can only be one approved address per token at a given time.
1083      * Can only be called by the token owner or an approved operator.
1084      * @param to address to be approved for the given token ID
1085      * @param tokenId uint256 ID of the token to be approved
1086      */
1087     function approve(address to, uint256 tokenId) public {
1088         address owner = ownerOf(tokenId);
1089         require(to != owner);
1090         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1091 
1092         _tokenApprovals[tokenId] = to;
1093         emit Approval(owner, to, tokenId);
1094     }
1095 
1096     /**
1097      * @dev Gets the approved address for a token ID, or zero if no address set
1098      * Reverts if the token ID does not exist.
1099      * @param tokenId uint256 ID of the token to query the approval of
1100      * @return address currently approved for the given token ID
1101      */
1102     function getApproved(uint256 tokenId) public view returns (address) {
1103         require(_exists(tokenId));
1104         return _tokenApprovals[tokenId];
1105     }
1106 
1107     /**
1108      * @dev Sets or unsets the approval of a given operator
1109      * An operator is allowed to transfer all tokens of the sender on their behalf
1110      * @param to operator address to set the approval
1111      * @param approved representing the status of the approval to be set
1112      */
1113     function setApprovalForAll(address to, bool approved) public {
1114         require(to != msg.sender);
1115         _operatorApprovals[msg.sender][to] = approved;
1116         emit ApprovalForAll(msg.sender, to, approved);
1117     }
1118 
1119     /**
1120      * @dev Tells whether an operator is approved by a given owner
1121      * @param owner owner address which you want to query the approval of
1122      * @param operator operator address which you want to query the approval of
1123      * @return bool whether the given operator is approved by the given owner
1124      */
1125     function isApprovedForAll(address owner, address operator) public view returns (bool) {
1126         return _operatorApprovals[owner][operator];
1127     }
1128 
1129     /**
1130      * @dev Transfers the ownership of a given token ID to another address
1131      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1132      * Requires the msg sender to be the owner, approved, or operator
1133      * @param from current owner of the token
1134      * @param to address to receive the ownership of the given token ID
1135      * @param tokenId uint256 ID of the token to be transferred
1136     */
1137     function transferFrom(address from, address to, uint256 tokenId) public {
1138         require(_isApprovedOrOwner(msg.sender, tokenId));
1139 
1140         _transferFrom(from, to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Safely transfers the ownership of a given token ID to another address
1145      * If the target address is a contract, it must implement `onERC721Received`,
1146      * which is called upon a safe transfer, and return the magic value
1147      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1148      * the transfer is reverted.
1149      *
1150      * Requires the msg sender to be the owner, approved, or operator
1151      * @param from current owner of the token
1152      * @param to address to receive the ownership of the given token ID
1153      * @param tokenId uint256 ID of the token to be transferred
1154     */
1155     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1156         safeTransferFrom(from, to, tokenId, "");
1157     }
1158 
1159     /**
1160      * @dev Safely transfers the ownership of a given token ID to another address
1161      * If the target address is a contract, it must implement `onERC721Received`,
1162      * which is called upon a safe transfer, and return the magic value
1163      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1164      * the transfer is reverted.
1165      * Requires the msg sender to be the owner, approved, or operator
1166      * @param from current owner of the token
1167      * @param to address to receive the ownership of the given token ID
1168      * @param tokenId uint256 ID of the token to be transferred
1169      * @param _data bytes data to send along with a safe transfer check
1170      */
1171     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
1172         transferFrom(from, to, tokenId);
1173         require(_checkOnERC721Received(from, to, tokenId, _data));
1174     }
1175 
1176     /**
1177      * @dev Returns whether the specified token exists
1178      * @param tokenId uint256 ID of the token to query the existence of
1179      * @return whether the token exists
1180      */
1181     function _exists(uint256 tokenId) internal view returns (bool) {
1182         address owner = _tokenOwner[tokenId];
1183         return owner != address(0);
1184     }
1185 
1186     /**
1187      * @dev Returns whether the given spender can transfer a given token ID
1188      * @param spender address of the spender to query
1189      * @param tokenId uint256 ID of the token to be transferred
1190      * @return bool whether the msg.sender is approved for the given token ID,
1191      *    is an operator of the owner, or is the owner of the token
1192      */
1193     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1194         address owner = ownerOf(tokenId);
1195         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1196     }
1197 
1198     /**
1199      * @dev Internal function to mint a new token
1200      * Reverts if the given token ID already exists
1201      * @param to The address that will own the minted token
1202      * @param tokenId uint256 ID of the token to be minted
1203      */
1204     function _mint(address to, uint256 tokenId) internal {
1205         require(to != address(0));
1206         require(!_exists(tokenId));
1207 
1208         _tokenOwner[tokenId] = to;
1209         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
1210 
1211         emit Transfer(address(0), to, tokenId);
1212     }
1213 
1214     /**
1215      * @dev Internal function to burn a specific token
1216      * Reverts if the token does not exist
1217      * Deprecated, use _burn(uint256) instead.
1218      * @param owner owner of the token to burn
1219      * @param tokenId uint256 ID of the token being burned
1220      */
1221     function _burn(address owner, uint256 tokenId) internal {
1222         require(ownerOf(tokenId) == owner);
1223 
1224         _clearApproval(tokenId);
1225 
1226         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
1227         _tokenOwner[tokenId] = address(0);
1228 
1229         emit Transfer(owner, address(0), tokenId);
1230     }
1231 
1232     /**
1233      * @dev Internal function to burn a specific token
1234      * Reverts if the token does not exist
1235      * @param tokenId uint256 ID of the token being burned
1236      */
1237     function _burn(uint256 tokenId) internal {
1238         _burn(ownerOf(tokenId), tokenId);
1239     }
1240 
1241     /**
1242      * @dev Internal function to transfer ownership of a given token ID to another address.
1243      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1244      * @param from current owner of the token
1245      * @param to address to receive the ownership of the given token ID
1246      * @param tokenId uint256 ID of the token to be transferred
1247     */
1248     function _transferFrom(address from, address to, uint256 tokenId) internal {
1249         require(ownerOf(tokenId) == from);
1250         require(to != address(0));
1251 
1252         _clearApproval(tokenId);
1253 
1254         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
1255         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
1256 
1257         _tokenOwner[tokenId] = to;
1258 
1259         emit Transfer(from, to, tokenId);
1260     }
1261 
1262     /**
1263      * @dev Internal function to invoke `onERC721Received` on a target address
1264      * The call is not executed if the target address is not a contract
1265      * @param from address representing the previous owner of the given token ID
1266      * @param to target address that will receive the tokens
1267      * @param tokenId uint256 ID of the token to be transferred
1268      * @param _data bytes optional data to send along with the call
1269      * @return whether the call correctly returned the expected magic value
1270      */
1271     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1272         internal returns (bool)
1273     {
1274         if (!to.isContract()) {
1275             return true;
1276         }
1277 
1278         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1279         return (retval == _ERC721_RECEIVED);
1280     }
1281 
1282     /**
1283      * @dev Private function to clear current approval of a given token ID
1284      * @param tokenId uint256 ID of the token to be transferred
1285      */
1286     function _clearApproval(uint256 tokenId) private {
1287         if (_tokenApprovals[tokenId] != address(0)) {
1288             _tokenApprovals[tokenId] = address(0);
1289         }
1290     }
1291 }
1292 
1293 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1294 
1295 pragma solidity ^0.5.0;
1296 
1297 /**
1298  * @title Ownable
1299  * @dev The Ownable contract has an owner address, and provides basic authorization control
1300  * functions, this simplifies the implementation of "user permissions".
1301  */
1302 contract Ownable {
1303     address private _owner;
1304 
1305     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1306 
1307     /**
1308      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1309      * account.
1310      */
1311     constructor () internal {
1312         _owner = msg.sender;
1313         emit OwnershipTransferred(address(0), _owner);
1314     }
1315 
1316     /**
1317      * @return the address of the owner.
1318      */
1319     function owner() public view returns (address) {
1320         return _owner;
1321     }
1322 
1323     /**
1324      * @dev Throws if called by any account other than the owner.
1325      */
1326     modifier onlyOwner() {
1327         require(isOwner());
1328         _;
1329     }
1330 
1331     /**
1332      * @return true if `msg.sender` is the owner of the contract.
1333      */
1334     function isOwner() public view returns (bool) {
1335         return msg.sender == _owner;
1336     }
1337 
1338     /**
1339      * @dev Allows the current owner to relinquish control of the contract.
1340      * @notice Renouncing to ownership will leave the contract without an owner.
1341      * It will not be possible to call the functions with the `onlyOwner`
1342      * modifier anymore.
1343      */
1344     function renounceOwnership() public onlyOwner {
1345         emit OwnershipTransferred(_owner, address(0));
1346         _owner = address(0);
1347     }
1348 
1349     /**
1350      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1351      * @param newOwner The address to transfer ownership to.
1352      */
1353     function transferOwnership(address newOwner) public onlyOwner {
1354         _transferOwnership(newOwner);
1355     }
1356 
1357     /**
1358      * @dev Transfers control of the contract to a newOwner.
1359      * @param newOwner The address to transfer ownership to.
1360      */
1361     function _transferOwnership(address newOwner) internal {
1362         require(newOwner != address(0));
1363         emit OwnershipTransferred(_owner, newOwner);
1364         _owner = newOwner;
1365     }
1366 }
1367 
1368 // File: contracts/BaseRegistrar.sol
1369 
1370 pragma solidity >=0.4.24;
1371 
1372 
1373 
1374 
1375 
1376 contract BaseRegistrar is ERC721, Ownable {
1377     uint constant public GRACE_PERIOD = 90 days;
1378 
1379     event ControllerAdded(address indexed controller);
1380     event ControllerRemoved(address indexed controller);
1381     event NameMigrated(uint256 indexed id, address indexed owner, uint expires);
1382     event NameRegistered(uint256 indexed id, address indexed owner, uint expires);
1383     event NameRenewed(uint256 indexed id, uint expires);
1384 
1385     // Expiration timestamp for migrated domains.
1386     uint public transferPeriodEnds;
1387 
1388     // The ENS registry
1389     ENS public ens;
1390 
1391     // The namehash of the TLD this registrar owns (eg, .eth)
1392     bytes32 public baseNode;
1393 
1394     // The interim registrar
1395     HashRegistrar public previousRegistrar;
1396 
1397     // A map of addresses that are authorised to register and renew names.
1398     mapping(address=>bool) public controllers;
1399 
1400     // Authorises a controller, who can register and renew domains.
1401     function addController(address controller) external;
1402 
1403     // Revoke controller permission for an address.
1404     function removeController(address controller) external;
1405 
1406     // Set the resolver for the TLD this registrar manages.
1407     function setResolver(address resolver) external;
1408 
1409     // Returns the expiration timestamp of the specified label hash.
1410     function nameExpires(uint256 id) external view returns(uint);
1411 
1412     // Returns true iff the specified name is available for registration.
1413     function available(uint256 id) public view returns(bool);
1414 
1415     /**
1416      * @dev Register a name.
1417      */
1418     function register(uint256 id, address owner, uint duration) external returns(uint);
1419 
1420     function renew(uint256 id, uint duration) external returns(uint);
1421 
1422     /**
1423      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
1424      */
1425     function reclaim(uint256 id, address owner) external;
1426 
1427     /**
1428      * @dev Transfers a registration from the initial registrar.
1429      * This function is called by the initial registrar when a user calls `transferRegistrars`.
1430      */
1431     function acceptRegistrarTransfer(bytes32 label, Deed deed, uint) external;
1432 }
1433 
1434 // File: contracts/StringUtils.sol
1435 
1436 pragma solidity >=0.4.24;
1437 
1438 library StringUtils {
1439     /**
1440      * @dev Returns the length of a given string
1441      *
1442      * @param s The string to measure the length of
1443      * @return The length of the input string
1444      */
1445     function strlen(string memory s) internal pure returns (uint) {
1446         uint len;
1447         uint i = 0;
1448         uint bytelength = bytes(s).length;
1449         for(len = 0; i < bytelength; len++) {
1450             byte b = bytes(s)[i];
1451             if(b < 0x80) {
1452                 i += 1;
1453             } else if (b < 0xE0) {
1454                 i += 2;
1455             } else if (b < 0xF0) {
1456                 i += 3;
1457             } else if (b < 0xF8) {
1458                 i += 4;
1459             } else if (b < 0xFC) {
1460                 i += 5;
1461             } else {
1462                 i += 6;
1463             }
1464         }
1465         return len;
1466     }
1467 }
1468 
1469 // File: contracts/ETHRegistrarController.sol
1470 
1471 pragma solidity ^0.5.0;
1472 
1473 
1474 
1475 
1476 
1477 /**
1478  * @dev A registrar controller for registering and renewing names at fixed cost.
1479  */
1480 contract ETHRegistrarController is Ownable {
1481     using StringUtils for *;
1482 
1483     uint constant public MIN_REGISTRATION_DURATION = 28 days;
1484 
1485     bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));
1486     bytes4 constant private COMMITMENT_CONTROLLER_ID = bytes4(
1487         keccak256("rentPrice(string,uint256)") ^
1488         keccak256("available(string)") ^
1489         keccak256("makeCommitment(string,address,bytes32)") ^
1490         keccak256("commit(bytes32)") ^
1491         keccak256("register(string,address,uint256,bytes32)") ^
1492         keccak256("renew(string,uint256)")
1493     );
1494 
1495     BaseRegistrar base;
1496     PriceOracle prices;
1497     uint public minCommitmentAge;
1498     uint public maxCommitmentAge;
1499 
1500     mapping(bytes32=>uint) public commitments;
1501 
1502     event NameRegistered(string name, bytes32 indexed label, address indexed owner, uint cost, uint expires);
1503     event NameRenewed(string name, bytes32 indexed label, uint cost, uint expires);
1504     event NewPriceOracle(address indexed oracle);
1505 
1506     constructor(BaseRegistrar _base, PriceOracle _prices, uint _minCommitmentAge, uint _maxCommitmentAge) public {
1507         require(_maxCommitmentAge > _minCommitmentAge);
1508 
1509         base = _base;
1510         prices = _prices;
1511         minCommitmentAge = _minCommitmentAge;
1512         maxCommitmentAge = _maxCommitmentAge;
1513     }
1514 
1515     function rentPrice(string memory name, uint duration) view public returns(uint) {
1516         bytes32 hash = keccak256(bytes(name));
1517         return prices.price(name, base.nameExpires(uint256(hash)), duration);
1518     }
1519 
1520     function valid(string memory name) public view returns(bool) {
1521         return name.strlen() > 6;
1522     }
1523 
1524     function available(string memory name) public view returns(bool) {
1525         bytes32 label = keccak256(bytes(name));
1526         return valid(name) && base.available(uint256(label));
1527     }
1528 
1529     function makeCommitment(string memory name, address owner, bytes32 secret) pure public returns(bytes32) {
1530         bytes32 label = keccak256(bytes(name));
1531         return keccak256(abi.encodePacked(label, owner, secret));
1532     }
1533 
1534     function commit(bytes32 commitment) public {
1535         require(commitments[commitment] + maxCommitmentAge < now);
1536         commitments[commitment] = now;
1537     }
1538 
1539     function register(string calldata name, address owner, uint duration, bytes32 secret) external payable {
1540         // Require a valid commitment
1541         bytes32 commitment = makeCommitment(name, owner, secret);
1542         require(commitments[commitment] + minCommitmentAge <= now);
1543 
1544         // If the commitment is too old, or the name is registered, stop
1545         require(commitments[commitment] + maxCommitmentAge > now);
1546         require(available(name));
1547 
1548         delete(commitments[commitment]);
1549 
1550         uint cost = rentPrice(name, duration);
1551         require(duration >= MIN_REGISTRATION_DURATION);
1552         require(msg.value >= cost);
1553 
1554         bytes32 label = keccak256(bytes(name));
1555         uint expires = base.register(uint256(label), owner, duration);
1556         emit NameRegistered(name, label, owner, cost, expires);
1557 
1558         if(msg.value > cost) {
1559             msg.sender.transfer(msg.value - cost);
1560         }
1561     }
1562 
1563     function renew(string calldata name, uint duration) external payable {
1564         uint cost = rentPrice(name, duration);
1565         require(msg.value >= cost);
1566 
1567         bytes32 label = keccak256(bytes(name));
1568         uint expires = base.renew(uint256(label), duration);
1569 
1570         if(msg.value > cost) {
1571             msg.sender.transfer(msg.value - cost);
1572         }
1573 
1574         emit NameRenewed(name, label, cost, expires);
1575     }
1576 
1577     function setPriceOracle(PriceOracle _prices) public onlyOwner {
1578         prices = _prices;
1579         emit NewPriceOracle(address(prices));
1580     }
1581 
1582     function setCommitmentAges(uint _minCommitmentAge, uint _maxCommitmentAge) public onlyOwner {
1583         minCommitmentAge = _minCommitmentAge;
1584         maxCommitmentAge = _maxCommitmentAge;
1585     }
1586 
1587     function withdraw() public onlyOwner {
1588         msg.sender.transfer(address(this).balance);
1589     }
1590 
1591     function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
1592         return interfaceID == INTERFACE_META_ID ||
1593                interfaceID == COMMITMENT_CONTROLLER_ID;
1594     }
1595 }
1596 
1597 /**
1598  * A simple resolver anyone can use; only allows the owner of a node to set its
1599  * address.
1600  */
1601 contract PublicResolver {
1602     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
1603     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
1604     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
1605     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
1606     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
1607     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
1608     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
1609 
1610     event AddrChanged(bytes32 indexed node, address a);
1611     event ContentChanged(bytes32 indexed node, bytes32 hash);
1612     event NameChanged(bytes32 indexed node, string name);
1613     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
1614     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
1615     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
1616 
1617     struct PublicKey {
1618         bytes32 x;
1619         bytes32 y;
1620     }
1621 
1622     struct Record {
1623         address addr;
1624         bytes32 content;
1625         string name;
1626         PublicKey pubkey;
1627         mapping(string=>string) text;
1628         mapping(uint256=>bytes) abis;
1629     }
1630 
1631     ENS ens;
1632     mapping (bytes32 => Record) records;
1633 
1634     /**
1635      * Sets the address associated with an ENS node.
1636      * May only be called by the owner of that node in the ENS registry.
1637      * @param node The node to update.
1638      * @param addr The address to set.
1639      */
1640     function setAddr(bytes32 node, address addr) public;
1641 
1642     /**
1643      * Sets the content hash associated with an ENS node.
1644      * May only be called by the owner of that node in the ENS registry.
1645      * Note that this resource type is not standardized, and will likely change
1646      * in future to a resource type based on multihash.
1647      * @param node The node to update.
1648      * @param hash The content hash to set
1649      */
1650     function setContent(bytes32 node, bytes32 hash) public;
1651     
1652     /**
1653      * Sets the name associated with an ENS node, for reverse records.
1654      * May only be called by the owner of that node in the ENS registry.
1655      * @param node The node to update.
1656      * @param name The name to set.
1657      */
1658     function setName(bytes32 node, string memory name) public;
1659 
1660     /**
1661      * Sets the ABI associated with an ENS node.
1662      * Nodes may have one ABI of each content type. To remove an ABI, set it to
1663      * the empty string.
1664      * @param node The node to update.
1665      * @param contentType The content type of the ABI
1666      * @param data The ABI data.
1667      */
1668     function setABI(bytes32 node, uint256 contentType, bytes memory data) public;
1669     
1670     /**
1671      * Sets the SECP256k1 public key associated with an ENS node.
1672      * @param node The ENS node to query
1673      * @param x the X coordinate of the curve point for the public key.
1674      * @param y the Y coordinate of the curve point for the public key.
1675      */
1676     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public;
1677 
1678     /**
1679      * Sets the text data associated with an ENS node and key.
1680      * May only be called by the owner of that node in the ENS registry.
1681      * @param node The node to update.
1682      * @param key The key to set.
1683      * @param value The text data value to set.
1684      */
1685     function setText(bytes32 node, string memory key, string memory value) public;
1686     /**
1687      * Returns the text data associated with an ENS node and key.
1688      * @param node The ENS node to query.
1689      * @param key The text data key to query.
1690      * @return The associated text data.
1691      */
1692     function text(bytes32 node, string memory key) public view returns (string memory);
1693 
1694     /**
1695      * Returns the SECP256k1 public key associated with an ENS node.
1696      * Defined in EIP 619.
1697      * @param node The ENS node to query
1698      * @return x, y the X and Y coordinates of the curve point for the public key.
1699      */
1700     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y);
1701     /**
1702      * Returns the ABI associated with an ENS node.
1703      * Defined in EIP205.
1704      * @param node The ENS node to query
1705      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
1706      * @return contentType The content type of the return value
1707      * @return data The ABI data
1708      */
1709     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes memory data);
1710     /**
1711      * Returns the name associated with an ENS node, for reverse records.
1712      * Defined in EIP181.
1713      * @param node The ENS node to query.
1714      * @return The associated name.
1715      */
1716     function name(bytes32 node) public view returns (string memory);
1717     /**
1718      * Returns the content hash associated with an ENS node.
1719      * Note that this resource type is not standardized, and will likely change
1720      * in future to a resource type based on multihash.
1721      * @param node The ENS node to query.
1722      * @return The associated content hash.
1723      */
1724     function content(bytes32 node) public view returns (bytes32);
1725     /**
1726      * Returns the address associated with an ENS node.
1727      * @param node The ENS node to query.
1728      * @return The associated address.
1729      */
1730     function addr(bytes32 node) public view returns (address);
1731 
1732     /**
1733      * Returns true if the resolver implements the interface specified by the provided hash.
1734      * @param interfaceID The ID of the interface to check for.
1735      * @return True if the contract implements the requested interface.
1736      */
1737     function supportsInterface(bytes4 interfaceID) public pure returns (bool);
1738 }
1739 
1740 
1741 pragma solidity ^0.5.6;
1742 
1743 
1744 contract ESENSFactory {
1745   ENS public registry;
1746   PublicResolver public resolver;
1747   ETHRegistrarController public permanentRegistrar;
1748   BaseRegistrar public baseRegistrar;
1749 
1750   uint public network_id;
1751   
1752   constructor (uint network) public{
1753     network_id = network;
1754 
1755     if (network_id == 1) {
1756       permanentRegistrar = ETHRegistrarController(0xF0AD5cAd05e10572EfcEB849f6Ff0c68f9700455);
1757       baseRegistrar = BaseRegistrar(0xFaC7BEA255a6990f749363002136aF6556b31e04);
1758       registry = ENS(0x314159265dD8dbb310642f98f50C066173C1259b);
1759       resolver = PublicResolver(0x5FfC014343cd971B7eb70732021E26C35B744cc4);
1760 //    registrar = Registrar(0x6090A6e47849629b7245Dfa1Ca21D94cd15878Ef);
1761 //    reverseRegistrar = ReverseRegistrar(0x9062C0A6Dbd6108336BcBe4593a3D1cE05512069);
1762     } else if (network_id == 3) {
1763       permanentRegistrar = ETHRegistrarController(0x357DBd063BeA7F0713BF88A3e97B7436B0235979);
1764       baseRegistrar = BaseRegistrar(0x227Fcb6Ddf14880413EF4f1A3dF2Bbb32bcb29d7);
1765       registry = ENS(0x112234455C3a32FD11230C42E7Bccd4A84e02010);
1766       resolver = PublicResolver(0x5FfC014343cd971B7eb70732021E26C35B744cc4);
1767 //    registrar = Registrar(0xc19fD9004B5c9789391679de6d766b981DB94610);
1768 //    reverseRegistrar = ReverseRegistrar(0x67d5418a000534a8F1f5FF4229cC2f439e63BBe2);
1769 //    testRegistrar = FIFSRegistrar(0x21397c1A1F4aCD9132fE36Df011610564b87E24b);
1770     }
1771   }
1772 }
1773 
1774 
1775 pragma solidity ^0.5.6;
1776 
1777 
1778 contract ESController {
1779 
1780   bytes32 constant TLD_NODE = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae; // namehash('eth')
1781   bytes32 constant ETHSIMPLE_NAMEHASH = 0xff60be0907d071946e59cea1ebac55c2e39e886f0101b78c305f67bdc2c4bd73; // namehash('ethsimple.eth')
1782   bytes32 constant ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2; // namehash('addr.reverse')
1783 
1784   event commitmentSubmitted(bytes32 _commitment, address _owner, uint _submitted);
1785   event registrationSubmitted(bytes32 _commitment, address _owner, uint _submitted);
1786 
1787   ESENSFactory public ensFactory;
1788   ENS public registry;
1789   ETHRegistrarController public permanentRegistrar; 
1790   PublicResolver public resolver; 
1791   BaseRegistrar public baseRegistrar; 
1792 
1793   address payable public registrarOwner; 
1794   address public registrarOperator; 
1795   
1796   uint networkFee = 135; 
1797   uint gasEstimate = 286191 * 10000000000; 
1798   // TODO: Connect to gas price oracle to estimate what the server will be paying, 
1799   // and subtract that from the amount sent to the registrar, 
1800   // also use that in the price estimator
1801   
1802   struct Commitment {
1803     uint totalSent;
1804     address owner;
1805     address sender;
1806   }
1807   
1808   mapping (bytes32 => Commitment) public commitments;
1809 
1810   modifier registrar_owner_only() {
1811     require(msg.sender == registrarOwner);
1812     _;
1813   }
1814 
1815   constructor(uint _network_id, address _operator) public {
1816     registrarOwner = msg.sender;
1817     registrarOperator = _operator;
1818 
1819     if (_network_id == 1) {
1820       ensFactory = ESENSFactory(0x306193c2ab1E659EE9ba4E5f0633B80D29CE33B3);
1821       permanentRegistrar = ETHRegistrarController(0xF0AD5cAd05e10572EfcEB849f6Ff0c68f9700455);
1822       baseRegistrar = BaseRegistrar(0xFaC7BEA255a6990f749363002136aF6556b31e04);
1823     } else if (_network_id == 3) {
1824       ensFactory = ESENSFactory(0xC8349c6dab9682E45E5B482CC633b50b0e458ba8);
1825       permanentRegistrar = ETHRegistrarController(0x357DBd063BeA7F0713BF88A3e97B7436B0235979);
1826       baseRegistrar = BaseRegistrar(0x227Fcb6Ddf14880413EF4f1A3dF2Bbb32bcb29d7);
1827     } else {
1828       revert("Provide network id");
1829     }
1830     registry = ENS(address(ensFactory.registry()));
1831     resolver = PublicResolver(address(ensFactory.resolver()));
1832   }
1833 
1834   function makeCommitment(string memory _name, bytes32 _secret) view public returns(bytes32) {
1835     return permanentRegistrar.makeCommitment(_name, address(this), _secret);
1836   }
1837   
1838   // Estimate the cost for the user before the user queries commit()
1839   function registrationCost(string memory _name, uint _duration) view public returns(uint) {
1840       return permanentRegistrar.rentPrice(_name, _duration) * networkFee + gasEstimate;
1841   }
1842 
1843   function commit(bytes32 _commitment, address _owner) public payable {
1844       require(commitments[_commitment].owner == address(0), "Domain registration has already been submitted");
1845       // TODO: Check if name already exists
1846       require(msg.value >= gasEstimate, "You must submit Ether to register a domain");
1847       
1848       commitments[_commitment] = Commitment(msg.value, _owner, msg.sender);
1849       permanentRegistrar.commit(_commitment);
1850 
1851       emit commitmentSubmitted(_commitment, _owner, msg.value);
1852   }
1853   
1854   function register (
1855       string memory _name, 
1856     //   address _registrarAddress,
1857       uint _duration, 
1858       bytes32 _secret,
1859       bytes32 _namehash,
1860       address _resolver,
1861       bytes32 _contentHash
1862     ) public {
1863 
1864       bytes32 commitmentSha = permanentRegistrar.makeCommitment(_name, address(this), _secret);
1865       Commitment memory commitment = commitments[commitmentSha];
1866 
1867       // Let the registrar owner or purchaser query this
1868       require(msg.sender == registrarOwner || msg.sender == commitment.owner || msg.sender == commitment.sender || msg.sender == registrarOperator);
1869 
1870       // Leaving the amount sent to the registrar unchecked, can allow for 'coupons', 
1871       // need to put in stronger checks to ensure we don't lose money on gas fees
1872       permanentRegistrar.register.value(commitment.totalSent - gasEstimate)(_name, address(this), _duration, _secret); // User can't register a domain for longer than their payment will allow
1873       registry.setResolver(_namehash, _resolver);
1874       resolver.setAddr(_namehash, commitment.owner);
1875       // if (_contentHash != 0x0000000000000000000000000000000000000000000000000000000000000000) {
1876       resolver.setContent(_namehash, _contentHash);
1877       // }
1878       baseRegistrar.reclaim(uint256(keccak256(bytes(_name))), commitment.owner);
1879       baseRegistrar.safeTransferFrom(address(this), commitment.owner, uint256(keccak256(bytes(_name)))); // TODO Note: This throws an error if someone tries to register a contract address
1880 
1881       emit registrationSubmitted(commitmentSha, commitment.owner, commitment.totalSent);      
1882 
1883       delete commitments[commitmentSha]; // Recover some gas
1884   }
1885   
1886   function withdraw() public registrar_owner_only {
1887       registrarOwner.transfer(address(this).balance);
1888   }
1889   
1890   function setNetworkPower(uint fee) public registrar_owner_only {
1891       networkFee = fee;
1892   }
1893   
1894   function setGasEstimate(uint _gasEstimate) public registrar_owner_only {
1895       gasEstimate = _gasEstimate;
1896   }
1897   
1898   function transferOwnership(address payable _newOwner) public registrar_owner_only {
1899       registrarOwner = _newOwner;
1900   }
1901   
1902   function setOperator(address payable _newOperator) public registrar_owner_only {
1903       registrarOperator = _newOperator;
1904   }
1905   
1906   function removeCommitment(bytes32 _commitment) public registrar_owner_only {
1907       delete commitments[_commitment]; // Recover some gas
1908   }
1909   
1910   // TODO: Maybe backup domain recovery method, though method atomicity should prevent the contract from ever owning a domain
1911   
1912   function() external payable { }
1913   
1914   function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4){
1915     return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
1916   } 
1917 }