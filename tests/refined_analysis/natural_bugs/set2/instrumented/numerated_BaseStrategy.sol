1 // SPDX-License-Identifier: MIT
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
17 //  _____             _____ _           _               
18 // | __  |___ ___ ___|   __| |_ ___ ___| |_ ___ ___ _ _ 
19 // | __ -| .'|_ -| -_|__   |  _|  _| .'|  _| -_| . | | |
20 // |_____|__,|___|___|_____|_| |_| |__,|_| |___|_  |_  |
21 //                                             |___|___|
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
26 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
27 import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
28 
29 import {IAssetVault} from "../interfaces/IAssetVault.sol";
30 import {IMetaVault} from "../interfaces/IMetaVault.sol";
31 import {IStrategy} from "../interfaces/IStrategy.sol";
32 
33 abstract contract BaseStrategy is ReentrancyGuard, IStrategy {
34 
35     using SafeERC20 for IERC20;
36     
37     /// @notice The assetVault that manages this strategy vault
38     address public assetVault;
39     /// @notice The assetVault Primary Asset
40     address public assetVaultPrimaryAsset;
41     /// @notice The platform address
42     address public platform;
43     /// @notice The vault manager address
44     address public manager;
45     /// @notice Enables Platform to override isStrategiesActive value
46     bool public isStrategiesActiveOverride;
47 
48     /********************************** Constructor **********************************/
49     
50     constructor(address _assetVault, address _platform, address _manager) {
51         assetVault = _assetVault;
52         platform = _platform;
53         manager = _manager;
54 
55         assetVaultPrimaryAsset = IAssetVault(_assetVault).getAsset();
56         isStrategiesActiveOverride = false;
57     }
58 
59     /********************************* Modifiers **********************************/
60 
61     /// @notice Platform has admin access
62     modifier onlyAssetVault() {
63         if (msg.sender != assetVault && msg.sender != platform) revert Unauthorized();
64         _;
65     }
66 
67     modifier onlyPlatform() {
68         if (msg.sender != platform) revert Unauthorized();
69         _;
70     }
71 
72     /// @notice Platform has admin access
73     modifier onlyManager() {
74         if (msg.sender != manager && msg.sender != platform) revert Unauthorized();
75         _;
76     }
77 
78     /********************************** View Functions **********************************/
79 
80     /// @inheritdoc IStrategy
81     function isActive() public view virtual returns (bool) {
82         if (isStrategiesActiveOverride) return false;
83         if (IERC20(assetVaultPrimaryAsset).balanceOf(address(this)) > 0) return true;
84 
85         return false;
86     }
87 
88     /********************************** Asset Vault Functions **********************************/
89 
90     /// @inheritdoc IStrategy
91     function deposit(uint256 _amount) external virtual onlyAssetVault nonReentrant {
92         address _assetVaultPrimaryAsset = assetVaultPrimaryAsset;
93         uint256 _before = IERC20(_assetVaultPrimaryAsset).balanceOf(address(this));
94         IERC20(_assetVaultPrimaryAsset).safeTransferFrom(assetVault, address(this), _amount);
95         uint256 _amountIn = IERC20(_assetVaultPrimaryAsset).balanceOf(address(this)) - _before;
96         if (_amountIn != _amount) revert AmountMismatch();
97 
98         emit Deposit(block.timestamp, _amountIn);
99     }
100 
101     /// @inheritdoc IStrategy
102     function withdraw(uint256 _amount) public virtual onlyAssetVault nonReentrant {
103         address _assetVaultPrimaryAsset = assetVaultPrimaryAsset;
104         address _assetVault = assetVault;
105         uint256 _before = IERC20(_assetVaultPrimaryAsset).balanceOf(_assetVault);
106         IERC20(_assetVaultPrimaryAsset).safeTransfer(_assetVault, _amount);
107         uint256 _amountOut = IERC20(_assetVaultPrimaryAsset).balanceOf(_assetVault) - _before;
108         if (_amountOut != _amount) revert AmountMismatch();
109 
110         emit Withdraw(block.timestamp, _amountOut);
111     }
112 
113     /// @inheritdoc IStrategy
114     function withdrawAll() public virtual onlyAssetVault {
115         if (isActive()) revert StrategyActive();
116 
117         withdraw(IERC20(assetVaultPrimaryAsset).balanceOf(address(this)));
118     }
119 
120     /********************************** Manager Functions **********************************/
121 
122     /// @inheritdoc IStrategy
123     function execute(bytes memory _configData) external virtual onlyManager returns (uint256) {}
124 
125     /// @inheritdoc IStrategy
126     function terminate(bytes memory _configData) external virtual onlyManager returns (uint256) {}
127 
128     /********************************** Platform Functions **********************************/
129 
130     /// @inheritdoc IStrategy
131     function overrideActiveStatus(bool _isStrategiesActive) external onlyPlatform {
132         isStrategiesActiveOverride = _isStrategiesActive;
133 
134         emit ActiveStatusOverriden(block.timestamp, _isStrategiesActive);
135     }
136 
137     /// @inheritdoc IStrategy
138     function rescueERC20(uint256 _amount) external onlyPlatform {
139         IERC20(assetVaultPrimaryAsset).safeTransfer(platform, _amount);
140 
141         emit Rescue(_amount);
142     }
143 }