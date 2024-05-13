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
17 //  _____             _   _____         _ _   
18 // |  _  |___ ___ ___| |_|  |  |___ _ _| | |_ 
19 // |     |_ -|_ -| -_|  _|  |  | .'| | | |  _|
20 // |__|__|___|___|___|_|  \___/|__,|___|_|_|  
21 
22 // Github - https://github.com/FortressFinance
23 
24 import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
25 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
26 import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
27 
28 import {IStrategy} from "./interfaces/IStrategy.sol";
29 import {IFortressSwap} from "./interfaces/IFortressSwap.sol";
30 import {IMetaVault} from "./interfaces/IMetaVault.sol";
31 import {IAssetVault} from "./interfaces/IAssetVault.sol";
32 
33 contract AssetVault is ReentrancyGuard, IAssetVault {
34 
35     using SafeERC20 for ERC20;
36 
37     /// @notice The asset managed by this vault
38     address internal primaryAsset;
39     /// @notice The metaVault that manages this vault
40     address public metaVault;
41     /// @notice The Primary Asset of the metaVault
42     address public metaVaultPrimaryAsset;
43     /// @notice The platform address
44     address public platform;
45     /// @notice The vault manager address
46     address public manager;
47     /// @notice The address of the newly initiated strategy
48     address public initiatedStrategy;
49     /// @notice The timelock duration, in seconds
50     uint256 public timelockDuration;
51     /// @notice The timelock timestamp
52     uint256 public timelock;
53     /// @notice Indicates whether the timelock was initiated
54     bool public isTimelocked;
55     /// @notice Enables Platform to override isStrategiesActive value
56     bool public isStrategiesActiveOverride;
57 
58     /// @notice The address list of strategies
59     address[] public strategyList;
60 
61     /// @notice The mapping of strategies
62     mapping(address => bool) public strategies;
63     /// @notice The mapping of blacklisted strategies
64     mapping(address => bool) public blacklistedStrategies;
65 
66     /********************************** Constructor **********************************/
67     
68     constructor(address _primaryAsset, address _metaVault, address _metaVaultPrimaryAsset, address _platform, address _manager) {
69         primaryAsset = _primaryAsset;
70         metaVault = _metaVault;
71         platform = _platform;
72         manager = _manager;
73         metaVaultPrimaryAsset = _metaVaultPrimaryAsset;
74         
75         timelockDuration = 1 days;
76         isStrategiesActiveOverride = false;
77     }
78 
79     /********************************** Modifiers **********************************/
80 
81     modifier onlyPlatform() {
82         if (msg.sender != platform) revert Unauthorized();
83         _;
84     }
85 
86     /// @notice Platform has admin access
87     modifier onlyMetaVault {
88         if (msg.sender != metaVault && msg.sender != platform) revert Unauthorized();
89         _;
90     }
91 
92     /// @notice Platform has admin access
93     modifier onlyManager() {
94         if (msg.sender != manager && msg.sender != platform) revert Unauthorized();
95         _;
96     }
97 
98     modifier unmanaged() {
99         if (!IMetaVault(metaVault).isUnmanaged()) revert InvalidState();
100         _;
101     }
102 
103     /********************************** View Functions **********************************/
104 
105     /// @inheritdoc IAssetVault
106     function isActive() external view returns (bool) {
107         return ERC20(primaryAsset).balanceOf(address(this)) > 0 || areStrategiesActive();
108     }
109 
110     /// @inheritdoc IAssetVault
111     function isStrategyActive(address _strategy) public view returns (bool) {
112         return strategies[_strategy] && IStrategy(_strategy).isActive() && !blacklistedStrategies[_strategy];
113     }
114 
115     /// @inheritdoc IAssetVault
116     function areStrategiesActive() public view returns (bool) {
117         if (isStrategiesActiveOverride) return false;
118 
119         address[] memory _strategyList = strategyList;
120         for (uint256 i = 0; i < _strategyList.length; i++) {
121             if (isStrategyActive(_strategyList[i])) {
122                 return true;
123             }
124         }
125         return false;
126     }
127 
128     /// @inheritdoc IAssetVault
129     function getAsset() external view returns (address) {
130         return primaryAsset;
131     }
132 
133     /********************************** Meta Vault Functions **********************************/
134 
135     /// @inheritdoc IAssetVault
136     function deposit(uint256 _amount) external onlyMetaVault nonReentrant returns (uint256 _amountIn) {
137         address _primaryAsset = primaryAsset;
138         address _metaVault = metaVault;
139         address _metaVaultPrimaryAsset = metaVaultPrimaryAsset;
140         uint256 _before = ERC20(_primaryAsset).balanceOf(address(this));
141         ERC20(_metaVaultPrimaryAsset).safeTransferFrom(_metaVault, address(this), _amount);
142         if (_primaryAsset != _metaVaultPrimaryAsset) {
143             address _swap = IMetaVault(_metaVault).getSwap();
144             _approve(_metaVaultPrimaryAsset, _swap, _amount);
145             _amount = IFortressSwap(_swap).swap(_metaVaultPrimaryAsset, _primaryAsset, _amount);
146         }
147         
148         _amountIn = ERC20(_primaryAsset).balanceOf(address(this)) - _before;
149 
150         emit Deposited(block.timestamp, _amount);
151 
152         return _amountIn;
153     }
154 
155     /// @inheritdoc IAssetVault
156     function withdraw(uint256 _amount) public onlyMetaVault nonReentrant returns (uint256 _amountOut) {
157         address _primaryAsset = primaryAsset;
158         address _metaVaultPrimaryAsset = metaVaultPrimaryAsset;
159         address _metaVault = metaVault;
160         uint256 _before = ERC20(_metaVaultPrimaryAsset).balanceOf(_metaVault);
161         if (_primaryAsset != _metaVaultPrimaryAsset) {
162             address _swap = IMetaVault(metaVault).getSwap();
163             _approve(_primaryAsset, _swap, _amount);
164             _amount = IFortressSwap(IMetaVault(metaVault).getSwap()).swap(_primaryAsset, _metaVaultPrimaryAsset, _amount);
165         }
166 
167         ERC20(_metaVaultPrimaryAsset).safeTransfer(_metaVault, _amount);
168         _amountOut = ERC20(_metaVaultPrimaryAsset).balanceOf(_metaVault) - _before;
169 
170         emit Withdrawn(block.timestamp, _amount);
171         
172         return _amountOut;
173     }
174 
175     /********************************** Manager Functions **********************************/
176 
177     /// @inheritdoc IAssetVault
178     function depositToStrategy(address _strategy, uint256 _amount) external onlyManager nonReentrant {
179         if (!strategies[_strategy]) revert StrategyNonExistent();
180         if (blacklistedStrategies[_strategy]) revert StrategyBlacklisted();
181 
182         address _primaryAsset = primaryAsset;
183         _approve(_primaryAsset, _strategy, _amount);
184         IStrategy(_strategy).deposit(_amount);
185 
186         emit DepositedToStrategy(block.timestamp, _strategy, _amount);
187     }
188 
189     /// @inheritdoc IAssetVault
190     function withdrawFromStrategy(address _strategy, uint256 _amount) external onlyManager nonReentrant {
191         if (!strategies[_strategy]) revert StrategyNonExistent();
192 
193         IStrategy(_strategy).withdraw(_amount);
194 
195         emit WithdrawnFromStrategy(block.timestamp, _strategy, _amount);
196     }
197 
198     /// @inheritdoc IAssetVault
199     function withdrawAllFromAllStrategies() external onlyManager {
200         address[] memory _strategyList = strategyList;
201         for (uint256 i = 0; i < _strategyList.length; i++) {
202             if (!blacklistedStrategies[_strategyList[i]]) {
203                 IStrategy(_strategyList[i]).withdrawAll();
204             }
205         }
206         
207         emit WithdrawnFromAllStrategies(block.timestamp);
208     }
209 
210     /// @inheritdoc IAssetVault
211     function initiateStrategy(address _strategy) public onlyManager unmanaged nonReentrant {
212         timelock = block.timestamp;
213         isTimelocked = true;
214         initiatedStrategy = _strategy;
215 
216         emit StrategyInitiated(block.timestamp, _strategy);
217     }
218 
219     /// @inheritdoc IAssetVault
220     function addStrategy() external onlyManager unmanaged nonReentrant {
221         if (isTimelocked == false) revert NotTimelocked();
222         if (timelock + timelockDuration > block.timestamp) revert TimelockNotExpired();
223         
224         address _strategy = initiatedStrategy;
225         if (blacklistedStrategies[_strategy]) revert StrategyBlacklisted();
226         if (strategies[_strategy]) revert StrategyAlreadyActive();
227 
228         strategies[_strategy] = true;
229         strategyList.push(_strategy);
230         initiatedStrategy = address(0);
231 
232         isTimelocked = false;
233 
234         emit StrategyAdded(block.timestamp, _strategy);
235     }
236 
237     /// @inheritdoc IAssetVault
238     function updateManager(address _manager) external onlyManager unmanaged {
239         manager = _manager;
240 
241         emit ManagerUpdated(block.timestamp, _manager);
242     }
243 
244     /********************************** Platform Functions **********************************/
245 
246     /// @inheritdoc IAssetVault
247     function updateTimelockDuration(uint256 _timelockDuration) external onlyPlatform unmanaged {
248         timelockDuration = _timelockDuration;
249 
250         emit TimelockDurationUpdated(block.timestamp, _timelockDuration);
251     }
252 
253     /// @inheritdoc IAssetVault
254     function platformAddStrategy(address _strategy) external onlyPlatform unmanaged {
255         strategies[_strategy] = true;
256         strategyList.push(_strategy);
257 
258         emit StrategyAdded(block.timestamp, _strategy);
259     }
260 
261     /// @inheritdoc IAssetVault
262     function overrideActiveStatus(bool _isStrategiesActive) external onlyPlatform {
263         isStrategiesActiveOverride = _isStrategiesActive;
264 
265         emit ActiveStatusOverriden(block.timestamp, _isStrategiesActive);
266     }
267 
268     /// @inheritdoc IAssetVault
269     function setBlacklistStatus(address _strategy, bool _isBlacklisted) external onlyPlatform {
270         if (strategies[_strategy] == false) revert StrategyNonExistent();
271 
272         blacklistedStrategies[_strategy] = _isBlacklisted;
273 
274         emit BlacklistStatusOverriden(block.timestamp, _strategy, _isBlacklisted);
275     }
276 
277     /********************************** Internal Functions **********************************/
278 
279     function _approve(address _asset, address _spender, uint256 _amount) internal {
280         ERC20(_asset).safeApprove(_spender, 0);
281         ERC20(_asset).safeApprove(_spender, _amount);
282     }
283 }