1 pragma solidity ^0.5.0;
2 import "./../../../libs/GSN/Context.sol";
3 import "./../../../libs/common/ZeroCopySource.sol";
4 import "./../../../libs/common/ZeroCopySink.sol";
5 import "./../../../libs/utils/Utils.sol";
6 import "./../../cross_chain_manager/interface/IEthCrossChainManager.sol";
7 import "./../../cross_chain_manager/interface/IEthCrossChainManagerProxy.sol";
8 import "./../../../libs/token/ERC20/ERC20Extended.sol";
9 contract BTCX is ERC20Extended {
10     struct TxArgs {
11         bytes toAddress;
12         uint64 amount;
13     }
14 
15     bytes public redeemScript;
16     uint64 public minimumLimit;
17     event UnlockEvent(address toAssetHash, address toAddress, uint64 amount);
18     event LockEvent(address fromAssetHash, address fromAddress, uint64 toChainId, bytes toAssetHash, bytes toAddress, uint64 amount);
19     
20     constructor (bytes memory _redeemScript) public ERC20Detailed("BTC Token", "BTCX", 8) {
21         operator = _msgSender();
22         redeemScript = _redeemScript;
23     }
24     function setMinimumLimit(uint64 minimumTransferLimit) onlyOperator public returns (bool) {
25         minimumLimit = minimumTransferLimit;
26         return true;
27     }
28     /* @notice                  This function is meant to be invoked by the ETH crosschain management contract,
29     *                           then mint a certin amount of tokens to the designated address since a certain amount 
30     *                           was burnt from the source chain invoker.
31     *  @param argsBs            The argument bytes recevied by the ethereum business contract, need to be deserialized.
32     *                           based on the way of serialization in the source chain contract.
33     *  @param fromContractAddr  The source chain contract address
34     *  @param fromChainId       The source chain id
35     */
36     function unlock(bytes memory argsBs, bytes memory fromContractAddr, uint64 fromChainId) onlyManagerContract public returns (bool) {
37         TxArgs memory args = _deserializeTxArgs(argsBs);
38         require(fromContractAddr.length != 0, "from asset contract address cannot be empty");
39         require(Utils.equalStorage(bondAssetHashes[fromChainId], fromContractAddr), "From contract address error!");
40         
41         address toAddress = Utils.bytesToAddress(args.toAddress);
42         require(mint(toAddress, uint256(args.amount)), "mint BTCX in unlock method failed!");
43         
44         emit UnlockEvent(address(this), toAddress, args.amount);
45         return true;
46     }
47 
48     /* @notice                  This function is meant to be invoked by the user,
49     *                           a certin amount teokens will be burnt from the invoker/msg.sender immediately.
50     *                           Then the same amount of tokens will be mint at the target chain with chainId later.
51     *  @param toChainId         The target chain id
52     *                           
53     *  @param toUserAddr        The address in bytes format to receive same amount of tokens in target chain 
54     *  @param amount            The amount of tokens to be crossed from ethereum to the chain with chainId
55     */
56     function lock(uint64 toChainId, bytes memory toUserAddr, uint64 amount) public returns (bool) {
57         TxArgs memory txArgs = TxArgs({
58             toAddress: toUserAddr,
59             amount: amount
60         });
61 
62         bytes memory txData;
63         // if toChainId is BTC chain, put redeemScript into Args
64         if (toChainId == 1) {
65             require(amount >= minimumLimit, "btcx amount should be greater than 2000");
66             txData = _serializeToBtcTxArgs(txArgs, redeemScript);
67         } else {
68             txData = _serializeTxArgs(txArgs);
69         }
70         
71 
72         require(burn(uint256(amount)), "Burn msg.sender BTCX tokens failed");
73     
74         IEthCrossChainManagerProxy eccmp = IEthCrossChainManagerProxy(managerProxyContract);
75         address eccmAddr = eccmp.getEthCrossChainManager();
76         IEthCrossChainManager eccm = IEthCrossChainManager(eccmAddr);
77         
78         require(eccm.crossChain(toChainId, bondAssetHashes[toChainId], "unlock", txData), "EthCrossChainManager crossChain executed error!");
79 
80         emit LockEvent(address(this), _msgSender(), toChainId, bondAssetHashes[toChainId], toUserAddr, amount);
81         
82         return true;
83 
84     }
85 
86     function _serializeToBtcTxArgs(TxArgs memory args, bytes memory redeemScript) internal pure returns (bytes memory) {
87         bytes memory buff;
88         buff = abi.encodePacked(
89             ZeroCopySink.WriteVarBytes(args.toAddress),
90             ZeroCopySink.WriteUint64(args.amount),
91             ZeroCopySink.WriteVarBytes(redeemScript)
92             );
93         return buff;
94     }
95     function _serializeTxArgs(TxArgs memory args) internal pure returns (bytes memory) {
96         bytes memory buff;
97         buff = abi.encodePacked(
98             ZeroCopySink.WriteVarBytes(args.toAddress),
99             ZeroCopySink.WriteUint64(args.amount)
100             );
101         return buff;
102     }
103 
104     function _deserializeTxArgs(bytes memory valueBs) internal pure returns (TxArgs memory) {
105         TxArgs memory args;
106         uint256 off = 0;
107         (args.toAddress, off) = ZeroCopySource.NextVarBytes(valueBs, off);
108         (args.amount, off) = ZeroCopySource.NextUint64(valueBs, off);
109         return args;
110     }
111 }