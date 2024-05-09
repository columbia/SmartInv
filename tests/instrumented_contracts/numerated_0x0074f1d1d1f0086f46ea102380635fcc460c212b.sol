1 // File: contracts\amm-aggregator\common\AMMData.sol
2 
3 //SPDX-License-Identifier: MIT
4 pragma solidity ^0.7.6;
5 
6 struct LiquidityPoolData {
7     address liquidityPoolAddress;
8     uint256 amount;
9     address tokenAddress;
10     bool amountIsLiquidityPool;
11     bool involvingETH;
12     address receiver;
13 }
14 
15 struct SwapData {
16     bool enterInETH;
17     bool exitInETH;
18     address[] liquidityPoolAddresses;
19     address[] path;
20     address inputToken;
21     uint256 amount;
22     address receiver;
23 }
24 
25 // File: contracts\amm-aggregator\common\IAMM.sol
26 
27 //SPDX_License_Identifier: MIT
28 pragma solidity ^0.7.6;
29 pragma abicoder v2;
30 
31 
32 interface IAMM {
33 
34     event NewLiquidityPoolAddress(address indexed);
35 
36     function info() external view returns(string memory name, uint256 version);
37 
38     function data() external view returns(address ethereumAddress, uint256 maxTokensPerLiquidityPool, bool hasUniqueLiquidityPools);
39 
40     function balanceOf(address liquidityPoolAddress, address owner) external view returns(uint256, uint256[] memory, address[] memory);
41 
42     function byLiquidityPool(address liquidityPoolAddress) external view returns(uint256, uint256[] memory, address[] memory);
43 
44     function byTokens(address[] calldata liquidityPoolTokens) external view returns(uint256, uint256[] memory, address, address[] memory);
45 
46     function byPercentage(address liquidityPoolAddress, uint256 numerator, uint256 denominator) external view returns (uint256, uint256[] memory, address[] memory);
47 
48     function byLiquidityPoolAmount(address liquidityPoolAddress, uint256 liquidityPoolAmount) external view returns(uint256[] memory, address[] memory);
49 
50     function byTokenAmount(address liquidityPoolAddress, address tokenAddress, uint256 tokenAmount) external view returns(uint256, uint256[] memory, address[] memory);
51 
52     function createLiquidityPoolAndAddLiquidity(address[] calldata tokenAddresses, uint256[] calldata amounts, bool involvingETH, address receiver) external payable returns(uint256, uint256[] memory, address, address[] memory);
53 
54     function addLiquidity(LiquidityPoolData calldata data) external payable returns(uint256, uint256[] memory, address[] memory);
55     function addLiquidityBatch(LiquidityPoolData[] calldata data) external payable returns(uint256[] memory, uint256[][] memory, address[][] memory);
56 
57     function removeLiquidity(LiquidityPoolData calldata data) external returns(uint256, uint256[] memory, address[] memory);
58     function removeLiquidityBatch(LiquidityPoolData[] calldata data) external returns(uint256[] memory, uint256[][] memory, address[][] memory);
59 
60     function getSwapOutput(address tokenAddress, uint256 tokenAmount, address[] calldata, address[] calldata path) view external returns(uint256[] memory);
61 
62     function swapLiquidity(SwapData calldata data) external payable returns(uint256);
63     function swapLiquidityBatch(SwapData[] calldata data) external payable returns(uint256[] memory);
64 }
65 
66 // File: contracts\farming\FarmData.sol
67 
68 //SPDX_License_Identifier: MIT
69 pragma solidity ^0.7.6;
70 
71 struct FarmingPositionRequest {
72     uint256 setupIndex; // index of the chosen setup.
73     uint256 amount; // amount of main token or liquidity pool token.
74     bool amountIsLiquidityPool; //true if user wants to directly share the liquidity pool token amount, false to add liquidity to AMM
75     address positionOwner; // position extension or address(0) [msg.sender].
76 }
77 
78 struct FarmingSetupConfiguration {
79     bool add; // true if we're adding a new setup, false we're updating it.
80     bool disable;
81     uint256 index; // index of the setup we're updating.
82     FarmingSetupInfo info; // data of the new or updated setup
83 }
84 
85 struct FarmingSetupInfo {
86     bool free; // if the setup is a free farming setup or a locked one.
87     uint256 blockDuration; // duration of setup
88     uint256 originalRewardPerBlock;
89     uint256 minStakeable; // minimum amount of staking tokens.
90     uint256 maxStakeable; // maximum amount stakeable in the setup (used only if free is false).
91     uint256 renewTimes; // if the setup is renewable or if it's one time.
92     address ammPlugin; // amm plugin address used for this setup (eg. uniswap amm plugin address).
93     address liquidityPoolTokenAddress; // address of the liquidity pool token
94     address mainTokenAddress; // eg. buidl address.
95     address ethereumAddress;
96     bool involvingETH; // if the setup involves ETH or not.
97     uint256 penaltyFee; // fee paid when the user exits a still active locked farming setup (used only if free is false).
98     uint256 setupsCount; // number of setups created by this info.
99     uint256 lastSetupIndex; // index of last setup;
100 }
101 
102 struct FarmingSetup {
103     uint256 infoIndex; // setup info
104     bool active; // if the setup is active or not.
105     uint256 startBlock; // farming setup start block.
106     uint256 endBlock; // farming setup end block.
107     uint256 lastUpdateBlock; // number of the block where an update was triggered.
108     uint256 objectId; // items object id for the liquidity pool token (used only if free is false).
109     uint256 rewardPerBlock; // farming setup reward per single block.
110     uint256 totalSupply; // If free it's the LP amount, if locked is currentlyStaked.
111 }
112 
113 struct FarmingPosition {
114     address uniqueOwner; // address representing the owner of the position.
115     uint256 setupIndex; // the setup index related to this position.
116     uint256 creationBlock; // block when this position was created.
117     uint256 liquidityPoolTokenAmount; // amount of liquidity pool token in the position.
118     uint256 mainTokenAmount; // amount of main token in the position (used only if free is false).
119     uint256 reward; // position reward (used only if free is false).
120     uint256 lockedRewardPerBlock; // position locked reward per block (used only if free is false).
121 }
122 
123 // File: contracts\farming\IFarmMain.sol
124 
125 //SPDX_License_Identifier: MIT
126 pragma solidity ^0.7.6;
127 //pragma abicoder v2;
128 
129 
130 interface IFarmMain {
131 
132     function ONE_HUNDRED() external view returns(uint256);
133     function _rewardTokenAddress() external view returns(address);
134     function position(uint256 positionId) external view returns (FarmingPosition memory);
135     function setups() external view returns (FarmingSetup[] memory);
136     function setup(uint256 setupIndex) external view returns (FarmingSetup memory, FarmingSetupInfo memory);
137     function setFarmingSetups(FarmingSetupConfiguration[] memory farmingSetups) external;
138     function openPosition(FarmingPositionRequest calldata request) external payable returns(uint256 positionId);
139     function addLiquidity(uint256 positionId, FarmingPositionRequest calldata request) external payable;
140 }
141 
142 // File: contracts\farming\IFarmExtension.sol
143 
144 //SPDX_License_Identifier: MIT
145 pragma solidity ^0.7.6;
146 //pragma abicoder v2;
147 
148 
149 interface IFarmExtension {
150 
151     function init(bool byMint, address host, address treasury) external;
152 
153     function setHost(address host) external;
154     function setTreasury(address treasury) external;
155 
156     function data() external view returns(address farmMainContract, bool byMint, address host, address treasury, address rewardTokenAddress);
157 
158     function transferTo(uint256 amount) external;
159     function backToYou(uint256 amount) external payable;
160 
161     function setFarmingSetups(FarmingSetupConfiguration[] memory farmingSetups) external;
162 
163 }
164 
165 // File: contracts\farming\IFarmFactory.sol
166 
167 //SPDX_License_Identifier: MIT
168 pragma solidity ^0.7.6;
169 
170 interface IFarmFactory {
171 
172     event ExtensionCloned(address indexed);
173 
174     function feePercentageInfo() external view returns (uint256, address);
175     function farmDefaultExtension() external view returns(address);
176     function cloneFarmDefaultExtension() external returns(address);
177     function getFarmTokenCollectionURI() external view returns (string memory);
178     function getFarmTokenURI() external view returns (string memory);
179 }
180 
181 // File: contracts\farming\util\ERC1155Receiver.sol
182 
183 // File: contracts/usd-v2/util/ERC1155Receiver.sol
184 
185 // SPDX_License_Identifier: MIT
186 
187 pragma solidity ^0.7.6;
188 
189 abstract contract ERC1155Receiver {
190     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
191 
192     mapping(bytes4 => bool) private _supportedInterfaces;
193 
194     constructor() {
195         _registerInterface(_INTERFACE_ID_ERC165);
196         _registerInterface(
197             ERC1155Receiver(0).onERC1155Received.selector ^
198             ERC1155Receiver(0).onERC1155BatchReceived.selector
199         );
200     }
201 
202     function supportsInterface(bytes4 interfaceId) public view returns (bool) {
203         return _supportedInterfaces[interfaceId];
204     }
205 
206     function _registerInterface(bytes4 interfaceId) internal virtual {
207         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
208         _supportedInterfaces[interfaceId] = true;
209     }
210 
211     function onERC1155Received(
212         address operator,
213         address from,
214         uint256 id,
215         uint256 value,
216         bytes calldata data
217     )
218         external
219         virtual
220         returns(bytes4);
221 
222     function onERC1155BatchReceived(
223         address operator,
224         address from,
225         uint256[] calldata ids,
226         uint256[] calldata values,
227         bytes calldata data
228     )
229         external
230         virtual
231         returns(bytes4);
232 }
233 
234 // File: contracts\farming\util\IERC20.sol
235 
236 // SPDX_License_Identifier: MIT
237 
238 pragma solidity ^0.7.6;
239 
240 interface IERC20 {
241 
242     function totalSupply() external view returns (uint256);
243 
244     function balanceOf(address account) external view returns (uint256);
245 
246     function transfer(address recipient, uint256 amount) external returns (bool);
247 
248     function allowance(address owner, address spender) external view returns (uint256);
249 
250     function approve(address spender, uint256 amount) external returns (bool);
251 
252     function safeApprove(address spender, uint256 amount) external;
253 
254     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
255 
256     function decimals() external view returns (uint8);
257 }
258 
259 // File: contracts\farming\util\IEthItemOrchestrator.sol
260 
261 //SPDX_License_Identifier: MIT
262 
263 pragma solidity ^0.7.6;
264 
265 interface IEthItemOrchestrator {
266     function createNative(bytes calldata modelInitPayload, string calldata ens)
267         external
268         returns (address newNativeAddress, bytes memory modelInitCallResponse);
269 }
270 
271 // File: contracts\farming\util\IERC1155.sol
272 
273 // SPDX_License_Identifier: MIT
274 
275 pragma solidity ^0.7.6;
276 
277 interface IERC1155 {
278 
279     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
280 
281     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
282 
283     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
284 
285     event URI(string value, uint256 indexed id);
286 
287     function balanceOf(address account, uint256 id) external view returns (uint256);
288 
289     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
290 
291     function setApprovalForAll(address operator, bool approved) external;
292 
293     function isApprovedForAll(address account, address operator) external view returns (bool);
294 
295     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
296 
297     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
298 }
299 
300 // File: contracts\farming\util\IEthItemInteroperableInterface.sol
301 
302 // SPDX_License_Identifier: MIT
303 
304 pragma solidity ^0.7.6;
305 
306 
307 interface IEthItemInteroperableInterface is IERC20 {
308 
309     function mainInterface() external view returns (address);
310 
311     function objectId() external view returns (uint256);
312 
313     function mint(address owner, uint256 amount) external;
314 
315     function burn(address owner, uint256 amount) external;
316 
317     function permitNonce(address sender) external view returns(uint256);
318 
319     function permit(address owner, address spender, uint value, uint8 v, bytes32 r, bytes32 s) external;
320 
321     function interoperableInterfaceVersion() external pure returns(uint256 ethItemInteroperableInterfaceVersion);
322 }
323 
324 // File: contracts\farming\util\IEthItem.sol
325 
326 // SPDX_License_Identifier: MIT
327 
328 pragma solidity ^0.7.6;
329 
330 
331 
332 interface IEthItem is IERC1155 {
333 
334     function name() external view returns (string memory);
335 
336     function symbol() external view returns (string memory);
337 
338     function totalSupply(uint256 objectId) external view returns (uint256);
339 
340     function name(uint256 objectId) external view returns (string memory);
341 
342     function symbol(uint256 objectId) external view returns (string memory);
343 
344     function decimals(uint256 objectId) external view returns (uint256);
345 
346     function uri(uint256 objectId) external view returns (string memory);
347 
348     function mainInterfaceVersion() external pure returns(uint256 ethItemInteroperableVersion);
349 
350     function toInteroperableInterfaceAmount(uint256 objectId, uint256 ethItemAmount) external view returns (uint256 interoperableInterfaceAmount);
351 
352     function toMainInterfaceAmount(uint256 objectId, uint256 erc20WrapperAmount) external view returns (uint256 mainInterfaceAmount);
353 
354     function interoperableInterfaceModel() external view returns (address, uint256);
355 
356     function asInteroperable(uint256 objectId) external view returns (IEthItemInteroperableInterface);
357 
358     function emitTransferSingleEvent(address sender, address from, address to, uint256 objectId, uint256 amount) external;
359 
360     function mint(uint256 amount, string calldata partialUri)
361         external
362         returns (uint256, address);
363 
364     function burn(
365         uint256 objectId,
366         uint256 amount
367     ) external;
368 
369     function burnBatch(
370         uint256[] calldata objectIds,
371         uint256[] calldata amounts
372     ) external;
373 }
374 
375 // File: contracts\farming\util\INativeV1.sol
376 
377 //SPDX_License_Identifier: MIT
378 
379 pragma solidity ^0.7.6;
380 
381 
382 interface INativeV1 is IEthItem {
383 
384     function init(string calldata name, string calldata symbol, bool hasDecimals, string calldata collectionUri, address extensionAddress, bytes calldata extensionInitPayload) external returns(bytes memory extensionInitCallResponse);
385     function extension() external view returns (address extensionAddress);
386     function canMint(address operator) external view returns (bool result);
387     function isEditable(uint256 objectId) external view returns (bool result);
388     function releaseExtension() external;
389     function uri() external view returns (string memory);
390     function decimals() external view returns (uint256);
391     function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
392     function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri) external returns (uint256 objectId, address tokenAddress);
393     function mint(uint256 objectId, uint256 amount) external;
394     function makeReadOnly(uint256 objectId) external;
395     function setUri(string calldata newUri) external;
396     function setUri(uint256 objectId, string calldata newUri) external;
397 }
398 
399 // File: contracts\farming\FarmMain.sol
400 
401 //SPDX_License_Identifier: MIT
402 pragma solidity ^0.7.6;
403 //pragma abicoder v2;
404 
405 
406 
407 
408 
409 
410 
411 
412 
413 contract FarmMain is IFarmMain, ERC1155Receiver {
414 
415     // percentage
416     uint256 public override constant ONE_HUNDRED = 1e18;
417     // event that tracks contracts deployed for the given reward token
418     event RewardToken(address indexed rewardTokenAddress);
419     // new or transferred farming position event
420     event Transfer(uint256 indexed positionId, address indexed from, address indexed to);
421     // event that tracks involved tokens for this contract
422     event SetupToken(address indexed mainToken, address indexed involvedToken);
423     // event that tracks farm tokens
424     event FarmToken(uint256 indexed objectId, address indexed liquidityPoolToken, uint256 setupIndex, uint256 endBlock);
425     // factory address that will create clones of this contract
426     address public _factory;
427     // address of the extension of this contract
428     address public _extension;
429     // address of the reward token
430     address public override _rewardTokenAddress;
431      // farm token collection
432     address public _farmTokenCollection;
433     // mapping containing all the currently available farming setups info
434     mapping(uint256 => FarmingSetupInfo) private _setupsInfo;
435     // counter for the farming setup info
436     uint256 public _farmingSetupsInfoCount;
437     // mapping containing all the currently available farming setups
438     mapping(uint256 => FarmingSetup) private _setups;
439     // counter for the farming setups
440     uint256 public _farmingSetupsCount;
441     // mapping containing all the positions
442     mapping(uint256 => FarmingPosition) private _positions;
443     // mapping containing the reward per token per setup per block
444     mapping(uint256 => uint256) private _rewardPerTokenPerSetup;
445     // mapping containing the reward per token paid per position
446     mapping(uint256 => uint256) private _rewardPerTokenPaid;
447     // mapping containing whether a farming position has been partially reedemed or not
448     mapping(uint256 => uint256) public _partiallyRedeemed;
449     // mapping containing object id to setup index
450     mapping(uint256 => uint256) private _objectIdSetup;
451     // mapping containing all the number of opened positions for each setups
452     mapping(uint256 => uint256) private _setupPositionsCount;
453     // mapping containing all the reward received/paid per setup
454     mapping(uint256 => uint256) public _rewardReceived;
455     mapping(uint256 => uint256) public _rewardPaid;
456 
457     /** Modifiers. */
458 
459     /** @dev byExtension modifier used to check for unauthorized changes. */
460     modifier byExtension() {
461         require(msg.sender == _extension, "Unauthorized");
462         _;
463     }
464 
465     /** @dev byPositionOwner modifier used to check for unauthorized accesses. */
466     modifier byPositionOwner(uint256 positionId) {
467         require(_positions[positionId].uniqueOwner == msg.sender && _positions[positionId].creationBlock != 0, "Not owned");
468         _;
469     }
470 
471     /** @dev activeSetupOnly modifier used to check for function calls only if the setup is active. */
472     modifier activeSetupOnly(uint256 setupIndex) {
473         require(_setups[setupIndex].active, "Setup not active");
474         require(_setups[setupIndex].startBlock <= block.number && _setups[setupIndex].endBlock > block.number, "Invalid setup");
475         _;
476     }
477 
478     receive() external payable {}
479 
480     /** Extension methods */
481 
482     /** @dev initializes the farming contract.
483       * @param extension extension address.
484       * @param extensionInitData lm extension init payload.
485       * @param orchestrator address of the eth item orchestrator.
486       * @param rewardTokenAddress address of the reward token.
487       * @return extensionReturnCall result of the extension initialization function, if it was called.  
488      */
489     function init(address extension, bytes memory extensionInitData, address orchestrator, address rewardTokenAddress, bytes memory farmingSetupInfosBytes) public returns(bytes memory extensionReturnCall) {
490         require(_factory == address(0), "Already initialized");
491         require((_extension = extension) != address(0), "extension");
492         _factory = msg.sender;
493         emit RewardToken(_rewardTokenAddress = rewardTokenAddress);
494         if (keccak256(extensionInitData) != keccak256("")) {
495             extensionReturnCall = _call(_extension, extensionInitData);
496         }
497         (_farmTokenCollection,) = IEthItemOrchestrator(orchestrator).createNative(abi.encodeWithSignature("init(string,string,bool,string,address,bytes)", "Covenants Farming", "cFARM", true, IFarmFactory(_factory).getFarmTokenCollectionURI(), address(this), ""), "");
498         if(farmingSetupInfosBytes.length > 0) {
499             FarmingSetupInfo[] memory farmingSetupInfos = abi.decode(farmingSetupInfosBytes, (FarmingSetupInfo[]));
500             for(uint256 i = 0; i < farmingSetupInfos.length; i++) {
501                 _setOrAddFarmingSetupInfo(farmingSetupInfos[i], true, false, 0);
502             }
503         }
504     }
505 
506     function setFarmingSetups(FarmingSetupConfiguration[] memory farmingSetups) public override byExtension {
507         for (uint256 i = 0; i < farmingSetups.length; i++) {
508             _setOrAddFarmingSetupInfo(farmingSetups[i].info, farmingSetups[i].add, farmingSetups[i].disable, farmingSetups[i].index);
509         }
510     }
511 
512     /** Public methods */
513 
514     /** @dev returns the position with the given id.
515       * @param positionId id of the position.
516       * @return farming position with the given id.
517      */
518     function position(uint256 positionId) public override view returns (FarmingPosition memory) {
519         return _positions[positionId];
520     }
521 
522     function setup(uint256 setupIndex) public override view returns (FarmingSetup memory, FarmingSetupInfo memory) {
523         return (_setups[setupIndex], _setupsInfo[_setups[setupIndex].infoIndex]);
524     }
525 
526     function setups() public override view returns (FarmingSetup[] memory) {
527         FarmingSetup[] memory farmingSetups = new FarmingSetup[](_farmingSetupsCount);
528         for (uint256 i = 0; i < _farmingSetupsCount; i++) {
529             farmingSetups[i] = _setups[i];
530         }
531         return farmingSetups;
532     }
533 
534     function activateSetup(uint256 setupInfoIndex) public {
535         require(_setupsInfo[setupInfoIndex].renewTimes > 0 && !_setups[_setupsInfo[setupInfoIndex].lastSetupIndex].active, "Invalid toggle.");
536         _toggleSetup(_setupsInfo[setupInfoIndex].lastSetupIndex);
537     }
538 
539     function transferPosition(address to, uint256 positionId) public byPositionOwner(positionId) {
540         // retrieve liquidity mining position
541         FarmingPosition memory pos = _positions[positionId];
542         require(
543             to != address(0) &&
544             pos.creationBlock != 0,
545             "Invalid position"
546         );
547         // pos.uniqueOwner = to;
548         uint256 newPositionId = uint256(keccak256(abi.encode(to, _setupsInfo[_setups[pos.setupIndex].infoIndex].free ? 0 : block.number, pos.setupIndex)));
549         require(_positions[newPositionId].creationBlock == 0, "Invalid transfer");
550         _positions[newPositionId] = abi.decode(abi.encode(pos), (FarmingPosition));
551         _positions[newPositionId].uniqueOwner = to;
552         delete _positions[positionId];
553         emit Transfer(newPositionId, msg.sender, to);
554     }
555 
556     function openPosition(FarmingPositionRequest memory request) public override payable activeSetupOnly(request.setupIndex) returns(uint256 positionId) {
557         // retrieve the setup
558         FarmingSetup storage chosenSetup = _setups[request.setupIndex];
559         // retrieve the unique owner
560         address uniqueOwner = (request.positionOwner != address(0)) ? request.positionOwner : msg.sender;
561         // create the position id
562         positionId = uint256(keccak256(abi.encode(uniqueOwner, _setupsInfo[chosenSetup.infoIndex].free ? 0 : block.number, request.setupIndex)));
563         require(_positions[positionId].creationBlock == 0, "Invalid open");
564         // create the lp data for the amm
565         (LiquidityPoolData memory liquidityPoolData, uint256 mainTokenAmount) = _addLiquidity(request.setupIndex, request);
566         // calculate the reward
567         uint256 reward;
568         uint256 lockedRewardPerBlock;
569         if (!_setupsInfo[chosenSetup.infoIndex].free) {
570             (reward, lockedRewardPerBlock) = calculateLockedFarmingReward(request.setupIndex, mainTokenAmount, false, 0);
571             require(reward > 0 && lockedRewardPerBlock > 0, "Insufficient staked amount");
572             chosenSetup.totalSupply = chosenSetup.totalSupply + mainTokenAmount;
573             chosenSetup.lastUpdateBlock = block.number;
574             _mintFarmTokenAmount(uniqueOwner, liquidityPoolData.amount, request.setupIndex);
575         } else {
576             _updateFreeSetup(request.setupIndex, liquidityPoolData.amount, positionId, false);
577         }
578         _positions[positionId] = FarmingPosition({
579             uniqueOwner: uniqueOwner,
580             setupIndex : request.setupIndex,
581             liquidityPoolTokenAmount: liquidityPoolData.amount,
582             mainTokenAmount: mainTokenAmount,
583             reward: reward,
584             lockedRewardPerBlock: lockedRewardPerBlock,
585             creationBlock: block.number
586         });
587         _setupPositionsCount[request.setupIndex] += (1 + (_setupsInfo[chosenSetup.infoIndex].free ? 0 : liquidityPoolData.amount));
588         emit Transfer(positionId, address(0), uniqueOwner);
589     }
590 
591     function addLiquidity(uint256 positionId, FarmingPositionRequest memory request) public override payable activeSetupOnly(request.setupIndex) byPositionOwner(positionId) {
592         // retrieve farming position
593         FarmingPosition storage farmingPosition = _positions[positionId];
594         FarmingSetup storage chosenSetup = _setups[farmingPosition.setupIndex];
595         // check if farmoing position is valid
596         require(_setupsInfo[chosenSetup.infoIndex].free, "Invalid add liquidity");
597         // create the lp data for the amm
598         (LiquidityPoolData memory liquidityPoolData,) = _addLiquidity(farmingPosition.setupIndex, request);
599         // rebalance the reward per token
600         _rewardPerTokenPerSetup[farmingPosition.setupIndex] += (((block.number - chosenSetup.lastUpdateBlock) * chosenSetup.rewardPerBlock) * 1e18) / chosenSetup.totalSupply;
601         farmingPosition.reward = calculateFreeFarmingReward(positionId, false);
602         _rewardPerTokenPaid[positionId] = _rewardPerTokenPerSetup[farmingPosition.setupIndex];
603         farmingPosition.liquidityPoolTokenAmount += liquidityPoolData.amount;
604         // update the last block update variablex
605         chosenSetup.lastUpdateBlock = block.number;
606         chosenSetup.totalSupply += liquidityPoolData.amount;
607     }
608 
609 
610     /** @dev this function allows a user to withdraw the reward.
611       * @param positionId farming position id.
612      */
613     function withdrawReward(uint256 positionId) public byPositionOwner(positionId) {
614         // retrieve farming position
615         FarmingPosition storage farmingPosition = _positions[positionId];
616         uint256 reward = farmingPosition.reward;
617         uint256 currentBlock = block.number;
618         if (!_setupsInfo[_setups[farmingPosition.setupIndex].infoIndex].free) {
619             // check if reward is available
620             require(farmingPosition.reward > 0, "No reward");
621             // check if it's a partial reward or not
622             // if (_setups[farmingPosition.setupIndex].endBlock > block.number) {
623             // calculate the reward from the farming position creation block to the current block multiplied by the reward per block
624             (reward,) = calculateLockedFarmingReward(0, 0, true, positionId);
625             //}
626             require(reward <= farmingPosition.reward, "Reward is bigger than expected");
627             // remove the partial reward from the liquidity mining position total reward
628             farmingPosition.reward = currentBlock >= _setups[farmingPosition.setupIndex].endBlock ? 0 : farmingPosition.reward - reward;
629             farmingPosition.creationBlock = block.number;
630         } else {
631             // rebalance setup
632             currentBlock = currentBlock > _setups[farmingPosition.setupIndex].endBlock ? _setups[farmingPosition.setupIndex].endBlock : currentBlock;
633             _rewardPerTokenPerSetup[farmingPosition.setupIndex] += (((currentBlock - _setups[farmingPosition.setupIndex].lastUpdateBlock) * _setups[farmingPosition.setupIndex].rewardPerBlock) * 1e18) / _setups[farmingPosition.setupIndex].totalSupply;
634             reward = calculateFreeFarmingReward(positionId, false);
635             _rewardPerTokenPaid[positionId] = _rewardPerTokenPerSetup[farmingPosition.setupIndex];
636             farmingPosition.reward = 0;
637             // update the last block update variable
638             _setups[farmingPosition.setupIndex].lastUpdateBlock = currentBlock;
639         }
640         if (reward > 0) {
641             // transfer the reward
642             if (_rewardTokenAddress != address(0)) {
643                 _safeTransfer(_rewardTokenAddress, farmingPosition.uniqueOwner, reward);
644             } else {
645                 (bool result,) = farmingPosition.uniqueOwner.call{value:reward}("");
646                 require(result, "Invalid ETH transfer.");
647             }
648             _rewardPaid[farmingPosition.setupIndex] += reward;
649         }
650         if (_setups[farmingPosition.setupIndex].endBlock <= block.number) {
651             if (_setups[farmingPosition.setupIndex].active) {
652                 _toggleSetup(farmingPosition.setupIndex);
653             }
654             // close the locked position after withdrawing all the reward
655             if (!_setupsInfo[_setups[farmingPosition.setupIndex].infoIndex].free) {
656                 _setupPositionsCount[farmingPosition.setupIndex] -= 1;
657                 if (_setupPositionsCount[farmingPosition.setupIndex] == 0 && !_setups[farmingPosition.setupIndex].active) {
658                     _giveBack(_rewardReceived[farmingPosition.setupIndex] - _rewardPaid[farmingPosition.setupIndex]);
659                     delete _setups[farmingPosition.setupIndex];
660                 }
661                 delete _positions[positionId];
662             }
663         } else if (!_setupsInfo[_setups[farmingPosition.setupIndex].infoIndex].free) {
664             // set the partially redeemed amount
665             _partiallyRedeemed[positionId] += reward;
666         }
667     }
668 
669     function withdrawLiquidity(uint256 positionId, uint256 objectId, bool unwrapPair, uint256 removedLiquidity) public {
670         // retrieve farming position
671         FarmingPosition memory farmingPosition = _positions[positionId];
672         uint256 setupIndex = farmingPosition.setupIndex;
673         if (objectId != 0 && address(INativeV1(_farmTokenCollection).asInteroperable(objectId)) != address(0)) {
674             setupIndex = _objectIdSetup[objectId];
675         }
676         require((positionId != 0 && objectId == 0) || (objectId != 0 && positionId == 0 && _setups[setupIndex].objectId == objectId), "Invalid position");
677         // current owned liquidity
678         require(
679             (
680                 _setupsInfo[_setups[farmingPosition.setupIndex].infoIndex].free && 
681                 farmingPosition.creationBlock != 0 &&
682                 removedLiquidity <= farmingPosition.liquidityPoolTokenAmount &&
683                 farmingPosition.uniqueOwner == msg.sender
684             ) || (INativeV1(_farmTokenCollection).balanceOf(msg.sender, objectId) >= removedLiquidity && (_setups[setupIndex].endBlock <= block.number)), "Invalid withdraw");
685         // burn the liquidity in the locked setup
686         if (positionId == 0) {
687             _burnFarmTokenAmount(objectId, removedLiquidity);
688         } else {
689             withdrawReward(positionId);
690             _setups[farmingPosition.setupIndex].totalSupply -= removedLiquidity;
691         }
692         _removeLiquidity(positionId, setupIndex, unwrapPair, removedLiquidity, false);
693         if (positionId == 0) {
694             _setupPositionsCount[setupIndex] -= removedLiquidity;
695             if (_setupPositionsCount[setupIndex] == 0 && !_setups[setupIndex].active) {
696                 _giveBack(_rewardReceived[setupIndex] - _rewardPaid[setupIndex]);
697                 delete _setups[setupIndex];
698             }
699         }
700     }
701 
702     function unlock(uint256 positionId, bool unwrapPair) public payable byPositionOwner(positionId) {
703         // retrieve liquidity mining position
704         FarmingPosition storage farmingPosition = _positions[positionId];
705         require(!_setupsInfo[_setups[farmingPosition.setupIndex].infoIndex].free && _setups[farmingPosition.setupIndex].endBlock > block.number, "Invalid unlock");
706         uint256 rewardToGiveBack = _partiallyRedeemed[positionId];
707         // must pay a penalty fee
708         rewardToGiveBack += _setupsInfo[_setups[farmingPosition.setupIndex].infoIndex].penaltyFee == 0 ? 0 : (farmingPosition.reward * ((_setupsInfo[_setups[farmingPosition.setupIndex].infoIndex].penaltyFee * 1e18) / ONE_HUNDRED) / 1e18);
709         // add all the unissued reward
710         if (rewardToGiveBack > 0) {
711             _safeTransferFrom(_rewardTokenAddress, msg.sender, address(this), rewardToGiveBack);
712             _giveBack(rewardToGiveBack);
713         } 
714         _setups[farmingPosition.setupIndex].totalSupply -= farmingPosition.mainTokenAmount;
715         _burnFarmTokenAmount(_setups[farmingPosition.setupIndex].objectId, farmingPosition.liquidityPoolTokenAmount);
716         _removeLiquidity(positionId, farmingPosition.setupIndex, unwrapPair, farmingPosition.liquidityPoolTokenAmount, true);
717         _setupPositionsCount[farmingPosition.setupIndex] -= 1 + farmingPosition.liquidityPoolTokenAmount;
718         delete _positions[positionId];
719     }
720 
721     function calculateLockedFarmingReward(uint256 setupIndex, uint256 mainTokenAmount, bool isPartial, uint256 positionId) public view returns(uint256 reward, uint256 relativeRewardPerBlock) {
722         if (isPartial) {
723             // retrieve the position
724             FarmingPosition memory farmingPosition = _positions[positionId];
725             // calculate the reward
726             uint256 currentBlock = block.number >= _setups[farmingPosition.setupIndex].endBlock ? _setups[farmingPosition.setupIndex].endBlock : block.number;
727             reward = ((currentBlock - farmingPosition.creationBlock) * farmingPosition.lockedRewardPerBlock);
728         } else {
729             FarmingSetup memory setup = _setups[setupIndex];
730             // check if main token amount is less than the stakeable liquidity
731             require(mainTokenAmount <= _setupsInfo[_setups[setupIndex].infoIndex].maxStakeable - setup.totalSupply, "Invalid liquidity");
732             uint256 remainingBlocks = block.number >= setup.endBlock ? 0 : setup.endBlock - block.number;
733             // get amount of remaining blocks
734             require(remainingBlocks > 0, "FarmingSetup ended");
735             // get total reward still available (= 0 if rewardPerBlock = 0)
736             require(setup.rewardPerBlock * remainingBlocks > 0, "No rewards");
737             // calculate relativeRewardPerBlock
738             relativeRewardPerBlock = (setup.rewardPerBlock * ((mainTokenAmount * 1e18) / _setupsInfo[_setups[setupIndex].infoIndex].maxStakeable)) / 1e18;
739             // check if rewardPerBlock is greater than 0
740             require(relativeRewardPerBlock > 0, "Invalid rpb");
741             // calculate reward by multiplying relative reward per block and the remaining blocks
742             reward = relativeRewardPerBlock * remainingBlocks;
743         }
744     }
745 
746     function calculateFreeFarmingReward(uint256 positionId, bool isExt) public view returns(uint256 reward) {
747         FarmingPosition memory farmingPosition = _positions[positionId];
748         reward = ((_rewardPerTokenPerSetup[farmingPosition.setupIndex] - _rewardPerTokenPaid[positionId]) * farmingPosition.liquidityPoolTokenAmount) / 1e18;
749         if (isExt) {
750             uint256 currentBlock = block.number < _setups[farmingPosition.setupIndex].endBlock ? block.number : _setups[farmingPosition.setupIndex].endBlock;
751             uint256 lastUpdateBlock = _setups[farmingPosition.setupIndex].lastUpdateBlock < _setups[farmingPosition.setupIndex].startBlock ? _setups[farmingPosition.setupIndex].startBlock : _setups[farmingPosition.setupIndex].lastUpdateBlock;
752             uint256 rpt = (((currentBlock - lastUpdateBlock) * _setups[farmingPosition.setupIndex].rewardPerBlock) * 1e18) / _setups[farmingPosition.setupIndex].totalSupply;
753             reward += (rpt * farmingPosition.liquidityPoolTokenAmount) / 1e18;
754         }
755         reward += farmingPosition.reward;
756     }
757 
758     function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory) public view override returns(bytes4) {
759         require(_farmTokenCollection == msg.sender, "Invalid sender");
760         return this.onERC1155BatchReceived.selector;
761     }
762 
763     function onERC1155Received(address, address, uint256, uint256, bytes memory) public view override returns(bytes4) {
764         require(_farmTokenCollection == msg.sender, "Invalid sender");
765         return this.onERC1155Received.selector;
766     }
767 
768     /** Private methods */
769 
770     function _setOrAddFarmingSetupInfo(FarmingSetupInfo memory info, bool add, bool disable, uint256 setupIndex) private {
771         FarmingSetupInfo memory farmingSetupInfo = info;
772 
773         if(add || !disable) {
774             farmingSetupInfo.renewTimes = farmingSetupInfo.renewTimes + 1;
775             if(farmingSetupInfo.renewTimes == 0) {
776                 farmingSetupInfo.renewTimes = farmingSetupInfo.renewTimes - 1;
777             }
778         }
779 
780         if (add) {
781             require(
782                 farmingSetupInfo.ammPlugin != address(0) &&
783                 farmingSetupInfo.liquidityPoolTokenAddress != address(0) &&
784                 farmingSetupInfo.originalRewardPerBlock > 0 &&
785                 (farmingSetupInfo.free || farmingSetupInfo.maxStakeable > 0),
786                 "Invalid setup configuration"
787             );
788 
789             (,,address[] memory tokenAddresses) = IAMM(farmingSetupInfo.ammPlugin).byLiquidityPool(farmingSetupInfo.liquidityPoolTokenAddress);
790             farmingSetupInfo.ethereumAddress = address(0);
791             if (farmingSetupInfo.involvingETH) {
792                 (farmingSetupInfo.ethereumAddress,,) = IAMM(farmingSetupInfo.ammPlugin).data();
793             }
794             bool mainTokenFound = false;
795             bool ethTokenFound = false;
796             for(uint256 z = 0; z < tokenAddresses.length; z++) {
797                 if(tokenAddresses[z] == farmingSetupInfo.mainTokenAddress) {
798                     mainTokenFound = true;
799                     if(tokenAddresses[z] == farmingSetupInfo.ethereumAddress) {
800                         ethTokenFound = true;
801                     }
802                 } else {
803                     emit SetupToken(farmingSetupInfo.mainTokenAddress, tokenAddresses[z]);
804                     if(tokenAddresses[z] == farmingSetupInfo.ethereumAddress) {
805                         ethTokenFound = true;
806                     }
807                 }
808             }
809             require(mainTokenFound, "No main token");
810             require(!farmingSetupInfo.involvingETH || ethTokenFound, "No ETH token");
811             farmingSetupInfo.setupsCount = 0;
812             _setupsInfo[_farmingSetupsInfoCount] = farmingSetupInfo;
813             _setups[_farmingSetupsCount] = FarmingSetup(_farmingSetupsInfoCount, false, 0, 0, 0, 0, farmingSetupInfo.originalRewardPerBlock, 0);
814             _setupsInfo[_farmingSetupsInfoCount].lastSetupIndex = _farmingSetupsCount;
815             _farmingSetupsInfoCount += 1;
816             _farmingSetupsCount += 1;
817             return;
818         }
819 
820         FarmingSetup storage setup = _setups[setupIndex];
821         farmingSetupInfo = _setupsInfo[_setups[setupIndex].infoIndex];
822 
823         if(disable) {
824             require(setup.active, "Not possible");
825             _toggleSetup(setupIndex);
826             return;
827         }
828 
829         info.renewTimes -= 1;
830 
831         if (setup.active && _setupsInfo[_setups[setupIndex].infoIndex].free) {
832             setup = _setups[setupIndex];
833             if(block.number < setup.endBlock) {
834                 uint256 difference = info.originalRewardPerBlock < farmingSetupInfo.originalRewardPerBlock ? farmingSetupInfo.originalRewardPerBlock - info.originalRewardPerBlock : info.originalRewardPerBlock - farmingSetupInfo.originalRewardPerBlock;
835                 uint256 duration = setup.endBlock - block.number;
836                 uint256 amount = difference * duration;
837                 if (amount > 0) {
838                     if (info.originalRewardPerBlock > farmingSetupInfo.originalRewardPerBlock) {
839                         require(_ensureTransfer(amount), "Insufficient reward in extension.");
840                         _rewardReceived[setupIndex] += amount;
841                     }
842                     _updateFreeSetup(setupIndex, 0, 0, false);
843                     setup.rewardPerBlock = info.originalRewardPerBlock;
844                 }
845             }
846             _setupsInfo[_setups[setupIndex].infoIndex].originalRewardPerBlock = info.originalRewardPerBlock;
847         }
848         if(_setupsInfo[_setups[setupIndex].infoIndex].renewTimes > 0) {
849             _setupsInfo[_setups[setupIndex].infoIndex].renewTimes = info.renewTimes;
850         }
851     }
852 
853     function _transferToMeAndCheckAllowance(FarmingSetup memory setup, FarmingPositionRequest memory request) private returns(IAMM amm, uint256 liquidityPoolAmount, uint256 mainTokenAmount) {
854         require(request.amount > 0, "No amount");
855         // retrieve the values
856         amm = IAMM(_setupsInfo[setup.infoIndex].ammPlugin);
857         liquidityPoolAmount = request.amountIsLiquidityPool ? request.amount : 0;
858         mainTokenAmount = request.amountIsLiquidityPool ? 0 : request.amount;
859         address[] memory tokens;
860         uint256[] memory tokenAmounts;
861         // if liquidity pool token amount is provided, the position is opened by liquidity pool token amount
862         if(request.amountIsLiquidityPool) {
863             _safeTransferFrom(_setupsInfo[setup.infoIndex].liquidityPoolTokenAddress, msg.sender, address(this), liquidityPoolAmount);
864             (tokenAmounts, tokens) = amm.byLiquidityPoolAmount(_setupsInfo[setup.infoIndex].liquidityPoolTokenAddress, liquidityPoolAmount);
865         } else {
866             // else it is opened by the tokens amounts
867             (liquidityPoolAmount, tokenAmounts, tokens) = amm.byTokenAmount(_setupsInfo[setup.infoIndex].liquidityPoolTokenAddress, _setupsInfo[setup.infoIndex].mainTokenAddress, mainTokenAmount);
868         }
869 
870         // iterate the tokens and perform the transferFrom and the approve
871         for(uint256 i = 0; i < tokens.length; i++) {
872             if(tokens[i] == _setupsInfo[setup.infoIndex].mainTokenAddress) {
873                 mainTokenAmount = tokenAmounts[i];
874                 require(mainTokenAmount >= _setupsInfo[setup.infoIndex].minStakeable, "Invalid liquidity.");
875                 if(request.amountIsLiquidityPool) {
876                     break;
877                 }
878             }
879             if(request.amountIsLiquidityPool) {
880                 continue;
881             }
882             if(_setupsInfo[setup.infoIndex].involvingETH && _setupsInfo[setup.infoIndex].ethereumAddress == tokens[i]) {
883                 require(msg.value == tokenAmounts[i], "Incorrect eth value");
884             } else {
885                 _safeTransferFrom(tokens[i], msg.sender, address(this), tokenAmounts[i]);
886                 _safeApprove(tokens[i], _setupsInfo[setup.infoIndex].ammPlugin, tokenAmounts[i]);
887             }
888         }
889     }
890 
891     function _addLiquidity(uint256 setupIndex, FarmingPositionRequest memory request) private returns(LiquidityPoolData memory liquidityPoolData, uint256 tokenAmount) {
892         (IAMM amm, uint256 liquidityPoolAmount, uint256 mainTokenAmount) = _transferToMeAndCheckAllowance(_setups[setupIndex], request);
893         // liquidity pool data struct for the AMM
894         liquidityPoolData = LiquidityPoolData(
895             _setupsInfo[_setups[setupIndex].infoIndex].liquidityPoolTokenAddress,
896             request.amountIsLiquidityPool ? liquidityPoolAmount : mainTokenAmount,
897             _setupsInfo[_setups[setupIndex].infoIndex].mainTokenAddress,
898             request.amountIsLiquidityPool,
899             _setupsInfo[_setups[setupIndex].infoIndex].involvingETH,
900             address(this)
901         );
902         tokenAmount = mainTokenAmount;
903         // amount is lp check
904         if (liquidityPoolData.amountIsLiquidityPool || !_setupsInfo[_setups[setupIndex].infoIndex].involvingETH) {
905             require(msg.value == 0, "ETH not involved");
906         }
907         if (liquidityPoolData.amountIsLiquidityPool) {
908             return(liquidityPoolData, tokenAmount);
909         }
910         // retrieve the poolTokenAmount from the amm
911         if(liquidityPoolData.involvingETH) {
912             (liquidityPoolData.amount,,) = amm.addLiquidity{value : msg.value}(liquidityPoolData);
913         } else {
914             (liquidityPoolData.amount,,) = amm.addLiquidity(liquidityPoolData);
915         }
916     }
917 
918     /** @dev helper function used to remove liquidity from a free position or to burn item farm tokens and retrieve their content.
919       * @param positionId id of the position.
920       * @param setupIndex index of the setup related to the item farm tokens.
921       * @param unwrapPair whether to unwrap the liquidity pool tokens or not.
922       * @param isUnlock if we're removing liquidity from an unlock method or not.
923      */
924     function _removeLiquidity(uint256 positionId, uint256 setupIndex, bool unwrapPair, uint256 removedLiquidity, bool isUnlock) private {
925         FarmingSetupInfo memory setupInfo = _setupsInfo[_setups[setupIndex].infoIndex];
926         // create liquidity pool data struct for the AMM
927         LiquidityPoolData memory lpData = LiquidityPoolData(
928             setupInfo.liquidityPoolTokenAddress,
929             removedLiquidity,
930             setupInfo.mainTokenAddress,
931             true,
932             setupInfo.involvingETH,
933             msg.sender
934         );
935         // retrieve the position
936         FarmingPosition storage farmingPosition = _positions[positionId];
937         // remaining liquidity
938         uint256 remainingLiquidity;
939         // we are removing liquidity using the setup items
940         if (setupInfo.free && farmingPosition.creationBlock != 0 && positionId != 0) {
941             // update the remaining liquidity
942             remainingLiquidity = farmingPosition.liquidityPoolTokenAmount - removedLiquidity;
943         }
944         // retrieve fee stuff
945         (uint256 exitFeePercentage, address exitFeeWallet) = IFarmFactory(_factory).feePercentageInfo();
946         // pay the fees!
947         if (exitFeePercentage > 0) {
948             uint256 fee = (lpData.amount * ((exitFeePercentage * 1e18) / ONE_HUNDRED)) / 1e18;
949             _safeTransfer(setupInfo.liquidityPoolTokenAddress, exitFeeWallet, fee);
950             lpData.amount = lpData.amount - fee;
951         }
952         // check if the user wants to unwrap its pair or not
953         if (unwrapPair) {
954             // remove liquidity using AMM
955             _safeApprove(lpData.liquidityPoolAddress, setupInfo.ammPlugin, lpData.amount);
956             IAMM(setupInfo.ammPlugin).removeLiquidity(lpData);
957         } else {
958             // send back the liquidity pool token amount without the fee
959             _safeTransfer(lpData.liquidityPoolAddress, lpData.receiver, lpData.amount);
960         }
961         if (!setupInfo.free && _setups[setupIndex].active && !isUnlock) {
962             _toggleSetup(setupIndex);
963         } else if (setupInfo.free && positionId != 0) {
964             if (_setups[farmingPosition.setupIndex].active && _setups[farmingPosition.setupIndex].endBlock <= block.number) {
965                 _toggleSetup(farmingPosition.setupIndex);
966             }
967             // delete the farming position after the withdraw
968             if (remainingLiquidity == 0) {
969                 _setupPositionsCount[farmingPosition.setupIndex] -= 1;
970                 if (_setupPositionsCount[farmingPosition.setupIndex] == 0 && !_setups[farmingPosition.setupIndex].active) {
971                     _giveBack(_rewardReceived[farmingPosition.setupIndex] - _rewardPaid[farmingPosition.setupIndex]);
972                     delete _setups[farmingPosition.setupIndex];
973                 }
974                 delete _positions[positionId];
975             } else {
976                 // update the creation block and amount
977                 farmingPosition.liquidityPoolTokenAmount = remainingLiquidity;
978             }
979         }
980     }
981 
982     /** @dev updates the free setup with the given index.
983       * @param setupIndex index of the setup that we're updating.
984       * @param amount amount of liquidity that we're adding/removeing.
985       * @param positionId position id.
986       * @param fromExit if it's from an exit or not.
987      */
988     function _updateFreeSetup(uint256 setupIndex, uint256 amount, uint256 positionId, bool fromExit) private {
989         uint256 currentBlock = block.number < _setups[setupIndex].endBlock ? block.number : _setups[setupIndex].endBlock;
990         if (_setups[setupIndex].totalSupply != 0) {
991             uint256 lastUpdateBlock = _setups[setupIndex].lastUpdateBlock < _setups[setupIndex].startBlock ? _setups[setupIndex].startBlock : _setups[setupIndex].lastUpdateBlock;
992             _rewardPerTokenPerSetup[setupIndex] += (((currentBlock - lastUpdateBlock) * _setups[setupIndex].rewardPerBlock) * 1e18) / _setups[setupIndex].totalSupply;
993         }
994         // update the last block update variable
995         _setups[setupIndex].lastUpdateBlock = currentBlock;
996         if (positionId != 0) {
997             _rewardPerTokenPaid[positionId] = _rewardPerTokenPerSetup[setupIndex];
998         }
999         if (amount > 0) {
1000             fromExit ? _setups[setupIndex].totalSupply -= amount : _setups[setupIndex].totalSupply += amount;
1001         }
1002     }
1003 
1004     function _toggleSetup(uint256 setupIndex) private {
1005         FarmingSetup storage setup = _setups[setupIndex];
1006         // require(!setup.active || block.number >= setup.endBlock, "Not valid activation");
1007 
1008         if (setup.active && block.number >= setup.endBlock && _setupsInfo[setup.infoIndex].renewTimes == 0) {
1009             setup.active = false;
1010             return;
1011         } else if (block.number >= setup.startBlock && block.number < setup.endBlock && setup.active) {
1012             setup.active = false;
1013             _setupsInfo[setup.infoIndex].renewTimes = 0;
1014             uint256 amount = (setup.endBlock - block.number) * setup.rewardPerBlock;
1015             setup.endBlock = block.number;
1016             if (_setupsInfo[setup.infoIndex].free) {
1017                 _updateFreeSetup(setupIndex, 0, 0, false);
1018             }
1019             _rewardReceived[setupIndex] -= amount;
1020             _giveBack(amount);
1021             return;
1022         }
1023 
1024         bool wasActive = setup.active;
1025         setup.active = _ensureTransfer(setup.rewardPerBlock * _setupsInfo[setup.infoIndex].blockDuration);
1026 
1027         if (setup.active && wasActive) {
1028             _rewardReceived[_farmingSetupsCount] = setup.rewardPerBlock * _setupsInfo[setup.infoIndex].blockDuration;
1029             // set new setup
1030             _setups[_farmingSetupsCount] = abi.decode(abi.encode(setup), (FarmingSetup));
1031             // update old setup
1032             _setups[setupIndex].active = false;
1033             // update new setup
1034             _setupsInfo[setup.infoIndex].renewTimes -= 1;
1035             _setupsInfo[setup.infoIndex].setupsCount += 1;
1036             _setupsInfo[setup.infoIndex].lastSetupIndex = _farmingSetupsCount;
1037             _setups[_farmingSetupsCount].startBlock = block.number;
1038             _setups[_farmingSetupsCount].endBlock = block.number + _setupsInfo[_setups[_farmingSetupsCount].infoIndex].blockDuration;
1039             _setups[_farmingSetupsCount].objectId = 0;
1040             _setups[_farmingSetupsCount].totalSupply = 0;
1041             _farmingSetupsCount += 1;
1042         } else if (setup.active && !wasActive) {
1043             _rewardReceived[setupIndex] = setup.rewardPerBlock * _setupsInfo[_setups[setupIndex].infoIndex].blockDuration;
1044             // update new setup
1045             _setups[setupIndex].startBlock = block.number;
1046             _setups[setupIndex].endBlock = block.number + _setupsInfo[_setups[setupIndex].infoIndex].blockDuration;
1047             _setups[setupIndex].totalSupply = 0;
1048             _setupsInfo[_setups[setupIndex].infoIndex].renewTimes -= 1;
1049         } else {
1050             _setupsInfo[_setups[setupIndex].infoIndex].renewTimes = 0;
1051         }
1052     }
1053 
1054     /** @dev mints a new FarmToken inside the collection for the given position.
1055       * @param uniqueOwner farming position owner.
1056       * @param amount amount of to mint for a farm token.
1057       * @param setupIndex index of the setup.
1058       * @return objectId new farm token object id.
1059      */
1060     function _mintFarmTokenAmount(address uniqueOwner, uint256 amount, uint256 setupIndex) private returns(uint256 objectId) {
1061         if (_setups[setupIndex].objectId == 0) {
1062             (objectId,) = INativeV1(_farmTokenCollection).mint(amount, string(abi.encodePacked("Farming LP ", _toString(_setupsInfo[_setups[setupIndex].infoIndex].liquidityPoolTokenAddress))), "fLP", IFarmFactory(_factory).getFarmTokenURI(), true);
1063             emit FarmToken(objectId, _setupsInfo[_setups[setupIndex].infoIndex].liquidityPoolTokenAddress, setupIndex, _setups[setupIndex].endBlock);
1064             _objectIdSetup[objectId] = setupIndex;
1065             _setups[setupIndex].objectId = objectId;
1066         } else {
1067             INativeV1(_farmTokenCollection).mint(_setups[setupIndex].objectId, amount);
1068         }
1069         INativeV1(_farmTokenCollection).safeTransferFrom(address(this), uniqueOwner, _setups[setupIndex].objectId, amount, "");
1070     }
1071 
1072     /** @dev burns a farm token from the collection.
1073       * @param objectId object id where to burn liquidity.
1074       * @param amount amount of liquidity to burn.
1075       */
1076     function _burnFarmTokenAmount(uint256 objectId, uint256 amount) private {
1077         INativeV1 tokenCollection = INativeV1(_farmTokenCollection);
1078         // transfer the farm token to this contract
1079         tokenCollection.safeTransferFrom(msg.sender, address(this), objectId, amount, "");
1080         // burn the farm token
1081         tokenCollection.burn(objectId, amount);
1082     }
1083 
1084     /** @dev function used to safely approve ERC20 transfers.
1085       * @param erc20TokenAddress address of the token to approve.
1086       * @param to receiver of the approval.
1087       * @param value amount to approve for.
1088      */
1089     function _safeApprove(address erc20TokenAddress, address to, uint256 value) internal virtual {
1090         bytes memory returnData = _call(erc20TokenAddress, abi.encodeWithSelector(IERC20(erc20TokenAddress).approve.selector, to, value));
1091         require(returnData.length == 0 || abi.decode(returnData, (bool)), 'APPROVE_FAILED');
1092     }
1093 
1094     /** @dev function used to safe transfer ERC20 tokens.
1095       * @param erc20TokenAddress address of the token to transfer.
1096       * @param to receiver of the tokens.
1097       * @param value amount of tokens to transfer.
1098      */
1099     function _safeTransfer(address erc20TokenAddress, address to, uint256 value) internal virtual {
1100         bytes memory returnData = _call(erc20TokenAddress, abi.encodeWithSelector(IERC20(erc20TokenAddress).transfer.selector, to, value));
1101         require(returnData.length == 0 || abi.decode(returnData, (bool)), 'TRANSFER_FAILED');
1102     }
1103 
1104     /** @dev this function safely transfers the given ERC20 value from an address to another.
1105       * @param erc20TokenAddress erc20 token address.
1106       * @param from address from.
1107       * @param to address to.
1108       * @param value amount to transfer.
1109      */
1110     function _safeTransferFrom(address erc20TokenAddress, address from, address to, uint256 value) private {
1111         bytes memory returnData = _call(erc20TokenAddress, abi.encodeWithSelector(IERC20(erc20TokenAddress).transferFrom.selector, from, to, value));
1112         require(returnData.length == 0 || abi.decode(returnData, (bool)), 'TRANSFERFROM_FAILED');
1113     }
1114 
1115     /** @dev calls the contract at the given location using the given payload and returns the returnData.
1116       * @param location location to call.
1117       * @param payload call payload.
1118       * @return returnData call return data.
1119      */
1120     function _call(address location, bytes memory payload) private returns(bytes memory returnData) {
1121         assembly {
1122             let result := call(gas(), location, 0, add(payload, 0x20), mload(payload), 0, 0)
1123             let size := returndatasize()
1124             returnData := mload(0x40)
1125             mstore(returnData, size)
1126             let returnDataPayloadStart := add(returnData, 0x20)
1127             returndatacopy(returnDataPayloadStart, 0, size)
1128             mstore(0x40, add(returnDataPayloadStart, size))
1129             switch result case 0 {revert(returnDataPayloadStart, size)}
1130         }
1131     }
1132 
1133     /** @dev returns the input address to string.
1134       * @param _addr address to convert as string.
1135       * @return address as string.
1136      */
1137     function _toString(address _addr) internal pure returns(string memory) {
1138         bytes32 value = bytes32(uint256(_addr));
1139         bytes memory alphabet = "0123456789abcdef";
1140 
1141         bytes memory str = new bytes(42);
1142         str[0] = '0';
1143         str[1] = 'x';
1144         for (uint i = 0; i < 20; i++) {
1145             str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
1146             str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
1147         }
1148         return string(str);
1149     }
1150 
1151     /** @dev gives back the reward to the extension.
1152       * @param amount to give back.
1153      */
1154     function _giveBack(uint256 amount) private {
1155         if(amount == 0) {
1156             return;
1157         }
1158         if (_rewardTokenAddress == address(0)) {
1159             IFarmExtension(_extension).backToYou{value : amount}(amount);
1160         } else {
1161             _safeApprove(_rewardTokenAddress, _extension, amount);
1162             IFarmExtension(_extension).backToYou(amount);
1163         }
1164     }
1165 
1166     /** @dev ensures the transfer from the contract to the extension.
1167       * @param amount amount to transfer.
1168      */
1169     function _ensureTransfer(uint256 amount) private returns(bool) {
1170         uint256 initialBalance = _rewardTokenAddress == address(0) ? address(this).balance : IERC20(_rewardTokenAddress).balanceOf(address(this));
1171         uint256 expectedBalance = initialBalance + amount;
1172         try IFarmExtension(_extension).transferTo(amount) {} catch {}
1173         uint256 actualBalance = _rewardTokenAddress == address(0) ? address(this).balance : IERC20(_rewardTokenAddress).balanceOf(address(this));
1174         if(actualBalance == expectedBalance) {
1175             return true;
1176         }
1177         _giveBack(actualBalance - initialBalance);
1178         return false;
1179     }
1180 }