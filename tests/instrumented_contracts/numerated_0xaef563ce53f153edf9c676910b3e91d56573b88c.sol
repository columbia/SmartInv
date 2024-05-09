1 // SPDX-License-Identifier: Apache-2.0
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8 
9   /**
10     * @dev Returns the amount of tokens owned by `account`.
11     */
12   function balanceOf(address account) external view returns (uint256);
13 
14   /**
15     * @dev Moves `amount` tokens from the caller's account to `recipient`.
16     *
17     * Returns a boolean value indicating whether the operation succeeded.
18     *
19     * Emits a {Transfer} event.
20     */
21   function transfer(address recipient, uint256 amount) external returns (bool);
22 
23   /**
24     * @dev Moves `amount` tokens from `sender` to `recipient` using the
25     * allowance mechanism. `amount` is then deducted from the caller's
26     * allowance.
27     *
28     * Returns a boolean value indicating whether the operation succeeded.
29     *
30     * Emits a {Transfer} event.
31     */
32   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33 }
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 {
39 
40   /**
41     * @dev Transfers `tokenId` token from `from` to `to`.
42     *
43     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
44     *
45     * Requirements:
46     *
47     * - `from` cannot be the zero address.
48     * - `to` cannot be the zero address.
49     * - `tokenId` token must be owned by `from`.
50     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
51     *
52     * Emits a {Transfer} event.
53     */
54   function transferFrom(
55     address from,
56     address to,
57     uint256 tokenId
58   ) external;
59 }
60 
61 interface IVaultConfig {
62 
63   function fee() external view returns (uint256);
64   function gasLimit() external view returns (uint256);
65   function ownerReward() external view returns (uint256);
66 }
67 
68 /*
69  * @dev Provides information about the current execution context, including the
70  * sender of the transaction and its data. While these are generally available
71  * via msg.sender and msg.data, they should not be accessed in such a direct
72  * manner, since when dealing with GSN meta-transactions the account sending and
73  * paying for execution may not be the actual sender (as far as an application
74  * is concerned).
75  *
76  * This contract is only required for intermediate, library-like contracts.
77  */
78 abstract contract Context {
79   function _msgSender() internal view returns (address) {
80     return msg.sender;
81   }
82 
83   function _msgData() internal view returns (bytes memory) {
84     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
85     return msg.data;
86   }
87 
88   function _msgValue() internal view returns (uint256) {
89     return msg.value;
90   }
91 }
92 
93 /**
94  * @dev Contract module which provides a basic access control mechanism, where
95  * there is an account (an owner) that can be granted exclusive access to
96  * specific functions.
97  *
98  * By default, the owner account will be the one that deploys the contract. This
99  * can later be changed with {transferOwnership}.
100  *
101  * This module is used through inheritance. It will make available the modifier
102  * `onlyOwner`, which can be applied to your functions to restrict their use to
103  * the owner.
104  */
105 abstract contract Ownable is Context {
106   address private _owner;
107   address private _newOwner;
108 
109   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111   /**
112    * @dev Initializes the contract setting the deployer as the initial owner.
113    */
114   constructor (address owner_) {
115     _owner = owner_;
116     emit OwnershipTransferred(address(0), owner_);
117   }
118 
119   /**
120    * @dev Returns the address of the current owner.
121    */
122   function owner() public view returns (address) {
123     return _owner;
124   }
125 
126   /**
127    * @dev Throws if called by any account other than the owner.
128    */
129   modifier onlyOwner() {
130     require(owner() == _msgSender(), "Ownable: caller is not the owner");
131     _;
132   }
133 
134   /**
135    * @dev Accept the ownership transfer. This is to make sure that the contract is
136    * transferred to a working address
137    *
138    * Can only be called by the newly transfered owner.
139    */
140   function acceptOwnership() public {
141     require(_msgSender() == _newOwner, "Ownable: only new owner can accept ownership");
142     address oldOwner = _owner;
143     _owner = _newOwner;
144     _newOwner = address(0);
145     emit OwnershipTransferred(oldOwner, _owner);
146   }
147 
148   /**
149    * @dev Transfers ownership of the contract to a new account (`newOwner`).
150    *
151    * Can only be called by the current owner.
152    */
153   function transferOwnership(address newOwner) public onlyOwner {
154     require(newOwner != address(0), "Ownable: new owner is the zero address");
155     _newOwner = newOwner;
156   }
157 }
158 
159 /**
160  * @dev Enable contract to receive gas token
161  */
162 abstract contract Payable {
163 
164   event Deposited(address indexed sender, uint256 value);
165 
166   fallback() external payable {
167     if(msg.value > 0) {
168       emit Deposited(msg.sender, msg.value);
169     }
170   }
171 
172   /// @dev enable wallet to receive ETH
173   receive() external payable {
174     if(msg.value > 0) {
175       emit Deposited(msg.sender, msg.value);
176     }
177   }
178 }
179 
180 /**
181  * @dev These functions deal with verification of Merkle trees (hash trees),
182  */
183 library MerkleProof {
184   /**
185     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
186     * defined by `root`. For this, a `proof` must be provided, containing
187     * sibling hashes on the branch from the leaf to the root of the tree. Each
188     * pair of leaves and each pair of pre-images are assumed to be sorted.
189     */
190   function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
191     bytes32 computedHash = leaf;
192 
193     for (uint256 i = 0; i < proof.length; i++) {
194       bytes32 proofElement = proof[i];
195 
196       if (computedHash <= proofElement) {
197         // Hash(current computed hash + current element of the proof)
198         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
199       } else {
200         // Hash(current element of the proof + current computed hash)
201         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
202       }
203     }
204 
205     // Check if the computed hash (root) is equal to the provided root
206     return computedHash == root;
207   }
208 }
209 
210 /**
211  * @dev Coin98Vault contract to enable vesting funds to investors
212  */
213 contract Coin98Vault is Ownable, Payable {
214 
215   address private _factory;
216   address[] private _admins;
217   mapping(address => bool) private _adminStatuses;
218   mapping(uint256 => EventData) private _eventDatas;
219   mapping(uint256 => mapping(uint256 => bool)) private _eventRedemptions;
220 
221   /// @dev Initialize a new vault
222   /// @param factory_ Back reference to the factory initialized this vault for global configuration
223   /// @param owner_ Owner of this vault
224   constructor(address factory_, address owner_) Ownable(owner_) {
225     _factory = factory_;
226   }
227 
228   struct EventData {
229     uint256 timestamp;
230     bytes32 merkleRoot;
231     address receivingToken;
232     address sendingToken;
233     uint8 isActive;
234   }
235 
236   event AdminAdded(address indexed admin);
237   event AdminRemoved(address indexed admin);
238   event EventCreated(uint256 eventId, EventData eventData);
239   event EventUpdated(uint256 eventId, uint8 isActive);
240   event Redeemed(uint256 eventId, uint256 index, address indexed recipient, address indexed receivingToken, uint256 receivingTokenAmount, address indexed sendingToken, uint256 sendingTokenAmount);
241   event Withdrawn(address indexed owner, address indexed recipient, address indexed token, uint256 value);
242 
243   function _setRedemption(uint256 eventId_, uint256 index_) private {
244     _eventRedemptions[eventId_][index_] = true;
245   }
246 
247   /// @dev Access Control, only owner and admins are able to access the specified function
248   modifier onlyAdmin() {
249     require(owner() == _msgSender() || _adminStatuses[_msgSender()], "Ownable: caller is not an admin");
250     _;
251   }
252 
253   /// @dev returns current admins who can manage the vault
254   function admins() public view returns (address[] memory) {
255     return _admins;
256   }
257 
258   /// @dev returns info of an event
259   /// @param eventId_ ID of the event
260   function eventInfo(uint256 eventId_) public view returns (EventData memory) {
261     return _eventDatas[eventId_];
262   }
263 
264   /// @dev address of the factory
265   function factory() public view returns (address) {
266     return _factory;
267   }
268 
269   /// @dev check an index whether it's redeemed
270   /// @param eventId_ event ID
271   /// @param index_ index of redemption pre-assigned to user
272   function isRedeemed(uint256 eventId_, uint256 index_) public view returns (bool) {
273     return _eventRedemptions[eventId_][index_];
274   }
275 
276   /// @dev claim the token which user is eligible from schedule
277   /// @param eventId_ event ID
278   /// @param index_ index of redemption pre-assigned to user
279   /// @param recipient_ index of redemption pre-assigned to user
280   /// @param receivingAmount_ amount of *receivingToken* user is eligible to redeem
281   /// @param sendingAmount_ amount of *sendingToken* user must send the contract to get *receivingToken*
282   /// @param proofs additional data to validate that the inputted information is valid
283   function redeem(uint256 eventId_, uint256 index_, address recipient_, uint256 receivingAmount_, uint256 sendingAmount_, bytes32[] calldata proofs) public payable {
284     uint256 fee = IVaultConfig(_factory).fee();
285     uint256 gasLimit = IVaultConfig(_factory).gasLimit();
286     if(fee > 0) {
287       require(_msgValue() == fee, "C98Vault: Invalid fee");
288     }
289 
290     EventData storage eventData = _eventDatas[eventId_];
291     require(eventData.isActive > 0, "C98Vault: Invalid event");
292     require(eventData.timestamp <= block.timestamp, "C98Vault: Schedule locked");
293     require(recipient_ != address(0), "C98Vault: Invalid schedule");
294 
295     bytes32 node = keccak256(abi.encodePacked(index_, recipient_, receivingAmount_, sendingAmount_));
296     require(MerkleProof.verify(proofs, eventData.merkleRoot, node), "C98Vault: Invalid proof");
297     require(!isRedeemed(eventId_, index_), "C98Vault: Redeemed");
298 
299     uint256 availableAmount;
300     if(eventData.receivingToken == address(0)) {
301       availableAmount = address(this).balance;
302     } else {
303       availableAmount = IERC20(eventData.receivingToken).balanceOf(address(this));
304     }
305 
306     require(receivingAmount_ <= availableAmount, "C98Vault: Insufficient token");
307 
308     _setRedemption(eventId_, index_);
309     if(fee > 0) {
310       uint256 reward = IVaultConfig(_factory).ownerReward();
311       uint256 finalFee = fee - reward;
312       (bool success, bytes memory data) = _factory.call{value:finalFee, gas:gasLimit}("");
313       require(success, "C98Vault: Unable to charge fee");
314     }
315     if(sendingAmount_ > 0) {
316       IERC20(eventData.sendingToken).transferFrom(_msgSender(), address(this), sendingAmount_);
317     }
318     if(eventData.receivingToken == address(0)) {
319       recipient_.call{value:receivingAmount_, gas:gasLimit}("");
320     } else {
321       IERC20(eventData.receivingToken).transfer(recipient_, receivingAmount_);
322     }
323 
324     emit Redeemed(eventId_, index_, recipient_, eventData.receivingToken, receivingAmount_, eventData.sendingToken, sendingAmount_);
325   }
326 
327   /// @dev withdraw the token in the vault, no limit
328   /// @param token_ address of the token, use address(0) to withdraw gas token
329   /// @param destination_ recipient address to receive the fund
330   /// @param amount_ amount of fund to withdaw
331   function withdraw(address token_, address destination_, uint256 amount_) public onlyAdmin {
332     require(destination_ != address(0), "C98Vault: Destination is zero address");
333 
334     uint256 availableAmount;
335     if(token_ == address(0)) {
336       availableAmount = address(this).balance;
337     } else {
338       availableAmount = IERC20(token_).balanceOf(address(this));
339     }
340 
341     require(amount_ <= availableAmount, "C98Vault: Not enough balance");
342 
343     uint256 gasLimit = IVaultConfig(_factory).gasLimit();
344     if(token_ == address(0)) {
345       destination_.call{value:amount_, gas:gasLimit}("");
346     } else {
347       IERC20(token_).transfer(destination_, amount_);
348     }
349 
350     emit Withdrawn(_msgSender(), destination_, token_, amount_);
351   }
352 
353   /// @dev withdraw NFT from contract
354   /// @param token_ address of the token, use address(0) to withdraw gas token
355   /// @param destination_ recipient address to receive the fund
356   /// @param tokenId_ ID of NFT to withdraw
357   function withdrawNft(address token_, address destination_, uint256 tokenId_) public onlyAdmin {
358     require(destination_ != address(0), "C98Vault: destination is zero address");
359 
360     IERC721(token_).transferFrom(address(this), destination_, tokenId_);
361 
362     emit Withdrawn(_msgSender(), destination_, token_, 1);
363   }
364 
365   /// @dev create an event to specify how user can claim their token
366   /// @param eventId_ event ID
367   /// @param timestamp_ when the token will be available for redemption
368   /// @param receivingToken_ token user will be receiving, mandatory
369   /// @param sendingToken_ token user need to send in order to receive *receivingToken_*
370   function createEvent(uint256 eventId_, uint256 timestamp_, bytes32 merkleRoot_, address receivingToken_, address sendingToken_) public onlyAdmin {
371     require(_eventDatas[eventId_].timestamp == 0, "C98Vault: Event existed");
372     require(timestamp_ != 0, "C98Vault: Invalid timestamp");
373     _eventDatas[eventId_].timestamp = timestamp_;
374     _eventDatas[eventId_].merkleRoot = merkleRoot_;
375     _eventDatas[eventId_].receivingToken = receivingToken_;
376     _eventDatas[eventId_].sendingToken = sendingToken_;
377     _eventDatas[eventId_].isActive = 1;
378 
379     emit EventCreated(eventId_, _eventDatas[eventId_]);
380   }
381 
382   /// @dev enable/disable a particular event
383   /// @param eventId_ event ID
384   /// @param isActive_ zero to inactive, any number to active
385   function setEventStatus(uint256 eventId_, uint8 isActive_) public onlyAdmin {
386     require(_eventDatas[eventId_].timestamp != 0, "C98Vault: Invalid event");
387     _eventDatas[eventId_].isActive = isActive_;
388 
389     emit EventUpdated(eventId_, isActive_);
390   }
391 
392   /// @dev add/remove admin of the vault.
393   /// @param nAdmins_ list to address to update
394   /// @param nStatuses_ address with same index will be added if true, or remove if false
395   /// admins will have access to all tokens in the vault, and can define vesting schedule
396   function setAdmins(address[] memory nAdmins_, bool[] memory nStatuses_) public onlyOwner {
397     require(nAdmins_.length != 0, "C98Vault: Empty arguments");
398     require(nStatuses_.length != 0, "C98Vault: Empty arguments");
399     require(nAdmins_.length == nStatuses_.length, "C98Vault: Invalid arguments");
400 
401     uint256 i;
402     for(i = 0; i < nAdmins_.length; i++) {
403       address nAdmin = nAdmins_[i];
404       if(nStatuses_[i]) {
405         if(!_adminStatuses[nAdmin]) {
406           _admins.push(nAdmin);
407           _adminStatuses[nAdmin] = nStatuses_[i];
408           emit AdminAdded(nAdmin);
409         }
410       } else {
411         uint256 j;
412         for(j = 0; j < _admins.length; j++) {
413           if(_admins[j] == nAdmin) {
414             _admins[j] = _admins[_admins.length - 1];
415             _admins.pop();
416             delete _adminStatuses[nAdmin];
417             emit AdminRemoved(nAdmin);
418             break;
419           }
420         }
421       }
422     }
423   }
424 }
425 
426 contract Coin98VaultFactory is Ownable, Payable, IVaultConfig {
427 
428   uint256 private _fee;
429   uint256 private _gasLimit;
430   uint256 private _ownerReward;
431   address[] private _vaults;
432 
433   constructor () Ownable(_msgSender()) {
434     _gasLimit = 9000;
435   }
436 
437   /// @dev Emit `FeeUpdated` when a new vault is created
438   event Created(address indexed vault);
439   /// @dev Emit `FeeUpdated` when fee of the protocol is updated
440   event FeeUpdated(uint256 fee);
441   /// @dev Emit `OwnerRewardUpdated` when reward for vault owner is updated
442   event OwnerRewardUpdated(uint256 fee);
443   /// @dev Emit `Withdrawn` when owner withdraw fund from the factory
444   event Withdrawn(address indexed owner, address indexed recipient, address indexed token, uint256 value);
445 
446   /// @dev get current protocol fee in gas token
447   function fee() override external view returns (uint256) {
448     return _fee;
449   }
450 
451   /// @dev limit gas to send native token
452   function gasLimit() override external view returns (uint256) {
453     return _gasLimit;
454   }
455 
456   /// @dev get current owner reward in gas token
457   function ownerReward() override external view returns (uint256) {
458     return _ownerReward;
459   }
460 
461   /// @dev get list of vaults initialized through this factory
462   function vaults() external view returns (address[] memory) {
463     return _vaults;
464   }
465 
466   /// @dev create a new vault
467   /// @param owner_ Owner of newly created vault
468   function createVault(address owner_) external returns (Coin98Vault vault) {
469     vault = new Coin98Vault(address(this), owner_);
470     _vaults.push(address(vault));
471     emit Created(address(vault));
472   }
473 
474   function setGasLimit(uint256 limit_) public onlyOwner {
475     _gasLimit = limit_;
476   }
477 
478   /// @dev change protocol fee
479   /// @param fee_ amount of gas token to charge for every redeem. can be ZERO to disable protocol fee
480   /// @param reward_ amount of gas token to incentive vault owner. this reward will be deduce from protocol fee
481   function setFee(uint256 fee_, uint256 reward_) public onlyOwner {
482     require(fee_ >= reward_, "C98Vault: Invalid reward amount");
483 
484     _fee = fee_;
485     _ownerReward = reward_;
486 
487     emit FeeUpdated(fee_);
488     emit OwnerRewardUpdated(reward_);
489   }
490 
491   /// @dev withdraw fee collected for protocol
492   /// @param token_ address of the token, use address(0) to withdraw gas token
493   /// @param destination_ recipient address to receive the fund
494   /// @param amount_ amount of fund to withdaw
495   function withdraw(address token_, address destination_, uint256 amount_) public onlyOwner {
496     require(destination_ != address(0), "C98Vault: Destination is zero address");
497 
498     uint256 availableAmount;
499     if(token_ == address(0)) {
500       availableAmount = address(this).balance;
501     } else {
502       availableAmount = IERC20(token_).balanceOf(address(this));
503     }
504 
505     require(amount_ <= availableAmount, "C98Vault: Not enough balance");
506 
507     if(token_ == address(0)) {
508       destination_.call{value:amount_, gas:_gasLimit}("");
509     } else {
510       IERC20(token_).transfer(destination_, amount_);
511     }
512 
513     emit Withdrawn(_msgSender(), destination_, token_, amount_);
514   }
515 
516   /// @dev withdraw NFT from contract
517   /// @param token_ address of the token, use address(0) to withdraw gas token
518   /// @param destination_ recipient address to receive the fund
519   /// @param tokenId_ ID of NFT to withdraw
520   function withdrawNft(address token_, address destination_, uint256 tokenId_) public onlyOwner {
521     require(destination_ != address(0), "C98Vault: destination is zero address");
522 
523     IERC721(token_).transferFrom(address(this), destination_, tokenId_);
524 
525     emit Withdrawn(_msgSender(), destination_, token_, 1);
526   }
527 }