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
36 contract RippleLockProxy is Ownable {
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
48     uint public rippleMinAmount = 30000000;
49     uint64 public rippleChainId = 39;
50     uint public rippleAddressLength = 20;
51 
52     event SetManagerProxyEvent(address manager);
53     event BindProxyEvent(uint64 toChainId, bytes targetProxyHash);
54     event UnlockEvent(address toAssetHash, address toAddress, uint256 amount);
55     event LockEvent(address fromAssetHash, address fromAddress, uint64 toChainId, bytes toAssetHash, bytes toAddress, uint256 amount);
56     
57     constructor(string memory name, string memory symbol, uint8 decimals) public {
58         token = new bridgeAsset(name, symbol, decimals, address(this));
59     }
60 
61     modifier onlyManagerContract() {
62         IEthCrossChainManagerProxy ieccmp = IEthCrossChainManagerProxy(managerProxyContract);
63         require(_msgSender() == ieccmp.getEthCrossChainManager(), "msgSender is not EthCrossChainManagerContract");
64         _;
65     }
66     
67     function setManagerProxy(address ethCCMProxyAddr) onlyOwner public {
68         managerProxyContract = ethCCMProxyAddr;
69         emit SetManagerProxyEvent(managerProxyContract);
70     }
71     
72     function bindProxyHash(uint64 toChainId, bytes memory targetProxyHash) onlyOwner public returns (bool) {
73         proxyHashMap[toChainId] = targetProxyHash;
74         emit BindProxyEvent(toChainId, targetProxyHash);
75         return true;
76     }
77 
78     function rippleSetup(uint64 _rippleChainId, uint _rippleMinAmount, uint _rippleAddressLength) external onlyOwner {
79         rippleChainId = _rippleChainId;
80         rippleAddressLength = _rippleAddressLength;
81         rippleMinAmount = _rippleMinAmount;
82     }
83 
84     function rippleSetup(uint64 _rippleChainId) external onlyOwner {
85         rippleChainId = _rippleChainId;
86     }
87     
88     /* @notice                  This function is meant to be invoked by the user,
89     *                           a certin amount teokens will be locked in the proxy contract the invoker/msg.sender immediately.
90     *                           Then the same amount of tokens will be unloked from target chain proxy contract at the target chain with chainId later.
91     *  @param fromAssetHash     The asset address in current chain, uniformly named as `fromAssetHash`
92     *  @param toChainId         The target chain id
93     *                           
94     *  @param toAddress         The address in bytes format to receive same amount of tokens in target chain 
95     *  @param amount            The amount of tokens to be crossed from ethereum to the chain with chainId
96     */
97     function lock(uint64 toChainId, bytes memory toAddress, uint256 amount) public payable returns (bool) {
98         _rippleCheck(toChainId, toAddress, amount);
99         require(amount != 0, "amount cannot be zero!");
100         
101         bridgeAsset(token).burnFrom(_msgSender(), amount);
102 
103         TxArgs memory txArgs = TxArgs({
104             toAddress: toAddress,
105             amount: amount
106         });
107         bytes memory txData = _serializeTxArgs(txArgs);
108         
109         IEthCrossChainManagerProxy eccmp = IEthCrossChainManagerProxy(managerProxyContract);
110         address eccmAddr = eccmp.getEthCrossChainManager();
111         IEthCrossChainManager eccm = IEthCrossChainManager(eccmAddr);
112         
113         bytes memory toProxyHash = proxyHashMap[toChainId];
114         require(toProxyHash.length != 0, "empty illegal toProxyHash");
115         require(eccm.crossChain(toChainId, toProxyHash, "unlock", txData), "EthCrossChainManager crossChain executed error!");
116 
117         emit LockEvent(address(token), _msgSender(), toChainId, toProxyHash, toAddress, amount);
118         
119         return true;
120 
121     }
122     
123     // /* @notice                  This function is meant to be invoked by the ETH crosschain management contract,
124     // *                           then mint a certin amount of tokens to the designated address since a certain amount 
125     // *                           was burnt from the source chain invoker.
126     // *  @param argsBs            The argument bytes recevied by the ethereum lock proxy contract, need to be deserialized.
127     // *                           based on the way of serialization in the source chain proxy contract.
128     // *  @param fromContractAddr  The source chain contract address
129     // *  @param fromChainId       The source chain id
130     // */
131     function unlock(bytes memory argsBs, bytes memory fromContractAddr, uint64 fromChainId) onlyManagerContract public returns (bool) {
132         TxArgs memory args = _deserializeTxArgs(argsBs);
133 
134         require(fromContractAddr.length != 0, "from proxy contract address cannot be empty");
135         require(Utils.equalStorage(proxyHashMap[fromChainId], fromContractAddr), "From Proxy contract address error!");
136 
137         require(args.toAddress.length != 0, "toAddress cannot be empty");
138         address toAddress = Utils.bytesToAddress(args.toAddress);
139         
140         bridgeAsset(token).mint(toAddress, args.amount);
141         
142         emit UnlockEvent(address(token), toAddress, args.amount);
143         return true;
144     }
145     
146     function _rippleCheck(uint64 toChainId, bytes memory toAddress, uint amount) internal view {
147         if (toChainId == rippleChainId) {
148             require(toAddress.length == rippleAddressLength, "invalid ripple address");
149             require(amount >= rippleMinAmount, "amount less than the minimum");
150         }
151     }
152     
153     function _serializeTxArgs(TxArgs memory args) internal pure returns (bytes memory) {
154         bytes memory buff;
155         buff = abi.encodePacked(
156             ZeroCopySink.WriteVarBytes(args.toAddress),
157             ZeroCopySink.WriteUint255(args.amount)
158             );
159         return buff;
160     }
161 
162     function _deserializeTxArgs(bytes memory valueBs) internal pure returns (TxArgs memory) {
163         TxArgs memory args;
164         uint256 off = 0;
165         (args.toAddress, off) = ZeroCopySource.NextVarBytes(valueBs, off);
166         (args.amount, off) = ZeroCopySource.NextUint255(valueBs, off);
167         return args;
168     }
169 }