1 pragma solidity 0.4.24;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         require(a == 0 || c / a == b, "mul overflow");
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
17         uint256 c = a / b;
18         // require(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a, "sub underflow");
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "add overflow");
30         return c;
31     }
32 
33     function roundedDiv(uint a, uint b) internal pure returns (uint256) {
34         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
35         uint256 z = a / b;
36         if (a % b >= b / 2) {
37             z++;  // no need for safe add b/c it can happen only if we divided the input
38         }
39         return z;
40     }
41 }
42 
43 /*
44     Generic contract to authorise calls to certain functions only from a given address.
45     The address authorised must be a contract (multisig or not, depending on the permission), except for local test
46 
47     deployment works as:
48            1. contract deployer account deploys contracts
49            2. constructor grants "PermissionGranter" permission to deployer account
50            3. deployer account executes initial setup (no multiSig)
51            4. deployer account grants PermissionGranter permission for the MultiSig contract
52                 (e.g. StabilityBoardProxy or PreTokenProxy)
53            5. deployer account revokes its own PermissionGranter permission
54 */
55 
56 contract Restricted {
57 
58     // NB: using bytes32 rather than the string type because it's cheaper gas-wise:
59     mapping (address => mapping (bytes32 => bool)) public permissions;
60 
61     event PermissionGranted(address indexed agent, bytes32 grantedPermission);
62     event PermissionRevoked(address indexed agent, bytes32 revokedPermission);
63 
64     modifier restrict(bytes32 requiredPermission) {
65         require(permissions[msg.sender][requiredPermission], "msg.sender must have permission");
66         _;
67     }
68 
69     constructor(address permissionGranterContract) public {
70         require(permissionGranterContract != address(0), "permissionGranterContract must be set");
71         permissions[permissionGranterContract]["PermissionGranter"] = true;
72         emit PermissionGranted(permissionGranterContract, "PermissionGranter");
73     }
74 
75     function grantPermission(address agent, bytes32 requiredPermission) public {
76         require(permissions[msg.sender]["PermissionGranter"],
77             "msg.sender must have PermissionGranter permission");
78         permissions[agent][requiredPermission] = true;
79         emit PermissionGranted(agent, requiredPermission);
80     }
81 
82     function grantMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
83         require(permissions[msg.sender]["PermissionGranter"],
84             "msg.sender must have PermissionGranter permission");
85         uint256 length = requiredPermissions.length;
86         for (uint256 i = 0; i < length; i++) {
87             grantPermission(agent, requiredPermissions[i]);
88         }
89     }
90 
91     function revokePermission(address agent, bytes32 requiredPermission) public {
92         require(permissions[msg.sender]["PermissionGranter"],
93             "msg.sender must have PermissionGranter permission");
94         permissions[agent][requiredPermission] = false;
95         emit PermissionRevoked(agent, requiredPermission);
96     }
97 
98     function revokeMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
99         uint256 length = requiredPermissions.length;
100         for (uint256 i = 0; i < length; i++) {
101             revokePermission(agent, requiredPermissions[i]);
102         }
103     }
104 
105 }
106 
107 /*
108  Generic symbol / WEI rates contract.
109  only callable by trusted price oracles.
110  Being regularly called by a price oracle
111 */
112 
113 contract Rates is Restricted {
114     using SafeMath for uint256;
115 
116     struct RateInfo {
117         uint rate; // how much 1 WEI worth 1 unit , i.e. symbol/ETH rate
118                     // 0 rate means no rate info available
119         uint lastUpdated;
120     }
121 
122     // mapping currency symbol => rate. all rates are stored with 4 decimals. i.e. ETH/EUR = 989.12 then rate = 989,1200
123     mapping(bytes32 => RateInfo) public rates;
124 
125     event RateChanged(bytes32 symbol, uint newRate);
126 
127     constructor(address permissionGranterContract) public Restricted(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
128 
129     function setRate(bytes32 symbol, uint newRate) external restrict("RatesFeeder") {
130         rates[symbol] = RateInfo(newRate, now);
131         emit RateChanged(symbol, newRate);
132     }
133 
134     function setMultipleRates(bytes32[] symbols, uint[] newRates) external restrict("RatesFeeder") {
135         require(symbols.length == newRates.length, "symobls and newRates lengths must be equal");
136         for (uint256 i = 0; i < symbols.length; i++) {
137             rates[symbols[i]] = RateInfo(newRates[i], now);
138             emit RateChanged(symbols[i], newRates[i]);
139         }
140     }
141 
142     function convertFromWei(bytes32 bSymbol, uint weiValue) external view returns(uint value) {
143         require(rates[bSymbol].rate > 0, "rates[bSymbol] must be > 0");
144         return weiValue.mul(rates[bSymbol].rate).roundedDiv(1000000000000000000);
145     }
146 
147     function convertToWei(bytes32 bSymbol, uint value) external view returns(uint weiValue) {
148         // next line would revert with div by zero but require to emit reason
149         require(rates[bSymbol].rate > 0, "rates[bSymbol] must be > 0");
150         /* TODO: can we make this not loosing max scale? */
151         return value.mul(1000000000000000000).roundedDiv(rates[bSymbol].rate);
152     }
153 
154 }