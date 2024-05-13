1 pragma solidity ^0.8.0;
2 
3 import "./../staking/TribalChief.sol";
4 import "../refs/CoreRef.sol";
5 import "../fuse/rewards/IRewardsDistributorAdmin.sol";
6 import "@openzeppelin/contracts/access/Ownable.sol";
7 
8 contract MockRewardsDistributor is IRewardsDistributorAdmin, Ownable {
9     event successSetAdmin(address pendingAdmin);
10     event successAcceptPendingAdmin(address newlyAppointedAdmin);
11     event successGrantComp(address compGrantee, uint256 compAmount);
12     event successSetCompSupplySpeed();
13     event successSetCompBorrowSpeed();
14     event successSetCompContributorSpeed();
15     event successAddMarket();
16 
17     bytes32 public constant override AUTO_REWARDS_DISTRIBUTOR_ROLE = keccak256("AUTO_REWARDS_DISTRIBUTOR_ROLE");
18 
19     uint256 public compSupplySpeed;
20     uint256 public compBorrowSpeed;
21 
22     address public pendingNewAdmin;
23     address public newAdmin;
24 
25     address public implementation;
26     address public newMarket;
27 
28     address public newContributor;
29     uint256 public newCompSpeed;
30 
31     address public newCompGrantee;
32     uint256 public newCompGranteeAmount;
33 
34     constructor() Ownable() {}
35 
36     /**
37      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
38      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
39      * @param _newPendingAdmin New pending admin.
40      */
41     function _setPendingAdmin(address _newPendingAdmin) external override onlyOwner {
42         pendingNewAdmin = _newPendingAdmin;
43         emit successSetAdmin(pendingNewAdmin);
44     }
45 
46     /**
47      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
48      * @dev Admin function for pending admin to accept role and update admin
49      */
50     function _acceptAdmin() external override onlyOwner {
51         newAdmin = pendingNewAdmin;
52         pendingNewAdmin = address(0);
53         emit successAcceptPendingAdmin(newAdmin);
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
65     function _grantComp(address recipient, uint256 amount) external override onlyOwner {
66         newCompGrantee = recipient;
67         newCompGranteeAmount = amount;
68         emit successGrantComp(recipient, amount);
69     }
70 
71     /**
72      * @notice Set COMP speed for a single market
73      */
74     function _setCompSupplySpeed(
75         address, /* cToken*/
76         uint256 compSpeed
77     ) external override onlyOwner {
78         compSupplySpeed = compSpeed;
79         emit successSetCompSupplySpeed();
80     }
81 
82     /**
83      * @notice Set COMP speed for a single market
84      */
85     function _setCompBorrowSpeed(
86         address, /* cToken*/
87         uint256 compSpeed
88     ) external override onlyOwner {
89         compBorrowSpeed = compSpeed;
90         emit successSetCompBorrowSpeed();
91     }
92 
93     /**
94      * @notice Set COMP speed for a single contributor
95      * @param contributor The contributor whose COMP speed to update
96      * @param compSpeed New COMP speed for contributor
97      */
98     function _setContributorCompSpeed(address contributor, uint256 compSpeed) external override onlyOwner {
99         newContributor = contributor;
100         newCompSpeed = compSpeed;
101         emit successSetCompContributorSpeed();
102     }
103 
104     /**
105      * @notice Add a default market to claim rewards for in `claimRewards()`
106      * @param cToken The market to add
107      */
108     function _addMarket(address cToken) external override onlyOwner {
109         newMarket = cToken;
110         emit successAddMarket();
111     }
112 
113     /**
114      * @notice view function to get the comp supply speeds from the rewards distributor contract
115      */
116     function compSupplySpeeds(
117         address /* cToken*/
118     ) external view override returns (uint256) {
119         return compSupplySpeed;
120     }
121 
122     /**
123      * @notice view function to get the comp borrow speeds from the rewards distributor contract
124      */
125     function compBorrowSpeeds(
126         address /* cToken*/
127     ) external view override returns (uint256) {
128         return compBorrowSpeed;
129     }
130 
131     /// @notice admin function
132     function setCompSupplySpeed(uint256 newSpeed) external {
133         compSupplySpeed = newSpeed;
134     }
135 
136     function setCompBorrowSpeed(uint256 newSpeed) external {
137         compBorrowSpeed = newSpeed;
138     }
139 
140     /**
141      * @notice Set the implementation contract the RewardsDistributorDelegator delegate calls
142      * @param implementation_ the logic contract address
143      */
144     function _setImplementation(address implementation_) external override onlyOwner {
145         implementation = implementation_;
146     }
147 }
