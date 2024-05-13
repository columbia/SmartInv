1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/ProxyAdmin.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 import "./TransparentUpgradeableProxy.sol";
7 import "@openzeppelin/contracts/access/Ownable.sol";
8 
9 /**
10  * @dev This is an auxiliary contract meant to be assigned as the admin of a {TransparentUpgradeableProxy}. For an
11  * explanation of why you would want to use this see the documentation for {TransparentUpgradeableProxy}.
12  */
13 contract ProxyAdmin is Ownable {
14     /**
15      * @dev Returns the current implementation of `proxy`.
16      *
17      * Requirements:
18      *
19      * - This contract must be the admin of `proxy`.
20      */
21     function getProxyImplementation(TransparentUpgradeableProxy proxy)
22         public
23         view
24         virtual
25         returns (address)
26     {
27         // We need to manually run the static call since the getter cannot be flagged as view
28         // bytes4(keccak256("implementation()")) == 0x5c60da1b
29         (bool success, bytes memory returndata) = address(proxy).staticcall(
30             hex"5c60da1b"
31         );
32         require(success);
33         return abi.decode(returndata, (address));
34     }
35 
36     /**
37      * @dev Returns the current admin of `proxy`.
38      *
39      * Requirements:
40      *
41      * - This contract must be the admin of `proxy`.
42      */
43     function getProxyAdmin(TransparentUpgradeableProxy proxy)
44         public
45         view
46         virtual
47         returns (address)
48     {
49         // We need to manually run the static call since the getter cannot be flagged as view
50         // bytes4(keccak256("admin()")) == 0xf851a440
51         (bool success, bytes memory returndata) = address(proxy).staticcall(
52             hex"f851a440"
53         );
54         require(success);
55         return abi.decode(returndata, (address));
56     }
57 
58     /**
59      * @dev Changes the admin of `proxy` to `newAdmin`.
60      *
61      * Requirements:
62      *
63      * - This contract must be the current admin of `proxy`.
64      */
65     function changeProxyAdmin(
66         TransparentUpgradeableProxy proxy,
67         address newAdmin
68     ) public virtual onlyOwner {
69         proxy.changeAdmin(newAdmin);
70     }
71 
72     /**
73      * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
74      *
75      * Requirements:
76      *
77      * - This contract must be the admin of `proxy`.
78      */
79     function upgrade(TransparentUpgradeableProxy proxy, address implementation)
80         public
81         virtual
82         onlyOwner
83     {
84         proxy.upgradeTo(implementation);
85     }
86 
87     /**
88      * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
89      * {TransparentUpgradeableProxy-upgradeToAndCall}.
90      *
91      * Requirements:
92      *
93      * - This contract must be the admin of `proxy`.
94      */
95     function upgradeAndCall(
96         TransparentUpgradeableProxy proxy,
97         address implementation,
98         bytes memory data
99     ) public payable virtual onlyOwner {
100         proxy.upgradeToAndCall{value: msg.value}(implementation, data);
101     }
102 }
