1 pragma solidity ^0.5.16;
2 
3 import "./CToken.sol";
4 import "./PriceOracle/PriceOracle.sol";
5 
6 contract UnitrollerAdminStorage {
7     /**
8      * @notice Administrator for this contract
9      */
10     address public admin;
11 
12     /**
13      * @notice Pending administrator for this contract
14      */
15     address public pendingAdmin;
16 
17     /**
18      * @notice Active brains of Unitroller
19      */
20     address public comptrollerImplementation;
21 
22     /**
23      * @notice Pending brains of Unitroller
24      */
25     address public pendingComptrollerImplementation;
26 }
27 
28 contract ComptrollerV1Storage is UnitrollerAdminStorage {
29     /**
30      * @notice Oracle which gives the price of any given asset
31      */
32     PriceOracle public oracle;
33 
34     /**
35      * @notice Multiplier used to calculate the maximum repayAmount when liquidating a borrow
36      */
37     uint256 public closeFactorMantissa;
38 
39     /**
40      * @notice Multiplier representing the discount on collateral that a liquidator receives
41      */
42     uint256 public liquidationIncentiveMantissa;
43 
44     /**
45      * @notice Max number of assets a single account can participate in (borrow or use as collateral)
46      */
47     uint256 public maxAssets;
48 
49     /**
50      * @notice Per-account mapping of "assets you are in", capped by maxAssets
51      */
52     mapping(address => CToken[]) public accountAssets;
53 }
54 
55 contract ComptrollerV2Storage is ComptrollerV1Storage {
56     enum Version {
57         VANILLA,
58         COLLATERALCAP,
59         WRAPPEDNATIVE
60     }
61 
62     struct Market {
63         /// @notice Whether or not this market is listed
64         bool isListed;
65         /**
66          * @notice Multiplier representing the most one can borrow against their collateral in this market.
67          *  For instance, 0.9 to allow borrowing 90% of collateral value.
68          *  Must be between 0 and 1, and stored as a mantissa.
69          */
70         uint256 collateralFactorMantissa;
71         /// @notice Per-market mapping of "accounts in this asset"
72         mapping(address => bool) accountMembership;
73         /// @notice Whether or not this market receives COMP
74         bool isComped;
75         /// @notice CToken version
76         Version version;
77     }
78 
79     /**
80      * @notice Official mapping of cTokens -> Market metadata
81      * @dev Used e.g. to determine if a market is supported
82      */
83     mapping(address => Market) public markets;
84 
85     /**
86      * @notice The Pause Guardian can pause certain actions as a safety mechanism.
87      *  Actions which allow users to remove their own assets cannot be paused.
88      *  Liquidation / seizing / transfer can only be paused globally, not by market.
89      */
90     address public pauseGuardian;
91     bool public _mintGuardianPaused;
92     bool public _borrowGuardianPaused;
93     bool public transferGuardianPaused;
94     bool public seizeGuardianPaused;
95     mapping(address => bool) public mintGuardianPaused;
96     mapping(address => bool) public borrowGuardianPaused;
97 }
98 
99 contract ComptrollerV3Storage is ComptrollerV2Storage {
100     struct CompMarketState {
101         /// @notice The market's last updated compBorrowIndex or compSupplyIndex
102         uint224 index;
103         /// @notice The block number the index was last updated at
104         uint32 block;
105     }
106 
107     /// @notice A list of all markets
108     CToken[] public allMarkets;
109 
110     /// @notice The rate at which the flywheel distributes COMP, per block
111     uint256 public compRate;
112 
113     /// @notice The portion of compRate that each market currently receives
114     mapping(address => uint256) public compSpeeds;
115 
116     /// @notice The COMP market supply state for each market
117     mapping(address => CompMarketState) public compSupplyState;
118 
119     /// @notice The COMP market borrow state for each market
120     mapping(address => CompMarketState) public compBorrowState;
121 
122     /// @notice The COMP borrow index for each market for each supplier as of the last time they accrued COMP
123     mapping(address => mapping(address => uint256)) public compSupplierIndex;
124 
125     /// @notice The COMP borrow index for each market for each borrower as of the last time they accrued COMP
126     mapping(address => mapping(address => uint256)) public compBorrowerIndex;
127 
128     /// @notice The COMP accrued but not yet transferred to each user
129     mapping(address => uint256) public compAccrued;
130 }
131 
132 contract ComptrollerV4Storage is ComptrollerV3Storage {
133     // @notice The borrowCapGuardian can set borrowCaps to any number for any market. Lowering the borrow cap could disable borrowing on the given market.
134     address public borrowCapGuardian;
135 
136     // @notice Borrow caps enforced by borrowAllowed for each cToken address. Defaults to zero which corresponds to unlimited borrowing.
137     mapping(address => uint256) public borrowCaps;
138 }
139 
140 contract ComptrollerV5Storage is ComptrollerV4Storage {
141     // @notice The supplyCapGuardian can set supplyCaps to any number for any market. Lowering the supply cap could disable supplying to the given market.
142     address public supplyCapGuardian;
143 
144     // @notice Supply caps enforced by mintAllowed for each cToken address. Defaults to zero which corresponds to unlimited supplying.
145     mapping(address => uint256) public supplyCaps;
146 }
147 
148 contract ComptrollerV6Storage is ComptrollerV5Storage {
149     // @notice flashloanGuardianPaused can pause flash loan as a safety mechanism.
150     mapping(address => bool) public flashloanGuardianPaused;
151 }
152 
153 contract ComptrollerV7Storage is ComptrollerV6Storage {
154     /// @notice liquidityMining the liquidity mining module that handles the LM rewards distribution.
155     address public liquidityMining;
156 }
