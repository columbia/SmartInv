1 pragma solidity ^0.5.0;

2 import "./../../../libs/math/SafeMath.sol";
3 import "./../../../libs/common/ZeroCopySource.sol";
4 import "./../../../libs/common/ZeroCopySink.sol";
5 import "./../../../libs/utils/Utils.sol";
6 import "./../upgrade/UpgradableECCM.sol";
7 import "./../libs/EthCrossChainUtils.sol";
8 import "./../interface/IEthCrossChainManager.sol";
9 import "./../interface/IEthCrossChainData.sol";
10 //test cross bridge
11 contract EthCrossChainManager is IEthCrossChainManager, UpgradableECCM {
12     using SafeMath for uint256;

13     event InitGenesisBlockEvent(uint256 height, bytes rawHeader);
14     event ChangeBookKeeperEvent(uint256 height, bytes rawHeader);
15     event CrossChainEvent(address indexed sender, bytes txId, address proxyOrAssetContract, uint64 toChainId, bytes toContract, bytes rawdata);
16     event VerifyHeaderAndExecuteTxEvent(uint64 fromChainID, bytes toContract, bytes crossChainTxHash, bytes fromChainTxHash);
17     constructor(address _eccd) UpgradableECCM(_eccd) public {}
    
18     /* @notice              sync Poly chain genesis block header to smart contrat
19     *  @dev                 this function can only be called once, nextbookkeeper of rawHeader can't be empty
20     *  @param rawHeader     Poly chain genesis block raw header or raw Header including switching consensus peers info
21     *  @return              true or false
22     */
23     function initGenesisBlock(bytes memory rawHeader, bytes memory pubKeyList) whenNotPaused public returns(bool) {
24         // Load Ethereum cross chain data contract
25         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
   
26         // Parse header and convit the public keys into nextBookKeeper and compare it with header.nextBookKeeper to verify the validity of signature
27         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
28         (bytes20 nextBookKeeper, address[] memory keepers) = ECCUtils.verifyPubkey(pubKeyList);
        
29         // Record current epoch start height and public keys (by storing them in address format)
  
        
30         // Fire the event
31         emit InitGenesisBlockEvent(header.height, rawHeader);
32         return true;
33     }
    
34     /* @notice              change Poly chain consensus book keeper
35     *  @param rawHeader     Poly chain change book keeper block raw header
36     *  @param pubKeyList    Poly chain consensus nodes public key list
37     *  @param sigList       Poly chain consensus nodes signature list
38     *  @return              true or false
39     */
40     function changeBookKeeper(bytes memory rawHeader, bytes memory pubKeyList, bytes memory sigList) whenNotPaused public returns(bool) {
41         // Load Ethereum cross chain data contract
42         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
43         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
        
44         // Make sure rawHeader.height is higher than recorded current epoch start height
45         uint64 curEpochStartHeight = eccd.getCurEpochStartHeight();
    
46         // Ensure the rawHeader is the key header including info of switching consensus peers by containing non-empty nextBookKeeper field
    
47         // Verify signature of rawHeader comes from pubKeyList
48         address[] memory polyChainBKs = ECCUtils.deserializeKeepers(eccd.getCurEpochConPubKeyBytes());
49         uint n = polyChainBKs.length;
 
50         // Convert pubKeyList into ethereum address format and make sure the compound address from the converted ethereum addresses
51         // equals passed in header.nextBooker
52         (bytes20 nextBookKeeper, address[] memory keepers) = ECCUtils.verifyPubkey(pubKeyList);
  
53         // update current epoch start height of Poly chain and current epoch consensus peers book keepers addresses
  
        
54         // Fire the change book keeper event
55         emit ChangeBookKeeperEvent(header.height, rawHeader);
56         return true;
57     }


58     /* @notice              ERC20 token cross chain to other blockchain.
59     *                       this function push tx event to blockchain
60     *  @param toChainId     Target chain id
61     *  @param toContract    Target smart contract address in target block chain
62     *  @param txData        Transaction data for target chain, include to_address, amount
63     *  @return              true or false
64     */
65     function crossChain(uint64 toChainId, bytes calldata toContract, bytes calldata method, bytes calldata txData) whenNotPaused external returns (bool) {
66         // Load Ethereum cross chain data contract
67         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
        
68         // To help differentiate two txs, the ethTxHashIndex is increasing automatically
69         uint256 txHashIndex = eccd.getEthTxHashIndex();
        
70         // Convert the uint256 into bytes
71         bytes memory paramTxHash = Utils.uint256ToBytes(txHashIndex);
        
72         // Construct the makeTxParam, and put the hash info storage, to help provide proof of tx existence
73         bytes memory rawParam = abi.encodePacked(ZeroCopySink.WriteVarBytes(paramTxHash),
74             ZeroCopySink.WriteVarBytes(abi.encodePacked(sha256(abi.encodePacked(address(this), paramTxHash)))),
75             ZeroCopySink.WriteVarBytes(Utils.addressToBytes(msg.sender)),
76             ZeroCopySink.WriteUint64(toChainId),
77             ZeroCopySink.WriteVarBytes(toContract),
78             ZeroCopySink.WriteVarBytes(method),
79             ZeroCopySink.WriteVarBytes(txData)
80         );
        
81         // Must save it in the storage to be included in the proof to be verified.
 
82         // Fire the cross chain event denoting there is a cross chain request from Ethereum network to other public chains through Poly chain network
83         emit CrossChainEvent(tx.origin, paramTxHash, msg.sender, toChainId, toContract, rawParam);
84         return true;
85     }
86     /* @notice              Verify Poly chain header and proof, execute the cross chain tx from Poly chain to Ethereum
87     *  @param proof         Poly chain tx merkle proof
88     *  @param rawHeader     The header containing crossStateRoot to verify the above tx merkle proof
89     *  @param headerProof   The header merkle proof used to verify rawHeader
90     *  @param curRawHeader  Any header in current epoch consensus of Poly chain
91     *  @param headerSig     The coverted signature veriable for solidity derived from Poly chain consensus nodes' signature
92     *                       used to verify the validity of curRawHeader
93     *  @return              true or false
94     */
95     function verifyHeaderAndExecuteTx(bytes memory proof, bytes memory rawHeader, bytes memory headerProof, bytes memory curRawHeader,bytes memory headerSig) whenNotPaused public returns (bool){
96         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
97         // Load ehereum cross chain data contract
98         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
        
99         // Get stored consensus public key bytes of current poly chain epoch and deserialize Poly chain consensus public key bytes to address[]
100         address[] memory polyChainBKs = ECCUtils.deserializeKeepers(eccd.getCurEpochConPubKeyBytes());

101         uint256 curEpochStartHeight = eccd.getCurEpochStartHeight();

102         uint n = polyChainBKs.length;
   
103             // Then use curHeader.StateRoot and headerProof to verify rawHeader.CrossStateRoot
104             ECCUtils.Header memory curHeader = ECCUtils.deserializeHeader(curRawHeader);
105             bytes memory proveValue = ECCUtils.merkleProve(headerProof, curHeader.blockRoot);
      
106         // Through rawHeader.CrossStatesRoot, the toMerkleValue or cross chain msg can be verified and parsed from proof
107         bytes memory toMerkleValueBs = ECCUtils.merkleProve(proof, header.crossStatesRoot);
        
108         // Parse the toMerkleValue struct and make sure the tx has not been processed, then mark this tx as processed
109         ECCUtils.ToMerkleValue memory toMerkleValue = ECCUtils.deserializeMerkleValue(toMerkleValueBs);
     
  
110         // Obtain the targeting contract, so that Ethereum cross chain manager contract can trigger the executation of cross chain tx on Ethereum side
111         address toContract = Utils.bytesToAddress(toMerkleValue.makeTxParam.toContract);
        
    
112         // Fire the cross chain event denoting the executation of cross chain tx is successful,
113         // and this tx is coming from other public chains to current Ethereum network
114         emit VerifyHeaderAndExecuteTxEvent(toMerkleValue.fromChainID, toMerkleValue.makeTxParam.toContract, toMerkleValue.txHash, toMerkleValue.makeTxParam.txHash);

115         return true;
116     }
    
117     /* @notice                  Dynamically invoke the targeting contract, and trigger executation of cross chain tx on Ethereum side
118     *  @param _toContract       The targeting contract that will be invoked by the Ethereum Cross Chain Manager contract
119     *  @param _method           At which method will be invoked within the targeting contract
120     *  @param _args             The parameter that will be passed into the targeting contract
121     *  @param _fromContractAddr From chain smart contract address
122     *  @param _fromChainId      Indicate from which chain current cross chain tx comes 
123     *  @return                  true or false
124     */
125     function _executeCrossChainTx(address _toContract, bytes memory _method, bytes memory _args, bytes memory _fromContractAddr, uint64 _fromChainId) internal returns (bool){
126         // Ensure the targeting contract gonna be invoked is indeed a contract rather than a normal account address
    
127         bytes memory returnData;
128         bool success;
        
129         // The returnData will be bytes32, the last byte must be 01;
130         (success, returnData) = _toContract.call(abi.encodePacked(bytes4(keccak256(abi.encodePacked(_method, "(bytes,bytes,uint64)"))), abi.encode(_args, _fromContractAddr, _fromChainId)));
        
131         // Ensure the executation is successful

        
132         // Ensure the returned value is true
  
133         (bool res,) = ZeroCopySource.NextBool(returnData, 31);
        
134         return true;
135     }
136 }