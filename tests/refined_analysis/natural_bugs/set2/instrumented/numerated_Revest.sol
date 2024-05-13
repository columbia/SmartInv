1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 import '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';
7 import "./interfaces/IRevest.sol";
8 import "./interfaces/IAddressRegistry.sol";
9 import "./interfaces/ILockManager.sol";
10 import "./interfaces/ITokenVaultV2.sol";
11 import "./interfaces/IRewardsHandler.sol";
12 import "./interfaces/IOutputReceiver.sol";
13 import "./interfaces/IOutputReceiverV2.sol";
14 import "./interfaces/IOutputReceiverV3.sol";
15 import "./interfaces/IAddressLock.sol";
16 import "./utils/RevestAccessControl.sol";
17 import "./utils/RevestReentrancyGuard.sol";
18 import "./lib/IWETH.sol";
19 
20 /**
21  * This is the entrypoint for the frontend, as well as third-party Revest integrations.
22  * Solidity style guide ordering: receive, fallback, external, public, internal, private - within a grouping, view and pure go last - https://docs.soliditylang.org/en/latest/style-guide.html
23  */
24 contract RevestA4 is IRevest, RevestAccessControl, RevestReentrancyGuard {
25     using SafeERC20 for IERC20;
26     using ERC165Checker for address;
27 
28     bytes4 public constant ADDRESS_LOCK_INTERFACE_ID = type(IAddressLock).interfaceId;
29     bytes4 public constant OUTPUT_RECEIVER_INTERFACE_V2_ID = type(IOutputReceiverV2).interfaceId;
30     bytes4 public constant OUTPUT_RECEIVER_INTERFACE_V3_ID = type(IOutputReceiverV3).interfaceId;
31 
32     address immutable WETH;
33 
34     /// Point at which FNFTs should point to the new token vault
35 
36     uint public erc20Fee; // out of 1000
37     uint private constant erc20multiplierPrecision = 1000;
38     uint public flatWeiFee;
39     uint private constant MAX_INT = 2**256 - 1;
40 
41     mapping(address => bool) private approved;
42 
43     mapping(address => bool) public whitelisted;
44 
45     
46     /**
47      * @dev Primary constructor to create the Revest controller contract
48      */
49     constructor(
50         address provider, 
51         address weth
52     ) RevestAccessControl(provider) {
53         WETH = weth;
54     }
55 
56     // PUBLIC FUNCTIONS
57 
58     /**
59      * @dev creates a single time-locked NFT with <quantity> number of copies with <amount> of <asset> stored for each copy
60      * asset - the address of the underlying ERC20 token for this bond
61      * amount - the amount to store per NFT if multiple NFTs of this variety are being created
62      * unlockTime - the timestamp at which this will unlock
63      * quantity – the number of FNFTs to create with this operation     
64      */
65     function mintTimeLock(
66         uint endTime,
67         address[] memory recipients,
68         uint[] memory quantities,
69         IRevest.FNFTConfig memory fnftConfig
70     ) external payable override nonReentrant returns (uint) {
71         // Get the next id
72         uint fnftId = getFNFTHandler().getNextId();
73         // Get or create lock based on time, assign lock to ID
74         {
75             IRevest.LockParam memory timeLock;
76             timeLock.lockType = IRevest.LockType.TimeLock;
77             timeLock.timeLockExpiry = endTime;
78             getLockManager().createLock(fnftId, timeLock);
79         }
80 
81         doMint(recipients, quantities, fnftId, fnftConfig, msg.value);
82 
83         emit FNFTTimeLockMinted(fnftConfig.asset, _msgSender(), fnftId, endTime, quantities, fnftConfig);
84 
85         return fnftId;
86     }
87 
88     function mintValueLock(
89         address primaryAsset,
90         address compareTo,
91         uint unlockValue,
92         bool unlockRisingEdge,
93         address oracleDispatch,
94         address[] memory recipients,
95         uint[] memory quantities,
96         IRevest.FNFTConfig memory fnftConfig
97     ) external payable override nonReentrant returns (uint) {
98         // copy the fnftId
99         uint fnftId = getFNFTHandler().getNextId();
100         // Initialize the lock structure
101         {
102             IRevest.LockParam memory valueLock;
103             valueLock.lockType = IRevest.LockType.ValueLock;
104             valueLock.valueLock.unlockRisingEdge = unlockRisingEdge;
105             valueLock.valueLock.unlockValue = unlockValue;
106             valueLock.valueLock.asset = primaryAsset;
107             valueLock.valueLock.compareTo = compareTo;
108             valueLock.valueLock.oracle = oracleDispatch;
109 
110             getLockManager().createLock(fnftId, valueLock);
111         }
112 
113         doMint(recipients, quantities, fnftId, fnftConfig, msg.value);
114 
115         emit FNFTValueLockMinted(fnftConfig.asset,  _msgSender(), fnftId, compareTo, oracleDispatch, quantities, fnftConfig);
116 
117         return fnftId;
118     }
119 
120     function mintAddressLock(
121         address trigger,
122         bytes memory arguments,
123         address[] memory recipients,
124         uint[] memory quantities,
125         IRevest.FNFTConfig memory fnftConfig
126     ) external payable override nonReentrant returns (uint) {
127         uint fnftId = getFNFTHandler().getNextId();
128 
129         {
130             IRevest.LockParam memory addressLock;
131             addressLock.addressLock = trigger;
132             addressLock.lockType = IRevest.LockType.AddressLock;
133             // Get or create lock based on address which can trigger unlock, assign lock to ID
134             uint lockId = getLockManager().createLock(fnftId, addressLock);
135 
136             // The lock ID is already incremented prior to calling a method that could allow for reentry
137             if(trigger.supportsInterface(ADDRESS_LOCK_INTERFACE_ID)) {
138                 IAddressLock(trigger).createLock(fnftId, lockId, arguments);
139             }
140         }
141         // This is a public call to a third-party contract. Must be done after everything else.
142         doMint(recipients, quantities, fnftId, fnftConfig, msg.value);
143 
144         emit FNFTAddressLockMinted(fnftConfig.asset, _msgSender(), fnftId, trigger, quantities, fnftConfig);
145 
146         return fnftId;
147     }
148 
149     function withdrawFNFT(uint fnftId, uint quantity) external override nonReentrant {
150         _withdrawFNFT(fnftId, quantity);
151     }
152 
153     /// Advanced FNFT withdrawals removed for the time being – no active implementations
154     /// Represents slightly increased surface area – may be utilized in Resolve
155 
156     function unlockFNFT(uint fnftId) external override nonReentrant  {
157         // Works for value locks or time locks
158         IRevest.LockType lock = getLockManager().lockTypes(fnftId);
159         require(lock == IRevest.LockType.AddressLock || lock == IRevest.LockType.ValueLock, "E008");
160         require(getLockManager().unlockFNFT(fnftId, _msgSender()), "E056");
161 
162         emit FNFTUnlocked(_msgSender(), fnftId);
163     }
164 
165     function splitFNFT(
166         uint fnftId,
167         uint[] memory proportions,
168         uint quantity
169     ) external override nonReentrant returns (uint[] memory) {
170         // Splitting is entirely disabled for the time being
171         revert("TMP_BRK");
172     }
173 
174     /// @return the FNFT ID
175     function extendFNFTMaturity(
176         uint fnftId,
177         uint endTime
178     ) external override nonReentrant returns (uint) {
179         IFNFTHandler fnftHandler = getFNFTHandler();
180         uint supply = fnftHandler.getSupply(fnftId);
181         uint balance = fnftHandler.getBalance(_msgSender(), fnftId);
182 
183         require(endTime > block.timestamp, 'E002');
184         require(fnftId < fnftHandler.getNextId(), "E007");
185         require(balance == supply , "E022");
186         
187         IRevest.FNFTConfig memory config = getTokenVault().getFNFT(fnftId);
188         ILockManager manager = getLockManager();
189         // If it can't have its maturity extended, revert
190         // Will also return false on non-time lock locks
191         require(config.maturityExtension &&
192             manager.lockTypes(fnftId) == IRevest.LockType.TimeLock, "E029");
193         // If desired maturity is below existing date, reject operation
194         require(manager.fnftIdToLock(fnftId).timeLockExpiry < endTime, "E030");
195 
196         // Update the lock
197         IRevest.LockParam memory lock;
198         lock.lockType = IRevest.LockType.TimeLock;
199         lock.timeLockExpiry = endTime;
200 
201         manager.createLock(fnftId, lock);
202 
203         // Callback to IOutputReceiverV3
204         // NB: All IOuputReceiver systems should be either marked non-reentrant or ensure they follow checks-effects-interactions
205         if(config.pipeToContract != address(0) && config.pipeToContract.supportsInterface(OUTPUT_RECEIVER_INTERFACE_V3_ID)) {
206             IOutputReceiverV3(config.pipeToContract).handleTimelockExtensions(fnftId, endTime, _msgSender());
207         }
208 
209         emit FNFTMaturityExtended(_msgSender(), fnftId, endTime);
210 
211         return fnftId;
212     }
213 
214     /**
215      * Amount will be per FNFT. So total ERC20s needed is amount * quantity.
216      * We don't charge an ETH fee on depositAdditional, but do take the erc20 percentage.
217      */
218     function depositAdditionalToFNFT(
219         uint fnftId,
220         uint amount,
221         uint quantity
222     ) external override nonReentrant returns (uint) {
223         address vault = addressesProvider.getTokenVault();
224         IRevest.FNFTConfig memory fnft = ITokenVault(vault).getFNFT(fnftId);
225         address handler = addressesProvider.getRevestFNFT();
226         require(fnftId < IFNFTHandler(handler).getNextId(), "E007");
227         require(fnft.isMulti, "E034");
228         require(fnft.depositStopTime > block.timestamp || fnft.depositStopTime == 0, "E035");
229         require(quantity > 0, "E070");
230         // This line will disable all legacy FNFTs from using this function
231         // Unless they are using it for pass-through
232         require(fnft.depositMul == 0 || fnft.asset == address(0), 'E084');
233 
234         uint supply = IFNFTHandler(handler).getSupply(fnftId);
235         uint deposit = quantity * amount;
236 
237         // Future versions may reintroduce series splitting, if it is ever in demand
238         require(quantity == supply, 'E083');
239 
240         // Transfer the ERC20 fee to the admin address, leave it at that
241         if(!whitelisted[_msgSender()]) {
242             uint totalERC20Fee = erc20Fee * deposit / erc20multiplierPrecision;
243             if(totalERC20Fee > 0) {
244                 // NB: The user has control of where this external call goes (fnft.asset)
245                 IERC20(fnft.asset).safeTransferFrom(_msgSender(), addressesProvider.getAdmin(), totalERC20Fee);
246             }
247         }
248 
249 
250         // Transfer to the smart wallet
251         if(fnft.asset != address(0)){
252             address smartWallet = ITokenVaultV2(vault).getFNFTAddress(fnftId);
253             // NB: The user has control of where this external call goes (fnft.asset)
254             IERC20(fnft.asset).safeTransferFrom(_msgSender(), smartWallet, deposit);
255             ITokenVaultV2(vault).recordAdditionalDeposit(_msgSender(), fnftId, deposit);
256         }
257                        
258         if(fnft.pipeToContract != address(0) && fnft.pipeToContract.supportsInterface(OUTPUT_RECEIVER_INTERFACE_V3_ID)) {
259             IOutputReceiverV3(fnft.pipeToContract).handleAdditionalDeposit(fnftId, amount, quantity, _msgSender());
260         }
261 
262         emit FNFTAddionalDeposited(_msgSender(), fnftId, quantity, amount);
263 
264         return 0;
265     }
266 
267     //
268     // INTERNAL FUNCTIONS
269     //
270 
271     // Private function for use in withdrawing FNFTs, allow us to make universal use of reentrancy guard 
272     function _withdrawFNFT(uint fnftId, uint quantity) private {
273         address fnftHandler = addressesProvider.getRevestFNFT();
274 
275         // Check if this many FNFTs exist in the first place for the given ID
276         require(quantity > 0, "E003");
277         // Burn the FNFTs being exchanged
278         IFNFTHandler(fnftHandler).burn(_msgSender(), fnftId, quantity);
279         require(getLockManager().unlockFNFT(fnftId, _msgSender()), 'E082');
280         address vault = addressesProvider.getTokenVault();
281 
282         ITokenVault(vault).withdrawToken(fnftId, quantity, _msgSender());
283         emit FNFTWithdrawn(_msgSender(), fnftId, quantity);
284     }
285 
286     function doMint(
287         address[] memory recipients,
288         uint[] memory quantities,
289         uint fnftId,
290         IRevest.FNFTConfig memory fnftConfig,
291         uint weiValue
292     ) internal {
293         bool isSingular;
294         uint totalQuantity = quantities[0];
295         {
296             uint rec = recipients.length;
297             uint quant = quantities.length;
298             require(rec == quant, "recipients and quantities arrays must match");
299             // Calculate total quantity
300             isSingular = rec == 1;
301             if(!isSingular) {
302                 for(uint i = 1; i < quant; i++) {
303                     totalQuantity += quantities[i];
304                 }
305             }
306             require(totalQuantity > 0, "E003");
307         }
308 
309         // Gas optimization
310         // Will always be new token vault
311         address vault = addressesProvider.getTokenVault();
312 
313         // Take fees
314         if(weiValue > 0) {
315             // Immediately convert all ETH to WETH
316             IWETH(WETH).deposit{value: weiValue}();
317         }
318 
319         // For multi-chain deployments, will relay through RewardsHandlerSimplified to end up in admin wallet
320         // Whitelist system will charge fees on all but approved parties, who may charge them using negotiated
321         // values with the Revest Protocol
322         if(!whitelisted[_msgSender()]) {
323             if(flatWeiFee > 0) {
324                 require(weiValue >= flatWeiFee, "E005");
325                 address reward = addressesProvider.getRewardsHandler();
326                 if(!approved[reward]) {
327                     IERC20(WETH).approve(reward, MAX_INT);
328                     approved[reward] = true;
329                 }
330                 IRewardsHandler(reward).receiveFee(WETH, flatWeiFee);
331             }
332             
333             // If we aren't depositing any value, no point running this
334             if(fnftConfig.depositAmount > 0) {
335                 uint totalERC20Fee = erc20Fee * totalQuantity * fnftConfig.depositAmount / erc20multiplierPrecision;
336                 if(totalERC20Fee > 0) {
337                     // NB: The user has control of where this external call goes (fnftConfig.asset)
338                     IERC20(fnftConfig.asset).safeTransferFrom(_msgSender(), addressesProvider.getAdmin(), totalERC20Fee);
339                 }
340             }
341 
342             // If there's any leftover ETH after the flat fee, convert it to WETH
343             weiValue -= flatWeiFee;
344         }
345         
346         // Convert ETH to WETH if necessary
347         if(weiValue > 0) {
348             // If the asset is WETH, we also enable sending ETH to pay for the tx fee. Not required though
349             require(fnftConfig.asset == WETH, "E053");
350             require(weiValue >= fnftConfig.depositAmount, "E015");
351         }
352         
353         
354         // Create the FNFT and update accounting within TokenVault
355         ITokenVault(vault).createFNFT(fnftId, fnftConfig, totalQuantity, _msgSender());
356 
357         // Now, we move the funds to token vault from the message sender
358         if(fnftConfig.asset != address(0)){
359             address smartWallet = ITokenVaultV2(vault).getFNFTAddress(fnftId);
360             // NB: The user has control of where this external call goes (fnftConfig.asset)
361             IERC20(fnftConfig.asset).safeTransferFrom(_msgSender(), smartWallet, totalQuantity * fnftConfig.depositAmount);
362         }
363         // Mint NFT
364         // Gas optimization
365         if(!isSingular) {
366             getFNFTHandler().mintBatchRec(recipients, quantities, fnftId, totalQuantity, '');
367         } else {
368             getFNFTHandler().mint(recipients[0], fnftId, quantities[0], '');
369         }
370 
371     }
372 
373     function setFlatWeiFee(uint wethFee) external override onlyOwner {
374         flatWeiFee = wethFee;
375     }
376 
377     function setERC20Fee(uint erc20) external override onlyOwner {
378         erc20Fee = erc20;
379     }
380 
381     function getFlatWeiFee() external view override returns (uint) {
382         return flatWeiFee;
383     }
384 
385     function getERC20Fee() external view override returns (uint) {
386         return erc20Fee;
387     }
388 
389     /**
390      * @dev Returns the cached IAddressRegistry connected to this contract
391      **/
392     function getAddressesProvider() external view returns (IAddressRegistry) {
393         return addressesProvider;
394     }
395 
396 
397     /// Used to whitelist a contract for custom fee behavior
398     function modifyWhitelist(address contra, bool listed) external onlyOwner {
399         whitelisted[contra] = listed;
400     }
401 
402     
403 
404 }
