1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface ILiFi {
5     /// Structs ///
6 
7     struct BridgeData {
8         bytes32 transactionId;
9         string bridge;
10         string integrator;
11         address referrer;
12         address sendingAssetId;
13         address receiver;
14         uint256 minAmount;
15         uint256 destinationChainId;
16         bool hasSourceSwaps;
17         bool hasDestinationCall;
18     }
19 
20     /// Events ///
21 
22     event LiFiTransferStarted(ILiFi.BridgeData bridgeData);
23 
24     event LiFiTransferCompleted(
25         bytes32 indexed transactionId,
26         address receivingAssetId,
27         address receiver,
28         uint256 amount,
29         uint256 timestamp
30     );
31 
32     event LiFiTransferRecovered(
33         bytes32 indexed transactionId,
34         address receivingAssetId,
35         address receiver,
36         uint256 amount,
37         uint256 timestamp
38     );
39 
40     event LiFiGenericSwapCompleted(
41         bytes32 indexed transactionId,
42         string integrator,
43         string referrer,
44         address receiver,
45         address fromAssetId,
46         address toAssetId,
47         uint256 fromAmount,
48         uint256 toAmount
49     );
50 
51     // Deprecated but kept here to include in ABI to parse historic events
52     event LiFiSwappedGeneric(
53         bytes32 indexed transactionId,
54         string integrator,
55         string referrer,
56         address fromAssetId,
57         address toAssetId,
58         uint256 fromAmount,
59         uint256 toAmount
60     );
61 }
