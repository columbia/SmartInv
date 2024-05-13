1 pragma solidity ^0.8.0;
2 
3 import {CToken} from "../../external/fuse/CToken.sol";
4 
5 interface IRewardsDistributorDelegator {
6     /// @notice The portion of compRate that each market currently receives
7     function compSupplySpeeds(address) external view returns (uint256);
8 
9     /// @notice The portion of compRate that each market currently receives
10     function compBorrowSpeeds(address) external view returns (uint256);
11 
12     /// @notice Role for AutoRewardsDistributor contracts
13     function AUTO_REWARDS_DISTRIBUTOR_ROLE() external view returns (bytes32);
14 
15     /*** Set Admin ***/
16 
17     /**
18      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
19      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
20      * @param newPendingAdmin New pending admin.
21      */
22     function _setPendingAdmin(address newPendingAdmin) external;
23 
24     /**
25      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
26      * @dev Admin function for pending admin to accept role and update admin
27      */
28     function _acceptAdmin() external;
29 
30     /**
31      * @notice Keeps the flywheel moving pre-mint and pre-redeem
32      * @dev Called by the Comptroller
33      * @param cToken The relevant market
34      * @param supplier The minter/redeemer
35      */
36     function flywheelPreSupplierAction(address cToken, address supplier) external;
37 
38     /**
39      * @notice Keeps the flywheel moving pre-borrow and pre-repay
40      * @dev Called by the Comptroller
41      * @param cToken The relevant market
42      * @param borrower The borrower
43      */
44     function flywheelPreBorrowerAction(address cToken, address borrower) external;
45 
46     /**
47      * @notice Keeps the flywheel moving pre-transfer and pre-seize
48      * @dev Called by the Comptroller
49      * @param cToken The relevant market
50      * @param src The account which sources the tokens
51      * @param dst The account which receives the tokens
52      */
53     function flywheelPreTransferAction(
54         address cToken,
55         address src,
56         address dst
57     ) external;
58 
59     /**
60      * @notice Calculate additional accrued COMP for a contributor since last accrual
61      * @param contributor The address to calculate contributor rewards for
62      */
63     function updateContributorRewards(address contributor) external;
64 
65     /**
66      * @notice Claim all the comp accrued by holder in all markets
67      * @param holder The address to claim COMP for
68      */
69     function claimRewards(address holder) external;
70 
71     /**
72      * @notice Claim all the comp accrued by holder in the specified markets
73      * @param holder The address to claim COMP for
74      * @param cTokens The list of markets to claim COMP in
75      */
76     function claimRewards(address holder, CToken[] memory cTokens) external;
77 
78     /**
79      * @notice Claim all comp accrued by the holders
80      * @param holders The addresses to claim COMP for
81      * @param cTokens The list of markets to claim COMP in
82      * @param borrowers Whether or not to claim COMP earned by borrowing
83      * @param suppliers Whether or not to claim COMP earned by supplying
84      */
85     function claimRewards(
86         address[] memory holders,
87         CToken[] memory cTokens,
88         bool borrowers,
89         bool suppliers
90     ) external;
91 
92     /*** Comp Distribution Admin ***/
93 
94     /**
95      * @notice Transfer COMP to the recipient
96      * @dev Note: If there is not enough COMP, we do not perform the transfer all.
97      * @param recipient The address of the recipient to transfer COMP to
98      * @param amount The amount of COMP to (possibly) transfer
99      */
100     function _grantComp(address recipient, uint256 amount) external;
101 
102     /**
103      * @notice Set COMP speed for a single market
104      * @param cToken The market whose COMP speed to update
105      * @param compSpeed New COMP speed for market
106      */
107     function _setCompSupplySpeed(CToken cToken, uint256 compSpeed) external;
108 
109     /**
110      * @notice Set COMP speed for a single market
111      * @param cToken The market whose COMP speed to update
112      * @param compSpeed New COMP speed for market
113      */
114     function _setCompBorrowSpeed(CToken cToken, uint256 compSpeed) external;
115 
116     /**
117      * @notice Set COMP borrow and supply speeds for the specified markets.
118      * @param cTokens The markets whose COMP speed to update.
119      * @param supplySpeeds New supply-side COMP speed for the corresponding market.
120      * @param borrowSpeeds New borrow-side COMP speed for the corresponding market.
121      */
122     function _setCompSpeeds(
123         CToken[] memory cTokens,
124         uint256[] memory supplySpeeds,
125         uint256[] memory borrowSpeeds
126     ) external;
127 
128     /**
129      * @notice Set COMP speed for a single contributor
130      * @param contributor The contributor whose COMP speed to update
131      * @param compSpeed New COMP speed for contributor
132      */
133     function _setContributorCompSpeed(address contributor, uint256 compSpeed) external;
134 
135     /*** Helper Functions */
136 
137     function getBlockNumber() external view returns (uint256);
138 
139     /**
140      * @notice Returns an array of all markets.
141      */
142     function getAllMarkets() external view returns (CToken[] memory);
143 }
