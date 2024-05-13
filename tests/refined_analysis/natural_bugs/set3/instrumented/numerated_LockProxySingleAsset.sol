1 pragma solidity ^0.5.0;
2 
3 import "./../../libs/ownership/Ownable.sol";
4 import "./../../libs/common/ZeroCopySource.sol";
5 import "./../../libs/common/ZeroCopySink.sol";
6 import "./../../libs/utils/Utils.sol";
7 import "./../../libs/token/ERC20/SafeERC20.sol";
8 import "./../../libs/token/ERC20/ERC20.sol";
9 import "./../../libs/token/ERC20/ERC20Detailed.sol";
10 import "./../cross_chain_manager/interface/IEthCrossChainManager.sol";
11 import "./../cross_chain_manager/interface/IEthCrossChainManagerProxy.sol";
12 
13 contract bridgeAsset is Context, ERC20, ERC20Detailed {
14 
15     address public bridge;
16 
17     constructor (string memory name, string memory symbol, uint8 decimals, address bridge_) 
18     public ERC20Detailed(name, symbol, decimals) {
19         bridge = bridge_;
20     }
21 
22     modifier onlyBridge() {
23         require(_msgSender() == bridge, "msgSender is not Bridge!");
24         _;
25     }
26 
27     function mint(address to, uint256 amount) public onlyBridge {
28         _mint(to, amount);
29     }
30     
31     function burnFrom(address account, uint256 amount) public onlyBridge {
32         _burnFrom(account, amount);
33     }
34 }
35 
36 contract LockProxySingleAsset is Ownable {
37     using SafeMath for uint;
38     using SafeERC20 for IERC20;
39 
40     struct TxArgs {
41         bytes toAddress;
42         uint256 amount;
43     }
44     bridgeAsset public token;
45     address public managerProxyContract;
46     mapping(uint64 => bytes) public proxyHashMap;
47 
48     event SetManagerProxyEvent(address manager);
49     event BindProxyEvent(uint64 toChainId, bytes targetProxyHash);
50     event UnlockEvent(address toAssetHash, address toAddress, uint256 amount);
51     event LockEvent(address fromAssetHash, address fromAddress, uint64 toChainId, bytes toAssetHash, bytes toAddress, uint256 amount);
52     
53     constructor(string memory name, string memory symbol, uint8 decimals) public {
54         token = new bridgeAsset(name, symbol, decimals, address(this));
55     }
56 
57     modifier onlyManagerContract() {
58         IEthCrossChainManagerProxy ieccmp = IEthCrossChainManagerProxy(managerProxyContract);
59         require(_msgSender() == ieccmp.getEthCrossChainManager(), "msgSender is not EthCrossChainManagerContract");
60         _;
61     }
62     
63     function setManagerProxy(address ethCCMProxyAddr) onlyOwner public {
64         managerProxyContract = ethCCMProxyAddr;
65         emit SetManagerProxyEvent(managerProxyContract);
66     }
67     
68     function bindProxyHash(uint64 toChainId, bytes memory targetProxyHash) onlyOwner public returns (bool) {
69         proxyHashMap[toChainId] = targetProxyHash;
70         emit BindProxyEvent(toChainId, targetProxyHash);
71         return true;
72     }
73     
74     /* @notice                  This function is meant to be invoked by the user,
75     *                           a certin amount teokens will be locked in the proxy contract the invoker/msg.sender immediately.
76     *                           Then the same amount of tokens will be unloked from target chain proxy contract at the target chain with chainId later.
77     *  @param fromAssetHash     The asset address in current chain, uniformly named as `fromAssetHash`
78     *  @param toChainId         The target chain id
79     *                           
80     *  @param toAddress         The address in bytes format to receive same amount of tokens in target chain 
81     *  @param amount            The amount of tokens to be crossed from ethereum to the chain with chainId
82     */
83     function lock(uint64 toChainId, bytes memory toAddress, uint256 amount) public payable returns (bool) {
84         require(amount != 0, "amount cannot be zero!");
85         
86         bridgeAsset(token).burnFrom(_msgSender(), amount);
87 
88         TxArgs memory txArgs = TxArgs({
89             toAddress: toAddress,
90             amount: amount
91         });
92         bytes memory txData = _serializeTxArgs(txArgs);
93         
94         IEthCrossChainManagerProxy eccmp = IEthCrossChainManagerProxy(managerProxyContract);
95         address eccmAddr = eccmp.getEthCrossChainManager();
96         IEthCrossChainManager eccm = IEthCrossChainManager(eccmAddr);
97         
98         bytes memory toProxyHash = proxyHashMap[toChainId];
99         require(toProxyHash.length != 0, "empty illegal toProxyHash");
100         require(eccm.crossChain(toChainId, toProxyHash, "unlock", txData), "EthCrossChainManager crossChain executed error!");
101 
102         emit LockEvent(address(token), _msgSender(), toChainId, toProxyHash, toAddress, amount);
103         
104         return true;
105 
106     }
107     
108     // /* @notice                  This function is meant to be invoked by the ETH crosschain management contract,
109     // *                           then mint a certin amount of tokens to the designated address since a certain amount 
110     // *                           was burnt from the source chain invoker.
111     // *  @param argsBs            The argument bytes recevied by the ethereum lock proxy contract, need to be deserialized.
112     // *                           based on the way of serialization in the source chain proxy contract.
113     // *  @param fromContractAddr  The source chain contract address
114     // *  @param fromChainId       The source chain id
115     // */
116     function unlock(bytes memory argsBs, bytes memory fromContractAddr, uint64 fromChainId) onlyManagerContract public returns (bool) {
117         TxArgs memory args = _deserializeTxArgs(argsBs);
118 
119         require(fromContractAddr.length != 0, "from proxy contract address cannot be empty");
120         require(Utils.equalStorage(proxyHashMap[fromChainId], fromContractAddr), "From Proxy contract address error!");
121 
122         require(args.toAddress.length != 0, "toAddress cannot be empty");
123         address toAddress = Utils.bytesToAddress(args.toAddress);
124         
125         bridgeAsset(token).mint(toAddress, args.amount);
126         
127         emit UnlockEvent(address(token), toAddress, args.amount);
128         return true;
129     }
130     
131     function _serializeTxArgs(TxArgs memory args) internal pure returns (bytes memory) {
132         bytes memory buff;
133         buff = abi.encodePacked(
134             ZeroCopySink.WriteVarBytes(args.toAddress),
135             ZeroCopySink.WriteUint255(args.amount)
136             );
137         return buff;
138     }
139 
140     function _deserializeTxArgs(bytes memory valueBs) internal pure returns (TxArgs memory) {
141         TxArgs memory args;
142         uint256 off = 0;
143         (args.toAddress, off) = ZeroCopySource.NextVarBytes(valueBs, off);
144         (args.amount, off) = ZeroCopySource.NextUint255(valueBs, off);
145         return args;
146     }
147 }