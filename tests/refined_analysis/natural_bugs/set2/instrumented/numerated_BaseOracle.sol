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
17 //  _____             _____             _     
18 // | __  |___ ___ ___|     |___ ___ ___| |___ 
19 // | __ -| .'|_ -| -_|  |  |  _| .'|  _| | -_|
20 // |_____|__,|___|___|_____|_| |__,|___|_|___|
21 
22 // Github - https://github.com/FortressFinance
23 
24 import {ERC4626} from "@solmate/mixins/ERC4626.sol";
25 import {AggregatorV3Interface} from "@chainlink/src/v0.8/interfaces/AggregatorV3Interface.sol";
26 import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
27 
28 contract BaseOracle is AggregatorV3Interface {
29 
30     using SafeCast for uint256;
31 
32     uint256 public lastSharePrice;
33     uint256 public lowerBoundPercentage;
34     uint256 public upperBoundPercentage;
35     uint256 public vaultMaxSpread;
36 
37     address public owner;
38     address public vault;
39 
40     bool public isCheckPriceDeviation;
41 
42     uint256 constant internal DECIMAL_DIFFERENCE = 1e6;
43     uint256 constant internal BASE = 1e18;
44 
45     /********************************** Constructor **********************************/
46 
47     constructor(address _owner, address _vault) {
48 
49         lowerBoundPercentage = 20;
50         upperBoundPercentage = 20;
51         
52         owner = _owner;
53         vault = _vault;
54 
55         uint256 _vaultSpread = ERC4626(_vault).convertToAssets(1e18);
56         vaultMaxSpread = _vaultSpread * 110 / 100; // limit to 10% of the vault spread
57 
58         lastSharePrice = uint256(_getPrice());
59 
60         isCheckPriceDeviation = true;
61     }
62 
63     /********************************** Modifiers **********************************/
64 
65     modifier onlyOwner() {
66         if (msg.sender != owner) revert notOwner();
67         _;
68     }
69 
70     /********************************** External Functions **********************************/
71 
72     function decimals() external pure virtual returns (uint8) {
73         return 18;
74     }
75 
76     function description() external pure virtual returns (string memory) {
77         return "Fortress Oracle";
78     }
79 
80     function version() external pure virtual returns (uint256) {
81         return 1;
82     }
83 
84     function getRoundData(uint80) external pure virtual returns (uint80, int256, uint256, uint256, uint80) {
85         revert("Not implemented");
86     }
87 
88     function latestRoundData() external view virtual returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) {
89         return (0, _getPrice(), 0, 0, 0);
90     }
91 
92     /********************************** Internal Functions **********************************/
93 
94     function _getPrice() internal view virtual returns (int256) {}
95 
96     /// @dev make sure that lp token price has not deviated by more than x% since last recorded price
97     /// @dev used to limit the risk of lp token price manipulation
98     function _checkPriceDeviation(uint256 _sharePrice) internal view {
99         uint256 _lastSharePrice = lastSharePrice;
100         uint256 _lowerBound = (_lastSharePrice * (100 - lowerBoundPercentage)) / 100;
101         uint256 _upperBound = (_lastSharePrice * (100 + upperBoundPercentage)) / 100;
102 
103         if (_sharePrice < _lowerBound || _sharePrice > _upperBound) revert priceDeviationTooHigh();
104     }
105 
106     function _checkVaultSpread() internal view {
107         if (ERC4626(vault).convertToAssets(1e18) > vaultMaxSpread) revert vaultMaxSpreadExceeded();
108     }
109 
110     /********************************** Owner Functions **********************************/
111 
112     /// @notice this function needs to be called periodically to update the last share price
113     function updateLastSharePrice() external virtual onlyOwner {}
114 
115     function shouldCheckPriceDeviation(bool _check) external onlyOwner {
116         isCheckPriceDeviation = _check;
117 
118         emit PriceDeviationCheckUpdated(_check);
119     }
120 
121     function updatePriceDeviationBounds(uint256 _lowerBoundPercentage, uint256 _upperBoundPercentage) external onlyOwner {
122         lowerBoundPercentage = _lowerBoundPercentage;
123         upperBoundPercentage = _upperBoundPercentage;
124 
125         emit PriceDeviationBoundsUpdated(_lowerBoundPercentage, _upperBoundPercentage);
126     }
127 
128     function updateVaultMaxSpread(uint256 _vaultMaxSpread) external onlyOwner {
129         vaultMaxSpread = _vaultMaxSpread;
130 
131         emit VaultMaxSpreadUpdated(_vaultMaxSpread);
132     }
133 
134     function updateOwner(address _owner) external onlyOwner {
135         owner = _owner;
136 
137         emit OwnershipTransferred(owner, _owner);
138     }
139 
140     /********************************** Events **********************************/
141 
142     event LastSharePriceUpdated(uint256 lastSharePrice);
143     event PriceDeviationCheckUpdated(bool isCheckPriceDeviation);
144     event PriceDeviationBoundsUpdated(uint256 lowerBoundPercentage, uint256 upperBoundPercentage);
145     event VaultMaxSpreadUpdated(uint256 vaultMaxSpread);
146     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
147     event PriceFeedUpdated(address indexed usdtPriceFeed, address indexed usdcPriceFeed);
148 
149     /********************************** Errors **********************************/
150 
151     error priceDeviationTooHigh();
152     error vaultMaxSpreadExceeded();
153     error notOwner();
154     error zeroPrice();
155     error stalePrice();
156 }