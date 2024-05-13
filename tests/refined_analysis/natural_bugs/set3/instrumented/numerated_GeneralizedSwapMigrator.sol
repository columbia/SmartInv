1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 import "./interfaces/ISwap.sol";
7 import "./helper/BaseBoringBatchable.sol";
8 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
9 import "@openzeppelin/contracts/access/Ownable.sol";
10 
11 /**
12  * @title GeneralizedSwapMigrator
13  * @notice This contract is responsible for migration liquidity between pools
14  * Users can use this contract to remove their liquidity from the old pools and add them to the new
15  * ones with a single transaction.
16  */
17 contract GeneralizedSwapMigrator is Ownable, BaseBoringBatchable {
18     using SafeERC20 for IERC20;
19 
20     struct MigrationData {
21         address newPoolAddress;
22         IERC20 oldPoolLPTokenAddress;
23         IERC20 newPoolLPTokenAddress;
24         IERC20[] tokens;
25     }
26 
27     uint256 private constant MAX_UINT256 = 2**256 - 1;
28     mapping(address => MigrationData) public migrationMap;
29 
30     event AddMigrationData(address indexed oldPoolAddress, MigrationData mData);
31     event Migrate(
32         address indexed migrator,
33         address indexed oldPoolAddress,
34         uint256 oldLPTokenAmount,
35         uint256 newLPTokenAmount
36     );
37 
38     constructor() public Ownable() {}
39 
40     /**
41      * @notice Add new migration data to the contract
42      * @param oldPoolAddress pool address to migrate from
43      * @param mData MigrationData struct that contains information of the old and new pools
44      * @param overwrite should overwrite existing migration data
45      */
46     function addMigrationData(
47         address oldPoolAddress,
48         MigrationData memory mData,
49         bool overwrite
50     ) external onlyOwner {
51         // Check
52         if (!overwrite) {
53             require(
54                 address(migrationMap[oldPoolAddress].oldPoolLPTokenAddress) ==
55                     address(0),
56                 "cannot overwrite existing migration data"
57             );
58         }
59         require(
60             address(mData.oldPoolLPTokenAddress) != address(0),
61             "oldPoolLPTokenAddress == 0"
62         );
63         require(
64             address(mData.newPoolLPTokenAddress) != address(0),
65             "newPoolLPTokenAddress == 0"
66         );
67 
68         for (uint8 i = 0; i < 32; i++) {
69             address oldPoolToken;
70             try ISwap(oldPoolAddress).getToken(i) returns (IERC20 token) {
71                 oldPoolToken = address(token);
72             } catch {
73                 require(i > 0, "Failed to get tokens underlying Saddle pool.");
74                 oldPoolToken = address(0);
75             }
76 
77             try ISwap(mData.newPoolAddress).getToken(i) returns (IERC20 token) {
78                 require(
79                     oldPoolToken == address(token) &&
80                         oldPoolToken == address(mData.tokens[i]),
81                     "Failed to match tokens list"
82                 );
83             } catch {
84                 require(i > 0, "Failed to get tokens underlying Saddle pool.");
85                 require(
86                     oldPoolToken == address(0) && i == mData.tokens.length,
87                     "Failed to match tokens list"
88                 );
89                 break;
90             }
91         }
92 
93         // Effect
94         migrationMap[oldPoolAddress] = mData;
95 
96         // Interaction
97         // Approve old LP Token to be used for withdraws.
98         mData.oldPoolLPTokenAddress.approve(oldPoolAddress, MAX_UINT256);
99 
100         // Approve underlying tokens to be used for deposits.
101         for (uint256 i = 0; i < mData.tokens.length; i++) {
102             mData.tokens[i].safeApprove(mData.newPoolAddress, 0);
103             mData.tokens[i].safeApprove(mData.newPoolAddress, MAX_UINT256);
104         }
105 
106         emit AddMigrationData(oldPoolAddress, mData);
107     }
108 
109     /**
110      * @notice Migrates saddle LP tokens from a pool to another
111      * @param oldPoolAddress pool address to migrate from
112      * @param amount amount of LP tokens to migrate
113      * @param minAmount of new LP tokens to receive
114      */
115     function migrate(
116         address oldPoolAddress,
117         uint256 amount,
118         uint256 minAmount
119     ) external returns (uint256) {
120         // Check
121         MigrationData memory mData = migrationMap[oldPoolAddress];
122         require(
123             address(mData.oldPoolLPTokenAddress) != address(0),
124             "migration is not available"
125         );
126 
127         // Interactions
128         // Transfer old LP token from the caller
129         mData.oldPoolLPTokenAddress.safeTransferFrom(
130             msg.sender,
131             address(this),
132             amount
133         );
134 
135         // Remove liquidity from the old pool
136         uint256[] memory amounts = ISwap(oldPoolAddress).removeLiquidity(
137             amount,
138             new uint256[](mData.tokens.length),
139             MAX_UINT256
140         );
141         // Add acquired liquidity to the new pool
142         uint256 mintedAmount = ISwap(mData.newPoolAddress).addLiquidity(
143             amounts,
144             minAmount,
145             MAX_UINT256
146         );
147 
148         // Transfer new LP Token to the caller
149         mData.newPoolLPTokenAddress.safeTransfer(msg.sender, mintedAmount);
150 
151         emit Migrate(msg.sender, oldPoolAddress, amount, mintedAmount);
152         return mintedAmount;
153     }
154 
155     /**
156      * @notice Rescues any token that may be sent to this contract accidentally.
157      * @param token Amount of old LPToken to migrate
158      * @param to Minimum amount of new LPToken to receive
159      */
160     function rescue(IERC20 token, address to) external onlyOwner {
161         token.safeTransfer(to, token.balanceOf(address(this)));
162     }
163 }
