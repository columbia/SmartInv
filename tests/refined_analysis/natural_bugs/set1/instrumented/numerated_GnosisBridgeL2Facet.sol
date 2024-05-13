1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IXDaiBridgeL2 } from "../Interfaces/IXDaiBridgeL2.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { InvalidSendingToken, NoSwapDataProvided } from "../Errors/GenericErrors.sol";
9 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
10 import { Validatable } from "../Helpers/Validatable.sol";
11 
12 /// @title Gnosis Bridge Facet on Gnosis Chain
13 /// @author LI.FI (https://li.fi)
14 /// @notice Provides functionality for bridging through XDaiBridge
15 /// @custom:version 1.0.0
16 contract GnosisBridgeL2Facet is
17     ILiFi,
18     ReentrancyGuard,
19     SwapperV2,
20     Validatable
21 {
22     /// Storage ///
23 
24     /// @notice The xDAI address on the source chain.
25     address private constant XDAI = address(0);
26 
27     /// @notice The chain id of Ethereum Mainnet.
28     uint64 private constant ETHEREUM_CHAIN_ID = 1;
29 
30     /// @notice The contract address of the xdai bridge on the source chain.
31     IXDaiBridgeL2 private immutable xDaiBridge;
32 
33     /// Constructor ///
34 
35     /// @notice Initialize the contract.
36     /// @param _xDaiBridge The contract address of the xdai bridge on the source chain.
37     constructor(IXDaiBridgeL2 _xDaiBridge) {
38         xDaiBridge = _xDaiBridge;
39     }
40 
41     /// External Methods ///
42 
43     /// @notice Bridges tokens via XDaiBridge
44     /// @param _bridgeData the core information needed for bridging
45     function startBridgeTokensViaXDaiBridge(
46         ILiFi.BridgeData memory _bridgeData
47     )
48         external
49         payable
50         nonReentrant
51         refundExcessNative(payable(msg.sender))
52         doesNotContainSourceSwaps(_bridgeData)
53         doesNotContainDestinationCalls(_bridgeData)
54         validateBridgeData(_bridgeData)
55         onlyAllowDestinationChain(_bridgeData, ETHEREUM_CHAIN_ID)
56         onlyAllowSourceToken(_bridgeData, XDAI)
57     {
58         _startBridge(_bridgeData);
59     }
60 
61     /// @notice Performs a swap before bridging via XDaiBridge
62     /// @param _bridgeData the core information needed for bridging
63     /// @param _swapData an object containing swap related data to perform swaps before bridging
64     function swapAndStartBridgeTokensViaXDaiBridge(
65         ILiFi.BridgeData memory _bridgeData,
66         LibSwap.SwapData[] calldata _swapData
67     )
68         external
69         payable
70         nonReentrant
71         refundExcessNative(payable(msg.sender))
72         containsSourceSwaps(_bridgeData)
73         doesNotContainDestinationCalls(_bridgeData)
74         validateBridgeData(_bridgeData)
75         onlyAllowDestinationChain(_bridgeData, ETHEREUM_CHAIN_ID)
76         onlyAllowSourceToken(_bridgeData, XDAI)
77     {
78         _bridgeData.minAmount = _depositAndSwap(
79             _bridgeData.transactionId,
80             _bridgeData.minAmount,
81             _swapData,
82             payable(msg.sender)
83         );
84 
85         _startBridge(_bridgeData);
86     }
87 
88     /// Private Methods ///
89 
90     /// @dev Contains the business logic for the bridge via XDaiBridge
91     /// @param _bridgeData the core information needed for bridging
92     function _startBridge(ILiFi.BridgeData memory _bridgeData) private {
93         xDaiBridge.relayTokens{ value: _bridgeData.minAmount }(
94             _bridgeData.receiver
95         );
96         emit LiFiTransferStarted(_bridgeData);
97     }
98 }
