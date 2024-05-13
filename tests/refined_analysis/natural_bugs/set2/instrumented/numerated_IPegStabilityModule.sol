1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import "../pcv/IPCVDeposit.sol";
6 
7 /**
8  * @title Fei Peg Stability Module
9  * @author Fei Protocol
10  * @notice  The Fei PSM is a contract which holds a reserve of assets in order to exchange FEI at $1 of underlying assets with a fee.
11  * `mint()` - buy FEI for $1 of underlying tokens
12  * `redeem()` - sell FEI back for $1 of the same
13  *
14  * The contract has a reservesThreshold() of underlying meant to stand ready for redemptions. Any surplus reserves can be sent into the PCV using `allocateSurplus()`
15  *
16  * The contract is a
17  * PCVDeposit - to track reserves
18  * OracleRef - to determine price of underlying, and
19  * RateLimitedMinter - to stop infinite mints and related issues (but this is in the implementation due to inheritance-linearization difficulties)
20  *
21  * Inspired by MakerDAO PSM, code written without reference
22  */
23 interface IPegStabilityModule {
24     // ----------- Public State Changing API -----------
25 
26     /// @notice mint `amountFeiOut` FEI to address `to` for `amountIn` underlying tokens
27     /// @dev see getMintAmountOut() to pre-calculate amount out
28     function mint(
29         address to,
30         uint256 amountIn,
31         uint256 minAmountOut
32     ) external returns (uint256 amountFeiOut);
33 
34     /// @notice redeem `amountFeiIn` FEI for `amountOut` underlying tokens and send to address `to`
35     /// @dev see getRedeemAmountOut() to pre-calculate amount out
36     function redeem(
37         address to,
38         uint256 amountFeiIn,
39         uint256 minAmountOut
40     ) external returns (uint256 amountOut);
41 
42     /// @notice send any surplus reserves to the PCV allocation
43     function allocateSurplus() external;
44 
45     // ----------- Governor or Admin Only State Changing API -----------
46 
47     /// @notice set the mint fee vs oracle price in basis point terms
48     function setMintFee(uint256 newMintFeeBasisPoints) external;
49 
50     /// @notice set the redemption fee vs oracle price in basis point terms
51     function setRedeemFee(uint256 newRedeemFeeBasisPoints) external;
52 
53     /// @notice set the ideal amount of reserves for the contract to hold for redemptions
54     function setReservesThreshold(uint256 newReservesThreshold) external;
55 
56     /// @notice set the target for sending surplus reserves
57     function setSurplusTarget(IPCVDeposit newTarget) external;
58 
59     // ----------- Getters -----------
60 
61     /// @notice calculate the amount of FEI out for a given `amountIn` of underlying
62     function getMintAmountOut(uint256 amountIn) external view returns (uint256 amountFeiOut);
63 
64     /// @notice calculate the amount of underlying out for a given `amountFeiIn` of FEI
65     function getRedeemAmountOut(uint256 amountFeiIn) external view returns (uint256 amountOut);
66 
67     /// @notice the maximum mint amount out
68     function getMaxMintAmountOut() external view returns (uint256);
69 
70     /// @notice a flag for whether the current balance is above (true) or below and equal (false) to the reservesThreshold
71     function hasSurplus() external view returns (bool);
72 
73     /// @notice an integer representing the positive surplus or negative deficit of contract balance vs reservesThreshold
74     function reservesSurplus() external view returns (int256);
75 
76     /// @notice the ideal amount of reserves for the contract to hold for redemptions
77     function reservesThreshold() external view returns (uint256);
78 
79     /// @notice the mint fee vs oracle price in basis point terms
80     function mintFeeBasisPoints() external view returns (uint256);
81 
82     /// @notice the redemption fee vs oracle price in basis point terms
83     function redeemFeeBasisPoints() external view returns (uint256);
84 
85     /// @notice the underlying token exchanged for FEI
86     function underlyingToken() external view returns (IERC20);
87 
88     /// @notice the PCV deposit target to send surplus reserves
89     function surplusTarget() external view returns (IPCVDeposit);
90 
91     /// @notice the max mint and redeem fee in basis points
92     function MAX_FEE() external view returns (uint256);
93 
94     // ----------- Events -----------
95 
96     /// @notice event emitted when excess PCV is allocated
97     event AllocateSurplus(address indexed caller, uint256 amount);
98 
99     /// @notice event emitted when a new max fee is set
100     event MaxFeeUpdate(uint256 oldMaxFee, uint256 newMaxFee);
101 
102     /// @notice event emitted when a new mint fee is set
103     event MintFeeUpdate(uint256 oldMintFee, uint256 newMintFee);
104 
105     /// @notice event emitted when a new redeem fee is set
106     event RedeemFeeUpdate(uint256 oldRedeemFee, uint256 newRedeemFee);
107 
108     /// @notice event emitted when reservesThreshold is updated
109     event ReservesThresholdUpdate(uint256 oldReservesThreshold, uint256 newReservesThreshold);
110 
111     /// @notice event emitted when surplus target is updated
112     event SurplusTargetUpdate(IPCVDeposit oldTarget, IPCVDeposit newTarget);
113 
114     /// @notice event emitted upon a redemption
115     event Redeem(address to, uint256 amountFeiIn, uint256 amountAssetOut);
116 
117     /// @notice event emitted when fei gets minted
118     event Mint(address to, uint256 amountIn, uint256 amountFeiOut);
119 }
