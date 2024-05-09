1 // File: node_modules\@openzeppelin\contracts\introspection\IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin\contracts\token\ERC721\IERC721.sol
29 
30 pragma solidity ^0.7.0;
31 
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
68      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(address from, address to, uint256 tokenId) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(address from, address to, uint256 tokenId) external;
97 
98     /**
99      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
100      * The approval is cleared when the token is transferred.
101      *
102      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
103      *
104      * Requirements:
105      *
106      * - The caller must own the token or be an approved operator.
107      * - `tokenId` must exist.
108      *
109      * Emits an {Approval} event.
110      */
111     function approve(address to, uint256 tokenId) external;
112 
113     /**
114      * @dev Returns the account approved for `tokenId` token.
115      *
116      * Requirements:
117      *
118      * - `tokenId` must exist.
119      */
120     function getApproved(uint256 tokenId) external view returns (address operator);
121 
122     /**
123      * @dev Approve or remove `operator` as an operator for the caller.
124      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
125      *
126      * Requirements:
127      *
128      * - The `operator` cannot be the caller.
129      *
130      * Emits an {ApprovalForAll} event.
131      */
132     function setApprovalForAll(address operator, bool _approved) external;
133 
134     /**
135      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
136      *
137      * See {setApprovalForAll}
138      */
139     function isApprovedForAll(address owner, address operator) external view returns (bool);
140 
141     /**
142       * @dev Safely transfers `tokenId` token from `from` to `to`.
143       *
144       * Requirements:
145       *
146      * - `from` cannot be the zero address.
147      * - `to` cannot be the zero address.
148       * - `tokenId` token must exist and be owned by `from`.
149       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
150       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151       *
152       * Emits a {Transfer} event.
153       */
154     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
155 }
156 
157 // File: contracts\GFarmNftSwap.sol
158 
159 pragma solidity 0.7.5;
160 
161 interface GFarmNftInterface{
162     function idToLeverage(uint id) external view returns(uint8);
163     function transferFrom(address from, address to, uint256 tokenId) external;
164 }
165 
166 interface GFarmBridgeableNftInterface{
167     function ownerOf(uint256 tokenId) external view returns (address);
168 	function mint(address to, uint tokenId) external;
169 	function burn(uint tokenId) external;
170     function transferFrom(address from, address to, uint256 tokenId) external;
171 
172 }
173 
174 contract GFarmNftSwap{
175 
176 	GFarmNftInterface public nft;
177 	GFarmBridgeableNftInterface[5] public bridgeableNfts;
178 	address public gov;
179 
180 	event NftToBridgeableNft(uint nftType, uint tokenId);
181 	event BridgeableNftToNft(uint nftType, uint tokenId);
182 
183 	constructor(GFarmNftInterface _nft){
184 		nft = _nft;
185 		gov = msg.sender;
186 	}
187 
188 	function setBridgeableNfts(GFarmBridgeableNftInterface[5] calldata _bridgeableNfts) external{
189 		require(msg.sender == gov, "ONLY_GOV");
190 		require(bridgeableNfts[0] == GFarmBridgeableNftInterface(0), "BRIDGEABLE_NFTS_ALREADY_SET");
191 		bridgeableNfts = _bridgeableNfts;
192 	}
193 
194 	function leverageToType(uint leverage) pure private returns(uint){
195 		// 150 => 5
196 		if(leverage == 150){ return 5; }
197 		
198 		// 25 => 1, 50 => 2, 75 => 3, 100 => 4
199 		return leverage / 25;
200 	}
201 
202 	// Important: nft types = 1,2,3,4,5 (25x, 50x, 75x, 100x, 150x)
203 	modifier correctNftType(uint nftType){
204 		require(nftType > 0 && nftType < 6, "NFT_TYPE_BETWEEN_1_AND_5");
205 		_;
206 	}
207 
208 	// Swap non-bridgeable nft for bridgeable nft
209 	function getBridgeableNft(uint nftType, uint tokenId) public correctNftType(nftType){
210 		// 1. token id corresponds to type provided
211 		require(leverageToType(nft.idToLeverage(tokenId)) == nftType, "WRONG_TYPE");
212 
213 		// 2. transfer nft to this contract
214 		nft.transferFrom(msg.sender, address(this), tokenId);
215 
216 		// 3. mint bridgeable nft of same type
217 		bridgeableNfts[nftType-1].mint(msg.sender, tokenId);
218 
219 		emit NftToBridgeableNft(nftType, tokenId);
220 	}
221 
222 	// Swap non-bridgeable nfts for bridgeable nfts
223 	function getBridgeableNfts(uint nftType, uint[] calldata ids) external correctNftType(nftType){
224 		// 1. max 10 at the same time
225 		require(ids.length <= 10, "MAX_10");
226 
227 		// 2. loop over ids
228 		for(uint i = 0; i < ids.length; i++){
229 			getBridgeableNft(nftType, ids[i]);
230 		}
231 	}
232 
233 	// Swap bridgeable nft for unbridgeable nft
234 	function getNft(uint nftType, uint tokenId) public correctNftType(nftType){
235 		// 1. Verify he owns the NFT
236 		require(bridgeableNfts[nftType-1].ownerOf(tokenId) == msg.sender, "NOT_OWNER");
237 
238 		// 2. Burn bridgeable nft
239 		bridgeableNfts[nftType-1].burn(tokenId);
240 
241 		// 3. transfer nft to msg.sender
242 		nft.transferFrom(address(this), msg.sender, tokenId);
243 
244 		emit BridgeableNftToNft(nftType, tokenId);
245 	}
246 
247 	// Swap bridgeable nft for unbridgeable nfts
248 	function getNfts(uint nftType, uint[] calldata ids) external correctNftType(nftType){
249 		// 1. max 10 at the same time
250 		require(ids.length <= 10, "MAX_10");
251 
252 		// 2. loop over ids
253 		for(uint i = 0; i < ids.length; i++){
254 			getNft(nftType, ids[i]);
255 		}
256 	}
257 
258 }