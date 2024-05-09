1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 
68 
69 
70 
71 contract UserManager {
72 
73     struct User {
74         string username;
75         bytes32 hashToProfilePicture;
76         bool exists;
77     }
78 
79     uint public numberOfUsers;
80 
81     mapping(string => bool) internal usernameExists;
82     mapping(address => User) public addressToUser;
83 
84     mapping(bytes32 => bool) public profilePictureExists;
85     mapping(string => address) internal usernameToAddress;
86 
87     event NewUser(address indexed user, string username, bytes32 profilePicture);
88 
89     function register(string _username, bytes32 _hashToProfilePicture) public {
90         require(usernameExists[_username] == false || 
91                 keccak256(abi.encodePacked(getUsername(msg.sender))) == keccak256(abi.encodePacked(_username))
92         );
93 
94         if (usernameExists[getUsername(msg.sender)]) {
95             // if he already had username, that username is free now
96             usernameExists[getUsername(msg.sender)] = false;
97         } else {
98             numberOfUsers++;
99             emit NewUser(msg.sender, _username, _hashToProfilePicture);
100         }
101 
102         addressToUser[msg.sender] = User({
103             username: _username,
104             hashToProfilePicture: _hashToProfilePicture,
105             exists: true
106         });
107 
108         usernameExists[_username] = true;
109         profilePictureExists[_hashToProfilePicture] = true;
110         usernameToAddress[_username] = msg.sender;
111     }
112 
113     function changeProfilePicture(bytes32 _hashToProfilePicture) public {
114         require(addressToUser[msg.sender].exists, "User doesn't exists");
115 
116         addressToUser[msg.sender].hashToProfilePicture = _hashToProfilePicture;
117     }
118 
119     function getUserInfo(address _address) public view returns(string, bytes32) {
120         User memory user = addressToUser[_address];
121         return (user.username, user.hashToProfilePicture);
122     }
123 
124     function getUsername(address _address) public view returns(string) {
125         return addressToUser[_address].username;
126     } 
127 
128     function getProfilePicture(address _address) public view returns(bytes32) {
129         return addressToUser[_address].hashToProfilePicture;
130     }
131 
132     function isUsernameExists(string _username) public view returns(bool) {
133         return usernameExists[_username];
134     }
135 
136 }
137 
138 
139 
140 contract AssetManager is Ownable {
141 
142     struct Asset {
143         uint id;
144         uint packId;
145         /// atributes field is going to be 3 digit uint where every digit can be "1" or "2"
146         /// 1st digit will tell us if asset is background 1 - true / 2 - false
147         /// 2nd digit will tell us if rotation is enabled 1 - true / 2 - false
148         /// 3rd digit will tell us if scaling  is enabled 1 - true / 2 - false
149         uint attributes;
150         bytes32 ipfsHash; // image
151     }
152 
153     struct AssetPack {
154         bytes32 packCover;
155         uint[] assetIds;
156         address creator;
157         uint price;
158         string ipfsHash; // containing title and description
159     }
160 
161     uint public numberOfAssets;
162     uint public numberOfAssetPacks;
163 
164     Asset[] public assets;
165     AssetPack[] public assetPacks;
166 
167     UserManager public userManager;
168 
169     mapping(address => uint) public artistBalance;
170     mapping(bytes32 => bool) public hashExists;
171 
172     mapping(address => uint[]) public createdAssetPacks;
173     mapping(address => uint[]) public boughtAssetPacks;
174     mapping(address => mapping(uint => bool)) public hasPermission;
175     mapping(uint => address) public approvedTakeover;
176 
177     event AssetPackCreated(uint indexed id, address indexed owner);
178     event AssetPackBought(uint indexed id, address indexed buyer);
179 
180     function addUserManager(address _userManager) public onlyOwner {
181         require(userManager == address(0));
182 
183         userManager = UserManager(_userManager);
184     }
185 
186     /// @notice Function to create assetpack
187     /// @param _packCover is cover image for asset pack
188     /// @param _attributes is array of attributes
189     /// @param _ipfsHashes is array containing all ipfsHashes for assets we'd like to put in pack
190     /// @param _packPrice is price for total assetPack (every asset will have average price)
191     /// @param _ipfsHash ipfs hash containing title and description in json format
192     function createAssetPack(
193         bytes32 _packCover, 
194         uint[] _attributes, 
195         bytes32[] _ipfsHashes, 
196         uint _packPrice,
197         string _ipfsHash) public {
198         
199         require(_ipfsHashes.length > 0);
200         require(_ipfsHashes.length < 50);
201         require(_attributes.length == _ipfsHashes.length);
202 
203         uint[] memory ids = new uint[](_ipfsHashes.length);
204 
205         for (uint i = 0; i < _ipfsHashes.length; i++) {
206             ids[i] = createAsset(_attributes[i], _ipfsHashes[i], numberOfAssetPacks);
207         }
208 
209         assetPacks.push(AssetPack({
210             packCover: _packCover,
211             assetIds: ids,
212             creator: msg.sender,
213             price: _packPrice,
214             ipfsHash: _ipfsHash
215         }));
216 
217         createdAssetPacks[msg.sender].push(numberOfAssetPacks);
218         numberOfAssetPacks++;
219 
220         emit AssetPackCreated(numberOfAssetPacks-1, msg.sender);
221     }
222 
223     /// @notice Function which creates an asset
224     /// @param _attributes is meta info for asset
225     /// @param _ipfsHash is ipfsHash to image of asset
226     function createAsset(uint _attributes, bytes32 _ipfsHash, uint _packId) internal returns(uint) {
227         uint id = numberOfAssets;
228 
229         require(isAttributesValid(_attributes), "Attributes are not valid.");
230 
231         assets.push(Asset({
232             id : id,
233             packId: _packId,
234             attributes: _attributes,
235             ipfsHash : _ipfsHash
236         }));
237 
238         numberOfAssets++;
239 
240         return id;
241     }
242 
243     /// @notice Method to buy right to use specific asset pack
244     /// @param _to is address of user who will get right on that asset pack
245     /// @param _assetPackId is id of asset pack user is buying
246     function buyAssetPack(address _to, uint _assetPackId) public payable {
247         require(!checkHasPermissionForPack(_to, _assetPackId));
248 
249         AssetPack memory assetPack = assetPacks[_assetPackId];
250         require(msg.value >= assetPack.price);
251         // if someone wants to pay more money for asset pack, we will give all of it to creator
252         artistBalance[assetPack.creator] += msg.value * 95 / 100;
253         artistBalance[owner] += msg.value * 5 / 100;
254         boughtAssetPacks[_to].push(_assetPackId);
255         hasPermission[_to][_assetPackId] = true;
256 
257         emit AssetPackBought(_assetPackId, _to);
258     }
259 
260     /// @notice Change price of asset pack
261     /// @param _assetPackId is id of asset pack for changing price
262     /// @param _newPrice is new price for that asset pack
263     function changeAssetPackPrice(uint _assetPackId, uint _newPrice) public {
264         require(assetPacks[_assetPackId].creator == msg.sender);
265 
266         assetPacks[_assetPackId].price = _newPrice;
267     }
268 
269     /// @notice Approve address to become creator of that pack
270     /// @param _assetPackId id of asset pack for other address to claim
271     /// @param _newCreator address that will be able to claim that asset pack
272     function approveTakeover(uint _assetPackId, address _newCreator) public {
273         require(assetPacks[_assetPackId].creator == msg.sender);
274 
275         approvedTakeover[_assetPackId] = _newCreator;
276     }
277 
278     /// @notice claim asset pack that is previously approved by creator
279     /// @param _assetPackId id of asset pack that is changing creator
280     function claimAssetPack(uint _assetPackId) public {
281         require(approvedTakeover[_assetPackId] == msg.sender);
282         
283         approvedTakeover[_assetPackId] = address(0);
284         assetPacks[_assetPackId].creator = msg.sender;
285     }
286 
287     ///@notice Function where all artists can withdraw their funds
288     function withdraw() public {
289         uint amount = artistBalance[msg.sender];
290         artistBalance[msg.sender] = 0;
291 
292         msg.sender.transfer(amount);
293     }
294 
295     /// @notice Function to fetch total number of assets
296     /// @return numberOfAssets
297     function getNumberOfAssets() public view returns (uint) {
298         return numberOfAssets;
299     }
300 
301     /// @notice Function to fetch total number of assetpacks
302     /// @return uint numberOfAssetPacks
303     function getNumberOfAssetPacks() public view returns(uint) {
304         return numberOfAssetPacks;
305     }
306 
307     /// @notice Function to check if user have permission (owner / bought) for pack
308     /// @param _address is address of user
309     /// @param _packId is id of pack
310     function checkHasPermissionForPack(address _address, uint _packId) public view returns (bool) {
311 
312         return (assetPacks[_packId].creator == _address) || hasPermission[_address][_packId];
313     }
314 
315     /// @notice Function to check does hash exist in mapping
316     /// @param _ipfsHash is bytes32 representation of hash
317     function checkHashExists(bytes32 _ipfsHash) public view returns (bool) {
318         return hashExists[_ipfsHash];
319     }
320 
321     /// @notice method that gets all unique packs from array of assets
322     function pickUniquePacks(uint[] assetIds) public view returns (uint[]) {
323         require(assetIds.length > 0);
324 
325         uint[] memory packs = new uint[](assetIds.length);
326         uint packsCount = 0;
327         
328         for (uint i = 0; i < assetIds.length; i++) {
329             Asset memory asset = assets[assetIds[i]];
330             bool exists = false;
331 
332             for (uint j = 0; j < packsCount; j++) {
333                 if (asset.packId == packs[j]) {
334                     exists = true;
335                 }
336             }
337 
338             if (!exists) {
339                 packs[packsCount] = asset.packId;
340                 packsCount++;
341             }
342         }
343 
344         uint[] memory finalPacks = new uint[](packsCount);
345         for (i = 0; i < packsCount; i++) {
346             finalPacks[i] = packs[i];
347         }
348 
349         return finalPacks;
350     }
351 
352     /// @notice Method to get all info for an asset
353     /// @param id is id of asset
354     /// @return All data for an asset
355     function getAssetInfo(uint id) public view returns (uint, uint, uint, bytes32) {
356         require(id >= 0);
357         require(id < numberOfAssets);
358         Asset memory asset = assets[id];
359 
360         return (asset.id, asset.packId, asset.attributes, asset.ipfsHash);
361     }
362 
363     /// @notice method returns all asset packs created by _address
364     /// @param _address is creator address
365     function getAssetPacksUserCreated(address _address) public view returns(uint[]) {
366         return createdAssetPacks[_address];
367     }
368 
369     /// @notice Function to get ipfsHash for selected asset
370     /// @param _id is id of asset we'd like to get ipfs hash
371     /// @return string representation of ipfs hash of that asset
372     function getAssetIpfs(uint _id) public view returns (bytes32) {
373         require(_id < numberOfAssets);
374         
375         return assets[_id].ipfsHash;
376     }
377 
378     /// @notice Function to get attributes for selected asset
379     /// @param _id is id of asset we'd like to get ipfs hash
380     /// @return uint representation of attributes of that asset
381     function getAssetAttributes(uint _id) public view returns (uint) {
382         require(_id < numberOfAssets);
383         
384         return assets[_id].attributes;
385     }
386 
387     /// @notice Function to get array of ipfsHashes for specific assets
388     /// @dev need for data parsing on frontend efficiently
389     /// @param _ids is array of ids
390     /// @return bytes32 array of hashes
391     function getIpfsForAssets(uint[] _ids) public view returns (bytes32[]) {
392         bytes32[] memory hashes = new bytes32[](_ids.length);
393         for (uint i = 0; i < _ids.length; i++) {
394             Asset memory asset = assets[_ids[i]];
395             hashes[i] = asset.ipfsHash;
396         }
397 
398         return hashes;
399     }
400 
401     /// @notice method that returns attributes for many assets
402     function getAttributesForAssets(uint[] _ids) public view returns(uint[]) {
403         uint[] memory attributes = new uint[](_ids.length);
404         
405         for (uint i = 0; i < _ids.length; i++) {
406             Asset memory asset = assets[_ids[i]];
407             attributes[i] = asset.attributes;
408         }
409         return attributes;
410     }
411 
412     /// @notice Function to get ipfs hash and id for all assets in one asset pack
413     /// @param _assetPackId is id of asset pack
414     /// @return two arrays with data
415     function getAssetPackData(uint _assetPackId) public view 
416     returns(bytes32, address, uint, uint[], uint[], bytes32[], string, string, bytes32) {
417         require(_assetPackId < numberOfAssetPacks);
418 
419         AssetPack memory assetPack = assetPacks[_assetPackId];
420         bytes32[] memory hashes = new bytes32[](assetPack.assetIds.length);
421 
422         for (uint i = 0; i < assetPack.assetIds.length; i++) {
423             hashes[i] = getAssetIpfs(assetPack.assetIds[i]);
424         }
425 
426         uint[] memory attributes = getAttributesForAssets(assetPack.assetIds);
427 
428         return(
429             assetPack.packCover, 
430             assetPack.creator, 
431             assetPack.price, 
432             assetPack.assetIds, 
433             attributes, 
434             hashes,
435             assetPack.ipfsHash,
436             userManager.getUsername(assetPack.creator),
437             userManager.getProfilePicture(assetPack.creator)
438         );
439     }
440 
441     function getAssetPackPrice(uint _assetPackId) public view returns (uint) {
442         require(_assetPackId < numberOfAssetPacks);
443 
444         return assetPacks[_assetPackId].price;
445     }
446 
447     function getBoughtAssetPacks(address _address) public view returns (uint[]) {
448         return boughtAssetPacks[_address];
449     }
450 
451     /// @notice Function to get cover image for every assetpack
452     /// @param _packIds is array of asset pack ids
453     /// @return bytes32[] array of hashes
454     function getCoversForPacks(uint[] _packIds) public view returns (bytes32[]) {
455         require(_packIds.length > 0);
456         bytes32[] memory covers = new bytes32[](_packIds.length);
457         for (uint i = 0; i < _packIds.length; i++) {
458             AssetPack memory assetPack = assetPacks[_packIds[i]];
459             covers[i] = assetPack.packCover;
460         }
461         return covers;
462     }
463 
464     function isAttributesValid(uint attributes) private pure returns(bool) {
465         if (attributes < 100 || attributes > 999) {
466             return false;
467         }
468 
469         uint num = attributes;
470 
471         while (num > 0) {
472             if (num % 10 != 1 && num % 10 != 2) {
473                 return false;
474             } 
475             num = num / 10;
476         }
477 
478         return true;
479     }
480 }