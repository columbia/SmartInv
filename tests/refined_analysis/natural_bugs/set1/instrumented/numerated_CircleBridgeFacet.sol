1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { ITokenMessenger } from "../Interfaces/ITokenMessenger.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
9 import { Validatable } from "../Helpers/Validatable.sol";
10 
11 /// @title CircleBridge Facet
12 /// @author LI.FI (https://li.fi)
13 /// @notice Provides functionality for bridging through CircleBridge
14 /// @custom:version 1.0.0
15 contract CircleBridgeFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
16     /// Storage ///
17 
18     /// @notice The address of the TokenMessenger on the source chain.
19     ITokenMessenger private immutable tokenMessenger;
20 
21     /// @notice The USDC address on the source chain.
22     address private immutable usdc;
23 
24     /// @param dstDomain The CircleBridge-specific domainId of the destination chain
25     struct CircleBridgeData {
26         uint32 dstDomain;
27     }
28 
29     /// Constructor ///
30 
31     /// @notice Initialize the contract.
32     /// @param _tokenMessenger The address of the TokenMessenger on the source chain.
33     /// @param _usdc The address of USDC on the source chain.
34     constructor(ITokenMessenger _tokenMessenger, address _usdc) {
35         tokenMessenger = _tokenMessenger;
36         usdc = _usdc;
37     }
38 
39     /// External Methods ///
40 
41     /// @notice Bridges tokens via CircleBridge
42     /// @param _bridgeData Data containing core information for bridging
43     /// @param _circleBridgeData Data specific to bridge
44     function startBridgeTokensViaCircleBridge(
45         BridgeData calldata _bridgeData,
46         CircleBridgeData calldata _circleBridgeData
47     )
48         external
49         nonReentrant
50         doesNotContainSourceSwaps(_bridgeData)
51         doesNotContainDestinationCalls(_bridgeData)
52         validateBridgeData(_bridgeData)
53         onlyAllowSourceToken(_bridgeData, usdc)
54     {
55         LibAsset.depositAsset(usdc, _bridgeData.minAmount);
56         _startBridge(_bridgeData, _circleBridgeData);
57     }
58 
59     /// @notice Performs a swap before bridging via CircleBridge
60     /// @param _bridgeData The core information needed for bridging
61     /// @param _swapData An array of swap related data for performing swaps before bridging
62     /// @param _circleBridgeData Data specific to CircleBridge
63     function swapAndStartBridgeTokensViaCircleBridge(
64         BridgeData memory _bridgeData,
65         LibSwap.SwapData[] calldata _swapData,
66         CircleBridgeData calldata _circleBridgeData
67     )
68         external
69         payable
70         nonReentrant
71         refundExcessNative(payable(msg.sender))
72         containsSourceSwaps(_bridgeData)
73         doesNotContainDestinationCalls(_bridgeData)
74         validateBridgeData(_bridgeData)
75         onlyAllowSourceToken(_bridgeData, usdc)
76     {
77         _bridgeData.minAmount = _depositAndSwap(
78             _bridgeData.transactionId,
79             _bridgeData.minAmount,
80             _swapData,
81             payable(msg.sender)
82         );
83         _startBridge(_bridgeData, _circleBridgeData);
84     }
85 
86     /// Private Methods ///
87 
88     /// @dev Contains the business logic for the bridge via CircleBridge
89     /// @param _bridgeData The core information needed for bridging
90     /// @param _circleBridgeData Data specific to CircleBridge
91     function _startBridge(
92         BridgeData memory _bridgeData,
93         CircleBridgeData calldata _circleBridgeData
94     ) private {
95         // give max approval for token to CircleBridge bridge, if not already
96         LibAsset.maxApproveERC20(
97             IERC20(usdc),
98             address(tokenMessenger),
99             _bridgeData.minAmount
100         );
101 
102         // initiate bridge transaction
103         tokenMessenger.depositForBurn(
104             _bridgeData.minAmount,
105             _circleBridgeData.dstDomain,
106             bytes32(uint256(uint160(_bridgeData.receiver))),
107             usdc
108         );
109 
110         emit LiFiTransferStarted(_bridgeData);
111     }
112 }
