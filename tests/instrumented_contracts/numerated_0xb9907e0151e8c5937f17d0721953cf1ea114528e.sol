1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title LinkedListLib
5  * @author Darryl Morris (o0ragman0o) and Modular.network
6  * 
7  * This utility library was forked from https://github.com/o0ragman0o/LibCLL
8  * into the Modular-Network ethereum-libraries repo at https://github.com/Modular-Network/ethereum-libraries
9  * It has been updated to add additional functionality and be more compatible with solidity 0.4.18
10  * coding patterns.
11  *
12  * version 1.0.0
13  * Copyright (c) 2017 Modular Inc.
14  * The MIT License (MIT)
15  * https://github.com/Modular-Network/ethereum-libraries/blob/master/LICENSE
16  * 
17  * The LinkedListLib provides functionality for implementing data indexing using
18  * a circlular linked list
19  *
20  * Modular provides smart contract services and security reviews for contract
21  * deployments in addition to working on open source projects in the Ethereum
22  * community. Our purpose is to test, document, and deploy reusable code onto the
23  * blockchain and improve both security and usability. We also educate non-profits,
24  * schools, and other community members about the application of blockchain
25  * technology. For further information: modular.network
26  *
27  *
28  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
29  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
30  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
31  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
32  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
33  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
34  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
35 */
36 
37 
38 library LinkedListLib {
39 
40     uint256 constant NULL = 0;
41     uint256 constant HEAD = 0;
42     bool constant PREV = false;
43     bool constant NEXT = true;
44     
45     struct LinkedList{
46         mapping (uint256 => mapping (bool => uint256)) list;
47     }
48 
49     /// @dev returns true if the list exists
50     /// @param self stored linked list from contract
51     function listExists(LinkedList storage self)
52         internal
53         view returns (bool)
54     {
55         // if the head nodes previous or next pointers both point to itself, then there are no items in the list
56         if (self.list[HEAD][PREV] != HEAD || self.list[HEAD][NEXT] != HEAD) {
57             return true;
58         } else {
59             return false;
60         }
61     }
62 
63     /// @dev returns true if the node exists
64     /// @param self stored linked list from contract
65     /// @param _node a node to search for
66     function nodeExists(LinkedList storage self, uint256 _node) 
67         internal
68         view returns (bool)
69     {
70         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
71             if (self.list[HEAD][NEXT] == _node) {
72                 return true;
73             } else {
74                 return false;
75             }
76         } else {
77             return true;
78         }
79     }
80     
81     /// @dev Returns the number of elements in the list
82     /// @param self stored linked list from contract
83     function sizeOf(LinkedList storage self) internal view returns (uint256 numElements) {
84         bool exists;
85         uint256 i;
86         (exists,i) = getAdjacent(self, HEAD, NEXT);
87         while (i != HEAD) {
88             (exists,i) = getAdjacent(self, i, NEXT);
89             numElements++;
90         }
91         return;
92     }
93 
94     /// @dev Returns the links of a node as a tuple
95     /// @param self stored linked list from contract
96     /// @param _node id of the node to get
97     function getNode(LinkedList storage self, uint256 _node)
98         internal view returns (bool,uint256,uint256)
99     {
100         if (!nodeExists(self,_node)) {
101             return (false,0,0);
102         } else {
103             return (true,self.list[_node][PREV], self.list[_node][NEXT]);
104         }
105     }
106 
107     /// @dev Returns the link of a node `_node` in direction `_direction`.
108     /// @param self stored linked list from contract
109     /// @param _node id of the node to step from
110     /// @param _direction direction to step in
111     function getAdjacent(LinkedList storage self, uint256 _node, bool _direction)
112         internal view returns (bool,uint256)
113     {
114         if (!nodeExists(self,_node)) {
115             return (false,0);
116         } else {
117             return (true,self.list[_node][_direction]);
118         }
119     }
120     
121     /// @dev Can be used before `insert` to build an ordered list
122     /// @param self stored linked list from contract
123     /// @param _node an existing node to search from, e.g. HEAD.
124     /// @param _value value to seek
125     /// @param _direction direction to seek in
126     //  @return next first node beyond '_node' in direction `_direction`
127     function getSortedSpot(LinkedList storage self, uint256 _node, uint256 _value, bool _direction)
128         internal view returns (uint256)
129     {
130         if (sizeOf(self) == 0) { return 0; }
131         require((_node == 0) || nodeExists(self,_node));
132         bool exists;
133         uint256 next;
134         (exists,next) = getAdjacent(self, _node, _direction);
135         while  ((next != 0) && (_value != next) && ((_value < next) != _direction)) next = self.list[next][_direction];
136         return next;
137     }
138     
139     /// @dev Can be used before `insert` to build an ordered list
140     /// @param self stored linked list from contract
141     /// @param _node an existing node to search from, e.g. HEAD.
142     /// @param _value value to seek
143     /// @param _direction direction to seek in
144     //  @return next first node beyond '_node' in direction `_direction`
145     function getSortedSpotByFunction(LinkedList storage self, uint256 _node, uint256 _value, bool _direction, function (uint, uint) view returns (bool) smallerComparator, int256 searchLimit)
146         internal view returns (uint256 nextNodeIndex, bool found, uint256 sizeEnd)
147     {
148         if ((sizeEnd=sizeOf(self)) == 0) { return (0, true, sizeEnd); }
149         require((_node == 0) || nodeExists(self,_node));
150         bool exists;
151         uint256 next;
152         (exists,next) = getAdjacent(self, _node, _direction);
153         while  ((--searchLimit >= 0) && (next != 0) && (_value != next) && (smallerComparator(_value, next) != _direction)) next = self.list[next][_direction];
154         if(searchLimit >= 0)
155             return (next, true, sizeEnd + 1);
156         else return (0, false, sizeEnd); //We exhausted the search limit without finding a position!
157     }
158 
159     /// @dev Creates a bidirectional link between two nodes on direction `_direction`
160     /// @param self stored linked list from contract
161     /// @param _node first node for linking
162     /// @param _link  node to link to in the _direction
163     function createLink(LinkedList storage self, uint256 _node, uint256 _link, bool _direction) internal  {
164         self.list[_link][!_direction] = _node;
165         self.list[_node][_direction] = _link;
166     }
167 
168     /// @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
169     /// @param self stored linked list from contract
170     /// @param _node existing node
171     /// @param _new  new node to insert
172     /// @param _direction direction to insert node in
173     function insert(LinkedList storage self, uint256 _node, uint256 _new, bool _direction) internal returns (bool) {
174         if(!nodeExists(self,_new) && nodeExists(self,_node)) {
175             uint256 c = self.list[_node][_direction];
176             createLink(self, _node, _new, _direction);
177             createLink(self, _new, c, _direction);
178             return true;
179         } else {
180             return false;
181         }
182     }
183     
184     /// @dev removes an entry from the linked list
185     /// @param self stored linked list from contract
186     /// @param _node node to remove from the list
187     function remove(LinkedList storage self, uint256 _node) internal returns (uint256) {
188         if ((_node == NULL) || (!nodeExists(self,_node))) { return 0; }
189         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
190         delete self.list[_node][PREV];
191         delete self.list[_node][NEXT];
192         return _node;
193     }
194 
195     /// @dev pushes an enrty to the head of the linked list
196     /// @param self stored linked list from contract
197     /// @param _node new entry to push to the head
198     /// @param _direction push to the head (NEXT) or tail (PREV)
199     function push(LinkedList storage self, uint256 _node, bool _direction) internal  {
200         insert(self, HEAD, _node, _direction);
201     }
202     
203     /// @dev pops the first entry from the linked list
204     /// @param self stored linked list from contract
205     /// @param _direction pop from the head (NEXT) or the tail (PREV)
206     function pop(LinkedList storage self, bool _direction) internal returns (uint256) {
207         bool exists;
208         uint256 adj;
209 
210         (exists,adj) = getAdjacent(self, HEAD, _direction);
211 
212         return remove(self, adj);
213     }
214 }
215 
216 // ----------------------------------------------------------------------------
217 // 'Coke' token contract
218 //
219 // Deployed to : 0xb9907e0151e8c5937f17d0721953cf1ea114528e
220 // Symbol      : COKE
221 // Name        : Coke Token
222 // Total supply: 875 000 000 000 000 micrograms (875 tons)
223 // Decimals    : 6 (micrograms)
224 //
225 // @2018 FC
226 // ----------------------------------------------------------------------------
227 
228 
229 // ----------------------------------------------------------------------------
230 // Safe maths
231 // ----------------------------------------------------------------------------
232 contract SafeMath {
233     function safeAdd(uint a, uint b) public pure returns (uint c) {
234         c = a + b;
235         require(c >= a && c >= b);
236     }
237     function safeSub(uint a, uint b) public pure returns (uint c) {
238         require(b <= a);
239         c = a - b;
240     }
241     function safeMul(uint a, uint b) public pure returns (uint c) {
242         c = a * b;
243         require(a == 0 || c / a == b);
244     }
245     function safeDiv(uint a, uint b) public pure returns (uint c) {
246         require(b > 0);
247         c = a / b;
248     }
249     
250     function min(uint x, uint y) internal pure returns (uint z) {
251         return x <= y ? x : y;
252     }
253     function max(uint x, uint y) internal pure returns (uint z) {
254         return x >= y ? x : y;
255     }
256 }
257 
258 contract Mutex {
259     bool locked;
260     modifier noReentrancy() {
261         require(!locked);
262         locked = true;
263         _;
264         locked = false;
265     }
266 }
267 
268 // ----------------------------------------------------------------------------
269 // ERC Token Standard #20 Interface
270 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
271 // ----------------------------------------------------------------------------
272 contract ERC20Interface {
273     function totalSupply() public constant returns (uint);
274     function balanceOf(address tokenOwner) public constant returns (uint balance);
275     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
276     function transfer(address to, uint tokens) public returns (bool success);
277     function approve(address spender, uint tokens) public returns (bool success);
278     function transferFrom(address from, address to, uint tokens) public returns (bool success);
279 
280     event Transfer(address indexed from, address indexed to, uint tokens);
281     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
282 }
283 
284 
285 // ----------------------------------------------------------------------------
286 // Contract function to receive approval and execute function in one call
287 //
288 // ----------------------------------------------------------------------------
289 contract ApproveAndCallFallBack {
290     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
291 }
292 
293 // ----------------------------------------------------------------------------
294 // Owned contract
295 // ----------------------------------------------------------------------------
296 contract Owned {
297     address public owner;
298     address public newOwner;
299 
300     event OwnershipTransferred(address indexed _from, address indexed _to);
301 
302     function Owned() public {
303         owner = msg.sender;
304     }
305 
306     modifier onlyOwner {
307         require(msg.sender == owner);
308         _;
309     }
310 
311     function transferOwnership(address _newOwner) public onlyOwner {
312         newOwner = _newOwner;
313     }
314     function acceptOwnership() public {
315         require(msg.sender == newOwner);
316         emit OwnershipTransferred(owner, newOwner);
317         owner = newOwner;
318         newOwner = address(0);
319     }
320 }
321 
322 // ----------------------------------------------------------------------------
323 // Contract "Recoverable", to allow a failsafe in case of user error, so users can recover their mistakenly sent Tokens or Eth
324 // https://github.com/ethereum/dapp-bin/blob/master/library/recoverable.sol
325 // ----------------------------------------------------------------------------
326 contract Recoverable is Owned {
327     // ------------------------------------------------------------------------
328     // Owner can transfer out any accidentally sent ERC20 tokens
329     // ------------------------------------------------------------------------
330     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
331         return ERC20Interface(tokenAddress).transfer(owner, tokens);
332     }
333     
334     // ------------------------------------------------------------------------
335     // Owner can transfer out any accidentally sent ETH
336     // ------------------------------------------------------------------------
337     function recoverLostEth(address toAddress, uint value) public onlyOwner returns (bool success) {
338         toAddress.transfer(value);
339         return true;
340     }
341 }
342 
343 /**
344  * @title EmergencyProtectedMode
345  * @dev Base contract which allows children to implement an emergency stop mechanism different than pausable. Useful for when we want to 
346  * stop the normal business of the contract (using the Pausable contract), but still allow some operations like withdrawls for users.
347  */
348 contract EmergencyProtectedMode is Owned {
349   event EmergencyProtectedModeActivated();
350   event EmergencyProtectedModeDeactivated();
351 
352   bool public emergencyProtectedMode = false;
353 
354   /**
355    * @dev Modifier to make a function callable only when the contract is not paused.
356    */
357   modifier whenNotInEmergencyProtectedMode() {
358     require(!emergencyProtectedMode);
359     _;
360   }
361 
362   /**
363    * @dev Modifier to make a function callable only when the contract is paused.
364    */
365   modifier whenInEmergencyProtectedMode() {
366     require(emergencyProtectedMode);
367     _;
368   }
369 
370   /**
371    * @dev called by the owner to activate emergency protected mode, triggers stopped state, to use in case of last resort, and stop even last case operations (in case of a security compromise)
372    */
373   function activateEmergencyProtectedMode() onlyOwner whenNotInEmergencyProtectedMode public {
374     emergencyProtectedMode = true;
375     emit EmergencyProtectedModeActivated();
376   }
377 
378   /**
379    * @dev called by the owner to deactivate emergency protected mode, returns to normal state
380    */
381   function deactivateEmergencyProtectedMode() onlyOwner whenInEmergencyProtectedMode public {
382     emergencyProtectedMode = false;
383     emit EmergencyProtectedModeDeactivated();
384   }
385 }
386 
387 /**
388  * @title Pausable
389  * @dev Base contract which allows children to implement an emergency stop mechanism.
390  */
391 contract Pausable is Owned {
392   event Pause();
393   event Unpause();
394 
395   bool public paused = false;
396 
397 
398   /**
399    * @dev Modifier to make a function callable only when the contract is not paused.
400    */
401   modifier whenNotPaused() {
402     require(!paused);
403     _;
404   }
405 
406   /**
407    * @dev Modifier to make a function callable only when the contract is paused.
408    */
409   modifier whenPaused() {
410     require(paused);
411     _;
412   }
413 
414   /**
415    * @dev called by the owner to pause, triggers stopped state
416    */
417   function pause() onlyOwner whenNotPaused public {
418     paused = true;
419     emit Pause();
420   }
421 
422   /**
423    * @dev called by the owner to unpause, returns to normal state
424    */
425   function unpause() onlyOwner whenPaused public {
426     paused = false;
427     emit Unpause();
428   }
429 }
430 
431 /**
432  * @title Migratable
433  * @dev Base contract which allows children to be migratable, that is it allows contracts to migrate to another contract (sucessor) that 
434  * is a more advanced version of the previous contract (more functionality, improved security, etc.).
435  */
436 contract Migratable is Owned {
437     address public sucessor; //By default, sucessor will be address 0, meaning the current contract is still active and has no sucessor yet!
438     function setSucessor(address _sucessor) onlyOwner public {
439       sucessor=_sucessor;
440     }
441 }
442 
443 // ---------------------------------------------------------------------------------------------
444 // Directly Exchangeable token
445 // This will allow users to directly exchange between themselves tokens for Eth and vice versa, 
446 // while having the assurance the other party will be kept to their part of the agreement.
447 // ---------------------------------------------------------------------------------------------
448 contract DirectlyExchangeable {
449     bool public isRatio; //Should be true if the prices used will be a Ratio, and not just a simple price, otherwise false.
450 
451     function sellToConsumer(address consumer, uint quantity, uint price) public returns (bool success);
452     function buyFromTrusterDealer(address dealer, uint quantity, uint price) public payable returns (bool success);
453     function cancelSellToConsumer(address consumer) public returns (bool success);
454     function checkMySellerOffer(address consumer) public view returns (uint quantity, uint price, uint totalWeiCost);
455     function checkSellerOffer(address seller) public view returns (uint quantity, uint price, uint totalWeiCost);
456 
457     //Events:
458     event DirectOfferAvailable(address indexed seller, address indexed buyer, uint quantity, uint price);
459     event DirectOfferCancelled(address indexed seller, address indexed consumer, uint quantity, uint price);
460     event OrderQuantityMismatch(address indexed addr, uint expectedInRegistry, uint buyerValue);
461     event OrderPriceMismatch(address indexed addr, uint expectedInRegistry, uint buyerValue);
462 }
463 
464 // ---------------------------------------------------------------------------------------------
465 // Black Market Sellable token
466 // This will allow users to sell and buy from a black market, without knowing one another, 
467 // while having the assurance the other party will keep their part of the agreement.
468 // ---------------------------------------------------------------------------------------------
469 contract BlackMarketSellable {
470     bool public isRatio; //Should be true if the prices used will be a Ratio, and not just a simple price, otherwise false.
471 
472     function sellToBlackMarket(uint quantity, uint price) public returns (bool success, uint numOrderCreated);
473     function cancelSellToBlackMarket(uint quantity, uint price, bool continueAfterFirstMatch) public returns (bool success, uint numOrdersCanceled);
474     function buyFromBlackMarket(uint quantity, uint priceLimit) public payable returns (bool success, bool partial, uint numOrdersCleared);
475     function getSellOrdersBlackMarket() public view returns (uint[] memory r);
476     function getSellOrdersBlackMarketComplete() public view returns (uint[] memory quantities, uint[] memory prices);
477     function getMySellOrdersBlackMarketComplete() public view returns (uint[] memory quantities, uint[] memory prices);
478 
479     //Events:
480     event BlackMarketOfferAvailable(uint quantity, uint price);
481     event BlackMarketOfferBought(uint quantity, uint price, uint leftOver);
482     event BlackMarketNoOfferForPrice(uint price);
483     event BlackMarketOfferCancelled(uint quantity, uint price);
484     event OrderInsufficientPayment(address indexed addr, uint expectedValue, uint valueReceived);
485     event OrderInsufficientBalance(address indexed addr, uint expectedBalance, uint actualBalance);
486 }
487 
488 // ----------------------------------------------------------------------------
489 // ERC20 Token, with the addition of symbol, name and decimals and assisted
490 // token transfers
491 // ----------------------------------------------------------------------------
492 contract Coke is ERC20Interface, Owned, Pausable, EmergencyProtectedMode, Recoverable, Mutex, Migratable, DirectlyExchangeable, BlackMarketSellable, SafeMath {
493     string public symbol;
494     string public  name;
495     uint8 public decimals;
496     uint public _totalSupply;
497 
498     mapping(address => uint) balances;
499     mapping(address => mapping(address => uint)) allowed;
500 
501     //Needed setup for LinkedList needed for the market:
502     using LinkedListLib for LinkedListLib.LinkedList;
503     uint256 constant NULL = 0;
504     uint256 constant HEAD = 0;
505     bool constant PREV = false;
506     bool constant NEXT = true;
507 
508     //Token specific properties:
509 
510     uint16 public constant yearOfProduction = 1997;
511     string public constant protectedDenominationOfOrigin = "Colombia";
512     string public constant targetDemographics = "The jet set / Top of the tops";
513     string public constant securityAudit = "ExtremeAssets Team Ref: XN872 Approved";
514     uint buyRatio; //Ratio to buy from the contract directly
515     uint sellRatio; //Ratio to sell from the contract directly
516     uint private _factorDecimalsEthToToken;
517     uint constant undergroundBunkerReserves = 2500000000000;
518     mapping(address => uint) changeToReturn; //The change to return to senders (in ETH value (Wei))
519     mapping(address => uint) gainsToReceive; //The gains to receive (for sellers) (in ETH value (Wei))
520     mapping(address => uint) tastersReceived; //Number of tokens received as a taster for each address
521     mapping(address => uint) toFlush; //Keeps address to be flushed (the value stored is the number of the block of when coke can be really flushed from the system)
522 
523     event Flushed(address indexed addr);
524     event ChangeToReceiveGotten(address indexed addr, uint weiToReceive, uint totalWeiToReceive);
525     event GainsGotten(address indexed addr, uint weiToReceive, uint totalWeiToReceive);
526     
527     struct SellOffer {
528         uint price;
529         uint quantity;
530     }
531     struct SellOfferComplete {
532         uint price;
533         uint quantity;
534         address seller;
535     }
536     mapping(address => mapping(address => SellOffer)) directOffers; //Direct offers
537     LinkedListLib.LinkedList blackMarketOffersSorted;
538     mapping(uint => SellOfferComplete) public blackMarketOffersMap;
539     uint marketOfferCounter = 0; //Counter that will increment for each offer
540 
541     uint directOffersComissionRatio = 100; //Ratio of the comission to buy from the contract directly (1%)
542     uint marketComissionRatio = 50; //Ratio of the comission to buy from the market (2%)
543     int32 maxMarketOffers = 100; //Maximum of market offers at the same time (will only keep the N less costly offers)
544 
545     //Message board variables:
546     struct Message {
547         uint valuePayed;
548         string msg;
549         address from;
550     }
551     LinkedListLib.LinkedList topMessagesSorted;
552     mapping(uint => Message) public topMessagesMap;
553     uint topMessagesCounter = 0; //Counter that will increment for each message
554     int32 maxMessagesTop = 20; //Maximum of top messages at the same time (will keep the N most payed messages)
555     Message[] messages;
556     int32 maxMessagesGlobal = 100; //Maximum number of messages at the same time (will keep the N most recently received messages)
557     int32 firstMsgGlobal = 0; //Indexes that will mark the first and the last message received in the array of global messages (revolving array)
558     int32 lastMsgGlobal = -1;
559     uint maxCharactersMessage = 750; //The maximum of characters a message can have
560 
561     event NewMessageAvailable(address indexed from, string message);
562     event ExceededMaximumMessageSize(uint messageSize, uint maximumMessageSize); //Message is bigger than maximum allowed characters for each message
563 
564     //Addresses to be used for random letItRain!
565     address[] lastAddresses;
566     int32 maxAddresses = 100; //Maximum number of addresses at the same time (will keep the N most recently mentioned addresses)
567     int32 firstAddress = 0; //Indexes that will mark the first and the last address received in the array of last addresses (revolving array)
568     int32 lastAddress = -1;
569     
570     event NoAddressesAvailable();
571     
572     // ------------------------------------------------------------------------
573     // Confirms the user is not in the middle of a flushing process
574     // ------------------------------------------------------------------------
575     modifier whenNotFlushing() {
576         require(toFlush[msg.sender] == 0);
577         _;
578     }
579 
580     // ------------------------------------------------------------------------
581     // Constructor
582     // ------------------------------------------------------------------------
583     function Coke() public {
584         symbol = "Coke";
585         name = "100 % Pure Cocaine";
586         decimals = 6; //Micrograms
587         _totalSupply = 875000000 * (uint(10)**decimals);
588         _factorDecimalsEthToToken = uint(10)**(18);
589         buyRatio = 10 * (uint(10)**decimals); //10g <- 1 ETH
590         sellRatio = 20 * (uint(10)**decimals); //20g -> 1 ETH
591         isRatio = true; //Buy and sell prices are ratios (and not simple prices) of how many tokens per 1 ETH
592         balances[0] = _totalSupply - undergroundBunkerReserves;
593         balances[msg.sender] = undergroundBunkerReserves;
594         //blackMarketOffers.length = maxMarketOffers;
595         //Do a reservation for msg.sender! Allow rest to be sold by contract!
596         emit Transfer(address(0), msg.sender, undergroundBunkerReserves);
597     }
598 
599 
600     // ------------------------------------------------------------------------
601     // Total supply
602     // ------------------------------------------------------------------------
603     function totalSupply() public constant returns (uint) {
604         return _totalSupply /* - balances[address(0)] */;
605     }
606 
607 
608     // ------------------------------------------------------------------------
609     // Get the token balance for account tokenOwner
610     // ------------------------------------------------------------------------
611     function balanceOf(address tokenOwner) public constant returns (uint balance) {
612         return balances[tokenOwner];
613     }
614 
615 
616     function transferInt(address from, address to, uint tokens, bool updateTasters) internal returns (bool success) {
617         if(updateTasters) {
618             //Check if sender has received tasters:
619             if(tastersReceived[from] > 0) {
620                 uint tasterTokens = min(tokens, tastersReceived[from]);
621                 tastersReceived[from] = safeSub(tastersReceived[from], tasterTokens);
622                 if(to != address(0)) {
623                     tastersReceived[to] = safeAdd(tastersReceived[to], tasterTokens);
624                 }
625             }
626         }
627         balances[from] = safeSub(balances[from], tokens);
628         balances[to] = safeAdd(balances[to], tokens);
629         emit Transfer(from, to, tokens);
630         return true;
631     }
632 
633     // ------------------------------------------------------------------------
634     // Transfer the balance from token owner's account to to account
635     // - Owner's account must have sufficient balance to transfer
636     // - 0 value transfers are allowed
637     // ------------------------------------------------------------------------
638     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
639         return transferInt(msg.sender, to, tokens, true);
640     }
641     
642     // ------------------------------------------------------------------------
643     // Token owner can approve for spender to transferFrom(...) tokens
644     // from the token owner's account
645     //
646     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
647     // recommends that there are no checks for the approval double-spend attack
648     // as this should be implemented in user interfaces 
649     // ------------------------------------------------------------------------
650     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
651         allowed[msg.sender][spender] = tokens;
652         emit Approval(msg.sender, spender, tokens);
653         return true;
654     }
655 
656 
657     // ------------------------------------------------------------------------
658     // Transfer tokens from the from account to the to account
659     // 
660     // The calling account must already have sufficient tokens approve(...)-d
661     // for spending from the from account and
662     // - From account must have sufficient balance to transfer
663     // - Spender must have sufficient allowance to transfer
664     // - 0 value transfers are allowed
665     // ------------------------------------------------------------------------
666     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
667         //Update the allowance, the rest it business as usual for the transferInt method:
668         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
669         return transferInt(from, to, tokens, true);
670     }
671 
672 
673     // ------------------------------------------------------------------------
674     // Returns the amount of tokens approved by the owner that can be
675     // transferred to the spender's account
676     // ------------------------------------------------------------------------
677     function allowance(address tokenOwner, address spender) public constant whenNotPaused returns (uint remaining) {
678         return allowed[tokenOwner][spender];
679     }
680 
681 
682     // ------------------------------------------------------------------------
683     // Token owner can approve for spender to transferFrom(...) tokens
684     // from the token owner's account. The spender contract function
685     // receiveApproval(...) is then executed
686     // ------------------------------------------------------------------------
687     function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {
688         allowed[msg.sender][spender] = tokens;
689         emit Approval(msg.sender, spender, tokens);
690         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
691         return true;
692     }
693 
694     // ------------------------------------------------------------------------
695     // Calculates the number of tokens (in unsigned integer form [decimals included]) corresponding to the weiValue passed, using the ratio specified
696     // ------------------------------------------------------------------------
697     function calculateTokensFromWei(uint weiValue, uint ratio) public view returns (uint numTokens) {
698         uint calc1 = safeMul(weiValue, ratio);
699         uint ethValue = calc1 / _factorDecimalsEthToToken;
700         return ethValue;
701     }
702 
703     // ------------------------------------------------------------------------
704     // Calculates the Eth value (in wei) corresponding to the number of tokens passed (in unsigned integer form [decimals included]), using the ratio specified
705     // ------------------------------------------------------------------------
706     function calculateEthValueFromTokens(uint numTokens, uint ratio) public view returns (uint weiValue) {
707         uint calc1 = safeMul(numTokens, _factorDecimalsEthToToken);
708         uint retValue = calc1 / ratio;
709         return retValue;
710     }
711     
712     // ------------------------------------------------------------------------
713     // Will buy tokens corresponding to the Ether sent (Own Token Specific Method)
714     // - Contract supply of tokens must have enough balance
715     // ------------------------------------------------------------------------
716     function buyCoke() public payable returns (bool success) {
717         //Calculate tokens corresponding to the Ether sent:
718         uint numTokensToBuy = calculateTokensFromWei(msg.value, buyRatio);
719         uint finalNumTokensToBuy = numTokensToBuy;
720         if(numTokensToBuy > balances[0]) {
721             //Adjust number of tokens to buy, to those available in stock:
722             finalNumTokensToBuy = balances[0];
723             //Update change to return for this sender (in Wei):
724             //SAFETY CHECK: No need to use safeSub for (numTokensToBuy - finalNumTokensToBuy), as we already know that numTokensToBuy > finalNumTokensToBuy!
725             uint ethValueFromTokens = calculateEthValueFromTokens(numTokensToBuy - finalNumTokensToBuy, buyRatio); //In Wei
726             changeToReturn[msg.sender] = safeAdd(changeToReturn[msg.sender], ethValueFromTokens );
727             emit ChangeToReceiveGotten(msg.sender, ethValueFromTokens, changeToReturn[msg.sender]);
728         }
729         if(finalNumTokensToBuy <= balances[0]) {
730             /*
731             balances[0] = safeSub(balances[0], finalNumTokensToBuy);
732             balances[msg.sender] = safeAdd(balances[msg.sender], finalNumTokensToBuy);
733             Transfer(address(0), msg.sender, finalNumTokensToBuy);
734             */
735             transferInt(address(0), msg.sender, finalNumTokensToBuy, false);
736             return true;
737         }
738         else return false;
739     }
740     
741     // ------------------------------------------------------------------------
742     // Will show to the user that is asking the change he has to receive
743     // ------------------------------------------------------------------------
744     function checkChangeToReceive() public view returns (uint changeInWei) {
745         return changeToReturn[msg.sender];
746     }
747 
748     // ------------------------------------------------------------------------
749     // Will show to the user that is asking the gains he has to receive
750     // ------------------------------------------------------------------------
751     function checkGainsToReceive() public view returns (uint gainsInWei) {
752         return gainsToReceive[msg.sender];
753     }
754 
755     // ------------------------------------------------------------------------
756     // Will get change in ETH from the tokens that were not possible to buy in a previous order
757     // - Contract supply of ETH must have enough balance (which should be in every case)
758     // ------------------------------------------------------------------------
759     function retrieveChange() public noReentrancy whenNotInEmergencyProtectedMode returns (bool success) {
760         uint change = changeToReturn[msg.sender];
761         if(change > 0) {
762             //Set correct value of change before calling transfer method to avoid reentrance after sending to another contracts:
763             changeToReturn[msg.sender] = 0;
764             //Send corresponding ETH to sender:
765             msg.sender.transfer(change);
766             return true;
767         }
768         else return false;
769     }
770 
771     // ------------------------------------------------------------------------
772     // Will get gains in ETH from the tokens that the seller has previously sold
773     // - Contract supply of ETH must have enough balance (which should be in every case)
774     // ------------------------------------------------------------------------
775     function retrieveGains() public noReentrancy whenNotInEmergencyProtectedMode returns (bool success) {
776         uint gains = gainsToReceive[msg.sender];
777         if(gains > 0) {
778             //Set correct value of "gains to receive" before calling transfer method to avoid reentrance attack after possibly sending to another contract:
779             gainsToReceive[msg.sender] = 0;
780             //Send corresponding ETH to sender:
781             msg.sender.transfer(gains);
782             return true;
783         }
784         else return false;
785     }
786 
787     // ------------------------------------------------------------------------
788     // Will return N bought tokens to the contract
789     // - User supply of tokens must have enough balance
790     // ------------------------------------------------------------------------
791     function returnCoke(uint ugToReturn) public noReentrancy whenNotPaused whenNotFlushing returns (bool success) {
792         //require(ugToReturn <= balances[msg.sender]); //Check balance of user
793         //Following require not needed anymore, will just pay the difference!
794         //require(ugToReturn > tastersReceived[msg.sender]); //Check if the mg to return are greater than the ones received as a taster
795         //Maximum possible number of mg to return, have to be lower than the balance of the user minus the tasters received:
796         uint finalUgToReturnForEth = min(ugToReturn, safeSub(balances[msg.sender], tastersReceived[msg.sender])); //Subtract tasters received from the total amount to return
797         //require(finalUgToReturnForEth <= balances[msg.sender]); //Check balance of user (No need for this extra check, as the minimum garantees at most the value of the balance[] to be returned)
798         //Calculate tokens corresponding to the Ether sent:
799         uint ethToReturn = calculateEthValueFromTokens(finalUgToReturnForEth, sellRatio); //Ethereum to return (in Wei)
800         
801         if(ethToReturn > 0) {
802             //Will return eth in exchange for the coke!
803             //Receive the coke:
804             transfer(address(0), finalUgToReturnForEth);
805             /*
806             balances[0] = safeAdd(balances[0], finalUgToReturnForEth);
807             balances[msg.sender] = safeSub(balances[msg.sender], finalUgToReturnForEth);
808             Transfer(msg.sender, address(0), finalUgToReturnForEth);
809             */
810             
811             //Return the Eth:
812             msg.sender.transfer(ethToReturn);
813             return true;
814         }
815         else return false;
816     }
817 
818     // ------------------------------------------------------------------------
819     // Will return all bought tokens to the contract
820     // ------------------------------------------------------------------------
821     function returnAllCoke() public returns (bool success) {
822         return returnCoke(safeSub(balances[msg.sender], tastersReceived[msg.sender]));
823     }
824 
825     // ------------------------------------------------------------------------
826     // Sends a special taster package to recipient
827     // - Contract supply of tokens must have enough balance
828     // ------------------------------------------------------------------------
829     function sendSpecialTasterPackage(address addr, uint ugToTaste) public whenNotPaused onlyOwner returns (bool success) {
830         tastersReceived[addr] = safeAdd(tastersReceived[addr], ugToTaste);
831         transfer(addr, ugToTaste);
832         return true;
833     }
834 
835     // ------------------------------------------------------------------------
836     // Will transfer to selected address a load of tokens
837     // - User supply of tokens must have enough balance
838     // ------------------------------------------------------------------------
839     function sendShipmentTo(address to, uint tokens) public returns (bool success) {
840         return transfer(to, tokens);
841     }
842 
843     // ------------------------------------------------------------------------
844     // Will transfer a small sample to selected address
845     // - User supply of tokens must have enough balance
846     // ------------------------------------------------------------------------
847     function sendTaster(address to) public returns (bool success) {
848         //Sending in 0.000002 g (that is 2 micrograms):
849         return transfer(to, 2);
850     }
851 
852     function lengthAddresses() internal view returns (uint) {
853         return (firstAddress > 0) ? lastAddresses.length : uint(lastAddress + 1);
854     }
855 
856     // ------------------------------------------------------------------------
857     // Will make it rain! Will throw some tokens from the user to some random addresses, spreading the happiness everywhere!
858     // The greater the range, it will supply to addresses further away.
859     // - User supply of tokens must have enough balance
860     // ------------------------------------------------------------------------
861     function letItRain(uint8 range, uint quantity) public returns (bool success) {
862         require(quantity <= balances[msg.sender]);
863         if(lengthAddresses() == 0) {
864             emit NoAddressesAvailable();
865             return false;
866         }
867         bytes32 hashBlock100 = block.blockhash(100); //Get hash of previous 100th block
868         bytes32 randomHash = keccak256(keccak256(hashBlock100)); //SAFETY CHECK: Increase difficulty to reverse needed hashBlock100 (in case of attack by the miners)
869         byte posAddr = randomHash[1]; //Check position one (to 10, maximum) of randomHash to use for the position(s) in the addresses array
870         byte howMany = randomHash[30]; //Check position 30 of randomHash to use for how many addresses base
871         
872         uint8 posInt = (uint8(posAddr) + range * 2) % uint8(lengthAddresses()); //SAFETY CHECK: lengthAddresses() can't be greater than 256!!
873         uint8 howManyInt = uint8(howMany) % uint8(lengthAddresses()); //SAFETY CHECK: lengthAddresses() can't be greater than 256!!
874         howManyInt = howManyInt > 10 ? 10 : howManyInt; //At maximum distribute to 10 addresses
875         howManyInt = howManyInt < 2 ? 2 : howManyInt; //At minimum distribute to 2 addresses
876         
877         address addr;
878         
879         uint8 counter = 0;
880         uint quant = quantity / howManyInt;
881         
882         do {
883             
884             //Distribute to one random address:
885             addr = lastAddresses[posInt];
886             transfer(addr, quant);
887             
888             posInt = (uint8(randomHash[1 + counter]) + range * 2) % uint8(lengthAddresses());
889             
890             counter++;
891             
892             //SAFETY CHECK: As the integer divisions are truncated (--> (quant * howManyInt) <= quantity (always) ), the following code is not needed:
893             /*
894             //we have to ensure, in case of uneven division, to just use at maximum the quantity specified by the user:
895             if(quantity > quant) {
896                 quantity = quantity - quant;
897             }
898             else {
899                 quant = quantity;
900             }
901             */
902         }
903         while(quantity > 0 && counter < howManyInt);
904         
905         return true;
906     }
907 
908     // ------------------------------------------------------------------------
909     // Method will be used to set a certain number of addresses periodically. These addresses will be the ones to receive randomly the tokens when somebody makes it rain!
910     // The list of addresses should be gotten from the main ethereum, by checking for addresses used in the latest transactions.
911     // ------------------------------------------------------------------------
912     function setAddressesForRain(address[] memory addresses) public onlyOwner returns (bool success) {
913         require(addresses.length <= uint(maxAddresses) && addresses.length > 0);
914         lastAddresses = addresses;
915         firstAddress = 0;
916         lastAddress = int32(addresses.length) - 1;
917         return true;
918     }
919 
920     // ------------------------------------------------------------------------
921     // Will get the Maximum of addresses to be used for making it rain
922     // ------------------------------------------------------------------------
923     function getMaxAddresses() public view returns (int32) {
924         return maxAddresses;
925     }
926 
927     // ------------------------------------------------------------------------
928     // Will set the Maximum of addresses to be used for making it rain (Maximum of 255 Addresses)
929     // ------------------------------------------------------------------------
930     function setMaxAddresses(int32 _maxAddresses) public onlyOwner returns (bool success) {
931         require(_maxAddresses > 0 && _maxAddresses < 256);
932         maxAddresses = _maxAddresses;
933         return true;
934     }
935 
936     // ------------------------------------------------------------------------
937     // Will get the Buy Ratio
938     // ------------------------------------------------------------------------
939     function getBuyRatio() public view returns (uint) {
940         return buyRatio;
941     }
942 
943     // ------------------------------------------------------------------------
944     // Will set the Buy Ratio
945     // ------------------------------------------------------------------------
946     function setBuyRatio(uint ratio) public onlyOwner returns (bool success) {
947         require(ratio != 0);
948         buyRatio = ratio;
949         return true;
950     }
951 
952     // ------------------------------------------------------------------------
953     // Will get the Sell Ratio
954     // ------------------------------------------------------------------------
955     function getSellRatio() public view returns (uint) {
956         return sellRatio;
957     }
958 
959     // ------------------------------------------------------------------------
960     // Will set the Sell Ratio
961     // ------------------------------------------------------------------------
962     function setSellRatio(uint ratio) public onlyOwner returns (bool success) {
963         require(ratio != 0);
964         sellRatio = ratio;
965         return true;
966     }
967 
968     // ------------------------------------------------------------------------
969     // Will set the Direct Offers Comission Ratio
970     // ------------------------------------------------------------------------
971     function setDirectOffersComissionRatio(uint ratio) public onlyOwner returns (bool success) {
972         require(ratio != 0);
973         directOffersComissionRatio = ratio;
974         return true;
975     }
976 
977     // ------------------------------------------------------------------------
978     // Will get the Direct Offers Comission Ratio
979     // ------------------------------------------------------------------------
980     function getDirectOffersComissionRatio() public view returns (uint) {
981         return directOffersComissionRatio;
982     }
983 
984     // ------------------------------------------------------------------------
985     // Will set the Market Comission Ratio
986     // ------------------------------------------------------------------------
987     function setMarketComissionRatio(uint ratio) public onlyOwner returns (bool success) {
988         require(ratio != 0);
989         marketComissionRatio = ratio;
990         return true;
991     }
992 
993     // ------------------------------------------------------------------------
994     // Will get the Market Comission Ratio
995     // ------------------------------------------------------------------------
996     function getMarketComissionRatio() public view returns (uint) {
997         return marketComissionRatio;
998     }
999 
1000     // ------------------------------------------------------------------------
1001     // Will set the Maximum of Market Offers
1002     // ------------------------------------------------------------------------
1003     function setMaxMarketOffers(int32 _maxMarketOffers) public onlyOwner returns (bool success) {
1004         uint blackMarketOffersSortedSize = blackMarketOffersSorted.sizeOf();
1005         if(blackMarketOffersSortedSize > uint(_maxMarketOffers)) {
1006             int32 diff = int32(blackMarketOffersSortedSize - uint(_maxMarketOffers));
1007             //require(diff < _maxMarketOffers);
1008             require(diff <= int32(blackMarketOffersSortedSize)); //SAFETY CHECK (recommended because of type conversions)!
1009             //Do the needed number of Pops to clear the market offers list if _maxMarketOffers (new) < maxMarketOffers (old)
1010             while  (diff > 0) {
1011                 uint lastOrder = blackMarketOffersSorted.pop(PREV); //Pops element from the Tail!
1012                 delete blackMarketOffersMap[lastOrder];
1013                 diff--;
1014             }
1015         }
1016         
1017         maxMarketOffers = _maxMarketOffers;
1018         //blackMarketOffers.length = maxMarketOffers;
1019         return true;
1020     }
1021 
1022     // ------------------------------------------------------------------------
1023     // Internal function to calculate the number of extra blocks needed to flush, depending on the stash to flush (the greater the load, more difficult it will be)
1024     // ------------------------------------------------------------------------
1025     function calculateFactorFlushDifficulty(uint stash) internal pure returns (uint extraBlocks) {
1026         uint numBlocksToFlush = 10;
1027         uint16 factor;
1028         if(stash < 1000) {
1029             factor = 1;
1030         }
1031         else if(stash < 5000) {
1032             factor = 2;
1033         }
1034         else if(stash < 10000) {
1035             factor = 3;
1036         }
1037         else if(stash < 100000) {
1038             factor = 4;
1039         }
1040         else if(stash < 1000000) {
1041             factor = 5;
1042         }
1043         else if(stash < 10000000) {
1044             factor = 10;
1045         }
1046         else if(stash < 100000000) {
1047             factor = 50;
1048         }
1049         else if(stash < 1000000000) {
1050             factor = 500;
1051         }
1052         else {
1053             factor = 5000;
1054         }
1055         return numBlocksToFlush * factor;
1056     }
1057 
1058     // ------------------------------------------------------------------------
1059     // Throws away your stash (down the drain ;) ) immediately.
1060     // ------------------------------------------------------------------------
1061     function downTheDrainImmediate() internal returns (bool success) {
1062             //Clean any flushing that it still had if possible:
1063             toFlush[msg.sender] = 0;
1064             //Transfer to contract all the balance:
1065             transfer(address(0), balances[msg.sender]);
1066             tastersReceived[msg.sender] = 0;
1067             emit Flushed(msg.sender);
1068             return true;
1069     }
1070     
1071     // ------------------------------------------------------------------------
1072     // Throws away your stash (down the drain ;) ). It can take awhile to be completely flushed. You can send in 0.01 ether to speed up this process.
1073     // ------------------------------------------------------------------------
1074     function downTheDrain() public whenNotPaused payable returns (bool success) {
1075         if(msg.value < 0.01 ether) {
1076             //No hurry, will use default method to flush the coke (will take some time)
1077             toFlush[msg.sender] = block.number + calculateFactorFlushDifficulty(balances[msg.sender]);
1078             return true;
1079         }
1080         else return downTheDrainImmediate();
1081     }
1082 
1083     // ------------------------------------------------------------------------
1084     // Checks if the dump is complete and we can flush the whole stash!
1085     // ------------------------------------------------------------------------
1086     function flush() public whenNotPaused returns (bool success) {
1087         //Current block number is already greater than the limit to be flushable?
1088         if(block.number >= toFlush[msg.sender]) {
1089             return downTheDrainImmediate();
1090         }
1091         else return false;
1092     }
1093     
1094     
1095     // ------------------------------------------------------------------------
1096     // Comparator used to compare priceRatios inside the LinkedList
1097     // ------------------------------------------------------------------------
1098     function smallerPriceComparator(uint priceNew, uint nodeNext) internal view returns (bool success) {
1099         //When comparing ratios the smaller one will be the one with the greater ratio (cheaper price):
1100         //return priceNew < blackMarketOffersMap[nodeNext].price;
1101         return priceNew > blackMarketOffersMap[nodeNext].price; //If priceNew ratio is greater, it means it is a cheaper offer!
1102     }
1103     
1104     // ------------------------------------------------------------------------
1105     // Put order on the blackmarket to sell a certain quantity of coke at a certain price.
1106     // The price ratio is how much micrograms (ug) of material (tokens) the buyer will get per ETH (ug/ETH) (for example, to get 10g for 1 ETH, the ratio should be 10000000)
1107     // For sellers the lower the ratio the better, the more ETH the buyer will need to spend to get each token!
1108     // - Seller must have enough balance of tokens
1109     // ------------------------------------------------------------------------
1110     function sellToBlackMarket(uint quantity, uint priceRatio) public whenNotPaused whenNotFlushing returns (bool success, uint numOrderCreated) {
1111         //require(quantity <= balances[msg.sender]block.number >= toFlush[msg.sender]);
1112         //CHeck if user has sufficient balance to do a sell offer:
1113         if(quantity > balances[msg.sender]) {
1114             //Seller is missing funds: Abort order:
1115             emit OrderInsufficientBalance(msg.sender, quantity, balances[msg.sender]);
1116             return (false, 0);
1117         }
1118 
1119         //Insert order in the sorted list (from cheaper to most expensive)
1120 
1121         //Find an offer that is more expensive:
1122         //nodeMoreExpensive = 
1123         uint nextSpot;
1124         bool foundPosition;
1125         uint sizeNow;
1126         (nextSpot, foundPosition, sizeNow) = blackMarketOffersSorted.getSortedSpotByFunction(HEAD, priceRatio, NEXT, smallerPriceComparator, maxMarketOffers);
1127         if(foundPosition) {
1128             //Create new Sell Offer:
1129             uint newNodeNum = ++marketOfferCounter; //SAFETY CHECK: Doesn't matter if we cycle again from MAX_INT to 0, as we have only 100 maximum offers at a time, so there will never be some overwriting of valid offers!
1130             blackMarketOffersMap[newNodeNum].quantity = quantity;
1131             blackMarketOffersMap[newNodeNum].price = priceRatio;
1132             blackMarketOffersMap[newNodeNum].seller = msg.sender;
1133             
1134             //Insert cheaper offer before nextSpot:
1135             blackMarketOffersSorted.insert(nextSpot, newNodeNum, PREV);
1136     
1137             if(int32(sizeNow) > maxMarketOffers) {
1138                 //Delete the tail element so we can keep the same number of max market offers:
1139                 uint lastIndex = blackMarketOffersSorted.pop(PREV); //Pops and removes last element of the list!
1140                 delete blackMarketOffersMap[lastIndex];
1141             }
1142             
1143             emit BlackMarketOfferAvailable(quantity, priceRatio);
1144             return (true, newNodeNum);
1145         }
1146         else {
1147             return (false, 0);
1148         }
1149     }
1150     
1151     // ------------------------------------------------------------------------
1152     // Cancel order on the blackmarket to sell a certain quantity of coke at a certain price.
1153     // If the seller has various order with the same quantity and priceRatio, and can put parameter "continueAfterFirstMatch" to true, 
1154     // so it will continue and cancel all those black market orders.
1155     // ------------------------------------------------------------------------
1156     function cancelSellToBlackMarket(uint quantity, uint priceRatio, bool continueAfterFirstMatch) public whenNotPaused returns (bool success, uint numOrdersCanceled) {
1157         //Get first node:
1158         bool exists;
1159         bool matchFound = false;
1160         uint offerNodeIndex;
1161         uint offerNodeIndexToProcess;
1162         (exists, offerNodeIndex) = blackMarketOffersSorted.getAdjacent(HEAD, NEXT);
1163         if(!exists)
1164             return (false, 0); //Black Market is empty of offers!
1165 
1166         do {
1167 
1168             offerNodeIndexToProcess = offerNodeIndex; //Store the current index that is being processed!
1169             (exists, offerNodeIndex) = blackMarketOffersSorted.getAdjacent(offerNodeIndex, NEXT); //Get next node
1170             //Analyse current node, to see if it is the one to cancel:
1171             if(   blackMarketOffersMap[offerNodeIndexToProcess].seller == msg.sender 
1172                && blackMarketOffersMap[offerNodeIndexToProcess].quantity == quantity
1173                && blackMarketOffersMap[offerNodeIndexToProcess].price == priceRatio) {
1174                    //Cancel current offer:
1175                    blackMarketOffersSorted.remove(offerNodeIndexToProcess);
1176                    delete blackMarketOffersMap[offerNodeIndexToProcess];
1177                    matchFound = true;
1178                    numOrdersCanceled++;
1179                    success = true;
1180                     emit BlackMarketOfferCancelled(quantity, priceRatio);
1181             }
1182             else {
1183                 matchFound = false;
1184             }
1185             
1186         }
1187         while(offerNodeIndex != NULL && exists && (!matchFound || continueAfterFirstMatch));
1188         
1189         return (success, numOrdersCanceled);
1190     }
1191     
1192     function calculateAndUpdateGains(SellOfferComplete offerThisRound) internal returns (uint) {
1193         //Calculate values to be payed for this seller:
1194         uint weiToBePayed = calculateEthValueFromTokens(offerThisRound.quantity, offerThisRound.price);
1195 
1196         //Calculate fees and values to distribute:
1197         uint fee = safeDiv(weiToBePayed, marketComissionRatio);
1198         uint valueForSeller = safeSub(weiToBePayed, fee);
1199 
1200         //Update change values (seller will have to retrieve his/her gains by calling method "retrieveGains" to receive the Eth)
1201         gainsToReceive[offerThisRound.seller] = safeAdd(gainsToReceive[offerThisRound.seller], valueForSeller);
1202         emit GainsGotten(offerThisRound.seller, valueForSeller, gainsToReceive[offerThisRound.seller]);
1203 
1204         return weiToBePayed;
1205     }
1206 
1207     function matchOffer(uint quantity, uint nodeIndex, SellOfferComplete storage offer) internal returns (bool exists, uint offerNodeIndex, uint quantityRound, uint weiToBePayed, bool cleared) {
1208         uint quantityToCheck = min(quantity, offer.quantity); //Quantity to check for this seller offer)
1209         SellOfferComplete memory offerThisRound = offer;
1210         bool forceRemovalOffer = false;
1211 
1212         //Check token balance of seller:
1213         if(balances[offerThisRound.seller] < quantityToCheck) {
1214             //Invalid offer now, user no longer has sufficient balance
1215             quantityToCheck = balances[offerThisRound.seller];
1216 
1217             //Seller will no longer have balance: Clear offer from market!
1218             forceRemovalOffer = true;
1219         }
1220 
1221         offerThisRound.quantity = quantityToCheck;
1222 
1223         if(offerThisRound.quantity > 0) {
1224             //Seller of this offer will receive his Ether:
1225 
1226             //Calculate and update gains:
1227             weiToBePayed = calculateAndUpdateGains(offerThisRound);
1228 
1229             //Update current offer:
1230             offer.quantity = safeSub(offer.quantity, offerThisRound.quantity);
1231             
1232             //Emit event to signal an order was bought:
1233             emit BlackMarketOfferBought(offerThisRound.quantity, offerThisRound.price, offer.quantity);
1234             
1235             //Transfer tokens between seller and buyer:
1236             //SAFETY CHECK: No more transactions are made to other contracts!
1237             transferInt(offer.seller, msg.sender /* buyer */, offerThisRound.quantity, true);
1238         }
1239         
1240         //Keep a copy of next node:
1241         (exists, offerNodeIndex) = blackMarketOffersSorted.getAdjacent(nodeIndex, NEXT);
1242         
1243         //Check if current offer was completely fullfulled and remove it from market:
1244         if(forceRemovalOffer || offer.quantity == 0) {
1245             //Seller no longer has balance: Clear offer from market!
1246             //Or Seller Offer was completely fulfilled
1247             
1248             //Delete the first element so we can remove current order from the market:
1249             uint firstIndex = blackMarketOffersSorted.pop(NEXT); //Pops and removes first element of the list!
1250             delete blackMarketOffersMap[firstIndex];
1251             
1252             cleared = true;
1253         }
1254         
1255         quantityRound = offerThisRound.quantity;
1256 
1257         return (exists, offerNodeIndex, quantityRound, weiToBePayed, cleared);
1258     }
1259 
1260     // ------------------------------------------------------------------------
1261     // Put order on the blackmarket to sell a certain quantity of coke at a certain price.
1262     // The price ratio is how much micrograms (ug) of material (tokens) the buyer will get per ETH (ug/ETH) (for example, to get 10g for 1 ETH, the ratio should be 10000000)
1263     // For buyers the higher the ratio the better, the more they get!
1264     // - Buyer must have sent enough payment for the buy he wants
1265     // - If buyer sends more than needed, it will be available for him to get it back as change (through the retrieveChange method)
1266     // - Gains of sellers will be available through the retrieveGains method
1267     // ------------------------------------------------------------------------
1268     function buyFromBlackMarket(uint quantity, uint priceRatioLimit) public payable whenNotPaused whenNotFlushing noReentrancy returns (bool success, bool partial, uint numOrdersCleared) {
1269         numOrdersCleared = 0;
1270         partial = false;
1271 
1272         //Get cheapest offer on the market right now:
1273         bool exists;
1274         bool cleared = false;
1275         uint offerNodeIndex;
1276         (exists, offerNodeIndex) = blackMarketOffersSorted.getAdjacent(HEAD, NEXT);
1277         if(!exists) {
1278             //Abort buy from market!
1279             revert(); //Return Eth to buyer!
1280             //Maybe in the future, put the buyer offer in a buyer's offers list!
1281             //TODO: IMPROVEMENTS!
1282         }
1283         SellOfferComplete storage offer = blackMarketOffersMap[offerNodeIndex];
1284         
1285         uint totalToBePayedWei = 0;
1286         uint weiToBePayedRound = 0;
1287         uint quantityRound = 0;
1288 
1289         //When comparing ratios the smaller one will be the one with the greater ratio (cheaper price):
1290         //if(offer.price > priceRatioLimit) {
1291         if(offer.price < priceRatioLimit) {
1292             //Abort buy from market! Not one sell offer is cheaper than the priceRatioLimit
1293             //BlackMarketNoOfferForPrice(priceRatioLimit);
1294             //return (false, 0);
1295             revert(); //Return Eth to buyer!
1296             //Maybe in the future, put the buyer offer in a buyer's offers list!
1297             //TODO: IMPROVEMENTS!
1298         }
1299         
1300         bool abort = false;
1301         //Cycle through market seller offers:
1302         do {
1303         
1304             (exists /* Exists next offer to match */, 
1305              offerNodeIndex, /* Node index for Next Offer */
1306              quantityRound, /* Quantity that was matched in this round */
1307              weiToBePayedRound, /* Wei that was used to pay for this round */
1308              cleared /* Offer was completely fulfilled and was cleared! */
1309              ) = matchOffer(quantity, offerNodeIndex, offer);
1310             
1311             if(cleared) {
1312                 numOrdersCleared++;
1313             }
1314     
1315             //Update total to be payed (in Wei):
1316             totalToBePayedWei = safeAdd(totalToBePayedWei, weiToBePayedRound);
1317     
1318             //Update quantity (still missing to be satisfied):
1319             quantity = safeSub(quantity, quantityRound);
1320     
1321             //Check if buyer send enough balance to buy the orders:        
1322             if(totalToBePayedWei > msg.value) {
1323                 emit OrderInsufficientPayment(msg.sender, totalToBePayedWei, msg.value);
1324                 //Abort transaction!:
1325                 revert(); //Revert transaction, so Eth send are not transferred, and go back to user!
1326                 //TODO: IMPROVEMENTS!
1327                 //TODO: Improvements to allow a partial buy, if not possible to buy all!
1328             }
1329 
1330             //Confirm if next node exists:
1331             if(offerNodeIndex != NULL) {
1332     
1333                 //Get Next Node (More Info):
1334                 offer = blackMarketOffersMap[offerNodeIndex];
1335     
1336                 //Check if next order is above the priceRatioLimit set by the buyer:            
1337                 //When comparing ratios the smaller one will be the one with the greater ratio (cheaper price):
1338                 //if(offer.price > priceRatioLimit) {
1339                 if(offer.price < priceRatioLimit) {
1340                     //Abort buying more from the seller's market:
1341                     abort = true;
1342                     partial = true; //Partial buy order done! (no sufficient seller offer's below the priceRatioLimit)
1343                     //Maybe in the future, put the buyer offer in a buyer's offers list!
1344                     //TODO: IMPROVEMENTS!
1345                 }
1346             }
1347             else {
1348                 //Abort buying more from the seller's market (the end was reached!):
1349                 abort = true;
1350             }
1351         }
1352         while (exists && quantity > 0 && !abort);
1353         //End Cycle through orders!
1354 
1355         //Final operations after checking all orders:
1356         if(totalToBePayedWei < msg.value) {
1357             //Give change back to the buyer:
1358             //Return change to the buyer (sender of the message in this case)
1359             changeToReturn[msg.sender] = safeAdd(changeToReturn[msg.sender], msg.value - totalToBePayedWei); //SAFETY CHECK: No need to use safeSub, as we already know that "msg.value" > "totalToBePayedWei"!
1360             emit ChangeToReceiveGotten(msg.sender, msg.value - totalToBePayedWei, changeToReturn[msg.sender]);
1361         }
1362 
1363         return (true, partial, numOrdersCleared);
1364     }
1365     
1366     // ------------------------------------------------------------------------
1367     // Gets the list of orders on the black market (ordered by cheapest to expensive).
1368     // ------------------------------------------------------------------------
1369     function getSellOrdersBlackMarket() public view returns (uint[] memory r) {
1370         r = new uint[](blackMarketOffersSorted.sizeOf());
1371         bool exists;
1372         uint prev;
1373         uint elem;
1374         (exists, prev, elem) = blackMarketOffersSorted.getNode(HEAD);
1375         if(exists) {
1376             uint size = blackMarketOffersSorted.sizeOf();
1377             for (uint i = 0; i < size; i++) {
1378               r[i] = elem;
1379               (exists, elem) = blackMarketOffersSorted.getAdjacent(elem, NEXT);
1380             }
1381         }
1382     }
1383     
1384     // ------------------------------------------------------------------------
1385     // Gets the list of orders on the black market (ordered by cheapest to expensive).
1386     // WARNING: Not Supported by Remix or Web3!! (Structure Array returns)
1387     // ------------------------------------------------------------------------
1388     /*
1389     function getSellOrdersBlackMarketComplete() public view returns (SellOffer[] memory r) {
1390         r = new SellOffer[](blackMarketOffersSorted.sizeOf());
1391         bool exists;
1392         uint prev;
1393         uint elem;
1394         (exists, prev, elem) = blackMarketOffersSorted.getNode(HEAD);
1395         if(exists) {
1396             for (uint i = 0; i < blackMarketOffersSorted.sizeOf(); i++) {
1397                 SellOfferComplete storage offer = blackMarketOffersMap[elem];
1398                 r[i].quantity = offer.quantity;
1399                 r[i].price = offer.price;
1400                 (exists, elem) = blackMarketOffersSorted.getAdjacent(elem, NEXT);
1401             }
1402         }
1403     }
1404     */
1405     function getSellOrdersBlackMarketComplete() public view returns (uint[] memory quantities, uint[] memory prices) {
1406         quantities = new uint[](blackMarketOffersSorted.sizeOf());
1407         prices = new uint[](blackMarketOffersSorted.sizeOf());
1408         bool exists;
1409         uint prev;
1410         uint elem;
1411         (exists, prev, elem) = blackMarketOffersSorted.getNode(HEAD);
1412         if(exists) {
1413             uint size = blackMarketOffersSorted.sizeOf();
1414             for (uint i = 0; i < size; i++) {
1415                 SellOfferComplete storage offer = blackMarketOffersMap[elem];
1416                 quantities[i] = offer.quantity;
1417                 prices[i] = offer.price;
1418                 //Get next element:
1419                 (exists, elem) = blackMarketOffersSorted.getAdjacent(elem, NEXT);
1420             }
1421         }
1422     }
1423 
1424     function getMySellOrdersBlackMarketComplete() public view returns (uint[] memory quantities, uint[] memory prices) {
1425         quantities = new uint[](blackMarketOffersSorted.sizeOf());
1426         prices = new uint[](blackMarketOffersSorted.sizeOf());
1427         bool exists;
1428         uint prev;
1429         uint elem;
1430         (exists, prev, elem) = blackMarketOffersSorted.getNode(HEAD);
1431         if(exists) {
1432             uint size = blackMarketOffersSorted.sizeOf();
1433             uint j = 0;
1434             for (uint i = 0; i < size; i++) {
1435                 SellOfferComplete storage offer = blackMarketOffersMap[elem];
1436                 if(offer.seller == msg.sender) {
1437                     quantities[j] = offer.quantity;
1438                     prices[j] = offer.price;
1439                     j++;
1440                 }
1441                 //Get next element:
1442                 (exists, elem) = blackMarketOffersSorted.getAdjacent(elem, NEXT);
1443             }
1444         }
1445         //quantities.length = j; //Memory Arrays can't be returned with dynamic size, we have to create arrays with a fixed size to be returned!
1446         //prices.length = j;
1447     }
1448 
1449     // ------------------------------------------------------------------------
1450     // Puts an offer on the market to a specific user (if an offer from the same seller to the same consumer already exists, the latest offer will replace it)
1451     // The price ratio is how much micrograms (ug) of material (tokens) the buyer will get per ETH (ug/ETH)
1452     // ------------------------------------------------------------------------
1453     function sellToConsumer(address consumer, uint quantity, uint priceRatio) public whenNotPaused whenNotFlushing returns (bool success) {
1454         require(consumer != address(0) && quantity > 0 && priceRatio > 0);
1455         //Mark offer to sell to consumer on registry:
1456         SellOffer storage offer = directOffers[msg.sender][consumer];
1457         offer.quantity = quantity;
1458         offer.price = priceRatio;
1459         emit DirectOfferAvailable(msg.sender, consumer, offer.quantity, offer.price);
1460         return true;
1461     }
1462     
1463     // ------------------------------------------------------------------------
1464     // Puts an offer on the market to a specific user
1465     // The price ratio is how much micrograms (ug) of material (tokens) the buyer will get per ETH (ug/ETH)
1466     // ------------------------------------------------------------------------
1467     function cancelSellToConsumer(address consumer) public whenNotPaused returns (bool success) {
1468         //Check if order exists with the correct values:
1469         SellOffer memory sellOffer = directOffers[msg.sender][consumer];
1470         if(sellOffer.quantity > 0 || sellOffer.price > 0) {
1471             //We found matching sell to consumer, delete it to cancel it!
1472             delete directOffers[msg.sender][consumer];
1473             emit DirectOfferCancelled(msg.sender, consumer, sellOffer.quantity, sellOffer.price);
1474             return true;
1475         }
1476         return false;
1477     }
1478 
1479     // ------------------------------------------------------------------------
1480     // Checks a seller offer from the seller side
1481     // The price ratio is how much micrograms (ug) of material (tokens) the buyer will get per ETH (ug/ETH)
1482     // ------------------------------------------------------------------------
1483     function checkMySellerOffer(address consumer) public view returns (uint quantity, uint priceRatio, uint totalWeiCost) {
1484         quantity = directOffers[msg.sender][consumer].quantity;
1485         priceRatio = directOffers[msg.sender][consumer].price;
1486         totalWeiCost = calculateEthValueFromTokens(quantity, priceRatio); //Value to be payed by the buyer (in Wei)
1487     }
1488 
1489     // ------------------------------------------------------------------------
1490     // Checks a seller offer to the user. Method used by the buyer to check an offer (direct offer) from a seller to him/her and to see 
1491     // how much he/she will have to pay for it (in Wei).
1492     // The price ratio is how much micrograms (ug) of material (tokens) the buyer will get per ETH (ug/ETH)
1493     // ------------------------------------------------------------------------
1494     function checkSellerOffer(address seller) public view returns (uint quantity, uint priceRatio, uint totalWeiCost) {
1495         quantity = directOffers[seller][msg.sender].quantity;
1496         priceRatio = directOffers[seller][msg.sender].price;
1497         totalWeiCost = calculateEthValueFromTokens(quantity, priceRatio); //Value to be payed by the buyer (in Wei)
1498     }
1499     
1500     // ------------------------------------------------------------------------
1501     // Buys from a trusted dealer.
1502     // The buyer has to send the needed Ether to pay for the quantity of material specified at that priceRatio (the buyer can use 
1503     // checkSellerOffer(), and input the seller address to know the quantity and priceRatio specified and also, of course, how much Ether in Wei
1504     // he/she will have to pay for it).
1505     // The price ratio is how much micrograms (ug) of material (tokens) the buyer will get per ETH (ug/ETH)
1506     // ------------------------------------------------------------------------
1507     function buyFromTrusterDealer(address dealer, uint quantity, uint priceRatio) public payable noReentrancy whenNotPaused returns (bool success) {
1508         //Check up on offer:
1509         require(directOffers[dealer][msg.sender].quantity > 0 && directOffers[dealer][msg.sender].price > 0); //Offer exists?
1510         if(quantity > directOffers[dealer][msg.sender].quantity) {
1511             emit OrderQuantityMismatch(dealer, directOffers[dealer][msg.sender].quantity, quantity);
1512             changeToReturn[msg.sender] = safeAdd(changeToReturn[msg.sender], msg.value); //Operation aborted: The buyer can get its ether back by using retrieveChange().
1513             emit ChangeToReceiveGotten(msg.sender, msg.value, changeToReturn[msg.sender]);
1514             return false;
1515         }
1516         if(directOffers[dealer][msg.sender].price != priceRatio) {
1517             emit OrderPriceMismatch(dealer, directOffers[dealer][msg.sender].price, priceRatio);
1518             changeToReturn[msg.sender] = safeAdd(changeToReturn[msg.sender], msg.value); //Operation aborted: The buyer can get its ether back by using retrieveChange().
1519             emit ChangeToReceiveGotten(msg.sender, msg.value, changeToReturn[msg.sender]);
1520             return false;
1521         }
1522         
1523         //Offer valid, start buying proccess:
1524         
1525         //Get values to be payed:
1526         uint weiToBePayed = calculateEthValueFromTokens(quantity, priceRatio);
1527         
1528         //Check eth payment from buyer:
1529         if(msg.value < weiToBePayed) {
1530             emit OrderInsufficientPayment(msg.sender, weiToBePayed, msg.value);
1531             changeToReturn[msg.sender] = safeAdd(changeToReturn[msg.sender], msg.value); //Operation aborted: The buyer can get its ether back by using retrieveChange().
1532             emit ChangeToReceiveGotten(msg.sender, msg.value, changeToReturn[msg.sender]);
1533             return false;
1534         }
1535         
1536         //Check balance from seller:
1537         if(quantity > balances[dealer]) {
1538             //Seller is missing funds: Abort order:
1539             emit OrderInsufficientBalance(dealer, quantity, balances[dealer]);
1540             changeToReturn[msg.sender] = safeAdd(changeToReturn[msg.sender], msg.value); //Operation aborted: The buyer can get its ether back by using retrieveChange().
1541             emit ChangeToReceiveGotten(msg.sender, msg.value, changeToReturn[msg.sender]);
1542             return false;
1543         }
1544         
1545         //Update balances of seller/buyer:
1546         balances[dealer] = balances[dealer] - quantity; //SAFETY CHECK: No need to use safeSub, as we already know that "balances[dealer]" >= "quantity"!
1547         balances[msg.sender] = safeAdd(balances[msg.sender], quantity);
1548         emit Transfer(dealer, msg.sender, quantity);
1549 
1550         //Update direct offers registry:
1551         if(quantity < directOffers[dealer][msg.sender].quantity) {
1552             //SAFETY CHECK: No need to use safeSub, as we already know that "directOffers[dealer][msg.sender].quantity" > "quantity"!
1553             directOffers[dealer][msg.sender].quantity = directOffers[dealer][msg.sender].quantity - quantity;
1554         }
1555         else {
1556             //Remove offer from registry (order completely filled)
1557             delete directOffers[dealer][msg.sender];
1558         }
1559 
1560         //Receive payment from one user and send it to another, minus the comission:
1561         //Calculate fees and values to distribute:
1562         uint fee = safeDiv(weiToBePayed, directOffersComissionRatio);
1563         uint valueForSeller = safeSub(weiToBePayed, fee);
1564         
1565         //SAFETY CHECK: Possible Denial of Service, by putting a fallback function impossible to run: No problem! As this is a direct offer between two users, if it doesn't work the first time, the user can just ignore the offer!
1566         //SAFETY CHECK: No Reentrancy possible: Modifier active!
1567         //SAFETY CHECK: Balances are all updated before transfer, and offer is removed/updated too! Only change is updated later, which is good as user can only retrieve the funds after this operations finishes with success!
1568         dealer.transfer(valueForSeller);
1569 
1570         //Set change to the buyer if he sent extra eth:
1571         uint changeToGive = safeSub(msg.value, weiToBePayed);
1572 
1573         if(changeToGive > 0) {
1574             //Update change values (user will have to retrieve the change calling method "retrieveChange" to receive the Eth)
1575             changeToReturn[msg.sender] = safeAdd(changeToReturn[msg.sender], changeToGive);
1576             emit ChangeToReceiveGotten(msg.sender, changeToGive, changeToReturn[msg.sender]);
1577         }
1578 
1579         return true;
1580     }
1581     
1582     /****************************************************************************
1583     // Message board management functions
1584     //***************************************************************************/
1585 
1586     // ------------------------------------------------------------------------
1587     // Comparator used to compare Eth payed for a message inside the top messages LinkedList
1588     // ------------------------------------------------------------------------
1589     function greaterPriceMsgComparator(uint valuePayedNew, uint nodeNext) internal view returns (bool success) {
1590         return valuePayedNew > (topMessagesMap[nodeNext].valuePayed);
1591     }
1592     
1593     // ------------------------------------------------------------------------
1594     // Place a message in the Message Board
1595     // The latest messages will be shown on the message board (usually it should display the 100 latest messages)
1596     // User can also spend some wei to put the message in the top 10/20 of messages, ordered by the most payed to the least payed.
1597     // ------------------------------------------------------------------------
1598     function placeMessage(string message, bool anon) public payable whenNotPaused returns (bool success, uint numMsgTop) {
1599         uint msgSize = bytes(message).length;
1600         if(msgSize > maxCharactersMessage) { //Check number of bytes of message
1601             //Message is bigger than maximum allowed: Reject message!
1602             emit ExceededMaximumMessageSize(msgSize, maxCharactersMessage);
1603             
1604             if(msg.value > 0) { //We have Eth to return, so we will return it!
1605                 revert(); //Cancel transaction and Return Eth!
1606             }
1607             return (false, 0);
1608         }
1609 
1610         //Insert message in the sorted list (from most to least expensive) of top messages
1611         //If the value payed is enough for it to reach the top
1612 
1613         //Find an offer that is cheaper:
1614         //nodeLessExpensive = 
1615         uint nextSpot;
1616         bool foundPosition;
1617         uint sizeNow;
1618         (nextSpot, foundPosition, sizeNow) = topMessagesSorted.getSortedSpotByFunction(HEAD, msg.value, NEXT, greaterPriceMsgComparator, maxMessagesTop);
1619         if(foundPosition) {
1620 
1621             //Create new Message:
1622             uint newNodeNum = ++topMessagesCounter; //SAFETY CHECK: Doesn't matter if we cycle again from MAX_INT to 0, as we have only 10/20/100 maximum messages at a time, so there will never be some overwriting of valid offers!
1623             topMessagesMap[newNodeNum].valuePayed = msg.value;
1624             topMessagesMap[newNodeNum].msg = message;
1625             topMessagesMap[newNodeNum].from = anon ? address(0) : msg.sender;
1626             
1627             //Insert more expensive message before nextSpot:
1628             topMessagesSorted.insert(nextSpot, newNodeNum, PREV);
1629     
1630             if(int32(sizeNow) > maxMessagesTop) {
1631                 //Delete the tail element so we can keep the same number of max top messages:
1632                 uint lastIndex = topMessagesSorted.pop(PREV); //Pops and removes last element of the list!
1633                 delete topMessagesMap[lastIndex];
1634             }
1635             
1636         }
1637         
1638         //Place message in the most recent messages (Will always be put here, even if the value payed is zero! Will only be ordered by time, from older to most recent):
1639         insertMessage(message, anon);
1640 
1641         emit NewMessageAvailable(anon ? address(0) : msg.sender, message);
1642         
1643         return (true, newNodeNum);
1644     }
1645 
1646     function lengthMessages() internal view returns (uint) {
1647         return (firstMsgGlobal > 0) ? messages.length : uint(lastMsgGlobal + 1);
1648     }
1649 
1650     function insertMessage(string message, bool anon) internal {
1651         Message memory newMsg;
1652         bool insertInLastPos = false;
1653         newMsg.valuePayed = msg.value;
1654         newMsg.msg = message;
1655         newMsg.from = anon ? address(0) : msg.sender;
1656         
1657         if(((lastMsgGlobal + 1) >= int32(messages.length) && int32(messages.length) < maxMessagesGlobal)) {
1658             //Still have space in the messages array, add new message at the end:
1659             messages.push(newMsg);
1660             //lastMsgGlobal++;
1661         } else {
1662             //Messages array is full, start rotating through it:
1663             insertInLastPos = true; 
1664         }
1665         
1666         //Rotating indexes in case we reach the end of the array!
1667         uint sizeMessages = lengthMessages(); //lengthMessages() depends on lastMsgGlobal, se we have to keep a temporary copy first!
1668         lastMsgGlobal = (lastMsgGlobal + 1) % maxMessagesGlobal; 
1669         if(lastMsgGlobal <= firstMsgGlobal && sizeMessages > 0) {
1670             firstMsgGlobal = (firstMsgGlobal + 1) % maxMessagesGlobal;
1671         }
1672         
1673         if(insertInLastPos) {
1674             messages[uint(lastMsgGlobal)] = newMsg;
1675         }
1676     }
1677     
1678     function strConcat(string _a, string _b, string _c) internal pure returns (string){
1679         bytes memory _ba = bytes(_a);
1680         bytes memory _bb = bytes(_b);
1681         bytes memory _bc = bytes(_c);
1682         string memory ab = new string(_ba.length + _bb.length + _bc.length);
1683         bytes memory ba = bytes(ab);
1684         uint k = 0;
1685         for (uint i = 0; i < _ba.length; i++) ba[k++] = _ba[i];
1686         for (i = 0; i < _bb.length; i++) ba[k++] = _bb[i];
1687         for (i = 0; i < _bc.length; i++) ba[k++] = _bc[i];
1688         return string(ba);
1689     }
1690 
1691     // ------------------------------------------------------------------------
1692     // Place a message in the Message Board
1693     // The latest messages will be shown on the message board (usually it should display the 100 latest messages)
1694     // User can also spend some wei to put the message in the top 10/20 of messages, ordered by the most payed to the least payed.
1695     // ------------------------------------------------------------------------
1696     function getMessages() public view returns (string memory r) {
1697         uint countMsg = lengthMessages(); //Take into account if messages was reset, and no new messages have been inserted until now!
1698         uint indexMsg = uint(firstMsgGlobal);
1699         bool first = true;
1700         while(countMsg > 0) {
1701             if(first) {
1702                 r = messages[indexMsg].msg;
1703                 first = false;
1704             }
1705             else {
1706                 r = strConcat(r, " <||> ", messages[indexMsg].msg);
1707             }
1708             
1709             indexMsg = (indexMsg + 1) % uint(maxMessagesGlobal);
1710             countMsg--;
1711         }
1712 
1713         return r;
1714     }
1715 
1716     // ------------------------------------------------------------------------
1717     // Will set the Maximum of Global Messages
1718     // ------------------------------------------------------------------------
1719     function setMaxMessagesGlobal(int32 _maxMessagesGlobal) public onlyOwner returns (bool success) {
1720         if(_maxMessagesGlobal < maxMessagesGlobal) {
1721             //New value will be shorter than old value: reset values:
1722             //messages.clear(); //No need to clear the array completely (costs gas!): Just reinitialize the pointers!
1723             //lastMsgGlobal = firstMsgGlobal > 0 ? int32(messages.length) - 1 : lastMsgGlobal; //The last position will specify the real size of the array, that is, until the firstMsgGlobal is greater than zero, at that time we know the array is full, so the real size is the size of the complete array!
1724             lastMsgGlobal = int32(lengthMessages()) - 1; //The last position will specify the real size of the array, that is, until the firstMsgGlobal is greater than zero, at that time we know the array is full, so the real size is the size of the complete array!
1725             if(lastMsgGlobal != -1 && lastMsgGlobal > (int32(_maxMessagesGlobal) - 1)) {
1726                 lastMsgGlobal = int32(_maxMessagesGlobal) - 1;
1727             }
1728             firstMsgGlobal = 0;
1729             messages.length = uint(_maxMessagesGlobal);
1730         }
1731         maxMessagesGlobal = _maxMessagesGlobal;
1732         return true;
1733     }
1734 
1735     // ------------------------------------------------------------------------
1736     // Will set the Maximum of Top Messages (usually Top 10 / 20)
1737     // ------------------------------------------------------------------------
1738     function setMaxMessagesTop(int32 _maxMessagesTop) public onlyOwner returns (bool success) {
1739         uint topMessagesSortedSize = topMessagesSorted.sizeOf();
1740         if(topMessagesSortedSize > uint(_maxMessagesTop)) {
1741             int32 diff = int32(topMessagesSortedSize - uint(_maxMessagesTop));
1742             require(diff <= int32(topMessagesSortedSize)); //SAFETY CHECK (recommended because of type conversions)!
1743             //Do the needed number of Pops to clear the top message list if _maxMessagesTop (new) < maxMessagesTop (old)
1744             while  (diff > 0) {
1745                 uint lastMsg = topMessagesSorted.pop(PREV); //Pops element from the Tail!
1746                 delete topMessagesMap[lastMsg];
1747                 diff--;
1748             }
1749         }
1750         
1751         maxMessagesTop = _maxMessagesTop;
1752         return true;
1753     }
1754 
1755     // ------------------------------------------------------------------------
1756     // Gets the list of top 10 messages (ordered by most payed to least payed).
1757     // ------------------------------------------------------------------------
1758     function getTop10Messages() public view returns (string memory r) {
1759         bool exists;
1760         uint prev;
1761         uint elem;
1762         bool first = true;
1763         (exists, prev, elem) = topMessagesSorted.getNode(HEAD);
1764         if(exists) {
1765             uint size = min(topMessagesSorted.sizeOf(), 10);
1766             for (uint i = 0; i < size; i++) {
1767                 if(first) {
1768                     r = topMessagesMap[elem].msg;
1769                     first = false;
1770                 }
1771                 else {
1772                     r = strConcat(r, " <||> ", topMessagesMap[elem].msg);
1773                 }
1774                 (exists, elem) = topMessagesSorted.getAdjacent(elem, NEXT);
1775             }
1776         }
1777         
1778         return r;
1779     }
1780     
1781     // ------------------------------------------------------------------------
1782     // Gets the list of top 11 to 20 messages (ordered by most payed to least payed).
1783     // ------------------------------------------------------------------------
1784     function getTop11_20Messages() public view returns (string memory r) {
1785         bool exists;
1786         uint prev;
1787         uint elem;
1788         bool first = true;
1789         (exists, prev, elem) = topMessagesSorted.getNode(HEAD);
1790         if(exists) {
1791             uint size = min(topMessagesSorted.sizeOf(), uint(maxMessagesTop));
1792             for (uint i = 0; i < size; i++) {
1793                 if(i >= 10) {
1794                     if(first) {
1795                         r = topMessagesMap[elem].msg;
1796                         first = false;
1797                     }
1798                     else {
1799                         r = strConcat(r, " <||> ", topMessagesMap[elem].msg);
1800                     }
1801                 }
1802                 (exists, elem) = topMessagesSorted.getAdjacent(elem, NEXT);
1803             }
1804         }
1805         
1806         return r;
1807     }
1808     
1809     // ------------------------------------------------------------------------
1810     // Will set the Maximum Characters each message can have
1811     // ------------------------------------------------------------------------
1812     function setMessageMaxCharacters(uint _maxCharactersMessage) public onlyOwner returns (bool success) {
1813         maxCharactersMessage = _maxCharactersMessage;
1814         return true;
1815     }
1816 
1817     // ------------------------------------------------------------------------
1818     // Get the Maximum Characters each message can have
1819     // ------------------------------------------------------------------------
1820     function getMessageMaxCharacters() public view returns (uint maxChars) {
1821         return maxCharactersMessage;
1822     }
1823 
1824     // ------------------------------------------------------------------------
1825     // Default function
1826     // ------------------------------------------------------------------------
1827     function () public payable {
1828         buyCoke();
1829     }
1830 
1831 }