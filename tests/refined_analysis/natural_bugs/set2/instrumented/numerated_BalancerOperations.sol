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
17 //  _____     _                     _____                 _   _             
18 // | __  |___| |___ ___ ___ ___ ___|     |___ ___ ___ ___| |_|_|___ ___ ___ 
19 // | __ -| .'| | .'|   |  _| -_|  _|  |  | . | -_|  _| .'|  _| | . |   |_ -|
20 // |_____|__,|_|__,|_|_|___|___|_| |_____|  _|___|_| |__,|_| |_|___|_|_|___|
21 //                                       |_|                                
22 
23 // Github - https://github.com/FortressFinance
24 
25 import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
26 import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
27 
28 import "src/shared/fortress-interfaces/IFortressSwap.sol";
29 import "src/shared/interfaces/IWETH.sol";
30 
31 import "src/shared/interfaces/IBalancerVault.sol";
32 import "src/shared/interfaces/IBalancerPool.sol";
33 
34 contract BalancerOperations {
35 
36     using SafeERC20 for IERC20;
37 
38     /// @notice The address of Balancer vault.
39     address internal constant BALANCER_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
40     /// @notice The address representing ETH.
41     address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
42     /// @notice The address of WETH.
43     address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
44     
45     function _addLiquidity(address _poolAddress, address _asset, uint256 _amount) internal returns (uint256) {
46         bytes32 _poolId = IBalancerPool(_poolAddress).getPoolId();
47         IBalancerVault _vault = IBalancerVault(BALANCER_VAULT);
48 
49         (address[] memory _tokens,,) = _vault.getPoolTokens(_poolId);
50 
51         uint256 _before = IERC20(_poolAddress).balanceOf(address(this));
52         
53         if (_asset == ETH) {
54             _wrapETH(_amount);
55             _asset = WETH;
56         }
57         
58         uint256[] memory _amounts = new uint256[](_tokens.length);
59         for (uint256 _i = 0; _i < _tokens.length; _i++) {
60             if (_tokens[_i] == _asset) {
61                 _amounts[_i] = _amount;
62 
63                 uint256[] memory _noBptAmounts = _isComposablePool(_tokens, _poolAddress) ? _dropBptItem(_tokens, _amounts, _poolAddress) : _amounts;
64                 
65                 _approveOperations(_tokens[_i], address(_vault), _amount);
66                 _vault.joinPool(
67                     _poolId,
68                     address(this), // sender
69                     address(this), // recipient
70                     IBalancerVault.JoinPoolRequest({
71                         assets: _tokens,
72                         maxAmountsIn: _amounts,
73                         userData: abi.encode(
74                             IBalancerVault.JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT,
75                             _noBptAmounts, // amountsIn
76                             0 // minimumBPT
77                         ),
78                         fromInternalBalance: false
79                     })
80                 );
81                 break;
82             }
83         }
84         return (IERC20(_poolAddress).balanceOf(address(this)) - _before);
85     }
86 
87     function _removeLiquidity(address _poolAddress, address _asset, uint256 _bptAmountIn) internal returns (uint256) {
88         bytes32 _poolId = IBalancerPool(_poolAddress).getPoolId();
89         IBalancerVault _vault = IBalancerVault(BALANCER_VAULT);
90 
91         (address[] memory _tokens,,) = _vault.getPoolTokens(_poolId);
92         uint256 _before = IERC20(_asset).balanceOf(address(this));
93         
94         uint256[] memory _amounts = new uint256[](_tokens.length);
95         for (uint256 _i = 0; _i < _tokens.length; _i++) {
96             if (_tokens[_i] == _asset) {
97                 _vault.exitPool(
98                     _poolId,
99                     address(this), // sender
100                     payable(address(this)), // recipient
101                     IBalancerVault.ExitPoolRequest({
102                         assets: _tokens,
103                         minAmountsOut: _amounts,
104                         userData: abi.encode(
105                             IBalancerVault.ExitKind.EXACT_BPT_IN_FOR_ONE_TOKEN_OUT,
106                             _bptAmountIn, // bptAmountIn
107                             _i // enterTokenIndex
108                         ),
109                         toInternalBalance: false
110                     })
111                 );
112                 break;
113             }
114         }
115         return (IERC20(_asset).balanceOf(address(this)) - _before);
116     }
117 
118     function _isComposablePool(address[] memory _tokens, address _poolAddress) internal pure returns (bool) {
119         for(uint256 i = 0; i < _tokens.length; i++) {
120             if (_tokens[i] == _poolAddress) {
121                 return true;
122             }
123         }
124         return false;
125     }
126     
127     function _dropBptItem(address[] memory _tokens, uint256[] memory _amounts, address _poolAddress) internal pure returns (uint256[] memory) {
128         uint256[] memory _noBPTAmounts = new uint256[](_tokens.length - 1);
129         uint256 _j = 0;
130         for(uint256 _i = 0; _i < _tokens.length; _i++) {
131             if (_tokens[_i] != _poolAddress) {
132                 _noBPTAmounts[_j] = _amounts[_i];
133                 _j++;
134             }
135         }
136         return _noBPTAmounts;
137     }
138 
139     function _approveOperations(address _token, address _spender, uint256 _amount) internal virtual {
140         IERC20(_token).safeApprove(_spender, 0);
141         IERC20(_token).safeApprove(_spender, _amount);
142     }
143 
144     function _wrapETH(uint256 _amount) internal {
145         IWETH(WETH).deposit{ value: _amount }();
146     }
147 }
