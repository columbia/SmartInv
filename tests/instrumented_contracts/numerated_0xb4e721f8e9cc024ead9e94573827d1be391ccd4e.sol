1 // File: contracts/interface/ISkvllpvnkz.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 interface ISkvllpvnkz {
7     function walletOfOwner(address _owner) external view returns(uint256[] memory);
8     function balanceOf(address owner) external view returns (uint256 balance);
9     function ownerOf(uint256 tokenId) external view returns (address owner);
10 }
11 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
12 
13 
14 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Interface of the ERC20 standard as defined in the EIP.
20  */
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
97 
98 
99 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Contract module that helps prevent reentrant calls to a function.
105  *
106  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
107  * available, which can be applied to functions to make sure there are no nested
108  * (reentrant) calls to them.
109  *
110  * Note that because there is a single `nonReentrant` guard, functions marked as
111  * `nonReentrant` may not call one another. This can be worked around by making
112  * those functions `private`, and then adding `external` `nonReentrant` entry
113  * points to them.
114  *
115  * TIP: If you would like to learn more about reentrancy and alternative ways
116  * to protect against it, check out our blog post
117  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
118  */
119 abstract contract ReentrancyGuard {
120     // Booleans are more expensive than uint256 or any type that takes up a full
121     // word because each write operation emits an extra SLOAD to first read the
122     // slot's contents, replace the bits taken up by the boolean, and then write
123     // back. This is the compiler's defense against contract upgrades and
124     // pointer aliasing, and it cannot be disabled.
125 
126     // The values being non-zero value makes deployment a bit more expensive,
127     // but in exchange the refund on every call to nonReentrant will be lower in
128     // amount. Since refunds are capped to a percentage of the total
129     // transaction's gas, it is best to keep them low in cases like this one, to
130     // increase the likelihood of the full refund coming into effect.
131     uint256 private constant _NOT_ENTERED = 1;
132     uint256 private constant _ENTERED = 2;
133 
134     uint256 private _status;
135 
136     constructor() {
137         _status = _NOT_ENTERED;
138     }
139 
140     /**
141      * @dev Prevents a contract from calling itself, directly or indirectly.
142      * Calling a `nonReentrant` function from another `nonReentrant`
143      * function is not supported. It is possible to prevent this from happening
144      * by making the `nonReentrant` function external, and making it call a
145      * `private` function that does the actual work.
146      */
147     modifier nonReentrant() {
148         // On the first call to nonReentrant, _notEntered will be true
149         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
150 
151         // Any calls to nonReentrant after this point will fail
152         _status = _ENTERED;
153 
154         _;
155 
156         // By storing the original value once again, a refund is triggered (see
157         // https://eips.ethereum.org/EIPS/eip-2200)
158         _status = _NOT_ENTERED;
159     }
160 }
161 
162 // File: @openzeppelin/contracts/utils/Context.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @dev Provides information about the current execution context, including the
171  * sender of the transaction and its data. While these are generally available
172  * via msg.sender and msg.data, they should not be accessed in such a direct
173  * manner, since when dealing with meta-transactions the account sending and
174  * paying for execution may not be the actual sender (as far as an application
175  * is concerned).
176  *
177  * This contract is only required for intermediate, library-like contracts.
178  */
179 abstract contract Context {
180     function _msgSender() internal view virtual returns (address) {
181         return msg.sender;
182     }
183 
184     function _msgData() internal view virtual returns (bytes calldata) {
185         return msg.data;
186     }
187 }
188 
189 // File: @openzeppelin/contracts/access/Ownable.sol
190 
191 
192 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
193 
194 pragma solidity ^0.8.0;
195 
196 
197 /**
198  * @dev Contract module which provides a basic access control mechanism, where
199  * there is an account (an owner) that can be granted exclusive access to
200  * specific functions.
201  *
202  * By default, the owner account will be the one that deploys the contract. This
203  * can later be changed with {transferOwnership}.
204  *
205  * This module is used through inheritance. It will make available the modifier
206  * `onlyOwner`, which can be applied to your functions to restrict their use to
207  * the owner.
208  */
209 abstract contract Ownable is Context {
210     address private _owner;
211 
212     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214     /**
215      * @dev Initializes the contract setting the deployer as the initial owner.
216      */
217     constructor() {
218         _transferOwnership(_msgSender());
219     }
220 
221     /**
222      * @dev Returns the address of the current owner.
223      */
224     function owner() public view virtual returns (address) {
225         return _owner;
226     }
227 
228     /**
229      * @dev Throws if called by any account other than the owner.
230      */
231     modifier onlyOwner() {
232         require(owner() == _msgSender(), "Ownable: caller is not the owner");
233         _;
234     }
235 
236     /**
237      * @dev Leaves the contract without owner. It will not be possible to call
238      * `onlyOwner` functions anymore. Can only be called by the current owner.
239      *
240      * NOTE: Renouncing ownership will leave the contract without an owner,
241      * thereby removing any functionality that is only available to the owner.
242      */
243     function renounceOwnership() public virtual onlyOwner {
244         _transferOwnership(address(0));
245     }
246 
247     /**
248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
249      * Can only be called by the current owner.
250      */
251     function transferOwnership(address newOwner) public virtual onlyOwner {
252         require(newOwner != address(0), "Ownable: new owner is the zero address");
253         _transferOwnership(newOwner);
254     }
255 
256     /**
257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
258      * Internal function without access restriction.
259      */
260     function _transferOwnership(address newOwner) internal virtual {
261         address oldOwner = _owner;
262         _owner = newOwner;
263         emit OwnershipTransferred(oldOwner, newOwner);
264     }
265 }
266 
267 // File: contracts/HideoutRewards.sol
268 
269 //SPDX-License-Identifier: MIT
270 pragma solidity ^0.8.0;
271 
272 
273 
274 
275 
276 contract HideoutRewards is Ownable, ReentrancyGuard {
277 
278     event RewardCollected(address owner, uint256 skvllpvnkId, uint256 amount);
279     event HideoutRewardsOpen();
280     event HideoutRewardsClosed();
281 
282     IERC20 private AMMO = IERC20(0xBcB6112292a9EE9C9cA876E6EAB0FeE7622445F1);
283     ISkvllpvnkz private SkvllpvnkzHideout = ISkvllpvnkz(0xB28a4FdE7B6c3Eb0C914d7b4d3ddb4544c3bcbd6);
284 
285     uint256 public constant START_TIMESTAMP = 1631142000; // 09-09-2021
286     uint256 public constant REWARD_PER_DAY = 2*10**18;
287     uint256 public constant REWARD_PER_SEC = REWARD_PER_DAY / 86400;
288 
289     bool public isHideoutRewardsOpen = false;
290 
291     mapping(uint256 => uint256) private skvllpvnkz;
292 
293     struct Report{
294         uint256 id;
295         address owner;
296         uint256 lastClaimTimestamp;
297         uint256 unclaimedRewards;
298     }
299 
300     modifier hideoutRewardsOpen {
301         require( isHideoutRewardsOpen, "Hideout Rewards is closed" );
302         _;
303     }
304 
305     function setTreasuryContract(address _address) external onlyOwner{
306         AMMO = IERC20(_address);
307     }
308 
309     function setSkvllpvnkzContract(address _address) external onlyOwner{
310         SkvllpvnkzHideout = ISkvllpvnkz(_address);
311     }
312 
313     function getBatchPendingRewards(uint64[] memory skvllpvnkIds) external view returns(Report[] memory) {
314         Report[] memory allRewards = new Report[](skvllpvnkIds.length);
315         for (uint64 i = 0; i < skvllpvnkIds.length; i++){
316             allRewards[i] = 
317                 Report(
318                     skvllpvnkIds[i],
319                     SkvllpvnkzHideout.ownerOf(skvllpvnkIds[i]),
320                     skvllpvnkz[skvllpvnkIds[i]] == 0 
321                         ? START_TIMESTAMP 
322                         : skvllpvnkz[skvllpvnkIds[i]], 
323                     _calculateRewards(skvllpvnkIds[i], block.timestamp));
324         }
325         return allRewards;
326     }
327 
328     function getWalletReport(address wallet) external view returns(Report[] memory) {
329         uint256[] memory skvllpvnkIds = SkvllpvnkzHideout.walletOfOwner(wallet);
330         Report[] memory report = new Report[](skvllpvnkIds.length);
331         uint256 rewardTimestamp = block.timestamp;
332         for (uint64 i = 0; i < skvllpvnkIds.length; i++){
333             report[i] = 
334                 Report(
335                     skvllpvnkIds[i],
336                     wallet,
337                     skvllpvnkz[skvllpvnkIds[i]] == 0 
338                     ? START_TIMESTAMP 
339                     : skvllpvnkz[skvllpvnkIds[i]], 
340                     _calculateRewards(skvllpvnkIds[i], rewardTimestamp));
341         }
342         return report;
343     }
344 
345     function collectRewards(uint256[] memory skvllpvnkIds) public hideoutRewardsOpen nonReentrant {
346         uint256 rewardTimestamp = block.timestamp;
347         uint256 rewardAmount = 0; 
348         for (uint256 i; i < skvllpvnkIds.length; i++){     
349             require(SkvllpvnkzHideout.ownerOf(skvllpvnkIds[i]) == msg.sender, "You do not own this Skvllpvnk");
350             rewardAmount += _calculateRewards(skvllpvnkIds[i], rewardTimestamp);
351             skvllpvnkz[skvllpvnkIds[i]] = rewardTimestamp;
352             emit RewardCollected( msg.sender, skvllpvnkIds[i], rewardAmount);
353         }
354         _releasePayment(rewardAmount);
355     }
356 
357     function _calculateRewards(uint256 skvllpvnkId, uint256 currentTime) internal view returns (uint256){
358         uint256 startTime = skvllpvnkz[skvllpvnkId] == 0 ? START_TIMESTAMP : skvllpvnkz[skvllpvnkId];
359         return (currentTime - startTime) * REWARD_PER_SEC;
360     }
361 
362     function _releasePayment(uint256 rewardAmount) internal {
363         require(rewardAmount > 0, "Nothing to collect");
364         require(AMMO.balanceOf(address(this)) >= rewardAmount, "Not enough AMMO");
365         AMMO.approve(address(this), rewardAmount); 
366         AMMO.transfer(msg.sender, rewardAmount);
367     }
368 
369     function openCloseHideout() external onlyOwner {
370         isHideoutRewardsOpen = !isHideoutRewardsOpen;
371     }
372 
373 }