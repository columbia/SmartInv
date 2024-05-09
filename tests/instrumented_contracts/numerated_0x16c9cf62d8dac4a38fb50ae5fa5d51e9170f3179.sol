1 pragma solidity 0.5.12;
2 
3 contract Proxy {
4     function() external payable {
5         _fallback();
6     }
7 
8     function _implementation() internal view returns (address);
9 
10     function _delegate(address implementation) internal {
11         assembly {
12             calldatacopy(0, 0, calldatasize)
13 
14             let result := delegatecall(
15                 gas,
16                 implementation,
17                 0,
18                 calldatasize,
19                 0,
20                 0
21             )
22             returndatacopy(0, 0, returndatasize)
23 
24             switch result
25                 case 0 {
26                     revert(0, returndatasize)
27                 }
28                 default {
29                     return(0, returndatasize)
30                 }
31         }
32     }
33 
34     function _willFallback() internal {}
35 
36     function _fallback() internal {
37         _willFallback();
38         _delegate(_implementation());
39     }
40 }
41 
42 library AddressUtils {
43     function isContract(address addr) internal view returns (bool) {
44         uint256 size;
45 
46         assembly {
47             size := extcodesize(addr)
48         }
49         return size > 0;
50     }
51 }
52 
53 contract UpgradeabilityProxy is Proxy {
54     event Upgraded(address implementation);
55 
56     bytes32
57         private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
58 
59     constructor(address _implementation) public {
60         assert(
61             IMPLEMENTATION_SLOT ==
62                 keccak256("org.zeppelinos.proxy.implementation")
63         );
64 
65         _setImplementation(_implementation);
66     }
67 
68     function _implementation() internal view returns (address impl) {
69         bytes32 slot = IMPLEMENTATION_SLOT;
70         assembly {
71             impl := sload(slot)
72         }
73     }
74 
75     function _upgradeTo(address newImplementation) internal {
76         _setImplementation(newImplementation);
77         emit Upgraded(newImplementation);
78     }
79 
80     function _setImplementation(address newImplementation) private {
81         require(
82             AddressUtils.isContract(newImplementation),
83             "Cannot set a proxy implementation to a non-contract address"
84         );
85 
86         bytes32 slot = IMPLEMENTATION_SLOT;
87 
88         assembly {
89             sstore(slot, newImplementation)
90         }
91     }
92 }
93 
94 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
95     event AdminChanged(address previousAdmin, address newAdmin);
96     event AdminUpdated(address newAdmin);
97 
98     bytes32
99         private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
100     bytes32
101         private constant PENDING_ADMIN_SLOT = 0x54ac2bd5363dfe95a011c5b5a153968d77d153d212e900afce8624fdad74525c;
102 
103     modifier ifAdmin() {
104         if (msg.sender == _admin()) {
105             _;
106         } else {
107             _fallback();
108         }
109     }
110 
111     constructor(address _implementation)
112         public
113         UpgradeabilityProxy(_implementation)
114     {
115         assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
116 
117         _setAdmin(msg.sender);
118     }
119 
120     function admin() external ifAdmin returns (address) {
121         return _admin();
122     }
123 
124     function pendingAdmin() external ifAdmin returns (address) {
125         return _pendingAdmin();
126     }
127 
128     function implementation() external ifAdmin returns (address) {
129         return _implementation();
130     }
131 
132     function changeAdmin(address _newAdmin) external ifAdmin {
133         require(
134             _newAdmin != address(0),
135             "Cannot change the admin of a proxy to the zero address"
136         );
137         require(
138             _newAdmin != _admin(),
139             "The current and new admin cannot be the same ."
140         );
141         require(
142             _newAdmin != _pendingAdmin(),
143             "Cannot set the newAdmin of a proxy to the same address ."
144         );
145         _setPendingAdmin(_newAdmin);
146         emit AdminChanged(_admin(), _newAdmin);
147     }
148 
149     function updateAdmin() external {
150         address _newAdmin = _pendingAdmin();
151         require(
152             _newAdmin != address(0),
153             "Cannot change the admin of a proxy to the zero address"
154         );
155         require(
156             msg.sender == _newAdmin,
157             "msg.sender and newAdmin must be the same ."
158         );
159         _setAdmin(_newAdmin);
160         _setPendingAdmin(address(0));
161         emit AdminUpdated(_newAdmin);
162     }
163 
164     function upgradeTo(address newImplementation) external ifAdmin {
165         _upgradeTo(newImplementation);
166     }
167 
168     function upgradeToAndCall(address newImplementation, bytes calldata data)
169         external
170         payable
171         ifAdmin
172     {
173         _upgradeTo(newImplementation);
174         (bool success, ) = address(this).call.value(msg.value)(data);
175         require(success, "upgradeToAndCall-error");
176     }
177 
178     function _admin() internal view returns (address adm) {
179         bytes32 slot = ADMIN_SLOT;
180         assembly {
181             adm := sload(slot)
182         }
183     }
184 
185     function _pendingAdmin() internal view returns (address pendingAdm) {
186         bytes32 slot = PENDING_ADMIN_SLOT;
187         assembly {
188             pendingAdm := sload(slot)
189         }
190     }
191 
192     function _setAdmin(address newAdmin) internal {
193         bytes32 slot = ADMIN_SLOT;
194 
195         assembly {
196             sstore(slot, newAdmin)
197         }
198     }
199 
200     function _setPendingAdmin(address pendingAdm) internal {
201         bytes32 slot = PENDING_ADMIN_SLOT;
202 
203         assembly {
204             sstore(slot, pendingAdm)
205         }
206     }
207 
208     function _willFallback() internal {
209         require(
210             msg.sender != _admin(),
211             "Cannot call fallback function from the proxy admin"
212         );
213         super._willFallback();
214     }
215 }
216 
217 contract DTokenProxy is AdminUpgradeabilityProxy {
218     constructor(address _implementation)
219         public
220         AdminUpgradeabilityProxy(_implementation)
221     {}
222 
223     // Allow anyone to view the implementation address
224     function dTokenImplementation() external view returns (address) {
225         return _implementation();
226     }
227 }