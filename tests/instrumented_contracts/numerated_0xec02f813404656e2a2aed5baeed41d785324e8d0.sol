1 // SPDX-License-Identifier: MIT
2 // File: ../../../../media/shakeib98/xio-flash-protocol/contracts/interfaces/IFlashToken.sol
3 
4 pragma solidity 0.6.12;
5 
6 interface IFlashToken {
7     function totalSupply() external view returns (uint256);
8 
9     function balanceOf(address account) external view returns (uint256);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transfer(address recipient, uint256 amount) external returns (bool);
16 
17     function transferFrom(
18         address sender,
19         address recipient,
20         uint256 amount
21     ) external returns (bool);
22 
23     function mint(address to, uint256 value) external returns (bool);
24 
25     function burn(uint256 value) external returns (bool);
26 }
27 
28 // File: ../../../../media/shakeib98/xio-flash-protocol/contracts/interfaces/IFlashReceiver.sol
29 
30 pragma solidity 0.6.12;
31 
32 interface IFlashReceiver {
33     function receiveFlash(
34         bytes32 id,
35         uint256 amountIn,
36         uint256 expireAfter,
37         uint256 mintedAmount,
38         address staker,
39         bytes calldata data
40     ) external returns (uint256);
41 }
42 
43 // File: ../../../../media/shakeib98/xio-flash-protocol/contracts/interfaces/IFlashProtocol.sol
44 
45 pragma solidity 0.6.12;
46 
47 interface IFlashProtocol {
48     enum LockedFunctions { SET_MATCH_RATIO, SET_MATCH_RECEIVER }
49 
50     function TIMELOCK() external view returns (uint256);
51 
52     function FLASH_TOKEN() external view returns (address);
53 
54     function matchRatio() external view returns (uint256);
55 
56     function matchReceiver() external view returns (address);
57 
58     function stakes(bytes32 _id)
59         external
60         view
61         returns (
62             uint256 amountIn,
63             uint256 expiry,
64             uint256 expireAfter,
65             uint256 mintedAmount,
66             address staker,
67             address receiver
68         );
69 
70     function stake(
71         uint256 _amountIn,
72         uint256 _days,
73         address _receiver,
74         bytes calldata _data
75     )
76         external
77         returns (
78             uint256 mintedAmount,
79             uint256 matchedAmount,
80             bytes32 id
81         );
82 
83     function lockFunction(LockedFunctions _lockedFunction) external;
84 
85     function unlockFunction(LockedFunctions _lockedFunction) external;
86 
87     function timelock(LockedFunctions _lockedFunction) external view returns (uint256);
88 
89     function balances(address _staker) external view returns (uint256);
90 
91     function unstake(bytes32 _id) external returns (uint256 withdrawAmount);
92 
93     function unstakeEarly(bytes32 _id) external returns (uint256 withdrawAmount);
94 
95     function getFPY(uint256 _amountIn) external view returns (uint256);
96 
97     function setMatchReceiver(address _newMatchReceiver) external;
98 
99     function setMatchRatio(uint256 _newMatchRatio) external;
100 
101     function getMatchedAmount(uint256 mintedAmount) external view returns (uint256);
102 
103     function getMintAmount(uint256 _amountIn, uint256 _expiry) external view returns (uint256);
104 
105     function getPercentageStaked(uint256 _amountIn) external view returns (uint256 percentage);
106 
107     function getInvFPY(uint256 _amount) external view returns (uint256);
108 
109     function getPercentageUnStaked(uint256 _amount) external view returns (uint256 percentage);
110 }
111 
112 // File: ../../../../media/shakeib98/xio-flash-protocol/contracts/libraries/SafeMath.sol
113 
114 pragma solidity 0.6.12;
115 
116 // A library for performing overflow-safe math, courtesy of DappHub: https://github.com/dapphub/ds-math/blob/d0ef6d6a5f/src/math.sol
117 // Modified to include only the essentials
118 library SafeMath {
119     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
120         require((z = x + y) >= x, "MATH:: ADD_OVERFLOW");
121     }
122 
123     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
124         require((z = x - y) <= x, "MATH:: SUB_UNDERFLOW");
125     }
126 
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129         // benefit is lost if 'b' is also tested.
130         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
131         if (a == 0) {
132             return 0;
133         }
134 
135         uint256 c = a * b;
136         require(c / a == b, "MATH:: MUL_OVERFLOW");
137 
138         return c;
139     }
140 
141     function div(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b > 0, "MATH:: DIVISION_BY_ZERO");
143         uint256 c = a / b;
144         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
145 
146         return c;
147     }
148 }
149 
150 // File: ../../../../media/shakeib98/xio-flash-protocol/contracts/libraries/Address.sol
151 
152 pragma solidity 0.6.12;
153 
154 /**
155  * @dev Collection of functions related to the address type
156  */
157 library Address {
158     /**
159      * @dev Returns true if `account` is a contract.
160      *
161      * [IMPORTANT]
162      * ====
163      * It is unsafe to assume that an address for which this function returns
164      * false is an externally-owned account (EOA) and not a contract.
165      *
166      * Among others, `isContract` will return false for the following
167      * types of addresses:
168      *
169      *  - an externally-owned account
170      *  - a contract in construction
171      *  - an address where a contract will be created
172      *  - an address where a contract lived, but was destroyed
173      * ====
174      */
175     function isContract(address account) internal view returns (bool) {
176         // This method relies on extcodesize, which returns 0 for contracts in
177         // construction, since the code is only stored at the end of the
178         // constructor execution.
179 
180         uint256 size;
181         // solhint-disable-next-line no-inline-assembly
182         assembly {
183             size := extcodesize(account)
184         }
185         return size > 0;
186     }
187 }
188 
189 // File: ../../../../media/shakeib98/xio-flash-protocol/contracts/FlashProtocol.sol
190 
191 pragma solidity 0.6.12;
192 
193 
194 
195 
196 
197 
198 contract FlashProtocol is IFlashProtocol {
199     using SafeMath for uint256;
200     using Address for address;
201 
202     struct Stake {
203         uint256 amountIn;
204         uint256 expiry;
205         uint256 expireAfter;
206         uint256 mintedAmount;
207         address staker;
208         address receiver;
209     }
210 
211     uint256 public constant override TIMELOCK = 3 days;
212     address public constant override FLASH_TOKEN = 0xB4467E8D621105312a914F1D42f10770C0Ffe3c8;
213 
214     uint256 internal constant PRECISION = 1e18;
215     uint256 internal constant MAX_FPY_FOR_1_YEAR = 5e17;
216     uint256 internal constant SECONDS_IN_1_YEAR = 365 * 86400;
217 
218     uint256 public override matchRatio;
219     address public override matchReceiver;
220 
221     mapping(bytes32 => Stake) public override stakes;
222     mapping(LockedFunctions => uint256) public override timelock;
223     mapping(address => uint256) public override balances;
224 
225     event Staked(
226         bytes32 _id,
227         uint256 _amountIn,
228         uint256 _expiry,
229         uint256 _expireAfter,
230         uint256 _mintedAmount,
231         address indexed _staker,
232         address indexed _receiver
233     );
234 
235     event Unstaked(bytes32 _id, uint256 _amountIn, address indexed _staker);
236 
237     modifier onlyMatchReceiver {
238         require(msg.sender == matchReceiver, "FlashProtocol:: NOT_MATCH_RECEIVER");
239         _;
240     }
241 
242     modifier notLocked(LockedFunctions _lockedFunction) {
243         require(
244             timelock[_lockedFunction] != 0 && timelock[_lockedFunction] <= block.timestamp,
245             "FlashProtocol:: FUNCTION_TIMELOCKED"
246         );
247         _;
248     }
249 
250     constructor(address _initialMatchReceiver) public {
251         _setMatchReceiver(_initialMatchReceiver);
252     }
253 
254     function lockFunction(LockedFunctions _lockedFunction) external override onlyMatchReceiver {
255         timelock[_lockedFunction] = type(uint256).max;
256     }
257 
258     function unlockFunction(LockedFunctions _lockedFunction) external override onlyMatchReceiver {
259         timelock[_lockedFunction] = block.timestamp + TIMELOCK;
260     }
261 
262     function setMatchReceiver(address _newMatchReceiver)
263         external
264         override
265         onlyMatchReceiver
266         notLocked(LockedFunctions.SET_MATCH_RECEIVER)
267     {
268         _setMatchReceiver(_newMatchReceiver);
269         timelock[LockedFunctions.SET_MATCH_RECEIVER] = 0;
270     }
271 
272     function _setMatchReceiver(address _newMatchReceiver) internal {
273         matchReceiver = _newMatchReceiver;
274     }
275 
276     function setMatchRatio(uint256 _newMatchRatio)
277         external
278         override
279         onlyMatchReceiver
280         notLocked(LockedFunctions.SET_MATCH_RATIO)
281     {
282         require(_newMatchRatio >= 0 && _newMatchRatio <= 2000, "FlashProtocol:: INVALID_MATCH_RATIO");
283         matchRatio = _newMatchRatio;
284         timelock[LockedFunctions.SET_MATCH_RATIO] = 0;
285     }
286 
287     function stake(
288         uint256 _amountIn,
289         uint256 _expiry,
290         address _receiver,
291         bytes calldata _data
292     )
293         external
294         override
295         returns (
296             uint256 mintedAmount,
297             uint256 matchedAmount,
298             bytes32 id
299         )
300     {
301         require(_amountIn > 0, "FlashProtocol:: INVALID_AMOUNT");
302 
303         require(_receiver != address(this), "FlashProtocol:: INVALID_ADDRESS");
304 
305         address staker = msg.sender;
306 
307         require(_expiry <= calculateMaxStakePeriod(_amountIn), "FlashProtocol:: MAX_STAKE_PERIOD_EXCEEDS");
308 
309         uint256 expiration = block.timestamp.add(_expiry);
310 
311         IFlashToken(FLASH_TOKEN).transferFrom(staker, address(this), _amountIn);
312 
313         balances[staker] = balances[staker].add(_amountIn);
314 
315         id = keccak256(abi.encodePacked(_amountIn, _expiry, _receiver, staker, block.timestamp));
316 
317         require(stakes[id].staker == address(0), "FlashProtocol:: STAKE_EXISTS");
318 
319         mintedAmount = getMintAmount(_amountIn, _expiry);
320         matchedAmount = getMatchedAmount(mintedAmount);
321 
322         IFlashToken(FLASH_TOKEN).mint(_receiver, mintedAmount);
323         IFlashToken(FLASH_TOKEN).mint(matchReceiver, matchedAmount);
324 
325         stakes[id] = Stake(_amountIn, _expiry, expiration, mintedAmount, staker, _receiver);
326 
327         if (_receiver.isContract()) {
328             IFlashReceiver(_receiver).receiveFlash(id, _amountIn, expiration, mintedAmount, staker, _data);
329         }
330 
331         emit Staked(id, _amountIn, _expiry, expiration, mintedAmount, staker, _receiver);
332     }
333 
334     function unstake(bytes32 _id) external override returns (uint256 withdrawAmount) {
335         Stake memory s = stakes[_id];
336         require(block.timestamp >= s.expireAfter, "FlashProtol:: STAKE_NOT_EXPIRED");
337         balances[s.staker] = balances[s.staker].sub(s.amountIn);
338         withdrawAmount = s.amountIn;
339         delete stakes[_id];
340         IFlashToken(FLASH_TOKEN).transfer(s.staker, withdrawAmount);
341         emit Unstaked(_id, s.amountIn, s.staker);
342     }
343 
344     function unstakeEarly(bytes32 _id) external override returns (uint256 withdrawAmount) {
345         Stake memory s = stakes[_id];
346         address staker = msg.sender;
347         require(s.staker == staker, "FlashProtocol:: INVALID_STAKER");
348         uint256 remainingTime = (s.expireAfter.sub(block.timestamp));
349         uint256 burnAmount = _calculateBurn(s.amountIn, remainingTime, s.expiry);
350         assert(burnAmount <= s.amountIn);
351         balances[staker] = balances[staker].sub(s.amountIn);
352         withdrawAmount = s.amountIn.sub(burnAmount);
353         delete stakes[_id];
354         IFlashToken(FLASH_TOKEN).burn(burnAmount);
355         IFlashToken(FLASH_TOKEN).transfer(staker, withdrawAmount);
356         emit Unstaked(_id, s.amountIn, staker);
357     }
358 
359     function getMatchedAmount(uint256 _mintedAmount) public override view returns (uint256) {
360         return _mintedAmount.mul(matchRatio).div(10000);
361     }
362 
363     function getMintAmount(uint256 _amountIn, uint256 _expiry) public override view returns (uint256) {
364         return _amountIn.mul(_expiry).mul(getFPY(_amountIn)).div(PRECISION * SECONDS_IN_1_YEAR);
365     }
366 
367     function getFPY(uint256 _amountIn) public override view returns (uint256) {
368         return (PRECISION.sub(getPercentageStaked(_amountIn))).div(2);
369     }
370 
371     function getPercentageStaked(uint256 _amountIn) public override view returns (uint256 percentage) {
372         uint256 locked = IFlashToken(FLASH_TOKEN).balanceOf(address(this)).add(_amountIn);
373         percentage = locked.mul(PRECISION).div(IFlashToken(FLASH_TOKEN).totalSupply());
374     }
375 
376     function _calculateBurn(
377         uint256 _amount,
378         uint256 _remainingTime,
379         uint256 _totalTime
380     ) private view returns (uint256 burnAmount) {
381         burnAmount = _amount.mul(_remainingTime).mul(getInvFPY(_amount)).div(_totalTime.mul(PRECISION));
382     }
383 
384     function getInvFPY(uint256 _amount) public override view returns (uint256) {
385         return PRECISION.sub(getPercentageUnStaked(_amount));
386     }
387 
388     function getPercentageUnStaked(uint256 _amount) public override view returns (uint256 percentage) {
389         uint256 locked = IFlashToken(FLASH_TOKEN).balanceOf(address(this)).sub(_amount);
390         percentage = locked.mul(PRECISION).div(IFlashToken(FLASH_TOKEN).totalSupply());
391     }
392 
393     function calculateMaxStakePeriod(uint256 _amountIn) private view returns (uint256) {
394         return MAX_FPY_FOR_1_YEAR.mul(SECONDS_IN_1_YEAR).div(getFPY(_amountIn));
395     }
396 }