1 pragma solidity ^0.5.0;
2 import "./../../../libs/ownership/Ownable.sol";
3 import "./../../../libs/lifecycle/Pausable.sol";
4 import "./../interface/IEthCrossChainData.sol";
5 
6 contract EthCrossChainData is IEthCrossChainData, Ownable, Pausable{
7     /*
8      Ethereum cross chain tx hash indexed by the automatically increased index.
9      This map exists for the reason that Poly chain can verify the existence of 
10      cross chain request tx coming from Ethereum
11     */
12     mapping(uint256 => bytes32) public EthToPolyTxHashMap;
13     // This index records the current Map length
14     uint256 public EthToPolyTxHashIndex;
15 
16     /* 
17      When Poly chain switches the consensus epoch book keepers, the consensus peers public keys of Poly chain should be 
18      changed into no-compressed version so that solidity smart contract can convert it to address type and 
19      verify the signature derived from Poly chain account signature.
20      ConKeepersPkBytes means Consensus book Keepers Public Key Bytes
21     */
22     bytes public ConKeepersPkBytes;
23     
24     // CurEpochStartHeight means Current Epoch Start Height of Poly chain block
25     uint32 public CurEpochStartHeight;
26     
27     // Record the from chain txs that have been processed
28     mapping(uint64 => mapping(bytes32 => bool)) FromChainTxExist;
29     
30     // Extra map for the usage of future potentially
31     mapping(bytes32 => mapping(bytes32 => bytes)) public ExtraData;
32     
33     // Store Current Epoch Start Height of Poly chain block
34     function putCurEpochStartHeight(uint32 curEpochStartHeight) public whenNotPaused onlyOwner returns (bool) {
35         CurEpochStartHeight = curEpochStartHeight;
36         return true;
37     }
38 
39     // Get Current Epoch Start Height of Poly chain block
40     function getCurEpochStartHeight() public view returns (uint32) {
41         return CurEpochStartHeight;
42     }
43 
44     // Store Consensus book Keepers Public Key Bytes
45     function putCurEpochConPubKeyBytes(bytes memory curEpochPkBytes) public whenNotPaused onlyOwner returns (bool) {
46         ConKeepersPkBytes = curEpochPkBytes;
47         return true;
48     }
49 
50     // Get Consensus book Keepers Public Key Bytes
51     function getCurEpochConPubKeyBytes() public view returns (bytes memory) {
52         return ConKeepersPkBytes;
53     }
54 
55     // Mark from chain tx fromChainTx as exist or processed
56     function markFromChainTxExist(uint64 fromChainId, bytes32 fromChainTx) public whenNotPaused onlyOwner returns (bool) {
57         FromChainTxExist[fromChainId][fromChainTx] = true;
58         return true;
59     }
60 
61     // Check if from chain tx fromChainTx has been processed before
62     function checkIfFromChainTxExist(uint64 fromChainId, bytes32 fromChainTx) public view returns (bool) {
63         return FromChainTxExist[fromChainId][fromChainTx];
64     }
65 
66     // Get current recorded index of cross chain txs requesting from Ethereum to other public chains
67     // in order to help cross chain manager contract differenciate two cross chain tx requests
68     function getEthTxHashIndex() public view returns (uint256) {
69         return EthToPolyTxHashIndex;
70     }
71 
72     // Store Ethereum cross chain tx hash, increase the index record by 1
73     function putEthTxHash(bytes32 ethTxHash) public whenNotPaused onlyOwner returns (bool) {
74         EthToPolyTxHashMap[EthToPolyTxHashIndex] = ethTxHash;
75         EthToPolyTxHashIndex = EthToPolyTxHashIndex + 1;
76         return true;
77     }
78 
79     // Get Ethereum cross chain tx hash indexed by ethTxHashIndex
80     function getEthTxHash(uint256 ethTxHashIndex) public view returns (bytes32) {
81         return EthToPolyTxHashMap[ethTxHashIndex];
82     }
83 
84     // Store extra data, which may be used in the future
85     function putExtraData(bytes32 key1, bytes32 key2, bytes memory value) public whenNotPaused onlyOwner returns (bool) {
86         ExtraData[key1][key2] = value;
87         return true;
88     }
89     // Get extra data, which may be used in the future
90     function getExtraData(bytes32 key1, bytes32 key2) public view returns (bytes memory) {
91         return ExtraData[key1][key2];
92     }
93     
94     function pause() onlyOwner whenNotPaused public returns (bool) {
95         _pause();
96         return true;
97     }
98     
99     function unpause() onlyOwner whenPaused public returns (bool) {
100         _unpause();
101         return true;
102     }
103 }