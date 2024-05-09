1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract UnicornManagementInterface {
33 
34     function ownerAddress() external view returns (address);
35     function managerAddress() external view returns (address);
36     function communityAddress() external view returns (address);
37     function dividendManagerAddress() external view returns (address);
38     function walletAddress() external view returns (address);
39     function blackBoxAddress() external view returns (address);
40     function unicornBreedingAddress() external view returns (address);
41     function geneLabAddress() external view returns (address);
42     function unicornTokenAddress() external view returns (address);
43     function candyToken() external view returns (address);
44     function candyPowerToken() external view returns (address);
45 
46     function createDividendPercent() external view returns (uint);
47     function sellDividendPercent() external view returns (uint);
48     function subFreezingPrice() external view returns (uint);
49     function subFreezingTime() external view returns (uint64);
50     function subTourFreezingPrice() external view returns (uint);
51     function subTourFreezingTime() external view returns (uint64);
52     function createUnicornPrice() external view returns (uint);
53     function createUnicornPriceInCandy() external view returns (uint);
54     function oraclizeFee() external view returns (uint);
55 
56     function paused() external view returns (bool);
57     //    function locked() external view returns (bool);
58 
59     function isTournament(address _tournamentAddress) external view returns (bool);
60 
61     function getCreateUnicornFullPrice() external view returns (uint);
62     function getHybridizationFullPrice(uint _price) external view returns (uint);
63     function getSellUnicornFullPrice(uint _price) external view returns (uint);
64     function getCreateUnicornFullPriceInCandy() external view returns (uint);
65 
66 
67     //service
68     function registerInit(address _contract) external;
69 
70 }
71 
72 contract UnicornAccessControl {
73 
74     UnicornManagementInterface public unicornManagement;
75 
76     function UnicornAccessControl(address _unicornManagementAddress) public {
77         unicornManagement = UnicornManagementInterface(_unicornManagementAddress);
78         unicornManagement.registerInit(this);
79     }
80 
81     modifier onlyOwner() {
82         require(msg.sender == unicornManagement.ownerAddress());
83         _;
84     }
85 
86     modifier onlyManager() {
87         require(msg.sender == unicornManagement.managerAddress());
88         _;
89     }
90 
91     modifier onlyCommunity() {
92         require(msg.sender == unicornManagement.communityAddress());
93         _;
94     }
95 
96     modifier onlyTournament() {
97         require(unicornManagement.isTournament(msg.sender));
98         _;
99     }
100 
101     modifier whenNotPaused() {
102         require(!unicornManagement.paused());
103         _;
104     }
105 
106     modifier whenPaused {
107         require(unicornManagement.paused());
108         _;
109     }
110 
111 
112     modifier onlyManagement() {
113         require(msg.sender == address(unicornManagement));
114         _;
115     }
116 
117     modifier onlyBreeding() {
118         require(msg.sender == unicornManagement.unicornBreedingAddress());
119         _;
120     }
121 
122     modifier onlyGeneLab() {
123         require(msg.sender == unicornManagement.geneLabAddress());
124         _;
125     }
126 
127     modifier onlyBlackBox() {
128         require(msg.sender == unicornManagement.blackBoxAddress());
129         _;
130     }
131 
132     modifier onlyUnicornToken() {
133         require(msg.sender == unicornManagement.unicornTokenAddress());
134         _;
135     }
136 
137     function isGamePaused() external view returns (bool) {
138         return unicornManagement.paused();
139     }
140 }
141 
142 contract UnicornBreedingInterface {
143     function deleteOffer(uint _unicornId) external;
144     function deleteHybridization(uint _unicornId) external;
145 }
146 
147 
148 contract UnicornBase is UnicornAccessControl {
149     using SafeMath for uint;
150     UnicornBreedingInterface public unicornBreeding; //set on deploy
151 
152     event Transfer(address indexed from, address indexed to, uint256 unicornId);
153     event Approval(address indexed owner, address indexed approved, uint256 unicornId);
154     event UnicornGeneSet(uint indexed unicornId);
155     event UnicornGeneUpdate(uint indexed unicornId);
156     event UnicornFreezingTimeSet(uint indexed unicornId, uint time);
157     event UnicornTourFreezingTimeSet(uint indexed unicornId, uint time);
158 
159 
160     struct Unicorn {
161         bytes gene;
162         uint64 birthTime;
163         uint64 freezingEndTime;
164         uint64 freezingTourEndTime;
165         string name;
166     }
167 
168     uint8 maxFreezingIndex = 7;
169     uint32[8] internal freezing = [
170     uint32(1 hours),    //1 hour
171     uint32(2 hours),    //2 - 4 hours
172     uint32(8 hours),    //8 - 12 hours
173     uint32(16 hours),   //16 - 24 hours
174     uint32(36 hours),   //36 - 48 hours
175     uint32(72 hours),   //72 - 96 hours
176     uint32(120 hours),  //120 - 144 hours
177     uint32(168 hours)   //168 hours
178     ];
179 
180     //count for random plus from 0 to ..
181     uint32[8] internal freezingPlusCount = [
182     0, 3, 5, 9, 13, 25, 25, 0
183     ];
184 
185     // Total amount of unicorns
186     uint256 private totalUnicorns;
187 
188     // Incremental counter of unicorns Id
189     uint256 private lastUnicornId;
190 
191     //Mapping from unicorn ID to Unicorn struct
192     mapping(uint256 => Unicorn) public unicorns;
193 
194     // Mapping from unicorn ID to owner
195     mapping(uint256 => address) private unicornOwner;
196 
197     // Mapping from unicorn ID to approved address
198     mapping(uint256 => address) private unicornApprovals;
199 
200     // Mapping from owner to list of owned unicorn IDs
201     mapping(address => uint256[]) private ownedUnicorns;
202 
203     // Mapping from unicorn ID to index of the owner unicorns list
204     // т.е. ID уникорна => порядковый номер в списке владельца
205     mapping(uint256 => uint256) private ownedUnicornsIndex;
206 
207     // Mapping from unicorn ID to approval for GeneLab
208     mapping(uint256 => bool) private unicornApprovalsForGeneLab;
209 
210     modifier onlyOwnerOf(uint256 _unicornId) {
211         require(owns(msg.sender, _unicornId));
212         _;
213     }
214 
215     /**
216     * @dev Gets the owner of the specified unicorn ID
217     * @param _unicornId uint256 ID of the unicorn to query the owner of
218     * @return owner address currently marked as the owner of the given unicorn ID
219     */
220     function ownerOf(uint256 _unicornId) public view returns (address) {
221         return unicornOwner[_unicornId];
222         //        address owner = unicornOwner[_unicornId];
223         //        require(owner != address(0));
224         //        return owner;
225     }
226 
227     function totalSupply() public view returns (uint256) {
228         return totalUnicorns;
229     }
230 
231     /**
232     * @dev Gets the balance of the specified address
233     * @param _owner address to query the balance of
234     * @return uint256 representing the amount owned by the passed address
235     */
236     function balanceOf(address _owner) public view returns (uint256) {
237         return ownedUnicorns[_owner].length;
238     }
239 
240     /**
241     * @dev Gets the list of unicorns owned by a given address
242     * @param _owner address to query the unicorns of
243     * @return uint256[] representing the list of unicorns owned by the passed address
244     */
245     function unicornsOf(address _owner) public view returns (uint256[]) {
246         return ownedUnicorns[_owner];
247     }
248 
249     /**
250     * @dev Gets the approved address to take ownership of a given unicorn ID
251     * @param _unicornId uint256 ID of the unicorn to query the approval of
252     * @return address currently approved to take ownership of the given unicorn ID
253     */
254     function approvedFor(uint256 _unicornId) public view returns (address) {
255         return unicornApprovals[_unicornId];
256     }
257 
258     /**
259     * @dev Tells whether the msg.sender is approved for the given unicorn ID or not
260     * This function is not private so it can be extended in further implementations like the operatable ERC721
261     * @param _owner address of the owner to query the approval of
262     * @param _unicornId uint256 ID of the unicorn to query the approval of
263     * @return bool whether the msg.sender is approved for the given unicorn ID or not
264     */
265     function allowance(address _owner, uint256 _unicornId) public view returns (bool) {
266         return approvedFor(_unicornId) == _owner;
267     }
268 
269     /**
270     * @dev Approves another address to claim for the ownership of the given unicorn ID
271     * @param _to address to be approved for the given unicorn ID
272     * @param _unicornId uint256 ID of the unicorn to be approved
273     */
274     function approve(address _to, uint256 _unicornId) public onlyOwnerOf(_unicornId) {
275         //модификатор onlyOwnerOf гарантирует, что owner = msg.sender
276         //        address owner = ownerOf(_unicornId);
277         require(_to != msg.sender);
278         if (approvedFor(_unicornId) != address(0) || _to != address(0)) {
279             unicornApprovals[_unicornId] = _to;
280             emit Approval(msg.sender, _to, _unicornId);
281         }
282     }
283 
284     /**
285     * @dev Claims the ownership of a given unicorn ID
286     * @param _unicornId uint256 ID of the unicorn being claimed by the msg.sender
287     */
288     function takeOwnership(uint256 _unicornId) public {
289         require(allowance(msg.sender, _unicornId));
290         clearApprovalAndTransfer(ownerOf(_unicornId), msg.sender, _unicornId);
291     }
292 
293     /**
294     * @dev Transfers the ownership of a given unicorn ID to another address
295     * @param _to address to receive the ownership of the given unicorn ID
296     * @param _unicornId uint256 ID of the unicorn to be transferred
297     */
298     function transfer(address _to, uint256 _unicornId) public onlyOwnerOf(_unicornId) {
299         clearApprovalAndTransfer(msg.sender, _to, _unicornId);
300     }
301 
302 
303     /**
304     * @dev Internal function to clear current approval and transfer the ownership of a given unicorn ID
305     * @param _from address which you want to send unicorns from
306     * @param _to address which you want to transfer the unicorn to
307     * @param _unicornId uint256 ID of the unicorn to be transferred
308     */
309     function clearApprovalAndTransfer(address _from, address _to, uint256 _unicornId) internal {
310         require(owns(_from, _unicornId));
311         require(_to != address(0));
312         require(_to != ownerOf(_unicornId));
313 
314         clearApproval(_from, _unicornId);
315         removeUnicorn(_from, _unicornId);
316         addUnicorn(_to, _unicornId);
317         emit Transfer(_from, _to, _unicornId);
318     }
319 
320     /**
321     * @dev Internal function to clear current approval of a given unicorn ID
322     * @param _unicornId uint256 ID of the unicorn to be transferred
323     */
324     function clearApproval(address _owner, uint256 _unicornId) private {
325         require(owns(_owner, _unicornId));
326         unicornApprovals[_unicornId] = 0;
327         emit Approval(_owner, 0, _unicornId);
328     }
329 
330     /**
331     * @dev Internal function to add a unicorn ID to the list of a given address
332     * @param _to address representing the new owner of the given unicorn ID
333     * @param _unicornId uint256 ID of the unicorn to be added to the unicorns list of the given address
334     */
335     function addUnicorn(address _to, uint256 _unicornId) private {
336         require(unicornOwner[_unicornId] == address(0));
337         unicornOwner[_unicornId] = _to;
338         //        uint256 length = balanceOf(_to);
339         uint256 length = ownedUnicorns[_to].length;
340         ownedUnicorns[_to].push(_unicornId);
341         ownedUnicornsIndex[_unicornId] = length;
342         totalUnicorns = totalUnicorns.add(1);
343     }
344 
345     /**
346     * @dev Internal function to remove a unicorn ID from the list of a given address
347     * @param _from address representing the previous owner of the given unicorn ID
348     * @param _unicornId uint256 ID of the unicorn to be removed from the unicorns list of the given address
349     */
350     function removeUnicorn(address _from, uint256 _unicornId) private {
351         require(owns(_from, _unicornId));
352 
353         uint256 unicornIndex = ownedUnicornsIndex[_unicornId];
354         //        uint256 lastUnicornIndex = balanceOf(_from).sub(1);
355         uint256 lastUnicornIndex = ownedUnicorns[_from].length.sub(1);
356         uint256 lastUnicorn = ownedUnicorns[_from][lastUnicornIndex];
357 
358         unicornOwner[_unicornId] = 0;
359         ownedUnicorns[_from][unicornIndex] = lastUnicorn;
360         ownedUnicorns[_from][lastUnicornIndex] = 0;
361         // Note that this will handle single-element arrays. In that case, both unicornIndex and lastUnicornIndex are going to
362         // be zero. Then we can make sure that we will remove _unicornId from the ownedUnicorns list since we are first swapping
363         // the lastUnicorn to the first position, and then dropping the element placed in the last position of the list
364 
365         ownedUnicorns[_from].length--;
366         ownedUnicornsIndex[_unicornId] = 0;
367         ownedUnicornsIndex[lastUnicorn] = unicornIndex;
368         totalUnicorns = totalUnicorns.sub(1);
369 
370         //deleting sale offer, if exists
371         //TODO check if contract exists?
372         //        if (address(unicornBreeding) != address(0)) {
373         unicornBreeding.deleteOffer(_unicornId);
374         unicornBreeding.deleteHybridization(_unicornId);
375         //        }
376     }
377 
378     //specific
379     //    function burnUnicorn(uint256 _unicornId) onlyOwnerOf(_unicornId) public  {
380     //        if (approvedFor(_unicornId) != 0) {
381     //            clearApproval(msg.sender, _unicornId);
382     //        }
383     //        removeUnicorn(msg.sender, _unicornId);
384     //        //destroy unicorn data
385     //        delete unicorns[_unicornId];
386     //        emit Transfer(msg.sender, 0x0, _unicornId);
387     //    }
388 
389 
390     function createUnicorn(address _owner) onlyBreeding external returns (uint) {
391         require(_owner != address(0));
392         uint256 _unicornId = lastUnicornId++;
393         addUnicorn(_owner, _unicornId);
394         //store new unicorn data
395         unicorns[_unicornId] = Unicorn({
396             gene : new bytes(0),
397             birthTime : uint64(now),
398             freezingEndTime : 0,
399             freezingTourEndTime: 0,
400             name: ''
401             });
402         emit Transfer(0x0, _owner, _unicornId);
403         return _unicornId;
404     }
405 
406 
407     function owns(address _claimant, uint256 _unicornId) public view returns (bool) {
408         return ownerOf(_unicornId) == _claimant && ownerOf(_unicornId) != address(0);
409     }
410 
411 
412     function transferFrom(address _from, address _to, uint256 _unicornId) public {
413         require(_to != address(this));
414         require(allowance(msg.sender, _unicornId));
415         clearApprovalAndTransfer(_from, _to, _unicornId);
416     }
417 
418 
419     function fromHexChar(uint8 _c) internal pure returns (uint8) {
420         return _c - (_c < 58 ? 48 : (_c < 97 ? 55 : 87));
421     }
422 
423 
424     function getUnicornGenByte(uint _unicornId, uint _byteNo) public view returns (uint8) {
425         uint n = _byteNo << 1; // = _byteNo * 2
426         //        require(unicorns[_unicornId].gene.length >= n + 1);
427         if (unicorns[_unicornId].gene.length < n + 1) {
428             return 0;
429         }
430         return fromHexChar(uint8(unicorns[_unicornId].gene[n])) << 4 | fromHexChar(uint8(unicorns[_unicornId].gene[n + 1]));
431     }
432 
433 
434     function setName(uint256 _unicornId, string _name ) public onlyOwnerOf(_unicornId) returns (bool) {
435         bytes memory tmp = bytes(unicorns[_unicornId].name);
436         require(tmp.length == 0);
437 
438         unicorns[_unicornId].name = _name;
439         return true;
440     }
441 
442 
443     function getGen(uint _unicornId) external view returns (bytes){
444         return unicorns[_unicornId].gene;
445     }
446 
447     function setGene(uint _unicornId, bytes _gene) onlyBlackBox external  {
448         if (unicorns[_unicornId].gene.length == 0) {
449             unicorns[_unicornId].gene = _gene;
450             emit UnicornGeneSet(_unicornId);
451         }
452     }
453 
454     function updateGene(uint _unicornId, bytes _gene) onlyGeneLab public {
455         require(unicornApprovalsForGeneLab[_unicornId]);
456         delete unicornApprovalsForGeneLab[_unicornId];
457         unicorns[_unicornId].gene = _gene;
458         emit UnicornGeneUpdate(_unicornId);
459     }
460 
461     function approveForGeneLab(uint256 _unicornId) public onlyOwnerOf(_unicornId) {
462         unicornApprovalsForGeneLab[_unicornId] = true;
463     }
464 
465     function clearApprovalForGeneLab(uint256 _unicornId) public onlyOwnerOf(_unicornId) {
466         delete unicornApprovalsForGeneLab[_unicornId];
467     }
468 
469     //transfer by market
470     function marketTransfer(address _from, address _to, uint256 _unicornId) onlyBreeding external {
471         clearApprovalAndTransfer(_from, _to, _unicornId);
472     }
473 
474     function plusFreezingTime(uint _unicornId) onlyBreeding external  {
475         unicorns[_unicornId].freezingEndTime = uint64(_getFreezeTime(getUnicornGenByte(_unicornId, 163)) + now);
476         emit UnicornFreezingTimeSet(_unicornId, unicorns[_unicornId].freezingEndTime);
477     }
478 
479     function plusTourFreezingTime(uint _unicornId) onlyBreeding external {
480         unicorns[_unicornId].freezingTourEndTime = uint64(_getFreezeTime(getUnicornGenByte(_unicornId, 168)) + now);
481         emit UnicornTourFreezingTimeSet(_unicornId, unicorns[_unicornId].freezingTourEndTime);
482     }
483 
484     function _getFreezeTime(uint8 freezingIndex) internal view returns (uint time) {
485         freezingIndex %= maxFreezingIndex;
486         time = freezing[freezingIndex];
487         if (freezingPlusCount[freezingIndex] != 0) {
488             time += (uint(block.blockhash(block.number - 1)) % freezingPlusCount[freezingIndex]) * 1 hours;
489         }
490     }
491 
492 
493     //change freezing time for candy
494     function minusFreezingTime(uint _unicornId, uint64 _time) onlyBreeding public {
495         //не минусуем на уже размороженных конях
496         require(unicorns[_unicornId].freezingEndTime > now);
497         //не используем safeMath, т.к. subFreezingTime в теории не должен быть больше now %)
498         unicorns[_unicornId].freezingEndTime -= _time;
499     }
500 
501     //change tour freezing time for candy
502     function minusTourFreezingTime(uint _unicornId, uint64 _time) onlyBreeding public {
503         //не минусуем на уже размороженных конях
504         require(unicorns[_unicornId].freezingTourEndTime > now);
505         //не используем safeMath, т.к. subTourFreezingTime в теории не должен быть больше now %)
506         unicorns[_unicornId].freezingTourEndTime -= _time;
507     }
508 
509     function isUnfreezed(uint _unicornId) public view returns (bool) {
510         return (unicorns[_unicornId].birthTime > 0 && unicorns[_unicornId].freezingEndTime <= uint64(now));
511     }
512 
513     function isTourUnfreezed(uint _unicornId) public view returns (bool) {
514         return (unicorns[_unicornId].birthTime > 0 && unicorns[_unicornId].freezingTourEndTime <= uint64(now));
515     }
516 
517 }
518 
519 contract UnicornToken is UnicornBase {
520     string public constant name = "UnicornGO";
521     string public constant symbol = "UNG";
522 
523     function UnicornToken(address _unicornManagementAddress) UnicornAccessControl(_unicornManagementAddress) public {
524 
525     }
526 
527     function init() onlyManagement whenPaused external {
528         unicornBreeding = UnicornBreedingInterface(unicornManagement.unicornBreedingAddress());
529     }
530 
531     function() public {
532 
533     }
534 }