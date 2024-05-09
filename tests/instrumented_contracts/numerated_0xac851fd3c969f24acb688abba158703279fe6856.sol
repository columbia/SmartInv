1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
46 
47 /**
48  * @title ERC721 token receiver interface
49  * @dev Interface for any contract that wants to support safeTransfers
50  *  from ERC721 asset contracts.
51  */
52 contract ERC721Receiver {
53   /**
54    * @dev Magic value to be returned upon successful reception of an NFT
55    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
56    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
57    */
58   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
59 
60   /**
61    * @notice Handle the receipt of an NFT
62    * @dev The ERC721 smart contract calls this function on the recipient
63    *  after a `safetransfer`. This function MAY throw to revert and reject the
64    *  transfer. This function MUST use 50,000 gas or less. Return of other
65    *  than the magic value MUST result in the transaction being reverted.
66    *  Note: the contract address is always the message sender.
67    * @param _from The sending address
68    * @param _tokenId The NFT identifier which is being transfered
69    * @param _data Additional data with no specified format
70    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
71    */
72   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
73 }
74 
75 // File: contracts/TVLottery.sol
76 
77 contract ITVToken {
78     function balanceOf(address _owner) public view returns (uint256);
79     function transfer(address _to, uint256 _value) public returns (bool);
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
81     function safeTransfer(address _to, uint256 _value, bytes _data) public;
82 }
83 
84 contract IArtefact {
85     function artefacts(uint id) public returns (uint, uint);
86     function ownerOf(uint256 _tokenId) public view returns (address);
87 }
88 
89 contract ITVKey {
90     function transferFrom(address _from, address _to, uint256 _tokenId) public;
91     function keys(uint id) public returns (uint, uint);
92     function mint(address to, uint chestId) public returns (uint);
93     function burn(uint id) public;
94 }
95 
96 contract TVLottery is Ownable, ERC721Receiver {
97     address public manager;
98     address public TVTokenAddress;
99     address public TVKeyAddress;
100 
101     struct Collection {
102         uint id;
103         uint[] typeIds;
104         address[] tokens;
105         uint chestId;
106         uint lotteryId;
107         bool created;
108     }
109 
110     struct Lottery {
111         uint id;
112         address bank;
113         uint[] collections;
114         uint bankPercentage;
115         bool isActive;
116         bool created;
117     }
118 
119     struct Chest {
120         uint id;
121         uint lotteryId;
122         uint percentage;
123         uint count;
124         uint keysCount;
125         uint openedCount;
126         bool created;
127     }
128 
129     mapping(uint => Lottery) public lotteries;
130     mapping(uint => Chest) public chests;
131     mapping(uint => Collection) public collections;
132     mapping(uint => mapping(address => bool)) public usedElements;
133 
134     event KeyReceived(uint keyId, uint lotteryId, uint collectionId, uint chestId, address receiver);
135     event ChestOpened(uint keyId, uint lotteryId, uint chestId, uint reward, address receiver);
136     event ArtefactUsed(uint id, address token, address sender);
137 
138     modifier onlyOwnerOrManager() {
139         require(msg.sender == owner || manager == msg.sender);
140         _;
141     }
142 
143     constructor(
144         address _TVTokenAddress,
145         address _TVKeyAddress,
146         address _manager
147     ) public {
148         manager = _manager;
149         TVTokenAddress = _TVTokenAddress;
150         TVKeyAddress = _TVKeyAddress;
151     }
152 
153     function onERC721Received(
154         address _from,
155         uint256 _tokenId,
156         bytes
157     ) public returns (bytes4) {
158         require(msg.sender == TVKeyAddress);
159         (, uint chestId) = ITVKey(TVKeyAddress).keys(_tokenId);
160         Chest memory chest = chests[chestId];
161         Lottery memory lottery = lotteries[chest.lotteryId];
162 
163         ITVKey(TVKeyAddress).transferFrom(this, lottery.bank, _tokenId);
164         lotteries[chest.lotteryId].bankPercentage -= chest.percentage;
165         chests[chestId].openedCount = chest.openedCount + 1;
166         uint reward = getChestReward(chestId);
167         ITVToken(TVTokenAddress).transferFrom(lottery.bank, _from, reward);
168         emit ChestOpened(_tokenId, lottery.id, chest.id, reward, _from);
169         return ERC721_RECEIVED;
170     }
171 
172     function getChestReward(uint chestId) public view returns (uint) {
173         Chest memory chest = chests[chestId];
174         Lottery memory lottery = lotteries[chest.lotteryId];
175         uint bankBalance = ITVToken(TVTokenAddress).balanceOf(lottery.bank);
176         uint onePercentage = bankBalance / lottery.bankPercentage;
177         return chest.percentage * onePercentage;
178     }
179 
180     function getKey(uint lotteryId, uint collectionId, uint[] elementIds) public returns (uint) {
181         Lottery memory lottery = lotteries[lotteryId];
182         Collection memory collection = collections[collectionId];
183         Chest memory chest = chests[collection.chestId];
184 
185         require(collection.lotteryId == lotteryId);
186         require(lottery.created && lottery.isActive && collection.created);
187         require(chest.keysCount > 0);
188 
189         checkCollection(collection, elementIds);
190 
191         chests[collection.chestId].keysCount = chest.keysCount - 1;
192         uint keyId = ITVKey(TVKeyAddress).mint(msg.sender, chest.id);
193         emit KeyReceived(keyId, lotteryId, collectionId, chest.id, msg.sender);
194 
195         return keyId;
196     }
197 
198     function checkCollection(Collection collection, uint[] elementsIds) internal {
199         require(elementsIds.length == collection.typeIds.length);
200         for (uint i = 0; i < elementsIds.length; i++) {
201             (uint id, uint typeId) = IArtefact(collection.tokens[i]).artefacts(elementsIds[i]);
202             require(typeId == collection.typeIds[i]);
203             require(!usedElements[id][collection.tokens[i]]);
204             require(IArtefact(collection.tokens[i]).ownerOf(id) == msg.sender);
205             usedElements[id][collection.tokens[i]] = true;
206             emit ArtefactUsed(id, collection.tokens[i], msg.sender);
207         }
208     }
209 
210     function setCollection(
211         uint id,
212         uint[] typeIds,
213         address[] tokens,
214         uint chestId,
215         uint lotteryId,
216         bool created
217     ) public onlyOwnerOrManager {
218         require(typeIds.length == tokens.length);
219         collections[id] = Collection(id, typeIds, tokens, chestId, lotteryId, created);
220     }
221 
222     function getCollectionElementsCount(uint id) public view returns(uint) {
223         return collections[id].typeIds.length;
224     }
225 
226     function getCollectionElementByIndex(uint id, uint index) public view returns(uint, address) {
227         return (collections[id].typeIds[index], collections[id].tokens[index]);
228     }
229 
230     function setChest(
231         uint lotteryId,
232         uint id,
233         uint percentage,
234         uint count,
235         uint keysCount,
236         uint openedCount,
237         bool created
238     ) public onlyOwnerOrManager {
239         chests[id] = Chest(id, lotteryId, percentage, count, keysCount, openedCount, created);
240     }
241 
242     function setLottery(
243         uint id,
244         address bank,
245         uint[] _collections,
246         uint bankPercentage,
247         bool isActive,
248         bool created
249     ) public onlyOwnerOrManager {
250         lotteries[id] = Lottery(id, bank, _collections, bankPercentage, isActive, created);
251     }
252 
253     function getLotteryCollectionCount(uint id) public view returns(uint) {
254         return lotteries[id].collections.length;
255     }
256 
257     function getLotteryCollectionByIndex(uint id, uint index) public view returns(uint) {
258         return lotteries[id].collections[index];
259     }
260 
261     function changeLotteryBank(uint lotteryId, address bank, uint bankPercentage) public onlyOwnerOrManager {
262         lotteries[lotteryId].bank = bank;
263         lotteries[lotteryId].bankPercentage = bankPercentage;
264     }
265 
266     function updateCollections(uint lotteryId, uint[] _collections) public onlyOwnerOrManager {
267         lotteries[lotteryId].collections = _collections;
268     }
269 
270     function setLotteryActive(uint id, bool isActive) public onlyOwnerOrManager {
271         lotteries[id].isActive = isActive;
272     }
273 
274     function changeTVTokenAddress(address newAddress) public onlyOwnerOrManager {
275         TVTokenAddress = newAddress;
276     }
277 
278     function changeTVKeyAddress(address newAddress) public onlyOwnerOrManager {
279         TVKeyAddress = newAddress;
280     }
281 
282     function setManager(address _manager) public onlyOwner {
283         manager = _manager;
284     }
285 }