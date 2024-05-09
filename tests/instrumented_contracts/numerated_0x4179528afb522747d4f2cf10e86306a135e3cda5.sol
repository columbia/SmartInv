1 pragma solidity 0.4.24;
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
32 contract Ownable {
33     address public owner;
34     mapping(address => bool) admins;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37     event AddAdmin(address indexed admin);
38     event DelAdmin(address indexed admin);
39 
40 
41     /**
42      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43      * account.
44      */
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     modifier onlyAdmin() {
58         require(isAdmin(msg.sender));
59         _;
60     }
61 
62 
63     function addAdmin(address _adminAddress) external onlyOwner {
64         require(_adminAddress != address(0));
65         admins[_adminAddress] = true;
66         emit AddAdmin(_adminAddress);
67     }
68 
69     function delAdmin(address _adminAddress) external onlyOwner {
70         require(admins[_adminAddress]);
71         admins[_adminAddress] = false;
72         emit DelAdmin(_adminAddress);
73     }
74 
75     function isAdmin(address _adminAddress) public view returns (bool) {
76         return admins[_adminAddress];
77     }
78     /**
79      * @dev Allows the current owner to transfer control of the contract to a newOwner.
80      * @param _newOwner The address to transfer ownership to.
81      */
82     function transferOwnership(address _newOwner) external onlyOwner {
83         require(_newOwner != address(0));
84         emit OwnershipTransferred(owner, _newOwner);
85         owner = _newOwner;
86     }
87 
88 }
89 
90 
91 
92 contract LandTokenInterface {
93     //ERC721
94     function balanceOf(address _owner) public view returns (uint256 _balance);
95     function ownerOf(uint256 _landId) public view returns (address _owner);
96     function transfer(address _to, uint256 _landId) public;
97     function approve(address _to, uint256 _landId) public;
98     function takeOwnership(uint256 _landId) public;
99     function totalSupply() public view returns (uint);
100     function owns(address _claimant, uint256 _landId) public view returns (bool);
101     function allowance(address _claimant, uint256 _landId) public view returns (bool);
102     function transferFrom(address _from, address _to, uint256 _landId) public;
103     function createLand(address _owner) external returns (uint);
104 }
105 
106 interface tokenRecipient {
107     function receiveApproval(address _from, address _token, uint _value, bytes _extraData) external;
108     function receiveCreateAuction(address _from, address _token, uint _landId, uint _startPrice, uint _duration) external;
109     function receiveCreateAuctionFromArray(address _from, address _token, uint[] _landIds, uint _startPrice, uint _duration) external;
110 }
111 
112 contract LandBase is Ownable {
113     using SafeMath for uint;
114 
115     event Transfer(address indexed from, address indexed to, uint256 indexed landId);
116     event Approval(address indexed owner, address indexed approved, uint256 landId);
117     event NewLand(address indexed owner, uint256 landId);
118 
119     struct Land {
120         uint id;
121     }
122 
123 
124     // Total amount of lands
125     uint256 private totalLands;
126 
127     // Incremental counter of lands Id
128     uint256 private lastLandId;
129 
130     //Mapping from land ID to Land struct
131     mapping(uint256 => Land) public lands;
132 
133     // Mapping from land ID to owner
134     mapping(uint256 => address) private landOwner;
135 
136     // Mapping from land ID to approved address
137     mapping(uint256 => address) private landApprovals;
138 
139     // Mapping from owner to list of owned lands IDs
140     mapping(address => uint256[]) private ownedLands;
141 
142     // Mapping from land ID to index of the owner lands list
143     // т.е. ID земли => порядковый номер в списке владельца
144     mapping(uint256 => uint256) private ownedLandsIndex;
145 
146 
147     modifier onlyOwnerOf(uint256 _landId) {
148         require(owns(msg.sender, _landId));
149         _;
150     }
151 
152     /**
153     * @dev Gets the owner of the specified land ID
154     * @param _landId uint256 ID of the land to query the owner of
155     * @return owner address currently marked as the owner of the given land ID
156     */
157     function ownerOf(uint256 _landId) public view returns (address) {
158         return landOwner[_landId];
159     }
160 
161     function totalSupply() public view returns (uint256) {
162         return totalLands;
163     }
164 
165     /**
166     * @dev Gets the balance of the specified address
167     * @param _owner address to query the balance of
168     * @return uint256 representing the amount owned by the passed address
169     */
170     function balanceOf(address _owner) public view returns (uint256) {
171         return ownedLands[_owner].length;
172     }
173 
174     /**
175     * @dev Gets the list of lands owned by a given address
176     * @param _owner address to query the lands of
177     * @return uint256[] representing the list of lands owned by the passed address
178     */
179     function landsOf(address _owner) public view returns (uint256[]) {
180         return ownedLands[_owner];
181     }
182 
183     /**
184     * @dev Gets the approved address to take ownership of a given land ID
185     * @param _landId uint256 ID of the land to query the approval of
186     * @return address currently approved to take ownership of the given land ID
187     */
188     function approvedFor(uint256 _landId) public view returns (address) {
189         return landApprovals[_landId];
190     }
191 
192     /**
193     * @dev Tells whether the msg.sender is approved for the given land ID or not
194     * This function is not private so it can be extended in further implementations like the operatable ERC721
195     * @param _owner address of the owner to query the approval of
196     * @param _landId uint256 ID of the land to query the approval of
197     * @return bool whether the msg.sender is approved for the given land ID or not
198     */
199     function allowance(address _owner, uint256 _landId) public view returns (bool) {
200         return approvedFor(_landId) == _owner;
201     }
202 
203     /**
204     * @dev Approves another address to claim for the ownership of the given land ID
205     * @param _to address to be approved for the given land ID
206     * @param _landId uint256 ID of the land to be approved
207     */
208     function approve(address _to, uint256 _landId) public onlyOwnerOf(_landId) returns (bool) {
209         require(_to != msg.sender);
210         if (approvedFor(_landId) != address(0) || _to != address(0)) {
211             landApprovals[_landId] = _to;
212             emit Approval(msg.sender, _to, _landId);
213             return true;
214         }
215     }
216 
217 
218     function approveAndCall(address _spender, uint256 _landId, bytes _extraData) public returns (bool) {
219         tokenRecipient spender = tokenRecipient(_spender);
220         if (approve(_spender, _landId)) {
221             spender.receiveApproval(msg.sender, this, _landId, _extraData);
222             return true;
223         }
224     }
225 
226 
227     function createAuction(address _auction, uint _landId, uint _startPrice, uint _duration) public returns (bool) {
228         tokenRecipient auction = tokenRecipient(_auction);
229         if (approve(_auction, _landId)) {
230             auction.receiveCreateAuction(msg.sender, this, _landId, _startPrice, _duration);
231             return true;
232         }
233     }
234 
235 
236     function createAuctionFromArray(address _auction, uint[] _landIds, uint _startPrice, uint _duration) public returns (bool) {
237         tokenRecipient auction = tokenRecipient(_auction);
238 
239         for (uint i = 0; i < _landIds.length; ++i)
240             require(approve(_auction, _landIds[i]));
241 
242         auction.receiveCreateAuctionFromArray(msg.sender, this, _landIds, _startPrice, _duration);
243         return true;
244     }
245 
246     /**
247     * @dev Claims the ownership of a given land ID
248     * @param _landId uint256 ID of the land being claimed by the msg.sender
249     */
250     function takeOwnership(uint256 _landId) public {
251         require(allowance(msg.sender, _landId));
252         clearApprovalAndTransfer(ownerOf(_landId), msg.sender, _landId);
253     }
254 
255     /**
256     * @dev Transfers the ownership of a given land ID to another address
257     * @param _to address to receive the ownership of the given land ID
258     * @param _landId uint256 ID of the land to be transferred
259     */
260     function transfer(address _to, uint256 _landId) public onlyOwnerOf(_landId) returns (bool) {
261         clearApprovalAndTransfer(msg.sender, _to, _landId);
262         return true;
263     }
264 
265 
266     function ownerTransfer(address _from, address _to, uint256 _landId) onlyAdmin public returns (bool) {
267         clearApprovalAndTransfer(_from, _to, _landId);
268         return true;
269     }
270 
271     /**
272     * @dev Internal function to clear current approval and transfer the ownership of a given land ID
273     * @param _from address which you want to send lands from
274     * @param _to address which you want to transfer the land to
275     * @param _landId uint256 ID of the land to be transferred
276     */
277     function clearApprovalAndTransfer(address _from, address _to, uint256 _landId) internal {
278         require(owns(_from, _landId));
279         require(_to != address(0));
280         require(_to != ownerOf(_landId));
281 
282         clearApproval(_from, _landId);
283         removeLand(_from, _landId);
284         addLand(_to, _landId);
285         emit Transfer(_from, _to, _landId);
286     }
287 
288     /**
289     * @dev Internal function to clear current approval of a given land ID
290     * @param _landId uint256 ID of the land to be transferred
291     */
292     function clearApproval(address _owner, uint256 _landId) private {
293         require(owns(_owner, _landId));
294         landApprovals[_landId] = address(0);
295         emit Approval(_owner, address(0), _landId);
296     }
297 
298     /**
299     * @dev Internal function to add a land ID to the list of a given address
300     * @param _to address representing the new owner of the given land ID
301     * @param _landId uint256 ID of the land to be added to the lands list of the given address
302     */
303     function addLand(address _to, uint256 _landId) private {
304         require(landOwner[_landId] == address(0));
305         landOwner[_landId] = _to;
306 
307         uint256 length = ownedLands[_to].length;
308         ownedLands[_to].push(_landId);
309         ownedLandsIndex[_landId] = length;
310         totalLands = totalLands.add(1);
311     }
312 
313     /**
314     * @dev Internal function to remove a land ID from the list of a given address
315     * @param _from address representing the previous owner of the given land ID
316     * @param _landId uint256 ID of the land to be removed from the lands list of the given address
317     */
318     function removeLand(address _from, uint256 _landId) private {
319         require(owns(_from, _landId));
320 
321         uint256 landIndex = ownedLandsIndex[_landId];
322         //        uint256 lastLandIndex = balanceOf(_from).sub(1);
323         uint256 lastLandIndex = ownedLands[_from].length.sub(1);
324         uint256 lastLand = ownedLands[_from][lastLandIndex];
325 
326         landOwner[_landId] = address(0);
327         ownedLands[_from][landIndex] = lastLand;
328         ownedLands[_from][lastLandIndex] = 0;
329         // Note that this will handle single-element arrays. In that case, both landIndex and lastLandIndex are going to
330         // be zero. Then we can make sure that we will remove _landId from the ownedLands list since we are first swapping
331         // the lastLand to the first position, and then dropping the element placed in the last position of the list
332 
333         ownedLands[_from].length--;
334         ownedLandsIndex[_landId] = 0;
335         ownedLandsIndex[lastLand] = landIndex;
336         totalLands = totalLands.sub(1);
337     }
338 
339 
340     function createLand(address _owner, uint _id) onlyAdmin public returns (uint) {
341         require(_owner != address(0));
342         uint256 _landId = lastLandId++;
343         addLand(_owner, _landId);
344         //store new land data
345         lands[_landId] = Land({
346             id : _id
347             });
348         emit Transfer(address(0), _owner, _landId);
349         emit NewLand(_owner, _landId);
350         return _landId;
351     }
352 
353     function createLandAndAuction(address _owner, uint _id, address _auction, uint _startPrice, uint _duration) onlyAdmin public
354     {
355         uint id = createLand(_owner, _id);
356         require(createAuction(_auction, id, _startPrice, _duration));
357     }
358 
359 
360     function owns(address _claimant, uint256 _landId) public view returns (bool) {
361         return ownerOf(_landId) == _claimant && ownerOf(_landId) != address(0);
362     }
363 
364 
365     function transferFrom(address _from, address _to, uint256 _landId) public returns (bool) {
366         require(_to != address(this));
367         require(allowance(msg.sender, _landId));
368         clearApprovalAndTransfer(_from, _to, _landId);
369         return true;
370     }
371 
372 }
373 
374 
375 contract ArconaDigitalLand is LandBase {
376     string public constant name = " Arcona Digital Land";
377     string public constant symbol = "ARDL";
378 
379     function() public payable{
380         revert();
381     }
382 }