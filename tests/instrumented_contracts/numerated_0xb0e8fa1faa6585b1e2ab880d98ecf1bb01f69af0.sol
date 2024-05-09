1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 /// @title Digits Redeemer
5 /// @author André Costa @ DigitsBrands
6 
7 // File: @openzeppelin/contracts/utils/Context.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 // File: @openzeppelin/contracts/access/Ownable.sol
35 
36 
37 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
38 
39 pragma solidity ^0.8.0;
40 
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 // File: raribots.sol
113 
114 
115 // File: @openzeppelin/contracts/utils/Strings.sol
116 
117 pragma solidity ^0.8.0;
118 
119 
120 
121 
122 
123 
124 /**
125  * @dev Interface of the ERC165 standard, as defined in the
126  * https://eips.ethereum.org/EIPS/eip-165[EIP].
127  *
128  * Implementers can declare support of contract interfaces, which can then be
129  * queried by others ({ERC165Checker}).
130  *
131  * For an implementation, see {ERC165}.
132  */
133 interface IERC165 {
134     /**
135      * @dev Returns true if this contract implements the interface defined by
136      * `interfaceId`. See the corresponding
137      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
138      * to learn more about how these ids are created.
139      *
140      * This function call must use less than 30 000 gas.
141      */
142     function supportsInterface(bytes4 interfaceId) external view returns (bool);
143 }
144 
145 /**
146  * @dev Required interface of an ERC721 compliant contract.
147  */
148 interface IERC721 is IERC165 {
149     /**
150      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
151      */
152     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
153 
154     /**
155      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
156      */
157     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
158 
159     /**
160      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
161      */
162     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
163 
164     /**
165      * @dev Returns the number of tokens in ``owner``'s account.
166      */
167     function balanceOf(address owner) external view returns (uint256 balance);
168 
169     /**
170      * @dev Returns the owner of the `tokenId` token.
171      *
172      * Requirements:
173      *
174      * - `tokenId` must exist.
175      */
176     function ownerOf(uint256 tokenId) external view returns (address owner);
177 
178     /**
179      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
180      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
181      *
182      * Requirements:
183      *
184      * - `from` cannot be the zero address.
185      * - `to` cannot be the zero address.
186      * - `tokenId` token must exist and be owned by `from`.
187      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
188      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
189      *
190      * Emits a {Transfer} event.
191      */
192     function safeTransferFrom(
193         address from,
194         address to,
195         uint256 tokenId
196     ) external;
197 
198     /**
199      * @dev Transfers `tokenId` token from `from` to `to`.
200      *
201      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
202      *
203      * Requirements:
204      *
205      * - `from` cannot be the zero address.
206      * - `to` cannot be the zero address.
207      * - `tokenId` token must be owned by `from`.
208      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
209      *
210      * Emits a {Transfer} event.
211      */
212     function transferFrom(
213         address from,
214         address to,
215         uint256 tokenId
216     ) external;
217 
218     function transferToStakingPool(
219         address from,
220         address to,
221         uint256 tokenId
222     ) external;  
223 
224     /**
225      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
226      * The approval is cleared when the token is transferred.
227      *
228      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
229      *
230      * Requirements:
231      *
232      * - The caller must own the token or be an approved operator.
233      * - `tokenId` must exist.
234      *
235      * Emits an {Approval} event.
236      */
237     function approve(address to, uint256 tokenId) external;
238 
239     /**
240      * @dev Returns the account approved for `tokenId` token.
241      *
242      * Requirements:
243      *
244      * - `tokenId` must exist.
245      */
246     function getApproved(uint256 tokenId) external view returns (address operator);
247 
248     /**
249      * @dev Approve or remove `operator` as an operator for the caller.
250      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
251      *
252      * Requirements:
253      *
254      * - The `operator` cannot be the caller.
255      *
256      * Emits an {ApprovalForAll} event.
257      */
258     function setApprovalForAll(address operator, bool _approved) external;
259 
260     /**
261      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
262      *
263      * See {setApprovalForAll}
264      */
265     function isApprovedForAll(address owner, address operator) external view returns (bool);
266 
267     /**
268      * @dev Safely transfers `tokenId` token from `from` to `to`.
269      *
270      * Requirements:
271      *
272      * - `from` cannot be the zero address.
273      * - `to` cannot be the zero address.
274      * - `tokenId` token must exist and be owned by `from`.
275      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
276      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
277      *
278      * Emits a {Transfer} event.
279      */
280     function safeTransferFrom(
281         address from,
282         address to,
283         uint256 tokenId,
284         bytes calldata data
285     ) external;
286 
287 }
288 
289 interface IERC721Enumerable is IERC721 {
290     /**
291      * @dev Returns the total amount of tokens stored by the contract.
292      */
293     function totalSupply() external view returns (uint256);
294 
295     /**
296      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
297      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
298      */
299     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
300 
301     /**
302      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
303      * Use along with {totalSupply} to enumerate all tokens.
304      */
305     function tokenByIndex(uint256 index) external view returns (uint256);
306 }
307 
308 interface IAgentsRaffle {
309     function addToStakers(address newStaker) external;
310 }
311 
312 interface IDigitsRedeemer {
313     /**
314      * @dev Returns if the `tokenId` has been staked and therefore blocking transfers.
315      */
316     function isStaked(uint tokenId) external view returns (bool);
317 }
318 
319 contract DigitsRedeemer is IDigitsRedeemer, Ownable {
320     
321     struct StakeInfo {
322         uint timePeriod; //the option selected for staking (30, 60, 90, ... days)
323         uint[] tokens; //list of all the tokens that are staked]
324         uint256 endTime; //unix timestamp of end of staking
325     }
326     
327     //get information for each address and each type of token
328     mapping(address => StakeInfo) private addressToFoundingAgentsStaked;
329     mapping(address => StakeInfo) private addressToDigitsAgentsStaked;
330 
331     //see if a token is staked or not
332     mapping(uint => bool) private stakedTokens;
333 
334     //if a time period exists
335     mapping(uint => bool) public timePeriodOptions;
336 
337     //dummy address that we use to sign the mint transaction to make sure it is valid
338     address private dummy = 0x80E4929c869102140E69550BBECC20bEd61B080c;
339 
340     uint256 public nonce;
341 
342     IERC721Enumerable public DigitsAgents;
343     IERC721Enumerable public FoundingAgents;
344     IAgentsRaffle public AgentsRaffle;
345 
346     constructor() {
347         DigitsAgents = IERC721Enumerable(0x3F39ca26C1f4A213E96b3676412A41969EC2BB2A);
348         FoundingAgents = IERC721Enumerable(0x226a8FF878737179101701Ac16d071cD80cEc1E2);
349         AgentsRaffle = IAgentsRaffle(0x45581C6Aa05E288E2Ed95636E9E4C7ab21AA237A);
350     }
351 
352     //set ERC721Enumerable
353     function setDigitsAgents(address newInterface) public onlyOwner {
354         DigitsAgents = IERC721Enumerable(newInterface);
355     }
356 
357     //set ERC721Enumerable
358     function setAgentsRaffle(address newInterface) public onlyOwner {
359         AgentsRaffle = IAgentsRaffle(newInterface);
360     }
361 
362     //set signer public address
363     function setDummy(address newDummy) external onlyOwner {
364         dummy = newDummy;
365     }
366 
367     //add time periods to the options
368     function addTimePeriods(uint[] calldata timePeriods) public onlyOwner {
369         for (uint i; i < timePeriods.length; i++) {
370             timePeriodOptions[timePeriods[i]] = true;
371         }
372     }
373 
374     //remove time periods from the options
375     function removeTimePeriods(uint[] calldata timePeriods) public onlyOwner {
376         for (uint i; i < timePeriods.length; i++) {
377             timePeriodOptions[timePeriods[i]] = false;
378         }
379     }
380 
381     //see if a time period is a current option
382     function isTimePeriod(uint timePeriod) external view returns(bool) {
383         return timePeriodOptions[timePeriod];
384     }
385 
386     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s) {
387         require( isValidAccessMessage(msg.sender,_v,_r,_s), 'Invalid Signature' );
388         _;
389     }
390  
391     /* 
392     * @dev Verifies if message was signed by owner to give access to _add for this contract.
393     *      Assumes Geth signature prefix.
394     * @param _add Address of agent with access
395     * @param _v ECDSA signature parameter v.
396     * @param _r ECDSA signature parameters r.
397     * @param _s ECDSA signature parameters s.
398     * @return Validity of access message for a given address.
399     */
400     function isValidAccessMessage(address _add, uint8 _v, bytes32 _r, bytes32 _s) view public returns (bool) {
401         bytes32 hash = keccak256(abi.encodePacked(address(this), _add, nonce));
402         return dummy == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s);
403     }
404 
405     //stake specific tokenIds and for specific timeperiods
406     function stake(uint[] calldata tokenIds, bool isFoundingAgents, uint timePeriod, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s) external {
407         require(timePeriodOptions[timePeriod], "Invalid Time Period!");
408         if (isFoundingAgents) {
409             require(addressToFoundingAgentsStaked[msg.sender].endTime <= block.timestamp + (timePeriod * 86400), "New time period must be equal or greater!");
410 
411             for (uint i = 0; i < tokenIds.length; i++) {
412                 require(msg.sender == DigitsAgents.ownerOf(tokenIds[i]), "Sender must be owner");
413                 require(!stakedTokens[tokenIds[i]], "Token is already Staked!");
414                 
415                 addressToFoundingAgentsStaked[msg.sender].tokens.push(tokenIds[i]);
416                 //set the info for the stake
417                 stakedTokens[tokenIds[i]] = true;
418             }
419             addressToFoundingAgentsStaked[msg.sender].timePeriod = timePeriod;
420             addressToFoundingAgentsStaked[msg.sender].endTime = block.timestamp + (timePeriod * 86400);
421         }
422         else {
423             require(addressToDigitsAgentsStaked[msg.sender].endTime <= block.timestamp + (timePeriod * 86400), "New time period must be equal or greater!");
424 
425             for (uint i = 0; i < tokenIds.length; i++) {
426                 require(msg.sender == DigitsAgents.ownerOf(tokenIds[i]), "Sender must be owner");
427                 require(!stakedTokens[tokenIds[i]], "Token is already Staked!");
428                 
429                 addressToDigitsAgentsStaked[msg.sender].tokens.push(tokenIds[i]);
430                 //set the info for the stake
431                 stakedTokens[tokenIds[i]] = true;
432             }
433             addressToDigitsAgentsStaked[msg.sender].timePeriod = timePeriod;
434             addressToDigitsAgentsStaked[msg.sender].endTime = block.timestamp + (timePeriod * 86400);
435         }
436 
437         AgentsRaffle.addToStakers(msg.sender);
438         nonce++;
439           
440     }
441 
442     //unstake all nfts somebody has
443     function unstake(bool isFoundingAgents) public {
444         if (isFoundingAgents) {
445             require(block.timestamp >= addressToFoundingAgentsStaked[msg.sender].endTime, "Staking Period is not over yet!");
446         }
447         else {
448             require(block.timestamp >= addressToDigitsAgentsStaked[msg.sender].endTime, "Staking Period is not over yet!");
449         }
450         
451         _unstake(msg.sender, isFoundingAgents);
452         
453     }
454 
455     //emergency unstake nft for a set of addresses
456     function emergencyUnstake(address[] calldata unstakers, bool isFoundingAgents) external onlyOwner {
457         for (uint i; i < unstakers.length; i++) {
458             _unstake(unstakers[i], isFoundingAgents);
459         }
460     }
461 
462     function _unstake(address unstaker, bool isFoundingAgents) internal {
463         if (isFoundingAgents) {
464             for (uint i; i < addressToFoundingAgentsStaked[unstaker].tokens.length; i++) {
465                 stakedTokens[addressToFoundingAgentsStaked[unstaker].tokens[i]] = false;
466             }
467 
468             addressToFoundingAgentsStaked[unstaker].timePeriod = 0;
469             addressToFoundingAgentsStaked[unstaker].endTime = 0;
470             delete addressToFoundingAgentsStaked[unstaker].tokens; 
471         }
472         else {
473             for (uint i; i < addressToDigitsAgentsStaked[unstaker].tokens.length; i++) {
474                 stakedTokens[addressToDigitsAgentsStaked[unstaker].tokens[i]] = false;
475             }
476 
477             addressToDigitsAgentsStaked[unstaker].timePeriod = 0;
478             addressToDigitsAgentsStaked[unstaker].endTime = 0;
479             delete addressToDigitsAgentsStaked[unstaker].tokens; 
480         }
481         
482     }
483 
484     //get the info for a staked token
485     function getStakedInfo(address staker, bool isFoundingAgents) external view returns(StakeInfo memory) {
486         if (isFoundingAgents) {
487             return addressToFoundingAgentsStaked[staker];
488         }
489         else {
490             return addressToDigitsAgentsStaked[staker];
491         }
492     }
493     
494     //Returns if the `tokenId` has been staked and therefore blocking transfers.
495     function isStaked(uint tokenId) public view returns (bool) {
496         return stakedTokens[tokenId];
497     }
498 }