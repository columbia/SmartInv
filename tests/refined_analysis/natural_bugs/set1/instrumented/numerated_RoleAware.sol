1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "./Roles.sol";
5 
6 /// @title Role management behavior
7 /// Main characters are for service discovery
8 /// Whereas roles are for access control
9 contract RoleAware {
10     // we chose not to go with an enum
11     // to make this list easy to extend
12     uint256 constant FUND_TRANSFERER = 1;
13     uint256 constant MARGIN_CALLER = 2;
14     uint256 constant BORROWER = 3;
15     uint256 constant MARGIN_TRADER = 4;
16     uint256 constant FEE_SOURCE = 5;
17     uint256 constant LIQUIDATOR = 6;
18     uint256 constant AUTHORIZED_FUND_TRADER = 7;
19     uint256 constant INCENTIVE_REPORTER = 8;
20     uint256 constant TOKEN_ACTIVATOR = 9;
21     uint256 constant STAKE_PENALIZER = 10;
22 
23     uint256 constant FUND = 101;
24     uint256 constant LENDING = 102;
25     uint256 constant ROUTER = 103;
26     uint256 constant MARGIN_TRADING = 104;
27     uint256 constant FEE_CONTROLLER = 105;
28     uint256 constant PRICE_CONTROLLER = 106;
29     uint256 constant ADMIN = 107;
30     uint256 constant INCENTIVE_DISTRIBUTION = 108;
31     uint256 constant TOKEN_ADMIN = 109;
32 
33     Roles public immutable roles;
34     mapping(uint256 => address) public mainCharacterCache;
35     mapping(address => mapping(uint256 => bool)) public roleCache;
36 
37     constructor(address _roles) {
38         require(_roles != address(0), "Please provide valid roles address");
39         roles = Roles(_roles);
40     }
41 
42     modifier noIntermediary() {
43         require(
44             msg.sender == tx.origin,
45             "Currently no intermediaries allowed for this function call"
46         );
47         _;
48     }
49 
50     function updateRoleCache(uint256 role, address contr) public virtual {
51         roleCache[contr][role] = roles.getRole(role, contr);
52     }
53 
54     function updateMainCharacterCache(uint256 role) public virtual {
55         mainCharacterCache[role] = roles.mainCharacters(role);
56     }
57 
58     function fund() internal view returns (address) {
59         return mainCharacterCache[FUND];
60     }
61 
62     function lending() internal view returns (address) {
63         return mainCharacterCache[LENDING];
64     }
65 
66     function router() internal view returns (address) {
67         return mainCharacterCache[ROUTER];
68     }
69 
70     function marginTrading() internal view returns (address) {
71         return mainCharacterCache[MARGIN_TRADING];
72     }
73 
74     function feeController() internal view returns (address) {
75         return mainCharacterCache[FEE_CONTROLLER];
76     }
77 
78     function price() internal view returns (address) {
79         return mainCharacterCache[PRICE_CONTROLLER];
80     }
81 
82     function admin() internal view returns (address) {
83         return mainCharacterCache[ADMIN];
84     }
85 
86     function incentiveDistributor() internal view returns (address) {
87         return mainCharacterCache[INCENTIVE_DISTRIBUTION];
88     }
89 
90     function isBorrower(address contr) internal view returns (bool) {
91         return roleCache[contr][BORROWER];
92     }
93 
94     function isFundTransferer(address contr) internal view returns (bool) {
95         return roleCache[contr][FUND_TRANSFERER];
96     }
97 
98     function isMarginTrader(address contr) internal view returns (bool) {
99         return roleCache[contr][MARGIN_TRADER];
100     }
101 
102     function isFeeSource(address contr) internal view returns (bool) {
103         return roleCache[contr][FEE_SOURCE];
104     }
105 
106     function isMarginCaller(address contr) internal view returns (bool) {
107         return roleCache[contr][MARGIN_CALLER];
108     }
109 
110     function isLiquidator(address contr) internal view returns (bool) {
111         return roleCache[contr][LIQUIDATOR];
112     }
113 
114     function isAuthorizedFundTrader(address contr)
115         internal
116         view
117         returns (bool)
118     {
119         return roleCache[contr][AUTHORIZED_FUND_TRADER];
120     }
121 
122     function isIncentiveReporter(address contr) internal view returns (bool) {
123         return roleCache[contr][INCENTIVE_REPORTER];
124     }
125 
126     function isTokenActivator(address contr) internal view returns (bool) {
127         return roleCache[contr][TOKEN_ACTIVATOR];
128     }
129 
130     function isStakePenalizer(address contr) internal view returns (bool) {
131         return roles.getRole(STAKE_PENALIZER, contr);
132     }
133 }
