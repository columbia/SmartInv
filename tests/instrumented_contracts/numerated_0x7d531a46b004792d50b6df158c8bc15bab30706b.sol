1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
108 
109 
110 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @title ERC721 token receiver interface
116  * @dev Interface for any contract that wants to support safeTransfers
117  * from ERC721 asset contracts.
118  */
119 interface IERC721Receiver {
120     /**
121      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
122      * by `operator` from `from`, this function is called.
123      *
124      * It must return its Solidity selector to confirm the token transfer.
125      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
126      *
127      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
128      */
129     function onERC721Received(
130         address operator,
131         address from,
132         uint256 tokenId,
133         bytes calldata data
134     ) external returns (bytes4);
135 }
136 
137 // File: contracts/SoulStakerNew.sol
138 
139 
140 
141 pragma solidity ^0.8.4;
142 
143 
144 
145 interface ISoulSplicers {
146     function safeTransferFrom(address,address,uint256,bytes memory) external;
147     function balanceOf(address) external view returns (uint256);
148 }
149 
150 error IncorrectOwner();
151 error IncorrectStakePeriod();
152 error StakingNotComplete();
153 error NotStaked();
154 error NotBeenStaked();
155 error WrongSpender();
156 error StakingUnavailable();
157 error NotEnoughRewards();
158 
159 pragma solidity ^0.8.7;
160 
161 contract SoulStaker is IERC721Receiver, Ownable{
162     ISoulSplicers public splicerContract;
163     SoulStaker public oldStakerContract;
164 
165     struct StakedNFTData {
166         address owner;     
167         uint32 releaseTimestamp;
168         uint8 t1Rewards;
169         uint8 t2Rewards;
170         uint8 t3Rewards;        
171     }
172 
173     bool t2StakingClosed = false;
174     bool t3StakingClosed = false;
175     bool earlyReleaseActive = false;
176     address spendingContract = address(0);
177     mapping(uint256 => StakedNFTData) public stakedNFTs;
178     mapping(address => uint256) public ownerTokenCount;
179 
180     constructor() {
181         splicerContract = ISoulSplicers(0xfD4BfE64fea2ce11898c4b931AFAF728778a90b4);
182         oldStakerContract = SoulStaker(0xf80faba16B4757598c6FaD1Fe4134039649cB099);
183     }
184 
185     function onERC721Received(
186         address,
187         address,
188         uint256,
189         bytes calldata
190     ) override pure external returns (bytes4) {
191         return this.onERC721Received.selector;
192     }
193 
194     function stake(uint256[] calldata _tokenIds, uint8[] calldata _months) public {
195         uint256 tokenCount = ownerTokenCount[msg.sender];
196         bool isT2StakingClosed = t2StakingClosed;
197         bool isT3StakingClosed = t3StakingClosed;
198         if (earlyReleaseActive) revert StakingUnavailable();
199 
200         for (uint256 i = 0; i < _tokenIds.length; i++){
201             uint8 months = _months[i];
202             uint256 tokenID = _tokenIds[i];
203 
204             if (months != 1 && months != 3 && months != 5) revert IncorrectStakePeriod();
205             StakedNFTData memory nftData; 
206             if (stakedNFTs[tokenID].t1Rewards > 0) nftData = stakedNFTs[tokenID];
207             if (months == 3 && (isT2StakingClosed || nftData.t2Rewards > 0)) revert IncorrectStakePeriod();
208             if (months == 5 && (isT3StakingClosed || nftData.t3Rewards > 0)) revert IncorrectStakePeriod();
209             
210             splicerContract.safeTransferFrom(msg.sender, address(this), tokenID, "0x00");
211             addRewards(nftData, months, tokenID);
212             stakedNFTs[tokenID].releaseTimestamp = uint32(block.timestamp) + (months * 2592000);
213             stakedNFTs[tokenID].owner = msg.sender;
214             tokenCount += 1;
215         }
216         ownerTokenCount[msg.sender] = tokenCount;
217     }
218 
219     function restake(uint256[] calldata _tokenIds, uint8[] calldata _months) public {
220         bool isT2StakingClosed = t2StakingClosed;
221         if (earlyReleaseActive) revert StakingUnavailable();
222 
223         for (uint256 i = 0; i < _tokenIds.length; i++){
224             uint8 months = _months[i];
225             uint256 tokenID = _tokenIds[i];
226             StakedNFTData memory nftData = stakedNFTs[tokenID];
227 
228             if (nftData.owner != msg.sender) revert IncorrectOwner();
229             if (block.timestamp < nftData.releaseTimestamp) revert StakingNotComplete();
230             if (months != 1 && months != 3) revert IncorrectStakePeriod();
231             if (months == 3 && (isT2StakingClosed || nftData.t2Rewards > 0)) revert IncorrectStakePeriod();
232             
233             addRewards(nftData, months, tokenID);
234             stakedNFTs[tokenID].releaseTimestamp = uint32(block.timestamp) + (months * 2592000);
235         }
236     }
237 
238     function stakeFromOldContract(uint256[] calldata _tokenIds) public {
239         if (block.timestamp > 1661983740) revert StakingUnavailable();
240         uint256 tokenCount = ownerTokenCount[msg.sender];
241 
242         for (uint256 i = 0; i < _tokenIds.length; i++){
243             uint256 tokenID = _tokenIds[i];
244             (, uint32 releaseTimestamp, , , ) = oldStakerContract.stakedNFTs(tokenID);
245             uint8 months = 0;
246 
247             if (releaseTimestamp > 1669846140) months = 5;
248             else if (releaseTimestamp > 1664662140) months = 3;
249             else if (releaseTimestamp > 1659478140) months = 1;
250             else revert NotBeenStaked();
251 
252             StakedNFTData memory nftData;
253             splicerContract.safeTransferFrom(msg.sender, address(this), tokenID, "0x00");
254 
255             addRewards(nftData, months, tokenID);
256             stakedNFTs[tokenID].releaseTimestamp = releaseTimestamp;
257             stakedNFTs[tokenID].owner = msg.sender;
258             tokenCount += 1;
259         }
260         ownerTokenCount[msg.sender] = tokenCount;
261     }     
262 
263     function unstake(uint256[] calldata _tokenIds) public {
264         bool isEarlyRealeaseActive = earlyReleaseActive;
265         uint256 ownerCount = ownerTokenCount[msg.sender];
266         for (uint256 i = 0; i < _tokenIds.length; i++){
267             uint256 tokenID = _tokenIds[i];
268             StakedNFTData memory nftData = stakedNFTs[tokenID];
269             if (stakedNFTs[tokenID].owner != msg.sender) revert IncorrectOwner();
270             if (!isEarlyRealeaseActive && block.timestamp < nftData.releaseTimestamp) revert StakingNotComplete();
271             splicerContract.safeTransferFrom(address(this), msg.sender, tokenID, "0x00");
272             delete stakedNFTs[tokenID].owner;
273             ownerCount -= 1;
274         }
275         ownerTokenCount[msg.sender] = ownerCount;
276     }    
277 
278     function spendRewards(uint256 _tokenID, uint8 _t1, uint8 _t2, uint8 _t3) public {
279         if (msg.sender != spendingContract) revert WrongSpender();
280         StakedNFTData memory nftRewards = stakedNFTs[_tokenID];
281         if (_t1 > nftRewards.t1Rewards || _t2 > nftRewards.t2Rewards || _t3 > nftRewards.t3Rewards) revert NotEnoughRewards();
282 
283         nftRewards.t1Rewards -= _t1;
284         nftRewards.t2Rewards -= _t2;        
285         nftRewards.t3Rewards -= _t3;
286         stakedNFTs[_tokenID] = nftRewards;
287     }    
288 
289     function setEarlyRelease(bool _earlyRelease) public onlyOwner {
290         earlyReleaseActive = _earlyRelease;
291     }
292 
293     function setT2End(bool _ended) public onlyOwner {
294         t2StakingClosed = _ended;
295     }
296 
297     function SetT3End(bool _ended) public onlyOwner {
298         t3StakingClosed = _ended;
299     }
300 
301     function setSpendingContract(address _contractAddress) public onlyOwner {
302         spendingContract = _contractAddress;
303     }
304 
305     function balanceOf(address owner) public view returns (uint256) {
306         return ownerTokenCount[owner] + splicerContract.balanceOf(owner) + oldStakerContract.ownerTokenCount(owner);
307     }
308 
309     function getTimeRemaining(uint256 _tokenID) public view returns (uint256) {
310         StakedNFTData memory nftData = stakedNFTs[_tokenID];
311         if (nftData.owner == address(0)) revert NotStaked();
312         if (block.timestamp >= nftData.releaseTimestamp) return 0;
313         return nftData.releaseTimestamp - block.timestamp;
314     }
315 
316     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
317         uint256 tokenCount = ownerTokenCount[_owner];
318         uint256 currentTokenId = 0;
319         uint256 arrIndex = 0;
320         uint256[] memory tokenIds = new uint256[](tokenCount);
321 
322         while (arrIndex < tokenCount && currentTokenId <= 2600)
323         {
324             if (stakedNFTs[currentTokenId].owner == _owner)
325             {
326                 tokenIds[arrIndex] = currentTokenId;
327                 arrIndex++;
328             }
329             currentTokenId++;
330         }       
331         return tokenIds;
332     }
333 
334     function addRewards(StakedNFTData memory _nftData, uint8 months, uint256 id) internal {
335         if (months == 1) {
336             if (_nftData.t1Rewards < 4) _nftData.t1Rewards += 1;
337             stakedNFTs[id].t1Rewards = _nftData.t1Rewards;
338             return;
339         }
340         if (months == 3) {
341             _nftData.t1Rewards += 2;
342             stakedNFTs[id].t2Rewards = 1;
343             stakedNFTs[id].t1Rewards = _nftData.t1Rewards;
344             return;
345         }
346         if (months == 5) {
347             stakedNFTs[id].t3Rewards = 1;
348             stakedNFTs[id].t2Rewards = 2;
349             stakedNFTs[id].t1Rewards = 4;
350         }
351     }
352 }