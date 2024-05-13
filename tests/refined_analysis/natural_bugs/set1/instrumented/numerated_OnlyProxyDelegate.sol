1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 /**
5  * @dev restrict delegation
6  */
7 abstract contract OnlyProxyDelegate {
8     address private immutable _proxy;
9 
10     error UnknownDelegator();
11     error UnsetDelegator();
12 
13     constructor(address proxy) {
14         _proxy = proxy;
15     }
16 
17     modifier onlyProxyDelegate() {
18         _onlyProxyDelegate();
19 
20         _;
21     }
22 
23     function _onlyProxyDelegate() internal view {
24         if (_proxy == address(0)) {
25             revert UnsetDelegator();
26         }
27         if (address(this) != _proxy) {
28             revert UnknownDelegator();
29         }
30     }
31 }
