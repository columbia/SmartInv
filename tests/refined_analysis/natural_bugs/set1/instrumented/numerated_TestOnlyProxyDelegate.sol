1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { OnlyProxyDelegate } from "../utility/OnlyProxyDelegate.sol";
5 
6 contract TestOnlyProxyDelegate is OnlyProxyDelegate {
7     constructor(address delegator) OnlyProxyDelegate(delegator) {}
8 
9     function testOnlyProxyDelegate() external view onlyProxyDelegate returns (bool) {
10         return true;
11     }
12 }
