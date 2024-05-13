1 // SPDX-License-Identifier: MIT WITH AGPL-3.0-only
2 
3 pragma solidity 0.6.12;
4 
5 import "./PermissionlessSwap.sol";
6 import "./FlashLoanEnabled.sol";
7 import "../interfaces/IFlashLoanReceiver.sol";
8 
9 /**
10  * @title Swap - A StableSwap implementation in solidity.
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
23  * @dev Most of the logic is stored as a library `SwapUtils` for the sake of reducing contract's
24  * deployment size.
25  */
26 contract PermissionlessSwapFlashLoan is PermissionlessSwap, FlashLoanEnabled {
27     /**
28      * @notice Constructor for the PermissionlessSwapFlashLoan contract.
29      * @param _masterRegistry address of the MasterRegistry contract
30      */
31     constructor(IMasterRegistry _masterRegistry)
32         public
33         PermissionlessSwap(_masterRegistry)
34     {}
35 
36     /**
37      * @notice Initializes this Swap contract with the given parameters.
38      * This will also clone a LPToken contract that represents users'
39      * LP positions. The owner of LPToken will be this contract - which means
40      * only this contract is allowed to mint/burn tokens.
41      *
42      * @param _pooledTokens an array of ERC20s this pool will accept
43      * @param decimals the decimals to use for each pooled token,
44      * eg 8 for WBTC. Cannot be larger than POOL_PRECISION_DECIMALS
45      * @param lpTokenName the long-form name of the token to be deployed
46      * @param lpTokenSymbol the short symbol for the token to be deployed
47      * @param _a the amplification coefficient * n * (n - 1). See the
48      * StableSwap paper for details
49      * @param _fee default swap fee to be initialized with
50      * @param _adminFee default adminFee to be initialized with
51      * @param lpTokenTargetAddress the address of an existing LPToken contract to use as a target
52      */
53     function initialize(
54         IERC20[] memory _pooledTokens,
55         uint8[] memory decimals,
56         string memory lpTokenName,
57         string memory lpTokenSymbol,
58         uint256 _a,
59         uint256 _fee,
60         uint256 _adminFee,
61         address lpTokenTargetAddress
62     ) public payable virtual override initializer {
63         Swap.initialize(
64             _pooledTokens,
65             decimals,
66             lpTokenName,
67             lpTokenSymbol,
68             _a,
69             _fee,
70             _adminFee,
71             lpTokenTargetAddress
72         );
73         // Set flashLoanFeeBPS to 8 and protocolFeeShareBPS to 0
74         _setFlashLoanFees(8, 0);
75         _updateFeeCollectorCache(MASTER_REGISTRY);
76     }
77 
78     /*** STATE MODIFYING FUNCTIONS ***/
79 
80     /// @inheritdoc FlashLoanEnabled
81     function flashLoan(
82         address receiver,
83         IERC20 token,
84         uint256 amount,
85         bytes memory params
86     ) external payable override nonReentrant {
87         uint8 tokenIndex = getTokenIndex(address(token));
88         uint256 availableLiquidityBefore = token.balanceOf(address(this));
89         uint256 protocolBalanceBefore = availableLiquidityBefore.sub(
90             swapStorage.balances[tokenIndex]
91         );
92         require(
93             amount > 0 && availableLiquidityBefore >= amount,
94             "invalid amount"
95         );
96 
97         // Calculate the additional amount of tokens the pool should end up with
98         uint256 amountFee = amount.mul(flashLoanFeeBPS).div(10000);
99         // Calculate the portion of the fee that will go to the protocol
100         uint256 protocolFee = amountFee.mul(protocolFeeShareBPS).div(10000);
101         require(amountFee > 0, "amount is small for a flashLoan");
102 
103         // Transfer the requested amount of tokens
104         token.safeTransfer(receiver, amount);
105 
106         // Execute callback function on receiver
107         IFlashLoanReceiver(receiver).executeOperation(
108             address(this),
109             address(token),
110             amount,
111             amountFee,
112             params
113         );
114 
115         uint256 availableLiquidityAfter = token.balanceOf(address(this));
116         require(
117             availableLiquidityAfter >= availableLiquidityBefore.add(amountFee),
118             "flashLoan fee is not met"
119         );
120 
121         swapStorage.balances[tokenIndex] = availableLiquidityAfter
122             .sub(protocolBalanceBefore)
123             .sub(protocolFee);
124         emit FlashLoan(receiver, tokenIndex, amount, amountFee, protocolFee);
125     }
126 
127     /*** ADMIN FUNCTIONS ***/
128 
129     /**
130      * @notice Updates the flash loan fee parameters. Only owner can call this function.
131      * @dev This function should be overridden for permissions.
132      * @param newFlashLoanFeeBPS the total fee in bps to be applied on future flash loans
133      * @param newProtocolFeeShareBPS the protocol fee in bps to be applied on the total flash loan fee
134      */
135     function setFlashLoanFees(
136         uint256 newFlashLoanFeeBPS,
137         uint256 newProtocolFeeShareBPS
138     ) external payable virtual onlyOwner {
139         _setFlashLoanFees(newFlashLoanFeeBPS, newProtocolFeeShareBPS);
140     }
141 }
