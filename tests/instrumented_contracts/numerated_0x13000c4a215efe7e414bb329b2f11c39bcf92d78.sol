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
195 interface marketSIHandlerDataStorageInterface  {
196 	function setCircuitBreaker(bool _emergency) external returns (bool);
197 
198 	function updateRewardPerBlockStorage(uint256 _rewardPerBlock) external returns (bool);
199 
200 	function getRewardInfo(address userAddr) external view returns (uint256, uint256, uint256, uint256, uint256, uint256);
201 
202 	function getMarketRewardInfo() external view returns (uint256, uint256, uint256);
203 
204 	function setMarketRewardInfo(uint256 _rewardLane, uint256 _rewardLaneUpdateAt, uint256 _rewardPerBlock) external returns (bool);
205 
206 	function getUserRewardInfo(address userAddr) external view returns (uint256, uint256, uint256);
207 
208 	function setUserRewardInfo(address userAddr, uint256 _rewardLane, uint256 _rewardLaneUpdateAt, uint256 _rewardAmount) external returns (bool);
209 
210 	function getBetaRate() external view returns (uint256);
211 
212 	function setBetaRate(uint256 _betaRate) external returns (bool);
213 }
214 contract proxy  {
215 	address payable owner;
216 
217 	uint256 handlerID;
218 
219 	string tokenName = "ether";
220 
221 	uint256 constant unifiedPoint = 10 ** 18;
222 
223 	marketManagerInterface marketManager;
224 
225 	interestModelInterface interestModelInstance;
226 
227 	marketHandlerDataStorageInterface handlerDataStorage;
228 
229 	marketSIHandlerDataStorageInterface SIHandlerDataStorage;
230 
231 	address public handler;
232 
233 	address public SI;
234 
235 	string DEPOSIT = "deposit(uint256,bool)";
236 
237 	string REDEEM = "withdraw(uint256,bool)";
238 
239 	string BORROW = "borrow(uint256,bool)";
240 
241 	string REPAY = "repay(uint256,bool)";
242 
243 	modifier onlyOwner {
244 		require(msg.sender == owner, "Ownable: caller is not the owner");
245 		_;
246 	}
247 
248 	modifier onlyMarketManager {
249 		address msgSender = msg.sender;
250 		require((msgSender == address(marketManager)) || (msgSender == owner), "onlyMarketManager function");
251 		_;
252 	}
253 
254 	constructor () public 
255 	{
256 		owner = msg.sender;
257 	}
258 
259 	function ownershipTransfer(address _owner) onlyOwner external returns (bool)
260 	{
261 		owner = address(uint160(_owner));
262 		return true;
263 	}
264 
265 	function initialize(uint256 _handlerID, address handlerAddr, address marketManagerAddr, address interestModelAddr, address marketDataStorageAddr, address siHandlerAddr, address SIHandlerDataStorageAddr) onlyOwner public returns (bool)
266 	{
267 		handlerID = _handlerID;
268 		handler = handlerAddr;
269 		SI = siHandlerAddr;
270 		marketManager = marketManagerInterface(marketManagerAddr);
271 		interestModelInstance = interestModelInterface(interestModelAddr);
272 		handlerDataStorage = marketHandlerDataStorageInterface(marketDataStorageAddr);
273 		SIHandlerDataStorage = marketSIHandlerDataStorageInterface(SIHandlerDataStorageAddr);
274 	}
275 
276 	function setHandlerID(uint256 _handlerID) onlyOwner public returns (bool)
277 	{
278 		handlerID = _handlerID;
279 		return true;
280 	}
281 
282 	function setHandlerAddr(address handlerAddr) onlyOwner public returns (bool)
283 	{
284 		handler = handlerAddr;
285 		return true;
286 	}
287 
288 	function setSiHandlerAddr(address siHandlerAddr) onlyOwner public returns (bool)
289 	{
290 		SI = siHandlerAddr;
291 		return true;
292 	}
293 
294 	function getHandlerID() public view returns (uint256)
295 	{
296 		return handlerID;
297 	}
298 
299 	function getHandlerAddr() public view returns (address)
300 	{
301 		return handler;
302 	}
303 
304 	function getSiHandlerAddr() public view returns (address)
305 	{
306 		return SI;
307 	}
308 
309 	function migration(address payable target) onlyOwner public returns (bool)
310 	{
311 		target.transfer(address(this).balance);
312 	}
313 
314 	fallback () external payable 
315 	{
316 		require(msg.value != 0, "DEPOSIT use unifiedTokenAmount");
317 	}
318 
319 	function deposit(uint256 unifiedTokenAmount, bool flag) public payable returns (bool)
320 	{
321 		bool result;
322 		bytes memory returnData;
323 		bytes memory data = abi.encodeWithSignature(DEPOSIT, unifiedTokenAmount, flag);
324 		(result, returnData) = handler.delegatecall(data);
325 		require(result, string(returnData));
326 		return result;
327 	}
328 
329 	function withdraw(uint256 unifiedTokenAmount, bool flag) public returns (bool)
330 	{
331 		bool result;
332 		bytes memory returnData;
333 		bytes memory data = abi.encodeWithSignature(REDEEM, unifiedTokenAmount, flag);
334 		(result, returnData) = handler.delegatecall(data);
335 		require(result, string(returnData));
336 		return result;
337 	}
338 
339 	function borrow(uint256 unifiedTokenAmount, bool flag) public returns (bool)
340 	{
341 		bool result;
342 		bytes memory returnData;
343 		bytes memory data = abi.encodeWithSignature(BORROW, unifiedTokenAmount, flag);
344 		(result, returnData) = handler.delegatecall(data);
345 		require(result, string(returnData));
346 		return result;
347 	}
348 
349 	function repay(uint256 unifiedTokenAmount, bool flag) public payable returns (bool)
350 	{
351 		bool result;
352 		bytes memory returnData;
353 		bytes memory data = abi.encodeWithSignature(REPAY, unifiedTokenAmount, flag);
354 		(result, returnData) = handler.delegatecall(data);
355 		require(result, string(returnData));
356 		return result;
357 	}
358 
359 	function handlerProxy(bytes memory data) onlyMarketManager external returns (bool, bytes memory)
360 	{
361 		bool result;
362 		bytes memory returnData;
363 		(result, returnData) = handler.delegatecall(data);
364 		require(result, string(returnData));
365 		return (result, returnData);
366 	}
367 
368 	function handlerViewProxy(bytes memory data) external returns (bool, bytes memory)
369 	{
370 		bool result;
371 		bytes memory returnData;
372 		(result, returnData) = handler.delegatecall(data);
373 		require(result, string(returnData));
374 		return (result, returnData);
375 	}
376 
377 	function siProxy(bytes memory data) onlyMarketManager external returns (bool, bytes memory)
378 	{
379 		bool result;
380 		bytes memory returnData;
381 		(result, returnData) = SI.delegatecall(data);
382 		require(result, string(returnData));
383 		return (result, returnData);
384 	}
385 
386 	function siViewProxy(bytes memory data) external returns (bool, bytes memory)
387 	{
388 		bool result;
389 		bytes memory returnData;
390 		(result, returnData) = SI.delegatecall(data);
391 		require(result, string(returnData));
392 		return (result, returnData);
393 	}
394 }
395 contract CoinHandlerProxy is proxy {
396     constructor()
397     proxy() public {}
398 }