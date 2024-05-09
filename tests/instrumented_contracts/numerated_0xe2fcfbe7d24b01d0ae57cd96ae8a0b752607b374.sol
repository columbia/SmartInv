1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/utils/Context.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Provides information about the current execution context, including the
95  * sender of the transaction and its data. While these are generally available
96  * via msg.sender and msg.data, they should not be accessed in such a direct
97  * manner, since when dealing with meta-transactions the account sending and
98  * paying for execution may not be the actual sender (as far as an application
99  * is concerned).
100  *
101  * This contract is only required for intermediate, library-like contracts.
102  */
103 abstract contract Context {
104     function _msgSender() internal view virtual returns (address) {
105         return msg.sender;
106     }
107 
108     function _msgData() internal view virtual returns (bytes calldata) {
109         return msg.data;
110     }
111 }
112 
113 // File: @openzeppelin/contracts/access/Ownable.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 
121 /**
122  * @dev Contract module which provides a basic access control mechanism, where
123  * there is an account (an owner) that can be granted exclusive access to
124  * specific functions.
125  *
126  * By default, the owner account will be the one that deploys the contract. This
127  * can later be changed with {transferOwnership}.
128  *
129  * This module is used through inheritance. It will make available the modifier
130  * `onlyOwner`, which can be applied to your functions to restrict their use to
131  * the owner.
132  */
133 abstract contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     /**
139      * @dev Initializes the contract setting the deployer as the initial owner.
140      */
141     constructor() {
142         _transferOwnership(_msgSender());
143     }
144 
145     /**
146      * @dev Throws if called by any account other than the owner.
147      */
148     modifier onlyOwner() {
149         _checkOwner();
150         _;
151     }
152 
153     /**
154      * @dev Returns the address of the current owner.
155      */
156     function owner() public view virtual returns (address) {
157         return _owner;
158     }
159 
160     /**
161      * @dev Throws if the sender is not the owner.
162      */
163     function _checkOwner() internal view virtual {
164         require(owner() == _msgSender(), "Ownable: caller is not the owner");
165     }
166 
167     /**
168      * @dev Leaves the contract without owner. It will not be possible to call
169      * `onlyOwner` functions anymore. Can only be called by the current owner.
170      *
171      * NOTE: Renouncing ownership will leave the contract without an owner,
172      * thereby removing any functionality that is only available to the owner.
173      */
174     function renounceOwnership() public virtual onlyOwner {
175         _transferOwnership(address(0));
176     }
177 
178     /**
179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
180      * Can only be called by the current owner.
181      */
182     function transferOwnership(address newOwner) public virtual onlyOwner {
183         require(newOwner != address(0), "Ownable: new owner is the zero address");
184         _transferOwnership(newOwner);
185     }
186 
187     /**
188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
189      * Internal function without access restriction.
190      */
191     function _transferOwnership(address newOwner) internal virtual {
192         address oldOwner = _owner;
193         _owner = newOwner;
194         emit OwnershipTransferred(oldOwner, newOwner);
195     }
196 }
197 
198 // File: contracts/WCAClaimableTokensAggregator.sol
199 
200 //SPDX-License-Identifier: MIT
201 pragma solidity ^0.8.17;
202 
203 
204 
205 contract WCAClaimableTokensAggregator is Ownable {
206 	IERC20 public Token;
207 	IWCARestake public Restake;
208 	IWCAWhitelist public Whitelist;
209 	IWCAICO public ICO;
210 	IWCAMundialStaking public MundialStaking;
211 	IWCAMundialRewards public MundialRewards;
212 	IWCADAOLocking public WCADAOLocking;
213 
214 	string public constant version = "0.5";
215 
216 	uint256 public startDate = 1687255200; // 20-06-2023 10:00:00 UTC
217 	uint256 public emissionRate = 763889; // 0.66% per day
218 	uint256 public emissionRateScale = 1e11;
219 	mapping(address => uint256) public userToClaimedTokens;
220 
221 	constructor(
222 		address _Token,
223 		address _Restake,
224 		address _Whitelist,
225 		address _ICO,
226 		address _MundialStaking,
227 		address _MundialRewards,
228 		address _WCADAOLocking
229 	) {
230 		Token = IERC20(_Token);
231 		Restake = IWCARestake(_Restake);
232 		Whitelist = IWCAWhitelist(_Whitelist);
233 		ICO = IWCAICO(_ICO);
234 		MundialStaking = IWCAMundialStaking(_MundialStaking);
235 		MundialRewards = IWCAMundialRewards(_MundialRewards);
236 		WCADAOLocking = IWCADAOLocking(_WCADAOLocking);
237 	}
238 
239 	function setAddresses(
240 		address _Token,
241 		address _Restake,
242 		address _Whitelist,
243 		address _ICO,
244 		address _MundialStaking,
245 		address _MundialRewards,
246 		address _WCADAOLocking
247 	) external onlyOwner {
248 		Token = IERC20(_Token);
249 		Restake = IWCARestake(_Restake);
250 		Whitelist = IWCAWhitelist(_Whitelist);
251 		ICO = IWCAICO(_ICO);
252 		MundialStaking = IWCAMundialStaking(_MundialStaking);
253 		MundialRewards = IWCAMundialRewards(_MundialRewards);
254 		WCADAOLocking = IWCADAOLocking(_WCADAOLocking);
255 	}
256 
257 	function setStartDate(uint256 _startDate) external onlyOwner {
258 		startDate = _startDate;
259 	}
260 
261 	function setEmissionRate(uint256 _emissionRate) external onlyOwner {
262 		emissionRate = _emissionRate;
263 	}
264 
265 	function setEmissionRateScale(uint256 _emissionRateScale) external onlyOwner {
266 		emissionRateScale = _emissionRateScale;
267 	}
268 
269 	function balanceOf(address _address) external view returns (uint256) {
270 		return Token.balanceOf(_address) + Restake.getTotalClaimable(_address) + Whitelist.getTotalClaimable(_address) + ICO.getTotalClaimable(_address) + getMundialStakingAvailableRewards(_address) + MundialRewards.getAvailableTokens(_address) + WCADAOLocking.getLockedTokensFromWallet(_address) - userToClaimedTokens[_address];
271 	}
272 
273 	function stakedBalanceOf(address _address) external view returns (uint256) {
274 		return Restake.getTotalClaimable(_address) + Whitelist.getTotalClaimable(_address) + ICO.getTotalClaimable(_address) + getMundialStakingAvailableRewards(_address) + MundialRewards.getAvailableTokens(_address) + WCADAOLocking.getLockedTokensFromWallet(_address) - userToClaimedTokens[_address];
275 	}
276 
277 	function leftToClaimBalanceOf(address _address) external view returns (uint256) {
278 		uint256 count = Restake.getTotalClaimable(_address) + Whitelist.getTotalClaimable(_address) + ICO.getTotalClaimable(_address) + getMundialStakingAvailableRewards(_address) + MundialRewards.getAvailableTokens(_address) - WCADAOLocking.getLockedTokensFromStaking(_address) - userToClaimedTokens[_address];
279 		return count;
280 	}
281 
282 	function claimableBalanceOf(address _address) public view returns (uint256) {
283 		if (block.timestamp < startDate) {
284 			return 0;
285 		}
286 
287 		uint256 restake = Restake.getTotalClaimable(_address);
288 		uint256 whitelist = Whitelist.getTotalClaimable(_address);
289 		uint256 ico = ICO.getTotalClaimable(_address);
290 		uint256 mundialStaking = getMundialStakingAvailableRewards(_address);
291 		uint256 mundialRewards = MundialRewards.getAvailableTokens(_address);
292 		uint256 lockedFromStaking = WCADAOLocking.getLockedTokensFromStaking(_address);
293 		
294 		uint256 total = restake + whitelist + ico + mundialStaking + mundialRewards;
295 		if(total == 0 || total < lockedFromStaking) {
296 			return 0;
297 		}
298 		total -= lockedFromStaking;
299 
300 		uint256 claimable = (emissionRate * total * (block.timestamp - startDate)) / (emissionRateScale * 100);
301 		if(claimable > total) {
302 			claimable = total;
303 		}
304 		if(claimable < userToClaimedTokens[_address]) {
305 			return 0;
306 		}
307 		return claimable - userToClaimedTokens[_address];
308 	}
309 
310 	function subdividedBalanceOf(address _address)
311 		external
312 		view
313 		returns (
314 			uint256 tokensOnWallet,
315 			uint256 restake,
316 			uint256 whitelist,
317 			uint256 ico,
318 			uint256 mundialStaking,
319 			uint256 promoRewards,
320 			uint256 lockedFromStaking,
321 			uint256 lockedFromWallet,
322 			uint256 alreadyClaimed
323 		)
324 	{
325 		tokensOnWallet = Token.balanceOf(_address);
326 		restake = Restake.getTotalClaimable(_address);
327 		whitelist = Whitelist.getTotalClaimable(_address);
328 		ico = ICO.getTotalClaimable(_address);
329 		mundialStaking = getMundialStakingAvailableRewards(_address);
330 		promoRewards = MundialRewards.getAvailableTokens(_address);
331 		lockedFromStaking = WCADAOLocking.getLockedTokensFromStaking(_address);
332 		lockedFromWallet = WCADAOLocking.getLockedTokensFromWallet(_address);
333 		alreadyClaimed = userToClaimedTokens[_address];
334 
335 		if ((lockedFromStaking + alreadyClaimed) > 0) {
336 			uint256 count = lockedFromStaking + alreadyClaimed;
337 			if (restake > 0) {
338 				if (restake >= count) {
339 					restake -= count;
340 					return (tokensOnWallet, restake, whitelist, ico, mundialStaking, promoRewards, lockedFromStaking, lockedFromWallet, alreadyClaimed);
341 				} else {
342 					count -= restake;
343 					restake = 0;
344 				}
345 			}
346 			if (whitelist > 0) {
347 				if (whitelist >= count) {
348 					whitelist -= count;
349 					return (tokensOnWallet, restake, whitelist, ico, mundialStaking, promoRewards, lockedFromStaking, lockedFromWallet, alreadyClaimed);
350 				} else {
351 					count -= whitelist;
352 					whitelist = 0;
353 				}
354 			}
355 			if (ico > 0) {
356 				if (ico >= count) {
357 					ico -= count;
358 					return (tokensOnWallet, restake, whitelist, ico, mundialStaking, promoRewards, lockedFromStaking, lockedFromWallet, alreadyClaimed);
359 				} else {
360 					count -= ico;
361 					ico = 0;
362 				}
363 			}
364 			if (mundialStaking > 0) {
365 				if (mundialStaking >= count) {
366 					mundialStaking -= count;
367 					return (tokensOnWallet, restake, whitelist, ico, mundialStaking, promoRewards, lockedFromStaking, lockedFromWallet, alreadyClaimed);
368 				} else {
369 					count -= mundialStaking;
370 					mundialStaking = 0;
371 				}
372 			}
373 			if (promoRewards > 0) {
374 				if (promoRewards >= count) {
375 					promoRewards -= count;
376 					return (tokensOnWallet, restake, whitelist, ico, mundialStaking, promoRewards, lockedFromStaking, lockedFromWallet, alreadyClaimed);
377 				} else {
378 					count -= promoRewards;
379 					promoRewards = 0;
380 				}
381 			}
382 			return (tokensOnWallet, restake, whitelist, ico, mundialStaking, promoRewards, lockedFromStaking, lockedFromWallet, alreadyClaimed);
383 		}
384 	}
385 
386 	function getMundialStakingAvailableRewards(address staker) public view returns (uint256) {
387 		uint256 tokenRewards = 0;
388 		for (uint256 i = MundialStaking.getStakedCount(staker); i > 0; i--) {
389 			uint256 tokenId = MundialStaking.getStakedTokens(staker)[i - 1];
390 			tokenRewards += MundialStaking.getRewardsByTokenId(tokenId);
391 		}
392 		if (tokenRewards == 0 && MundialStaking.stakerRewards(staker) == 0) {
393 			return 0;
394 		}
395 		uint256 availableRewards = MundialStaking.stakerRewards(staker) + tokenRewards - MundialStaking.stakerRewardsClaimed(staker);
396 		return availableRewards;
397 	}
398 
399 	function claim() external {
400 		require(block.timestamp >= startDate, "Not started yet");
401 		uint256 claimable = claimableBalanceOf(msg.sender);
402 		require(claimable > 0, "Nothing to claim");
403 		userToClaimedTokens[msg.sender] += claimable;
404 		Token.transfer(msg.sender, claimable);
405 	}
406 
407 	function withdraw(uint256 amount) external onlyOwner {
408 		if (amount == 0) {
409 			amount = Token.balanceOf(address(this));
410 		}
411 		Token.transfer(owner(), amount);
412 	}
413 }
414 
415 interface IWCARestake {
416 	function getTotalClaimable(address _address) external view returns (uint256);
417 }
418 
419 interface IWCAWhitelist {
420 	function getTotalClaimable(address _address) external view returns (uint256);
421 }
422 
423 interface IWCAICO {
424 	function getTotalClaimable(address _address) external view returns (uint256);
425 }
426 
427 interface IWCAMundialStaking {
428 	function getRewardsByTokenId(uint256 _tokenId) external view returns (uint256);
429 
430 	function getStakedCount(address staker) external view returns (uint256);
431 
432 	function getStakedTokens(address staker) external view returns (uint256[] memory);
433 
434 	function stakerRewards(address staker) external view returns (uint256);
435 
436 	function stakerRewardsClaimed(address staker) external view returns (uint256);
437 }
438 
439 interface IWCAMundialRewards {
440 	function getAvailableTokens(address _address) external view returns (uint256);
441 }
442 
443 interface IWCADAOLocking {
444 	function getLockedTokensFromStaking(address _address) external view returns (uint256);
445 
446 	function getLockedTokensFromWallet(address _address) external view returns (uint256);
447 }