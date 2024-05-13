1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
6 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
7 import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
8 import {BoringOwnable} from "./utils/BoringOwnable.sol";
9 import {EIP1271Wallet} from "./utils/EIP1271Wallet.sol";
10 import {IVault, IAsset} from "interfaces/balancer/IVault.sol";
11 import {NotionalTreasuryAction} from "interfaces/notional/NotionalTreasuryAction.sol";
12 import {WETH9} from "interfaces/WETH9.sol";
13 import "interfaces/balancer/IPriceOracle.sol";
14 
15 contract TreasuryManager is
16     EIP1271Wallet,
17     BoringOwnable,
18     Initializable,
19     UUPSUpgradeable
20 {
21     using SafeERC20 for IERC20;
22 
23     /// @notice precision used to limit the amount of NOTE price impact (1e8 = 100%)
24     uint256 internal constant NOTE_PURCHASE_LIMIT_PRECISION = 1e8;
25 
26     NotionalTreasuryAction public immutable NOTIONAL;
27     IERC20 public immutable NOTE;
28     IVault public immutable BALANCER_VAULT;
29     ERC20 public immutable BALANCER_POOL_TOKEN;
30     address public immutable sNOTE;
31     bytes32 public immutable NOTE_ETH_POOL_ID;
32     address public immutable ASSET_PROXY;
33 
34     address public manager;
35     uint32 public refundGasPrice;
36     uint256 public notePurchaseLimit;
37 
38     event ManagementTransferred(address prevManager, address newManager);
39     event AssetsHarvested(uint16[] currencies, uint256[] amounts);
40     event COMPHarvested(address[] ctokens, uint256 amount);
41     event NOTEPurchaseLimitUpdated(uint256 purchaseLimit);
42 
43     /// @dev Restricted methods for the treasury manager
44     modifier onlyManager() {
45         require(msg.sender == manager, "Unauthorized");
46         _;
47     }
48 
49     constructor(
50         NotionalTreasuryAction _notional,
51         WETH9 _weth,
52         IVault _balancerVault,
53         bytes32 _noteETHPoolId,
54         IERC20 _note,
55         address _sNOTE,
56         address _assetProxy
57     ) EIP1271Wallet(_weth) initializer {
58         // prettier-ignore
59         (address poolAddress, /* */) = _balancerVault.getPool(_noteETHPoolId);
60         require(poolAddress != address(0));
61 
62         NOTIONAL = NotionalTreasuryAction(_notional);
63         sNOTE = _sNOTE;
64         NOTE = _note;
65         BALANCER_VAULT = _balancerVault;
66         NOTE_ETH_POOL_ID = _noteETHPoolId;
67         ASSET_PROXY = _assetProxy;
68         BALANCER_POOL_TOKEN = ERC20(poolAddress);
69     }
70 
71     function initialize(address _owner, address _manager) external initializer {
72         owner = _owner;
73         manager = _manager;
74         emit OwnershipTransferred(address(0), _owner);
75         emit ManagementTransferred(address(0), _manager);
76     }
77 
78     function approveToken(address token, uint256 amount) external onlyOwner {
79         IERC20(token).approve(ASSET_PROXY, amount);
80     }
81 
82     function setPriceOracle(address tokenAddress, address oracleAddress)
83         external
84         onlyOwner
85     {
86         _setPriceOracle(tokenAddress, oracleAddress);
87     }
88 
89     function setSlippageLimit(address tokenAddress, uint256 slippageLimit)
90         external
91         onlyOwner
92     {
93         _setSlippageLimit(tokenAddress, slippageLimit);
94     }
95 
96     function setNOTEPurchaseLimit(uint256 purchaseLimit) external onlyOwner {
97         require(
98             purchaseLimit <= NOTE_PURCHASE_LIMIT_PRECISION,
99             "purchase limit is too high"
100         );
101         notePurchaseLimit = purchaseLimit;
102         emit NOTEPurchaseLimitUpdated(purchaseLimit);
103     }
104 
105     function withdraw(address token, uint256 amount) external onlyOwner {
106         if (amount == type(uint256).max)
107             amount = IERC20(token).balanceOf(address(this));
108         IERC20(token).safeTransfer(owner, amount);
109     }
110 
111     function wrapToWETH() external onlyManager {
112         WETH.deposit{value: address(this).balance}();
113     }
114 
115     function setManager(address newManager) external onlyOwner {
116         emit ManagementTransferred(manager, newManager);
117         manager = newManager;
118     }
119 
120     /*** Manager Functionality  ***/
121 
122     /// @dev Will need to add a this method as a separate action behind the notional proxy
123     function harvestAssetsFromNotional(uint16[] calldata currencies)
124         external
125         onlyManager
126     {
127         uint256[] memory amountsTransferred = NOTIONAL
128             .transferReserveToTreasury(currencies);
129         emit AssetsHarvested(currencies, amountsTransferred);
130     }
131 
132     function harvestCOMPFromNotional(address[] calldata ctokens)
133         external
134         onlyManager
135     {
136         uint256 amountTransferred = NOTIONAL.claimCOMPAndTransfer(ctokens);
137         emit COMPHarvested(ctokens, amountTransferred);
138     }
139 
140     function investWETHToBuyNOTE(uint256 wethAmount) external onlyManager {
141         _investWETHToBuyNOTE(wethAmount);
142     }
143 
144     function _getNOTESpotPrice() public view returns (uint256) {
145         // prettier-ignore
146         (
147             /* address[] memory tokens */,
148             uint256[] memory balances,
149             /* uint256 lastChangeBlock */
150         ) = BALANCER_VAULT.getPoolTokens(NOTE_ETH_POOL_ID);
151 
152         // balances[0] = WETH
153         // balances[1] = NOTE
154         // increase NOTE precision to 1e18
155         uint256 noteBal = balances[1] * 1e10;
156 
157         // We need to multiply the numerator by 1e18 to preserve enough
158         // precision for the division
159         // NOTEWeight = 0.8
160         // ETHWeight = 0.2
161         // SpotPrice = (ETHBalance / 0.2 * 1e18) / (NOTEBalance / 0.8)
162         // SpotPrice = (ETHBalance * 5 * 1e18) / (NOTEBalance * 1.25)
163         // SpotPrice = (ETHBalance * 5 * 1e18) / (NOTEBalance * 125 / 100)
164 
165         return (balances[0] * 5 * 1e18) / ((noteBal * 125) / 100);
166     }
167 
168     function _investWETHToBuyNOTE(uint256 wethAmount) internal {
169         IAsset[] memory assets = new IAsset[](2);
170         assets[0] = IAsset(address(WETH));
171         assets[1] = IAsset(address(NOTE));
172         uint256[] memory maxAmountsIn = new uint256[](2);
173         maxAmountsIn[0] = wethAmount;
174         maxAmountsIn[1] = 0;
175 
176         IPriceOracle.OracleAverageQuery[]
177             memory queries = new IPriceOracle.OracleAverageQuery[](1);
178 
179         queries[0].variable = IPriceOracle.Variable.PAIR_PRICE;
180         queries[0].secs = 3600; // last hour
181         queries[0].ago = 0; // now
182 
183         // Gets the balancer time weighted average price denominated in ETH
184         uint256 noteOraclePrice = IPriceOracle(address(BALANCER_POOL_TOKEN))
185             .getTimeWeightedAverage(queries)[0];
186 
187         BALANCER_VAULT.joinPool(
188             NOTE_ETH_POOL_ID,
189             address(this),
190             sNOTE, // sNOTE will receive the BPT
191             IVault.JoinPoolRequest(
192                 assets,
193                 maxAmountsIn,
194                 abi.encode(
195                     IVault.JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT,
196                     maxAmountsIn,
197                     0 // Accept however much BPT the pool will give us
198                 ),
199                 false // Don't use internal balances
200             )
201         );
202 
203         uint256 noteSpotPrice = _getNOTESpotPrice();
204 
205         // Calculate the max spot price based on the purchase limit
206         uint256 maxPrice = noteOraclePrice +
207             (noteOraclePrice * notePurchaseLimit) /
208             NOTE_PURCHASE_LIMIT_PRECISION;
209 
210         require(noteSpotPrice <= maxPrice, "price impact is too high");
211     }
212 
213     function isValidSignature(bytes calldata data, bytes calldata signature)
214         external
215         view
216         returns (bytes4)
217     {
218         return _isValidSignature(data, signature, manager);
219     }
220 
221     function _authorizeUpgrade(address newImplementation)
222         internal
223         override
224         onlyOwner
225     {}
226 }
