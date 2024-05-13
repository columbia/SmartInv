1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // ============ Internal Imports ============
5 import {BridgeRouter} from "./BridgeRouter.sol";
6 import {IWeth} from "./interfaces/IWeth.sol";
7 // ============ External Imports ============
8 import {TypeCasts} from "@nomad-xyz/contracts-core/contracts/XAppConnectionManager.sol";
9 
10 contract ETHHelper {
11     // ============ Immutables ============
12 
13     // wrapped Ether contract
14     IWeth public immutable weth;
15     // bridge router contract
16     BridgeRouter public immutable bridge;
17 
18     // ======== Events =========
19 
20     /**
21      * @notice emitted when Ether is sent from this domain to another domain
22      * @param from the address sending tokens
23      */
24     event Send(address indexed from);
25 
26     // ============ Constructor ============
27 
28     constructor(address _weth, address payable _bridge) {
29         weth = IWeth(_weth);
30         bridge = BridgeRouter(_bridge);
31         IWeth(_weth).approve(_bridge, uint256(-1));
32     }
33 
34     // ============ External Functions ============
35 
36     /**
37      * @notice Sends ETH over the Nomad Bridge. Sends to a full-width Nomad
38      * identifer on the other side.
39      * @dev As with all bridges, improper use may result in loss of funds.
40      * @param _domain The domain to send funds to.
41      * @param _to The 32-byte identifier of the recipient
42      */
43     function sendTo(
44         uint32 _domain,
45         bytes32 _to,
46         bool /*_enableFast - deprecated field, left argument for backwards compatibility */
47     ) public payable {
48         // wrap ETH to WETH
49         weth.deposit{value: msg.value}();
50         // send WETH via bridge
51         bridge.send(address(weth), msg.value, _domain, _to, false);
52         // emit event indicating the original sender of tokens
53         emit Send(msg.sender);
54     }
55 
56     /**
57      * @notice Sends ETH over the Nomad Bridge. Sends to the same address on
58      * the other side.
59      * @dev WARNING: This function should only be used when sending TO an
60      * EVM-like domain. As with all bridges, improper use may result in loss of
61      * funds.
62      * @param _domain The domain to send funds to
63      */
64     function send(
65         uint32 _domain,
66         bool /*_enableFast - deprecated field, left argument for backwards compatibility */
67     ) external payable {
68         sendTo(_domain, TypeCasts.addressToBytes32(msg.sender), false);
69     }
70 
71     /**
72      * @notice Sends ETH over the Nomad Bridge. Sends to a specified EVM
73      * address on the other side.
74      * @dev This function should only be used when sending TO an EVM-like
75      * domain. As with all bridges, improper use may result in loss of funds
76      * @param _domain The domain to send funds to.
77      * @param _to The EVM address of the recipient
78      */
79     function sendToEVMLike(
80         uint32 _domain,
81         address _to,
82         bool /*_enableFast - deprecated field, left argument for backwards compatibility */
83     ) external payable {
84         sendTo(_domain, TypeCasts.addressToBytes32(_to), false);
85     }
86 }
