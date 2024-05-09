1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-19
3 */
4 
5 // File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 // File: @openzeppelin\contracts\token\ERC1155\IERC1155.sol
33 
34 // SPDX_License_Identifier: MIT
35 
36 pragma solidity ^0.8.0;
37 
38 
39 /**
40  * @dev Required interface of an ERC1155 compliant contract, as defined in the
41  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
42  *
43  * _Available since v3.1._
44  */
45 interface IERC1155 is IERC165 {
46     /**
47      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
48      */
49     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
50 
51     /**
52      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
53      * transfers.
54      */
55     event TransferBatch(
56         address indexed operator,
57         address indexed from,
58         address indexed to,
59         uint256[] ids,
60         uint256[] values
61     );
62 
63     /**
64      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
65      * `approved`.
66      */
67     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
68 
69     /**
70      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
71      *
72      * If an {URI} event was emitted for `id`, the standard
73      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
74      * returned by {IERC1155MetadataURI-uri}.
75      */
76     event URI(string value, uint256 indexed id);
77 
78     /**
79      * @dev Returns the amount of tokens of token type `id` owned by `account`.
80      *
81      * Requirements:
82      *
83      * - `account` cannot be the zero address.
84      */
85     function balanceOf(address account, uint256 id) external view returns (uint256);
86 
87     /**
88      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
89      *
90      * Requirements:
91      *
92      * - `accounts` and `ids` must have the same length.
93      */
94     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
95         external
96         view
97         returns (uint256[] memory);
98 
99     /**
100      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
101      *
102      * Emits an {ApprovalForAll} event.
103      *
104      * Requirements:
105      *
106      * - `operator` cannot be the caller.
107      */
108     function setApprovalForAll(address operator, bool approved) external;
109 
110     /**
111      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
112      *
113      * See {setApprovalForAll}.
114      */
115     function isApprovedForAll(address account, address operator) external view returns (bool);
116 
117     /**
118      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
119      *
120      * Emits a {TransferSingle} event.
121      *
122      * Requirements:
123      *
124      * - `to` cannot be the zero address.
125      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
126      * - `from` must have a balance of tokens of type `id` of at least `amount`.
127      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
128      * acceptance magic value.
129      */
130     function safeTransferFrom(
131         address from,
132         address to,
133         uint256 id,
134         uint256 amount,
135         bytes calldata data
136     ) external;
137 
138     /**
139      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
140      *
141      * Emits a {TransferBatch} event.
142      *
143      * Requirements:
144      *
145      * - `ids` and `amounts` must have the same length.
146      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
147      * acceptance magic value.
148      */
149     function safeBatchTransferFrom(
150         address from,
151         address to,
152         uint256[] calldata ids,
153         uint256[] calldata amounts,
154         bytes calldata data
155     ) external;
156 }
157 
158 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
159 
160 // SPDX_License_Identifier: MIT
161 
162 pragma solidity ^0.8.0;
163 
164 /**
165  * @dev Interface of the ERC20 standard as defined in the EIP.
166  */
167 interface IERC20 {
168     /**
169      * @dev Returns the amount of tokens in existence.
170      */
171     function totalSupply() external view returns (uint256);
172 
173     /**
174      * @dev Returns the amount of tokens owned by `account`.
175      */
176     function balanceOf(address account) external view returns (uint256);
177 
178     /**
179      * @dev Moves `amount` tokens from the caller's account to `recipient`.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transfer(address recipient, uint256 amount) external returns (bool);
186 
187     /**
188      * @dev Returns the remaining number of tokens that `spender` will be
189      * allowed to spend on behalf of `owner` through {transferFrom}. This is
190      * zero by default.
191      *
192      * This value changes when {approve} or {transferFrom} are called.
193      */
194     function allowance(address owner, address spender) external view returns (uint256);
195 
196     /**
197      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * IMPORTANT: Beware that changing an allowance with this method brings the risk
202      * that someone may use both the old and the new allowance by unfortunate
203      * transaction ordering. One possible solution to mitigate this race
204      * condition is to first reduce the spender's allowance to 0 and set the
205      * desired value afterwards:
206      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207      *
208      * Emits an {Approval} event.
209      */
210     function approve(address spender, uint256 amount) external returns (bool);
211 
212     /**
213      * @dev Moves `amount` tokens from `sender` to `recipient` using the
214      * allowance mechanism. `amount` is then deducted from the caller's
215      * allowance.
216      *
217      * Returns a boolean value indicating whether the operation succeeded.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transferFrom(
222         address sender,
223         address recipient,
224         uint256 amount
225     ) external returns (bool);
226 
227     /**
228      * @dev Emitted when `value` tokens are moved from one account (`from`) to
229      * another (`to`).
230      *
231      * Note that `value` may be zero.
232      */
233     event Transfer(address indexed from, address indexed to, uint256 value);
234 
235     /**
236      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
237      * a call to {approve}. `value` is the new allowance.
238      */
239     event Approval(address indexed owner, address indexed spender, uint256 value);
240 }
241 
242 // File: contracts\AleToschiSwitch.sol
243 
244 //SPDX_License_Identifier: MIT
245 pragma solidity >=0.7.0;
246 
247 
248 
249 interface IVotingToken is IERC20 {
250     function burn(uint256 amount) external;
251 }
252 
253 interface AleToschiSwitchPriceDumper {
254     function pricePerETH(address) external view returns(uint256);
255 }
256 
257 contract AleToschiSwitch {
258 
259     address private creator = msg.sender;
260 
261     address private switchPriceDumper;
262     address private destinationTokenAddress;
263     address[] private tokenAddresses;
264     uint256[] private conversionsPerToken;
265     uint256 private totalSupply;
266     uint256 private snapshotBlock;
267     uint256 private startBlock;
268 
269     constructor(address _switchPriceDumper, address _destinationTokenAddress, address[] memory _tokenAddresses, uint256 _totalSupply, uint256[] memory _conversionsPerToken) {
270         switchPriceDumper = _switchPriceDumper;
271         destinationTokenAddress = _destinationTokenAddress;
272         tokenAddresses = _tokenAddresses;
273         totalSupply = _totalSupply;
274         conversionsPerToken = _conversionsPerToken;
275     }
276 
277     function info() external view returns(address, address, address[] memory, uint256[] memory, uint256, uint256, uint256) {
278         return (switchPriceDumper, destinationTokenAddress, tokenAddresses, conversionsPerToken, totalSupply, snapshotBlock, startBlock);
279     }
280 
281     function snapshot() external {
282         revert("Useless");
283     }
284 
285     modifier preConditionCheck(uint256 tokenAddressIndex, uint256 amount) {
286         require(conversionsPerToken.length > 0, "snapshot");
287         require(tokenAddressIndex < tokenAddresses.length, "unsupported");
288         require(amount > 0, "amount");
289         _;
290     }
291 
292     function performSwitch(uint256 tokenAddressIndex, uint256 amount, address receiverInput) external preConditionCheck(tokenAddressIndex, amount) {
293         address tokenAddress = tokenAddresses[tokenAddressIndex];
294         IVotingToken token = IVotingToken(tokenAddress);
295         token.transferFrom(msg.sender, address(this), amount);
296         token.burn(amount);
297         uint256 value = calculateAmount(tokenAddressIndex, amount);
298         address receiver = receiverInput == address(0) ? msg.sender : receiverInput;
299         IERC20(destinationTokenAddress).transfer(receiver, value);
300     }
301 
302     function calculateAmount(uint256 tokenAddressIndex, uint256 amount) public preConditionCheck(tokenAddressIndex, amount) view returns(uint256) {
303         return (conversionsPerToken[tokenAddressIndex] * amount) / 1e18;
304     }
305 }