1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./IVault.sol";
5 import "./IMerkleOrchard.sol";
6 import "./IWeightedPool.sol";
7 import "../PCVDeposit.sol";
8 import "../../Constants.sol";
9 import "../../refs/CoreRef.sol";
10 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
11 
12 /// @title base class for a Balancer PCV Deposit
13 /// @author Fei Protocol
14 abstract contract BalancerPCVDepositBase is PCVDeposit {
15     // ----------- Events ---------------
16     event UpdateMaximumSlippage(uint256 maximumSlippageBasisPoints);
17 
18     /// @notice event generated when rewards are claimed
19     event ClaimRewards(address indexed _caller, address indexed _token, address indexed _to, uint256 _amount);
20 
21     // @notice event generated when pool position is exited (LP tokens redeemed
22     // for tokens in proportion to the pool's weights.
23     event ExitPool(bytes32 indexed _poodId, address indexed _to, uint256 _bptAmount);
24 
25     // Maximum tolerated slippage for deposits
26     uint256 public maximumSlippageBasisPoints;
27 
28     /// @notice the balancer pool to deposit in
29     bytes32 public immutable poolId;
30     address public immutable poolAddress;
31 
32     /// @notice cache of the assets in the Balancer pool
33     IAsset[] internal poolAssets;
34 
35     /// @notice the balancer vault
36     IVault public immutable vault;
37 
38     /// @notice the balancer rewards contract to claim incentives
39     IMerkleOrchard public immutable rewards;
40 
41     /// @notice Balancer PCV Deposit constructor
42     /// @param _core Fei Core for reference
43     /// @param _vault Balancer vault
44     /// @param _rewards Balancer rewards (the MerkleOrchard)
45     /// @param _poolId Balancer poolId to deposit in
46     /// @param _maximumSlippageBasisPoints Maximum slippage basis points when depositing
47     constructor(
48         address _core,
49         address _vault,
50         address _rewards,
51         bytes32 _poolId,
52         uint256 _maximumSlippageBasisPoints
53     ) CoreRef(_core) {
54         vault = IVault(_vault);
55         rewards = IMerkleOrchard(_rewards);
56         maximumSlippageBasisPoints = _maximumSlippageBasisPoints;
57         poolId = _poolId;
58 
59         (poolAddress, ) = IVault(_vault).getPool(_poolId);
60 
61         // get the balancer pool tokens
62         IERC20[] memory tokens;
63         (tokens, , ) = IVault(_vault).getPoolTokens(_poolId);
64 
65         // cache the balancer pool tokens as Assets
66         poolAssets = new IAsset[](tokens.length);
67         for (uint256 i = 0; i < tokens.length; i++) {
68             poolAssets[i] = IAsset(address(tokens[i]));
69         }
70     }
71 
72     // Accept ETH transfers
73     receive() external payable {}
74 
75     /// @notice Wraps all ETH held by the contract to WETH
76     /// Anyone can call it.
77     /// Balancer uses WETH in its pools, and not ETH.
78     function wrapETH() external {
79         uint256 ethBalance = address(this).balance;
80         if (ethBalance != 0) {
81             Constants.WETH.deposit{value: ethBalance}();
82         }
83     }
84 
85     /// @notice unwrap WETH on the contract, for instance before
86     /// sending to another PCVDeposit that needs pure ETH.
87     /// Balancer uses WETH in its pools, and not ETH.
88     function unwrapETH() external onlyPCVController {
89         uint256 wethBalance = IERC20(address(Constants.WETH)).balanceOf(address(this));
90         if (wethBalance != 0) {
91             Constants.WETH.withdraw(wethBalance);
92         }
93     }
94 
95     /// @notice Sets the maximum slippage vs 1:1 price accepted during withdraw.
96     /// @param _maximumSlippageBasisPoints the maximum slippage expressed in basis points (1/10_000)
97     function setMaximumSlippage(uint256 _maximumSlippageBasisPoints) external onlyGovernorOrAdmin {
98         require(
99             _maximumSlippageBasisPoints <= Constants.BASIS_POINTS_GRANULARITY,
100             "BalancerPCVDepositBase: Exceeds bp granularity."
101         );
102         maximumSlippageBasisPoints = _maximumSlippageBasisPoints;
103         emit UpdateMaximumSlippage(_maximumSlippageBasisPoints);
104     }
105 
106     /// @notice redeeem all assets from LP pool
107     /// @param _to address to send underlying tokens to
108     function exitPool(address _to) external whenNotPaused onlyPCVController {
109         uint256 bptBalance = IWeightedPool(poolAddress).balanceOf(address(this));
110         if (bptBalance != 0) {
111             IVault.ExitPoolRequest memory request;
112 
113             // Uses encoding for exact BPT IN withdrawal using all held BPT
114             bytes memory userData = abi.encode(IWeightedPool.ExitKind.EXACT_BPT_IN_FOR_TOKENS_OUT, bptBalance);
115             request.assets = poolAssets;
116             request.minAmountsOut = new uint256[](poolAssets.length); // 0 minimums
117             request.userData = userData;
118             request.toInternalBalance = false; // use external balances to be able to transfer out tokenReceived
119 
120             vault.exitPool(poolId, address(this), payable(address(_to)), request);
121 
122             if (_to == address(this)) {
123                 _burnFeiHeld();
124             }
125 
126             emit ExitPool(poolId, _to, bptBalance);
127         }
128     }
129 
130     /// @notice claim BAL rewards associated to this PCV Deposit.
131     /// Note that if dual incentives are active, this will only claim BAL rewards.
132     /// For more context, see the following links :
133     /// - https://docs.balancer.fi/products/merkle-orchard
134     /// - https://docs.balancer.fi/products/merkle-orchard/claiming-tokens
135     /// A permissionless manual claim can always be done directly on the
136     /// MerkleOrchard contract, on behalf of this PCVDeposit. This function is
137     /// provided solely for claiming more conveniently the BAL rewards.
138     function claimRewards(
139         uint256 distributionId,
140         uint256 amount,
141         bytes32[] memory merkleProof
142     ) external whenNotPaused {
143         address BAL_TOKEN_ADDRESS = address(0xba100000625a3754423978a60c9317c58a424e3D);
144         address BAL_TOKEN_DISTRIBUTOR = address(0x35ED000468f397AA943009bD60cc6d2d9a7d32fF);
145 
146         IERC20[] memory tokens = new IERC20[](1);
147         tokens[0] = IERC20(BAL_TOKEN_ADDRESS);
148 
149         IMerkleOrchard.Claim memory claim = IMerkleOrchard.Claim({
150             distributionId: distributionId,
151             balance: amount,
152             distributor: BAL_TOKEN_DISTRIBUTOR,
153             tokenIndex: 0,
154             merkleProof: merkleProof
155         });
156         IMerkleOrchard.Claim[] memory claims = new IMerkleOrchard.Claim[](1);
157         claims[0] = claim;
158 
159         IMerkleOrchard(rewards).claimDistributions(address(this), claims, tokens);
160 
161         emit ClaimRewards(msg.sender, address(BAL_TOKEN_ADDRESS), address(this), amount);
162     }
163 }
