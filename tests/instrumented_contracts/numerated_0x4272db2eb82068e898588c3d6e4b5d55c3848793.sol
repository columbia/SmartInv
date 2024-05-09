1 // File: contracts/generic/Restricted.sol
2 
3 /*
4     Generic contract to authorise calls to certain functions only from a given address.
5     The address authorised must be a contract (multisig or not, depending on the permission), except for local test
6 
7     deployment works as:
8            1. contract deployer account deploys contracts
9            2. constructor grants "PermissionGranter" permission to deployer account
10            3. deployer account executes initial setup (no multiSig)
11            4. deployer account grants PermissionGranter permission for the MultiSig contract
12                 (e.g. StabilityBoardProxy or PreTokenProxy)
13            5. deployer account revokes its own PermissionGranter permission
14 */
15 
16 pragma solidity 0.4.24;
17 
18 
19 contract Restricted {
20 
21     // NB: using bytes32 rather than the string type because it's cheaper gas-wise:
22     mapping (address => mapping (bytes32 => bool)) public permissions;
23 
24     event PermissionGranted(address indexed agent, bytes32 grantedPermission);
25     event PermissionRevoked(address indexed agent, bytes32 revokedPermission);
26 
27     modifier restrict(bytes32 requiredPermission) {
28         require(permissions[msg.sender][requiredPermission], "msg.sender must have permission");
29         _;
30     }
31 
32     constructor(address permissionGranterContract) public {
33         require(permissionGranterContract != address(0), "permissionGranterContract must be set");
34         permissions[permissionGranterContract]["PermissionGranter"] = true;
35         emit PermissionGranted(permissionGranterContract, "PermissionGranter");
36     }
37 
38     function grantPermission(address agent, bytes32 requiredPermission) public {
39         require(permissions[msg.sender]["PermissionGranter"],
40             "msg.sender must have PermissionGranter permission");
41         permissions[agent][requiredPermission] = true;
42         emit PermissionGranted(agent, requiredPermission);
43     }
44 
45     function grantMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
46         require(permissions[msg.sender]["PermissionGranter"],
47             "msg.sender must have PermissionGranter permission");
48         uint256 length = requiredPermissions.length;
49         for (uint256 i = 0; i < length; i++) {
50             grantPermission(agent, requiredPermissions[i]);
51         }
52     }
53 
54     function revokePermission(address agent, bytes32 requiredPermission) public {
55         require(permissions[msg.sender]["PermissionGranter"],
56             "msg.sender must have PermissionGranter permission");
57         permissions[agent][requiredPermission] = false;
58         emit PermissionRevoked(agent, requiredPermission);
59     }
60 
61     function revokeMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
62         uint256 length = requiredPermissions.length;
63         for (uint256 i = 0; i < length; i++) {
64             revokePermission(agent, requiredPermissions[i]);
65         }
66     }
67 
68 }
69 
70 // File: contracts/generic/SafeMath.sol
71 
72 /**
73 * @title SafeMath
74 * @dev Math operations with safety checks that throw on error
75 
76     TODO: check against ds-math: https://blog.dapphub.com/ds-math/
77     TODO: move roundedDiv to a sep lib? (eg. Math.sol)
78     TODO: more unit tests!
79 */
80 pragma solidity 0.4.24;
81 
82 
83 library SafeMath {
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a * b;
86         require(a == 0 || c / a == b, "mul overflow");
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
92         uint256 c = a / b;
93         // require(a == b * c + a % b); // There is no case in which this doesn't hold
94         return c;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b <= a, "sub underflow");
99         return a - b;
100     }
101 
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "add overflow");
105         return c;
106     }
107 
108     // Division, round to nearest integer, round half up
109     function roundedDiv(uint256 a, uint256 b) internal pure returns (uint256) {
110         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
111         uint256 halfB = (b % 2 == 0) ? (b / 2) : (b / 2 + 1);
112         return (a % b >= halfB) ? (a / b + 1) : (a / b);
113     }
114 
115     // Division, always rounds up
116     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
117         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
118         return (a % b != 0) ? (a / b + 1) : (a / b);
119     }
120 
121     function min(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a < b ? a : b;
123     }
124 
125     function max(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a < b ? b : a;
127     }    
128 }
129 
130 // File: contracts/Rates.sol
131 
132 /*
133  Generic symbol / WEI rates contract.
134  only callable by trusted price oracles.
135  Being regularly called by a price oracle
136     TODO: trustless/decentrilezed price Oracle
137     TODO: shall we use blockNumber instead of now for lastUpdated?
138     TODO: consider if we need storing rates with variable decimals instead of fixed 4
139     TODO: could we emit 1 RateChanged event from setMultipleRates (symbols and newrates arrays)?
140 */
141 pragma solidity 0.4.24;
142 
143 
144 
145 
146 contract Rates is Restricted {
147     using SafeMath for uint256;
148 
149     struct RateInfo {
150         uint rate; // how much 1 WEI worth 1 unit , i.e. symbol/ETH rate
151                     // 0 rate means no rate info available
152         uint lastUpdated;
153     }
154 
155     // mapping currency symbol => rate. all rates are stored with 2 decimals. i.e. EUR/ETH = 989.12 then rate = 98912
156     mapping(bytes32 => RateInfo) public rates;
157 
158     event RateChanged(bytes32 symbol, uint newRate);
159 
160     constructor(address permissionGranterContract) public Restricted(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
161 
162     function setRate(bytes32 symbol, uint newRate) external restrict("RatesFeeder") {
163         rates[symbol] = RateInfo(newRate, now);
164         emit RateChanged(symbol, newRate);
165     }
166 
167     function setMultipleRates(bytes32[] symbols, uint[] newRates) external restrict("RatesFeeder") {
168         require(symbols.length == newRates.length, "symobls and newRates lengths must be equal");
169         for (uint256 i = 0; i < symbols.length; i++) {
170             rates[symbols[i]] = RateInfo(newRates[i], now);
171             emit RateChanged(symbols[i], newRates[i]);
172         }
173     }
174 
175     function convertFromWei(bytes32 bSymbol, uint weiValue) external view returns(uint value) {
176         require(rates[bSymbol].rate > 0, "rates[bSymbol] must be > 0");
177         return weiValue.mul(rates[bSymbol].rate).roundedDiv(1000000000000000000);
178     }
179 
180     function convertToWei(bytes32 bSymbol, uint value) external view returns(uint weiValue) {
181         // next line would revert with div by zero but require to emit reason
182         require(rates[bSymbol].rate > 0, "rates[bSymbol] must be > 0");
183         /* TODO: can we make this not loosing max scale? */
184         return value.mul(1000000000000000000).roundedDiv(rates[bSymbol].rate);
185     }
186 
187 }