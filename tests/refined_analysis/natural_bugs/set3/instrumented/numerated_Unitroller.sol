1 pragma solidity ^0.5.16;
2 
3 import "./ErrorReporter.sol";
4 import "./ComptrollerStorage.sol";
5 
6 /**
7  * @title ComptrollerCore
8  * @dev Storage for the comptroller is at this address, while execution is delegated to the `comptrollerImplementation`.
9  * CTokens should reference this contract as their comptroller.
10  */
11 contract Unitroller is UnitrollerAdminStorage, ComptrollerErrorReporter {
12     /**
13      * @notice Emitted when pendingComptrollerImplementation is changed
14      */
15     event NewPendingImplementation(address oldPendingImplementation, address newPendingImplementation);
16 
17     /**
18      * @notice Emitted when pendingComptrollerImplementation is accepted, which means comptroller implementation is updated
19      */
20     event NewImplementation(address oldImplementation, address newImplementation);
21 
22     /**
23      * @notice Emitted when pendingAdmin is changed
24      */
25     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
26 
27     /**
28      * @notice Emitted when pendingAdmin is accepted, which means admin is updated
29      */
30     event NewAdmin(address oldAdmin, address newAdmin);
31 
32     constructor() public {
33         // Set admin to caller
34         admin = msg.sender;
35     }
36 
37     /*** Admin Functions ***/
38     function _setPendingImplementation(address newPendingImplementation) public returns (uint256) {
39         if (msg.sender != admin) {
40             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_IMPLEMENTATION_OWNER_CHECK);
41         }
42 
43         address oldPendingImplementation = pendingComptrollerImplementation;
44 
45         pendingComptrollerImplementation = newPendingImplementation;
46 
47         emit NewPendingImplementation(oldPendingImplementation, pendingComptrollerImplementation);
48 
49         return uint256(Error.NO_ERROR);
50     }
51 
52     /**
53      * @notice Accepts new implementation of comptroller. msg.sender must be pendingImplementation
54      * @dev Admin function for new implementation to accept it's role as implementation
55      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
56      */
57     function _acceptImplementation() public returns (uint256) {
58         // Check caller is pendingImplementation and pendingImplementation ≠ address(0)
59         if (msg.sender != pendingComptrollerImplementation || pendingComptrollerImplementation == address(0)) {
60             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK);
61         }
62 
63         // Save current values for inclusion in log
64         address oldImplementation = comptrollerImplementation;
65         address oldPendingImplementation = pendingComptrollerImplementation;
66 
67         comptrollerImplementation = pendingComptrollerImplementation;
68 
69         pendingComptrollerImplementation = address(0);
70 
71         emit NewImplementation(oldImplementation, comptrollerImplementation);
72         emit NewPendingImplementation(oldPendingImplementation, pendingComptrollerImplementation);
73 
74         return uint256(Error.NO_ERROR);
75     }
76 
77     /**
78      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
79      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
80      * @param newPendingAdmin New pending admin.
81      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
82      */
83     function _setPendingAdmin(address newPendingAdmin) public returns (uint256) {
84         // Check caller = admin
85         if (msg.sender != admin) {
86             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
87         }
88 
89         // Save current value, if any, for inclusion in log
90         address oldPendingAdmin = pendingAdmin;
91 
92         // Store pendingAdmin with value newPendingAdmin
93         pendingAdmin = newPendingAdmin;
94 
95         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
96         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
97 
98         return uint256(Error.NO_ERROR);
99     }
100 
101     /**
102      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
103      * @dev Admin function for pending admin to accept role and update admin
104      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
105      */
106     function _acceptAdmin() public returns (uint256) {
107         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
108         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
109             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
110         }
111 
112         // Save current values for inclusion in log
113         address oldAdmin = admin;
114         address oldPendingAdmin = pendingAdmin;
115 
116         // Store admin with value pendingAdmin
117         admin = pendingAdmin;
118 
119         // Clear the pending value
120         pendingAdmin = address(0);
121 
122         emit NewAdmin(oldAdmin, admin);
123         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
124 
125         return uint256(Error.NO_ERROR);
126     }
127 
128     /**
129      * @dev Delegates execution to an implementation contract.
130      * It returns to the external caller whatever the implementation returns
131      * or forwards reverts.
132      */
133     function() external payable {
134         // delegate all other functions to current implementation
135         (bool success, ) = comptrollerImplementation.delegatecall(msg.data);
136 
137         assembly {
138             let free_mem_ptr := mload(0x40)
139             returndatacopy(free_mem_ptr, 0, returndatasize)
140 
141             switch success
142             case 0 {
143                 revert(free_mem_ptr, returndatasize)
144             }
145             default {
146                 return(free_mem_ptr, returndatasize)
147             }
148         }
149     }
150 }
