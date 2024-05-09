1 // File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
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
28 // File: @openzeppelin\contracts\token\ERC1155\IERC1155.sol
29 
30 // SPDX_License_Identifier: MIT
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Required interface of an ERC1155 compliant contract, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
38  *
39  * _Available since v3.1._
40  */
41 interface IERC1155 is IERC165 {
42     /**
43      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
44      */
45     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
46 
47     /**
48      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
49      * transfers.
50      */
51     event TransferBatch(
52         address indexed operator,
53         address indexed from,
54         address indexed to,
55         uint256[] ids,
56         uint256[] values
57     );
58 
59     /**
60      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
61      * `approved`.
62      */
63     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
64 
65     /**
66      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
67      *
68      * If an {URI} event was emitted for `id`, the standard
69      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
70      * returned by {IERC1155MetadataURI-uri}.
71      */
72     event URI(string value, uint256 indexed id);
73 
74     /**
75      * @dev Returns the amount of tokens of token type `id` owned by `account`.
76      *
77      * Requirements:
78      *
79      * - `account` cannot be the zero address.
80      */
81     function balanceOf(address account, uint256 id) external view returns (uint256);
82 
83     /**
84      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
85      *
86      * Requirements:
87      *
88      * - `accounts` and `ids` must have the same length.
89      */
90     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
91         external
92         view
93         returns (uint256[] memory);
94 
95     /**
96      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
97      *
98      * Emits an {ApprovalForAll} event.
99      *
100      * Requirements:
101      *
102      * - `operator` cannot be the caller.
103      */
104     function setApprovalForAll(address operator, bool approved) external;
105 
106     /**
107      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
108      *
109      * See {setApprovalForAll}.
110      */
111     function isApprovedForAll(address account, address operator) external view returns (bool);
112 
113     /**
114      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
115      *
116      * Emits a {TransferSingle} event.
117      *
118      * Requirements:
119      *
120      * - `to` cannot be the zero address.
121      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
122      * - `from` must have a balance of tokens of type `id` of at least `amount`.
123      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
124      * acceptance magic value.
125      */
126     function safeTransferFrom(
127         address from,
128         address to,
129         uint256 id,
130         uint256 amount,
131         bytes calldata data
132     ) external;
133 
134     /**
135      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
136      *
137      * Emits a {TransferBatch} event.
138      *
139      * Requirements:
140      *
141      * - `ids` and `amounts` must have the same length.
142      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
143      * acceptance magic value.
144      */
145     function safeBatchTransferFrom(
146         address from,
147         address to,
148         uint256[] calldata ids,
149         uint256[] calldata amounts,
150         bytes calldata data
151     ) external;
152 }
153 
154 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
155 
156 // SPDX_License_Identifier: MIT
157 
158 pragma solidity ^0.8.0;
159 
160 /**
161  * @dev Interface of the ERC20 standard as defined in the EIP.
162  */
163 interface IERC20 {
164     /**
165      * @dev Returns the amount of tokens in existence.
166      */
167     function totalSupply() external view returns (uint256);
168 
169     /**
170      * @dev Returns the amount of tokens owned by `account`.
171      */
172     function balanceOf(address account) external view returns (uint256);
173 
174     /**
175      * @dev Moves `amount` tokens from the caller's account to `recipient`.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transfer(address recipient, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Returns the remaining number of tokens that `spender` will be
185      * allowed to spend on behalf of `owner` through {transferFrom}. This is
186      * zero by default.
187      *
188      * This value changes when {approve} or {transferFrom} are called.
189      */
190     function allowance(address owner, address spender) external view returns (uint256);
191 
192     /**
193      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * IMPORTANT: Beware that changing an allowance with this method brings the risk
198      * that someone may use both the old and the new allowance by unfortunate
199      * transaction ordering. One possible solution to mitigate this race
200      * condition is to first reduce the spender's allowance to 0 and set the
201      * desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address spender, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Moves `amount` tokens from `sender` to `recipient` using the
210      * allowance mechanism. `amount` is then deducted from the caller's
211      * allowance.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(
218         address sender,
219         address recipient,
220         uint256 amount
221     ) external returns (bool);
222 
223     /**
224      * @dev Emitted when `value` tokens are moved from one account (`from`) to
225      * another (`to`).
226      *
227      * Note that `value` may be zero.
228      */
229     event Transfer(address indexed from, address indexed to, uint256 value);
230 
231     /**
232      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
233      * a call to {approve}. `value` is the new allowance.
234      */
235     event Approval(address indexed owner, address indexed spender, uint256 value);
236 }
237 
238 // File: contracts\AleToschiSwitch.sol
239 
240 //SPDX_License_Identifier: MIT
241 pragma solidity >=0.7.0;
242 
243 
244 
245 interface IVotingToken is IERC20 {
246     function burn(uint256 amount) external;
247 }
248 
249 interface AleToschiSwitchPriceDumper {
250     function pricePerETH(address) external view returns(uint256);
251 }
252 
253 contract AleToschiSwitch {
254 
255     address private creator = msg.sender;
256 
257     address private switchPriceDumper;
258     address private destinationTokenAddress;
259     address[] private tokenAddresses;
260     uint256[] private conversionsPerToken;
261     uint256 private totalSupply;
262     uint256 private snapshotBlock;
263     uint256 private startBlock;
264 
265     constructor(address _switchPriceDumper, address _destinationTokenAddress, address[] memory _tokenAddresses, uint256 _totalSupply, uint256 _snapshotBlock, uint256 _startBlock) {
266         switchPriceDumper = _switchPriceDumper;
267         destinationTokenAddress = _destinationTokenAddress;
268         tokenAddresses = _tokenAddresses;
269         totalSupply = _totalSupply;
270         snapshotBlock = _snapshotBlock;
271         startBlock = _startBlock;
272     }
273 
274     function info() external view returns(address, address, address[] memory, uint256[] memory, uint256, uint256, uint256) {
275         return (switchPriceDumper, destinationTokenAddress, tokenAddresses, conversionsPerToken, totalSupply, snapshotBlock, startBlock);
276     }
277 
278     function snapshot() external {
279         require(block.number >= snapshotBlock, "too early");
280         require(conversionsPerToken.length == 0, "already done");
281         require(msg.sender == creator, "only creator");
282         uint256[] memory tokenMarketCaps = new uint256[](tokenAddresses.length);
283         uint256[] memory tokenTotalSupplies = new uint256[](tokenAddresses.length);
284         uint256 cumulativeMarketCap = 0;
285         for(uint256 i = 0; i < tokenAddresses.length; i++) {
286             uint256 tokenPrice = AleToschiSwitchPriceDumper(switchPriceDumper).pricePerETH(tokenAddresses[i]);
287             uint256 tokenTotalSupply = IERC20(tokenAddresses[i]).totalSupply();
288             uint256 tokenMarketCap = tokenPrice * tokenTotalSupply;
289             tokenTotalSupplies[i] = tokenTotalSupply;
290             tokenMarketCaps[i] = tokenMarketCap;
291             cumulativeMarketCap += tokenMarketCap;
292         }
293         for(uint256 i = 0; i < tokenAddresses.length; i++) {
294             uint256 tokenRatio = (tokenMarketCaps[i] * 1e18) / cumulativeMarketCap;
295             uint256 tokenNumerator = tokenRatio * totalSupply;
296             uint256 conversionPerToken = tokenNumerator / tokenTotalSupplies[i];
297             conversionsPerToken.push(conversionPerToken);
298         }
299     }
300 
301     modifier preConditionCheck(uint256 tokenAddressIndex, uint256 amount) {
302         require(block.number >= startBlock, "too early");
303         require(conversionsPerToken.length > 0, "snapshot");
304         require(tokenAddressIndex < tokenAddresses.length, "unsupported");
305         require(amount > 0, "amount");
306         _;
307     }
308 
309     function performSwitch(uint256 tokenAddressIndex, uint256 amount, address receiverInput) external preConditionCheck(tokenAddressIndex, amount) {
310         address tokenAddress = tokenAddresses[tokenAddressIndex];
311         IVotingToken token = IVotingToken(tokenAddress);
312         token.transferFrom(msg.sender, address(this), amount);
313         token.burn(amount);
314         uint256 value = calculateAmount(tokenAddressIndex, amount);
315         address receiver = receiverInput == address(0) ? msg.sender : receiverInput;
316         IERC20(destinationTokenAddress).transfer(receiver, value);
317     }
318 
319     function calculateAmount(uint256 tokenAddressIndex, uint256 amount) public preConditionCheck(tokenAddressIndex, amount) view returns(uint256) {
320         return (conversionsPerToken[tokenAddressIndex] * amount) / 1e18;
321     }
322 }