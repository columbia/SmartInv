1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity =0.7.6;
3 pragma abicoder v2;
4 
5 import "@openzeppelin-0.7/contracts/math/SafeMath.sol";
6 import "@openzeppelin-0.7/contracts/token/ERC20/SafeERC20.sol";
7 import "./ActionGuards.sol";
8 import "./math/SafeInt256.sol";
9 import "./stubs/BalanceHandler.sol";
10 import "./stubs/TokenHandler.sol";
11 import "./global/StorageLayoutV2.sol";
12 import "./global/Constants.sol";
13 import "interfaces/notional/NotionalTreasury.sol";
14 import "interfaces/compound/ComptrollerInterface.sol";
15 import "interfaces/compound/CErc20Interface.sol";
16 import {WETH9_07 as WETH9} from "interfaces/WETH9_07.sol";
17 
18 contract TreasuryAction is StorageLayoutV2, ActionGuards, NotionalTreasury {
19     using SafeMath for uint256;
20     using SafeInt256 for int256;
21     using SafeERC20 for IERC20;
22     using TokenHandler for Token;
23 
24     IERC20 public immutable COMP;
25     Comptroller public immutable COMPTROLLER;
26     WETH9 public immutable WETH;
27 
28     /// @dev Emitted when treasury manager is updated
29     event TreasuryManagerChanged(address indexed previousManager, address indexed newManager);
30     /// @dev Emitted when reserve buffer value is updated
31     event ReserveBufferUpdated(uint16 currencyId, uint256 bufferAmount);
32 
33     /// @dev Throws if called by any account other than the owner.
34     modifier onlyOwner() {
35         require(owner == msg.sender, "Ownable: caller is not the owner");
36         _;
37     }
38 
39     /// @dev Harvest methods are only callable by the authorized treasury manager contract
40     modifier onlyManagerContract() {
41         require(treasuryManagerContract == msg.sender, "Caller is not the treasury manager");
42         _;
43     }
44 
45     /// @dev Checks if the currency ID is valid
46     function _checkValidCurrency(uint16 currencyId) internal view {
47         require(0 < currencyId && currencyId <= maxCurrencyId, "Invalid currency id");
48     }
49 
50     constructor(Comptroller _comptroller, WETH9 _weth) {
51         COMPTROLLER = _comptroller;
52         COMP = IERC20(_comptroller.getCompAddress());
53         WETH = _weth;
54     }
55 
56     /// @notice Sets the new treasury manager contract
57     function setTreasuryManager(address manager) external override onlyOwner {
58         emit TreasuryManagerChanged(treasuryManagerContract, manager);
59         treasuryManagerContract = manager;
60     }
61 
62     /// @notice Sets the reserve buffer. This is the amount of reserve balance to keep denominated in 1e8 
63     /// The reserve cannot be harvested if it's below this amount. This portion of the reserve will remain on 
64     /// the contract to act as a buffer against potential insolvency.
65     /// @param currencyId refers to the currency of the reserve
66     /// @param bufferAmount reserve buffer amount to keep in internal token precision (1e8)
67     function setReserveBuffer(uint16 currencyId, uint256 bufferAmount)
68         external
69         override
70         onlyOwner
71     {
72         _checkValidCurrency(currencyId);
73         reserveBuffer[currencyId] = bufferAmount;
74         emit ReserveBufferUpdated(currencyId, bufferAmount);
75     }
76 
77     /// @notice This is used in the case of insolvency. It allows the owner to re-align the reserve with its correct balance.
78     /// @param currencyId refers to the currency of the reserve
79     /// @param newBalance new reserve balance to set, must be less than the current balance
80     function setReserveCashBalance(uint16 currencyId, int256 newBalance)
81         external
82         override
83         onlyOwner
84     {
85         _checkValidCurrency(currencyId);
86         // prettier-ignore
87         (int256 reserveBalance, /* */, /* */, /* */) = BalanceHandler.getBalanceStorage(Constants.RESERVE, currencyId);
88         require(newBalance < reserveBalance, "cannot increase reserve balance");
89         // newBalance cannot be negative and is checked inside BalanceHandler.setReserveCashBalance
90         BalanceHandler.setReserveCashBalance(currencyId, newBalance);
91     }
92 
93     /// @notice Claims COMP incentives earned and transfers to the treasury manager contract.
94     /// @param cTokens a list of cTokens to claim incentives for
95     /// @return the balance of COMP claimed
96     function claimCOMPAndTransfer(address[] calldata cTokens)
97         external
98         override
99         onlyManagerContract
100         nonReentrant
101         returns (uint256)
102     {
103         // Take a snasphot of the COMP balance before we claim COMP so that we don't inadvertently transfer
104         // something we shouldn't.
105         uint256 balanceBefore = COMP.balanceOf(address(this));
106         COMPTROLLER.claimComp(address(this), cTokens);
107         // NOTE: If Notional ever lists COMP as a collateral asset it will be cCOMP instead and it
108         // will never hold COMP balances directly. In this case we can always transfer all the COMP
109         // off of the contract.
110         uint256 balanceAfter = COMP.balanceOf(address(this));
111         uint256 amountClaimed = balanceAfter.sub(balanceBefore);
112         // NOTE: the onlyManagerContract modifier prevents a transfer to address(0) here
113         COMP.safeTransfer(treasuryManagerContract, amountClaimed);
114         // NOTE: TreasuryManager contract will emit a COMPHarvested event
115         return amountClaimed;
116     }
117 
118     /// @notice redeems and transfers tokens to the treasury manager contract
119     function _redeemAndTransfer(
120         uint16 currencyId,
121         Token memory asset,
122         int256 assetInternalRedeemAmount
123     ) private returns (uint256) {
124         Token memory underlying = TokenHandler.getUnderlyingToken(currencyId);
125         int256 assetExternalRedeemAmount = asset.convertToExternal(assetInternalRedeemAmount);
126 
127         // This is the actual redeemed amount in underlying external precision
128         uint256 redeemedExternalUnderlying = asset
129             .redeem(underlying, assetExternalRedeemAmount.toUint())
130             .toUint();
131 
132         // NOTE: cETH redeems to ETH, converting it to WETH
133         if (underlying.tokenAddress == address(0)) {
134             WETH9(WETH).deposit{value: address(this).balance}();
135         }
136 
137         address underlyingAddress = underlying.tokenAddress == address(0)
138             ? address(WETH)
139             : underlying.tokenAddress;
140         IERC20(underlyingAddress).safeTransfer(treasuryManagerContract, redeemedExternalUnderlying);
141 
142         return redeemedExternalUnderlying;
143     }
144 
145     /// @notice Transfers some amount of reserve assets to the treasury manager contract to be invested
146     /// into the sNOTE pool.
147     /// @param currencies an array of currencies to transfer from Notional
148     function transferReserveToTreasury(uint16[] calldata currencies)
149         external
150         override
151         onlyManagerContract
152         nonReentrant
153         returns (uint256[] memory)
154     {
155         uint256[] memory amountsTransferred = new uint256[](currencies.length);
156 
157         for (uint256 i; i < currencies.length; i++) {
158             // Prevents duplicate currency IDs
159             if (i > 0) require(currencies[i] > currencies[i - 1], "IDs must be sorted");
160 
161             uint16 currencyId = currencies[i];
162 
163             _checkValidCurrency(currencyId);
164 
165             // Reserve buffer amount in INTERNAL_TOKEN_PRECISION
166             int256 bufferInternal = SafeInt256.toInt(reserveBuffer[currencyId]);
167 
168             // Reserve requirement not defined
169             if (bufferInternal == 0) continue;
170 
171             // prettier-ignore
172             (int256 reserveInternal, /* */, /* */, /* */) = BalanceHandler.getBalanceStorage(Constants.RESERVE, currencyId);
173 
174             // Do not withdraw anything if reserve is below or equal to reserve requirement
175             if (reserveInternal <= bufferInternal) continue;
176 
177             Token memory asset = TokenHandler.getAssetToken(currencyId);
178 
179             // Actual reserve amount allowed to be redeemed and transferred
180             int256 assetInternalRedeemAmount = reserveInternal.subNoNeg(bufferInternal);
181 
182             // Redeems cTokens and transfer underlying to treasury manager contract
183             amountsTransferred[i] = _redeemAndTransfer(
184                 currencyId,
185                 asset,
186                 assetInternalRedeemAmount
187             );
188 
189             // Updates the reserve balance
190             BalanceHandler.harvestExcessReserveBalance(
191                 currencyId,
192                 reserveInternal,
193                 assetInternalRedeemAmount
194             );
195         }
196 
197         // NOTE: TreasuryManager contract will emit an AssetsHarvested event
198         return amountsTransferred;
199     }
200 }