1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address previousOwner, address newOwner);
7 
8     function Ownable() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0));
19         emit OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21     }
22 }
23 
24 contract StorageBase is Ownable {
25 
26     function withdrawBalance() external onlyOwner returns (bool) {
27         // The owner has a method to withdraw balance from multiple contracts together,
28         // use send here to make sure even if one withdrawBalance fails the others will still work
29         bool res = msg.sender.send(address(this).balance);
30         return res;
31     }
32 }
33 
34 // owner of ActivityStorage should be ActivityCore contract address
35 contract ActivityStorage is StorageBase {
36 
37     struct Activity {
38         // accept bid or not
39         bool isPause;
40         // limit max num of monster buyable per address
41         uint16 buyLimit;
42         // price (in wei)
43         uint128 packPrice;
44         // startDate (in seconds)
45         uint64 startDate;
46         // endDate (in seconds)
47         uint64 endDate;
48         // packId => address of bid winner
49         mapping(uint16 => address) soldPackToAddress;
50         // address => number of success bid
51         mapping(address => uint16) addressBoughtCount;
52     }
53 
54     // limit max activityId to 65536, big enough
55     mapping(uint16 => Activity) public activities;
56 
57     function createActivity(
58         uint16 _activityId,
59         uint16 _buyLimit,
60         uint128 _packPrice,
61         uint64 _startDate,
62         uint64 _endDate
63     ) 
64         external
65         onlyOwner
66     {
67         // activity should not exist and can only be initialized once
68         require(activities[_activityId].buyLimit == 0);
69 
70         activities[_activityId] = Activity({
71             isPause: false,
72             buyLimit: _buyLimit,
73             packPrice: _packPrice,
74             startDate: _startDate,
75             endDate: _endDate
76         });
77     }
78 
79     function sellPackToAddress(
80         uint16 _activityId, 
81         uint16 _packId, 
82         address buyer
83     ) 
84         external 
85         onlyOwner
86     {
87         Activity storage activity = activities[_activityId];
88         activity.soldPackToAddress[_packId] = buyer;
89         activity.addressBoughtCount[buyer]++;
90     }
91 
92     function pauseActivity(uint16 _activityId) external onlyOwner {
93         activities[_activityId].isPause = true;
94     }
95 
96     function unpauseActivity(uint16 _activityId) external onlyOwner {
97         activities[_activityId].isPause = false;
98     }
99 
100     function deleteActivity(uint16 _activityId) external onlyOwner {
101         delete activities[_activityId];
102     }
103 
104     function getAddressBoughtCount(uint16 _activityId, address buyer) external view returns (uint16) {
105         return activities[_activityId].addressBoughtCount[buyer];
106     }
107 
108     function getBuyerAddress(uint16 _activityId, uint16 packId) external view returns (address) {
109         return activities[_activityId].soldPackToAddress[packId];
110     }
111 }
112 
113 contract Pausable is Ownable {
114     event Pause();
115     event Unpause();
116 
117     bool public paused = false;
118 
119     modifier whenNotPaused() {
120         require(!paused);
121         _;
122     }
123 
124     modifier whenPaused {
125         require(paused);
126         _;
127     }
128 
129     function pause() public onlyOwner whenNotPaused {
130         paused = true;
131         emit Pause();
132     }
133 
134     function unpause() public onlyOwner whenPaused {
135         paused = false;
136         emit Unpause();
137     }
138 }
139 
140 contract HasNoContracts is Pausable {
141 
142     function reclaimContract(address _contractAddr) external onlyOwner whenPaused {
143         Ownable contractInst = Ownable(_contractAddr);
144         contractInst.transferOwnership(owner);
145     }
146 }
147 
148 contract ERC721 {
149     // Required methods
150     function totalSupply() public view returns (uint256 total);
151     function balanceOf(address _owner) public view returns (uint256 balance);
152     function ownerOf(uint256 _tokenId) external view returns (address owner);
153     function approve(address _to, uint256 _tokenId) external;
154     function transfer(address _to, uint256 _tokenId) external;
155     function transferFrom(address _from, address _to, uint256 _tokenId) external;
156 
157     // Events
158     event Transfer(address from, address to, uint256 tokenId);
159     event Approval(address owner, address approved, uint256 tokenId);
160 
161     // Optional
162     // function name() public view returns (string name);
163     // function symbol() public view returns (string symbol);
164     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
165     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
166 
167     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
168     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
169 }
170 
171 contract LogicBase is HasNoContracts {
172 
173     /// The ERC-165 interface signature for ERC-721.
174     ///  Ref: https://github.com/ethereum/EIPs/issues/165
175     ///  Ref: https://github.com/ethereum/EIPs/issues/721
176     bytes4 constant InterfaceSignature_NFC = bytes4(0x9f40b779);
177 
178     // Reference to contract tracking NFT ownership
179     ERC721 public nonFungibleContract;
180 
181     // Reference to storage contract
182     StorageBase public storageContract;
183 
184     function LogicBase(address _nftAddress, address _storageAddress) public {
185         // paused by default
186         paused = true;
187 
188         setNFTAddress(_nftAddress);
189 
190         require(_storageAddress != address(0));
191         storageContract = StorageBase(_storageAddress);
192     }
193 
194     // Very dangerous action, only when new contract has been proved working
195     // Requires storageContract already transferOwnership to the new contract
196     // This method is only used to transfer the balance to owner
197     function destroy() external onlyOwner whenPaused {
198         address storageOwner = storageContract.owner();
199         // owner of storageContract must not be the current contract otherwise the storageContract will forever not accessible
200         require(storageOwner != address(this));
201         // Transfers the current balance to the owner and terminates the contract
202         selfdestruct(owner);
203     }
204 
205     // Very dangerous action, only when new contract has been proved working
206     // Requires storageContract already transferOwnership to the new contract
207     // This method is only used to transfer the balance to the new contract
208     function destroyAndSendToStorageOwner() external onlyOwner whenPaused {
209         address storageOwner = storageContract.owner();
210         // owner of storageContract must not be the current contract otherwise the storageContract will forever not accessible
211         require(storageOwner != address(this));
212         // Transfers the current balance to the new owner of the storage contract and terminates the contract
213         selfdestruct(storageOwner);
214     }
215 
216     // override to make sure everything is initialized before the unpause
217     function unpause() public onlyOwner whenPaused {
218         // can not unpause when the logic contract is not initialzed
219         require(nonFungibleContract != address(0));
220         require(storageContract != address(0));
221         // can not unpause when ownership of storage contract is not the current contract
222         require(storageContract.owner() == address(this));
223 
224         super.unpause();
225     }
226 
227     function setNFTAddress(address _nftAddress) public onlyOwner {
228         require(_nftAddress != address(0));
229         ERC721 candidateContract = ERC721(_nftAddress);
230         require(candidateContract.supportsInterface(InterfaceSignature_NFC));
231         nonFungibleContract = candidateContract;
232     }
233 
234     // Withdraw balance to the Core Contract
235     function withdrawBalance() external returns (bool) {
236         address nftAddress = address(nonFungibleContract);
237         // either Owner or Core Contract can trigger the withdraw
238         require(msg.sender == owner || msg.sender == nftAddress);
239         // The owner has a method to withdraw balance from multiple contracts together,
240         // use send here to make sure even if one withdrawBalance fails the others will still work
241         bool res = nftAddress.send(address(this).balance);
242         return res;
243     }
244 
245     function withdrawBalanceFromStorageContract() external returns (bool) {
246         address nftAddress = address(nonFungibleContract);
247         // either Owner or Core Contract can trigger the withdraw
248         require(msg.sender == owner || msg.sender == nftAddress);
249         // The owner has a method to withdraw balance from multiple contracts together,
250         // use send here to make sure even if one withdrawBalance fails the others will still work
251         bool res = storageContract.withdrawBalance();
252         return res;
253     }
254 }
255 
256 contract ActivityCore is LogicBase {
257 
258     bool public isActivityCore = true;
259 
260     ActivityStorage activityStorage;
261 
262     event ActivityCreated(uint16 activityId);
263     event ActivityBidSuccess(uint16 activityId, uint16 packId, address winner);
264 
265     function ActivityCore(address _nftAddress, address _storageAddress) 
266         LogicBase(_nftAddress, _storageAddress) public {
267             
268         activityStorage = ActivityStorage(_storageAddress);
269     }
270 
271     function createActivity(
272         uint16 _activityId,
273         uint16 _buyLimit,
274         uint128 _packPrice,
275         uint64 _startDate,
276         uint64 _endDate
277     ) 
278         external
279         onlyOwner
280         whenNotPaused
281     {
282         activityStorage.createActivity(_activityId, _buyLimit, _packPrice, _startDate, _endDate);
283 
284         emit ActivityCreated(_activityId);
285     }
286 
287     // Very dangerous action and should be only used for testing
288     // Must pause the contract first 
289     function deleteActivity(
290         uint16 _activityId
291     )
292         external 
293         onlyOwner
294         whenPaused
295     {
296         activityStorage.deleteActivity(_activityId);
297     }
298 
299     function getActivity(
300         uint16 _activityId
301     ) 
302         external 
303         view  
304         returns (
305             bool isPause,
306             uint16 buyLimit,
307             uint128 packPrice,
308             uint64 startDate,
309             uint64 endDate
310         )
311     {
312         return activityStorage.activities(_activityId);
313     }
314     
315     function bid(uint16 _activityId, uint16 _packId)
316         external
317         payable
318         whenNotPaused
319     {
320         bool isPause;
321         uint16 buyLimit;
322         uint128 packPrice;
323         uint64 startDate;
324         uint64 endDate;
325         (isPause, buyLimit, packPrice, startDate, endDate) = activityStorage.activities(_activityId);
326         // not allow to bid when activity is paused
327         require(!isPause);
328         // not allow to bid when activity is not initialized (buyLimit == 0)
329         require(buyLimit > 0);
330         // should send enough ether
331         require(msg.value >= packPrice);
332         // verify startDate & endDate
333         require(now >= startDate && now <= endDate);
334         // this pack is not sold out
335         require(activityStorage.getBuyerAddress(_activityId, _packId) == address(0));
336         // buyer not exceed buyLimit
337         require(activityStorage.getAddressBoughtCount(_activityId, msg.sender) < buyLimit);
338         // record in blockchain
339         activityStorage.sellPackToAddress(_activityId, _packId, msg.sender);
340         // emit the success event
341         emit ActivityBidSuccess(_activityId, _packId, msg.sender);
342     }
343 }