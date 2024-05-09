1 /**
2  *Submitted for verification at Etherscan.io on 2019-11-13
3 */
4 
5 // File: contracts/common/Validating.sol
6 
7 pragma solidity 0.5.12;
8 
9 
10 interface Validating {
11   modifier notZero(uint number) { require(number > 0, "invalid 0 value"); _; }
12   modifier notEmpty(string memory text) { require(bytes(text).length > 0, "invalid empty string"); _; }
13   modifier validAddress(address value) { require(value != address(0x0), "invalid address"); _; }
14 }
15 
16 // File: contracts/gluon/AppGovernance.sol
17 
18 pragma solidity 0.5.12;
19 
20 
21 interface AppGovernance {
22   function approve(uint32 id) external;
23   function disapprove(uint32 id) external;
24   function activate(uint32 id) external;
25 }
26 
27 // File: contracts/gluon/AppLogic.sol
28 
29 pragma solidity 0.5.12;
30 
31 
32 interface AppLogic {
33   function upgrade() external;
34   function credit(address account, address asset, uint quantity) external;
35   function debit(address account, bytes calldata parameters) external returns (address asset, uint quantity);
36 }
37 
38 // File: contracts/gluon/AppState.sol
39 
40 pragma solidity 0.5.12;
41 
42 
43 contract AppState {
44 
45   enum State { OFF, ON, RETIRED }
46   State public state = State.ON;
47   event Off();
48   event Retired();
49 
50   modifier whenOn() { require(state == State.ON, "must be on"); _; }
51   modifier whenOff() { require(state == State.OFF, "must be off"); _; }
52   modifier whenRetired() { require(state == State.RETIRED, "must be retired"); _; }
53 
54   function retire_() internal whenOn {
55     state = State.RETIRED;
56     emit Retired();
57   }
58 
59   function switchOff_() internal whenOn {
60     state = State.OFF;
61     emit Off();
62   }
63 
64   function isOn() external view returns (bool) { return state == State.ON; }
65 }
66 
67 // File: contracts/gluon/GluonView.sol
68 
69 pragma solidity 0.5.12;
70 
71 
72 interface GluonView {
73   function app(uint32 id) external view returns (address current, address proposal, uint activationBlock);
74   function current(uint32 id) external view returns (address);
75   function history(uint32 id) external view returns (address[] memory);
76   function getBalance(uint32 id, address asset) external view returns (uint);
77   function isAnyLogic(uint32 id, address logic) external view returns (bool);
78   function isAppOwner(uint32 id, address appOwner) external view returns (bool);
79   function proposals(address logic) external view returns (bool);
80   function totalAppsCount() external view returns(uint32);
81 }
82 
83 // File: contracts/gluon/GluonCentric.sol
84 
85 pragma solidity 0.5.12;
86 
87 
88 
89 contract GluonCentric {
90   uint32 internal constant REGISTRY_INDEX = 0;
91   uint32 internal constant STAKE_INDEX = 1;
92 
93   uint32 public id;
94   address public gluon;
95 
96   constructor(uint32 id_, address gluon_) public {
97     id = id_;
98     gluon = gluon_;
99   }
100 
101   modifier onlyCurrentLogic { require(currentLogic() == msg.sender, "invalid sender; must be current logic contract"); _; }
102   modifier onlyGluon { require(gluon == msg.sender, "invalid sender; must be gluon contract"); _; }
103   modifier onlyOwner { require(GluonView(gluon).isAppOwner(id, msg.sender), "invalid sender; must be app owner"); _; }
104 
105   function currentLogic() public view returns (address) { return GluonView(gluon).current(id); }
106 }
107 
108 // File: contracts/apps/registry/RegistryData.sol
109 
110 pragma solidity 0.5.12;
111 
112 
113 
114 contract RegistryData is GluonCentric {
115 
116   mapping(address => address) public accounts;
117 
118   constructor(address gluon) GluonCentric(REGISTRY_INDEX, gluon) public { }
119 
120   function addKey(address apiKey, address account) external onlyCurrentLogic {
121     accounts[apiKey] = account;
122   }
123 
124 }
125 
126 // File: contracts/gluon/Upgrading.sol
127 
128 pragma solidity 0.5.12;
129 
130 
131 
132 
133 contract Upgrading {
134   address public upgradeOperator;
135 
136   modifier onlyOwner { require(false, "modifier onlyOwner must be implemented"); _; }
137   modifier onlyUpgradeOperator { require(upgradeOperator == msg.sender, "invalid sender; must be upgrade operator"); _; }
138   function setUpgradeOperator(address upgradeOperator_) external onlyOwner { upgradeOperator = upgradeOperator_; }
139   function upgrade_(AppGovernance appGovernance, uint32 id) internal {
140     appGovernance.activate(id);
141     delete upgradeOperator;
142   }
143 }
144 
145 // File: contracts/apps/registry/RegistryLogic.sol
146 
147 pragma solidity 0.5.12;
148 
149 
150 
151 
152 
153 
154 
155 
156 
157 contract RegistryLogic is Upgrading, Validating, AppLogic, AppState, GluonCentric {
158 
159   RegistryData public data;
160   OldRegistry public old;
161 
162   event Registered(address apiKey, address indexed account);
163 
164   constructor(address gluon, address old_, address data_) GluonCentric(REGISTRY_INDEX, gluon) public {
165     data = RegistryData(data_);
166     old = OldRegistry(old_);
167   }
168 
169   modifier isAbsent(address apiKey) { require(translate(apiKey) == address (0x0), "api key already in use"); _; }
170 
171   function register(address apiKey) external whenOn validAddress(apiKey) isAbsent(apiKey) {
172     data.addKey(apiKey, msg.sender);
173     emit Registered(apiKey, msg.sender);
174   }
175 
176   function translate(address apiKey) public view returns (address) {
177     address account = data.accounts(apiKey);
178     if (account == address(0x0)) account = old.translate(apiKey);
179     return account;
180   }
181 
182   /**************************************************** AppLogic ****************************************************/
183 
184   function upgrade() external onlyUpgradeOperator {
185     retire_();
186     upgrade_(AppGovernance(gluon), id);
187   }
188 
189   function credit(address, address, uint) external { revert("not supported"); }
190 
191   function debit(address, bytes calldata) external returns (address, uint) { revert("not supported"); }
192 
193   function switchOff() external onlyOwner {
194     uint32 totalAppsCount = GluonView(gluon).totalAppsCount();
195     for (uint32 i = 2; i < totalAppsCount; i++) {
196       AppState appState = AppState(GluonView(gluon).current(i));
197       require(!appState.isOn(), "One of the apps is still ON");
198     }
199     switchOff_();
200   }
201 }
202 
203 
204 contract OldRegistry {
205   function translate(address) public view returns (address);
206 }