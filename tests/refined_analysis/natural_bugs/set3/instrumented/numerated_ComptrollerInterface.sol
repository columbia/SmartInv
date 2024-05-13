1 pragma solidity ^0.5.16;
2 
3 import "./CToken.sol";
4 import "./ComptrollerStorage.sol";
5 
6 contract ComptrollerInterface {
7     /// @notice Indicator that this is a Comptroller contract (for inspection)
8     bool public constant isComptroller = true;
9 
10     /*** Assets You Are In ***/
11 
12     function enterMarkets(address[] calldata cTokens) external returns (uint256[] memory);
13 
14     function exitMarket(address cToken) external returns (uint256);
15 
16     /*** Policy Hooks ***/
17 
18     function mintAllowed(
19         address cToken,
20         address minter,
21         uint256 mintAmount
22     ) external returns (uint256);
23 
24     function mintVerify(
25         address cToken,
26         address minter,
27         uint256 mintAmount,
28         uint256 mintTokens
29     ) external;
30 
31     function redeemAllowed(
32         address cToken,
33         address redeemer,
34         uint256 redeemTokens
35     ) external returns (uint256);
36 
37     function redeemVerify(
38         address cToken,
39         address redeemer,
40         uint256 redeemAmount,
41         uint256 redeemTokens
42     ) external;
43 
44     function borrowAllowed(
45         address cToken,
46         address borrower,
47         uint256 borrowAmount
48     ) external returns (uint256);
49 
50     function borrowVerify(
51         address cToken,
52         address borrower,
53         uint256 borrowAmount
54     ) external;
55 
56     function repayBorrowAllowed(
57         address cToken,
58         address payer,
59         address borrower,
60         uint256 repayAmount
61     ) external returns (uint256);
62 
63     function repayBorrowVerify(
64         address cToken,
65         address payer,
66         address borrower,
67         uint256 repayAmount,
68         uint256 borrowerIndex
69     ) external;
70 
71     function liquidateBorrowAllowed(
72         address cTokenBorrowed,
73         address cTokenCollateral,
74         address liquidator,
75         address borrower,
76         uint256 repayAmount
77     ) external returns (uint256);
78 
79     function liquidateBorrowVerify(
80         address cTokenBorrowed,
81         address cTokenCollateral,
82         address liquidator,
83         address borrower,
84         uint256 repayAmount,
85         uint256 seizeTokens
86     ) external;
87 
88     function seizeAllowed(
89         address cTokenCollateral,
90         address cTokenBorrowed,
91         address liquidator,
92         address borrower,
93         uint256 seizeTokens
94     ) external returns (uint256);
95 
96     function seizeVerify(
97         address cTokenCollateral,
98         address cTokenBorrowed,
99         address liquidator,
100         address borrower,
101         uint256 seizeTokens
102     ) external;
103 
104     function transferAllowed(
105         address cToken,
106         address src,
107         address dst,
108         uint256 transferTokens
109     ) external returns (uint256);
110 
111     function transferVerify(
112         address cToken,
113         address src,
114         address dst,
115         uint256 transferTokens
116     ) external;
117 
118     /*** Liquidity/Liquidation Calculations ***/
119 
120     function liquidateCalculateSeizeTokens(
121         address cTokenBorrowed,
122         address cTokenCollateral,
123         uint256 repayAmount
124     ) external view returns (uint256, uint256);
125 }
126 
127 interface ComptrollerInterfaceExtension {
128     function checkMembership(address account, CToken cToken) external view returns (bool);
129 
130     function updateCTokenVersion(address cToken, ComptrollerV2Storage.Version version) external;
131 
132     function flashloanAllowed(
133         address cToken,
134         address receiver,
135         uint256 amount,
136         bytes calldata params
137     ) external view returns (bool);
138 
139     function getAccountLiquidity(address account)
140         external
141         view
142         returns (
143             uint256,
144             uint256,
145             uint256
146         );
147 
148     function supplyCaps(address market) external view returns (uint256);
149 }
