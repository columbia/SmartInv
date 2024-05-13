1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 import "@openzeppelin/contracts/access/Ownable.sol";
4 import "./RoleAware.sol";
5 import "./Lending.sol";
6 import "./PriceAware.sol";
7 
8 abstract contract IsolatedMarginAccounts is RoleAware {
9     struct IsolatedMarginAccount {
10         uint256 lastDepositBlock;
11         uint256 borrowed;
12         uint256 borrowedYieldQuotientFP;
13         uint256 holding;
14     }
15 
16     address public borrowToken;
17     address public holdingToken;
18 
19     uint256 public totalDebt;
20 
21     address[] public liquidationPairs;
22     address[] public liquidationTokens;
23 
24     /// update window in blocks
25     uint16 public priceUpdateWindow = 8;
26     uint256 public UPDATE_RATE_PERMIL = 80;
27 
28     /// @dev percentage of assets held per assets borrowed at which to liquidate
29     uint256 public liquidationThresholdPercent;
30 
31     mapping(address => IsolatedMarginAccount) public marginAccounts;
32     uint256 public coolingOffPeriod = 20;
33     uint256 public leveragePercent = 500;
34 
35     /// @dev adjust account to reflect borrowing of token amount
36     function borrow(IsolatedMarginAccount storage account, uint256 amount)
37         internal
38     {
39         updateLoan(account);
40         account.borrowed += amount;
41         require(positiveBalance(account), "Can't borrow: insufficient balance");
42     }
43 
44     function updateLoan(IsolatedMarginAccount storage account) internal {
45         account.borrowed = Lending(lending()).applyBorrowInterest(
46             account.borrowed,
47             address(this),
48             account.borrowedYieldQuotientFP
49         );
50         account.borrowedYieldQuotientFP = Lending(lending())
51             .viewBorrowingYieldFP(address(this));
52     }
53 
54     /// @dev checks whether account is in the black, deposit + earnings relative to borrowed
55     function positiveBalance(IsolatedMarginAccount storage account)
56         internal
57         returns (bool)
58     {
59         uint256 loan = loanInPeg(account, false);
60         uint256 holdings = holdingInPeg(account, false);
61 
62         // The following condition should hold:
63         // holdings / loan >= leveragePercent / (leveragePercent - 100)
64         // =>
65         return holdings * (leveragePercent - 100) >= loan * leveragePercent;
66     }
67 
68     /// @dev internal function adjusting holding and borrow balances when debt extinguished
69     function extinguishDebt(
70         IsolatedMarginAccount storage account,
71         uint256 extinguishAmount
72     ) internal {
73         // TODO check if underflow?
74         // TODO TELL LENDING
75         updateLoan(account);
76         account.borrowed -= extinguishAmount;
77     }
78 
79     /// @dev check whether an account can/should be liquidated
80     function belowMaintenanceThreshold(IsolatedMarginAccount storage account)
81         internal
82         returns (bool)
83     {
84         uint256 loan = loanInPeg(account, true);
85         uint256 holdings = holdingInPeg(account, true);
86         // The following should hold:
87         // holdings / loan >= 1.1
88         // => holdings >= loan * 1.1
89         return 100 * holdings >= liquidationThresholdPercent * loan;
90     }
91 
92     /// @dev calculate loan in reference currency
93     function loanInPeg(
94         IsolatedMarginAccount storage account,
95         bool forceCurBlock
96     ) internal returns (uint256) {
97         return
98             PriceAware(price()).getCurrentPriceInPeg(
99                 borrowToken,
100                 account.borrowed,
101                 forceCurBlock
102             );
103     }
104 
105     /// @dev calculate loan in reference currency
106     function holdingInPeg(
107         IsolatedMarginAccount storage account,
108         bool forceCurBlock
109     ) internal returns (uint256) {
110         return
111             PriceAware(price()).getCurrentPriceInPeg(
112                 holdingToken,
113                 account.holding,
114                 forceCurBlock
115             );
116     }
117 
118     /// @dev minimum
119     function min(uint256 a, uint256 b) internal pure returns (uint256) {
120         if (a > b) {
121             return b;
122         } else {
123             return a;
124         }
125     }
126 }
