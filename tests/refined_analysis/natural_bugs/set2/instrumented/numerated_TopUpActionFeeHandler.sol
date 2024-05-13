1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
5 
6 import "../../../interfaces/actions/IActionFeeHandler.sol";
7 import "../../../interfaces/IController.sol";
8 import "../../../interfaces/tokenomics/IKeeperGauge.sol";
9 
10 import "../../../libraries/Errors.sol";
11 import "../../../libraries/ScaledMath.sol";
12 import "../../../libraries/AddressProviderHelpers.sol";
13 
14 import "../../LpToken.sol";
15 import "../../access/Authorization.sol";
16 import "../../pool/LiquidityPool.sol";
17 import "../../utils/Preparable.sol";
18 
19 /**
20  * @notice Contract to manage the distribution protocol fees
21  */
22 contract TopUpActionFeeHandler is IActionFeeHandler, Authorization, Preparable {
23     using ScaledMath for uint256;
24     using SafeERC20Upgradeable for LpToken;
25     using AddressProviderHelpers for IAddressProvider;
26 
27     bytes32 internal constant _KEEPER_FEE_FRACTION_KEY = "KeeperFee";
28     bytes32 internal constant _KEEPER_GAUGE_KEY = "KeeperGauge";
29     bytes32 internal constant _TREASURY_FEE_FRACTION_KEY = "TreasuryFee";
30 
31     address public immutable actionContract;
32     IController public immutable controller;
33 
34     mapping(address => uint256) public treasuryAmounts;
35     mapping(address => mapping(address => uint256)) public keeperRecords;
36 
37     event KeeperFeesClaimed(address indexed keeper, address token, uint256 totalClaimed);
38 
39     event FeesPayed(
40         address indexed payer,
41         address indexed keeper,
42         address token,
43         uint256 amount,
44         uint256 keeperAmount,
45         uint256 lpAmount
46     );
47 
48     constructor(
49         IController _controller,
50         address _actionContract,
51         uint256 keeperFee,
52         uint256 treasuryFee
53     ) Authorization(_controller.addressProvider().getRoleManager()) {
54         require(keeperFee + treasuryFee <= ScaledMath.ONE, Error.INVALID_AMOUNT);
55         actionContract = _actionContract;
56         controller = _controller;
57         _setConfig(_KEEPER_FEE_FRACTION_KEY, keeperFee);
58         _setConfig(_TREASURY_FEE_FRACTION_KEY, treasuryFee);
59     }
60 
61     function setInitialKeeperGaugeForToken(address lpToken, address _keeperGauge)
62         external
63         override
64         onlyGovernance
65         returns (bool)
66     {
67         require(getKeeperGauge(lpToken) == address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
68         require(_keeperGauge != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
69         _setConfig(_getKeeperGaugeKey(lpToken), _keeperGauge);
70         return true;
71     }
72 
73     /**
74      * @notice Transfers the keeper and treasury fees to the fee handler and burns LP fees.
75      * @param payer Account who's position the fees are charged on.
76      * @param beneficiary Beneficiary of the fees paid (usually this will be the keeper).
77      * @param amount Total fee value (both keeper and LP fees).
78      * @param lpTokenAddress Address of the lpToken used to pay fees.
79      * @return `true` if successful.
80      */
81     function payFees(
82         address payer,
83         address beneficiary,
84         uint256 amount,
85         address lpTokenAddress
86     ) external override returns (bool) {
87         require(msg.sender == actionContract, Error.UNAUTHORIZED_ACCESS);
88         // Handle keeper fees
89         uint256 keeperAmount = amount.scaledMul(getKeeperFeeFraction());
90         uint256 treasuryAmount = amount.scaledMul(getTreasuryFeeFraction());
91         LpToken lpToken = LpToken(lpTokenAddress);
92 
93         lpToken.safeTransferFrom(msg.sender, address(this), amount);
94 
95         address keeperGauge = getKeeperGauge(lpTokenAddress);
96         if (keeperGauge != address(0)) {
97             IKeeperGauge(keeperGauge).reportFees(beneficiary, keeperAmount, lpTokenAddress);
98         }
99 
100         // Accrue keeper and treasury fees here for periodic claiming
101         keeperRecords[beneficiary][lpTokenAddress] += keeperAmount;
102         treasuryAmounts[lpTokenAddress] += treasuryAmount;
103 
104         // Handle LP fees
105         uint256 lpAmount = amount - keeperAmount - treasuryAmount;
106         lpToken.burn(lpAmount);
107         emit FeesPayed(payer, beneficiary, lpTokenAddress, amount, keeperAmount, lpAmount);
108         return true;
109     }
110 
111     /**
112      * @notice Claim all accrued fees for an LPToken.
113      * @param beneficiary Address to claim the fees for.
114      * @param token Address of the lpToken for claiming.
115      * @return `true` if successful.
116      */
117     function claimKeeperFeesForPool(address beneficiary, address token)
118         external
119         override
120         returns (bool)
121     {
122         uint256 totalClaimable = keeperRecords[beneficiary][token];
123         require(totalClaimable > 0, Error.NOTHING_TO_CLAIM);
124         keeperRecords[beneficiary][token] = 0;
125 
126         LpToken lpToken = LpToken(token);
127         lpToken.safeTransfer(beneficiary, totalClaimable);
128 
129         emit KeeperFeesClaimed(beneficiary, token, totalClaimable);
130         return true;
131     }
132 
133     /**
134      * @notice Claim all accrued treasury fees for an LPToken.
135      * @param token Address of the lpToken for claiming.
136      * @return `true` if successful.
137      */
138     function claimTreasuryFees(address token) external override returns (bool) {
139         uint256 claimable = treasuryAmounts[token];
140         treasuryAmounts[token] = 0;
141         LpToken(token).safeTransfer(controller.addressProvider().getTreasury(), claimable);
142         return true;
143     }
144 
145     /**
146      * @notice Prepare update of keeper fee (with time delay enforced).
147      * @param newKeeperFee New keeper fee value.
148      * @return `true` if successful.
149      */
150     function prepareKeeperFee(uint256 newKeeperFee) external onlyGovernance returns (bool) {
151         require(newKeeperFee <= ScaledMath.ONE, Error.INVALID_AMOUNT);
152         return _prepare(_KEEPER_FEE_FRACTION_KEY, newKeeperFee);
153     }
154 
155     /**
156      * @notice Execute update of keeper fee (with time delay enforced).
157      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
158      * @return New keeper fee.
159      */
160     function executeKeeperFee() external returns (uint256) {
161         require(
162             pendingUInts256[_TREASURY_FEE_FRACTION_KEY] +
163                 pendingUInts256[_KEEPER_FEE_FRACTION_KEY] <=
164                 ScaledMath.ONE,
165             Error.INVALID_AMOUNT
166         );
167         return _executeUInt256(_KEEPER_FEE_FRACTION_KEY);
168     }
169 
170     function resetKeeperFee() external onlyGovernance returns (bool) {
171         return _resetUInt256Config(_KEEPER_FEE_FRACTION_KEY);
172     }
173 
174     function prepareKeeperGauge(address lpToken, address newKeeperGauge)
175         external
176         onlyGovernance
177         returns (bool)
178     {
179         return _prepare(_getKeeperGaugeKey(lpToken), newKeeperGauge);
180     }
181 
182     function executeKeeperGauge(address lpToken) external returns (address) {
183         return _executeAddress(_getKeeperGaugeKey(lpToken));
184     }
185 
186     function resetKeeperGauge(address lpToken) external onlyGovernance returns (bool) {
187         return _resetAddressConfig(_getKeeperGaugeKey(lpToken));
188     }
189 
190     /**
191      * @notice Prepare update of treasury fee (with time delay enforced).
192      * @param newTreasuryFee New treasury fee value.
193      * @return `true` if successful.
194      */
195     function prepareTreasuryFee(uint256 newTreasuryFee) external onlyGovernance returns (bool) {
196         require(newTreasuryFee <= ScaledMath.ONE, Error.INVALID_AMOUNT);
197         return _prepare(_TREASURY_FEE_FRACTION_KEY, newTreasuryFee);
198     }
199 
200     /**
201      * @notice Execute update of treasury fee (with time delay enforced).
202      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
203      * @return New treasury fee.
204      */
205     function executeTreasuryFee() external returns (uint256) {
206         require(
207             pendingUInts256[_TREASURY_FEE_FRACTION_KEY] +
208                 pendingUInts256[_KEEPER_FEE_FRACTION_KEY] <=
209                 ScaledMath.ONE,
210             Error.INVALID_AMOUNT
211         );
212         return _executeUInt256(_TREASURY_FEE_FRACTION_KEY);
213     }
214 
215     function resetTreasuryFee() external onlyGovernance returns (bool) {
216         return _resetUInt256Config(_TREASURY_FEE_FRACTION_KEY);
217     }
218 
219     function getKeeperFeeFraction() public view returns (uint256) {
220         return currentUInts256[_KEEPER_FEE_FRACTION_KEY];
221     }
222 
223     function getKeeperGauge(address lpToken) public view returns (address) {
224         return currentAddresses[_getKeeperGaugeKey(lpToken)];
225     }
226 
227     function getTreasuryFeeFraction() public view returns (uint256) {
228         return currentUInts256[_TREASURY_FEE_FRACTION_KEY];
229     }
230 
231     function _getKeeperGaugeKey(address lpToken) internal pure returns (bytes32) {
232         return keccak256(abi.encodePacked(_KEEPER_GAUGE_KEY, lpToken));
233     }
234 }
