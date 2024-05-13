1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "./IsolatedMarginLiquidation.sol";
5 
6 contract IsolatedMarginTrading is IsolatedMarginLiquidation {
7     constructor(address _roles) RoleAware(_roles) Ownable() {}
8 
9     /// @dev last time this account deposited
10     /// relevant for withdrawal window
11     function getLastDepositBlock(address trader)
12         external
13         view
14         returns (uint256)
15     {
16         return marginAccounts[trader].lastDepositBlock;
17     }
18 
19     /// @dev setter for cooling off period for withdrawing funds after deposit
20     function setCoolingOffPeriod(uint256 blocks) external onlyOwner {
21         coolingOffPeriod = blocks;
22     }
23 
24     /// @dev admin function to set leverage
25     function setLeveragePercent(uint256 _leveragePercent) external onlyOwner {
26         leveragePercent = _leveragePercent;
27     }
28 
29     /// @dev admin function to set liquidation threshold
30     function setLiquidationThresholdPercent(uint256 threshold)
31         external
32         onlyOwner
33     {
34         liquidationThresholdPercent = threshold;
35     }
36 
37     /// @dev gets called by router to affirm trader taking position
38     function registerPosition(
39         address trader,
40         uint256 borrowed,
41         uint256 holdingsAdded
42     ) external {
43         require(
44             isMarginTrader(msg.sender),
45             "Calling contract not authorized to deposit"
46         );
47 
48         IsolatedMarginAccount storage account = marginAccounts[trader];
49 
50         account.holding += holdingsAdded;
51         borrow(account, borrowed);
52     }
53 
54     /// @dev gets called by router to affirm unwinding of position
55     function registerUnwind(
56         address trader,
57         uint256 extinguished,
58         uint256 holdingsSold
59     ) external {
60         require(
61             isMarginTrader(msg.sender),
62             "Calling contract not authorized to deposit"
63         );
64 
65         IsolatedMarginAccount storage account = marginAccounts[trader];
66 
67         account.holding -= holdingsSold;
68         extinguishDebt(account, extinguished);
69     }
70 
71     /// @dev gets called by router to close account
72     function registerCloseAccount(address trader)
73         external
74         returns (uint256 holdingAmount)
75     {
76         require(
77             isMarginTrader(msg.sender),
78             "Calling contract not authorized to deposit"
79         );
80 
81         IsolatedMarginAccount storage account = marginAccounts[trader];
82 
83         require(account.borrowed == 0, "Can't close account that's borrowing");
84 
85         holdingAmount = account.holding;
86 
87         delete marginAccounts[trader];
88     }
89 }
