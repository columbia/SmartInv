1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../utils/WethPCVDeposit.sol";
5 
6 interface LendingPool {
7     function deposit(
8         address asset,
9         uint256 amount,
10         address onBehalfOf,
11         uint16 referralCode
12     ) external;
13 
14     function withdraw(
15         address asset,
16         uint256 amount,
17         address to
18     ) external;
19 }
20 
21 interface IncentivesController {
22     function claimRewards(
23         address[] calldata assets,
24         uint256 amount,
25         address to
26     ) external;
27 
28     function getRewardsBalance(address[] calldata assets, address user) external view returns (uint256);
29 }
30 
31 /// @title Aave PCV Deposit
32 /// @author Fei Protocol
33 contract AavePCVDeposit is WethPCVDeposit {
34     event ClaimRewards(address indexed caller, uint256 amount);
35 
36     /// @notice the associated Aave aToken for the deposit
37     IERC20 public aToken;
38 
39     /// @notice the Aave v2 lending pool
40     LendingPool public lendingPool;
41 
42     /// @notice the underlying token of the PCV deposit
43     IERC20 public token;
44 
45     /// @notice the Aave incentives controller for the aToken
46     IncentivesController public incentivesController;
47 
48     /// @notice Aave PCV Deposit constructor
49     /// @param _core Fei Core for reference
50     /// @param _lendingPool the Aave v2 lending pool
51     /// @param _token the underlying token of the PCV deposit
52     /// @param _aToken the associated Aave aToken for the deposit
53     /// @param _incentivesController the Aave incentives controller for the aToken
54     constructor(
55         address _core,
56         LendingPool _lendingPool,
57         IERC20 _token,
58         IERC20 _aToken,
59         IncentivesController _incentivesController
60     ) CoreRef(_core) {
61         lendingPool = _lendingPool;
62         aToken = _aToken;
63         token = _token;
64         incentivesController = _incentivesController;
65     }
66 
67     /// @notice claims Aave rewards from the deposit and transfers to this address
68     function claimRewards() external {
69         address[] memory assets = new address[](1);
70         assets[0] = address(aToken);
71         // First grab the available balance
72         uint256 amount = incentivesController.getRewardsBalance(assets, address(this));
73 
74         // claim all available rewards
75         incentivesController.claimRewards(assets, amount, address(this));
76 
77         emit ClaimRewards(msg.sender, amount);
78     }
79 
80     /// @notice deposit buffered aTokens
81     function deposit() external override whenNotPaused {
82         // wrap any held ETH if present
83         wrapETH();
84 
85         // Approve and deposit buffered tokens
86         uint256 pendingBalance = token.balanceOf(address(this));
87         token.approve(address(lendingPool), pendingBalance);
88         lendingPool.deposit(address(token), pendingBalance, address(this), 0);
89 
90         emit Deposit(msg.sender, pendingBalance);
91     }
92 
93     /// @notice withdraw tokens from the PCV allocation
94     /// @param amountUnderlying of tokens withdrawn
95     /// @param to the address to send PCV to
96     function withdraw(address to, uint256 amountUnderlying) external override onlyPCVController {
97         lendingPool.withdraw(address(token), amountUnderlying, to);
98         emit Withdrawal(msg.sender, to, amountUnderlying);
99     }
100 
101     /// @notice returns total balance of PCV in the Deposit
102     /// @dev aTokens are rebasing, so represent 1:1 on underlying value
103     function balance() public view override returns (uint256) {
104         return aToken.balanceOf(address(this));
105     }
106 
107     /// @notice display the related token of the balance reported
108     function balanceReportedIn() public view override returns (address) {
109         return address(token);
110     }
111 }
