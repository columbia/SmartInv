1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 interface ICloneFactory {
12     function clone(address prototype) external returns (address proxy);
13 }
14 
15 // introduction of proxy mode design: https://docs.openzeppelin.com/upgrades/2.8/
16 // minimum implementation of transparent proxy: https://eips.ethereum.org/EIPS/eip-1167
17 
18 contract CloneFactory is ICloneFactory {
19     function clone(address prototype) external override returns (address proxy) {
20         bytes20 targetBytes = bytes20(prototype);
21         assembly {
22             let clone := mload(0x40)
23             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
24             mstore(add(clone, 0x14), targetBytes)
25             mstore(
26                 add(clone, 0x28),
27                 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
28             )
29             proxy := create(0, clone, 0x37)
30         }
31         return proxy;
32     }
33 }
