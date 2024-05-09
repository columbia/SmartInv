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
92     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
93         return target.mul(d).divCeil(ONE);
94     }
95 
96     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
97         return target.mul(ONE).div(d);
98     }
99 
100     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
101         return target.mul(ONE).divCeil(d);
102     }
103 }
104 
105 
106 // File: contracts/lib/Ownable.sol
107 
108 /*
109 
110     Copyright 2020 DODO ZOO.
111 
112 */
113 
114 /**
115  * @title Ownable
116  * @author DODO Breeder
117  *
118  * @notice Ownership related functions
119  */
120 contract Ownable {
121     address public _OWNER_;
122     address public _NEW_OWNER_;
123 
124     // ============ Events ============
125 
126     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
127 
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130     // ============ Modifiers ============
131 
132     modifier onlyOwner() {
133         require(msg.sender == _OWNER_, "NOT_OWNER");
134         _;
135     }
136 
137     // ============ Functions ============
138 
139     constructor() internal {
140         _OWNER_ = msg.sender;
141         emit OwnershipTransferred(address(0), _OWNER_);
142     }
143 
144     function transferOwnership(address newOwner) external onlyOwner {
145         require(newOwner != address(0), "INVALID_OWNER");
146         emit OwnershipTransferPrepared(_OWNER_, newOwner);
147         _NEW_OWNER_ = newOwner;
148     }
149 
150     function claimOwnership() external {
151         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
152         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
153         _OWNER_ = _NEW_OWNER_;
154         _NEW_OWNER_ = address(0);
155     }
156 }
157 
158 
159 // File: contracts/intf/IERC20.sol
160 
161 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
162 
163 /**
164  * @dev Interface of the ERC20 standard as defined in the EIP.
165  */
166 interface IERC20 {
167     /**
168      * @dev Returns the amount of tokens in existence.
169      */
170     function totalSupply() external view returns (uint256);
171 
172     function decimals() external view returns (uint8);
173 
174     function name() external view returns (string memory);
175 
176     /**
177      * @dev Returns the amount of tokens owned by `account`.
178      */
179     function balanceOf(address account) external view returns (uint256);
180 
181     /**
182      * @dev Moves `amount` tokens from the caller's account to `recipient`.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transfer(address recipient, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Returns the remaining number of tokens that `spender` will be
192      * allowed to spend on behalf of `owner` through {transferFrom}. This is
193      * zero by default.
194      *
195      * This value changes when {approve} or {transferFrom} are called.
196      */
197     function allowance(address owner, address spender) external view returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `sender` to `recipient` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(
225         address sender,
226         address recipient,
227         uint256 amount
228     ) external returns (bool);
229 }
230 
231 
232 // File: contracts/lib/SafeERC20.sol
233 
234 /*
235 
236     Copyright 2020 DODO ZOO.
237     This is a simplified version of OpenZepplin's SafeERC20 library
238 
239 */
240 
241 /**
242  * @title SafeERC20
243  * @dev Wrappers around ERC20 operations that throw on failure (when the token
244  * contract returns false). Tokens that return no value (and instead revert or
245  * throw on failure) are also supported, non-reverting calls are assumed to be
246  * successful.
247  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
248  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
249  */
250 library SafeERC20 {
251     using SafeMath for uint256;
252 
253     function safeTransfer(
254         IERC20 token,
255         address to,
256         uint256 value
257     ) internal {
258         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
259     }
260 
261     function safeTransferFrom(
262         IERC20 token,
263         address from,
264         address to,
265         uint256 value
266     ) internal {
267         _callOptionalReturn(
268             token,
269             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
270         );
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
281         // solhint-disable-next-line max-line-length
282         require(
283             (value == 0) || (token.allowance(address(this), spender) == 0),
284             "SafeERC20: approve from non-zero to non-zero allowance"
285         );
286         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
287     }
288 
289     /**
290      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
291      * on the return value: the return value is optional (but if data is returned, it must not be false).
292      * @param token The token targeted by the call.
293      * @param data The call data (encoded using abi.encode or one of its variants).
294      */
295     function _callOptionalReturn(IERC20 token, bytes memory data) private {
296         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
297         // we're implementing it ourselves.
298 
299         // A Solidity high level call has three parts:
300         //  1. The target address is checked to verify it contains contract code
301         //  2. The call itself is made, and success asserted
302         //  3. The return value is decoded, which in turn checks the size of the returned data.
303         // solhint-disable-next-line max-line-length
304 
305         // solhint-disable-next-line avoid-low-level-calls
306         (bool success, bytes memory returndata) = address(token).call(data);
307         require(success, "SafeERC20: low-level call failed");
308 
309         if (returndata.length > 0) {
310             // Return data is optional
311             // solhint-disable-next-line max-line-length
312             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
313         }
314     }
315 }
316 
317 
318 // File: contracts/token/LockedTokenVault.sol
319 
320 /*
321 
322     Copyright 2020 DODO ZOO.
323 
324 */
325 
326 /**
327  * @title LockedTokenVault
328  * @author DODO Breeder
329  *
330  * @notice Lock Token and release it linearly
331  */
332 
333 contract LockedTokenVault is Ownable {
334     using SafeMath for uint256;
335     using SafeERC20 for IERC20;
336 
337     address _TOKEN_;
338 
339     mapping(address => uint256) internal originBalances;
340     mapping(address => uint256) internal claimedBalances;
341 
342     uint256 public _UNDISTRIBUTED_AMOUNT_;
343     uint256 public _START_RELEASE_TIME_;
344     uint256 public _RELEASE_DURATION_;
345     uint256 public _CLIFF_RATE_;
346 
347     bool public _DISTRIBUTE_FINISHED_;
348 
349     // ============ Modifiers ============
350 
351     event Claim(address indexed holder, uint256 origin, uint256 claimed, uint256 amount);
352 
353     // ============ Modifiers ============
354 
355     modifier beforeStartRelease() {
356         require(block.timestamp < _START_RELEASE_TIME_, "RELEASE START");
357         _;
358     }
359 
360     modifier afterStartRelease() {
361         require(block.timestamp >= _START_RELEASE_TIME_, "RELEASE NOT START");
362         _;
363     }
364 
365     modifier distributeNotFinished() {
366         require(!_DISTRIBUTE_FINISHED_, "DISTRIBUTE FINISHED");
367         _;
368     }
369 
370     // ============ Init Functions ============
371 
372     constructor(
373         address _token,
374         uint256 _startReleaseTime,
375         uint256 _releaseDuration,
376         uint256 _cliffRate
377     ) public {
378         _TOKEN_ = _token;
379         _START_RELEASE_TIME_ = _startReleaseTime;
380         _RELEASE_DURATION_ = _releaseDuration;
381         _CLIFF_RATE_ = _cliffRate;
382     }
383 
384     function deposit(uint256 amount) external onlyOwner {
385         _tokenTransferIn(_OWNER_, amount);
386         _UNDISTRIBUTED_AMOUNT_ = _UNDISTRIBUTED_AMOUNT_.add(amount);
387     }
388 
389     function withdraw(uint256 amount) external onlyOwner {
390         _UNDISTRIBUTED_AMOUNT_ = _UNDISTRIBUTED_AMOUNT_.sub(amount);
391         _tokenTransferOut(_OWNER_, amount);
392     }
393 
394     function finishDistribute() external onlyOwner {
395         _DISTRIBUTE_FINISHED_ = true;
396     }
397 
398     // ============ For Owner ============
399 
400     function grant(address[] calldata holderList, uint256[] calldata amountList)
401         external
402         onlyOwner
403     {
404         require(holderList.length == amountList.length, "batch grant length not match");
405         uint256 amount = 0;
406         for (uint256 i = 0; i < holderList.length; ++i) {
407             // for saving gas, no event for grant
408             originBalances[holderList[i]] = originBalances[holderList[i]].add(amountList[i]);
409             amount = amount.add(amountList[i]);
410         }
411         _UNDISTRIBUTED_AMOUNT_ = _UNDISTRIBUTED_AMOUNT_.sub(amount);
412     }
413 
414     function recall(address holder) external onlyOwner distributeNotFinished {
415         _UNDISTRIBUTED_AMOUNT_ = _UNDISTRIBUTED_AMOUNT_.add(originBalances[holder]).sub(
416             claimedBalances[holder]
417         );
418         originBalances[holder] = 0;
419         claimedBalances[holder] = 0;
420     }
421 
422     // ============ For Holder ============
423 
424     function transferLockedToken(address to) external {
425         originBalances[to] = originBalances[to].add(originBalances[msg.sender]);
426         claimedBalances[to] = claimedBalances[to].add(claimedBalances[msg.sender]);
427 
428         originBalances[msg.sender] = 0;
429         claimedBalances[msg.sender] = 0;
430     }
431 
432     function claim() external {
433         uint256 claimableToken = getClaimableBalance(msg.sender);
434         _tokenTransferOut(msg.sender, claimableToken);
435         claimedBalances[msg.sender] = claimedBalances[msg.sender].add(claimableToken);
436         emit Claim(
437             msg.sender,
438             originBalances[msg.sender],
439             claimedBalances[msg.sender],
440             claimableToken
441         );
442     }
443 
444     // ============ View ============
445 
446     function isReleaseStart() external view returns (bool) {
447         return block.timestamp >= _START_RELEASE_TIME_;
448     }
449 
450     function getOriginBalance(address holder) external view returns (uint256) {
451         return originBalances[holder];
452     }
453 
454     function getClaimedBalance(address holder) external view returns (uint256) {
455         return claimedBalances[holder];
456     }
457 
458     function getClaimableBalance(address holder) public view returns (uint256) {
459         uint256 remainingToken = getRemainingBalance(holder);
460         return originBalances[holder].sub(remainingToken).sub(claimedBalances[holder]);
461     }
462 
463     function getRemainingBalance(address holder) public view returns (uint256) {
464         uint256 remainingRatio = getRemainingRatio(block.timestamp);
465         return DecimalMath.mul(originBalances[holder], remainingRatio);
466     }
467 
468     function getRemainingRatio(uint256 timestamp) public view returns (uint256) {
469         if (timestamp < _START_RELEASE_TIME_) {
470             return DecimalMath.ONE;
471         }
472         uint256 timePast = timestamp.sub(_START_RELEASE_TIME_);
473         if (timePast < _RELEASE_DURATION_) {
474             uint256 remainingTime = _RELEASE_DURATION_.sub(timePast);
475             return DecimalMath.ONE.sub(_CLIFF_RATE_).mul(remainingTime).div(_RELEASE_DURATION_);
476         } else {
477             return 0;
478         }
479     }
480 
481     // ============ Internal Helper ============
482 
483     function _tokenTransferIn(address from, uint256 amount) internal {
484         IERC20(_TOKEN_).safeTransferFrom(from, address(this), amount);
485     }
486 
487     function _tokenTransferOut(address to, uint256 amount) internal {
488         IERC20(_TOKEN_).safeTransfer(to, amount);
489     }
490 }