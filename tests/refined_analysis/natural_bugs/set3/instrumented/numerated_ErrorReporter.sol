1 pragma solidity ^0.5.16;
2 
3 contract ComptrollerErrorReporter {
4     enum Error {
5         NO_ERROR,
6         UNAUTHORIZED,
7         COMPTROLLER_MISMATCH,
8         INSUFFICIENT_SHORTFALL,
9         INSUFFICIENT_LIQUIDITY,
10         INVALID_CLOSE_FACTOR,
11         INVALID_COLLATERAL_FACTOR,
12         INVALID_LIQUIDATION_INCENTIVE,
13         MARKET_NOT_ENTERED, // no longer possible
14         MARKET_NOT_LISTED,
15         MARKET_ALREADY_LISTED,
16         MATH_ERROR,
17         NONZERO_BORROW_BALANCE,
18         PRICE_ERROR,
19         REJECTION,
20         SNAPSHOT_ERROR,
21         TOO_MANY_ASSETS,
22         TOO_MUCH_REPAY
23     }
24 
25     enum FailureInfo {
26         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
27         ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK,
28         EXIT_MARKET_BALANCE_OWED,
29         EXIT_MARKET_REJECTION,
30         SET_CLOSE_FACTOR_OWNER_CHECK,
31         SET_CLOSE_FACTOR_VALIDATION,
32         SET_COLLATERAL_FACTOR_OWNER_CHECK,
33         SET_COLLATERAL_FACTOR_NO_EXISTS,
34         SET_COLLATERAL_FACTOR_VALIDATION,
35         SET_COLLATERAL_FACTOR_WITHOUT_PRICE,
36         SET_IMPLEMENTATION_OWNER_CHECK,
37         SET_LIQUIDATION_INCENTIVE_OWNER_CHECK,
38         SET_LIQUIDATION_INCENTIVE_VALIDATION,
39         SET_MAX_ASSETS_OWNER_CHECK,
40         SET_PENDING_ADMIN_OWNER_CHECK,
41         SET_PENDING_IMPLEMENTATION_OWNER_CHECK,
42         SET_PRICE_ORACLE_OWNER_CHECK,
43         SUPPORT_MARKET_EXISTS,
44         SUPPORT_MARKET_OWNER_CHECK,
45         SET_PAUSE_GUARDIAN_OWNER_CHECK
46     }
47 
48     /**
49      * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
50      * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
51      **/
52     event Failure(uint256 error, uint256 info, uint256 detail);
53 
54     /**
55      * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
56      */
57     function fail(Error err, FailureInfo info) internal returns (uint256) {
58         emit Failure(uint256(err), uint256(info), 0);
59 
60         return uint256(err);
61     }
62 
63     /**
64      * @dev use this when reporting an opaque error from an upgradeable collaborator contract
65      */
66     function failOpaque(
67         Error err,
68         FailureInfo info,
69         uint256 opaqueError
70     ) internal returns (uint256) {
71         emit Failure(uint256(err), uint256(info), opaqueError);
72 
73         return uint256(err);
74     }
75 }
76 
77 contract TokenErrorReporter {
78     enum Error {
79         NO_ERROR,
80         UNAUTHORIZED,
81         BAD_INPUT,
82         COMPTROLLER_REJECTION,
83         COMPTROLLER_CALCULATION_ERROR,
84         INTEREST_RATE_MODEL_ERROR,
85         INVALID_ACCOUNT_PAIR,
86         INVALID_CLOSE_AMOUNT_REQUESTED,
87         INVALID_COLLATERAL_FACTOR,
88         MATH_ERROR,
89         MARKET_NOT_FRESH,
90         MARKET_NOT_LISTED,
91         TOKEN_INSUFFICIENT_ALLOWANCE,
92         TOKEN_INSUFFICIENT_BALANCE,
93         TOKEN_INSUFFICIENT_CASH,
94         TOKEN_TRANSFER_IN_FAILED,
95         TOKEN_TRANSFER_OUT_FAILED
96     }
97 
98     /*
99      * Note: FailureInfo (but not Error) is kept in alphabetical order
100      *       This is because FailureInfo grows significantly faster, and
101      *       the order of Error has some meaning, while the order of FailureInfo
102      *       is entirely arbitrary.
103      */
104     enum FailureInfo {
105         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
106         ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED,
107         BORROW_ACCRUE_INTEREST_FAILED,
108         BORROW_CASH_NOT_AVAILABLE,
109         BORROW_FRESHNESS_CHECK,
110         BORROW_MARKET_NOT_LISTED,
111         BORROW_COMPTROLLER_REJECTION,
112         LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED,
113         LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED,
114         LIQUIDATE_COLLATERAL_FRESHNESS_CHECK,
115         LIQUIDATE_COMPTROLLER_REJECTION,
116         LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED,
117         LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX,
118         LIQUIDATE_CLOSE_AMOUNT_IS_ZERO,
119         LIQUIDATE_FRESHNESS_CHECK,
120         LIQUIDATE_LIQUIDATOR_IS_BORROWER,
121         LIQUIDATE_REPAY_BORROW_FRESH_FAILED,
122         LIQUIDATE_SEIZE_COMPTROLLER_REJECTION,
123         LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER,
124         LIQUIDATE_SEIZE_TOO_MUCH,
125         MINT_ACCRUE_INTEREST_FAILED,
126         MINT_COMPTROLLER_REJECTION,
127         MINT_FRESHNESS_CHECK,
128         MINT_TRANSFER_IN_FAILED,
129         MINT_TRANSFER_IN_NOT_POSSIBLE,
130         REDEEM_ACCRUE_INTEREST_FAILED,
131         REDEEM_COMPTROLLER_REJECTION,
132         REDEEM_FRESHNESS_CHECK,
133         REDEEM_TRANSFER_OUT_NOT_POSSIBLE,
134         REDUCE_RESERVES_ACCRUE_INTEREST_FAILED,
135         REDUCE_RESERVES_ADMIN_CHECK,
136         REDUCE_RESERVES_CASH_NOT_AVAILABLE,
137         REDUCE_RESERVES_FRESH_CHECK,
138         REDUCE_RESERVES_VALIDATION,
139         REPAY_BEHALF_ACCRUE_INTEREST_FAILED,
140         REPAY_BORROW_ACCRUE_INTEREST_FAILED,
141         REPAY_BORROW_COMPTROLLER_REJECTION,
142         REPAY_BORROW_FRESHNESS_CHECK,
143         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
144         SET_COLLATERAL_FACTOR_OWNER_CHECK,
145         SET_COLLATERAL_FACTOR_VALIDATION,
146         SET_COMPTROLLER_OWNER_CHECK,
147         SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED,
148         SET_INTEREST_RATE_MODEL_FRESH_CHECK,
149         SET_INTEREST_RATE_MODEL_OWNER_CHECK,
150         SET_MAX_ASSETS_OWNER_CHECK,
151         SET_ORACLE_MARKET_NOT_LISTED,
152         SET_PENDING_ADMIN_OWNER_CHECK,
153         SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED,
154         SET_RESERVE_FACTOR_ADMIN_CHECK,
155         SET_RESERVE_FACTOR_FRESH_CHECK,
156         SET_RESERVE_FACTOR_BOUNDS_CHECK,
157         TRANSFER_COMPTROLLER_REJECTION,
158         TRANSFER_NOT_ALLOWED,
159         ADD_RESERVES_ACCRUE_INTEREST_FAILED,
160         ADD_RESERVES_FRESH_CHECK,
161         ADD_RESERVES_TRANSFER_IN_NOT_POSSIBLE
162     }
163 
164     /**
165      * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
166      * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
167      **/
168     event Failure(uint256 error, uint256 info, uint256 detail);
169 
170     /**
171      * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
172      */
173     function fail(Error err, FailureInfo info) internal returns (uint256) {
174         emit Failure(uint256(err), uint256(info), 0);
175 
176         return uint256(err);
177     }
178 
179     /**
180      * @dev use this when reporting an opaque error from an upgradeable collaborator contract
181      */
182     function failOpaque(
183         Error err,
184         FailureInfo info,
185         uint256 opaqueError
186     ) internal returns (uint256) {
187         emit Failure(uint256(err), uint256(info), opaqueError);
188 
189         return uint256(err);
190     }
191 }
