1 pragma solidity 0.6.12;
2 
3 interface marketManagerInterface  {
4 	function setOracleProxy(address oracleProxyAddr) external returns (bool);
5 
6 	function setBreakerTable(address _target, bool _status) external returns (bool);
7 
8 	function getCircuitBreaker() external view returns (bool);
9 
10 	function setCircuitBreaker(bool _emergency) external returns (bool);
11 
12 	function getTokenHandlerInfo(uint256 handlerID) external view returns (bool, address, string memory);
13 
14 	function handlerRegister(uint256 handlerID, address tokenHandlerAddr) external returns (bool);
15 
16 	function applyInterestHandlers(address payable userAddr, uint256 callerID, bool allFlag) external returns (uint256, uint256, uint256);
17 
18 	function liquidationApplyInterestHandlers(address payable userAddr, uint256 callerID) external returns (uint256, uint256, uint256, uint256, uint256);
19 
20 	function getTokenHandlerPrice(uint256 handlerID) external view returns (uint256);
21 
22 	function getTokenHandlerBorrowLimit(uint256 handlerID) external view returns (uint256);
23 
24 	function getTokenHandlerSupport(uint256 handlerID) external view returns (bool);
25 
26 	function getTokenHandlersLength() external view returns (uint256);
27 
28 	function setTokenHandlersLength(uint256 _tokenHandlerLength) external returns (bool);
29 
30 	function getTokenHandlerID(uint256 index) external view returns (uint256);
31 
32 	function getTokenHandlerMarginCallLimit(uint256 handlerID) external view returns (uint256);
33 
34 	function getUserIntraHandlerAssetWithInterest(address payable userAddr, uint256 handlerID) external view returns (uint256, uint256);
35 
36 	function getUserTotalIntraCreditAsset(address payable userAddr) external view returns (uint256, uint256);
37 
38 	function getUserLimitIntraAsset(address payable userAddr) external view returns (uint256, uint256);
39 
40 	function getUserCollateralizableAmount(address payable userAddr, uint256 handlerID) external view returns (uint256);
41 
42 	function getUserExtraLiquidityAmount(address payable userAddr, uint256 handlerID) external view returns (uint256);
43 
44 	function partialLiquidationUser(address payable delinquentBorrower, uint256 liquidateAmount, address payable liquidator, uint256 liquidateHandlerID, uint256 rewardHandlerID) external returns (uint256, uint256, uint256);
45 
46 	function getMaxLiquidationReward(address payable delinquentBorrower, uint256 liquidateHandlerID, uint256 liquidateAmount, uint256 rewardHandlerID, uint256 rewardRatio) external view returns (uint256);
47 
48 	function partialLiquidationUserReward(address payable delinquentBorrower, uint256 rewardAmount, address payable liquidator, uint256 handlerID) external returns (uint256);
49 
50 	function setLiquidationManager(address liquidationManagerAddr) external returns (bool);
51 
52 	function rewardClaimAll(address payable userAddr) external returns (bool);
53 
54 	function rewardTransfer(uint256 _claimAmountSum) external returns (bool);
55 
56 	function updateRewardParams(address payable userAddr) external returns (bool);
57 
58 	function interestUpdateReward() external returns (bool);
59 
60 	function getGlobalRewardInfo() external view returns (uint256, uint256, uint256);
61 }
62 
63 interface interestModelInterface  {
64 	function getInterestAmount(address handlerDataStorageAddr, address payable userAddr, bool isView) external view returns (bool, uint256, uint256, bool, uint256, uint256);
65 
66 	function viewInterestAmount(address handlerDataStorageAddr, address payable userAddr) external view returns (bool, uint256, uint256, bool, uint256, uint256);
67 
68 	function getSIRandBIR(address handlerDataStorageAddr, uint256 depositTotalAmount, uint256 borrowTotalAmount) external view returns (uint256, uint256);
69 }
70 
71 interface marketHandlerDataStorageInterface  {
72 	function setCircuitBreaker(bool _emergency) external returns (bool);
73 
74 	function setNewCustomer(address payable userAddr) external returns (bool);
75 
76 	function getUserAccessed(address payable userAddr) external view returns (bool);
77 
78 	function setUserAccessed(address payable userAddr, bool _accessed) external returns (bool);
79 
80 	function getReservedAddr() external view returns (address payable);
81 
82 	function setReservedAddr(address payable reservedAddress) external returns (bool);
83 
84 	function getReservedAmount() external view returns (int256);
85 
86 	function addReservedAmount(uint256 amount) external returns (int256);
87 
88 	function subReservedAmount(uint256 amount) external returns (int256);
89 
90 	function updateSignedReservedAmount(int256 amount) external returns (int256);
91 
92 	function setTokenHandler(address _marketHandlerAddr, address _interestModelAddr) external returns (bool);
93 
94 	function setCoinHandler(address _marketHandlerAddr, address _interestModelAddr) external returns (bool);
95 
96 	function getDepositTotalAmount() external view returns (uint256);
97 
98 	function addDepositTotalAmount(uint256 amount) external returns (uint256);
99 
100 	function subDepositTotalAmount(uint256 amount) external returns (uint256);
101 
102 	function getBorrowTotalAmount() external view returns (uint256);
103 
104 	function addBorrowTotalAmount(uint256 amount) external returns (uint256);
105 
106 	function subBorrowTotalAmount(uint256 amount) external returns (uint256);
107 
108 	function getUserIntraDepositAmount(address payable userAddr) external view returns (uint256);
109 
110 	function addUserIntraDepositAmount(address payable userAddr, uint256 amount) external returns (uint256);
111 
112 	function subUserIntraDepositAmount(address payable userAddr, uint256 amount) external returns (uint256);
113 
114 	function getUserIntraBorrowAmount(address payable userAddr) external view returns (uint256);
115 
116 	function addUserIntraBorrowAmount(address payable userAddr, uint256 amount) external returns (uint256);
117 
118 	function subUserIntraBorrowAmount(address payable userAddr, uint256 amount) external returns (uint256);
119 
120 	function addDepositAmount(address payable userAddr, uint256 amount) external returns (bool);
121 
122 	function addBorrowAmount(address payable userAddr, uint256 amount) external returns (bool);
123 
124 	function subDepositAmount(address payable userAddr, uint256 amount) external returns (bool);
125 
126 	function subBorrowAmount(address payable userAddr, uint256 amount) external returns (bool);
127 
128 	function getUserAmount(address payable userAddr) external view returns (uint256, uint256);
129 
130 	function getHandlerAmount() external view returns (uint256, uint256);
131 
132 	function getAmount(address payable userAddr) external view returns (uint256, uint256, uint256, uint256);
133 
134 	function setAmount(address payable userAddr, uint256 depositTotalAmount, uint256 borrowTotalAmount, uint256 depositAmount, uint256 borrowAmount) external returns (uint256);
135 
136 	function setBlocks(uint256 lastUpdatedBlock, uint256 inactiveActionDelta) external returns (bool);
137 
138 	function getLastUpdatedBlock() external view returns (uint256);
139 
140 	function setLastUpdatedBlock(uint256 _lastUpdatedBlock) external returns (bool);
141 
142 	function getInactiveActionDelta() external view returns (uint256);
143 
144 	function setInactiveActionDelta(uint256 inactiveActionDelta) external returns (bool);
145 
146 	function syncActionEXR() external returns (bool);
147 
148 	function getActionEXR() external view returns (uint256, uint256);
149 
150 	function setActionEXR(uint256 actionDepositExRate, uint256 actionBorrowExRate) external returns (bool);
151 
152 	function getGlobalDepositEXR() external view returns (uint256);
153 
154 	function getGlobalBorrowEXR() external view returns (uint256);
155 
156 	function setEXR(address payable userAddr, uint256 globalDepositEXR, uint256 globalBorrowEXR) external returns (bool);
157 
158 	function getUserEXR(address payable userAddr) external view returns (uint256, uint256);
159 
160 	function setUserEXR(address payable userAddr, uint256 depositEXR, uint256 borrowEXR) external returns (bool);
161 
162 	function getGlobalEXR() external view returns (uint256, uint256);
163 
164 	function getMarketHandlerAddr() external view returns (address);
165 
166 	function setMarketHandlerAddr(address marketHandlerAddr) external returns (bool);
167 
168 	function getInterestModelAddr() external view returns (address);
169 
170 	function setInterestModelAddr(address interestModelAddr) external returns (bool);
171 
172 	function getLimit() external view returns (uint256, uint256);
173 
174 	function getBorrowLimit() external view returns (uint256);
175 
176 	function getMarginCallLimit() external view returns (uint256);
177 
178 	function getMinimumInterestRate() external view returns (uint256);
179 
180 	function getLiquiditySensitivity() external view returns (uint256);
181 
182 	function setBorrowLimit(uint256 _borrowLimit) external returns (bool);
183 
184 	function setMarginCallLimit(uint256 _marginCallLimit) external returns (bool);
185 
186 	function setMinimumInterestRate(uint256 _minimumInterestRate) external returns (bool);
187 
188 	function setLiquiditySensitivity(uint256 _liquiditySensitivity) external returns (bool);
189 
190 	function getLimitOfAction() external view returns (uint256);
191 
192 	function setLimitOfAction(uint256 limitOfAction) external returns (bool);
193 
194 	function getLiquidityLimit() external view returns (uint256);
195 
196 	function setLiquidityLimit(uint256 liquidityLimit) external returns (bool);
197 }
198 
199 interface IERC20  {
200 	function totalSupply() external view returns (uint256);
201 
202 	function balanceOf(address account) external view returns (uint256);
203 
204 	function transfer(address recipient, uint256 amount) external ;
205 
206 	function allowance(address owner, address spender) external view returns (uint256);
207 
208 	function approve(address spender, uint256 amount) external view returns (bool);
209 
210 	function transferFrom(address from, address to, uint256 value) external ;
211 }
212 
213 interface marketSIHandlerDataStorageInterface  {
214 	function setCircuitBreaker(bool _emergency) external returns (bool);
215 
216 	function updateRewardPerBlockStorage(uint256 _rewardPerBlock) external returns (bool);
217 
218 	function getRewardInfo(address userAddr) external view returns (uint256, uint256, uint256, uint256, uint256, uint256);
219 
220 	function getMarketRewardInfo() external view returns (uint256, uint256, uint256);
221 
222 	function setMarketRewardInfo(uint256 _rewardLane, uint256 _rewardLaneUpdateAt, uint256 _rewardPerBlock) external returns (bool);
223 
224 	function getUserRewardInfo(address userAddr) external view returns (uint256, uint256, uint256);
225 
226 	function setUserRewardInfo(address userAddr, uint256 _rewardLane, uint256 _rewardLaneUpdateAt, uint256 _rewardAmount) external returns (bool);
227 
228 	function getBetaRate() external view returns (uint256);
229 
230 	function setBetaRate(uint256 _betaRate) external returns (bool);
231 }
232 
233 contract proxy  {
234 	address payable owner;
235 
236 	uint256 handlerID;
237 
238 	string tokenName;
239 
240 	uint256 constant unifiedPoint = 10 ** 18;
241 
242 	uint256 unifiedTokenDecimal = 10 ** 18;
243 
244 	uint256 underlyingTokenDecimal;
245 
246 	marketManagerInterface marketManager;
247 
248 	interestModelInterface interestModelInstance;
249 
250 	marketHandlerDataStorageInterface handlerDataStorage;
251 
252 	marketSIHandlerDataStorageInterface SIHandlerDataStorage;
253 
254 	IERC20 erc20Instance;
255 
256 	address public handler;
257 
258 	address public SI;
259 
260 	string DEPOSIT = "deposit(uint256,bool)";
261 
262 	string REDEEM = "withdraw(uint256,bool)";
263 
264 	string BORROW = "borrow(uint256,bool)";
265 
266 	string REPAY = "repay(uint256,bool)";
267 
268 	modifier onlyOwner {
269 		require(msg.sender == owner, "Ownable: caller is not the owner");
270 		_;
271 	}
272 
273 	modifier onlyMarketManager {
274 		address msgSender = msg.sender;
275 		require((msgSender == address(marketManager)) || (msgSender == owner), "onlyMarketManager function");
276 		_;
277 	}
278 
279 	constructor () public 
280 	{
281 		owner = msg.sender;
282 	}
283 
284 	function ownershipTransfer(address _owner) onlyOwner external returns (bool)
285 	{
286 		owner = address(uint160(_owner));
287 		return true;
288 	}
289 
290 	function initialize(uint256 _handlerID, address handlerAddr, address marketManagerAddr, address interestModelAddr, address marketDataStorageAddr, address erc20Addr, string memory _tokenName, address siHandlerAddr, address SIHandlerDataStorageAddr) onlyOwner public returns (bool)
291 	{
292 		handlerID = _handlerID;
293 		handler = handlerAddr;
294 		marketManager = marketManagerInterface(marketManagerAddr);
295 		interestModelInstance = interestModelInterface(interestModelAddr);
296 		handlerDataStorage = marketHandlerDataStorageInterface(marketDataStorageAddr);
297 		erc20Instance = IERC20(erc20Addr);
298 		tokenName = _tokenName;
299 		SI = siHandlerAddr;
300 		SIHandlerDataStorage = marketSIHandlerDataStorageInterface(SIHandlerDataStorageAddr);
301 	}
302 
303 	function setHandlerID(uint256 _handlerID) onlyOwner public returns (bool)
304 	{
305 		handlerID = _handlerID;
306 		return true;
307 	}
308 
309 	function setHandlerAddr(address handlerAddr) onlyOwner public returns (bool)
310 	{
311 		handler = handlerAddr;
312 		return true;
313 	}
314 
315 	function setSiHandlerAddr(address siHandlerAddr) onlyOwner public returns (bool)
316 	{
317 		SI = siHandlerAddr;
318 		return true;
319 	}
320 
321 	function getHandlerID() public view returns (uint256)
322 	{
323 		return handlerID;
324 	}
325 
326 	function getHandlerAddr() public view returns (address)
327 	{
328 		return handler;
329 	}
330 
331 	function getSiHandlerAddr() public view returns (address)
332 	{
333 		return SI;
334 	}
335 
336 	function migration(address target) onlyOwner public returns (bool)
337 	{
338 		uint256 balance = erc20Instance.balanceOf(address(this));
339 		erc20Instance.transfer(target, balance);
340 	}
341 
342 	function deposit(uint256 unifiedTokenAmount, bool flag) public payable returns (bool)
343 	{
344 		bool result;
345 		bytes memory returnData;
346 		bytes memory data = abi.encodeWithSignature(DEPOSIT, unifiedTokenAmount, flag);
347 		(result, returnData) = handler.delegatecall(data);
348 		require(result, string(returnData));
349 		return result;
350 	}
351 
352 	function withdraw(uint256 unifiedTokenAmount, bool flag) public returns (bool)
353 	{
354 		bool result;
355 		bytes memory returnData;
356 		bytes memory data = abi.encodeWithSignature(REDEEM, unifiedTokenAmount, flag);
357 		(result, returnData) = handler.delegatecall(data);
358 		require(result, string(returnData));
359 		return result;
360 	}
361 
362 	function borrow(uint256 unifiedTokenAmount, bool flag) public returns (bool)
363 	{
364 		bool result;
365 		bytes memory returnData;
366 		bytes memory data = abi.encodeWithSignature(BORROW, unifiedTokenAmount, flag);
367 		(result, returnData) = handler.delegatecall(data);
368 		require(result, string(returnData));
369 		return result;
370 	}
371 
372 	function repay(uint256 unifiedTokenAmount, bool flag) public payable returns (bool)
373 	{
374 		bool result;
375 		bytes memory returnData;
376 		bytes memory data = abi.encodeWithSignature(REPAY, unifiedTokenAmount, flag);
377 		(result, returnData) = handler.delegatecall(data);
378 		require(result, string(returnData));
379 		return result;
380 	}
381 
382 	function handlerProxy(bytes memory data) onlyMarketManager external returns (bool, bytes memory)
383 	{
384 		bool result;
385 		bytes memory returnData;
386 		(result, returnData) = handler.delegatecall(data);
387 		require(result, string(returnData));
388 		return (result, returnData);
389 	}
390 
391 	function handlerViewProxy(bytes memory data) external returns (bool, bytes memory)
392 	{
393 		bool result;
394 		bytes memory returnData;
395 		(result, returnData) = handler.delegatecall(data);
396 		require(result, string(returnData));
397 		return (result, returnData);
398 	}
399 
400 	function siProxy(bytes memory data) onlyMarketManager external returns (bool, bytes memory)
401 	{
402 		bool result;
403 		bytes memory returnData;
404 		(result, returnData) = SI.delegatecall(data);
405 		require(result, string(returnData));
406 		return (result, returnData);
407 	}
408 
409 	function siViewProxy(bytes memory data) external returns (bool, bytes memory)
410 	{
411 		bool result;
412 		bytes memory returnData;
413 		(result, returnData) = SI.delegatecall(data);
414 		require(result, string(returnData));
415 		return (result, returnData);
416 	}
417 }
418 
419 contract UsdtHandlerProxy is proxy {
420     constructor()
421     proxy() public {}
422 }