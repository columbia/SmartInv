1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.4;
3 
4 interface IFlashToken {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function allowance(address owner, address spender) external view returns (uint256);
10 
11     function approve(address spender, uint256 amount) external returns (bool);
12 
13     function transfer(address recipient, uint256 amount) external returns (bool);
14 
15     function transferFrom(
16         address sender,
17         address recipient,
18         uint256 amount
19     ) external returns (bool);
20 
21     function mint(address to, uint256 value) external returns (bool);
22 
23     function burn(uint256 value) external returns (bool);
24 
25     function permit(
26         address owner,
27         address spender,
28         uint256 value,
29         uint256 deadline,
30         uint8 v,
31         bytes32 r,
32         bytes32 s
33     ) external;
34 }
35 
36 interface IFlashReceiver {
37     function receiveFlash(
38         bytes32 id,
39         uint256 amountIn,
40         uint256 expireAfter,
41         uint256 mintedAmount,
42         address staker,
43         bytes calldata data
44     ) external returns (uint256);
45 }
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
107     function calculateMaxStakePeriod(uint256 _amountIn) external view returns (uint256);
108 
109     function stakeWithPermit(
110         address _receiver,
111         uint256 _amountIn,
112         uint256 _expiry,
113         uint256 _deadline,
114         uint8 _v,
115         bytes32 _r,
116         bytes32 _s,
117         bytes calldata _data
118     )
119         external
120         returns (
121             uint256 mintedAmount,
122             uint256 matchedAmount,
123             bytes32 id
124         );
125 }
126 
127 library SafeMath {
128     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
129         require((z = x + y) >= x, "MATH:: ADD_OVERFLOW");
130     }
131 
132     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
133         require((z = x - y) <= x, "MATH:: SUB_UNDERFLOW");
134     }
135 
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138         // benefit is lost if 'b' is also tested.
139         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
140         if (a == 0) {
141             return 0;
142         }
143 
144         uint256 c = a * b;
145         require(c / a == b, "MATH:: MUL_OVERFLOW");
146 
147         return c;
148     }
149 
150     function div(uint256 a, uint256 b) internal pure returns (uint256) {
151         require(b > 0, "MATH:: DIVISION_BY_ZERO");
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 }
158 
159 library Address {
160     /**
161      * @dev Returns true if `account` is a contract.
162      *
163      * [IMPORTANT]
164      * ====
165      * It is unsafe to assume that an address for which this function returns
166      * false is an externally-owned account (EOA) and not a contract.
167      *
168      * Among others, `isContract` will return false for the following
169      * types of addresses:
170      *
171      *  - an externally-owned account
172      *  - a contract in construction
173      *  - an address where a contract will be created
174      *  - an address where a contract lived, but was destroyed
175      * ====
176      */
177     function isContract(address account) internal view returns (bool) {
178         // This method relies on extcodesize, which returns 0 for contracts in
179         // construction, since the code is only stored at the end of the
180         // constructor execution.
181 
182         uint256 size;
183         // solhint-disable-next-line no-inline-assembly
184         assembly {
185             size := extcodesize(account)
186         }
187         return size > 0;
188     }
189 }
190 
191 
192 contract FlashProtocol is IFlashProtocol {
193     using SafeMath for uint256;
194     using Address for address;
195 
196     struct Stake {
197         uint256 amountIn;
198         uint256 expiry;
199         uint256 expireAfter;
200         uint256 mintedAmount;
201         address staker;
202         address receiver;
203     }
204 
205     uint256 public constant override TIMELOCK = 3 days;
206     address public constant override FLASH_TOKEN = 0x20398aD62bb2D930646d45a6D4292baa0b860C1f;
207 
208     uint256 internal constant PRECISION = 1e18;
209     uint256 internal constant MAX_FPY_FOR_1_YEAR = 5e17;
210     uint256 internal constant SECONDS_IN_1_YEAR = 365 * 86400;
211 
212     uint256 public override matchRatio;
213     address public override matchReceiver;
214 
215     mapping(bytes32 => Stake) public override stakes;
216     mapping(LockedFunctions => uint256) public override timelock;
217     mapping(address => uint256) public override balances;
218 
219     event Staked(
220         bytes32 _id,
221         uint256 _amountIn,
222         uint256 _expiry,
223         uint256 _expireAfter,
224         uint256 _mintedAmount,
225         address indexed _staker,
226         address indexed _receiver
227     );
228 
229     event Unstaked(bytes32 _id, uint256 _amountIn, address indexed _staker);
230 
231     modifier onlyMatchReceiver {
232         require(msg.sender == matchReceiver, "FlashProtocol:: NOT_MATCH_RECEIVER");
233         _;
234     }
235 
236     modifier notLocked(LockedFunctions _lockedFunction) {
237         require(
238             timelock[_lockedFunction] != 0 && timelock[_lockedFunction] <= block.timestamp,
239             "FlashProtocol:: FUNCTION_TIMELOCKED"
240         );
241         _;
242     }
243 
244     constructor(address _initialMatchReceiver, uint256 _initialMatchRatio) {
245         _setMatchRatio(_initialMatchRatio);
246         _setMatchReceiver(_initialMatchReceiver);
247     }
248 
249     function lockFunction(LockedFunctions _lockedFunction) external override onlyMatchReceiver {
250         timelock[_lockedFunction] = type(uint256).max;
251     }
252 
253     function unlockFunction(LockedFunctions _lockedFunction) external override onlyMatchReceiver {
254         timelock[_lockedFunction] = block.timestamp + TIMELOCK;
255     }
256 
257     function setMatchReceiver(address _newMatchReceiver)
258         external
259         override
260         onlyMatchReceiver
261         notLocked(LockedFunctions.SET_MATCH_RECEIVER)
262     {
263         _setMatchReceiver(_newMatchReceiver);
264         timelock[LockedFunctions.SET_MATCH_RECEIVER] = 0;
265     }
266 
267     function _setMatchReceiver(address _newMatchReceiver) internal {
268         matchReceiver = _newMatchReceiver;
269     }
270 
271     function setMatchRatio(uint256 _newMatchRatio)
272         external
273         override
274         onlyMatchReceiver
275         notLocked(LockedFunctions.SET_MATCH_RATIO)
276     {
277         _setMatchRatio(_newMatchRatio);
278         timelock[LockedFunctions.SET_MATCH_RATIO] = 0;
279     }
280 
281     function _setMatchRatio(uint256 _newMatchRatio) internal {
282         require(_newMatchRatio >= 0 && _newMatchRatio <= 2000, "FlashProtocol:: INVALID_MATCH_RATIO");
283         // can be 0 and cannot be above 20%
284         require(_newMatchRatio <= 2000, "FlashProtocol:: INVALID_MATCH_RATIO");
285         matchRatio = _newMatchRatio;
286     }
287 
288     function stake(
289         uint256 _amountIn,
290         uint256 _expiry,
291         address _receiver,
292         bytes calldata _data
293     )
294         external
295         override
296         returns (
297             uint256,
298             uint256,
299             bytes32
300         )
301     {
302         return _stake(_amountIn, _expiry, _receiver, _data);
303     }
304 
305     function stakeWithPermit(
306         address _receiver,
307         uint256 _amountIn,
308         uint256 _expiry,
309         uint256 _deadline,
310         uint8 _v,
311         bytes32 _r,
312         bytes32 _s,
313         bytes calldata _data
314     )
315         external
316         override
317         returns (
318             uint256,
319             uint256,
320             bytes32
321         )
322     {
323         IFlashToken(FLASH_TOKEN).permit(msg.sender, address(this), type(uint256).max, _deadline, _v, _r, _s);
324         return _stake(_amountIn, _expiry, _receiver, _data);
325     }
326 
327     function _stake(
328         uint256 _amountIn,
329         uint256 _expiry,
330         address _receiver,
331         bytes calldata _data
332     )
333         internal
334         returns (
335             uint256 mintedAmount,
336             uint256 matchedAmount,
337             bytes32 id
338         )
339     {
340         require(_amountIn > 0, "FlashProtocol:: INVALID_AMOUNT");
341         require(_receiver != address(this), "FlashProtocol:: INVALID_ADDRESS");
342         require(_expiry <= calculateMaxStakePeriod(_amountIn), "FlashProtocol:: MAX_STAKE_PERIOD_EXCEEDS");
343 
344         address staker = msg.sender;
345 
346         uint256 expiration = block.timestamp.add(_expiry);
347         balances[staker] = balances[staker].add(_amountIn);
348 
349         id = keccak256(abi.encodePacked(_amountIn, _expiry, _receiver, staker, block.timestamp));
350 
351         require(stakes[id].staker == address(0), "FlashProtocol:: STAKE_EXISTS");
352 
353         mintedAmount = getMintAmount(_amountIn, _expiry);
354         matchedAmount = getMatchedAmount(mintedAmount);
355 
356         IFlashToken(FLASH_TOKEN).transferFrom(staker, address(this), _amountIn);
357 
358         IFlashToken(FLASH_TOKEN).mint(_receiver, mintedAmount);
359         IFlashToken(FLASH_TOKEN).mint(matchReceiver, matchedAmount);
360 
361         stakes[id] = Stake(_amountIn, _expiry, expiration, mintedAmount, staker, _receiver);
362 
363         if (_receiver.isContract()) {
364             IFlashReceiver(_receiver).receiveFlash(id, _amountIn, expiration, mintedAmount, staker, _data);
365         }
366 
367         emit Staked(id, _amountIn, _expiry, expiration, mintedAmount, staker, _receiver);
368     }
369 
370     function unstake(bytes32 _id) external override returns (uint256 withdrawAmount) {
371         Stake memory s = stakes[_id];
372         require(block.timestamp >= s.expireAfter, "FlashProtol:: STAKE_NOT_EXPIRED");
373         balances[s.staker] = balances[s.staker].sub(s.amountIn);
374         withdrawAmount = s.amountIn;
375         delete stakes[_id];
376         IFlashToken(FLASH_TOKEN).transfer(s.staker, withdrawAmount);
377         emit Unstaked(_id, s.amountIn, s.staker);
378     }
379 
380     function unstakeEarly(bytes32 _id) external override returns (uint256 withdrawAmount) {
381         Stake memory s = stakes[_id];
382         address staker = msg.sender;
383         require(s.staker == staker, "FlashProtocol:: INVALID_STAKER");
384         uint256 remainingTime = (s.expireAfter.sub(block.timestamp));
385         require(s.expiry > remainingTime, "Flash Protocol:: INVALID_UNSTAKE_TIME");
386         uint256 burnAmount = _calculateBurn(s.amountIn, remainingTime, s.expiry);
387         assert(burnAmount <= s.amountIn);
388         balances[staker] = balances[staker].sub(s.amountIn);
389         withdrawAmount = s.amountIn.sub(burnAmount);
390         delete stakes[_id];
391         IFlashToken(FLASH_TOKEN).burn(burnAmount);
392         IFlashToken(FLASH_TOKEN).transfer(staker, withdrawAmount);
393         emit Unstaked(_id, withdrawAmount, staker);
394     }
395 
396     function getMatchedAmount(uint256 _mintedAmount) public view override returns (uint256) {
397         return _mintedAmount.mul(matchRatio).div(10000);
398     }
399 
400     function getMintAmount(uint256 _amountIn, uint256 _expiry) public view override returns (uint256) {
401         return _amountIn.mul(_expiry).mul(getFPY(_amountIn)).div(PRECISION * SECONDS_IN_1_YEAR);
402     }
403 
404     function getFPY(uint256 _amountIn) public view override returns (uint256) {
405         return (PRECISION.sub(getPercentageStaked(_amountIn))).div(2);
406     }
407 
408     function getPercentageStaked(uint256 _amountIn) public view override returns (uint256) {
409         uint256 locked = IFlashToken(FLASH_TOKEN).balanceOf(address(this)).add(_amountIn);
410         return locked.mul(PRECISION).div(IFlashToken(FLASH_TOKEN).totalSupply());
411     }
412 
413     function calculateMaxStakePeriod(uint256 _amountIn) public view override returns (uint256) {
414         return MAX_FPY_FOR_1_YEAR.mul(SECONDS_IN_1_YEAR).div(getFPY(_amountIn));
415     }
416 
417     function _calculateBurn(
418         uint256 _amount,
419         uint256 _remainingTime,
420         uint256 _totalTime
421     ) private pure returns (uint256) {
422         return _amount.mul(_remainingTime).div(_totalTime);
423     }
424 }