1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import "forge-std/Test.sol";
5 import {UpdaterManager} from "../UpdaterManager.sol";
6 import {TypeCasts} from "../libs/TypeCasts.sol";
7 import {Home} from "../Home.sol";
8 
9 contract UpdaterManagerTest is Test {
10     UpdaterManager updaterManager;
11 
12     address updater;
13 
14     Home home;
15 
16     uint32 localDomain;
17 
18     event FakeSlashed(address reporter);
19 
20     function setUp() public {
21         updater = address(0xBEEF);
22         updaterManager = new UpdaterManager(updater);
23         localDomain = 30;
24         home = new Home(localDomain);
25         home.initialize(updaterManager);
26     }
27 
28     function test_constructor() public {
29         assertEq(updaterManager.updater(), updater);
30     }
31 
32     event NewHome(address homeAddress);
33 
34     function test_setHome() public {
35         // any address that is a contract
36         address homeAddress = address(this);
37         vm.expectEmit(false, false, false, true);
38         emit NewHome(homeAddress);
39         updaterManager.setHome(homeAddress);
40         address storedAddress = TypeCasts.bytes32ToAddress(
41             vm.load(address(updaterManager), bytes32(0))
42         );
43         assertEq(storedAddress, homeAddress);
44     }
45 
46     function test_setHomeOnlyContract() public {
47         address homeAddress = address(0xBEEF);
48         vm.expectRevert("!contract home");
49         updaterManager.setHome(homeAddress);
50     }
51 
52     function test_setHomeOnlyOwnerFuzzed(address user) public {
53         vm.assume(user != address(this));
54         address homeAddress = address(this);
55         updaterManager.setHome(homeAddress);
56         vm.prank(user);
57         vm.expectRevert("Ownable: caller is not the owner");
58         updaterManager.setHome(homeAddress);
59     }
60 
61     function test_setUpdater() public {
62         updaterManager.setHome(address(home));
63         updaterManager.setUpdater(updater);
64         assertEq(updaterManager.updater(), updater);
65     }
66 
67     function test_setUpdaterOnlyOwnerFuzzed(address user) public {
68         vm.assume(user != address(this));
69         updaterManager.setHome(address(home));
70         vm.prank(user);
71         vm.expectRevert("Ownable: caller is not the owner");
72         updaterManager.setUpdater(updater);
73     }
74 
75     function test_slashUpdater() public {
76         address payable reporter = address(0xBEEEEEEF);
77         updaterManager.setHome(address(home));
78         vm.expectEmit(false, false, false, true);
79         emit FakeSlashed(reporter);
80         vm.prank(address(home));
81         updaterManager.slashUpdater(reporter);
82     }
83 
84     function test_renounceOwnershipNotChangeOwnership() public {
85         address ownerBefore = updaterManager.owner();
86         updaterManager.renounceOwnership();
87         assertEq(updaterManager.owner(), ownerBefore);
88     }
89 }
