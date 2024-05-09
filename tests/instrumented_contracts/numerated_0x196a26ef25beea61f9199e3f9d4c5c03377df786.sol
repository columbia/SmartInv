1 pragma solidity ^0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Emitted when `value` tokens are moved from one account (`from`) to
12      * another (`to`).
13      *
14      * Note that `value` may be zero.
15      */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     /**
19      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
20      * a call to {approve}. `value` is the new allowance.
21      */
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `to`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address to, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `from` to `to` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(
78         address from,
79         address to,
80         uint256 amount
81     ) external returns (bool);
82 }
83 
84 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
85 /**
86  * @dev Provides information about the current execution context, including the
87  * sender of the transaction and its data. While these are generally available
88  * via msg.sender and msg.data, they should not be accessed in such a direct
89  * manner, since when dealing with meta-transactions the account sending and
90  * paying for execution may not be the actual sender (as far as an application
91  * is concerned).
92  *
93  * This contract is only required for intermediate, library-like contracts.
94  */
95 abstract contract Context {
96     function _msgSender() internal view virtual returns (address) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view virtual returns (bytes calldata) {
101         return msg.data;
102     }
103 }
104 
105 contract Membership is Context {
106     address private owner;
107     event MembershipChanged(address indexed owner, uint256 level);
108     event OwnerTransferred(address indexed preOwner, address indexed newOwner);
109 
110     mapping(address => uint256) internal membership;
111 
112     constructor() {
113         owner = _msgSender();
114         setMembership(_msgSender(), 1);
115     }
116 
117     function transferOwner(address newOwner) public onlyOwner {
118         address preOwner = owner;
119         setMembership(newOwner, 1);
120         setMembership(preOwner, 0);
121         owner = newOwner;
122         emit OwnerTransferred(preOwner, newOwner);
123     }
124 
125     function setMembership(address key, uint256 level) public onlyOwner {
126         membership[key] = level;
127         emit MembershipChanged(key, level);
128     }
129 
130     modifier onlyOwner() {
131         require(isOwner(), "Membership : caller is not the owner");
132         _;
133     }
134 
135     function isOwner() public view returns (bool) {
136         return _msgSender() == owner;
137     }
138 
139 
140     modifier onlyAdmin() {
141         require(isAdmin(), "Membership : caller is not a admin");
142         _;
143     }
144 
145     function isAdmin() public view returns (bool) {
146         return membership[_msgSender()] == 1;
147     }
148 
149     modifier onlyMinter() {
150         require(isMinter(), "Memberhsip : caller is not a Minter");
151         _;
152     }
153 
154     function isMinter() public view returns (bool) {
155         return isOwner() || membership[_msgSender()] == 11;
156     }
157     
158     function getMembership(address account) public view returns (uint256){
159         return membership[account];
160     }
161 }
162 
163 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
164 /**
165  * @dev Interface of the ERC165 standard, as defined in the
166  * https://eips.ethereum.org/EIPS/eip-165[EIP].
167  *
168  * Implementers can declare support of contract interfaces, which can then be
169  * queried by others ({ERC165Checker}).
170  *
171  * For an implementation, see {ERC165}.
172  */
173 interface IERC165 {
174     /**
175      * @dev Returns true if this contract implements the interface defined by
176      * `interfaceId`. See the corresponding
177      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
178      * to learn more about how these ids are created.
179      *
180      * This function call must use less than 30 000 gas.
181      */
182     function supportsInterface(bytes4 interfaceId) external view returns (bool);
183 }
184 
185 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
186 /**
187  * @dev Required interface of an ERC721 compliant contract.
188  */
189 interface IERC721 is IERC165 {
190     /**
191      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
192      */
193     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
194 
195     /**
196      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
197      */
198     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
199 
200     /**
201      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
202      */
203     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
204 
205     /**
206      * @dev Returns the number of tokens in ``owner``'s account.
207      */
208     function balanceOf(address owner) external view returns (uint256 balance);
209 
210     /**
211      * @dev Returns the owner of the `tokenId` token.
212      *
213      * Requirements:
214      *
215      * - `tokenId` must exist.
216      */
217     function ownerOf(uint256 tokenId) external view returns (address owner);
218 
219     /**
220      * @dev Safely transfers `tokenId` token from `from` to `to`.
221      *
222      * Requirements:
223      *
224      * - `from` cannot be the zero address.
225      * - `to` cannot be the zero address.
226      * - `tokenId` token must exist and be owned by `from`.
227      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
228      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
229      *
230      * Emits a {Transfer} event.
231      */
232     function safeTransferFrom(
233         address from,
234         address to,
235         uint256 tokenId,
236         bytes calldata data
237     ) external;
238 
239     /**
240      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
241      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
242      *
243      * Requirements:
244      *
245      * - `from` cannot be the zero address.
246      * - `to` cannot be the zero address.
247      * - `tokenId` token must exist and be owned by `from`.
248      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
249      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
250      *
251      * Emits a {Transfer} event.
252      */
253     function safeTransferFrom(
254         address from,
255         address to,
256         uint256 tokenId
257     ) external;
258 
259     /**
260      * @dev Transfers `tokenId` token from `from` to `to`.
261      *
262      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
263      *
264      * Requirements:
265      *
266      * - `from` cannot be the zero address.
267      * - `to` cannot be the zero address.
268      * - `tokenId` token must be owned by `from`.
269      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
270      *
271      * Emits a {Transfer} event.
272      */
273     function transferFrom(
274         address from,
275         address to,
276         uint256 tokenId
277     ) external;
278 
279     /**
280      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
281      * The approval is cleared when the token is transferred.
282      *
283      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
284      *
285      * Requirements:
286      *
287      * - The caller must own the token or be an approved operator.
288      * - `tokenId` must exist.
289      *
290      * Emits an {Approval} event.
291      */
292     function approve(address to, uint256 tokenId) external;
293 
294     /**
295      * @dev Approve or remove `operator` as an operator for the caller.
296      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
297      *
298      * Requirements:
299      *
300      * - The `operator` cannot be the caller.
301      *
302      * Emits an {ApprovalForAll} event.
303      */
304     function setApprovalForAll(address operator, bool _approved) external;
305 
306     /**
307      * @dev Returns the account approved for `tokenId` token.
308      *
309      * Requirements:
310      *
311      * - `tokenId` must exist.
312      */
313     function getApproved(uint256 tokenId) external view returns (address operator);
314 
315     /**
316      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
317      *
318      * See {setApprovalForAll}
319      */
320     function isApprovedForAll(address owner, address operator) external view returns (bool);
321 }
322 
323 contract Transmitter is Membership {
324     function checkToken(address token, address payer, uint256 amount) public view {
325         require(IERC20(token).balanceOf(payer)>=amount, "Insufficient balance");
326         require(IERC20(token).allowance(payer, address(this))>=amount, "Not approved");
327     }
328     function checkNft(address nft, address owner, uint256 tokenId) public view {
329         require(IERC721(nft).ownerOf(tokenId) == owner, "Not owner");
330         require(IERC721(nft).isApprovedForAll(owner, address(this)), "Not approved");
331     }
332     function transferToken(address token, address payer, address receiver, uint256 amount) public onlyMinter{
333         IERC20(token).transferFrom(payer, receiver, amount);
334     }
335     function transferNft(address nft, address owner, address proposer, uint256 tokenId) public onlyMinter{
336         IERC721(nft).transferFrom(owner, proposer, tokenId);
337     }
338 }
339 
340 contract LOKAStaking is Membership{
341     event Stake(address indexed from, uint256 indexed continent, uint256 amount);
342     event Unstake(address indexed from, uint256 indexed continent, uint256 amount);
343     address payable private receiver;
344     address LOKA;
345     Transmitter transmitter;
346     address[] internal stakers;
347     mapping(uint256 => uint256) private continents;
348     mapping(address => mapping (uint256 => uint256) ) public stakes;
349     mapping(address => uint256) public indexes;
350 
351     constructor(address _loka, Transmitter _transmitter) {
352         setLoka(_loka);
353         setTransmitter(_transmitter);
354         setReceiver(payable(_msgSender()));
355     }
356     function setTransmitter(Transmitter _transmitter) public onlyOwner {
357         transmitter = _transmitter;
358     }
359     function setReceiver(address payable _receiver) public onlyOwner {
360         receiver = _receiver;
361     }
362     function setLoka(address _loka) public onlyOwner {
363         LOKA = _loka;
364     }
365     function getReceiver() public view returns(address) {
366         return receiver;
367     }
368     function getTransmitter() public view returns(address) {
369         return address(transmitter);
370     }
371     function getStakerCount() public view returns(uint256){
372         return stakers.length;
373     }
374     function getStakers() public view returns(address[] memory){
375         return stakers;
376     }
377     function getStakersRange(uint256 start, uint256 end) public view returns(address[] memory){
378         address[] memory addresses = new address[](end-start);
379          for(uint256 i=start; i<end; ++i){
380             addresses[i-start] = stakers[i];
381         }
382         return addresses;
383     }
384     function getAmount() public view returns(uint256[] memory){
385         uint256[] memory amounts = new uint256[](stakers.length);
386         for(uint256 i=0; i<stakers.length; ++i){
387             amounts[i] = stakes[stakers[i]][0];
388         }
389         return amounts;
390     }
391     function getAmountRange(uint256 start, uint256 end) public view returns(uint256[] memory){
392         uint256[] memory amounts = new uint256[](end-start);
393         for(uint256 i=start; i<end; ++i){
394             amounts[i-start] = stakes[stakers[i]][0];
395         }
396         return amounts;
397     }
398     function getAmounts(uint256 size) public view returns(uint256[][] memory){
399         uint256[][] memory amounts = new uint256[][](stakers.length);
400         for(uint256 i=0; i<stakers.length; ++i){
401             amounts[i] = new uint256[](size);
402             for(uint256 j=0; j<size; ++j)
403                 amounts[i][j] = stakes[stakers[i]][j];
404         }
405         return amounts;
406     }
407     function getAmountsByAddress(uint256 size, address[] memory owners) public view returns(uint256[][] memory){
408         uint256[][] memory amounts = new uint256[][](owners.length);
409         for(uint256 i=0; i<owners.length; ++i){
410             amounts[i] = new uint256[](size);
411             for(uint256 j=0; j<size; ++j)
412                 amounts[i][j] = stakes[owners[i]][j];
413         }
414         return amounts;
415     }
416     function getAmountsRange(uint256 size, uint256 start, uint256 end) public view returns(uint256[][] memory){
417         uint256[][] memory amounts = new uint256[][](end-start);
418         for(uint256 i=start; i<end; ++i){
419             amounts[i-start] = new uint256[](size);
420             for(uint256 j=0; j<size; ++j)
421                 amounts[i-start][j] = stakes[stakers[i]][j];
422         }
423         return amounts;
424     }
425     function stake(uint256 continent, uint256 amount) public {
426         require(continent>0, "Invalid index");
427         require(amount>0, "Invalid amount");
428         transmitter.transferToken(LOKA, _msgSender(), receiver, amount);
429         continents[continent] += amount;
430         continents[0] += amount;
431         stakes[_msgSender()][continent] += amount;
432         stakes[_msgSender()][0] += amount;
433         if(indexes[_msgSender()]==0)
434         {
435             stakers.push(_msgSender());
436             indexes[_msgSender()] = stakers.length;
437         }
438         emit Stake(_msgSender(), continent, amount);
439     }
440     function unstake(uint256 continent, uint256 amount) public {
441         require(continent>0, "Invalid index");
442         require(amount>0, "Invalid amount");
443         require(stakes[_msgSender()][continent]>=amount, "Insufficient balance");
444         transmitter.transferToken(LOKA, receiver, _msgSender(), amount);
445         continents[continent] -= amount;
446         continents[0] -= amount;
447         stakes[_msgSender()][continent] -= amount;
448         stakes[_msgSender()][0] -= amount;
449         emit Unstake(_msgSender(), continent, amount);
450     }
451     
452     function stakeOf(address owner, uint256 continent) public view returns(uint256) {
453         return stakes[owner][continent];
454     }
455     function totalStakeOf(address owner) public view returns(uint256) {
456         return stakes[owner][0];
457     }
458     function allStakeOf(address owner, uint256 size) public view returns(uint256[] memory) {
459         uint256[] memory all = new uint256[](size);
460         for(uint256 i=0; i<size; ++i)
461             all[i] = stakes[owner][i];
462         return all;
463     }
464 
465     function stakeOfContinent(uint256 index) public view returns(uint256) {
466         return continents[index];
467     }
468     function totalStakeOfContinent() public view returns(uint256) {
469         return continents[0];
470     }
471     function allStakeOfContinent(uint256 size) public view returns(uint256[] memory) {
472         uint256[] memory all = new uint256[](size);
473         for(uint256 i=0; i<size; ++i)
474             all[i] = continents[i];
475         return all;
476     }
477 }