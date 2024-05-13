1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IAngleStableMaster.sol";
5 import "./IAngleStakingRewards.sol";
6 import "../uniswap/UniswapPCVDeposit.sol";
7 
8 /// @title implementation for Angle PCV Deposit
9 /// @author Angle Core Team and Fei Protocol
10 contract AngleUniswapPCVDeposit is UniswapPCVDeposit {
11     using Decimal for Decimal.D256;
12 
13     /// @notice the Angle StableMaster contract
14     IAngleStableMaster public immutable stableMaster;
15 
16     /// @notice the Angle PoolManager contract
17     IAnglePoolManager public poolManager;
18 
19     /// @notice the Angle StakingRewards contract
20     IAngleStakingRewards public stakingRewards;
21 
22     /// @notice Uniswap PCV Deposit constructor
23     /// @param _core Fei Core for reference
24     /// @param _pair Uniswap Pair to deposit to
25     /// @param _router Uniswap Router
26     /// @param _oracle oracle for reference
27     /// @param _backupOracle the backup oracle to reference
28     /// @param _maxBasisPointsFromPegLP the max basis points of slippage from peg allowed on LP deposit
29     constructor(
30         address _core,
31         address _pair,
32         address _router,
33         address _oracle,
34         address _backupOracle,
35         uint256 _maxBasisPointsFromPegLP,
36         IAngleStableMaster _stableMaster,
37         IAnglePoolManager _poolManager,
38         IAngleStakingRewards _stakingRewards
39     ) UniswapPCVDeposit(_core, _pair, _router, _oracle, _backupOracle, _maxBasisPointsFromPegLP) {
40         stableMaster = _stableMaster;
41         poolManager = _poolManager;
42         stakingRewards = _stakingRewards;
43         require(_poolManager.token() == address(fei()), "AngleUniswapPCVDeposit: invalid poolManager");
44         require(_stableMaster.agToken() == token, "AngleUniswapPCVDeposit: invalid stableMaster");
45         require(_stakingRewards.stakingToken() == _pair, "AngleUniswapPCVDeposit: invalid stakingRewards");
46 
47         // Approve FEI on StableMaster to be able to mint agTokens
48         SafeERC20.safeApprove(IERC20(address(fei())), address(_stableMaster), type(uint256).max);
49         // Approve LP tokens on StakingRewards to earn ANGLE rewards
50         SafeERC20.safeApprove(IERC20(_pair), address(_stakingRewards), type(uint256).max);
51     }
52 
53     /// @notice claim staking rewards
54     function claimRewards() external {
55         stakingRewards.getReward();
56     }
57 
58     /// @notice mint agToken from FEI
59     /// @dev the call will revert if slippage is too high compared to oracle.
60     function mintAgToken(uint256 amountFei) public onlyPCVController {
61         // compute minimum amount out
62         uint256 minAgTokenOut = Decimal
63             .from(amountFei)
64             .div(readOracle())
65             .mul(Constants.BASIS_POINTS_GRANULARITY - maxBasisPointsFromPegLP)
66             .div(Constants.BASIS_POINTS_GRANULARITY)
67             .asUint256();
68 
69         // mint FEI to self
70         _mintFei(address(this), amountFei);
71 
72         // mint agToken from FEI
73         stableMaster.mint(amountFei, address(this), poolManager, minAgTokenOut);
74     }
75 
76     /// @notice burn agToken for FEI
77     /// @dev the call will revert if slippage is too high compared to oracle
78     function burnAgToken(uint256 amountAgToken) public onlyPCVController {
79         // compute minimum of FEI out for agTokens burnt
80         uint256 minFeiOut = readOracle() // FEI per X
81             .mul(amountAgToken)
82             .mul(Constants.BASIS_POINTS_GRANULARITY - maxBasisPointsFromPegLP)
83             .div(Constants.BASIS_POINTS_GRANULARITY)
84             .asUint256();
85 
86         // burn agTokens for FEI
87         stableMaster.burn(amountAgToken, address(this), address(this), poolManager, minFeiOut);
88 
89         // burn FEI held (after redeeming agTokens, we have some)
90         _burnFeiHeld();
91     }
92 
93     /// @notice burn ALL agToken held for FEI
94     /// @dev see burnAgToken(uint256 amount).
95     function burnAgTokenAll() external onlyPCVController {
96         burnAgToken(IERC20(token).balanceOf(address(this)));
97     }
98 
99     /// @notice set the new pair contract
100     /// @param _pair the new pair
101     /// @dev also approves the router for the new pair token and underlying token
102     function setPair(address _pair) public override onlyGovernor {
103         super.setPair(_pair);
104         SafeERC20.safeApprove(IERC20(_pair), address(stakingRewards), type(uint256).max);
105     }
106 
107     /// @notice set a new stakingRewards address
108     /// @param _stakingRewards the new stakingRewards
109     function setStakingRewards(IAngleStakingRewards _stakingRewards) public onlyGovernor {
110         require(address(_stakingRewards) != address(0), "AngleUniswapPCVDeposit: zero address");
111         stakingRewards = _stakingRewards;
112     }
113 
114     /// @notice set a new poolManager address
115     /// @param _poolManager the new poolManager
116     function setPoolManager(IAnglePoolManager _poolManager) public onlyGovernor {
117         require(address(_poolManager) != address(0), "AngleUniswapPCVDeposit: zero address");
118         poolManager = _poolManager;
119     }
120 
121     /// @notice amount of pair liquidity owned by this contract
122     /// @return amount of LP tokens
123     function liquidityOwned() public view override returns (uint256) {
124         return pair.balanceOf(address(this)) + stakingRewards.balanceOf(address(this));
125     }
126 
127     function _removeLiquidity(uint256 liquidity) internal override returns (uint256) {
128         stakingRewards.withdraw(liquidity);
129         return super._removeLiquidity(liquidity);
130     }
131 
132     function _addLiquidity(uint256 tokenAmount, uint256 feiAmount) internal override {
133         super._addLiquidity(tokenAmount, feiAmount);
134         uint256 lpBalanceAfter = pair.balanceOf(address(this));
135         stakingRewards.stake(lpBalanceAfter);
136     }
137 }
