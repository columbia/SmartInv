1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 import {EnumerableSet} from "@openzeppelin/contracts/utils/EnumerableSet.sol";
5 
6 import {IFactory} from "../factory/IFactory.sol";
7 import {InstanceRegistry} from "../factory/InstanceRegistry.sol";
8 import {RewardPool} from "./RewardPool.sol";
9 
10 /// @title Reward Pool Factory
11 contract RewardPoolFactory is IFactory, InstanceRegistry {
12     function create(bytes calldata args) external override returns (address) {
13         address powerSwitch = abi.decode(args, (address));
14         RewardPool pool = new RewardPool(powerSwitch);
15         InstanceRegistry._register(address(pool));
16         pool.transferOwnership(msg.sender);
17         return address(pool);
18     }
19 
20     function create2(bytes calldata, bytes32) external pure override returns (address) {
21         revert("RewardPoolFactory: unused function");
22     }
23 }
