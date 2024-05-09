1 // SPDX-License-Identifier: BSD-3-Clause
2 // File: contracts/interfaces/IOwner.sol
3 pragma solidity 0.8.4;
4 
5 /**
6 * @title BiFi-Bifrost-Extension IOwner Interface
7 * @notice Interface for Owner Contract
8 * @author BiFi-Bifrost-Extension(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
9 */
10 
11 interface IOwner {
12     function transferOwnership(address _owner) external;
13     function acceptOwnership() external;
14     function setOwner(address _owner) external;
15     function setAdmin(address _admin, uint256 auth) external;
16 }
17 
18 // File: contracts/interfaces/IProxyEntry.sol
19 pragma solidity 0.8.4;
20 
21 
22 /**
23 * @title BiFi-Bifrost-Extension IProxyEntry Interface
24 * @notice Interface for Proxy Contract
25 * @author BiFi-Bifrost-Extension(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
26 */
27 
28 interface IProxyEntry is IOwner {
29     function setProxyLogic(address logicAddr) external returns(bool);
30     fallback() external payable;
31     receive() external payable;
32 }
33 
34 // File: contracts/libs/Owner.sol
35 pragma solidity 0.8.4;
36 
37 
38 abstract contract Owner is IOwner {
39     address payable public owner;
40     address payable public pendingOwner;
41     mapping(address => uint256) public admins;
42 
43     modifier onlyOwner() {
44         require(payable( msg.sender ) == owner, "only Owner");
45         _;
46     }
47 
48     modifier onlyAdmin() {
49         address payable sender = payable( msg.sender );
50         require(sender == owner || admins[sender] != 0, "only Admin");
51         _;
52     }
53 
54     constructor() {
55         admins[owner = payable( msg.sender )] = 1;
56     }
57 
58     function transferOwnership(address _nextOwner) override external onlyOwner {
59         pendingOwner = payable( _nextOwner );
60     }
61 
62     function acceptOwnership() override external {
63         address payable sender = payable( msg.sender );
64         require(sender == pendingOwner, "pendingOwner");
65         owner = sender;
66     }
67 
68     function setOwner(address _nextOwner) override external onlyOwner {
69         owner = payable( _nextOwner );
70     }
71 
72     function setAdmin(address _admin, uint256 auth) override external onlyOwner {
73         admins[_admin] = auth;
74     }
75 }
76 
77 // File: contracts/libs/proxy/ProxyStorage.sol
78 pragma solidity 0.8.4;
79 
80 
81 /**
82 * @title BiFi-Bifrost-Extension ProxyStorage Contract
83 * @notice Contract for proxy storage layout sharing
84 * @author BiFi-Bifrost-Extension(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
85 */
86 
87 abstract contract ProxyStorage is Owner {
88     address public _implement;
89 }
90 
91 // File: contracts/libs/proxy/ProxyEntry.sol
92 pragma solidity 0.8.4;
93 
94 
95 
96 /**
97 * @title BiFi-Bifrost-Extension ProxyEntry Contract
98 * @notice Contract for upgradable proxy pattern with access control
99 * @author BiFi-Bifrost-Extension(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
100 */
101 
102 contract ProxyEntry is ProxyStorage, IProxyEntry {
103     constructor (address logicAddr) {
104         _setProxyLogic(logicAddr);
105     }
106 
107     function setProxyLogic(address logicAddr) onlyOwner override external returns(bool) {
108         _setProxyLogic(logicAddr);
109     }
110     function _setProxyLogic(address logicAddr) internal {
111         _implement = logicAddr;
112     }
113 
114     fallback() override external payable {
115         address addr = _implement;
116         assembly {
117             calldatacopy(0, 0, calldatasize())
118             let result := delegatecall(gas(), addr, 0, calldatasize(), 0, 0)
119             returndatacopy(0, 0, returndatasize())
120             switch result
121             case 0 { revert(0, returndatasize()) }
122             default { return(0, returndatasize()) }
123         }
124     }
125 
126     receive() override external payable {}
127 }