1 pragma solidity ^0.4.0;
2 
3 
4 /*
5 
6 Temporary Hash Registrar 
7 ========================
8 
9 This is a simplified version of a hash registrar. It is purporsefully limited:
10 names cannot be six letters or shorter, new auctions will stop after 4 years
11 and all ether still locked after 8 years will become unreachable.
12 
13 The plan is to test the basic features and then move to a new contract in at most
14 2 years, when some sort of renewal mechanism will be enabled.
15 */
16 
17 contract AbstractENS {
18     function owner(bytes32 node) constant returns(address);
19     function resolver(bytes32 node) constant returns(address);
20     function ttl(bytes32 node) constant returns(uint64);
21     function setOwner(bytes32 node, address owner);
22     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
23     function setResolver(bytes32 node, address resolver);
24     function setTTL(bytes32 node, uint64 ttl);
25 
26     event Transfer(bytes32 indexed node, address owner);
27     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
28     event NewResolver(bytes32 indexed node, address resolver);
29     event NewTTL(bytes32 indexed node, uint64 ttl);
30 }
31 
32 /**
33  * @title Deed to hold ether in exchange for ownership of a node
34  * @dev The deed can be controlled only by the registrar and can only send ether back to the owner.
35  */
36 contract Deed {
37     address public registrar;
38     address constant burn = 0xdead;
39     uint public creationDate;
40     address public owner;
41     address public previousOwner;
42     uint public value;
43     event OwnerChanged(address newOwner);
44     event DeedClosed();
45     bool active;
46 
47 
48     modifier onlyRegistrar {
49         if (msg.sender != registrar) throw;
50         _;
51     }
52 
53     modifier onlyActive {
54         if (!active) throw;
55         _;
56     }
57 
58     function Deed(uint _value) {
59         registrar = msg.sender;
60         creationDate = now;
61         active = true;
62         value = _value;
63     }
64         
65     function setOwner(address newOwner) onlyRegistrar {
66         // so contracts can check who sent them the ownership
67         previousOwner = owner;
68         owner = newOwner;
69         OwnerChanged(newOwner);
70     }
71 
72     function setRegistrar(address newRegistrar) onlyRegistrar {
73         registrar = newRegistrar;
74     }
75     
76     function setBalance(uint newValue) onlyRegistrar onlyActive payable {
77         // Check if it has enough balance to set the value
78         if (value < newValue) throw;
79         value = newValue;
80         // Send the difference to the owner
81         if (!owner.send(this.balance - newValue)) throw;
82     }
83 
84     /**
85      * @dev Close a deed and refund a specified fraction of the bid value
86      * @param refundRatio The amount*1/1000 to refund
87      */
88     function closeDeed(uint refundRatio) onlyRegistrar onlyActive {
89         active = false;            
90         if (! burn.send(((1000 - refundRatio) * this.balance)/1000)) throw;
91         DeedClosed();
92         destroyDeed();
93     }    
94 
95     /**
96      * @dev Close a deed and refund a specified fraction of the bid value
97      */
98     function destroyDeed() {
99         if (active) throw;
100         if(owner.send(this.balance))
101             selfdestruct(burn);
102     }
103 
104     // The default function just receives an amount
105     function () payable {}
106 }
107 
108 /**
109  * @title Registrar
110  * @dev The registrar handles the auction process for each subnode of the node it owns.
111  */
112 contract Registrar {
113     AbstractENS public ens;
114     bytes32 public rootNode;
115 
116     mapping (bytes32 => entry) _entries;
117     mapping (address => mapping(bytes32 => Deed)) public sealedBids;
118     
119     enum Mode { Open, Auction, Owned, Forbidden, Reveal }
120     uint32 constant auctionLength = 5 days;
121     uint32 constant revealPeriod = 48 hours;
122     uint32 constant initialAuctionPeriod = 4 weeks;
123     uint constant minPrice = 0.01 ether;
124     uint public registryStarted;
125 
126     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
127     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
128     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
129     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
130     event HashReleased(bytes32 indexed hash, uint value);
131     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
132 
133     struct entry {
134         Deed deed;
135         uint registrationDate;
136         uint value;
137         uint highestBid;
138     }
139 
140     // State transitions for names:
141     //   Open -> Auction (startAuction)
142     //   Auction -> Reveal
143     //   Reveal -> Owned
144     //   Reveal -> Open (if nobody bid)
145     //   Owned -> Forbidden (invalidateName)
146     //   Owned -> Open (releaseDeed)
147     function state(bytes32 _hash) constant returns (Mode) {
148         var entry = _entries[_hash];
149         if(now < entry.registrationDate) {
150             if(now < entry.registrationDate - revealPeriod) {
151                 return Mode.Auction;
152             } else {
153                 return Mode.Reveal;
154             }
155         } else {
156             if(entry.highestBid == 0) {
157                 return Mode.Open;
158             } else if(entry.deed == Deed(0)) {
159                 return Mode.Forbidden;
160             } else {
161                 return Mode.Owned;
162             }
163         }
164     }
165     
166     modifier inState(bytes32 _hash, Mode _state) {
167         if(state(_hash) != _state) throw;
168         _;
169     }
170 
171     modifier onlyOwner(bytes32 _hash) {
172         if (state(_hash) != Mode.Owned || msg.sender != _entries[_hash].deed.owner()) throw;
173         _;
174     }
175     
176     modifier registryOpen() {
177         if(now < registryStarted  || now > registryStarted + 4 years || ens.owner(rootNode) != address(this)) throw;
178         _;
179     }
180     
181     function entries(bytes32 _hash) constant returns (Mode, address, uint, uint, uint) {
182         entry h = _entries[_hash];
183         return (state(_hash), h.deed, h.registrationDate, h.value, h.highestBid);
184     }
185     
186     /**
187      * @dev Constructs a new Registrar, with the provided address as the owner of the root node.
188      * @param _ens The address of the ENS
189      * @param _rootNode The hash of the rootnode.
190      */
191     function Registrar(address _ens, bytes32 _rootNode, uint _startDate) {
192         ens = AbstractENS(_ens);
193         rootNode = _rootNode;
194         registryStarted = _startDate > 0 ? _startDate : now;
195     }
196 
197     /**
198      * @dev Returns the maximum of two unsigned integers
199      * @param a A number to compare
200      * @param b A number to compare
201      * @return The maximum of two unsigned integers
202      */
203     function max(uint a, uint b) internal constant returns (uint max) {
204         if (a > b)
205             return a;
206         else
207             return b;
208     }
209 
210     /**
211      * @dev Returns the minimum of two unsigned integers
212      * @param a A number to compare
213      * @param b A number to compare
214      * @return The minimum of two unsigned integers
215      */
216     function min(uint a, uint b) internal constant returns (uint min) {
217         if (a < b)
218             return a;
219         else
220             return b;
221     }
222 
223     /**
224      * @dev Returns the length of a given string
225      * @param s The string to measure the length of
226      * @return The length of the input string
227      */
228     function strlen(string s) internal constant returns (uint) {
229         // Starting here means the LSB will be the byte we care about
230         uint ptr;
231         uint end;
232         assembly {
233             ptr := add(s, 1)
234             end := add(mload(s), ptr)
235         }
236         for (uint len = 0; ptr < end; len++) {
237             uint8 b;
238             assembly { b := and(mload(ptr), 0xFF) }
239             if (b < 0x80) {
240                 ptr += 1;
241             } else if(b < 0xE0) {
242                 ptr += 2;
243             } else if(b < 0xF0) {
244                 ptr += 3;
245             } else if(b < 0xF8) {
246                 ptr += 4;
247             } else if(b < 0xFC) {
248                 ptr += 5;
249             } else {
250                 ptr += 6;
251             }
252         }
253         return len;
254     }
255 
256     /**
257      * @dev Start an auction for an available hash
258      * 
259      * Anyone can start an auction by sending an array of hashes that they want to bid for. 
260      * Arrays are sent so that someone can open up an auction for X dummy hashes when they 
261      * are only really interested in bidding for one. This will increase the cost for an 
262      * attacker to simply bid blindly on all new auctions. Dummy auctions that are 
263      * open but not bid on are closed after a week. 
264      *
265      * @param _hash The hash to start an auction on
266      */    
267     function startAuction(bytes32 _hash) inState(_hash, Mode.Open) registryOpen() {
268         entry newAuction = _entries[_hash];
269 
270         // for the first month of the registry, make longer auctions
271         newAuction.registrationDate = max(now + auctionLength, registryStarted + initialAuctionPeriod);
272         newAuction.value = 0;
273         newAuction.highestBid = 0;
274         AuctionStarted(_hash, newAuction.registrationDate);      
275     }
276 
277     /**
278      * @dev Start multiple auctions for better anonymity
279      * @param _hashes An array of hashes, at least one of which you presumably want to bid on
280      */
281     function startAuctions(bytes32[] _hashes)  {
282         for (uint i = 0; i < _hashes.length; i ++ ) {
283             startAuction(_hashes[i]);
284         }
285     }
286     
287     /**
288      * @dev Hash the values required for a secret bid
289      * @param hash The node corresponding to the desired namehash
290      * @param owner The address which will own the 
291      * @param value The bid amount
292      * @param salt A random value to ensure secrecy of the bid
293      * @return The hash of the bid values
294      */
295     function shaBid(bytes32 hash, address owner, uint value, bytes32 salt) constant returns (bytes32 sealedBid) {
296         return sha3(hash, owner, value, salt);
297     }
298     
299     /**
300      * @dev Submit a new sealed bid on a desired hash in a blind auction
301      * 
302      * Bids are sent by sending a message to the main contract with a hash and an amount. The hash 
303      * contains information about the bid, including the bidded hash, the bid amount, and a random 
304      * salt. Bids are not tied to any one auction until they are revealed. The value of the bid 
305      * itself can be masqueraded by sending more than the value of your actual bid. This is 
306      * followed by a 24h reveal period. Bids revealed after this period will be burned and the ether unrecoverable. 
307      * Since this is an auction, it is expected that most public hashes, like known domains and common dictionary 
308      * words, will have multiple bidders pushing the price up. 
309      *
310      * @param sealedBid A sealedBid, created by the shaBid function
311      */
312     function newBid(bytes32 sealedBid) payable {
313         if (address(sealedBids[msg.sender][sealedBid]) > 0 ) throw;
314         if (msg.value < minPrice) throw;
315         // creates a new hash contract with the owner
316         Deed newBid = new Deed(msg.value);
317         sealedBids[msg.sender][sealedBid] = newBid;
318         NewBid(sealedBid, msg.sender, msg.value);
319 
320         if (!newBid.send(msg.value)) throw;
321     } 
322 
323     /**
324      * @dev Submit the properties of a bid to reveal them
325      * @param _hash The node in the sealedBid
326      * @param _owner The address in the sealedBid
327      * @param _value The bid amount in the sealedBid
328      * @param _salt The sale in the sealedBid
329      */ 
330     function unsealBid(bytes32 _hash, address _owner, uint _value, bytes32 _salt) {
331         bytes32 seal = shaBid(_hash, _owner, _value, _salt);
332         Deed bid = sealedBids[msg.sender][seal];
333         if (address(bid) == 0 ) throw;
334         sealedBids[msg.sender][seal] = Deed(0);
335         bid.setOwner(_owner);
336         entry h = _entries[_hash];
337         uint actualValue = min(_value, bid.value());
338         bid.setBalance(actualValue);
339 
340         var auctionState = state(_hash);
341         if(auctionState == Mode.Owned) {
342             // Too late! Bidder loses their bid. Get's 0.5% back.
343             bid.closeDeed(5);
344             BidRevealed(_hash, _owner, actualValue, 1);
345         } else if(auctionState != Mode.Reveal) {
346             // Invalid phase
347             throw;
348         } else if (_value < minPrice || bid.creationDate() > h.registrationDate - revealPeriod) {
349             // Bid too low or too late, refund 99.5%
350             bid.closeDeed(995);
351             BidRevealed(_hash, _owner, actualValue, 0);
352         } else if (_value > h.highestBid) {
353             // new winner
354             // cancel the other bid, refund 99.5%
355             if(address(h.deed) != 0) {
356                 Deed previousWinner = h.deed;
357                 previousWinner.closeDeed(995);
358             }
359             
360             // set new winner
361             // per the rules of a vickery auction, the value becomes the previous highestBid
362             h.value = h.highestBid;
363             h.highestBid = actualValue;
364             h.deed = bid;
365             BidRevealed(_hash, _owner, actualValue, 2);
366         } else if (_value > h.value) {
367             // not winner, but affects second place
368             h.value = actualValue;
369             bid.closeDeed(995);
370             BidRevealed(_hash, _owner, actualValue, 3);
371         } else {
372             // bid doesn't affect auction
373             bid.closeDeed(995);
374             BidRevealed(_hash, _owner, actualValue, 4);
375         }
376     }
377     
378     /**
379      * @dev Cancel a bid
380      * @param seal The value returned by the shaBid function
381      */ 
382     function cancelBid(address bidder, bytes32 seal) {
383         Deed bid = sealedBids[bidder][seal];
384         // If the bid hasn't been revealed after any possible auction date, then close it
385         if (address(bid) == 0 
386             || now < bid.creationDate() + initialAuctionPeriod 
387             || bid.owner() > 0) throw;
388 
389         // Send the canceller 0.5% of the bid, and burn the rest.
390         bid.setOwner(msg.sender);
391         bid.closeDeed(5);
392         sealedBids[bidder][seal] = Deed(0);
393         BidRevealed(seal, bidder, 0, 5);
394     }
395 
396     /**
397      * @dev Finalize an auction after the registration date has passed
398      * @param _hash The hash of the name the auction is for
399      */ 
400     function finalizeAuction(bytes32 _hash) onlyOwner(_hash) {
401         entry h = _entries[_hash];
402 
403         h.value =  max(h.value, minPrice);
404 
405         // Assign the owner in ENS
406         ens.setSubnodeOwner(rootNode, _hash, h.deed.owner());
407 
408         Deed deedContract = h.deed;
409         deedContract.setBalance(h.value);
410         HashRegistered(_hash, deedContract.owner(), h.value, h.registrationDate);
411     }
412 
413     /**
414      * @dev The owner of a domain may transfer it to someone else at any time.
415      * @param _hash The node to transfer
416      * @param newOwner The address to transfer ownership to
417      */
418     function transfer(bytes32 _hash, address newOwner) onlyOwner(_hash) {
419         entry h = _entries[_hash];
420         h.deed.setOwner(newOwner);
421         ens.setSubnodeOwner(rootNode, _hash, newOwner);
422     }
423 
424     /**
425      * @dev After some time, the owner can release the property and get their ether back
426      * @param _hash The node to release
427      */
428     function releaseDeed(bytes32 _hash) onlyOwner(_hash) {
429         entry h = _entries[_hash];
430         Deed deedContract = h.deed;
431         if (now < h.registrationDate + 1 years 
432             || now > registryStarted + 8 years) throw;
433 
434         HashReleased(_hash, h.value);
435         
436         h.value = 0;
437         h.highestBid = 0;
438         h.deed = Deed(0);
439 
440         ens.setSubnodeOwner(rootNode, _hash, 0);
441         deedContract.closeDeed(1000);
442     }  
443 
444     /**
445      * @dev Submit a name 6 characters long or less. If it has been registered, 
446      * the submitter will earn 50% of the deed value. We are purposefully
447      * handicapping the simplified registrar as a way to force it into being restructured
448      * in a few years.
449      * @param unhashedName An invalid name to search for in the registry.
450      * 
451      */
452     function invalidateName(string unhashedName) inState(sha3(unhashedName), Mode.Owned) {
453         if (strlen(unhashedName) > 6 ) throw;
454         bytes32 hash = sha3(unhashedName);
455         
456         entry h = _entries[hash];
457         ens.setSubnodeOwner(rootNode, hash, 0);
458         if(address(h.deed) != 0) {
459             // Reward the discoverer with 50% of the deed
460             // The previous owner gets 50%
461             h.deed.setBalance(h.deed.value()/2);
462             h.deed.setOwner(msg.sender);
463             h.deed.closeDeed(1000);
464         }
465         HashInvalidated(hash, unhashedName, h.value, h.registrationDate);
466         h.deed = Deed(0);
467     }
468 
469     /**
470      * @dev Transfers the deed to the current registrar, if different from this one.
471      * Used during the upgrade process to a permanent registrar.
472      * @param _hash The name hash to transfer.
473      */
474     function transferRegistrars(bytes32 _hash) onlyOwner(_hash) {
475         var registrar = ens.owner(rootNode);
476         if(registrar == address(this))
477             throw;
478 
479         entry h = _entries[_hash];
480         h.deed.setRegistrar(registrar);
481     }
482 
483     /**
484      * @dev Returns a deed created by a previous instance of the registrar.
485      * @param deed The address of the deed.
486      */
487     function returnDeed(Deed deed) {
488         // Only return if we own the deed, and it was created before our start date.
489         if(deed.registrar() != address(this) || deed.creationDate() > registryStarted)
490             throw;
491         deed.closeDeed(1000);
492     }
493 }