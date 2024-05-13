1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IXDaiBridge } from "../Interfaces/IXDaiBridge.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { InvalidSendingToken, NoSwapDataProvided } from "../Errors/GenericErrors.sol";
9 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
10 import { Validatable } from "../Helpers/Validatable.sol";
11 
12 /// @title Gnosis Bridge Facet
13 /// @author LI.FI (https://li.fi)
14 /// @notice Provides functionality for bridging through XDaiBridge
15 /// @custom:version 1.0.0
16 contract GnosisBridgeFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
17     /// Storage ///
18 
19     /// @notice The DAI address on the source chain.
20     address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
21 
22     /// @notice The chain id of Gnosis.
23     uint64 private constant GNOSIS_CHAIN_ID = 100;
24 
25     /// @notice The contract address of the xdai bridge on the source chain.
26     IXDaiBridge private immutable xDaiBridge;
27 
28     /// Constructor ///
29 
30     /// @notice Initialize the contract.
31     /// @param _xDaiBridge The contract address of the xdai bridge on the source chain.
32     constructor(IXDaiBridge _xDaiBridge) {
33         xDaiBridge = _xDaiBridge;
34     }
35 
36     /// External Methods ///
37 
38     /// @notice Bridges tokens via XDaiBridge
39     /// @param _bridgeData the core information needed for bridging
40     function startBridgeTokensViaXDaiBridge(
41         ILiFi.BridgeData memory _bridgeData
42     )
43         external
44         nonReentrant
45         doesNotContainSourceSwaps(_bridgeData)
46         doesNotContainDestinationCalls(_bridgeData)
47         validateBridgeData(_bridgeData)
48         onlyAllowDestinationChain(_bridgeData, GNOSIS_CHAIN_ID)
49         onlyAllowSourceToken(_bridgeData, DAI)
50     {
51         LibAsset.depositAsset(DAI, _bridgeData.minAmount);
52         _startBridge(_bridgeData);
53     }
54 
55     /// @notice Performs a swap before bridging via XDaiBridge
56     /// @param _bridgeData the core information needed for bridging
57     /// @param _swapData an object containing swap related data to perform swaps before bridging
58     function swapAndStartBridgeTokensViaXDaiBridge(
59         ILiFi.BridgeData memory _bridgeData,
60         LibSwap.SwapData[] calldata _swapData
61     )
62         external
63         payable
64         nonReentrant
65         refundExcessNative(payable(msg.sender))
66         containsSourceSwaps(_bridgeData)
67         doesNotContainDestinationCalls(_bridgeData)
68         validateBridgeData(_bridgeData)
69         onlyAllowDestinationChain(_bridgeData, GNOSIS_CHAIN_ID)
70         onlyAllowSourceToken(_bridgeData, DAI)
71     {
72         _bridgeData.minAmount = _depositAndSwap(
73             _bridgeData.transactionId,
74             _bridgeData.minAmount,
75             _swapData,
76             payable(msg.sender)
77         );
78 
79         _startBridge(_bridgeData);
80     }
81 
82     /// Private Methods ///
83 
84     /// @dev Contains the business logic for the bridge via XDaiBridge
85     /// @param _bridgeData the core information needed for bridging
86     function _startBridge(ILiFi.BridgeData memory _bridgeData) private {
87         LibAsset.maxApproveERC20(
88             IERC20(DAI),
89             address(xDaiBridge),
90             _bridgeData.minAmount
91         );
92         xDaiBridge.relayTokens(_bridgeData.receiver, _bridgeData.minAmount);
93         emit LiFiTransferStarted(_bridgeData);
94     }
95 }
