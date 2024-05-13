1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 import "./interfaces/ISwap.sol";
7 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
8 
9 /**
10  * @title SwapMigrator
11  * @notice This contract is responsible for migrating old USD pool liquidity to the new ones.
12  * Users can use this contract to remove their liquidity from the old pools and add them to the new
13  * ones with a single transaction.
14  */
15 contract SwapMigrator {
16     using SafeERC20 for IERC20;
17 
18     struct MigrationData {
19         address oldPoolAddress;
20         IERC20 oldPoolLPTokenAddress;
21         address newPoolAddress;
22         IERC20 newPoolLPTokenAddress;
23         IERC20[] underlyingTokens;
24     }
25 
26     MigrationData public usdPoolMigrationData;
27     address public owner;
28 
29     uint256 private constant MAX_UINT256 = 2**256 - 1;
30 
31     /**
32      * @notice Sets the storage variables and approves tokens to be used by the old and new swap contracts
33      * @param usdData_ MigrationData struct with information about old and new USD pools
34      * @param owner_ owner that is allowed to call the `rescue()` function
35      */
36     constructor(MigrationData memory usdData_, address owner_) public {
37         // Approve old USD LP Token to be used by the old USD pool
38         usdData_.oldPoolLPTokenAddress.approve(
39             usdData_.oldPoolAddress,
40             MAX_UINT256
41         );
42 
43         // Approve USD tokens to be used by the new USD pool
44         for (uint256 i = 0; i < usdData_.underlyingTokens.length; i++) {
45             usdData_.underlyingTokens[i].safeApprove(
46                 usdData_.newPoolAddress,
47                 MAX_UINT256
48             );
49         }
50 
51         // Set storage variables
52         usdPoolMigrationData = usdData_;
53         owner = owner_;
54     }
55 
56     /**
57      * @notice Migrates old USD pool's LPToken to the new pool
58      * @param amount Amount of old LPToken to migrate
59      * @param minAmount Minimum amount of new LPToken to receive
60      */
61     function migrateUSDPool(uint256 amount, uint256 minAmount)
62         external
63         returns (uint256)
64     {
65         // Transfer old LP token from the caller
66         usdPoolMigrationData.oldPoolLPTokenAddress.safeTransferFrom(
67             msg.sender,
68             address(this),
69             amount
70         );
71 
72         // Remove liquidity from the old pool and add them to the new pool
73         uint256[] memory amounts = ISwap(usdPoolMigrationData.oldPoolAddress)
74             .removeLiquidity(
75                 amount,
76                 new uint256[](usdPoolMigrationData.underlyingTokens.length),
77                 MAX_UINT256
78             );
79         uint256 mintedAmount = ISwap(usdPoolMigrationData.newPoolAddress)
80             .addLiquidity(amounts, minAmount, MAX_UINT256);
81 
82         // Transfer new LP Token to the caller
83         usdPoolMigrationData.newPoolLPTokenAddress.safeTransfer(
84             msg.sender,
85             mintedAmount
86         );
87         return mintedAmount;
88     }
89 
90     /**
91      * @notice Rescues any token that may be sent to this contract accidentally.
92      * @param token Amount of old LPToken to migrate
93      * @param to Minimum amount of new LPToken to receive
94      */
95     function rescue(IERC20 token, address to) external {
96         require(msg.sender == owner, "is not owner");
97         token.safeTransfer(to, token.balanceOf(address(this)));
98     }
99 }
