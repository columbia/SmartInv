1 pragma solidity ^0.4.13;
2 
3 contract AbstractENS {
4     function owner(bytes32 node) constant returns(address);
5     function resolver(bytes32 node) constant returns(address);
6     function ttl(bytes32 node) constant returns(uint64);
7     function setOwner(bytes32 node, address owner);
8     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
9     function setResolver(bytes32 node, address resolver);
10     function setTTL(bytes32 node, uint64 ttl);
11 
12     // Logged when the owner of a node assigns a new owner to a subnode.
13     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
14 
15     // Logged when the owner of a node transfers ownership to a new account.
16     event Transfer(bytes32 indexed node, address owner);
17 
18     // Logged when the resolver for a node changes.
19     event NewResolver(bytes32 indexed node, address resolver);
20 
21     // Logged when the TTL of a node changes
22     event NewTTL(bytes32 indexed node, uint64 ttl);
23 }
24 
25 contract ENS is AbstractENS {
26     struct Record {
27         address owner;
28         address resolver;
29         uint64 ttl;
30     }
31 
32     mapping(bytes32=>Record) records;
33 
34     // Permits modifications only by the owner of the specified node.
35     modifier only_owner(bytes32 node) {
36         if(records[node].owner != msg.sender) throw;
37         _;
38     }
39 
40     /**
41      * Constructs a new ENS registrar.
42      */
43     function ENS() {
44         records[0].owner = msg.sender;
45     }
46 
47     /**
48      * Returns the address that owns the specified node.
49      */
50     function owner(bytes32 node) constant returns (address) {
51         return records[node].owner;
52     }
53 
54     /**
55      * Returns the address of the resolver for the specified node.
56      */
57     function resolver(bytes32 node) constant returns (address) {
58         return records[node].resolver;
59     }
60 
61     /**
62      * Returns the TTL of a node, and any records associated with it.
63      */
64     function ttl(bytes32 node) constant returns (uint64) {
65         return records[node].ttl;
66     }
67 
68     /**
69      * Transfers ownership of a node to a new address. May only be called by the current
70      * owner of the node.
71      * @param node The node to transfer ownership of.
72      * @param owner The address of the new owner.
73      */
74     function setOwner(bytes32 node, address owner) only_owner(node) {
75         Transfer(node, owner);
76         records[node].owner = owner;
77     }
78 
79     /**
80      * Transfers ownership of a subnode sha3(node, label) to a new address. May only be
81      * called by the owner of the parent node.
82      * @param node The parent node.
83      * @param label The hash of the label specifying the subnode.
84      * @param owner The address of the new owner.
85      */
86     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) only_owner(node) {
87         var subnode = sha3(node, label);
88         NewOwner(node, label, owner);
89         records[subnode].owner = owner;
90     }
91 
92     /**
93      * Sets the resolver address for the specified node.
94      * @param node The node to update.
95      * @param resolver The address of the resolver.
96      */
97     function setResolver(bytes32 node, address resolver) only_owner(node) {
98         NewResolver(node, resolver);
99         records[node].resolver = resolver;
100     }
101 
102     /**
103      * Sets the TTL for the specified node.
104      * @param node The node to update.
105      * @param ttl The TTL in seconds.
106      */
107     function setTTL(bytes32 node, uint64 ttl) only_owner(node) {
108         NewTTL(node, ttl);
109         records[node].ttl = ttl;
110     }
111 }
112 
113 contract Deed {
114     address public registrar;
115     address constant burn = 0xdead;
116     uint public creationDate;
117     address public owner;
118     address public previousOwner;
119     uint public value;
120     event OwnerChanged(address newOwner);
121     event DeedClosed();
122     bool active;
123 
124 
125     modifier onlyRegistrar {
126         if (msg.sender != registrar) throw;
127         _;
128     }
129 
130     modifier onlyActive {
131         if (!active) throw;
132         _;
133     }
134 
135     function Deed(address _owner) payable {
136         owner = _owner;
137         registrar = msg.sender;
138         creationDate = now;
139         active = true;
140         value = msg.value;
141     }
142 
143     function setOwner(address newOwner) onlyRegistrar {
144         if (newOwner == 0) throw;
145         previousOwner = owner;  // This allows contracts to check who sent them the ownership
146         owner = newOwner;
147         OwnerChanged(newOwner);
148     }
149 
150     function setRegistrar(address newRegistrar) onlyRegistrar {
151         registrar = newRegistrar;
152     }
153 
154     function setBalance(uint newValue, bool throwOnFailure) onlyRegistrar onlyActive {
155         // Check if it has enough balance to set the value
156         if (value < newValue) throw;
157         value = newValue;
158         // Send the difference to the owner
159         if (!owner.send(this.balance - newValue) && throwOnFailure) throw;
160     }
161 
162     /**
163      * @dev Close a deed and refund a specified fraction of the bid value
164      * @param refundRatio The amount*1/1000 to refund
165      */
166     function closeDeed(uint refundRatio) onlyRegistrar onlyActive {
167         active = false;
168         if (! burn.send(((1000 - refundRatio) * this.balance)/1000)) throw;
169         DeedClosed();
170         destroyDeed();
171     }
172 
173     /**
174      * @dev Close a deed and refund a specified fraction of the bid value
175      */
176     function destroyDeed() {
177         if (active) throw;
178         
179         // Instead of selfdestruct(owner), invoke owner fallback function to allow
180         // owner to log an event if desired; but owner should also be aware that
181         // its fallback function can also be invoked by setBalance
182         if(owner.send(this.balance)) {
183             selfdestruct(burn);
184         }
185     }
186 }
187 
188 contract Registrar {
189     AbstractENS public ens;
190     bytes32 public rootNode;
191 
192     mapping (bytes32 => entry) _entries;
193     mapping (address => mapping(bytes32 => Deed)) public sealedBids;
194     
195     enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }
196 
197     uint32 constant totalAuctionLength = 5 seconds;
198     uint32 constant revealPeriod = 3 seconds;
199     uint32 public constant launchLength = 0 seconds;
200 
201     uint constant minPrice = 0.01 ether;
202     uint public registryStarted;
203 
204     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
205     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
206     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
207     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
208     event HashReleased(bytes32 indexed hash, uint value);
209     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
210 
211     struct entry {
212         Deed deed;
213         uint registrationDate;
214         uint value;
215         uint highestBid;
216     }
217 
218     // State transitions for names:
219     //   Open -> Auction (startAuction)
220     //   Auction -> Reveal
221     //   Reveal -> Owned
222     //   Reveal -> Open (if nobody bid)
223     //   Owned -> Open (releaseDeed or invalidateName)
224     function state(bytes32 _hash) constant returns (Mode) {
225         var entry = _entries[_hash];
226         
227         if(!isAllowed(_hash, now)) {
228             return Mode.NotYetAvailable;
229         } else if(now < entry.registrationDate) {
230             if (now < entry.registrationDate - revealPeriod) {
231                 return Mode.Auction;
232             } else {
233                 return Mode.Reveal;
234             }
235         } else {
236             if(entry.highestBid == 0) {
237                 return Mode.Open;
238             } else {
239                 return Mode.Owned;
240             }
241         }
242     }
243 
244     modifier inState(bytes32 _hash, Mode _state) {
245         if(state(_hash) != _state) throw;
246         _;
247     }
248 
249     modifier onlyOwner(bytes32 _hash) {
250         if (state(_hash) != Mode.Owned || msg.sender != _entries[_hash].deed.owner()) throw;
251         _;
252     }
253 
254     modifier registryOpen() {
255         if(now < registryStarted  || now > registryStarted + 4 years || ens.owner(rootNode) != address(this)) throw;
256         _;
257     }
258 
259     function entries(bytes32 _hash) constant returns (Mode, address, uint, uint, uint) {
260         entry h = _entries[_hash];
261         return (state(_hash), h.deed, h.registrationDate, h.value, h.highestBid);
262     }
263 
264     /**
265      * @dev Constructs a new Registrar, with the provided address as the owner of the root node.
266      * @param _ens The address of the ENS
267      * @param _rootNode The hash of the rootnode.
268      */
269     function Registrar(AbstractENS _ens, bytes32 _rootNode, uint _startDate) {
270         ens = _ens;
271         rootNode = _rootNode;
272         registryStarted = _startDate > 0 ? _startDate : now;
273     }
274 
275     /**
276      * @dev Returns the maximum of two unsigned integers
277      * @param a A number to compare
278      * @param b A number to compare
279      * @return The maximum of two unsigned integers
280      */
281     function max(uint a, uint b) internal constant returns (uint max) {
282         if (a > b)
283             return a;
284         else
285             return b;
286     }
287 
288     /**
289      * @dev Returns the minimum of two unsigned integers
290      * @param a A number to compare
291      * @param b A number to compare
292      * @return The minimum of two unsigned integers
293      */
294     function min(uint a, uint b) internal constant returns (uint min) {
295         if (a < b)
296             return a;
297         else
298             return b;
299     }
300 
301     /**
302      * @dev Returns the length of a given string
303      * @param s The string to measure the length of
304      * @return The length of the input string
305      */
306     function strlen(string s) internal constant returns (uint) {
307         // Starting here means the LSB will be the byte we care about
308         uint ptr;
309         uint end;
310         assembly {
311             ptr := add(s, 1)
312             end := add(mload(s), ptr)
313         }
314         for (uint len = 0; ptr < end; len++) {
315             uint8 b;
316             assembly { b := and(mload(ptr), 0xFF) }
317             if (b < 0x80) {
318                 ptr += 1;
319             } else if(b < 0xE0) {
320                 ptr += 2;
321             } else if(b < 0xF0) {
322                 ptr += 3;
323             } else if(b < 0xF8) {
324                 ptr += 4;
325             } else if(b < 0xFC) {
326                 ptr += 5;
327             } else {
328                 ptr += 6;
329             }
330         }
331         return len;
332     }
333     
334     /** 
335      * @dev Determines if a name is available for registration yet
336      * 
337      * Each name will be assigned a random date in which its auction 
338      * can be started, from 0 to 13 weeks
339      * 
340      * @param _hash The hash to start an auction on
341      * @param _timestamp The timestamp to query about
342      */
343      
344     function isAllowed(bytes32 _hash, uint _timestamp) constant returns (bool allowed){
345         return _timestamp > getAllowedTime(_hash);
346     }
347 
348     /** 
349      * @dev Returns available date for hash
350      * 
351      * @param _hash The hash to start an auction on
352      */
353     function getAllowedTime(bytes32 _hash) constant returns (uint timestamp) {
354         return registryStarted + (launchLength*(uint(_hash)>>128)>>128);
355         // right shift operator: a >> b == a / 2**b
356     }
357     /**
358      * @dev Assign the owner in ENS, if we're still the registrar
359      * @param _hash hash to change owner
360      * @param _newOwner new owner to transfer to
361      */
362     function trySetSubnodeOwner(bytes32 _hash, address _newOwner) internal {
363         if(ens.owner(rootNode) == address(this))
364             ens.setSubnodeOwner(rootNode, _hash, _newOwner);        
365     }
366 
367     /**
368      * @dev Start an auction for an available hash
369      *
370      * Anyone can start an auction by sending an array of hashes that they want to bid for.
371      * Arrays are sent so that someone can open up an auction for X dummy hashes when they
372      * are only really interested in bidding for one. This will increase the cost for an
373      * attacker to simply bid blindly on all new auctions. Dummy auctions that are
374      * open but not bid on are closed after a week.
375      *
376      * @param _hash The hash to start an auction on
377      */
378     function startAuction(bytes32 _hash) registryOpen() {
379         var mode = state(_hash);
380         if(mode == Mode.Auction) return;
381         if(mode != Mode.Open) throw;
382 
383         entry newAuction = _entries[_hash];
384         newAuction.registrationDate = now + totalAuctionLength;
385         newAuction.value = 0;
386         newAuction.highestBid = 0;
387         AuctionStarted(_hash, newAuction.registrationDate);
388     }
389 
390     /**
391      * @dev Start multiple auctions for better anonymity
392      * @param _hashes An array of hashes, at least one of which you presumably want to bid on
393      */
394     function startAuctions(bytes32[] _hashes)  {
395         for (uint i = 0; i < _hashes.length; i ++ ) {
396             startAuction(_hashes[i]);
397         }
398     }
399 
400     /**
401      * @dev Hash the values required for a secret bid
402      * @param hash The node corresponding to the desired namehash
403      * @param value The bid amount
404      * @param salt A random value to ensure secrecy of the bid
405      * @return The hash of the bid values
406      */
407     function shaBid(bytes32 hash, address owner, uint value, bytes32 salt) constant returns (bytes32 sealedBid) {
408         return sha3(hash, owner, value, salt);
409     }
410 
411     /**
412      * @dev Submit a new sealed bid on a desired hash in a blind auction
413      *
414      * Bids are sent by sending a message to the main contract with a hash and an amount. The hash
415      * contains information about the bid, including the bidded hash, the bid amount, and a random
416      * salt. Bids are not tied to any one auction until they are revealed. The value of the bid
417      * itself can be masqueraded by sending more than the value of your actual bid. This is
418      * followed by a 48h reveal period. Bids revealed after this period will be burned and the ether unrecoverable.
419      * Since this is an auction, it is expected that most public hashes, like known domains and common dictionary
420      * words, will have multiple bidders pushing the price up.
421      *
422      * @param sealedBid A sealedBid, created by the shaBid function
423      */
424     function newBid(bytes32 sealedBid) payable {
425         if (address(sealedBids[msg.sender][sealedBid]) > 0 ) throw;
426         if (msg.value < minPrice) throw;
427         // creates a new hash contract with the owner
428         Deed newBid = (new Deed).value(msg.value)(msg.sender);
429         sealedBids[msg.sender][sealedBid] = newBid;
430         NewBid(sealedBid, msg.sender, msg.value);
431     }
432 
433     /**
434      * @dev Start a set of auctions and bid on one of them
435      *
436      * This method functions identically to calling `startAuctions` followed by `newBid`,
437      * but all in one transaction.
438      * @param hashes A list of hashes to start auctions on.
439      * @param sealedBid A sealed bid for one of the auctions.
440      */
441     function startAuctionsAndBid(bytes32[] hashes, bytes32 sealedBid) payable {
442         startAuctions(hashes);
443         newBid(sealedBid);
444     }
445 
446     /**
447      * @dev Submit the properties of a bid to reveal them
448      * @param _hash The node in the sealedBid
449      * @param _value The bid amount in the sealedBid
450      * @param _salt The sale in the sealedBid
451      */
452     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) {
453         bytes32 seal = shaBid(_hash, msg.sender, _value, _salt);
454         Deed bid = sealedBids[msg.sender][seal];
455         if (address(bid) == 0 ) throw;
456         sealedBids[msg.sender][seal] = Deed(0);
457         entry h = _entries[_hash];
458         uint value = min(_value, bid.value());
459         bid.setBalance(value, true);
460 
461         var auctionState = state(_hash);
462         if(auctionState == Mode.Owned) {
463             // Too late! Bidder loses their bid. Get's 0.5% back.
464             bid.closeDeed(5);
465             BidRevealed(_hash, msg.sender, value, 1);
466         } else if(auctionState != Mode.Reveal) {
467             // Invalid phase
468             throw;
469         } else if (value < minPrice || bid.creationDate() > h.registrationDate - revealPeriod) {
470             // Bid too low or too late, refund 99.5%
471             bid.closeDeed(995);
472             BidRevealed(_hash, msg.sender, value, 0);
473         } else if (value > h.highestBid) {
474             // new winner
475             // cancel the other bid, refund 99.5%
476             if(address(h.deed) != 0) {
477                 Deed previousWinner = h.deed;
478                 previousWinner.closeDeed(995);
479             }
480 
481             // set new winner
482             // per the rules of a vickery auction, the value becomes the previous highestBid
483             h.value = h.highestBid;  // will be zero if there's only 1 bidder
484             h.highestBid = value;
485             h.deed = bid;
486             BidRevealed(_hash, msg.sender, value, 2);
487         } else if (value > h.value) {
488             // not winner, but affects second place
489             h.value = value;
490             bid.closeDeed(995);
491             BidRevealed(_hash, msg.sender, value, 3);
492         } else {
493             // bid doesn't affect auction
494             bid.closeDeed(995);
495             BidRevealed(_hash, msg.sender, value, 4);
496         }
497     }
498 
499     /**
500      * @dev Cancel a bid
501      * @param seal The value returned by the shaBid function
502      */
503     function cancelBid(address bidder, bytes32 seal) {
504         Deed bid = sealedBids[bidder][seal];
505         
506         // If a sole bidder does not `unsealBid` in time, they have a few more days
507         // where they can call `startAuction` (again) and then `unsealBid` during
508         // the revealPeriod to get back their bid value.
509         // For simplicity, they should call `startAuction` within
510         // 9 days (2 weeks - totalAuctionLength), otherwise their bid will be
511         // cancellable by anyone.
512         if (address(bid) == 0
513             || now < bid.creationDate() + totalAuctionLength + 2 weeks) throw;
514 
515         // Send the canceller 0.5% of the bid, and burn the rest.
516         bid.setOwner(msg.sender);
517         bid.closeDeed(5);
518         sealedBids[bidder][seal] = Deed(0);
519         BidRevealed(seal, bidder, 0, 5);
520     }
521 
522     /**
523      * @dev Finalize an auction after the registration date has passed
524      * @param _hash The hash of the name the auction is for
525      */
526     function finalizeAuction(bytes32 _hash) onlyOwner(_hash) {
527         entry h = _entries[_hash];
528         
529         // handles the case when there's only a single bidder (h.value is zero)
530         h.value =  max(h.value, minPrice);
531         h.deed.setBalance(h.value, true);
532 
533         trySetSubnodeOwner(_hash, h.deed.owner());
534         HashRegistered(_hash, h.deed.owner(), h.value, h.registrationDate);
535     }
536 
537     /**
538      * @dev The owner of a domain may transfer it to someone else at any time.
539      * @param _hash The node to transfer
540      * @param newOwner The address to transfer ownership to
541      */
542     function transfer(bytes32 _hash, address newOwner) onlyOwner(_hash) {
543         if (newOwner == 0) throw;
544 
545         entry h = _entries[_hash];
546         h.deed.setOwner(newOwner);
547         trySetSubnodeOwner(_hash, newOwner);
548     }
549 
550     /**
551      * @dev After some time, or if we're no longer the registrar, the owner can release
552      *      the name and get their ether back.
553      * @param _hash The node to release
554      */
555     function releaseDeed(bytes32 _hash) onlyOwner(_hash) {
556         entry h = _entries[_hash];
557         Deed deedContract = h.deed;
558         if(now < h.registrationDate + 1 years && ens.owner(rootNode) == address(this)) throw;
559 
560         h.value = 0;
561         h.highestBid = 0;
562         h.deed = Deed(0);
563 
564         _tryEraseSingleNode(_hash);
565         deedContract.closeDeed(1000);
566         HashReleased(_hash, h.value);        
567     }
568 
569     /**
570      * @dev Submit a name 6 characters long or less. If it has been registered,
571      * the submitter will earn 50% of the deed value. We are purposefully
572      * handicapping the simplified registrar as a way to force it into being restructured
573      * in a few years.
574      * @param unhashedName An invalid name to search for in the registry.
575      *
576      */
577     function invalidateName(string unhashedName) inState(sha3(unhashedName), Mode.Owned) {
578         if (strlen(unhashedName) > 6 ) throw;
579         bytes32 hash = sha3(unhashedName);
580 
581         entry h = _entries[hash];
582 
583         _tryEraseSingleNode(hash);
584 
585         if(address(h.deed) != 0) {
586             // Reward the discoverer with 50% of the deed
587             // The previous owner gets 50%
588             h.value = max(h.value, minPrice);
589             h.deed.setBalance(h.value/2, false);
590             h.deed.setOwner(msg.sender);
591             h.deed.closeDeed(1000);
592         }
593 
594         HashInvalidated(hash, unhashedName, h.value, h.registrationDate);
595 
596         h.value = 0;
597         h.highestBid = 0;
598         h.deed = Deed(0);
599     }
600 
601     /**
602      * @dev Allows anyone to delete the owner and resolver records for a (subdomain of) a
603      *      name that is not currently owned in the registrar. If passing, eg, 'foo.bar.eth',
604      *      the owner and resolver fields on 'foo.bar.eth' and 'bar.eth' will all be cleared.
605      * @param labels A series of label hashes identifying the name to zero out, rooted at the
606      *        registrar's root. Must contain at least one element. For instance, to zero 
607      *        'foo.bar.eth' on a registrar that owns '.eth', pass an array containing
608      *        [sha3('foo'), sha3('bar')].
609      */
610     function eraseNode(bytes32[] labels) {
611         if(labels.length == 0) throw;
612         if(state(labels[labels.length - 1]) == Mode.Owned) throw;
613 
614         _eraseNodeHierarchy(labels.length - 1, labels, rootNode);
615     }
616 
617     function _tryEraseSingleNode(bytes32 label) internal {
618         if(ens.owner(rootNode) == address(this)) {
619             ens.setSubnodeOwner(rootNode, label, address(this));
620             var node = sha3(rootNode, label);
621             ens.setResolver(node, 0);
622             ens.setOwner(node, 0);
623         }
624     }
625 
626     function _eraseNodeHierarchy(uint idx, bytes32[] labels, bytes32 node) internal {
627         // Take ownership of the node
628         ens.setSubnodeOwner(node, labels[idx], address(this));
629         node = sha3(node, labels[idx]);
630         
631         // Recurse if there's more labels
632         if(idx > 0)
633             _eraseNodeHierarchy(idx - 1, labels, node);
634 
635         // Erase the resolver and owner records
636         ens.setResolver(node, 0);
637         ens.setOwner(node, 0);
638     }
639 
640     /**
641      * @dev Transfers the deed to the current registrar, if different from this one.
642      * Used during the upgrade process to a permanent registrar.
643      * @param _hash The name hash to transfer.
644      */
645     function transferRegistrars(bytes32 _hash) onlyOwner(_hash) {
646         var registrar = ens.owner(rootNode);
647         if(registrar == address(this))
648             throw;
649 
650         // Migrate the deed
651         entry h = _entries[_hash];
652         h.deed.setRegistrar(registrar);
653 
654         // Call the new registrar to accept the transfer
655         Registrar(registrar).acceptRegistrarTransfer(_hash, h.deed, h.registrationDate);
656 
657         // Zero out the entry
658         h.deed = Deed(0);
659         h.registrationDate = 0;
660         h.value = 0;
661         h.highestBid = 0;
662     }
663 
664     /**
665      * @dev Accepts a transfer from a previous registrar; stubbed out here since there
666      *      is no previous registrar implementing this interface.
667      * @param hash The sha3 hash of the label to transfer.
668      * @param deed The Deed object for the name being transferred in.
669      * @param registrationDate The date at which the name was originally registered.
670      */
671     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) {}
672 
673 }
674 
675 contract Ownable {
676   address public owner;
677 
678 
679   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
680 
681 
682   /**
683    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
684    * account.
685    */
686   function Ownable() public {
687     owner = msg.sender;
688   }
689 
690   /**
691    * @dev Throws if called by any account other than the owner.
692    */
693   modifier onlyOwner() {
694     require(msg.sender == owner);
695     _;
696   }
697 
698   /**
699    * @dev Allows the current owner to transfer control of the contract to a newOwner.
700    * @param newOwner The address to transfer ownership to.
701    */
702   function transferOwnership(address newOwner) public onlyOwner {
703     require(newOwner != address(0));
704     OwnershipTransferred(owner, newOwner);
705     owner = newOwner;
706   }
707 
708 }
709 
710 contract Whitelist is Ownable {
711   mapping(address => bool) public whitelist;
712   
713   event WhitelistedAddressAdded(address addr);
714   event WhitelistedAddressRemoved(address addr);
715 
716   /**
717    * @dev Throws if called by any account that's not whitelisted.
718    */
719   modifier onlyWhitelisted() {
720     require(whitelist[msg.sender]);
721     _;
722   }
723 
724   /**
725    * @dev add an address to the whitelist
726    * @param addr address
727    * @return true if the address was added to the whitelist, false if the address was already in the whitelist 
728    */
729   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
730     if (!whitelist[addr]) {
731       whitelist[addr] = true;
732       WhitelistedAddressAdded(addr);
733       success = true; 
734     }
735   }
736 
737   /**
738    * @dev add addresses to the whitelist
739    * @param addrs addresses
740    * @return true if at least one address was added to the whitelist, 
741    * false if all addresses were already in the whitelist  
742    */
743   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
744     for (uint256 i = 0; i < addrs.length; i++) {
745       if (addAddressToWhitelist(addrs[i])) {
746         success = true;
747       }
748     }
749   }
750 
751   /**
752    * @dev remove an address from the whitelist
753    * @param addr address
754    * @return true if the address was removed from the whitelist, 
755    * false if the address wasn't in the whitelist in the first place 
756    */
757   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
758     if (whitelist[addr]) {
759       whitelist[addr] = false;
760       WhitelistedAddressRemoved(addr);
761       success = true;
762     }
763   }
764 
765   /**
766    * @dev remove addresses from the whitelist
767    * @param addrs addresses
768    * @return true if at least one address was removed from the whitelist, 
769    * false if all addresses weren't in the whitelist in the first place
770    */
771   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
772     for (uint256 i = 0; i < addrs.length; i++) {
773       if (removeAddressFromWhitelist(addrs[i])) {
774         success = true;
775       }
776     }
777   }
778 
779 }
780 
781 contract BedOracleV1 is Whitelist {
782     struct Bid {
783         uint value;
784         uint reward;
785         bytes32 hash;
786         address owner;
787     }
788 
789     Registrar internal registrar_;
790     uint internal balance_;
791     mapping (bytes32 => Bid) internal bids_;
792 
793     event Added(address indexed owner, bytes32 indexed shaBid, bytes8 indexed gasPrices, bytes cypherBid);
794     event Finished(bytes32 indexed shaBid);
795     event Forfeited(bytes32 indexed shaBid);
796     event Withdrawn(address indexed to, uint value);
797 
798     function() external payable {}
799     
800     constructor(address _registrar) public {
801         registrar_ = Registrar(_registrar);
802     }
803 
804     // This function adds the bid to a map of bids for the oracle to bid on
805     function add(bytes32 _shaBid, uint reward, bytes _cypherBid, bytes8 _gasPrices)
806         external payable
807     {
808         // Validate that the bid doesn't exist
809         require(bids_[_shaBid].owner == 0);
810         require(msg.value > 0.01 ether + reward);
811 
812         // MAYBE take a cut
813         // // we take 1 percent of the bid above the minimum.
814         // uint cut = msg.value - 10 finney - reward / 100;
815 
816         // Create the bid
817         bids_[_shaBid] = Bid(
818             msg.value - reward,
819             reward,
820             bytes32(0),
821             msg.sender
822         );
823 
824         // Emit an Added Event. We store the cypherBid inside the events because
825         // it isn't neccisarry for any of the other steps while bidding
826         emit Added(msg.sender, _shaBid, _gasPrices, _cypherBid);
827     }
828 
829     // bid is responsable for calling the newBid function
830     // Note: bid is onlyWhitelisted to make sure that we don't preemptivly bid
831     // on a name.
832     function bid(bytes32 _shaBid) external onlyWhitelisted {
833         Bid storage b = bids_[_shaBid];
834 
835         registrar_.newBid.value(b.value)(_shaBid);
836     }
837 
838     // reveal is responsable for unsealing the bid. it also stores the hash
839     // for later use when finalizing or forfeiting the auction.
840     function reveal(bytes32 _hash, uint _value, bytes32 _salt) external {
841         bids_[keccak256(_hash, this, _value, _salt)].hash = _hash;
842 
843         registrar_.unsealBid(_hash, _value, _salt);
844     }
845 
846     // finalize claims the deed and transfers it back to the user.
847     function finalize(bytes32 _shaBid) external {
848         Bid storage b = bids_[_shaBid];
849         bytes32 node = keccak256(registrar_.rootNode(), b.hash);
850         
851         registrar_.finalizeAuction(b.hash);
852 
853         // set the resolver to zero in order to make sure no dead data is read.
854         ENS(registrar_.ens()).setResolver(node, address(0));
855 
856         registrar_.transfer(b.hash, b.owner);
857 
858         // make sure subsequent calls to 'forfeit' don't affect us.
859         b.value = 0;
860 
861         // add gas to balance
862         balance_ += b.reward;
863         b.reward = 0;
864 
865         emit Finished(_shaBid);
866     }
867 
868     function forfeit(bytes32 _shaBid) external onlyWhitelisted {
869         Bid storage b = bids_[_shaBid];
870 
871         // this is here to make sure that we don't steal the customers money
872         // after they call 'add'.
873         require(registrar_.state(b.hash) == Registrar.Mode.Owned);
874 
875         // give back the lost bid value.
876         b.owner.transfer(b.value);
877         b.value = 0;
878 
879         // add gas to balance
880         balance_ += b.reward;
881         b.reward = 0;
882 
883         emit Forfeited(_shaBid);
884     }
885 
886     function getBid(bytes32 _shaBid)
887         external view returns (uint, uint, bytes32, address)
888     {
889         Bid storage b = bids_[_shaBid];
890         return (b.value, b.reward, b.hash, b.owner);
891     }
892 
893     function setRegistrar(address _newRegistrar) external onlyOwner {
894         registrar_ = Registrar(_newRegistrar);
895     }
896 
897     // withdraws from the reward pot
898     function withdraw() external onlyWhitelisted {
899         msg.sender.transfer(balance_);
900         emit Withdrawn(msg.sender, balance_);
901         balance_ = 0;
902     }
903 }