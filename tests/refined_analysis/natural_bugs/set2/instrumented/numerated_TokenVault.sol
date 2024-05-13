1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 pragma experimental ABIEncoderV2;
5 
6 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
7 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
8 import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
9 import "./interfaces/ITokenVault.sol";
10 import "./interfaces/ILockManager.sol";
11 import "./interfaces/IRevest.sol";
12 import "./interfaces/IOutputReceiver.sol";
13 import "./interfaces/IInterestHandler.sol";
14 import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
15 import "./utils/RevestAccessControl.sol";
16 import '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';
17 
18 /**
19  * This vault knows nothing about ownership. Only what fnftIds correspond to what configs
20  * and ensures that all FNFTs are backed by assets in the vault.
21  */
22 contract TokenVault is ITokenVault, AccessControlEnumerable, RevestAccessControl {
23     using ERC165Checker for address;
24     using SafeERC20 for IERC20;
25 
26     event CreateFNFT(uint indexed fnftId, address indexed from);
27     event RedeemFNFT(uint indexed fnftId, address indexed from);
28 
29     mapping(uint => IRevest.FNFTConfig) private fnfts;
30 
31     mapping(address => IRevest.TokenTracker) public tokenTrackers;
32 
33     uint private constant multiplierPrecision = 1 ether;
34     bytes4 public constant OUTPUT_RECEIVER_INTERFACE_ID = type(IOutputReceiver).interfaceId;
35 
36 
37     constructor(address provider) RevestAccessControl(provider) {
38 
39     }
40 
41     function createFNFT(uint fnftId, IRevest.FNFTConfig memory fnftConfig, uint quantity, address from) external override {
42         mapFNFTToToken(fnftId, fnftConfig);
43         depositToken(fnftId, fnftConfig.depositAmount, quantity);
44         emit CreateFNFT(fnftId, from);
45     }
46 
47 
48     /**
49      * Grab the current balance of this address in the ERC20 and update the multiplier accordingly
50      */
51     function updateBalance(uint fnftId, uint incomingDeposit) internal {
52         IRevest.FNFTConfig storage fnft = fnfts[fnftId];
53         address asset = fnft.asset;
54         IRevest.TokenTracker storage tracker = tokenTrackers[asset];
55 
56         uint currentAmount;
57         uint lastBal = tracker.lastBalance;
58 
59         if(asset != address(0)){
60             currentAmount = IERC20(asset).balanceOf(address(this));
61         } else {
62             // Keep us from zeroing out zero assets
63             currentAmount = lastBal;
64         }
65         tracker.lastMul = lastBal == 0 ? multiplierPrecision : multiplierPrecision * currentAmount / lastBal;
66         tracker.lastBalance = currentAmount + incomingDeposit;
67     }
68 
69     /**
70      * This lines up the fnftId with its config and ensures that the fnftId -> config mapping
71      * is only created if the proper tokens are deposited.
72      * It does not handle the FNFT creation and assignment itself, that happens in Revest.sol
73      * PRECONDITION: fnftId maps to fnftConfig, as done in CreateFNFT()
74      */
75     function depositToken(
76         uint fnftId,
77         uint transferAmount,
78         uint quantity
79     ) public override onlyRevestController {
80         // Updates in advance, to handle rebasing tokens
81         updateBalance(fnftId, quantity * transferAmount);
82         IRevest.FNFTConfig storage fnft = fnfts[fnftId];
83         fnft.depositMul = tokenTrackers[fnft.asset].lastMul;
84     }
85 
86     function withdrawToken(
87         uint fnftId,
88         uint quantity,
89         address user
90     ) external override onlyRevestController {
91         IRevest.FNFTConfig storage fnft = fnfts[fnftId];
92         IRevest.TokenTracker storage tracker = tokenTrackers[fnft.asset];
93         address asset = fnft.asset;
94 
95         // Update multiplier first
96         updateBalance(fnftId, 0);
97 
98         uint withdrawAmount = fnft.depositAmount * quantity * tracker.lastMul / fnft.depositMul;
99         tracker.lastBalance -= withdrawAmount;
100 
101         address pipeTo = fnft.pipeToContract;
102         if (pipeTo == address(0)) {
103             if(asset != address(0)) {
104                 IERC20(asset).safeTransfer(user, withdrawAmount);
105             }
106         }
107         else {
108             if(fnft.depositAmount > 0 && asset != address(0)) {
109                 //Only transfer value if there is value to transfer
110                 IERC20(asset).safeTransfer(fnft.pipeToContract, withdrawAmount);
111             }
112             if(pipeTo.supportsInterface(OUTPUT_RECEIVER_INTERFACE_ID)) {
113                 // Callback to OutputReceiver
114                 IOutputReceiver(pipeTo).receiveRevestOutput(fnftId, asset, payable(user), quantity);
115             }
116         }
117 
118         if(getFNFTHandler().getSupply(fnftId) == 0) {
119             removeFNFT(fnftId);
120         }
121         emit RedeemFNFT(fnftId, _msgSender());
122     }
123 
124 
125     function mapFNFTToToken(
126         uint fnftId,
127         IRevest.FNFTConfig memory fnftConfig
128     ) public override onlyRevestController {
129         // Gas optimizations
130         fnfts[fnftId].asset =  fnftConfig.asset;
131         fnfts[fnftId].depositAmount =  fnftConfig.depositAmount;
132         if(fnftConfig.depositMul > 0) {
133             fnfts[fnftId].depositMul = fnftConfig.depositMul;
134         }
135         if(fnftConfig.split > 0) {
136             fnfts[fnftId].split = fnftConfig.split;
137         }
138         if(fnftConfig.maturityExtension) {
139             fnfts[fnftId].maturityExtension = fnftConfig.maturityExtension;
140         }
141         if(fnftConfig.pipeToContract != address(0)) {
142             fnfts[fnftId].pipeToContract = fnftConfig.pipeToContract;
143         }
144         if(fnftConfig.isMulti) {
145             fnfts[fnftId].isMulti = fnftConfig.isMulti;
146             fnfts[fnftId].depositStopTime = fnftConfig.depositStopTime;
147         }
148         if(fnftConfig.nontransferrable){
149             fnfts[fnftId].nontransferrable = fnftConfig.nontransferrable;
150         }
151     }
152 
153     function splitFNFT(
154         uint fnftId,
155         uint[] memory newFNFTIds,
156         uint[] memory proportions,
157         uint quantity
158     ) external override {
159         IRevest.FNFTConfig storage fnft = fnfts[fnftId];
160         updateBalance(fnftId, 0);
161         // Burn the original FNFT but keep its lock
162 
163         // Create new FNFTs with the same config, only thing changed is the depositAmount
164         // proportions should add up to 1000
165         uint denominator = 1000;
166         uint runningTotal = 0;
167         for(uint i = 0; i < proportions.length; i++) {
168             runningTotal += proportions[i];
169             uint amount = fnft.depositAmount * proportions[i] / denominator;
170             IRevest.FNFTConfig memory newFNFT = cloneFNFTConfig(fnft);
171             newFNFT.depositAmount = amount;
172             newFNFT.split -= 1;
173             mapFNFTToToken(newFNFTIds[i], newFNFT);
174             emit CreateFNFT(newFNFTIds[i], _msgSender());
175         }
176         // This is really a precondition but more efficient to place here
177         require(runningTotal == denominator, 'E054');
178         if(quantity == getFNFTHandler().getSupply(fnftId)) {
179             // We should also burn it
180             removeFNFT(fnftId);
181         }
182         emit RedeemFNFT(fnftId, _msgSender());
183     }
184 
185     function removeFNFT(uint fnftId) internal {
186         delete fnfts[fnftId];
187     }
188 
189     // amount = amount per vault for new mapping
190     function handleMultipleDeposits(
191         uint fnftId,
192         uint newFNFTId,
193         uint amount
194     ) external override onlyRevestController {
195         require(amount >= fnfts[fnftId].depositAmount, 'E003');
196         IRevest.FNFTConfig storage config = fnfts[fnftId];
197         config.depositAmount = amount;
198         mapFNFTToToken(fnftId, config);
199         if(newFNFTId != 0) {
200             mapFNFTToToken(newFNFTId, config);
201         }
202     }
203 
204     function cloneFNFTConfig(IRevest.FNFTConfig memory old) public pure override returns (IRevest.FNFTConfig memory) {
205         return IRevest.FNFTConfig({
206             asset: old.asset,
207             depositAmount: old.depositAmount,
208             depositMul: old.depositMul,
209             split: old.split,
210             maturityExtension: old.maturityExtension,
211             pipeToContract: old.pipeToContract,
212             isMulti : old.isMulti,
213             depositStopTime: old.depositStopTime,
214             nontransferrable: old.nontransferrable
215         });
216     }
217 
218     /**
219     // Getters
220     **/
221 
222     function getFNFTCurrentValue(uint fnftId) external view override returns (uint) {
223         if(fnfts[fnftId].pipeToContract.supportsInterface(OUTPUT_RECEIVER_INTERFACE_ID)) {
224             return IOutputReceiver(fnfts[fnftId].pipeToContract).getValue((fnftId));
225         }
226 
227         uint currentAmount = 0;
228         if(fnfts[fnftId].asset != address(0)) {
229             currentAmount = IERC20(fnfts[fnftId].asset).balanceOf(address(this));
230             IRevest.TokenTracker memory tracker = tokenTrackers[fnfts[fnftId].asset];
231             uint lastMul = tracker.lastBalance == 0 ? multiplierPrecision : multiplierPrecision * currentAmount / tracker.lastBalance;
232             return fnfts[fnftId].depositAmount * lastMul / fnfts[fnftId].depositMul;
233         }
234         // Default fall-through
235         return currentAmount;
236     }
237 
238     /**
239      * Getters
240      **/
241     function getFNFT(uint fnftId) external view override returns (IRevest.FNFTConfig memory) {
242         return fnfts[fnftId];
243     }
244 
245     function getNontransferable(uint fnftId) external view override returns (bool) {
246         return fnfts[fnftId].nontransferrable;
247     }
248 
249     function getSplitsRemaining(uint fnftId) external view override returns (uint) {
250         IRevest.FNFTConfig storage fnft = fnfts[fnftId];
251         return fnft.split;
252     }
253 }
