1 pragma solidity 0.5.12;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev Give an account access to this role.
14      */
15     function add(Role storage role, address account) internal {
16         require(!has(role, account), "Roles: account already has role");
17         role.bearer[account] = true;
18     }
19 
20     /**
21      * @dev Remove an account's access to this role.
22      */
23     function remove(Role storage role, address account) internal {
24         require(has(role, account), "Roles: account does not have role");
25         role.bearer[account] = false;
26     }
27 
28     /**
29      * @dev Check if an account has this role.
30      * @return bool
31      */
32     function has(Role storage role, address account) internal view returns (bool) {
33         require(account != address(0), "Roles: account is the zero address");
34         return role.bearer[account];
35     }
36 }
37 
38 /**
39  * @title WhitelistAdminRole
40  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
41  */
42 contract WhitelistAdminRole {
43     using Roles for Roles.Role;
44 
45     event WhitelistAdminAdded(address indexed account);
46     event WhitelistAdminRemoved(address indexed account);
47 
48     Roles.Role private _whitelistAdmins;
49 
50     constructor () internal {
51         _addWhitelistAdmin(msg.sender);
52     }
53 
54     modifier onlyWhitelistAdmin() {
55         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
56         _;
57     }
58 
59     function isWhitelistAdmin(address account) public view returns (bool) {
60         return _whitelistAdmins.has(account);
61     }
62 
63     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
64         _addWhitelistAdmin(account);
65     }
66 
67     function renounceWhitelistAdmin() public {
68         _removeWhitelistAdmin(msg.sender);
69     }
70 
71     function _addWhitelistAdmin(address account) internal {
72         _whitelistAdmins.add(account);
73         emit WhitelistAdminAdded(account);
74     }
75 
76     function _removeWhitelistAdmin(address account) internal {
77         _whitelistAdmins.remove(account);
78         emit WhitelistAdminRemoved(account);
79     }
80 }
81 
82 /**
83  * @title WhitelistedRole
84  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
85  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
86  * it), and not Whitelisteds themselves.
87  */
88 contract WhitelistedRole is WhitelistAdminRole {
89     using Roles for Roles.Role;
90 
91     event WhitelistedAdded(address indexed account);
92     event WhitelistedRemoved(address indexed account);
93 
94     Roles.Role private _whitelisteds;
95 
96     modifier onlyWhitelisted() {
97         require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the Whitelisted role");
98         _;
99     }
100 
101     function isWhitelisted(address account) public view returns (bool) {
102         return _whitelisteds.has(account);
103     }
104 
105     function addWhitelisted(address account) public onlyWhitelistAdmin {
106         _addWhitelisted(account);
107     }
108 
109     function removeWhitelisted(address account) public onlyWhitelistAdmin {
110         _removeWhitelisted(account);
111     }
112 
113     function renounceWhitelisted() public {
114         _removeWhitelisted(msg.sender);
115     }
116 
117     function _addWhitelisted(address account) internal {
118         _whitelisteds.add(account);
119         emit WhitelistedAdded(account);
120     }
121 
122     function _removeWhitelisted(address account) internal {
123         _whitelisteds.remove(account);
124         emit WhitelistedRemoved(account);
125     }
126 }
127 
128 /**
129  * @title BulkWhitelistedRole
130  * @dev a Whitelist role defined using the Open Zeppelin Role system with the addition of bulkAddWhitelisted and
131  * bulkRemoveWhitelisted.
132  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
133  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
134  * it), and not Whitelisteds themselves.
135  */
136 contract BulkWhitelistedRole is WhitelistedRole {
137 
138     function bulkAddWhitelisted(address[] memory accounts) public onlyWhitelistAdmin {
139         for (uint256 index = 0; index < accounts.length; index++) {
140             _addWhitelisted(accounts[index]);
141         }
142     }
143 
144     function bulkRemoveWhitelisted(address[] memory accounts) public onlyWhitelistAdmin {
145         for (uint256 index = 0; index < accounts.length; index++) {
146             _removeWhitelisted(accounts[index]);
147         }
148     }
149 
150 }
151 
152 /**
153  * @dev Interface of the ERC165 standard, as defined in the
154  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
155  *
156  * Implementers can declare support of contract interfaces, which can then be
157  * queried by others (`ERC165Checker`).
158  *
159  * For an implementation, see `ERC165`.
160  */
161 interface IERC165 {
162     /**
163      * @dev Returns true if this contract implements the interface defined by
164      * `interfaceId`. See the corresponding
165      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
166      * to learn more about how these ids are created.
167      *
168      * This function call must use less than 30 000 gas.
169      */
170     function supportsInterface(bytes4 interfaceId) external view returns (bool);
171 }
172 
173 /**
174  * @dev Required interface of an ERC721 compliant contract.
175  */
176 contract IERC721 is IERC165 {
177     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
178     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
179     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
180 
181     /**
182      * @dev Returns the number of NFTs in `owner`'s account.
183      */
184     function balanceOf(address owner) public view returns (uint256 balance);
185 
186     /**
187      * @dev Returns the owner of the NFT specified by `tokenId`.
188      */
189     function ownerOf(uint256 tokenId) public view returns (address owner);
190 
191     /**
192      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
193      * another (`to`).
194      *
195      * 
196      *
197      * Requirements:
198      * - `from`, `to` cannot be zero.
199      * - `tokenId` must be owned by `from`.
200      * - If the caller is not `from`, it must be have been allowed to move this
201      * NFT by either `approve` or `setApproveForAll`.
202      */
203     function safeTransferFrom(address from, address to, uint256 tokenId) public;
204     /**
205      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
206      * another (`to`).
207      *
208      * Requirements:
209      * - If the caller is not `from`, it must be approved to move this NFT by
210      * either `approve` or `setApproveForAll`.
211      */
212     function transferFrom(address from, address to, uint256 tokenId) public;
213     function approve(address to, uint256 tokenId) public;
214     function getApproved(uint256 tokenId) public view returns (address operator);
215 
216     function setApprovalForAll(address operator, bool _approved) public;
217     function isApprovedForAll(address owner, address operator) public view returns (bool);
218 
219 
220     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
221 }
222 
223 /**
224  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
225  * @dev See https://eips.ethereum.org/EIPS/eip-721
226  */
227 contract IERC721Metadata is IERC721 {
228     function name() external view returns (string memory);
229     function symbol() external view returns (string memory);
230     function tokenURI(uint256 tokenId) external view returns (string memory);
231 }
232 
233 contract IRegistry is IERC721Metadata {
234 
235     event NewURI(uint256 indexed tokenId, string uri);
236 
237     event NewURIPrefix(string prefix);
238 
239     event Resolve(uint256 indexed tokenId, address indexed to);
240 
241     event Sync(address indexed resolver, uint256 indexed updateId, uint256 indexed tokenId);
242 
243     /**
244      * @dev Controlled function to set the token URI Prefix for all tokens.
245      * @param prefix string URI to assign
246      */
247     function controlledSetTokenURIPrefix(string calldata prefix) external;
248 
249     /**
250      * @dev Returns whether the given spender can transfer a given token ID.
251      * @param spender address of the spender to query
252      * @param tokenId uint256 ID of the token to be transferred
253      * @return bool whether the msg.sender is approved for the given token ID,
254      * is an operator of the owner, or is the owner of the token
255      */
256     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
257 
258     /**
259      * @dev Mints a new a child token.
260      * Calculates child token ID using a namehash function.
261      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
262      * Requires the token not exist.
263      * @param to address to receive the ownership of the given token ID
264      * @param tokenId uint256 ID of the parent token
265      * @param label subdomain label of the child token ID
266      */
267     function mintChild(address to, uint256 tokenId, string calldata label) external;
268 
269     /**
270      * @dev Controlled function to mint a given token ID.
271      * Requires the msg.sender to be controller.
272      * Requires the token ID to not exist.
273      * @param to address the given token ID will be minted to
274      * @param label string that is a subdomain
275      * @param tokenId uint256 ID of the parent token
276      */
277     function controlledMintChild(address to, uint256 tokenId, string calldata label) external;
278 
279     /**
280      * @dev Transfers the ownership of a child token ID to another address.
281      * Calculates child token ID using a namehash function.
282      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
283      * Requires the token already exist.
284      * @param from current owner of the token
285      * @param to address to receive the ownership of the given token ID
286      * @param tokenId uint256 ID of the token to be transferred
287      * @param label subdomain label of the child token ID
288      */
289     function transferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
290 
291     /**
292      * @dev Controlled function to transfers the ownership of a token ID to
293      * another address.
294      * Requires the msg.sender to be controller.
295      * Requires the token already exist.
296      * @param from current owner of the token
297      * @param to address to receive the ownership of the given token ID
298      * @param tokenId uint256 ID of the token to be transferred
299      */
300     function controlledTransferFrom(address from, address to, uint256 tokenId) external;
301 
302     /**
303      * @dev Safely transfers the ownership of a child token ID to another address.
304      * Calculates child token ID using a namehash function.
305      * Implements a ERC721Reciever check unlike transferFromChild.
306      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
307      * Requires the token already exist.
308      * @param from current owner of the token
309      * @param to address to receive the ownership of the given token ID
310      * @param tokenId uint256 parent ID of the token to be transferred
311      * @param label subdomain label of the child token ID
312      * @param _data bytes data to send along with a safe transfer check
313      */
314     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label, bytes calldata _data) external;
315 
316     /// Shorthand for calling the above ^^^ safeTransferFromChild function with an empty _data parameter. Similar to ERC721.safeTransferFrom.
317     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
318 
319     /**
320      * @dev Controlled frunction to safely transfers the ownership of a token ID
321      * to another address.
322      * Implements a ERC721Reciever check unlike controlledSafeTransferFrom.
323      * Requires the msg.sender to be controller.
324      * Requires the token already exist.
325      * @param from current owner of the token
326      * @param to address to receive the ownership of the given token ID
327      * @param tokenId uint256 parent ID of the token to be transferred
328      * @param _data bytes data to send along with a safe transfer check
329      */
330     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data) external;
331 
332     /**
333      * @dev Burns a child token ID.
334      * Calculates child token ID using a namehash function.
335      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
336      * Requires the token already exist.
337      * @param tokenId uint256 ID of the token to be transferred
338      * @param label subdomain label of the child token ID
339      */
340     function burnChild(uint256 tokenId, string calldata label) external;
341 
342     /**
343      * @dev Controlled function to burn a given token ID.
344      * Requires the msg.sender to be controller.
345      * Requires the token already exist.
346      * @param tokenId uint256 ID of the token to be burned
347      */
348     function controlledBurn(uint256 tokenId) external;
349 
350     /**
351      * @dev Sets the resolver of a given token ID to another address.
352      * Requires the msg.sender to be the owner, approved, or operator.
353      * @param to address the given token ID will resolve to
354      * @param tokenId uint256 ID of the token to be transferred
355      */
356     function resolveTo(address to, uint256 tokenId) external;
357 
358     /**
359      * @dev Gets the resolver of the specified token ID.
360      * @param tokenId uint256 ID of the token to query the resolver of
361      * @return address currently marked as the resolver of the given token ID
362      */
363     function resolverOf(uint256 tokenId) external view returns (address);
364 
365     /**
366      * @dev Controlled function to sets the resolver of a given token ID.
367      * Requires the msg.sender to be controller.
368      * @param to address the given token ID will resolve to
369      * @param tokenId uint256 ID of the token to be transferred
370      */
371     function controlledResolveTo(address to, uint256 tokenId) external;
372 
373     /**
374      * @dev Provides child token (subdomain) of provided tokenId.
375      * @param tokenId uint256 ID of the token
376      * @param label label of subdomain (for `aaa.bbb.crypto` it will be `aaa`)
377      */
378     function childIdOf(uint256 tokenId, string calldata label) external pure returns (uint256);
379 
380     /**
381      * @dev Transfer domain ownership without resetting domain records.
382      * @param to address of new domain owner
383      * @param tokenId uint256 ID of the token to be transferred
384      */
385     function setOwner(address to, uint256 tokenId) external;
386 }
387 
388 pragma experimental ABIEncoderV2;
389 
390 
391 
392 
393 contract IResolver {
394     function reconfigure(string[] memory keys, string[] memory values, uint256 tokenId) public;
395     function setMany(string[] memory keys, string[] memory values, uint256 tokenId) public;
396 }
397 
398 contract DomainZoneController is BulkWhitelistedRole {
399 
400     event MintChild(uint256 indexed tokenId, uint256 indexed parentTokenId, string label);
401 
402     IRegistry internal _registry;
403 
404     constructor (IRegistry registry, address[] memory accounts) public {
405         _registry = registry;
406         for (uint256 index = 0; index < accounts.length; index++) {
407             _addWhitelisted(accounts[index]);
408         }
409     }
410 
411     function mintChild(address to, uint256 tokenId, string memory label, string[] memory keys, string[] memory values) public onlyWhitelisted {
412         address resolver = _registry.resolverOf(tokenId);
413         uint256 childTokenId = _registry.childIdOf(tokenId, label);
414         if (keys.length > 0) {
415             _registry.mintChild(address(this), tokenId, label);
416             _registry.resolveTo(resolver, childTokenId);
417             IResolver(resolver).reconfigure(keys, values, childTokenId);
418             _registry.setOwner(to, childTokenId);
419         } else {
420             _registry.mintChild(to, tokenId, label);
421         }
422 
423         emit MintChild(childTokenId, tokenId, label);
424     }
425 
426     function resolveTo(address to, uint256 tokenId) external onlyWhitelisted {
427         _registry.resolveTo(to, tokenId);
428     }
429 
430     function setMany(string[] memory keys, string[] memory values, uint256 tokenId) public onlyWhitelisted {
431         address resolver = _registry.resolverOf(tokenId);
432         IResolver(resolver).setMany(keys, values, tokenId);
433     }
434 }