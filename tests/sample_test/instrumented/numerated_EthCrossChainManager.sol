1 1 pragma solidity ^0.5.0;
2 
3 2 import "./../../../libs/math/SafeMath.sol";
4 3 import "./../../../libs/common/ZeroCopySource.sol";
5 4 import "./../../../libs/common/ZeroCopySink.sol";
6 5 import "./../../../libs/utils/Utils.sol";
7 6 import "./../upgrade/UpgradableECCM.sol";
8 7 import "./../libs/EthCrossChainUtils.sol";
9 8 import "./../interface/IEthCrossChainManager.sol";
10 9 import "./../interface/IEthCrossChainData.sol";
11 10 //test cross bridge
12 11 contract EthCrossChainManager is IEthCrossChainManager, UpgradableECCM {
13 12     using SafeMath for uint256;
14 
15 13     event InitGenesisBlockEvent(uint256 height, bytes rawHeader);
16 14     event ChangeBookKeeperEvent(uint256 height, bytes rawHeader);
17 15     event CrossChainEvent(address indexed sender, bytes txId, address proxyOrAssetContract, uint64 toChainId, bytes toContract, bytes rawdata);
18 16     event VerifyHeaderAndExecuteTxEvent(uint64 fromChainID, bytes toContract, bytes crossChainTxHash, bytes fromChainTxHash);
19 17     constructor(address _eccd) UpgradableECCM(_eccd) public {}
20     
21 18     /* @notice              sync Poly chain genesis block header to smart contrat
22 19     *  @dev                 this function can only be called once, nextbookkeeper of rawHeader can't be empty
23 20     *  @param rawHeader     Poly chain genesis block raw header or raw Header including switching consensus peers info
24 21     *  @return              true or false
25 22     */
26 23     function initGenesisBlock(bytes memory rawHeader, bytes memory pubKeyList) whenNotPaused public returns(bool) {
27 24         // Load Ethereum cross chain data contract
28 25         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
29    
30 26         // Parse header and convit the public keys into nextBookKeeper and compare it with header.nextBookKeeper to verify the validity of signature
31 27         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
32 28         (bytes20 nextBookKeeper, address[] memory keepers) = ECCUtils.verifyPubkey(pubKeyList);
33         
34 29         // Record current epoch start height and public keys (by storing them in address format)
35   
36         
37 30         // Fire the event
38 31         emit InitGenesisBlockEvent(header.height, rawHeader);
39 32         return true;
40 33     }
41     
42 34     /* @notice              change Poly chain consensus book keeper
43 35     *  @param rawHeader     Poly chain change book keeper block raw header
44 36     *  @param pubKeyList    Poly chain consensus nodes public key list
45 37     *  @param sigList       Poly chain consensus nodes signature list
46 38     *  @return              true or false
47 39     */
48 40     function changeBookKeeper(bytes memory rawHeader, bytes memory pubKeyList, bytes memory sigList) whenNotPaused public returns(bool) {
49 41         // Load Ethereum cross chain data contract
50 42         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
51 43         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
52         
53 44         // Make sure rawHeader.height is higher than recorded current epoch start height
54 45         uint64 curEpochStartHeight = eccd.getCurEpochStartHeight();
55     
56 46         // Ensure the rawHeader is the key header including info of switching consensus peers by containing non-empty nextBookKeeper field
57     
58 47         // Verify signature of rawHeader comes from pubKeyList
59 48         address[] memory polyChainBKs = ECCUtils.deserializeKeepers(eccd.getCurEpochConPubKeyBytes());
60 49         uint n = polyChainBKs.length;
61  
62 50         // Convert pubKeyList into ethereum address format and make sure the compound address from the converted ethereum addresses
63 51         // equals passed in header.nextBooker
64 52         (bytes20 nextBookKeeper, address[] memory keepers) = ECCUtils.verifyPubkey(pubKeyList);
65   
66 53         // update current epoch start height of Poly chain and current epoch consensus peers book keepers addresses
67   
68         
69 54         // Fire the change book keeper event
70 55         emit ChangeBookKeeperEvent(header.height, rawHeader);
71 56         return true;
72 57     }
73 
74 
75 58     /* @notice              ERC20 token cross chain to other blockchain.
76 59     *                       this function push tx event to blockchain
77 60     *  @param toChainId     Target chain id
78 61     *  @param toContract    Target smart contract address in target block chain
79 62     *  @param txData        Transaction data for target chain, include to_address, amount
80 63     *  @return              true or false
81 64     */
82 65     function crossChain(uint64 toChainId, bytes calldata toContract, bytes calldata method, bytes calldata txData) whenNotPaused external returns (bool) {
83 66         // Load Ethereum cross chain data contract
84 67         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
85         
86 68         // To help differentiate two txs, the ethTxHashIndex is increasing automatically
87 69         uint256 txHashIndex = eccd.getEthTxHashIndex();
88         
89 70         // Convert the uint256 into bytes
90 71         bytes memory paramTxHash = Utils.uint256ToBytes(txHashIndex);
91         
92 72         // Construct the makeTxParam, and put the hash info storage, to help provide proof of tx existence
93 73         bytes memory rawParam = abi.encodePacked(ZeroCopySink.WriteVarBytes(paramTxHash),
94 74             ZeroCopySink.WriteVarBytes(abi.encodePacked(sha256(abi.encodePacked(address(this), paramTxHash)))),
95 75             ZeroCopySink.WriteVarBytes(Utils.addressToBytes(msg.sender)),
96 76             ZeroCopySink.WriteUint64(toChainId),
97 77             ZeroCopySink.WriteVarBytes(toContract),
98 78             ZeroCopySink.WriteVarBytes(method),
99 79             ZeroCopySink.WriteVarBytes(txData)
100 80         );
101         
102 81         // Must save it in the storage to be included in the proof to be verified.
103  
104 82         // Fire the cross chain event denoting there is a cross chain request from Ethereum network to other public chains through Poly chain network
105 83         emit CrossChainEvent(tx.origin, paramTxHash, msg.sender, toChainId, toContract, rawParam);
106 84         return true;
107 85     }
108 86     /* @notice              Verify Poly chain header and proof, execute the cross chain tx from Poly chain to Ethereum
109 87     *  @param proof         Poly chain tx merkle proof
110 88     *  @param rawHeader     The header containing crossStateRoot to verify the above tx merkle proof
111 89     *  @param headerProof   The header merkle proof used to verify rawHeader
112 90     *  @param curRawHeader  Any header in current epoch consensus of Poly chain
113 91     *  @param headerSig     The coverted signature veriable for solidity derived from Poly chain consensus nodes' signature
114 92     *                       used to verify the validity of curRawHeader
115 93     *  @return              true or false
116 94     */
117 95     function verifyHeaderAndExecuteTx(bytes memory proof, bytes memory rawHeader, bytes memory headerProof, bytes memory curRawHeader,bytes memory headerSig) whenNotPaused public returns (bool){
118 96         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
119 97         // Load ehereum cross chain data contract
120 98         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
121         
122 99         // Get stored consensus public key bytes of current poly chain epoch and deserialize Poly chain consensus public key bytes to address[]
123 100         address[] memory polyChainBKs = ECCUtils.deserializeKeepers(eccd.getCurEpochConPubKeyBytes());
124 
125 101         uint256 curEpochStartHeight = eccd.getCurEpochStartHeight();
126 
127 102         uint n = polyChainBKs.length;
128    
129 103             // Then use curHeader.StateRoot and headerProof to verify rawHeader.CrossStateRoot
130 104             ECCUtils.Header memory curHeader = ECCUtils.deserializeHeader(curRawHeader);
131 105             bytes memory proveValue = ECCUtils.merkleProve(headerProof, curHeader.blockRoot);
132       
133 106         // Through rawHeader.CrossStatesRoot, the toMerkleValue or cross chain msg can be verified and parsed from proof
134 107         bytes memory toMerkleValueBs = ECCUtils.merkleProve(proof, header.crossStatesRoot);
135         
136 108         // Parse the toMerkleValue struct and make sure the tx has not been processed, then mark this tx as processed
137 109         ECCUtils.ToMerkleValue memory toMerkleValue = ECCUtils.deserializeMerkleValue(toMerkleValueBs);
138      
139   
140 110         // Obtain the targeting contract, so that Ethereum cross chain manager contract can trigger the executation of cross chain tx on Ethereum side
141 111         address toContract = Utils.bytesToAddress(toMerkleValue.makeTxParam.toContract);
142         
143     
144 112         // Fire the cross chain event denoting the executation of cross chain tx is successful,
145 113         // and this tx is coming from other public chains to current Ethereum network
146 114         emit VerifyHeaderAndExecuteTxEvent(toMerkleValue.fromChainID, toMerkleValue.makeTxParam.toContract, toMerkleValue.txHash, toMerkleValue.makeTxParam.txHash);
147 
148 115         return true;
149 116     }
150     
151 117     /* @notice                  Dynamically invoke the targeting contract, and trigger executation of cross chain tx on Ethereum side
152 118     *  @param _toContract       The targeting contract that will be invoked by the Ethereum Cross Chain Manager contract
153 119     *  @param _method           At which method will be invoked within the targeting contract
154 120     *  @param _args             The parameter that will be passed into the targeting contract
155 121     *  @param _fromContractAddr From chain smart contract address
156 122     *  @param _fromChainId      Indicate from which chain current cross chain tx comes 
157 123     *  @return                  true or false
158 124     */
159 125     function _executeCrossChainTx(address _toContract, bytes memory _method, bytes memory _args, bytes memory _fromContractAddr, uint64 _fromChainId) internal returns (bool){
160 126         // Ensure the targeting contract gonna be invoked is indeed a contract rather than a normal account address
161     
162 127         bytes memory returnData;
163 128         bool success;
164         
165 129         // The returnData will be bytes32, the last byte must be 01;
166 130         (success, returnData) = _toContract.call(abi.encodePacked(bytes4(keccak256(abi.encodePacked(_method, "(bytes,bytes,uint64)"))), abi.encode(_args, _fromContractAddr, _fromChainId)));
167         
168 131         // Ensure the executation is successful
169 
170         
171 132         // Ensure the returned value is true
172   
173 133         (bool res,) = ZeroCopySource.NextBool(returnData, 31);
174         
175 134         return true;
176 135     }
177 136 }