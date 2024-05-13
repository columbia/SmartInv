1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import "@openzeppelin/contracts/utils/math/SafeCast.sol";
6 import { ILiFi } from "../Interfaces/ILiFi.sol";
7 import { ITeleportGateway } from "../Interfaces/ITeleportGateway.sol";
8 import { LibAsset } from "../Libraries/LibAsset.sol";
9 import { LibSwap } from "../Libraries/LibSwap.sol";
10 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
11 import { SwapperV2 } from "../Helpers/SwapperV2.sol";
12 import { Validatable } from "../Helpers/Validatable.sol";
13 import { InvalidSendingToken, NoSwapDataProvided } from "../Errors/GenericErrors.sol";
14 
15 /// @title MakerTeleport Facet
16 /// @author LI.FI (https://li.fi)
17 /// @notice Provides functionality for bridging through Maker Teleport
18 /// @custom:version 1.0.0
19 contract MakerTeleportFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
20     using SafeCast for uint256;
21 
22     /// Storage ///
23 
24     /// @notice The address of Teleport Gateway.
25     ITeleportGateway private immutable teleportGateway;
26 
27     /// @notice The address of DAI on the source chain.
28     address private immutable dai;
29 
30     /// @notice The chain id of destination chain.
31     uint256 private immutable dstChainId;
32 
33     /// @notice The domain of l1 network.
34     bytes32 private immutable l1Domain;
35 
36     /// Constructor ///
37 
38     /// @notice Initialize the contract.
39     /// @param _teleportGateway The address of Teleport Gateway.
40     /// @param _dai The address of DAI on the source chain.
41     /// @param _dstChainId The chain id of destination chain.
42     /// @param _l1Domain The domain of l1 network.
43     constructor(
44         ITeleportGateway _teleportGateway,
45         address _dai,
46         uint256 _dstChainId,
47         bytes32 _l1Domain
48     ) {
49         dstChainId = _dstChainId;
50         teleportGateway = _teleportGateway;
51         dai = _dai;
52         l1Domain = _l1Domain;
53     }
54 
55     /// External Methods ///
56 
57     /// @notice Bridges tokens via Maker Teleport
58     /// @param _bridgeData The core information needed for bridging
59     function startBridgeTokensViaMakerTeleport(
60         ILiFi.BridgeData memory _bridgeData
61     )
62         external
63         nonReentrant
64         validateBridgeData(_bridgeData)
65         doesNotContainSourceSwaps(_bridgeData)
66         doesNotContainDestinationCalls(_bridgeData)
67         onlyAllowDestinationChain(_bridgeData, dstChainId)
68         onlyAllowSourceToken(_bridgeData, dai)
69     {
70         LibAsset.depositAsset(dai, _bridgeData.minAmount);
71         _startBridge(_bridgeData);
72     }
73 
74     /// @notice Performs a swap before bridging via Maker Teleport
75     /// @param _bridgeData The core information needed for bridging
76     /// @param _swapData An array of swap related data for performing swaps before bridging
77     function swapAndStartBridgeTokensViaMakerTeleport(
78         ILiFi.BridgeData memory _bridgeData,
79         LibSwap.SwapData[] calldata _swapData
80     )
81         external
82         payable
83         nonReentrant
84         refundExcessNative(payable(msg.sender))
85         validateBridgeData(_bridgeData)
86         containsSourceSwaps(_bridgeData)
87         doesNotContainDestinationCalls(_bridgeData)
88         onlyAllowDestinationChain(_bridgeData, dstChainId)
89         onlyAllowSourceToken(_bridgeData, dai)
90     {
91         _bridgeData.minAmount = _depositAndSwap(
92             _bridgeData.transactionId,
93             _bridgeData.minAmount,
94             _swapData,
95             payable(msg.sender)
96         );
97 
98         _startBridge(_bridgeData);
99     }
100 
101     /// Internal Methods ///
102 
103     /// @dev Contains the business logic for the bridge via Maker Teleport
104     /// @param _bridgeData The core information needed for bridging
105     function _startBridge(ILiFi.BridgeData memory _bridgeData) internal {
106         LibAsset.maxApproveERC20(
107             IERC20(dai),
108             address(teleportGateway),
109             _bridgeData.minAmount
110         );
111 
112         teleportGateway.initiateTeleport(
113             l1Domain,
114             _bridgeData.receiver,
115             _bridgeData.minAmount.toUint128()
116         );
117 
118         emit LiFiTransferStarted(_bridgeData);
119     }
120 }
