1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.6;
3 
4 import "../upgrade/UpgradeBeaconController.sol";
5 import {UpgradeTest} from "./utils/UpgradeTest.sol";
6 import {MockBeacon} from "./utils/MockBeacon.sol";
7 
8 contract UpgradeBeaconControllerTest is UpgradeTest {
9     MockBeacon mockBeacon;
10 
11     function setUp() public override {
12         super.setUp();
13         implAddr = address(this);
14         controller = new UpgradeBeaconController();
15         controllerAddr = address(controller);
16         mockBeacon = new MockBeacon(implAddr, controllerAddr);
17         beaconAddr = address(mockBeacon);
18     }
19 
20     event BeaconUpgraded(address indexed beacon, address implementation);
21 
22     function test_upgradeContractOnlyOwner() public {
23         // any address that is a contract
24         vm.expectEmit(true, false, false, true);
25         emit BeaconUpgraded(beaconAddr, implAddr);
26         controller.upgrade(beaconAddr, implAddr);
27         assertEq(mockBeacon.implementation(), implAddr);
28     }
29 
30     function test_upgradeAddressFail() public {
31         // any address that is a contract
32         vm.expectRevert("beacon !contract");
33         controller.upgrade(address(0xBEEF), implAddr);
34     }
35 
36     function test_upgradeNotOwnerFailFuzzed(address user) public {
37         vm.assume(user != controller.owner());
38         vm.prank(user);
39         vm.expectRevert("Ownable: caller is not the owner");
40         controller.upgrade(beaconAddr, implAddr);
41     }
42 }
