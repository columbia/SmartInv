1 pragma solidity ^0.8.0;
2 
3 import "../../refs/CoreRef.sol";
4 import "./IRewardsDistributorAdmin.sol";
5 import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
6 
7 /// @notice this contract has its own internal ACL. The reasons for doing this
8 /// and not leveraging core are twofold. One, it simplifies devops operations around adding
9 /// and removing users, and two, by being self contained, it is more efficient as it does not need
10 /// to make external calls to figure out who has a particular role.
11 contract RewardsDistributorAdmin is IRewardsDistributorAdmin, CoreRef, AccessControlEnumerable {
12     /// @notice auto rewards distributor controller role.
13     /// This role will be given to auto rewards distributor controller smart contracts
14     bytes32 public constant override AUTO_REWARDS_DISTRIBUTOR_ROLE = keccak256("AUTO_REWARDS_DISTRIBUTOR_ROLE");
15 
16     /// @notice rewards distributor contract
17     IRewardsDistributorAdmin public rewardsDistributorContract;
18 
19     /// @param coreAddress address of core contract
20     /// @param _rewardsDistributorContract admin rewards distributor contract
21     /// @param _autoRewardDistributors list of auto rewards distributor contracts that can call this contract
22     constructor(
23         address coreAddress,
24         IRewardsDistributorAdmin _rewardsDistributorContract,
25         address[] memory _autoRewardDistributors
26     ) CoreRef(coreAddress) {
27         rewardsDistributorContract = _rewardsDistributorContract;
28         /// @notice The reason we are reusing the tribal chief admin role is it consolidates control in the OA,
29         /// and means we don't have to do another governance action to create this role in core
30         _setContractAdminRole(keccak256("TRIBAL_CHIEF_ADMIN_ROLE"));
31         _setRoleAdmin(AUTO_REWARDS_DISTRIBUTOR_ROLE, DEFAULT_ADMIN_ROLE);
32 
33         /// give all AutoRewardsDistributor contracts the proper role so that they can set borrow and supply speeds
34         for (uint256 i = 0; i < _autoRewardDistributors.length; i++) {
35             _setupRole(AUTO_REWARDS_DISTRIBUTOR_ROLE, _autoRewardDistributors[i]);
36         }
37     }
38 
39     /**
40      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
41      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
42      * @param newPendingAdmin New pending admin.
43      */
44     function _setPendingAdmin(address newPendingAdmin) external override onlyGovernor {
45         rewardsDistributorContract._setPendingAdmin(newPendingAdmin);
46     }
47 
48     /**
49      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
50      * @dev Admin function for pending admin to accept role and update admin
51      */
52     function _acceptAdmin() external override {
53         rewardsDistributorContract._acceptAdmin();
54     }
55 
56     /*** Comp Distribution ***/
57     /*** Comp Distribution Admin ***/
58 
59     /**
60      * @notice Transfer COMP to the recipient
61      * @dev Note: If there is not enough COMP, we do not perform the transfer all.
62      * @param recipient The address of the recipient to transfer COMP to
63      * @param amount The amount of COMP to (possibly) transfer
64      */
65     function _grantComp(address recipient, uint256 amount) external override onlyGovernor {
66         rewardsDistributorContract._grantComp(recipient, amount);
67     }
68 
69     /**
70      * @notice Set COMP speed for a single market.
71      * Callable only by users with auto rewards distributor role
72      * @param cToken The market whose COMP speed to update
73      */
74     function _setCompSupplySpeed(address cToken, uint256 compSpeed)
75         external
76         override
77         onlyRole(AUTO_REWARDS_DISTRIBUTOR_ROLE)
78         whenNotPaused
79     {
80         rewardsDistributorContract._setCompSupplySpeed(cToken, compSpeed);
81     }
82 
83     /**
84      * @notice Set COMP speed for a single market
85      * Callable only by users with auto rewards distributor role
86      * @param cToken The market whose COMP speed to update
87      */
88     function _setCompBorrowSpeed(address cToken, uint256 compSpeed)
89         external
90         override
91         onlyRole(AUTO_REWARDS_DISTRIBUTOR_ROLE)
92         whenNotPaused
93     {
94         rewardsDistributorContract._setCompBorrowSpeed(cToken, compSpeed);
95     }
96 
97     /**
98      * @notice Set COMP supply speed for a single market to 0
99      * Callable only by the guardian or governor
100      * @param cToken The market whose COMP speed to set to 0
101      */
102     function guardianDisableSupplySpeed(address cToken) external onlyGuardianOrGovernor {
103         rewardsDistributorContract._setCompSupplySpeed(cToken, 0);
104     }
105 
106     /**
107      * @notice Set COMP borrow speed for a single market to 0
108      * Callable only by the guardian or governor
109      * @param cToken The market whose COMP speed to set to 0
110      */
111     function guardianDisableBorrowSpeed(address cToken) external onlyGuardianOrGovernor {
112         rewardsDistributorContract._setCompBorrowSpeed(cToken, 0);
113     }
114 
115     /**
116      * @notice Set COMP speed for a single contributor
117      * @param contributor The contributor whose COMP speed to update
118      * @param compSpeed New COMP speed for contributor
119      */
120     function _setContributorCompSpeed(address contributor, uint256 compSpeed) external override onlyGovernorOrAdmin {
121         rewardsDistributorContract._setContributorCompSpeed(contributor, compSpeed);
122     }
123 
124     /**
125      * @notice Add a default market to claim rewards for in `claimRewards()`
126      * @param cToken The market to add
127      */
128     function _addMarket(address cToken) external override onlyGovernorOrAdmin {
129         rewardsDistributorContract._addMarket(cToken);
130     }
131 
132     /**
133      * @notice Set the implementation contract the RewardsDistributorDelegator delegate calls
134      * @param implementation_ the logic contract address
135      */
136     function _setImplementation(address implementation_) external override onlyGovernor {
137         rewardsDistributorContract._setImplementation(implementation_);
138     }
139 
140     /**
141      * @notice view function to get the comp supply speeds from the rewards distributor contract
142      * @param cToken The market to view
143      */
144     function compSupplySpeeds(address cToken) external view override returns (uint256) {
145         return rewardsDistributorContract.compSupplySpeeds(cToken);
146     }
147 
148     /**
149      * @notice view function to get the comp borrow speeds from the rewards distributor contract
150      * @param cToken The market to view
151      */
152     function compBorrowSpeeds(address cToken) external view override returns (uint256) {
153         return rewardsDistributorContract.compBorrowSpeeds(cToken);
154     }
155 
156     /**
157      * @notice allow admin or governor to assume auto reward distributor admin role
158      */
159     function becomeAdmin() public onlyGovernorOrAdmin {
160         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
161     }
162 }
