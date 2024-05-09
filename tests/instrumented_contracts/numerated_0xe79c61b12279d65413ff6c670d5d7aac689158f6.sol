1 pragma solidity ^0.4.24;
2 
3 /**
4  * Owned contract
5  */
6 contract Owned {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed from, address indexed to);
11 
12     /**
13      * Constructor
14      */
15     constructor() public {
16         owner = msg.sender;
17     }
18 
19     /**
20      * @dev Only the owner of contract
21      */ 
22     modifier onlyOwner {
23         require(msg.sender == owner);
24         _;
25     }
26     
27     /**
28      * @dev transfer the ownership to other
29      *      - Only the owner can operate
30      */ 
31     function transferOwnership(address _newOwner) public onlyOwner {
32         newOwner = _newOwner;
33     }
34 
35     /** 
36      * @dev Accept the ownership from last owner
37      */ 
38     function acceptOwnership() public {
39         require(msg.sender == newOwner);
40         emit OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42         newOwner = address(0);
43     }
44 }
45 
46 contract TRNData is Owned {
47     TripioRoomNightData dataSource;
48     /**
49      * Only the valid vendor and the vendor is valid
50      */ 
51     modifier onlyVendor {
52         uint256 vendorId = dataSource.vendorIds(msg.sender);
53         require(vendorId > 0);
54         (,,,bool valid) = dataSource.getVendor(vendorId);
55         require(valid);
56         _;
57     }
58 
59     /**
60      * The vendor is valid
61      */
62     modifier vendorValid(address _vendor) {
63         uint256 vendorId = dataSource.vendorIds(_vendor);
64         require(vendorId > 0);
65         (,,,bool valid) = dataSource.getVendor(vendorId);
66         require(valid);
67         _;
68     }
69 
70     /**
71      * The vendorId is valid
72      */
73     modifier vendorIdValid(uint256 _vendorId) {
74         (,,,bool valid) = dataSource.getVendor(_vendorId);
75         require(valid);
76         _;
77     }
78 
79     /**
80      * Rate plan exist.
81      */
82     modifier ratePlanExist(uint256 _vendorId, uint256 _rpid) {
83         (,,,bool valid) = dataSource.getVendor(_vendorId);
84         require(valid);
85         require(dataSource.ratePlanIsExist(_vendorId, _rpid));
86         _;
87     }
88     
89     /**
90      * Token is valid
91      */
92     modifier validToken(uint256 _tokenId) {
93         require(_tokenId > 0);
94         require(dataSource.roomNightIndexToOwner(_tokenId) != address(0));
95         _;
96     }
97 
98     /**
99      * Tokens are valid
100      */
101     modifier validTokenInBatch(uint256[] _tokenIds) {
102         for(uint256 i = 0; i < _tokenIds.length; i++) {
103             require(_tokenIds[i] > 0);
104             require(dataSource.roomNightIndexToOwner(_tokenIds[i]) != address(0));
105         }
106         _;
107     }
108 
109     /**
110      * Whether the `_tokenId` can be transfered
111      */
112     modifier canTransfer(uint256 _tokenId) {
113         address owner = dataSource.roomNightIndexToOwner(_tokenId);
114         bool isOwner = (msg.sender == owner);
115         bool isApproval = (msg.sender == dataSource.roomNightApprovals(_tokenId));
116         bool isOperator = (dataSource.operatorApprovals(owner, msg.sender));
117         require(isOwner || isApproval || isOperator);
118         _;
119     }
120 
121     /**
122      * Whether the `_tokenIds` can be transfered
123      */
124     modifier canTransferInBatch(uint256[] _tokenIds) {
125         for(uint256 i = 0; i < _tokenIds.length; i++) {
126             address owner = dataSource.roomNightIndexToOwner(_tokenIds[i]);
127             bool isOwner = (msg.sender == owner);
128             bool isApproval = (msg.sender == dataSource.roomNightApprovals(_tokenIds[i]));
129             bool isOperator = (dataSource.operatorApprovals(owner, msg.sender));
130             require(isOwner || isApproval || isOperator);
131         }
132         _;
133     }
134 
135 
136     /**
137      * Whether the `_tokenId` can be operated by `msg.sender`
138      */
139     modifier canOperate(uint256 _tokenId) {
140         address owner = dataSource.roomNightIndexToOwner(_tokenId);
141         bool isOwner = (msg.sender == owner);
142         bool isOperator = (dataSource.operatorApprovals(owner, msg.sender));
143         require(isOwner || isOperator);
144         _;
145     }
146 
147     /**
148      * Whether the `_date` is valid(no hours, no seconds)
149      */
150     modifier validDate(uint256 _date) {
151         require(_date > 0);
152         require(dateIsLegal(_date));
153         _;
154     }
155 
156     /**
157      * Whether the `_dates` are valid(no hours, no seconds)
158      */
159     modifier validDates(uint256[] _dates) {
160         for(uint256 i = 0;i < _dates.length; i++) {
161             require(_dates[i] > 0);
162             require(dateIsLegal(_dates[i]));
163         }
164         _;
165     }
166 
167     function dateIsLegal(uint256 _date) pure private returns(bool) {
168         uint256 year = _date / 10000;
169         uint256 mon = _date / 100 - year * 100;
170         uint256 day = _date - mon * 100 - year * 10000;
171         
172         if(year < 1970 || mon <= 0 || mon > 12 || day <= 0 || day > 31)
173             return false;
174 
175         if(4 == mon || 6 == mon || 9 == mon || 11 == mon){
176             if (day == 31) {
177                 return false;
178             }
179         }
180         if(((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
181             if(2 == mon && day > 29) {
182                 return false;
183             }
184         }else {
185             if(2 == mon && day > 28){
186                 return false;
187             }
188         }
189         return true;
190     }
191     /**
192      * Constructor
193      */
194     constructor() public {
195 
196     }
197 }
198 
199 
200 contract TRNPrices is TRNData {
201 
202     /**
203      * Constructor
204      */
205     constructor() public {
206 
207     }
208 
209     /**
210      * This emits when rate plan price changed
211      */
212     event RatePlanPriceChanged(uint256 indexed _rpid);
213 
214     /**
215      * This emits when rate plan inventory changed
216      */
217     event RatePlanInventoryChanged(uint256 indexed _rpid);
218 
219     /**
220      * This emits when rate plan base price changed
221      */
222     event RatePlanBasePriceChanged(uint256 indexed _rpid);
223     
224     function _updatePrices(uint256 _rpid, uint256 _date, uint16 _inventory, uint256[] _tokens, uint256[] _prices) private {
225         uint256 vendorId = dataSource.vendorIds(msg.sender);
226         dataSource.updateInventories(vendorId, _rpid, _date, _inventory);
227         for (uint256 tindex = 0; tindex < _tokens.length; tindex++) {
228             dataSource.updatePrice(vendorId, _rpid, _date, _tokens[tindex], _prices[tindex]);
229         }
230     }
231 
232     function _updateInventories(uint256 _rpid, uint256 _date, uint16 _inventory) private {
233         uint256 vendorId = dataSource.vendorIds(msg.sender);
234         dataSource.updateInventories(vendorId, _rpid, _date, _inventory);
235     }
236 
237     /**
238      * @dev Update base price assigned to a vendor by `_rpid`, `msg.sender`, `_dates`
239      *      Throw when `msg.sender` is not a vendor
240      *      Throw when `_rpid` not exist
241      *      Throw when `_tokens`'s length is not equal to `_prices`'s length or `_tokens`'s length is equal to zero
242      * @param _rpid The rate plan identifier
243      * @param _inventory The amount that can be sold
244      * @param _tokens The pricing currency token
245      * @param _prices The currency token selling price  
246      */
247     function updateBasePrice(uint256 _rpid, uint256[] _tokens, uint256[] _prices, uint16 _inventory) 
248         external 
249         ratePlanExist(dataSource.vendorIds(msg.sender), _rpid) 
250         returns(bool) {
251         require(_tokens.length == _prices.length);
252         require(_prices.length > 0);
253         uint256 vendorId = dataSource.vendorIds(msg.sender);
254         dataSource.updateBaseInventory(vendorId, _rpid, _inventory);
255         for (uint256 tindex = 0; tindex < _tokens.length; tindex++) {
256             dataSource.updateBasePrice(vendorId, _rpid, _tokens[tindex], _prices[tindex]);
257         }
258         // Event 
259         emit RatePlanBasePriceChanged(_rpid);
260         return true;
261     }
262 
263     /**
264      * @dev Update prices assigned to a vendor by `_rpid`, `msg.sender`, `_dates`
265      *      Throw when `msg.sender` is not a vendor
266      *      Throw when `_rpid` not exist
267      *      Throw when `_dates`'s length lte 0
268      *      Throw when `_tokens`'s length is not equal to `_prices`'s length or `_tokens`'s length is equal to zero
269      * @param _rpid The rate plan identifier
270      * @param _dates The prices to be modified of `_dates`
271      * @param _inventory The amount that can be sold
272      * @param _tokens The pricing currency token
273      * @param _prices The currency token selling price  
274      */
275     function updatePrices(uint256 _rpid, uint256[] _dates, uint16 _inventory, uint256[] _tokens, uint256[] _prices)
276         external 
277         ratePlanExist(dataSource.vendorIds(msg.sender), _rpid) 
278         returns(bool) {
279         require(_dates.length > 0);
280         require(_tokens.length == _prices.length);
281         require(_prices.length > 0);
282         for (uint256 index = 0; index < _dates.length; index++) {
283             _updatePrices(_rpid, _dates[index], _inventory, _tokens, _prices);
284         }
285         // Event 
286         emit RatePlanPriceChanged(_rpid);
287         return true;
288     }
289 
290     /**
291      * @dev Update inventory assigned to a vendor by `_rpid`, `msg.sender`, `_dates`
292      *      Throw when `msg.sender` is not a vendor
293      *      Throw when `_rpid` not exist
294      *      Throw when `_dates`'s length lte 0
295      * @param _rpid The rate plan identifier
296      * @param _dates The prices to be modified of `_dates`
297      * @param _inventory The amount that can be sold
298      */
299     function updateInventories(uint256 _rpid, uint256[] _dates, uint16 _inventory) 
300         external 
301         ratePlanExist(dataSource.vendorIds(msg.sender), _rpid) 
302         returns(bool) {
303         for (uint256 index = 0; index < _dates.length; index++) {
304             _updateInventories(_rpid, _dates[index], _inventory);
305         }
306 
307         // Event
308         emit RatePlanInventoryChanged(_rpid);
309         return true;
310     }
311 
312     /**
313      * @dev Returns the inventories of `_vendor`'s RP(`_rpid`) on `_dates`
314      *      Throw when `_rpid` not exist
315      *      Throw when `_dates`'s count lte 0
316      * @param _vendorId The vendor Id
317      * @param _rpid The rate plan identifier
318      * @param _dates The inventories to be returned of `_dates`
319      * @return The inventories
320      */
321     function inventoriesOfDate(uint256 _vendorId, uint256 _rpid, uint256[] _dates) 
322         external 
323         view
324         ratePlanExist(_vendorId, _rpid) 
325         returns(uint16[]) {
326         require(_dates.length > 0);
327         uint16[] memory result = new uint16[](_dates.length);
328         for (uint256 index = 0; index < _dates.length; index++) {
329             uint256 date = _dates[index];
330             (uint16 inventory,) = dataSource.getInventory(_vendorId, _rpid, date);
331             result[index] = inventory;
332         }
333         return result;
334     }
335 
336     /**
337      * @dev Returns the prices of `_vendor`'s RP(`_rpid`) on `_dates`
338      *      Throw when `_rpid` not exist
339      *      Throw when `_dates`'s count lte 0
340      * @param _vendorId The vendor Id
341      * @param _rpid The rate plan identifier
342      * @param _dates The inventories to be returned of `_dates`
343      * @param _token The digital currency token
344      * @return The prices
345      */
346     function pricesOfDate(uint256 _vendorId, uint256 _rpid, uint256[] _dates, uint256 _token)
347         external 
348         view
349         ratePlanExist(_vendorId, _rpid) 
350         returns(uint256[]) {
351         require(_dates.length > 0);
352         uint256[] memory result = new uint256[](_dates.length);
353         for (uint256 index = 0; index < _dates.length; index++) {
354             (,, uint256 _price) = dataSource.getPrice(_vendorId, _rpid, _dates[index], _token);
355             result[index] = _price;
356         }
357         return result;
358     }
359 
360     /**
361      * @dev Returns the prices and inventories of `_vendor`'s RP(`_rpid`) on `_dates`
362      *      Throw when `_rpid` not exist
363      *      Throw when `_dates`'s count lte 0
364      * @param _vendorId The vendor Id
365      * @param _rpid The rate plan identifier
366      * @param _dates The inventories to be returned of `_dates`
367      * @param _token The digital currency token
368      * @return The prices and inventories
369      */
370     function pricesAndInventoriesOfDate(uint256 _vendorId, uint256 _rpid, uint256[] _dates, uint256 _token)
371         external 
372         view
373         returns(uint256[], uint16[]) {
374         uint256[] memory prices = new uint256[](_dates.length);
375         uint16[] memory inventories = new uint16[](_dates.length);
376         for (uint256 index = 0; index < _dates.length; index++) {
377             (uint16 _inventory,, uint256 _price) = dataSource.getPrice(_vendorId, _rpid, _dates[index], _token);
378             prices[index] = _price;
379             inventories[index] = _inventory;
380         }
381         return (prices, inventories);
382     }
383 
384     /**
385      * @dev Returns the RP's price and inventory of `_date`.
386      *      Throw when `_rpid` not exist
387      * @param _vendorId The vendor Id
388      * @param _rpid The rate plan identifier
389      * @param _date The price and inventory to be returneed of `_date`
390      * @param _token The digital currency token
391      * @return The price and inventory
392      */
393     function priceOfDate(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _token) 
394         external 
395         view
396         ratePlanExist(_vendorId, _rpid) 
397         returns(uint16 _inventory, uint256 _price) {
398         (_inventory, , _price) = dataSource.getPrice(_vendorId, _rpid, _date, _token);
399     }
400 }
401 
402 /**
403  * This utility library was forked from https://github.com/o0ragman0o/LibCLL
404  */
405 library LinkedListLib {
406 
407     uint256 constant NULL = 0;
408     uint256 constant HEAD = 0;
409     bool constant PREV = false;
410     bool constant NEXT = true;
411 
412     struct LinkedList {
413         mapping (uint256 => mapping (bool => uint256)) list;
414         uint256 length;
415         uint256 index;
416     }
417 
418     /**
419      * @dev returns true if the list exists
420      * @param self stored linked list from contract
421      */
422     function listExists(LinkedList storage self)
423         internal
424         view returns (bool) {
425         return self.length > 0;
426     }
427 
428     /**
429      * @dev returns true if the node exists
430      * @param self stored linked list from contract
431      * @param _node a node to search for
432      */
433     function nodeExists(LinkedList storage self, uint256 _node)
434         internal
435         view returns (bool) {
436         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
437             if (self.list[HEAD][NEXT] == _node) {
438                 return true;
439             } else {
440                 return false;
441             }
442         } else {
443             return true;
444         }
445     }
446 
447     /**
448      * @dev Returns the number of elements in the list
449      * @param self stored linked list from contract
450      */ 
451     function sizeOf(LinkedList storage self) 
452         internal 
453         view 
454         returns (uint256 numElements) {
455         return self.length;
456     }
457 
458     /**
459      * @dev Returns the links of a node as a tuple
460      * @param self stored linked list from contract
461      * @param _node id of the node to get
462      */
463     function getNode(LinkedList storage self, uint256 _node)
464         public 
465         view 
466         returns (bool, uint256, uint256) {
467         if (!nodeExists(self,_node)) {
468             return (false, 0, 0);
469         } else {
470             return (true, self.list[_node][PREV], self.list[_node][NEXT]);
471         }
472     }
473 
474     /**
475      * @dev Returns the link of a node `_node` in direction `_direction`.
476      * @param self stored linked list from contract
477      * @param _node id of the node to step from
478      * @param _direction direction to step in
479      */
480     function getAdjacent(LinkedList storage self, uint256 _node, bool _direction)
481         public 
482         view 
483         returns (bool, uint256) {
484         if (!nodeExists(self,_node)) {
485             return (false,0);
486         } else {
487             return (true,self.list[_node][_direction]);
488         }
489     }
490 
491     /**
492      * @dev Can be used before `insert` to build an ordered list
493      * @param self stored linked list from contract
494      * @param _node an existing node to search from, e.g. HEAD.
495      * @param _value value to seek
496      * @param _direction direction to seek in
497      * @return next first node beyond '_node' in direction `_direction`
498      */
499     function getSortedSpot(LinkedList storage self, uint256 _node, uint256 _value, bool _direction)
500         public 
501         view 
502         returns (uint256) {
503         if (sizeOf(self) == 0) { 
504             return 0; 
505         }
506         require((_node == 0) || nodeExists(self,_node));
507         bool exists;
508         uint256 next;
509         (exists,next) = getAdjacent(self, _node, _direction);
510         while  ((next != 0) && (_value != next) && ((_value < next) != _direction)) next = self.list[next][_direction];
511         return next;
512     }
513 
514     /**
515      * @dev Creates a bidirectional link between two nodes on direction `_direction`
516      * @param self stored linked list from contract
517      * @param _node first node for linking
518      * @param _link  node to link to in the _direction
519      */
520     function createLink(LinkedList storage self, uint256 _node, uint256 _link, bool _direction) 
521         private {
522         self.list[_link][!_direction] = _node;
523         self.list[_node][_direction] = _link;
524     }
525 
526     /**
527      * @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
528      * @param self stored linked list from contract
529      * @param _node existing node
530      * @param _new  new node to insert
531      * @param _direction direction to insert node in
532      */
533     function insert(LinkedList storage self, uint256 _node, uint256 _new, bool _direction) 
534         internal 
535         returns (bool) {
536         if(!nodeExists(self,_new) && nodeExists(self,_node)) {
537             uint256 c = self.list[_node][_direction];
538             createLink(self, _node, _new, _direction);
539             createLink(self, _new, c, _direction);
540             self.length++;
541             return true;
542         } else {
543             return false;
544         }
545     }
546 
547     /**
548      * @dev removes an entry from the linked list
549      * @param self stored linked list from contract
550      * @param _node node to remove from the list
551      */
552     function remove(LinkedList storage self, uint256 _node) 
553         internal 
554         returns (uint256) {
555         if ((_node == NULL) || (!nodeExists(self,_node))) { 
556             return 0; 
557         }
558         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
559         delete self.list[_node][PREV];
560         delete self.list[_node][NEXT];
561         self.length--;
562         return _node;
563     }
564 
565     /**
566      * @dev pushes an enrty to the head of the linked list
567      * @param self stored linked list from contract
568      * @param _index The node Id
569      * @param _direction push to the head (NEXT) or tail (PREV)
570      */
571     function add(LinkedList storage self, uint256 _index, bool _direction) 
572         internal 
573         returns (uint256) {
574         insert(self, HEAD, _index, _direction);
575         return self.index;
576     }
577 
578     /**
579      * @dev pushes an enrty to the head of the linked list
580      * @param self stored linked list from contract
581      * @param _direction push to the head (NEXT) or tail (PREV)
582      */
583     function push(LinkedList storage self, bool _direction) 
584         internal 
585         returns (uint256) {
586         self.index++;
587         insert(self, HEAD, self.index, _direction);
588         return self.index;
589     }
590 
591     /**
592      * @dev pops the first entry from the linked list
593      * @param self stored linked list from contract
594      * @param _direction pop from the head (NEXT) or the tail (PREV)
595      */
596     function pop(LinkedList storage self, bool _direction) 
597         internal 
598         returns (uint256) {
599         bool exists;
600         uint256 adj;
601         (exists,adj) = getAdjacent(self, HEAD, _direction);
602         return remove(self, adj);
603     }
604 }
605 
606 
607 contract TripioToken {
608     string public name;
609     string public symbol;
610     uint8 public decimals;
611     function transfer(address _to, uint256 _value) public returns (bool);
612     function balanceOf(address who) public view returns (uint256);
613     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
614 }
615 
616 contract TripioRoomNightData is Owned {
617     using LinkedListLib for LinkedListLib.LinkedList;
618     // Interface signature of erc165.
619     // bytes4(keccak256("supportsInterface(bytes4)"))
620     bytes4 constant public interfaceSignature_ERC165 = 0x01ffc9a7;
621 
622     // Interface signature of erc721 metadata.
623     // bytes4(keccak256("name()")) ^ bytes4(keccak256("symbol()")) ^ bytes4(keccak256("tokenURI(uint256)"));
624     bytes4 constant public interfaceSignature_ERC721Metadata = 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd;
625         
626     // Interface signature of erc721.
627     // bytes4(keccak256("balanceOf(address)")) ^
628     // bytes4(keccak256("ownerOf(uint256)")) ^
629     // bytes4(keccak256("safeTransferFrom(address,address,uint256,bytes)")) ^
630     // bytes4(keccak256("safeTransferFrom(address,address,uint256)")) ^
631     // bytes4(keccak256("transferFrom(address,address,uint256)")) ^
632     // bytes4(keccak256("approve(address,uint256)")) ^
633     // bytes4(keccak256("setApprovalForAll(address,bool)")) ^
634     // bytes4(keccak256("getApproved(uint256)")) ^
635     // bytes4(keccak256("isApprovedForAll(address,address)"));
636     bytes4 constant public interfaceSignature_ERC721 = 0x70a08231 ^ 0x6352211e ^ 0xb88d4fde ^ 0x42842e0e ^ 0x23b872dd ^ 0x095ea7b3 ^ 0xa22cb465 ^ 0x081812fc ^ 0xe985e9c5;
637 
638     // Base URI of token asset
639     string public tokenBaseURI;
640 
641     // Authorized contracts
642     struct AuthorizedContract {
643         string name;
644         address acontract;
645     }
646     mapping (address=>uint256) public authorizedContractIds;
647     mapping (uint256 => AuthorizedContract) public authorizedContracts;
648     LinkedListLib.LinkedList public authorizedContractList = LinkedListLib.LinkedList(0, 0);
649 
650     // Rate plan prices
651     struct Price {
652         uint16 inventory;       // Rate plan inventory
653         bool init;              // Whether the price is initied
654         mapping (uint256 => uint256) tokens;
655     }
656 
657     // Vendor hotel RPs
658     struct RatePlan {
659         string name;            // Name of rate plan.
660         uint256 timestamp;      // Create timestamp.
661         bytes32 ipfs;           // The address of rate plan detail on IPFS.
662         Price basePrice;        // The base price of rate plan
663         mapping (uint256 => Price) prices;   // date -> Price
664     }
665 
666     // Vendors
667     struct Vendor {
668         string name;            // Name of vendor.
669         address vendor;         // Address of vendor.
670         uint256 timestamp;      // Create timestamp.
671         bool valid;             // Whether the vendor is valid(default is true)
672         LinkedListLib.LinkedList ratePlanList;
673         mapping (uint256=>RatePlan) ratePlans;
674     }
675     mapping (address => uint256) public vendorIds;
676     mapping (uint256 => Vendor) vendors;
677     LinkedListLib.LinkedList public vendorList = LinkedListLib.LinkedList(0, 0);
678 
679     // Supported digital currencies
680     mapping (uint256 => address) public tokenIndexToAddress;
681     LinkedListLib.LinkedList public tokenList = LinkedListLib.LinkedList(0, 0);
682 
683     // RoomNight tokens
684     struct RoomNight {
685         uint256 vendorId;
686         uint256 rpid;
687         uint256 token;          // The digital currency token 
688         uint256 price;          // The digital currency price
689         uint256 timestamp;      // Create timestamp.
690         uint256 date;           // The checkin date
691         bytes32 ipfs;           // The address of rate plan detail on IPFS.
692     }
693     RoomNight[] public roomnights;
694     // rnid -> owner
695     mapping (uint256 => address) public roomNightIndexToOwner;
696 
697     // Owner Account
698     mapping (address => LinkedListLib.LinkedList) public roomNightOwners;
699 
700     // Vendor Account
701     mapping (address => LinkedListLib.LinkedList) public roomNightVendors;
702 
703     // The authorized address for each TRN
704     mapping (uint256 => address) public roomNightApprovals;
705 
706     // The authorized operators for each address
707     mapping (address => mapping (address => bool)) public operatorApprovals;
708 
709     // The applications of room night redund
710     mapping (address => mapping (uint256 => bool)) public refundApplications;
711 
712     // The signature of `onERC721Received(address,uint256,bytes)`
713     // bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
714     bytes4 constant public ERC721_RECEIVED = 0xf0b9e5ba;
715 
716     /**
717      * This emits when contract authorized
718      */
719     event ContractAuthorized(address _contract);
720 
721     /**
722      * This emits when contract deauthorized
723      */
724     event ContractDeauthorized(address _contract);
725 
726     /**
727      * The contract is valid
728      */
729     modifier authorizedContractValid(address _contract) {
730         require(authorizedContractIds[_contract] > 0);
731         _;
732     }
733 
734     /**
735      * The contract is valid
736      */
737     modifier authorizedContractIdValid(uint256 _cid) {
738         require(authorizedContractList.nodeExists(_cid));
739         _;
740     }
741 
742     /**
743      * Only the owner or authorized contract is valid
744      */
745     modifier onlyOwnerOrAuthorizedContract {
746         require(msg.sender == owner || authorizedContractIds[msg.sender] > 0);
747         _;
748     }
749 
750     /**
751      * Constructor
752      */
753     constructor() public {
754         // Add one invalid RoomNight, avoid subscript 0
755         roomnights.push(RoomNight(0, 0, 0, 0, 0, 0, 0));
756     }
757 
758     /**
759      * @dev Returns the node list and next node as a tuple
760      * @param self stored linked list from contract
761      * @param _node the begin id of the node to get
762      * @param _limit the total nodes of one page
763      * @param _direction direction to step in
764      */
765     function getNodes(LinkedListLib.LinkedList storage self, uint256 _node, uint256 _limit, bool _direction) 
766         private
767         view 
768         returns (uint256[], uint256) {
769         bool exists;
770         uint256 i = 0;
771         uint256 ei = 0;
772         uint256 index = 0;
773         uint256 count = _limit;
774         if(count > self.length) {
775             count = self.length;
776         }
777         (exists, i) = self.getAdjacent(_node, _direction);
778         if(!exists || count == 0) {
779             return (new uint256[](0), 0);
780         }else {
781             uint256[] memory temp = new uint256[](count);
782             if(_node != 0) {
783                 index++;
784                 temp[0] = _node;
785             }
786             while (i != 0 && index < count) {
787                 temp[index] = i;
788                 (exists,i) = self.getAdjacent(i, _direction);
789                 index++;
790             }
791             ei = i;
792             if(index < count) {
793                 uint256[] memory result = new uint256[](index);
794                 for(i = 0; i < index; i++) {
795                     result[i] = temp[i];
796                 }
797                 return (result, ei);
798             }else {
799                 return (temp, ei);
800             }
801         }
802     }
803 
804     /**
805      * @dev Authorize `_contract` to execute this contract's funs
806      * @param _contract The contract address
807      * @param _name The contract name
808      */
809     function authorizeContract(address _contract, string _name) 
810         public 
811         onlyOwner 
812         returns(bool) {
813         uint256 codeSize;
814         assembly { codeSize := extcodesize(_contract) }
815         require(codeSize != 0);
816         // Not exists
817         require(authorizedContractIds[_contract] == 0);
818 
819         // Add
820         uint256 id = authorizedContractList.push(false);
821         authorizedContractIds[_contract] = id;
822         authorizedContracts[id] = AuthorizedContract(_name, _contract);
823 
824         // Event
825         emit ContractAuthorized(_contract);
826         return true;
827     }
828 
829     /**
830      * @dev Deauthorized `_contract` by address
831      * @param _contract The contract address
832      */
833     function deauthorizeContract(address _contract) 
834         public 
835         onlyOwner
836         authorizedContractValid(_contract)
837         returns(bool) {
838         uint256 id = authorizedContractIds[_contract];
839         authorizedContractList.remove(id);
840         authorizedContractIds[_contract] = 0;
841         delete authorizedContracts[id];
842         
843         // Event 
844         emit ContractDeauthorized(_contract);
845         return true;
846     }
847 
848     /**
849      * @dev Deauthorized `_contract` by contract id
850      * @param _cid The contract id
851      */
852     function deauthorizeContractById(uint256 _cid) 
853         public
854         onlyOwner
855         authorizedContractIdValid(_cid)
856         returns(bool) {
857         address acontract = authorizedContracts[_cid].acontract;
858         authorizedContractList.remove(_cid);
859         authorizedContractIds[acontract] = 0;
860         delete authorizedContracts[_cid];
861 
862         // Event 
863         emit ContractDeauthorized(acontract);
864         return true;
865     }
866 
867     /**
868      * @dev Get authorize contract ids by page
869      * @param _from The begin authorize contract id
870      * @param _limit How many authorize contract ids one page
871      * @return The authorize contract ids and the next authorize contract id as tuple, the next page not exists when next eq 0
872      */
873     function getAuthorizeContractIds(uint256 _from, uint256 _limit) 
874         external 
875         view 
876         returns(uint256[], uint256){
877         return getNodes(authorizedContractList, _from, _limit, true);
878     }
879 
880     /**
881      * @dev Get authorize contract by id
882      * @param _cid Then authorize contract id
883      * @return The authorize contract info(_name, _acontract)
884      */
885     function getAuthorizeContract(uint256 _cid) 
886         external 
887         view 
888         returns(string _name, address _acontract) {
889         AuthorizedContract memory acontract = authorizedContracts[_cid]; 
890         _name = acontract.name;
891         _acontract = acontract.acontract;
892     }
893 
894     /*************************************** GET ***************************************/
895 
896     /**
897      * @dev Get the rate plan by `_vendorId` and `_rpid`
898      * @param _vendorId The vendor id
899      * @param _rpid The rate plan id
900      */
901     function getRatePlan(uint256 _vendorId, uint256 _rpid) 
902         public 
903         view 
904         returns (string _name, uint256 _timestamp, bytes32 _ipfs) {
905         _name = vendors[_vendorId].ratePlans[_rpid].name;
906         _timestamp = vendors[_vendorId].ratePlans[_rpid].timestamp;
907         _ipfs = vendors[_vendorId].ratePlans[_rpid].ipfs;
908     }
909 
910     /**
911      * @dev Get the rate plan price by `_vendorId`, `_rpid`, `_date` and `_tokenId`
912      * @param _vendorId The vendor id
913      * @param _rpid The rate plan id
914      * @param _date The date desc (20180723)
915      * @param _tokenId The digital token id
916      * @return The price info(inventory, init, price)
917      */
918     function getPrice(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _tokenId) 
919         public
920         view 
921         returns(uint16 _inventory, bool _init, uint256 _price) {
922         _inventory = vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
923         _init = vendors[_vendorId].ratePlans[_rpid].prices[_date].init;
924         _price = vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId];
925         if(!_init) {
926             // Get the base price
927             _inventory = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
928             _price = vendors[_vendorId].ratePlans[_rpid].basePrice.tokens[_tokenId];
929             _init = vendors[_vendorId].ratePlans[_rpid].basePrice.init;
930         }
931     }
932 
933     /**
934      * @dev Get the rate plan prices by `_vendorId`, `_rpid`, `_dates` and `_tokenId`
935      * @param _vendorId The vendor id
936      * @param _rpid The rate plan id
937      * @param _dates The dates desc ([20180723,20180724,20180725])
938      * @param _tokenId The digital token id
939      * @return The price info(inventory, init, price)
940      */
941     function getPrices(uint256 _vendorId, uint256 _rpid, uint256[] _dates, uint256 _tokenId) 
942         public
943         view 
944         returns(uint16[] _inventories, uint256[] _prices) {
945         uint16[] memory inventories = new uint16[](_dates.length);
946         uint256[] memory prices = new uint256[](_dates.length);
947         uint256 date;
948         for(uint256 i = 0; i < _dates.length; i++) {
949             date = _dates[i];
950             uint16 inventory = vendors[_vendorId].ratePlans[_rpid].prices[date].inventory;
951             bool init = vendors[_vendorId].ratePlans[_rpid].prices[date].init;
952             uint256 price = vendors[_vendorId].ratePlans[_rpid].prices[date].tokens[_tokenId];
953             if(!init) {
954                 // Get the base price
955                 inventory = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
956                 price = vendors[_vendorId].ratePlans[_rpid].basePrice.tokens[_tokenId];
957                 init = vendors[_vendorId].ratePlans[_rpid].basePrice.init;
958             }
959             inventories[i] = inventory;
960             prices[i] = price;
961         }
962         return (inventories, prices);
963     }
964 
965     /**
966      * @dev Get the inventory by  by `_vendorId`, `_rpid` and `_date`
967      * @param _vendorId The vendor id
968      * @param _rpid The rate plan id
969      * @param _date The date desc (20180723)
970      * @return The inventory info(inventory, init)
971      */
972     function getInventory(uint256 _vendorId, uint256 _rpid, uint256 _date) 
973         public
974         view 
975         returns(uint16 _inventory, bool _init) {
976         _inventory = vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
977         _init = vendors[_vendorId].ratePlans[_rpid].prices[_date].init;
978         if(!_init) {
979             // Get the base price
980             _inventory = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
981         }
982     }
983 
984     /**
985      * @dev Whether the rate plan is exist
986      * @param _vendorId The vendor id
987      * @param _rpid The rate plan id
988      * @return If the rate plan of the vendor is exist returns true otherwise return false
989      */
990     function ratePlanIsExist(uint256 _vendorId, uint256 _rpid) 
991         public 
992         view 
993         returns (bool) {
994         return vendors[_vendorId].ratePlanList.nodeExists(_rpid);
995     }
996 
997     /**
998      * @dev Get orders of owner by page
999      * @param _owner The owner address
1000      * @param _from The begin id of the node to get
1001      * @param _limit The total nodes of one page
1002      * @param _direction Direction to step in
1003      * @return The order ids and the next id
1004      */
1005     function getOrdersOfOwner(address _owner, uint256 _from, uint256 _limit, bool _direction) 
1006         public 
1007         view 
1008         returns (uint256[], uint256) {
1009         return getNodes(roomNightOwners[_owner], _from, _limit, _direction);
1010     }
1011 
1012     /**
1013      * @dev Get orders of vendor by page
1014      * @param _owner The vendor address
1015      * @param _from The begin id of the node to get
1016      * @param _limit The total nodes of on page
1017      * @param _direction Direction to step in 
1018      * @return The order ids and the next id
1019      */
1020     function getOrdersOfVendor(address _owner, uint256 _from, uint256 _limit, bool _direction) 
1021         public 
1022         view 
1023         returns (uint256[], uint256) {
1024         return getNodes(roomNightVendors[_owner], _from, _limit, _direction);
1025     }
1026 
1027     /**
1028      * @dev Get the token count of somebody 
1029      * @param _owner The owner of token
1030      * @return The token count of `_owner`
1031      */
1032     function balanceOf(address _owner) 
1033         public 
1034         view 
1035         returns(uint256) {
1036         return roomNightOwners[_owner].length;
1037     }
1038 
1039     /**
1040      * @dev Get rate plan ids of `_vendorId`
1041      * @param _from The begin id of the node to get
1042      * @param _limit The total nodes of on page
1043      * @param _direction Direction to step in 
1044      * @return The rate plan ids and the next id
1045      */
1046     function getRatePlansOfVendor(uint256 _vendorId, uint256 _from, uint256 _limit, bool _direction) 
1047         public 
1048         view 
1049         returns(uint256[], uint256) {
1050         return getNodes(vendors[_vendorId].ratePlanList, _from, _limit, _direction);
1051     }
1052 
1053     /**
1054      * @dev Get token ids
1055      * @param _from The begin id of the node to get
1056      * @param _limit The total nodes of on page
1057      * @param _direction Direction to step in 
1058      * @return The token ids and the next id
1059      */
1060     function getTokens(uint256 _from, uint256 _limit, bool _direction) 
1061         public 
1062         view 
1063         returns(uint256[], uint256) {
1064         return getNodes(tokenList, _from, _limit, _direction);
1065     }
1066 
1067     /**
1068      * @dev Get token Info
1069      * @param _tokenId The token id
1070      * @return The token info(symbol, name, decimals)
1071      */
1072     function getToken(uint256 _tokenId)
1073         public 
1074         view 
1075         returns(string _symbol, string _name, uint8 _decimals, address _token) {
1076         _token = tokenIndexToAddress[_tokenId];
1077         TripioToken tripio = TripioToken(_token);
1078         _symbol = tripio.symbol();
1079         _name = tripio.name();
1080         _decimals = tripio.decimals();
1081     }
1082 
1083     /**
1084      * @dev Get vendor ids
1085      * @param _from The begin id of the node to get
1086      * @param _limit The total nodes of on page
1087      * @param _direction Direction to step in 
1088      * @return The vendor ids and the next id
1089      */
1090     function getVendors(uint256 _from, uint256 _limit, bool _direction) 
1091         public 
1092         view 
1093         returns(uint256[], uint256) {
1094         return getNodes(vendorList, _from, _limit, _direction);
1095     }
1096 
1097     /**
1098      * @dev Get the vendor infomation by vendorId
1099      * @param _vendorId The vendor id
1100      * @return The vendor infomation(name, vendor, timestamp, valid)
1101      */
1102     function getVendor(uint256 _vendorId) 
1103         public 
1104         view 
1105         returns(string _name, address _vendor,uint256 _timestamp, bool _valid) {
1106         _name = vendors[_vendorId].name;
1107         _vendor = vendors[_vendorId].vendor;
1108         _timestamp = vendors[_vendorId].timestamp;
1109         _valid = vendors[_vendorId].valid;
1110     }
1111 
1112     /*************************************** SET ***************************************/
1113     /**
1114      * @dev Update base uri of token metadata
1115      * @param _tokenBaseURI The base uri
1116      */
1117     function updateTokenBaseURI(string _tokenBaseURI) 
1118         public 
1119         onlyOwnerOrAuthorizedContract {
1120         tokenBaseURI = _tokenBaseURI;
1121     }
1122 
1123     /**
1124      * @dev Push order to user's order list
1125      * @param _owner The buyer address
1126      * @param _rnid The room night order id
1127      * @param _direction direction to step in
1128      */
1129     function pushOrderOfOwner(address _owner, uint256 _rnid, bool _direction) 
1130         public 
1131         onlyOwnerOrAuthorizedContract {
1132         if(!roomNightOwners[_owner].listExists()) {
1133             roomNightOwners[_owner] = LinkedListLib.LinkedList(0, 0);
1134         }
1135         roomNightOwners[_owner].add(_rnid, _direction);
1136     }
1137 
1138     /**
1139      * @dev Remove order from owner's order list
1140      * @param _owner The owner address
1141      * @param _rnid The room night order id
1142      */
1143     function removeOrderOfOwner(address _owner, uint _rnid) 
1144         public 
1145         onlyOwnerOrAuthorizedContract {
1146         require(roomNightOwners[_owner].nodeExists(_rnid));
1147         roomNightOwners[_owner].remove(_rnid);
1148     }
1149 
1150     /**
1151      * @dev Push order to the vendor's order list
1152      * @param _vendor The vendor address
1153      * @param _rnid The room night order id
1154      * @param _direction direction to step in
1155      */
1156     function pushOrderOfVendor(address _vendor, uint256 _rnid, bool _direction) 
1157         public 
1158         onlyOwnerOrAuthorizedContract {
1159         if(!roomNightVendors[_vendor].listExists()) {
1160             roomNightVendors[_vendor] = LinkedListLib.LinkedList(0, 0);
1161         }
1162         roomNightVendors[_vendor].add(_rnid, _direction);
1163     }
1164 
1165     /**
1166      * @dev Remove order from vendor's order list
1167      * @param _vendor The vendor address
1168      * @param _rnid The room night order id
1169      */
1170     function removeOrderOfVendor(address _vendor, uint256 _rnid) 
1171         public 
1172         onlyOwnerOrAuthorizedContract {
1173         require(roomNightVendors[_vendor].nodeExists(_rnid));
1174         roomNightVendors[_vendor].remove(_rnid);
1175     }
1176 
1177     /**
1178      * @dev Transfer token to somebody
1179      * @param _tokenId The token id 
1180      * @param _to The target owner of the token
1181      */
1182     function transferTokenTo(uint256 _tokenId, address _to) 
1183         public 
1184         onlyOwnerOrAuthorizedContract {
1185         roomNightIndexToOwner[_tokenId] = _to;
1186         roomNightApprovals[_tokenId] = address(0);
1187     }
1188 
1189     /**
1190      * @dev Approve `_to` to operate the `_tokenId`
1191      * @param _tokenId The token id
1192      * @param _to Somebody to be approved
1193      */
1194     function approveTokenTo(uint256 _tokenId, address _to) 
1195         public 
1196         onlyOwnerOrAuthorizedContract {
1197         roomNightApprovals[_tokenId] = _to;
1198     }
1199 
1200     /**
1201      * @dev Approve `_operator` to operate all the Token of `_to`
1202      * @param _operator The operator to be approved
1203      * @param _to The owner of tokens to be operate
1204      * @param _approved Approved or not
1205      */
1206     function approveOperatorTo(address _operator, address _to, bool _approved) 
1207         public 
1208         onlyOwnerOrAuthorizedContract {
1209         operatorApprovals[_to][_operator] = _approved;
1210     } 
1211 
1212     /**
1213      * @dev Update base price of rate plan
1214      * @param _vendorId The vendor id
1215      * @param _rpid The rate plan id
1216      * @param _tokenId The digital token id
1217      * @param _price The price to be updated
1218      */
1219     function updateBasePrice(uint256 _vendorId, uint256 _rpid, uint256 _tokenId, uint256 _price)
1220         public 
1221         onlyOwnerOrAuthorizedContract {
1222         vendors[_vendorId].ratePlans[_rpid].basePrice.init = true;
1223         vendors[_vendorId].ratePlans[_rpid].basePrice.tokens[_tokenId] = _price;
1224     }
1225 
1226     /**
1227      * @dev Update base inventory of rate plan 
1228      * @param _vendorId The vendor id
1229      * @param _rpid The rate plan id
1230      * @param _inventory The inventory to be updated
1231      */
1232     function updateBaseInventory(uint256 _vendorId, uint256 _rpid, uint16 _inventory)
1233         public 
1234         onlyOwnerOrAuthorizedContract {
1235         vendors[_vendorId].ratePlans[_rpid].basePrice.inventory = _inventory;
1236     }
1237 
1238     /**
1239      * @dev Update price by `_vendorId`, `_rpid`, `_date`, `_tokenId` and `_price`
1240      * @param _vendorId The vendor id
1241      * @param _rpid The rate plan id
1242      * @param _date The date desc (20180723)
1243      * @param _tokenId The digital token id
1244      * @param _price The price to be updated
1245      */
1246     function updatePrice(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _tokenId, uint256 _price)
1247         public
1248         onlyOwnerOrAuthorizedContract {
1249         if (vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1250             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
1251         } else {
1252             vendors[_vendorId].ratePlans[_rpid].prices[_date] = Price(0, true);
1253             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
1254         }
1255     }
1256 
1257     /**
1258      * @dev Update inventory by `_vendorId`, `_rpid`, `_date`, `_inventory`
1259      * @param _vendorId The vendor id
1260      * @param _rpid The rate plan id
1261      * @param _date The date desc (20180723)
1262      * @param _inventory The inventory to be updated
1263      */
1264     function updateInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint16 _inventory)
1265         public 
1266         onlyOwnerOrAuthorizedContract {
1267         if (vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1268             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = _inventory;
1269         } else {
1270             vendors[_vendorId].ratePlans[_rpid].prices[_date] = Price(_inventory, true);
1271         }
1272     }
1273 
1274     /**
1275      * @dev Reduce inventories
1276      * @param _vendorId The vendor id
1277      * @param _rpid The rate plan id
1278      * @param _date The date desc (20180723)
1279      * @param _inventory The amount to be reduced
1280      */
1281     function reduceInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint16 _inventory) 
1282         public  
1283         onlyOwnerOrAuthorizedContract {
1284         uint16 a = 0;
1285         if(vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1286             a = vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
1287             require(_inventory <= a);
1288             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = a - _inventory;
1289         }else if(vendors[_vendorId].ratePlans[_rpid].basePrice.init){
1290             a = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
1291             require(_inventory <= a);
1292             vendors[_vendorId].ratePlans[_rpid].basePrice.inventory = a - _inventory;
1293         }
1294     }
1295 
1296     /**
1297      * @dev Add inventories
1298      * @param _vendorId The vendor id
1299      * @param _rpid The rate plan id
1300      * @param _date The date desc (20180723)
1301      * @param _inventory The amount to be add
1302      */
1303     function addInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint16 _inventory) 
1304         public  
1305         onlyOwnerOrAuthorizedContract {
1306         uint16 c = 0;
1307         if(vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1308             c = _inventory + vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
1309             require(c >= _inventory);
1310             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = c;
1311         }else if(vendors[_vendorId].ratePlans[_rpid].basePrice.init) {
1312             c = _inventory + vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
1313             require(c >= _inventory);
1314             vendors[_vendorId].ratePlans[_rpid].basePrice.inventory = c;
1315         }
1316     }
1317 
1318     /**
1319      * @dev Update inventory and price by `_vendorId`, `_rpid`, `_date`, `_tokenId`, `_price` and `_inventory`
1320      * @param _vendorId The vendor id
1321      * @param _rpid The rate plan id
1322      * @param _date The date desc (20180723)
1323      * @param _tokenId The digital token id
1324      * @param _price The price to be updated
1325      * @param _inventory The inventory to be updated
1326      */
1327     function updatePriceAndInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _tokenId, uint256 _price, uint16 _inventory)
1328         public 
1329         onlyOwnerOrAuthorizedContract {
1330         if (vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1331             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = _inventory;
1332             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
1333         } else {
1334             vendors[_vendorId].ratePlans[_rpid].prices[_date] = Price(_inventory, true);
1335             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
1336         }
1337     }
1338 
1339     /**
1340      * @dev Push rate plan to `_vendorId`'s rate plan list
1341      * @param _vendorId The vendor id
1342      * @param _name The name of rate plan
1343      * @param _ipfs The rate plan IPFS address
1344      * @param _direction direction to step in
1345      */
1346     function pushRatePlan(uint256 _vendorId, string _name, bytes32 _ipfs, bool _direction) 
1347         public 
1348         onlyOwnerOrAuthorizedContract
1349         returns(uint256) {
1350         RatePlan memory rp = RatePlan(_name, uint256(now), _ipfs, Price(0, false));
1351         
1352         uint256 id = vendors[_vendorId].ratePlanList.push(_direction);
1353         vendors[_vendorId].ratePlans[id] = rp;
1354         return id;
1355     }
1356 
1357     /**
1358      * @dev Remove rate plan of `_vendorId` by `_rpid`
1359      * @param _vendorId The vendor id
1360      * @param _rpid The rate plan id
1361      */
1362     function removeRatePlan(uint256 _vendorId, uint256 _rpid) 
1363         public 
1364         onlyOwnerOrAuthorizedContract {
1365         delete vendors[_vendorId].ratePlans[_rpid];
1366         vendors[_vendorId].ratePlanList.remove(_rpid);
1367     }
1368 
1369     /**
1370      * @dev Update `_rpid` of `_vendorId` by `_name` and `_ipfs`
1371      * @param _vendorId The vendor id
1372      * @param _rpid The rate plan id
1373      * @param _name The rate plan name
1374      * @param _ipfs The rate plan IPFS address
1375      */
1376     function updateRatePlan(uint256 _vendorId, uint256 _rpid, string _name, bytes32 _ipfs)
1377         public 
1378         onlyOwnerOrAuthorizedContract {
1379         vendors[_vendorId].ratePlans[_rpid].ipfs = _ipfs;
1380         vendors[_vendorId].ratePlans[_rpid].name = _name;
1381     }
1382     
1383     /**
1384      * @dev Push token contract to the token list
1385      * @param _direction direction to step in
1386      */
1387     function pushToken(address _contract, bool _direction)
1388         public 
1389         onlyOwnerOrAuthorizedContract 
1390         returns(uint256) {
1391         uint256 id = tokenList.push(_direction);
1392         tokenIndexToAddress[id] = _contract;
1393         return id;
1394     }
1395 
1396     /**
1397      * @dev Remove token by `_tokenId`
1398      * @param _tokenId The digital token id
1399      */
1400     function removeToken(uint256 _tokenId) 
1401         public 
1402         onlyOwnerOrAuthorizedContract {
1403         delete tokenIndexToAddress[_tokenId];
1404         tokenList.remove(_tokenId);
1405     }
1406 
1407     /**
1408      * @dev Generate room night token
1409      * @param _vendorId The vendor id
1410      * @param _rpid The rate plan id
1411      * @param _date The date desc (20180723)
1412      * @param _token The token id
1413      * @param _price The token price
1414      * @param _ipfs The rate plan IPFS address
1415      */
1416     function generateRoomNightToken(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _token, uint256 _price, bytes32 _ipfs)
1417         public 
1418         onlyOwnerOrAuthorizedContract 
1419         returns(uint256) {
1420         roomnights.push(RoomNight(_vendorId, _rpid, _token, _price, now, _date, _ipfs));
1421 
1422         // Give the token to `_customer`
1423         uint256 rnid = uint256(roomnights.length - 1);
1424         return rnid;
1425     }
1426 
1427     /**
1428      * @dev Update refund applications
1429      * @param _buyer The room night token holder
1430      * @param _rnid The room night token id
1431      * @param _isRefund Is redund or not
1432      */
1433     function updateRefundApplications(address _buyer, uint256 _rnid, bool _isRefund) 
1434         public 
1435         onlyOwnerOrAuthorizedContract {
1436         refundApplications[_buyer][_rnid] = _isRefund;
1437     }
1438 
1439     /**
1440      * @dev Push vendor info to the vendor list
1441      * @param _name The name of vendor
1442      * @param _vendor The vendor address
1443      * @param _direction direction to step in
1444      */
1445     function pushVendor(string _name, address _vendor, bool _direction)
1446         public 
1447         onlyOwnerOrAuthorizedContract 
1448         returns(uint256) {
1449         uint256 id = vendorList.push(_direction);
1450         vendorIds[_vendor] = id;
1451         vendors[id] = Vendor(_name, _vendor, uint256(now), true, LinkedListLib.LinkedList(0, 0));
1452         return id;
1453     }
1454 
1455     /**
1456      * @dev Remove vendor from vendor list
1457      * @param _vendorId The vendor id
1458      */
1459     function removeVendor(uint256 _vendorId) 
1460         public 
1461         onlyOwnerOrAuthorizedContract {
1462         vendorList.remove(_vendorId);
1463         address vendor = vendors[_vendorId].vendor;
1464         vendorIds[vendor] = 0;
1465         delete vendors[_vendorId];
1466     }
1467 
1468     /**
1469      * @dev Make vendor valid or invalid
1470      * @param _vendorId The vendor id
1471      * @param _valid The vendor is valid or not
1472      */
1473     function updateVendorValid(uint256 _vendorId, bool _valid)
1474         public 
1475         onlyOwnerOrAuthorizedContract {
1476         vendors[_vendorId].valid = _valid;
1477     }
1478 
1479     /**
1480      * @dev Modify vendor's name
1481      * @param _vendorId The vendor id
1482      * @param _name Then vendor name
1483      */
1484     function updateVendorName(uint256 _vendorId, string _name)
1485         public 
1486         onlyOwnerOrAuthorizedContract {
1487         vendors[_vendorId].name = _name;
1488     }
1489 }
1490 
1491 
1492 contract TRNRatePlans is TRNData {
1493     /**
1494      * Constructor
1495      */
1496     constructor() public {
1497 
1498     }
1499 
1500     /**
1501      * This emits when rate plan created
1502      */
1503     event RatePlanCreated(address indexed _vendor, string _name, bytes32 indexed _ipfs);
1504 
1505     /**
1506      * This emits when rate plan removed
1507      */
1508     event RatePlanRemoved(address indexed _vendor, uint256 indexed _rpid);
1509 
1510     /**
1511      * This emits when rate plan modified
1512      */
1513     event RatePlanModified(address indexed _vendor, uint256 indexed _rpid, string name, bytes32 _ipfs);
1514 
1515     /**
1516      * @dev Create rate plan
1517      *      Only vendor can operate
1518      *      Throw when `_name`'s length lte 0 or mte 100.
1519      * @param _name The name of rate plan
1520      * @param _ipfs The address of the rate plan detail info on IPFS.
1521      */
1522     function createRatePlan(string _name, bytes32 _ipfs) 
1523         external 
1524         // onlyVendor 
1525         returns(uint256) {
1526         // if vendor not exist create it
1527         if(dataSource.vendorIds(msg.sender) == 0) {
1528             dataSource.pushVendor("", msg.sender, false);
1529         }
1530         bytes memory nameBytes = bytes(_name);
1531         require(nameBytes.length > 0 && nameBytes.length < 200);
1532     
1533         uint256 vendorId = dataSource.vendorIds(msg.sender);
1534         uint256 id = dataSource.pushRatePlan(vendorId, _name, _ipfs, false);
1535         
1536         // Event 
1537         emit RatePlanCreated(msg.sender, _name, _ipfs);
1538 
1539         return id;
1540     }
1541     
1542     /**
1543      * @dev Remove rate plan
1544      *      Only vendor can operate
1545      *      Throw when `_rpid` not exist
1546      * @param _rpid The rate plan identifier
1547      */
1548     function removeRatePlan(uint256 _rpid) 
1549         external 
1550         onlyVendor 
1551         ratePlanExist(dataSource.vendorIds(msg.sender), _rpid) 
1552         returns(bool) {
1553         uint256 vendorId = dataSource.vendorIds(msg.sender);
1554 
1555         // Delete rate plan
1556         dataSource.removeRatePlan(vendorId, _rpid);
1557         
1558         // Event 
1559         emit RatePlanRemoved(msg.sender, _rpid);
1560         return true;
1561     }
1562 
1563     /**
1564      * @dev Modify rate plan
1565      *      Throw when `_rpid` not exist
1566      * @param _rpid The rate plan identifier
1567      * @param _ipfs The address of the rate plan detail info on IPFS
1568      */
1569     function modifyRatePlan(uint256 _rpid, string _name, bytes32 _ipfs) 
1570         external 
1571         onlyVendor 
1572         ratePlanExist(dataSource.vendorIds(msg.sender), _rpid) 
1573         returns(bool) {
1574 
1575         uint256 vendorId = dataSource.vendorIds(msg.sender);
1576         dataSource.updateRatePlan(vendorId, _rpid, _name, _ipfs);
1577 
1578         // Event 
1579         emit RatePlanModified(msg.sender, _rpid, _name, _ipfs);
1580         return true;
1581     }
1582 
1583     /**
1584      * @dev Returns a list of all rate plan IDs assigned to a vendor.
1585      * @param _vendorId The Id of vendor
1586      * @param _from The begin ratePlan Id
1587      * @param _limit How many ratePlan Ids one page 
1588      * @return A list of all rate plan IDs assigned to a vendor
1589      */
1590     function ratePlansOfVendor(uint256 _vendorId, uint256 _from, uint256 _limit) 
1591         external
1592         view
1593         vendorIdValid(_vendorId)  
1594         returns(uint256[], uint256) {
1595         return dataSource.getRatePlansOfVendor(_vendorId, _from, _limit, true);
1596     }
1597 
1598     /**
1599      * @dev Returns ratePlan info of vendor
1600      * @param _vendorId The address of vendor
1601      * @param _rpid The ratePlan id
1602      * @return The ratePlan info(_name, _timestamp, _ipfs)
1603      */
1604     function ratePlanOfVendor(uint256 _vendorId, uint256 _rpid) 
1605         external 
1606         view 
1607         vendorIdValid(_vendorId) 
1608         returns(string _name, uint256 _timestamp, bytes32 _ipfs) {
1609         (_name, _timestamp, _ipfs) = dataSource.getRatePlan(_vendorId, _rpid);
1610     }
1611 }
1612 
1613 contract TripioRoomNightVendor is TRNPrices, TRNRatePlans {
1614     /**
1615      * Constructor
1616      */
1617     constructor(address _dataSource) public {
1618         // Init the data source
1619         dataSource = TripioRoomNightData(_dataSource);
1620     }
1621     
1622     /**
1623      * @dev Destory the contract
1624      */
1625     function destroy() external onlyOwner {
1626         selfdestruct(owner);
1627     }
1628 }