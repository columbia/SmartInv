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
34 
35 
36     event OwnershipRenounced(address indexed previousOwner);
37     event OwnershipTransferred(
38         address indexed previousOwner,
39         address indexed newOwner
40     );
41 
42 
43     /**
44      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45      * account.
46      */
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     /**
60      * @dev Allows the current owner to relinquish control of the contract.
61      * @notice Renouncing to ownership will leave the contract without an owner.
62      * It will not be possible to call the functions with the `onlyOwner`
63      * modifier anymore.
64      */
65     //    function renounceOwnership() public onlyOwner {
66     //        emit OwnershipRenounced(owner);
67     //        owner = address(0);
68     //    }
69 
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param _newOwner The address to transfer ownership to.
73      */
74     function transferOwnership(address _newOwner) public onlyOwner {
75         _transferOwnership(_newOwner);
76     }
77 
78     /**
79      * @dev Transfers control of the contract to a newOwner.
80      * @param _newOwner The address to transfer ownership to.
81      */
82     function _transferOwnership(address _newOwner) internal {
83         require(_newOwner != address(0));
84         emit OwnershipTransferred(owner, _newOwner);
85         owner = _newOwner;
86     }
87 }
88 
89 
90 
91 contract LandTokenInterface {
92     //ERC721
93     function balanceOf(address _owner) public view returns (uint256 _balance);
94     function ownerOf(uint256 _landId) public view returns (address _owner);
95     function transfer(address _to, uint256 _landId) public;
96     function approve(address _to, uint256 _landId) public;
97     function takeOwnership(uint256 _landId) public;
98     function totalSupply() public view returns (uint);
99     function owns(address _claimant, uint256 _landId) public view returns (bool);
100     function allowance(address _claimant, uint256 _landId) public view returns (bool);
101     function transferFrom(address _from, address _to, uint256 _landId) public;
102     function createLand(address _owner) external returns (uint);
103 }
104 
105 interface tokenRecipient {
106     function receiveApproval(address _from, address _token, uint _value, bytes _extraData) external;
107     function receiveCreateAuction(address _from, address _token, uint _landId, uint _startPrice, uint _duration) external;
108     function receiveCreateAuctionFromArray(address _from, address _token, uint[] _landIds, uint _startPrice, uint _duration) external;
109 }
110 
111 contract LandBase is Ownable {
112     using SafeMath for uint;
113 
114     event Transfer(address indexed from, address indexed to, uint256 landId);
115     event Approval(address indexed owner, address indexed approved, uint256 landId);
116     event NewLand(address indexed owner, uint256 landId);
117 
118     struct Land {
119         uint id;
120     }
121 
122 
123     // Total amount of lands
124     uint256 private totalLands;
125 
126     // Incremental counter of lands Id
127     uint256 private lastLandId;
128 
129     //Mapping from land ID to Land struct
130     mapping(uint256 => Land) public lands;
131 
132     // Mapping from land ID to owner
133     mapping(uint256 => address) private landOwner;
134 
135     // Mapping from land ID to approved address
136     mapping(uint256 => address) private landApprovals;
137 
138     // Mapping from owner to list of owned lands IDs
139     mapping(address => uint256[]) private ownedLands;
140 
141     // Mapping from land ID to index of the owner lands list
142     // т.е. ID земли => порядковый номер в списке владельца
143     mapping(uint256 => uint256) private ownedLandsIndex;
144 
145 
146     modifier onlyOwnerOf(uint256 _landId) {
147         require(owns(msg.sender, _landId));
148         _;
149     }
150 
151     /**
152     * @dev Gets the owner of the specified land ID
153     * @param _landId uint256 ID of the land to query the owner of
154     * @return owner address currently marked as the owner of the given land ID
155     */
156     function ownerOf(uint256 _landId) public view returns (address) {
157         return landOwner[_landId];
158     }
159 
160     function totalSupply() public view returns (uint256) {
161         return totalLands;
162     }
163 
164     /**
165     * @dev Gets the balance of the specified address
166     * @param _owner address to query the balance of
167     * @return uint256 representing the amount owned by the passed address
168     */
169     function balanceOf(address _owner) public view returns (uint256) {
170         return ownedLands[_owner].length;
171     }
172 
173     /**
174     * @dev Gets the list of lands owned by a given address
175     * @param _owner address to query the lands of
176     * @return uint256[] representing the list of lands owned by the passed address
177     */
178     function landsOf(address _owner) public view returns (uint256[]) {
179         return ownedLands[_owner];
180     }
181 
182     /**
183     * @dev Gets the approved address to take ownership of a given land ID
184     * @param _landId uint256 ID of the land to query the approval of
185     * @return address currently approved to take ownership of the given land ID
186     */
187     function approvedFor(uint256 _landId) public view returns (address) {
188         return landApprovals[_landId];
189     }
190 
191     /**
192     * @dev Tells whether the msg.sender is approved for the given land ID or not
193     * This function is not private so it can be extended in further implementations like the operatable ERC721
194     * @param _owner address of the owner to query the approval of
195     * @param _landId uint256 ID of the land to query the approval of
196     * @return bool whether the msg.sender is approved for the given land ID or not
197     */
198     function allowance(address _owner, uint256 _landId) public view returns (bool) {
199         return approvedFor(_landId) == _owner;
200     }
201 
202     /**
203     * @dev Approves another address to claim for the ownership of the given land ID
204     * @param _to address to be approved for the given land ID
205     * @param _landId uint256 ID of the land to be approved
206     */
207     function approve(address _to, uint256 _landId) public onlyOwnerOf(_landId) returns (bool) {
208         require(_to != msg.sender);
209         if (approvedFor(_landId) != address(0) || _to != address(0)) {
210             landApprovals[_landId] = _to;
211             emit Approval(msg.sender, _to, _landId);
212             return true;
213         }
214     }
215 
216 
217     function approveAndCall(address _spender, uint256 _landId, bytes _extraData) public returns (bool) {
218         tokenRecipient spender = tokenRecipient(_spender);
219         if (approve(_spender, _landId)) {
220             spender.receiveApproval(msg.sender, this, _landId, _extraData);
221             return true;
222         }
223     }
224 
225 
226     function createAuction(address _auction, uint _landId, uint _startPrice, uint _duration) public returns (bool) {
227         tokenRecipient auction = tokenRecipient(_auction);
228         if (approve(_auction, _landId)) {
229             auction.receiveCreateAuction(msg.sender, this, _landId, _startPrice, _duration);
230             return true;
231         }
232     }
233 
234 
235     function createAuctionFromArray(address _auction, uint[] _landIds, uint _startPrice, uint _duration) public returns (bool) {
236         tokenRecipient auction = tokenRecipient(_auction);
237 
238         for (uint i = 0; i < _landIds.length; ++i)
239             require(approve(_auction, _landIds[i]));
240 
241         auction.receiveCreateAuctionFromArray(msg.sender, this, _landIds, _startPrice, _duration);
242         return true;
243     }
244 
245     /**
246     * @dev Claims the ownership of a given land ID
247     * @param _landId uint256 ID of the land being claimed by the msg.sender
248     */
249     function takeOwnership(uint256 _landId) public {
250         require(allowance(msg.sender, _landId));
251         clearApprovalAndTransfer(ownerOf(_landId), msg.sender, _landId);
252     }
253 
254     /**
255     * @dev Transfers the ownership of a given land ID to another address
256     * @param _to address to receive the ownership of the given land ID
257     * @param _landId uint256 ID of the land to be transferred
258     */
259     function transfer(address _to, uint256 _landId) public onlyOwnerOf(_landId) returns (bool) {
260         clearApprovalAndTransfer(msg.sender, _to, _landId);
261         return true;
262     }
263 
264 
265     /**
266     * @dev Internal function to clear current approval and transfer the ownership of a given land ID
267     * @param _from address which you want to send lands from
268     * @param _to address which you want to transfer the land to
269     * @param _landId uint256 ID of the land to be transferred
270     */
271     function clearApprovalAndTransfer(address _from, address _to, uint256 _landId) internal {
272         require(owns(_from, _landId));
273         require(_to != address(0));
274         require(_to != ownerOf(_landId));
275 
276         clearApproval(_from, _landId);
277         removeLand(_from, _landId);
278         addLand(_to, _landId);
279         emit Transfer(_from, _to, _landId);
280     }
281 
282     /**
283     * @dev Internal function to clear current approval of a given land ID
284     * @param _landId uint256 ID of the land to be transferred
285     */
286     function clearApproval(address _owner, uint256 _landId) private {
287         require(owns(_owner, _landId));
288         landApprovals[_landId] = address(0);
289         emit Approval(_owner, address(0), _landId);
290     }
291 
292     /**
293     * @dev Internal function to add a land ID to the list of a given address
294     * @param _to address representing the new owner of the given land ID
295     * @param _landId uint256 ID of the land to be added to the lands list of the given address
296     */
297     function addLand(address _to, uint256 _landId) private {
298         require(landOwner[_landId] == address(0));
299         landOwner[_landId] = _to;
300 
301         uint256 length = ownedLands[_to].length;
302         ownedLands[_to].push(_landId);
303         ownedLandsIndex[_landId] = length;
304         totalLands = totalLands.add(1);
305     }
306 
307     /**
308     * @dev Internal function to remove a land ID from the list of a given address
309     * @param _from address representing the previous owner of the given land ID
310     * @param _landId uint256 ID of the land to be removed from the lands list of the given address
311     */
312     function removeLand(address _from, uint256 _landId) private {
313         require(owns(_from, _landId));
314 
315         uint256 landIndex = ownedLandsIndex[_landId];
316         //        uint256 lastLandIndex = balanceOf(_from).sub(1);
317         uint256 lastLandIndex = ownedLands[_from].length.sub(1);
318         uint256 lastLand = ownedLands[_from][lastLandIndex];
319 
320         landOwner[_landId] = address(0);
321         ownedLands[_from][landIndex] = lastLand;
322         ownedLands[_from][lastLandIndex] = 0;
323         // Note that this will handle single-element arrays. In that case, both landIndex and lastLandIndex are going to
324         // be zero. Then we can make sure that we will remove _landId from the ownedLands list since we are first swapping
325         // the lastLand to the first position, and then dropping the element placed in the last position of the list
326 
327         ownedLands[_from].length--;
328         ownedLandsIndex[_landId] = 0;
329         ownedLandsIndex[lastLand] = landIndex;
330         totalLands = totalLands.sub(1);
331     }
332 
333 
334     function createLand(address _owner, uint _id) onlyOwner public returns (uint) {
335         require(_owner != address(0));
336         uint256 _landId = lastLandId++;
337         addLand(_owner, _landId);
338         //store new land data
339         lands[_landId] = Land({
340             id : _id
341             });
342         emit Transfer(address(0), _owner, _landId);
343         emit NewLand(_owner, _landId);
344         return _landId;
345     }
346 
347     function createLandAndAuction(address _owner, uint _id, address _auction, uint _startPrice, uint _duration) onlyOwner public
348     {
349         uint id = createLand(_owner, _id);
350         require(createAuction(_auction, id, _startPrice, _duration));
351     }
352 
353 
354     function owns(address _claimant, uint256 _landId) public view returns (bool) {
355         return ownerOf(_landId) == _claimant && ownerOf(_landId) != address(0);
356     }
357 
358 
359     function transferFrom(address _from, address _to, uint256 _landId) public returns (bool) {
360         require(_to != address(this));
361         require(allowance(msg.sender, _landId));
362         clearApprovalAndTransfer(_from, _to, _landId);
363         return true;
364     }
365 
366 }
367 
368 
369 contract ArconaDigitalLand is LandBase {
370     string public constant name = " Arcona Digital Land";
371     string public constant symbol = "ARDL";
372 
373     function() public payable{
374         revert();
375     }
376 }