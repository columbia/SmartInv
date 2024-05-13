1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "../../interfaces/IOutputReceiverV2.sol";
7 import "../../interfaces/ITokenVault.sol";
8 import "../../interfaces/IRevest.sol";
9 import "../../interfaces/IFeeReporter.sol";
10 import "../../interfaces/IFNFTHandler.sol";
11 import "../../interfaces/ILockManager.sol";
12 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
13 import '@openzeppelin/contracts/utils/introspection/ERC165.sol';
14 import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
15 import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
16 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
17 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
18 
19 /**
20  * @title
21  * @dev could add ability to airdrop ERC1155s to this, make things even more interesting
22  */
23 
24 contract NFTLocker is IOutputReceiverV2, Ownable, ERC165, ERC721Holder, ReentrancyGuard, IFeeReporter {
25     using SafeERC20 for IERC20;
26 
27     address public addressRegistry;
28     string public  metadata;
29     uint public constant PRECISION = 10**27;
30 
31     // Will concatenate with ID
32     string private constant REWARDS_ENDPOINT = "https://lambda.revest.finance/api/getRewardsForNFTLocker/"; 
33     string private constant ARGUMENTS_FACTORY = "https://lambda.revest.finance/api/getParamsForNFTLocker/"; 
34 
35     struct ERC721Data {
36         uint[] tokenIds;
37         uint index;
38         address erc721;
39     }
40 
41     struct Balance {
42         uint curMul;
43         uint lastMul;
44     }
45 
46     event AirdropEvent(address indexed token, address indexed erc721, uint indexed update_index, uint amount);
47     event LockedNFTEvent(address indexed erc721, uint indexed tokenId, uint indexed fnftId, uint update_index);
48     event ClaimedReward(address indexed token, address indexed erc721, uint indexed fnftId, uint update_index, uint amount);
49 
50     uint public updateIndex = 1;
51 
52     // Map fnftId to ERC721Data object for that token
53     mapping (uint => ERC721Data) public nfts;
54 
55     // Map ERC20 token address to latest update index for that token
56     mapping (address => bytes32) public globalBalances;
57 
58     // Map ERC20 token updates from updateIndex to balances
59     mapping (bytes32 => Balance) public updateEvents;
60 
61     // Map fnftId to mapping of ERC20 tokens to multipliers
62     mapping (uint => mapping (address => uint)) public localMuls;
63 
64     // Map address of ERC721 to minimum length of locking period
65     // If one has been set by the ERC721 owner
66     mapping (address => uint) public minTimes;
67 
68     // Whitelist of NFTs which can be locked for free
69     // Admission awarded by Revest DAO
70     mapping (address => bool) public whitelisted;
71 
72     uint public MIN_PERIOD = 30 days; //Minimum lock-up of 30 days
73 
74     constructor(address _provider, string memory _meta) {
75         addressRegistry = _provider;
76         metadata = _meta;
77     }
78 
79     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
80         return interfaceId == type(IOutputReceiver).interfaceId
81             || interfaceId == type(IOutputReceiverV2).interfaceId
82             || super.supportsInterface(interfaceId);
83     }
84 
85     /// Allows for a user to deposit ERC721s
86     /// @param endTime UTC for when the enclosing FNFT will unlock
87     /// @param tokenIds a list of ERC721 Ids to lock
88     /// @param erc721 the address of the ERC721 contract
89     /// @param hardLock whether to allow transfer of the enclosing ERC1155 FNFT
90     /// @dev you should not stake and fractionalize at the same time, as this results in a race condition
91     function mintTimeLock(
92         uint endTime,
93         uint[] memory tokenIds,
94         address erc721,
95         bool hardLock
96     ) external payable returns (uint fnftId) {
97         require(( minTimes[erc721] == 0 && endTime - block.timestamp >= MIN_PERIOD) || 
98                 ( minTimes[erc721] > 0 && endTime - block.timestamp >= minTimes[erc721]), 
99                 'Must lock for longer than minimum');
100         IRevest.FNFTConfig memory fnftConfig;
101         fnftConfig.pipeToContract = address(this);
102         fnftConfig.nontransferrable = hardLock;
103 
104 
105         // Mint FNFT
106         uint[] memory quantities = new uint[](1);
107         // FNFT quantity will always be singular
108         quantities[0] = 1;
109         address[] memory recipients = new address[](1);
110         recipients[0] = msg.sender;
111 
112         fnftId = getRevest().mintTimeLock{value:msg.value}(endTime, recipients, quantities, fnftConfig);
113 
114         // Transfer NFT to this contract
115         // Implicitly checks if holder owns NFT
116         for(uint i = 0; i < tokenIds.length; i++) {
117             IERC721(erc721).safeTransferFrom(msg.sender, address(this), tokenIds[i], '');
118             emit LockedNFTEvent(erc721, tokenIds[i], fnftId, updateIndex);
119         }
120 
121         // Store data
122         nfts[fnftId] = ERC721Data(tokenIds, updateIndex, erc721);
123     }
124 
125     /// Function to allow for the withdrawal of the underlying NFT
126     function receiveRevestOutput(
127         uint fnftId,
128         address,
129         address payable owner,
130         uint
131     ) external override  {
132         require(_msgSender() == IAddressRegistry(addressRegistry).getTokenVault(), 'E016');
133         ERC721Data memory nft = nfts[fnftId];
134 
135         // Transfer ownership of the underlying NFT to the caller
136         for(uint i = 0; i < nft.tokenIds.length; i++) {
137             IERC721(nft.erc721).safeTransferFrom(address(this), owner, nft.tokenIds[i]);
138         }
139         // Unfortunately, we do not have a way to detect what tokens need to be auto withdrawn from
140         // So you will need to claim all rewards from your NFT prior to withdrawing it
141         delete nfts[fnftId]; // Remove the mapping entirely, refund some gas
142     }
143 
144     // Not applicable, as these cannot be split
145     function handleFNFTRemaps(uint, uint[] memory, address, bool) external pure override {
146         require(false,'Unauthorized Method');
147     }
148 
149     // We have no use for this functionality here, and honestly, I'm not sure if it is worthy of being a final candidate
150     // Causes all sorts of funkiness with gas, and we can implement much of it with other features
151     function receiveSecondaryCallback(
152         uint fnftId,
153         address payable owner,
154         uint quantity,
155         IRevest.FNFTConfig memory config,
156         bytes memory args
157     ) external payable override {}
158 
159     // This is crucial
160     function triggerOutputReceiverUpdate(
161         uint fnftId,
162         bytes memory args
163     ) external override {
164         (uint[] memory timeIndices, address[] memory tokens) = abi.decode(args, (uint[], address[]));
165         claimRewardsBatch(fnftId, timeIndices, tokens);
166     }
167 
168     function airdropTokens(uint amount, address token, address erc721) external {
169         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
170         uint totalAllocPoints = IERC721(erc721).balanceOf(address(this));
171         require(totalAllocPoints > 0, 'E076');
172         uint newMulComponent = amount * PRECISION / totalAllocPoints;
173         uint current = updateEvents[globalBalances[token]].curMul;
174         if(current == 0) {
175             // New token, need to initialize to precision
176             current = PRECISION;
177         }
178         Balance memory bal = Balance(current + newMulComponent, current);
179         bytes32 key = getBalanceKey(updateIndex, token);
180         updateEvents[key] = bal;
181         globalBalances[token] = key;
182         emit AirdropEvent(token, erc721, updateIndex, amount);
183         updateIndex++;
184     }
185 
186     /// Allows a user to claim their rewards
187     /// @param fnftId the FNFT ID to claim the rewards for
188     /// @param timeIndex the time index to look at. Must be discovered off-chain as closest to staking event
189     function claimRewards(
190         uint fnftId,
191         uint timeIndex,
192         address token
193     ) external nonReentrant {
194         IAddressRegistry reg = IAddressRegistry(addressRegistry);
195         require(IFNFTHandler(reg.getRevestFNFT()).getBalance(_msgSender(), fnftId) > 0, 'E064');
196         _claimRewards(fnftId, timeIndex, token);
197     }
198 
199     function claimRewardsBatch(
200         uint fnftId,
201         uint[] memory timeIndices,
202         address[] memory tokens
203     ) public nonReentrant {
204         require(timeIndices.length == tokens.length, 'E067');
205         IAddressRegistry reg = IAddressRegistry(addressRegistry);
206         require(IFNFTHandler(reg.getRevestFNFT()).getBalance(_msgSender(), fnftId) > 0, 'E064');
207         for(uint i = 0; i < timeIndices.length; i++) {
208             _claimRewards(fnftId, timeIndices[i], tokens[i]);
209         }
210     }
211 
212     // Time index will correspond to a DepositEvent created after the NFT was staked
213     function _claimRewards(
214         uint fnftId,
215         uint timeIndex,
216         address token
217     ) internal {
218         uint localMul = localMuls[fnftId][token];
219         require(nfts[fnftId].index <= timeIndex || localMul > 0, 'E075');
220         Balance memory bal =updateEvents[globalBalances[token]];
221         
222 
223         if(localMul == 0) {
224             // Need to derive mul for token when NFT staked - use timeIndex
225             localMul = updateEvents[getBalanceKey(timeIndex, token)].lastMul;
226             require(localMul != 0, 'E081');
227         }
228         uint rewards = (bal.curMul - localMul) * nfts[fnftId].tokenIds.length / PRECISION;
229         localMuls[fnftId][token] = bal.curMul;
230         try IERC20(token).transfer(_msgSender(), rewards) returns (bool success) {
231             //If this fails because the token is broken, we don't want to break everything
232         } catch {}
233         // If anything failed, we still want it wiped from pending rewards, as it has contract-level issues
234         emit ClaimedReward(token, nfts[fnftId].erc721, fnftId, updateIndex, rewards);
235     }
236 
237     function getRewards(
238         uint fnftId,
239         uint timeIndex,
240         address token
241     ) external view returns (uint rewards) {
242         uint localMul = localMuls[fnftId][token];
243         require(nfts[fnftId].index <= timeIndex || localMul > 0, 'E075');
244         Balance memory bal =updateEvents[globalBalances[token]];
245 
246         if(localMul == 0) {
247             // Need to derive mul for token when NFT staked - use timeIndex
248             localMul = updateEvents[getBalanceKey(timeIndex, token)].lastMul;
249             require(localMul != 0, 'E081');
250         }
251         rewards = (bal.curMul - localMul) * nfts[fnftId].tokenIds.length / PRECISION;
252     }
253     
254     function setMinPeriod(address erc721, uint min) external {
255         require(msg.sender == owner() || msg.sender == Ownable(erc721).owner(), 'Must have admin access to change min period');
256         minTimes[erc721] = min;
257     }
258     
259     function setGlobalMin(uint minPer) external onlyOwner {
260         MIN_PERIOD = minPer;
261     }
262 
263     function getCustomMetadata(uint) external view override returns (string memory) {
264         return metadata;
265     }
266 
267     function getValue(uint fnftId) external view override returns (uint) {
268         return nfts[fnftId].tokenIds.length;
269     }
270 
271     function getAsset(uint fnftId) external view override returns (address) {
272         return nfts[fnftId].erc721;
273     }
274 
275     function getOutputDisplayValues(uint fnftId) external view override returns (bytes memory) {
276         ERC721Data memory nft = nfts[fnftId];
277         // Display only the first image – and even then, we'll need to properly parse it
278         string memory tokenURI = IERC721Metadata(nft.erc721).tokenURI(nft.tokenIds[0]);
279         string memory endpoint = string(abi.encodePacked(REWARDS_ENDPOINT,uint2str(fnftId), '-',uint2str(block.chainid)));
280         string memory argumentsGen = string(abi.encodePacked(ARGUMENTS_FACTORY,uint2str(fnftId),'-',uint2str(block.chainid)));
281 
282         return abi.encode(tokenURI, endpoint, argumentsGen, nft.tokenIds, nft.erc721, nft.index);
283     }
284 
285     function setAddressRegistry(address addressRegistry_) external override onlyOwner {
286         addressRegistry = addressRegistry_;
287     }
288 
289     function getAddressRegistry() external view override returns (address) {
290         return addressRegistry;
291     }
292 
293     function getRevest() internal view returns (IRevest) {
294         return IRevest(IAddressRegistry(addressRegistry).getRevest());
295     }
296 
297     /**
298      * @dev See {IERC721Receiver-onERC721Received}.
299      *
300      * Always returns `IERC721Receiver.onERC721Received.selector`.
301      */
302     function onERC721Received(
303         address,
304         address,
305         uint256,
306         bytes memory
307     ) public virtual override returns (bytes4) {
308         return this.onERC721Received.selector;
309     }
310 
311     function getBalanceKey(uint num, address add) public pure returns (bytes32 hash_) {
312         hash_ = keccak256(abi.encode(num, add));
313     }
314 
315     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
316         if (_i == 0) {
317             return "0";
318         }
319         uint j = _i;
320         uint len;
321         while (j != 0) {
322             len++;
323             j /= 10;
324         }
325         bytes memory bstr = new bytes(len);
326         uint k = len;
327         while (_i != 0) {
328             k = k-1;
329             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
330             bytes1 b1 = bytes1(temp);
331             bstr[k] = b1;
332             _i /= 10;
333         }
334         return string(bstr);
335     }   
336 
337     function setWhitelisted(address asset, bool whitelist) external onlyOwner {
338         whitelisted[asset] = whitelist;
339     }
340 
341     function emitManualEvent(address token, address erc721, uint fnftId, uint rewards) external onlyOwner {
342         emit ClaimedReward(token, erc721, fnftId, updateIndex, rewards);
343     }
344 
345     // For fees, we simply charge the default fee for using Revest
346 
347     function getFlatWeiFee(address asset) external view override returns (uint fee) {
348         if(!whitelisted[asset]) {
349             fee = getRevest().getFlatWeiFee();
350         }
351     }
352 
353     function getERC20Fee(address asset) external view override returns (uint fee) {
354         if(!whitelisted[asset]) {
355             fee = getRevest().getERC20Fee();
356         }
357     }
358 }
