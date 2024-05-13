1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.6;
3 
4 // Test imports
5 import {TypeCasts} from "../libs/TypeCasts.sol";
6 import {UpgradeBeacon} from "../upgrade/UpgradeBeacon.sol";
7 import {UpgradeTest} from "./utils/UpgradeTest.sol";
8 
9 // External Imports
10 import {Address} from "@openzeppelin/contracts/utils/Address.sol";
11 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
12 
13 contract UpgradeBeaconTest is UpgradeTest {
14     event Upgrade(address indexed implementation);
15 
16     using TypedMemView for bytes;
17     using TypedMemView for bytes29;
18 
19     function setUp() public override {
20         super.setUp();
21         controllerAddr = address(0xBEEF);
22         // any address that is NOT an EOA
23         implAddr = address(this);
24         vm.expectEmit(true, false, false, false);
25         emit Upgrade(implAddr);
26         beacon = new UpgradeBeacon(implAddr, controllerAddr);
27         beaconAddr = address(beacon);
28     }
29 
30     function test_constructor() public {
31         address storedImplementation = TypeCasts.bytes32ToAddress(
32             vm.load(beaconAddr, bytes32(0))
33         );
34         assertEq(storedImplementation, implAddr);
35         // Immutable variables are part of the bytecode of the contract
36         bytes memory data = at(beaconAddr);
37         bytes29 dataView = data.ref(0);
38         assertEq(
39             controllerAddr,
40             TypeCasts.bytes32ToAddress(dataView.index(28, 32))
41         );
42     }
43 
44     function test_fallbackNotController() public {
45         (bool success, bytes memory ret) = beaconAddr.call("");
46         assert(success);
47         assertEq(implAddr, abi.decode(ret, (address)));
48     }
49 
50     function test_fallbackNotControllerFuzzed(bytes memory data) public {
51         (bool success, bytes memory ret) = beaconAddr.call(data);
52         assert(success);
53         assertEq(implAddr, abi.decode(ret, (address)));
54     }
55 
56     function test_fallbackControllerSuccess() public {
57         // any address that is not a EOA
58         address newImpl = address(vm);
59         vm.startPrank(controllerAddr);
60         vm.expectEmit(true, false, false, false);
61         emit Upgrade(newImpl);
62         beaconAddr.call(abi.encode(newImpl));
63         address storedImplementation = TypeCasts.bytes32ToAddress(
64             vm.load(beaconAddr, bytes32(0))
65         );
66         assertEq(storedImplementation, newImpl);
67         vm.stopPrank();
68     }
69 
70     function test_fallbackControllerFailNotContract() public {
71         // any address that is not a EOA
72         address newImpl = address(0xBEEFEEF);
73         vm.startPrank(controllerAddr);
74         (bool success, bytes memory ret) = beaconAddr.call(abi.encode(newImpl));
75         assertFalse(success);
76         assertEq(
77             ret,
78             abi.encodeWithSignature("Error(string)", "implementation !contract")
79         );
80     }
81 
82     function test_fallbackControllerFailNotContractFuzzed(address newImpl)
83         public
84     {
85         vm.assume(!Address.isContract(newImpl));
86         vm.startPrank(controllerAddr);
87         (bool success, bytes memory ret) = beaconAddr.call(abi.encode(newImpl));
88         assertFalse(success);
89         assertEq(
90             ret,
91             abi.encodeWithSignature("Error(string)", "implementation !contract")
92         );
93     }
94 
95     function test_fallbackControllerFailSameImpl() public {
96         // any address that is not a EOA
97         address newImpl = implAddr;
98         vm.startPrank(controllerAddr);
99         (bool success, bytes memory ret) = beaconAddr.call(abi.encode(newImpl));
100         assertFalse(success);
101         assertEq(
102             ret.ref(0).slice(4, ret.length - 4, 0).keccak(),
103             keccak256(abi.encode("!upgrade"))
104         );
105     }
106 }
