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
17 //  __ __ ___ _____ _____ _                     _____ _           _               
18 // |  |  |_  |  |  |   __|_|___ ___ ___ ___ ___|   __| |_ ___ ___| |_ ___ ___ _ _ 
19 // |_   _|  _|    -|   __| |   | .'|   |  _| -_|__   |  _|  _| .'|  _| -_| . | | |
20 //   |_| |___|__|__|__|  |_|_|_|__,|_|_|___|___|_____|_| |_| |__,|_| |___|_  |_  |
21 //                                                                       |___|___|
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {BaseStrategy, IAssetVault} from "./BaseStrategy.sol";
26 import {IY2KVault} from "./interfaces/IY2KVault.sol";
27 import {IY2KRewards} from "./interfaces/IY2KRewards.sol";
28 import {IFortressSwap} from "../interfaces/IFortressSwap.sol";
29 
30 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
31 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
32 import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
33 
34 contract Y2KFinanceStrategy is BaseStrategy {
35 
36     using SafeERC20 for IERC20;
37     
38     /// @notice The address of FortressSwap
39     address public swap;
40 
41     /// @notice The address of the Y2K token
42     address private constant Y2K = address(0x65c936f008BC34fE819bce9Fa5afD9dc2d49977f);
43     /// @notice The address of the WETH token
44     address private constant WETH = address(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1);
45 
46     /// @notice Array of vaults that were used
47     address[] vaults;
48     /// @notice Array of vault IDs that were used
49     uint256[] vaultIDs;
50 
51     /// @notice Indicates if a vault is used
52     mapping(address => bool) isVault;
53     /// @notice The address of the Y2K Rewards contract for a specific vault and ID
54     mapping(address => mapping(uint => address)) stakingRewards;
55 
56 
57     /********************************** Constructor **********************************/
58 
59     constructor(address _assetVault, address _platform, address _manager, address _swap)
60         BaseStrategy(_assetVault, _platform, _manager) {
61             if (!IFortressSwap(_swap).routeExists(Y2K, assetVaultPrimaryAsset)) revert InvalidSwap();
62             if (assetVaultPrimaryAsset != WETH) revert InvalidAssetVault();
63 
64             swap = _swap;
65         }
66 
67     /********************************** View Functions **********************************/
68 
69     function isActive() public view override returns (bool) {
70         if (isStrategiesActiveOverride) return false;
71         if (IERC20(assetVaultPrimaryAsset).balanceOf(address(this)) > 0) return true;
72 
73         address[] memory _vaults = vaults;
74         uint256[] memory _vaultIDs = vaultIDs;
75         for (uint256 i = 0; i < vaults.length; i++) {
76             if (IY2KVault(_vaults[i]).balanceOf(address(this), _vaultIDs[i]) > 0) return true;
77         }
78 
79         return false;
80     }
81 
82     /********************************** Manager Functions **********************************/
83 
84     // TODO - fix docs
85     /// @dev Executes the strategy - deposit into a Y2K Risk/Hedge Vault
86     /// @dev _configData:
87     /// @dev _index - index of the vault in the vaultFactory, determines the asset and the strike vault
88     /// @dev _amount - amount of the assetVaultPrimaryAsset to deposit, will be set to the balance if set to type(uint256).max
89     /// @dev _id - id of the vault in the vaultFactory, determines end date of the Epoch
90     /// @dev _type - true for Risk Vault, false for Hedge Vault
91     function execute(bytes memory _configData) external override onlyManager returns (uint256) {
92 
93         (uint256 _id, uint256 _amount, address _vault, address _stakingRewards) = abi.decode(_configData, (uint256, uint256, address, address));
94 
95         address _assetVaultPrimaryAsset = assetVaultPrimaryAsset;
96         if (_amount == type(uint256).max) {
97             _amount = IERC20(_assetVaultPrimaryAsset).balanceOf(address(this));
98         }
99 
100         if (!isVault[_vault]) {
101             isVault[_vault] = true;
102             vaults.push(_vault);
103             vaultIDs.push(_id);
104         }
105 
106         uint256 _before = IERC1155(_vault).balanceOf(address(this), _id);
107         IERC20(_assetVaultPrimaryAsset).safeApprove(_vault, _amount);
108         IY2KVault(_vault).deposit(_id, _amount, address(this));
109         // TODO - should revert because no ERC1155Receiver implemented
110         uint256 _shares = IERC1155(_vault).balanceOf(address(this), _id) - _before;
111 
112         if (_stakingRewards != address(0)) {
113             stakingRewards[_vault][_id] = _stakingRewards;
114 
115             IERC1155(_vault).setApprovalForAll(_stakingRewards, true);
116             IY2KRewards(_stakingRewards).stake(_shares);
117             IERC1155(_vault).setApprovalForAll(_stakingRewards, false);
118         }
119 
120         return _shares;
121     }
122 
123     // TODO - fix docs
124     /// @dev Terminates the strategy - withdraw from fortGLP
125     /// @dev _configData:
126     /// @dev _index - index of the vault in the vaultFactory, determines the asset and the strike vault
127     /// @dev _amount - amount of the assetVaultPrimaryAsset to deposit, will be set to the balance if set to type(uint256).max
128     /// @dev _id - id of the vault in the vaultFactory, determines end date of the Epoch
129     /// @dev _type - true for Risk Vault, false for Hedge Vault
130     function terminate(bytes memory _configData) external override onlyManager returns (uint256) {
131         
132         (uint256 _id, uint256 _shares, address _vault, bool _claimRewards) = abi.decode(_configData, (uint256,uint256,address,bool));
133         
134         address _assetVaultPrimaryAsset = assetVaultPrimaryAsset;
135         uint256 _before = IERC20(_assetVaultPrimaryAsset).balanceOf(address(this));
136         if (_shares == type(uint256).max) {
137             _shares = IERC1155(_vault).balanceOf(address(this), _id);
138         }
139 
140         address _stakingRewards = stakingRewards[_vault][_id];
141         if (_stakingRewards != address(0)) {
142             // TODO - should revert because no ERC1155Receiver implemented
143             IY2KRewards(_stakingRewards).withdraw(_shares);
144             if (_claimRewards) _getRewards(_stakingRewards);
145         }
146 
147         IY2KVault(_vault).withdraw(_id, _shares, address(this), address(this));
148 
149         return IY2KVault(_vault).balanceOf(address(this), _id) - _before;
150     }
151 
152     /// @dev Updates the fortressSwap address
153     function updateSwap(address _swap) external onlyManager {
154         if (IFortressSwap(_swap).routeExists(Y2K, assetVaultPrimaryAsset)) revert InvalidSwap();
155 
156         swap = _swap;
157     }
158 
159     /********************************** Internal Functions **********************************/
160 
161     /// @dev increases the balance of assetVaultPrimaryAsset by swapping Y2K tokens
162     function _getRewards(address _stakingRewards) internal {
163         address _y2k = Y2K;
164         uint256 before = IERC20(_y2k).balanceOf(address(this));
165         IY2KRewards(_stakingRewards).getReward();
166         uint256 _rewards = IERC20(_y2k).balanceOf(address(this)) - before;
167         
168         emit Y2KRewards(_rewards);
169 
170         if (_rewards > 0) {
171             address _swap = swap;
172             IERC20(_y2k).safeApprove(_swap, IERC20(_y2k).balanceOf(address(this)) - before);
173             _rewards = IFortressSwap(_swap).swap(_y2k, assetVaultPrimaryAsset, _rewards);
174 
175             emit PrimaryAssetRewards(_rewards);
176         } else {
177             revert NoRewards();
178         }
179     }
180 
181     /********************************** Events **********************************/
182 
183     event PrimaryAssetRewards(uint256 _rewards);
184     event Y2KRewards(uint256 _rewards);
185 
186     /********************************** Errors **********************************/
187 
188     error InvalidSwap();
189     error NoRewards();
190     error InvalidAssetVault();
191 }
