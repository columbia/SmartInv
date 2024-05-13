1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.6;
3 
4 // Test libraries
5 
6 import {UpgradeTest} from "./utils/UpgradeTest.sol";
7 import {MockBeacon} from "./utils/MockBeacon.sol";
8 import {MockBeaconRevert} from "./utils/MockBeaconRevert.sol";
9 import {MockBeaconNotAddr} from "./utils/MockBeaconNotAddr.sol";
10 import {UpgradeBeaconProxy} from "../upgrade/UpgradeBeaconProxy.sol";
11 
12 contract UpgradeProxyTest is UpgradeTest {
13     MockBeacon mockBeacon;
14     UpgradeBeaconProxy proxy;
15 
16     event Quote(string what);
17 
18     function setUp() public override {
19         super.setUp();
20         controllerAddr = address(this);
21         mockBeacon = new MockBeacon(implAddr, controllerAddr);
22         beaconAddr = address(mockBeacon);
23         vm.expectEmit(false, false, false, true);
24         emit Quote("The fires are lit! The fires of Amon Din are lit");
25         proxy = new UpgradeBeaconProxy(
26             beaconAddr,
27             abi.encodeWithSignature("gondor()")
28         );
29         proxyAddr = address(proxy);
30     }
31 
32     function test_constructor() public {
33         (bool success, bytes memory data) = proxyAddr.call(
34             abi.encodeWithSignature("fires()")
35         );
36         assert(success);
37         assert(abi.decode(data, (bool)));
38     }
39 
40     function test_constructorBeaconNotContract() public {
41         beaconAddr = address(0xBEEF);
42         vm.expectRevert("beacon !contract");
43         proxy = new UpgradeBeaconProxy(
44             beaconAddr,
45             abi.encodeWithSignature("gondor()")
46         );
47     }
48 
49     function test_constructorBeaconNotContractFuzzed(address _beaconAddr)
50         public
51     {
52         vm.assume(!isContract(_beaconAddr));
53         vm.expectRevert("beacon !contract");
54         proxy = new UpgradeBeaconProxy(
55             _beaconAddr,
56             abi.encodeWithSignature("gondor()")
57         );
58     }
59 
60     function test_constructorImplNotcontract() public {
61         implAddr = address(0xBEEF);
62         mockBeacon = new MockBeacon(implAddr, controllerAddr);
63         beaconAddr = address(mockBeacon);
64         vm.expectRevert("beacon implementation !contract");
65         proxy = new UpgradeBeaconProxy(
66             beaconAddr,
67             abi.encodeWithSignature("gondor()")
68         );
69     }
70 
71     function test_constructorImplNotcontractFuzzed(address _implAddr) public {
72         mockBeacon = new MockBeacon(_implAddr, controllerAddr);
73         beaconAddr = address(mockBeacon);
74         vm.assume(!isContract(_implAddr));
75         vm.expectRevert("beacon implementation !contract");
76         proxy = new UpgradeBeaconProxy(
77             beaconAddr,
78             abi.encodeWithSignature("gondor()")
79         );
80     }
81 
82     function test_fallback() public {
83         vm.expectEmit(false, false, false, true);
84         emit Quote("I am no man");
85         proxyAddr.call(abi.encodeWithSignature("witchKing(bool)", true));
86     }
87 
88     function test_fallbackRevert() public {
89         vm.expectRevert("no man can kill me");
90         proxyAddr.call(abi.encodeWithSignature("witchKing(bool)", false));
91     }
92 
93     function test_receive() public {
94         // Give 10 ether
95         vm.deal(address(this), 10);
96         // Empty calldata + value invokes the receive() function
97         emit Quote(
98             "Nine were given to the kings of men whose heart above all desire Power"
99         );
100         proxyAddr.call{value: 1}("");
101     }
102 
103     // Test that if beacon reverts during `_getImplementation`, proxy will return the
104     // revert error
105     function test_getImplementationRevert() public {
106         MockBeaconRevert mockBeaconRevert = new MockBeaconRevert(
107             implAddr,
108             controllerAddr
109         );
110         vm.expectRevert(abi.encodeWithSignature("Error(string)", "lol no"));
111         proxy = new UpgradeBeaconProxy(address(mockBeaconRevert), "");
112     }
113 
114     // Test that if beacon returns raw bytes that aren't an address
115     function test_getImplementationNotAddress() public {
116         MockBeaconNotAddr mockBeaconNotAddr = new MockBeaconNotAddr(
117             implAddr,
118             controllerAddr
119         );
120         vm.expectRevert("beacon implementation !contract");
121         proxy = new UpgradeBeaconProxy(address(mockBeaconNotAddr), "");
122     }
123 }
