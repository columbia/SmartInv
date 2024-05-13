1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 import {EnumerableSet} from "@openzeppelin/contracts/utils/EnumerableSet.sol";
5 
6 import {IFactory} from "../factory/IFactory.sol";
7 import {InstanceRegistry} from "../factory/InstanceRegistry.sol";
8 import {PowerSwitch} from "./PowerSwitch.sol";
9 
10 /// @title Power Switch Factory
11 contract PowerSwitchFactory is IFactory, InstanceRegistry {
12     function create(bytes calldata args) external override returns (address) {
13         address owner = abi.decode(args, (address));
14         PowerSwitch powerSwitch = new PowerSwitch(owner);
15         InstanceRegistry._register(address(powerSwitch));
16         return address(powerSwitch);
17     }
18 
19     function create2(bytes calldata, bytes32) external pure override returns (address) {
20         revert("PowerSwitchFactory: unused function");
21     }
22 }
