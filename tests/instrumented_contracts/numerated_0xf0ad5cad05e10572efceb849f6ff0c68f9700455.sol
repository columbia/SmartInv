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
64 // File: @ensdomains/ens/contracts/DeedImplementation.sol
65 
66 pragma solidity ^0.5.0;
67 
68 
69 /**
70  * @title Deed to hold ether in exchange for ownership of a node
71  * @dev The deed can be controlled only by the registrar and can only send ether back to the owner.
72  */
73 contract DeedImplementation is Deed {
74 
75     address payable constant burn = address(0xdead);
76 
77     address payable private _owner;
78     address private _previousOwner;
79     address private _registrar;
80 
81     uint private _creationDate;
82     uint private _value;
83 
84     bool active;
85 
86     event OwnerChanged(address newOwner);
87     event DeedClosed();
88 
89     modifier onlyRegistrar {
90         require(msg.sender == _registrar);
91         _;
92     }
93 
94     modifier onlyActive {
95         require(active);
96         _;
97     }
98 
99     constructor(address payable initialOwner) public payable {
100         _owner = initialOwner;
101         _registrar = msg.sender;
102         _creationDate = now;
103         active = true;
104         _value = msg.value;
105     }
106 
107     function setOwner(address payable newOwner) external onlyRegistrar {
108         require(newOwner != address(0x0));
109         _previousOwner = _owner;  // This allows contracts to check who sent them the ownership
110         _owner = newOwner;
111         emit OwnerChanged(newOwner);
112     }
113 
114     function setRegistrar(address newRegistrar) external onlyRegistrar {
115         _registrar = newRegistrar;
116     }
117 
118     function setBalance(uint newValue, bool throwOnFailure) external onlyRegistrar onlyActive {
119         // Check if it has enough balance to set the value
120         require(_value >= newValue);
121         _value = newValue;
122         // Send the difference to the owner
123         require(_owner.send(address(this).balance - newValue) || !throwOnFailure);
124     }
125 
126     /**
127      * @dev Close a deed and refund a specified fraction of the bid value
128      *
129      * @param refundRatio The amount*1/1000 to refund
130      */
131     function closeDeed(uint refundRatio) external onlyRegistrar onlyActive {
132         active = false;
133         require(burn.send(((1000 - refundRatio) * address(this).balance)/1000));
134         emit DeedClosed();
135         _destroyDeed();
136     }
137 
138     /**
139      * @dev Close a deed and refund a specified fraction of the bid value
140      */
141     function destroyDeed() external {
142         _destroyDeed();
143     }
144 
145     function owner() external view returns (address) {
146         return _owner;
147     }
148 
149     function previousOwner() external view returns (address) {
150         return _previousOwner;
151     }
152 
153     function value() external view returns (uint) {
154         return _value;
155     }
156 
157     function creationDate() external view returns (uint) {
158         _creationDate;
159     }
160 
161     function _destroyDeed() internal {
162         require(!active);
163 
164         // Instead of selfdestruct(owner), invoke owner fallback function to allow
165         // owner to log an event if desired; but owner should also be aware that
166         // its fallback function can also be invoked by setBalance
167         if (_owner.send(address(this).balance)) {
168             selfdestruct(burn);
169         }
170     }
171 }
172 
173 // File: @ensdomains/ens/contracts/Registrar.sol
174 
175 pragma solidity >=0.4.24;
176 
177 
178 interface Registrar {
179 
180     enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }
181 
182     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
183     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
184     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
185     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
186     event HashReleased(bytes32 indexed hash, uint value);
187     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
188 
189     function startAuction(bytes32 _hash) external;
190     function startAuctions(bytes32[] calldata _hashes) external;
191     function newBid(bytes32 sealedBid) external payable;
192     function startAuctionsAndBid(bytes32[] calldata hashes, bytes32 sealedBid) external payable;
193     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) external;
194     function cancelBid(address bidder, bytes32 seal) external;
195     function finalizeAuction(bytes32 _hash) external;
196     function transfer(bytes32 _hash, address payable newOwner) external;
197     function releaseDeed(bytes32 _hash) external;
198     function invalidateName(string calldata unhashedName) external;
199     function eraseNode(bytes32[] calldata labels) external;
200     function transferRegistrars(bytes32 _hash) external;
201     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) external;
202     function entries(bytes32 _hash) external view returns (Mode, address, uint, uint, uint);
203 }
204 
205 // File: @ensdomains/ens/contracts/HashRegistrar.sol
206 
207 pragma solidity ^0.5.0;
208 
209 
210 /*
211 
212 Temporary Hash Registrar
213 ========================
214 
215 This is a simplified version of a hash registrar. It is purporsefully limited:
216 names cannot be six letters or shorter, new auctions will stop after 4 years.
217 
218 The plan is to test the basic features and then move to a new contract in at most
219 2 years, when some sort of renewal mechanism will be enabled.
220 */
221 
222 
223 
224 
225 /**
226  * @title Registrar
227  * @dev The registrar handles the auction process for each subnode of the node it owns.
228  */
229 contract HashRegistrar is Registrar {
230     ENS public ens;
231     bytes32 public rootNode;
232 
233     mapping (bytes32 => Entry) _entries;
234     mapping (address => mapping (bytes32 => Deed)) public sealedBids;
235 
236     uint32 constant totalAuctionLength = 5 days;
237     uint32 constant revealPeriod = 48 hours;
238     uint32 public constant launchLength = 8 weeks;
239 
240     uint constant minPrice = 0.01 ether;
241     uint public registryStarted;
242 
243     struct Entry {
244         Deed deed;
245         uint registrationDate;
246         uint value;
247         uint highestBid;
248     }
249 
250     modifier inState(bytes32 _hash, Mode _state) {
251         require(state(_hash) == _state);
252         _;
253     }
254 
255     modifier onlyOwner(bytes32 _hash) {
256         require(state(_hash) == Mode.Owned && msg.sender == _entries[_hash].deed.owner());
257         _;
258     }
259 
260     modifier registryOpen() {
261         require(now >= registryStarted && now <= registryStarted + (365 * 4) * 1 days && ens.owner(rootNode) == address(this));
262         _;
263     }
264 
265     /**
266      * @dev Constructs a new Registrar, with the provided address as the owner of the root node.
267      *
268      * @param _ens The address of the ENS
269      * @param _rootNode The hash of the rootnode.
270      */
271     constructor(ENS _ens, bytes32 _rootNode, uint _startDate) public {
272         ens = _ens;
273         rootNode = _rootNode;
274         registryStarted = _startDate > 0 ? _startDate : now;
275     }
276 
277     /**
278      * @dev Start an auction for an available hash
279      *
280      * @param _hash The hash to start an auction on
281      */
282     function startAuction(bytes32 _hash) external {
283         _startAuction(_hash);
284     }
285 
286     /**
287      * @dev Start multiple auctions for better anonymity
288      *
289      * Anyone can start an auction by sending an array of hashes that they want to bid for.
290      * Arrays are sent so that someone can open up an auction for X dummy hashes when they
291      * are only really interested in bidding for one. This will increase the cost for an
292      * attacker to simply bid blindly on all new auctions. Dummy auctions that are
293      * open but not bid on are closed after a week.
294      *
295      * @param _hashes An array of hashes, at least one of which you presumably want to bid on
296      */
297     function startAuctions(bytes32[] calldata _hashes) external {
298         _startAuctions(_hashes);
299     }
300 
301     /**
302      * @dev Submit a new sealed bid on a desired hash in a blind auction
303      *
304      * Bids are sent by sending a message to the main contract with a hash and an amount. The hash
305      * contains information about the bid, including the bidded hash, the bid amount, and a random
306      * salt. Bids are not tied to any one auction until they are revealed. The value of the bid
307      * itself can be masqueraded by sending more than the value of your actual bid. This is
308      * followed by a 48h reveal period. Bids revealed after this period will be burned and the ether unrecoverable.
309      * Since this is an auction, it is expected that most public hashes, like known domains and common dictionary
310      * words, will have multiple bidders pushing the price up.
311      *
312      * @param sealedBid A sealedBid, created by the shaBid function
313      */
314     function newBid(bytes32 sealedBid) external payable {
315         _newBid(sealedBid);
316     }
317 
318     /**
319      * @dev Start a set of auctions and bid on one of them
320      *
321      * This method functions identically to calling `startAuctions` followed by `newBid`,
322      * but all in one transaction.
323      *
324      * @param hashes A list of hashes to start auctions on.
325      * @param sealedBid A sealed bid for one of the auctions.
326      */
327     function startAuctionsAndBid(bytes32[] calldata hashes, bytes32 sealedBid) external payable {
328         _startAuctions(hashes);
329         _newBid(sealedBid);
330     }
331 
332     /**
333      * @dev Submit the properties of a bid to reveal them
334      *
335      * @param _hash The node in the sealedBid
336      * @param _value The bid amount in the sealedBid
337      * @param _salt The sale in the sealedBid
338      */
339     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) external {
340         bytes32 seal = shaBid(_hash, msg.sender, _value, _salt);
341         Deed bid = sealedBids[msg.sender][seal];
342         require(address(bid) != address(0x0));
343 
344         sealedBids[msg.sender][seal] = Deed(address(0x0));
345         Entry storage h = _entries[_hash];
346         uint value = min(_value, bid.value());
347         bid.setBalance(value, true);
348 
349         Mode auctionState = state(_hash);
350         if (auctionState == Mode.Owned) {
351             // Too late! Bidder loses their bid. Gets 0.5% back.
352             bid.closeDeed(5);
353             emit BidRevealed(_hash, msg.sender, value, 1);
354         } else if (auctionState != Mode.Reveal) {
355             // Invalid phase
356             revert();
357         } else if (value < minPrice || bid.creationDate() > h.registrationDate - revealPeriod) {
358             // Bid too low or too late, refund 99.5%
359             bid.closeDeed(995);
360             emit BidRevealed(_hash, msg.sender, value, 0);
361         } else if (value > h.highestBid) {
362             // New winner
363             // Cancel the other bid, refund 99.5%
364             if (address(h.deed) != address(0x0)) {
365                 Deed previousWinner = h.deed;
366                 previousWinner.closeDeed(995);
367             }
368 
369             // Set new winner
370             // Per the rules of a vickery auction, the value becomes the previous highestBid
371             h.value = h.highestBid;  // will be zero if there's only 1 bidder
372             h.highestBid = value;
373             h.deed = bid;
374             emit BidRevealed(_hash, msg.sender, value, 2);
375         } else if (value > h.value) {
376             // Not winner, but affects second place
377             h.value = value;
378             bid.closeDeed(995);
379             emit BidRevealed(_hash, msg.sender, value, 3);
380         } else {
381             // Bid doesn't affect auction
382             bid.closeDeed(995);
383             emit BidRevealed(_hash, msg.sender, value, 4);
384         }
385     }
386 
387     /**
388      * @dev Cancel a bid
389      *
390      * @param seal The value returned by the shaBid function
391      */
392     function cancelBid(address bidder, bytes32 seal) external {
393         Deed bid = sealedBids[bidder][seal];
394         
395         // If a sole bidder does not `unsealBid` in time, they have a few more days
396         // where they can call `startAuction` (again) and then `unsealBid` during
397         // the revealPeriod to get back their bid value.
398         // For simplicity, they should call `startAuction` within
399         // 9 days (2 weeks - totalAuctionLength), otherwise their bid will be
400         // cancellable by anyone.
401         require(address(bid) != address(0x0) && now >= bid.creationDate() + totalAuctionLength + 2 weeks);
402 
403         // Send the canceller 0.5% of the bid, and burn the rest.
404         bid.setOwner(msg.sender);
405         bid.closeDeed(5);
406         sealedBids[bidder][seal] = Deed(0);
407         emit BidRevealed(seal, bidder, 0, 5);
408     }
409 
410     /**
411      * @dev Finalize an auction after the registration date has passed
412      *
413      * @param _hash The hash of the name the auction is for
414      */
415     function finalizeAuction(bytes32 _hash) external onlyOwner(_hash) {
416         Entry storage h = _entries[_hash];
417         
418         // Handles the case when there's only a single bidder (h.value is zero)
419         h.value = max(h.value, minPrice);
420         h.deed.setBalance(h.value, true);
421 
422         trySetSubnodeOwner(_hash, h.deed.owner());
423         emit HashRegistered(_hash, h.deed.owner(), h.value, h.registrationDate);
424     }
425 
426     /**
427      * @dev The owner of a domain may transfer it to someone else at any time.
428      *
429      * @param _hash The node to transfer
430      * @param newOwner The address to transfer ownership to
431      */
432     function transfer(bytes32 _hash, address payable newOwner) external onlyOwner(_hash) {
433         require(newOwner != address(0x0));
434 
435         Entry storage h = _entries[_hash];
436         h.deed.setOwner(newOwner);
437         trySetSubnodeOwner(_hash, newOwner);
438     }
439 
440     /**
441      * @dev After some time, or if we're no longer the registrar, the owner can release
442      *      the name and get their ether back.
443      *
444      * @param _hash The node to release
445      */
446     function releaseDeed(bytes32 _hash) external onlyOwner(_hash) {
447         Entry storage h = _entries[_hash];
448         Deed deedContract = h.deed;
449 
450         require(now >= h.registrationDate + 365 days || ens.owner(rootNode) != address(this));
451 
452         h.value = 0;
453         h.highestBid = 0;
454         h.deed = Deed(0);
455 
456         _tryEraseSingleNode(_hash);
457         deedContract.closeDeed(1000);
458         emit HashReleased(_hash, h.value);        
459     }
460 
461     /**
462      * @dev Submit a name 6 characters long or less. If it has been registered,
463      *      the submitter will earn 50% of the deed value. 
464      * 
465      * We are purposefully handicapping the simplified registrar as a way 
466      * to force it into being restructured in a few years.
467      *
468      * @param unhashedName An invalid name to search for in the registry.
469      */
470     function invalidateName(string calldata unhashedName)
471         external
472         inState(keccak256(abi.encode(unhashedName)), Mode.Owned)
473     {
474         require(strlen(unhashedName) <= 6);
475         bytes32 hash = keccak256(abi.encode(unhashedName));
476 
477         Entry storage h = _entries[hash];
478 
479         _tryEraseSingleNode(hash);
480 
481         if (address(h.deed) != address(0x0)) {
482             // Reward the discoverer with 50% of the deed
483             // The previous owner gets 50%
484             h.value = max(h.value, minPrice);
485             h.deed.setBalance(h.value/2, false);
486             h.deed.setOwner(msg.sender);
487             h.deed.closeDeed(1000);
488         }
489 
490         emit HashInvalidated(hash, unhashedName, h.value, h.registrationDate);
491 
492         h.value = 0;
493         h.highestBid = 0;
494         h.deed = Deed(0);
495     }
496 
497     /**
498      * @dev Allows anyone to delete the owner and resolver records for a (subdomain of) a
499      *      name that is not currently owned in the registrar. If passing, eg, 'foo.bar.eth',
500      *      the owner and resolver fields on 'foo.bar.eth' and 'bar.eth' will all be cleared.
501      *
502      * @param labels A series of label hashes identifying the name to zero out, rooted at the
503      *        registrar's root. Must contain at least one element. For instance, to zero 
504      *        'foo.bar.eth' on a registrar that owns '.eth', pass an array containing
505      *        [keccak256('foo'), keccak256('bar')].
506      */
507     function eraseNode(bytes32[] calldata labels) external {
508         require(labels.length != 0);
509         require(state(labels[labels.length - 1]) != Mode.Owned);
510 
511         _eraseNodeHierarchy(labels.length - 1, labels, rootNode);
512     }
513 
514     /**
515      * @dev Transfers the deed to the current registrar, if different from this one.
516      *
517      * Used during the upgrade process to a permanent registrar.
518      *
519      * @param _hash The name hash to transfer.
520      */
521     function transferRegistrars(bytes32 _hash) external onlyOwner(_hash) {
522         address registrar = ens.owner(rootNode);
523         require(registrar != address(this));
524 
525         // Migrate the deed
526         Entry storage h = _entries[_hash];
527         h.deed.setRegistrar(registrar);
528 
529         // Call the new registrar to accept the transfer
530         Registrar(registrar).acceptRegistrarTransfer(_hash, h.deed, h.registrationDate);
531 
532         // Zero out the Entry
533         h.deed = Deed(0);
534         h.registrationDate = 0;
535         h.value = 0;
536         h.highestBid = 0;
537     }
538 
539     /**
540      * @dev Accepts a transfer from a previous registrar; stubbed out here since there
541      *      is no previous registrar implementing this interface.
542      *
543      * @param hash The sha3 hash of the label to transfer.
544      * @param deed The Deed object for the name being transferred in.
545      * @param registrationDate The date at which the name was originally registered.
546      */
547     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) external {
548         hash; deed; registrationDate; // Don't warn about unused variables
549     }
550 
551     function entries(bytes32 _hash) external view returns (Mode, address, uint, uint, uint) {
552         Entry storage h = _entries[_hash];
553         return (state(_hash), address(h.deed), h.registrationDate, h.value, h.highestBid);
554     }
555 
556     // State transitions for names:
557     //   Open -> Auction (startAuction)
558     //   Auction -> Reveal
559     //   Reveal -> Owned
560     //   Reveal -> Open (if nobody bid)
561     //   Owned -> Open (releaseDeed or invalidateName)
562     function state(bytes32 _hash) public view returns (Mode) {
563         Entry storage entry = _entries[_hash];
564 
565         if (!isAllowed(_hash, now)) {
566             return Mode.NotYetAvailable;
567         } else if (now < entry.registrationDate) {
568             if (now < entry.registrationDate - revealPeriod) {
569                 return Mode.Auction;
570             } else {
571                 return Mode.Reveal;
572             }
573         } else {
574             if (entry.highestBid == 0) {
575                 return Mode.Open;
576             } else {
577                 return Mode.Owned;
578             }
579         }
580     }
581 
582     /**
583      * @dev Determines if a name is available for registration yet
584      *
585      * Each name will be assigned a random date in which its auction
586      * can be started, from 0 to 8 weeks
587      *
588      * @param _hash The hash to start an auction on
589      * @param _timestamp The timestamp to query about
590      */
591     function isAllowed(bytes32 _hash, uint _timestamp) public view returns (bool allowed) {
592         return _timestamp > getAllowedTime(_hash);
593     }
594 
595     /**
596      * @dev Returns available date for hash
597      *
598      * The available time from the `registryStarted` for a hash is proportional
599      * to its numeric value.
600      *
601      * @param _hash The hash to start an auction on
602      */
603     function getAllowedTime(bytes32 _hash) public view returns (uint) {
604         return registryStarted + ((launchLength * (uint(_hash) >> 128)) >> 128);
605         // Right shift operator: a >> b == a / 2**b
606     }
607 
608     /**
609      * @dev Hash the values required for a secret bid
610      *
611      * @param hash The node corresponding to the desired namehash
612      * @param value The bid amount
613      * @param salt A random value to ensure secrecy of the bid
614      * @return The hash of the bid values
615      */
616     function shaBid(bytes32 hash, address owner, uint value, bytes32 salt) public pure returns (bytes32) {
617         return keccak256(abi.encodePacked(hash, owner, value, salt));
618     }
619 
620     function _tryEraseSingleNode(bytes32 label) internal {
621         if (ens.owner(rootNode) == address(this)) {
622             ens.setSubnodeOwner(rootNode, label, address(this));
623             bytes32 node = keccak256(abi.encodePacked(rootNode, label));
624             ens.setResolver(node, address(0x0));
625             ens.setOwner(node, address(0x0));
626         }
627     }
628 
629     function _startAuction(bytes32 _hash) internal registryOpen() {
630         Mode mode = state(_hash);
631         if (mode == Mode.Auction) return;
632         require(mode == Mode.Open);
633 
634         Entry storage newAuction = _entries[_hash];
635         newAuction.registrationDate = now + totalAuctionLength;
636         newAuction.value = 0;
637         newAuction.highestBid = 0;
638         emit AuctionStarted(_hash, newAuction.registrationDate);
639     }
640 
641     function _startAuctions(bytes32[] memory _hashes) internal {
642         for (uint i = 0; i < _hashes.length; i ++) {
643             _startAuction(_hashes[i]);
644         }
645     }
646 
647     function _newBid(bytes32 sealedBid) internal {
648         require(address(sealedBids[msg.sender][sealedBid]) == address(0x0));
649         require(msg.value >= minPrice);
650 
651         // Creates a new hash contract with the owner
652         Deed bid = (new DeedImplementation).value(msg.value)(msg.sender);
653         sealedBids[msg.sender][sealedBid] = bid;
654         emit NewBid(sealedBid, msg.sender, msg.value);
655     }
656 
657     function _eraseNodeHierarchy(uint idx, bytes32[] memory labels, bytes32 node) internal {
658         // Take ownership of the node
659         ens.setSubnodeOwner(node, labels[idx], address(this));
660         node = keccak256(abi.encodePacked(node, labels[idx]));
661 
662         // Recurse if there are more labels
663         if (idx > 0) {
664             _eraseNodeHierarchy(idx - 1, labels, node);
665         }
666 
667         // Erase the resolver and owner records
668         ens.setResolver(node, address(0x0));
669         ens.setOwner(node, address(0x0));
670     }
671 
672     /**
673      * @dev Assign the owner in ENS, if we're still the registrar
674      *
675      * @param _hash hash to change owner
676      * @param _newOwner new owner to transfer to
677      */
678     function trySetSubnodeOwner(bytes32 _hash, address _newOwner) internal {
679         if (ens.owner(rootNode) == address(this))
680             ens.setSubnodeOwner(rootNode, _hash, _newOwner);
681     }
682 
683     /**
684      * @dev Returns the maximum of two unsigned integers
685      *
686      * @param a A number to compare
687      * @param b A number to compare
688      * @return The maximum of two unsigned integers
689      */
690     function max(uint a, uint b) internal pure returns (uint) {
691         if (a > b)
692             return a;
693         else
694             return b;
695     }
696 
697     /**
698      * @dev Returns the minimum of two unsigned integers
699      *
700      * @param a A number to compare
701      * @param b A number to compare
702      * @return The minimum of two unsigned integers
703      */
704     function min(uint a, uint b) internal pure returns (uint) {
705         if (a < b)
706             return a;
707         else
708             return b;
709     }
710 
711     /**
712      * @dev Returns the length of a given string
713      *
714      * @param s The string to measure the length of
715      * @return The length of the input string
716      */
717     function strlen(string memory s) internal pure returns (uint) {
718         s; // Don't warn about unused variables
719         // Starting here means the LSB will be the byte we care about
720         uint ptr;
721         uint end;
722         assembly {
723             ptr := add(s, 1)
724             end := add(mload(s), ptr)
725         }
726         uint len = 0;
727         for (len; ptr < end; len++) {
728             uint8 b;
729             assembly { b := and(mload(ptr), 0xFF) }
730             if (b < 0x80) {
731                 ptr += 1;
732             } else if (b < 0xE0) {
733                 ptr += 2;
734             } else if (b < 0xF0) {
735                 ptr += 3;
736             } else if (b < 0xF8) {
737                 ptr += 4;
738             } else if (b < 0xFC) {
739                 ptr += 5;
740             } else {
741                 ptr += 6;
742             }
743         }
744         return len;
745     }
746 
747 }
748 
749 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
750 
751 pragma solidity ^0.5.0;
752 
753 /**
754  * @title IERC165
755  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
756  */
757 interface IERC165 {
758     /**
759      * @notice Query if a contract implements an interface
760      * @param interfaceId The interface identifier, as specified in ERC-165
761      * @dev Interface identification is specified in ERC-165. This function
762      * uses less than 30,000 gas.
763      */
764     function supportsInterface(bytes4 interfaceId) external view returns (bool);
765 }
766 
767 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
768 
769 pragma solidity ^0.5.0;
770 
771 
772 /**
773  * @title ERC721 Non-Fungible Token Standard basic interface
774  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
775  */
776 contract IERC721 is IERC165 {
777     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
778     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
779     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
780 
781     function balanceOf(address owner) public view returns (uint256 balance);
782     function ownerOf(uint256 tokenId) public view returns (address owner);
783 
784     function approve(address to, uint256 tokenId) public;
785     function getApproved(uint256 tokenId) public view returns (address operator);
786 
787     function setApprovalForAll(address operator, bool _approved) public;
788     function isApprovedForAll(address owner, address operator) public view returns (bool);
789 
790     function transferFrom(address from, address to, uint256 tokenId) public;
791     function safeTransferFrom(address from, address to, uint256 tokenId) public;
792 
793     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
794 }
795 
796 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
797 
798 pragma solidity ^0.5.0;
799 
800 /**
801  * @title ERC721 token receiver interface
802  * @dev Interface for any contract that wants to support safeTransfers
803  * from ERC721 asset contracts.
804  */
805 contract IERC721Receiver {
806     /**
807      * @notice Handle the receipt of an NFT
808      * @dev The ERC721 smart contract calls this function on the recipient
809      * after a `safeTransfer`. This function MUST return the function selector,
810      * otherwise the caller will revert the transaction. The selector to be
811      * returned can be obtained as `this.onERC721Received.selector`. This
812      * function MAY throw to revert and reject the transfer.
813      * Note: the ERC721 contract address is always the message sender.
814      * @param operator The address which called `safeTransferFrom` function
815      * @param from The address which previously owned the token
816      * @param tokenId The NFT identifier which is being transferred
817      * @param data Additional data with no specified format
818      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
819      */
820     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
821     public returns (bytes4);
822 }
823 
824 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
825 
826 pragma solidity ^0.5.0;
827 
828 /**
829  * @title SafeMath
830  * @dev Unsigned math operations with safety checks that revert on error
831  */
832 library SafeMath {
833     /**
834     * @dev Multiplies two unsigned integers, reverts on overflow.
835     */
836     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
837         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
838         // benefit is lost if 'b' is also tested.
839         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
840         if (a == 0) {
841             return 0;
842         }
843 
844         uint256 c = a * b;
845         require(c / a == b);
846 
847         return c;
848     }
849 
850     /**
851     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
852     */
853     function div(uint256 a, uint256 b) internal pure returns (uint256) {
854         // Solidity only automatically asserts when dividing by 0
855         require(b > 0);
856         uint256 c = a / b;
857         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
858 
859         return c;
860     }
861 
862     /**
863     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
864     */
865     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
866         require(b <= a);
867         uint256 c = a - b;
868 
869         return c;
870     }
871 
872     /**
873     * @dev Adds two unsigned integers, reverts on overflow.
874     */
875     function add(uint256 a, uint256 b) internal pure returns (uint256) {
876         uint256 c = a + b;
877         require(c >= a);
878 
879         return c;
880     }
881 
882     /**
883     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
884     * reverts when dividing by zero.
885     */
886     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
887         require(b != 0);
888         return a % b;
889     }
890 }
891 
892 // File: openzeppelin-solidity/contracts/utils/Address.sol
893 
894 pragma solidity ^0.5.0;
895 
896 /**
897  * Utility library of inline functions on addresses
898  */
899 library Address {
900     /**
901      * Returns whether the target address is a contract
902      * @dev This function will return false if invoked during the constructor of a contract,
903      * as the code is not actually created until after the constructor finishes.
904      * @param account address of the account to check
905      * @return whether the target address is a contract
906      */
907     function isContract(address account) internal view returns (bool) {
908         uint256 size;
909         // XXX Currently there is no better way to check if there is a contract in an address
910         // than to check the size of the code at that address.
911         // See https://ethereum.stackexchange.com/a/14016/36603
912         // for more details about how this works.
913         // TODO Check this again before the Serenity release, because all addresses will be
914         // contracts then.
915         // solhint-disable-next-line no-inline-assembly
916         assembly { size := extcodesize(account) }
917         return size > 0;
918     }
919 }
920 
921 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
922 
923 pragma solidity ^0.5.0;
924 
925 
926 /**
927  * @title ERC165
928  * @author Matt Condon (@shrugs)
929  * @dev Implements ERC165 using a lookup table.
930  */
931 contract ERC165 is IERC165 {
932     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
933     /**
934      * 0x01ffc9a7 ===
935      *     bytes4(keccak256('supportsInterface(bytes4)'))
936      */
937 
938     /**
939      * @dev a mapping of interface id to whether or not it's supported
940      */
941     mapping(bytes4 => bool) private _supportedInterfaces;
942 
943     /**
944      * @dev A contract implementing SupportsInterfaceWithLookup
945      * implement ERC165 itself
946      */
947     constructor () internal {
948         _registerInterface(_INTERFACE_ID_ERC165);
949     }
950 
951     /**
952      * @dev implement supportsInterface(bytes4) using a lookup table
953      */
954     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
955         return _supportedInterfaces[interfaceId];
956     }
957 
958     /**
959      * @dev internal method for registering an interface
960      */
961     function _registerInterface(bytes4 interfaceId) internal {
962         require(interfaceId != 0xffffffff);
963         _supportedInterfaces[interfaceId] = true;
964     }
965 }
966 
967 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
968 
969 pragma solidity ^0.5.0;
970 
971 
972 
973 
974 
975 
976 /**
977  * @title ERC721 Non-Fungible Token Standard basic implementation
978  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
979  */
980 contract ERC721 is ERC165, IERC721 {
981     using SafeMath for uint256;
982     using Address for address;
983 
984     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
985     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
986     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
987 
988     // Mapping from token ID to owner
989     mapping (uint256 => address) private _tokenOwner;
990 
991     // Mapping from token ID to approved address
992     mapping (uint256 => address) private _tokenApprovals;
993 
994     // Mapping from owner to number of owned token
995     mapping (address => uint256) private _ownedTokensCount;
996 
997     // Mapping from owner to operator approvals
998     mapping (address => mapping (address => bool)) private _operatorApprovals;
999 
1000     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1001     /*
1002      * 0x80ac58cd ===
1003      *     bytes4(keccak256('balanceOf(address)')) ^
1004      *     bytes4(keccak256('ownerOf(uint256)')) ^
1005      *     bytes4(keccak256('approve(address,uint256)')) ^
1006      *     bytes4(keccak256('getApproved(uint256)')) ^
1007      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
1008      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
1009      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1010      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
1011      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1012      */
1013 
1014     constructor () public {
1015         // register the supported interfaces to conform to ERC721 via ERC165
1016         _registerInterface(_INTERFACE_ID_ERC721);
1017     }
1018 
1019     /**
1020      * @dev Gets the balance of the specified address
1021      * @param owner address to query the balance of
1022      * @return uint256 representing the amount owned by the passed address
1023      */
1024     function balanceOf(address owner) public view returns (uint256) {
1025         require(owner != address(0));
1026         return _ownedTokensCount[owner];
1027     }
1028 
1029     /**
1030      * @dev Gets the owner of the specified token ID
1031      * @param tokenId uint256 ID of the token to query the owner of
1032      * @return owner address currently marked as the owner of the given token ID
1033      */
1034     function ownerOf(uint256 tokenId) public view returns (address) {
1035         address owner = _tokenOwner[tokenId];
1036         require(owner != address(0));
1037         return owner;
1038     }
1039 
1040     /**
1041      * @dev Approves another address to transfer the given token ID
1042      * The zero address indicates there is no approved address.
1043      * There can only be one approved address per token at a given time.
1044      * Can only be called by the token owner or an approved operator.
1045      * @param to address to be approved for the given token ID
1046      * @param tokenId uint256 ID of the token to be approved
1047      */
1048     function approve(address to, uint256 tokenId) public {
1049         address owner = ownerOf(tokenId);
1050         require(to != owner);
1051         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1052 
1053         _tokenApprovals[tokenId] = to;
1054         emit Approval(owner, to, tokenId);
1055     }
1056 
1057     /**
1058      * @dev Gets the approved address for a token ID, or zero if no address set
1059      * Reverts if the token ID does not exist.
1060      * @param tokenId uint256 ID of the token to query the approval of
1061      * @return address currently approved for the given token ID
1062      */
1063     function getApproved(uint256 tokenId) public view returns (address) {
1064         require(_exists(tokenId));
1065         return _tokenApprovals[tokenId];
1066     }
1067 
1068     /**
1069      * @dev Sets or unsets the approval of a given operator
1070      * An operator is allowed to transfer all tokens of the sender on their behalf
1071      * @param to operator address to set the approval
1072      * @param approved representing the status of the approval to be set
1073      */
1074     function setApprovalForAll(address to, bool approved) public {
1075         require(to != msg.sender);
1076         _operatorApprovals[msg.sender][to] = approved;
1077         emit ApprovalForAll(msg.sender, to, approved);
1078     }
1079 
1080     /**
1081      * @dev Tells whether an operator is approved by a given owner
1082      * @param owner owner address which you want to query the approval of
1083      * @param operator operator address which you want to query the approval of
1084      * @return bool whether the given operator is approved by the given owner
1085      */
1086     function isApprovedForAll(address owner, address operator) public view returns (bool) {
1087         return _operatorApprovals[owner][operator];
1088     }
1089 
1090     /**
1091      * @dev Transfers the ownership of a given token ID to another address
1092      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1093      * Requires the msg sender to be the owner, approved, or operator
1094      * @param from current owner of the token
1095      * @param to address to receive the ownership of the given token ID
1096      * @param tokenId uint256 ID of the token to be transferred
1097     */
1098     function transferFrom(address from, address to, uint256 tokenId) public {
1099         require(_isApprovedOrOwner(msg.sender, tokenId));
1100 
1101         _transferFrom(from, to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev Safely transfers the ownership of a given token ID to another address
1106      * If the target address is a contract, it must implement `onERC721Received`,
1107      * which is called upon a safe transfer, and return the magic value
1108      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1109      * the transfer is reverted.
1110      *
1111      * Requires the msg sender to be the owner, approved, or operator
1112      * @param from current owner of the token
1113      * @param to address to receive the ownership of the given token ID
1114      * @param tokenId uint256 ID of the token to be transferred
1115     */
1116     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1117         safeTransferFrom(from, to, tokenId, "");
1118     }
1119 
1120     /**
1121      * @dev Safely transfers the ownership of a given token ID to another address
1122      * If the target address is a contract, it must implement `onERC721Received`,
1123      * which is called upon a safe transfer, and return the magic value
1124      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1125      * the transfer is reverted.
1126      * Requires the msg sender to be the owner, approved, or operator
1127      * @param from current owner of the token
1128      * @param to address to receive the ownership of the given token ID
1129      * @param tokenId uint256 ID of the token to be transferred
1130      * @param _data bytes data to send along with a safe transfer check
1131      */
1132     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
1133         transferFrom(from, to, tokenId);
1134         require(_checkOnERC721Received(from, to, tokenId, _data));
1135     }
1136 
1137     /**
1138      * @dev Returns whether the specified token exists
1139      * @param tokenId uint256 ID of the token to query the existence of
1140      * @return whether the token exists
1141      */
1142     function _exists(uint256 tokenId) internal view returns (bool) {
1143         address owner = _tokenOwner[tokenId];
1144         return owner != address(0);
1145     }
1146 
1147     /**
1148      * @dev Returns whether the given spender can transfer a given token ID
1149      * @param spender address of the spender to query
1150      * @param tokenId uint256 ID of the token to be transferred
1151      * @return bool whether the msg.sender is approved for the given token ID,
1152      *    is an operator of the owner, or is the owner of the token
1153      */
1154     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1155         address owner = ownerOf(tokenId);
1156         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1157     }
1158 
1159     /**
1160      * @dev Internal function to mint a new token
1161      * Reverts if the given token ID already exists
1162      * @param to The address that will own the minted token
1163      * @param tokenId uint256 ID of the token to be minted
1164      */
1165     function _mint(address to, uint256 tokenId) internal {
1166         require(to != address(0));
1167         require(!_exists(tokenId));
1168 
1169         _tokenOwner[tokenId] = to;
1170         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
1171 
1172         emit Transfer(address(0), to, tokenId);
1173     }
1174 
1175     /**
1176      * @dev Internal function to burn a specific token
1177      * Reverts if the token does not exist
1178      * Deprecated, use _burn(uint256) instead.
1179      * @param owner owner of the token to burn
1180      * @param tokenId uint256 ID of the token being burned
1181      */
1182     function _burn(address owner, uint256 tokenId) internal {
1183         require(ownerOf(tokenId) == owner);
1184 
1185         _clearApproval(tokenId);
1186 
1187         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
1188         _tokenOwner[tokenId] = address(0);
1189 
1190         emit Transfer(owner, address(0), tokenId);
1191     }
1192 
1193     /**
1194      * @dev Internal function to burn a specific token
1195      * Reverts if the token does not exist
1196      * @param tokenId uint256 ID of the token being burned
1197      */
1198     function _burn(uint256 tokenId) internal {
1199         _burn(ownerOf(tokenId), tokenId);
1200     }
1201 
1202     /**
1203      * @dev Internal function to transfer ownership of a given token ID to another address.
1204      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1205      * @param from current owner of the token
1206      * @param to address to receive the ownership of the given token ID
1207      * @param tokenId uint256 ID of the token to be transferred
1208     */
1209     function _transferFrom(address from, address to, uint256 tokenId) internal {
1210         require(ownerOf(tokenId) == from);
1211         require(to != address(0));
1212 
1213         _clearApproval(tokenId);
1214 
1215         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
1216         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
1217 
1218         _tokenOwner[tokenId] = to;
1219 
1220         emit Transfer(from, to, tokenId);
1221     }
1222 
1223     /**
1224      * @dev Internal function to invoke `onERC721Received` on a target address
1225      * The call is not executed if the target address is not a contract
1226      * @param from address representing the previous owner of the given token ID
1227      * @param to target address that will receive the tokens
1228      * @param tokenId uint256 ID of the token to be transferred
1229      * @param _data bytes optional data to send along with the call
1230      * @return whether the call correctly returned the expected magic value
1231      */
1232     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1233         internal returns (bool)
1234     {
1235         if (!to.isContract()) {
1236             return true;
1237         }
1238 
1239         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1240         return (retval == _ERC721_RECEIVED);
1241     }
1242 
1243     /**
1244      * @dev Private function to clear current approval of a given token ID
1245      * @param tokenId uint256 ID of the token to be transferred
1246      */
1247     function _clearApproval(uint256 tokenId) private {
1248         if (_tokenApprovals[tokenId] != address(0)) {
1249             _tokenApprovals[tokenId] = address(0);
1250         }
1251     }
1252 }
1253 
1254 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1255 
1256 pragma solidity ^0.5.0;
1257 
1258 /**
1259  * @title Ownable
1260  * @dev The Ownable contract has an owner address, and provides basic authorization control
1261  * functions, this simplifies the implementation of "user permissions".
1262  */
1263 contract Ownable {
1264     address private _owner;
1265 
1266     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1267 
1268     /**
1269      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1270      * account.
1271      */
1272     constructor () internal {
1273         _owner = msg.sender;
1274         emit OwnershipTransferred(address(0), _owner);
1275     }
1276 
1277     /**
1278      * @return the address of the owner.
1279      */
1280     function owner() public view returns (address) {
1281         return _owner;
1282     }
1283 
1284     /**
1285      * @dev Throws if called by any account other than the owner.
1286      */
1287     modifier onlyOwner() {
1288         require(isOwner());
1289         _;
1290     }
1291 
1292     /**
1293      * @return true if `msg.sender` is the owner of the contract.
1294      */
1295     function isOwner() public view returns (bool) {
1296         return msg.sender == _owner;
1297     }
1298 
1299     /**
1300      * @dev Allows the current owner to relinquish control of the contract.
1301      * @notice Renouncing to ownership will leave the contract without an owner.
1302      * It will not be possible to call the functions with the `onlyOwner`
1303      * modifier anymore.
1304      */
1305     function renounceOwnership() public onlyOwner {
1306         emit OwnershipTransferred(_owner, address(0));
1307         _owner = address(0);
1308     }
1309 
1310     /**
1311      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1312      * @param newOwner The address to transfer ownership to.
1313      */
1314     function transferOwnership(address newOwner) public onlyOwner {
1315         _transferOwnership(newOwner);
1316     }
1317 
1318     /**
1319      * @dev Transfers control of the contract to a newOwner.
1320      * @param newOwner The address to transfer ownership to.
1321      */
1322     function _transferOwnership(address newOwner) internal {
1323         require(newOwner != address(0));
1324         emit OwnershipTransferred(_owner, newOwner);
1325         _owner = newOwner;
1326     }
1327 }
1328 
1329 // File: contracts/BaseRegistrar.sol
1330 
1331 pragma solidity >=0.4.24;
1332 
1333 
1334 
1335 
1336 
1337 contract BaseRegistrar is ERC721, Ownable {
1338     uint constant public GRACE_PERIOD = 90 days;
1339 
1340     event ControllerAdded(address indexed controller);
1341     event ControllerRemoved(address indexed controller);
1342     event NameMigrated(uint256 indexed id, address indexed owner, uint expires);
1343     event NameRegistered(uint256 indexed id, address indexed owner, uint expires);
1344     event NameRenewed(uint256 indexed id, uint expires);
1345 
1346     // Expiration timestamp for migrated domains.
1347     uint public transferPeriodEnds;
1348 
1349     // The ENS registry
1350     ENS public ens;
1351 
1352     // The namehash of the TLD this registrar owns (eg, .eth)
1353     bytes32 public baseNode;
1354 
1355     // The interim registrar
1356     HashRegistrar public previousRegistrar;
1357 
1358     // A map of addresses that are authorised to register and renew names.
1359     mapping(address=>bool) public controllers;
1360 
1361     // Authorises a controller, who can register and renew domains.
1362     function addController(address controller) external;
1363 
1364     // Revoke controller permission for an address.
1365     function removeController(address controller) external;
1366 
1367     // Set the resolver for the TLD this registrar manages.
1368     function setResolver(address resolver) external;
1369 
1370     // Returns the expiration timestamp of the specified label hash.
1371     function nameExpires(uint256 id) external view returns(uint);
1372 
1373     // Returns true iff the specified name is available for registration.
1374     function available(uint256 id) public view returns(bool);
1375 
1376     /**
1377      * @dev Register a name.
1378      */
1379     function register(uint256 id, address owner, uint duration) external returns(uint);
1380 
1381     function renew(uint256 id, uint duration) external returns(uint);
1382 
1383     /**
1384      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
1385      */
1386     function reclaim(uint256 id, address owner) external;
1387 
1388     /**
1389      * @dev Transfers a registration from the initial registrar.
1390      * This function is called by the initial registrar when a user calls `transferRegistrars`.
1391      */
1392     function acceptRegistrarTransfer(bytes32 label, Deed deed, uint) external;
1393 }
1394 
1395 // File: contracts/StringUtils.sol
1396 
1397 pragma solidity >=0.4.24;
1398 
1399 library StringUtils {
1400     /**
1401      * @dev Returns the length of a given string
1402      *
1403      * @param s The string to measure the length of
1404      * @return The length of the input string
1405      */
1406     function strlen(string memory s) internal pure returns (uint) {
1407         uint len;
1408         uint i = 0;
1409         uint bytelength = bytes(s).length;
1410         for(len = 0; i < bytelength; len++) {
1411             byte b = bytes(s)[i];
1412             if(b < 0x80) {
1413                 i += 1;
1414             } else if (b < 0xE0) {
1415                 i += 2;
1416             } else if (b < 0xF0) {
1417                 i += 3;
1418             } else if (b < 0xF8) {
1419                 i += 4;
1420             } else if (b < 0xFC) {
1421                 i += 5;
1422             } else {
1423                 i += 6;
1424             }
1425         }
1426         return len;
1427     }
1428 }
1429 
1430 // File: contracts/ETHRegistrarController.sol
1431 
1432 pragma solidity ^0.5.0;
1433 
1434 
1435 
1436 
1437 
1438 /**
1439  * @dev A registrar controller for registering and renewing names at fixed cost.
1440  */
1441 contract ETHRegistrarController is Ownable {
1442     using StringUtils for *;
1443 
1444     uint constant public MIN_REGISTRATION_DURATION = 28 days;
1445 
1446     bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));
1447     bytes4 constant private COMMITMENT_CONTROLLER_ID = bytes4(
1448         keccak256("rentPrice(string,uint256)") ^
1449         keccak256("available(string)") ^
1450         keccak256("makeCommitment(string,address,bytes32)") ^
1451         keccak256("commit(bytes32)") ^
1452         keccak256("register(string,address,uint256,bytes32)") ^
1453         keccak256("renew(string,uint256)")
1454     );
1455 
1456     BaseRegistrar base;
1457     PriceOracle prices;
1458     uint public minCommitmentAge;
1459     uint public maxCommitmentAge;
1460 
1461     mapping(bytes32=>uint) public commitments;
1462 
1463     event NameRegistered(string name, bytes32 indexed label, address indexed owner, uint cost, uint expires);
1464     event NameRenewed(string name, bytes32 indexed label, uint cost, uint expires);
1465     event NewPriceOracle(address indexed oracle);
1466 
1467     constructor(BaseRegistrar _base, PriceOracle _prices, uint _minCommitmentAge, uint _maxCommitmentAge) public {
1468         require(_maxCommitmentAge > _minCommitmentAge);
1469 
1470         base = _base;
1471         prices = _prices;
1472         minCommitmentAge = _minCommitmentAge;
1473         maxCommitmentAge = _maxCommitmentAge;
1474     }
1475 
1476     function rentPrice(string memory name, uint duration) view public returns(uint) {
1477         bytes32 hash = keccak256(bytes(name));
1478         return prices.price(name, base.nameExpires(uint256(hash)), duration);
1479     }
1480 
1481     function valid(string memory name) public view returns(bool) {
1482         return name.strlen() > 6;
1483     }
1484 
1485     function available(string memory name) public view returns(bool) {
1486         bytes32 label = keccak256(bytes(name));
1487         return valid(name) && base.available(uint256(label));
1488     }
1489 
1490     function makeCommitment(string memory name, address owner, bytes32 secret) pure public returns(bytes32) {
1491         bytes32 label = keccak256(bytes(name));
1492         return keccak256(abi.encodePacked(label, owner, secret));
1493     }
1494 
1495     function commit(bytes32 commitment) public {
1496         require(commitments[commitment] + maxCommitmentAge < now);
1497         commitments[commitment] = now;
1498     }
1499 
1500     function register(string calldata name, address owner, uint duration, bytes32 secret) external payable {
1501         // Require a valid commitment
1502         bytes32 commitment = makeCommitment(name, owner, secret);
1503         require(commitments[commitment] + minCommitmentAge <= now);
1504 
1505         // If the commitment is too old, or the name is registered, stop
1506         require(commitments[commitment] + maxCommitmentAge > now);
1507         require(available(name));
1508 
1509         delete(commitments[commitment]);
1510 
1511         uint cost = rentPrice(name, duration);
1512         require(duration >= MIN_REGISTRATION_DURATION);
1513         require(msg.value >= cost);
1514 
1515         bytes32 label = keccak256(bytes(name));
1516         uint expires = base.register(uint256(label), owner, duration);
1517         emit NameRegistered(name, label, owner, cost, expires);
1518 
1519         if(msg.value > cost) {
1520             msg.sender.transfer(msg.value - cost);
1521         }
1522     }
1523 
1524     function renew(string calldata name, uint duration) external payable {
1525         uint cost = rentPrice(name, duration);
1526         require(msg.value >= cost);
1527 
1528         bytes32 label = keccak256(bytes(name));
1529         uint expires = base.renew(uint256(label), duration);
1530 
1531         if(msg.value > cost) {
1532             msg.sender.transfer(msg.value - cost);
1533         }
1534 
1535         emit NameRenewed(name, label, cost, expires);
1536     }
1537 
1538     function setPriceOracle(PriceOracle _prices) public onlyOwner {
1539         prices = _prices;
1540         emit NewPriceOracle(address(prices));
1541     }
1542 
1543     function setCommitmentAges(uint _minCommitmentAge, uint _maxCommitmentAge) public onlyOwner {
1544         minCommitmentAge = _minCommitmentAge;
1545         maxCommitmentAge = _maxCommitmentAge;
1546     }
1547 
1548     function withdraw() public onlyOwner {
1549         msg.sender.transfer(address(this).balance);
1550     }
1551 
1552     function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
1553         return interfaceID == INTERFACE_META_ID ||
1554                interfaceID == COMMITMENT_CONTROLLER_ID;
1555     }
1556 }