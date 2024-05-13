1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "../Swap.sol";
6 import "../interfaces/IMasterRegistry.sol";
7 import "./PermissionlessSwapUtils.sol";
8 import "./ShareProtocolFee.sol";
9 
10 /**
11  * @title Swap - A StableSwap implementation in solidity.
12  * @notice This contract is responsible for custody of closely pegged assets (eg. group of stablecoins)
13  * and automatic market making system. Users become an LP (Liquidity Provider) by depositing their tokens
14  * in desired ratios for an exchange of the pool token that represents their share of the pool.
15  * Users can burn pool tokens and withdraw their share of token(s).
16  *
17  * Each time a swap between the pooled tokens happens, a set fee incurs which effectively gets
18  * distributed to the LPs. Part of this fee is given to the creator of the pool as an Admin fee,
19  * the amount of which is set when the pool is created. Saddle will collect to 50% of these Admin fees.
20  *
21  * In case of emergencies, admin can pause additional deposits, swaps, or single-asset withdraws - which
22  * stops the ratio of the tokens in the pool from changing.
23  * Users can always withdraw their tokens via multi-asset withdraws.
24  *
25  * @dev Most of the logic is stored as a library `PermissionlessSwapUtils` for the sake of reducing
26  * contract's deployment size.
27  */
28 contract PermissionlessSwap is Swap, ShareProtocolFee {
29     using PermissionlessSwapUtils for SwapUtils.Swap;
30 
31     /**
32      * @notice Constructor for the PermissionlessSwap contract.
33      * @param _masterRegistry address of the MasterRegistry contract
34      */
35     constructor(IMasterRegistry _masterRegistry)
36         public
37         ShareProtocolFee(_masterRegistry)
38     {}
39 
40     /*** ADMIN FUNCTIONS ***/
41 
42     /**
43      * @notice Updates cached address of the fee collector
44      */
45     function initialize(
46         IERC20[] memory _pooledTokens,
47         uint8[] memory decimals,
48         string memory lpTokenName,
49         string memory lpTokenSymbol,
50         uint256 _a,
51         uint256 _fee,
52         uint256 _adminFee,
53         address lpTokenTargetAddress
54     ) public payable virtual override initializer {
55         Swap.initialize(
56             _pooledTokens,
57             decimals,
58             lpTokenName,
59             lpTokenSymbol,
60             _a,
61             _fee,
62             _adminFee,
63             lpTokenTargetAddress
64         );
65         _updateFeeCollectorCache(MASTER_REGISTRY);
66     }
67 
68     /**
69      * @notice Withdraw all admin fees to the contract owner and the fee collector.
70      */
71     function withdrawAdminFees()
72         external
73         payable
74         virtual
75         override(Swap, ShareProtocolFee)
76     {
77         require(
78             msg.sender == owner() || msg.sender == feeCollector,
79             "Caller is not authorized"
80         );
81         PermissionlessSwapUtils.withdrawAdminFees(
82             swapStorage,
83             owner(),
84             feeCollector
85         );
86     }
87 }
