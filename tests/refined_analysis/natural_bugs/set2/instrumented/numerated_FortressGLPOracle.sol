1 // // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
5 // ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
6 // █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
7 // ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
8 // ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
9 // ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
10 // ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
11 // ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
12 // █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
13 // ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
14 // ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
15 // ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝
16 
17 //  _____         _                   _____ __    _____ _____             _     
18 // |   __|___ ___| |_ ___ ___ ___ ___|   __|  |  |  _  |     |___ ___ ___| |___ 
19 // |   __| . |  _|  _|  _| -_|_ -|_ -|  |  |  |__|   __|  |  |  _| .'|  _| | -_|
20 // |__|  |___|_| |_| |_| |___|___|___|_____|_____|__|  |_____|_| |__,|___|_|___|                                                                           
21 
22 // Github - https://github.com/FortressFinance
23 
24 import {ERC4626} from "@solmate/mixins/ERC4626.sol";
25 import {AggregatorV3Interface} from "@chainlink/src/v0.8/interfaces/AggregatorV3Interface.sol";
26 import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
27 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
28 
29 import {IGlpManager} from "../interfaces/IGlpManager.sol";
30 
31 contract FortressGLPOracle is AggregatorV3Interface {
32 
33     using SafeCast for uint256;
34 
35     IGlpManager public immutable glpManager;
36     IERC20 public immutable glp;
37     ERC4626 public immutable fcGLP;
38 
39     uint256 public lastSharePrice;
40     uint256 public lowerBoundPercentage;
41     uint256 public upperBoundPercentage;
42     uint256 public vaultMaxSpread;
43 
44     address public owner;
45 
46     bool public isCheckPriceDeviation;
47 
48     uint256 constant private DECIMAL_DIFFERENCE = 1e6;
49     uint256 constant private BASE = 1e18;
50 
51     /********************************** Constructor **********************************/
52 
53     constructor(address _owner) {
54         glpManager = IGlpManager(address(0x3963FfC9dff443c2A94f21b129D429891E32ec18));
55         glp = IERC20(address(0x4277f8F2c384827B5273592FF7CeBd9f2C1ac258));
56         fcGLP = ERC4626(address(0x86eE39B28A7fDea01b53773AEE148884Db311B46));
57 
58         lowerBoundPercentage = 20;
59         upperBoundPercentage = 20;
60         
61         owner = _owner;
62 
63         uint256 _vaultSpread = fcGLP.convertToAssets(1e18);
64         vaultMaxSpread = _vaultSpread * 110 / 100; // limit to 10% of the vault spread
65 
66         lastSharePrice = uint256(_getPrice());
67 
68         isCheckPriceDeviation = true;
69     }
70 
71     /********************************** Modifiers **********************************/
72 
73     modifier onlyOwner() {
74         if (msg.sender != owner) revert notOwner();
75         _;
76     }
77 
78     /********************************** External Functions **********************************/
79 
80     function decimals() external pure returns (uint8) {
81         return 18;
82     }
83 
84     function description() external pure returns (string memory) {
85         return "fcGLP USD Oracle";
86     }
87 
88     function version() external pure returns (uint256) {
89         return 1;
90     }
91 
92     function getRoundData(uint80) external pure returns (uint80, int256, uint256, uint256, uint80) {
93         revert("Not implemented");
94     }
95 
96     function latestRoundData() external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) {
97         return (0, _getPrice(), 0, 0, 0);
98     }
99 
100     /********************************** Internal Functions **********************************/
101 
102     function _getPrice() internal view returns (int256) {
103         uint256 _assetPrice = glpManager.getPrice(false);
104 
105         uint256 _sharePrice = ((fcGLP.convertToAssets(_assetPrice) * DECIMAL_DIFFERENCE) / BASE);
106 
107         // check that fcGLP price deviation did not exceed the configured bounds
108         if (isCheckPriceDeviation) _checkPriceDeviation(_sharePrice);
109         _checkVaultSpread();
110 
111         return _sharePrice.toInt256();
112     }
113 
114     /// @dev make sure that GLP price has not deviated by more than x% since last recorded price
115     /// @dev used to limit the risk of GLP price manipulation
116     function _checkPriceDeviation(uint256 _sharePrice) internal view {
117         uint256 _lastSharePrice = lastSharePrice;
118         uint256 _lowerBound = (_lastSharePrice * (100 - lowerBoundPercentage)) / 100;
119         uint256 _upperBound = (_lastSharePrice * (100 + upperBoundPercentage)) / 100;
120 
121         if (_sharePrice < _lowerBound || _sharePrice > _upperBound) revert priceDeviationTooHigh();
122     }
123 
124     function _checkVaultSpread() internal view {
125         if (fcGLP.convertToAssets(1e18) > vaultMaxSpread) revert vaultMaxSpreadExceeded();
126     }
127 
128     /********************************** Owner Functions **********************************/
129 
130     /// @notice this function needs to be called periodically to update the last share price
131     function updateLastSharePrice() external onlyOwner {
132         lastSharePrice = ((fcGLP.convertToAssets(glpManager.getPrice(false)) * DECIMAL_DIFFERENCE) / BASE);
133 
134         emit LastSharePriceUpdated(lastSharePrice);
135     }
136 
137     function shouldCheckPriceDeviation(bool _check) external onlyOwner {
138         isCheckPriceDeviation = _check;
139 
140         emit PriceDeviationCheckUpdated(_check);
141     }
142 
143     function updatePriceDeviationBounds(uint256 _lowerBoundPercentage, uint256 _upperBoundPercentage) external onlyOwner {
144         lowerBoundPercentage = _lowerBoundPercentage;
145         upperBoundPercentage = _upperBoundPercentage;
146 
147         emit PriceDeviationBoundsUpdated(_lowerBoundPercentage, _upperBoundPercentage);
148     }
149 
150     function updateVaultMaxSpread(uint256 _vaultMaxSpread) external onlyOwner {
151         vaultMaxSpread = _vaultMaxSpread;
152 
153         emit VaultMaxSpreadUpdated(_vaultMaxSpread);
154     }
155 
156     function updateOwner(address _owner) external onlyOwner {
157         owner = _owner;
158 
159         emit OwnershipTransferred(owner, _owner);
160     }
161 
162     /********************************** Events **********************************/
163 
164     event LastSharePriceUpdated(uint256 lastSharePrice);
165     event PriceDeviationCheckUpdated(bool isCheckPriceDeviation);
166     event PriceDeviationBoundsUpdated(uint256 lowerBoundPercentage, uint256 upperBoundPercentage);
167     event VaultMaxSpreadUpdated(uint256 vaultMaxSpread);
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     /********************************** Errors **********************************/
171 
172     error priceDeviationTooHigh();
173     error vaultMaxSpreadExceeded();
174     error notOwner();
175 }