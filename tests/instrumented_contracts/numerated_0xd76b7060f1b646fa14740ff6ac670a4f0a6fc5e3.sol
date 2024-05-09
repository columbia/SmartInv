1 pragma solidity 0.6.12;
2 interface marketManagerInterface  {
3 	function setOracleProxy(address oracleProxyAddr) external returns (bool);
4 
5 	function setBreakerTable(address _target, bool _status) external returns (bool);
6 
7 	function getCircuitBreaker() external view returns (bool);
8 
9 	function setCircuitBreaker(bool _emergency) external returns (bool);
10 
11 	function getTokenHandlerInfo(uint256 handlerID) external view returns (bool, address, string memory);
12 
13 	function handlerRegister(uint256 handlerID, address tokenHandlerAddr) external returns (bool);
14 
15 	function applyInterestHandlers(address payable userAddr, uint256 callerID, bool allFlag) external returns (uint256, uint256, uint256);
16 
17 	function liquidationApplyInterestHandlers(address payable userAddr, uint256 callerID) external returns (uint256, uint256, uint256, uint256, uint256);
18 
19 	function getTokenHandlerPrice(uint256 handlerID) external view returns (uint256);
20 
21 	function getTokenHandlerBorrowLimit(uint256 handlerID) external view returns (uint256);
22 
23 	function getTokenHandlerSupport(uint256 handlerID) external view returns (bool);
24 
25 	function getTokenHandlersLength() external view returns (uint256);
26 
27 	function setTokenHandlersLength(uint256 _tokenHandlerLength) external returns (bool);
28 
29 	function getTokenHandlerID(uint256 index) external view returns (uint256);
30 
31 	function getTokenHandlerMarginCallLimit(uint256 handlerID) external view returns (uint256);
32 
33 	function getUserIntraHandlerAssetWithInterest(address payable userAddr, uint256 handlerID) external view returns (uint256, uint256);
34 
35 	function getUserTotalIntraCreditAsset(address payable userAddr) external view returns (uint256, uint256);
36 
37 	function getUserLimitIntraAsset(address payable userAddr) external view returns (uint256, uint256);
38 
39 	function getUserCollateralizableAmount(address payable userAddr, uint256 handlerID) external view returns (uint256);
40 
41 	function getUserExtraLiquidityAmount(address payable userAddr, uint256 handlerID) external view returns (uint256);
42 
43 	function partialLiquidationUser(address payable delinquentBorrower, uint256 liquidateAmount, address payable liquidator, uint256 liquidateHandlerID, uint256 rewardHandlerID) external returns (uint256, uint256, uint256);
44 
45 	function getMaxLiquidationReward(address payable delinquentBorrower, uint256 liquidateHandlerID, uint256 liquidateAmount, uint256 rewardHandlerID, uint256 rewardRatio) external view returns (uint256);
46 
47 	function partialLiquidationUserReward(address payable delinquentBorrower, uint256 rewardAmount, address payable liquidator, uint256 handlerID) external returns (uint256);
48 
49 	function setLiquidationManager(address liquidationManagerAddr) external returns (bool);
50 
51 	function rewardClaimAll(address payable userAddr) external returns (bool);
52 
53 	function rewardTransfer(uint256 _claimAmountSum) external returns (bool);
54 
55 	function updateRewardParams(address payable userAddr) external returns (bool);
56 
57 	function interestUpdateReward() external returns (bool);
58 
59 	function getGlobalRewardInfo() external view returns (uint256, uint256, uint256);
60 }
61 interface interestModelInterface  {
62 	function getInterestAmount(address handlerDataStorageAddr, address payable userAddr, bool isView) external view returns (bool, uint256, uint256, bool, uint256, uint256);
63 
64 	function viewInterestAmount(address handlerDataStorageAddr, address payable userAddr) external view returns (bool, uint256, uint256, bool, uint256, uint256);
65 
66 	function getSIRandBIR(address handlerDataStorageAddr, uint256 depositTotalAmount, uint256 borrowTotalAmount) external view returns (uint256, uint256);
67 }
68 interface marketHandlerDataStorageInterface  {
69 	function setCircuitBreaker(bool _emergency) external returns (bool);
70 
71 	function setNewCustomer(address payable userAddr) external returns (bool);
72 
73 	function getUserAccessed(address payable userAddr) external view returns (bool);
74 
75 	function setUserAccessed(address payable userAddr, bool _accessed) external returns (bool);
76 
77 	function getReservedAddr() external view returns (address payable);
78 
79 	function setReservedAddr(address payable reservedAddress) external returns (bool);
80 
81 	function getReservedAmount() external view returns (int256);
82 
83 	function addReservedAmount(uint256 amount) external returns (int256);
84 
85 	function subReservedAmount(uint256 amount) external returns (int256);
86 
87 	function updateSignedReservedAmount(int256 amount) external returns (int256);
88 
89 	function setTokenHandler(address _marketHandlerAddr, address _interestModelAddr) external returns (bool);
90 
91 	function setCoinHandler(address _marketHandlerAddr, address _interestModelAddr) external returns (bool);
92 
93 	function getDepositTotalAmount() external view returns (uint256);
94 
95 	function addDepositTotalAmount(uint256 amount) external returns (uint256);
96 
97 	function subDepositTotalAmount(uint256 amount) external returns (uint256);
98 
99 	function getBorrowTotalAmount() external view returns (uint256);
100 
101 	function addBorrowTotalAmount(uint256 amount) external returns (uint256);
102 
103 	function subBorrowTotalAmount(uint256 amount) external returns (uint256);
104 
105 	function getUserIntraDepositAmount(address payable userAddr) external view returns (uint256);
106 
107 	function addUserIntraDepositAmount(address payable userAddr, uint256 amount) external returns (uint256);
108 
109 	function subUserIntraDepositAmount(address payable userAddr, uint256 amount) external returns (uint256);
110 
111 	function getUserIntraBorrowAmount(address payable userAddr) external view returns (uint256);
112 
113 	function addUserIntraBorrowAmount(address payable userAddr, uint256 amount) external returns (uint256);
114 
115 	function subUserIntraBorrowAmount(address payable userAddr, uint256 amount) external returns (uint256);
116 
117 	function addDepositAmount(address payable userAddr, uint256 amount) external returns (bool);
118 
119 	function addBorrowAmount(address payable userAddr, uint256 amount) external returns (bool);
120 
121 	function subDepositAmount(address payable userAddr, uint256 amount) external returns (bool);
122 
123 	function subBorrowAmount(address payable userAddr, uint256 amount) external returns (bool);
124 
125 	function getUserAmount(address payable userAddr) external view returns (uint256, uint256);
126 
127 	function getHandlerAmount() external view returns (uint256, uint256);
128 
129 	function getAmount(address payable userAddr) external view returns (uint256, uint256, uint256, uint256);
130 
131 	function setAmount(address payable userAddr, uint256 depositTotalAmount, uint256 borrowTotalAmount, uint256 depositAmount, uint256 borrowAmount) external returns (uint256);
132 
133 	function setBlocks(uint256 lastUpdatedBlock, uint256 inactiveActionDelta) external returns (bool);
134 
135 	function getLastUpdatedBlock() external view returns (uint256);
136 
137 	function setLastUpdatedBlock(uint256 _lastUpdatedBlock) external returns (bool);
138 
139 	function getInactiveActionDelta() external view returns (uint256);
140 
141 	function setInactiveActionDelta(uint256 inactiveActionDelta) external returns (bool);
142 
143 	function syncActionEXR() external returns (bool);
144 
145 	function getActionEXR() external view returns (uint256, uint256);
146 
147 	function setActionEXR(uint256 actionDepositExRate, uint256 actionBorrowExRate) external returns (bool);
148 
149 	function getGlobalDepositEXR() external view returns (uint256);
150 
151 	function getGlobalBorrowEXR() external view returns (uint256);
152 
153 	function setEXR(address payable userAddr, uint256 globalDepositEXR, uint256 globalBorrowEXR) external returns (bool);
154 
155 	function getUserEXR(address payable userAddr) external view returns (uint256, uint256);
156 
157 	function setUserEXR(address payable userAddr, uint256 depositEXR, uint256 borrowEXR) external returns (bool);
158 
159 	function getGlobalEXR() external view returns (uint256, uint256);
160 
161 	function getMarketHandlerAddr() external view returns (address);
162 
163 	function setMarketHandlerAddr(address marketHandlerAddr) external returns (bool);
164 
165 	function getInterestModelAddr() external view returns (address);
166 
167 	function setInterestModelAddr(address interestModelAddr) external returns (bool);
168 
169 	function getLimit() external view returns (uint256, uint256);
170 
171 	function getBorrowLimit() external view returns (uint256);
172 
173 	function getMarginCallLimit() external view returns (uint256);
174 
175 	function getMinimumInterestRate() external view returns (uint256);
176 
177 	function getLiquiditySensitivity() external view returns (uint256);
178 
179 	function setBorrowLimit(uint256 _borrowLimit) external returns (bool);
180 
181 	function setMarginCallLimit(uint256 _marginCallLimit) external returns (bool);
182 
183 	function setMinimumInterestRate(uint256 _minimumInterestRate) external returns (bool);
184 
185 	function setLiquiditySensitivity(uint256 _liquiditySensitivity) external returns (bool);
186 
187 	function getLimitOfAction() external view returns (uint256);
188 
189 	function setLimitOfAction(uint256 limitOfAction) external returns (bool);
190 
191 	function getLiquidityLimit() external view returns (uint256);
192 
193 	function setLiquidityLimit(uint256 liquidityLimit) external returns (bool);
194 }
195 interface IERC20  {
196 	function totalSupply() external view returns (uint256);
197 
198 	function balanceOf(address account) external view returns (uint256);
199 
200 	function transfer(address recipient, uint256 amount) external ;
201 
202 	function allowance(address owner, address spender) external view returns (uint256);
203 
204 	function approve(address spender, uint256 amount) external view returns (bool);
205 
206 	function transferFrom(address from, address to, uint256 value) external ;
207 }
208 interface marketSIHandlerDataStorageInterface  {
209 	function setCircuitBreaker(bool _emergency) external returns (bool);
210 
211 	function updateRewardPerBlockStorage(uint256 _rewardPerBlock) external returns (bool);
212 
213 	function getRewardInfo(address userAddr) external view returns (uint256, uint256, uint256, uint256, uint256, uint256);
214 
215 	function getMarketRewardInfo() external view returns (uint256, uint256, uint256);
216 
217 	function setMarketRewardInfo(uint256 _rewardLane, uint256 _rewardLaneUpdateAt, uint256 _rewardPerBlock) external returns (bool);
218 
219 	function getUserRewardInfo(address userAddr) external view returns (uint256, uint256, uint256);
220 
221 	function setUserRewardInfo(address userAddr, uint256 _rewardLane, uint256 _rewardLaneUpdateAt, uint256 _rewardAmount) external returns (bool);
222 
223 	function getBetaRate() external view returns (uint256);
224 
225 	function setBetaRate(uint256 _betaRate) external returns (bool);
226 }
227 contract proxy  {
228 	address payable owner;
229 
230 	uint256 handlerID;
231 
232 	string tokenName;
233 
234 	uint256 constant unifiedPoint = 10 ** 18;
235 
236 	uint256 unifiedTokenDecimal = 10 ** 18;
237 
238 	uint256 underlyingTokenDecimal;
239 
240 	marketManagerInterface marketManager;
241 
242 	interestModelInterface interestModelInstance;
243 
244 	marketHandlerDataStorageInterface handlerDataStorage;
245 
246 	marketSIHandlerDataStorageInterface SIHandlerDataStorage;
247 
248 	IERC20 erc20Instance;
249 
250 	address public handler;
251 
252 	address public SI;
253 
254 	string DEPOSIT = "deposit(uint256,bool)";
255 
256 	string REDEEM = "withdraw(uint256,bool)";
257 
258 	string BORROW = "borrow(uint256,bool)";
259 
260 	string REPAY = "repay(uint256,bool)";
261 
262 	modifier onlyOwner {
263 		require(msg.sender == owner, "Ownable: caller is not the owner");
264 		_;
265 	}
266 
267 	modifier onlyMarketManager {
268 		address msgSender = msg.sender;
269 		require((msgSender == address(marketManager)) || (msgSender == owner), "onlyMarketManager function");
270 		_;
271 	}
272 
273 	constructor () public 
274 	{
275 		owner = msg.sender;
276 	}
277 
278 	function ownershipTransfer(address _owner) onlyOwner external returns (bool)
279 	{
280 		owner = address(uint160(_owner));
281 		return true;
282 	}
283 
284 	function initialize(uint256 _handlerID, address handlerAddr, address marketManagerAddr, address interestModelAddr, address marketDataStorageAddr, address erc20Addr, string memory _tokenName, address siHandlerAddr, address SIHandlerDataStorageAddr) onlyOwner public returns (bool)
285 	{
286 		handlerID = _handlerID;
287 		handler = handlerAddr;
288 		marketManager = marketManagerInterface(marketManagerAddr);
289 		interestModelInstance = interestModelInterface(interestModelAddr);
290 		handlerDataStorage = marketHandlerDataStorageInterface(marketDataStorageAddr);
291 		erc20Instance = IERC20(erc20Addr);
292 		tokenName = _tokenName;
293 		SI = siHandlerAddr;
294 		SIHandlerDataStorage = marketSIHandlerDataStorageInterface(SIHandlerDataStorageAddr);
295 	}
296 
297 	function setHandlerID(uint256 _handlerID) onlyOwner public returns (bool)
298 	{
299 		handlerID = _handlerID;
300 		return true;
301 	}
302 
303 	function setHandlerAddr(address handlerAddr) onlyOwner public returns (bool)
304 	{
305 		handler = handlerAddr;
306 		return true;
307 	}
308 
309 	function setSiHandlerAddr(address siHandlerAddr) onlyOwner public returns (bool)
310 	{
311 		SI = siHandlerAddr;
312 		return true;
313 	}
314 
315 	function getHandlerID() public view returns (uint256)
316 	{
317 		return handlerID;
318 	}
319 
320 	function getHandlerAddr() public view returns (address)
321 	{
322 		return handler;
323 	}
324 
325 	function getSiHandlerAddr() public view returns (address)
326 	{
327 		return SI;
328 	}
329 
330 	function migration(address target) onlyOwner public returns (bool)
331 	{
332 		uint256 balance = erc20Instance.balanceOf(address(this));
333 		erc20Instance.transfer(target, balance);
334 	}
335 
336 	function deposit(uint256 unifiedTokenAmount, bool flag) public payable returns (bool)
337 	{
338 		bool result;
339 		bytes memory returnData;
340 		bytes memory data = abi.encodeWithSignature(DEPOSIT, unifiedTokenAmount, flag);
341 		(result, returnData) = handler.delegatecall(data);
342 		require(result, string(returnData));
343 		return result;
344 	}
345 
346 	function withdraw(uint256 unifiedTokenAmount, bool flag) public returns (bool)
347 	{
348 		bool result;
349 		bytes memory returnData;
350 		bytes memory data = abi.encodeWithSignature(REDEEM, unifiedTokenAmount, flag);
351 		(result, returnData) = handler.delegatecall(data);
352 		require(result, string(returnData));
353 		return result;
354 	}
355 
356 	function borrow(uint256 unifiedTokenAmount, bool flag) public returns (bool)
357 	{
358 		bool result;
359 		bytes memory returnData;
360 		bytes memory data = abi.encodeWithSignature(BORROW, unifiedTokenAmount, flag);
361 		(result, returnData) = handler.delegatecall(data);
362 		require(result, string(returnData));
363 		return result;
364 	}
365 
366 	function repay(uint256 unifiedTokenAmount, bool flag) public payable returns (bool)
367 	{
368 		bool result;
369 		bytes memory returnData;
370 		bytes memory data = abi.encodeWithSignature(REPAY, unifiedTokenAmount, flag);
371 		(result, returnData) = handler.delegatecall(data);
372 		require(result, string(returnData));
373 		return result;
374 	}
375 
376 	function handlerProxy(bytes memory data) onlyMarketManager external returns (bool, bytes memory)
377 	{
378 		bool result;
379 		bytes memory returnData;
380 		(result, returnData) = handler.delegatecall(data);
381 		require(result, string(returnData));
382 		return (result, returnData);
383 	}
384 
385 	function handlerViewProxy(bytes memory data) external returns (bool, bytes memory)
386 	{
387 		bool result;
388 		bytes memory returnData;
389 		(result, returnData) = handler.delegatecall(data);
390 		require(result, string(returnData));
391 		return (result, returnData);
392 	}
393 
394 	function siProxy(bytes memory data) onlyMarketManager external returns (bool, bytes memory)
395 	{
396 		bool result;
397 		bytes memory returnData;
398 		(result, returnData) = SI.delegatecall(data);
399 		require(result, string(returnData));
400 		return (result, returnData);
401 	}
402 
403 	function siViewProxy(bytes memory data) external returns (bool, bytes memory)
404 	{
405 		bool result;
406 		bytes memory returnData;
407 		(result, returnData) = SI.delegatecall(data);
408 		require(result, string(returnData));
409 		return (result, returnData);
410 	}
411 }
412 
413 contract DaiHandlerProxy is proxy{
414     constructor()
415     proxy() public {}
416 }