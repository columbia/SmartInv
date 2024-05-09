1 // SPDX-License-Identifier: MIT
2 // Sources flattened with hardhat v2.8.4 https://hardhat.org
3 
4 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
32 
33 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 
108 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
109 
110 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Contract module that helps prevent reentrant calls to a function.
116  *
117  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
118  * available, which can be applied to functions to make sure there are no nested
119  * (reentrant) calls to them.
120  *
121  * Note that because there is a single `nonReentrant` guard, functions marked as
122  * `nonReentrant` may not call one another. This can be worked around by making
123  * those functions `private`, and then adding `external` `nonReentrant` entry
124  * points to them.
125  *
126  * TIP: If you would like to learn more about reentrancy and alternative ways
127  * to protect against it, check out our blog post
128  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
129  */
130 abstract contract ReentrancyGuard {
131     // Booleans are more expensive than uint256 or any type that takes up a full
132     // word because each write operation emits an extra SLOAD to first read the
133     // slot's contents, replace the bits taken up by the boolean, and then write
134     // back. This is the compiler's defense against contract upgrades and
135     // pointer aliasing, and it cannot be disabled.
136 
137     // The values being non-zero value makes deployment a bit more expensive,
138     // but in exchange the refund on every call to nonReentrant will be lower in
139     // amount. Since refunds are capped to a percentage of the total
140     // transaction's gas, it is best to keep them low in cases like this one, to
141     // increase the likelihood of the full refund coming into effect.
142     uint256 private constant _NOT_ENTERED = 1;
143     uint256 private constant _ENTERED = 2;
144 
145     uint256 private _status;
146 
147     constructor() {
148         _status = _NOT_ENTERED;
149     }
150 
151     /**
152      * @dev Prevents a contract from calling itself, directly or indirectly.
153      * Calling a `nonReentrant` function from another `nonReentrant`
154      * function is not supported. It is possible to prevent this from happening
155      * by making the `nonReentrant` function external, and making it call a
156      * `private` function that does the actual work.
157      */
158     modifier nonReentrant() {
159         // On the first call to nonReentrant, _notEntered will be true
160         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
161 
162         // Any calls to nonReentrant after this point will fail
163         _status = _ENTERED;
164 
165         _;
166 
167         // By storing the original value once again, a refund is triggered (see
168         // https://eips.ethereum.org/EIPS/eip-2200)
169         _status = _NOT_ENTERED;
170     }
171 }
172 
173 
174 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
175 
176 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Interface of the ERC20 standard as defined in the EIP.
182  */
183 interface IERC20 {
184     /**
185      * @dev Returns the amount of tokens in existence.
186      */
187     function totalSupply() external view returns (uint256);
188 
189     /**
190      * @dev Returns the amount of tokens owned by `account`.
191      */
192     function balanceOf(address account) external view returns (uint256);
193 
194     /**
195      * @dev Moves `amount` tokens from the caller's account to `to`.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transfer(address to, uint256 amount) external returns (bool);
202 
203     /**
204      * @dev Returns the remaining number of tokens that `spender` will be
205      * allowed to spend on behalf of `owner` through {transferFrom}. This is
206      * zero by default.
207      *
208      * This value changes when {approve} or {transferFrom} are called.
209      */
210     function allowance(address owner, address spender) external view returns (uint256);
211 
212     /**
213      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * IMPORTANT: Beware that changing an allowance with this method brings the risk
218      * that someone may use both the old and the new allowance by unfortunate
219      * transaction ordering. One possible solution to mitigate this race
220      * condition is to first reduce the spender's allowance to 0 and set the
221      * desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      *
224      * Emits an {Approval} event.
225      */
226     function approve(address spender, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Moves `amount` tokens from `from` to `to` using the
230      * allowance mechanism. `amount` is then deducted from the caller's
231      * allowance.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * Emits a {Transfer} event.
236      */
237     function transferFrom(
238         address from,
239         address to,
240         uint256 amount
241     ) external returns (bool);
242 
243     /**
244      * @dev Emitted when `value` tokens are moved from one account (`from`) to
245      * another (`to`).
246      *
247      * Note that `value` may be zero.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     /**
252      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
253      * a call to {approve}. `value` is the new allowance.
254      */
255     event Approval(address indexed owner, address indexed spender, uint256 value);
256 }
257 
258 
259 // File contracts/StakingRewards.sol
260 
261 pragma solidity ^0.8.10;
262 
263 
264 
265 contract StakingRewards is Ownable, ReentrancyGuard {
266 
267     /* ========================== STATE VARIABLES =========================== */
268 
269     IERC20 public token;
270     address public treasury;
271 
272     uint256 public lastUpdateTime;
273     uint256 public rewardPerTokenStored;
274 
275     mapping(address => uint256) public userRewardPerTokenPaid;
276     mapping(address => uint256) public rewards;
277 
278     uint256 private _totalSupply;
279     mapping(address => uint256) private _balances;
280 
281     uint256[] public periods;
282     uint256[] public rates;
283 
284     /* ============================ CONSTRUCTOR ============================= */
285 
286     constructor(
287         // Token to stake.
288         address _token,
289         // The teasury account.
290         address _treasury,
291         uint256[] memory _periods,
292         uint256[] memory _rates
293     ) {
294         require(_periods.length == _rates.length);
295         periods = _periods;
296         rates = _rates;
297 
298         token = IERC20(_token);
299         treasury = _treasury;
300     }
301 
302     /* =============================== VIEWS ================================ */
303 
304     function totalSupply() external view returns (uint256) {
305         return _totalSupply;
306     }
307 
308     function balanceOf(address account) external view returns (uint256) {
309         return _balances[account];
310     }
311 
312     // Returns the current reward rate.
313     function rewardRate() public view returns (uint256) {
314         if (block.timestamp < periods[0]) return 0;
315         for (uint i = 1; i < periods.length; i++) {
316             if (block.timestamp < periods[i]) return rates[i - 1];
317         }
318         return 0;
319     }
320 
321     function apr() public view returns (uint256) {
322         if (_totalSupply == 0) return 0;
323         return ((rewardRate() * 1e5) / _totalSupply) * 365 * 24 * 60 * 60;
324     }
325 
326     function max(uint256 a, uint256 b) internal pure returns (uint256) {
327         if (a > b) return a;
328         return b;
329     }
330 
331     function rewardPerToken() public view returns (uint256) {
332         if (_totalSupply == 0) return rewardPerTokenStored;
333         uint256 totalReward;
334         for (uint i = 1; i < periods.length; i++) {
335             // Period block did not start yet.
336             uint256 periodStart = periods[i-1];
337             if (block.timestamp < periodStart) continue;
338 
339             // Period is already included in the last update.
340             uint256 periodEnd = periods[i];
341             if (periodEnd < lastUpdateTime) continue;
342 
343             uint256 lastUpdate = max(lastUpdateTime, periodStart);
344             uint256 periodRate = rates[i-1];
345 
346             uint256 period;
347             if (periodEnd < block.timestamp) {
348                 // Total period block, starting from lastUpdate.
349                 period = periodEnd - lastUpdate;
350             } else {
351                 // Part of the period block, startingf from lastUpdate.
352                 period = block.timestamp - lastUpdate;
353             }
354             totalReward += (period * periodRate * 1e18) / _totalSupply;
355         }
356         return rewardPerTokenStored + totalReward;
357     }
358 
359     function earned(address account) public view returns (uint256) {
360         return
361             ((_balances[account] *
362                 (rewardPerToken() - userRewardPerTokenPaid[account])) / 1e18) +
363             rewards[account];
364     }
365 
366     /* ============================= MODIFIERS ============================== */
367 
368     modifier updateReward(address account) {
369         rewardPerTokenStored = rewardPerToken();
370         lastUpdateTime = block.timestamp;
371         if (account != address(0)) {
372             rewards[account] = earned(account);
373             userRewardPerTokenPaid[account] = rewardPerTokenStored;
374         }
375         _;
376     }
377 
378     /* ========================= MUTATIVE FUNCTIONS ========================= */
379 
380     function stake(uint256 _amount) external nonReentrant updateReward(msg.sender) {
381         _totalSupply += _amount;
382         _balances[msg.sender] += _amount;
383         token.transferFrom(msg.sender, address(this), _amount);
384     }
385 
386     function withdraw() external {
387         withdraw(_balances[msg.sender]);
388     }
389 
390     function withdraw(uint256 _amount) public nonReentrant updateReward(msg.sender) {
391         _totalSupply -= _amount;
392         _balances[msg.sender] -= _amount;
393         token.transfer(msg.sender, _amount);
394     }
395 
396     function getReward() public nonReentrant updateReward(msg.sender) {
397         uint256 reward = rewards[msg.sender];
398         rewards[msg.sender] = 0;
399         token.transferFrom(treasury, msg.sender, reward);
400     }
401 
402     function exit() external {
403         exit(_balances[msg.sender]);
404     }
405 
406     function exit(uint256 _amount) public {
407         withdraw(_amount);
408         getReward();
409     }
410 
411     /* ======================== RESTRICTED FUNCTIONS ======================== */
412 
413     function updateRewards(
414         uint256[] memory _periods,
415         uint256[] memory _rates
416     ) external onlyOwner updateReward(address(0)) {
417         periods = _periods;
418         rates = _rates;
419     }
420 }