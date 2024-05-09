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
92 interface tokenRecipient {
93     function receiveApproval(address _from, address _token, uint _value, bytes _extraData) external;
94     function receiveCreateAuction(address _from, address _token, uint _tokenId, uint _startPrice, uint _duration) external;
95     function receiveCreateAuctionFromArray(address _from, address _token, uint[] _landIds, uint _startPrice, uint _duration) external;
96 }
97 
98 
99 contract ERC721 {
100     function implementsERC721() public pure returns (bool);
101     function totalSupply() public view returns (uint256 total);
102     function balanceOf(address _owner) public view returns (uint256 balance);
103     function ownerOf(uint256 _tokenId) public view returns (address owner);
104     function approve(address _to, uint256 _tokenId) public returns (bool);
105     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool);
106     function transfer(address _to, uint256 _tokenId) public returns (bool);
107     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
108     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
109 
110     // Optional
111     // function name() public view returns (string name);
112     // function symbol() public view returns (string symbol);
113     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
114     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
115 }
116 
117 
118 
119 contract LandBase is ERC721, Ownable {
120     using SafeMath for uint;
121 
122     event NewLand(address indexed owner, uint256 landId);
123 
124     struct Land {
125         uint id;
126     }
127 
128 
129     // Total amount of lands
130     uint256 private totalLands;
131 
132     // Incremental counter of lands Id
133     uint256 private lastLandId;
134 
135     //Mapping from land ID to Land struct
136     mapping(uint256 => Land) public lands;
137 
138     // Mapping from land ID to owner
139     mapping(uint256 => address) private landOwner;
140 
141     // Mapping from land ID to approved address
142     mapping(uint256 => address) private landApprovals;
143 
144     // Mapping from owner to list of owned lands IDs
145     mapping(address => uint256[]) private ownedLands;
146 
147     // Mapping from land ID to index of the owner lands list
148     // т.е. ID земли => порядковый номер в списке владельца
149     mapping(uint256 => uint256) private ownedLandsIndex;
150 
151 
152     modifier onlyOwnerOf(uint256 _tokenId) {
153         require(owns(msg.sender, _tokenId));
154         _;
155     }
156 
157     /**
158     * @dev Gets the owner of the specified land ID
159     * @param _tokenId uint256 ID of the land to query the owner of
160     * @return owner address currently marked as the owner of the given land ID
161     */
162     function ownerOf(uint256 _tokenId) public view returns (address) {
163         return landOwner[_tokenId];
164     }
165 
166     function totalSupply() public view returns (uint256) {
167         return totalLands;
168     }
169 
170     /**
171     * @dev Gets the balance of the specified address
172     * @param _owner address to query the balance of
173     * @return uint256 representing the amount owned by the passed address
174     */
175     function balanceOf(address _owner) public view returns (uint256) {
176         return ownedLands[_owner].length;
177     }
178 
179     /**
180     * @dev Gets the list of lands owned by a given address
181     * @param _owner address to query the lands of
182     * @return uint256[] representing the list of lands owned by the passed address
183     */
184     function landsOf(address _owner) public view returns (uint256[]) {
185         return ownedLands[_owner];
186     }
187 
188     /**
189     * @dev Gets the approved address to take ownership of a given land ID
190     * @param _tokenId uint256 ID of the land to query the approval of
191     * @return address currently approved to take ownership of the given land ID
192     */
193     function approvedFor(uint256 _tokenId) public view returns (address) {
194         return landApprovals[_tokenId];
195     }
196 
197     /**
198     * @dev Tells whether the msg.sender is approved for the given land ID or not
199     * This function is not private so it can be extended in further implementations like the operatable ERC721
200     * @param _owner address of the owner to query the approval of
201     * @param _tokenId uint256 ID of the land to query the approval of
202     * @return bool whether the msg.sender is approved for the given land ID or not
203     */
204     function allowance(address _owner, uint256 _tokenId) public view returns (bool) {
205         return approvedFor(_tokenId) == _owner;
206     }
207 
208     /**
209     * @dev Approves another address to claim for the ownership of the given land ID
210     * @param _to address to be approved for the given land ID
211     * @param _tokenId uint256 ID of the land to be approved
212     */
213     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) returns (bool) {
214         require(_to != msg.sender);
215         if (approvedFor(_tokenId) != address(0) || _to != address(0)) {
216             landApprovals[_tokenId] = _to;
217             emit Approval(msg.sender, _to, _tokenId);
218             return true;
219         }
220     }
221 
222 
223     function approveAndCall(address _spender, uint256 _tokenId, bytes _extraData) public returns (bool) {
224         tokenRecipient spender = tokenRecipient(_spender);
225         if (approve(_spender, _tokenId)) {
226             spender.receiveApproval(msg.sender, this, _tokenId, _extraData);
227             return true;
228         }
229     }
230 
231 
232     function createAuction(address _auction, uint _tokenId, uint _startPrice, uint _duration) public returns (bool) {
233         tokenRecipient auction = tokenRecipient(_auction);
234         if (approve(_auction, _tokenId)) {
235             auction.receiveCreateAuction(msg.sender, this, _tokenId, _startPrice, _duration);
236             return true;
237         }
238     }
239 
240 
241     function createAuctionFromArray(address _auction, uint[] _landIds, uint _startPrice, uint _duration) public returns (bool) {
242         tokenRecipient auction = tokenRecipient(_auction);
243 
244         for (uint i = 0; i < _landIds.length; ++i)
245             require(approve(_auction, _landIds[i]));
246 
247         auction.receiveCreateAuctionFromArray(msg.sender, this, _landIds, _startPrice, _duration);
248         return true;
249     }
250 
251     /**
252     * @dev Claims the ownership of a given land ID
253     * @param _tokenId uint256 ID of the land being claimed by the msg.sender
254     */
255     function takeOwnership(uint256 _tokenId) public {
256         require(allowance(msg.sender, _tokenId));
257         clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
258     }
259 
260     /**
261     * @dev Transfers the ownership of a given land ID to another address
262     * @param _to address to receive the ownership of the given land ID
263     * @param _tokenId uint256 ID of the land to be transferred
264     */
265     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) returns (bool) {
266         clearApprovalAndTransfer(msg.sender, _to, _tokenId);
267         return true;
268     }
269 
270 
271     function ownerTransfer(address _from, address _to, uint256 _tokenId) onlyAdmin public returns (bool) {
272         clearApprovalAndTransfer(_from, _to, _tokenId);
273         return true;
274     }
275 
276     /**
277     * @dev Internal function to clear current approval and transfer the ownership of a given land ID
278     * @param _from address which you want to send lands from
279     * @param _to address which you want to transfer the land to
280     * @param _tokenId uint256 ID of the land to be transferred
281     */
282     function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
283         require(owns(_from, _tokenId));
284         require(_to != address(0));
285         require(_to != ownerOf(_tokenId));
286 
287         clearApproval(_from, _tokenId);
288         removeLand(_from, _tokenId);
289         addLand(_to, _tokenId);
290         emit Transfer(_from, _to, _tokenId);
291     }
292 
293     /**
294     * @dev Internal function to clear current approval of a given land ID
295     * @param _tokenId uint256 ID of the land to be transferred
296     */
297     function clearApproval(address _owner, uint256 _tokenId) private {
298         require(owns(_owner, _tokenId));
299         landApprovals[_tokenId] = address(0);
300         emit Approval(_owner, address(0), _tokenId);
301     }
302 
303     /**
304     * @dev Internal function to add a land ID to the list of a given address
305     * @param _to address representing the new owner of the given land ID
306     * @param _tokenId uint256 ID of the land to be added to the lands list of the given address
307     */
308     function addLand(address _to, uint256 _tokenId) private {
309         require(landOwner[_tokenId] == address(0));
310         landOwner[_tokenId] = _to;
311 
312         uint256 length = ownedLands[_to].length;
313         ownedLands[_to].push(_tokenId);
314         ownedLandsIndex[_tokenId] = length;
315         totalLands = totalLands.add(1);
316     }
317 
318     /**
319     * @dev Internal function to remove a land ID from the list of a given address
320     * @param _from address representing the previous owner of the given land ID
321     * @param _tokenId uint256 ID of the land to be removed from the lands list of the given address
322     */
323     function removeLand(address _from, uint256 _tokenId) private {
324         require(owns(_from, _tokenId));
325 
326         uint256 landIndex = ownedLandsIndex[_tokenId];
327         //        uint256 lastLandIndex = balanceOf(_from).sub(1);
328         uint256 lastLandIndex = ownedLands[_from].length.sub(1);
329         uint256 lastLand = ownedLands[_from][lastLandIndex];
330 
331         landOwner[_tokenId] = address(0);
332         ownedLands[_from][landIndex] = lastLand;
333         ownedLands[_from][lastLandIndex] = 0;
334         // Note that this will handle single-element arrays. In that case, both landIndex and lastLandIndex are going to
335         // be zero. Then we can make sure that we will remove _tokenId from the ownedLands list since we are first swapping
336         // the lastLand to the first position, and then dropping the element placed in the last position of the list
337 
338         ownedLands[_from].length--;
339         ownedLandsIndex[_tokenId] = 0;
340         ownedLandsIndex[lastLand] = landIndex;
341         totalLands = totalLands.sub(1);
342     }
343 
344 
345     function createLand(address _owner, uint _id) onlyAdmin public returns (uint) {
346         require(_owner != address(0));
347         uint256 _tokenId = lastLandId++;
348         addLand(_owner, _tokenId);
349         //store new land data
350         lands[_tokenId] = Land({
351             id : _id
352             });
353         emit Transfer(address(0), _owner, _tokenId);
354         emit NewLand(_owner, _tokenId);
355         return _tokenId;
356     }
357 
358     function createLandAndAuction(address _owner, uint _id, address _auction, uint _startPrice, uint _duration) onlyAdmin public
359     {
360         uint id = createLand(_owner, _id);
361         require(createAuction(_auction, id, _startPrice, _duration));
362     }
363 
364 
365     function owns(address _claimant, uint256 _tokenId) public view returns (bool) {
366         return ownerOf(_tokenId) == _claimant && ownerOf(_tokenId) != address(0);
367     }
368 
369 
370     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {
371         require(_to != address(this));
372         require(allowance(msg.sender, _tokenId));
373         clearApprovalAndTransfer(_from, _to, _tokenId);
374         return true;
375     }
376 
377 }
378 
379 
380 contract ArconaDigitalLand is LandBase {
381     string public constant name = " Arcona Digital Land";
382     string public constant symbol = "ARDL";
383 
384     function implementsERC721() public pure returns (bool)
385     {
386         return true;
387     }
388 
389     function() public payable{
390         revert();
391     }
392 }