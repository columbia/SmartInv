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
11 contract EthCrossChainManagerForUpgrade is IEthCrossChainManager, UpgradableECCM {
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
23 
24     function crossChain(uint64 toChainId, bytes calldata toContract, bytes calldata method, bytes calldata txData) whenNotPaused external returns (bool) {
25         revert("Polynetwork v1.0 has been suspended, try v2.0.");
26         return true;
27     }
28     
29     /* @notice              Verify Poly chain header and proof, execute the cross chain tx from Poly chain to Ethereum
30     *  @param proof         Poly chain tx merkle proof
31     *  @param rawHeader     The header containing crossStateRoot to verify the above tx merkle proof
32     *  @param headerProof   The header merkle proof used to verify rawHeader
33     *  @param curRawHeader  Any header in current epoch consensus of Poly chain
34     *  @param headerSig     The coverted signature veriable for solidity derived from Poly chain consensus nodes' signature
35     *                       used to verify the validity of curRawHeader
36     *  @return              true or false
37     */
38     function verifyHeaderAndExecuteTx(bytes memory proof, bytes memory rawHeader, bytes memory headerProof, bytes memory curRawHeader,bytes memory headerSig) whenNotPaused public returns (bool){
39         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
40         // Load ehereum cross chain data contract
41         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
42         
43         // Get stored consensus public key bytes of current poly chain epoch and deserialize Poly chain consensus public key bytes to address[]
44         address[] memory polyChainBKs = ECCUtils.deserializeKeepers(eccd.getCurEpochConPubKeyBytes());
45 
46         uint256 curEpochStartHeight = eccd.getCurEpochStartHeight();
47 
48         uint n = polyChainBKs.length;
49         if (header.height >= curEpochStartHeight) {
50             // It's enough to verify rawHeader signature
51             require(ECCUtils.verifySig(rawHeader, headerSig, polyChainBKs, n - ( n - 1) / 3), "Verify poly chain header signature failed!");
52         } else {
53             // We need to verify the signature of curHeader 
54             require(ECCUtils.verifySig(curRawHeader, headerSig, polyChainBKs, n - ( n - 1) / 3), "Verify poly chain current epoch header signature failed!");
55 
56             // Then use curHeader.StateRoot and headerProof to verify rawHeader.CrossStateRoot
57             ECCUtils.Header memory curHeader = ECCUtils.deserializeHeader(curRawHeader);
58             bytes memory proveValue = ECCUtils.merkleProve(headerProof, curHeader.blockRoot);
59             require(ECCUtils.getHeaderHash(rawHeader) == Utils.bytesToBytes32(proveValue), "verify header proof failed!");
60         }
61         
62         // Through rawHeader.CrossStatesRoot, the toMerkleValue or cross chain msg can be verified and parsed from proof
63         bytes memory toMerkleValueBs = ECCUtils.merkleProve(proof, header.crossStatesRoot);
64         
65         // Parse the toMerkleValue struct and make sure the tx has not been processed, then mark this tx as processed
66         ECCUtils.ToMerkleValue memory toMerkleValue = ECCUtils.deserializeMerkleValue(toMerkleValueBs);
67         require(!eccd.checkIfFromChainTxExist(toMerkleValue.fromChainID, Utils.bytesToBytes32(toMerkleValue.txHash)), "the transaction has been executed!");
68         require(eccd.markFromChainTxExist(toMerkleValue.fromChainID, Utils.bytesToBytes32(toMerkleValue.txHash)), "Save crosschain tx exist failed!");
69         
70         // Ethereum ChainId is 2, we need to check the transaction is for Ethereum network
71         require(toMerkleValue.makeTxParam.toChainId == chainId, "This Tx is not aiming at this network!");
72         
73         // Obtain the targeting contract, so that Ethereum cross chain manager contract can trigger the executation of cross chain tx on Ethereum side
74         address toContract = Utils.bytesToAddress(toMerkleValue.makeTxParam.toContract);
75         require(toContract != EthCrossChainDataAddress, "No eccd here!");
76 
77         //TODO: check this part to make sure we commit the next line when doing local net UT test
78         require(_executeCrossChainTx(toContract, toMerkleValue.makeTxParam.method, toMerkleValue.makeTxParam.args, toMerkleValue.makeTxParam.fromContract, toMerkleValue.fromChainID), "Execute CrossChain Tx failed!");
79 
80         // Fire the cross chain event denoting the executation of cross chain tx is successful,
81         // and this tx is coming from other public chains to current Ethereum network
82         emit VerifyHeaderAndExecuteTxEvent(toMerkleValue.fromChainID, toMerkleValue.makeTxParam.toContract, toMerkleValue.txHash, toMerkleValue.makeTxParam.txHash);
83 
84         return true;
85     }
86     
87     /* @notice                  Dynamically invoke the targeting contract, and trigger executation of cross chain tx on Ethereum side
88     *  @param _toContract       The targeting contract that will be invoked by the Ethereum Cross Chain Manager contract
89     *  @param _method           At which method will be invoked within the targeting contract
90     *  @param _args             The parameter that will be passed into the targeting contract
91     *  @param _fromContractAddr From chain smart contract address
92     *  @param _fromChainId      Indicate from which chain current cross chain tx comes 
93     *  @return                  true or false
94     */
95     function _executeCrossChainTx(address _toContract, bytes memory _method, bytes memory _args, bytes memory _fromContractAddr, uint64 _fromChainId) internal returns (bool){
96         // Ensure the targeting contract gonna be invoked is indeed a contract rather than a normal account address
97         require(Utils.isContract(_toContract), "The passed in address is not a contract!");
98         bytes memory returnData;
99         bool success;
100         
101         // The returnData will be bytes32, the last byte must be 01;
102         (success, returnData) = _toContract.call(abi.encodePacked(bytes4(keccak256(abi.encodePacked(_method, "(bytes,bytes,uint64)"))), abi.encode(_args, _fromContractAddr, _fromChainId)));
103         
104         // Ensure the executation is successful
105         require(success == true, "EthCrossChain call business contract failed");
106         
107         // Ensure the returned value is true
108         require(returnData.length != 0, "No return value from business contract!");
109         (bool res,) = ZeroCopySource.NextBool(returnData, 31);
110         require(res == true, "EthCrossChain call business contract return is not true");
111         
112         return true;
113     }
114 }