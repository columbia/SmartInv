1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./ICoreRef.sol";
5 import "@openzeppelin/contracts/security/Pausable.sol";
6 
7 /// @title A Reference to Core
8 /// @author Fei Protocol
9 /// @notice defines some modifiers and utilities around interacting with Core
10 abstract contract CoreRef is ICoreRef, Pausable {
11     ICore private immutable _core;
12     IFei private immutable _fei;
13     IERC20 private immutable _tribe;
14 
15     /// @notice a role used with a subset of governor permissions for this contract only
16     bytes32 public override CONTRACT_ADMIN_ROLE;
17 
18     constructor(address coreAddress) {
19         _core = ICore(coreAddress);
20 
21         _fei = ICore(coreAddress).fei();
22         _tribe = ICore(coreAddress).tribe();
23 
24         _setContractAdminRole(ICore(coreAddress).GOVERN_ROLE());
25     }
26 
27     function _initialize(address) internal {} // no-op for backward compatibility
28 
29     modifier ifMinterSelf() {
30         if (_core.isMinter(address(this))) {
31             _;
32         }
33     }
34 
35     modifier onlyMinter() {
36         require(_core.isMinter(msg.sender), "CoreRef: Caller is not a minter");
37         _;
38     }
39 
40     modifier onlyBurner() {
41         require(_core.isBurner(msg.sender), "CoreRef: Caller is not a burner");
42         _;
43     }
44 
45     modifier onlyPCVController() {
46         require(_core.isPCVController(msg.sender), "CoreRef: Caller is not a PCV controller");
47         _;
48     }
49 
50     modifier onlyGovernorOrAdmin() {
51         require(
52             _core.isGovernor(msg.sender) || isContractAdmin(msg.sender),
53             "CoreRef: Caller is not a governor or contract admin"
54         );
55         _;
56     }
57 
58     modifier onlyGovernor() {
59         require(_core.isGovernor(msg.sender), "CoreRef: Caller is not a governor");
60         _;
61     }
62 
63     modifier onlyGuardianOrGovernor() {
64         require(
65             _core.isGovernor(msg.sender) || _core.isGuardian(msg.sender),
66             "CoreRef: Caller is not a guardian or governor"
67         );
68         _;
69     }
70 
71     modifier isGovernorOrGuardianOrAdmin() {
72         require(
73             _core.isGovernor(msg.sender) || _core.isGuardian(msg.sender) || isContractAdmin(msg.sender),
74             "CoreRef: Caller is not governor or guardian or admin"
75         );
76         _;
77     }
78 
79     // Named onlyTribeRole to prevent collision with OZ onlyRole modifier
80     modifier onlyTribeRole(bytes32 role) {
81         require(_core.hasRole(role, msg.sender), "UNAUTHORIZED");
82         _;
83     }
84 
85     // Modifiers to allow any combination of roles
86     modifier hasAnyOfTwoRoles(bytes32 role1, bytes32 role2) {
87         require(_core.hasRole(role1, msg.sender) || _core.hasRole(role2, msg.sender), "UNAUTHORIZED");
88         _;
89     }
90 
91     modifier hasAnyOfThreeRoles(
92         bytes32 role1,
93         bytes32 role2,
94         bytes32 role3
95     ) {
96         require(
97             _core.hasRole(role1, msg.sender) || _core.hasRole(role2, msg.sender) || _core.hasRole(role3, msg.sender),
98             "UNAUTHORIZED"
99         );
100         _;
101     }
102 
103     modifier hasAnyOfFourRoles(
104         bytes32 role1,
105         bytes32 role2,
106         bytes32 role3,
107         bytes32 role4
108     ) {
109         require(
110             _core.hasRole(role1, msg.sender) ||
111                 _core.hasRole(role2, msg.sender) ||
112                 _core.hasRole(role3, msg.sender) ||
113                 _core.hasRole(role4, msg.sender),
114             "UNAUTHORIZED"
115         );
116         _;
117     }
118 
119     modifier hasAnyOfFiveRoles(
120         bytes32 role1,
121         bytes32 role2,
122         bytes32 role3,
123         bytes32 role4,
124         bytes32 role5
125     ) {
126         require(
127             _core.hasRole(role1, msg.sender) ||
128                 _core.hasRole(role2, msg.sender) ||
129                 _core.hasRole(role3, msg.sender) ||
130                 _core.hasRole(role4, msg.sender) ||
131                 _core.hasRole(role5, msg.sender),
132             "UNAUTHORIZED"
133         );
134         _;
135     }
136 
137     modifier hasAnyOfSixRoles(
138         bytes32 role1,
139         bytes32 role2,
140         bytes32 role3,
141         bytes32 role4,
142         bytes32 role5,
143         bytes32 role6
144     ) {
145         require(
146             _core.hasRole(role1, msg.sender) ||
147                 _core.hasRole(role2, msg.sender) ||
148                 _core.hasRole(role3, msg.sender) ||
149                 _core.hasRole(role4, msg.sender) ||
150                 _core.hasRole(role5, msg.sender) ||
151                 _core.hasRole(role6, msg.sender),
152             "UNAUTHORIZED"
153         );
154         _;
155     }
156 
157     modifier onlyFei() {
158         require(msg.sender == address(_fei), "CoreRef: Caller is not FEI");
159         _;
160     }
161 
162     /// @notice sets a new admin role for this contract
163     function setContractAdminRole(bytes32 newContractAdminRole) external override onlyGovernor {
164         _setContractAdminRole(newContractAdminRole);
165     }
166 
167     /// @notice returns whether a given address has the admin role for this contract
168     function isContractAdmin(address _admin) public view override returns (bool) {
169         return _core.hasRole(CONTRACT_ADMIN_ROLE, _admin);
170     }
171 
172     /// @notice set pausable methods to paused
173     function pause() public override onlyGuardianOrGovernor {
174         _pause();
175     }
176 
177     /// @notice set pausable methods to unpaused
178     function unpause() public override onlyGuardianOrGovernor {
179         _unpause();
180     }
181 
182     /// @notice address of the Core contract referenced
183     /// @return ICore implementation address
184     function core() public view override returns (ICore) {
185         return _core;
186     }
187 
188     /// @notice address of the Fei contract referenced by Core
189     /// @return IFei implementation address
190     function fei() public view override returns (IFei) {
191         return _fei;
192     }
193 
194     /// @notice address of the Tribe contract referenced by Core
195     /// @return IERC20 implementation address
196     function tribe() public view override returns (IERC20) {
197         return _tribe;
198     }
199 
200     /// @notice fei balance of contract
201     /// @return fei amount held
202     function feiBalance() public view override returns (uint256) {
203         return _fei.balanceOf(address(this));
204     }
205 
206     /// @notice tribe balance of contract
207     /// @return tribe amount held
208     function tribeBalance() public view override returns (uint256) {
209         return _tribe.balanceOf(address(this));
210     }
211 
212     function _burnFeiHeld() internal {
213         _fei.burn(feiBalance());
214     }
215 
216     function _mintFei(address to, uint256 amount) internal virtual {
217         if (amount != 0) {
218             _fei.mint(to, amount);
219         }
220     }
221 
222     function _setContractAdminRole(bytes32 newContractAdminRole) internal {
223         bytes32 oldContractAdminRole = CONTRACT_ADMIN_ROLE;
224         CONTRACT_ADMIN_ROLE = newContractAdminRole;
225         emit ContractAdminRoleUpdate(oldContractAdminRole, newContractAdminRole);
226     }
227 }
