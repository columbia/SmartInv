1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "./PermissionlessMetaSwap.sol";
6 import "./FlashLoanEnabled.sol";
7 import "../interfaces/IFlashLoanReceiver.sol";
8 
9 /**
10  * @title MetaSwap - A StableSwap implementation in solidity.
11  * @notice This contract is responsible for custody of closely pegged assets (eg. group of stablecoins)
12  * and automatic market making system. Users become an LP (Liquidity Provider) by depositing their tokens
13  * in desired ratios for an exchange of the pool token that represents their share of the pool.
14  * Users can burn pool tokens and withdraw their share of token(s).
15  *
16  * Each time a swap between the pooled tokens happens, a set fee incurs which effectively gets
17  * distributed to the LPs.
18  *
19  * In case of emergencies, admin can pause additional deposits, swaps, or single-asset withdraws - which
20  * stops the ratio of the tokens in the pool from changing.
21  * Users can always withdraw their tokens via multi-asset withdraws.
22  *
23  * MetaSwap is a modified version of Swap that allows Swap's LP token to be utilized in pooling with other tokens.
24  * As an example, if there is a Swap pool consisting of [DAI, USDC, USDT], then a MetaSwap pool can be created
25  * with [sUSD, BaseSwapLPToken] to allow trades between either the LP token or the underlying tokens and sUSD.
26  * Note that when interacting with MetaSwap, users cannot deposit or withdraw via underlying tokens. In that case,
27  * `MetaSwapDeposit.sol` can be additionally deployed to allow interacting with unwrapped representations of the tokens.
28  *
29  * @dev Most of the logic is stored as a library `MetaSwapUtils` for the sake of reducing contract's
30  * deployment size.
31  */
32 contract PermissionlessMetaSwapFlashLoan is
33     PermissionlessMetaSwap,
34     FlashLoanEnabled
35 {
36     /**
37      * @notice Constructor for the PermissionlessSwapFlashLoan contract.
38      * @param _masterRegistry address of the MasterRegistry contract
39      */
40     constructor(IMasterRegistry _masterRegistry)
41         public
42         PermissionlessMetaSwap(_masterRegistry)
43     {}
44 
45     /**
46      * @inheritdoc MetaSwap
47      * @dev Additionally sets flashloan fees.
48      */
49     function initializeMetaSwap(
50         IERC20[] memory _pooledTokens,
51         uint8[] memory decimals,
52         string memory lpTokenName,
53         string memory lpTokenSymbol,
54         uint256 _a,
55         uint256 _fee,
56         uint256 _adminFee,
57         address lpTokenTargetAddress,
58         ISwap baseSwap
59     ) public payable virtual override initializer {
60         MetaSwap.initializeMetaSwap(
61             _pooledTokens,
62             decimals,
63             lpTokenName,
64             lpTokenSymbol,
65             _a,
66             _fee,
67             _adminFee,
68             lpTokenTargetAddress,
69             baseSwap
70         );
71         // Set flashLoanFeeBPS to 8 and protocolFeeShareBPS to 0
72         _setFlashLoanFees(8, 0);
73         _updateFeeCollectorCache(MASTER_REGISTRY);
74     }
75 
76     /*** STATE MODIFYING FUNCTIONS ***/
77 
78     /// @inheritdoc FlashLoanEnabled
79     function flashLoan(
80         address receiver,
81         IERC20 token,
82         uint256 amount,
83         bytes memory params
84     ) external payable virtual override nonReentrant {
85         uint8 tokenIndex = getTokenIndex(address(token));
86         uint256 availableLiquidityBefore = token.balanceOf(address(this));
87         uint256 protocolBalanceBefore = availableLiquidityBefore.sub(
88             swapStorage.balances[tokenIndex]
89         );
90         require(
91             amount > 0 && availableLiquidityBefore >= amount,
92             "invalid amount"
93         );
94 
95         // Calculate the additional amount of tokens the pool should end up with
96         uint256 amountFee = amount.mul(flashLoanFeeBPS).div(10000);
97         // Calculate the portion of the fee that will go to the protocol
98         uint256 protocolFee = amountFee.mul(protocolFeeShareBPS).div(10000);
99         require(amountFee > 0, "amount is small for a flashLoan");
100 
101         // Transfer the requested amount of tokens
102         token.safeTransfer(receiver, amount);
103 
104         // Execute callback function on receiver
105         IFlashLoanReceiver(receiver).executeOperation(
106             address(this),
107             address(token),
108             amount,
109             amountFee,
110             params
111         );
112 
113         uint256 availableLiquidityAfter = token.balanceOf(address(this));
114         require(
115             availableLiquidityAfter >= availableLiquidityBefore.add(amountFee),
116             "flashLoan fee is not met"
117         );
118 
119         swapStorage.balances[tokenIndex] = availableLiquidityAfter
120             .sub(protocolBalanceBefore)
121             .sub(protocolFee);
122         emit FlashLoan(receiver, tokenIndex, amount, amountFee, protocolFee);
123     }
124 
125     /*** ADMIN FUNCTIONS ***/
126 
127     /**
128      * @notice Updates the flash loan fee parameters. Only owner can call this function.
129      * @dev This function should be overridden for permissions.
130      * @param newFlashLoanFeeBPS the total fee in bps to be applied on future flash loans
131      * @param newProtocolFeeShareBPS the protocol fee in bps to be applied on the total flash loan fee
132      */
133     function setFlashLoanFees(
134         uint256 newFlashLoanFeeBPS,
135         uint256 newProtocolFeeShareBPS
136     ) external payable virtual onlyOwner {
137         _setFlashLoanFees(newFlashLoanFeeBPS, newProtocolFeeShareBPS);
138     }
139 }
