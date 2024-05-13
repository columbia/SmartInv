1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 import {EnumerableSet} from "@openzeppelin/contracts/utils/EnumerableSet.sol";
5 
6 interface IInstanceRegistry {
7     /* events */
8 
9     event InstanceAdded(address instance);
10     event InstanceRemoved(address instance);
11 
12     /* view functions */
13 
14     function isInstance(address instance) external view returns (bool validity);
15 
16     function instanceCount() external view returns (uint256 count);
17 
18     function instanceAt(uint256 index) external view returns (address instance);
19 }
20 
21 /// @title InstanceRegistry
22 contract InstanceRegistry is IInstanceRegistry {
23     using EnumerableSet for EnumerableSet.AddressSet;
24 
25     /* storage */
26 
27     EnumerableSet.AddressSet private _instanceSet;
28 
29     /* view functions */
30 
31     function isInstance(address instance) external view override returns (bool validity) {
32         return _instanceSet.contains(instance);
33     }
34 
35     function instanceCount() external view override returns (uint256 count) {
36         return _instanceSet.length();
37     }
38 
39     function instanceAt(uint256 index) external view override returns (address instance) {
40         return _instanceSet.at(index);
41     }
42 
43     /* admin functions */
44 
45     function _register(address instance) internal {
46         require(_instanceSet.add(instance), "InstanceRegistry: already registered");
47         emit InstanceAdded(instance);
48     }
49 }
