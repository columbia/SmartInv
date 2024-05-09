1 pragma solidity ^0.4.0;
2 
3 
4 /*
5 
6 Temporary Hash Registrar
7 ========================
8 
9 This is a simplified version of a hash registrar. It is purporsefully limited:
10 names cannot be six letters or shorter, new auctions will stop after 4 years.
11 
12 The plan is to test the basic features and then move to a new contract in at most
13 2 years, when some sort of renewal mechanism will be enabled.
14 */
15 
16 contract AbstractENS {
17     function owner(bytes32 node) constant returns(address);
18     function resolver(bytes32 node) constant returns(address);
19     function ttl(bytes32 node) constant returns(uint64);
20     function setOwner(bytes32 node, address owner);
21     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
22     function setResolver(bytes32 node, address resolver);
23     function setTTL(bytes32 node, uint64 ttl);
24 
25     // Logged when the owner of a node assigns a new owner to a subnode.
26     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
27 
28     // Logged when the owner of a node transfers ownership to a new account.
29     event Transfer(bytes32 indexed node, address owner);
30 
31     // Logged when the resolver for a node changes.
32     event NewResolver(bytes32 indexed node, address resolver);
33 
34     // Logged when the TTL of a node changes
35     event NewTTL(bytes32 indexed node, uint64 ttl);
36 }
37 
38 /**
39  * @title Deed to hold ether in exchange for ownership of a node
40  * @dev The deed can be controlled only by the registrar and can only send ether back to the owner.
41  */
42 contract Deed {
43     address public registrar;
44     address constant burn = 0xdead;
45     uint public creationDate;
46     address public owner;
47     address public previousOwner;
48     uint public value;
49     event OwnerChanged(address newOwner);
50     event DeedClosed();
51     bool active;
52 
53 
54     modifier onlyRegistrar {
55         if (msg.sender != registrar) throw;
56         _;
57     }
58 
59     modifier onlyActive {
60         if (!active) throw;
61         _;
62     }
63 
64     function Deed(address _owner) payable {
65         owner = _owner;
66         registrar = msg.sender;
67         creationDate = now;
68         active = true;
69         value = msg.value;
70     }
71 
72     function setOwner(address newOwner) onlyRegistrar {
73         if (newOwner == 0) throw;
74         previousOwner = owner;  // This allows contracts to check who sent them the ownership
75         owner = newOwner;
76         OwnerChanged(newOwner);
77     }
78 
79     function setRegistrar(address newRegistrar) onlyRegistrar {
80         registrar = newRegistrar;
81     }
82 
83     function setBalance(uint newValue, bool throwOnFailure) onlyRegistrar onlyActive {
84         // Check if it has enough balance to set the value
85         if (value < newValue) throw;
86         value = newValue;
87         // Send the difference to the owner
88         if (!owner.send(this.balance - newValue) && throwOnFailure) throw;
89     }
90 
91     /**
92      * @dev Close a deed and refund a specified fraction of the bid value
93      * @param refundRatio The amount*1/1000 to refund
94      */
95     function closeDeed(uint refundRatio) onlyRegistrar onlyActive {
96         active = false;
97         if (! burn.send(((1000 - refundRatio) * this.balance)/1000)) throw;
98         DeedClosed();
99         destroyDeed();
100     }
101 
102     /**
103      * @dev Close a deed and refund a specified fraction of the bid value
104      */
105     function destroyDeed() {
106         if (active) throw;
107         
108         // Instead of selfdestruct(owner), invoke owner fallback function to allow
109         // owner to log an event if desired; but owner should also be aware that
110         // its fallback function can also be invoked by setBalance
111         if(owner.send(this.balance)) {
112             selfdestruct(burn);
113         }
114     }
115 }
116 
117 /**
118  * @title Registrar
119  * @dev The registrar handles the auction process for each subnode of the node it owns.
120  */
121 contract Registrar {
122     AbstractENS public ens;
123     bytes32 public rootNode;
124 
125     mapping (bytes32 => entry) _entries;
126     mapping (address => mapping(bytes32 => Deed)) public sealedBids;
127     
128     enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }
129 
130     uint32 constant totalAuctionLength = 5 days;
131     uint32 constant revealPeriod = 48 hours;
132     uint32 public constant launchLength = 8 weeks;
133 
134     uint constant minPrice = 0.01 ether;
135     uint public registryStarted;
136 
137     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
138     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
139     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
140     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
141     event HashReleased(bytes32 indexed hash, uint value);
142     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
143 
144     struct entry {
145         Deed deed;
146         uint registrationDate;
147         uint value;
148         uint highestBid;
149     }
150 
151     // State transitions for names:
152     //   Open -> Auction (startAuction)
153     //   Auction -> Reveal
154     //   Reveal -> Owned
155     //   Reveal -> Open (if nobody bid)
156     //   Owned -> Open (releaseDeed or invalidateName)
157     function state(bytes32 _hash) constant returns (Mode) {
158         var entry = _entries[_hash];
159         
160         if(!isAllowed(_hash, now)) {
161             return Mode.NotYetAvailable;
162         } else if(now < entry.registrationDate) {
163             if (now < entry.registrationDate - revealPeriod) {
164                 return Mode.Auction;
165             } else {
166                 return Mode.Reveal;
167             }
168         } else {
169             if(entry.highestBid == 0) {
170                 return Mode.Open;
171             } else {
172                 return Mode.Owned;
173             }
174         }
175     }
176 
177     modifier inState(bytes32 _hash, Mode _state) {
178         if(state(_hash) != _state) throw;
179         _;
180     }
181 
182     modifier onlyOwner(bytes32 _hash) {
183         if (state(_hash) != Mode.Owned || msg.sender != _entries[_hash].deed.owner()) throw;
184         _;
185     }
186 
187     modifier registryOpen() {
188         if(now < registryStarted  || now > registryStarted + 4 years || ens.owner(rootNode) != address(this)) throw;
189         _;
190     }
191 
192     function entries(bytes32 _hash) constant returns (Mode, address, uint, uint, uint) {
193         entry h = _entries[_hash];
194         return (state(_hash), h.deed, h.registrationDate, h.value, h.highestBid);
195     }
196 
197     /**
198      * @dev Constructs a new Registrar, with the provided address as the owner of the root node.
199      * @param _ens The address of the ENS
200      * @param _rootNode The hash of the rootnode.
201      */
202     function Registrar(AbstractENS _ens, bytes32 _rootNode, uint _startDate) {
203         ens = _ens;
204         rootNode = _rootNode;
205         registryStarted = _startDate > 0 ? _startDate : now;
206     }
207 
208     /**
209      * @dev Returns the maximum of two unsigned integers
210      * @param a A number to compare
211      * @param b A number to compare
212      * @return The maximum of two unsigned integers
213      */
214     function max(uint a, uint b) internal constant returns (uint max) {
215         if (a > b)
216             return a;
217         else
218             return b;
219     }
220 
221     /**
222      * @dev Returns the minimum of two unsigned integers
223      * @param a A number to compare
224      * @param b A number to compare
225      * @return The minimum of two unsigned integers
226      */
227     function min(uint a, uint b) internal constant returns (uint min) {
228         if (a < b)
229             return a;
230         else
231             return b;
232     }
233 
234     /**
235      * @dev Returns the length of a given string
236      * @param s The string to measure the length of
237      * @return The length of the input string
238      */
239     function strlen(string s) internal constant returns (uint) {
240         // Starting here means the LSB will be the byte we care about
241         uint ptr;
242         uint end;
243         assembly {
244             ptr := add(s, 1)
245             end := add(mload(s), ptr)
246         }
247         for (uint len = 0; ptr < end; len++) {
248             uint8 b;
249             assembly { b := and(mload(ptr), 0xFF) }
250             if (b < 0x80) {
251                 ptr += 1;
252             } else if(b < 0xE0) {
253                 ptr += 2;
254             } else if(b < 0xF0) {
255                 ptr += 3;
256             } else if(b < 0xF8) {
257                 ptr += 4;
258             } else if(b < 0xFC) {
259                 ptr += 5;
260             } else {
261                 ptr += 6;
262             }
263         }
264         return len;
265     }
266     
267     /** 
268      * @dev Determines if a name is available for registration yet
269      * 
270      * Each name will be assigned a random date in which its auction 
271      * can be started, from 0 to 13 weeks
272      * 
273      * @param _hash The hash to start an auction on
274      * @param _timestamp The timestamp to query about
275      */
276      
277     function isAllowed(bytes32 _hash, uint _timestamp) constant returns (bool allowed){
278         return _timestamp > getAllowedTime(_hash);
279     }
280 
281     /** 
282      * @dev Returns available date for hash
283      * 
284      * @param _hash The hash to start an auction on
285      */
286     function getAllowedTime(bytes32 _hash) constant returns (uint timestamp) {
287         return registryStarted + (launchLength*(uint(_hash)>>128)>>128);
288         // right shift operator: a >> b == a / 2**b
289     }
290     /**
291      * @dev Assign the owner in ENS, if we're still the registrar
292      * @param _hash hash to change owner
293      * @param _newOwner new owner to transfer to
294      */
295     function trySetSubnodeOwner(bytes32 _hash, address _newOwner) internal {
296         if(ens.owner(rootNode) == address(this))
297             ens.setSubnodeOwner(rootNode, _hash, _newOwner);        
298     }
299 
300     /**
301      * @dev Start an auction for an available hash
302      *
303      * Anyone can start an auction by sending an array of hashes that they want to bid for.
304      * Arrays are sent so that someone can open up an auction for X dummy hashes when they
305      * are only really interested in bidding for one. This will increase the cost for an
306      * attacker to simply bid blindly on all new auctions. Dummy auctions that are
307      * open but not bid on are closed after a week.
308      *
309      * @param _hash The hash to start an auction on
310      */
311     function startAuction(bytes32 _hash) registryOpen() {
312         var mode = state(_hash);
313         if(mode == Mode.Auction) return;
314         if(mode != Mode.Open) throw;
315 
316         entry newAuction = _entries[_hash];
317         newAuction.registrationDate = now + totalAuctionLength;
318         newAuction.value = 0;
319         newAuction.highestBid = 0;
320         AuctionStarted(_hash, newAuction.registrationDate);
321     }
322 
323     /**
324      * @dev Start multiple auctions for better anonymity
325      * @param _hashes An array of hashes, at least one of which you presumably want to bid on
326      */
327     function startAuctions(bytes32[] _hashes)  {
328         for (uint i = 0; i < _hashes.length; i ++ ) {
329             startAuction(_hashes[i]);
330         }
331     }
332 
333     /**
334      * @dev Hash the values required for a secret bid
335      * @param hash The node corresponding to the desired namehash
336      * @param value The bid amount
337      * @param salt A random value to ensure secrecy of the bid
338      * @return The hash of the bid values
339      */
340     function shaBid(bytes32 hash, address owner, uint value, bytes32 salt) constant returns (bytes32 sealedBid) {
341         return sha3(hash, owner, value, salt);
342     }
343 
344     /**
345      * @dev Submit a new sealed bid on a desired hash in a blind auction
346      *
347      * Bids are sent by sending a message to the main contract with a hash and an amount. The hash
348      * contains information about the bid, including the bidded hash, the bid amount, and a random
349      * salt. Bids are not tied to any one auction until they are revealed. The value of the bid
350      * itself can be masqueraded by sending more than the value of your actual bid. This is
351      * followed by a 48h reveal period. Bids revealed after this period will be burned and the ether unrecoverable.
352      * Since this is an auction, it is expected that most public hashes, like known domains and common dictionary
353      * words, will have multiple bidders pushing the price up.
354      *
355      * @param sealedBid A sealedBid, created by the shaBid function
356      */
357     function newBid(bytes32 sealedBid) payable {
358         if (address(sealedBids[msg.sender][sealedBid]) > 0 ) throw;
359         if (msg.value < minPrice) throw;
360         // creates a new hash contract with the owner
361         Deed newBid = (new Deed).value(msg.value)(msg.sender);
362         sealedBids[msg.sender][sealedBid] = newBid;
363         NewBid(sealedBid, msg.sender, msg.value);
364     }
365 
366     /**
367      * @dev Start a set of auctions and bid on one of them
368      *
369      * This method functions identically to calling `startAuctions` followed by `newBid`,
370      * but all in one transaction.
371      * @param hashes A list of hashes to start auctions on.
372      * @param sealedBid A sealed bid for one of the auctions.
373      */
374     function startAuctionsAndBid(bytes32[] hashes, bytes32 sealedBid) payable {
375         startAuctions(hashes);
376         newBid(sealedBid);
377     }
378 
379     /**
380      * @dev Submit the properties of a bid to reveal them
381      * @param _hash The node in the sealedBid
382      * @param _value The bid amount in the sealedBid
383      * @param _salt The sale in the sealedBid
384      */
385     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) {
386         bytes32 seal = shaBid(_hash, msg.sender, _value, _salt);
387         Deed bid = sealedBids[msg.sender][seal];
388         if (address(bid) == 0 ) throw;
389         sealedBids[msg.sender][seal] = Deed(0);
390         entry h = _entries[_hash];
391         uint value = min(_value, bid.value());
392         bid.setBalance(value, true);
393 
394         var auctionState = state(_hash);
395         if(auctionState == Mode.Owned) {
396             // Too late! Bidder loses their bid. Get's 0.5% back.
397             bid.closeDeed(5);
398             BidRevealed(_hash, msg.sender, value, 1);
399         } else if(auctionState != Mode.Reveal) {
400             // Invalid phase
401             throw;
402         } else if (value < minPrice || bid.creationDate() > h.registrationDate - revealPeriod) {
403             // Bid too low or too late, refund 99.5%
404             bid.closeDeed(995);
405             BidRevealed(_hash, msg.sender, value, 0);
406         } else if (value > h.highestBid) {
407             // new winner
408             // cancel the other bid, refund 99.5%
409             if(address(h.deed) != 0) {
410                 Deed previousWinner = h.deed;
411                 previousWinner.closeDeed(995);
412             }
413 
414             // set new winner
415             // per the rules of a vickery auction, the value becomes the previous highestBid
416             h.value = h.highestBid;  // will be zero if there's only 1 bidder
417             h.highestBid = value;
418             h.deed = bid;
419             BidRevealed(_hash, msg.sender, value, 2);
420         } else if (value > h.value) {
421             // not winner, but affects second place
422             h.value = value;
423             bid.closeDeed(995);
424             BidRevealed(_hash, msg.sender, value, 3);
425         } else {
426             // bid doesn't affect auction
427             bid.closeDeed(995);
428             BidRevealed(_hash, msg.sender, value, 4);
429         }
430     }
431 
432     /**
433      * @dev Cancel a bid
434      * @param seal The value returned by the shaBid function
435      */
436     function cancelBid(address bidder, bytes32 seal) {
437         Deed bid = sealedBids[bidder][seal];
438         
439         // If a sole bidder does not `unsealBid` in time, they have a few more days
440         // where they can call `startAuction` (again) and then `unsealBid` during
441         // the revealPeriod to get back their bid value.
442         // For simplicity, they should call `startAuction` within
443         // 9 days (2 weeks - totalAuctionLength), otherwise their bid will be
444         // cancellable by anyone.
445         if (address(bid) == 0
446             || now < bid.creationDate() + totalAuctionLength + 2 weeks) throw;
447 
448         // Send the canceller 0.5% of the bid, and burn the rest.
449         bid.setOwner(msg.sender);
450         bid.closeDeed(5);
451         sealedBids[bidder][seal] = Deed(0);
452         BidRevealed(seal, bidder, 0, 5);
453     }
454 
455     /**
456      * @dev Finalize an auction after the registration date has passed
457      * @param _hash The hash of the name the auction is for
458      */
459     function finalizeAuction(bytes32 _hash) onlyOwner(_hash) {
460         entry h = _entries[_hash];
461         
462         // handles the case when there's only a single bidder (h.value is zero)
463         h.value =  max(h.value, minPrice);
464         h.deed.setBalance(h.value, true);
465 
466         trySetSubnodeOwner(_hash, h.deed.owner());
467         HashRegistered(_hash, h.deed.owner(), h.value, h.registrationDate);
468     }
469 
470     /**
471      * @dev The owner of a domain may transfer it to someone else at any time.
472      * @param _hash The node to transfer
473      * @param newOwner The address to transfer ownership to
474      */
475     function transfer(bytes32 _hash, address newOwner) onlyOwner(_hash) {
476         if (newOwner == 0) throw;
477 
478         entry h = _entries[_hash];
479         h.deed.setOwner(newOwner);
480         trySetSubnodeOwner(_hash, newOwner);
481     }
482 
483     /**
484      * @dev After some time, or if we're no longer the registrar, the owner can release
485      *      the name and get their ether back.
486      * @param _hash The node to release
487      */
488     function releaseDeed(bytes32 _hash) onlyOwner(_hash) {
489         entry h = _entries[_hash];
490         Deed deedContract = h.deed;
491         if(now < h.registrationDate + 1 years && ens.owner(rootNode) == address(this)) throw;
492 
493         h.value = 0;
494         h.highestBid = 0;
495         h.deed = Deed(0);
496 
497         _tryEraseSingleNode(_hash);
498         deedContract.closeDeed(1000);
499         HashReleased(_hash, h.value);        
500     }
501 
502     /**
503      * @dev Submit a name 6 characters long or less. If it has been registered,
504      * the submitter will earn 50% of the deed value. We are purposefully
505      * handicapping the simplified registrar as a way to force it into being restructured
506      * in a few years.
507      * @param unhashedName An invalid name to search for in the registry.
508      *
509      */
510     function invalidateName(string unhashedName) inState(sha3(unhashedName), Mode.Owned) {
511         if (strlen(unhashedName) > 6 ) throw;
512         bytes32 hash = sha3(unhashedName);
513 
514         entry h = _entries[hash];
515 
516         _tryEraseSingleNode(hash);
517 
518         if(address(h.deed) != 0) {
519             // Reward the discoverer with 50% of the deed
520             // The previous owner gets 50%
521             h.value = max(h.value, minPrice);
522             h.deed.setBalance(h.value/2, false);
523             h.deed.setOwner(msg.sender);
524             h.deed.closeDeed(1000);
525         }
526 
527         HashInvalidated(hash, unhashedName, h.value, h.registrationDate);
528 
529         h.value = 0;
530         h.highestBid = 0;
531         h.deed = Deed(0);
532     }
533 
534     /**
535      * @dev Allows anyone to delete the owner and resolver records for a (subdomain of) a
536      *      name that is not currently owned in the registrar. If passing, eg, 'foo.bar.eth',
537      *      the owner and resolver fields on 'foo.bar.eth' and 'bar.eth' will all be cleared.
538      * @param labels A series of label hashes identifying the name to zero out, rooted at the
539      *        registrar's root. Must contain at least one element. For instance, to zero 
540      *        'foo.bar.eth' on a registrar that owns '.eth', pass an array containing
541      *        [sha3('foo'), sha3('bar')].
542      */
543     function eraseNode(bytes32[] labels) {
544         if(labels.length == 0) throw;
545         if(state(labels[labels.length - 1]) == Mode.Owned) throw;
546 
547         _eraseNodeHierarchy(labels.length - 1, labels, rootNode);
548     }
549 
550     function _tryEraseSingleNode(bytes32 label) internal {
551         if(ens.owner(rootNode) == address(this)) {
552             ens.setSubnodeOwner(rootNode, label, address(this));
553             var node = sha3(rootNode, label);
554             ens.setResolver(node, 0);
555             ens.setOwner(node, 0);
556         }
557     }
558 
559     function _eraseNodeHierarchy(uint idx, bytes32[] labels, bytes32 node) internal {
560         // Take ownership of the node
561         ens.setSubnodeOwner(node, labels[idx], address(this));
562         node = sha3(node, labels[idx]);
563         
564         // Recurse if there's more labels
565         if(idx > 0)
566             _eraseNodeHierarchy(idx - 1, labels, node);
567 
568         // Erase the resolver and owner records
569         ens.setResolver(node, 0);
570         ens.setOwner(node, 0);
571     }
572 
573     /**
574      * @dev Transfers the deed to the current registrar, if different from this one.
575      * Used during the upgrade process to a permanent registrar.
576      * @param _hash The name hash to transfer.
577      */
578     function transferRegistrars(bytes32 _hash) onlyOwner(_hash) {
579         var registrar = ens.owner(rootNode);
580         if(registrar == address(this))
581             throw;
582 
583         // Migrate the deed
584         entry h = _entries[_hash];
585         h.deed.setRegistrar(registrar);
586 
587         // Call the new registrar to accept the transfer
588         Registrar(registrar).acceptRegistrarTransfer(_hash, h.deed, h.registrationDate);
589 
590         // Zero out the entry
591         h.deed = Deed(0);
592         h.registrationDate = 0;
593         h.value = 0;
594         h.highestBid = 0;
595     }
596 
597     /**
598      * @dev Accepts a transfer from a previous registrar; stubbed out here since there
599      *      is no previous registrar implementing this interface.
600      * @param hash The sha3 hash of the label to transfer.
601      * @param deed The Deed object for the name being transferred in.
602      * @param registrationDate The date at which the name was originally registered.
603      */
604     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) {}
605 
606 }