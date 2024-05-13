1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import {TypeCasts} from "@nomad-xyz/contracts-core/contracts/libs/TypeCasts.sol";
5 import {BridgeRouterBaseTest} from "./BridgeRouterBase.t.sol";
6 
7 contract EthereumBridgeRouterTest is BridgeRouterBaseTest {
8     using TypeCasts for bytes32;
9     using TypeCasts for address payable;
10     using TypeCasts for address;
11 
12     function setUp() public virtual override {
13         setUpEthereumBridgeRouter();
14         super.setUp();
15     }
16 
17     function test_isAffectedAsset() public view {
18         address payable[14] memory affected = accountant.affectedAssets();
19         for (uint256 i = 0; i < affected.length; i++) {
20             require(accountant.isAffectedAsset(affected[i]));
21         }
22     }
23 
24     event MockAcctCalled(
25         address indexed _asset,
26         address indexed _user,
27         uint256 _amount
28     );
29 
30     function test_giveLocalUnaffected() public {
31         uint256 amount = 1000;
32         address recipient = address(33);
33         // test with localtoken
34         localToken.mint(address(bridgeRouter), amount);
35         vm.expectEmit(true, true, false, true, address(localToken));
36         emit Transfer(address(bridgeRouter), recipient, amount);
37         bridgeRouter.exposed_giveLocal(address(localToken), amount, recipient);
38 
39         // test with each affected tokens
40         // This checks for events on the mock accountant
41         // Accountant logic is tested separately
42         address payable[14] memory affected = accountant.affectedAssets();
43         for (uint256 i = 0; i < affected.length; i++) {
44             address a = affected[i];
45             vm.expectEmit(
46                 true,
47                 true,
48                 false,
49                 true,
50                 address(bridgeRouter.accountant())
51             );
52             emit MockAcctCalled(a, recipient, amount);
53             bridgeRouter.exposed_giveLocal(a, amount, recipient);
54         }
55     }
56 
57     function test_exitBridgeOnly() public {
58         address payable[14] memory affected = accountant.affectedAssets();
59         for (uint256 i = 0; i < affected.length; i++) {
60             vm.expectRevert();
61             bridgeRouter.send(
62                 affected[i],
63                 1,
64                 receiverDomain,
65                 tokenReceiver,
66                 fastLiquidityEnabled
67             );
68         }
69     }
70 }
