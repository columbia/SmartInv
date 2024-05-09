1 pragma solidity ^0.4.24;
2 
3 /**
4  * This utility library was forked from https://github.com/o0ragman0o/LibCLL
5  */
6 library LinkedListLib {
7 
8     uint256 constant NULL = 0;
9     uint256 constant HEAD = 0;
10     bool constant PREV = false;
11     bool constant NEXT = true;
12 
13     struct LinkedList {
14         mapping (uint256 => mapping (bool => uint256)) list;
15         uint256 length;
16         uint256 index;
17     }
18 
19     /**
20      * @dev returns true if the list exists
21      * @param self stored linked list from contract
22      */
23     function listExists(LinkedList storage self)
24         internal
25         view returns (bool) {
26         return self.length > 0;
27     }
28 
29     /**
30      * @dev returns true if the node exists
31      * @param self stored linked list from contract
32      * @param _node a node to search for
33      */
34     function nodeExists(LinkedList storage self, uint256 _node)
35         internal
36         view returns (bool) {
37         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
38             if (self.list[HEAD][NEXT] == _node) {
39                 return true;
40             } else {
41                 return false;
42             }
43         } else {
44             return true;
45         }
46     }
47 
48     /**
49      * @dev Returns the number of elements in the list
50      * @param self stored linked list from contract
51      */ 
52     function sizeOf(LinkedList storage self) 
53         internal 
54         view 
55         returns (uint256 numElements) {
56         return self.length;
57     }
58 
59     /**
60      * @dev Returns the links of a node as a tuple
61      * @param self stored linked list from contract
62      * @param _node id of the node to get
63      */
64     function getNode(LinkedList storage self, uint256 _node)
65         public 
66         view 
67         returns (bool, uint256, uint256) {
68         if (!nodeExists(self,_node)) {
69             return (false, 0, 0);
70         } else {
71             return (true, self.list[_node][PREV], self.list[_node][NEXT]);
72         }
73     }
74 
75     /**
76      * @dev Returns the link of a node `_node` in direction `_direction`.
77      * @param self stored linked list from contract
78      * @param _node id of the node to step from
79      * @param _direction direction to step in
80      */
81     function getAdjacent(LinkedList storage self, uint256 _node, bool _direction)
82         public 
83         view 
84         returns (bool, uint256) {
85         if (!nodeExists(self,_node)) {
86             return (false,0);
87         } else {
88             return (true,self.list[_node][_direction]);
89         }
90     }
91 
92     /**
93      * @dev Can be used before `insert` to build an ordered list
94      * @param self stored linked list from contract
95      * @param _node an existing node to search from, e.g. HEAD.
96      * @param _value value to seek
97      * @param _direction direction to seek in
98      * @return next first node beyond '_node' in direction `_direction`
99      */
100     function getSortedSpot(LinkedList storage self, uint256 _node, uint256 _value, bool _direction)
101         public 
102         view 
103         returns (uint256) {
104         if (sizeOf(self) == 0) { 
105             return 0; 
106         }
107         require((_node == 0) || nodeExists(self,_node));
108         bool exists;
109         uint256 next;
110         (exists,next) = getAdjacent(self, _node, _direction);
111         while  ((next != 0) && (_value != next) && ((_value < next) != _direction)) next = self.list[next][_direction];
112         return next;
113     }
114 
115     /**
116      * @dev Creates a bidirectional link between two nodes on direction `_direction`
117      * @param self stored linked list from contract
118      * @param _node first node for linking
119      * @param _link  node to link to in the _direction
120      */
121     function createLink(LinkedList storage self, uint256 _node, uint256 _link, bool _direction) 
122         private {
123         self.list[_link][!_direction] = _node;
124         self.list[_node][_direction] = _link;
125     }
126 
127     /**
128      * @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
129      * @param self stored linked list from contract
130      * @param _node existing node
131      * @param _new  new node to insert
132      * @param _direction direction to insert node in
133      */
134     function insert(LinkedList storage self, uint256 _node, uint256 _new, bool _direction) 
135         internal 
136         returns (bool) {
137         if(!nodeExists(self,_new) && nodeExists(self,_node)) {
138             uint256 c = self.list[_node][_direction];
139             createLink(self, _node, _new, _direction);
140             createLink(self, _new, c, _direction);
141             self.length++;
142             return true;
143         } else {
144             return false;
145         }
146     }
147 
148     /**
149      * @dev removes an entry from the linked list
150      * @param self stored linked list from contract
151      * @param _node node to remove from the list
152      */
153     function remove(LinkedList storage self, uint256 _node) 
154         internal 
155         returns (uint256) {
156         if ((_node == NULL) || (!nodeExists(self,_node))) { 
157             return 0; 
158         }
159         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
160         delete self.list[_node][PREV];
161         delete self.list[_node][NEXT];
162         self.length--;
163         return _node;
164     }
165 
166     /**
167      * @dev pushes an enrty to the head of the linked list
168      * @param self stored linked list from contract
169      * @param _index The node Id
170      * @param _direction push to the head (NEXT) or tail (PREV)
171      */
172     function add(LinkedList storage self, uint256 _index, bool _direction) 
173         internal 
174         returns (uint256) {
175         insert(self, HEAD, _index, _direction);
176         return self.index;
177     }
178 
179     /**
180      * @dev pushes an enrty to the head of the linked list
181      * @param self stored linked list from contract
182      * @param _direction push to the head (NEXT) or tail (PREV)
183      */
184     function push(LinkedList storage self, bool _direction) 
185         internal 
186         returns (uint256) {
187         self.index++;
188         insert(self, HEAD, self.index, _direction);
189         return self.index;
190     }
191 
192     /**
193      * @dev pops the first entry from the linked list
194      * @param self stored linked list from contract
195      * @param _direction pop from the head (NEXT) or the tail (PREV)
196      */
197     function pop(LinkedList storage self, bool _direction) 
198         internal 
199         returns (uint256) {
200         bool exists;
201         uint256 adj;
202         (exists,adj) = getAdjacent(self, HEAD, _direction);
203         return remove(self, adj);
204     }
205 }
206 
207 
208 /**
209  * Owned contract
210  */
211 contract Owned {
212     address public owner;
213     address public newOwner;
214 
215     event OwnershipTransferred(address indexed from, address indexed to);
216 
217     /**
218      * Constructor
219      */
220     constructor() public {
221         owner = msg.sender;
222     }
223 
224     /**
225      * @dev Only the owner of contract
226      */ 
227     modifier onlyOwner {
228         require(msg.sender == owner);
229         _;
230     }
231     
232     /**
233      * @dev transfer the ownership to other
234      *      - Only the owner can operate
235      */ 
236     function transferOwnership(address _newOwner) public onlyOwner {
237         newOwner = _newOwner;
238     }
239 
240     /** 
241      * @dev Accept the ownership from last owner
242      */ 
243     function acceptOwnership() public {
244         require(msg.sender == newOwner);
245         emit OwnershipTransferred(owner, newOwner);
246         owner = newOwner;
247         newOwner = address(0);
248     }
249 }
250 
251 contract TripioToken {
252     string public name;
253     string public symbol;
254     uint8 public decimals;
255     function transfer(address _to, uint256 _value) public returns (bool);
256     function balanceOf(address who) public view returns (uint256);
257     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
258 }
259 
260 contract TripioRoomNightData is Owned {
261     using LinkedListLib for LinkedListLib.LinkedList;
262     // Interface signature of erc165.
263     // bytes4(keccak256("supportsInterface(bytes4)"))
264     bytes4 constant public interfaceSignature_ERC165 = 0x01ffc9a7;
265 
266     // Interface signature of erc721 metadata.
267     // bytes4(keccak256("name()")) ^ bytes4(keccak256("symbol()")) ^ bytes4(keccak256("tokenURI(uint256)"));
268     bytes4 constant public interfaceSignature_ERC721Metadata = 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd;
269         
270     // Interface signature of erc721.
271     // bytes4(keccak256("balanceOf(address)")) ^
272     // bytes4(keccak256("ownerOf(uint256)")) ^
273     // bytes4(keccak256("safeTransferFrom(address,address,uint256,bytes)")) ^
274     // bytes4(keccak256("safeTransferFrom(address,address,uint256)")) ^
275     // bytes4(keccak256("transferFrom(address,address,uint256)")) ^
276     // bytes4(keccak256("approve(address,uint256)")) ^
277     // bytes4(keccak256("setApprovalForAll(address,bool)")) ^
278     // bytes4(keccak256("getApproved(uint256)")) ^
279     // bytes4(keccak256("isApprovedForAll(address,address)"));
280     bytes4 constant public interfaceSignature_ERC721 = 0x70a08231 ^ 0x6352211e ^ 0xb88d4fde ^ 0x42842e0e ^ 0x23b872dd ^ 0x095ea7b3 ^ 0xa22cb465 ^ 0x081812fc ^ 0xe985e9c5;
281 
282     // Base URI of token asset
283     string public tokenBaseURI;
284 
285     // Authorized contracts
286     struct AuthorizedContract {
287         string name;
288         address acontract;
289     }
290     mapping (address=>uint256) public authorizedContractIds;
291     mapping (uint256 => AuthorizedContract) public authorizedContracts;
292     LinkedListLib.LinkedList public authorizedContractList = LinkedListLib.LinkedList(0, 0);
293 
294     // Rate plan prices
295     struct Price {
296         uint16 inventory;       // Rate plan inventory
297         bool init;              // Whether the price is initied
298         mapping (uint256 => uint256) tokens;
299     }
300 
301     // Vendor hotel RPs
302     struct RatePlan {
303         string name;            // Name of rate plan.
304         uint256 timestamp;      // Create timestamp.
305         bytes32 ipfs;           // The address of rate plan detail on IPFS.
306         Price basePrice;        // The base price of rate plan
307         mapping (uint256 => Price) prices;   // date -> Price
308     }
309 
310     // Vendors
311     struct Vendor {
312         string name;            // Name of vendor.
313         address vendor;         // Address of vendor.
314         uint256 timestamp;      // Create timestamp.
315         bool valid;             // Whether the vendor is valid(default is true)
316         LinkedListLib.LinkedList ratePlanList;
317         mapping (uint256=>RatePlan) ratePlans;
318     }
319     mapping (address => uint256) public vendorIds;
320     mapping (uint256 => Vendor) vendors;
321     LinkedListLib.LinkedList public vendorList = LinkedListLib.LinkedList(0, 0);
322 
323     // Supported digital currencies
324     mapping (uint256 => address) public tokenIndexToAddress;
325     LinkedListLib.LinkedList public tokenList = LinkedListLib.LinkedList(0, 0);
326 
327     // RoomNight tokens
328     struct RoomNight {
329         uint256 vendorId;
330         uint256 rpid;
331         uint256 token;          // The digital currency token 
332         uint256 price;          // The digital currency price
333         uint256 timestamp;      // Create timestamp.
334         uint256 date;           // The checkin date
335         bytes32 ipfs;           // The address of rate plan detail on IPFS.
336     }
337     RoomNight[] public roomnights;
338     // rnid -> owner
339     mapping (uint256 => address) public roomNightIndexToOwner;
340 
341     // Owner Account
342     mapping (address => LinkedListLib.LinkedList) public roomNightOwners;
343 
344     // Vendor Account
345     mapping (address => LinkedListLib.LinkedList) public roomNightVendors;
346 
347     // The authorized address for each TRN
348     mapping (uint256 => address) public roomNightApprovals;
349 
350     // The authorized operators for each address
351     mapping (address => mapping (address => bool)) public operatorApprovals;
352 
353     // The applications of room night redund
354     mapping (address => mapping (uint256 => bool)) public refundApplications;
355 
356     // The signature of `onERC721Received(address,uint256,bytes)`
357     // bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
358     bytes4 constant public ERC721_RECEIVED = 0xf0b9e5ba;
359 
360     /**
361      * This emits when contract authorized
362      */
363     event ContractAuthorized(address _contract);
364 
365     /**
366      * This emits when contract deauthorized
367      */
368     event ContractDeauthorized(address _contract);
369 
370     /**
371      * The contract is valid
372      */
373     modifier authorizedContractValid(address _contract) {
374         require(authorizedContractIds[_contract] > 0);
375         _;
376     }
377 
378     /**
379      * The contract is valid
380      */
381     modifier authorizedContractIdValid(uint256 _cid) {
382         require(authorizedContractList.nodeExists(_cid));
383         _;
384     }
385 
386     /**
387      * Only the owner or authorized contract is valid
388      */
389     modifier onlyOwnerOrAuthorizedContract {
390         require(msg.sender == owner || authorizedContractIds[msg.sender] > 0);
391         _;
392     }
393 
394     /**
395      * Constructor
396      */
397     constructor() public {
398         // Add one invalid RoomNight, avoid subscript 0
399         roomnights.push(RoomNight(0, 0, 0, 0, 0, 0, 0));
400     }
401 
402     /**
403      * @dev Returns the node list and next node as a tuple
404      * @param self stored linked list from contract
405      * @param _node the begin id of the node to get
406      * @param _limit the total nodes of one page
407      * @param _direction direction to step in
408      */
409     function getNodes(LinkedListLib.LinkedList storage self, uint256 _node, uint256 _limit, bool _direction) 
410         private
411         view 
412         returns (uint256[], uint256) {
413         bool exists;
414         uint256 i = 0;
415         uint256 ei = 0;
416         uint256 index = 0;
417         uint256 count = _limit;
418         if(count > self.length) {
419             count = self.length;
420         }
421         (exists, i) = self.getAdjacent(_node, _direction);
422         if(!exists || count == 0) {
423             return (new uint256[](0), 0);
424         }else {
425             uint256[] memory temp = new uint256[](count);
426             if(_node != 0) {
427                 index++;
428                 temp[0] = _node;
429             }
430             while (i != 0 && index < count) {
431                 temp[index] = i;
432                 (exists,i) = self.getAdjacent(i, _direction);
433                 index++;
434             }
435             ei = i;
436             if(index < count) {
437                 uint256[] memory result = new uint256[](index);
438                 for(i = 0; i < index; i++) {
439                     result[i] = temp[i];
440                 }
441                 return (result, ei);
442             }else {
443                 return (temp, ei);
444             }
445         }
446     }
447 
448     /**
449      * @dev Authorize `_contract` to execute this contract's funs
450      * @param _contract The contract address
451      * @param _name The contract name
452      */
453     function authorizeContract(address _contract, string _name) 
454         public 
455         onlyOwner 
456         returns(bool) {
457         uint256 codeSize;
458         assembly { codeSize := extcodesize(_contract) }
459         require(codeSize != 0);
460         // Not exists
461         require(authorizedContractIds[_contract] == 0);
462 
463         // Add
464         uint256 id = authorizedContractList.push(false);
465         authorizedContractIds[_contract] = id;
466         authorizedContracts[id] = AuthorizedContract(_name, _contract);
467 
468         // Event
469         emit ContractAuthorized(_contract);
470         return true;
471     }
472 
473     /**
474      * @dev Deauthorized `_contract` by address
475      * @param _contract The contract address
476      */
477     function deauthorizeContract(address _contract) 
478         public 
479         onlyOwner
480         authorizedContractValid(_contract)
481         returns(bool) {
482         uint256 id = authorizedContractIds[_contract];
483         authorizedContractList.remove(id);
484         authorizedContractIds[_contract] = 0;
485         delete authorizedContracts[id];
486         
487         // Event 
488         emit ContractDeauthorized(_contract);
489         return true;
490     }
491 
492     /**
493      * @dev Deauthorized `_contract` by contract id
494      * @param _cid The contract id
495      */
496     function deauthorizeContractById(uint256 _cid) 
497         public
498         onlyOwner
499         authorizedContractIdValid(_cid)
500         returns(bool) {
501         address acontract = authorizedContracts[_cid].acontract;
502         authorizedContractList.remove(_cid);
503         authorizedContractIds[acontract] = 0;
504         delete authorizedContracts[_cid];
505 
506         // Event 
507         emit ContractDeauthorized(acontract);
508         return true;
509     }
510 
511     /**
512      * @dev Get authorize contract ids by page
513      * @param _from The begin authorize contract id
514      * @param _limit How many authorize contract ids one page
515      * @return The authorize contract ids and the next authorize contract id as tuple, the next page not exists when next eq 0
516      */
517     function getAuthorizeContractIds(uint256 _from, uint256 _limit) 
518         external 
519         view 
520         returns(uint256[], uint256){
521         return getNodes(authorizedContractList, _from, _limit, true);
522     }
523 
524     /**
525      * @dev Get authorize contract by id
526      * @param _cid Then authorize contract id
527      * @return The authorize contract info(_name, _acontract)
528      */
529     function getAuthorizeContract(uint256 _cid) 
530         external 
531         view 
532         returns(string _name, address _acontract) {
533         AuthorizedContract memory acontract = authorizedContracts[_cid]; 
534         _name = acontract.name;
535         _acontract = acontract.acontract;
536     }
537 
538     /*************************************** GET ***************************************/
539 
540     /**
541      * @dev Get the rate plan by `_vendorId` and `_rpid`
542      * @param _vendorId The vendor id
543      * @param _rpid The rate plan id
544      */
545     function getRatePlan(uint256 _vendorId, uint256 _rpid) 
546         public 
547         view 
548         returns (string _name, uint256 _timestamp, bytes32 _ipfs) {
549         _name = vendors[_vendorId].ratePlans[_rpid].name;
550         _timestamp = vendors[_vendorId].ratePlans[_rpid].timestamp;
551         _ipfs = vendors[_vendorId].ratePlans[_rpid].ipfs;
552     }
553 
554     /**
555      * @dev Get the rate plan price by `_vendorId`, `_rpid`, `_date` and `_tokenId`
556      * @param _vendorId The vendor id
557      * @param _rpid The rate plan id
558      * @param _date The date desc (20180723)
559      * @param _tokenId The digital token id
560      * @return The price info(inventory, init, price)
561      */
562     function getPrice(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _tokenId) 
563         public
564         view 
565         returns(uint16 _inventory, bool _init, uint256 _price) {
566         _inventory = vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
567         _init = vendors[_vendorId].ratePlans[_rpid].prices[_date].init;
568         _price = vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId];
569         if(!_init) {
570             // Get the base price
571             _inventory = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
572             _price = vendors[_vendorId].ratePlans[_rpid].basePrice.tokens[_tokenId];
573             _init = vendors[_vendorId].ratePlans[_rpid].basePrice.init;
574         }
575     }
576 
577     /**
578      * @dev Get the rate plan prices by `_vendorId`, `_rpid`, `_dates` and `_tokenId`
579      * @param _vendorId The vendor id
580      * @param _rpid The rate plan id
581      * @param _dates The dates desc ([20180723,20180724,20180725])
582      * @param _tokenId The digital token id
583      * @return The price info(inventory, init, price)
584      */
585     function getPrices(uint256 _vendorId, uint256 _rpid, uint256[] _dates, uint256 _tokenId) 
586         public
587         view 
588         returns(uint16[] _inventories, uint256[] _prices) {
589         uint16[] memory inventories = new uint16[](_dates.length);
590         uint256[] memory prices = new uint256[](_dates.length);
591         uint256 date;
592         for(uint256 i = 0; i < _dates.length; i++) {
593             date = _dates[i];
594             uint16 inventory = vendors[_vendorId].ratePlans[_rpid].prices[date].inventory;
595             bool init = vendors[_vendorId].ratePlans[_rpid].prices[date].init;
596             uint256 price = vendors[_vendorId].ratePlans[_rpid].prices[date].tokens[_tokenId];
597             if(!init) {
598                 // Get the base price
599                 inventory = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
600                 price = vendors[_vendorId].ratePlans[_rpid].basePrice.tokens[_tokenId];
601                 init = vendors[_vendorId].ratePlans[_rpid].basePrice.init;
602             }
603             inventories[i] = inventory;
604             prices[i] = price;
605         }
606         return (inventories, prices);
607     }
608 
609     /**
610      * @dev Get the inventory by  by `_vendorId`, `_rpid` and `_date`
611      * @param _vendorId The vendor id
612      * @param _rpid The rate plan id
613      * @param _date The date desc (20180723)
614      * @return The inventory info(inventory, init)
615      */
616     function getInventory(uint256 _vendorId, uint256 _rpid, uint256 _date) 
617         public
618         view 
619         returns(uint16 _inventory, bool _init) {
620         _inventory = vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
621         _init = vendors[_vendorId].ratePlans[_rpid].prices[_date].init;
622         if(!_init) {
623             // Get the base price
624             _inventory = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
625         }
626     }
627 
628     /**
629      * @dev Whether the rate plan is exist
630      * @param _vendorId The vendor id
631      * @param _rpid The rate plan id
632      * @return If the rate plan of the vendor is exist returns true otherwise return false
633      */
634     function ratePlanIsExist(uint256 _vendorId, uint256 _rpid) 
635         public 
636         view 
637         returns (bool) {
638         return vendors[_vendorId].ratePlanList.nodeExists(_rpid);
639     }
640 
641     /**
642      * @dev Get orders of owner by page
643      * @param _owner The owner address
644      * @param _from The begin id of the node to get
645      * @param _limit The total nodes of one page
646      * @param _direction Direction to step in
647      * @return The order ids and the next id
648      */
649     function getOrdersOfOwner(address _owner, uint256 _from, uint256 _limit, bool _direction) 
650         public 
651         view 
652         returns (uint256[], uint256) {
653         return getNodes(roomNightOwners[_owner], _from, _limit, _direction);
654     }
655 
656     /**
657      * @dev Get orders of vendor by page
658      * @param _owner The vendor address
659      * @param _from The begin id of the node to get
660      * @param _limit The total nodes of on page
661      * @param _direction Direction to step in 
662      * @return The order ids and the next id
663      */
664     function getOrdersOfVendor(address _owner, uint256 _from, uint256 _limit, bool _direction) 
665         public 
666         view 
667         returns (uint256[], uint256) {
668         return getNodes(roomNightVendors[_owner], _from, _limit, _direction);
669     }
670 
671     /**
672      * @dev Get the token count of somebody 
673      * @param _owner The owner of token
674      * @return The token count of `_owner`
675      */
676     function balanceOf(address _owner) 
677         public 
678         view 
679         returns(uint256) {
680         return roomNightOwners[_owner].length;
681     }
682 
683     /**
684      * @dev Get rate plan ids of `_vendorId`
685      * @param _from The begin id of the node to get
686      * @param _limit The total nodes of on page
687      * @param _direction Direction to step in 
688      * @return The rate plan ids and the next id
689      */
690     function getRatePlansOfVendor(uint256 _vendorId, uint256 _from, uint256 _limit, bool _direction) 
691         public 
692         view 
693         returns(uint256[], uint256) {
694         return getNodes(vendors[_vendorId].ratePlanList, _from, _limit, _direction);
695     }
696 
697     /**
698      * @dev Get token ids
699      * @param _from The begin id of the node to get
700      * @param _limit The total nodes of on page
701      * @param _direction Direction to step in 
702      * @return The token ids and the next id
703      */
704     function getTokens(uint256 _from, uint256 _limit, bool _direction) 
705         public 
706         view 
707         returns(uint256[], uint256) {
708         return getNodes(tokenList, _from, _limit, _direction);
709     }
710 
711     /**
712      * @dev Get token Info
713      * @param _tokenId The token id
714      * @return The token info(symbol, name, decimals)
715      */
716     function getToken(uint256 _tokenId)
717         public 
718         view 
719         returns(string _symbol, string _name, uint8 _decimals, address _token) {
720         _token = tokenIndexToAddress[_tokenId];
721         TripioToken tripio = TripioToken(_token);
722         _symbol = tripio.symbol();
723         _name = tripio.name();
724         _decimals = tripio.decimals();
725     }
726 
727     /**
728      * @dev Get vendor ids
729      * @param _from The begin id of the node to get
730      * @param _limit The total nodes of on page
731      * @param _direction Direction to step in 
732      * @return The vendor ids and the next id
733      */
734     function getVendors(uint256 _from, uint256 _limit, bool _direction) 
735         public 
736         view 
737         returns(uint256[], uint256) {
738         return getNodes(vendorList, _from, _limit, _direction);
739     }
740 
741     /**
742      * @dev Get the vendor infomation by vendorId
743      * @param _vendorId The vendor id
744      * @return The vendor infomation(name, vendor, timestamp, valid)
745      */
746     function getVendor(uint256 _vendorId) 
747         public 
748         view 
749         returns(string _name, address _vendor,uint256 _timestamp, bool _valid) {
750         _name = vendors[_vendorId].name;
751         _vendor = vendors[_vendorId].vendor;
752         _timestamp = vendors[_vendorId].timestamp;
753         _valid = vendors[_vendorId].valid;
754     }
755 
756     /*************************************** SET ***************************************/
757     /**
758      * @dev Update base uri of token metadata
759      * @param _tokenBaseURI The base uri
760      */
761     function updateTokenBaseURI(string _tokenBaseURI) 
762         public 
763         onlyOwnerOrAuthorizedContract {
764         tokenBaseURI = _tokenBaseURI;
765     }
766 
767     /**
768      * @dev Push order to user's order list
769      * @param _owner The buyer address
770      * @param _rnid The room night order id
771      * @param _direction direction to step in
772      */
773     function pushOrderOfOwner(address _owner, uint256 _rnid, bool _direction) 
774         public 
775         onlyOwnerOrAuthorizedContract {
776         if(!roomNightOwners[_owner].listExists()) {
777             roomNightOwners[_owner] = LinkedListLib.LinkedList(0, 0);
778         }
779         roomNightOwners[_owner].add(_rnid, _direction);
780     }
781 
782     /**
783      * @dev Remove order from owner's order list
784      * @param _owner The owner address
785      * @param _rnid The room night order id
786      */
787     function removeOrderOfOwner(address _owner, uint _rnid) 
788         public 
789         onlyOwnerOrAuthorizedContract {
790         require(roomNightOwners[_owner].nodeExists(_rnid));
791         roomNightOwners[_owner].remove(_rnid);
792     }
793 
794     /**
795      * @dev Push order to the vendor's order list
796      * @param _vendor The vendor address
797      * @param _rnid The room night order id
798      * @param _direction direction to step in
799      */
800     function pushOrderOfVendor(address _vendor, uint256 _rnid, bool _direction) 
801         public 
802         onlyOwnerOrAuthorizedContract {
803         if(!roomNightVendors[_vendor].listExists()) {
804             roomNightVendors[_vendor] = LinkedListLib.LinkedList(0, 0);
805         }
806         roomNightVendors[_vendor].add(_rnid, _direction);
807     }
808 
809     /**
810      * @dev Remove order from vendor's order list
811      * @param _vendor The vendor address
812      * @param _rnid The room night order id
813      */
814     function removeOrderOfVendor(address _vendor, uint256 _rnid) 
815         public 
816         onlyOwnerOrAuthorizedContract {
817         require(roomNightVendors[_vendor].nodeExists(_rnid));
818         roomNightVendors[_vendor].remove(_rnid);
819     }
820 
821     /**
822      * @dev Transfer token to somebody
823      * @param _tokenId The token id 
824      * @param _to The target owner of the token
825      */
826     function transferTokenTo(uint256 _tokenId, address _to) 
827         public 
828         onlyOwnerOrAuthorizedContract {
829         roomNightIndexToOwner[_tokenId] = _to;
830         roomNightApprovals[_tokenId] = address(0);
831     }
832 
833     /**
834      * @dev Approve `_to` to operate the `_tokenId`
835      * @param _tokenId The token id
836      * @param _to Somebody to be approved
837      */
838     function approveTokenTo(uint256 _tokenId, address _to) 
839         public 
840         onlyOwnerOrAuthorizedContract {
841         roomNightApprovals[_tokenId] = _to;
842     }
843 
844     /**
845      * @dev Approve `_operator` to operate all the Token of `_to`
846      * @param _operator The operator to be approved
847      * @param _to The owner of tokens to be operate
848      * @param _approved Approved or not
849      */
850     function approveOperatorTo(address _operator, address _to, bool _approved) 
851         public 
852         onlyOwnerOrAuthorizedContract {
853         operatorApprovals[_to][_operator] = _approved;
854     } 
855 
856     /**
857      * @dev Update base price of rate plan
858      * @param _vendorId The vendor id
859      * @param _rpid The rate plan id
860      * @param _tokenId The digital token id
861      * @param _price The price to be updated
862      */
863     function updateBasePrice(uint256 _vendorId, uint256 _rpid, uint256 _tokenId, uint256 _price)
864         public 
865         onlyOwnerOrAuthorizedContract {
866         vendors[_vendorId].ratePlans[_rpid].basePrice.init = true;
867         vendors[_vendorId].ratePlans[_rpid].basePrice.tokens[_tokenId] = _price;
868     }
869 
870     /**
871      * @dev Update base inventory of rate plan 
872      * @param _vendorId The vendor id
873      * @param _rpid The rate plan id
874      * @param _inventory The inventory to be updated
875      */
876     function updateBaseInventory(uint256 _vendorId, uint256 _rpid, uint16 _inventory)
877         public 
878         onlyOwnerOrAuthorizedContract {
879         vendors[_vendorId].ratePlans[_rpid].basePrice.inventory = _inventory;
880     }
881 
882     /**
883      * @dev Update price by `_vendorId`, `_rpid`, `_date`, `_tokenId` and `_price`
884      * @param _vendorId The vendor id
885      * @param _rpid The rate plan id
886      * @param _date The date desc (20180723)
887      * @param _tokenId The digital token id
888      * @param _price The price to be updated
889      */
890     function updatePrice(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _tokenId, uint256 _price)
891         public
892         onlyOwnerOrAuthorizedContract {
893         if (vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
894             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
895         } else {
896             vendors[_vendorId].ratePlans[_rpid].prices[_date] = Price(0, true);
897             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
898         }
899     }
900 
901     /**
902      * @dev Update inventory by `_vendorId`, `_rpid`, `_date`, `_inventory`
903      * @param _vendorId The vendor id
904      * @param _rpid The rate plan id
905      * @param _date The date desc (20180723)
906      * @param _inventory The inventory to be updated
907      */
908     function updateInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint16 _inventory)
909         public 
910         onlyOwnerOrAuthorizedContract {
911         if (vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
912             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = _inventory;
913         } else {
914             vendors[_vendorId].ratePlans[_rpid].prices[_date] = Price(_inventory, true);
915         }
916     }
917 
918     /**
919      * @dev Reduce inventories
920      * @param _vendorId The vendor id
921      * @param _rpid The rate plan id
922      * @param _date The date desc (20180723)
923      * @param _inventory The amount to be reduced
924      */
925     function reduceInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint16 _inventory) 
926         public  
927         onlyOwnerOrAuthorizedContract {
928         uint16 a = 0;
929         if(vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
930             a = vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
931             require(_inventory <= a);
932             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = a - _inventory;
933         }else if(vendors[_vendorId].ratePlans[_rpid].basePrice.init){
934             a = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
935             require(_inventory <= a);
936             vendors[_vendorId].ratePlans[_rpid].basePrice.inventory = a - _inventory;
937         }
938     }
939 
940     /**
941      * @dev Add inventories
942      * @param _vendorId The vendor id
943      * @param _rpid The rate plan id
944      * @param _date The date desc (20180723)
945      * @param _inventory The amount to be add
946      */
947     function addInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint16 _inventory) 
948         public  
949         onlyOwnerOrAuthorizedContract {
950         uint16 c = 0;
951         if(vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
952             c = _inventory + vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
953             require(c >= _inventory);
954             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = c;
955         }else if(vendors[_vendorId].ratePlans[_rpid].basePrice.init) {
956             c = _inventory + vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
957             require(c >= _inventory);
958             vendors[_vendorId].ratePlans[_rpid].basePrice.inventory = c;
959         }
960     }
961 
962     /**
963      * @dev Update inventory and price by `_vendorId`, `_rpid`, `_date`, `_tokenId`, `_price` and `_inventory`
964      * @param _vendorId The vendor id
965      * @param _rpid The rate plan id
966      * @param _date The date desc (20180723)
967      * @param _tokenId The digital token id
968      * @param _price The price to be updated
969      * @param _inventory The inventory to be updated
970      */
971     function updatePriceAndInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _tokenId, uint256 _price, uint16 _inventory)
972         public 
973         onlyOwnerOrAuthorizedContract {
974         if (vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
975             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = _inventory;
976             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
977         } else {
978             vendors[_vendorId].ratePlans[_rpid].prices[_date] = Price(_inventory, true);
979             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
980         }
981     }
982 
983     /**
984      * @dev Push rate plan to `_vendorId`'s rate plan list
985      * @param _vendorId The vendor id
986      * @param _name The name of rate plan
987      * @param _ipfs The rate plan IPFS address
988      * @param _direction direction to step in
989      */
990     function pushRatePlan(uint256 _vendorId, string _name, bytes32 _ipfs, bool _direction) 
991         public 
992         onlyOwnerOrAuthorizedContract
993         returns(uint256) {
994         RatePlan memory rp = RatePlan(_name, uint256(now), _ipfs, Price(0, false));
995         
996         uint256 id = vendors[_vendorId].ratePlanList.push(_direction);
997         vendors[_vendorId].ratePlans[id] = rp;
998         return id;
999     }
1000 
1001     /**
1002      * @dev Remove rate plan of `_vendorId` by `_rpid`
1003      * @param _vendorId The vendor id
1004      * @param _rpid The rate plan id
1005      */
1006     function removeRatePlan(uint256 _vendorId, uint256 _rpid) 
1007         public 
1008         onlyOwnerOrAuthorizedContract {
1009         delete vendors[_vendorId].ratePlans[_rpid];
1010         vendors[_vendorId].ratePlanList.remove(_rpid);
1011     }
1012 
1013     /**
1014      * @dev Update `_rpid` of `_vendorId` by `_name` and `_ipfs`
1015      * @param _vendorId The vendor id
1016      * @param _rpid The rate plan id
1017      * @param _name The rate plan name
1018      * @param _ipfs The rate plan IPFS address
1019      */
1020     function updateRatePlan(uint256 _vendorId, uint256 _rpid, string _name, bytes32 _ipfs)
1021         public 
1022         onlyOwnerOrAuthorizedContract {
1023         vendors[_vendorId].ratePlans[_rpid].ipfs = _ipfs;
1024         vendors[_vendorId].ratePlans[_rpid].name = _name;
1025     }
1026     
1027     /**
1028      * @dev Push token contract to the token list
1029      * @param _direction direction to step in
1030      */
1031     function pushToken(address _contract, bool _direction)
1032         public 
1033         onlyOwnerOrAuthorizedContract 
1034         returns(uint256) {
1035         uint256 id = tokenList.push(_direction);
1036         tokenIndexToAddress[id] = _contract;
1037         return id;
1038     }
1039 
1040     /**
1041      * @dev Remove token by `_tokenId`
1042      * @param _tokenId The digital token id
1043      */
1044     function removeToken(uint256 _tokenId) 
1045         public 
1046         onlyOwnerOrAuthorizedContract {
1047         delete tokenIndexToAddress[_tokenId];
1048         tokenList.remove(_tokenId);
1049     }
1050 
1051     /**
1052      * @dev Generate room night token
1053      * @param _vendorId The vendor id
1054      * @param _rpid The rate plan id
1055      * @param _date The date desc (20180723)
1056      * @param _token The token id
1057      * @param _price The token price
1058      * @param _ipfs The rate plan IPFS address
1059      */
1060     function generateRoomNightToken(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _token, uint256 _price, bytes32 _ipfs)
1061         public 
1062         onlyOwnerOrAuthorizedContract 
1063         returns(uint256) {
1064         roomnights.push(RoomNight(_vendorId, _rpid, _token, _price, now, _date, _ipfs));
1065 
1066         // Give the token to `_customer`
1067         uint256 rnid = uint256(roomnights.length - 1);
1068         return rnid;
1069     }
1070 
1071     /**
1072      * @dev Update refund applications
1073      * @param _buyer The room night token holder
1074      * @param _rnid The room night token id
1075      * @param _isRefund Is redund or not
1076      */
1077     function updateRefundApplications(address _buyer, uint256 _rnid, bool _isRefund) 
1078         public 
1079         onlyOwnerOrAuthorizedContract {
1080         refundApplications[_buyer][_rnid] = _isRefund;
1081     }
1082 
1083     /**
1084      * @dev Push vendor info to the vendor list
1085      * @param _name The name of vendor
1086      * @param _vendor The vendor address
1087      * @param _direction direction to step in
1088      */
1089     function pushVendor(string _name, address _vendor, bool _direction)
1090         public 
1091         onlyOwnerOrAuthorizedContract 
1092         returns(uint256) {
1093         uint256 id = vendorList.push(_direction);
1094         vendorIds[_vendor] = id;
1095         vendors[id] = Vendor(_name, _vendor, uint256(now), true, LinkedListLib.LinkedList(0, 0));
1096         return id;
1097     }
1098 
1099     /**
1100      * @dev Remove vendor from vendor list
1101      * @param _vendorId The vendor id
1102      */
1103     function removeVendor(uint256 _vendorId) 
1104         public 
1105         onlyOwnerOrAuthorizedContract {
1106         vendorList.remove(_vendorId);
1107         address vendor = vendors[_vendorId].vendor;
1108         vendorIds[vendor] = 0;
1109         delete vendors[_vendorId];
1110     }
1111 
1112     /**
1113      * @dev Make vendor valid or invalid
1114      * @param _vendorId The vendor id
1115      * @param _valid The vendor is valid or not
1116      */
1117     function updateVendorValid(uint256 _vendorId, bool _valid)
1118         public 
1119         onlyOwnerOrAuthorizedContract {
1120         vendors[_vendorId].valid = _valid;
1121     }
1122 
1123     /**
1124      * @dev Modify vendor's name
1125      * @param _vendorId The vendor id
1126      * @param _name Then vendor name
1127      */
1128     function updateVendorName(uint256 _vendorId, string _name)
1129         public 
1130         onlyOwnerOrAuthorizedContract {
1131         vendors[_vendorId].name = _name;
1132     }
1133 }