1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 import "./../../../libs/math/SafeMath.sol";
5 import "./../../../libs/common/ZeroCopySource.sol";
6 import "./../../../libs/common/ZeroCopySink.sol";
7 import "./../../../libs/utils/Utils.sol";
8 import "./../upgrade/UpgradableECCM.sol";
9 import "./../libs/EthCrossChainUtils.sol";
10 import "./../interface/IEthCrossChainManager.sol";
11 import "./../interface/IEthCrossChainData.sol";
12 contract EthCrossChainManager is IEthCrossChainManager, UpgradableECCM {
13     using SafeMath for uint256;
14     
15     address public whiteLister;
16     mapping(address => bool) public whiteListFromContract;
17     mapping(address => mapping(bytes => bool)) public whiteListContractMethodMap;
18 
19     event InitGenesisBlockEvent(uint256 height, bytes rawHeader);
20     event ChangeBookKeeperEvent(uint256 height, bytes rawHeader);
21     event CrossChainEvent(address indexed sender, bytes txId, address proxyOrAssetContract, uint64 toChainId, bytes toContract, bytes rawdata);
22     event VerifyHeaderAndExecuteTxEvent(uint64 fromChainID, bytes toContract, bytes crossChainTxHash, bytes fromChainTxHash);
23     constructor(
24         address _eccd, 
25         uint64 _chainId, 
26         address[] memory fromContractWhiteList, 
27         bytes[] memory contractMethodWhiteList
28     ) UpgradableECCM(_eccd,_chainId) public {
29         whiteLister = msg.sender;
30         for (uint i=0;i<fromContractWhiteList.length;i++) {
31             whiteListFromContract[fromContractWhiteList[i]] = true;
32         }
33         for (uint i=0;i<contractMethodWhiteList.length;i++) {
34             (address toContract,bytes[] memory methods) = abi.decode(contractMethodWhiteList[i],(address,bytes[]));
35             for (uint j=0;j<methods.length;j++) {
36                 whiteListContractMethodMap[toContract][methods[j]] = true;
37             }
38         }
39     }
40     
41     modifier onlyWhiteLister() {
42         require(msg.sender == whiteLister, "Not whiteLister");
43         _;
44     }
45 
46     function setWhiteLister(address newWL) public onlyWhiteLister {
47         require(newWL!=address(0), "Can not transfer to address(0)");
48         whiteLister = newWL;
49     }
50     
51     function setFromContractWhiteList(address[] memory fromContractWhiteList) public onlyWhiteLister {
52         for (uint i=0;i<fromContractWhiteList.length;i++) {
53             whiteListFromContract[fromContractWhiteList[i]] = true;
54         }
55     }
56     
57     function removeFromContractWhiteList(address[] memory fromContractWhiteList) public onlyWhiteLister {
58         for (uint i=0;i<fromContractWhiteList.length;i++) {
59             whiteListFromContract[fromContractWhiteList[i]] = false;
60         }
61     }
62     
63     function setContractMethodWhiteList(bytes[] memory contractMethodWhiteList) public onlyWhiteLister {
64         for (uint i=0;i<contractMethodWhiteList.length;i++) {
65             (address toContract,bytes[] memory methods) = abi.decode(contractMethodWhiteList[i],(address,bytes[]));
66             for (uint j=0;j<methods.length;j++) {
67                 whiteListContractMethodMap[toContract][methods[j]] = true;
68             }
69         }
70     }
71     
72     function removeContractMethodWhiteList(bytes[] memory contractMethodWhiteList) public onlyWhiteLister {
73         for (uint i=0;i<contractMethodWhiteList.length;i++) {
74             (address toContract,bytes[] memory methods) = abi.decode(contractMethodWhiteList[i],(address,bytes[]));
75             for (uint j=0;j<methods.length;j++) {
76                 whiteListContractMethodMap[toContract][methods[j]] = false;
77             }
78         }
79     }
80 
81     /* @notice              sync Poly chain genesis block header to smart contrat
82     *  @dev                 this function can only be called once, nextbookkeeper of rawHeader can't be empty
83     *  @param rawHeader     Poly chain genesis block raw header or raw Header including switching consensus peers info
84     *  @return              true or false
85     */
86     function initGenesisBlock(bytes memory rawHeader, bytes memory pubKeyList) whenNotPaused public returns(bool) {
87         // Load Ethereum cross chain data contract
88         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
89         
90         // Make sure the contract has not been initialized before
91         require(eccd.getCurEpochConPubKeyBytes().length == 0, "EthCrossChainData contract has already been initialized!");
92         
93         // Parse header and convit the public keys into nextBookKeeper and compare it with header.nextBookKeeper to verify the validity of signature
94         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
95         (bytes20 nextBookKeeper, address[] memory keepers) = ECCUtils.verifyPubkey(pubKeyList);
96         require(header.nextBookkeeper == nextBookKeeper, "NextBookers illegal");
97         
98         // Record current epoch start height and public keys (by storing them in address format)
99         require(eccd.putCurEpochStartHeight(header.height), "Save Poly chain current epoch start height to Data contract failed!");
100         require(eccd.putCurEpochConPubKeyBytes(ECCUtils.serializeKeepers(keepers)), "Save Poly chain current epoch book keepers to Data contract failed!");
101         
102         // Fire the event
103         emit InitGenesisBlockEvent(header.height, rawHeader);
104         return true;
105     }
106     
107     /* @notice              change Poly chain consensus book keeper
108     *  @param rawHeader     Poly chain change book keeper block raw header
109     *  @param pubKeyList    Poly chain consensus nodes public key list
110     *  @param sigList       Poly chain consensus nodes signature list
111     *  @return              true or false
112     */
113     function changeBookKeeper(bytes memory rawHeader, bytes memory pubKeyList, bytes memory sigList) whenNotPaused public returns(bool) {
114         // Load Ethereum cross chain data contract
115         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
116         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
117         
118         // Make sure rawHeader.height is higher than recorded current epoch start height
119         uint64 curEpochStartHeight = eccd.getCurEpochStartHeight();
120         require(header.height > curEpochStartHeight, "The height of header is lower than current epoch start height!");
121         
122         // Ensure the rawHeader is the key header including info of switching consensus peers by containing non-empty nextBookKeeper field
123         require(header.nextBookkeeper != bytes20(0), "The nextBookKeeper of header is empty");
124         
125         // Verify signature of rawHeader comes from pubKeyList
126         address[] memory polyChainBKs = ECCUtils.deserializeKeepers(eccd.getCurEpochConPubKeyBytes());
127         uint n = polyChainBKs.length;
128         require(ECCUtils.verifySig(rawHeader, sigList, polyChainBKs, n - (n - 1) / 3), "Verify signature failed!");
129         
130         // Convert pubKeyList into ethereum address format and make sure the compound address from the converted ethereum addresses
131         // equals passed in header.nextBooker
132         (bytes20 nextBookKeeper, address[] memory keepers) = ECCUtils.verifyPubkey(pubKeyList);
133         require(header.nextBookkeeper == nextBookKeeper, "NextBookers illegal");
134         
135         // update current epoch start height of Poly chain and current epoch consensus peers book keepers addresses
136         require(eccd.putCurEpochStartHeight(header.height), "Save MC LatestHeight to Data contract failed!");
137         require(eccd.putCurEpochConPubKeyBytes(ECCUtils.serializeKeepers(keepers)), "Save Poly chain book keepers bytes to Data contract failed!");
138         
139         // Fire the change book keeper event
140         emit ChangeBookKeeperEvent(header.height, rawHeader);
141         return true;
142     }
143 
144 
145     /* @notice              ERC20 token cross chain to other blockchain.
146     *                       this function push tx event to blockchain
147     *  @param toChainId     Target chain id
148     *  @param toContract    Target smart contract address in target block chain
149     *  @param txData        Transaction data for target chain, include to_address, amount
150     *  @return              true or false
151     */
152     function crossChain(uint64 toChainId, bytes calldata toContract, bytes calldata method, bytes calldata txData) whenNotPaused external returns (bool) {
153         // Only allow whitelist contract to call
154         require(whiteListFromContract[msg.sender],"Invalid from contract");
155         
156         // Load Ethereum cross chain data contract
157         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
158         
159         // To help differentiate two txs, the ethTxHashIndex is increasing automatically
160         uint256 txHashIndex = eccd.getEthTxHashIndex();
161         
162         // Convert the uint256 into bytes
163         bytes memory paramTxHash = Utils.uint256ToBytes(txHashIndex);
164         
165         // Construct the makeTxParam, and put the hash info storage, to help provide proof of tx existence
166         bytes memory rawParam = abi.encodePacked(ZeroCopySink.WriteVarBytes(paramTxHash),
167             ZeroCopySink.WriteVarBytes(abi.encodePacked(sha256(abi.encodePacked(address(this), paramTxHash)))),
168             ZeroCopySink.WriteVarBytes(Utils.addressToBytes(msg.sender)),
169             ZeroCopySink.WriteUint64(toChainId),
170             ZeroCopySink.WriteVarBytes(toContract),
171             ZeroCopySink.WriteVarBytes(method),
172             ZeroCopySink.WriteVarBytes(txData)
173         );
174         
175         // Must save it in the storage to be included in the proof to be verified.
176         require(eccd.putEthTxHash(keccak256(rawParam)), "Save ethTxHash by index to Data contract failed!");
177         
178         // Fire the cross chain event denoting there is a cross chain request from Ethereum network to other public chains through Poly chain network
179         emit CrossChainEvent(tx.origin, paramTxHash, msg.sender, toChainId, toContract, rawParam);
180         return true;
181     }
182     /* @notice              Verify Poly chain header and proof, execute the cross chain tx from Poly chain to Ethereum
183     *  @param proof         Poly chain tx merkle proof
184     *  @param rawHeader     The header containing crossStateRoot to verify the above tx merkle proof
185     *  @param headerProof   The header merkle proof used to verify rawHeader
186     *  @param curRawHeader  Any header in current epoch consensus of Poly chain
187     *  @param headerSig     The coverted signature veriable for solidity derived from Poly chain consensus nodes' signature
188     *                       used to verify the validity of curRawHeader
189     *  @return              true or false
190     */
191     function verifyHeaderAndExecuteTx(bytes memory proof, bytes memory rawHeader, bytes memory headerProof, bytes memory curRawHeader,bytes memory headerSig) whenNotPaused public returns (bool){
192         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
193         // Load ehereum cross chain data contract
194         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
195         
196         // Get stored consensus public key bytes of current poly chain epoch and deserialize Poly chain consensus public key bytes to address[]
197         address[] memory polyChainBKs = ECCUtils.deserializeKeepers(eccd.getCurEpochConPubKeyBytes());
198 
199         uint256 curEpochStartHeight = eccd.getCurEpochStartHeight();
200 
201         uint n = polyChainBKs.length;
202         if (header.height >= curEpochStartHeight) {
203             // It's enough to verify rawHeader signature
204             require(ECCUtils.verifySig(rawHeader, headerSig, polyChainBKs, n - ( n - 1) / 3), "Verify poly chain header signature failed!");
205         } else {
206             // We need to verify the signature of curHeader 
207             require(ECCUtils.verifySig(curRawHeader, headerSig, polyChainBKs, n - ( n - 1) / 3), "Verify poly chain current epoch header signature failed!");
208 
209             // Then use curHeader.StateRoot and headerProof to verify rawHeader.CrossStateRoot
210             ECCUtils.Header memory curHeader = ECCUtils.deserializeHeader(curRawHeader);
211             bytes memory proveValue = ECCUtils.merkleProve(headerProof, curHeader.blockRoot);
212             require(ECCUtils.getHeaderHash(rawHeader) == Utils.bytesToBytes32(proveValue), "verify header proof failed!");
213         }
214         
215         // Through rawHeader.CrossStatesRoot, the toMerkleValue or cross chain msg can be verified and parsed from proof
216         bytes memory toMerkleValueBs = ECCUtils.merkleProve(proof, header.crossStatesRoot);
217         
218         // Parse the toMerkleValue struct and make sure the tx has not been processed, then mark this tx as processed
219         ECCUtils.ToMerkleValue memory toMerkleValue = ECCUtils.deserializeMerkleValue(toMerkleValueBs);
220         require(!eccd.checkIfFromChainTxExist(toMerkleValue.fromChainID, Utils.bytesToBytes32(toMerkleValue.txHash)), "the transaction has been executed!");
221         require(eccd.markFromChainTxExist(toMerkleValue.fromChainID, Utils.bytesToBytes32(toMerkleValue.txHash)), "Save crosschain tx exist failed!");
222         
223         // Ethereum ChainId is 2, we need to check the transaction is for Ethereum network
224         require(toMerkleValue.makeTxParam.toChainId == chainId, "This Tx is not aiming at this network!");
225         
226         // Obtain the targeting contract, so that Ethereum cross chain manager contract can trigger the executation of cross chain tx on Ethereum side
227         address toContract = Utils.bytesToAddress(toMerkleValue.makeTxParam.toContract);
228         
229         // only invoke PreWhiteListed Contract and method For Now
230         require(whiteListContractMethodMap[toContract][toMerkleValue.makeTxParam.method],"Invalid to contract or method");
231 
232         //TODO: check this part to make sure we commit the next line when doing local net UT test
233         require(_executeCrossChainTx(toContract, toMerkleValue.makeTxParam.method, toMerkleValue.makeTxParam.args, toMerkleValue.makeTxParam.fromContract, toMerkleValue.fromChainID), "Execute CrossChain Tx failed!");
234 
235         // Fire the cross chain event denoting the executation of cross chain tx is successful,
236         // and this tx is coming from other public chains to current Ethereum network
237         emit VerifyHeaderAndExecuteTxEvent(toMerkleValue.fromChainID, toMerkleValue.makeTxParam.toContract, toMerkleValue.txHash, toMerkleValue.makeTxParam.txHash);
238 
239         return true;
240     }
241     
242     /* @notice                  Dynamically invoke the targeting contract, and trigger executation of cross chain tx on Ethereum side
243     *  @param _toContract       The targeting contract that will be invoked by the Ethereum Cross Chain Manager contract
244     *  @param _method           At which method will be invoked within the targeting contract
245     *  @param _args             The parameter that will be passed into the targeting contract
246     *  @param _fromContractAddr From chain smart contract address
247     *  @param _fromChainId      Indicate from which chain current cross chain tx comes 
248     *  @return                  true or false
249     */
250     function _executeCrossChainTx(address _toContract, bytes memory _method, bytes memory _args, bytes memory _fromContractAddr, uint64 _fromChainId) internal returns (bool){
251         // Ensure the targeting contract gonna be invoked is indeed a contract rather than a normal account address
252         require(Utils.isContract(_toContract), "The passed in address is not a contract!");
253         bytes memory returnData;
254         bool success;
255         
256         // The returnData will be bytes32, the last byte must be 01;
257         (success, returnData) = _toContract.call(abi.encodePacked(bytes4(keccak256(abi.encodePacked(_method, "(bytes,bytes,uint64)"))), abi.encode(_args, _fromContractAddr, _fromChainId)));
258         
259         // Ensure the executation is successful
260         require(success == true, "EthCrossChain call business contract failed");
261         
262         // Ensure the returned value is true
263         require(returnData.length != 0, "No return value from business contract!");
264         (bool res,) = ZeroCopySource.NextBool(returnData, 31);
265         require(res == true, "EthCrossChain call business contract return is not true");
266         
267         return true;
268     }
269 }