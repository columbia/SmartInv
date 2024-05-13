1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { ICircleBridgeProxy } from "../Interfaces/ICircleBridgeProxy.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
9 import { Validatable } from "../Helpers/Validatable.sol";
10 
11 /// @title CelerCircleBridge Facet
12 /// @author LI.FI (https://li.fi)
13 /// @notice Provides functionality for bridging through CelerCircleBridge
14 /// @custom:version 1.0.1
15 contract CelerCircleBridgeFacet is
16     ILiFi,
17     ReentrancyGuard,
18     SwapperV2,
19     Validatable
20 {
21     /// Storage ///
22 
23     /// @notice The address of the CircleBridgeProxy on the current chain.
24     ICircleBridgeProxy private immutable circleBridgeProxy;
25 
26     /// @notice The USDC address on the current chain.
27     address private immutable usdc;
28 
29     /// Constructor ///
30 
31     /// @notice Initialize the contract.
32     /// @param _circleBridgeProxy The address of the CircleBridgeProxy on the current chain.
33     /// @param _usdc The address of USDC on the current chain.
34     constructor(ICircleBridgeProxy _circleBridgeProxy, address _usdc) {
35         circleBridgeProxy = _circleBridgeProxy;
36         usdc = _usdc;
37     }
38 
39     /// External Methods ///
40 
41     /// @notice Bridges tokens via CelerCircleBridge
42     /// @param _bridgeData Data containing core information for bridging
43     function startBridgeTokensViaCelerCircleBridge(
44         BridgeData calldata _bridgeData
45     )
46         external
47         nonReentrant
48         doesNotContainSourceSwaps(_bridgeData)
49         doesNotContainDestinationCalls(_bridgeData)
50         validateBridgeData(_bridgeData)
51         onlyAllowSourceToken(_bridgeData, usdc)
52     {
53         LibAsset.depositAsset(usdc, _bridgeData.minAmount);
54         _startBridge(_bridgeData);
55     }
56 
57     /// @notice Performs a swap before bridging via CelerCircleBridge
58     /// @param _bridgeData The core information needed for bridging
59     /// @param _swapData An array of swap related data for performing swaps before bridging
60     function swapAndStartBridgeTokensViaCelerCircleBridge(
61         BridgeData memory _bridgeData,
62         LibSwap.SwapData[] calldata _swapData
63     )
64         external
65         payable
66         nonReentrant
67         refundExcessNative(payable(msg.sender))
68         containsSourceSwaps(_bridgeData)
69         doesNotContainDestinationCalls(_bridgeData)
70         validateBridgeData(_bridgeData)
71         onlyAllowSourceToken(_bridgeData, usdc)
72     {
73         _bridgeData.minAmount = _depositAndSwap(
74             _bridgeData.transactionId,
75             _bridgeData.minAmount,
76             _swapData,
77             payable(msg.sender)
78         );
79         _startBridge(_bridgeData);
80     }
81 
82     /// Private Methods ///
83 
84     /// @dev Contains the business logic for the bridge via CelerCircleBridge
85     /// @param _bridgeData The core information needed for bridging
86     function _startBridge(BridgeData memory _bridgeData) private {
87         require(
88             _bridgeData.destinationChainId <= type(uint64).max,
89             "_bridgeData.destinationChainId passed is too big to fit in uint64"
90         );
91 
92         // give max approval for token to CelerCircleBridge bridge, if not already
93         LibAsset.maxApproveERC20(
94             IERC20(usdc),
95             address(circleBridgeProxy),
96             _bridgeData.minAmount
97         );
98 
99         // initiate bridge transaction
100         circleBridgeProxy.depositForBurn(
101             _bridgeData.minAmount,
102             uint64(_bridgeData.destinationChainId),
103             bytes32(uint256(uint160(_bridgeData.receiver))),
104             usdc
105         );
106 
107         emit LiFiTransferStarted(_bridgeData);
108     }
109 }
