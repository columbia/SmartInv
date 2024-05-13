1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import {Home} from "../Home.sol";
5 import {NomadTest} from "./utils/NomadTest.sol";
6 import {NomadBaseHarness} from "./harnesses/NomadBaseHarness.sol";
7 import {console} from "forge-std/console.sol";
8 
9 contract NomadBaseTest is NomadTest {
10     NomadBaseHarness nbh;
11 
12     bytes32 oldRoot = "old Root";
13     bytes32 newRoot = "new Root";
14 
15     function setUp() public override {
16         super.setUp();
17         nbh = new NomadBaseHarness(homeDomain);
18         vm.expectEmit(false, false, false, true);
19         emit NewUpdater(address(0), updaterAddr);
20         nbh.initialize(updaterAddr);
21         vm.label(address(nbh), "Nomad Base Harness");
22     }
23 
24     function test_failInitializeTwice() public {
25         vm.expectRevert(
26             bytes("Initializable: contract is already initialized")
27         );
28         nbh.initialize(updaterAddr);
29     }
30 
31     function test_ownerIsContractCreator() public {
32         assertEq(nbh.owner(), address(this));
33     }
34 
35     function test_stateIsActiveAfterInit() public {
36         assertEq(uint256(nbh.state()), 1);
37     }
38 
39     function test_acceptUpdaterSignature() public {
40         bytes memory sig = signHomeUpdate(updaterPK, oldRoot, newRoot);
41         assertTrue(nbh.isUpdaterSignature(oldRoot, newRoot, sig));
42     }
43 
44     function test_rejectNonUpdaterSignature() public {
45         bytes memory sig = signHomeUpdate(fakeUpdaterPK, oldRoot, newRoot);
46         assertFalse(nbh.isUpdaterSignature(oldRoot, newRoot, sig));
47     }
48 
49     function test_homeDomainHash() public {
50         assertEq(
51             nbh.homeDomainHash(),
52             keccak256(abi.encodePacked(homeDomain, "NOMAD"))
53         );
54     }
55 }
