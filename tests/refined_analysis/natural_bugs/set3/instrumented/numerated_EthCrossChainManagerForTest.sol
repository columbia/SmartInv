1 pragma solidity ^0.5.16;
2 
3 import "./../../../libs/math/SafeMath.sol";
4 import "./../../../libs/common/ZeroCopySource.sol";
5 import "./../../../libs/common/ZeroCopySink.sol";
6 import "./../../../libs/utils/Utils.sol";
7 import "./../upgrade/UpgradableECCM.sol";
8 import "./../libs/EthCrossChainUtils.sol";
9 import "./../interface/IEthCrossChainManager.sol";
10 import "./../interface/IEthCrossChainData.sol";
11 contract EthCrossChainManagerForTest is IEthCrossChainManager, UpgradableECCM {
12     using SafeMath for uint256;
13 
14     event InitGenesisBlockEvent(uint256 height, bytes rawHeader);
15     event ChangeBookKeeperEvent(uint256 height, bytes rawHeader);
16     event CrossChainEvent(address indexed sender, bytes txId, address proxyOrAssetContract, uint64 toChainId, bytes toContract, bytes rawdata);
17     event VerifyHeaderAndExecuteTxEvent(uint64 fromChainID, bytes toContract, bytes crossChainTxHash, bytes fromChainTxHash);
18     constructor(
19         address _eccd, 
20         uint64 _chainId
21     ) UpgradableECCM(_eccd,_chainId) public {}
22 
23     /* @notice              sync Poly chain genesis block header to smart contrat
24     *  @dev                 this function can only be called once, nextbookkeeper of rawHeader can't be empty
25     *  @param rawHeader     Poly chain genesis block raw header or raw Header including switching consensus peers info
26     *  @return              true or false
27     */
28     function initGenesisBlock(bytes memory rawHeader, bytes memory pubKeyList) whenNotPaused public returns(bool) {
29         // Load Ethereum cross chain data contract
30         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
31         
32         // Make sure the contract has not been initialized before
33         require(eccd.getCurEpochConPubKeyBytes().length == 0, "EthCrossChainData contract has already been initialized!");
34         
35         // Parse header and convit the public keys into nextBookKeeper and compare it with header.nextBookKeeper to verify the validity of signature
36         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
37         (bytes20 nextBookKeeper, address[] memory keepers) = ECCUtils.verifyPubkey(pubKeyList);
38         require(header.nextBookkeeper == nextBookKeeper, "NextBookers illegal");
39         
40         // Record current epoch start height and public keys (by storing them in address format)
41         require(eccd.putCurEpochStartHeight(header.height), "Save Poly chain current epoch start height to Data contract failed!");
42         require(eccd.putCurEpochConPubKeyBytes(ECCUtils.serializeKeepers(keepers)), "Save Poly chain current epoch book keepers to Data contract failed!");
43         
44         // Fire the event
45         emit InitGenesisBlockEvent(header.height, rawHeader);
46         return true;
47     }
48     
49     /* @notice              change Poly chain consensus book keeper
50     *  @param rawHeader     Poly chain change book keeper block raw header
51     *  @param pubKeyList    Poly chain consensus nodes public key list
52     *  @param sigList       Poly chain consensus nodes signature list
53     *  @return              true or false
54     */
55     function changeBookKeeper(bytes memory rawHeader, bytes memory pubKeyList, bytes memory sigList) whenNotPaused public returns(bool) {
56         // Load Ethereum cross chain data contract
57         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
58         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
59         
60         // Make sure rawHeader.height is higher than recorded current epoch start height
61         uint64 curEpochStartHeight = eccd.getCurEpochStartHeight();
62         require(header.height > curEpochStartHeight, "The height of header is lower than current epoch start height!");
63         
64         // Ensure the rawHeader is the key header including info of switching consensus peers by containing non-empty nextBookKeeper field
65         require(header.nextBookkeeper != bytes20(0), "The nextBookKeeper of header is empty");
66         
67         // Verify signature of rawHeader comes from pubKeyList
68         address[] memory polyChainBKs = ECCUtils.deserializeKeepers(eccd.getCurEpochConPubKeyBytes());
69         uint n = polyChainBKs.length;
70         require(ECCUtils.verifySig(rawHeader, sigList, polyChainBKs, n - (n - 1) / 3), "Verify signature failed!");
71         
72         // Convert pubKeyList into ethereum address format and make sure the compound address from the converted ethereum addresses
73         // equals passed in header.nextBooker
74         (bytes20 nextBookKeeper, address[] memory keepers) = ECCUtils.verifyPubkey(pubKeyList);
75         require(header.nextBookkeeper == nextBookKeeper, "NextBookers illegal");
76         
77         // update current epoch start height of Poly chain and current epoch consensus peers book keepers addresses
78         require(eccd.putCurEpochStartHeight(header.height), "Save MC LatestHeight to Data contract failed!");
79         require(eccd.putCurEpochConPubKeyBytes(ECCUtils.serializeKeepers(keepers)), "Save Poly chain book keepers bytes to Data contract failed!");
80         
81         // Fire the change book keeper event
82         emit ChangeBookKeeperEvent(header.height, rawHeader);
83         return true;
84     }
85 
86 
87     /* @notice              ERC20 token cross chain to other blockchain.
88     *                       this function push tx event to blockchain
89     *  @param toChainId     Target chain id
90     *  @param toContract    Target smart contract address in target block chain
91     *  @param txData        Transaction data for target chain, include to_address, amount
92     *  @return              true or false
93     */
94     function crossChain(uint64 toChainId, bytes calldata toContract, bytes calldata method, bytes calldata txData) whenNotPaused external returns (bool) {
95         
96         // Load Ethereum cross chain data contract
97         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
98         
99         // To help differentiate two txs, the ethTxHashIndex is increasing automatically
100         uint256 txHashIndex = eccd.getEthTxHashIndex();
101         
102         // Convert the uint256 into bytes
103         bytes memory paramTxHash = Utils.uint256ToBytes(txHashIndex);
104         
105         // Construct the makeTxParam, and put the hash info storage, to help provide proof of tx existence
106         bytes memory rawParam = abi.encodePacked(ZeroCopySink.WriteVarBytes(paramTxHash),
107             ZeroCopySink.WriteVarBytes(abi.encodePacked(sha256(abi.encodePacked(address(this), paramTxHash)))),
108             ZeroCopySink.WriteVarBytes(Utils.addressToBytes(msg.sender)),
109             ZeroCopySink.WriteUint64(toChainId),
110             ZeroCopySink.WriteVarBytes(toContract),
111             ZeroCopySink.WriteVarBytes(method),
112             ZeroCopySink.WriteVarBytes(txData)
113         );
114         
115         // Must save it in the storage to be included in the proof to be verified.
116         require(eccd.putEthTxHash(keccak256(rawParam)), "Save ethTxHash by index to Data contract failed!");
117         
118         // Fire the cross chain event denoting there is a cross chain request from Ethereum network to other public chains through Poly chain network
119         emit CrossChainEvent(tx.origin, paramTxHash, msg.sender, toChainId, toContract, rawParam);
120         return true;
121     }
122     /* @notice              Verify Poly chain header and proof, execute the cross chain tx from Poly chain to Ethereum
123     *  @param proof         Poly chain tx merkle proof
124     *  @param rawHeader     The header containing crossStateRoot to verify the above tx merkle proof
125     *  @param headerProof   The header merkle proof used to verify rawHeader
126     *  @param curRawHeader  Any header in current epoch consensus of Poly chain
127     *  @param headerSig     The coverted signature veriable for solidity derived from Poly chain consensus nodes' signature
128     *                       used to verify the validity of curRawHeader
129     *  @return              true or false
130     */
131     function verifyHeaderAndExecuteTx(bytes memory proof, bytes memory rawHeader, bytes memory headerProof, bytes memory curRawHeader,bytes memory headerSig) whenNotPaused public returns (bool){
132         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
133         // Load ehereum cross chain data contract
134         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
135         
136         // Get stored consensus public key bytes of current poly chain epoch and deserialize Poly chain consensus public key bytes to address[]
137         address[] memory polyChainBKs = ECCUtils.deserializeKeepers(eccd.getCurEpochConPubKeyBytes());
138 
139         uint256 curEpochStartHeight = eccd.getCurEpochStartHeight();
140 
141         uint n = polyChainBKs.length;
142         if (header.height >= curEpochStartHeight) {
143             // It's enough to verify rawHeader signature
144             require(ECCUtils.verifySig(rawHeader, headerSig, polyChainBKs, n - ( n - 1) / 3), "Verify poly chain header signature failed!");
145         } else {
146             // We need to verify the signature of curHeader 
147             require(ECCUtils.verifySig(curRawHeader, headerSig, polyChainBKs, n - ( n - 1) / 3), "Verify poly chain current epoch header signature failed!");
148 
149             // Then use curHeader.StateRoot and headerProof to verify rawHeader.CrossStateRoot
150             ECCUtils.Header memory curHeader = ECCUtils.deserializeHeader(curRawHeader);
151             bytes memory proveValue = ECCUtils.merkleProve(headerProof, curHeader.blockRoot);
152             require(ECCUtils.getHeaderHash(rawHeader) == Utils.bytesToBytes32(proveValue), "verify header proof failed!");
153         }
154         
155         // Through rawHeader.CrossStatesRoot, the toMerkleValue or cross chain msg can be verified and parsed from proof
156         bytes memory toMerkleValueBs = ECCUtils.merkleProve(proof, header.crossStatesRoot);
157         
158         // Parse the toMerkleValue struct and make sure the tx has not been processed, then mark this tx as processed
159         ECCUtils.ToMerkleValue memory toMerkleValue = ECCUtils.deserializeMerkleValue(toMerkleValueBs);
160         require(!eccd.checkIfFromChainTxExist(toMerkleValue.fromChainID, Utils.bytesToBytes32(toMerkleValue.txHash)), "the transaction has been executed!");
161         require(eccd.markFromChainTxExist(toMerkleValue.fromChainID, Utils.bytesToBytes32(toMerkleValue.txHash)), "Save crosschain tx exist failed!");
162         
163         // Ethereum ChainId is 2, we need to check the transaction is for Ethereum network
164         require(toMerkleValue.makeTxParam.toChainId == chainId, "This Tx is not aiming at this network!");
165         
166         // Obtain the targeting contract, so that Ethereum cross chain manager contract can trigger the executation of cross chain tx on Ethereum side
167         address toContract = Utils.bytesToAddress(toMerkleValue.makeTxParam.toContract);
168         require(toContract != EthCrossChainDataAddress, "No eccd here!");
169 
170         //TODO: check this part to make sure we commit the next line when doing local net UT test
171         require(_executeCrossChainTx(toContract, toMerkleValue.makeTxParam.method, toMerkleValue.makeTxParam.args, toMerkleValue.makeTxParam.fromContract, toMerkleValue.fromChainID), "Execute CrossChain Tx failed!");
172 
173         // Fire the cross chain event denoting the executation of cross chain tx is successful,
174         // and this tx is coming from other public chains to current Ethereum network
175         emit VerifyHeaderAndExecuteTxEvent(toMerkleValue.fromChainID, toMerkleValue.makeTxParam.toContract, toMerkleValue.txHash, toMerkleValue.makeTxParam.txHash);
176 
177         return true;
178     }
179     
180     /* @notice                  Dynamically invoke the targeting contract, and trigger executation of cross chain tx on Ethereum side
181     *  @param _toContract       The targeting contract that will be invoked by the Ethereum Cross Chain Manager contract
182     *  @param _method           At which method will be invoked within the targeting contract
183     *  @param _args             The parameter that will be passed into the targeting contract
184     *  @param _fromContractAddr From chain smart contract address
185     *  @param _fromChainId      Indicate from which chain current cross chain tx comes 
186     *  @return                  true or false
187     */
188     function _executeCrossChainTx(address _toContract, bytes memory _method, bytes memory _args, bytes memory _fromContractAddr, uint64 _fromChainId) internal returns (bool){
189         // // Ensure the targeting contract gonna be invoked is indeed a contract rather than a normal account address
190         // require(Utils.isContract(_toContract), "The passed in address is not a contract!");
191         // bytes memory returnData;
192         // bool success;
193         
194         // // The returnData will be bytes32, the last byte must be 01;
195         // (success, returnData) = _toContract.call(abi.encodePacked(bytes4(keccak256(abi.encodePacked(_method, "(bytes,bytes,uint64)"))), abi.encode(_args, _fromContractAddr, _fromChainId)));
196         
197         // // Ensure the executation is successful
198         // require(success == true, "EthCrossChain call business contract failed");
199         
200         // // Ensure the returned value is true
201         // require(returnData.length != 0, "No return value from business contract!");
202         // (bool res,) = ZeroCopySource.NextBool(returnData, 31);
203         // require(res == true, "EthCrossChain call business contract return is not true");
204         
205         return true;
206     }
207 }