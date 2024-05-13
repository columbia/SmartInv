1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.17;
3 
4 interface ITransactionManager {
5     // Structs
6 
7     // Holds all data that is constant between sending and
8     // receiving chains. The hash of this is what gets signed
9     // to ensure the signature can be used on both chains.
10     struct InvariantTransactionData {
11         address receivingChainTxManagerAddress;
12         address user;
13         address router;
14         address initiator; // msg.sender of sending side
15         address sendingAssetId;
16         address receivingAssetId;
17         address sendingChainFallback; // funds sent here on cancel
18         address receivingAddress;
19         address callTo;
20         uint256 sendingChainId;
21         uint256 receivingChainId;
22         bytes32 callDataHash; // hashed to prevent free option
23         bytes32 transactionId;
24     }
25 
26     // All Transaction data, constant and variable
27     struct TransactionData {
28         address receivingChainTxManagerAddress;
29         address user;
30         address router;
31         address initiator; // msg.sender of sending side
32         address sendingAssetId;
33         address receivingAssetId;
34         address sendingChainFallback;
35         address receivingAddress;
36         address callTo;
37         bytes32 callDataHash;
38         bytes32 transactionId;
39         uint256 sendingChainId;
40         uint256 receivingChainId;
41         uint256 amount;
42         uint256 expiry;
43         uint256 preparedBlockNumber; // Needed for removal of active blocks on fulfill/cancel
44     }
45 
46     /**
47      * Arguments for calling prepare()
48      * @param invariantData The data for a crosschain transaction that will
49      *                      not change between sending and receiving chains.
50      *                      The hash of this data is used as the key to store
51      *                      the inforamtion that does change between chains
52      *                      (amount,expiry,preparedBlock) for verification
53      * @param amount The amount of the transaction on this chain
54      * @param expiry The block.timestamp when the transaction will no longer be
55      *               fulfillable and is freely cancellable on this chain
56      * @param encryptedCallData The calldata to be executed when the tx is
57      *                          fulfilled. Used in the function to allow the user
58      *                          to reconstruct the tx from events. Hash is stored
59      *                          onchain to prevent shenanigans.
60      * @param encodedBid The encoded bid that was accepted by the user for this
61      *                   crosschain transfer. It is supplied as a param to the
62      *                   function but is only used in event emission
63      * @param bidSignature The signature of the bidder on the encoded bid for
64      *                     this transaction. Only used within the function for
65      *                     event emission. The validity of the bid and
66      *                     bidSignature are enforced offchain
67      * @param encodedMeta The meta for the function
68      */
69     struct PrepareArgs {
70         InvariantTransactionData invariantData;
71         uint256 amount;
72         uint256 expiry;
73         bytes encryptedCallData;
74         bytes encodedBid;
75         bytes bidSignature;
76         bytes encodedMeta;
77     }
78 
79     // called in the following order (in happy case)
80     // 1. prepare by user on sending chain
81     function prepare(
82         PrepareArgs calldata args
83     ) external payable returns (TransactionData memory);
84 }
