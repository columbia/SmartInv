1 // File: contracts/lib/SafeMath.sol
2 
3 /*
4 
5     Copyright 2020 DODO ZOO.
6     SPDX-License-Identifier: Apache-2.0
7 
8 */
9 
10 pragma solidity 0.6.9;
11 pragma experimental ABIEncoderV2;
12 
13 
14 /**
15  * @title SafeMath
16  * @author DODO Breeder
17  *
18  * @notice Math operations with safety checks that revert on error
19  */
20 library SafeMath {
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25 
26         uint256 c = a * b;
27         require(c / a == b, "MUL_ERROR");
28 
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b > 0, "DIVIDING_ERROR");
34         return a / b;
35     }
36 
37     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 quotient = div(a, b);
39         uint256 remainder = a - quotient * b;
40         if (remainder > 0) {
41             return quotient + 1;
42         } else {
43             return quotient;
44         }
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         require(b <= a, "SUB_ERROR");
49         return a - b;
50     }
51 
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "ADD_ERROR");
55         return c;
56     }
57 
58     function sqrt(uint256 x) internal pure returns (uint256 y) {
59         uint256 z = x / 2 + 1;
60         y = x;
61         while (z < y) {
62             y = z;
63             z = (x / z + z) / 2;
64         }
65     }
66 }
67 
68 
69 // File: contracts/lib/DecimalMath.sol
70 
71 /*
72 
73     Copyright 2020 DODO ZOO.
74 
75 */
76 
77 /**
78  * @title DecimalMath
79  * @author DODO Breeder
80  *
81  * @notice Functions for fixed point number with 18 decimals
82  */
83 library DecimalMath {
84     using SafeMath for uint256;
85 
86     uint256 constant ONE = 10**18;
87 
88     function mul(uint256 target, uint256 d) internal pure returns (uint256) {
89         return target.mul(d) / ONE;
90     }
91 
92     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
93         return target.mul(ONE).div(d);
94     }
95 
96     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
97         return target.mul(ONE).divCeil(d);
98     }
99 }
100 
101 
102 // File: contracts/lib/Ownable.sol
103 
104 /*
105 
106     Copyright 2020 DODO ZOO.
107 
108 */
109 
110 /**
111  * @title Ownable
112  * @author DODO Breeder
113  *
114  * @notice Ownership related functions
115  */
116 contract Ownable {
117     address public _OWNER_;
118     address public _NEW_OWNER_;
119 
120     // ============ Events ============
121 
122     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     // ============ Modifiers ============
127 
128     modifier onlyOwner() {
129         require(msg.sender == _OWNER_, "NOT_OWNER");
130         _;
131     }
132 
133     // ============ Functions ============
134 
135     constructor() internal {
136         _OWNER_ = msg.sender;
137         emit OwnershipTransferred(address(0), _OWNER_);
138     }
139 
140     function transferOwnership(address newOwner) external onlyOwner {
141         require(newOwner != address(0), "INVALID_OWNER");
142         emit OwnershipTransferPrepared(_OWNER_, newOwner);
143         _NEW_OWNER_ = newOwner;
144     }
145 
146     function claimOwnership() external {
147         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
148         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
149         _OWNER_ = _NEW_OWNER_;
150         _NEW_OWNER_ = address(0);
151     }
152 }
153 
154 
155 // File: contracts/intf/IERC20.sol
156 
157 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
158 
159 /**
160  * @dev Interface of the ERC20 standard as defined in the EIP.
161  */
162 interface IERC20 {
163     /**
164      * @dev Returns the amount of tokens in existence.
165      */
166     function totalSupply() external view returns (uint256);
167 
168     function decimals() external view returns (uint8);
169 
170     function name() external view returns (string memory);
171 
172     /**
173      * @dev Returns the amount of tokens owned by `account`.
174      */
175     function balanceOf(address account) external view returns (uint256);
176 
177     /**
178      * @dev Moves `amount` tokens from the caller's account to `recipient`.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transfer(address recipient, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Returns the remaining number of tokens that `spender` will be
188      * allowed to spend on behalf of `owner` through {transferFrom}. This is
189      * zero by default.
190      *
191      * This value changes when {approve} or {transferFrom} are called.
192      */
193     function allowance(address owner, address spender) external view returns (uint256);
194 
195     /**
196      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * IMPORTANT: Beware that changing an allowance with this method brings the risk
201      * that someone may use both the old and the new allowance by unfortunate
202      * transaction ordering. One possible solution to mitigate this race
203      * condition is to first reduce the spender's allowance to 0 and set the
204      * desired value afterwards:
205      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address spender, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Moves `amount` tokens from `sender` to `recipient` using the
213      * allowance mechanism. `amount` is then deducted from the caller's
214      * allowance.
215      *
216      * Returns a boolean value indicating whether the operation succeeded.
217      *
218      * Emits a {Transfer} event.
219      */
220     function transferFrom(
221         address sender,
222         address recipient,
223         uint256 amount
224     ) external returns (bool);
225 }
226 
227 
228 // File: contracts/lib/SafeERC20.sol
229 
230 /*
231 
232     Copyright 2020 DODO ZOO.
233     This is a simplified version of OpenZepplin's SafeERC20 library
234 
235 */
236 
237 /**
238  * @title SafeERC20
239  * @dev Wrappers around ERC20 operations that throw on failure (when the token
240  * contract returns false). Tokens that return no value (and instead revert or
241  * throw on failure) are also supported, non-reverting calls are assumed to be
242  * successful.
243  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
244  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
245  */
246 library SafeERC20 {
247     using SafeMath for uint256;
248 
249     function safeTransfer(
250         IERC20 token,
251         address to,
252         uint256 value
253     ) internal {
254         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
255     }
256 
257     function safeTransferFrom(
258         IERC20 token,
259         address from,
260         address to,
261         uint256 value
262     ) internal {
263         _callOptionalReturn(
264             token,
265             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
266         );
267     }
268 
269     function safeApprove(
270         IERC20 token,
271         address spender,
272         uint256 value
273     ) internal {
274         // safeApprove should only be called when setting an initial allowance,
275         // or when resetting it to zero. To increase and decrease it, use
276         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
277         // solhint-disable-next-line max-line-length
278         require(
279             (value == 0) || (token.allowance(address(this), spender) == 0),
280             "SafeERC20: approve from non-zero to non-zero allowance"
281         );
282         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
283     }
284 
285     /**
286      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
287      * on the return value: the return value is optional (but if data is returned, it must not be false).
288      * @param token The token targeted by the call.
289      * @param data The call data (encoded using abi.encode or one of its variants).
290      */
291     function _callOptionalReturn(IERC20 token, bytes memory data) private {
292         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
293         // we're implementing it ourselves.
294 
295         // A Solidity high level call has three parts:
296         //  1. The target address is checked to verify it contains contract code
297         //  2. The call itself is made, and success asserted
298         //  3. The return value is decoded, which in turn checks the size of the returned data.
299         // solhint-disable-next-line max-line-length
300 
301         // solhint-disable-next-line avoid-low-level-calls
302         (bool success, bytes memory returndata) = address(token).call(data);
303         require(success, "SafeERC20: low-level call failed");
304 
305         if (returndata.length > 0) {
306             // Return data is optional
307             // solhint-disable-next-line max-line-length
308             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
309         }
310     }
311 }
312 
313 
314 // File: contracts/token/LockedTokenVault.sol
315 
316 /*
317 
318     Copyright 2020 DODO ZOO.
319 
320 */
321 
322 /**
323  * @title LockedTokenVault
324  * @author DODO Breeder
325  *
326  * @notice Lock Token and release it linearly
327  */
328 
329 contract LockedTokenVault is Ownable {
330     using SafeMath for uint256;
331     using SafeERC20 for IERC20;
332 
333     address _TOKEN_;
334 
335     mapping(address => uint256) internal originBalances;
336     mapping(address => uint256) internal claimedBalances;
337 
338     mapping(address => address) internal holderTransferRequest;
339 
340     uint256 public _UNDISTRIBUTED_AMOUNT_;
341     uint256 public _START_RELEASE_TIME_;
342     uint256 public _RELEASE_DURATION_;
343     uint256 public _CLIFF_RATE_;
344 
345     bool public _DISTRIBUTE_FINISHED_;
346 
347     // ============ Modifiers ============
348 
349     modifier beforeStartRelease() {
350         require(block.timestamp < _START_RELEASE_TIME_, "RELEASE START");
351         _;
352     }
353 
354     modifier afterStartRelease() {
355         require(block.timestamp > _START_RELEASE_TIME_, "RELEASE NOT START");
356         _;
357     }
358 
359     modifier distributeNotFinished() {
360         require(!_DISTRIBUTE_FINISHED_, "DISTRIBUTE FINISHED");
361         _;
362     }
363 
364     // ============ Init Functions ============
365 
366     constructor(
367         address _token,
368         uint256 _startReleaseTime,
369         uint256 _releaseDuration,
370         uint256 _cliffRate
371     ) public {
372         _TOKEN_ = _token;
373         _START_RELEASE_TIME_ = _startReleaseTime;
374         _RELEASE_DURATION_ = _releaseDuration;
375         _CLIFF_RATE_ = _cliffRate;
376     }
377 
378     function deposit(uint256 amount) external onlyOwner {
379         _tokenTransferIn(_OWNER_, amount);
380         _UNDISTRIBUTED_AMOUNT_ = _UNDISTRIBUTED_AMOUNT_.add(amount);
381     }
382 
383     function withdraw(uint256 amount) external onlyOwner {
384         _UNDISTRIBUTED_AMOUNT_ = _UNDISTRIBUTED_AMOUNT_.sub(amount);
385         _tokenTransferOut(_OWNER_, amount);
386     }
387 
388     function finishDistribute() external onlyOwner {
389         _DISTRIBUTE_FINISHED_ = true;
390     }
391 
392     // ============ For Owner ============
393 
394     function grant(address[] calldata holderList, uint256[] calldata amountList)
395         external
396         onlyOwner
397     {
398         require(holderList.length == amountList.length, "batch grant length not match");
399         uint256 amount = 0;
400         for (uint256 i = 0; i < holderList.length; ++i) {
401             originBalances[holderList[i]] = originBalances[holderList[i]].add(amountList[i]);
402             amount = amount.add(amountList[i]);
403         }
404         _UNDISTRIBUTED_AMOUNT_ = _UNDISTRIBUTED_AMOUNT_.sub(amount);
405     }
406 
407     function recall(address holder) external onlyOwner distributeNotFinished {
408         uint256 amount = originBalances[holder];
409         originBalances[holder] = 0;
410         _UNDISTRIBUTED_AMOUNT_ = _UNDISTRIBUTED_AMOUNT_.add(amount);
411     }
412 
413     // ============ For Holder ============
414 
415     function transferLockedToken(address to) external {
416         originBalances[to] = originBalances[to].add(originBalances[msg.sender]);
417         claimedBalances[to] = claimedBalances[to].add(claimedBalances[msg.sender]);
418 
419         originBalances[msg.sender] = 0;
420         claimedBalances[msg.sender] = 0;
421     }
422 
423     function claim() external {
424         uint256 claimableToken = getClaimableBalance(msg.sender);
425         _tokenTransferOut(msg.sender, claimableToken);
426         claimedBalances[msg.sender] = claimedBalances[msg.sender].add(claimableToken);
427     }
428 
429     // ============ View ============
430 
431     function getOriginBalance(address holder) external view returns (uint256) {
432         return originBalances[holder];
433     }
434 
435     function getClaimedBalance(address holder) external view returns (uint256) {
436         return claimedBalances[holder];
437     }
438 
439     function getHolderTransferRequest(address holder) external view returns (address) {
440         return holderTransferRequest[holder];
441     }
442 
443     function getClaimableBalance(address holder) public view returns (uint256) {
444         if (block.timestamp < _START_RELEASE_TIME_) {
445             return 0;
446         }
447         uint256 remainingToken = getRemainingBalance(holder);
448         return originBalances[holder].sub(remainingToken).sub(claimedBalances[holder]);
449     }
450 
451     function getRemainingBalance(address holder) public view returns (uint256) {
452         uint256 remainingToken = 0;
453         uint256 timePast = block.timestamp.sub(_START_RELEASE_TIME_);
454         if (timePast < _RELEASE_DURATION_) {
455             uint256 remainingTime = _RELEASE_DURATION_.sub(timePast);
456             remainingToken = originBalances[holder]
457                 .sub(DecimalMath.mul(originBalances[holder], _CLIFF_RATE_))
458                 .mul(remainingTime)
459                 .div(_RELEASE_DURATION_);
460         }
461         return remainingToken;
462     }
463 
464     // ============ Internal Helper ============
465 
466     function _tokenTransferIn(address from, uint256 amount) internal {
467         IERC20(_TOKEN_).safeTransferFrom(from, address(this), amount);
468     }
469 
470     function _tokenTransferOut(address to, uint256 amount) internal {
471         IERC20(_TOKEN_).safeTransfer(to, amount);
472     }
473 }