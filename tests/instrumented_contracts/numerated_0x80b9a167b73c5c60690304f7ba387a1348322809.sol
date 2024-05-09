1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor() {
22         _transferOwnership(_msgSender());
23     }
24 
25     modifier onlyOwner() {
26         _checkOwner();
27         _;
28     }
29 
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     function _checkOwner() internal view virtual {
35         require(owner() == _msgSender(), "Ownable: caller is not the owner");
36     }
37 
38     function renounceOwnership() public virtual onlyOwner {
39         _transferOwnership(address(0));
40     }
41 
42     function transferOwnership(address newOwner) public virtual onlyOwner {
43         require(newOwner != address(0), "Ownable: new owner is the zero address");
44         _transferOwnership(newOwner);
45     }
46 
47     function _transferOwnership(address newOwner) internal virtual {
48         address oldOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(oldOwner, newOwner);
51     }
52 }
53 
54 abstract contract ReentrancyGuard {
55 
56     uint256 private constant _NOT_ENTERED = 1;
57     uint256 private constant _ENTERED = 2;
58 
59     uint256 private _status;
60 
61     constructor() {
62         _status = _NOT_ENTERED;
63     }
64 
65     modifier nonReentrant() {
66         _nonReentrantBefore();
67         _;
68         _nonReentrantAfter();
69     }
70 
71     function _nonReentrantBefore() private {
72         // On the first call to nonReentrant, _notEntered will be true
73         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
74 
75         // Any calls to nonReentrant after this point will fail
76         _status = _ENTERED;
77     }
78 
79     function _nonReentrantAfter() private {
80         // By storing the original value once again, a refund is triggered (see
81         // https://eips.ethereum.org/EIPS/eip-2200)
82         _status = _NOT_ENTERED;
83     }
84 }
85 
86 
87 interface IERC20 {
88 
89     event Transfer(address indexed from, address indexed to, uint256 value);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 
92     function decimals() external view returns (uint8);
93     function totalSupply() external view returns (uint256);
94     function balanceOf(address account) external view returns (uint256);
95     function transfer(address to, uint256 amount) external returns (bool);
96     function allowance(address owner, address spender) external view returns (uint256);
97     function approve(address spender, uint256 amount) external returns (bool);
98     function transferFrom(
99         address from,
100         address to,
101         uint256 amount
102     ) external returns (bool);
103 }
104 
105 interface IERC20Permit {
106     
107     function permit(
108         address owner,
109         address spender,
110         uint256 value,
111         uint256 deadline,
112         uint8 v,
113         bytes32 r,
114         bytes32 s
115     ) external;
116 
117     function nonces(address owner) external view returns (uint256);
118     function DOMAIN_SEPARATOR() external view returns (bytes32);
119 }
120 
121 interface IERC165 {
122     /**
123      * @dev Returns true if this contract implements the interface defined by
124      * `interfaceId`. See the corresponding
125      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
126      * to learn more about how these ids are created.
127      *
128      * This function call must use less than 30 000 gas.
129      */
130     function supportsInterface(bytes4 interfaceId) external view returns (bool);
131 }
132 
133 library Address {
134     
135     function isContract(address account) internal view returns (bool) {
136         // This method relies on extcodesize/address.code.length, which returns 0
137         // for contracts in construction, since the code is only stored at the end
138         // of the constructor execution.
139 
140         return account.code.length > 0;
141     }
142 
143     function sendValue(address payable recipient, uint256 amount) internal {
144         require(address(this).balance >= amount, "Address: insufficient balance");
145 
146         (bool success, ) = recipient.call{value: amount}("");
147         require(success, "Address: unable to send value, recipient may have reverted");
148     }
149 
150     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
151         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
152     }
153 
154     function functionCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal returns (bytes memory) {
159         return functionCallWithValue(target, data, 0, errorMessage);
160     }
161 
162     function functionCallWithValue(
163         address target,
164         bytes memory data,
165         uint256 value
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
168     }
169 
170     function functionCallWithValue(
171         address target,
172         bytes memory data,
173         uint256 value,
174         string memory errorMessage
175     ) internal returns (bytes memory) {
176         require(address(this).balance >= value, "Address: insufficient balance for call");
177         (bool success, bytes memory returndata) = target.call{value: value}(data);
178         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
179     }
180 
181     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
182         return functionStaticCall(target, data, "Address: low-level static call failed");
183     }
184 
185     function functionStaticCall(
186         address target,
187         bytes memory data,
188         string memory errorMessage
189     ) internal view returns (bytes memory) {
190         (bool success, bytes memory returndata) = target.staticcall(data);
191         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
192     }
193 
194     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
195         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
196     }
197 
198     function functionDelegateCall(
199         address target,
200         bytes memory data,
201         string memory errorMessage
202     ) internal returns (bytes memory) {
203         (bool success, bytes memory returndata) = target.delegatecall(data);
204         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
205     }
206 
207     function verifyCallResultFromTarget(
208         address target,
209         bool success,
210         bytes memory returndata,
211         string memory errorMessage
212     ) internal view returns (bytes memory) {
213         if (success) {
214             if (returndata.length == 0) {
215                 // only check isContract if the call was successful and the return data is empty
216                 // otherwise we already know that it was a contract
217                 require(isContract(target), "Address: call to non-contract");
218             }
219             return returndata;
220         } else {
221             _revert(returndata, errorMessage);
222         }
223     }
224 
225     function verifyCallResult(
226         bool success,
227         bytes memory returndata,
228         string memory errorMessage
229     ) internal pure returns (bytes memory) {
230         if (success) {
231             return returndata;
232         } else {
233             _revert(returndata, errorMessage);
234         }
235     }
236 
237     function _revert(bytes memory returndata, string memory errorMessage) private pure {
238         // Look for revert reason and bubble it up if present
239         if (returndata.length > 0) {
240             // The easiest way to bubble the revert reason is using memory via assembly
241             /// @solidity memory-safe-assembly
242             assembly {
243                 let returndata_size := mload(returndata)
244                 revert(add(32, returndata), returndata_size)
245             }
246         } else {
247             revert(errorMessage);
248         }
249     }
250 }
251 
252 
253 library SafeERC20 {
254     using Address for address;
255 
256     function safeTransfer(
257         IERC20 token,
258         address to,
259         uint256 value
260     ) internal {
261         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
262     }
263 
264     function safeTransferFrom(
265         IERC20 token,
266         address from,
267         address to,
268         uint256 value
269     ) internal {
270         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
271     }
272 
273     function safeApprove(
274         IERC20 token,
275         address spender,
276         uint256 value
277     ) internal {
278         // safeApprove should only be called when setting an initial allowance,
279         // or when resetting it to zero. To increase and decrease it, use
280         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
281         require(
282             (value == 0) || (token.allowance(address(this), spender) == 0),
283             "SafeERC20: approve from non-zero to non-zero allowance"
284         );
285         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
286     }
287 
288     function safeIncreaseAllowance(
289         IERC20 token,
290         address spender,
291         uint256 value
292     ) internal {
293         uint256 newAllowance = token.allowance(address(this), spender) + value;
294         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
295     }
296 
297     function safeDecreaseAllowance(
298         IERC20 token,
299         address spender,
300         uint256 value
301     ) internal {
302         unchecked {
303             uint256 oldAllowance = token.allowance(address(this), spender);
304             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
305             uint256 newAllowance = oldAllowance - value;
306             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
307         }
308     }
309 
310     function safePermit(
311         IERC20Permit token,
312         address owner,
313         address spender,
314         uint256 value,
315         uint256 deadline,
316         uint8 v,
317         bytes32 r,
318         bytes32 s
319     ) internal {
320         uint256 nonceBefore = token.nonces(owner);
321         token.permit(owner, spender, value, deadline, v, r, s);
322         uint256 nonceAfter = token.nonces(owner);
323         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
324     }
325 
326     function _callOptionalReturn(IERC20 token, bytes memory data) private {
327         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
328         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
329         // the target address contains contract code and also asserts for success in the low-level call.
330 
331         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
332         if (returndata.length > 0) {
333             // Return data is optional
334             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
335         }
336     }
337 }
338 
339 interface IERC721 is IERC165 {
340 
341     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
342     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
343     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
344 
345     function balanceOf(address owner) external view returns (uint256 balance);
346     function ownerOf(uint256 tokenId) external view returns (address owner);
347     function safeTransferFrom(
348         address from,
349         address to,
350         uint256 tokenId,
351         bytes calldata data
352     ) external;
353 
354     function safeTransferFrom(
355         address from,
356         address to,
357         uint256 tokenId
358     ) external;
359 
360     function transferFrom(
361         address from,
362         address to,
363         uint256 tokenId
364     ) external;
365 
366     function approve(address to, uint256 tokenId) external;
367     function setApprovalForAll(address operator, bool _approved) external;
368     function getApproved(uint256 tokenId) external view returns (address operator);
369     function isApprovedForAll(address owner, address operator) external view returns (bool);
370 }
371 
372 
373 contract ERC721Staking is Ownable, ReentrancyGuard {
374     using SafeERC20 for IERC20;
375 
376     // Interfaces for ERC20 and ERC721
377     IERC20 public immutable rewardsToken;
378     IERC721 public immutable nftCollection;
379 
380     uint256 public bonusEndTimestamp = 1677268800;
381 
382     event BonusEndTimestampUpdated(uint256 oldBonusEndTimestamp, uint256 newBonusEndTimestamp);
383     event RewardsPerHourUpdated(uint256 oldRewardsPerHour, uint256 newRewardsPerHour);
384 
385     // Constructor function to set the rewards token and the NFT collection addresses
386     constructor(IERC721 _nftCollection, IERC20 _rewardsToken) {
387         nftCollection = _nftCollection;
388         rewardsToken = _rewardsToken;
389     }
390 
391     struct StakedToken {
392         address staker;
393         uint256 tokenId;
394     }
395     
396     // Staker info
397     struct Staker {
398         // Amount of tokens staked by the staker
399         uint256 amountStaked;
400 
401         // Staked token ids
402         StakedToken[] stakedTokens;
403 
404         // Last time of the rewards were calculated for this user
405         uint256 timeOfLastUpdate;
406 
407         // Calculated, but unclaimed rewards for the User. The rewards are
408         // calculated each time the user writes to the Smart Contract
409         uint256 unclaimedRewards;
410     }
411 
412     // Rewards per hour per token deposited in wei.
413     uint256 public rewardsPerHour = 613181151618000000000;
414 
415     // Mapping of User Address to Staker info
416     mapping(address => Staker) public stakers;
417 
418     // Mapping of Token Id to staker. Made for the SC to remeber
419     // who to send back the ERC721 Token to.
420     mapping(uint256 => address) public stakerAddress;
421 
422     // If address already has ERC721 Token/s staked, calculate the rewards.
423     // Increment the amountStaked and map msg.sender to the Token Id of the staked
424     // Token to later send back on withdrawal. Finally give timeOfLastUpdate the
425     // value of now.
426     function stake(uint256 _tokenId) external nonReentrant {
427         // If wallet has tokens staked, calculate the rewards before adding the new token
428         if (stakers[msg.sender].amountStaked > 0) {
429             uint256 rewards = calculateRewards(msg.sender);
430             stakers[msg.sender].unclaimedRewards += rewards;
431         }
432 
433         // Wallet must own the token they are trying to stake
434         require(
435             nftCollection.ownerOf(_tokenId) == msg.sender,
436             "You don't own this token!"
437         );
438 
439         // Transfer the token from the wallet to the Smart contract
440         nftCollection.transferFrom(msg.sender, address(this), _tokenId);
441 
442         // Create StakedToken
443         StakedToken memory stakedToken = StakedToken(msg.sender, _tokenId);
444 
445         // Add the token to the stakedTokens array
446         stakers[msg.sender].stakedTokens.push(stakedToken);
447 
448         // Increment the amount staked for this wallet
449         stakers[msg.sender].amountStaked++;
450 
451         // Update the mapping of the tokenId to the staker's address
452         stakerAddress[_tokenId] = msg.sender;
453 
454         // Update the timeOfLastUpdate for the staker   
455         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
456     }
457     
458     // Check if user has any ERC721 Tokens Staked and if they tried to withdraw,
459     // calculate the rewards and store them in the unclaimedRewards
460     // decrement the amountStaked of the user and transfer the ERC721 token back to them
461     function withdraw(uint256 _tokenId) external nonReentrant {
462         require(block.timestamp >= bonusEndTimestamp, "NFTs are locked");
463         // Make sure the user has at least one token staked before withdrawing
464         require(
465             stakers[msg.sender].amountStaked > 0,
466             "You have no tokens staked"
467         );
468         
469         // Wallet must own the token they are trying to withdraw
470         require(stakerAddress[_tokenId] == msg.sender, "You don't own this token!");
471 
472         // Update the rewards for this user, as the amount of rewards decreases with less tokens.
473         uint256 rewards = calculateRewards(msg.sender);
474         stakers[msg.sender].unclaimedRewards += rewards;
475 
476         // Find the index of this token id in the stakedTokens array
477         uint256 index = 0;
478         for (uint256 i = 0; i < stakers[msg.sender].stakedTokens.length; i++) {
479             if (
480                 stakers[msg.sender].stakedTokens[i].tokenId == _tokenId 
481                 && 
482                 stakers[msg.sender].stakedTokens[i].staker != address(0)
483             ) {
484                 index = i;
485                 break;
486             }
487         }
488 
489         // Set this token's .staker to be address 0 to mark it as no longer staked
490         stakers[msg.sender].stakedTokens[index].staker = address(0);
491 
492         // Decrement the amount staked for this wallet
493         stakers[msg.sender].amountStaked--;
494 
495         // Update the mapping of the tokenId to the be address(0) to indicate that the token is no longer staked
496         stakerAddress[_tokenId] = address(0);
497 
498         // Transfer the token back to the withdrawer
499         nftCollection.transferFrom(address(this), msg.sender, _tokenId);
500 
501         // Update the timeOfLastUpdate for the withdrawer   
502         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
503     }
504 
505     // Calculate rewards for the msg.sender, check if there are any rewards
506     // claim, set unclaimedRewards to 0 and transfer the ERC20 Reward token
507     // to the user.
508     function claimRewards() external {
509         uint256 rewards = calculateRewards(msg.sender) +
510             stakers[msg.sender].unclaimedRewards;
511         require(rewards > 0, "You have no rewards to claim");
512         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
513         stakers[msg.sender].unclaimedRewards = 0;
514         rewardsToken.safeTransfer(msg.sender, rewards);
515     }
516 
517 
518     //////////
519     // View //
520     //////////
521 
522     function availableRewards(address _staker) public view returns (uint256) {
523         uint256 rewards = calculateRewards(_staker) +
524             stakers[_staker].unclaimedRewards;
525         return rewards;
526     }
527 
528     function getStakedTokens(address _user) public view returns (uint256[] memory) {
529         // Check if we know this user
530         if (stakers[_user].amountStaked > 0) {
531             // Return all the tokens in the stakedToken Array for this user that are not -1
532             uint256[] memory _stakedTokens = new uint256[](stakers[_user].amountStaked);
533             uint256 _index = 0;
534 
535             for (uint256 j = 0; j < stakers[_user].stakedTokens.length; j++) {
536                 if (stakers[_user].stakedTokens[j].staker != (address(0))) {
537                     _stakedTokens[_index] = stakers[_user].stakedTokens[j].tokenId;
538                     _index++;
539                 }
540             }
541 
542             return _stakedTokens;
543         }
544         
545         // Otherwise, return empty array
546         else {
547             return new uint256[](0);
548         }
549     }
550 
551     function updateBonusEndTimestamp(uint256 timestamp) external onlyOwner {
552         uint256 oldBonusEndTimestamp = bonusEndTimestamp;
553         bonusEndTimestamp = timestamp;
554 
555         emit BonusEndTimestampUpdated(oldBonusEndTimestamp, timestamp);
556     }
557 
558     function emergencyWithdraw(IERC20 token, uint256 amount) external onlyOwner {
559         token.safeTransfer(owner(), amount);
560     }
561 
562     function updateRewardPerHour(uint256 newRewardsPerHour) external onlyOwner {
563         uint256 oldRewardsPerHour = rewardsPerHour;
564         rewardsPerHour = newRewardsPerHour;
565 
566         emit RewardsPerHourUpdated(oldRewardsPerHour, newRewardsPerHour);
567     }
568 
569     /////////////
570     // Internal//
571     /////////////
572 
573     // Calculate rewards for param _staker by calculating the time passed
574     // since last update in hours and mulitplying it to ERC721 Tokens Staked
575     // and rewardsPerHour.
576     function calculateRewards(address _staker)
577         internal
578         view
579         returns (uint256 _rewards)
580     {
581         if (block.timestamp <= bonusEndTimestamp)
582             return (((
583                 ((block.timestamp - stakers[_staker].timeOfLastUpdate) *
584                     stakers[_staker].amountStaked)
585             ) * rewardsPerHour) / 3600);
586         
587         else if(stakers[_staker].timeOfLastUpdate >= bonusEndTimestamp) {
588             return 0;
589         }
590         return (((
591             ((bonusEndTimestamp - stakers[_staker].timeOfLastUpdate) *
592                 stakers[_staker].amountStaked)
593         ) * rewardsPerHour) / 3600);
594     }
595 }