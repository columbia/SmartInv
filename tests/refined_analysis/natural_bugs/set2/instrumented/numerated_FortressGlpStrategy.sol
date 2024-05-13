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
17 //  _____         _                   _____ _     _____ _           _               
18 // |   __|___ ___| |_ ___ ___ ___ ___|   __| |___|   __| |_ ___ ___| |_ ___ ___ _ _ 
19 // |   __| . |  _|  _|  _| -_|_ -|_ -|  |  | | . |__   |  _|  _| .'|  _| -_| . | | |
20 // |__|  |___|_| |_| |_| |___|___|___|_____|_|  _|_____|_| |_| |__,|_| |___|_  |_  |
21 //                                           |_|                           |___|___|
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {BaseStrategy, IAssetVault} from "./BaseStrategy.sol";
26 
27 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
28 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
29 import {IFortGlp} from "./interfaces/IFortGlp.sol";
30 import {IFortressSwap} from "../interfaces/IFortressSwap.sol";
31 
32 contract FortressGlpStrategy is BaseStrategy {
33 
34     using SafeERC20 for IERC20;
35 
36     /// @notice The address of fortGLP
37     address public fortGlp;
38     /// @notice The address of FortressSwap
39     address public swap;
40 
41     /********************************** Constructor **********************************/
42 
43     constructor(address _assetVault, address _platform, address _manager, address _fortGlp, address _swap)
44         BaseStrategy(_assetVault, _platform, _manager) {
45             fortGlp = _fortGlp;
46             swap = _swap;
47         }
48 
49     /********************************** View Functions **********************************/
50 
51     function isActive() public view override returns (bool) {
52         if (isStrategiesActiveOverride) return false;
53         if (IERC20(assetVaultPrimaryAsset).balanceOf(address(this)) > 0) return true;
54         if (IERC20(fortGlp).balanceOf(address(this)) > 0) return true;
55 
56         return false;
57     }
58 
59     /********************************** Manager Functions **********************************/
60 
61     /// @dev Executes the strategy - deposit into fortGLP
62     /// @dev _configData expects _asset, _amount and _minAmount. If _amount is set to type(uint256).max, it will deposit all the funds
63     function execute(bytes memory _configData) external override onlyManager returns (uint256) {
64         (address _asset, uint256 _amount, uint256 _minAmount) = abi.decode(_configData, (address, uint256, uint256));
65 
66         address _assetVaultPrimaryAsset = assetVaultPrimaryAsset;
67         if (_amount == type(uint256).max) {
68             _amount = IERC20(_assetVaultPrimaryAsset).balanceOf(address(this));
69         }
70 
71         if (_asset != _assetVaultPrimaryAsset) {
72             address _swap = swap;
73             _approve(_assetVaultPrimaryAsset, _swap, _amount);
74             _amount = IFortressSwap(_swap).swap(_assetVaultPrimaryAsset, _asset, _amount);
75         }
76         
77         address _fortGlp = fortGlp;
78         _approve(_asset, _fortGlp, _amount);
79         uint256 _shares = IFortGlp(_fortGlp).depositUnderlying(_asset, address(this), _amount, _minAmount);
80 
81         return _shares;
82     }
83 
84     /// @dev Terminates the strategy - withdraw from fortGLP
85     /// @dev _configData expects _asset, _amount and _minAmount. If _amount is set to type(uint256).max, it will withdraw all the funds
86     function terminate(bytes memory _configData) external override onlyManager returns (uint256) {
87         (address _asset, uint256 _amount, uint256 _minAmount) = abi.decode(_configData, (address, uint256, uint256));
88 
89         if (_amount == type(uint256).max) {
90             _amount = IERC20(fortGlp).balanceOf(address(this));
91         }
92 
93         _amount = IFortGlp(fortGlp).redeemUnderlying(_asset, address(this), address(this), _amount, _minAmount);
94 
95         if (_asset != assetVaultPrimaryAsset) {
96             address _swap = swap;
97             _approve(_asset, _swap, _amount);
98             _amount = IFortressSwap(_swap).swap(_asset, assetVaultPrimaryAsset, _amount);
99         }
100 
101         return _amount;
102     }
103 
104     /// @dev Updates the fortressSwap address
105     function updateSwap(address _swap) external onlyManager {
106         swap = _swap;
107     }
108 
109     /********************************** Internal Functions **********************************/
110 
111     function _approve(address _asset, address _spender, uint256 _amount) internal {
112         IERC20(_asset).safeApprove(_spender, 0);
113         IERC20(_asset).safeApprove(_spender, _amount);
114     }
115 }
