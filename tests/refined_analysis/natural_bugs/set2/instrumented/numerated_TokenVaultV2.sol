1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 pragma experimental ABIEncoderV2;
5 
6 import "./interfaces/ITokenVaultV2.sol";
7 import "./interfaces/ILockManager.sol";
8 import "./interfaces/IRevest.sol";
9 import "./interfaces/IOutputReceiver.sol";
10 
11 import "./utils/RevestAccessControl.sol";
12 import "./RevestSmartWallet.sol";
13 
14 import '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';
15 import "@openzeppelin/contracts/proxy/Clones.sol";
16 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
17 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
18 import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
19 
20 
21 /**
22  * This vault knows nothing about ownership. Only what fnftIds correspond to what configs
23  * and ensures that all FNFTs are backed by assets in the vault.
24  */
25 contract TokenVaultV2 is ITokenVaultV2, Ownable, RevestAccessControl {
26     using ERC165Checker for address;
27     using SafeERC20 for IERC20;
28 
29     /// Address to use for EIP-1167 smart-wallet creation calls
30     address public immutable TEMPLATE;
31 
32     /// Cutoff ID above which FNFTs are created from this contract
33     uint public immutable FNFT_CUTOFF;
34 
35     /// Maps fnftIds to their respective configs
36     mapping(uint => IRevest.FNFTConfig) private fnfts;
37 
38     /// Tracks migrations for updated staking contracts
39     mapping(address => address) public migrations;
40 
41     /// Used for calculations
42     uint private constant multiplierPrecision = 1 ether;
43 
44     /// The identifier for IOutputReceivers to return for use with ERC-165
45     bytes4 public constant OUTPUT_RECEIVER_INTERFACE_ID = type(IOutputReceiver).interfaceId;
46 
47 
48     constructor(
49         address provider, 
50         address[] memory oldOutputs, 
51         address[] memory newOutputs
52     ) RevestAccessControl(provider) {
53         RevestSmartWallet wallet = new RevestSmartWallet();
54         TEMPLATE = address(wallet);
55         FNFT_CUTOFF = getFNFTHandler().getNextId() - 1;
56         for(uint i = 0; i < oldOutputs.length; i++) {
57             migrations[oldOutputs[i]] = newOutputs[i];
58         }
59     }
60 
61     /**
62      * @notice Maps an fnftConfig object to a given FNFT ID
63      * @param fnftId the FNFT ID to map the config to
64      * @param fnftConfig the config to map to the ID
65      * @param quantity the quantity to create
66      * @param from the user generating this call
67      * @dev this can only ever be called from Revest.sol during the minting process
68      */
69     function createFNFT(uint fnftId, IRevest.FNFTConfig memory fnftConfig, uint quantity, address from) external override onlyRevestController {
70         mapFNFTToToken(fnftId, fnftConfig);
71         if(fnftConfig.asset != address(0)) {
72             emit DepositERC20(fnftConfig.asset, from, fnftId, fnftConfig.depositAmount * quantity, getFNFTAddress(fnftId));
73         }
74         emit CreateFNFT(fnftId, from);
75     }
76 
77     /**
78      * @notice allows for the withdrawal of unlocked FNFTs
79      * @param fnftId the FNFT ID to withdraw from
80      * @param quantity the number of FNFTs within that series to withdraw
81      * @param user the user requesting the withdrawal of funds
82      * @dev should only ever be called from Revest.sol
83      */
84     function withdrawToken(
85         uint fnftId,
86         uint quantity,
87         address user
88     ) external override onlyRevestController {
89         // If the FNFT is an old one, this just assigns to zero-value
90         IRevest.FNFTConfig memory fnft = fnfts[fnftId];
91         address asset = fnft.asset;
92         address pipeTo = fnft.pipeToContract;
93         uint amountToWithdraw;
94 
95         uint supplyBefore = getFNFTHandler().getSupply(fnftId) + quantity;
96         if(fnftId <= FNFT_CUTOFF) {
97             // Uses the old TokenVault
98             // Withdraw and remap
99             // Begin by getting the FNFT Config from the old TokenVault
100             address oldVault = addressesProvider.getLegacyTokenVault();
101 
102             fnft = ITokenVault(oldVault).getFNFT(fnftId);
103 
104             amountToWithdraw = quantity * fnft.depositAmount;
105             // Update vars to reflect accurate state
106             asset = fnft.asset;
107             // Modify output receivers to forward underlying value to this contract
108             if(fnft.pipeToContract != address(0)) {
109                 pipeTo = fnft.pipeToContract; // Store original output receiver destination
110                 fnft.pipeToContract = address(this);
111                 ITokenVault(oldVault).mapFNFTToToken(fnftId, fnft);
112 
113                 // Handle any migrations needed from old to new staking contract
114                 if(migrations[pipeTo] != address(0)) {
115                     pipeTo = migrations[pipeTo];
116                 }
117             }
118             // Call withdrawal method on old system
119             ITokenVault(oldVault).withdrawToken(fnftId, quantity, user);
120             // Very uncommon edge-case, no known system will use this, but need to cover regardless
121             if(pipeTo != address(0) && supplyBefore - quantity != 0) {
122                 // If there are still instances, need to re-write to accurate OutputRec for future withdrawals 
123                 fnft.pipeToContract = pipeTo;
124                 ITokenVault(oldVault).mapFNFTToToken(fnftId, fnft);
125             }
126 
127             // If value has been routed here, forward onto destination, then handle callback
128             if(pipeTo != address(0) && asset != address(0)) {
129                 // NB: The user has control of where these external calls go
130                 amountToWithdraw = IERC20(asset).balanceOf(address(this)); 
131                 IERC20(asset).safeTransfer(pipeTo, amountToWithdraw);
132             }
133 
134         } else {
135             // Handle any migrations needed from old to new staking contract
136             if(migrations[pipeTo] != address(0)) {
137                 pipeTo = migrations[pipeTo];
138             }
139             
140             // Deploy the smart wallet object
141             if(asset != address(0)) {
142                 // Real tokens, deploy smart-wallet
143                 address smartWallAdd = Clones.cloneDeterministic(TEMPLATE, keccak256(abi.encode(fnftId)));
144                 RevestSmartWallet wallet = RevestSmartWallet(smartWallAdd);
145                 // NB: The user has control of where this external call goes
146                 amountToWithdraw = quantity * IERC20(asset).balanceOf(smartWallAdd) / supplyBefore;
147                 if(pipeTo == address(0)) {
148                     wallet.withdraw(amountToWithdraw, asset, user);
149                 } else {
150                     wallet.withdraw(amountToWithdraw, asset, pipeTo);
151                 }
152             } 
153         }
154         
155         // Handle all callbacks from here, regardless of what system it was
156         // NB: This makes an external call and could be used for reentrancy:
157         //     all important systems on IOutputReceiver implementations should be
158         //     marked as nonReentrant to ensure that exploitation is impossible
159         //     or properly follow checks-effects-interactions
160         if(pipeTo != address(0) && pipeTo.supportsInterface(OUTPUT_RECEIVER_INTERFACE_ID)) {
161             IOutputReceiver(pipeTo).receiveRevestOutput(fnftId, asset, payable(user), quantity);
162         }
163 
164         // Perform clean-up 
165         if(supplyBefore - quantity == 0 && fnftId > FNFT_CUTOFF) {
166             removeFNFT(fnftId);
167         }
168         emit RedeemFNFT(fnftId, user);
169         if(asset != address(0) && amountToWithdraw > 0) {
170             emit WithdrawERC20(asset, user, fnftId, amountToWithdraw, getFNFTAddress(fnftId));
171         }
172     }
173 
174     /**
175      * @notice this function maps an FNFT config to an FNFT ID
176      * @param fnftId the FNFT ID to map to
177      * @param fnftConfig the config to map to that ID
178      * @dev this should only ever be called from Revest.sol
179      */
180     function mapFNFTToToken(
181         uint fnftId,
182         IRevest.FNFTConfig memory fnftConfig
183     ) public override onlyRevestController {
184         // Gas optimizations
185         fnfts[fnftId].asset =  fnftConfig.asset;
186         // We don't specify depositAmount or depositMul, neither are necessary anymore
187         if(fnftConfig.split > 0) {
188             fnfts[fnftId].split = fnftConfig.split;
189         }
190         if(fnftConfig.maturityExtension) {
191             fnfts[fnftId].maturityExtension = fnftConfig.maturityExtension;
192         }
193         if(fnftConfig.pipeToContract != address(0)) {
194             fnfts[fnftId].pipeToContract = fnftConfig.pipeToContract;
195         }
196         if(fnftConfig.isMulti) {
197             fnfts[fnftId].isMulti = fnftConfig.isMulti;
198             fnfts[fnftId].depositStopTime = fnftConfig.depositStopTime;
199         }
200         if(fnftConfig.nontransferrable){
201             fnfts[fnftId].nontransferrable = fnftConfig.nontransferrable;
202         }
203     }
204 
205     /**
206      * @notice Emits an event when we have an additional deposit 
207      * @param user the user who is making the deposit
208      * @param fnftId the ID of the FNFT being deposited
209      * @param tokenAmount the amount of tokens being deposited
210      * @dev this should only ever be called from Revest.sol
211      */
212     function recordAdditionalDeposit(
213         address user, 
214         uint fnftId, 
215         uint tokenAmount
216     ) external override onlyRevestController {
217         emit DepositERC20(fnfts[fnftId].asset, user, fnftId, tokenAmount, getFNFTAddress(fnftId));
218     }
219 
220     ///
221     /// Utility functions
222     ///
223 
224     /// Internal function to remove FNFT configs
225     function removeFNFT(uint fnftId) private {
226         delete fnfts[fnftId];
227     }
228 
229     /**
230      * @notice Given an FNFT config, clones it and returns a deep copy
231      * @param old an FNFT config to be cloned
232      * @return a new FNFT config that is a deep copy of the passed-in parameter
233      */
234     function cloneFNFTConfig(IRevest.FNFTConfig memory old) public pure override returns (IRevest.FNFTConfig memory) {
235         return IRevest.FNFTConfig({
236             asset: old.asset,
237             split: old.split,
238             depositAmount:old.depositAmount,
239             depositMul:old.depositMul,
240             maturityExtension: old.maturityExtension,
241             pipeToContract: old.pipeToContract,
242             isMulti : old.isMulti,
243             depositStopTime: old.depositStopTime,
244             nontransferrable: old.nontransferrable
245         });
246     }
247 
248     ///
249     /// Getters
250     ///
251 
252     /**
253      * @notice gets the current face-value of an FNFT: if it has an OutputReceiver, will source data from there
254      * @param fnftId the fnft to get the value of
255      * @return the face-value of the FNFT – for native Revest vault storage, this is guaranteed to be accurate
256      * @dev for FNFTs with OutputReceivers, this value is provided by the OutputReceiver and not gauranteed to be accurate
257      */
258     function getFNFTCurrentValue(uint fnftId) external view override returns (uint) {      
259         if(fnftId <= FNFT_CUTOFF) {
260             ITokenVault legacyVault = ITokenVault(addressesProvider.getLegacyTokenVault());
261             IRevest.FNFTConfig memory fnft = legacyVault.getFNFT(fnftId);
262             if(fnft.pipeToContract != address(0) && fnft.pipeToContract.supportsInterface(OUTPUT_RECEIVER_INTERFACE_ID)) {
263                 address migration = migrations[fnft.pipeToContract];
264                 if(migration != address(0) && migration.supportsInterface(OUTPUT_RECEIVER_INTERFACE_ID)) {
265                     // NB: The user has control of where this external view call goes
266                     return IOutputReceiver(migration).getValue((fnftId));
267                 } else if(migration == address(0)) {
268                     // NB: The user has control of where this external view call goes
269                     return IOutputReceiver(fnft.pipeToContract).getValue((fnftId));
270                 }
271             } else {
272                 return legacyVault.getFNFTCurrentValue(fnftId);
273             }
274         }
275 
276         // NB: The user has control of where this external call goes
277         if(fnfts[fnftId].pipeToContract.supportsInterface(OUTPUT_RECEIVER_INTERFACE_ID)) {
278             return IOutputReceiver(fnfts[fnftId].pipeToContract).getValue((fnftId));
279         }
280 
281         uint currentAmount = 0;
282         address asset = fnfts[fnftId].asset;
283         if(asset != address(0)) {
284             address smartWallet = getFNFTAddress(fnftId);
285             uint supply = getFNFTHandler().getSupply(fnftId);
286             // NB: The user has control of where this external call goes
287             return IERC20(asset).balanceOf(smartWallet) / supply;
288         }
289         // Default fall-through
290         return currentAmount;
291     }
292 
293     /**
294      * @notice Get the FNFT Config for a given FNFT ID
295      * @param fnftId the FNFT ID to get the config for
296      * @return the FNFT Config associated with the FNFT ID
297      * @dev for TokenVaultV2 FNFTs, depositAmount will not be recorded
298      */
299     function getFNFT(uint fnftId) public view override returns (IRevest.FNFTConfig memory) {
300         if(fnftId <= FNFT_CUTOFF) {
301             IRevest.FNFTConfig memory config = ITokenVault(addressesProvider.getLegacyTokenVault()).getFNFT(fnftId);
302             return config;
303         } else {
304             return fnfts[fnftId];
305         }
306     }
307 
308     /// Gets whether a given FNFT is nontransferrable
309     function getNontransferable(uint fnftId) external view override returns (bool) {
310         return getFNFT(fnftId).nontransferrable;
311     }
312     
313     /// Gets the number of splits remaining for a given FNFT
314     function getSplitsRemaining(uint fnftId) external view override returns (uint) {
315         return getFNFT(fnftId).split;
316     }
317 
318     /**
319      * @notice Retrieves the smart-wallet address associated with a given FNFT ID
320      * @param fnftId The FNFT Id to get the address for
321      * @return smartWallet The address for the smart-wallet where funds for the given FNFT ID are stored 
322      */
323     function getFNFTAddress(uint fnftId) public view override returns (address smartWallet) {
324         smartWallet = Clones.predictDeterministicAddress(TEMPLATE, keccak256(abi.encode(fnftId)));
325     }
326 
327     ///
328     /// Deprecated Functions
329     ///
330 
331     /**
332      * @dev Deprecated from TokenVaultV2 onwards
333      */
334     function splitFNFT(
335         uint fnftId,
336         uint[] memory newFNFTIds,
337         uint[] memory proportions,
338         uint quantity
339     ) external override onlyRevestController {}
340 
341     /**
342      * @dev Deprecated from TokenVaultV2 onwards
343      */
344     function depositToken(
345         uint fnftId,
346         uint transferAmount,
347         uint quantity
348     ) public override onlyRevestController {}
349 
350     /**
351      * @dev Deprecated from TokenVaultV2 onwards
352      */
353     function handleMultipleDeposits(uint, uint, uint) external override onlyRevestController {}
354 
355 }
