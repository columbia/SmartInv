1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.6;
3 
4 import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
5 
6 library ProxyFactory {
7     /* functions */
8 
9     function _create(address logic, bytes memory data) internal returns (address proxy) {
10         // deploy clone
11         proxy = Clones.clone(logic);
12 
13         // attempt initialization
14         if (data.length > 0) {
15             (bool success, bytes memory err) = proxy.call(data);
16             require(success, string(err));
17         }
18 
19         // explicit return
20         return proxy;
21     }
22 
23     function _create2(
24         address logic,
25         bytes memory data,
26         bytes32 salt
27     ) internal returns (address proxy) {
28         // deploy clone
29         proxy = Clones.cloneDeterministic(logic, salt);
30 
31         // attempt initialization
32         if (data.length > 0) {
33             (bool success, bytes memory err) = proxy.call(data);
34             require(success, string(err));
35         }
36 
37         // explicit return
38         return proxy;
39     }
40 }
