1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/TransparentUpgradeableProxy.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
7 
8 /**
9  * @dev This contract implements a proxy that is upgradeable by an admin.
10  *
11  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
12  * clashing], which can potentially be used in an attack, this contract uses the
13  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
14  * things that go hand in hand:
15  *
16  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
17  * that call matches one of the admin functions exposed by the proxy itself.
18  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
19  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
20  * "admin cannot fallback to proxy target".
21  *
22  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
23  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
24  * to sudden errors when trying to call a function from the proxy implementation.
25  *
26  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
27  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
28  */
29 contract TransparentUpgradeableProxy is ERC1967Proxy {
30     /**
31      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
32      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
33      */
34     constructor(
35         address _logic,
36         address admin_,
37         bytes memory _data
38     ) payable ERC1967Proxy(_logic, _data) {
39         assert(
40             _ADMIN_SLOT ==
41                 bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1)
42         );
43         _changeAdmin(admin_);
44     }
45 
46     /**
47      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
48      */
49     modifier ifAdmin() {
50         if (msg.sender == _getAdmin()) {
51             _;
52         } else {
53             _fallback();
54         }
55     }
56 
57     /**
58      * @dev Returns the current admin.
59      *
60      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
61      *
62      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
63      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
64      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
65      */
66     function admin() external ifAdmin returns (address admin_) {
67         admin_ = _getAdmin();
68     }
69 
70     /**
71      * @dev Returns the current implementation.
72      *
73      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
74      *
75      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
76      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
77      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
78      */
79     function implementation()
80         external
81         ifAdmin
82         returns (address implementation_)
83     {
84         implementation_ = _implementation();
85     }
86 
87     /**
88      * @dev Changes the admin of the proxy.
89      *
90      * Emits an {AdminChanged} event.
91      *
92      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
93      */
94     function changeAdmin(address newAdmin) external virtual ifAdmin {
95         _changeAdmin(newAdmin);
96     }
97 
98     /**
99      * @dev Upgrade the implementation of the proxy.
100      *
101      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
102      */
103     function upgradeTo(address newImplementation) external ifAdmin {
104         _upgradeToAndCall(newImplementation, bytes(""), false);
105     }
106 
107     /**
108      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
109      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
110      * proxied contract.
111      *
112      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
113      */
114     function upgradeToAndCall(address newImplementation, bytes calldata data)
115         external
116         payable
117         ifAdmin
118     {
119         _upgradeToAndCall(newImplementation, data, true);
120     }
121 
122     /**
123      * @dev Returns the current admin.
124      */
125     function _admin() internal view virtual returns (address) {
126         return _getAdmin();
127     }
128 
129     /**
130      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
131      */
132     function _beforeFallback() internal virtual override {
133         require(
134             msg.sender != _getAdmin(),
135             "TransparentUpgradeableProxy: admin cannot fallback to proxy target"
136         );
137         super._beforeFallback();
138     }
139 }
