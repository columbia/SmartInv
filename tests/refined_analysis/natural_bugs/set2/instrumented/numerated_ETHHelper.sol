1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // ============ Internal Imports ============
5 import {BridgeRouter} from "./BridgeRouter.sol";
6 import {IWeth} from "../../interfaces/bridge/IWeth.sol";
7 // ============ External Imports ============
8 import {TypeCasts} from "@nomad-xyz/nomad-core-sol/contracts/XAppConnectionManager.sol";
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
42      * @param _enableFast True to enable fast liquidity
43      */
44     function sendTo(
45         uint32 _domain,
46         bytes32 _to,
47         bool _enableFast
48     ) public payable {
49         // wrap ETH to WETH
50         weth.deposit{value: msg.value}();
51         // send WETH via bridge
52         bridge.send(address(weth), msg.value, _domain, _to, _enableFast);
53         // emit event indicating the original sender of tokens
54         emit Send(msg.sender);
55     }
56 
57     /**
58      * @notice Sends ETH over the Nomad Bridge. Sends to the same address on
59      * the other side.
60      * @dev WARNING: This function should only be used when sending TO an
61      * EVM-like domain. As with all bridges, improper use may result in loss of
62      * funds.
63      * @param _domain The domain to send funds to
64      * @param _enableFast True to enable fast liquidity
65      */
66     function send(uint32 _domain, bool _enableFast) external payable {
67         sendTo(_domain, TypeCasts.addressToBytes32(msg.sender), _enableFast);
68     }
69 
70     /**
71      * @notice Sends ETH over the Nomad Bridge. Sends to a specified EVM
72      * address on the other side.
73      * @dev This function should only be used when sending TO an EVM-like
74      * domain. As with all bridges, improper use may result in loss of funds
75      * @param _domain The domain to send funds to.
76      * @param _to The EVM address of the recipient
77      * @param _enableFast True to enable fast liquidity
78      */
79     function sendToEVMLike(
80         uint32 _domain,
81         address _to,
82         bool _enableFast
83     ) external payable {
84         sendTo(_domain, TypeCasts.addressToBytes32(_to), _enableFast);
85     }
86 }
