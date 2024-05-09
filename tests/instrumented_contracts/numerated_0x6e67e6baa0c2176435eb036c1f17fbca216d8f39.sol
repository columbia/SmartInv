1 pragma solidity ^0.4.18;
2 pragma solidity ^0.4.18;
3 
4 //It's open source,but... ;) Good luck! :P
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17     /**
18      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19      * account.
20      */
21     function Ownable() public {
22         owner = msg.sender;
23     }
24 
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 
34 
35     /**
36      * @dev Allows the current owner to transfer control of the contract to a newOwner.
37      * @param newOwner The address to transfer ownership to.
38      */
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 
45 }
46 
47 contract Beneficiary is Ownable {
48 
49     address public beneficiary;
50 
51     function setBeneficiary(address _beneficiary) onlyOwner public {
52         beneficiary = _beneficiary;
53     }
54 
55 
56 }
57 
58 
59 contract Pausable is Beneficiary{
60     bool public paused = false;
61 
62     modifier whenNotPaused() {
63         require(!paused);
64         _;
65     }
66 
67     modifier whenPaused {
68         require(paused);
69         _;
70     }
71 
72     function pause() external onlyOwner whenNotPaused {
73         paused = true;
74     }
75 
76     function unpause() public onlyOwner whenPaused {
77         // can't unpause if contract was upgraded
78         paused = false;
79     }
80 } 
81 
82 library SafeMath {
83 
84   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85     if (a == 0) {
86       return 0;
87     }
88     uint256 c = a * b;
89     assert(c / a == b);
90     return c;
91   }
92 
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     // assert(b > 0); // Solidity automatically throws when dividing by 0
95     uint256 c = a / b;
96     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97     return c;
98   }
99 
100   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101     assert(b <= a);
102     return a - b;
103   }
104 
105   function add(uint256 a, uint256 b) internal pure returns (uint256) {
106     uint256 c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 
113 contract WarshipAccess is Pausable{
114 	address[] public OfficialApps;
115 	//Official games & services
116 
117 	function AddOfficialApps(address _app) onlyOwner public{
118 		require(_app != address(0));
119 		OfficialApps.push(_app);
120 	}
121 	
122 	function nukeApps()onlyOwner public{
123 	    for(uint i = 0; i < OfficialApps.length; i++){
124 			delete OfficialApps[i];
125 	        
126 	    }
127 	}
128 
129 	function _isOfficialApps(address _app) internal view returns (bool){
130 		for(uint i = 0; i < OfficialApps.length; i++){
131 			if( _app == OfficialApps[i] ){
132 				return true;
133 			}
134 		}
135 		return false;
136 	}
137 
138 	modifier OnlyOfficialApps {
139         require(_isOfficialApps(msg.sender));
140         _;
141     }
142 
143 
144 
145 }
146 
147 
148 
149 
150 //main contract for warship
151 
152 contract WarshipMain is WarshipAccess{
153     
154     using SafeMath for uint256;
155 
156     struct Warship {
157         uint128 appearance; //wsic code for producing warship outlook
158         uint32 profile;//profile including ship names
159         uint8 firepower;
160         uint8 armor;
161         uint8 hitrate;
162         uint8 speed;
163         uint8 duration;//ship strength
164         uint8 shiptype;//ship class
165         uint8 level;//strengthening level
166         uint8 status;//how it was built
167         uint16 specials;//16 specials
168         uint16 extend;
169     }//128+32+8*8+16*2=256
170 
171     Warship[] public Ships;
172     mapping (uint256 => address) public ShipIdToOwner;
173     //Supporting 2^32 ships at most.
174     mapping (address => uint256) OwnerShipCount;
175     //Used internally inside balanceOf() to resolve ownership count.
176     mapping (uint256 => address) public ShipIdToApproval;
177     //Each ship can only have one approved address for transfer at any time.
178     mapping (uint256 => uint256) public ShipIdToStatus;
179     //0 for sunk, 1 for live, 2 for min_broken, 3 for max_broken, 4 for on_marketing, 5 for in_pvp
180     //256 statuses at most.
181     
182 
183     //SaleAuction
184     address public SaleAuction;
185     function setSaleAuction(address _sale) onlyOwner public{
186         require(_sale != address(0));
187         SaleAuction = _sale;
188     }
189 
190 
191 
192     //event emitted when ship created or updated
193     event NewShip(address indexed owner, uint indexed shipId, uint256 wsic);
194     event ShipStatusUpdate(uint indexed shipId, uint8 newStatus);
195     event ShipStructUpdate(uint indexed shipId, uint256 wsic);
196 
197     //----erc721 interface
198     bool public implementsERC721 = true;
199     string public constant name = "EtherWarship";
200     string public constant symbol = "SHIP";
201     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); 
202     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
203     function balanceOf(address _owner) public view returns (uint256 _balance){
204         return OwnerShipCount[_owner];
205     }
206     function ownerOf(uint256 _tokenId) public view returns (address _owner){
207         return ShipIdToOwner[_tokenId];
208     }
209     //function transfer(address _to, uint256 _tokenId) public;   //see below
210     //function approve(address _to, uint256 _tokenId) public;    //see below
211     //function takeOwnership(uint256 _tokenId) public;      //see below
212     //----erc721 interface
213 
214 
215     
216 
217     //check if owned/approved
218     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
219         return ShipIdToOwner[_tokenId] == _claimant;
220     }
221     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
222         return ShipIdToApproval[_tokenId] == _claimant;
223     }
224 
225 
226     /// @dev Assigns ownership of a specific ship to an address.
227     function _transfer(address _from, address _to, uint256 _tokenId) internal {
228         OwnerShipCount[_to]=OwnerShipCount[_to].add(1);
229         ShipIdToOwner[_tokenId] = _to;
230         if (_from != address(0)) {
231             OwnerShipCount[_from]=OwnerShipCount[_from].sub(1);
232             // clear any previously approved ownership exchange
233             delete ShipIdToApproval[_tokenId];
234         }
235         Transfer(_from, _to, _tokenId);
236     }
237 
238     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
239     ///  approval. Setting _approved to address(0) clears all transfer approval.
240     function _approve(uint256 _tokenId, address _approved) internal {
241         ShipIdToApproval[_tokenId] = _approved;
242     }
243 
244     /// @dev Required for ERC-721 compliance.
245     function transfer(address _to, uint256 _tokenId) external whenNotPaused {
246         // Safety check to prevent against an unexpected 0x0 default.
247         require(_to != address(0));
248         // Disallow transfers to this contract to prevent accidental misuse.
249         require(_to != address(this));
250         // You can only send your own cat.
251         require(_owns(msg.sender, _tokenId));
252         // Reassign ownership, clear pending approvals, emit Transfer event.
253         require(ShipIdToStatus[_tokenId]==1||msg.sender==SaleAuction);
254         // Ship must be alive.
255 
256         if(msg.sender == SaleAuction){
257             ShipIdToStatus[_tokenId] = 1;
258         }
259 
260         _transfer(msg.sender, _to, _tokenId);
261 
262     }
263 
264     /// @dev Required for ERC-721 compliance.
265     function approve(address _to, uint256 _tokenId) external whenNotPaused {
266         // Only an owner can grant transfer approval.
267         require(_owns(msg.sender, _tokenId));
268         // Register the approval (replacing any previous approval).
269         _approve(_tokenId, _to);
270         // Emit approval event.
271         Approval(msg.sender, _to, _tokenId);
272     }
273 
274     /// @dev Required for ERC-721 compliance.
275     function transferFrom(address _from, address _to, uint256 _tokenId) external whenNotPaused {
276         // Safety check to prevent against an unexpected 0x0 default.
277         require(_to != address(0));
278         // Disallow transfers to this contract to prevent accidental misuse.
279         require(_to != address(this));
280         // Check for approval and valid ownersh ip
281         //p.s. SaleAuction can call transferFrom for anyone
282         require(_approvedFor(msg.sender, _tokenId)||msg.sender==SaleAuction); 
283 
284         require(_owns(_from, _tokenId));
285 
286         require(ShipIdToStatus[_tokenId]==1);
287         // Ship must be alive.
288 
289         if(msg.sender == SaleAuction){
290             ShipIdToStatus[_tokenId] = 4;
291         }
292 
293 
294         // Reassign ownership (also clears pending approvals and emits Transfer event).
295         _transfer(_from, _to, _tokenId);
296     }
297     /// @dev Required for ERC-721 compliance.
298     function totalSupply() public view returns (uint) {
299         return Ships.length;
300     }
301 
302     /// @dev Required for ERC-721 compliance.
303     function takeOwnership(uint256 _tokenId) public {
304         // check approvals
305         require(ShipIdToApproval[_tokenId] == msg.sender);
306 
307         require(ShipIdToStatus[_tokenId]==1);
308         // Ship must be alive.
309 
310         _transfer(ownerOf(_tokenId), msg.sender, _tokenId);
311     }
312 
313 
314     //------------all ERC-721 requirement are present----------------------
315 
316 
317 
318 
319 
320     /// @dev uint256 WSIC to warship structure 
321     function _translateWSIC (uint256 _wsic) internal pure returns(Warship){
322   //    uint128 _appearance = uint128(_wsic >> 128);
323   //    uint32 _profile = uint32((_wsic>>96)&0xffffffff);
324   //    uint8 _firepower = uint8((_wsic>>88)&0xff);
325         // uint8 _armor = uint8((_wsic>>80)&0xff);
326         // uint8 _hitrate = uint8((_wsic>>72)&0xff);
327         // uint8 _speed = uint8((_wsic>>64)&0xff);
328         // uint8 _duration = uint8((_wsic>>56)&0xff);
329         // uint8 _shiptype = uint8((_wsic>>48)&0xff);
330         // uint8 _level = uint8((_wsic>>40)&0xff);
331         // uint8 _status = uint8((_wsic>>32)&0xff);
332         // uint16 _specials = uint16((_wsic>>16)&0xffff);
333         // uint16 _extend = uint16(_wsic&0xffff);
334         Warship memory  _ship = Warship(uint128(_wsic >> 128), uint32((_wsic>>96)&0xffffffff), uint8((_wsic>>88)&0xff), uint8((_wsic>>80)&0xff), uint8((_wsic>>72)&0xff), uint8((_wsic>>64)&0xff),
335          uint8((_wsic>>56)&0xff), uint8((_wsic>>48)&0xff), uint8((_wsic>>40)&0xff), uint8((_wsic>>32)&0xff),  uint16((_wsic>>16)&0xffff), uint16(_wsic&0xffff));
336         return _ship;
337     }
338     function _encodeWSIC(Warship _ship) internal pure returns(uint256){
339         uint256 _wsic = 0x00;
340         _wsic = _wsic ^ (uint256(_ship.appearance) << 128);
341         _wsic = _wsic ^ (uint256(_ship.profile) << 96);
342         _wsic = _wsic ^ (uint256(_ship.firepower) << 88);
343         _wsic = _wsic ^ (uint256(_ship.armor) << 80);
344         _wsic = _wsic ^ (uint256(_ship.hitrate) << 72);
345         _wsic = _wsic ^ (uint256(_ship.speed) << 64);
346         _wsic = _wsic ^ (uint256(_ship.duration) << 56);
347         _wsic = _wsic ^ (uint256(_ship.shiptype) << 48);
348         _wsic = _wsic ^ (uint256(_ship.level) << 40);
349         _wsic = _wsic ^ (uint256(_ship.status) << 32);
350         _wsic = _wsic ^ (uint256(_ship.specials) << 16);
351         _wsic = _wsic ^ (uint256(_ship.extend));
352         return _wsic;
353     }
354 
355 
356     
357 
358     // @dev An internal method that creates a new ship and stores it. This
359     ///  method doesn't do any checking and should only be called when the
360     ///  input data is known to be valid. 
361     function _createship (uint256 _wsic, address _owner) internal returns(uint){
362         //wsic2ship
363         Warship memory _warship = _translateWSIC(_wsic);
364         //push into ships
365         uint256 newshipId = Ships.push(_warship) - 1;
366         //emit event
367         NewShip(_owner, newshipId, _wsic);
368         //set to alive
369         ShipIdToStatus[newshipId] = 1;
370         //transfer 0 to owner
371         _transfer(0, _owner, newshipId);
372         //"Where is the counter?Repeat that.Where is the counter?Everyone want to know it.----Troll XI"
373        
374         
375 
376         return newshipId; 
377     }
378 
379     /// @dev An internal method that update a new ship. 
380     function _update (uint256 _wsic, uint256 _tokenId) internal returns(bool){
381         //check if id is valid
382         require(_tokenId <= totalSupply());
383         //wsic2ship
384         Warship memory _warship = _translateWSIC(_wsic);
385         //emit event
386         ShipStructUpdate(_tokenId, _wsic);
387         //update
388         Ships[_tokenId] = _warship;
389 
390         return true;
391     }
392 
393 
394     /// @dev Allow official apps to create ship.
395     function createship(uint256 _wsic, address _owner) external OnlyOfficialApps returns(uint){
396         //check address
397         require(_owner != address(0));
398         return _createship(_wsic, _owner);
399     }
400 
401     /// @dev Allow official apps to update ship.
402     function updateship (uint256 _wsic, uint256 _tokenId) external OnlyOfficialApps returns(bool){
403         return _update(_wsic, _tokenId);
404     }
405     /// @dev Allow official apps to update ship.
406     function SetStatus(uint256 _tokenId, uint256 _status) external OnlyOfficialApps returns(bool){
407         require(uint8(_status)==_status);
408         ShipIdToStatus[_tokenId] = _status;
409         ShipStatusUpdate(_tokenId, uint8(_status));
410         return true;
411     }
412 
413 
414 
415 
416 
417 
418     /// @dev Get wsic code for a ship.
419     function Getwsic(uint256 _tokenId) external view returns(uint256){
420         //check if id is valid
421         require(_tokenId < Ships.length);
422         uint256 _wsic = _encodeWSIC(Ships[_tokenId]);
423         return _wsic;
424     }
425 
426     /// @dev Get ships for a specified user.
427     function GetShipsByOwner(address _owner) external view returns(uint[]) {
428     uint[] memory result = new uint[](OwnerShipCount[_owner]);
429     uint counter = 0;
430     for (uint i = 0; i < Ships.length; i++) {
431           if (ShipIdToOwner[i] == _owner) {
432             result[counter] = i;
433             counter++;
434           }
435         }
436     return result;
437     }
438 
439     /// @dev Get status
440     function GetStatus(uint256 _tokenId) external view returns(uint){
441         return ShipIdToStatus[_tokenId];
442     }
443 
444 
445 
446 }