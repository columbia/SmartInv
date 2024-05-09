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
45 contract TRNData is Owned {
46     TripioRoomNightData dataSource;
47     /**
48      * Only the valid vendor and the vendor is valid
49      */ 
50     modifier onlyVendor {
51         uint256 vendorId = dataSource.vendorIds(msg.sender);
52         require(vendorId > 0);
53         (,,,bool valid) = dataSource.getVendor(vendorId);
54         require(valid);
55         _;
56     }
57 
58     /**
59      * The vendor is valid
60      */
61     modifier vendorValid(address _vendor) {
62         uint256 vendorId = dataSource.vendorIds(_vendor);
63         require(vendorId > 0);
64         (,,,bool valid) = dataSource.getVendor(vendorId);
65         require(valid);
66         _;
67     }
68 
69     /**
70      * The vendorId is valid
71      */
72     modifier vendorIdValid(uint256 _vendorId) {
73         (,,,bool valid) = dataSource.getVendor(_vendorId);
74         require(valid);
75         _;
76     }
77 
78     /**
79      * Rate plan exist.
80      */
81     modifier ratePlanExist(uint256 _vendorId, uint256 _rpid) {
82         (,,,bool valid) = dataSource.getVendor(_vendorId);
83         require(valid);
84         require(dataSource.ratePlanIsExist(_vendorId, _rpid));
85         _;
86     }
87     
88     /**
89      * Token is valid
90      */
91     modifier validToken(uint256 _tokenId) {
92         require(_tokenId > 0);
93         require(dataSource.roomNightIndexToOwner(_tokenId) != address(0));
94         _;
95     }
96 
97     /**
98      * Tokens are valid
99      */
100     modifier validTokenInBatch(uint256[] _tokenIds) {
101         for(uint256 i = 0; i < _tokenIds.length; i++) {
102             require(_tokenIds[i] > 0);
103             require(dataSource.roomNightIndexToOwner(_tokenIds[i]) != address(0));
104         }
105         _;
106     }
107 
108     /**
109      * Whether the `_tokenId` can be transfered
110      */
111     modifier canTransfer(uint256 _tokenId) {
112         address owner = dataSource.roomNightIndexToOwner(_tokenId);
113         bool isOwner = (msg.sender == owner);
114         bool isApproval = (msg.sender == dataSource.roomNightApprovals(_tokenId));
115         bool isOperator = (dataSource.operatorApprovals(owner, msg.sender));
116         require(isOwner || isApproval || isOperator);
117         _;
118     }
119 
120     /**
121      * Whether the `_tokenIds` can be transfered
122      */
123     modifier canTransferInBatch(uint256[] _tokenIds) {
124         for(uint256 i = 0; i < _tokenIds.length; i++) {
125             address owner = dataSource.roomNightIndexToOwner(_tokenIds[i]);
126             bool isOwner = (msg.sender == owner);
127             bool isApproval = (msg.sender == dataSource.roomNightApprovals(_tokenIds[i]));
128             bool isOperator = (dataSource.operatorApprovals(owner, msg.sender));
129             require(isOwner || isApproval || isOperator);
130         }
131         _;
132     }
133 
134 
135     /**
136      * Whether the `_tokenId` can be operated by `msg.sender`
137      */
138     modifier canOperate(uint256 _tokenId) {
139         address owner = dataSource.roomNightIndexToOwner(_tokenId);
140         bool isOwner = (msg.sender == owner);
141         bool isOperator = (dataSource.operatorApprovals(owner, msg.sender));
142         require(isOwner || isOperator);
143         _;
144     }
145 
146     /**
147      * Whether the `_date` is valid(no hours, no seconds)
148      */
149     modifier validDate(uint256 _date) {
150         require(_date > 0);
151         require(dateIsLegal(_date));
152         _;
153     }
154 
155     /**
156      * Whether the `_dates` are valid(no hours, no seconds)
157      */
158     modifier validDates(uint256[] _dates) {
159         for(uint256 i = 0;i < _dates.length; i++) {
160             require(_dates[i] > 0);
161             require(dateIsLegal(_dates[i]));
162         }
163         _;
164     }
165 
166     function dateIsLegal(uint256 _date) pure private returns(bool) {
167         uint256 year = _date / 10000;
168         uint256 mon = _date / 100 - year * 100;
169         uint256 day = _date - mon * 100 - year * 10000;
170         
171         if(year < 1970 || mon <= 0 || mon > 12 || day <= 0 || day > 31)
172             return false;
173 
174         if(4 == mon || 6 == mon || 9 == mon || 11 == mon){
175             if (day == 31) {
176                 return false;
177             }
178         }
179         if(((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
180             if(2 == mon && day > 29) {
181                 return false;
182             }
183         }else {
184             if(2 == mon && day > 28){
185                 return false;
186             }
187         }
188         return true;
189     }
190     /**
191      * Constructor
192      */
193     constructor() public {
194 
195     }
196 }
197 contract TRNVendors is TRNData {
198     
199     /**
200      * Constructor
201      */
202     constructor() public {
203 
204     }
205 
206     /**
207      * This emits when vendor is added
208      */
209     event VendorAdded(address indexed _vendor, string _name);
210 
211     /**
212      * This emits when vendor is removed
213      */
214     event VendorRemoved(address indexed _vendor);
215 
216     /**
217      * This emits when vendor's validation is changed
218      */
219     event VendorValid(address indexed _vendor, bool _valid);
220 
221     /**
222      * This emits when vendor's name is updated
223      */
224     event VendorUpdated(address indexed _vendor, string _name);
225 
226     /**
227      * @dev Add vendor to the system.
228      *      Only owner can operate
229      *      Throw when `_vendor` is equal to `address(0)`
230      *      Throw unless `_vendor` not exist.
231      *      Throw when `_name`'s length lte 0 or mte 100.
232      * @param _vendor The address of vendor
233      * @param _name The name of vendor
234      * @return Success
235      */
236     function addVendor(address _vendor, string _name) 
237         external 
238         onlyOwner 
239         returns(bool) {
240         // _vendor is valid address
241         require(_vendor != address(0));
242         // _vendor not exists
243         require(dataSource.vendorIds(_vendor) == 0);
244         // The length of _name between 0 and 1000
245         bytes memory nameBytes = bytes(_name);
246         require(nameBytes.length > 0 && nameBytes.length < 200);
247 
248         dataSource.pushVendor(_name, _vendor, false);
249     
250         // Event
251         emit VendorAdded(_vendor, _name);
252         return true;
253     }
254 
255     /**
256      * @dev Remove vendor from the system by address.
257      *      Only owner can operate
258      * @param _vendor The address of vendor
259      * @return Success
260      */
261     function removeVendorByAddress(address _vendor) 
262         public 
263         onlyOwner 
264         returns(bool) {
265         // _vendor exists
266         uint256 id = dataSource.vendorIds(_vendor);
267         require(id > 0);
268         
269         dataSource.removeVendor(id);
270         // Event
271         emit VendorRemoved(_vendor);
272         return true;
273     }
274 
275     /**
276      * @dev Remove vendor from the system by Id
277      *      Only owner can operate
278      * @param _vendorId The id of vendor
279      */
280     function removeVendorById(uint256 _vendorId) 
281         external 
282         onlyOwner 
283         returns(bool) {
284         (,address vendor,,) = dataSource.getVendor(_vendorId);
285         return removeVendorByAddress(vendor);
286     }
287 
288     /**
289      * @dev Change the `_vendorId`'s validation
290      *      Only owner can operate
291      * @param _vendorId The id of vendor
292      * @param _valid The validation of vendor
293      * @return Success
294      */
295     function makeVendorValid(uint256 _vendorId, bool _valid) 
296         external 
297         onlyOwner 
298         returns(bool) {
299         (,address vendor,,) = dataSource.getVendor(_vendorId);
300         require(dataSource.vendorIds(vendor) > 0);
301         dataSource.updateVendorValid(_vendorId, _valid);
302         
303         // Event
304         emit VendorValid(vendor, _valid);
305         return true;
306     }
307 
308     /**
309      * @dev Update the `_vendorId`'s name
310      *      Only owner can operate
311      * @param _vendorId Then id of vendor
312      * @param _name The name of vendor
313      * @return Success
314      */
315     function updateVendorName(uint256 _vendorId, string _name) 
316         external
317         onlyOwner
318         returns(bool) {
319         (,address vendor,,) = dataSource.getVendor(_vendorId);
320         require(dataSource.vendorIds(vendor) > 0);
321         // The length of _name between 0 and 1000
322         bytes memory nameBytes = bytes(_name);
323         require(nameBytes.length > 0 && nameBytes.length < 200);
324         dataSource.updateVendorName(_vendorId, _name);
325 
326         // Event
327         emit VendorUpdated(vendor, _name);
328         return true;
329     }
330 
331     /**
332      * @dev Get Vendor ids by page
333      * @param _from The begin vendorId
334      * @param _limit How many vendorIds one page
335      * @return The vendorIds and the next vendorId as tuple, the next page not exists when next eq 0
336      */
337     function getVendorIds(uint256 _from, uint256 _limit) 
338         external 
339         view 
340         returns(uint256[], uint256){
341         return dataSource.getVendors(_from, _limit, true);
342     }
343 
344     /**
345      * @dev Get Vendor by id
346      * @param _vendorId Then vendor id
347      * @return The vendor info(_name, _vendor, _timestamp, _valid)
348      */
349     function getVendor(uint256 _vendorId) 
350         external 
351         view 
352         returns(string _name, address _vendor, uint256 _timestamp, bool _valid) {
353         (_name, _vendor, _timestamp, _valid) = dataSource.getVendor(_vendorId);
354     }
355 
356     /**
357      * @dev Get Vendor by address\
358      * @param _vendor Then vendor address
359      * @return Then vendor info(_vendorId, _name, _timestamp, _valid)
360      */
361     function getVendorByAddress(address _vendor) 
362         external 
363         view
364         returns(uint256 _vendorId, string _name, uint256 _timestamp, bool _valid) {
365         _vendorId = dataSource.vendorIds(_vendor);
366         (_name,, _timestamp, _valid) = dataSource.getVendor(_vendorId);
367     }
368 }
369 
370 contract TRNTokens is TRNData {
371     /**
372      * Constructor
373      */
374     constructor() public {
375 
376     }
377     /**
378      * This emits when token contract is added
379      */
380     event TokenAdded(address indexed _token);
381 
382     /**
383      * This emits when token contract is removed
384      */
385     event TokenRemoved(uint256 _index);
386 
387     /**
388      * @dev Add supported digital currency token
389      *      Only owner can operate
390      * @param _contract The address of digital currency contract
391      */
392     function addToken(address _contract) 
393         external 
394         onlyOwner 
395         returns(uint256) {
396         require(_contract != address(0));
397         uint256 id = dataSource.pushToken(_contract, false);
398         // Event 
399         emit TokenAdded(_contract);
400         return id;
401     }
402 
403     /**
404      * @dev Remove digital currency token
405      *      Only owner can operate
406      * @param _tokenId The index of digital currency contract
407      */
408     function removeToken(uint256 _tokenId) 
409         external 
410         onlyOwner 
411         returns(bool){
412         require(dataSource.tokenIndexToAddress(_tokenId) != address(0));
413         dataSource.removeToken(_tokenId);
414         // Event
415         emit TokenRemoved(_tokenId);
416         return true;
417     }
418 
419     /**
420      * @dev Returns all the supported digital currency tokens
421      * @param _from The begin tokenId
422      * @param _limit How many tokenIds one page 
423      * @return All the supported digital currency tokens
424      */
425 
426     function supportedTokens(uint256 _from, uint256 _limit) 
427         external 
428         view 
429         returns(uint256[], uint256) {
430         return dataSource.getTokens(_from, _limit, true);
431     }
432 
433     /**
434      * @dev Return the token info
435      * @param _tokenId The token Id
436      * @return The token info(symbol, name, decimals)
437      */
438     function getToken(uint256 _tokenId) 
439         external
440         view 
441         returns(string _symbol, string _name, uint8 _decimals, address _token) {
442         return dataSource.getToken(_tokenId);
443     }
444 }
445 
446 
447 /**
448  * This utility library was forked from https://github.com/o0ragman0o/LibCLL
449  */
450 library LinkedListLib {
451 
452     uint256 constant NULL = 0;
453     uint256 constant HEAD = 0;
454     bool constant PREV = false;
455     bool constant NEXT = true;
456 
457     struct LinkedList {
458         mapping (uint256 => mapping (bool => uint256)) list;
459         uint256 length;
460         uint256 index;
461     }
462 
463     /**
464      * @dev returns true if the list exists
465      * @param self stored linked list from contract
466      */
467     function listExists(LinkedList storage self)
468         internal
469         view returns (bool) {
470         return self.length > 0;
471     }
472 
473     /**
474      * @dev returns true if the node exists
475      * @param self stored linked list from contract
476      * @param _node a node to search for
477      */
478     function nodeExists(LinkedList storage self, uint256 _node)
479         internal
480         view returns (bool) {
481         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
482             if (self.list[HEAD][NEXT] == _node) {
483                 return true;
484             } else {
485                 return false;
486             }
487         } else {
488             return true;
489         }
490     }
491 
492     /**
493      * @dev Returns the number of elements in the list
494      * @param self stored linked list from contract
495      */ 
496     function sizeOf(LinkedList storage self) 
497         internal 
498         view 
499         returns (uint256 numElements) {
500         return self.length;
501     }
502 
503     /**
504      * @dev Returns the links of a node as a tuple
505      * @param self stored linked list from contract
506      * @param _node id of the node to get
507      */
508     function getNode(LinkedList storage self, uint256 _node)
509         public 
510         view 
511         returns (bool, uint256, uint256) {
512         if (!nodeExists(self,_node)) {
513             return (false, 0, 0);
514         } else {
515             return (true, self.list[_node][PREV], self.list[_node][NEXT]);
516         }
517     }
518 
519     /**
520      * @dev Returns the link of a node `_node` in direction `_direction`.
521      * @param self stored linked list from contract
522      * @param _node id of the node to step from
523      * @param _direction direction to step in
524      */
525     function getAdjacent(LinkedList storage self, uint256 _node, bool _direction)
526         public 
527         view 
528         returns (bool, uint256) {
529         if (!nodeExists(self,_node)) {
530             return (false,0);
531         } else {
532             return (true,self.list[_node][_direction]);
533         }
534     }
535 
536     /**
537      * @dev Can be used before `insert` to build an ordered list
538      * @param self stored linked list from contract
539      * @param _node an existing node to search from, e.g. HEAD.
540      * @param _value value to seek
541      * @param _direction direction to seek in
542      * @return next first node beyond '_node' in direction `_direction`
543      */
544     function getSortedSpot(LinkedList storage self, uint256 _node, uint256 _value, bool _direction)
545         public 
546         view 
547         returns (uint256) {
548         if (sizeOf(self) == 0) { 
549             return 0; 
550         }
551         require((_node == 0) || nodeExists(self,_node));
552         bool exists;
553         uint256 next;
554         (exists,next) = getAdjacent(self, _node, _direction);
555         while  ((next != 0) && (_value != next) && ((_value < next) != _direction)) next = self.list[next][_direction];
556         return next;
557     }
558 
559     /**
560      * @dev Creates a bidirectional link between two nodes on direction `_direction`
561      * @param self stored linked list from contract
562      * @param _node first node for linking
563      * @param _link  node to link to in the _direction
564      */
565     function createLink(LinkedList storage self, uint256 _node, uint256 _link, bool _direction) 
566         private {
567         self.list[_link][!_direction] = _node;
568         self.list[_node][_direction] = _link;
569     }
570 
571     /**
572      * @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
573      * @param self stored linked list from contract
574      * @param _node existing node
575      * @param _new  new node to insert
576      * @param _direction direction to insert node in
577      */
578     function insert(LinkedList storage self, uint256 _node, uint256 _new, bool _direction) 
579         internal 
580         returns (bool) {
581         if(!nodeExists(self,_new) && nodeExists(self,_node)) {
582             uint256 c = self.list[_node][_direction];
583             createLink(self, _node, _new, _direction);
584             createLink(self, _new, c, _direction);
585             self.length++;
586             return true;
587         } else {
588             return false;
589         }
590     }
591 
592     /**
593      * @dev removes an entry from the linked list
594      * @param self stored linked list from contract
595      * @param _node node to remove from the list
596      */
597     function remove(LinkedList storage self, uint256 _node) 
598         internal 
599         returns (uint256) {
600         if ((_node == NULL) || (!nodeExists(self,_node))) { 
601             return 0; 
602         }
603         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
604         delete self.list[_node][PREV];
605         delete self.list[_node][NEXT];
606         self.length--;
607         return _node;
608     }
609 
610     /**
611      * @dev pushes an enrty to the head of the linked list
612      * @param self stored linked list from contract
613      * @param _index The node Id
614      * @param _direction push to the head (NEXT) or tail (PREV)
615      */
616     function add(LinkedList storage self, uint256 _index, bool _direction) 
617         internal 
618         returns (uint256) {
619         insert(self, HEAD, _index, _direction);
620         return self.index;
621     }
622 
623     /**
624      * @dev pushes an enrty to the head of the linked list
625      * @param self stored linked list from contract
626      * @param _direction push to the head (NEXT) or tail (PREV)
627      */
628     function push(LinkedList storage self, bool _direction) 
629         internal 
630         returns (uint256) {
631         self.index++;
632         insert(self, HEAD, self.index, _direction);
633         return self.index;
634     }
635 
636     /**
637      * @dev pops the first entry from the linked list
638      * @param self stored linked list from contract
639      * @param _direction pop from the head (NEXT) or the tail (PREV)
640      */
641     function pop(LinkedList storage self, bool _direction) 
642         internal 
643         returns (uint256) {
644         bool exists;
645         uint256 adj;
646         (exists,adj) = getAdjacent(self, HEAD, _direction);
647         return remove(self, adj);
648     }
649 }
650 
651 contract TripioToken {
652     string public name;
653     string public symbol;
654     uint8 public decimals;
655     function transfer(address _to, uint256 _value) public returns (bool);
656     function balanceOf(address who) public view returns (uint256);
657     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
658 }
659 contract TripioRoomNightData is Owned {
660     using LinkedListLib for LinkedListLib.LinkedList;
661     // Interface signature of erc165.
662     // bytes4(keccak256("supportsInterface(bytes4)"))
663     bytes4 constant public interfaceSignature_ERC165 = 0x01ffc9a7;
664 
665     // Interface signature of erc721 metadata.
666     // bytes4(keccak256("name()")) ^ bytes4(keccak256("symbol()")) ^ bytes4(keccak256("tokenURI(uint256)"));
667     bytes4 constant public interfaceSignature_ERC721Metadata = 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd;
668         
669     // Interface signature of erc721.
670     // bytes4(keccak256("balanceOf(address)")) ^
671     // bytes4(keccak256("ownerOf(uint256)")) ^
672     // bytes4(keccak256("safeTransferFrom(address,address,uint256,bytes)")) ^
673     // bytes4(keccak256("safeTransferFrom(address,address,uint256)")) ^
674     // bytes4(keccak256("transferFrom(address,address,uint256)")) ^
675     // bytes4(keccak256("approve(address,uint256)")) ^
676     // bytes4(keccak256("setApprovalForAll(address,bool)")) ^
677     // bytes4(keccak256("getApproved(uint256)")) ^
678     // bytes4(keccak256("isApprovedForAll(address,address)"));
679     bytes4 constant public interfaceSignature_ERC721 = 0x70a08231 ^ 0x6352211e ^ 0xb88d4fde ^ 0x42842e0e ^ 0x23b872dd ^ 0x095ea7b3 ^ 0xa22cb465 ^ 0x081812fc ^ 0xe985e9c5;
680 
681     // Base URI of token asset
682     string public tokenBaseURI;
683 
684     // Authorized contracts
685     struct AuthorizedContract {
686         string name;
687         address acontract;
688     }
689     mapping (address=>uint256) public authorizedContractIds;
690     mapping (uint256 => AuthorizedContract) public authorizedContracts;
691     LinkedListLib.LinkedList public authorizedContractList = LinkedListLib.LinkedList(0, 0);
692 
693     // Rate plan prices
694     struct Price {
695         uint16 inventory;       // Rate plan inventory
696         bool init;              // Whether the price is initied
697         mapping (uint256 => uint256) tokens;
698     }
699 
700     // Vendor hotel RPs
701     struct RatePlan {
702         string name;            // Name of rate plan.
703         uint256 timestamp;      // Create timestamp.
704         bytes32 ipfs;           // The address of rate plan detail on IPFS.
705         Price basePrice;        // The base price of rate plan
706         mapping (uint256 => Price) prices;   // date -> Price
707     }
708 
709     // Vendors
710     struct Vendor {
711         string name;            // Name of vendor.
712         address vendor;         // Address of vendor.
713         uint256 timestamp;      // Create timestamp.
714         bool valid;             // Whether the vendor is valid(default is true)
715         LinkedListLib.LinkedList ratePlanList;
716         mapping (uint256=>RatePlan) ratePlans;
717     }
718     mapping (address => uint256) public vendorIds;
719     mapping (uint256 => Vendor) vendors;
720     LinkedListLib.LinkedList public vendorList = LinkedListLib.LinkedList(0, 0);
721 
722     // Supported digital currencies
723     mapping (uint256 => address) public tokenIndexToAddress;
724     LinkedListLib.LinkedList public tokenList = LinkedListLib.LinkedList(0, 0);
725 
726     // RoomNight tokens
727     struct RoomNight {
728         uint256 vendorId;
729         uint256 rpid;
730         uint256 token;          // The digital currency token 
731         uint256 price;          // The digital currency price
732         uint256 timestamp;      // Create timestamp.
733         uint256 date;           // The checkin date
734         bytes32 ipfs;           // The address of rate plan detail on IPFS.
735     }
736     RoomNight[] public roomnights;
737     // rnid -> owner
738     mapping (uint256 => address) public roomNightIndexToOwner;
739 
740     // Owner Account
741     mapping (address => LinkedListLib.LinkedList) public roomNightOwners;
742 
743     // Vendor Account
744     mapping (address => LinkedListLib.LinkedList) public roomNightVendors;
745 
746     // The authorized address for each TRN
747     mapping (uint256 => address) public roomNightApprovals;
748 
749     // The authorized operators for each address
750     mapping (address => mapping (address => bool)) public operatorApprovals;
751 
752     // The applications of room night redund
753     mapping (address => mapping (uint256 => bool)) public refundApplications;
754 
755     // The signature of `onERC721Received(address,uint256,bytes)`
756     // bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
757     bytes4 constant public ERC721_RECEIVED = 0xf0b9e5ba;
758 
759     /**
760      * This emits when contract authorized
761      */
762     event ContractAuthorized(address _contract);
763 
764     /**
765      * This emits when contract deauthorized
766      */
767     event ContractDeauthorized(address _contract);
768 
769     /**
770      * The contract is valid
771      */
772     modifier authorizedContractValid(address _contract) {
773         require(authorizedContractIds[_contract] > 0);
774         _;
775     }
776 
777     /**
778      * The contract is valid
779      */
780     modifier authorizedContractIdValid(uint256 _cid) {
781         require(authorizedContractList.nodeExists(_cid));
782         _;
783     }
784 
785     /**
786      * Only the owner or authorized contract is valid
787      */
788     modifier onlyOwnerOrAuthorizedContract {
789         require(msg.sender == owner || authorizedContractIds[msg.sender] > 0);
790         _;
791     }
792 
793     /**
794      * Constructor
795      */
796     constructor() public {
797         // Add one invalid RoomNight, avoid subscript 0
798         roomnights.push(RoomNight(0, 0, 0, 0, 0, 0, 0));
799     }
800 
801     /**
802      * @dev Returns the node list and next node as a tuple
803      * @param self stored linked list from contract
804      * @param _node the begin id of the node to get
805      * @param _limit the total nodes of one page
806      * @param _direction direction to step in
807      */
808     function getNodes(LinkedListLib.LinkedList storage self, uint256 _node, uint256 _limit, bool _direction) 
809         private
810         view 
811         returns (uint256[], uint256) {
812         bool exists;
813         uint256 i = 0;
814         uint256 ei = 0;
815         uint256 index = 0;
816         uint256 count = _limit;
817         if(count > self.length) {
818             count = self.length;
819         }
820         (exists, i) = self.getAdjacent(_node, _direction);
821         if(!exists || count == 0) {
822             return (new uint256[](0), 0);
823         }else {
824             uint256[] memory temp = new uint256[](count);
825             if(_node != 0) {
826                 index++;
827                 temp[0] = _node;
828             }
829             while (i != 0 && index < count) {
830                 temp[index] = i;
831                 (exists,i) = self.getAdjacent(i, _direction);
832                 index++;
833             }
834             ei = i;
835             if(index < count) {
836                 uint256[] memory result = new uint256[](index);
837                 for(i = 0; i < index; i++) {
838                     result[i] = temp[i];
839                 }
840                 return (result, ei);
841             }else {
842                 return (temp, ei);
843             }
844         }
845     }
846 
847     /**
848      * @dev Authorize `_contract` to execute this contract's funs
849      * @param _contract The contract address
850      * @param _name The contract name
851      */
852     function authorizeContract(address _contract, string _name) 
853         public 
854         onlyOwner 
855         returns(bool) {
856         uint256 codeSize;
857         assembly { codeSize := extcodesize(_contract) }
858         require(codeSize != 0);
859         // Not exists
860         require(authorizedContractIds[_contract] == 0);
861 
862         // Add
863         uint256 id = authorizedContractList.push(false);
864         authorizedContractIds[_contract] = id;
865         authorizedContracts[id] = AuthorizedContract(_name, _contract);
866 
867         // Event
868         emit ContractAuthorized(_contract);
869         return true;
870     }
871 
872     /**
873      * @dev Deauthorized `_contract` by address
874      * @param _contract The contract address
875      */
876     function deauthorizeContract(address _contract) 
877         public 
878         onlyOwner
879         authorizedContractValid(_contract)
880         returns(bool) {
881         uint256 id = authorizedContractIds[_contract];
882         authorizedContractList.remove(id);
883         authorizedContractIds[_contract] = 0;
884         delete authorizedContracts[id];
885         
886         // Event 
887         emit ContractDeauthorized(_contract);
888         return true;
889     }
890 
891     /**
892      * @dev Deauthorized `_contract` by contract id
893      * @param _cid The contract id
894      */
895     function deauthorizeContractById(uint256 _cid) 
896         public
897         onlyOwner
898         authorizedContractIdValid(_cid)
899         returns(bool) {
900         address acontract = authorizedContracts[_cid].acontract;
901         authorizedContractList.remove(_cid);
902         authorizedContractIds[acontract] = 0;
903         delete authorizedContracts[_cid];
904 
905         // Event 
906         emit ContractDeauthorized(acontract);
907         return true;
908     }
909 
910     /**
911      * @dev Get authorize contract ids by page
912      * @param _from The begin authorize contract id
913      * @param _limit How many authorize contract ids one page
914      * @return The authorize contract ids and the next authorize contract id as tuple, the next page not exists when next eq 0
915      */
916     function getAuthorizeContractIds(uint256 _from, uint256 _limit) 
917         external 
918         view 
919         returns(uint256[], uint256){
920         return getNodes(authorizedContractList, _from, _limit, true);
921     }
922 
923     /**
924      * @dev Get authorize contract by id
925      * @param _cid Then authorize contract id
926      * @return The authorize contract info(_name, _acontract)
927      */
928     function getAuthorizeContract(uint256 _cid) 
929         external 
930         view 
931         returns(string _name, address _acontract) {
932         AuthorizedContract memory acontract = authorizedContracts[_cid]; 
933         _name = acontract.name;
934         _acontract = acontract.acontract;
935     }
936 
937     /*************************************** GET ***************************************/
938 
939     /**
940      * @dev Get the rate plan by `_vendorId` and `_rpid`
941      * @param _vendorId The vendor id
942      * @param _rpid The rate plan id
943      */
944     function getRatePlan(uint256 _vendorId, uint256 _rpid) 
945         public 
946         view 
947         returns (string _name, uint256 _timestamp, bytes32 _ipfs) {
948         _name = vendors[_vendorId].ratePlans[_rpid].name;
949         _timestamp = vendors[_vendorId].ratePlans[_rpid].timestamp;
950         _ipfs = vendors[_vendorId].ratePlans[_rpid].ipfs;
951     }
952 
953     /**
954      * @dev Get the rate plan price by `_vendorId`, `_rpid`, `_date` and `_tokenId`
955      * @param _vendorId The vendor id
956      * @param _rpid The rate plan id
957      * @param _date The date desc (20180723)
958      * @param _tokenId The digital token id
959      * @return The price info(inventory, init, price)
960      */
961     function getPrice(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _tokenId) 
962         public
963         view 
964         returns(uint16 _inventory, bool _init, uint256 _price) {
965         _inventory = vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
966         _init = vendors[_vendorId].ratePlans[_rpid].prices[_date].init;
967         _price = vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId];
968         if(!_init) {
969             // Get the base price
970             _inventory = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
971             _price = vendors[_vendorId].ratePlans[_rpid].basePrice.tokens[_tokenId];
972             _init = vendors[_vendorId].ratePlans[_rpid].basePrice.init;
973         }
974     }
975 
976     /**
977      * @dev Get the rate plan prices by `_vendorId`, `_rpid`, `_dates` and `_tokenId`
978      * @param _vendorId The vendor id
979      * @param _rpid The rate plan id
980      * @param _dates The dates desc ([20180723,20180724,20180725])
981      * @param _tokenId The digital token id
982      * @return The price info(inventory, init, price)
983      */
984     function getPrices(uint256 _vendorId, uint256 _rpid, uint256[] _dates, uint256 _tokenId) 
985         public
986         view 
987         returns(uint16[] _inventories, uint256[] _prices) {
988         uint16[] memory inventories = new uint16[](_dates.length);
989         uint256[] memory prices = new uint256[](_dates.length);
990         uint256 date;
991         for(uint256 i = 0; i < _dates.length; i++) {
992             date = _dates[i];
993             uint16 inventory = vendors[_vendorId].ratePlans[_rpid].prices[date].inventory;
994             bool init = vendors[_vendorId].ratePlans[_rpid].prices[date].init;
995             uint256 price = vendors[_vendorId].ratePlans[_rpid].prices[date].tokens[_tokenId];
996             if(!init) {
997                 // Get the base price
998                 inventory = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
999                 price = vendors[_vendorId].ratePlans[_rpid].basePrice.tokens[_tokenId];
1000                 init = vendors[_vendorId].ratePlans[_rpid].basePrice.init;
1001             }
1002             inventories[i] = inventory;
1003             prices[i] = price;
1004         }
1005         return (inventories, prices);
1006     }
1007 
1008     /**
1009      * @dev Get the inventory by  by `_vendorId`, `_rpid` and `_date`
1010      * @param _vendorId The vendor id
1011      * @param _rpid The rate plan id
1012      * @param _date The date desc (20180723)
1013      * @return The inventory info(inventory, init)
1014      */
1015     function getInventory(uint256 _vendorId, uint256 _rpid, uint256 _date) 
1016         public
1017         view 
1018         returns(uint16 _inventory, bool _init) {
1019         _inventory = vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
1020         _init = vendors[_vendorId].ratePlans[_rpid].prices[_date].init;
1021         if(!_init) {
1022             // Get the base price
1023             _inventory = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
1024         }
1025     }
1026 
1027     /**
1028      * @dev Whether the rate plan is exist
1029      * @param _vendorId The vendor id
1030      * @param _rpid The rate plan id
1031      * @return If the rate plan of the vendor is exist returns true otherwise return false
1032      */
1033     function ratePlanIsExist(uint256 _vendorId, uint256 _rpid) 
1034         public 
1035         view 
1036         returns (bool) {
1037         return vendors[_vendorId].ratePlanList.nodeExists(_rpid);
1038     }
1039 
1040     /**
1041      * @dev Get orders of owner by page
1042      * @param _owner The owner address
1043      * @param _from The begin id of the node to get
1044      * @param _limit The total nodes of one page
1045      * @param _direction Direction to step in
1046      * @return The order ids and the next id
1047      */
1048     function getOrdersOfOwner(address _owner, uint256 _from, uint256 _limit, bool _direction) 
1049         public 
1050         view 
1051         returns (uint256[], uint256) {
1052         return getNodes(roomNightOwners[_owner], _from, _limit, _direction);
1053     }
1054 
1055     /**
1056      * @dev Get orders of vendor by page
1057      * @param _owner The vendor address
1058      * @param _from The begin id of the node to get
1059      * @param _limit The total nodes of on page
1060      * @param _direction Direction to step in 
1061      * @return The order ids and the next id
1062      */
1063     function getOrdersOfVendor(address _owner, uint256 _from, uint256 _limit, bool _direction) 
1064         public 
1065         view 
1066         returns (uint256[], uint256) {
1067         return getNodes(roomNightVendors[_owner], _from, _limit, _direction);
1068     }
1069 
1070     /**
1071      * @dev Get the token count of somebody 
1072      * @param _owner The owner of token
1073      * @return The token count of `_owner`
1074      */
1075     function balanceOf(address _owner) 
1076         public 
1077         view 
1078         returns(uint256) {
1079         return roomNightOwners[_owner].length;
1080     }
1081 
1082     /**
1083      * @dev Get rate plan ids of `_vendorId`
1084      * @param _from The begin id of the node to get
1085      * @param _limit The total nodes of on page
1086      * @param _direction Direction to step in 
1087      * @return The rate plan ids and the next id
1088      */
1089     function getRatePlansOfVendor(uint256 _vendorId, uint256 _from, uint256 _limit, bool _direction) 
1090         public 
1091         view 
1092         returns(uint256[], uint256) {
1093         return getNodes(vendors[_vendorId].ratePlanList, _from, _limit, _direction);
1094     }
1095 
1096     /**
1097      * @dev Get token ids
1098      * @param _from The begin id of the node to get
1099      * @param _limit The total nodes of on page
1100      * @param _direction Direction to step in 
1101      * @return The token ids and the next id
1102      */
1103     function getTokens(uint256 _from, uint256 _limit, bool _direction) 
1104         public 
1105         view 
1106         returns(uint256[], uint256) {
1107         return getNodes(tokenList, _from, _limit, _direction);
1108     }
1109 
1110     /**
1111      * @dev Get token Info
1112      * @param _tokenId The token id
1113      * @return The token info(symbol, name, decimals)
1114      */
1115     function getToken(uint256 _tokenId)
1116         public 
1117         view 
1118         returns(string _symbol, string _name, uint8 _decimals, address _token) {
1119         _token = tokenIndexToAddress[_tokenId];
1120         TripioToken tripio = TripioToken(_token);
1121         _symbol = tripio.symbol();
1122         _name = tripio.name();
1123         _decimals = tripio.decimals();
1124     }
1125 
1126     /**
1127      * @dev Get vendor ids
1128      * @param _from The begin id of the node to get
1129      * @param _limit The total nodes of on page
1130      * @param _direction Direction to step in 
1131      * @return The vendor ids and the next id
1132      */
1133     function getVendors(uint256 _from, uint256 _limit, bool _direction) 
1134         public 
1135         view 
1136         returns(uint256[], uint256) {
1137         return getNodes(vendorList, _from, _limit, _direction);
1138     }
1139 
1140     /**
1141      * @dev Get the vendor infomation by vendorId
1142      * @param _vendorId The vendor id
1143      * @return The vendor infomation(name, vendor, timestamp, valid)
1144      */
1145     function getVendor(uint256 _vendorId) 
1146         public 
1147         view 
1148         returns(string _name, address _vendor,uint256 _timestamp, bool _valid) {
1149         _name = vendors[_vendorId].name;
1150         _vendor = vendors[_vendorId].vendor;
1151         _timestamp = vendors[_vendorId].timestamp;
1152         _valid = vendors[_vendorId].valid;
1153     }
1154 
1155     /*************************************** SET ***************************************/
1156     /**
1157      * @dev Update base uri of token metadata
1158      * @param _tokenBaseURI The base uri
1159      */
1160     function updateTokenBaseURI(string _tokenBaseURI) 
1161         public 
1162         onlyOwnerOrAuthorizedContract {
1163         tokenBaseURI = _tokenBaseURI;
1164     }
1165 
1166     /**
1167      * @dev Push order to user's order list
1168      * @param _owner The buyer address
1169      * @param _rnid The room night order id
1170      * @param _direction direction to step in
1171      */
1172     function pushOrderOfOwner(address _owner, uint256 _rnid, bool _direction) 
1173         public 
1174         onlyOwnerOrAuthorizedContract {
1175         if(!roomNightOwners[_owner].listExists()) {
1176             roomNightOwners[_owner] = LinkedListLib.LinkedList(0, 0);
1177         }
1178         roomNightOwners[_owner].add(_rnid, _direction);
1179     }
1180 
1181     /**
1182      * @dev Remove order from owner's order list
1183      * @param _owner The owner address
1184      * @param _rnid The room night order id
1185      */
1186     function removeOrderOfOwner(address _owner, uint _rnid) 
1187         public 
1188         onlyOwnerOrAuthorizedContract {
1189         require(roomNightOwners[_owner].nodeExists(_rnid));
1190         roomNightOwners[_owner].remove(_rnid);
1191     }
1192 
1193     /**
1194      * @dev Push order to the vendor's order list
1195      * @param _vendor The vendor address
1196      * @param _rnid The room night order id
1197      * @param _direction direction to step in
1198      */
1199     function pushOrderOfVendor(address _vendor, uint256 _rnid, bool _direction) 
1200         public 
1201         onlyOwnerOrAuthorizedContract {
1202         if(!roomNightVendors[_vendor].listExists()) {
1203             roomNightVendors[_vendor] = LinkedListLib.LinkedList(0, 0);
1204         }
1205         roomNightVendors[_vendor].add(_rnid, _direction);
1206     }
1207 
1208     /**
1209      * @dev Remove order from vendor's order list
1210      * @param _vendor The vendor address
1211      * @param _rnid The room night order id
1212      */
1213     function removeOrderOfVendor(address _vendor, uint256 _rnid) 
1214         public 
1215         onlyOwnerOrAuthorizedContract {
1216         require(roomNightVendors[_vendor].nodeExists(_rnid));
1217         roomNightVendors[_vendor].remove(_rnid);
1218     }
1219 
1220     /**
1221      * @dev Transfer token to somebody
1222      * @param _tokenId The token id 
1223      * @param _to The target owner of the token
1224      */
1225     function transferTokenTo(uint256 _tokenId, address _to) 
1226         public 
1227         onlyOwnerOrAuthorizedContract {
1228         roomNightIndexToOwner[_tokenId] = _to;
1229         roomNightApprovals[_tokenId] = address(0);
1230     }
1231 
1232     /**
1233      * @dev Approve `_to` to operate the `_tokenId`
1234      * @param _tokenId The token id
1235      * @param _to Somebody to be approved
1236      */
1237     function approveTokenTo(uint256 _tokenId, address _to) 
1238         public 
1239         onlyOwnerOrAuthorizedContract {
1240         roomNightApprovals[_tokenId] = _to;
1241     }
1242 
1243     /**
1244      * @dev Approve `_operator` to operate all the Token of `_to`
1245      * @param _operator The operator to be approved
1246      * @param _to The owner of tokens to be operate
1247      * @param _approved Approved or not
1248      */
1249     function approveOperatorTo(address _operator, address _to, bool _approved) 
1250         public 
1251         onlyOwnerOrAuthorizedContract {
1252         operatorApprovals[_to][_operator] = _approved;
1253     } 
1254 
1255     /**
1256      * @dev Update base price of rate plan
1257      * @param _vendorId The vendor id
1258      * @param _rpid The rate plan id
1259      * @param _tokenId The digital token id
1260      * @param _price The price to be updated
1261      */
1262     function updateBasePrice(uint256 _vendorId, uint256 _rpid, uint256 _tokenId, uint256 _price)
1263         public 
1264         onlyOwnerOrAuthorizedContract {
1265         vendors[_vendorId].ratePlans[_rpid].basePrice.init = true;
1266         vendors[_vendorId].ratePlans[_rpid].basePrice.tokens[_tokenId] = _price;
1267     }
1268 
1269     /**
1270      * @dev Update base inventory of rate plan 
1271      * @param _vendorId The vendor id
1272      * @param _rpid The rate plan id
1273      * @param _inventory The inventory to be updated
1274      */
1275     function updateBaseInventory(uint256 _vendorId, uint256 _rpid, uint16 _inventory)
1276         public 
1277         onlyOwnerOrAuthorizedContract {
1278         vendors[_vendorId].ratePlans[_rpid].basePrice.inventory = _inventory;
1279     }
1280 
1281     /**
1282      * @dev Update price by `_vendorId`, `_rpid`, `_date`, `_tokenId` and `_price`
1283      * @param _vendorId The vendor id
1284      * @param _rpid The rate plan id
1285      * @param _date The date desc (20180723)
1286      * @param _tokenId The digital token id
1287      * @param _price The price to be updated
1288      */
1289     function updatePrice(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _tokenId, uint256 _price)
1290         public
1291         onlyOwnerOrAuthorizedContract {
1292         if (vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1293             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
1294         } else {
1295             vendors[_vendorId].ratePlans[_rpid].prices[_date] = Price(0, true);
1296             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
1297         }
1298     }
1299 
1300     /**
1301      * @dev Update inventory by `_vendorId`, `_rpid`, `_date`, `_inventory`
1302      * @param _vendorId The vendor id
1303      * @param _rpid The rate plan id
1304      * @param _date The date desc (20180723)
1305      * @param _inventory The inventory to be updated
1306      */
1307     function updateInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint16 _inventory)
1308         public 
1309         onlyOwnerOrAuthorizedContract {
1310         if (vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1311             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = _inventory;
1312         } else {
1313             vendors[_vendorId].ratePlans[_rpid].prices[_date] = Price(_inventory, true);
1314         }
1315     }
1316 
1317     /**
1318      * @dev Reduce inventories
1319      * @param _vendorId The vendor id
1320      * @param _rpid The rate plan id
1321      * @param _date The date desc (20180723)
1322      * @param _inventory The amount to be reduced
1323      */
1324     function reduceInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint16 _inventory) 
1325         public  
1326         onlyOwnerOrAuthorizedContract {
1327         uint16 a = 0;
1328         if(vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1329             a = vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
1330             require(_inventory <= a);
1331             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = a - _inventory;
1332         }else if(vendors[_vendorId].ratePlans[_rpid].basePrice.init){
1333             a = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
1334             require(_inventory <= a);
1335             vendors[_vendorId].ratePlans[_rpid].basePrice.inventory = a - _inventory;
1336         }
1337     }
1338 
1339     /**
1340      * @dev Add inventories
1341      * @param _vendorId The vendor id
1342      * @param _rpid The rate plan id
1343      * @param _date The date desc (20180723)
1344      * @param _inventory The amount to be add
1345      */
1346     function addInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint16 _inventory) 
1347         public  
1348         onlyOwnerOrAuthorizedContract {
1349         uint16 c = 0;
1350         if(vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1351             c = _inventory + vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
1352             require(c >= _inventory);
1353             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = c;
1354         }else if(vendors[_vendorId].ratePlans[_rpid].basePrice.init) {
1355             c = _inventory + vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
1356             require(c >= _inventory);
1357             vendors[_vendorId].ratePlans[_rpid].basePrice.inventory = c;
1358         }
1359     }
1360 
1361     /**
1362      * @dev Update inventory and price by `_vendorId`, `_rpid`, `_date`, `_tokenId`, `_price` and `_inventory`
1363      * @param _vendorId The vendor id
1364      * @param _rpid The rate plan id
1365      * @param _date The date desc (20180723)
1366      * @param _tokenId The digital token id
1367      * @param _price The price to be updated
1368      * @param _inventory The inventory to be updated
1369      */
1370     function updatePriceAndInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _tokenId, uint256 _price, uint16 _inventory)
1371         public 
1372         onlyOwnerOrAuthorizedContract {
1373         if (vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1374             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = _inventory;
1375             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
1376         } else {
1377             vendors[_vendorId].ratePlans[_rpid].prices[_date] = Price(_inventory, true);
1378             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
1379         }
1380     }
1381 
1382     /**
1383      * @dev Push rate plan to `_vendorId`'s rate plan list
1384      * @param _vendorId The vendor id
1385      * @param _name The name of rate plan
1386      * @param _ipfs The rate plan IPFS address
1387      * @param _direction direction to step in
1388      */
1389     function pushRatePlan(uint256 _vendorId, string _name, bytes32 _ipfs, bool _direction) 
1390         public 
1391         onlyOwnerOrAuthorizedContract
1392         returns(uint256) {
1393         RatePlan memory rp = RatePlan(_name, uint256(now), _ipfs, Price(0, false));
1394         
1395         uint256 id = vendors[_vendorId].ratePlanList.push(_direction);
1396         vendors[_vendorId].ratePlans[id] = rp;
1397         return id;
1398     }
1399 
1400     /**
1401      * @dev Remove rate plan of `_vendorId` by `_rpid`
1402      * @param _vendorId The vendor id
1403      * @param _rpid The rate plan id
1404      */
1405     function removeRatePlan(uint256 _vendorId, uint256 _rpid) 
1406         public 
1407         onlyOwnerOrAuthorizedContract {
1408         delete vendors[_vendorId].ratePlans[_rpid];
1409         vendors[_vendorId].ratePlanList.remove(_rpid);
1410     }
1411 
1412     /**
1413      * @dev Update `_rpid` of `_vendorId` by `_name` and `_ipfs`
1414      * @param _vendorId The vendor id
1415      * @param _rpid The rate plan id
1416      * @param _name The rate plan name
1417      * @param _ipfs The rate plan IPFS address
1418      */
1419     function updateRatePlan(uint256 _vendorId, uint256 _rpid, string _name, bytes32 _ipfs)
1420         public 
1421         onlyOwnerOrAuthorizedContract {
1422         vendors[_vendorId].ratePlans[_rpid].ipfs = _ipfs;
1423         vendors[_vendorId].ratePlans[_rpid].name = _name;
1424     }
1425     
1426     /**
1427      * @dev Push token contract to the token list
1428      * @param _direction direction to step in
1429      */
1430     function pushToken(address _contract, bool _direction)
1431         public 
1432         onlyOwnerOrAuthorizedContract 
1433         returns(uint256) {
1434         uint256 id = tokenList.push(_direction);
1435         tokenIndexToAddress[id] = _contract;
1436         return id;
1437     }
1438 
1439     /**
1440      * @dev Remove token by `_tokenId`
1441      * @param _tokenId The digital token id
1442      */
1443     function removeToken(uint256 _tokenId) 
1444         public 
1445         onlyOwnerOrAuthorizedContract {
1446         delete tokenIndexToAddress[_tokenId];
1447         tokenList.remove(_tokenId);
1448     }
1449 
1450     /**
1451      * @dev Generate room night token
1452      * @param _vendorId The vendor id
1453      * @param _rpid The rate plan id
1454      * @param _date The date desc (20180723)
1455      * @param _token The token id
1456      * @param _price The token price
1457      * @param _ipfs The rate plan IPFS address
1458      */
1459     function generateRoomNightToken(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _token, uint256 _price, bytes32 _ipfs)
1460         public 
1461         onlyOwnerOrAuthorizedContract 
1462         returns(uint256) {
1463         roomnights.push(RoomNight(_vendorId, _rpid, _token, _price, now, _date, _ipfs));
1464 
1465         // Give the token to `_customer`
1466         uint256 rnid = uint256(roomnights.length - 1);
1467         return rnid;
1468     }
1469 
1470     /**
1471      * @dev Update refund applications
1472      * @param _buyer The room night token holder
1473      * @param _rnid The room night token id
1474      * @param _isRefund Is redund or not
1475      */
1476     function updateRefundApplications(address _buyer, uint256 _rnid, bool _isRefund) 
1477         public 
1478         onlyOwnerOrAuthorizedContract {
1479         refundApplications[_buyer][_rnid] = _isRefund;
1480     }
1481 
1482     /**
1483      * @dev Push vendor info to the vendor list
1484      * @param _name The name of vendor
1485      * @param _vendor The vendor address
1486      * @param _direction direction to step in
1487      */
1488     function pushVendor(string _name, address _vendor, bool _direction)
1489         public 
1490         onlyOwnerOrAuthorizedContract 
1491         returns(uint256) {
1492         uint256 id = vendorList.push(_direction);
1493         vendorIds[_vendor] = id;
1494         vendors[id] = Vendor(_name, _vendor, uint256(now), true, LinkedListLib.LinkedList(0, 0));
1495         return id;
1496     }
1497 
1498     /**
1499      * @dev Remove vendor from vendor list
1500      * @param _vendorId The vendor id
1501      */
1502     function removeVendor(uint256 _vendorId) 
1503         public 
1504         onlyOwnerOrAuthorizedContract {
1505         vendorList.remove(_vendorId);
1506         address vendor = vendors[_vendorId].vendor;
1507         vendorIds[vendor] = 0;
1508         delete vendors[_vendorId];
1509     }
1510 
1511     /**
1512      * @dev Make vendor valid or invalid
1513      * @param _vendorId The vendor id
1514      * @param _valid The vendor is valid or not
1515      */
1516     function updateVendorValid(uint256 _vendorId, bool _valid)
1517         public 
1518         onlyOwnerOrAuthorizedContract {
1519         vendors[_vendorId].valid = _valid;
1520     }
1521 
1522     /**
1523      * @dev Modify vendor's name
1524      * @param _vendorId The vendor id
1525      * @param _name Then vendor name
1526      */
1527     function updateVendorName(uint256 _vendorId, string _name)
1528         public 
1529         onlyOwnerOrAuthorizedContract {
1530         vendors[_vendorId].name = _name;
1531     }
1532 }
1533 
1534 
1535 contract TripioRoomNightAdmin is TRNVendors, TRNTokens {
1536     /**
1537      * This emits when token base uri changed
1538      */
1539     event TokenBaseURIChanged(string _uri);
1540 
1541     /**
1542      * Constructor
1543      */
1544     constructor(address _dataSource) public {
1545         // Init the data source
1546         dataSource = TripioRoomNightData(_dataSource);
1547     }
1548 
1549      /**
1550      * @dev Update the base URI of token asset
1551      * @param _uri The base uri of token asset
1552      */
1553     function updateBaseTokenURI(string _uri) 
1554         external 
1555         onlyOwner {
1556         dataSource.updateTokenBaseURI(_uri);
1557         emit TokenBaseURIChanged(_uri);
1558     }
1559 
1560     /**
1561      * @dev Destory the contract
1562      */
1563     function destroy() external onlyOwner {
1564         selfdestruct(owner);
1565     }
1566 }