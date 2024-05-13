1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
5 import "./IPermissions.sol";
6 
7 /// @title Access control module for Core
8 /// @author Fei Protocol
9 contract Permissions is IPermissions, AccessControlEnumerable {
10     bytes32 public constant override BURNER_ROLE = keccak256("BURNER_ROLE");
11     bytes32 public constant override MINTER_ROLE = keccak256("MINTER_ROLE");
12     bytes32 public constant override PCV_CONTROLLER_ROLE = keccak256("PCV_CONTROLLER_ROLE");
13     bytes32 public constant override GOVERN_ROLE = keccak256("GOVERN_ROLE");
14     bytes32 public constant override GUARDIAN_ROLE = keccak256("GUARDIAN_ROLE");
15 
16     constructor() {
17         // Appointed as a governor so guardian can have indirect access to revoke ability
18         _setupGovernor(address(this));
19 
20         _setRoleAdmin(MINTER_ROLE, GOVERN_ROLE);
21         _setRoleAdmin(BURNER_ROLE, GOVERN_ROLE);
22         _setRoleAdmin(PCV_CONTROLLER_ROLE, GOVERN_ROLE);
23         _setRoleAdmin(GOVERN_ROLE, GOVERN_ROLE);
24         _setRoleAdmin(GUARDIAN_ROLE, GOVERN_ROLE);
25     }
26 
27     modifier onlyGovernor() {
28         require(isGovernor(msg.sender), "Permissions: Caller is not a governor");
29         _;
30     }
31 
32     modifier onlyGuardian() {
33         require(isGuardian(msg.sender), "Permissions: Caller is not a guardian");
34         _;
35     }
36 
37     /// @notice creates a new role to be maintained
38     /// @param role the new role id
39     /// @param adminRole the admin role id for `role`
40     /// @dev can also be used to update admin of existing role
41     function createRole(bytes32 role, bytes32 adminRole) external override onlyGovernor {
42         _setRoleAdmin(role, adminRole);
43     }
44 
45     /// @notice grants minter role to address
46     /// @param minter new minter
47     function grantMinter(address minter) external override onlyGovernor {
48         grantRole(MINTER_ROLE, minter);
49     }
50 
51     /// @notice grants burner role to address
52     /// @param burner new burner
53     function grantBurner(address burner) external override onlyGovernor {
54         grantRole(BURNER_ROLE, burner);
55     }
56 
57     /// @notice grants controller role to address
58     /// @param pcvController new controller
59     function grantPCVController(address pcvController) external override onlyGovernor {
60         grantRole(PCV_CONTROLLER_ROLE, pcvController);
61     }
62 
63     /// @notice grants governor role to address
64     /// @param governor new governor
65     function grantGovernor(address governor) external override onlyGovernor {
66         grantRole(GOVERN_ROLE, governor);
67     }
68 
69     /// @notice grants guardian role to address
70     /// @param guardian new guardian
71     function grantGuardian(address guardian) external override onlyGovernor {
72         grantRole(GUARDIAN_ROLE, guardian);
73     }
74 
75     /// @notice revokes minter role from address
76     /// @param minter ex minter
77     function revokeMinter(address minter) external override onlyGovernor {
78         revokeRole(MINTER_ROLE, minter);
79     }
80 
81     /// @notice revokes burner role from address
82     /// @param burner ex burner
83     function revokeBurner(address burner) external override onlyGovernor {
84         revokeRole(BURNER_ROLE, burner);
85     }
86 
87     /// @notice revokes pcvController role from address
88     /// @param pcvController ex pcvController
89     function revokePCVController(address pcvController) external override onlyGovernor {
90         revokeRole(PCV_CONTROLLER_ROLE, pcvController);
91     }
92 
93     /// @notice revokes governor role from address
94     /// @param governor ex governor
95     function revokeGovernor(address governor) external override onlyGovernor {
96         revokeRole(GOVERN_ROLE, governor);
97     }
98 
99     /// @notice revokes guardian role from address
100     /// @param guardian ex guardian
101     function revokeGuardian(address guardian) external override onlyGovernor {
102         revokeRole(GUARDIAN_ROLE, guardian);
103     }
104 
105     /// @notice revokes a role from address
106     /// @param role the role to revoke
107     /// @param account the address to revoke the role from
108     function revokeOverride(bytes32 role, address account) external override onlyGuardian {
109         require(role != GOVERN_ROLE, "Permissions: Guardian cannot revoke governor");
110 
111         // External call because this contract is appointed as a governor and has access to revoke
112         this.revokeRole(role, account);
113     }
114 
115     /// @notice checks if address is a minter
116     /// @param _address address to check
117     /// @return true _address is a minter
118     function isMinter(address _address) external view override returns (bool) {
119         return hasRole(MINTER_ROLE, _address);
120     }
121 
122     /// @notice checks if address is a burner
123     /// @param _address address to check
124     /// @return true _address is a burner
125     function isBurner(address _address) external view override returns (bool) {
126         return hasRole(BURNER_ROLE, _address);
127     }
128 
129     /// @notice checks if address is a controller
130     /// @param _address address to check
131     /// @return true _address is a controller
132     function isPCVController(address _address) external view override returns (bool) {
133         return hasRole(PCV_CONTROLLER_ROLE, _address);
134     }
135 
136     /// @notice checks if address is a governor
137     /// @param _address address to check
138     /// @return true _address is a governor
139     // only virtual for testing mock override
140     function isGovernor(address _address) public view virtual override returns (bool) {
141         return hasRole(GOVERN_ROLE, _address);
142     }
143 
144     /// @notice checks if address is a guardian
145     /// @param _address address to check
146     /// @return true _address is a guardian
147     function isGuardian(address _address) public view override returns (bool) {
148         return hasRole(GUARDIAN_ROLE, _address);
149     }
150 
151     function _setupGovernor(address governor) internal {
152         _setupRole(GOVERN_ROLE, governor);
153     }
154 }
