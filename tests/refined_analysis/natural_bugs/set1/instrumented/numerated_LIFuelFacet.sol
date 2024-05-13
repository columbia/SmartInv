1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { LiFuelFeeCollector } from "../Periphery/LiFuelFeeCollector.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
9 import { Validatable } from "../Helpers/Validatable.sol";
10 
11 /// @title LIFuel Facet
12 /// @author Li.Finance (https://li.finance)
13 /// @notice Provides functionality for bridging gas through LIFuel
14 /// @custom:version 1.0.1
15 contract LIFuelFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
16     /// Storage ///
17 
18     bytes32 internal constant NAMESPACE =
19         keccak256("com.lifi.facets.periphery_registry");
20     string internal constant FEE_COLLECTOR_NAME = "LiFuelFeeCollector";
21 
22     /// Types ///
23 
24     struct Storage {
25         mapping(string => address) contracts;
26     }
27 
28     /// External Methods ///
29 
30     /// @notice Bridges tokens via LIFuel Bridge
31     /// @param _bridgeData Data used purely for tracking and analytics
32     function startBridgeTokensViaLIFuel(
33         ILiFi.BridgeData memory _bridgeData
34     )
35         external
36         payable
37         nonReentrant
38         refundExcessNative(payable(msg.sender))
39         doesNotContainSourceSwaps(_bridgeData)
40         doesNotContainDestinationCalls(_bridgeData)
41         validateBridgeData(_bridgeData)
42     {
43         LibAsset.depositAsset(
44             _bridgeData.sendingAssetId,
45             _bridgeData.minAmount
46         );
47         _startBridge(_bridgeData);
48     }
49 
50     /// @notice Performs a swap before bridging via LIFuel Bridge
51     /// @param _bridgeData Data used purely for tracking and analytics
52     /// @param _swapData An array of swap related data for performing swaps before bridging
53     function swapAndStartBridgeTokensViaLIFuel(
54         ILiFi.BridgeData memory _bridgeData,
55         LibSwap.SwapData[] calldata _swapData
56     )
57         external
58         payable
59         nonReentrant
60         refundExcessNative(payable(msg.sender))
61         containsSourceSwaps(_bridgeData)
62         doesNotContainDestinationCalls(_bridgeData)
63         validateBridgeData(_bridgeData)
64     {
65         _bridgeData.minAmount = _depositAndSwap(
66             _bridgeData.transactionId,
67             _bridgeData.minAmount,
68             _swapData,
69             payable(msg.sender)
70         );
71 
72         _startBridge(_bridgeData);
73     }
74 
75     /// Private Methods ///
76 
77     /// @dev Contains the business logic for the bridge via LIFuel Bridge
78     /// @param _bridgeData Data used purely for tracking and analytics
79     function _startBridge(ILiFi.BridgeData memory _bridgeData) private {
80         LiFuelFeeCollector liFuelFeeCollector = LiFuelFeeCollector(
81             getStorage().contracts[FEE_COLLECTOR_NAME]
82         );
83 
84         if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
85             liFuelFeeCollector.collectNativeGasFees{
86                 value: _bridgeData.minAmount
87             }(
88                 _bridgeData.minAmount,
89                 _bridgeData.destinationChainId,
90                 _bridgeData.receiver
91             );
92         } else {
93             LibAsset.maxApproveERC20(
94                 IERC20(_bridgeData.sendingAssetId),
95                 address(liFuelFeeCollector),
96                 _bridgeData.minAmount
97             );
98 
99             liFuelFeeCollector.collectTokenGasFees(
100                 _bridgeData.sendingAssetId,
101                 _bridgeData.minAmount,
102                 _bridgeData.destinationChainId,
103                 _bridgeData.receiver
104             );
105         }
106 
107         emit LiFiTransferStarted(_bridgeData);
108     }
109 
110     /// @dev fetch local storage
111     function getStorage() private pure returns (Storage storage s) {
112         bytes32 namespace = NAMESPACE;
113         // solhint-disable-next-line no-inline-assembly
114         assembly {
115             s.slot := namespace
116         }
117     }
118 }
