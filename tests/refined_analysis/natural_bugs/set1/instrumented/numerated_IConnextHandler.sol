1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IConnextHandler {
5     /// @notice These are the call parameters that will remain constant between the
6     /// two chains. They are supplied on `xcall` and should be asserted on `execute`
7     /// @property to - The account that receives funds, in the event of a crosschain call,
8     /// will receive funds if the call fails.
9     /// @param to - The address you are sending funds (and potentially data) to
10     /// @param callData - The data to execute on the receiving chain. If no crosschain call is needed, then leave empty.
11     /// @param originDomain - The originating domain (i.e. where `xcall` is called). Must match nomad domain schema
12     /// @param destinationDomain - The final domain (i.e. where `execute` / `reconcile` are called). Must match nomad domain schema
13     /// @param agent - An address who can execute txs on behalf of `to`, in addition to allowing relayers
14     /// @param recovery - The address to send funds to if your `Executor.execute call` fails
15     /// @param forceSlow - If true, will take slow liquidity path even if it is not a permissioned call
16     /// @param receiveLocal - If true, will use the local nomad asset on the destination instead of adopted.
17     /// @param callback - The address on the origin domain of the callback contract
18     /// @param callbackFee - The relayer fee to execute the callback
19     /// @param relayerFee - The amount of relayer fee the tx called xcall with
20     /// @param slippageTol - Max bps of original due to slippage (i.e. would be 9995 to tolerate .05% slippage)
21     struct CallParams {
22         address to;
23         bytes callData;
24         uint32 originDomain;
25         uint32 destinationDomain;
26         address agent;
27         address recovery;
28         bool forceSlow;
29         bool receiveLocal;
30         address callback;
31         uint256 callbackFee;
32         uint256 relayerFee;
33         uint256 slippageTol;
34     }
35 
36     /// @notice The arguments you supply to the `xcall` function called by user on origin domain
37     /// @param params - The CallParams. These are consistent across sending and receiving chains
38     /// @param transactingAsset - The asset the caller sent with the transfer. Can be the adopted, canonical,
39     /// or the representational asset
40     /// @param transactingAmount - The amount of transferring asset supplied by the user in the `xcall`
41     /// @param originMinOut - Minimum amount received on swaps for adopted <> local on origin chain
42     struct XCallArgs {
43         CallParams params;
44         address transactingAsset; // Could be adopted, local, or wrapped
45         uint256 transactingAmount;
46         uint256 originMinOut;
47     }
48 
49     function xcall(
50         uint32 destination,
51         address recipient,
52         address tokenAddress,
53         address delegate,
54         uint256 amount,
55         uint256 slippage,
56         bytes memory callData
57     ) external payable returns (bytes32);
58 
59     function xcall(
60         uint32 destination,
61         address recipient,
62         address tokenAddress,
63         address delegate,
64         uint256 amount,
65         uint256 slippage,
66         bytes memory callData,
67         uint256 _relayerFee
68     ) external returns (bytes32);
69 }
