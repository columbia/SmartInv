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
17 
18 contract AbstractENS {
19     function owner(bytes32 node) constant returns(address);
20     function resolver(bytes32 node) constant returns(address);
21     function ttl(bytes32 node) constant returns(uint64);
22     function setOwner(bytes32 node, address owner);
23     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
24     function setResolver(bytes32 node, address resolver);
25     function setTTL(bytes32 node, uint64 ttl);
26 
27     event Transfer(bytes32 indexed node, address owner);
28     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
29     event NewResolver(bytes32 indexed node, address resolver);
30     event NewTTL(bytes32 indexed node, uint64 ttl);
31 }
32 
33 /**
34  * @title Deed to hold ether in exchange for ownership of a node
35  * @dev The deed can be controlled only by the registrar and can only send ether back to the owner.
36  */
37 contract Deed {
38     address public registrar;
39     address constant burn = 0xdead;
40     uint public creationDate;
41     address public owner;
42     address public previousOwner;
43     uint public value;
44     event OwnerChanged(address newOwner);
45     event DeedClosed();
46     bool active;
47 
48 
49     modifier onlyRegistrar {
50         if (msg.sender != registrar) throw;
51         _;
52     }
53 
54     modifier onlyActive {
55         if (!active) throw;
56         _;
57     }
58 
59     function Deed(uint _value) {
60         registrar = msg.sender;
61         creationDate = now;
62         active = true;
63         value = _value;
64     }
65         
66     function setOwner(address newOwner) onlyRegistrar {
67         // so contracts can check who sent them the ownership
68         previousOwner = owner;
69         owner = newOwner;
70         OwnerChanged(newOwner);
71     }
72 
73     function setRegistrar(address newRegistrar) onlyRegistrar {
74         registrar = newRegistrar;
75     }
76     
77     function setBalance(uint newValue) onlyRegistrar onlyActive payable {
78         // Check if it has enough balance to set the value
79         if (value < newValue) throw;
80         value = newValue;
81         // Send the difference to the owner
82         if (!owner.send(this.balance - newValue)) throw;
83     }
84 
85     /**
86      * @dev Close a deed and refund a specified fraction of the bid value
87      * @param refundRatio The amount*1/1000 to refund
88      */
89     function closeDeed(uint refundRatio) onlyRegistrar onlyActive {
90         active = false;            
91         if (! burn.send(((1000 - refundRatio) * this.balance)/1000)) throw;
92         DeedClosed();
93         destroyDeed();
94     }    
95 
96     /**
97      * @dev Close a deed and refund a specified fraction of the bid value
98      */
99     function destroyDeed() {
100         if (active) throw;
101         if(owner.send(this.balance))
102             selfdestruct(burn);
103     }
104 
105     // The default function just receives an amount
106     function () payable {}
107 }
108 
109 /**
110  * @title Registrar
111  * @dev The registrar handles the auction process for each subnode of the node it owns.
112  */
113 contract Registrar {
114     AbstractENS public ens;
115     bytes32 public rootNode;
116 
117     mapping (bytes32 => entry) _entries;
118     mapping (address => mapping(bytes32 => Deed)) public sealedBids;
119     
120     enum Mode { Open, Auction, Owned, Forbidden, Reveal }
121     uint32 constant auctionLength = 5 days;
122     uint32 constant revealPeriod = 48 hours;
123     uint32 constant initialAuctionPeriod = 4 weeks;
124     uint constant minPrice = 0.01 ether;
125     uint public registryStarted;
126 
127     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
128     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
129     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
130     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
131     event HashReleased(bytes32 indexed hash, uint value);
132     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
133 
134     struct entry {
135         Deed deed;
136         uint registrationDate;
137         uint value;
138         uint highestBid;
139     }
140 
141     // State transitions for names:
142     //   Open -> Auction (startAuction)
143     //   Auction -> Reveal
144     //   Reveal -> Owned
145     //   Reveal -> Open (if nobody bid)
146     //   Owned -> Forbidden (invalidateName)
147     //   Owned -> Open (releaseDeed)
148     function state(bytes32 _hash) constant returns (Mode) {
149         var entry = _entries[_hash];
150         if(now < entry.registrationDate) {
151             if(now < entry.registrationDate - revealPeriod) {
152                 return Mode.Auction;
153             } else {
154                 return Mode.Reveal;
155             }
156         } else {
157             if(entry.highestBid == 0) {
158                 return Mode.Open;
159             } else if(entry.deed == Deed(0)) {
160                 return Mode.Forbidden;
161             } else {
162                 return Mode.Owned;
163             }
164         }
165     }
166     
167     modifier inState(bytes32 _hash, Mode _state) {
168         if(state(_hash) != _state) throw;
169         _;
170     }
171 
172     modifier onlyOwner(bytes32 _hash) {
173         if (state(_hash) != Mode.Owned || msg.sender != _entries[_hash].deed.owner()) throw;
174         _;
175     }
176     
177     modifier registryOpen() {
178         if(now < registryStarted  || now > registryStarted + 4 years) throw;
179         _;
180     }
181     
182     function entries(bytes32 _hash) constant returns (Mode, address, uint, uint, uint) {
183         entry h = _entries[_hash];
184         return (state(_hash), h.deed, h.registrationDate, h.value, h.highestBid);
185     }
186     
187     /**
188      * @dev Constructs a new Registrar, with the provided address as the owner of the root node.
189      * @param _ens The address of the ENS
190      * @param _rootNode The hash of the rootnode.
191      */
192     function Registrar(address _ens, bytes32 _rootNode, uint _startDate) {
193         ens = AbstractENS(_ens);
194         rootNode = _rootNode;
195         registryStarted = _startDate > 0 ? _startDate : now;
196     }
197 
198     /**
199      * @dev Returns the maximum of two unsigned integers
200      * @param a A number to compare
201      * @param b A number to compare
202      * @return The maximum of two unsigned integers
203      */
204     function max(uint a, uint b) internal constant returns (uint max) {
205         if (a > b)
206             return a;
207         else
208             return b;
209     }
210 
211     /**
212      * @dev Returns the minimum of two unsigned integers
213      * @param a A number to compare
214      * @param b A number to compare
215      * @return The minimum of two unsigned integers
216      */
217     function min(uint a, uint b) internal constant returns (uint min) {
218         if (a < b)
219             return a;
220         else
221             return b;
222     }
223 
224     /**
225      * @dev Returns the length of a given string
226      * @param s The string to measure the length of
227      * @return The length of the input string
228      */
229     function strlen(string s) internal constant returns (uint) {
230         // Starting here means the LSB will be the byte we care about
231         uint ptr;
232         uint end;
233         assembly {
234             ptr := add(s, 1)
235             end := add(mload(s), ptr)
236         }
237         for (uint len = 0; ptr < end; len++) {
238             uint8 b;
239             assembly { b := and(mload(ptr), 0xFF) }
240             if (b < 0x80) {
241                 ptr += 1;
242             } else if(b < 0xE0) {
243                 ptr += 2;
244             } else if(b < 0xF0) {
245                 ptr += 3;
246             } else if(b < 0xF8) {
247                 ptr += 4;
248             } else if(b < 0xFC) {
249                 ptr += 5;
250             } else {
251                 ptr += 6;
252             }
253         }
254         return len;
255     }
256 
257     /**
258      * @dev Start an auction for an available hash
259      * 
260      * Anyone can start an auction by sending an array of hashes that they want to bid for. 
261      * Arrays are sent so that someone can open up an auction for X dummy hashes when they 
262      * are only really interested in bidding for one. This will increase the cost for an 
263      * attacker to simply bid blindly on all new auctions. Dummy auctions that are 
264      * open but not bid on are closed after a week. 
265      *
266      * @param _hash The hash to start an auction on
267      */    
268     function startAuction(bytes32 _hash) inState(_hash, Mode.Open) registryOpen() {
269         entry newAuction = _entries[_hash];
270 
271         // for the first month of the registry, make longer auctions
272         newAuction.registrationDate = max(now + auctionLength, registryStarted + initialAuctionPeriod);
273         newAuction.value = 0;
274         newAuction.highestBid = 0;
275         AuctionStarted(_hash, newAuction.registrationDate);      
276     }
277 
278     /**
279      * @dev Start multiple auctions for better anonymity
280      * @param _hashes An array of hashes, at least one of which you presumably want to bid on
281      */
282     function startAuctions(bytes32[] _hashes)  {
283         for (uint i = 0; i < _hashes.length; i ++ ) {
284             startAuction(_hashes[i]);
285         }
286     }
287     
288     /**
289      * @dev Hash the values required for a secret bid
290      * @param hash The node corresponding to the desired namehash
291      * @param owner The address which will own the 
292      * @param value The bid amount
293      * @param salt A random value to ensure secrecy of the bid
294      * @return The hash of the bid values
295      */
296     function shaBid(bytes32 hash, address owner, uint value, bytes32 salt) constant returns (bytes32 sealedBid) {
297         return sha3(hash, owner, value, salt);
298     }
299     
300     /**
301      * @dev Submit a new sealed bid on a desired hash in a blind auction
302      * 
303      * Bids are sent by sending a message to the main contract with a hash and an amount. The hash 
304      * contains information about the bid, including the bidded hash, the bid amount, and a random 
305      * salt. Bids are not tied to any one auction until they are revealed. The value of the bid 
306      * itself can be masqueraded by sending more than the value of your actual bid. This is 
307      * followed by a 24h reveal period. Bids revealed after this period will be burned and the ether unrecoverable. 
308      * Since this is an auction, it is expected that most public hashes, like known domains and common dictionary 
309      * words, will have multiple bidders pushing the price up. 
310      *
311      * @param sealedBid A sealedBid, created by the shaBid function
312      */
313     function newBid(bytes32 sealedBid) payable {
314         if (address(sealedBids[msg.sender][sealedBid]) > 0 ) throw;
315         if (msg.value < minPrice) throw;
316         // creates a new hash contract with the owner
317         Deed newBid = new Deed(msg.value);
318         sealedBids[msg.sender][sealedBid] = newBid;
319         NewBid(sealedBid, msg.sender, msg.value);
320 
321         if (!newBid.send(msg.value)) throw;
322     } 
323 
324     /**
325      * @dev Submit the properties of a bid to reveal them
326      * @param _hash The node in the sealedBid
327      * @param _owner The address in the sealedBid
328      * @param _value The bid amount in the sealedBid
329      * @param _salt The sale in the sealedBid
330      */ 
331     function unsealBid(bytes32 _hash, address _owner, uint _value, bytes32 _salt) {
332         bytes32 seal = shaBid(_hash, _owner, _value, _salt);
333         Deed bid = sealedBids[msg.sender][seal];
334         if (address(bid) == 0 ) throw;
335         sealedBids[msg.sender][seal] = Deed(0);
336         bid.setOwner(_owner);
337         entry h = _entries[_hash];
338         uint actualValue = min(_value, bid.value());
339         bid.setBalance(actualValue);
340 
341         var auctionState = state(_hash);
342         if(auctionState == Mode.Owned) {
343             // Too late! Bidder loses their bid. Get's 0.5% back.
344             bid.closeDeed(5);
345             BidRevealed(_hash, _owner, actualValue, 1);
346         } else if(auctionState != Mode.Reveal) {
347             // Invalid phase
348             throw;
349         } else if (_value < minPrice) {
350             // Bid too low, refund 99.5%
351             bid.closeDeed(995);
352             BidRevealed(_hash, _owner, actualValue, 0);
353         } else if (_value > h.highestBid) {
354             // new winner
355             // cancel the other bid, refund 99.5%
356             if(address(h.deed) != 0) {
357                 Deed previousWinner = h.deed;
358                 previousWinner.closeDeed(995);
359             }
360             
361             // set new winner
362             // per the rules of a vickery auction, the value becomes the previous highestBid
363             h.value = h.highestBid;
364             h.highestBid = actualValue;
365             h.deed = bid;
366             BidRevealed(_hash, _owner, actualValue, 2);
367         } else if (_value > h.value) {
368             // not winner, but affects second place
369             h.value = actualValue;
370             bid.closeDeed(995);
371             BidRevealed(_hash, _owner, actualValue, 3);
372         } else {
373             // bid doesn't affect auction
374             bid.closeDeed(995);
375             BidRevealed(_hash, _owner, actualValue, 4);
376         }
377     }
378     
379     /**
380      * @dev Cancel a bid
381      * @param seal The value returned by the shaBid function
382      */ 
383     function cancelBid(address bidder, bytes32 seal) {
384         Deed bid = sealedBids[bidder][seal];
385         // If the bid hasn't been revealed after any possible auction date, then close it
386         if (address(bid) == 0 
387             || now < bid.creationDate() + initialAuctionPeriod 
388             || bid.owner() > 0) throw;
389 
390         // Send the canceller 0.5% of the bid, and burn the rest.
391         bid.setOwner(msg.sender);
392         bid.closeDeed(5);
393         sealedBids[bidder][seal] = Deed(0);
394         BidRevealed(seal, bidder, 0, 5);
395     }
396 
397     /**
398      * @dev Finalize an auction after the registration date has passed
399      * @param _hash The hash of the name the auction is for
400      */ 
401     function finalizeAuction(bytes32 _hash) onlyOwner(_hash) {
402         entry h = _entries[_hash];
403 
404         h.value =  max(h.value, minPrice);
405 
406         // Assign the owner in ENS
407         ens.setSubnodeOwner(rootNode, _hash, h.deed.owner());
408 
409         Deed deedContract = h.deed;
410         deedContract.setBalance(h.value);
411         HashRegistered(_hash, deedContract.owner(), h.value, h.registrationDate);
412     }
413 
414     /**
415      * @dev The owner of a domain may transfer it to someone else at any time.
416      * @param _hash The node to transfer
417      * @param newOwner The address to transfer ownership to
418      */
419     function transfer(bytes32 _hash, address newOwner) onlyOwner(_hash) {
420         entry h = _entries[_hash];
421         h.deed.setOwner(newOwner);
422         ens.setSubnodeOwner(rootNode, _hash, newOwner);
423     }
424 
425     /**
426      * @dev After some time, the owner can release the property and get their ether back
427      * @param _hash The node to release
428      */
429     function releaseDeed(bytes32 _hash) onlyOwner(_hash) {
430         entry h = _entries[_hash];
431         Deed deedContract = h.deed;
432         if (now < h.registrationDate + 1 years 
433             || now > registryStarted + 8 years) throw;
434 
435         HashReleased(_hash, h.value);
436         
437         h.value = 0;
438         h.highestBid = 0;
439         h.deed = Deed(0);
440 
441         ens.setSubnodeOwner(rootNode, _hash, 0);
442         deedContract.closeDeed(1000);
443     }  
444 
445     /**
446      * @dev Submit a name 6 characters long or less. If it has been registered, 
447      * the submitter will earn 50% of the deed value. We are purposefully
448      * handicapping the simplified registrar as a way to force it into being restructured
449      * in a few years.
450      * @param unhashedName An invalid name to search for in the registry.
451      * 
452      */
453     function invalidateName(string unhashedName) inState(sha3(unhashedName), Mode.Owned) {
454         if (strlen(unhashedName) > 6 ) throw;
455         bytes32 hash = sha3(unhashedName);
456         
457         entry h = _entries[hash];
458         ens.setSubnodeOwner(rootNode, hash, 0);
459         if(address(h.deed) != 0) {
460             // Reward the discoverer with 50% of the deed
461             // The previous owner gets nothing
462             h.deed.setBalance(h.deed.value()/2);
463             h.deed.setOwner(msg.sender);
464             h.deed.closeDeed(1000);
465         }
466         HashInvalidated(hash, unhashedName, h.value, h.registrationDate);
467         h.deed = Deed(0);
468     }
469 
470     /**
471      * @dev Transfers the deed to the current registrar, if different from this one.
472      * Used during the upgrade process to a permanent registrar.
473      * @param _hash The name hash to transfer.
474      */
475     function transferRegistrars(bytes32 _hash) onlyOwner(_hash) {
476         var registrar = ens.owner(rootNode);
477         if(registrar == address(this))
478             throw;
479 
480         entry h = _entries[_hash];
481         h.deed.setRegistrar(registrar);
482     }
483 }