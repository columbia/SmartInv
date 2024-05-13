1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import {IPCVDeposit} from "../pcv/IPCVDeposit.sol";
6 import {GlobalRateLimitedMinter} from "../utils/GlobalRateLimitedMinter.sol";
7 
8 /**
9  * @title Fei Peg Stability Module
10  * @author Fei Protocol
11  * @notice  The Fei PSM is a contract which pulls reserve assets from PCV Deposits in order to exchange FEI at $1 of underlying assets with a fee.
12  * `mint()` - buy FEI for $1 of underlying tokens
13  * `redeem()` - sell FEI back for $1 of the same
14  *
15  *
16  * The contract is a
17  * OracleRef - to determine price of underlying, and
18  * RateLimitedReplenishable - to stop infinite mints and related DOS issues
19  *
20  * Inspired by MakerDAO PSM, code written without reference
21  */
22 interface INonCustodialPSM {
23     // ----------- Public State Changing API -----------
24 
25     /// @notice mint `amountFeiOut` FEI to address `to` for `amountIn` underlying tokens
26     /// @dev see getMintAmountOut() to pre-calculate amount out
27     function mint(
28         address to,
29         uint256 amountIn,
30         uint256 minAmountOut
31     ) external returns (uint256 amountFeiOut);
32 
33     /// @notice redeem `amountFeiIn` FEI for `amountOut` underlying tokens and send to address `to`
34     /// @dev see getRedeemAmountOut() to pre-calculate amount out
35     function redeem(
36         address to,
37         uint256 amountFeiIn,
38         uint256 minAmountOut
39     ) external returns (uint256 amountOut);
40 
41     // ----------- Governor or Admin Only State Changing API -----------
42 
43     /// @notice set the mint fee vs oracle price in basis point terms
44     function setMintFee(uint256 newMintFeeBasisPoints) external;
45 
46     /// @notice set the redemption fee vs oracle price in basis point terms
47     function setRedeemFee(uint256 newRedeemFeeBasisPoints) external;
48 
49     /// @notice set the target for sending surplus reserves
50     function setPCVDeposit(IPCVDeposit newTarget) external;
51 
52     /// @notice set the target to call for FEI minting
53     function setGlobalRateLimitedMinter(GlobalRateLimitedMinter newMinter) external;
54 
55     /// @notice withdraw ERC20 from the contract
56     function withdrawERC20(
57         address token,
58         address to,
59         uint256 amount
60     ) external;
61 
62     // ----------- Getters -----------
63 
64     /// @notice calculate the amount of FEI out for a given `amountIn` of underlying
65     function getMintAmountOut(uint256 amountIn) external view returns (uint256 amountFeiOut);
66 
67     /// @notice calculate the amount of underlying out for a given `amountFeiIn` of FEI
68     function getRedeemAmountOut(uint256 amountFeiIn) external view returns (uint256 amountOut);
69 
70     /// @notice the maximum mint amount out
71     function getMaxMintAmountOut() external view returns (uint256);
72 
73     /// @notice the mint fee vs oracle price in basis point terms
74     function mintFeeBasisPoints() external view returns (uint256);
75 
76     /// @notice the redemption fee vs oracle price in basis point terms
77     function redeemFeeBasisPoints() external view returns (uint256);
78 
79     /// @notice the underlying token exchanged for FEI
80     function underlyingToken() external view returns (IERC20);
81 
82     /// @notice the PCV deposit target to deposit and withdraw from
83     function pcvDeposit() external view returns (IPCVDeposit);
84 
85     /// @notice Rate Limited Minter contract that will be called when FEI needs to be minted
86     function rateLimitedMinter() external view returns (GlobalRateLimitedMinter);
87 
88     /// @notice the max mint and redeem fee in basis points
89     function MAX_FEE() external view returns (uint256);
90 
91     // ----------- Events -----------
92 
93     /// @notice event emitted when a new max fee is set
94     event MaxFeeUpdate(uint256 oldMaxFee, uint256 newMaxFee);
95 
96     /// @notice event emitted when a new mint fee is set
97     event MintFeeUpdate(uint256 oldMintFee, uint256 newMintFee);
98 
99     /// @notice event emitted when a new redeem fee is set
100     event RedeemFeeUpdate(uint256 oldRedeemFee, uint256 newRedeemFee);
101 
102     /// @notice event emitted when reservesThreshold is updated
103     event ReservesThresholdUpdate(uint256 oldReservesThreshold, uint256 newReservesThreshold);
104 
105     /// @notice event emitted when surplus target is updated
106     event PCVDepositUpdate(IPCVDeposit oldTarget, IPCVDeposit newTarget);
107 
108     /// @notice event emitted upon a redemption
109     event Redeem(address to, uint256 amountFeiIn, uint256 amountAssetOut);
110 
111     /// @notice event emitted when fei gets minted
112     event Mint(address to, uint256 amountIn, uint256 amountFeiOut);
113 
114     /// @notice event emitted when ERC20 tokens get withdrawn
115     event WithdrawERC20(address indexed _caller, address indexed _token, address indexed _to, uint256 _amount);
116 
117     /// @notice event emitted when global rate limited minter is updated
118     event GlobalRateLimitedMinterUpdate(GlobalRateLimitedMinter oldMinter, GlobalRateLimitedMinter newMinter);
119 
120     /// @notice event that is emitted when redemptions are paused
121     event RedemptionsPaused(address account);
122 
123     /// @notice event that is emitted when redemptions are unpaused
124     event RedemptionsUnpaused(address account);
125 
126     /// @notice event that is emitted when minting is paused
127     event MintingPaused(address account);
128 
129     /// @notice event that is emitted when minting is unpaused
130     event MintingUnpaused(address account);
131 }
