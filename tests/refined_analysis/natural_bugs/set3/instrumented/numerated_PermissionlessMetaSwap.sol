1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "./PermissionlessSwap.sol";
6 import "./ShareProtocolFee.sol";
7 import "../meta/MetaSwapUtils.sol";
8 import "../meta/MetaSwap.sol";
9 
10 /**
11  * @title MetaSwap - A StableSwap implementation in solidity.
12  * @notice This contract is responsible for custody of closely pegged assets (eg. group of stablecoins)
13  * and automatic market making system. Users become an LP (Liquidity Provider) by depositing their tokens
14  * in desired ratios for an exchange of the pool token that represents their share of the pool.
15  * Users can burn pool tokens and withdraw their share of token(s).
16  *
17  * Each time a swap between the pooled tokens happens, a set fee incurs which effectively gets
18  * distributed to the LPs.
19  *
20  * In case of emergencies, admin can pause additional deposits, swaps, or single-asset withdraws - which
21  * stops the ratio of the tokens in the pool from changing.
22  * Users can always withdraw their tokens via multi-asset withdraws.
23  *
24  * MetaSwap is a modified version of Swap that allows Swap's LP token to be utilized in pooling with other tokens.
25  * As an example, if there is a Swap pool consisting of [DAI, USDC, USDT], then a MetaSwap pool can be created
26  * with [sUSD, BaseSwapLPToken] to allow trades between either the LP token or the underlying tokens and sUSD.
27  * Note that when interacting with MetaSwap, users cannot deposit or withdraw via underlying tokens. In that case,
28  * `MetaSwapDeposit.sol` can be additionally deployed to allow interacting with unwrapped representations of the tokens.
29  *
30  * @dev Most of the logic is stored as a library `MetaSwapUtils` for the sake of reducing contract's
31  * deployment size.
32  */
33 contract PermissionlessMetaSwap is MetaSwap, ShareProtocolFee {
34     using PermissionlessSwapUtils for SwapUtils.Swap;
35 
36     /**
37      * @notice Constructor for the PermissionlessSwap contract.
38      * @param _masterRegistry address of the MasterRegistry contract
39      */
40     constructor(IMasterRegistry _masterRegistry)
41         public
42         ShareProtocolFee(_masterRegistry)
43     {}
44 
45     /*** ADMIN FUNCTIONS ***/
46 
47     function initializeMetaSwap(
48         IERC20[] memory _pooledTokens,
49         uint8[] memory decimals,
50         string memory lpTokenName,
51         string memory lpTokenSymbol,
52         uint256 _a,
53         uint256 _fee,
54         uint256 _adminFee,
55         address lpTokenTargetAddress,
56         ISwap baseSwap
57     ) public payable virtual override initializer {
58         MetaSwap.initializeMetaSwap(
59             _pooledTokens,
60             decimals,
61             lpTokenName,
62             lpTokenSymbol,
63             _a,
64             _fee,
65             _adminFee,
66             lpTokenTargetAddress,
67             baseSwap
68         );
69         _updateFeeCollectorCache(MASTER_REGISTRY);
70     }
71 
72     /**
73      * @notice Withdraw all admin fees to the contract owner and the fee collector
74      */
75     function withdrawAdminFees()
76         external
77         payable
78         virtual
79         override(ShareProtocolFee, Swap)
80     {
81         require(
82             msg.sender == owner() || msg.sender == feeCollector,
83             "Caller is not authorized"
84         );
85         PermissionlessSwapUtils.withdrawAdminFees(
86             swapStorage,
87             owner(),
88             feeCollector
89         );
90     }
91 }
