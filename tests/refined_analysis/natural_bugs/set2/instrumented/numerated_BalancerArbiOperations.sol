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
34 contract BalancerArbiOperations {
35 
36     using SafeERC20 for IERC20;
37     using Address for address payable;
38     
39     /// @notice The address of the owner
40     address public owner;
41 
42     /// @notice The mapping of whitelisted addresses, which are Fortress Vaults
43     mapping(address => bool) public whitelist;
44 
45     /// @notice The address of Balancer vault.
46     address internal constant BALANCER_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
47     /// @notice The address representing ETH.
48     address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
49     /// @notice The address of WETH.
50     address internal constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
51         
52     /********************************** Constructor **********************************/
53 
54     constructor(address _owner) {
55         owner = _owner;
56     }
57 
58     /********************************** Restricted Functions **********************************/
59 
60     function updateWhitelist(address _vault, bool _whitelisted) external {
61         if (msg.sender != owner) revert OnlyOwner();
62 
63         whitelist[_vault] = _whitelisted;
64     }
65 
66     function updateOwner(address _owner) external {
67         if (msg.sender != owner) revert OnlyOwner();
68 
69         owner = _owner;
70     }
71 
72     /********************************** Restricted Functions **********************************/
73 
74     function addLiquidity(address _poolAddress, address _asset, uint256 _amount) external returns (uint256 _assets) {
75         if (!whitelist[msg.sender]) revert Unauthorized_();
76         
77         bytes32 _poolId = IBalancerPool(_poolAddress).getPoolId();
78         IBalancerVault _vault = IBalancerVault(BALANCER_VAULT);
79 
80         (address[] memory _tokens,,) = _vault.getPoolTokens(_poolId);
81 
82         uint256 _before = IERC20(_poolAddress).balanceOf(address(this));
83         
84         if (_asset == ETH) {
85             _wrapETH(_amount);
86             _asset = WETH;
87         }
88         IERC20(_asset).safeTransferFrom(msg.sender, address(this), _amount);
89 
90         uint256[] memory _amounts = new uint256[](_tokens.length);
91         for (uint256 _i = 0; _i < _tokens.length; _i++) {
92             if (_tokens[_i] == _asset) {
93                 _amounts[_i] = _amount;
94 
95                 uint256[] memory _noBptAmounts = _isComposablePool(_tokens, _poolAddress) ? _dropBptItem(_tokens, _amounts, _poolAddress) : _amounts;
96                 
97                 _approveOperations(_tokens[_i], address(_vault), _amount);
98                 // _approveOperations(_tokens[_i], BALANCER_VAULT, _amount);
99                 _vault.joinPool(
100                     _poolId,
101                     address(this), // sender
102                     address(this), // recipient
103                     IBalancerVault.JoinPoolRequest({
104                         assets: _tokens,
105                         maxAmountsIn: _amounts,
106                         userData: abi.encode(
107                             IBalancerVault.JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT,
108                             _noBptAmounts, // amountsIn
109                             0 // minimumBPT
110                         ),
111                         fromInternalBalance: false
112                     })
113                 );
114                 break;
115             }
116         }
117         _assets = IERC20(_poolAddress).balanceOf(address(this)) - _before;
118         IERC20(_poolAddress).safeTransfer(msg.sender, _assets);
119         
120         return _assets;
121     }
122 
123     function removeLiquidity(address _poolAddress, address _asset, uint256 _bptAmountIn) external returns (uint256 _underlyingAmount) {
124         if (!whitelist[msg.sender]) revert Unauthorized_();
125         
126         bytes32 _poolId = IBalancerPool(_poolAddress).getPoolId();
127         IBalancerVault _vault = IBalancerVault(BALANCER_VAULT);
128 
129         (address[] memory _tokens,,) = _vault.getPoolTokens(_poolId);
130         uint256 _before = IERC20(_asset).balanceOf(address(this));
131         
132         IERC20(_poolAddress).safeTransferFrom(msg.sender, address(this), _bptAmountIn);
133 
134         uint256[] memory _amounts = new uint256[](_tokens.length);
135         for (uint256 _i = 0; _i < _tokens.length; _i++) {
136             if (_tokens[_i] == _asset) {
137                 _vault.exitPool(
138                     _poolId,
139                     address(this), // sender
140                     payable(address(this)), // recipient
141                     IBalancerVault.ExitPoolRequest({
142                         assets: _tokens,
143                         minAmountsOut: _amounts,
144                         userData: abi.encode(
145                             IBalancerVault.ExitKind.EXACT_BPT_IN_FOR_ONE_TOKEN_OUT,
146                             _bptAmountIn, // bptAmountIn
147                             _i // enterTokenIndex
148                         ),
149                         toInternalBalance: false
150                     })
151                 );
152                 break;
153             }
154         }
155         _underlyingAmount = IERC20(_asset).balanceOf(address(this)) - _before;
156         IERC20(_asset).safeTransfer(msg.sender, _underlyingAmount);
157 
158         return _underlyingAmount;
159     }
160 
161     /********************************** Internal Functions **********************************/
162 
163     function _isComposablePool(address[] memory _tokens, address _poolAddress) internal pure returns (bool) {
164         for(uint256 i = 0; i < _tokens.length; i++) {
165             if (_tokens[i] == _poolAddress) {
166                 return true;
167             }
168         }
169         return false;
170     }
171     
172     function _dropBptItem(address[] memory _tokens, uint256[] memory _amounts, address _poolAddress) internal pure returns (uint256[] memory) {
173         uint256[] memory _noBPTAmounts = new uint256[](_tokens.length - 1);
174         uint256 _j = 0;
175         for(uint256 _i = 0; _i < _tokens.length; _i++) {
176             if (_tokens[_i] != _poolAddress) {
177                 _noBPTAmounts[_j] = _amounts[_i];
178                 _j++;
179             }
180         }
181         return _noBPTAmounts;
182     }
183 
184     function _approveOperations(address _token, address _spender, uint256 _amount) internal virtual {
185         IERC20(_token).safeApprove(_spender, 0);
186         IERC20(_token).safeApprove(_spender, _amount);
187     }
188 
189     function _wrapETH(uint256 _amount) internal {
190         IWETH(WETH).deposit{ value: _amount }();
191     }
192 
193     // receive() external payable {}
194 
195 /********************************** Errors **********************************/
196 
197     error OnlyOwner();
198     error Unauthorized_();
199 
200 }
