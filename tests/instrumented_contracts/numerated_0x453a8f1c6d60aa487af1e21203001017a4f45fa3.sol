1 // File: contracts\Staking\StrikeStakingStorage.sol
2 
3 pragma solidity ^0.5.16;
4 
5 contract StrikeStakingProxyAdminStorage {
6     /**
7     * @notice Administrator for this contract
8     */
9     address public admin;
10 
11     /**
12     * @notice Pending administrator for this contract
13     */
14     address public pendingAdmin;
15 
16     /**
17     * @notice Active brains of StrikeStakingProxy
18     */
19     address public strikeStakingImplementation;
20 
21     /**
22     * @notice Pending brains of StrikeStakingProxy
23     */
24     address public pendingStrikeStakingImplementation;
25 }
26 
27 contract StrikeStakingG1Storage is StrikeStakingProxyAdminStorage {
28 }
29 
30 // File: contracts\Staking\StrikeStakingProxy.sol
31 
32 pragma solidity ^0.5.16;
33 /**
34  * @title StrikeStakingProxy
35  * @dev Storage for the strike staking is at this address, while execution is delegated to the `strikeStakingImplementation`.
36  */
37 contract StrikeStakingProxy is StrikeStakingProxyAdminStorage {
38 
39     /**
40       * @notice Emitted when pendingStrikeStakingImplementation is changed
41       */
42     event NewPendingImplementation(address oldPendingImplementation, address newPendingImplementation);
43 
44     /**
45       * @notice Emitted when pendingStrikeStakingImplementation is accepted, which means strikeStaking implementation is updated
46       */
47     event NewImplementation(address oldImplementation, address newImplementation);
48 
49     /**
50       * @notice Emitted when pendingAdmin is changed
51       */
52     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
53 
54     /**
55       * @notice Emitted when pendingAdmin is accepted, which means admin is updated
56       */
57     event NewAdmin(address oldAdmin, address newAdmin);
58 
59     constructor() public {
60         // Set admin to caller
61         admin = msg.sender;
62     }
63 
64     /*** Admin Functions ***/
65     function _setPendingImplementation(address newPendingImplementation) public {
66         require(msg.sender == admin, "SET_PENDING_IMPLEMENTATION_OWNER_CHECK");
67 
68         address oldPendingImplementation = pendingStrikeStakingImplementation;
69 
70         pendingStrikeStakingImplementation = newPendingImplementation;
71 
72         emit NewPendingImplementation(oldPendingImplementation, pendingStrikeStakingImplementation);
73     }
74 
75     /**
76     * @notice Accepts new implementation of strikeStaking. msg.sender must be pendingImplementation
77     * @dev Admin function for new implementation to accept it's role as implementation
78     */
79     function _acceptImplementation() public {
80         // Check caller is pendingImplementation and pendingImplementation ≠ address(0)
81         require(msg.sender == pendingStrikeStakingImplementation && pendingStrikeStakingImplementation != address(0), "ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK");
82 
83         // Save current values for inclusion in log
84         address oldImplementation = strikeStakingImplementation;
85         address oldPendingImplementation = pendingStrikeStakingImplementation;
86 
87         strikeStakingImplementation = pendingStrikeStakingImplementation;
88 
89         pendingStrikeStakingImplementation = address(0);
90 
91         emit NewImplementation(oldImplementation, strikeStakingImplementation);
92         emit NewPendingImplementation(oldPendingImplementation, pendingStrikeStakingImplementation);
93     }
94 
95     /**
96       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
97       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
98       * @param newPendingAdmin New pending admin.
99       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
100       */
101     function _setPendingAdmin(address newPendingAdmin) public {
102         require(msg.sender == admin, "SET_PENDING_ADMIN_OWNER_CHECK");
103 
104         // Save current value, if any, for inclusion in log
105         address oldPendingAdmin = pendingAdmin;
106 
107         // Store pendingAdmin with value newPendingAdmin
108         pendingAdmin = newPendingAdmin;
109 
110         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
111         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
112     }
113 
114     /**
115       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
116       * @dev Admin function for pending admin to accept role and update admin
117       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
118       */
119     function _acceptAdmin() public {
120         require(msg.sender == pendingAdmin && msg.sender == address(0), "ACCEPT_ADMIN_PENDING_ADMIN_CHECK");
121 
122         // Save current values for inclusion in log
123         address oldAdmin = admin;
124         address oldPendingAdmin = pendingAdmin;
125 
126         // Store admin with value pendingAdmin
127         admin = pendingAdmin;
128 
129         // Clear the pending value
130         pendingAdmin = address(0);
131 
132         emit NewAdmin(oldAdmin, admin);
133         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
134     }
135 
136     /**
137      * @dev Delegates execution to an implementation contract.
138      * It returns to the external caller whatever the implementation returns
139      * or forwards reverts.
140      */
141     function () external payable {
142         // delegate all other functions to current implementation
143         (bool success, ) = strikeStakingImplementation.delegatecall(msg.data);
144 
145         assembly {
146               let free_mem_ptr := mload(0x40)
147               returndatacopy(free_mem_ptr, 0, returndatasize)
148 
149               switch success
150               case 0 { revert(free_mem_ptr, returndatasize) }
151               default { return(free_mem_ptr, returndatasize) }
152         }
153     }
154 }