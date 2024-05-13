1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IRootChainManager } from "../Interfaces/IRootChainManager.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
9 import { Validatable } from "../Helpers/Validatable.sol";
10 
11 /// @title Polygon Bridge Facet
12 /// @author Li.Finance (https://li.finance)
13 /// @notice Provides functionality for bridging through Polygon Bridge
14 /// @custom:version 1.0.0
15 contract PolygonBridgeFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
16     /// Storage ///
17 
18     /// @notice The contract address of the RootChainManager on the source chain.
19     IRootChainManager private immutable rootChainManager;
20 
21     /// @notice The contract address of the ERC20Predicate on the source chain.
22     address private immutable erc20Predicate;
23 
24     /// Constructor ///
25 
26     /// @notice Initialize the contract.
27     /// @param _rootChainManager The contract address of the RootChainManager on the source chain.
28     /// @param _erc20Predicate The contract address of the ERC20Predicate on the source chain.
29     constructor(IRootChainManager _rootChainManager, address _erc20Predicate) {
30         rootChainManager = _rootChainManager;
31         erc20Predicate = _erc20Predicate;
32     }
33 
34     /// External Methods ///
35 
36     /// @notice Bridges tokens via Polygon Bridge
37     /// @param _bridgeData Data containing core information for bridging
38     function startBridgeTokensViaPolygonBridge(
39         ILiFi.BridgeData memory _bridgeData
40     )
41         external
42         payable
43         nonReentrant
44         refundExcessNative(payable(msg.sender))
45         doesNotContainSourceSwaps(_bridgeData)
46         doesNotContainDestinationCalls(_bridgeData)
47         validateBridgeData(_bridgeData)
48     {
49         LibAsset.depositAsset(
50             _bridgeData.sendingAssetId,
51             _bridgeData.minAmount
52         );
53         _startBridge(_bridgeData);
54     }
55 
56     /// @notice Performs a swap before bridging via Polygon Bridge
57     /// @param _bridgeData Data containing core information for bridging
58     /// @param _swapData An array of swap related data for performing swaps before bridging
59     function swapAndStartBridgeTokensViaPolygonBridge(
60         ILiFi.BridgeData memory _bridgeData,
61         LibSwap.SwapData[] calldata _swapData
62     )
63         external
64         payable
65         nonReentrant
66         refundExcessNative(payable(msg.sender))
67         containsSourceSwaps(_bridgeData)
68         doesNotContainDestinationCalls(_bridgeData)
69         validateBridgeData(_bridgeData)
70     {
71         _bridgeData.minAmount = _depositAndSwap(
72             _bridgeData.transactionId,
73             _bridgeData.minAmount,
74             _swapData,
75             payable(msg.sender)
76         );
77         _startBridge(_bridgeData);
78     }
79 
80     /// Private Methods ///
81 
82     /// @dev Contains the business logic for the bridge via Polygon Bridge
83     /// @param _bridgeData Data containing core information for bridging
84     function _startBridge(ILiFi.BridgeData memory _bridgeData) private {
85         address childToken;
86 
87         if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
88             rootChainManager.depositEtherFor{ value: _bridgeData.minAmount }(
89                 _bridgeData.receiver
90             );
91         } else {
92             childToken = rootChainManager.rootToChildToken(
93                 _bridgeData.sendingAssetId
94             );
95 
96             LibAsset.maxApproveERC20(
97                 IERC20(_bridgeData.sendingAssetId),
98                 erc20Predicate,
99                 _bridgeData.minAmount
100             );
101 
102             bytes memory depositData = abi.encode(_bridgeData.minAmount);
103             rootChainManager.depositFor(
104                 _bridgeData.receiver,
105                 _bridgeData.sendingAssetId,
106                 depositData
107             );
108         }
109 
110         emit LiFiTransferStarted(_bridgeData);
111     }
112 }
